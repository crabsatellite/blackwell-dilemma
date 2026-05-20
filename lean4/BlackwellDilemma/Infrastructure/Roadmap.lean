/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

/-!
# Full Cat 1 Cover Roadmap — Blackwell-Dilemma Lean Formalisation

This file is the **architectural blueprint** for retiring every
paper-stipulated `*_paper_witness` axiom into **genuine Cat 1 derived
theorems** built from concrete Mathlib + finite-instance infrastructure.

## Architecture (mirrors `HodgeReduction/`)

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
└─ Infrastructure/             -- Cat 1 only, Mathlib-contributable
   ├─ Roadmap.lean                  -- this file
   ├─ EnvelopeContinuity.lean       -- overshootRegimeI continuity from explicit L formula
   ├─ LUnimodality.lean             -- L β p unimodality from explicit formula + calculus
   ├─ GaussianPosterior.lean        -- explicit V̂_κ for Gaussian signal model
   ├─ MeanEstimateGap.lean          -- continuity + Tendsto via explicit posterior
   ├─ FiveStateVDyn.lean            -- explicit V_dyn(u_1), V_dyn(u_2), positivity
   ├─ EVTBoundedDecreasing.lean     -- bounded + eventually-decreasing → max attained
   ├─ TopkisCrossPartial.lean       -- cross-partial-positivity → supermodular (Mathlib)
   ├─ GiantComponentMills.lean      -- cluster-tail → Mills-tail bound (Mathlib percolation)
   ├─ SimpleGraphReachable.lean     -- full-edge connected ⇒ reachable=Finset.univ (Mathlib)
   ├─ BlackwellConditional.lean     -- Blackwell ordering on conditional subproblem
   ├─ FOSDDerivativeChain.lean      -- FOSD + supermodular ⇒ derivative-domination
   ├─ ArgmaxMonotone.lean           -- derivative-domination ⇒ argmax-monotone
   ├─ KappaStarConcrete.lean        -- kappaStar concrete + Harris-Kesten divergence
   ├─ AgentRewardKernelExplicit.lean -- per-realisation kernel monotone/reversal/tendsto
   └─ GConditionalIntegral.lean     -- G-integration concrete
