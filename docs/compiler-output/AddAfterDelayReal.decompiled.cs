using System;
using System.Diagnostics;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
using System.Runtime.Versioning;
using System.Threading.Tasks;
using Microsoft.CodeAnalysis;

[assembly: CompilationRelaxations(8)]
[assembly: RuntimeCompatibility(WrapNonExceptionThrows = true)]
[assembly: Debuggable(DebuggableAttribute.DebuggingModes.IgnoreSymbolStoreSequencePoints)]
[assembly: TargetFramework(".NETFramework,Version=v4.8", FrameworkDisplayName = ".NET Framework 4.8")]
[assembly: AssemblyCompany("MMPWorks LLC")]
[assembly: AssemblyConfiguration("Release")]
[assembly: AssemblyFileVersion("1.0.0.0")]
[assembly: AssemblyInformationalVersion("1.0.0+78bc8b5be030f4ab22c80442379e745015a55861")]
[assembly: AssemblyProduct("MMP.AsyncProxy.CompilerReference")]
[assembly: AssemblyTitle("MMP.AsyncProxy.CompilerReference")]
[assembly: AssemblyMetadata("RepositoryUrl", "https://github.com/mmpworks/MMP.AsyncProxy")]
[assembly: AssemblyVersion("1.0.0.0")]
[module: RefSafetyRules(11)]
namespace Microsoft.CodeAnalysis
{
	[CompilerGenerated]
	[Embedded]
	internal sealed class EmbeddedAttribute : Attribute
	{
	}
}
namespace System.Runtime.CompilerServices
{
	[CompilerGenerated]
	[Embedded]
	[AttributeUsage(AttributeTargets.Module, AllowMultiple = false, Inherited = false)]
	internal sealed class RefSafetyRulesAttribute : Attribute
	{
		public readonly int Version;

		public RefSafetyRulesAttribute(int P_0)
		{
			Version = P_0;
		}
	}
}
namespace MMP.AsyncProxy.CompilerReference
{
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
}
