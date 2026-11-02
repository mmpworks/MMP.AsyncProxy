# MMP.AsyncProxy

`async`/`await` for .NET 3.5, built by hand.

C# 5 added `async` and `await` in 2012. The compiler rewrites an `async` method into a state machine class. The runtime supplies `Task`, `TaskAwaiter`, and `AsyncTaskMethodBuilder`. This library writes all of those parts in C# 3, so they compile with the Visual Studio 2008 compiler and run on .NET 3.5 and the CLR 2.0.

Three things come out of it:

1. **A readable copy of the mechanism.** Every type carries the name of the real one. `Promise<T>` is `TaskCompletionSource<T>`. `IFuture<T>` is `Task<T>`. `FutureAwaiter<T>` is `TaskAwaiter<T>`. `AsyncMethodBuilder<T>` is `AsyncTaskMethodBuilder<T>`. The sample project holds a hand-written state machine beside the `async` method it stands for.
2. **Usable async on an old runtime.** A C# 2.0 iterator stands in for the compiler. `yield return future` is `await future`. `AsyncProxy.Run` drives it with the same builder the hand-written machine uses.
3. **A Windows CE build.** The same source compiles against the .NET Compact Framework 3.5 reference assemblies and passes the same test suite. On a 64 MB board, a worker that is waiting costs about a kilobyte and no thread. The next section has the numbers.

## Why this exists: Windows CE and the Compact Framework

Fuel dispensers, point-of-sale terminals, handheld scanners, and factory panels still run Windows CE 6 with the .NET Compact Framework 3.5. Their teams have the Visual Studio 2008 compiler and cannot change it. The board is what it is: in the course that ships with this repo it is 64 MB of RAM, a thread pool capped at 25, and a 128 KB stack per pool thread. The cost that kills those programs is a parked thread. Every worker that sits waiting for a message, a serial byte, or a timer holds a stack the board paid for.

This library takes the thread out of the wait. A worker becomes a small object with a bookmark. While it waits it holds nothing but that object. When its message lands, a pool thread runs it to the next wait and leaves.

### The target

| Constraint on Kevin's board | Value | Where it comes from |
|---|---|---|
| OS and runtime | Windows CE 6, .NET Compact Framework 3.5, CLR 2.0 | the course, `docs/course/00-dinner.md` |
| Compiler | Visual Studio 2008, C# 3 | same; the library is written in C# 3 for that reason |
| RAM | 64 MB | same |
| Thread pool | 25 threads, 128 KB stack each; `SetMaxThreads` can raise it | Microsoft, "Threading in the .NET Compact Framework" |
| Default thread stack | 64 KB, 8 KB of it reserved for overflow control | Windows Embedded CE 6.0 stack docs |
| Pool worst case | 25 × 128 KB = 3.2 MB of stack before a line of application code | arithmetic on the two rows above |

### What the Compact Framework does and does not have

Checked against the CF 3.5 reference assemblies themselves (`NETCFSetupv35.msi`, SHA1 `48eba5c9ae1856cda0c2b0833dfdc28c36dbbc04`), because the documentation that once listed this is gone. `tools/netcf-audit.ps1` reruns the check; `docs/netcf-port.md` has the full table.

| Present on CF 3.5, and the library leans on it | Missing on CF 3.5, and what the library does instead |
|---|---|
| `ThreadPool.QueueUserWorkItem`, `SetMaxThreads` | `ExecutionContext`: nothing flows across a park; a value that must survive rides in the state machine's fields |
| `System.Threading.Timer` | `SynchronizationContext`: a display thread registers an `IPostTarget` (one method, `Post(Action)`) through `PostTarget.SetForCurrentThread` |
| `ManualResetEvent`, `AutoResetEvent`, `WaitHandle.WaitOne(int, bool)` | `Exception.Data`: the first stack trace is lost on rethrow (known limit 1) |
| `Monitor.Enter`/`Exit` (every `lock`) | `Monitor.Wait`/`Pulse`: never used in the library |
| `Interlocked.Increment`, `Decrement`, `Exchange`, `CompareExchange<T>` | `Interlocked.Add`, `Thread.VolatileRead`: compare-and-swap loops instead |
| `IAsyncResult`, `AsyncCallback`, `Stream.BeginRead` | `OperationCanceledException`: `FutureCanceledException` derives from `Exception` on CF |
| `TcpListener`, `Socket`, `SerialPort` | `ThreadStaticAttribute`: `PostTarget` keeps a copy-on-write array keyed by `ManagedThreadId` |

### The footprint

Measured 2026-11-02 with the allocation counter on the .NET Framework 4.8 CLR, 64-bit. A 32-bit CE board has half-size references, so these are upper bounds. The test that produces them is `tests/MMP.AsyncProxy.Tests/FootprintTests.cs`.

