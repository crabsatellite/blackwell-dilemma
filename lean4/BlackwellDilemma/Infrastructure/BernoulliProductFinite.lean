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
* `standardBernoulliProductMonotoneCouplingMarginalData` — the same finite
  product with total mass one and both finite-product Bernoulli marginals.
* `bernoulliProductExpectation_mono_of_monotone` — finite-box stochastic
  monotonicity: every coordinatewise monotone real-valued observable has
  non-decreasing Bernoulli-product expectation in `p`.

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

This package records the kernel-checked finite-box ingredient needed before
the lattice monotone-coupling bridge can close: non-negative joint mass and
zero mass for every configuration pair that contains an edge with lower
configuration open and upper configuration closed.  The marginal package below
adds total mass one and both finite-product Bernoulli marginals. -/
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

/-- The Bernoulli product weights over all configurations have total mass one. -/
theorem bernoulliWeight_univ_total
    {E : Type*} [Fintype E] [DecidableEq E] (p : ℝ) :
    Finset.univ.sum (fun ω : E -> Bool =>
      bernoulliWeight p Finset.univ ω) = 1 := by
  classical
  unfold bernoulliWeight
  have hprod_sum :
      (Finset.univ.prod
        (fun e : E => Finset.univ.sum (fun b : Bool => bernoulliFactor p b))) =
        Finset.univ.sum (fun ω : E -> Bool =>
          Finset.univ.prod (fun e : E => bernoulliFactor p (ω e))) := by
    simpa using
      (Fintype.prod_sum (fun (_e : E) (b : Bool) => bernoulliFactor p b))
  calc
    Finset.univ.sum (fun ω : E -> Bool =>
      Finset.univ.prod (fun e : E => bernoulliFactor p (ω e)))
        = Finset.univ.prod
            (fun e : E => Finset.univ.sum (fun b : Bool => bernoulliFactor p b)) := by
          simpa using hprod_sum.symm
    _ = 1 := by
          apply Finset.prod_eq_one
          intro e _he
          simp [bernoulliFactor]

/-- The lower marginal of the finite-product monotone coupling is the
finite-product Bernoulli law with parameter `p_low`. -/
theorem bernoulliProductMonotoneCouplingFactor_lower_marginal
    {E : Type*} [Fintype E] [DecidableEq E]
    (p_low p_high : ℝ) (lower : E -> Bool) :
    (Finset.univ.sum (fun upper : E -> Bool =>
      bernoulliProductMonotoneCouplingFactor p_low p_high lower upper)) =
        bernoulliWeight p_low Finset.univ lower := by
  classical
  unfold bernoulliProductMonotoneCouplingFactor bernoulliWeight
  let g : E -> Bool -> ℝ := fun e b =>
    bernoulliMonotoneCouplingFactor p_low p_high (lower e) b
  have hprod_sum :
      (Finset.univ.prod
        (fun e : E => Finset.univ.sum (fun b : Bool => g e b))) =
        Finset.univ.sum (fun upper : E -> Bool =>
          Finset.univ.prod (fun e : E => g e (upper e))) := by
    simpa using (Fintype.prod_sum g)
  calc
    Finset.univ.sum (fun upper : E -> Bool =>
      Finset.univ.prod (fun e : E =>
        bernoulliMonotoneCouplingFactor p_low p_high (lower e) (upper e)))
        = Finset.univ.prod
            (fun e : E => Finset.univ.sum (fun b : Bool => g e b)) := by
          simpa [g] using hprod_sum.symm
    _ = Finset.univ.prod (fun e : E => bernoulliFactor p_low (lower e)) := by
          apply Finset.prod_congr rfl
          intro e _he
          exact bernoulliMonotoneCouplingFactor_lower_marginal
            p_low p_high (lower e)

/-- The upper marginal of the finite-product monotone coupling is the
finite-product Bernoulli law with parameter `p_high`. -/
theorem bernoulliProductMonotoneCouplingFactor_upper_marginal
    {E : Type*} [Fintype E] [DecidableEq E]
    (p_low p_high : ℝ) (upper : E -> Bool) :
    (Finset.univ.sum (fun lower : E -> Bool =>
      bernoulliProductMonotoneCouplingFactor p_low p_high lower upper)) =
        bernoulliWeight p_high Finset.univ upper := by
  classical
  unfold bernoulliProductMonotoneCouplingFactor bernoulliWeight
  let g : E -> Bool -> ℝ := fun e b =>
    bernoulliMonotoneCouplingFactor p_low p_high b (upper e)
  have hprod_sum :
      (Finset.univ.prod
        (fun e : E => Finset.univ.sum (fun b : Bool => g e b))) =
        Finset.univ.sum (fun lower : E -> Bool =>
          Finset.univ.prod (fun e : E => g e (lower e))) := by
    simpa using (Fintype.prod_sum g)
  calc
    Finset.univ.sum (fun lower : E -> Bool =>
      Finset.univ.prod (fun e : E =>
        bernoulliMonotoneCouplingFactor p_low p_high (lower e) (upper e)))
        = Finset.univ.prod
            (fun e : E => Finset.univ.sum (fun b : Bool => g e b)) := by
          simpa [g] using hprod_sum.symm
    _ = Finset.univ.prod (fun e : E => bernoulliFactor p_high (upper e)) := by
          apply Finset.prod_congr rfl
          intro e _he
          exact bernoulliMonotoneCouplingFactor_upper_marginal
            p_low p_high (upper e)

