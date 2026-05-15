/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Topology.Order.Compact
import Mathlib.Topology.UnitInterval

/-!
# Extreme Value Theorem for bounded eventually-decreasing functions on `[0, ∞)`

A continuous function `f : ℝ → ℝ` that is bounded on `[0, ∞)` and
eventually decreasing (`∃ N, ∀ x ≥ N, f x ≤ f N`) attains its supremum
on `[0, ∞)`.

This is the missing piece for paper claims of the form
`∃ β_max ≥ 0, ∀ β, f β ≤ f β_max` (e.g. Blackwell-Dilemma's
`principal_interior_maximum_exists` and `aggregate_optimum_exists_per_G`)
when `f` is paper-known to be continuous + bounded + eventually
decreasing.

## Main result

* `exists_maxOn_of_continuous_eventually_decreasing` —
  `f` continuous on `[0, ∞)` + eventually decreasing past some
  `N ≥ 0` ⇒ `∃ x_max ∈ [0, ∞), ∀ x ∈ [0, ∞), f x ≤ f x_max`.

The proof reduces the problem to the compact interval `[0, N]` (where
EVT applies) by observing that the eventually-decreasing tail past `N`
is dominated by `f N`, hence the supremum on `[0, ∞)` equals the
supremum on `[0, N]`.

## Cat 1 status

Built only from Mathlib (`Mathlib.Topology.Order.Compact` + Mathlib's
EVT for continuous functions on compact intervals). No paper-novel
axioms, no `sorry`.

## Future Mathlib PR

This file is Mathlib-contributable as a generalisation of
`IsCompact.exists_isMaxOn`. Suggested namespace:
`Mathlib.Topology.Order.Compact.EventuallyDecreasing`.

## Tags

extreme value theorem, EVT, bounded, eventually decreasing,
non-compact maximum, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

open Set Topology

/-- **EVT for bounded eventually-decreasing functions on `[0, ∞)`.**
    A continuous function `f : ℝ → ℝ` that is eventually dominated by
    its value at some `N ≥ 0` (i.e. `∀ x ≥ N, f x ≤ f N`) attains its
    supremum on `[0, ∞)`.

    Proof strategy:
     * Apply Mathlib's `isCompact_Icc` + `IsCompact.exists_isMaxOn`
       to get a maximiser `x_max ∈ [0, N]` of `f` on the compact
       interval `[0, N]`.
     * For any `x ∈ [0, ∞)`: if `x ∈ [0, N]`, use the compact-interval
       maximiser; if `x > N`, use the eventually-decreasing dominance
       `f x ≤ f N ≤ f x_max` (since `N ∈ [0, N]` so `f N ≤ f x_max`).

    Cat 1: kernel-pure (no axioms beyond Mathlib EVT). -/
theorem exists_maxOn_of_continuous_eventually_decreasing
    (f : ℝ → ℝ) (N : ℝ) (hN : 0 ≤ N)
    (hf_cont : ContinuousOn f (Set.Ici 0))
    (hf_decr : ∀ x : ℝ, N ≤ x → f x ≤ f N) :
    ∃ x_max : ℝ, 0 ≤ x_max ∧ ∀ x : ℝ, 0 ≤ x → f x ≤ f x_max := by
  -- The compact interval `[0, N]` is non-empty (`0 ≤ N`).
  have h_Icc_nonempty : (Set.Icc (0 : ℝ) N).Nonempty := ⟨0, by simp [hN]⟩
  -- `f` is continuous on `[0, N] ⊆ [0, ∞)`.
  have h_cont_Icc : ContinuousOn f (Set.Icc 0 N) :=
    hf_cont.mono (fun x hx => hx.1)
  -- Apply Mathlib's compact-interval EVT.
  obtain ⟨x_max, hx_max_mem, hx_max⟩ :=
    isCompact_Icc.exists_isMaxOn h_Icc_nonempty h_cont_Icc
  refine ⟨x_max, hx_max_mem.1, ?_⟩
  intro x hx_nonneg
  by_cases h : x ≤ N
  · -- Case 1: `x ∈ [0, N]`, apply compact-interval maximiser.
    exact hx_max ⟨hx_nonneg, h⟩
  · -- Case 2: `x > N`, use eventually-decreasing dominance.
    push Not at h
    have h_x_ge_N : N ≤ x := le_of_lt h
    have h_fx_le_fN : f x ≤ f N := hf_decr x h_x_ge_N
    have h_N_mem : N ∈ Set.Icc (0 : ℝ) N := ⟨hN, le_refl N⟩
    have h_fN_le_fmax : f N ≤ f x_max := hx_max h_N_mem
    linarith

/-! ### Kernel-purity audit

`#print axioms` on `exists_maxOn_of_continuous_eventually_decreasing`
surfaces ONLY Mathlib kernel axioms (`propext, Classical.choice,
Quot.sound`) — no paper-novel `Types.lean` carriers, no broken-link
`_OPEN` axioms, no `sorry`. This is a Cat 1 EVT generalisation of
`IsCompact.exists_isMaxOn` to non-compact `[0, ∞)` under
eventually-decreasing dominance, and is Mathlib-PR-contributable. -/

#print axioms exists_maxOn_of_continuous_eventually_decreasing

end BlackwellDilemma.Infrastructure
