# Termika GPU: dokładna bramka etapu gazu — 2026-11-14

Pomiar do [strefa-zero#98](https://github.com/maershal/strefa-zero/pull/98) (raport
`docs/reports/THERMAL_GAS_GATE.md` w repozytorium gry). Kandydat 1 z
[strefa-zero#96](https://github.com/maershal/strefa-zero/issues/96), narzędzie skrótów z
[strefa-zero#97](https://github.com/maershal/strefa-zero/pull/97).

## Sprzęt i ustawienia

| Pozycja | Wartość |
| --- | --- |
| Sprzęt | laptop, GTX 1650, sterownik 610.47, i5-9300HF, zasilanie sieciowe, plan „Zrównoważony” |
| Build | Release MSVC (`scripts/build.ps1 -Configuration Release`); llvmpipe: GCC w WSL2 (`scripts/build.sh`) |
| `main` | 5a00e2c (worktree) |
| Bramka | gałąź `thermal-zero-work` |
| Pomiar ABBA | `profile-thermal-gate.ps1` (kopia obok), `StrefaQA --gpu-check thermal-gate`, plan `full`: 4 bloki, w każdym losowa kolejność scen cold, idle, fire, quench, kwadrat ABBA (bramka off, on, on, off), świeży świat, 120 ticków rozgrzewki, 240 mierzonych |

## Katalogi

- `abba-v3/`: wersja końcowa (438243f): migawka wejścia etapu gazu w osobnym buforze (64 B na komórkę), przypięta
  do bindingu 3 tylko dla op 8. 300 s bezczynności przed startem (GPU 45 °C, maksimum 66 °C), telemetria co 100 ms
  (2860 próbek), 0 z 64 odcinków zdyskwalifikowanych, `sw_power_cap` w 60.
- `abba-v2/`: wersja a38698c: migawka w bloku `ThermalAux` (48 B na komórkę). Szybsza o ok. 0,01–0,04 ms, ale na Mesa
  llvmpipe sama deklaracja tej tablicy w bloku podnosiła pamięć procesu o gigabajty (nocne CI: wyłączenie runnera;
  WSL: OOM przy 7,6 GB), dlatego zastąpiona przez v3. 0 z 64 odcinków zdyskwalifikowanych.
- `abba-v1/`: pierwsza wersja z osobnymi pełnymi przebiegami porównania przed etapem gazu i po nim (kod niezachowany
  w historii). 0 z 64 odcinków zdyskwalifikowanych.
- `bits/main-5a00e2c/`, `bits/gate/` (a38698c), `bits/gate-438243f/`: `StrefaQA --gpu-check thermal-bits` (600 ticków).
  `thermal-bits.txt` wszystkich trzech jest identyczny (sceny `fire` i `idle`). W `gate-438243f` drugi przebieg każdej
  sceny to przebieg audytu, a wiersze `gate` podają 0 naruszeń.
- `bits/llvmpipe-438243f/`: to samo na Mesa llvmpipe w WSL2, 120 ticków (maksymalny RSS 1,08 GB, 328 s). Na llvmpipe
  powtarzają się też sceny oil, quench i phases.
- `bits/mutation-always-skip/`: bramka zmieniona tak, by pomijała zawsze (tylko kopia shadera w katalogu buildu),
  60 ticków: audyt zgłasza naruszenia, test odrzuca.
- `bits/main-3600-ticks/`: `thermal-bits` z `STREFA_THERMAL_BITS_TICKS=3600` na `main`: próba punktu stałego po 30 s
  (pusty świat 0 zmienionych słów, w scenie zimnej cząstki świata wciąż ok. 63 tys. słów na tick).

Ścieżka pliku wykonywalnego w `run-spec.json` jest skrócona do `<repo>`.

| Scena (v3) | Tick bez bramki [ms] | Tick z bramką [ms] | Efekt [ms] | Efekt [%] |
| --- | --- | --- | --- | --- |
| cold | 6,847 | 5,671 | −1,172 | −17,1 |
| idle | 3,541 | 2,376 | −1,178 | −33,3 |
| fire | 3,475 | 3,626 | +0,148 | +4,3 |
| quench | 5,795 | 5,938 | +0,155 | +2,7 |
