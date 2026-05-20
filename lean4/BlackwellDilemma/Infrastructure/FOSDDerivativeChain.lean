/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import BlackwellDilemma.Infrastructure.TopkisCrossPartial

/-!
# FOSD + supermodular ⇒ β-increment derivative-domination (Cat 1)

This file provides the **abstract comparative-statics chain** from
supermodularity to β-increment dominance, which is the operational
content of paper's `fosd_induces_derivative_domination_paper_witness`
axiom (paper Proposition `prop:principal-optimum` Part 2 line 634).

## Main results

* `IsSupermodular.beta_increment_dominance` —
  `IsSupermodular f` ⇒ `∀ x₁ ≤ x₂ y₁ ≤ y₂,
  f x₂ y₂ - f x₂ y₁ ≥ f x₁ y₂ - f x₁ y₁`. This is the four-corner
  inequality rearranged into the β-increment-dominance form: the
  y-increment under x₂ dominates the y-increment under x₁.

This is Topkis's monotone comparative statics in its purest abstract
form, modulo no integration. The substantive integration step
(FOSD on CDFs G₁ ≤_FOSD G₂ + supermodular integrand `f β κ` ⇒
`∫ f β κ d(G₂ κ)` β-increment dominates `∫ f β κ d(G₁ κ)` β-increment)
requires Mathlib's `MeasureTheory.Integral` infrastructure and is
deferred to a follow-up integration-step extension.

## Bridge to paper carrier `aggregateWelfareWith`

The paper's `aggregateWelfareWith G β = ∫ agentWelfare β κ dG(κ)` is
constructed as the integral of `agentWelfare β κ` against the CDF G.
The bridge from this Cat 1 abstract result to the paper-stipulated
`fosd_induces_derivative_domination_paper_witness` requires:

1. **β-increment-dominance preservation under integration** — the
   substantive integration step (Mathlib `MeasureTheory.Integral`).
2. **Supermodularity of `agentWelfare β κ`** — paper carrier
   property (workingAssumption per paper Proposition `prop:supermodular`,
   to be retired via a calculus-Topkis criterion when carrier is concretized).

With (1) and (2), the paper axiom becomes a direct Cat 1 corollary of
`IsSupermodular.beta_increment_dominance` composed with the integration
preservation lemma.

## Cat 1 status

Built only from `Infrastructure.TopkisCrossPartial` (which is itself
Cat 1 from Mathlib base). No paper-novel axioms, no `sorry`. The
β-increment-dominance lemma is Mathlib-PR-contributable as an
elementary consequence of lattice supermodularity.

## Tags

supermodular, FOSD, derivative-domination, β-increment, comparative
statics, Topkis, monotone optimum, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### Abstract β-increment dominance from supermodularity -/

/-- **Abstract β-increment dominance from supermodularity.**

    Let `f : ℝ → ℝ → ℝ` be supermodular. Then for any `x₁ ≤ x₂` and
    `y₁ ≤ y₂`, the y-increment under x₂ dominates the y-increment
    under x₁:
    `f x₂ y₂ - f x₂ y₁ ≥ f x₁ y₂ - f x₁ y₁`.

    This is the four-corner inequality
    `f x₁ y₁ + f x₂ y₂ ≥ f x₁ y₂ + f x₂ y₁`
    rearranged into the β-increment-dominance form by subtracting
    `f x₁ y₁ + f x₂ y₁` from both sides.

    Cat 1: kernel-pure (single-line `linarith` from
    `IsSupermodular`). -/
theorem IsSupermodular.beta_increment_dominance
    {f : ℝ → ℝ → ℝ} (hf : IsSupermodular f)
    {x₁ x₂ y₁ y₂ : ℝ} (hx : x₁ ≤ x₂) (hy : y₁ ≤ y₂) :
    f x₂ y₂ - f x₂ y₁ ≥ f x₁ y₂ - f x₁ y₁ := by
  have h := hf x₁ x₂ y₁ y₂ hx hy
  linarith

/-- **Equivalent form**: the x-increment under y₂ dominates the
    x-increment under y₁. By symmetry of the four-corner inequality. -/
theorem IsSupermodular.alpha_increment_dominance
    {f : ℝ → ℝ → ℝ} (hf : IsSupermodular f)
    {x₁ x₂ y₁ y₂ : ℝ} (hx : x₁ ≤ x₂) (hy : y₁ ≤ y₂) :
    f x₂ y₂ - f x₁ y₂ ≥ f x₂ y₁ - f x₁ y₁ := by
  have h := hf x₁ x₂ y₁ y₂ hx hy
  linarith

/-! ### Bridge atom to paper's `fosd_induces_derivative_domination`

The paper's claim about `aggregateWelfareWith G β` is the
β-increment-dominance form

  `aggregateWelfareWith G₁ β₂ - aggregateWelfareWith G₁ β₁ ≤
   aggregateWelfareWith G₂ β₂ - aggregateWelfareWith G₂ β₁`

under FOSD `G₁ ≤_FOSD G₂` and `β₁ ≤ β₂`. This is the integral
version of `IsSupermodular.beta_increment_dominance` lifted from
pointwise `agentWelfare β κ` to integrated `aggregateWelfareWith G β`.
The lift requires a measure-theoretic
β-increment-dominance-preservation-under-integration lemma. -/

/-- **Operational bridge atom** for the paper's
    `fosd_induces_derivative_domination` axiom: if a binary function
    `f : ℝ → ℝ → ℝ` is supermodular AND any pair of "first-argument"
    values `x₁ ≤ x₂` satisfies the β-increment-dominance, then
    we get the paper's derivative-domination form.

    This is just `IsSupermodular.beta_increment_dominance` re-named
    in the paper's notation; provides a single named theorem for
    paper-bridge consumption. -/
theorem derivative_domination_of_supermodular
    {f : ℝ → ℝ → ℝ} (hf : IsSupermodular f)
    (x₁ x₂ y₁ y₂ : ℝ) (hx : x₁ ≤ x₂) (hy : y₁ ≤ y₂) :
    f x₁ y₂ - f x₁ y₁ ≤ f x₂ y₂ - f x₂ y₁ := by
  have h := hf.beta_increment_dominance hx hy
  linarith

/-! ### Kernel-purity audit

`#print axioms` on `derivative_domination_of_supermodular` surfaces
ONLY Mathlib kernel axioms (`propext, Classical.choice, Quot.sound`)
— no paper-novel `Types.lean` carriers, no broken-link `_OPEN` axioms,
no `sorry`. This is the abstract Cat 1 chain from supermodularity to
β-increment-dominance, modulo the integration step. -/

#print axioms derivative_domination_of_supermodular

end BlackwellDilemma.Infrastructure
