# Settings

Last verified: 2026-08-09. Key names checked against the harness documentation on that date — see the verification note at the bottom.

`settings.json` carries no comments, because a settings file that fails to parse is worse than no template at all. The annotations live here instead. Copy it to `.claude/settings.json` and cut what doesn't apply; the deny rules are the part worth keeping.

The posture is containment over supervision — constrain what the agent *can* do rather than reviewing each thing it *does*. Reasoning in [chronicle 001](../../chronicles/001-effective-agent-workspace-setup.md), *Permission Modes and Sandboxing*.

## permissions

| Key | Note |
| --- | --- |
| `defaultMode` | `"auto"` routes tool calls through the classifier instead of prompting on each one. `"ask"` prompts. Deny rules are respected regardless of mode. |
| `allow` | Routine commands you never want to think about. Keep it short — it's a convenience list, not a security control. |
| `deny` | The part that matters. Credentials and history-rewriting commands. Deny always wins. |
| `ask` | Forces a prompt even under `auto`. `Bash(dangerouslyDisableSandbox:true)` catches the sandbox escape hatch being used. |

## sandbox

Sandboxed commands write only to the working directory and the session temp directory unless you widen it.

| Key | Note |
| --- | --- |
| `enabled` | OS-level isolation for Bash. macOS uses Seatbelt; Linux and WSL2 need two extra packages. |
| `allowUnsandboxedCommands` | `false` is strict mode — the unsandboxed retry path is ignored entirely. Set `true` if too many legitimate commands fail, accepting that they fall back to the regular permission flow. |
| `filesystem.allowWrite` | Add paths only when a real toolchain needs them (`~/.kube`, a build cache). |
| `filesystem.denyRead` / `allowRead` | The more specific path wins, and an exact deny holds inside a wider allow — so a broad allow can't silently re-expose a secret. |
| `network.allowedDomains` | Egress allowlist. Start narrow; the agent prompts the first time it needs a new domain. |
| `credentials.files` / `envVars` | `deny` removes the value entirely, which breaks tools that need it. `mode: "mask"` shows a sentinel and swaps the real value in on requests to hosts you list under `injectHosts`, so authenticating tools keep working. |

There is no built-in credential deny list — only what you list is restricted.

## hooks

Scripts live in `.claude/hooks/`. Copy them from [`../hooks/`](../hooks/) and **read them before installing** — they run on your machine on every matching turn.

`${CLAUDE_PROJECT_DIR}` resolves to the project root. `matcher` filters by tool name and accepts alternation (`Edit|Write`) or `*`.

## Verification note

Checked against the harness documentation on 2026-08-09: hook event names and config shape, `permissionDecision` values, hook stdin fields, `permissions.*` keys, and every `sandbox.*` key above.

Not verified: the complete list of `defaultMode` values. Only `ask` and `auto` were confirmed in the documentation consulted, and `auto` is what this template uses. If you want a different mode, check the current docs rather than trusting a value you remember.
