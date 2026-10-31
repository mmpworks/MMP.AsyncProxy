using System;
using System.Threading;

namespace MMP.AsyncProxy
{
    /// <summary>
    /// The TaskAwaiter shape. Captures the SynchronizationContext at OnCompleted
    /// and posts the continuation back to it, unless built by ContinueOnAnyThread.
    /// </summary>
    public struct FutureAwaiter<T> : IAwaiter<T>
    {
        private readonly Promise<T> _promise;
        private readonly bool _continueOnCapturedContext;

        internal FutureAwaiter(Promise<T> promise, bool continueOnCapturedContext)
        {
            _promise = promise;
            _continueOnCapturedContext = continueOnCapturedContext;
        }

        public bool IsCompleted { get { return _promise.IsCompleted; } }

        public void OnCompleted(Action continuation)
        {
            SynchronizationContext context = _continueOnCapturedContext ? SynchronizationContext.Current : null;
            if (context == null)
            {
                _promise.RegisterContinuation(continuation);
                return;
            }
            _promise.RegisterContinuation(delegate { context.Post(delegate { continuation(); }, null); });
        }

        public T GetResult()
        {
            return _promise.GetResultCore();
        }

        void IAwaiter.GetResult()
        {
            _promise.GetResultCore();
        }
    }
}
