<!-- Last verified: 2026-08-09 -->
<!--
  The universal-rules context file, read natively by most agent harnesses.

  Use this as the source of truth. Keep any harness-specific file thin: an
  import of this one plus whatever only that harness understands. A rule
  that exists in two files will disagree with itself within a month.

  Two ways to wire the thin file up, both fine:
    - an import directive pointing at this file
    - a symlink: ln -s AGENTS.md CLAUDE.md

  Rationale: chronicles/001, section "CLAUDE.md and AGENTS.md".
-->

# <Project name>

<!-- One or two lines. What this is, who uses it. -->

## Stack

<!-- Versions and key dependencies, not the framework's own documentation. -->

## Commands

- Install:
- Test:
- Lint:
- Build:
- Run locally:

## Structure

<!-- Boundaries between packages or modules, and which directories are generated. -->

## Conventions

<!-- What isn't visible in the code. Code style belongs to the linter, not here. -->

## Safety rules

<!-- Short and specific. Prefer a hook wherever the rule can be enforced. -->

- Never edit generated files in `<path>`.
- Migrations require review before running.

## Reference docs

<!-- Point rather than embed, so the file loads only when it's needed. -->

- For complex `<Foo>` usage, or if you hit `<FooBarError>`, read `<path/to/doc.md>`.
