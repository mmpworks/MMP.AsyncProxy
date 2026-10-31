using System;
using System.Threading;

namespace MMP.AsyncProxy
{
    /// <summary>
    /// The thing an await talks to. It knows two facts: which promise it watches,
    /// and whether to bring the continuation back to the thread that started it.
    ///
    /// That second fact is the whole UI-thread story. A WinForms or WPF thread
    /// has a SynchronizationContext. If we capture it here and Post the callback
    /// to it later, the code after the await runs on the UI thread again, and
    /// touching a control is safe. Skip the capture and the callback runs on
    /// whatever thread finished the work.
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
            // Capture happens here, at the await, on the awaiting thread.
            // That is the only moment we know which context the caller meant.
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
