using System;

namespace MMP.AsyncProxy
{
    /// <summary>The builder for an async method that finishes with "done" and no value.</summary>
    public struct AsyncMethodBuilder
    {
        private AsyncMethodBuilder<VoidResult> _inner;

        public static AsyncMethodBuilder Create()
        {
            AsyncMethodBuilder builder = new AsyncMethodBuilder();
            builder._inner = AsyncMethodBuilder<VoidResult>.Create();
            return builder;
        }

        public IFuture Future { get { return _inner.Future; } }

        public void Start<TStateMachine>(ref TStateMachine stateMachine) where TStateMachine : IAsyncStateMachine
        {
            _inner.Start(ref stateMachine);
        }

        public void AwaitOnCompleted<TAwaiter, TStateMachine>(ref TAwaiter awaiter, ref TStateMachine stateMachine)
            where TAwaiter : IAwaiter
            where TStateMachine : IAsyncStateMachine
        {
            _inner.AwaitOnCompleted(ref awaiter, ref stateMachine);
        }

        public void SetResult()
        {
            _inner.SetResult(VoidResult.Value);
        }

        public void SetException(Exception exception)
        {
            _inner.SetException(exception);
        }
    }
}
