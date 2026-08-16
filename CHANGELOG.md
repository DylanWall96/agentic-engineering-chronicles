# Changelog

## [Unreleased]

### 2026-08-16 — An example for 001

Added:
- `examples/context-budget/` — `budget.sh` reports where the context window goes before any work begins; `redundant.sh` flags context-file lines the agent could have recovered itself. Bash only, no model calls
- 001's header no longer reads "Runnable — nothing yet"

001 was the last chronicle without a working example, and most of it cannot
have one: context degradation, whether a context file helps, whether
subagents beat a single agent all need model calls and many runs. What is
demonstrable is the accounting, which is the part people skip.

Unlike the other examples this is meant to be pointed at the reader's own
repository rather than watched. On this repo it reports 6% of context-file
lines as recoverable; on the bundled bloated fixture, 50%.

Two limits are stated rather than hidden. Token counts are characters/4, not
a real tokenizer, so they are honest as ratios and wrong as absolutes. And
MCP tool-definition size cannot be read off disk — the script prints `?` and
a server count instead of a number that would look authoritative and be made
up.

`redundant.sh` gets three lines of this repo's own `AGENTS.md` wrong, and the
false positives were left in and documented. The check proposes; the reader
decides.

### 2026-08-16 — A working eval, and the standard behind it

Added:
- `examples/evals/` gains the practice, not just the argument: three cases drawn from real failures, a pluggable agent, a runner writing `results.jsonl`, and `analyse.sh` returning a verdict on whether the observed gap survives the number of runs
- `AGENTS.md`: every chronicle ships a working example. Not a demonstration of the *problem* — the practice itself, runnable, with one clearly marked seam for the reader's own project

003 described a golden set, a runner, and a results format that existed
nowhere in the repo, while its example proved only that one run tells you
nothing. Correct, useful, and not the practice. Talking about a practice
without showing it is the failure this repo exists to argue against.

The default agent is a deterministic stand-in with known underlying success
rates, so the harness can be checked against an answer you never have with a
real agent. Swapping in a real one is a single script.

Found while building it: the runner recorded wall-clock, which made results
irreproducible whenever a run crossed a second boundary. It now prefers a
duration the agent reports and falls back to measured time.

### 2026-08-16 — Format pass across all three chronicles

Changed:
- 001, 002 and 003 all carry a header block (covers / assumes / runnable), reference material as tables, and the artefacts they recommend shown inline rather than only described
- 002: cheat taxonomy became a table with a third column — what catches each pattern — which did not exist anywhere before
- 001: trust hierarchy stated once instead of twice; evals precondition and review-pass line now point at 003 and 002 rather than restating them
- `AGENTS.md`: numbers a reader must act on belong in the body, and examples get built before the prose is finalised

**Note for whoever considers splitting 001.** The question was whether it is one document or two. The churn record says two: every correction since v2 has landed in *CLAUDE.md and AGENTS.md*, *When to Reach Beyond the Basics*, or *Permission Modes and Sandboxing*, while *Mental Model*, *What Makes Up the Context*, *Context as a Finite Budget*, *Scaling* and *Workflow Patterns* have gone untouched across four months, three chronicles and a full sourcing pass.

It was not split, for two reasons. The seam is not a line — *Skills*, *Hooks* and *Cross-Session State* each wrap durable argument around perishable mechanics, so a split cuts inside three sections rather than between them, making it a rewrite rather than a move. And 001's URL had already changed once that week.

If you do split it: the inlined artefacts added in this pass — the context-file skeleton, the format hook and its wiring, the state directory layout, the permission and sandbox JSON — are the natural first thing to move. They were added knowing they increase the perishable content, because they make the chronicle usable on its own.

The trigger to watch for is not simply another correction in those three sections. It is a correction that forces you to touch the durable half to keep the perishable half coherent. Until that happens, the coupling costs nothing.

### 2026-08-16 — Cohesion pass, workspace audit

