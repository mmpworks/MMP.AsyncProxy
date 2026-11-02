namespace MMP.AsyncProxy
{
    /// <summary>
    /// Which build of the library is loaded. A test suite that runs against more than
    /// one build reads this at run time. A property, never a const, so the value comes
    /// from the loaded assembly and is never inlined into the caller.
    /// </summary>
    public static class BuildInfo
    {
#if NETCF
        public static string Target { get { return "netcf35"; } }
        public static bool IsCompactFramework { get { return true; } }
#else
        public static string Target { get { return "desktop"; } }
        public static bool IsCompactFramework { get { return false; } }
#endif
    }
}
