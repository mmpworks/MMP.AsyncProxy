using System;
using System.Threading;

namespace MMP.AsyncProxy.Forecourt
{
    /// <summary>
    /// The code Kevin brought to dinner. Two of his four threads, as he drew them on the
    /// napkin: the pulser thread that polls the meter and closes the valve at the ceiling,
    /// and the host thread that sends a request down the serial line and blocks until a
    /// reply comes or the timeout runs out. Both work. Both hold a thread to wait.
    /// </summary>
    public sealed class KevinsPump : IDisposable
    {
        private readonly Pulser _pulser;
        private readonly Valve _valve;
        private readonly SerialLink _link;
        private readonly int _pollMs;
        private volatile bool _running = true;
        private Thread _pulserThread;

        public KevinsPump(Pulser pulser, Valve valve, SerialLink link, int pollMs)
        {
            _pulser = pulser;
            _valve = valve;
            _link = link;
            _pollMs = pollMs;
        }

        /// <summary>Gallons delivered, from the pulse count. The display thread reads this.</summary>
        public double Gallons { get { return _pulser.Pulses / 1000.0; } }

        /// <summary>
        /// The pulser thread. Opens the valve, then sleeps, reads, compares, sleeps, until the
        /// ceiling. The thread exists so that something is awake every fifty milliseconds. It
        /// spends 99 percent of its life inside Thread.Sleep.
        /// </summary>
        public void StartDelivery(double ceilingGallons, Action onStopped)
        {
            _valve.Open();
            _pulserThread = new Thread(delegate()
            {
                while (_running)
                {
                    Thread.Sleep(_pollMs);                         // the thread is parked here
                    if (_pulser.Pulses / 1000.0 >= ceilingGallons)
                    {
                        _valve.Close();
                        onStopped();
                        return;
                    }
                }
            });
            _pulserThread.IsBackground = true;
            _pulserThread.Name = "pulser";
            _pulserThread.Start();
        }

        /// <summary>
        /// The host call. Sends the authorization request and blocks the calling thread on an
        /// event until the controller replies or the timeout passes. If the controller stops
        /// talking, this thread is gone until the timeout, and on the real board the timeout
        /// was thirty seconds. This is the thread that scared Kevin.
        /// </summary>
        public string Authorize(string card, int timeoutMs)
        {
            string reply = null;
            using (AutoResetEvent arrived = new AutoResetEvent(false))
            {
                Action<string> onData = delegate(string text) { reply = text; arrived.Set(); };
                _link.DataReceived += onData;
                try
                {
                    _link.Send("AUTH " + card);
                    if (!arrived.WaitOne(timeoutMs, false)) return "TIMEOUT";   // the thread is parked here
                    return reply;
                }
                finally { _link.DataReceived -= onData; }
            }
        }

        public void Dispose()
        {
            _running = false;
            if (_pulserThread != null) _pulserThread.Join(2000);
        }
    }
}
