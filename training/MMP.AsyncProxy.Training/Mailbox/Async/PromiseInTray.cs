using System.Collections.Generic;
using System.Threading;

namespace MMP.AsyncProxy.Training.Mailbox.Async
{
    /// <summary>
    /// The same in-tray with one change: when the clerk asks for a slip and the
    /// tray is empty, the tray hands back an IOU (a pending future) instead of
    /// parking a thread. The next post pays the IOU, and that is what wakes the
    /// clerk, on whatever pool thread is free. No thread sleeps here.
    /// </summary>
    public sealed class PromiseInTray<T> : IInTray<T>
    {
        private readonly object _gate = new object();
        private readonly Queue<T> _slips = new Queue<T>();
        private readonly string _name;
        private readonly int _capacity;
        private Promise<T> _waiting;
        private int _pending;
        private bool _closed;

        public PromiseInTray(string name, int capacity)
        {
            _name = name;
            _capacity = capacity;
        }

        public string Name { get { return _name; } }
        public int Capacity { get { return _capacity; } }
        public int Pending { get { return Thread.VolatileRead(ref _pending); } }

        public bool TryPost(T slip)
        {
            Promise<T> wake = null;
            lock (_gate)
            {
                if (_closed) return false;
                if (_waiting != null)
                {
                    // The clerk is waiting on an IOU. Hand the slip straight to it; the queue is never touched.
                    wake = _waiting;
                    _waiting = null;
                }
                else if (_slips.Count >= _capacity) return false;
                else _slips.Enqueue(slip);
                Interlocked.Increment(ref _pending);
            }
            // Outside the lock, on purpose. The promise was built to run its continuation on the
            // pool, so this returns at once, and the clerk's code never runs while we hold _gate.
            if (wake != null) wake.TrySetResult(slip);
            return true;
        }

        public void Close()
        {
            Promise<T> wake;
            lock (_gate)
            {
                _closed = true;
                wake = _waiting;
                _waiting = null;
                _slips.Clear();
            }
            // A cancelled IOU is how the tray says "closed" to a clerk that is parked on it.
            if (wake != null) wake.TrySetCanceled();
        }

        /// <summary>
        /// The clerk's await. If a slip is queued the future is already complete,
        /// so the clerk's loop keeps going without parking: that is the fast path,
        /// and it allocates one promise. If the tray is empty the future is pending
        /// and the clerk parks on it. If the tray is closed the future is cancelled.
        /// </summary>
        internal IFuture<T> TakeAsync()
        {
            lock (_gate)
            {
                if (_slips.Count > 0)
                {
                    Promise<T> ready = new Promise<T>(true);
                    ready.SetResult(_slips.Dequeue());
                    return ready.Future;
                }
                if (_closed) return Cancelled();
                _waiting = new Promise<T>(true);
                return _waiting.Future;
            }
        }

        internal void Handled()
        {
            Interlocked.Decrement(ref _pending);
        }

        private static IFuture<T> Cancelled()
        {
            Promise<T> p = new Promise<T>(true);
            p.SetCanceled();
            return p.Future;
        }
    }
}
