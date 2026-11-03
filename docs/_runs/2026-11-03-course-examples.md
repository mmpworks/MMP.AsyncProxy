# Course example review

Date: November 3, 2026.

## Scope and acceptance

Review the source examples and nearby explanations in the nine chapters numbered 3 through 11. Steve authorized comment cleanup, clearer explanations, a junior developer reader, and a later senior developer correctness review.

For each example, explain its purpose, required context, control flow, saved data, completion handling, and relevant thread behavior. Add source locations for library excerpts. Mark shortened excerpts, modern-C# comparisons, and intentionally flawed exercise code. Keep comments focused on decisions and behavior that a junior developer could miss.

Finish when nine of nine chapters have a recorded junior-reader disposition and senior-review disposition, identified questions are answered, and preservation checks pass. Target date: November 3, 2026.

## Boundary and decisions

- Edit course comments and surrounding explanations. Preserve the story's established food, drink, and napkin continuity.
- Preserve executable tokens, benchmark output, and existing Mermaid blocks. If an example is misleading, qualify it beside the example; record any defect that needs a separate behavior change.
- Keep C# 3 and .NET 3.5 teaching examples distinct from modern compiler comparisons. Source verification uses this checkout, including the separate simulator checkout when a chapter refers to it.
- No source implementation changes, commits, pushes, or benchmark reruns are needed for this documentation pass.
- Missing sources or conflicting claims are investigated locally. Narrow unsupported claims and record remaining limits rather than inventing behavior.

## Checks

Capture the current course files before edits. Compare executable tokens in C# fences, non-C# fences, existing links, and story continuity against that snapshot. Review claims against the runtime source and its tests. The later senior reader checks the revised chapters independently of the junior reader.

The reviewers use the same model vendor. Their judgments are separate from the source and preservation checks.

## Results

Reviewed and edited nine of nine chapters. The 48 C# fences are distributed as follows: chapter 3 has 7; chapter 4 has 2; chapter 5 has 5; chapter 6 has 4; chapter 7 has 14; chapters 8 and 9 have none; chapters 10 and 11 have 8 each. Chapters 8 and 9 received exercise and concept clarifications.

The comments and walkthroughs now distinguish an individual step from the whole operation, explain saved state and registration, identify source locations, and state required setup. Modern syntax, shortened excerpts, intentionally flawed sketches, and decompiler output are labeled. Added dialogue answers concrete reader questions about typed results, display ownership, and caller blocking.

### Reader passes

- [Jamie, junior reader persona](2026-11-03-course-junior-reader.md): reviewed nine chapters, raised questions per chapter, and reread the revisions. Nine of nine question groups resolved; no remaining reader blocker.
- [Morgan, senior correctness reviewer](2026-11-03-course-senior-review.md): checked nine chapters and 48 C# fences against implementation and contract tests. Four qualification groups were corrected and rechecked: pending versus completed callback registration; iterator cleanup errors; normal-processing mailbox counts versus shutdown; and pending Windows I/O versus synchronous completion.

These are simulated reader roles performed by separate agents using the same model vendor. Source inspection and preservation checks provide evidence separate from their judgments. This pass does not establish a measured reading grade or certify historical benchmark results.

### Preservation and verification

Compared the revised chapters with the snapshot captured before this pass:

1. Executable tokens match in 48 of 48 C# fences. Comments and explanatory text changed; executable examples did not.
2. Content matches in 36 of 36 other fenced blocks, including Mermaid, shell output, and IL excerpts. No diagram rerender was needed.
3. Existing Markdown link targets remain present. Fifteen relative links resolve to local files.
4. The prior paragraphs containing wings, bones, napkins, drinks, baskets, or Dee remain unchanged. Chapters 0 through 2 were outside the editing scope.
5. `git -c core.safecrlf=false diff --check -- docs/course docs/_runs` passed.
6. The senior reviewer ran `dotnet build`: `Build succeeded. 0 Warning(s) 0 Error(s)`. Tests were inspected but not rerun. Benchmarks were not rerun.

### Source limitations recorded

- `IteratorStateMachine<T>.MoveNext` calls `_steps.Dispose()` before recording an exception. Throwing cleanup can escape and leave the overall future pending. Chapters 7 and 10 explain that limit; runtime repair remains separate work.
- The simulator mailbox's `_pending` accounting describes normal handling. Shutdown can discard messages without subtracting them. Chapter 10 now limits its accounting explanation accordingly.
- The printer contract's caller-thread claim exceeds the synchronous postback implementation: an owner-thread caller can block the continuation it needs. Chapter 11 explains the external-caller requirement and a future-returning alternative.
- An exploratory source formatter check reported 22 whitespace diagnostics and workspace warnings. It was outside this documentation plan's acceptance checks. Source formatting was left unchanged; details are in the senior report.

One coordination correction was needed: messages to the completed junior reader queued without starting its follow-up read. An explicit follow-up task started the final acceptance read. No review finding was lost.

Disposition: complete on November 3, 2026. Nine chapters reviewed by both reader roles; reader questions and documentation correctness findings resolved. Runtime implementations and recorded measurements remain unchanged by this pass.
