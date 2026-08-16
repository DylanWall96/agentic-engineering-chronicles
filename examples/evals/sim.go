// Command sim demonstrates why a single run cannot tell you whether a harness
// change helped. It makes no model calls: two configurations are simulated with
// known, fixed underlying success rates, so the ground truth is not in doubt.
// Everything the simulation reports is a fact about sampling, not about models.
//
// See ../../chronicles/003-evals-for-your-own-harness.md
package main

import (
	"flag"
	"fmt"
	"math"
	"math/rand"
	"strings"
)

// Two configurations. B is genuinely better, by a margin typical of the kind of
// harness change people argue about — a trimmed context file, a different
// subagent tier, a skill added.
const (
	rateA = 0.50
	rateB = 0.55

	trials = 20000 // independent repetitions of the whole comparison
)

// runSuite executes n runs of a golden set at the given underlying success rate
// and returns the observed pass rate.
func runSuite(rng *rand.Rand, rate float64, n int) float64 {
	passed := 0
	for i := 0; i < n; i++ {
		if rng.Float64() < rate {
			passed++
		}
	}
	return float64(passed) / float64(n)
}

// compare runs both configurations n times each and reports what an observer
// would conclude: whether B looked better, and by how much.
func compare(rng *rand.Rand, rA, rB float64, n int) (bWins, tie bool, margin float64) {
	a := runSuite(rng, rA, n)
	b := runSuite(rng, rB, n)
	return b > a, a == b, (b - a) * 100
}

// requiredN is the textbook UNPOOLED two-proportion sample size, per
// configuration. The pooled variant differs by a few runs — see README.
// Included so the number in the chronicle can be checked rather than trusted.
func requiredN(p1, delta, power float64) int {
	// Full precision: rounded z-values shift three cells of the published
	// table by one, which is how the chronicle and this code came to disagree.
	zAlpha := 1.9599639845400545 // two-sided, alpha = 0.05
	zBeta := map[float64]float64{0.80: 0.8416212335729143, 0.90: 1.2815515655446004}[power]
	p2 := p1 + delta
	num := math.Pow(zAlpha+zBeta, 2) * (p1*(1-p1) + p2*(1-p2))
	return int(math.Ceil(num / (delta * delta)))
}

func bar(label string) {
	fmt.Printf("\n\033[1m%s\033[0m\n", label)
}

