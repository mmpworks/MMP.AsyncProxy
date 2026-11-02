using MMP.AsyncProxy.Training.Mailbox;
using MMP.AsyncProxy.Training.Mailbox.Async;
using MMP.AsyncProxy.Training.Mailbox.Threaded;

namespace MMP.AsyncProxy.Training.Tests.Mailbox;

/// <summary>
/// The versions under test, by name. xunit theories take the name so a failure
/// says which desk failed. On net48 there are two; on net10 the modern one joins.
/// </summary>
public static class Desks
{
    public static IEnumerable<object[]> All()
    {
        yield return ["threaded"];
        yield return ["asyncproxy"];
#if NET10_0_OR_GREATER
        yield return ["modern"];
#endif
    }

    /// <summary>The desks that hold no thread for an idle clerk. The thread test is about these.</summary>
    public static IEnumerable<object[]> Threadless()
    {
        yield return ["asyncproxy"];
#if NET10_0_OR_GREATER
        yield return ["modern"];
#endif
    }

    public static IDesk Open(string version) => version switch
    {
        "threaded" => new ThreadedDesk(),
        "asyncproxy" => new AsyncProxyDesk(),
#if NET10_0_OR_GREATER
        "modern" => new Modern.Mailbox.ModernDesk(),
#endif
        _ => throw new ArgumentOutOfRangeException(nameof(version), version, "no such desk"),
    };
}
