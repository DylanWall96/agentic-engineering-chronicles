#!/usr/bin/env bash
# Last verified: 2026-08-09
#
# PreToolUse hook. Blocks writes to test paths while implementation is running.
#
# This is the freeze from chronicles/002, "Making Tests Hard to Game". The
# agent optimises against whatever oracle it can reach; making the oracle
# unreachable turns a probabilistic instruction into an invariant. If a test
# genuinely needs changing, the agent has to come back and ask — which is the
# conversation you wanted anyway.
#
# Toggle by touching/removing the sentinel file, so you can unfreeze for a
# task that is legitimately about the tests:
#   touch .claude/tests-frozen      # freeze on
#   rm .claude/tests-frozen         # freeze off
#
# Wire up in .claude/settings.json:
#   "hooks": {
#     "PreToolUse": [
#       { "matcher": "Edit|Write",
#         "hooks": [{ "type": "command",
#                     "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/freeze-tests.sh" }] }
#     ]
#   }

set -euo pipefail

[ -f "${CLAUDE_PROJECT_DIR:-.}/.claude/tests-frozen" ] || exit 0

file_path=$(jq -r '.tool_input.file_path // empty')
[ -z "$file_path" ] && exit 0

case "$file_path" in
  */test/*|*/tests/*|*/spec/*|*_test.*|*.test.*|*.spec.*|*/conftest.py|*/__tests__/*)
    cat <<'JSON'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "Tests are frozen during implementation. If this test is wrong, stop and say so — do not edit it to make the run pass."
  }
}
JSON
    exit 0
    ;;
esac

exit 0
