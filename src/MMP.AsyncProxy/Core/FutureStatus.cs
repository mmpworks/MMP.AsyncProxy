namespace MMP.AsyncProxy
{
    /// <summary>Where a future is in its life. It starts Pending and moves once, to one of the other three.</summary>
    public enum FutureStatus
    {
        Pending = 0,
        Succeeded = 1,
        Faulted = 2,
        Canceled = 3
    }
}
