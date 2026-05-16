/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Algebra.Field.GeomSum
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

/-!
# Mills-tail bounds from exponential cluster-tail decay (Cat 1)

This module provides Cat 1 lemmas converting exponential cluster-tail
decay (e.g., Grimmett 1999 §6.75) into Mills-tail-style bounds on
cumulative sums.

**Key result**: if `clusterTail k ≤ exp(-c·k)` for some `c > 0`, then
the cumulative tail sum `∑_{k=0}^{N-1} clusterTail k` is bounded by
`1/(1 - exp(-c))` uniformly in `N` (geometric series).

This is the paper-citation backbone for paper Mills-tail constants
(Mills 1926 series + cluster-tail composition from Grimmett 1999).

## Main results

* `geometric_series_bound_from_exponential` — exponential decay
  ⇒ geometric-series-style cumulative bound.
* `tail_sum_le_geometric_const` — clean packaging of the above for
  Mills-tail composition.

## Cat 1 status

Built only from Mathlib. Kernel-pure. Generic on `ℝ`-valued
sequences with exponential decay.

## Future Mathlib PR

Suggested namespace: `Mathlib.Analysis.GeometricSeries.Decay` or
`Mathlib.Analysis.SpecialFunctions.Exp.GeometricBound`. The result
is foundational for any analysis involving exponential-decay tail
bounds.

## Tags

Mills-tail, geometric series, exponential decay, cluster-tail,
Grimmett, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

open Real

/-- **Geometric series bound from exponential decay**:
    if a non-negative sequence `f : ℕ → ℝ` satisfies
    `f k ≤ exp(-(c · k))` for some `c > 0` and all `k`, then for any
    `N`, the cumulative sum `∑_{k < N} f k` is bounded by the closed
    form of the geometric series:

      `∑_{k < N} f k ≤ ∑_{k < N} exp(-(c · k))
                    = (1 - exp(-(c·N))) / (1 - exp(-c))
                    ≤ 1 / (1 - exp(-c))`.

    Cat 1: kernel-pure (composes `Finset.sum_le_sum` for monotonicity
    + Mathlib geometric series + exp-bound). -/
theorem geometric_series_bound_from_exponential
    (f : ℕ → ℝ) (c : ℝ) (hc : 0 < c)
    (h_nonneg : ∀ k, 0 ≤ f k)
    (h_decay : ∀ k : ℕ, f k ≤ Real.exp (-(c * (k : ℝ))))
    (N : ℕ) :
    ∑ k ∈ Finset.range N, f k ≤
      (1 - Real.exp (-(c * (N : ℝ)))) / (1 - Real.exp (-c)) := by
  -- First: ∑ f k ≤ ∑ exp(-c·k) by monotone sum.
  have h_le : ∑ k ∈ Finset.range N, f k ≤
              ∑ k ∈ Finset.range N, Real.exp (-(c * (k : ℝ))) := by
    apply Finset.sum_le_sum (s := Finset.range N)
    intros k _
    exact h_decay k
  -- Closed form for the geometric series ∑_{k < N} exp(-c·k)
  -- = ∑_{k < N} (exp(-c))^k = (1 - exp(-c·N)) / (1 - exp(-c))
  -- using exp(-(c·k)) = (exp(-c))^k
  have h_pow : ∀ k : ℕ,
      Real.exp (-(c * (k : ℝ))) = (Real.exp (-c)) ^ k := by
    intro k
    rw [← Real.exp_nat_mul]
    congr 1
    ring
  have h_sum_eq : (∑ k ∈ Finset.range N, Real.exp (-(c * (k : ℝ))))
                = ∑ k ∈ Finset.range N, (Real.exp (-c)) ^ k := by
    apply Finset.sum_congr rfl
    intros k _
    exact h_pow k
  -- Geometric sum: 1 - exp(-c·N) = 1 - (exp(-c))^N, denominator is 1 - exp(-c)
  -- Use Mathlib's `geom_sum_eq` for r ≠ 1.
  have h_exp_neg_c_lt_one : Real.exp (-c) < 1 := by
    rw [show (1 : ℝ) = Real.exp 0 from Real.exp_zero.symm]
    exact Real.exp_strictMono (by linarith)
  have h_exp_neg_c_ne_one : Real.exp (-c) ≠ 1 := ne_of_lt h_exp_neg_c_lt_one
  -- It suffices to show (sum of exp) ≤ closed form, then chain with h_le.
  refine le_trans h_le ?_
  rw [h_sum_eq]
  -- Now goal: ∑ k ∈ Finset.range N, (rexp (-c))^k ≤ (1 - rexp(-c·N)) / (1 - rexp(-c))
  rw [geom_sum_eq h_exp_neg_c_ne_one N]
  -- Goal: (rexp(-c)^N - 1) / (rexp(-c) - 1) ≤ (1 - rexp(-c·N)) / (1 - rexp(-c))
  have h_rewrite : ((Real.exp (-c)) ^ N - 1) / (Real.exp (-c) - 1)
        = (1 - (Real.exp (-c)) ^ N) / (1 - Real.exp (-c)) := by
    have h_ne : Real.exp (-c) - 1 ≠ 0 := by
      intro h
      have : Real.exp (-c) = 1 := by linarith
      exact h_exp_neg_c_ne_one this
    field_simp
    ring
  rw [h_rewrite, ← h_pow N]

