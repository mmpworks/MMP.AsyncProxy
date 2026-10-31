using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Threading;
using Xunit;

namespace MMP.AsyncProxy.Tests
{
    /// <summary>
    /// The OS-driven path. A FileStream opened with FileOptions.Asynchronous hands
    /// the read to the kernel. Completion comes back through an I/O completion port.
    /// No thread of ours waits for the disk.
    /// </summary>
    public class FromAsyncTests
    {
        [Fact]
        public void FromAsync_reads_a_file_through_the_OS_completion_path()
        {
            var path = Path.GetTempFileName();
            try
            {
                var payload = Encoding.ASCII.GetBytes("the bytes arrive when the OS says so");
                File.WriteAllBytes(path, payload);

                using (var stream = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.Read, 4096, FileOptions.Asynchronous))
                {
                    var buffer = new byte[payload.Length];
                    var future = Futures.FromAsync<int>(
                        (cb, state) => stream.BeginRead(buffer, 0, buffer.Length, cb, state),
                        stream.EndRead);

                    future.Wait();
                    Assert.Equal(payload.Length, future.Result);
                    Assert.Equal(payload, buffer);
                }
            }
            finally
            {
                File.Delete(path);
            }
        }

        [Fact]
        public void FromAsync_inside_an_iterator_resumes_after_the_read()
        {
            var path = Path.GetTempFileName();
            try
            {
                File.WriteAllText(path, "hello, iterator");
                var future = AsyncProxy.Run<string>(ret => ReadAll(path, ret));
                Assert.Equal("hello, iterator", future.Result);
            }
            finally
            {
                File.Delete(path);
            }
        }

        private static IEnumerable<IFuture> ReadAll(string path, Return<string> ret)
        {
            using (var stream = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.Read, 4096, FileOptions.Asynchronous))
            {
                var buffer = new byte[(int)stream.Length];
                var read = Futures.FromAsync<int>(
                    (cb, state) => stream.BeginRead(buffer, 0, buffer.Length, cb, state),
                    stream.EndRead);
                yield return read;
                ret.Value = Encoding.UTF8.GetString(buffer, 0, read.Result);
            }
        }

        [Fact]
        public void FromAsync_turns_a_throwing_Begin_into_a_fault()
        {
            var future = Futures.FromAsync<int>(
                (cb, state) => throw new IOException("disk on fire"),
                ar => 0);
            Assert.True(future.IsFaulted);
            Assert.IsType<IOException>(future.Exception);
        }
    }
}
