using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading;
using Xunit;

namespace MMP.AsyncProxy.Tests
{
    /// <summary>
    /// The changes the training track's IL comparison and bench asked for, rows 1, 2,
    /// 3, 4, and 6 of the table in docs/prd-training.md. Each test pins the behaviour
    /// the row promised.
    /// </summary>
    public class ImprovementsTests
    {
        [Fact]
        public void Wait_with_a_timeout_says_false_while_pending_and_true_once_done()
        {
            var promise = new Promise<int>();
            var clock = Stopwatch.StartNew();
            Assert.False(promise.Future.Wait(30));
            Assert.True(clock.ElapsedMilliseconds >= 25, "returned before the timeout");

            promise.SetResult(1);
            Assert.True(promise.Future.Wait(0));
            Assert.True(promise.Future.Wait(1000));
        }

        [Fact]
        public void Wait_with_a_timeout_wakes_as_soon_as_the_promise_completes()
        {
            var promise = new Promise<int>();
            var completer = new Thread(() => { Thread.Sleep(20); promise.SetResult(7); });
            completer.Start();
            var clock = Stopwatch.StartNew();
            Assert.True(promise.Future.Wait(5000));
            Assert.True(clock.ElapsedMilliseconds < 2000, "waited for the whole timeout");
            completer.Join();
        }

        [Fact]
        public void Observe_of_a_settled_future_is_the_shared_completed_future()
        {
            Assert.Same(Futures.Completed, Futures.Observe(Futures.FromResult(3)));
            Assert.Same(Futures.Completed, Futures.Observe(Futures.FromException<int>(new ApplicationException("x"))));
            var canceled = new Promise<int>();
            canceled.SetCanceled();
            Assert.Same(Futures.Completed, Futures.Observe(canceled.Future));
        }

        [Fact]
        public void Observe_of_a_pending_future_still_completes_when_it_settles()
        {
            var promise = new Promise<int>();
            var observed = Futures.Observe(promise.Future);
            Assert.NotSame(Futures.Completed, observed);
            Assert.False(observed.IsCompleted);
            promise.SetException(new ApplicationException("late"));
            Assert.True(observed.Wait(1000));
            Assert.False(observed.IsFaulted);
            Assert.True(promise.Future.IsFaulted);
        }

        [Fact]
        public void True_and_False_are_shared_and_complete()
        {
            Assert.Same(Futures.True, Futures.True);
            Assert.True(Futures.True.IsCompleted);
            Assert.True(Futures.True.Result);
            Assert.False(Futures.False.Result);
            Assert.NotSame(Futures.True, Futures.False);
        }

        [Fact]
        public void An_iterator_step_that_already_succeeded_never_parks_and_never_boxes_an_awaiter()
        {
            var threadBefore = Thread.CurrentThread.ManagedThreadId;
            var seen = new List<int>();
            var future = AsyncProxy.Run<int>(ret => Body(seen, ret));
            Assert.True(future.IsCompleted, "a chain of completed steps should finish synchronously");
            Assert.Equal(3, future.Result);
            Assert.Equal(new[] { threadBefore, threadBefore, threadBefore }, seen);
        }

        private static IEnumerable<IFuture> Body(List<int> seen, Return<int> ret)
        {
            seen.Add(Thread.CurrentThread.ManagedThreadId);
            yield return Futures.True;
            seen.Add(Thread.CurrentThread.ManagedThreadId);
            yield return Futures.Observe(Futures.FromResult("done"));
            seen.Add(Thread.CurrentThread.ManagedThreadId);
            ret.Value = 3;
        }

        [Fact]
        public void An_iterator_step_that_already_faulted_still_faults_the_run()
        {
            var future = AsyncProxy.Run<int>(ret => FaultedBody(ret));
            Assert.True(future.IsCompleted);
            Assert.True(future.IsFaulted);
            Assert.IsType<ApplicationException>(future.Exception);
        }

        private static IEnumerable<IFuture> FaultedBody(Return<int> ret)
        {
            yield return Futures.FromException<int>(new ApplicationException("already broken"));
            ret.Value = 1;
        }

        [Fact]
        public void An_iterator_step_that_was_already_canceled_ends_the_run_canceled()
        {
            var canceled = new Promise<int>();
            canceled.SetCanceled();
            var future = AsyncProxy.Run<int>(ret => CanceledBody(canceled.Future, ret));
            Assert.True(future.IsCompleted);
            Assert.True(future.IsCanceled);
        }

        private static IEnumerable<IFuture> CanceledBody(IFuture step, Return<int> ret)
        {
            yield return step;
            ret.Value = 1;
        }

        [Fact]
        public void Two_hundred_delays_due_together_all_complete_and_in_time()
        {
            var clock = Stopwatch.StartNew();
            var delays = new IFuture[200];
            for (var i = 0; i < delays.Length; i++) delays[i] = Futures.Delay(50);
            Futures.WhenAll(delays).Wait();
            Assert.True(clock.ElapsedMilliseconds >= 45, $"fired early at {clock.ElapsedMilliseconds} ms");
            Assert.True(clock.ElapsedMilliseconds < 1000, $"took {clock.ElapsedMilliseconds} ms");
            foreach (var d in delays) Assert.True(d.IsCompleted && !d.IsFaulted && !d.IsCanceled);
        }

        [Fact]
        public void Delays_fire_in_due_order_whatever_order_they_were_made_in()
        {
            var order = new List<int>();
            var gate = new object();
            var longer = Futures.Delay(80);
            var shorter = Futures.Delay(20);
            longer.ContinueOnAnyThread().OnCompleted(() => { lock (gate) order.Add(80); });
            shorter.ContinueOnAnyThread().OnCompleted(() => { lock (gate) order.Add(20); });
            Futures.WhenAll(longer, shorter).Wait();
            Thread.Sleep(20);                                  // let both continuations land
            lock (gate) Assert.Equal(new[] { 20, 80 }, order);
        }

        [Fact]
        public void A_canceled_delay_leaves_the_wheel_and_never_fires()
        {
            var source = new CancelSource();
            var canceled = Futures.Delay(30, source.Token);
            var kept = Futures.Delay(30);
            source.Cancel();
            Assert.True(canceled.IsCanceled);
            kept.Wait();
            Assert.True(kept.IsCompleted && !kept.IsCanceled);
            Assert.True(canceled.IsCanceled);
        }

        [Fact]
        public void A_delay_added_earlier_than_the_one_the_wheel_was_armed_for_fires_first()
        {
            // The later delay is long on purpose. If the wheel failed to re-arm, the sooner one would
            // fire with it at 3 s; a busy pool can hold a 30 ms callback for a second, which must not
            // read as that failure. The later delay is left pending; the wheel drops it on its own.
            var clock = Stopwatch.StartNew();
            var later = Futures.Delay(3000);
            var sooner = Futures.Delay(30);                    // goes to the front; the wheel must re-arm
            Assert.True(sooner.Wait(2500), "the sooner delay never fired");
            Assert.True(clock.ElapsedMilliseconds < 2000, $"the sooner delay waited for the later one: {clock.ElapsedMilliseconds} ms");
            Assert.False(later.IsCompleted);
        }
    }
}
