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
exec go run . "$@"
