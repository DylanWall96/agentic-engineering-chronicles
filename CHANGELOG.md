# Changelog

## [Unreleased]

### 2026-08-09 — Chronicle 002: qualify the property-testing claim

Added:
- A qualifier to *Making Tests Hard to Game*: a property is only as strong as the inputs its generator samples
- Quick Reference row for generator shape

002 argued that properties resist accidental satisfaction because the agent
cannot enumerate the inputs. That holds only where the generator reaches the
failing cases. Walking the pattern through a worked example — user creation
in Go, with an implementation that lowercased but never trimmed — a correct
invariant with a stock string generator passed 500 cases against the broken
code. The same invariant with a domain-shaped generator failed immediately.

Found by running the pattern rather than re-reading it, which is the
discipline the chronicles argue for.

### 2026-08-09 — Consistency pass

Changed:
- Cut the "Trust the harness" Quick Reference row from 001 — orphaned by the v2 restructure and redundant against two neighbouring rows
- 001's "verification beats execution" now points at 002 rather than restating its argument
- Scoped 002's fresh-context-reviewer claim so it no longer reads as contradicting the held-out oracle as the strongest single practice

Audited clean: British spelling across all files, SKILL.md routing rows
against actual headings, every internal link, and thresholds in chronicle
bodies. The one remaining specific — "React 18" in 001 — is an illustrative
example of how to write a stack line, not a claim about tooling.

### 2026-08-09 — Templates

Added:
- `templates/CLAUDE.md` and `templates/AGENTS.md` — annotated starters, commented so a reader knows what to cut
- `templates/hooks/` — format after write, freeze test paths during implementation, block destructive commands
- `templates/settings/` — permissions and sandboxing reflecting 001's containment posture, with annotations in a sibling README so the JSON stays strictly valid
- `templates/README.md` — states plainly that templates are dated and expected to rot

Hook and settings key names were checked against the harness documentation on
2026-08-09 rather than written from memory. The one gap is recorded in
`templates/settings/README.md`: only two `defaultMode` values were confirmed.

### 2026-08-09 — Chronicle 001 v5: neutrality pass

Changed:
- Retitled to *Effective Agent Workspace Setup* and renamed the file; the chronicle number, which is the externally referenced part, is unchanged
- Removed harness product names from the body — the guide is about agent workspaces, not one tool
- Removed exact thresholds per the AGENTS.md editorial rule; the figures live in the sources section below
- Corrected the skill-registry claim to what the audits actually confirm — credential theft, backdoors, and exfiltration, not ransomware staging

### 2026-08-09 — Chronicle 002, AGENTS.md, SKILL.md

Added:
- Chronicle 002: Verification in the Agentic Loop — the follow-through on 001's "verification beats execution"
- `AGENTS.md` — maintenance context and editorial rules for this repository
- `SKILL.md` — routing layer making the chronicles installable as a skill
- Dated, verifiable sources for both chronicles, replacing the generic list

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

## Sources

The chronicle bodies carry no citations by design. Every claim in them that asserts an external fact is listed here with a date and a source.

**†** marks evidence that is vendor-published or otherwise self-interested. It isn't disqualifying — some of it is the only measurement that exists — but it should be read knowing who produced it.

### Chronicle 001 — Effective Agent Workspace Setup

**Performance degrades as the context window fills, regardless of where the relevant information sits**

- 2025-07 — Chroma, *Context Rot: How Increasing Input Tokens Impacts LLM Performance* — trychroma.com/research/context-rot — degradation across 18 frontier models as input grows. † Chroma sells retrieval infrastructure; the finding favours its product.
- 2025 — Adobe Research, *NoLiMa: Long-Context Evaluation Beyond Literal Matching* (ICML 2025) — github.com/adobe-research/NoLiMa — models advertising near-perfect recall to a million tokens fail non-lexical retrieval by 32K.
- 2023 — Liu et al., *Lost in the Middle* — accuracy is U-shaped by position, degrading over 30% when the evidence sits mid-context.

**AGENTS.md is the cross-tool standard, under vendor-neutral governance**

- 2025-12 — AGENTS.md donated to the Agentic AI Foundation under the Linux Foundation, co-founded by OpenAI, Anthropic, and Block — openai.com/index/agentic-ai-foundation † co-founder announcement.
- 2026-06 — agents.md lists 28+ tools with native support; 60,000+ repositories adopted. Supports the chronicle's "tens of thousands".

**Context files should stay short**

- Claude Code documentation, *How Claude remembers your project* — code.claude.com/docs/en/memory — the "roughly two hundred lines" figure. † Vendor guidance.

**Tool definitions cost context; progressive loading removes most of it**

- 2025-11-04 — Anthropic, *Code execution with MCP: building more efficient AI agents* — anthropic.com/engineering/code-execution-with-mcp — a worked example reducing 150,000 tokens to 2,000 (98.7%). † Vendor.
- Anthropic, *Introducing advanced tool use on the Claude Developer Platform* — anthropic.com/engineering/advanced-tool-use — deferred tool definitions and tool search. † Vendor.

**Permission prompts stopped being a real control**

