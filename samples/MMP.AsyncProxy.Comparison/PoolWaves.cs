using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading;

namespace MMP.AsyncProxy.Comparison
{
    /// <summary>
    /// Shows the thread pool starvation mistake as a picture you can count.
    ///
    /// Queue a lot of jobs on the thread pool where every job just sleeps. The pool's
    /// worker threads are the crew, the queue is the job board, and a sleeping job is a
    /// crew member sitting in a parked car. Print when each job actually started. They
    /// start in waves, one wave per sleep, and each wave is as wide as the crew.
    ///
    /// Run it:  dotnet run --project samples/MMP.AsyncProxy.Comparison -- waves 64
    /// </summary>
    internal static class PoolWaves
    {
        private const int SleepMs = 200;

        public static void Run(int jobs)
        {
            int minWorkers, minIo;
            ThreadPool.GetMinThreads(out minWorkers, out minIo);
            Console.WriteLine("Jobs: " + jobs + ", each one sleeps " + SleepMs + " ms. Cores: " + Environment.ProcessorCount
                + ". The pool starts with " + minWorkers + " worker threads.");
            Console.WriteLine();

            Console.WriteLine("A. Thread pool, and every job sleeps (the crew parks in their cars):");
            Print(SleepOnThePool(jobs));

            Console.WriteLine();
            Console.WriteLine("B. The same jobs as state machines on a Futures.Delay (no crew member parks):");
            Print(DelayWithoutAThread(jobs));

            Console.WriteLine();
            Console.WriteLine("Ideal is about " + SleepMs + " ms: everybody waits at the same time.");
        }

        // A: each work item holds a pool thread for the whole sleep.
        private static Result SleepOnThePool(int jobs)
        {
            long[] started = new long[jobs];
            CountdownEvent done = new CountdownEvent(jobs);
            Stopwatch clock = Stopwatch.StartNew();
            for (int i = 0; i < jobs; i++)
            {
                int me = i;
                ThreadPool.QueueUserWorkItem(delegate
                {
                    started[me] = clock.ElapsedMilliseconds;
                    Thread.Sleep(SleepMs);          // the crew member parks here
                    done.Signal();
                });
            }
            done.Wait();
            return new Result(started, clock.ElapsedMilliseconds);
        }

        // B: the wait is a timer. A pool thread only runs the first half and the last half.
        private static Result DelayWithoutAThread(int jobs)
        {
            long[] started = new long[jobs];
            IFuture[] all = new IFuture[jobs];
            Stopwatch clock = Stopwatch.StartNew();
            for (int i = 0; i < jobs; i++)
            {
                all[i] = AsyncProxy.Run(OneJob(i, started, clock));
            }
            Futures.WhenAll(all).Wait();
            return new Result(started, clock.ElapsedMilliseconds);
        }

        private static IEnumerable<IFuture> OneJob(int me, long[] started, Stopwatch clock)
        {
            started[me] = clock.ElapsedMilliseconds;
            yield return Futures.Delay(SleepMs);
        }

        // Group the start times into waves: a gap of more than 80 ms starts a new wave.
        private static void Print(Result r)
        {
            long[] sorted = (long[])r.Started.Clone();
            Array.Sort(sorted);
            long waveStart = sorted[0], last = sorted[0];
            int count = 0, wave = 1;
            for (int i = 0; i < sorted.Length; i++)
            {
                if (sorted[i] - last > 80)
                {
                    Console.WriteLine("  wave {0,2}: {1,3} jobs started at about {2,5} ms", wave++, count, waveStart);
                    waveStart = sorted[i];
                    count = 0;
                }
                last = sorted[i];
                count++;
            }
            Console.WriteLine("  wave {0,2}: {1,3} jobs started at about {2,5} ms", wave, count, waveStart);
            Console.WriteLine("  all {0} jobs finished after {1} ms", sorted.Length, r.TotalMs);
        }

        private sealed class Result
        {
            public readonly long[] Started;
            public readonly long TotalMs;
            public Result(long[] started, long totalMs) { Started = started; TotalMs = totalMs; }
        }
    }
}
