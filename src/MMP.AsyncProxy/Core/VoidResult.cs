namespace MMP.AsyncProxy
{
    /// <summary>
    /// A value that means "nothing". A future with no result still needs a type
    /// parameter, so this fills the slot. It lets one generic Promise serve both
    /// the Task and the Task&lt;T&gt; shapes.
    /// </summary>
    public struct VoidResult
    {
        public static readonly VoidResult Value = new VoidResult();
    }
}
