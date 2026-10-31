namespace MMP.AsyncProxy
{
    /// <summary>
    /// The return slot of an iterator-driven async method. An iterator cannot
    /// return a value, so the body sets Value before it ends.
    /// </summary>
    public sealed class Return<T>
    {
        public T Value { get; set; }
    }
}
