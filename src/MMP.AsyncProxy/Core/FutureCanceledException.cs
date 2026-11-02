using System;

namespace MMP.AsyncProxy
{
    /// <summary>What you get from GetResult, Result, or Wait when someone canceled the future.</summary>
#if NETCF
    // The Compact Framework has no OperationCanceledException. Checked against the
    // CF 3.5 reference assemblies (docs/netcf-port.md). On that target the library's
    // own type is the one the builder and Futures.Run look for.
    public class FutureCanceledException : Exception
#else
    public class FutureCanceledException : OperationCanceledException
#endif
    {
        public FutureCanceledException() : base("The future was canceled.") { }
    }
}
