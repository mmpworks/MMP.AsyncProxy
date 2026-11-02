using System;
using System.Threading;
using MMP.AsyncProxy.Training.Support;

namespace MMP.AsyncProxy.Training.Printer.Threaded
{
    /// <summary>
    /// The plain answer: one thread owns the printer, and each job runs as one block on that
    /// thread. The paper-feed wait is a Thread.Sleep on the owner thread, so while one job feeds
    /// paper the owner is parked and every other job stands in line. Simple, correct, and the
    /// way almost every thread-bound device has been driven since there were threads.
    /// </summary>
    public sealed class OwnerThreadDesk : IReceiptDesk
    {
        private readonly OwnerThread _owner = new OwnerThread("printer");
        private readonly ReceiptPrinter _printer = new ReceiptPrinter();

        public OwnerThreadDesk()
        {
            _owner.Invoke(delegate { _printer.Open(); });
        }

        public string Version { get { return "threaded"; } }
        public ReceiptPrinter Printer { get { return _printer; } }
        public int OwnerThreadId { get { return _owner.ThreadId; } }

        public PrintReport PrintJob(string[] receipts, int feedMs)
        {
            int printed = 0;
            _owner.Invoke(delegate
            {
                for (int i = 0; i < receipts.Length; i++)
                {
                    _printer.PrintLine(receipts[i]);
                    printed++;
                    Thread.Sleep(feedMs);              // the owner thread sits here. Nobody else can use the printer meanwhile.
                }
            });
            return new PrintReport(printed, 0, null);
        }

        public void Dispose() { _owner.Dispose(); }
    }
}
