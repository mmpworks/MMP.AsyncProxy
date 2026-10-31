using System;

namespace MMP.AsyncProxy
{
    /// <summary>
    /// The three calls the compiler makes at every await. That is the whole
    /// protocol. In .NET 4.5 this is INotifyCompletion plus the TaskAwaiter
    /// members, squashed into one interface here so you can see it in one place.
    /// </summary>
    public interface IAwaiter
    {
        /// <summary>
        /// Is the answer already here? If yes, the state machine keeps running on
        /// the same thread and never suspends. The fast path.
        /// </summary>
        bool IsCompleted { get; }

        /// <summary>
        /// "Call this when you are done." The continuation is the rest of the method.
        /// The machine calls this once, and only when IsCompleted said no.
        /// </summary>
        void OnCompleted(Action continuation);

        /// <summary>Gets the answer, or throws the failure. Call it after completion.</summary>
        void GetResult();
    }

    /// <summary>Same three calls, and GetResult hands back a value.</summary>
    public interface IAwaiter<T> : IAwaiter
    {
        new T GetResult();
    }
}
