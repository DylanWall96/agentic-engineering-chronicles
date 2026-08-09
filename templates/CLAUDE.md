<!-- Last verified: 2026-08-09 -->
<!--
  Starter context file. Cut everything that doesn't apply.
  Rationale for every rule here lives in chronicles/001, section
  "CLAUDE.md and AGENTS.md". This file is the shape, not the argument.

  Target: under a couple of hundred lines including your content.
  The test: a new contributor asks "run the tests" and it works first try.

  If you also keep an AGENTS.md, put the universal rules there and reduce
  this file to an import plus anything harness-specific. Don't duplicate.
-->

# <Project name>

<!-- One or two lines. What this is, who uses it. Not a sales pitch. -->

## Stack

<!-- Versions and key dependencies. "React 18 with TypeScript, Vite, Tailwind"
     — not "React project". The model knows React; it doesn't know your version. -->

## Commands

<!-- Only the handful actually used. Non-obvious tooling matters most:
     if it's `task` not `make`, or `bun test` not `npm test`, say so.
     Delete any line the agent could discover in one `cat package.json`. -->

- Install:
- Test:
- Lint:
- Build:
- Run locally:

## Structure

<!-- Where things live, and the boundaries between packages or modules.
     Not a directory listing — the agent can `ls`. The parts that surprise
     a newcomer: what depends on what, which directory is generated. -->

## Conventions

<!-- Only what isn't visible in the code. Naming rules, patterns you've
     standardised on, decisions someone would otherwise re-litigate.

     Do NOT put code style here. Linters and formatters enforce it, and a
     hook runs them every time. Never send a model to do a linter's job. -->

## Safety rules

<!-- Things that must never happen. Keep this list short and specific.

     Anything phrased "never do X" or "always do Y" is a candidate for a
     hook instead — see templates/hooks/. An instruction can be forgotten
     under context pressure, or dropped entirely by compaction. A hook
     can't be. Leave it here only if it can't be enforced deterministically. -->

- Never edit generated files in `<path>`.
- Migrations require review before running.

## Reference docs

<!-- Point, don't embed. @-mentioning a large file loads it every single turn.
     Tell the agent when to go read it instead: -->

- For complex `<Foo>` usage, or if you hit `<FooBarError>`, read `<path/to/doc.md>`.
- Before starting a new feature, check `<decisions/>` for prior conventions.

<!--
  Monorepos: put package-specific context in a nested file inside that
  package rather than growing this one. Nesting resolves nearest-file-first.
-->
