using MMP.AsyncProxy.Training.Mailbox;
using MMP.AsyncProxy.Training.Mailbox.Async;
using MMP.AsyncProxy.Training.Mailbox.Threaded;

namespace MMP.AsyncProxy.Training.Bench;

/// <summary>
/// The mailbox job for the bench: N clerks, each at their own tray, each handed
/// ten slips in a round-robin so every clerk wakes ten times. The clerks sit
/// idle for a moment first, so the peak-threads column shows what an idle
/// clerk holds, and then the time column shows what a wake-up costs.
/// </summary>
internal static class MailboxRows
{
    private const int SlipsPerClerk = 10;

    public static IEnumerable<BenchRow> For(int clerks)
    {
        yield return new BenchRow("mailbox", "threaded", () => Run(new ThreadedDesk(), clerks));
        yield return new BenchRow("mailbox", "asyncproxy", () => Run(new AsyncProxyDesk(), clerks));
#if NET10_0_OR_GREATER
        yield return new BenchRow("mailbox", "modern", () => Run(new Modern.Mailbox.ModernDesk(), clerks));
#endif
    }

    private static bool Run(IDesk desk, int clerks)
    {
        using (desk)
        {
            var handled = 0;
            var trays = new IInTray<int>[clerks];
            var seated = new IClerk[clerks];
            for (var i = 0; i < clerks; i++)
            {
                trays[i] = desk.OpenTray<int>("tray" + i, SlipsPerClerk);
                seated[i] = desk.Seat("clerk" + i, trays[i], _ => Interlocked.Increment(ref handled));
            }
            Thread.Sleep(50);                      // idle: the sampler sees what each clerk holds while waiting

            for (var round = 0; round < SlipsPerClerk; round++)
                for (var i = 0; i < clerks; i++)
                    while (!trays[i].TryPost(round)) Thread.Yield();

            var ok = true;
            foreach (var c in seated) ok &= c.WaitUntilIdle(30_000);
            return ok && Volatile.Read(ref handled) == clerks * SlipsPerClerk;
        }
    }
}
