namespace MMP.AsyncProxy
{
    /// <summary>
    /// What the compiler generates for every async method. MoveNext runs the
    /// method from its current state to the next await, or to the end.
    /// </summary>
    public interface IAsyncStateMachine
    {
        void MoveNext();

        /// <summary>Kept for shape parity. Class machines ignore it. See PRD decision 3.</summary>
        void SetStateMachine(IAsyncStateMachine stateMachine);
    }
}
