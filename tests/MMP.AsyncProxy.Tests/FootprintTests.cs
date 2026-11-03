using System;
using System.Collections.Generic;
using Xunit;
using Xunit.Abstractions;

namespace MMP.AsyncProxy.Tests
{
    /// <summary>
    /// How many bytes one parked worker costs. The CE budget in MMP.GasPumpSimulator
    /// (docs/ce-budget.md) claims "a few hundred bytes per worker" and "about 1 KB of
    /// garbage per wake-up". This pins both with the allocation counter on the desktop
    /// CLR, which is an upper bound for a 32-bit board: references there are half the size.
    /// </summary>
    public class FootprintTests
    {
        private readonly ITestOutputHelper _out;
        public FootprintTests(ITestOutputHelper output) { _out = output; }

        [Fact]
        public void One_parked_iterator_worker_costs_under_two_kilobytes()
        {
            // Warm up so type loading and JIT are not in the measurement.
            Park(new Promise<int>(true));
            GC.Collect();

            long before = GC.GetAllocatedBytesForCurrentThread();
            var promise = new Promise<int>(true);
            var future = Park(promise);
            long parked = GC.GetAllocatedBytesForCurrentThread() - before;

            promise.SetResult(1);
            future.Wait();
            long total = GC.GetAllocatedBytesForCurrentThread() - before;

            _out.WriteLine($"[{BuildInfo.Target}] parked worker: {parked} bytes; after one wake-up: {total} bytes");
            Assert.InRange(parked, 1, 2048);
            Assert.InRange(total, parked, 4096);
        }

        [Fact]
        public void One_thousand_parked_workers_cost_under_two_megabytes_and_no_threads()
        {
            GC.Collect();
            int threadsBefore = System.Diagnostics.Process.GetCurrentProcess().Threads.Count;
            long before = GC.GetAllocatedBytesForCurrentThread();
            var promises = new List<Promise<int>>(1000);
            var futures = new List<IFuture>(1000);
            for (int i = 0; i < 1000; i++)
            {
                var p = new Promise<int>(true);
                promises.Add(p);
                futures.Add(Park(p));
            }
            long parked = GC.GetAllocatedBytesForCurrentThread() - before;
            int threadsParked = System.Diagnostics.Process.GetCurrentProcess().Threads.Count;
            _out.WriteLine($"[{BuildInfo.Target}] 1000 parked workers: {parked} bytes, {parked / 1000} per worker; process threads {threadsBefore} before, {threadsParked} parked");
            Assert.InRange(parked, 1, 2 * 1024 * 1024);
            // The README's "threads held by those 1,000 parked workers: 0". A parked worker is an
            // object, so the count must not grow with them; a few threads of slack covers the
            // pool and the runner doing their own thing underneath.
            Assert.InRange(threadsParked, 0, threadsBefore + 4);

            foreach (var p in promises) p.SetResult(1);
            foreach (var f in futures) Assert.True(f.Wait(5000));
        }

        private static IFuture Park(Promise<int> promise)
        {
            return AsyncProxy.Run(Steps(promise.Future));
        }

        private static IEnumerable<IFuture> Steps(IFuture<int> next)
        {
            yield return Futures.Observe(next);
        }
    }
}
