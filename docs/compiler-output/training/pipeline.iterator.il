// IL code: MMP.AsyncProxy.Training
.class private auto ansi '<Module>'
{
} // end of class <Module>

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Support.OwnerThread
	extends [mscorlib]System.Threading.SynchronizationContext
	implements [mscorlib]System.IDisposable
{
	// Nested Types
	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass10_0'
		extends [mscorlib]System.Object
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field public class [System.Core]System.Action job
		.field public class [mscorlib]System.Exception failure
		.field public class [mscorlib]System.Threading.ManualResetEvent done

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor () cil managed 
		{
			// Method begins at RVA 0x4654
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass10_0'::.ctor

		.method assembly hidebysig 
			instance void '<Invoke>b__0' () cil managed 
		{
			// Method begins at RVA 0x465c
			// Header size: 12
			// Code size: 37 (0x25)
			.maxstack 2
			.locals init (
				[0] class [mscorlib]System.Exception
			)

			.try
			{
				.try
				{
					IL_0000: ldarg.0
					IL_0001: ldfld class [System.Core]System.Action MMP.AsyncProxy.Training.Support.OwnerThread/'<>c__DisplayClass10_0'::job
					IL_0006: callvirt instance void [System.Core]System.Action::Invoke()
					IL_000b: leave.s IL_0024
				} // end .try
				catch [mscorlib]System.Exception
				{
					IL_000d: stloc.0
					IL_000e: ldarg.0
					IL_000f: ldloc.0
					IL_0010: stfld class [mscorlib]System.Exception MMP.AsyncProxy.Training.Support.OwnerThread/'<>c__DisplayClass10_0'::failure
					IL_0015: leave.s IL_0024
				} // end handler
			} // end .try
			finally
			{
				IL_0017: ldarg.0
				IL_0018: ldfld class [mscorlib]System.Threading.ManualResetEvent MMP.AsyncProxy.Training.Support.OwnerThread/'<>c__DisplayClass10_0'::done
				IL_001d: callvirt instance bool [mscorlib]System.Threading.EventWaitHandle::Set()
				IL_0022: pop
				IL_0023: endfinally
			} // end handler

			IL_0024: ret
		} // end of method '<>c__DisplayClass10_0'::'<Invoke>b__0'

	} // end of class <>c__DisplayClass10_0

	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass11_0'
		extends [mscorlib]System.Object
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field public class [mscorlib]System.Threading.SendOrPostCallback d
		.field public object state

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor () cil managed 
		{
			// Method begins at RVA 0x46ac
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass11_0'::.ctor

		.method assembly hidebysig 
			instance void '<Post>b__0' () cil managed 
		{
			// Method begins at RVA 0x46b4
			// Header size: 1
			// Code size: 18 (0x12)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [mscorlib]System.Threading.SendOrPostCallback MMP.AsyncProxy.Training.Support.OwnerThread/'<>c__DisplayClass11_0'::d
			IL_0006: ldarg.0
			IL_0007: ldfld object MMP.AsyncProxy.Training.Support.OwnerThread/'<>c__DisplayClass11_0'::state
			IL_000c: callvirt instance void [mscorlib]System.Threading.SendOrPostCallback::Invoke(object)
			IL_0011: ret
		} // end of method '<>c__DisplayClass11_0'::'<Post>b__0'

	} // end of class <>c__DisplayClass11_0


	// Fields
	.field private initonly object _gate
	.field private initonly class [System]System.Collections.Generic.Queue`1<class [System.Core]System.Action> _jobs
	.field private initonly class [mscorlib]System.Threading.Thread _thread
	.field private bool _stop

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			string name
		) cil managed 
	{
		// Method begins at RVA 0x2050
		// Header size: 12
		// Code size: 87 (0x57)
		.maxstack 3

		IL_0000: ldarg.0
		IL_0001: newobj instance void [mscorlib]System.Object::.ctor()
		IL_0006: stfld object MMP.AsyncProxy.Training.Support.OwnerThread::_gate
		IL_000b: ldarg.0
		IL_000c: newobj instance void class [System]System.Collections.Generic.Queue`1<class [System.Core]System.Action>::.ctor()
		IL_0011: stfld class [System]System.Collections.Generic.Queue`1<class [System.Core]System.Action> MMP.AsyncProxy.Training.Support.OwnerThread::_jobs
		IL_0016: ldarg.0
		IL_0017: call instance void [mscorlib]System.Threading.SynchronizationContext::.ctor()
		IL_001c: ldarg.0
		IL_001d: ldarg.0
		IL_001e: ldftn instance void MMP.AsyncProxy.Training.Support.OwnerThread::Pump()
		IL_0024: newobj instance void [mscorlib]System.Threading.ThreadStart::.ctor(object, native int)
		IL_0029: newobj instance void [mscorlib]System.Threading.Thread::.ctor(class [mscorlib]System.Threading.ThreadStart)
		IL_002e: stfld class [mscorlib]System.Threading.Thread MMP.AsyncProxy.Training.Support.OwnerThread::_thread
		IL_0033: ldarg.0
		IL_0034: ldfld class [mscorlib]System.Threading.Thread MMP.AsyncProxy.Training.Support.OwnerThread::_thread
		IL_0039: ldc.i4.1
		IL_003a: callvirt instance void [mscorlib]System.Threading.Thread::set_IsBackground(bool)
		IL_003f: ldarg.0
		IL_0040: ldfld class [mscorlib]System.Threading.Thread MMP.AsyncProxy.Training.Support.OwnerThread::_thread
		IL_0045: ldarg.1
		IL_0046: callvirt instance void [mscorlib]System.Threading.Thread::set_Name(string)
		IL_004b: ldarg.0
		IL_004c: ldfld class [mscorlib]System.Threading.Thread MMP.AsyncProxy.Training.Support.OwnerThread::_thread
		IL_0051: callvirt instance void [mscorlib]System.Threading.Thread::Start()
		IL_0056: ret
	} // end of method OwnerThread::.ctor

	.method public hidebysig specialname 
		instance int32 get_ThreadId () cil managed 
	{
		// Method begins at RVA 0x20b3
		// Header size: 1
		// Code size: 12 (0xc)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld class [mscorlib]System.Threading.Thread MMP.AsyncProxy.Training.Support.OwnerThread::_thread
		IL_0006: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
		IL_000b: ret
	} // end of method OwnerThread::get_ThreadId

	.method public hidebysig specialname 
		instance bool get_IsOwnerThread () cil managed 
	{
		// Method begins at RVA 0x20c0
		// Header size: 1
		// Code size: 14 (0xe)
		.maxstack 8

		IL_0000: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
		IL_0005: ldarg.0
		IL_0006: ldfld class [mscorlib]System.Threading.Thread MMP.AsyncProxy.Training.Support.OwnerThread::_thread
		IL_000b: ceq
		IL_000d: ret
	} // end of method OwnerThread::get_IsOwnerThread

	.method public hidebysig 
		instance void Enqueue (
			class [System.Core]System.Action job
		) cil managed 
	{
		// Method begins at RVA 0x20d0
		// Header size: 12
		// Code size: 65 (0x41)
		.maxstack 2
		.locals init (
			[0] object
		)

		IL_0000: ldarg.0
		IL_0001: ldfld object MMP.AsyncProxy.Training.Support.OwnerThread::_gate
		IL_0006: stloc.0
		IL_0007: ldloc.0
		IL_0008: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_000d: ldarg.0
			IL_000e: ldfld bool MMP.AsyncProxy.Training.Support.OwnerThread::_stop
			IL_0013: brfalse.s IL_0020

			IL_0015: ldstr "OwnerThread"
			IL_001a: newobj instance void [mscorlib]System.ObjectDisposedException::.ctor(string)
			IL_001f: throw

			IL_0020: ldarg.0
			IL_0021: ldfld class [System]System.Collections.Generic.Queue`1<class [System.Core]System.Action> MMP.AsyncProxy.Training.Support.OwnerThread::_jobs
			IL_0026: ldarg.1
			IL_0027: callvirt instance void class [System]System.Collections.Generic.Queue`1<class [System.Core]System.Action>::Enqueue(!0)
			IL_002c: ldarg.0
			IL_002d: ldfld object MMP.AsyncProxy.Training.Support.OwnerThread::_gate
			IL_0032: call void [mscorlib]System.Threading.Monitor::Pulse(object)
			IL_0037: leave.s IL_0040
		} // end .try
		finally
		{
			IL_0039: ldloc.0
			IL_003a: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_003f: endfinally
		} // end handler

		IL_0040: ret
	} // end of method OwnerThread::Enqueue

	.method public hidebysig 
		instance void Invoke (
			class [System.Core]System.Action job
		) cil managed 
	{
		// Method begins at RVA 0x2130
		// Header size: 12
		// Code size: 135 (0x87)
		.maxstack 3
		.locals init (
			[0] class MMP.AsyncProxy.Training.Support.OwnerThread/'<>c__DisplayClass10_0'
		)

		IL_0000: newobj instance void MMP.AsyncProxy.Training.Support.OwnerThread/'<>c__DisplayClass10_0'::.ctor()
		IL_0005: stloc.0
		IL_0006: ldloc.0
		IL_0007: ldarg.1
		IL_0008: stfld class [System.Core]System.Action MMP.AsyncProxy.Training.Support.OwnerThread/'<>c__DisplayClass10_0'::job
		IL_000d: ldarg.0
		IL_000e: call instance bool MMP.AsyncProxy.Training.Support.OwnerThread::get_IsOwnerThread()
		IL_0013: brfalse.s IL_0021

		IL_0015: ldloc.0
		IL_0016: ldfld class [System.Core]System.Action MMP.AsyncProxy.Training.Support.OwnerThread/'<>c__DisplayClass10_0'::job
		IL_001b: callvirt instance void [System.Core]System.Action::Invoke()
		IL_0020: ret

		IL_0021: ldloc.0
		IL_0022: ldnull
		IL_0023: stfld class [mscorlib]System.Exception MMP.AsyncProxy.Training.Support.OwnerThread/'<>c__DisplayClass10_0'::failure
		IL_0028: ldloc.0
		IL_0029: ldc.i4.0
		IL_002a: newobj instance void [mscorlib]System.Threading.ManualResetEvent::.ctor(bool)
		IL_002f: stfld class [mscorlib]System.Threading.ManualResetEvent MMP.AsyncProxy.Training.Support.OwnerThread/'<>c__DisplayClass10_0'::done
		IL_0034: ldarg.0
		IL_0035: ldloc.0
		IL_0036: ldftn instance void MMP.AsyncProxy.Training.Support.OwnerThread/'<>c__DisplayClass10_0'::'<Invoke>b__0'()
		IL_003c: newobj instance void [System.Core]System.Action::.ctor(object, native int)
		IL_0041: call instance void MMP.AsyncProxy.Training.Support.OwnerThread::Enqueue(class [System.Core]System.Action)
		IL_0046: ldloc.0
		IL_0047: ldfld class [mscorlib]System.Threading.ManualResetEvent MMP.AsyncProxy.Training.Support.OwnerThread/'<>c__DisplayClass10_0'::done
		IL_004c: callvirt instance bool [mscorlib]System.Threading.WaitHandle::WaitOne()
		IL_0051: pop
		IL_0052: ldloc.0
		IL_0053: ldfld class [mscorlib]System.Threading.ManualResetEvent MMP.AsyncProxy.Training.Support.OwnerThread/'<>c__DisplayClass10_0'::done
		IL_0058: callvirt instance void [mscorlib]System.Threading.WaitHandle::Close()
		IL_005d: ldloc.0
		IL_005e: ldfld class [mscorlib]System.Exception MMP.AsyncProxy.Training.Support.OwnerThread/'<>c__DisplayClass10_0'::failure
		IL_0063: brfalse.s IL_0086

		IL_0065: ldstr "The job on the owner thread failed: "
		IL_006a: ldloc.0
		IL_006b: ldfld class [mscorlib]System.Exception MMP.AsyncProxy.Training.Support.OwnerThread/'<>c__DisplayClass10_0'::failure
		IL_0070: callvirt instance string [mscorlib]System.Exception::get_Message()
		IL_0075: call string [mscorlib]System.String::Concat(string, string)
		IL_007a: ldloc.0
		IL_007b: ldfld class [mscorlib]System.Exception MMP.AsyncProxy.Training.Support.OwnerThread/'<>c__DisplayClass10_0'::failure
		IL_0080: newobj instance void [mscorlib]System.InvalidOperationException::.ctor(string, class [mscorlib]System.Exception)
		IL_0085: throw

		IL_0086: ret
	} // end of method OwnerThread::Invoke

	.method public hidebysig virtual 
		instance void Post (
			class [mscorlib]System.Threading.SendOrPostCallback d,
			object state
		) cil managed 
	{
		// Method begins at RVA 0x21c4
		// Header size: 12
		// Code size: 39 (0x27)
		.maxstack 3
		.locals init (
			[0] class MMP.AsyncProxy.Training.Support.OwnerThread/'<>c__DisplayClass11_0'
		)

		IL_0000: newobj instance void MMP.AsyncProxy.Training.Support.OwnerThread/'<>c__DisplayClass11_0'::.ctor()
		IL_0005: stloc.0
		IL_0006: ldloc.0
		IL_0007: ldarg.1
		IL_0008: stfld class [mscorlib]System.Threading.SendOrPostCallback MMP.AsyncProxy.Training.Support.OwnerThread/'<>c__DisplayClass11_0'::d
		IL_000d: ldloc.0
		IL_000e: ldarg.2
		IL_000f: stfld object MMP.AsyncProxy.Training.Support.OwnerThread/'<>c__DisplayClass11_0'::state
		IL_0014: ldarg.0
		IL_0015: ldloc.0
		IL_0016: ldftn instance void MMP.AsyncProxy.Training.Support.OwnerThread/'<>c__DisplayClass11_0'::'<Post>b__0'()
		IL_001c: newobj instance void [System.Core]System.Action::.ctor(object, native int)
		IL_0021: call instance void MMP.AsyncProxy.Training.Support.OwnerThread::Enqueue(class [System.Core]System.Action)
		IL_0026: ret
	} // end of method OwnerThread::Post

	.method public hidebysig virtual 
		instance class [mscorlib]System.Threading.SynchronizationContext CreateCopy () cil managed 
	{
		// Method begins at RVA 0x21f7
		// Header size: 1
		// Code size: 2 (0x2)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ret
	} // end of method OwnerThread::CreateCopy

	.method private hidebysig 
		instance void Pump () cil managed 
	{
		// Method begins at RVA 0x21fc
		// Header size: 12
		// Code size: 99 (0x63)
		.maxstack 1
		.locals init (
			[0] class [System.Core]System.Action,
			[1] object
		)

		IL_0000: ldarg.0
		IL_0001: call void [mscorlib]System.Threading.SynchronizationContext::SetSynchronizationContext(class [mscorlib]System.Threading.SynchronizationContext)
		// loop start (head: IL_0006)
			IL_0006: ldarg.0
			IL_0007: ldfld object MMP.AsyncProxy.Training.Support.OwnerThread::_gate
			IL_000c: stloc.1
			IL_000d: ldloc.1
			IL_000e: call void [mscorlib]System.Threading.Monitor::Enter(object)
			.try
			{
				IL_0013: br.s IL_0021
				// loop start (head: IL_0021)
					IL_0015: ldarg.0
					IL_0016: ldfld object MMP.AsyncProxy.Training.Support.OwnerThread::_gate
					IL_001b: call bool [mscorlib]System.Threading.Monitor::Wait(object)
					IL_0020: pop

					IL_0021: ldarg.0
					IL_0022: ldfld class [System]System.Collections.Generic.Queue`1<class [System.Core]System.Action> MMP.AsyncProxy.Training.Support.OwnerThread::_jobs
					IL_0027: callvirt instance int32 class [System]System.Collections.Generic.Queue`1<class [System.Core]System.Action>::get_Count()
					IL_002c: brtrue.s IL_0036

					IL_002e: ldarg.0
					IL_002f: ldfld bool MMP.AsyncProxy.Training.Support.OwnerThread::_stop
					IL_0034: brfalse.s IL_0015
				// end loop

				IL_0036: ldarg.0
				IL_0037: ldfld class [System]System.Collections.Generic.Queue`1<class [System.Core]System.Action> MMP.AsyncProxy.Training.Support.OwnerThread::_jobs
				IL_003c: callvirt instance int32 class [System]System.Collections.Generic.Queue`1<class [System.Core]System.Action>::get_Count()
				IL_0041: brtrue.s IL_0045

				IL_0043: leave.s IL_0062

				IL_0045: ldarg.0
				IL_0046: ldfld class [System]System.Collections.Generic.Queue`1<class [System.Core]System.Action> MMP.AsyncProxy.Training.Support.OwnerThread::_jobs
				IL_004b: callvirt instance !0 class [System]System.Collections.Generic.Queue`1<class [System.Core]System.Action>::Dequeue()
				IL_0050: stloc.0
				IL_0051: leave.s IL_005a
			} // end .try
			finally
			{
				IL_0053: ldloc.1
				IL_0054: call void [mscorlib]System.Threading.Monitor::Exit(object)
				IL_0059: endfinally
			} // end handler

			IL_005a: ldloc.0
			IL_005b: callvirt instance void [System.Core]System.Action::Invoke()
			IL_0060: br.s IL_0006
		// end loop

		IL_0062: ret
	} // end of method OwnerThread::Pump

	.method public final hidebysig newslot virtual 
		instance void Dispose () cil managed 
	{
		// Method begins at RVA 0x227c
		// Header size: 12
		// Code size: 52 (0x34)
		.maxstack 2
		.locals init (
			[0] object
		)

		IL_0000: ldarg.0
		IL_0001: ldfld object MMP.AsyncProxy.Training.Support.OwnerThread::_gate
		IL_0006: stloc.0
		IL_0007: ldloc.0
		IL_0008: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_000d: ldarg.0
			IL_000e: ldc.i4.1
			IL_000f: stfld bool MMP.AsyncProxy.Training.Support.OwnerThread::_stop
			IL_0014: ldarg.0
			IL_0015: ldfld object MMP.AsyncProxy.Training.Support.OwnerThread::_gate
			IL_001a: call void [mscorlib]System.Threading.Monitor::PulseAll(object)
			IL_001f: leave.s IL_0028
		} // end .try
		finally
		{
			IL_0021: ldloc.0
			IL_0022: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_0027: endfinally
		} // end handler

		IL_0028: ldarg.0
		IL_0029: ldfld class [mscorlib]System.Threading.Thread MMP.AsyncProxy.Training.Support.OwnerThread::_thread
		IL_002e: callvirt instance void [mscorlib]System.Threading.Thread::Join()
		IL_0033: ret
	} // end of method OwnerThread::Dispose

	// Properties
	.property instance int32 ThreadId()
	{
		.get instance int32 MMP.AsyncProxy.Training.Support.OwnerThread::get_ThreadId()
	}
	.property instance bool IsOwnerThread()
	{
		.get instance bool MMP.AsyncProxy.Training.Support.OwnerThread::get_IsOwnerThread()
	}

} // end of class MMP.AsyncProxy.Training.Support.OwnerThread

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Support.ThreadSampler
	extends [mscorlib]System.Object
{
	// Fields
	.field private initonly class [mscorlib]System.Threading.Timer _timer
	.field private int32 _peak
	.field private bool _stopped

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x22cc
		// Header size: 1
		// Code size: 40 (0x28)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: call instance void [mscorlib]System.Object::.ctor()
		IL_0006: ldarg.0
		IL_0007: ldnull
		IL_0008: call instance void MMP.AsyncProxy.Training.Support.ThreadSampler::Sample(object)
		IL_000d: ldarg.0
		IL_000e: ldarg.0
		IL_000f: ldftn instance void MMP.AsyncProxy.Training.Support.ThreadSampler::Sample(object)
		IL_0015: newobj instance void [mscorlib]System.Threading.TimerCallback::.ctor(object, native int)
		IL_001a: ldnull
		IL_001b: ldc.i4.5
		IL_001c: ldc.i4.5
		IL_001d: newobj instance void [mscorlib]System.Threading.Timer::.ctor(class [mscorlib]System.Threading.TimerCallback, object, int32, int32)
		IL_0022: stfld class [mscorlib]System.Threading.Timer MMP.AsyncProxy.Training.Support.ThreadSampler::_timer
		IL_0027: ret
	} // end of method ThreadSampler::.ctor

	.method private hidebysig 
		instance void Sample (
			object state
		) cil managed 
	{
		// Method begins at RVA 0x22f8
		// Header size: 12
		// Code size: 54 (0x36)
		.maxstack 3
		.locals init (
			[0] int32,
			[1] int32
		)

		IL_0000: ldarg.0
		IL_0001: ldfld bool MMP.AsyncProxy.Training.Support.ThreadSampler::_stopped
		IL_0006: brfalse.s IL_0009

		IL_0008: ret

		IL_0009: call class [System]System.Diagnostics.Process [System]System.Diagnostics.Process::GetCurrentProcess()
		IL_000e: callvirt instance class [System]System.Diagnostics.ProcessThreadCollection [System]System.Diagnostics.Process::get_Threads()
		IL_0013: callvirt instance int32 [mscorlib]System.Collections.ReadOnlyCollectionBase::get_Count()
		IL_0018: stloc.0
		// loop start (head: IL_0019)
			IL_0019: ldarg.0
			IL_001a: ldfld int32 MMP.AsyncProxy.Training.Support.ThreadSampler::_peak
			IL_001f: stloc.1
			IL_0020: ldloc.0
			IL_0021: ldloc.1
			IL_0022: bgt.s IL_0025

			IL_0024: ret

			IL_0025: ldarg.0
			IL_0026: ldflda int32 MMP.AsyncProxy.Training.Support.ThreadSampler::_peak
			IL_002b: ldloc.0
			IL_002c: ldloc.1
			IL_002d: call int32 [mscorlib]System.Threading.Interlocked::CompareExchange(int32&, int32, int32)
			IL_0032: ldloc.1
			IL_0033: bne.un.s IL_0019
		// end loop
		IL_0035: ret
	} // end of method ThreadSampler::Sample

	.method public hidebysig 
		instance int32 Stop () cil managed 
	{
		// Method begins at RVA 0x233a
		// Header size: 1
		// Code size: 32 (0x20)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldc.i4.1
		IL_0002: stfld bool MMP.AsyncProxy.Training.Support.ThreadSampler::_stopped
		IL_0007: ldarg.0
		IL_0008: ldfld class [mscorlib]System.Threading.Timer MMP.AsyncProxy.Training.Support.ThreadSampler::_timer
		IL_000d: callvirt instance void [mscorlib]System.Threading.Timer::Dispose()
		IL_0012: ldarg.0
		IL_0013: ldnull
		IL_0014: call instance void MMP.AsyncProxy.Training.Support.ThreadSampler::Sample(object)
		IL_0019: ldarg.0
		IL_001a: ldfld int32 MMP.AsyncProxy.Training.Support.ThreadSampler::_peak
		IL_001f: ret
	} // end of method ThreadSampler::Stop

} // end of class MMP.AsyncProxy.Training.Support.ThreadSampler

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Printer.WrongThreadException
	extends [mscorlib]System.InvalidOperationException
{
	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			string message
		) cil managed 
	{
		// Method begins at RVA 0x235b
		// Header size: 1
		// Code size: 8 (0x8)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldarg.1
		IL_0002: call instance void [mscorlib]System.InvalidOperationException::.ctor(string)
		IL_0007: ret
	} // end of method WrongThreadException::.ctor

} // end of class MMP.AsyncProxy.Training.Printer.WrongThreadException

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Printer.ReceiptPrinter
	extends [mscorlib]System.Object
{
	// Fields
	.field private initonly object _gate
	.field private initonly class [mscorlib]System.Collections.Generic.List`1<string> _lines
	.field private initonly class [mscorlib]System.Collections.Generic.Dictionary`2<int32, bool> _callers
	.field private int32 _owner
	.field private int32 _rejected

	// Methods
	.method public hidebysig 
		instance void Open () cil managed 
	{
		// Method begins at RVA 0x2364
		// Header size: 12
		// Code size: 39 (0x27)
		.maxstack 2
		.locals init (
			[0] object
		)

		IL_0000: ldarg.0
		IL_0001: ldfld object MMP.AsyncProxy.Training.Printer.ReceiptPrinter::_gate
		IL_0006: stloc.0
		IL_0007: ldloc.0
		IL_0008: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_000d: ldarg.0
			IL_000e: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0013: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_0018: stfld int32 MMP.AsyncProxy.Training.Printer.ReceiptPrinter::_owner
			IL_001d: leave.s IL_0026
		} // end .try
		finally
		{
			IL_001f: ldloc.0
			IL_0020: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_0025: endfinally
		} // end handler

		IL_0026: ret
	} // end of method ReceiptPrinter::Open

	.method public hidebysig 
		instance void PrintLine (
			string line
		) cil managed 
	{
		// Method begins at RVA 0x23a8
		// Header size: 12
		// Code size: 147 (0x93)
		.maxstack 4
		.locals init (
			[0] int32,
			[1] object
		)

		IL_0000: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
		IL_0005: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
		IL_000a: stloc.0
		IL_000b: ldarg.0
		IL_000c: ldfld object MMP.AsyncProxy.Training.Printer.ReceiptPrinter::_gate
		IL_0011: stloc.1
		IL_0012: ldloc.1
		IL_0013: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_0018: ldarg.0
			IL_0019: ldfld class [mscorlib]System.Collections.Generic.Dictionary`2<int32, bool> MMP.AsyncProxy.Training.Printer.ReceiptPrinter::_callers
			IL_001e: ldloc.0
			IL_001f: ldc.i4.1
			IL_0020: callvirt instance void class [mscorlib]System.Collections.Generic.Dictionary`2<int32, bool>::set_Item(!0, !1)
			IL_0025: ldloc.0
			IL_0026: ldarg.0
			IL_0027: ldfld int32 MMP.AsyncProxy.Training.Printer.ReceiptPrinter::_owner
			IL_002c: beq.s IL_007d

			IL_002e: ldarg.0
			IL_002f: ldarg.0
			IL_0030: ldfld int32 MMP.AsyncProxy.Training.Printer.ReceiptPrinter::_rejected
			IL_0035: ldc.i4.1
			IL_0036: add
			IL_0037: stfld int32 MMP.AsyncProxy.Training.Printer.ReceiptPrinter::_rejected
			IL_003c: ldc.i4.5
			IL_003d: newarr [mscorlib]System.String
			IL_0042: dup
			IL_0043: ldc.i4.0
			IL_0044: ldstr "The printer was opened on thread "
			IL_0049: stelem.ref
			IL_004a: dup
			IL_004b: ldc.i4.1
			IL_004c: ldarg.0
			IL_004d: ldflda int32 MMP.AsyncProxy.Training.Printer.ReceiptPrinter::_owner
			IL_0052: call instance string [mscorlib]System.Int32::ToString()
			IL_0057: stelem.ref
			IL_0058: dup
			IL_0059: ldc.i4.2
			IL_005a: ldstr " and called from thread "
			IL_005f: stelem.ref
			IL_0060: dup
			IL_0061: ldc.i4.3
			IL_0062: ldloca.s 0
			IL_0064: call instance string [mscorlib]System.Int32::ToString()
			IL_0069: stelem.ref
			IL_006a: dup
			IL_006b: ldc.i4.4
			IL_006c: ldstr "."
			IL_0071: stelem.ref
			IL_0072: call string [mscorlib]System.String::Concat(string[])
			IL_0077: newobj instance void MMP.AsyncProxy.Training.Printer.WrongThreadException::.ctor(string)
			IL_007c: throw

			IL_007d: ldarg.0
			IL_007e: ldfld class [mscorlib]System.Collections.Generic.List`1<string> MMP.AsyncProxy.Training.Printer.ReceiptPrinter::_lines
			IL_0083: ldarg.1
			IL_0084: callvirt instance void class [mscorlib]System.Collections.Generic.List`1<string>::Add(!0)
			IL_0089: leave.s IL_0092
		} // end .try
		finally
		{
			IL_008b: ldloc.1
			IL_008c: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_0091: endfinally
		} // end handler

		IL_0092: ret
	} // end of method ReceiptPrinter::PrintLine

	.method public hidebysig specialname 
		instance string[] get_Lines () cil managed 
	{
		// Method begins at RVA 0x2458
		// Header size: 12
		// Code size: 36 (0x24)
		.maxstack 1
		.locals init (
			[0] object,
			[1] string[]
		)

		IL_0000: ldarg.0
		IL_0001: ldfld object MMP.AsyncProxy.Training.Printer.ReceiptPrinter::_gate
		IL_0006: stloc.0
		IL_0007: ldloc.0
		IL_0008: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_000d: ldarg.0
			IL_000e: ldfld class [mscorlib]System.Collections.Generic.List`1<string> MMP.AsyncProxy.Training.Printer.ReceiptPrinter::_lines
			IL_0013: callvirt instance !0[] class [mscorlib]System.Collections.Generic.List`1<string>::ToArray()
			IL_0018: stloc.1
			IL_0019: leave.s IL_0022
		} // end .try
		finally
		{
			IL_001b: ldloc.0
			IL_001c: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_0021: endfinally
		} // end handler

		IL_0022: ldloc.1
		IL_0023: ret
	} // end of method ReceiptPrinter::get_Lines

	.method public hidebysig specialname 
		instance int32 get_Rejected () cil managed 
	{
		// Method begins at RVA 0x2498
		// Header size: 12
		// Code size: 31 (0x1f)
		.maxstack 1
		.locals init (
			[0] object,
			[1] int32
		)

		IL_0000: ldarg.0
		IL_0001: ldfld object MMP.AsyncProxy.Training.Printer.ReceiptPrinter::_gate
		IL_0006: stloc.0
		IL_0007: ldloc.0
		IL_0008: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_000d: ldarg.0
			IL_000e: ldfld int32 MMP.AsyncProxy.Training.Printer.ReceiptPrinter::_rejected
			IL_0013: stloc.1
			IL_0014: leave.s IL_001d
		} // end .try
		finally
		{
			IL_0016: ldloc.0
			IL_0017: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_001c: endfinally
		} // end handler

		IL_001d: ldloc.1
		IL_001e: ret
	} // end of method ReceiptPrinter::get_Rejected

	.method public hidebysig specialname 
		instance int32 get_CallerThreads () cil managed 
	{
		// Method begins at RVA 0x24d4
		// Header size: 12
		// Code size: 36 (0x24)
		.maxstack 1
		.locals init (
			[0] object,
			[1] int32
		)

		IL_0000: ldarg.0
		IL_0001: ldfld object MMP.AsyncProxy.Training.Printer.ReceiptPrinter::_gate
		IL_0006: stloc.0
		IL_0007: ldloc.0
		IL_0008: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_000d: ldarg.0
			IL_000e: ldfld class [mscorlib]System.Collections.Generic.Dictionary`2<int32, bool> MMP.AsyncProxy.Training.Printer.ReceiptPrinter::_callers
			IL_0013: callvirt instance int32 class [mscorlib]System.Collections.Generic.Dictionary`2<int32, bool>::get_Count()
			IL_0018: stloc.1
			IL_0019: leave.s IL_0022
		} // end .try
		finally
		{
			IL_001b: ldloc.0
			IL_001c: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_0021: endfinally
		} // end handler

		IL_0022: ldloc.1
		IL_0023: ret
	} // end of method ReceiptPrinter::get_CallerThreads

	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x2514
		// Header size: 1
		// Code size: 47 (0x2f)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: newobj instance void [mscorlib]System.Object::.ctor()
		IL_0006: stfld object MMP.AsyncProxy.Training.Printer.ReceiptPrinter::_gate
		IL_000b: ldarg.0
		IL_000c: newobj instance void class [mscorlib]System.Collections.Generic.List`1<string>::.ctor()
		IL_0011: stfld class [mscorlib]System.Collections.Generic.List`1<string> MMP.AsyncProxy.Training.Printer.ReceiptPrinter::_lines
		IL_0016: ldarg.0
		IL_0017: newobj instance void class [mscorlib]System.Collections.Generic.Dictionary`2<int32, bool>::.ctor()
		IL_001c: stfld class [mscorlib]System.Collections.Generic.Dictionary`2<int32, bool> MMP.AsyncProxy.Training.Printer.ReceiptPrinter::_callers
		IL_0021: ldarg.0
		IL_0022: ldc.i4.m1
		IL_0023: stfld int32 MMP.AsyncProxy.Training.Printer.ReceiptPrinter::_owner
		IL_0028: ldarg.0
		IL_0029: call instance void [mscorlib]System.Object::.ctor()
		IL_002e: ret
	} // end of method ReceiptPrinter::.ctor

	// Properties
	.property instance string[] Lines()
	{
		.get instance string[] MMP.AsyncProxy.Training.Printer.ReceiptPrinter::get_Lines()
	}
	.property instance int32 Rejected()
	{
		.get instance int32 MMP.AsyncProxy.Training.Printer.ReceiptPrinter::get_Rejected()
	}
	.property instance int32 CallerThreads()
	{
		.get instance int32 MMP.AsyncProxy.Training.Printer.ReceiptPrinter::get_CallerThreads()
	}

} // end of class MMP.AsyncProxy.Training.Printer.ReceiptPrinter

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Printer.PrintReport
	extends [mscorlib]System.Object
{
	// Fields
	.field private initonly int32 _printed
	.field private initonly int32 _rejected
	.field private initonly string _firstProblem

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			int32 printed,
			int32 rejected,
			string firstProblem
		) cil managed 
	{
		// Method begins at RVA 0x2544
		// Header size: 1
		// Code size: 28 (0x1c)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: call instance void [mscorlib]System.Object::.ctor()
		IL_0006: ldarg.0
		IL_0007: ldarg.1
		IL_0008: stfld int32 MMP.AsyncProxy.Training.Printer.PrintReport::_printed
		IL_000d: ldarg.0
		IL_000e: ldarg.2
		IL_000f: stfld int32 MMP.AsyncProxy.Training.Printer.PrintReport::_rejected
		IL_0014: ldarg.0
		IL_0015: ldarg.3
		IL_0016: stfld string MMP.AsyncProxy.Training.Printer.PrintReport::_firstProblem
		IL_001b: ret
	} // end of method PrintReport::.ctor

	.method public hidebysig specialname 
		instance int32 get_Printed () cil managed 
	{
		// Method begins at RVA 0x2561
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld int32 MMP.AsyncProxy.Training.Printer.PrintReport::_printed
		IL_0006: ret
	} // end of method PrintReport::get_Printed

	.method public hidebysig specialname 
		instance int32 get_Rejected () cil managed 
	{
		// Method begins at RVA 0x2569
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld int32 MMP.AsyncProxy.Training.Printer.PrintReport::_rejected
		IL_0006: ret
	} // end of method PrintReport::get_Rejected

	.method public hidebysig specialname 
		instance string get_FirstProblem () cil managed 
	{
		// Method begins at RVA 0x2571
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld string MMP.AsyncProxy.Training.Printer.PrintReport::_firstProblem
		IL_0006: ret
	} // end of method PrintReport::get_FirstProblem

	// Properties
	.property instance int32 Printed()
	{
		.get instance int32 MMP.AsyncProxy.Training.Printer.PrintReport::get_Printed()
	}
	.property instance int32 Rejected()
	{
		.get instance int32 MMP.AsyncProxy.Training.Printer.PrintReport::get_Rejected()
	}
	.property instance string FirstProblem()
	{
		.get instance string MMP.AsyncProxy.Training.Printer.PrintReport::get_FirstProblem()
	}

} // end of class MMP.AsyncProxy.Training.Printer.PrintReport

.class interface public auto ansi abstract beforefieldinit MMP.AsyncProxy.Training.Printer.IReceiptDesk
	implements [mscorlib]System.IDisposable
{
	// Methods
	.method public hidebysig specialname newslot abstract virtual 
		instance string get_Version () cil managed 
	{
	} // end of method IReceiptDesk::get_Version

	.method public hidebysig specialname newslot abstract virtual 
		instance class MMP.AsyncProxy.Training.Printer.ReceiptPrinter get_Printer () cil managed 
	{
	} // end of method IReceiptDesk::get_Printer

	.method public hidebysig specialname newslot abstract virtual 
		instance int32 get_OwnerThreadId () cil managed 
	{
	} // end of method IReceiptDesk::get_OwnerThreadId

	.method public hidebysig newslot abstract virtual 
		instance class MMP.AsyncProxy.Training.Printer.PrintReport PrintJob (
			string[] receipts,
			int32 feedMs
		) cil managed 
	{
	} // end of method IReceiptDesk::PrintJob

	// Properties
	.property instance string Version()
	{
		.get instance string MMP.AsyncProxy.Training.Printer.IReceiptDesk::get_Version()
	}
	.property instance class MMP.AsyncProxy.Training.Printer.ReceiptPrinter Printer()
	{
		.get instance class MMP.AsyncProxy.Training.Printer.ReceiptPrinter MMP.AsyncProxy.Training.Printer.IReceiptDesk::get_Printer()
	}
	.property instance int32 OwnerThreadId()
	{
		.get instance int32 MMP.AsyncProxy.Training.Printer.IReceiptDesk::get_OwnerThreadId()
	}

} // end of class MMP.AsyncProxy.Training.Printer.IReceiptDesk

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk
	extends [mscorlib]System.Object
	implements MMP.AsyncProxy.Training.Printer.IReceiptDesk,
	           [mscorlib]System.IDisposable
{
	// Nested Types
	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass9_0'
		extends [mscorlib]System.Object
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field public class MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk '<>4__this'
		.field public string[] receipts
		.field public int32 printed
		.field public int32 feedMs

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor () cil managed 
		{
			// Method begins at RVA 0x46c7
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass9_0'::.ctor

		.method assembly hidebysig 
			instance void '<PrintJob>b__0' () cil managed 
		{
			// Method begins at RVA 0x46d0
			// Header size: 12
			// Code size: 71 (0x47)
			.maxstack 3
			.locals init (
				[0] int32,
				[1] int32
			)

			IL_0000: ldc.i4.0
			IL_0001: stloc.0
			IL_0002: br.s IL_003b
			// loop start (head: IL_003b)
				IL_0004: ldarg.0
				IL_0005: ldfld class MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk/'<>c__DisplayClass9_0'::'<>4__this'
				IL_000a: ldfld class MMP.AsyncProxy.Training.Printer.ReceiptPrinter MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk::_printer
				IL_000f: ldarg.0
				IL_0010: ldfld string[] MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk/'<>c__DisplayClass9_0'::receipts
				IL_0015: ldloc.0
				IL_0016: ldelem.ref
				IL_0017: callvirt instance void MMP.AsyncProxy.Training.Printer.ReceiptPrinter::PrintLine(string)
				IL_001c: ldarg.0
				IL_001d: ldfld int32 MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk/'<>c__DisplayClass9_0'::printed
				IL_0022: stloc.1
				IL_0023: ldarg.0
				IL_0024: ldloc.1
				IL_0025: ldc.i4.1
				IL_0026: add
				IL_0027: stfld int32 MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk/'<>c__DisplayClass9_0'::printed
				IL_002c: ldarg.0
				IL_002d: ldfld int32 MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk/'<>c__DisplayClass9_0'::feedMs
				IL_0032: call void [mscorlib]System.Threading.Thread::Sleep(int32)
				IL_0037: ldloc.0
				IL_0038: ldc.i4.1
				IL_0039: add
				IL_003a: stloc.0

				IL_003b: ldloc.0
				IL_003c: ldarg.0
				IL_003d: ldfld string[] MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk/'<>c__DisplayClass9_0'::receipts
				IL_0042: ldlen
				IL_0043: conv.i4
				IL_0044: blt.s IL_0004
			// end loop

			IL_0046: ret
		} // end of method '<>c__DisplayClass9_0'::'<PrintJob>b__0'

	} // end of class <>c__DisplayClass9_0


	// Fields
	.field private initonly class MMP.AsyncProxy.Training.Support.OwnerThread _owner
	.field private initonly class MMP.AsyncProxy.Training.Printer.ReceiptPrinter _printer

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x2579
		// Header size: 1
		// Code size: 57 (0x39)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldstr "printer"
		IL_0006: newobj instance void MMP.AsyncProxy.Training.Support.OwnerThread::.ctor(string)
		IL_000b: stfld class MMP.AsyncProxy.Training.Support.OwnerThread MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk::_owner
		IL_0010: ldarg.0
		IL_0011: newobj instance void MMP.AsyncProxy.Training.Printer.ReceiptPrinter::.ctor()
		IL_0016: stfld class MMP.AsyncProxy.Training.Printer.ReceiptPrinter MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk::_printer
		IL_001b: ldarg.0
		IL_001c: call instance void [mscorlib]System.Object::.ctor()
		IL_0021: ldarg.0
		IL_0022: ldfld class MMP.AsyncProxy.Training.Support.OwnerThread MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk::_owner
		IL_0027: ldarg.0
		IL_0028: ldftn instance void MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk::'<.ctor>b__2_0'()
		IL_002e: newobj instance void [System.Core]System.Action::.ctor(object, native int)
		IL_0033: callvirt instance void MMP.AsyncProxy.Training.Support.OwnerThread::Invoke(class [System.Core]System.Action)
		IL_0038: ret
	} // end of method OwnerThreadDesk::.ctor

	.method public final hidebysig specialname newslot virtual 
		instance string get_Version () cil managed 
	{
		// Method begins at RVA 0x25b3
		// Header size: 1
		// Code size: 6 (0x6)
		.maxstack 8

		IL_0000: ldstr "threaded"
		IL_0005: ret
	} // end of method OwnerThreadDesk::get_Version

	.method public final hidebysig specialname newslot virtual 
		instance class MMP.AsyncProxy.Training.Printer.ReceiptPrinter get_Printer () cil managed 
	{
		// Method begins at RVA 0x25ba
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld class MMP.AsyncProxy.Training.Printer.ReceiptPrinter MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk::_printer
		IL_0006: ret
	} // end of method OwnerThreadDesk::get_Printer

	.method public final hidebysig specialname newslot virtual 
		instance int32 get_OwnerThreadId () cil managed 
	{
		// Method begins at RVA 0x25c2
		// Header size: 1
		// Code size: 12 (0xc)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld class MMP.AsyncProxy.Training.Support.OwnerThread MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk::_owner
		IL_0006: callvirt instance int32 MMP.AsyncProxy.Training.Support.OwnerThread::get_ThreadId()
		IL_000b: ret
	} // end of method OwnerThreadDesk::get_OwnerThreadId

	.method public final hidebysig newslot virtual 
		instance class MMP.AsyncProxy.Training.Printer.PrintReport PrintJob (
			string[] receipts,
			int32 feedMs
		) cil managed 
	{
		// Method begins at RVA 0x25d0
		// Header size: 12
		// Code size: 71 (0x47)
		.maxstack 3
		.locals init (
			[0] class MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk/'<>c__DisplayClass9_0'
		)

		IL_0000: newobj instance void MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk/'<>c__DisplayClass9_0'::.ctor()
		IL_0005: stloc.0
		IL_0006: ldloc.0
		IL_0007: ldarg.0
		IL_0008: stfld class MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk/'<>c__DisplayClass9_0'::'<>4__this'
		IL_000d: ldloc.0
		IL_000e: ldarg.1
		IL_000f: stfld string[] MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk/'<>c__DisplayClass9_0'::receipts
		IL_0014: ldloc.0
		IL_0015: ldarg.2
		IL_0016: stfld int32 MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk/'<>c__DisplayClass9_0'::feedMs
		IL_001b: ldloc.0
		IL_001c: ldc.i4.0
		IL_001d: stfld int32 MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk/'<>c__DisplayClass9_0'::printed
		IL_0022: ldarg.0
		IL_0023: ldfld class MMP.AsyncProxy.Training.Support.OwnerThread MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk::_owner
		IL_0028: ldloc.0
		IL_0029: ldftn instance void MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk/'<>c__DisplayClass9_0'::'<PrintJob>b__0'()
		IL_002f: newobj instance void [System.Core]System.Action::.ctor(object, native int)
		IL_0034: callvirt instance void MMP.AsyncProxy.Training.Support.OwnerThread::Invoke(class [System.Core]System.Action)
		IL_0039: ldloc.0
		IL_003a: ldfld int32 MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk/'<>c__DisplayClass9_0'::printed
		IL_003f: ldc.i4.0
		IL_0040: ldnull
		IL_0041: newobj instance void MMP.AsyncProxy.Training.Printer.PrintReport::.ctor(int32, int32, string)
		IL_0046: ret
	} // end of method OwnerThreadDesk::PrintJob

	.method public final hidebysig newslot virtual 
		instance void Dispose () cil managed 
	{
		// Method begins at RVA 0x2623
		// Header size: 1
		// Code size: 12 (0xc)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld class MMP.AsyncProxy.Training.Support.OwnerThread MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk::_owner
		IL_0006: callvirt instance void MMP.AsyncProxy.Training.Support.OwnerThread::Dispose()
		IL_000b: ret
	} // end of method OwnerThreadDesk::Dispose

	.method private hidebysig 
		instance void '<.ctor>b__2_0' () cil managed 
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Method begins at RVA 0x2630
		// Header size: 1
		// Code size: 12 (0xc)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld class MMP.AsyncProxy.Training.Printer.ReceiptPrinter MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk::_printer
		IL_0006: callvirt instance void MMP.AsyncProxy.Training.Printer.ReceiptPrinter::Open()
		IL_000b: ret
	} // end of method OwnerThreadDesk::'<.ctor>b__2_0'

	// Properties
	.property instance string Version()
	{
		.get instance string MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk::get_Version()
	}
	.property instance class MMP.AsyncProxy.Training.Printer.ReceiptPrinter Printer()
	{
		.get instance class MMP.AsyncProxy.Training.Printer.ReceiptPrinter MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk::get_Printer()
	}
	.property instance int32 OwnerThreadId()
	{
		.get instance int32 MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk::get_OwnerThreadId()
	}

} // end of class MMP.AsyncProxy.Training.Printer.Threaded.OwnerThreadDesk

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Printer.Async.NaiveDesk
	extends [mscorlib]System.Object
	implements MMP.AsyncProxy.Training.Printer.IReceiptDesk,
	           [mscorlib]System.IDisposable
{
	// Nested Types
	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass9_0'
		extends [mscorlib]System.Object
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field public class MMP.AsyncProxy.Training.Printer.Async.NaiveDesk '<>4__this'
		.field public string[] receipts
		.field public int32 feedMs

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor () cil managed 
		{
			// Method begins at RVA 0x4723
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass9_0'::.ctor

		.method assembly hidebysig 
			instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> '<PrintJob>b__0' (
				class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Printer.PrintReport> 'ret'
			) cil managed 
		{
			// Method begins at RVA 0x472b
			// Header size: 1
			// Code size: 25 (0x19)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class MMP.AsyncProxy.Training.Printer.Async.NaiveDesk MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<>c__DisplayClass9_0'::'<>4__this'
			IL_0006: ldarg.0
			IL_0007: ldfld string[] MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<>c__DisplayClass9_0'::receipts
			IL_000c: ldarg.0
			IL_000d: ldfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<>c__DisplayClass9_0'::feedMs
			IL_0012: ldarg.1
			IL_0013: call instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Printer.Async.NaiveDesk::Body(string[], int32, class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Printer.PrintReport>)
			IL_0018: ret
		} // end of method '<>c__DisplayClass9_0'::'<PrintJob>b__0'

	} // end of class <>c__DisplayClass9_0

	.class nested private auto ansi sealed beforefieldinit '<Body>d__10'
		extends [mscorlib]System.Object
		implements class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>,
		           [mscorlib]System.Collections.IEnumerable,
		           class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>,
		           [mscorlib]System.IDisposable,
		           [mscorlib]System.Collections.IEnumerator
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field private int32 '<>1__state'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture '<>2__current'
		.field private int32 '<>l__initialThreadId'
		.field public class MMP.AsyncProxy.Training.Printer.Async.NaiveDesk '<>4__this'
		.field private string[] receipts
		.field public string[] '<>3__receipts'
		.field private int32 feedMs
		.field public int32 '<>3__feedMs'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Printer.PrintReport> 'ret'
		.field public class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Printer.PrintReport> '<>3__ret'
		.field private int32 '<printed>5__2'
		.field private int32 '<rejected>5__3'
		.field private string '<firstProblem>5__4'
		.field private int32 '<i>5__5'

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor (
				int32 '<>1__state'
			) cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			// Method begins at RVA 0x4745
			// Header size: 1
			// Code size: 30 (0x1e)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ldarg.0
			IL_0007: ldarg.1
			IL_0008: stfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<>1__state'
			IL_000d: ldarg.0
			IL_000e: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0013: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_0018: stfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<>l__initialThreadId'
			IL_001d: ret
		} // end of method '<Body>d__10'::.ctor

		.method private final hidebysig newslot virtual 
			instance void System.IDisposable.Dispose () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [mscorlib]System.IDisposable::Dispose()
			// Method begins at RVA 0x4764
			// Header size: 1
			// Code size: 16 (0x10)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldnull
			IL_0002: stfld string MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<firstProblem>5__4'
			IL_0007: ldarg.0
			IL_0008: ldc.i4.s -2
			IL_000a: stfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<>1__state'
			IL_000f: ret
		} // end of method '<Body>d__10'::System.IDisposable.Dispose

		.method private final hidebysig newslot virtual 
			instance bool MoveNext () cil managed 
		{
			.override method instance bool [mscorlib]System.Collections.IEnumerator::MoveNext()
			// Method begins at RVA 0x4778
			// Header size: 12
			// Code size: 252 (0xfc)
			.maxstack 4
			.locals init (
				[0] int32,
				[1] class MMP.AsyncProxy.Training.Printer.Async.NaiveDesk,
				[2] int32,
				[3] class MMP.AsyncProxy.Training.Printer.WrongThreadException
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<>1__state'
			IL_0006: stloc.0
			IL_0007: ldarg.0
			IL_0008: ldfld class MMP.AsyncProxy.Training.Printer.Async.NaiveDesk MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<>4__this'
			IL_000d: stloc.1
			IL_000e: ldloc.0
			IL_000f: brfalse.s IL_001a

			IL_0011: ldloc.0
			IL_0012: ldc.i4.1
			IL_0013: beq IL_00ae

			IL_0018: ldc.i4.0
			IL_0019: ret

			IL_001a: ldarg.0
			IL_001b: ldc.i4.m1
			IL_001c: stfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<>1__state'
			IL_0021: ldarg.0
			IL_0022: ldc.i4.0
			IL_0023: stfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<printed>5__2'
			IL_0028: ldarg.0
			IL_0029: ldc.i4.0
			IL_002a: stfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<rejected>5__3'
			IL_002f: ldarg.0
			IL_0030: ldnull
			IL_0031: stfld string MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<firstProblem>5__4'
			IL_0036: ldarg.0
			IL_0037: ldc.i4.0
			IL_0038: stfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<i>5__5'
			IL_003d: br IL_00c5

			IL_0042: nop
			.try
			{
				IL_0043: ldloc.1
				IL_0044: ldfld class MMP.AsyncProxy.Training.Printer.ReceiptPrinter MMP.AsyncProxy.Training.Printer.Async.NaiveDesk::_printer
				IL_0049: ldarg.0
				IL_004a: ldfld string[] MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::receipts
				IL_004f: ldarg.0
				IL_0050: ldfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<i>5__5'
				IL_0055: ldelem.ref
				IL_0056: callvirt instance void MMP.AsyncProxy.Training.Printer.ReceiptPrinter::PrintLine(string)
				IL_005b: ldarg.0
				IL_005c: ldfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<printed>5__2'
				IL_0061: stloc.2
				IL_0062: ldarg.0
				IL_0063: ldloc.2
				IL_0064: ldc.i4.1
				IL_0065: add
				IL_0066: stfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<printed>5__2'
				IL_006b: leave.s IL_0094
			} // end .try
			catch MMP.AsyncProxy.Training.Printer.WrongThreadException
			{
				IL_006d: stloc.3
				IL_006e: ldarg.0
				IL_006f: ldfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<rejected>5__3'
				IL_0074: stloc.2
				IL_0075: ldarg.0
				IL_0076: ldloc.2
				IL_0077: ldc.i4.1
				IL_0078: add
				IL_0079: stfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<rejected>5__3'
				IL_007e: ldarg.0
				IL_007f: ldfld string MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<firstProblem>5__4'
				IL_0084: brtrue.s IL_0092

				IL_0086: ldarg.0
				IL_0087: ldloc.3
				IL_0088: callvirt instance string [mscorlib]System.Exception::get_Message()
				IL_008d: stfld string MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<firstProblem>5__4'

				IL_0092: leave.s IL_0094
			} // end handler

			IL_0094: ldarg.0
			IL_0095: ldarg.0
			IL_0096: ldfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::feedMs
			IL_009b: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture [MMP.AsyncProxy]MMP.AsyncProxy.Futures::Delay(int32)
			IL_00a0: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<>2__current'
			IL_00a5: ldarg.0
			IL_00a6: ldc.i4.1
			IL_00a7: stfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<>1__state'
			IL_00ac: ldc.i4.1
			IL_00ad: ret

			IL_00ae: ldarg.0
			IL_00af: ldc.i4.m1
			IL_00b0: stfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<>1__state'
			IL_00b5: ldarg.0
			IL_00b6: ldfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<i>5__5'
			IL_00bb: stloc.2
			IL_00bc: ldarg.0
			IL_00bd: ldloc.2
			IL_00be: ldc.i4.1
			IL_00bf: add
			IL_00c0: stfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<i>5__5'

			IL_00c5: ldarg.0
			IL_00c6: ldfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<i>5__5'
			IL_00cb: ldarg.0
			IL_00cc: ldfld string[] MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::receipts
			IL_00d1: ldlen
			IL_00d2: conv.i4
			IL_00d3: blt IL_0042

			IL_00d8: ldarg.0
			IL_00d9: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Printer.PrintReport> MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'ret'
			IL_00de: ldarg.0
			IL_00df: ldfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<printed>5__2'
			IL_00e4: ldarg.0
			IL_00e5: ldfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<rejected>5__3'
			IL_00ea: ldarg.0
			IL_00eb: ldfld string MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<firstProblem>5__4'
			IL_00f0: newobj instance void MMP.AsyncProxy.Training.Printer.PrintReport::.ctor(int32, int32, string)
			IL_00f5: callvirt instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Printer.PrintReport>::set_Value(!0)
			IL_00fa: ldc.i4.0
			IL_00fb: ret
		} // end of method '<Body>d__10'::MoveNext

		.method private final hidebysig specialname newslot virtual 
			instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance !0 class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::get_Current()
			// Method begins at RVA 0x4890
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<>2__current'
			IL_0006: ret
		} // end of method '<Body>d__10'::'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current'

		.method private final hidebysig newslot virtual 
			instance void System.Collections.IEnumerator.Reset () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [mscorlib]System.Collections.IEnumerator::Reset()
			// Method begins at RVA 0x4898
			// Header size: 1
			// Code size: 6 (0x6)
			.maxstack 8

			IL_0000: newobj instance void [mscorlib]System.NotSupportedException::.ctor()
			IL_0005: throw
		} // end of method '<Body>d__10'::System.Collections.IEnumerator.Reset

		.method private final hidebysig specialname newslot virtual 
			instance object System.Collections.IEnumerator.get_Current () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance object [mscorlib]System.Collections.IEnumerator::get_Current()
			// Method begins at RVA 0x489f
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<>2__current'
			IL_0006: ret
		} // end of method '<Body>d__10'::System.Collections.IEnumerator.get_Current

		.method private final hidebysig newslot virtual 
			instance class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> 'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance class [mscorlib]System.Collections.Generic.IEnumerator`1<!0> class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::GetEnumerator()
			// Method begins at RVA 0x48a8
			// Header size: 12
			// Code size: 96 (0x60)
			.maxstack 2
			.locals init (
				[0] class MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<>1__state'
			IL_0006: ldc.i4.s -2
			IL_0008: bne.un.s IL_0027

			IL_000a: ldarg.0
			IL_000b: ldfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<>l__initialThreadId'
			IL_0010: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0015: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_001a: bne.un.s IL_0027

			IL_001c: ldarg.0
			IL_001d: ldc.i4.0
			IL_001e: stfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<>1__state'
			IL_0023: ldarg.0
			IL_0024: stloc.0
			IL_0025: br.s IL_003a

			IL_0027: ldc.i4.0
			IL_0028: newobj instance void MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::.ctor(int32)
			IL_002d: stloc.0
			IL_002e: ldloc.0
			IL_002f: ldarg.0
			IL_0030: ldfld class MMP.AsyncProxy.Training.Printer.Async.NaiveDesk MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<>4__this'
			IL_0035: stfld class MMP.AsyncProxy.Training.Printer.Async.NaiveDesk MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<>4__this'

			IL_003a: ldloc.0
			IL_003b: ldarg.0
			IL_003c: ldfld string[] MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<>3__receipts'
			IL_0041: stfld string[] MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::receipts
			IL_0046: ldloc.0
			IL_0047: ldarg.0
			IL_0048: ldfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<>3__feedMs'
			IL_004d: stfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::feedMs
			IL_0052: ldloc.0
			IL_0053: ldarg.0
			IL_0054: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Printer.PrintReport> MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<>3__ret'
			IL_0059: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Printer.PrintReport> MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'ret'
			IL_005e: ldloc.0
			IL_005f: ret
		} // end of method '<Body>d__10'::'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator'

		.method private final hidebysig newslot virtual 
			instance class [mscorlib]System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance class [mscorlib]System.Collections.IEnumerator [mscorlib]System.Collections.IEnumerable::GetEnumerator()
			// Method begins at RVA 0x4914
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator'()
			IL_0006: ret
		} // end of method '<Body>d__10'::System.Collections.IEnumerable.GetEnumerator

		// Properties
		.property instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.Current'()
		{
			.get instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current'()
		}
		.property instance object System.Collections.IEnumerator.Current()
		{
			.get instance object MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::System.Collections.IEnumerator.get_Current()
		}

	} // end of class <Body>d__10


	// Fields
	.field private initonly class MMP.AsyncProxy.Training.Support.OwnerThread _owner
	.field private initonly class MMP.AsyncProxy.Training.Printer.ReceiptPrinter _printer

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x263d
		// Header size: 1
		// Code size: 57 (0x39)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldstr "printer"
		IL_0006: newobj instance void MMP.AsyncProxy.Training.Support.OwnerThread::.ctor(string)
		IL_000b: stfld class MMP.AsyncProxy.Training.Support.OwnerThread MMP.AsyncProxy.Training.Printer.Async.NaiveDesk::_owner
		IL_0010: ldarg.0
		IL_0011: newobj instance void MMP.AsyncProxy.Training.Printer.ReceiptPrinter::.ctor()
		IL_0016: stfld class MMP.AsyncProxy.Training.Printer.ReceiptPrinter MMP.AsyncProxy.Training.Printer.Async.NaiveDesk::_printer
		IL_001b: ldarg.0
		IL_001c: call instance void [mscorlib]System.Object::.ctor()
		IL_0021: ldarg.0
		IL_0022: ldfld class MMP.AsyncProxy.Training.Support.OwnerThread MMP.AsyncProxy.Training.Printer.Async.NaiveDesk::_owner
		IL_0027: ldarg.0
		IL_0028: ldftn instance void MMP.AsyncProxy.Training.Printer.Async.NaiveDesk::'<.ctor>b__2_0'()
		IL_002e: newobj instance void [System.Core]System.Action::.ctor(object, native int)
		IL_0033: callvirt instance void MMP.AsyncProxy.Training.Support.OwnerThread::Invoke(class [System.Core]System.Action)
		IL_0038: ret
	} // end of method NaiveDesk::.ctor

	.method public final hidebysig specialname newslot virtual 
		instance string get_Version () cil managed 
	{
		// Method begins at RVA 0x2677
		// Header size: 1
		// Code size: 6 (0x6)
		.maxstack 8

		IL_0000: ldstr "async-naive"
		IL_0005: ret
	} // end of method NaiveDesk::get_Version

	.method public final hidebysig specialname newslot virtual 
		instance class MMP.AsyncProxy.Training.Printer.ReceiptPrinter get_Printer () cil managed 
	{
		// Method begins at RVA 0x267e
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld class MMP.AsyncProxy.Training.Printer.ReceiptPrinter MMP.AsyncProxy.Training.Printer.Async.NaiveDesk::_printer
		IL_0006: ret
	} // end of method NaiveDesk::get_Printer

	.method public final hidebysig specialname newslot virtual 
		instance int32 get_OwnerThreadId () cil managed 
	{
		// Method begins at RVA 0x2686
		// Header size: 1
		// Code size: 12 (0xc)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld class MMP.AsyncProxy.Training.Support.OwnerThread MMP.AsyncProxy.Training.Printer.Async.NaiveDesk::_owner
		IL_0006: callvirt instance int32 MMP.AsyncProxy.Training.Support.OwnerThread::get_ThreadId()
		IL_000b: ret
	} // end of method NaiveDesk::get_OwnerThreadId

	.method public final hidebysig newslot virtual 
		instance class MMP.AsyncProxy.Training.Printer.PrintReport PrintJob (
			string[] receipts,
			int32 feedMs
		) cil managed 
	{
		// Method begins at RVA 0x2693
		// Header size: 1
		// Code size: 48 (0x30)
		.maxstack 8

		IL_0000: newobj instance void MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<>c__DisplayClass9_0'::.ctor()
		IL_0005: dup
		IL_0006: ldarg.0
		IL_0007: stfld class MMP.AsyncProxy.Training.Printer.Async.NaiveDesk MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<>c__DisplayClass9_0'::'<>4__this'
		IL_000c: dup
		IL_000d: ldarg.1
		IL_000e: stfld string[] MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<>c__DisplayClass9_0'::receipts
		IL_0013: dup
		IL_0014: ldarg.2
		IL_0015: stfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<>c__DisplayClass9_0'::feedMs
		IL_001a: ldftn instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<>c__DisplayClass9_0'::'<PrintJob>b__0'(class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Printer.PrintReport>)
		IL_0020: newobj instance void class [System.Core]System.Func`2<class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Printer.PrintReport>, class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>>::.ctor(object, native int)
		IL_0025: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!!0> [MMP.AsyncProxy]MMP.AsyncProxy.AsyncProxy::Run<class MMP.AsyncProxy.Training.Printer.PrintReport>(class [System.Core]System.Func`2<class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<!!0>, class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>>)
		IL_002a: callvirt instance !0 class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class MMP.AsyncProxy.Training.Printer.PrintReport>::get_Result()
		IL_002f: ret
	} // end of method NaiveDesk::PrintJob

	.method private hidebysig 
		instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> Body (
			string[] receipts,
			int32 feedMs,
			class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Printer.PrintReport> 'ret'
		) cil managed 
	{
		// Method begins at RVA 0x26c4
		// Header size: 1
		// Code size: 36 (0x24)
		.maxstack 8

		IL_0000: ldc.i4.s -2
		IL_0002: newobj instance void MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::.ctor(int32)
		IL_0007: dup
		IL_0008: ldarg.0
		IL_0009: stfld class MMP.AsyncProxy.Training.Printer.Async.NaiveDesk MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<>4__this'
		IL_000e: dup
		IL_000f: ldarg.1
		IL_0010: stfld string[] MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<>3__receipts'
		IL_0015: dup
		IL_0016: ldarg.2
		IL_0017: stfld int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<>3__feedMs'
		IL_001c: dup
		IL_001d: ldarg.3
		IL_001e: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Printer.PrintReport> MMP.AsyncProxy.Training.Printer.Async.NaiveDesk/'<Body>d__10'::'<>3__ret'
		IL_0023: ret
	} // end of method NaiveDesk::Body

	.method public final hidebysig newslot virtual 
		instance void Dispose () cil managed 
	{
		// Method begins at RVA 0x26e9
		// Header size: 1
		// Code size: 12 (0xc)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld class MMP.AsyncProxy.Training.Support.OwnerThread MMP.AsyncProxy.Training.Printer.Async.NaiveDesk::_owner
		IL_0006: callvirt instance void MMP.AsyncProxy.Training.Support.OwnerThread::Dispose()
		IL_000b: ret
	} // end of method NaiveDesk::Dispose

	.method private hidebysig 
		instance void '<.ctor>b__2_0' () cil managed 
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Method begins at RVA 0x26f6
		// Header size: 1
		// Code size: 12 (0xc)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld class MMP.AsyncProxy.Training.Printer.ReceiptPrinter MMP.AsyncProxy.Training.Printer.Async.NaiveDesk::_printer
		IL_0006: callvirt instance void MMP.AsyncProxy.Training.Printer.ReceiptPrinter::Open()
		IL_000b: ret
	} // end of method NaiveDesk::'<.ctor>b__2_0'

	// Properties
	.property instance string Version()
	{
		.get instance string MMP.AsyncProxy.Training.Printer.Async.NaiveDesk::get_Version()
	}
	.property instance class MMP.AsyncProxy.Training.Printer.ReceiptPrinter Printer()
	{
		.get instance class MMP.AsyncProxy.Training.Printer.ReceiptPrinter MMP.AsyncProxy.Training.Printer.Async.NaiveDesk::get_Printer()
	}
	.property instance int32 OwnerThreadId()
	{
		.get instance int32 MMP.AsyncProxy.Training.Printer.Async.NaiveDesk::get_OwnerThreadId()
	}

} // end of class MMP.AsyncProxy.Training.Printer.Async.NaiveDesk

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Printer.Async.PostBackDesk
	extends [mscorlib]System.Object
	implements MMP.AsyncProxy.Training.Printer.IReceiptDesk,
	           [mscorlib]System.IDisposable
{
	// Nested Types
	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass9_0'
		extends [mscorlib]System.Object
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field public class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class MMP.AsyncProxy.Training.Printer.PrintReport> job
		.field public class MMP.AsyncProxy.Training.Printer.Async.PostBackDesk '<>4__this'
		.field public string[] receipts
		.field public int32 feedMs

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor () cil managed 
		{
			// Method begins at RVA 0x491c
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass9_0'::.ctor

		.method assembly hidebysig 
			instance void '<PrintJob>b__0' () cil managed 
		{
			// Method begins at RVA 0x4924
			// Header size: 1
			// Code size: 24 (0x18)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldarg.0
			IL_0002: ldftn instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<>c__DisplayClass9_0'::'<PrintJob>b__1'(class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Printer.PrintReport>)
			IL_0008: newobj instance void class [System.Core]System.Func`2<class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Printer.PrintReport>, class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>>::.ctor(object, native int)
			IL_000d: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!!0> [MMP.AsyncProxy]MMP.AsyncProxy.AsyncProxy::Run<class MMP.AsyncProxy.Training.Printer.PrintReport>(class [System.Core]System.Func`2<class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<!!0>, class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>>)
			IL_0012: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class MMP.AsyncProxy.Training.Printer.PrintReport> MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<>c__DisplayClass9_0'::job
			IL_0017: ret
		} // end of method '<>c__DisplayClass9_0'::'<PrintJob>b__0'

		.method assembly hidebysig 
			instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> '<PrintJob>b__1' (
				class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Printer.PrintReport> 'ret'
			) cil managed 
		{
			// Method begins at RVA 0x493d
			// Header size: 1
			// Code size: 25 (0x19)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class MMP.AsyncProxy.Training.Printer.Async.PostBackDesk MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<>c__DisplayClass9_0'::'<>4__this'
			IL_0006: ldarg.0
			IL_0007: ldfld string[] MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<>c__DisplayClass9_0'::receipts
			IL_000c: ldarg.0
			IL_000d: ldfld int32 MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<>c__DisplayClass9_0'::feedMs
			IL_0012: ldarg.1
			IL_0013: call instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Printer.Async.PostBackDesk::Body(string[], int32, class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Printer.PrintReport>)
			IL_0018: ret
		} // end of method '<>c__DisplayClass9_0'::'<PrintJob>b__1'

	} // end of class <>c__DisplayClass9_0

	.class nested private auto ansi sealed beforefieldinit '<Body>d__10'
		extends [mscorlib]System.Object
		implements class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>,
		           [mscorlib]System.Collections.IEnumerable,
		           class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>,
		           [mscorlib]System.IDisposable,
		           [mscorlib]System.Collections.IEnumerator
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field private int32 '<>1__state'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture '<>2__current'
		.field private int32 '<>l__initialThreadId'
		.field public class MMP.AsyncProxy.Training.Printer.Async.PostBackDesk '<>4__this'
		.field private string[] receipts
		.field public string[] '<>3__receipts'
		.field private int32 feedMs
		.field public int32 '<>3__feedMs'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Printer.PrintReport> 'ret'
		.field public class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Printer.PrintReport> '<>3__ret'
		.field private int32 '<printed>5__2'
		.field private int32 '<i>5__3'

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor (
				int32 '<>1__state'
			) cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			// Method begins at RVA 0x4957
			// Header size: 1
			// Code size: 30 (0x1e)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ldarg.0
			IL_0007: ldarg.1
			IL_0008: stfld int32 MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<>1__state'
			IL_000d: ldarg.0
			IL_000e: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0013: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_0018: stfld int32 MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<>l__initialThreadId'
			IL_001d: ret
		} // end of method '<Body>d__10'::.ctor

		.method private final hidebysig newslot virtual 
			instance void System.IDisposable.Dispose () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [mscorlib]System.IDisposable::Dispose()
			// Method begins at RVA 0x4976
			// Header size: 1
			// Code size: 9 (0x9)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldc.i4.s -2
			IL_0003: stfld int32 MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<>1__state'
			IL_0008: ret
		} // end of method '<Body>d__10'::System.IDisposable.Dispose

		.method private final hidebysig newslot virtual 
			instance bool MoveNext () cil managed 
		{
			.override method instance bool [mscorlib]System.Collections.IEnumerator::MoveNext()
			// Method begins at RVA 0x4980
			// Header size: 12
			// Code size: 177 (0xb1)
			.maxstack 4
			.locals init (
				[0] int32,
				[1] class MMP.AsyncProxy.Training.Printer.Async.PostBackDesk,
				[2] int32
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<>1__state'
			IL_0006: stloc.0
			IL_0007: ldarg.0
			IL_0008: ldfld class MMP.AsyncProxy.Training.Printer.Async.PostBackDesk MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<>4__this'
			IL_000d: stloc.1
			IL_000e: ldloc.0
			IL_000f: brfalse.s IL_0017

			IL_0011: ldloc.0
			IL_0012: ldc.i4.1
			IL_0013: beq.s IL_0070

			IL_0015: ldc.i4.0
			IL_0016: ret

			IL_0017: ldarg.0
			IL_0018: ldc.i4.m1
			IL_0019: stfld int32 MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<>1__state'
			IL_001e: ldarg.0
			IL_001f: ldc.i4.0
			IL_0020: stfld int32 MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<printed>5__2'
			IL_0025: ldarg.0
			IL_0026: ldc.i4.0
			IL_0027: stfld int32 MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<i>5__3'
			IL_002c: br.s IL_0087

			IL_002e: ldloc.1
			IL_002f: ldfld class MMP.AsyncProxy.Training.Printer.ReceiptPrinter MMP.AsyncProxy.Training.Printer.Async.PostBackDesk::_printer
			IL_0034: ldarg.0
			IL_0035: ldfld string[] MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::receipts
			IL_003a: ldarg.0
			IL_003b: ldfld int32 MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<i>5__3'
			IL_0040: ldelem.ref
			IL_0041: callvirt instance void MMP.AsyncProxy.Training.Printer.ReceiptPrinter::PrintLine(string)
			IL_0046: ldarg.0
			IL_0047: ldfld int32 MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<printed>5__2'
			IL_004c: stloc.2
			IL_004d: ldarg.0
			IL_004e: ldloc.2
			IL_004f: ldc.i4.1
			IL_0050: add
			IL_0051: stfld int32 MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<printed>5__2'
			IL_0056: ldarg.0
			IL_0057: ldarg.0
			IL_0058: ldfld int32 MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::feedMs
			IL_005d: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture [MMP.AsyncProxy]MMP.AsyncProxy.Futures::Delay(int32)
			IL_0062: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<>2__current'
			IL_0067: ldarg.0
			IL_0068: ldc.i4.1
			IL_0069: stfld int32 MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<>1__state'
			IL_006e: ldc.i4.1
			IL_006f: ret

			IL_0070: ldarg.0
			IL_0071: ldc.i4.m1
			IL_0072: stfld int32 MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<>1__state'
			IL_0077: ldarg.0
			IL_0078: ldfld int32 MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<i>5__3'
			IL_007d: stloc.2
			IL_007e: ldarg.0
			IL_007f: ldloc.2
			IL_0080: ldc.i4.1
			IL_0081: add
			IL_0082: stfld int32 MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<i>5__3'

			IL_0087: ldarg.0
			IL_0088: ldfld int32 MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<i>5__3'
			IL_008d: ldarg.0
			IL_008e: ldfld string[] MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::receipts
			IL_0093: ldlen
			IL_0094: conv.i4
			IL_0095: blt.s IL_002e

			IL_0097: ldarg.0
			IL_0098: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Printer.PrintReport> MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'ret'
			IL_009d: ldarg.0
			IL_009e: ldfld int32 MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<printed>5__2'
			IL_00a3: ldc.i4.0
			IL_00a4: ldnull
			IL_00a5: newobj instance void MMP.AsyncProxy.Training.Printer.PrintReport::.ctor(int32, int32, string)
			IL_00aa: callvirt instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Printer.PrintReport>::set_Value(!0)
			IL_00af: ldc.i4.0
			IL_00b0: ret
		} // end of method '<Body>d__10'::MoveNext

		.method private final hidebysig specialname newslot virtual 
			instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance !0 class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::get_Current()
			// Method begins at RVA 0x4a3d
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<>2__current'
			IL_0006: ret
		} // end of method '<Body>d__10'::'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current'

		.method private final hidebysig newslot virtual 
			instance void System.Collections.IEnumerator.Reset () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [mscorlib]System.Collections.IEnumerator::Reset()
			// Method begins at RVA 0x4a45
			// Header size: 1
			// Code size: 6 (0x6)
			.maxstack 8

			IL_0000: newobj instance void [mscorlib]System.NotSupportedException::.ctor()
			IL_0005: throw
		} // end of method '<Body>d__10'::System.Collections.IEnumerator.Reset

		.method private final hidebysig specialname newslot virtual 
			instance object System.Collections.IEnumerator.get_Current () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance object [mscorlib]System.Collections.IEnumerator::get_Current()
			// Method begins at RVA 0x4a4c
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<>2__current'
			IL_0006: ret
		} // end of method '<Body>d__10'::System.Collections.IEnumerator.get_Current

		.method private final hidebysig newslot virtual 
			instance class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> 'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance class [mscorlib]System.Collections.Generic.IEnumerator`1<!0> class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::GetEnumerator()
			// Method begins at RVA 0x4a54
			// Header size: 12
			// Code size: 96 (0x60)
			.maxstack 2
			.locals init (
				[0] class MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<>1__state'
			IL_0006: ldc.i4.s -2
			IL_0008: bne.un.s IL_0027

			IL_000a: ldarg.0
			IL_000b: ldfld int32 MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<>l__initialThreadId'
			IL_0010: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0015: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_001a: bne.un.s IL_0027

			IL_001c: ldarg.0
			IL_001d: ldc.i4.0
			IL_001e: stfld int32 MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<>1__state'
			IL_0023: ldarg.0
			IL_0024: stloc.0
			IL_0025: br.s IL_003a

			IL_0027: ldc.i4.0
			IL_0028: newobj instance void MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::.ctor(int32)
			IL_002d: stloc.0
			IL_002e: ldloc.0
			IL_002f: ldarg.0
			IL_0030: ldfld class MMP.AsyncProxy.Training.Printer.Async.PostBackDesk MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<>4__this'
			IL_0035: stfld class MMP.AsyncProxy.Training.Printer.Async.PostBackDesk MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<>4__this'

			IL_003a: ldloc.0
			IL_003b: ldarg.0
			IL_003c: ldfld string[] MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<>3__receipts'
			IL_0041: stfld string[] MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::receipts
			IL_0046: ldloc.0
			IL_0047: ldarg.0
			IL_0048: ldfld int32 MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<>3__feedMs'
			IL_004d: stfld int32 MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::feedMs
			IL_0052: ldloc.0
			IL_0053: ldarg.0
			IL_0054: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Printer.PrintReport> MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<>3__ret'
			IL_0059: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Printer.PrintReport> MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'ret'
			IL_005e: ldloc.0
			IL_005f: ret
		} // end of method '<Body>d__10'::'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator'

		.method private final hidebysig newslot virtual 
			instance class [mscorlib]System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance class [mscorlib]System.Collections.IEnumerator [mscorlib]System.Collections.IEnumerable::GetEnumerator()
			// Method begins at RVA 0x4ac0
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator'()
			IL_0006: ret
		} // end of method '<Body>d__10'::System.Collections.IEnumerable.GetEnumerator

		// Properties
		.property instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.Current'()
		{
			.get instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current'()
		}
		.property instance object System.Collections.IEnumerator.Current()
		{
			.get instance object MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::System.Collections.IEnumerator.get_Current()
		}

	} // end of class <Body>d__10


	// Fields
	.field private initonly class MMP.AsyncProxy.Training.Support.OwnerThread _owner
	.field private initonly class MMP.AsyncProxy.Training.Printer.ReceiptPrinter _printer

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x2703
		// Header size: 1
		// Code size: 57 (0x39)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldstr "printer"
		IL_0006: newobj instance void MMP.AsyncProxy.Training.Support.OwnerThread::.ctor(string)
		IL_000b: stfld class MMP.AsyncProxy.Training.Support.OwnerThread MMP.AsyncProxy.Training.Printer.Async.PostBackDesk::_owner
		IL_0010: ldarg.0
		IL_0011: newobj instance void MMP.AsyncProxy.Training.Printer.ReceiptPrinter::.ctor()
		IL_0016: stfld class MMP.AsyncProxy.Training.Printer.ReceiptPrinter MMP.AsyncProxy.Training.Printer.Async.PostBackDesk::_printer
		IL_001b: ldarg.0
		IL_001c: call instance void [mscorlib]System.Object::.ctor()
		IL_0021: ldarg.0
		IL_0022: ldfld class MMP.AsyncProxy.Training.Support.OwnerThread MMP.AsyncProxy.Training.Printer.Async.PostBackDesk::_owner
		IL_0027: ldarg.0
		IL_0028: ldftn instance void MMP.AsyncProxy.Training.Printer.Async.PostBackDesk::'<.ctor>b__2_0'()
		IL_002e: newobj instance void [System.Core]System.Action::.ctor(object, native int)
		IL_0033: callvirt instance void MMP.AsyncProxy.Training.Support.OwnerThread::Invoke(class [System.Core]System.Action)
		IL_0038: ret
	} // end of method PostBackDesk::.ctor

	.method public final hidebysig specialname newslot virtual 
		instance string get_Version () cil managed 
	{
		// Method begins at RVA 0x273d
		// Header size: 1
		// Code size: 6 (0x6)
		.maxstack 8

		IL_0000: ldstr "async-postback"
		IL_0005: ret
	} // end of method PostBackDesk::get_Version

	.method public final hidebysig specialname newslot virtual 
		instance class MMP.AsyncProxy.Training.Printer.ReceiptPrinter get_Printer () cil managed 
	{
		// Method begins at RVA 0x2744
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld class MMP.AsyncProxy.Training.Printer.ReceiptPrinter MMP.AsyncProxy.Training.Printer.Async.PostBackDesk::_printer
		IL_0006: ret
	} // end of method PostBackDesk::get_Printer

	.method public final hidebysig specialname newslot virtual 
		instance int32 get_OwnerThreadId () cil managed 
	{
		// Method begins at RVA 0x274c
		// Header size: 1
		// Code size: 12 (0xc)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld class MMP.AsyncProxy.Training.Support.OwnerThread MMP.AsyncProxy.Training.Printer.Async.PostBackDesk::_owner
		IL_0006: callvirt instance int32 MMP.AsyncProxy.Training.Support.OwnerThread::get_ThreadId()
		IL_000b: ret
	} // end of method PostBackDesk::get_OwnerThreadId

	.method public final hidebysig newslot virtual 
		instance class MMP.AsyncProxy.Training.Printer.PrintReport PrintJob (
			string[] receipts,
			int32 feedMs
		) cil managed 
	{
		// Method begins at RVA 0x275c
		// Header size: 12
		// Code size: 69 (0x45)
		.maxstack 3
		.locals init (
			[0] class MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<>c__DisplayClass9_0'
		)

		IL_0000: newobj instance void MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<>c__DisplayClass9_0'::.ctor()
		IL_0005: stloc.0
		IL_0006: ldloc.0
		IL_0007: ldarg.0
		IL_0008: stfld class MMP.AsyncProxy.Training.Printer.Async.PostBackDesk MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<>c__DisplayClass9_0'::'<>4__this'
		IL_000d: ldloc.0
		IL_000e: ldarg.1
		IL_000f: stfld string[] MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<>c__DisplayClass9_0'::receipts
		IL_0014: ldloc.0
		IL_0015: ldarg.2
		IL_0016: stfld int32 MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<>c__DisplayClass9_0'::feedMs
		IL_001b: ldloc.0
		IL_001c: ldnull
		IL_001d: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class MMP.AsyncProxy.Training.Printer.PrintReport> MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<>c__DisplayClass9_0'::job
		IL_0022: ldarg.0
		IL_0023: ldfld class MMP.AsyncProxy.Training.Support.OwnerThread MMP.AsyncProxy.Training.Printer.Async.PostBackDesk::_owner
		IL_0028: ldloc.0
		IL_0029: ldftn instance void MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<>c__DisplayClass9_0'::'<PrintJob>b__0'()
		IL_002f: newobj instance void [System.Core]System.Action::.ctor(object, native int)
		IL_0034: callvirt instance void MMP.AsyncProxy.Training.Support.OwnerThread::Invoke(class [System.Core]System.Action)
		IL_0039: ldloc.0
		IL_003a: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class MMP.AsyncProxy.Training.Printer.PrintReport> MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<>c__DisplayClass9_0'::job
		IL_003f: callvirt instance !0 class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class MMP.AsyncProxy.Training.Printer.PrintReport>::get_Result()
		IL_0044: ret
	} // end of method PostBackDesk::PrintJob

	.method private hidebysig 
		instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> Body (
			string[] receipts,
			int32 feedMs,
			class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Printer.PrintReport> 'ret'
		) cil managed 
	{
		// Method begins at RVA 0x27ad
		// Header size: 1
		// Code size: 36 (0x24)
		.maxstack 8

		IL_0000: ldc.i4.s -2
		IL_0002: newobj instance void MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::.ctor(int32)
		IL_0007: dup
		IL_0008: ldarg.0
		IL_0009: stfld class MMP.AsyncProxy.Training.Printer.Async.PostBackDesk MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<>4__this'
		IL_000e: dup
		IL_000f: ldarg.1
		IL_0010: stfld string[] MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<>3__receipts'
		IL_0015: dup
		IL_0016: ldarg.2
		IL_0017: stfld int32 MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<>3__feedMs'
		IL_001c: dup
		IL_001d: ldarg.3
		IL_001e: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Printer.PrintReport> MMP.AsyncProxy.Training.Printer.Async.PostBackDesk/'<Body>d__10'::'<>3__ret'
		IL_0023: ret
	} // end of method PostBackDesk::Body

	.method public final hidebysig newslot virtual 
		instance void Dispose () cil managed 
	{
		// Method begins at RVA 0x27d2
		// Header size: 1
		// Code size: 12 (0xc)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld class MMP.AsyncProxy.Training.Support.OwnerThread MMP.AsyncProxy.Training.Printer.Async.PostBackDesk::_owner
		IL_0006: callvirt instance void MMP.AsyncProxy.Training.Support.OwnerThread::Dispose()
		IL_000b: ret
	} // end of method PostBackDesk::Dispose

	.method private hidebysig 
		instance void '<.ctor>b__2_0' () cil managed 
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Method begins at RVA 0x27df
		// Header size: 1
		// Code size: 12 (0xc)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld class MMP.AsyncProxy.Training.Printer.ReceiptPrinter MMP.AsyncProxy.Training.Printer.Async.PostBackDesk::_printer
		IL_0006: callvirt instance void MMP.AsyncProxy.Training.Printer.ReceiptPrinter::Open()
		IL_000b: ret
	} // end of method PostBackDesk::'<.ctor>b__2_0'

	// Properties
	.property instance string Version()
	{
		.get instance string MMP.AsyncProxy.Training.Printer.Async.PostBackDesk::get_Version()
	}
	.property instance class MMP.AsyncProxy.Training.Printer.ReceiptPrinter Printer()
	{
		.get instance class MMP.AsyncProxy.Training.Printer.ReceiptPrinter MMP.AsyncProxy.Training.Printer.Async.PostBackDesk::get_Printer()
	}
	.property instance int32 OwnerThreadId()
	{
		.get instance int32 MMP.AsyncProxy.Training.Printer.Async.PostBackDesk::get_OwnerThreadId()
	}

} // end of class MMP.AsyncProxy.Training.Printer.Async.PostBackDesk

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Pipeline.LineResult
	extends [mscorlib]System.Object
{
	// Fields
	.field private initonly int32[] _outputs
	.field private initonly int32[] _dropped
	.field private initonly int32 _inFlightPeak

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			int32[] outputs,
			int32[] dropped,
			int32 inFlightPeak
		) cil managed 
	{
		// Method begins at RVA 0x27ec
		// Header size: 1
		// Code size: 28 (0x1c)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: call instance void [mscorlib]System.Object::.ctor()
		IL_0006: ldarg.0
		IL_0007: ldarg.1
		IL_0008: stfld int32[] MMP.AsyncProxy.Training.Pipeline.LineResult::_outputs
		IL_000d: ldarg.0
		IL_000e: ldarg.2
		IL_000f: stfld int32[] MMP.AsyncProxy.Training.Pipeline.LineResult::_dropped
		IL_0014: ldarg.0
		IL_0015: ldarg.3
		IL_0016: stfld int32 MMP.AsyncProxy.Training.Pipeline.LineResult::_inFlightPeak
		IL_001b: ret
	} // end of method LineResult::.ctor

	.method public hidebysig specialname 
		instance int32[] get_Outputs () cil managed 
	{
		// Method begins at RVA 0x2809
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld int32[] MMP.AsyncProxy.Training.Pipeline.LineResult::_outputs
		IL_0006: ret
	} // end of method LineResult::get_Outputs

	.method public hidebysig specialname 
		instance int32[] get_Dropped () cil managed 
	{
		// Method begins at RVA 0x2811
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld int32[] MMP.AsyncProxy.Training.Pipeline.LineResult::_dropped
		IL_0006: ret
	} // end of method LineResult::get_Dropped

	.method public hidebysig specialname 
		instance int32 get_InFlightPeak () cil managed 
	{
		// Method begins at RVA 0x2819
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld int32 MMP.AsyncProxy.Training.Pipeline.LineResult::_inFlightPeak
		IL_0006: ret
	} // end of method LineResult::get_InFlightPeak

	// Properties
	.property instance int32[] Outputs()
	{
		.get instance int32[] MMP.AsyncProxy.Training.Pipeline.LineResult::get_Outputs()
	}
	.property instance int32[] Dropped()
	{
		.get instance int32[] MMP.AsyncProxy.Training.Pipeline.LineResult::get_Dropped()
	}
	.property instance int32 InFlightPeak()
	{
		.get instance int32 MMP.AsyncProxy.Training.Pipeline.LineResult::get_InFlightPeak()
	}

} // end of class MMP.AsyncProxy.Training.Pipeline.LineResult

.class interface public auto ansi abstract beforefieldinit MMP.AsyncProxy.Training.Pipeline.IAssemblyLine
	implements [mscorlib]System.IDisposable
{
	// Methods
	.method public hidebysig specialname newslot abstract virtual 
		instance string get_Version () cil managed 
	{
	} // end of method IAssemblyLine::get_Version

	.method public hidebysig newslot abstract virtual 
		instance class MMP.AsyncProxy.Training.Pipeline.LineResult Run (
			int32[] inputs,
			int32 trayCapacity,
			int32 writeDelayMs
		) cil managed 
	{
	} // end of method IAssemblyLine::Run

	// Properties
	.property instance string Version()
	{
		.get instance string MMP.AsyncProxy.Training.Pipeline.IAssemblyLine::get_Version()
	}

} // end of class MMP.AsyncProxy.Training.Pipeline.IAssemblyLine

.class public auto ansi abstract sealed beforefieldinit MMP.AsyncProxy.Training.Pipeline.Stages
	extends [mscorlib]System.Object
{
	// Fields
	.field public static literal int32 Poison = int32(13)

	// Methods
	.method public hidebysig static 
		int32 Parse (
			int32 x
		) cil managed 
	{
		// Method begins at RVA 0x2821
		// Header size: 1
		// Code size: 4 (0x4)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldc.i4.1
		IL_0002: add
		IL_0003: ret
	} // end of method Stages::Parse

	.method public hidebysig static 
		int32 Enrich (
			int32 x
		) cil managed 
	{
		// Method begins at RVA 0x2826
		// Header size: 1
		// Code size: 32 (0x20)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldc.i4.s 13
		IL_0003: bne.un.s IL_001c

		IL_0005: ldstr "poison item "
		IL_000a: ldarga.s x
		IL_000c: call instance string [mscorlib]System.Int32::ToString()
		IL_0011: call string [mscorlib]System.String::Concat(string, string)
		IL_0016: newobj instance void [mscorlib]System.InvalidOperationException::.ctor(string)
		IL_001b: throw

		IL_001c: ldarg.0
		IL_001d: ldc.i4.2
		IL_001e: mul
		IL_001f: ret
	} // end of method Stages::Enrich

} // end of class MMP.AsyncProxy.Training.Pipeline.Stages

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Pipeline.InFlightMeter
	extends [mscorlib]System.Object
{
	// Fields
	.field private int32 _now
	.field private int32 _peak

	// Methods
	.method public hidebysig 
		instance void Entered () cil managed 
	{
		// Method begins at RVA 0x2848
		// Header size: 12
		// Code size: 41 (0x29)
		.maxstack 3
		.locals init (
			[0] int32,
			[1] int32
		)

		IL_0000: ldarg.0
		IL_0001: ldflda int32 MMP.AsyncProxy.Training.Pipeline.InFlightMeter::_now
		IL_0006: call int32 [mscorlib]System.Threading.Interlocked::Increment(int32&)
		IL_000b: stloc.0
		// loop start (head: IL_000c)
			IL_000c: ldarg.0
			IL_000d: ldfld int32 MMP.AsyncProxy.Training.Pipeline.InFlightMeter::_peak
			IL_0012: stloc.1
			IL_0013: ldloc.0
			IL_0014: ldloc.1
			IL_0015: bgt.s IL_0018

			IL_0017: ret

			IL_0018: ldarg.0
			IL_0019: ldflda int32 MMP.AsyncProxy.Training.Pipeline.InFlightMeter::_peak
			IL_001e: ldloc.0
			IL_001f: ldloc.1
			IL_0020: call int32 [mscorlib]System.Threading.Interlocked::CompareExchange(int32&, int32, int32)
			IL_0025: ldloc.1
			IL_0026: bne.un.s IL_000c
		// end loop
		IL_0028: ret
	} // end of method InFlightMeter::Entered

	.method public hidebysig 
		instance void Left () cil managed 
	{
		// Method begins at RVA 0x287d
		// Header size: 1
		// Code size: 13 (0xd)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldflda int32 MMP.AsyncProxy.Training.Pipeline.InFlightMeter::_now
		IL_0006: call int32 [mscorlib]System.Threading.Interlocked::Decrement(int32&)
		IL_000b: pop
		IL_000c: ret
	} // end of method InFlightMeter::Left

	.method public hidebysig specialname 
		instance int32 get_Peak () cil managed 
	{
		// Method begins at RVA 0x288b
		// Header size: 1
		// Code size: 14 (0xe)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldflda int32 MMP.AsyncProxy.Training.Pipeline.InFlightMeter::_peak
		IL_0006: ldc.i4.0
		IL_0007: ldc.i4.0
		IL_0008: call int32 [mscorlib]System.Threading.Interlocked::CompareExchange(int32&, int32, int32)
		IL_000d: ret
	} // end of method InFlightMeter::get_Peak

	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x289a
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: call instance void [mscorlib]System.Object::.ctor()
		IL_0006: ret
	} // end of method InFlightMeter::.ctor

	// Properties
	.property instance int32 Peak()
	{
		.get instance int32 MMP.AsyncProxy.Training.Pipeline.InFlightMeter::get_Peak()
	}

} // end of class MMP.AsyncProxy.Training.Pipeline.InFlightMeter

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<T>
	extends [mscorlib]System.Object
{
	// Fields
	.field private initonly object _gate
	.field private initonly class [System]System.Collections.Generic.Queue`1<!T> _items
	.field private initonly int32 _capacity
	.field private bool _closed

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			int32 capacity
		) cil managed 
	{
		// Method begins at RVA 0x28a2
		// Header size: 1
		// Code size: 36 (0x24)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: newobj instance void [mscorlib]System.Object::.ctor()
		IL_0006: stfld object class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<!T>::_gate
		IL_000b: ldarg.0
		IL_000c: newobj instance void class [System]System.Collections.Generic.Queue`1<!T>::.ctor()
		IL_0011: stfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<!T>::_items
		IL_0016: ldarg.0
		IL_0017: call instance void [mscorlib]System.Object::.ctor()
		IL_001c: ldarg.0
		IL_001d: ldarg.1
		IL_001e: stfld int32 class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<!T>::_capacity
		IL_0023: ret
	} // end of method BlockingTray`1::.ctor

	.method public hidebysig 
		instance bool Put (
			!T item
		) cil managed 
	{
		// Method begins at RVA 0x28c8
		// Header size: 12
		// Code size: 94 (0x5e)
		.maxstack 2
		.locals init (
			[0] object,
			[1] bool
		)

		IL_0000: ldarg.0
		IL_0001: ldfld object class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<!T>::_gate
		IL_0006: stloc.0
		IL_0007: ldloc.0
		IL_0008: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_000d: br.s IL_0027
			// loop start (head: IL_0027)
				IL_000f: ldarg.0
				IL_0010: ldfld bool class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<!T>::_closed
				IL_0015: brfalse.s IL_001b

				IL_0017: ldc.i4.0
				IL_0018: stloc.1
				IL_0019: leave.s IL_005c

				IL_001b: ldarg.0
				IL_001c: ldfld object class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<!T>::_gate
				IL_0021: call bool [mscorlib]System.Threading.Monitor::Wait(object)
				IL_0026: pop

				IL_0027: ldarg.0
				IL_0028: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<!T>::_items
				IL_002d: callvirt instance int32 class [System]System.Collections.Generic.Queue`1<!T>::get_Count()
				IL_0032: ldarg.0
				IL_0033: ldfld int32 class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<!T>::_capacity
				IL_0038: bge.s IL_000f
			// end loop

			IL_003a: ldarg.0
			IL_003b: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<!T>::_items
			IL_0040: ldarg.1
			IL_0041: callvirt instance void class [System]System.Collections.Generic.Queue`1<!T>::Enqueue(!0)
			IL_0046: ldarg.0
			IL_0047: ldfld object class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<!T>::_gate
			IL_004c: call void [mscorlib]System.Threading.Monitor::PulseAll(object)
			IL_0051: ldc.i4.1
			IL_0052: stloc.1
			IL_0053: leave.s IL_005c
		} // end .try
		finally
		{
			IL_0055: ldloc.0
			IL_0056: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_005b: endfinally
		} // end handler

		IL_005c: ldloc.1
		IL_005d: ret
	} // end of method BlockingTray`1::Put

	.method public hidebysig 
		instance bool Take (
			[out] !T& item
		) cil managed 
	{
		// Method begins at RVA 0x2944
		// Header size: 12
		// Code size: 100 (0x64)
		.maxstack 2
		.locals init (
			[0] object,
			[1] bool
		)

		IL_0000: ldarg.0
		IL_0001: ldfld object class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<!T>::_gate
		IL_0006: stloc.0
		IL_0007: ldloc.0
		IL_0008: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_000d: br.s IL_002e
			// loop start (head: IL_002e)
				IL_000f: ldarg.0
				IL_0010: ldfld bool class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<!T>::_closed
				IL_0015: brfalse.s IL_0022

				IL_0017: ldarg.1
				IL_0018: initobj !T
				IL_001e: ldc.i4.0
				IL_001f: stloc.1
				IL_0020: leave.s IL_0062

				IL_0022: ldarg.0
				IL_0023: ldfld object class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<!T>::_gate
				IL_0028: call bool [mscorlib]System.Threading.Monitor::Wait(object)
				IL_002d: pop

				IL_002e: ldarg.0
				IL_002f: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<!T>::_items
				IL_0034: callvirt instance int32 class [System]System.Collections.Generic.Queue`1<!T>::get_Count()
				IL_0039: brfalse.s IL_000f
			// end loop

			IL_003b: ldarg.1
			IL_003c: ldarg.0
			IL_003d: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<!T>::_items
			IL_0042: callvirt instance !0 class [System]System.Collections.Generic.Queue`1<!T>::Dequeue()
			IL_0047: stobj !T
			IL_004c: ldarg.0
			IL_004d: ldfld object class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<!T>::_gate
			IL_0052: call void [mscorlib]System.Threading.Monitor::PulseAll(object)
			IL_0057: ldc.i4.1
			IL_0058: stloc.1
			IL_0059: leave.s IL_0062
		} // end .try
		finally
		{
			IL_005b: ldloc.0
			IL_005c: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_0061: endfinally
		} // end handler

		IL_0062: ldloc.1
		IL_0063: ret
	} // end of method BlockingTray`1::Take

	.method public hidebysig 
		instance void Close () cil managed 
	{
		// Method begins at RVA 0x29c4
		// Header size: 12
		// Code size: 41 (0x29)
		.maxstack 2
		.locals init (
			[0] object
		)

		IL_0000: ldarg.0
		IL_0001: ldfld object class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<!T>::_gate
		IL_0006: stloc.0
		IL_0007: ldloc.0
		IL_0008: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_000d: ldarg.0
			IL_000e: ldc.i4.1
			IL_000f: stfld bool class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<!T>::_closed
			IL_0014: ldarg.0
			IL_0015: ldfld object class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<!T>::_gate
			IL_001a: call void [mscorlib]System.Threading.Monitor::PulseAll(object)
			IL_001f: leave.s IL_0028
		} // end .try
		finally
		{
			IL_0021: ldloc.0
			IL_0022: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_0027: endfinally
		} // end handler

		IL_0028: ret
	} // end of method BlockingTray`1::Close

} // end of class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine
	extends [mscorlib]System.Object
	implements MMP.AsyncProxy.Training.Pipeline.IAssemblyLine,
	           [mscorlib]System.IDisposable
{
	// Nested Types
	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass2_0'
		extends [mscorlib]System.Object
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field public int32[] inputs
		.field public class MMP.AsyncProxy.Training.Pipeline.InFlightMeter meter
		.field public class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<int32> parsed
		.field public class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<int32> enriched
		.field public class [mscorlib]System.Collections.Generic.List`1<int32> dropped
		.field public int32 writeDelayMs
		.field public class [mscorlib]System.Collections.Generic.List`1<int32> outputs

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor () cil managed 
		{
			// Method begins at RVA 0x4ac8
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass2_0'::.ctor

		.method assembly hidebysig 
			instance void '<Run>b__0' () cil managed 
		{
			// Method begins at RVA 0x4ad0
			// Header size: 12
			// Code size: 66 (0x42)
			.maxstack 2
			.locals init (
				[0] int32[],
				[1] int32,
				[2] int32
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32[] MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::inputs
			IL_0006: stloc.0
			IL_0007: ldc.i4.0
			IL_0008: stloc.1
			IL_0009: br.s IL_0030
			// loop start (head: IL_0030)
				IL_000b: ldloc.0
				IL_000c: ldloc.1
				IL_000d: ldelem.i4
				IL_000e: stloc.2
				IL_000f: ldarg.0
				IL_0010: ldfld class MMP.AsyncProxy.Training.Pipeline.InFlightMeter MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::meter
				IL_0015: callvirt instance void MMP.AsyncProxy.Training.Pipeline.InFlightMeter::Entered()
				IL_001a: ldarg.0
				IL_001b: ldfld class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::parsed
				IL_0020: ldloc.2
				IL_0021: call int32 MMP.AsyncProxy.Training.Pipeline.Stages::Parse(int32)
				IL_0026: callvirt instance bool class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<int32>::Put(!0)
				IL_002b: pop
				IL_002c: ldloc.1
				IL_002d: ldc.i4.1
				IL_002e: add
				IL_002f: stloc.1

				IL_0030: ldloc.1
				IL_0031: ldloc.0
				IL_0032: ldlen
				IL_0033: conv.i4
				IL_0034: blt.s IL_000b
			// end loop

			IL_0036: ldarg.0
			IL_0037: ldfld class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::parsed
			IL_003c: callvirt instance void class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<int32>::Close()
			IL_0041: ret
		} // end of method '<>c__DisplayClass2_0'::'<Run>b__0'

		.method assembly hidebysig 
			instance void '<Run>b__1' () cil managed 
		{
			// Method begins at RVA 0x4b20
			// Header size: 12
			// Code size: 98 (0x62)
			.maxstack 2
			.locals init (
				[0] int32,
				[1] class [mscorlib]System.Collections.Generic.List`1<int32>
			)

			IL_0000: br.s IL_0047
			// loop start (head: IL_0047)
				IL_0002: nop
				.try
				{
					IL_0003: ldarg.0
					IL_0004: ldfld class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::enriched
					IL_0009: ldloc.0
					IL_000a: call int32 MMP.AsyncProxy.Training.Pipeline.Stages::Enrich(int32)
					IL_000f: callvirt instance bool class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<int32>::Put(!0)
					IL_0014: pop
					IL_0015: leave.s IL_0047
				} // end .try
				catch [mscorlib]System.InvalidOperationException
				{
					IL_0017: pop
					IL_0018: ldarg.0
					IL_0019: ldfld class [mscorlib]System.Collections.Generic.List`1<int32> MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::dropped
					IL_001e: stloc.1
					IL_001f: ldloc.1
					IL_0020: call void [mscorlib]System.Threading.Monitor::Enter(object)
					.try
					{
						IL_0025: ldarg.0
						IL_0026: ldfld class [mscorlib]System.Collections.Generic.List`1<int32> MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::dropped
						IL_002b: ldloc.0
						IL_002c: callvirt instance void class [mscorlib]System.Collections.Generic.List`1<int32>::Add(!0)
						IL_0031: leave.s IL_003a
					} // end .try
					finally
					{
						IL_0033: ldloc.1
						IL_0034: call void [mscorlib]System.Threading.Monitor::Exit(object)
						IL_0039: endfinally
					} // end handler

					IL_003a: ldarg.0
					IL_003b: ldfld class MMP.AsyncProxy.Training.Pipeline.InFlightMeter MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::meter
					IL_0040: callvirt instance void MMP.AsyncProxy.Training.Pipeline.InFlightMeter::Left()
					IL_0045: leave.s IL_0047
				} // end handler

				IL_0047: ldarg.0
				IL_0048: ldfld class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::parsed
				IL_004d: ldloca.s 0
				IL_004f: callvirt instance bool class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<int32>::Take(!0&)
				IL_0054: brtrue.s IL_0002
			// end loop

			IL_0056: ldarg.0
			IL_0057: ldfld class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::enriched
			IL_005c: callvirt instance void class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<int32>::Close()
			IL_0061: ret
		} // end of method '<>c__DisplayClass2_0'::'<Run>b__1'

		.method assembly hidebysig 
			instance void '<Run>b__2' () cil managed 
		{
			// Method begins at RVA 0x4bac
			// Header size: 12
			// Code size: 61 (0x3d)
			.maxstack 2
			.locals init (
				[0] int32
			)

			IL_0000: br.s IL_002d
			// loop start (head: IL_002d)
				IL_0002: ldarg.0
				IL_0003: ldfld int32 MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::writeDelayMs
				IL_0008: ldc.i4.0
				IL_0009: ble.s IL_0016

				IL_000b: ldarg.0
				IL_000c: ldfld int32 MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::writeDelayMs
				IL_0011: call void [mscorlib]System.Threading.Thread::Sleep(int32)

				IL_0016: ldarg.0
				IL_0017: ldfld class [mscorlib]System.Collections.Generic.List`1<int32> MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::outputs
				IL_001c: ldloc.0
				IL_001d: callvirt instance void class [mscorlib]System.Collections.Generic.List`1<int32>::Add(!0)
				IL_0022: ldarg.0
				IL_0023: ldfld class MMP.AsyncProxy.Training.Pipeline.InFlightMeter MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::meter
				IL_0028: callvirt instance void MMP.AsyncProxy.Training.Pipeline.InFlightMeter::Left()

				IL_002d: ldarg.0
				IL_002e: ldfld class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::enriched
				IL_0033: ldloca.s 0
				IL_0035: callvirt instance bool class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<int32>::Take(!0&)
				IL_003a: brtrue.s IL_0002
			// end loop

			IL_003c: ret
		} // end of method '<>c__DisplayClass2_0'::'<Run>b__2'

	} // end of class <>c__DisplayClass2_0


	// Methods
	.method public final hidebysig specialname newslot virtual 
		instance string get_Version () cil managed 
	{
		// Method begins at RVA 0x2a0c
		// Header size: 1
		// Code size: 6 (0x6)
		.maxstack 8

		IL_0000: ldstr "threaded"
		IL_0005: ret
	} // end of method ThreadedLine::get_Version

	.method public final hidebysig newslot virtual 
		instance class MMP.AsyncProxy.Training.Pipeline.LineResult Run (
			int32[] inputs,
			int32 trayCapacity,
			int32 writeDelayMs
		) cil managed 
	{
		// Method begins at RVA 0x2a14
		// Header size: 12
		// Code size: 240 (0xf0)
		.maxstack 4
		.locals init (
			[0] class MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0',
			[1] class [mscorlib]System.Threading.Thread,
			[2] class [mscorlib]System.Threading.Thread,
			[3] class [mscorlib]System.Threading.Thread,
			[4] class [mscorlib]System.Threading.Thread[],
			[5] int32
		)

		IL_0000: newobj instance void MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::.ctor()
		IL_0005: stloc.0
		IL_0006: ldloc.0
		IL_0007: ldarg.1
		IL_0008: stfld int32[] MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::inputs
		IL_000d: ldloc.0
		IL_000e: ldarg.3
		IL_000f: stfld int32 MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::writeDelayMs
		IL_0014: ldloc.0
		IL_0015: ldarg.2
		IL_0016: newobj instance void class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<int32>::.ctor(int32)
		IL_001b: stfld class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::parsed
		IL_0020: ldloc.0
		IL_0021: ldarg.2
		IL_0022: newobj instance void class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<int32>::.ctor(int32)
		IL_0027: stfld class MMP.AsyncProxy.Training.Pipeline.Threaded.BlockingTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::enriched
		IL_002c: ldloc.0
		IL_002d: ldloc.0
		IL_002e: ldfld int32[] MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::inputs
		IL_0033: ldlen
		IL_0034: conv.i4
		IL_0035: newobj instance void class [mscorlib]System.Collections.Generic.List`1<int32>::.ctor(int32)
		IL_003a: stfld class [mscorlib]System.Collections.Generic.List`1<int32> MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::outputs
		IL_003f: ldloc.0
		IL_0040: newobj instance void class [mscorlib]System.Collections.Generic.List`1<int32>::.ctor()
		IL_0045: stfld class [mscorlib]System.Collections.Generic.List`1<int32> MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::dropped
		IL_004a: ldloc.0
		IL_004b: newobj instance void MMP.AsyncProxy.Training.Pipeline.InFlightMeter::.ctor()
		IL_0050: stfld class MMP.AsyncProxy.Training.Pipeline.InFlightMeter MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::meter
		IL_0055: ldloc.0
		IL_0056: ldftn instance void MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::'<Run>b__0'()
		IL_005c: newobj instance void [mscorlib]System.Threading.ThreadStart::.ctor(object, native int)
		IL_0061: newobj instance void [mscorlib]System.Threading.Thread::.ctor(class [mscorlib]System.Threading.ThreadStart)
		IL_0066: stloc.1
		IL_0067: ldloc.0
		IL_0068: ldftn instance void MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::'<Run>b__1'()
		IL_006e: newobj instance void [mscorlib]System.Threading.ThreadStart::.ctor(object, native int)
		IL_0073: newobj instance void [mscorlib]System.Threading.Thread::.ctor(class [mscorlib]System.Threading.ThreadStart)
		IL_0078: stloc.2
		IL_0079: ldloc.0
		IL_007a: ldftn instance void MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::'<Run>b__2'()
		IL_0080: newobj instance void [mscorlib]System.Threading.ThreadStart::.ctor(object, native int)
		IL_0085: newobj instance void [mscorlib]System.Threading.Thread::.ctor(class [mscorlib]System.Threading.ThreadStart)
		IL_008a: stloc.3
		IL_008b: ldc.i4.3
		IL_008c: newarr [mscorlib]System.Threading.Thread
		IL_0091: dup
		IL_0092: ldc.i4.0
		IL_0093: ldloc.1
		IL_0094: stelem.ref
		IL_0095: dup
		IL_0096: ldc.i4.1
		IL_0097: ldloc.2
		IL_0098: stelem.ref
		IL_0099: dup
		IL_009a: ldc.i4.2
		IL_009b: ldloc.3
		IL_009c: stelem.ref
		IL_009d: stloc.s 4
		IL_009f: ldc.i4.0
		IL_00a0: stloc.s 5
		IL_00a2: br.s IL_00bb
		// loop start (head: IL_00bb)
			IL_00a4: ldloc.s 4
			IL_00a6: ldloc.s 5
			IL_00a8: ldelem.ref
			IL_00a9: dup
			IL_00aa: ldc.i4.1
			IL_00ab: callvirt instance void [mscorlib]System.Threading.Thread::set_IsBackground(bool)
			IL_00b0: callvirt instance void [mscorlib]System.Threading.Thread::Start()
			IL_00b5: ldloc.s 5
			IL_00b7: ldc.i4.1
			IL_00b8: add
			IL_00b9: stloc.s 5

			IL_00bb: ldloc.s 5
			IL_00bd: ldloc.s 4
			IL_00bf: ldlen
			IL_00c0: conv.i4
			IL_00c1: blt.s IL_00a4
		// end loop

		IL_00c3: ldloc.3
		IL_00c4: callvirt instance void [mscorlib]System.Threading.Thread::Join()
		IL_00c9: ldloc.0
		IL_00ca: ldfld class [mscorlib]System.Collections.Generic.List`1<int32> MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::outputs
		IL_00cf: callvirt instance !0[] class [mscorlib]System.Collections.Generic.List`1<int32>::ToArray()
		IL_00d4: ldloc.0
		IL_00d5: ldfld class [mscorlib]System.Collections.Generic.List`1<int32> MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::dropped
		IL_00da: callvirt instance !0[] class [mscorlib]System.Collections.Generic.List`1<int32>::ToArray()
		IL_00df: ldloc.0
		IL_00e0: ldfld class MMP.AsyncProxy.Training.Pipeline.InFlightMeter MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine/'<>c__DisplayClass2_0'::meter
		IL_00e5: callvirt instance int32 MMP.AsyncProxy.Training.Pipeline.InFlightMeter::get_Peak()
		IL_00ea: newobj instance void MMP.AsyncProxy.Training.Pipeline.LineResult::.ctor(int32[], int32[], int32)
		IL_00ef: ret
	} // end of method ThreadedLine::Run

	.method public final hidebysig newslot virtual 
		instance void Dispose () cil managed 
	{
		// Method begins at RVA 0x2b10
		// Header size: 1
		// Code size: 1 (0x1)
		.maxstack 8

		IL_0000: ret
	} // end of method ThreadedLine::Dispose

	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x2b12
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: call instance void [mscorlib]System.Object::.ctor()
		IL_0006: ret
	} // end of method ThreadedLine::.ctor

	// Properties
	.property instance string Version()
	{
		.get instance string MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine::get_Version()
	}

} // end of class MMP.AsyncProxy.Training.Pipeline.Threaded.ThreadedLine

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine
	extends [mscorlib]System.Object
	implements MMP.AsyncProxy.Training.Pipeline.IAssemblyLine,
	           [mscorlib]System.IDisposable
{
	// Nested Types
	.class nested private auto ansi sealed beforefieldinit '<EnrichStage>d__4'
		extends [mscorlib]System.Object
		implements class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>,
		           [mscorlib]System.Collections.IEnumerable,
		           class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>,
		           [mscorlib]System.IDisposable,
		           [mscorlib]System.Collections.IEnumerator
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field private int32 '<>1__state'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture '<>2__current'
		.field private int32 '<>l__initialThreadId'
		.field private class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> behind
		.field public class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> '<>3__behind'
		.field private class [mscorlib]System.Collections.Generic.List`1<int32> dropped
		.field public class [mscorlib]System.Collections.Generic.List`1<int32> '<>3__dropped'
		.field private class MMP.AsyncProxy.Training.Pipeline.InFlightMeter meter
		.field public class MMP.AsyncProxy.Training.Pipeline.InFlightMeter '<>3__meter'
		.field private class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> ahead
		.field public class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> '<>3__ahead'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32> '<next>5__2'

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor (
				int32 '<>1__state'
			) cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			// Method begins at RVA 0x4bf5
			// Header size: 1
			// Code size: 30 (0x1e)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ldarg.0
			IL_0007: ldarg.1
			IL_0008: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>1__state'
			IL_000d: ldarg.0
			IL_000e: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0013: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_0018: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>l__initialThreadId'
			IL_001d: ret
		} // end of method '<EnrichStage>d__4'::.ctor

		.method private final hidebysig newslot virtual 
			instance void System.IDisposable.Dispose () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [mscorlib]System.IDisposable::Dispose()
			// Method begins at RVA 0x4c14
			// Header size: 1
			// Code size: 16 (0x10)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldnull
			IL_0002: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<next>5__2'
			IL_0007: ldarg.0
			IL_0008: ldc.i4.s -2
			IL_000a: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>1__state'
			IL_000f: ret
		} // end of method '<EnrichStage>d__4'::System.IDisposable.Dispose

		.method private final hidebysig newslot virtual 
			instance bool MoveNext () cil managed 
		{
			.override method instance bool [mscorlib]System.Collections.IEnumerator::MoveNext()
			// Method begins at RVA 0x4c28
			// Header size: 12
			// Code size: 239 (0xef)
			.maxstack 3
			.locals init (
				[0] int32,
				[1] int32,
				[2] int32
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>1__state'
			IL_0006: stloc.0
			IL_0007: ldloc.0
			IL_0008: switch (IL_001b, IL_005c, IL_00d6)

			IL_0019: ldc.i4.0
			IL_001a: ret

			IL_001b: ldarg.0
			IL_001c: ldc.i4.m1
			IL_001d: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>1__state'

			IL_0022: ldarg.0
			IL_0023: ldfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::behind
			IL_0028: ldloca.s 1
			IL_002a: callvirt instance bool class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32>::TryTake(!0&)
			IL_002f: brtrue.s IL_0083

			IL_0031: ldarg.0
			IL_0032: ldarg.0
			IL_0033: ldfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::behind
			IL_0038: callvirt instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32>::TakeAsync()
			IL_003d: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<next>5__2'
			IL_0042: ldarg.0
			IL_0043: ldarg.0
			IL_0044: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<next>5__2'
			IL_0049: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture [MMP.AsyncProxy]MMP.AsyncProxy.Futures::Observe(class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture)
			IL_004e: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>2__current'
			IL_0053: ldarg.0
			IL_0054: ldc.i4.1
			IL_0055: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>1__state'
			IL_005a: ldc.i4.1
			IL_005b: ret

			IL_005c: ldarg.0
			IL_005d: ldc.i4.m1
			IL_005e: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>1__state'
			IL_0063: ldarg.0
			IL_0064: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<next>5__2'
			IL_0069: callvirt instance bool [MMP.AsyncProxy]MMP.AsyncProxy.IFuture::get_IsCanceled()
			IL_006e: brtrue.s IL_00e2

			IL_0070: ldarg.0
			IL_0071: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<next>5__2'
			IL_0076: callvirt instance !0 class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32>::get_Result()
			IL_007b: stloc.1
			IL_007c: ldarg.0
			IL_007d: ldnull
			IL_007e: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<next>5__2'

			IL_0083: nop
			.try
			{
				IL_0084: ldloc.1
				IL_0085: call int32 MMP.AsyncProxy.Training.Pipeline.Stages::Enrich(int32)
				IL_008a: stloc.2
				IL_008b: leave.s IL_00aa
			} // end .try
			catch [mscorlib]System.InvalidOperationException
			{
				IL_008d: pop
				IL_008e: ldarg.0
				IL_008f: ldfld class [mscorlib]System.Collections.Generic.List`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::dropped
				IL_0094: ldloc.1
				IL_0095: callvirt instance void class [mscorlib]System.Collections.Generic.List`1<int32>::Add(!0)
				IL_009a: ldarg.0
				IL_009b: ldfld class MMP.AsyncProxy.Training.Pipeline.InFlightMeter MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::meter
				IL_00a0: callvirt instance void MMP.AsyncProxy.Training.Pipeline.InFlightMeter::Left()
				IL_00a5: leave IL_0022
			} // end handler

			IL_00aa: ldarg.0
			IL_00ab: ldfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::ahead
			IL_00b0: ldloc.2
			IL_00b1: callvirt instance bool class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32>::TryPut(!0)
			IL_00b6: brtrue IL_0022

			IL_00bb: ldarg.0
			IL_00bc: ldarg.0
			IL_00bd: ldfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::ahead
			IL_00c2: ldloc.2
			IL_00c3: callvirt instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<bool> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32>::PutAsync(!0)
			IL_00c8: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>2__current'
			IL_00cd: ldarg.0
			IL_00ce: ldc.i4.2
			IL_00cf: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>1__state'
			IL_00d4: ldc.i4.1
			IL_00d5: ret

			IL_00d6: ldarg.0
			IL_00d7: ldc.i4.m1
			IL_00d8: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>1__state'
			IL_00dd: br IL_0022

			IL_00e2: ldarg.0
			IL_00e3: ldfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::ahead
			IL_00e8: callvirt instance void class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32>::Close()
			IL_00ed: ldc.i4.0
			IL_00ee: ret
		} // end of method '<EnrichStage>d__4'::MoveNext

		.method private final hidebysig specialname newslot virtual 
			instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance !0 class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::get_Current()
			// Method begins at RVA 0x4d34
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>2__current'
			IL_0006: ret
		} // end of method '<EnrichStage>d__4'::'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current'

		.method private final hidebysig newslot virtual 
			instance void System.Collections.IEnumerator.Reset () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [mscorlib]System.Collections.IEnumerator::Reset()
			// Method begins at RVA 0x4d3c
			// Header size: 1
			// Code size: 6 (0x6)
			.maxstack 8

			IL_0000: newobj instance void [mscorlib]System.NotSupportedException::.ctor()
			IL_0005: throw
		} // end of method '<EnrichStage>d__4'::System.Collections.IEnumerator.Reset

		.method private final hidebysig specialname newslot virtual 
			instance object System.Collections.IEnumerator.get_Current () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance object [mscorlib]System.Collections.IEnumerator::get_Current()
			// Method begins at RVA 0x4d43
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>2__current'
			IL_0006: ret
		} // end of method '<EnrichStage>d__4'::System.Collections.IEnumerator.get_Current

		.method private final hidebysig newslot virtual 
			instance class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> 'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance class [mscorlib]System.Collections.Generic.IEnumerator`1<!0> class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::GetEnumerator()
			// Method begins at RVA 0x4d4c
			// Header size: 12
			// Code size: 96 (0x60)
			.maxstack 2
			.locals init (
				[0] class MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>1__state'
			IL_0006: ldc.i4.s -2
			IL_0008: bne.un.s IL_0027

			IL_000a: ldarg.0
			IL_000b: ldfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>l__initialThreadId'
			IL_0010: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0015: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_001a: bne.un.s IL_0027

			IL_001c: ldarg.0
			IL_001d: ldc.i4.0
			IL_001e: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>1__state'
			IL_0023: ldarg.0
			IL_0024: stloc.0
			IL_0025: br.s IL_002e

			IL_0027: ldc.i4.0
			IL_0028: newobj instance void MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::.ctor(int32)
			IL_002d: stloc.0

			IL_002e: ldloc.0
			IL_002f: ldarg.0
			IL_0030: ldfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>3__behind'
			IL_0035: stfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::behind
			IL_003a: ldloc.0
			IL_003b: ldarg.0
			IL_003c: ldfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>3__ahead'
			IL_0041: stfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::ahead
			IL_0046: ldloc.0
			IL_0047: ldarg.0
			IL_0048: ldfld class [mscorlib]System.Collections.Generic.List`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>3__dropped'
			IL_004d: stfld class [mscorlib]System.Collections.Generic.List`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::dropped
			IL_0052: ldloc.0
			IL_0053: ldarg.0
			IL_0054: ldfld class MMP.AsyncProxy.Training.Pipeline.InFlightMeter MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>3__meter'
			IL_0059: stfld class MMP.AsyncProxy.Training.Pipeline.InFlightMeter MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::meter
			IL_005e: ldloc.0
			IL_005f: ret
		} // end of method '<EnrichStage>d__4'::'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator'

		.method private final hidebysig newslot virtual 
			instance class [mscorlib]System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance class [mscorlib]System.Collections.IEnumerator [mscorlib]System.Collections.IEnumerable::GetEnumerator()
			// Method begins at RVA 0x4db8
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator'()
			IL_0006: ret
		} // end of method '<EnrichStage>d__4'::System.Collections.IEnumerable.GetEnumerator

		// Properties
		.property instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.Current'()
		{
			.get instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current'()
		}
		.property instance object System.Collections.IEnumerator.Current()
		{
			.get instance object MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::System.Collections.IEnumerator.get_Current()
		}

	} // end of class <EnrichStage>d__4

	.class nested private auto ansi sealed beforefieldinit '<ParseStage>d__3'
		extends [mscorlib]System.Object
		implements class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>,
		           [mscorlib]System.Collections.IEnumerable,
		           class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>,
		           [mscorlib]System.IDisposable,
		           [mscorlib]System.Collections.IEnumerator
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field private int32 '<>1__state'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture '<>2__current'
		.field private int32 '<>l__initialThreadId'
		.field private int32[] inputs
		.field public int32[] '<>3__inputs'
		.field private class MMP.AsyncProxy.Training.Pipeline.InFlightMeter meter
		.field public class MMP.AsyncProxy.Training.Pipeline.InFlightMeter '<>3__meter'
		.field private class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> ahead
		.field public class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> '<>3__ahead'
		.field private int32[] '<>7__wrap1'
		.field private int32 '<>7__wrap2'

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor (
				int32 '<>1__state'
			) cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			// Method begins at RVA 0x4dc0
			// Header size: 1
			// Code size: 30 (0x1e)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ldarg.0
			IL_0007: ldarg.1
			IL_0008: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>1__state'
			IL_000d: ldarg.0
			IL_000e: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0013: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_0018: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>l__initialThreadId'
			IL_001d: ret
		} // end of method '<ParseStage>d__3'::.ctor

		.method private final hidebysig newslot virtual 
			instance void System.IDisposable.Dispose () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [mscorlib]System.IDisposable::Dispose()
			// Method begins at RVA 0x4ddf
			// Header size: 1
			// Code size: 16 (0x10)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldnull
			IL_0002: stfld int32[] MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>7__wrap1'
			IL_0007: ldarg.0
			IL_0008: ldc.i4.s -2
			IL_000a: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>1__state'
			IL_000f: ret
		} // end of method '<ParseStage>d__3'::System.IDisposable.Dispose

		.method private final hidebysig newslot virtual 
			instance bool MoveNext () cil managed 
		{
			.override method instance bool [mscorlib]System.Collections.IEnumerator::MoveNext()
			// Method begins at RVA 0x4df0
			// Header size: 12
			// Code size: 172 (0xac)
			.maxstack 3
			.locals init (
				[0] int32,
				[1] int32
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>1__state'
			IL_0006: stloc.0
			IL_0007: ldloc.0
			IL_0008: brfalse.s IL_0010

			IL_000a: ldloc.0
			IL_000b: ldc.i4.1
			IL_000c: beq.s IL_0073

			IL_000e: ldc.i4.0
			IL_000f: ret

			IL_0010: ldarg.0
			IL_0011: ldc.i4.m1
			IL_0012: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>1__state'
			IL_0017: ldarg.0
			IL_0018: ldarg.0
			IL_0019: ldfld int32[] MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::inputs
			IL_001e: stfld int32[] MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>7__wrap1'
			IL_0023: ldarg.0
			IL_0024: ldc.i4.0
			IL_0025: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>7__wrap2'
			IL_002a: br.s IL_0088

			IL_002c: ldarg.0
			IL_002d: ldfld int32[] MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>7__wrap1'
			IL_0032: ldarg.0
			IL_0033: ldfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>7__wrap2'
			IL_0038: ldelem.i4
			IL_0039: ldarg.0
			IL_003a: ldfld class MMP.AsyncProxy.Training.Pipeline.InFlightMeter MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::meter
			IL_003f: callvirt instance void MMP.AsyncProxy.Training.Pipeline.InFlightMeter::Entered()
			IL_0044: call int32 MMP.AsyncProxy.Training.Pipeline.Stages::Parse(int32)
			IL_0049: stloc.1
			IL_004a: ldarg.0
			IL_004b: ldfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::ahead
			IL_0050: ldloc.1
			IL_0051: callvirt instance bool class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32>::TryPut(!0)
			IL_0056: brtrue.s IL_007a

			IL_0058: ldarg.0
			IL_0059: ldarg.0
			IL_005a: ldfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::ahead
			IL_005f: ldloc.1
			IL_0060: callvirt instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<bool> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32>::PutAsync(!0)
			IL_0065: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>2__current'
			IL_006a: ldarg.0
			IL_006b: ldc.i4.1
			IL_006c: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>1__state'
			IL_0071: ldc.i4.1
			IL_0072: ret

			IL_0073: ldarg.0
			IL_0074: ldc.i4.m1
			IL_0075: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>1__state'

			IL_007a: ldarg.0
			IL_007b: ldarg.0
			IL_007c: ldfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>7__wrap2'
			IL_0081: ldc.i4.1
			IL_0082: add
			IL_0083: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>7__wrap2'

			IL_0088: ldarg.0
			IL_0089: ldfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>7__wrap2'
			IL_008e: ldarg.0
			IL_008f: ldfld int32[] MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>7__wrap1'
			IL_0094: ldlen
			IL_0095: conv.i4
			IL_0096: blt.s IL_002c

			IL_0098: ldarg.0
			IL_0099: ldnull
			IL_009a: stfld int32[] MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>7__wrap1'
			IL_009f: ldarg.0
			IL_00a0: ldfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::ahead
			IL_00a5: callvirt instance void class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32>::Close()
			IL_00aa: ldc.i4.0
			IL_00ab: ret
		} // end of method '<ParseStage>d__3'::MoveNext

		.method private final hidebysig specialname newslot virtual 
			instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance !0 class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::get_Current()
			// Method begins at RVA 0x4ea8
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>2__current'
			IL_0006: ret
		} // end of method '<ParseStage>d__3'::'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current'

		.method private final hidebysig newslot virtual 
			instance void System.Collections.IEnumerator.Reset () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [mscorlib]System.Collections.IEnumerator::Reset()
			// Method begins at RVA 0x4eb0
			// Header size: 1
			// Code size: 6 (0x6)
			.maxstack 8

			IL_0000: newobj instance void [mscorlib]System.NotSupportedException::.ctor()
			IL_0005: throw
		} // end of method '<ParseStage>d__3'::System.Collections.IEnumerator.Reset

		.method private final hidebysig specialname newslot virtual 
			instance object System.Collections.IEnumerator.get_Current () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance object [mscorlib]System.Collections.IEnumerator::get_Current()
			// Method begins at RVA 0x4eb7
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>2__current'
			IL_0006: ret
		} // end of method '<ParseStage>d__3'::System.Collections.IEnumerator.get_Current

		.method private final hidebysig newslot virtual 
			instance class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> 'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance class [mscorlib]System.Collections.Generic.IEnumerator`1<!0> class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::GetEnumerator()
			// Method begins at RVA 0x4ec0
			// Header size: 12
			// Code size: 84 (0x54)
			.maxstack 2
			.locals init (
				[0] class MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>1__state'
			IL_0006: ldc.i4.s -2
			IL_0008: bne.un.s IL_0027

			IL_000a: ldarg.0
			IL_000b: ldfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>l__initialThreadId'
			IL_0010: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0015: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_001a: bne.un.s IL_0027

			IL_001c: ldarg.0
			IL_001d: ldc.i4.0
			IL_001e: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>1__state'
			IL_0023: ldarg.0
			IL_0024: stloc.0
			IL_0025: br.s IL_002e

			IL_0027: ldc.i4.0
			IL_0028: newobj instance void MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::.ctor(int32)
			IL_002d: stloc.0

			IL_002e: ldloc.0
			IL_002f: ldarg.0
			IL_0030: ldfld int32[] MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>3__inputs'
			IL_0035: stfld int32[] MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::inputs
			IL_003a: ldloc.0
			IL_003b: ldarg.0
			IL_003c: ldfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>3__ahead'
			IL_0041: stfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::ahead
			IL_0046: ldloc.0
			IL_0047: ldarg.0
			IL_0048: ldfld class MMP.AsyncProxy.Training.Pipeline.InFlightMeter MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>3__meter'
			IL_004d: stfld class MMP.AsyncProxy.Training.Pipeline.InFlightMeter MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::meter
			IL_0052: ldloc.0
			IL_0053: ret
		} // end of method '<ParseStage>d__3'::'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator'

		.method private final hidebysig newslot virtual 
			instance class [mscorlib]System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance class [mscorlib]System.Collections.IEnumerator [mscorlib]System.Collections.IEnumerable::GetEnumerator()
			// Method begins at RVA 0x4f20
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator'()
			IL_0006: ret
		} // end of method '<ParseStage>d__3'::System.Collections.IEnumerable.GetEnumerator

		// Properties
		.property instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.Current'()
		{
			.get instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current'()
		}
		.property instance object System.Collections.IEnumerator.Current()
		{
			.get instance object MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::System.Collections.IEnumerator.get_Current()
		}

	} // end of class <ParseStage>d__3

	.class nested private auto ansi sealed beforefieldinit '<WriteStage>d__5'
		extends [mscorlib]System.Object
		implements class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>,
		           [mscorlib]System.Collections.IEnumerable,
		           class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>,
		           [mscorlib]System.IDisposable,
		           [mscorlib]System.Collections.IEnumerator
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field private int32 '<>1__state'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture '<>2__current'
		.field private int32 '<>l__initialThreadId'
		.field private class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> behind
		.field public class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> '<>3__behind'
		.field private int32 writeDelayMs
		.field public int32 '<>3__writeDelayMs'
		.field private class [mscorlib]System.Collections.Generic.List`1<int32> outputs
		.field public class [mscorlib]System.Collections.Generic.List`1<int32> '<>3__outputs'
		.field private class MMP.AsyncProxy.Training.Pipeline.InFlightMeter meter
		.field public class MMP.AsyncProxy.Training.Pipeline.InFlightMeter '<>3__meter'
		.field private int32 '<x>5__2'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32> '<next>5__3'

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor (
				int32 '<>1__state'
			) cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			// Method begins at RVA 0x4f28
			// Header size: 1
			// Code size: 30 (0x1e)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ldarg.0
			IL_0007: ldarg.1
			IL_0008: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>1__state'
			IL_000d: ldarg.0
			IL_000e: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0013: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_0018: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>l__initialThreadId'
			IL_001d: ret
		} // end of method '<WriteStage>d__5'::.ctor

		.method private final hidebysig newslot virtual 
			instance void System.IDisposable.Dispose () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [mscorlib]System.IDisposable::Dispose()
			// Method begins at RVA 0x4f47
			// Header size: 1
			// Code size: 16 (0x10)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldnull
			IL_0002: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<next>5__3'
			IL_0007: ldarg.0
			IL_0008: ldc.i4.s -2
			IL_000a: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>1__state'
			IL_000f: ret
		} // end of method '<WriteStage>d__5'::System.IDisposable.Dispose

		.method private final hidebysig newslot virtual 
			instance bool MoveNext () cil managed 
		{
			.override method instance bool [mscorlib]System.Collections.IEnumerator::MoveNext()
			// Method begins at RVA 0x4f58
			// Header size: 12
			// Code size: 217 (0xd9)
			.maxstack 2
			.locals init (
				[0] int32
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>1__state'
			IL_0006: stloc.0
			IL_0007: ldloc.0
			IL_0008: switch (IL_001b, IL_0060, IL_00af)

			IL_0019: ldc.i4.0
			IL_001a: ret

			IL_001b: ldarg.0
			IL_001c: ldc.i4.m1
			IL_001d: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>1__state'

			IL_0022: ldarg.0
			IL_0023: ldfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::behind
			IL_0028: ldarg.0
			IL_0029: ldflda int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<x>5__2'
			IL_002e: callvirt instance bool class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32>::TryTake(!0&)
			IL_0033: brtrue.s IL_008c

			IL_0035: ldarg.0
			IL_0036: ldarg.0
			IL_0037: ldfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::behind
			IL_003c: callvirt instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32>::TakeAsync()
			IL_0041: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<next>5__3'
			IL_0046: ldarg.0
			IL_0047: ldarg.0
			IL_0048: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<next>5__3'
			IL_004d: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture [MMP.AsyncProxy]MMP.AsyncProxy.Futures::Observe(class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture)
			IL_0052: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>2__current'
			IL_0057: ldarg.0
			IL_0058: ldc.i4.1
			IL_0059: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>1__state'
			IL_005e: ldc.i4.1
			IL_005f: ret

			IL_0060: ldarg.0
			IL_0061: ldc.i4.m1
			IL_0062: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>1__state'
			IL_0067: ldarg.0
			IL_0068: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<next>5__3'
			IL_006d: callvirt instance bool [MMP.AsyncProxy]MMP.AsyncProxy.IFuture::get_IsCanceled()
			IL_0072: brtrue.s IL_00d7

			IL_0074: ldarg.0
			IL_0075: ldarg.0
			IL_0076: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<next>5__3'
			IL_007b: callvirt instance !0 class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32>::get_Result()
			IL_0080: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<x>5__2'
			IL_0085: ldarg.0
			IL_0086: ldnull
			IL_0087: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<next>5__3'

			IL_008c: ldarg.0
			IL_008d: ldfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::writeDelayMs
			IL_0092: ldc.i4.0
			IL_0093: ble.s IL_00b6

			IL_0095: ldarg.0
			IL_0096: ldarg.0
			IL_0097: ldfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::writeDelayMs
			IL_009c: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture [MMP.AsyncProxy]MMP.AsyncProxy.Futures::Delay(int32)
			IL_00a1: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>2__current'
			IL_00a6: ldarg.0
			IL_00a7: ldc.i4.2
			IL_00a8: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>1__state'
			IL_00ad: ldc.i4.1
			IL_00ae: ret

			IL_00af: ldarg.0
			IL_00b0: ldc.i4.m1
			IL_00b1: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>1__state'

			IL_00b6: ldarg.0
			IL_00b7: ldfld class [mscorlib]System.Collections.Generic.List`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::outputs
			IL_00bc: ldarg.0
			IL_00bd: ldfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<x>5__2'
			IL_00c2: callvirt instance void class [mscorlib]System.Collections.Generic.List`1<int32>::Add(!0)
			IL_00c7: ldarg.0
			IL_00c8: ldfld class MMP.AsyncProxy.Training.Pipeline.InFlightMeter MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::meter
			IL_00cd: callvirt instance void MMP.AsyncProxy.Training.Pipeline.InFlightMeter::Left()
			IL_00d2: br IL_0022

			IL_00d7: ldc.i4.0
			IL_00d8: ret
		} // end of method '<WriteStage>d__5'::MoveNext

		.method private final hidebysig specialname newslot virtual 
			instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance !0 class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::get_Current()
			// Method begins at RVA 0x503d
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>2__current'
			IL_0006: ret
		} // end of method '<WriteStage>d__5'::'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current'

		.method private final hidebysig newslot virtual 
			instance void System.Collections.IEnumerator.Reset () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [mscorlib]System.Collections.IEnumerator::Reset()
			// Method begins at RVA 0x5045
			// Header size: 1
			// Code size: 6 (0x6)
			.maxstack 8

			IL_0000: newobj instance void [mscorlib]System.NotSupportedException::.ctor()
			IL_0005: throw
		} // end of method '<WriteStage>d__5'::System.Collections.IEnumerator.Reset

		.method private final hidebysig specialname newslot virtual 
			instance object System.Collections.IEnumerator.get_Current () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance object [mscorlib]System.Collections.IEnumerator::get_Current()
			// Method begins at RVA 0x504c
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>2__current'
			IL_0006: ret
		} // end of method '<WriteStage>d__5'::System.Collections.IEnumerator.get_Current

		.method private final hidebysig newslot virtual 
			instance class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> 'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance class [mscorlib]System.Collections.Generic.IEnumerator`1<!0> class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::GetEnumerator()
			// Method begins at RVA 0x5054
			// Header size: 12
			// Code size: 96 (0x60)
			.maxstack 2
			.locals init (
				[0] class MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>1__state'
			IL_0006: ldc.i4.s -2
			IL_0008: bne.un.s IL_0027

			IL_000a: ldarg.0
			IL_000b: ldfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>l__initialThreadId'
			IL_0010: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0015: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_001a: bne.un.s IL_0027

			IL_001c: ldarg.0
			IL_001d: ldc.i4.0
			IL_001e: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>1__state'
			IL_0023: ldarg.0
			IL_0024: stloc.0
			IL_0025: br.s IL_002e

			IL_0027: ldc.i4.0
			IL_0028: newobj instance void MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::.ctor(int32)
			IL_002d: stloc.0

			IL_002e: ldloc.0
			IL_002f: ldarg.0
			IL_0030: ldfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>3__behind'
			IL_0035: stfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::behind
			IL_003a: ldloc.0
			IL_003b: ldarg.0
			IL_003c: ldfld class [mscorlib]System.Collections.Generic.List`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>3__outputs'
			IL_0041: stfld class [mscorlib]System.Collections.Generic.List`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::outputs
			IL_0046: ldloc.0
			IL_0047: ldarg.0
			IL_0048: ldfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>3__writeDelayMs'
			IL_004d: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::writeDelayMs
			IL_0052: ldloc.0
			IL_0053: ldarg.0
			IL_0054: ldfld class MMP.AsyncProxy.Training.Pipeline.InFlightMeter MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>3__meter'
			IL_0059: stfld class MMP.AsyncProxy.Training.Pipeline.InFlightMeter MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::meter
			IL_005e: ldloc.0
			IL_005f: ret
		} // end of method '<WriteStage>d__5'::'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator'

		.method private final hidebysig newslot virtual 
			instance class [mscorlib]System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance class [mscorlib]System.Collections.IEnumerator [mscorlib]System.Collections.IEnumerable::GetEnumerator()
			// Method begins at RVA 0x50c0
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator'()
			IL_0006: ret
		} // end of method '<WriteStage>d__5'::System.Collections.IEnumerable.GetEnumerator

		// Properties
		.property instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.Current'()
		{
			.get instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current'()
		}
		.property instance object System.Collections.IEnumerator.Current()
		{
			.get instance object MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::System.Collections.IEnumerator.get_Current()
		}

	} // end of class <WriteStage>d__5


	// Methods
	.method public final hidebysig specialname newslot virtual 
		instance string get_Version () cil managed 
	{
		// Method begins at RVA 0x2b1a
		// Header size: 1
		// Code size: 6 (0x6)
		.maxstack 8

		IL_0000: ldstr "asyncproxy"
		IL_0005: ret
	} // end of method IteratorLine::get_Version

	.method public final hidebysig newslot virtual 
		instance class MMP.AsyncProxy.Training.Pipeline.LineResult Run (
			int32[] inputs,
			int32 trayCapacity,
			int32 writeDelayMs
		) cil managed 
	{
		// Method begins at RVA 0x2b24
		// Header size: 12
		// Code size: 112 (0x70)
		.maxstack 4
		.locals init (
			[0] class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32>,
			[1] class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32>,
			[2] class [mscorlib]System.Collections.Generic.List`1<int32>,
			[3] class [mscorlib]System.Collections.Generic.List`1<int32>,
			[4] class MMP.AsyncProxy.Training.Pipeline.InFlightMeter
		)

		IL_0000: ldarg.2
		IL_0001: newobj instance void class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32>::.ctor(int32)
		IL_0006: stloc.0
		IL_0007: ldarg.2
		IL_0008: newobj instance void class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32>::.ctor(int32)
		IL_000d: stloc.1
		IL_000e: ldarg.1
		IL_000f: ldlen
		IL_0010: conv.i4
		IL_0011: newobj instance void class [mscorlib]System.Collections.Generic.List`1<int32>::.ctor(int32)
		IL_0016: stloc.2
		IL_0017: newobj instance void class [mscorlib]System.Collections.Generic.List`1<int32>::.ctor()
		IL_001c: stloc.3
		IL_001d: newobj instance void MMP.AsyncProxy.Training.Pipeline.InFlightMeter::.ctor()
		IL_0022: stloc.s 4
		IL_0024: ldarg.1
		IL_0025: ldloc.0
		IL_0026: ldloc.s 4
		IL_0028: call class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine::ParseStage(int32[], class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32>, class MMP.AsyncProxy.Training.Pipeline.InFlightMeter)
		IL_002d: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture [MMP.AsyncProxy]MMP.AsyncProxy.AsyncProxy::Run(class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>)
		IL_0032: pop
		IL_0033: ldloc.0
		IL_0034: ldloc.1
		IL_0035: ldloc.3
		IL_0036: ldloc.s 4
		IL_0038: call class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine::EnrichStage(class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32>, class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32>, class [mscorlib]System.Collections.Generic.List`1<int32>, class MMP.AsyncProxy.Training.Pipeline.InFlightMeter)
		IL_003d: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture [MMP.AsyncProxy]MMP.AsyncProxy.AsyncProxy::Run(class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>)
		IL_0042: pop
		IL_0043: ldloc.1
		IL_0044: ldloc.2
		IL_0045: ldarg.3
		IL_0046: ldloc.s 4
		IL_0048: call class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine::WriteStage(class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32>, class [mscorlib]System.Collections.Generic.List`1<int32>, int32, class MMP.AsyncProxy.Training.Pipeline.InFlightMeter)
		IL_004d: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture [MMP.AsyncProxy]MMP.AsyncProxy.AsyncProxy::Run(class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>)
		IL_0052: callvirt instance void [MMP.AsyncProxy]MMP.AsyncProxy.IFuture::Wait()
		IL_0057: ldloc.2
		IL_0058: callvirt instance !0[] class [mscorlib]System.Collections.Generic.List`1<int32>::ToArray()
		IL_005d: ldloc.3
		IL_005e: callvirt instance !0[] class [mscorlib]System.Collections.Generic.List`1<int32>::ToArray()
		IL_0063: ldloc.s 4
		IL_0065: callvirt instance int32 MMP.AsyncProxy.Training.Pipeline.InFlightMeter::get_Peak()
		IL_006a: newobj instance void MMP.AsyncProxy.Training.Pipeline.LineResult::.ctor(int32[], int32[], int32)
		IL_006f: ret
	} // end of method IteratorLine::Run

	.method private hidebysig static 
		class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> ParseStage (
			int32[] inputs,
			class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> ahead,
			class MMP.AsyncProxy.Training.Pipeline.InFlightMeter meter
		) cil managed 
	{
		// Method begins at RVA 0x2ba0
		// Header size: 1
		// Code size: 29 (0x1d)
		.maxstack 8

		IL_0000: ldc.i4.s -2
		IL_0002: newobj instance void MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::.ctor(int32)
		IL_0007: dup
		IL_0008: ldarg.0
		IL_0009: stfld int32[] MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>3__inputs'
		IL_000e: dup
		IL_000f: ldarg.1
		IL_0010: stfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>3__ahead'
		IL_0015: dup
		IL_0016: ldarg.2
		IL_0017: stfld class MMP.AsyncProxy.Training.Pipeline.InFlightMeter MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>3__meter'
		IL_001c: ret
	} // end of method IteratorLine::ParseStage

	.method private hidebysig static 
		class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> EnrichStage (
			class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> behind,
			class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> ahead,
			class [mscorlib]System.Collections.Generic.List`1<int32> dropped,
			class MMP.AsyncProxy.Training.Pipeline.InFlightMeter meter
		) cil managed 
	{
		// Method begins at RVA 0x2bbe
		// Header size: 1
		// Code size: 36 (0x24)
		.maxstack 8

		IL_0000: ldc.i4.s -2
		IL_0002: newobj instance void MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::.ctor(int32)
		IL_0007: dup
		IL_0008: ldarg.0
		IL_0009: stfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>3__behind'
		IL_000e: dup
		IL_000f: ldarg.1
		IL_0010: stfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>3__ahead'
		IL_0015: dup
		IL_0016: ldarg.2
		IL_0017: stfld class [mscorlib]System.Collections.Generic.List`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>3__dropped'
		IL_001c: dup
		IL_001d: ldarg.3
		IL_001e: stfld class MMP.AsyncProxy.Training.Pipeline.InFlightMeter MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>3__meter'
		IL_0023: ret
	} // end of method IteratorLine::EnrichStage

	.method private hidebysig static 
		class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> WriteStage (
			class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> behind,
			class [mscorlib]System.Collections.Generic.List`1<int32> outputs,
			int32 writeDelayMs,
			class MMP.AsyncProxy.Training.Pipeline.InFlightMeter meter
		) cil managed 
	{
		// Method begins at RVA 0x2be3
		// Header size: 1
		// Code size: 36 (0x24)
		.maxstack 8

		IL_0000: ldc.i4.s -2
		IL_0002: newobj instance void MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::.ctor(int32)
		IL_0007: dup
		IL_0008: ldarg.0
		IL_0009: stfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>3__behind'
		IL_000e: dup
		IL_000f: ldarg.1
		IL_0010: stfld class [mscorlib]System.Collections.Generic.List`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>3__outputs'
		IL_0015: dup
		IL_0016: ldarg.2
		IL_0017: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>3__writeDelayMs'
		IL_001c: dup
		IL_001d: ldarg.3
		IL_001e: stfld class MMP.AsyncProxy.Training.Pipeline.InFlightMeter MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>3__meter'
		IL_0023: ret
	} // end of method IteratorLine::WriteStage

	.method public final hidebysig newslot virtual 
		instance void Dispose () cil managed 
	{
		// Method begins at RVA 0x2c08
		// Header size: 1
		// Code size: 1 (0x1)
		.maxstack 8

		IL_0000: ret
	} // end of method IteratorLine::Dispose

	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x2c0a
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: call instance void [mscorlib]System.Object::.ctor()
		IL_0006: ret
	} // end of method IteratorLine::.ctor

	// Properties
	.property instance string Version()
	{
		.get instance string MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine::get_Version()
	}

} // end of class MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<T>
	extends [mscorlib]System.Object
{
	// Fields
	.field private initonly object _gate
	.field private initonly class [System]System.Collections.Generic.Queue`1<!T> _items
	.field private initonly int32 _capacity
	.field private class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T> _waitingTaker
	.field private class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool> _waitingPutter
	.field private !T _held
	.field private bool _holding
	.field private bool _closed

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			int32 capacity
		) cil managed 
	{
		// Method begins at RVA 0x2c12
		// Header size: 1
		// Code size: 36 (0x24)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: newobj instance void [mscorlib]System.Object::.ctor()
		IL_0006: stfld object class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_gate
		IL_000b: ldarg.0
		IL_000c: newobj instance void class [System]System.Collections.Generic.Queue`1<!T>::.ctor()
		IL_0011: stfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_items
		IL_0016: ldarg.0
		IL_0017: call instance void [mscorlib]System.Object::.ctor()
		IL_001c: ldarg.0
		IL_001d: ldarg.1
		IL_001e: stfld int32 class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_capacity
		IL_0023: ret
	} // end of method PromiseTray`1::.ctor

	.method public hidebysig 
		instance bool TryPut (
			!T item
		) cil managed 
	{
		// Method begins at RVA 0x2c38
		// Header size: 12
		// Code size: 117 (0x75)
		.maxstack 2
		.locals init (
			[0] class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>,
			[1] object,
			[2] bool
		)

		IL_0000: ldnull
		IL_0001: stloc.0
		IL_0002: ldarg.0
		IL_0003: ldfld object class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_gate
		IL_0008: stloc.1
		IL_0009: ldloc.1
		IL_000a: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_000f: ldarg.0
			IL_0010: ldfld bool class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_closed
			IL_0015: brtrue.s IL_001f

			IL_0017: ldarg.0
			IL_0018: ldfld bool class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_holding
			IL_001d: brfalse.s IL_0023

			IL_001f: ldc.i4.0
			IL_0020: stloc.2
			IL_0021: leave.s IL_0073

			IL_0023: ldarg.0
			IL_0024: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingTaker
			IL_0029: brfalse.s IL_003b

			IL_002b: ldarg.0
			IL_002c: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingTaker
			IL_0031: stloc.0
			IL_0032: ldarg.0
			IL_0033: ldnull
			IL_0034: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingTaker
			IL_0039: leave.s IL_0069

			IL_003b: ldarg.0
			IL_003c: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_items
			IL_0041: callvirt instance int32 class [System]System.Collections.Generic.Queue`1<!T>::get_Count()
			IL_0046: ldarg.0
			IL_0047: ldfld int32 class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_capacity
			IL_004c: bge.s IL_005e

			IL_004e: ldarg.0
			IL_004f: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_items
			IL_0054: ldarg.1
			IL_0055: callvirt instance void class [System]System.Collections.Generic.Queue`1<!T>::Enqueue(!0)
			IL_005a: ldc.i4.1
			IL_005b: stloc.2
			IL_005c: leave.s IL_0073

			IL_005e: ldc.i4.0
			IL_005f: stloc.2
			IL_0060: leave.s IL_0073
		} // end .try
		finally
		{
			IL_0062: ldloc.1
			IL_0063: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_0068: endfinally
		} // end handler

		IL_0069: ldloc.0
		IL_006a: ldarg.1
		IL_006b: callvirt instance bool class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::TrySetResult(!0)
		IL_0070: pop
		IL_0071: ldc.i4.1
		IL_0072: ret

		IL_0073: ldloc.2
		IL_0074: ret
	} // end of method PromiseTray`1::TryPut

	.method public hidebysig 
		instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<bool> PutAsync (
			!T item
		) cil managed 
	{
		// Method begins at RVA 0x2ccc
		// Header size: 12
		// Code size: 179 (0xb3)
		.maxstack 2
		.locals init (
			[0] class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>,
			[1] object,
			[2] class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<bool>
		)

		IL_0000: ldnull
		IL_0001: stloc.0
		IL_0002: ldarg.0
		IL_0003: ldfld object class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_gate
		IL_0008: stloc.1
		IL_0009: ldloc.1
		IL_000a: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_000f: ldarg.0
			IL_0010: ldfld bool class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_closed
			IL_0015: brfalse.s IL_0022

			IL_0017: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<bool> [MMP.AsyncProxy]MMP.AsyncProxy.Futures::get_False()
			IL_001c: stloc.2
			IL_001d: leave IL_00b1

			IL_0022: ldarg.0
			IL_0023: ldfld bool class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_holding
			IL_0028: brfalse.s IL_0035

			IL_002a: ldstr "one producer per tray: an item is already held at the door"
			IL_002f: newobj instance void [mscorlib]System.InvalidOperationException::.ctor(string)
			IL_0034: throw

			IL_0035: ldarg.0
			IL_0036: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingTaker
			IL_003b: brfalse.s IL_004d

			IL_003d: ldarg.0
			IL_003e: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingTaker
			IL_0043: stloc.0
			IL_0044: ldarg.0
			IL_0045: ldnull
			IL_0046: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingTaker
			IL_004b: leave.s IL_00a3

			IL_004d: ldarg.0
			IL_004e: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_items
			IL_0053: callvirt instance int32 class [System]System.Collections.Generic.Queue`1<!T>::get_Count()
			IL_0058: ldarg.0
			IL_0059: ldfld int32 class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_capacity
			IL_005e: bge.s IL_0074

			IL_0060: ldarg.0
			IL_0061: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_items
			IL_0066: ldarg.1
			IL_0067: callvirt instance void class [System]System.Collections.Generic.Queue`1<!T>::Enqueue(!0)
			IL_006c: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<bool> [MMP.AsyncProxy]MMP.AsyncProxy.Futures::get_True()
			IL_0071: stloc.2
			IL_0072: leave.s IL_00b1

			IL_0074: ldarg.0
			IL_0075: ldarg.1
			IL_0076: stfld !0 class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_held
			IL_007b: ldarg.0
			IL_007c: ldc.i4.1
			IL_007d: stfld bool class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_holding
			IL_0082: ldarg.0
			IL_0083: ldc.i4.1
			IL_0084: newobj instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool>::.ctor(valuetype [MMP.AsyncProxy]MMP.AsyncProxy.PromiseOptions)
			IL_0089: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingPutter
			IL_008e: ldarg.0
			IL_008f: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingPutter
			IL_0094: callvirt instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool>::get_Future()
			IL_0099: stloc.2
			IL_009a: leave.s IL_00b1
		} // end .try
		finally
		{
			IL_009c: ldloc.1
			IL_009d: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_00a2: endfinally
		} // end handler

		IL_00a3: ldloc.0
		IL_00a4: ldarg.1
		IL_00a5: callvirt instance bool class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::TrySetResult(!0)
		IL_00aa: pop
		IL_00ab: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<bool> [MMP.AsyncProxy]MMP.AsyncProxy.Futures::get_True()
		IL_00b0: ret

		IL_00b1: ldloc.2
		IL_00b2: ret
	} // end of method PromiseTray`1::PutAsync

	.method public hidebysig 
		instance bool TryTake (
			[out] !T& item
		) cil managed 
	{
		// Method begins at RVA 0x2d9c
		// Header size: 12
		// Code size: 196 (0xc4)
		.maxstack 2
		.locals init (
			[0] class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool>,
			[1] object,
			[2] bool
		)

		IL_0000: ldnull
		IL_0001: stloc.0
		IL_0002: ldarg.0
		IL_0003: ldfld object class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_gate
		IL_0008: stloc.1
		IL_0009: ldloc.1
		IL_000a: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_000f: ldarg.0
			IL_0010: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_items
			IL_0015: callvirt instance int32 class [System]System.Collections.Generic.Queue`1<!T>::get_Count()
			IL_001a: ldc.i4.0
			IL_001b: ble.s IL_006a

			IL_001d: ldarg.1
			IL_001e: ldarg.0
			IL_001f: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_items
			IL_0024: callvirt instance !0 class [System]System.Collections.Generic.Queue`1<!T>::Dequeue()
			IL_0029: stobj !T
			IL_002e: ldarg.0
			IL_002f: ldfld bool class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_holding
			IL_0034: brfalse.s IL_00ac

			IL_0036: ldarg.0
			IL_0037: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_items
			IL_003c: ldarg.0
			IL_003d: ldfld !0 class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_held
			IL_0042: callvirt instance void class [System]System.Collections.Generic.Queue`1<!T>::Enqueue(!0)
			IL_0047: ldarg.0
			IL_0048: ldflda !0 class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_held
			IL_004d: initobj !T
			IL_0053: ldarg.0
			IL_0054: ldc.i4.0
			IL_0055: stfld bool class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_holding
			IL_005a: ldarg.0
			IL_005b: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingPutter
			IL_0060: stloc.0
			IL_0061: ldarg.0
			IL_0062: ldnull
			IL_0063: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingPutter
			IL_0068: leave.s IL_00b5

			IL_006a: ldarg.0
			IL_006b: ldfld bool class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_holding
			IL_0070: brfalse.s IL_00a1

			IL_0072: ldarg.1
			IL_0073: ldarg.0
			IL_0074: ldfld !0 class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_held
			IL_0079: stobj !T
			IL_007e: ldarg.0
			IL_007f: ldflda !0 class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_held
			IL_0084: initobj !T
			IL_008a: ldarg.0
			IL_008b: ldc.i4.0
			IL_008c: stfld bool class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_holding
			IL_0091: ldarg.0
			IL_0092: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingPutter
			IL_0097: stloc.0
			IL_0098: ldarg.0
			IL_0099: ldnull
			IL_009a: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingPutter
			IL_009f: leave.s IL_00b5

			IL_00a1: ldarg.1
			IL_00a2: initobj !T
			IL_00a8: ldc.i4.0
			IL_00a9: stloc.2
			IL_00aa: leave.s IL_00c2

			IL_00ac: leave.s IL_00b5
		} // end .try
		finally
		{
			IL_00ae: ldloc.1
			IL_00af: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_00b4: endfinally
		} // end handler

		IL_00b5: ldloc.0
		IL_00b6: brfalse.s IL_00c0

		IL_00b8: ldloc.0
		IL_00b9: ldc.i4.1
		IL_00ba: callvirt instance bool class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool>::TrySetResult(!0)
		IL_00bf: pop

		IL_00c0: ldc.i4.1
		IL_00c1: ret

		IL_00c2: ldloc.2
		IL_00c3: ret
	} // end of method PromiseTray`1::TryTake

	.method public hidebysig 
		instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!T> TakeAsync () cil managed 
	{
		// Method begins at RVA 0x2e7c
		// Header size: 12
		// Code size: 124 (0x7c)
		.maxstack 3
		.locals init (
			[0] !T,
			[1] object,
			[2] class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!T>
		)

		IL_0000: ldarg.0
		IL_0001: ldloca.s 0
		IL_0003: call instance bool class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::TryTake(!0&)
		IL_0008: brfalse.s IL_001d

		IL_000a: ldc.i4.1
		IL_000b: newobj instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::.ctor(valuetype [MMP.AsyncProxy]MMP.AsyncProxy.PromiseOptions)
		IL_0010: dup
		IL_0011: ldloc.0
		IL_0012: callvirt instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::SetResult(!0)
		IL_0017: callvirt instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::get_Future()
		IL_001c: ret

		IL_001d: ldarg.0
		IL_001e: ldfld object class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_gate
		IL_0023: stloc.1
		IL_0024: ldloc.1
		IL_0025: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_002a: ldarg.0
			IL_002b: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_items
			IL_0030: callvirt instance int32 class [System]System.Collections.Generic.Queue`1<!T>::get_Count()
			IL_0035: ldc.i4.0
			IL_0036: bgt.s IL_0040

			IL_0038: ldarg.0
			IL_0039: ldfld bool class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_holding
			IL_003e: brfalse.s IL_0049

			IL_0040: ldarg.0
			IL_0041: call instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::TakeAsync()
			IL_0046: stloc.2
			IL_0047: leave.s IL_007a

			IL_0049: ldarg.0
			IL_004a: ldfld bool class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_closed
			IL_004f: brfalse.s IL_0059

			IL_0051: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::Cancelled()
			IL_0056: stloc.2
			IL_0057: leave.s IL_007a

			IL_0059: ldarg.0
			IL_005a: ldc.i4.1
			IL_005b: newobj instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::.ctor(valuetype [MMP.AsyncProxy]MMP.AsyncProxy.PromiseOptions)
			IL_0060: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingTaker
			IL_0065: ldarg.0
			IL_0066: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingTaker
			IL_006b: callvirt instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::get_Future()
			IL_0070: stloc.2
			IL_0071: leave.s IL_007a
		} // end .try
		finally
		{
			IL_0073: ldloc.1
			IL_0074: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_0079: endfinally
		} // end handler

		IL_007a: ldloc.2
		IL_007b: ret
	} // end of method PromiseTray`1::TakeAsync

	.method public hidebysig 
		instance void Close () cil managed 
	{
		// Method begins at RVA 0x2f14
		// Header size: 12
		// Code size: 104 (0x68)
		.maxstack 2
		.locals init (
			[0] class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>,
			[1] class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool>,
			[2] object
		)

		IL_0000: ldnull
		IL_0001: stloc.0
		IL_0002: ldnull
		IL_0003: stloc.1
		IL_0004: ldarg.0
		IL_0005: ldfld object class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_gate
		IL_000a: stloc.2
		IL_000b: ldloc.2
		IL_000c: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_0011: ldarg.0
			IL_0012: ldc.i4.1
			IL_0013: stfld bool class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_closed
			IL_0018: ldarg.0
			IL_0019: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_items
			IL_001e: callvirt instance int32 class [System]System.Collections.Generic.Queue`1<!T>::get_Count()
			IL_0023: brtrue.s IL_003b

			IL_0025: ldarg.0
			IL_0026: ldfld bool class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_holding
			IL_002b: brtrue.s IL_003b

			IL_002d: ldarg.0
			IL_002e: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingTaker
			IL_0033: stloc.0
			IL_0034: ldarg.0
			IL_0035: ldnull
			IL_0036: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingTaker

			IL_003b: ldarg.0
			IL_003c: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingPutter
			IL_0041: stloc.1
			IL_0042: ldarg.0
			IL_0043: ldnull
			IL_0044: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingPutter
			IL_0049: leave.s IL_0052
		} // end .try
		finally
		{
			IL_004b: ldloc.2
			IL_004c: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_0051: endfinally
		} // end handler

		IL_0052: ldloc.0
		IL_0053: brfalse.s IL_005c

		IL_0055: ldloc.0
		IL_0056: callvirt instance bool class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::TrySetCanceled()
		IL_005b: pop

		IL_005c: ldloc.1
		IL_005d: brfalse.s IL_0067

		IL_005f: ldloc.1
		IL_0060: ldc.i4.0
		IL_0061: callvirt instance bool class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool>::TrySetResult(!0)
		IL_0066: pop

		IL_0067: ret
	} // end of method PromiseTray`1::Close

	.method private hidebysig static 
		class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!T> Cancelled () cil managed 
	{
		// Method begins at RVA 0x2f98
		// Header size: 1
		// Code size: 18 (0x12)
		.maxstack 8

		IL_0000: ldc.i4.1
		IL_0001: newobj instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::.ctor(valuetype [MMP.AsyncProxy]MMP.AsyncProxy.PromiseOptions)
		IL_0006: dup
		IL_0007: callvirt instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::SetCanceled()
		IL_000c: callvirt instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::get_Future()
		IL_0011: ret
	} // end of method PromiseTray`1::Cancelled

} // end of class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1

.class interface public auto ansi abstract beforefieldinit MMP.AsyncProxy.Training.Mailbox.IClerk
	implements [mscorlib]System.IDisposable
{
	// Methods
	.method public hidebysig specialname newslot abstract virtual 
		instance string get_Name () cil managed 
	{
	} // end of method IClerk::get_Name

	.method public hidebysig specialname newslot abstract virtual 
		instance bool get_IsRunning () cil managed 
	{
	} // end of method IClerk::get_IsRunning

	.method public hidebysig specialname newslot abstract virtual 
		instance int32 get_Handled () cil managed 
	{
	} // end of method IClerk::get_Handled

	.method public hidebysig newslot abstract virtual 
		instance bool WaitUntilIdle (
			int32 timeoutMs
		) cil managed 
	{
	} // end of method IClerk::WaitUntilIdle

	// Properties
	.property instance string Name()
	{
		.get instance string MMP.AsyncProxy.Training.Mailbox.IClerk::get_Name()
	}
	.property instance bool IsRunning()
	{
		.get instance bool MMP.AsyncProxy.Training.Mailbox.IClerk::get_IsRunning()
	}
	.property instance int32 Handled()
	{
		.get instance int32 MMP.AsyncProxy.Training.Mailbox.IClerk::get_Handled()
	}

} // end of class MMP.AsyncProxy.Training.Mailbox.IClerk

.class interface public auto ansi abstract beforefieldinit MMP.AsyncProxy.Training.Mailbox.IDesk
	implements [mscorlib]System.IDisposable
{
	// Methods
	.method public hidebysig specialname newslot abstract virtual 
		instance string get_Version () cil managed 
	{
	} // end of method IDesk::get_Version

	.method public hidebysig newslot abstract virtual 
		instance class MMP.AsyncProxy.Training.Mailbox.IInTray`1<!!T> OpenTray<T> (
			string name,
			int32 capacity
		) cil managed 
	{
	} // end of method IDesk::OpenTray

	.method public hidebysig newslot abstract virtual 
		instance class MMP.AsyncProxy.Training.Mailbox.IClerk Seat<T> (
			string name,
			class MMP.AsyncProxy.Training.Mailbox.IInTray`1<!!T> tray,
			class [mscorlib]System.Action`1<!!T> handle
		) cil managed 
	{
	} // end of method IDesk::Seat

	// Properties
	.property instance string Version()
	{
		.get instance string MMP.AsyncProxy.Training.Mailbox.IDesk::get_Version()
	}

} // end of class MMP.AsyncProxy.Training.Mailbox.IDesk

.class interface public auto ansi abstract beforefieldinit MMP.AsyncProxy.Training.Mailbox.IInTray`1<T>
{
	// Methods
	.method public hidebysig specialname newslot abstract virtual 
		instance string get_Name () cil managed 
	{
	} // end of method IInTray`1::get_Name

	.method public hidebysig specialname newslot abstract virtual 
		instance int32 get_Capacity () cil managed 
	{
	} // end of method IInTray`1::get_Capacity

	.method public hidebysig specialname newslot abstract virtual 
		instance int32 get_Pending () cil managed 
	{
	} // end of method IInTray`1::get_Pending

	.method public hidebysig newslot abstract virtual 
		instance bool TryPost (
			!T slip
		) cil managed 
	{
	} // end of method IInTray`1::TryPost

	.method public hidebysig newslot abstract virtual 
		instance void Close () cil managed 
	{
	} // end of method IInTray`1::Close

	// Properties
	.property instance string Name()
	{
		.get instance string MMP.AsyncProxy.Training.Mailbox.IInTray`1::get_Name()
	}
	.property instance int32 Capacity()
	{
		.get instance int32 MMP.AsyncProxy.Training.Mailbox.IInTray`1::get_Capacity()
	}
	.property instance int32 Pending()
	{
		.get instance int32 MMP.AsyncProxy.Training.Mailbox.IInTray`1::get_Pending()
	}

} // end of class MMP.AsyncProxy.Training.Mailbox.IInTray`1

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1<T>
	extends [mscorlib]System.Object
	implements MMP.AsyncProxy.Training.Mailbox.IClerk,
	           [mscorlib]System.IDisposable
{
	// Fields
	.field private initonly string _name
	.field private initonly class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T> _tray
	.field private initonly class [mscorlib]System.Action`1<!T> _handle
	.field private initonly class [mscorlib]System.Threading.Thread _thread
	.field private bool modreq([mscorlib]System.Runtime.CompilerServices.IsVolatile) _running
	.field private int32 _handled
	.field private int32 _busy

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			string name,
			class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T> tray,
			class [mscorlib]System.Action`1<!T> handle
		) cil managed 
	{
		// Method begins at RVA 0x2fac
		// Header size: 12
		// Code size: 105 (0x69)
		.maxstack 3

		IL_0000: ldarg.0
		IL_0001: ldc.i4.1
		IL_0002: volatile.
		IL_0004: stfld bool modreq([mscorlib]System.Runtime.CompilerServices.IsVolatile) class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1<!T>::_running
		IL_0009: ldarg.0
		IL_000a: call instance void [mscorlib]System.Object::.ctor()
		IL_000f: ldarg.0
		IL_0010: ldarg.1
		IL_0011: stfld string class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1<!T>::_name
		IL_0016: ldarg.0
		IL_0017: ldarg.2
		IL_0018: stfld class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!0> class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1<!T>::_tray
		IL_001d: ldarg.0
		IL_001e: ldarg.3
		IL_001f: stfld class [mscorlib]System.Action`1<!0> class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1<!T>::_handle
		IL_0024: ldarg.0
		IL_0025: ldarg.0
		IL_0026: ldftn instance void class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1<!T>::Loop()
		IL_002c: newobj instance void [mscorlib]System.Threading.ThreadStart::.ctor(object, native int)
		IL_0031: newobj instance void [mscorlib]System.Threading.Thread::.ctor(class [mscorlib]System.Threading.ThreadStart)
		IL_0036: stfld class [mscorlib]System.Threading.Thread class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1<!T>::_thread
		IL_003b: ldarg.0
		IL_003c: ldfld class [mscorlib]System.Threading.Thread class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1<!T>::_thread
		IL_0041: ldc.i4.1
		IL_0042: callvirt instance void [mscorlib]System.Threading.Thread::set_IsBackground(bool)
		IL_0047: ldarg.0
		IL_0048: ldfld class [mscorlib]System.Threading.Thread class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1<!T>::_thread
		IL_004d: ldstr "clerk:"
		IL_0052: ldarg.1
		IL_0053: call string [mscorlib]System.String::Concat(string, string)
		IL_0058: callvirt instance void [mscorlib]System.Threading.Thread::set_Name(string)
		IL_005d: ldarg.0
		IL_005e: ldfld class [mscorlib]System.Threading.Thread class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1<!T>::_thread
		IL_0063: callvirt instance void [mscorlib]System.Threading.Thread::Start()
		IL_0068: ret
	} // end of method ThreadedClerk`1::.ctor

	.method public final hidebysig specialname newslot virtual 
		instance string get_Name () cil managed 
	{
		// Method begins at RVA 0x3021
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld string class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1<!T>::_name
		IL_0006: ret
	} // end of method ThreadedClerk`1::get_Name

	.method public final hidebysig specialname newslot virtual 
		instance bool get_IsRunning () cil managed 
	{
		// Method begins at RVA 0x3029
		// Header size: 1
		// Code size: 9 (0x9)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: volatile.
		IL_0003: ldfld bool modreq([mscorlib]System.Runtime.CompilerServices.IsVolatile) class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1<!T>::_running
		IL_0008: ret
	} // end of method ThreadedClerk`1::get_IsRunning

	.method public final hidebysig specialname newslot virtual 
		instance int32 get_Handled () cil managed 
	{
		// Method begins at RVA 0x3033
		// Header size: 1
		// Code size: 12 (0xc)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldflda int32 class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1<!T>::_handled
		IL_0006: call int32 [mscorlib]System.Threading.Thread::VolatileRead(int32&)
		IL_000b: ret
	} // end of method ThreadedClerk`1::get_Handled

	.method private hidebysig 
		instance void Loop () cil managed 
	{
		// Method begins at RVA 0x3040
		// Header size: 12
		// Code size: 97 (0x61)
		.maxstack 2
		.locals init (
			[0] !T
		)

		.try
		{
			IL_0000: br.s IL_0045
			// loop start (head: IL_0045)
				IL_0002: ldarg.0
				IL_0003: ldflda int32 class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1<!T>::_busy
				IL_0008: ldc.i4.1
				IL_0009: call int32 [mscorlib]System.Threading.Interlocked::Exchange(int32&, int32)
				IL_000e: pop
				.try
				{
					.try
					{
						IL_000f: ldarg.0
						IL_0010: ldfld class [mscorlib]System.Action`1<!0> class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1<!T>::_handle
						IL_0015: ldloc.0
						IL_0016: callvirt instance void class [mscorlib]System.Action`1<!T>::Invoke(!0)
						IL_001b: leave.s IL_0045
					} // end .try
					catch [mscorlib]System.Exception
					{
						IL_001d: pop
						IL_001e: leave.s IL_0045
					} // end handler
				} // end .try
				finally
				{
					IL_0020: ldarg.0
					IL_0021: ldflda int32 class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1<!T>::_handled
					IL_0026: call int32 [mscorlib]System.Threading.Interlocked::Increment(int32&)
					IL_002b: pop
					IL_002c: ldarg.0
					IL_002d: ldfld class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!0> class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1<!T>::_tray
					IL_0032: callvirt instance void class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::Handled()
					IL_0037: ldarg.0
					IL_0038: ldflda int32 class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1<!T>::_busy
					IL_003d: ldc.i4.0
					IL_003e: call int32 [mscorlib]System.Threading.Interlocked::Exchange(int32&, int32)
					IL_0043: pop
					IL_0044: endfinally
				} // end handler

				IL_0045: ldarg.0
				IL_0046: ldfld class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!0> class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1<!T>::_tray
				IL_004b: ldloca.s 0
				IL_004d: callvirt instance bool class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::TakeBlocking(!0&)
				IL_0052: brtrue.s IL_0002
			// end loop

			IL_0054: leave.s IL_0060
		} // end .try
		finally
		{
			IL_0056: ldarg.0
			IL_0057: ldc.i4.0
			IL_0058: volatile.
			IL_005a: stfld bool modreq([mscorlib]System.Runtime.CompilerServices.IsVolatile) class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1<!T>::_running
			IL_005f: endfinally
		} // end handler

		IL_0060: ret
	} // end of method ThreadedClerk`1::Loop

	.method public final hidebysig newslot virtual 
		instance bool WaitUntilIdle (
			int32 timeoutMs
		) cil managed 
	{
		// Method begins at RVA 0x30d8
		// Header size: 12
		// Code size: 69 (0x45)
		.maxstack 2
		.locals init (
			[0] valuetype [mscorlib]System.DateTime,
			[1] valuetype [mscorlib]System.DateTime
		)

		IL_0000: call valuetype [mscorlib]System.DateTime [mscorlib]System.DateTime::get_UtcNow()
		IL_0005: stloc.1
		IL_0006: ldloca.s 1
		IL_0008: ldarg.1
		IL_0009: conv.r8
		IL_000a: call instance valuetype [mscorlib]System.DateTime [mscorlib]System.DateTime::AddMilliseconds(float64)
		IL_000f: stloc.0
		IL_0010: br.s IL_0027
		// loop start (head: IL_0027)
			IL_0012: call valuetype [mscorlib]System.DateTime [mscorlib]System.DateTime::get_UtcNow()
			IL_0017: ldloc.0
			IL_0018: call bool [mscorlib]System.DateTime::op_GreaterThanOrEqual(valuetype [mscorlib]System.DateTime, valuetype [mscorlib]System.DateTime)
			IL_001d: brfalse.s IL_0021

			IL_001f: ldc.i4.0
			IL_0020: ret

			IL_0021: ldc.i4.1
			IL_0022: call void [mscorlib]System.Threading.Thread::Sleep(int32)

			IL_0027: ldarg.0
			IL_0028: ldfld class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!0> class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1<!T>::_tray
			IL_002d: callvirt instance int32 class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::get_Pending()
			IL_0032: ldc.i4.0
			IL_0033: bgt.s IL_0012

			IL_0035: ldarg.0
			IL_0036: ldflda int32 class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1<!T>::_busy
			IL_003b: call int32 [mscorlib]System.Threading.Thread::VolatileRead(int32&)
			IL_0040: ldc.i4.1
			IL_0041: beq.s IL_0012
		// end loop

		IL_0043: ldc.i4.1
		IL_0044: ret
	} // end of method ThreadedClerk`1::WaitUntilIdle

	.method public final hidebysig newslot virtual 
		instance void Dispose () cil managed 
	{
		// Method begins at RVA 0x3129
		// Header size: 1
		// Code size: 29 (0x1d)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!0> class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1<!T>::_tray
		IL_0006: callvirt instance void class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::Close()
		IL_000b: ldarg.0
		IL_000c: ldfld class [mscorlib]System.Threading.Thread class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1<!T>::_thread
		IL_0011: ldc.i4 2000
		IL_0016: callvirt instance bool [mscorlib]System.Threading.Thread::Join(int32)
		IL_001b: pop
		IL_001c: ret
	} // end of method ThreadedClerk`1::Dispose

	// Properties
	.property instance string Name()
	{
		.get instance string MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1::get_Name()
	}
	.property instance bool IsRunning()
	{
		.get instance bool MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1::get_IsRunning()
	}
	.property instance int32 Handled()
	{
		.get instance int32 MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1::get_Handled()
	}

} // end of class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedDesk
	extends [mscorlib]System.Object
	implements MMP.AsyncProxy.Training.Mailbox.IDesk,
	           [mscorlib]System.IDisposable
{
	// Fields
	.field private initonly class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.IDisposable> _seated

	// Methods
	.method public final hidebysig specialname newslot virtual 
		instance string get_Version () cil managed 
	{
		// Method begins at RVA 0x3147
		// Header size: 1
		// Code size: 6 (0x6)
		.maxstack 8

		IL_0000: ldstr "threaded"
		IL_0005: ret
	} // end of method ThreadedDesk::get_Version

	.method public final hidebysig newslot virtual 
		instance class MMP.AsyncProxy.Training.Mailbox.IInTray`1<!!T> OpenTray<T> (
			string name,
			int32 capacity
		) cil managed 
	{
		// Method begins at RVA 0x314e
		// Header size: 1
		// Code size: 8 (0x8)
		.maxstack 8

		IL_0000: ldarg.1
		IL_0001: ldarg.2
		IL_0002: newobj instance void class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!!T>::.ctor(string, int32)
		IL_0007: ret
	} // end of method ThreadedDesk::OpenTray

	.method public final hidebysig newslot virtual 
		instance class MMP.AsyncProxy.Training.Mailbox.IClerk Seat<T> (
			string name,
			class MMP.AsyncProxy.Training.Mailbox.IInTray`1<!!T> tray,
			class [mscorlib]System.Action`1<!!T> handle
		) cil managed 
	{
		// Method begins at RVA 0x3158
		// Header size: 12
		// Code size: 50 (0x32)
		.maxstack 3
		.locals init (
			[0] class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1<!!T>,
			[1] class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.IDisposable>
		)

		IL_0000: ldarg.1
		IL_0001: ldarg.2
		IL_0002: castclass class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!!T>
		IL_0007: ldarg.3
		IL_0008: newobj instance void class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedClerk`1<!!T>::.ctor(string, class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!0>, class [mscorlib]System.Action`1<!0>)
		IL_000d: stloc.0
		IL_000e: ldarg.0
		IL_000f: ldfld class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.IDisposable> MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedDesk::_seated
		IL_0014: stloc.1
		IL_0015: ldloc.1
		IL_0016: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_001b: ldarg.0
			IL_001c: ldfld class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.IDisposable> MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedDesk::_seated
			IL_0021: ldloc.0
			IL_0022: callvirt instance void class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.IDisposable>::Add(!0)
			IL_0027: leave.s IL_0030
		} // end .try
		finally
		{
			IL_0029: ldloc.1
			IL_002a: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_002f: endfinally
		} // end handler

		IL_0030: ldloc.0
		IL_0031: ret
	} // end of method ThreadedDesk::Seat

	.method public final hidebysig newslot virtual 
		instance void Dispose () cil managed 
	{
		// Method begins at RVA 0x31a8
		// Header size: 12
		// Code size: 70 (0x46)
		.maxstack 2
		.locals init (
			[0] class [mscorlib]System.IDisposable[],
			[1] class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.IDisposable>,
			[2] class [mscorlib]System.IDisposable[],
			[3] int32
		)

		IL_0000: ldarg.0
		IL_0001: ldfld class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.IDisposable> MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedDesk::_seated
		IL_0006: stloc.1
		IL_0007: ldloc.1
		IL_0008: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_000d: ldarg.0
			IL_000e: ldfld class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.IDisposable> MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedDesk::_seated
			IL_0013: callvirt instance !0[] class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.IDisposable>::ToArray()
			IL_0018: stloc.0
			IL_0019: ldarg.0
			IL_001a: ldfld class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.IDisposable> MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedDesk::_seated
			IL_001f: callvirt instance void class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.IDisposable>::Clear()
			IL_0024: leave.s IL_002d
		} // end .try
		finally
		{
			IL_0026: ldloc.1
			IL_0027: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_002c: endfinally
		} // end handler

		IL_002d: ldloc.0
		IL_002e: stloc.2
		IL_002f: ldc.i4.0
		IL_0030: stloc.3
		IL_0031: br.s IL_003f
		// loop start (head: IL_003f)
			IL_0033: ldloc.2
			IL_0034: ldloc.3
			IL_0035: ldelem.ref
			IL_0036: callvirt instance void [mscorlib]System.IDisposable::Dispose()
			IL_003b: ldloc.3
			IL_003c: ldc.i4.1
			IL_003d: add
			IL_003e: stloc.3

			IL_003f: ldloc.3
			IL_0040: ldloc.2
			IL_0041: ldlen
			IL_0042: conv.i4
			IL_0043: blt.s IL_0033
		// end loop

		IL_0045: ret
	} // end of method ThreadedDesk::Dispose

	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x320c
		// Header size: 1
		// Code size: 18 (0x12)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: newobj instance void class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.IDisposable>::.ctor()
		IL_0006: stfld class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.IDisposable> MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedDesk::_seated
		IL_000b: ldarg.0
		IL_000c: call instance void [mscorlib]System.Object::.ctor()
		IL_0011: ret
	} // end of method ThreadedDesk::.ctor

	// Properties
	.property instance string Version()
	{
		.get instance string MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedDesk::get_Version()
	}

} // end of class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedDesk

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<T>
	extends [mscorlib]System.Object
	implements class MMP.AsyncProxy.Training.Mailbox.IInTray`1<!T>
{
	// Fields
	.field private initonly object _gate
	.field private initonly class [System]System.Collections.Generic.Queue`1<!T> _slips
	.field private initonly string _name
	.field private initonly int32 _capacity
	.field private int32 _pending
	.field private bool _closed

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			string name,
			int32 capacity
		) cil managed 
	{
		// Method begins at RVA 0x321f
		// Header size: 1
		// Code size: 43 (0x2b)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: newobj instance void [mscorlib]System.Object::.ctor()
		IL_0006: stfld object class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::_gate
		IL_000b: ldarg.0
		IL_000c: newobj instance void class [System]System.Collections.Generic.Queue`1<!T>::.ctor()
		IL_0011: stfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::_slips
		IL_0016: ldarg.0
		IL_0017: call instance void [mscorlib]System.Object::.ctor()
		IL_001c: ldarg.0
		IL_001d: ldarg.1
		IL_001e: stfld string class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::_name
		IL_0023: ldarg.0
		IL_0024: ldarg.2
		IL_0025: stfld int32 class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::_capacity
		IL_002a: ret
	} // end of method ThreadedInTray`1::.ctor

	.method public final hidebysig specialname newslot virtual 
		instance string get_Name () cil managed 
	{
		// Method begins at RVA 0x324b
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld string class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::_name
		IL_0006: ret
	} // end of method ThreadedInTray`1::get_Name

	.method public final hidebysig specialname newslot virtual 
		instance int32 get_Capacity () cil managed 
	{
		// Method begins at RVA 0x3253
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld int32 class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::_capacity
		IL_0006: ret
	} // end of method ThreadedInTray`1::get_Capacity

	.method public final hidebysig specialname newslot virtual 
		instance int32 get_Pending () cil managed 
	{
		// Method begins at RVA 0x325b
		// Header size: 1
		// Code size: 12 (0xc)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldflda int32 class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::_pending
		IL_0006: call int32 [mscorlib]System.Threading.Thread::VolatileRead(int32&)
		IL_000b: ret
	} // end of method ThreadedInTray`1::get_Pending

	.method public final hidebysig newslot virtual 
		instance bool TryPost (
			!T slip
		) cil managed 
	{
		// Method begins at RVA 0x3268
		// Header size: 12
		// Code size: 92 (0x5c)
		.maxstack 2
		.locals init (
			[0] object,
			[1] bool
		)

		IL_0000: ldarg.0
		IL_0001: ldfld object class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::_gate
		IL_0006: stloc.0
		IL_0007: ldloc.0
		IL_0008: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_000d: ldarg.0
			IL_000e: ldfld bool class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::_closed
			IL_0013: brtrue.s IL_0028

			IL_0015: ldarg.0
			IL_0016: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::_slips
			IL_001b: callvirt instance int32 class [System]System.Collections.Generic.Queue`1<!T>::get_Count()
			IL_0020: ldarg.0
			IL_0021: ldfld int32 class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::_capacity
			IL_0026: blt.s IL_002c

			IL_0028: ldc.i4.0
			IL_0029: stloc.1
			IL_002a: leave.s IL_005a

			IL_002c: ldarg.0
			IL_002d: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::_slips
			IL_0032: ldarg.1
			IL_0033: callvirt instance void class [System]System.Collections.Generic.Queue`1<!T>::Enqueue(!0)
			IL_0038: ldarg.0
			IL_0039: ldflda int32 class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::_pending
			IL_003e: call int32 [mscorlib]System.Threading.Interlocked::Increment(int32&)
			IL_0043: pop
			IL_0044: ldarg.0
			IL_0045: ldfld object class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::_gate
			IL_004a: call void [mscorlib]System.Threading.Monitor::Pulse(object)
			IL_004f: ldc.i4.1
			IL_0050: stloc.1
			IL_0051: leave.s IL_005a
		} // end .try
		finally
		{
			IL_0053: ldloc.0
			IL_0054: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_0059: endfinally
		} // end handler

		IL_005a: ldloc.1
		IL_005b: ret
	} // end of method ThreadedInTray`1::TryPost

	.method public final hidebysig newslot virtual 
		instance void Close () cil managed 
	{
		// Method begins at RVA 0x32e0
		// Header size: 12
		// Code size: 41 (0x29)
		.maxstack 2
		.locals init (
			[0] object
		)

		IL_0000: ldarg.0
		IL_0001: ldfld object class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::_gate
		IL_0006: stloc.0
		IL_0007: ldloc.0
		IL_0008: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_000d: ldarg.0
			IL_000e: ldc.i4.1
			IL_000f: stfld bool class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::_closed
			IL_0014: ldarg.0
			IL_0015: ldfld object class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::_gate
			IL_001a: call void [mscorlib]System.Threading.Monitor::PulseAll(object)
			IL_001f: leave.s IL_0028
		} // end .try
		finally
		{
			IL_0021: ldloc.0
			IL_0022: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_0027: endfinally
		} // end handler

		IL_0028: ret
	} // end of method ThreadedInTray`1::Close

	.method assembly hidebysig 
		instance bool TakeBlocking (
			[out] !T& slip
		) cil managed 
	{
		// Method begins at RVA 0x3328
		// Header size: 12
		// Code size: 89 (0x59)
		.maxstack 2
		.locals init (
			[0] object,
			[1] bool
		)

		IL_0000: ldarg.0
		IL_0001: ldfld object class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::_gate
		IL_0006: stloc.0
		IL_0007: ldloc.0
		IL_0008: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_000d: br.s IL_002e
			// loop start (head: IL_002e)
				IL_000f: ldarg.0
				IL_0010: ldfld bool class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::_closed
				IL_0015: brfalse.s IL_0022

				IL_0017: ldarg.1
				IL_0018: initobj !T
				IL_001e: ldc.i4.0
				IL_001f: stloc.1
				IL_0020: leave.s IL_0057

				IL_0022: ldarg.0
				IL_0023: ldfld object class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::_gate
				IL_0028: call bool [mscorlib]System.Threading.Monitor::Wait(object)
				IL_002d: pop

				IL_002e: ldarg.0
				IL_002f: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::_slips
				IL_0034: callvirt instance int32 class [System]System.Collections.Generic.Queue`1<!T>::get_Count()
				IL_0039: brfalse.s IL_000f
			// end loop

			IL_003b: ldarg.1
			IL_003c: ldarg.0
			IL_003d: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::_slips
			IL_0042: callvirt instance !0 class [System]System.Collections.Generic.Queue`1<!T>::Dequeue()
			IL_0047: stobj !T
			IL_004c: ldc.i4.1
			IL_004d: stloc.1
			IL_004e: leave.s IL_0057
		} // end .try
		finally
		{
			IL_0050: ldloc.0
			IL_0051: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_0056: endfinally
		} // end handler

		IL_0057: ldloc.1
		IL_0058: ret
	} // end of method ThreadedInTray`1::TakeBlocking

	.method assembly hidebysig 
		instance void Handled () cil managed 
	{
		// Method begins at RVA 0x33a0
		// Header size: 1
		// Code size: 13 (0xd)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldflda int32 class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1<!T>::_pending
		IL_0006: call int32 [mscorlib]System.Threading.Interlocked::Decrement(int32&)
		IL_000b: pop
		IL_000c: ret
	} // end of method ThreadedInTray`1::Handled

	// Properties
	.property instance string Name()
	{
		.get instance string MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1::get_Name()
	}
	.property instance int32 Capacity()
	{
		.get instance int32 MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1::get_Capacity()
	}
	.property instance int32 Pending()
	{
		.get instance int32 MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1::get_Pending()
	}

} // end of class MMP.AsyncProxy.Training.Mailbox.Threaded.ThreadedInTray`1

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Mailbox.Async.AsyncProxyDesk
	extends [mscorlib]System.Object
	implements MMP.AsyncProxy.Training.Mailbox.IDesk,
	           [mscorlib]System.IDisposable
{
	// Fields
	.field private initonly class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.IDisposable> _seated

	// Methods
	.method public final hidebysig specialname newslot virtual 
		instance string get_Version () cil managed 
	{
		// Method begins at RVA 0x33ae
		// Header size: 1
		// Code size: 6 (0x6)
		.maxstack 8

		IL_0000: ldstr "asyncproxy"
		IL_0005: ret
	} // end of method AsyncProxyDesk::get_Version

	.method public final hidebysig newslot virtual 
		instance class MMP.AsyncProxy.Training.Mailbox.IInTray`1<!!T> OpenTray<T> (
			string name,
			int32 capacity
		) cil managed 
	{
		// Method begins at RVA 0x33b5
		// Header size: 1
		// Code size: 8 (0x8)
		.maxstack 8

		IL_0000: ldarg.1
		IL_0001: ldarg.2
		IL_0002: newobj instance void class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!!T>::.ctor(string, int32)
		IL_0007: ret
	} // end of method AsyncProxyDesk::OpenTray

	.method public final hidebysig newslot virtual 
		instance class MMP.AsyncProxy.Training.Mailbox.IClerk Seat<T> (
			string name,
			class MMP.AsyncProxy.Training.Mailbox.IInTray`1<!!T> tray,
			class [mscorlib]System.Action`1<!!T> handle
		) cil managed 
	{
		// Method begins at RVA 0x33c0
		// Header size: 12
		// Code size: 50 (0x32)
		.maxstack 3
		.locals init (
			[0] class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!!T>,
			[1] class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.IDisposable>
		)

		IL_0000: ldarg.1
		IL_0001: ldarg.2
		IL_0002: castclass class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!!T>
		IL_0007: ldarg.3
		IL_0008: newobj instance void class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!!T>::.ctor(string, class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!0>, class [mscorlib]System.Action`1<!0>)
		IL_000d: stloc.0
		IL_000e: ldarg.0
		IL_000f: ldfld class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.IDisposable> MMP.AsyncProxy.Training.Mailbox.Async.AsyncProxyDesk::_seated
		IL_0014: stloc.1
		IL_0015: ldloc.1
		IL_0016: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_001b: ldarg.0
			IL_001c: ldfld class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.IDisposable> MMP.AsyncProxy.Training.Mailbox.Async.AsyncProxyDesk::_seated
			IL_0021: ldloc.0
			IL_0022: callvirt instance void class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.IDisposable>::Add(!0)
			IL_0027: leave.s IL_0030
		} // end .try
		finally
		{
			IL_0029: ldloc.1
			IL_002a: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_002f: endfinally
		} // end handler

		IL_0030: ldloc.0
		IL_0031: ret
	} // end of method AsyncProxyDesk::Seat

	.method public final hidebysig newslot virtual 
		instance void Dispose () cil managed 
	{
		// Method begins at RVA 0x3410
		// Header size: 12
		// Code size: 70 (0x46)
		.maxstack 2
		.locals init (
			[0] class [mscorlib]System.IDisposable[],
			[1] class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.IDisposable>,
			[2] class [mscorlib]System.IDisposable[],
			[3] int32
		)

		IL_0000: ldarg.0
		IL_0001: ldfld class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.IDisposable> MMP.AsyncProxy.Training.Mailbox.Async.AsyncProxyDesk::_seated
		IL_0006: stloc.1
		IL_0007: ldloc.1
		IL_0008: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_000d: ldarg.0
			IL_000e: ldfld class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.IDisposable> MMP.AsyncProxy.Training.Mailbox.Async.AsyncProxyDesk::_seated
			IL_0013: callvirt instance !0[] class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.IDisposable>::ToArray()
			IL_0018: stloc.0
			IL_0019: ldarg.0
			IL_001a: ldfld class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.IDisposable> MMP.AsyncProxy.Training.Mailbox.Async.AsyncProxyDesk::_seated
			IL_001f: callvirt instance void class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.IDisposable>::Clear()
			IL_0024: leave.s IL_002d
		} // end .try
		finally
		{
			IL_0026: ldloc.1
			IL_0027: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_002c: endfinally
		} // end handler

		IL_002d: ldloc.0
		IL_002e: stloc.2
		IL_002f: ldc.i4.0
		IL_0030: stloc.3
		IL_0031: br.s IL_003f
		// loop start (head: IL_003f)
			IL_0033: ldloc.2
			IL_0034: ldloc.3
			IL_0035: ldelem.ref
			IL_0036: callvirt instance void [mscorlib]System.IDisposable::Dispose()
			IL_003b: ldloc.3
			IL_003c: ldc.i4.1
			IL_003d: add
			IL_003e: stloc.3

			IL_003f: ldloc.3
			IL_0040: ldloc.2
			IL_0041: ldlen
			IL_0042: conv.i4
			IL_0043: blt.s IL_0033
		// end loop

		IL_0045: ret
	} // end of method AsyncProxyDesk::Dispose

	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x3474
		// Header size: 1
		// Code size: 18 (0x12)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: newobj instance void class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.IDisposable>::.ctor()
		IL_0006: stfld class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.IDisposable> MMP.AsyncProxy.Training.Mailbox.Async.AsyncProxyDesk::_seated
		IL_000b: ldarg.0
		IL_000c: call instance void [mscorlib]System.Object::.ctor()
		IL_0011: ret
	} // end of method AsyncProxyDesk::.ctor

	// Properties
	.property instance string Version()
	{
		.get instance string MMP.AsyncProxy.Training.Mailbox.Async.AsyncProxyDesk::get_Version()
	}

} // end of class MMP.AsyncProxy.Training.Mailbox.Async.AsyncProxyDesk

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<T>
	extends [mscorlib]System.Object
	implements MMP.AsyncProxy.Training.Mailbox.IClerk,
	           [mscorlib]System.IDisposable
{
	// Nested Types
	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass17_0'<T>
		extends [mscorlib]System.Object
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field public class [mscorlib]System.Threading.ManualResetEvent done

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor () cil managed 
		{
			// Method begins at RVA 0x50c8
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass17_0'::.ctor

		.method assembly hidebysig 
			instance void '<Dispose>b__0' () cil managed 
		{
			// Method begins at RVA 0x50d0
			// Header size: 1
			// Code size: 13 (0xd)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [mscorlib]System.Threading.ManualResetEvent class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<>c__DisplayClass17_0'<!T>::done
			IL_0006: callvirt instance bool [mscorlib]System.Threading.EventWaitHandle::Set()
			IL_000b: pop
			IL_000c: ret
		} // end of method '<>c__DisplayClass17_0'::'<Dispose>b__0'

	} // end of class <>c__DisplayClass17_0

	.class nested private auto ansi sealed beforefieldinit '<Loop>d__14'<T>
		extends [mscorlib]System.Object
		implements class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>,
		           [mscorlib]System.Collections.IEnumerable,
		           class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>,
		           [mscorlib]System.IDisposable,
		           [mscorlib]System.Collections.IEnumerator
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field private int32 '<>1__state'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture '<>2__current'
		.field private int32 '<>l__initialThreadId'
		.field public class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T> '<>4__this'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!T> '<next>5__2'

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor (
				int32 '<>1__state'
			) cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			// Method begins at RVA 0x50de
			// Header size: 1
			// Code size: 30 (0x1e)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ldarg.0
			IL_0007: ldarg.1
			IL_0008: stfld int32 class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<>1__state'
			IL_000d: ldarg.0
			IL_000e: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0013: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_0018: stfld int32 class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<>l__initialThreadId'
			IL_001d: ret
		} // end of method '<Loop>d__14'::.ctor

		.method private final hidebysig newslot virtual 
			instance void System.IDisposable.Dispose () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [mscorlib]System.IDisposable::Dispose()
			// Method begins at RVA 0x50fd
			// Header size: 1
			// Code size: 16 (0x10)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldnull
			IL_0002: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<next>5__2'
			IL_0007: ldarg.0
			IL_0008: ldc.i4.s -2
			IL_000a: stfld int32 class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<>1__state'
			IL_000f: ret
		} // end of method '<Loop>d__14'::System.IDisposable.Dispose

		.method private final hidebysig newslot virtual 
			instance bool MoveNext () cil managed 
		{
			.override method instance bool [mscorlib]System.Collections.IEnumerator::MoveNext()
			// Method begins at RVA 0x5110
			// Header size: 12
			// Code size: 179 (0xb3)
			.maxstack 2
			.locals init (
				[0] int32,
				[1] class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>,
				[2] !T
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<>1__state'
			IL_0006: stloc.0
			IL_0007: ldarg.0
			IL_0008: ldfld class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<>4__this'
			IL_000d: stloc.1
			IL_000e: ldloc.0
			IL_000f: brfalse.s IL_0017

			IL_0011: ldloc.0
			IL_0012: ldc.i4.1
			IL_0013: beq.s IL_005d

			IL_0015: ldc.i4.0
			IL_0016: ret

			IL_0017: ldarg.0
			IL_0018: ldc.i4.m1
			IL_0019: stfld int32 class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<>1__state'
			IL_001e: br IL_00a4

			IL_0023: ldloc.1
			IL_0024: ldfld class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_tray
			IL_0029: ldloca.s 2
			IL_002b: callvirt instance bool class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::TryTake(!0&)
			IL_0030: brtrue.s IL_009d

			IL_0032: ldarg.0
			IL_0033: ldloc.1
			IL_0034: ldfld class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_tray
			IL_0039: callvirt instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::TakeAsync()
			IL_003e: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<next>5__2'
			IL_0043: ldarg.0
			IL_0044: ldarg.0
			IL_0045: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<next>5__2'
			IL_004a: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture [MMP.AsyncProxy]MMP.AsyncProxy.Futures::Observe(class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture)
			IL_004f: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<>2__current'
			IL_0054: ldarg.0
			IL_0055: ldc.i4.1
			IL_0056: stfld int32 class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<>1__state'
			IL_005b: ldc.i4.1
			IL_005c: ret

			IL_005d: ldarg.0
			IL_005e: ldc.i4.m1
			IL_005f: stfld int32 class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<>1__state'
			IL_0064: ldarg.0
			IL_0065: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<next>5__2'
			IL_006a: callvirt instance bool [MMP.AsyncProxy]MMP.AsyncProxy.IFuture::get_IsCanceled()
			IL_006f: brtrue.s IL_0088

			IL_0071: ldarg.0
			IL_0072: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<next>5__2'
			IL_0077: callvirt instance bool [MMP.AsyncProxy]MMP.AsyncProxy.IFuture::get_IsFaulted()
			IL_007c: brtrue.s IL_0088

			IL_007e: ldloc.1
			IL_007f: volatile.
			IL_0081: ldfld bool modreq([mscorlib]System.Runtime.CompilerServices.IsVolatile) class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_stopping
			IL_0086: brfalse.s IL_008a

			IL_0088: ldc.i4.0
			IL_0089: ret

			IL_008a: ldarg.0
			IL_008b: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<next>5__2'
			IL_0090: callvirt instance !0 class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!T>::get_Result()
			IL_0095: stloc.2
			IL_0096: ldarg.0
			IL_0097: ldnull
			IL_0098: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<next>5__2'

			IL_009d: ldloc.1
			IL_009e: ldloc.2
			IL_009f: call instance void class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::Handle(!0)

			IL_00a4: ldloc.1
			IL_00a5: volatile.
			IL_00a7: ldfld bool modreq([mscorlib]System.Runtime.CompilerServices.IsVolatile) class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_stopping
			IL_00ac: brfalse IL_0023

			IL_00b1: ldc.i4.0
			IL_00b2: ret
		} // end of method '<Loop>d__14'::MoveNext

		.method private final hidebysig specialname newslot virtual 
			instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance !0 class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::get_Current()
			// Method begins at RVA 0x51cf
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<>2__current'
			IL_0006: ret
		} // end of method '<Loop>d__14'::'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current'

		.method private final hidebysig newslot virtual 
			instance void System.Collections.IEnumerator.Reset () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [mscorlib]System.Collections.IEnumerator::Reset()
			// Method begins at RVA 0x51d7
			// Header size: 1
			// Code size: 6 (0x6)
			.maxstack 8

			IL_0000: newobj instance void [mscorlib]System.NotSupportedException::.ctor()
			IL_0005: throw
		} // end of method '<Loop>d__14'::System.Collections.IEnumerator.Reset

		.method private final hidebysig specialname newslot virtual 
			instance object System.Collections.IEnumerator.get_Current () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance object [mscorlib]System.Collections.IEnumerator::get_Current()
			// Method begins at RVA 0x51de
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<>2__current'
			IL_0006: ret
		} // end of method '<Loop>d__14'::System.Collections.IEnumerator.get_Current

		.method private final hidebysig newslot virtual 
			instance class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> 'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance class [mscorlib]System.Collections.Generic.IEnumerator`1<!0> class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::GetEnumerator()
			// Method begins at RVA 0x51e8
			// Header size: 12
			// Code size: 60 (0x3c)
			.maxstack 2
			.locals init (
				[0] class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<>1__state'
			IL_0006: ldc.i4.s -2
			IL_0008: bne.un.s IL_0027

			IL_000a: ldarg.0
			IL_000b: ldfld int32 class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<>l__initialThreadId'
			IL_0010: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0015: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_001a: bne.un.s IL_0027

			IL_001c: ldarg.0
			IL_001d: ldc.i4.0
			IL_001e: stfld int32 class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<>1__state'
			IL_0023: ldarg.0
			IL_0024: stloc.0
			IL_0025: br.s IL_003a

			IL_0027: ldc.i4.0
			IL_0028: newobj instance void class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::.ctor(int32)
			IL_002d: stloc.0
			IL_002e: ldloc.0
			IL_002f: ldarg.0
			IL_0030: ldfld class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<>4__this'
			IL_0035: stfld class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<>4__this'

			IL_003a: ldloc.0
			IL_003b: ret
		} // end of method '<Loop>d__14'::'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator'

		.method private final hidebysig newslot virtual 
			instance class [mscorlib]System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance class [mscorlib]System.Collections.IEnumerator [mscorlib]System.Collections.IEnumerable::GetEnumerator()
			// Method begins at RVA 0x5230
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator'()
			IL_0006: ret
		} // end of method '<Loop>d__14'::System.Collections.IEnumerable.GetEnumerator

		// Properties
		.property instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.Current'()
		{
			.get instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'::'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current'()
		}
		.property instance object System.Collections.IEnumerator.Current()
		{
			.get instance object MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'::System.Collections.IEnumerator.get_Current()
		}

	} // end of class <Loop>d__14


	// Fields
	.field private initonly string _name
	.field private initonly class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T> _tray
	.field private initonly class [mscorlib]System.Action`1<!T> _handle
	.field private initonly class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture _loop
	.field private bool modreq([mscorlib]System.Runtime.CompilerServices.IsVolatile) _stopping
	.field private int32 _handled
	.field private int32 _busy

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			string name,
			class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T> tray,
			class [mscorlib]System.Action`1<!T> handle
		) cil managed 
	{
		// Method begins at RVA 0x3487
		// Header size: 1
		// Code size: 45 (0x2d)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: call instance void [mscorlib]System.Object::.ctor()
		IL_0006: ldarg.0
		IL_0007: ldarg.1
		IL_0008: stfld string class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_name
		IL_000d: ldarg.0
		IL_000e: ldarg.2
		IL_000f: stfld class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_tray
		IL_0014: ldarg.0
		IL_0015: ldarg.3
		IL_0016: stfld class [mscorlib]System.Action`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_handle
		IL_001b: ldarg.0
		IL_001c: ldarg.0
		IL_001d: call instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::Loop()
		IL_0022: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture [MMP.AsyncProxy]MMP.AsyncProxy.AsyncProxy::Run(class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>)
		IL_0027: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_loop
		IL_002c: ret
	} // end of method IteratorClerk`1::.ctor

	.method public final hidebysig specialname newslot virtual 
		instance string get_Name () cil managed 
	{
		// Method begins at RVA 0x34b5
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld string class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_name
		IL_0006: ret
	} // end of method IteratorClerk`1::get_Name

	.method public final hidebysig specialname newslot virtual 
		instance bool get_IsRunning () cil managed 
	{
		// Method begins at RVA 0x34bd
		// Header size: 1
		// Code size: 15 (0xf)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_loop
		IL_0006: callvirt instance bool [MMP.AsyncProxy]MMP.AsyncProxy.IFuture::get_IsCompleted()
		IL_000b: ldc.i4.0
		IL_000c: ceq
		IL_000e: ret
	} // end of method IteratorClerk`1::get_IsRunning

	.method public final hidebysig specialname newslot virtual 
		instance int32 get_Handled () cil managed 
	{
		// Method begins at RVA 0x34cd
		// Header size: 1
		// Code size: 12 (0xc)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldflda int32 class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_handled
		IL_0006: call int32 [mscorlib]System.Threading.Thread::VolatileRead(int32&)
		IL_000b: ret
	} // end of method IteratorClerk`1::get_Handled

	.method private hidebysig 
		instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> Loop () cil managed 
	{
		// Method begins at RVA 0x34da
		// Header size: 1
		// Code size: 15 (0xf)
		.maxstack 8

		IL_0000: ldc.i4.s -2
		IL_0002: newobj instance void class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::.ctor(int32)
		IL_0007: dup
		IL_0008: ldarg.0
		IL_0009: stfld class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<>4__this'
		IL_000e: ret
	} // end of method IteratorClerk`1::Loop

	.method private hidebysig 
		instance void Handle (
			!T slip
		) cil managed 
	{
		// Method begins at RVA 0x34ec
		// Header size: 12
		// Code size: 68 (0x44)
		.maxstack 2

		IL_0000: ldarg.0
		IL_0001: ldflda int32 class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_busy
		IL_0006: ldc.i4.1
		IL_0007: call int32 [mscorlib]System.Threading.Interlocked::Exchange(int32&, int32)
		IL_000c: pop
		.try
		{
			.try
			{
				IL_000d: ldarg.0
				IL_000e: ldfld class [mscorlib]System.Action`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_handle
				IL_0013: ldarg.1
				IL_0014: callvirt instance void class [mscorlib]System.Action`1<!T>::Invoke(!0)
				IL_0019: leave.s IL_0043
			} // end .try
			catch [mscorlib]System.Exception
			{
				IL_001b: pop
				IL_001c: leave.s IL_0043
			} // end handler
		} // end .try
		finally
		{
			IL_001e: ldarg.0
			IL_001f: ldflda int32 class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_handled
			IL_0024: call int32 [mscorlib]System.Threading.Interlocked::Increment(int32&)
			IL_0029: pop
			IL_002a: ldarg.0
			IL_002b: ldfld class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_tray
			IL_0030: callvirt instance void class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::Handled()
			IL_0035: ldarg.0
			IL_0036: ldflda int32 class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_busy
			IL_003b: ldc.i4.0
			IL_003c: call int32 [mscorlib]System.Threading.Interlocked::Exchange(int32&, int32)
			IL_0041: pop
			IL_0042: endfinally
		} // end handler

		IL_0043: ret
	} // end of method IteratorClerk`1::Handle

	.method public final hidebysig newslot virtual 
		instance bool WaitUntilIdle (
			int32 timeoutMs
		) cil managed 
	{
		// Method begins at RVA 0x3558
		// Header size: 12
		// Code size: 69 (0x45)
		.maxstack 2
		.locals init (
			[0] valuetype [mscorlib]System.DateTime,
			[1] valuetype [mscorlib]System.DateTime
		)

		IL_0000: call valuetype [mscorlib]System.DateTime [mscorlib]System.DateTime::get_UtcNow()
		IL_0005: stloc.1
		IL_0006: ldloca.s 1
		IL_0008: ldarg.1
		IL_0009: conv.r8
		IL_000a: call instance valuetype [mscorlib]System.DateTime [mscorlib]System.DateTime::AddMilliseconds(float64)
		IL_000f: stloc.0
		IL_0010: br.s IL_0027
		// loop start (head: IL_0027)
			IL_0012: call valuetype [mscorlib]System.DateTime [mscorlib]System.DateTime::get_UtcNow()
			IL_0017: ldloc.0
			IL_0018: call bool [mscorlib]System.DateTime::op_GreaterThanOrEqual(valuetype [mscorlib]System.DateTime, valuetype [mscorlib]System.DateTime)
			IL_001d: brfalse.s IL_0021

			IL_001f: ldc.i4.0
			IL_0020: ret

			IL_0021: ldc.i4.1
			IL_0022: call void [mscorlib]System.Threading.Thread::Sleep(int32)

			IL_0027: ldarg.0
			IL_0028: ldfld class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_tray
			IL_002d: callvirt instance int32 class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::get_Pending()
			IL_0032: ldc.i4.0
			IL_0033: bgt.s IL_0012

			IL_0035: ldarg.0
			IL_0036: ldflda int32 class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_busy
			IL_003b: call int32 [mscorlib]System.Threading.Thread::VolatileRead(int32&)
			IL_0040: ldc.i4.1
			IL_0041: beq.s IL_0012
		// end loop

		IL_0043: ldc.i4.1
		IL_0044: ret
	} // end of method IteratorClerk`1::WaitUntilIdle

	.method public final hidebysig newslot virtual 
		instance void Dispose () cil managed 
	{
		// Method begins at RVA 0x35ac
		// Header size: 12
		// Code size: 106 (0x6a)
		.maxstack 3
		.locals init (
			[0] class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<>c__DisplayClass17_0'<!T>
		)

		IL_0000: ldarg.0
		IL_0001: ldc.i4.1
		IL_0002: volatile.
		IL_0004: stfld bool modreq([mscorlib]System.Runtime.CompilerServices.IsVolatile) class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_stopping
		IL_0009: ldarg.0
		IL_000a: ldfld class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_tray
		IL_000f: callvirt instance void class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::Close()
		IL_0014: newobj instance void class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<>c__DisplayClass17_0'<!T>::.ctor()
		IL_0019: stloc.0
		IL_001a: ldloc.0
		IL_001b: ldc.i4.0
		IL_001c: newobj instance void [mscorlib]System.Threading.ManualResetEvent::.ctor(bool)
		IL_0021: stfld class [mscorlib]System.Threading.ManualResetEvent class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<>c__DisplayClass17_0'<!T>::done
		.try
		{
			IL_0026: ldarg.0
			IL_0027: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_loop
			IL_002c: callvirt instance class [MMP.AsyncProxy]MMP.AsyncProxy.IAwaiter [MMP.AsyncProxy]MMP.AsyncProxy.IFuture::ContinueOnAnyThread()
			IL_0031: ldloc.0
			IL_0032: ldftn instance void class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<>c__DisplayClass17_0'<!T>::'<Dispose>b__0'()
			IL_0038: newobj instance void [System.Core]System.Action::.ctor(object, native int)
			IL_003d: callvirt instance void [MMP.AsyncProxy]MMP.AsyncProxy.IAwaiter::OnCompleted(class [System.Core]System.Action)
			IL_0042: ldloc.0
			IL_0043: ldfld class [mscorlib]System.Threading.ManualResetEvent class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<>c__DisplayClass17_0'<!T>::done
			IL_0048: ldc.i4 2000
			IL_004d: callvirt instance bool [mscorlib]System.Threading.WaitHandle::WaitOne(int32)
			IL_0052: pop
			IL_0053: leave.s IL_0069
		} // end .try
		finally
		{
			IL_0055: ldloc.0
			IL_0056: ldfld class [mscorlib]System.Threading.ManualResetEvent class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<>c__DisplayClass17_0'<!T>::done
			IL_005b: brfalse.s IL_0068

			IL_005d: ldloc.0
			IL_005e: ldfld class [mscorlib]System.Threading.ManualResetEvent class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<>c__DisplayClass17_0'<!T>::done
			IL_0063: callvirt instance void [mscorlib]System.IDisposable::Dispose()

			IL_0068: endfinally
		} // end handler

		IL_0069: ret
	} // end of method IteratorClerk`1::Dispose

	// Properties
	.property instance string Name()
	{
		.get instance string MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1::get_Name()
	}
	.property instance bool IsRunning()
	{
		.get instance bool MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1::get_IsRunning()
	}
	.property instance int32 Handled()
	{
		.get instance int32 MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1::get_Handled()
	}

} // end of class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<T>
	extends [mscorlib]System.Object
	implements class MMP.AsyncProxy.Training.Mailbox.IInTray`1<!T>
{
	// Fields
	.field private initonly object _gate
	.field private initonly class [System]System.Collections.Generic.Queue`1<!T> _slips
	.field private initonly string _name
	.field private initonly int32 _capacity
	.field private class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T> _waiting
	.field private int32 _pending
	.field private bool _closed

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			string name,
			int32 capacity
		) cil managed 
	{
		// Method begins at RVA 0x3634
		// Header size: 1
		// Code size: 43 (0x2b)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: newobj instance void [mscorlib]System.Object::.ctor()
		IL_0006: stfld object class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_gate
		IL_000b: ldarg.0
		IL_000c: newobj instance void class [System]System.Collections.Generic.Queue`1<!T>::.ctor()
		IL_0011: stfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_slips
		IL_0016: ldarg.0
		IL_0017: call instance void [mscorlib]System.Object::.ctor()
		IL_001c: ldarg.0
		IL_001d: ldarg.1
		IL_001e: stfld string class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_name
		IL_0023: ldarg.0
		IL_0024: ldarg.2
		IL_0025: stfld int32 class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_capacity
		IL_002a: ret
	} // end of method PromiseInTray`1::.ctor

	.method public final hidebysig specialname newslot virtual 
		instance string get_Name () cil managed 
	{
		// Method begins at RVA 0x3660
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld string class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_name
		IL_0006: ret
	} // end of method PromiseInTray`1::get_Name

	.method public final hidebysig specialname newslot virtual 
		instance int32 get_Capacity () cil managed 
	{
		// Method begins at RVA 0x3668
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld int32 class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_capacity
		IL_0006: ret
	} // end of method PromiseInTray`1::get_Capacity

	.method public final hidebysig specialname newslot virtual 
		instance int32 get_Pending () cil managed 
	{
		// Method begins at RVA 0x3670
		// Header size: 1
		// Code size: 12 (0xc)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldflda int32 class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_pending
		IL_0006: call int32 [mscorlib]System.Threading.Thread::VolatileRead(int32&)
		IL_000b: ret
	} // end of method PromiseInTray`1::get_Pending

	.method public final hidebysig newslot virtual 
		instance bool TryPost (
			!T slip
		) cil managed 
	{
		// Method begins at RVA 0x3680
		// Header size: 12
		// Code size: 122 (0x7a)
		.maxstack 2
		.locals init (
			[0] class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>,
			[1] object,
			[2] bool
		)

		IL_0000: ldnull
		IL_0001: stloc.0
		IL_0002: ldarg.0
		IL_0003: ldfld object class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_gate
		IL_0008: stloc.1
		IL_0009: ldloc.1
		IL_000a: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_000f: ldarg.0
			IL_0010: ldfld bool class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_closed
			IL_0015: brfalse.s IL_001b

			IL_0017: ldc.i4.0
			IL_0018: stloc.2
			IL_0019: leave.s IL_0078

			IL_001b: ldarg.0
			IL_001c: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_waiting
			IL_0021: brfalse.s IL_0033

			IL_0023: ldarg.0
			IL_0024: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_waiting
			IL_0029: stloc.0
			IL_002a: ldarg.0
			IL_002b: ldnull
			IL_002c: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_waiting
			IL_0031: br.s IL_0056

			IL_0033: ldarg.0
			IL_0034: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_slips
			IL_0039: callvirt instance int32 class [System]System.Collections.Generic.Queue`1<!T>::get_Count()
			IL_003e: ldarg.0
			IL_003f: ldfld int32 class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_capacity
			IL_0044: blt.s IL_004a

			IL_0046: ldc.i4.0
			IL_0047: stloc.2
			IL_0048: leave.s IL_0078

			IL_004a: ldarg.0
			IL_004b: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_slips
			IL_0050: ldarg.1
			IL_0051: callvirt instance void class [System]System.Collections.Generic.Queue`1<!T>::Enqueue(!0)

			IL_0056: ldarg.0
			IL_0057: ldflda int32 class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_pending
			IL_005c: call int32 [mscorlib]System.Threading.Interlocked::Increment(int32&)
			IL_0061: pop
			IL_0062: leave.s IL_006b
		} // end .try
		finally
		{
			IL_0064: ldloc.1
			IL_0065: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_006a: endfinally
		} // end handler

		IL_006b: ldloc.0
		IL_006c: brfalse.s IL_0076

		IL_006e: ldloc.0
		IL_006f: ldarg.1
		IL_0070: callvirt instance bool class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::TrySetResult(!0)
		IL_0075: pop

		IL_0076: ldc.i4.1
		IL_0077: ret

		IL_0078: ldloc.2
		IL_0079: ret
	} // end of method PromiseInTray`1::TryPost

	.method public final hidebysig newslot virtual 
		instance void Close () cil managed 
	{
		// Method begins at RVA 0x3718
		// Header size: 12
		// Code size: 65 (0x41)
		.maxstack 2
		.locals init (
			[0] class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>,
			[1] object
		)

		IL_0000: ldarg.0
		IL_0001: ldfld object class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_gate
		IL_0006: stloc.1
		IL_0007: ldloc.1
		IL_0008: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_000d: ldarg.0
			IL_000e: ldc.i4.1
			IL_000f: stfld bool class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_closed
			IL_0014: ldarg.0
			IL_0015: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_waiting
			IL_001a: stloc.0
			IL_001b: ldarg.0
			IL_001c: ldnull
			IL_001d: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_waiting
			IL_0022: ldarg.0
			IL_0023: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_slips
			IL_0028: callvirt instance void class [System]System.Collections.Generic.Queue`1<!T>::Clear()
			IL_002d: leave.s IL_0036
		} // end .try
		finally
		{
			IL_002f: ldloc.1
			IL_0030: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_0035: endfinally
		} // end handler

		IL_0036: ldloc.0
		IL_0037: brfalse.s IL_0040

		IL_0039: ldloc.0
		IL_003a: callvirt instance bool class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::TrySetCanceled()
		IL_003f: pop

		IL_0040: ret
	} // end of method PromiseInTray`1::Close

	.method assembly hidebysig 
		instance bool TryTake (
			[out] !T& slip
		) cil managed 
	{
		// Method begins at RVA 0x3778
		// Header size: 12
		// Code size: 68 (0x44)
		.maxstack 2
		.locals init (
			[0] object,
			[1] bool
		)

		IL_0000: ldarg.0
		IL_0001: ldfld object class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_gate
		IL_0006: stloc.0
		IL_0007: ldloc.0
		IL_0008: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_000d: ldarg.0
			IL_000e: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_slips
			IL_0013: callvirt instance int32 class [System]System.Collections.Generic.Queue`1<!T>::get_Count()
			IL_0018: ldc.i4.0
			IL_0019: ble.s IL_0030

			IL_001b: ldarg.1
			IL_001c: ldarg.0
			IL_001d: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_slips
			IL_0022: callvirt instance !0 class [System]System.Collections.Generic.Queue`1<!T>::Dequeue()
			IL_0027: stobj !T
			IL_002c: ldc.i4.1
			IL_002d: stloc.1
			IL_002e: leave.s IL_0042

			IL_0030: ldarg.1
			IL_0031: initobj !T
			IL_0037: ldc.i4.0
			IL_0038: stloc.1
			IL_0039: leave.s IL_0042
		} // end .try
		finally
		{
			IL_003b: ldloc.0
			IL_003c: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_0041: endfinally
		} // end handler

		IL_0042: ldloc.1
		IL_0043: ret
	} // end of method PromiseInTray`1::TryTake

	.method assembly hidebysig 
		instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!T> TakeAsync () cil managed 
	{
		// Method begins at RVA 0x37d8
		// Header size: 12
		// Code size: 109 (0x6d)
		.maxstack 3
		.locals init (
			[0] object,
			[1] class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!T>
		)

		IL_0000: ldarg.0
		IL_0001: ldfld object class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_gate
		IL_0006: stloc.0
		IL_0007: ldloc.0
		IL_0008: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_000d: ldarg.0
			IL_000e: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_slips
			IL_0013: callvirt instance int32 class [System]System.Collections.Generic.Queue`1<!T>::get_Count()
			IL_0018: ldc.i4.0
			IL_0019: ble.s IL_003a

			IL_001b: ldc.i4.1
			IL_001c: newobj instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::.ctor(valuetype [MMP.AsyncProxy]MMP.AsyncProxy.PromiseOptions)
			IL_0021: dup
			IL_0022: ldarg.0
			IL_0023: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_slips
			IL_0028: callvirt instance !0 class [System]System.Collections.Generic.Queue`1<!T>::Dequeue()
			IL_002d: callvirt instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::SetResult(!0)
			IL_0032: callvirt instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::get_Future()
			IL_0037: stloc.1
			IL_0038: leave.s IL_006b

			IL_003a: ldarg.0
			IL_003b: ldfld bool class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_closed
			IL_0040: brfalse.s IL_004a

			IL_0042: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::Cancelled()
			IL_0047: stloc.1
			IL_0048: leave.s IL_006b

			IL_004a: ldarg.0
			IL_004b: ldc.i4.1
			IL_004c: newobj instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::.ctor(valuetype [MMP.AsyncProxy]MMP.AsyncProxy.PromiseOptions)
			IL_0051: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_waiting
			IL_0056: ldarg.0
			IL_0057: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_waiting
			IL_005c: callvirt instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::get_Future()
			IL_0061: stloc.1
			IL_0062: leave.s IL_006b
		} // end .try
		finally
		{
			IL_0064: ldloc.0
			IL_0065: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_006a: endfinally
		} // end handler

		IL_006b: ldloc.1
		IL_006c: ret
	} // end of method PromiseInTray`1::TakeAsync

	.method assembly hidebysig 
		instance void Handled () cil managed 
	{
		// Method begins at RVA 0x3864
		// Header size: 1
		// Code size: 13 (0xd)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldflda int32 class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::_pending
		IL_0006: call int32 [mscorlib]System.Threading.Interlocked::Decrement(int32&)
		IL_000b: pop
		IL_000c: ret
	} // end of method PromiseInTray`1::Handled

	.method private hidebysig static 
		class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!T> Cancelled () cil managed 
	{
		// Method begins at RVA 0x3872
		// Header size: 1
		// Code size: 18 (0x12)
		.maxstack 8

		IL_0000: ldc.i4.1
		IL_0001: newobj instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::.ctor(valuetype [MMP.AsyncProxy]MMP.AsyncProxy.PromiseOptions)
		IL_0006: dup
		IL_0007: callvirt instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::SetCanceled()
		IL_000c: callvirt instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::get_Future()
		IL_0011: ret
	} // end of method PromiseInTray`1::Cancelled

	// Properties
	.property instance string Name()
	{
		.get instance string MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1::get_Name()
	}
	.property instance int32 Capacity()
	{
		.get instance int32 MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1::get_Capacity()
	}
	.property instance int32 Pending()
	{
		.get instance int32 MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1::get_Pending()
	}

} // end of class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.FanOut.WhenAllCourier
	extends [mscorlib]System.Object
	implements MMP.AsyncProxy.Training.FanOut.ICourier,
	           [mscorlib]System.IDisposable
{
	// Nested Types
	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass2_0'
		extends [mscorlib]System.Object
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field public string[] addresses
		.field public class MMP.AsyncProxy.Training.FanOut.PostOffice office

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor () cil managed 
		{
			// Method begins at RVA 0x5238
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass2_0'::.ctor

		.method assembly hidebysig 
			instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> '<SendAll>b__0' (
				class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.FanOut.Reply[]> 'ret'
			) cil managed 
		{
			// Method begins at RVA 0x5240
			// Header size: 1
			// Code size: 19 (0x13)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld string[] MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<>c__DisplayClass2_0'::addresses
			IL_0006: ldarg.0
			IL_0007: ldfld class MMP.AsyncProxy.Training.FanOut.PostOffice MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<>c__DisplayClass2_0'::office
			IL_000c: ldarg.1
			IL_000d: call class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.FanOut.WhenAllCourier::Gather(string[], class MMP.AsyncProxy.Training.FanOut.PostOffice, class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.FanOut.Reply[]>)
			IL_0012: ret
		} // end of method '<>c__DisplayClass2_0'::'<SendAll>b__0'

	} // end of class <>c__DisplayClass2_0

	.class nested private auto ansi sealed beforefieldinit '<Gather>d__3'
		extends [mscorlib]System.Object
		implements class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>,
		           [mscorlib]System.Collections.IEnumerable,
		           class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>,
		           [mscorlib]System.IDisposable,
		           [mscorlib]System.Collections.IEnumerator
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field private int32 '<>1__state'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture '<>2__current'
		.field private int32 '<>l__initialThreadId'
		.field private string[] addresses
		.field public string[] '<>3__addresses'
		.field private class MMP.AsyncProxy.Training.FanOut.PostOffice office
		.field public class MMP.AsyncProxy.Training.FanOut.PostOffice '<>3__office'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.FanOut.Reply[]> 'ret'
		.field public class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.FanOut.Reply[]> '<>3__ret'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<string>[] '<letters>5__2'

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor (
				int32 '<>1__state'
			) cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			// Method begins at RVA 0x5254
			// Header size: 1
			// Code size: 30 (0x1e)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ldarg.0
			IL_0007: ldarg.1
			IL_0008: stfld int32 MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'<>1__state'
			IL_000d: ldarg.0
			IL_000e: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0013: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_0018: stfld int32 MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'<>l__initialThreadId'
			IL_001d: ret
		} // end of method '<Gather>d__3'::.ctor

		.method private final hidebysig newslot virtual 
			instance void System.IDisposable.Dispose () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [mscorlib]System.IDisposable::Dispose()
			// Method begins at RVA 0x5273
			// Header size: 1
			// Code size: 16 (0x10)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldnull
			IL_0002: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<string>[] MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'<letters>5__2'
			IL_0007: ldarg.0
			IL_0008: ldc.i4.s -2
			IL_000a: stfld int32 MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'<>1__state'
			IL_000f: ret
		} // end of method '<Gather>d__3'::System.IDisposable.Dispose

		.method private final hidebysig newslot virtual 
			instance bool MoveNext () cil managed 
		{
			.override method instance bool [mscorlib]System.Collections.IEnumerator::MoveNext()
			// Method begins at RVA 0x5284
			// Header size: 12
			// Code size: 249 (0xf9)
			.maxstack 5
			.locals init (
				[0] int32,
				[1] class MMP.AsyncProxy.Training.FanOut.Reply[],
				[2] int32,
				[3] class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture[],
				[4] int32,
				[5] class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<string>
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'<>1__state'
			IL_0006: stloc.0
			IL_0007: ldloc.0
			IL_0008: brfalse.s IL_0010

			IL_000a: ldloc.0
			IL_000b: ldc.i4.1
			IL_000c: beq.s IL_0079

			IL_000e: ldc.i4.0
			IL_000f: ret

			IL_0010: ldarg.0
			IL_0011: ldc.i4.m1
			IL_0012: stfld int32 MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'<>1__state'
			IL_0017: ldarg.0
			IL_0018: ldarg.0
			IL_0019: ldfld string[] MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::addresses
			IL_001e: ldlen
			IL_001f: conv.i4
			IL_0020: newarr class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<string>
			IL_0025: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<string>[] MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'<letters>5__2'
			IL_002a: ldc.i4.0
			IL_002b: stloc.2
			IL_002c: br.s IL_004d
			// loop start (head: IL_004d)
				IL_002e: ldarg.0
				IL_002f: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<string>[] MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'<letters>5__2'
				IL_0034: ldloc.2
				IL_0035: ldarg.0
				IL_0036: ldfld class MMP.AsyncProxy.Training.FanOut.PostOffice MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::office
				IL_003b: ldarg.0
				IL_003c: ldfld string[] MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::addresses
				IL_0041: ldloc.2
				IL_0042: ldelem.ref
				IL_0043: callvirt instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<string> MMP.AsyncProxy.Training.FanOut.PostOffice::AskAsync(string)
				IL_0048: stelem.ref
				IL_0049: ldloc.2
				IL_004a: ldc.i4.1
				IL_004b: add
				IL_004c: stloc.2

				IL_004d: ldloc.2
				IL_004e: ldarg.0
				IL_004f: ldfld string[] MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::addresses
				IL_0054: ldlen
				IL_0055: conv.i4
				IL_0056: blt.s IL_002e
			// end loop

			IL_0058: ldarg.0
			IL_0059: ldarg.0
			IL_005a: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<string>[] MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'<letters>5__2'
			IL_005f: stloc.3
			IL_0060: ldloc.3
			IL_0061: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture [MMP.AsyncProxy]MMP.AsyncProxy.Futures::WhenAll(class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture[])
			IL_0066: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture [MMP.AsyncProxy]MMP.AsyncProxy.Futures::Observe(class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture)
			IL_006b: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'<>2__current'
			IL_0070: ldarg.0
			IL_0071: ldc.i4.1
			IL_0072: stfld int32 MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'<>1__state'
			IL_0077: ldc.i4.1
			IL_0078: ret

			IL_0079: ldarg.0
			IL_007a: ldc.i4.m1
			IL_007b: stfld int32 MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'<>1__state'
			IL_0080: ldarg.0
			IL_0081: ldfld string[] MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::addresses
			IL_0086: ldlen
			IL_0087: conv.i4
			IL_0088: newarr MMP.AsyncProxy.Training.FanOut.Reply
			IL_008d: stloc.1
			IL_008e: ldc.i4.0
			IL_008f: stloc.s 4
			IL_0091: br.s IL_00df
			// loop start (head: IL_00df)
				IL_0093: ldarg.0
				IL_0094: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<string>[] MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'<letters>5__2'
				IL_0099: ldloc.s 4
				IL_009b: ldelem.ref
				IL_009c: stloc.s 5
				IL_009e: ldloc.1
				IL_009f: ldloc.s 4
				IL_00a1: ldloc.s 5
				IL_00a3: callvirt instance bool [MMP.AsyncProxy]MMP.AsyncProxy.IFuture::get_IsFaulted()
				IL_00a8: brtrue.s IL_00c2

				IL_00aa: ldarg.0
				IL_00ab: ldfld string[] MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::addresses
				IL_00b0: ldloc.s 4
				IL_00b2: ldelem.ref
				IL_00b3: ldloc.s 5
				IL_00b5: callvirt instance !0 class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<string>::get_Result()
				IL_00ba: ldnull
				IL_00bb: newobj instance void MMP.AsyncProxy.Training.FanOut.Reply::.ctor(string, string, class [mscorlib]System.Exception)
				IL_00c0: br.s IL_00d8

				IL_00c2: ldarg.0
				IL_00c3: ldfld string[] MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::addresses
				IL_00c8: ldloc.s 4
				IL_00ca: ldelem.ref
				IL_00cb: ldnull
				IL_00cc: ldloc.s 5
				IL_00ce: callvirt instance class [mscorlib]System.Exception [MMP.AsyncProxy]MMP.AsyncProxy.IFuture::get_Exception()
				IL_00d3: newobj instance void MMP.AsyncProxy.Training.FanOut.Reply::.ctor(string, string, class [mscorlib]System.Exception)

				IL_00d8: stelem.ref
				IL_00d9: ldloc.s 4
				IL_00db: ldc.i4.1
				IL_00dc: add
				IL_00dd: stloc.s 4

				IL_00df: ldloc.s 4
				IL_00e1: ldarg.0
				IL_00e2: ldfld string[] MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::addresses
				IL_00e7: ldlen
				IL_00e8: conv.i4
				IL_00e9: blt.s IL_0093
			// end loop

			IL_00eb: ldarg.0
			IL_00ec: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.FanOut.Reply[]> MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'ret'
			IL_00f1: ldloc.1
			IL_00f2: callvirt instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.FanOut.Reply[]>::set_Value(!0)
			IL_00f7: ldc.i4.0
			IL_00f8: ret
		} // end of method '<Gather>d__3'::MoveNext

		.method private final hidebysig specialname newslot virtual 
			instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance !0 class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::get_Current()
			// Method begins at RVA 0x5389
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'<>2__current'
			IL_0006: ret
		} // end of method '<Gather>d__3'::'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current'

		.method private final hidebysig newslot virtual 
			instance void System.Collections.IEnumerator.Reset () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [mscorlib]System.Collections.IEnumerator::Reset()
			// Method begins at RVA 0x5391
			// Header size: 1
			// Code size: 6 (0x6)
			.maxstack 8

			IL_0000: newobj instance void [mscorlib]System.NotSupportedException::.ctor()
			IL_0005: throw
		} // end of method '<Gather>d__3'::System.Collections.IEnumerator.Reset

		.method private final hidebysig specialname newslot virtual 
			instance object System.Collections.IEnumerator.get_Current () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance object [mscorlib]System.Collections.IEnumerator::get_Current()
			// Method begins at RVA 0x5398
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'<>2__current'
			IL_0006: ret
		} // end of method '<Gather>d__3'::System.Collections.IEnumerator.get_Current

		.method private final hidebysig newslot virtual 
			instance class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> 'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance class [mscorlib]System.Collections.Generic.IEnumerator`1<!0> class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::GetEnumerator()
			// Method begins at RVA 0x53a0
			// Header size: 12
			// Code size: 84 (0x54)
			.maxstack 2
			.locals init (
				[0] class MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'<>1__state'
			IL_0006: ldc.i4.s -2
			IL_0008: bne.un.s IL_0027

			IL_000a: ldarg.0
			IL_000b: ldfld int32 MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'<>l__initialThreadId'
			IL_0010: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0015: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_001a: bne.un.s IL_0027

			IL_001c: ldarg.0
			IL_001d: ldc.i4.0
			IL_001e: stfld int32 MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'<>1__state'
			IL_0023: ldarg.0
			IL_0024: stloc.0
			IL_0025: br.s IL_002e

			IL_0027: ldc.i4.0
			IL_0028: newobj instance void MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::.ctor(int32)
			IL_002d: stloc.0

			IL_002e: ldloc.0
			IL_002f: ldarg.0
			IL_0030: ldfld string[] MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'<>3__addresses'
			IL_0035: stfld string[] MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::addresses
			IL_003a: ldloc.0
			IL_003b: ldarg.0
			IL_003c: ldfld class MMP.AsyncProxy.Training.FanOut.PostOffice MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'<>3__office'
			IL_0041: stfld class MMP.AsyncProxy.Training.FanOut.PostOffice MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::office
			IL_0046: ldloc.0
			IL_0047: ldarg.0
			IL_0048: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.FanOut.Reply[]> MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'<>3__ret'
			IL_004d: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.FanOut.Reply[]> MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'ret'
			IL_0052: ldloc.0
			IL_0053: ret
		} // end of method '<Gather>d__3'::'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator'

		.method private final hidebysig newslot virtual 
			instance class [mscorlib]System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance class [mscorlib]System.Collections.IEnumerator [mscorlib]System.Collections.IEnumerable::GetEnumerator()
			// Method begins at RVA 0x5400
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator'()
			IL_0006: ret
		} // end of method '<Gather>d__3'::System.Collections.IEnumerable.GetEnumerator

		// Properties
		.property instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.Current'()
		{
			.get instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current'()
		}
		.property instance object System.Collections.IEnumerator.Current()
		{
			.get instance object MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::System.Collections.IEnumerator.get_Current()
		}

	} // end of class <Gather>d__3


	// Methods
	.method public final hidebysig specialname newslot virtual 
		instance string get_Version () cil managed 
	{
		// Method begins at RVA 0x3885
		// Header size: 1
		// Code size: 6 (0x6)
		.maxstack 8

		IL_0000: ldstr "asyncproxy"
		IL_0005: ret
	} // end of method WhenAllCourier::get_Version

	.method public final hidebysig newslot virtual 
		instance class MMP.AsyncProxy.Training.FanOut.Reply[] SendAll (
			string[] addresses,
			class MMP.AsyncProxy.Training.FanOut.PostOffice office
		) cil managed 
	{
		// Method begins at RVA 0x388c
		// Header size: 1
		// Code size: 41 (0x29)
		.maxstack 8

		IL_0000: newobj instance void MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<>c__DisplayClass2_0'::.ctor()
		IL_0005: dup
		IL_0006: ldarg.1
		IL_0007: stfld string[] MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<>c__DisplayClass2_0'::addresses
		IL_000c: dup
		IL_000d: ldarg.2
		IL_000e: stfld class MMP.AsyncProxy.Training.FanOut.PostOffice MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<>c__DisplayClass2_0'::office
		IL_0013: ldftn instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<>c__DisplayClass2_0'::'<SendAll>b__0'(class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.FanOut.Reply[]>)
		IL_0019: newobj instance void class [System.Core]System.Func`2<class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.FanOut.Reply[]>, class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>>::.ctor(object, native int)
		IL_001e: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!!0> [MMP.AsyncProxy]MMP.AsyncProxy.AsyncProxy::Run<class MMP.AsyncProxy.Training.FanOut.Reply[]>(class [System.Core]System.Func`2<class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<!!0>, class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>>)
		IL_0023: callvirt instance !0 class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class MMP.AsyncProxy.Training.FanOut.Reply[]>::get_Result()
		IL_0028: ret
	} // end of method WhenAllCourier::SendAll

	.method private hidebysig static 
		class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> Gather (
			string[] addresses,
			class MMP.AsyncProxy.Training.FanOut.PostOffice office,
			class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.FanOut.Reply[]> 'ret'
		) cil managed 
	{
		// Method begins at RVA 0x38b6
		// Header size: 1
		// Code size: 29 (0x1d)
		.maxstack 8

		IL_0000: ldc.i4.s -2
		IL_0002: newobj instance void MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::.ctor(int32)
		IL_0007: dup
		IL_0008: ldarg.0
		IL_0009: stfld string[] MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'<>3__addresses'
		IL_000e: dup
		IL_000f: ldarg.1
		IL_0010: stfld class MMP.AsyncProxy.Training.FanOut.PostOffice MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'<>3__office'
		IL_0015: dup
		IL_0016: ldarg.2
		IL_0017: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.FanOut.Reply[]> MMP.AsyncProxy.Training.FanOut.WhenAllCourier/'<Gather>d__3'::'<>3__ret'
		IL_001c: ret
	} // end of method WhenAllCourier::Gather

	.method public final hidebysig newslot virtual 
		instance void Dispose () cil managed 
	{
		// Method begins at RVA 0x38d4
		// Header size: 1
		// Code size: 1 (0x1)
		.maxstack 8

		IL_0000: ret
	} // end of method WhenAllCourier::Dispose

	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x38d6
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: call instance void [mscorlib]System.Object::.ctor()
		IL_0006: ret
	} // end of method WhenAllCourier::.ctor

	// Properties
	.property instance string Version()
	{
		.get instance string MMP.AsyncProxy.Training.FanOut.WhenAllCourier::get_Version()
	}

} // end of class MMP.AsyncProxy.Training.FanOut.WhenAllCourier

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.FanOut.Reply
	extends [mscorlib]System.Object
{
	// Fields
	.field private initonly string _address
	.field private initonly string _text
	.field private initonly class [mscorlib]System.Exception _error

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			string address,
			string text,
			class [mscorlib]System.Exception 'error'
		) cil managed 
	{
		// Method begins at RVA 0x38de
		// Header size: 1
		// Code size: 28 (0x1c)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: call instance void [mscorlib]System.Object::.ctor()
		IL_0006: ldarg.0
		IL_0007: ldarg.1
		IL_0008: stfld string MMP.AsyncProxy.Training.FanOut.Reply::_address
		IL_000d: ldarg.0
		IL_000e: ldarg.2
		IL_000f: stfld string MMP.AsyncProxy.Training.FanOut.Reply::_text
		IL_0014: ldarg.0
		IL_0015: ldarg.3
		IL_0016: stfld class [mscorlib]System.Exception MMP.AsyncProxy.Training.FanOut.Reply::_error
		IL_001b: ret
	} // end of method Reply::.ctor

	.method public hidebysig specialname 
		instance string get_Address () cil managed 
	{
		// Method begins at RVA 0x38fb
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld string MMP.AsyncProxy.Training.FanOut.Reply::_address
		IL_0006: ret
	} // end of method Reply::get_Address

	.method public hidebysig specialname 
		instance string get_Text () cil managed 
	{
		// Method begins at RVA 0x3903
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld string MMP.AsyncProxy.Training.FanOut.Reply::_text
		IL_0006: ret
	} // end of method Reply::get_Text

	.method public hidebysig specialname 
		instance class [mscorlib]System.Exception get_Error () cil managed 
	{
		// Method begins at RVA 0x390b
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld class [mscorlib]System.Exception MMP.AsyncProxy.Training.FanOut.Reply::_error
		IL_0006: ret
	} // end of method Reply::get_Error

	.method public hidebysig specialname 
		instance bool get_Ok () cil managed 
	{
		// Method begins at RVA 0x3913
		// Header size: 1
		// Code size: 10 (0xa)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld class [mscorlib]System.Exception MMP.AsyncProxy.Training.FanOut.Reply::_error
		IL_0006: ldnull
		IL_0007: ceq
		IL_0009: ret
	} // end of method Reply::get_Ok

	// Properties
	.property instance string Address()
	{
		.get instance string MMP.AsyncProxy.Training.FanOut.Reply::get_Address()
	}
	.property instance string Text()
	{
		.get instance string MMP.AsyncProxy.Training.FanOut.Reply::get_Text()
	}
	.property instance class [mscorlib]System.Exception Error()
	{
		.get instance class [mscorlib]System.Exception MMP.AsyncProxy.Training.FanOut.Reply::get_Error()
	}
	.property instance bool Ok()
	{
		.get instance bool MMP.AsyncProxy.Training.FanOut.Reply::get_Ok()
	}

} // end of class MMP.AsyncProxy.Training.FanOut.Reply

.class interface public auto ansi abstract beforefieldinit MMP.AsyncProxy.Training.FanOut.ICourier
	implements [mscorlib]System.IDisposable
{
	// Methods
	.method public hidebysig specialname newslot abstract virtual 
		instance string get_Version () cil managed 
	{
	} // end of method ICourier::get_Version

	.method public hidebysig newslot abstract virtual 
		instance class MMP.AsyncProxy.Training.FanOut.Reply[] SendAll (
			string[] addresses,
			class MMP.AsyncProxy.Training.FanOut.PostOffice office
		) cil managed 
	{
	} // end of method ICourier::SendAll

	// Properties
	.property instance string Version()
	{
		.get instance string MMP.AsyncProxy.Training.FanOut.ICourier::get_Version()
	}

} // end of class MMP.AsyncProxy.Training.FanOut.ICourier

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.FanOut.PostOffice
	extends [mscorlib]System.Object
{
	// Nested Types
	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass9_0'
		extends [mscorlib]System.Object
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field public class MMP.AsyncProxy.Training.FanOut.PostOffice '<>4__this'
		.field public string address

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor () cil managed 
		{
			// Method begins at RVA 0x5408
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass9_0'::.ctor

		.method assembly hidebysig 
			instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> '<AskAsync>b__0' (
				class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<string> 'ret'
			) cil managed 
		{
			// Method begins at RVA 0x5410
			// Header size: 1
			// Code size: 19 (0x13)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class MMP.AsyncProxy.Training.FanOut.PostOffice MMP.AsyncProxy.Training.FanOut.PostOffice/'<>c__DisplayClass9_0'::'<>4__this'
			IL_0006: ldarg.0
			IL_0007: ldfld string MMP.AsyncProxy.Training.FanOut.PostOffice/'<>c__DisplayClass9_0'::address
			IL_000c: ldarg.1
			IL_000d: call instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.FanOut.PostOffice::AskBody(string, class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<string>)
			IL_0012: ret
		} // end of method '<>c__DisplayClass9_0'::'<AskAsync>b__0'

	} // end of class <>c__DisplayClass9_0

	.class nested private auto ansi sealed beforefieldinit '<AskBody>d__10'
		extends [mscorlib]System.Object
		implements class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>,
		           [mscorlib]System.Collections.IEnumerable,
		           class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>,
		           [mscorlib]System.IDisposable,
		           [mscorlib]System.Collections.IEnumerator
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field private int32 '<>1__state'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture '<>2__current'
		.field private int32 '<>l__initialThreadId'
		.field public class MMP.AsyncProxy.Training.FanOut.PostOffice '<>4__this'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<string> 'ret'
		.field public class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<string> '<>3__ret'
		.field private string address
		.field public string '<>3__address'

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor (
				int32 '<>1__state'
			) cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			// Method begins at RVA 0x5424
			// Header size: 1
			// Code size: 30 (0x1e)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ldarg.0
			IL_0007: ldarg.1
			IL_0008: stfld int32 MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::'<>1__state'
			IL_000d: ldarg.0
			IL_000e: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0013: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_0018: stfld int32 MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::'<>l__initialThreadId'
			IL_001d: ret
		} // end of method '<AskBody>d__10'::.ctor

		.method private final hidebysig newslot virtual 
			instance void System.IDisposable.Dispose () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [mscorlib]System.IDisposable::Dispose()
			// Method begins at RVA 0x5443
			// Header size: 1
			// Code size: 9 (0x9)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldc.i4.s -2
			IL_0003: stfld int32 MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::'<>1__state'
			IL_0008: ret
		} // end of method '<AskBody>d__10'::System.IDisposable.Dispose

		.method private final hidebysig newslot virtual 
			instance bool MoveNext () cil managed 
		{
			.override method instance bool [mscorlib]System.Collections.IEnumerator::MoveNext()
			// Method begins at RVA 0x5450
			// Header size: 12
			// Code size: 88 (0x58)
			.maxstack 3
			.locals init (
				[0] int32,
				[1] class MMP.AsyncProxy.Training.FanOut.PostOffice
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::'<>1__state'
			IL_0006: stloc.0
			IL_0007: ldarg.0
			IL_0008: ldfld class MMP.AsyncProxy.Training.FanOut.PostOffice MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::'<>4__this'
			IL_000d: stloc.1
			IL_000e: ldloc.0
			IL_000f: brfalse.s IL_0017

			IL_0011: ldloc.0
			IL_0012: ldc.i4.1
			IL_0013: beq.s IL_0038

			IL_0015: ldc.i4.0
			IL_0016: ret

			IL_0017: ldarg.0
			IL_0018: ldc.i4.m1
			IL_0019: stfld int32 MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::'<>1__state'
			IL_001e: ldarg.0
			IL_001f: ldloc.1
			IL_0020: ldfld int32 MMP.AsyncProxy.Training.FanOut.PostOffice::_delayMs
			IL_0025: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture [MMP.AsyncProxy]MMP.AsyncProxy.Futures::Delay(int32)
			IL_002a: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::'<>2__current'
			IL_002f: ldarg.0
			IL_0030: ldc.i4.1
			IL_0031: stfld int32 MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::'<>1__state'
			IL_0036: ldc.i4.1
			IL_0037: ret

			IL_0038: ldarg.0
			IL_0039: ldc.i4.m1
			IL_003a: stfld int32 MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::'<>1__state'
			IL_003f: ldarg.0
			IL_0040: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<string> MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::'ret'
			IL_0045: ldloc.1
			IL_0046: ldarg.0
			IL_0047: ldfld string MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::address
			IL_004c: call instance string MMP.AsyncProxy.Training.FanOut.PostOffice::Answer(string)
			IL_0051: callvirt instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<string>::set_Value(!0)
			IL_0056: ldc.i4.0
			IL_0057: ret
		} // end of method '<AskBody>d__10'::MoveNext

		.method private final hidebysig specialname newslot virtual 
			instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance !0 class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::get_Current()
			// Method begins at RVA 0x54b4
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::'<>2__current'
			IL_0006: ret
		} // end of method '<AskBody>d__10'::'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current'

		.method private final hidebysig newslot virtual 
			instance void System.Collections.IEnumerator.Reset () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [mscorlib]System.Collections.IEnumerator::Reset()
			// Method begins at RVA 0x54bc
			// Header size: 1
			// Code size: 6 (0x6)
			.maxstack 8

			IL_0000: newobj instance void [mscorlib]System.NotSupportedException::.ctor()
			IL_0005: throw
		} // end of method '<AskBody>d__10'::System.Collections.IEnumerator.Reset

		.method private final hidebysig specialname newslot virtual 
			instance object System.Collections.IEnumerator.get_Current () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance object [mscorlib]System.Collections.IEnumerator::get_Current()
			// Method begins at RVA 0x54c3
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::'<>2__current'
			IL_0006: ret
		} // end of method '<AskBody>d__10'::System.Collections.IEnumerator.get_Current

		.method private final hidebysig newslot virtual 
			instance class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> 'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance class [mscorlib]System.Collections.Generic.IEnumerator`1<!0> class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::GetEnumerator()
			// Method begins at RVA 0x54cc
			// Header size: 12
			// Code size: 84 (0x54)
			.maxstack 2
			.locals init (
				[0] class MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::'<>1__state'
			IL_0006: ldc.i4.s -2
			IL_0008: bne.un.s IL_0027

			IL_000a: ldarg.0
			IL_000b: ldfld int32 MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::'<>l__initialThreadId'
			IL_0010: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0015: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_001a: bne.un.s IL_0027

			IL_001c: ldarg.0
			IL_001d: ldc.i4.0
			IL_001e: stfld int32 MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::'<>1__state'
			IL_0023: ldarg.0
			IL_0024: stloc.0
			IL_0025: br.s IL_003a

			IL_0027: ldc.i4.0
			IL_0028: newobj instance void MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::.ctor(int32)
			IL_002d: stloc.0
			IL_002e: ldloc.0
			IL_002f: ldarg.0
			IL_0030: ldfld class MMP.AsyncProxy.Training.FanOut.PostOffice MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::'<>4__this'
			IL_0035: stfld class MMP.AsyncProxy.Training.FanOut.PostOffice MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::'<>4__this'

			IL_003a: ldloc.0
			IL_003b: ldarg.0
			IL_003c: ldfld string MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::'<>3__address'
			IL_0041: stfld string MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::address
			IL_0046: ldloc.0
			IL_0047: ldarg.0
			IL_0048: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<string> MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::'<>3__ret'
			IL_004d: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<string> MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::'ret'
			IL_0052: ldloc.0
			IL_0053: ret
		} // end of method '<AskBody>d__10'::'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator'

		.method private final hidebysig newslot virtual 
			instance class [mscorlib]System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance class [mscorlib]System.Collections.IEnumerator [mscorlib]System.Collections.IEnumerable::GetEnumerator()
			// Method begins at RVA 0x552c
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator'()
			IL_0006: ret
		} // end of method '<AskBody>d__10'::System.Collections.IEnumerable.GetEnumerator

		// Properties
		.property instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.Current'()
		{
			.get instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current'()
		}
		.property instance object System.Collections.IEnumerator.Current()
		{
			.get instance object MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::System.Collections.IEnumerator.get_Current()
		}

	} // end of class <AskBody>d__10


	// Fields
	.field private initonly int32 _delayMs
	.field private initonly class [mscorlib]System.Collections.Generic.Dictionary`2<string, bool> _bounces

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			int32 delayMs
		) cil managed 
	{
		// Method begins at RVA 0x391e
		// Header size: 1
		// Code size: 25 (0x19)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: newobj instance void class [mscorlib]System.Collections.Generic.Dictionary`2<string, bool>::.ctor()
		IL_0006: stfld class [mscorlib]System.Collections.Generic.Dictionary`2<string, bool> MMP.AsyncProxy.Training.FanOut.PostOffice::_bounces
		IL_000b: ldarg.0
		IL_000c: call instance void [mscorlib]System.Object::.ctor()
		IL_0011: ldarg.0
		IL_0012: ldarg.1
		IL_0013: stfld int32 MMP.AsyncProxy.Training.FanOut.PostOffice::_delayMs
		IL_0018: ret
	} // end of method PostOffice::.ctor

	.method public hidebysig specialname 
		instance int32 get_DelayMs () cil managed 
	{
		// Method begins at RVA 0x3938
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld int32 MMP.AsyncProxy.Training.FanOut.PostOffice::_delayMs
		IL_0006: ret
	} // end of method PostOffice::get_DelayMs

	.method public hidebysig 
		instance class MMP.AsyncProxy.Training.FanOut.PostOffice Bounce (
			string address
		) cil managed 
	{
		// Method begins at RVA 0x3940
		// Header size: 1
		// Code size: 15 (0xf)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld class [mscorlib]System.Collections.Generic.Dictionary`2<string, bool> MMP.AsyncProxy.Training.FanOut.PostOffice::_bounces
		IL_0006: ldarg.1
		IL_0007: ldc.i4.1
		IL_0008: callvirt instance void class [mscorlib]System.Collections.Generic.Dictionary`2<string, bool>::set_Item(!0, !1)
		IL_000d: ldarg.0
		IL_000e: ret
	} // end of method PostOffice::Bounce

	.method public hidebysig 
		instance bool Bounces (
			string address
		) cil managed 
	{
		// Method begins at RVA 0x3950
		// Header size: 1
		// Code size: 13 (0xd)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld class [mscorlib]System.Collections.Generic.Dictionary`2<string, bool> MMP.AsyncProxy.Training.FanOut.PostOffice::_bounces
		IL_0006: ldarg.1
		IL_0007: callvirt instance bool class [mscorlib]System.Collections.Generic.Dictionary`2<string, bool>::ContainsKey(!0)
		IL_000c: ret
	} // end of method PostOffice::Bounces

	.method public hidebysig 
		instance string Answer (
			string address
		) cil managed 
	{
		// Method begins at RVA 0x395e
		// Header size: 1
		// Code size: 38 (0x26)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldarg.1
		IL_0002: call instance bool MMP.AsyncProxy.Training.FanOut.PostOffice::Bounces(string)
		IL_0007: brfalse.s IL_001a

		IL_0009: ldstr "no such address: "
		IL_000e: ldarg.1
		IL_000f: call string [mscorlib]System.String::Concat(string, string)
		IL_0014: newobj instance void [mscorlib]System.InvalidOperationException::.ctor(string)
		IL_0019: throw

		IL_001a: ldstr "re: "
		IL_001f: ldarg.1
		IL_0020: call string [mscorlib]System.String::Concat(string, string)
		IL_0025: ret
	} // end of method PostOffice::Answer

	.method public hidebysig 
		instance string Ask (
			string address
		) cil managed 
	{
		// Method begins at RVA 0x3985
		// Header size: 1
		// Code size: 19 (0x13)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld int32 MMP.AsyncProxy.Training.FanOut.PostOffice::_delayMs
		IL_0006: call void [mscorlib]System.Threading.Thread::Sleep(int32)
		IL_000b: ldarg.0
		IL_000c: ldarg.1
		IL_000d: call instance string MMP.AsyncProxy.Training.FanOut.PostOffice::Answer(string)
		IL_0012: ret
	} // end of method PostOffice::Ask

	.method public hidebysig 
		instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<string> AskAsync (
			string address
		) cil managed 
	{
		// Method begins at RVA 0x3999
		// Header size: 1
		// Code size: 36 (0x24)
		.maxstack 8

		IL_0000: newobj instance void MMP.AsyncProxy.Training.FanOut.PostOffice/'<>c__DisplayClass9_0'::.ctor()
		IL_0005: dup
		IL_0006: ldarg.0
		IL_0007: stfld class MMP.AsyncProxy.Training.FanOut.PostOffice MMP.AsyncProxy.Training.FanOut.PostOffice/'<>c__DisplayClass9_0'::'<>4__this'
		IL_000c: dup
		IL_000d: ldarg.1
		IL_000e: stfld string MMP.AsyncProxy.Training.FanOut.PostOffice/'<>c__DisplayClass9_0'::address
		IL_0013: ldftn instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.FanOut.PostOffice/'<>c__DisplayClass9_0'::'<AskAsync>b__0'(class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<string>)
		IL_0019: newobj instance void class [System.Core]System.Func`2<class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<string>, class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>>::.ctor(object, native int)
		IL_001e: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!!0> [MMP.AsyncProxy]MMP.AsyncProxy.AsyncProxy::Run<string>(class [System.Core]System.Func`2<class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<!!0>, class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>>)
		IL_0023: ret
	} // end of method PostOffice::AskAsync

	.method private hidebysig 
		instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> AskBody (
			string address,
			class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<string> 'ret'
		) cil managed 
	{
		// Method begins at RVA 0x39be
		// Header size: 1
		// Code size: 29 (0x1d)
		.maxstack 8

		IL_0000: ldc.i4.s -2
		IL_0002: newobj instance void MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::.ctor(int32)
		IL_0007: dup
		IL_0008: ldarg.0
		IL_0009: stfld class MMP.AsyncProxy.Training.FanOut.PostOffice MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::'<>4__this'
		IL_000e: dup
		IL_000f: ldarg.1
		IL_0010: stfld string MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::'<>3__address'
		IL_0015: dup
		IL_0016: ldarg.2
		IL_0017: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<string> MMP.AsyncProxy.Training.FanOut.PostOffice/'<AskBody>d__10'::'<>3__ret'
		IL_001c: ret
	} // end of method PostOffice::AskBody

	// Properties
	.property instance int32 DelayMs()
	{
		.get instance int32 MMP.AsyncProxy.Training.FanOut.PostOffice::get_DelayMs()
	}

} // end of class MMP.AsyncProxy.Training.FanOut.PostOffice

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier
	extends [mscorlib]System.Object
	implements MMP.AsyncProxy.Training.FanOut.ICourier,
	           [mscorlib]System.IDisposable
{
	// Nested Types
	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass2_0'
		extends [mscorlib]System.Object
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field public class MMP.AsyncProxy.Training.FanOut.Reply[] replies
		.field public class MMP.AsyncProxy.Training.FanOut.PostOffice office
		.field public int32 remaining
		.field public class [mscorlib]System.Threading.ManualResetEvent allIn

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor () cil managed 
		{
			// Method begins at RVA 0x5534
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass2_0'::.ctor

	} // end of class <>c__DisplayClass2_0

	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass2_1'
		extends [mscorlib]System.Object
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field public int32 slot
		.field public string address
		.field public class MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_0' 'CS$<>8__locals1'

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor () cil managed 
		{
			// Method begins at RVA 0x553c
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass2_1'::.ctor

		.method assembly hidebysig 
			instance void '<SendAll>b__0' () cil managed 
		{
			// Method begins at RVA 0x5544
			// Header size: 12
			// Code size: 125 (0x7d)
			.maxstack 5
			.locals init (
				[0] class [mscorlib]System.Exception
			)

			.try
			{
				.try
				{
					IL_0000: ldarg.0
					IL_0001: ldfld class MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_0' MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_1'::'CS$<>8__locals1'
					IL_0006: ldfld class MMP.AsyncProxy.Training.FanOut.Reply[] MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_0'::replies
					IL_000b: ldarg.0
					IL_000c: ldfld int32 MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_1'::slot
					IL_0011: ldarg.0
					IL_0012: ldfld string MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_1'::address
					IL_0017: ldarg.0
					IL_0018: ldfld class MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_0' MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_1'::'CS$<>8__locals1'
					IL_001d: ldfld class MMP.AsyncProxy.Training.FanOut.PostOffice MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_0'::office
					IL_0022: ldarg.0
					IL_0023: ldfld string MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_1'::address
					IL_0028: callvirt instance string MMP.AsyncProxy.Training.FanOut.PostOffice::Ask(string)
					IL_002d: ldnull
					IL_002e: newobj instance void MMP.AsyncProxy.Training.FanOut.Reply::.ctor(string, string, class [mscorlib]System.Exception)
					IL_0033: stelem.ref
					IL_0034: leave.s IL_007c
				} // end .try
				catch [mscorlib]System.Exception
				{
					IL_0036: stloc.0
					IL_0037: ldarg.0
					IL_0038: ldfld class MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_0' MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_1'::'CS$<>8__locals1'
					IL_003d: ldfld class MMP.AsyncProxy.Training.FanOut.Reply[] MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_0'::replies
					IL_0042: ldarg.0
					IL_0043: ldfld int32 MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_1'::slot
					IL_0048: ldarg.0
					IL_0049: ldfld string MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_1'::address
					IL_004e: ldnull
					IL_004f: ldloc.0
					IL_0050: newobj instance void MMP.AsyncProxy.Training.FanOut.Reply::.ctor(string, string, class [mscorlib]System.Exception)
					IL_0055: stelem.ref
					IL_0056: leave.s IL_007c
				} // end handler
			} // end .try
			finally
			{
				IL_0058: ldarg.0
				IL_0059: ldfld class MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_0' MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_1'::'CS$<>8__locals1'
				IL_005e: ldflda int32 MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_0'::remaining
				IL_0063: call int32 [mscorlib]System.Threading.Interlocked::Decrement(int32&)
				IL_0068: brtrue.s IL_007b

				IL_006a: ldarg.0
				IL_006b: ldfld class MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_0' MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_1'::'CS$<>8__locals1'
				IL_0070: ldfld class [mscorlib]System.Threading.ManualResetEvent MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_0'::allIn
				IL_0075: callvirt instance bool [mscorlib]System.Threading.EventWaitHandle::Set()
				IL_007a: pop

				IL_007b: endfinally
			} // end handler

			IL_007c: ret
		} // end of method '<>c__DisplayClass2_1'::'<SendAll>b__0'

	} // end of class <>c__DisplayClass2_1


	// Methods
	.method public final hidebysig specialname newslot virtual 
		instance string get_Version () cil managed 
	{
		// Method begins at RVA 0x39dc
		// Header size: 1
		// Code size: 6 (0x6)
		.maxstack 8

		IL_0000: ldstr "threaded"
		IL_0005: ret
	} // end of method ThreadPerLetterCourier::get_Version

	.method public final hidebysig newslot virtual 
		instance class MMP.AsyncProxy.Training.FanOut.Reply[] SendAll (
			string[] addresses,
			class MMP.AsyncProxy.Training.FanOut.PostOffice office
		) cil managed 
	{
		// Method begins at RVA 0x39e4
		// Header size: 12
		// Code size: 194 (0xc2)
		.maxstack 4
		.locals init (
			[0] class MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_0',
			[1] int32,
			[2] class MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_1'
		)

		IL_0000: newobj instance void MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_0'::.ctor()
		IL_0005: stloc.0
		IL_0006: ldloc.0
		IL_0007: ldarg.2
		IL_0008: stfld class MMP.AsyncProxy.Training.FanOut.PostOffice MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_0'::office
		IL_000d: ldloc.0
		IL_000e: ldarg.1
		IL_000f: ldlen
		IL_0010: conv.i4
		IL_0011: newarr MMP.AsyncProxy.Training.FanOut.Reply
		IL_0016: stfld class MMP.AsyncProxy.Training.FanOut.Reply[] MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_0'::replies
		IL_001b: ldarg.1
		IL_001c: ldlen
		IL_001d: brtrue.s IL_0026

		IL_001f: ldloc.0
		IL_0020: ldfld class MMP.AsyncProxy.Training.FanOut.Reply[] MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_0'::replies
		IL_0025: ret

		IL_0026: ldloc.0
		IL_0027: ldarg.1
		IL_0028: ldlen
		IL_0029: conv.i4
		IL_002a: stfld int32 MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_0'::remaining
		IL_002f: ldloc.0
		IL_0030: ldc.i4.0
		IL_0031: newobj instance void [mscorlib]System.Threading.ManualResetEvent::.ctor(bool)
		IL_0036: stfld class [mscorlib]System.Threading.ManualResetEvent MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_0'::allIn
		.try
		{
			IL_003b: ldc.i4.0
			IL_003c: stloc.1
			IL_003d: br.s IL_0093
			// loop start (head: IL_0093)
				IL_003f: newobj instance void MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_1'::.ctor()
				IL_0044: stloc.2
				IL_0045: ldloc.2
				IL_0046: ldloc.0
				IL_0047: stfld class MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_0' MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_1'::'CS$<>8__locals1'
				IL_004c: ldloc.2
				IL_004d: ldloc.1
				IL_004e: stfld int32 MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_1'::slot
				IL_0053: ldloc.2
				IL_0054: ldarg.1
				IL_0055: ldloc.1
				IL_0056: ldelem.ref
				IL_0057: stfld string MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_1'::address
				IL_005c: ldloc.2
				IL_005d: ldftn instance void MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_1'::'<SendAll>b__0'()
				IL_0063: newobj instance void [mscorlib]System.Threading.ThreadStart::.ctor(object, native int)
				IL_0068: newobj instance void [mscorlib]System.Threading.Thread::.ctor(class [mscorlib]System.Threading.ThreadStart)
				IL_006d: dup
				IL_006e: ldc.i4.1
				IL_006f: callvirt instance void [mscorlib]System.Threading.Thread::set_IsBackground(bool)
				IL_0074: dup
				IL_0075: ldstr "letter:"
				IL_007a: ldloc.2
				IL_007b: ldfld string MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_1'::address
				IL_0080: call string [mscorlib]System.String::Concat(string, string)
				IL_0085: callvirt instance void [mscorlib]System.Threading.Thread::set_Name(string)
				IL_008a: callvirt instance void [mscorlib]System.Threading.Thread::Start()
				IL_008f: ldloc.1
				IL_0090: ldc.i4.1
				IL_0091: add
				IL_0092: stloc.1

				IL_0093: ldloc.1
				IL_0094: ldarg.1
				IL_0095: ldlen
				IL_0096: conv.i4
				IL_0097: blt.s IL_003f
			// end loop

			IL_0099: ldloc.0
			IL_009a: ldfld class [mscorlib]System.Threading.ManualResetEvent MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_0'::allIn
			IL_009f: callvirt instance bool [mscorlib]System.Threading.WaitHandle::WaitOne()
			IL_00a4: pop
			IL_00a5: leave.s IL_00bb
		} // end .try
		finally
		{
			IL_00a7: ldloc.0
			IL_00a8: ldfld class [mscorlib]System.Threading.ManualResetEvent MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_0'::allIn
			IL_00ad: brfalse.s IL_00ba

			IL_00af: ldloc.0
			IL_00b0: ldfld class [mscorlib]System.Threading.ManualResetEvent MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_0'::allIn
			IL_00b5: callvirt instance void [mscorlib]System.IDisposable::Dispose()

			IL_00ba: endfinally
		} // end handler

		IL_00bb: ldloc.0
		IL_00bc: ldfld class MMP.AsyncProxy.Training.FanOut.Reply[] MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier/'<>c__DisplayClass2_0'::replies
		IL_00c1: ret
	} // end of method ThreadPerLetterCourier::SendAll

	.method public final hidebysig newslot virtual 
		instance void Dispose () cil managed 
	{
		// Method begins at RVA 0x3ac4
		// Header size: 1
		// Code size: 1 (0x1)
		.maxstack 8

		IL_0000: ret
	} // end of method ThreadPerLetterCourier::Dispose

	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x3ac6
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: call instance void [mscorlib]System.Object::.ctor()
		IL_0006: ret
	} // end of method ThreadPerLetterCourier::.ctor

	// Properties
	.property instance string Version()
	{
		.get instance string MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier::get_Version()
	}

} // end of class MMP.AsyncProxy.Training.FanOut.ThreadPerLetterCourier

.class public auto ansi sealed MMP.AsyncProxy.Training.Deadline.CallOutcome
	extends [mscorlib]System.Enum
{
	// Fields
	.field public specialname rtspecialname int32 value__
	.field public static literal valuetype MMP.AsyncProxy.Training.Deadline.CallOutcome Answered = int32(0)
	.field public static literal valuetype MMP.AsyncProxy.Training.Deadline.CallOutcome GaveUp = int32(1)
	.field public static literal valuetype MMP.AsyncProxy.Training.Deadline.CallOutcome Cancelled = int32(2)

} // end of class MMP.AsyncProxy.Training.Deadline.CallOutcome

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Deadline.CallResult
	extends [mscorlib]System.Object
{
	// Fields
	.field private initonly valuetype MMP.AsyncProxy.Training.Deadline.CallOutcome _outcome
	.field private initonly string _reply
	.field private initonly int32 _attempts

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			valuetype MMP.AsyncProxy.Training.Deadline.CallOutcome outcome,
			string reply,
			int32 attempts
		) cil managed 
	{
		// Method begins at RVA 0x3ace
		// Header size: 1
		// Code size: 28 (0x1c)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: call instance void [mscorlib]System.Object::.ctor()
		IL_0006: ldarg.0
		IL_0007: ldarg.1
		IL_0008: stfld valuetype MMP.AsyncProxy.Training.Deadline.CallOutcome MMP.AsyncProxy.Training.Deadline.CallResult::_outcome
		IL_000d: ldarg.0
		IL_000e: ldarg.2
		IL_000f: stfld string MMP.AsyncProxy.Training.Deadline.CallResult::_reply
		IL_0014: ldarg.0
		IL_0015: ldarg.3
		IL_0016: stfld int32 MMP.AsyncProxy.Training.Deadline.CallResult::_attempts
		IL_001b: ret
	} // end of method CallResult::.ctor

	.method public hidebysig specialname 
		instance valuetype MMP.AsyncProxy.Training.Deadline.CallOutcome get_Outcome () cil managed 
	{
		// Method begins at RVA 0x3aeb
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld valuetype MMP.AsyncProxy.Training.Deadline.CallOutcome MMP.AsyncProxy.Training.Deadline.CallResult::_outcome
		IL_0006: ret
	} // end of method CallResult::get_Outcome

	.method public hidebysig specialname 
		instance string get_Reply () cil managed 
	{
		// Method begins at RVA 0x3af3
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld string MMP.AsyncProxy.Training.Deadline.CallResult::_reply
		IL_0006: ret
	} // end of method CallResult::get_Reply

	.method public hidebysig specialname 
		instance int32 get_Attempts () cil managed 
	{
		// Method begins at RVA 0x3afb
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld int32 MMP.AsyncProxy.Training.Deadline.CallResult::_attempts
		IL_0006: ret
	} // end of method CallResult::get_Attempts

	// Properties
	.property instance valuetype MMP.AsyncProxy.Training.Deadline.CallOutcome Outcome()
	{
		.get instance valuetype MMP.AsyncProxy.Training.Deadline.CallOutcome MMP.AsyncProxy.Training.Deadline.CallResult::get_Outcome()
	}
	.property instance string Reply()
	{
		.get instance string MMP.AsyncProxy.Training.Deadline.CallResult::get_Reply()
	}
	.property instance int32 Attempts()
	{
		.get instance int32 MMP.AsyncProxy.Training.Deadline.CallResult::get_Attempts()
	}

} // end of class MMP.AsyncProxy.Training.Deadline.CallResult

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Deadline.GiveUp
	extends [mscorlib]System.Object
{
	// Fields
	.field private initonly object _gate
	.field private class [System.Core]System.Action _fired
	.field private bool _requested

	// Methods
	.method public hidebysig specialname 
		instance bool get_Requested () cil managed 
	{
		// Method begins at RVA 0x3b04
		// Header size: 12
		// Code size: 31 (0x1f)
		.maxstack 1
		.locals init (
			[0] object,
			[1] bool
		)

		IL_0000: ldarg.0
		IL_0001: ldfld object MMP.AsyncProxy.Training.Deadline.GiveUp::_gate
		IL_0006: stloc.0
		IL_0007: ldloc.0
		IL_0008: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_000d: ldarg.0
			IL_000e: ldfld bool MMP.AsyncProxy.Training.Deadline.GiveUp::_requested
			IL_0013: stloc.1
			IL_0014: leave.s IL_001d
		} // end .try
		finally
		{
			IL_0016: ldloc.0
			IL_0017: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_001c: endfinally
		} // end handler

		IL_001d: ldloc.1
		IL_001e: ret
	} // end of method GiveUp::get_Requested

	.method public hidebysig 
		instance void Fire () cil managed 
	{
		// Method begins at RVA 0x3b40
		// Header size: 12
		// Code size: 56 (0x38)
		.maxstack 2
		.locals init (
			[0] class [System.Core]System.Action,
			[1] object
		)

		IL_0000: ldarg.0
		IL_0001: ldfld object MMP.AsyncProxy.Training.Deadline.GiveUp::_gate
		IL_0006: stloc.1
		IL_0007: ldloc.1
		IL_0008: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_000d: ldarg.0
			IL_000e: ldfld bool MMP.AsyncProxy.Training.Deadline.GiveUp::_requested
			IL_0013: brfalse.s IL_0017

			IL_0015: leave.s IL_0037

			IL_0017: ldarg.0
			IL_0018: ldc.i4.1
			IL_0019: stfld bool MMP.AsyncProxy.Training.Deadline.GiveUp::_requested
			IL_001e: ldarg.0
			IL_001f: ldfld class [System.Core]System.Action MMP.AsyncProxy.Training.Deadline.GiveUp::_fired
			IL_0024: stloc.0
			IL_0025: leave.s IL_002e
		} // end .try
		finally
		{
			IL_0027: ldloc.1
			IL_0028: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_002d: endfinally
		} // end handler

		IL_002e: ldloc.0
		IL_002f: brfalse.s IL_0037

		IL_0031: ldloc.0
		IL_0032: callvirt instance void [System.Core]System.Action::Invoke()

		IL_0037: ret
	} // end of method GiveUp::Fire

	.method public hidebysig 
		instance void OnFired (
			class [System.Core]System.Action callback
		) cil managed 
	{
		// Method begins at RVA 0x3b94
		// Header size: 12
		// Code size: 62 (0x3e)
		.maxstack 3
		.locals init (
			[0] object
		)

		IL_0000: ldarg.0
		IL_0001: ldfld object MMP.AsyncProxy.Training.Deadline.GiveUp::_gate
		IL_0006: stloc.0
		IL_0007: ldloc.0
		IL_0008: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_000d: ldarg.0
			IL_000e: ldfld bool MMP.AsyncProxy.Training.Deadline.GiveUp::_requested
			IL_0013: brtrue.s IL_002e

			IL_0015: ldarg.0
			IL_0016: ldarg.0
			IL_0017: ldfld class [System.Core]System.Action MMP.AsyncProxy.Training.Deadline.GiveUp::_fired
			IL_001c: ldarg.1
			IL_001d: call class [mscorlib]System.Delegate [mscorlib]System.Delegate::Combine(class [mscorlib]System.Delegate, class [mscorlib]System.Delegate)
			IL_0022: castclass [System.Core]System.Action
			IL_0027: stfld class [System.Core]System.Action MMP.AsyncProxy.Training.Deadline.GiveUp::_fired
			IL_002c: leave.s IL_003d

			IL_002e: leave.s IL_0037
		} // end .try
		finally
		{
			IL_0030: ldloc.0
			IL_0031: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_0036: endfinally
		} // end handler

		IL_0037: ldarg.1
		IL_0038: callvirt instance void [System.Core]System.Action::Invoke()

		IL_003d: ret
	} // end of method GiveUp::OnFired

	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x3bf0
		// Header size: 1
		// Code size: 18 (0x12)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: newobj instance void [mscorlib]System.Object::.ctor()
		IL_0006: stfld object MMP.AsyncProxy.Training.Deadline.GiveUp::_gate
		IL_000b: ldarg.0
		IL_000c: call instance void [mscorlib]System.Object::.ctor()
		IL_0011: ret
	} // end of method GiveUp::.ctor

	// Properties
	.property instance bool Requested()
	{
		.get instance bool MMP.AsyncProxy.Training.Deadline.GiveUp::get_Requested()
	}

} // end of class MMP.AsyncProxy.Training.Deadline.GiveUp

.class interface public auto ansi abstract beforefieldinit MMP.AsyncProxy.Training.Deadline.IDeadlineCaller
	implements [mscorlib]System.IDisposable
{
	// Methods
	.method public hidebysig specialname newslot abstract virtual 
		instance string get_Version () cil managed 
	{
	} // end of method IDeadlineCaller::get_Version

	.method public hidebysig newslot abstract virtual 
		instance class MMP.AsyncProxy.Training.Deadline.CallResult Call (
			class MMP.AsyncProxy.Training.Deadline.FlakyService service,
			int32 timeoutMs,
			int32 maxAttempts,
			class MMP.AsyncProxy.Training.Deadline.GiveUp giveUp
		) cil managed 
	{
	} // end of method IDeadlineCaller::Call

	// Properties
	.property instance string Version()
	{
		.get instance string MMP.AsyncProxy.Training.Deadline.IDeadlineCaller::get_Version()
	}

} // end of class MMP.AsyncProxy.Training.Deadline.IDeadlineCaller

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Deadline.FlakyService
	extends [mscorlib]System.Object
{
	// Nested Types
	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass9_0'
		extends [mscorlib]System.Object
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field public class MMP.AsyncProxy.Training.Deadline.FlakyService '<>4__this'
		.field public int32 attempt
		.field public int32 delay

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor () cil managed 
		{
			// Method begins at RVA 0x55ec
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass9_0'::.ctor

		.method assembly hidebysig 
			instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> '<AskAsync>b__0' (
				class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<string> 'ret'
			) cil managed 
		{
			// Method begins at RVA 0x55f4
			// Header size: 1
			// Code size: 25 (0x19)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class MMP.AsyncProxy.Training.Deadline.FlakyService MMP.AsyncProxy.Training.Deadline.FlakyService/'<>c__DisplayClass9_0'::'<>4__this'
			IL_0006: ldarg.0
			IL_0007: ldfld int32 MMP.AsyncProxy.Training.Deadline.FlakyService/'<>c__DisplayClass9_0'::attempt
			IL_000c: ldarg.0
			IL_000d: ldfld int32 MMP.AsyncProxy.Training.Deadline.FlakyService/'<>c__DisplayClass9_0'::delay
			IL_0012: ldarg.1
			IL_0013: call instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Deadline.FlakyService::AskBody(int32, int32, class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<string>)
			IL_0018: ret
		} // end of method '<>c__DisplayClass9_0'::'<AskAsync>b__0'

	} // end of class <>c__DisplayClass9_0

	.class nested private auto ansi sealed beforefieldinit '<AskBody>d__10'
		extends [mscorlib]System.Object
		implements class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>,
		           [mscorlib]System.Collections.IEnumerable,
		           class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>,
		           [mscorlib]System.IDisposable,
		           [mscorlib]System.Collections.IEnumerator
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field private int32 '<>1__state'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture '<>2__current'
		.field private int32 '<>l__initialThreadId'
		.field private int32 delay
		.field public int32 '<>3__delay'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<string> 'ret'
		.field public class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<string> '<>3__ret'
		.field public class MMP.AsyncProxy.Training.Deadline.FlakyService '<>4__this'
		.field private int32 attempt
		.field public int32 '<>3__attempt'

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor (
				int32 '<>1__state'
			) cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			// Method begins at RVA 0x560e
			// Header size: 1
			// Code size: 30 (0x1e)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ldarg.0
			IL_0007: ldarg.1
			IL_0008: stfld int32 MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'<>1__state'
			IL_000d: ldarg.0
			IL_000e: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0013: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_0018: stfld int32 MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'<>l__initialThreadId'
			IL_001d: ret
		} // end of method '<AskBody>d__10'::.ctor

		.method private final hidebysig newslot virtual 
			instance void System.IDisposable.Dispose () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [mscorlib]System.IDisposable::Dispose()
			// Method begins at RVA 0x562d
			// Header size: 1
			// Code size: 9 (0x9)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldc.i4.s -2
			IL_0003: stfld int32 MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'<>1__state'
			IL_0008: ret
		} // end of method '<AskBody>d__10'::System.IDisposable.Dispose

		.method private final hidebysig newslot virtual 
			instance bool MoveNext () cil managed 
		{
			.override method instance bool [mscorlib]System.Collections.IEnumerator::MoveNext()
			// Method begins at RVA 0x5638
			// Header size: 12
			// Code size: 88 (0x58)
			.maxstack 3
			.locals init (
				[0] int32,
				[1] class MMP.AsyncProxy.Training.Deadline.FlakyService
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'<>1__state'
			IL_0006: stloc.0
			IL_0007: ldarg.0
			IL_0008: ldfld class MMP.AsyncProxy.Training.Deadline.FlakyService MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'<>4__this'
			IL_000d: stloc.1
			IL_000e: ldloc.0
			IL_000f: brfalse.s IL_0017

			IL_0011: ldloc.0
			IL_0012: ldc.i4.1
			IL_0013: beq.s IL_0038

			IL_0015: ldc.i4.0
			IL_0016: ret

			IL_0017: ldarg.0
			IL_0018: ldc.i4.m1
			IL_0019: stfld int32 MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'<>1__state'
			IL_001e: ldarg.0
			IL_001f: ldarg.0
			IL_0020: ldfld int32 MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::delay
			IL_0025: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture [MMP.AsyncProxy]MMP.AsyncProxy.Futures::Delay(int32)
			IL_002a: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'<>2__current'
			IL_002f: ldarg.0
			IL_0030: ldc.i4.1
			IL_0031: stfld int32 MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'<>1__state'
			IL_0036: ldc.i4.1
			IL_0037: ret

			IL_0038: ldarg.0
			IL_0039: ldc.i4.m1
			IL_003a: stfld int32 MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'<>1__state'
			IL_003f: ldarg.0
			IL_0040: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<string> MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'ret'
			IL_0045: ldloc.1
			IL_0046: ldarg.0
			IL_0047: ldfld int32 MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::attempt
			IL_004c: call instance string MMP.AsyncProxy.Training.Deadline.FlakyService::Answer(int32)
			IL_0051: callvirt instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<string>::set_Value(!0)
			IL_0056: ldc.i4.0
			IL_0057: ret
		} // end of method '<AskBody>d__10'::MoveNext

		.method private final hidebysig specialname newslot virtual 
			instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance !0 class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::get_Current()
			// Method begins at RVA 0x569c
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'<>2__current'
			IL_0006: ret
		} // end of method '<AskBody>d__10'::'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current'

		.method private final hidebysig newslot virtual 
			instance void System.Collections.IEnumerator.Reset () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [mscorlib]System.Collections.IEnumerator::Reset()
			// Method begins at RVA 0x56a4
			// Header size: 1
			// Code size: 6 (0x6)
			.maxstack 8

			IL_0000: newobj instance void [mscorlib]System.NotSupportedException::.ctor()
			IL_0005: throw
		} // end of method '<AskBody>d__10'::System.Collections.IEnumerator.Reset

		.method private final hidebysig specialname newslot virtual 
			instance object System.Collections.IEnumerator.get_Current () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance object [mscorlib]System.Collections.IEnumerator::get_Current()
			// Method begins at RVA 0x56ab
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'<>2__current'
			IL_0006: ret
		} // end of method '<AskBody>d__10'::System.Collections.IEnumerator.get_Current

		.method private final hidebysig newslot virtual 
			instance class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> 'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance class [mscorlib]System.Collections.Generic.IEnumerator`1<!0> class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::GetEnumerator()
			// Method begins at RVA 0x56b4
			// Header size: 12
			// Code size: 96 (0x60)
			.maxstack 2
			.locals init (
				[0] class MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'<>1__state'
			IL_0006: ldc.i4.s -2
			IL_0008: bne.un.s IL_0027

			IL_000a: ldarg.0
			IL_000b: ldfld int32 MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'<>l__initialThreadId'
			IL_0010: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0015: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_001a: bne.un.s IL_0027

			IL_001c: ldarg.0
			IL_001d: ldc.i4.0
			IL_001e: stfld int32 MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'<>1__state'
			IL_0023: ldarg.0
			IL_0024: stloc.0
			IL_0025: br.s IL_003a

			IL_0027: ldc.i4.0
			IL_0028: newobj instance void MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::.ctor(int32)
			IL_002d: stloc.0
			IL_002e: ldloc.0
			IL_002f: ldarg.0
			IL_0030: ldfld class MMP.AsyncProxy.Training.Deadline.FlakyService MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'<>4__this'
			IL_0035: stfld class MMP.AsyncProxy.Training.Deadline.FlakyService MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'<>4__this'

			IL_003a: ldloc.0
			IL_003b: ldarg.0
			IL_003c: ldfld int32 MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'<>3__attempt'
			IL_0041: stfld int32 MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::attempt
			IL_0046: ldloc.0
			IL_0047: ldarg.0
			IL_0048: ldfld int32 MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'<>3__delay'
			IL_004d: stfld int32 MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::delay
			IL_0052: ldloc.0
			IL_0053: ldarg.0
			IL_0054: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<string> MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'<>3__ret'
			IL_0059: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<string> MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'ret'
			IL_005e: ldloc.0
			IL_005f: ret
		} // end of method '<AskBody>d__10'::'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator'

		.method private final hidebysig newslot virtual 
			instance class [mscorlib]System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance class [mscorlib]System.Collections.IEnumerator [mscorlib]System.Collections.IEnumerable::GetEnumerator()
			// Method begins at RVA 0x5720
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator'()
			IL_0006: ret
		} // end of method '<AskBody>d__10'::System.Collections.IEnumerable.GetEnumerator

		// Properties
		.property instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.Current'()
		{
			.get instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current'()
		}
		.property instance object System.Collections.IEnumerator.Current()
		{
			.get instance object MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::System.Collections.IEnumerator.get_Current()
		}

	} // end of class <AskBody>d__10


	// Fields
	.field private initonly int32[] _delays
	.field private initonly class [mscorlib]System.Threading.ManualResetEvent _never
	.field private int32 _answers

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			int32[] delaysMsPerAttempt
		) cil managed 
	{
		.param [1]
			.custom instance void [mscorlib]System.ParamArrayAttribute::.ctor() = (
				01 00 00 00
			)
		// Method begins at RVA 0x3c03
		// Header size: 1
		// Code size: 26 (0x1a)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldc.i4.0
		IL_0002: newobj instance void [mscorlib]System.Threading.ManualResetEvent::.ctor(bool)
		IL_0007: stfld class [mscorlib]System.Threading.ManualResetEvent MMP.AsyncProxy.Training.Deadline.FlakyService::_never
		IL_000c: ldarg.0
		IL_000d: call instance void [mscorlib]System.Object::.ctor()
		IL_0012: ldarg.0
		IL_0013: ldarg.1
		IL_0014: stfld int32[] MMP.AsyncProxy.Training.Deadline.FlakyService::_delays
		IL_0019: ret
	} // end of method FlakyService::.ctor

	.method public hidebysig specialname 
		instance int32 get_Answers () cil managed 
	{
		// Method begins at RVA 0x3c1e
		// Header size: 1
		// Code size: 14 (0xe)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldflda int32 MMP.AsyncProxy.Training.Deadline.FlakyService::_answers
		IL_0006: ldc.i4.0
		IL_0007: ldc.i4.0
		IL_0008: call int32 [mscorlib]System.Threading.Interlocked::CompareExchange(int32&, int32, int32)
		IL_000d: ret
	} // end of method FlakyService::get_Answers

	.method public hidebysig 
		instance int32 DelayFor (
			int32 attempt
		) cil managed 
	{
		// Method begins at RVA 0x3c2d
		// Header size: 1
		// Code size: 38 (0x26)
		.maxstack 8

		IL_0000: ldarg.1
		IL_0001: ldarg.0
		IL_0002: ldfld int32[] MMP.AsyncProxy.Training.Deadline.FlakyService::_delays
		IL_0007: ldlen
		IL_0008: conv.i4
		IL_0009: blt.s IL_001d

		IL_000b: ldarg.0
		IL_000c: ldfld int32[] MMP.AsyncProxy.Training.Deadline.FlakyService::_delays
		IL_0011: ldarg.0
		IL_0012: ldfld int32[] MMP.AsyncProxy.Training.Deadline.FlakyService::_delays
		IL_0017: ldlen
		IL_0018: conv.i4
		IL_0019: ldc.i4.1
		IL_001a: sub
		IL_001b: ldelem.i4
		IL_001c: ret

		IL_001d: ldarg.0
		IL_001e: ldfld int32[] MMP.AsyncProxy.Training.Deadline.FlakyService::_delays
		IL_0023: ldarg.1
		IL_0024: ldelem.i4
		IL_0025: ret
	} // end of method FlakyService::DelayFor

	.method public hidebysig 
		instance string Answer (
			int32 attempt
		) cil managed 
	{
		// Method begins at RVA 0x3c54
		// Header size: 12
		// Code size: 34 (0x22)
		.maxstack 3
		.locals init (
			[0] int32
		)

		IL_0000: ldarg.0
		IL_0001: ldflda int32 MMP.AsyncProxy.Training.Deadline.FlakyService::_answers
		IL_0006: call int32 [mscorlib]System.Threading.Interlocked::Increment(int32&)
		IL_000b: pop
		IL_000c: ldstr "ok on attempt "
		IL_0011: ldarg.1
		IL_0012: ldc.i4.1
		IL_0013: add
		IL_0014: stloc.0
		IL_0015: ldloca.s 0
		IL_0017: call instance string [mscorlib]System.Int32::ToString()
		IL_001c: call string [mscorlib]System.String::Concat(string, string)
		IL_0021: ret
	} // end of method FlakyService::Answer

	.method public hidebysig 
		instance string Ask (
			int32 attempt
		) cil managed 
	{
		// Method begins at RVA 0x3c84
		// Header size: 12
		// Code size: 40 (0x28)
		.maxstack 2
		.locals init (
			[0] int32
		)

		IL_0000: ldarg.0
		IL_0001: ldarg.1
		IL_0002: call instance int32 MMP.AsyncProxy.Training.Deadline.FlakyService::DelayFor(int32)
		IL_0007: stloc.0
		IL_0008: ldloc.0
		IL_0009: ldc.i4.0
		IL_000a: bge.s IL_001a

		IL_000c: ldarg.0
		IL_000d: ldfld class [mscorlib]System.Threading.ManualResetEvent MMP.AsyncProxy.Training.Deadline.FlakyService::_never
		IL_0012: callvirt instance bool [mscorlib]System.Threading.WaitHandle::WaitOne()
		IL_0017: pop
		IL_0018: ldnull
		IL_0019: ret

		IL_001a: ldloc.0
		IL_001b: call void [mscorlib]System.Threading.Thread::Sleep(int32)
		IL_0020: ldarg.0
		IL_0021: ldarg.1
		IL_0022: call instance string MMP.AsyncProxy.Training.Deadline.FlakyService::Answer(int32)
		IL_0027: ret
	} // end of method FlakyService::Ask

	.method public hidebysig 
		instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<string> AskAsync (
			int32 attempt
		) cil managed 
	{
		// Method begins at RVA 0x3cb8
		// Header size: 12
		// Code size: 77 (0x4d)
		.maxstack 3
		.locals init (
			[0] class MMP.AsyncProxy.Training.Deadline.FlakyService/'<>c__DisplayClass9_0'
		)

		IL_0000: newobj instance void MMP.AsyncProxy.Training.Deadline.FlakyService/'<>c__DisplayClass9_0'::.ctor()
		IL_0005: stloc.0
		IL_0006: ldloc.0
		IL_0007: ldarg.0
		IL_0008: stfld class MMP.AsyncProxy.Training.Deadline.FlakyService MMP.AsyncProxy.Training.Deadline.FlakyService/'<>c__DisplayClass9_0'::'<>4__this'
		IL_000d: ldloc.0
		IL_000e: ldarg.1
		IL_000f: stfld int32 MMP.AsyncProxy.Training.Deadline.FlakyService/'<>c__DisplayClass9_0'::attempt
		IL_0014: ldloc.0
		IL_0015: ldarg.0
		IL_0016: ldloc.0
		IL_0017: ldfld int32 MMP.AsyncProxy.Training.Deadline.FlakyService/'<>c__DisplayClass9_0'::attempt
		IL_001c: call instance int32 MMP.AsyncProxy.Training.Deadline.FlakyService::DelayFor(int32)
		IL_0021: stfld int32 MMP.AsyncProxy.Training.Deadline.FlakyService/'<>c__DisplayClass9_0'::delay
		IL_0026: ldloc.0
		IL_0027: ldfld int32 MMP.AsyncProxy.Training.Deadline.FlakyService/'<>c__DisplayClass9_0'::delay
		IL_002c: ldc.i4.0
		IL_002d: bge.s IL_003b

		IL_002f: ldc.i4.1
		IL_0030: newobj instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<string>::.ctor(valuetype [MMP.AsyncProxy]MMP.AsyncProxy.PromiseOptions)
		IL_0035: call instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<string>::get_Future()
		IL_003a: ret

		IL_003b: ldloc.0
		IL_003c: ldftn instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Deadline.FlakyService/'<>c__DisplayClass9_0'::'<AskAsync>b__0'(class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<string>)
		IL_0042: newobj instance void class [System.Core]System.Func`2<class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<string>, class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>>::.ctor(object, native int)
		IL_0047: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!!0> [MMP.AsyncProxy]MMP.AsyncProxy.AsyncProxy::Run<string>(class [System.Core]System.Func`2<class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<!!0>, class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>>)
		IL_004c: ret
	} // end of method FlakyService::AskAsync

	.method private hidebysig 
		instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> AskBody (
			int32 attempt,
			int32 delay,
			class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<string> 'ret'
		) cil managed 
	{
		// Method begins at RVA 0x3d11
		// Header size: 1
		// Code size: 36 (0x24)
		.maxstack 8

		IL_0000: ldc.i4.s -2
		IL_0002: newobj instance void MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::.ctor(int32)
		IL_0007: dup
		IL_0008: ldarg.0
		IL_0009: stfld class MMP.AsyncProxy.Training.Deadline.FlakyService MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'<>4__this'
		IL_000e: dup
		IL_000f: ldarg.1
		IL_0010: stfld int32 MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'<>3__attempt'
		IL_0015: dup
		IL_0016: ldarg.2
		IL_0017: stfld int32 MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'<>3__delay'
		IL_001c: dup
		IL_001d: ldarg.3
		IL_001e: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<string> MMP.AsyncProxy.Training.Deadline.FlakyService/'<AskBody>d__10'::'<>3__ret'
		IL_0023: ret
	} // end of method FlakyService::AskBody

	// Properties
	.property instance int32 Answers()
	{
		.get instance int32 MMP.AsyncProxy.Training.Deadline.FlakyService::get_Answers()
	}

} // end of class MMP.AsyncProxy.Training.Deadline.FlakyService

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller
	extends [mscorlib]System.Object
	implements MMP.AsyncProxy.Training.Deadline.IDeadlineCaller,
	           [mscorlib]System.IDisposable
{
	// Nested Types
	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass5_0'
		extends [mscorlib]System.Object
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field public class [mscorlib]System.Threading.ManualResetEvent gaveUp
		.field public class MMP.AsyncProxy.Training.Deadline.FlakyService service

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor () cil managed 
		{
			// Method begins at RVA 0x5728
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass5_0'::.ctor

		.method assembly hidebysig 
			instance void '<Call>b__0' () cil managed 
		{
			// Method begins at RVA 0x5730
			// Header size: 1
			// Code size: 13 (0xd)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [mscorlib]System.Threading.ManualResetEvent MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass5_0'::gaveUp
			IL_0006: callvirt instance bool [mscorlib]System.Threading.EventWaitHandle::Set()
			IL_000b: pop
			IL_000c: ret
		} // end of method '<>c__DisplayClass5_0'::'<Call>b__0'

	} // end of class <>c__DisplayClass5_0

	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass5_1'
		extends [mscorlib]System.Object
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field public string[] slot
		.field public int32 which
		.field public class [mscorlib]System.Threading.ManualResetEvent answered
		.field public class MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass5_0' 'CS$<>8__locals1'

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor () cil managed 
		{
			// Method begins at RVA 0x573e
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass5_1'::.ctor

		.method assembly hidebysig 
			instance void '<Call>b__1' () cil managed 
		{
			// Method begins at RVA 0x5746
			// Header size: 1
			// Code size: 43 (0x2b)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld string[] MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass5_1'::slot
			IL_0006: ldc.i4.0
			IL_0007: ldarg.0
			IL_0008: ldfld class MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass5_0' MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass5_1'::'CS$<>8__locals1'
			IL_000d: ldfld class MMP.AsyncProxy.Training.Deadline.FlakyService MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass5_0'::service
			IL_0012: ldarg.0
			IL_0013: ldfld int32 MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass5_1'::which
			IL_0018: callvirt instance string MMP.AsyncProxy.Training.Deadline.FlakyService::Ask(int32)
			IL_001d: stelem.ref
			IL_001e: ldarg.0
			IL_001f: ldfld class [mscorlib]System.Threading.ManualResetEvent MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass5_1'::answered
			IL_0024: callvirt instance bool [mscorlib]System.Threading.EventWaitHandle::Set()
			IL_0029: pop
			IL_002a: ret
		} // end of method '<>c__DisplayClass5_1'::'<Call>b__1'

	} // end of class <>c__DisplayClass5_1


	// Fields
	.field private initonly class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.Threading.Thread> _attempts

	// Methods
	.method public final hidebysig specialname newslot virtual 
		instance string get_Version () cil managed 
	{
		// Method begins at RVA 0x3d36
		// Header size: 1
		// Code size: 6 (0x6)
		.maxstack 8

		IL_0000: ldstr "threaded"
		IL_0005: ret
	} // end of method ThreadPerAttemptCaller::get_Version

	.method public hidebysig specialname 
		instance int32 get_ParkedAttempts () cil managed 
	{
		// Method begins at RVA 0x3d40
		// Header size: 12
		// Code size: 81 (0x51)
		.maxstack 2
		.locals init (
			[0] int32,
			[1] class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.Threading.Thread>,
			[2] valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<class [mscorlib]System.Threading.Thread>
		)

		IL_0000: ldc.i4.0
		IL_0001: stloc.0
		IL_0002: ldarg.0
		IL_0003: ldfld class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.Threading.Thread> MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller::_attempts
		IL_0008: stloc.1
		IL_0009: ldloc.1
		IL_000a: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_000f: ldarg.0
			IL_0010: ldfld class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.Threading.Thread> MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller::_attempts
			IL_0015: callvirt instance valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<!0> class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.Threading.Thread>::GetEnumerator()
			IL_001a: stloc.2
			.try
			{
				IL_001b: br.s IL_002f
				// loop start (head: IL_002f)
					IL_001d: ldloca.s 2
					IL_001f: call instance !0 valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<class [mscorlib]System.Threading.Thread>::get_Current()
					IL_0024: callvirt instance bool [mscorlib]System.Threading.Thread::get_IsAlive()
					IL_0029: brfalse.s IL_002f

					IL_002b: ldloc.0
					IL_002c: ldc.i4.1
					IL_002d: add
					IL_002e: stloc.0

					IL_002f: ldloca.s 2
					IL_0031: call instance bool valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<class [mscorlib]System.Threading.Thread>::MoveNext()
					IL_0036: brtrue.s IL_001d
				// end loop

				IL_0038: leave.s IL_004f
			} // end .try
			finally
			{
				IL_003a: ldloca.s 2
				IL_003c: constrained. valuetype [mscorlib]System.Collections.Generic.List`1/Enumerator<class [mscorlib]System.Threading.Thread>
				IL_0042: callvirt instance void [mscorlib]System.IDisposable::Dispose()
				IL_0047: endfinally
			} // end handler
		} // end .try
		finally
		{
			IL_0048: ldloc.1
			IL_0049: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_004e: endfinally
		} // end handler

		IL_004f: ldloc.0
		IL_0050: ret
	} // end of method ThreadPerAttemptCaller::get_ParkedAttempts

	.method public final hidebysig newslot virtual 
		instance class MMP.AsyncProxy.Training.Deadline.CallResult Call (
			class MMP.AsyncProxy.Training.Deadline.FlakyService service,
			int32 timeoutMs,
			int32 maxAttempts,
			class MMP.AsyncProxy.Training.Deadline.GiveUp giveUp
		) cil managed 
	{
		// Method begins at RVA 0x3dbc
		// Header size: 12
		// Code size: 300 (0x12c)
		.maxstack 4
		.locals init (
			[0] class MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass5_0',
			[1] int32,
			[2] class MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass5_1',
			[3] class [mscorlib]System.Threading.Thread,
			[4] int32,
			[5] class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.Threading.Thread>
		)

		IL_0000: newobj instance void MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass5_0'::.ctor()
		IL_0005: stloc.0
		IL_0006: ldloc.0
		IL_0007: ldarg.1
		IL_0008: stfld class MMP.AsyncProxy.Training.Deadline.FlakyService MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass5_0'::service
		IL_000d: ldloc.0
		IL_000e: ldc.i4.0
		IL_000f: newobj instance void [mscorlib]System.Threading.ManualResetEvent::.ctor(bool)
		IL_0014: stfld class [mscorlib]System.Threading.ManualResetEvent MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass5_0'::gaveUp
		IL_0019: ldarg.s giveUp
		IL_001b: ldloc.0
		IL_001c: ldftn instance void MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass5_0'::'<Call>b__0'()
		IL_0022: newobj instance void [System.Core]System.Action::.ctor(object, native int)
		IL_0027: callvirt instance void MMP.AsyncProxy.Training.Deadline.GiveUp::OnFired(class [System.Core]System.Action)
		IL_002c: ldc.i4.0
		IL_002d: stloc.1
		IL_002e: br IL_011c
		// loop start (head: IL_011c)
			IL_0033: newobj instance void MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass5_1'::.ctor()
			IL_0038: stloc.2
			IL_0039: ldloc.2
			IL_003a: ldloc.0
			IL_003b: stfld class MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass5_0' MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass5_1'::'CS$<>8__locals1'
			IL_0040: ldarg.s giveUp
			IL_0042: callvirt instance bool MMP.AsyncProxy.Training.Deadline.GiveUp::get_Requested()
			IL_0047: brfalse.s IL_0052

			IL_0049: ldc.i4.2
			IL_004a: ldnull
			IL_004b: ldloc.1
			IL_004c: newobj instance void MMP.AsyncProxy.Training.Deadline.CallResult::.ctor(valuetype MMP.AsyncProxy.Training.Deadline.CallOutcome, string, int32)
			IL_0051: ret

			IL_0052: ldloc.2
			IL_0053: ldc.i4.1
			IL_0054: newarr [mscorlib]System.String
			IL_0059: stfld string[] MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass5_1'::slot
			IL_005e: ldloc.2
			IL_005f: ldc.i4.0
			IL_0060: newobj instance void [mscorlib]System.Threading.ManualResetEvent::.ctor(bool)
			IL_0065: stfld class [mscorlib]System.Threading.ManualResetEvent MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass5_1'::answered
			IL_006a: ldloc.2
			IL_006b: ldloc.1
			IL_006c: stfld int32 MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass5_1'::which
			IL_0071: ldloc.2
			IL_0072: ldftn instance void MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass5_1'::'<Call>b__1'()
			IL_0078: newobj instance void [mscorlib]System.Threading.ThreadStart::.ctor(object, native int)
			IL_007d: newobj instance void [mscorlib]System.Threading.Thread::.ctor(class [mscorlib]System.Threading.ThreadStart)
			IL_0082: stloc.3
			IL_0083: ldloc.3
			IL_0084: ldc.i4.1
			IL_0085: callvirt instance void [mscorlib]System.Threading.Thread::set_IsBackground(bool)
			IL_008a: ldloc.3
			IL_008b: ldstr "attempt:"
			IL_0090: ldloca.s 1
			IL_0092: call instance string [mscorlib]System.Int32::ToString()
			IL_0097: call string [mscorlib]System.String::Concat(string, string)
			IL_009c: callvirt instance void [mscorlib]System.Threading.Thread::set_Name(string)
			IL_00a1: ldarg.0
			IL_00a2: ldfld class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.Threading.Thread> MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller::_attempts
			IL_00a7: stloc.s 5
			IL_00a9: ldloc.s 5
			IL_00ab: call void [mscorlib]System.Threading.Monitor::Enter(object)
			.try
			{
				IL_00b0: ldarg.0
				IL_00b1: ldfld class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.Threading.Thread> MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller::_attempts
				IL_00b6: ldloc.3
				IL_00b7: callvirt instance void class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.Threading.Thread>::Add(!0)
				IL_00bc: leave.s IL_00c6
			} // end .try
			finally
			{
				IL_00be: ldloc.s 5
				IL_00c0: call void [mscorlib]System.Threading.Monitor::Exit(object)
				IL_00c5: endfinally
			} // end handler

			IL_00c6: ldloc.3
			IL_00c7: callvirt instance void [mscorlib]System.Threading.Thread::Start()
			IL_00cc: ldc.i4.2
			IL_00cd: newarr [mscorlib]System.Threading.WaitHandle
			IL_00d2: dup
			IL_00d3: ldc.i4.0
			IL_00d4: ldloc.2
			IL_00d5: ldfld class [mscorlib]System.Threading.ManualResetEvent MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass5_1'::answered
			IL_00da: stelem.ref
			IL_00db: dup
			IL_00dc: ldc.i4.1
			IL_00dd: ldloc.2
			IL_00de: ldfld class MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass5_0' MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass5_1'::'CS$<>8__locals1'
			IL_00e3: ldfld class [mscorlib]System.Threading.ManualResetEvent MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass5_0'::gaveUp
			IL_00e8: stelem.ref
			IL_00e9: ldarg.2
			IL_00ea: ldc.i4.0
			IL_00eb: call int32 [mscorlib]System.Threading.WaitHandle::WaitAny(class [mscorlib]System.Threading.WaitHandle[], int32, bool)
			IL_00f0: stloc.s 4
			IL_00f2: ldloc.s 4
			IL_00f4: brtrue.s IL_0108

			IL_00f6: ldc.i4.0
			IL_00f7: ldloc.2
			IL_00f8: ldfld string[] MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass5_1'::slot
			IL_00fd: ldc.i4.0
			IL_00fe: ldelem.ref
			IL_00ff: ldloc.1
			IL_0100: ldc.i4.1
			IL_0101: add
			IL_0102: newobj instance void MMP.AsyncProxy.Training.Deadline.CallResult::.ctor(valuetype MMP.AsyncProxy.Training.Deadline.CallOutcome, string, int32)
			IL_0107: ret

			IL_0108: ldloc.s 4
			IL_010a: ldc.i4.1
			IL_010b: bne.un.s IL_0118

			IL_010d: ldc.i4.2
			IL_010e: ldnull
			IL_010f: ldloc.1
			IL_0110: ldc.i4.1
			IL_0111: add
			IL_0112: newobj instance void MMP.AsyncProxy.Training.Deadline.CallResult::.ctor(valuetype MMP.AsyncProxy.Training.Deadline.CallOutcome, string, int32)
			IL_0117: ret

			IL_0118: ldloc.1
			IL_0119: ldc.i4.1
			IL_011a: add
			IL_011b: stloc.1

			IL_011c: ldloc.1
			IL_011d: ldarg.3
			IL_011e: blt IL_0033
		// end loop

		IL_0123: ldc.i4.1
		IL_0124: ldnull
		IL_0125: ldarg.3
		IL_0126: newobj instance void MMP.AsyncProxy.Training.Deadline.CallResult::.ctor(valuetype MMP.AsyncProxy.Training.Deadline.CallOutcome, string, int32)
		IL_012b: ret
	} // end of method ThreadPerAttemptCaller::Call

	.method public final hidebysig newslot virtual 
		instance void Dispose () cil managed 
	{
		// Method begins at RVA 0x3f04
		// Header size: 1
		// Code size: 1 (0x1)
		.maxstack 8

		IL_0000: ret
	} // end of method ThreadPerAttemptCaller::Dispose

	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x3f06
		// Header size: 1
		// Code size: 18 (0x12)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: newobj instance void class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.Threading.Thread>::.ctor()
		IL_0006: stfld class [mscorlib]System.Collections.Generic.List`1<class [mscorlib]System.Threading.Thread> MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller::_attempts
		IL_000b: ldarg.0
		IL_000c: call instance void [mscorlib]System.Object::.ctor()
		IL_0011: ret
	} // end of method ThreadPerAttemptCaller::.ctor

	// Properties
	.property instance string Version()
	{
		.get instance string MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller::get_Version()
	}
	.property instance int32 ParkedAttempts()
	{
		.get instance int32 MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller::get_ParkedAttempts()
	}

} // end of class MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller
	extends [mscorlib]System.Object
	implements MMP.AsyncProxy.Training.Deadline.IDeadlineCaller,
	           [mscorlib]System.IDisposable
{
	// Nested Types
	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass2_0'
		extends [mscorlib]System.Object
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field public class MMP.AsyncProxy.Training.Deadline.FlakyService service
		.field public int32 timeoutMs
		.field public int32 maxAttempts
		.field public class [MMP.AsyncProxy]MMP.AsyncProxy.CancelSource cord

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor () cil managed 
		{
			// Method begins at RVA 0x5772
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass2_0'::.ctor

		.method assembly hidebysig 
			instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> '<Call>b__0' (
				class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Deadline.CallResult> 'ret'
			) cil managed 
		{
			// Method begins at RVA 0x577a
			// Header size: 1
			// Code size: 36 (0x24)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class MMP.AsyncProxy.Training.Deadline.FlakyService MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<>c__DisplayClass2_0'::service
			IL_0006: ldarg.0
			IL_0007: ldfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<>c__DisplayClass2_0'::timeoutMs
			IL_000c: ldarg.0
			IL_000d: ldfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<>c__DisplayClass2_0'::maxAttempts
			IL_0012: ldarg.0
			IL_0013: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.CancelSource MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<>c__DisplayClass2_0'::cord
			IL_0018: callvirt instance valuetype [MMP.AsyncProxy]MMP.AsyncProxy.CancelToken [MMP.AsyncProxy]MMP.AsyncProxy.CancelSource::get_Token()
			IL_001d: ldarg.1
			IL_001e: call class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller::Attempts(class MMP.AsyncProxy.Training.Deadline.FlakyService, int32, int32, valuetype [MMP.AsyncProxy]MMP.AsyncProxy.CancelToken, class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Deadline.CallResult>)
			IL_0023: ret
		} // end of method '<>c__DisplayClass2_0'::'<Call>b__0'

	} // end of class <>c__DisplayClass2_0

	.class nested private auto ansi sealed beforefieldinit '<Attempts>d__3'
		extends [mscorlib]System.Object
		implements class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>,
		           [mscorlib]System.Collections.IEnumerable,
		           class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>,
		           [mscorlib]System.IDisposable,
		           [mscorlib]System.Collections.IEnumerator
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field private int32 '<>1__state'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture '<>2__current'
		.field private int32 '<>l__initialThreadId'
		.field private valuetype [MMP.AsyncProxy]MMP.AsyncProxy.CancelToken cord
		.field public valuetype [MMP.AsyncProxy]MMP.AsyncProxy.CancelToken '<>3__cord'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Deadline.CallResult> 'ret'
		.field public class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Deadline.CallResult> '<>3__ret'
		.field private class MMP.AsyncProxy.Training.Deadline.FlakyService service
		.field public class MMP.AsyncProxy.Training.Deadline.FlakyService '<>3__service'
		.field private int32 timeoutMs
		.field public int32 '<>3__timeoutMs'
		.field private int32 maxAttempts
		.field public int32 '<>3__maxAttempts'
		.field private int32 '<attempt>5__2'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<string> '<answer>5__3'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> '<first>5__4'

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor (
				int32 '<>1__state'
			) cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			// Method begins at RVA 0x579f
			// Header size: 1
			// Code size: 30 (0x1e)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ldarg.0
			IL_0007: ldarg.1
			IL_0008: stfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<>1__state'
			IL_000d: ldarg.0
			IL_000e: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0013: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_0018: stfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<>l__initialThreadId'
			IL_001d: ret
		} // end of method '<Attempts>d__3'::.ctor

		.method private final hidebysig newslot virtual 
			instance void System.IDisposable.Dispose () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [mscorlib]System.IDisposable::Dispose()
			// Method begins at RVA 0x57be
			// Header size: 1
			// Code size: 23 (0x17)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldnull
			IL_0002: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<string> MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<answer>5__3'
			IL_0007: ldarg.0
			IL_0008: ldnull
			IL_0009: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<first>5__4'
			IL_000e: ldarg.0
			IL_000f: ldc.i4.s -2
			IL_0011: stfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<>1__state'
			IL_0016: ret
		} // end of method '<Attempts>d__3'::System.IDisposable.Dispose

		.method private final hidebysig newslot virtual 
			instance bool MoveNext () cil managed 
		{
			.override method instance bool [mscorlib]System.Collections.IEnumerator::MoveNext()
			// Method begins at RVA 0x57d8
			// Header size: 12
			// Code size: 347 (0x15b)
			.maxstack 5
			.locals init (
				[0] int32,
				[1] class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture,
				[2] int32
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<>1__state'
			IL_0006: stloc.0
			IL_0007: ldloc.0
			IL_0008: brfalse.s IL_0013

			IL_000a: ldloc.0
			IL_000b: ldc.i4.1
			IL_000c: beq IL_00a9

			IL_0011: ldc.i4.0
			IL_0012: ret

			IL_0013: ldarg.0
			IL_0014: ldc.i4.m1
			IL_0015: stfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<>1__state'
			IL_001a: ldarg.0
			IL_001b: ldc.i4.0
			IL_001c: stfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<attempt>5__2'
			IL_0021: br IL_0130

			IL_0026: ldarg.0
			IL_0027: ldflda valuetype [MMP.AsyncProxy]MMP.AsyncProxy.CancelToken MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::cord
			IL_002c: call instance bool [MMP.AsyncProxy]MMP.AsyncProxy.CancelToken::get_IsCancelRequested()
			IL_0031: brfalse.s IL_004d

			IL_0033: ldarg.0
			IL_0034: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Deadline.CallResult> MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'ret'
			IL_0039: ldc.i4.2
			IL_003a: ldnull
			IL_003b: ldarg.0
			IL_003c: ldfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<attempt>5__2'
			IL_0041: newobj instance void MMP.AsyncProxy.Training.Deadline.CallResult::.ctor(valuetype MMP.AsyncProxy.Training.Deadline.CallOutcome, string, int32)
			IL_0046: callvirt instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Deadline.CallResult>::set_Value(!0)
			IL_004b: ldc.i4.0
			IL_004c: ret

			IL_004d: ldarg.0
			IL_004e: ldarg.0
			IL_004f: ldfld class MMP.AsyncProxy.Training.Deadline.FlakyService MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::service
			IL_0054: ldarg.0
			IL_0055: ldfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<attempt>5__2'
			IL_005a: callvirt instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<string> MMP.AsyncProxy.Training.Deadline.FlakyService::AskAsync(int32)
			IL_005f: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<string> MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<answer>5__3'
			IL_0064: ldarg.0
			IL_0065: ldfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::timeoutMs
			IL_006a: ldarg.0
			IL_006b: ldfld valuetype [MMP.AsyncProxy]MMP.AsyncProxy.CancelToken MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::cord
			IL_0070: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture [MMP.AsyncProxy]MMP.AsyncProxy.Futures::Delay(int32, valuetype [MMP.AsyncProxy]MMP.AsyncProxy.CancelToken)
			IL_0075: stloc.1
			IL_0076: ldarg.0
			IL_0077: ldc.i4.2
			IL_0078: newarr [MMP.AsyncProxy]MMP.AsyncProxy.IFuture
			IL_007d: dup
			IL_007e: ldc.i4.0
			IL_007f: ldarg.0
			IL_0080: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<string> MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<answer>5__3'
			IL_0085: stelem.ref
			IL_0086: dup
			IL_0087: ldc.i4.1
			IL_0088: ldloc.1
			IL_0089: stelem.ref
			IL_008a: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> [MMP.AsyncProxy]MMP.AsyncProxy.Futures::WhenAny(class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture[])
			IL_008f: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<first>5__4'
			IL_0094: ldarg.0
			IL_0095: ldarg.0
			IL_0096: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<first>5__4'
			IL_009b: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<>2__current'
			IL_00a0: ldarg.0
			IL_00a1: ldc.i4.1
			IL_00a2: stfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<>1__state'
			IL_00a7: ldc.i4.1
			IL_00a8: ret

			IL_00a9: ldarg.0
			IL_00aa: ldc.i4.m1
			IL_00ab: stfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<>1__state'
			IL_00b0: ldarg.0
			IL_00b1: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<first>5__4'
			IL_00b6: callvirt instance !0 class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::get_Result()
			IL_00bb: ldarg.0
			IL_00bc: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<string> MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<answer>5__3'
			IL_00c1: bne.un.s IL_00e9

			IL_00c3: ldarg.0
			IL_00c4: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Deadline.CallResult> MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'ret'
			IL_00c9: ldc.i4.0
			IL_00ca: ldarg.0
			IL_00cb: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<string> MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<answer>5__3'
			IL_00d0: callvirt instance !0 class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<string>::get_Result()
			IL_00d5: ldarg.0
			IL_00d6: ldfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<attempt>5__2'
			IL_00db: ldc.i4.1
			IL_00dc: add
			IL_00dd: newobj instance void MMP.AsyncProxy.Training.Deadline.CallResult::.ctor(valuetype MMP.AsyncProxy.Training.Deadline.CallOutcome, string, int32)
			IL_00e2: callvirt instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Deadline.CallResult>::set_Value(!0)
			IL_00e7: ldc.i4.0
			IL_00e8: ret

			IL_00e9: ldarg.0
			IL_00ea: ldflda valuetype [MMP.AsyncProxy]MMP.AsyncProxy.CancelToken MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::cord
			IL_00ef: call instance bool [MMP.AsyncProxy]MMP.AsyncProxy.CancelToken::get_IsCancelRequested()
			IL_00f4: brfalse.s IL_0112

			IL_00f6: ldarg.0
			IL_00f7: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Deadline.CallResult> MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'ret'
			IL_00fc: ldc.i4.2
			IL_00fd: ldnull
			IL_00fe: ldarg.0
			IL_00ff: ldfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<attempt>5__2'
			IL_0104: ldc.i4.1
			IL_0105: add
			IL_0106: newobj instance void MMP.AsyncProxy.Training.Deadline.CallResult::.ctor(valuetype MMP.AsyncProxy.Training.Deadline.CallOutcome, string, int32)
			IL_010b: callvirt instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Deadline.CallResult>::set_Value(!0)
			IL_0110: ldc.i4.0
			IL_0111: ret

			IL_0112: ldarg.0
			IL_0113: ldnull
			IL_0114: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<string> MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<answer>5__3'
			IL_0119: ldarg.0
			IL_011a: ldnull
			IL_011b: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<first>5__4'
			IL_0120: ldarg.0
			IL_0121: ldfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<attempt>5__2'
			IL_0126: stloc.2
			IL_0127: ldarg.0
			IL_0128: ldloc.2
			IL_0129: ldc.i4.1
			IL_012a: add
			IL_012b: stfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<attempt>5__2'

			IL_0130: ldarg.0
			IL_0131: ldfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<attempt>5__2'
			IL_0136: ldarg.0
			IL_0137: ldfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::maxAttempts
			IL_013c: blt IL_0026

			IL_0141: ldarg.0
			IL_0142: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Deadline.CallResult> MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'ret'
			IL_0147: ldc.i4.1
			IL_0148: ldnull
			IL_0149: ldarg.0
			IL_014a: ldfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::maxAttempts
			IL_014f: newobj instance void MMP.AsyncProxy.Training.Deadline.CallResult::.ctor(valuetype MMP.AsyncProxy.Training.Deadline.CallOutcome, string, int32)
			IL_0154: callvirt instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Deadline.CallResult>::set_Value(!0)
			IL_0159: ldc.i4.0
			IL_015a: ret
		} // end of method '<Attempts>d__3'::MoveNext

		.method private final hidebysig specialname newslot virtual 
			instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance !0 class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::get_Current()
			// Method begins at RVA 0x593f
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<>2__current'
			IL_0006: ret
		} // end of method '<Attempts>d__3'::'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current'

		.method private final hidebysig newslot virtual 
			instance void System.Collections.IEnumerator.Reset () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [mscorlib]System.Collections.IEnumerator::Reset()
			// Method begins at RVA 0x5947
			// Header size: 1
			// Code size: 6 (0x6)
			.maxstack 8

			IL_0000: newobj instance void [mscorlib]System.NotSupportedException::.ctor()
			IL_0005: throw
		} // end of method '<Attempts>d__3'::System.Collections.IEnumerator.Reset

		.method private final hidebysig specialname newslot virtual 
			instance object System.Collections.IEnumerator.get_Current () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance object [mscorlib]System.Collections.IEnumerator::get_Current()
			// Method begins at RVA 0x594e
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<>2__current'
			IL_0006: ret
		} // end of method '<Attempts>d__3'::System.Collections.IEnumerator.get_Current

		.method private final hidebysig newslot virtual 
			instance class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> 'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance class [mscorlib]System.Collections.Generic.IEnumerator`1<!0> class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::GetEnumerator()
			// Method begins at RVA 0x5958
			// Header size: 12
			// Code size: 108 (0x6c)
			.maxstack 2
			.locals init (
				[0] class MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<>1__state'
			IL_0006: ldc.i4.s -2
			IL_0008: bne.un.s IL_0027

			IL_000a: ldarg.0
			IL_000b: ldfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<>l__initialThreadId'
			IL_0010: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0015: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_001a: bne.un.s IL_0027

			IL_001c: ldarg.0
			IL_001d: ldc.i4.0
			IL_001e: stfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<>1__state'
			IL_0023: ldarg.0
			IL_0024: stloc.0
			IL_0025: br.s IL_002e

			IL_0027: ldc.i4.0
			IL_0028: newobj instance void MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::.ctor(int32)
			IL_002d: stloc.0

			IL_002e: ldloc.0
			IL_002f: ldarg.0
			IL_0030: ldfld class MMP.AsyncProxy.Training.Deadline.FlakyService MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<>3__service'
			IL_0035: stfld class MMP.AsyncProxy.Training.Deadline.FlakyService MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::service
			IL_003a: ldloc.0
			IL_003b: ldarg.0
			IL_003c: ldfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<>3__timeoutMs'
			IL_0041: stfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::timeoutMs
			IL_0046: ldloc.0
			IL_0047: ldarg.0
			IL_0048: ldfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<>3__maxAttempts'
			IL_004d: stfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::maxAttempts
			IL_0052: ldloc.0
			IL_0053: ldarg.0
			IL_0054: ldfld valuetype [MMP.AsyncProxy]MMP.AsyncProxy.CancelToken MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<>3__cord'
			IL_0059: stfld valuetype [MMP.AsyncProxy]MMP.AsyncProxy.CancelToken MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::cord
			IL_005e: ldloc.0
			IL_005f: ldarg.0
			IL_0060: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Deadline.CallResult> MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<>3__ret'
			IL_0065: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Deadline.CallResult> MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'ret'
			IL_006a: ldloc.0
			IL_006b: ret
		} // end of method '<Attempts>d__3'::'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator'

		.method private final hidebysig newslot virtual 
			instance class [mscorlib]System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance class [mscorlib]System.Collections.IEnumerator [mscorlib]System.Collections.IEnumerable::GetEnumerator()
			// Method begins at RVA 0x59d0
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator'()
			IL_0006: ret
		} // end of method '<Attempts>d__3'::System.Collections.IEnumerable.GetEnumerator

		// Properties
		.property instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.Current'()
		{
			.get instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current'()
		}
		.property instance object System.Collections.IEnumerator.Current()
		{
			.get instance object MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::System.Collections.IEnumerator.get_Current()
		}

	} // end of class <Attempts>d__3


	// Methods
	.method public final hidebysig specialname newslot virtual 
		instance string get_Version () cil managed 
	{
		// Method begins at RVA 0x3f19
		// Header size: 1
		// Code size: 6 (0x6)
		.maxstack 8

		IL_0000: ldstr "asyncproxy"
		IL_0005: ret
	} // end of method WhenAnyCaller::get_Version

	.method public final hidebysig newslot virtual 
		instance class MMP.AsyncProxy.Training.Deadline.CallResult Call (
			class MMP.AsyncProxy.Training.Deadline.FlakyService service,
			int32 timeoutMs,
			int32 maxAttempts,
			class MMP.AsyncProxy.Training.Deadline.GiveUp giveUp
		) cil managed 
	{
		// Method begins at RVA 0x3f20
		// Header size: 12
		// Code size: 85 (0x55)
		.maxstack 3
		.locals init (
			[0] class MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<>c__DisplayClass2_0'
		)

		IL_0000: newobj instance void MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<>c__DisplayClass2_0'::.ctor()
		IL_0005: stloc.0
		IL_0006: ldloc.0
		IL_0007: ldarg.1
		IL_0008: stfld class MMP.AsyncProxy.Training.Deadline.FlakyService MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<>c__DisplayClass2_0'::service
		IL_000d: ldloc.0
		IL_000e: ldarg.2
		IL_000f: stfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<>c__DisplayClass2_0'::timeoutMs
		IL_0014: ldloc.0
		IL_0015: ldarg.3
		IL_0016: stfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<>c__DisplayClass2_0'::maxAttempts
		IL_001b: ldloc.0
		IL_001c: newobj instance void [MMP.AsyncProxy]MMP.AsyncProxy.CancelSource::.ctor()
		IL_0021: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.CancelSource MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<>c__DisplayClass2_0'::cord
		IL_0026: ldarg.s giveUp
		IL_0028: ldloc.0
		IL_0029: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.CancelSource MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<>c__DisplayClass2_0'::cord
		IL_002e: ldftn instance void [MMP.AsyncProxy]MMP.AsyncProxy.CancelSource::Cancel()
		IL_0034: newobj instance void [System.Core]System.Action::.ctor(object, native int)
		IL_0039: callvirt instance void MMP.AsyncProxy.Training.Deadline.GiveUp::OnFired(class [System.Core]System.Action)
		IL_003e: ldloc.0
		IL_003f: ldftn instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<>c__DisplayClass2_0'::'<Call>b__0'(class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Deadline.CallResult>)
		IL_0045: newobj instance void class [System.Core]System.Func`2<class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Deadline.CallResult>, class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>>::.ctor(object, native int)
		IL_004a: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!!0> [MMP.AsyncProxy]MMP.AsyncProxy.AsyncProxy::Run<class MMP.AsyncProxy.Training.Deadline.CallResult>(class [System.Core]System.Func`2<class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<!!0>, class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>>)
		IL_004f: callvirt instance !0 class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class MMP.AsyncProxy.Training.Deadline.CallResult>::get_Result()
		IL_0054: ret
	} // end of method WhenAnyCaller::Call

	.method private hidebysig static 
		class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> Attempts (
			class MMP.AsyncProxy.Training.Deadline.FlakyService service,
			int32 timeoutMs,
			int32 maxAttempts,
			valuetype [MMP.AsyncProxy]MMP.AsyncProxy.CancelToken cord,
			class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Deadline.CallResult> 'ret'
		) cil managed 
	{
		// Method begins at RVA 0x3f81
		// Header size: 1
		// Code size: 44 (0x2c)
		.maxstack 8

		IL_0000: ldc.i4.s -2
		IL_0002: newobj instance void MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::.ctor(int32)
		IL_0007: dup
		IL_0008: ldarg.0
		IL_0009: stfld class MMP.AsyncProxy.Training.Deadline.FlakyService MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<>3__service'
		IL_000e: dup
		IL_000f: ldarg.1
		IL_0010: stfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<>3__timeoutMs'
		IL_0015: dup
		IL_0016: ldarg.2
		IL_0017: stfld int32 MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<>3__maxAttempts'
		IL_001c: dup
		IL_001d: ldarg.3
		IL_001e: stfld valuetype [MMP.AsyncProxy]MMP.AsyncProxy.CancelToken MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<>3__cord'
		IL_0023: dup
		IL_0024: ldarg.s 'ret'
		IL_0026: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Deadline.CallResult> MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller/'<Attempts>d__3'::'<>3__ret'
		IL_002b: ret
	} // end of method WhenAnyCaller::Attempts

	.method public final hidebysig newslot virtual 
		instance void Dispose () cil managed 
	{
		// Method begins at RVA 0x3fae
		// Header size: 1
		// Code size: 1 (0x1)
		.maxstack 8

		IL_0000: ret
	} // end of method WhenAnyCaller::Dispose

	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x3fb0
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: call instance void [mscorlib]System.Object::.ctor()
		IL_0006: ret
	} // end of method WhenAnyCaller::.ctor

	// Properties
	.property instance string Version()
	{
		.get instance string MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller::get_Version()
	}

} // end of class MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Crunch.HeartbeatReport
	extends [mscorlib]System.Object
{
	// Fields
	.field private initonly int32 _beats
	.field private initonly int64 _worstLateMs
	.field private initonly float64 _averageLateMs

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			int32 beats,
			int64 worstLateMs,
			float64 averageLateMs
		) cil managed 
	{
		// Method begins at RVA 0x3fb8
		// Header size: 1
		// Code size: 28 (0x1c)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: call instance void [mscorlib]System.Object::.ctor()
		IL_0006: ldarg.0
		IL_0007: ldarg.1
		IL_0008: stfld int32 MMP.AsyncProxy.Training.Crunch.HeartbeatReport::_beats
		IL_000d: ldarg.0
		IL_000e: ldarg.2
		IL_000f: stfld int64 MMP.AsyncProxy.Training.Crunch.HeartbeatReport::_worstLateMs
		IL_0014: ldarg.0
		IL_0015: ldarg.3
		IL_0016: stfld float64 MMP.AsyncProxy.Training.Crunch.HeartbeatReport::_averageLateMs
		IL_001b: ret
	} // end of method HeartbeatReport::.ctor

	.method public hidebysig specialname 
		instance int32 get_Beats () cil managed 
	{
		// Method begins at RVA 0x3fd5
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld int32 MMP.AsyncProxy.Training.Crunch.HeartbeatReport::_beats
		IL_0006: ret
	} // end of method HeartbeatReport::get_Beats

	.method public hidebysig specialname 
		instance int64 get_WorstLateMs () cil managed 
	{
		// Method begins at RVA 0x3fdd
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld int64 MMP.AsyncProxy.Training.Crunch.HeartbeatReport::_worstLateMs
		IL_0006: ret
	} // end of method HeartbeatReport::get_WorstLateMs

	.method public hidebysig specialname 
		instance float64 get_AverageLateMs () cil managed 
	{
		// Method begins at RVA 0x3fe5
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld float64 MMP.AsyncProxy.Training.Crunch.HeartbeatReport::_averageLateMs
		IL_0006: ret
	} // end of method HeartbeatReport::get_AverageLateMs

	// Properties
	.property instance int32 Beats()
	{
		.get instance int32 MMP.AsyncProxy.Training.Crunch.HeartbeatReport::get_Beats()
	}
	.property instance int64 WorstLateMs()
	{
		.get instance int64 MMP.AsyncProxy.Training.Crunch.HeartbeatReport::get_WorstLateMs()
	}
	.property instance float64 AverageLateMs()
	{
		.get instance float64 MMP.AsyncProxy.Training.Crunch.HeartbeatReport::get_AverageLateMs()
	}

} // end of class MMP.AsyncProxy.Training.Crunch.HeartbeatReport

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Crunch.Heartbeat
	extends [mscorlib]System.Object
{
	// Nested Types
	.class nested private auto ansi sealed beforefieldinit '<Beat>d__10'
		extends [mscorlib]System.Object
		implements class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>,
		           [mscorlib]System.Collections.IEnumerable,
		           class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>,
		           [mscorlib]System.IDisposable,
		           [mscorlib]System.Collections.IEnumerator
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field private int32 '<>1__state'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture '<>2__current'
		.field private int32 '<>l__initialThreadId'
		.field public class MMP.AsyncProxy.Training.Crunch.Heartbeat '<>4__this'
		.field private class [System]System.Diagnostics.Stopwatch '<clock>5__2'
		.field private int64 '<last>5__3'

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor (
				int32 '<>1__state'
			) cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			// Method begins at RVA 0x59d8
			// Header size: 1
			// Code size: 30 (0x1e)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ldarg.0
			IL_0007: ldarg.1
			IL_0008: stfld int32 MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::'<>1__state'
			IL_000d: ldarg.0
			IL_000e: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0013: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_0018: stfld int32 MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::'<>l__initialThreadId'
			IL_001d: ret
		} // end of method '<Beat>d__10'::.ctor

		.method private final hidebysig newslot virtual 
			instance void System.IDisposable.Dispose () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [mscorlib]System.IDisposable::Dispose()
			// Method begins at RVA 0x59f7
			// Header size: 1
			// Code size: 16 (0x10)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldnull
			IL_0002: stfld class [System]System.Diagnostics.Stopwatch MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::'<clock>5__2'
			IL_0007: ldarg.0
			IL_0008: ldc.i4.s -2
			IL_000a: stfld int32 MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::'<>1__state'
			IL_000f: ret
		} // end of method '<Beat>d__10'::System.IDisposable.Dispose

		.method private final hidebysig newslot virtual 
			instance bool MoveNext () cil managed 
		{
			.override method instance bool [mscorlib]System.Collections.IEnumerator::MoveNext()
			// Method begins at RVA 0x5a08
			// Header size: 12
			// Code size: 223 (0xdf)
			.maxstack 3
			.locals init (
				[0] int32,
				[1] class MMP.AsyncProxy.Training.Crunch.Heartbeat,
				[2] int64,
				[3] int64,
				[4] object
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::'<>1__state'
			IL_0006: stloc.0
			IL_0007: ldarg.0
			IL_0008: ldfld class MMP.AsyncProxy.Training.Crunch.Heartbeat MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::'<>4__this'
			IL_000d: stloc.1
			IL_000e: ldloc.0
			IL_000f: brfalse.s IL_0017

			IL_0011: ldloc.0
			IL_0012: ldc.i4.1
			IL_0013: beq.s IL_0059

			IL_0015: ldc.i4.0
			IL_0016: ret

			IL_0017: ldarg.0
			IL_0018: ldc.i4.m1
			IL_0019: stfld int32 MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::'<>1__state'
			IL_001e: ldarg.0
			IL_001f: call class [System]System.Diagnostics.Stopwatch [System]System.Diagnostics.Stopwatch::StartNew()
			IL_0024: stfld class [System]System.Diagnostics.Stopwatch MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::'<clock>5__2'
			IL_0029: ldarg.0
			IL_002a: ldarg.0
			IL_002b: ldfld class [System]System.Diagnostics.Stopwatch MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::'<clock>5__2'
			IL_0030: callvirt instance int64 [System]System.Diagnostics.Stopwatch::get_ElapsedMilliseconds()
			IL_0035: stfld int64 MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::'<last>5__3'
			IL_003a: br IL_00d0

			IL_003f: ldarg.0
			IL_0040: ldloc.1
			IL_0041: ldfld int32 MMP.AsyncProxy.Training.Crunch.Heartbeat::_periodMs
			IL_0046: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture [MMP.AsyncProxy]MMP.AsyncProxy.Futures::Delay(int32)
			IL_004b: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::'<>2__current'
			IL_0050: ldarg.0
			IL_0051: ldc.i4.1
			IL_0052: stfld int32 MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::'<>1__state'
			IL_0057: ldc.i4.1
			IL_0058: ret

			IL_0059: ldarg.0
			IL_005a: ldc.i4.m1
			IL_005b: stfld int32 MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::'<>1__state'
			IL_0060: ldarg.0
			IL_0061: ldfld class [System]System.Diagnostics.Stopwatch MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::'<clock>5__2'
			IL_0066: callvirt instance int64 [System]System.Diagnostics.Stopwatch::get_ElapsedMilliseconds()
			IL_006b: stloc.2
			IL_006c: ldc.i4.0
			IL_006d: conv.i8
			IL_006e: ldloc.2
			IL_006f: ldarg.0
			IL_0070: ldfld int64 MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::'<last>5__3'
			IL_0075: sub
			IL_0076: ldloc.1
			IL_0077: ldfld int32 MMP.AsyncProxy.Training.Crunch.Heartbeat::_periodMs
			IL_007c: conv.i8
			IL_007d: sub
			IL_007e: call int64 [mscorlib]System.Math::Max(int64, int64)
			IL_0083: stloc.3
			IL_0084: ldarg.0
			IL_0085: ldloc.2
			IL_0086: stfld int64 MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::'<last>5__3'
			IL_008b: ldloc.1
			IL_008c: ldfld object MMP.AsyncProxy.Training.Crunch.Heartbeat::_gate
			IL_0091: stloc.s 4
			IL_0093: ldloc.s 4
			IL_0095: call void [mscorlib]System.Threading.Monitor::Enter(object)
			.try
			{
				IL_009a: ldloc.1
				IL_009b: ldloc.1
				IL_009c: ldfld int32 MMP.AsyncProxy.Training.Crunch.Heartbeat::_beats
				IL_00a1: ldc.i4.1
				IL_00a2: add
				IL_00a3: stfld int32 MMP.AsyncProxy.Training.Crunch.Heartbeat::_beats
				IL_00a8: ldloc.1
				IL_00a9: ldloc.1
				IL_00aa: ldfld int64 MMP.AsyncProxy.Training.Crunch.Heartbeat::_totalLate
				IL_00af: ldloc.3
				IL_00b0: add
				IL_00b1: stfld int64 MMP.AsyncProxy.Training.Crunch.Heartbeat::_totalLate
				IL_00b6: ldloc.3
				IL_00b7: ldloc.1
				IL_00b8: ldfld int64 MMP.AsyncProxy.Training.Crunch.Heartbeat::_worst
				IL_00bd: ble.s IL_00c6

				IL_00bf: ldloc.1
				IL_00c0: ldloc.3
				IL_00c1: stfld int64 MMP.AsyncProxy.Training.Crunch.Heartbeat::_worst

				IL_00c6: leave.s IL_00d0
			} // end .try
			finally
			{
				IL_00c8: ldloc.s 4
				IL_00ca: call void [mscorlib]System.Threading.Monitor::Exit(object)
				IL_00cf: endfinally
			} // end handler

			IL_00d0: ldloc.1
			IL_00d1: volatile.
			IL_00d3: ldfld bool modreq([mscorlib]System.Runtime.CompilerServices.IsVolatile) MMP.AsyncProxy.Training.Crunch.Heartbeat::_stop
			IL_00d8: brfalse IL_003f

			IL_00dd: ldc.i4.0
			IL_00de: ret
		} // end of method '<Beat>d__10'::MoveNext

		.method private final hidebysig specialname newslot virtual 
			instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance !0 class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::get_Current()
			// Method begins at RVA 0x5b04
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::'<>2__current'
			IL_0006: ret
		} // end of method '<Beat>d__10'::'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current'

		.method private final hidebysig newslot virtual 
			instance void System.Collections.IEnumerator.Reset () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [mscorlib]System.Collections.IEnumerator::Reset()
			// Method begins at RVA 0x5b0c
			// Header size: 1
			// Code size: 6 (0x6)
			.maxstack 8

			IL_0000: newobj instance void [mscorlib]System.NotSupportedException::.ctor()
			IL_0005: throw
		} // end of method '<Beat>d__10'::System.Collections.IEnumerator.Reset

		.method private final hidebysig specialname newslot virtual 
			instance object System.Collections.IEnumerator.get_Current () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance object [mscorlib]System.Collections.IEnumerator::get_Current()
			// Method begins at RVA 0x5b13
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::'<>2__current'
			IL_0006: ret
		} // end of method '<Beat>d__10'::System.Collections.IEnumerator.get_Current

		.method private final hidebysig newslot virtual 
			instance class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> 'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance class [mscorlib]System.Collections.Generic.IEnumerator`1<!0> class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::GetEnumerator()
			// Method begins at RVA 0x5b1c
			// Header size: 12
			// Code size: 60 (0x3c)
			.maxstack 2
			.locals init (
				[0] class MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::'<>1__state'
			IL_0006: ldc.i4.s -2
			IL_0008: bne.un.s IL_0027

			IL_000a: ldarg.0
			IL_000b: ldfld int32 MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::'<>l__initialThreadId'
			IL_0010: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0015: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_001a: bne.un.s IL_0027

			IL_001c: ldarg.0
			IL_001d: ldc.i4.0
			IL_001e: stfld int32 MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::'<>1__state'
			IL_0023: ldarg.0
			IL_0024: stloc.0
			IL_0025: br.s IL_003a

			IL_0027: ldc.i4.0
			IL_0028: newobj instance void MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::.ctor(int32)
			IL_002d: stloc.0
			IL_002e: ldloc.0
			IL_002f: ldarg.0
			IL_0030: ldfld class MMP.AsyncProxy.Training.Crunch.Heartbeat MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::'<>4__this'
			IL_0035: stfld class MMP.AsyncProxy.Training.Crunch.Heartbeat MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::'<>4__this'

			IL_003a: ldloc.0
			IL_003b: ret
		} // end of method '<Beat>d__10'::'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator'

		.method private final hidebysig newslot virtual 
			instance class [mscorlib]System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance class [mscorlib]System.Collections.IEnumerator [mscorlib]System.Collections.IEnumerable::GetEnumerator()
			// Method begins at RVA 0x5b64
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator'()
			IL_0006: ret
		} // end of method '<Beat>d__10'::System.Collections.IEnumerable.GetEnumerator

		// Properties
		.property instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.Current'()
		{
			.get instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current'()
		}
		.property instance object System.Collections.IEnumerator.Current()
		{
			.get instance object MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::System.Collections.IEnumerator.get_Current()
		}

	} // end of class <Beat>d__10


	// Fields
	.field private initonly int32 _periodMs
	.field private initonly object _gate
	.field private bool modreq([mscorlib]System.Runtime.CompilerServices.IsVolatile) _stop
	.field private int32 _beats
	.field private int64 _worst
	.field private int64 _totalLate
	.field private class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture _loop

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			int32 periodMs
		) cil managed 
	{
		// Method begins at RVA 0x3fed
		// Header size: 1
		// Code size: 25 (0x19)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: newobj instance void [mscorlib]System.Object::.ctor()
		IL_0006: stfld object MMP.AsyncProxy.Training.Crunch.Heartbeat::_gate
		IL_000b: ldarg.0
		IL_000c: call instance void [mscorlib]System.Object::.ctor()
		IL_0011: ldarg.0
		IL_0012: ldarg.1
		IL_0013: stfld int32 MMP.AsyncProxy.Training.Crunch.Heartbeat::_periodMs
		IL_0018: ret
	} // end of method Heartbeat::.ctor

	.method public hidebysig 
		instance void Start () cil managed 
	{
		// Method begins at RVA 0x4007
		// Header size: 1
		// Code size: 18 (0x12)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldarg.0
		IL_0002: call instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Crunch.Heartbeat::Beat()
		IL_0007: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture [MMP.AsyncProxy]MMP.AsyncProxy.AsyncProxy::Run(class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>)
		IL_000c: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Crunch.Heartbeat::_loop
		IL_0011: ret
	} // end of method Heartbeat::Start

	.method public hidebysig 
		instance class MMP.AsyncProxy.Training.Crunch.HeartbeatReport Stop () cil managed 
	{
		// Method begins at RVA 0x401c
		// Header size: 12
		// Code size: 98 (0x62)
		.maxstack 3
		.locals init (
			[0] object,
			[1] float64,
			[2] class MMP.AsyncProxy.Training.Crunch.HeartbeatReport
		)

		IL_0000: ldarg.0
		IL_0001: ldc.i4.1
		IL_0002: volatile.
		IL_0004: stfld bool modreq([mscorlib]System.Runtime.CompilerServices.IsVolatile) MMP.AsyncProxy.Training.Crunch.Heartbeat::_stop
		IL_0009: ldarg.0
		IL_000a: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Crunch.Heartbeat::_loop
		IL_000f: callvirt instance void [MMP.AsyncProxy]MMP.AsyncProxy.IFuture::Wait()
		IL_0014: ldarg.0
		IL_0015: ldfld object MMP.AsyncProxy.Training.Crunch.Heartbeat::_gate
		IL_001a: stloc.0
		IL_001b: ldloc.0
		IL_001c: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_0021: ldarg.0
			IL_0022: ldfld int32 MMP.AsyncProxy.Training.Crunch.Heartbeat::_beats
			IL_0027: brfalse.s IL_003a

			IL_0029: ldarg.0
			IL_002a: ldfld int64 MMP.AsyncProxy.Training.Crunch.Heartbeat::_totalLate
			IL_002f: conv.r8
			IL_0030: ldarg.0
			IL_0031: ldfld int32 MMP.AsyncProxy.Training.Crunch.Heartbeat::_beats
			IL_0036: conv.r8
			IL_0037: div
			IL_0038: br.s IL_0043

			IL_003a: ldc.r8 0.0

			IL_0043: stloc.1
			IL_0044: ldarg.0
			IL_0045: ldfld int32 MMP.AsyncProxy.Training.Crunch.Heartbeat::_beats
			IL_004a: ldarg.0
			IL_004b: ldfld int64 MMP.AsyncProxy.Training.Crunch.Heartbeat::_worst
			IL_0050: ldloc.1
			IL_0051: newobj instance void MMP.AsyncProxy.Training.Crunch.HeartbeatReport::.ctor(int32, int64, float64)
			IL_0056: stloc.2
			IL_0057: leave.s IL_0060
		} // end .try
		finally
		{
			IL_0059: ldloc.0
			IL_005a: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_005f: endfinally
		} // end handler

		IL_0060: ldloc.2
		IL_0061: ret
	} // end of method Heartbeat::Stop

	.method private hidebysig 
		instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> Beat () cil managed 
	{
		// Method begins at RVA 0x409c
		// Header size: 1
		// Code size: 15 (0xf)
		.maxstack 8

		IL_0000: ldc.i4.s -2
		IL_0002: newobj instance void MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::.ctor(int32)
		IL_0007: dup
		IL_0008: ldarg.0
		IL_0009: stfld class MMP.AsyncProxy.Training.Crunch.Heartbeat MMP.AsyncProxy.Training.Crunch.Heartbeat/'<Beat>d__10'::'<>4__this'
		IL_000e: ret
	} // end of method Heartbeat::Beat

} // end of class MMP.AsyncProxy.Training.Crunch.Heartbeat

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Crunch.SaleRecord
	extends [mscorlib]System.Object
{
	// Fields
	.field private initonly int32 _id
	.field private initonly int32 _cents
	.field private initonly int32 _grade

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			int32 id,
			int32 cents,
			int32 grade
		) cil managed 
	{
		// Method begins at RVA 0x40ac
		// Header size: 1
		// Code size: 28 (0x1c)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: call instance void [mscorlib]System.Object::.ctor()
		IL_0006: ldarg.0
		IL_0007: ldarg.1
		IL_0008: stfld int32 MMP.AsyncProxy.Training.Crunch.SaleRecord::_id
		IL_000d: ldarg.0
		IL_000e: ldarg.2
		IL_000f: stfld int32 MMP.AsyncProxy.Training.Crunch.SaleRecord::_cents
		IL_0014: ldarg.0
		IL_0015: ldarg.3
		IL_0016: stfld int32 MMP.AsyncProxy.Training.Crunch.SaleRecord::_grade
		IL_001b: ret
	} // end of method SaleRecord::.ctor

	.method public hidebysig specialname 
		instance int32 get_Id () cil managed 
	{
		// Method begins at RVA 0x40c9
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld int32 MMP.AsyncProxy.Training.Crunch.SaleRecord::_id
		IL_0006: ret
	} // end of method SaleRecord::get_Id

	.method public hidebysig specialname 
		instance int32 get_Cents () cil managed 
	{
		// Method begins at RVA 0x40d1
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld int32 MMP.AsyncProxy.Training.Crunch.SaleRecord::_cents
		IL_0006: ret
	} // end of method SaleRecord::get_Cents

	.method public hidebysig specialname 
		instance int32 get_Grade () cil managed 
	{
		// Method begins at RVA 0x40d9
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld int32 MMP.AsyncProxy.Training.Crunch.SaleRecord::_grade
		IL_0006: ret
	} // end of method SaleRecord::get_Grade

	// Properties
	.property instance int32 Id()
	{
		.get instance int32 MMP.AsyncProxy.Training.Crunch.SaleRecord::get_Id()
	}
	.property instance int32 Cents()
	{
		.get instance int32 MMP.AsyncProxy.Training.Crunch.SaleRecord::get_Cents()
	}
	.property instance int32 Grade()
	{
		.get instance int32 MMP.AsyncProxy.Training.Crunch.SaleRecord::get_Grade()
	}

} // end of class MMP.AsyncProxy.Training.Crunch.SaleRecord

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Crunch.Settlement
	extends [mscorlib]System.Object
{
	// Fields
	.field private initonly int32 _count
	.field private initonly int64 _totalCents
	.field private initonly int64[] _centsByGrade
	.field private initonly uint64 _checksum
	.field private initonly int32 _threadsUsed
	.field private initonly bool _ranOnPoolThreads

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			int32 count,
			int64 totalCents,
			int64[] centsByGrade,
			uint64 checksum,
			int32 threadsUsed,
			bool ranOnPoolThreads
		) cil managed 
	{
		// Method begins at RVA 0x40e1
		// Header size: 1
		// Code size: 52 (0x34)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: call instance void [mscorlib]System.Object::.ctor()
		IL_0006: ldarg.0
		IL_0007: ldarg.1
		IL_0008: stfld int32 MMP.AsyncProxy.Training.Crunch.Settlement::_count
		IL_000d: ldarg.0
		IL_000e: ldarg.2
		IL_000f: stfld int64 MMP.AsyncProxy.Training.Crunch.Settlement::_totalCents
		IL_0014: ldarg.0
		IL_0015: ldarg.3
		IL_0016: stfld int64[] MMP.AsyncProxy.Training.Crunch.Settlement::_centsByGrade
		IL_001b: ldarg.0
		IL_001c: ldarg.s checksum
		IL_001e: stfld uint64 MMP.AsyncProxy.Training.Crunch.Settlement::_checksum
		IL_0023: ldarg.0
		IL_0024: ldarg.s threadsUsed
		IL_0026: stfld int32 MMP.AsyncProxy.Training.Crunch.Settlement::_threadsUsed
		IL_002b: ldarg.0
		IL_002c: ldarg.s ranOnPoolThreads
		IL_002e: stfld bool MMP.AsyncProxy.Training.Crunch.Settlement::_ranOnPoolThreads
		IL_0033: ret
	} // end of method Settlement::.ctor

	.method public hidebysig specialname 
		instance int32 get_Count () cil managed 
	{
		// Method begins at RVA 0x4116
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld int32 MMP.AsyncProxy.Training.Crunch.Settlement::_count
		IL_0006: ret
	} // end of method Settlement::get_Count

	.method public hidebysig specialname 
		instance int64 get_TotalCents () cil managed 
	{
		// Method begins at RVA 0x411e
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld int64 MMP.AsyncProxy.Training.Crunch.Settlement::_totalCents
		IL_0006: ret
	} // end of method Settlement::get_TotalCents

	.method public hidebysig specialname 
		instance int64[] get_CentsByGrade () cil managed 
	{
		// Method begins at RVA 0x4126
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld int64[] MMP.AsyncProxy.Training.Crunch.Settlement::_centsByGrade
		IL_0006: ret
	} // end of method Settlement::get_CentsByGrade

	.method public hidebysig specialname 
		instance uint64 get_Checksum () cil managed 
	{
		// Method begins at RVA 0x412e
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld uint64 MMP.AsyncProxy.Training.Crunch.Settlement::_checksum
		IL_0006: ret
	} // end of method Settlement::get_Checksum

	.method public hidebysig specialname 
		instance int32 get_ThreadsUsed () cil managed 
	{
		// Method begins at RVA 0x4136
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld int32 MMP.AsyncProxy.Training.Crunch.Settlement::_threadsUsed
		IL_0006: ret
	} // end of method Settlement::get_ThreadsUsed

	.method public hidebysig specialname 
		instance bool get_RanOnPoolThreads () cil managed 
	{
		// Method begins at RVA 0x413e
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld bool MMP.AsyncProxy.Training.Crunch.Settlement::_ranOnPoolThreads
		IL_0006: ret
	} // end of method Settlement::get_RanOnPoolThreads

	.method public hidebysig 
		instance bool SameAnswerAs (
			class MMP.AsyncProxy.Training.Crunch.Settlement other
		) cil managed 
	{
		// Method begins at RVA 0x4148
		// Header size: 12
		// Code size: 85 (0x55)
		.maxstack 3
		.locals init (
			[0] int32
		)

		IL_0000: ldarg.0
		IL_0001: ldfld int32 MMP.AsyncProxy.Training.Crunch.Settlement::_count
		IL_0006: ldarg.1
		IL_0007: ldfld int32 MMP.AsyncProxy.Training.Crunch.Settlement::_count
		IL_000c: bne.un.s IL_002a

		IL_000e: ldarg.0
		IL_000f: ldfld int64 MMP.AsyncProxy.Training.Crunch.Settlement::_totalCents
		IL_0014: ldarg.1
		IL_0015: ldfld int64 MMP.AsyncProxy.Training.Crunch.Settlement::_totalCents
		IL_001a: bne.un.s IL_002a

		IL_001c: ldarg.0
		IL_001d: ldfld uint64 MMP.AsyncProxy.Training.Crunch.Settlement::_checksum
		IL_0022: ldarg.1
		IL_0023: ldfld uint64 MMP.AsyncProxy.Training.Crunch.Settlement::_checksum
		IL_0028: beq.s IL_002c

		IL_002a: ldc.i4.0
		IL_002b: ret

		IL_002c: ldc.i4.0
		IL_002d: stloc.0
		IL_002e: br.s IL_0048
		// loop start (head: IL_0048)
			IL_0030: ldarg.0
			IL_0031: ldfld int64[] MMP.AsyncProxy.Training.Crunch.Settlement::_centsByGrade
			IL_0036: ldloc.0
			IL_0037: ldelem.i8
			IL_0038: ldarg.1
			IL_0039: ldfld int64[] MMP.AsyncProxy.Training.Crunch.Settlement::_centsByGrade
			IL_003e: ldloc.0
			IL_003f: ldelem.i8
			IL_0040: beq.s IL_0044

			IL_0042: ldc.i4.0
			IL_0043: ret

			IL_0044: ldloc.0
			IL_0045: ldc.i4.1
			IL_0046: add
			IL_0047: stloc.0

			IL_0048: ldloc.0
			IL_0049: ldarg.0
			IL_004a: ldfld int64[] MMP.AsyncProxy.Training.Crunch.Settlement::_centsByGrade
			IL_004f: ldlen
			IL_0050: conv.i4
			IL_0051: blt.s IL_0030
		// end loop

		IL_0053: ldc.i4.1
		IL_0054: ret
	} // end of method Settlement::SameAnswerAs

	// Properties
	.property instance int32 Count()
	{
		.get instance int32 MMP.AsyncProxy.Training.Crunch.Settlement::get_Count()
	}
	.property instance int64 TotalCents()
	{
		.get instance int64 MMP.AsyncProxy.Training.Crunch.Settlement::get_TotalCents()
	}
	.property instance int64[] CentsByGrade()
	{
		.get instance int64[] MMP.AsyncProxy.Training.Crunch.Settlement::get_CentsByGrade()
	}
	.property instance uint64 Checksum()
	{
		.get instance uint64 MMP.AsyncProxy.Training.Crunch.Settlement::get_Checksum()
	}
	.property instance int32 ThreadsUsed()
	{
		.get instance int32 MMP.AsyncProxy.Training.Crunch.Settlement::get_ThreadsUsed()
	}
	.property instance bool RanOnPoolThreads()
	{
		.get instance bool MMP.AsyncProxy.Training.Crunch.Settlement::get_RanOnPoolThreads()
	}

} // end of class MMP.AsyncProxy.Training.Crunch.Settlement

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Crunch.Tally
	extends [mscorlib]System.Object
{
	// Fields
	.field private int32 _count
	.field private int64 _totalCents
	.field private initonly int64[] _centsByGrade
	.field private uint64 _checksum
	.field private initonly class [mscorlib]System.Collections.Generic.Dictionary`2<int32, bool> _threads
	.field private bool _ranOnPool

	// Methods
	.method public hidebysig 
		instance void Add (
			class MMP.AsyncProxy.Training.Crunch.SaleRecord sale,
			uint64 seal
		) cil managed 
	{
		// Method begins at RVA 0x41ac
		// Header size: 12
		// Code size: 116 (0x74)
		.maxstack 3
		.locals init (
			[0] class [mscorlib]System.Threading.Thread
		)

		IL_0000: ldarg.0
		IL_0001: ldarg.0
		IL_0002: ldfld int32 MMP.AsyncProxy.Training.Crunch.Tally::_count
		IL_0007: ldc.i4.1
		IL_0008: add
		IL_0009: stfld int32 MMP.AsyncProxy.Training.Crunch.Tally::_count
		IL_000e: ldarg.0
		IL_000f: ldarg.0
		IL_0010: ldfld int64 MMP.AsyncProxy.Training.Crunch.Tally::_totalCents
		IL_0015: ldarg.1
		IL_0016: callvirt instance int32 MMP.AsyncProxy.Training.Crunch.SaleRecord::get_Cents()
		IL_001b: conv.i8
		IL_001c: add
		IL_001d: stfld int64 MMP.AsyncProxy.Training.Crunch.Tally::_totalCents
		IL_0022: ldarg.0
		IL_0023: ldfld int64[] MMP.AsyncProxy.Training.Crunch.Tally::_centsByGrade
		IL_0028: ldarg.1
		IL_0029: callvirt instance int32 MMP.AsyncProxy.Training.Crunch.SaleRecord::get_Grade()
		IL_002e: ldelema [mscorlib]System.Int64
		IL_0033: dup
		IL_0034: ldind.i8
		IL_0035: ldarg.1
		IL_0036: callvirt instance int32 MMP.AsyncProxy.Training.Crunch.SaleRecord::get_Cents()
		IL_003b: conv.i8
		IL_003c: add
		IL_003d: stind.i8
		IL_003e: ldarg.0
		IL_003f: ldarg.0
		IL_0040: ldfld uint64 MMP.AsyncProxy.Training.Crunch.Tally::_checksum
		IL_0045: ldarg.2
		IL_0046: xor
		IL_0047: stfld uint64 MMP.AsyncProxy.Training.Crunch.Tally::_checksum
		IL_004c: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
		IL_0051: stloc.0
		IL_0052: ldarg.0
		IL_0053: ldfld class [mscorlib]System.Collections.Generic.Dictionary`2<int32, bool> MMP.AsyncProxy.Training.Crunch.Tally::_threads
		IL_0058: ldloc.0
		IL_0059: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
		IL_005e: ldc.i4.1
		IL_005f: callvirt instance void class [mscorlib]System.Collections.Generic.Dictionary`2<int32, bool>::set_Item(!0, !1)
		IL_0064: ldloc.0
		IL_0065: callvirt instance bool [mscorlib]System.Threading.Thread::get_IsThreadPoolThread()
		IL_006a: brfalse.s IL_0073

		IL_006c: ldarg.0
		IL_006d: ldc.i4.1
		IL_006e: stfld bool MMP.AsyncProxy.Training.Crunch.Tally::_ranOnPool

		IL_0073: ret
	} // end of method Tally::Add

	.method public hidebysig 
		instance void Merge (
			class MMP.AsyncProxy.Training.Crunch.Tally other
		) cil managed 
	{
		// Method begins at RVA 0x422c
		// Header size: 12
		// Code size: 181 (0xb5)
		.maxstack 4
		.locals init (
			[0] int32,
			[1] valuetype [mscorlib]System.Collections.Generic.Dictionary`2/KeyCollection/Enumerator<int32, bool>,
			[2] int32
		)

		IL_0000: ldarg.0
		IL_0001: ldarg.0
		IL_0002: ldfld int32 MMP.AsyncProxy.Training.Crunch.Tally::_count
		IL_0007: ldarg.1
		IL_0008: ldfld int32 MMP.AsyncProxy.Training.Crunch.Tally::_count
		IL_000d: add
		IL_000e: stfld int32 MMP.AsyncProxy.Training.Crunch.Tally::_count
		IL_0013: ldarg.0
		IL_0014: ldarg.0
		IL_0015: ldfld int64 MMP.AsyncProxy.Training.Crunch.Tally::_totalCents
		IL_001a: ldarg.1
		IL_001b: ldfld int64 MMP.AsyncProxy.Training.Crunch.Tally::_totalCents
		IL_0020: add
		IL_0021: stfld int64 MMP.AsyncProxy.Training.Crunch.Tally::_totalCents
		IL_0026: ldc.i4.0
		IL_0027: stloc.0
		IL_0028: br.s IL_0046
		// loop start (head: IL_0046)
			IL_002a: ldarg.0
			IL_002b: ldfld int64[] MMP.AsyncProxy.Training.Crunch.Tally::_centsByGrade
			IL_0030: ldloc.0
			IL_0031: ldelema [mscorlib]System.Int64
			IL_0036: dup
			IL_0037: ldind.i8
			IL_0038: ldarg.1
			IL_0039: ldfld int64[] MMP.AsyncProxy.Training.Crunch.Tally::_centsByGrade
			IL_003e: ldloc.0
			IL_003f: ldelem.i8
			IL_0040: add
			IL_0041: stind.i8
			IL_0042: ldloc.0
			IL_0043: ldc.i4.1
			IL_0044: add
			IL_0045: stloc.0

			IL_0046: ldloc.0
			IL_0047: ldarg.0
			IL_0048: ldfld int64[] MMP.AsyncProxy.Training.Crunch.Tally::_centsByGrade
			IL_004d: ldlen
			IL_004e: conv.i4
			IL_004f: blt.s IL_002a
		// end loop

		IL_0051: ldarg.0
		IL_0052: ldarg.0
		IL_0053: ldfld uint64 MMP.AsyncProxy.Training.Crunch.Tally::_checksum
		IL_0058: ldarg.1
		IL_0059: ldfld uint64 MMP.AsyncProxy.Training.Crunch.Tally::_checksum
		IL_005e: xor
		IL_005f: stfld uint64 MMP.AsyncProxy.Training.Crunch.Tally::_checksum
		IL_0064: ldarg.1
		IL_0065: ldfld class [mscorlib]System.Collections.Generic.Dictionary`2<int32, bool> MMP.AsyncProxy.Training.Crunch.Tally::_threads
		IL_006a: callvirt instance class [mscorlib]System.Collections.Generic.Dictionary`2/KeyCollection<!0, !1> class [mscorlib]System.Collections.Generic.Dictionary`2<int32, bool>::get_Keys()
		IL_006f: callvirt instance valuetype [mscorlib]System.Collections.Generic.Dictionary`2/KeyCollection/Enumerator<!0, !1> class [mscorlib]System.Collections.Generic.Dictionary`2/KeyCollection<int32, bool>::GetEnumerator()
		IL_0074: stloc.1
		.try
		{
			IL_0075: br.s IL_008c
			// loop start (head: IL_008c)
				IL_0077: ldloca.s 1
				IL_0079: call instance !0 valuetype [mscorlib]System.Collections.Generic.Dictionary`2/KeyCollection/Enumerator<int32, bool>::get_Current()
				IL_007e: stloc.2
				IL_007f: ldarg.0
				IL_0080: ldfld class [mscorlib]System.Collections.Generic.Dictionary`2<int32, bool> MMP.AsyncProxy.Training.Crunch.Tally::_threads
				IL_0085: ldloc.2
				IL_0086: ldc.i4.1
				IL_0087: callvirt instance void class [mscorlib]System.Collections.Generic.Dictionary`2<int32, bool>::set_Item(!0, !1)

				IL_008c: ldloca.s 1
				IL_008e: call instance bool valuetype [mscorlib]System.Collections.Generic.Dictionary`2/KeyCollection/Enumerator<int32, bool>::MoveNext()
				IL_0093: brtrue.s IL_0077
			// end loop

			IL_0095: leave.s IL_00a5
		} // end .try
		finally
		{
			IL_0097: ldloca.s 1
			IL_0099: constrained. valuetype [mscorlib]System.Collections.Generic.Dictionary`2/KeyCollection/Enumerator<int32, bool>
			IL_009f: callvirt instance void [mscorlib]System.IDisposable::Dispose()
			IL_00a4: endfinally
		} // end handler

		IL_00a5: ldarg.1
		IL_00a6: ldfld bool MMP.AsyncProxy.Training.Crunch.Tally::_ranOnPool
		IL_00ab: brfalse.s IL_00b4

		IL_00ad: ldarg.0
		IL_00ae: ldc.i4.1
		IL_00af: stfld bool MMP.AsyncProxy.Training.Crunch.Tally::_ranOnPool

		IL_00b4: ret
	} // end of method Tally::Merge

	.method public hidebysig 
		instance class MMP.AsyncProxy.Training.Crunch.Settlement ToSettlement () cil managed 
	{
		// Method begins at RVA 0x4300
		// Header size: 1
		// Code size: 57 (0x39)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld int32 MMP.AsyncProxy.Training.Crunch.Tally::_count
		IL_0006: ldarg.0
		IL_0007: ldfld int64 MMP.AsyncProxy.Training.Crunch.Tally::_totalCents
		IL_000c: ldarg.0
		IL_000d: ldfld int64[] MMP.AsyncProxy.Training.Crunch.Tally::_centsByGrade
		IL_0012: callvirt instance object [mscorlib]System.Array::Clone()
		IL_0017: castclass int64[]
		IL_001c: ldarg.0
		IL_001d: ldfld uint64 MMP.AsyncProxy.Training.Crunch.Tally::_checksum
		IL_0022: ldarg.0
		IL_0023: ldfld class [mscorlib]System.Collections.Generic.Dictionary`2<int32, bool> MMP.AsyncProxy.Training.Crunch.Tally::_threads
		IL_0028: callvirt instance int32 class [mscorlib]System.Collections.Generic.Dictionary`2<int32, bool>::get_Count()
		IL_002d: ldarg.0
		IL_002e: ldfld bool MMP.AsyncProxy.Training.Crunch.Tally::_ranOnPool
		IL_0033: newobj instance void MMP.AsyncProxy.Training.Crunch.Settlement::.ctor(int32, int64, int64[], uint64, int32, bool)
		IL_0038: ret
	} // end of method Tally::ToSettlement

	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x433a
		// Header size: 1
		// Code size: 30 (0x1e)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldc.i4.3
		IL_0002: newarr [mscorlib]System.Int64
		IL_0007: stfld int64[] MMP.AsyncProxy.Training.Crunch.Tally::_centsByGrade
		IL_000c: ldarg.0
		IL_000d: newobj instance void class [mscorlib]System.Collections.Generic.Dictionary`2<int32, bool>::.ctor()
		IL_0012: stfld class [mscorlib]System.Collections.Generic.Dictionary`2<int32, bool> MMP.AsyncProxy.Training.Crunch.Tally::_threads
		IL_0017: ldarg.0
		IL_0018: call instance void [mscorlib]System.Object::.ctor()
		IL_001d: ret
	} // end of method Tally::.ctor

} // end of class MMP.AsyncProxy.Training.Crunch.Tally

.class public auto ansi abstract sealed beforefieldinit MMP.AsyncProxy.Training.Crunch.Ledger
	extends [mscorlib]System.Object
{
	// Methods
	.method public hidebysig static 
		class MMP.AsyncProxy.Training.Crunch.SaleRecord[] Day (
			int32 count
		) cil managed 
	{
		// Method begins at RVA 0x435c
		// Header size: 12
		// Code size: 49 (0x31)
		.maxstack 6
		.locals init (
			[0] class MMP.AsyncProxy.Training.Crunch.SaleRecord[],
			[1] int32
		)

		IL_0000: ldarg.0
		IL_0001: newarr MMP.AsyncProxy.Training.Crunch.SaleRecord
		IL_0006: stloc.0
		IL_0007: ldc.i4.0
		IL_0008: stloc.1
		IL_0009: br.s IL_002b
		// loop start (head: IL_002b)
			IL_000b: ldloc.0
			IL_000c: ldloc.1
			IL_000d: ldloc.1
			IL_000e: ldc.i4 500
			IL_0013: ldloc.1
			IL_0014: ldc.i4.s 37
			IL_0016: mul
			IL_0017: ldc.i4 9500
			IL_001c: rem
			IL_001d: add
			IL_001e: ldloc.1
			IL_001f: ldc.i4.3
			IL_0020: rem
			IL_0021: newobj instance void MMP.AsyncProxy.Training.Crunch.SaleRecord::.ctor(int32, int32, int32)
			IL_0026: stelem.ref
			IL_0027: ldloc.1
			IL_0028: ldc.i4.1
			IL_0029: add
			IL_002a: stloc.1

			IL_002b: ldloc.1
			IL_002c: ldarg.0
			IL_002d: blt.s IL_000b
		// end loop

		IL_002f: ldloc.0
		IL_0030: ret
	} // end of method Ledger::Day

	.method public hidebysig static 
		uint64 Seal (
			class [mscorlib]System.Security.Cryptography.SHA256 sha,
			class MMP.AsyncProxy.Training.Crunch.SaleRecord sale,
			int32 rounds
		) cil managed 
	{
		// Method begins at RVA 0x439c
		// Header size: 12
		// Code size: 72 (0x48)
		.maxstack 3
		.locals init (
			[0] uint8[],
			[1] int32
		)

		IL_0000: ldc.i4.s 32
		IL_0002: newarr [mscorlib]System.Byte
		IL_0007: stloc.0
		IL_0008: ldarg.1
		IL_0009: callvirt instance int32 MMP.AsyncProxy.Training.Crunch.SaleRecord::get_Id()
		IL_000e: call uint8[] [mscorlib]System.BitConverter::GetBytes(int32)
		IL_0013: ldloc.0
		IL_0014: ldc.i4.0
		IL_0015: callvirt instance void [mscorlib]System.Array::CopyTo(class [mscorlib]System.Array, int32)
		IL_001a: ldarg.1
		IL_001b: callvirt instance int32 MMP.AsyncProxy.Training.Crunch.SaleRecord::get_Cents()
		IL_0020: call uint8[] [mscorlib]System.BitConverter::GetBytes(int32)
		IL_0025: ldloc.0
		IL_0026: ldc.i4.4
		IL_0027: callvirt instance void [mscorlib]System.Array::CopyTo(class [mscorlib]System.Array, int32)
		IL_002c: ldc.i4.0
		IL_002d: stloc.1
		IL_002e: br.s IL_003c
		// loop start (head: IL_003c)
			IL_0030: ldarg.0
			IL_0031: ldloc.0
			IL_0032: callvirt instance uint8[] [mscorlib]System.Security.Cryptography.HashAlgorithm::ComputeHash(uint8[])
			IL_0037: stloc.0
			IL_0038: ldloc.1
			IL_0039: ldc.i4.1
			IL_003a: add
			IL_003b: stloc.1

			IL_003c: ldloc.1
			IL_003d: ldarg.2
			IL_003e: blt.s IL_0030
		// end loop

		IL_0040: ldloc.0
		IL_0041: ldc.i4.0
		IL_0042: call uint64 [mscorlib]System.BitConverter::ToUInt64(uint8[], int32)
		IL_0047: ret
	} // end of method Ledger::Seal

	.method public hidebysig static 
		class MMP.AsyncProxy.Training.Crunch.Tally SealRange (
			class MMP.AsyncProxy.Training.Crunch.SaleRecord[] sales,
			int32 from,
			int32 'to',
			int32 stride,
			int32 rounds
		) cil managed 
	{
		// Method begins at RVA 0x43f0
		// Header size: 12
		// Code size: 58 (0x3a)
		.maxstack 5
		.locals init (
			[0] class MMP.AsyncProxy.Training.Crunch.Tally,
			[1] class [mscorlib]System.Security.Cryptography.SHA256,
			[2] int32
		)

		IL_0000: newobj instance void MMP.AsyncProxy.Training.Crunch.Tally::.ctor()
		IL_0005: stloc.0
		IL_0006: call class [mscorlib]System.Security.Cryptography.SHA256 [mscorlib]System.Security.Cryptography.SHA256::Create()
		IL_000b: stloc.1
		.try
		{
			IL_000c: ldarg.1
			IL_000d: stloc.2
			IL_000e: br.s IL_0028
			// loop start (head: IL_0028)
				IL_0010: ldloc.0
				IL_0011: ldarg.0
				IL_0012: ldloc.2
				IL_0013: ldelem.ref
				IL_0014: ldloc.1
				IL_0015: ldarg.0
				IL_0016: ldloc.2
				IL_0017: ldelem.ref
				IL_0018: ldarg.s rounds
				IL_001a: call uint64 MMP.AsyncProxy.Training.Crunch.Ledger::Seal(class [mscorlib]System.Security.Cryptography.SHA256, class MMP.AsyncProxy.Training.Crunch.SaleRecord, int32)
				IL_001f: callvirt instance void MMP.AsyncProxy.Training.Crunch.Tally::Add(class MMP.AsyncProxy.Training.Crunch.SaleRecord, uint64)
				IL_0024: ldloc.2
				IL_0025: ldarg.3
				IL_0026: add
				IL_0027: stloc.2

				IL_0028: ldloc.2
				IL_0029: ldarg.2
				IL_002a: blt.s IL_0010
			// end loop

			IL_002c: leave.s IL_0038
		} // end .try
		finally
		{
			IL_002e: ldloc.1
			IL_002f: brfalse.s IL_0037

			IL_0031: ldloc.1
			IL_0032: callvirt instance void [mscorlib]System.IDisposable::Dispose()

			IL_0037: endfinally
		} // end handler

		IL_0038: ldloc.0
		IL_0039: ret
	} // end of method Ledger::SealRange

	.method public hidebysig static 
		class MMP.AsyncProxy.Training.Crunch.Settlement InOneLoop (
			class MMP.AsyncProxy.Training.Crunch.SaleRecord[] sales,
			int32 rounds
		) cil managed 
	{
		// Method begins at RVA 0x4448
		// Header size: 1
		// Code size: 18 (0x12)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldc.i4.0
		IL_0002: ldarg.0
		IL_0003: ldlen
		IL_0004: conv.i4
		IL_0005: ldc.i4.1
		IL_0006: ldarg.1
		IL_0007: call class MMP.AsyncProxy.Training.Crunch.Tally MMP.AsyncProxy.Training.Crunch.Ledger::SealRange(class MMP.AsyncProxy.Training.Crunch.SaleRecord[], int32, int32, int32, int32)
		IL_000c: callvirt instance class MMP.AsyncProxy.Training.Crunch.Settlement MMP.AsyncProxy.Training.Crunch.Tally::ToSettlement()
		IL_0011: ret
	} // end of method Ledger::InOneLoop

} // end of class MMP.AsyncProxy.Training.Crunch.Ledger

.class interface public auto ansi abstract beforefieldinit MMP.AsyncProxy.Training.Crunch.ISettler
	implements [mscorlib]System.IDisposable
{
	// Methods
	.method public hidebysig specialname newslot abstract virtual 
		instance string get_Version () cil managed 
	{
	} // end of method ISettler::get_Version

	.method public hidebysig newslot abstract virtual 
		instance class MMP.AsyncProxy.Training.Crunch.Settlement Settle (
			class MMP.AsyncProxy.Training.Crunch.SaleRecord[] sales,
			int32 rounds
		) cil managed 
	{
	} // end of method ISettler::Settle

	// Properties
	.property instance string Version()
	{
		.get instance string MMP.AsyncProxy.Training.Crunch.ISettler::get_Version()
	}

} // end of class MMP.AsyncProxy.Training.Crunch.ISettler

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler
	extends [mscorlib]System.Object
	implements MMP.AsyncProxy.Training.Crunch.ISettler,
	           [mscorlib]System.IDisposable
{
	// Nested Types
	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass7_0'
		extends [mscorlib]System.Object
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field public class MMP.AsyncProxy.Training.Crunch.Tally[] parts
		.field public class MMP.AsyncProxy.Training.Crunch.SaleRecord[] sales
		.field public class MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler '<>4__this'
		.field public int32 rounds

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor () cil managed 
		{
			// Method begins at RVA 0x5b6c
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass7_0'::.ctor

	} // end of class <>c__DisplayClass7_0

	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass7_1'
		extends [mscorlib]System.Object
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field public int32 me
		.field public class MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_0' 'CS$<>8__locals1'

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor () cil managed 
		{
			// Method begins at RVA 0x5b74
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass7_1'::.ctor

		.method assembly hidebysig 
			instance void '<Settle>b__0' () cil managed 
		{
			// Method begins at RVA 0x5b7c
			// Header size: 12
			// Code size: 81 (0x51)
			.maxstack 7

			IL_0000: ldarg.0
			IL_0001: ldfld class MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_0' MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_1'::'CS$<>8__locals1'
			IL_0006: ldfld class MMP.AsyncProxy.Training.Crunch.Tally[] MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_0'::parts
			IL_000b: ldarg.0
			IL_000c: ldfld int32 MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_1'::me
			IL_0011: ldarg.0
			IL_0012: ldfld class MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_0' MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_1'::'CS$<>8__locals1'
			IL_0017: ldfld class MMP.AsyncProxy.Training.Crunch.SaleRecord[] MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_0'::sales
			IL_001c: ldarg.0
			IL_001d: ldfld int32 MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_1'::me
			IL_0022: ldarg.0
			IL_0023: ldfld class MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_0' MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_1'::'CS$<>8__locals1'
			IL_0028: ldfld class MMP.AsyncProxy.Training.Crunch.SaleRecord[] MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_0'::sales
			IL_002d: ldlen
			IL_002e: conv.i4
			IL_002f: ldarg.0
			IL_0030: ldfld class MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_0' MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_1'::'CS$<>8__locals1'
			IL_0035: ldfld class MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_0'::'<>4__this'
			IL_003a: ldfld int32 MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler::_crew
			IL_003f: ldarg.0
			IL_0040: ldfld class MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_0' MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_1'::'CS$<>8__locals1'
			IL_0045: ldfld int32 MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_0'::rounds
			IL_004a: call class MMP.AsyncProxy.Training.Crunch.Tally MMP.AsyncProxy.Training.Crunch.Ledger::SealRange(class MMP.AsyncProxy.Training.Crunch.SaleRecord[], int32, int32, int32, int32)
			IL_004f: stelem.ref
			IL_0050: ret
		} // end of method '<>c__DisplayClass7_1'::'<Settle>b__0'

	} // end of class <>c__DisplayClass7_1


	// Fields
	.field private initonly int32 _crew

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x445b
		// Header size: 1
		// Code size: 20 (0x14)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldc.i4.1
		IL_0002: call int32 [mscorlib]System.Environment::get_ProcessorCount()
		IL_0007: ldc.i4.1
		IL_0008: sub
		IL_0009: call int32 [mscorlib]System.Math::Max(int32, int32)
		IL_000e: call instance void MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler::.ctor(int32)
		IL_0013: ret
	} // end of method CrewSettler::.ctor

	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			int32 crew
		) cil managed 
	{
		// Method begins at RVA 0x4470
		// Header size: 1
		// Code size: 14 (0xe)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: call instance void [mscorlib]System.Object::.ctor()
		IL_0006: ldarg.0
		IL_0007: ldarg.1
		IL_0008: stfld int32 MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler::_crew
		IL_000d: ret
	} // end of method CrewSettler::.ctor

	.method public final hidebysig specialname newslot virtual 
		instance string get_Version () cil managed 
	{
		// Method begins at RVA 0x447f
		// Header size: 1
		// Code size: 6 (0x6)
		.maxstack 8

		IL_0000: ldstr "threaded"
		IL_0005: ret
	} // end of method CrewSettler::get_Version

	.method public hidebysig specialname 
		instance int32 get_Crew () cil managed 
	{
		// Method begins at RVA 0x4486
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld int32 MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler::_crew
		IL_0006: ret
	} // end of method CrewSettler::get_Crew

	.method public final hidebysig newslot virtual 
		instance class MMP.AsyncProxy.Training.Crunch.Settlement Settle (
			class MMP.AsyncProxy.Training.Crunch.SaleRecord[] sales,
			int32 rounds
		) cil managed 
	{
		// Method begins at RVA 0x4490
		// Header size: 12
		// Code size: 226 (0xe2)
		.maxstack 4
		.locals init (
			[0] class MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_0',
			[1] class [mscorlib]System.Threading.Thread[],
			[2] class MMP.AsyncProxy.Training.Crunch.Tally,
			[3] int32,
			[4] class MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_1',
			[5] int32
		)

		IL_0000: newobj instance void MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_0'::.ctor()
		IL_0005: stloc.0
		IL_0006: ldloc.0
		IL_0007: ldarg.1
		IL_0008: stfld class MMP.AsyncProxy.Training.Crunch.SaleRecord[] MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_0'::sales
		IL_000d: ldloc.0
		IL_000e: ldarg.0
		IL_000f: stfld class MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_0'::'<>4__this'
		IL_0014: ldloc.0
		IL_0015: ldarg.2
		IL_0016: stfld int32 MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_0'::rounds
		IL_001b: ldloc.0
		IL_001c: ldarg.0
		IL_001d: ldfld int32 MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler::_crew
		IL_0022: newarr MMP.AsyncProxy.Training.Crunch.Tally
		IL_0027: stfld class MMP.AsyncProxy.Training.Crunch.Tally[] MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_0'::parts
		IL_002c: ldarg.0
		IL_002d: ldfld int32 MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler::_crew
		IL_0032: newarr [mscorlib]System.Threading.Thread
		IL_0037: stloc.1
		IL_0038: ldc.i4.0
		IL_0039: stloc.3
		IL_003a: br.s IL_009f
		// loop start (head: IL_009f)
			IL_003c: newobj instance void MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_1'::.ctor()
			IL_0041: stloc.s 4
			IL_0043: ldloc.s 4
			IL_0045: ldloc.0
			IL_0046: stfld class MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_0' MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_1'::'CS$<>8__locals1'
			IL_004b: ldloc.s 4
			IL_004d: ldloc.3
			IL_004e: stfld int32 MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_1'::me
			IL_0053: ldloc.1
			IL_0054: ldloc.3
			IL_0055: ldloc.s 4
			IL_0057: ldftn instance void MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_1'::'<Settle>b__0'()
			IL_005d: newobj instance void [mscorlib]System.Threading.ThreadStart::.ctor(object, native int)
			IL_0062: newobj instance void [mscorlib]System.Threading.Thread::.ctor(class [mscorlib]System.Threading.ThreadStart)
			IL_0067: stelem.ref
			IL_0068: ldloc.1
			IL_0069: ldloc.3
			IL_006a: ldelem.ref
			IL_006b: ldc.i4.1
			IL_006c: callvirt instance void [mscorlib]System.Threading.Thread::set_IsBackground(bool)
			IL_0071: ldloc.1
			IL_0072: ldloc.3
			IL_0073: ldelem.ref
			IL_0074: ldstr "crunch:"
			IL_0079: ldloca.s 3
			IL_007b: call instance string [mscorlib]System.Int32::ToString()
			IL_0080: call string [mscorlib]System.String::Concat(string, string)
			IL_0085: callvirt instance void [mscorlib]System.Threading.Thread::set_Name(string)
			IL_008a: ldloc.1
			IL_008b: ldloc.3
			IL_008c: ldelem.ref
			IL_008d: ldc.i4.1
			IL_008e: callvirt instance void [mscorlib]System.Threading.Thread::set_Priority(valuetype [mscorlib]System.Threading.ThreadPriority)
			IL_0093: ldloc.1
			IL_0094: ldloc.3
			IL_0095: ldelem.ref
			IL_0096: callvirt instance void [mscorlib]System.Threading.Thread::Start()
			IL_009b: ldloc.3
			IL_009c: ldc.i4.1
			IL_009d: add
			IL_009e: stloc.3

			IL_009f: ldloc.3
			IL_00a0: ldarg.0
			IL_00a1: ldfld int32 MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler::_crew
			IL_00a6: blt.s IL_003c
		// end loop

		IL_00a8: newobj instance void MMP.AsyncProxy.Training.Crunch.Tally::.ctor()
		IL_00ad: stloc.2
		IL_00ae: ldc.i4.0
		IL_00af: stloc.s 5
		IL_00b1: br.s IL_00d1
		// loop start (head: IL_00d1)
			IL_00b3: ldloc.1
			IL_00b4: ldloc.s 5
			IL_00b6: ldelem.ref
			IL_00b7: callvirt instance void [mscorlib]System.Threading.Thread::Join()
			IL_00bc: ldloc.2
			IL_00bd: ldloc.0
			IL_00be: ldfld class MMP.AsyncProxy.Training.Crunch.Tally[] MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler/'<>c__DisplayClass7_0'::parts
			IL_00c3: ldloc.s 5
			IL_00c5: ldelem.ref
			IL_00c6: callvirt instance void MMP.AsyncProxy.Training.Crunch.Tally::Merge(class MMP.AsyncProxy.Training.Crunch.Tally)
			IL_00cb: ldloc.s 5
			IL_00cd: ldc.i4.1
			IL_00ce: add
			IL_00cf: stloc.s 5

			IL_00d1: ldloc.s 5
			IL_00d3: ldarg.0
			IL_00d4: ldfld int32 MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler::_crew
			IL_00d9: blt.s IL_00b3
		// end loop

		IL_00db: ldloc.2
		IL_00dc: callvirt instance class MMP.AsyncProxy.Training.Crunch.Settlement MMP.AsyncProxy.Training.Crunch.Tally::ToSettlement()
		IL_00e1: ret
	} // end of method CrewSettler::Settle

	.method public final hidebysig newslot virtual 
		instance void Dispose () cil managed 
	{
		// Method begins at RVA 0x457e
		// Header size: 1
		// Code size: 1 (0x1)
		.maxstack 8

		IL_0000: ret
	} // end of method CrewSettler::Dispose

	// Properties
	.property instance string Version()
	{
		.get instance string MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler::get_Version()
	}
	.property instance int32 Crew()
	{
		.get instance int32 MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler::get_Crew()
	}

} // end of class MMP.AsyncProxy.Training.Crunch.Threaded.CrewSettler

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Crunch.Async.LoopSettler
	extends [mscorlib]System.Object
	implements MMP.AsyncProxy.Training.Crunch.ISettler,
	           [mscorlib]System.IDisposable
{
	// Nested Types
	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass3_0'
		extends [mscorlib]System.Object
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field public class MMP.AsyncProxy.Training.Crunch.SaleRecord[] sales
		.field public int32 rounds

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor () cil managed 
		{
			// Method begins at RVA 0x5bd9
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass3_0'::.ctor

		.method assembly hidebysig 
			instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> '<Settle>b__0' (
				class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Crunch.Settlement> 'ret'
			) cil managed 
		{
			// Method begins at RVA 0x5be1
			// Header size: 1
			// Code size: 19 (0x13)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class MMP.AsyncProxy.Training.Crunch.SaleRecord[] MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass3_0'::sales
			IL_0006: ldarg.0
			IL_0007: ldfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass3_0'::rounds
			IL_000c: ldarg.1
			IL_000d: call class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Crunch.Async.LoopSettler::Body(class MMP.AsyncProxy.Training.Crunch.SaleRecord[], int32, class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Crunch.Settlement>)
			IL_0012: ret
		} // end of method '<>c__DisplayClass3_0'::'<Settle>b__0'

	} // end of class <>c__DisplayClass3_0

	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass4_0'
		extends [mscorlib]System.Object
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field public class MMP.AsyncProxy.Training.Crunch.SaleRecord[] sales
		.field public int32 rounds

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor () cil managed 
		{
			// Method begins at RVA 0x5bf5
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass4_0'::.ctor

	} // end of class <>c__DisplayClass4_0

	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass4_1'
		extends [mscorlib]System.Object
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field public int32 from
		.field public int32 'to'
		.field public class MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_0' 'CS$<>8__locals1'

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor () cil managed 
		{
			// Method begins at RVA 0x5bfd
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass4_1'::.ctor

		.method assembly hidebysig 
			instance class MMP.AsyncProxy.Training.Crunch.Tally '<Body>b__0' () cil managed 
		{
			// Method begins at RVA 0x5c05
			// Header size: 1
			// Code size: 41 (0x29)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_0' MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_1'::'CS$<>8__locals1'
			IL_0006: ldfld class MMP.AsyncProxy.Training.Crunch.SaleRecord[] MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_0'::sales
			IL_000b: ldarg.0
			IL_000c: ldfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_1'::from
			IL_0011: ldarg.0
			IL_0012: ldfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_1'::'to'
			IL_0017: ldc.i4.1
			IL_0018: ldarg.0
			IL_0019: ldfld class MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_0' MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_1'::'CS$<>8__locals1'
			IL_001e: ldfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_0'::rounds
			IL_0023: call class MMP.AsyncProxy.Training.Crunch.Tally MMP.AsyncProxy.Training.Crunch.Ledger::SealRange(class MMP.AsyncProxy.Training.Crunch.SaleRecord[], int32, int32, int32, int32)
			IL_0028: ret
		} // end of method '<>c__DisplayClass4_1'::'<Body>b__0'

	} // end of class <>c__DisplayClass4_1

	.class nested private auto ansi sealed beforefieldinit '<Body>d__4'
		extends [mscorlib]System.Object
		implements class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>,
		           [mscorlib]System.Collections.IEnumerable,
		           class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>,
		           [mscorlib]System.IDisposable,
		           [mscorlib]System.Collections.IEnumerator
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field private int32 '<>1__state'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture '<>2__current'
		.field private int32 '<>l__initialThreadId'
		.field private class MMP.AsyncProxy.Training.Crunch.SaleRecord[] sales
		.field public class MMP.AsyncProxy.Training.Crunch.SaleRecord[] '<>3__sales'
		.field private int32 rounds
		.field public int32 '<>3__rounds'
		.field private class MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_0' '<>8__1'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Crunch.Settlement> 'ret'
		.field public class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Crunch.Settlement> '<>3__ret'
		.field private class MMP.AsyncProxy.Training.Crunch.Tally '<all>5__2'
		.field private int32 '<start>5__3'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class MMP.AsyncProxy.Training.Crunch.Tally> '<chunk>5__4'

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor (
				int32 '<>1__state'
			) cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			// Method begins at RVA 0x5c2f
			// Header size: 1
			// Code size: 30 (0x1e)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ldarg.0
			IL_0007: ldarg.1
			IL_0008: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<>1__state'
			IL_000d: ldarg.0
			IL_000e: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0013: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_0018: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<>l__initialThreadId'
			IL_001d: ret
		} // end of method '<Body>d__4'::.ctor

		.method private final hidebysig newslot virtual 
			instance void System.IDisposable.Dispose () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [mscorlib]System.IDisposable::Dispose()
			// Method begins at RVA 0x5c4e
			// Header size: 1
			// Code size: 30 (0x1e)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldnull
			IL_0002: stfld class MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_0' MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<>8__1'
			IL_0007: ldarg.0
			IL_0008: ldnull
			IL_0009: stfld class MMP.AsyncProxy.Training.Crunch.Tally MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<all>5__2'
			IL_000e: ldarg.0
			IL_000f: ldnull
			IL_0010: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class MMP.AsyncProxy.Training.Crunch.Tally> MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<chunk>5__4'
			IL_0015: ldarg.0
			IL_0016: ldc.i4.s -2
			IL_0018: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<>1__state'
			IL_001d: ret
		} // end of method '<Body>d__4'::System.IDisposable.Dispose

		.method private final hidebysig newslot virtual 
			instance bool MoveNext () cil managed 
		{
			.override method instance bool [mscorlib]System.Collections.IEnumerator::MoveNext()
			// Method begins at RVA 0x5c70
			// Header size: 12
			// Code size: 306 (0x132)
			.maxstack 3
			.locals init (
				[0] int32,
				[1] class MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_1'
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<>1__state'
			IL_0006: stloc.0
			IL_0007: ldloc.0
			IL_0008: brfalse.s IL_0013

			IL_000a: ldloc.0
			IL_000b: ldc.i4.1
			IL_000c: beq IL_00cc

			IL_0011: ldc.i4.0
			IL_0012: ret

			IL_0013: ldarg.0
			IL_0014: ldc.i4.m1
			IL_0015: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<>1__state'
			IL_001a: ldarg.0
			IL_001b: newobj instance void MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_0'::.ctor()
			IL_0020: stfld class MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_0' MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<>8__1'
			IL_0025: ldarg.0
			IL_0026: ldfld class MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_0' MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<>8__1'
			IL_002b: ldarg.0
			IL_002c: ldfld class MMP.AsyncProxy.Training.Crunch.SaleRecord[] MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::sales
			IL_0031: stfld class MMP.AsyncProxy.Training.Crunch.SaleRecord[] MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_0'::sales
			IL_0036: ldarg.0
			IL_0037: ldfld class MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_0' MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<>8__1'
			IL_003c: ldarg.0
			IL_003d: ldfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::rounds
			IL_0042: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_0'::rounds
			IL_0047: ldarg.0
			IL_0048: newobj instance void MMP.AsyncProxy.Training.Crunch.Tally::.ctor()
			IL_004d: stfld class MMP.AsyncProxy.Training.Crunch.Tally MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<all>5__2'
			IL_0052: ldarg.0
			IL_0053: ldc.i4.0
			IL_0054: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<start>5__3'
			IL_0059: br IL_0102

			IL_005e: newobj instance void MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_1'::.ctor()
			IL_0063: stloc.1
			IL_0064: ldloc.1
			IL_0065: ldarg.0
			IL_0066: ldfld class MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_0' MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<>8__1'
			IL_006b: stfld class MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_0' MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_1'::'CS$<>8__locals1'
			IL_0070: ldloc.1
			IL_0071: ldarg.0
			IL_0072: ldfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<start>5__3'
			IL_0077: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_1'::from
			IL_007c: ldloc.1
			IL_007d: ldarg.0
			IL_007e: ldfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<start>5__3'
			IL_0083: ldc.i4 500
			IL_0088: add
			IL_0089: ldloc.1
			IL_008a: ldfld class MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_0' MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_1'::'CS$<>8__locals1'
			IL_008f: ldfld class MMP.AsyncProxy.Training.Crunch.SaleRecord[] MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_0'::sales
			IL_0094: ldlen
			IL_0095: conv.i4
			IL_0096: call int32 [mscorlib]System.Math::Min(int32, int32)
			IL_009b: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_1'::'to'
			IL_00a0: ldarg.0
			IL_00a1: ldloc.1
			IL_00a2: ldftn instance class MMP.AsyncProxy.Training.Crunch.Tally MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_1'::'<Body>b__0'()
			IL_00a8: newobj instance void class [System.Core]System.Func`1<class MMP.AsyncProxy.Training.Crunch.Tally>::.ctor(object, native int)
			IL_00ad: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!!0> [MMP.AsyncProxy]MMP.AsyncProxy.Futures::Run<class MMP.AsyncProxy.Training.Crunch.Tally>(class [System.Core]System.Func`1<!!0>)
			IL_00b2: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class MMP.AsyncProxy.Training.Crunch.Tally> MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<chunk>5__4'
			IL_00b7: ldarg.0
			IL_00b8: ldarg.0
			IL_00b9: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class MMP.AsyncProxy.Training.Crunch.Tally> MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<chunk>5__4'
			IL_00be: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<>2__current'
			IL_00c3: ldarg.0
			IL_00c4: ldc.i4.1
			IL_00c5: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<>1__state'
			IL_00ca: ldc.i4.1
			IL_00cb: ret

			IL_00cc: ldarg.0
			IL_00cd: ldc.i4.m1
			IL_00ce: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<>1__state'
			IL_00d3: ldarg.0
			IL_00d4: ldfld class MMP.AsyncProxy.Training.Crunch.Tally MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<all>5__2'
			IL_00d9: ldarg.0
			IL_00da: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class MMP.AsyncProxy.Training.Crunch.Tally> MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<chunk>5__4'
			IL_00df: callvirt instance !0 class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class MMP.AsyncProxy.Training.Crunch.Tally>::get_Result()
			IL_00e4: callvirt instance void MMP.AsyncProxy.Training.Crunch.Tally::Merge(class MMP.AsyncProxy.Training.Crunch.Tally)
			IL_00e9: ldarg.0
			IL_00ea: ldnull
			IL_00eb: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class MMP.AsyncProxy.Training.Crunch.Tally> MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<chunk>5__4'
			IL_00f0: ldarg.0
			IL_00f1: ldarg.0
			IL_00f2: ldfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<start>5__3'
			IL_00f7: ldc.i4 500
			IL_00fc: add
			IL_00fd: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<start>5__3'

			IL_0102: ldarg.0
			IL_0103: ldfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<start>5__3'
			IL_0108: ldarg.0
			IL_0109: ldfld class MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_0' MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<>8__1'
			IL_010e: ldfld class MMP.AsyncProxy.Training.Crunch.SaleRecord[] MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass4_0'::sales
			IL_0113: ldlen
			IL_0114: conv.i4
			IL_0115: blt IL_005e

			IL_011a: ldarg.0
			IL_011b: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Crunch.Settlement> MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'ret'
			IL_0120: ldarg.0
			IL_0121: ldfld class MMP.AsyncProxy.Training.Crunch.Tally MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<all>5__2'
			IL_0126: callvirt instance class MMP.AsyncProxy.Training.Crunch.Settlement MMP.AsyncProxy.Training.Crunch.Tally::ToSettlement()
			IL_012b: callvirt instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Crunch.Settlement>::set_Value(!0)
			IL_0130: ldc.i4.0
			IL_0131: ret
		} // end of method '<Body>d__4'::MoveNext

		.method private final hidebysig specialname newslot virtual 
			instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance !0 class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::get_Current()
			// Method begins at RVA 0x5dae
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<>2__current'
			IL_0006: ret
		} // end of method '<Body>d__4'::'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current'

		.method private final hidebysig newslot virtual 
			instance void System.Collections.IEnumerator.Reset () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [mscorlib]System.Collections.IEnumerator::Reset()
			// Method begins at RVA 0x5db6
			// Header size: 1
			// Code size: 6 (0x6)
			.maxstack 8

			IL_0000: newobj instance void [mscorlib]System.NotSupportedException::.ctor()
			IL_0005: throw
		} // end of method '<Body>d__4'::System.Collections.IEnumerator.Reset

		.method private final hidebysig specialname newslot virtual 
			instance object System.Collections.IEnumerator.get_Current () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance object [mscorlib]System.Collections.IEnumerator::get_Current()
			// Method begins at RVA 0x5dbd
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<>2__current'
			IL_0006: ret
		} // end of method '<Body>d__4'::System.Collections.IEnumerator.get_Current

		.method private final hidebysig newslot virtual 
			instance class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> 'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance class [mscorlib]System.Collections.Generic.IEnumerator`1<!0> class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::GetEnumerator()
			// Method begins at RVA 0x5dc8
			// Header size: 12
			// Code size: 84 (0x54)
			.maxstack 2
			.locals init (
				[0] class MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<>1__state'
			IL_0006: ldc.i4.s -2
			IL_0008: bne.un.s IL_0027

			IL_000a: ldarg.0
			IL_000b: ldfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<>l__initialThreadId'
			IL_0010: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0015: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_001a: bne.un.s IL_0027

			IL_001c: ldarg.0
			IL_001d: ldc.i4.0
			IL_001e: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<>1__state'
			IL_0023: ldarg.0
			IL_0024: stloc.0
			IL_0025: br.s IL_002e

			IL_0027: ldc.i4.0
			IL_0028: newobj instance void MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::.ctor(int32)
			IL_002d: stloc.0

			IL_002e: ldloc.0
			IL_002f: ldarg.0
			IL_0030: ldfld class MMP.AsyncProxy.Training.Crunch.SaleRecord[] MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<>3__sales'
			IL_0035: stfld class MMP.AsyncProxy.Training.Crunch.SaleRecord[] MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::sales
			IL_003a: ldloc.0
			IL_003b: ldarg.0
			IL_003c: ldfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<>3__rounds'
			IL_0041: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::rounds
			IL_0046: ldloc.0
			IL_0047: ldarg.0
			IL_0048: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Crunch.Settlement> MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<>3__ret'
			IL_004d: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Crunch.Settlement> MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'ret'
			IL_0052: ldloc.0
			IL_0053: ret
		} // end of method '<Body>d__4'::'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator'

		.method private final hidebysig newslot virtual 
			instance class [mscorlib]System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance class [mscorlib]System.Collections.IEnumerator [mscorlib]System.Collections.IEnumerable::GetEnumerator()
			// Method begins at RVA 0x5e28
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator'()
			IL_0006: ret
		} // end of method '<Body>d__4'::System.Collections.IEnumerable.GetEnumerator

		// Properties
		.property instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.Current'()
		{
			.get instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current'()
		}
		.property instance object System.Collections.IEnumerator.Current()
		{
			.get instance object MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::System.Collections.IEnumerator.get_Current()
		}

	} // end of class <Body>d__4


	// Fields
	.field private static literal int32 ChunkSize = int32(500)

	// Methods
	.method public final hidebysig specialname newslot virtual 
		instance string get_Version () cil managed 
	{
		// Method begins at RVA 0x4580
		// Header size: 1
		// Code size: 6 (0x6)
		.maxstack 8

		IL_0000: ldstr "async-loop"
		IL_0005: ret
	} // end of method LoopSettler::get_Version

	.method public final hidebysig newslot virtual 
		instance class MMP.AsyncProxy.Training.Crunch.Settlement Settle (
			class MMP.AsyncProxy.Training.Crunch.SaleRecord[] sales,
			int32 rounds
		) cil managed 
	{
		// Method begins at RVA 0x4587
		// Header size: 1
		// Code size: 41 (0x29)
		.maxstack 8

		IL_0000: newobj instance void MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass3_0'::.ctor()
		IL_0005: dup
		IL_0006: ldarg.1
		IL_0007: stfld class MMP.AsyncProxy.Training.Crunch.SaleRecord[] MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass3_0'::sales
		IL_000c: dup
		IL_000d: ldarg.2
		IL_000e: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass3_0'::rounds
		IL_0013: ldftn instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<>c__DisplayClass3_0'::'<Settle>b__0'(class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Crunch.Settlement>)
		IL_0019: newobj instance void class [System.Core]System.Func`2<class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Crunch.Settlement>, class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>>::.ctor(object, native int)
		IL_001e: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!!0> [MMP.AsyncProxy]MMP.AsyncProxy.AsyncProxy::Run<class MMP.AsyncProxy.Training.Crunch.Settlement>(class [System.Core]System.Func`2<class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<!!0>, class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>>)
		IL_0023: callvirt instance !0 class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class MMP.AsyncProxy.Training.Crunch.Settlement>::get_Result()
		IL_0028: ret
	} // end of method LoopSettler::Settle

	.method private hidebysig static 
		class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> Body (
			class MMP.AsyncProxy.Training.Crunch.SaleRecord[] sales,
			int32 rounds,
			class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Crunch.Settlement> 'ret'
		) cil managed 
	{
		// Method begins at RVA 0x45b1
		// Header size: 1
		// Code size: 29 (0x1d)
		.maxstack 8

		IL_0000: ldc.i4.s -2
		IL_0002: newobj instance void MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::.ctor(int32)
		IL_0007: dup
		IL_0008: ldarg.0
		IL_0009: stfld class MMP.AsyncProxy.Training.Crunch.SaleRecord[] MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<>3__sales'
		IL_000e: dup
		IL_000f: ldarg.1
		IL_0010: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<>3__rounds'
		IL_0015: dup
		IL_0016: ldarg.2
		IL_0017: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Crunch.Settlement> MMP.AsyncProxy.Training.Crunch.Async.LoopSettler/'<Body>d__4'::'<>3__ret'
		IL_001c: ret
	} // end of method LoopSettler::Body

	.method public final hidebysig newslot virtual 
		instance void Dispose () cil managed 
	{
		// Method begins at RVA 0x45cf
		// Header size: 1
		// Code size: 1 (0x1)
		.maxstack 8

		IL_0000: ret
	} // end of method LoopSettler::Dispose

	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x45d1
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: call instance void [mscorlib]System.Object::.ctor()
		IL_0006: ret
	} // end of method LoopSettler::.ctor

	// Properties
	.property instance string Version()
	{
		.get instance string MMP.AsyncProxy.Training.Crunch.Async.LoopSettler::get_Version()
	}

} // end of class MMP.AsyncProxy.Training.Crunch.Async.LoopSettler

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler
	extends [mscorlib]System.Object
	implements MMP.AsyncProxy.Training.Crunch.ISettler,
	           [mscorlib]System.IDisposable
{
	// Nested Types
	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass5_0'
		extends [mscorlib]System.Object
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field public class MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler '<>4__this'
		.field public class MMP.AsyncProxy.Training.Crunch.SaleRecord[] sales
		.field public int32 rounds

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor () cil managed 
		{
			// Method begins at RVA 0x5e30
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass5_0'::.ctor

		.method assembly hidebysig 
			instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> '<Settle>b__0' (
				class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Crunch.Settlement> 'ret'
			) cil managed 
		{
			// Method begins at RVA 0x5e38
			// Header size: 1
			// Code size: 25 (0x19)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass5_0'::'<>4__this'
			IL_0006: ldarg.0
			IL_0007: ldfld class MMP.AsyncProxy.Training.Crunch.SaleRecord[] MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass5_0'::sales
			IL_000c: ldarg.0
			IL_000d: ldfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass5_0'::rounds
			IL_0012: ldarg.1
			IL_0013: call instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler::Body(class MMP.AsyncProxy.Training.Crunch.SaleRecord[], int32, class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Crunch.Settlement>)
			IL_0018: ret
		} // end of method '<>c__DisplayClass5_0'::'<Settle>b__0'

	} // end of class <>c__DisplayClass5_0

	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass6_0'
		extends [mscorlib]System.Object
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field public class MMP.AsyncProxy.Training.Crunch.SaleRecord[] sales
		.field public int32 rounds

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor () cil managed 
		{
			// Method begins at RVA 0x5e52
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass6_0'::.ctor

	} // end of class <>c__DisplayClass6_0

	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass6_1'
		extends [mscorlib]System.Object
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field public int32 me
		.field public int32 count
		.field public class MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass6_0' 'CS$<>8__locals1'

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor () cil managed 
		{
			// Method begins at RVA 0x5e5a
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass6_1'::.ctor

		.method assembly hidebysig 
			instance class MMP.AsyncProxy.Training.Crunch.Tally '<Body>b__0' () cil managed 
		{
			// Method begins at RVA 0x5e62
			// Header size: 1
			// Code size: 53 (0x35)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass6_0' MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass6_1'::'CS$<>8__locals1'
			IL_0006: ldfld class MMP.AsyncProxy.Training.Crunch.SaleRecord[] MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass6_0'::sales
			IL_000b: ldarg.0
			IL_000c: ldfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass6_1'::me
			IL_0011: ldarg.0
			IL_0012: ldfld class MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass6_0' MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass6_1'::'CS$<>8__locals1'
			IL_0017: ldfld class MMP.AsyncProxy.Training.Crunch.SaleRecord[] MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass6_0'::sales
			IL_001c: ldlen
			IL_001d: conv.i4
			IL_001e: ldarg.0
			IL_001f: ldfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass6_1'::count
			IL_0024: ldarg.0
			IL_0025: ldfld class MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass6_0' MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass6_1'::'CS$<>8__locals1'
			IL_002a: ldfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass6_0'::rounds
			IL_002f: call class MMP.AsyncProxy.Training.Crunch.Tally MMP.AsyncProxy.Training.Crunch.Ledger::SealRange(class MMP.AsyncProxy.Training.Crunch.SaleRecord[], int32, int32, int32, int32)
			IL_0034: ret
		} // end of method '<>c__DisplayClass6_1'::'<Body>b__0'

	} // end of class <>c__DisplayClass6_1

	.class nested private auto ansi sealed beforefieldinit '<Body>d__6'
		extends [mscorlib]System.Object
		implements class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>,
		           [mscorlib]System.Collections.IEnumerable,
		           class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>,
		           [mscorlib]System.IDisposable,
		           [mscorlib]System.Collections.IEnumerator
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field private int32 '<>1__state'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture '<>2__current'
		.field private int32 '<>l__initialThreadId'
		.field private class MMP.AsyncProxy.Training.Crunch.SaleRecord[] sales
		.field public class MMP.AsyncProxy.Training.Crunch.SaleRecord[] '<>3__sales'
		.field private int32 rounds
		.field public int32 '<>3__rounds'
		.field public class MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler '<>4__this'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Crunch.Settlement> 'ret'
		.field public class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Crunch.Settlement> '<>3__ret'
		.field private class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class MMP.AsyncProxy.Training.Crunch.Tally>[] '<chunks>5__2'

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor (
				int32 '<>1__state'
			) cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			// Method begins at RVA 0x5e98
			// Header size: 1
			// Code size: 30 (0x1e)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ldarg.0
			IL_0007: ldarg.1
			IL_0008: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<>1__state'
			IL_000d: ldarg.0
			IL_000e: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0013: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_0018: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<>l__initialThreadId'
			IL_001d: ret
		} // end of method '<Body>d__6'::.ctor

		.method private final hidebysig newslot virtual 
			instance void System.IDisposable.Dispose () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [mscorlib]System.IDisposable::Dispose()
			// Method begins at RVA 0x5eb7
			// Header size: 1
			// Code size: 16 (0x10)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldnull
			IL_0002: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class MMP.AsyncProxy.Training.Crunch.Tally>[] MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<chunks>5__2'
			IL_0007: ldarg.0
			IL_0008: ldc.i4.s -2
			IL_000a: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<>1__state'
			IL_000f: ret
		} // end of method '<Body>d__6'::System.IDisposable.Dispose

		.method private final hidebysig newslot virtual 
			instance bool MoveNext () cil managed 
		{
			.override method instance bool [mscorlib]System.Collections.IEnumerator::MoveNext()
			// Method begins at RVA 0x5ec8
			// Header size: 12
			// Code size: 268 (0x10c)
			.maxstack 4
			.locals init (
				[0] int32,
				[1] class MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler,
				[2] class MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass6_0',
				[3] class MMP.AsyncProxy.Training.Crunch.Tally,
				[4] int32,
				[5] class MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass6_1',
				[6] class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture[],
				[7] int32
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<>1__state'
			IL_0006: stloc.0
			IL_0007: ldarg.0
			IL_0008: ldfld class MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<>4__this'
			IL_000d: stloc.1
			IL_000e: ldloc.0
			IL_000f: brfalse.s IL_001a

			IL_0011: ldloc.0
			IL_0012: ldc.i4.1
			IL_0013: beq IL_00c3

			IL_0018: ldc.i4.0
			IL_0019: ret

			IL_001a: ldarg.0
			IL_001b: ldc.i4.m1
			IL_001c: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<>1__state'
			IL_0021: newobj instance void MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass6_0'::.ctor()
			IL_0026: stloc.2
			IL_0027: ldloc.2
			IL_0028: ldarg.0
			IL_0029: ldfld class MMP.AsyncProxy.Training.Crunch.SaleRecord[] MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::sales
			IL_002e: stfld class MMP.AsyncProxy.Training.Crunch.SaleRecord[] MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass6_0'::sales
			IL_0033: ldloc.2
			IL_0034: ldarg.0
			IL_0035: ldfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::rounds
			IL_003a: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass6_0'::rounds
			IL_003f: ldarg.0
			IL_0040: ldloc.1
			IL_0041: ldfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler::_chunks
			IL_0046: newarr class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class MMP.AsyncProxy.Training.Crunch.Tally>
			IL_004b: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class MMP.AsyncProxy.Training.Crunch.Tally>[] MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<chunks>5__2'
			IL_0050: ldc.i4.0
			IL_0051: stloc.s 4
			IL_0053: br.s IL_009b
			// loop start (head: IL_009b)
				IL_0055: newobj instance void MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass6_1'::.ctor()
				IL_005a: stloc.s 5
				IL_005c: ldloc.s 5
				IL_005e: ldloc.2
				IL_005f: stfld class MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass6_0' MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass6_1'::'CS$<>8__locals1'
				IL_0064: ldloc.s 5
				IL_0066: ldloc.s 4
				IL_0068: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass6_1'::me
				IL_006d: ldloc.s 5
				IL_006f: ldloc.1
				IL_0070: ldfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler::_chunks
				IL_0075: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass6_1'::count
				IL_007a: ldarg.0
				IL_007b: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class MMP.AsyncProxy.Training.Crunch.Tally>[] MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<chunks>5__2'
				IL_0080: ldloc.s 4
				IL_0082: ldloc.s 5
				IL_0084: ldftn instance class MMP.AsyncProxy.Training.Crunch.Tally MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass6_1'::'<Body>b__0'()
				IL_008a: newobj instance void class [System.Core]System.Func`1<class MMP.AsyncProxy.Training.Crunch.Tally>::.ctor(object, native int)
				IL_008f: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!!0> [MMP.AsyncProxy]MMP.AsyncProxy.Futures::Run<class MMP.AsyncProxy.Training.Crunch.Tally>(class [System.Core]System.Func`1<!!0>)
				IL_0094: stelem.ref
				IL_0095: ldloc.s 4
				IL_0097: ldc.i4.1
				IL_0098: add
				IL_0099: stloc.s 4

				IL_009b: ldloc.s 4
				IL_009d: ldloc.1
				IL_009e: ldfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler::_chunks
				IL_00a3: blt.s IL_0055
			// end loop

			IL_00a5: ldarg.0
			IL_00a6: ldarg.0
			IL_00a7: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class MMP.AsyncProxy.Training.Crunch.Tally>[] MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<chunks>5__2'
			IL_00ac: stloc.s 6
			IL_00ae: ldloc.s 6
			IL_00b0: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture [MMP.AsyncProxy]MMP.AsyncProxy.Futures::WhenAll(class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture[])
			IL_00b5: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<>2__current'
			IL_00ba: ldarg.0
			IL_00bb: ldc.i4.1
			IL_00bc: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<>1__state'
			IL_00c1: ldc.i4.1
			IL_00c2: ret

			IL_00c3: ldarg.0
			IL_00c4: ldc.i4.m1
			IL_00c5: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<>1__state'
			IL_00ca: newobj instance void MMP.AsyncProxy.Training.Crunch.Tally::.ctor()
			IL_00cf: stloc.3
			IL_00d0: ldc.i4.0
			IL_00d1: stloc.s 7
			IL_00d3: br.s IL_00ef
			// loop start (head: IL_00ef)
				IL_00d5: ldloc.3
				IL_00d6: ldarg.0
				IL_00d7: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class MMP.AsyncProxy.Training.Crunch.Tally>[] MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<chunks>5__2'
				IL_00dc: ldloc.s 7
				IL_00de: ldelem.ref
				IL_00df: callvirt instance !0 class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class MMP.AsyncProxy.Training.Crunch.Tally>::get_Result()
				IL_00e4: callvirt instance void MMP.AsyncProxy.Training.Crunch.Tally::Merge(class MMP.AsyncProxy.Training.Crunch.Tally)
				IL_00e9: ldloc.s 7
				IL_00eb: ldc.i4.1
				IL_00ec: add
				IL_00ed: stloc.s 7

				IL_00ef: ldloc.s 7
				IL_00f1: ldloc.1
				IL_00f2: ldfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler::_chunks
				IL_00f7: blt.s IL_00d5
			// end loop

			IL_00f9: ldarg.0
			IL_00fa: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Crunch.Settlement> MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'ret'
			IL_00ff: ldloc.3
			IL_0100: callvirt instance class MMP.AsyncProxy.Training.Crunch.Settlement MMP.AsyncProxy.Training.Crunch.Tally::ToSettlement()
			IL_0105: callvirt instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Crunch.Settlement>::set_Value(!0)
			IL_010a: ldc.i4.0
			IL_010b: ret
		} // end of method '<Body>d__6'::MoveNext

		.method private final hidebysig specialname newslot virtual 
			instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance !0 class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::get_Current()
			// Method begins at RVA 0x5fe0
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<>2__current'
			IL_0006: ret
		} // end of method '<Body>d__6'::'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current'

		.method private final hidebysig newslot virtual 
			instance void System.Collections.IEnumerator.Reset () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [mscorlib]System.Collections.IEnumerator::Reset()
			// Method begins at RVA 0x5fe8
			// Header size: 1
			// Code size: 6 (0x6)
			.maxstack 8

			IL_0000: newobj instance void [mscorlib]System.NotSupportedException::.ctor()
			IL_0005: throw
		} // end of method '<Body>d__6'::System.Collections.IEnumerator.Reset

		.method private final hidebysig specialname newslot virtual 
			instance object System.Collections.IEnumerator.get_Current () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance object [mscorlib]System.Collections.IEnumerator::get_Current()
			// Method begins at RVA 0x5fef
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<>2__current'
			IL_0006: ret
		} // end of method '<Body>d__6'::System.Collections.IEnumerator.get_Current

		.method private final hidebysig newslot virtual 
			instance class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> 'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance class [mscorlib]System.Collections.Generic.IEnumerator`1<!0> class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::GetEnumerator()
			// Method begins at RVA 0x5ff8
			// Header size: 12
			// Code size: 96 (0x60)
			.maxstack 2
			.locals init (
				[0] class MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<>1__state'
			IL_0006: ldc.i4.s -2
			IL_0008: bne.un.s IL_0027

			IL_000a: ldarg.0
			IL_000b: ldfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<>l__initialThreadId'
			IL_0010: call class [mscorlib]System.Threading.Thread [mscorlib]System.Threading.Thread::get_CurrentThread()
			IL_0015: callvirt instance int32 [mscorlib]System.Threading.Thread::get_ManagedThreadId()
			IL_001a: bne.un.s IL_0027

			IL_001c: ldarg.0
			IL_001d: ldc.i4.0
			IL_001e: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<>1__state'
			IL_0023: ldarg.0
			IL_0024: stloc.0
			IL_0025: br.s IL_003a

			IL_0027: ldc.i4.0
			IL_0028: newobj instance void MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::.ctor(int32)
			IL_002d: stloc.0
			IL_002e: ldloc.0
			IL_002f: ldarg.0
			IL_0030: ldfld class MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<>4__this'
			IL_0035: stfld class MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<>4__this'

			IL_003a: ldloc.0
			IL_003b: ldarg.0
			IL_003c: ldfld class MMP.AsyncProxy.Training.Crunch.SaleRecord[] MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<>3__sales'
			IL_0041: stfld class MMP.AsyncProxy.Training.Crunch.SaleRecord[] MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::sales
			IL_0046: ldloc.0
			IL_0047: ldarg.0
			IL_0048: ldfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<>3__rounds'
			IL_004d: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::rounds
			IL_0052: ldloc.0
			IL_0053: ldarg.0
			IL_0054: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Crunch.Settlement> MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<>3__ret'
			IL_0059: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Crunch.Settlement> MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'ret'
			IL_005e: ldloc.0
			IL_005f: ret
		} // end of method '<Body>d__6'::'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator'

		.method private final hidebysig newslot virtual 
			instance class [mscorlib]System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance class [mscorlib]System.Collections.IEnumerator [mscorlib]System.Collections.IEnumerable::GetEnumerator()
			// Method begins at RVA 0x6064
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'System.Collections.Generic.IEnumerable<MMP.AsyncProxy.IFuture>.GetEnumerator'()
			IL_0006: ret
		} // end of method '<Body>d__6'::System.Collections.IEnumerable.GetEnumerator

		// Properties
		.property instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.Current'()
		{
			.get instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current'()
		}
		.property instance object System.Collections.IEnumerator.Current()
		{
			.get instance object MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::System.Collections.IEnumerator.get_Current()
		}

	} // end of class <Body>d__6


	// Fields
	.field private initonly int32 _chunks

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x45d9
		// Header size: 1
		// Code size: 12 (0xc)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: call int32 [mscorlib]System.Environment::get_ProcessorCount()
		IL_0006: call instance void MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler::.ctor(int32)
		IL_000b: ret
	} // end of method PoolFanOutSettler::.ctor

	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			int32 chunks
		) cil managed 
	{
		// Method begins at RVA 0x45e6
		// Header size: 1
		// Code size: 14 (0xe)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: call instance void [mscorlib]System.Object::.ctor()
		IL_0006: ldarg.0
		IL_0007: ldarg.1
		IL_0008: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler::_chunks
		IL_000d: ret
	} // end of method PoolFanOutSettler::.ctor

	.method public final hidebysig specialname newslot virtual 
		instance string get_Version () cil managed 
	{
		// Method begins at RVA 0x45f5
		// Header size: 1
		// Code size: 6 (0x6)
		.maxstack 8

		IL_0000: ldstr "async-pool"
		IL_0005: ret
	} // end of method PoolFanOutSettler::get_Version

	.method public final hidebysig newslot virtual 
		instance class MMP.AsyncProxy.Training.Crunch.Settlement Settle (
			class MMP.AsyncProxy.Training.Crunch.SaleRecord[] sales,
			int32 rounds
		) cil managed 
	{
		// Method begins at RVA 0x45fc
		// Header size: 1
		// Code size: 48 (0x30)
		.maxstack 8

		IL_0000: newobj instance void MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass5_0'::.ctor()
		IL_0005: dup
		IL_0006: ldarg.0
		IL_0007: stfld class MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass5_0'::'<>4__this'
		IL_000c: dup
		IL_000d: ldarg.1
		IL_000e: stfld class MMP.AsyncProxy.Training.Crunch.SaleRecord[] MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass5_0'::sales
		IL_0013: dup
		IL_0014: ldarg.2
		IL_0015: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass5_0'::rounds
		IL_001a: ldftn instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<>c__DisplayClass5_0'::'<Settle>b__0'(class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Crunch.Settlement>)
		IL_0020: newobj instance void class [System.Core]System.Func`2<class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Crunch.Settlement>, class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>>::.ctor(object, native int)
		IL_0025: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!!0> [MMP.AsyncProxy]MMP.AsyncProxy.AsyncProxy::Run<class MMP.AsyncProxy.Training.Crunch.Settlement>(class [System.Core]System.Func`2<class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<!!0>, class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>>)
		IL_002a: callvirt instance !0 class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<class MMP.AsyncProxy.Training.Crunch.Settlement>::get_Result()
		IL_002f: ret
	} // end of method PoolFanOutSettler::Settle

	.method private hidebysig 
		instance class [mscorlib]System.Collections.Generic.IEnumerable`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture> Body (
			class MMP.AsyncProxy.Training.Crunch.SaleRecord[] sales,
			int32 rounds,
			class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Crunch.Settlement> 'ret'
		) cil managed 
	{
		// Method begins at RVA 0x462d
		// Header size: 1
		// Code size: 36 (0x24)
		.maxstack 8

		IL_0000: ldc.i4.s -2
		IL_0002: newobj instance void MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::.ctor(int32)
		IL_0007: dup
		IL_0008: ldarg.0
		IL_0009: stfld class MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<>4__this'
		IL_000e: dup
		IL_000f: ldarg.1
		IL_0010: stfld class MMP.AsyncProxy.Training.Crunch.SaleRecord[] MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<>3__sales'
		IL_0015: dup
		IL_0016: ldarg.2
		IL_0017: stfld int32 MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<>3__rounds'
		IL_001c: dup
		IL_001d: ldarg.3
		IL_001e: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Return`1<class MMP.AsyncProxy.Training.Crunch.Settlement> MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler/'<Body>d__6'::'<>3__ret'
		IL_0023: ret
	} // end of method PoolFanOutSettler::Body

	.method public final hidebysig newslot virtual 
		instance void Dispose () cil managed 
	{
		// Method begins at RVA 0x4652
		// Header size: 1
		// Code size: 1 (0x1)
		.maxstack 8

		IL_0000: ret
	} // end of method PoolFanOutSettler::Dispose

	// Properties
	.property instance string Version()
	{
		.get instance string MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler::get_Version()
	}

} // end of class MMP.AsyncProxy.Training.Crunch.Async.PoolFanOutSettler

You are not using the latest version of the tool, please update.
Latest version is '11.2.0.10050' (yours is '10.0.1.8346')
