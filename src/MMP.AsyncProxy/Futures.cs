using System;
using System.Collections.Generic;
using System.Threading;

namespace MMP.AsyncProxy
{
    /// <summary>The static helpers. Think of the static side of Task: Delay, Run, WhenAll, FromResult.</summary>
    public static class Futures
    {
        private static readonly IFuture CompletedFuture = CreateCompleted();
        private static readonly IFuture<bool> TrueFuture = FromResult(true);
        private static readonly IFuture<bool> FalseFuture = FromResult(false);

        /// <summary>A future that was done before you asked. Awaiting it never suspends.</summary>
        public static IFuture Completed { get { return CompletedFuture; } }

        /// <summary>
        /// Completed futures for the two answers a yes-or-no step gives. A tray that
        /// says "it went in" on the fast path hands one of these back and allocates
        /// nothing, where a fresh promise and future cost two objects per call. The
        /// training track's pipeline paid that twice per item before these existed.
        /// </summary>
        public static IFuture<bool> True { get { return TrueFuture; } }
        public static IFuture<bool> False { get { return FalseFuture; } }

        public static IFuture<T> FromResult<T>(T value)
        {
            Promise<T> promise = new Promise<T>();
            promise.SetResult(value);
            return promise.Future;
        }

        public static IFuture<T> FromException<T>(Exception exception)
        {
            Promise<T> promise = new Promise<T>();
            promise.SetException(exception);
            return promise.Future;
        }

        public static IFuture FromException(Exception exception)
        {
            return FromException<VoidResult>(exception);
        }

        /// <summary>
        /// Waits without a thread. A timer fires once and completes the promise.
        /// Compare Thread.Sleep inside a work item: that holds a pool thread hostage
        /// for the whole time and does nothing with it. Await this instead.
        /// </summary>
        public static IFuture Delay(int milliseconds)
        {
            return Delay(milliseconds, CancelToken.None);
        }

        /// <summary>
        /// Same delay, but the token can cut it short. Cancel wins the race: the
        /// future ends Canceled, the timer is thrown away, and the registration is
        /// released either way so the source does not keep dead timers alive.
        /// </summary>
        public static IFuture Delay(int milliseconds, CancelToken token)
        {
            if (milliseconds < 0) throw new ArgumentOutOfRangeException("milliseconds");
            Promise promise = new Promise();
            if (token.IsCancelRequested)
            {
                promise.SetCanceled();
                return promise.Future;
            }
            if (milliseconds == 0)
            {
                promise.SetResult();
                return promise.Future;
            }
            // One shared timer for every delay, not a Timer per call. The first version
            // made a System.Threading.Timer here and disposed it in its own callback; two
            // hundred of those firing on one tick took the timer queue's lock two hundred
            // times and the .NET 10 pool read it as starvation and added fifty threads.
            // The wheel fires once per due time and queues each completion to the pool.
            DelayWheel.Entry entry = DelayWheel.Add(milliseconds, promise);
            if (token.CanBeCanceled)
            {
                IDisposable registration = token.Register(delegate
                {
                    DelayWheel.Remove(entry);
                    promise.TrySetCanceled();
                });
                entry.Registration = registration;
            }
            return promise.Future;
        }

        /// <summary>
        /// Done when the first input is done, and it tells you which one. The
        /// others keep running; nobody stops them. Task.WhenAny, same rules.
        /// </summary>
        public static IFuture<IFuture> WhenAny(params IFuture[] futures)
        {
            if (futures == null) throw new ArgumentNullException("futures");
            if (futures.Length == 0) throw new ArgumentException("WhenAny needs at least one future.", "futures");
            Promise<IFuture> promise = new Promise<IFuture>();
            for (int i = 0; i < futures.Length; i++)
            {
                IFuture future = futures[i];
                if (future == null) throw new ArgumentException("A null future was passed to WhenAny.", "futures");
                // First one to get here wins. TrySetResult refuses the rest.
                future.ContinueOnAnyThread().OnCompleted(delegate { promise.TrySetResult(future); });
            }
            return promise.Future;
        }

        /// <summary>
        /// Wraps a future so that awaiting the wrapper never throws. When the
        /// inner one finishes, in any state, the wrapper succeeds. Then you read
        /// the inner future's IsFaulted or IsCanceled yourself. This is how an
        /// iterator body handles a step's failure, since it cannot catch one.
        /// <code>
        /// yield return Futures.Observe(risky);
        /// if (risky.IsFaulted) { /* handle it */ }
        /// </code>
        /// </summary>
        public static IFuture Observe(IFuture future)
        {
            if (future == null) throw new ArgumentNullException("future");
            // Already settled, in any state: there is nothing to wait for, so hand back
            // the shared completed future and allocate nothing. A mailbox loop whose
            // next item was already queued takes this path on every item.
            if (future.IsCompleted) return CompletedFuture;
            Promise promise = new Promise();
            future.ContinueOnAnyThread().OnCompleted(delegate { promise.TrySetResult(); });
            return promise.Future;
        }

