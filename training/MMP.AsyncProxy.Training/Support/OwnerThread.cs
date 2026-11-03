using System;
using System.Collections.Generic;
using System.Threading;

namespace MMP.AsyncProxy.Training.Support
{
    /// <summary>
    /// One thread that owns something, plus a line of jobs for it. Anything that must always
    /// be touched from the same thread (a device driver, a UI control, a COM object in a
    /// single-threaded apartment) lives here. The thread does nothing but take the next job
    /// off the line and run it.
    ///
    /// It is also a SynchronizationContext. A method that waits and then must carry on
    /// "back where it was" captures this context at the wait, and the library posts the rest
    /// of the method back onto this thread when the wait is over (chapter 5). That is how an
    /// async method can use a device that owns a thread: the thread stays; only the waiting
    /// stops holding it.
    /// </summary>
    public sealed class OwnerThread : SynchronizationContext, IDisposable
    {
        private readonly object _gate = new object();
        private readonly Queue<Action> _jobs = new Queue<Action>();
        private readonly Thread _thread;
        private bool _stop;

        public OwnerThread(string name)
        {
            _thread = new Thread(Pump);
            _thread.IsBackground = true;
            _thread.Name = name;
            _thread.Start();
        }

        public int ThreadId { get { return _thread.ManagedThreadId; } }

        public bool IsOwnerThread { get { return Thread.CurrentThread == _thread; } }

        /// <summary>Puts a job on the line and returns at once.</summary>
        public void Enqueue(Action job)
        {
            lock (_gate)
            {
                if (_stop) throw new ObjectDisposedException("OwnerThread");
                _jobs.Enqueue(job);
                Monitor.Pulse(_gate);
            }
        }

        /// <summary>Runs the job on the owner thread and blocks the caller until it is done. A throw comes back to the caller.</summary>
        public void Invoke(Action job)
        {
            if (IsOwnerThread) { job(); return; }
            Exception failure = null;
            ManualResetEvent done = new ManualResetEvent(false);
            Enqueue(delegate
            {
                try { job(); }
                catch (Exception ex) { failure = ex; }
                finally { done.Set(); }
            });
            done.WaitOne();
            done.Close();
            if (failure != null) throw new InvalidOperationException("The job on the owner thread failed: " + failure.Message, failure);
        }

        public override void Post(SendOrPostCallback d, object state)
        {
            Enqueue(delegate { d(state); });
        }

        public override SynchronizationContext CreateCopy()
        {
            return this;
        }

        private void Pump()
        {
            SynchronizationContext.SetSynchronizationContext(this);
            while (true)
            {
                Action job;
                lock (_gate)
                {
                    while (_jobs.Count == 0 && !_stop) Monitor.Wait(_gate);
                    if (_jobs.Count == 0) return;
                    job = _jobs.Dequeue();
                }
                job();
            }
        }

        public void Dispose()
        {
            lock (_gate)
            {
                _stop = true;
                Monitor.PulseAll(_gate);
            }
            _thread.Join();
        }
    }
}
