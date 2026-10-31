using System;

namespace MMP.AsyncProxy
{
    /// <summary>A promise with no value. Wraps Promise&lt;VoidResult&gt; so one implementation serves both shapes.</summary>
    public sealed class Promise
    {
        private readonly Promise<VoidResult> _inner = new Promise<VoidResult>();

        public IFuture Future { get { return _inner; } }

        public bool TrySetResult() { return _inner.TrySetResult(VoidResult.Value); }
        public bool TrySetException(Exception exception) { return _inner.TrySetException(exception); }
        public bool TrySetCanceled() { return _inner.TrySetCanceled(); }

        public void SetResult() { _inner.SetResult(VoidResult.Value); }
        public void SetException(Exception exception) { _inner.SetException(exception); }
        public void SetCanceled() { _inner.SetCanceled(); }
    }
}