        /// <summary>
        /// Turns a Begin/End pair into a future. This is how real I/O stays off a
        /// thread in .NET 3.5: FileStream.BeginRead hands the read to the OS, the OS
        /// signals an I/O completion port when the bytes land, and a pool thread runs
        /// our callback for a few microseconds. Nobody waited.
        /// <code>
        /// Futures.FromAsync&lt;int&gt;(
        ///     delegate(AsyncCallback cb, object s) { return stream.BeginRead(buf, 0, buf.Length, cb, s); },
        ///     stream.EndRead);
        /// </code>
        /// Task.Factory.FromAsync does the same job in .NET 4.
        /// </summary>
        public static IFuture<T> FromAsync<T>(Func<AsyncCallback, object, IAsyncResult> begin, Func<IAsyncResult, T> end)
        {
            if (begin == null) throw new ArgumentNullException("begin");
            if (end == null) throw new ArgumentNullException("end");
            Promise<T> promise = new Promise<T>();
            try
            {
                begin(delegate(IAsyncResult ar)
                {
                    try { promise.TrySetResult(end(ar)); }
                    catch (Exception ex) { promise.TrySetException(ex); }
                }, null);
            }
            catch (Exception ex)
            {
                promise.TrySetException(ex);
            }
            return promise.Future;
        }

        /// <summary>
        /// Runs CPU work on a pool thread. This is the one place in the library
        /// where a thread does the waiting, because CPU work has no other way to happen.
        /// </summary>
        public static IFuture<T> Run<T>(Func<T> work)
        {
            return Run(work, CancelToken.None);
        }

        /// <summary>
        /// Same, with a token. If it is already canceled when the work item
        /// starts, the work never runs. Once running, the work has to check the
        /// token itself; nothing can stop a thread from the outside, and nothing should.
        /// </summary>
        public static IFuture<T> Run<T>(Func<T> work, CancelToken token)
        {
            if (work == null) throw new ArgumentNullException("work");
            Promise<T> promise = new Promise<T>();
            ThreadPool.QueueUserWorkItem(delegate
            {
                if (token.IsCancelRequested) { promise.TrySetCanceled(); return; }
                try { promise.TrySetResult(work()); }
#if NETCF
                catch (FutureCanceledException) { promise.TrySetCanceled(); }
#else
                catch (OperationCanceledException) { promise.TrySetCanceled(); }
#endif
                catch (Exception ex) { promise.TrySetException(ex); }
            });
            return promise.Future;
        }

        public static IFuture Run(Action work)
        {
            if (work == null) throw new ArgumentNullException("work");
            return Run<VoidResult>(delegate { work(); return VoidResult.Value; });
        }

        /// <summary>
        /// Done when every input is done. No thread waits; each input's callback
        /// decrements a counter, and whoever brings it to zero completes the result.
        /// If any input failed, the result fails with all of the failures, in order.
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
            // One slot per input, so the failures come out in input order whatever order
            // the inputs finished in. The fuzz suite caught the first version, which
            // appended to a list as each input completed.
            Exception[] faults = new Exception[futures.Length];
            bool[] anyCanceled = new bool[1];

            for (int i = 0; i < futures.Length; i++)
            {
                IFuture future = futures[i];
                if (future == null) throw new ArgumentException("A null future was passed to WhenAll.", "futures");
                int slot = i;
                // This is library plumbing, so it uses the no-context awaiter. Hopping to
                // a UI thread here would be wasted work; the caller's own await does that.
                IAwaiter awaiter = future.ContinueOnAnyThread();
                awaiter.OnCompleted(delegate
                {
                    if (future.IsFaulted)
                    {
                        faults[slot] = future.Exception;
                    }
                    else if (future.IsCanceled)
                    {
                        anyCanceled[0] = true;
                    }

                    // The decrement is a full fence, so the last one in sees every slot.
                    if (Interlocked.Decrement(ref remaining[0]) != 0) return;

                    List<Exception> inOrder = null;
                    for (int j = 0; j < faults.Length; j++)
                    {
                        if (faults[j] == null) continue;
                        if (inOrder == null) inOrder = new List<Exception>();
                        inOrder.Add(faults[j]);
                    }
                    if (inOrder != null) promise.TrySetException(new AggregateFutureException(inOrder));
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
