#!/usr/bin/env bash
# Demonstrates why a single run cannot tell you whether a harness change
# helped. No model calls, no network, no API keys — two configurations with
# known success rates, and the rest is sampling.
#
#   ./run.sh              reproducible, fixed seed
#   ./run.sh -seed 42     vary it
#
# Requires Go. Takes a couple of seconds.

set -euo pipefail
cd "$(dirname "$0")"
case "${1:-}" in
  --eval)    shift; exec ./eval.sh "$@" ;;
  --analyse) shift; exec ./analyse.sh "$@" ;;
esac

# A runner that cannot distinguish a build failure from a result is the
# defect this repo warns about. Check the toolchain before reporting numbers.
if ! err=$(go build ./... 2>&1); then
  printf '\n  Cannot build, so no numbers are shown — they would be meaningless.\n\n'
  printf '  %s\n\n' "$err" | head -5
  printf '  Needs Go 1.21 or later. You have: %s\n' "$(go version 2>&1)"
  printf '  The eval half needs no Go at all:  ./eval.sh --config baseline --runs 20\n\n'
  exit 1
fi

# Default: the sampling argument, as a simulation.
go run . "$@"

cat <<'TXT'

────────────────────────────────────────────────────────────────────────
That was the argument. Here it is as a working eval you can run:

    ./eval.sh --config baseline        --runs 20
    ./eval.sh --config trimmed-context --runs 20
    ./analyse.sh

Three cases, a pluggable agent, and a verdict on whether your result
means anything. Offline and deterministic by default; swap in a real
agent with agents/real.sh.example.
TXT
