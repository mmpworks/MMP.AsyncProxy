# The training track: moving a threaded program onto MMP.AsyncProxy

Four small programs, each written twice in C# 3 for .NET 3.5: once the way a 2008 team wrote it, with threads, and once with this library. A third copy of each, in modern C# on .NET 10, exists so the machine we build by hand can be set beside the machine the modern compiler builds, down to the IL. One test suite runs every version through one contract. One bench prints the memory and speed table.

Read `docs/course/10-waiting-without-a-thread.md` first. It is the shape all four share, explained once.

| # | Project | The job | What the move teaches |
|---|---|---|---|
| 1 | [01-mailbox](01-mailbox/README.md) | A clerk and an in-tray: wait for a slip, handle it, wait again | What a worker holds while it waits |
| 2 | [02-fan-out](02-fan-out/README.md) | Send many requests at once and wait for all of them | A countdown of threads against `WhenAll` |
| 3 | [03-pipeline](03-pipeline/README.md) | Three stages with a bounded hand-off between each | Backpressure with and without a parked thread |
| 4 | [04-deadline](04-deadline/README.md) | A request with a time limit, retries, and a caller who can give up | Timeouts and cancellation as futures |

## The projects

| Project | Target | What it holds |
|---|---|---|
| `MMP.AsyncProxy.Training` | net35, netstandard2.0, C# 3 | The four jobs, each as a `Contract`, a `Threaded` version, and an `Async` version |
| `MMP.AsyncProxy.Training.Modern` | net10.0 | The four jobs with `async`/`await`, `Task`, `Channel`, `CancellationToken` |
| `MMP.AsyncProxy.Training.Tests` | net48, net10.0 | The contract tests. On net48 they load the net35 binaries. On net10 they also run the modern copies |
| `MMP.AsyncProxy.Training.Bench` | net48, net10.0 | The table: elapsed, peak threads, allocated bytes, peak working set |

## Run it

```
dotnet test training/MMP.AsyncProxy.Training.Tests
dotnet run --project training/MMP.AsyncProxy.Training.Bench -c Release -f net48
dotnet run --project training/MMP.AsyncProxy.Training.Bench -c Release -f net10.0
pwsh tools/decompile.ps1          # regenerates docs/compiler-output/, needs ilspycmd
```

## How to read a project

Each project folder has one README with the same eight sections: the job, the thread way, the AsyncProxy way, thread model against async model, the same machine in IL, memory and speed, CUPID and DRY and SOLID, and how to run it. The code is in the training assembly under the project's folder. The decompiled machines are under `docs/compiler-output/training/`.

The plan, the decisions, and the acceptance list are in `docs/prd-training.md`.
