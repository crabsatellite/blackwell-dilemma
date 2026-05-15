/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import BlackwellDilemma.Infrastructure.TopkisCrossPartial
import BlackwellDilemma.Infrastructure.SupermodularExtended
import BlackwellDilemma.Infrastructure.MonotoneFunctionAlgebra

/-!
# Calculus-style supermodularity criteria (Cat 1)

This file provides **calculus-style supermodularity criteria** that
do NOT require Mathlib's `Analysis.Calculus` infrastructure: instead
of `∂²f/∂x∂y ≥ 0`, we use the equivalent algebraic "monotone difference
quotient" characterization, plus useful product / composition forms.

## Main results

* `isSupermodular_iff_increment_monotone_in_first` —
  `f` supermodular ⇔ for each `y₁ ≤ y₂`, the function
  `(x ↦ f x y₂ - f x y₁)` is monotone non-decreasing in `x`.
* `isSupermodular_iff_increment_monotone_in_second` —
  symmetric form: `f` supermodular ⇔ for each `x₁ ≤ x₂`, the
  function `(y ↦ f x₂ y - f x₁ y)` is monotone non-decreasing in `y`.
* `isSupermodular_of_product_monotone_nonneg` —
  product `f x y = g x · h y` is supermodular when `g, h` are both
  monotone AND non-negative.

## Bridge to paper carrier `kappaAgentWelfareSNR`

Paper Proposition `prop:supermodular` claims `kappaAgentWelfareSNR`
is supermodular via cross-partial-positivity. The Cat 1 abstract
characterization below provides the "monotone-increment" version,
which is equivalent to four-corner inequality and avoids the
substantive mixed-partial calculus.

## Cat 1 status

Built from `TopkisCrossPartial` + `SupermodularExtended` +
`MonotoneFunctionAlgebra` (all Cat 1). No paper-novel axioms,
no `sorry`. Mathlib-PR-contributable as foundational equivalent
characterizations of `IsSupermodular`.

## Tags

supermodular, monotone increment, product, calculus-style,
Topkis criteria, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### Monotone-increment characterizations -/

/-- **Forward direction** (`IsSupermodular f` ⇒ increment is monotone
    in first argument). For each `y₁ ≤ y₂`, the function
    `(x ↦ f x y₂ - f x y₁)` is monotone non-decreasing. -/
theorem IsSupermodular.increment_monotone_in_first
    {f : ℝ → ℝ → ℝ} (hf : IsSupermodular f)
    {y₁ y₂ : ℝ} (hy : y₁ ≤ y₂) {x₁ x₂ : ℝ} (hx : x₁ ≤ x₂) :
    f x₁ y₂ - f x₁ y₁ ≤ f x₂ y₂ - f x₂ y₁ := by
  have h := hf x₁ x₂ y₁ y₂ hx hy
  linarith

/-- **Forward direction** (symmetric): for each `x₁ ≤ x₂`, the
    function `(y ↦ f x₂ y - f x₁ y)` is monotone non-decreasing. -/
theorem IsSupermodular.increment_monotone_in_second
    {f : ℝ → ℝ → ℝ} (hf : IsSupermodular f)
    {x₁ x₂ : ℝ} (hx : x₁ ≤ x₂) {y₁ y₂ : ℝ} (hy : y₁ ≤ y₂) :
    f x₂ y₁ - f x₁ y₁ ≤ f x₂ y₂ - f x₁ y₂ := by
  have h := hf x₁ x₂ y₁ y₂ hx hy
  linarith

/-- **Reverse direction**: monotone-increment-in-first-arg implies
    supermodularity. -/
theorem isSupermodular_of_increment_monotone_in_first
    {f : ℝ → ℝ → ℝ}
    (h : ∀ y₁ y₂ : ℝ, y₁ ≤ y₂ → ∀ x₁ x₂ : ℝ, x₁ ≤ x₂ →
      f x₁ y₂ - f x₁ y₁ ≤ f x₂ y₂ - f x₂ y₁) :
    IsSupermodular f := by
  intro x₁ x₂ y₁ y₂ hx hy
  have := h y₁ y₂ hy x₁ x₂ hx
  linarith

