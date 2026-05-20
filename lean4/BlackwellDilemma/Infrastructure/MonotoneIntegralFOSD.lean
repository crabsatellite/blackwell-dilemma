/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import BlackwellDilemma.Infrastructure.BlackwellConditional
import BlackwellDilemma.Infrastructure.DifferenceQuotientAlgebra
import Mathlib.Tactic.Ring

/-!
# FOSD-style Finset-weighted dominance (Cat 1)

This file provides the **abstract Finset-weighted FOSD-style dominance**,
which is the discrete-version of the integration step needed for paper's
`fosd_induces_derivative_domination_paper_witness` axiom.

The full measure-theoretic version (`∫ f dG₁ ≤ ∫ f dG₂` under FOSD `G₁ ≤_FOSD G₂`
and monotone `f`) requires Mathlib's `MeasureTheory.Integral` infrastructure.
Here we provide the elementary discrete analog over Finset-weighted sums,
which is sufficient for finite-sample paper-bridge applications and is
Mathlib-PR-contributable as a stand-alone result.

## Main results

* `weighted_sum_mono_under_weight_fosd` — for non-negative weights
  `w₁ ≤ w₂` (pointwise) on a finite index set, the weighted sum
  `Σ wᵢ · f(i)` is monotone in the weights when `f` is non-negative.
* `weighted_sum_mono_under_pointwise` — for fixed weights, the weighted
  sum is monotone in the integrand.
* `difference_dominates_via_weighted_sum` — pointwise difference-dominance
  lifts to weighted-sum difference-dominance.

## Bridge to paper carrier `aggregateWelfareWith`

The paper's `aggregateWelfareWith G β = ∫ agentWelfare β κ d(G κ)` is
constructed as integration of `agentWelfare β κ` against the CDF G.
The FOSD `G₁ ≤_FOSD G₂` (`∀ x, G₁(x) ≥ G₂(x)`) plus monotonic `agentWelfare β κ`
in κ implies `∫ agentWelfare β κ d(G₁ κ) ≤ ∫ agentWelfare β κ d(G₂ κ)`
by integration-by-parts on the Stieltjes integral. The discrete weighted
sum below provides the Cat 1 atom; the substantive Stieltjes IBP step
remains a Cat 2 dependency.

## Cat 1 status

Built from `BlackwellConditional` and `DifferenceQuotientAlgebra`, both
Cat 1. No paper-novel axioms, no `sorry`. The atoms below are
Mathlib-PR-contributable as basic Finset-sum monotonicity packagings.

## Tags

FOSD, integral dominance, weighted sum, Finset, comparative statics,
Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### Weighted-sum monotonicity in weights (FOSD analog) -/

/-- **Weighted-sum monotonicity in non-negative weight increments.**
    For a non-negative integrand `f` and weights `w₁ ≤ w₂` pointwise
    on a finite index set, `Σ w₁ᵢ · f(i) ≤ Σ w₂ᵢ · f(i)`.

    This is the discrete FOSD-style "more weight on positive things"
    monotonicity. -/
theorem weighted_sum_mono_under_weight_fosd
    {V : Type*} (R : Finset V)
    (w₁ w₂ : V → ℝ) (f : V → ℝ)
    (h_w_le : ∀ v ∈ R, w₁ v ≤ w₂ v)
    (h_f_nonneg : ∀ v ∈ R, 0 ≤ f v) :
    R.sum (fun v => w₁ v * f v) ≤ R.sum (fun v => w₂ v * f v) := by
  apply Finset.sum_le_sum
  intro v hv
  exact mul_le_mul_of_nonneg_right (h_w_le v hv) (h_f_nonneg v hv)

/-- **Weighted-sum monotonicity in non-negative integrand increments.**
    For non-negative weights `w` and integrands `f₁ ≤ f₂` pointwise,
    `Σ w · f₁ ≤ Σ w · f₂`. -/
