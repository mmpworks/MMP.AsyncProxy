using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Runtime.CompilerServices;
using System.Runtime.ExceptionServices;
using System.Runtime.InteropServices;
using System.Threading.Channels;
using System.Threading.Tasks;
using MMP.AsyncProxy.Training.Pipeline;

namespace MMP.AsyncProxy.Training.Modern.Pipeline
{
	[NullableContext(1)]
	[Nullable(0)]
	public sealed class ChannelLine : IAssemblyLine, IDisposable
	{
		[StructLayout(LayoutKind.Auto)]
		[CompilerGenerated]
		private struct <EnrichStage>d__4 : IAsyncStateMachine
		{
			public int <>1__state;

			public AsyncTaskMethodBuilder <>t__builder;

			[Nullable(0)]
			public ChannelReader<int> behind;

			[Nullable(0)]
			public List<int> dropped;

			[Nullable(0)]
			public InFlightMeter meter;

			[Nullable(0)]
			public ChannelWriter<int> ahead;

			[Nullable(0)]
			private ConfiguredCancelableAsyncEnumerable<int>.Enumerator <>7__wrap1;

			[Nullable(0)]
			private object <>7__wrap2;

			private int <>7__wrap3;

			private ConfiguredValueTaskAwaitable.ConfiguredValueTaskAwaiter <>u__1;

			[Nullable(0)]
			private ConfiguredValueTaskAwaitable<bool>.ConfiguredValueTaskAwaiter <>u__2;

