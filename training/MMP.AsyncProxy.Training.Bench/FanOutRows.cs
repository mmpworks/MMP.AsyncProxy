using MMP.AsyncProxy.Training.FanOut;

namespace MMP.AsyncProxy.Training.Bench;

/// <summary>
/// The fan-out job for the bench: N letters at once to an office that answers in
/// 100 ms, and every reply read. Elapsed shows whether the letters overlapped;
/// peak threads shows what each in-flight letter held.
/// </summary>
internal static class FanOutRows
{
    private const int DelayMs = 100;

    public static IEnumerable<BenchRow> For(int letters)
    {
        yield return new BenchRow("fan-out", "threaded", () => Run(new ThreadPerLetterCourier(), letters));
        yield return new BenchRow("fan-out", "asyncproxy", () => Run(new WhenAllCourier(), letters));
#if NET10_0_OR_GREATER
        yield return new BenchRow("fan-out", "modern", () => Run(new Modern.FanOut.TaskCourier(), letters));
#endif
    }

    private static bool Run(ICourier courier, int letters)
    {
        using (courier)
        {
            var addresses = new string[letters];
            for (var i = 0; i < letters; i++) addresses[i] = "box-" + i;
            var replies = courier.SendAll(addresses, new PostOffice(DelayMs));
            var ok = replies.Length == letters;
            for (var i = 0; i < letters && ok; i++) ok = replies[i].Ok && replies[i].Text == "re: " + addresses[i];
            return ok;
        }
    }
}
