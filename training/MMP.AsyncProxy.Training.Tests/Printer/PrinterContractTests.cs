using MMP.AsyncProxy.Training.Printer;
using Xunit;

namespace MMP.AsyncProxy.Training.Tests.Printer;

/// <summary>
/// The contract a receipt desk keeps: every receipt prints, in order, and the driver is only
/// ever called from the one thread that opened it, however many jobs arrive at once. Then the
/// two things the versions are allowed to differ on: whether a second job gets in while the
/// first waits for the paper, and what happens to a version that forgets the thread rule.
/// </summary>
public class PrinterContractTests
{
    // Each caller blocks until its job is done, so each gets a thread of its own. Blocking callers on the
    // pool would park its workers, and the async desk needs the pool for its timers.
    private static Task<PrintReport> Submit(IReceiptDesk desk, string job, int count, int feedMs) =>
        Task.Factory.StartNew(() => desk.PrintJob(Receipts(job, count), feedMs), TaskCreationOptions.LongRunning);

    private static string[] Receipts(string job, int count) =>
        Enumerable.Range(1, count).Select(i => $"{job}-{i}").ToArray();

    [Theory, MemberData(nameof(Desks.Correct), MemberType = typeof(Desks))]
    public void A_job_prints_every_receipt_in_order(string version)
    {
        using var desk = Desks.Open(version);
        var report = desk.PrintJob(Receipts("A", 4), feedMs: 5);

        Assert.Equal(4, report.Printed);
        Assert.Equal(0, report.Rejected);
        Assert.Equal(new[] { "A-1", "A-2", "A-3", "A-4" }, desk.Printer.Lines);
    }

    [Theory, MemberData(nameof(Desks.Correct), MemberType = typeof(Desks))]
    public async Task The_driver_is_only_ever_called_from_the_thread_that_opened_it(string version)
    {
        using var desk = Desks.Open(version);
        var jobs = Enumerable.Range(0, 3)
            .Select(j => Submit(desk, "J" + j, 3, 5))
            .ToArray();
        var reports = await Task.WhenAll(jobs);

        Assert.Equal(0, desk.Printer.Rejected);
        Assert.Equal(1, desk.Printer.CallerThreads);          // one thread called the driver, ever
        Assert.Equal(9, desk.Printer.Lines.Length);
        Assert.All(reports, r => Assert.Equal(3, r.Printed));
    }

    [Theory, MemberData(nameof(Desks.Correct), MemberType = typeof(Desks))]
    public async Task Each_jobs_own_receipts_stay_in_their_own_order(string version)
    {
        using var desk = Desks.Open(version);
        var a = Submit(desk, "A", 4, 20);
        var b = Submit(desk, "B", 4, 20);
        await Task.WhenAll(a, b);

        var lines = desk.Printer.Lines;
        Assert.Equal(new[] { "A-1", "A-2", "A-3", "A-4" }, lines.Where(l => l.StartsWith("A")));
        Assert.Equal(new[] { "B-1", "B-2", "B-3", "B-4" }, lines.Where(l => l.StartsWith("B")));
    }

    [Fact]
    public async Task The_threaded_desk_holds_the_owner_thread_through_every_paper_feed_so_a_second_job_waits_for_the_whole_first_one()
    {
        using var desk = Desks.Open("threaded");
        var a = Submit(desk, "A", 4, 80);
        Thread.Sleep(30);                                      // A has printed its first receipt and is feeding paper
        var b = Submit(desk, "B", 4, 80);
        await Task.WhenAll(a, b);

        var lines = desk.Printer.Lines;
        Assert.True(Array.IndexOf(lines, "B-1") > Array.IndexOf(lines, "A-4"),
            "B got in before A was done: " + string.Join(", ", lines));
    }

    [Fact]
    public async Task The_postback_desk_lets_a_second_job_in_while_the_first_waits_for_the_paper()
    {
        using var desk = Desks.Open("async-postback");
        var a = Submit(desk, "A", 4, 80);
        Thread.Sleep(30);                                      // A has printed its first receipt and is waiting on a timer
        var b = Submit(desk, "B", 4, 80);
        await Task.WhenAll(a, b);

        // The owner thread was free during A's waits, so B's first receipt printed in the gap.
        var lines = desk.Printer.Lines;
        Assert.True(Array.IndexOf(lines, "B-1") < Array.IndexOf(lines, "A-4"),
            "B waited for all of A: " + string.Join(", ", lines));
        Assert.Equal(0, desk.Printer.Rejected);
        Assert.Equal(1, desk.Printer.CallerThreads);
    }

    [Fact]
    public void A_version_that_forgets_the_thread_rule_is_refused_by_the_driver_and_says_so()
    {
        using var desk = Desks.Open("async-naive");
        var report = desk.PrintJob(Receipts("A", 4), feedMs: 5);

        Assert.True(report.Rejected > 0, "the driver took every call; the mistake did not show");
        Assert.True(report.Printed < 4);
        Assert.Contains("was opened on thread", report.FirstProblem);
        Assert.True(desk.Printer.CallerThreads > 1);
    }
}
