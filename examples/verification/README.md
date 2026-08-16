# Verification, running

Everything [chronicle 002](../../chronicles/002-verification-in-the-agentic-loop.md) argues, as code you can execute. Requires **Go 1.21+**.

```sh
./run.sh
```

Roughly ten seconds. Nothing in the output is written by hand — every line is produced by actually running the suites.

## What it shows

**A green suite hiding three real bugs.** The task is creating a user: normalise the email, enforce a password minimum, reject duplicates. There are two implementations. `Honest` follows the spec. `Fitted` is what you get when a visible test suite is the only feedback signal — it lowercases without trimming, sets the password floor at 8 rather than the documented 12, and dedupes on the raw email instead of the normalised one.

`Fitted` passes the working suite completely. Against a held-out suite of the same spec, it fails three ways: duplicate accounts for the same person, and a password policy that is silently 8 characters. Neither implementation is doing anything exotic; the difference is only which tests each was measured against.

**Why the held-out suite is the thing.** It isn't harder. It's the same spec with different cases, and it doesn't share the working suite's blind spots. `Honest` passes both and always would — correct code pays nothing for any of this.

**Where properties stop helping.** "Normalising leaves no surrounding whitespace" is a correct invariant. With Go's stock string generator it runs 500 cases past an implementation that never trims, because arbitrary runes essentially never carry surrounding whitespace. The same invariant with a generator shaped like real email addresses fails on the first case. A property is only as strong as the distribution it samples.

**Every route to green in the taxonomy.** Seven packages under `cheats/`, one per pattern — hardcoding the answer, reading the fixtures, special-casing the inputs, weakening the assertion, mocking the thing under test, swallowing the error, skipping the test. Each produces a genuinely passing suite and is caught by a held-out probe.

**The eighth, which needs no agent at all.** A failing suite reports success because someone piped it through `tee`:

```
go test          exit 1
go test | tee    exit 0
+ pipefail       exit 1
```

## Layout

```
user.go              spec as comments, then Honest and Fitted
working_test.go      what the agent sees and iterates against
heldout/             same spec, different cases, plus the property tests
cheats/              one package per route to green
```

`chosen_honest.go` and `chosen_fitted.go` select the implementation by build tag, so the same suites run against both:

```sh
go test ./...                 # honest
go test -tags fitted ./...    # fitted
```

## The hook

Blocking the shortest route — editing the test — is deterministic rather than probabilistic. [`templates/hooks/freeze-tests.sh`](../../templates/hooks/freeze-tests.sh) denies writes to test paths during implementation:

```
Edit working_test.go  ->  DENY: Tests are frozen during implementation.
Edit user.go          ->  allowed
```
