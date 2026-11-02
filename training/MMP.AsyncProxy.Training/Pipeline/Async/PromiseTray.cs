using System;
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

        /// <summary>
        /// The fast path in: true when the item went in now, with no promise made. False
        /// when the tray is full or closed, and then the producer calls PutAsync. A stage
        /// tries this first, the way a Channel writer tries TryWrite before it waits.
        /// </summary>
        public bool TryPut(T item)
        {
            Promise<T> wakeTaker = null;
            lock (_gate)
            {
                if (_closed || _holding) return false;
                if (_waitingTaker != null) { wakeTaker = _waitingTaker; _waitingTaker = null; }
                else if (_items.Count < _capacity) { _items.Enqueue(item); return true; }
                else return false;
            }
            wakeTaker.TrySetResult(item);               // outside the lock
            return true;
        }

        /// <summary>
        /// True when the item went in (now or once there was room); false if the tray
        /// closed first. The decision to park is taken under the same lock as the check
        /// for a waiting consumer. A first draft checked in one lock and parked in a
        /// second, and a consumer that drained the tray and parked in between left both
        /// sides waiting on each other; the bench hung on the 10,000th item.
        /// </summary>
        public IFuture<bool> PutAsync(T item)
        {
            Promise<T> wakeTaker = null;
            lock (_gate)
            {
                if (_closed) return Futures.False;
                if (_holding) throw new InvalidOperationException("one producer per tray: an item is already held at the door");
                if (_waitingTaker != null)
                {
                    wakeTaker = _waitingTaker;          // the consumer is waiting: hand it straight over
                    _waitingTaker = null;
                }
                else if (_items.Count < _capacity)
                {
                    _items.Enqueue(item);
                    return Futures.True;                // shared, so the common case allocates nothing
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
            return Futures.True;
        }

        /// <summary>
        /// The fast path out: true with the next item when one is there, with no promise
        /// made. Taking one may let the held item in and pay the producer's IOU.
        /// </summary>
        public bool TryTake(out T item)
        {
            Promise<bool> wakePutter = null;
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
                else { item = default(T); return false; }
            }
            if (wakePutter != null) wakePutter.TrySetResult(true);
            return true;
        }

        /// <summary>The next item, now or when one arrives. Cancelled when the tray is closed and drained.</summary>
        public IFuture<T> TakeAsync()
        {
            T item;
            if (TryTake(out item))
            {
                Promise<T> ready = new Promise<T>(true);
                ready.SetResult(item);
                return ready.Future;
            }
            lock (_gate)
            {
                if (_items.Count > 0 || _holding) return TakeAsync();   // an item landed between the two calls
                if (_closed) return Cancelled();
                _waitingTaker = new Promise<T>(true);   // empty: hand out an IOU
                return _waitingTaker.Future;
            }
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

        private static IFuture<T> Cancelled()
        {
            Promise<T> p = new Promise<T>(true);
            p.SetCanceled();
            return p.Future;
        }
    }
}
