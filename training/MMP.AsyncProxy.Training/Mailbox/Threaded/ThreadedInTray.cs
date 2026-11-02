using System.Collections.Generic;
using System.Threading;

namespace MMP.AsyncProxy.Training.Mailbox.Threaded
{
    /// <summary>
    /// The 2008 in-tray: a queue under a lock, and a clerk's thread that sleeps
    /// inside Monitor.Wait when the queue is empty. A post pulses the monitor and
    /// the kernel wakes that one thread. This is what BlockingCollection does
    /// inside, written out, because .NET 3.5 did not ship BlockingCollection.
    /// </summary>
    public sealed class ThreadedInTray<T> : IInTray<T>
    {
        private readonly object _gate = new object();
        private readonly Queue<T> _slips = new Queue<T>();
        private readonly string _name;
        private readonly int _capacity;
        private int _pending;
        private bool _closed;

        public ThreadedInTray(string name, int capacity)
        {
            _name = name;
            _capacity = capacity;
        }

        public string Name { get { return _name; } }
        public int Capacity { get { return _capacity; } }
        public int Pending { get { return Thread.VolatileRead(ref _pending); } }

        public bool TryPost(T slip)
        {
            lock (_gate)
            {
                if (_closed || _slips.Count >= _capacity) return false;
                _slips.Enqueue(slip);
                Interlocked.Increment(ref _pending);
                // One clerk is seated here, so one wake-up is enough. PulseAll would be safe and slower.
                Monitor.Pulse(_gate);
                return true;
            }
        }

        public void Close()
        {
            lock (_gate)
            {
                _closed = true;
                Monitor.PulseAll(_gate);
            }
        }

        /// <summary>
        /// The clerk's side. Blocks the calling thread until a slip arrives or the
        /// tray closes. Returns false on close with nothing left. This is the line
        /// that costs a thread: the clerk's whole stack sits here, parked.
        /// </summary>
        internal bool TakeBlocking(out T slip)
        {
            lock (_gate)
            {
                while (_slips.Count == 0)
                {
                    if (_closed) { slip = default(T); return false; }
                    Monitor.Wait(_gate);
                }
                slip = _slips.Dequeue();
                return true;
            }
        }

        /// <summary>The clerk says the slip is done, so Pending drops. Handled slips count from here, never from the dequeue.</summary>
        internal void Handled()
        {
            Interlocked.Decrement(ref _pending);
        }
    }
}
