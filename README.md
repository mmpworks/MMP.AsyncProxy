# MMP.AsyncProxy

`async`/`await` for .NET 3.5, built by hand.

C# 5 added `async` and `await` in 2012. The compiler rewrites an `async` method into a state machine class. The runtime supplies `Task`, `TaskAwaiter`, and `AsyncTaskMethodBuilder`. This library writes all of those parts in C# 3, so they compile with the Visual Studio 2008 compiler and run on .NET 3.5 and the CLR 2.0.

Two things come out of it:

1. **A readable copy of the mechanism.** Every type carries the name of the real one. `Promise<T>` is `TaskCompletionSource<T>`. `IFuture<T>` is `Task<T>`. `FutureAwaiter<T>` is `TaskAwaiter<T>`. `AsyncMethodBuilder<T>` is `AsyncTaskMethodBuilder<T>`. The sample project holds a hand-written state machine beside the `async` method it stands for.
2. **Usable async on an old runtime.** A C# 2.0 iterator stands in for the compiler. `yield return future` is `await future`. `AsyncProxy.Run` drives it with the same builder the hand-written machine uses.

## The two ways to write one

The method a C# 5 programmer writes:

```csharp
async Task<int> AddAfterDelayAsync(int a, int b)
{
    await Task.Delay(10);
    int sum = a + b;
    await Task.Delay(10);
    return sum * 2;
}
```

**Iterator form.** The compiler builds the iterator's state machine. The library makes it async.

```csharp
public static IFuture<int> AddAfterDelayAsync(int a, int b)
{
    return AsyncProxy.Run<int>(delegate(Return<int> ret) { return Body(a, b, ret); });
}

private static IEnumerable<IFuture> Body(int a, int b, Return<int> ret)
{
    yield return Futures.Delay(10);
    int sum = a + b;
    yield return Futures.Delay(10);
    ret.Value = sum * 2;
}
```

**Hand-written form.** This is the shape the C# 5 compiler emits. See `samples/MMP.AsyncProxy.Samples/AddAfterDelay.cs` for the full version with comments.

```csharp
internal sealed class AddAfterDelayMachine : IAsyncStateMachine
{
    public int State;                          // -1 running, -2 done, 0.. parked at await n
    public AsyncMethodBuilder<int> Builder;
    public int A, B;                           // parameters, hoisted
    private int _sum;                          // local that lives across an await, hoisted
    private IAwaiter _awaiter;                 // the awaiter we are parked on

    public void MoveNext()
    {
        int result;
        try
        {
            IAwaiter awaiter;
            switch (State)
            {
                case 0: awaiter = _awaiter; _awaiter = null; State = -1; goto Resume0;
                case 1: awaiter = _awaiter; _awaiter = null; State = -1; goto Resume1;
            }
            awaiter = Futures.Delay(10).GetAwaiter();
            if (!awaiter.IsCompleted) { State = 0; _awaiter = awaiter; var self = this; Builder.AwaitOnCompleted(ref awaiter, ref self); return; }
        Resume0:
            awaiter.GetResult();
            _sum = A + B;
            awaiter = Futures.Delay(10).GetAwaiter();
            if (!awaiter.IsCompleted) { State = 1; _awaiter = awaiter; var self = this; Builder.AwaitOnCompleted(ref awaiter, ref self); return; }
        Resume1:
            awaiter.GetResult();
            result = _sum * 2;
        }
        catch (Exception ex) { State = -2; Builder.SetException(ex); return; }
        State = -2;
        Builder.SetResult(result);
    }

    public void SetStateMachine(IAsyncStateMachine stateMachine) { }
}
```

## What each part does

| This library | .NET 4.5 | Job |
|---|---|---|
| `IFuture`, `IFuture<T>` | `Task`, `Task<T>` | Read-only view of a result that arrives later |
| `Promise`, `Promise<T>` | `TaskCompletionSource<T>` | The only type that can complete a future |
| `IAwaiter`, `FutureAwaiter<T>` | `INotifyCompletion`, `TaskAwaiter<T>` | `IsCompleted`, `OnCompleted`, `GetResult` |
| `IAsyncStateMachine` | `IAsyncStateMachine` | `MoveNext` runs the method to its next await |
| `AsyncMethodBuilder<T>` | `AsyncTaskMethodBuilder<T>` | `Start`, `AwaitOnCompleted`, `SetResult`, `SetException` |
| `ContinueOnAnyThread()` | `ConfigureAwait(false)` | Skip the `SynchronizationContext` post-back |
| `Futures.Delay`, `Run`, `WhenAll`, `FromResult` | `Task.Delay`, `Run`, `WhenAll`, `FromResult` | Factories and combinators |
| `Futures.FromAsync` | `Task.Factory.FromAsync` | Wraps a Begin/End pair so OS I/O completes the future |
| `AsyncProxy.Run` | the C# 5 compiler | Drives an iterator as an async method |

Context flows the way the real one does. The builder captures `ExecutionContext` at each suspend and restores it before `MoveNext`. The awaiter captures `SynchronizationContext` and posts the continuation back to it.

## Where no thread is used

`Futures.Delay` is a `System.Threading.Timer`. `await` on it holds no thread. The timer fires, the pool runs `MoveNext`, and the method continues. `Futures.FromAsync` wraps `BeginRead`/`EndRead`, so a file or socket read is done by the OS and completes through an I/O completion port. `Futures.Run` is the one place a thread is used, because CPU work needs one.

Run `samples/MMP.AsyncProxy.Comparison` to see it. 2000 requests that each wait 200 ms: a thread per request peaked at 1357 threads, the state machines did the same work at 33 threads, which is the idle count.

## Learn how it works

`docs/course/` is an eight-chapter walk through the machine, written as two developers going over it after hours. Mermaid diagrams inline. Start at `docs/course/README.md`.

`docs/sdk.md` is the short guide to using the library.

## Build and test

```
dotnet build MMP.AsyncProxy.slnx
dotnet test MMP.AsyncProxy.slnx
```

The library and samples compile for `net35` with `LangVersion` 3. The tests run on `net48` and load the `net35` binaries. Three tests pin that: the assembly under test has CLR header `v2.0.50727` and no `TargetFrameworkAttribute`.

Last run, 2026-10-31: 31 tests, 31 passed.

`dotnet pack src/MMP.AsyncProxy -c Release` builds the NuGet package into `artifacts/`.

## Known limits

1. **Rethrow wipes the stack.** .NET 3.5 has no `ExceptionDispatchInfo`. `GetResult` throws the original exception object. Before it does, it stores the first stack trace in `exception.Data["MMP.AsyncProxy.OriginalStackTrace"]`.
2. **An iterator body cannot catch a step's fault.** When a yielded future faults, the whole operation faults. This matches how `await` propagates. The hand-written form can catch, because the `try` is yours.
3. **Continuations run inline on the completing thread.** Same as `TaskCompletionSource` by default. A long chain of synchronous completions can grow the stack.
4. **No cancellation token yet.** .NET 3.5 has none. A `CancelToken` is on the plan.

## Plan

`docs/prd.md` holds the decisions, the slices, and the acceptance list.

## Licence

MIT. See `LICENSE`.
