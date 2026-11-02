#Requires -Version 7.2
# Runs docs/maintenance/GPU_CHECK.md unattended: cool-down, benchmark with and without VSync, single-process soak.
param([Parameter(Mandatory = $true)][string]$Repo, [Parameter(Mandatory = $true)][string]$Out)
$ErrorActionPreference = 'Stop'
Set-Location $Repo
[Console]::OutputEncoding = [Text.UTF8Encoding]::new($false)
Add-Type -Namespace Win32 -Name Power -MemberDefinition '[DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint flags);'
[void][Win32.Power]::SetThreadExecutionState([uint32]2147483651) # ES_CONTINUOUS | ES_SYSTEM_REQUIRED | ES_DISPLAY_REQUIRED
New-Item -ItemType Directory -Path $Out -Force | Out-Null
$progress = Join-Path $Out 'progress.txt'
function Note([string]$Text) { "$([DateTimeOffset]::Now.ToString('HH:mm:ss')) $Text" | Add-Content -LiteralPath $progress }
Import-Module (Join-Path $Repo 'scripts/profiling/GpuTelemetry.psm1') -Force
$exe = (Resolve-Path (Join-Path $Repo 'build/release/StrefaQA.exe')).Path

Note 'stygniecie 300 s'
$t = Start-GpuTelemetry -Path (Join-Path $Out 'cooldown-telemetry.csv')
Start-Sleep -Seconds 300
Stop-GpuTelemetry $t | Out-Null

foreach ($vsync in 'on', 'off') {
    $dir = Join-Path $Out "benchmark-vsync-$vsync"
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    Note "benchmark vsync $vsync start"
    $t = Start-GpuTelemetry -Path (Join-Path $dir 'telemetry.csv')
    & $exe --scene-benchmark all --seconds 60 --vsync $vsync --profile $dir 2> (Join-Path $dir 'stderr.txt') |
        Tee-Object -FilePath (Join-Path $dir 'summary.txt') | Out-Null
    $code = $LASTEXITCODE
    Stop-GpuTelemetry $t | Out-Null
    Note "benchmark vsync $vsync koniec, kod $code"
    Note 'przerwa 300 s'
    Start-Sleep -Seconds 300
}

Note 'soak start'
pwsh -NoProfile -File (Join-Path $Repo 'scripts/profiling/soak.ps1') -Executable $exe -Output (Join-Path $Out 'soak') `
    -SingleProcess -Baseline (Join-Path $Out 'benchmark-vsync-off/scene-benchmark.csv') *> (Join-Path $Out 'soak-console.txt')
Note "soak koniec, kod $LASTEXITCODE"
Note 'GOTOWE'
