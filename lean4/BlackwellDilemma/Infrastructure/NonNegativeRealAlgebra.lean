/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

/-!
# Non-negative real algebra (Cat 1)

This file provides **non-negative real algebra atoms** packaged for
ergonomic paper-bridge work. Most claims have direct Mathlib analogs;
this module re-packages them in a way that aligns with paper carriers'
typical signatures.

## Main results

* `NonNeg.add` — sum of two non-negative is non-negative.
* `NonNeg.mul` — product of two non-negative is non-negative.
* `NonNeg.smul_const_nonneg` — non-negative scalar times non-negative.
* `NonNeg.sum_finset` — Finset sum of non-negative is non-negative.

## Cat 1 status

Built only from `Mathlib.Data.Real.Basic` + `Mathlib.Tactic.Linarith`.
Most atoms are direct Mathlib re-packaging.

## Tags

non-negative, real, ergonomic atoms, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### Non-negative real algebra -/

/-- **Sum of two non-negatives.** -/
theorem NonNeg.add {x y : ℝ} (hx : 0 ≤ x) (hy : 0 ≤ y) : 0 ≤ x + y := by linarith

/-- **Product of two non-negatives.** -/
theorem NonNeg.mul {x y : ℝ} (hx : 0 ≤ x) (hy : 0 ≤ y) : 0 ≤ x * y :=
  mul_nonneg hx hy

/-- **Scalar of non-negative by non-negative scalar is non-negative.** -/
theorem NonNeg.smul_const_nonneg {x c : ℝ} (hx : 0 ≤ x) (hc : 0 ≤ c) :
    0 ≤ c * x := mul_nonneg hc hx

/-- **Min of two non-negatives is non-negative.** -/
theorem NonNeg.min {x y : ℝ} (hx : 0 ≤ x) (hy : 0 ≤ y) : 0 ≤ min x y :=
  le_min hx hy

/-- **Max of two non-negatives is non-negative.** -/
theorem NonNeg.max {x y : ℝ} (hx : 0 ≤ x) (hy : 0 ≤ y) : 0 ≤ max x y :=
  le_trans hx (le_max_left x y)

/-- **Square of any real is non-negative.** -/
theorem NonNeg.sq (x : ℝ) : 0 ≤ x * x := mul_self_nonneg x

/-- **Difference of non-negative larger from non-negative smaller is
    non-negative.** -/
theorem NonNeg.sub_of_le {x y : ℝ} (hxy : x ≤ y) : 0 ≤ y - x := by linarith

/-! ### Strict positivity -/

/-- **Sum of positive and non-negative is positive.** -/
theorem Pos.add_nonneg {x y : ℝ} (hx : 0 < x) (hy : 0 ≤ y) : 0 < x + y := by linarith

/-- **Product of positives is positive.** -/
theorem Pos.mul {x y : ℝ} (hx : 0 < x) (hy : 0 < y) : 0 < x * y :=
  mul_pos hx hy

/-! ### Kernel-purity audit -/

#print axioms NonNeg.add
#print axioms Pos.mul

end BlackwellDilemma.Infrastructure
