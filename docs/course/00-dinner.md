# 0. Dinner

Tuesday night, the wing place on the frontage road, the one with the good blue cheese and the TVs nobody watches. Steve got there first and took the booth in the back. Kevin came in ten minutes late with a laptop bag he did not open.

"You said bring the pump problem," Kevin said. "I brought the pump problem."

"Sit down first. Order first. Then the pump."

Kevin ordered the hot ones. Steve ordered the ones that say hot and are not. The waitress knew both of them.

---

Kevin runs firmware for a fuel dispenser. The head of the pump, the part with the card reader and the display and the nozzle switches, has a board in it with an ARM chip, 64 MB of RAM, and Windows CE 6. The code is C# on the .NET Compact Framework 3.5. It was written in 2009 by a guy who left in 2011, and Kevin has been the guy since 2014. The compiler is Visual Studio 2008. It is going to be Visual Studio 2008 until the hardware is retired, because the certification that lets the thing take credit cards was done against that build chain, and redoing it costs more than Kevin's salary.

"So here's what I've got," Kevin said, and drew on a napkin. "Four threads. One reads the pulser. That's the meter. Every pulse is a thousandth of a gallon. It polls the count every fifty milliseconds and does the math and stops the valve at the ceiling. One watches the card reader and the keypad. One talks to the forecourt controller over a serial line, which is how we ask the bank for a hold. One draws the display."

"That's not bad."

"It's not bad. It works. It's worked for fifteen years." He pushed the napkin over. "But we're adding a second nozzle per side, and a receipt printer, and the loyalty thing, and every one of those is another thread, and the box has 64 meg. And the serial thread. The serial thread is the one that scares me. It blocks on a read. If the controller stops talking, that thread is gone until the watchdog kicks the whole board."

Steve looked at the napkin for a while.

"You know what the serial thread is doing while it's blocked in that read?"

"Waiting."

"Right. And what's it holding while it waits?"

"A... thread."

"A stack. A kernel object. A slot in the scheduler. On a box with 64 meg. And it's holding all of that to do nothing, because the UART is doing the work. The thread is standing there so it can be the one to notice." Steve took a wing. "Same with the pulser thread. It sleeps fifty milliseconds, wakes up, reads a number, sleeps again. It's a thread that exists to sleep."

"So what, I put it all on one thread? I did that once. The display froze every time the bank was slow."

"No. You keep the work. You stop holding a thread while you wait."

"On CE 6. On the 2008 compiler."

"On the 2008 compiler."

Kevin put the wing down.

"There's no `await` on the 2008 compiler, Steve."

"There's no `await` keyword. There's everything `await` is made of. The keyword is sugar. Underneath it is a state machine and a callback, and C# 2 had both. I built the rest. It's about seven hundred lines and it runs on 3.5." Steve pulled his own laptop out. "Nine chapters. We're going to go through them tonight, and when we're done, your serial thread is gone and your pulser thread is gone and the display never freezes, and the box has the same four threads it had when it booted."

"How many wings is this going to take?"

"All of them."

---

What follows is the course, with the dinner running alongside it. Each chapter opens at the table, where Kevin asks the question a working engineer would ask, and Steve answers it with the thing in the chapter. The code Kevin brought and the code he left with are in `samples/MMP.AsyncProxy.Forecourt`, built for `net35` with the C# 3 compiler, and the tests in `tests/MMP.AsyncProxy.Tests/ForecourtTests.cs` run both versions. The Compact Framework build is still on the plan; the library keeps `Monitor.Wait` and `Monitor.Pulse` out of itself so that port stays possible, and the sample does the same.

Kevin is made up. The pump is not: MMP.GasPumpSimulator is a working model of one, and chapter 10 is where the two meet.
