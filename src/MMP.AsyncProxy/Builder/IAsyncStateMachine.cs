namespace MMP.AsyncProxy
{
    /// <summary>
    /// Every async method becomes one of these. MoveNext is the method body,
    /// cut at each await. Call it once and it runs to the first await that is
    /// not ready, then returns. Call it again and it picks up where it stopped.
    /// </summary>
    public interface IAsyncStateMachine
    {
        void MoveNext();

        /// <summary>
        /// The real runtime uses this when the machine is a struct and gets boxed.
        /// Ours are classes, so there is nothing to do. It stays so the shape matches.
        /// </summary>
        void SetStateMachine(IAsyncStateMachine stateMachine);
    }
}
