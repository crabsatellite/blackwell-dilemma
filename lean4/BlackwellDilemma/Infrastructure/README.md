# `BlackwellDilemma.Infrastructure` — Mathlib-PR-quality Lean infrastructure

This directory contains **self-contained Lean modules** designed to be
Mathlib-PR-ready. Each module fills a gap in Mathlib (currently no
`Order.Supermodular`, no Gaussian conjugate-prior infrastructure, no
non-compact EVT extension, no one-sided divergence predicate, no
finite bond-percolation framework, etc.) while providing the
mathematical foundations needed to retire the paper's Cat 3 §3.4.4
`workingAssumption` axioms with genuine Cat 1 derived theorems.

## Design principles

* **Mathlib-PR-quality**: generic naming, comprehensive docstrings,
  Apache-2.0 licensed, no project-specific dependencies.
* **Real Lean proofs**: all theorems decided by Lean kernel + Mathlib
  tactics (`linarith`, `nlinarith`, `ring`, `norm_num`, `positivity`,
  `Finset.sum_le_sum`, etc.). No domain axioms.
* **Incremental**: each module is self-contained, builds on earlier
  modules and standard Mathlib only.
* **Kernel-pure verified**: every main theorem has a `#print axioms`
  audit at the bottom of its file showing `[propext, Classical.choice,
  Quot.sound]` — no `sorry`, no broken-link axioms, no paper-novel
  carriers.

## Status (as of R140 — see `Roadmap.lean`)

### ✅ Tier A — Foundational predicates (DONE)

| Module | Description | Status |
|---|---|---|
| `TopkisCrossPartial.lean` | `IsSupermodular f` def + algebra (additivity, scalar, const) — fills missing Mathlib `Order.Supermodular` namespace | ✅ |
| `KappaStarConcrete.lean` | `DivergesAtBelowAtTop` predicate + algebra (`add_const`, `add`, `mono`) for one-sided divergence | ✅ |
| `EVTBoundedDecreasing.lean` | `exists_maxOn_of_continuous_eventually_decreasing` — generalises `IsCompact.exists_isMaxOn` to non-compact `[0, ∞)` under eventually-decreasing dominance | ✅ |

### ✅ Tier B — Comparative statics chain (DONE)

| Module | Description | Status |
|---|---|---|
| `FOSDDerivativeChain.lean` | `IsSupermodular.beta_increment_dominance` — four-corner inequality → β-increment dominance + `derivative_domination_of_supermodular` operational atom | ✅ |
| `ArgmaxMonotone.lean` | `strict_pref_preserved_under_difference_dominance` single-crossing + `argmax_monotone_atom` for paper bridge | ✅ |
| `BlackwellConditional.lean` | `finset_sum_mono_of_pointwise_mono` (+ weighted version) — pointwise → summed monotonicity lift via `Finset.sum_le_sum` | ✅ |

### ✅ Tier C — Concrete instance witnesses (DONE)

| Module | Description | Status |
|---|---|---|
| `FiveStateRewards.lean` | Explicit 5-state IDP reward parameters `r_S, r_A, r_B, r_D, r_G` + decidable inequalities | ✅ |
| `FiveStateVDyn.lean` | Explicit `V_dyn` per vertex on 5-state IDP (max over forward-reachable rewards), `V_dyn_B = 1`, `V_dyn_A = 0.6` | ✅ |
| `MLimitDifferenceConcrete.lean` | `mLimitDifference_fiveState_pos : 0.4 > 0` — first kernel-pure Cat 1 prototype for paper Theorem 4.1 Part 3 line 505 | ✅ |
| `SimpleGraphReachable.lean` | `reachable_finset_eq_univ_of_preconnected` — natural Finset packaging of `SimpleGraph.Preconnected` | ✅ |
| `GaussianPosterior.lean` | `gaussianPosteriorMean` explicit formula + continuity in `n` and `signal_variance` | ✅ |

### 🔲 Tier D — Calculus + Measure theory (IN PROGRESS)

| Module | Description | Status |
|---|---|---|
| `MillsRatioTail.lean` | Standard-normal Mills ratio bound `1 - Φ(x) ≤ φ(x)/x` for `x > 0` (Mills 1926) | 🔲 |
| `CalculusTopkis.lean` | Mixed-partial criterion `∂²f/∂x∂y ≥ 0 ⇒ IsSupermodular f` (Topkis 1978/1998) | 🔲 |
| `MonotoneIntegralFOSD.lean` | FOSD CDF + monotone integrand → integral dominance | 🔲 |

### 🔲 Tier E — Heavy infrastructure (PENDING — multi-month effort)

| Module | Description | Status |
|---|---|---|
| `FinitePercolation.lean` | Finite bond-percolation atoms (BondConfig, Bernoulli product, expectation linearity) | 🔲 |
| `GiantComponentMills.lean` | Giant-component Mills-tail decay above `p_c` | 🔲 |
| `LebesgueStieltjesAtoms.lean` | Stieltjes integration vs CDF G — basic atoms | 🔲 |
| `KernelConcretization.lean` | Per-realisation reward-kernel concretisation pattern | 🔲 |

## Architecture (mirrors Hodge)

