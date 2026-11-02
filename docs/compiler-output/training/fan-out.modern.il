// IL code: MMP.AsyncProxy.Training.Modern
.class private auto ansi '<Module>'
{
} // end of class <Module>

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Modern.Mailbox.ModernDesk
	extends [System.Runtime]System.Object
	implements [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.Mailbox.IDesk,
	           [System.Runtime]System.IDisposable
{
	.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableContextAttribute::.ctor(uint8) = (
		01 00 01 00 00
	)
	.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
		01 00 00 00 00
	)
	.interfaceimpl type [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.Mailbox.IDesk
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
			01 00 00 00 00
		)

	.interfaceimpl type [System.Runtime]System.IDisposable
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
			01 00 00 00 00
		)

	// Fields
	.field private initonly class [System.Collections]System.Collections.Generic.List`1<class [System.Runtime]System.IDisposable> _seated

	// Methods
	.method public final hidebysig specialname newslot virtual 
		instance string get_Version () cil managed 
	{
		// Method begins at RVA 0x2050
		// Header size: 1
		// Code size: 6 (0x6)
		.maxstack 8

		IL_0000: ldstr "modern"
		IL_0005: ret
	} // end of method ModernDesk::get_Version

	.method public final hidebysig newslot virtual 
		instance class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.Mailbox.IInTray`1<!!T> OpenTray<T> (
			string name,
			int32 capacity
		) cil managed 
	{
		.param type T
			.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
				01 00 02 00 00
			)
		// Method begins at RVA 0x2057
		// Header size: 1
		// Code size: 8 (0x8)
		.maxstack 8

		IL_0000: ldarg.1
		IL_0001: ldarg.2
		IL_0002: newobj instance void class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!!T>::.ctor(string, int32)
		IL_0007: ret
	} // end of method ModernDesk::OpenTray

	.method public final hidebysig newslot virtual 
		instance class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.Mailbox.IClerk Seat<T> (
			string name,
			class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.Mailbox.IInTray`1<!!T> tray,
			class [System.Runtime]System.Action`1<!!T> handle
		) cil managed 
	{
		.param type T
			.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
				01 00 02 00 00
			)
		// Method begins at RVA 0x2060
		// Header size: 12
		// Code size: 57 (0x39)
		.maxstack 3
		.locals init (
			[0] class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1<!!T>,
			[1] class [System.Collections]System.Collections.Generic.List`1<class [System.Runtime]System.IDisposable>,
			[2] bool
		)

		IL_0000: ldarg.1
		IL_0001: ldarg.2
		IL_0002: castclass class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!!T>
		IL_0007: ldarg.3
		IL_0008: newobj instance void class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1<!!T>::.ctor(string, class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!0>, class [System.Runtime]System.Action`1<!0>)
		IL_000d: stloc.0
		IL_000e: ldarg.0
		IL_000f: ldfld class [System.Collections]System.Collections.Generic.List`1<class [System.Runtime]System.IDisposable> MMP.AsyncProxy.Training.Modern.Mailbox.ModernDesk::_seated
		IL_0014: stloc.1
		IL_0015: ldc.i4.0
		IL_0016: stloc.2
		.try
		{
			IL_0017: ldloc.1
			IL_0018: ldloca.s 2
			IL_001a: call void [System.Threading]System.Threading.Monitor::Enter(object, bool&)
			IL_001f: ldarg.0
			IL_0020: ldfld class [System.Collections]System.Collections.Generic.List`1<class [System.Runtime]System.IDisposable> MMP.AsyncProxy.Training.Modern.Mailbox.ModernDesk::_seated
			IL_0025: ldloc.0
			IL_0026: callvirt instance void class [System.Collections]System.Collections.Generic.List`1<class [System.Runtime]System.IDisposable>::Add(!0)
			IL_002b: leave.s IL_0037
		} // end .try
		finally
		{
			IL_002d: ldloc.2
			IL_002e: brfalse.s IL_0036

			IL_0030: ldloc.1
			IL_0031: call void [System.Threading]System.Threading.Monitor::Exit(object)

			IL_0036: endfinally
		} // end handler

		IL_0037: ldloc.0
		IL_0038: ret
	} // end of method ModernDesk::Seat

	.method public final hidebysig newslot virtual 
		instance void Dispose () cil managed 
	{
		// Method begins at RVA 0x20b8
		// Header size: 12
		// Code size: 82 (0x52)
		.maxstack 2
		.locals init (
			[0] class [System.Runtime]System.IDisposable[],
			[1] class [System.Collections]System.Collections.Generic.List`1<class [System.Runtime]System.IDisposable>,
			[2] bool,
			[3] class [System.Runtime]System.IDisposable[],
			[4] int32
		)

		IL_0000: ldarg.0
		IL_0001: ldfld class [System.Collections]System.Collections.Generic.List`1<class [System.Runtime]System.IDisposable> MMP.AsyncProxy.Training.Modern.Mailbox.ModernDesk::_seated
		IL_0006: stloc.1
		IL_0007: ldc.i4.0
		IL_0008: stloc.2
		.try
		{
			IL_0009: ldloc.1
			IL_000a: ldloca.s 2
			IL_000c: call void [System.Threading]System.Threading.Monitor::Enter(object, bool&)
			IL_0011: ldarg.0
			IL_0012: ldfld class [System.Collections]System.Collections.Generic.List`1<class [System.Runtime]System.IDisposable> MMP.AsyncProxy.Training.Modern.Mailbox.ModernDesk::_seated
			IL_0017: callvirt instance !0[] class [System.Collections]System.Collections.Generic.List`1<class [System.Runtime]System.IDisposable>::ToArray()
			IL_001c: stloc.0
			IL_001d: ldarg.0
			IL_001e: ldfld class [System.Collections]System.Collections.Generic.List`1<class [System.Runtime]System.IDisposable> MMP.AsyncProxy.Training.Modern.Mailbox.ModernDesk::_seated
			IL_0023: callvirt instance void class [System.Collections]System.Collections.Generic.List`1<class [System.Runtime]System.IDisposable>::Clear()
			IL_0028: leave.s IL_0034
		} // end .try
		finally
		{
			IL_002a: ldloc.2
			IL_002b: brfalse.s IL_0033

			IL_002d: ldloc.1
			IL_002e: call void [System.Threading]System.Threading.Monitor::Exit(object)

			IL_0033: endfinally
		} // end handler

		IL_0034: ldloc.0
		IL_0035: stloc.3
		IL_0036: ldc.i4.0
		IL_0037: stloc.s 4
		IL_0039: br.s IL_004a
		// loop start (head: IL_004a)
			IL_003b: ldloc.3
			IL_003c: ldloc.s 4
			IL_003e: ldelem.ref
			IL_003f: callvirt instance void [System.Runtime]System.IDisposable::Dispose()
			IL_0044: ldloc.s 4
			IL_0046: ldc.i4.1
			IL_0047: add
			IL_0048: stloc.s 4

			IL_004a: ldloc.s 4
			IL_004c: ldloc.3
			IL_004d: ldlen
			IL_004e: conv.i4
			IL_004f: blt.s IL_003b
		// end loop

		IL_0051: ret
	} // end of method ModernDesk::Dispose

	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x2128
		// Header size: 1
		// Code size: 18 (0x12)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: newobj instance void class [System.Collections]System.Collections.Generic.List`1<class [System.Runtime]System.IDisposable>::.ctor()
		IL_0006: stfld class [System.Collections]System.Collections.Generic.List`1<class [System.Runtime]System.IDisposable> MMP.AsyncProxy.Training.Modern.Mailbox.ModernDesk::_seated
		IL_000b: ldarg.0
		IL_000c: call instance void [System.Runtime]System.Object::.ctor()
		IL_0011: ret
	} // end of method ModernDesk::.ctor

	// Properties
	.property instance string Version()
	{
		.get instance string MMP.AsyncProxy.Training.Modern.Mailbox.ModernDesk::get_Version()
	}

} // end of class MMP.AsyncProxy.Training.Modern.Mailbox.ModernDesk

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<T>
	extends [System.Runtime]System.Object
	implements class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.Mailbox.IInTray`1<!T>
{
	.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableContextAttribute::.ctor(uint8) = (
		01 00 01 00 00
	)
	.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
		01 00 00 00 00
	)
	.param type T
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
			01 00 02 00 00
		)
	.interfaceimpl type class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.Mailbox.IInTray`1<!T>
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8[]) = (
			01 00 02 00 00 00 00 01 00 00
		)

	// Fields
	.field private string '<name>P'
	.custom instance void [System.Runtime]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
		01 00 00 00
	)
	.field private int32 '<capacity>P'
	.custom instance void [System.Runtime]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
		01 00 00 00
	)
	.field public initonly class [System.Threading.Channels]System.Threading.Channels.Channel`1<!T> Channel
	.field private int32 _pending

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			string name,
			int32 capacity
		) cil managed 
	{
		// Method begins at RVA 0x213b
		// Header size: 1
		// Code size: 50 (0x32)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldarg.1
		IL_0002: stfld string class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!T>::'<name>P'
		IL_0007: ldarg.0
		IL_0008: ldarg.2
		IL_0009: stfld int32 class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!T>::'<capacity>P'
		IL_000e: ldarg.0
		IL_000f: ldarg.0
		IL_0010: ldfld int32 class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!T>::'<capacity>P'
		IL_0015: newobj instance void [System.Threading.Channels]System.Threading.Channels.BoundedChannelOptions::.ctor(int32)
		IL_001a: dup
		IL_001b: ldc.i4.1
		IL_001c: callvirt instance void [System.Threading.Channels]System.Threading.Channels.ChannelOptions::set_SingleReader(bool)
		IL_0021: call class [System.Threading.Channels]System.Threading.Channels.Channel`1<!!0> [System.Threading.Channels]System.Threading.Channels.Channel::CreateBounded<!T>(class [System.Threading.Channels]System.Threading.Channels.BoundedChannelOptions)
		IL_0026: stfld class [System.Threading.Channels]System.Threading.Channels.Channel`1<!0> class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!T>::Channel
		IL_002b: ldarg.0
		IL_002c: call instance void [System.Runtime]System.Object::.ctor()
		IL_0031: ret
	} // end of method ChannelInTray`1::.ctor

	.method public final hidebysig specialname newslot virtual 
		instance string get_Name () cil managed 
	{
		// Method begins at RVA 0x216e
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld string class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!T>::'<name>P'
		IL_0006: ret
	} // end of method ChannelInTray`1::get_Name

	.method public final hidebysig specialname newslot virtual 
		instance int32 get_Capacity () cil managed 
	{
		// Method begins at RVA 0x2176
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld int32 class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!T>::'<capacity>P'
		IL_0006: ret
	} // end of method ChannelInTray`1::get_Capacity

	.method public final hidebysig specialname newslot virtual 
		instance int32 get_Pending () cil managed 
	{
		// Method begins at RVA 0x217e
		// Header size: 1
		// Code size: 12 (0xc)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldflda int32 class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!T>::_pending
		IL_0006: call int32 [System.Threading]System.Threading.Volatile::Read(int32&)
		IL_000b: ret
	} // end of method ChannelInTray`1::get_Pending

	.method public final hidebysig newslot virtual 
		instance bool TryPost (
			!T slip
		) cil managed 
	{
		// Method begins at RVA 0x218b
		// Header size: 1
		// Code size: 35 (0x23)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld class [System.Threading.Channels]System.Threading.Channels.Channel`1<!0> class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!T>::Channel
		IL_0006: callvirt instance class [System.Threading.Channels]System.Threading.Channels.ChannelWriter`1<!0> class [System.Threading.Channels]System.Threading.Channels.Channel`2<!T, !T>::get_Writer()
		IL_000b: ldarg.1
		IL_000c: callvirt instance bool class [System.Threading.Channels]System.Threading.Channels.ChannelWriter`1<!T>::TryWrite(!0)
		IL_0011: brtrue.s IL_0015

		IL_0013: ldc.i4.0
		IL_0014: ret

		IL_0015: ldarg.0
		IL_0016: ldflda int32 class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!T>::_pending
		IL_001b: call int32 [System.Threading]System.Threading.Interlocked::Increment(int32&)
		IL_0020: pop
		IL_0021: ldc.i4.1
		IL_0022: ret
	} // end of method ChannelInTray`1::TryPost

	.method public final hidebysig newslot virtual 
		instance void Close () cil managed 
	{
		// Method begins at RVA 0x21af
		// Header size: 1
		// Code size: 19 (0x13)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld class [System.Threading.Channels]System.Threading.Channels.Channel`1<!0> class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!T>::Channel
		IL_0006: callvirt instance class [System.Threading.Channels]System.Threading.Channels.ChannelWriter`1<!0> class [System.Threading.Channels]System.Threading.Channels.Channel`2<!T, !T>::get_Writer()
		IL_000b: ldnull
		IL_000c: callvirt instance bool class [System.Threading.Channels]System.Threading.Channels.ChannelWriter`1<!T>::TryComplete(class [System.Runtime]System.Exception)
		IL_0011: pop
		IL_0012: ret
	} // end of method ChannelInTray`1::Close

	.method assembly hidebysig 
		instance void Handled () cil managed 
	{
		// Method begins at RVA 0x21c3
		// Header size: 1
		// Code size: 13 (0xd)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldflda int32 class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!T>::_pending
		IL_0006: call int32 [System.Threading]System.Threading.Interlocked::Decrement(int32&)
		IL_000b: pop
		IL_000c: ret
	} // end of method ChannelInTray`1::Handled

	// Properties
	.property instance string Name()
	{
		.get instance string MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1::get_Name()
	}
	.property instance int32 Capacity()
	{
		.get instance int32 MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1::get_Capacity()
	}
	.property instance int32 Pending()
	{
		.get instance int32 MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1::get_Pending()
	}

} // end of class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1<T>
	extends [System.Runtime]System.Object
	implements [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.Mailbox.IClerk,
	           [System.Runtime]System.IDisposable
{
	.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableContextAttribute::.ctor(uint8) = (
		01 00 01 00 00
	)
	.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
		01 00 00 00 00
	)
	.param type T
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
			01 00 02 00 00
		)
	.interfaceimpl type [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.Mailbox.IClerk
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
			01 00 00 00 00
		)

	.interfaceimpl type [System.Runtime]System.IDisposable
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
			01 00 00 00 00
		)

	// Nested Types
	.class nested private auto ansi sealed beforefieldinit '<Loop>d__12'<T>
		extends [System.Runtime]System.ValueType
		implements [System.Runtime]System.Runtime.CompilerServices.IAsyncStateMachine
	{
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		.param type T
			.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
				01 00 02 00 00
			)
		.interfaceimpl type [System.Runtime]System.Runtime.CompilerServices.IAsyncStateMachine
			.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
				01 00 00 00 00
			)

		// Fields
		.field public int32 '<>1__state'
		.field public valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder '<>t__builder'
		.field public class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!T> tray
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8[]) = (
			01 00 02 00 00 00 00 01 00 00
		)
		.field public class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1<!T> '<>4__this'
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
			01 00 00 00 00
		)
		.field public class [System.Runtime]System.Action`1<!T> handle
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8[]) = (
			01 00 02 00 00 00 00 01 00 00
		)
		.field private valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredCancelableAsyncEnumerable`1/Enumerator<!T> '<>7__wrap1'
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
			01 00 00 00 00
		)
		.field private object '<>7__wrap2'
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
			01 00 00 00 00
		)
		.field private int32 '<>7__wrap3'
		.field private valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable`1/ConfiguredValueTaskAwaiter<bool> '<>u__1'
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
			01 00 00 00 00
		)
		.field private valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable/ConfiguredValueTaskAwaiter '<>u__2'

		// Methods
		.method private final hidebysig newslot virtual 
			instance void MoveNext () cil managed 
		{
			.override method instance void [System.Runtime]System.Runtime.CompilerServices.IAsyncStateMachine::MoveNext()
			// Method begins at RVA 0x23b0
			// Header size: 12
			// Code size: 510 (0x1fe)
			.maxstack 3
			.locals init (
				[0] int32,
				[1] class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1<!T>,
				[2] valuetype [System.Runtime]System.Threading.CancellationToken,
				[3] valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredCancelableAsyncEnumerable`1<!T>,
				[4] !T,
				[5] valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable`1/ConfiguredValueTaskAwaiter<bool>,
				[6] valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable`1<bool>,
				[7] object,
				[8] valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable/ConfiguredValueTaskAwaiter,
				[9] valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable,
				[10] class [System.Runtime]System.Exception
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>1__state'
			IL_0006: stloc.0
			IL_0007: ldarg.0
			IL_0008: ldfld class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1<!0> valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>4__this'
			IL_000d: stloc.1
			.try
			{
				IL_000e: ldloc.0
				IL_000f: brfalse.s IL_0058

				IL_0011: ldloc.0
				IL_0012: ldc.i4.1
				IL_0013: beq IL_0175

				IL_0018: ldarg.0
				IL_0019: ldarg.0
				IL_001a: ldfld class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!0> valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::tray
				IL_001f: ldfld class [System.Threading.Channels]System.Threading.Channels.Channel`1<!0> class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!T>::Channel
				IL_0024: callvirt instance class [System.Threading.Channels]System.Threading.Channels.ChannelReader`1<!1> class [System.Threading.Channels]System.Threading.Channels.Channel`2<!T, !T>::get_Reader()
				IL_0029: ldloca.s 2
				IL_002b: initobj [System.Runtime]System.Threading.CancellationToken
				IL_0031: ldloc.2
				IL_0032: callvirt instance class [System.Runtime]System.Collections.Generic.IAsyncEnumerable`1<!0> class [System.Threading.Channels]System.Threading.Channels.ChannelReader`1<!T>::ReadAllAsync(valuetype [System.Runtime]System.Threading.CancellationToken)
				IL_0037: ldc.i4.0
				IL_0038: call valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredCancelableAsyncEnumerable`1<!!0> [System.Runtime]System.Threading.Tasks.TaskAsyncEnumerableExtensions::ConfigureAwait<!T>(class [System.Runtime]System.Collections.Generic.IAsyncEnumerable`1<!!0>, bool)
				IL_003d: stloc.3
				IL_003e: ldloca.s 3
				IL_0040: call instance valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredCancelableAsyncEnumerable`1/Enumerator<!0> valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredCancelableAsyncEnumerable`1<!T>::GetAsyncEnumerator()
				IL_0045: stfld valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredCancelableAsyncEnumerable`1/Enumerator<!0> valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>7__wrap1'
				IL_004a: ldarg.0
				IL_004b: ldnull
				IL_004c: stfld object valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>7__wrap2'
				IL_0051: ldarg.0
				IL_0052: ldc.i4.0
				IL_0053: stfld int32 valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>7__wrap3'

				IL_0058: nop
				.try
				{
					IL_0059: ldloc.0
					IL_005a: brfalse IL_00fb

					IL_005f: br.s IL_00b8

					IL_0061: ldarg.0
					IL_0062: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredCancelableAsyncEnumerable`1/Enumerator<!0> valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>7__wrap1'
					IL_0067: call instance !0 valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredCancelableAsyncEnumerable`1/Enumerator<!T>::get_Current()
					IL_006c: stloc.s 4
					IL_006e: ldloc.1
					IL_006f: ldflda int32 class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1<!T>::_busy
					IL_0074: ldc.i4.1
					IL_0075: call int32 [System.Threading]System.Threading.Interlocked::Exchange(int32&, int32)
					IL_007a: pop
					.try
					{
						.try
						{
							IL_007b: ldarg.0
							IL_007c: ldfld class [System.Runtime]System.Action`1<!0> valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::handle
							IL_0081: ldloc.s 4
							IL_0083: callvirt instance void class [System.Runtime]System.Action`1<!T>::Invoke(!0)
							IL_0088: leave.s IL_008d
						} // end .try
						catch [System.Runtime]System.Exception
						{
							IL_008a: pop
							IL_008b: leave.s IL_008d
						} // end handler

						IL_008d: leave.s IL_00b8
					} // end .try
					finally
					{
						IL_008f: ldloc.0
						IL_0090: ldc.i4.0
						IL_0091: bge.s IL_00b7

						IL_0093: ldloc.1
						IL_0094: ldflda int32 class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1<!T>::_handled
						IL_0099: call int32 [System.Threading]System.Threading.Interlocked::Increment(int32&)
						IL_009e: pop
						IL_009f: ldarg.0
						IL_00a0: ldfld class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!0> valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::tray
						IL_00a5: callvirt instance void class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!T>::Handled()
						IL_00aa: ldloc.1
						IL_00ab: ldflda int32 class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1<!T>::_busy
						IL_00b0: ldc.i4.0
						IL_00b1: call int32 [System.Threading]System.Threading.Interlocked::Exchange(int32&, int32)
						IL_00b6: pop

						IL_00b7: endfinally
					} // end handler

					IL_00b8: ldarg.0
					IL_00b9: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredCancelableAsyncEnumerable`1/Enumerator<!0> valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>7__wrap1'
					IL_00be: call instance valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable`1<bool> valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredCancelableAsyncEnumerable`1/Enumerator<!T>::MoveNextAsync()
					IL_00c3: stloc.s 6
					IL_00c5: ldloca.s 6
					IL_00c7: call instance valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable`1/ConfiguredValueTaskAwaiter<!0> valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable`1<bool>::GetAwaiter()
					IL_00cc: stloc.s 5
					IL_00ce: ldloca.s 5
					IL_00d0: call instance bool valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable`1/ConfiguredValueTaskAwaiter<bool>::get_IsCompleted()
					IL_00d5: brtrue.s IL_0118

					IL_00d7: ldarg.0
					IL_00d8: ldc.i4.0
					IL_00d9: dup
					IL_00da: stloc.0
					IL_00db: stfld int32 valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>1__state'
					IL_00e0: ldarg.0
					IL_00e1: ldloc.s 5
					IL_00e3: stfld valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable`1/ConfiguredValueTaskAwaiter<bool> valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>u__1'
					IL_00e8: ldarg.0
					IL_00e9: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>t__builder'
					IL_00ee: ldloca.s 5
					IL_00f0: ldarg.0
					IL_00f1: call instance void [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder::AwaitUnsafeOnCompleted<valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable`1/ConfiguredValueTaskAwaiter<bool>, valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>>(!!0&, !!1&)
					IL_00f6: leave IL_01fd

					IL_00fb: ldarg.0
					IL_00fc: ldfld valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable`1/ConfiguredValueTaskAwaiter<bool> valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>u__1'
					IL_0101: stloc.s 5
					IL_0103: ldarg.0
					IL_0104: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable`1/ConfiguredValueTaskAwaiter<bool> valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>u__1'
					IL_0109: initobj valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable`1/ConfiguredValueTaskAwaiter<bool>
					IL_010f: ldarg.0
					IL_0110: ldc.i4.m1
					IL_0111: dup
					IL_0112: stloc.0
					IL_0113: stfld int32 valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>1__state'

					IL_0118: ldloca.s 5
					IL_011a: call instance !0 valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable`1/ConfiguredValueTaskAwaiter<bool>::GetResult()
					IL_011f: brtrue IL_0061

					IL_0124: leave.s IL_0132
				} // end .try
				catch [System.Runtime]System.Object
				{
					IL_0126: stloc.s 7
					IL_0128: ldarg.0
					IL_0129: ldloc.s 7
					IL_012b: stfld object valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>7__wrap2'
					IL_0130: leave.s IL_0132
				} // end handler

				IL_0132: ldarg.0
				IL_0133: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredCancelableAsyncEnumerable`1/Enumerator<!0> valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>7__wrap1'
				IL_0138: call instance valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredCancelableAsyncEnumerable`1/Enumerator<!T>::DisposeAsync()
				IL_013d: stloc.s 9
				IL_013f: ldloca.s 9
				IL_0141: call instance valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable/ConfiguredValueTaskAwaiter [System.Runtime]System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable::GetAwaiter()
				IL_0146: stloc.s 8
				IL_0148: ldloca.s 8
				IL_014a: call instance bool [System.Runtime]System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable/ConfiguredValueTaskAwaiter::get_IsCompleted()
				IL_014f: brtrue.s IL_0192

				IL_0151: ldarg.0
				IL_0152: ldc.i4.1
				IL_0153: dup
				IL_0154: stloc.0
				IL_0155: stfld int32 valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>1__state'
				IL_015a: ldarg.0
				IL_015b: ldloc.s 8
				IL_015d: stfld valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable/ConfiguredValueTaskAwaiter valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>u__2'
				IL_0162: ldarg.0
				IL_0163: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>t__builder'
				IL_0168: ldloca.s 8
				IL_016a: ldarg.0
				IL_016b: call instance void [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder::AwaitUnsafeOnCompleted<valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable/ConfiguredValueTaskAwaiter, valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>>(!!0&, !!1&)
				IL_0170: leave IL_01fd

				IL_0175: ldarg.0
				IL_0176: ldfld valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable/ConfiguredValueTaskAwaiter valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>u__2'
				IL_017b: stloc.s 8
				IL_017d: ldarg.0
				IL_017e: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable/ConfiguredValueTaskAwaiter valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>u__2'
				IL_0183: initobj [System.Runtime]System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable/ConfiguredValueTaskAwaiter
				IL_0189: ldarg.0
				IL_018a: ldc.i4.m1
				IL_018b: dup
				IL_018c: stloc.0
				IL_018d: stfld int32 valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>1__state'

				IL_0192: ldloca.s 8
				IL_0194: call instance void [System.Runtime]System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable/ConfiguredValueTaskAwaiter::GetResult()
				IL_0199: ldarg.0
				IL_019a: ldfld object valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>7__wrap2'
				IL_019f: stloc.s 7
				IL_01a1: ldloc.s 7
				IL_01a3: brfalse.s IL_01bc

				IL_01a5: ldloc.s 7
				IL_01a7: isinst [System.Runtime]System.Exception
				IL_01ac: dup
				IL_01ad: brtrue.s IL_01b2

				IL_01af: ldloc.s 7
				IL_01b1: throw

				IL_01b2: call class [System.Runtime]System.Runtime.ExceptionServices.ExceptionDispatchInfo [System.Runtime]System.Runtime.ExceptionServices.ExceptionDispatchInfo::Capture(class [System.Runtime]System.Exception)
				IL_01b7: callvirt instance void [System.Runtime]System.Runtime.ExceptionServices.ExceptionDispatchInfo::Throw()

				IL_01bc: ldarg.0
				IL_01bd: ldnull
				IL_01be: stfld object valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>7__wrap2'
				IL_01c3: ldarg.0
				IL_01c4: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredCancelableAsyncEnumerable`1/Enumerator<!0> valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>7__wrap1'
				IL_01c9: initobj valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredCancelableAsyncEnumerable`1/Enumerator<!T>
				IL_01cf: leave.s IL_01ea
			} // end .try
			catch [System.Runtime]System.Exception
			{
				IL_01d1: stloc.s 10
				IL_01d3: ldarg.0
				IL_01d4: ldc.i4.s -2
				IL_01d6: stfld int32 valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>1__state'
				IL_01db: ldarg.0
				IL_01dc: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>t__builder'
				IL_01e1: ldloc.s 10
				IL_01e3: call instance void [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder::SetException(class [System.Runtime]System.Exception)
				IL_01e8: leave.s IL_01fd
			} // end handler

			IL_01ea: ldarg.0
			IL_01eb: ldc.i4.s -2
			IL_01ed: stfld int32 valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>1__state'
			IL_01f2: ldarg.0
			IL_01f3: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>t__builder'
			IL_01f8: call instance void [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder::SetResult()

			IL_01fd: ret
		} // end of method '<Loop>d__12'::MoveNext

		.method private final hidebysig newslot virtual 
			instance void SetStateMachine (
				class [System.Runtime]System.Runtime.CompilerServices.IAsyncStateMachine stateMachine
			) cil managed 
		{
			.custom instance void [System.Runtime]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [System.Runtime]System.Runtime.CompilerServices.IAsyncStateMachine::SetStateMachine(class [System.Runtime]System.Runtime.CompilerServices.IAsyncStateMachine)
			// Method begins at RVA 0x2620
			// Header size: 1
			// Code size: 13 (0xd)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>t__builder'
			IL_0006: ldarg.1
			IL_0007: call instance void [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder::SetStateMachine(class [System.Runtime]System.Runtime.CompilerServices.IAsyncStateMachine)
			IL_000c: ret
		} // end of method '<Loop>d__12'::SetStateMachine

	} // end of class <Loop>d__12


	// Fields
	.field private initonly class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!T> _tray
	.field private initonly class [System.Runtime]System.Threading.Tasks.Task _loop
	.field private int32 _handled
	.field private int32 _busy
	.field private initonly string '<Name>k__BackingField'
	.custom instance void [System.Runtime]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
		01 00 00 00
	)

	// Methods
	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			string name,
			class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!T> tray,
			class [System.Runtime]System.Action`1<!T> handle
		) cil managed 
	{
		// Method begins at RVA 0x21d1
		// Header size: 1
		// Code size: 35 (0x23)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: call instance void [System.Runtime]System.Object::.ctor()
		IL_0006: ldarg.0
		IL_0007: ldarg.1
		IL_0008: stfld string class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1<!T>::'<Name>k__BackingField'
		IL_000d: ldarg.0
		IL_000e: ldarg.2
		IL_000f: stfld class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!0> class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1<!T>::_tray
		IL_0014: ldarg.0
		IL_0015: ldarg.0
		IL_0016: ldarg.2
		IL_0017: ldarg.3
		IL_0018: call instance class [System.Runtime]System.Threading.Tasks.Task class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1<!T>::Loop(class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!0>, class [System.Runtime]System.Action`1<!0>)
		IL_001d: stfld class [System.Runtime]System.Threading.Tasks.Task class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1<!T>::_loop
		IL_0022: ret
	} // end of method ChannelClerk`1::.ctor

	.method public final hidebysig specialname newslot virtual 
		instance string get_Name () cil managed 
	{
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Method begins at RVA 0x21f5
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld string class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1<!T>::'<Name>k__BackingField'
		IL_0006: ret
	} // end of method ChannelClerk`1::get_Name

	.method public final hidebysig specialname newslot virtual 
		instance bool get_IsRunning () cil managed 
	{
		// Method begins at RVA 0x21fd
		// Header size: 1
		// Code size: 15 (0xf)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld class [System.Runtime]System.Threading.Tasks.Task class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1<!T>::_loop
		IL_0006: callvirt instance bool [System.Runtime]System.Threading.Tasks.Task::get_IsCompleted()
		IL_000b: ldc.i4.0
		IL_000c: ceq
		IL_000e: ret
	} // end of method ChannelClerk`1::get_IsRunning

	.method public final hidebysig specialname newslot virtual 
		instance int32 get_Handled () cil managed 
	{
		// Method begins at RVA 0x220d
		// Header size: 1
		// Code size: 12 (0xc)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldflda int32 class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1<!T>::_handled
		IL_0006: call int32 [System.Threading]System.Threading.Volatile::Read(int32&)
		IL_000b: ret
	} // end of method ChannelClerk`1::get_Handled

	.method private hidebysig 
		instance class [System.Runtime]System.Threading.Tasks.Task Loop (
			class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!T> tray,
			class [System.Runtime]System.Action`1<!T> handle
		) cil managed 
	{
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.AsyncStateMachineAttribute::.ctor(class [System.Runtime]System.Type) = (
			01 00 41 4d 4d 50 2e 41 73 79 6e 63 50 72 6f 78
			79 2e 54 72 61 69 6e 69 6e 67 2e 4d 6f 64 65 72
			6e 2e 4d 61 69 6c 62 6f 78 2e 43 68 61 6e 6e 65
			6c 43 6c 65 72 6b 60 31 2b 3c 4c 6f 6f 70 3e 64
			5f 5f 31 32 00 00
		)
		// Method begins at RVA 0x221c
		// Header size: 12
		// Code size: 71 (0x47)
		.maxstack 2
		.locals init (
			[0] valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>
		)

		IL_0000: ldloca.s 0
		IL_0002: call valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder::Create()
		IL_0007: stfld valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>t__builder'
		IL_000c: ldloca.s 0
		IL_000e: ldarg.0
		IL_000f: stfld class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1<!0> valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>4__this'
		IL_0014: ldloca.s 0
		IL_0016: ldarg.1
		IL_0017: stfld class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!0> valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::tray
		IL_001c: ldloca.s 0
		IL_001e: ldarg.2
		IL_001f: stfld class [System.Runtime]System.Action`1<!0> valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::handle
		IL_0024: ldloca.s 0
		IL_0026: ldc.i4.m1
		IL_0027: stfld int32 valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>1__state'
		IL_002c: ldloca.s 0
		IL_002e: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>t__builder'
		IL_0033: ldloca.s 0
		IL_0035: call instance void [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder::Start<valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>>(!!0&)
		IL_003a: ldloca.s 0
		IL_003c: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder valuetype MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1/'<Loop>d__12'<!T>::'<>t__builder'
		IL_0041: call instance class [System.Runtime]System.Threading.Tasks.Task [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder::get_Task()
		IL_0046: ret
	} // end of method ChannelClerk`1::Loop

	.method public final hidebysig newslot virtual 
		instance bool WaitUntilIdle (
			int32 timeoutMs
		) cil managed 
	{
		// Method begins at RVA 0x2270
		// Header size: 12
		// Code size: 69 (0x45)
		.maxstack 2
		.locals init (
			[0] valuetype [System.Runtime]System.DateTime,
			[1] valuetype [System.Runtime]System.DateTime
		)

		IL_0000: call valuetype [System.Runtime]System.DateTime [System.Runtime]System.DateTime::get_UtcNow()
		IL_0005: stloc.1
		IL_0006: ldloca.s 1
		IL_0008: ldarg.1
		IL_0009: conv.r8
		IL_000a: call instance valuetype [System.Runtime]System.DateTime [System.Runtime]System.DateTime::AddMilliseconds(float64)
		IL_000f: stloc.0
		IL_0010: br.s IL_0027
		// loop start (head: IL_0027)
			IL_0012: call valuetype [System.Runtime]System.DateTime [System.Runtime]System.DateTime::get_UtcNow()
			IL_0017: ldloc.0
			IL_0018: call bool [System.Runtime]System.DateTime::op_GreaterThanOrEqual(valuetype [System.Runtime]System.DateTime, valuetype [System.Runtime]System.DateTime)
			IL_001d: brfalse.s IL_0021

			IL_001f: ldc.i4.0
			IL_0020: ret

			IL_0021: ldc.i4.1
			IL_0022: call void [System.Threading.Thread]System.Threading.Thread::Sleep(int32)

			IL_0027: ldarg.0
			IL_0028: ldfld class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!0> class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1<!T>::_tray
			IL_002d: callvirt instance int32 class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!T>::get_Pending()
			IL_0032: ldc.i4.0
			IL_0033: bgt.s IL_0012

			IL_0035: ldarg.0
			IL_0036: ldflda int32 class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1<!T>::_busy
			IL_003b: call int32 [System.Threading]System.Threading.Volatile::Read(int32&)
			IL_0040: ldc.i4.1
			IL_0041: beq.s IL_0012
		// end loop

		IL_0043: ldc.i4.1
		IL_0044: ret
	} // end of method ChannelClerk`1::WaitUntilIdle

	.method public final hidebysig newslot virtual 
		instance void Dispose () cil managed 
	{
		// Method begins at RVA 0x22c1
		// Header size: 1
		// Code size: 31 (0x1f)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!0> class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1<!T>::_tray
		IL_0006: callvirt instance void class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelInTray`1<!T>::Close()
		IL_000b: ldarg.0
		IL_000c: ldfld class [System.Runtime]System.Threading.Tasks.Task class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1<!T>::_loop
		IL_0011: ldc.i4.2
		IL_0012: conv.i8
		IL_0013: call valuetype [System.Runtime]System.TimeSpan [System.Runtime]System.TimeSpan::FromSeconds(int64)
		IL_0018: callvirt instance bool [System.Runtime]System.Threading.Tasks.Task::Wait(valuetype [System.Runtime]System.TimeSpan)
		IL_001d: pop
		IL_001e: ret
	} // end of method ChannelClerk`1::Dispose

	// Properties
	.property instance string Name()
	{
		.get instance string MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1::get_Name()
	}
	.property instance bool IsRunning()
	{
		.get instance bool MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1::get_IsRunning()
	}
	.property instance int32 Handled()
	{
		.get instance int32 MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1::get_Handled()
	}

} // end of class MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk`1

.class public auto ansi sealed beforefieldinit MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier
	extends [System.Runtime]System.Object
	implements [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.ICourier,
	           [System.Runtime]System.IDisposable
{
	.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableContextAttribute::.ctor(uint8) = (
		01 00 01 00 00
	)
	.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
		01 00 00 00 00
	)
	.interfaceimpl type [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.ICourier
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
			01 00 00 00 00
		)

	.interfaceimpl type [System.Runtime]System.IDisposable
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
			01 00 00 00 00
		)

	// Nested Types
	.class nested private auto ansi sealed beforefieldinit '<>c__DisplayClass3_0'
		extends [System.Runtime]System.Object
	{
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		// Fields
		.field public class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.PostOffice office
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
			01 00 00 00 00
		)

		// Methods
		.method public hidebysig specialname rtspecialname 
			instance void .ctor () cil managed 
		{
			// Method begins at RVA 0x262e
			// Header size: 1
			// Code size: 7 (0x7)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: call instance void [System.Runtime]System.Object::.ctor()
			IL_0006: ret
		} // end of method '<>c__DisplayClass3_0'::.ctor

		.method assembly hidebysig 
			instance class [System.Runtime]System.Threading.Tasks.Task`1<string> '<Gather>b__0' (
				string a
			) cil managed 
		{
			.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableContextAttribute::.ctor(uint8) = (
				01 00 00 00 00
			)
			// Method begins at RVA 0x2636
			// Header size: 1
			// Code size: 13 (0xd)
			.maxstack 8

			IL_0000: ldarg.1
			IL_0001: ldarg.0
			IL_0002: ldfld class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.PostOffice MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<>c__DisplayClass3_0'::office
			IL_0007: call class [System.Runtime]System.Threading.Tasks.Task`1<string> MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier::Ask(string, class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.PostOffice)
			IL_000c: ret
		} // end of method '<>c__DisplayClass3_0'::'<Gather>b__0'

	} // end of class <>c__DisplayClass3_0

	.class nested private auto ansi sealed beforefieldinit '<Ask>d__4'
		extends [System.Runtime]System.ValueType
		implements [System.Runtime]System.Runtime.CompilerServices.IAsyncStateMachine
	{
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		.interfaceimpl type [System.Runtime]System.Runtime.CompilerServices.IAsyncStateMachine
			.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
				01 00 00 00 00
			)

		// Fields
		.field public int32 '<>1__state'
		.field public valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<string> '<>t__builder'
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
			01 00 00 00 00
		)
		.field public class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.PostOffice office
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
			01 00 00 00 00
		)
		.field public string address
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
			01 00 00 00 00
		)
		.field private valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredTaskAwaitable/ConfiguredTaskAwaiter '<>u__1'

		// Methods
		.method private final hidebysig newslot virtual 
			instance void MoveNext () cil managed 
		{
			.override method instance void [System.Runtime]System.Runtime.CompilerServices.IAsyncStateMachine::MoveNext()
			// Method begins at RVA 0x2644
			// Header size: 12
			// Code size: 183 (0xb7)
			.maxstack 3
			.locals init (
				[0] int32,
				[1] string,
				[2] valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredTaskAwaitable/ConfiguredTaskAwaiter,
				[3] valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredTaskAwaitable,
				[4] class [System.Runtime]System.Exception
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Ask>d__4'::'<>1__state'
			IL_0006: stloc.0
			.try
			{
				IL_0007: ldloc.0
				IL_0008: brfalse.s IL_0052

				IL_000a: ldarg.0
				IL_000b: ldfld class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.PostOffice MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Ask>d__4'::office
				IL_0010: callvirt instance int32 [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.PostOffice::get_DelayMs()
				IL_0015: call class [System.Runtime]System.Threading.Tasks.Task [System.Runtime]System.Threading.Tasks.Task::Delay(int32)
				IL_001a: ldc.i4.0
				IL_001b: callvirt instance valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredTaskAwaitable [System.Runtime]System.Threading.Tasks.Task::ConfigureAwait(bool)
				IL_0020: stloc.3
				IL_0021: ldloca.s 3
				IL_0023: call instance valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredTaskAwaitable/ConfiguredTaskAwaiter [System.Runtime]System.Runtime.CompilerServices.ConfiguredTaskAwaitable::GetAwaiter()
				IL_0028: stloc.2
				IL_0029: ldloca.s 2
				IL_002b: call instance bool [System.Runtime]System.Runtime.CompilerServices.ConfiguredTaskAwaitable/ConfiguredTaskAwaiter::get_IsCompleted()
				IL_0030: brtrue.s IL_006e

				IL_0032: ldarg.0
				IL_0033: ldc.i4.0
				IL_0034: dup
				IL_0035: stloc.0
				IL_0036: stfld int32 MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Ask>d__4'::'<>1__state'
				IL_003b: ldarg.0
				IL_003c: ldloc.2
				IL_003d: stfld valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredTaskAwaitable/ConfiguredTaskAwaiter MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Ask>d__4'::'<>u__1'
				IL_0042: ldarg.0
				IL_0043: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<string> MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Ask>d__4'::'<>t__builder'
				IL_0048: ldloca.s 2
				IL_004a: ldarg.0
				IL_004b: call instance void valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<string>::AwaitUnsafeOnCompleted<valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredTaskAwaitable/ConfiguredTaskAwaiter, valuetype MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Ask>d__4'>(!!0&, !!1&)
				IL_0050: leave.s IL_00b6

				IL_0052: ldarg.0
				IL_0053: ldfld valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredTaskAwaitable/ConfiguredTaskAwaiter MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Ask>d__4'::'<>u__1'
				IL_0058: stloc.2
				IL_0059: ldarg.0
				IL_005a: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredTaskAwaitable/ConfiguredTaskAwaiter MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Ask>d__4'::'<>u__1'
				IL_005f: initobj [System.Runtime]System.Runtime.CompilerServices.ConfiguredTaskAwaitable/ConfiguredTaskAwaiter
				IL_0065: ldarg.0
				IL_0066: ldc.i4.m1
				IL_0067: dup
				IL_0068: stloc.0
				IL_0069: stfld int32 MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Ask>d__4'::'<>1__state'

				IL_006e: ldloca.s 2
				IL_0070: call instance void [System.Runtime]System.Runtime.CompilerServices.ConfiguredTaskAwaitable/ConfiguredTaskAwaiter::GetResult()
				IL_0075: ldarg.0
				IL_0076: ldfld class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.PostOffice MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Ask>d__4'::office
				IL_007b: ldarg.0
				IL_007c: ldfld string MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Ask>d__4'::address
				IL_0081: callvirt instance string [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.PostOffice::Answer(string)
				IL_0086: stloc.1
				IL_0087: leave.s IL_00a2
			} // end .try
			catch [System.Runtime]System.Exception
			{
				IL_0089: stloc.s 4
				IL_008b: ldarg.0
				IL_008c: ldc.i4.s -2
				IL_008e: stfld int32 MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Ask>d__4'::'<>1__state'
				IL_0093: ldarg.0
				IL_0094: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<string> MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Ask>d__4'::'<>t__builder'
				IL_0099: ldloc.s 4
				IL_009b: call instance void valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<string>::SetException(class [System.Runtime]System.Exception)
				IL_00a0: leave.s IL_00b6
			} // end handler

			IL_00a2: ldarg.0
			IL_00a3: ldc.i4.s -2
			IL_00a5: stfld int32 MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Ask>d__4'::'<>1__state'
			IL_00aa: ldarg.0
			IL_00ab: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<string> MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Ask>d__4'::'<>t__builder'
			IL_00b0: ldloc.1
			IL_00b1: call instance void valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<string>::SetResult(!0)

			IL_00b6: ret
		} // end of method '<Ask>d__4'::MoveNext

		.method private final hidebysig newslot virtual 
			instance void SetStateMachine (
				class [System.Runtime]System.Runtime.CompilerServices.IAsyncStateMachine stateMachine
			) cil managed 
		{
			.custom instance void [System.Runtime]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [System.Runtime]System.Runtime.CompilerServices.IAsyncStateMachine::SetStateMachine(class [System.Runtime]System.Runtime.CompilerServices.IAsyncStateMachine)
			// Method begins at RVA 0x2718
			// Header size: 1
			// Code size: 13 (0xd)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<string> MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Ask>d__4'::'<>t__builder'
			IL_0006: ldarg.1
			IL_0007: call instance void valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<string>::SetStateMachine(class [System.Runtime]System.Runtime.CompilerServices.IAsyncStateMachine)
			IL_000c: ret
		} // end of method '<Ask>d__4'::SetStateMachine

	} // end of class <Ask>d__4

	.class nested private auto ansi sealed beforefieldinit '<Gather>d__3'
		extends [System.Runtime]System.ValueType
		implements [System.Runtime]System.Runtime.CompilerServices.IAsyncStateMachine
	{
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		.interfaceimpl type [System.Runtime]System.Runtime.CompilerServices.IAsyncStateMachine
			.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
				01 00 00 00 00
			)

		// Fields
		.field public int32 '<>1__state'
		.field public valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.Reply[]> '<>t__builder'
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8[]) = (
			01 00 03 00 00 00 00 00 01 00 00
		)
		.field public class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.PostOffice office
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
			01 00 00 00 00
		)
		.field public string[] addresses
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8[]) = (
			01 00 02 00 00 00 00 01 00 00
		)
		.field private class [System.Runtime]System.Threading.Tasks.Task`1<string>[] '<letters>5__2'
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8) = (
			01 00 00 00 00
		)
		.field private valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredTaskAwaitable`1/ConfiguredTaskAwaiter<string[]> '<>u__1'
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.NullableAttribute::.ctor(uint8[]) = (
			01 00 03 00 00 00 00 01 00 00 00
		)

		// Methods
		.method private final hidebysig newslot virtual 
			instance void MoveNext () cil managed 
		{
			.override method instance void [System.Runtime]System.Runtime.CompilerServices.IAsyncStateMachine::MoveNext()
			// Method begins at RVA 0x2728
			// Header size: 12
			// Code size: 368 (0x170)
			.maxstack 6
			.locals init (
				[0] int32,
				[1] class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.Reply[],
				[2] class MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<>c__DisplayClass3_0',
				[3] class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.Reply[],
				[4] valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredTaskAwaitable`1/ConfiguredTaskAwaiter<string[]>,
				[5] valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredTaskAwaitable`1<string[]>,
				[6] int32,
				[7] class [System.Runtime]System.Threading.Tasks.Task`1<string>,
				[8] class [System.Runtime]System.Exception
			)

			IL_0000: ldarg.0
			IL_0001: ldfld int32 MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::'<>1__state'
			IL_0006: stloc.0
			.try
			{
				IL_0007: ldloc.0
				IL_0008: brfalse.s IL_003e

				IL_000a: newobj instance void MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<>c__DisplayClass3_0'::.ctor()
				IL_000f: stloc.2
				IL_0010: ldloc.2
				IL_0011: ldarg.0
				IL_0012: ldfld class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.PostOffice MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::office
				IL_0017: stfld class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.PostOffice MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<>c__DisplayClass3_0'::office
				IL_001c: ldarg.0
				IL_001d: ldarg.0
				IL_001e: ldfld string[] MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::addresses
				IL_0023: ldloc.2
				IL_0024: ldftn instance class [System.Runtime]System.Threading.Tasks.Task`1<string> MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<>c__DisplayClass3_0'::'<Gather>b__0'(string)
				IL_002a: newobj instance void class [System.Runtime]System.Func`2<string, class [System.Runtime]System.Threading.Tasks.Task`1<string>>::.ctor(object, native int)
				IL_002f: call class [System.Runtime]System.Collections.Generic.IEnumerable`1<!!1> [System.Linq]System.Linq.Enumerable::Select<string, class [System.Runtime]System.Threading.Tasks.Task`1<string>>(class [System.Runtime]System.Collections.Generic.IEnumerable`1<!!0>, class [System.Runtime]System.Func`2<!!0, !!1>)
				IL_0034: call !!0[] [System.Linq]System.Linq.Enumerable::ToArray<class [System.Runtime]System.Threading.Tasks.Task`1<string>>(class [System.Runtime]System.Collections.Generic.IEnumerable`1<!!0>)
				IL_0039: stfld class [System.Runtime]System.Threading.Tasks.Task`1<string>[] MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::'<letters>5__2'

				IL_003e: nop
				.try
				{
					IL_003f: ldloc.0
					IL_0040: brfalse.s IL_008b

					IL_0042: ldarg.0
					IL_0043: ldfld class [System.Runtime]System.Threading.Tasks.Task`1<string>[] MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::'<letters>5__2'
					IL_0048: call class [System.Runtime]System.Threading.Tasks.Task`1<!!0[]> [System.Runtime]System.Threading.Tasks.Task::WhenAll<string>(class [System.Runtime]System.Threading.Tasks.Task`1<!!0>[])
					IL_004d: ldc.i4.0
					IL_004e: callvirt instance valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredTaskAwaitable`1<!0> class [System.Runtime]System.Threading.Tasks.Task`1<string[]>::ConfigureAwait(bool)
					IL_0053: stloc.s 5
					IL_0055: ldloca.s 5
					IL_0057: call instance valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredTaskAwaitable`1/ConfiguredTaskAwaiter<!0> valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredTaskAwaitable`1<string[]>::GetAwaiter()
					IL_005c: stloc.s 4
					IL_005e: ldloca.s 4
					IL_0060: call instance bool valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredTaskAwaitable`1/ConfiguredTaskAwaiter<string[]>::get_IsCompleted()
					IL_0065: brtrue.s IL_00a8

					IL_0067: ldarg.0
					IL_0068: ldc.i4.0
					IL_0069: dup
					IL_006a: stloc.0
					IL_006b: stfld int32 MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::'<>1__state'
					IL_0070: ldarg.0
					IL_0071: ldloc.s 4
					IL_0073: stfld valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredTaskAwaitable`1/ConfiguredTaskAwaiter<string[]> MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::'<>u__1'
					IL_0078: ldarg.0
					IL_0079: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.Reply[]> MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::'<>t__builder'
					IL_007e: ldloca.s 4
					IL_0080: ldarg.0
					IL_0081: call instance void valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.Reply[]>::AwaitUnsafeOnCompleted<valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredTaskAwaitable`1/ConfiguredTaskAwaiter<string[]>, valuetype MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'>(!!0&, !!1&)
					IL_0086: leave IL_016f

					IL_008b: ldarg.0
					IL_008c: ldfld valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredTaskAwaitable`1/ConfiguredTaskAwaiter<string[]> MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::'<>u__1'
					IL_0091: stloc.s 4
					IL_0093: ldarg.0
					IL_0094: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredTaskAwaitable`1/ConfiguredTaskAwaiter<string[]> MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::'<>u__1'
					IL_0099: initobj valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredTaskAwaitable`1/ConfiguredTaskAwaiter<string[]>
					IL_009f: ldarg.0
					IL_00a0: ldc.i4.m1
					IL_00a1: dup
					IL_00a2: stloc.0
					IL_00a3: stfld int32 MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::'<>1__state'

					IL_00a8: ldloca.s 4
					IL_00aa: call instance !0 valuetype [System.Runtime]System.Runtime.CompilerServices.ConfiguredTaskAwaitable`1/ConfiguredTaskAwaiter<string[]>::GetResult()
					IL_00af: pop
					IL_00b0: leave.s IL_00b5
				} // end .try
				catch [System.Runtime]System.Exception
				{
					IL_00b2: pop
					IL_00b3: leave.s IL_00b5
				} // end handler

				IL_00b5: ldarg.0
				IL_00b6: ldfld string[] MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::addresses
				IL_00bb: ldlen
				IL_00bc: conv.i4
				IL_00bd: newarr [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.Reply
				IL_00c2: stloc.3
				IL_00c3: ldc.i4.0
				IL_00c4: stloc.s 6
				IL_00c6: br.s IL_0124
				// loop start (head: IL_0124)
					IL_00c8: ldarg.0
					IL_00c9: ldfld class [System.Runtime]System.Threading.Tasks.Task`1<string>[] MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::'<letters>5__2'
					IL_00ce: ldloc.s 6
					IL_00d0: ldelem.ref
					IL_00d1: stloc.s 7
					IL_00d3: ldloc.3
					IL_00d4: ldloc.s 6
					IL_00d6: ldloc.s 7
					IL_00d8: callvirt instance bool [System.Runtime]System.Threading.Tasks.Task::get_IsFaulted()
					IL_00dd: brtrue.s IL_00f7

					IL_00df: ldarg.0
					IL_00e0: ldfld string[] MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::addresses
					IL_00e5: ldloc.s 6
					IL_00e7: ldelem.ref
					IL_00e8: ldloc.s 7
					IL_00ea: callvirt instance !0 class [System.Runtime]System.Threading.Tasks.Task`1<string>::get_Result()
					IL_00ef: ldnull
					IL_00f0: newobj instance void [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.Reply::.ctor(string, string, class [System.Runtime]System.Exception)
					IL_00f5: br.s IL_011d

					IL_00f7: ldarg.0
					IL_00f8: ldfld string[] MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::addresses
					IL_00fd: ldloc.s 6
					IL_00ff: ldelem.ref
					IL_0100: ldnull
					IL_0101: ldloc.s 7
					IL_0103: callvirt instance class [System.Runtime]System.AggregateException [System.Runtime]System.Threading.Tasks.Task::get_Exception()
					IL_0108: callvirt instance class [System.Runtime]System.Exception [System.Runtime]System.Exception::get_InnerException()
					IL_010d: dup
					IL_010e: brtrue.s IL_0118

					IL_0110: pop
					IL_0111: ldloc.s 7
					IL_0113: callvirt instance class [System.Runtime]System.AggregateException [System.Runtime]System.Threading.Tasks.Task::get_Exception()

					IL_0118: newobj instance void [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.Reply::.ctor(string, string, class [System.Runtime]System.Exception)

					IL_011d: stelem.ref
					IL_011e: ldloc.s 6
					IL_0120: ldc.i4.1
					IL_0121: add
					IL_0122: stloc.s 6

					IL_0124: ldloc.s 6
					IL_0126: ldarg.0
					IL_0127: ldfld string[] MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::addresses
					IL_012c: ldlen
					IL_012d: conv.i4
					IL_012e: blt.s IL_00c8
				// end loop

				IL_0130: ldloc.3
				IL_0131: stloc.1
				IL_0132: leave.s IL_0154
			} // end .try
			catch [System.Runtime]System.Exception
			{
				IL_0134: stloc.s 8
				IL_0136: ldarg.0
				IL_0137: ldc.i4.s -2
				IL_0139: stfld int32 MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::'<>1__state'
				IL_013e: ldarg.0
				IL_013f: ldnull
				IL_0140: stfld class [System.Runtime]System.Threading.Tasks.Task`1<string>[] MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::'<letters>5__2'
				IL_0145: ldarg.0
				IL_0146: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.Reply[]> MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::'<>t__builder'
				IL_014b: ldloc.s 8
				IL_014d: call instance void valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.Reply[]>::SetException(class [System.Runtime]System.Exception)
				IL_0152: leave.s IL_016f
			} // end handler

			IL_0154: ldarg.0
			IL_0155: ldc.i4.s -2
			IL_0157: stfld int32 MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::'<>1__state'
			IL_015c: ldarg.0
			IL_015d: ldnull
			IL_015e: stfld class [System.Runtime]System.Threading.Tasks.Task`1<string>[] MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::'<letters>5__2'
			IL_0163: ldarg.0
			IL_0164: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.Reply[]> MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::'<>t__builder'
			IL_0169: ldloc.1
			IL_016a: call instance void valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.Reply[]>::SetResult(!0)

			IL_016f: ret
		} // end of method '<Gather>d__3'::MoveNext

		.method private final hidebysig newslot virtual 
			instance void SetStateMachine (
				class [System.Runtime]System.Runtime.CompilerServices.IAsyncStateMachine stateMachine
			) cil managed 
		{
			.custom instance void [System.Runtime]System.Diagnostics.DebuggerHiddenAttribute::.ctor() = (
				01 00 00 00
			)
			.override method instance void [System.Runtime]System.Runtime.CompilerServices.IAsyncStateMachine::SetStateMachine(class [System.Runtime]System.Runtime.CompilerServices.IAsyncStateMachine)
			// Method begins at RVA 0x28d8
			// Header size: 1
			// Code size: 13 (0xd)
			.maxstack 8

			IL_0000: ldarg.0
			IL_0001: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.Reply[]> MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::'<>t__builder'
			IL_0006: ldarg.1
			IL_0007: call instance void valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.Reply[]>::SetStateMachine(class [System.Runtime]System.Runtime.CompilerServices.IAsyncStateMachine)
			IL_000c: ret
		} // end of method '<Gather>d__3'::SetStateMachine

	} // end of class <Gather>d__3


	// Methods
	.method public final hidebysig specialname newslot virtual 
		instance string get_Version () cil managed 
	{
		// Method begins at RVA 0x22e1
		// Header size: 1
		// Code size: 6 (0x6)
		.maxstack 8

		IL_0000: ldstr "modern"
		IL_0005: ret
	} // end of method TaskCourier::get_Version

	.method public final hidebysig newslot virtual 
		instance class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.Reply[] SendAll (
			string[] addresses,
			class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.PostOffice office
		) cil managed 
	{
		// Method begins at RVA 0x22e8
		// Header size: 12
		// Code size: 21 (0x15)
		.maxstack 2
		.locals init (
			[0] valuetype [System.Runtime]System.Runtime.CompilerServices.TaskAwaiter`1<class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.Reply[]>
		)

		IL_0000: ldarg.1
		IL_0001: ldarg.2
		IL_0002: call class [System.Runtime]System.Threading.Tasks.Task`1<class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.Reply[]> MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier::Gather(string[], class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.PostOffice)
		IL_0007: callvirt instance valuetype [System.Runtime]System.Runtime.CompilerServices.TaskAwaiter`1<!0> class [System.Runtime]System.Threading.Tasks.Task`1<class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.Reply[]>::GetAwaiter()
		IL_000c: stloc.0
		IL_000d: ldloca.s 0
		IL_000f: call instance !0 valuetype [System.Runtime]System.Runtime.CompilerServices.TaskAwaiter`1<class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.Reply[]>::GetResult()
		IL_0014: ret
	} // end of method TaskCourier::SendAll

	.method private hidebysig static 
		class [System.Runtime]System.Threading.Tasks.Task`1<class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.Reply[]> Gather (
			string[] addresses,
			class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.PostOffice office
		) cil managed 
	{
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.AsyncStateMachineAttribute::.ctor(class [System.Runtime]System.Type) = (
			01 00 3e 4d 4d 50 2e 41 73 79 6e 63 50 72 6f 78
			79 2e 54 72 61 69 6e 69 6e 67 2e 4d 6f 64 65 72
			6e 2e 46 61 6e 4f 75 74 2e 54 61 73 6b 43 6f 75
			72 69 65 72 2b 3c 47 61 74 68 65 72 3e 64 5f 5f
			33 00 00
		)
		// Method begins at RVA 0x230c
		// Header size: 12
		// Code size: 63 (0x3f)
		.maxstack 2
		.locals init (
			[0] valuetype MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'
		)

		IL_0000: ldloca.s 0
		IL_0002: call valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<!0> valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.Reply[]>::Create()
		IL_0007: stfld valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.Reply[]> MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::'<>t__builder'
		IL_000c: ldloca.s 0
		IL_000e: ldarg.0
		IL_000f: stfld string[] MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::addresses
		IL_0014: ldloca.s 0
		IL_0016: ldarg.1
		IL_0017: stfld class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.PostOffice MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::office
		IL_001c: ldloca.s 0
		IL_001e: ldc.i4.m1
		IL_001f: stfld int32 MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::'<>1__state'
		IL_0024: ldloca.s 0
		IL_0026: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.Reply[]> MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::'<>t__builder'
		IL_002b: ldloca.s 0
		IL_002d: call instance void valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.Reply[]>::Start<valuetype MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'>(!!0&)
		IL_0032: ldloca.s 0
		IL_0034: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.Reply[]> MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Gather>d__3'::'<>t__builder'
		IL_0039: call instance class [System.Runtime]System.Threading.Tasks.Task`1<!0> valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.Reply[]>::get_Task()
		IL_003e: ret
	} // end of method TaskCourier::Gather

	.method private hidebysig static 
		class [System.Runtime]System.Threading.Tasks.Task`1<string> Ask (
			string address,
			class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.PostOffice office
		) cil managed 
	{
		.custom instance void [System.Runtime]System.Runtime.CompilerServices.AsyncStateMachineAttribute::.ctor(class [System.Runtime]System.Type) = (
			01 00 3b 4d 4d 50 2e 41 73 79 6e 63 50 72 6f 78
			79 2e 54 72 61 69 6e 69 6e 67 2e 4d 6f 64 65 72
			6e 2e 46 61 6e 4f 75 74 2e 54 61 73 6b 43 6f 75
			72 69 65 72 2b 3c 41 73 6b 3e 64 5f 5f 34 00 00
		)
		// Method begins at RVA 0x2358
		// Header size: 12
		// Code size: 63 (0x3f)
		.maxstack 2
		.locals init (
			[0] valuetype MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Ask>d__4'
		)

		IL_0000: ldloca.s 0
		IL_0002: call valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<!0> valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<string>::Create()
		IL_0007: stfld valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<string> MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Ask>d__4'::'<>t__builder'
		IL_000c: ldloca.s 0
		IL_000e: ldarg.0
		IL_000f: stfld string MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Ask>d__4'::address
		IL_0014: ldloca.s 0
		IL_0016: ldarg.1
		IL_0017: stfld class [MMP.AsyncProxy.Training]MMP.AsyncProxy.Training.FanOut.PostOffice MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Ask>d__4'::office
		IL_001c: ldloca.s 0
		IL_001e: ldc.i4.m1
		IL_001f: stfld int32 MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Ask>d__4'::'<>1__state'
		IL_0024: ldloca.s 0
		IL_0026: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<string> MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Ask>d__4'::'<>t__builder'
		IL_002b: ldloca.s 0
		IL_002d: call instance void valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<string>::Start<valuetype MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Ask>d__4'>(!!0&)
		IL_0032: ldloca.s 0
		IL_0034: ldflda valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<string> MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier/'<Ask>d__4'::'<>t__builder'
		IL_0039: call instance class [System.Runtime]System.Threading.Tasks.Task`1<!0> valuetype [System.Runtime]System.Runtime.CompilerServices.AsyncTaskMethodBuilder`1<string>::get_Task()
		IL_003e: ret
	} // end of method TaskCourier::Ask

	.method public final hidebysig newslot virtual 
		instance void Dispose () cil managed 
	{
		// Method begins at RVA 0x23a3
		// Header size: 1
		// Code size: 1 (0x1)
		.maxstack 8

		IL_0000: ret
	} // end of method TaskCourier::Dispose

	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		// Method begins at RVA 0x23a5
		// Header size: 1
		// Code size: 7 (0x7)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: call instance void [System.Runtime]System.Object::.ctor()
		IL_0006: ret
	} // end of method TaskCourier::.ctor

	// Properties
	.property instance string Version()
	{
		.get instance string MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier::get_Version()
	}

} // end of class MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier

You are not using the latest version of the tool, please update.
Latest version is '11.2.0.10050' (yours is '10.0.1.8346')
