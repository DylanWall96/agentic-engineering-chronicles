# AGENTS.md

Context for agents working **on this repository**. If you are looking for guidance to apply to *another* project, read `SKILL.md` instead — this file is about maintaining the chronicles, not using them.

## What this repo is

A collection of chronicles on agentic software engineering: principles and patterns for working with AI coding agents that hold up across model generations. Prose, deliberately generic, plus a thin layer of copyable templates.

It is also installable as a skill (`SKILL.md`), so changes to structure or filenames must keep the skill's routing table accurate.

## Structure

- `chronicles/` — numbered, self-contained documents. The durable material.
- `templates/` — copyable artefacts (context files, hooks, settings). Explicitly dated and expected to rot.
- `examples/` — runnable demonstrations of mechanical claims. Not for copying; for checking.
- `CHANGELOG.md` — dated sources backing claims made in the chronicles.
- `SKILL.md` — routing layer for agents applying the chronicles elsewhere.

## Editorial rules

These are the reason the repo is worth reading. Hold them.

- **Principles over feature lists.** Write what will still be true after the next model release. Keep version numbers, product names, and UI descriptions out of chronicle bodies. Those date; put them in `CHANGELOG.md` and refer to them generically.
- **But numbers a reader needs to act on belong in the body.** The rule above is about specifics that identify a vendor's product, not about arithmetic. A sample size, a threshold someone has to compute against, a figure that changes what they do on Monday — that is the practical content, and stating it generically to satisfy the rule above guts the chronicle. If you find yourself writing "runs in the thousands" where you could write the table, write the table. This has already gone wrong once: 003 shipped its central arithmetic as vague magnitudes and had to have it put back.
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
3. **Build the example before finalising the prose**, wherever the chronicle makes a mechanical claim. See below.
4. Add its rows to the routing table in `SKILL.md`.
5. Add its sources to `CHANGELOG.md`, dated.
6. Add it to the chronicle list in `README.md`.

## Every chronicle ships a working example

Not optional, and not satisfied by a demonstration of the *problem*. If a chronicle recommends a practice, the example has to show that practice working, in a form a reader can run and then point at their own project.

The distinction matters because it has already been got wrong. 003 shipped a simulation proving that one run tells you nothing — a correct and useful demonstration of the problem — while the chronicle described a golden set, a runner, and a results format that existed nowhere in the repo. Talking about a practice without showing it is the failure this repo exists to argue against.

What an example owes the reader:

- **The practice, working.** Not a diagram of it, not a printed snippet. Something that runs.
- **A seam for their own project.** One clearly marked script or config to swap. Everything else stays.
- **Determinism, offline.** No network, no API keys, no model calls in the default path. An example needing live calls is non-deterministic, costs money, and rots when models change — which breaks the standard that a failing example is a finding about the chronicle rather than a maintenance chore.
- **A printed seed** where randomness is involved.

The non-deterministic part is always exactly one thing: the agent. Isolate it behind a script with a stand-in default, and the rest of the harness — cases, scoring, analysis — is ordinary deterministic software you can ship.

## Build the example first

Where a claim can be demonstrated in code, write the demonstration before you write the paragraph, and let the prose describe what the example actually shows.

This is not a style preference. Examples have corrected chronicles three times, always in the same direction — the prose overclaimed and the code disproved it:

- 002 said property-based tests are hard to satisfy accidentally. A correct invariant with a stock generator passed five hundred cases against code known to be broken.
- 003 said identical configurations compared over a handful of runs show "an apparent improvement of several points". The simulation put it in the tens of points.
- 002 described a held-out suite as needing to sit outside the agent's tree, while its own example co-located one.

Three for three suggests the failure is structural rather than careless. Prose written first describes the claim you believe; prose written after the demonstration describes the claim you can support. Write it in that order.

If the example contradicts the chronicle, the chronicle is what changes. Never adjust an example to agree with prose.

## When editing an existing chronicle

Later chronicles describe earlier ones. Editing 001 can silently invalidate how 002 or 003 characterises it, and nothing catches that except reading them in sequence.

After changing a chronicle, grep the others for references to it and check that what they say about it is still true. This has already happened once: 001 gained a forward pointer to 002, which made 002's opening line — "001 says verification beats execution and leaves it there" — describe a version of 001 that no longer existed. Four commits passed before a sequential read caught it.

Describe what an earlier chronicle *is about*, not what it *fails to do*. The first stays true when the earlier document changes; the second is a hostage to it.

## What to leave alone

- Don't renumber existing chronicles. Numbers are referenced externally.
- Don't rewrite the voice of an existing chronicle to match a new one.
- Don't add citations, footnotes, or source links to chronicle bodies.
- Don't add a table of contents. The documents are short enough not to need one.
