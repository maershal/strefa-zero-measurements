#Requires -Version 7.2
# Z05 ABBA: mission scene, A = main (dbe068f), B = z05-single-pass-coupling (196cd0e).
# A pause before every run and a CPU probe that must be back within 15% of its best reading (Z01: after GPU load
# this laptop slows the CPU without a trace in nvidia-smi).
param([Parameter(Mandatory)][string]$Out, [int]$PauseSeconds = 120, [int]$MaxWaitSeconds = 600)
$ErrorActionPreference = 'Stop'
$repo = '<strefa-zero>'
Import-Module (Join-Path $repo 'scripts\profiling\GpuTelemetry.psm1')
$exe = @{ A = '<strefa-zero-main-worktree>\build\release\StrefaQA.exe'; B = "$repo\build\release\StrefaQA.exe" }
New-Item -ItemType Directory $Out -Force | Out-Null
$smi = Find-NvidiaSmi
$temperature = { (& $smi --query-gpu=temperature.gpu --format=csv,noheader) -join '' }
$battery = Get-CimInstance -ClassName BatteryStatus -Namespace root/wmi -ErrorAction SilentlyContinue | Select-Object -First 1
@(
    "a=dbe068f b=196cd0e pause_s=$PauseSeconds probe=sha256_64MiB_min_of_3 probe_tolerance=1.15",
    "ac_power=$($battery.PowerOnline) discharging=$($battery.Discharging)",
    "power_plan=$((powercfg /getactivescheme) -join ' ')",
    "gpu=$((& $smi --query-gpu=name,driver_version --format=csv,noheader) -join ' ')",
    "idle_start_temperature_c=$(& $temperature)",
    "start=$(Get-Date -Format o)"
) | Set-Content "$Out\environment.txt"
$buffer = [byte[]]::new(64MB)
$sha = [Security.Cryptography.SHA256]::Create()
function Probe { (1..3 | ForEach-Object { $w = [Diagnostics.Stopwatch]::StartNew(); [void]$sha.ComputeHash($buffer); $w.Elapsed.TotalMilliseconds } | Measure-Object -Minimum).Minimum }
$best = Probe
Start-Sleep -Seconds 300
$best = [Math]::Min($best, (Probe))
"idle_end_temperature_c=$(& $temperature) probe_best_ms=$([Math]::Round($best, 1))" | Add-Content "$Out\environment.txt"
$order = 'A','B','B','A','A','B','B','A','A','B','B','A'
for ($i = 0; $i -lt $order.Count; ++$i) {
    $v = $order[$i]
    if ($i -gt 0) { Start-Sleep -Seconds $PauseSeconds }
    $waited = 0
    while ($true) {
        $p = Probe
        $best = [Math]::Min($best, $p)
        if ($p -le 1.15 * $best -or $waited -ge $MaxWaitSeconds) { break }
        Start-Sleep -Seconds 15
        $waited += 15
    }
    "run=$($i + 1) variant=$v probe_ms=$([Math]::Round($p, 1)) best_ms=$([Math]::Round($best, 1)) extra_wait_s=$waited gpu_c=$(& $temperature)" | Add-Content "$Out\probe.txt"
    $run = Join-Path $Out ('{0:d2}-{1}' -f ($i + 1), $v)
    New-Item -ItemType Directory $run -Force | Out-Null
    $t = Start-GpuTelemetry -Path "$run\telemetry.csv"
    & $exe[$v] --scene-benchmark mission --seconds 60 --vsync off --test-window-size 1600 900 --profile $run *> "$run\stdout.txt"
    $code = $LASTEXITCODE
    "exit=$code" | Add-Content "$run\stdout.txt"
    Stop-GpuTelemetry $t
    "run=$($i + 1) variant=$v exit=$code probe_after_ms=$([Math]::Round((Probe), 1)) $(Get-Date -Format o)" | Add-Content "$Out\progress.txt"
}
"end=$(Get-Date -Format o)" | Add-Content "$Out\environment.txt"
"done" | Add-Content "$Out\progress.txt"
