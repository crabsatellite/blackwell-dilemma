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
* `standardBernoulliMonotoneCouplingData` — the one-edge Strassen monotone
  coupling table for `0 <= p_low <= p_high <= 1`, including both Bernoulli
  marginals and zero mass on the forbidden open-to-closed atom.
* `standardBernoulliProductMonotoneCouplingData` — the finite-edge product of
  the one-edge monotone coupling, with non-negative mass and zero mass on any
  configuration pair containing a forbidden open-to-closed edge.

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

/-! ### One-edge monotone Bernoulli coupling -/

/-- One-edge monotone coupling factor between Bernoulli(`p_low`) and
Bernoulli(`p_high`) for `p_low <= p_high`.

The only forbidden lower/upper pair is `(true, false)`.  The remaining masses
are the standard Strassen coupling on a two-point chain:
`P(true,true)=p_low`, `P(false,true)=p_high-p_low`, and
`P(false,false)=1-p_high`. -/
def bernoulliMonotoneCouplingFactor
    (p_low p_high : ℝ) (lower upper : Bool) : ℝ :=
  match lower, upper with
  | true, true => p_low
  | true, false => 0
  | false, true => p_high - p_low
  | false, false => 1 - p_high

/-- Data package for a one-edge monotone coupling between two Bernoulli
parameters.  This is intentionally finite and measure-free: it records the
joint mass table, both Bernoulli marginals, non-negativity, total mass one,
and the monotone support condition. -/
structure BernoulliMonotoneCouplingData (p_low p_high : ℝ) where
  factor : Bool -> Bool -> ℝ
  nonneg : ∀ lower upper : Bool, 0 ≤ factor lower upper
  total_mass : (∑ lower : Bool, ∑ upper : Bool, factor lower upper) = 1
  lower_marginal :
    ∀ lower : Bool, (∑ upper : Bool, factor lower upper) =
      bernoulliFactor p_low lower
  upper_marginal :
    ∀ upper : Bool, (∑ lower : Bool, factor lower upper) =
      bernoulliFactor p_high upper
  no_lower_open_upper_closed : factor true false = 0

/-- Non-negativity of the standard one-edge monotone Bernoulli coupling. -/
theorem bernoulliMonotoneCouplingFactor_nonneg
    {p_low p_high : ℝ} (h_low_nonneg : 0 ≤ p_low)
    (h_mono : p_low ≤ p_high) (h_high_le_one : p_high ≤ 1)
    (lower upper : Bool) :
    0 ≤ bernoulliMonotoneCouplingFactor p_low p_high lower upper := by
  cases lower <;> cases upper <;>
    simp [bernoulliMonotoneCouplingFactor] <;> linarith

/-- The standard one-edge monotone Bernoulli coupling has total mass one. -/
theorem bernoulliMonotoneCouplingFactor_total_mass
    (p_low p_high : ℝ) :
    (∑ lower : Bool, ∑ upper : Bool,
      bernoulliMonotoneCouplingFactor p_low p_high lower upper) = 1 := by
  simp [bernoulliMonotoneCouplingFactor]

/-- The lower marginal of the standard monotone coupling is
Bernoulli(`p_low`). -/
theorem bernoulliMonotoneCouplingFactor_lower_marginal
    (p_low p_high : ℝ) (lower : Bool) :
    (∑ upper : Bool,
      bernoulliMonotoneCouplingFactor p_low p_high lower upper) =
        bernoulliFactor p_low lower := by
  cases lower <;> simp [bernoulliMonotoneCouplingFactor, bernoulliFactor]

/-- The upper marginal of the standard monotone coupling is
Bernoulli(`p_high`). -/
theorem bernoulliMonotoneCouplingFactor_upper_marginal
    (p_low p_high : ℝ) (upper : Bool) :
    (∑ lower : Bool,
      bernoulliMonotoneCouplingFactor p_low p_high lower upper) =
        bernoulliFactor p_high upper := by
  cases upper <;> simp [bernoulliMonotoneCouplingFactor, bernoulliFactor]

/-- The forbidden monotonicity-violating atom has zero mass. -/
theorem bernoulliMonotoneCouplingFactor_no_lower_open_upper_closed
    (p_low p_high : ℝ) :
    bernoulliMonotoneCouplingFactor p_low p_high true false = 0 := rfl

