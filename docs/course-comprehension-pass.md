# Course comprehension pass

Date: November 2, 2026.

## Scope

Revise the opening story, chapters 1 through 11, and the course README for an eighth-grade reading target. Keep the story, technical terms, and supported qualifications. Explain each code walkthrough through its inputs, actions, saved state, and result.

Use the shared humanization runbook, followed by a shorter-language pass. Use "buddy" where the dialogue previously used "bro". Keep natural dialogue without adding slang.

## Acceptance

1. Read and edit the 12 numbered story files and course README.
2. Explain unfamiliar terms before relying on them in a walkthrough.
3. Make the actor and execution order clear at each pause and resume.
4. Check changed technical claims against repository source.
5. Preserve fenced code, output, Mermaid diagrams, and existing link destinations.
6. Run an independent editorial acceptance read and resolve its findings.

The pass ends when these 13 files have been reviewed and the preservation and acceptance checks pass. Target completion date: November 2, 2026. The reading level is an editorial target; a formula cannot establish reader understanding.

## Boundary

Authorized work covers prose edits and local checks. Source code, generated diagrams, benchmark output, and public publication remain outside this pass. If a protected example needs a qualification, explain the limit beside the example. Record unresolved conflicts here.

## Results

1. Edited 12 numbered story files and the course README. The pass explains callbacks, saved fields, context flow, iterator results, and failure handling through concrete steps.
2. The arithmetic walkthrough now follows inputs `3` and `4` through saved sum `7` to result `14`.
3. Corrected unsupported claims about scheduler scans, fixed pool sizes, thread changes, timing guarantees, and exercise failures. Benchmark comparisons now distinguish the 64-request batch from the 2,000-request batches.
4. Replaced dialogue "bro" with "buddy". Removed repeated lesson closers and reduced explanations that repeated the preceding example.
5. Checked 102 fenced blocks and 15 link destinations against the original Git revision. Their contents and destinations remain unchanged. Local link targets exist. `git diff --check` passes.
6. A separate editorial reader read the 13 files and returned PASS after 11 corrections. The corrections clarify batch sizes, object size, UART callbacks, scheduling claims, and the README's shorter arithmetic example. This acceptance uses the same model vendor. It supports the comprehension target without certifying a measured reading level.

## Limits and follow-up

Code and diagrams remain protected. Some diagrams use simplified labels or show the context calls in the wrong order. The adjacent walkthrough gives the correct behavior. The approval callbacks in chapter 2 are placeholders; the revised text requires checking success, cancellation, and errors before approving fuel.

Recorded benchmark output remains unchanged. This prose pass did not rerun benchmarks or device timing tests. Readability formulas are secondary checks; they do not establish that a reader understands the code.

One editing command corrupted two punctuation characters through text decoding. Both characters were restored. A scan of the course files found no remaining instances of that encoding error.

Disposition: complete on November 2, 2026. The 13 course files passed editorial acceptance and the preservation checks.

## Metaphor review, November 2, 2026

Steve rejected the HR-file comparison in chapter 1 and requested a course-wide review of weak metaphors.

1. Reviewed 13 course files and edited 12. Replaced HR files and roll-call sheets with thread control records, IDs, priorities, and states. Updated three Mermaid diagrams to use the same terms. This follow-up changes diagram labels that the first pass preserved.
2. Replaced stack-as-hands, lock-as-marker, dummy-lamp, padded-envelope, and key-fitting-a-hand explanations. Removed the pizza-delivery detour and used the actual four-worker, 64-job example.
3. Corrected two misleading comparisons. Unsubscribing a callback ends notifications without canceling the operation. An owner thread can run other queued work between device calls.
4. Retained useful comparisons, including the restaurant pager and recipe bookmark. Glossaries now allow direct examples instead of requiring a metaphor for each term.
5. A separate editorial reader identified weak comparisons and checked the replacements. Resolved its four remaining references to removed comparisons.
6. Compared this follow-up with a snapshot taken before its edits. The 65 code and output blocks and existing link destinations remain unchanged. Only Mermaid labels changed within fenced blocks. The removed comparisons and encoding-error patterns have no remaining matches. `git diff --check` passes.

Disposition: metaphor corrections complete. No source code or benchmark results changed.

## Chapter 1 job-board review

Steve now explains what a work item contains before the diagram introduces promises. The queue accepts a callback with optional data. The API does not inspect that callback for blocking calls or long calculations.

The chapter distinguishes pending callbacks stored by a promise from callbacks ready for a pool worker. It explains the library's queued-completion option, default inline completion, and immediate registration on an already completed promise. The diagram shows one board as a teaching simplification.

