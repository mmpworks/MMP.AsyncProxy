using System.Diagnostics;
using MMP.AsyncProxy.Training.Pipeline;
using MMP.AsyncProxy.Training.Support;
using Xunit;

namespace MMP.AsyncProxy.Training.Tests.Pipeline;

/// <summary>
/// The contract every line keeps: every input comes out transformed and in order, a
/// poison item is dropped and the line goes on, and the trays bound how far ahead the
/// fast stages can run. Written before the AsyncProxy line and run first against the
/// threaded one.
/// </summary>
public class PipelineContractTests
{
    private static int[] Inputs(int n) => Enumerable.Range(0, n).ToArray();
    private static int Expected(int x) => Stages.Enrich(Stages.Parse(x));

    [Theory, MemberData(nameof(Lines.All), MemberType = typeof(Lines))]
    public void Every_input_comes_out_transformed_and_in_order(string version)
    {
        using var line = Lines.Open(version);
        var inputs = Inputs(500).Where(x => Stages.Parse(x) != Stages.Poison).ToArray();
        var result = line.Run(inputs, trayCapacity: 4, writeDelayMs: 0);

        Assert.Equal(inputs.Select(Expected), result.Outputs);
        Assert.Empty(result.Dropped);
    }

    [Theory, MemberData(nameof(Lines.All), MemberType = typeof(Lines))]
    public void A_poison_item_is_dropped_and_the_line_goes_on(string version)
    {
        using var line = Lines.Open(version);
        var inputs = Inputs(30);                                   // 12 parses to 13, the poison value
        var result = line.Run(inputs, trayCapacity: 4, writeDelayMs: 0);

        Assert.Equal([Stages.Poison], result.Dropped);
        Assert.Equal(inputs.Where(x => x != 12).Select(Expected), result.Outputs);
    }

    [Theory, MemberData(nameof(Lines.All), MemberType = typeof(Lines))]
    public void The_trays_bound_how_far_ahead_the_fast_stages_run(string version)
    {
        using var line = Lines.Open(version);
        var inputs = Inputs(200).Where(x => Stages.Parse(x) != Stages.Poison).ToArray();
        // The writer is slow, so parse and enrich would run away without the trays.
        var result = line.Run(inputs, trayCapacity: 4, writeDelayMs: 2);

        Assert.Equal(inputs.Length, result.Outputs.Length);
        // Two trays of 4, plus one item in each of the three stages' hands.
        Assert.True(result.InFlightPeak <= 2 * 4 + 3, $"{result.InFlightPeak} items in flight with trays of 4");
        Assert.True(result.InFlightPeak >= 4, $"only {result.InFlightPeak} in flight: the trays never filled");
    }

    [Theory, MemberData(nameof(Lines.All), MemberType = typeof(Lines))]
    public void No_inputs_means_no_outputs_and_the_line_still_finishes(string version)
    {
        using var line = Lines.Open(version);
        var clock = Stopwatch.StartNew();
        var result = line.Run([], trayCapacity: 4, writeDelayMs: 50);
        Assert.Empty(result.Outputs);
        Assert.True(clock.ElapsedMilliseconds < 1000, "an empty line hung");
    }

    [Theory, MemberData(nameof(Lines.Threadless), MemberType = typeof(Lines))]
    public void A_waiting_line_holds_no_threads(string version)
    {
        using var line = Lines.Open(version);
        var before = Process.GetCurrentProcess().Threads.Count;
        var sampler = new ThreadSampler();
        line.Run(Inputs(100).Where(x => Stages.Parse(x) != Stages.Poison).ToArray(), trayCapacity: 2, writeDelayMs: 3);
        var peak = sampler.Stop();
        // No thread per stage. The pool grows a little for the writer's timers: 14 on both runtimes in
        // this test, every run, against 3 dedicated threads for the threaded line that never go back.
        // Row 6 of the improvements table in docs/prd-training.md is the timer change that shrinks it.
        Assert.True(peak - before < 30, $"{peak - before} threads appeared for three waiting stages");
    }

    [Fact]
    public void A_waiting_threaded_line_holds_three_threads()
    {
        using var line = Lines.Open("threaded");
        var before = Process.GetCurrentProcess().Threads.Count;
        var sampler = new ThreadSampler();
        line.Run(Inputs(100).Where(x => Stages.Parse(x) != Stages.Poison).ToArray(), trayCapacity: 2, writeDelayMs: 3);
        var peak = sampler.Stop();
        Assert.True(peak - before >= 3, $"only {peak - before} threads appeared for three threaded stages");
    }
}
