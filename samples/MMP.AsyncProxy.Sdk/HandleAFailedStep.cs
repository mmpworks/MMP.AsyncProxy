using System;
using System.Collections.Generic;

namespace MMP.AsyncProxy.Sdk
{
    /// <summary>
    /// docs/sdk.md, "Handle a failed step inside an iterator". A faulted step faults the whole
    /// method, so the body never gets a catch. Observe wraps the step so the await always
    /// succeeds; then the body looks at the step itself.
    /// </summary>
    public static class HandleAFailedStep
    {
        public static IFuture<int> ReadOrFallbackAsync(IFuture<int> risky, int fallback)
        {
            return AsyncProxy.Run<int>(delegate(Return<int> ret) { return Body(risky, fallback, ret); });
        }

        private static IEnumerable<IFuture> Body(IFuture<int> risky, int fallback, Return<int> ret)
        {
            yield return Futures.Observe(risky);
            if (risky.IsFaulted) { Console.Error.WriteLine(risky.Exception.Message); ret.Value = fallback; yield break; }
            ret.Value = risky.Result;
        }
    }
}
