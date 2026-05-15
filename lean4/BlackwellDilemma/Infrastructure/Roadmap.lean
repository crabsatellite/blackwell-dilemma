/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

/-!
# Full Cat 1 Cover Roadmap — Blackwell-Dilemma Lean Formalisation

This file is the **architectural blueprint** for retiring every
paper-stipulated `*_paper_witness` axiom (R104-R121 batch) into
**genuine Cat 1 derived theorems** built from concrete Mathlib +
finite-instance infrastructure.

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
└─ Infrastructure/             -- ★ NEW: Cat 1 only, Mathlib-contributable
   ├─ Roadmap.lean             -- this file
   ├─ EnvelopeContinuity.lean  -- Phase 1: overshootRegimeI continuity from explicit L formula
   ├─ LUnimodality.lean        -- Phase 1: L β p unimodality from explicit formula + calculus
   ├─ GaussianPosterior.lean   -- Phase 2: explicit V̂_κ for Gaussian signal model
   ├─ MeanEstimateGap.lean     -- Phase 2: continuity + Tendsto via explicit posterior
   ├─ FiveStateVDyn.lean       -- Phase 3: explicit V_dyn(u_1), V_dyn(u_2), positivity
   ├─ EVTBoundedDecreasing.lean-- Phase 4: bounded + eventually-decreasing → max attained
   ├─ TopkisCrossPartial.lean  -- Phase 5: cross-partial-positivity → supermodular (Mathlib)
   ├─ GiantComponentMills.lean -- Phase 6: cluster-tail → Mills-tail bound (Mathlib percolation)
   ├─ SimpleGraphReachable.lean-- Phase 7: full-edge connected ⇒ reachable=Finset.univ (Mathlib)
   ├─ BlackwellConditional.lean-- Phase 8: Blackwell ordering on conditional subproblem
   ├─ FOSDDerivativeChain.lean -- Phase 9: FOSD + supermodular ⇒ derivative-domination
   ├─ ArgmaxMonotone.lean      -- Phase 10: derivative-domination ⇒ argmax-monotone
   ├─ KappaStarConcrete.lean   -- Phase 11: kappaStar concrete + Harris-Kesten divergence
   ├─ AgentRewardKernelExplicit.lean -- Phase 12: per-realisation kernel monotone/reversal/tendsto
   └─ GConditionalIntegral.lean-- Phase 13: G-integration concrete (R92/R93/R94/R95/R96/R101 retire)
