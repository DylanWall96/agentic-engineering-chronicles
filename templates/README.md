# Templates

Last verified: 2026-08-09

Copyable starting artefacts. **These target current tooling and are expected to rot.** Setting names, hook event names, and flags change; the chronicles do not. If a template and a chronicle disagree, the chronicle is the durable part and the template is the stale part.

Verify anything here against your harness's own documentation before relying on it.

## What's here

| File | Purpose | Chronicle |
| --- | --- | --- |
| `CLAUDE.md` | Annotated context-file starter. Delete more than you add. | [001](../chronicles/001-effective-agent-workspace-setup.md) — *CLAUDE.md and AGENTS.md* |
| `AGENTS.md` | The universal-rules version, for mixed-tool teams. | [001](../chronicles/001-effective-agent-workspace-setup.md) — *CLAUDE.md and AGENTS.md* |
| [`hooks/`](hooks/) | Deterministic enforcement: format, freeze tests, block destructive commands. | [001](../chronicles/001-effective-agent-workspace-setup.md) — *Hooks*; [002](../chronicles/002-verification-in-the-agentic-loop.md) — *Making Tests Hard to Game* |
| `settings/settings.json` | Permissions and sandboxing reflecting the containment posture. | [001](../chronicles/001-effective-agent-workspace-setup.md) — *Permission Modes and Sandboxing* |

## How to use them

Copy, then cut. A template you delete from is better than one you add to — every line you keep costs adherence elsewhere, which is the whole argument of 001.

The hooks are shell scripts. Read them before installing them; they run on your machine on every matching turn.
