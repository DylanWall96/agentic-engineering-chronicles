# Agentic Engineering Chronicles

> Working notes on getting the most out of AI coding agents. Principles and patterns over feature lists.

An evergreen collection on **agentic software engineering**: what has held up across model generations, kept deliberately generic so it ages well as tools, version numbers, and feature names shift underneath it.

## Chronicles

- **[001 — Effective Agent Workspace Setup](chronicles/001-effective-agent-workspace-setup.md)** — The mental model, context as a finite budget, `CLAUDE.md` and `AGENTS.md`, skills, hooks, when to reach for MCP servers and plugins, scaling from one agent to many, permissions and sandboxing, and cross-session state. Assumes nothing; start here.
- **[002 — Verification in the Agentic Loop](chronicles/002-verification-in-the-agentic-loop.md)** — Why a passing test suite is weaker evidence when an agent wrote the code, the routes agents take to green without solving the problem, held-out oracles, and what detection actually catches. Assumes 001.

## Install as a skill

The chronicles are readable on their own, but `SKILL.md` lets an agent route to the relevant section and apply it to the workspace in front of it:

```sh
git clone https://github.com/DylanWall96/agentic-engineering-chronicles.git \
  ~/.claude/skills/agentic-engineering-chronicles
```

It triggers on setup, context, and verification work — reviewing a context file, deciding whether to add an MCP server, or setting up tests for agent-written code.

## Templates

[`templates/`](templates/) holds copyable starting artefacts: context files, hooks, and a permissions and sandboxing configuration. **They target current tooling, carry a last-verified date, and are expected to rot.** The chronicles are the durable part; where the two disagree, trust the chronicle and check the harness's own documentation.

## Contributing

Pull requests welcome for principles that have held across multiple model generations, or patterns with concrete adoption behind them. Speculation, marketing claims, and untested wisdom belong in [Discussions](../../discussions), not the chronicles.

Claims asserting external facts need a dated, verifiable source in [`CHANGELOG.md`](CHANGELOG.md). Chronicle bodies carry no citations by design.

## License

[CC-BY-4.0](LICENSE).
