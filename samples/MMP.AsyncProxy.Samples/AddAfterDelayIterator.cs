using System;
using System.Collections.Generic;

namespace MMP.AsyncProxy.Samples
{
    /// <summary>
    /// Same method as <see cref="AddAfterDelay"/>, but this time we let the
    /// compiler write the state machine. It already knows how, for iterators.
    /// Every "yield return future" is an await. AsyncProxy drives it.
    /// Compare the line count with the hand-written one. That gap is what C# 5 bought us.
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
