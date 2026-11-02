using MMP.AsyncProxy.Training.Deadline;
using MMP.AsyncProxy.Training.Deadline.Async;
using MMP.AsyncProxy.Training.Deadline.Threaded;

namespace MMP.AsyncProxy.Training.Bench;

/// <summary>
/// The deadline job for the bench: N calls one after another, each to a service that
/// stays silent on the first attempt and answers in 20 ms on the second, with a 60 ms
/// limit. Every call abandons one attempt. Peak threads shows what N abandoned
/// attempts left behind; elapsed is N times about 80 ms either way.
///
/// The margins are wide on purpose. Windows timers tick every 15.6 ms, so a 10 ms
/// answer against a 20 ms limit can land on the same tick and lose; the first draft
/// of this row did, and reported failures that were the clock's, not the callers'.
///
/// The threaded row goes last: its abandoned attempts are threads that never exit,
/// so every row after it would start from a baseline N threads higher.
/// </summary>
internal static class DeadlineRows
{
    private const int TimeoutMs = 60;
    private const int AnswerMs = 20;

    public static IEnumerable<BenchRow> For(int calls)
    {
        yield return new BenchRow("deadline", "asyncproxy", () => Run(new WhenAnyCaller(), calls));
#if NET10_0_OR_GREATER
        yield return new BenchRow("deadline", "modern", () => Run(new Modern.Deadline.TaskCaller(), calls));
#endif
        yield return new BenchRow("deadline", "threaded", () => Run(new ThreadPerAttemptCaller(), calls));
    }

    private static bool Run(IDeadlineCaller caller, int calls)
    {
        using (caller)
        {
            for (var i = 0; i < calls; i++)
            {
                var result = caller.Call(new FlakyService(-1, AnswerMs), TimeoutMs, maxAttempts: 2, new GiveUp());
                if (result.Outcome != CallOutcome.Answered || result.Attempts != 2)
                {
                    Console.Error.WriteLine($"[deadline {caller.Version}] call {i}: {result.Outcome} after {result.Attempts} attempts");
                    return false;
                }
            }
            return true;
        }
    }
}
