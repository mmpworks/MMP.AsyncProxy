using System.Diagnostics;
using MMP.AsyncProxy.Training.Printer;
using MMP.AsyncProxy.Training.Printer.Async;
using MMP.AsyncProxy.Training.Printer.Threaded;

namespace MMP.AsyncProxy.Training.Bench;

/// <summary>
/// The printer job for the bench: several jobs arrive at once at a desk whose driver insists on
/// one thread. Each job prints 5 receipts and waits 40 ms after each for the paper. The owner
/// thread is the one thing every version has to keep. What differs is whether it sits through
/// each paper feed (threaded) or goes back to its line while a timer waits (async-postback).
/// Rejected calls are the driver refusing a wrong-thread call; the naive version is here to show them.
///
///   dotnet run --project training/MMP.AsyncProxy.Training.Bench -c Release -f net10.0 -- printer [jobs]
/// </summary>
internal static class PrinterTable
{
    private const int Receipts = 5;
    private const int FeedMs = 40;

    public static void Print(int jobs)
    {
        Console.WriteLine($"Runtime: {System.Runtime.InteropServices.RuntimeInformation.FrameworkDescription}, cores: {Environment.ProcessorCount}, {jobs} jobs at once, {Receipts} receipts each, {FeedMs} ms paper feed after each");
        Console.WriteLine($"One job alone takes about {Receipts * FeedMs} ms.");
        Console.WriteLine();
        Console.WriteLine("{0,-16} {1,10} {2,8} {3,10} {4,15}", "version", "elapsed ms", "printed", "rejected", "driver threads");
        foreach (var version in new[] { "threaded", "async-postback", "async-naive" })
        {
            using var desk = version switch
            {
                "threaded" => (IReceiptDesk)new OwnerThreadDesk(),
                "async-postback" => new PostBackDesk(),
                _ => new NaiveDesk(),
            };
            var clock = Stopwatch.StartNew();
            // Each caller gets a thread of its own (LongRunning). Callers that block on the pool would
            // park its workers, and the async version needs the pool for its timers: the starvation
            // problem from chapter 6, found in this bench's first draft.
            var tasks = Enumerable.Range(0, jobs)
                .Select(j => Task.Factory.StartNew(() => desk.PrintJob(Enumerable.Range(1, Receipts).Select(r => $"J{j}-{r}").ToArray(), FeedMs), TaskCreationOptions.LongRunning))
                .ToArray();
            Task.WaitAll(tasks);
            clock.Stop();
            Console.WriteLine("{0,-16} {1,10} {2,8} {3,10} {4,15}", desk.Version, clock.ElapsedMilliseconds,
                desk.Printer.Lines.Length, desk.Printer.Rejected, desk.Printer.CallerThreads);
        }
    }
}