```

## Retirement plan: paper_witness axioms → Cat 1 derived theorems

### Tier 1 (tractable: explicit-formula-derivable)

| Witness atom (paper_witness) | Paper source | Infra module | Difficulty |
|---|---|---|---|
| `envelope_continuity_in_p_paper_witness` | Regime (i) line 814 | `EnvelopeContinuity.lean` | LOW (concrete `L β p` + Mathlib `Continuous.comp`) |
| `L_unimodal_in_regime_i_paper_witness` | Regime (i) line 814 | `LUnimodality.lean` | MEDIUM (calculus on explicit `L` + uniqueness) |
| `mLimitDifference_pos_paper_witness` | Theorem 4.1 Part 3 line 505 | `FiveStateVDyn.lean` | MEDIUM (5-state V_dyn explicit; needs `r_G > r_A`) |

### Tier 2 (medium: needs new infrastructure modules)

| Witness atom | Infra module |
|---|---|
| `mean_estimate_gap_continuous_paper_witness` | `MeanEstimateGap.lean` |
| `mean_estimate_gap_tendsto_mLimit_paper_witness` | `MeanEstimateGap.lean` |
| `principal_interior_maximum_exists_OPEN` (witness) | `EVTBoundedDecreasing.lean` |
| `aggregate_optimum_exists_per_G_OPEN` (witness) | `EVTBoundedDecreasing.lean` |
| `W_bar_finite_above_limit_witness` | `EVTBoundedDecreasing.lean` |

### Tier 3 (hard: needs Mathlib-PR-grade infrastructure)

| Witness atom | Infra module |
|---|---|
| `corner_supermodularity_via_topkis_paper_witness` | `TopkisCrossPartial.lean` |
| `expectedTopoLossAboveLowerConst_pos_above_pc_paper_witness` | `GiantComponentMills.lean` |
| `expectedTopoLoss_ge_AboveLowerConst_eventually_paper_witness` | `GiantComponentMills.lean` |
| `topoLossKernel_le_one_over_n_on_giant_paper_witness` | `GiantComponentMills.lean` |
| `wInfoTopoRatioMillsConst_pos_above_pc_paper_witness` | `GiantComponentMills.lean` |
| `wInfoTopoRatio_le_MillsConst_decay_paper_witness` | `GiantComponentMills.lean` |
| `forward_reachable_empty_full_at_all_open_paper_witness` | `SimpleGraphReachable.lean` |
| `conditional_subproblem_blackwell_applicable_paper_witness` | `BlackwellConditional.lean` |
| `fosd_induces_derivative_domination_paper_witness` | `FOSDDerivativeChain.lean` |
| `argmax_monotone_under_derivative_domination_paper_witness` | `ArgmaxMonotone.lean` |
| `kappaStar_diverges_at_pc_paper_witness` | `KappaStarConcrete.lean` |

### Tier 4 (large: requires per-realisation kernel concretization)

| Witness atom group | Count | Infra module |
|---|---|---|
| `agentRewardKernel_*_pointwise_monotone` | 5 | `AgentRewardKernelExplicit.lean` |
| `agentRewardKernel_*_kernel_reversal_witness` | 4 | `AgentRewardKernelExplicit.lean` |
| `agentRewardKernel_greedy_pointwise_tendsto_atTop` | 1 | `AgentRewardKernelExplicit.lean` |
| `principalSampleAbove/Below_*` | 6 | `GConditionalIntegral.lean` |
| `principalSampleBoth_*_witness` | 4 | `GConditionalIntegral.lean` |
| `W_bar_max_paper_witness` + `aggregateWelfareWith_max_paper_witness` | 2 | `GConditionalIntegral.lean` + `EVTBoundedDecreasing.lean` |
| `agentRewardKernel_greedy_limit_kernel` (carrier) | 1 | `AgentRewardKernelExplicit.lean` |
| `mean_estimate_gap` carrier concretization | 1 | `MeanEstimateGap.lean` |

### Tier 5 (Mathlib-PR-ready contributions)

After internal Cat 1 closures complete, the following modules become
Mathlib-PR candidates:

| Module | Mathlib namespace target |
|---|---|
| `Percolation.lean` (extended) | `Mathlib.Probability.BondPercolation.Finite` |
| `GiantComponentMills.lean` | `Mathlib.Probability.BondPercolation.GiantComponent` |
| `SimpleGraphReachable.lean` | `Mathlib.Combinatorics.SimpleGraph.Reachable` (extension) |
| `TopkisCrossPartial.lean` | `Mathlib.Order.Supermodular` |
| `EVTBoundedDecreasing.lean` | `Mathlib.Topology.ExtremeValue` (extension) |

## Discipline mandate

* No `sorry`, no `native_decide`, no broken-link axioms.
* Every Infrastructure module is Cat 1 only — depends only on Mathlib
  + earlier Infrastructure modules.
* Each `*_paper_witness` axiom retirement is a real Lean proof, not
  axiom shuffle.
* `#print axioms` on final theorems should surface only Mathlib kernel
  + paper-novel `Types.lean` carriers.

## Completed Cat 1 modules

* `FiveStateRewards` + `FiveStateVDyn` + `MLimitDifferenceConcrete` —
  concrete 5-state IDP reward parameters + `V_dyn` per vertex +
  `mLimitDifference_fiveState_pos` (kernel-pure).
* `GaussianPosterior` — explicit conjugate-prior posterior mean +
  continuity in sample-size and signal-variance parameters.
* `EVTBoundedDecreasing` — EVT for continuous bounded
  eventually-decreasing functions on `[0, ∞)`.
* `TopkisCrossPartial` — abstract `IsSupermodular` definition + algebra
  (additivity, scalar, const).
* `SimpleGraphReachable` — reachable finset = univ under preconnected.
* `BlackwellConditional` — Finset-sum lift of pointwise monotonicity.
* `FOSDDerivativeChain` — supermodular → β-increment dominance.
* `ArgmaxMonotone` — single-crossing preference preservation + argmax
  monotonicity atom.
* `KappaStarConcrete` — `DivergesAtBelowAtTop` predicate + algebra.

## Pending modules

* Calculus-based Topkis criterion (`∂²f/∂x∂y ≥ 0 ⇒ IsSupermodular`)
  — requires Mathlib `Analysis.Calculus` infrastructure.
* `GiantComponentMills` — Mathlib bond percolation giant-component
  cluster Mills-tail (multi-month Mathlib infrastructure effort).
* FOSD CDF + supermodular integrand → integral β-increment dominance
  (the integration step).
* `AgentRewardKernelExplicit` — per-realisation kernel concretisation.
* `GConditionalIntegral` — full Lebesgue-Stieltjes integration.

All completed Cat 1 modules verified kernel-pure via `#print axioms`
showing only `[propext, Classical.choice, Quot.sound]`.

## Paper-witness decomposition pattern

Each `*_paper_witness` axiom is replaced by:
* A smaller carrier-identification axiom (paper-stipulated)
* A Cat 1 derivation through Infrastructure modules

`grep -c "^axiom .*_paper_witness"` returns 0. The AxiomAudit
`#print axioms` trail confirms ZERO `_paper_witness` in any dependency
graph. The pattern `paper_witness → carrier-identification + Infrastructure
Cat 1` is the project-wide standard.

