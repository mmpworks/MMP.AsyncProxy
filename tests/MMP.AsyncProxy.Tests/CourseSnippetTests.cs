using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using Xunit;

namespace MMP.AsyncProxy.Tests
{
    /// <summary>
    /// The course's small illustrative blocks, run for real. Each test holds the lines of one
    /// fence verbatim (CourseFenceTests finds them here) and asserts what the chapter says
    /// about them. A test is named after the chapter file and the line of its opening fence
    /// at the time it was written, so a reader can find the block it proves.
    /// </summary>
    public class CourseSnippetTests
    {
        private const int Bound = 10000;

        // ---- 01-why-threads-hurt.md: the first job-board ticket ----

        private readonly ManualResetEvent _checked = new ManualResetEvent(false);
        private int _checkThread;

        private void CompareCountToCeiling()
        {
            _checkThread = Thread.CurrentThread.ManagedThreadId;
            _checked.Set();
        }

        [Fact]
        public void Ch01_L76_a_queued_delegate_runs_on_a_pool_worker()
        {
            ThreadPool.QueueUserWorkItem(delegate
            {
                // This is the ticket. A free crew worker will run it.
                CompareCountToCeiling();
            });

            Assert.True(_checked.WaitOne(Bound), "the pool never ran the ticket");
            Assert.NotEqual(Thread.CurrentThread.ManagedThreadId, _checkThread);
        }

        // ---- 02-callbacks-and-promises.md: a serial link the pumps can talk to ----

        /// <summary>Answers each Send on a pool thread, or never when Answer is null.</summary>
        private sealed class FakeLink
        {
            public event Action<string> DataReceived;
            public string Answer;
            public string LastSent;

            public void Send(string text)
            {
                LastSent = text;
                if (Answer == null) return;
                string answer = Answer;
                ThreadPool.QueueUserWorkItem(delegate
                {
                    Action<string> handler = DataReceived;
                    if (handler != null) handler(answer);
                });
            }

            public bool HasListeners { get { return DataReceived != null; } }
        }

        /// <summary>Kevin's blocking Authorize, as the chapter shows it in its two commented copies.</summary>
        private sealed class KevinsSerialPump
        {
            private readonly FakeLink _link;
            public KevinsSerialPump(FakeLink link) { _link = link; }

            public string Authorize(string card, int timeoutMs)
            {
                string reply = null;
                using (AutoResetEvent arrived = new AutoResetEvent(false))
                {
                    Action<string> onData = delegate(string text)
                    {
                        reply = text;
                        arrived.Set();
                    };
                    _link.DataReceived += onData;
                    try
                    {
                        _link.Send("AUTH " + card);
                        if (!arrived.WaitOne(timeoutMs, false)) return "TIMEOUT";
                        return reply;
                    }
                    finally
                    {
                        _link.DataReceived -= onData;
                    }
                }
            }
        }

        [Fact]
        public void Ch02_L11_Kevins_Authorize_blocks_until_the_reply_and_unsubscribes()
        {
            var link = new FakeLink { Answer = "APPROVED" };
            string reply = new KevinsSerialPump(link).Authorize("4111", Bound);

            Assert.Equal("APPROVED", reply);
            Assert.Equal("AUTH 4111", link.LastSent);
            Assert.False(link.HasListeners);
        }

        [Fact]
        public void Ch02_L72_Kevins_Authorize_returns_TIMEOUT_when_the_controller_stays_quiet()
        {
            var link = new FakeLink { Answer = null };
            string reply = new KevinsSerialPump(link).Authorize("4111", 50);

            Assert.Equal("TIMEOUT", reply);
            Assert.False(link.HasListeners);
        }

        /// <summary>The promise-based Authorize and its caller, as chapter 2 writes them.</summary>
        private sealed class PromiseSerialPump
        {
            private readonly FakeLink _link;
            public PromiseSerialPump(FakeLink link) { _link = link; }

            public IFuture<string> Authorize(string card, int timeoutMs)
            {
                Promise<string> reply = new Promise<string>(
                    PromiseOptions.RunContinuationsAsynchronously);

                Action<string> onData = delegate(string text)
                {
                    reply.TrySetResult(text);
                };

                _link.DataReceived += onData;

                reply.Future.ContinueOnAnyThread().OnCompleted(delegate
                {
                    _link.DataReceived -= onData;
                });

                try
                {
                    _link.Send("AUTH " + card);

                    IFuture timeout = Futures.Delay(timeoutMs);

                    timeout.ContinueOnAnyThread().OnCompleted(delegate
                    {
                        reply.TrySetResult("TIMEOUT");
                    });
                }
                catch (Exception error)
                {
                    reply.TrySetException(error);
                }

                return reply.Future;
            }

            public IFuture<string> Sell(string card)
            {
                IFuture<string> authorization = Authorize(card, 30000);
                authorization.ContinueOnAnyThread().OnCompleted(delegate
                {
                    if (authorization.IsFaulted)
                    {
                        Console.WriteLine("Authorization failed: " + authorization.Exception.Message);
                        return;
                    }
                    Console.WriteLine("Authorization reply: " + authorization.Result);
                });
                Console.WriteLine("The caller can do other work while the reply is pending.");
                return authorization;
            }
        }

