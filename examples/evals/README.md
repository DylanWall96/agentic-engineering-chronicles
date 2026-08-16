# Evals, running

The load-bearing claim in [chronicle 003](../../chronicles/003-evals-for-your-own-harness.md) is that a single run cannot tell you whether a harness change helped, because the variation between runs is larger than the difference you are trying to detect.

That is a claim about sampling, so it needs no model calls to demonstrate. Requires Go.

```sh
./run.sh              # fixed seed, reproduces exactly
./run.sh -seed 42     # vary it
```

Two configurations are simulated with known, fixed success rates — 50% and 55%. B really is better. That is a fact of the simulation, not something to infer, which is what makes the wrong answers below legible as wrong.

## What it shows

**One run each is a coin.** Half the time both configurations produce the same outcome and the comparison says nothing at all. When it does give an answer, it is wrong about 45% of the time.

**A handful of runs barely helps.** At five runs each it is wrong 42% of the time it answers; at fifty, still 29%. The ties thin out, so you get an answer more often — it just isn't a better answer. This is the regime everyone actually works in.

**The run counts that resolve it are not ones anybody uses.** For this five-point difference: 1,562 runs per configuration for 80% power, 2,092 for 90%, at α = 0.05. The simulation confirms the arithmetic empirically — at 1,562 runs each it is wrong 0.3% of the time. That is over four thousand agent runs to establish one five-point difference.

**The inverse is the alarming part.** Two *identical* configurations, compared five times each, produce an apparent winner 75% of the time — with a typical claimed margin of **32 percentage points**. Small samples do not produce small false effects. They produce enormous ones, because the observed rate can only move in steps of one over the number of runs.

## Why no model calls

An example that needed live model calls would be non-deterministic, would cost money, and would break when models changed. [`examples/README.md`](../README.md) sets the standard that a failing example is a finding about the chronicle rather than a maintenance chore, and that only holds if the example is a closed system.

Nothing here depends on any model's behaviour. It depends only on the fact that agent runs vary, which the chronicle sources separately.

## A finding from building it

003 originally said identical configurations would show "an apparent improvement of several points". The simulation put that at tens of points, not several. The chronicle was corrected to match the measurement — the example was not adjusted to agree with the chronicle.

## Layout

```
sim.go     the simulation, including the textbook sample-size calculation
           so the chronicle's numbers can be checked rather than trusted
run.sh     runs it
```
