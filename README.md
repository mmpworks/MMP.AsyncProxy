# MMP.AsyncProxy

`async`/`await` for .NET 3.5, built by hand.

C# 5 added `async` and `await` in 2012. The compiler rewrites an `async` method into a state machine class. The runtime supplies `Task`, `TaskAwaiter`, and `AsyncTaskMethodBuilder`. This library writes all of those parts in C# 3, so they compile with the Visual Studio 2008 compiler and run on .NET 3.5 and the CLR 2.0.

Three things come out of it:

1. **A readable copy of the mechanism.** Every type carries the name of the real one. `Promise<T>` is `TaskCompletionSource<T>`. `IFuture<T>` is `Task<T>`. `FutureAwaiter<T>` is `TaskAwaiter<T>`. `AsyncMethodBuilder<T>` is `AsyncTaskMethodBuilder<T>`. The sample project holds a hand-written state machine beside the `async` method it stands for.
2. **Usable async on an old runtime.** A C# 2.0 iterator stands in for the compiler. `yield return future` is `await future`. `AsyncProxy.Run` drives it with the same builder the hand-written machine uses.
3. **A Windows CE build.** The same source compiles against the .NET Compact Framework 3.5 reference assemblies and passes the same test suite, with the seven desktop-only facts skipped. Measured on the desktop CLR, a worker that is waiting costs about a kilobyte and no thread; nothing has run on a board yet. The next section has the numbers.

## Why this exists: Windows CE and the Compact Framework

Fuel dispensers, point-of-sale terminals, handheld scanners, and factory panels still run Windows CE 6 with the .NET Compact Framework 3.5. Their teams have the Visual Studio 2008 compiler and cannot change it. The board is what it is: in the course that ships with this repo it is 64 MB of RAM, a thread pool capped at 25, and a 128 KB stack per pool thread. The cost that kills those programs is a parked thread. Every worker that sits waiting for a message, a serial byte, or a timer holds a stack the board paid for.

This library takes the thread out of the wait. A worker becomes a small object with a bookmark. While it waits it holds nothing but that object. When its message lands, a pool thread runs it to the next wait and leaves.

### The target

| Constraint on Kevin's board | Value | Where it comes from |
|---|---|---|
| OS and runtime | Windows CE 6, .NET Compact Framework 3.5, CLR 2.0 | the course, `docs/course/00-dinner.md` |
| Compiler | Visual Studio 2008, C# 3 | same; the library is written in C# 3 for that reason |
| RAM | 64 MB | same |
| Thread pool | 25 threads, 128 KB stack each; `SetMaxThreads` can raise it | Microsoft, "Threading in the .NET Compact Framework" (MSDN article; quoted from memory of the page, no copy in this repo) |
| Default thread stack | 64 KB, 8 KB of it reserved for overflow control | Windows Embedded CE 6.0 stack documentation (same caveat) |
| Pool worst case | 25 × 128 KB = 3.2 MB of stack before a line of application code | arithmetic on the two rows above |

### What the Compact Framework does and does not have

Checked against the CF 3.5 reference assemblies themselves (`NETCFSetupv35.msi`, SHA1 `48eba5c9ae1856cda0c2b0833dfdc28c36dbbc04`), because the documentation that once listed this is gone. `tools/netcf-audit.ps1` reruns the check; `docs/netcf-port.md` has the full table.

| Present on CF 3.5, and the library leans on it | Missing on CF 3.5, and what the library does instead |
|---|---|
| `ThreadPool.QueueUserWorkItem`, `SetMaxThreads` | `ExecutionContext`: nothing flows across a park; a value that must survive rides in the state machine's fields |
| `System.Threading.Timer` | `SynchronizationContext`: a display thread registers an `IPostTarget` (one method, `Post(Action)`) through `PostTarget.SetForCurrentThread` |
| `ManualResetEvent`, `AutoResetEvent`, `WaitHandle.WaitOne(int, bool)` | `Exception.Data`: the first stack trace is lost on rethrow (known limit 1) |
| `Monitor.Enter`/`Exit` (every `lock`) | `Monitor.Wait`/`Pulse`: never used in the library |
| `Interlocked.Increment`, `Decrement`, `Exchange`, `CompareExchange<T>` | `Interlocked.Add`, `Thread.VolatileRead`: the forecourt sample's `Pulser` uses compare-and-swap loops instead (the library never needed them) |
| `IAsyncResult`, `AsyncCallback`, `Stream.BeginRead` | `OperationCanceledException`: `FutureCanceledException` derives from `Exception` on CF |
| `TcpListener`, `Socket`, `SerialPort` | `ThreadStaticAttribute`: `PostTarget` keeps a copy-on-write array keyed by `ManagedThreadId` |

