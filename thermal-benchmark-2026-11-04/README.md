# Benchmark termiki, protokół v2 — 2026-11-04

Jeden przebieg `--gpu-thermal-benchmark` w nowym protokole z
[strefa-zero#50](https://github.com/maershal/strefa-zero/pull/50): losowa kolejność scen w każdym bloku, znaczniki
czasu po każdym kernelu, liczniki dispatchy i barier, telemetria `nvidia-smi`. **Pomiar informacyjny**, nie podstawa
decyzji o wydajności: jeden przebieg (protokół wymaga ≥ 3 powtórzeń ABBA) i bez stygnięcia przed startem.

## Sprzęt i warunki

| Pozycja | Wartość |
| --- | --- |
| Sprzęt | laptop, NVIDIA GeForce GTX 1650, sterownik 610.47, limit mocy 50 W |
| Zasilanie | zasilacz, plan zrównoważony |
| Build | Release MSVC (`/WX`), gałąź `thermal-benchmark-protocol` przed podziałem na #50 i #51; kod benchmarku i termiki jak w commicie `4b883f0`, analiza `analyze-thermal.py` jak w `64593ed` z poprawkami recenzji |
| Start | GPU 60 °C, **bez 5 min stygnięcia** (wcześniej biegły testy GPU) |
| Czas | 2026-11-04 00:52–01:01 UTC (ok. 9 min) |
| Ziarno | `11745719804495518723`; kolejność bloków: fire, quench, cold, oil / quench, oil, fire, cold / cold, oil, fire, quench |
| Telemetria | `GpuTelemetry.psm1 -IntervalMs 100`; faktyczny odstęp próbek ok. 265 ms (2055 próbek) |

Polecenia (z katalogu strefa-zero):

```powershell
pwsh ./scripts/profiling/profile-thermal.ps1 -Executable build/release/StrefaQA.exe -Output thermal-bench `
    -Suite benchmark -Telemetry
python scripts/profiling/analyze-thermal.py thermal-bench --controls
```

## Wynik

Wolny reżim z [scene-benchmark-2026-11-02](../scene-benchmark-2026-11-02/README.md) wystąpił także tutaj. Po dojściu
do 85 °C (odcinek „oil” bloku 2) karta zeszła do 1395 MHz i ok. 22–26 W przy P0, bez żadnego aktywnego powodu
ograniczenia, i została tam do końca, także po ostygnięciu do 64 °C.

| Odcinki profilu | Zegar grafiki | Moc | Mediana etapu gazu |
| --- | --- | --- | --- |
| 5 (blok 1 i quench bloku 2) | 1845–1890 MHz, P0 | ok. 49 W | 1,33–1,37 ms |
| 7 (od oil bloku 2) | 1395 MHz, P0, bez powodu | ok. 22–26 W | 3,12–3,14 ms (×2,35) |

- Fizyka sceny `cold` (sand_water) rośnie z 3,5 do 15,5 ms/tick.
- Bez kryterium zegara zwykła mediana wybrałaby wolny reżim jako odniesienie (7 z 12 odcinków). Z kryterium
  (mediana zegara < 90% maksimum sesji) zostaje 8 bramek etapu `full` z odcinków w szybkim reżimie.
- Etap `full` kosztuje tam +3,6 do +4,1 ms/tick względem `off` (budżety 0,05/0,70 ms nadal niespełnione).
- 54 dispatche i 54 bariery na profilowany tick, 20 kerneli w ticku. Wszystkie 11 kontroli analizy: PASS.

## Pliki

- `thermal-samples.csv`, `thermal-pool-segments.csv`, `thermal-pass-samples.csv`, `thermal-op-samples.csv`,
  `thermal-profile-segments.csv`, `thermal-benchmark-info.txt`: wyjście StrefaQA (opis kolumn:
  `docs/maintenance/GPU_CHECK.md`, sekcja 4).
- `telemetry.csv`: telemetria `GpuTelemetry.psm1`; `run-spec.json`, `run-result.json`: `profile-thermal.ps1`.
- `thermal-summary.json`, `analysis-controls.json`: `analyze-thermal.py --controls` (schemat 2).
- `*.bmp`: obraz każdej sceny i wariantu z pierwszego bloku.

Liczniki dispatchy w `thermal-pass-samples.csv` pochodzą z buildu sprzed poprawki recenzji #50: pierwszy tick
każdego odcinka profilu zawiera też kernele resetu sceny i wymuszonego odczytu sum.
