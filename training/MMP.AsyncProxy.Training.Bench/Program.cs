using System;
using System.Collections.Generic;
using System.Diagnostics;
using MMP.AsyncProxy.Training.Support;

namespace MMP.AsyncProxy.Training.Bench;

/// <summary>
/// One table: for each mini-project and each version, how long it took, how many
/// threads the process held at its peak, how many bytes it allocated, and the peak
/// working set. The rows are filled in as each slice lands. Run it on both runtimes:
///
///   dotnet run --project training/MMP.AsyncProxy.Training.Bench -c Release -f net48
///   dotnet run --project training/MMP.AsyncProxy.Training.Bench -c Release -f net10.0
/// </summary>
internal static class Program
{
    private static void Main(string[] args)
    {
        var n = args.Length > 0 ? int.Parse(args[0]) : 1000;
        Console.WriteLine($"Runtime: {System.Runtime.InteropServices.RuntimeInformation.FrameworkDescription}, cores: {Environment.ProcessorCount}, N = {n}");
        Console.WriteLine();
        Console.WriteLine("{0,-12} {1,-12} {2,10} {3,13} {4,16} {5,14} {6,5}", "project", "version", "elapsed ms", "peak threads", "allocated bytes", "peak WS bytes", "ok");
        foreach (var row in Rows.All(n)) Console.WriteLine(row.Measure());
    }
}

/// <summary>A job to measure: a name, a version, and the work itself, which returns true when its answer was right.</summary>
internal sealed class BenchRow(string project, string version, Func<bool> work)
{
    public string Project => project;
    public string Version => version;
    public Func<bool> Work => work;

    /// <summary>
    /// Two passes over the same work. The first runs under the thread sampler for elapsed time and
    /// peak threads. The second runs with no sampler for the allocation count, because the sampler
    /// itself allocates: on .NET Framework, Process.Threads reads the whole system process table
    /// on every call, and a long row under a 5 ms sampler once showed 700 MB that was all sampler.
    /// </summary>
    public string Measure()
    {
        Settle();
        var sampler = new ThreadSampler();
        var clock = Stopwatch.StartNew();
        var ok = Work();
        clock.Stop();
        var peakThreads = sampler.Stop();
        var peakWorkingSet = Process.GetCurrentProcess().PeakWorkingSet64;

        Settle();
        var allocatedBefore = Allocated();
        ok &= Work();
        var allocated = Allocated() - allocatedBefore;

        return string.Format("{0,-12} {1,-12} {2,10} {3,13} {4,16:N0} {5,14:N0} {6,5}", Project, Version, clock.ElapsedMilliseconds, peakThreads, allocated, peakWorkingSet, ok ? "yes" : "NO");
    }

    private static void Settle()
    {
        GC.Collect();
        GC.WaitForPendingFinalizers();
        GC.Collect();
        Thread.Sleep(200);          // let the pool shed the threads the last row woke, so peaks do not bleed between rows
    }

    private static long Allocated()
    {
#if NET48
        // Needs AppDomain monitoring switched on once; the first read turns it on.
        AppDomain.MonitoringIsEnabled = true;
        return AppDomain.CurrentDomain.MonitoringTotalAllocatedMemorySize;
#else
        return GC.GetTotalAllocatedBytes(precise: true);
#endif
    }
}

/// <summary>The rows, one group per mini-project. Each slice adds its group here.</summary>
internal static class Rows
{
    public static IEnumerable<BenchRow> All(int n)
    {
        foreach (var row in MailboxRows.For(n)) yield return row;
        foreach (var row in FanOutRows.For(n)) yield return row;
    }
}
