using System;
using System.Collections.Generic;

namespace MMP.AsyncProxy.Training.FanOut
{
    /// <summary>
    /// The slow service every courier talks to. A letter takes DelayMs to answer, and
    /// some addresses bounce. Two doors: Ask blocks the calling thread for the delay,
    /// the way a 2008 web request did; AskAsync hands back a future that a timer
    /// completes, so nobody waits. The modern courier builds its own door from the
    /// same two facts, DelayMs and Bounces.
    /// </summary>
    public sealed class PostOffice
    {
        private readonly int _delayMs;
        private readonly Dictionary<string, bool> _bounces = new Dictionary<string, bool>();

        public PostOffice(int delayMs)
        {
            _delayMs = delayMs;
        }

        public int DelayMs { get { return _delayMs; } }

        /// <summary>Marks an address as one that bounces: the reply is an error instead of text.</summary>
        public PostOffice Bounce(string address)
        {
            _bounces[address] = true;
            return this;
        }

        public bool Bounces(string address)
        {
            return _bounces.ContainsKey(address);
        }

        /// <summary>The reply text for an address, or the exception a bounce throws.</summary>
        public string Answer(string address)
        {
            if (Bounces(address)) throw new InvalidOperationException("no such address: " + address);
            return "re: " + address;
        }

        /// <summary>The blocking door. The calling thread sleeps for the delay, then gets the answer or the throw.</summary>
        public string Ask(string address)
        {
            System.Threading.Thread.Sleep(_delayMs);
            return Answer(address);
        }

        /// <summary>The future door. A timer completes it; no thread of the caller's waits.</summary>
        public IFuture<string> AskAsync(string address)
        {
            return AsyncProxy.Run<string>(delegate(Return<string> ret) { return AskBody(address, ret); });
        }

        private IEnumerable<IFuture> AskBody(string address, Return<string> ret)
        {
            yield return Futures.Delay(_delayMs);
            ret.Value = Answer(address);
        }
    }
}
