using System;
using System.Collections.Generic;

namespace MMP.AsyncProxy
{
    /// <summary>
    /// The side that pulls the cord. You keep the source. You hand out its
    /// <see cref="Token"/>. Anyone with the token can ask "has someone canceled?"
    /// or register a callback for when it happens. Only the source can say yes.
    /// Same split as CancellationTokenSource and CancellationToken, which .NET 4.0 added.
    /// </summary>
    public sealed class CancelSource : IDisposable
    {
        private readonly object _gate = new object();
        private bool _canceled;
        private List<Action> _callbacks;

        public CancelToken Token { get { return new CancelToken(this); } }

        public bool IsCancelRequested
        {
            get { lock (_gate) { return _canceled; } }
        }

        /// <summary>
        /// Flips the flag and runs every registered callback, on this thread, in
        /// registration order. Calling it twice does nothing the second time.
        /// </summary>
        public void Cancel()
        {
            List<Action> toRun;
            lock (_gate)
            {
                if (_canceled) return;
                _canceled = true;
                toRun = _callbacks;
                _callbacks = null;
            }
            if (toRun == null) return;
            for (int i = 0; i < toRun.Count; i++) toRun[i]();
        }

        /// <summary>
        /// Same two-case shape as Promise.RegisterContinuation. Already canceled:
        /// run it now. Otherwise: remember it. The returned handle unregisters.
        /// </summary>
        internal IDisposable Register(Action callback)
        {
            if (callback == null) throw new ArgumentNullException("callback");
            lock (_gate)
            {
                if (!_canceled)
                {
                    if (_callbacks == null) _callbacks = new List<Action>(1);
                    _callbacks.Add(callback);
                    return new Registration(this, callback);
                }
            }
            callback();
            return Registration.Empty;
        }

        private void Unregister(Action callback)
        {
            lock (_gate)
            {
                if (_callbacks != null) _callbacks.Remove(callback);
            }
        }

        public void Dispose()
        {
            lock (_gate) { _callbacks = null; }
        }

        private sealed class Registration : IDisposable
        {
            public static readonly Registration Empty = new Registration(null, null);
            private CancelSource _source;
            private readonly Action _callback;

            public Registration(CancelSource source, Action callback)
            {
                _source = source;
                _callback = callback;
            }

            public void Dispose()
            {
                CancelSource source = _source;
                if (source == null) return;
                _source = null;
                source.Unregister(_callback);
            }
        }
    }
}
