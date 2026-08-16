# Workspace audit

Loaded when the user asks for their setup to be looked at. Report what you observe; the user decides what to do about it.

## Before anything else

Look for signs the repository is used with agents at all: context files, a `.claude/` or equivalent directory, configured tool servers, skills, hooks.

**If there are none, say so plainly and stop.** "I don't see any agent configuration here — nothing to audit yet. If you tell me what's going wrong, I can suggest where to start." Do not produce a setup plan for someone who asked for an audit. Chronicle 001 is explicit that scaffolding is a response to friction actually experienced, and prescribing a full configuration to someone who has not hit any friction contradicts the thing you would be citing.

## What to look at

Read before reporting. Every observation needs the evidence in front of you, not an assumption about what a repository like this usually contains.

**Context files.** Size, and what is in them. Content the model already knows (language syntax, framework basics). Content recoverable in a couple of greps (directory listings, dependency lists). Code-style rules a linter should own. Whether `AGENTS.md` and a harness-specific file duplicate each other rather than one importing the other. Whether large reference docs are pulled in on every turn instead of pointed at.
→ 001, *CLAUDE.md and AGENTS.md*

**Rules that could be deterministic.** Prose in a context file phrased as "never do X" or "always do Y" where a hook could enforce it. These are the highest-value observations you can make, because the instruction is the version that gets forgotten under context pressure or dropped by compaction.
→ 001, *Hooks*

**Permissions and sandboxing.** What the posture is, whether deny rules cover credentials, whether anything runs unrestricted.
→ 001, *Permission Modes and Sandboxing*

**Skills.** Whether descriptions are specific enough to trigger. Whether any bundle scripts the user may not have read.
→ 001, *Skills*

**Tool surface.** How many servers are configured, and whether they correspond to systems the user develops against rather than calls.
→ 001, *When to Reach Beyond the Basics*

**Cross-session state.** Whether any durable, version-controlled artefacts exist, or everything lives in session history.
→ 001, *Cross-Session State*

**Verification.** Whether tests exist. Whether anything prevents the agent editing them mid-implementation. Whether there is any oracle the agent does not control.
→ 002, *Holding Out an Oracle*, *Making Tests Hard to Game*

## How to report

**Lead with what could be removed.** Most workspaces have too much rather than too little, and deletion is the more common fix. A report that opens with additions has already misread the situation.

**Separate two kinds of observation, and label them clearly.**

*Likely to bite you* — something present and working against the user: a context file large enough to cost adherence on every turn, duplicated rules across two files that will diverge, a test suite the agent can freely rewrite, credentials readable in an unsandboxed session.

*Absent, which may be entirely correct* — no skills, no tool servers, no cross-session directory, no hooks. Absence is the default state and is frequently right. Say what it might indicate and what friction would justify changing it. Never imply a gap.

**Attribute every observation.** Name the chronicle and section behind it so the user can disagree with the reasoning rather than only the verdict. If you cannot name one, you are giving a personal opinion — say that instead.

**Ask before changing anything.** The audit reports. Offer to act on specific items and wait.

## What not to do

- No score, grade, percentage, maturity level, or pass/fail. There is no correct configuration to be measured against.
- No checklist framing where every unticked box reads as a deficiency.
- Don't recommend adding hooks, skills, subagents, or a decisions directory by default. Each is a response to a specific friction; if you cannot name the friction it addresses in this repository, don't raise it.
- Don't infer from absence. A repository without a golden set is not behind — chronicle 003 is explicit that trace-reading may beat formal evals until a regression bites.
- Don't rewrite anything to demonstrate a point.
