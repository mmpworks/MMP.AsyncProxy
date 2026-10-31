using System;
using System.Collections.Generic;

namespace MMP.AsyncProxy.Samples
{
    /// <summary>
    /// The same method as <see cref="AddAfterDelay"/>, written as a C# 2.0
    /// iterator. The compiler writes the state machine for the iterator, and
    /// AsyncProxy drives it. Each yield return is an await.
    /// </summary>
    public static class AddAfterDelayIterator
    {
        public static IFuture<int> RunAsync(int a, int b, int delayMs)
        {
            return AsyncProxy.Run<int>(delegate(Return<int> ret) { return Body(a, b, delayMs, ret); });
        }

        private static IEnumerable<IFuture> Body(int a, int b, int delayMs, Return<int> ret)
        {
            yield return Futures.Delay(delayMs);
            if (a < 0) throw new ArgumentOutOfRangeException("a");
            int sum = a + b;
            yield return Futures.Delay(delayMs);
            ret.Value = sum * 2;
        }
    }
}
