using System.Linq;
using Xunit;
using Xunit.Abstractions;

namespace MMP.AsyncProxy.Fuzz
{
    /// <summary>
    /// The short door: every generator on eight fixed seeds, a few hundred rounds each, so
    /// `dotnet test` runs the fuzz suite in seconds. The long door is `dotnet run -- 60`.
    /// A failure message carries the generator and the round seed to replay.
    /// </summary>
    public class FuzzTests
    {
        private const int RoundsPerSeed = 40;
        private readonly ITestOutputHelper _out;
        public FuzzTests(ITestOutputHelper output) { _out = output; }

        public static TheoryData<string, int> Cases()
        {
            var data = new TheoryData<string, int>();
            foreach (var g in Fuzzer.All)
                foreach (int seed in new[] { 1, 2, 3, 5, 8, 13, 21, 34 })
                    data.Add(g.Name, seed);
            return data;
        }

        [Theory]
        [MemberData(nameof(Cases))]
        public void Generator_holds_its_invariants(string generator, int seed)
        {
            IGenerator g = Fuzzer.All.Single(x => x.Name == generator);
            Fuzzer.Run(g, seed, RoundsPerSeed);
            _out.WriteLine(generator + " seed " + seed + ": " + RoundsPerSeed + " rounds clean");
        }

        [Fact]
        public void Library_under_fuzz_is_the_net35_build()
        {
            Assert.Equal("v2.0.50727", typeof(Promise<int>).Assembly.ImageRuntimeVersion);
        }
    }
}
