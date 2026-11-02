using System;
using System.Threading;

namespace MMP.AsyncProxy.Training.Mailbox.Threaded
{
    /// <summary>
    /// A clerk with their own thread. The thread is made when the clerk sits
    /// down and lives until the tray closes. Between slips it is blocked in the
    /// kernel inside the tray's Monitor.Wait: a reserved stack, a kernel object,
    /// and a scheduler entry, all for a clerk doing nothing.
    /// </summary>
    public sealed class ThreadedClerk<T> : IClerk
    {
        private readonly string _name;
        private readonly ThreadedInTray<T> _tray;
        private readonly Action<T> _handle;
        private readonly Thread _thread;
        private volatile bool _running = true;
        private int _handled;
        private int _busy;

        public ThreadedClerk(string name, ThreadedInTray<T> tray, Action<T> handle)
        {
            _name = name;
            _tray = tray;
            _handle = handle;
            _thread = new Thread(Loop);
            _thread.IsBackground = true;
            _thread.Name = "clerk:" + name;
            _thread.Start();
        }

        public string Name { get { return _name; } }
        public bool IsRunning { get { return _running; } }
        public int Handled { get { return Thread.VolatileRead(ref _handled); } }

        private void Loop()
        {
            try
            {
                T slip;
                while (_tray.TakeBlocking(out slip))
                {
                    Interlocked.Exchange(ref _busy, 1);
                    try { _handle(slip); }
                    catch (Exception) { /* a slip that throws is still a slip handled; the clerk stays seated */ }
                    finally
                    {
                        Interlocked.Increment(ref _handled);
                        _tray.Handled();
                        Interlocked.Exchange(ref _busy, 0);
                    }
                }
            }
            finally { _running = false; }
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
            _tray.Close();
            // A background thread: if it is stuck inside a handler, process exit takes it.
            _thread.Join(2000);
        }
    }
}