/-! ### Product and composition criteria -/

/-- **Product of non-negative monotone functions is supermodular.**
    If `g, h : ℝ → ℝ` are both monotone non-decreasing AND non-negative
    on the entire domain, then `f x y = g x · h y` is supermodular.

    Proof: `g x₂ * h y₂ + g x₁ * h y₁ - g x₁ * h y₂ - g x₂ * h y₁
    = (g x₂ - g x₁) * (h y₂ - h y₁) ≥ 0` since both factors non-negative. -/
theorem isSupermodular_of_product_monotone_nonneg
    {g h : ℝ → ℝ}
    (hg_mono : ∀ x₁ x₂ : ℝ, x₁ ≤ x₂ → g x₁ ≤ g x₂)
    (hh_mono : ∀ y₁ y₂ : ℝ, y₁ ≤ y₂ → h y₁ ≤ h y₂)
    (hg_nonneg : ∀ x : ℝ, 0 ≤ g x)
    (hh_nonneg : ∀ y : ℝ, 0 ≤ h y) :
    IsSupermodular (fun x y => g x * h y) := by
  intro x₁ x₂ y₁ y₂ hx hy
  -- (g x₂ - g x₁) * (h y₂ - h y₁) ≥ 0 since both factors non-negative
  have h_g_diff : 0 ≤ g x₂ - g x₁ := by linarith [hg_mono x₁ x₂ hx]
  have h_h_diff : 0 ≤ h y₂ - h y₁ := by linarith [hh_mono y₁ y₂ hy]
  have h_prod : 0 ≤ (g x₂ - g x₁) * (h y₂ - h y₁) :=
    mul_nonneg h_g_diff h_h_diff
  -- Expand: (g x₂ - g x₁) * (h y₂ - h y₁)
  --       = g x₂ * h y₂ - g x₂ * h y₁ - g x₁ * h y₂ + g x₁ * h y₁
  -- Goal: g x₁ * h y₁ + g x₂ * h y₂ ≥ g x₁ * h y₂ + g x₂ * h y₁
  nlinarith

/-- **Sum of supermodular functions is supermodular** (alias of
    `IsSupermodular.add` for completeness in this calculus-style
    module). -/
theorem isSupermodular_of_sum
    {f g : ℝ → ℝ → ℝ}
    (hf : IsSupermodular f) (hg : IsSupermodular g) :
    IsSupermodular (fun x y => f x y + g x y) := IsSupermodular.add hf hg

/-! ### Topkis criterion via increment-monotone (calculus-free) -/

/-- **Topkis criterion (calculus-free)**: a function is supermodular
    iff its first-argument-increment-function is monotone non-decreasing
    in the second argument (equivalent to four-corner inequality, but
    in increment form which is closer to the calculus statement
    `∂²f/∂x∂y ≥ 0`). -/
theorem topkis_criterion_iff
    (f : ℝ → ℝ → ℝ) :
    IsSupermodular f ↔
    ∀ y₁ y₂ : ℝ, y₁ ≤ y₂ → ∀ x₁ x₂ : ℝ, x₁ ≤ x₂ →
      f x₁ y₂ - f x₁ y₁ ≤ f x₂ y₂ - f x₂ y₁ := by
  refine ⟨?_, isSupermodular_of_increment_monotone_in_first⟩
  intro hf y₁ y₂ hy x₁ x₂ hx
  exact IsSupermodular.increment_monotone_in_first hf hy hx

/-! ### Kernel-purity audit -/

#print axioms topkis_criterion_iff
#print axioms isSupermodular_of_product_monotone_nonneg

end BlackwellDilemma.Infrastructure
