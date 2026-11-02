using System;
using System.Collections.Generic;
using System.Threading;

namespace MMP.AsyncProxy.Training.Mailbox.Async
{
    /// <summary>
    /// A clerk with no thread. The loop is a C# 2 iterator, and "yield return"
    /// is the await. When the tray is empty the loop parks: its locals live in
    /// the iterator's fields, its place lives in the state field, and nothing
    /// else is held. A post completes the future, the pool runs MoveNext, and
    /// the loop picks up on the line after the yield.
    /// </summary>
    public sealed class IteratorClerk<T> : IClerk
    {
        private readonly string _name;
        private readonly PromiseInTray<T> _tray;
        private readonly Action<T> _handle;
        private readonly IFuture _loop;
        private volatile bool _stopping;
        private int _handled;
        private int _busy;

        public IteratorClerk(string name, PromiseInTray<T> tray, Action<T> handle)
        {
            _name = name;
            _tray = tray;
            _handle = handle;
            _loop = AsyncProxy.Run(Loop());
        }

        public string Name { get { return _name; } }
        public bool IsRunning { get { return !_loop.IsCompleted; } }
        public int Handled { get { return Thread.VolatileRead(ref _handled); } }

        /// <summary>The whole worker, as a to-do list the library walks. Compare it line by line with ThreadedClerk.Loop.</summary>
        private IEnumerable<IFuture> Loop()
        {
            while (!_stopping)
            {
                IFuture<T> next = _tray.TakeAsync();
                // Observe, so a cancelled take (the tray closed) ends the loop instead of faulting it.
                yield return Futures.Observe(next);
                if (next.IsCanceled || next.IsFaulted || _stopping) yield break;

                Interlocked.Exchange(ref _busy, 1);
                try { _handle(next.Result); }
                catch (Exception) { /* a slip that throws is still a slip handled; the clerk stays seated */ }
                finally
                {
                    Interlocked.Increment(ref _handled);
                    _tray.Handled();
                    Interlocked.Exchange(ref _busy, 0);
                }
            }
        }

        public bool WaitUntilIdle(int timeoutMs)
        {
            DateTime deadline = DateTime.UtcNow.AddMilliseconds(timeoutMs);
            while (_tray.Pending > 0 || Thread.VolatileRead(ref _busy) == 1)
            {
                if (DateTime.UtcNow >= deadline) return false;
                Thread.Sleep(1);
            }
            return true;
        }

        public void Dispose()
        {
            _stopping = true;
            _tray.Close();
            // The pending future cancels on close and the machine finishes on a pool thread. Wait for
            // that with a bound, the way ThreadedClerk waits with Thread.Join(2000). The first draft
            // polled IsCompleted with Thread.Sleep(1), and on Windows one millisecond of sleep is a
            // 15 ms timer tick, so a thousand clerks took fifteen seconds to go home. The bench caught it.
            // IFuture.Wait() has no timeout in this library version; this is that overload written by hand.
            using (ManualResetEvent done = new ManualResetEvent(false))
            {
                _loop.ContinueOnAnyThread().OnCompleted(delegate { done.Set(); });
                done.WaitOne(2000);
            }
        }
    }
}
