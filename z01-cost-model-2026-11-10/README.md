# Z01 — model kosztu ticka GPU — 2026-11-10

Pomiar do raportu `docs/reports/Z01_GPU_COST_MODEL.md` z
[strefa-zero](https://github.com/maershal/strefa-zero), gałąź `perf/z01-gpu-cost-model`, commit
`1c5260d41e2d8fc884499c9421e731bd06af95b7` (kod narzędzia identyczny z buildem pomiaru `run-3`).

## Sprzęt i ustawienia

| Pozycja | Wartość |
| --- | --- |
| Sprzęt | laptop, i5-9300HF, NVIDIA GeForce GTX 1650, sterownik 610.47 |
| Zasilanie | zasilacz, plan „Zrównoważony” |
| Build | Release MSVC, `StrefaQA.exe` (SHA-256 w `run-*/run-spec.json`) |
| Threaded optimization | domyślne „Auto” (nie zmieniane, nie odczytywane) |

## Katalogi

| Katalog | Co zawiera | W wynikach raportu |
| --- | --- | --- |
| `run-3` | pełny plan, bramka schładzania i rozgrzewka GPU; 432 odcinki, 51 min | tak |
| `run-2` | pełny plan z bramką schładzania, bez rozgrzewki GPU i bez okna pomiarowego w `sweep.csv` | nie |
| `run-1` | pierwsza próba bez bramki; przerwana przez utratę timerów ticka; pokazuje 5× spowolnienie CPU | nie |

Pliki w `run-*`: `series.csv` (każde powtórzenie serii syntetycznej), `segments.csv` (odcinki z sondami
kalibracyjnymi i czasem UTC), `sweep.csv`, `sweep-ticks.csv`, `series-summary.csv`, `series-fit.csv`,
`sweep-fit.csv`, `cost-model.txt`, `telemetry.csv` (nvidia-smi co 100 ms), `run-spec.json`, `run-result.json`;
w `run-2` i `run-3` także `analysis.json` i `summary.md` z `scripts/profiling/analyze-cost-model.py`
(przeliczone analizatorem po recenzji PR maershal/strefa-zero#82: dopasowanie po wszystkich N i po N ≥ N_max/4
oraz próg `crossover_n`). `sweep-fit.csv` pochodzi z wersji narzędzia sprzed tej poprawki: jego kolumna `knee_n`
to a/b, a nie próg; raport korzysta z `summary.md`.
`run-3/gpu-before-start.txt`: temperatura i P-stan GPU po 5 min bezczynności przed startem.

Odtworzenie analizy: `python scripts/profiling/analyze-cost-model.py run-3`.
