using System;
using System.IO;
using System.Net;

namespace MMP.AsyncProxy.Sdk
{
    /// <summary>docs/sdk.md, "Wrap a callback API". Begin/End pairs and events become futures.</summary>
    public static class WrapACallbackApi
    {
        /// <summary>The read goes to the OS. Open the FileStream with FileOptions.Asynchronous or a pool thread does it.</summary>
        public static IFuture<int> ReadAsync(Stream stream, byte[] buffer)
        {
            return Futures.FromAsync<int>(
                delegate(AsyncCallback cb, object state) { return stream.BeginRead(buffer, 0, buffer.Length, cb, state); },
                stream.EndRead);
        }

        /// <summary>An event needs a promise by hand: subscribe, complete in the handler, unsubscribe.</summary>
        public static IFuture<DownloadDataCompletedEventArgs> DownloadAsync(WebClient client, Uri uri)
        {
            Promise<DownloadDataCompletedEventArgs> promise = new Promise<DownloadDataCompletedEventArgs>();
            DownloadDataCompletedEventHandler handler = null;
            handler = delegate(object s, DownloadDataCompletedEventArgs e)
            {
                client.DownloadDataCompleted -= handler;
                if (e.Error != null) promise.TrySetException(e.Error);
                else promise.TrySetResult(e);
            };
            client.DownloadDataCompleted += handler;
            client.DownloadDataAsync(uri);
            return promise.Future;
        }
    }
}
