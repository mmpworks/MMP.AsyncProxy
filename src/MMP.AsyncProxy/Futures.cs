using System;
using System.Collections.Generic;
using System.Threading;

namespace MMP.AsyncProxy
{
    /// <summary>Factories and combinators. The static side of Task.</summary>
    public static class Futures
    {
        private static readonly IFuture CompletedFuture = CreateCompleted();

        /// <summary>A future that was complete before you asked.</summary>
        public static IFuture Completed { get { return CompletedFuture; } }

        public static IFuture<T> FromResult<T>(T value)
        {
            Promise<T> promise = new Promise<T>();
            promise.SetResult(value);
            return promise;
        }

        public static IFuture<T> FromException<T>(Exception exception)
        {
            Promise<T> promise = new Promise<T>();
            promise.SetException(exception);
            return promise;
        }

        public static IFuture FromException(Exception exception)
        {
            return FromException<VoidResult>(exception);
        }

        /// <summary>
        /// Completes after the delay. Uses a timer, so no thread waits.
        /// Thread.Sleep inside a work item would hold a pool thread for the whole time.
        /// </summary>
        public static IFuture Delay(int milliseconds)
        {
            if (milliseconds < 0) throw new ArgumentOutOfRangeException("milliseconds");
            Promise promise = new Promise();
            if (milliseconds == 0)
            {
                promise.SetResult();
                return promise.Future;
            }
            Timer[] holder = new Timer[1];
            holder[0] = new Timer(delegate
            {
                Timer t = holder[0];
                if (t != null) t.Dispose();
                promise.TrySetResult();
            }, null, milliseconds, Timeout.Infinite);
            return promise.Future;
        }

        /// <summary>Queues CPU work to the thread pool. The one place a thread is really used.</summary>
        public static IFuture<T> Run<T>(Func<T> work)
        {
            if (work == null) throw new ArgumentNullException("work");
            Promise<T> promise = new Promise<T>();
            ThreadPool.QueueUserWorkItem(delegate
            {
                try { promise.TrySetResult(work()); }
                catch (Exception ex) { promise.TrySetException(ex); }
            });
            return promise;
        }

        public static IFuture Run(Action work)
        {
            if (work == null) throw new ArgumentNullException("work");
            return Run<VoidResult>(delegate { work(); return VoidResult.Value; });
        }

        /// <summary>
        /// Completes when every input completes. Counts down with Interlocked.Decrement.
        /// Faults with every fault collected, never only the first.
        /// </summary>
        public static IFuture WhenAll(params IFuture[] futures)
        {
            if (futures == null) throw new ArgumentNullException("futures");
            Promise promise = new Promise();
            if (futures.Length == 0)
            {
                promise.SetResult();
                return promise.Future;
            }

            int[] remaining = new int[] { futures.Length };
            object faultGate = new object();
            List<Exception> faults = new List<Exception>();
            bool[] anyCanceled = new bool[1];

            for (int i = 0; i < futures.Length; i++)
            {
                IFuture future = futures[i];
                if (future == null) throw new ArgumentException("A null future was passed to WhenAll.", "futures");
                // Library-internal continuation. Never post to a UI context from here;
                // the caller's own await on the WhenAll result does that.
                IAwaiter awaiter = future.ContinueOnAnyThread();
                awaiter.OnCompleted(delegate
                {
                    if (future.IsFaulted)
                    {
                        lock (faultGate) { faults.Add(future.Exception); }
                    }
                    else if (future.IsCanceled)
                    {
                        anyCanceled[0] = true;
                    }

                    if (Interlocked.Decrement(ref remaining[0]) != 0) return;

                    if (faults.Count > 0) promise.TrySetException(new AggregateFutureException(faults));
                    else if (anyCanceled[0]) promise.TrySetCanceled();
                    else promise.TrySetResult();
                });
            }
            return promise.Future;
        }

        private static IFuture CreateCompleted()
        {
            Promise promise = new Promise();
            promise.SetResult();
            return promise.Future;
        }
    }
}
