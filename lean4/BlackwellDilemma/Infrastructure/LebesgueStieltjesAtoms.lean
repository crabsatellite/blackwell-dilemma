/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import BlackwellDilemma.Infrastructure.MonotoneCDFAlgebra
import BlackwellDilemma.Infrastructure.MonotoneFunctionAlgebra
import BlackwellDilemma.Infrastructure.FiniteConvexCombination

/-!
# Stieltjes-style integration atoms (Cat 1)

This file provides **abstract Stieltjes-style integration atoms** for
finite discrete CDFs (sum form), the Phase 13 foundation for paper's
`aggregateWelfareWith` carrier construction. The full measure-theoretic
Lebesgue-Stieltjes integral requires Mathlib `MeasureTheory.LStieltjes`
which is multi-month effort; this module provides the discrete sum
analog that captures the algebraic structure.

## Main definitions

* `discreteStieltjesIntegral G_increment x_grid f` —
  finite-discrete Stieltjes integral `∫ f dG ≈ Σᵢ f(xᵢ) · ΔG(xᵢ)`
  where `ΔG(xᵢ) = G_increment xᵢ` are non-negative weight increments.

## Main results

* `discreteStieltjesIntegral_nonneg` — non-negativity for non-negative
  integrand and weight-increments.
* `discreteStieltjesIntegral_mono_in_integrand` — pointwise integrand
  domination lifts to integral domination.
* `discreteStieltjesIntegral_linear` — linearity in the integrand.

## Bridge to paper carrier `aggregateWelfareWith`

Paper's `aggregateWelfareWith G β = ∫ agentWelfare β κ d(G κ)` is
the Stieltjes integral of `agentWelfare β κ` against CDF G's
distribution measure. The discrete-grid finite-sum approximation
below provides the Cat 1 algebraic atoms that captures the integral's
structural properties; the substantive Stieltjes integration-by-parts
+ measure-theoretic limit theorems remain a Cat 2 dependency.

## Cat 1 status

Built from `MonotoneCDFAlgebra` + `FiniteConvexCombination` (both
Cat 1). No paper-novel axioms, no `sorry`. Mathlib-PR-contributable
as discrete-Stieltjes elementary atoms.

## Tags

Stieltjes integral, CDF, discrete approximation, weighted sum,
aggregateWelfareWith, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### Discrete Stieltjes-style integral -/

/-- **Discrete Stieltjes-style integral**. For a CDF G with discrete
    increment-weights `G_increment : V → ℝ` (i.e., `ΔG(v) = G(v) - G(v⁻)`)
    on a finite grid `x_grid : Finset V`, integrand `f : V → ℝ`, the
    discrete Stieltjes integral is `Σ_{v ∈ x_grid} f v · G_increment v`. -/
def discreteStieltjesIntegral
    {V : Type*} (G_increment : V → ℝ) (x_grid : Finset V)
    (f : V → ℝ) : ℝ :=
  x_grid.sum (fun v => f v * G_increment v)

/-! ### Non-negativity / monotonicity / linearity -/

/-- **Non-negativity** for non-negative integrand + non-negative
    increments. -/
theorem discreteStieltjesIntegral_nonneg
    {V : Type*} (G_increment : V → ℝ) (x_grid : Finset V)
    (f : V → ℝ)
    (h_inc_nonneg : ∀ v ∈ x_grid, 0 ≤ G_increment v)
    (h_f_nonneg : ∀ v ∈ x_grid, 0 ≤ f v) :
    0 ≤ discreteStieltjesIntegral G_increment x_grid f := by
  unfold discreteStieltjesIntegral
  apply Finset.sum_nonneg
  intro v hv
  exact mul_nonneg (h_f_nonneg v hv) (h_inc_nonneg v hv)

/-- **Monotonicity in integrand**: pointwise `f₁ ≤ f₂` lifts to
    `∫ f₁ dG ≤ ∫ f₂ dG` for non-negative weight-increments. -/
theorem discreteStieltjesIntegral_mono_in_integrand
    {V : Type*} (G_increment : V → ℝ) (x_grid : Finset V)
    {f₁ f₂ : V → ℝ}
    (h_inc_nonneg : ∀ v ∈ x_grid, 0 ≤ G_increment v)
    (h_le : ∀ v ∈ x_grid, f₁ v ≤ f₂ v) :
    discreteStieltjesIntegral G_increment x_grid f₁ ≤
      discreteStieltjesIntegral G_increment x_grid f₂ := by
  unfold discreteStieltjesIntegral
  apply Finset.sum_le_sum
  intro v hv
  exact mul_le_mul_of_nonneg_right (h_le v hv) (h_inc_nonneg v hv)

/-- **Linearity** in integrand: `∫ (a · f + b · g) dG = a · ∫ f dG + b · ∫ g dG`. -/
theorem discreteStieltjesIntegral_linear
    {V : Type*} (G_increment : V → ℝ) (x_grid : Finset V)
    (f g : V → ℝ) (a b : ℝ) :
    discreteStieltjesIntegral G_increment x_grid (fun v => a * f v + b * g v) =
      a * discreteStieltjesIntegral G_increment x_grid f +
        b * discreteStieltjesIntegral G_increment x_grid g := by
  unfold discreteStieltjesIntegral
  rw [Finset.mul_sum, Finset.mul_sum, ← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl (fun v _ => ?_)
  ring

/-! ### FOSD-lifted integral monotonicity -/

/-- **Discrete Stieltjes integral monotonicity under weight-FOSD**
    (more weight on right): for non-negative monotone integrand `f`,
    if weight-increments `G₁_inc ≤ G₂_inc` pointwise on the grid AND
    integrand has uniform support property, then
    `∫ f dG₁ ≤ ∫ f dG₂`. -/
theorem discreteStieltjesIntegral_mono_under_weight_dominance
    {V : Type*} (x_grid : Finset V)
    (G₁_increment G₂_increment : V → ℝ) (f : V → ℝ)
    (h_inc_le : ∀ v ∈ x_grid, G₁_increment v ≤ G₂_increment v)
    (h_f_nonneg : ∀ v ∈ x_grid, 0 ≤ f v) :
    discreteStieltjesIntegral G₁_increment x_grid f ≤
      discreteStieltjesIntegral G₂_increment x_grid f := by
  unfold discreteStieltjesIntegral
  apply Finset.sum_le_sum
  intro v hv
  exact mul_le_mul_of_nonneg_left (h_inc_le v hv) (h_f_nonneg v hv)

/-! ### Kernel-purity audit -/

#print axioms discreteStieltjesIntegral_nonneg
#print axioms discreteStieltjesIntegral_mono_in_integrand
#print axioms discreteStieltjesIntegral_linear

end BlackwellDilemma.Infrastructure
