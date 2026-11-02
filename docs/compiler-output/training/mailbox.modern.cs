using System;
using System.Diagnostics;
using System.Runtime.CompilerServices;
using System.Runtime.ExceptionServices;
using System.Runtime.InteropServices;
using System.Threading;
using System.Threading.Tasks;
using MMP.AsyncProxy.Training.Mailbox;

namespace MMP.AsyncProxy.Training.Modern.Mailbox
{
	[NullableContext(1)]
	[Nullable(0)]
	public sealed class ChannelClerk<[Nullable(2)] T> : IClerk, IDisposable
	{
		[StructLayout(LayoutKind.Auto)]
		[CompilerGenerated]
		private struct <Loop>d__12 : IAsyncStateMachine
		{
			public int <>1__state;

			public AsyncTaskMethodBuilder <>t__builder;

			[Nullable(new byte[] { 0, 1 })]
			public ChannelInTray<T> tray;

			[Nullable(0)]
			public ChannelClerk<T> <>4__this;

			[Nullable(new byte[] { 0, 1 })]
			public Action<T> handle;

			[Nullable(0)]
			private ConfiguredCancelableAsyncEnumerable<T>.Enumerator <>7__wrap1;

			[Nullable(0)]
			private object <>7__wrap2;

			private int <>7__wrap3;

			[Nullable(0)]
			private ConfiguredValueTaskAwaitable<bool>.ConfiguredValueTaskAwaiter <>u__1;

			private ConfiguredValueTaskAwaitable.ConfiguredValueTaskAwaiter <>u__2;

			private void MoveNext()
			{
				int num = <>1__state;
				ChannelClerk<T> channelClerk = <>4__this;
				try
				{
					ConfiguredValueTaskAwaitable.ConfiguredValueTaskAwaiter awaiter;
					if (num != 0)
					{
						if (num == 1)
						{
							awaiter = <>u__2;
							<>u__2 = default(ConfiguredValueTaskAwaitable.ConfiguredValueTaskAwaiter);
							num = (<>1__state = -1);
							goto IL_0192;
						}
						<>7__wrap1 = tray.Channel.Reader.ReadAllAsync().ConfigureAwait(false).GetAsyncEnumerator();
						<>7__wrap2 = null;
						<>7__wrap3 = 0;
					}
					try
					{
						if (num != 0)
						{
							goto IL_00b8;
						}
						ConfiguredValueTaskAwaitable<bool>.ConfiguredValueTaskAwaiter awaiter2 = <>u__1;
						<>u__1 = default(ConfiguredValueTaskAwaitable<bool>.ConfiguredValueTaskAwaiter);
						num = (<>1__state = -1);
						goto IL_0118;
						IL_0118:
						if (awaiter2.GetResult())
						{
							T current = <>7__wrap1.Current;
							Interlocked.Exchange(ref channelClerk._busy, 1);
							try
							{
								handle(current);
							}
							catch (Exception)
							{
							}
							finally
							{
								if (num < 0)
								{
									Interlocked.Increment(ref channelClerk._handled);
									tray.Handled();
									Interlocked.Exchange(ref channelClerk._busy, 0);
								}
							}
							goto IL_00b8;
						}
						goto end_IL_0059;
						IL_00b8:
						awaiter2 = <>7__wrap1.MoveNextAsync().GetAwaiter();
						if (!awaiter2.IsCompleted)
						{
							num = (<>1__state = 0);
							<>u__1 = awaiter2;
							<>t__builder.AwaitUnsafeOnCompleted(ref awaiter2, ref this);
							return;
						}
						goto IL_0118;
						end_IL_0059:;
					}
					catch (object obj)
					{
						<>7__wrap2 = obj;
					}
					awaiter = <>7__wrap1.DisposeAsync().GetAwaiter();
					if (!awaiter.IsCompleted)
					{
						num = (<>1__state = 1);
						<>u__2 = awaiter;
						<>t__builder.AwaitUnsafeOnCompleted(ref awaiter, ref this);
						return;
					}
					goto IL_0192;
					IL_0192:
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
					<>7__wrap1 = default(ConfiguredCancelableAsyncEnumerable<T>.Enumerator);
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

		private readonly ChannelInTray<T> _tray;

		private readonly Task _loop;

		private int _handled;

		private int _busy;

		[CompilerGenerated]
		private readonly string <Name>k__BackingField;

		public string Name
		{
			[CompilerGenerated]
			get
			{
				return <Name>k__BackingField;
			}
		}

		public bool IsRunning
		{
			get
			{
				return !_loop.IsCompleted;
			}
		}

		public int Handled
		{
			get
			{
				return Volatile.Read(ref _handled);
			}
		}

		public ChannelClerk(string name, ChannelInTray<T> tray, Action<T> handle)
		{
			<Name>k__BackingField = name;
			_tray = tray;
			_loop = Loop(tray, handle);
		}

		[AsyncStateMachine(typeof(ChannelClerk<>.<Loop>d__12))]
		private Task Loop(ChannelInTray<T> tray, Action<T> handle)
		{
			<Loop>d__12 stateMachine = default(<Loop>d__12);
			stateMachine.<>t__builder = AsyncTaskMethodBuilder.Create();
			stateMachine.<>4__this = this;
			stateMachine.tray = tray;
			stateMachine.handle = handle;
			stateMachine.<>1__state = -1;
			stateMachine.<>t__builder.Start(ref stateMachine);
			return stateMachine.<>t__builder.Task;
		}

		public bool WaitUntilIdle(int timeoutMs)
		{
			DateTime dateTime = DateTime.UtcNow.AddMilliseconds(timeoutMs);
			while (_tray.Pending > 0 || Volatile.Read(ref _busy) == 1)
			{
				if (DateTime.UtcNow >= dateTime)
				{
					return false;
				}
				Thread.Sleep(1);
			}
			return true;
		}

		public void Dispose()
		{
			_tray.Close();
			_loop.Wait(TimeSpan.FromSeconds(2L));
		}
	}
}
You are not using the latest version of the tool, please update.
Latest version is '11.2.0.10050' (yours is '10.0.1.8346')
