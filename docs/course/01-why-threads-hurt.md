# 1. Why threads hurt

## At the table

"Four threads," Steve said, tapping the napkin. "Tell me what each one is doing right now. Not what it's for. What it's doing."

"Right now? Nobody's at the pump. So the pulser thread is asleep. Fifty milliseconds, wake up, read zero pulses, go back to sleep. Card reader thread is blocked on the reader. Serial thread is blocked on a read. Display thread is... sleeping until something changes."

"So four threads and all four are asleep."

"They're waiting. That's the job."

"Sure. And what does a sleeping thread cost you on that board?"

Kevin thought about it. "The stack. CE gives you sixty-four K by default. We bumped the serial one to 256 because it blew up once."

"So a quarter meg for a thread whose whole job is to sit in a read call. Plus the kernel's record of it. Plus the scheduler looks at it every time it goes around the room, decides it's still asleep, moves on. Four threads, fine. You said you're adding a second nozzle, a printer, loyalty. That's eight. Ten. And the fifteen-year-old guy's code makes a thread for every one of them because that's how you did it in 2009."

"That's how you did it in 2009."

"It's how I did it in 1989. Different problem, same mistake. The thread isn't doing the waiting. The UART is doing the waiting. The timer chip is doing the waiting. Your thread is standing next to the hardware so it can be the one who notices when it's done." Steve pulled a wing apart. "What if the thread left, and something else noticed?"

"Something else like what."

"Like a callback. The hardware finishes, it raises a signal, and a pool thread runs one small piece of code: pick up where that method left off. On whatever thread. The method doesn't care."

"Pool thread. On CE."

"The Compact Framework has a thread pool. Twenty-five threads, 128 K stacks, if the 2.0 docs still hold for your 3.5. Three megs of stack for the whole pool, worst case. It's small because the work items are small: a pool thread runs your code for the microseconds it takes to compare a pulse count to a ceiling, and goes back." He turned the laptop around. "Here's the shape of what you have, and the shape of what you're going to have."

So here is the thing nobody tells you when you learn threads. A thread is a great tool for doing work. It is a terrible tool for waiting.

## What a thread costs

Every thread you make gets:

- A reserved stack. One megabyte on Windows by default. Reserved, so it is address space more than RAM, but 2000 threads is 2 GB of address space on a 32-bit process. That process will not start.
- A kernel object. The OS has to track it, schedule it, context-switch into it.
- A slot in the scheduler's attention. The more threads, the more time the OS spends deciding who runs, and the less time anything runs.

And when that thread is sitting in `Thread.Sleep` or blocked on a socket read, it is paying all of that to do nothing. That is the waste.

## The thread pool was the first fix

"Fine," said .NET 1.0, "stop making threads. Put the work in a queue, and a small set of threads will pull from it." That is the thread pool. It is great, as long as the work items do work.

Put a `Thread.Sleep` inside a work item and you have pinned one of those few threads. Put sixty-four of them in and the pool drains at a crawl, because it adds new threads slowly on purpose. Stephen Toub walks through this at 50:18 in his "Writing async/await from scratch" talk. We measured it in chapter 6.

## The real fix: stop waiting on a thread at all

When you read from a socket, your thread is not doing the reading. The network card is. When you wait 200 ms, your thread is not doing the waiting. A hardware timer is. The thread is just standing there so it can be the one to notice when the work is done.

So the question becomes: what if the thread left, and something else noticed?

That "something else" is a callback. The OS or the timer finishes, raises a signal, and a pool thread picks up a small piece of work: "run the rest of that method." The method continues. The thread it continues on may be a different one. The method does not care.

## The picture

```mermaid
flowchart LR
    subgraph Threads["One thread per request"]
        T1[Thread 1<br/>sleeping] --> W1[wait 200 ms] --> R1[add]
        T2[Thread 2<br/>sleeping] --> W2[wait 200 ms] --> R2[add]
        T3[Thread N<br/>sleeping] --> W3[wait 200 ms] --> R3[add]
    end
    subgraph Machine["State machine per request"]
        M1[machine 1] -.->|callback| P[pool thread]
        M2[machine 2] -.->|callback| P
        M3[machine N] -.->|callback| P
        TM[one timer] -->|fires| P
    end
```

Left side: N threads, N stacks, N things for the OS to juggle, all asleep. Right side: N small objects on the heap, one timer, and a pool thread that wakes up for microseconds per request.

## What this chapter sets up

The rest of the course is how you build the right-hand side without a compiler that knows `await`. You need:

1. A way to hand out "the answer is coming" and let one party fill it in later. Chapter 2.
2. A way to cut a method in half at the wait and resume it later. Chapter 3.
3. A protocol between the two. Chapter 4.
4. A way to carry per-request data across the cut. Chapter 5.

Then we run the numbers in chapter 6 and cheat with iterators in chapter 7.
