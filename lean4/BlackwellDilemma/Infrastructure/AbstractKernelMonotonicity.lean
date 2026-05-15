/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import BlackwellDilemma.Infrastructure.BlackwellConditional
import BlackwellDilemma.Infrastructure.MonotoneFunctionAlgebra

/-!
# Abstract per-realisation kernel monotonicity (Cat 1)

This file provides the **abstract kernel-monotonicity pattern** that
paper's `agentRewardKernel_*_pointwise_monotone` axioms instantiate
(R88/R89 batch — Phase 12). The pattern is: a per-realisation
kernel `K : ω → β → ℝ` is "pointwise-monotone in β for each ω", and
its expectation is monotone by lifting via `Finset.sum_le_sum`.

## Main results

* `expectation_mono_of_pointwise_kernel_mono` —
  expectation `E[K(ω, β)] = Σ π(ω) · K(ω, β)` is monotone in β when
  each `K(ω, ·)` is monotone and weights `π` are non-negative.
* `kernel_pointwise_le_kernel_pointwise_imp_expectation_le` —
  pointwise-domination of kernels lifts to expectation domination.

## Bridge to paper carriers

Paper's `agentRewardKernel_normal_pointwise_monotone` etc. claim
monotonicity of the per-realisation kernel `K(ω, β)`, and the
expectation `agentWelfare β = Σ π(ω) · K(ω, β)` then inherits
monotonicity. The bridge from per-realisation kernel monotonicity
(paper-stipulated workingAssumption per ω) to expectation monotonicity
(paper claim) is exactly the lift below.

## Cat 1 status

Built from `BlackwellConditional` (Cat 1). No paper-novel axioms,
no `sorry`. The kernel-lift pattern is Mathlib-PR-contributable as
a probability-theory packaging.

## Tags

kernel, expectation, pointwise monotonicity, per-realisation,
percolation, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### Per-realisation kernel monotonicity → expectation monotonicity -/

/-- **Per-realisation kernel monotonicity → expectation monotonicity.**
    If `K : Ω → ℝ → ℝ` is pointwise-monotone in the parameter for each
    realisation, and weights `π : Ω → ℝ` are non-negative on the finite
    sample space `Ω`, then the expectation `E[K(ω, β)] = Σ π(ω) · K(ω, β)`
    is monotone in β. -/
theorem expectation_mono_of_pointwise_kernel_mono
    {Ω : Type*} (Ω_finset : Finset Ω) (K : Ω → ℝ → ℝ) (π : Ω → ℝ)
    (h_π_nonneg : ∀ ω ∈ Ω_finset, 0 ≤ π ω)
    (h_K_mono : ∀ ω ∈ Ω_finset, ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ → K ω β₁ ≤ K ω β₂)
    {β₁ β₂ : ℝ} (hβ : β₁ ≤ β₂) :
    Ω_finset.sum (fun ω => π ω * K ω β₁) ≤
      Ω_finset.sum (fun ω => π ω * K ω β₂) := by
  apply Finset.sum_le_sum
  intro ω hω
  exact mul_le_mul_of_nonneg_left (h_K_mono ω hω β₁ β₂ hβ) (h_π_nonneg ω hω)

/-- **Pointwise kernel domination → expectation domination.**
    If `K₁ ≤ K₂` pointwise (for each `ω` and each `β`) and weights
    `π` are non-negative, then `E[K₁(ω, β)] ≤ E[K₂(ω, β)]`. -/
theorem expectation_le_of_kernel_pointwise_le
    {Ω : Type*} (Ω_finset : Finset Ω) (K₁ K₂ : Ω → ℝ → ℝ) (π : Ω → ℝ)
    (h_π_nonneg : ∀ ω ∈ Ω_finset, 0 ≤ π ω)
    (h_K_le : ∀ ω ∈ Ω_finset, ∀ β : ℝ, K₁ ω β ≤ K₂ ω β)
    (β : ℝ) :
    Ω_finset.sum (fun ω => π ω * K₁ ω β) ≤
      Ω_finset.sum (fun ω => π ω * K₂ ω β) := by
  apply Finset.sum_le_sum
  intro ω hω
  exact mul_le_mul_of_nonneg_left (h_K_le ω hω β) (h_π_nonneg ω hω)

/-! ### Per-realisation kernel reversal -/

/-- **Per-realisation kernel reversal → expectation reversal.**
    Reversal pattern: if `K(ω, β₁) ≥ K(ω, β₂)` (reversed) for each
    `ω` and `β₁ ≤ β₂`, the expectation also reverses. -/
theorem expectation_reverses_under_kernel_reversal
    {Ω : Type*} (Ω_finset : Finset Ω) (K : Ω → ℝ → ℝ) (π : Ω → ℝ)
    (h_π_nonneg : ∀ ω ∈ Ω_finset, 0 ≤ π ω)
    (h_K_reverse : ∀ ω ∈ Ω_finset, ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ → K ω β₂ ≤ K ω β₁)
    {β₁ β₂ : ℝ} (hβ : β₁ ≤ β₂) :
    Ω_finset.sum (fun ω => π ω * K ω β₂) ≤
      Ω_finset.sum (fun ω => π ω * K ω β₁) := by
  apply Finset.sum_le_sum
  intro ω hω
  exact mul_le_mul_of_nonneg_left (h_K_reverse ω hω β₁ β₂ hβ) (h_π_nonneg ω hω)

/-! ### Kernel-purity audit -/

#print axioms expectation_mono_of_pointwise_kernel_mono
#print axioms expectation_le_of_kernel_pointwise_le

end BlackwellDilemma.Infrastructure
