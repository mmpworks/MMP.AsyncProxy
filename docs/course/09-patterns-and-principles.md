# 9. Patterns and principles

We did not sit down and pick patterns. We built the smallest thing that worked and the patterns showed up, because they are the shapes these problems take. This chapter names them after the fact, points at the file each one lives in, and then holds the code up against CUPID, SOLID, and DRY. Where it falls short, we say so.

## The patterns, by file

| Pattern | Where | What it buys |
|---|---|---|
| **Future / Promise** | `Core/Promise{T}.cs`, `Core/IFuture.cs` | A placeholder for a value that arrives later, split into a write side and a read side. Older than most of us: Baker and Hewitt named futures in 1977, Liskov and Shrira named promises in 1988. |
| **Observer** | `Promise<T>.RegisterContinuation`, `IAwaiter.OnCompleted`, `CancelToken.Register` | "Call me when it happens." Every continuation is an observer of one promise. Cancel callbacks are observers of one source. |
| **State machine** | `samples/.../AddAfterDelay.cs`, `Iterate/IteratorStateMachine{T}.cs` | A method that can stop and resume. An `int` says where we are, a `switch` jumps back there. This is the table-driven kind, with one method and a state field. The GoF State pattern, with one class per state, would be ten times the code for no gain here. |
| **Iterator, used as a coroutine** | `Iterate/AsyncProxy.cs` | `yield return` already suspends and resumes. We drive it from the outside and it becomes a coroutine. |
| **Adapter** | `Futures.FromAsync`, `Futures.Observe`, `IteratorStateMachine` | Begin/End becomes a future. A future that may fault becomes one that cannot. An `IEnumerator<IFuture>` becomes an `IAsyncStateMachine`. Three adapters, same job: make an old shape fit a new socket. |
| **Facade** | `Futures`, `AsyncProxy` | Two static classes with short names in front of the machinery. Most callers never see a builder or an awaiter. |
| **Protocol, duck-typed** | `Core/IAwaiter.cs` | Three members. In C# 5 the compiler does not even need the interface; anything with those three members is awaitable. We made it an interface because C# 3 has no way to say "anything with these members". |
| **Null Object** | `CancelToken.None`, `EmptyDisposable`, `VoidResult`, `Futures.Completed` | A value that is safe to use and does nothing. Callers skip the null checks. |
| **Registration handle** | `CancelSource.Register` returns `IDisposable` | Subscribe, get a handle, dispose the handle to unsubscribe. The .NET idiom for "undo a registration", from `IObservable` to event-to-token bridges. |
| **Wrapper, for the non-generic twin** | `Core/Promise.cs`, `Builder/AsyncMethodBuilder.cs` | The void versions hold a generic one over `VoidResult` and forward. One implementation to get right. |
| **Countdown latch** | `Futures.WhenAll` | N callbacks, one counter, `Interlocked.Decrement`, whoever hits zero finishes the job. No lock, no waiting thread. |
| **Ambient context, captured and restored** | `AsyncMethodBuilder<T>.AwaitOnCompleted`, `FutureAwaiter<T>.OnCompleted` | Grab `ExecutionContext` and `SynchronizationContext` at one point, put them back at another. Same move the state machine makes with its locals, applied to the environment. |
| **Read-only view** | `Core/Future{T}.cs`, handed out by `Promise<T>.Future` | A separate sealed object that forwards the read members. The receiver cannot reach the setters by any cast. Capability by object identity, not only by static type. |

Thirteen named shapes in about 700 lines of library. None of them were added for their own sake. Each one is the answer to a question the previous chapter asked.

## CUPID

Dan North's CUPID is five properties code can have. Not rules. Things that, when present, make the code a joy to work in. We check each one against this repo.

**Composable.** Small surface, few dependencies, intention revealing. `IFuture` has seven members. `IAwaiter` has three. You can combine futures with `WhenAll`, `WhenAny`, and `Observe` without any of them knowing about the others, because they all speak `IAwaiter`. A new combinator is a new static method; nothing existing changes. Score: good.

**Unix philosophy.** Does one thing well. `Promise` completes. `FutureAwaiter` answers three questions. `AsyncMethodBuilder` makes four calls. `IteratorStateMachine` pulls the next step. `CancelSource` flips a flag and runs callbacks. Open any file and the class fits on a screen with its comments. Score: good. The one that does two things is `Futures.Delay(ms, token)`, which is both a timer and a cancel race, and the comment inside says so.

**Predictable.** Does what it looks like, deterministic, observable. A future moves once and never back. First completion wins and the second is refused. Continuations run inline unless you asked otherwise, and the constructor flag is the only place that changes. There are no hidden threads. A future handed out as read-only stays read-only, because it is a different object from the promise. Score: good. The first draft had a hole here; see "where we fell short".