			private void MoveNext()
			{
				int num = <>1__state;
				try
				{
					ConfiguredValueTaskAwaitable.ConfiguredValueTaskAwaiter awaiter;
					if ((uint)num > 1u)
					{
						if (num == 2)
						{
							awaiter = <>u__1;
							<>u__1 = default(ConfiguredValueTaskAwaitable.ConfiguredValueTaskAwaiter);
							num = (<>1__state = -1);
							goto IL_01e1;
						}
						<>7__wrap1 = behind.ReadAllAsync().ConfigureAwait(false).GetAsyncEnumerator();
						<>7__wrap2 = null;
						<>7__wrap3 = 0;
					}
					try
					{
						ConfiguredValueTaskAwaitable<bool>.ConfiguredValueTaskAwaiter awaiter2;
						if (num != 0)
						{
							if (num != 1)
							{
								goto IL_0107;
							}
							awaiter2 = <>u__2;
							<>u__2 = default(ConfiguredValueTaskAwaitable<bool>.ConfiguredValueTaskAwaiter);
							num = (<>1__state = -1);
							goto IL_0167;
						}
						awaiter = <>u__1;
						<>u__1 = default(ConfiguredValueTaskAwaitable.ConfiguredValueTaskAwaiter);
						num = (<>1__state = -1);
						goto IL_0100;
						IL_0167:
						if (awaiter2.GetResult())
						{
							int current = <>7__wrap1.Current;
							int item;
							try
							{
								item = Stages.Enrich(current);
							}
							catch (InvalidOperationException)
							{
								dropped.Add(current);
								meter.Left();
								goto IL_0107;
							}
							awaiter = ahead.WriteAsync(item).ConfigureAwait(false).GetAwaiter();
							if (!awaiter.IsCompleted)
							{
								num = (<>1__state = 0);
								<>u__1 = awaiter;
								<>t__builder.AwaitUnsafeOnCompleted(ref awaiter, ref this);
								return;
							}
							goto IL_0100;
						}
						goto end_IL_0049;
						IL_0107:
						awaiter2 = <>7__wrap1.MoveNextAsync().GetAwaiter();
						if (!awaiter2.IsCompleted)
						{
							num = (<>1__state = 1);
							<>u__2 = awaiter2;
							<>t__builder.AwaitUnsafeOnCompleted(ref awaiter2, ref this);
							return;
						}
						goto IL_0167;
						IL_0100:
						awaiter.GetResult();
						goto IL_0107;
						end_IL_0049:;
					}
					catch (object obj)
					{
						<>7__wrap2 = obj;
					}
					awaiter = <>7__wrap1.DisposeAsync().GetAwaiter();
					if (!awaiter.IsCompleted)
					{
						num = (<>1__state = 2);
						<>u__1 = awaiter;
						<>t__builder.AwaitUnsafeOnCompleted(ref awaiter, ref this);
						return;
					}
					goto IL_01e1;
					IL_01e1:
					awaiter.GetResult();
					object obj2 = <>7__wrap2;
					if (obj2 != null)
					{
						Exception obj3 = obj2 as Exception;
						if (obj3 == null)
						{
							throw obj2;
						}
						ExceptionDispatchInfo.Capture(obj3).Throw();
					}
					<>7__wrap2 = null;
					<>7__wrap1 = default(ConfiguredCancelableAsyncEnumerable<int>.Enumerator);
					ahead.Complete();
				}
				catch (Exception exception)
				{
					<>1__state = -2;
					<>t__builder.SetException(exception);
					return;
				}
				<>1__state = -2;
				<>t__builder.SetResult();
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
		private struct <ParseStage>d__3 : IAsyncStateMachine
		{
			public int <>1__state;

			public AsyncTaskMethodBuilder <>t__builder;

			[Nullable(0)]
			public int[] inputs;

			[Nullable(0)]
			public InFlightMeter meter;

			[Nullable(0)]
			public ChannelWriter<int> ahead;

			[Nullable(0)]
			private int[] <>7__wrap1;

			private int <>7__wrap2;

			private ConfiguredValueTaskAwaitable.ConfiguredValueTaskAwaiter <>u__1;

			private void MoveNext()
			{
				int num = <>1__state;
				try
				{
					if (num != 0)
					{
						<>7__wrap1 = inputs;
						<>7__wrap2 = 0;
						goto IL_00c9;
					}
					ConfiguredValueTaskAwaitable.ConfiguredValueTaskAwaiter awaiter = <>u__1;
					<>u__1 = default(ConfiguredValueTaskAwaitable.ConfiguredValueTaskAwaiter);
					num = (<>1__state = -1);
					goto IL_00b4;
					IL_00b4:
					awaiter.GetResult();
					<>7__wrap2++;
					goto IL_00c9;
					IL_00c9:
					if (<>7__wrap2 < <>7__wrap1.Length)
					{
						int x = <>7__wrap1[<>7__wrap2];
						meter.Entered();
						awaiter = ahead.WriteAsync(Stages.Parse(x)).ConfigureAwait(false).GetAwaiter();
						if (!awaiter.IsCompleted)
						{
							num = (<>1__state = 0);
							<>u__1 = awaiter;
							<>t__builder.AwaitUnsafeOnCompleted(ref awaiter, ref this);
							return;
						}
						goto IL_00b4;
					}
					<>7__wrap1 = null;
					ahead.Complete();
				}
				catch (Exception exception)
				{
					<>1__state = -2;
					<>t__builder.SetException(exception);
					return;
				}
				<>1__state = -2;
				<>t__builder.SetResult();
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
		private struct <WriteStage>d__5 : IAsyncStateMachine
		{
			public int <>1__state;

			public AsyncTaskMethodBuilder <>t__builder;

			[Nullable(0)]
			public ChannelReader<int> behind;

			public int writeDelayMs;

			[Nullable(0)]
			public List<int> outputs;

			[Nullable(0)]
			public InFlightMeter meter;

			[Nullable(0)]
			private ConfiguredCancelableAsyncEnumerable<int>.Enumerator <>7__wrap1;

			[Nullable(0)]
			private object <>7__wrap2;

			private int <>7__wrap3;

			private int <x>5__5;

			private ConfiguredTaskAwaitable.ConfiguredTaskAwaiter <>u__1;

			[Nullable(0)]
			private ConfiguredValueTaskAwaitable<bool>.ConfiguredValueTaskAwaiter <>u__2;

			private ConfiguredValueTaskAwaitable.ConfiguredValueTaskAwaiter <>u__3;

			private void MoveNext()
			{
				int num = <>1__state;
				try
				{
					ConfiguredValueTaskAwaitable.ConfiguredValueTaskAwaiter awaiter;
					if ((uint)num > 1u)
					{
						if (num == 2)
						{
							awaiter = <>u__3;
							<>u__3 = default(ConfiguredValueTaskAwaitable.ConfiguredValueTaskAwaiter);
							num = (<>1__state = -1);
							goto IL_01d2;
						}
						<>7__wrap1 = behind.ReadAllAsync().ConfigureAwait(false).GetAsyncEnumerator();
						<>7__wrap2 = null;
						<>7__wrap3 = 0;
					}
					try
					{
						ConfiguredValueTaskAwaitable<bool>.ConfiguredValueTaskAwaiter awaiter2;
						if (num != 0)
						{
							if (num != 1)
							{
								goto IL_00f8;
							}
							awaiter2 = <>u__2;
							<>u__2 = default(ConfiguredValueTaskAwaitable<bool>.ConfiguredValueTaskAwaiter);
							num = (<>1__state = -1);
							goto IL_0158;
						}
						ConfiguredTaskAwaitable.ConfiguredTaskAwaiter awaiter3 = <>u__1;
						<>u__1 = default(ConfiguredTaskAwaitable.ConfiguredTaskAwaiter);
						num = (<>1__state = -1);
						goto IL_00d5;
						IL_00dc:
						outputs.Add(<x>5__5);
						meter.Left();
						goto IL_00f8;
						IL_0158:
						if (awaiter2.GetResult())
						{
							<x>5__5 = <>7__wrap1.Current;
							if (writeDelayMs > 0)
							{
								awaiter3 = Task.Delay(writeDelayMs).ConfigureAwait(false).GetAwaiter();
								if (!awaiter3.IsCompleted)
								{
									num = (<>1__state = 0);
									<>u__1 = awaiter3;
									<>t__builder.AwaitUnsafeOnCompleted(ref awaiter3, ref this);
									return;
								}
								goto IL_00d5;
							}
							goto IL_00dc;
						}
						goto end_IL_0049;
						IL_00d5:
						awaiter3.GetResult();
						goto IL_00dc;
						IL_00f8:
						awaiter2 = <>7__wrap1.MoveNextAsync().GetAwaiter();
						if (!awaiter2.IsCompleted)
						{
							num = (<>1__state = 1);
							<>u__2 = awaiter2;
							<>t__builder.AwaitUnsafeOnCompleted(ref awaiter2, ref this);
							return;
						}
						goto IL_0158;
						end_IL_0049:;
					}
					catch (object obj)
					{
						<>7__wrap2 = obj;
					}
					awaiter = <>7__wrap1.DisposeAsync().GetAwaiter();
					if (!awaiter.IsCompleted)
					{
						num = (<>1__state = 2);
						<>u__3 = awaiter;
						<>t__builder.AwaitUnsafeOnCompleted(ref awaiter, ref this);
						return;
					}
					goto IL_01d2;
					IL_01d2:
					awaiter.GetResult();
					object obj2 = <>7__wrap2;
					if (obj2 != null)
					{
						Exception obj3 = obj2 as Exception;
						if (obj3 == null)
						{
							throw obj2;
						}
						ExceptionDispatchInfo.Capture(obj3).Throw();
					}
					<>7__wrap2 = null;
					<>7__wrap1 = default(ConfiguredCancelableAsyncEnumerable<int>.Enumerator);
				}
				catch (Exception exception)
				{
					<>1__state = -2;
					<>t__builder.SetException(exception);
					return;
				}
				<>1__state = -2;
				<>t__builder.SetResult();
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

		public LineResult Run(int[] inputs, int trayCapacity, int writeDelayMs)
		{
			Channel<int> channel = Channel.CreateBounded<int>(new BoundedChannelOptions(trayCapacity)
			{
				SingleReader = true,
				SingleWriter = true
			});
			Channel<int> channel2 = Channel.CreateBounded<int>(new BoundedChannelOptions(trayCapacity)
			{
				SingleReader = true,
				SingleWriter = true
			});
			List<int> list = new List<int>(inputs.Length);
			List<int> list2 = new List<int>();
			InFlightMeter inFlightMeter = new InFlightMeter();
			ParseStage(inputs, channel.Writer, inFlightMeter);
			EnrichStage(channel.Reader, channel2.Writer, list2, inFlightMeter);
			WriteStage(channel2.Reader, list, writeDelayMs, inFlightMeter).GetAwaiter().GetResult();
			return new LineResult(list.ToArray(), list2.ToArray(), inFlightMeter.Peak);
		}

		[AsyncStateMachine(typeof(<ParseStage>d__3))]
		private static Task ParseStage(int[] inputs, ChannelWriter<int> ahead, InFlightMeter meter)
		{
			<ParseStage>d__3 stateMachine = default(<ParseStage>d__3);
			stateMachine.<>t__builder = AsyncTaskMethodBuilder.Create();
			stateMachine.inputs = inputs;
			stateMachine.ahead = ahead;
			stateMachine.meter = meter;
			stateMachine.<>1__state = -1;
			stateMachine.<>t__builder.Start(ref stateMachine);
			return stateMachine.<>t__builder.Task;
		}

		[AsyncStateMachine(typeof(<EnrichStage>d__4))]
		private static Task EnrichStage(ChannelReader<int> behind, ChannelWriter<int> ahead, List<int> dropped, InFlightMeter meter)
		{
			<EnrichStage>d__4 stateMachine = default(<EnrichStage>d__4);
			stateMachine.<>t__builder = AsyncTaskMethodBuilder.Create();
			stateMachine.behind = behind;
			stateMachine.ahead = ahead;
			stateMachine.dropped = dropped;
			stateMachine.meter = meter;
			stateMachine.<>1__state = -1;
			stateMachine.<>t__builder.Start(ref stateMachine);
			return stateMachine.<>t__builder.Task;
		}

		[AsyncStateMachine(typeof(<WriteStage>d__5))]
		private static Task WriteStage(ChannelReader<int> behind, List<int> outputs, int writeDelayMs, InFlightMeter meter)
		{
			<WriteStage>d__5 stateMachine = default(<WriteStage>d__5);
			stateMachine.<>t__builder = AsyncTaskMethodBuilder.Create();
			stateMachine.behind = behind;
			stateMachine.outputs = outputs;
			stateMachine.writeDelayMs = writeDelayMs;
			stateMachine.meter = meter;
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
