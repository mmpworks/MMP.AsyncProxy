using System;
using System.Collections.Generic;
using System.Threading;

namespace MMP.AsyncProxy.Training.Deadline
{
    /// <summary>How a call ended: an answer, a last timeout after every attempt, or the caller giving up.</summary>
    public enum CallOutcome { Answered, GaveUp, Cancelled }

    public sealed class CallResult
    {
        private readonly CallOutcome _outcome;
        private readonly string _reply;
        private readonly int _attempts;

        public CallResult(CallOutcome outcome, string reply, int attempts)
        {
            _outcome = outcome;
            _reply = reply;
            _attempts = attempts;
        }

        public CallOutcome Outcome { get { return _outcome; } }
        public string Reply { get { return _reply; } }
        public int Attempts { get { return _attempts; } }
    }

    /// <summary>
    /// The caller's hand on the cord. Fire it from any thread and every caller version
    /// stops waiting. The threaded caller watches an event; the AsyncProxy caller turns
    /// it into a CancelToken; the modern caller into a CancellationToken.
    /// </summary>
    public sealed class GiveUp
    {
        private readonly object _gate = new object();
        private Action _fired;
        private bool _requested;

        public bool Requested { get { lock (_gate) return _requested; } }

        public void Fire()
        {
            Action fired;
            lock (_gate)
            {
                if (_requested) return;
                _requested = true;
                fired = _fired;
            }
            if (fired != null) fired();
        }

        /// <summary>Runs the callback at Fire, or at once if already fired.</summary>
        public void OnFired(Action callback)
        {
            lock (_gate)
            {
                if (!_requested) { _fired = (Action)Delegate.Combine(_fired, callback); return; }
            }
            callback();
        }
    }

    /// <summary>
    /// A request with a time limit, tried up to maxAttempts times, and a cord the caller
    /// can pull. The three rules: an attempt that runs past the limit is abandoned and
    /// the next one starts; a late answer to an abandoned attempt lands nowhere and
    /// breaks nothing; a pull on the cord ends the call at once, mid-attempt. What an
    /// abandoned attempt leaves behind is the difference between the versions.
    /// </summary>
    public interface IDeadlineCaller : IDisposable
    {
        /// <summary>"threaded", "asyncproxy", or "modern".</summary>
        string Version { get; }

        CallResult Call(FlakyService service, int timeoutMs, int maxAttempts, GiveUp giveUp);
    }

    /// <summary>
    /// The service that sometimes answers late or never. Each attempt has a scripted
    /// delay; a negative delay means that attempt never answers. Answers counts every
    /// reply the service produced, whether or not anyone was still waiting for it.
    /// Two doors again: Ask blocks the calling thread until the answer (or forever);
    /// AskAsync returns a future a timer completes (or never).
    /// </summary>
    public sealed class FlakyService
    {
        private readonly int[] _delays;
        private readonly ManualResetEvent _never = new ManualResetEvent(false);
        private int _answers;

        public FlakyService(params int[] delaysMsPerAttempt)
        {
            _delays = delaysMsPerAttempt;
        }

        public int Answers { get { return Interlocked.CompareExchange(ref _answers, 0, 0); } }

        public int DelayFor(int attempt)
        {
            return attempt < _delays.Length ? _delays[attempt] : _delays[_delays.Length - 1];
        }

        public string Answer(int attempt)
        {
            Interlocked.Increment(ref _answers);
            return "ok on attempt " + (attempt + 1);
        }

        /// <summary>The blocking door. A never-answering attempt parks the thread for good.</summary>
        public string Ask(int attempt)
        {
            int delay = DelayFor(attempt);
            if (delay < 0) { _never.WaitOne(); return null; }       // nobody sets this: the thread is gone
            Thread.Sleep(delay);
            return Answer(attempt);
        }

        /// <summary>The future door. A never-answering attempt is a promise nobody completes: one small object.</summary>
        public IFuture<string> AskAsync(int attempt)
        {
            int delay = DelayFor(attempt);
            if (delay < 0) return new Promise<string>(PromiseOptions.RunContinuationsAsynchronously).Future;
            return AsyncProxy.Run<string>(delegate(Return<string> ret) { return AskBody(attempt, delay, ret); });
        }

        private IEnumerable<IFuture> AskBody(int attempt, int delay, Return<string> ret)
        {
            yield return Futures.Delay(delay);
            ret.Value = Answer(attempt);
        }
    }
}
