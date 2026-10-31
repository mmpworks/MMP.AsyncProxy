using System;
using System.Threading;
using Xunit;

namespace MMP.AsyncProxy.Tests
{
    public class PromiseTests
    {
        [Fact]
        public void Result_set_before_registration_runs_continuation_at_once() => NoContext.Run(() =>
        {
            var promise = new Promise<int>();
            promise.SetResult(7);
            var ran = false;
            promise.GetAwaiter().OnCompleted(() => ran = true);
            Assert.True(ran);
            Assert.Equal(7, promise.GetAwaiter().GetResult());
        });

        [Fact]
        public void Continuation_registered_before_completion_runs_on_completion() => NoContext.Run(() =>
        {
            var promise = new Promise<int>();
            var awaiter = promise.GetAwaiter();
            Assert.False(awaiter.IsCompleted);
            var seen = 0;
            awaiter.OnCompleted(() => seen = awaiter.GetResult());
            Assert.Equal(0, seen);
            promise.SetResult(42);
            Assert.Equal(42, seen);
        });

        [Fact]
        public void Under_a_SynchronizationContext_the_continuation_is_posted_not_run_inline()
        {
            // xunit's own context is in place here. This pins the Task-like behaviour.
            Assert.NotNull(SynchronizationContext.Current);
            var promise = new Promise<int>();
            promise.SetResult(7);
            var ran = false;
            promise.GetAwaiter().OnCompleted(() => ran = true);
            Assert.False(ran);
        }

        [Fact]
        public void Second_completion_is_refused()
        {
            var promise = new Promise<int>();
            Assert.True(promise.TrySetResult(1));
            Assert.False(promise.TrySetResult(2));
            Assert.Throws<InvalidOperationException>(() => promise.SetResult(3));
            Assert.Equal(1, promise.Result);
        }

        [Fact]
        public void Fault_rethrows_the_original_and_keeps_its_first_stack()
        {
            var promise = new Promise<int>();
            Exception thrown;
            try { throw new InvalidOperationException("boom"); }
            catch (Exception ex) { thrown = ex; }
            promise.SetException(thrown);

            var caught = Assert.Throws<InvalidOperationException>(() => promise.GetAwaiter().GetResult());
            Assert.Same(thrown, caught);
            Assert.True(promise.IsFaulted);
            var original = caught.Data[Promise<int>.OriginalStackTraceKey] as string;
            Assert.False(string.IsNullOrEmpty(original));
            Assert.Contains(nameof(Fault_rethrows_the_original_and_keeps_its_first_stack), original);
        }

        [Fact]
        public void Canceled_throws_FutureCanceledException()
        {
            var promise = new Promise<int>();
            promise.SetCanceled();
            Assert.True(promise.IsCanceled);
            Assert.Throws<FutureCanceledException>(() => promise.Result);
        }

        [Fact]
        public void Wait_blocks_until_another_thread_completes()
        {
            var promise = new Promise<string>();
            var started = new ManualResetEvent(false);
            ThreadPool.QueueUserWorkItem(_ =>
            {
                started.WaitOne();
                Thread.Sleep(30);
                promise.SetResult("late");
            });
            started.Set();
            promise.Future.Wait();
            Assert.Equal("late", promise.Result);
        }

        [Fact]
        public void Future_view_cannot_be_cast_back_to_a_completer()
        {
            // The future is a separate sealed object. No cast reaches the setters,
            // and the view is the same instance every time so reference equality holds.
            var promise = new Promise<int>();
            IFuture<int> view = promise.Future;
            Assert.IsType<Future<int>>(view);
            // The compiler rejects "view is Promise<int>" outright (CS0184), which is the point.
            Assert.False(typeof(IFuture<int>).IsAssignableFrom(typeof(Promise<int>)));
            Assert.False(typeof(IFuture).IsAssignableFrom(typeof(Promise<int>)));
            Assert.Null(typeof(Future<int>).GetMethod("SetResult"));
            Assert.Null(typeof(Future<int>).GetMethod("TrySetResult"));
            Assert.Same(promise.Future, view);
        }
    }
}
