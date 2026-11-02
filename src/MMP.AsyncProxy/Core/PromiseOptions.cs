using System;

namespace MMP.AsyncProxy
{
    /// <summary>
    /// How a <see cref="Promise{T}"/> runs the callbacks waiting on it. The name of the
    /// one real option is the name .NET 4.6 gave it on TaskCreationOptions, so the
    /// call site says what it does and the match to modern code is word for word.
    /// </summary>
    [Flags]
    public enum PromiseOptions
    {
        /// <summary>
        /// The default. Whoever calls SetResult runs every waiting callback right there,
        /// on its own thread, before SetResult returns. Same as a default TaskCompletionSource.
        /// </summary>
        None = 0,

        /// <summary>
        /// SetResult hands the waiting callbacks to the thread pool (a work item on the
        /// pool's job board) and returns at once. Use it when the completer must never run
        /// someone else's code on its own stack: it holds a lock, sits on a deep stack, or
        /// is a thread with a deadline, such as a UART interrupt.
        /// </summary>
        RunContinuationsAsynchronously = 1
    }
}
