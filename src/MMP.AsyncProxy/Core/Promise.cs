using System;

namespace MMP.AsyncProxy
{
    /// <summary>
    /// A promise with no value to deliver, only "done". Under the hood it is a
    /// Promise&lt;VoidResult&gt;, so there is one implementation to get right.
    /// </summary>
    public sealed class Promise
    {
        private readonly Promise<VoidResult> _inner;

        public Promise() : this(false) { }

        public Promise(bool runContinuationsAsync)
        {
            _inner = new Promise<VoidResult>(runContinuationsAsync);
        }

        public IFuture Future { get { return _inner.Future; } }

        public bool TrySetResult() { return _inner.TrySetResult(VoidResult.Value); }
        public bool TrySetException(Exception exception) { return _inner.TrySetException(exception); }
        public bool TrySetCanceled() { return _inner.TrySetCanceled(); }

        public void SetResult() { _inner.SetResult(VoidResult.Value); }
        public void SetException(Exception exception) { _inner.SetException(exception); }
        public void SetCanceled() { _inner.SetCanceled(); }
    }
}
