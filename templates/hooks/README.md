# Hooks

Last verified: 2026-08-09. Event names, config shape, and the deny-response format were checked against the harness documentation on that date.

**Read each script before installing it.** A hook runs on your machine on every matching turn, with whatever permissions you give it. These are short on purpose so that reading them is quick.

Why hooks rather than instructions in a context file: [chronicle 001](../../chronicles/001-effective-agent-workspace-setup.md), *Hooks*. Short version — anything you're tempted to write as "never do X" or "always do Y" can be forgotten under context pressure, or dropped entirely by compaction. A hook can't be talked out of it.

## What's here

| Script | Event | Does |
| --- | --- | --- |
| `format-after-write.sh` | `PostToolUse` | Runs the formatter on a file the moment it's written. Advisory — never blocks. |
| `freeze-tests.sh` | `PreToolUse` | Denies writes to test paths while implementation is running. Toggled by a sentinel file. |
| `block-destructive.sh` | `PreToolUse` | Denies a short list of hard-to-undo commands. |

## Install

Copy into `.claude/hooks/`, make them executable, and wire them up in `.claude/settings.json` — see [`../settings/`](../settings/) for a complete file.

```sh
mkdir -p .claude/hooks
cp templates/hooks/*.sh .claude/hooks/
chmod +x .claude/hooks/*.sh
```

Each script carries its own settings block in a header comment.

## Freezing tests

`freeze-tests.sh` only fires when a sentinel file exists, so you can unfreeze for work that is legitimately about the tests:

```sh
touch .claude/tests-frozen    # freeze on
rm .claude/tests-frozen       # freeze off
```

Frozen, an attempt to edit a test path is denied with a reason the agent can act on:

```
Edit user_test.go  ->  DENY: Tests are frozen during implementation.
                             If this test is wrong, stop and say so.
Edit user.go       ->  allowed
```

The reasoning, and a runnable demonstration of what it prevents, are in [chronicle 002](../../chronicles/002-verification-in-the-agentic-loop.md) and [`examples/verification/`](../../examples/verification/).

## Mechanics worth knowing

- Hooks receive JSON on **stdin**. `.tool_input.file_path` for file tools, `.tool_input.command` for Bash. These scripts use `jq`.
- To deny, print a `hookSpecificOutput` object with `permissionDecision: "deny"` and a reason. Exit code **2** also blocks.
- Exit **0** with no output allows the call. All three scripts stay silent unless they have something to say.
- `matcher` filters by tool name and accepts alternation (`Edit|Write`) or `*`.
- `${CLAUDE_PROJECT_DIR}` resolves to the project root — use it rather than a relative path.

## Limits

Hooks are not a security boundary. A determined prompt injection can route around a pattern match, and `block-destructive.sh` in particular is a backstop for the ordinary accident, not a control. Containment — sandboxing plus deny rules — is the real boundary. Keep the deny list short and specific to what would actually hurt in your project; a long list of half-remembered dangers is worse than a short list of real ones, because you stop reading the denials.
