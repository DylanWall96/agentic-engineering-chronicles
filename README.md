# Agentic Engineering Chronicles

> Working notes on getting the most out of AI coding agents. Principles and patterns over feature lists.

An evergreen collection on **agentic software engineering**: what has held up across model generations, kept deliberately generic so it ages well as tools, version numbers, and feature names shift underneath it.

## Chronicles

- **[001 — Effective Agent Workspace Setup](chronicles/001-effective-agent-workspace-setup.md)** — The mental model, context as a finite budget, `CLAUDE.md` and `AGENTS.md`, skills, hooks, when to reach for MCP servers and plugins, scaling from one agent to many, permissions and sandboxing, and cross-session state. Assumes nothing; start here.
- **[002 — Verification in the Agentic Loop](chronicles/002-verification-in-the-agentic-loop.md)** — Why a passing test suite is weaker evidence when an agent wrote the code, the routes agents take to green without solving the problem, held-out oracles, and what detection actually catches. Assumes 001.
- **[003 — Evals for Your Own Harness](chronicles/003-evals-for-your-own-harness.md)** — How you would know a harness change helped: why one run is no evidence, how many you actually need, golden sets, cost as a first-class metric, and why your own small suite beats a public benchmark. Assumes 001, and qualifies it.

## Run it rather than trust it

Where a chronicle makes a mechanical claim, [`examples/`](examples/) lets you check it:

```sh
cd examples/verification && ./run.sh
```

Ten seconds, and you watch a green test suite hide three real bugs in a user-creation function — duplicate accounts for the same person, and a password policy that is silently 8 characters instead of the documented 12. Every route to green in 002's taxonomy is reproduced, including the one that needs no agent at all: a failing suite reporting exit 0 because someone piped it through `tee`.

## How claims are handled

Every statement of external fact has a dated, verifiable source in [`CHANGELOG.md`](CHANGELOG.md), with vendor-published evidence flagged as such. Claims that couldn't be sourced are listed there as unsourced rather than quietly dropped — currently two.

Chronicle bodies carry no citations by design; they're meant to be read, not audited. The audit trail is the changelog.

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

The most useful contribution is a claim that doesn't hold. If an example stops reproducing what it demonstrates, or you can show a chronicle is wrong, that's worth more than an addition.

## License

[CC-BY-4.0](LICENSE).
