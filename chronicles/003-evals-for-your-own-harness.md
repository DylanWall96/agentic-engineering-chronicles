# Evals for Your Own Harness

Chronicle 001 lists "you have evals" as a precondition for moving past a single agent, and separately advises testing skills against held-out cases before shipping them. It never says what an eval is, how you would build one, or how you would know a harness change helped. This is the follow-through.

The subject is your setup, not the agent's output. Chronicle 002 covers establishing that what was generated is correct. This one covers establishing that the thing which generated it is any good — and, more often, whether the change you just made to it did anything at all.

---

## A Change Is a Hypothesis

You trim the context file, add a skill, drop a subagent to a cheaper tier, install a tool server. The next session goes well. You conclude the change worked.

That is one flip of a coin you have decided is biased.

**Every harness change is a hypothesis, and almost nobody tests theirs.** The setup is full of adjustments adopted because the session afterwards felt smoother, retained because nothing obviously broke, and never revisited. The scaffolding accumulates. Each piece is load-bearing only in the sense that no one has checked whether removing it changes anything.

The most instructive case is the change everyone makes first. Writing a context file is the single most universally recommended piece of harness work there is — it is the opening advice of every guide, including 001. When it was finally put to controlled evaluation on real repository tasks, supplying one did not generally improve task success, while adding meaningful inference cost to every run. A separate factorial study varying the structural properties practitioners argue about — length, where instructions sit, how files are split, whether adjacent files contradict each other — found none of them produced a detectable difference in whether the agent followed the instructions.

Neither result means context files are worthless. Both mean the benefit is smaller, narrower, and more conditional than the confidence with which it is recommended, and that the mechanisms we cite for it are largely folklore. If the most-tested piece of harness advice in the field turns out to be this uncertain, the untested piece you invented last Tuesday deserves rather less confidence than you are giving it.

That is the argument for evals. Not rigour for its own sake — the specific and repeated experience of discovering that a change you were sure about does nothing.

---

## The Minimum Unit of Evidence

Agent runs are not deterministic. The same prompt against the same model with the same setup produces different token samples, different tool calls, different outcomes — and that holds even at fixed temperature, because the non-determinism arrives from the inference stack rather than only from sampling.

**So the minimum unit of evidence is a distribution, not a run.** Comparing one before to one after is not weak evidence. It is no evidence, and it is worse than none, because it produces a confident conclusion.

The arithmetic here is unforgiving, and it is the single most useful thing in this chronicle. On a suite that yields pass or fail per task, detecting a difference of a couple of percentage points needs runs in the *thousands* per configuration. A five-point difference needs low thousands. Even a ten-point difference — large enough that you would expect to feel it — needs several hundred. Only differences so large you would never have needed statistics to see them resolve in the dozens.

Nobody runs that many. Which means, stated plainly: **most before-and-after comparisons of harness changes cannot detect the differences they claim to have found.** The honest conclusion from a handful of runs each way is almost always "no detectable difference", and the second most honest is "this needs a bigger effect to be worth chasing".

This is not counsel of despair. It redirects effort. Chase changes big enough to see. Prefer removing scaffolding, where the win is cost and simplicity and you need only show nothing got worse. Treat small measured improvements with suspicion proportional to how few runs produced them. And when the effect really is small, accept that you are choosing on grounds other than measured performance — cost, or simplicity, or taste — and say so, rather than dressing the preference up as a result.

Beware the inverse most of all. Two genuinely identical configurations, compared over a handful of runs, will usually produce an apparent winner — and the margin will not be modest. This is the part that surprises people: small run counts do not generate small false effects, they generate enormous ones, because the observed rate can only move in steps of one over the number of runs. Compare a configuration against an identical copy of itself five times each and you will typically come away with a winner and a margin in the tens of points. Not occasionally. Usually. Every practitioner who has declared a config change a success on the strength of three runs has generated exactly this artefact, and had no way to tell.

---

## The Golden Set

A golden set is a small collection of tasks representative of your actual work, each with a known-good outcome, which you re-run when you change something.

**Its value is in coverage of failure modes, not volume.** Ten tasks that fail in ten different ways will teach you more than a hundred variations on the same one. Build it from things that have actually gone wrong: the refactor the agent botched, the migration it did not realise needed review, the file it kept editing when it should have asked. Each becomes a case. The suite grows out of your own history rather than out of an idea of what coverage should look like.

Practical shape:

- **Fix the task, not the phrasing.** The point is to vary the harness and hold everything else steady. If you also reword prompts between runs, you have measured two things and can attribute neither.
- **Record the whole run, not the verdict.** Tokens spent, wall-clock, tool calls made, files touched. The pass or fail is the least informative number you collect, and the rest is what tells you why.
- **Keep the outcomes checkable by something other than your impression.** Chronicle 002's argument applies here without modification.
- **Let it go stale deliberately.** A case that has passed for months on every configuration is no longer discriminating between anything. Retire it or replace it.

Common sizing advice exists and is widely repeated, but it is practitioner convention rather than a measured finding. Pick the smallest set that covers your distinct failure modes and let the arithmetic above tell you how much a run of it can actually prove.

---

## Cost as a Metric

A setup that produces marginally better outcomes for double the token spend is not better. It is a purchase, and one you would probably not have authorised if anyone had quoted you the price.

**Cost belongs in the eval alongside the outcome, because otherwise you cannot tell which one you changed.** This is not hypothetical. Where the comparison between agent architectures has been instrumented, token spend alone accounts for the large majority of the measured performance difference — which means an uninstrumented comparison of two setups is frequently measuring budget while reporting design.

