# SDK guide

Every code block in this guide is a method in `samples/MMP.AsyncProxy.Sdk/`, one file per section, built as net35 with the C# 3 compiler settings. `tests/MMP.AsyncProxy.Tests/SdkTests.cs` runs each one. `CourseFenceTests` checks that the blocks here are those files, so what you read is what compiles.

## Install

Build the package yourself and point at the `.nupkg`:

```
dotnet pack src/MMP.AsyncProxy -c Release
```

Once the package is on nuget.org (it is not yet; publishing is a separate, gated step) this becomes:

```
dotnet add package MMP.AsyncProxy
```

The package lands in `artifacts/` and carries three targets: `net35`, `net48`, and `netstandard2.0`. The last one lets a modern .NET app reference the same source, which is how MMP.GasPumpSimulator runs its third dispatch strategy on it. Visual Studio 2008 projects reference the `net35` dll directly from the extracted package.

## The five types you use

| Type | Use it when |
|------|-------------|
| `Promise<T>` / `Promise` | You are the one who knows when the work is done. Keep the promise, hand out `.Future`. The future is a separate object; a receiver cannot cast it back. |
| `IFuture<T>` / `IFuture` | You are waiting for someone else's work. Await it, or `Wait()` at the top of a program. |
| `AsyncProxy.Run` | You want to write an async method as an iterator. `yield return future` is `await`. |
| `Futures.*` | You need a delay, a pool run, a WhenAll, or a pre-completed future. |
| `AsyncMethodBuilder<T>` + `IAsyncStateMachine` | You are writing a state machine by hand, or teaching someone what the compiler does. |

## Wrap a callback API

File: `samples/MMP.AsyncProxy.Sdk/WrapACallbackApi.cs`.

Most 3.5-era I/O APIs are `Begin`/`End` pairs. `Futures.FromAsync` turns one into a future. The read goes to the OS, completion comes back through an I/O completion port, and no thread of yours waits:

```csharp
public static IFuture<int> ReadAsync(Stream stream, byte[] buffer)
{
    return Futures.FromAsync<int>(
        delegate(AsyncCallback cb, object state) { return stream.BeginRead(buffer, 0, buffer.Length, cb, state); },
        stream.EndRead);
}
```

Open the `FileStream` with `FileOptions.Asynchronous` or the OS path is bypassed and a pool thread does the read.

Events need a promise by hand. Subscribe, complete the promise in the handler, unsubscribe:

```csharp
public static IFuture<DownloadDataCompletedEventArgs> DownloadAsync(WebClient client, Uri uri)
{
    Promise<DownloadDataCompletedEventArgs> promise = new Promise<DownloadDataCompletedEventArgs>();
    DownloadDataCompletedEventHandler handler = null;
    handler = delegate(object s, DownloadDataCompletedEventArgs e)
    {
        client.DownloadDataCompleted -= handler;
        if (e.Error != null) promise.TrySetException(e.Error);
        else promise.TrySetResult(e);
    };
    client.DownloadDataCompleted += handler;
    client.DownloadDataAsync(uri);
    return promise.Future;
}
```

## Write an async method

File: `samples/MMP.AsyncProxy.Sdk/WriteAnAsyncMethod.cs`.

```csharp
public static IFuture<string> FetchAndTrimAsync(Stream stream)
{
    return AsyncProxy.Run<string>(delegate(Return<string> ret) { return Body(stream, ret); });
}

private static IEnumerable<IFuture> Body(Stream stream, Return<string> ret)
{
    byte[] buffer = new byte[4096];
    IFuture<int> read = WrapACallbackApi.ReadAsync(stream, buffer);
    yield return read;                                   // await
    string text = Encoding.UTF8.GetString(buffer, 0, read.Result);
    yield return Futures.Delay(100);                     // await
    ret.Value = text.Trim();                             // return
}
```

Rules:

1. Yield the future, then read its `.Result`. It is complete by then, so it does not block.
2. Set `ret.Value` before the body ends. Whatever is there becomes the result.
3. A faulted step faults the whole method. The caller sees the exception on their await.
4. `yield` cannot sit inside a `try` that has a `catch`. `try`/`finally` is fine. A `finally` that throws faults the method; if the method was already faulting, the first fault wins and the second rides on it under `AsyncProxy.DisposeFaultKey` in `Exception.Data`.

## Consume one

File: `samples/MMP.AsyncProxy.Sdk/ConsumeOne.cs`.

Inside another async method, yield it. At the top of a program, wait on it:

```csharp
IFuture<string> future = WriteAnAsyncMethod.FetchAndTrimAsync(stream);
future.Wait();
Console.WriteLine(future.Result);
```

With a bound, the way `Task.Wait(int)` has one. True when the answer came in time:

```csharp
if (!future.Wait(2000)) Console.Error.WriteLine("still waiting after two seconds");
```

Never poll `IsCompleted` in a `Thread.Sleep(1)` loop instead. On Windows a one millisecond sleep is a 15 ms timer tick, and the training track's first clerk took fifteen seconds to stop a thousand workers that way.

Or hang a callback on it and move on:

```csharp
future.GetAwaiter().OnCompleted(delegate { Console.WriteLine(future.Result); });
```

## UI threads

File: `samples/MMP.AsyncProxy.Sdk/UiThreads.cs`.

On a WinForms or WPF thread, `GetAwaiter()` brings the continuation back to that thread. Inside a library, use `ContinueOnAnyThread()` so you do not bounce to the UI for work the UI never sees:

