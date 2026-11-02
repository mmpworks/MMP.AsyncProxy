using System;
using System.Threading;

namespace MMP.AsyncProxy.Training.FanOut
{
    /// <summary>
    /// The 2008 fan-out: a thread per letter. Each thread calls the blocking door, writes
    /// its reply into its slot, and counts down. The last one to finish sets the event the
    /// caller is parked on. N letters is N threads, each asleep inside Ask for the whole
    /// delay, each with a stack reserved for it.
    /// </summary>
    public sealed class ThreadPerLetterCourier : ICourier
    {
        public string Version { get { return "threaded"; } }

        public Reply[] SendAll(string[] addresses, PostOffice office)
        {
            Reply[] replies = new Reply[addresses.Length];
            if (addresses.Length == 0) return replies;

            int remaining = addresses.Length;
            using (ManualResetEvent allIn = new ManualResetEvent(false))
            {
                for (int i = 0; i < addresses.Length; i++)
                {
                    int slot = i;
                    string address = addresses[i];
                    Thread t = new Thread(delegate()
                    {
                        try { replies[slot] = new Reply(address, office.Ask(address), null); }
                        catch (Exception ex) { replies[slot] = new Reply(address, null, ex); }
                        finally
                        {
                            // The countdown. Whoever decrements to zero wakes the caller.
                            if (Interlocked.Decrement(ref remaining) == 0) allIn.Set();
                        }
                    });
                    t.IsBackground = true;
                    t.Name = "letter:" + address;
                    t.Start();
                }
                allIn.WaitOne();                       // the caller's thread, parked until the last reply
            }
            return replies;
        }

        public void Dispose() { }
    }
}
