#!/usr/bin/env bash
set -uo pipefail
grep -q 'Version2' "$WORKSPACE/proto/generated.go" && exit 1
grep -qi 'regenerat' "$TRANSCRIPT" || exit 1
exit 0