Changed:
- 001 now states at the top that most of it is practitioner consensus rather than measured result, and points at 003 for telling the difference. This was the largest incoherence in the repo: 001 reads as settled practice while 003 argues most harness changes are unverified hypotheses, including 001's
- 001's "every line costs you adherence elsewhere" corrected. The factorial study found positive evidence of no effect for file size on adherence, so the mechanism was folklore. The advice survives on cost grounds and now says so
- Quick Reference row "Test your context — untested skills can hurt performance" replaced with "Verify, don't assume", since it rested on the claim retired above
- `templates/CLAUDE.md` carries the qualifier, so a reader copying the template meets the caveat rather than only the advice

Added:
- `references/workspace-audit.md` and a short SKILL.md section — assess a repository against the chronicles and report observations, never a score, grade, or checklist. Leads with what could be removed, labels absence as frequently correct rather than a gap, attributes every observation to a chronicle section, and stops rather than prescribing a setup to a repository showing no sign of agent use

### 2026-08-16 — Chronicle 003 and its example

Added:
- `chronicles/003-evals-for-your-own-harness.md` — the follow-through on 001's unkept "you have evals" precondition, scoped to evaluating the setup rather than its output
- `examples/evals/` — the run-count argument as a deterministic simulation, no model calls, seeded and reproducible
- Sources for 003, including the computed sample-size table and a note on why a published 30-runs figure was deliberately not used
- A qualifier to 001: the benefit of a context file is not automatic

Changed:
- Retired the unsourced claim about untested context files, replaced by two sourced findings that are more precise and less flattering
- Corrected 003 after the example contradicted it — identical configurations compared over five runs produce false margins in the tens of points, not "several points"

### 2026-08-09 — Faros 2026, hooks README

Changed:
- Swapped the Faros citation from the 2025 telemetry to *The AI Engineering Report 2026: The Acceleration Whiplash* — 22,000 developers and 4,000 teams over two years, against 10,000 and 1,255. Same direction, much stronger sample, and it adds the finding that deployments per week fall while task throughput rises
- Downgraded one unsourced claim to largely-supported: Faros carries "real but smaller", but "than it feels" still needs a current perception measurement

Added:
- A paragraph to 002's *The Cost, Honestly* on the second-order failure — when review becomes the bottleneck, review is what gets skipped
- `templates/hooks/README.md`, matching `templates/settings/`, covering install, the freeze sentinel, hook mechanics, and the limits of hooks as a control

### 2026-08-09 — Runnable examples

Added:
- `examples/verification/` — every mechanical claim in 002 as executable Go, with `run.sh` producing the whole demonstration in about ten seconds
- `examples/README.md` — examples are for checking, not copying, and unlike templates are not expected to rot
- README sections surfacing the examples and the sourcing discipline, which were previously only visible to someone who opened this file

The chronicles argue that observed behaviour beats assertion. Until now the
repo asked to be taken on faith. Results, all reproduced rather than written
by hand: a fitted implementation passing its working suite and failing a
held-out suite three ways; all seven cheat patterns producing genuinely green
suites; and a failing suite reporting exit 0 through a pipe.

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

### Chronicle 003 — Evals for Your Own Harness

**Context files do not generally improve task success, and cost more**

- 2026-02-12 (v1), revised 2026-06-23 — Gloaguen, Mündler, Müller, Raychev, Vechev, *Evaluating AGENTS.md: Are Repository-Level Context Files Helpful for Coding Agents?* — arxiv.org/abs/2602.11988 — SWE-bench tasks with generated context files, plus a new collection of issues from repositories carrying developer-committed ones. Verbatim from the abstract: "providing context files does not generally improve task success rates, while increasing inference cost by over 20% on average."
  - **Excluded deliberately:** secondary write-ups report a per-variant split of roughly +4% for developer-written files and −3% for generated ones. That split is not in the abstract, which reports the finding undifferentiated, and the PDF body could not be read to confirm it. A number that cannot be checked in the primary should not carry a claim, so the body states only the general finding.

**Context-file structure does not detectably affect instruction adherence**

