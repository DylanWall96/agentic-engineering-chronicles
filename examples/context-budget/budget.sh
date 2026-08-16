#!/usr/bin/env bash
# Where your context window goes before any work begins.
#
#   ./budget.sh [path]        defaults to the repo this lives in
#   ./budget.sh fixtures/bloated
#
# No network, no model calls. Reads files and counts.
set -euo pipefail
cd "$(dirname "$0")"
TARGET=${1:-../..}
WINDOW=${WINDOW:-200000}

tok() { [ -f "$1" ] || { echo 0; return; }; echo $(( ($(wc -c < "$1") + 3) / 4 )); }
tok_dir() { local t=0 f; while IFS= read -r f; do t=$(( t + $(tok "$f") )); done < <(find "$1" -type f -name "$2" 2>/dev/null); echo "$t"; }

row() { printf '%-34s %8s   %6s%s\n' "$1" "$2" "$3" "${4:+   $4}"; }
pct() { awk -v a="$1" -v b="$WINDOW" 'BEGIN{printf "%.1f%%", a*100/b}'; }

printf '\nContext budget for %s\n' "$(cd "$TARGET" && pwd)"
printf 'Window assumed: %s tokens. Estimates are characters/4 — see README.\n\n' "$WINDOW"
printf '%-34s %8s   %6s   %s\n' "COMPONENT" "TOKENS" "SHARE" "NOTE"
printf '%-34s %8s   %6s   %s\n' "---------" "------" "-----" "----"

standing=0
for f in AGENTS.md CLAUDE.md; do
  n=$(tok "$TARGET/$f"); [ "$n" -eq 0 ] && continue
  standing=$(( standing + n )); row "$f" "$n" "$(pct "$n")" "every turn"
done

# Skills: descriptions are always resident, bodies load on invocation.
desc=0; body=0
while IFS= read -r sk; do
  full=$(tok "$sk")
  # frontmatter (name + description) is resident; everything after it is not
  head=$(awk 'NR==1&&/^---$/{f=1;next} f&&/^---$/{exit} f{c+=length($0)+1} END{printf "%d",(c+3)/4}' "$sk")
  desc=$(( desc + head )); body=$(( body + full - head ))
done < <(find "$TARGET/.claude/skills" "$TARGET/skills" "$TARGET" -maxdepth 3 -name SKILL.md 2>/dev/null | sort -u)
if [ "$desc" -gt 0 ]; then
  standing=$(( standing + desc ))
  row "skill descriptions" "$desc" "$(pct "$desc")" "every turn"
  row "skill bodies" "$body" "-" "on invocation only"
fi

# MCP servers. The config is cheap; the tool definitions it pulls in are not,
# and their size cannot be read off disk — only the harness knows it.
servers=0
for cfg in "$TARGET/.mcp.json" "$TARGET/.claude/settings.json" "$TARGET/.claude/settings.local.json"; do
  [ -f "$cfg" ] || continue
  # grep exits 1 when it matches nothing, which with pipefail+set -e would
  # kill the script on any repo that has no MCP servers configured.
  n=$( { grep -o '"command"' "$cfg" 2>/dev/null || true; } | wc -l | tr -d ' ')
  servers=$(( servers + ${n:-0} ))
done
if [ "$servers" -gt 0 ]; then
  row "MCP tool definitions" "?" "  ?" "$servers server(s) — see note"
fi

printf '%-34s %8s   %6s\n' "" "------" "-----"
row "STANDING COST PER TURN" "$standing" "$(pct "$standing")"
printf '\n'
awk -v s="$standing" -v w="$WINDOW" 'BEGIN{
  r = s*100/w
  if (r > 20) print "  A fifth of the window is gone before the agent reads a line of code."
  else if (r > 5) print "  Reasonable. Every line here is still paid on every turn, forever."
  else print "  Lean. The budget is going to the work, which is the point."
}'
printf '  Skill bodies: %s tokens costing nothing until used. That ratio is what\n' "$body"
printf '  progressive disclosure buys you.\n'
if [ "$servers" -gt 0 ]; then
  printf '\n  %s MCP server(s) configured. Their tool definitions are the largest line\n' "$servers"
  printf '  item in most setups and cannot be read off disk — ask your harness what it\n'
  printf '  is loading, and whether deferral is on.\n'
fi
printf '\n'
