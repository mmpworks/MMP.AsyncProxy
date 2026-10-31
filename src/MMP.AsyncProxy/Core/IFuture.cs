using System;

namespace MMP.AsyncProxy
{
    /// <summary>
    /// A ticket for an answer that is not here yet. You can check it, wait on it,
    /// or hang a callback on it. You cannot finish it. Only the Promise that
    /// made it can do that. Same split as Task and TaskCompletionSource.
    /// </summary>
    public interface IFuture
    {
        FutureStatus Status { get; }
        bool IsCompleted { get; }
        bool IsFaulted { get; }
        bool IsCanceled { get; }

        /// <summary>The exception, if this future failed. Null otherwise.</summary>
        Exception Exception { get; }

        /// <summary>
        /// Parks the calling thread until the answer arrives. This is the thing
        /// async exists to avoid, so reach for it only at the top of a program or in a test.
        /// </summary>
        void Wait();

        /// <summary>
        /// Hands back the object an await talks to. Three questions, in order:
        /// is it done, call me when it is, give me the answer.
        /// </summary>
        IAwaiter GetAwaiter();

        /// <summary>
        /// Same awaiter, but it will not hop back to the thread you started on.
        /// This is what ConfigureAwait(false) does. Use it inside library code.
        /// </summary>
        IAwaiter ContinueOnAnyThread();
    }

    /// <summary>A future that carries a value when it finishes. Task&lt;T&gt;.</summary>
    public interface IFuture<T> : IFuture
    {
        /// <summary>Waits if it has to, then gives you the value or throws the failure.</summary>
        T Result { get; }

        new IAwaiter<T> GetAwaiter();

        new IAwaiter<T> ContinueOnAnyThread();
    }
}
