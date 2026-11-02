using Xunit;

namespace MMP.AsyncProxy.Tests
{
    /// <summary>
    /// A fact that only holds on the desktop build of the library. The same suite runs
    /// against the Compact Framework build (tools/netcf-build.ps1), which has no
    /// ExecutionContext, no SynchronizationContext, and no Exception.Data, so the
    /// tests that prove those three are skipped there with the reason on the row.
    /// </summary>
    public sealed class DesktopFactAttribute : FactAttribute
    {
        public DesktopFactAttribute(string needs)
        {
            if (BuildInfo.IsCompactFramework)
                Skip = $"desktop only: the Compact Framework build has no {needs}";
        }
    }

    /// <summary>The mirror: a fact that only holds on the Compact Framework build.</summary>
    public sealed class CompactFrameworkFactAttribute : FactAttribute
    {
        public CompactFrameworkFactAttribute()
        {
            if (!BuildInfo.IsCompactFramework)
                Skip = "Compact Framework build only";
        }
    }
}
