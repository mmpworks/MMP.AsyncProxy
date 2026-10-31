using System;

namespace MMP.AsyncProxy
{
    /// <summary>Thrown by GetResult, Result and Wait when the future was canceled.</summary>
    public class FutureCanceledException : OperationCanceledException
    {
        public FutureCanceledException() : base("The future was canceled.") { }
    }
}
