using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;

namespace MMP.AsyncProxy.Fuzz
{
    /// <summary>
    /// One promise, many hands. Several threads race to complete it with different outcomes
    /// while other threads register continuations before, during, and after completion.
    ///
    /// Invariants: one completer wins and the rest get false; the future's status is the
    /// winner's; every continuation runs exactly once and never before completion; Wait
    /// returns; GetResult agrees with the status; the inline/pool option is honoured for
    /// continuations that were saved while pending.
    /// </summary>
    public sealed class PromiseRaces : IGenerator
    {
        public string Name => "promise";

        private enum Outcome { Result, Fault, Cancel }

        public void Round(Random rng)
        {
            bool async = rng.Next(2) == 0;
            var promise = new Promise<int>(async ? PromiseOptions.RunContinuationsAsynchronously : PromiseOptions.None);
            int completers = 1 + rng.Next(4);
            int early = rng.Next(6);
            int late = rng.Next(4);
            var outcomes = Enumerable.Range(0, completers).Select(_ => (Outcome)rng.Next(3)).ToArray();
            var values = Enumerable.Range(0, completers).Select(_ => rng.Next(1000)).ToArray();

            int wins = 0;
            int winner = -1;
            var runs = new int[early + late];
            var ranBeforeDone = new bool[early + late];
            var ranOn = new int[early + late];
            var completerThread = new int[completers];
            var allRan = new CountdownEvent(early + late);

            Action<int> register = i =>
            {
                promise.Future.ContinueOnAnyThread().OnCompleted(() =>
                {
                    if (!promise.Future.IsCompleted) ranBeforeDone[i] = true;
                    ranOn[i] = Thread.CurrentThread.ManagedThreadId;
                    Interlocked.Increment(ref runs[i]);
                    allRan.Signal();
                });
            };

            var branches = new List<Action>();
            for (int i = 0; i < early; i++) { int k = i; branches.Add(() => { Fuzzer.Jitter(rng); register(k); }); }
            for (int c = 0; c < completers; c++)
            {
                int k = c;
                branches.Add(() =>
                {
                    Fuzzer.Jitter(rng);
                    completerThread[k] = Thread.CurrentThread.ManagedThreadId;
                    bool won;
                    switch (outcomes[k])
                    {
                        case Outcome.Result: won = promise.TrySetResult(values[k]); break;
                        case Outcome.Fault: won = promise.TrySetException(new InvalidOperationException("fault " + k)); break;
                        default: won = promise.TrySetCanceled(); break;
                    }
                    if (won) { Interlocked.Increment(ref wins); winner = k; }
                });
            }
            Shuffle(rng, branches);
            Fuzzer.InParallel(branches);

            // Late registrations run at once on the registering thread, option or not.
            for (int i = 0; i < late; i++)
            {
                int k = early + i;
                int me = Thread.CurrentThread.ManagedThreadId;
                register(k);
                if (runs[k] != 1) throw new Exception("late continuation " + k + " ran " + runs[k] + " times, expected 1 inline run");
                if (ranOn[k] != me) throw new Exception("late continuation " + k + " ran on thread " + ranOn[k] + ", expected the registering thread " + me);
            }

            if (wins != 1) throw new Exception(wins + " completers won; expected 1");
            Fuzzer.MustSettle(promise.Future, "the raced promise");
            if (!allRan.Wait(5000)) throw new TimeoutException("not every continuation ran: " + string.Join(",", runs));

            var expected = outcomes[winner] == Outcome.Result ? FutureStatus.Succeeded
                : outcomes[winner] == Outcome.Fault ? FutureStatus.Faulted : FutureStatus.Canceled;
            if (promise.Future.Status != expected) throw new Exception("status " + promise.Future.Status + " but winner " + winner + " set " + outcomes[winner]);
            if (expected == FutureStatus.Succeeded && promise.Future.Result != values[winner]) throw new Exception("result " + promise.Future.Result + " is not the winner's " + values[winner]);
            if (expected == FutureStatus.Faulted && promise.Future.Exception.Message != "fault " + winner) throw new Exception("exception is not the winner's");

            for (int i = 0; i < runs.Length; i++)
            {
                if (runs[i] != 1) throw new Exception("continuation " + i + " ran " + runs[i] + " times");
                if (ranBeforeDone[i]) throw new Exception("continuation " + i + " ran before the future completed");
            }

            // GetResult agrees with the status.
            try
            {
                int got = promise.Future.GetAwaiter().GetResult();
                if (expected != FutureStatus.Succeeded) throw new Exception("GetResult returned " + got + " on a " + expected + " future");
            }
            catch (FutureCanceledException) { if (expected != FutureStatus.Canceled) throw; }
            catch (InvalidOperationException) { if (expected != FutureStatus.Faulted) throw; }

            // Early continuations under the pool option never run on the completer's thread
            // while it is still inside SetResult; the simplest observable form is "not inline
            // on a different thread than the registering one" is unprovable here, so check the
            // half that is: with the option, a saved continuation runs on a pool thread, which
            // is never the winner's completer thread when that thread is one of ours.
            if (async)
            {
                for (int i = 0; i < early; i++)
                    if (ranOn[i] == completerThread[winner]) throw new Exception("saved continuation " + i + " ran inline on the completer under RunContinuationsAsynchronously");
            }
        }

        private static void Shuffle<T>(Random rng, IList<T> list)
        {
            for (int i = list.Count - 1; i > 0; i--)
            {
                int j = rng.Next(i + 1);
                T t = list[i]; list[i] = list[j]; list[j] = t;
            }
        }
    }
}
