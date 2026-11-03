# 05. The crunch: when the work is CPU, not waiting

Built after slice 5. This is the first project where the plain thread is the right tool, and the async versions are here to show why. The story and the pictures are in [chapter 11](../../docs/course/11-when-threads-win.md). This page is the project: the job, the three versions, the tests, and how to run it.

## The job

Close the day at a fuel station. Every sale gets **sealed**: hashed with SHA-256, `rounds` times in a row, so the bench has measurable CPU work. Then add up the money, in total and per grade. Twenty thousand sales on a busy station.

Every version does the same sealing loop (`Ledger.SealRange`) and has to return the same answer as one plain loop on one thread: same count, same money, same checksum. The checksum is every seal combined with XOR, which doesn't depend on order, so four threads and one thread can agree.

While a version works, a **heartbeat** ticks every 20 ms on a timer. It stands in for the pulser. After each tick it records how late the tick was. Late ticks are the cost a version puts on everything else in the process.

## The three versions

| Version | Class | How it works | Where the work runs |
|---|---|---|---|
| `threaded` | `Threaded/CrewSettler.cs` | A crew of threads it makes itself, one fewer than the cores by default, at `BelowNormal` priority. Each takes every crew-th record and keeps its own `Tally`. | Its own threads. Never the pool. |
| `async-loop` | `Async/LoopSettler.cs` | One state machine. Each 500-record chunk goes to `Futures.Run`, then `yield return` until it is back, then the next. | The pool, one chunk at a time. |
| `async-pool` | `Async/PoolFanOutSettler.cs` | One chunk per core, all sent to `Futures.Run` at once, then one `WhenAll`. | The pool, every worker, all at once. |

The contract and the shared pieces are in `Contract/ISettler.cs` (the sale record, `Ledger.Seal`, `Tally`, `Settlement`) and `Contract/Heartbeat.cs`.

## What it shows

Measured on a 4-core Linux container, .NET 10, 20,000 sales, 300 rounds, 2026-11-02:

```
version      elapsed ms  peak threads   worst late  average late     ok
one loop           3602             -            -             -    yes
async-loop         3489            17         7 ms          0 ms    yes
async-pool         1026            17       885 ms        111 ms    yes
threaded           1361            20         3 ms          0 ms    yes
```

- `async-loop` is no faster than one plain loop. Async doesn't speed up CPU work.
- `async-pool` is the fastest and the one that wrecks the heartbeat: its worst tick was 885 ms late.
- `threaded` is a fifth to a third slower, because it leaves a core free on purpose, and its worst tick was 3 ms late.

Across three runs, `async-pool` was 1,026 to 1,108 ms with a worst tick of 751 to 885 ms late; `threaded` was 1,204 to 1,425 ms with a worst tick of 3 ms every time.

## The tests

`training/MMP.AsyncProxy.Training.Tests/Crunch/`. Twelve test cases, some run once per version:

- every version gets the same answer as one plain loop, for a full day and for a day shorter than the crew (three versions each);
- the crew seals on threads of its own and never on a pool thread (`Settlement.RanOnPoolThreads` is false, `ThreadsUsed` is the crew size);
- both async versions do their sealing on borrowed pool threads;
- the loop only ever has one chunk in flight, so it cannot beat one plain loop by much;
- two crew threads beat one when there are two cores;
- the heartbeat stays on time while the crew works.

The bad case, a late heartbeat under the fan-out, is in the bench and not in a test, because how late depends on the machine's core count and a test should not hang on that.

## Run it

```
dotnet test training/MMP.AsyncProxy.Training.Tests -f net10.0 --filter "FullyQualifiedName~Crunch"
dotnet run --project training/MMP.AsyncProxy.Training.Bench -c Release -f net10.0 -- crunch            # 20,000 sales, 300 rounds
dotnet run --project training/MMP.AsyncProxy.Training.Bench -c Release -f net10.0 -- crunch 2000 300   # a short day
```

Run the bench alone, in a quiet process, and read the **worst late** column first.

## One limit

The container is Linux, which mostly ignores thread priority for ordinary programs. So the numbers above come from leaving a core free, not from `BelowNormal`. The priority part is what protects the pulser on a one-core Windows CE board, and it is not measured here.
