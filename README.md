# Strefa Zero — surowe pomiary

Logi, CSV, JSON, JUnit, migawki PNG/BMP i metadane prób z kolejnych etapów projektu
[strefa-zero](https://github.com/maershal/strefa-zero). Do listopada 2026 leżały w
`docs/measurements/` głównego repozytorium; przeniesiono je tutaj bajt w bajt, bez zmian
treści, aby zwykły checkout gry nie zawierał ~12 tys. plików i 679 MB danych. Raporty w
`docs/reports/` repozytorium gry cytują potrzebne liczby i linkują tu permalinkami do
konkretnego commita.

Pliki nie są edytowane ani formatowane (`* -text` w `.gitattributes`). Nowe serie pomiarów
trafiają do nowego katalogu `<etap>/` z własnym manifestem `SHA256SUMS.txt`.

## Weryfikacja

Każdy katalog ma manifest `SHA256SUMS.txt` ze ścieżkami względnymi:

```bash
for m in */SHA256SUMS.txt; do (cd "${m%/*}" && sha256sum --quiet -c SHA256SUMS.txt) || echo "BŁĄD: $m"; done
```

Manifesty katalogów `gpu-i01` … `gpu-i04-5q` pochodzą z oryginalnych serii. Pozostałe
(`benchmarks`, `gpu-i00`, `gpu050` … `gpu070`, `i05` … `i11`, `legacy`, `linux-wsl`)
wygenerowano przy przeniesieniu, z plików śledzonych wtedy w Gicie.

## Pełne obrazy BMP

Śledzonych jest tylko część surowych BMP. Komplet z I04–I11 jest w
[wydaniu I11 Preview](https://github.com/maershal/strefa-zero/releases/tag/v0.7.0-i11-preview.1)
jako `StrefaZero-QA-images-I04-I11.zip` (ścieżki `docs/<etap>/...`, własny manifest
`QA-IMAGES-SHA256SUMS.txt`). Rozpakuj go do katalogu tymczasowego i skopiuj zawartość
`docs/` do katalogu głównego tego repozytorium, nie nadpisując plików:

```bash
unzip StrefaZero-QA-images-I04-I11.zip -d /tmp/strefa-qa
cp -rn /tmp/strefa-qa/docs/. .
```

## Katalogi i raporty

Raporty leżą w [strefa-zero/docs/reports](https://github.com/maershal/strefa-zero/tree/main/docs/reports).

| Katalog | Raport w strefa-zero |
| --- | --- |
| `z01-cpu-pbf-2026-11-11` | `Z01_GPU_COST_MODEL.md`, sekcja 5 (mikrobenchmark CPU dwóch przebiegów PBF, i5-9300HF) |
| `z01-cost-model-2026-11-10` | `Z01_GPU_COST_MODEL.md` (model kosztu ticka GPU, GTX 1650) |
| `thermal-benchmark-2026-11-04` | `docs/maintenance/GPU_CHECK.md`, PR #50 (benchmark termiki v2, wolny reżim) |
| `scene-benchmark-2026-11-02` | `docs/maintenance/GPU_CHECK.md`, PR #13 (benchmark scen, soak, wolny reżim) |
| `demo-clock` | `DEMO_CLOCK.md` |
| `legacy` | `GPU_MIGRATION.md`, `GPU_LIQUIDS.md`, `GPU_MISSION_070.md`, `PHYSICS_REVIEW_061.md`, `PERFORMANCE_AUDIT.md` |
| `benchmarks` | `PERFORMANCE_AUDIT.md` |
| `gpu050` | `GPU_MIGRATION.md` |
| `gpu060` | `GPU_LIQUIDS.md` |
| `gpu061` | `PHYSICS_REVIEW_061.md` |
| `gpu070` | `GPU_MISSION_070.md` (oraz `docs/plans/PLAN_ROZWOJU_GPU.md`) |
| `gpu-i00` | `I00_GPU_PROFILING.md` |
| `gpu-i01` | `I01_GPU_READBACK.md` |
| `gpu-i02` | `I02_GPU_EXECUTION.md` |
| `gpu-i03` | `I03_GPU_NEIGHBORS.md` |
| `gpu-i04` | `I04_GPU_COUPLING.md` |
| `gpu-i04-5` | `I04_5_GPU_STABILIZATION.md` (oraz `docs/plans/REVIEW_I04_ROZSTRZYGNIECIA.md`) |
| `gpu-i04-5b` | `I04_5B_GPU_TRANSPORT.md` |
| `gpu-i04-5c` | `I04_5C_GPU_WORK.md` |
| `gpu-i04-5d` | `I04_5D_GPU_NEIGHBOR_READS.md` |
| `gpu-i04-5e0` | `I04_5E0_GPU_COSTS.md` |
| `gpu-i04-5g` | `I04_5G_GPU_PBF_GROUPS.md` |
| `gpu-i04-5g2` | `I04_5G2_GPU_PBF_RESTRICT.md` |
| `gpu-i04-5g3` | `I04_5G3_GPU_VARIANCE.md` |
| `gpu-i04-5g3b` | `I04_5G3B_GPU_REPLAY.md` |
| `gpu-i04-5q` | `I04_5Q_GPU_COUPLING_QA.md` |
| `i05` | `I05_SHARED_WORLD.md` |
| `i06` | `I06_GAMEPLAY_PROTOCOL.md` |
| `i07` | `I07_FLUID_QUALITY.md` |
| `i08` | `I08_SCENE_RENDERER.md` |
| `i09` | `I09_GPU_VFX.md` |
| `i10` | `I10_GPU_THERMAL.md` (oraz `docs/plans/PLAN_I10_DOMKNIECIE.md`) |
| `i11` | `I11_LIGHTING.md` |
| `linux-wsl` | `LINUX_WSL_QA.md` |
