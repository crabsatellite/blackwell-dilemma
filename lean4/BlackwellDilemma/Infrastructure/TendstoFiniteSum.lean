/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import BlackwellDilemma.Infrastructure.TendstoLimitArithmetic
import Mathlib.Algebra.BigOperators.Group.Finset.Defs

/-!
# Tendsto of Finset sums (Cat 1)

This file provides **Tendsto preservation under Finset sums**, the
operational tool for paper's `agentRewardKernel_greedy_pointwise_tendsto_atTop`
axiom, where pointwise Tendsto of per-realisation
kernel lifts to Tendsto of the expectation (Finset-weighted sum).

## Main results

* `tendsto_finset_sum_of_pointwise_tendsto` —
  if `f i β → L i` for each `i ∈ R` as `β → ∞`, then
  `Σ_{i ∈ R} f i β → Σ_{i ∈ R} L i`.

## Bridge to paper carrier `agentRewardKernel_greedy_pointwise_tendsto_atTop`

Paper's claim: for each realisation `ω` of percolation, the per-vertex
greedy kernel `K(ω, β) → K_∞(ω)` as `β → ∞`. The expectation
`agentWelfare β = Σ_ω P(ω) · K(ω, β) → Σ_ω P(ω) · K_∞(ω)` follows
by Finset-weighted-sum continuity. This is exactly the lift below.

## Cat 1 status

Built from `TendstoLimitArithmetic` (Cat 1) and Mathlib's
`Finset.sum`. No paper-novel axioms, no `sorry`.
Mathlib-PR-contributable as a Finset-Tendsto packaging.

## Tags

Tendsto, Finset.sum, pointwise convergence, expectation, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

open Filter

/-! ### Tendsto of Finset sums -/

/-- **Tendsto preservation under Finset.sum** (real-valued, finite
    index). If `f i β → L i` for each `i ∈ R` as `β → ∞`, then
    `Σ_{i ∈ R} f i β → Σ_{i ∈ R} L i`. -/
theorem tendsto_finset_sum_of_pointwise_tendsto
    {ι α : Type*} (R : Finset ι) (l : Filter α)
    (f : ι → α → ℝ) (L : ι → ℝ)
    (h_pw : ∀ i ∈ R, Tendsto (fun a => f i a) l (nhds (L i))) :
    Tendsto (fun a => R.sum (fun i => f i a)) l (nhds (R.sum L)) :=
  tendsto_finset_sum R h_pw

/-- **Tendsto preservation for weighted Finset.sum**. If `f i β → L i`
    pointwise on `R` and weights `w : ι → ℝ` are constant in `β`, then
    `Σ_{i ∈ R} w i · f i β → Σ_{i ∈ R} w i · L i`. -/
theorem tendsto_finset_weighted_sum
    {ι α : Type*} (R : Finset ι) (l : Filter α)
    (w : ι → ℝ) (f : ι → α → ℝ) (L : ι → ℝ)
    (h_pw : ∀ i ∈ R, Tendsto (fun a => f i a) l (nhds (L i))) :
    Tendsto (fun a => R.sum (fun i => w i * f i a)) l
      (nhds (R.sum (fun i => w i * L i))) := by
  apply tendsto_finset_sum
  intro i hi
  -- (w i) is constant in `a`, so by Tendsto.mul on a constant
  exact (tendsto_const_nhds : Tendsto (fun _ : α => w i) l (nhds (w i))).mul (h_pw i hi)

/-! ### Kernel-purity audit -/

#print axioms tendsto_finset_sum_of_pointwise_tendsto
#print axioms tendsto_finset_weighted_sum

end BlackwellDilemma.Infrastructure
