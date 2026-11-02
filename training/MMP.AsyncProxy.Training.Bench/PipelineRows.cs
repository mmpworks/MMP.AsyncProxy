using MMP.AsyncProxy.Training.Pipeline;
using MMP.AsyncProxy.Training.Pipeline.Async;
using MMP.AsyncProxy.Training.Pipeline.Threaded;

namespace MMP.AsyncProxy.Training.Bench;

/// <summary>
/// The pipeline job for the bench: N items through three stages with trays of 8 and
/// no write delay, so the cost measured is the hand-off itself: two tray crossings
/// per item, each one a park-and-wake when the stages fall out of step.
/// </summary>
internal static class PipelineRows
{
    private const int Capacity = 8;

    public static IEnumerable<BenchRow> For(int items)
    {
        yield return new BenchRow("pipeline", "threaded", () => Run(new ThreadedLine(), items));
        yield return new BenchRow("pipeline", "asyncproxy", () => Run(new IteratorLine(), items));
#if NET10_0_OR_GREATER
        yield return new BenchRow("pipeline", "modern", () => Run(new Modern.Pipeline.ChannelLine(), items));
#endif
    }

    private static bool Run(IAssemblyLine line, int items)
    {
        using (line)
        {
            // Skip the input that parses to the poison value, so every item comes out.
            var inputs = Enumerable.Range(0, items + 1).Where(x => Stages.Parse(x) != Stages.Poison).Take(items).ToArray();
            var result = line.Run(inputs, Capacity, writeDelayMs: 0);
            if (result.Outputs.Length != items || result.Dropped.Length != 0) return false;
            for (var i = 0; i < items; i++) if (result.Outputs[i] != Stages.Enrich(Stages.Parse(inputs[i]))) return false;
            return result.InFlightPeak <= 2 * Capacity + 3;
        }
    }
}
