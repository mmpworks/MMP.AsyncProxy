using System;
using System.Collections.Generic;
using System.Runtime.Remoting.Messaging;
using System.Threading;
using MMP.AsyncProxy.Samples;
using Xunit;

namespace MMP.AsyncProxy.Tests
{
    public class StateMachineTests
    {
        [Fact]
        public void Hand_written_machine_suspends_then_returns_the_value()
        {
            var future = AddAfterDelay.RunAsync(3, 4, 40);
            Assert.False(future.IsCompleted);
            future.Wait();
            Assert.Equal(14, future.Result);
        }

        [Fact]
        public void Hand_written_machine_routes_a_throw_to_SetException()
        {
            var future = AddAfterDelay.RunAsync(-1, 4, 10);
            future.Wait();
            Assert.True(future.IsFaulted);
            Assert.IsType<ArgumentOutOfRangeException>(future.Exception);
            Assert.Throws<ArgumentOutOfRangeException>(() => future.Result);
        }

        [Fact]
        public void Hand_written_machine_with_zero_delay_completes_synchronously()
        {
            var future = AddAfterDelay.RunAsync(1, 1, 0);
            Assert.True(future.IsCompleted);
            Assert.Equal(4, future.Result);
        }

        [Fact]
        public void Iterator_machine_matches_the_hand_written_one()
        {
            var future = AddAfterDelayIterator.RunAsync(3, 4, 40);
            Assert.False(future.IsCompleted);
            Assert.Equal(14, future.Result);
        }

        [Fact]
        public void Iterator_machine_routes_a_throw_to_the_future()
        {
            var future = AddAfterDelayIterator.RunAsync(-1, 4, 10);
            future.Wait();
            Assert.True(future.IsFaulted);
            Assert.IsType<ArgumentOutOfRangeException>(future.Exception);
        }

        [Fact]
        public void Iterator_machine_faults_when_a_yielded_future_faults() => NoContext.Run(() =>
        {
            var failing = new Promise<int>();
            var future = AsyncProxy.Run(Steps(failing));
            Assert.False(future.IsCompleted);
            failing.SetException(new InvalidOperationException("step failed"));
            Assert.True(future.IsFaulted);
            Assert.Equal("step failed", future.Exception.Message);
        });

        private static IEnumerable<IFuture> Steps(IFuture<int> failing)
        {
            yield return Futures.Completed;
            yield return failing;
            throw new Exception("never reached");
        }

        [Fact]
        public void Iterator_machine_reads_a_typed_result_after_yield()
        {
            var source = new Promise<string>();
            var future = AsyncProxy.Run<int>(ret => ReadLength(source, ret));
            source.SetResult("twelve chars");
            Assert.Equal(12, future.Result);
        }

        private static IEnumerable<IFuture> ReadLength(IFuture<string> source, Return<int> ret)
        {
            yield return source;
            ret.Value = source.Result.Length;
        }

        [Fact]
        public void ExecutionContext_flows_across_the_await()
        {
            CallContext.LogicalSetData("tenant", "acme");
            try
            {
                var future = AsyncProxy.Run<object>(ret => ReadTenantAfterDelay(ret));
                future.Wait();
                Assert.Equal("acme", future.Result);
            }
            finally
            {
                CallContext.FreeNamedDataSlot("tenant");
            }
        }

        private static IEnumerable<IFuture> ReadTenantAfterDelay(Return<object> ret)
        {
            yield return Futures.Delay(20);
            ret.Value = CallContext.LogicalGetData("tenant");
        }

        [Fact]
        public void Continuation_posts_back_to_the_captured_SynchronizationContext()
        {
            var context = new RecordingContext();
            var previous = SynchronizationContext.Current;
            SynchronizationContext.SetSynchronizationContext(context);
            try
            {
                var promise = new Promise<int>();
                var ranOn = 0;
                promise.GetAwaiter().OnCompleted(() => ranOn = Thread.CurrentThread.ManagedThreadId);

                var completer = new Thread(() => promise.SetResult(1));
                completer.Start();
                completer.Join();

                Assert.Equal(0, ranOn);
                Assert.Single(context.Posted);
                context.RunAll();
                Assert.Equal(Thread.CurrentThread.ManagedThreadId, ranOn);
            }
            finally
            {
                SynchronizationContext.SetSynchronizationContext(previous);
            }
        }

        [Fact]
        public void ContinueOnAnyThread_skips_the_SynchronizationContext()
        {
            var context = new RecordingContext();
            var previous = SynchronizationContext.Current;
            SynchronizationContext.SetSynchronizationContext(context);
            try
            {
                var promise = new Promise<int>();
                var ran = false;
                promise.ContinueOnAnyThread().OnCompleted(() => ran = true);
                promise.SetResult(1);
                Assert.True(ran);
                Assert.Empty(context.Posted);
            }
            finally
            {
                SynchronizationContext.SetSynchronizationContext(previous);
            }
        }

        private sealed class RecordingContext : SynchronizationContext
        {
            public readonly List<Action> Posted = new List<Action>();

            public override void Post(SendOrPostCallback d, object state)
            {
                lock (Posted) Posted.Add(() => d(state));
            }

            public void RunAll()
            {
                Action[] batch;
                lock (Posted) { batch = Posted.ToArray(); Posted.Clear(); }
                foreach (var a in batch) a();
            }
        }
    }
}
