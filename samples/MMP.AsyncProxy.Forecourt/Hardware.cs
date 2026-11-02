using System;
using System.Threading;

namespace MMP.AsyncProxy.Forecourt
{
    /// <summary>
    /// The meter. Every pulse is a thousandth of a gallon. On the real board this is a
    /// hardware counter the pulser thread reads through a driver; here it is a number a
    /// test can bump. Reads are atomic, so a reader needs no lock.
    /// </summary>
    public sealed class Pulser
    {
        private int _pulses;

        // Interlocked.CompareExchange with no change is the volatile read the Compact Framework has.
        // Thread.VolatileRead is not in its mscorlib; the audit in docs/netcf-port.md lists what is.
        public int Pulses { get { return Interlocked.CompareExchange(ref _pulses, 0, 0); } }

        /// <summary>The test's hand on the flow. The nozzle is open and fuel is moving.</summary>
        public void Pulse(int count)
        {
            // Interlocked.Add is missing on the Compact Framework too. A compare-and-swap loop is the same add.
            int seen;
            do { seen = _pulses; }
            while (Interlocked.CompareExchange(ref _pulses, seen + count, seen) != seen);
        }
    }

    /// <summary>
    /// The valve. Open lets fuel move; Close stops it. The pump controller is the only
    /// thing that touches it, from whichever thread the controller happens to be on.
    /// </summary>
    public sealed class Valve
    {
        private int _open;
        public bool IsOpen { get { return Interlocked.CompareExchange(ref _open, 0, 0) == 1; } }
        public void Open() { Interlocked.Exchange(ref _open, 1); }
        public void Close() { Interlocked.Exchange(ref _open, 0); }
    }

    /// <summary>
    /// The serial line to the forecourt controller, which talks to the bank. A request
    /// goes out; a reply comes back later, or never. On the real board the UART raises
    /// DataReceived; here the test plays the controller and calls Reply or stays silent.
    /// </summary>
    public sealed class SerialLink
    {
        private Action<string> _onReply;
        private readonly object _gate = new object();

        /// <summary>Sends a request. The reply, if any, arrives through DataReceived.</summary>
        public void Send(string request)
        {
            LastRequest = request;
        }

        public string LastRequest { get; private set; }

        /// <summary>Subscribe to replies. One handler at a time, the way a serial port works.</summary>
        public event Action<string> DataReceived
        {
            add { lock (_gate) _onReply = (Action<string>)Delegate.Combine(_onReply, value); }
            remove { lock (_gate) _onReply = (Action<string>)Delegate.Remove(_onReply, value); }
        }

        /// <summary>The controller's side: bytes arrive on the line. Raised on the caller's thread, like a UART interrupt.</summary>
        public void Reply(string text)
        {
            Action<string> handler;
            lock (_gate) handler = _onReply;
            if (handler != null) handler(text);
        }
    }
}
