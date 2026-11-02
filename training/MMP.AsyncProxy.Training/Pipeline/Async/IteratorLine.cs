using System;
using System.Collections.Generic;

namespace MMP.AsyncProxy.Training.Pipeline.Async
{
    /// <summary>
    /// A state machine per stage and no thread for any of them. Each stage is an
    /// iterator that yields a tray future in each direction: take from the tray
    /// behind it, put into the tray ahead of it. A stage that is waiting, for an
    /// item or for room, is an object with a bookmark. The three run on the pool
    /// for the microseconds each item takes, and the caller waits once on the
    /// writer's future.
    /// </summary>
    public sealed class IteratorLine : IAssemblyLine
    {
        public string Version { get { return "asyncproxy"; } }

        public LineResult Run(int[] inputs, int trayCapacity, int writeDelayMs)
        {
            PromiseTray<int> parsed = new PromiseTray<int>(trayCapacity);
            PromiseTray<int> enriched = new PromiseTray<int>(trayCapacity);
            List<int> outputs = new List<int>(inputs.Length);
            List<int> dropped = new List<int>();
            InFlightMeter meter = new InFlightMeter();

            AsyncProxy.Run(ParseStage(inputs, parsed, meter));
            AsyncProxy.Run(EnrichStage(parsed, enriched, dropped, meter));
            IFuture done = AsyncProxy.Run(WriteStage(enriched, outputs, writeDelayMs, meter));
            done.Wait();                                                // the caller, parked once, at the top
            return new LineResult(outputs.ToArray(), dropped.ToArray(), meter.Peak);
        }

        private static IEnumerable<IFuture> ParseStage(int[] inputs, PromiseTray<int> ahead, InFlightMeter meter)
        {
            foreach (int x in inputs)
            {
                meter.Entered();
                int parsed = Stages.Parse(x);
                if (ahead.TryPut(parsed)) continue;                     // room: in it goes, nothing allocated
                yield return ahead.PutAsync(parsed);                    // full: park on the tray's IOU
            }
            ahead.Close();
        }

        private static IEnumerable<IFuture> EnrichStage(PromiseTray<int> behind, PromiseTray<int> ahead, List<int> dropped, InFlightMeter meter)
        {
            while (true)
            {
                int x;
                if (!behind.TryTake(out x))
                {
                    IFuture<int> next = behind.TakeAsync();
                    yield return Futures.Observe(next);                 // parks only when the tray behind is empty
                    if (next.IsCanceled) break;                         // closed and drained
                    x = next.Result;
                }
                int enrichedItem;
                try { enrichedItem = Stages.Enrich(x); }
                catch (InvalidOperationException) { dropped.Add(x); meter.Left(); continue; }
                if (ahead.TryPut(enrichedItem)) continue;
                yield return ahead.PutAsync(enrichedItem);
            }
            ahead.Close();
        }

        private static IEnumerable<IFuture> WriteStage(PromiseTray<int> behind, List<int> outputs, int writeDelayMs, InFlightMeter meter)
        {
            while (true)
            {
                int x;
                if (!behind.TryTake(out x))
                {
                    IFuture<int> next = behind.TakeAsync();
                    yield return Futures.Observe(next);
                    if (next.IsCanceled) break;
                    x = next.Result;
                }
                if (writeDelayMs > 0) yield return Futures.Delay(writeDelayMs);   // the slow end of the line, with no thread asleep
                outputs.Add(x);
                meter.Left();
            }
        }

        public void Dispose() { }
    }
}
