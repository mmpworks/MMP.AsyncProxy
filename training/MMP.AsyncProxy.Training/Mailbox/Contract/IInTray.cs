namespace MMP.AsyncProxy.Training.Mailbox
{
    /// <summary>
    /// The in-tray on a clerk's desk. Anyone can drop a slip in it. It holds only
    /// so many, so a flood of slips makes the sender wait instead of filling
    /// memory. Only the clerk seated at it takes slips out, and only one at a time.
    /// </summary>
    /// <typeparam name="T">The slip.</typeparam>
    public interface IInTray<T>
    {
        string Name { get; }

        /// <summary>How many slips the tray holds before a post is refused.</summary>
        int Capacity { get; }

        /// <summary>Slips posted and not yet handled, counting the one the clerk holds right now.</summary>
        int Pending { get; }

        /// <summary>Drops a slip in. False when the tray is full or closed; the sender decides what to do then.</summary>
        bool TryPost(T slip);

        /// <summary>Closes the tray. Nothing more goes in, and the clerk seated at it goes home once it is empty.</summary>
        void Close();
    }
}