| Measure | Bytes |
|---|---|
| The library on disk, CF 3.5 build (`MMP.AsyncProxy.dll`) | 20,992 |
| Kevin's pump firmware sample on disk, CF 3.5 build | 10,240 |
| One parked worker: iterator machine, builder, promise, pending future, observe wrapper | 1,152 |
| The same worker after one wake-up | 1,360 |
| 1,000 parked workers | 1,168,200 |
| Threads held by those 1,000 parked workers | 0 |

Put against the board: a pump head with two nozzles, a printer, a card reader, and a loyalty link is five or six workers. Under threads that is five or six parked stacks at 64 KB each, plus a context switch every time one wakes. Under this library it is about 7 KB of objects, and the pool thread that runs their wake-ups was already there for the timers.

### Threads, side by side

Four small programs in `training/`, each written with threads and then with this library, same contract, same tests. Measured 2026-11-02 on .NET Framework 4.8, Release, 24 cores. The thread column is the one a 64 MB board cares about.

| Program | Work | Threaded: peak threads | AsyncProxy: peak threads | Threaded: ms | AsyncProxy: ms |
|---|---|---|---|---|---|
| mailbox | 1,000 workers, 10,000 wake-ups | 1,018 | 34 | 288 | 96 |
| fan-out | 1,000 requests to a slow service at once | 782 | 34 | 307 | 117 |
| pipeline | 10,000 items through two hand-offs | 37 | 34 | 31 | 13 |
| deadline | 100 calls, each abandons one attempt | 134 | 34 | 9,387 | 9,352 |

34 is the idle thread count of the test process. Every AsyncProxy row sits on it. The threaded mailbox row would be 1,018 stacks; on the CE board that is 1,018 × 64 KB, which is the whole 64 MB. The deadline row is the quiet one: an abandoned attempt under threads is a thread that never comes back, and 100 of them is 100 stacks leaked. Under this library it is 0.

Allocation per message after the 0.2.0 fast paths: a mailbox wake-up that finds its message already queued allocates nothing; one that has to park allocates one promise and one future. The pipeline program moved 10,000 items for 3.1 MB of garbage (was 18.3 MB before 0.2.0) and ran faster than the threaded version on both runtimes. Full tables with allocation and working-set columns are in each `training/*/README.md`.

### The CF 3.5 build

```
pwsh tools/netcf-build.ps1
   src\MMP.AsyncProxy.NetCF\bin\Release\net35\MMP.AsyncProxy.dll  20,992 bytes
   samples\MMP.AsyncProxy.Forecourt.NetCF\bin\Release\net35\MMP.AsyncProxy.Forecourt.dll  10,240 bytes
Passed!  - Failed: 0, Passed: 71, Skipped: 4, Total: 75   (the CF binaries, run on the net48 CLR)
```

`src/MMP.AsyncProxy.NetCF` compiles the same source against the CF 3.5 reference assemblies with `NETCF` defined. `samples/MMP.AsyncProxy.Forecourt.NetCF` does the same for Kevin's pump code. The script builds both and runs the whole test suite against them on the desktop CLR, which can load them because CF assembly references are retargetable. The four skipped tests are the ones that need `ExecutionContext`, `SynchronizationContext`, or `Exception.Data`; each is marked `[DesktopFact("<what it needs>")]`. One test reads the loaded assembly's `mscorlib` public key token (`969db8053d3322ac` is CF) and checks it against `BuildInfo.Target`, so a mislabeled build fails. The reference assemblies are Microsoft binaries and stay outside the repo; `docs/netcf-port.md` says where to get them and how to unpack them without installing anything.

### What is still unverified

Nothing here has run on a Windows CE device or emulator. The CF build proves the CF-compiled IL is sound and the suite passes on it. It says nothing about how the CF thread pool schedules, how coarse `System.Threading.Timer` is on a given board, or what the CF runtime's own footprint is. Those are device measurements, and the first team to make them should add the numbers to `docs/netcf-port.md`.

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
| `Future<T>` | `Task<T>` (the object) | The sealed read-only partner a promise hands out. No cast reaches the setters |
| `IAwaiter`, `FutureAwaiter<T>` | `INotifyCompletion`, `TaskAwaiter<T>` | `IsCompleted`, `OnCompleted`, `GetResult` |
| `IAsyncStateMachine` | `IAsyncStateMachine` | `MoveNext` runs the method to its next await |
| `AsyncMethodBuilder<T>` | `AsyncTaskMethodBuilder<T>` | `Start`, `AwaitOnCompleted`, `SetResult`, `SetException` |
| `ContinueOnAnyThread()` | `ConfigureAwait(false)` | Skip the `SynchronizationContext` post-back |
| `Futures.Delay`, `Run`, `WhenAll`, `FromResult` | `Task.Delay`, `Run`, `WhenAll`, `FromResult` | Factories and combinators |
| `Futures.FromAsync` | `Task.Factory.FromAsync` | Wraps a Begin/End pair so OS I/O completes the future |
| `Futures.WhenAny`, `Observe` | `Task.WhenAny`, no direct match | First to finish; a wrapper that never throws so a body can inspect a step. `Observe` of a settled future is the shared `Completed` |
| `IFuture.Wait(int)` | `Task.Wait(int)` | Park with a bound; true when the answer came in time |
| `Futures.True`, `Futures.False` | `Task.FromResult(true)`, cached | Shared completed yes-or-no answers, so a fast path allocates nothing |
| `CancelSource`, `CancelToken` | `CancellationTokenSource`, `CancellationToken` | Cooperative cancel. `Delay` and `Run` take a token |
| `new Promise<T>(PromiseOptions.RunContinuationsAsynchronously)` | `TaskCreationOptions.RunContinuationsAsynchronously` | Continuations go to the pool instead of the completer's stack |
| `AsyncProxy.Run` | the C# 5 compiler | Drives an iterator as an async method |