- 2026-05-11 — McMillan, *Instruction Adherence in Coding Agent Configuration Files: A Factorial Study of Four File-Structure Variables* — arxiv.org/abs/2605.10039 — 1,650 agent sessions, 16,050 function-level observations, two codebases, three models. Varied file size, instruction position, file architecture, and contradictions between adjacent files. None of the four, and none of the three two-way interactions, produced a detectable contrast after multiple-testing correction. Size and conflict nulls carry affirmative-null Bayes factors (BF10 0.05–0.10) — positive evidence of no effect rather than a failure to reject.
  - Largest effect measured was within-session: roughly 5.6% lower odds of compliance per additional function generated (OR 0.944), non-monotonic, identified during analysis rather than pre-specified. This supports 001's fresh-session and compaction advice while cutting against its stated file-length mechanism.

**Runs are non-deterministic even at fixed temperature**

- *Understanding and Mitigating Numerical Sources of Nondeterminism in LLM Inference* — arxiv.org/html/2506.09501v2 — variation arising from the inference stack, not only from sampling.
- *How Consistent Are LLM Agents? Measuring Behavioral Reproducibility in Multi-Step Tool-Calling Pipelines* — arxiv.org/html/2605.28840

**How many runs it takes to detect a difference**

The body carries magnitudes rather than figures. The figures, and what they are conditional on:

- Computed for this chronicle, not borrowed: two-proportion z-test, binary pass/fail per task, baseline success 50%, α = 0.05, two-sided. Runs **per configuration**, ceilinged: 2pp effect — 9,804 at 80% power, 13,125 at 90%. 5pp — 1,562 / 2,092. 10pp — 385 / 515. 15pp — 167 / 224. 40pp — 17 / 23. The table is now in 003's body, not only here. Baseline rates away from 50% reduce these somewhat; paired designs reduce them further. Reproduced empirically by `examples/evals/`.
- 2025-12 — *ReasonBENCH: Benchmarking the (In)Stability of LLM Reasoning* — arxiv.org/pdf/2512.07795 — two-stage power analysis justifying 30 runs per configuration for a 5% effect at 90% power, α = 0.05.
  - **Not cited in the body, and worth recording why.** Its unit of observation is a benchmark *score* — a scaled sum over many per-problem Bernoulli outcomes — so its variance is far lower than a per-task pass/fail. Quoting "30 runs for a 5% effect" to someone re-running a golden set would understate what they need by roughly two orders of magnitude. The figure is correct for what it measures and wrong for what a reader would use it for.
- 2026-05 — *Coordination as an Architectural Layer for LLM-Based Multi-Agent Systems* — arxiv.org/pdf/2605.03310 — ~350 resolved binary predictions per condition to detect a 0.02 difference at α = 0.05, 80% power. Binary outcome, consistent in shape with the computed table.

**Token spend explains most of the difference between architectures**

- 2025-06 — Anthropic, *How we built our multi-agent research system* — token usage alone explains 80% of performance variance on BrowseComp; tool calls ~10%, model choice ~5%. † Vendor, and the finding cuts against the vendor's interest, which strengthens it.
- *Single-Agent LLMs Outperform Multi-Agent Systems on Multi-Hop Reasoning Under Equal Thinking Token Budgets* — the advantage disappears when budget is held constant.

**LLM judges carry replicated biases**

- 2024-10 — *Self-Preference Bias in LLM-as-a-Judge* — arxiv.org/pdf/2410.21819
- 2026-06 — *The Coin Flip Judge? Reliability and Bias in LLM-as-a-Judge Evaluation* — arxiv.org/pdf/2606.13685
- Position, verbosity, and self-enhancement biases quantified at scale, with swap-augmented evaluation proposed as calibration for position effects. Judge frameworks require empirical calibration against human annotators per task.

**Public benchmarks carry contamination and leakage**

- 32.67% of successful agent resolutions involved solution leakage — the fix or a direct pointer present in the issue description or comments.
- *Does SWE-Bench-Verified Test Agent Ability or Model Memory?* — arxiv.org/html/2512.10218v2 — a frontier model identifies the buggy file at 76% accuracy from the issue description alone, with no repository context.
- *SWE-Bench+* — arxiv.org/pdf/2410.06992 — 31.08% of accepted patches passed against test suites too weak to reject an incorrect solution; filtering these drops apparent effectiveness from 12.47% to 3.97%.

### Chronicle 002 — Verification in the Agentic Loop

**Agents reach green by routes you didn't intend**