/-- Standard one-edge monotone Bernoulli coupling data for
`0 <= p_low <= p_high <= 1`. -/
def standardBernoulliMonotoneCouplingData
    (p_low p_high : ℝ) (h_low_nonneg : 0 ≤ p_low)
    (h_mono : p_low ≤ p_high) (h_high_le_one : p_high ≤ 1) :
    BernoulliMonotoneCouplingData p_low p_high where
  factor := bernoulliMonotoneCouplingFactor p_low p_high
  nonneg :=
    bernoulliMonotoneCouplingFactor_nonneg
      h_low_nonneg h_mono h_high_le_one
  total_mass :=
    bernoulliMonotoneCouplingFactor_total_mass p_low p_high
  lower_marginal :=
    bernoulliMonotoneCouplingFactor_lower_marginal p_low p_high
  upper_marginal :=
    bernoulliMonotoneCouplingFactor_upper_marginal p_low p_high
  no_lower_open_upper_closed :=
    bernoulliMonotoneCouplingFactor_no_lower_open_upper_closed p_low p_high

/-! ### Finite-product monotone Bernoulli coupling -/

/-- Finite-edge product of the one-edge monotone Bernoulli coupling. -/
def bernoulliProductMonotoneCouplingFactor
    {E : Type*} [Fintype E] (p_low p_high : ℝ)
    (lower upper : E -> Bool) : ℝ :=
  Finset.univ.prod (fun e : E =>
    bernoulliMonotoneCouplingFactor p_low p_high (lower e) (upper e))

/-- Data package for the finite-edge product monotone coupling support.

The full marginal proof for finite products is a separate product-sum theorem.
This package records the kernel-checked finite-box ingredient needed before
the lattice monotone-coupling bridge can close: non-negative joint mass and
zero mass for every configuration pair that contains an edge with lower
configuration open and upper configuration closed. -/
structure BernoulliProductMonotoneCouplingData
    {E : Type*} [Fintype E] [DecidableEq E]
    (p_low p_high : ℝ) where
  factor : (E -> Bool) -> (E -> Bool) -> ℝ
  nonneg :
    ∀ lower upper : E -> Bool, 0 ≤ factor lower upper
  no_forbidden_open_to_closed_edge :
    ∀ lower upper : E -> Bool,
      (∃ e : E, lower e = true ∧ upper e = false) ->
        factor lower upper = 0

/-- Non-negativity of the finite-product monotone coupling factor. -/
theorem bernoulliProductMonotoneCouplingFactor_nonneg
    {E : Type*} [Fintype E] {p_low p_high : ℝ}
    (h_low_nonneg : 0 ≤ p_low)
    (h_mono : p_low ≤ p_high) (h_high_le_one : p_high ≤ 1)
    (lower upper : E -> Bool) :
    0 ≤ bernoulliProductMonotoneCouplingFactor p_low p_high lower upper := by
  unfold bernoulliProductMonotoneCouplingFactor
  apply Finset.prod_nonneg
  intro e _he
  exact
    bernoulliMonotoneCouplingFactor_nonneg
      h_low_nonneg h_mono h_high_le_one (lower e) (upper e)

/-- Any forbidden open-to-closed edge gives zero mass in the finite-product
monotone coupling factor. -/
theorem bernoulliProductMonotoneCouplingFactor_no_forbidden_open_to_closed_edge
    {E : Type*} [Fintype E] [DecidableEq E]
    (p_low p_high : ℝ) (lower upper : E -> Bool)
    (h_forbidden : ∃ e : E, lower e = true ∧ upper e = false) :
    bernoulliProductMonotoneCouplingFactor p_low p_high lower upper = 0 := by
  rcases h_forbidden with ⟨e, h_lower, h_upper⟩
  unfold bernoulliProductMonotoneCouplingFactor
  apply Finset.prod_eq_zero (i := e) (Finset.mem_univ e)
  simp [bernoulliMonotoneCouplingFactor, h_lower, h_upper]

/-- Standard finite-product monotone Bernoulli coupling support data for
`0 <= p_low <= p_high <= 1`. -/
def standardBernoulliProductMonotoneCouplingData
    {E : Type*} [Fintype E] [DecidableEq E]
    (p_low p_high : ℝ) (h_low_nonneg : 0 ≤ p_low)
    (h_mono : p_low ≤ p_high) (h_high_le_one : p_high ≤ 1) :
    BernoulliProductMonotoneCouplingData (E := E) p_low p_high where
  factor := bernoulliProductMonotoneCouplingFactor p_low p_high
  nonneg :=
    bernoulliProductMonotoneCouplingFactor_nonneg
      h_low_nonneg h_mono h_high_le_one
  no_forbidden_open_to_closed_edge :=
    bernoulliProductMonotoneCouplingFactor_no_forbidden_open_to_closed_edge
      p_low p_high

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
#print axioms bernoulliMonotoneCouplingFactor_lower_marginal
#print axioms bernoulliMonotoneCouplingFactor_upper_marginal
#print axioms standardBernoulliMonotoneCouplingData
#print axioms bernoulliProductMonotoneCouplingFactor_nonneg
#print axioms bernoulliProductMonotoneCouplingFactor_no_forbidden_open_to_closed_edge
#print axioms standardBernoulliProductMonotoneCouplingData

end BlackwellDilemma.Infrastructure
