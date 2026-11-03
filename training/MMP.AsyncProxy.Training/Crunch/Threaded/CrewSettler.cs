using System;
using System.Threading;

namespace MMP.AsyncProxy.Training.Crunch.Threaded
{
    /// <summary>
    /// A crew of threads of its own. Each one is started for the job, takes every
    /// crew-th record starting at its own number, keeps its own Tally, and is joined at the end.
    /// Nothing is borrowed from the thread pool, so nothing the pool does (timers, other
    /// callbacks) ever waits behind this work. By default the crew is one smaller than the
    /// number of cores, which leaves a core free for whatever has to stay on time.
    ///
    /// This is the case where the plain thread is the right tool: the work is CPU, a thread is
    /// what a core runs, and the program wants to say exactly how many cores to give it.
    /// </summary>
    public sealed class CrewSettler : ISettler
    {
        private readonly int _crew;

        public CrewSettler() : this(Math.Max(1, Environment.ProcessorCount - 1)) { }

        public CrewSettler(int crew)
        {
            _crew = crew;
        }

        public string Version { get { return "threaded"; } }

        public int Crew { get { return _crew; } }

        public Settlement Settle(SaleRecord[] sales, int rounds)
        {
            Tally[] parts = new Tally[_crew];
            Thread[] threads = new Thread[_crew];
            for (int t = 0; t < _crew; t++)
            {
                int me = t;
                threads[t] = new Thread(delegate() { parts[me] = Ledger.SealRange(sales, me, sales.Length, _crew, rounds); });
                threads[t].IsBackground = true;
                threads[t].Name = "crunch:" + t;
                threads[t].Priority = ThreadPriority.BelowNormal;       // the crew yields to anything more urgent
                threads[t].Start();
            }

            Tally all = new Tally();
            for (int t = 0; t < _crew; t++)
            {
                threads[t].Join();
                all.Merge(parts[t]);
            }
            return all.ToSettlement();
        }

        public void Dispose() { }
    }
}
