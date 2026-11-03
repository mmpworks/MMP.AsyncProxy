# PRD: release 0.4.0, tests for every story, fuzz, SDK examples

Date: 2026-11-03. Owner: Steve. Builder: main Claude. Branch: `docs/course-eighth-grade`.

## What

1. Every C# code block in the course, the SDK guide, and the training READMEs is either the repo's own code or is marked as a sketch. A test proves it.
2. Every sample project has a test that runs it.
3. The library gets a seeded fuzz suite beside the regular suite.
4. An SDK examples project holds one runnable file per section of `docs/sdk.md`, with a test each.
5. The team reads the thirteen course chapters against the code and the README, and every wrong claim is fixed.
6. README updated, version 0.4.0, tag `v0.4.0` pushed. NuGet publish stays gated.

## Why

The course and the README make claims about code. A reader who copies a block from a chapter must get code that compiles and does what the chapter says. A library that parks continuations and runs them on other threads needs tests that hunt interleavings, which hand-written cases do not reach.

## Acceptance (the kill condition)

| # | Check | Pass when |
|---|---|---|
| A1 | `CourseFenceTests` | every `csharp` fence in `docs/course/*.md`, `docs/sdk.md`, `training/*/README.md` matches repo source at 90% of its code lines, or carries a `<!-- fence: sketch ... -->` marker on the line above; 0 unmarked misses |
| A2 | samples | `Comparison`, `CompilerReference`, `Samples`, `Forecourt`, `Sdk` each have at least one test that executes their code |
| A3 | fuzz | `tests/MMP.AsyncProxy.Fuzz` runs N seeded rounds per generator under `dotnet test` (small N) and from `dotnet run -- <seconds>` (long); a failure prints the seed; 0 failures over a 60 s run |
| A4 | SDK | `samples/MMP.AsyncProxy.Sdk` builds net35 with LangVersion 3; each file maps to one `docs/sdk.md` section; tests cover each file |
| A5 | story review | three readers, each covering all thirteen chapters from a different angle, report findings as tables; every HIGH is fixed or recorded in `docs/_runs/2026-11-03-release-0.4.md` |
| A6 | runtime | the iterator-cleanup limit the senior review found is fixed: a throwing `Dispose` in the iterator body no longer leaves the future pending; test added |
| A7 | gates | `dotnet test MMP.AsyncProxy.slnx` green; `pwsh tools/netcf-build.ps1` green; tic-gate clean on README, PR body |
| A8 | release | PR merged to main, `Version` 0.4.0, tag `v0.4.0` on the merge commit, pushed |

Date: 2026-11-03.

## Non-goals

1. NuGet publish (gated, Steve).
2. Running on a CE device or emulator.
3. Rewriting the course voice. Readers report accuracy; fixes are the smallest edit.
4. A libFuzzer or SharpFuzz harness. The fuzz suite is seeded random interleavings in xunit plus a console runner; no native tooling.
5. Re-running benchmarks. Numbers stay as reported with their dates.

## Decisions

| # | Decision | Choice | Why |
|---|---|---|---|
| 1 | How to prove a fence is real | line-match against repo `.cs` files after whitespace normalisation, 90% threshold, comments and brace-only lines skipped | works for complete methods and for excerpts; no build-time extraction |
| 2 | Sketch marker | HTML comment `<!-- fence: sketch <reason> -->` on the line above the fence | invisible on GitHub, greppable, forces a reason |
| 3 | Where SDK fences live | `samples/MMP.AsyncProxy.Sdk/*.cs`, one file per `docs/sdk.md` section, net35, C# 3 | the guide's code becomes real code the fence test then checks |
| 4 | Fuzz shape | hand-rolled `Fuzzer` with `Random(seed)`, generators for promise races, iterator bodies, WhenAll/WhenAny, cancel, timer wheel; xunit theory over 8 fixed seeds; console runner takes seconds and reports the seed on failure | no dependency; reproducible; runs on net48 against the net35 dll |
| 5 | Fuzz invariants | a future settles once; every registered continuation runs once; `WhenAll` result equals the inputs' states; `WhenAny` winner is complete; no deadlock within a bound; an iterator's future settles after the body ends, even when `Dispose` throws | these are the contracts the README states |
| 6 | Iterator cleanup fix | wrap `_steps.Dispose()` in the catch in its own try; a Dispose fault is recorded with `SetException` (first fault wins, Dispose fault attached as inner data) | the future always settles |
| 7 | Story readers | Richard (code truth, chapters 0-6), a second architecture reader (code truth, 7-12), Iolo (claims and numbers across course + README) | three angles; each reads the full code for its range |
| 8 | Version | 0.4.0 | new public project (Sdk), new suite (Fuzz), runtime fix |

## Boundary

The agent may: write code, tests, docs, commit on the branch, push the branch, open the PR, merge a green PR, push the tag.
Needs Steve: NuGet publish, any claim in outward text about devices this has not run on.
On a failing gate: stop and report. Never `--no-verify`. A reader finding the builder disputes is recorded with both views, not dropped.
Decision owner: Steve. Accepted risk: readers share the builder's model vendor; the fence test and the suites are the anchor, not the readers.

## Anchor

Written before the build: A1 (fence test over the current docs), A3 (60 s fuzz, 0 failures), A7 (full suites). The fence test is independent of every chapter author.
