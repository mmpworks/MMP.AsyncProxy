using System;
using System.Collections.Generic;

namespace MMP.AsyncProxy.Training.FanOut
{
    /// <summary>
    /// The same fan-out with no thread per letter. Every letter is a future from the
    /// office's timer door. Futures.WhenAll is the countdown: N callbacks, one counter,
    /// whoever hits zero completes the one future the gatherer is parked on. The gatherer
    /// is an iterator with a single yield, and the caller waits once on its result.
    /// </summary>
    public sealed class WhenAllCourier : ICourier
    {
        public string Version { get { return "asyncproxy"; } }

        public Reply[] SendAll(string[] addresses, PostOffice office)
        {
            IFuture<Reply[]> gathered = AsyncProxy.Run<Reply[]>(delegate(Return<Reply[]> ret) { return Gather(addresses, office, ret); });
            return gathered.Result;                    // the caller's thread, parked once, at the top
        }

        private static IEnumerable<IFuture> Gather(string[] addresses, PostOffice office, Return<Reply[]> ret)
        {
            IFuture<string>[] letters = new IFuture<string>[addresses.Length];
            for (int i = 0; i < addresses.Length; i++) letters[i] = office.AskAsync(addresses[i]);

            // One await for the lot. Observe, so a bounced letter faults its own future and never this loop.
            yield return Futures.Observe(Futures.WhenAll(letters));

            Reply[] replies = new Reply[addresses.Length];
            for (int i = 0; i < addresses.Length; i++)
            {
                IFuture<string> letter = letters[i];
                replies[i] = letter.IsFaulted
                    ? new Reply(addresses[i], null, letter.Exception)
                    : new Reply(addresses[i], letter.Result, null);
            }
            ret.Value = replies;
        }

        public void Dispose() { }
    }
}
