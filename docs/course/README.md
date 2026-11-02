# How async/await works, from the inside

A short course. Eleven chapters, each one a conversation between two developers after hours, going over how the machine works. Code is from this repo, so you can open the file next to the chapter and step through it. You don't need to know threads already. Each chapter says what its words mean the first time they show up, and every picture comes with a plain-words walkthrough.

The two developers are Steve and Kevin. Kevin keeps the firmware for a fuel dispenser: Windows CE 6, .NET Compact Framework 3.5, the Visual Studio 2008 compiler, four threads, and a box with 64 MB. They meet for wings at a place on the frontage road where Dee, the waitress, knows both their orders. Each chapter opens at the table, where Kevin asks what a working engineer would ask and Steve answers with the thing in the chapter. The code Kevin brought (threads) and the code he left with (this library) are in `samples/MMP.AsyncProxy.Forecourt`, built for net35 with C# 3, and `tests/MMP.AsyncProxy.Tests/ForecourtTests.cs` runs both.

You need: a C# compiler of any age, `dotnet` to run the samples, and about three hours.

| # | Chapter | What you leave with |
|---|---------|---------------------|
| 0 | [Dinner](00-dinner.md) | Kevin's pump, his four threads, and the problem he brought |
| 1 | [Why threads hurt](01-why-threads-hurt.md) | Why "one thread per thing" stops scaling, with numbers from this machine |
| 2 | [Callbacks and promises](02-callbacks-and-promises.md) | The Promise/Future split and why only one side can finish |
| 3 | [The state machine](03-the-state-machine.md) | What the compiler emits for an `async` method, read line by line |
| 4 | [Awaiter and builder](04-awaiter-and-builder.md) | The three-call protocol and the four-call builder, with a sequence diagram |
| 5 | [Context rides along](05-context-rides-along.md) | How a value set before an await is still there after it, on another thread |
| 6 | [Threads versus the machine](06-threads-vs-the-machine.md) | Run the comparison console and read the table |
| 7 | [The iterator trick](07-the-iterator-trick.md) | How `yield return` gets you async on C# 2.0 |
| 8 | [Exercises](08-exercises.md) | Write your own machine, break it, fix it |
| 9 | [Patterns and principles](09-patterns-and-principles.md) | The thirteen patterns that showed up, and the code held against CUPID, SOLID, and DRY |
| 10 | [Waiting without a thread](10-waiting-without-a-thread.md) | The worker loop with threads and with the machine, in a real program, down to the IL. The door into `training/` |
| 11 | [When threads win](11-when-threads-win.md) | The jobs where async is the wrong tool: CPU work, and a device that owns a thread. Two runnable projects with numbers |

Diagrams: Mermaid blocks render on GitHub. The tldraw canvas in `diagrams/` opens in tldraw desktop or at tldraw.com. Every diagram is followed by an **In words** walkthrough (the steps, in time order, saying who is working and who is waiting) and a **Why it matters** line. If a picture doesn't make sense, read the words under it first, then look at the picture again.

## The one-sentence version

`await` does not wait. It cuts the method in two at that line, hands the second half to the thing you awaited as a callback, and returns. Whatever finishes the work calls the second half, on whatever thread it happens to be on.

![await is a callback, not a thread](diagrams/async-state-machine.png)

Read the picture clockwise from the top left.

**In words:**

1. **Caller thread (top left).** Some code calls `AddAfterDelayAsync(3, 4)`. This is the only thread in the picture so far.
2. **State machine (top, second box).** The call builds a state machine, which is the method turned into an object (chapter 3). It sets `State = -1` for "running" and runs `MoveNext()` until it hits the first `await`.
3. **Awaiter (top, third box).** At the `await`, the machine asks the awaiter "are you done yet?" The answer is no. So the machine says "call `MoveNext` when you are" (`OnCompleted(MoveNext)`) and returns. The thread leaves.
4. **Timer / OS (top right).** The timer holds the callback and counts. Time passes down the right side, and no thread is waiting anywhere. That is what the label "zero threads used" says.
5. **Timer fires (bottom right).** When the time is up, a pool thread picks up the callback.
6. **Builder (bottom, third box).** The builder restores the backpack (the `ExecutionContext`, chapter 5) and calls `MoveNext()`.
7. **State machine again (bottom, second box).** This time `State = 0`, so the machine jumps to `Resume0`, which is the line after the `await`, and carries on. It runs to the next `await` (the arrow that loops back up to the awaiter, labelled "repeat per await"), or to the end and `SetResult`.
8. **Promise completed (bottom left).** At the end the promise is completed, the waiting continuations run, and the caller's own `await` resumes.

**Why it matters:** the thread leaves at every `return`, and something other than a thread (a timer, the operating system) brings the work back. Between the steps, nothing is being held.

Everything else in these chapters is the plumbing that makes that sentence true.

## The pictures the course keeps using

The same few pictures carry the whole course. They are introduced where the chapter needs them and reused after that, so you only learn each once.

| Idea | The picture | Chapter |
|---|---|---|
| **Thread** | A worker with a desk (the **stack**), a file at HR (the **kernel object**), and a line on the manager's roll-call sheet (the **scheduler's** list) | 0, 1 |
| **Waiting on a thread** | Standing at the counter, staring at the cook | 1 |
| **Callback** | The restaurant pager: leave it, go sit, it buzzes | 1 |
| **Thread pool** | A small shared crew, one job board, and tickets (**work items**). A motor pool, not a parking lot | 1 |
| **Promise and future** | A pickup window. The kitchen can put food in it, once. The customer can only look and ask to be buzzed | 2 |
| **State machine** | A recipe with a bookmark and a sticky note of everything you were holding | 3 |
| **Context** | A backpack that travels with the job, and a sign that says "back to counter 3" | 5 |
| **Pool starvation** | A pizza shop where every driver must sit parked at the curb after each delivery | 6 |
| **Async versus threads** | Waiters and cooks. Async is how one waiter handles twenty tables. Chopping twenty thousand onions takes cooks | 11 |
