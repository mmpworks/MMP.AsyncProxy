# 5. Context rides along

## At the table

"Here's one that's going to bite me," Kevin said. "I keep the current sale in a static. `CurrentSale`. The pulser thread sets it when the valve opens, the display thread reads it to draw the gallons. If my pulser loop wakes up on a pool thread now..."

"Is the static thread-static?"

"No. Plain static, with a lock."

"Then you're fine, it's one static and the lock is doing its job. The one that bites is `[ThreadStatic]`. People use it as a cheap per-request bag. The request starts on thread A, sets the tenant, awaits, wakes up on thread B, and thread B's copy of the field is whatever the last request that used thread B left there. You're reading somebody else's card number."

"We don't do that."

"You don't do that yet. The guy before you didn't have pool threads to tempt him. Here's the rule, and it's older than `await`: once your code can wake up on any thread, anything tied to a thread is a bug. Two fixes. Carry it in the object you're already passing around, the sale. Or put it in the bag that travels, which on the desktop is `ExecutionContext`, and the builder captures it at the wait and restores it before `MoveNext`."

"Does CE have that bag?"

Steve shook his head. "Compact Framework doesn't ship `ExecutionContext`. I pulled the 3.5 assemblies and looked. So on your box, the bag is off the table, and you do the first fix. Which is the better fix anyway. The sale object already has the sale id in it. Pass the sale."

"And the display thread? It's the one thread I'm keeping. It owns the LCD."

"That one gets the other context. `SynchronizationContext`. It's how a continuation says, run me back on the thread that owns the controls. WinForms sets one up on the UI thread on the desktop. In 4.5 the switch for it is `ConfigureAwait`. Here it's `ContinueOnAnyThread`, and your pulser loop should use it, because the pulser loop has no business bouncing to the display thread to compare two numbers."

"Does CE have that one?"

"No. Same look, same answer. CF 3.5 has neither context. So the port gets a small interface of its own, one method, post this to my thread, and your display loop implements it with a queue it drains. The awaiter captures that instead. It's the one design decision in the port, and it's written down in `docs/netcf-port.md` with the rest of what the assemblies do and don't have."

"Two contexts."

"Two contexts, two jobs, one table. Next page."

Chapter 4 ended on "the method wakes up on a different thread." That raises a question any real system has to answer: what happened to the stuff that was on the old thread?

## The problem

Say a web request sets a tenant id in a thread-static before it starts work:

```csharp
[ThreadStatic] static string CurrentTenant;
```

Then it awaits something, and the continuation runs on pool thread 7. Thread 7's `CurrentTenant` is whatever the last request that used thread 7 left there. You are now reading another customer's account number. Toub shows this bug live at 15:55.

Thread-static is the wrong tool once the thread is not yours.

## ExecutionContext: the bag that travels

.NET has had the fix since 2.0. `ExecutionContext` is a bag of ambient state that is captured as an object and restored later, on any thread. `CallContext.LogicalSetData` writes into it. Security context and culture ride in it too. In .NET 4.6 `AsyncLocal<T>` is the friendly front door; in 3.5 you use `CallContext` directly.

The builder does the carrying:

```csharp
public void AwaitOnCompleted<TAwaiter, TStateMachine>(ref TAwaiter awaiter, ref TStateMachine stateMachine)
{
    IAsyncStateMachine machine = stateMachine;
    ExecutionContext captured = ExecutionContext.Capture();   // snapshot, here, now
    awaiter.OnCompleted(delegate
    {
        ExecutionContext.Run(captured, delegate { machine.MoveNext(); }, null);   // restore, there, later
    });
}
```

Capture at the await. Restore right before `MoveNext`. Whatever thread runs the continuation, the method sees the same logical values it saw before it suspended. The test `ExecutionContext_flows_across_the_await` proves it: set a value, await a timer, read it back on the pool thread, same value.

Toub spends 13:44 to 20:27 on this and it is worth the time. The key sentence: ExecutionContext is captured at queue time and restored at run time, which is why the data follows the work and never the thread.

## SynchronizationContext: the thread that matters

There is one case where you do want to go back to a specific thread. UI frameworks. WinForms and WPF have one thread that owns the controls, and touching a control from any other thread throws.

That thread has a `SynchronizationContext.Current`. `Post` on it says "run this on my thread, when you get to it." Our awaiter captures it:

```csharp
public void OnCompleted(Action continuation)
{
    SynchronizationContext context = _continueOnCapturedContext ? SynchronizationContext.Current : null;
    if (context == null) { _promise.RegisterContinuation(continuation); return; }
    _promise.RegisterContinuation(delegate { context.Post(delegate { continuation(); }, null); });
}
```

On a UI thread, the continuation gets posted back to the UI thread. On a pool thread or a console, `Current` is null and the continuation runs wherever the completion happened.

## ConfigureAwait(false), under its real name

That `_continueOnCapturedContext` flag is the whole of `ConfigureAwait(false)`. We named ours `ContinueOnAnyThread()` because that is what it does. Library code should use it: a library has no business bouncing back to the UI thread for work the UI never sees, and doing so is how you deadlock a `.Result` call on a UI thread.

`Futures.WhenAll` uses it internally for that reason. The caller's own await on the result decides whether to go back to the UI.

## Two contexts, two jobs

| | ExecutionContext | SynchronizationContext |
|---|---|---|
| Carries | ambient data (tenant, trace id, culture) | "which thread should run this" |
| Captured by | the builder, at `AwaitOnCompleted` | the awaiter, at `OnCompleted` |
| Restored by | `ExecutionContext.Run` around `MoveNext` | `context.Post(...)` |
| Turn off with | `ExecutionContext.SuppressFlow()` | `ContinueOnAnyThread()` |
| Real name | same | `ConfigureAwait(false)` |

Both ride along by default. Both can be switched off. Neither one is magic; both are a capture at one point and a restore at another, which is the same move the state machine makes with its locals.

## The picture

```mermaid
flowchart TB
    subgraph Before["Thread A, at the await"]
        D1[CallContext: tenant=acme]
        S1[SyncContext: UI]
        AW[awaiter.OnCompleted]
    end
    CAP[captured = ExecutionContext.Capture<br/>ctx = SynchronizationContext.Current]
    subgraph After["Thread B, when the timer fires"]
        RUN[ExecutionContext.Run captured]
        POST[ctx.Post]
        MN[MoveNext sees tenant=acme<br/>and runs on the UI thread]
    end
    D1 --> CAP
    S1 --> CAP
    AW --> CAP
    CAP -.->|later| RUN --> POST --> MN
```

## The lesson that survives the course

Thread-static state is tied to a thread. Once your code can wake up on any thread, that tie is a bug. Either carry the value in the request object itself, or put it in the bag that travels. We have fixed a tenant leak in a logging pipeline this way: resolve the value on the producer side and carry it in the queued item. Same principle, any repo.
