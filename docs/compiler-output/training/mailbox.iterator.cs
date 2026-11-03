using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Runtime.CompilerServices;
using System.Threading;

namespace MMP.AsyncProxy.Training.Mailbox.Async
{
	public sealed class IteratorClerk<T> : IClerk, IDisposable
	{
		[CompilerGenerated]
		private sealed class <>c__DisplayClass17_0
		{
			public ManualResetEvent done;

			internal void <Dispose>b__0()
			{
				done.Set();
			}
		}

		[CompilerGenerated]
		private sealed class <Loop>d__14 : IEnumerable<IFuture>, IEnumerable, IEnumerator<IFuture>, IDisposable, IEnumerator
		{
			private int <>1__state;

			private IFuture <>2__current;

			private int <>l__initialThreadId;

			public IteratorClerk<T> <>4__this;

			private IFuture<T> <next>5__2;

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
			public <Loop>d__14(int <>1__state)
			{
				this.<>1__state = <>1__state;
				<>l__initialThreadId = Thread.CurrentThread.ManagedThreadId;
			}

			[DebuggerHidden]
			void IDisposable.Dispose()
			{
				<next>5__2 = null;
				<>1__state = -2;
			}

			private bool MoveNext()
			{
				int num = <>1__state;
				IteratorClerk<T> iteratorClerk = <>4__this;
				T slip;
				if (num != 0)
				{
					if (num != 1)
					{
						return false;
					}
					<>1__state = -1;
					if (<next>5__2.IsCanceled || <next>5__2.IsFaulted || iteratorClerk._stopping)
					{
						return false;
					}
					slip = <next>5__2.Result;
					<next>5__2 = null;
					goto IL_009d;
				}
				<>1__state = -1;
				goto IL_00a4;
				IL_00a4:
				if (!iteratorClerk._stopping)
				{
					if (!iteratorClerk._tray.TryTake(out slip))
					{
						<next>5__2 = iteratorClerk._tray.TakeAsync();
						<>2__current = Futures.Observe(<next>5__2);
						<>1__state = 1;
						return true;
					}
					goto IL_009d;
				}
				return false;
				IL_009d:
				iteratorClerk.Handle(slip);
				goto IL_00a4;
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
				<Loop>d__14 <Loop>d__15;
				if (<>1__state == -2 && <>l__initialThreadId == Thread.CurrentThread.ManagedThreadId)
				{
					<>1__state = 0;
					<Loop>d__15 = this;
				}
				else
				{
					<Loop>d__15 = new <Loop>d__14(0);
					<Loop>d__15.<>4__this = <>4__this;
				}
				return <Loop>d__15;
			}

			[DebuggerHidden]
			IEnumerator IEnumerable.GetEnumerator()
			{
				return ((IEnumerable<IFuture>)this).GetEnumerator();
			}
		}

		private readonly string _name;

		private readonly PromiseInTray<T> _tray;

		private readonly Action<T> _handle;

		private readonly IFuture _loop;

		private volatile bool _stopping;

		private int _handled;

		private int _busy;

		public string Name
		{
			get
			{
				return _name;
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
				return Thread.VolatileRead(ref _handled);
			}
		}

		public IteratorClerk(string name, PromiseInTray<T> tray, Action<T> handle)
		{
			_name = name;
			_tray = tray;
			_handle = handle;
			_loop = AsyncProxy.Run(Loop());
		}

		private IEnumerable<IFuture> Loop()
		{
			<Loop>d__14 obj = new <Loop>d__14(-2);
			obj.<>4__this = this;
			return obj;
		}

		private void Handle(T slip)
		{
			Interlocked.Exchange(ref _busy, 1);
			try
			{
				_handle(slip);
			}
			catch (Exception)
			{
			}
			finally
			{
				Interlocked.Increment(ref _handled);
				_tray.Handled();
				Interlocked.Exchange(ref _busy, 0);
			}
		}

		public bool WaitUntilIdle(int timeoutMs)
		{
			DateTime dateTime = DateTime.UtcNow.AddMilliseconds(timeoutMs);
			while (_tray.Pending > 0 || Thread.VolatileRead(ref _busy) == 1)
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
			_stopping = true;
			_tray.Close();
			<>c__DisplayClass17_0 <>c__DisplayClass17_1 = new <>c__DisplayClass17_0();
			<>c__DisplayClass17_1.done = new ManualResetEvent(false);
			try
			{
				_loop.ContinueOnAnyThread().OnCompleted(new Action(<>c__DisplayClass17_1.<Dispose>b__0));
				<>c__DisplayClass17_1.done.WaitOne(2000);
			}
			finally
			{
				if (<>c__DisplayClass17_1.done != null)
				{
					((IDisposable)<>c__DisplayClass17_1.done).Dispose();
				}
			}
		}
	}
}
You are not using the latest version of the tool, please update.
Latest version is '11.2.0.10050' (yours is '10.0.1.8346')
