/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Order.AbsoluteValue.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

/-!
# Absolute value bounds (Cat 1)

This file provides **`|x|` bound atoms** packaged for ergonomic
paper-bridge work involving epsilon-bounds and Tendsto manipulations.

## Main results

* `abs_le_iff_neg_le_and_le` — `|x| ≤ M ↔ -M ≤ x ∧ x ≤ M`.
* `abs_lt_of_diff_lt` — `|a - b| < ε ⇒ a < b + ε ∧ a > b - ε`.
* `abs_le_of_diff_le` — non-strict version.
* `abs_sub_swap` — `|a - b| = |b - a|`.

## Cat 1 status

Built only from Mathlib basic absolute value algebra. Most atoms are
direct re-packagings.

## Tags

absolute value, bound, epsilon, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### Absolute value bound atoms -/

/-- **|·| ≤ M characterization.** -/
theorem abs_le_iff_bound (x M : ℝ) :
    |x| ≤ M ↔ -M ≤ x ∧ x ≤ M := abs_le

/-- **|a - b| < ε ⇒ a < b + ε.** -/
theorem lt_add_of_abs_sub_lt {a b ε : ℝ} (h : |a - b| < ε) : a < b + ε := by
  have := (abs_lt.mp h).2
  linarith

/-- **|a - b| < ε ⇒ a > b - ε.** -/
theorem sub_lt_of_abs_sub_lt {a b ε : ℝ} (h : |a - b| < ε) : b - ε < a := by
  have := (abs_lt.mp h).1
  linarith

/-- **|a - b| ≤ ε ⇒ a ≤ b + ε.** -/
theorem le_add_of_abs_sub_le {a b ε : ℝ} (h : |a - b| ≤ ε) : a ≤ b + ε := by
  have := (abs_le.mp h).2
  linarith

/-- **|a - b| ≤ ε ⇒ b - ε ≤ a.** -/
theorem sub_le_of_abs_sub_le {a b ε : ℝ} (h : |a - b| ≤ ε) : b - ε ≤ a := by
  have := (abs_le.mp h).1
  linarith

/-- **Symmetry of `|·|` for differences.** -/
theorem abs_sub_swap (a b : ℝ) : |a - b| = |b - a| := abs_sub_comm a b

/-- **Triangle inequality**. -/
theorem abs_add_le_triangle (a b : ℝ) : |a + b| ≤ |a| + |b| := abs_add_le a b

/-! ### Eventually-close atoms -/

/-- **If `|f x - L| < ε` for all `x` in some set, `f x` is bounded
    above by `L + ε` and below by `L - ε`.** -/
theorem range_of_eventually_close {α : Type*} (f : α → ℝ) (L : ℝ) {ε : ℝ}
    (s : Set α) (h_close : ∀ x ∈ s, |f x - L| < ε) :
    ∀ x ∈ s, L - ε < f x ∧ f x < L + ε := by
  intro x hx
  have h_abs := abs_lt.mp (h_close x hx)
  refine ⟨?_, ?_⟩
  · linarith [h_abs.1]
  · linarith [h_abs.2]

/-! ### Kernel-purity audit -/

#print axioms abs_le_iff_bound
#print axioms range_of_eventually_close

end BlackwellDilemma.Infrastructure
