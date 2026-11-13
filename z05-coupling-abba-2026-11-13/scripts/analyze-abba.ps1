#Requires -Version 7.2
param([string]$Out = "$PSScriptRoot\z05-abba")
$ErrorActionPreference = 'Stop'
Import-Module '<strefa-zero>\scripts\profiling\GpuTelemetry.psm1'
$inv = [Globalization.CultureInfo]::InvariantCulture
$rows = foreach ($run in Get-ChildItem $Out -Directory | Sort-Object Name) {
    $b = Import-Csv "$($run.FullName)\scene-benchmark.csv" | Where-Object scene -eq 'mission' | Select-Object -First 1
    $tel = Import-GpuTelemetry "$($run.FullName)\telemetry.csv"
    $w = Get-GpuTelemetryWindow -Telemetry $tel -StartNs ([long]$b.start_utc_unix_ns) -EndNs ([long]$b.end_utc_unix_ns)
    $bad = @('hw_slowdown', 'hw_thermal_slowdown', 'hw_power_brake_slowdown', 'sw_thermal_slowdown') |
        Where-Object { $w."Reason_$_" -gt 0 }
    [pscustomobject]@{
        run = $run.Name; variant = $run.Name.Substring(3); status = $b.status
        physics_median_ms = [double]::Parse($b.physics_median_ms, $inv)
        physics_p95_ms = [double]::Parse($b.physics_p95_ms, $inv)
        gpu_ms_per_sim_s = [double]::Parse($b.gpu_ms_per_sim_second, $inv)
        dropped_s = [double]::Parse($b.dropped_seconds, $inv)
        mhz = $w.GraphicsMhzMedian; temp_max = $w.TemperatureCMax; power_cap = $w.Reason_sw_power_cap
        disqualified = ($bad -join '+')
    }
}
$rows | Format-Table -AutoSize | Out-String -Width 250
$rows | Export-Csv "$Out\abba-summary.csv" -NoTypeInformation
foreach ($v in 'A', 'B') {
    $ok = @($rows | Where-Object { $_.variant -eq $v -and -not $_.disqualified -and $_.status -eq 'ok' })
    $med = { param($xs) $s = @($xs | Sort-Object); if ($s.Count % 2) { $s[[int][Math]::Floor($s.Count / 2)] } else { ($s[$s.Count / 2 - 1] + $s[$s.Count / 2]) / 2 } }
    '{0}: runs={1} median(physics_median)={2:N4} median(physics_p95)={3:N4} median(gpu_ms/sim_s)={4:N2} dropped_sum={5}' -f $v, $ok.Count,
        (& $med $ok.physics_median_ms), (& $med $ok.physics_p95_ms), (& $med $ok.gpu_ms_per_sim_s), ($ok.dropped_s | Measure-Object -Sum).Sum
}
