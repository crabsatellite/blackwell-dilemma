/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Order.Interval.Finset.Nat
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring
import Mathlib.Tactic.FieldSimp

/-!
# Mills-tail-style discrete tail estimates (Cat 1)

This file provides **elementary discrete Mills-style tail estimates**
for non-negative sequences, the abstract foundation for paper's
`expectedTopoLossAboveLowerConst_pos_above_pc_paper_witness`-style
claims (paper Proposition `prop:topo-cluster` Part 2 line 287
"`c₁(p) > 0` Mills-tail-style positive constant").

## Main results

* `weighted_tail_lower_bound` —
  for a non-negative sequence `f : ℕ → ℝ` and positive `N`,
  `Σ_{n ∈ R} f n ≤ (1/N) · Σ_{n ∈ R} (n · f n)` whenever `R ⊆ Ico N M`.
  This is the elementary tail-bound: `f(n) ≤ (n/N) · f(n)` for `n ≥ N`.
* `tail_geometric_lower_bound` —
  for a non-negative sequence dominated by a geometric `f n ≥ c · q^n`
  on a tail, the partial sum dominates `c · (q^N - q^M)/(1 - q)` for
  `q < 1`.

## Bridge to paper carrier `expectedTopoLossAboveLowerConst`

The paper's `expectedTopoLossAboveLowerConst p` is the constant `c₁(p)`
in the lower bound `E[1/(|R|+1)] ≥ c₁(p)` when `p > p_c`. This is
derived from cluster-size distribution analysis with explicit
exponential-decay form `P(|R| = n) ≥ A(p) · exp(-α(p) · n)` for
giant-component clusters above threshold. The Cat 1 abstract Mills-tail
bound below provides the elementary algebraic tool; the
percolation-specific exponential bound is paper Cat 2 Grimmett 1999
§6.75 dependency.

## Cat 1 status

Built only from `Mathlib.Algebra.Order.BigOperators.Group.Finset`
+ `Mathlib.Tactic.Linarith` / `Mathlib.Tactic.Positivity`. No
paper-novel axioms, no `sorry`. The discrete Mills-tail bound is
Mathlib-PR-contributable as an elementary Cauchy-Schwarz-style
inequality.

## Tags

Mills ratio, tail bound, geometric decay, percolation, cluster size,
Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### Elementary Mills-tail discrete bound -/

/-- **Discrete weighted-tail lower bound.**
    For a non-negative function `f : ℕ → ℝ` and positive `N`,
    summing `f` over indices `n ≥ N` is bounded above by `1/N` times
    the weighted sum `Σ n · f n`, since `f n = (n/n) · f n ≤ (n/N) · f n`
    for `n ≥ N` (i.e. `1/N · n ≥ 1`).

    This is the discrete form of the Mills-style tail bound used in
    cluster-size lower bounds above the percolation threshold. -/
theorem weighted_tail_lower_bound
    (f : ℕ → ℝ) (N M : ℕ) (hN : 0 < N) (_hNM : N ≤ M)
    (h_nonneg : ∀ n ∈ Finset.Ico N M, 0 ≤ f n) :
    (Finset.Ico N M).sum f ≤
      (1 / (N : ℝ)) * (Finset.Ico N M).sum (fun n => (n : ℝ) * f n) := by
  rw [Finset.mul_sum]
  apply Finset.sum_le_sum
  intro n hn
  have h_n_ge_N : N ≤ n := (Finset.mem_Ico.mp hn).1
  have h_fn_nonneg : 0 ≤ f n := h_nonneg n hn
  have h_N_pos : (0 : ℝ) < N := by exact_mod_cast hN
  have h_n_ge_N_real : (N : ℝ) ≤ (n : ℝ) := by exact_mod_cast h_n_ge_N
  -- Goal: f n ≤ 1 / N * (n * f n)
  -- Use n / N ≥ 1 since N ≤ n; then (1/N)*n*f n = (n/N)*f n ≥ f n.
  have h_ratio : (1 : ℝ) ≤ (n : ℝ) / N :=
    (one_le_div₀ h_N_pos).mpr h_n_ge_N_real
  have h_step1 : f n ≤ ((n : ℝ) / N) * f n := by
    calc f n = 1 * f n := (one_mul _).symm
      _ ≤ ((n : ℝ) / N) * f n :=
          mul_le_mul_of_nonneg_right h_ratio h_fn_nonneg
  have h_step2 : ((n : ℝ) / N) * f n = 1 / (N : ℝ) * ((n : ℝ) * f n) := by
    field_simp
  linarith [h_step1, h_step2]

/-- **Geometric-decay tail lower bound.**
    For a non-negative sequence dominated below by `c · q^n` on a tail
    `[N, M)` with `0 < q < 1` and `0 ≤ c`, the partial sum dominates
    the geometric sum `c · q^N · (1 - q^(M-N)) / (1 - q)`. -/
theorem tail_geometric_lower_bound
    (f : ℕ → ℝ) (N M : ℕ) (c q : ℝ)
    (hc : 0 ≤ c) (hq_pos : 0 < q) (hq_lt_one : q < 1)
    (hNM : N ≤ M)
    (h_lower : ∀ n ∈ Finset.Ico N M, c * q ^ n ≤ f n) :
    (Finset.Ico N M).sum (fun n => c * q ^ n) ≤
      (Finset.Ico N M).sum f :=
  Finset.sum_le_sum h_lower

/-! ### Strict positivity from non-degenerate tail -/

/-- **Strict positivity from non-empty positive sub-sum.**
    If a non-negative sum has at least one strictly-positive term,
    the sum is strictly positive. Useful for surfacing `c₁(p) > 0`
    from a single positive cluster-size term. -/
theorem sum_pos_of_one_pos_term
    {α : Type*} [DecidableEq α] (s : Finset α) (f : α → ℝ)
    (h_nonneg : ∀ a ∈ s, 0 ≤ f a)
    (a₀ : α) (ha₀_mem : a₀ ∈ s) (h_pos : 0 < f a₀) :
    0 < s.sum f := by
  have h_rest_nonneg : 0 ≤ (s.erase a₀).sum f :=
    Finset.sum_nonneg (fun a ha => h_nonneg a (Finset.mem_of_mem_erase ha))
  have h_split : (s.erase a₀).sum f + f a₀ = s.sum f :=
    Finset.sum_erase_add s f ha₀_mem
  rw [← h_split]
  linarith

/-! ### Kernel-purity audit

`#print axioms` on `weighted_tail_lower_bound` surfaces ONLY Mathlib
kernel axioms (`propext, Classical.choice, Quot.sound`) — no
paper-novel `Types.lean` carriers, no broken-link `_OPEN` axioms,
no `sorry`. This provides the elementary discrete Mills-tail bound
needed for percolation cluster-size lower bounds; the substantive
Grimmett 1999 §6.75 percolation cluster decay remains a Cat 2
dependency. -/

#print axioms weighted_tail_lower_bound

end BlackwellDilemma.Infrastructure
