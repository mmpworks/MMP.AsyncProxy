# Decompiles the machines so a reader can set them side by side.
#
# Part 1: the compiler reference sample at C# 4 level, so ILSpy cannot re-sugar the
#         state machine back into async/await. Output: docs/compiler-output/AddAfterDelayReal.decompiled.cs
# Part 2: the training track. For each mini-project, the AsyncProxy version (an iterator machine,
#         net35, decompiled at C# 1 so yield is not re-sugared) and the modern version (an async
#         machine, net10.0, decompiled at C# 4), each as C# and as IL.
#         Output: docs/compiler-output/training/<project>.{iterator,modern}.{cs,il}
# Needs: dotnet tool install -g ilspycmd
param()
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$out  = Join-Path $root "artifacts\decompile"
if (Test-Path $out) { Remove-Item $out -Recurse -Force }
New-Item -ItemType Directory -Path $out | Out-Null

# Part 1
$proj = Join-Path $root "samples\MMP.AsyncProxy.CompilerReference"
$dll  = Join-Path $proj "bin\Release\net48\MMP.AsyncProxy.CompilerReference.dll"
dotnet build $proj -c Release | Out-Null
ilspycmd -lv CSharp4 $dll -o (Join-Path $out "reference")
Copy-Item (Join-Path $out "reference\MMP.AsyncProxy.CompilerReference.decompiled.cs") (Join-Path $root "docs\compiler-output\AddAfterDelayReal.decompiled.cs") -Force
Write-Host "wrote docs/compiler-output/AddAfterDelayReal.decompiled.cs"

# Part 2
$training = Join-Path $root "training\MMP.AsyncProxy.Training"
$modern   = Join-Path $root "training\MMP.AsyncProxy.Training.Modern"
dotnet build $training -c Release -f net35 | Out-Null
dotnet build $modern -c Release | Out-Null
$trainingDll = Join-Path $training "bin\Release\net35\MMP.AsyncProxy.Training.dll"
$modernDll   = Join-Path $modern   "bin\Release\net10.0\MMP.AsyncProxy.Training.Modern.dll"
$target = Join-Path $root "docs\compiler-output\training"
New-Item -ItemType Directory -Path $target -Force | Out-Null

# project name -> the type that holds the machine, on each side. Generic arity is part of the name.
$machines = @(
    @{ Name = "mailbox"; Iterator = "MMP.AsyncProxy.Training.Mailbox.Async.IteratorClerk``1"; Modern = "MMP.AsyncProxy.Training.Modern.Mailbox.ChannelClerk``1" },
    @{ Name = "fan-out"; Iterator = "MMP.AsyncProxy.Training.FanOut.WhenAllCourier"; Modern = "MMP.AsyncProxy.Training.Modern.FanOut.TaskCourier" },
    @{ Name = "pipeline"; Iterator = "MMP.AsyncProxy.Training.Pipeline.Async.IteratorLine"; Modern = "MMP.AsyncProxy.Training.Modern.Pipeline.ChannelLine" },
    @{ Name = "deadline"; Iterator = "MMP.AsyncProxy.Training.Deadline.Async.WhenAnyCaller"; Modern = "MMP.AsyncProxy.Training.Modern.Deadline.TaskCaller" }
)

function Decompile($dll, $type, $level, $path) {
    $text = ilspycmd -lv $level -t $type $dll | Out-String
    Set-Content -Path $path -Value $text -NoNewline
}
function DecompileIL($dll, $type, $path) {
    $text = ilspycmd -il -t $type $dll | Out-String
    Set-Content -Path $path -Value $text -NoNewline
}

foreach ($m in $machines) {
    Decompile   $trainingDll $m.Iterator "CSharp1" (Join-Path $target "$($m.Name).iterator.cs")
    DecompileIL $trainingDll $m.Iterator           (Join-Path $target "$($m.Name).iterator.il")
    Decompile   $modernDll   $m.Modern   "CSharp4" (Join-Path $target "$($m.Name).modern.cs")
    DecompileIL $modernDll   $m.Modern             (Join-Path $target "$($m.Name).modern.il")
    Write-Host "wrote docs/compiler-output/training/$($m.Name).{iterator,modern}.{cs,il}"
}
