using System;
using System.Collections.Generic;

namespace MMP.AsyncProxy.Training.Pipeline
{
    /// <summary>
    /// What the line produced: the outputs in input order, the items it had to drop
    /// because a stage threw on them, and the most items it ever held between the
    /// first stage's intake and the last stage's output. That last number is the
    /// backpressure made visible: with trays of capacity C and three stages, it can
    /// never pass 2C plus the three items in the stages' hands.
    /// </summary>
    public sealed class LineResult
    {
        private readonly int[] _outputs;
        private readonly int[] _dropped;
        private readonly int _inFlightPeak;

        public LineResult(int[] outputs, int[] dropped, int inFlightPeak)
        {
            _outputs = outputs;
            _dropped = dropped;
            _inFlightPeak = inFlightPeak;
        }

        public int[] Outputs { get { return _outputs; } }
        public int[] Dropped { get { return _dropped; } }
        public int InFlightPeak { get { return _inFlightPeak; } }
    }

    /// <summary>
    /// Three stages in a row, parse then enrich then write, with a small tray between
    /// each pair. A full tray makes the stage before it wait; an empty tray makes the
    /// stage after it wait. What a waiting stage holds is the difference between the
    /// versions. The stages are the same three functions in every version:
    /// Parse(x) = x + 1, Enrich(x) = x * 2 and throws on a poison value, Write(x)
    /// appends to the output after writeDelayMs.
    /// </summary>
    public interface IAssemblyLine : IDisposable
    {
        /// <summary>"threaded", "asyncproxy", or "modern".</summary>
        string Version { get; }

        /// <summary>Feeds every input through the three stages and returns when the last one is written.</summary>
        LineResult Run(int[] inputs, int trayCapacity, int writeDelayMs);
    }

    /// <summary>The three stage functions, shared so every version does the same arithmetic.</summary>
    public static class Stages
    {
        /// <summary>The value Enrich refuses. A line must drop it and go on.</summary>
        public const int Poison = 13;

        public static int Parse(int x) { return x + 1; }

        public static int Enrich(int x)
        {
            if (x == Poison) throw new InvalidOperationException("poison item " + x);
            return x * 2;
        }
    }

    /// <summary>Counts items between intake and output and remembers the highest count.</summary>
    public sealed class InFlightMeter
    {
        private int _now;
        private int _peak;

        public void Entered()
        {
            int now = System.Threading.Interlocked.Increment(ref _now);
            int seen;
            do { seen = _peak; if (now <= seen) return; }
            while (System.Threading.Interlocked.CompareExchange(ref _peak, now, seen) != seen);
        }

        public void Left() { System.Threading.Interlocked.Decrement(ref _now); }

        public int Peak { get { return System.Threading.Interlocked.CompareExchange(ref _peak, 0, 0); } }
    }
}
