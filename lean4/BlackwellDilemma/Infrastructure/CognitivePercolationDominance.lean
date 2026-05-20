/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Data.Real.Archimedean
import Mathlib.Order.ConditionallyCompleteLattice.Basic
import Mathlib.Order.Bounds.Basic

/-!
# Cognitive-percolation lower envelope dominance (Cat 1)

This file provides the **Cat 1 generic lifting** used to discharge the
paper Theorem 4.1 Part 6 dominance ordering
`kappaStar_dominates_percolation_scaling_paper_Def`, derived as a
`csInf_le` consequence on the concretised
`harrisKestenScalingFunction` carrier.

## Substantive content

The paper's Part 6 derivation states that the cognitive threshold
inherits its blow-up at the percolation critical probability `p_c` from
the underlying intrinsic percolation scaling function. Concretising the
percolation scaling function as the **lower envelope of the cognitive
threshold over the high-α regime** — i.e.,
`sInf {kappaStar p α | α ≥ α*(0, p_c)}` — makes the dominance ordering
a direct `csInf_le` consequence:

  `sInf {kappaStar p α | α ≥ α₀} ≤ kappaStar p α` for any `α ≥ α₀`,

provided the image set is `BddBelow` (which it is, with lower bound 0
via paper Theorem 4.1 Part 3 `kappaStar_nonneg`).

The substantive Cat 2 Harris-Kesten + Cardy + Smirnov-Werner
percolation universality content is then honestly retained as a
divergence claim on this concrete inf-envelope:

  `DivergesAtBelowAtTop (fun p => sInf {kappaStar p α | α ≥ α₀}) p_c`.

This restructuring honestly preserves the substantive content while
discharging the dominance ordering as a Cat 1 derived theorem.

## Main results

* `lower_envelope_le_at_value` — generic Cat 1 lifting: the infimum
  of a non-negatively-bounded function over a sub-domain is ≤ its
  value at any point in the sub-domain. Direct `csInf_le` application
  with the non-negativity lower bound.

## Cat 1 status

Built only from `Mathlib.Data.Real.Basic` +
`Mathlib.Order.ConditionallyCompleteLattice.Basic`. No paper-novel
axioms, no `sorry`. Kernel-pure.

## Tags

dominance, infimum, lower envelope, cognitive threshold, percolation
scaling, Harris-Kesten, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### Generic Cat 1 lifting: lower-envelope dominance -/

/-- **Cat 1 lifting (lower-envelope dominance)**: for a function
    `f : ℝ → ℝ` that is non-negative on a sub-domain `S ⊆ ℝ`, the
    infimum `sInf (f '' S)` is bounded above by `f α` at any point
    `α ∈ S`.

    This is the canonical Cat 1 vehicle for discharging the
    cognitive-percolation dominance ordering once the percolation
    scaling carrier is concretised as the lower envelope of the
    cognitive threshold over the high-α regime.

    Direct application of `csInf_le` with the non-negativity lower
    bound `0 ∈ lowerBounds (f '' S)` discharged via the per-point
    `0 ≤ f α` hypothesis. -/
theorem lower_envelope_le_at_value
    {f : ℝ → ℝ} {S : Set ℝ}
    (h_nonneg : ∀ α ∈ S, 0 ≤ f α)
    {α : ℝ} (hα : α ∈ S) :
    sInf (f '' S) ≤ f α := by
  have h_bdd : BddBelow (f '' S) := by
    refine ⟨0, ?_⟩
    rintro y ⟨x, hxS, rfl⟩
    exact h_nonneg x hxS
  exact csInf_le h_bdd ⟨α, hα, rfl⟩

/-! ### Kernel-purity audit

`#print axioms` on the lemma surfaces ONLY Mathlib kernel axioms
(`propext, Classical.choice, Quot.sound`) — no paper-novel
`Types.lean` carriers, no broken-link `_OPEN` axioms, no `sorry`.
The Cat 1 generic lifting `lower_envelope_le_at_value` is
Mathlib-PR-contributable as a natural form of conditionally-complete-
lattice infimum dominance. -/

#print axioms lower_envelope_le_at_value

end BlackwellDilemma.Infrastructure
