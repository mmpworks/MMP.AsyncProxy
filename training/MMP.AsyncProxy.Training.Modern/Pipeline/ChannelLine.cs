using System.Threading.Channels;
using MMP.AsyncProxy.Training.Pipeline;

namespace MMP.AsyncProxy.Training.Modern.Pipeline;

/// <summary>
/// The line the way a .NET 10 developer writes it: a bounded Channel between each
/// pair of stages, WriteAsync for the wait-for-room and ReadAllAsync for the
/// wait-for-item, and an async method per stage. The compiler builds three machines;
/// IteratorLine builds them from iterators over PromiseTray.
/// </summary>
public sealed class ChannelLine : IAssemblyLine
{
    public string Version => "modern";

    public LineResult Run(int[] inputs, int trayCapacity, int writeDelayMs)
    {
        var parsed = Channel.CreateBounded<int>(new BoundedChannelOptions(trayCapacity) { SingleReader = true, SingleWriter = true });
        var enriched = Channel.CreateBounded<int>(new BoundedChannelOptions(trayCapacity) { SingleReader = true, SingleWriter = true });
        var outputs = new List<int>(inputs.Length);
        var dropped = new List<int>();
        var meter = new InFlightMeter();

        _ = ParseStage(inputs, parsed.Writer, meter);
        _ = EnrichStage(parsed.Reader, enriched.Writer, dropped, meter);
        WriteStage(enriched.Reader, outputs, writeDelayMs, meter).GetAwaiter().GetResult();   // the caller, parked once
        return new LineResult([.. outputs], [.. dropped], meter.Peak);
    }

    private static async Task ParseStage(int[] inputs, ChannelWriter<int> ahead, InFlightMeter meter)
    {
        foreach (var x in inputs)
        {
            meter.Entered();
            await ahead.WriteAsync(Stages.Parse(x)).ConfigureAwait(false);     // parks only when the channel ahead is full
        }
        ahead.Complete();
    }

    private static async Task EnrichStage(ChannelReader<int> behind, ChannelWriter<int> ahead, List<int> dropped, InFlightMeter meter)
    {
        await foreach (var x in behind.ReadAllAsync().ConfigureAwait(false))   // parks only when the channel behind is empty
        {
            int enrichedItem;
            try { enrichedItem = Stages.Enrich(x); }
            catch (InvalidOperationException) { dropped.Add(x); meter.Left(); continue; }
            await ahead.WriteAsync(enrichedItem).ConfigureAwait(false);
        }
        ahead.Complete();
    }

    private static async Task WriteStage(ChannelReader<int> behind, List<int> outputs, int writeDelayMs, InFlightMeter meter)
    {
        await foreach (var x in behind.ReadAllAsync().ConfigureAwait(false))
        {
            if (writeDelayMs > 0) await Task.Delay(writeDelayMs).ConfigureAwait(false);
            outputs.Add(x);
            meter.Left();
        }
    }

    public void Dispose() { }
}
