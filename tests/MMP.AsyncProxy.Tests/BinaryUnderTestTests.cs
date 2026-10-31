using System.Linq;
using System.Runtime.Versioning;
using MMP.AsyncProxy.Samples;
using Xunit;

namespace MMP.AsyncProxy.Tests
{
    /// <summary>
    /// Anchor: the tests must run against the net35 build, never a net48 recompile.
    /// A net35 assembly carries CLR header v2.0.50727 and no TargetFrameworkAttribute
    /// (that attribute arrived in .NET 4.0).
    /// </summary>
    public class BinaryUnderTestTests
    {
        [Fact]
        public void Library_under_test_is_the_net35_build()
        {
            var asm = typeof(Promise<int>).Assembly;
            Assert.Equal("v2.0.50727", asm.ImageRuntimeVersion);
            Assert.Empty(asm.GetCustomAttributes(typeof(TargetFrameworkAttribute), false));
        }

        [Fact]
        public void Samples_under_test_are_the_net35_build()
        {
            var asm = typeof(AddAfterDelay).Assembly;
            Assert.Equal("v2.0.50727", asm.ImageRuntimeVersion);
            Assert.Empty(asm.GetCustomAttributes(typeof(TargetFrameworkAttribute), false));
        }

        [Fact]
        public void Test_project_itself_runs_on_net48()
        {
            var tfm = typeof(BinaryUnderTestTests).Assembly
                .GetCustomAttributes(typeof(TargetFrameworkAttribute), false)
                .Cast<TargetFrameworkAttribute>().Single();
            Assert.StartsWith(".NETFramework,Version=v4.8", tfm.FrameworkName);
        }
    }
}
