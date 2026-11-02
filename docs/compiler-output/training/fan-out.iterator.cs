using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Runtime.CompilerServices;
using System.Threading;

namespace MMP.AsyncProxy.Training.FanOut
{
	public sealed class WhenAllCourier : ICourier, IDisposable
	{
		[CompilerGenerated]
		private sealed class <>c__DisplayClass2_0
		{
			public string[] addresses;

			public PostOffice office;

			internal IEnumerable<IFuture> <SendAll>b__0(Return<Reply[]> ret)
			{
				return Gather(addresses, office, ret);
			}
		}

		[CompilerGenerated]
		private sealed class <Gather>d__3 : IEnumerable<IFuture>, IEnumerable, IEnumerator<IFuture>, IDisposable, IEnumerator
		{
			private int <>1__state;

			private IFuture <>2__current;

			private int <>l__initialThreadId;

			private string[] addresses;

			public string[] <>3__addresses;

			private PostOffice office;

			public PostOffice <>3__office;

			private Return<Reply[]> ret;

			public Return<Reply[]> <>3__ret;

			private IFuture<string>[] <letters>5__2;

			IFuture IEnumerator<IFuture>.Current
			{
				[DebuggerHidden]
				get
				{
					return <>2__current;
				}
			}

			object IEnumerator.Current
			{
				[DebuggerHidden]
				get
				{
					return <>2__current;
				}
			}

			[DebuggerHidden]
			public <Gather>d__3(int <>1__state)
			{
				this.<>1__state = <>1__state;
				<>l__initialThreadId = Thread.CurrentThread.ManagedThreadId;
			}

			[DebuggerHidden]
			void IDisposable.Dispose()
			{
				<letters>5__2 = null;
				<>1__state = -2;
			}

			private bool MoveNext()
			{
				switch (<>1__state)
				{
				default:
					return false;
				case 0:
				{
					<>1__state = -1;
					<letters>5__2 = new IFuture<string>[addresses.Length];
					for (int j = 0; j < addresses.Length; j++)
					{
						<letters>5__2[j] = office.AskAsync(addresses[j]);
					}
					IFuture[] futures = <letters>5__2;
					<>2__current = Futures.Observe(Futures.WhenAll(futures));
					<>1__state = 1;
					return true;
				}
				case 1:
				{
					<>1__state = -1;
					Reply[] array = new Reply[addresses.Length];
					for (int i = 0; i < addresses.Length; i++)
					{
						IFuture<string> future = <letters>5__2[i];
						array[i] = (future.IsFaulted ? new Reply(addresses[i], null, future.Exception) : new Reply(addresses[i], future.Result, null));
					}
					ret.Value = array;
					return false;
				}
				}
			}

			bool IEnumerator.MoveNext()
			{
				//ILSpy generated this explicit interface implementation from .override directive in MoveNext
				return this.MoveNext();
			}

			[DebuggerHidden]
			void IEnumerator.Reset()
			{
				throw new NotSupportedException();
			}

			[DebuggerHidden]
			IEnumerator<IFuture> IEnumerable<IFuture>.GetEnumerator()
			{
				<Gather>d__3 <Gather>d__4;
				if (<>1__state == -2 && <>l__initialThreadId == Thread.CurrentThread.ManagedThreadId)
				{
					<>1__state = 0;
					<Gather>d__4 = this;
				}
				else
				{
					<Gather>d__4 = new <Gather>d__3(0);
				}
				<Gather>d__4.addresses = <>3__addresses;
				<Gather>d__4.office = <>3__office;
				<Gather>d__4.ret = <>3__ret;
				return <Gather>d__4;
			}

			[DebuggerHidden]
			IEnumerator IEnumerable.GetEnumerator()
			{
				return ((IEnumerable<IFuture>)this).GetEnumerator();
			}
		}

		public string Version
		{
			get
			{
				return "asyncproxy";
			}
		}

		public Reply[] SendAll(string[] addresses, PostOffice office)
		{
			<>c__DisplayClass2_0 obj = new <>c__DisplayClass2_0();
			obj.addresses = addresses;
			obj.office = office;
			return AsyncProxy.Run(new Func<Return<Reply[]>, IEnumerable<IFuture>>(obj.<SendAll>b__0)).Result;
		}

		private static IEnumerable<IFuture> Gather(string[] addresses, PostOffice office, Return<Reply[]> ret)
		{
			<Gather>d__3 obj = new <Gather>d__3(-2);
			obj.<>3__addresses = addresses;
			obj.<>3__office = office;
			obj.<>3__ret = ret;
			return obj;
		}

		public void Dispose()
		{
		}
	}
}
You are not using the latest version of the tool, please update.
Latest version is '11.2.0.10050' (yours is '10.0.1.8346')
