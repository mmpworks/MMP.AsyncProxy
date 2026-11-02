using System.Diagnostics;
using MMP.AsyncProxy.Training.Crunch;
using MMP.AsyncProxy.Training.Crunch.Async;
using MMP.AsyncProxy.Training.Crunch.Threaded;
using MMP.AsyncProxy.Training.Support;

namespace MMP.AsyncProxy.Training.Bench;

/// <summary>
/// The crunch job for the bench, and the one table where the plain thread comes out ahead. A day of
/// sales is sealed three ways while a pulser-style heartbeat tries to tick every 20 ms. Elapsed is
/// the whole settle. Late is how far past 20 ms the worst and the average beat landed: the cost to
/// everything else in the process. Pool threads is whether any record was sealed on a borrowed
/// pool worker. Run it by itself, in a quiet process, and read the late column first:
///
///   dotnet run --project training/MMP.AsyncProxy.Training.Bench -c Release -f net10.0 -- crunch [sales] [rounds]
/// </summary>
internal static class CrunchTable
{
    private const int PeriodMs = 20;

    public static void Print(int sales, int rounds)
    {
        var day = Ledger.Day(sales);
        Console.WriteLine($"Runtime: {System.Runtime.InteropServices.RuntimeInformation.FrameworkDescription}, cores: {Environment.ProcessorCount}, {sales:N0} sales, {rounds} hash rounds each, heartbeat every {PeriodMs} ms");
        Console.WriteLine();

        var reference = Stopwatch.StartNew();
        var plain = Ledger.InOneLoop(day, rounds);
        reference.Stop();
        Console.WriteLine("{0,-12} {1,10} {2,13} {3,12} {4,13} {5,6}", "version", "elapsed ms", "peak threads", "worst late", "average late", "ok");
        Console.WriteLine("{0,-12} {1,10} {2,13} {3,12} {4,13} {5,6}", "one loop", reference.ElapsedMilliseconds, "-", "-", "-", "yes");

        foreach (var settler in new ISettler[] { new LoopSettler(), new PoolFanOutSettler(), new CrewSettler() })
        {
            using (settler)
            {
                Row(settler, day, rounds, plain);
            }
        }
    }

    private static void Row(ISettler settler, SaleRecord[] day, int rounds, Settlement plain)
    {
        Thread.Sleep(300);                       // let the pool settle between rows
        var heartbeat = new Heartbeat(PeriodMs);
        var sampler = new ThreadSampler();
        heartbeat.Start();
        var clock = Stopwatch.StartNew();
        var answer = settler.Settle(day, rounds);
        clock.Stop();
        var peak = sampler.Stop();
        var report = heartbeat.Stop();
        Console.WriteLine("{0,-12} {1,10} {2,13} {3,9} ms {4,10:F0} ms {5,6}", settler.Version, clock.ElapsedMilliseconds, peak,
            report.WorstLateMs, report.AverageLateMs, answer.SameAnswerAs(plain) ? "yes" : "NO");
    }
}
