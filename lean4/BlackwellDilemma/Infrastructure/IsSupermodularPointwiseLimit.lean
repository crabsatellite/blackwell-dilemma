/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import BlackwellDilemma.Infrastructure.TopkisCrossPartial
import Mathlib.Topology.Order.Basic
import Mathlib.Order.Filter.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Topology.MetricSpace.Basic
import Mathlib.Topology.Algebra.Order.Field

/-!
# Pointwise-limit preservation of supermodularity (Cat 1)

This module provides the Mathlib-PR-ready lemma:
**The pointwise limit of a sequence of supermodular functions is
supermodular** (provided the limit exists at every point).

This generalises the algebraic preservation lemmas in
`TopkisCrossPartial.lean` (`add`, `smul_nonneg`, `const`) to
non-algebraic preservation under topological limits — useful for
deriving supermodularity of approximation limits, integrals of
parameterised supermodular kernels, etc.

## Main result

* `IsSupermodular.of_tendsto_pointwise` — `(∀ n, IsSupermodular (f n))`
  AND `(∀ x y, Tendsto (fun n => f n x y) atTop (nhds (g x y)))`
  ⇒ `IsSupermodular g`.

## Cat 1 status

Built only from `TopkisCrossPartial` + `Mathlib.Order.Filter.Basic` +
`Mathlib.Topology.Order.Basic`. Kernel-pure (`#print axioms` shows
only `[propext, Classical.choice, Quot.sound]`). No paper-novel
axioms, no `sorry`. Generic on `ℝ → ℝ → ℝ`.

## Future Mathlib PR

Suggested namespace: `Mathlib.Order.Supermodular` (yet-to-be-created).
This is the canonical "limit-preserves-supermodularity" lemma for the
abstract supermodularity framework.

## Tags

supermodular, tendsto, pointwise limit, preservation, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

open Filter Topology

/-- **Pointwise-limit preservation of supermodularity**:
    if `f n` is supermodular for every `n`, AND the pointwise limit
    `g x y = limₙ f n x y` exists at every `(x, y)`, then `g` is
    supermodular.

    Proof: the four-corner inequality `f n x₁ y₁ + f n x₂ y₂ ≥
    f n x₁ y₂ + f n x₂ y₁` holds for every `n`; passing to the
    pointwise limit (using `Filter.Tendsto.add` for the LHS and RHS
    sums + `le_of_tendsto_of_tendsto'` for the limit-preservation of
    `≥`) gives the four-corner inequality for `g`. -/
theorem IsSupermodular.of_tendsto_pointwise
    (f : ℕ → ℝ → ℝ → ℝ) (g : ℝ → ℝ → ℝ)
    (hf : ∀ n : ℕ, IsSupermodular (f n))
    (h_tendsto : ∀ x y : ℝ,
      Filter.Tendsto (fun n => f n x y) Filter.atTop (nhds (g x y))) :
    IsSupermodular g := by
  intro x₁ x₂ y₁ y₂ hx hy
  -- LHS and RHS of the four-corner inequality at each n.
  have h_n : ∀ n : ℕ, f n x₁ y₂ + f n x₂ y₁ ≤ f n x₁ y₁ + f n x₂ y₂ := by
    intro n
    exact hf n x₁ x₂ y₁ y₂ hx hy
  -- Tendsto for both sides.
  have h_lhs_tendsto :
      Filter.Tendsto (fun n => f n x₁ y₂ + f n x₂ y₁) Filter.atTop
        (nhds (g x₁ y₂ + g x₂ y₁)) :=
    (h_tendsto x₁ y₂).add (h_tendsto x₂ y₁)
  have h_rhs_tendsto :
      Filter.Tendsto (fun n => f n x₁ y₁ + f n x₂ y₂) Filter.atTop
        (nhds (g x₁ y₁ + g x₂ y₂)) :=
    (h_tendsto x₁ y₁).add (h_tendsto x₂ y₂)
  -- Apply Mathlib's `le_of_tendsto_of_tendsto'` to lift `≤` from the
  -- per-n inequality to the pointwise-limit inequality.
  exact le_of_tendsto_of_tendsto' h_lhs_tendsto h_rhs_tendsto h_n

/-! ### Kernel-purity audit

`#print axioms` on `IsSupermodular.of_tendsto_pointwise` surfaces ONLY
Mathlib kernel axioms (`propext, Classical.choice, Quot.sound`) — no
paper-novel `Types.lean` carriers, no broken-link `_OPEN` axioms, no
`sorry`. This is a Cat 1 generic limit-preservation lemma,
Mathlib-PR-contributable as the canonical "supermodularity is closed
under pointwise limits" theorem for the abstract `Order.Supermodular`
namespace. -/

#print axioms IsSupermodular.of_tendsto_pointwise

end BlackwellDilemma.Infrastructure
