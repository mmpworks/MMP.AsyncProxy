using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading;

namespace MMP.AsyncProxy.Comparison
{
    /// <summary>
    /// Three ways to do the same job and a stopwatch on each.
    ///
    /// The job: N requests arrive at once. Each one waits for "I/O" (we fake it
    /// with a 200 ms delay) and then does a tiny bit of math. Picture a web
    /// server, a device poller, anything that mostly waits.
    ///
    /// Run it and read the table. The numbers teach the lesson better than we can.
    /// </summary>
    internal static class Program
    {
        private const int DelayMs = 200;

        private static void Main(string[] args)
        {
            int n = args.Length > 0 ? int.Parse(args[0]) : 2000;
            Console.WriteLine("Requests: " + n + ", each waits " + DelayMs + " ms then adds two numbers.");
            Console.WriteLine("Cores: " + Environment.ProcessorCount);
            Console.WriteLine();
            Console.WriteLine("{0,-34} {1,10} {2,14} {3,12}", "approach", "elapsed ms", "peak threads", "ok");

            Report("thread per request (Sleep)", RunThreadPerRequest(n));
            Report("thread pool + Sleep (starves)", RunPoolWithSleep(Math.Min(n, 64)) + "  (capped at 64 requests)");
            Report("state machine + Delay (no wait)", RunStateMachines(n));

            Console.WriteLine();
            Console.WriteLine("The third row does the same work with the thread count of an idle process.");
            Console.WriteLine("Nothing waited on a thread. The timer waited, and the pool ran the callbacks.");
        }

        private static void Report(string name, string row)
        {
            Console.WriteLine("{0,-34} {1}", name, row);
        }

        // Approach 1: one OS thread per request, and that thread sleeps.
        // Honest and simple. Also one megabyte of reserved stack per request,
        // a kernel object per request, and a scheduler that has to juggle all of them.
        private static string RunThreadPerRequest(int n)
        {
            int[] sum = new int[1];
            ThreadSampler sampler = new ThreadSampler();
            Stopwatch clock = Stopwatch.StartNew();

            List<Thread> threads = new List<Thread>(n);
            for (int i = 0; i < n; i++)
            {
                int a = i;
                Thread t = new Thread((ThreadStart)delegate
                {
                    Thread.Sleep(DelayMs);
                    Interlocked.Add(ref sum[0], a + 1);
                });
                threads.Add(t);
                t.Start();
            }
            for (int i = 0; i < threads.Count; i++) threads[i].Join();

            clock.Stop();
            return Row(clock, sampler.Stop(), sum[0] == Expected(n));
        }

        // Approach 2: hand the work to the thread pool, and sleep inside the work item.
        // Looks cheaper. It is a trap. The pool starts with about one thread per core
        // and adds more slowly. Every Sleep pins one of them, so the queue drains at
        // a crawl. Stephen Toub calls this out at 50:18 in "Writing async/await from scratch".
        private static string RunPoolWithSleep(int n)
        {
            int[] sum = new int[1];
            int[] remaining = new int[] { n };
            ManualResetEvent done = new ManualResetEvent(false);
            ThreadSampler sampler = new ThreadSampler();
            Stopwatch clock = Stopwatch.StartNew();

            for (int i = 0; i < n; i++)
            {
                int a = i;
                ThreadPool.QueueUserWorkItem(delegate
                {
                    Thread.Sleep(DelayMs);
                    Interlocked.Add(ref sum[0], a + 1);
                    if (Interlocked.Decrement(ref remaining[0]) == 0) done.Set();
                });
            }
            done.WaitOne();

            clock.Stop();
            return Row(clock, sampler.Stop(), sum[0] == Expected(n));
        }

        // Approach 3: a state machine per request. The "wait" is a timer. No thread
        // is parked anywhere. When a timer fires, a pool thread runs one MoveNext,
        // adds two numbers, and goes back to the pool in microseconds.
        private static string RunStateMachines(int n)
        {
            int[] sum = new int[1];
            ThreadSampler sampler = new ThreadSampler();
            Stopwatch clock = Stopwatch.StartNew();

            IFuture[] futures = new IFuture[n];
            for (int i = 0; i < n; i++)
            {
                futures[i] = AsyncProxy.Run(OneRequest(i, sum));
            }
            Futures.WhenAll(futures).Wait();

            clock.Stop();
            return Row(clock, sampler.Stop(), sum[0] == Expected(n));
        }

        private static IEnumerable<IFuture> OneRequest(int a, int[] sum)
        {
            yield return Futures.Delay(DelayMs);
            Interlocked.Add(ref sum[0], a + 1);
        }

        private static int Expected(int n)
        {
            // sum of (i + 1) for i in 0..n-1
            return n * (n + 1) / 2;
        }

        private static string Row(Stopwatch clock, int peakThreads, bool ok)
        {
            return string.Format("{0,10} {1,14} {2,12}", clock.ElapsedMilliseconds, peakThreads, ok ? "yes" : "NO");
        }

        /// <summary>Polls the process thread count every few ms and remembers the high-water mark.</summary>
        private sealed class ThreadSampler
        {
            private readonly Timer _timer;
            private int _peak;
            private bool _stopped;

            public ThreadSampler()
            {
                Sample(null);
                _timer = new Timer(Sample, null, 5, 5);
            }

            private void Sample(object state)
            {
                if (_stopped) return;
                int now = Process.GetCurrentProcess().Threads.Count;
                int seen;
                do { seen = _peak; if (now <= seen) return; }
                while (Interlocked.CompareExchange(ref _peak, now, seen) != seen);
            }

            public int Stop()
            {
                _stopped = true;
                _timer.Dispose();
                Sample(null);
                return _peak;
            }
        }
    }
}