The rule follows directly: any harness comparison that reports outcomes without reporting spend is uninterpretable. If the new configuration wins while spending more, you have learned nothing about the configuration. Equalise the budget, or report both numbers and let the reader see what was bought.

---

## Scripts and Judges

Most of what you want to know about a harness is structural, and a script can answer it.

**Check programmatically wherever the answer is not a matter of taste.** Did it call the tool you expected. Did it stay out of the path you forbade. Did it produce output that parses. Did it stop, or grind through a dozen turns of the same failing approach. Did it read the file it was told to read before editing. None of this needs a model to assess, and a deterministic check does not have an opinion that drifts.

Reach for a model as judge only for the genuinely open-ended remainder, and then knowing what you have hired. Judges carry documented and repeatedly replicated biases: toward longer answers over shorter ones, toward whichever candidate they were shown first, and toward output from their own model family. The first two are trivially triggered by exactly the comparisons you want to run.

If you use one, treat it as an instrument requiring calibration rather than an oracle. Run both orderings and average, so position cancels. Score correctness separately from style, so length cannot smuggle itself in. And label a sample yourself, then check the judge against your labels — if it does not agree with you on cases where you are confident, its verdicts on the rest are decoration.

---

## Your Own Suite and the Public Ones

Public benchmarks are answering a different question than the one you have. They ask whether a model is broadly capable. You are asking whether a change to your setup helped on your codebase.

They are also less clean than their headline numbers imply. A substantial share of successful resolutions on the best-known coding benchmark turn out to have the fix, or a direct pointer to it, sitting in the issue text. Models can identify the file to change at high accuracy from the issue description alone, without the repository. And when instances whose tests were too weak to reject a wrong patch are filtered out, apparent effectiveness falls by a large multiple.

**None of this makes benchmarks useless; it makes them unable to answer your question.** A dozen tasks drawn from your own repository, with outcomes you defined, will tell you more about a change to your harness than any public leaderboard, and cannot be contaminated by material the model saw in training, because it has never seen your repository.

---

## The Suite Is a Claim Too

This is the point at which chronicle 002 arrives one level up, and it is worth stating plainly rather than leaving as an implication.

**A harness tuned until the golden set goes green has optimised against the measurement.** It is precisely the failure 002 describes, moved up a layer: the suite was a proxy for "my setup works well", you adjusted things until the proxy was satisfied, and the proxy is satisfiable in ways the real goal is not. Add cases that reward verbosity and you will tune toward a verbose setup. Build the suite from tasks the agent already handles and you will conclude everything is fine.

The tell is the same as in 002: the measurement stops moving while your experience of the work does not improve, or improves in ways the suite never registered. A suite that has agreed with you for six months has probably stopped being evidence and started being a ritual.

So the things that cannot be delegated to the eval, because the eval is the thing they check:

- **Choosing what to measure.** The suite encodes a theory of what good looks like, and that theory is yours.
- **Noticing when it stopped tracking the outcome.** No amount of green tells you this. Only the gap between the number and your actual experience does.
- **Deciding what an acceptable cost is.** No measurement makes that call.

---

## The Cost, Honestly

For a solo engineer, building and maintaining this is real overhead against uncertain return, and pretending otherwise would be the same overselling this chronicle exists to argue against.

Reading your traces carefully — actually reading them, not skimming for the failure — will probably teach you more per hour than a formal suite until a regression bites you twice. The case for the apparatus strengthens with the number of people depending on the setup, the frequency with which you change it, and the cost of it silently degrading. A team of twenty sharing a harness is in a different position from one person who can feel when their tooling turns.

Scale it to consequence, as with everything else. A golden set for the workflow your team runs daily; a careful read of the trace for the experiment you ran once. Applying the full apparatus uniformly is its own kind of waste, and the surest way to abandon the practice entirely is to make it heavier than the problem.

One caveat this chronicle owes itself. The studies above are individually well-designed and independent, and each is a single result. A single controlled study is one run — better instrumented than yours, and still one. Treat the findings here as the best evidence currently available rather than as settled, and hold them the way this chronicle asks you to hold your own measurements.

---

## Quick Reference

| Principle | Action |
| --- | --- |
| A change is a hypothesis | Assume your harness adjustment did nothing until measured |
| One run is no evidence | The minimum unit is a distribution, not a session that felt good |
| Know what you cannot detect | Small differences need run counts nobody runs; chase big effects |
| Identical configs differ | A handful of runs will invent improvements that do not exist |
| Golden set by failure mode | Ten distinct failures beat a hundred variations on one |
| Vary one thing | Hold the prompt steady, change the harness, or attribute nothing |
| Record the whole run | Tokens, time, tool calls — the verdict is the least useful number |
| Cost is a metric | Outcomes without spend are uninterpretable; equalise or report both |
| Script before judge | Deterministic checks for anything that is not a matter of taste |
| Calibrate the judge | Swap orderings, split correctness from style, check against your labels |
| Your suite beats theirs | Public benchmarks answer a different question and carry contamination |
| The suite is a claim | A harness tuned until it goes green has optimised against the measurement |
| Prefer removing | Deleting scaffolding needs only proof nothing got worse |
| Scale to consequence | Trace-reading may beat evals until a regression bites twice |

---

## Further Reading

As with 001 and 002, specific tools, benchmark names, and exact figures shift and have been kept out of the body on purpose. The studies behind the claims here — including the run counts required to detect a given effect, and the conditions those numbers depend on — are dated in `../CHANGELOG.md`.
