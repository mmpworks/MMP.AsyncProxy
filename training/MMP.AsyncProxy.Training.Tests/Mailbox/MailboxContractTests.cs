using System.Diagnostics;
using MMP.AsyncProxy.Training.Support;
using Xunit;

namespace MMP.AsyncProxy.Training.Tests.Mailbox;

/// <summary>
/// The contract every desk must keep. Written before the AsyncProxy version
/// existed and run first against the threaded one, so it is the anchor for
/// "the move kept the behaviour" rather than a description of what got built.
/// </summary>
public class MailboxContractTests
{
    [Theory, MemberData(nameof(Desks.All), MemberType = typeof(Desks))]
    public void Every_slip_is_handled_once_in_the_order_it_was_posted(string version)
    {
        using var desk = Desks.Open(version);
        var seen = new List<int>();
        var tray = desk.OpenTray<int>("orders", 64);
        using var clerk = desk.Seat("ann", tray, slip => { lock (seen) seen.Add(slip); });

        for (var i = 0; i < 50; i++) Assert.True(tray.TryPost(i), $"post {i} refused");

        Assert.True(clerk.WaitUntilIdle(5000), "clerk never went idle");
        Assert.Equal(Enumerable.Range(0, 50), seen);
        Assert.Equal(50, clerk.Handled);
        Assert.Equal(0, tray.Pending);
    }

    [Theory, MemberData(nameof(Desks.All), MemberType = typeof(Desks))]
    public void One_slip_at_a_time_and_never_two_at_once(string version)
    {
        using var desk = Desks.Open(version);
        var inHand = 0;
        var overlap = 0;
        var tray = desk.OpenTray<int>("orders", 256);
        using var clerk = desk.Seat("ann", tray, _ =>
        {
            if (Interlocked.Increment(ref inHand) > 1) Interlocked.Increment(ref overlap);
            Thread.SpinWait(200);
            Interlocked.Decrement(ref inHand);
        });

        // Post from four threads at once, so any desk that let two slips run together would show it.
        var posters = Enumerable.Range(0, 4).Select(p => new Thread(() =>
        {
            for (var i = 0; i < 50; i++) while (!tray.TryPost(p * 100 + i)) Thread.Yield();
        })).ToList();
        posters.ForEach(t => t.Start());
        posters.ForEach(t => t.Join());

        Assert.True(clerk.WaitUntilIdle(5000));
        Assert.Equal(200, clerk.Handled);
        Assert.Equal(0, overlap);
    }

    [Theory, MemberData(nameof(Desks.All), MemberType = typeof(Desks))]
    public void A_full_tray_refuses_the_next_slip_until_the_clerk_catches_up(string version)
    {
        using var desk = Desks.Open(version);
        using var hold = new ManualResetEventSlim(false);
        using var inHand = new ManualResetEventSlim(false);
        var tray = desk.OpenTray<int>("orders", 3);
        // The clerk takes the first slip and stops on it, so the tray fills behind it.
        using var clerk = desk.Seat("ann", tray, _ => { inHand.Set(); hold.Wait(); });

        Assert.True(tray.TryPost(0));
        Assert.True(inHand.Wait(2000), "the clerk never picked up slip 0");
        Assert.True(tray.TryPost(1));
        Assert.True(tray.TryPost(2));
        Assert.True(tray.TryPost(3));
        Assert.False(tray.TryPost(4), "a fourth slip fit in a tray of three");

        hold.Set();
        Assert.True(clerk.WaitUntilIdle(5000));
        Assert.Equal(4, clerk.Handled);
        Assert.True(tray.TryPost(5), "the tray stayed full after it drained");
    }

    [Theory, MemberData(nameof(Desks.All), MemberType = typeof(Desks))]
    public void A_slip_whose_handler_throws_does_not_unseat_the_clerk(string version)
    {
        using var desk = Desks.Open(version);
        var good = 0;
        var tray = desk.OpenTray<string>("orders", 16);
        using var clerk = desk.Seat("ann", tray, slip =>
        {
            if (slip == "bad") throw new InvalidOperationException("a bad slip");
            Interlocked.Increment(ref good);
        });

        tray.TryPost("ok");
        tray.TryPost("bad");
        tray.TryPost("ok");

        Assert.True(clerk.WaitUntilIdle(5000));
        Assert.Equal(3, clerk.Handled);
        Assert.Equal(2, good);
        Assert.True(clerk.IsRunning, "the clerk left after a bad slip");
    }

    [Theory, MemberData(nameof(Desks.All), MemberType = typeof(Desks))]
    public void Closing_the_tray_sends_the_clerk_home_and_refuses_new_slips(string version)
    {
        using var desk = Desks.Open(version);
        var tray = desk.OpenTray<int>("orders", 16);
        var clerk = desk.Seat("ann", tray, _ => { });
        Assert.True(clerk.IsRunning);

        tray.Close();

        WaitUntil(() => !clerk.IsRunning, 2000);
        Assert.False(clerk.IsRunning, "the clerk stayed after the tray closed");
        Assert.False(tray.TryPost(1), "a closed tray took a slip");
    }

    [Theory, MemberData(nameof(Desks.All), MemberType = typeof(Desks))]
    public void A_slip_posted_to_an_empty_tray_is_handled_within_a_few_milliseconds(string version)
    {
        using var desk = Desks.Open(version);
        using var handled = new ManualResetEventSlim(false);
        var tray = desk.OpenTray<int>("orders", 16);
        using var clerk = desk.Seat("ann", tray, _ => handled.Set());
        Thread.Sleep(50);                                   // let the clerk settle into its wait

        var clock = Stopwatch.StartNew();
        tray.TryPost(1);
        Assert.True(handled.Wait(1000), "the clerk never woke");
        Assert.True(clock.ElapsedMilliseconds < 100, $"wake-up took {clock.ElapsedMilliseconds} ms");
    }

    [Theory, MemberData(nameof(Desks.Threadless), MemberType = typeof(Desks))]
    public void Two_hundred_idle_clerks_hold_no_threads(string version)
    {
        using var desk = Desks.Open(version);
        var before = Process.GetCurrentProcess().Threads.Count;

        var clerks = new List<IDisposable>();
        for (var i = 0; i < 200; i++)
        {
            var tray = desk.OpenTray<int>("tray" + i, 8);
            clerks.Add(desk.Seat("clerk" + i, tray, _ => { }));
        }
        Thread.Sleep(100);

        var after = Process.GetCurrentProcess().Threads.Count;
        Assert.True(after - before < 20, $"{after - before} threads appeared for 200 idle clerks");
        clerks.ForEach(c => c.Dispose());
    }

    [Fact]
    public void Two_hundred_idle_threaded_clerks_hold_two_hundred_threads()
    {
        using var desk = Desks.Open("threaded");
        var before = Process.GetCurrentProcess().Threads.Count;

        var clerks = new List<IDisposable>();
        for (var i = 0; i < 200; i++)
        {
            var tray = desk.OpenTray<int>("tray" + i, 8);
            clerks.Add(desk.Seat("clerk" + i, tray, _ => { }));
        }
        Thread.Sleep(100);

        var after = Process.GetCurrentProcess().Threads.Count;
        Assert.True(after - before >= 200, $"only {after - before} threads appeared for 200 threaded clerks");
        clerks.ForEach(c => c.Dispose());
    }

    private static void WaitUntil(Func<bool> condition, int timeoutMs)
    {
        var deadline = DateTime.UtcNow.AddMilliseconds(timeoutMs);
        while (!condition() && DateTime.UtcNow < deadline) Thread.Sleep(1);
    }
}
