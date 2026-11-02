# PRD: the training track

Status: written 2026-11-02. Slice 0 (this file, course chapter 10, the project skeleton) built the same day. Decisions below stand until Steve changes one.

## What

A training track inside this repo that teaches a developer how to move a threaded .NET application onto MMP.AsyncProxy. It has three parts:

1. **Course chapter 10, "Waiting without a thread".** The article written for MMP.GasPumpSimulator, moved here and made about the mailbox worker in general, with the gas pump as the worked example. It sits after chapter 9 in `docs/course/`.
2. **Four mini-projects** under `training/`. Each one is a small, real program written twice in C# 3 for .NET 3.5: once with threads, once with AsyncProxy. A third copy, in modern C# with `async`/`await` on .NET 10, exists so the IL of the hand-built machine can be set beside the IL the modern compiler emits. Each project has a test suite that runs the threaded and the AsyncProxy versions through one contract, a README that explains the flow at a tenth grade reading level, the thread model against the async model, the IL side by side, and a memory and speed table.
3. **A bench** that produces the memory and speed numbers for all four, on .NET Framework 4.8 (the CLR family .NET 3.5 code runs on) and on .NET 10.

The four projects, in the order a reader meets them:

| # | Folder | The job | Threads version | AsyncProxy version |
|---|---|---|---|---|
| 1 | `training/01-mailbox` | A worker loop: wait for a slip in the in-tray, handle it, wait again. The gas pump's shape. | A thread per worker parked in `Monitor.Wait` on a `Queue<T>`. | A promise-backed mailbox and an iterator loop. No thread while waiting. |
| 2 | `training/02-fan-out` | Send N requests at once and wait for all of them. | A thread per request and a countdown on a `ManualResetEvent`. | `Futures.WhenAll` over N futures. |
| 3 | `training/03-pipeline` | Three stages in a row with a bounded hand-off between each. | A thread per stage, bounded queues, `Monitor` for full and empty. | An iterator per stage over promise-backed queues. |
| 4 | `training/04-deadline` | A request with a time limit, retried a few times, cancelled when the caller gives up. | `WaitOne(timeout)` on an event, a stop flag the worker polls, a thread per attempt. | `Futures.WhenAny(work, Futures.Delay(limit))` and a `CancelToken`. |

## Why

1. The article proved the claim for one program. A reader who wants to move their own program needs the move shown four times, on four shapes, with the tests that prove each move kept the behaviour.
2. This repo is open source. Its reason to exist is that .NET 2.0-era runtimes (3.5, Compact Framework) can have async without a compiler upgrade. The training track is where that claim gets its evidence: the same job, the same tests, the same IL shape, on both sides.
3. Setting the hand-built machine beside the .NET 10 machine is also an audit. Where the modern compiler or runtime does something safer or cheaper, the library should pick it up, and then the gas pump simulator should get it.

## Acceptance

Kill condition: every row below is true on one date, and that date is written here.

