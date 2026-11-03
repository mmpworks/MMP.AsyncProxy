# 0. Dinner

## At the table

Tuesday night, the wing place on the frontage road at 183A and Whitesone Blvd. Good blue cheese, and four TVs nobody watches. They were all showing bass fishing with the sound off, and a man in a boat held up a fish like it owed him money.

Steve got there first and took the booth in the back, the one where he could see the door. He ordered a coffee. Dee brought it without being asked.

"Your buddy coming?" she said.

"He's coming. He's just late. He's always late when he's worried."

"What's he worried about?"

"A pump."

Dee nodded like that was a normal thing to be worried about, and went to check on the fishing fans at the bar.

Kevin came in ten minutes later with a laptop bag he did not open. He slid into the booth and put the bag next to him on the bench, the way you park a thing you plan to use later.

"You said bring the pump problem," Kevin said. "I brought the pump problem."

"Sit down first. Order first. Then we fix the pump."

Dee was already there. "Sweet tea, and the Cluckin' Hot ones," she said to Kevin. "And you want the ones that say hot and aren't," she said to Steve.

"Dee knows me better than my wife does," Kevin said.

"Dee has to. You tip better when you're stressed."

Dee wrote nothing down, she never did, and left.

---

>Hey... Narrator here. Welcome to this story about this repo. I figure a story helps to ground one in the use cases to be covered far better than some dry text. I have intentionally written this for an average reader and NOT a computer scientist, so bear with some explanations that seem a bit basic. If you hate it, too bad. Here is the problem Kevin brought.

>Kevin writes **firmware** for a fuel dispenser - yep... a gas pump. Firmware is the program that lives inside a machine instead of on a computer you sit in front of. When you pull up to a gas pump, tap your card, and pick a grade, you are talking to Kevin's firmware.

>The head of the pump, the part with the card reader and the screen and the nozzle switches, has a small computer board inside it. It has an ARM chip (a small, low-power processor, the same family that is in your phone), 64 MB of memory, and an operating system called Windows CE 6. For scale, a cheap phone today has well over a hundred times that much memory.

>The code is C# on the **.NET Compact Framework 3.5**. That is a trimmed-down version of .NET made for small devices. Somebody wrote it in 2009, and that person left in 2011. Kevin has been "the guy" since 2014.

