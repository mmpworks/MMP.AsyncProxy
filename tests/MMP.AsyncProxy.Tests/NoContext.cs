using System;
using System.Threading;

namespace MMP.AsyncProxy.Tests
{
    /// <summary>
    /// xunit installs a SynchronizationContext on the test thread. An awaiter
    /// built by GetAwaiter posts to it, so a continuation runs later instead of
    /// inline. Tests that assert inline behaviour run under this helper, which
    /// is what a console app or a pool thread sees.
    /// </summary>
    internal static class NoContext
    {
        public static void Run(Action test)
        {
            var previous = SynchronizationContext.Current;
            SynchronizationContext.SetSynchronizationContext(null);
            try { test(); }
            finally { SynchronizationContext.SetSynchronizationContext(previous); }
        }
    }
}
