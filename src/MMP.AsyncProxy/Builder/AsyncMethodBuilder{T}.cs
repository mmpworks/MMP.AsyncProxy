using System;
using System.Threading;

namespace MMP.AsyncProxy
{
    /// <summary>
    /// The AsyncTaskMethodBuilder shape. A state machine holds one as a field and
    /// calls four things: Start once, AwaitOnCompleted at each suspend, then
    /// SetResult or SetException once at the end.
    /// Captures ExecutionContext at the suspend and restores it before MoveNext,
    /// so thread-local-style data set before an await is visible after it.
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

        /// <summary>The future the caller gets back from the async method.</summary>
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

        public void SetException(Exception exception)
        {
            _promise.TrySetException(exception);
        }
    }
}
