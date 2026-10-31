# 8. Exercises

Each one is a small change to the repo. Build, run the tests, see what moved. Answers are not here on purpose; the tests are the answers.

## 1. Add a third await

Take `AddAfterDelayMachine` and add a third `Futures.Delay` before the return. You need a new `case 2`, a new `Resume2` label, and a new parked state. Count how many places you touched. That count is why we let the compiler do this.

## 2. Break the fast path

In `AddAfterDelayMachine.MoveNext`, delete the `if (!awaiter.IsCompleted)` check and always park. Run `Hand_written_machine_with_zero_delay_completes_synchronously`. It fails. Work out why the zero-delay case now completes on a different thread than the caller, and what a UI program would notice.

## 3. Lose the lock

In `Promise<T>.RegisterContinuation`, remove the `lock`. Write a test that completes the promise from one thread while another registers a continuation, in a tight loop, a thousand times. Count how many continuations never ran. Put the lock back.

## 4. Run continuations inside the lock

In `Promise<T>.Complete`, move the `foreach (toRun)` inside the `lock`. Write a continuation that completes a second promise whose continuation completes the first promise's sibling. Find the deadlock. Move it back out.

## 5. Make a Delay that starves

Replace `Futures.Delay` with a version that does `Futures.Run(() => Thread.Sleep(ms))`. Run the comparison console. Row 3 now behaves like row 2. Explain, in one sentence, where the thread went.

## 6. Carry a value the wrong way

In `ReadTenantAfterDelay`, replace `CallContext.LogicalSetData` with a `[ThreadStatic]` field. Run `ExecutionContext_flows_across_the_await`. It fails, or it passes by luck. Run it twenty times. Explain which thread the value was on each time.

## 7. Write WhenAny

`Futures.WhenAll` is in `Futures.cs`. Write `WhenAny(params IFuture[] futures)` that completes with the first one to finish. You need a flag that only the first callback flips. `Interlocked.CompareExchange` is your friend. Write a test where two delays race.

## 8. Write Observe

Chapter 7 said you cannot catch a step's fault inside an iterator body. Write `Futures.Observe(IFuture f)` that returns a future which always succeeds once `f` completes, so the body can yield it and then inspect `f.IsFaulted` by hand. Add a test where a body recovers from a failed step.

## 9. Decompile the real thing

Make a tiny net48 project with a real `async Task<int>` version of `AddAfterDelayAsync`. Build it in Release. Run `ilspycmd` on the dll. Find the generated struct. Put it beside `AddAfterDelayMachine.cs` and label each field with its match. The repo's `docs/compiler-vs-handwritten.md` is waiting for that table.

## 10. Make it a struct

The real compiler emits a struct machine in Release. Turn `AddAfterDelayMachine` into a struct. `Builder.Start(ref machine)` still works. `Builder.AwaitOnCompleted(ref awaiter, ref self)` with `var self = this;` now copies the struct, and the copy gets the callback while the original holds the state. Watch the test hang. Then implement `SetStateMachine` properly so the builder boxes once and reuses the box. That is the last piece of the real design, and you will understand why it exists the moment it bites you.
