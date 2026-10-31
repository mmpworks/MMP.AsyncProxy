using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace MMP.AsyncProxy
{
    /// <summary>
    /// Holds every fault from a WhenAll. .NET 3.5 has no AggregateException.
    /// </summary>
    public class AggregateFutureException : Exception
    {
        private readonly ReadOnlyCollection<Exception> _inner;

        public AggregateFutureException(IList<Exception> inner)
            : base(BuildMessage(inner), inner.Count > 0 ? inner[0] : null)
        {
            _inner = new ReadOnlyCollection<Exception>(inner);
        }

        public ReadOnlyCollection<Exception> InnerExceptions { get { return _inner; } }

        private static string BuildMessage(IList<Exception> inner)
        {
            return inner.Count + " future(s) faulted.";
        }
    }
}
