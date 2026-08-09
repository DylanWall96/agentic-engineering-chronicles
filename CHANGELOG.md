# Changelog

## [Unreleased]

### 2026-08-09 — Chronicle 001 v4

Changed:
- MCP section: retired the context-budget argument for restraint. Progressive tool loading has largely dissolved it; the case is now accuracy and blast radius
- Permission modes: reframed around *containment over supervision*, with measured approval rates as the reason prompts stopped being a real control, plus a sandbox-escape caveat
- AGENTS.md: promoted from fallback to cross-tool standard, with Claude Code named as the exception
- Code Mode: from "expect this to evolve toward" to "already shipping by default", scoped as an escape hatch rather than the front door
- Quick Reference: replaced the tool-bloat and sandbox rows to match

Added:
- Auto-compaction as a genuine safety net — a floor, not a strategy
- Built-in memory as complementary to version-controlled artefacts: convenient, but opaque and unreviewable
- Inter-agent coordination channels — advisory, not a lock, contract, or merge queue
- Multi-agent: token spend accounts for most of the measured single-vs-multi gap
- Hooks survive compaction; instructions may not
- Long-context degradation holds regardless of where the evidence sits in the window

### 2026-05-12 — Chronicle 001 v3

Added:
- Mental model: "match the model to the task" — tiered model usage by task complexity
- Scaling: model-tier-per-subagent guidance
- Quick Reference row for model-tier matching

### 2026-05-09 — Chronicle 001 v2

Added:
- Mental model: "don't fix a context problem by switching models"
- Hooks section as the deterministic enforcement layer
- Cross-Session State section covering the persistent-Markdown-directory pattern
- Skills security trust hierarchy (mirrors plugins)
- Quick Reference entries for hooks, skills-as-third-party-code, persistence, and context-over-model

Changed:
- Sharpened phrasing throughout, removed appeals to authority
- Promoted thoughts/ pattern from a workflow bullet to a full section

### Initial commit
- Initial chronicle: Effective Claude Code Setup
- Repo structure: README as index, chronicles/ for individual entries
- CC-BY-4.0 license

## Sources informing the current draft

- Anthropic Engineering — context engineering, harness design, agent skills, multi-agent systems, code execution with MCP
- Claude Code documentation — progressive tool loading, sandboxing, permission modes, memory
- HumanLayer blog — CLAUDE.md authoring, advanced context engineering
- GitHub — AGENTS.md large-repo analysis; agents.md adoption under vendor-neutral governance
- Independent research on long-context degradation
- Published vulnerability reports on agent sandbox escapes across vendors
- Measured comparisons of multi-agent vs single-agent performance controlling for token spend
