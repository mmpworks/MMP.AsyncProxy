using System;
using System.Linq;
using Xunit;

namespace MMP.AsyncProxy.Tests
{
    /// <summary>
    /// The fuzz suite's first catch, pinned: WhenAll lists failures in input order, whatever
    /// order the inputs finished in. The README and the SDK guide both promise "in order".
    /// </summary>
    public class WhenAllOrderTests
    {
        [Fact]
        public void WhenAll_reports_failures_in_input_order_not_completion_order()
        {
            var a = new Promise<int>();
            var b = new Promise<int>();
            var c = new Promise<int>();
            IFuture all = Futures.WhenAll(a.Future, b.Future, c.Future);

            c.SetException(new ApplicationException("c"));
            a.SetException(new ApplicationException("a"));
            b.SetResult(1);

            Assert.True(all.Wait(2000));
            var agg = Assert.IsType<AggregateFutureException>(all.Exception);
            Assert.Equal(new[] { "a", "c" }, agg.InnerExceptions.Select(e => e.Message).ToArray());
            Assert.Equal("a", agg.InnerException.Message);
        }

        [Fact]
        public void WhenAll_with_a_cancel_and_no_fault_ends_Canceled()
        {
            var a = new Promise<int>();
            var b = new Promise<int>();
            IFuture all = Futures.WhenAll(a.Future, b.Future);
            b.SetCanceled();
            a.SetResult(1);
            Assert.True(all.Wait(2000));
            Assert.True(all.IsCanceled);
        }
    }
}
