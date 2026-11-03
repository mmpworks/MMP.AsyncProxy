using System;
using System.Threading;

namespace MMP.AsyncProxy.Sdk
{
    /// <summary>
    /// docs/sdk.md, "Continuations off your stack". By default SetResult runs every waiting
    /// continuation on the calling thread before it returns. A completer that holds a lock,
    /// sits on a deep stack, or has a deadline asks for them to go to the pool instead.
    /// </summary>
    public static class ContinuationsOffYourStack
    {
        /// <summary>The default: the continuation runs on the completer's thread, before SetResult returns.</summary>
        public static int CompleteInline(out int completerThread)
        {
            int ran = 0;
            Promise<int> promise = new Promise<int>();
            promise.Future.ContinueOnAnyThread().OnCompleted(delegate { ran = Thread.CurrentThread.ManagedThreadId; });
            completerThread = Thread.CurrentThread.ManagedThreadId;
            promise.SetResult(1);
            return ran;
        }

        /// <summary>The option: SetResult queues the continuation and returns at once.</summary>
        public static IFuture<int> CompleteOnThePool(out bool ranBeforeSetResultReturned)
        {
            Promise<int> continuationThread = new Promise<int>();
            Promise<int> promise = new Promise<int>(PromiseOptions.RunContinuationsAsynchronously);
            promise.Future.ContinueOnAnyThread().OnCompleted(delegate { continuationThread.TrySetResult(Thread.CurrentThread.ManagedThreadId); });
            promise.SetResult(1);
            ranBeforeSetResultReturned = continuationThread.IsCompleted;
            return continuationThread.Future;
        }
    }
}
