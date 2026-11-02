using System;
using System.Collections.Generic;

namespace MMP.AsyncProxy.Training.Crunch.Async
{
    /// <summary>
    /// The way a person reaches for async second, after finding out the loop is slow: cut the day
    /// into one chunk per core, send every chunk to the pool at once with Futures.Run, and wait
    /// for all of them. It is quick, because it uses every core. It is also what Task.Run in a
    /// loop does in modern .NET.
    ///
    /// But those chunks are work items on the pool's job board, and each one holds a pool thread
    /// for its whole length. While they run, every other job the pool is asked to do, such as the
    /// timer that wakes the pulser, waits behind them. The heartbeat in the bench shows how long.
    /// </summary>
    public sealed class PoolFanOutSettler : ISettler
    {
        private readonly int _chunks;

        public PoolFanOutSettler() : this(Environment.ProcessorCount) { }

        public PoolFanOutSettler(int chunks)
        {
            _chunks = chunks;
        }

        public string Version { get { return "async-pool"; } }

        public Settlement Settle(SaleRecord[] sales, int rounds)
        {
            return AsyncProxy.Run<Settlement>(delegate(Return<Settlement> ret) { return Body(sales, rounds, ret); }).Result;
        }

        private IEnumerable<IFuture> Body(SaleRecord[] sales, int rounds, Return<Settlement> ret)
        {
            IFuture<Tally>[] chunks = new IFuture<Tally>[_chunks];
            for (int c = 0; c < _chunks; c++)
            {
                int me = c;
                int count = _chunks;
                chunks[c] = Futures.Run<Tally>(delegate { return Ledger.SealRange(sales, me, sales.Length, count, rounds); });
            }
            yield return Futures.WhenAll(chunks);          // park once; every chunk runs on a borrowed worker

            Tally all = new Tally();
            for (int c = 0; c < _chunks; c++) all.Merge(chunks[c].Result);
            ret.Value = all.ToSettlement();
        }

        public void Dispose() { }
    }
}
