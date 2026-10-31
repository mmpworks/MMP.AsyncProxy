namespace MMP.AsyncProxy
{
    /// <summary>
    /// The result type of a future that carries no value. Stands in for the
    /// non-generic Task so that one generic implementation serves both shapes.
    /// </summary>
    public struct VoidResult
    {
        public static readonly VoidResult Value = new VoidResult();
    }
}
