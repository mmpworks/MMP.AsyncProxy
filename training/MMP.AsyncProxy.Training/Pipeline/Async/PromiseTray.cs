using System.Collections.Generic;

namespace MMP.AsyncProxy.Training.Pipeline.Async
{
    /// <summary>
    /// The same tray with two IOUs instead of two parked threads. A producer that
    /// finds the tray full gets a pending future and the item is held at the door;
    /// the next take lets it in and pays the IOU. A consumer that finds the tray
    /// empty gets a pending future; the next put hands the item straight over.
    /// One producer and one consumer, which is what a pipeline stage has. Every
    /// promise is built to run its continuation on the pool, and every promise is
    /// completed outside the lock, so no stage ever runs under another's lock.
    /// </summary>
    public sealed class PromiseTray<T>
    {
        private readonly object _gate = new object();
        private readonly Queue<T> _items = new Queue<T>();
        private readonly int _capacity;
        private Promise<T> _waitingTaker;
        private Promise<bool> _waitingPutter;
        private T _held;
        private bool _holding;
        private bool _closed;

        public PromiseTray(int capacity) { _capacity = capacity; }

        /// <summary>True when the item went in (now or once there was room); false if the tray closed first.</summary>
        public IFuture<bool> PutAsync(T item)
        {
            Promise<T> wakeTaker = null;
            lock (_gate)
            {
                if (_closed) return Done(false);
                if (_waitingTaker != null)
                {
                    wakeTaker = _waitingTaker;          // the consumer is waiting: hand it straight over
                    _waitingTaker = null;
                }
                else if (_items.Count < _capacity)
                {
                    _items.Enqueue(item);
                    return Done(true);
                }
                else
                {
                    _held = item;                       // full: hold the item at the door, hand out an IOU
                    _holding = true;
                    _waitingPutter = new Promise<bool>(true);
                    return _waitingPutter.Future;
                }
            }
            wakeTaker.TrySetResult(item);               // outside the lock
            return Done(true);
        }

        /// <summary>The next item, now or when one arrives. Cancelled when the tray is closed and drained.</summary>
        public IFuture<T> TakeAsync()
        {
            Promise<bool> wakePutter = null;
            T item;
            lock (_gate)
            {
                if (_items.Count > 0)
                {
                    item = _items.Dequeue();
                    if (_holding)                       // room now: let the held item in, pay the producer's IOU
                    {
                        _items.Enqueue(_held);
                        _held = default(T);
                        _holding = false;
                        wakePutter = _waitingPutter;
                        _waitingPutter = null;
                    }
                }
                else if (_holding)                      // capacity 0 would land here; the held item is the next item
                {
                    item = _held;
                    _held = default(T);
                    _holding = false;
                    wakePutter = _waitingPutter;
                    _waitingPutter = null;
                }
                else if (_closed) return Cancelled();
                else
                {
                    _waitingTaker = new Promise<T>(true);   // empty: hand out an IOU
                    return _waitingTaker.Future;
                }
            }
            if (wakePutter != null) wakePutter.TrySetResult(true);
            Promise<T> ready = new Promise<T>(true);
            ready.SetResult(item);
            return ready.Future;
        }

        /// <summary>No more puts. A waiting consumer is woken with a cancel once the tray is drained.</summary>
        public void Close()
        {
            Promise<T> wakeTaker = null;
            Promise<bool> wakePutter = null;
            lock (_gate)
            {
                _closed = true;
                if (_items.Count == 0 && !_holding) { wakeTaker = _waitingTaker; _waitingTaker = null; }
                wakePutter = _waitingPutter;
                _waitingPutter = null;
            }
            if (wakeTaker != null) wakeTaker.TrySetCanceled();
            if (wakePutter != null) wakePutter.TrySetResult(false);
        }

        private static IFuture<bool> Done(bool value)
        {
            Promise<bool> p = new Promise<bool>(true);
            p.SetResult(value);
            return p.Future;
        }

        private static IFuture<T> Cancelled()
        {
            Promise<T> p = new Promise<T>(true);
            p.SetCanceled();
            return p.Future;
        }
    }
}
