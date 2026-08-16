# Evals, running

Two things: the argument behind [chronicle 003](../../chronicles/003-evals-for-your-own-harness.md), and a working eval you can point at a real agent.

Requires Go for the first, nothing but bash for the second. No network, no API keys, no model calls by default.

## The argument

```sh
./run.sh              # fixed seed, reproduces exactly
./run.sh -seed 42     # vary it
```

Two configurations with known success rates — 50% and 55%. B really is better, which is what makes the wrong answers legible as wrong.

- **One run each is a coin.** Half the time the comparison says nothing; when it answers, it is wrong about 45% of the time.
- **A handful barely helps.** Five runs each: wrong 42% of the time it answers. Fifty: still 29%.
- **The run counts that resolve it are not ones anybody uses.** 1,562 per configuration for a five-point difference at 80% power.
- **The inverse is the alarming part.** Two *identical* configurations compared five times each show an apparent winner 75% of the time, with a typical claimed margin of 32 points. Small samples do not produce small false effects — the observed rate can only move in steps of one over the number of runs.

## The eval

```sh
./eval.sh --config baseline        --runs 20
./eval.sh --config trimmed-context --runs 20
./analyse.sh
```

```
CONFIG             PASSED         PASS RATE        AVG TOKENS/RUN
baseline           29/60          48.3%            52589
trimmed-context    40/60          66.7%            40926

observed   trimmed-context is 18.3 points ahead, on 60 runs each
needed     111 runs each for 80% power, 148 for 90% (alpha 0.05)
verdict    NOT DETECTABLE — 60 runs cannot resolve 18.3 points.
           A gap this size needs 2x the runs you did.

cost       trimmed-context costs 22.2% less per run — and unlike the pass
           rate, that is readable off a single run.
```

That verdict is the point of the whole chronicle. An eighteen-point gap over sixty runs still is not evidence — and most people would have shipped the change on three. Meanwhile the cost difference is solid, from the same data, which is why 003 argues you should optimise on the axis you can actually see.

Run it with `--runs 60` and the verdict flips to DETECTABLE. That is the harness working, not the answer changing.

## Layout

```
cases/                       one directory per case
  001-flags-migration-for-review/
    task.md                  the prompt, fixed — never reworded between runs
    expect.sh                exits 0 if the outcome was right
    notes.md                 why this case exists, and what it came from
agents/
  fake.sh                    deterministic stand-in, runs offline
  real.sh.example            swap in your own agent — one line
eval.sh                      runs every case n times against one config
analyse.sh                   reads results.jsonl, returns a verdict
results.jsonl                one line per run
sim.go                       the sampling argument analyse.sh rests on
```

Every case came from something that actually went wrong — a migration applied unprompted, generated code hand-edited, a schema changed silently. That is where a golden set comes from: your own history, not an idea of what coverage should look like.

## Pointing it at a real agent

```sh
cp agents/real.sh.example agents/real.sh && chmod +x agents/real.sh
./eval.sh --agent real --config my-setup --runs 20
```

The harness only requires that the agent script works inside `$WORKSPACE` and writes `$TRANSCRIPT`. Cases, scoring, and analysis are unchanged. Only that one script is non-deterministic, which is why it is the only part you have to supply.

## Why the default agent is fake

An example needing live model calls would be non-deterministic, would cost money, and would break when models changed. [`examples/README.md`](../README.md) holds that a failing example is a finding about the chronicle rather than a maintenance chore, and that only works if the example is closed.

The stand-in has fixed underlying success rates, so the harness can be checked against a known answer — something you never get with a real agent, and the reason the statistical problem exists at all.

## Findings from building it

- The runner recorded wall-clock, which made results irreproducible when a run crossed a second boundary. It now prefers a duration the agent reports, falling back to measured time for real agents.
- 003 originally said identical configurations show "an apparent improvement of several points". The simulation put it in the tens. The chronicle was corrected; the example was not adjusted to agree with it.
