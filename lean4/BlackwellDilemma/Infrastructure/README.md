# `BlackwellDilemma.Infrastructure` — Mathlib-PR-quality Lean infrastructure

This directory contains **self-contained Lean modules** designed to be
Mathlib-PR-ready. Each module fills a gap in Mathlib (currently no
`Order.Supermodular`, no Gaussian conjugate-prior infrastructure, no
non-compact EVT extension, no one-sided divergence predicate, no
finite bond-percolation framework, etc.) while providing the
mathematical foundations needed to discharge the paper's Cat 3 §3.4.4
paper-derived working-content axioms with genuine Cat 1 derived
theorems.

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

## Status — 26 Cat 1 modules complete

### ✅ Tier A — Foundational predicates (DONE)

| Module | Description | Status |
|---|---|---|
| `TopkisCrossPartial.lean` | `IsSupermodular f` def + algebra (additivity, scalar, const) — fills missing Mathlib `Order.Supermodular` namespace | ✅ |
| `SupermodularExtended.lean` | `IsAntimodular`, `of_separable`, `of_separable_plus_residual`, `add_function_of_first/second` | ✅ |
| `KappaStarConcrete.lean` | `DivergesAtBelowAtTop` predicate + algebra (`add_const`, `add`, `mono`) for one-sided divergence | ✅ |
| `EVTBoundedDecreasing.lean` | `exists_maxOn_of_continuous_eventually_decreasing` — generalises `IsCompact.exists_isMaxOn` to non-compact `[0, ∞)` | ✅ |
| `UnitIntervalAlgebra.lean` | `InUnitInterval`, `mul`, `convex_comb`, `one_sub`, `min_mem`, `max_mem` for `[0, 1]` algebra | ✅ |
| `MonotoneFunctionAlgebra.lean` | `Monotone` algebra: sum, scalar, comp, sub-antitone, MonotoneOn variants | ✅ |
| `MonotoneCDFAlgebra.lean` | `IsCDF` predicate + `FOSD` relation + refl/trans/antisymm | ✅ |

### ✅ Tier B — Comparative statics chain (DONE)

| Module | Description | Status |
|---|---|---|
| `FOSDDerivativeChain.lean` | `IsSupermodular.beta_increment_dominance` — four-corner → β-increment dominance | ✅ |
| `ArgmaxMonotone.lean` | `strict_pref_preserved_under_difference_dominance` + `argmax_monotone_atom` | ✅ |
| `BlackwellConditional.lean` | `finset_sum_mono_of_pointwise_mono` — pointwise → summed monotonicity | ✅ |
| `DifferenceQuotientAlgebra.lean` | `DifferenceDominates` predicate + algebra (refl, trans, add, smul, neg-swap) | ✅ |
| `MonotoneIntegralFOSD.lean` | `weighted_sum_mono_under_weight_fosd` + `difference_dominates_via_weighted_sum` | ✅ |
| `FOSDLiftedExpectation.lean` | Combines FOSD + finset-weighted sum atoms for paper-bridge expectation lift | ✅ |
| `ArgmaxExistence.lean` | `argmax_exists_of_continuous_eventually_decreasing` + `argmax_preserved_under_monotone` | ✅ |
| `AbstractKernelMonotonicity.lean` | `expectation_mono_of_pointwise_kernel_mono` + reversal pattern | ✅ |

### ✅ Tier C — Concrete instance witnesses (DONE)

| Module | Description | Status |
|---|---|---|
| `FiveStateRewards.lean` | Explicit 5-state IDP reward parameters `r_S, r_A, r_B, r_D, r_G` + decidable inequalities | ✅ |
| `FiveStateVDyn.lean` | Explicit `V_dyn` per vertex on 5-state IDP, `V_dyn_B = 1`, `V_dyn_A = 0.6` | ✅ |
| `MLimitDifferenceConcrete.lean` | `mLimitDifference_fiveState_pos : 0.4 > 0` — Cat 1 prototype | ✅ |
| `SimpleGraphReachable.lean` | `reachable_finset_eq_univ_of_preconnected` — Finset packaging of `Preconnected` | ✅ |
| `GaussianPosterior.lean` | `gaussianPosteriorMean` explicit formula + continuity in `n` and `signal_variance` | ✅ |
| `MaxOverFinset.lean` | `Finset.sup'` atoms for `V_dyn(v)` — `le_finset_sup'_of_mem`, `_mono_pointwise` | ✅ |
| `FiniteConvexCombination.lean` | Convex combinations: `convex_combination_in_unit_interval`, `weighted_sum_linear` | ✅ |

### ✅ Tier D — Topology / arithmetic atoms (DONE)

| Module | Description | Status |
|---|---|---|
| `ContinuousArithmetic.lean` | `ContinuousOn.add_Ioi0`, `sub_Ioi0`, `mul_Ioi0`, `linear_Ioi0` for half-line atoms | ✅ |
| `TendstoLimitArithmetic.lean` | `Tendsto.add_const_real`, `sub_const_real`, `const_smul_real`, `add_real` | ✅ |
| `TendstoFiniteSum.lean` | `tendsto_finset_sum_of_pointwise_tendsto` + weighted version | ✅ |
| `MillsRatioTail.lean` | `weighted_tail_lower_bound` + `tail_geometric_lower_bound` + `sum_pos_of_one_pos_term` | ✅ |
| `PiecewiseFunction.lean` | `piecewise2 c f g` + `_at_left/_right` + `_mono` (regime functions) | ✅ |

