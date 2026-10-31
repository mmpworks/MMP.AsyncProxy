using System;

namespace MMP.AsyncProxy
{
    /// <summary>
    /// The read-only view of a <see cref="CancelSource"/>. A struct, so passing
    /// it around costs one reference copy. <see cref="None"/> is a token nobody
    /// can cancel, for the callers that have no source to give you.
    /// </summary>
    public struct CancelToken
    {
        private readonly CancelSource _source;

        internal CancelToken(CancelSource source)
        {
            _source = source;
        }

        /// <summary>A token that never cancels. Pass it when you have nothing better.</summary>
        public static CancelToken None { get { return new CancelToken(null); } }

        public bool CanBeCanceled { get { return _source != null; } }

        public bool IsCancelRequested
        {
            get { return _source != null && _source.IsCancelRequested; }
        }

        /// <summary>
        /// Call this at the top of a loop body or before expensive work. It is the
        /// cooperative half of cancellation: nobody stops your code, your code stops itself.
        /// </summary>
        public void ThrowIfCancelRequested()
        {
            if (IsCancelRequested) throw new FutureCanceledException();
        }

        /// <summary>
        /// "Tell me when." Dispose the handle to take the callback back. On a
        /// token that cannot cancel this does nothing and returns an empty handle.
        /// </summary>
        public IDisposable Register(Action callback)
        {
            if (_source == null) return EmptyDisposable.Instance;
            return _source.Register(callback);
        }

        private sealed class EmptyDisposable : IDisposable
        {
            public static readonly EmptyDisposable Instance = new EmptyDisposable();
            public void Dispose() { }
        }
    }
}
