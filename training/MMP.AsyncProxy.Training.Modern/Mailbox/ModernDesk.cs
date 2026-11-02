using System.Threading.Channels;
using MMP.AsyncProxy.Training.Mailbox;

namespace MMP.AsyncProxy.Training.Modern.Mailbox;

/// <summary>
/// The office the way a .NET 10 developer writes it: a bounded Channel for the
/// tray and an async loop for the clerk. The compiler builds the state machine
/// that IteratorClerk builds by hand. Same contract, same tests.
/// </summary>
public sealed class ModernDesk : IDesk
{
    private readonly List<IDisposable> _seated = [];

    public string Version => "modern";

    public IInTray<T> OpenTray<T>(string name, int capacity) => new ChannelInTray<T>(name, capacity);

    public IClerk Seat<T>(string name, IInTray<T> tray, Action<T> handle)
    {
        var clerk = new ChannelClerk<T>(name, (ChannelInTray<T>)tray, handle);
        lock (_seated) _seated.Add(clerk);
        return clerk;
    }

    public void Dispose()
    {
        IDisposable[] all;
        lock (_seated) { all = [.. _seated]; _seated.Clear(); }
        foreach (var d in all) d.Dispose();
    }
}

/// <summary>A bounded channel. TryWrite refuses when full, the same rule as the other two trays.</summary>
public sealed class ChannelInTray<T>(string name, int capacity) : IInTray<T>
{
    public readonly Channel<T> Channel = System.Threading.Channels.Channel.CreateBounded<T>(new BoundedChannelOptions(capacity) { SingleReader = true });
    private int _pending;

    public string Name => name;
    public int Capacity => capacity;
    public int Pending => Volatile.Read(ref _pending);

    public bool TryPost(T slip)
    {
        if (!Channel.Writer.TryWrite(slip)) return false;
        Interlocked.Increment(ref _pending);
        return true;
    }

    public void Close() => Channel.Writer.TryComplete();

    internal void Handled() => Interlocked.Decrement(ref _pending);
}

/// <summary>The clerk as an async method. "await foreach" is the bookmark; the compiler writes the machine.</summary>
public sealed class ChannelClerk<T> : IClerk
{
    private readonly ChannelInTray<T> _tray;
    private readonly Task _loop;
    private int _handled;
    private int _busy;

    public ChannelClerk(string name, ChannelInTray<T> tray, Action<T> handle)
    {
        Name = name;
        _tray = tray;
        _loop = Loop(tray, handle);
    }

    public string Name { get; }
    public bool IsRunning => !_loop.IsCompleted;
    public int Handled => Volatile.Read(ref _handled);

    private async Task Loop(ChannelInTray<T> tray, Action<T> handle)
    {
        await foreach (var slip in tray.Channel.Reader.ReadAllAsync().ConfigureAwait(false))
        {
            Interlocked.Exchange(ref _busy, 1);
            try { handle(slip); }
            catch (Exception) { /* a slip that throws is still a slip handled; the clerk stays seated */ }
            finally
            {
                Interlocked.Increment(ref _handled);
                tray.Handled();
                Interlocked.Exchange(ref _busy, 0);
            }
        }
    }

    public bool WaitUntilIdle(int timeoutMs)
    {
        var deadline = DateTime.UtcNow.AddMilliseconds(timeoutMs);
        while (_tray.Pending > 0 || Volatile.Read(ref _busy) == 1)
        {
            if (DateTime.UtcNow >= deadline) return false;
            Thread.Sleep(1);
        }
        return true;
    }

    public void Dispose()
    {
        _tray.Close();
        _loop.Wait(TimeSpan.FromSeconds(2));
    }
}