Context flows the way the real one does. The builder captures `ExecutionContext` at each suspend and restores it before `MoveNext`. The awaiter captures `SynchronizationContext` and posts the continuation back to it.

## Where no thread is used

`Futures.Delay` is an entry on one shared timer (`DelayWheel`): every delay in the process rides one `System.Threading.Timer`, and each completion runs as its own pool work item. `await` on it holds no thread. The timer fires, the pool runs `MoveNext`, and the method continues. `Futures.FromAsync` wraps `BeginRead`/`EndRead`, so a file or socket read is done by the OS and completes through an I/O completion port. `Futures.Run` is the one place a thread is used, because CPU work needs one.

Run `samples/MMP.AsyncProxy.Comparison` to see it. 2000 requests that each wait 200 ms: a thread per request peaked at 1357 threads, the state machines did the same work at 33 threads, which is the idle count.

## Learn how it works

`docs/course/` is an eleven-chapter walk through the machine, written as two developers going over it over dinner: Steve, and Kevin, who keeps the firmware for a fuel dispenser on Windows CE and .NET Compact Framework 3.5 and cannot change compilers. Each chapter opens at the table. Kevin's pump code, before and after, is in `samples/MMP.AsyncProxy.Forecourt` with tests. Mermaid diagrams inline, each with a plain-words walkthrough. The last chapter covers the jobs where plain threads beat async. Start at `docs/course/README.md`.

`docs/sdk.md` is the short guide to using the library.

## Move a threaded program onto it

`training/` is four small programs, each written with threads and then with this library, in C# 3 for .NET 3.5, with a modern `async`/`await` copy beside each for the IL comparison. One contract and one test suite per program prove the two versions behave the same. One bench prints the thread, memory, and time table on .NET Framework 4.8 and on .NET 10. Start at `training/README.md`. The plan is `docs/prd-training.md`.

## Build and test

```
dotnet build MMP.AsyncProxy.slnx
dotnet test MMP.AsyncProxy.slnx
```

The library and samples compile for `net35` with `LangVersion` 3. The tests run on `net48` and load the `net35` binaries. Three tests pin that: the assembly under test has CLR header `v2.0.50727` and no `TargetFrameworkAttribute`.

Last run, 2026-11-02: 75 tests, 73 passed and 2 CF-only facts skipped on the desktop build; 71 passed and 4 desktop-only facts skipped on the CF 3.5 build (`pwsh tools/netcf-build.ps1`). The training track adds 49 on net48 and 73 on net10.0 under `training/`.

`dotnet pack src/MMP.AsyncProxy -c Release` builds the NuGet package into `artifacts/`.

## The compiler's machine beside ours

`docs/compiler-vs-handwritten.md` puts the real compiler's output for the same method next to our hand-written sample, with a row-by-row mapping. The shapes match field for field. `tools/decompile.ps1` regenerates it.

## Known limits

1. **Rethrow wipes the stack.** .NET 3.5 has no `ExceptionDispatchInfo`. `GetResult` throws the original exception object. Before it does, it stores the first stack trace in `exception.Data["MMP.AsyncProxy.OriginalStackTrace"]`. The Compact Framework build has no `Exception.Data`, so there the first trace is lost.
2. **An iterator body cannot `catch` a step's fault.** When a yielded future faults, the whole operation faults, which is how `await` propagates. To handle it in the body, yield `Futures.Observe(step)` and then check `step.IsFaulted`. The hand-written form can `catch`, because the `try` is yours.
3. **Continuations run inline on the completing thread by default.** Same as `TaskCompletionSource`. Pass `true` to the `Promise` constructor to send them to the pool.
4. **Cancellation is cooperative.** `CancelToken` stops a `Delay`, skips a `Run` that has not started, and lets your code stop itself with `ThrowIfCancelRequested`. Nothing stops a running thread from outside.

## Plan

`docs/prd.md` holds the decisions, the slices, and the acceptance list.

## Licence

MIT. See `LICENSE`.
