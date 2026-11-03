# Junior reader pass

Date: November 3, 2026.

Reader: Jamie, a junior C# developer who knows methods, classes, fields, and delegates. Jamie has read chapters 0 through 2 and is new to async internals. This pass uses `E:/dev/MMP.Humanization/RUNBOOK.md`, especially causal order, concrete mechanisms, source-comment purpose, and preserving technical qualifications.

Status: closed. Nine of nine chapter question groups answered on the revised read.

Coverage: nine of nine chapters, numbered 3 through 11. Questions below describe the initial read. Editors received them before this report was saved. Some revisions may already address them.

| Chapter | Reader questions and requested clarification |
|---|---|
| 3, The state machine | In the saved-fields and stub examples, which promise holds the whole calculation's result, and which promises belong to individual delays? The source path and numeric walkthrough already explain most other questions. Name the two completion lifetimes when introducing `Builder`. |
| 4, Awaiter and builder | Where are the interface and builder files under the repository root? Why does `IAwaiter.GetResult` return `void` when a bank reply is a string? Introduce the typed interface beside the base interface. Distinguish this library's three-member interface from the modern compiler's full awaiter requirements. |
| 5, Context rides along | Can the `async Handle` sketch compile with Kevin's C# 3 compiler? Which source files contain the builder and awaiter excerpts, and which declarations were omitted? Is `DisplayQueue` supplied by the library or written by the application? Label the display setup as a sketch and explain who drains its queue. |
| 6, Threads versus the machine | Where do `a`, `sum`, and `delivered` come from, and what keeps the console alive until jobs finish? Label shortened or illustrative fragments and link the comparison source. Does one `BeginRead` fill the whole file? Explain the test's one-read scope and production short-read handling. The main-thread `Wait` explanation already answers why the batch itself blocks. |
| 7, The iterator trick | How does the public `Authorize` method start `AuthorizeBody`, and what is `_link`? Which file contains this version? Which `MoveNext` belongs to the driver, and which belongs to the compiler's iterator? Does `Observe` make a canceled input safe to read through `Result`? The shown `else` needs an explicit success-only qualification. |
| 8, Exercises | Which source file should I edit for each exercise? In exercise 4, what is the first promise's sibling, and which two locks do the two threads hold? Name promises A and B and describe the cross-access. In exercise 1, does adding a wait keep the numeric answer while changing timing? Preserve the existing warnings that race and struct experiments can produce different observations. |
| 9, Patterns and principles | How does a new operation fit the extension interface without changing the driver? Does an awaiter only notify, or also collect the outcome? Narrow the original broad Begin/End and interface-segregation statements. The delay walkthrough already distinguishes the step's promise from the whole method's promise. No C# source fences need comments here. |
| 10, Waiting without a thread | Which blocks are modern simulator source, shortened sketches, or decompiler output that cannot compile as written? Why does `TryPost` say the sender waits when it returns `false`? What does `_pending` count, and where is it decremented? Explain the `Observe(next)` wrapper and original-future check together. Identify both `MoveNext` methods and keep cancellation distinct from failure. |
| 11, When threads win | Why copy `t` into `me` and `start` into `from` before constructing delegates? What does the range stride mean in each version? When are partial totals merged? Does priority guarantee a thread yields? Can a naive printer call ever start on its owner thread? For postback, explain that `Invoke` waits for setup while `job.Result` blocks the external caller, and that an owner-thread caller would need a different API. After `yield return chunk`, explain why merging occurs only after successful completion. |

## Acceptance status

This is a simulated junior-reader audit, not a study with a human junior developer or a senior correctness verdict. The initial questions were derived from the chapters and their code fences, without reading other reviewers' feedback. The final read checked the revised explanations against those questions. The parent also identified the final senior-review qualification groups to include in that read. No course files were edited by this reader.

## Revision closure

Final read: November 3, 2026. Disposition: nine of nine pass for clarity within the source-example review scope. No remaining concrete junior-reader blocker was found.

| Chapter | Status | What answers the original questions |
|---|---|---|
| 3 | Pass | The builder field and stub comments distinguish the final calculation promise from the two delay operations. The chapter labels shortened excerpts and conceptual modern syntax. Saved fields, resume points, and cancellation/error exits have explicit descriptions. |
| 4 | Pass | Linked source files identify the interface, awaiter, and builder. Kevin asks why the interface returns `void`; Steve explains typed `IAwaiter<string>` and the untyped outcome check. The full compiler pattern is distinguished from the teaching interface. |
| 5 | Pass | The flawed modern sketch is labeled as incompatible with Kevin's compiler. Source links and omitted generic constraints are named. The application supplies `DisplayQueue`; its posting and draining responsibilities are stated. Context capture and restoration remain separate from thread selection. |
| 6 | Pass | The comparison source and surrounding inputs/completion checks are identified. The file-read example explains buffer lifetime, actual bytes read, short reads, and decoder state. The diagram is explicitly a pending Windows read with registration before completion; an already-complete read can continue on the same thread. |
| 7 | Pass | The public wrapper, `StevesPump.cs`, injected serial link, result box, and two `MoveNext` methods are identified. The text separates the reply promise from the race and whole-operation results. Cancellation in the `Observe` sketch is qualified. Disposal runs cleanup, and cleanup can itself throw before the result promise completes. Saved callbacks and registration after completion have distinct scheduling rules. |
| 8 | Pass | Source locations and named tests establish the edit targets. Exercise 1 distinguishes the unchanged answer from proving an extra step ran. Exercise 4 names A and B and defines the barrier as coordination that gets both callbacks holding their respective locks before cross-access. Race experiments retain their nondeterministic-result warnings. |
| 9 | Pass | The extension example now describes compatible future/awaiter interfaces and matching Begin/End delegates. End collects the value or error. Interface segregation explains the actual members rather than implying awaiters only notify. Saved callbacks and late registration are distinguished. |
| 10 | Pass | The simulator revision, modern syntax, omitted declarations, reading sketches, and decompiler output are labeled. Mailbox refusal returns immediately. The normal-processing counter includes accepted messages until handling ends, with a separate shutdown caveat. `Observe` and the original-future checks are explained together. Cleanup failure and late-inline registration limitations are stated. |
| 11 | Pass | Delegate comments explain captured index/bound snapshots. Stride examples show each job's record set; merging follows `Join` or successful `WhenAll`. Priority is a scheduling request. Printer behavior is tied to the stated console scenario. The fake owner thread is distinguished from a real COM apartment. The setup wait, external caller's blocking read, and owner-thread deadlock risk are explicit. |

## Runbook acceptance

The final pressure-point search found existing story dialogue and comparison wording such as "the whole" and "rather than." Those hits do not create unanswered source-example questions. The new comments explain ownership, lifetime, races, thread/context behavior, or omitted scope. They do not require the reader to infer those facts from the next code line. Explanations retain qualifications about cancellation, late registration, short reads, shutdown, and cleanup errors. Existing story passages remain outside this reader's editing authority.

This disposition assesses clarity and causal order. Runtime correctness, executable-token preservation, links, and unchanged story continuity have separate checks owned by the parent and senior reviewer.
