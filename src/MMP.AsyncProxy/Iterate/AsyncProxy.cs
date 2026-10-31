using System;
using System.Collections.Generic;

namespace MMP.AsyncProxy
{
    /// <summary>
    /// Entry point for iterator-driven async methods.
    /// Write a method that returns IEnumerable&lt;IFuture&gt; and yield each future
    /// where you would have written await. Pass it here.
    /// </summary>
    public static class AsyncProxy
    {
        /// <summary>Runs an iterator with no return value.</summary>
        public static IFuture Run(IEnumerable<IFuture> steps)
        {
            if (steps == null) throw new ArgumentNullException("steps");
            IteratorStateMachine<VoidResult> machine =
                new IteratorStateMachine<VoidResult>(steps.GetEnumerator(), new Return<VoidResult>());
            machine.Start();
            return machine.Future;
        }

        /// <summary>Runs an iterator that sets a value on its Return slot before it ends.</summary>
        public static IFuture<T> Run<T>(Func<Return<T>, IEnumerable<IFuture>> body)
        {
            if (body == null) throw new ArgumentNullException("body");
            Return<T> ret = new Return<T>();
            IEnumerable<IFuture> steps = body(ret);
            if (steps == null) throw new InvalidOperationException("The body returned a null sequence.");
            IteratorStateMachine<T> machine = new IteratorStateMachine<T>(steps.GetEnumerator(), ret);
            machine.Start();
            return machine.Future;
        }
    }
}
