using System;
using System.Collections.Generic;

namespace MMP.AsyncProxy.Sdk
{
    /// <summary>docs/sdk.md, "Fan out, fan in" and "First one wins".</summary>
    public static class FanOutFanIn
    {
        /// <summary>Stands in for a network fetch: answers after the given delay with the length of the url.</summary>
        public static IFuture<int> FetchAsync(string url, int delayMs)
        {
            return AsyncProxy.Run<int>(delegate(Return<int> ret) { return FetchBody(url, delayMs, ret); });
        }

        private static IEnumerable<IFuture> FetchBody(string url, int delayMs, Return<int> ret)
        {
            yield return Futures.Delay(delayMs);
            ret.Value = url.Length;
        }

        /// <summary>One await for the lot. If any failed, WhenAll faults with an AggregateFutureException holding every failure, in order.</summary>
        public static IFuture<int> TotalLengthAsync(string[] urls)
        {
            return AsyncProxy.Run<int>(delegate(Return<int> ret) { return TotalBody(urls, ret); });
        }

        private static IEnumerable<IFuture> TotalBody(string[] urls, Return<int> ret)
        {
            IFuture<int>[] all = new IFuture<int>[urls.Length];
            for (int i = 0; i < urls.Length; i++) all[i] = FetchAsync(urls[i], 10);
            yield return Futures.WhenAll(all);     // one await for the lot
            int total = 0;
            for (int i = 0; i < all.Length; i++) total += all[i].Result;
            ret.Value = total;
        }

        /// <summary>First to answer wins. The loser keeps running; cancel it with a token if you care.</summary>
        public static IFuture<string> FirstToAnswerAsync(IFuture<int> primary, IFuture<int> mirror)
        {
            return AsyncProxy.Run<string>(delegate(Return<string> ret) { return FirstBody(primary, mirror, ret); });
        }

        private static IEnumerable<IFuture> FirstBody(IFuture<int> primary, IFuture<int> mirror, Return<string> ret)
        {
            IFuture<IFuture> first = Futures.WhenAny(primary, mirror);
            yield return first;
            if (first.Result == primary) ret.Value = "primary";
            else ret.Value = "mirror";
        }
    }
}
