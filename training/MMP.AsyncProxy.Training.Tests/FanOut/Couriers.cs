using MMP.AsyncProxy.Training.FanOut;

namespace MMP.AsyncProxy.Training.Tests.FanOut;

/// <summary>The couriers under test, by name. Two on net48, three on net10.</summary>
public static class Couriers
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

    public static ICourier Open(string version) => version switch
    {
        "threaded" => new ThreadPerLetterCourier(),
        "asyncproxy" => new WhenAllCourier(),
#if NET10_0_OR_GREATER
        "modern" => new Modern.FanOut.TaskCourier(),
#endif
        _ => throw new ArgumentOutOfRangeException(nameof(version), version, "no such courier"),
    };
}
