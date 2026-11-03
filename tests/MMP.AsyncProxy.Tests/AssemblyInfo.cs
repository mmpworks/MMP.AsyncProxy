using Xunit;

// One class at a time. Several tests here measure timing on the shared thread pool, park
// a thousand workers, swap Console.Out, or spawn the comparison console. Run side by side
// they starve each other's pool callbacks (the 30 ms delay in ImprovementsTests once took
// 1,082 ms with the whole suite in flight) and read each other's console output. The suite
// takes a few seconds serial, so the trade is cheap. The training suite made the same call.
[assembly: CollectionBehavior(DisableTestParallelization = true)]
