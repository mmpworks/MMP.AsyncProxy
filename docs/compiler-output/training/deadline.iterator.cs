using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Runtime.CompilerServices;
using System.Threading;

namespace MMP.AsyncProxy.Training.Deadline.Async
{
	public sealed class WhenAnyCaller : IDeadlineCaller, IDisposable
	{
		[CompilerGenerated]
		private sealed class <>c__DisplayClass2_0
		{
			public FlakyService service;

			public int timeoutMs;

			public int maxAttempts;

			public CancelSource cord;

			internal IEnumerable<IFuture> <Call>b__0(Return<CallResult> ret)
			{
				return Attempts(service, timeoutMs, maxAttempts, cord.Token, ret);
			}
		}

		[CompilerGenerated]
		private sealed class <Attempts>d__3 : IEnumerable<IFuture>, IEnumerable, IEnumerator<IFuture>, IDisposable, IEnumerator
		{
			private int <>1__state;

			private IFuture <>2__current;

			private int <>l__initialThreadId;

			private CancelToken cord;

			public CancelToken <>3__cord;

			private Return<CallResult> ret;

			public Return<CallResult> <>3__ret;

			private FlakyService service;

			public FlakyService <>3__service;

			private int timeoutMs;

			public int <>3__timeoutMs;

			private int maxAttempts;

			public int <>3__maxAttempts;

			private int <attempt>5__2;

			private IFuture<string> <answer>5__3;

			private IFuture<IFuture> <first>5__4;

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
			public <Attempts>d__3(int <>1__state)
			{
				this.<>1__state = <>1__state;
				<>l__initialThreadId = Thread.CurrentThread.ManagedThreadId;
			}

			[DebuggerHidden]
			void IDisposable.Dispose()
			{
				<answer>5__3 = null;
				<first>5__4 = null;
				<>1__state = -2;
			}

			private bool MoveNext()
			{
				switch (<>1__state)
				{
				default:
					return false;
				case 0:
					<>1__state = -1;
					<attempt>5__2 = 0;
					break;
				case 1:
					<>1__state = -1;
					if (<first>5__4.Result == <answer>5__3)
					{
						ret.Value = new CallResult(CallOutcome.Answered, <answer>5__3.Result, <attempt>5__2 + 1);
						return false;
					}
					if (cord.IsCancelRequested)
					{
						ret.Value = new CallResult(CallOutcome.Cancelled, null, <attempt>5__2 + 1);
						return false;
					}
					<answer>5__3 = null;
					<first>5__4 = null;
					<attempt>5__2++;
					break;
				}
				if (<attempt>5__2 < maxAttempts)
				{
					if (cord.IsCancelRequested)
					{
						ret.Value = new CallResult(CallOutcome.Cancelled, null, <attempt>5__2);
						return false;
					}
					<answer>5__3 = service.AskAsync(<attempt>5__2);
					IFuture future = Futures.Delay(timeoutMs, cord);
					<first>5__4 = Futures.WhenAny(<answer>5__3, future);
					<>2__current = <first>5__4;
					<>1__state = 1;
					return true;
				}
				ret.Value = new CallResult(CallOutcome.GaveUp, null, maxAttempts);
				return false;
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
				<Attempts>d__3 <Attempts>d__4;
				if (<>1__state == -2 && <>l__initialThreadId == Thread.CurrentThread.ManagedThreadId)
				{
					<>1__state = 0;
					<Attempts>d__4 = this;
				}
				else
				{
					<Attempts>d__4 = new <Attempts>d__3(0);
				}
				<Attempts>d__4.service = <>3__service;
				<Attempts>d__4.timeoutMs = <>3__timeoutMs;
				<Attempts>d__4.maxAttempts = <>3__maxAttempts;
				<Attempts>d__4.cord = <>3__cord;
				<Attempts>d__4.ret = <>3__ret;
				return <Attempts>d__4;
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

		public CallResult Call(FlakyService service, int timeoutMs, int maxAttempts, GiveUp giveUp)
		{
			<>c__DisplayClass2_0 <>c__DisplayClass2_1 = new <>c__DisplayClass2_0();
			<>c__DisplayClass2_1.service = service;
			<>c__DisplayClass2_1.timeoutMs = timeoutMs;
			<>c__DisplayClass2_1.maxAttempts = maxAttempts;
			<>c__DisplayClass2_1.cord = new CancelSource();
			giveUp.OnFired(new Action(<>c__DisplayClass2_1.cord.Cancel));
			return AsyncProxy.Run(new Func<Return<CallResult>, IEnumerable<IFuture>>(<>c__DisplayClass2_1.<Call>b__0)).Result;
		}

		private static IEnumerable<IFuture> Attempts(FlakyService service, int timeoutMs, int maxAttempts, CancelToken cord, Return<CallResult> ret)
		{
			<Attempts>d__3 obj = new <Attempts>d__3(-2);
			obj.<>3__service = service;
			obj.<>3__timeoutMs = timeoutMs;
			obj.<>3__maxAttempts = maxAttempts;
			obj.<>3__cord = cord;
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
