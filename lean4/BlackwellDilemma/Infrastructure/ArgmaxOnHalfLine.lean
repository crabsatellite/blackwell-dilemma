/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import BlackwellDilemma.Infrastructure.EventuallyDecreasingWithLowerBound
import Mathlib.Topology.Order.Compact

/-!
# Argmax existence on `[a, ∞)` from continuous + tendsto-with-witness (Cat 1)

This module provides the generic Mathlib-PR-ready theorem:
**A continuous function `f : ℝ → ℝ` on `[a, ∞)` that tends to a
finite limit `L` at infinity, with some witness `x_high ∈ [a, ∞)`
satisfying `L < f x_high`, attains its supremum on `[a, ∞)`.**

This is the canonical optimization pattern for "interior maximum
exists" arguments, generalising the BlackwellDilemma-specific
`exists_maxOn_of_continuous_eventually_decreasing` (in
`EVTBoundedDecreasing.lean`) by replacing the eventually-decreasing
hypothesis with the more natural pair (tendsto-finite-limit +
witness-strictly-above-limit).

## Main result

* `argmax_on_Ici_of_tendsto_lt_witness` —
  for `f : ℝ → ℝ` continuous on `[a, ∞)`, `Tendsto f atTop (nhds L)`,
  AND `∃ x_high ∈ [a, ∞), L < f x_high`,
  ⇒ `∃ x_max ∈ [a, ∞), ∀ x ∈ [a, ∞), f x ≤ f x_max`.

## Proof strategy

1. From `eventually_le_of_tendsto_lt_witness`: get `N₀` such
   that `f x ≤ f x_high` for all `x ≥ N₀`.
2. Set `Nupper = max(x_high, N₀)`; both `x_high ≤ Nupper` and
   `N₀ ≤ Nupper`.
3. Apply Mathlib's `IsCompact.exists_isMaxOn` on the compact interval
   `[a, Nupper]` (assuming `a ≤ x_high ≤ Nupper`) to get a maximizer
   `x_max ∈ [a, Nupper]`.
4. For any `x ∈ [a, ∞)`: case-split on `x ≤ Nupper` (use argmax) or
   `x > Nupper ≥ N₀` (use `eventually_le_of_tendsto_lt_witness`
   + argmax dominance at `x_high`).

## Cat 1 status

Built only from `eventually_le_of_tendsto_lt_witness` + Mathlib.
Kernel-pure (`#print axioms` shows
only `[propext, Classical.choice, Quot.sound]`). No paper-novel
axioms, no `sorry`. Generic on `ℝ` (could extend to ordered metric
spaces).

## Future Mathlib PR

Suggested namespace: `Mathlib.Topology.Order.Compact.HalfLine` or
`Mathlib.Topology.Algebra.Order.ExtremeValueExtended`. Combined with
`eventually_le_of_tendsto_lt_witness`, this provides a complete
"EVT for non-compact `[a, ∞)`" toolkit.

## Tags

argmax, EVT, half-line, tendsto, finite limit, non-compact maximum,
Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

open Set Filter Topology

/-- **Argmax on `[a, ∞)` from continuous + tendsto-finite-with-witness**:
    if `f` is continuous on `[a, ∞)`, tends to a finite limit `L` at
    `+∞`, and there is some `x_high ∈ [a, ∞)` with `L < f x_high`,
    then `f` attains its supremum on `[a, ∞)`.

    Proof: combine `eventually_le_of_tendsto_lt_witness` (gives
    `N₀` with `f x ≤ f x_high` past `N₀`) + Mathlib EVT on the compact
    `[a, max(x_high, N₀)]` + case-split argmax dominance. -/
theorem argmax_on_Ici_of_tendsto_lt_witness
    (f : ℝ → ℝ) (a L x_high : ℝ)
    (h_a_le_x_high : a ≤ x_high)
    (hf_cont : ContinuousOn f (Set.Ici a))
    (hf_tendsto : Filter.Tendsto f Filter.atTop (nhds L))
    (h_witness : L < f x_high) :
    ∃ x_max : ℝ, a ≤ x_max ∧ ∀ x : ℝ, a ≤ x → f x ≤ f x_max := by
  -- Step 1: Apply `eventually_le_of_tendsto_lt_witness` to get N₀ such that f x ≤ f x_high for x ≥ N₀.
  obtain ⟨N₀, hN₀⟩ :=
    eventually_le_of_tendsto_lt_witness f L x_high hf_tendsto h_witness
  -- Step 2: Set Nupper = max(x_high, N₀).
  set Nupper := max x_high N₀ with hNupper_def
  have h_x_high_le_Nupper : x_high ≤ Nupper := le_max_left _ _
  have h_N₀_le_Nupper : N₀ ≤ Nupper := le_max_right _ _
  have h_a_le_Nupper : a ≤ Nupper := le_trans h_a_le_x_high h_x_high_le_Nupper
  -- Step 3: Apply EVT on compact [a, Nupper].
  have h_Icc_nonempty : (Set.Icc a Nupper).Nonempty :=
    ⟨a, by simp [h_a_le_Nupper]⟩
  have h_cont_Icc : ContinuousOn f (Set.Icc a Nupper) :=
    hf_cont.mono (fun x hx => hx.1)
  obtain ⟨x_max, hx_max_mem, hx_max⟩ :=
    isCompact_Icc.exists_isMaxOn h_Icc_nonempty h_cont_Icc
  refine ⟨x_max, hx_max_mem.1, ?_⟩
  intro x hx_a
  -- Step 4: Case-split on x ≤ Nupper vs x > Nupper.
  by_cases h : x ≤ Nupper
  · -- Case 1: x ∈ [a, Nupper], apply compact-interval maximizer.
    exact hx_max ⟨hx_a, h⟩
  · -- Case 2: x > Nupper ≥ N₀, use the tendsto-le witness + argmax-dominance at x_high.
    push_neg at h
    have hx_ge_N₀ : N₀ ≤ x := le_trans h_N₀_le_Nupper (le_of_lt h)
    have h_fx_le_fxhigh : f x ≤ f x_high := hN₀ x hx_ge_N₀
    have h_x_high_in_Icc : x_high ∈ Set.Icc a Nupper :=
      ⟨h_a_le_x_high, h_x_high_le_Nupper⟩
    have h_fxhigh_le_fxmax : f x_high ≤ f x_max := hx_max h_x_high_in_Icc
    linarith

/-! ### Kernel-purity audit

`#print axioms` on `argmax_on_Ici_of_tendsto_lt_witness` surfaces ONLY
Mathlib kernel axioms (`propext, Classical.choice, Quot.sound`) — no
paper-novel `Types.lean` carriers, no broken-link `_OPEN` axioms, no
`sorry`. This is a Cat 1 generic argmax-existence theorem,
Mathlib-PR-contributable as the canonical "non-compact `[a, ∞)` EVT
under tendsto-finite-with-strict-witness" lemma. -/

#print axioms argmax_on_Ici_of_tendsto_lt_witness

end BlackwellDilemma.Infrastructure
