using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

namespace MMP.AsyncProxy.Fuzz
{
    /// <summary>
    /// Many delays of random length started together from several threads, with some of them
    /// canceled part way, all on the one shared timer wheel.
    ///
    /// Invariants: every delay settles; an uncanceled one Succeeded; a canceled one is Canceled or
    /// Succeeded (the cancel lost the race) and never Faulted; no delay completes before its due
    /// time minus the Windows timer slop; the whole storm finishes inside a bound that scales
    /// with the longest delay, so an entry never gets stuck behind another on the wheel.
    /// </summary>
    public sealed class DelayStorm : IGenerator
    {
        public string Name => "delays";

        public void Round(Random rng)
        {
            int n = rng.Next(1, 60);
            int maxMs = rng.Next(1, 60);
            var lengths = Enumerable.Range(0, n).Select(_ => rng.Next(0, maxMs + 1)).ToArray();
            var cancel = Enumerable.Range(0, n).Select(_ => rng.Next(4) == 0).ToArray();
            var sources = lengths.Select(_ => new CancelSource()).ToArray();
            var futures = new IFuture[n];

            int threads = rng.Next(1, 5);
            var branches = new List<Action>();
            for (int t = 0; t < threads; t++)
            {
                int from = t;
                branches.Add(() =>
                {
                    for (int i = from; i < n; i += threads)
                        futures[i] = Futures.Delay(lengths[i], sources[i].Token);
                });
            }
            Fuzzer.InParallel(branches);

            // Cancel a quarter of them from yet another thread, at a random moment.
            Fuzzer.InParallel(() =>
            {
                Fuzzer.Jitter(rng, 2000);
                for (int i = 0; i < n; i++) if (cancel[i]) sources[i].Cancel();
            });

            int bound = 2000 + maxMs * 4;
            for (int i = 0; i < n; i++)
            {
                Fuzzer.MustSettle(futures[i], "delay " + i + " of " + lengths[i] + " ms", bound);
                if (futures[i].IsFaulted) throw new Exception("delay " + i + " faulted: " + futures[i].Exception);
                if (!cancel[i] && !futures[i].Status.Equals(FutureStatus.Succeeded)) throw new Exception("uncanceled delay " + i + " ended " + futures[i].Status);
            }

            // Early firing check on one lone delay, allowing the 16 ms tick that the timer queue
            // and Environment.TickCount both round to. The storm above does not time each entry.
            if (rng.Next(4) == 0)
            {
                int ms = 40 + rng.Next(40);
                var sw = Stopwatch.StartNew();
                IFuture one = Futures.Delay(ms);
                Fuzzer.MustSettle(one, "a lone " + ms + " ms delay", 2000 + ms);
                if (sw.ElapsedMilliseconds < ms - 16) throw new Exception("a " + ms + " ms delay fired after " + sw.ElapsedMilliseconds + " ms");
            }

            foreach (var s in sources) s.Dispose();
        }
    }
}