### The footprint

Measured 2026-11-02 with the allocation counter on the .NET Framework 4.8 CLR, 64-bit. A 32-bit CE board has half-size references, so these are upper bounds. The test that produces them is `tests/MMP.AsyncProxy.Tests/FootprintTests.cs`; it prints the figures and asserts the bounds: under 2 KB for one parked worker, under 4 KB after a wake-up, under 2 MB for a thousand, and no thread added by the thousand.

| Measure | Bytes |
|---|---|
| The library on disk, CF 3.5 build (`MMP.AsyncProxy.dll`), 0.4.0 | 21,504 |
| Kevin's pump firmware sample on disk, CF 3.5 build | 10,752 |
| One parked worker: iterator machine, builder, promise, pending future, observe wrapper | 1,152 |
| The same worker after one wake-up | 1,360 |
| 1,000 parked workers | 1,168,200 |
| Threads held by those 1,000 parked workers | 0 |

Put against the board: a pump head with two nozzles, a printer, a card reader, and a loyalty link is five or six workers. Under threads that is five or six parked stacks at 64 KB each, plus a context switch every time one wakes. Under this library it is about 7 KB of objects, and the pool thread that runs their wake-ups was already there for the timers.

### Threads, side by side

Four small programs in `training/`, each written with threads and then with this library, same contract, same tests. One run of `dotnet run --project training/MMP.AsyncProxy.Training.Bench -c Release -f net48` on 2026-11-03, .NET Framework 4.8, Release, 24 cores; all four rows from that one run. The thread column is the one a 64 MB board cares about.

| Program | Work | Threaded: peak threads | AsyncProxy: peak threads | Threaded: ms | AsyncProxy: ms |
|---|---|---|---|---|---|
| mailbox | 1,000 workers, 10,000 wake-ups | 1,019 | 33 | 343 | 88 |
| fan-out | 1,000 requests to a slow service at once | 982 | 34 | 235 | 130 |
| pipeline | 10,000 items through two hand-offs | 34 | 34 | 37 | 15 |
| deadline | 100 calls, each abandons one attempt | 133 | 34 | 9,440 | 9,439 |

33 to 34 is the idle thread count of the bench process. Every AsyncProxy row sits on it. The threaded mailbox row is 1,019 threads; on the CE board that is 1,019 stack reservations at 64 KB each, about 64 MB of address space before any of it is touched. The deadline row is the quiet one: an abandoned attempt under threads is a thread that never comes back, and 100 of them is 100 stacks leaked. Under this library it is 0.

Allocation per message after the 0.2.0 fast paths: a mailbox wake-up that finds its message already queued takes `TryTake` and the `Observe` fast path, so it allocates no promise, no future, and no awaiter; one that has to park allocates the promise, its future, the `Observe` wrapper, and the callback objects, about a kilobyte (`FootprintTests` measures 1,152 bytes for a parked worker). The pipeline program moved 10,000 items for 3.3 MB of garbage (was 18.3 MB before 0.2.0) and ran faster than the threaded version on both runtimes. Full tables with allocation and working-set columns are in each `training/*/README.md`.

### The CF 3.5 build

```
pwsh tools/netcf-build.ps1                                       (2026-11-03, version 0.4.0)
   src\MMP.AsyncProxy.NetCF\bin\Release\net35\MMP.AsyncProxy.dll  21,504 bytes
   samples\MMP.AsyncProxy.Forecourt.NetCF\bin\Release\net35\MMP.AsyncProxy.Forecourt.dll  10,752 bytes
Passed!  - Failed: 0, Passed: 112, Skipped: 7, Total: 119   (the CF binaries, run on the net48 CLR)
```

`src/MMP.AsyncProxy.NetCF` compiles the same source against the CF 3.5 reference assemblies with `NETCF` defined. `samples/MMP.AsyncProxy.Forecourt.NetCF` does the same for Kevin's pump code. The script builds both and runs the whole test suite against them on the desktop CLR, which can load them because CF assembly references are retargetable. The seven skipped tests are the ones that need `ExecutionContext`, `SynchronizationContext`, or `Exception.Data`; each is marked `[DesktopFact("<what it needs>")]`. One test reads the loaded assembly's `mscorlib` public key token (`969db8053d3322ac` is CF) and checks it against `BuildInfo.Target`, so a mislabeled build fails. The reference assemblies are Microsoft binaries and stay outside the repo; `docs/netcf-port.md` says where to get them and how to unpack them without installing anything.

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

