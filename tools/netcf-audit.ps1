# Checks the types the library, the forecourt sample, and a Compact Framework port would lean on
# against the .NET Compact Framework 3.5 reference assemblies, using ilspycmd's type listing and
# member decompile. Prints PRESENT or MISSING per row. The reference assemblies come from
# NETCFSetupv35.msi (SHA1 48eba5c9ae1856cda0c2b0833dfdc28c36dbbc04), unpacked with
# `msiexec /a ... TARGETDIR=<dir>` and taken from <dir>\v3.5\Debugger\BCL. They are Microsoft
# binaries and stay out of the repo; pass their folder with -RefDir.
#
#   pwsh tools/netcf-audit.ps1 -RefDir E:\dev\tools\netcf35-ref
#
# Needs: dotnet tool install -g ilspycmd
param([string]$RefDir = "E:\dev\tools\netcf35-ref")
$ErrorActionPreference = "Stop"
$mscorlib = Join-Path $RefDir "mscorlib.dll"
$system   = Join-Path $RefDir "System.dll"
$core     = Join-Path $RefDir "System.Core.dll"
foreach ($f in @($mscorlib, $system, $core)) { if (-not (Test-Path $f)) { throw "missing $f" } }

$types = @{}
foreach ($f in @($mscorlib, $system, $core)) {
    $name = [System.IO.Path]::GetFileName($f)
    # ilspycmd 10 takes one entity kind per -l, and prints an update notice first; keep only the "Kind Name" rows.
    foreach ($kind in @("c", "i", "d")) {
        foreach ($line in (ilspycmd -l $kind $f 2>$null)) {
            if ($line -notmatch '^(Class|Interface|Delegate|Struct|Enum) (.+)$') { continue }
            $types[$Matches[2]] = $name
        }
    }
}

function Members($dll, $type) { (ilspycmd -t $type $dll 2>$null) -join "`n" }

# type, member regex (empty = type only), who uses it
$rows = @(
    @("System.Threading.ExecutionContext",       "",                                   "AsyncMethodBuilder<T>.AwaitOnCompleted"),
    @("System.Threading.SynchronizationContext", "",                                   "FutureAwaiter<T>.OnCompleted"),
    @("System.Threading.ThreadPool",             "QueueUserWorkItem\(",                "Promise<T> (runContinuationsAsync), Futures.Run"),
    @("System.Threading.ThreadPool",             "SetMaxThreads\(",                    "the CE budget"),
    @("System.Threading.Timer",                  "public Timer\(TimerCallback",        "Futures.Delay"),
    @("System.Threading.Timer",                  "Dispose\(",                          "Futures.Delay"),
    @("System.Threading.ManualResetEvent",       "",                                   "Promise<T>.Wait, IteratorClerk.Dispose"),
    @("System.Threading.AutoResetEvent",         "",                                   "KevinsPump.Authorize"),
    @("System.Threading.WaitHandle",             "WaitOne\(int",                       "KevinsPump.Authorize"),
    @("System.Threading.Monitor",                "Enter\(",                            "lock statements everywhere"),
    @("System.Threading.Monitor",                "Wait\(",                             "training ThreadedInTray only (desktop)"),
    @("System.Threading.Interlocked",            "CompareExchange<T>\(",               "Futures.WhenAny, cancel"),
    @("System.Threading.Interlocked",            "Increment\(ref int",                 "counters"),
    @("System.Threading.Interlocked",            "Add\(ref int",                       "Pulser.Pulse (first draft)"),
    @("System.Threading.Thread",                 "VolatileRead\(",                     "Pulser.Pulses (first draft)"),
    @("System.Threading.Thread",                 "public Thread\(ThreadStart start, int maxStackSize", "KevinsPump pulser thread"),
    @("System.Exception",                        "public .* Data\b",                   "Promise<T>.PreserveStackTrace"),
    @("System.Delegate",                         "Combine\(",                          "SerialLink.DataReceived"),
    @("System.Collections.Generic.List",         "",                                   "Promise<T> continuations"),
    @("System.Collections.Generic.Queue",        "",                                   "training PromiseInTray"),
    @("System.Action",                           "",                                   "continuations"),
    @("System.Func",                             "",                                   "Futures.Run, FromAsync"),
    @("System.IAsyncResult",                     "",                                   "Futures.FromAsync"),
    @("System.AsyncCallback",                    "",                                   "Futures.FromAsync"),
    @("System.IO.Stream",                        "BeginRead\(",                        "Futures.FromAsync over a stream"),
    @("System.Net.Sockets.TcpListener",          "",                                   "the island's accept loop"),
    @("System.IO.Ports.SerialPort",              "DataReceived",                       "Kevin's serial line")
)

"{0,-44} {1,-40} {2,-9} {3}" -f "type", "member", "status", "used by"
foreach ($r in $rows) {
    $type = $r[0]; $member = $r[1]; $who = $r[2]
    $status = "MISSING"
    if ($types.ContainsKey($type)) {
        if ($member -eq "") { $status = "PRESENT" }
        else {
            $dll = Join-Path $RefDir $types[$type]
            if ((Members $dll $type) -match $member) { $status = "PRESENT" } else { $status = "MISSING" }
        }
    }
    "{0,-44} {1,-40} {2,-9} {3}" -f $type, $member, $status, $who
}
