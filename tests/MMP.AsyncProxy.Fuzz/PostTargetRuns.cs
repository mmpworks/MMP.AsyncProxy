using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;

namespace MMP.AsyncProxy.Fuzz
{
    /// <summary>
    /// A thread that registers an IPostTarget starts several async methods; their steps are
    /// settled from random other threads.
    ///
    /// Invariants: every continuation after an await runs on the owner thread; a method started
    /// with ContinueOnAnyThread does not; the owner drains everything and the methods settle;
    /// PostTarget.Current is per thread, so other threads see null.
    /// </summary>
    public sealed class PostTargetRuns : IGenerator
    {
        public string Name => "posttarget";

        private sealed class Owner : IPostTarget, IDisposable
        {
            private readonly Queue<Action> _queue = new Queue<Action>();
            private readonly AutoResetEvent _wake = new AutoResetEvent(false);
            private readonly Thread _thread;
            private volatile bool _stop;
            public int Posts;

            public Owner()
            {
                _thread = new Thread(Loop) { IsBackground = true };
                _thread.Start();
            }

            public int ThreadId => _thread.ManagedThreadId;

            public void Post(Action action)
            {
                Interlocked.Increment(ref Posts);
                lock (_queue) _queue.Enqueue(action);
                _wake.Set();
            }

            private void Loop()
            {
                PostTarget.SetForCurrentThread(this);
                while (!_stop)
                {
                    _wake.WaitOne(50);
                    while (true)
                    {
                        Action next;
                        lock (_queue) { if (_queue.Count == 0) break; next = _queue.Dequeue(); }
                        next();
                    }
                }
            }

            public void Dispose() { _stop = true; _wake.Set(); _thread.Join(2000); }
        }

        public void Round(Random rng)
        {
            using (var owner = new Owner())
            {
                int methods = rng.Next(1, 8);
                var steps = Enumerable.Range(0, methods).Select(_ => Enumerable.Range(0, rng.Next(1, 4)).Select(__ => new Promise<int>(rng.Next(2) == 0)).ToArray()).ToArray();
                var resumedOn = new List<int>[methods];
                var futures = new IFuture[methods];
                var started = new ManualResetEvent(false);

                owner.Post(() =>
                {
                    if (PostTarget.Current == null) throw new Exception("PostTarget.Current is null on the owner thread");
                    for (int m = 0; m < methods; m++)
                    {
                        resumedOn[m] = new List<int>();
                        futures[m] = AsyncProxy.Run(Body(steps[m], resumedOn[m]));
                    }
                    started.Set();
                });
                if (!started.WaitOne(5000)) throw new TimeoutException("the owner never started the methods");
                if (PostTarget.Current != null) throw new Exception("PostTarget.Current leaked to the fuzz thread");

                var settlers = steps.SelectMany(s => s).Select<Promise<int>, Action>(p => () => { Fuzzer.Jitter(rng, 1500); p.TrySetResult(1); }).ToList();
                Fuzzer.InParallel(settlers);

                for (int m = 0; m < methods; m++)
                {
                    Fuzzer.MustSettle(futures[m], "owner method " + m);
                    if (futures[m].IsFaulted) throw new Exception("owner method " + m + " faulted: " + futures[m].Exception);
                }
                // The lists are written on the owner thread and read after the futures settled; the Wait is the fence.
                for (int m = 0; m < methods; m++)
                {
                    if (resumedOn[m].Count != steps[m].Length) throw new Exception("method " + m + " resumed " + resumedOn[m].Count + " times for " + steps[m].Length + " steps");
                    foreach (int tid in resumedOn[m])
                        if (tid != owner.ThreadId) throw new Exception("method " + m + " resumed on thread " + tid + ", expected the owner " + owner.ThreadId);
                }
            }
        }

        private static IEnumerable<IFuture> Body(Promise<int>[] steps, List<int> resumedOn)
        {
            foreach (var step in steps)
            {
                yield return step.Future;
                resumedOn.Add(Thread.CurrentThread.ManagedThreadId);
            }
        }
    }
}