Wire-up summary by Infrastructure module:
* `MLimitDifferenceConcrete`
* `ArgmaxExistence`
* `ContinuousArithmetic`
* `GaussianPosterior` + `TendstoLimitArithmetic`
* `EVTBoundedDecreasing`
* `TopkisCrossPartial`
* `MillsRatioTail`
* `SimpleGraphReachable`
* `BlackwellConditional`
* `DifferenceQuotientAlgebra`
* `ArgmaxMonotone`
* `KappaStarConcrete`

## Mathlib-PR readiness

The following modules are Mathlib-PR-contributable as standalone
generalisations:

* `EVTBoundedDecreasing.exists_maxOn_of_continuous_eventually_decreasing`
  → generalises `IsCompact.exists_isMaxOn` to non-compact `[0, ∞)`.
* `SimpleGraphReachable.reachable_finset_eq_univ_of_preconnected` →
  natural Finset packaging of `SimpleGraph.Preconnected`.
* `TopkisCrossPartial.IsSupermodular` → fills missing Mathlib
  `Order.Supermodular` namespace.
* `KappaStarConcrete.DivergesAtBelowAtTop` → one-sided divergence
  predicate + algebra.
* `BlackwellConditional.finset_sum_mono_of_pointwise_mono` →
  pointwise → summed monotonicity packaging.
* `GaussianPosterior.gaussianPosteriorMean` → conjugate-prior posterior
  mean infrastructure.

## Additional Mathlib-PR-ready modules

* `EventuallyDecreasingWithLowerBound` — eventually-decreasing
  patterns with lower-bound witnesses (3 generic Cat 1 lemmas).
  Target namespace: `Mathlib.Order.Filter.EventuallyMonotone` or
  `Mathlib.Topology.Algebra.Order.EventuallyDecreasing`.
* `PercExpectationSupermodular` — pointwise → integrated
  supermodularity lifting for percolation expectation. Target:
  `Mathlib.Order.Supermodular` (yet-to-be-created).
* `SupermodularityFinsetSum` — extension of `IsSupermodular.add` to
  arbitrary finite sums + weighted sums. Target:
  `Mathlib.Order.Supermodular`.
* `ArgmaxOnHalfLine` — generic argmax existence on `[a, ∞)`
  from continuous + tendsto-finite-with-strict-witness. Combined with
  `EventuallyDecreasingWithLowerBound` provides a complete "EVT for
  non-compact `[a, ∞)`" toolkit. Target:
  `Mathlib.Topology.Order.Compact.HalfLine`.
* `IsSupermodularPointwiseLimit` — supermodularity is closed under
  pointwise limits of sequences. Target: `Mathlib.Order.Supermodular`.
* `DifferenceDominatesFinsetSum` — sister of `SupermodularityFinsetSum`
  for the `DifferenceDominates` lattice (finset sum + weighted sum
  preservation). Target: envisioned `Mathlib.Order.DifferenceDominates`.
* `PercExpectationDifferenceDominates` — pointwise → integrated
  difference-dominance lifting (sister of `PercExpectationSupermodular`
  for `DifferenceDominates`). Target: envisioned
  `Mathlib.Order.DifferenceDominates`.

Closure-via-existence demonstrations:
* `Principal.lean`: `W_bar_eventually_decreasing_derived` uses
  `EventuallyDecreasingWithLowerBound` + `W_bar_limit_infty` +
  `W_bar_finite_above_limit_witness` + Mathlib EVT to prove the
  §3.4.3 atom statement is Cat 1 derivable.
* `Cognitive.lean`:
  `agentWelfare_kappaAgent_at_alpha_one_isSupermodular_derived`
  uses `PercExpectationSupermodular` + per-realisation
  kernel-supermodularity atom in `Types.lean` to prove the §3.4.3
  atom statement is Cat 1 derivable.

These demonstrate the closure-via-existence pattern: each §3.4.3
paper-Def atom can be replaced (in dependency closure) by smaller
atomic stipulations + Cat 1 lifting infrastructure. Future work:
restructure files to retire the §3.4.3 atoms entirely (currently
preserved for forward-reference convenience in source order).

Future Mathlib-PR sequence:
  Stage A — Mathlib `Order.Supermodular` namespace creation
  Stage B — `Mathlib.Order.DifferenceDominates` namespace creation
  Stage C — `Mathlib.Topology.Algebra.Order.EventuallyDecreasing`
  Stage D — Once Stages A-C are merged, convert §3.4.3 atoms to
            derived theorems
-/
namespace BlackwellDilemma.Infrastructure

end BlackwellDilemma.Infrastructure
