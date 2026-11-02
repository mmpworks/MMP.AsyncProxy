using MMP.AsyncProxy.Training.Pipeline;
using MMP.AsyncProxy.Training.Pipeline.Async;
using MMP.AsyncProxy.Training.Pipeline.Threaded;

namespace MMP.AsyncProxy.Training.Tests.Pipeline;

/// <summary>The lines under test, by name. Two on net48, three on net10.</summary>
public static class Lines
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

    public static IAssemblyLine Open(string version) => version switch
    {
        "threaded" => new ThreadedLine(),
        "asyncproxy" => new IteratorLine(),
#if NET10_0_OR_GREATER
        "modern" => new Modern.Pipeline.ChannelLine(),
#endif
        _ => throw new ArgumentOutOfRangeException(nameof(version), version, "no such line"),
    };
}
