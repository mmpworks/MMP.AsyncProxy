using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;

namespace MMP.AsyncProxy.Fuzz
{
    /// <summary>
    /// A random async method: a list of steps, each one a future that is already done, or
    /// settles later from another thread, or is a delay, or is a nested WhenAll, or is an
    /// Observe of a failing step, with an optional finally that throws. The expected outcome
    /// is computed from the step list before the program runs.
    ///
    /// Invariants: the future settles; its status is the expected one; the result is the
    /// value the body set; a body that faulted never runs a step past the fault; a throwing
    /// finally faults the method and never leaves it pending.
    /// </summary>
    public sealed class IteratorPrograms : IGenerator
    {
        public string Name => "iterator";

        private enum Kind { Done, DoneFault, DoneCancel, Later, LaterFault, LaterCancel, Delay, ObserveFault, Nested }

        private sealed class Step
        {
            public Kind Kind;
            public Promise<int> Promise;        // for Later*
            public List<Step> Children;         // for Nested
        }

        public void Round(Random rng)
        {
            var steps = new List<Step>();
            int count = rng.Next(1, 9);
            for (int i = 0; i < count; i++) steps.Add(MakeStep(rng, 0));
            bool throwInFinally = rng.Next(5) == 0;
            int answer = rng.Next(1000);

            int stepsRun = 0;
            int lastStep = -1;
            IFuture<int> future = AsyncProxy.Run<int>(ret => Body(steps, answer, throwInFinally, ret, s => { stepsRun++; lastStep = s; }));

            // Settle the Later* steps from other threads, in random order, with jitter.
            var settlers = Flatten(steps).Where(s => s.Promise != null).Select<Step, Action>(s => () =>
            {
                Fuzzer.Jitter(rng, 2000);
                switch (s.Kind)
                {
                    case Kind.Later: s.Promise.TrySetResult(1); break;
                    case Kind.LaterFault: s.Promise.TrySetException(new ApplicationException("later fault")); break;
                    default: s.Promise.TrySetCanceled(); break;
                }
            }).ToList();
            Fuzzer.InParallel(settlers);

            Fuzzer.MustSettle(future, "the iterator program");

            // Expected: the first step that faults or cancels (as seen by the body) ends the method there.
            int firstBad = -1;
            FutureStatus expected = FutureStatus.Succeeded;
            for (int i = 0; i < steps.Count; i++)
            {
                FutureStatus s = Effective(steps[i]);
                if (s != FutureStatus.Succeeded) { firstBad = i; expected = s; break; }
            }
            // A throwing finally on the happy path is the method's fault. When a step already
            // ended the method, the step's outcome wins and the cleanup fault rides on it
            // (AsyncProxy.DisposeFaultKey). This differs from the C# compiler, where the
            // finally's exception replaces the in-flight one; README known limit 5 says so.
            if (throwInFinally && firstBad < 0) expected = FutureStatus.Faulted;

            if (future.Status != expected)
                throw new Exception("status " + future.Status + ", expected " + expected + " for " + Describe(steps) + (throwInFinally ? " + throwing finally" : ""));
            if (expected == FutureStatus.Succeeded && future.Result != answer)
                throw new Exception("result " + future.Result + ", expected " + answer);
            int expectedRun = firstBad < 0 ? steps.Count : firstBad + 1;
            if (stepsRun != expectedRun)
                throw new Exception("body yielded " + stepsRun + " steps, expected " + expectedRun + " for " + Describe(steps));
            if (throwInFinally && firstBad < 0 && !(future.Exception is ApplicationException && future.Exception.Message == "cleanup"))
                throw new Exception("a throwing finally on the happy path should be the method's fault; got " + future.Exception);
            if (throwInFinally && firstBad >= 0 && Effective(steps[firstBad]) == FutureStatus.Faulted && future.Exception.Message == "cleanup")
                throw new Exception("the step's fault should win over the finally's");
        }

        private static IEnumerable<IFuture> Body(List<Step> steps, int answer, bool throwInFinally, Return<int> ret, Action<int> ran)
        {
            try
            {
                for (int i = 0; i < steps.Count; i++)
                {
                    ran(i);
                    yield return Build(steps[i]);
                }
                ret.Value = answer;
            }
            finally
            {
                if (throwInFinally) throw new ApplicationException("cleanup");
            }
        }

        private static IFuture Build(Step s)
        {
            switch (s.Kind)
            {
                case Kind.Done: return Futures.FromResult(1);
                case Kind.DoneFault: return Futures.FromException(new ApplicationException("done fault"));
                case Kind.DoneCancel: { var p = new Promise(); p.SetCanceled(); return p.Future; }
                case Kind.Later:
                case Kind.LaterFault:
                case Kind.LaterCancel: return s.Promise.Future;
                case Kind.Delay: return Futures.Delay(1);
                case Kind.ObserveFault: return Futures.Observe(Futures.FromException(new ApplicationException("observed")));
                default: return Futures.WhenAll(s.Children.Select(Build).ToArray());
            }
        }

        /// <summary>What the body sees when it awaits this step.</summary>
        private static FutureStatus Effective(Step s)
        {
            switch (s.Kind)
            {
                case Kind.DoneFault: case Kind.LaterFault: return FutureStatus.Faulted;
                case Kind.DoneCancel: case Kind.LaterCancel: return FutureStatus.Canceled;
                case Kind.Nested:
                    {
                        var kids = s.Children.Select(Effective).ToList();
                        if (kids.Contains(FutureStatus.Faulted)) return FutureStatus.Faulted;
                        if (kids.Contains(FutureStatus.Canceled)) return FutureStatus.Canceled;
                        return FutureStatus.Succeeded;
                    }
                default: return FutureStatus.Succeeded;
            }
        }

        private static Step MakeStep(Random rng, int depth)
        {
            var kind = (Kind)rng.Next(depth < 2 ? 9 : 8);
            var s = new Step { Kind = kind };
            if (kind == Kind.Later || kind == Kind.LaterFault || kind == Kind.LaterCancel) s.Promise = new Promise<int>(rng.Next(2) == 0);
            if (kind == Kind.Nested) s.Children = Enumerable.Range(0, rng.Next(1, 4)).Select(_ => MakeStep(rng, depth + 1)).ToList();
            return s;
        }

        private static IEnumerable<Step> Flatten(IEnumerable<Step> steps)
        {
            foreach (var s in steps)
            {
                yield return s;
                if (s.Children != null) foreach (var c in Flatten(s.Children)) yield return c;
            }
        }

        private static string Describe(List<Step> steps)
        {
            return "[" + string.Join(" ", steps.Select(s => s.Kind == Kind.Nested ? "Nested" + Describe(s.Children) : s.Kind.ToString())) + "]";
        }
    }
}
