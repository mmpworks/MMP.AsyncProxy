using System;
using System.Collections.Generic;

namespace MMP.AsyncProxy.Sdk
{
    /// <summary>
    /// docs/sdk.md, "The fast path costs nothing". A step that is already complete never parks
    /// and never allocates an awaiter. So a tray offers TryTake beside TakeAsync, and a loop
    /// tries first and yields only when the try fails.
    /// </summary>
    public static class FastPath
    {
        /// <summary>A one-slot-at-a-time queue with a synchronous door and an async door.</summary>
        public sealed class Tray<T>
        {
            private readonly object _gate = new object();
            private readonly Queue<T> _items = new Queue<T>();
            private readonly Queue<Promise<T>> _waiting = new Queue<Promise<T>>();
            private bool _closed;

            public bool TryTake(out T item)
            {
                lock (_gate)
                {
                    if (_items.Count > 0) { item = _items.Dequeue(); return true; }
                }
                item = default(T);
                return false;
            }

            public IFuture<T> TakeAsync()
            {
                Promise<T> promise = new Promise<T>(PromiseOptions.RunContinuationsAsynchronously);
                lock (_gate)
                {
                    if (_items.Count > 0) promise.SetResult(_items.Dequeue());
                    else if (_closed) promise.SetCanceled();
                    else _waiting.Enqueue(promise);
                }
                return promise.Future;
            }

            public void Put(T item)
            {
                Promise<T> waiter = null;
                lock (_gate)
                {
                    if (_waiting.Count > 0) waiter = _waiting.Dequeue();
                    else _items.Enqueue(item);
                }
                if (waiter != null) waiter.TrySetResult(item);
            }

            /// <summary>Every waiting taker ends Canceled; the loop reads that as "stop".</summary>
            public void Close()
            {
                List<Promise<T>> waiters = new List<Promise<T>>();
                lock (_gate)
                {
                    _closed = true;
                    while (_waiting.Count > 0) waiters.Add(_waiting.Dequeue());
                }
                for (int i = 0; i < waiters.Count; i++) waiters[i].TrySetCanceled();
            }
        }

        /// <summary>Drains the tray until it closes, handing every item to <paramref name="handle"/>. Try first, yield only on a miss.</summary>
        public static IFuture Drain<T>(Tray<T> tray, Action<T> handle)
        {
            return AsyncProxy.Run(DrainBody(tray, handle));
        }

        private static IEnumerable<IFuture> DrainBody<T>(Tray<T> tray, Action<T> handle)
        {
            while (true)
            {
                T item;
                if (!tray.TryTake(out item))
                {
                    IFuture<T> next = tray.TakeAsync();
                    yield return Futures.Observe(next);
                    if (next.IsCanceled) yield break;
                    item = next.Result;
                }
                handle(item);
            }
        }
    }
}
