using System;
using System.Collections.Generic;
using System.Threading;

namespace MMP.AsyncProxy.Sdk
{
    /// <summary>
    /// docs/sdk.md, "Cancel". Keep a CancelSource, hand out its Token. Delay and Run take one.
    /// Your own loops check it. A method that ends by throwing FutureCanceledException
    /// completes its future as Canceled.
    /// </summary>
    public sealed class CancelAPoll : IDisposable
    {
        private readonly CancelSource _source = new CancelSource();
        private int _polls;

        public int Polls { get { return _polls; } }

        public IFuture Start(int periodMs)
        {
            CancelSource source = _source;
            IFuture work = AsyncProxy.Run(Poll(source.Token, periodMs));
            return work;
        }

        /// <summary>Later, from any thread.</summary>
        public void Stop()
        {
            _source.Cancel();
        }

        private IEnumerable<IFuture> Poll(CancelToken token, int periodMs)
        {
            while (true)
            {
                token.ThrowIfCancelRequested();        // ends the method Canceled, not Faulted
                yield return Futures.Delay(periodMs, token);
                DoOnePoll();
            }
        }

        private void DoOnePoll()
        {
            Interlocked.Increment(ref _polls);
        }

        public void Dispose()
        {
            _source.Dispose();
        }
    }
}
