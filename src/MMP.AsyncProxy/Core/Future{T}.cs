using System;

namespace MMP.AsyncProxy
{
    /// <summary>
    /// The read side, as its own object. It holds the promise and forwards the
    /// read members. It is sealed, and it is not the promise, so there is no cast
    /// that gets a caller from here to SetResult. One allocation per promise buys
    /// that guarantee. TaskCompletionSource and Task have the same arrangement.
    /// </summary>
    public sealed class Future<T> : IFuture<T>
    {
        private readonly Promise<T> _promise;

        internal Future(Promise<T> promise)
        {
            _promise = promise;
        }

        public FutureStatus Status { get { return _promise.Status; } }
        public bool IsCompleted { get { return _promise.IsCompleted; } }
        public bool IsFaulted { get { return _promise.IsFaulted; } }
        public bool IsCanceled { get { return _promise.IsCanceled; } }
        public Exception Exception { get { return _promise.Exception; } }
        public T Result { get { return _promise.Result; } }

        public void Wait()
        {
            _promise.Wait();
        }

        public IAwaiter<T> GetAwaiter()
        {
            return _promise.GetAwaiter();
        }

        IAwaiter IFuture.GetAwaiter()
        {
            return _promise.GetAwaiter();
        }

        public IAwaiter<T> ContinueOnAnyThread()
        {
            return _promise.ContinueOnAnyThread();
        }

        IAwaiter IFuture.ContinueOnAnyThread()
        {
            return _promise.ContinueOnAnyThread();
        }
    }
}
