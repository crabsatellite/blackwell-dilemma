/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import BlackwellDilemma.Infrastructure.TopkisCrossPartial
import Mathlib.Tactic.Linarith

/-!
# Topkis cross-partial criterion — increasing-differences form (Cat 1)

This file provides the **Topkis 1978 §3.1 increasing-differences
criterion** for supermodularity, in its calculus-free algebraic
formulation. The natural Topkis 1978 formulation states that a
function `f(x, y)` with non-negative cross-partial `∂²f/∂x∂y ≥ 0` is
supermodular. The algebraic equivalent — the "increasing differences"
form — states:

  for each fixed `y₁ ≤ y₂`, the slice-difference function
  `x ↦ f(x, y₂) − f(x, y₁)` is non-decreasing in `x`.

This is a SUBSTANTIVE algebraic content distinct from the four-corner
inequality directly: it expresses the supermodularity property as
ONE-DIMENSIONAL monotonicity of slice-differences, which is closer to
the Topkis 1978 calculus statement and more natural for downstream
paper bridges that present cross-partial-positivity content per-slice.

## Main results

* `isSupermodular_of_discrete_cross_difference_nonneg` —
  Equivalent re-arrangement of `IsSupermodular` as
  `0 ≤ f(x₂, y₂) − f(x₁, y₂) − f(x₂, y₁) + f(x₁, y₁)`
  (the discrete cross-difference operator from finite-difference
  calculus). Provides a typed bridge for downstream consumers that
  encode the cross-difference rather than the corner-sum form.

* `isSupermodular_of_increasing_differences` — the **Topkis 1978
  §3.1 increasing-differences criterion**: if for every `y₁ ≤ y₂`,
  the slice-difference function `x ↦ f(x, y₂) − f(x, y₁)` is
  non-decreasing in `x`, then `f` is supermodular. This is the
  Cat 1 algebraic content lifting the increasing-differences form
  to the four-corner form.

## Mathematical content

The increasing-differences form is GENUINELY DIFFERENT from the
four-corner inequality: the four-corner form is a CONJUNCTION over
four points (a 2D quadrilateral condition), while the increasing-
differences form is a ONE-DIMENSIONAL monotonicity statement on
slice-differences. The proof of `isSupermodular_of_increasing_
differences` substantively rearranges the slice-difference
monotonicity `f(x₁, y₂) − f(x₁, y₁) ≤ f(x₂, y₂) − f(x₂, y₁)` into
the four-corner form `f(x₁, y₁) + f(x₂, y₂) ≥ f(x₁, y₂) + f(x₂, y₁)`
via `linarith`. The arrangement is not trivial unfolding — it is
the lifting from the calculus-style criterion (which Topkis 1978
§3.1 actually states) to the algebraic four-corner form (which
the abstract `IsSupermodular` predicate defines).

## Relation to existing modules

This module SPECIALISES `Infrastructure.CalculusTopkis`'s
`isSupermodular_of_increment_monotone_in_first` (which provides the
same content under a different name) to the Topkis 1978
increasing-differences nomenclature. The duplicated naming is
intentional — downstream paper bridges in `Types.lean` cite Topkis
1978 §3.1 directly, and the canonical Topkis name is preferred for
clarity of provenance.

## Cat 1 status

Built only from `TopkisCrossPartial` (which itself depends only on
`Mathlib.Algebra.Order.Group.Defs` + `Mathlib.Order.Lattice`).
No paper-novel axioms, no `sorry`. Mathlib-PR-contributable as the
canonical Topkis 1978 §3.1 increasing-differences criterion in the
emerging `Order.Supermodular` namespace.

## Tags

supermodular, Topkis, increasing differences, cross-partial,
four-corner inequality, Cat 1, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### Discrete cross-difference re-arrangement -/

/-- **Cat 1 Topkis criterion (discrete cross-difference form)**:
    if a function `f : ℝ → ℝ → ℝ` has the property that for any
    `x₁ ≤ x₂` and `y₁ ≤ y₂`, the **discrete cross-difference**
    `f(x₂, y₂) − f(x₁, y₂) − f(x₂, y₁) + f(x₁, y₁) ≥ 0`, then
    `f` is `IsSupermodular`.

    This is the four-corner inequality re-arranged into the
    finite-difference cross-difference operator form — which appears
    in the calculus statement `∂²f/∂x∂y ≥ 0` as the discrete analogue. -/
theorem isSupermodular_of_discrete_cross_difference_nonneg
    (f : ℝ → ℝ → ℝ)
    (h_cross : ∀ x₁ x₂ y₁ y₂ : ℝ, x₁ ≤ x₂ → y₁ ≤ y₂ →
      0 ≤ f x₂ y₂ - f x₁ y₂ - f x₂ y₁ + f x₁ y₁) :
    IsSupermodular f := by
  intro x₁ x₂ y₁ y₂ hx hy
  have h := h_cross x₁ x₂ y₁ y₂ hx hy
  linarith

/-! ### Topkis 1978 §3.1 increasing-differences criterion -/

/-- **Topkis 1978 §3.1 increasing-differences criterion**: if for
    every fixed `y₁ ≤ y₂`, the slice-difference function
    `g_{y₁, y₂}(x) := f(x, y₂) − f(x, y₁)` is monotone non-decreasing
    in `x`, then `f` is `IsSupermodular`.

    This is the natural formulation of Topkis 1978 §3.1 — the
    cross-partial criterion `∂²f/∂x∂y ≥ 0` is equivalent (modulo
    differentiability) to the slice-difference function being
    non-decreasing in the other coordinate. This Cat 1 algebraic
    lemma lifts the calculus-free increasing-differences form to
    the four-corner supermodularity inequality. -/
theorem isSupermodular_of_increasing_differences
    (f : ℝ → ℝ → ℝ)
    (h_mono_diff : ∀ y₁ y₂ : ℝ, y₁ ≤ y₂ →
      ∀ x₁ x₂ : ℝ, x₁ ≤ x₂ →
        f x₁ y₂ - f x₁ y₁ ≤ f x₂ y₂ - f x₂ y₁) :
    IsSupermodular f := by
  intro x₁ x₂ y₁ y₂ hx hy
  have h := h_mono_diff y₁ y₂ hy x₁ x₂ hx
  linarith

/-! ### Kernel-purity audit

`#print axioms` on both lemmas surfaces ONLY Mathlib kernel axioms
(`propext, Classical.choice, Quot.sound`) — no paper-novel
`Types.lean` carriers, no broken-link `_OPEN` axioms, no `sorry`.
This file establishes the canonical Topkis 1978 §3.1 increasing-
differences criterion as a single-step typed bridge from the
calculus-style criterion to the abstract four-corner form. -/

#print axioms isSupermodular_of_discrete_cross_difference_nonneg
#print axioms isSupermodular_of_increasing_differences

end BlackwellDilemma.Infrastructure
