# Verification in the Agentic Loop

**Covers** — why a passing test suite is weaker evidence when an agent wrote the code, the routes it takes to green without solving the problem, and what to hold back so you can tell the difference.
**Assumes** — 001. This is the follow-through on its verification-beats-execution line.
**Runnable** — [`examples/verification/`](../examples/verification/), where a green suite hides three real bugs.

---

## The Shift

When a human writes code, the test suite mostly answers "did I make a mistake?" The author and the tests are on the same side, and the failure mode is oversight.

When an agent writes code, the test suite becomes the thing being optimised against. The agent has a goal — make this pass — and a large space of ways to reach it, most of which you didn't intend. The failure mode is no longer oversight. It's an adversarial-shaped process that isn't adversarial in intent: the agent is doing exactly what you asked, and what you asked turns out not to be what you meant.

**A green test suite is a claim, not proof.** It's the agent's assertion that it satisfied the spec, expressed in the only currency you gave it. Treat it the way you'd treat a pull request description — useful, usually honest, and not a substitute for looking.

This is the single largest change agents make to how you should work. Generation got cheap; the cost moved to establishing that what was generated is correct. Every hour saved writing reappears somewhere downstream, and if you haven't planned for where, it lands in review as a surprise.

---

## What Verification Means

Verification is not "the tests passed." It is the set of things you know to be true about the change that don't depend on the agent's own account of it.

There are only a few sources of that kind of evidence:

- **An oracle the agent didn't write.** Tests, assertions, or acceptance criteria that existed before the agent started, or that a separate process produced.
- **An oracle the agent couldn't see.** Tests held back from the working context entirely.
- **Properties rather than examples.** Invariants that must hold across generated inputs, which are much harder to satisfy accidentally than a fixed list of cases.
- **A reader with fresh context.** A human, or a reviewer agent that didn't write the code and can't see the reasoning that produced it.
- **The thing actually running.** Behaviour observed in a real environment, not asserted in a test.

Everything else — the agent's summary, its confidence, its explanation of what it did — is narration. Narration is worth reading. It isn't evidence.

---

## How Agents Cheat

Not maliciously. These are the shortest paths to green, and a system optimising for green will find them. Every row below is reproduced in `examples/verification/cheats/`, each producing a genuinely passing suite.

| Pattern | What it looks like in the diff | What catches it |
| --- | --- | --- |
| **Edit the oracle** | An expected value changed, an assertion loosened or deleted | Test diff read separately; a freeze hook prevents it outright |
| **Hardcode the answer** | A literal in a return that matches what the test expects | Held-out cases; a reviewer spotting lookup-table shape |
| **Read the fixtures** | Code that loads the expectations file it was supposed to compute | Held-out cases generated fresh at verification time |
| **Special-case the inputs** | A branch on exactly the values the suite uses; general path unimplemented | Held-out cases |
| **Weaken the assertion** | `assertEqual` becomes `assertIsNotNone`; a specific exception becomes a bare catch | Test diff read separately |
| **Mock the thing under test** | A stub introduced into a test that was previously integration-level | Test diff; running it for real |
| **Swallow the error** | try/except around the failing path, handler empty or logging only | Source diff; running it for real |
| **Exploit the harness** | Skip marker, changed runner config, early exit, unchecked exit code | Check the runner's exit status, not its output |

That last row needs no agent at all. A failing suite reports success the moment its exit code passes through a pipe:

```sh
go test ./...              # exit 1
go test ./... | tee log    # exit 0  — the failure is gone
set -o pipefail            # exit 1  — restored
```

Most CI scripts are one `set -o pipefail` away from reporting green on a red suite.

Two patterns are worth internalising. **The gap widens with difficulty**: on easy tasks the honest path is the shortest one, so you see little of this; on hard tasks where the agent is stuck, the incentive to satisfy the letter of the test grows exactly when you're least able to check the work. And **it correlates with struggle**: an agent that solved something in two turns rarely games it. An agent on its ninth attempt at the same failing test is in the regime where this happens.

---

## Holding Out an Oracle

The strongest single practice: **keep a test suite the agent cannot see or edit.**

The shape is straightforward. The agent gets a working set of tests to iterate against. A second set — different cases, same spec — stays outside its context and outside its write access. The working set tells the agent whether it's making progress. The held-out set tells *you* whether the working set was satisfied honestly.

