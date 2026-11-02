# What a Compact Framework 3.5 port needs

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
| `System.Threading.ThreadPool` | `QueueUserWorkItem` | present | `Promise<T>` with `runContinuationsAsync`, `Futures.Run` |
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

## What this does not say

The reference assemblies say what compiles. They do not say how the CF thread pool schedules, how coarse `Timer` is on a given board, or what the runtime's own footprint is. Those are device measurements and they are items 2 and 4 in `docs/ce-budget.md` of MMP.GasPumpSimulator.
