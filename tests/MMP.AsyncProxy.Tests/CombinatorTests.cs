using System;
using System.Collections.Generic;
using System.Threading;
using Xunit;

namespace MMP.AsyncProxy.Tests
{
    public class CombinatorTests
    {
        [Fact]
        public void WhenAny_reports_the_first_to_finish()
        {
            var slow = new Promise<int>();
            var fast = new Promise<int>();
            var any = Futures.WhenAny(slow.Future, fast.Future);
            Assert.False(any.IsCompleted);
            fast.SetResult(2);
            Assert.Same(fast, any.Result);
            slow.SetResult(1);
            Assert.Same(fast, any.Result);
        }

        [Fact]
        public void WhenAny_succeeds_even_when_the_winner_faulted()
        {
            var failing = new Promise<int>();
            var any = Futures.WhenAny(failing.Future, Futures.Delay(5000));
            failing.SetException(new Exception("lost"));
            Assert.False(any.IsFaulted);
            Assert.True(any.Result.IsFaulted);
        }

        [Fact]
        public void WhenAny_races_two_delays()
        {
            var a = Futures.Delay(300);
            var b = Futures.Delay(20);
            Assert.Same(b, Futures.WhenAny(a, b).Result);
        }

        [Fact]
        public void WhenAny_rejects_an_empty_list()
        {
            Assert.Throws<ArgumentException>(() => Futures.WhenAny());
        }

        [Fact]
        public void Observe_never_throws_and_lets_the_body_inspect_the_step()
        {
            var risky = new Promise<int>();
            var future = AsyncProxy.Run<string>(ret => Recover(risky, ret));
            risky.SetException(new InvalidOperationException("step failed"));
            Assert.Equal("recovered from step failed", future.Result);
        }

        private static IEnumerable<IFuture> Recover(IFuture<int> risky, Return<string> ret)
        {
            yield return Futures.Observe(risky);
            if (risky.IsFaulted) ret.Value = "recovered from " + risky.Exception.Message;
            else ret.Value = "got " + risky.Result;
        }

        [Fact]
        public void Observe_of_a_success_leaves_the_result_readable()
        {
            var ok = Futures.FromResult(5);
            var observed = Futures.Observe(ok);
            Assert.True(observed.IsCompleted);
            Assert.Equal(5, ok.Result);
        }

        [Fact]
        public void RunContinuationsAsync_moves_the_callback_off_the_completing_thread() => NoContext.Run(() =>
        {
            var promise = new Promise<int>(true);
            var done = new ManualResetEvent(false);
            var ranOn = 0;
            promise.GetAwaiter().OnCompleted(() => { ranOn = Thread.CurrentThread.ManagedThreadId; done.Set(); });
            promise.SetResult(1);
            Assert.True(done.WaitOne(5000));
            Assert.NotEqual(Thread.CurrentThread.ManagedThreadId, ranOn);
        });

        [Fact]
        public void Default_promise_runs_the_callback_on_the_completing_thread() => NoContext.Run(() =>
        {
            var promise = new Promise<int>();
            var ranOn = 0;
            promise.GetAwaiter().OnCompleted(() => ranOn = Thread.CurrentThread.ManagedThreadId);
            promise.SetResult(1);
            Assert.Equal(Thread.CurrentThread.ManagedThreadId, ranOn);
        });
    }
}
