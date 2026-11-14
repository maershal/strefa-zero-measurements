# Z06 — start trybu GPU: kompilacja shaderów, pomiar ABBA — 2026-11-14

Pomiar do PR-ów [strefa-zero#93](https://github.com/maershal/strefa-zero/pull/93) (równoległa kompilacja shaderów)
i [strefa-zero#94](https://github.com/maershal/strefa-zero/pull/94) (ekran „Kompilacja shaderów… n/m”, raport
`docs/reports/Z06_SHADER_STARTUP.md`). Mierzony jest czas od wyboru trybu do otwartego świata GPU
(`first_world_ms` z `gpu-startup.txt`) na zimno, z cache dyskowym sterownika i z cache binarnym programów (I05).

## Sprzęt i ustawienia

| Pozycja | Wartość |
| --- | --- |
| Sprzęt | laptop, GTX 1650, sterownik 610.47, i5-9300HF, zasilanie sieciowe, plan „Zrównoważony” |
| Build | Release MSVC (`scripts/build.ps1 -Configuration Release`) |
| A | `main` fdd1e26 (worktree) |
| B | część 1 + część 2 Z06; seria z telemetrią: `z06-startup-screen` a012e66, serie bez telemetrii: 77b738f (ten sam kod startu bez licznika klatek) |
| Przebieg | `StrefaQA --mission-ui-smoke-test --profile <świeży profil>`: ustawienia domyślne, okno 1280×800, VSync włączony |
| Kolejność | ABBA, 3 powtórzenia na tryb (6 przebiegów na wariant), 15 s przerwy przed każdym |
| Narzędzie | `scripts/shader-startup.ps1` (kopia wersji użytej w serii z telemetrią), Mesa: `scripts/mesa-startup.sh` |

Tryby: `cold` — cache dyskowy sterownika wyłączony i pusty (nowy `__GL_SHADER_DISK_CACHE_PATH`), bez binariów;
`driver` — cache sterownika rozgrzany jednym przebiegiem niemierzonym; `binary` — `--shader-cache on`, cache
binarny rozgrzany jednym przebiegiem, cache sterownika wyłączony.

## Seria główna z telemetrią (`gtx1650-telemetry/`)

300 s bezczynności przed pierwszym przebiegiem (GPU 54 °C), telemetria `GpuTelemetry.psm1` co 100 ms przez całą
serię (5312 próbek, `telemetry.csv`). Żaden przebieg nie miał `hw_*` ani `sw_thermal_slowdown` (0 z 36
zdyskwalifikowanych), `sw_power_cap` w żadnym; temperatura przed przebiegami 57–58 °C, maksimum 62 °C.

| Tryb | A `first_world_ms` mediana (min–max) | B `first_world_ms` | A `compile_ms` | B `compile_ms` | B `progress_gap_ms` | B klatki postępu |
| --- | --- | --- | --- | --- | --- | --- |
| cold | 10 739,5 (10 540,7–10 889,3) | 4 938,0 (4 796,9–5 483,3) | 10 556,2 | 4 707,7 | 485 (441–502) | 33 (32–37) |
| driver | 135,7 (132,5–173,3) | 135,7 (131,0–136,0) | 31,1 | 33,4 | 34 (3–54) | 1 |
| binary | 333,3 (323,6–399,3) | 368,7 (344,2–463,2) | 0 (69 trafień) | 0 (69 trafień) | 17 (3–80) | 1 (1–2) |

Telemetria co 100 ms sama spowalnia start: pełne zapytanie `nvidia-smi` (zegary, moc, przyczyny zdarzeń zegara)
dodaje ok. 50 ms do ciepłego startu. Sprawdzenie po serii, B, cache sterownika, po 3 przebiegi:

| Warunek | `first_world_ms` |
| --- | --- |
| bez nvidia-smi | 98,1 / 85,8 / 81,9 (i później 86,4 / 94,3) |
| `nvidia-smi` z samym zegarem i P-stanem co 100 ms | 82,8 / 93,1 / 83,1 |
| pełne zapytanie telemetrii co 100 ms | 150,7 / 134,1 / 143,7 |
| pełne zapytanie telemetrii co 500 ms | 150,3 / 84,0 / 83,3 |

Porównanie A–B jest więc ważne w obrębie jednej serii; bezwzględne czasy ciepłego startu bierz z serii bez
telemetrii.

## Serie bez telemetrii (`gtx1650-no-telemetry/`, `gtx1650-no-telemetry-control/`)

Ta sama macierz bez telemetrii i bez bezczynności przed serią, GPU 52–56 °C przed przebiegami
(`gpu_temp_c` w CSV), wcześniej tego samego dnia. Seria kontrolna: tylko `cold`, 2 powtórzenia ABBA (4 przebiegi
na wariant), po zmianie raportowania postępu przy zlecaniu.

| Tryb | A `first_world_ms` | B `first_world_ms` | A `compile_ms` | B `compile_ms` | B `progress_gap_ms` |
| --- | --- | --- | --- | --- | --- |
| cold | 10 460,2 (10 355,0–10 497,6) | 4 685,8 (4 643,8–4 726,2) | 10 381,3 | 4 576,7 | 440–515 |
| driver | 82,1 (80,8–84,3) | 84,8 (81,1–86,1) | 30,6 | 33,3 | 8–9 |
| binary | 259,2 (254,9–267,4) | 265,6 (258,0–276,0) | 0 | 0 | 9–11 |
| cold, kontrola | 10 749,2 (10 666,5–10 821,4) | 4 857,3 (4 820,1–5 713,6) | 10 665,3 | 4 710,6 | 474–543 |

## Mesa llvmpipe (`mesa-llvmpipe/`, tylko informacyjnie)

WSL2 na tym samym laptopie, Mesa 25.2.8, llvmpipe (LLVM 20.1.2), build GCC Release; ABBA, 2 powtórzenia
(4 przebiegi na wariant). `cold` = `MESA_SHADER_CACHE_DISABLE=true`, `driver` = cache Mesy rozgrzany. Bez
telemetrii GPU (renderer programowy).

## Pliki

- `*/shader-startup.csv` — wiersz na przebieg (pola z `gpu-startup.txt`, temperatura przed przebiegiem, w serii
  z telemetrią także okno czasu, liczba próbek, przyczyny zdarzeń zegara i `disqualified`).
- `gtx1650-telemetry/telemetry.csv`, `summary.txt`, `run.log`; `gtx1650-no-telemetry/run.log`.
- `*/runs/<tryb>-<wariant>-<przebieg>/` — `stdout.txt` i profil (`gpu-startup.txt`, `mission-ui-quick.txt`,
  `progress.txt`, `vfx-state.txt`). Katalogi cache sterownika i cache binarnego pominięto (binaria sterownika).
- `scripts/` — skrypty pomiaru.