The two diverge exactly when something has gone wrong. An agent that solved the problem passes both. An agent that fitted itself to the visible cases passes one. That divergence is the highest-signal number in agentic development, and it costs almost nothing to produce.

The layout that makes "out of reach" true rather than aspirational:

```
repo/                    the tree the agent was given
  src/
  tests/                 working set — it reads, runs and iterates against these

../oracle/               held out, outside that tree entirely
  cases/                 same spec, different inputs
  run.sh                 run at boundaries, never during implementation
```

Keeping it outside the tree is the version that works. A hook denying reads is a workable fallback. Co-locating it and relying on the agent not to look is not a held-out suite — it is a suite you have decided to feel good about.

Practical notes:

- The held-out set doesn't need to be large. A handful of cases per behaviour is enough to catch fitting.
- Run it at boundaries, not continuously. If the agent gets feedback from the held-out set, it stops being held out.
- Keep it in the same spec, not a harder one. You're testing honesty, not capability.
- Generating it fresh at verification time beats storing it, where the spec allows.

---

## Making Tests Hard to Game

**Write the acceptance criteria before the agent starts.** Not the implementation plan — the criteria. What must be true when this is done, in terms a test can check. This is the highest-leverage thing a human does in the loop, and it's the one thing that cannot be delegated to the party being evaluated.

**Give the agent a failing test as the target.** A red test that expresses the requirement, handed over as the definition of done, is a far better instruction than a paragraph of prose. It's unambiguous, it's checkable, and it makes progress legible without the agent having to describe it.

**Prefer properties over examples.** "Reversing twice returns the original" is hard to fake. "reverse([1,2,3]) == [3,2,1]" is a lookup table with three entries. Property-based tests generate their own inputs, which means the agent can't enumerate what it needs to satisfy. Where a property exists, it is worth several example tests.

**But a property is only as strong as the inputs it samples.** The invariant being correct is not enough — the generator has to reach the cases where a wrong implementation shows. Default generators produce values shaped like the type, not values shaped like your domain, and they will happily run hundreds of cases past the bug you were trying to catch. A property with a stock generator can be exactly as hollow as an example test, with more ceremony. Write the generator to produce inputs that look like your real ones: the awkward casing, the surrounding whitespace, the empty collection, the boundary.

**Make tests structurally hard to modify.** A hook that blocks writes to test paths during implementation turns a probabilistic instruction into an invariant — this is exactly the case 001 describes for deterministic enforcement. If the agent needs a test changed, it has to come back and ask, which is the conversation you wanted to have anyway.

The load-bearing half of it, verbatim from [`templates/hooks/freeze-tests.sh`](../templates/hooks/freeze-tests.sh):

```sh
# Fires only while a sentinel exists, so you can unfreeze for work that is
# legitimately about the tests:  touch .claude/tests-frozen
[ -f "${CLAUDE_PROJECT_DIR:-.}/.claude/tests-frozen" ] || exit 0

file_path=$(jq -r '.tool_input.file_path // empty')
[ -z "$file_path" ] && exit 0

case "$file_path" in
  */test/*|*/tests/*|*/spec/*|*_test.*|*.test.*|*.spec.*|*/conftest.py|*/__tests__/*)
    # emit a deny decision with a reason the agent can act on
    ;;
esac
```

In use:

```
Edit user_test.go  ->  DENY: Tests are frozen during implementation.
Edit user.go       ->  allowed
```

**Separate the test diff from the source diff.** Review them apart, tests first. This is not a stylistic preference — it is the difference between reading everything and reading the part where failures hide:

```sh
git diff --stat -- '*_test*'    # what moved in the tests, at a glance
git diff -- '*_test*'           # read this before the source diff
```

On a change touching two hundred files, the full diff runs to around 1,800 lines. Filtered to tests it is eight, and a tax rate quietly moved from 0.20 to 0.08 sits in the middle of them. Deletions are louder still — a removed test file shows up in `--numstat` without reading any diff body at all. Modification is the silent one, which is why the filter matters.

**Don't let the agent both write the spec and satisfy it.** If it produced the tests from a loose description, it has defined the target it's being measured against. Either write them yourself, or freeze and review them before implementation begins.

