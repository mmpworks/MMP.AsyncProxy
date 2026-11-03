using System;
using System.Collections.Generic;
using Xunit;

namespace MMP.AsyncProxy.Tests
{
    /// <summary>
    /// The 2026-11-03 course review found that a throwing finally in an iterator body
    /// escaped MoveNext and left the future Pending forever. These pin the fix: the
    /// future always settles, and the first fault is the one the caller sees.
    /// </summary>
    public class IteratorCleanupTests
    {
        [Fact]
        public void A_finally_that_throws_after_a_faulted_step_still_settles_the_future_with_the_first_fault()
        {
            var step = new Promise<int>();
            IFuture future = AsyncProxy.Run(FaultThenThrowInFinally(step.Future));
            Assert.False(future.IsCompleted);

            step.SetException(new InvalidOperationException("step failed"));

            Assert.True(future.Wait(2000), "the future never settled");
            Assert.True(future.IsFaulted);
            Assert.IsType<InvalidOperationException>(future.Exception);
            Assert.Equal("step failed", future.Exception.Message);
        }

        [DesktopFact("Exception.Data")]
        public void The_cleanup_fault_rides_on_the_first_fault_in_Data()
        {
            var step = new Promise<int>();
            IFuture future = AsyncProxy.Run(FaultThenThrowInFinally(step.Future));
            step.SetException(new InvalidOperationException("step failed"));
            Assert.True(future.Wait(2000));
            Assert.IsType<ApplicationException>(future.Exception.Data[AsyncProxy.DisposeFaultKey]);
        }

        [Fact]
        public void A_finally_that_throws_on_the_happy_path_faults_the_method()
        {
            IFuture future = AsyncProxy.Run(ThrowInFinally());
            Assert.True(future.Wait(2000), "the future never settled");
            Assert.True(future.IsFaulted);
            Assert.IsType<ApplicationException>(future.Exception);
        }

        [Fact]
        public void A_body_that_throws_before_its_first_yield_faults_the_method()
        {
            IFuture<int> future = AsyncProxy.Run<int>(ret => ThrowFirst(ret));
            Assert.True(future.Wait(2000));
            Assert.True(future.IsFaulted);
            Assert.IsType<ArgumentException>(future.Exception);
        }

        private static IEnumerable<IFuture> FaultThenThrowInFinally(IFuture<int> step)
        {
            try
            {
                yield return step;
            }
            finally
            {
                throw new ApplicationException("cleanup failed");
            }
        }

        private static IEnumerable<IFuture> ThrowInFinally()
        {
            try
            {
                yield return Futures.Completed;
            }
            finally
            {
                throw new ApplicationException("cleanup failed");
            }
        }

        private static IEnumerable<IFuture> ThrowFirst(Return<int> ret)
        {
            throw new ArgumentException("bad input");
#pragma warning disable CS0162
            yield break;
#pragma warning restore CS0162
        }
    }
}