```
BlackwellDilemma/
├─ Types.lean                  -- opaque carriers + paper-novel scope predicates (Cat 3 §3.4.1/2)
├─ Basic.lean                  -- foundational wrappers
├─ ClassicalResults.lean       -- Cat 2 axioms (Blackwell, Harris-Kesten, Grimmett, …)
├─ Percolation.lean            -- finite bond-percolation framework (Cat 1)
├─ Bayesian.lean               -- Bayesian / satisficing welfare (Cat 3 + derived)
├─ Canonical.lean              -- 4-state + 5-state IDP instances (Cat 1 explicit)
├─ Cognitive.lean              -- Theorem 4.1 cognitive threshold (Cat 3 + derived)
├─ Wrongness.lean              -- Lemma `lem:wrongness` (Cat 3 + derived)
├─ Phase.lean                  -- Theorem 3.3 phase transition (Cat 3 + derived)
├─ Principal.lean              -- principal welfare W_bar (Cat 3 + derived)
├─ GeneralGraphs.lean          -- Theorem 6.1 general-graph extension (Cat 3 + derived)
├─ Ledger.lean                 -- canonical gap inventory (auditable)
├─ AxiomAudit.lean             -- #print axioms surface for kernel-purity audit
└─ Infrastructure/             -- ★ Cat 1 only, Mathlib-contributable
   ├─ Roadmap.lean             -- architectural blueprint
   ├─ README.md                -- this file
   ├─ TopkisCrossPartial.lean  -- Tier A: IsSupermodular + algebra
   ├─ KappaStarConcrete.lean   -- Tier A: DivergesAtBelowAtTop + algebra
   ├─ EVTBoundedDecreasing.lean-- Tier A: EVT for bounded eventually-decreasing
   ├─ FOSDDerivativeChain.lean -- Tier B: supermod → β-increment dominance
   ├─ ArgmaxMonotone.lean      -- Tier B: derivative-domination → argmax monotone
   ├─ BlackwellConditional.lean-- Tier B: pointwise → finset-sum monotonicity
   ├─ FiveStateRewards.lean    -- Tier C: 5-state IDP rewards
   ├─ FiveStateVDyn.lean       -- Tier C: 5-state V_dyn per vertex
   ├─ MLimitDifferenceConcrete.lean -- Tier C: 5-state mLimitDifference > 0
   ├─ SimpleGraphReachable.lean-- Tier C: reachable=univ under preconnected
   ├─ GaussianPosterior.lean   -- Tier C: conjugate-prior posterior mean
   ├─ MillsRatioTail.lean      -- Tier D: standard-normal Mills bound
   ├─ CalculusTopkis.lean      -- Tier D: mixed partial → supermod
   ├─ MonotoneIntegralFOSD.lean-- Tier D: FOSD integral dominance
   ├─ FinitePercolation.lean   -- Tier E: finite bond percolation
   ├─ GiantComponentMills.lean -- Tier E: giant-component decay
   ├─ LebesgueStieltjesAtoms.lean -- Tier E: Stieltjes atoms
   └─ KernelConcretization.lean   -- Tier E: kernel concretisation
```

## How to use

Importing this directory:
```lean
import BlackwellDilemma.Infrastructure.TopkisCrossPartial
import BlackwellDilemma.Infrastructure.EVTBoundedDecreasing
-- etc.
```

Or via the top-level meta-import:
```lean
import BlackwellDilemma  -- imports everything
```

## Verification

Each file has its theorems verified by `lake build`. The `#print axioms`
output for theorems in these files surfaces only Lean kernel
foundational axioms (`propext`, `Classical.choice`, `Quot.sound`) —
NO domain-specific axioms.

Verify with:
```bash
lake build BlackwellDilemma.Infrastructure.<ModuleName>
```

## Mathlib PR plan

When complete and stable, these modules can be contributed to Mathlib
as standalone PRs:

1. **`Mathlib.Order.Supermodular.Basic`** — `IsSupermodular` definition
   + algebra (additivity, scalar, const) on `ℝ → ℝ → ℝ`. Currently
   ZERO supermodular content in Mathlib; this PR creates the namespace.
2. **`Mathlib.Topology.Order.ExtremeValueExtension`** — non-compact
   EVT extension: `exists_maxOn_of_continuous_eventually_decreasing`
   for functions on `[0, ∞)` under eventually-decreasing dominance.
3. **`Mathlib.Order.Filter.DivergesAtBelowAtTop`** — one-sided
   divergence predicate (`f → +∞` as `x → c⁻`) + basic algebra
   (additivity, scalar, dominance-monotone).
4. **`Mathlib.Combinatorics.SimpleGraph.Reachable.FinsetUniv`** —
   `reachable_finset_eq_univ_of_preconnected` natural Finset
   packaging of `Preconnected`.
5. **`Mathlib.Probability.Bayesian.GaussianConjugatePrior`** —
   explicit `gaussianPosteriorMean` formula + continuity in
   sample-size and signal-variance parameters.
6. **`Mathlib.Probability.Distributions.Mills`** — standard-normal
   Mills ratio bound (foundational for Gaussian-tail inequalities).

These would be the first occurrence in Mathlib of these objects /
results, providing immediate value to other formalisation projects
(comparative statics, Bayesian inference, probability tail bounds,
percolation theory).

## License

Apache 2.0 (same as Mathlib).

## References

Standard references for the math:

* D. M. Topkis, *Supermodularity and Complementarity*, Princeton
  University Press (1998).
* J. P. Mills, "Table of the ratio: area to bounding ordinate, for
  any portion of normal curve", *Biometrika* **18** (1926), 395-400.
* G. Grimmett, *Percolation*, Springer (1999), 2nd ed.
* H. Kesten, "The critical probability of bond percolation on the
  square lattice equals 1/2", *Comm. Math. Phys.* **74** (1980),
  41-59.
* D. Blackwell, "Equivalent comparisons of experiments",
  *Ann. Math. Statist.* **24** (1953), 265-272.
* T. J. Stieltjes, *Recherches sur les fractions continues*,
  Toulouse Annales (1894).
