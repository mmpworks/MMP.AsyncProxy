using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading;
using Xunit;

namespace MMP.AsyncProxy.Tests
{
    public class CancelTests
    {
        [Fact]
        public void Token_reports_the_source()
        {
            var source = new CancelSource();
            var token = source.Token;
            Assert.True(token.CanBeCanceled);
            Assert.False(token.IsCancelRequested);
            source.Cancel();
            Assert.True(token.IsCancelRequested);
            Assert.Throws<FutureCanceledException>(() => token.ThrowIfCancelRequested());
        }

        [Fact]
        public void None_never_cancels_and_registration_is_a_no_op()
        {
            var token = CancelToken.None;
            Assert.False(token.CanBeCanceled);
            var ran = false;
            using (token.Register(() => ran = true)) { }
            token.ThrowIfCancelRequested();
            Assert.False(ran);
        }

        [Fact]
        public void Register_runs_on_cancel_and_disposed_registration_does_not()
        {
            var source = new CancelSource();
            var a = 0;
            var b = 0;
            source.Token.Register(() => a++);
            var reg = source.Token.Register(() => b++);
            reg.Dispose();
            source.Cancel();
            source.Cancel();
            Assert.Equal(1, a);
            Assert.Equal(0, b);
        }

        [Fact]
        public void Register_after_cancel_runs_at_once()
        {
            var source = new CancelSource();
            source.Cancel();
            var ran = false;
            source.Token.Register(() => ran = true);
            Assert.True(ran);
        }

        [Fact]
        public void Delay_is_cut_short_by_cancel()
        {
            var source = new CancelSource();
            var clock = Stopwatch.StartNew();
            var future = Futures.Delay(5000, source.Token);
            Assert.False(future.IsCompleted);
            source.Cancel();
            future.Wait();
            Assert.True(future.IsCanceled);
            Assert.True(clock.ElapsedMilliseconds < 1000);
            Assert.Throws<FutureCanceledException>(() => future.GetAwaiter().GetResult());
        }

        [Fact]
        public void Delay_with_already_canceled_token_is_canceled_at_once()
        {
            var source = new CancelSource();
            source.Cancel();
            Assert.True(Futures.Delay(100, source.Token).IsCanceled);
        }

        [Fact]
        public void Delay_that_finishes_first_ignores_a_later_cancel()
        {
            var source = new CancelSource();
            var future = Futures.Delay(20, source.Token);
            future.Wait();
            source.Cancel();
            Assert.Equal(FutureStatus.Succeeded, future.Status);
        }

        [Fact]
        public void Run_with_canceled_token_skips_the_work()
        {
            var source = new CancelSource();
            source.Cancel();
            var ran = false;
            var future = Futures.Run(() => { ran = true; return 1; }, source.Token);
            future.Wait();
            Assert.True(future.IsCanceled);
            Assert.False(ran);
        }

        [Fact]
        public void Run_that_throws_canceled_ends_canceled_not_faulted()
        {
            var source = new CancelSource();
            var future = Futures.Run<int>(() =>
            {
                source.Cancel();
                source.Token.ThrowIfCancelRequested();
                return 1;
            }, source.Token);
            future.Wait();
            Assert.True(future.IsCanceled);
            Assert.False(future.IsFaulted);
        }

        [Fact]
        public void Iterator_that_awaits_a_canceled_step_ends_canceled()
        {
            var source = new CancelSource();
            var reached = false;
            var future = AsyncProxy.Run(Body(source.Token, () => reached = true));
            source.Cancel();
            future.Wait();
            Assert.True(future.IsCanceled);
            Assert.False(future.IsFaulted);
            Assert.False(reached);
        }

        private static IEnumerable<IFuture> Body(CancelToken token, Action afterDelay)
        {
            yield return Futures.Delay(5000, token);
            afterDelay();
        }

        [Fact]
        public void Hand_written_machine_that_throws_canceled_ends_canceled()
        {
            var builder = AsyncMethodBuilder<int>.Create();
            builder.SetException(new FutureCanceledException());
            Assert.True(builder.Future.IsCanceled);
            Assert.False(builder.Future.IsFaulted);
        }
    }
}
