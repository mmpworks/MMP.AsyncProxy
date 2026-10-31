using System;
using System.Threading.Tasks;

namespace MMP.AsyncProxy.CompilerReference
{
    /// <summary>
    /// The real async method, compiled by the real compiler. Decompile this
    /// assembly and compare the generated state machine with
    /// samples/MMP.AsyncProxy.Samples/AddAfterDelay.cs. Same fields, same states, same shape.
    /// </summary>
    public static class AddAfterDelayReal
    {
        public static async Task<int> RunAsync(int a, int b, int delayMs)
        {
            await Task.Delay(delayMs);
            if (a < 0) throw new ArgumentOutOfRangeException("a");
            int sum = a + b;
            await Task.Delay(delayMs);
            return sum * 2;
        }
    }
}