- Anthropic, Claude 3.7 Sonnet system card — special-casing test cases in agentic coding environments: returning expected values directly, or modifying test files rather than implementing a general solution. † Vendor, self-disclosed.
- *EvilGenie: a Reward Hacking Benchmark* — arxiv.org/html/2511.21654v2 — taxonomy covering hard-coded test cases, modified harnesses, and special-case solutions.
- *SpecBench: Measuring Reward Hacking in Long-Horizon Coding Agents* — arxiv.org/html/2605.21384v1 — 30 systems-level tasks.
- *Do Coding Agents Deceive Us? Detecting and Preventing Cheating via Capped Evaluation with Randomized Tests* — arxiv.org/pdf/2606.07379 — agents observed editing a writable test so buggy output passes. Supports the held-out-oracle and freeze-the-tests practices.
- *CircumEval — Measuring Circumvention Propensity in Coding Agents* — explicit reward hacking observed in two of three major proprietary agents, misaligned behaviour in all three.

**The saved time reappears downstream in review and rework**

- 2025-07-10 — METR, *Measuring the Impact of Early-2025 AI on Experienced Open-Source Developer Productivity* — metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/ — 16 developers, 246 tasks, 19% slower with AI while believing they were 20% faster. **METR now labels this out of date**; its 2026-02-24 follow-up redesigns the experiment rather than restating the figure — metr.org/blog/2026-02-24-uplift-update/. Cite for the perception gap, not as a current productivity measurement.
- 2026 — Faros AI, *The AI Engineering Report 2026: The Acceleration Whiplash* — faros.ai/research/ai-acceleration-whiplash — telemetry, not surveys, across 22,000 developers and 4,000 teams over two years. Throughput genuinely rises: task completion +33.7%, epics +66.2%, PR merge rate +16.2%. The cost lands downstream: bugs per developer +54%, monthly incidents +57.9%, incidents per PR 3×, median PR review time 5×, code churn 10×, and 31% more PRs merging with no review at all. Deployments per week fall 11.7% — the throughput gain does not reach the end of the pipeline. This is the clearest evidence for the relocation-of-cost argument. † Vendor-published; Faros sells engineering analytics, so a finding that teams need better measurement serves its product. The telemetry basis and sample size still make it the strongest measurement available.
- GitClear, *The Maintainability Gap: 2026 AI Code Quality Research* — gitclear.com/the_ai_code_quality_maintainability_gap — copy-pasted code 9.4% (2022) to 15.7% (early 2026); refactored code 21% to 3.8%; two-week churn rising.
- DORA, 2025 State of DevOps — Rework Rate added as a fifth metric, with review burden elevated as a leading indicator.

### Claims carrying no solid source

Listed rather than dropped. Each is either weakly supported or an inference stated as fact in a chronicle body.

- ~~**"Untested context files can actively hurt agent performance"** (001, Skills)~~ — **retired 2026-08-16.** Now sourced, and more precisely than the original claim: context files do not generally improve task success and add over 20% inference cost (Gloaguen et al.), and no structural property of them detectably affects adherence (McMillan). The original phrasing implied that *testing* was the differentiator; the evidence does not support that framing, so 001 carries a qualifier about the benefit not being automatic instead.
- **Golden-set sizing** (003, *The Golden Set*) — practitioner writing widely converges on a range of a few dozen cases. No measurement behind it was located. The body says so explicitly and declines to give a number, deferring to the run-count arithmetic instead.
- **"Reading your traces carefully will probably teach you more per hour than a formal suite until a regression bites you twice"** (003, *The Cost, Honestly*) — a judgement about where effort pays off at small scale. No measurement located, and it is stated as opinion in the body rather than as finding.
- **"The gap widens with difficulty"** and **"it correlates with struggle"** (002) — consistent with how the reward-hacking literature frames the incentive, but not located as a measured result.
- **"Teams that measure this find the throughput improvement real but smaller than it feels"** (002) — now largely supported. Faros 2026 carries "real but smaller": throughput up by a third while deployments per week fall. The "than it feels" half needs a perception measurement, and the only one located is METR's, which METR labels out of date. Retained here until something current measures the gap between believed and actual.
