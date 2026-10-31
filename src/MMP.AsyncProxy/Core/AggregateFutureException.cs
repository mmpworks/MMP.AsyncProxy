using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace MMP.AsyncProxy
{
    /// <summary>
    /// WhenAll can fail more than once. This holds every failure, in input order.
    /// .NET 4.0 added AggregateException for the same job. .NET 3.5 has nothing, so here it is.
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
