# Z09: domyślne iteracje solvera 5/11 — 2026-11-15

Dane do PR „Default solver iterations 5/11” w repozytorium gry (gałąź `default-iterations-5-11`).

- `gpu-511.log`: `ctest -L graphics` (74 testy, `STREFA_REQUIRE_GL43=1`) na GTX 1650, sterownik 610.47, build Release
  MSVC z domyślną konfiguracją 5/11: 74/74 zaliczone.
- `fluid-8-12-vs-5-11-t1200.png`: sceny I07 4, 5, 6, 7, 8, 10, 11 (`--gpu-fluid-check`, profil `legacy`) w ticku 1200,
  po lewej 8/12, po prawej 5/11. Źródło: BMP z pomiaru Z08 (`../z08-iteration-sweep-2026-11-15`, katalogi
  `iteration-sweep-gates/p8-c12/fluid_quality` i `iteration-sweep-gates-3/p5-c11/fluid_quality`, obrazy nie zachowane),
  złożone skryptem `compare_fluid_images.py`.
