using System;
using System.Collections.Generic;
using System.Threading;

namespace MMP.AsyncProxy.Sdk
{
    /// <summary>
    /// docs/sdk.md, "UI threads". GetAwaiter() brings a continuation back to the thread that
    /// started the await when that thread has a SynchronizationContext (desktop) or a registered
    /// IPostTarget (Compact Framework). ContinueOnAnyThread() skips the trip.
    /// </summary>
    public static class UiThreads
    {
        /// <summary>Inside a library: do not bounce to the UI for work the UI never sees.</summary>
        public static IAwaiter<int> StayOffTheUiThread(IFuture<int> future)
        {
            IAwaiter<int> awaiter = future.ContinueOnAnyThread();
            return awaiter;
        }

        /// <summary>
        /// A thread that owns something (a display loop, a printer driver) asks for its
        /// continuations back by registering a post target once. Works on the desktop and on
        /// the Compact Framework, which has no SynchronizationContext.
        /// </summary>
        public sealed class OwnerLoop : IPostTarget, IDisposable
        {
            private readonly Queue<Action> _queue = new Queue<Action>();
            private readonly AutoResetEvent _wake = new AutoResetEvent(false);
            private readonly Thread _thread;
            private volatile bool _stopping;

            public OwnerLoop()
            {
                _thread = new Thread(Loop);
                _thread.IsBackground = true;
                _thread.Start();
            }

            public int ThreadId { get { return _thread.ManagedThreadId; } }

            /// <summary>IPostTarget: the awaiter calls this to bring a continuation back here.</summary>
            public void Post(Action action)
            {
                lock (_queue) _queue.Enqueue(action);
                _wake.Set();
            }

            private void Loop()
            {
                PostTarget.SetForCurrentThread(this);
                while (!_stopping)
                {
                    _wake.WaitOne();
                    while (true)
                    {
                        Action next;
                        lock (_queue)
                        {
                            if (_queue.Count == 0) break;
                            next = _queue.Dequeue();
                        }
                        next();
                    }
                }
            }

            public void Dispose()
            {
                _stopping = true;
                _wake.Set();
            }
        }

        /// <summary>Start an async method on the owner thread; its continuations come back to that thread.</summary>
        public static IFuture<int> RunOnOwner(OwnerLoop owner, IFuture step)
        {
            Promise<int> started = new Promise<int>();
            owner.Post(delegate
            {
                IFuture<int> result = AsyncProxy.Run<int>(delegate(Return<int> ret) { return ThreadAfterAwait(step, ret); });
                result.ContinueOnAnyThread().OnCompleted(delegate { started.TrySetResult(result.Result); });
            });
            return started.Future;
        }

        private static IEnumerable<IFuture> ThreadAfterAwait(IFuture step, Return<int> ret)
        {
            yield return step;
            ret.Value = Thread.CurrentThread.ManagedThreadId;
        }
    }
}
