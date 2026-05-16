/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Order.Field.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

/-!
# Order-statistics algebraic bound (Cat 1)

This module provides a Cat 1 algebraic bound for the order-statistics
ratio that arises from the David & Nagaraja 2003 §1.3 formula for the
expected gap between the population maximum and the sample maximum of
`k` iid `Uniform[0, 1]` draws on `{0, 1/(N+1), 2/(N+1), …, N/(N+1)}`.

The closed-form
`E[r* - max_{v ∈ R} r(v) | |R| = k] = (N - k) / ((N + 1) (k + 1))`
appears in the proof of the paper's Proposition `prop:topo-cluster`
(line 294) as the per-realisation topological-loss kernel value on
the giant-component event.

## Main result

* `orderStatisticsRatio_le_one_over_n_succ` — for `N, k : ℕ` with
  the giant-component lower-bound `N ≤ 2 k + 1`, the order-statistics
  ratio satisfies
  `(N - k) / ((N + 1) (k + 1)) ≤ 1 / (N + 1)`.

The algebra: starting from the goal
`(N - k) / ((N + 1) (k + 1)) ≤ 1 / (N + 1)`,
cancelling the common positive factor `N + 1 > 0` reduces to
`(N - k) / (k + 1) ≤ 1`, which (multiplying by `k + 1 > 0`) becomes
`N - k ≤ k + 1`, equivalently `N ≤ 2 k + 1`. This is the precise
"giant-component" hypothesis: `k` must be at least `(N - 1) / 2`,
i.e., the cluster covers at least half of the lattice.

## Cat 1 status

Built only from `Mathlib.Algebra.Order.Field.Basic` +
`Mathlib.Data.Real.Basic` + `Linarith` + `Positivity`. Kernel-pure
(`#print axioms` shows only `[propext, Classical.choice, Quot.sound]`).
Generic on `ℕ → ℝ` coerced naturals — no paper-specific carriers,
no broken-link `_OPEN` axioms.

## Future Mathlib PR

Suggested namespace:
`Mathlib.Algebra.Order.Field.OrderStatistics` or
`Mathlib.Probability.OrderStatistics.UniformBounds`. Useful for any
analysis composing the David-Nagaraja uniform-spacing closed form
with a "cluster covers at least half the population" hypothesis
(arises in percolation, random-graph, and ranking-aggregation work).

## Tags

order statistics, uniform spacing, algebraic bound, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### Core algebraic bound -/

/-- **Cat 1 algebraic bound** for the order-statistics ratio
    `(N - k) / ((N + 1) (k + 1))`.

    Hypothesis: `N ≤ 2 k + 1` (the "giant-component" lower bound,
    equivalent to `k ≥ (N - 1) / 2`, i.e., `k` covers at least half
    of `{0, 1, …, N}`).

    Conclusion: the ratio is bounded above by `1 / (N + 1)`.

    Proof sketch: cancel the common factor `N + 1 > 0`, then multiply
    by the positive denominator `k + 1 > 0` to convert the rational
    inequality to the linear inequality `N - k ≤ k + 1`, equivalent
    to the hypothesis.

    This is a Cat 1 lemma: no paper-novel carriers, no economic
    structure — purely an inequality in `ℝ` parameterised by two
    natural-number indices. -/
theorem orderStatisticsRatio_le_one_over_n_succ
    (N k : ℕ) (h_k_large : N ≤ 2 * k + 1) :
    ((N : ℝ) - (k : ℝ)) / (((N : ℝ) + 1) * ((k : ℝ) + 1)) ≤
      1 / ((N : ℝ) + 1) := by
  -- Positivity of denominators (via the natural-number coercions).
  have hN1_pos : (0 : ℝ) < (N : ℝ) + 1 := by positivity
  have hk1_pos : (0 : ℝ) < (k : ℝ) + 1 := by positivity
  have hprod_pos : (0 : ℝ) < ((N : ℝ) + 1) * ((k : ℝ) + 1) :=
    mul_pos hN1_pos hk1_pos
  -- Convert hypothesis to a real-valued linear inequality.
  have h_linear : (N : ℝ) - (k : ℝ) ≤ (k : ℝ) + 1 := by
    have h_cast : (N : ℝ) ≤ 2 * (k : ℝ) + 1 := by exact_mod_cast h_k_large
    linarith
  -- Cross-multiply: goal becomes
  --   ((N - k)) * (N + 1) ≤ 1 * ((N + 1) * (k + 1))
  rw [div_le_div_iff₀ hprod_pos hN1_pos]
  -- Step 1 (algebra): the right-hand side simplifies to (N+1)*(k+1).
  -- Step 2 (mono): from `N - k ≤ k + 1` (h_linear) and `N + 1 > 0`,
  -- multiplying both sides by (N + 1) preserves the inequality, giving
  --   (N - k) * (N + 1) ≤ (k + 1) * (N + 1) = (N + 1) * (k + 1).
  have h_step :
      ((N : ℝ) - (k : ℝ)) * ((N : ℝ) + 1) ≤
        ((k : ℝ) + 1) * ((N : ℝ) + 1) :=
    mul_le_mul_of_nonneg_right h_linear (le_of_lt hN1_pos)
  -- Final ring-normalisation handled by `linarith` + `nlinarith` fallback.
  nlinarith [h_step, hN1_pos, hk1_pos]

/-- **Companion lemma**: trivial reformulation in the form
    `(N - k) * (N + 1) ≤ (N + 1) * (k + 1)` (the cross-multiplied
    statement, useful when downstream code already cleared denominators). -/
theorem orderStatisticsRatio_cross_mul
    (N k : ℕ) (h_k_large : N ≤ 2 * k + 1) :
    ((N : ℝ) - (k : ℝ)) * ((N : ℝ) + 1) ≤
      ((N : ℝ) + 1) * ((k : ℝ) + 1) := by
  have hN1_pos : (0 : ℝ) < (N : ℝ) + 1 := by positivity
  have h_linear : (N : ℝ) - (k : ℝ) ≤ (k : ℝ) + 1 := by
    have h_cast : (N : ℝ) ≤ 2 * (k : ℝ) + 1 := by exact_mod_cast h_k_large
    linarith
  have h_step :
      ((N : ℝ) - (k : ℝ)) * ((N : ℝ) + 1) ≤
        ((k : ℝ) + 1) * ((N : ℝ) + 1) :=
    mul_le_mul_of_nonneg_right h_linear (le_of_lt hN1_pos)
  linarith [h_step]

/-! ### Kernel-purity audit

`#print axioms` on the main theorems surfaces ONLY Mathlib kernel
axioms (`propext, Classical.choice, Quot.sound`) — no paper-novel
carriers, no broken-link `_OPEN` axioms, no `sorry`. This is a
Cat 1 lemma ready for upstream Mathlib contribution. -/

#print axioms orderStatisticsRatio_le_one_over_n_succ
#print axioms orderStatisticsRatio_cross_mul

end BlackwellDilemma.Infrastructure