        [Fact]
        public void Ch02_L220_promise_Authorize_returns_a_future_the_reply_completes()
        {
            var link = new FakeLink { Answer = "APPROVED" };
            IFuture<string> reply = new PromiseSerialPump(link).Authorize("4111", Bound);

            Assert.True(reply.Wait(Bound));
            Assert.Equal("APPROVED", reply.Result);
            SpinWait.SpinUntil(delegate { return !link.HasListeners; }, Bound);
            Assert.False(link.HasListeners);
        }

        [Fact]
        public void Ch02_L220_promise_Authorize_completes_with_TIMEOUT_when_the_timer_wins()
        {
            var link = new FakeLink { Answer = null };
            IFuture<string> reply = new PromiseSerialPump(link).Authorize("4111", 30);

            Assert.True(reply.Wait(Bound));
            Assert.Equal("TIMEOUT", reply.Result);
        }

        [Fact]
        public void Ch02_L299_the_caller_registers_its_next_step_and_carries_on()
        {
            var link = new FakeLink { Answer = "APPROVED" };
            IFuture<string> authorization = new PromiseSerialPump(link).Sell("4111");

            Assert.True(authorization.Wait(Bound));
            Assert.False(authorization.IsFaulted);
            Assert.Equal("APPROVED", authorization.Result);
        }

        // ---- 02-callbacks-and-promises.md: first completion wins ----

        private readonly List<string> _ran = new List<string>();
        private void ArmThePump() { _ran.Add("A"); }
        private void ShowApproved() { _ran.Add("B"); }

        [Fact]
        public void Ch02_L651_first_completion_wins_and_both_continuations_run_in_order()
        {
            NoContext.Run(delegate
            {
                Promise<string> reply = new Promise<string>();

                reply.Future.GetAwaiter().OnCompleted(delegate { ArmThePump(); });   // continuation A
                reply.Future.GetAwaiter().OnCompleted(delegate { ShowApproved(); }); // continuation B

                bool first = reply.TrySetResult("OK");
                bool second = reply.TrySetCanceled();

                Assert.True(first);
                Assert.False(second);
                Assert.Equal("OK", reply.Future.Result);
                Assert.Equal(new[] { "A", "B" }, _ran.ToArray());
            });
        }

        [Fact]
        public void Ch02_L708_the_default_promise_calls_back_on_the_completing_thread_before_SetResult_returns()
        {
            NoContext.Run(delegate
            {
                Promise<string> reply = new Promise<string>();
                int callbackThread = 0;
                bool returned = false;
                bool ranBeforeReturn = false;

                reply.Future.GetAwaiter().OnCompleted(delegate
                {
                    Console.WriteLine("callback ran on thread " + Thread.CurrentThread.ManagedThreadId);
                    callbackThread = Thread.CurrentThread.ManagedThreadId;
                    ranBeforeReturn = !returned;
                });
                Console.WriteLine("completing on thread " + Thread.CurrentThread.ManagedThreadId);
                reply.SetResult("OK");
                returned = true;
                Console.WriteLine("SetResult has returned");

                Assert.Equal(Thread.CurrentThread.ManagedThreadId, callbackThread);
                Assert.True(ranBeforeReturn);
            });
        }

        [Fact]
        public void Ch02_L766_try_it_registered_prints_before_got_hello()
        {
            NoContext.Run(delegate
            {
                var printed = new List<string>();
                var promise = new Promise<string>();
                IFuture<string> future = promise.Future;

                future.GetAwaiter().OnCompleted(delegate
                {
                    Console.WriteLine("got " + future.Result);
                    printed.Add("got " + future.Result);
                });
                Console.WriteLine("registered");
                printed.Add("registered");

                promise.SetResult("hello");

                Assert.Equal(new[] { "registered", "got hello" }, printed.ToArray());
            });
        }

        // ---- 05-context-rides-along.md ----

        [ThreadStatic] static string CurrentTenant;

        [Fact]
        public void Ch05_L57_a_thread_static_holds_one_value_per_thread()
        {
            CurrentTenant = "acme";
            string seenElsewhere = "unset";
            var other = new Thread(delegate() { seenElsewhere = CurrentTenant; });
            other.Start();
            Assert.True(other.Join(Bound));

            Assert.Equal("acme", CurrentTenant);
            Assert.Null(seenElsewhere);
            CurrentTenant = null;
        }

        /// <summary>The display thread's queue from the chapter: Post only enqueues, the owning thread drains.</summary>
        private sealed class DisplayQueue : IPostTarget
        {
            public readonly Queue<Action> Posted = new Queue<Action>();
            public void Post(Action action) { lock (Posted) Posted.Enqueue(action); }
        }

