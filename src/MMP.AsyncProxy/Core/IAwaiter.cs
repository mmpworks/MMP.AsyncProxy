using System;

namespace MMP.AsyncProxy
{
    /// <summary>
    /// The three members the compiler calls at an await site.
    /// INotifyCompletion plus TaskAwaiter, folded into one interface.
    /// </summary>
    public interface IAwaiter
    {
        /// <summary>True when the result is already here. The machine then skips the suspend and keeps running.</summary>
        bool IsCompleted { get; }

        /// <summary>Registers the rest of the method. Called once, only when IsCompleted was false.</summary>
        void OnCompleted(Action continuation);

        /// <summary>Returns nothing or throws the fault. Called after completion.</summary>
        void GetResult();
    }

    /// <summary>An awaiter that hands back a value.</summary>
    public interface IAwaiter<T> : IAwaiter
    {
        new T GetResult();
    }
}
