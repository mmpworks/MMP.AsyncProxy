using System;
using System.Diagnostics;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
using System.Threading;
using System.Threading.Tasks;
using MMP.AsyncProxy.Training.Deadline;

namespace MMP.AsyncProxy.Training.Modern.Deadline
{
	[NullableContext(1)]
	[Nullable(0)]
	public sealed class TaskCaller : IDeadlineCaller, IDisposable
	{
		[StructLayout(LayoutKind.Auto)]
		[CompilerGenerated]
		private struct <Ask>d__4 : IAsyncStateMachine
		{
			public int <>1__state;

			[Nullable(0)]
			public AsyncTaskMethodBuilder<string> <>t__builder;

			[Nullable(0)]
			public FlakyService service;

			public int attempt;

			[Nullable(new byte[] { 0, 1 })]
			private ConfiguredTaskAwaitable<string>.ConfiguredTaskAwaiter <>u__1;

			private ConfiguredTaskAwaitable.ConfiguredTaskAwaiter <>u__2;

			private void MoveNext()
			{
				int num = <>1__state;
				string result;
				try
				{
					ConfiguredTaskAwaitable<string>.ConfiguredTaskAwaiter awaiter;
					if (num != 0)
					{
						ConfiguredTaskAwaitable.ConfiguredTaskAwaiter awaiter2;
						if (num != 1)
						{
							int num2 = service.DelayFor(attempt);
							if (num2 < 0)
							{
								awaiter = new TaskCompletionSource<string>().Task.ConfigureAwait(false).GetAwaiter();
								if (!awaiter.IsCompleted)
								{
									num = (<>1__state = 0);
									<>u__1 = awaiter;
									<>t__builder.AwaitUnsafeOnCompleted(ref awaiter, ref this);
									return;
								}
								goto IL_0089;
							}
							awaiter2 = Task.Delay(num2).ConfigureAwait(false).GetAwaiter();
							if (!awaiter2.IsCompleted)
							{
								num = (<>1__state = 1);
								<>u__2 = awaiter2;
								<>t__builder.AwaitUnsafeOnCompleted(ref awaiter2, ref this);
								return;
							}
						}
						else
						{
							awaiter2 = <>u__2;
							<>u__2 = default(ConfiguredTaskAwaitable.ConfiguredTaskAwaiter);
							num = (<>1__state = -1);
						}
						awaiter2.GetResult();
						goto IL_00f8;
					}
					awaiter = <>u__1;
					<>u__1 = default(ConfiguredTaskAwaitable<string>.ConfiguredTaskAwaiter);
					num = (<>1__state = -1);
					goto IL_0089;
					IL_0089:
					awaiter.GetResult();
					goto IL_00f8;
					IL_00f8:
					result = service.Answer(attempt);
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

		[StructLayout(LayoutKind.Auto)]
		[CompilerGenerated]
		private struct <Attempts>d__3 : IAsyncStateMachine
		{
			public int <>1__state;

			[Nullable(0)]
			public AsyncTaskMethodBuilder<CallResult> <>t__builder;

			public CancellationToken cord;

			[Nullable(0)]
			public FlakyService service;

			public int timeoutMs;

			public int maxAttempts;

			private int <attempt>5__2;

			[Nullable(new byte[] { 0, 1 })]
			private Task<string> <answer>5__3;

			[Nullable(new byte[] { 0, 1 })]
			private ConfiguredTaskAwaitable<Task>.ConfiguredTaskAwaiter <>u__1;

			private void MoveNext()
			{
				int num = <>1__state;
				CallResult result;
				try
				{
					if (num != 0)
					{
						<attempt>5__2 = 0;
						goto IL_0129;
					}
					ConfiguredTaskAwaitable<Task>.ConfiguredTaskAwaiter awaiter = <>u__1;
					<>u__1 = default(ConfiguredTaskAwaitable<Task>.ConfiguredTaskAwaiter);
					num = (<>1__state = -1);
					goto IL_00c6;
					IL_00c6:
					if (awaiter.GetResult() == <answer>5__3)
					{
						result = new CallResult(CallOutcome.Answered, <answer>5__3.Result, <attempt>5__2 + 1);
					}
					else
					{
						if (!cord.IsCancellationRequested)
						{
							<answer>5__3 = null;
							<attempt>5__2++;
							goto IL_0129;
						}
						result = new CallResult(CallOutcome.Cancelled, null, <attempt>5__2 + 1);
					}
					goto end_IL_0007;
					IL_0129:
					if (<attempt>5__2 < maxAttempts)
					{
						if (!cord.IsCancellationRequested)
						{
							<answer>5__3 = Ask(service, <attempt>5__2);
							Task task = Task.Delay(timeoutMs, cord);
							awaiter = Task.WhenAny(<answer>5__3, task).ConfigureAwait(false).GetAwaiter();
							if (!awaiter.IsCompleted)
							{
								num = (<>1__state = 0);
								<>u__1 = awaiter;
								<>t__builder.AwaitUnsafeOnCompleted(ref awaiter, ref this);
								return;
							}
							goto IL_00c6;
						}
						result = new CallResult(CallOutcome.Cancelled, null, <attempt>5__2);
					}
					else
					{
						result = new CallResult(CallOutcome.GaveUp, null, maxAttempts);
					}
					end_IL_0007:;
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

		public string Version
		{
			get
			{
				return "modern";
			}
		}

		public CallResult Call(FlakyService service, int timeoutMs, int maxAttempts, GiveUp giveUp)
		{
			CancellationTokenSource cancellationTokenSource = new CancellationTokenSource();
			giveUp.OnFired(cancellationTokenSource.Cancel);
			return Attempts(service, timeoutMs, maxAttempts, cancellationTokenSource.Token).GetAwaiter().GetResult();
		}

		[AsyncStateMachine(typeof(<Attempts>d__3))]
		private static Task<CallResult> Attempts(FlakyService service, int timeoutMs, int maxAttempts, CancellationToken cord)
		{
			<Attempts>d__3 stateMachine = default(<Attempts>d__3);
			stateMachine.<>t__builder = AsyncTaskMethodBuilder<CallResult>.Create();
			stateMachine.service = service;
			stateMachine.timeoutMs = timeoutMs;
			stateMachine.maxAttempts = maxAttempts;
			stateMachine.cord = cord;
			stateMachine.<>1__state = -1;
			stateMachine.<>t__builder.Start(ref stateMachine);
			return stateMachine.<>t__builder.Task;
		}

		[AsyncStateMachine(typeof(<Ask>d__4))]
		private static Task<string> Ask(FlakyService service, int attempt)
		{
			<Ask>d__4 stateMachine = default(<Ask>d__4);
			stateMachine.<>t__builder = AsyncTaskMethodBuilder<string>.Create();
			stateMachine.service = service;
			stateMachine.attempt = attempt;
			stateMachine.<>1__state = -1;
			stateMachine.<>t__builder.Start(ref stateMachine);
			return stateMachine.<>t__builder.Task;
		}

		public void Dispose()
		{
		}
	}
}
You are not using the latest version of the tool, please update.
Latest version is '11.2.0.10050' (yours is '10.0.1.8346')
