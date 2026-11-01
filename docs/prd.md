# MMP.AsyncProxy PRD

Status: slice 1 built 2026-10-31. Decisions below are open for review until Steve signs.

## What

A .NET 3.5 library that rebuilds the `async`/`await` machinery by hand. It ships the five parts the C# 5 compiler and the .NET 4.5 runtime supply, written in C# 3 so the Visual Studio 2008 compiler accepts them:

1. `IFuture` and `IFuture<T>`: the `Task` shape. Read-only view of a result that arrives later.
2. `Promise<T>`: the `TaskCompletionSource` shape. The only type that can complete a future.
3. `IAwaiter` and `FutureAwaiter<T>`: the `TaskAwaiter` shape. `IsCompleted`, `OnCompleted`, `GetResult`.
4. `AsyncMethodBuilder<T>` and `IAsyncStateMachine`: the builder the compiler calls. `Start`, `AwaitOnCompleted`, `SetResult`, `SetException`.
5. `AsyncProxy.Run`: a C# 2.0 iterator stands in for the compiler. `yield return future` is the `await`.

Two ways to write an async method come out of this:

- **Hand-written machine.** A class with `_state`, hoisted locals, a builder field, and a `MoveNext` with a `switch`. This is the shape the compiler emits. The sample project holds one beside the method it stands for.
- **Iterator machine.** A method that returns `IEnumerable<IFuture>` and yields each future. The library drives it with the same builder. This is the usable form.

## Why

1. Evidence for a claim. `await` is `ContinueWith` with the compiler writing the state machine. This repo is the demonstration. A reader can diff the hand-written machine against `ilspycmd` output for a real `async` method.
2. Old runtimes still exist. Windows CE and Compact Framework 3.5 devices run C# 3. Fuel dispensers and point-of-sale terminals are on the list. A team maintaining one gets structured async without a compiler upgrade.
3. Teaching. Every piece is small and named after the real one. Reading the source teaches the mechanism.

## Acceptance

Kill condition: the items below are all true on one date, and that date is written here.

1. `dotnet build` of the library succeeds for `net35` with `LangVersion` 3 and zero warnings.
2. The test project references the `net35` binary, never a recompile, and runs on `net48`.
3. Tests prove: completion before and after registration, result and fault paths, `ExecutionContext` flow across an await, `SynchronizationContext` post-back, `WhenAll` fault aggregation, `Wait` blocking, the hand-written machine, and the iterator machine. Count on 2026-10-31: 50 of 50. Sign-off date: ___.
4. `docs/compiler-vs-handwritten.md` shows the `ilspycmd` decompile of a real `async` method next to the hand-written sample, with the matching parts labelled. Done 2026-10-31, 13-row mapping table.
5. README states the three limitations in the Decisions table.

## Non-goals

1. No `ValueTask`, no `IAsyncEnumerable`, no async streams.
2. No PLINQ or `Parallel.For`.
3. No source generator or Fody weaver that writes the machine for you. The point is to see it.
4. No .NET Compact Framework build in slice 1 to 3. The code avoids `Monitor.Wait` and `Monitor.Pulse` so a NETCF port stays possible. A CE port is slice 4 and needs a device or emulator.
5. No `ExceptionDispatchInfo`. .NET 3.5 lacks it. See decision 6.

## Decisions

