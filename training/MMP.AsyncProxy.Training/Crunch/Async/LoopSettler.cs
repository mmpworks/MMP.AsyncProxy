using System;
using System.Collections.Generic;

namespace MMP.AsyncProxy.Training.Crunch.Async
{
    /// <summary>
    /// The way a person reaches for async first: one method, a loop, and a wait at each step. It
    /// takes the day in chunks, sends each chunk to the pool with Futures.Run, and yields until the
    /// chunk is back before sending the next one. It never waits on a thread, and it never gets
    /// more than one core, because it only ever has one chunk in flight.
    ///
    /// Async is about not holding a thread while you wait. There is nothing to wait for here, so
    /// the machine adds a hop to the pool per chunk and gives nothing back.
    /// </summary>
    public sealed class LoopSettler : ISettler
    {
        private const int ChunkSize = 500;

        public string Version { get { return "async-loop"; } }

        public Settlement Settle(SaleRecord[] sales, int rounds)
        {
            return AsyncProxy.Run<Settlement>(delegate(Return<Settlement> ret) { return Body(sales, rounds, ret); }).Result;
        }

        private static IEnumerable<IFuture> Body(SaleRecord[] sales, int rounds, Return<Settlement> ret)
        {
            Tally all = new Tally();
            for (int start = 0; start < sales.Length; start += ChunkSize)
            {
                int from = start;
                int to = Math.Min(start + ChunkSize, sales.Length);
                IFuture<Tally> chunk = Futures.Run<Tally>(delegate { return Ledger.SealRange(sales, from, to, 1, rounds); });
                yield return chunk;                       // "await": the machine parks, the pool thread runs the chunk
                all.Merge(chunk.Result);
            }
            ret.Value = all.ToSettlement();
        }

        public void Dispose() { }
    }
}
