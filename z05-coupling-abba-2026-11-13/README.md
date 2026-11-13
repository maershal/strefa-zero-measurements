# Z05 — jeden przebieg sprzężenia postaci na redukcję, pomiar ABBA misji — 2026-11-13

Pomiar do PR [strefa-zero#90](https://github.com/maershal/strefa-zero/pull/90): redukcja kolejki reakcji postaci
w jednym dispatchu zamiast dwóch (140 → 114 dispatchy fizyki na tick misji), wynik bitowo identyczny. Pomiar ma
potwierdzić brak regresji czasu.

## Sprzęt i ustawienia

| Pozycja | Wartość |
| --- | --- |
| Sprzęt | laptop, GTX 1650, sterownik 610.47, i5-9300HF, zasilanie sieciowe, plan „Zrównoważony” |
| Build | Release MSVC (`scripts/build.ps1 -Configuration Release`) |
| A | `main` dbe068f (worktree) |
| B | `z05-single-pass-coupling` 196cd0e |
| Flagi | `StrefaQA --scene-benchmark mission --seconds 60 --vsync off --test-window-size 1600 900` |
| Kolejność | ABBA ABBA ABBA (12 przebiegów), telemetria GPU (`GpuTelemetry.psm1`) w każdym |

## Wynik (`paused/`)

5 min bezczynności przed serią; przed każdym przebiegiem 120 s przerwy i sonda CPU (SHA-256 z 64 MiB, minimum z 3)
w granicy 15% najlepszego odczytu (`probe.txt`). Żadne okno nie miało `hw_*` ani `sw_thermal_slowdown`;
`sw_power_cap` aktywne w 75–100% próbek w obu wariantach (limit mocy laptopa); mediana zegara GPU 1845–1875 MHz.

| Wariant | Przebiegi | Mediana fizyki GPU (ms), mediana przebiegów | Zakres median przebiegów | p95 fizyki (ms) | GPU ms na s symulacji | Utracone (s) |
| --- | --- | --- | --- | --- | --- | --- |
| A (`main`) | 6 | 3,324 | 3,30–3,35 | 4,10 | 409,5 | 0 |
| B (PR #90) | 6 | 3,227 | 3,21–3,25 | 3,99 | 397,7 | 0 |

Każdy przebieg B jest szybszy od każdego przebiegu A (ok. 0,1 ms na tick, −2,9%).

## Seria odrzucona (`discarded-no-pauses/`)

Ta sama macierz bez przerw i bez sondy. Po przebiegu 3 oba warianty przeszły w stan z zegarem GPU 1395 MHz,
przeważnie `gpu_idle`, ok. 13,5 ms fizyki i ok. 24 s utraconych na przebieg (A 13,55, B 13,44 ms mediany), bez
żadnego powodu zgłoszonego przez nvidia-smi — zgodnie ze spowolnieniem CPU po obciążeniu GPU opisanym w raporcie
Z01. Sonda w serii `paused/` to potwierdza: 150–166 ms przed przebiegiem, 255–290 ms tuż po nim. Seria nie jest
podstawą porównania.

## Pliki

| Ścieżka | Co zawiera |
| --- | --- |
| `<seria>/NN-X/` | przebieg nr NN wariantu X: `scene-benchmark.csv`, `scene-benchmark-frames.csv`, `scene-benchmark-info.txt`, `telemetry.csv`, `stdout.txt` |
| `<seria>/environment.txt` | zasilanie, plan, sterownik, temperatury, czasy |
| `<seria>/abba-summary.csv` | tabela przebiegów z `scripts/analyze-abba.ps1` |
| `paused/probe.txt`, `paused/progress.txt` | odczyty sondy CPU przed i po każdym przebiegu |
| `scripts/` | `abba.ps1` (seria `paused`; seria odrzucona to ta sama pętla bez przerw i sondy), `analyze-abba.ps1`; ścieżki lokalne zastąpione przez `<strefa-zero>` |
