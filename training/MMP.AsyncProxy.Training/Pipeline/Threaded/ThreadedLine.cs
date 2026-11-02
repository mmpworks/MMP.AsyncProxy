using System;
using System.Collections.Generic;
using System.Threading;

namespace MMP.AsyncProxy.Training.Pipeline.Threaded
{
    /// <summary>
    /// A tray with two waits. Put parks the caller while the tray is full; Take parks
    /// the caller while it is empty. Both park inside Monitor.Wait on the same lock,
    /// and either side's change pulses the other. This is the 2008 bounded queue,
    /// written out, because BlockingCollection arrived in .NET 4.
    /// </summary>
    public sealed class BlockingTray<T>
    {
        private readonly object _gate = new object();
        private readonly Queue<T> _items = new Queue<T>();
        private readonly int _capacity;
        private bool _closed;

        public BlockingTray(int capacity) { _capacity = capacity; }

        /// <summary>Blocks until there is room. False if the tray closed first.</summary>
        public bool Put(T item)
        {
            lock (_gate)
            {
                while (_items.Count >= _capacity)
                {
                    if (_closed) return false;
                    Monitor.Wait(_gate);                    // the producer's thread, parked: tray full
                }
                _items.Enqueue(item);
                Monitor.PulseAll(_gate);
                return true;
            }
        }

        /// <summary>Blocks until there is an item. False when the tray is closed and drained.</summary>
        public bool Take(out T item)
        {
            lock (_gate)
            {
                while (_items.Count == 0)
                {
                    if (_closed) { item = default(T); return false; }
                    Monitor.Wait(_gate);                    // the consumer's thread, parked: tray empty
                }
                item = _items.Dequeue();
                Monitor.PulseAll(_gate);
                return true;
            }
        }

        /// <summary>No more puts. Takes drain what is left, then return false.</summary>
        public void Close()
        {
            lock (_gate) { _closed = true; Monitor.PulseAll(_gate); }
        }
    }

    /// <summary>
    /// A thread per stage. Parse reads the inputs, Enrich reads tray 1, Write reads tray 2.
    /// Each thread blocks on its tray in both directions, so between items every stage
    /// holds a parked thread with a reserved stack. Three stages, three threads, for the
    /// life of the run.
    /// </summary>
    public sealed class ThreadedLine : IAssemblyLine
    {
        public string Version { get { return "threaded"; } }

        public LineResult Run(int[] inputs, int trayCapacity, int writeDelayMs)
        {
            BlockingTray<int> parsed = new BlockingTray<int>(trayCapacity);
            BlockingTray<int> enriched = new BlockingTray<int>(trayCapacity);
            List<int> outputs = new List<int>(inputs.Length);
            List<int> dropped = new List<int>();
            InFlightMeter meter = new InFlightMeter();

            Thread parse = new Thread(delegate()
            {
                foreach (int x in inputs) { meter.Entered(); parsed.Put(Stages.Parse(x)); }
                parsed.Close();
            });
            Thread enrich = new Thread(delegate()
            {
                int x;
                while (parsed.Take(out x))
                {
                    try { enriched.Put(Stages.Enrich(x)); }
                    catch (InvalidOperationException) { lock (dropped) dropped.Add(x); meter.Left(); }
                }
                enriched.Close();
            });
            Thread write = new Thread(delegate()
            {
                int x;
                while (enriched.Take(out x))
                {
                    if (writeDelayMs > 0) Thread.Sleep(writeDelayMs);   // the slow end of the line
                    outputs.Add(x);
                    meter.Left();
                }
            });
            foreach (Thread t in new[] { parse, enrich, write }) { t.IsBackground = true; t.Start(); }
            write.Join();                                               // the caller, parked until the last write
            return new LineResult(outputs.ToArray(), dropped.ToArray(), meter.Peak);
        }

        public void Dispose() { }
    }
}
