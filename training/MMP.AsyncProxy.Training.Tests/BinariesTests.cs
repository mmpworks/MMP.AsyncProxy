using System.Reflection;
using Xunit;

namespace MMP.AsyncProxy.Training.Tests;

/// <summary>
/// Pins which build the suite is running against on each runtime, so a green run
/// says what it proved. On net48 the training assembly must be the net35 binary,
/// the one a 2008 compiler could have produced. On net10 it is the netstandard2.0 build.
/// </summary>
public class BinariesTests
{
    [Fact]
    public void The_training_assembly_under_test_is_the_one_this_runtime_should_load()
    {
        var asm = typeof(Support.ThreadSampler).Assembly;
        var target = asm.GetCustomAttribute<System.Runtime.Versioning.TargetFrameworkAttribute>();
#if NET48
        // net35 assemblies carry no TargetFrameworkAttribute: the attribute arrived in .NET 4.0.
        Assert.Null(target);
        Assert.Equal("v2.0.50727", asm.ImageRuntimeVersion);
#else
        Assert.NotNull(target);
        Assert.StartsWith(".NETStandard,Version=v2.0", target!.FrameworkName);
#endif
    }
}
