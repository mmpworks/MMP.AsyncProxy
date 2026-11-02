# What a Compact Framework 3.5 port needs

Status: BUILT 2026-11-02. `src/MMP.AsyncProxy.NetCF` compiles the library against the CF 3.5 assemblies and `tools/netcf-build.ps1` runs the test suite against that binary. The "Result" section at the end has the numbers. The audit below is what the build was designed from.

Checked 2026-11-02 against the .NET Compact Framework 3.5 reference assemblies, not against documentation. The current Microsoft Learn pages do not record Compact Framework support per class, and the old MSDN pages that did are gone, so the assemblies themselves are the source.

## Where the assemblies came from

`NETCFSetupv35.msi`, the .NET Compact Framework 3.5 Redistributable, Microsoft Download Center id 65. Microsoft deleted the download. Legacy Update archives the Wayback Machine copy taken before October 2019:

- https://legacyupdate.net/download-center/download/65/.net-compact-framework-3.5-redistributable
- 32.89 MB, SHA1 `48eba5c9ae1856cda0c2b0833dfdc28c36dbbc04`, checked after download.

Unpacked with `msiexec /a NETCFSetupv35.msi /qn TARGETDIR=<dir>`, which extracts the files and installs nothing. The reference assemblies are under `<dir>\v3.5\Debugger\BCL`: `mscorlib.dll`, `System.dll`, `System.Core.dll`, and the rest. They are Microsoft binaries and stay out of this repo. On the build machine they live at `E:\dev\tools\netcf35-ref` with a README that repeats this provenance.

## The audit

`tools/netcf-audit.ps1` lists the types in those three assemblies with ilspycmd and decompiles the ones with a member in question. It prints one row per type the library, the forecourt sample, or a port would lean on.

```
pwsh tools/netcf-audit.ps1 -RefDir E:\dev\tools\netcf35-ref
```

Output on 2026-11-02:

| Type | Member | CF 3.5 | Used by |
|---|---|---|---|
| `System.Threading.ExecutionContext` | | MISSING | `AsyncMethodBuilder<T>.AwaitOnCompleted` |
| `System.Threading.SynchronizationContext` | | MISSING | `FutureAwaiter<T>.OnCompleted` |
| `System.Threading.ThreadPool` | `QueueUserWorkItem` | present | `Promise<T>` with `PromiseOptions.RunContinuationsAsynchronously`, `Futures.Run` |
| `System.Threading.ThreadPool` | `SetMaxThreads` | present | the CE budget |
| `System.Threading.Timer` | ctor, `Dispose`, `Change` | present | `Futures.Delay` |
| `System.Threading.ManualResetEvent` | | present | `Promise<T>.Wait` |
| `System.Threading.AutoResetEvent` | | present | `KevinsPump.Authorize` |
| `System.Threading.WaitHandle` | `WaitOne(int, bool)` | present | `KevinsPump.Authorize` |
| `System.Threading.Monitor` | `Enter`, `TryEnter`, `Exit` | present | every `lock` |
| `System.Threading.Monitor` | `Wait`, `Pulse`, `PulseAll` | MISSING | the training track's `ThreadedInTray` only, which is desktop code on purpose |
| `System.Threading.Interlocked` | `Increment`, `Decrement`, `Exchange`, `CompareExchange`, `CompareExchange<T>` | present | counters, `WhenAny`, cancel |
| `System.Threading.Interlocked` | `Add` | MISSING | `Pulser.Pulse`, first draft |
| `System.Threading.Thread` | `VolatileRead` | MISSING | `Pulser.Pulses`, first draft |
| `System.Threading.Thread` | `Thread(ThreadStart, int maxStackSize)`, `Name`, `IsBackground`, `Join(int)`, `Sleep` | present | `KevinsPump` |
| `System.Exception` | `Data` | MISSING | `Promise<T>.PreserveStackTrace` |
| `System.OperationCanceledException` | | MISSING | `FutureCanceledException` base, `AsyncMethodBuilder<T>.SetException`, `Futures.Run` (found by the compiler, added to the audit the same day) |
| `System.ThreadStaticAttribute` | | MISSING | a per-thread post target; `PostTarget` keeps a copy-on-write array keyed by `ManagedThreadId` instead |
| `System.Reflection.AssemblyFileVersionAttribute` | | MISSING | the SDK's generated AssemblyInfo; turned off with `GenerateAssemblyFileVersionAttribute` |
| `System.Delegate` | `Combine`, `Remove` | present | `SerialLink.DataReceived` |
| `System.Collections.Generic.List<T>`, `Queue<T>` | | present | continuations, the training tray |
| `System.Action`, `System.Func<...>` | | present, in `System.Core` | everywhere |
| `System.IAsyncResult`, `System.AsyncCallback`, `Stream.BeginRead` | | present | `Futures.FromAsync` |
| `System.Net.Sockets.TcpListener`, `Socket` | | present | the island's accept loop |
| `System.IO.Ports.SerialPort` | `DataReceived`, `BaseStream` | present | Kevin's serial line |

The thread pool on CF 3.5 has `QueueUserWorkItem`, `SetMaxThreads`, and `GetMaxThreads`, and nothing else. `GetAvailableThreads` and `SetMinThreads` are not there.

## What the port changes

Five things, and four of them are small.

