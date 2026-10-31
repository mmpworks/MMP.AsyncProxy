# SDK guide

## Install

From the package:

```
dotnet add package MMP.AsyncProxy
```

Or build it yourself and point at the `.nupkg`:

```
dotnet pack src/MMP.AsyncProxy -c Release
```

The package lands in `artifacts/` and carries two targets: `net35` and `net48`. Visual Studio 2008 projects reference the `net35` dll directly from the extracted package.

## The five types you use

| Type | Use it when |
|------|-------------|
| `Promise<T>` / `Promise` | You are the one who knows when the work is done. Keep the promise, hand out `.Future`. |
| `IFuture<T>` / `IFuture` | You are waiting for someone else's work. Await it, or `Wait()` at the top of a program. |
| `AsyncProxy.Run` | You want to write an async method as an iterator. `yield return future` is `await`. |
| `Futures.*` | You need a delay, a pool run, a WhenAll, or a pre-completed future. |
| `AsyncMethodBuilder<T>` + `IAsyncStateMachine` | You are writing a state machine by hand, or teaching someone what the compiler does. |

## Wrap a callback API

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

```csharp
public static IFuture<string> FetchAndTrimAsync(Stream stream)
{
    return AsyncProxy.Run<string>(delegate(Return<string> ret) { return Body(stream, ret); });
}

private static IEnumerable<IFuture> Body(Stream stream, Return<string> ret)
{
    byte[] buffer = new byte[4096];
    IFuture<int> read = ReadAsync(stream, buffer);
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
4. `yield` cannot sit inside a `try` that has a `catch`. `try`/`finally` is fine.

## Consume one

Inside another async method, yield it. At the top of a program, wait on it:

```csharp
IFuture<string> future = FetchAndTrimAsync(stream);
future.Wait();
Console.WriteLine(future.Result);
```

Or hang a callback on it and move on:

```csharp
future.GetAwaiter().OnCompleted(delegate { Console.WriteLine(future.Result); });
```

## UI threads

On a WinForms or WPF thread, `GetAwaiter()` brings the continuation back to that thread. Inside a library, use `ContinueOnAnyThread()` so you do not bounce to the UI for work the UI never sees:

```csharp
IAwaiter<int> awaiter = future.ContinueOnAnyThread();
```

Never call `.Result` or `.Wait()` on a UI thread while a continuation is waiting to post back to it. That is the classic deadlock and it works the same here as in .NET 4.5.

## Fan out, fan in

```csharp
IFuture[] all = new IFuture[urls.Length];
for (int i = 0; i < urls.Length; i++) all[i] = FetchAsync(urls[i]);
yield return Futures.WhenAll(all);     // one await for the lot
```

If any failed, `WhenAll` faults with an `AggregateFutureException` that holds every failure, in order.

## First one wins

```csharp
IFuture<IFuture> first = Futures.WhenAny(FetchAsync(primary), FetchAsync(mirror));
yield return first;
if (first.Result == primaryFuture) { /* primary answered first */ }
```

The losers keep running. Cancel them with a token if you care.

## Handle a failed step inside an iterator

A faulted step faults the whole method, so the body never gets a `catch`. Wrap the step in `Observe`, which always succeeds, then look at the step yourself:

```csharp
IFuture<int> risky = ReadAsync(stream, buffer);
yield return Futures.Observe(risky);
if (risky.IsFaulted) { log.Warn(risky.Exception.Message); ret.Value = fallback; yield break; }
ret.Value = risky.Result;
```

## Cancel

Keep a `CancelSource`. Hand out its `Token`. `Delay` and `Run` take one. Your own loops check it:

```csharp
CancelSource source = new CancelSource();
IFuture work = AsyncProxy.Run(Poll(source.Token));
// later, from any thread
source.Cancel();

static IEnumerable<IFuture> Poll(CancelToken token)
{
    while (true)
    {
        token.ThrowIfCancelRequested();        // ends the method Canceled, not Faulted
        yield return Futures.Delay(1000, token);
        DoOnePoll();
    }
}
```

A method that ends by throwing `FutureCanceledException` completes its future as Canceled. Callers that await it get the same exception. `Register` on a token runs a callback at cancel time; dispose the handle to take it back.

## Continuations off your stack

By default `SetResult` runs every waiting continuation on the calling thread before it returns. When the completer holds a lock, sits on a deep stack, or has a deadline, build the promise with `new Promise<T>(true)` and continuations go to the thread pool instead.

## Faults and stacks

.NET 3.5 has no `ExceptionDispatchInfo`, so a rethrow resets the stack trace. Before it rethrows, the library copies the first stack into the exception:

```csharp
catch (Exception ex)
{
    string where = ex.Data[Promise<int>.OriginalStackTraceKey] as string;
    log.Error(ex.Message + Environment.NewLine + where);
}
```

## What is on the plan

A Compact Framework build, and the public release. See `docs/prd.md`.
