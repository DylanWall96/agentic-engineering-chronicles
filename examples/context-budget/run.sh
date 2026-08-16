#!/usr/bin/env bash
# Both checks, against whatever you point them at.
#
#   ./run.sh                    this repo
#   ./run.sh fixtures/bloated   a deliberately over-stuffed workspace
#   ./run.sh ~/code/your-repo   yours
set -euo pipefail
cd "$(dirname "$0")"
T=${1:-../..}
./budget.sh "$T"
./redundant.sh "$T"