### ✅ Tier E — Percolation infrastructure (DONE for foundational atoms)

| Module | Description | Status |
|---|---|---|
| `BernoulliProductFinite.lean` | `bernoulliFactor`, `bernoulliWeight` over `Bool^E` finite product + non-negativity / strict positivity | ✅ |
| `PercolationExpectation.lean` | `percExpectation_finite` + non-negativity + monotonicity + linearity | ✅ |

### 🔲 Tier F — Future heavy infrastructure (PENDING — multi-month effort)

| Module | Description | Status |
|---|---|---|
| `CalculusTopkis.lean` | Mixed-partial criterion `∂²f/∂x∂y ≥ 0 ⇒ IsSupermodular f` (Mathlib `Analysis.Calculus`) | 🔲 |
| `GiantComponentMills.lean` | Giant-component Mills-tail decay above `p_c` (Grimmett 1999 §6.75) | 🔲 |
| `LebesgueStieltjesAtoms.lean` | Stieltjes integration vs CDF G — Mathlib `MeasureTheory` | 🔲 |
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

When complete and stable, these 26 modules can be contributed to Mathlib
as standalone PRs grouped by area:

### PR-1: Order theory + comparative statics

1. **`Mathlib.Order.Supermodular.Basic`** — `IsSupermodular` definition
   + algebra (additivity, scalar, const, separable, antimodular).
   Currently ZERO supermodular content in Mathlib; this PR creates the
   namespace. Combines `TopkisCrossPartial.lean` + `SupermodularExtended.lean`.
2. **`Mathlib.Order.Comparative.DifferenceDominates`** —
   `DifferenceDominates` predicate + algebra (refl, trans, add, smul,
   neg-swap) from `DifferenceQuotientAlgebra.lean`.
3. **`Mathlib.Order.Comparative.ArgmaxMonotone`** — single-crossing
   preference preservation + argmax monotone atoms from
   `ArgmaxMonotone.lean` + `FOSDDerivativeChain.lean`.

### PR-2: Topology extensions

4. **`Mathlib.Topology.Order.ExtremeValueExtension`** — non-compact
   EVT extension `exists_maxOn_of_continuous_eventually_decreasing`
   from `EVTBoundedDecreasing.lean`.
5. **`Mathlib.Order.Filter.DivergesAtBelowAtTop`** — one-sided
   divergence predicate + algebra from `KappaStarConcrete.lean`.

### PR-3: SimpleGraph + Combinatorics

6. **`Mathlib.Combinatorics.SimpleGraph.Reachable.FinsetUniv`** —
   `reachable_finset_eq_univ_of_preconnected` Finset packaging from
   `SimpleGraphReachable.lean`.
7. **`Mathlib.Combinatorics.Finset.MaxFinset`** — `Finset.sup'` atoms
   from `MaxOverFinset.lean` (some already in Mathlib, this packages
   the ergonomic versions).

### PR-4: Probability foundations

8. **`Mathlib.Probability.Bayesian.GaussianConjugatePrior`** —
   `gaussianPosteriorMean` explicit formula + continuity from
   `GaussianPosterior.lean`.
9. **`Mathlib.Probability.UnitInterval.Algebra`** — `InUnitInterval`
   algebra from `UnitIntervalAlgebra.lean`.
10. **`Mathlib.Probability.CDF.FOSD`** — `IsCDF` predicate + `FOSD`
    relation from `MonotoneCDFAlgebra.lean`.

### PR-5: Tail bounds + Bernoulli

11. **`Mathlib.Probability.MillsTail.Discrete`** — `weighted_tail_lower_bound`
    + geometric decay from `MillsRatioTail.lean`.
12. **`Mathlib.Probability.BondPercolation.BernoulliWeight`** —
    finite Bernoulli product atoms from `BernoulliProductFinite.lean`
    + `PercolationExpectation.lean`.

### PR-6: Big-operator monotonicity

13. **`Mathlib.Algebra.Order.BigOperators.MonoLift`** —
    `finset_sum_mono_of_pointwise_mono` + weighted variants from
    `BlackwellConditional.lean` + `MonotoneIntegralFOSD.lean`.

### PR-7: Topological/continuous arithmetic atoms

14. **`Mathlib.Topology.Order.ContinuousArithmetic.IoiAtoms`** —
    `ContinuousOn` arithmetic on `(0, ∞)` from `ContinuousArithmetic.lean`.
15. **`Mathlib.Topology.Order.Tendsto.Arithmetic`** — `Tendsto` arithmetic
    real-valued ergonomic atoms from `TendstoLimitArithmetic.lean`.

These would be the first occurrence in Mathlib of these objects /
results, providing immediate value to:
* Comparative statics formalisations (economics, game theory).
* Bayesian inference formalisations.
* Probability tail bound libraries.
* Percolation theory formalisations.
* Real-analysis ergonomic atoms.

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
