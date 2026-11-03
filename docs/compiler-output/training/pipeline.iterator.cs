using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Runtime.CompilerServices;
using System.Threading;

namespace MMP.AsyncProxy.Training.Pipeline.Async
{
	public sealed class IteratorLine : IAssemblyLine, IDisposable
	{
		[CompilerGenerated]
		private sealed class <EnrichStage>d__4 : IEnumerable<IFuture>, IEnumerable, IEnumerator<IFuture>, IDisposable, IEnumerator
		{
			private int <>1__state;

			private IFuture <>2__current;

			private int <>l__initialThreadId;

			private PromiseTray<int> behind;

			public PromiseTray<int> <>3__behind;

			private List<int> dropped;

			public List<int> <>3__dropped;

			private InFlightMeter meter;

			public InFlightMeter <>3__meter;

			private PromiseTray<int> ahead;

			public PromiseTray<int> <>3__ahead;

			private IFuture<int> <next>5__2;

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
			public <EnrichStage>d__4(int <>1__state)
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
				int item;
				int item2;
				switch (<>1__state)
				{
				default:
					return false;
				case 0:
					<>1__state = -1;
					goto IL_0022;
				case 1:
					<>1__state = -1;
					if (!<next>5__2.IsCanceled)
					{
						item = <next>5__2.Result;
						<next>5__2 = null;
						goto IL_0084;
					}
					ahead.Close();
					return false;
				case 2:
					{
						<>1__state = -1;
						goto IL_0022;
					}
					IL_0084:
					try
					{
						item2 = Stages.Enrich(item);
					}
					catch (InvalidOperationException)
					{
						dropped.Add(item);
						meter.Left();
						goto IL_0022;
					}
					if (!ahead.TryPut(item2))
					{
						<>2__current = ahead.PutAsync(item2);
						<>1__state = 2;
						return true;
					}
					goto IL_0022;
					IL_0022:
					if (!behind.TryTake(out item))
					{
						<next>5__2 = behind.TakeAsync();
						<>2__current = Futures.Observe(<next>5__2);
						<>1__state = 1;
						return true;
					}
					goto IL_0084;
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
				<EnrichStage>d__4 <EnrichStage>d__5;
				if (<>1__state == -2 && <>l__initialThreadId == Thread.CurrentThread.ManagedThreadId)
				{
					<>1__state = 0;
					<EnrichStage>d__5 = this;
				}
				else
				{
					<EnrichStage>d__5 = new <EnrichStage>d__4(0);
				}
				<EnrichStage>d__5.behind = <>3__behind;
				<EnrichStage>d__5.ahead = <>3__ahead;
				<EnrichStage>d__5.dropped = <>3__dropped;
				<EnrichStage>d__5.meter = <>3__meter;
				return <EnrichStage>d__5;
			}

			[DebuggerHidden]
			IEnumerator IEnumerable.GetEnumerator()
			{
				return ((IEnumerable<IFuture>)this).GetEnumerator();
			}
		}

		[CompilerGenerated]
		private sealed class <ParseStage>d__3 : IEnumerable<IFuture>, IEnumerable, IEnumerator<IFuture>, IDisposable, IEnumerator
		{
			private int <>1__state;

			private IFuture <>2__current;

			private int <>l__initialThreadId;

			private int[] inputs;

			public int[] <>3__inputs;

			private InFlightMeter meter;

			public InFlightMeter <>3__meter;

			private PromiseTray<int> ahead;

			public PromiseTray<int> <>3__ahead;

			private int[] <>7__wrap1;

			private int <>7__wrap2;

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
			public <ParseStage>d__3(int <>1__state)
			{
				this.<>1__state = <>1__state;
				<>l__initialThreadId = Thread.CurrentThread.ManagedThreadId;
			}

			[DebuggerHidden]
			void IDisposable.Dispose()
			{
				<>7__wrap1 = null;
				<>1__state = -2;
			}

			private bool MoveNext()
			{
				int num = <>1__state;
				if (num != 0)
				{
					if (num != 1)
					{
						return false;
					}
					<>1__state = -1;
					goto IL_007a;
				}
				<>1__state = -1;
				<>7__wrap1 = inputs;
				<>7__wrap2 = 0;
				goto IL_0088;
				IL_007a:
				<>7__wrap2++;
				goto IL_0088;
				IL_0088:
				if (<>7__wrap2 < <>7__wrap1.Length)
				{
					int x = <>7__wrap1[<>7__wrap2];
					meter.Entered();
					int item = Stages.Parse(x);
					if (!ahead.TryPut(item))
					{
						<>2__current = ahead.PutAsync(item);
						<>1__state = 1;
						return true;
					}
					goto IL_007a;
				}
				<>7__wrap1 = null;
				ahead.Close();
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
				<ParseStage>d__3 <ParseStage>d__4;
				if (<>1__state == -2 && <>l__initialThreadId == Thread.CurrentThread.ManagedThreadId)
				{
					<>1__state = 0;
					<ParseStage>d__4 = this;
				}
				else
				{
					<ParseStage>d__4 = new <ParseStage>d__3(0);
				}
				<ParseStage>d__4.inputs = <>3__inputs;
				<ParseStage>d__4.ahead = <>3__ahead;
				<ParseStage>d__4.meter = <>3__meter;
				return <ParseStage>d__4;
			}