/-- **Cumulative tail bound from exponential decay (uniform N)**:
    the closed-form bound from `geometric_series_bound_from_exponential`
    further implies a UNIFORM bound `∑_{k < N} f k ≤ 1/(1 - exp(-c))`
    independent of `N`, since `exp(-c·N) ≥ 0` makes the numerator ≤ 1. -/
theorem tail_sum_le_geometric_const
    (f : ℕ → ℝ) (c : ℝ) (hc : 0 < c)
    (h_nonneg : ∀ k, 0 ≤ f k)
    (h_decay : ∀ k : ℕ, f k ≤ Real.exp (-(c * (k : ℝ))))
    (N : ℕ) :
    ∑ k ∈ Finset.range N, f k ≤ 1 / (1 - Real.exp (-c)) := by
  have h_bound :=
    geometric_series_bound_from_exponential f c hc h_nonneg h_decay N
  -- Need: (1 - exp(-c·N)) / (1 - exp(-c)) ≤ 1 / (1 - exp(-c))
  -- Both denominators positive (exp(-c) < 1 since c > 0)
  have h_denom_pos : 0 < 1 - Real.exp (-c) := by
    have h_exp_lt : Real.exp (-c) < 1 := by
      rw [show (1 : ℝ) = Real.exp 0 from Real.exp_zero.symm]
      exact Real.exp_strictMono (by linarith)
    linarith
  have h_num_le : 1 - Real.exp (-(c * (N : ℝ))) ≤ 1 := by
    have : 0 ≤ Real.exp (-(c * (N : ℝ))) := le_of_lt (Real.exp_pos _)
    linarith
  calc ∑ k ∈ Finset.range N, f k
      ≤ (1 - Real.exp (-(c * (N : ℝ)))) / (1 - Real.exp (-c)) := h_bound
    _ ≤ 1 / (1 - Real.exp (-c)) := by
        apply div_le_div_of_nonneg_right h_num_le h_denom_pos.le

/-! ### Kernel-purity audit

`#print axioms` on the main theorems surfaces ONLY Mathlib kernel
axioms (`propext, Classical.choice, Quot.sound`) — no paper-novel
carriers, no broken-link `_OPEN` axioms, no `sorry`. These provide
the foundational Mills-tail composition from exponential cluster-tail
decay, generic over ℝ-valued sequences. -/

#print axioms geometric_series_bound_from_exponential
#print axioms tail_sum_le_geometric_const

end BlackwellDilemma.Infrastructure