func main() {
	seed := flag.Int64("seed", 20260816, "PRNG seed; output is exactly reproducible")
	flag.Parse()

	fmt.Printf("seed = %d   (rerun with -seed to vary; same seed gives identical output)\n", *seed)
	fmt.Printf("Configuration A succeeds %.0f%% of the time. B succeeds %.0f%%.\n", rateA*100, rateB*100)
	fmt.Printf("B is genuinely better. That is a fact of the simulation, not something to infer.\n")
	fmt.Printf("Every figure below is over %d independent repetitions of the comparison.\n", trials)

	// ---------------------------------------------------------------------
	bar("1. One run each")
	rng := rand.New(rand.NewSource(*seed))
	wrong, ties := 0, 0
	for i := 0; i < trials; i++ {
		bw, tie, _ := compare(rng, rateA, rateB, 1)
		if tie {
			ties++
		} else if !bw {
			wrong++
		}
	}
	fmt.Printf("   tied (both passed, or both failed) : %.1f%%\n", pct(ties, trials))
	fmt.Printf("   gave an answer                     : %.1f%%\n", pct(trials-ties, trials))
	fmt.Printf("   of those answers, wrong            : %.1f%%\n", pct(wrong, trials-ties))
	fmt.Printf("   You are reading a coin. The better configuration is invisible.\n")

	// ---------------------------------------------------------------------
	bar("2. A handful of runs each")
	fmt.Printf("   %-11s %-9s %s\n", "RUNS EACH", "TIED", "WRONG, OF THE TIMES IT GAVE AN ANSWER")
	for _, n := range []int{5, 10, 20, 50} {
		rng = rand.New(rand.NewSource(*seed + int64(n)))
		wrong, ties = 0, 0
		for i := 0; i < trials; i++ {
			bw, tie, _ := compare(rng, rateA, rateB, n)
			if tie {
				ties++
			} else if !bw {
				wrong++
			}
		}
		decisive := trials - ties
		fmt.Printf("   %-11d %-9s %.1f%%\n", n,
			fmt.Sprintf("%.0f%%", pct(ties, trials)), pct(wrong, decisive))
	}
	fmt.Printf("   Ties thin out as runs increase, so the comparison answers more often.\n")
	fmt.Printf("   The answer barely gets better. This is the regime everyone actually\n")
	fmt.Printf("   works in when judging a config change.\n")

	// ---------------------------------------------------------------------
	bar("3. Enough runs, per the arithmetic")
	need80 := requiredN(rateA, rateB-rateA, 0.80)
	need90 := requiredN(rateA, rateB-rateA, 0.90)
	fmt.Printf("   Two-proportion test, %.0fpp effect, alpha 0.05, per configuration:\n", (rateB-rateA)*100)
	fmt.Printf("     %d runs for 80%% power, %d for 90%%\n", need80, need90)
	for _, n := range []int{100, 500, need80, need90} {
		rng = rand.New(rand.NewSource(*seed + int64(n)))
		wrong, ties = 0, 0
		for i := 0; i < trials; i++ {
			bw, tie, _ := compare(rng, rateA, rateB, n)
			if tie {
				ties++
			} else if !bw {
				wrong++
			}
		}
		fmt.Printf("   %5d runs each : wrong %.1f%% of the time it answered\n", n, pct(wrong, trials-ties))
	}
	fmt.Printf("   Only here does the comparison resolve reliably. Note the cost:\n")
	fmt.Printf("   that is %d agent runs to establish one %.0f-point difference.\n", need90*2, (rateB-rateA)*100)

	// ---------------------------------------------------------------------
	bar("4. Two configurations that are identical")
	fmt.Printf("   Both succeed %.0f%% of the time. There is nothing to find.\n", rateA*100)
	fmt.Printf("   %-12s %-22s %s\n", "RUNS EACH", "APPARENT WINNER", "TYPICAL MARGIN CLAIMED")
	for _, n := range []int{3, 5, 10, 20} {
		rng = rand.New(rand.NewSource(*seed + 7919 + int64(n)))
		decisive, sumAbs := 0, 0.0
		for i := 0; i < trials; i++ {
			_, tie, margin := compare(rng, rateA, rateA, n)
			if !tie {
				decisive++
				sumAbs += math.Abs(margin)
			}
		}
		fmt.Printf("   %-12d %-22s %.1f percentage points\n",
			n, fmt.Sprintf("%.0f%% of the time", pct(decisive, trials)), sumAbs/float64(decisive))
	}
	fmt.Printf("   Every one of those is an artefact. Note the size of them: a five-run\n")
	fmt.Printf("   before-and-after on a change that does nothing usually hands you a\n")
	fmt.Printf("   winner, and a margin in the tens of points, in whichever direction\n")
	fmt.Printf("   chance chose. Small run counts do not produce small false effects.\n")
	fmt.Printf("   They produce enormous ones, because the margin can only move in\n")
	fmt.Printf("   steps of one over the number of runs.\n")

	// ---------------------------------------------------------------------
	bar("What this means")
	fmt.Println(strings.TrimRight(`   Your before-and-after impression of a config change is not weak evidence.
   At the run counts anyone actually uses, it is indistinguishable from noise,
   and it arrives feeling like a conclusion.

   The practical response is not to run thousands of trials. It is to prefer
   changes big enough to see, to prefer deletions where you need only show
   nothing got worse, and to say "no detectable difference" out loud when that
   is what the evidence supports.`, "\n"))
	fmt.Println()
	fmt.Println("   ../../chronicles/003-evals-for-your-own-harness.md")
	fmt.Println()
}

func pct(part, whole int) float64 { return float64(part) / float64(whole) * 100 }
