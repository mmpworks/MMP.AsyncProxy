# How async/await works, from the inside

A short course. Eight chapters, each one a conversation between two developers after hours, going over how the machine works. Code is from this repo, so you can open the file next to the chapter and step through it.

You need: a C# compiler of any age, `dotnet` to run the samples, and about two hours.

| # | Chapter | What you leave with |
|---|---------|---------------------|
| 1 | [Why threads hurt](01-why-threads-hurt.md) | Why "one thread per thing" stops scaling, with numbers from this machine |
| 2 | [Callbacks and promises](02-callbacks-and-promises.md) | The Promise/Future split and why only one side can finish |
| 3 | [The state machine](03-the-state-machine.md) | What the compiler emits for an `async` method, read line by line |
| 4 | [Awaiter and builder](04-awaiter-and-builder.md) | The three-call protocol and the four-call builder, with a sequence diagram |
| 5 | [Context rides along](05-context-rides-along.md) | How a value set before an await is still there after it, on another thread |
| 6 | [Threads versus the machine](06-threads-vs-the-machine.md) | Run the comparison console and read the table |
| 7 | [The iterator trick](07-the-iterator-trick.md) | How `yield return` gets you async on C# 2.0 |
| 8 | [Exercises](08-exercises.md) | Write your own machine, break it, fix it |

Diagrams: Mermaid blocks render on GitHub. The tldraw canvas in `diagrams/` opens in tldraw desktop or at tldraw.com.

## The one-sentence version

`await` does not wait. It cuts the method in two at that line, hands the second half to the thing you awaited as a callback, and returns. Whatever finishes the work calls the second half, on whatever thread it happens to be on.

Everything else in these chapters is the plumbing that makes that sentence true.