/-- The finite-product monotone coupling has total mass one. -/
theorem bernoulliProductMonotoneCouplingFactor_total_mass
    {E : Type*} [Fintype E] [DecidableEq E]
    (p_low p_high : ℝ) :
    Finset.univ.sum (fun lower : E -> Bool =>
      Finset.univ.sum (fun upper : E -> Bool =>
        bernoulliProductMonotoneCouplingFactor p_low p_high lower upper)) = 1 := by
  classical
  calc
    Finset.univ.sum (fun lower : E -> Bool =>
      Finset.univ.sum (fun upper : E -> Bool =>
        bernoulliProductMonotoneCouplingFactor p_low p_high lower upper))
        = Finset.univ.sum (fun lower : E -> Bool =>
            bernoulliWeight p_low Finset.univ lower) := by
          apply Finset.sum_congr rfl
          intro lower _h
          exact
            bernoulliProductMonotoneCouplingFactor_lower_marginal
              p_low p_high lower
    _ = 1 := bernoulliWeight_univ_total p_low

/-- Data package for the finite-edge product monotone coupling with total mass
and both finite-product Bernoulli marginals. -/
structure BernoulliProductMonotoneCouplingMarginalData
    {E : Type*} [Fintype E] [DecidableEq E]
    (p_low p_high : ℝ) extends
      BernoulliProductMonotoneCouplingData (E := E) p_low p_high where
  total_mass :
    Finset.univ.sum (fun lower : E -> Bool =>
      Finset.univ.sum (fun upper : E -> Bool => factor lower upper)) = 1
  lower_marginal :
    (lower : E -> Bool) ->
      Finset.univ.sum (fun upper : E -> Bool => factor lower upper) =
        bernoulliWeight p_low Finset.univ lower
  upper_marginal :
    (upper : E -> Bool) ->
      Finset.univ.sum (fun lower : E -> Bool => factor lower upper) =
        bernoulliWeight p_high Finset.univ upper

/-- Standard finite-product monotone Bernoulli coupling marginal data for
`0 <= p_low <= p_high <= 1`. -/
def standardBernoulliProductMonotoneCouplingMarginalData
    {E : Type*} [Fintype E] [DecidableEq E]
    (p_low p_high : ℝ) (h_low_nonneg : 0 ≤ p_low)
    (h_mono : p_low ≤ p_high) (h_high_le_one : p_high ≤ 1) :
    BernoulliProductMonotoneCouplingMarginalData (E := E) p_low p_high where
  toBernoulliProductMonotoneCouplingData :=
    standardBernoulliProductMonotoneCouplingData
      (E := E) p_low p_high h_low_nonneg h_mono h_high_le_one
  total_mass :=
    bernoulliProductMonotoneCouplingFactor_total_mass p_low p_high
  lower_marginal :=
    bernoulliProductMonotoneCouplingFactor_lower_marginal p_low p_high
  upper_marginal :=
    bernoulliProductMonotoneCouplingFactor_upper_marginal p_low p_high

/-! ### Finite-product stochastic monotonicity -/

/-- A forbidden monotone-coupling transition: an edge that is open in the lower
configuration and closed in the upper configuration. -/
def ForbiddenOpenToClosed {E : Type*} (lower upper : E -> Bool) : Prop :=
  Exists (fun e : E => And (lower e = true) (upper e = false))

/-- Coordinatewise order on Boolean configurations, with `false < true`. -/
def BoolConfigLe {E : Type*} (lower upper : E -> Bool) : Prop :=
  (e : E) -> lower e = true -> upper e = true

/-- A real-valued observable on Boolean configurations is monotone if it is
non-decreasing in the coordinatewise order. -/
def BoolConfigMonotone {E : Type*} (f : (E -> Bool) -> ℝ) : Prop :=
  (lower : E -> Bool) -> (upper : E -> Bool) ->
    BoolConfigLe lower upper -> f lower ≤ f upper

/-- Bernoulli-product expectation of a finite Boolean-configuration
observable. -/
noncomputable def bernoulliProductExpectation
    {E : Type*} [Fintype E] [DecidableEq E]
    (p : ℝ) (f : (E -> Bool) -> ℝ) : ℝ :=
  Finset.univ.sum (fun ω : E -> Bool =>
    bernoulliWeight p Finset.univ ω * f ω)

/-- If no forbidden open-to-closed edge exists, then the lower configuration is
coordinatewise below the upper configuration. -/
theorem boolConfigLe_of_not_forbiddenOpenToClosed
    {E : Type*} {lower upper : E -> Bool}
    (hno : Not (ForbiddenOpenToClosed lower upper)) :
    BoolConfigLe lower upper := by
  intro e h_lower
  cases h_upper : upper e with
  | false =>
      exfalso
      exact hno (Exists.intro e (And.intro h_lower h_upper))
  | true =>
      rfl

