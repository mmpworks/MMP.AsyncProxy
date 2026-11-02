// IL code: MMP.AsyncProxy.Training
.class private auto ansi '<Module>'
{
} // end of class <Module>

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
		// Method begins at RVA 0x2050
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
		// Method begins at RVA 0x207c
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
		// Method begins at RVA 0x20be
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
		// Method begins at RVA 0x20df
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
		// Method begins at RVA 0x20fc
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
		// Method begins at RVA 0x2104
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
		// Method begins at RVA 0x210c
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
		// Method begins at RVA 0x2114
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
		// Method begins at RVA 0x2119
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
		// Method begins at RVA 0x213c
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
		// Method begins at RVA 0x2171
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
		// Method begins at RVA 0x217f
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
		// Method begins at RVA 0x218e
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
		// Method begins at RVA 0x2196
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
		// Method begins at RVA 0x21bc
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
		// Method begins at RVA 0x2238
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
		// Method begins at RVA 0x22b8
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
			// Method begins at RVA 0x3620
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
			// Method begins at RVA 0x3628
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
			// Method begins at RVA 0x3678
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
			// Method begins at RVA 0x3704
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
		// Method begins at RVA 0x2300
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
		// Method begins at RVA 0x2308
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
		// Method begins at RVA 0x2404
		// Header size: 1
		// Code size: 1 (0x1)
		.maxstack 8

		IL_0000: ret
	} // end of method ThreadedLine::Dispose

	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x2406
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
			// Method begins at RVA 0x374d
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
			// Method begins at RVA 0x376c
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
			// Method begins at RVA 0x3780
			// Header size: 12
			// Code size: 212 (0xd4)
			.maxstack 3
			.locals init (
				[0] int32,
				[1] int32
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>1__state'
			IL_0006: stloc.0
			IL_0007: ldloc.0
			IL_0008: switch (IL_001b, IL_004d, IL_00b4)

			IL_0019: ldc.i4.0
			IL_001a: ret

			IL_001b: ldarg.0
			IL_001c: ldc.i4.m1
			IL_001d: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>1__state'

			IL_0022: ldarg.0
			IL_0023: ldarg.0
			IL_0024: ldfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::behind
			IL_0029: callvirt instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32>::TakeAsync()
			IL_002e: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<next>5__2'
			IL_0033: ldarg.0
			IL_0034: ldarg.0
			IL_0035: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<next>5__2'
			IL_003a: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture [MMP.AsyncProxy]MMP.AsyncProxy.Futures::Observe(class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture)
			IL_003f: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>2__current'
			IL_0044: ldarg.0
			IL_0045: ldc.i4.1
			IL_0046: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>1__state'
			IL_004b: ldc.i4.1
			IL_004c: ret

			IL_004d: ldarg.0
			IL_004e: ldc.i4.m1
			IL_004f: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>1__state'
			IL_0054: ldarg.0
			IL_0055: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<next>5__2'
			IL_005a: callvirt instance bool [MMP.AsyncProxy]MMP.AsyncProxy.IFuture::get_IsCanceled()
			IL_005f: brtrue.s IL_00c7

			IL_0061: nop
			.try
			{
				IL_0062: ldarg.0
				IL_0063: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<next>5__2'
				IL_0068: callvirt instance !0 class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32>::get_Result()
				IL_006d: call int32 MMP.AsyncProxy.Training.Pipeline.Stages::Enrich(int32)
				IL_0072: stloc.1
				IL_0073: leave.s IL_0099
			} // end .try
			catch [mscorlib]System.InvalidOperationException
			{
				IL_0075: pop
				IL_0076: ldarg.0
				IL_0077: ldfld class [mscorlib]System.Collections.Generic.List`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::dropped
				IL_007c: ldarg.0
				IL_007d: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<next>5__2'
				IL_0082: callvirt instance !0 class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32>::get_Result()
				IL_0087: callvirt instance void class [mscorlib]System.Collections.Generic.List`1<int32>::Add(!0)
				IL_008c: ldarg.0
				IL_008d: ldfld class MMP.AsyncProxy.Training.Pipeline.InFlightMeter MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::meter
				IL_0092: callvirt instance void MMP.AsyncProxy.Training.Pipeline.InFlightMeter::Left()
				IL_0097: leave.s IL_0022
			} // end handler

			IL_0099: ldarg.0
			IL_009a: ldarg.0
			IL_009b: ldfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::ahead
			IL_00a0: ldloc.1
			IL_00a1: callvirt instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<bool> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32>::PutAsync(!0)
			IL_00a6: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>2__current'
			IL_00ab: ldarg.0
			IL_00ac: ldc.i4.2
			IL_00ad: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>1__state'
			IL_00b2: ldc.i4.1
			IL_00b3: ret

			IL_00b4: ldarg.0
			IL_00b5: ldc.i4.m1
			IL_00b6: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<>1__state'
			IL_00bb: ldarg.0
			IL_00bc: ldnull
			IL_00bd: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::'<next>5__2'
			IL_00c2: br IL_0022

			IL_00c7: ldarg.0
			IL_00c8: ldfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<EnrichStage>d__4'::ahead
			IL_00cd: callvirt instance void class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32>::Close()
			IL_00d2: ldc.i4.0
			IL_00d3: ret
		} // end of method '<EnrichStage>d__4'::MoveNext

		.method private final hidebysig specialname newslot virtual 
			instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance !0 class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::get_Current()
			// Method begins at RVA 0x3870
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
			// Method begins at RVA 0x3878
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
			// Method begins at RVA 0x387f
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
			// Method begins at RVA 0x3888
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
			// Method begins at RVA 0x38f4
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
			// Method begins at RVA 0x38fc
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
			// Method begins at RVA 0x391b
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
			// Method begins at RVA 0x392c
			// Header size: 12
			// Code size: 160 (0xa0)
			.maxstack 3
			.locals init (
				[0] int32,
				[1] int32,
				[2] class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<bool>
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>1__state'
			IL_0006: stloc.0
			IL_0007: ldloc.0
			IL_0008: brfalse.s IL_0010

			IL_000a: ldloc.0
			IL_000b: ldc.i4.1
			IL_000c: beq.s IL_0067

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
			IL_002a: br.s IL_007c

			IL_002c: ldarg.0
			IL_002d: ldfld int32[] MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>7__wrap1'
			IL_0032: ldarg.0
			IL_0033: ldfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>7__wrap2'
			IL_0038: ldelem.i4
			IL_0039: stloc.1
			IL_003a: ldarg.0
			IL_003b: ldfld class MMP.AsyncProxy.Training.Pipeline.InFlightMeter MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::meter
			IL_0040: callvirt instance void MMP.AsyncProxy.Training.Pipeline.InFlightMeter::Entered()
			IL_0045: ldarg.0
			IL_0046: ldfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::ahead
			IL_004b: ldloc.1
			IL_004c: call int32 MMP.AsyncProxy.Training.Pipeline.Stages::Parse(int32)
			IL_0051: callvirt instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<bool> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32>::PutAsync(!0)
			IL_0056: stloc.2
			IL_0057: ldarg.0
			IL_0058: ldloc.2
			IL_0059: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>2__current'
			IL_005e: ldarg.0
			IL_005f: ldc.i4.1
			IL_0060: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>1__state'
			IL_0065: ldc.i4.1
			IL_0066: ret

			IL_0067: ldarg.0
			IL_0068: ldc.i4.m1
			IL_0069: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>1__state'
			IL_006e: ldarg.0
			IL_006f: ldarg.0
			IL_0070: ldfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>7__wrap2'
			IL_0075: ldc.i4.1
			IL_0076: add
			IL_0077: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>7__wrap2'

			IL_007c: ldarg.0
			IL_007d: ldfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>7__wrap2'
			IL_0082: ldarg.0
			IL_0083: ldfld int32[] MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>7__wrap1'
			IL_0088: ldlen
			IL_0089: conv.i4
			IL_008a: blt.s IL_002c

			IL_008c: ldarg.0
			IL_008d: ldnull
			IL_008e: stfld int32[] MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::'<>7__wrap1'
			IL_0093: ldarg.0
			IL_0094: ldfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<ParseStage>d__3'::ahead
			IL_0099: callvirt instance void class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32>::Close()
			IL_009e: ldc.i4.0
			IL_009f: ret
		} // end of method '<ParseStage>d__3'::MoveNext

		.method private final hidebysig specialname newslot virtual 
			instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance !0 class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::get_Current()
			// Method begins at RVA 0x39d8
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
			// Method begins at RVA 0x39e0
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
			// Method begins at RVA 0x39e7
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
			// Method begins at RVA 0x39f0
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
			// Method begins at RVA 0x3a50
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
			// Method begins at RVA 0x3a58
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
			// Method begins at RVA 0x3a77
			// Header size: 1
			// Code size: 16 (0x10)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldnull
			IL_0002: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<next>5__2'
			IL_0007: ldarg.0
			IL_0008: ldc.i4.s -2
			IL_000a: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>1__state'
			IL_000f: ret
		} // end of method '<WriteStage>d__5'::System.IDisposable.Dispose

		.method private final hidebysig newslot virtual 
			instance bool MoveNext () cil managed 
		{
			.override method instance bool [mscorlib]System.Collections.IEnumerator::MoveNext()
			// Method begins at RVA 0x3a88
			// Header size: 12
			// Code size: 186 (0xba)
			.maxstack 2
			.locals init (
				[0] int32
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>1__state'
			IL_0006: stloc.0
			IL_0007: ldloc.0
			IL_0008: switch (IL_001b, IL_004d, IL_0084)

			IL_0019: ldc.i4.0
			IL_001a: ret

			IL_001b: ldarg.0
			IL_001c: ldc.i4.m1
			IL_001d: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>1__state'

			IL_0022: ldarg.0
			IL_0023: ldarg.0
			IL_0024: ldfld class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::behind
			IL_0029: callvirt instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<int32>::TakeAsync()
			IL_002e: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<next>5__2'
			IL_0033: ldarg.0
			IL_0034: ldarg.0
			IL_0035: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<next>5__2'
			IL_003a: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture [MMP.AsyncProxy]MMP.AsyncProxy.Futures::Observe(class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture)
			IL_003f: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>2__current'
			IL_0044: ldarg.0
			IL_0045: ldc.i4.1
			IL_0046: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>1__state'
			IL_004b: ldc.i4.1
			IL_004c: ret

			IL_004d: ldarg.0
			IL_004e: ldc.i4.m1
			IL_004f: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>1__state'
			IL_0054: ldarg.0
			IL_0055: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<next>5__2'
			IL_005a: callvirt instance bool [MMP.AsyncProxy]MMP.AsyncProxy.IFuture::get_IsCanceled()
			IL_005f: brtrue.s IL_00b8

			IL_0061: ldarg.0
			IL_0062: ldfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::writeDelayMs
			IL_0067: ldc.i4.0
			IL_0068: ble.s IL_008b

			IL_006a: ldarg.0
			IL_006b: ldarg.0
			IL_006c: ldfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::writeDelayMs
			IL_0071: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture [MMP.AsyncProxy]MMP.AsyncProxy.Futures::Delay(int32)
			IL_0076: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>2__current'
			IL_007b: ldarg.0
			IL_007c: ldc.i4.2
			IL_007d: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>1__state'
			IL_0082: ldc.i4.1
			IL_0083: ret

			IL_0084: ldarg.0
			IL_0085: ldc.i4.m1
			IL_0086: stfld int32 MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<>1__state'

			IL_008b: ldarg.0
			IL_008c: ldfld class [mscorlib]System.Collections.Generic.List`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::outputs
			IL_0091: ldarg.0
			IL_0092: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<next>5__2'
			IL_0097: callvirt instance !0 class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32>::get_Result()
			IL_009c: callvirt instance void class [mscorlib]System.Collections.Generic.List`1<int32>::Add(!0)
			IL_00a1: ldarg.0
			IL_00a2: ldfld class MMP.AsyncProxy.Training.Pipeline.InFlightMeter MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::meter
			IL_00a7: callvirt instance void MMP.AsyncProxy.Training.Pipeline.InFlightMeter::Left()
			IL_00ac: ldarg.0
			IL_00ad: ldnull
			IL_00ae: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<int32> MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine/'<WriteStage>d__5'::'<next>5__2'
			IL_00b3: br IL_0022

			IL_00b8: ldc.i4.0
			IL_00b9: ret
		} // end of method '<WriteStage>d__5'::MoveNext

		.method private final hidebysig specialname newslot virtual 
			instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance !0 class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::get_Current()
			// Method begins at RVA 0x3b4e
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
			// Method begins at RVA 0x3b56
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
			// Method begins at RVA 0x3b5d
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
			// Method begins at RVA 0x3b68
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
			// Method begins at RVA 0x3bd4
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
		// Method begins at RVA 0x240e
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
		// Method begins at RVA 0x2418
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
		// Method begins at RVA 0x2494
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
		// Method begins at RVA 0x24b2
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
		// Method begins at RVA 0x24d7
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
		// Method begins at RVA 0x24fc
		// Header size: 1
		// Code size: 1 (0x1)
		.maxstack 8

		IL_0000: ret
	} // end of method IteratorLine::Dispose

	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x24fe
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
		// Method begins at RVA 0x2506
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
		instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<bool> PutAsync (
			!T item
		) cil managed 
	{
		// Method begins at RVA 0x252c
		// Header size: 12
		// Code size: 160 (0xa0)
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
			IL_0015: brfalse.s IL_0020

			IL_0017: ldc.i4.0
			IL_0018: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<bool> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::Done(bool)
			IL_001d: stloc.2
			IL_001e: leave.s IL_009e

			IL_0020: ldarg.0
			IL_0021: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingTaker
			IL_0026: brfalse.s IL_0038

			IL_0028: ldarg.0
			IL_0029: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingTaker
			IL_002e: stloc.0
			IL_002f: ldarg.0
			IL_0030: ldnull
			IL_0031: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingTaker
			IL_0036: leave.s IL_008f

			IL_0038: ldarg.0
			IL_0039: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_items
			IL_003e: callvirt instance int32 class [System]System.Collections.Generic.Queue`1<!T>::get_Count()
			IL_0043: ldarg.0
			IL_0044: ldfld int32 class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_capacity
			IL_0049: bge.s IL_0060

			IL_004b: ldarg.0
			IL_004c: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_items
			IL_0051: ldarg.1
			IL_0052: callvirt instance void class [System]System.Collections.Generic.Queue`1<!T>::Enqueue(!0)
			IL_0057: ldc.i4.1
			IL_0058: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<bool> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::Done(bool)
			IL_005d: stloc.2
			IL_005e: leave.s IL_009e

			IL_0060: ldarg.0
			IL_0061: ldarg.1
			IL_0062: stfld !0 class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_held
			IL_0067: ldarg.0
			IL_0068: ldc.i4.1
			IL_0069: stfld bool class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_holding
			IL_006e: ldarg.0
			IL_006f: ldc.i4.1
			IL_0070: newobj instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool>::.ctor(bool)
			IL_0075: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingPutter
			IL_007a: ldarg.0
			IL_007b: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingPutter
			IL_0080: callvirt instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool>::get_Future()
			IL_0085: stloc.2
			IL_0086: leave.s IL_009e
		} // end .try
		finally
		{
			IL_0088: ldloc.1
			IL_0089: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_008e: endfinally
		} // end handler

		IL_008f: ldloc.0
		IL_0090: ldarg.1
		IL_0091: callvirt instance bool class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::TrySetResult(!0)
		IL_0096: pop
		IL_0097: ldc.i4.1
		IL_0098: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<bool> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::Done(bool)
		IL_009d: ret

		IL_009e: ldloc.2
		IL_009f: ret
	} // end of method PromiseTray`1::PutAsync

	.method public hidebysig 
		instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!T> TakeAsync () cil managed 
	{
		// Method begins at RVA 0x25e8
		// Header size: 12
		// Code size: 237 (0xed)
		.maxstack 3
		.locals init (
			[0] class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool>,
			[1] !T,
			[2] object,
			[3] class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!T>
		)

		IL_0000: ldnull
		IL_0001: stloc.0
		IL_0002: ldarg.0
		IL_0003: ldfld object class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_gate
		IL_0008: stloc.2
		IL_0009: ldloc.2
		IL_000a: call void [mscorlib]System.Threading.Monitor::Enter(object)
		.try
		{
			IL_000f: ldarg.0
			IL_0010: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_items
			IL_0015: callvirt instance int32 class [System]System.Collections.Generic.Queue`1<!T>::get_Count()
			IL_001a: ldc.i4.0
			IL_001b: ble.s IL_0068

			IL_001d: ldarg.0
			IL_001e: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_items
			IL_0023: callvirt instance !0 class [System]System.Collections.Generic.Queue`1<!T>::Dequeue()
			IL_0028: stloc.1
			IL_0029: ldarg.0
			IL_002a: ldfld bool class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_holding
			IL_002f: brfalse IL_00c4

			IL_0034: ldarg.0
			IL_0035: ldfld class [System]System.Collections.Generic.Queue`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_items
			IL_003a: ldarg.0
			IL_003b: ldfld !0 class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_held
			IL_0040: callvirt instance void class [System]System.Collections.Generic.Queue`1<!T>::Enqueue(!0)
			IL_0045: ldarg.0
			IL_0046: ldflda !0 class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_held
			IL_004b: initobj !T
			IL_0051: ldarg.0
			IL_0052: ldc.i4.0
			IL_0053: stfld bool class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_holding
			IL_0058: ldarg.0
			IL_0059: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingPutter
			IL_005e: stloc.0
			IL_005f: ldarg.0
			IL_0060: ldnull
			IL_0061: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingPutter
			IL_0066: leave.s IL_00cd

			IL_0068: ldarg.0
			IL_0069: ldfld bool class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_holding
			IL_006e: brfalse.s IL_009a

			IL_0070: ldarg.0
			IL_0071: ldfld !0 class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_held
			IL_0076: stloc.1
			IL_0077: ldarg.0
			IL_0078: ldflda !0 class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_held
			IL_007d: initobj !T
			IL_0083: ldarg.0
			IL_0084: ldc.i4.0
			IL_0085: stfld bool class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_holding
			IL_008a: ldarg.0
			IL_008b: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingPutter
			IL_0090: stloc.0
			IL_0091: ldarg.0
			IL_0092: ldnull
			IL_0093: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingPutter
			IL_0098: leave.s IL_00cd

			IL_009a: ldarg.0
			IL_009b: ldfld bool class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_closed
			IL_00a0: brfalse.s IL_00aa

			IL_00a2: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::Cancelled()
			IL_00a7: stloc.3
			IL_00a8: leave.s IL_00eb

			IL_00aa: ldarg.0
			IL_00ab: ldc.i4.1
			IL_00ac: newobj instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::.ctor(bool)
			IL_00b1: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingTaker
			IL_00b6: ldarg.0
			IL_00b7: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!0> class MMP.AsyncProxy.Training.Pipeline.Async.PromiseTray`1<!T>::_waitingTaker
			IL_00bc: callvirt instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::get_Future()
			IL_00c1: stloc.3
			IL_00c2: leave.s IL_00eb

			IL_00c4: leave.s IL_00cd
		} // end .try
		finally
		{
			IL_00c6: ldloc.2
			IL_00c7: call void [mscorlib]System.Threading.Monitor::Exit(object)
			IL_00cc: endfinally
		} // end handler

		IL_00cd: ldloc.0
		IL_00ce: brfalse.s IL_00d8

		IL_00d0: ldloc.0
		IL_00d1: ldc.i4.1
		IL_00d2: callvirt instance bool class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool>::TrySetResult(!0)
		IL_00d7: pop

		IL_00d8: ldc.i4.1
		IL_00d9: newobj instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::.ctor(bool)
		IL_00de: dup
		IL_00df: ldloc.1
		IL_00e0: callvirt instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::SetResult(!0)
		IL_00e5: callvirt instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::get_Future()
		IL_00ea: ret

		IL_00eb: ldloc.3
		IL_00ec: ret
	} // end of method PromiseTray`1::TakeAsync

	.method public hidebysig 
		instance void Close () cil managed 
	{
		// Method begins at RVA 0x26f4
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
		class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<bool> Done (
			bool 'value'
		) cil managed 
	{
		// Method begins at RVA 0x2778
		// Header size: 1
		// Code size: 19 (0x13)
		.maxstack 8

		IL_0000: ldc.i4.1
		IL_0001: newobj instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool>::.ctor(bool)
		IL_0006: dup
		IL_0007: ldarg.0
		IL_0008: callvirt instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool>::SetResult(!0)
		IL_000d: callvirt instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<bool>::get_Future()
		IL_0012: ret
	} // end of method PromiseTray`1::Done

	.method private hidebysig static 
		class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!T> Cancelled () cil managed 
	{
		// Method begins at RVA 0x278c
		// Header size: 1
		// Code size: 18 (0x12)
		.maxstack 8

		IL_0000: ldc.i4.1
		IL_0001: newobj instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::.ctor(bool)
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
		// Method begins at RVA 0x27a0
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
		// Method begins at RVA 0x2815
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
		// Method begins at RVA 0x281d
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
		// Method begins at RVA 0x2827
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
		// Method begins at RVA 0x2834
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
		// Method begins at RVA 0x28cc
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
		// Method begins at RVA 0x291d
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
		// Method begins at RVA 0x293b
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
		// Method begins at RVA 0x2942
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
		// Method begins at RVA 0x294c
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
		// Method begins at RVA 0x299c
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
		// Method begins at RVA 0x2a00
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
		// Method begins at RVA 0x2a13
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
		// Method begins at RVA 0x2a3f
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
		// Method begins at RVA 0x2a47
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
		// Method begins at RVA 0x2a4f
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
		// Method begins at RVA 0x2a5c
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
		// Method begins at RVA 0x2ad4
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
		// Method begins at RVA 0x2b1c
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
		// Method begins at RVA 0x2b94
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
		// Method begins at RVA 0x2ba2
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
		// Method begins at RVA 0x2ba9
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
		// Method begins at RVA 0x2bb4
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
		// Method begins at RVA 0x2c04
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
		// Method begins at RVA 0x2c68
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
	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass16_0'<T>
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
			// Method begins at RVA 0x3bdc
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass16_0'::.ctor

		.method assembly hidebysig 
			instance void '<Dispose>b__0' () cil managed 
		{
			// Method begins at RVA 0x3be4
			// Header size: 1
			// Code size: 13 (0xd)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [mscorlib]System.Threading.ManualResetEvent class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<>c__DisplayClass16_0'<!T>::done
			IL_0006: callvirt instance bool [mscorlib]System.Threading.EventWaitHandle::Set()
			IL_000b: pop
			IL_000c: ret
		} // end of method '<>c__DisplayClass16_0'::'<Dispose>b__0'

	} // end of class <>c__DisplayClass16_0

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
			// Method begins at RVA 0x3bf2
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
			// Method begins at RVA 0x3c11
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
			// Method begins at RVA 0x3c24
			// Header size: 12
			// Code size: 222 (0xde)
			.maxstack 2
			.locals init (
				[0] int32,
				[1] class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>
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
			IL_0013: beq.s IL_004e

			IL_0015: ldc.i4.0
			IL_0016: ret

			IL_0017: ldarg.0
			IL_0018: ldc.i4.m1
			IL_0019: stfld int32 class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<>1__state'
			IL_001e: br IL_00cf

			IL_0023: ldarg.0
			IL_0024: ldloc.1
			IL_0025: ldfld class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_tray
			IL_002a: callvirt instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::TakeAsync()
			IL_002f: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<next>5__2'
			IL_0034: ldarg.0
			IL_0035: ldarg.0
			IL_0036: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<next>5__2'
			IL_003b: call class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture [MMP.AsyncProxy]MMP.AsyncProxy.Futures::Observe(class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture)
			IL_0040: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<>2__current'
			IL_0045: ldarg.0
			IL_0046: ldc.i4.1
			IL_0047: stfld int32 class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<>1__state'
			IL_004c: ldc.i4.1
			IL_004d: ret

			IL_004e: ldarg.0
			IL_004f: ldc.i4.m1
			IL_0050: stfld int32 class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<>1__state'
			IL_0055: ldarg.0
			IL_0056: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<next>5__2'
			IL_005b: callvirt instance bool [MMP.AsyncProxy]MMP.AsyncProxy.IFuture::get_IsCanceled()
			IL_0060: brtrue.s IL_0079

			IL_0062: ldarg.0
			IL_0063: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<next>5__2'
			IL_0068: callvirt instance bool [MMP.AsyncProxy]MMP.AsyncProxy.IFuture::get_IsFaulted()
			IL_006d: brtrue.s IL_0079

			IL_006f: ldloc.1
			IL_0070: volatile.
			IL_0072: ldfld bool modreq([mscorlib]System.Runtime.CompilerServices.IsVolatile) class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_stopping
			IL_0077: brfalse.s IL_007b

			IL_0079: ldc.i4.0
			IL_007a: ret

			IL_007b: ldloc.1
			IL_007c: ldflda int32 class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_busy
			IL_0081: ldc.i4.1
			IL_0082: call int32 [mscorlib]System.Threading.Interlocked::Exchange(int32&, int32)
			IL_0087: pop
			.try
			{
				.try
				{
					IL_0088: ldloc.1
					IL_0089: ldfld class [mscorlib]System.Action`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_handle
					IL_008e: ldarg.0
					IL_008f: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<next>5__2'
					IL_0094: callvirt instance !0 class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!T>::get_Result()
					IL_0099: callvirt instance void class [mscorlib]System.Action`1<!T>::Invoke(!0)
					IL_009e: leave.s IL_00c8
				} // end .try
				catch [mscorlib]System.Exception
				{
					IL_00a0: pop
					IL_00a1: leave.s IL_00c8
				} // end handler
			} // end .try
			finally
			{
				IL_00a3: ldloc.1
				IL_00a4: ldflda int32 class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_handled
				IL_00a9: call int32 [mscorlib]System.Threading.Interlocked::Increment(int32&)
				IL_00ae: pop
				IL_00af: ldloc.1
				IL_00b0: ldfld class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_tray
				IL_00b5: callvirt instance void class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::Handled()
				IL_00ba: ldloc.1
				IL_00bb: ldflda int32 class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_busy
				IL_00c0: ldc.i4.0
				IL_00c1: call int32 [mscorlib]System.Threading.Interlocked::Exchange(int32&, int32)
				IL_00c6: pop
				IL_00c7: endfinally
			} // end handler

			IL_00c8: ldarg.0
			IL_00c9: ldnull
			IL_00ca: stfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<Loop>d__14'<!T>::'<next>5__2'

			IL_00cf: ldloc.1
			IL_00d0: volatile.
			IL_00d2: ldfld bool modreq([mscorlib]System.Runtime.CompilerServices.IsVolatile) class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_stopping
			IL_00d7: brfalse IL_0023

			IL_00dc: ldc.i4.0
			IL_00dd: ret
		} // end of method '<Loop>d__14'::MoveNext

		.method private final hidebysig specialname newslot virtual 
			instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture 'System.Collections.Generic.IEnumerator<MMP.AsyncProxy.IFuture>.get_Current' () cil managed 
		{
			.custom instance void [mscorlib]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance !0 class [mscorlib]System.Collections.Generic.IEnumerator`1<class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture>::get_Current()
			// Method begins at RVA 0x3d2c
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
			// Method begins at RVA 0x3d34
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
			// Method begins at RVA 0x3d3b
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
			// Method begins at RVA 0x3d44
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
			// Method begins at RVA 0x3d8c
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
		// Method begins at RVA 0x2c7b
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
		// Method begins at RVA 0x2ca9
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
		// Method begins at RVA 0x2cb1
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
		// Method begins at RVA 0x2cc1
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
		// Method begins at RVA 0x2cce
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

	.method public final hidebysig newslot virtual 
		instance bool WaitUntilIdle (
			int32 timeoutMs
		) cil managed 
	{
		// Method begins at RVA 0x2ce0
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
		// Method begins at RVA 0x2d34
		// Header size: 12
		// Code size: 106 (0x6a)
		.maxstack 3
		.locals init (
			[0] class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<>c__DisplayClass16_0'<!T>
		)

		IL_0000: ldarg.0
		IL_0001: ldc.i4.1
		IL_0002: volatile.
		IL_0004: stfld bool modreq([mscorlib]System.Runtime.CompilerServices.IsVolatile) class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_stopping
		IL_0009: ldarg.0
		IL_000a: ldfld class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!0> class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_tray
		IL_000f: callvirt instance void class MMP.AsyncProxy.Training.Mailbox.Async.PromiseInTray`1<!T>::Close()
		IL_0014: newobj instance void class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<>c__DisplayClass16_0'<!T>::.ctor()
		IL_0019: stloc.0
		IL_001a: ldloc.0
		IL_001b: ldc.i4.0
		IL_001c: newobj instance void [mscorlib]System.Threading.ManualResetEvent::.ctor(bool)
		IL_0021: stfld class [mscorlib]System.Threading.ManualResetEvent class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<>c__DisplayClass16_0'<!T>::done
		.try
		{
			IL_0026: ldarg.0
			IL_0027: ldfld class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1<!T>::_loop
			IL_002c: callvirt instance class [MMP.AsyncProxy]MMP.AsyncProxy.IAwaiter [MMP.AsyncProxy]MMP.AsyncProxy.IFuture::ContinueOnAnyThread()
			IL_0031: ldloc.0
			IL_0032: ldftn instance void class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<>c__DisplayClass16_0'<!T>::'<Dispose>b__0'()
			IL_0038: newobj instance void [System.Core]System.Action::.ctor(object, native int)
			IL_003d: callvirt instance void [MMP.AsyncProxy]MMP.AsyncProxy.IAwaiter::OnCompleted(class [System.Core]System.Action)
			IL_0042: ldloc.0
			IL_0043: ldfld class [mscorlib]System.Threading.ManualResetEvent class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<>c__DisplayClass16_0'<!T>::done
			IL_0048: ldc.i4 2000
			IL_004d: callvirt instance bool [mscorlib]System.Threading.WaitHandle::WaitOne(int32)
			IL_0052: pop
			IL_0053: leave.s IL_0069
		} // end .try
		finally
		{
			IL_0055: ldloc.0
			IL_0056: ldfld class [mscorlib]System.Threading.ManualResetEvent class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<>c__DisplayClass16_0'<!T>::done
			IL_005b: brfalse.s IL_0068

			IL_005d: ldloc.0
			IL_005e: ldfld class [mscorlib]System.Threading.ManualResetEvent class MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk`1/'<>c__DisplayClass16_0'<!T>::done
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
		// Method begins at RVA 0x2dbc
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
		// Method begins at RVA 0x2de8
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
		// Method begins at RVA 0x2df0
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
		// Method begins at RVA 0x2df8
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
		// Method begins at RVA 0x2e08
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
		// Method begins at RVA 0x2ea0
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
		instance class [MMP.AsyncProxy]MMP.AsyncProxy.IFuture`1<!T> TakeAsync () cil managed 
	{
		// Method begins at RVA 0x2f00
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
			IL_001c: newobj instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::.ctor(bool)
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
			IL_004c: newobj instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::.ctor(bool)
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
		// Method begins at RVA 0x2f8c
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
		// Method begins at RVA 0x2f9a
		// Header size: 1
		// Code size: 18 (0x12)
		.maxstack 8

		IL_0000: ldc.i4.1
		IL_0001: newobj instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<!T>::.ctor(bool)
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
			// Method begins at RVA 0x3d94
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
			// Method begins at RVA 0x3d9c
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
			// Method begins at RVA 0x3db0
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
			// Method begins at RVA 0x3dcf
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
			// Method begins at RVA 0x3de0
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
			// Method begins at RVA 0x3ee5
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
			// Method begins at RVA 0x3eed
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
			// Method begins at RVA 0x3ef4
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
			// Method begins at RVA 0x3efc
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
			// Method begins at RVA 0x3f5c
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
		// Method begins at RVA 0x2fad
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
		// Method begins at RVA 0x2fb4
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
		// Method begins at RVA 0x2fde
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
		// Method begins at RVA 0x2ffc
		// Header size: 1
		// Code size: 1 (0x1)
		.maxstack 8

		IL_0000: ret
	} // end of method WhenAllCourier::Dispose

	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x2ffe
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
		// Method begins at RVA 0x3006
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
		// Method begins at RVA 0x3023
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
		// Method begins at RVA 0x302b
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
		// Method begins at RVA 0x3033
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
		// Method begins at RVA 0x303b
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
			// Method begins at RVA 0x3f64
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
			// Method begins at RVA 0x3f6c
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
			// Method begins at RVA 0x3f80
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
			// Method begins at RVA 0x3f9f
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
			// Method begins at RVA 0x3fac
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
			// Method begins at RVA 0x4010
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
			// Method begins at RVA 0x4018
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
			// Method begins at RVA 0x401f
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
			// Method begins at RVA 0x4028
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
			// Method begins at RVA 0x4088
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
		// Method begins at RVA 0x3046
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
		// Method begins at RVA 0x3060
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
		// Method begins at RVA 0x3068
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
		// Method begins at RVA 0x3078
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
		// Method begins at RVA 0x3086
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
		// Method begins at RVA 0x30ad
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
		// Method begins at RVA 0x30c1
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
		// Method begins at RVA 0x30e6
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
			// Method begins at RVA 0x4090
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
			// Method begins at RVA 0x4098
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
			// Method begins at RVA 0x40a0
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
		// Method begins at RVA 0x3104
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
		// Method begins at RVA 0x310c
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
		// Method begins at RVA 0x31ec
		// Header size: 1
		// Code size: 1 (0x1)
		.maxstack 8

		IL_0000: ret
	} // end of method ThreadPerLetterCourier::Dispose

	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x31ee
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
		// Method begins at RVA 0x31f6
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
		// Method begins at RVA 0x3213
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
		// Method begins at RVA 0x321b
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
		// Method begins at RVA 0x3223
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
		// Method begins at RVA 0x322c
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
		// Method begins at RVA 0x3268
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
		// Method begins at RVA 0x32bc
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
		// Method begins at RVA 0x3318
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
			// Method begins at RVA 0x4148
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
			// Method begins at RVA 0x4150
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
			// Method begins at RVA 0x416a
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
			// Method begins at RVA 0x4189
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
			// Method begins at RVA 0x4194
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
			// Method begins at RVA 0x41f8
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
			// Method begins at RVA 0x4200
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
			// Method begins at RVA 0x4207
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
			// Method begins at RVA 0x4210
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
			// Method begins at RVA 0x427c
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
		// Method begins at RVA 0x332b
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
		// Method begins at RVA 0x3346
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
		// Method begins at RVA 0x3355
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
		// Method begins at RVA 0x337c
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
		// Method begins at RVA 0x33ac
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
		// Method begins at RVA 0x33e0
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
		IL_0030: newobj instance void class [MMP.AsyncProxy]MMP.AsyncProxy.Promise`1<string>::.ctor(bool)
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
		// Method begins at RVA 0x3439
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
	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass2_0'
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
			// Method begins at RVA 0x4284
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass2_0'::.ctor

		.method assembly hidebysig 
			instance void '<Call>b__0' () cil managed 
		{
			// Method begins at RVA 0x428c
			// Header size: 1
			// Code size: 13 (0xd)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld class [mscorlib]System.Threading.ManualResetEvent MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass2_0'::gaveUp
			IL_0006: callvirt instance bool [mscorlib]System.Threading.EventWaitHandle::Set()
			IL_000b: pop
			IL_000c: ret
		} // end of method '<>c__DisplayClass2_0'::'<Call>b__0'

	} // end of class <>c__DisplayClass2_0

	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass2_1'
		extends [mscorlib]System.Object
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field public string[] slot
		.field public int32 which
		.field public class [mscorlib]System.Threading.ManualResetEvent answered
		.field public class MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass2_0' 'CS$<>8__locals1'

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor () cil managed 
		{
			// Method begins at RVA 0x429a
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [mscorlib]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass2_1'::.ctor

		.method assembly hidebysig 
			instance void '<Call>b__1' () cil managed 
		{
			// Method begins at RVA 0x42a2
			// Header size: 1
			// Code size: 43 (0x2b)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldfld string[] MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass2_1'::slot
			IL_0006: ldc.i4.0
			IL_0007: ldarg.0
			IL_0008: ldfld class MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass2_0' MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass2_1'::'CS$<>8__locals1'
			IL_000d: ldfld class MMP.AsyncProxy.Training.Deadline.FlakyService MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass2_0'::service
			IL_0012: ldarg.0
			IL_0013: ldfld int32 MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass2_1'::which
			IL_0018: callvirt instance string MMP.AsyncProxy.Training.Deadline.FlakyService::Ask(int32)
			IL_001d: stelem.ref
			IL_001e: ldarg.0
			IL_001f: ldfld class [mscorlib]System.Threading.ManualResetEvent MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass2_1'::answered
			IL_0024: callvirt instance bool [mscorlib]System.Threading.EventWaitHandle::Set()
			IL_0029: pop
			IL_002a: ret
		} // end of method '<>c__DisplayClass2_1'::'<Call>b__1'

	} // end of class <>c__DisplayClass2_1


	// Methods
	.method public final hidebysig specialname newslot virtual 
		instance string get_Version () cil managed 
	{
		// Method begins at RVA 0x345e
		// Header size: 1
		// Code size: 6 (0x6)
		.maxstack 8

		IL_0000: ldstr "threaded"
		IL_0005: ret
	} // end of method ThreadPerAttemptCaller::get_Version

	.method public final hidebysig newslot virtual 
		instance class MMP.AsyncProxy.Training.Deadline.CallResult Call (
			class MMP.AsyncProxy.Training.Deadline.FlakyService service,
			int32 timeoutMs,
			int32 maxAttempts,
			class MMP.AsyncProxy.Training.Deadline.GiveUp giveUp
		) cil managed 
	{
		// Method begins at RVA 0x3468
		// Header size: 12
		// Code size: 258 (0x102)
		.maxstack 4
		.locals init (
			[0] class MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass2_0',
			[1] int32,
			[2] class MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass2_1',
			[3] int32
		)

		IL_0000: newobj instance void MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass2_0'::.ctor()
		IL_0005: stloc.0
		IL_0006: ldloc.0
		IL_0007: ldarg.1
		IL_0008: stfld class MMP.AsyncProxy.Training.Deadline.FlakyService MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass2_0'::service
		IL_000d: ldloc.0
		IL_000e: ldc.i4.0
		IL_000f: newobj instance void [mscorlib]System.Threading.ManualResetEvent::.ctor(bool)
		IL_0014: stfld class [mscorlib]System.Threading.ManualResetEvent MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass2_0'::gaveUp
		IL_0019: ldarg.s giveUp
		IL_001b: ldloc.0
		IL_001c: ldftn instance void MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass2_0'::'<Call>b__0'()
		IL_0022: newobj instance void [System.Core]System.Action::.ctor(object, native int)
		IL_0027: callvirt instance void MMP.AsyncProxy.Training.Deadline.GiveUp::OnFired(class [System.Core]System.Action)
		IL_002c: ldc.i4.0
		IL_002d: stloc.1
		IL_002e: br IL_00f2
		// loop start (head: IL_00f2)
			IL_0033: newobj instance void MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass2_1'::.ctor()
			IL_0038: stloc.2
			IL_0039: ldloc.2
			IL_003a: ldloc.0
			IL_003b: stfld class MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass2_0' MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass2_1'::'CS$<>8__locals1'
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
			IL_0059: stfld string[] MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass2_1'::slot
			IL_005e: ldloc.2
			IL_005f: ldc.i4.0
			IL_0060: newobj instance void [mscorlib]System.Threading.ManualResetEvent::.ctor(bool)
			IL_0065: stfld class [mscorlib]System.Threading.ManualResetEvent MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass2_1'::answered
			IL_006a: ldloc.2
			IL_006b: ldloc.1
			IL_006c: stfld int32 MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass2_1'::which
			IL_0071: ldloc.2
			IL_0072: ldftn instance void MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass2_1'::'<Call>b__1'()
			IL_0078: newobj instance void [mscorlib]System.Threading.ThreadStart::.ctor(object, native int)
			IL_007d: newobj instance void [mscorlib]System.Threading.Thread::.ctor(class [mscorlib]System.Threading.ThreadStart)
			IL_0082: dup
			IL_0083: ldc.i4.1
			IL_0084: callvirt instance void [mscorlib]System.Threading.Thread::set_IsBackground(bool)
			IL_0089: dup
			IL_008a: ldstr "attempt:"
			IL_008f: ldloca.s 1
			IL_0091: call instance string [mscorlib]System.Int32::ToString()
			IL_0096: call string [mscorlib]System.String::Concat(string, string)
			IL_009b: callvirt instance void [mscorlib]System.Threading.Thread::set_Name(string)
			IL_00a0: callvirt instance void [mscorlib]System.Threading.Thread::Start()
			IL_00a5: ldc.i4.2
			IL_00a6: newarr [mscorlib]System.Threading.WaitHandle
			IL_00ab: dup
			IL_00ac: ldc.i4.0
			IL_00ad: ldloc.2
			IL_00ae: ldfld class [mscorlib]System.Threading.ManualResetEvent MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass2_1'::answered
			IL_00b3: stelem.ref
			IL_00b4: dup
			IL_00b5: ldc.i4.1
			IL_00b6: ldloc.2
			IL_00b7: ldfld class MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass2_0' MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass2_1'::'CS$<>8__locals1'
			IL_00bc: ldfld class [mscorlib]System.Threading.ManualResetEvent MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass2_0'::gaveUp
			IL_00c1: stelem.ref
			IL_00c2: ldarg.2
			IL_00c3: ldc.i4.0
			IL_00c4: call int32 [mscorlib]System.Threading.WaitHandle::WaitAny(class [mscorlib]System.Threading.WaitHandle[], int32, bool)
			IL_00c9: stloc.3
			IL_00ca: ldloc.3
			IL_00cb: brtrue.s IL_00df

			IL_00cd: ldc.i4.0
			IL_00ce: ldloc.2
			IL_00cf: ldfld string[] MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller/'<>c__DisplayClass2_1'::slot
			IL_00d4: ldc.i4.0
			IL_00d5: ldelem.ref
			IL_00d6: ldloc.1
			IL_00d7: ldc.i4.1
			IL_00d8: add
			IL_00d9: newobj instance void MMP.AsyncProxy.Training.Deadline.CallResult::.ctor(valuetype MMP.AsyncProxy.Training.Deadline.CallOutcome, string, int32)
			IL_00de: ret

			IL_00df: ldloc.3
			IL_00e0: ldc.i4.1
			IL_00e1: bne.un.s IL_00ee

			IL_00e3: ldc.i4.2
			IL_00e4: ldnull
			IL_00e5: ldloc.1
			IL_00e6: ldc.i4.1
			IL_00e7: add
			IL_00e8: newobj instance void MMP.AsyncProxy.Training.Deadline.CallResult::.ctor(valuetype MMP.AsyncProxy.Training.Deadline.CallOutcome, string, int32)
			IL_00ed: ret

			IL_00ee: ldloc.1
			IL_00ef: ldc.i4.1
			IL_00f0: add
			IL_00f1: stloc.1

			IL_00f2: ldloc.1
			IL_00f3: ldarg.3
			IL_00f4: blt IL_0033
		// end loop

		IL_00f9: ldc.i4.1
		IL_00fa: ldnull
		IL_00fb: ldarg.3
		IL_00fc: newobj instance void MMP.AsyncProxy.Training.Deadline.CallResult::.ctor(valuetype MMP.AsyncProxy.Training.Deadline.CallOutcome, string, int32)
		IL_0101: ret
	} // end of method ThreadPerAttemptCaller::Call

	.method public final hidebysig newslot virtual 
		instance void Dispose () cil managed 
	{
		// Method begins at RVA 0x3576
		// Header size: 1
		// Code size: 1 (0x1)
		.maxstack 8

		IL_0000: ret
	} // end of method ThreadPerAttemptCaller::Dispose

	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x3578
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: call instance void [mscorlib]System.Object::.ctor()
		IL_0006: ret
	} // end of method ThreadPerAttemptCaller::.ctor

	// Properties
	.property instance string Version()
	{
		.get instance string MMP.AsyncProxy.Training.Deadline.Threaded.ThreadPerAttemptCaller::get_Version()
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
			// Method begins at RVA 0x42ce
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
			// Method begins at RVA 0x42d6
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
			// Method begins at RVA 0x42fb
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
			// Method begins at RVA 0x431a
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
			// Method begins at RVA 0x4334
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
			// Method begins at RVA 0x449b
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
			// Method begins at RVA 0x44a3
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
			// Method begins at RVA 0x44aa
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
			// Method begins at RVA 0x44b4
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
			// Method begins at RVA 0x452c
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
		// Method begins at RVA 0x3580
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
		// Method begins at RVA 0x3588
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
		// Method begins at RVA 0x35e9
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
		// Method begins at RVA 0x3616
		// Header size: 1
		// Code size: 1 (0x1)
		.maxstack 8

		IL_0000: ret
	} // end of method WhenAnyCaller::Dispose

	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x3618
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

You are not using the latest version of the tool, please update.
Latest version is '11.2.0.10050' (yours is '10.0.1.8346')
