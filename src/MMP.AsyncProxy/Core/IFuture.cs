using System;

namespace MMP.AsyncProxy
{
    /// <summary>
    /// A read-only view of work that finishes later. The Task shape.
    /// Only a Promise can complete it.
    /// </summary>
    public interface IFuture
    {
        FutureStatus Status { get; }
        bool IsCompleted { get; }
        bool IsFaulted { get; }
        bool IsCanceled { get; }

        /// <summary>The fault, or null when the future has not faulted.</summary>
        Exception Exception { get; }

        /// <summary>Blocks the calling thread until the future completes. Sync over async. Use with care.</summary>
        void Wait();

        /// <summary>Returns the object an await would call IsCompleted, OnCompleted and GetResult on.</summary>
        IAwaiter GetAwaiter();

        /// <summary>An awaiter that skips the SynchronizationContext post-back. The ConfigureAwait(false) stand-in.</summary>
        IAwaiter ContinueOnAnyThread();
    }

    /// <summary>A future that carries a value. The Task&lt;T&gt; shape.</summary>
    public interface IFuture<T> : IFuture
    {
        /// <summary>Blocks until complete, then returns the value or throws the fault.</summary>
        T Result { get; }

        new IAwaiter<T> GetAwaiter();

        new IAwaiter<T> ContinueOnAnyThread();
    }
}
