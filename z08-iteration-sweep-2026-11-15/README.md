# Z08: ile iteracji solvera wymagają bramki jakości — 2026-11-14/15

Pomiar do raportu `docs/reports/Z08_SOLVER_ITERATIONS.md` w repozytorium gry (gałąź `z08-iteration-sweep`, kod
narzędzia w commicie 6154a8a). `StrefaQA --gpu-check iteration-sweep`.

## Sprzęt i ustawienia

| Pozycja | Wartość |
| --- | --- |
| Sprzęt | laptop, GTX 1650, sterownik 610.47, i5-9300HF, zasilanie sieciowe, plan „Zrównoważony” |
| Build | Release MSVC (`scripts/build.ps1 -Configuration Release`), `main` f85caeb + narzędzie Z08 |
| Profil cieczy | domyślny (`legacy`), 2 podkroki; zmieniane tylko `pbf_iterations` i `contact_iterations` |
| Bramki | `--gpu-fluid-check` (I07), `--gpu-liquid-test`, `--gpu-test` (ziarna), `--gpu-flow-test`, `--gpu-coupling-check`, `--mission-test`, bez zmian progów |
| Koszt | `profile-iteration-sweep.ps1 -Plan timing` (kopia obok), 4 bloki, losowa kolejność 18 odcinków (9 konfiguracji × misja/tama) w bloku, świeży świat, 120 ticków rozgrzewki, 240 mierzonych (para `GL_TIMESTAMP` wokół `step()`), sondy Z01 przed i po odcinku, telemetria co 100 ms, 300 s bezczynności przed startem (GPU 57 °C) |

## Katalogi

- `iteration-sweep-gates/`: plan `gates`, siatka z zadania 8/12, 7/11, 6/10, 6/8, 5/8, 4/6, wszystkie bramki.
- `iteration-sweep-gates-2/`: konfiguracje graniczne 6/9, 5/10, 4/10, 5/9, 4/9, 4/8 oraz powtórzenie 8/12 i 6/8.
- `iteration-sweep-gates-3/`: 4/11 i 5/11, wszystkie bramki.
- `iteration-sweep-repeat-1..5/`: bramki `granular` i `coupling`, konfiguracje 8/12, 7/11, 6/10, 6/9, 5/10, 5/9, 4/10,
  4/9, 6/8 (po 5 procesów).
- `iteration-sweep-repeat-11-1..5/`: bramki `granular` i `coupling` dla 4/11 i 5/11.
- `iteration-sweep-timing/`: koszt (`iteration-sweep-timing.csv`, `telemetry.csv`, `run-spec.json`, `analysis.json`,
  `summary.md`). `analysis.json` i `summary.md` policzone z bramkami wszystkich katalogów:
  `python analyze-iteration-sweep.py iteration-sweep-timing --gates iteration-sweep-gates*/iteration-sweep-gates.csv iteration-sweep-repeat-*/iteration-sweep-gates.csv`.

Obrazy BMP zapisywane przez walidacje (1706 plików, 3,6 GB) nie zostały zachowane; odtwarza je to samo polecenie.
Podkatalogi `p<PBF>-c<kontakt>/<bramka>/` zawierają pliki raportów każdej walidacji (np. `gpu-tests.txt` z
`scene_2_max_penetration_cells`, `fluid-quality.csv`, `coupling-tests.txt`).