1. **`AsyncMethodBuilder<T>.AwaitOnCompleted`**: no `ExecutionContext` to capture. Under `#if NETCF` the method is one line, `awaiter.OnCompleted(machine.MoveNext)`. Nothing flows across a park, so a value that must survive one rides in the object, which chapter 5 already tells Kevin to do.
2. **`FutureAwaiter<T>.OnCompleted`**: no `SynchronizationContext` to capture. The flag `continueOnCapturedContext` becomes a no-op, and `ContinueOnAnyThread()` and `GetAwaiter()` behave the same. A display thread that needs continuations posted to it gets a small interface the library defines, `IPostTarget` or the like, set once per thread by the application; the awaiter captures that instead. This is the one design decision in the port and it goes in the PRD before the code.
3. **`Promise<T>.PreserveStackTrace`**: no `Exception.Data`. Under `#if NETCF` the first stack trace goes nowhere, and the README's known limit 1 says so for that target. An alternative is a wrapper exception, which chapter 9 rejected for the desktop because it changes `catch` behaviour; the same reason holds.
4. **`Pulser` in the forecourt sample**: `Interlocked.Add` becomes a compare-and-swap loop, and `Thread.VolatileRead` becomes `Interlocked.CompareExchange(ref x, 0, 0)`. Done 2026-11-02, so the sample is clean for both targets now.
5. **Build**: a `netcf35` target cannot come from the SDK, because there is no reference pack for it on NuGet. The route is a classic `.csproj` built by Visual Studio 2008, or an SDK project with `<TargetFramework>net35</TargetFramework>`, `NoStandardLib`, and explicit `<Reference>` items pointing at the CF assemblies by path, with `NETCF` defined. The second route builds on a modern machine and is the one to try first.

Everything else the library touches is there: the pool, the timer, the events, `Monitor.Enter` for `lock`, `Interlocked` for the counters and the first-wins race in `WhenAny`, the Begin/End pair for `FromAsync`, and the sockets and serial port Kevin's board talks through.

## Result, 2026-11-02

What the port did against the list above.

1. `AsyncMethodBuilder<T>.AwaitOnCompleted` under `#if NETCF` is `awaiter.OnCompleted(machine.MoveNext)`. Done.
2. `FutureAwaiter<T>.OnCompleted` reads `PostTarget.Current` when no `SynchronizationContext` applies. The interface is `IPostTarget` with one method, `Post(Action)`. A thread registers once with `PostTarget.SetForCurrentThread(target)` and `null` removes it. The registry is a copy-on-write array keyed by `Thread.ManagedThreadId`, because CF has no `ThreadStaticAttribute`. The desktop builds keep `SynchronizationContext.Current` first and check the registry second, so the same test proves the path on both. Done.
3. `Promise<T>.PreserveStackTrace` is empty under `#if NETCF`. README known limit 1 says so. Done.
4. The forecourt sample was already clean, and it now compiles against the CF assemblies too (`samples/MMP.AsyncProxy.Forecourt.NetCF`). Done.
5. Build: the second route works. An SDK project with `TargetFramework` net35, `NoStdLib`, `DisableImplicitFrameworkReferences`, `AutomaticallyUseReferenceAssemblyPackages` off, `FrameworkPathOverride` pointing at the CF folder, explicit `Reference` items for `mscorlib`, `System`, and `System.Core` by path, and `NETCF` defined. Two things the audit missed and the compiler found: `OperationCanceledException` is absent, so `FutureCanceledException` derives from `Exception` on CF and the two `is`/`catch` sites test the library's own type; and `AssemblyFileVersionAttribute` is absent, so that generated attribute is turned off. Done.

The build:

```
pwsh tools/netcf-build.ps1
   src\MMP.AsyncProxy.NetCF\bin\Release\net35\MMP.AsyncProxy.dll  20,992 bytes
   samples\MMP.AsyncProxy.Forecourt.NetCF\bin\Release\net35\MMP.AsyncProxy.Forecourt.dll  10,240 bytes
Passed!  - Failed: 0, Passed: 71, Skipped: 4, Total: 75   (against the CF binaries, on the net48 CLR)
Passed!  - Failed: 0, Passed: 73, Skipped: 2, Total: 75   (control: the desktop net35 binary)
```

The four skips on the CF run are the facts that need `ExecutionContext`, `SynchronizationContext` (two), and `Exception.Data`, each marked `[DesktopFact("<what it needs>")]`. The two skips on the control are the CF-only facts. `CompactFrameworkTests` is the anchor: it reads the loaded assembly's `mscorlib` reference and checks the public key token (`969db8053d3322ac` for CF, `b77a5c561934e089` for desktop) against `BuildInfo.Target`, so a mislabeled build fails there.

Why the desktop CLR runs a CF binary at all: CF assembly references carry the retargetable flag, and the desktop loader binds them to its own `mscorlib`. That proves the IL the CF compiler step produced is sound and the suite passes on it. It proves nothing about the CF runtime.

Footprint, from `FootprintTests` on the net48 CLR (64-bit, so an upper bound for a 32-bit board):

| Measure | Bytes |
|---|---|
| one parked iterator worker (machine, builder, promise, pending future, observe wrapper) | 1,152 |
| the same after one wake-up | 1,360 |
| 1,000 parked workers | 1,168,200, no thread held by any of them |

Against the 64 MB board in `docs/ce-budget.md` of MMP.GasPumpSimulator: the island's one worker is about a kilobyte, the library is 21 KB on disk, and a thousand workers would be about 1.2 MB. The pool's stacks, 25 at 128 KB, are the first real line item, and they are the runtime's, not the library's.

## What this does not say

The reference assemblies say what compiles. They do not say how the CF thread pool schedules, how coarse `Timer` is on a given board, or what the runtime's own footprint is. Those are device measurements and they are items 2 and 4 in `docs/ce-budget.md` of MMP.GasPumpSimulator. Nothing here has run on a Windows CE device or emulator.
