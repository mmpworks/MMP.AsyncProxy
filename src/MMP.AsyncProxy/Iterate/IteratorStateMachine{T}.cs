using System;
using System.Collections.Generic;

namespace MMP.AsyncProxy
{
    /// <summary>
    /// Drives a C# 2.0 iterator as if the compiler had emitted an async state
    /// machine for it. Each yielded future is an await. The iterator's own
    /// compiler-generated state field plays the part of the async machine's state.
    /// </summary>
    internal sealed class IteratorStateMachine<T> : IAsyncStateMachine
    {
        private readonly IEnumerator<IFuture> _steps;
        private readonly Return<T> _return;
        private AsyncMethodBuilder<T> _builder;
        private IAwaiter _pending;

        internal IteratorStateMachine(IEnumerator<IFuture> steps, Return<T> ret)
        {
            _steps = steps;
            _return = ret;
            _builder = AsyncMethodBuilder<T>.Create();
        }

        internal IFuture<T> Future { get { return _builder.Future; } }

        internal void Start()
        {
            IteratorStateMachine<T> self = this;
            _builder.Start(ref self);
        }

        public void MoveNext()
        {
            try
            {
                while (true)
                {
                    if (_pending != null)
                    {
                        IAwaiter finished = _pending;
                        _pending = null;
                        finished.GetResult();
                    }

                    if (!_steps.MoveNext())
                    {
                        _steps.Dispose();
                        _builder.SetResult(_return.Value);
                        return;
                    }

                    IFuture step = _steps.Current;
                    if (step == null) throw new InvalidOperationException("The iterator yielded a null future.");

                    IAwaiter awaiter = step.GetAwaiter();
                    if (awaiter.IsCompleted)
                    {
                        awaiter.GetResult();
                        continue;
                    }

                    _pending = awaiter;
                    IteratorStateMachine<T> self = this;
                    _builder.AwaitOnCompleted(ref awaiter, ref self);
                    return;
                }
            }
            catch (Exception ex)
            {
                _steps.Dispose();
                _builder.SetException(ex);
            }
        }

        public void SetStateMachine(IAsyncStateMachine stateMachine)
        {
        }
    }
}