On the desktop builds, context flows the way the real one does. The builder captures `ExecutionContext` at each suspend and restores it before `MoveNext`. The awaiter captures `SynchronizationContext` and posts the continuation back to it. The shared timer flows no context of its own, so one caller's values never ride into another caller's continuation. The Compact Framework build has neither type; see the table above for what it does instead.

## Where no thread is used

`Futures.Delay` is an entry on one shared timer (`DelayWheel`): every delay in the process rides one `System.Threading.Timer`, and each completion runs as its own pool work item. `await` on it holds no thread. The timer fires, the pool runs `MoveNext`, and the method continues. `Futures.FromAsync` wraps `BeginRead`/`EndRead`, so a file or socket read is done by the OS; on desktop Windows with `FileOptions.Asynchronous` it completes through an I/O completion port, and on CE that path is unmeasured. `Futures.Run` is the one place a thread is used, because CPU work needs one.

Run `samples/MMP.AsyncProxy.Comparison` to see it. 2,000 requests that each wait 200 ms, run 2026-11-03 on .NET Framework 4.8 with 24 cores: a thread per request peaked at 1,392 threads and took 533 ms; the state machines did the same work at 33 threads, which is the idle count, in 226 ms. `SampleProgramTests` runs the console at 8 requests and checks that all three approaches compute the same sum.

## Learn how it works

`docs/course/` is an eleven-chapter walk through the machine, with an opening story and an epilogue, written as two developers going over it over dinner: Steve, and Kevin, who keeps the firmware for a fuel dispenser on Windows CE and .NET Compact Framework 3.5 and cannot change compilers. Each chapter opens at the table. Kevin's pump code, before and after, is in `samples/MMP.AsyncProxy.Forecourt` with tests. Mermaid diagrams inline, each with a plain-words walkthrough. The last technical chapter covers the jobs where plain threads beat async. Start at `docs/course/README.md`.

## Use it

`docs/sdk.md` is the short guide to using the library. Every code block in it is a method in `samples/MMP.AsyncProxy.Sdk/`, one file per section, compiled as C# 3 for net35, and `tests/MMP.AsyncProxy.Tests/SdkTests.cs` runs each one:

| Section of the guide | File | Shows |
|---|---|---|
| Wrap a callback API | `WrapACallbackApi.cs` | `Begin`/`End` through `Futures.FromAsync`; an event through a `Promise` |
| Write an async method | `WriteAnAsyncMethod.cs` | the iterator form of an async method |
| Consume one | `ConsumeOne.cs` | `Wait()`, `Wait(int)`, a callback |
| UI threads | `UiThreads.cs` | `ContinueOnAnyThread()`; an owner thread that registers an `IPostTarget` |
| Fan out, fan in; first one wins | `FanOutFanIn.cs` | `WhenAll`, `WhenAny` |
| Handle a failed step | `HandleAFailedStep.cs` | `Observe` and a fallback |
| Cancel | `CancelAPoll.cs` | a polling loop that ends Canceled |
| The fast path | `FastPath.cs` | a tray with `TryTake` beside `TakeAsync`, and the loop that tries first |
| Continuations off your stack | `ContinuationsOffYourStack.cs` | `PromiseOptions.RunContinuationsAsynchronously` |
| Faults and stacks | `FaultsAndStacks.cs` | reading the first stack trace out of `Exception.Data` |

The written word is under test too. `CourseFenceTests` reads every C# block in the course, the SDK guide, and the training READMEs and checks that its lines are in this repo's source, or that the block is marked as a sketch (modern C# shown for comparison, decompiler output, an exercise that is broken on purpose). A reader who copies a block gets code that exists and is run by a test.

## Move a threaded program onto it

`training/` is six small programs. Four are written with threads and then with this library, in C# 3 for .NET 3.5, with a modern `async`/`await` copy beside each for the IL comparison; two more (crunch, printer) are the jobs where the plain thread wins. One contract and one test suite per program prove the two versions behave the same. One bench prints the thread, memory, and time table on .NET Framework 4.8 and on .NET 10. Start at `training/README.md`. The plan is `docs/prd-training.md`.

## Build and test

```
dotnet build MMP.AsyncProxy.slnx
dotnet test MMP.AsyncProxy.slnx -m:1
```

