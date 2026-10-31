using System;

namespace MMP.AsyncProxy
{
    /// <summary>What you get from GetResult, Result, or Wait when someone canceled the future.</summary>
    public class FutureCanceledException : OperationCanceledException
    {
        public FutureCanceledException() : base("The future was canceled.") { }
    }
}
