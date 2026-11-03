using System;
using System.IO;

namespace MMP.AsyncProxy.Sdk
{
    /// <summary>docs/sdk.md, "Consume one". Three ways to take the answer out of a future.</summary>
    public static class ConsumeOne
    {
        /// <summary>At the top of a program: wait, then read.</summary>
        public static void WaitAtTheTop(Stream stream)
        {
            IFuture<string> future = WriteAnAsyncMethod.FetchAndTrimAsync(stream);
            future.Wait();
            Console.WriteLine(future.Result);
        }

        /// <summary>With a bound, the way Task.Wait(int) has one. True when the answer came in time.</summary>
        public static bool WaitWithABound(IFuture<string> future)
        {
            if (!future.Wait(2000)) Console.Error.WriteLine("still waiting after two seconds");
            return future.IsCompleted;
        }

        /// <summary>Or hang a callback on it and move on.</summary>
        public static void HangACallback(IFuture<string> future)
        {
            future.GetAwaiter().OnCompleted(delegate { Console.WriteLine(future.Result); });
        }
    }
}
