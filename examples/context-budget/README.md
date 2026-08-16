# Context budget, measured

[Chronicle 001](../../chronicles/001-effective-agent-workspace-setup.md) argues that the model only sees the context window, that most of what people put in it is recoverable anyway, and that every line is paid for on every turn. Those are claims about files on your disk, so they can be checked rather than believed.

Bash only. No network, no model calls.

```sh
./run.sh                    # this repo
./run.sh fixtures/bloated   # a deliberately over-stuffed workspace
./run.sh ~/code/your-repo   # yours — this is the point
```

Unlike the other examples, this one is meant to be pointed at your own project. The fixture is just there to show what a bad result looks like.

## What it reports

**`budget.sh` — where the window goes before any work begins.**

```
COMPONENT                            TOKENS    SHARE   NOTE
CLAUDE.md                               358     0.2%   every turn
skill descriptions                       37     0.0%   every turn
skill bodies                             35        -   on invocation only
MCP tool definitions                      ?        ?   6 server(s) — see note
                                     ------    -----
STANDING COST PER TURN                  395     0.2%
```

The skill split is the mechanism 001 describes in a paragraph: descriptions are resident, bodies load only when used. Seeing the ratio on your own skills makes the argument for progressive disclosure better than the paragraph does.

**`redundant.sh` — which lines the agent could have found itself.**

```
CUT  - src/            source code                    -> ls -d */
CUT  - Use 2 spaces for indentation, never tabs.      -> the linter
CUT  This is a Node.js project. Node.js is a JavaS…   -> already known

13 of 24 content lines look recoverable (54%).
```

More than half the file is paying rent on every turn to save the agent one command. Against this repo's own `AGENTS.md` the same check returns 6%, which is the contrast worth having.

## Two honest limits

**Token counts are characters ÷ 4, not a real tokenizer.** A proper BPE count needs a model's vocabulary, which would break the offline guarantee. The estimate is consistently wrong in the same direction, so it is fine for comparing components against each other and wrong for capacity planning. Treat it as ratios, not absolutes.

**MCP tool definitions cannot be measured from disk, and the script says `?` rather than guessing.** The config lists which servers run; the tool schemas come from the servers themselves. In most real setups this is the largest single line item, so the honest output is a server count and an instruction to ask your harness what it actually loads — not a number that looks authoritative and isn't.

## The heuristic is wrong on this repo, deliberately left in

`redundant.sh` flags three lines of our own `AGENTS.md`:

```
CUT  - `chronicles/` — numbered, self-contained documents…   -> ls -d */
CUT  - `templates/` — copyable artefacts…                    -> ls -d */
CUT  - `examples/` — runnable demonstrations…                -> ls -d */
```

All three are false positives. `ls` recovers the directory *names*; it cannot tell you what each one is *for*, and the purpose is the part worth keeping. The pattern matcher sees a bulleted directory and stops thinking.

This was not tuned away, because the failure is the lesson: the check proposes, you decide. A tool that silently suppressed its own wrong answers would be less useful and less honest than one that shows them.

## Layout

```
budget.sh          where the context window goes
redundant.sh       which lines are recoverable, and how
run.sh             both, against any path
fixtures/bloated/  an over-stuffed workspace to see a bad result
```

## What this cannot show

001's larger claims — that performance degrades as the window fills, that a context file does or doesn't improve task success, that subagents beat a single agent — all need model calls and many runs. They are sourced in [`CHANGELOG.md`](../../CHANGELOG.md) instead, and [chronicle 003](../../chronicles/003-evals-for-your-own-harness.md) covers what measuring them would actually take.

What is demonstrable here is the accounting, and the accounting is the part people skip.
