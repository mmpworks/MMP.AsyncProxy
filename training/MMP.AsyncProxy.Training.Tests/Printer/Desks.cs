using MMP.AsyncProxy.Training.Printer;
using MMP.AsyncProxy.Training.Printer.Async;
using MMP.AsyncProxy.Training.Printer.Threaded;

namespace MMP.AsyncProxy.Training.Tests.Printer;

/// <summary>The desks under test. The two that keep the driver's rule are the contract; the naive one is the mistake, tested on its own.</summary>
public static class Desks
{
    public static IEnumerable<object[]> Correct()
    {
        yield return ["threaded"];
        yield return ["async-postback"];
    }

    public static IReceiptDesk Open(string version) => version switch
    {
        "threaded" => new OwnerThreadDesk(),
        "async-postback" => new PostBackDesk(),
        "async-naive" => new NaiveDesk(),
        _ => throw new ArgumentOutOfRangeException(nameof(version), version, "no such desk"),
    };
}