```csharp
IAwaiter<int> awaiter = future.ContinueOnAnyThread();
```

Never call `.Result` or `.Wait()` on a UI thread while a continuation is waiting to post back to it. That is the classic deadlock and it works the same here as in .NET 4.5.

Any thread that owns something can ask for its continuations back, not only a UI thread: a printer driver that insists on one thread, a display loop. On the desktop, make that thread's `SynchronizationContext` post to a queue the thread drains, and start the async method on that thread. `training/MMP.AsyncProxy.Training/Support/OwnerThread.cs` is a small working one, and course chapter 11 shows it in use.

The Compact Framework has no `SynchronizationContext`. There, implement `IPostTarget` (one method, `Post(Action)`) and register it once on the thread with `PostTarget.SetForCurrentThread`. The awaiter checks `SynchronizationContext.Current` first on the desktop builds and the registry second, so the same code works on both. `UiThreads.OwnerLoop` in the SDK sample is one such thread: a queue, a wake-up event, and a loop that registers itself as the post target.

```csharp
public void Post(Action action)
{
    lock (_queue) _queue.Enqueue(action);
    _wake.Set();
}
```

## Fan out, fan in

File: `samples/MMP.AsyncProxy.Sdk/FanOutFanIn.cs`.

```csharp
IFuture<int>[] all = new IFuture<int>[urls.Length];
for (int i = 0; i < urls.Length; i++) all[i] = FetchAsync(urls[i], 10);
yield return Futures.WhenAll(all);     // one await for the lot
```

If any failed, `WhenAll` faults with an `AggregateFutureException` that holds every failure, in order.

## First one wins

Same file.

```csharp
IFuture<IFuture> first = Futures.WhenAny(primary, mirror);
yield return first;
if (first.Result == primary) ret.Value = "primary";
```

The losers keep running. Cancel them with a token if you care.

## Handle a failed step inside an iterator

File: `samples/MMP.AsyncProxy.Sdk/HandleAFailedStep.cs`.

A faulted step faults the whole method, so the body never gets a `catch`. Wrap the step in `Observe`, which always succeeds, then look at the step yourself:

```csharp
yield return Futures.Observe(risky);
if (risky.IsFaulted) { Console.Error.WriteLine(risky.Exception.Message); ret.Value = fallback; yield break; }
ret.Value = risky.Result;
```

## Cancel

File: `samples/MMP.AsyncProxy.Sdk/CancelAPoll.cs`.

Keep a `CancelSource`. Hand out its `Token`. `Delay` and `Run` take one. Your own loops check it:

```csharp
CancelSource source = _source;
IFuture work = AsyncProxy.Run(Poll(source.Token, periodMs));
```

```csharp
private IEnumerable<IFuture> Poll(CancelToken token, int periodMs)
{
    while (true)
    {
        token.ThrowIfCancelRequested();        // ends the method Canceled, not Faulted
        yield return Futures.Delay(periodMs, token);
        DoOnePoll();
    }
}
```

Later, from any thread, `source.Cancel()`. A method that ends by throwing `FutureCanceledException` completes its future as Canceled. Callers that await it get the same exception. `Register` on a token runs a callback at cancel time; dispose the handle to take it back.

## The fast path costs nothing

File: `samples/MMP.AsyncProxy.Sdk/FastPath.cs`.

An iterator step that is already complete never parks and never allocates an awaiter. `Futures.Observe` of a settled future returns the shared `Futures.Completed`. A yes-or-no step answers with `Futures.True` or `Futures.False`, which are shared. So a queue or tray written for this library should offer a synchronous `TryTake` or `TryPut` beside its `TakeAsync` or `PutAsync`, and a loop should try first and yield only when the try fails:

```csharp
T item;
if (!tray.TryTake(out item))
{
    IFuture<T> next = tray.TakeAsync();
    yield return Futures.Observe(next);
    if (next.IsCanceled) yield break;
    item = next.Result;
}
handle(item);
```

The training track's pipeline went from 1.8 KB per item to about 300 bytes with the 0.2.0 fast paths, this one among them.

## Continuations off your stack

File: `samples/MMP.AsyncProxy.Sdk/ContinuationsOffYourStack.cs`.

By default `SetResult` runs every waiting continuation on the calling thread before it returns. When the completer holds a lock, sits on a deep stack, or has a deadline, build the promise with the option and continuations go to the thread pool instead:

```csharp
Promise<int> promise = new Promise<int>(PromiseOptions.RunContinuationsAsynchronously);
```

A continuation registered after the promise completed runs at once on the registering thread, option or not.

## Faults and stacks

File: `samples/MMP.AsyncProxy.Sdk/FaultsAndStacks.cs`.

.NET 3.5 has no `ExceptionDispatchInfo`, so a rethrow resets the stack trace. Before it rethrows, the library copies the first stack into the exception:

```csharp
catch (Exception ex)
{
    string where = ex.Data[Promise<int>.OriginalStackTraceKey] as string;
    Console.Error.WriteLine(ex.Message + Environment.NewLine + where);
    return where;
}
```

The Compact Framework has no `Exception.Data`, so on that build the first stack is not kept. README known limit 1 says so.

## Where the rest is

`docs/prd.md` holds the plan and decisions. The Compact Framework 3.5 build is `src/MMP.AsyncProxy.NetCF`, built and tested by `tools/netcf-build.ps1` and described in `docs/netcf-port.md`. On that build `ex.Data` is unavailable, so the `where` line above is desktop only.
