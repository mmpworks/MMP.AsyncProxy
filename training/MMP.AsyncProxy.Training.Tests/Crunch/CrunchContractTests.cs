using System.Diagnostics;
using MMP.AsyncProxy.Training.Crunch;
using MMP.AsyncProxy.Training.Crunch.Async;
using MMP.AsyncProxy.Training.Crunch.Threaded;
using Xunit;

namespace MMP.AsyncProxy.Training.Tests.Crunch;

/// <summary>
/// The contract every settler keeps: close the day and get the same money and the same checksum
/// as one plain loop gives, however the work was split. After that, the tests pin down where the
/// work happened, because that is the whole difference between the versions: a crew of threads of
/// its own, or workers borrowed from the thread pool.
/// </summary>
public class CrunchContractTests
{
    private const int Rounds = 50;

    [Theory, MemberData(nameof(Settlers.All), MemberType = typeof(Settlers))]
    public void Every_version_gets_the_same_answer_as_one_plain_loop(string version)
    {
        var day = Ledger.Day(1_500);
        var reference = Ledger.InOneLoop(day, Rounds);

        using var settler = Settlers.Open(version);
        var answer = settler.Settle(day, Rounds);

        Assert.Equal(1_500, answer.Count);
        Assert.True(answer.SameAnswerAs(reference), $"{version} disagreed with the plain loop");
        Assert.Equal(answer.TotalCents, answer.CentsByGrade.Sum());
    }

    [Theory, MemberData(nameof(Settlers.All), MemberType = typeof(Settlers))]
    public void A_short_day_with_fewer_sales_than_workers_still_settles(string version)
    {
        var day = Ledger.Day(2);
        using var settler = Settlers.Open(version);
        var answer = settler.Settle(day, Rounds);

        Assert.Equal(2, answer.Count);
        Assert.True(answer.SameAnswerAs(Ledger.InOneLoop(day, Rounds)));
    }

    [Fact]
    public void The_crew_seals_on_threads_of_its_own_and_never_borrows_from_the_pool()
    {
        using var settler = new CrewSettler(3);
        var answer = settler.Settle(Ledger.Day(900), Rounds);

        Assert.False(answer.RanOnPoolThreads);
        Assert.Equal(3, answer.ThreadsUsed);
    }

    [Theory]
    [InlineData("async-loop")]
    [InlineData("async-pool")]
    public void The_async_versions_do_their_cpu_work_on_borrowed_pool_threads(string version)
    {
        using var settler = Settlers.Open(version);
        var answer = settler.Settle(Ledger.Day(900), Rounds);

        // Async did not make the sealing go away. It moved it onto the pool's workers.
        Assert.True(answer.RanOnPoolThreads);
    }

    [Fact]
    public void The_loop_only_ever_has_one_chunk_in_flight_so_it_uses_one_thread_at_a_time()
    {
        // The chunks run one after another. They may land on different pool threads over time,
        // but never two at once, so no overlap is possible: its wall time is the sum of the chunks.
        var day = Ledger.Day(2_000);
        var one = Stopwatch.StartNew();
        Ledger.InOneLoop(day, 200);
        one.Stop();

        using var loop = new LoopSettler();
        var clock = Stopwatch.StartNew();
        loop.Settle(day, 200);
        clock.Stop();

        Assert.True(clock.ElapsedMilliseconds >= one.ElapsedMilliseconds * 0.6,
            $"the loop took {clock.ElapsedMilliseconds} ms against {one.ElapsedMilliseconds} ms for one plain loop; chunks cannot overlap");
    }

    [Fact]
    public void Two_crew_threads_beat_one_when_there_are_two_cores_to_run_on()
    {
        if (Environment.ProcessorCount < 2) return;           // one core: nothing to prove
        var day = Ledger.Day(3_000);
        Ledger.InOneLoop(Ledger.Day(100), 200);               // warm the hash code before timing

        using var one = new CrewSettler(1);
        var oneClock = Stopwatch.StartNew();
        one.Settle(day, 200);
        oneClock.Stop();

        using var two = new CrewSettler(2);
        var twoClock = Stopwatch.StartNew();
        two.Settle(day, 200);
        twoClock.Stop();

        Assert.True(twoClock.ElapsedMilliseconds < oneClock.ElapsedMilliseconds * 0.85,
            $"two threads took {twoClock.ElapsedMilliseconds} ms, one took {oneClock.ElapsedMilliseconds} ms");
    }

    [Fact]
    public void The_heartbeat_stays_on_time_while_the_crew_works()
    {
        // Leave a core free and the pulser's timer finds a pool worker at once.
        var crew = Math.Max(1, Environment.ProcessorCount - 1);
        using var settler = new CrewSettler(crew);
        var heartbeat = new Heartbeat(20);
        heartbeat.Start();
        var clock = Stopwatch.StartNew();
        settler.Settle(Ledger.Day(6_000), 200);                // about a second of work, depending on the machine
        clock.Stop();
        var report = heartbeat.Stop();

        Assert.True(report.Beats >= 3, $"only {report.Beats} beats in {clock.ElapsedMilliseconds} ms");
        Assert.True(report.WorstLateMs < 250, $"the worst beat was {report.WorstLateMs} ms late");
    }
}
