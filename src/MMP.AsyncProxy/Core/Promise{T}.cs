using System;
using System.Collections.Generic;
using System.Threading;

namespace MMP.AsyncProxy
{
    /// <summary>
    /// The one type that can complete a future. The TaskCompletionSource shape.
    /// Hand the <see cref="Future"/> view to callers so they can await but never complete.
    /// Continuations run inline on the thread that completes the promise, as
    /// TaskCompletionSource does by default.
    /// </summary>
    public sealed class Promise<T> : IFuture<T>
    {
        /// <summary>Key under which GetResult stores the stack trace a rethrow would wipe.</summary>
        public const string OriginalStackTraceKey = "MMP.AsyncProxy.OriginalStackTrace";

        private readonly object _gate = new object();
        private FutureStatus _status;
        private T _result;
        private Exception _exception;
        private List<Action> _continuations;
        private ManualResetEvent _done;

        /// <summary>The read-only view to hand out.</summary>
        public IFuture<T> Future { get { return this; } }

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

        IAwaiter IFuture.GetAwaiter()
        {
            return GetAwaiter();
        }

        public IAwaiter<T> ContinueOnAnyThread()
        {
            return new FutureAwaiter<T>(this, false);
        }

        IAwaiter IFuture.ContinueOnAnyThread()
        {
            return ContinueOnAnyThread();
        }

        /// <summary>Runs the continuation now if complete, else stores it for the completer to run.</summary>
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

        /// <summary>Value or throw. Caller guarantees completion.</summary>
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
                for (int i = 0; i < toRun.Count; i++) toRun[i]();
            }
            return true;
        }

        /// <summary>
        /// .NET 3.5 has no ExceptionDispatchInfo. A rethrow resets the stack.
        /// Keep the first stack in Data so a log still shows where the fault began.
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
