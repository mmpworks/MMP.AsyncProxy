using System;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using MMP.AsyncProxy.Sdk;
using Xunit;

namespace MMP.AsyncProxy.Tests
{
    /// <summary>
    /// Runs every example in docs/sdk.md. The examples live in samples/MMP.AsyncProxy.Sdk, one
    /// file per section of the guide, built as net35 C# 3; CourseFenceTests proves the guide's
    /// code blocks are those files. These tests prove the files do what the guide says.
    /// </summary>
    public class SdkTests
    {
        [Fact]
        public void Wrap_a_callback_api_reads_a_file_through_FromAsync()
        {
            string path = Path.GetTempFileName();
            try
            {
                byte[] payload = Encoding.UTF8.GetBytes("  hello from the OS  ");
                File.WriteAllBytes(path, payload);
                using (var stream = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.Read, 4096, FileOptions.Asynchronous))
                {
                    byte[] buffer = new byte[64];
                    IFuture<int> read = WrapACallbackApi.ReadAsync(stream, buffer);
                    Assert.True(read.Wait(5000));
                    Assert.Equal(payload.Length, read.Result);
                }
            }
            finally { File.Delete(path); }
        }

        [Fact]
        public void Wrap_a_callback_api_turns_an_event_into_a_future()
        {
            // No network in a unit test: a bad scheme makes WebClient raise DownloadDataCompleted with an error,
            // which the example must route to the promise as a fault, and unsubscribe.
            using (var client = new System.Net.WebClient())
            {
                var future = WrapACallbackApi.DownloadAsync(client, new Uri("file:///nonexistent-folder-for-sdk-test/nothing.bin"));
                Assert.True(future.Wait(10000), "the event never completed the promise");
                Assert.True(future.IsFaulted);
            }
        }

