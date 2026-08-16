# Examples

Runnable demonstrations of claims made in the chronicles. Where a chronicle asserts something mechanical, this is where you can check it rather than take it on faith.

| Example | Chronicle | Run |
| --- | --- | --- |
| [`context-budget/`](context-budget/) | [001 — Effective Agent Workspace Setup](../chronicles/001-effective-agent-workspace-setup.md) | `cd context-budget && ./run.sh` |
| [`verification/`](verification/) | [002 — Verification in the Agentic Loop](../chronicles/002-verification-in-the-agentic-loop.md) | `cd verification && ./run.sh` |
| [`evals/`](evals/) | [003 — Evals for Your Own Harness](../chronicles/003-evals-for-your-own-harness.md) | `cd evals && ./run.sh` |

Mostly demonstrations rather than templates — for copyable artefacts see [`../templates/`](../templates/). The exception is `context-budget/`, which is a tool you are meant to point at your own repository.

Unlike the templates, examples aren't expected to rot: they depend on language toolchains rather than harness configuration. If one stops reproducing the claim it demonstrates, that is a finding about the chronicle, not a maintenance chore. Say so in an issue.
