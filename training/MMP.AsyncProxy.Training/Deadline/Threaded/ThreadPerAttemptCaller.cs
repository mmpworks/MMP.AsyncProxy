using System;
using System.Collections.Generic;
using System.Threading;

namespace MMP.AsyncProxy.Training.Deadline.Threaded
{
    /// <summary>
    /// The 2008 deadline: a thread per attempt. The attempt thread walks through the
    /// blocking door and sets an event when it has the answer. The caller waits on
    /// that event, the give-up event, or the clock, whichever comes first. When the
    /// clock wins, the caller moves on and the attempt thread is abandoned: still
    /// parked inside Ask, with its stack, until the service answers or forever. A
    /// late answer sets an event nobody is watching, which is harmless, and leaves
    /// a thread behind, which is the cost this project is about.
    /// </summary>
    public sealed class ThreadPerAttemptCaller : IDeadlineCaller
    {
        private readonly List<Thread> _attempts = new List<Thread>();

        public string Version { get { return "threaded"; } }

        /// <summary>Attempt threads that are still alive: the ones the service never answered, parked for good.</summary>
        public int ParkedAttempts
        {
            get
            {
                int alive = 0;
                lock (_attempts) foreach (Thread t in _attempts) if (t.IsAlive) alive++;
                return alive;
            }
        }

        public CallResult Call(FlakyService service, int timeoutMs, int maxAttempts, GiveUp giveUp)
        {
            ManualResetEvent gaveUp = new ManualResetEvent(false);
            giveUp.OnFired(delegate { gaveUp.Set(); });

            for (int attempt = 0; attempt < maxAttempts; attempt++)
            {
                if (giveUp.Requested) return new CallResult(CallOutcome.Cancelled, null, attempt);

                string[] slot = new string[1];
                ManualResetEvent answered = new ManualResetEvent(false);
                int which = attempt;
                Thread t = new Thread(delegate()
                {
                    slot[0] = service.Ask(which);                 // parked here for the delay, or forever
                    answered.Set();                               // nobody may be listening by now
                });
                t.IsBackground = true;
                t.Name = "attempt:" + attempt;
                lock (_attempts) _attempts.Add(t);
                t.Start();

                int signalled = WaitHandle.WaitAny(new WaitHandle[] { answered, gaveUp }, timeoutMs, false);
                if (signalled == 0) return new CallResult(CallOutcome.Answered, slot[0], attempt + 1);
                if (signalled == 1) return new CallResult(CallOutcome.Cancelled, null, attempt + 1);
                // WaitTimeout: abandon the attempt. Its thread is still parked inside Ask.
            }
            return new CallResult(CallOutcome.GaveUp, null, maxAttempts);
        }

        public void Dispose() { }
    }
}
