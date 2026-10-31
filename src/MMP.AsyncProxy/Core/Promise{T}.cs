using System;
using System.Collections.Generic;
using System.Threading;

namespace MMP.AsyncProxy
{
    /// <summary>
    /// The counter where answers get filled in. You keep the Promise. You hand
    /// out its Future. Whoever holds the Future can wait or subscribe, and that
    /// is all they can do. This is TaskCompletionSource, and the split exists
    /// so a caller can never complete work it did not do. The Future is a
    /// separate sealed object, not this one wearing an interface, so a cast
    /// cannot undo the split.
    ///
    /// When you call SetResult, the callbacks run right there, on your thread,
    /// before SetResult returns. TaskCompletionSource does the same by default.
    /// Build it with runContinuationsAsync = true and they go to the pool instead,
    /// which is TaskCreationOptions.RunContinuationsAsynchronously in .NET 4.6.
    /// </summary>
    public sealed class Promise<T>
    {
        /// <summary>
        /// Where GetResult stashes the first stack trace before it rethrows.
        /// See <see cref="PreserveStackTrace"/> for why.
        /// </summary>
        public const string OriginalStackTraceKey = "MMP.AsyncProxy.OriginalStackTrace";

        private readonly object _gate = new object();
        private readonly bool _runContinuationsAsync;
        private FutureStatus _status;
        private T _result;
        private Exception _exception;
        private List<Action> _continuations;
        private ManualResetEvent _done;
        private readonly Future<T> _future;

        public Promise() : this(false) { }

        /// <summary>
        /// Pass true when the completer must never run someone else's code on its
        /// own stack. A lock holder, a deep chain, or a thread with a deadline.
        /// </summary>
        public Promise(bool runContinuationsAsync)
        {
            _runContinuationsAsync = runContinuationsAsync;
            _future = new Future<T>(this);
        }

        /// <summary>The view to give away. Same one every time, so reference equality works on it.</summary>
        public IFuture<T> Future { get { return _future; } }

        public FutureStatus Status
        {
            get { lock (_gate) { return _status; } }
        }

        public bool IsCompleted { get { return Status != FutureStatus.Pending; } }
        public bool IsFaulted { get { return Status == FutureStatus.Faulted; } }
        public bool IsCanceled { get { return Status == FutureStatus.Canceled; } }

        public Exception Exception
        {
            get { lock (_gate) { return _exception; } }
        }

        public T Result
        {
            get
            {
                Wait();
                return GetResultCore();
            }
        }

        public bool TrySetResult(T result)
        {
            return Complete(FutureStatus.Succeeded, result, null);
        }

        public bool TrySetException(Exception exception)
        {
            if (exception == null) throw new ArgumentNullException("exception");
            return Complete(FutureStatus.Faulted, default(T), exception);
        }

        public bool TrySetCanceled()
        {
            return Complete(FutureStatus.Canceled, default(T), null);
        }

        public void SetResult(T result)
        {
            if (!TrySetResult(result)) throw AlreadyCompleted();
        }

        public void SetException(Exception exception)
        {
            if (!TrySetException(exception)) throw AlreadyCompleted();
        }

        public void SetCanceled()
        {
            if (!TrySetCanceled()) throw AlreadyCompleted();
        }

        public void Wait()
        {
            // The event is made on first use. Most futures are awaited, never waited on,
            // so most of them never pay for a kernel handle.
            ManualResetEvent handle;
            lock (_gate)
            {
                if (_status != FutureStatus.Pending) return;
                if (_done == null) _done = new ManualResetEvent(false);
                handle = _done;
            }
            handle.WaitOne();
        }

        public IAwaiter<T> GetAwaiter()
        {
            return new FutureAwaiter<T>(this, true);
        }

        public IAwaiter<T> ContinueOnAnyThread()
        {
            return new FutureAwaiter<T>(this, false);
        }

        /// <summary>
        /// Two cases. Already done: run the callback now, on this thread. Still
        /// pending: put it on the list, and Complete will run it later. The lock
        /// closes the gap where a completion could slip in between the check and the add.
        /// </summary>
        internal void RegisterContinuation(Action continuation)
        {
            if (continuation == null) throw new ArgumentNullException("continuation");
            lock (_gate)
            {
                if (_status == FutureStatus.Pending)
                {
                    if (_continuations == null) _continuations = new List<Action>(1);
                    _continuations.Add(continuation);
                    return;
                }
            }
            continuation();
        }

        /// <summary>Value, or throw. Only called once the future has settled.</summary>
        internal T GetResultCore()
        {
            FutureStatus status;
            Exception exception;
            T result;
            lock (_gate)
            {
                status = _status;
                exception = _exception;
                result = _result;
            }
            switch (status)
            {
                case FutureStatus.Succeeded:
                    return result;
                case FutureStatus.Canceled:
                    throw new FutureCanceledException();
                case FutureStatus.Faulted:
                    PreserveStackTrace(exception);
                    throw exception;
                default:
                    throw new InvalidOperationException("GetResult called before the future completed.");
            }
        }

        private bool Complete(FutureStatus status, T result, Exception exception)
        {
            // Settle the state under the lock, then let go of it before running
            // anyone's callback. A callback that takes its own lock, or completes
            // another promise, must never run while we hold ours.
            List<Action> toRun;
            ManualResetEvent toSignal;
            lock (_gate)
            {
                if (_status != FutureStatus.Pending) return false;
                _status = status;
                _result = result;
                _exception = exception;
                toRun = _continuations;
                _continuations = null;
                toSignal = _done;
            }
            if (toSignal != null) toSignal.Set();
            if (toRun != null)
            {
                if (_runContinuationsAsync)
                {
                    ThreadPool.QueueUserWorkItem(delegate
                    {
                        for (int i = 0; i < toRun.Count; i++) toRun[i]();
                    });
                }
                else
                {
                    for (int i = 0; i < toRun.Count; i++) toRun[i]();
                }
            }
            return true;
        }

        /// <summary>
        /// In .NET 3.5, "throw ex" resets the stack trace to the throw site, so the
        /// line that failed is gone from the log. Newer runtimes fix this with
        /// ExceptionDispatchInfo. We cannot. What we can do is copy the first
        /// trace into Data before the rethrow, so a log still has the evidence.
        /// </summary>
        private static void PreserveStackTrace(Exception exception)
        {
            if (exception.Data.Contains(OriginalStackTraceKey)) return;
            exception.Data[OriginalStackTraceKey] = exception.StackTrace;
        }

        private static InvalidOperationException AlreadyCompleted()
        {
            return new InvalidOperationException("The promise was already completed.");
        }
    }
}
