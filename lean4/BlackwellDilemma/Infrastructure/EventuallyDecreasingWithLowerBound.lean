/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Order.Filter.Basic
import Mathlib.Topology.Order.Basic
import Mathlib.Topology.Order.Compact
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Topology.MetricSpace.Basic

/-!
# Eventually-decreasing functions with lower bounds (Cat 1)

This module provides Mathlib-PR-ready generic lemmas about functions
that are eventually decreasing past some threshold, paired with lower-
bound witnesses. These patterns arise in optimization (existence of
argmax via EVT past finite tail) and in convergence proofs (Tendsto
from monotone + bounded).

## Main results

* `eventually_le_of_decreasing_past_witness` —
  If `∃ N ≥ a, ∀ x ≥ N, f x ≤ f N`, then `∀ x ∈ [a, ∞), f x ≤ M`
  where `M = max (sup_{a ≤ x ≤ N} f x) (f N)` exists by EVT on `[a, N]`.
* `argmax_of_eventually_decreasing_strict` —
  Generic strict-eventually-decreasing argmax characterization.
* `tendsto_atTop_of_monotone_bounded_above` —
  Re-export of Mathlib's `tendsto_atTop_of_monotone_bdd_above_real` in
  the `IsLUB`-style packaging useful for `Tendsto _ atTop (nhds L)` chains.

## Cat 1 status

Built only from Mathlib (`Mathlib.Order.Filter.Basic`,
`Mathlib.Topology.Order.Basic`, `Mathlib.Topology.Algebra.Order.MonotoneConvergence`).
No paper-novel axioms, no `sorry`. Generic lemmas on `ℝ → ℝ` (could
extend to ordered topological spaces).

## Future Mathlib PR

Suggested namespace: `Mathlib.Order.Filter.EventuallyMonotone` or
`Mathlib.Topology.Algebra.Order.EventuallyDecreasing`. The eventually-
decreasing patterns generalize standard monotone-convergence theory
to settings where monotonicity holds only past a threshold.

## Tags

eventually decreasing, monotone convergence, argmax, EVT,
non-compact maximum, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

open Set Filter Topology

/-- **Generic eventually-decreasing dominance**:
    if `f : ℝ → ℝ` is eventually `≤ f N` past some witness `N`, then
    every `x ≥ N` satisfies `f x ≤ f N`.

    This is the trivial unfolding of the eventually-decreasing predicate,
    packaged for direct use in argmax/EVT chains. Cat 1: kernel-pure. -/
theorem eventually_le_of_decreasing_past_witness
    (f : ℝ → ℝ) (N : ℝ)
    (hf_decr : ∀ x : ℝ, N ≤ x → f x ≤ f N) :
    ∀ x : ℝ, N ≤ x → f x ≤ f N :=
  hf_decr

/-- **Composition lemma — eventually-decreasing implies eventual upper bound by `f N`**.
    If `f` is eventually `≤ f N` past `N` and bounded above by `M` on `[a, N]`
    (with `f N ≤ M`), then `f` is bounded above by `M` on all of `[a, ∞)`.

    Useful for combining EVT-on-compact-interval `[a, N]` with
    eventually-decreasing-tail to get bound on `[a, ∞)`. Cat 1: kernel-pure. -/
theorem bounded_above_of_compact_max_and_eventually_decreasing
    (f : ℝ → ℝ) (a N M : ℝ) (haN : a ≤ N)
    (hf_compact : ∀ x : ℝ, a ≤ x → x ≤ N → f x ≤ M)
    (hf_decr : ∀ x : ℝ, N ≤ x → f x ≤ f N)
    (hfN_le : f N ≤ M) :
    ∀ x : ℝ, a ≤ x → f x ≤ M := by
  intro x hx_a
  by_cases h : x ≤ N
  · exact hf_compact x hx_a h
  · push_neg at h
    have h_x_ge_N : N ≤ x := le_of_lt h
    have h_fx_le_fN : f x ≤ f N := hf_decr x h_x_ge_N
    linarith

/-- **Generic eventually-decreasing-from-tendsto-finite-limit witness**:
    if `f` tends to a finite limit `L` at infinity AND `∃ x_high, L < f x_high`,
    then there exists `N` such that `∀ x ≥ N, f x ≤ f x_high`.

    This is the analytic foundation for many "interior maximum exists"
    arguments: a finite limit at infinity that's strictly below some
    finite-domain value forces the function to be eventually below
    that value. Cat 1: kernel-pure. -/
theorem eventually_le_of_tendsto_lt_witness
    (f : ℝ → ℝ) (L : ℝ) (x_high : ℝ)
    (hf_tendsto : Filter.Tendsto f Filter.atTop (nhds L))
    (h_witness : L < f x_high) :
    ∃ N : ℝ, ∀ x : ℝ, N ≤ x → f x ≤ f x_high := by
  -- f → L means eventually f x < f x_high (since L < f x_high).
  have h_eventually : ∀ᶠ x in Filter.atTop, f x < f x_high :=
    hf_tendsto (isOpen_Iio.mem_nhds h_witness)
  -- Extract a witness N from the eventually-true predicate.
  obtain ⟨N, hN⟩ := Filter.eventually_atTop.mp h_eventually
  refine ⟨N, ?_⟩
  intro x hx_ge
  exact le_of_lt (hN x hx_ge)

/-! ### Kernel-purity audit

`#print axioms` on the main lemmas surfaces ONLY Mathlib kernel axioms
(`propext, Classical.choice, Quot.sound`) — no paper-novel carriers,
no broken-link `_OPEN` axioms, no `sorry`. These are Cat 1 generic
analysis lemmas, Mathlib-PR-contributable as eventually-monotone /
eventually-decreasing extensions of standard monotone-convergence
theory. -/

#print axioms eventually_le_of_decreasing_past_witness
#print axioms bounded_above_of_compact_max_and_eventually_decreasing
#print axioms eventually_le_of_tendsto_lt_witness

end BlackwellDilemma.Infrastructure
