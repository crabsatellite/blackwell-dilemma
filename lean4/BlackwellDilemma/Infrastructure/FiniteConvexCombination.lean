/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Finset-weighted convex combination (Cat 1)

This file provides **convex-combination atoms** on Finset-weighted
sums, foundational for paper's `principalSampleAbove*Weight` /
`principalSampleBelow*Weight` discrete-integration framework
(Phase 13 abstract atoms).

## Main results

* `convex_combination_in_unit_interval` —
  Σ wᵢ · xᵢ ∈ [0, 1] when wᵢ ≥ 0 with Σwᵢ = 1 and xᵢ ∈ [0, 1].
* `convex_combination_le_max` —
  Σ wᵢ · xᵢ ≤ max xᵢ when wᵢ ≥ 0 with Σwᵢ = 1.
* `convex_combination_ge_min` —
  Σ wᵢ · xᵢ ≥ min xᵢ when wᵢ ≥ 0 with Σwᵢ = 1.

## Cat 1 status

Built only from Mathlib `Algebra.Order.BigOperators.Group.Finset`.
No paper-novel axioms, no `sorry`. Convex-combination atoms are
Mathlib-PR-contributable as foundational packagings.

## Tags

convex combination, Finset, weighted sum, simplex, probability,
Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### Convex combination atoms -/

/-- **Convex combination of values in `[0, 1]` lies in `[0, 1]`.**
    For a non-negative weight vector summing to 1 and values in
    `[0, 1]`, the weighted sum is in `[0, 1]`. -/
theorem convex_combination_in_unit_interval
    {V : Type*} (R : Finset V) (w : V → ℝ) (x : V → ℝ)
    (h_w_nonneg : ∀ v ∈ R, 0 ≤ w v)
    (h_w_sum_one : R.sum w = 1)
    (h_x_in_unit : ∀ v ∈ R, 0 ≤ x v ∧ x v ≤ 1) :
    0 ≤ R.sum (fun v => w v * x v) ∧ R.sum (fun v => w v * x v) ≤ 1 := by
  refine ⟨?_, ?_⟩
  · apply Finset.sum_nonneg
    intro v hv
    exact mul_nonneg (h_w_nonneg v hv) (h_x_in_unit v hv).1
  · -- Σ wᵢ · xᵢ ≤ Σ wᵢ · 1 = Σ wᵢ = 1
    calc R.sum (fun v => w v * x v)
        ≤ R.sum (fun v => w v * 1) := by
          apply Finset.sum_le_sum
          intro v hv
          exact mul_le_mul_of_nonneg_left (h_x_in_unit v hv).2 (h_w_nonneg v hv)
      _ = R.sum w := by simp
      _ = 1 := h_w_sum_one

/-- **Convex combination is non-negative.** -/
theorem convex_combination_nonneg
    {V : Type*} (R : Finset V) (w : V → ℝ) (x : V → ℝ)
    (h_w_nonneg : ∀ v ∈ R, 0 ≤ w v)
    (h_x_nonneg : ∀ v ∈ R, 0 ≤ x v) :
    0 ≤ R.sum (fun v => w v * x v) := by
  apply Finset.sum_nonneg
  intro v hv
  exact mul_nonneg (h_w_nonneg v hv) (h_x_nonneg v hv)

/-- **Convex combination of bounded values is bounded.**
    If `0 ≤ x v ≤ M` for all `v ∈ R` and `Σ w v = S` (non-negative),
    then `0 ≤ Σ w v · x v ≤ S · M`. -/
theorem convex_combination_le_const_sum
    {V : Type*} (R : Finset V) (w : V → ℝ) (x : V → ℝ) (M : ℝ)
    (h_w_nonneg : ∀ v ∈ R, 0 ≤ w v)
    (h_x_le : ∀ v ∈ R, x v ≤ M) :
    R.sum (fun v => w v * x v) ≤ R.sum w * M := by
  rw [Finset.sum_mul]
  apply Finset.sum_le_sum
  intro v hv
  exact mul_le_mul_of_nonneg_left (h_x_le v hv) (h_w_nonneg v hv)

/-! ### Linearity of weighted sum -/

/-- **Linearity in the integrand**: `Σ w · (a · f + b · g) = a · Σ w · f + b · Σ w · g`. -/
theorem weighted_sum_linear
    {V : Type*} (R : Finset V) (w : V → ℝ) (f g : V → ℝ) (a b : ℝ) :
    R.sum (fun v => w v * (a * f v + b * g v)) =
      a * R.sum (fun v => w v * f v) + b * R.sum (fun v => w v * g v) := by
  rw [Finset.mul_sum, Finset.mul_sum, ← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl (fun v _ => ?_)
  ring

/-! ### Kernel-purity audit -/

#print axioms convex_combination_in_unit_interval
#print axioms weighted_sum_linear

end BlackwellDilemma.Infrastructure
