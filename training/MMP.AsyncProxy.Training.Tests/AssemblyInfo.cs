using Xunit;

// Several tests count the process's threads before and after seating clerks or sending
// letters. Two of those running at once would count each other's threads, so the suite
// runs its test classes one at a time. It finishes in a few seconds either way.
[assembly: CollectionBehavior(DisableTestParallelization = true)]
