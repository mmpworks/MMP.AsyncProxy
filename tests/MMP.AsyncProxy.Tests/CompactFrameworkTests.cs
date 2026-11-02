using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using Xunit;

namespace MMP.AsyncProxy.Tests
{
    /// <summary>
    /// What the Compact Framework port adds, and what it gives up. The PostTarget tests
    /// run on both builds. The anchor test reads the loaded assembly's mscorlib reference,
    /// so a desktop build mislabeled as CF, or the reverse, fails here.
    /// </summary>
    public class CompactFrameworkTests
    {
        private const string CompactFrameworkKeyToken = "969db8053d3322ac";
        private const string DesktopKeyToken = "b77a5c561934e089";

        [Fact]
        public void BuildInfo_matches_the_mscorlib_the_library_was_compiled_against()
        {
            var mscorlib = typeof(Promise<int>).Assembly.GetReferencedAssemblies().Single(a => a.Name == "mscorlib");
            var token = BitConverter.ToString(mscorlib.GetPublicKeyToken()).Replace("-", "").ToLowerInvariant();
            if (BuildInfo.IsCompactFramework)
            {
                Assert.Equal("netcf35", BuildInfo.Target);
                Assert.Equal(CompactFrameworkKeyToken, token);
                Assert.Equal(new Version(3, 5, 0, 0), mscorlib.Version);
            }
            else
            {
                Assert.Equal("desktop", BuildInfo.Target);
                Assert.Equal(DesktopKeyToken, token);
            }
        }

        [Fact]
        public void A_registered_post_target_receives_the_continuation_instead_of_the_completing_thread() => NoContext.Run(() =>
        {
            // On the desktop build SynchronizationContext.Current wins, and xunit installs one.
            // Clear it so the post target is what the awaiter finds, as it would be on CF.
            var target = new RecordingTarget();
            PostTarget.SetForCurrentThread(target);
            try
            {
                var promise = new Promise<int>();
                var ranOn = 0;
                promise.GetAwaiter().OnCompleted(() => ranOn = Thread.CurrentThread.ManagedThreadId);

                var completer = new Thread(() => promise.SetResult(1));
                completer.Start();
                completer.Join();

                Assert.Equal(0, ranOn);
                Assert.Single(target.Posted);
                target.RunAll();
                Assert.Equal(Thread.CurrentThread.ManagedThreadId, ranOn);
            }
            finally
            {
                PostTarget.SetForCurrentThread(null);
            }
        });

        [Fact]
        public void ContinueOnAnyThread_ignores_the_post_target()
        {
            var target = new RecordingTarget();
            PostTarget.SetForCurrentThread(target);
            try
            {
                var promise = new Promise<int>();
                var ran = false;
                promise.ContinueOnAnyThread().OnCompleted(() => ran = true);
                promise.SetResult(1);
                Assert.True(ran);
                Assert.Empty(target.Posted);
            }
            finally
            {
                PostTarget.SetForCurrentThread(null);
            }
        }

        [Fact]
        public void Post_targets_are_per_thread_and_a_null_registration_removes_one()
        {
            var mine = new RecordingTarget();
            PostTarget.SetForCurrentThread(mine);
            try
            {
                IPostTarget seenOnOtherThread = mine;
                var other = new Thread(() => seenOnOtherThread = PostTarget.Current);
                other.Start();
                other.Join();

                Assert.Same(mine, PostTarget.Current);
                Assert.Null(seenOnOtherThread);

                PostTarget.SetForCurrentThread(null);
                Assert.Null(PostTarget.Current);
            }
            finally
            {
                PostTarget.SetForCurrentThread(null);
            }
        }

        [CompactFrameworkFact]
        public void Canceled_future_throws_a_plain_exception_on_the_Compact_Framework()
        {
            // No OperationCanceledException in CF 3.5, so the library's own type stands alone.
            Assert.Null(typeof(FutureCanceledException).BaseType!.BaseType!.BaseType);
            Assert.Equal(typeof(Exception), typeof(FutureCanceledException).BaseType);

            var promise = new Promise<int>();
            promise.SetCanceled();
            Assert.Throws<FutureCanceledException>(() => promise.Result);
        }

        [CompactFrameworkFact]
        public void A_canceled_body_still_ends_the_future_Canceled_on_the_Compact_Framework()
        {
            var future = AsyncProxy.Run<int>(ret => ThrowCanceled());
            future.Wait();
            Assert.True(future.IsCanceled);
            Assert.False(future.IsFaulted);
        }

        private static IEnumerable<IFuture> ThrowCanceled()
        {
            yield return Futures.Delay(1);
            throw new FutureCanceledException();
        }

        private sealed class RecordingTarget : IPostTarget
        {
            public readonly List<Action> Posted = new();
            public void Post(Action action) => Posted.Add(action);
            public void RunAll() { foreach (var a in Posted) a(); }
        }
    }
}
