/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import BlackwellDilemma.Infrastructure.BernoulliProductFinite
import BlackwellDilemma.Infrastructure.UnitIntervalAlgebra

/-!
# Finite percolation expectation (Cat 1)

This file provides the **finite percolation expectation** framework
constructed from `BernoulliProductFinite` weights, the operational
core of paper's `percExpectation` carrier on a finite outcome space.

## Main definitions

* `percExpectation_finite p E_finset Ω_finset f` —
  the expectation `Σ_ω P(ω) · f(ω)` for `ω` ranging over the finite
  outcome space `Ω_finset` (typically `(E → Bool)`-restricted), under
  the Bernoulli product measure with parameter `p`.

## Main results

* `percExpectation_nonneg` — non-negative under non-negative integrand
  and `p ∈ [0, 1]`.
* `percExpectation_le` — pointwise integrand domination lifts to
  expectation domination.
* `percExpectation_const_zero` — expectation of zero is zero.

## Bridge to paper carrier `percExpectation`

Paper's `percExpectation : ℝ → (PercolationOutcome → ℝ) → ℝ`
takes the form `percExpectation p f = ∫ f dμ_p` where `μ_p` is the
Bernoulli product measure with parameter `p`. On the finite-outcome
restriction, this is exactly `Σ_ω P_p(ω) · f(ω)` as defined below.

## Cat 1 status

Built from `BernoulliProductFinite` and `UnitIntervalAlgebra` (both
Cat 1). No paper-novel axioms, no `sorry`. Mathlib-PR-contributable
as a finite-percolation foundational module.

## Tags

percolation, expectation, finite product, Bernoulli, BondConfig,
Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### Finite percolation expectation -/

/-- **Finite percolation expectation.** For an integrand `f : (E → Bool) → ℝ`
    over a finite outcome set `Ω_finset` (with integration weights given
    by Bernoulli factors with parameter `p` over edge set `E_finset`),
    the expectation `E[f] = Σ_ω P(ω) · f(ω)`. -/
def percExpectation_finite {E : Type*}
    (p : ℝ) (E_finset : Finset E)
    (Ω_finset : Finset (E → Bool)) (f : (E → Bool) → ℝ) : ℝ :=
  Ω_finset.sum (fun ω => bernoulliWeight p E_finset ω * f ω)

/-! ### Non-negativity -/

/-- **Non-negativity** of expectation for non-negative integrand
    and `p ∈ [0, 1]`. -/
theorem percExpectation_finite_nonneg {E : Type*}
    {p : ℝ} (h_p : 0 ≤ p ∧ p ≤ 1)
    (E_finset : Finset E) (Ω_finset : Finset (E → Bool))
    {f : (E → Bool) → ℝ} (hf_nonneg : ∀ ω ∈ Ω_finset, 0 ≤ f ω) :
    0 ≤ percExpectation_finite p E_finset Ω_finset f := by
  unfold percExpectation_finite
  apply Finset.sum_nonneg
  intro ω hω
  exact mul_nonneg (bernoulliWeight_nonneg E_finset h_p ω) (hf_nonneg ω hω)

/-! ### Monotonicity in integrand -/

/-- **Pointwise integrand domination lifts to expectation domination.**
    For `f₁ ≤ f₂` pointwise on `Ω_finset`, the expectations satisfy
    `E[f₁] ≤ E[f₂]` provided `p ∈ [0, 1]`. -/
theorem percExpectation_finite_mono {E : Type*}
    {p : ℝ} (h_p : 0 ≤ p ∧ p ≤ 1)
    (E_finset : Finset E) (Ω_finset : Finset (E → Bool))
    {f₁ f₂ : (E → Bool) → ℝ}
    (h_le : ∀ ω ∈ Ω_finset, f₁ ω ≤ f₂ ω) :
    percExpectation_finite p E_finset Ω_finset f₁ ≤
      percExpectation_finite p E_finset Ω_finset f₂ := by
  unfold percExpectation_finite
  apply Finset.sum_le_sum
  intro ω hω
  exact mul_le_mul_of_nonneg_left (h_le ω hω)
    (bernoulliWeight_nonneg E_finset h_p ω)

/-- **Expectation of zero is zero.** -/
theorem percExpectation_finite_const_zero {E : Type*}
    (p : ℝ) (E_finset : Finset E) (Ω_finset : Finset (E → Bool)) :
    percExpectation_finite p E_finset Ω_finset (fun _ => 0) = 0 := by
  unfold percExpectation_finite
  simp

/-! ### Linearity -/

/-- **Linearity** of expectation in integrand: `E[a·f + b·g] = a·E[f] + b·E[g]`. -/
theorem percExpectation_finite_linear {E : Type*}
    (p : ℝ) (E_finset : Finset E) (Ω_finset : Finset (E → Bool))
    (f g : (E → Bool) → ℝ) (a b : ℝ) :
    percExpectation_finite p E_finset Ω_finset
        (fun ω => a * f ω + b * g ω) =
      a * percExpectation_finite p E_finset Ω_finset f +
        b * percExpectation_finite p E_finset Ω_finset g := by
  unfold percExpectation_finite
  rw [Finset.mul_sum, Finset.mul_sum, ← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl (fun ω _ => ?_)
  ring

/-! ### Kernel-purity audit -/

#print axioms percExpectation_finite_nonneg
#print axioms percExpectation_finite_mono

end BlackwellDilemma.Infrastructure
