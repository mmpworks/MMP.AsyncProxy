# Course senior correctness review

Date: November 3, 2026. Reviewer: Morgan (senior C# review role).

Disposition: approve the documentation correctness pass. The editor applied four qualification groups, and this reviewer checked the revised text against the cited implementation branches. Nine of nine chapters reviewed; 48 C# fences reviewed. No remaining HIGH or CRITICAL documentation findings.

## Scope and independence

Read nine chapters, 03 through 11, including 48 C# fences and their explanations. Reviewed the implementation in this checkout, relevant sample and training implementations, and relevant contract tests. Chapter 10 also used the current read-only simulator checkout. Its historical November 2 excerpts differ from that checkout; the chapter identifies that difference.

Read the course plan and MMP.Humanization/RUNBOOK.md acceptance checks. The review concentrated on truth and preserved qualifications. It did not rewrite voice or protected executable tokens. The junior findings were not read before this review. Reviewer independence: separate reader, same model vendor. Root supplied one factual notice that its sequential-loop closure comment had changed.

## Requested corrections

1. **[HIGH] Queue option applies to callbacks saved while pending.** Chapter 07, line 220, and chapter 10, line 418, describe the pool dispatch rule without the completed-registration exception. `Promise{T}.cs:151-165` registers under the lock, then calls a late continuation immediately. Only `Complete`, lines 212-225, applies the asynchronous option to saved callbacks. Add the exception beside both explanations. A captured context can still post the late callback. Chapter 04 and exercise 2 already explain this exception correctly. Pending/return timeline descriptions should be understood as the pending path, rather than a guarantee that the method remains pending when its caller receives the future.

2. **[HIGH] Iterator cleanup can prevent result completion.** Chapter 07, line 172, and chapter 10, line 263, describe driver exception routing as unconditional. `IteratorStateMachine{T}.cs:84-87` calls `_steps.Dispose()` before `_builder.SetException(ex)`. A throwing iterator cleanup escapes that catch and can leave the returned future pending. Qualify the explanation with successful cleanup and record this as a runtime limitation. Runtime repair is outside this documentation pass. The hand-written sample's separate qualification about user completion callbacks is useful and should remain.

3. **[MEDIUM] Mailbox accounting describes normal operation.** Chapter 10, line 383, says `_pending` counts accepted messages until their handlers finish. In the current simulator, `AsyncProxyDispatch.cs:162-172` clears queued messages on disposal without reducing `_pending`. Its worker can also leave after a canceled/stopping dequeue before entering the handler's `finally`. Limit the accounting explanation to messages processed during normal operation. The queue-capacity check, immediate `TryPost` refusal, and handler-finally decrement explanations otherwise match the source.

4. **[MEDIUM] File-read timeline assumes a pending Windows native asynchronous read.** Chapter 06 correctly adds a Windows/runtime qualification after its diagram, and correctly discusses short reads and decoder state. Put the pending-path qualification before the walkthrough as well. `Futures.cs:152-155` calls the supplied Begin delegate directly; it can complete the promise before returning. The iterator then takes its completed fast path. A pool-thread resumption is therefore conditional. The test checks returned bytes; its name and comments do not independently establish which OS I/O implementation ran. Keep other-platform worker implementations outside the native Windows claim.

These findings were sent to the root editor before this report. The editor added the completed-registration exception beside the queue-option descriptions, successful-cleanup conditions beside the driver explanation, shutdown limits beside the counter explanation, and pending Windows-path conditions before the read diagram. Recheck disposition: four of four qualification groups resolved in prose/comments. The numbered locations above identify the pre-correction findings; later insertions changed some line numbers.

The throwing-disposal behavior and shutdown accounting remain runtime limitations. This review requested documentation qualifications; it did not authorize or perform runtime repairs.

Root subsequently reported adding the same saved-callback/late-registration qualification to chapter 09's Predictable paragraph. That consistency edit matches qualification 1; it changes prose only.

## Coverage

| Chapter | C# fences | Reviewed areas | Disposition at initial review |
|---|---:|---|---|
| 03 | 7 | conceptual async return, hoisting, saved awaiter, fast path, result/error exits | Pass; pending timelines describe one path |
| 04 | 2 | promise/future/awaiter roles, late registration, runtime-selected continuation, builder | Pass |
| 05 | 5 | thread-static data, execution-context capture, context/post-target placement, actual callback order | Pass |
| 06 | 4 | interlocked total, pool waits, iterator requests, Begin/End, short reads | Qualification 4 |
| 07 | 14 | iterator versus driver, saved pending awaiter, Observe, serial race, losing operation, cleanup | Qualifications 1 and 2 |
| 08 | 0 | ten exercises, race experiment, reentrant monitor, forced registration, struct-copy experiment | Pass |
| 09 | 0 | pattern-to-source mapping, public interfaces, builder limits, modern API comparisons | Pass; queue rule shares qualification 1 |
| 10 | 8 | modern simulator syntax, mailbox handoff/full refusal, pending accounting, shortened decompiler sketches | Qualifications 1, 2, 3 |
| 11 | 8 | hash input, stable closure indices, strided ranges, merging, pool work, printer owner/caller deadlock | Pass |
| Total | 48 | Nine chapters | Four qualification groups resolved; nine chapters pass |

The snippets are appropriately labeled as complete methods, shortened excerpts, conceptual modern syntax, or decompiler sketches. The printer explanation states that `PrintJob` blocks its caller and that calling it on its owner thread can deadlock after a pending delay. The crunch ranges and merges match `SealRange`, `LoopSettler`, `PoolFanOutSettler`, and `CrewSettler`. The corrected loop comment describes captured bounds without claiming a race across sequential chunks.

## Verification and limits

1. `git diff -- '*.cs'` showed documentation changes in `Promise{T}.cs`; this review made no runtime changes.
2. `dotnet build` completed: `Build succeeded. 0 Warning(s) 0 Error(s)`.
3. Exploratory `dotnet format --verify-no-changes` exited 1 with 22 whitespace diagnostics across samples, runtime, and training files. It also reported workspace-loading warnings. These files were left unchanged by this reviewer. Formatting the source is outside the documentation plan's acceptance scope; this result does not establish a documentation failure.
4. Tests were read as evidence of asserted behavior. This reviewer did not rerun tests or benchmarks. Build success does not establish scheduler timing, historical measurements, Windows CE behavior, or simulator equivalence across every scenario.
5. Historical benchmark outputs and IL offsets were preserved as reported artifacts. This review does not certify those measurements, replay the historical build, or independently fetch the external talks and framework histories.
6. The root preservation check owns executable-token, other-fence, diagram, and link comparisons against the captured baseline. This review does not substitute a second preservation result.

Recommendation: accept the reviewed documentation after the root preservation checks. Keep runtime limitations and the exploratory format result visible in the completion record.

## Exploratory format diagnostics

The captured output contains the following 22 WHITESPACE diagnostics in 16 files. Paths are relative to the repository. No command was rerun to produce this inventory.

| File | Lines | Count |
|---|---|---:|
| samples/MMP.AsyncProxy.Forecourt/KevinsPump.cs | 40, 69 | 2 |
| samples/MMP.AsyncProxy.Forecourt/StevesPump.cs | 60, 66 | 2 |
| samples/MMP.AsyncProxy.Samples/AddAfterDelayIterator.cs | 16 | 1 |
| src/MMP.AsyncProxy/Core/FutureCanceledException.cs | 4, 12 | 2 |
| src/MMP.AsyncProxy/Futures.cs | 152 | 1 |
| training/MMP.AsyncProxy.Training/Crunch/Async/LoopSettler.cs | 23 | 1 |
| training/MMP.AsyncProxy.Training/Crunch/Async/PoolFanOutSettler.cs | 31 | 1 |
| training/MMP.AsyncProxy.Training/Crunch/Threaded/CrewSettler.cs | 38 | 1 |
| training/MMP.AsyncProxy.Training/Deadline/Async/WhenAnyCaller.cs | 22 | 1 |
| training/MMP.AsyncProxy.Training/Deadline/Contract/IDeadlineCaller.cs | 124 | 1 |
| training/MMP.AsyncProxy.Training/Deadline/Threaded/ThreadPerAttemptCaller.cs | 45 | 1 |
| training/MMP.AsyncProxy.Training/FanOut/Async/WhenAllCourier.cs | 18 | 1 |
| training/MMP.AsyncProxy.Training/FanOut/Contract/PostOffice.cs | 54 | 1 |
| training/MMP.AsyncProxy.Training/Pipeline/Threaded/ThreadedLine.cs | 79, 84, 94 | 3 |
| training/MMP.AsyncProxy.Training/Printer/Async/NaiveDesk.cs | 32 | 1 |
| training/MMP.AsyncProxy.Training/Printer/Async/PostBackDesk.cs | 36 | 1 |
| Total | | 22 |
