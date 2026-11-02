using MMP.AsyncProxy.Training.Deadline;

namespace MMP.AsyncProxy.Training.Modern.Deadline;

/// <summary>
/// The deadline the way a .NET 10 developer writes it: Task.Delay with a
/// CancellationToken as the clock, Task.WhenAny against the answer, and a
/// CancellationTokenSource as the cord. The compiler builds the attempts machine;
/// WhenAnyCaller builds it from an iterator.
/// </summary>
public sealed class TaskCaller : IDeadlineCaller
{
    public string Version => "modern";

    public CallResult Call(FlakyService service, int timeoutMs, int maxAttempts, GiveUp giveUp)
    {
        var cord = new CancellationTokenSource();
        giveUp.OnFired(cord.Cancel);
        return Attempts(service, timeoutMs, maxAttempts, cord.Token).GetAwaiter().GetResult();
    }

    private static async Task<CallResult> Attempts(FlakyService service, int timeoutMs, int maxAttempts, CancellationToken cord)
    {
        for (var attempt = 0; attempt < maxAttempts; attempt++)
        {
            if (cord.IsCancellationRequested) return new CallResult(CallOutcome.Cancelled, null, attempt);

            var answer = Ask(service, attempt);
            var clock = Task.Delay(timeoutMs, cord);
            var first = await Task.WhenAny(answer, clock).ConfigureAwait(false);

            if (first == answer) return new CallResult(CallOutcome.Answered, answer.Result, attempt + 1);
            if (cord.IsCancellationRequested) return new CallResult(CallOutcome.Cancelled, null, attempt + 1);
            // The clock won: abandon the attempt. Its task stays pending, and that is all that stays.
        }
        return new CallResult(CallOutcome.GaveUp, null, maxAttempts);
    }

    /// <summary>The service's timer door, in Task form: the same scripted delay, or a task that never completes.</summary>
    private static async Task<string> Ask(FlakyService service, int attempt)
    {
        var delay = service.DelayFor(attempt);
        if (delay < 0) await new TaskCompletionSource<string>().Task.ConfigureAwait(false);   // never
        else await Task.Delay(delay).ConfigureAwait(false);
        return service.Answer(attempt);
    }

    public void Dispose() { }
}
