using System;
using System.Collections.Generic;

namespace MMP.AsyncProxy.Sdk
{
    /// <summary>
    /// docs/sdk.md, "Faults and stacks". .NET 3.5 has no ExceptionDispatchInfo, so a rethrow
    /// resets the stack trace. Before it rethrows, the library copies the first stack into
    /// Exception.Data. The Compact Framework has no Exception.Data, so there it is lost.
    /// </summary>
    public static class FaultsAndStacks
    {
        /// <summary>Waits on a future that faulted somewhere else and returns the original stack, or null.</summary>
        public static string WhereDidItFail(IFuture<int> future)
        {
            try
            {
                future.Wait();
                return future.GetAwaiter().GetResult().ToString();
            }
            catch (Exception ex)
            {
                string where = ex.Data[Promise<int>.OriginalStackTraceKey] as string;
                Console.Error.WriteLine(ex.Message + Environment.NewLine + where);
                return where;
            }
        }

        /// <summary>A method whose second step throws, three frames down, so there is a stack to lose.</summary>
        public static IFuture<int> FailDeepAsync()
        {
            return AsyncProxy.Run<int>(delegate(Return<int> ret) { return FailBody(ret); });
        }

        private static IEnumerable<IFuture> FailBody(Return<int> ret)
        {
            yield return Futures.Delay(1);
            ThrowFromHere();
        }

        private static void ThrowFromHere()
        {
            throw new InvalidOperationException("the valve did not answer");
        }
    }
}
