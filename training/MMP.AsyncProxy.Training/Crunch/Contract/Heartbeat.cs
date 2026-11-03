using System;
using System.Collections.Generic;
using System.Diagnostics;

namespace MMP.AsyncProxy.Training.Crunch
{
    /// <summary>What the heartbeat saw: how many beats, and how far past its period the worst and the average beat landed.</summary>
    public sealed class HeartbeatReport
    {
        private readonly int _beats;
        private readonly long _worstLateMs;
        private readonly double _averageLateMs;

        public HeartbeatReport(int beats, long worstLateMs, double averageLateMs)
        {
            _beats = beats;
            _worstLateMs = worstLateMs;
            _averageLateMs = averageLateMs;
        }

        public int Beats { get { return _beats; } }
        public long WorstLateMs { get { return _worstLateMs; } }
        public double AverageLateMs { get { return _averageLateMs; } }
    }

    /// <summary>
    /// Stands in for the pulser: a small job that has to run every period (50 ms for the
    /// pump) and can't be late. It waits on a timer, not on a thread, so it needs a worker
    /// for a few microseconds per beat, and the beat comes from the thread pool. That makes it
    /// a good test of what the settler left free: if the pool's workers are all busy, the beat
    /// waits in line and lands late. Late is measured: the time from one beat to the next,
    /// minus the period.
    /// </summary>
    public sealed class Heartbeat
    {
        private readonly int _periodMs;
        private readonly object _gate = new object();
        private volatile bool _stop;
        private int _beats;
        private long _worst;
        private long _totalLate;
        private IFuture _loop;

        public Heartbeat(int periodMs)
        {
            _periodMs = periodMs;
        }

        public void Start()
        {
            _loop = AsyncProxy.Run(Beat());
        }

        /// <summary>Stops the beat and reports. Waits for the last beat, which can itself be late.</summary>
        public HeartbeatReport Stop()
        {
            _stop = true;
            _loop.Wait();
            lock (_gate)
            {
                double average = _beats == 0 ? 0 : (double)_totalLate / _beats;
                return new HeartbeatReport(_beats, _worst, average);
            }
        }

        private IEnumerable<IFuture> Beat()
        {
            Stopwatch clock = Stopwatch.StartNew();
            long last = clock.ElapsedMilliseconds;
            while (!_stop)
            {
                yield return Futures.Delay(_periodMs);
                long now = clock.ElapsedMilliseconds;
                long late = Math.Max(0, now - last - _periodMs);
                last = now;
                lock (_gate)
                {
                    _beats++;
                    _totalLate += late;
                    if (late > _worst) _worst = late;
                }
            }
        }
    }
}
