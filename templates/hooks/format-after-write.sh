#!/usr/bin/env bash
# Last verified: 2026-08-09
#
# PostToolUse hook. Formats and lints a file the moment the agent writes it.
#
# Why a hook and not a context-file rule: chronicles/001, "Hooks".
# Short version — never send a model to do a linter's job, and never trust
# an instruction to survive compaction.
#
# Wire up in .claude/settings.json:
#   "hooks": {
#     "PostToolUse": [
#       { "matcher": "Edit|Write",
#         "hooks": [{ "type": "command",
#                     "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/format-after-write.sh" }] }
#     ]
#   }

set -euo pipefail

# Hook input arrives as JSON on stdin.
file_path=$(jq -r '.tool_input.file_path // empty')
[ -z "$file_path" ] && exit 0
[ -f "$file_path" ] || exit 0

case "$file_path" in
  *.ts|*.tsx|*.js|*.jsx|*.json|*.css|*.md)
    command -v prettier >/dev/null && prettier --write "$file_path" >/dev/null 2>&1
    ;;
  *.py)
    command -v ruff >/dev/null && ruff format "$file_path" >/dev/null 2>&1
    ;;
  *.go)
    command -v gofmt >/dev/null && gofmt -w "$file_path" >/dev/null 2>&1
    ;;
  *.rs)
    command -v rustfmt >/dev/null && rustfmt "$file_path" >/dev/null 2>&1
    ;;
esac

# Exit 0: formatting is advisory, never blocks the write.
exit 0
