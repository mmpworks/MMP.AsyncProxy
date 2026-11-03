using System.Collections.Generic;
using MMP.AsyncProxy.Training.Support;

namespace MMP.AsyncProxy.Training.Printer.Async
{
    /// <summary>
    /// The async answer that works. The job is a state machine started ON the owner thread, so the
    /// awaiter captures the owner thread's SynchronizationContext at each wait. While the paper
    /// feeds, the machine is a bookmark and the owner thread is free to serve other jobs. When the
    /// timer fires, the library posts the rest of the machine back onto the owner thread. Every
    /// call to the driver still comes from the one thread that opened it.
    ///
    /// Notice what did not go away: the owner thread. Async did not remove the thread the device
    /// insists on. It only stopped the waiting from holding that thread hostage.
    /// </summary>
    public sealed class PostBackDesk : IReceiptDesk
    {
        private readonly OwnerThread _owner = new OwnerThread("printer");
        private readonly ReceiptPrinter _printer = new ReceiptPrinter();

        public PostBackDesk()
        {
            _owner.Invoke(delegate { _printer.Open(); });
        }

        public string Version { get { return "async-postback"; } }
        public ReceiptPrinter Printer { get { return _printer; } }
        public int OwnerThreadId { get { return _owner.ThreadId; } }

        public PrintReport PrintJob(string[] receipts, int feedMs)
        {
            IFuture<PrintReport> job = null;
            // Start the machine on the owner thread, so "where I was" is the owner thread.
            _owner.Invoke(delegate
            {
                job = AsyncProxy.Run<PrintReport>(delegate(Return<PrintReport> ret) { return Body(receipts, feedMs, ret); });
            });
            return job.Result;                         // this blocks the CALLER, not the owner thread
        }

        private IEnumerable<IFuture> Body(string[] receipts, int feedMs, Return<PrintReport> ret)
        {
            int printed = 0;
            for (int i = 0; i < receipts.Length; i++)
            {
                _printer.PrintLine(receipts[i]);       // on the owner thread, every time
                printed++;
                yield return Futures.Delay(feedMs);    // the owner thread goes back to its line; the timer waits
            }
            ret.Value = new PrintReport(printed, 0, null);
        }

        public void Dispose() { _owner.Dispose(); }
    }
}
