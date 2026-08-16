#!/usr/bin/env bash
# 001 says: don't put anything in a context file that the agent can recover
# cheaply with find and grep. This checks that line by line.
#
#   ./redundant.sh [path]     defaults to the repo this lives in
#   ./redundant.sh fixtures/bloated
#
# It proposes. It does not edit anything, and it is a heuristic — a line can
# look recoverable and still be worth keeping. Read before cutting.
set -euo pipefail
cd "$(dirname "$0")"
TARGET=${1:-../..}
cd "$TARGET"

FILE=""
for f in CLAUDE.md AGENTS.md; do [ -f "$f" ] && { FILE=$f; break; }; done
[ -n "$FILE" ] || { echo "no CLAUDE.md or AGENTS.md in $(pwd)" >&2; exit 1; }

printf '\nChecking %s/%s\n\n' "$(pwd)" "$FILE"
flagged=0; kept=0

while IFS= read -r line; do
  [ -z "${line// }" ] && continue
  case "$line" in \#*|'```'*) continue ;; esac

  why=""
  # A directory listing the agent can produce itself.
  if printf '%s' "$line" | grep -qE '^[[:space:]]*[-*][[:space:]]+`?[a-z_]+/`?[[:space:]]+' ; then
    d=$(printf '%s' "$line" | sed -E 's/^[[:space:]]*[-*][[:space:]]+`?([a-z_]+)\/`?.*/\1/')
    [ -d "$d" ] && why="ls -d */"
  fi
  # A dependency list that is already in a manifest.
  if [ -z "$why" ] && printf '%s' "$line" | grep -qE '(express|jest|eslint|typescript|prettier|react|pytest|django)' \
     && ls package.json pyproject.toml go.mod Cargo.toml >/dev/null 2>&1; then
    why="cat package.json"
  fi
  # Code style — a linter's job, per 001.
  if [ -z "$why" ] && printf '%s' "$line" | grep -qiE 'indent|semicolon|single quotes|double quotes|line length|camelCase|PascalCase|spaces.*tabs|prefer const'; then
    why="the linter"
  fi
  # General language knowledge the model already has.
  if [ -z "$why" ] && printf '%s' "$line" | grep -qiE 'javascript runtime|event-driven|callback hell|async/await|strict equality|avoid global|promises'; then
    why="already known"
  fi

  if [ -n "$why" ]; then
    flagged=$((flagged+1))
    printf '  CUT  %-58s  -> %s\n' "$(printf '%s' "$line" | cut -c1-58)" "$why"
  else
    kept=$((kept+1))
  fi
done < "$FILE"

total=$((flagged+kept))
printf '\n  %d of %d content lines look recoverable (%d%%).\n' \
  "$flagged" "$total" "$(( total ? flagged*100/total : 0 ))"
printf '  Recoverable means the agent could find it itself, so you are paying\n'
printf '  for it on every turn to save it one command.\n\n'
printf '  Heuristic, not a verdict. Check each before cutting.\n\n'
