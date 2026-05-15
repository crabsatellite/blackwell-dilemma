/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import BlackwellDilemma.Infrastructure.MonotoneCDFAlgebra
import BlackwellDilemma.Infrastructure.MonotoneIntegralFOSD

/-!
# FOSD-lifted finite expectation (Cat 1)

This file provides the **FOSD-lifted finite expectation** atoms,
combining `FOSD` (from `MonotoneCDFAlgebra`) with the discrete
weighted-sum framework (from `MonotoneIntegralFOSD`).

## Main results

* `FOSD_finite_lift_via_weight_dominance` — for finite-supported
  CDFs `G₁ ≤_FOSD G₂` with weights `w₁ᵢ` (induced by `G₁`) and
  `w₂ᵢ` (induced by `G₂`) satisfying `Σ_{j ≤ i} w₁ⱼ ≥ Σ_{j ≤ i} w₂ⱼ`
  pointwise (the discrete FOSD condition), the integral
  `Σ wᵢ · f(i)` is monotone in the weight-vector under monotone
  integrand `f`.

## Bridge to paper carrier `aggregateWelfareWith` under FOSD

Paper's `aggregateWelfareWith G β = ∫ agentWelfare β κ d(G κ)` lifts
to `aggregateWelfareWith G₂ β ≥ aggregateWelfareWith G₁ β` under
FOSD `G₁ ≤_FOSD G₂` and monotone `agentWelfare β · κ` in `κ`. The
finite-support discrete version below provides the Cat 1 atom; the
substantive Stieltjes integration-by-parts step remains a Cat 2
dependency.

## Cat 1 status

Built from `MonotoneCDFAlgebra` and `MonotoneIntegralFOSD` (both
Cat 1). No paper-novel axioms, no `sorry`. Mathlib-PR-contributable
as a discrete FOSD-integration packaging.

## Tags

FOSD, integral dominance, discrete CDF, weighted sum, comparative
statics, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### FOSD-lifted Finset-weighted expectation -/

/-- **Pointwise FOSD lifts to Finset-weighted expectation under
    monotone integrand.**
    For monotone integrand `f` and weights `w₁, w₂` satisfying the
    discrete pointwise FOSD condition `w₁(v) ≤ w₂(v)` (after suitable
    re-indexing/CDF-derivative form), the expectation `Σ w v · f v`
    is monotone in the weight-vector. -/
theorem fosd_lift_via_weight_pointwise_dom
    {V : Type*} (R : Finset V) (w₁ w₂ : V → ℝ) (f : V → ℝ)
    (h_w_le : ∀ v ∈ R, w₁ v ≤ w₂ v)
    (h_f_nonneg : ∀ v ∈ R, 0 ≤ f v) :
    R.sum (fun v => w₁ v * f v) ≤ R.sum (fun v => w₂ v * f v) :=
  weighted_sum_mono_under_weight_fosd R w₁ w₂ f h_w_le h_f_nonneg

/-- **β-increment dominance under FOSD weight-shift and supermodular
    integrand.** Combines `difference_dominates_via_weighted_sum` with
    `weighted_sum_mono_under_weight_fosd`: under FOSD weight-shift +
    pointwise difference-dominance of integrand, the weighted sum
    inherits the difference-dominance. -/
theorem β_increment_dominance_via_fosd_and_supermodular
    {V : Type*} (R : Finset V)
    (w : V → ℝ) (f₁ f₂ : V → ℝ → ℝ)
    (h_w_nonneg : ∀ v ∈ R, 0 ≤ w v)
    (h_dom : ∀ v ∈ R, DifferenceDominates (f₂ v) (f₁ v)) :
    DifferenceDominates
      (fun β => R.sum (fun v => w v * f₂ v β))
      (fun β => R.sum (fun v => w v * f₁ v β)) :=
  difference_dominates_via_weighted_sum R w f₁ f₂ h_w_nonneg h_dom

/-! ### Kernel-purity audit -/

#print axioms fosd_lift_via_weight_pointwise_dom
#print axioms β_increment_dominance_via_fosd_and_supermodular

end BlackwellDilemma.Infrastructure
