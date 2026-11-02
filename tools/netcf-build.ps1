# Builds the library against the .NET Compact Framework 3.5 reference assemblies and runs
# the test suite against that binary on the desktop CLR. CF assembly references are
# retargetable, so the desktop runtime binds them to its own mscorlib; what this proves is
# that the CF-compiled IL runs and the suite passes, with the desktop-only facts skipped.
# It does not prove anything about a device: see docs/netcf-port.md, "What this does not say".
#
#   pwsh tools/netcf-build.ps1 [-RefDir E:\dev\tools\netcf35-ref] [-Configuration Release]
param(
    [string]$RefDir = "E:\dev\tools\netcf35-ref",
    [string]$Configuration = "Release"
)
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path (Join-Path $RefDir "mscorlib.dll"))) { throw "CF 3.5 reference assemblies missing at $RefDir. See docs/netcf-port.md." }

Write-Host "== CF 3.5 build"
dotnet build (Join-Path $root "src\MMP.AsyncProxy.NetCF") -c $Configuration -p:NetCFRefDir=$RefDir
if ($LASTEXITCODE -ne 0) { throw "CF build failed" }
$dll = Join-Path $root "src\MMP.AsyncProxy.NetCF\bin\$Configuration\net35\MMP.AsyncProxy.dll"
Write-Host ("   {0}  {1:N0} bytes" -f $dll, (Get-Item $dll).Length)

Write-Host "== CF 3.5 build of Kevin's forecourt sample"
dotnet build (Join-Path $root "samples\MMP.AsyncProxy.Forecourt.NetCF") -c $Configuration -p:NetCFRefDir=$RefDir
if ($LASTEXITCODE -ne 0) { throw "CF forecourt build failed" }
$forecourt = Join-Path $root "samples\MMP.AsyncProxy.Forecourt.NetCF\bin\$Configuration\net35\MMP.AsyncProxy.Forecourt.dll"
Write-Host ("   {0}  {1:N0} bytes" -f $forecourt, (Get-Item $forecourt).Length)

Write-Host "== test suite against the two CF builds"
$dir = (Split-Path -Parent $dll) + "\"
$fdir = (Split-Path -Parent $forecourt) + "\"
dotnet test (Join-Path $root "tests\MMP.AsyncProxy.Tests") -c $Configuration -p:AsyncProxyDllDir=$dir -p:ForecourtDllDir=$fdir
if ($LASTEXITCODE -ne 0) { throw "tests against the CF build failed" }
