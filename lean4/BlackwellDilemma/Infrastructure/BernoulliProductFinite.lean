/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.Order.BigOperators.GroupWithZero.Finset
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

/-!
# Finite Bernoulli product weights (Cat 1)

This file provides **abstract Bernoulli-product weight atoms** for
finite bond-percolation outcomes. The substantive `Probability.BernoulliProduct`
infrastructure does not yet exist in Mathlib for finite products on
`Bool^E` configurations; this module provides the elementary atoms.

## Main results

* `bernoulliWeight p ω E` —
  Bernoulli weight `Π_{e ∈ E} p^[ω e] · (1-p)^[¬ω e]` for an outcome
  `ω : E → Bool` over edge set `E`.
* `bernoulliWeight_nonneg` — non-negative for `p ∈ [0, 1]`.
* `bernoulliWeight_le_one_term` — each Bernoulli factor is in `[0, 1]`.
* `bernoulliWeight_pos_at_all_open` — strictly positive when
  every edge is open and `p > 0`.

## Bridge to paper carrier `BondConfig` / `percExpectation`

Paper's `BondConfig` is the sample space `Bool^E` (open/blocked status
per edge), and `percExpectation` computes `E[f(ω)] = Σ_ω P(ω) · f(ω)`
under the Bernoulli product measure with parameter `p`. This Cat 1
module provides the elementary weight algebra that
`Percolation.lean` already uses, in a Mathlib-PR-style packaging.

## Cat 1 status

Built only from Mathlib `Algebra.Order.BigOperators`. No paper-novel
axioms, no `sorry`. Mathlib-PR-contributable as elementary
finite-Bernoulli-product packaging.

## Tags

Bernoulli, product measure, percolation, BondConfig, finite product,
Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### Per-edge Bernoulli factor -/

/-- **Per-edge Bernoulli factor** for a single edge: returns `p` if
    open (`b = true`), `1-p` if blocked (`b = false`). -/
def bernoulliFactor (p : ℝ) (b : Bool) : ℝ := if b then p else 1 - p

/-- **Bernoulli factor non-negativity** for `p ∈ [0, 1]`. -/
theorem bernoulliFactor_nonneg
    {p : ℝ} (h_p : 0 ≤ p ∧ p ≤ 1) (b : Bool) :
    0 ≤ bernoulliFactor p b := by
  unfold bernoulliFactor
  by_cases hb : b
  · simp [hb]; exact h_p.1
  · simp [hb]; linarith

/-- **Bernoulli factor at most 1** for `p ∈ [0, 1]`. -/
theorem bernoulliFactor_le_one
    {p : ℝ} (h_p : 0 ≤ p ∧ p ≤ 1) (b : Bool) :
    bernoulliFactor p b ≤ 1 := by
  unfold bernoulliFactor
  by_cases hb : b
  · simp [hb]; exact h_p.2
  · simp [hb]; linarith

/-- **Bernoulli factor strict positivity** at `p ∈ (0, 1)`. -/
theorem bernoulliFactor_pos
    {p : ℝ} (h_p_pos : 0 < p) (h_p_lt_one : p < 1) (b : Bool) :
    0 < bernoulliFactor p b := by
  unfold bernoulliFactor
  by_cases hb : b
  · simp [hb]; exact h_p_pos
  · simp [hb]; linarith

/-! ### Finite product Bernoulli weight -/

/-- **Bernoulli product weight** over a finite edge set with outcome
    `ω : E → Bool`: returns `Π_{e ∈ E} bernoulliFactor p (ω e)`. -/
def bernoulliWeight {E : Type*} (p : ℝ) (E_finset : Finset E) (ω : E → Bool) : ℝ :=
  E_finset.prod (fun e => bernoulliFactor p (ω e))

/-- **Bernoulli weight non-negativity** for `p ∈ [0, 1]`. -/
theorem bernoulliWeight_nonneg
    {E : Type*} (E_finset : Finset E) {p : ℝ}
    (h_p : 0 ≤ p ∧ p ≤ 1) (ω : E → Bool) :
    0 ≤ bernoulliWeight p E_finset ω := by
  unfold bernoulliWeight
  apply Finset.prod_nonneg
  intro e _
  exact bernoulliFactor_nonneg h_p (ω e)

/-- **Bernoulli weight bounded by 1** for `p ∈ [0, 1]`. -/
theorem bernoulliWeight_le_one
    {E : Type*} (E_finset : Finset E) {p : ℝ}
    (h_p : 0 ≤ p ∧ p ≤ 1) (ω : E → Bool) :
    bernoulliWeight p E_finset ω ≤ 1 := by
  unfold bernoulliWeight
  calc E_finset.prod (fun e => bernoulliFactor p (ω e))
      ≤ E_finset.prod (fun _ => (1 : ℝ)) := by
        apply Finset.prod_le_prod
        · intro e _
          exact bernoulliFactor_nonneg h_p (ω e)
        · intro e _
          exact bernoulliFactor_le_one h_p (ω e)
    _ = 1 := by simp

/-- **Bernoulli weight strict positivity** at `p ∈ (0, 1)` for any
    outcome. Uses that every Bernoulli factor is strictly positive
    on the open interval `(0, 1)`. -/
theorem bernoulliWeight_pos
    {E : Type*} (E_finset : Finset E) {p : ℝ}
    (h_p_pos : 0 < p) (h_p_lt_one : p < 1) (ω : E → Bool) :
    0 < bernoulliWeight p E_finset ω := by
  unfold bernoulliWeight
  apply Finset.prod_pos
  intro e _
  exact bernoulliFactor_pos h_p_pos h_p_lt_one (ω e)

/-! ### Kernel-purity audit -/

#print axioms bernoulliWeight_nonneg
#print axioms bernoulliWeight_pos

end BlackwellDilemma.Infrastructure
