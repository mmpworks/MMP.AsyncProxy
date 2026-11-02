using System.Diagnostics;
using System.Threading;
using MMP.AsyncProxy.Forecourt;
using Xunit;

namespace MMP.AsyncProxy.Tests
{
    /// <summary>
    /// Kevin's pump and Steve's pump, from the dinner in docs/course/00-dinner.md, do the
    /// same two jobs: stop the valve at the ceiling, and ask the host for a hold with a
    /// timeout. These run both against the same fake hardware.
    /// </summary>
    public class ForecourtTests
    {
        [Fact]
        public void Kevins_pulser_thread_closes_the_valve_at_the_ceiling()
        {
            var pulser = new Pulser();
            var valve = new Valve();
            using (var pump = new KevinsPump(pulser, valve, new SerialLink(), pollMs: 5))
            using (var stopped = new ManualResetEvent(false))
            {
                pump.StartDelivery(ceilingGallons: 0.5, onStopped: () => stopped.Set());
                Assert.True(valve.IsOpen);
                pulser.Pulse(499);
                Thread.Sleep(30);
                Assert.True(valve.IsOpen, "closed before the ceiling");
                pulser.Pulse(1);
                Assert.True(stopped.WaitOne(2000, false), "never stopped");
                Assert.False(valve.IsOpen);
                Assert.Equal(0.5, pump.Gallons);
            }
        }

        [Fact]
        public void Steves_pulser_loop_closes_the_valve_at_the_ceiling_with_no_thread_of_its_own()
        {
            var pulser = new Pulser();
            var valve = new Valve();
            using (var pump = new StevesPump(pulser, valve, new SerialLink(), pollMs: 5))
            {
                var before = Process.GetCurrentProcess().Threads.Count;
                var delivery = pump.StartDelivery(ceilingGallons: 0.5);
                Assert.True(valve.IsOpen);
                pulser.Pulse(499);
                Thread.Sleep(30);
                Assert.True(valve.IsOpen, "closed before the ceiling");
                Assert.False(delivery.IsCompleted);
                pulser.Pulse(1);
                delivery.Wait();
                Assert.False(valve.IsOpen);
                Assert.Equal(0.5, pump.Gallons);
                // The pool may have added a thread or two for the timer callbacks; a dedicated pulser thread would be one more, forever.
                Assert.True(Process.GetCurrentProcess().Threads.Count - before <= 2);
            }
        }

        [Fact]
        public void Kevins_host_call_blocks_the_caller_until_the_reply_lands()
        {
            var link = new SerialLink();
            using (var pump = new KevinsPump(new Pulser(), new Valve(), link, pollMs: 5))
            {
                // The controller answers on another thread a moment after the request goes out.
                var controller = new Thread(() => { Thread.Sleep(20); link.Reply("APPROVED 30.00"); });
                controller.Start();
                var clock = Stopwatch.StartNew();
                var answer = pump.Authorize("4111", timeoutMs: 2000);
                Assert.Equal("APPROVED 30.00", answer);
                Assert.True(clock.ElapsedMilliseconds >= 15, "returned before the reply");   // the caller sat in WaitOne the whole time
                Assert.Equal("AUTH 4111", link.LastRequest);
                controller.Join();
            }
        }

        [Fact]
        public void Steves_host_call_returns_at_once_and_the_reply_completes_the_future()
        {
            var link = new SerialLink();
            using (var pump = new StevesPump(new Pulser(), new Valve(), link, pollMs: 5))
            {
                var clock = Stopwatch.StartNew();
                var answer = pump.Authorize("4111", timeoutMs: 2000);
                Assert.True(clock.ElapsedMilliseconds < 50, "the caller waited");           // the thread came straight back
                Assert.False(answer.IsCompleted);
                Assert.Equal("AUTH 4111", link.LastRequest);

                link.Reply("APPROVED 30.00");                                               // the UART interrupt, on this thread
                answer.Wait();
                Assert.Equal("APPROVED 30.00", answer.Result);
            }
        }

        [Fact]
        public void Both_pumps_time_out_when_the_controller_stays_silent()
        {
            var link = new SerialLink();
            using (var kevin = new KevinsPump(new Pulser(), new Valve(), link, pollMs: 5))
            using (var steve = new StevesPump(new Pulser(), new Valve(), link, pollMs: 5))
            {
                Assert.Equal("TIMEOUT", kevin.Authorize("4111", timeoutMs: 40));
                var answer = steve.Authorize("4111", timeoutMs: 40);
                answer.Wait();
                Assert.Equal("TIMEOUT", answer.Result);
            }
        }
    }
}
