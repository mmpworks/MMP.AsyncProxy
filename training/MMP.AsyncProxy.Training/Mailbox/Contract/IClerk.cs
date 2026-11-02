using System;

namespace MMP.AsyncProxy.Training.Mailbox
{
    /// <summary>
    /// A clerk seated at one in-tray. The clerk takes the top slip, handles it,
    /// and looks at the tray again. The two versions differ in one thing only:
    /// what the clerk holds while the tray is empty.
    /// </summary>
    public interface IClerk : IDisposable
    {
        string Name { get; }

        /// <summary>True until the tray closes and the clerk has handled the last slip.</summary>
        bool IsRunning { get; }

        /// <summary>Slips handled so far, including ones whose handler threw.</summary>
        int Handled { get; }

        /// <summary>Waits until the tray is empty and no slip is in the clerk's hand. False if the time runs out first.</summary>
        bool WaitUntilIdle(int timeoutMs);
    }
}
