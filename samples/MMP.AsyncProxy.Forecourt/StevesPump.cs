using System;
using System.Collections.Generic;

namespace MMP.AsyncProxy.Forecourt
{
    /// <summary>
    /// The code Kevin left with. Same two jobs, no threads of their own. The pulser loop is
    /// an iterator that yields a timer; between polls it is a small object with a bookmark.
    /// The host call is a promise the serial line's reply completes, raced against a timer
    /// with WhenAny. Both run their callbacks on the pool for a few microseconds at a time.
    /// Every line compiles on the 2008 compiler and uses nothing the Compact Framework lacks.
    /// </summary>
    public sealed class StevesPump : IDisposable
    {
        private readonly Pulser _pulser;
        private readonly Valve _valve;
        private readonly SerialLink _link;
        private readonly int _pollMs;
        private readonly CancelSource _stop = new CancelSource();

        public StevesPump(Pulser pulser, Valve valve, SerialLink link, int pollMs)
        {
            _pulser = pulser;
            _valve = valve;
            _link = link;
            _pollMs = pollMs;
        }

        public double Gallons { get { return _pulser.Pulses / 1000.0; } }

        /// <summary>
        /// The pulser loop. Reads the same as Kevin's thread, with "yield return Futures.Delay"
        /// where "Thread.Sleep" was. The future it returns completes when the valve closes.
        /// </summary>
        public IFuture StartDelivery(double ceilingGallons)
        {
            _valve.Open();
            return AsyncProxy.Run(PollUntilCeiling(ceilingGallons));
        }

        private IEnumerable<IFuture> PollUntilCeiling(double ceilingGallons)
        {
            while (!_stop.Token.IsCancelRequested)
            {
                yield return Futures.Delay(_pollMs);                       // the bookmark; no thread is parked
                if (_pulser.Pulses / 1000.0 >= ceilingGallons)
                {
                    _valve.Close();
                    yield break;
                }
            }
        }

        /// <summary>
        /// The host call. The reply completes a promise; a timer races it. Whichever finishes
        /// first wins, and the caller's thread was never involved after Send returned.
        /// </summary>
        public IFuture<string> Authorize(string card, int timeoutMs)
        {
            return AsyncProxy.Run<string>(delegate(Return<string> ret) { return AuthorizeBody(card, timeoutMs, ret); });
        }

        private IEnumerable<IFuture> AuthorizeBody(string card, int timeoutMs, Return<string> ret)
        {
            Promise<string> reply = new Promise<string>(true);
            Action<string> onData = delegate(string text) { reply.TrySetResult(text); };
            _link.DataReceived += onData;
            try
            {
                _link.Send("AUTH " + card);
                IFuture<IFuture> first = Futures.WhenAny(reply.Future, Futures.Delay(timeoutMs));
                yield return first;
                ret.Value = first.Result == reply.Future ? reply.Future.Result : "TIMEOUT";
            }
            finally { _link.DataReceived -= onData; }
        }

        public void Dispose()
        {
            _stop.Cancel();
        }
    }
}
