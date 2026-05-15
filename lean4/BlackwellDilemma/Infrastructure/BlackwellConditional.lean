/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Data.Finset.Basic
import Mathlib.Data.Real.Basic

/-!
# Conditional welfare monotonicity from pointwise monotonicity (Cat 1)

This file provides the **Finset-sum lift** of pointwise monotonicity to
restricted-domain monotonicity, addressing the integration-side of paper's
`conditional_subproblem_blackwell_applicable_paper_witness` axiom (paper
Lemma `lem:conditional-reduction` part (i) line 375).

## Main results

* `finset_sum_mono_of_pointwise_mono` —
  if `h v β` is monotone non-decreasing in `β` for each `v ∈ R`, then
  `Σ_{v ∈ R} h v β` is monotone non-decreasing in `β`.
* `finset_sum_mono_of_pointwise_mono_with_weights` —
  weighted version with non-negative weights `π v ≥ 0`.

## Bridge to paper carrier `conditionalWelfareOnR`

The paper's `conditionalWelfareOnR R signalFamily β` is constructed
as a sum/integral over `R` of `agentWelfare β (signalFamily β ω) …`.
Under Blackwell-ordering of `signalFamily` + bayesian monotonicity at
baseline (paper's hypothesis), the per-vertex welfare term is monotone
in β. This Cat 1 module then lifts pointwise monotonicity to the
finset-sum / integral level.

## Cat 2 dependency

The substantive Blackwell 1953 step (signal-family ordering →
expected-utility monotonicity for any decision rule) remains a Cat 2
axiom dependency. This Cat 1 module handles only the trivial-but-
essential lift from pointwise to summed monotonicity.

## Cat 1 status

Built only from `Mathlib.Algebra.BigOperators.Order.Group`. No
paper-novel axioms, no `sorry`. The lift is Mathlib-PR-contributable
as a `Finset.sum_le_sum` packaging.

## Tags

Blackwell, conditional welfare, Finset sum, pointwise monotonicity,
restriction inheritance, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### Pointwise → Finset-sum monotonicity lift -/

/-- **Pointwise monotonicity lifts to finset sum.**
    If `h v β` is monotone non-decreasing in `β` for each `v` in the
    finset `R`, then `Σ_{v ∈ R} h v β` is monotone non-decreasing in `β`.

    This is the integration side of the paper's "Blackwell ordering on
    the conditional subproblem on R" claim — pointwise monotonicity
    (provided by Blackwell 1953 Cat 2 dependency) lifts to summed
    monotonicity by `Finset.sum_le_sum`.

    Cat 1: kernel-pure, single-line `Finset.sum_le_sum` application. -/
theorem finset_sum_mono_of_pointwise_mono
    {V : Type*} (R : Finset V)
    (h : V → ℝ → ℝ)
    (h_mono : ∀ v ∈ R, ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ → h v β₁ ≤ h v β₂)
    {β₁ β₂ : ℝ} (hβ : β₁ ≤ β₂) :
    (R.sum (fun v => h v β₁)) ≤ R.sum (fun v => h v β₂) :=
  Finset.sum_le_sum (fun v hv => h_mono v hv β₁ β₂ hβ)

/-- **Weighted pointwise → Finset-sum monotonicity** (non-negative weights).
    With weights `π v ≥ 0`, the weighted sum
    `Σ_{v ∈ R} π v · h v β` is monotone in `β`. -/
theorem finset_sum_mono_of_pointwise_mono_with_weights
    {V : Type*} (R : Finset V)
    (h : V → ℝ → ℝ) (π : V → ℝ)
    (h_pi_nonneg : ∀ v ∈ R, 0 ≤ π v)
    (h_mono : ∀ v ∈ R, ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ → h v β₁ ≤ h v β₂)
    {β₁ β₂ : ℝ} (hβ : β₁ ≤ β₂) :
    (R.sum (fun v => π v * h v β₁)) ≤ R.sum (fun v => π v * h v β₂) := by
  apply Finset.sum_le_sum
  intro v hv
  exact mul_le_mul_of_nonneg_left (h_mono v hv β₁ β₂ hβ) (h_pi_nonneg v hv)

/-! ### Restriction inheritance of monotonicity -/

/-- **Restriction-inheritance of monotonicity.**
    If a function `f : ℝ → ℝ` is monotone non-decreasing on the full
    domain, then it is monotone non-decreasing on any subset of the
    domain (trivially). -/
theorem mono_inherits_to_restriction
    {f : ℝ → ℝ} (h_mono : ∀ x₁ x₂ : ℝ, x₁ ≤ x₂ → f x₁ ≤ f x₂)
    (S : Set ℝ) :
    ∀ x₁ ∈ S, ∀ x₂ ∈ S, x₁ ≤ x₂ → f x₁ ≤ f x₂ :=
  fun x₁ _ x₂ _ h => h_mono x₁ x₂ h

/-! ### Bridge atom to paper's `conditional_subproblem_blackwell_applicable`

The paper-bridge axiom takes the form: bayesian-baseline-monotonicity
+ Blackwell-ordered signal family ⇒ conditionalWelfareOnR monotone.

The Cat 1 piece established above (`finset_sum_mono_of_pointwise_mono`)
shows that pointwise monotonicity (provided by Blackwell 1953 + the
baseline hypothesis) lifts to summed monotonicity. The remaining
bridge step is the per-vertex Blackwell-ordering application
(Cat 2 axiom dependency) and the paper-stipulated identification
`conditionalWelfareOnR R sf β = Σ_{v ∈ R} π(v) · agentWelfare(β, sf β ω(v))`. -/

/-! ### Kernel-purity audit

`#print axioms` on `finset_sum_mono_of_pointwise_mono` surfaces ONLY
Mathlib kernel axioms (`propext, Classical.choice, Quot.sound`) — no
paper-novel `Types.lean` carriers, no broken-link `_OPEN` axioms,
no `sorry`. This provides the Cat 1 finset-sum lift; the Cat 2
Blackwell 1953 step + paper-novel bridge identification handle the
remaining axiom retirement work. -/

#print axioms finset_sum_mono_of_pointwise_mono

end BlackwellDilemma.Infrastructure
