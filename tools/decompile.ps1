# Rebuilds the compiler reference in Release and decompiles it at C# 4 level,
# so ILSpy cannot re-sugar the state machine back into async/await.
# Output: docs/compiler-output/AddAfterDelayReal.decompiled.cs
# Needs: dotnet tool install -g ilspycmd
param()
$root = Split-Path -Parent $PSScriptRoot
$proj = Join-Path $root "samples\MMP.AsyncProxy.CompilerReference"
$dll  = Join-Path $proj "bin\Release\net48\MMP.AsyncProxy.CompilerReference.dll"
$out  = Join-Path $root "artifacts\decompile"
dotnet build $proj -c Release | Out-Null
if (Test-Path $out) { Remove-Item $out -Recurse -Force }
ilspycmd -lv CSharp4 $dll -o $out
Copy-Item (Join-Path $out "MMP.AsyncProxy.CompilerReference.decompiled.cs") (Join-Path $root "docs\compiler-output\AddAfterDelayReal.decompiled.cs") -Force
Write-Host "wrote docs/compiler-output/AddAfterDelayReal.decompiled.cs"
