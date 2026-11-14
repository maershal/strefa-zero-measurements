# Termika GPU: dokładna bramka etapu gazu — 2026-11-14

Pomiar do PR-a z bramką etapu gazu termiki (raport `docs/reports/THERMAL_GAS_GATE.md` w repozytorium gry). Kandydat 1
z [strefa-zero#96](https://github.com/maershal/strefa-zero/issues/96), narzędzie skrótów z
[strefa-zero#97](https://github.com/maershal/strefa-zero/pull/97).

## Sprzęt i ustawienia

| Pozycja | Wartość |
| --- | --- |
| Sprzęt | laptop, GTX 1650, sterownik 610.47, i5-9300HF, zasilanie sieciowe, plan „Zrównoważony” |
| Build | Release MSVC (`scripts/build.ps1 -Configuration Release`) |
| `main` | 5a00e2c (worktree) |
| Bramka | gałąź `thermal-zero-work`, commit a38698c (`abba-v2`, `bits/gate`, `bits/mutation-always-skip`) |
| Pomiar ABBA | `profile-thermal-gate.ps1` (kopia obok), `StrefaQA --gpu-check thermal-gate`, plan `full`: 4 bloki, w każdym losowa kolejność scen cold, idle, fire, quench, kwadrat ABBA (bramka off, on, on, off), świeży świat, 120 ticków rozgrzewki, 240 mierzonych |

## Katalogi

- `abba-v2/`: pomiar wersji z PR-a. 300 s bezczynności przed startem (GPU 53 °C), telemetria co 100 ms
  (`telemetry.csv`, 3416 próbek), 0 z 64 odcinków zdyskwalifikowanych, `sw_power_cap` w 55. Wynik w `summary.md`
  i `analysis.json` (`analyze-thermal-gate.py`, kopia obok).
- `abba-v1/`: ten sam pomiar pierwszej wersji bramki z osobnymi pełnymi przebiegami porównania przed etapem gazu
  i po nim (kod niezachowany w historii; zastąpiony przez v2). 0 z 64 odcinków zdyskwalifikowanych.
- `bits/main-5a00e2c/`, `bits/gate/`: `StrefaQA --gpu-check thermal-bits` (600 ticków) na `main` i na bramce.
  `thermal-bits.txt` obu jest identyczny (sceny `fire` i `idle`). `bits/gate/thermal-bits-info.txt` zawiera wiersze
  `gate` z audytem (0 naruszeń).
- `bits/mutation-always-skip/`: bramka zmieniona tak, by pomijała zawsze (tylko kopia shadera w katalogu buildu),
  60 ticków: audyt zgłasza naruszenia, test odrzuca.
- `bits/main-3600-ticks/`: `thermal-bits` z `STREFA_THERMAL_BITS_TICKS=3600` na `main`: próba punktu stałego po 30 s
  (pusty świat 0 zmienionych słów, w scenie zimnej cząstki świata wciąż ok. 63 tys. słów na tick).

Ścieżka pliku wykonywalnego w `run-spec.json` jest skrócona do `<repo>`.

| Scena | Tick bez bramki [ms] | Tick z bramką [ms] | Efekt [ms] | Efekt [%] |
| --- | --- | --- | --- | --- |
| cold | 6,872 | 5,660 | −1,215 | −17,7 |
| idle | 3,568 | 2,364 | −1,204 | −33,7 |
| fire | 3,503 | 3,621 | +0,115 | +3,3 |
| quench | 5,810 | 5,961 | +0,147 | +2,5 |