| # | Check | Count | Date |
|---|---|---|---|
| 1 | `docs/course/10-waiting-without-a-thread.md` exists and the course index lists it | 1 chapter | 2026-11-02 |
| 2 | Each of the four projects has a threaded version and an AsyncProxy version in `MMP.AsyncProxy.Training` (net35, C# 3) and a modern version in `MMP.AsyncProxy.Training.Modern` (net10.0) | 4 of 4 | 2026-11-02 |
| 3 | `MMP.AsyncProxy.Training.Tests` runs every behaviour test against both 3.5 versions through one contract, and against the modern version on net10 | 49 of 49 on net48, 73 of 73 on net10.0 | 2026-11-02 |
| 4 | `docs/compiler-output/training/` holds, per project, the decompiled iterator machine (CSharp1) and the decompiled modern machine (CSharp4), and the IL of each `MoveNext` | 16 of 16 files | 2026-11-02 |
| 5 | Each project README has the sections listed under "README shape" below, with the bench numbers filled in from a run on this machine | 4 of 4 | 2026-11-02 |
| 6 | `MMP.AsyncProxy.Training.Bench` prints the table for all four on net48 and on net10.0 | all four, 2 runs | 2026-11-02 |
| 7 | Every library improvement found during the IL comparison is listed in the "Improvements found" table below as adopted or rejected with a reason, and each adopted one has a test | ___ rows | ___ |
| 8 | Each adopted improvement that touches the dispatch pattern is applied in MMP.GasPumpSimulator's `AsyncProxyDispatch` with its tests green | ___ of ___ | ___ |
| 9 | Tic-gate clean on every markdown file in the track | all | ___ |

## Non-goals

1. No BenchmarkDotNet. It cannot target net35 and the point is a table a reader can reproduce with `dotnet run`. The bench uses `Stopwatch`, a thread sampler, and the GC counters each runtime offers, the way `samples/MMP.AsyncProxy.Comparison` already does.
2. No new library features for their own sake. A change to `src/` lands only as a row in "Improvements found" with the IL or runtime evidence that motivated it.
3. No GUI samples. All four are console-shaped libraries with tests.
4. No Compact Framework build. Still slice 4 of the main PRD.
5. The modern versions are references for the IL comparison and the bench. They get the same behaviour tests, and nothing more: no modern-only features.

## Decisions

| # | Question | Pick | Why |
|---|---|---|---|
| 1 | Where the track lives | `training/` at the repo root, beside `samples/` | `samples/` holds the small single-method demos. The track is bigger and has its own README index. A reader finds it from the root README. |
| 2 | One assembly or four for the 3.5 code | One: `MMP.AsyncProxy.Training`, folders `Mailbox`, `FanOut`, `Pipeline`, `Deadline`, each with `Contract`, `Threaded`, `Async` namespaces | Four assemblies would be sixteen projects with the modern copies and tests. One assembly keeps the solution readable and `ilspycmd` still decompiles one type at a time. |
| 3 | Target frameworks of the training assembly | `net35;netstandard2.0`, `LangVersion` 3 | Same as the library. net35 is the point. netstandard2.0 lets the .NET 10 bench and tests load the same source, so the three versions can be measured in one process on one runtime. |
| 4 | The threaded versions use .NET 3.5 primitives only | `Thread`, `Monitor`, `Queue<T>`, `ManualResetEvent`, `Interlocked` | `BlockingCollection` and `CancellationToken` arrived in .NET 4. The threaded version must be the code a 2008 team would have written, or the comparison is unfair. |
| 5 | The modern assembly | `MMP.AsyncProxy.Training.Modern`, net10.0, `LangVersion` latest, `Task`, `Channel<T>`, `CancellationToken` | The IL comparison needs the real compiler's machine for the same job. The bench needs the runtime's own numbers beside ours. |
| 6 | One contract per project | An interface in `Contract`, for example `IMailboxWorker<T>`; every version implements it; the tests are theories over the versions | This is what makes "the behaviour is the same" a test and not a sentence. It is also the shape the gas pump uses (`IDispatchStrategy`). |
| 7 | Tests | `MMP.AsyncProxy.Training.Tests`, xunit, multi-target `net48;net10.0`. On net48 it references the net35 binaries by path, like the main tests. On net10.0 it references the netstandard2.0 build and the modern assembly. | Proves the 3.5 binaries, and proves the same contract holds on the modern runtime. |
| 8 | Bench | `MMP.AsyncProxy.Training.Bench`, console, multi-target `net48;net10.0`. Columns: elapsed ms, peak threads, allocated bytes, peak working set. Modern rows only on net10.0. | Memory and speed were asked for. Peak threads is the number that teaches. Allocated bytes uses `AppDomain.MonitoringTotalAllocatedMemorySize` on net48 and `GC.GetTotalAllocatedBytes` on net10. |
| 9 | Decompile | `tools/decompile.ps1` grows a second half: Release build of Training (net35) and Modern (net10.0), `ilspycmd -lv CSharp1` for the iterator machines, `-lv CSharp4` for the modern ones, `-il` for both, into `docs/compiler-output/training/` | Same tool and flags the article used, so the output matches what the reader saw there. |
| 10 | README voice | Tenth grade reading level, the two-developers register of the course, STE sentence mechanics, no tics. Every claim about memory or speed quotes the bench table it came from. | House writing standard. Demonstration over explanation. |
| 11 | What "humanized code" means here | Names say what the thing is in the domain (in-tray, slip, clerk), one idea per method, comments say why and name the modern equivalent. Same voice as `src/`. | Matches the library. A reader moving between them should feel no seam. |
| 12 | Improvements flow | Found during slices 1 to 4, written into the table below at once, implemented in slice 5 as their own PR, then applied to the gas pump as a PR there | Keeps each mini-project PR about the mini-project. The audit trail is the table. |

## README shape (each project)

1. **The job.** Three sentences. What the program does and why someone wrote it.
2. **The thread way.** The flow, step by step, with a Mermaid sequence or state diagram. What the thread holds while it waits.
3. **The AsyncProxy way.** The same flow, and what changed at each step. A diff-style table of the lines that moved.
4. **Thread model against async model.** Which problems left, which stayed, which rules the design keeps by shape.
5. **The same machine in IL.** The iterator `MoveNext` (ours, .NET 3.5) beside the compiler's `MoveNext` (.NET 10), decompiled, with the matching parts named. A link to the full files in `docs/compiler-output/training/`.
6. **Memory and speed.** The bench rows for this project, both runtimes, with the command that produced them.
7. **CUPID, DRY, SOLID.** Where each version stands, and what the move changed.
8. **Run it.** The test command and the bench command.

## Program design

```
training/
  README.md                                   index: the four projects, how to run, how to read
  01-mailbox/README.md  02-fan-out/README.md  03-pipeline/README.md  04-deadline/README.md
  MMP.AsyncProxy.Training/                    net35;netstandard2.0, C# 3
    Mailbox/   Contract/IMailboxWorker.cs IInTray.cs   Threaded/ThreadedInTray.cs ThreadedClerk.cs   Async/PromiseInTray.cs IteratorClerk.cs
    FanOut/    Contract/IFanOut.cs                     Threaded/ThreadPerRequest.cs                  Async/WhenAllFanOut.cs
    Pipeline/  Contract/IPipeline.cs IStage.cs         Threaded/ThreadedStage.cs                     Async/IteratorStage.cs
    Deadline/  Contract/IDeadlineCaller.cs             Threaded/ThreadedDeadline.cs                  Async/WhenAnyDeadline.cs
    Support/   ThreadSampler.cs (shared with the bench)
  MMP.AsyncProxy.Training.Modern/             net10.0, async/await: ChannelClerk, TaskFanOut, ChannelPipeline, TaskDeadline
  MMP.AsyncProxy.Training.Tests/              net48;net10.0, xunit, theories over the versions
  MMP.AsyncProxy.Training.Bench/              net48;net10.0, console, one table
docs/course/10-waiting-without-a-thread.md
docs/compiler-output/training/<project>.{iterator,modern}.{cs,il}
tools/decompile.ps1                           second half
```

Build order. Each slice is one PR, merged when green.

0. This PRD, chapter 10, the training index, the four projects as empty shells that build, the solution entries. Done 2026-11-02.
1. Mailbox: contract, threaded, async, modern, tests, bench row, decompile, README. Done 2026-11-02. Found improvements 1 to 5 below.
2. Fan-out, same list. Done 2026-11-02. Found improvement 6 below.
3. Pipeline, same list. Done 2026-11-02. Row 4 reached its rule of three; found row 7.
4. Deadline, same list. Done 2026-11-02. No new library row; the bench taught that a limit near the 15.6 ms timer tick is a guess, which is a README note and a pump rule.
5. Improvements: the adopted rows below land in `src/` with tests, then in the gas pump simulator.

## Improvements found

Filled in as slices 1 to 4 run. Each row names the evidence, the decision, and the reason.

| # | Seen in | What .NET 10 does | Decision | Reason | Landed |
|---|---|---|---|---|---|
| 1 | Mailbox, `IteratorClerk.Dispose` (2026-11-02). The first draft polled `IsCompleted` with `Sleep(1)`; 1000 clerks took 15 s to stop. | `Task.Wait(int timeout)` exists, so a caller never polls. | Adopt: add `IFuture.Wait(int millisecondsTimeout)` returning `bool`. | A missing overload makes every caller write the event-and-callback dance by hand, and the first one wrote it wrong. | slice 5 |
| 2 | Mailbox bench: about 1 KB allocated per slip against 180 bytes for the modern version. `Futures.Observe` builds a `Promise`, a `Future`, and a delegate even when the inner future is already complete. | `ValueTask` returns a completed result with no allocation on the synchronous path. | Adopt: `Observe` returns the shared `Futures.Completed` when the inner future is already complete. | Pure fast path, same observable behaviour, and the mailbox loop hits it on every slip that was already queued. | slice 5 |
| 3 | Same bench. `IteratorStateMachine.MoveNext` calls `step.GetAwaiter()` before checking completion, which boxes the `FutureAwaiter` struct to `IAwaiter` on every step, including completed ones. | The compiler's machine keeps the awaiter as a struct field; no boxing. | Adopt: check `step.IsCompleted` first and skip the awaiter on a completed, non-faulted step. | One interface box per step saved on the fast path; the slow path is unchanged. | slice 5 |
| 4 | Mailbox `TakeAsync`, then fan-out, then the pipeline tray's `PutAsync` returning a completed `IFuture<bool>` and `TakeAsync` returning a completed `IFuture<T>`: two promise-and-future pairs per item on the fast path, about 1.8 KB per item against 12 bytes for the modern line (2026-11-02). | `ValueTask<T>` wraps the value directly; `TryWrite` and `TryRead` succeed with no allocation. | Adopt, in two parts. (a) Shared completed futures for the values that repeat: `Futures.True`, `Futures.False` beside `Futures.Completed`. (b) See row 7 for the item case. | The third project hit the same path, which is the rule of three. A cached `IFuture<bool>` is one static per value and no new shape. | slice 5 |
| 7 | Same pipeline bench. The iterator yields `TakeAsync()` even when an item is already there, so the fast path pays for a promise, a future, an `Observe` wrapper, and a boxed awaiter to hand back a value it could have returned. | `Channel` exposes `TryRead` and `TryWrite`; `ReadAllAsync` tries synchronously first and only awaits when it must. | Adopt: a synchronous `TryTake(out T)` and `TryPut(T)` on the trays, and the stage loops try them before yielding. The gas pump's `AsyncProxyDispatch.Mailbox` gets the same `TryDequeue` before `DequeueAsync`. | The park is the rare case; the common case should cost nothing. It is the same shape as `IteratorStateMachine`'s own `IsCompleted` check, moved one level up. | slice 5 |
| 5 | `AsyncMethodBuilder<T>.AwaitOnCompleted` captures `ExecutionContext` on every park and wraps the continuation in two delegates. | `AwaitUnsafeOnCompleted` skips the flow when the runtime knows the context is the default. | Watch: measure the share of the per-wake cost first. .NET 3.5 has no "is default" check on `ExecutionContext`, so a skip would be an opt-in flag, which is decision 2 of chapter 9's booleans-as-strategy caveat. | Behaviour change for anyone relying on logical call context across a park; needs its own test and a measured win. | |
| 6 | Fan-out (2026-11-02). 200 `Futures.Delay` timers firing on one tick made the .NET 10 pool inject 57 threads in a cold process (22 warm); the modern courier's 200 `Task.Delay` stayed under 20. At 1000 letters in the warm bench both sat at the idle count. Each `Delay` is its own `System.Threading.Timer` and its callback calls `Timer.Dispose`, which takes the timer queue's lock; 200 of those at once look like starvation to the pool's heuristic. | `Task.Delay` rides one timer queue; a fired entry is unlinked without a per-timer dispose on the callback path. | Watch, then adopt in slice 5 if the measurement holds: one shared timer wheel for `Futures.Delay`, so N delays due at the same tick are one callback that completes N promises. | The injection is transient and the claim "no thread per letter" still holds, but a CE pool of 25 has no room for a burst of 57. The shared wheel is also fewer kernel timers on the board. | |

## Boundary

The agent may: write code, tests, docs, commit, push, open and merge its own green PRs here and in MMP.GasPumpSimulator (Steve, 2026-11-02).
Needs Steve: NuGet publish, any change to the library's public surface that removes or renames a member, any claim about the library in outward marketing text.
On a failing gate: stop and report. Never `--no-verify`.
Two sources disagree (an IL reading against a measured number): the measured number wins and the disagreement goes in the README.

## Anchor

The anchor for "the behaviour is the same" is the contract test suite, written in slice 1 before the AsyncProxy versions exist and run first against the threaded versions. The anchor for the IL claim is the decompiled output on disk, produced by a tool that shares no code with this repo. The anchor for the numbers is the bench output pasted into the README with its command.