| # | Question | Pick | Why |
|---|----------|------|-----|
| 1 | Target frameworks | `net35;net48;netstandard2.0` for the library, `net48` for tests | `net35` is the point. `net48` runs the same CLR family so xunit can load the `net35` binary. `netstandard2.0` (added 2026-11-01) lets a .NET 10 consumer reference the library; same C# 3 source, no new APIs. |
| 2 | Language version | `LangVersion` 3 on library and samples | Roslyn enforces it. Nothing from C# 4 and later can leak in. |
| 3 | Machine type | Hand-written machines are classes | A struct machine needs `SetStateMachine` boxing tricks. C# 3 code is easier to read with a class. The interface keeps `SetStateMachine` so the shape matches. |
| 4 | Continuation thread | Continuations run inline on the completer's thread | Same as `TaskCompletionSource` default. Deep chains can stack-dive. Slice 2 adds a `RunContinuationsAsync` option. |
| 5 | Context flow | Builder captures `ExecutionContext` at `AwaitOnCompleted` and restores it before `MoveNext`. Awaiter captures `SynchronizationContext` and posts back. | Matches the Toub video 13:44 to 20:27. `ContinueOnAnyThread()` is the `ConfigureAwait(false)` stand-in. |
| 6 | Fault rethrow | `GetResult` throws the original exception. The original stack string is stored in `Exception.Data["MMP.AsyncProxy.OriginalStackTrace"]` first. | `throw ex` wipes the stack in 3.5. The data slot keeps the evidence. Wrapping would change `catch` behaviour versus real `await`. |
| 7 | Iterator result | `AsyncProxy.Run<T>(Func<Return<T>, IEnumerable<IFuture>>)`. The body sets `ret.Value`. | An iterator cannot `return` a value. A typed box is the smallest shape that says what it does. |
| 8 | Iterator fault handling | A faulted yielded future faults the whole operation. The body cannot `catch` it. | Same as real `await` propagation. A body that must handle a step's fault yields `Futures.Observe(f)`, then reads `f.IsFaulted`. Built in slice 2. |
| 9 | Cancellation | `CancelSource` and `CancelToken`, cooperative. A `FutureCanceledException` escaping a body ends the future Canceled, not Faulted. | .NET 3.5 lacks `CancellationToken`. The builder maps `OperationCanceledException` to Canceled the way the real one does. Built in slice 2. |
| 11 | Continuation thread option | `new Promise<T>(true)` queues continuations to the pool | The `RunContinuationsAsynchronously` stand-in. Default stays inline to match `TaskCompletionSource`. Built in slice 2. |
| 10 | Licence and repo | MIT, `mmpworks/MMP.AsyncProxy`, created private, Steve flips to public | Public creation is gated. Private creation is free. |

## Program design

```
src/MMP.AsyncProxy/
  Core/     IFuture.cs IFuture{T}.cs IAwaiter.cs FutureStatus.cs VoidResult.cs
            Promise{T}.cs Promise.cs FutureAwaiter{T}.cs
            FutureCanceledException.cs AggregateFutureException.cs
  Builder/  IAsyncStateMachine.cs AsyncMethodBuilder{T}.cs AsyncMethodBuilder.cs
  Iterate/  AsyncProxy.cs Return{T}.cs IteratorStateMachine{T}.cs
  Futures.cs      Completed FromResult FromException Delay Run WhenAll
samples/MMP.AsyncProxy.Samples/   AddAfterDelay.cs (hand-written machine, net35, C# 3)
tests/MMP.AsyncProxy.Tests/       xunit on net48, references the net35 dll
```

Build order:

1. Slice 1 (done 2026-10-31): skeleton, Core, Builder, Iterate, `Futures` basics, sample machine, tests.
   Same day: `Futures.FromAsync` with a real async `FileStream` test, the comparison console, the
   eight-chapter course in `docs/course/`, `docs/sdk.md`, NuGet pack metadata, comment pass in the
   two-developers voice.
2. Slice 2 (done 2026-10-31): `WhenAny`, `Observe`, `Promise(runContinuationsAsync)`, `CancelSource`/`CancelToken`,
   `Delay` and `Run` with a token, canceled iterators end Canceled, `docs/compiler-vs-handwritten.md` from
   `ilspycmd` with `tools/decompile.ps1`. Tests 50 of 50.
3. Slice 3: README for public release, NETCF notes, Steve's publish decision.

## Prior art

1. Jeffrey Richter, `AsyncEnumerator` (Power Threading library, 2008): iterator-driven async for .NET 2.0. Same shape as `AsyncProxy.Run`. Closed source at the time.
2. Stephen Toub, "Deep .NET: Writing async/await from scratch" (2024), the `Iterate` helper at 59:00. Same shape, written against .NET 8.
3. Where this differs: the builder and awaiter are first-class public types, so the hand-written machine and the iterator machine share one path. Richter's library hid the machinery. Toub's talk targeted a modern runtime.

## Boundary

The agent may: write code, tests, docs, commit locally, create the private repo, push to it.
Needs Steve: flip to public, NuGet publish, any claim about the library in outward text.
On a failing gate: stop and report. Never `--no-verify`.
