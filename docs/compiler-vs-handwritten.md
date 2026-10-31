# The compiler's machine beside ours

Same method, two authors. The C# compiler wrote the left column. We wrote the right one in C# 3, in `samples/MMP.AsyncProxy.Samples/AddAfterDelay.cs`. This page puts them side by side so you can check the claim that they are the same shape.

How the left column was made: `samples/MMP.AsyncProxy.CompilerReference/AddAfterDelayReal.cs` holds a real `async Task<int>` method. Built in Release, decompiled with `ilspycmd -lv CSharp4` (C# 4 has no `await`, so ILSpy cannot sugar the machine back up). The full output is in `AddAfterDelayReal.decompiled.cs` next to this file. `tools/decompile.ps1` regenerates it. Decompiled 2026-10-31 with ilspycmd 10.0.1.

## The mapping

| Compiler emits | We wrote | Notes |
|---|---|---|
| `struct <RunAsync>d__0 : IAsyncStateMachine` | `class AddAfterDelayMachine : IAsyncStateMachine` | Struct in Release to skip an allocation on the synchronous path. See "where they differ". |
| `int <>1__state` | `int State` | -1 running, -2 done, 0 and 1 parked at await 0 and 1. Same values. |
| `AsyncTaskMethodBuilder<int> <>t__builder` | `AsyncMethodBuilder<int> Builder` | Same four calls: Create, Start, AwaitOnCompleted, SetResult/SetException. |
| `int a; int b; int delayMs;` | `int A; int B; int DelayMs;` | Parameters hoisted to public fields. |
| `int <sum>5__2` | `int _sum` | The one local that crosses an await. `5__2` is the compiler's slot number. |
| `TaskAwaiter <>u__1` | `IAwaiter _awaiter` | One awaiter field, reused by both awaits, since only one is pending at a time. |
| `if (num != 0) { if (num == 1) ... goto IL_00ee; }` | `switch (State) { case 0: goto Resume0; case 1: goto Resume1; }` | The dispatch. The compiler nests ifs; we used a switch. Same jump table. |
| `awaiter = <>u__1; <>u__1 = default; num = (<>1__state = -1);` | `awaiter = _awaiter; _awaiter = null; State = -1;` | Pull the saved awaiter back into a local and clear the field, on resume. |
| `if (!awaiter.IsCompleted) { state = 0; <>u__1 = awaiter; builder.AwaitUnsafeOnCompleted(ref awaiter, ref this); return; }` | `if (!awaiter.IsCompleted) { State = 0; _awaiter = awaiter; var self = this; Builder.AwaitOnCompleted(ref awaiter, ref self); return; }` | The suspend. `Unsafe` means the builder skips ExecutionContext capture because `TaskAwaiter` already flows it. Ours captures in the builder. Same net effect. |
| `awaiter.GetResult();` | `awaiter.GetResult();` | On resume. Throws the fault if there was one. |
| `catch (Exception) { state = -2; builder.SetException(e); return; }` | same | Nothing escapes MoveNext. |
| `state = -2; builder.SetResult(result);` | same | The happy exit. |
| `stateMachine.<>t__builder.Start(ref stateMachine); return stateMachine.<>t__builder.Task;` | `machine.Builder.Start(ref machine); return machine.Builder.Future;` | The public stub. |
| `SetStateMachine(sm) => <>t__builder.SetStateMachine(sm)` | empty | Only matters for a struct machine. See below. |

## Where they differ, and why it does not change the idea

1. **Struct versus class.** In Release the compiler emits a struct so an async method that never suspends allocates nothing. On the first real suspend the builder boxes the struct and keeps the box; `SetStateMachine` is how the box learns about itself. Ours is a class, always one allocation, and `SetStateMachine` has nothing to do. Exercise 10 in the course walks you through making ours a struct and watching why `SetStateMachine` exists.
2. **`AwaitUnsafeOnCompleted` versus `AwaitOnCompleted`.** The real `TaskAwaiter` flows ExecutionContext itself, so the compiler calls the "unsafe" builder method that skips a second capture. Our awaiter does not flow it, so our builder does. One capture either way.
3. **`ref this` versus `var self = this; ref self`.** A struct can pass `ref this`. A class cannot, so we copy the reference to a local first. The builder receives the same object.
4. **Nested `if` versus `switch`.** The compiler's dispatch for two states is two `if`s. At three or more it emits a `switch`. Ours is a `switch` from the start. Same control flow.
5. **Names.** `<>1__state`, `<>t__builder`, `<sum>5__2`, `<>u__1` are unspeakable on purpose so your code cannot collide with them. Ours are readable because you are meant to read them.

## The compiler's output

From `AddAfterDelayReal.decompiled.cs`, lines 48 to 159:

```csharp
	public static class AddAfterDelayReal
	{
		[StructLayout(LayoutKind.Auto)]
		[CompilerGenerated]
		private struct <RunAsync>d__0 : IAsyncStateMachine
		{
			public int <>1__state;

			public AsyncTaskMethodBuilder<int> <>t__builder;

			public int delayMs;

			public int a;

			public int b;

			private int <sum>5__2;

			private TaskAwaiter <>u__1;

			private void MoveNext()
			{
				int num = <>1__state;
				int result;
				try
				{
					TaskAwaiter awaiter;
					if (num != 0)
					{
						if (num == 1)
						{
							awaiter = <>u__1;
							<>u__1 = default(TaskAwaiter);
							num = (<>1__state = -1);
							goto IL_00ee;
						}
						awaiter = Task.Delay(delayMs).GetAwaiter();
						if (!awaiter.IsCompleted)
						{
							num = (<>1__state = 0);
							<>u__1 = awaiter;
							<>t__builder.AwaitUnsafeOnCompleted(ref awaiter, ref this);
							return;
						}
					}
					else
					{
						awaiter = <>u__1;
						<>u__1 = default(TaskAwaiter);
						num = (<>1__state = -1);
					}
					awaiter.GetResult();
					if (a < 0)
					{
						throw new ArgumentOutOfRangeException("a");
					}
					<sum>5__2 = a + b;
					awaiter = Task.Delay(delayMs).GetAwaiter();
					if (!awaiter.IsCompleted)
					{
						num = (<>1__state = 1);
						<>u__1 = awaiter;
						<>t__builder.AwaitUnsafeOnCompleted(ref awaiter, ref this);
						return;
					}
					goto IL_00ee;
					IL_00ee:
					awaiter.GetResult();
					result = <sum>5__2 * 2;
				}
				catch (Exception exception)
				{
					<>1__state = -2;
					<>t__builder.SetException(exception);
					return;
				}
				<>1__state = -2;
				<>t__builder.SetResult(result);
			}

			void IAsyncStateMachine.MoveNext()
			{
				//ILSpy generated this explicit interface implementation from .override directive in MoveNext
				this.MoveNext();
			}

			[DebuggerHidden]
			private void SetStateMachine(IAsyncStateMachine stateMachine)
			{
				<>t__builder.SetStateMachine(stateMachine);
			}

			void IAsyncStateMachine.SetStateMachine(IAsyncStateMachine stateMachine)
			{
				//ILSpy generated this explicit interface implementation from .override directive in SetStateMachine
				this.SetStateMachine(stateMachine);
			}
		}

		[AsyncStateMachine(typeof(<RunAsync>d__0))]
		public static Task<int> RunAsync(int a, int b, int delayMs)
		{
			<RunAsync>d__0 stateMachine = default(<RunAsync>d__0);
			stateMachine.<>t__builder = AsyncTaskMethodBuilder<int>.Create();
			stateMachine.a = a;
			stateMachine.b = b;
			stateMachine.delayMs = delayMs;
			stateMachine.<>1__state = -1;
			stateMachine.<>t__builder.Start(ref stateMachine);
			return stateMachine.<>t__builder.Task;
		}
	}
```

## Ours

`samples/MMP.AsyncProxy.Samples/AddAfterDelay.cs`, in full, with comments. Open it beside the block above. Walk the table one row at a time.
