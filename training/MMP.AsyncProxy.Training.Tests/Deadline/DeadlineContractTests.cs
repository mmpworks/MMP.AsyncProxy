using System.Diagnostics;
using MMP.AsyncProxy.Training.Deadline;
using MMP.AsyncProxy.Training.Support;
using Xunit;

namespace MMP.AsyncProxy.Training.Tests.Deadline;

/// <summary>
/// The contract every caller keeps: an attempt past the limit is abandoned and the
/// next starts; after the last one the call gives up; a late answer breaks nothing;
/// a pull on the cord ends the call mid-attempt. Written before the AsyncProxy caller
/// and run first against the threaded one.
/// </summary>
public class DeadlineContractTests
{
    private const int Never = -1;

    [Theory, MemberData(nameof(Callers.All), MemberType = typeof(Callers))]
    public void A_prompt_answer_ends_the_call_on_the_first_attempt(string version)
    {
        using var caller = Callers.Open(version);
        var result = caller.Call(new FlakyService(10), timeoutMs: 200, maxAttempts: 3, new GiveUp());

        Assert.Equal(CallOutcome.Answered, result.Outcome);
        Assert.Equal("ok on attempt 1", result.Reply);
        Assert.Equal(1, result.Attempts);
    }

    [Theory, MemberData(nameof(Callers.All), MemberType = typeof(Callers))]
    public void Two_silent_attempts_are_abandoned_and_the_third_answers(string version)
    {
        using var caller = Callers.Open(version);
        var service = new FlakyService(Never, Never, 10);
        var clock = Stopwatch.StartNew();
        var result = caller.Call(service, timeoutMs: 100, maxAttempts: 3, new GiveUp());
        clock.Stop();

        Assert.Equal(CallOutcome.Answered, result.Outcome);
        Assert.Equal("ok on attempt 3", result.Reply);
        Assert.Equal(3, result.Attempts);
        Assert.True(clock.ElapsedMilliseconds >= 200, $"answered in {clock.ElapsedMilliseconds} ms, before two timeouts could pass");
        Assert.True(clock.ElapsedMilliseconds < 600, $"took {clock.ElapsedMilliseconds} ms for two timeouts and a 10 ms answer");
    }

    [Theory, MemberData(nameof(Callers.All), MemberType = typeof(Callers))]
    public void Every_attempt_silent_means_the_call_gives_up_after_the_last_limit(string version)
    {
        using var caller = Callers.Open(version);
        var clock = Stopwatch.StartNew();
        var result = caller.Call(new FlakyService(Never), timeoutMs: 50, maxAttempts: 3, new GiveUp());
        clock.Stop();

        Assert.Equal(CallOutcome.GaveUp, result.Outcome);
        Assert.Null(result.Reply);
        Assert.Equal(3, result.Attempts);
        Assert.True(clock.ElapsedMilliseconds >= 150, $"gave up in {clock.ElapsedMilliseconds} ms, before three limits");
    }

    [Theory, MemberData(nameof(Callers.All), MemberType = typeof(Callers))]
    public void A_late_answer_to_an_abandoned_attempt_lands_nowhere_and_breaks_nothing(string version)
    {
        using var caller = Callers.Open(version);
        var service = new FlakyService(150);                     // answers, but after the limit
        var result = caller.Call(service, timeoutMs: 50, maxAttempts: 1, new GiveUp());

        Assert.Equal(CallOutcome.GaveUp, result.Outcome);
        Assert.Equal(0, service.Answers);
        Thread.Sleep(250);                                       // the late answer arrives now
        Assert.Equal(1, service.Answers);                        // the service answered; nobody was there; nothing threw
    }

    [Theory, MemberData(nameof(Callers.All), MemberType = typeof(Callers))]
    public void Pulling_the_cord_mid_attempt_ends_the_call_at_once(string version)
    {
        using var caller = Callers.Open(version);
        var giveUp = new GiveUp();
        var puller = new Thread(() => { Thread.Sleep(40); giveUp.Fire(); });
        puller.Start();

        var clock = Stopwatch.StartNew();
        var result = caller.Call(new FlakyService(Never), timeoutMs: 2000, maxAttempts: 3, giveUp);
        clock.Stop();
        puller.Join();

        Assert.Equal(CallOutcome.Cancelled, result.Outcome);
        Assert.Equal(1, result.Attempts);
        Assert.True(clock.ElapsedMilliseconds < 1000, $"the cord took {clock.ElapsedMilliseconds} ms to end the call");
    }

    [Theory, MemberData(nameof(Callers.All), MemberType = typeof(Callers))]
    public void A_cord_pulled_before_the_call_means_no_attempt_at_all(string version)
    {
        using var caller = Callers.Open(version);
        var giveUp = new GiveUp();
        giveUp.Fire();
        var service = new FlakyService(10);
        var result = caller.Call(service, timeoutMs: 200, maxAttempts: 3, giveUp);

        Assert.Equal(CallOutcome.Cancelled, result.Outcome);
        Assert.Equal(0, result.Attempts);
        Thread.Sleep(50);
        Assert.Equal(0, service.Answers);
    }

    [Theory, MemberData(nameof(Callers.Threadless), MemberType = typeof(Callers))]
    public void Fifty_abandoned_attempts_leave_no_threads_behind(string version)
    {
        using var caller = Callers.Open(version);
        var before = Process.GetCurrentProcess().Threads.Count;
        for (var i = 0; i < 50; i++) caller.Call(new FlakyService(Never), timeoutMs: 5, maxAttempts: 1, new GiveUp());
        Thread.Sleep(200);                                       // let the pool shed what it added for the timers
        var after = Process.GetCurrentProcess().Threads.Count;
        Assert.True(after - before < 20, $"{after - before} threads stayed behind after 50 abandoned attempts");
    }

    [Fact]
    public void Fifty_abandoned_threaded_attempts_leave_fifty_threads_behind()
    {
        using var caller = Callers.Open("threaded");
        Thread.Sleep(300);                                       // let the pool shed what the last test added, so "before" is a floor
        var before = Process.GetCurrentProcess().Threads.Count;
        for (var i = 0; i < 50; i++) caller.Call(new FlakyService(Never), timeoutMs: 5, maxAttempts: 1, new GiveUp());
        // Each abandoned attempt is a thread parked inside Ask with nothing to wake it. They are
        // background threads, so the process can still exit; until then they are gone for good.
        var deadline = DateTime.UtcNow.AddSeconds(3);
        while (Process.GetCurrentProcess().Threads.Count - before < 45 && DateTime.UtcNow < deadline) Thread.Sleep(10);
        var after = Process.GetCurrentProcess().Threads.Count;
        Assert.True(after - before >= 45, $"only {after - before} threads stayed behind after 50 abandoned attempts");
    }
}
