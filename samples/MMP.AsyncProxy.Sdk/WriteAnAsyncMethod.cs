using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace MMP.AsyncProxy.Sdk
{
    /// <summary>docs/sdk.md, "Write an async method". The iterator is the method; yield return is await.</summary>
    public static class WriteAnAsyncMethod
    {
        public static IFuture<string> FetchAndTrimAsync(Stream stream)
        {
            return AsyncProxy.Run<string>(delegate(Return<string> ret) { return Body(stream, ret); });
        }

        private static IEnumerable<IFuture> Body(Stream stream, Return<string> ret)
        {
            byte[] buffer = new byte[4096];
            IFuture<int> read = WrapACallbackApi.ReadAsync(stream, buffer);
            yield return read;                                   // await
            string text = Encoding.UTF8.GetString(buffer, 0, read.Result);
            yield return Futures.Delay(100);                     // await
            ret.Value = text.Trim();                             // return
        }
    }
}
