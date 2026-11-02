# P06 – CPU-01 + CPU-02 (StrefaPhysics A/B)

- A = maershal/strefa-zero 6d98c4d (chain case only), B = perf/p06-soa-layout-detonate (see environment.txt).
- runs.csv: one row per process; ABAB order, 4 rounds, scenes in separate processes, --threads 1 and 2.
- raw/<scene>-t<threads>-r<round>-<A|B>/: summary.csv, <scene>-profile.csv, stdout.txt of StrefaPhysics.
- raw/all-t<threads>-<A|B>/: --scene all runs for the scene-order check.
- telemetry.csv: Windows WMI ProcessorInformation(_Total) once per second (perf_pct > 100 = turbo); started after
  the first six runs (wood-fire t1); thermal zone unavailable without admin rights.
