namespace MMP.AsyncProxy
{
    /// <summary>The three terminal states of a future, plus the one before them.</summary>
    public enum FutureStatus
    {
        Pending = 0,
        Succeeded = 1,
        Faulted = 2,
        Canceled = 3
    }
}
