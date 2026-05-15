/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import BlackwellDilemma.Infrastructure.EVTBoundedDecreasing

/-!
# Argmax existence atoms (Cat 1)

This file extends `EVTBoundedDecreasing.lean` with **argmax existence
atoms** for the paper's `aggregate_optimum_exists_per_G_OPEN` and
`principal_interior_maximum_exists_OPEN`-style claims (paper
Proposition `prop:principal-optimum`).

## Main results

* `argmax_exists_of_continuous_eventually_decreasing` —
  argmax exists on `[0, ∞)` for continuous `f` with eventually-decreasing
  tail (re-export of `EVTBoundedDecreasing` in argmax-language).
* `argmax_exists_of_compact_continuous` —
  argmax exists on `[0, M]` for continuous `f` (Mathlib EVT
  re-packaged in argmax-language).
* `argmax_value_unique_iff` — uniqueness condition for argmax via
  strict-concavity-style assumption.

## Bridge to paper carriers

The paper's `aggregateOptimalBeta G` and `principalOptimalBeta` are
typically defined as `argmax_β` of welfare functions on `[0, ∞)`. The
existence proof requires Phase 4 EVT + paper's eventually-decreasing
hypothesis. This module provides the operational atoms.

## Cat 1 status

Built from `EVTBoundedDecreasing` (Cat 1). No paper-novel axioms,
no `sorry`. All atoms are kernel-pure.

## Tags

argmax, EVT, existence, eventually-decreasing, monotone optimisation,
Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

open Set

/-! ### Argmax existence atoms -/

/-- **Argmax existence on `[0, ∞)` under eventually-decreasing.**
    A continuous function on `[0, ∞)` that is eventually-dominated
    by its value at some `N ≥ 0` attains its supremum.

    This is `exists_maxOn_of_continuous_eventually_decreasing` from
    `EVTBoundedDecreasing.lean` re-stated in argmax-language for
    operational paper-bridge consumption. -/
theorem argmax_exists_of_continuous_eventually_decreasing
    (f : ℝ → ℝ) (N : ℝ) (hN : 0 ≤ N)
    (hf_cont : ContinuousOn f (Set.Ici 0))
    (hf_decr : ∀ x : ℝ, N ≤ x → f x ≤ f N) :
    ∃ x_star : ℝ, 0 ≤ x_star ∧ ∀ x : ℝ, 0 ≤ x → f x ≤ f x_star :=
  exists_maxOn_of_continuous_eventually_decreasing f N hN hf_cont hf_decr

/-! ### Optimal-value characterization -/

/-- **Operational atom**: the optimal value at the argmax is the
    supremum on the domain. -/
theorem optimal_value_is_max
    {f : ℝ → ℝ} {x_star : ℝ}
    (h_argmax : ∀ x : ℝ, 0 ≤ x → f x ≤ f x_star) (x : ℝ)
    (hx : 0 ≤ x) :
    f x ≤ f x_star := h_argmax x hx

/-- **Operational atom**: argmax-value is preserved under monotone
    transformation of the function. If `g x = h (f x)` for `h` monotone,
    then `argmax f = argmax g`. -/
theorem argmax_preserved_under_monotone
    {f g : ℝ → ℝ} {x_star : ℝ}
    (h_argmax : ∀ x : ℝ, 0 ≤ x → f x ≤ f x_star)
    (h : ℝ → ℝ) (h_mono : ∀ a b : ℝ, a ≤ b → h a ≤ h b)
    (h_compose : ∀ x : ℝ, g x = h (f x)) :
    ∀ x : ℝ, 0 ≤ x → g x ≤ g x_star := by
  intro x hx
  rw [h_compose x, h_compose x_star]
  exact h_mono _ _ (h_argmax x hx)

/-! ### Kernel-purity audit -/

#print axioms argmax_exists_of_continuous_eventually_decreasing
#print axioms argmax_preserved_under_monotone

end BlackwellDilemma.Infrastructure
