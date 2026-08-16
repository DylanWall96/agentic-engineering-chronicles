---
name: agentic-engineering-chronicles
description: Set up, review, or improve an agent workspace — CLAUDE.md and AGENTS.md, skills, hooks, permissions and sandboxing, MCP servers, cross-session state, and verification discipline. Use this skill whenever the user is starting work in a new repository, mentions onboarding an agent, asks how to configure or improve their setup, complains that the agent keeps forgetting things or making the same mistake, is deciding whether to add an MCP server or run agents in parallel, or is setting up testing for agent-written code — even if they don't explicitly ask for a workspace review.
---

# Agentic Engineering Chronicles

Working notes on getting the most out of AI coding agents. This skill routes to them and applies them to the current workspace.

## How to use this skill

Read only what the task needs. Each chronicle is self-contained prose; the templates are copyable artefacts. Don't load everything.

| If the user is... | Read |
| --- | --- |
| Setting up a new repository for agent work | `chronicles/001-effective-agent-workspace-setup.md` |
| Reviewing or trimming an existing `CLAUDE.md` / `AGENTS.md` | `chronicles/001` — *CLAUDE.md and AGENTS.md* |
| Hitting context limits, compacting often, losing state | `chronicles/001` — *Context as a Finite Budget*, *Cross-Session State* |
| Writing a skill, or wondering whether to | `chronicles/001` — *Skills* |
| Asking for a rule the agent must never break | `chronicles/001` — *Hooks* |
| Considering an MCP server or plugin | `chronicles/001` — *When to Reach Beyond the Basics* |
| Setting permissions, sandboxing, or automation flags | `chronicles/001` — *Permission Modes and Sandboxing* |
| Running subagents or parallel agents | `chronicles/001` — *Scaling: From One Agent to Many* |
| Setting up tests for agent-written code | `chronicles/002-verification-in-the-agentic-loop.md` |
| Reviewing a large agent-authored diff | `chronicles/002` — *Detection* |
| Finding that tests pass but behaviour is wrong | `chronicles/002` — *How Agents Cheat* |
| Unconvinced that any of 002 is real | `examples/verification/` — run it |
| Asking whether a harness change helped | `chronicles/003-evals-for-your-own-harness.md` |
| Comparing two setups, or two model tiers | `chronicles/003` — *The Minimum Unit of Evidence*, *Cost as a Metric* |
| Building a golden set, or scoring agent runs | `chronicles/003` — *The Golden Set*, *Scripts and Judges* |
| Citing a public benchmark to justify a choice | `chronicles/003` — *Your Own Suite and the Public Ones* |

Chronicles 002 and 003 both assume 001. If the user is starting from nothing, 001 first. 003 carries findings that qualify 001 — read the qualifier in 001's *CLAUDE.md and AGENTS.md* section alongside it.

## Applying it

When asked to set up or improve a workspace:

1. **Look before prescribing.** Read the existing context files, settings, hooks, and installed servers. Most workspaces have too much, not too little — the common fix is deletion.
2. **Ask what's actually breaking.** The chronicles are opinionated, but the opinions are responses to friction. Don't install scaffolding for friction the user hasn't hit.
3. **Start from a template, then cut.** See `templates/`. Generated starters are always too long; trim to what's specific to this project.
4. **Enforce with tooling where possible.** Anything phrased as "never do X" or "always do Y" belongs in a hook, not a context file.
5. **Say what you didn't do.** If you skipped a recommendation because it didn't fit, tell the user which and why.

## Rules

- **The chronicles are principles, not commands.** They describe what has held up across model generations. Where a principle conflicts with something specific to the user's project, the project wins — say so rather than silently overriding either.
- **Don't recite.** Apply the reasoning to the workspace in front of you. The user can read the chronicles themselves.
- **Templates rot; chronicles don't.** Anything in `templates/` targets current tooling and may be out of date. Verify against the harness's own docs before relying on a specific setting name or flag.
- **Never widen permissions or disable sandboxing to make a task easier.** If a task needs more access, stop and ask.
