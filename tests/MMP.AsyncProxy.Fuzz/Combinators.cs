using System;
using System.Collections.Generic;
using System.Linq;

namespace MMP.AsyncProxy.Fuzz
{
    /// <summary>
    /// WhenAll and WhenAny over inputs that settle in a random order on random threads, some
    /// already settled before the call, with random outcomes.
    ///
    /// Invariants. WhenAll: settles; Succeeded iff every input succeeded; Faulted with an
    /// AggregateFutureException that lists each faulted input's exception in INPUT order iff
    /// any input faulted; Canceled otherwise. WhenAny: settles as soon as one input has; its
    /// result is one of the inputs and that input is complete at the time WhenAny completes.
    /// </summary>
    public sealed class Combinators : IGenerator
    {
        public string Name => "combinators";

        public void Round(Random rng)
        {
            int n = rng.Next(1, 12);
            var promises = Enumerable.Range(0, n).Select(_ => new Promise<int>(rng.Next(2) == 0)).ToArray();
            var outcome = Enumerable.Range(0, n).Select(_ => (FutureStatus)rng.Next(1, 4)).ToArray();   // Succeeded, Faulted, Canceled
            var inputs = promises.Select(p => (IFuture)p.Future).ToArray();

            // Some settle before the combinators are even built.
            var settled = new bool[n];
            for (int i = 0; i < n; i++) if (rng.Next(3) == 0) { Settle(promises[i], outcome[i], i); settled[i] = true; }

            IFuture all = Futures.WhenAll(inputs);
            IFuture<IFuture> any = Futures.WhenAny(inputs);

            bool anyWasSettledUpFront = settled.Any(s => s);
            if (anyWasSettledUpFront && !any.IsCompleted) throw new Exception("WhenAny over an already-settled input is not complete");
            if (settled.All(s => s) && !all.IsCompleted) throw new Exception("WhenAll over all-settled inputs is not complete");

            var branches = new List<Action>();
            for (int i = 0; i < n; i++)
            {
                if (settled[i]) continue;
                int k = i;
                branches.Add(() => { Fuzzer.Jitter(rng, 1000); Settle(promises[k], outcome[k], k); });
            }
            Fuzzer.InParallel(branches);

            Fuzzer.MustSettle(all, "WhenAll");
            Fuzzer.MustSettle(any, "WhenAny");

            // WhenAll
            var faultedIdx = Enumerable.Range(0, n).Where(i => outcome[i] == FutureStatus.Faulted).ToArray();
            FutureStatus expected = faultedIdx.Length > 0 ? FutureStatus.Faulted
                : outcome.Contains(FutureStatus.Canceled) ? FutureStatus.Canceled : FutureStatus.Succeeded;
            if (all.Status != expected) throw new Exception("WhenAll " + all.Status + ", expected " + expected + " for [" + string.Join(",", outcome) + "]");
            if (expected == FutureStatus.Faulted)
            {
                var agg = all.Exception as AggregateFutureException;
                if (agg == null) throw new Exception("WhenAll fault is " + all.Exception.GetType().Name + ", expected AggregateFutureException");
                var got = agg.InnerExceptions.Select(e => int.Parse(e.Message)).ToArray();
                if (!got.SequenceEqual(faultedIdx)) throw new Exception("WhenAll faults in order [" + string.Join(",", got) + "], expected input order [" + string.Join(",", faultedIdx) + "]");
            }

            // WhenAny
            IFuture winner = any.Result;
            int idx = Array.IndexOf(inputs, winner);
            if (idx < 0) throw new Exception("WhenAny returned a future that was not an input");
            if (!winner.IsCompleted) throw new Exception("WhenAny winner " + idx + " is not complete");
        }

        private static void Settle(Promise<int> p, FutureStatus how, int index)
        {
            switch (how)
            {
                case FutureStatus.Succeeded: p.TrySetResult(index); break;
                case FutureStatus.Faulted: p.TrySetException(new ApplicationException(index.ToString())); break;
                default: p.TrySetCanceled(); break;
            }
        }
    }
}
