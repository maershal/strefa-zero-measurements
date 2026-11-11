# Z01, uzupełnienie — mikrobenchmark CPU dwóch przebiegów PBF — 2026-11-11

Pomiar do sekcji „5. CPU czy GPU” raportu `docs/reports/Z01_GPU_COST_MODEL.md` z
[strefa-zero](https://github.com/maershal/strefa-zero), gałąź `perf/z01-cpu-pbf-bench`. Narzędzie:
`experiments/pbf_cpu_bench.cpp` (target `strefa_pbf_cpu_bench`, `StrefaPbfCpuBench.exe`, opcja CMake
`STREFA_EXPERIMENT_PBF_CPU=ON`).

## Sprzęt i ustawienia

| Pozycja | Wartość |
| --- | --- |
| Sprzęt | laptop, i5-9300HF (4 rdzenie, 8 wątków), GPU bezczynne |
| Zasilanie | zasilacz, plan „Zrównoważony” |
| Build | Release MSVC 19.51, `/O2 /fp:precise`, bez `/arch:AVX2` (szczegóły w `run-2/run-spec.json`) |

## Katalogi

| Katalog | Co zawiera | W wynikach raportu |
| --- | --- | --- |
| `run-2` | pełny plan z sondą zegara CPU przed każdym tickiem; 5 bloków ABBA, 4,5 min | tak |
| `run-1` | pierwszy pełny plan bez sondy (3 bloki, commit `7594841`); pokazuje skoki ~1,7× między blokami (turbo i zegar bazowy) | nie |

Pliki w `run-2`: `ticks.csv` (każdy mierzony tick: czas sondy, mediana przebiegu gęstości i korekty w ticku,
sortowanie, 16 + 16 przebiegów, tick), `segments.csv` (odcinek = N × wątki × blok; mediany, liczba sąsiadów,
gęstość względna, suma kontrolna stanu), `summary.csv` (mediany ticków przy pełnym zegarze, tj. sonda ≤ 1,10 ×
najszybszej, oraz wszystkich ticków i ticków przy zegarze bazowym, sonda ≥ 1,5 × najszybszej), `stderr.txt`
(log), `run-spec.json`.
