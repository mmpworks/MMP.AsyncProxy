using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;

namespace MMP.AsyncProxy.Fuzz
{
    /// <summary>
    /// One CancelSource; callbacks registered and unregistered from several threads while
    /// another thread cancels; delays and pool runs hanging off the token.
    ///
    /// Invariants: Cancel is idempotent; a callback never runs twice; a callback that was
    /// registered before Cancel and never disposed runs exactly once; a callback registered
    /// after Cancel runs at once on the registering thread; a callback disposed before Cancel
    /// never runs; every Delay(token) and Run(token) settles, as Canceled or as Succeeded,
    /// never Faulted; ThrowIfCancelRequested inside an iterator ends it Canceled.
    /// </summary>
    public sealed class CancelRaces : IGenerator
    {
        public string Name => "cancel";

        public void Round(Random rng)
        {
            var source = new CancelSource();
            CancelToken token = source.Token;
            int callbacks = rng.Next(1, 8);
            var runs = new int[callbacks];
            var disposedBeforeCancel = new bool[callbacks];
            var disposeAttempted = new bool[callbacks];
            var registrations = new IDisposable[callbacks];
            int cancels = 1 + rng.Next(3);

            // Registered up front, so each is either disposed-before-cancel or must run once.
            for (int i = 0; i < callbacks; i++) { int k = i; registrations[i] = token.Register(() => Interlocked.Increment(ref runs[k])); }

            var delays = Enumerable.Range(0, rng.Next(0, 6)).Select(_ => Futures.Delay(rng.Next(0, 20), token)).ToArray();
            var works = Enumerable.Range(0, rng.Next(0, 4)).Select(_ => Futures.Run(() => { Fuzzer.Jitter(rng, 500); return 1; }, token)).ToArray();
            IFuture loop = AsyncProxy.Run(PollUntilCanceled(token));

            var branches = new List<Action>();
            for (int c = 0; c < cancels; c++) branches.Add(() => { Fuzzer.Jitter(rng, 500); source.Cancel(); });
            for (int i = 0; i < callbacks; i++)
            {
                if (rng.Next(3) != 0) continue;
                int k = i;
                disposeAttempted[i] = true;
                branches.Add(() =>
                {
                    Fuzzer.Jitter(rng, 500);
                    // Dispose races Cancel. Cancel flips the flag under the same lock Dispose takes,
                    // so if the flag is still down after Dispose returned, Dispose won and the
                    // callback was removed before Cancel could snapshot the list.
                    registrations[k].Dispose();
                    if (!source.IsCancelRequested) disposedBeforeCancel[k] = true;
                });
            }
            Fuzzer.InParallel(branches);

            if (!source.IsCancelRequested) throw new Exception("Cancel did not take");

            // Late registration runs at once, here.
            int me = Thread.CurrentThread.ManagedThreadId, lateOn = 0, lateRuns = 0;
            token.Register(() => { lateOn = Thread.CurrentThread.ManagedThreadId; lateRuns++; });
            if (lateRuns != 1 || lateOn != me) throw new Exception("late registration ran " + lateRuns + " times on thread " + lateOn + ", expected once on " + me);

            for (int i = 0; i < callbacks; i++)
            {
                if (runs[i] > 1) throw new Exception("callback " + i + " ran " + runs[i] + " times");
                if (disposedBeforeCancel[i] && runs[i] != 0) throw new Exception("callback " + i + " was disposed before cancel and still ran");
                if (!disposeAttempted[i] && runs[i] != 1) throw new Exception("callback " + i + " was never disposed and ran " + runs[i] + " times");
            }

            foreach (var d in delays) { Fuzzer.MustSettle(d, "Delay(token)"); if (d.IsFaulted) throw new Exception("a Delay(token) faulted: " + d.Exception); }
            foreach (var w in works) { Fuzzer.MustSettle(w, "Run(token)"); if (w.IsFaulted) throw new Exception("a Run(token) faulted: " + w.Exception); }
            Fuzzer.MustSettle(loop, "the polling iterator");
            if (!loop.IsCanceled) throw new Exception("the polling iterator ended " + loop.Status + ", expected Canceled");

            source.Dispose();
        }

        private static IEnumerable<IFuture> PollUntilCanceled(CancelToken token)
        {
            while (true)
            {
                token.ThrowIfCancelRequested();
                yield return Futures.Delay(1, token);
            }
        }
    }
}
