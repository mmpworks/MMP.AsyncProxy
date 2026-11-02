using System;
using System.Diagnostics;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
using System.Threading.Tasks;
using MMP.AsyncProxy.Training.FanOut;

namespace MMP.AsyncProxy.Training.Modern.FanOut
{
	[NullableContext(1)]
	[Nullable(0)]
	public sealed class TaskCourier : ICourier, IDisposable
	{
		[StructLayout(LayoutKind.Auto)]
		[CompilerGenerated]
		private struct <Ask>d__4 : IAsyncStateMachine
		{
			public int <>1__state;

			[Nullable(0)]
			public AsyncTaskMethodBuilder<string> <>t__builder;

			[Nullable(0)]
			public PostOffice office;

			[Nullable(0)]
			public string address;

			private ConfiguredTaskAwaitable.ConfiguredTaskAwaiter <>u__1;

			private void MoveNext()
			{
				int num = <>1__state;
				string result;
				try
				{
					ConfiguredTaskAwaitable.ConfiguredTaskAwaiter awaiter;
					if (num != 0)
					{
						awaiter = Task.Delay(office.DelayMs).ConfigureAwait(false).GetAwaiter();
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
						<>u__1 = default(ConfiguredTaskAwaitable.ConfiguredTaskAwaiter);
						num = (<>1__state = -1);
					}
					awaiter.GetResult();
					result = office.Answer(address);
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
		private struct <Gather>d__3 : IAsyncStateMachine
		{
			public int <>1__state;

			[Nullable(new byte[] { 0, 0, 1 })]
			public AsyncTaskMethodBuilder<Reply[]> <>t__builder;

			[Nullable(0)]
			public PostOffice office;

			[Nullable(new byte[] { 0, 1 })]
			public string[] addresses;

			[Nullable(0)]
			private Task<string>[] <letters>5__2;

			[Nullable(new byte[] { 0, 1, 0 })]
			private ConfiguredTaskAwaitable<string[]>.ConfiguredTaskAwaiter <>u__1;

			private void MoveNext()
			{
				int num = <>1__state;
				Reply[] result;
				try
				{
					if (num != 0)
					{
						PostOffice office = this.office;
						<letters>5__2 = addresses.Select([NullableContext(0)] (string a) => Ask(a, office)).ToArray();
					}
					try
					{
						ConfiguredTaskAwaitable<string[]>.ConfiguredTaskAwaiter awaiter;
						if (num != 0)
						{
							awaiter = Task.WhenAll(<letters>5__2).ConfigureAwait(false).GetAwaiter();
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
							<>u__1 = default(ConfiguredTaskAwaitable<string[]>.ConfiguredTaskAwaiter);
							num = (<>1__state = -1);
						}
						awaiter.GetResult();
					}
					catch (Exception)
					{
					}
					Reply[] array = new Reply[addresses.Length];
					for (int num2 = 0; num2 < addresses.Length; num2++)
					{
						Task<string> task = <letters>5__2[num2];
						array[num2] = (task.IsFaulted ? new Reply(addresses[num2], null, task.Exception.InnerException ?? task.Exception) : new Reply(addresses[num2], task.Result, null));
					}
					result = array;
				}
				catch (Exception exception)
				{
					<>1__state = -2;
					<letters>5__2 = null;
					<>t__builder.SetException(exception);
					return;
				}
				<>1__state = -2;
				<letters>5__2 = null;
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

		public Reply[] SendAll(string[] addresses, PostOffice office)
		{
			return Gather(addresses, office).GetAwaiter().GetResult();
		}

		[AsyncStateMachine(typeof(<Gather>d__3))]
		private static Task<Reply[]> Gather(string[] addresses, PostOffice office)
		{
			<Gather>d__3 stateMachine = default(<Gather>d__3);
			stateMachine.<>t__builder = AsyncTaskMethodBuilder<Reply[]>.Create();
			stateMachine.addresses = addresses;
			stateMachine.office = office;
			stateMachine.<>1__state = -1;
			stateMachine.<>t__builder.Start(ref stateMachine);
			return stateMachine.<>t__builder.Task;
		}

		[AsyncStateMachine(typeof(<Ask>d__4))]
		private static Task<string> Ask(string address, PostOffice office)
		{
			<Ask>d__4 stateMachine = default(<Ask>d__4);
			stateMachine.<>t__builder = AsyncTaskMethodBuilder<string>.Create();
			stateMachine.address = address;
			stateMachine.office = office;
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
