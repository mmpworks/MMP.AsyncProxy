namespace MMP.AsyncProxy
{
    /// <summary>
    /// An iterator method cannot "return x". So we hand it a box, and it sets
    /// Value before it runs out of steps. Whatever is in the box when the
    /// iterator ends becomes the future's result.
    /// </summary>
    public sealed class Return<T>
    {
        public T Value { get; set; }
    }
}
