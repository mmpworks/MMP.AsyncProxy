using System;

namespace MMP.AsyncProxy.Samples
{
    /// <summary>
    /// The method a C# 5 programmer would write:
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
    /// Below is what the compiler emits for it, written by hand in C# 3.
    /// The method body becomes a stub that builds the machine and starts it.
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
    /// The state machine. Parameters and locals that live across an await are
    /// hoisted to fields. State -1 is "running", -2 is "done", 0 and up name
    /// the await the machine is parked at.
    /// </summary>
    internal sealed class AddAfterDelayMachine : IAsyncStateMachine
    {
        public int State;
        public AsyncMethodBuilder<int> Builder;

        // Parameters, hoisted.
        public int A;
        public int B;
        public int DelayMs;

        // The local that lives across the second await, hoisted.
        private int _sum;

        // The awaiter the machine is parked on, so Resume can call GetResult on it.
        private IAwaiter _awaiter;

        public void MoveNext()
        {
            int result;
            try
            {
                IAwaiter awaiter;
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
                awaiter.GetResult();

                if (A < 0) throw new ArgumentOutOfRangeException("a");
                _sum = A + B;

                // await Futures.Delay(delayMs);
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
