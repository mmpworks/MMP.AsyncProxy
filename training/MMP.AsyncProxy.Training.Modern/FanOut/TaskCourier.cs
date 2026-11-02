using MMP.AsyncProxy.Training.FanOut;

namespace MMP.AsyncProxy.Training.Modern.FanOut;

/// <summary>
/// The fan-out the way a .NET 10 developer writes it: a Task per letter from Task.Delay,
/// one await on Task.WhenAll, and the caller blocks once on the result. The compiler
/// builds the gatherer's machine; WhenAllCourier builds it from an iterator.
/// </summary>
public sealed class TaskCourier : ICourier
{
    public string Version => "modern";

    public Reply[] SendAll(string[] addresses, PostOffice office) => Gather(addresses, office).GetAwaiter().GetResult();

    private static async Task<Reply[]> Gather(string[] addresses, PostOffice office)
    {
        var letters = addresses.Select(a => Ask(a, office)).ToArray();
        try { await Task.WhenAll(letters).ConfigureAwait(false); }
        catch (Exception) { /* a bounced letter faults its own task; each is read below */ }

        var replies = new Reply[addresses.Length];
        for (var i = 0; i < addresses.Length; i++)
        {
            var letter = letters[i];
            replies[i] = letter.IsFaulted
                ? new Reply(addresses[i], null, letter.Exception!.InnerException ?? letter.Exception)
                : new Reply(addresses[i], letter.Result, null);
        }
        return replies;
    }

    /// <summary>The office's timer door, in Task form: the same delay and the same bounces.</summary>
    private static async Task<string> Ask(string address, PostOffice office)
    {
        await Task.Delay(office.DelayMs).ConfigureAwait(false);
        return office.Answer(address);
    }

    public void Dispose() { }
}