/-- A finite-product monotone coupling puts enough mass on ordered pairs to
compare a monotone observable term-by-term. -/
theorem bernoulliProductCoupling_term_mono
    {E : Type*} [Fintype E] [DecidableEq E]
    {p_low p_high : ℝ}
    (c : BernoulliProductMonotoneCouplingMarginalData
      (E := E) p_low p_high)
    (f : (E -> Bool) -> ℝ) (hf : BoolConfigMonotone f)
    (lower upper : E -> Bool) :
    c.factor lower upper * f lower ≤ c.factor lower upper * f upper := by
  classical
  by_cases hle : BoolConfigLe lower upper
  case pos =>
    exact mul_le_mul_of_nonneg_left (hf lower upper hle)
      (c.nonneg lower upper)
  case neg =>
    have hforbidden : ForbiddenOpenToClosed lower upper := by
      by_contra hno
      exact hle (boolConfigLe_of_not_forbiddenOpenToClosed hno)
    have hzero := c.no_forbidden_open_to_closed_edge lower upper hforbidden
    rw [hzero]
    simp

/-- Finite-product stochastic monotonicity from an explicit finite-product
monotone coupling with correct Bernoulli marginals. -/
theorem bernoulliProductExpectation_mono_of_monotone_coupling
    {E : Type*} [Fintype E] [DecidableEq E]
    {p_low p_high : ℝ}
    (c : BernoulliProductMonotoneCouplingMarginalData
      (E := E) p_low p_high)
    (f : (E -> Bool) -> ℝ) (hf : BoolConfigMonotone f) :
    bernoulliProductExpectation p_low f ≤
      bernoulliProductExpectation p_high f := by
  classical
  unfold bernoulliProductExpectation
  have hleft :
      Finset.univ.sum (fun lower : E -> Bool =>
        bernoulliWeight p_low Finset.univ lower * f lower) =
      Finset.univ.sum (fun lower : E -> Bool =>
        Finset.univ.sum (fun upper : E -> Bool =>
          c.factor lower upper * f lower)) := by
    apply Finset.sum_congr rfl
    intro lower _hlower
    rw [Eq.symm (c.lower_marginal lower)]
    rw [Finset.sum_mul]
  have hright :
      Finset.univ.sum (fun upper : E -> Bool =>
        bernoulliWeight p_high Finset.univ upper * f upper) =
      Finset.univ.sum (fun lower : E -> Bool =>
        Finset.univ.sum (fun upper : E -> Bool =>
          c.factor lower upper * f upper)) := by
    calc
      Finset.univ.sum (fun upper : E -> Bool =>
        bernoulliWeight p_high Finset.univ upper * f upper)
          = Finset.univ.sum (fun upper : E -> Bool =>
              Finset.univ.sum (fun lower : E -> Bool =>
                c.factor lower upper * f upper)) := by
              apply Finset.sum_congr rfl
              intro upper _hupper
              rw [Eq.symm (c.upper_marginal upper)]
              rw [Finset.sum_mul]
      _ = Finset.univ.sum (fun lower : E -> Bool =>
            Finset.univ.sum (fun upper : E -> Bool =>
              c.factor lower upper * f upper)) := by
              rw [Finset.sum_comm]
  rw [hleft, hright]
  apply Finset.sum_le_sum
  intro lower _hlower
  apply Finset.sum_le_sum
  intro upper _hupper
  exact bernoulliProductCoupling_term_mono c f hf lower upper

/-- Standard finite-product Bernoulli expectation monotonicity for every
coordinatewise monotone observable. -/
theorem bernoulliProductExpectation_mono_of_monotone
    {E : Type*} [Fintype E] [DecidableEq E]
    {p_low p_high : ℝ}
    (h_low_nonneg : 0 ≤ p_low) (h_mono : p_low ≤ p_high)
    (h_high_le_one : p_high ≤ 1)
    (f : (E -> Bool) -> ℝ) (hf : BoolConfigMonotone f) :
    bernoulliProductExpectation p_low f ≤
      bernoulliProductExpectation p_high f := by
  exact bernoulliProductExpectation_mono_of_monotone_coupling
    (standardBernoulliProductMonotoneCouplingMarginalData
      (E := E) p_low p_high h_low_nonneg h_mono h_high_le_one)
    f hf

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
#print axioms bernoulliWeight_univ_total
#print axioms bernoulliProductMonotoneCouplingFactor_total_mass
#print axioms bernoulliProductMonotoneCouplingFactor_lower_marginal
#print axioms bernoulliProductMonotoneCouplingFactor_upper_marginal
#print axioms standardBernoulliProductMonotoneCouplingMarginalData
#print axioms boolConfigLe_of_not_forbiddenOpenToClosed
#print axioms bernoulliProductExpectation_mono_of_monotone_coupling
#print axioms bernoulliProductExpectation_mono_of_monotone

end BlackwellDilemma.Infrastructure
