#!/usr/bin/env bash
# Mesa llvmpipe: StrefaQA --mission-ui-smoke-test, A=main, B=branch, ABBA, modes cold/driver.
set -u
A=<baseline worktree>/build/linux-release/StrefaQA
B=<candidate checkout>/build/linux-release/StrefaQA
OUT=${1:-/tmp/z06-mesa}
rm -rf "$OUT"; mkdir -p "$OUT"
export LIBGL_ALWAYS_SOFTWARE=1 GALLIUM_DRIVER=llvmpipe
echo "mode,build,run,exit,process_s,programs,parallel_compile,compile_ms,submit_ms,progress_ms,progress_gap_ms,first_world_ms" > "$OUT/mesa.csv"
run() { # mode build name measured
    local mode=$1 build=$2 name=$3 exe=$A; [ "$build" = B ] && exe=$B
    local dir="$OUT/runs/$mode-$build-$name" cache="$OUT/cache/$mode-$build"
    [ "$mode" = cold ] && rm -rf "$cache"
    mkdir -p "$dir" "$cache"
    if [ "$mode" = cold ]; then export MESA_SHADER_CACHE_DISABLE=true; else export MESA_SHADER_CACHE_DISABLE=false; fi
    export MESA_SHADER_CACHE_DIR="$cache"
    local t0=$(date +%s.%N)
    "$exe" --mission-ui-smoke-test --profile "$dir/profile" > "$dir/stdout.txt" 2>&1
    local code=$? t1=$(date +%s.%N)
    [ "$4" = 1 ] || return 0
    local f="$dir/profile/gpu-startup.txt"
    get() { grep -m1 "^$1=" "$f" 2>/dev/null | cut -d= -f2; }
    echo "$mode,$build,$name,$code,$(echo "$t1 - $t0" | bc),$(get programs),$(get parallel_compile),$(get compile_ms),$(get submit_ms),$(get progress_ms),$(get progress_gap_ms),$(get first_world_ms)" | tee -a "$OUT/mesa.csv"
}
for mode in cold driver; do
    if [ "$mode" = driver ]; then run driver A warm 0; run driver B warm 0; fi
    for r in 1 2; do
        if [ $((r % 2)) = 1 ]; then order="A B B A"; else order="B A A B"; fi
        i=0; for b in $order; do sleep 5; run $mode $b "r$r-$i" 1; i=$((i + 1)); done
    done
done
