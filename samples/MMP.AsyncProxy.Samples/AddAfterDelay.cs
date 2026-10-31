using System;

namespace MMP.AsyncProxy.Samples
{
    /// <summary>
    /// Okay, here is the method we would write if we had C# 5:
    /// <code>
    /// async IFuture&lt;int&gt; AddAfterDelayAsync(int a, int b)
    /// {
    ///     await Futures.Delay(delayMs);
    ///     if (a &lt; 0) throw new ArgumentOutOfRangeException("a");
    ///     int sum = a + b;
    ///     await Futures.Delay(delayMs);
    ///     return sum * 2;
    /// }
    /// </code>
    /// We do not have C# 5. So below is what the compiler would have written
    /// for us, typed out by hand. The public method shrinks to a stub: make the
    /// machine, fill in the parameters, kick it once, hand back the future.
    /// </summary>
    public static class AddAfterDelay
    {
        public static IFuture<int> RunAsync(int a, int b, int delayMs)
        {
            AddAfterDelayMachine machine = new AddAfterDelayMachine();
            machine.A = a;
            machine.B = b;
            machine.DelayMs = delayMs;
            machine.State = -1;
            machine.Builder = AsyncMethodBuilder<int>.Create();
            machine.Builder.Start(ref machine);
            return machine.Builder.Future;
        }
    }

    /// <summary>
    /// The machine itself. Every local that has to survive an await moves out of
    /// the method and into a field, because the method's stack frame is gone the
    /// moment we return. State says where we are: -1 means running, -2 means
    /// finished, 0 and up means "parked at await number N".
    /// </summary>
    internal sealed class AddAfterDelayMachine : IAsyncStateMachine
    {
        public int State;
        public AsyncMethodBuilder<int> Builder;

        // The parameters. They used to live on the stack. Now they live here.
        public int A;
        public int B;
        public int DelayMs;

        // "sum" is computed before the second await and read after it, so it moves up too.
        private int _sum;

        // The awaiter we are parked on. When we wake up, we call GetResult on it.
        private IAwaiter _awaiter;

        public void MoveNext()
        {
            int result;
            try
            {
                IAwaiter awaiter;
                // First thing on every entry: where were we? Jump back to that spot.
                switch (State)
                {
                    case 0:
                        awaiter = _awaiter;
                        _awaiter = null;
                        State = -1;
                        goto Resume0;
                    case 1:
                        awaiter = _awaiter;
                        _awaiter = null;
                        State = -1;
                        goto Resume1;
                }

                // await Futures.Delay(delayMs);
                // Ask the awaiter if it is done. If yes, fall straight through to
                // Resume0 on this same thread. If no, remember where we are, hand
                // the builder our awaiter, and leave. Note the return: that is the
                // thread walking away.
                awaiter = Futures.Delay(DelayMs).GetAwaiter();
                if (!awaiter.IsCompleted)
                {
                    State = 0;
                    _awaiter = awaiter;
                    AddAfterDelayMachine self = this;
                    Builder.AwaitOnCompleted(ref awaiter, ref self);
                    return;
                }
            Resume0:
                // Back again, maybe on another thread. GetResult throws if the awaited thing failed.
                awaiter.GetResult();

                if (A < 0) throw new ArgumentOutOfRangeException("a");
                _sum = A + B;

                // await Futures.Delay(delayMs);
                // Same dance, second verse.
                awaiter = Futures.Delay(DelayMs).GetAwaiter();
                if (!awaiter.IsCompleted)
                {
                    State = 1;
                    _awaiter = awaiter;
                    AddAfterDelayMachine self = this;
                    Builder.AwaitOnCompleted(ref awaiter, ref self);
                    return;
                }
            Resume1:
                awaiter.GetResult();

                // return sum * 2;
                result = _sum * 2;
            }
            catch (Exception ex)
            {
                // Any throw, from any state, lands here. It does not escape MoveNext.
                // It becomes the future's fault, and the awaiting caller sees it there.
                State = -2;
                Builder.SetException(ex);
                return;
            }
            State = -2;
            Builder.SetResult(result);
        }

        public void SetStateMachine(IAsyncStateMachine stateMachine)
        {
        }
    }
}
