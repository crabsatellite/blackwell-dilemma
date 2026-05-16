/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import BlackwellDilemma.Percolation
import BlackwellDilemma.Infrastructure.TopkisCrossPartial
import BlackwellDilemma.Infrastructure.BernoulliProductFinite

/-!
# Percolation expectation of a supermodular kernel is supermodular (Cat 1)

This module provides the Cat 1 lifting lemma:
**If for every realisation `ω`, the kernel `(β, κ) → f β κ ω` is
supermodular in `(β, κ)`, then the percolation expectation
`(β, κ) → percExpectation p (fun ω => f β κ ω)` is supermodular.**

This is the percolation-side analogue of `Finset.sum`-style lifting
of a Topkis-type four-corner inequality from the integrand to the
expectation.

## Main result

* `percExpectation_supermodular_of_pointwise_supermodular` — the
  pointwise → expectation lifting of supermodularity for kernels
  parameterised by two real arguments `(β, κ)`.

## Cat 1 status

Built only from existing Cat 1 infrastructure (`BlackwellDilemma.Percolation`,
`BlackwellDilemma.Infrastructure.TopkisCrossPartial`,
`BlackwellDilemma.Infrastructure.BernoulliProductFinite`) + Mathlib.
No paper-novel axioms, no `sorry`. Generic over `Fintype E` (works
for any finite event-type, not just `BlackwellDilemma`-specific).

## Future Mathlib PR

Suggested namespace: `Mathlib.Order.Supermodular` (which doesn't yet
exist; would be created by a PR contributing the abstract
`IsSupermodular` definition + algebraic preservation lemmas — including
this lifting lemma which generalises naturally to any positive-measure
weighted sum).

## Tags

supermodular, Topkis, percolation expectation, pointwise lifting,
weighted sum, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

open BlackwellDilemma

/-- **Pointwise → expectation lifting of supermodularity**:
    if for every realisation `ω`, the kernel `(β, κ) → f β κ ω` is
    `IsSupermodular`, AND the bond-percolation parameter `p` is in
    `[0, 1]`, then the percolation expectation
    `(β, κ) → percExpectation p (fun ω => f β κ ω)` is
    `IsSupermodular`.

    Proof sketch: rewrite both sides of the four-corner inequality
    via the linearity of `percExpectation` (which is a weighted finite
    sum); the pointwise four-corner inequality times the non-negative
    bond weight gives a non-negative integrand summand-by-summand;
    `Finset.sum_le_sum` lifts to the integrated form.

    Cat 1: kernel-pure (composes `Finset.sum_le_sum` +
    `bernoulliWeight_nonneg` + per-ω supermodularity hypothesis). -/
theorem percExpectation_supermodular_of_pointwise_supermodular
    {E : Type} [Fintype E] [DecidableEq E]
    (p : ℝ) (h_p_nonneg : 0 ≤ p) (h_p_le_one : p ≤ 1)
    (f : ℝ → ℝ → BondConfig E → ℝ)
    (h_ptwise : ∀ ω : BondConfig E, IsSupermodular (fun β κ => f β κ ω)) :
    IsSupermodular (fun β κ => percExpectation p (fun ω => f β κ ω)) := by
  intro β₁ β₂ κ₁ κ₂ hβ hκ
  -- Goal: percExpectation p (...β₁,κ₁) + percExpectation p (...β₂,κ₂)
  --       ≥ percExpectation p (...β₁,κ₂) + percExpectation p (...β₂,κ₁)
  unfold percExpectation
  -- Each percExpectation is `∑ ω, bondConfigWeight p ω * f _ _ ω`.
  -- Combine LHS sums and RHS sums via `Finset.sum_add_distrib`.
  rw [← Finset.sum_add_distrib, ← Finset.sum_add_distrib]
  -- Now goal: ∑ ω, (weight * f β₁ κ₂ + weight * f β₂ κ₁) ≤
  --          ∑ ω, (weight * f β₁ κ₁ + weight * f β₂ κ₂)
  apply Finset.sum_le_sum
  intro ω _
  -- Per-ω: weight * f β₁ κ₂ + weight * f β₂ κ₁ ≤ weight * f β₁ κ₁ + weight * f β₂ κ₂
  -- ⟺ weight * (f β₁ κ₁ + f β₂ κ₂ - f β₁ κ₂ - f β₂ κ₁) ≥ 0
  have h_super := h_ptwise ω β₁ β₂ κ₁ κ₂ hβ hκ
  -- h_super: f β₁ κ₁ ω + f β₂ κ₂ ω ≥ f β₁ κ₂ ω + f β₂ κ₁ ω
  have h_weight_nonneg : 0 ≤ bondConfigWeight p ω :=
    BlackwellDilemma.bondConfigWeight_nonneg p h_p_nonneg h_p_le_one ω
  nlinarith [h_super, h_weight_nonneg]

/-! ### Kernel-purity audit

`#print axioms` on `percExpectation_supermodular_of_pointwise_supermodular`
surfaces ONLY Mathlib kernel axioms (`propext, Classical.choice,
Quot.sound`) — no paper-novel `Types.lean` carriers, no broken-link
`_OPEN` axioms, no `sorry`. This is a Cat 1 generic lifting lemma,
Mathlib-PR-contributable as a positive-measure-weighted-sum
preservation theorem for the (yet-to-be-created) `Order.Supermodular`
namespace. -/

#print axioms percExpectation_supermodular_of_pointwise_supermodular

end BlackwellDilemma.Infrastructure
