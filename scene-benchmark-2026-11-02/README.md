# Benchmark scen i soak GPU — 2026-11-02

Pierwsza pełna kontrola według `docs/maintenance/GPU_CHECK.md` z
[strefa-zero](https://github.com/maershal/strefa-zero) na buildzie `main` 5eec70c, czyli po PR #13 i #20.

## Sprzęt i ustawienia

| Pozycja | Wartość |
| --- | --- |
| Sprzęt | laptop, NVIDIA GeForce GTX 1650, sterownik 610.47, limit mocy 50 W |
| Zasilanie | zasilacz, plan zrównoważony |
| Build | Release MSVC, ustawienia domyślne `core::Settings` |
| Okno | widoczne, 1600×920 px, skala DPI 1,25 |

## Przebieg

Uruchomiony przez `run-gpu-check.ps1`:

1. 5 min stygnięcia z telemetrią: `cooldown-telemetry.csv`, od 62 do 54 °C.
2. `StrefaQA --scene-benchmark all --seconds 60 --vsync on`, wynik w `benchmark-vsync-on/`. Po nim 5 min przerwy.
3. To samo z `--vsync off`, wynik w `benchmark-vsync-off/`. Po nim 5 min przerwy.
4. `soak.ps1 -SingleProcess -Baseline benchmark-vsync-off/scene-benchmark.csv`, wynik w `soak/`: 15 min, 17 scen GPU po 10 s, VSync off.

Wszystkie 64 pomiary benchmarku i 85 pomiarów soaku mają status `ok`.

## Wynik

Wolny reżim (G3-B) występuje bez VSync i trwa do końca procesu.

- Po dwóch scenach na limicie mocy (49 W, `sw_power_cap`, 86 °C) zegar GPU spada od sceny `gpu:mixed` do 1395 MHz.
- Pobór mocy spada do ok. 20 W, a temperatura do ok. 60 °C. Sterownik nie zgłasza wtedy żadnego aktywnego powodu poza `gpu_idle`.
- Fizyka GPU zwalnia ok. ×4.

W soaku przebieg 1 jest szybki, a przebiegi 2–5 wolne (×3,95–4,01).

| Scena | Fizyka, VSync on (ms) | Fizyka, VSync off (ms) | Zegar przy VSync off |
| --- | ---: | ---: | --- |
| `gpu:avalanche` | 2,70 | 1,83 | 1800 MHz, 49,6 W |
| `gpu:mixed` | 2,71 | 7,77 | 1395 MHz, 22,6 W |
| `gpu:dam-break` | 2,80 | 12,23 | 1395 MHz |
| `gpu:sand-water` | 3,98 | 16,83 | 1395 MHz |
| `mission` | 3,43 | 13,73 | 1395 MHz |
| `thermal:fire` | 4,78 | 8,38 | 1395 MHz |

Fizyka to średni czas GPU na tick.

Baza soaku pochodzi z benchmarku VSync off, który od trzeciej sceny był już wolny. Kryterium bezwzględne jest więc
miarodajne tylko dla `gpu:avalanche` i `gpu:rain`.

## Pliki

`*/scene-benchmark-frames.csv` są spakowane gzipem (`.csv.gz`), bo jeden z nich przekracza limit GitHuba 100 MB.
Manifest `SHA256SUMS.txt` obejmuje pliki `.gz`. Sumy SHA-256 i rozmiary nieskompresowanych plików:

| SHA-256 | Bajty | Plik |
| --- | ---: | --- |
| `bf8d27003760c2c47f55e3d90131eea69102fe8b34b125cc20ca52aa3234e3c0` | 126428713 | `benchmark-vsync-off/scene-benchmark-frames.csv` |
| `b892ca4c2d208a1f52125f00cbad55cd457dc406455f1af2368949717b9c06de` | 13763931 | `benchmark-vsync-on/scene-benchmark-frames.csv` |
| `43af3486595b319a9ef3e8dfaf07bc985d67c77adbcc45f87d3c3e6a65569952` | 30655521 | `soak/run/scene-benchmark-frames.csv` |

Pozostałe pliki są bajt w bajt takie, jakie zapisał StrefaQA lub skrypty.
