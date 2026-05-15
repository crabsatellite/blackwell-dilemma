/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

/-!
# Unit interval `[0, 1]` algebra (Cat 1)

This file provides **arithmetic atoms on the unit interval `[0, 1]`**,
foundational for paper's `agentWelfare`, `topoLossKernel`,
`P_trap`, etc., all of which are probability-bounded.

## Main results

* `mem_unitInterval_iff` — `x ∈ [0, 1] ↔ 0 ≤ x ∧ x ≤ 1`.
* `mul_mem_unitInterval` — product of two values in `[0, 1]` is in `[0, 1]`.
* `convex_combination_in_unitInterval` —
  `α · x + (1-α) · y ∈ [0, 1]` for `α, x, y ∈ [0, 1]`.
* `one_minus_in_unitInterval` — `1 - x ∈ [0, 1]` iff `x ∈ [0, 1]`.

## Bridge to paper carriers

Paper's `agentWelfare`, `topoLossKernel`, `wInfoTopoRatio`,
`P_trap`, etc. all take values in `[0, 1]` (probabilities or
welfare-normalised quantities). The `mem_unitInterval` predicates
below provide foundational atoms for closure properties.

## Cat 1 status

Built only from `Mathlib.Data.Real.Basic` + `Mathlib.Tactic.Linarith`.
No paper-novel axioms, no `sorry`. Mathlib-PR-contributable as
elementary `Set.Icc 0 1` algebra.

## Tags

unit interval, `[0, 1]`, probability, welfare bounds, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### Membership in `[0, 1]` -/

/-- **Unit interval membership predicate.** `x ∈ [0, 1]`. -/
def InUnitInterval (x : ℝ) : Prop := 0 ≤ x ∧ x ≤ 1

/-- **Iff form for membership.** -/
theorem inUnitInterval_iff (x : ℝ) :
    InUnitInterval x ↔ 0 ≤ x ∧ x ≤ 1 := Iff.rfl

/-! ### Closure under arithmetic operations -/

/-- **Product of values in `[0, 1]` is in `[0, 1]`.** -/
theorem InUnitInterval.mul {x y : ℝ}
    (hx : InUnitInterval x) (hy : InUnitInterval y) :
    InUnitInterval (x * y) := by
  refine ⟨mul_nonneg hx.1 hy.1, ?_⟩
  calc x * y ≤ 1 * y := mul_le_mul_of_nonneg_right hx.2 hy.1
    _ = y := one_mul y
    _ ≤ 1 := hy.2

/-- **Convex combination of two values in `[0, 1]` is in `[0, 1]`.** -/
theorem InUnitInterval.convex_comb {x y α : ℝ}
    (hx : InUnitInterval x) (hy : InUnitInterval y) (hα : InUnitInterval α) :
    InUnitInterval (α * x + (1 - α) * y) := by
  refine ⟨?_, ?_⟩
  · -- Non-negativity
    have h_α_x : 0 ≤ α * x := mul_nonneg hα.1 hx.1
    have h_y : 0 ≤ (1 - α) * y := mul_nonneg (by linarith [hα.2]) hy.1
    linarith
  · -- Upper bound
    have h_α_x : α * x ≤ α := by
      calc α * x ≤ α * 1 := mul_le_mul_of_nonneg_left hx.2 hα.1
        _ = α := mul_one α
    have h_y : (1 - α) * y ≤ 1 - α := by
      calc (1 - α) * y ≤ (1 - α) * 1 :=
            mul_le_mul_of_nonneg_left hy.2 (by linarith [hα.2])
        _ = 1 - α := mul_one _
    linarith

/-- **`1 - x` is in `[0, 1]` iff `x` is in `[0, 1]`.** -/
theorem InUnitInterval.one_sub {x : ℝ} (hx : InUnitInterval x) :
    InUnitInterval (1 - x) := by
  refine ⟨?_, ?_⟩
  · linarith [hx.2]
  · linarith [hx.1]

/-- **Constant `0` is in `[0, 1]`.** -/
theorem InUnitInterval.zero : InUnitInterval (0 : ℝ) := ⟨le_refl 0, by linarith⟩

/-- **Constant `1` is in `[0, 1]`.** -/
theorem InUnitInterval.one : InUnitInterval (1 : ℝ) := ⟨by linarith, le_refl 1⟩

/-! ### Min / max preservation -/

/-- **min of two `[0, 1]` values is in `[0, 1]`.** -/
theorem InUnitInterval.min_mem {x y : ℝ}
    (hx : InUnitInterval x) (hy : InUnitInterval y) :
    InUnitInterval (min x y) := by
  refine ⟨le_min hx.1 hy.1, ?_⟩
  exact le_trans (min_le_left x y) hx.2

/-- **max of two `[0, 1]` values is in `[0, 1]`.** -/
theorem InUnitInterval.max_mem {x y : ℝ}
    (hx : InUnitInterval x) (hy : InUnitInterval y) :
    InUnitInterval (max x y) := by
  refine ⟨le_trans hx.1 (le_max_left x y), ?_⟩
  exact max_le hx.2 hy.2

/-! ### Kernel-purity audit -/

#print axioms InUnitInterval.mul
#print axioms InUnitInterval.convex_comb

end BlackwellDilemma.Infrastructure
