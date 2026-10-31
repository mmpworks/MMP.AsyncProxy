using System;
using System.Collections.Generic;

namespace MMP.AsyncProxy
{
    /// <summary>
    /// The front door for iterator-style async. Write a method that returns
    /// IEnumerable&lt;IFuture&gt;. Everywhere you would have typed "await x",
    /// type "yield return x". Hand the method here and you get a future back.
    /// </summary>
    public static class AsyncProxy
    {
        /// <summary>For a method that finishes with "done" and no value.</summary>
        public static IFuture Run(IEnumerable<IFuture> steps)
        {
            if (steps == null) throw new ArgumentNullException("steps");
            IteratorStateMachine<VoidResult> machine =
                new IteratorStateMachine<VoidResult>(steps.GetEnumerator(), new Return<VoidResult>());
            machine.Start();
            return machine.Future;
        }

        /// <summary>
        /// For a method that produces a value. You get a Return&lt;T&gt; box as a
        /// parameter. Set its Value before the iterator ends.
        /// </summary>
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
