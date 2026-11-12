# Z03 — odczyty diagnostyczne benchmarków przez bufor pośredni — 2026-11-12

Pomiar do PR [strefa-zero#86](https://github.com/maershal/strefa-zero/pull/86) i zgłoszenia
[strefa-zero#49](https://github.com/maershal/strefa-zero/issues/49). Porównanie liczby komunikatów sterownika 131186
(migracja bufora) w benchmarkach termiki, oświetlenia i efektów przed zmianą i po niej.

## Sprzęt i ustawienia

| Pozycja | Wartość |
| --- | --- |
| Sprzęt | laptop, GTX 1650, sterownik 610.47, i5-9300HF |
| Build | Release MSVC 19.51 |
| `main` | `origin/main` 69bbac2 |
| `branch` | `perf/z03-staged-readback` ae7d796 |
| Flagi | `StrefaQA --gpu-<thermal|lighting|vfx>-benchmark --gl-debug`, `STREFA_BENCHMARK_SEED=1` |

**Pomiar orientacyjny, niezgodny z protokołem pomiaru z `CLAUDE.md`:** GPU miało 75 °C na starcie, nie było
telemetrii, wykonano jeden przebieg na wariant zamiast ABBA (najpierw `branch`, potem `main`), a benchmarki
oświetlenia i efektów gałęzi szły równolegle z kompilacją `main`. Liczby komunikatów 131186 nie zależą od tych
warunków; czasy (w tym etap gazu) tak.

## Katalogi

| Katalog | Co zawiera |
| --- | --- |
| `main/<benchmark>` | wyniki benchmarku przed zmianą; komunikaty 131186 tylko łącznie w `gl-debug.txt` (cały benchmark w fazie `validation`) |
| `branch/<benchmark>` | wyniki po zmianie; kolumny `id131186_runtime` i `id131186_readback` w `thermal-pool-segments.csv`, `thermal-profile-segments.csv`, `lighting-sources.csv`, `vfx-debug-segments.csv` |

Obrazy BMP z benchmarków pominięto. `thermal/analyze-thermal-stdout.json` to wyjście
`scripts/profiling/analyze-thermal.py`, `thermal/thermal-summary.json` jego pełny raport.

## Wyniki

| Benchmark | `main`: 131186 | `branch`: runtime / odczyty |
| --- | --- | --- |
| termika | 3339 (1307 wpisów nie zmieściło się w dzienniku, licznik dokładny) | 0 / 0 |
| oświetlenie | 687 | 0 / 0 |
| efekty | 3535 | 0 / 0 |

Etap gazu (mediana referencyjna, mediany 12 odcinków profilu): `main` 3,143 ms (3,135–3,162 ms), `branch`
3,122 ms (1,352–3,144 ms; trzy odcinki bloku 1 ok. 1,36 ms). Oba przebiegi spędziły większość czasu w wolnym
reżimie z #49. Że migracje nie są jego przyczyną, to hipoteza do sprawdzenia w pomiarze A/B zgodnym z protokołem.
