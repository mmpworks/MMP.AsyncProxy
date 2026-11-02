using System;
using System.Threading;

namespace MMP.AsyncProxy
{
    /// <summary>
    /// A thread that wants continuations posted back to it. A display thread with a
    /// message loop implements Post by queueing the action to that loop. This is the
    /// one method of SynchronizationContext the library needs, and it exists because
    /// the Compact Framework has no SynchronizationContext at all.
    /// </summary>
    public interface IPostTarget
    {
        /// <summary>Run the action on this target's thread, later. Never inline.</summary>
        void Post(Action action);
    }

    /// <summary>
    /// The registry of post targets, one per thread that registered. An awaiter made
    /// with GetAwaiter() asks for the current thread's target at the await and, if one
    /// is registered, posts the continuation there instead of running it on whatever
    /// thread completed the future. On the desktop builds SynchronizationContext.Current
    /// is checked first and this registry second, so an application can use either.
    ///
    /// No ThreadStatic: the Compact Framework does not have it. Registrations are a
    /// small copy-on-write array keyed by managed thread id. A display thread
    /// registers once at startup, so the array has one or two entries and the lookup
    /// is a short scan.
    /// </summary>
    public static class PostTarget
    {
        private sealed class Entry
        {
            public readonly int ThreadId;
            public readonly IPostTarget Target;
            public Entry(int threadId, IPostTarget target) { ThreadId = threadId; Target = target; }
        }

        private static Entry[] _entries = new Entry[0];

        /// <summary>Register a target for the calling thread. A second call on the same thread replaces the first.</summary>
        public static void SetForCurrentThread(IPostTarget target)
        {
            int id = Thread.CurrentThread.ManagedThreadId;
            while (true)
            {
                Entry[] before = _entries;
                Entry[] after = Without(before, id);
                if (target != null)
                {
                    Entry[] grown = new Entry[after.Length + 1];
                    Array.Copy(after, grown, after.Length);
                    grown[after.Length] = new Entry(id, target);
                    after = grown;
                }
                if (Interlocked.CompareExchange(ref _entries, after, before) == before) return;
            }
        }

        /// <summary>The target registered by the calling thread, or null.</summary>
        public static IPostTarget Current
        {
            get
            {
                Entry[] entries = _entries;
                if (entries.Length == 0) return null;
                int id = Thread.CurrentThread.ManagedThreadId;
                for (int i = 0; i < entries.Length; i++)
                {
                    if (entries[i].ThreadId == id) return entries[i].Target;
                }
                return null;
            }
        }

        private static Entry[] Without(Entry[] entries, int id)
        {
            int count = 0;
            for (int i = 0; i < entries.Length; i++) if (entries[i].ThreadId != id) count++;
            if (count == entries.Length) return entries;
            Entry[] result = new Entry[count];
            int n = 0;
            for (int i = 0; i < entries.Length; i++) if (entries[i].ThreadId != id) result[n++] = entries[i];
            return result;
        }
    }
}
