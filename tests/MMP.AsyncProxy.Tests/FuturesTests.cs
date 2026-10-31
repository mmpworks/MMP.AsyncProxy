using System;
using System.Diagnostics;
using System.Threading;
using Xunit;

namespace MMP.AsyncProxy.Tests
{
    public class FuturesTests
    {
        [Fact]
        public void Delay_completes_after_the_time_without_blocking_the_caller()
        {
            var clock = Stopwatch.StartNew();
            var future = Futures.Delay(60);
            Assert.False(future.IsCompleted);
            Assert.True(clock.ElapsedMilliseconds < 50);
            future.Wait();
            Assert.True(clock.ElapsedMilliseconds >= 50);
        }

        [Fact]
        public void Run_executes_on_a_pool_thread_and_returns_the_value()
        {
            var caller = Thread.CurrentThread.ManagedThreadId;
            var future = Futures.Run(() => Thread.CurrentThread.ManagedThreadId);
            var worker = future.Result;
            Assert.NotEqual(caller, worker);
        }

        [Fact]
        public void Run_captures_a_throw_as_a_fault()
        {
            var future = Futures.Run<int>(() => throw new ApplicationException("work failed"));
            future.Wait();
            Assert.True(future.IsFaulted);
            Assert.IsType<ApplicationException>(future.Exception);
        }

        [Fact]
        public void WhenAll_waits_for_every_input()
        {
            var a = new Promise<int>();
            var b = new Promise<int>();
            var all = Futures.WhenAll(a.Future, b.Future);
            a.SetResult(1);
            Assert.False(all.IsCompleted);
            b.SetResult(2);
            Assert.True(all.IsCompleted);
            Assert.False(all.IsFaulted);
        }

        [Fact]
        public void WhenAll_collects_every_fault()
        {
            var a = new Promise<int>();
            var b = new Promise<int>();
            var c = new Promise<int>();
            var all = Futures.WhenAll(a.Future, b.Future, c.Future);
            a.SetException(new Exception("first"));
            b.SetResult(0);
            c.SetException(new Exception("second"));
            var agg = Assert.IsType<AggregateFutureException>(all.Exception);
            Assert.Equal(2, agg.InnerExceptions.Count);
            Assert.Equal("first", agg.InnerExceptions[0].Message);
            Assert.Equal("second", agg.InnerExceptions[1].Message);
        }

        [Fact]
        public void WhenAll_of_nothing_is_complete()
        {
            Assert.True(Futures.WhenAll().IsCompleted);
        }

        [Fact]
        public void FromResult_and_Completed_are_complete_at_once()
        {
            Assert.True(Futures.Completed.IsCompleted);
            Assert.Equal(5, Futures.FromResult(5).Result);
        }
    }
}
