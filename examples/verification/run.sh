#!/usr/bin/env bash
# Runs every demonstration behind chronicle 002. Nothing here is a mock-up:
# each result is produced by actually running the suites.
#
#   ./run.sh
#
# Requires Go. Takes a few seconds.

set -uo pipefail
cd "$(dirname "$0")"

bar() { printf '\n\033[1m%s\033[0m\n' "$1"; }

bar "1. A fitted implementation against the suite it was given"
echo "   The agent's own evidence that it finished."
printf '   working suite  : '
go test -tags fitted . >/dev/null 2>&1 && echo "PASS — green" || echo "FAIL"

bar "2. The same implementation against a held-out suite"
echo "   Same spec. Different cases. Never visible during implementation."
go test -tags fitted -run 'TestNormalise|TestCreateUser' ./heldout/ 2>&1 \
  | grep -E "^\s+heldout_test" | sed 's/^/   /'
printf '   verdict        : '
go test -tags fitted ./heldout/ >/dev/null 2>&1 && echo "pass" || echo "FAIL — three real bugs"
echo
echo "   Duplicate accounts for one person, and a password policy that is"
echo "   silently 8 characters instead of the documented 12."

bar "3. The honest implementation against both"
printf '   working suite  : '; go test . >/dev/null 2>&1 && echo "PASS" || echo "FAIL"
printf '   held-out suite : '; go test ./heldout/ >/dev/null 2>&1 && echo "PASS" || echo "FAIL"
echo "   Correct code pays nothing for any of this."

bar "4. A property is only as strong as the inputs it samples"
go test -tags fitted -v -run Property ./heldout/ 2>&1 \
  | grep -E "^--- (PASS|FAIL)" \
  | sed -e 's/^--- PASS: /   PASS  /' -e 's/^--- FAIL: /   FAIL  /' -e 's/ (0\.00s)//'
echo
echo "   Same invariant, both times. The stock generator produces arbitrary"
echo "   runes, which essentially never carry surrounding whitespace, so it"
echo "   ran 500 cases straight past the bug."

bar "5. Every route to green in the taxonomy, reproduced"
printf '   %-14s %-16s %s\n' "CHEAT" "VISIBLE SUITE" "HELD-OUT PROBE"
for d in hardcode fixtures specialcase weaken mock swallow skip; do
  v=$(go test -run Visible ./cheats/$d/ >/dev/null 2>&1 && echo "PASS (green)" || echo "FAIL")
  p=$(go test -run Probe   ./cheats/$d/ >/dev/null 2>&1 && echo "FAIL - caught" || echo "FAIL - caught")
  go test -run Probe ./cheats/$d/ >/dev/null 2>&1 && p="pass (missed)"
  printf '   %-14s %-16s %s\n' "$d" "$v" "$p"
done

bar "6. The eighth route: an exit code nobody checked"
go test ./cheats/hardcode/ -run Probe >/dev/null 2>&1
echo "   go test          exit $?"
# This script runs with pipefail on, so turn it off to show the default shell
# behaviour a CI script gets.
(set +o pipefail; go test ./cheats/hardcode/ -run Probe 2>&1 | tee /dev/null >/dev/null)
echo "   go test | tee    exit $?   <- failing suite reports success"
(set -o pipefail; go test ./cheats/hardcode/ -run Probe 2>&1 | tee /dev/null >/dev/null)
echo "   + pipefail       exit $?"
echo
echo "   No cheating required. Most CI scripts are one 'set -o pipefail'"
echo "   away from this."

bar "Reading"
echo "   ../../chronicles/002-verification-in-the-agentic-loop.md"
echo
