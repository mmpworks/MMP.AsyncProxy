using MMP.AsyncProxy.Training.Crunch;
using MMP.AsyncProxy.Training.Crunch.Async;
using MMP.AsyncProxy.Training.Crunch.Threaded;

namespace MMP.AsyncProxy.Training.Tests.Crunch;

/// <summary>The settlers under test, by name. Three versions, on both runtimes.</summary>
public static class Settlers
{
    public static IEnumerable<object[]> All()
    {
        yield return ["threaded"];
        yield return ["async-loop"];
        yield return ["async-pool"];
    }

    public static ISettler Open(string version) => version switch
    {
        "threaded" => new CrewSettler(),
        "async-loop" => new LoopSettler(),
        "async-pool" => new PoolFanOutSettler(),
        _ => throw new ArgumentOutOfRangeException(nameof(version), version, "no such settler"),
    };
}
