using System.Diagnostics;
using System.Threading;

namespace MMP.AsyncProxy.Training.Support
{
    /// <summary>
    /// Counts the threads in this process every five milliseconds and keeps the
    /// highest number seen. The bench and the tests use it to show what a
    /// version held while it waited. Peak threads is the number that teaches:
    /// a thread per worker shows up here, a bookmark per worker does not.
    /// </summary>
    public sealed class ThreadSampler
    {
        private readonly Timer _timer;
        private int _peak;
        private bool _stopped;

        public ThreadSampler()
        {
            Sample(null);
            _timer = new Timer(Sample, null, 5, 5);
        }

        private void Sample(object state)
        {
            if (_stopped) return;
            int now = Process.GetCurrentProcess().Threads.Count;
            int seen;
            do { seen = _peak; if (now <= seen) return; }
            while (Interlocked.CompareExchange(ref _peak, now, seen) != seen);
        }

        /// <summary>Stops sampling and returns the peak. Safe to call once.</summary>
        public int Stop()
        {
            _stopped = true;
            _timer.Dispose();
            Sample(null);
            return _peak;
        }
    }
}
