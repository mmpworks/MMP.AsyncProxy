using System;
using System.Collections.Generic;

namespace MMP.AsyncProxy.Training.Mailbox.Async
{
    /// <summary>The office, with the library: every clerk is a state machine, and the pool's threads are shared.</summary>
    public sealed class AsyncProxyDesk : IDesk
    {
        private readonly List<IDisposable> _seated = new List<IDisposable>();

        public string Version { get { return "asyncproxy"; } }

        public IInTray<T> OpenTray<T>(string name, int capacity)
        {
            return new PromiseInTray<T>(name, capacity);
        }

        public IClerk Seat<T>(string name, IInTray<T> tray, Action<T> handle)
        {
            IteratorClerk<T> clerk = new IteratorClerk<T>(name, (PromiseInTray<T>)tray, handle);
            lock (_seated) _seated.Add(clerk);
            return clerk;
        }

        public void Dispose()
        {
            IDisposable[] all;
            lock (_seated) { all = _seated.ToArray(); _seated.Clear(); }
            foreach (IDisposable d in all) d.Dispose();
        }
    }
}
