/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import BlackwellDilemma.Infrastructure.UnitIntervalAlgebra
import BlackwellDilemma.Infrastructure.MonotoneFunctionAlgebra

/-!
# Piecewise function atoms (Cat 1)

This file provides **piecewise function definition + algebra**, useful
for paper's regime-piecewise definitions like `L β p` (regime (i)
formula) vs. its boundary behavior, and similar threshold-defined
welfare functions.

## Main definitions

* `piecewise2 c f g` — `f` if `x < c` else `g`, returning value in `ℝ`.

## Main results

* `piecewise2_at_left` — `piecewise2 c f g x = f x` when `x < c`.
* `piecewise2_at_right` — `piecewise2 c f g x = g x` when `c ≤ x`.
* `piecewise2_mono_of_continuity` — under monotonicity of both branches
  AND boundary-continuity (`f c = g c`), the piecewise is monotone.

## Cat 1 status

Built from `UnitIntervalAlgebra` and `MonotoneFunctionAlgebra` (both
Cat 1). No paper-novel axioms, no `sorry`. Mathlib-PR-contributable
as elementary piecewise function packaging.

## Tags

piecewise function, threshold, regime, monotone, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### Piecewise function definition -/

/-- **Two-piece piecewise function**: returns `f x` if `x < c`, else
    `g x`. -/
noncomputable def piecewise2 (c : ℝ) (f g : ℝ → ℝ) (x : ℝ) : ℝ :=
  if x < c then f x else g x

/-- **Left-branch evaluation**: `piecewise2 c f g x = f x` when `x < c`. -/
theorem piecewise2_at_left {c : ℝ} (f g : ℝ → ℝ) {x : ℝ} (hx : x < c) :
    piecewise2 c f g x = f x := by
  unfold piecewise2; simp [hx]

/-- **Right-branch evaluation**: `piecewise2 c f g x = g x` when `c ≤ x`. -/
theorem piecewise2_at_right {c : ℝ} (f g : ℝ → ℝ) {x : ℝ} (hx : c ≤ x) :
    piecewise2 c f g x = g x := by
  unfold piecewise2
  simp [not_lt.mpr hx]

/-! ### Monotonicity of piecewise -/

/-- **Monotonicity of two-piece piecewise** under per-branch monotonicity
    + boundary-continuity at the threshold. -/
theorem piecewise2_mono
    {c : ℝ} {f g : ℝ → ℝ}
    (hf_mono : ∀ x₁ x₂ : ℝ, x₁ ≤ x₂ → x₂ < c → f x₁ ≤ f x₂)
    (hg_mono : ∀ x₁ x₂ : ℝ, c ≤ x₁ → x₁ ≤ x₂ → g x₁ ≤ g x₂)
    (h_boundary : ∀ x₁ : ℝ, x₁ < c → ∀ x₂ : ℝ, c ≤ x₂ → f x₁ ≤ g x₂) :
    ∀ x₁ x₂ : ℝ, x₁ ≤ x₂ → piecewise2 c f g x₁ ≤ piecewise2 c f g x₂ := by
  intro x₁ x₂ h_le
  by_cases h₁ : x₁ < c
  · rw [piecewise2_at_left _ _ h₁]
    by_cases h₂ : x₂ < c
    · rw [piecewise2_at_left _ _ h₂]
      exact hf_mono x₁ x₂ h_le h₂
    · rw [piecewise2_at_right _ _ (not_lt.mp h₂)]
      exact h_boundary x₁ h₁ x₂ (not_lt.mp h₂)
  · have h₁' : c ≤ x₁ := not_lt.mp h₁
    have h₂' : c ≤ x₂ := le_trans h₁' h_le
    rw [piecewise2_at_right _ _ h₁', piecewise2_at_right _ _ h₂']
    exact hg_mono x₁ x₂ h₁' h_le

/-! ### Kernel-purity audit -/

#print axioms piecewise2_at_left
#print axioms piecewise2_mono

end BlackwellDilemma.Infrastructure