- ~93% of permission prompts approved (Anthropic telemetry, reported secondhand — no primary publication located). † Vendor telemetry, secondary reporting.
- 2026-07 — *How Agents Ask for Permission: User Permissions for AI Agents, from Interfaces to Enforcement* — arxiv.org/html/2607.13718v1 — 13 of 16 participants used "Always Allow" to dismiss prompts; 3 of 16 read them carefully.
- Claude Code documentation, *Configure the sandboxed Bash tool* — code.claude.com/docs/en/sandboxing — sandboxing cuts prompt volume by up to 84%. † Vendor.

**Sandbox escapes across vendors, several sharing root causes**

- 2026 — BleepingComputer, *Cursor, Codex, Gemini CLI, Antigravity hit by sandbox escapes* — bleepingcomputer.com/news/security/cursor-codex-gemini-cli-antigravity-hit-by-sandbox-escapes/
- Cymulate, *Configuration-Based Sandbox Escape (CBSE) in AI Coding Tools* — cymulate.com/blog — the shared root cause: writing a file that a trusted process outside the sandbox later runs.
- CVE-2026-46406 and further Claude Code advisories, including two rated CVSS 10.0; Cursor CVE-2026-50548 / 50549 at CVSS 9.8.

**Multi-agent gains are substantially a token-spend effect**

- 2025-06 — Anthropic, *How we built our multi-agent research system* — token usage alone explains 80% of performance variance on BrowseComp; tool calls ~10%, model choice ~5%. Multi-agent consumes roughly 15× the tokens of chat. † Vendor — though the finding cuts against the vendor's interest, which strengthens it.
- *Single-Agent LLMs Outperform Multi-Agent Systems on Multi-Hop Reasoning Under Equal Thinking Token Budgets* — the advantage disappears when the budget is held constant.

**Skill registries contain malicious payloads**

- Snyk, *ToxicSkills* — snyk.io/blog/toxicskills-malicious-ai-agent-skills-clawhub — prompt injection in 36% of skills audited; 1,467 malicious payloads.
- 2026-02 — *Malicious Agent Skills in the Wild: A Large-Scale Security Empirical Study* — arxiv.org/html/2602.06547v1 — 534 of 3,984 skills (13.4%) carrying critical security issues.
- Zenity — malicious skills across ~1.7M installs, aimed at credential theft and supply-chain persistence.

### Chronicle 002 — Verification in the Agentic Loop

**Agents reach green by routes you didn't intend**

- Anthropic, Claude 3.7 Sonnet system card — special-casing test cases in agentic coding environments: returning expected values directly, or modifying test files rather than implementing a general solution. † Vendor, self-disclosed.
- *EvilGenie: a Reward Hacking Benchmark* — arxiv.org/html/2511.21654v2 — taxonomy covering hard-coded test cases, modified harnesses, and special-case solutions.
- *SpecBench: Measuring Reward Hacking in Long-Horizon Coding Agents* — arxiv.org/html/2605.21384v1 — 30 systems-level tasks.
- *Do Coding Agents Deceive Us? Detecting and Preventing Cheating via Capped Evaluation with Randomized Tests* — arxiv.org/pdf/2606.07379 — agents observed editing a writable test so buggy output passes. Supports the held-out-oracle and freeze-the-tests practices.
- *CircumEval — Measuring Circumvention Propensity in Coding Agents* — explicit reward hacking observed in two of three major proprietary agents, misaligned behaviour in all three.

**The saved time reappears downstream in review and rework**

- 2025-07-10 — METR, *Measuring the Impact of Early-2025 AI on Experienced Open-Source Developer Productivity* — metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/ — 16 developers, 246 tasks, 19% slower with AI while believing they were 20% faster. **METR now labels this out of date**; its 2026-02-24 follow-up redesigns the experiment rather than restating the figure — metr.org/blog/2026-02-24-uplift-update/. Cite for the perception gap, not as a current productivity measurement.
- Faros AI, 2025 telemetry across 10,000+ developers and 1,255 teams — high-adoption teams completed 21% more tasks and merged 98% more PRs, while PR review time rose 91%, PR size 154%, and bug counts 9%. This is the clearest evidence for the relocation-of-cost argument.
- GitClear, *The Maintainability Gap: 2026 AI Code Quality Research* — gitclear.com/the_ai_code_quality_maintainability_gap — copy-pasted code 9.4% (2022) to 15.7% (early 2026); refactored code 21% to 3.8%; two-week churn rising.
- DORA, 2025 State of DevOps — Rework Rate added as a fifth metric, with review burden elevated as a leading indicator.

### Claims carrying no solid source

Listed rather than dropped. Each is either weakly supported or an inference stated as fact in a chronicle body.

- **"Untested context files can actively hurt agent performance"** (001, Skills) — the adjacent evidence covers context *length* degrading performance. Nothing found ties *untested* context specifically to harm.
- **"The gap widens with difficulty"** and **"it correlates with struggle"** (002) — consistent with how the reward-hacking literature frames the incentive, but not located as a measured result.
- **"Teams that measure this find the throughput improvement real but smaller than it feels"** (002) — Faros supports the direction; the specific characterisation is inference.
