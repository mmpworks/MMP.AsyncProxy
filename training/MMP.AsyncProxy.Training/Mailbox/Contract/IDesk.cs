using System;

namespace MMP.AsyncProxy.Training.Mailbox
{
    /// <summary>
    /// The office. It opens trays and seats clerks at them. Each version of the
    /// program is one desk: the threaded one, the AsyncProxy one, and on .NET 10
    /// the modern one. The tests and the bench talk to this and nothing else, so
    /// "the versions behave the same" is a theory over desks, never a sentence.
    /// </summary>
    public interface IDesk : IDisposable
    {
        /// <summary>"threaded", "asyncproxy", or "modern". Shows up in test names and bench rows.</summary>
        string Version { get; }

        IInTray<T> OpenTray<T>(string name, int capacity);

        /// <summary>Seats a clerk at a tray. The clerk starts at once and handles every slip through <paramref name="handle"/>.</summary>
        IClerk Seat<T>(string name, IInTray<T> tray, Action<T> handle);
    }
}
