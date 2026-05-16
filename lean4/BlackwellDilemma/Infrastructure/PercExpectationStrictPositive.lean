/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import BlackwellDilemma.Percolation
import BlackwellDilemma.Infrastructure.BernoulliProductFinite
import Mathlib.Algebra.Order.BigOperators.Group.Finset

/-!
# Strict positivity of percolation expectation from per-realisation positivity (Cat 1)

This module provides the Cat 1 lemma:

**If a non-negative kernel `f : BondConfig E → ℝ` is strictly positive
at some realisation `ω₀`, AND the bond-percolation parameter `p ∈ (0, 1)`
(so all weights are strictly positive), THEN the percolation expectation
`percExpectation p f` is strictly positive.**

Proof sketch: percExpectation = ∑ ω, weight(ω) * f(ω). Each summand
is non-negative (weight ≥ 0, f ≥ 0). At ω₀, weight(ω₀) > 0 (since
p ∈ (0, 1)) and f(ω₀) > 0, so the ω₀-summand is strictly positive.
Sum-positivity from nonneg-with-one-strict-positive completes.

This is the foundational Cat 1 piece for paper claims like
"the Mills-tail-style positive constant exists" (Mills 1926 + Grimmett
1999 §6.75 composition for paper Proposition `prop:topo-cluster` Part
2 line 287).

## Main result

* `percExpectation_pos_of_kernel_pos_at_some_realisation` —
  strict positivity from non-negativity + per-realisation strict
  positivity at some specific configuration + p ∈ (0, 1).

## Cat 1 status

Built only from `BlackwellDilemma.Percolation` +
`Infrastructure.BernoulliProductFinite` + Mathlib. Kernel-pure
(`#print axioms` shows only `[propext, Classical.choice, Quot.sound]`).
No paper-novel axioms, no `sorry`. Generic over `Fintype E`.

## Future Mathlib PR

Suggested namespace: `Mathlib.Probability.BondPercolation.Expectation`
or part of an envisioned percolation namespace.

## Tags

bond percolation, percolation expectation, strict positivity,
Mills-tail constant, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

open BlackwellDilemma

/-- **Strict positivity of percolation expectation from per-realisation
    strict positivity**:
    if `f : BondConfig E → ℝ` is non-negative everywhere and strictly
    positive at some configuration `ω₀`, AND `p ∈ (0, 1)` (so all bond
    weights are strictly positive — see `bondConfigWeight_pos`),
    then `0 < percExpectation p f`.

    This is the canonical "non-zero positive contribution implies sum
    is positive" pattern for percolation expectations. Cat 1: kernel-pure. -/
theorem percExpectation_pos_of_kernel_pos_at_some_realisation
    {E : Type} [Fintype E] [DecidableEq E]
    (p : ℝ) (h_p_pos : 0 < p) (h_p_lt_one : p < 1)
    (f : BondConfig E → ℝ)
    (h_nonneg : ∀ ω : BondConfig E, 0 ≤ f ω)
    (ω₀ : BondConfig E) (h_pos_at_ω₀ : 0 < f ω₀) :
    0 < percExpectation p f := by
  unfold percExpectation
  -- ∑ ω, weight ω * f ω > 0 because:
  -- (1) every summand is ≥ 0 (weight ≥ 0 + f ≥ 0)
  -- (2) the ω₀-summand is strictly > 0 (weight > 0 + f > 0)
  -- Apply Finset.sum_pos' (from Mathlib).
  apply Finset.sum_pos' (s := Finset.univ)
  · -- All summands non-negative
    intro ω _
    exact mul_nonneg
      (BlackwellDilemma.bondConfigWeight_nonneg p (le_of_lt h_p_pos)
        (le_of_lt h_p_lt_one) ω)
      (h_nonneg ω)
  · -- ω₀-summand strictly positive
    refine ⟨ω₀, Finset.mem_univ ω₀, ?_⟩
    have h_weight_pos : 0 < bondConfigWeight p ω₀ :=
      BlackwellDilemma.bondConfigWeight_pos p h_p_pos h_p_lt_one ω₀
    exact mul_pos h_weight_pos h_pos_at_ω₀

/-! ### Kernel-purity audit

`#print axioms` on `percExpectation_pos_of_kernel_pos_at_some_realisation`
surfaces ONLY Mathlib kernel axioms (`propext, Classical.choice,
Quot.sound`) — no paper-novel `Types.lean` carriers, no broken-link
`_OPEN` axioms, no `sorry`. This is a Cat 1 generic lemma, foundational
for any paper claim of the form "constant c > 0 exists from positive
contribution at some realisation". -/

#print axioms percExpectation_pos_of_kernel_pos_at_some_realisation

end BlackwellDilemma.Infrastructure
