using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Threading;

namespace MMP.AsyncProxy.Training.Crunch
{
    /// <summary>One fuel sale from the day's log.</summary>
    public sealed class SaleRecord
    {
        private readonly int _id;
        private readonly int _cents;
        private readonly int _grade;

        public SaleRecord(int id, int cents, int grade)
        {
            _id = id;
            _cents = cents;
            _grade = grade;
        }

        public int Id { get { return _id; } }
        public int Cents { get { return _cents; } }

        /// <summary>0, 1 or 2: regular, plus, premium.</summary>
        public int Grade { get { return _grade; } }
    }

    /// <summary>
    /// The end-of-day answer: how many sales, how much money in all and per grade, and one
    /// checksum that covers every record's seal. The checksum is combined with XOR, so it does
    /// not depend on the order the records were sealed in. That is what lets four threads and
    /// one thread agree. ThreadsUsed and RanOnPoolThreads say where the work happened, which is
    /// the one thing the versions are allowed to differ on.
    /// </summary>
    public sealed class Settlement
    {
        private readonly int _count;
        private readonly long _totalCents;
        private readonly long[] _centsByGrade;
        private readonly ulong _checksum;
        private readonly int _threadsUsed;
        private readonly bool _ranOnPoolThreads;

        public Settlement(int count, long totalCents, long[] centsByGrade, ulong checksum, int threadsUsed, bool ranOnPoolThreads)
        {
            _count = count;
            _totalCents = totalCents;
            _centsByGrade = centsByGrade;
            _checksum = checksum;
            _threadsUsed = threadsUsed;
            _ranOnPoolThreads = ranOnPoolThreads;
        }

        public int Count { get { return _count; } }
        public long TotalCents { get { return _totalCents; } }
        public long[] CentsByGrade { get { return _centsByGrade; } }
        public ulong Checksum { get { return _checksum; } }

        /// <summary>How many different threads sealed records.</summary>
        public int ThreadsUsed { get { return _threadsUsed; } }

        /// <summary>True if any record was sealed on a thread-pool thread (a borrowed worker) instead of a thread of the version's own.</summary>
        public bool RanOnPoolThreads { get { return _ranOnPoolThreads; } }

        /// <summary>Same money and same checksum. Says nothing about which threads did the work.</summary>
        public bool SameAnswerAs(Settlement other)
        {
            if (_count != other._count || _totalCents != other._totalCents || _checksum != other._checksum) return false;
            for (int g = 0; g < _centsByGrade.Length; g++)
            {
                if (_centsByGrade[g] != other._centsByGrade[g]) return false;
            }
            return true;
        }
    }

    /// <summary>
    /// A running count for some of the records. Each worker keeps its own, so no two threads
    /// ever write to the same one; the totals are merged at the end.
    /// </summary>
    public sealed class Tally
    {
        private int _count;
        private long _totalCents;
        private readonly long[] _centsByGrade = new long[3];
        private ulong _checksum;
        private readonly Dictionary<int, bool> _threads = new Dictionary<int, bool>();
        private bool _ranOnPool;

        public void Add(SaleRecord sale, ulong seal)
        {
            _count++;
            _totalCents += sale.Cents;
            _centsByGrade[sale.Grade] += sale.Cents;
            _checksum ^= seal;
            Thread me = Thread.CurrentThread;
            _threads[me.ManagedThreadId] = true;
            if (me.IsThreadPoolThread) _ranOnPool = true;
        }

        public void Merge(Tally other)
        {
            _count += other._count;
            _totalCents += other._totalCents;
            for (int g = 0; g < _centsByGrade.Length; g++) _centsByGrade[g] += other._centsByGrade[g];
            _checksum ^= other._checksum;
            foreach (int id in other._threads.Keys) _threads[id] = true;
            if (other._ranOnPool) _ranOnPool = true;
        }

        public Settlement ToSettlement()
        {
            return new Settlement(_count, _totalCents, (long[])_centsByGrade.Clone(), _checksum, _threads.Count, _ranOnPool);
        }
    }

    /// <summary>
    /// The day's log and the work done on each record. Sealing is meant to be heavy: it hashes
    /// a record over and over (SHA-256, the way a signature check chews on its input). That is
    /// pure CPU. No disk, no network, nothing to wait for. A core is busy, or it is not.
    /// </summary>
    public static class Ledger
    {
        /// <summary>A day of sales, the same every time: record i is always the same sale.</summary>
        public static SaleRecord[] Day(int count)
        {
            SaleRecord[] day = new SaleRecord[count];
            for (int i = 0; i < count; i++) day[i] = new SaleRecord(i, 500 + (i * 37) % 9500, i % 3);
            return day;
        }

        /// <summary>The seal on one record: start from its id and hash the result, rounds times.</summary>
        public static ulong Seal(SHA256 sha, SaleRecord sale, int rounds)
        {
            byte[] h = new byte[32];
            BitConverter.GetBytes(sale.Id).CopyTo(h, 0);
            BitConverter.GetBytes(sale.Cents).CopyTo(h, 4);
            for (int r = 0; r < rounds; r++) h = sha.ComputeHash(h);
            return BitConverter.ToUInt64(h, 0);
        }

        /// <summary>Seals records from..to-1 and counts them. Every version's real work is this loop.</summary>
        public static Tally SealRange(SaleRecord[] sales, int from, int to, int stride, int rounds)
        {
            Tally tally = new Tally();
            using (SHA256 sha = SHA256.Create())
            {
                for (int i = from; i < to; i += stride) tally.Add(sales[i], Seal(sha, sales[i], rounds));
            }
            return tally;
        }

        /// <summary>The reference answer: one plain loop on the calling thread. Every version has to match it.</summary>
        public static Settlement InOneLoop(SaleRecord[] sales, int rounds)
        {
            return SealRange(sales, 0, sales.Length, 1, rounds).ToSettlement();
        }
    }

    /// <summary>
    /// Close the day: seal every sale and add up the money. The work is the same in every version
    /// and it is all CPU. The versions differ in who does it and what they borrow to do it:
    /// threads of their own, or the thread pool's shared workers.
    /// </summary>
    public interface ISettler : IDisposable
    {
        /// <summary>"threaded", "async-loop", or "async-pool".</summary>
        string Version { get; }

        /// <summary>Blocks the caller until the whole day is settled.</summary>
        Settlement Settle(SaleRecord[] sales, int rounds);
    }
}
