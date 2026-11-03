# 06. The printer: when a device owns a thread

Built after slice 5. The second project where the thread is not a cost to get rid of. The story and the pictures are in [chapter 11](../../docs/course/11-when-threads-win.md). This page is the project.

## The job

A receipt printer whose driver may only be called from the thread that opened it. Real ones are like this: a single-threaded COM object, a USB SDK, a graphics context. The stand-in, `ReceiptPrinter`, throws `WrongThreadException` on a call from any other thread, and counts it.

A job prints some receipts in order and waits `feedMs` after each one for the paper to advance. Jobs can arrive from any thread, several at a time.

## The versions

| Version | Class | How it works |
|---|---|---|
| `threaded` | `Threaded/OwnerThreadDesk.cs` | One `OwnerThread` opens the driver. Each job runs as one block on it, sleeping through every paper feed. A second job waits for the whole first one. |
| `async-postback` | `Async/PostBackDesk.cs` | The job is a state machine started on the owner thread, so each wait captures the owner thread's `SynchronizationContext`. When the timer fires the rest of the machine is posted back to the owner thread. While the paper feeds, the owner thread serves other jobs. |
| `async-naive` | `Async/NaiveDesk.cs` | The mistake, kept on purpose. The machine starts on the caller's thread and never goes back, so every call is refused: the first from the caller's thread, and the rest from pool threads. |

`Support/OwnerThread.cs` is the thread-with-a-line-of-jobs that is also a `SynchronizationContext`. It is the only new piece of machinery, and it is not specific to printers.

## What it shows

Eight jobs at once, five receipts each, a 40 ms paper feed after each (one job alone is about 200 ms). 4-core Linux container, .NET 10, 2026-11-02:

```
version          elapsed ms  printed   rejected  driver threads
threaded               1613       40          0               1
async-postback          215       40          0               1
async-naive             203        0         40              13
```

- `threaded` is correct and serial: eight jobs at about 200 ms each.
- `async-postback` is correct and overlapped: about one job's time, because the owner thread isn't asleep during the paper feeds.
- `async-naive` is the fastest and prints nothing.

The thread did not go away in `async-postback`. The device insists on it. Async only changed what the thread does while it waits.

## The tests

`training/MMP.AsyncProxy.Training.Tests/Printer/`. Nine of them:

- each correct version prints every receipt in order, and from the owner thread only;
- three jobs at once all finish, the driver is called from exactly one thread, and each job's receipts stay in their own order;
- in the threaded desk a second job's first receipt prints after the first job's last one;
- in the post-back desk it prints before it (the owner thread was free during the paper feeds), with no driver refusals;
- the naive desk is refused by the driver, with the message that says which thread opened it.

The callers are given threads of their own (`TaskCreationOptions.LongRunning`). Callers that block on the pool would park its workers, and the async desk needs the pool for its timers. The first draft of the bench made that mistake and measured 4,558 ms for `async-postback` instead of 215.

## Run it

```
dotnet test training/MMP.AsyncProxy.Training.Tests -f net10.0 --filter "FullyQualifiedName~Printer"
dotnet run --project training/MMP.AsyncProxy.Training.Bench -c Release -f net10.0 -- printer 8
```
