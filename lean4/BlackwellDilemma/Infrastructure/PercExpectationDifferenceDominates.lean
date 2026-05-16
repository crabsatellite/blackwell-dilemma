/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import BlackwellDilemma.Percolation
import BlackwellDilemma.Infrastructure.DifferenceQuotientAlgebra
import BlackwellDilemma.Infrastructure.BernoulliProductFinite

/-!
# Percolation expectation lifting of difference-dominance (Cat 1)

This module provides the Cat 1 lifting lemma:
**If for every realisation `ω`, the kernel pair `(f β ω, g β ω)`
satisfies `DifferenceDominates (f · ω) (g · ω)`, then the
percolation expectation pair
`(percExpectation p (f β), percExpectation p (g β))`
also satisfies `DifferenceDominates`.**

Sister module to:
* `PercExpectationSupermodular.lean` (R178; lifting of supermodularity)
* `DifferenceDominatesFinsetSum.lean` (R182; finset-sum extension)

## Main result

* `percExpectation_differenceDominates_of_pointwise_differenceDominates` —
  per-ω difference-dominance lifts to percExpectation difference-dominance.

## Cat 1 status

Built only from existing Cat 1 infrastructure
(`BlackwellDilemma.Percolation`, `Infrastructure.DifferenceQuotientAlgebra`,
`Infrastructure.BernoulliProductFinite`) + Mathlib. Generic over
`Fintype E`. Kernel-pure (`#print axioms` shows only `[propext,
Classical.choice, Quot.sound]`). No paper-novel axioms, no `sorry`.

## Future Mathlib PR

Suggested namespace: extension of an envisioned
`Mathlib.Order.DifferenceDominates` namespace with positive-measure-
weighted-sum preservation lemmas (sister of similar Mathlib lemmas
for `IsSupermodular`).

## Tags

difference dominates, percolation expectation, pointwise lifting,
weighted sum, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

open BlackwellDilemma

/-- **Pointwise → expectation lifting of difference-dominance**:
    if for every realisation `ω`, the kernel pair `(β → f β ω,
    β → g β ω)` satisfies `DifferenceDominates`, AND the bond-
    percolation parameter `p ∈ [0, 1]`, then the percolation
    expectation pair `(β → percExpectation p (f β), β → percExpectation
    p (g β))` also satisfies `DifferenceDominates`.

    Proof sketch: rewrite both sides of the difference-dominance
    inequality via linearity of `percExpectation` (weighted finite
    sum); the pointwise difference-dominance inequality times the
    non-negative bond weight gives a non-negative integrand summand;
    `Finset.sum_le_sum` lifts to the integrated form.

    Cat 1: kernel-pure. -/
theorem percExpectation_differenceDominates_of_pointwise_differenceDominates
    {E : Type} [Fintype E] [DecidableEq E]
    (p : ℝ) (h_p_nonneg : 0 ≤ p) (h_p_le_one : p ≤ 1)
    (f g : ℝ → BondConfig E → ℝ)
    (h_ptwise : ∀ ω : BondConfig E,
      DifferenceDominates (fun β => f β ω) (fun β => g β ω)) :
    DifferenceDominates
      (fun β => percExpectation p (fun ω => f β ω))
      (fun β => percExpectation p (fun ω => g β ω)) := by
  intro β₁ β₂ hβ
  -- Goal: percExpectation p (g β₂) - percExpectation p (g β₁)
  --       ≤ percExpectation p (f β₂) - percExpectation p (f β₁)
  unfold percExpectation
  -- Each percExpectation is `∑ ω, bondConfigWeight p ω * h _ ω`.
  -- Rewrite both sides using sum_sub_distrib.
  rw [← Finset.sum_sub_distrib, ← Finset.sum_sub_distrib]
  apply Finset.sum_le_sum (s := Finset.univ)
  intro ω _
  -- Per-ω: weight * g β₂ ω - weight * g β₁ ω ≤ weight * f β₂ ω - weight * f β₁ ω
  -- ⟺ weight * (g β₂ ω - g β₁ ω) ≤ weight * (f β₂ ω - f β₁ ω)
  have h_diff := h_ptwise ω β₁ β₂ hβ
  -- h_diff: g β₂ ω - g β₁ ω ≤ f β₂ ω - f β₁ ω
  have h_weight_nonneg : 0 ≤ bondConfigWeight p ω :=
    BlackwellDilemma.bondConfigWeight_nonneg p h_p_nonneg h_p_le_one ω
  nlinarith [h_diff, h_weight_nonneg]

/-! ### Kernel-purity audit

`#print axioms` on `percExpectation_differenceDominates_of_pointwise_differenceDominates`
surfaces ONLY Mathlib kernel axioms (`propext, Classical.choice,
Quot.sound`) — no paper-novel `Types.lean` carriers, no broken-link
`_OPEN` axioms, no `sorry`. This is a Cat 1 generic lifting lemma,
Mathlib-PR-contributable as a positive-measure-weighted-sum
preservation theorem for the `DifferenceDominates` lattice. -/

#print axioms percExpectation_differenceDominates_of_pointwise_differenceDominates

end BlackwellDilemma.Infrastructure