			[DebuggerHidden]
			IEnumerator IEnumerable.GetEnumerator()
			{
				return ((IEnumerable<IFuture>)this).GetEnumerator();
			}
		}

		[CompilerGenerated]
		private sealed class <WriteStage>d__5 : IEnumerable<IFuture>, IEnumerable, IEnumerator<IFuture>, IDisposable, IEnumerator
		{
			private int <>1__state;

			private IFuture <>2__current;

			private int <>l__initialThreadId;

			private PromiseTray<int> behind;

			public PromiseTray<int> <>3__behind;

			private int writeDelayMs;

			public int <>3__writeDelayMs;

			private List<int> outputs;

			public List<int> <>3__outputs;

			private InFlightMeter meter;

			public InFlightMeter <>3__meter;

			private int <x>5__2;

			private IFuture<int> <next>5__3;

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
			public <WriteStage>d__5(int <>1__state)
			{
				this.<>1__state = <>1__state;
				<>l__initialThreadId = Thread.CurrentThread.ManagedThreadId;
			}

			[DebuggerHidden]
			void IDisposable.Dispose()
			{
				<next>5__3 = null;
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
					goto IL_0022;
				case 1:
					<>1__state = -1;
					if (!<next>5__3.IsCanceled)
					{
						<x>5__2 = <next>5__3.Result;
						<next>5__3 = null;
						goto IL_008c;
					}
					return false;
				case 2:
					{
						<>1__state = -1;
						goto IL_00b6;
					}
					IL_008c:
					if (writeDelayMs > 0)
					{
						<>2__current = Futures.Delay(writeDelayMs);
						<>1__state = 2;
						return true;
					}
					goto IL_00b6;
					IL_0022:
					if (!behind.TryTake(out <x>5__2))
					{
						<next>5__3 = behind.TakeAsync();
						<>2__current = Futures.Observe(<next>5__3);
						<>1__state = 1;
						return true;
					}
					goto IL_008c;
					IL_00b6:
					outputs.Add(<x>5__2);
					meter.Left();
					goto IL_0022;
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
				<WriteStage>d__5 <WriteStage>d__6;
				if (<>1__state == -2 && <>l__initialThreadId == Thread.CurrentThread.ManagedThreadId)
				{
					<>1__state = 0;
					<WriteStage>d__6 = this;
				}
				else
				{
					<WriteStage>d__6 = new <WriteStage>d__5(0);
				}
				<WriteStage>d__6.behind = <>3__behind;
				<WriteStage>d__6.outputs = <>3__outputs;
				<WriteStage>d__6.writeDelayMs = <>3__writeDelayMs;
				<WriteStage>d__6.meter = <>3__meter;
				return <WriteStage>d__6;
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

		public LineResult Run(int[] inputs, int trayCapacity, int writeDelayMs)
		{
			PromiseTray<int> promiseTray = new PromiseTray<int>(trayCapacity);
			PromiseTray<int> promiseTray2 = new PromiseTray<int>(trayCapacity);
			List<int> list = new List<int>(inputs.Length);
			List<int> list2 = new List<int>();
			InFlightMeter inFlightMeter = new InFlightMeter();
			AsyncProxy.Run(ParseStage(inputs, promiseTray, inFlightMeter));
			AsyncProxy.Run(EnrichStage(promiseTray, promiseTray2, list2, inFlightMeter));
			AsyncProxy.Run(WriteStage(promiseTray2, list, writeDelayMs, inFlightMeter)).Wait();
			return new LineResult(list.ToArray(), list2.ToArray(), inFlightMeter.Peak);
		}

		private static IEnumerable<IFuture> ParseStage(int[] inputs, PromiseTray<int> ahead, InFlightMeter meter)
		{
			<ParseStage>d__3 obj = new <ParseStage>d__3(-2);
			obj.<>3__inputs = inputs;
			obj.<>3__ahead = ahead;
			obj.<>3__meter = meter;
			return obj;
		}

		private static IEnumerable<IFuture> EnrichStage(PromiseTray<int> behind, PromiseTray<int> ahead, List<int> dropped, InFlightMeter meter)
		{
			<EnrichStage>d__4 obj = new <EnrichStage>d__4(-2);
			obj.<>3__behind = behind;
			obj.<>3__ahead = ahead;
			obj.<>3__dropped = dropped;
			obj.<>3__meter = meter;
			return obj;
		}

		private static IEnumerable<IFuture> WriteStage(PromiseTray<int> behind, List<int> outputs, int writeDelayMs, InFlightMeter meter)
		{
			<WriteStage>d__5 obj = new <WriteStage>d__5(-2);
			obj.<>3__behind = behind;
			obj.<>3__outputs = outputs;
			obj.<>3__writeDelayMs = writeDelayMs;
			obj.<>3__meter = meter;
			return obj;
		}

		public void Dispose()
		{
		}
	}
}
You are not using the latest version of the tool, please update.
Latest version is '11.2.0.10050' (yours is '10.0.1.8346')
