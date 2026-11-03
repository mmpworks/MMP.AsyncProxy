using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using MMP.AsyncProxy.CompilerReference;
using Xunit;
using Xunit.Abstractions;

namespace MMP.AsyncProxy.Tests
{
    /// <summary>
    /// The two console samples that had no test. The comparison program runs as a process,
    /// because referencing it would drag the net48 build of the library into this test's
    /// folder beside the net35 one under test. The compiler-reference method must give the
    /// same answer as the hand-written machine in samples/MMP.AsyncProxy.Samples.
    /// </summary>
    public class SampleProgramTests
    {
        private readonly ITestOutputHelper _out;
        public SampleProgramTests(ITestOutputHelper output) { _out = output; }

        [Fact]
        public void Comparison_console_three_approaches_all_compute_the_same_sum()
        {
            string output = RunComparison("8");
            string[] rows = output.Split('\n').Where(l => l.StartsWith("thread per") || l.StartsWith("thread pool") || l.StartsWith("state machine")).ToArray();
            Assert.Equal(3, rows.Length);
            Assert.All(rows, r => Assert.Contains(" yes", r));
            Assert.All(rows, r => Assert.DoesNotContain(" NO", r));
        }

        [Fact]
        public void Comparison_console_pool_waves_prints_both_sides()
        {
            string output = RunComparison("waves 8");
            Assert.Contains("A. Thread pool", output);
            Assert.Contains("B. The same jobs as state machines", output);
            Assert.Equal(2, output.Split('\n').Count(l => l.Contains("all 8 jobs finished")));
        }

        [Fact]
        public async System.Threading.Tasks.Task Compiler_reference_method_gives_the_same_answer_as_the_hand_written_machine()
        {
            Assert.Equal(14, await AddAfterDelayReal.RunAsync(3, 4, 1));
            IFuture<int> ours = Samples.AddAfterDelay.RunAsync(3, 4, 1);
            Assert.True(ours.Wait(5000));
            Assert.Equal(14, ours.Result);
        }

        private string RunComparison(string args)
        {
            string config = typeof(SampleProgramTests).Assembly.GetCustomAttribute<AssemblyConfigurationAttribute>().Configuration;
            string exe = Path.Combine(RepoRoot.Find(), "samples", "MMP.AsyncProxy.Comparison", "bin", config, "net48", "MMP.AsyncProxy.Comparison.exe");
            Assert.True(File.Exists(exe), "build the comparison sample first: " + exe);
            var info = new ProcessStartInfo(exe, args) { RedirectStandardOutput = true, UseShellExecute = false, CreateNoWindow = true };
            using (var p = Process.Start(info))
            {
                string output = p.StandardOutput.ReadToEnd();
                Assert.True(p.WaitForExit(60000), "the comparison console did not finish in a minute");
                _out.WriteLine(output);
                Assert.Equal(0, p.ExitCode);
                return output;
            }
        }
    }
}
