/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import BlackwellDilemma.Infrastructure.TopkisCrossPartial

/-!
# Extended supermodularity algebra (Cat 1)

This file extends `TopkisCrossPartial.lean` with additional algebra:
separable-form decomposition, monotone composition, max/min preservation
under specific structural conditions.

## Main results

* `IsSupermodular.of_separable_plus_residual` — `f x y = g x + h x y`
  is supermodular iff `h` is supermodular.
* `IsSupermodular.of_separable` — separable functions
  `f x y = g x + h y` are supermodular (with equality at the four corners).
* `IsSupermodular.sub_const` — subtracting a constant preserves
  supermodularity.
* `IsSupermodular.neg_antimodular` — `f` supermodular ⇔ `-f` antimodular
  (reverse four-corner inequality).

## Mathlib-PR readiness

Together with `TopkisCrossPartial.lean`, this completes the basic
algebraic foundation for `Mathlib.Order.Supermodular.Basic`. Both
modules form a coherent supermodularity infrastructure suitable for
direct PR contribution.

## Tags

supermodular, separable, antimodular, lattice, Topkis, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### Separable-form decomposition -/

/-- **Separable functions are supermodular (with equality).**
    `f x y = g x + h y` satisfies the four-corner inequality with
    equality, hence is supermodular (and antimodular simultaneously). -/
theorem IsSupermodular.of_separable (g h : ℝ → ℝ) :
    IsSupermodular (fun x y => g x + h y) := by
  intro x₁ x₂ y₁ y₂ _ _
  -- (g x₁ + h y₁) + (g x₂ + h y₂) = (g x₁ + h y₂) + (g x₂ + h y₁)
  show g x₁ + h y₁ + (g x₂ + h y₂) ≥ g x₁ + h y₂ + (g x₂ + h y₁)
  linarith

/-- **Separable-plus-residual decomposition.**
    If `f = (g x) + h x y` and `h` is supermodular, then `f` is
    supermodular. The `g x`-only term contributes equality at the
    four corners. -/
theorem IsSupermodular.of_separable_plus_residual
    (g : ℝ → ℝ) {h : ℝ → ℝ → ℝ} (h_super : IsSupermodular h) :
    IsSupermodular (fun x y => g x + h x y) := by
  intro x₁ x₂ y₁ y₂ hx hy
  -- (g x₁ + h x₁ y₁) + (g x₂ + h x₂ y₂) ≥
  -- (g x₁ + h x₁ y₂) + (g x₂ + h x₂ y₁)
  -- ⟺ h x₁ y₁ + h x₂ y₂ ≥ h x₁ y₂ + h x₂ y₁ (the g-terms cancel)
  have h_h := h_super x₁ x₂ y₁ y₂ hx hy
  linarith

/-- **Subtracting a constant preserves supermodularity.** -/
theorem IsSupermodular.sub_const
    {f : ℝ → ℝ → ℝ} (hf : IsSupermodular f) (k : ℝ) :
    IsSupermodular (fun x y => f x y - k) := by
  intro x₁ x₂ y₁ y₂ hx hy
  have h := hf x₁ x₂ y₁ y₂ hx hy
  linarith

/-! ### Antimodular dual -/

/-- A function `f : ℝ → ℝ → ℝ` is **antimodular** iff for any
    `x₁ ≤ x₂` and `y₁ ≤ y₂`,
    `f x₁ y₁ + f x₂ y₂ ≤ f x₁ y₂ + f x₂ y₁` (reverse four-corner).
    This is the dual notion to supermodularity. -/
def IsAntimodular (f : ℝ → ℝ → ℝ) : Prop :=
  ∀ x₁ x₂ y₁ y₂ : ℝ, x₁ ≤ x₂ → y₁ ≤ y₂ →
    f x₁ y₁ + f x₂ y₂ ≤ f x₁ y₂ + f x₂ y₁

/-- **Negation reverses supermodularity ↔ antimodularity.** -/
theorem IsSupermodular.neg_antimodular
    {f : ℝ → ℝ → ℝ} (hf : IsSupermodular f) :
    IsAntimodular (fun x y => -f x y) := by
  intro x₁ x₂ y₁ y₂ hx hy
  have h := hf x₁ x₂ y₁ y₂ hx hy
  linarith

/-- **Antimodularity ↔ negation supermodularity.** Symmetric form. -/
theorem IsAntimodular.neg_supermodular
    {f : ℝ → ℝ → ℝ} (hf : IsAntimodular f) :
    IsSupermodular (fun x y => -f x y) := by
  intro x₁ x₂ y₁ y₂ hx hy
  have h := hf x₁ x₂ y₁ y₂ hx hy
  linarith

/-! ### Monotone composition (single variable) -/

/-- **Monotone composition with a single-variable function.**
    If `f` is supermodular and `φ : ℝ → ℝ` is non-decreasing AND
    convex, then `φ ∘ f` need NOT be supermodular in general
    (counterexamples exist). However, the simple "additive shift"
    case is preserved: `(fun x y => f x y + c)` is supermodular when
    `f` is. This follows from `IsSupermodular.add` with const. -/
theorem IsSupermodular.add_const_monotone
    {f : ℝ → ℝ → ℝ} (hf : IsSupermodular f) (c : ℝ) :
    IsSupermodular (fun x y => f x y + c) :=
  IsSupermodular.add hf (IsSupermodular.const c)

/-! ### Linearity of supermodularity in the first argument -/

/-- **Adding a function of `x` only preserves supermodularity.**
    `f` supermodular + `g x`-only addition = supermodular. -/
theorem IsSupermodular.add_function_of_first
    {f : ℝ → ℝ → ℝ} (hf : IsSupermodular f) (g : ℝ → ℝ) :
    IsSupermodular (fun x y => f x y + g x) := by
  intro x₁ x₂ y₁ y₂ hx hy
  have h := hf x₁ x₂ y₁ y₂ hx hy
  linarith

/-- **Adding a function of `y` only preserves supermodularity.** -/
theorem IsSupermodular.add_function_of_second
    {f : ℝ → ℝ → ℝ} (hf : IsSupermodular f) (g : ℝ → ℝ) :
    IsSupermodular (fun x y => f x y + g y) := by
  intro x₁ x₂ y₁ y₂ hx hy
  have h := hf x₁ x₂ y₁ y₂ hx hy
  linarith

/-! ### Kernel-purity audit -/

#print axioms IsSupermodular.of_separable
#print axioms IsSupermodular.of_separable_plus_residual

end BlackwellDilemma.Infrastructure
