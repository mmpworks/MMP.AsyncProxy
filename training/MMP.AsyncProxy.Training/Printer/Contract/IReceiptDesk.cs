using System;
using System.Collections.Generic;
using System.Threading;

namespace MMP.AsyncProxy.Training.Printer
{
    /// <summary>The driver was called from a thread that is not the one that opened it.</summary>
    public sealed class WrongThreadException : InvalidOperationException
    {
        public WrongThreadException(string message) : base(message) { }
    }

    /// <summary>
    /// Stands in for a vendor's printer driver. Real ones are like this more often than
    /// anyone likes: a single-threaded COM object, a USB SDK, a graphics context. The thread
    /// that opened the driver is the only thread allowed to call it. A call from any other
    /// thread throws, or on a real driver, corrupts something quietly.
    /// </summary>
    public sealed class ReceiptPrinter
    {
        private readonly object _gate = new object();
        private readonly List<string> _lines = new List<string>();
        private readonly Dictionary<int, bool> _callers = new Dictionary<int, bool>();
        private int _owner = -1;
        private int _rejected;

        public void Open()
        {
            lock (_gate) _owner = Thread.CurrentThread.ManagedThreadId;
        }

        public void PrintLine(string line)
        {
            int me = Thread.CurrentThread.ManagedThreadId;
            lock (_gate)
            {
                _callers[me] = true;
                if (me != _owner)
                {
                    _rejected++;
                    throw new WrongThreadException("The printer was opened on thread " + _owner + " and called from thread " + me + ".");
                }
                _lines.Add(line);
            }
        }

        /// <summary>Every line that was accepted, in the order the driver took it.</summary>
        public string[] Lines { get { lock (_gate) return _lines.ToArray(); } }

        /// <summary>How many calls came from a thread that was not the owner.</summary>
        public int Rejected { get { lock (_gate) return _rejected; } }

        /// <summary>How many different threads called the driver, good or bad.</summary>
        public int CallerThreads { get { lock (_gate) return _callers.Count; } }
    }

    /// <summary>How a print job went: lines the driver took, calls it refused, and the first complaint.</summary>
    public sealed class PrintReport
    {
        private readonly int _printed;
        private readonly int _rejected;
        private readonly string _firstProblem;

        public PrintReport(int printed, int rejected, string firstProblem)
        {
            _printed = printed;
            _rejected = rejected;
            _firstProblem = firstProblem;
        }

        public int Printed { get { return _printed; } }
        public int Rejected { get { return _rejected; } }
        public string FirstProblem { get { return _firstProblem; } }
    }

    /// <summary>
    /// A receipt desk in front of a thread-bound printer. PrintJob prints the receipts in order,
    /// waiting feedMs after each one for the paper to advance, and returns a report. It can be
    /// called from any thread, several at a time. The rule the driver enforces, and every
    /// version has to keep: only the thread that opened the printer ever calls it.
    /// </summary>
    public interface IReceiptDesk : IDisposable
    {
        /// <summary>"threaded", "async-postback", or "async-naive".</summary>
        string Version { get; }

        /// <summary>The driver, so a test can see which threads called it and in what order lines landed.</summary>
        ReceiptPrinter Printer { get; }

        /// <summary>The thread that opened the driver.</summary>
        int OwnerThreadId { get; }

        PrintReport PrintJob(string[] receipts, int feedMs);
    }
}