`-m:1` runs the test projects one at a time. Several tests time the thread pool, a 30 ms delay, or two threads against one, and three test hosts on one box make those numbers lie.

The library compiles for `net35`, `net48`, and `netstandard2.0` with `LangVersion` 3 on all three; the samples compile for `net35`. The tests run on `net48` and load the `net35` binaries. Two tests pin that: the library and the samples assembly under test have CLR header `v2.0.50727` and no `TargetFrameworkAttribute`; a third pins the test project itself to `net48`.

Last run, 2026-11-03, `dotnet test MMP.AsyncProxy.slnx -c Release -m:1`:

| Project | Runtime | Result |
|---|---|---|
| `tests/MMP.AsyncProxy.Tests` | net48, loads the net35 dll | 117 passed, 2 CF-only facts skipped, of 119 |
| `tests/MMP.AsyncProxy.Fuzz` | net48, loads the net35 dll | 49 passed (6 generators × 8 seeds × 40 rounds) |
| `training/MMP.AsyncProxy.Training.Tests` | net48 | 70 passed |
| `training/MMP.AsyncProxy.Training.Tests` | net10.0 | 94 passed |

The CF 3.5 build (`pwsh tools/netcf-build.ps1`) runs the main suite against the Compact Framework binaries; its output is in the section above.

`dotnet pack src/MMP.AsyncProxy -c Release` builds the NuGet package into `artifacts/`.

### Fuzz

`tests/MMP.AsyncProxy.Fuzz` runs random programs against the net35 binary and checks the contracts the sections above state: a future settles once and every continuation runs once; an iterator's future settles with the status its steps predict, even when a `finally` throws; `WhenAll` lists failures in input order and `WhenAny` names a completed input; a cancel callback never runs twice and a `Delay(token)` never faults; a storm of delays on the shared timer all fire; continuations under a registered `IPostTarget` all land on the owner thread. Six generators.

```
dotnet test tests/MMP.AsyncProxy.Fuzz -c Release        # 8 seeds x 40 rounds per generator, about 20 s
dotnet run --project tests/MMP.AsyncProxy.Fuzz -c Release -- 60 [runSeed]
dotnet run --project tests/MMP.AsyncProxy.Fuzz -c Release -- replay <generator> <seed>
```

A failure prints the generator and the round seed, and the replay line reruns that one round. Last long run, 2026-11-03, run seed 20261103: 6,000 rounds, 0 failures. The suite's first catch was `WhenAll` listing failures in completion order while the guide promised input order; fixed in 0.4.0 and pinned by `WhenAllOrderTests`.

## The compiler's machine beside ours

`docs/compiler-vs-handwritten.md` puts the real compiler's output for the same method next to our hand-written sample, with a row-by-row mapping. The shapes match; that document lists where they differ, starting with the struct the compiler emits in Release where ours is a class. `tools/decompile.ps1` regenerates it.

## Known limits

1. **Rethrow wipes the stack.** .NET 3.5 has no `ExceptionDispatchInfo`. `GetResult` throws the original exception object. Before it does, it stores the first stack trace in `exception.Data["MMP.AsyncProxy.OriginalStackTrace"]`. The Compact Framework build has no `Exception.Data`, so there the first trace is lost.
2. **An iterator body cannot `catch` a step's fault.** When a yielded future faults, the whole operation faults, which is how `await` propagates. To handle it in the body, yield `Futures.Observe(step)` and then check `step.IsFaulted`. The hand-written form can `catch`, because the `try` is yours.
3. **Continuations run inline on the completing thread by default.** Same as `TaskCompletionSource`. Build the promise with `PromiseOptions.RunContinuationsAsynchronously` to send them to the pool.
4. **Cancellation is cooperative.** `CancelToken` stops a `Delay`, skips a `Run` that has not started, and lets your code stop itself with `ThrowIfCancelRequested`. Nothing stops a running thread from outside.
5. **A throwing `finally` does not replace the fault.** In an iterator body, a `finally` that throws on the happy path faults the method, as the compiler would. When a step already faulted or canceled the method, the step's outcome stands and the cleanup fault rides on it under `AsyncProxy.DisposeFaultKey` in `Exception.Data`. The compiler lets the `finally`'s exception replace the first. Before 0.4.0 the throw escaped and the future stayed Pending.

## Plan

`docs/prd.md` holds the decisions, the slices, and the acceptance list.

## Licence

MIT. See `LICENSE`.
