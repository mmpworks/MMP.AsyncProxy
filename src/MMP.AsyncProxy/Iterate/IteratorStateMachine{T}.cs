using System;
using System.Collections.Generic;

namespace MMP.AsyncProxy
{
    /// <summary>
    /// Here is the trick. C# 2.0 already had a compiler that turns a method into
    /// a state machine: the iterator. "yield return" saves the locals, records
    /// where it stopped, and returns. That is nine tenths of what "await" needs.
    ///
    /// This class supplies the last tenth. It pulls one future at a time from
    /// the iterator. If the future is done, it pulls the next. If the future is
    /// pending, it parks on it with the same builder the hand-written machine
    /// uses, and comes back when the future completes.
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
                    // Coming back from a suspend? Observe the step we parked on.
                    // If it failed, GetResult throws and the catch below faults the whole run.
                    if (_pending != null)
                    {
                        IAwaiter finished = _pending;
                        _pending = null;
                        finished.GetResult();
                    }

                    // Ask the iterator for its next future. No more? The method is done.
                    if (!_steps.MoveNext())
                    {
                        _steps.Dispose();
                        _builder.SetResult(_return.Value);
                        return;
                    }

                    IFuture step = _steps.Current;
                    if (step == null) throw new InvalidOperationException("The iterator yielded a null future.");

                    // Fast path: the future is already done, so no suspend. Keep going in this loop.
                    IAwaiter awaiter = step.GetAwaiter();
                    if (awaiter.IsCompleted)
                    {
                        awaiter.GetResult();
                        continue;
                    }

                    // Slow path: park here. The builder will call MoveNext again when the future completes.
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
