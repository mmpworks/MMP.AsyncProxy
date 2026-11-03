using System;
using System.Collections.Generic;
using System.Threading;

namespace MMP.AsyncProxy
{
    /// <summary>
    /// One timer for every Futures.Delay in the process. Entries are kept in due
    /// order; the timer is armed for the earliest one; when it fires, every entry
    /// that is due is taken off the list and its promise is completed on a pool
    /// thread of its own, the way the modern runtime's timer queue runs each
    /// callback. A cancelled delay is removed from the list and never fires.
    ///
    /// Due times are Environment.TickCount values, which wrap every 24.9 days, so
    /// every comparison is a subtraction in unchecked arithmetic and never a
    /// less-than on the raw numbers. A delay longer than about 24 days is refused.
    /// Everything here exists on the Compact Framework: a Timer, a lock, a list.
    /// </summary>
    internal static class DelayWheel
    {
        internal sealed class Entry
        {
            internal int Due;
            internal Promise Promise;
            internal IDisposable Registration;
            internal bool Done;
        }

        private const int MaxDelayMs = 24 * 24 * 60 * 60 * 1000;
        private static readonly object Gate = new object();
        private static readonly List<Entry> Entries = new List<Entry>();
        private static readonly WaitCallback CompleteOne = Complete;
        private static Timer _timer;

        internal static Entry Add(int milliseconds, Promise promise)
        {
            if (milliseconds > MaxDelayMs) throw new ArgumentOutOfRangeException("milliseconds", "A delay longer than 24 days cannot be kept on a 32-bit tick count.");
            Entry entry = new Entry();
            entry.Promise = promise;
            lock (Gate)
            {
                entry.Due = unchecked(Environment.TickCount + milliseconds);
                int index = Entries.Count;
                while (index > 0 && Before(entry.Due, Entries[index - 1].Due)) index--;
                Entries.Insert(index, entry);
                if (index == 0) Arm();
            }
            return entry;
        }

        internal static void Remove(Entry entry)
        {
            lock (Gate)
            {
                if (entry.Done) return;
                entry.Done = true;
                int index = Entries.IndexOf(entry);
                if (index < 0) return;
                Entries.RemoveAt(index);
                if (index == 0) Arm();
            }
        }

        /// <summary>True when a is due no later than b, with the tick count allowed to wrap.</summary>
        private static bool Before(int a, int b)
        {
            return unchecked(a - b) <= 0;
        }

        /// <summary>Under the lock: point the one timer at the earliest entry, or park it when there is none.</summary>
        private static void Arm()
        {
            if (_timer == null) _timer = CreateTimer();
            if (Entries.Count == 0)
            {
                _timer.Change(Timeout.Infinite, Timeout.Infinite);
                return;
            }
            int wait = unchecked(Entries[0].Due - Environment.TickCount);
            _timer.Change(wait < 0 ? 0 : wait, Timeout.Infinite);
        }

        /// <summary>
        /// The one timer is made by whichever thread first asks for a delay. A Timer captures that
        /// thread's ExecutionContext and every callback would run under it, so a value one caller
        /// set would leak into every other caller's continuation. Making it with flow suppressed
        /// gives the callbacks no context of their own; the builder restores each method's own.
        /// The Compact Framework has no ExecutionContext, so there is nothing to suppress there.
        /// </summary>
        private static Timer CreateTimer()
        {
#if NETCF
            return new Timer(Fire, null, Timeout.Infinite, Timeout.Infinite);
#else
            if (ExecutionContext.IsFlowSuppressed()) return new Timer(Fire, null, Timeout.Infinite, Timeout.Infinite);
            using (ExecutionContext.SuppressFlow())
            {
                return new Timer(Fire, null, Timeout.Infinite, Timeout.Infinite);
            }
#endif
        }

        private static void Fire(object state)
        {
            List<Entry> due = null;
            lock (Gate)
            {
                int now = Environment.TickCount;
                while (Entries.Count > 0 && Before(Entries[0].Due, now))
                {
                    Entry entry = Entries[0];
                    Entries.RemoveAt(0);
                    entry.Done = true;
                    if (due == null) due = new List<Entry>();
                    due.Add(entry);
                }
                Arm();
            }
            if (due == null) return;
            // Each completion is its own pool work item, so N delays due together run
            // their continuations in parallel and none of them runs under the gate.
            // Unsafe here means "do not flow the timer thread's context", which is what we want:
            // the completion carries no caller's context, and each waiting method's builder
            // restores its own. The Compact Framework has only the flowing overload.
            for (int i = 0; i < due.Count; i++)
            {
#if NETCF
                ThreadPool.QueueUserWorkItem(CompleteOne, due[i]);
#else
                ThreadPool.UnsafeQueueUserWorkItem(CompleteOne, due[i]);
#endif
            }
        }

        private static void Complete(object state)
        {
            Entry entry = (Entry)state;
            IDisposable registration = entry.Registration;
            if (registration != null) registration.Dispose();
            entry.Promise.TrySetResult();
        }
    }
}
