# Zegar i tempo dema

Raport: `docs/reports/DEMO_CLOCK.md` w strefa-zero. GTX 1650 przez WSLg/D3D12 (`GALLIUM_DRIVER=d3d12`), 2 listopada 2026.

- `catchup-*`: `StrefaQA --mission-smoke-test`, warianty limitu kroków w klatce (stały 2/3/4, względny maks. 5) uruchomione tymczasową łatką; limit czasu testu podniesiony na czas pomiaru.
- `final-adaptive-max4`: `gpu.mission_ui` z kodem gałęzi (względny, maks. 4); test nie przeszedł kryterium utraconego czasu (`smoke-error.txt`).
- `mission-ui-quick-stall`: `gpu.mission_ui_quick` z przestojem 5 s.
