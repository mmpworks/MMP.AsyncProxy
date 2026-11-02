using MMP.AsyncProxy.Training.Deadline;
using MMP.AsyncProxy.Training.Deadline.Async;
using MMP.AsyncProxy.Training.Deadline.Threaded;

namespace MMP.AsyncProxy.Training.Tests.Deadline;

/// <summary>The callers under test, by name. Two on net48, three on net10.</summary>
public static class Callers
{
    public static IEnumerable<object[]> All()
    {
        yield return ["threaded"];
        yield return ["asyncproxy"];
#if NET10_0_OR_GREATER
        yield return ["modern"];
#endif
    }

    public static IEnumerable<object[]> Threadless()
    {
        yield return ["asyncproxy"];
#if NET10_0_OR_GREATER
        yield return ["modern"];
#endif
    }

    public static IDeadlineCaller Open(string version) => version switch
    {
        "threaded" => new ThreadPerAttemptCaller(),
        "asyncproxy" => new WhenAnyCaller(),
#if NET10_0_OR_GREATER
        "modern" => new Modern.Deadline.TaskCaller(),
#endif
        _ => throw new ArgumentOutOfRangeException(nameof(version), version, "no such caller"),
    };
}