        [Fact]
        public void Write_an_async_method_reads_then_delays_then_trims()
        {
            string path = Path.GetTempFileName();
            try
            {
                File.WriteAllBytes(path, Encoding.UTF8.GetBytes("  trim me  "));
                using (var stream = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.Read, 4096, FileOptions.Asynchronous))
                {
                    IFuture<string> future = WriteAnAsyncMethod.FetchAndTrimAsync(stream);
                    Assert.True(future.Wait(5000));
                    Assert.Equal("trim me", future.Result);
                }
            }
            finally { File.Delete(path); }
        }

        [Fact]
        public void Consume_one_waits_with_a_bound_and_hangs_a_callback()
        {
            var promise = new Promise<string>();
            Assert.True(promise.Future.Wait(0) == false);
            var done = new ManualResetEvent(false);
            NoContext.Run(() =>
            {
                promise.Future.GetAwaiter().OnCompleted(() => done.Set());
                ConsumeOne.HangACallback(promise.Future);
            });
            promise.SetResult("x");
            Assert.True(done.WaitOne(2000, false));
            Assert.True(ConsumeOne.WaitWithABound(promise.Future));
        }

        [Fact]
        public void Consume_one_at_the_top_of_a_program_prints_the_result()
        {
            string path = Path.GetTempFileName();
            var writer = new StringWriter();
            TextWriter previous = Console.Out;
            try
            {
                File.WriteAllBytes(path, Encoding.UTF8.GetBytes(" top "));
                Console.SetOut(writer);
                using (var stream = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.Read, 4096, FileOptions.Asynchronous))
                    ConsumeOne.WaitAtTheTop(stream);
            }
            finally { Console.SetOut(previous); File.Delete(path); }
            // Other test classes run at the same time and may write to the console too, so look
            // for the line rather than demanding the whole capture.
            Assert.Contains("top", writer.ToString().Split('\n').Select(l => l.Trim()));
        }

        [Fact]
        public void Ui_threads_ContinueOnAnyThread_runs_the_continuation_on_the_completer()
        {
            var promise = new Promise<int>();
            int ranOn = 0;
            IAwaiter<int> awaiter = UiThreads.StayOffTheUiThread(promise.Future);
            awaiter.OnCompleted(() => ranOn = Thread.CurrentThread.ManagedThreadId);
            int completer = 0;
            var t = new Thread(() => { completer = Thread.CurrentThread.ManagedThreadId; promise.SetResult(1); });
            t.Start(); t.Join();
            Assert.Equal(completer, ranOn);
        }

        [DesktopFact("the registry path is the same on CF; this test only needs a thread of its own")]
        public void Ui_threads_an_owner_loop_gets_its_continuations_back()
        {
            using (var owner = new UiThreads.OwnerLoop())
            {
                var step = new Promise<int>();
                IFuture<int> resumedOn = UiThreads.RunOnOwner(owner, step.Future);
                Thread.Sleep(50);
                step.SetResult(1);                       // completes on the test thread
                Assert.True(resumedOn.Wait(5000), "the method never resumed");
                Assert.Equal(owner.ThreadId, resumedOn.Result);
            }
        }

        [Fact]
        public void Fan_out_fan_in_sums_every_answer()
        {
            var future = FanOutFanIn.TotalLengthAsync(new[] { "a", "bb", "ccc" });
            Assert.True(future.Wait(5000));
            Assert.Equal(6, future.Result);
        }

        [Fact]
        public void First_one_wins_names_the_winner()
        {
            var primary = new Promise<int>();
            var mirror = new Promise<int>();
            var first = FanOutFanIn.FirstToAnswerAsync(primary.Future, mirror.Future);
            mirror.SetResult(2);
            Assert.True(first.Wait(5000));
            Assert.Equal("mirror", first.Result);
            primary.SetResult(1);
        }

        [Fact]
        public void Handle_a_failed_step_falls_back_instead_of_faulting()
        {
            var risky = new Promise<int>();
            var future = HandleAFailedStep.ReadOrFallbackAsync(risky.Future, 42);
            risky.SetException(new IOException("disk gone"));
            Assert.True(future.Wait(5000));
            Assert.False(future.IsFaulted);
            Assert.Equal(42, future.Result);

            var fine = new Promise<int>();
            var ok = HandleAFailedStep.ReadOrFallbackAsync(fine.Future, 42);
            fine.SetResult(7);
            Assert.True(ok.Wait(5000));
            Assert.Equal(7, ok.Result);
        }

        [Fact]
        public void Cancel_ends_the_poll_Canceled_not_Faulted()
        {
            using (var poller = new CancelAPoll())
            {
                IFuture work = poller.Start(5);
                Thread.Sleep(60);
                poller.Stop();
                Assert.True(work.Wait(5000), "the poll never stopped");
                Assert.True(work.IsCanceled);
                Assert.False(work.IsFaulted);
                Assert.True(poller.Polls >= 1, "expected at least one poll before the cancel");
            }
        }

        [Fact]
        public void Fast_path_drains_queued_items_without_parking_and_parks_only_when_empty()
        {
            var tray = new FastPath.Tray<int>();
            int sum = 0;
            for (int i = 1; i <= 100; i++) tray.Put(i);
            IFuture drain = FastPath.Drain(tray, x => Interlocked.Add(ref sum, x));
            Assert.False(drain.IsCompleted);           // parked on the empty tray
            tray.Put(1000);
            tray.Close();
            Assert.True(drain.Wait(5000));
            Assert.Equal(5050 + 1000, sum);
        }

        [Fact]
        public void Continuations_off_your_stack_run_inline_by_default_and_on_the_pool_by_option()
        {
            int completer;
            int ranOn = ContinuationsOffYourStack.CompleteInline(out completer);
            Assert.Equal(completer, ranOn);

            bool ranBefore;
            IFuture<int> poolThread = ContinuationsOffYourStack.CompleteOnThePool(out ranBefore);
            Assert.True(poolThread.Wait(5000));
            Assert.False(ranBefore);
            Assert.NotEqual(Thread.CurrentThread.ManagedThreadId, poolThread.Result);
        }

        [DesktopFact("Exception.Data")]
        public void Faults_and_stacks_keep_the_first_stack_trace()
        {
            TextWriter previous = Console.Error;
            Console.SetError(TextWriter.Null);
            try
            {
                string where = FaultsAndStacks.WhereDidItFail(FaultsAndStacks.FailDeepAsync());
                Assert.NotNull(where);
                Assert.Contains("ThrowFromHere", where);
            }
            finally { Console.SetError(previous); }
        }
    }
}
