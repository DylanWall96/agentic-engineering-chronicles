#!/usr/bin/env bash
# Last verified: 2026-08-09
#
# PreToolUse hook. Blocks a small set of commands that are hard to undo.
#
# This is a backstop, not a security boundary — chronicles/001, "Hooks" and
# "Permission Modes and Sandboxing". A determined prompt injection routes
# around a pattern match. Containment (sandbox + permission rules) is the
# real control; this catches the ordinary accident.
#
# Keep the list short and specific to what would actually hurt here. A long
# list of half-remembered dangers is worse than a short list of real ones,
# because you stop reading the denials.
#
# Wire up in .claude/settings.json:
#   "hooks": {
#     "PreToolUse": [
#       { "matcher": "Bash",
#         "hooks": [{ "type": "command",
#                     "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/block-destructive.sh" }] }
#     ]
#   }

set -euo pipefail

cmd=$(jq -r '.tool_input.command // empty')
[ -z "$cmd" ] && exit 0

deny() {
  jq -n --arg reason "$1" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: $reason
    }
  }'
  exit 0
}

case "$cmd" in
  *"rm -rf /"*|*"rm -rf ~"*|*"rm -fr /"*)
    deny "Recursive delete of a root or home path. Blocked by hook." ;;
  *"git push --force"*|*"git push -f"*)
    deny "Force push. Blocked by hook — push a new commit, or ask first." ;;
  *"git reset --hard"*)
    deny "Hard reset discards uncommitted work. Blocked by hook — stash instead, or ask first." ;;
  *"DROP DATABASE"*|*"DROP TABLE"*|*"TRUNCATE "*)
    deny "Destructive SQL. Blocked by hook — migrations require review." ;;
  *"chmod 777"*)
    deny "World-writable permissions. Blocked by hook." ;;
  *"curl "*"| sh"*|*"curl "*"| bash"*|*"wget "*"| sh"*|*"wget "*"| bash"*)
    deny "Piping a downloaded script straight into a shell. Blocked by hook." ;;
esac

exit 0
