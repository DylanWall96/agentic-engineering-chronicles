#!/usr/bin/env bash
# Runs every case n times against one configuration, appending one line per
# run to results.jsonl.
#
#   ./eval.sh --config baseline        --runs 20
#   ./eval.sh --config trimmed-context --runs 20
#   ./analyse.sh
#
# No network, no API keys, no model calls with the default agent. Same seed
# gives byte-identical results.
set -euo pipefail
cd "$(dirname "$0")"
export EVAL_ROOT="$PWD"

CONFIG=baseline; RUNS=20; AGENT=fake; export SEED=${SEED:-20260816}
while [ $# -gt 0 ]; do
  case "$1" in
    --config) CONFIG=$2; shift 2 ;;
    --runs)   RUNS=$2;   shift 2 ;;
    --agent)  AGENT=$2;  shift 2 ;;
    *) echo "unknown flag: $1" >&2; exit 2 ;;
  esac
done

TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
touch results.jsonl

for case_dir in cases/*/; do
  case_name=$(basename "$case_dir")
  for run in $(seq 1 "$RUNS"); do
    export WORKSPACE="$TMP/$case_name-$run"
    export TRANSCRIPT="$WORKSPACE/.transcript"
    cp -R fixture "$WORKSPACE"

    start=$(date +%s)
    "./agents/$AGENT.sh" "$case_name" "$CONFIG" "$run"
    elapsed=$(( $(date +%s) - start ))

    if "$case_dir/expect.sh"; then pass=true; else pass=false; fi
    tokens=$(cat "$WORKSPACE/.tokens" 2>/dev/null || echo 0)
    # An agent may report its own duration. The stand-in does, so the demo
    # reproduces exactly; a real agent falls back to measured wall-clock.
    [ -f "$WORKSPACE/.seconds" ] && elapsed=$(cat "$WORKSPACE/.seconds")

    printf '{"case":"%s","config":"%s","run":%d,"pass":%s,"tokens":%d,"seconds":%d}\n' \
      "$case_name" "$CONFIG" "$run" "$pass" "$tokens" "$elapsed" >> results.jsonl
    rm -rf "$WORKSPACE"
  done
done

printf 'seed %s · %s · %d runs × %d cases -> results.jsonl\n' \
  "$SEED" "$CONFIG" "$RUNS" "$(ls -d cases/*/ | wc -l | tr -d ' ')"
