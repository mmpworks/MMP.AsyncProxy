using System;

namespace MMP.AsyncProxy.Training.FanOut
{
    /// <summary>
    /// One reply per letter sent. Either the text came back, or the error that stood in
    /// for it. The courier never throws for one bad address; the caller reads each reply.
    /// </summary>
    public sealed class Reply
    {
        private readonly string _address;
        private readonly string _text;
        private readonly Exception _error;

        public Reply(string address, string text, Exception error)
        {
            _address = address;
            _text = text;
            _error = error;
        }

        public string Address { get { return _address; } }
        public string Text { get { return _text; } }
        public Exception Error { get { return _error; } }
        public bool Ok { get { return _error == null; } }
    }

    /// <summary>
    /// Sends one letter to every address at the same moment and waits for every reply.
    /// The caller blocks once, at the top. What the courier holds while the replies are
    /// on the way is the difference between the versions: a thread per letter, or none.
    /// </summary>
    public interface ICourier : IDisposable
    {
        /// <summary>"threaded", "asyncproxy", or "modern".</summary>
        string Version { get; }

        /// <summary>Replies in the order of the addresses, one each, after every one has come back.</summary>
        Reply[] SendAll(string[] addresses, PostOffice office);
    }
}
