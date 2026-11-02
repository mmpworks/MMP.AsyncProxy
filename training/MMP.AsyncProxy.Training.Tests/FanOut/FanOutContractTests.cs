using System.Diagnostics;
using MMP.AsyncProxy.Training.FanOut;
using MMP.AsyncProxy.Training.Support;
using Xunit;

namespace MMP.AsyncProxy.Training.Tests.FanOut;

/// <summary>
/// The contract every courier keeps: one reply per address in address order, a bounce
/// is one bad reply and never a failed batch, and N letters take one delay, not N.
/// Written before the AsyncProxy courier and run first against the threaded one.
/// </summary>
public class FanOutContractTests
{
    private static string[] Addresses(int n) => Enumerable.Range(1, n).Select(i => "box-" + i).ToArray();

    [Theory, MemberData(nameof(Couriers.All), MemberType = typeof(Couriers))]
    public void One_reply_per_address_in_the_order_they_were_sent(string version)
    {
        using var courier = Couriers.Open(version);
        var replies = courier.SendAll(Addresses(20), new PostOffice(delayMs: 10));

        Assert.Equal(20, replies.Length);
        Assert.All(replies, r => Assert.True(r.Ok, r.Address));
        Assert.Equal(Addresses(20), replies.Select(r => r.Address));
        Assert.Equal(Addresses(20).Select(a => "re: " + a), replies.Select(r => r.Text));
    }

    [Theory, MemberData(nameof(Couriers.All), MemberType = typeof(Couriers))]
    public void A_bounced_address_is_one_bad_reply_and_the_rest_still_come_back(string version)
    {
        using var courier = Couriers.Open(version);
        var office = new PostOffice(delayMs: 10).Bounce("box-3");
        var replies = courier.SendAll(Addresses(5), office);

        Assert.Equal([true, true, false, true, true], replies.Select(r => r.Ok));
        Assert.IsType<InvalidOperationException>(replies[2].Error);
        Assert.Contains("box-3", replies[2].Error!.Message);
        Assert.Null(replies[2].Text);
        Assert.Equal("re: box-5", replies[4].Text);
    }

    [Theory, MemberData(nameof(Couriers.All), MemberType = typeof(Couriers))]
    public void No_addresses_means_no_replies_and_no_wait(string version)
    {
        using var courier = Couriers.Open(version);
        var clock = Stopwatch.StartNew();
        var replies = courier.SendAll([], new PostOffice(delayMs: 500));
        Assert.Empty(replies);
        Assert.True(clock.ElapsedMilliseconds < 100, "waited for nothing");
    }

    [Theory, MemberData(nameof(Couriers.All), MemberType = typeof(Couriers))]
    public void Two_hundred_letters_take_one_delay_and_never_two_hundred(string version)
    {
        using var courier = Couriers.Open(version);
        var clock = Stopwatch.StartNew();
        var replies = courier.SendAll(Addresses(200), new PostOffice(delayMs: 100));
        clock.Stop();

        Assert.Equal(200, replies.Count(r => r.Ok));
        Assert.True(clock.ElapsedMilliseconds >= 100, $"came back in {clock.ElapsedMilliseconds} ms, before the delay");
        Assert.True(clock.ElapsedMilliseconds < 1500, $"took {clock.ElapsedMilliseconds} ms: the letters went one at a time");
    }

    [Theory, MemberData(nameof(Couriers.Threadless), MemberType = typeof(Couriers))]
    public void Two_hundred_letters_in_flight_add_no_threads(string version)
    {
        using var courier = Couriers.Open(version);
        var before = Process.GetCurrentProcess().Threads.Count;
        var sampler = new ThreadSampler();
        courier.SendAll(Addresses(200), new PostOffice(delayMs: 100));
        var peak = sampler.Stop();
        // No thread per letter. The pool itself may grow for a moment when 200 timers fire on the same
        // tick: on .NET 10 a cold process added 57 threads for the AsyncProxy courier and under 20 for
        // the modern one, and a warm one added 22. That is pool injection, not letters holding threads,
        // and it is row 6 of the improvements table in docs/prd-training.md. The threaded courier adds 200.
        Assert.True(peak - before < 100, $"{peak - before} threads appeared for 200 letters in flight");
    }

    [Fact]
    public void Two_hundred_threaded_letters_in_flight_are_two_hundred_threads()
    {
        using var courier = Couriers.Open("threaded");
        var before = Process.GetCurrentProcess().Threads.Count;
        var sampler = new ThreadSampler();
        // A longer delay than the other tests, so the first letters are still parked when the last thread starts.
        courier.SendAll(Addresses(200), new PostOffice(delayMs: 400));
        var peak = sampler.Stop();
        Assert.True(peak - before >= 150, $"only {peak - before} threads appeared for 200 threaded letters");
    }
}