```

## Retirement plan: 17 paper_witness axioms → Cat 1 derived theorems

### Tier 1 (tractable: explicit-formula-derivable)

| Witness atom (paper_witness) | Paper source | Phase | Infra module | Difficulty |
|---|---|---|---|---|
| `envelope_continuity_in_p_paper_witness` | Regime (i) line 814 | 1 | `EnvelopeContinuity.lean` | LOW (concrete `L β p` + Mathlib `Continuous.comp`) |
| `L_unimodal_in_regime_i_paper_witness` | Regime (i) line 814 | 1 | `LUnimodality.lean` | MEDIUM (calculus on explicit `L` + uniqueness) |
| `mLimitDifference_pos_paper_witness` | Theorem 4.1 Part 3 line 505 | 3 | `FiveStateVDyn.lean` | MEDIUM (5-state V_dyn explicit; needs `r_G > r_A`) |

### Tier 2 (medium: needs new infrastructure modules)

| Witness atom | Phase | Infra module |
|---|---|---|
| `mean_estimate_gap_continuous_paper_witness` | 2 | `MeanEstimateGap.lean` |
| `mean_estimate_gap_tendsto_mLimit_paper_witness` | 2 | `MeanEstimateGap.lean` |
| `principal_interior_maximum_exists_OPEN` (witness) | 4 | `EVTBoundedDecreasing.lean` |
| `aggregate_optimum_exists_per_G_OPEN` (witness) | 4 | `EVTBoundedDecreasing.lean` |
| `W_bar_finite_above_limit_witness` | 4 | `EVTBoundedDecreasing.lean` |

### Tier 3 (hard: needs Mathlib-PR-grade infrastructure)

| Witness atom | Phase | Infra module |
|---|---|---|
| `corner_supermodularity_via_topkis_paper_witness` | 5 | `TopkisCrossPartial.lean` |
| `expectedTopoLossAboveLowerConst_pos_above_pc_paper_witness` | 6 | `GiantComponentMills.lean` |
| `expectedTopoLoss_ge_AboveLowerConst_eventually_paper_witness` | 6 | `GiantComponentMills.lean` |
| `topoLossKernel_le_one_over_n_on_giant_paper_witness` | 6 | `GiantComponentMills.lean` |
| `wInfoTopoRatioMillsConst_pos_above_pc_paper_witness` | 6 | `GiantComponentMills.lean` |
| `wInfoTopoRatio_le_MillsConst_decay_paper_witness` | 6 | `GiantComponentMills.lean` |
| `forward_reachable_empty_full_at_all_open_paper_witness` | 7 | `SimpleGraphReachable.lean` |
| `conditional_subproblem_blackwell_applicable_paper_witness` | 8 | `BlackwellConditional.lean` |
| `fosd_induces_derivative_domination_paper_witness` | 9 | `FOSDDerivativeChain.lean` |
| `argmax_monotone_under_derivative_domination_paper_witness` | 10 | `ArgmaxMonotone.lean` |
| `kappaStar_diverges_at_pc_paper_witness` | 11 | `KappaStarConcrete.lean` |

### Tier 4 (large: requires per-realisation kernel concretization)

| Witness atom group | Count | Phase | Infra module |
|---|---|---|---|
| `agentRewardKernel_*_pointwise_monotone` (R88/R89) | 5 | 12 | `AgentRewardKernelExplicit.lean` |
| `agentRewardKernel_*_kernel_reversal_witness` (R90) | 4 | 12 | `AgentRewardKernelExplicit.lean` |
| `agentRewardKernel_greedy_pointwise_tendsto_atTop` (R103) | 1 | 12 | `AgentRewardKernelExplicit.lean` |
| `principalSampleAbove/Below_*` (R92/R101) | 6 | 13 | `GConditionalIntegral.lean` |
| `principalSampleBoth_*_witness` (R93/R94/R95/R96) | 4 | 13 | `GConditionalIntegral.lean` |
| `W_bar_max_paper_witness` + `aggregateWelfareWith_max_paper_witness` (R104/R105) | 2 | 13 | `GConditionalIntegral.lean` + `EVTBoundedDecreasing.lean` |
| `agentRewardKernel_greedy_limit_kernel` (R103 carrier) | 1 | 12 | `AgentRewardKernelExplicit.lean` |
| `mean_estimate_gap` carrier concretization | 1 | 2 | `MeanEstimateGap.lean` |

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

Per `feedback_truth_over_publication` + `feedback_gap_ledger_in_lean4`:
* No `sorry`, no `native_decide`, no broken-link axioms.
* Every Infrastructure module is Cat 1 only — depends only on Mathlib
  + earlier Infrastructure modules.
* Each `*_paper_witness` axiom retirement is a real Lean proof, not
  axiom shuffle.
* `#print axioms` on final theorems should surface only Mathlib kernel
  + paper-novel `Types.lean` carriers.

## Phase 1 starting point (this commit)

This file is the architectural skeleton; concrete implementation
begins with Phase 1 in `EnvelopeContinuity.lean` and `LUnimodality.lean`,
both unlocked by existing `Canonical.lean` infrastructure
(`L β p`, `P_trap β`, `Phi_B β` all concrete + Mathlib `Phi`,
`signalVariance` continuity already proved in `ClassicalResults.lean`).
-/
namespace BlackwellDilemma.Infrastructure

end BlackwellDilemma.Infrastructure
