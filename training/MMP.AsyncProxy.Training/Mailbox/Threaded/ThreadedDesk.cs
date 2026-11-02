using System;
using System.Collections.Generic;

namespace MMP.AsyncProxy.Training.Mailbox.Threaded
{
    /// <summary>The office, 2008 edition: every clerk gets a thread.</summary>
    public sealed class ThreadedDesk : IDesk
    {
        private readonly List<IDisposable> _seated = new List<IDisposable>();

        public string Version { get { return "threaded"; } }

        public IInTray<T> OpenTray<T>(string name, int capacity)
        {
            return new ThreadedInTray<T>(name, capacity);
        }

        public IClerk Seat<T>(string name, IInTray<T> tray, Action<T> handle)
        {
            ThreadedClerk<T> clerk = new ThreadedClerk<T>(name, (ThreadedInTray<T>)tray, handle);
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
