using System.Collections.Generic;
using MMP.AsyncProxy.Training.Support;

namespace MMP.AsyncProxy.Training.Printer.Async
{
    /// <summary>
    /// The mistake, kept on purpose so a test can show it. The printer is opened on the owner
    /// thread, but the job's state machine is started wherever the caller happens to be, so there
    /// is no context to go back to. After the first wait the machine carries on on a pool thread
    /// and calls the driver from the wrong thread. The driver says so, loudly. A real driver
    /// might not.
    ///
    /// "Async everywhere" works only for code that can run on any thread. A thread-bound device
    /// is not that code.
    /// </summary>
    public sealed class NaiveDesk : IReceiptDesk
    {
        private readonly OwnerThread _owner = new OwnerThread("printer");
        private readonly ReceiptPrinter _printer = new ReceiptPrinter();

        public NaiveDesk()
        {
            _owner.Invoke(delegate { _printer.Open(); });
        }

        public string Version { get { return "async-naive"; } }
        public ReceiptPrinter Printer { get { return _printer; } }
        public int OwnerThreadId { get { return _owner.ThreadId; } }

        public PrintReport PrintJob(string[] receipts, int feedMs)
        {
            return AsyncProxy.Run<PrintReport>(delegate(Return<PrintReport> ret) { return Body(receipts, feedMs, ret); }).Result;
        }

        private IEnumerable<IFuture> Body(string[] receipts, int feedMs, Return<PrintReport> ret)
        {
            int printed = 0;
            int rejected = 0;
            string firstProblem = null;
            for (int i = 0; i < receipts.Length; i++)
            {
                try
                {
                    _printer.PrintLine(receipts[i]);   // the first line is called from the caller's thread, the rest from the pool
                    printed++;
                }
                catch (WrongThreadException ex)
                {
                    rejected++;
                    if (firstProblem == null) firstProblem = ex.Message;
                }
                yield return Futures.Delay(feedMs);
            }
            ret.Value = new PrintReport(printed, rejected, firstProblem);
        }

        public void Dispose() { _owner.Dispose(); }
    }
}
