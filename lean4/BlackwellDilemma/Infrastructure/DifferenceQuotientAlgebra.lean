/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

/-!
# Difference-quotient algebra (Cat 1)

This file provides **algebraic operations on difference quotients**
`f β₂ - f β₁`, the building blocks for monotone-comparative-statics
chains. The key insight: difference-quotient dominance composes
additively, scalar-multiplies by non-negative constants, and respects
pointwise sums.

## Main results

* `diff_dom_add` — sum of two difference-dominating pairs preserves
  dominance.
* `diff_dom_smul_nonneg` — non-negative scalar preserves dominance.
* `diff_dom_neg_swap` — negation reverses dominance direction.
* `diff_dom_const` — constant function has zero difference (reflexive).

## Bridge to comparative statics

The chain `IsSupermodular ⇒ derivative-domination ⇒ argmax-monotone`
(Phases 5/9/10) is built on these difference-quotient atoms. With the
algebra below, more complex compositions can be built modularly
(e.g., aggregateWelfareWith decomposed as integral of pointwise terms,
each with its own difference-dominance proof).

## Cat 1 status

Built only from `Mathlib.Data.Real.Basic` + `Mathlib.Tactic.Linarith`.
No paper-novel axioms, no `sorry`. The difference-quotient algebra
is foundational and Mathlib-PR-contributable.

## Tags

difference quotient, monotone comparative statics, dominance,
Topkis-style, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### Difference-dominance predicate -/

/-- **Difference dominance**: `f₁` dominates `f₂` in difference iff
    for all `β₁ ≤ β₂`, the increment of `f₂` is at most the
    increment of `f₁`. (Ordering chosen to match
    `derivative_domination_of_supermodular` in `FOSDDerivativeChain`.) -/
def DifferenceDominates (f₁ f₂ : ℝ → ℝ) : Prop :=
  ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ → f₂ β₂ - f₂ β₁ ≤ f₁ β₂ - f₁ β₁

/-! ### Reflexivity, transitivity, partial-order properties -/

/-- **Reflexivity**: any function difference-dominates itself. -/
theorem DifferenceDominates.refl (f : ℝ → ℝ) : DifferenceDominates f f :=
  fun _ _ _ => le_refl _

/-- **Transitivity**: if `f₁` dominates `f₂` and `f₂` dominates `f₃`,
    then `f₁` dominates `f₃`. -/
theorem DifferenceDominates.trans
    {f₁ f₂ f₃ : ℝ → ℝ}
    (h₁₂ : DifferenceDominates f₁ f₂) (h₂₃ : DifferenceDominates f₂ f₃) :
    DifferenceDominates f₁ f₃ := by
  intro β₁ β₂ hβ
  have h₁ := h₁₂ β₁ β₂ hβ
  have h₂ := h₂₃ β₁ β₂ hβ
  linarith

/-! ### Algebraic operations -/

/-- **Sum of two dominating pairs preserves dominance.**
    If `f₁ ≥_diff g₁` and `f₂ ≥_diff g₂`, then `f₁ + f₂ ≥_diff g₁ + g₂`. -/
theorem DifferenceDominates.add
    {f₁ g₁ f₂ g₂ : ℝ → ℝ}
    (h₁ : DifferenceDominates f₁ g₁) (h₂ : DifferenceDominates f₂ g₂) :
    DifferenceDominates (fun β => f₁ β + f₂ β) (fun β => g₁ β + g₂ β) := by
  intro β₁ β₂ hβ
  have h_a := h₁ β₁ β₂ hβ
  have h_b := h₂ β₁ β₂ hβ
  linarith

/-- **Non-negative scalar preserves dominance.** -/
theorem DifferenceDominates.smul_nonneg
    {f g : ℝ → ℝ} (h : DifferenceDominates f g) {c : ℝ} (hc : 0 ≤ c) :
    DifferenceDominates (fun β => c * f β) (fun β => c * g β) := by
  intro β₁ β₂ hβ
  have h_diff := h β₁ β₂ hβ
  -- c * g β₂ - c * g β₁ ≤ c * f β₂ - c * f β₁
  -- ⟺ c * (g β₂ - g β₁) ≤ c * (f β₂ - f β₁)
  nlinarith

/-- **Constant function has zero difference (any pair dominates const).** -/
theorem const_diff_dominated_by_any
    (f : ℝ → ℝ) (k : ℝ) (h_mono : ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ → f β₁ ≤ f β₂) :
    DifferenceDominates f (fun _ => k) := by
  intro β₁ β₂ hβ
  -- k - k = 0 ≤ f β₂ - f β₁
  have h_f := h_mono β₁ β₂ hβ
  linarith

/-- **Negation reverses dominance**: `f ≥_diff g ↔ -g ≥_diff -f`. -/
theorem DifferenceDominates.neg_swap
    {f g : ℝ → ℝ} (h : DifferenceDominates f g) :
    DifferenceDominates (fun β => -g β) (fun β => -f β) := by
  intro β₁ β₂ hβ
  have h_diff := h β₁ β₂ hβ
  linarith

/-! ### Connection to monotonicity -/

/-- **Domination of constant ⇒ monotonicity.**
    If `f` difference-dominates a constant function, then `f` is
    monotone non-decreasing. -/
theorem mono_of_diff_dominates_const
    {f : ℝ → ℝ} {k : ℝ} (h : DifferenceDominates f (fun _ => k)) :
    ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ → f β₁ ≤ f β₂ := by
  intro β₁ β₂ hβ
  have := h β₁ β₂ hβ
  -- k - k = 0 ≤ f β₂ - f β₁
  linarith

/-- **Monotonicity ⇒ difference-dominates const.** Converse. -/
theorem diff_dominates_const_of_mono
    {f : ℝ → ℝ} (h_mono : ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ → f β₁ ≤ f β₂) (k : ℝ) :
    DifferenceDominates f (fun _ => k) := by
  intro β₁ β₂ hβ
  have := h_mono β₁ β₂ hβ
  linarith

/-! ### Kernel-purity audit -/

#print axioms DifferenceDominates.add
#print axioms DifferenceDominates.trans

end BlackwellDilemma.Infrastructure