**Idiomatic.** Feels natural to a .NET developer. The names are the .NET 4.5 names with one letter changed, on purpose. `Begin`/`End` adapts through a method that looks like `Task.Factory.FromAsync`. Registrations return `IDisposable`. The C# 3 inside uses anonymous delegates where a modern reader expects lambdas, because C# 3 lambdas cannot be statement bodies in every position we needed. Score: good for 2008, slightly dated for 2026, which is the point.

**Domain-based.** Uses the language of the problem. The domain here is asynchrony, and the words are future, promise, awaiter, continuation, state, cancel. No `Manager`, no `Helper`, no `Util`. Score: good.

## SOLID

SOLID is older and more prescriptive. CUPID came out of frustration with how SOLID gets applied, so we treat it as a checklist rather than a creed.

**Single responsibility.** The split between `Promise` (holds the result), `FutureAwaiter` (answers the compiler), and `AsyncMethodBuilder` (drives the machine) is the whole reason the hand-written machine and the iterator machine can share parts. Collapse them into one class and you could not write `IteratorStateMachine` without copying half of `AddAfterDelayMachine`.

**Open/closed.** `IAwaiter` is the extension point. Any type that implements it can be parked on. `Futures.FromAsync` means every Begin/End API in the framework became awaitable without touching the library. Adding `WhenAny` in slice 2 touched zero existing files.

**Liskov substitution.** `IFuture<T>` is an `IFuture`. Anywhere that takes the base, the generic works. `WhenAll` takes `IFuture[]` and you pass typed futures in without a cast. `Promise<T>` is an `IFuture<T>` and behaves like one everywhere it is passed as one.

**Interface segregation.** `IAwaiter` has three members and nothing else, because that is all the compiler calls. `IFuture` has no setters. A caller that only needs "tell me when" gets `IAwaiter`. A caller that needs "give me the value" gets `IFuture<T>`. Nobody gets `SetResult` unless they made the promise.

**Dependency inversion.** The state machine depends on `IAwaiter` and on the builder. It does not know about timers, thread pools, or file handles. `Futures.FromAsync` takes two delegates and never names `FileStream`. Swap the timer for a socket and the machine does not change.

One caveat: SOLID is easy to pass when the code is this small. The test is whether the shapes hold at ten times the size. The reason to believe they do is that the real .NET runtime has the same five seams and has held for fourteen years.

## DRY

Rule of three: duplicate once and wait, extract on the third. Here is where we extracted and where we are waiting.

**Extracted.**

- `Promise` is a shell over `Promise<VoidResult>`. One completion algorithm.
- `AsyncMethodBuilder` is a shell over `AsyncMethodBuilder<VoidResult>`.
- `Futures.Run(Action)` calls `Run<VoidResult>`. `Run<T>(work)` calls `Run<T>(work, CancelToken.None)`. `Delay(ms)` calls `Delay(ms, None)`. Every overload funnels to one body.
- `IAwaiter.GetResult()` on the generic awaiter forwards to the typed one.

**Waiting.** The two-case register shape, "if pending add to list, else run now, under a lock", appears in `Promise<T>.RegisterContinuation` and in `CancelSource.Register`. Two occurrences. The third would be a `Signal` or a `Latch`, and that is when it becomes a shared `CallbackList` type. Until then, two copies of eight lines are cheaper than a shared abstraction that has to serve both and fit neither.

**On purpose.** `AddAfterDelay.cs` and `AddAfterDelayIterator.cs` do the same thing twice. That duplication is the lesson. Deleting either one deletes the comparison.

## Where we fell short

Three things a reviewer flagged on the first draft. One is fixed. Two are watched.

1. **The read-only view was a cast away. Fixed.** The first draft had `Promise<T>` implement `IFuture<T>` and return `this` from `Future`. Anyone who wrote `(Promise<T>)future` got the setters back. The fix was a separate sealed `Future<T>` that holds the promise and forwards the reads, which is how `TaskCompletionSource` and `Task` are arranged. Cost: one allocation per promise. The test `Future_view_cannot_be_cast_back_to_a_completer` now asserts the types are unrelated, and the compiler rejects the cast at build time. Lesson for the course: a review that names a concrete fix gets acted on. One that says "consider encapsulation" does not.
2. **Booleans as strategy.** `continueOnCapturedContext` and `runContinuationsAsync` are flags. Two flags are fine. A third would be the moment to turn them into an options object or a small policy interface. Watch for it.
3. **`SetStateMachine` is empty.** Fine for class machines, wrong for struct ones. Exercise 10 in chapter 8 is where you find out why. A real release would either implement it or seal the door by making the builder refuse struct machines at compile time, which C# 3 cannot express.

## The one to remember

If you forget every pattern name in the table, keep this: every piece here is a capture at one point and a restore at another. The state machine captures locals in fields and restores them on `MoveNext`. The builder captures `ExecutionContext` and restores it before the callback. The awaiter captures `SynchronizationContext` and posts back to it. The promise captures continuations and runs them on completion. Same move, four places. That is what Composable looks like when it is working.
