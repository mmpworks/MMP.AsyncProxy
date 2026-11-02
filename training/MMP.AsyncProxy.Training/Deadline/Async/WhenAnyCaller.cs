using System;
using System.Collections.Generic;

namespace MMP.AsyncProxy.Training.Deadline.Async
{
    /// <summary>
    /// The same deadline with no thread per attempt. Each attempt is a future from the
    /// service's timer door. The time limit is Futures.Delay with the give-up token on
    /// it. WhenAny says which finished first: the answer, or the clock, or the cord
    /// (which cancels the clock). An abandoned attempt is a pending promise nobody
    /// completes: a few dozen bytes that the collector takes when the service forgets
    /// it, and no thread anywhere.
    /// </summary>
    public sealed class WhenAnyCaller : IDeadlineCaller
    {
        public string Version { get { return "asyncproxy"; } }

        public CallResult Call(FlakyService service, int timeoutMs, int maxAttempts, GiveUp giveUp)
        {
            CancelSource cord = new CancelSource();
            giveUp.OnFired(cord.Cancel);
            IFuture<CallResult> call = AsyncProxy.Run<CallResult>(delegate(Return<CallResult> ret) { return Attempts(service, timeoutMs, maxAttempts, cord.Token, ret); });
            return call.Result;                                   // the caller, parked once, at the top
        }

        private static IEnumerable<IFuture> Attempts(FlakyService service, int timeoutMs, int maxAttempts, CancelToken cord, Return<CallResult> ret)
        {
            for (int attempt = 0; attempt < maxAttempts; attempt++)
            {
                if (cord.IsCancelRequested) { ret.Value = new CallResult(CallOutcome.Cancelled, null, attempt); yield break; }

                IFuture<string> answer = service.AskAsync(attempt);
                IFuture clock = Futures.Delay(timeoutMs, cord);         // the cord cancels the clock
                IFuture<IFuture> first = Futures.WhenAny(answer, clock);
                yield return first;                                     // parked on whichever comes first; no thread

                if (first.Result == answer) { ret.Value = new CallResult(CallOutcome.Answered, answer.Result, attempt + 1); yield break; }
                if (cord.IsCancelRequested) { ret.Value = new CallResult(CallOutcome.Cancelled, null, attempt + 1); yield break; }
                // The clock won: abandon the attempt. Its promise stays pending, and that is all that stays.
            }
            ret.Value = new CallResult(CallOutcome.GaveUp, null, maxAttempts);
        }

        public void Dispose() { }
    }
}
