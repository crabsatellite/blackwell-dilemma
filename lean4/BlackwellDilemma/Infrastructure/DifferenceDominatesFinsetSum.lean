/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import BlackwellDilemma.Infrastructure.DifferenceQuotientAlgebra
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Order.BigOperators.Group.Finset

/-!
# Finset.sum preservation of difference-dominance (Cat 1)

This module extends `DifferenceDominates.add` (binary additivity) to
finite sums, providing the Mathlib-PR-ready generic lemma:

**Pointwise-pair difference-dominance is preserved under finite sums.**

Sister module to `SupermodularityFinsetSum.lean` (R179) for the
`DifferenceDominates` lattice structure.

## Main results

* `DifferenceDominates.finset_sum` — `(∀ i ∈ S, DifferenceDominates
  (f i) (g i)) ⇒ DifferenceDominates (∑ i ∈ S, f i ·) (∑ i ∈ S, g i ·)`.
* `DifferenceDominates.finset_sum_smul_nonneg` — `(∀ i ∈ S, 0 ≤ c i
  ∧ DifferenceDominates (f i) (g i)) ⇒ DifferenceDominates
  (∑ i ∈ S, c i * f i ·) (∑ i ∈ S, c i * g i ·)`.

## Cat 1 status

Built only from `DifferenceQuotientAlgebra` + Mathlib `BigOperators`.
Kernel-pure (`#print axioms` shows only `[propext, Classical.choice,
Quot.sound]`). No paper-novel axioms, no `sorry`. Generic over
arbitrary `Finset` index types.

## Future Mathlib PR

Suggested namespace: extension of an envisioned
`Mathlib.Order.DifferenceDominates` namespace, alongside
`Mathlib.Order.Supermodular`.

## Tags

difference dominates, finset sum, additivity, weighted sum, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

open Finset

/-- **Finset.sum preservation of difference-dominance**:
    if every pair `(f i, g i)` for `i ∈ S` satisfies
    `DifferenceDominates (f i) (g i)`, then so does the pair of
    pointwise sums.

    Generalises `DifferenceDominates.add` (binary case) to arbitrary
    finite index sets. Cat 1: kernel-pure. -/
theorem DifferenceDominates.finset_sum {ι : Type*} (S : Finset ι)
    (f g : ι → ℝ → ℝ)
    (h : ∀ i ∈ S, DifferenceDominates (f i) (g i)) :
    DifferenceDominates (fun β => ∑ i ∈ S, f i β) (fun β => ∑ i ∈ S, g i β) := by
  intro β₁ β₂ hβ
  -- Goal: (∑ i ∈ S, g i β₂) - (∑ i ∈ S, g i β₁) ≤ (∑ i ∈ S, f i β₂) - (∑ i ∈ S, f i β₁)
  -- ⟺ ∑ i ∈ S, (g i β₂ - g i β₁) ≤ ∑ i ∈ S, (f i β₂ - f i β₁)
  rw [← Finset.sum_sub_distrib, ← Finset.sum_sub_distrib]
  apply Finset.sum_le_sum (s := S)
  intro i hi
  exact h i hi β₁ β₂ hβ

/-- **Weighted Finset.sum preservation of difference-dominance**:
    if every pair `(f i, g i)` is `DifferenceDominates` AND every
    weight `c i ≥ 0`, then the weighted-sum pair is also dominating. -/
theorem DifferenceDominates.finset_sum_smul_nonneg {ι : Type*} (S : Finset ι)
    (c : ι → ℝ) (f g : ι → ℝ → ℝ)
    (hc : ∀ i ∈ S, 0 ≤ c i)
    (h : ∀ i ∈ S, DifferenceDominates (f i) (g i)) :
    DifferenceDominates
      (fun β => ∑ i ∈ S, c i * f i β)
      (fun β => ∑ i ∈ S, c i * g i β) := by
  apply DifferenceDominates.finset_sum S
    (fun i β => c i * f i β) (fun i β => c i * g i β)
  intro i hi
  exact (h i hi).smul_nonneg (hc i hi)

/-! ### Kernel-purity audit

`#print axioms` on the main theorems surfaces ONLY Mathlib kernel
axioms (`propext, Classical.choice, Quot.sound`) — no paper-novel
carriers, no broken-link `_OPEN` axioms, no `sorry`. These are Cat 1
generic algebraic preservation lemmas, Mathlib-PR-contributable as
the canonical `Finset.sum` extensions of `DifferenceDominates.add`. -/

#print axioms DifferenceDominates.finset_sum
#print axioms DifferenceDominates.finset_sum_smul_nonneg

end BlackwellDilemma.Infrastructure
