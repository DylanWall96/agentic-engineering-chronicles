#!/usr/bin/env bash
# Reads results.jsonl and answers the only question that matters: given how
# many runs you did, is the difference you are looking at real?
set -euo pipefail
cd "$(dirname "$0")"
[ -s results.jsonl ] || { echo "no results.jsonl — run ./eval.sh first" >&2; exit 1; }

awk '
function n_required(p1, p2, zb,   d, num) {
  d = p2 - p1; if (d < 0) d = -d
  if (d == 0) return -1
  num = (1.96 + zb) ^ 2 * (p1 * (1 - p1) + p2 * (1 - p2))
  return int(num / (d * d)) + 1
}
{
  match($0, /"config":"[^"]*"/); cfg = substr($0, RSTART+10, RLENGTH-11)
  match($0, /"pass":[a-z]*/);    p   = substr($0, RSTART+7, RLENGTH-7)
  match($0, /"tokens":[0-9]*/);  tk  = substr($0, RSTART+9, RLENGTH-9) + 0
  runs[cfg]++; tokens[cfg] += tk; if (p == "true") passed[cfg]++
  if (!(cfg in seen)) { seen[cfg] = 1; order[++k] = cfg }
}
END {
  printf "\n%-18s %-14s %-16s %s\n", "CONFIG", "PASSED", "PASS RATE", "AVG TOKENS/RUN"
  for (i = 1; i <= k; i++) {
    c = order[i]; rate[c] = passed[c] / runs[c]
    printf "%-18s %-14s %-16s %d\n", c, passed[c] "/" runs[c], \
           sprintf("%.1f%%", rate[c] * 100), tokens[c] / runs[c]
  }
  if (k != 2) { printf "\nRun a second configuration to compare.\n"; exit }

  a = order[1]; b = order[2]
  gap = (rate[b] - rate[a]) * 100; agap = gap < 0 ? -gap : gap
  per = runs[a] < runs[b] ? runs[a] : runs[b]
  need80 = n_required(rate[a], rate[b], 0.8416)
  need90 = n_required(rate[a], rate[b], 1.2816)

  printf "\nobserved   %s is %.1f points %s, on %d runs each\n", b, agap, (gap >= 0 ? "ahead" : "behind"), per
  if (need80 < 0) { printf "verdict    identical pass rates — nothing to test\n" }
  else {
    printf "needed     %d runs each for 80%% power, %d for 90%% (alpha 0.05)\n", need80, need90
    if (per >= need80) printf "verdict    DETECTABLE — you ran enough for this gap\n"
    else printf "verdict    NOT DETECTABLE — %d runs cannot resolve %.1f points.\n           A gap this size needs %dx the runs you did.\n", per, agap, int(need80 / per + 0.5)
  }
  tgap = (tokens[b]/runs[b] - tokens[a]/runs[a]) / (tokens[a]/runs[a]) * 100
  atg = tgap < 0 ? -tgap : tgap
  printf "\ncost       %s costs %.1f%% %s per run — and unlike the pass rate,\n           that is readable off a single run.\n\n", b, atg, (tgap >= 0 ? "more" : "less")
}
' results.jsonl