>The compiler (the tool that turns the C# into a program) is Visual Studio 2008. It is going to stay Visual Studio 2008 until the hardware is retired. The reason is the **certification**. Before a pump is allowed to take credit cards, an outside lab tests it, and the test is done on one exact build. Change the compiler and you have to pay for the test again, and the test costs more than Kevin makes in a year. Dale, Kevin's boss, is the person who signs that check. Dale does not like to sign that check.

---

"So here's what I've got," Kevin said, and pulled a napkin toward him. This was napkin number one. He drew four boxes. "Four threads."

> Quick stop for the word. A **thread** is one worker inside a program. A program with four threads is like a shop with four employees: each one can be in the middle of a different job at the same time. Each thread needs its own stack memory.

"One reads the pulser," Kevin said, pointing at the first box. "That's the meter. A pulse is a tiny electrical tick, and every tick is a thousandth of a gallon. The thread checks the count every fifty milliseconds, does the math, and shuts the valve when you hit the limit. One watches the card reader and the keypad. One talks to the forecourt controller over a serial line. That's how we ask the bank for permission to sell you gas. And one draws the display."

---

## The napkin

This is what Kevin drew, redrawn so you can read the handwriting.

One word you will see in the picture is **blocked**. A thread is blocked when it has asked for something that is not ready yet, and the operating system has put it to sleep until it is. A blocked thread runs none of your code while it waits. Its stack and operating-system record remain in memory. The operating system can run other threads during that time. In the restaurant picture, one worker stays at the counter until the meal arrives.

On Kevin's board, the card thread asks the reader for the next card. That call waits until the hardware reports a tap or an inserted card. The operating system then wakes the thread.

The serial thread asks the UART for incoming bytes in the same way. While it waits, the UART listens to the wire. The thread keeps its memory but does no work.

```mermaid
flowchart LR
    subgraph Board["Kevin's pump board: 4 threads, 64 MB"]
        P["Pulser thread<br/>wakes every 50 ms"]
        C["Card and keypad thread"]
        S["Serial thread"]
        D["Display thread"]
    end
    P -.->|sleeps until| T["a timer tick"]
    C -.->|blocked on| R["the card reader"]
    S -.->|blocked on| U["the UART (the chip that listens to the wire)"]
    D -.->|sleeps until| X["something changes on screen"]
```

**In words:**

1. The big box is the board inside the pump. It has four threads, and the memory around them is only 64 MB.
2. The pulser thread keeps a dotted line to "a timer tick". It wakes every 50 milliseconds, reads the pulse count, then goes back to sleep.
3. The card and keypad thread has a dotted line to the card reader. It is blocked until somebody taps or inserts a card.
4. The serial thread has a dotted line to the UART. It is blocked until the controller says something.
5. The display thread waits until something changes and then redraws.
6. Each dotted arrow marks a wait. The timer, device, or event will make the thread ready to run again.

---

"That's not bad," Steve said.

"It's not bad. It works. It's worked for fifteen years." Kevin pushed the napkin over. "But we're adding a second nozzle per side, and a receipt printer, and a loyalty thing where you scan the app. And every one of those is another thread. And the box has 64 meg."

"And?"

"And the serial thread." Kevin picked up his tea and put it down again without drinking. "The serial thread is the one that scares me. It sits and waits for the controller to talk. If the controller stops talking, that thread is stuck until the **watchdog** kicks the whole board. The watchdog is a little timer chip that says 'nobody's home, I'm rebooting the pump.' In the middle of a sale. In Tulsa, once, that was a guy with his nozzle in his truck and a screen that went black."

"The Tulsa pump."

"The Tulsa pump."

The wings came. Kevin's were the color of a stop sign. Steve's were the color of a sunset that does not scare anyone. Dee set down a stack of napkins without comment, which was a joke between her and Steve that had been running for two years.

Steve looked at the napkin for a while. Kevin went after a wing.

"You know what the serial thread is doing while it waits?"

"Waiting."

"What stays allocated while that thread waits?"

"Its stack?"

"Right. And the operating system's record of it. The **stack** holds active method calls and their local data. The **kernel object** is the operating system's control record, with the thread's ID, priority, and state. The **scheduler** is the part of the operating system that chooses which ready thread runs next. A blocked thread waits off that ready list. It keeps its stack and its operating-system record while it sleeps."

"And that memory stays allocated while it waits?"

"Yes. On a box with 64 meg, those stacks take up space you could use elsewhere. The UART, that's the chip that actually listens to the wire, is doing the real work. Your thread is just standing next to the UART so it can be the one to notice." Steve took a wing. "Same with the pulser. It sleeps fifty milliseconds, wakes up, reads a number, sleeps again. That thread needs to run briefly every fifty milliseconds."

Kevin chewed. He did not love hearing that. "So what, I put everything on one thread? I tried that once. The display froze every time the bank was slow."

"Buddy, no. You don't do that. You keep the work. You stop holding a worker while you wait."

"On CE. On the 2008 compiler."

"On the 2008 compiler."

Kevin put the wing down.

"There's no `await` on the 2008 compiler, Steve."

"There's no `await` *keyword*. There's everything `await` is made of. The keyword is sugar. Underneath it, it's a **state machine** and a **callback**, and C# 2 already had both."

>(A state machine is a way of cutting a job into pieces so it can stop in the middle and pick up later. A callback is a piece of code you hand to someone and say "call this when you're done." You'll get both of them in chapters 2 and 3. For tonight, just know the words.)

"I built the rest. It's about seven hundred lines and it runs on 3.5." Steve pulled his own laptop out and set it next to the wing basket. "We're going to go through it chapter by chapter, tonight. We'll replace the thread that waits for an authorization reply and the thread that sleeps between pulse checks. The display can keep responding during those waits. We'll also check which threads the serial link still needs."


"Dale is going to have a stroke," Kevin said. "I'm not putting a library into certified firmware."

"We'll get to Dale. Chapter 9 is Dale's chapter."

"How many wings is this going to take?"

"All of them."

Kevin looked at the basket. There were eleven left, between them. He picked up the napkin with the drawing, flipped it over, and wrote "NAPKIN 1" in the corner, which was how Steve knew he was in.

---

## How the pump talks to the bank

> (A **serial line** is a wire that sends one thing at a time, like a one-lane road.)

The **forecourt** is the pump area of a gas station. In this story, one **forecourt controller** serves the station. It is a computer that routes card requests to the bank and sends replies to the pumps.

Each side of a pump cabinet is a numbered **fueling position**, where one driver can buy fuel. Each position has its own board. The boards share a serial line, so messages include a position number. Kevin's board runs position 3.

```mermaid
flowchart LR
    subgraph Island["One island: 3 pump cabinets, 6 fueling positions"]
        subgraph CabA["Cabinet A"]
            P1["Position 1"]
            P2["Position 2"]
        end
        subgraph CabB["Cabinet B"]
            P3["Position 3<br/>(Kevin's board)"]
            P4["Position 4"]
        end
        subgraph CabC["Cabinet C"]
            P5["Position 5"]
            P6["Position 6"]
        end
    end
    W(("Shared wire<br/>(the serial line)"))
    C["Forecourt controller<br/>(the station's computer)"]
    BK["The bank"]
    P1 --- W
    P2 --- W
    P3 --- W
    P4 --- W
    P5 --- W
    P6 --- W
    W <-->|"messages carry a position number"| C
    C <-->|"asks for a hold, gets yes or no"| BK
    style P3 stroke-width:3px
```

**In words:**

1. This is the arrangement used in the story. One island has three pump cabinets with a fueling position on each side, so six positions in all. Every position has its own board, like Kevin's. Position 3 is the one the story follows.
2. All six boards hang off the **same wire**. There is one serial line for the whole island, not one per pump.
3. Someone taps a card at position 3. Kevin's board sends AUTH and the card onto the wire, marked as coming from position 3.
4. The forecourt controller is on the other end of the wire. It sees the message and which position sent it. It is also the only one that talks to the bank, so it asks the bank to put a hold on the money.
5. The bank answers yes or no. That can take a moment, and sometimes it never comes.
6. The controller sends the answer back onto the wire, addressed to position 3. The other five boards ignore it, because it is not theirs. (Real stations differ on the details. Some controllers ask each position in turn, so nobody talks over anybody. The idea is the same.)
7. Position 3's serial thread is the one waiting for step 6. The other positions have their own threads waiting for their own replies.

---

## What follows

The dinner continues through the course. Each chapter starts with Kevin's next question, then walks through the code that answers it.

The code Kevin brought (the threads) and the code he left with (this library) are in `samples/MMP.AsyncProxy.Forecourt`. They are built for `net35` with the C# 3 compiler. The tests in `tests/MMP.AsyncProxy.Tests/ForecourtTests.cs` run both versions.

The library also builds against the Compact Framework 3.5 (`src/MMP.AsyncProxy.NetCF`), and Kevin's pump code builds there too. That build is checked on the desktop runtime, not on a real Windows CE board. The library keeps `Monitor.Wait` and `Monitor.Pulse` (two older locking tools the Compact Framework doesn't have) out of itself, and the sample does the same. Chapter 5 and `docs/netcf-port.md` say what else the port gives up.

Kevin is made up. The pump is not: MMP.GasPumpSimulator is a working model of one, and chapter 10 is where the two meet.

## Words you just met

| Word | In plain words | Example or comparison |
|---|---|---|
| **Firmware** | The program that lives inside a machine | The brain inside the pump |
| **Thread** | Runs one sequence of instructions | Several threads can work on different jobs |
| **Stack** | Memory for active method calls and their local data | Each thread reserves its own stack space |
| **Kernel object** | The operating system's control record for a thread | Holds the thread ID, priority, and state |
| **Scheduler** | Chooses a ready thread to run next | A waiting thread becomes eligible when its wait ends |
| **Blocked** | A thread put to sleep by the operating system until what it asked for is ready | Standing at the counter, staring at the cook |
| **Serial line / UART** | A connection that sends bits in sequence, and the chip that sends and receives them | Carries requests and replies between the pump and controller |
| **Forecourt / forecourt controller** | The pump area of a gas station; the station's computer that looks after every pump and talks to the bank | The front desk that phones the bank for every pump |
| **Watchdog** | A timer that reboots the board if the program stops checking in | A missed check-in triggers a restart |
| **State machine, callback** | Two tools you'll build in chapters 2 and 3 | Coming up |