theorem weighted_sum_mono_under_pointwise
    {V : Type*} (R : Finset V)
    (w : V → ℝ) (f₁ f₂ : V → ℝ)
    (h_w_nonneg : ∀ v ∈ R, 0 ≤ w v)
    (h_f_le : ∀ v ∈ R, f₁ v ≤ f₂ v) :
    R.sum (fun v => w v * f₁ v) ≤ R.sum (fun v => w v * f₂ v) := by
  apply Finset.sum_le_sum
  intro v hv
  exact mul_le_mul_of_nonneg_left (h_f_le v hv) (h_w_nonneg v hv)

/-! ### Difference-dominance lifts to weighted sums -/

/-- **Difference-dominance lifts to weighted sums** (with non-negative
    weights). If for every `v`, the function `(fun β => f₂ v β)`
    difference-dominates `(fun β => f₁ v β)`, then with non-negative
    weights `w`, `(fun β => Σ w v · f₂ v β)` difference-dominates
    `(fun β => Σ w v · f₁ v β)`. -/
theorem difference_dominates_via_weighted_sum
    {V : Type*} (R : Finset V)
    (w : V → ℝ) (f₁ f₂ : V → ℝ → ℝ)
    (h_w_nonneg : ∀ v ∈ R, 0 ≤ w v)
    (h_dom : ∀ v ∈ R, DifferenceDominates (f₂ v) (f₁ v)) :
    DifferenceDominates
      (fun β => R.sum (fun v => w v * f₂ v β))
      (fun β => R.sum (fun v => w v * f₁ v β)) := by
  intro β₁ β₂ hβ
  -- Equivalent: Σ (w v · f₁ v β₂) - Σ (w v · f₁ v β₁) ≤
  --            Σ (w v · f₂ v β₂) - Σ (w v · f₂ v β₁)
  -- Use linearity: each side = Σ (w v · (f v β₂ - f v β₁))
  have h_lift : ∀ v ∈ R,
      w v * f₁ v β₂ - w v * f₁ v β₁ ≤
      w v * f₂ v β₂ - w v * f₂ v β₁ := by
    intro v hv
    have h_dom_v := h_dom v hv β₁ β₂ hβ
    have h_lhs :
        w v * f₁ v β₂ - w v * f₁ v β₁ = w v * (f₁ v β₂ - f₁ v β₁) := by ring
    have h_rhs :
        w v * f₂ v β₂ - w v * f₂ v β₁ = w v * (f₂ v β₂ - f₂ v β₁) := by ring
    rw [h_lhs, h_rhs]
    exact mul_le_mul_of_nonneg_left h_dom_v (h_w_nonneg v hv)
  -- Sum over R: linarith from Finset.sum_le_sum on h_lift
  have h_sum_le :
      R.sum (fun v => w v * f₁ v β₂ - w v * f₁ v β₁) ≤
      R.sum (fun v => w v * f₂ v β₂ - w v * f₂ v β₁) :=
    Finset.sum_le_sum h_lift
  have h_lhs_eq :
      R.sum (fun v => w v * f₁ v β₂ - w v * f₁ v β₁) =
      R.sum (fun v => w v * f₁ v β₂) - R.sum (fun v => w v * f₁ v β₁) := by
    rw [eq_sub_iff_add_eq, ← Finset.sum_add_distrib]
    refine Finset.sum_congr rfl (fun v _ => ?_)
    ring
  have h_rhs_eq :
      R.sum (fun v => w v * f₂ v β₂ - w v * f₂ v β₁) =
      R.sum (fun v => w v * f₂ v β₂) - R.sum (fun v => w v * f₂ v β₁) := by
    rw [eq_sub_iff_add_eq, ← Finset.sum_add_distrib]
    refine Finset.sum_congr rfl (fun v _ => ?_)
    ring
  linarith

/-! ### Kernel-purity audit -/

#print axioms weighted_sum_mono_under_weight_fosd
#print axioms difference_dominates_via_weighted_sum

end BlackwellDilemma.Infrastructure
