using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading;

namespace MMP.AsyncProxy.Fuzz
{
    /// <summary>One random program against the library. A round builds it from the seed, runs it, and checks its invariants.</summary>
    public interface IGenerator
    {
        string Name { get; }
        /// <summary>Runs one round. Throws (any exception) when an invariant breaks or the round hangs.</summary>
        void Round(Random rng);
    }

    /// <summary>Carries the generator and the seed, so a failure can be replayed with `dotnet run -- replay name seed`.</summary>
    public sealed class FuzzFailure : Exception
    {
        public FuzzFailure(string generator, int seed, Exception inner)
            : base(generator + " failed on seed " + seed + ": " + inner.Message + "\n  replay: dotnet run --project tests/MMP.AsyncProxy.Fuzz -c Release -- replay " + generator + " " + seed, inner)
        {
            Generator = generator;
            Seed = seed;
        }

        public string Generator { get; }
        public int Seed { get; }
    }

    public static class Fuzzer
    {
        public static readonly IGenerator[] All =
        {
            new PromiseRaces(),
            new IteratorPrograms(),
            new Combinators(),
            new CancelRaces(),
            new DelayStorm(),
            new PostTargetRuns(),
        };

        /// <summary>Round i of a run uses its own seed derived from the run seed, so one failing round is replayable on its own.</summary>
        public static int RoundSeed(int runSeed, int round)
        {
            return unchecked(runSeed * 1000003 + round * 7919);
        }

        public static void Run(IGenerator generator, int runSeed, int rounds)
        {
            for (int i = 0; i < rounds; i++) RunOne(generator, RoundSeed(runSeed, i));
        }

        public static void RunOne(IGenerator generator, int seed)
        {
            try { generator.Round(new Random(seed)); }
            catch (Exception ex) { throw new FuzzFailure(generator.Name, seed, ex); }
        }

        /// <summary>Every generator, round-robin, for the given wall-clock budget. Returns rounds per generator; throws the first failure.</summary>
        public static Dictionary<string, int> RunFor(TimeSpan budget, int runSeed, Action<string> log)
        {
            var counts = All.ToDictionary(g => g.Name, g => 0);
            var clock = Stopwatch.StartNew();
            int round = 0;
            while (clock.Elapsed < budget)
            {
                foreach (IGenerator g in All)
                {
                    RunOne(g, RoundSeed(runSeed, round));
                    counts[g.Name]++;
                }
                round++;
                if (round % 50 == 0 && log != null) log(clock.Elapsed.TotalSeconds.ToString("F0") + " s, " + round + " rounds per generator");
            }
            return counts;
        }

        /// <summary>Waits with a bound and names the thing that hung.</summary>
        public static void MustSettle(IFuture future, string what, int ms = 5000)
        {
            if (!future.Wait(ms)) throw new TimeoutException(what + " did not settle in " + ms + " ms");
        }

        /// <summary>Runs each action on its own thread, starts them together, joins them all.</summary>
        public static void InParallel(params Action[] actions)
        {
            InParallel((IList<Action>)actions);
        }

        public static void InParallel(IList<Action> actions)
        {
            var go = new ManualResetEvent(false);
            var failures = new List<Exception>();
            var threads = actions.Select(a => new Thread(() =>
            {
                go.WaitOne();
                try { a(); }
                catch (Exception ex) { lock (failures) failures.Add(ex); }
            })).ToArray();
            foreach (var t in threads) t.Start();
            go.Set();
            foreach (var t in threads) t.Join();
            if (failures.Count > 0) throw new AggregateException("a parallel branch threw", failures);
        }

        /// <summary>A short, random busy wait so two threads land on a lock in a different order each round.</summary>
        public static void Jitter(Random rng, int maxSpins = 200)
        {
            int spins = rng.Next(maxSpins);
            if (spins == 0) return;
            if (rng.Next(8) == 0) Thread.Yield();
            Thread.SpinWait(spins);
        }
    }

    internal static class Program
    {
        /// <summary>
        /// dotnet run -- [seconds]                 run every generator for N seconds (default 30) on a clock seed
        /// dotnet run -- replay <generator> <seed> rerun one round
        /// </summary>
        private static int Main(string[] args)
        {
            if (args.Length >= 3 && args[0] == "replay")
            {
                IGenerator g = Fuzzer.All.FirstOrDefault(x => string.Equals(x.Name, args[1], StringComparison.OrdinalIgnoreCase));
                if (g == null) { Console.Error.WriteLine("no generator named " + args[1] + "; have: " + string.Join(", ", Fuzzer.All.Select(x => x.Name))); return 2; }
                int seed = int.Parse(args[2]);
                try { Fuzzer.RunOne(g, seed); Console.WriteLine(g.Name + " seed " + seed + ": passed"); return 0; }
                catch (FuzzFailure f) { Console.Error.WriteLine(f.Message); Console.Error.WriteLine(f.InnerException); return 1; }
            }

            int seconds = args.Length >= 1 ? int.Parse(args[0]) : 30;
            int runSeed = args.Length >= 2 ? int.Parse(args[1]) : Environment.TickCount;
            Console.WriteLine("MMP.AsyncProxy fuzz: " + seconds + " s, run seed " + runSeed + ", library " + typeof(Promise<int>).Assembly.ImageRuntimeVersion + " " + BuildInfo.Target);
            try
            {
                var counts = Fuzzer.RunFor(TimeSpan.FromSeconds(seconds), runSeed, Console.WriteLine);
                Console.WriteLine();
                Console.WriteLine("{0,-18} {1,8}", "generator", "rounds");
                foreach (var kv in counts) Console.WriteLine("{0,-18} {1,8}", kv.Key, kv.Value);
                Console.WriteLine();
                Console.WriteLine("0 failures in " + counts.Values.Sum() + " rounds.");
                return 0;
            }
            catch (FuzzFailure f)
            {
                Console.Error.WriteLine();
                Console.Error.WriteLine("FAIL " + f.Message);
                Console.Error.WriteLine(f.InnerException);
                return 1;
            }
        }
    }
}
