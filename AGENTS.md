# AGENTS.md

Context for agents working **on this repository**. If you are looking for guidance to apply to *another* project, read `SKILL.md` instead — this file is about maintaining the chronicles, not using them.

## What this repo is

A collection of chronicles on agentic software engineering: principles and patterns for working with AI coding agents that hold up across model generations. Prose, deliberately generic, plus a thin layer of copyable templates.

It is also installable as a skill (`SKILL.md`), so changes to structure or filenames must keep the skill's routing table accurate.

## Structure

- `chronicles/` — numbered, self-contained documents. The durable material.
- `templates/` — copyable artefacts (context files, hooks, settings). Explicitly dated and expected to rot.
- `CHANGELOG.md` — dated sources backing claims made in the chronicles.
- `SKILL.md` — routing layer for agents applying the chronicles elsewhere.

## Editorial rules

These are the reason the repo is worth reading. Hold them.

- **Principles over feature lists.** Write what will still be true after the next model release. Avoid version numbers, product names, exact thresholds, and UI descriptions in chronicle bodies. If a specific is essential, put it in `CHANGELOG.md` and refer to it generically in the text.
- **No speculation.** Claims belong in the chronicles only if they have held across model generations or have concrete adoption behind them. Anything untested goes to GitHub Discussions.
- **First person is implicit, not stated.** The voice is experience-backed and unattributed. Don't add "studies show" or "research suggests" to the body — sources live in the CHANGELOG.
- **Cut before adding.** These documents argue that bloated context degrades performance. A chronicle that doubles in length has failed its own test. Prefer a new chronicle to an expanding one.
- **Every chronicle earns its number.** It should either close a gap an earlier one left open, or cover ground none of them touch. State the relationship in the opening lines.

## Style

- British spelling (*behaviour*, *summarise*, *artefact*, *utilisation*).
- Bold lead-ins for the load-bearing claim of a paragraph. Prose underneath, not fragments.
- Em dashes for asides. No exclamation marks.
- Each chronicle ends with a Quick Reference table and a pointer to `CHANGELOG.md`.
- Section headings are noun phrases, not questions.

## When adding a chronicle

1. Confirm it isn't an expansion of an existing one in disguise.
2. Open by naming what it follows from and what it assumes.
3. Add its rows to the routing table in `SKILL.md`.
4. Add its sources to `CHANGELOG.md`, dated.
5. Add it to the chronicle list in `README.md`.

## What to leave alone

- Don't renumber existing chronicles. Numbers are referenced externally.
- Don't rewrite the voice of an existing chronicle to match a new one.
- Don't add citations, footnotes, or source links to chronicle bodies.
- Don't add a table of contents. The documents are short enough not to need one.