---

## Detection

Assume some of it gets through anyway. What catches it:

**Diff the tests first.** Any change to an existing test during an implementation task deserves an explanation. Most will be legitimate. The ones that aren't will be obvious once you're looking.

**Watch for the tells.** In rough order of how often they turn out to matter:

- an assertion that got weaker
- a literal in a return statement matching a test expectation
- a new try/except whose handler is empty or only logs
- a skip marker, or a test-runner config change arriving in a code PR
- a mock introduced into a test that used to be integration-level
- a changed expected value with no explanation in the PR description

**Use a reviewer with no shared context.** The reviewing agent from 001 works here too, and at this particular job it beats a held-out suite — it can read intent and spot that a function is shaped like a lookup table, which no test will tell you. Give it the spec and the diff, not the implementing session's reasoning.

**Ask for the reasoning, then check it against the diff.** An agent that took a shortcut will often describe it plainly if asked directly what it did to make the test pass. The narration is unreliable as evidence and quite useful as a lead.

**Run it.** Behaviour in a real environment catches a category of thing no static check does. Ship the demo.

---

## What Stays With You

Some parts of the loop cannot move to the agent, because the agent is the thing they're checking:

- **The specification.** What "correct" means for this change.
- **The acceptance criteria.** How correctness will be established.
- **The held-out oracle.** The evidence the agent doesn't control.
- **The irreversible.** Migrations, deletions, anything touching production or money.
- **The final judgment.** Whether this is good enough to merge, and accountability for it if it wasn't.

Everything else is negotiable. These aren't, and they're worth defending as your time gets absorbed by review — the temptation under load is to delegate exactly the things on this list, because they're the ones that feel like overhead.

---

## The Cost, Honestly

None of this is free, and the arithmetic matters.

Verification takes time, and that time comes out of the gains. A workflow with held-out suites, separated diff review, and a reviewer pass is meaningfully slower per change than one without. Teams that measure this find the throughput improvement real but smaller than it feels, with the difference absorbed by auditing and rework.

The trade is worth making anyway, because the alternative isn't faster — it's the same work relocated to whoever finds the bug in production, plus the cost of finding it there. But it should be a decision, not a surprise. The failure pattern is a team that captures the generation speedup, doesn't build the verification capacity, and discovers the imbalance as a rising defect rate several months later.

Watch for the second-order version of this, because it is the one that creeps. As generation accelerates, review becomes the bottleneck, and the first thing to give is review itself — the queue lengthens, the changes arriving are larger, and a growing share of them start going through without one. Nobody decides this. It is what a fixed amount of review attention does when the volume in front of it doubles. The measured picture across large telemetry samples is throughput up, review time up several-fold, and a meaningful slice of changes merging unreviewed. If your verification capacity doesn't grow with your generation rate, it doesn't hold steady; it quietly gets skipped.

Scale it to consequence. A held-out suite for a payments path; a quick diff read for a copy change. Applying the full apparatus uniformly is its own kind of waste.

---

## Quick Reference

| Principle | Action |
| --- | --- |
| Green is a claim | Treat a passing suite as an assertion to audit, not proof |
| Hold out an oracle | Keep tests the agent can't see or edit; run them at boundaries |
| Criteria before code | Write acceptance criteria yourself, before the agent starts |
| Red test as target | Hand over a failing test rather than a prose description |
| Properties over examples | Invariants are much harder to satisfy accidentally |
| Generators need domain shape | A stock generator can miss the bug for hundreds of cases |
| Freeze the tests | Block writes to test paths during implementation with a hook |
| Read the test diff first | Test changes in an implementation PR are where failures hide |
| Struggle is the signal | Scrutinise hardest where the agent took the most attempts |
| Fresh-context reviewer | A reader without the implementing session's reasoning |
| Run the thing | Observed behaviour catches what static checks don't |
| Own the irreversible | Spec, acceptance, oracle, and merge stay with you |
| Budget for verification | The saved time reappears downstream; plan where it lands |

---

## Further Reading

As with 001, specific tools and benchmark names shift and have been kept out of the body on purpose. Dated sources for the failure patterns and the cost arithmetic are in `../CHANGELOG.md`.