Checked the explanation against `Promise<T>.RegisterContinuation`, `Promise<T>.Complete`, and `DelayWheel`. Checked the callback-and-data API against [Microsoft's QueueUserWorkItem reference](https://learn.microsoft.com/en-us/dotnet/api/system.threading.threadpool.queueuserworkitem). Removed unverified Compact Framework pool-size arithmetic and corrected the timer/UART explanation.

A separate editorial reader confirmed the source behavior and identified two remaining issues: an unmeasured callback duration and a dialogue reference to a removed phrase. Both were corrected. The executable example remains unchanged, and `git diff --check` passes.

Disposition: chapter 1 accuracy and job-board explanation complete.

### Conversation flow follow-up

Reordered the job-board dialogue around two pump examples. Steve first traces a pulse-count check from delegate to queued work item to worker. Kevin then asks about sleeping loops, which leads to the timer. Steve introduces the diagram's promise route through a bank reply before explaining queued and inline notification. A separate reader passed the revised flow and source accuracy. Code and Mermaid blocks remain unchanged; `git diff --check` passes.

Added the distinction between stored promise data and queued callback code. Steve explains that pool workers also run short callbacks, and that setting up a timer differs from queuing immediate work. A comparison table shows the three routes. The `DelayWheel.Fire` example explains why this library queues each due completion separately even though its timer callback already runs on a pool thread. Checked against local source and Microsoft's timer and work-item API references. Independent editorial acceptance passed; fenced blocks remain unchanged.

Separated the two callback roles in the bank example: the receiving callback stores the reply, and the registered sale continuation reads the outcome and continues the sale. Updated the dialogue, diagram label, comparison table, and glossary to keep those names consistent. Independent acceptance passed. The edited Mermaid diagram rendered successfully; the C# example remains unchanged.

Replaced the mixed timer and serial explanation with four ordered steps for one console delay: setup, continuation registration, pending delay, and completion. A separate serial-reply section explains the receiving callback and the driver's possible reader thread. Independent acceptance and whitespace checks passed. Fenced blocks remain unchanged.

Steve rejected that delay walkthrough because it introduced later chapters' mechanisms before establishing their need. Removed it. Chapter 1 keeps the concrete pulse-check timer example in the conversation. The serial-reply example now has its own section heading. Fenced blocks remain unchanged, and the whitespace check passes.

## Chapter 2 annotated bakery example

Filled the second copy of Kevin's `Authorize` method with comments connecting the pickup shelf to `reply`, the ready signal to `arrived`, and delivery to the receiving callback. Explained registration before sending, the blocking wait, timeout, unsubscribe without cancellation, and disposal. Introduced both bakery objects before the annotated copy. Clarified that the event remembers a signal until consumed, unlike an ordinary bell.

The first code copy remains unchanged. The second copy has the same executable C# tokens as the first. The late-reply and disposal-race caveat remains in the walkthrough. A C# reviewer passed the comments; its wording correction removes an implication that the callback always uses a separate thread. Whitespace checks pass. Runtime source files remain unchanged.

Steve clarified that the original code needs comments exposing its flaws. Added those comments to the first copy: the blocked caller, timeout without request cancellation, and event disposal racing an in-flight receiving callback. The bakery copy remains further down, with an explicit note that it is the same method and still has those flaws. Both copies retain the original executable tokens. The accurate `using` explanation remains in the later bakery copy.

### Show the repair after the blocking diagram

Reordered chapter 2 to show the original method and blocking sequence first. The fix conversation now follows that diagram. It introduces a callback-only `Authorize` returning `IFuture<string>`, shows the caller registering a continuation, and then shows the updated sequence diagram. Promise internals follow the repair. The repair uses no iterator or reader-written state machine.

The repaired method registers cleanup before sending, lets reply and timeout compete through `TrySetResult`, and faults the future on setup errors. It removes the disposable event and the caller's blocking wait. The text names the remaining limits: prompt `Send`, finite supported timeout, the losing timer still scheduled, request correlation, and any serial reader thread.

Verification: extracted the method directly from Markdown and compiled it with C# 3 syntax in a temporary .NET 10 console harness against this library's netstandard2.0 target. Five of five cases passed: return before reply, timeout with a captured late callback, send failure, synchronous reply during send, and timer-setup failure. This is a desktop proof, not a Windows CE run. Temporary proof files are under `C:/Users/smuch/AppData/Local/Temp/asyncproxy-ch2-proof`.

A C# reviewer passed the example. Its setup-order correction was applied to the sequence diagram. Mermaid CLI rendered six of six chapter diagrams. `git diff --check` passes. Runtime source files remain unchanged.
