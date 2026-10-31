using System;
using System.Threading;

namespace MMP.AsyncProxy
{
    /// <summary>
    /// The compiler's helper. A state machine keeps one of these as a field and
    /// makes four kinds of call: Start once, AwaitOnCompleted every time it has
    /// to suspend, and SetResult or SetException once at the end.
    ///
    /// It also carries ExecutionContext across the gap. Set a logical call
    /// context value before an await and it is still there after, even though
    /// the method may wake up on a different thread. The builder grabs the
    /// context at suspend time and puts it back right before MoveNext.
    /// </summary>
    public struct AsyncMethodBuilder<T>
    {
        private Promise<T> _promise;

        public static AsyncMethodBuilder<T> Create()
        {
            AsyncMethodBuilder<T> builder = new AsyncMethodBuilder<T>();
            builder._promise = new Promise<T>();
            return builder;
        }

        /// <summary>What the caller of the async method gets back.</summary>
        public IFuture<T> Future { get { return _promise; } }

        public void Start<TStateMachine>(ref TStateMachine stateMachine) where TStateMachine : IAsyncStateMachine
        {
            if (stateMachine == null) throw new ArgumentNullException("stateMachine");
            stateMachine.MoveNext();
        }

        public void AwaitOnCompleted<TAwaiter, TStateMachine>(ref TAwaiter awaiter, ref TStateMachine stateMachine)
            where TAwaiter : IAwaiter
            where TStateMachine : IAsyncStateMachine
        {
            IAsyncStateMachine machine = stateMachine;
            // Capture returns null when flow is suppressed. Then there is nothing to carry.
            ExecutionContext captured = ExecutionContext.Capture();
            if (captured == null)
            {
                awaiter.OnCompleted(machine.MoveNext);
                return;
            }
            awaiter.OnCompleted(delegate
            {
                ExecutionContext.Run(captured, delegate { machine.MoveNext(); }, null);
            });
        }

        public void SetResult(T result)
        {
            _promise.TrySetResult(result);
        }

        /// <summary>
        /// A FutureCanceledException escaping the body means "someone pulled the
        /// cord", so the future ends Canceled, not Faulted. Any other exception is a fault.
        /// The real builder makes the same call for OperationCanceledException.
        /// </summary>
        public void SetException(Exception exception)
        {
            if (exception is OperationCanceledException) _promise.TrySetCanceled();
            else _promise.TrySetException(exception);
        }
    }
}