        [Fact]
        public void Ch05_L188_a_registered_post_target_receives_the_continuation_instead_of_running_it_inline()
        {
            NoContext.Run(delegate
            {
                bool ran = false;
                PostTarget.SetForCurrentThread(new DisplayQueue());
                try
                {
                    var queue = (DisplayQueue)PostTarget.Current;
                    var promise = new Promise<string>();
                    promise.Future.GetAwaiter().OnCompleted(delegate { ran = true; });

                    promise.SetResult("OK");
                    Assert.False(ran);
                    Action posted = Assert.Single(queue.Posted);

                    posted();
                    Assert.True(ran);
                }
                finally
                {
                    PostTarget.SetForCurrentThread(null);
                }
                Assert.Null(PostTarget.Current);
            });
        }

        // ---- 06-threads-vs-the-machine.md ----

        [Fact]
        public void Ch06_L126_sixty_four_sleeping_work_items_all_deliver()
        {
            int delivered = 0;
            for (int i = 0; i < 64; i++)
            {
                ThreadPool.QueueUserWorkItem(delegate
                {
                    Thread.Sleep(200);
                    Interlocked.Increment(ref delivered);
                });
            }

            Assert.True(SpinWait.SpinUntil(delegate { return Thread.VolatileRead(ref delivered) == 64; }, 60000),
                "only " + Thread.VolatileRead(ref delivered) + " of 64 work items finished");
        }

        // ---- 07-the-iterator-trick.md ----

        [Fact]
        public void Ch07_L25_Except_yields_the_remaining_distinct_numbers()
        {
            var printed = new List<int>();
            int[] numbers = { 1, 2, 3 };
            int[] excluded = { 2 };

            IEnumerable<int> remaining = numbers.Except(excluded);
            foreach (int number in remaining)
            {
                Console.WriteLine(number);
                printed.Add(number);
            }

            Assert.Equal(new[] { 1, 3 }, printed.ToArray());
        }

        /// <summary>The output loop of the reference-source ExceptIterator, around the setup the chapter leaves out.</summary>
        private static IEnumerable<TSource> ExceptIterator<TSource>(IEnumerable<TSource> first, IEnumerable<TSource> second)
        {
            HashSet<TSource> set = new HashSet<TSource>(second);
            foreach (TSource element in first)
                if (set.Add(element)) yield return element;
        }

        [Fact]
        public void Ch07_L50_set_Add_skips_excluded_values_and_duplicates()
        {
            int[] result = ExceptIterator(new[] { 1, 2, 1, 3, 3 }, new[] { 2 }).ToArray();
            Assert.Equal(new[] { 1, 3 }, result);
        }

        IEnumerable<int> Count()
        {
            // The body first runs when a consumer calls the iterator's MoveNext.
            yield return 1;
            int x = 2;
            yield return x;
            yield return x + 1;
        }

        [Fact]
        public void Ch07_L161_Count_hands_out_1_2_3_one_at_a_time()
        {
            IEnumerator<int> steps = Count().GetEnumerator();
            Assert.True(steps.MoveNext()); Assert.Equal(1, steps.Current);
            Assert.True(steps.MoveNext()); Assert.Equal(2, steps.Current);
            Assert.True(steps.MoveNext()); Assert.Equal(3, steps.Current);
            Assert.False(steps.MoveNext());
        }

        public static IFuture<int> AddAfterDelayAsync(int a, int b)
        {
            // Run creates the driver and returns a future for the whole Body operation.
            return AsyncProxy.Run<int>(delegate(Return<int> ret) { return Body(a, b, ret); });
        }

        private static IEnumerable<IFuture> Body(int a, int b, Return<int> ret)
        {
            yield return Futures.Delay(10);
            int sum = a + b;
            yield return Futures.Delay(10);
            // The driver copies this value into its promise when the iterator ends.
            ret.Value = sum * 2;
        }

        [Fact]
        public void Ch07_L232_the_iterator_version_of_AddAfterDelay_returns_14()
        {
            IFuture<int> future = AddAfterDelayAsync(3, 4);
            Assert.True(future.Wait(Bound));
            Assert.Equal(14, future.Result);
        }

        private static IEnumerable<IFuture> RiskyBody(IFuture<int> risky, Action<int> use)
        {
            // Shortened sketch: handle cancellation separately when risky can be canceled.
            yield return Futures.Observe(risky);
            if (risky.IsFaulted) { /* handle it */ }
            else { use(risky.Result); }
        }

        [Fact]
        public void Ch07_L348_Observe_lets_the_body_inspect_a_failed_step()
        {
            var used = new List<int>();
            IFuture failed = AsyncProxy.Run(RiskyBody(Futures.FromException<int>(new InvalidOperationException("no reply")), used.Add));
            IFuture succeeded = AsyncProxy.Run(RiskyBody(Futures.FromResult(5), used.Add));

            Assert.True(failed.Wait(Bound));
            Assert.True(succeeded.Wait(Bound));
            Assert.False(failed.IsFaulted);
            Assert.False(succeeded.IsFaulted);
            Assert.Equal(new[] { 5 }, used.ToArray());
        }
    }
}
