/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import BlackwellDilemma.Infrastructure.TopkisCrossPartial
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Order.BigOperators.Group.Finset

/-!
# Finset.sum supermodularity preservation (Cat 1)

This module extends `IsSupermodular.add` (binary additivity) to
finite sums, providing the Mathlib-PR-ready generic lemma:

**The pointwise sum of supermodular functions over a finite index
set is supermodular.**

This generalises both `IsSupermodular.add` (the `Finset` `{a, b}`
special case) and the percolation-specific
`percExpectation_supermodular_of_pointwise_supermodular`
(the bond-config-weighted Finset.sum special case).

## Main results

* `IsSupermodular.finset_sum` — `∀ i ∈ S, IsSupermodular (f i) ⇒
  IsSupermodular (fun β κ => ∑ i ∈ S, f i β κ)`.
* `IsSupermodular.finset_sum_smul_nonneg` — `∀ i ∈ S, 0 ≤ c i ∧
  IsSupermodular (f i) ⇒ IsSupermodular (fun β κ => ∑ i ∈ S, c i * f i β κ)`.

## Cat 1 status

Built only from `BlackwellDilemma.Infrastructure.TopkisCrossPartial` +
`Mathlib.Algebra.BigOperators.Basic`. No paper-novel axioms, no
`sorry`. Generic over arbitrary `Finset` index types.

## Future Mathlib PR

Suggested namespace: `Mathlib.Order.Supermodular` (yet-to-be-created;
this lemma is the canonical Finset.sum preservation theorem for the
abstract supermodularity framework).

## Tags

supermodular, finset sum, additivity, weighted sum, Topkis, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

open Finset

/-- **Finset.sum preservation of supermodularity**:
    if every `f i` for `i ∈ S` is supermodular, then so is
    `(fun β κ => ∑ i ∈ S, f i β κ)`.

    Generalises `IsSupermodular.add` (the binary case) to arbitrary
    finite index sets. Cat 1: kernel-pure (induction on `S` via
    `Finset.induction_on` + `IsSupermodular.add` + `IsSupermodular.const 0`). -/
theorem IsSupermodular.finset_sum {ι : Type*} (S : Finset ι)
    (f : ι → ℝ → ℝ → ℝ)
    (hf : ∀ i ∈ S, IsSupermodular (f i)) :
    IsSupermodular (fun β κ => ∑ i ∈ S, f i β κ) := by
  intro β₁ β₂ κ₁ κ₂ hβ hκ
  -- Apply Finset.sum monotonicity twice (or rearrange and use sum_add_distrib).
  -- Goal: (∑ i ∈ S, f i β₁ κ₁) + (∑ i ∈ S, f i β₂ κ₂) ≥
  --       (∑ i ∈ S, f i β₁ κ₂) + (∑ i ∈ S, f i β₂ κ₁)
  rw [show (∑ i ∈ S, f i β₁ κ₁) + (∑ i ∈ S, f i β₂ κ₂) =
        ∑ i ∈ S, (f i β₁ κ₁ + f i β₂ κ₂) from (Finset.sum_add_distrib).symm,
      show (∑ i ∈ S, f i β₁ κ₂) + (∑ i ∈ S, f i β₂ κ₁) =
        ∑ i ∈ S, (f i β₁ κ₂ + f i β₂ κ₁) from (Finset.sum_add_distrib).symm]
  apply Finset.sum_le_sum (s := S)
  intro i hi
  exact hf i hi β₁ β₂ κ₁ κ₂ hβ hκ

/-- **Weighted Finset.sum preservation of supermodularity**:
    if every `f i` is supermodular AND every weight `c i ≥ 0`, then
    `(fun β κ => ∑ i ∈ S, c i * f i β κ)` is supermodular. -/
theorem IsSupermodular.finset_sum_smul_nonneg {ι : Type*} (S : Finset ι)
    (c : ι → ℝ) (f : ι → ℝ → ℝ → ℝ)
    (hc : ∀ i ∈ S, 0 ≤ c i)
    (hf : ∀ i ∈ S, IsSupermodular (f i)) :
    IsSupermodular (fun β κ => ∑ i ∈ S, c i * f i β κ) := by
  apply IsSupermodular.finset_sum S (fun i β κ => c i * f i β κ)
  intro i hi
  exact (hf i hi).smul_nonneg (hc i hi)

/-! ### Kernel-purity audit

`#print axioms` on the main theorems surfaces ONLY Mathlib kernel
axioms (`propext, Classical.choice, Quot.sound`) — no paper-novel
carriers, no broken-link `_OPEN` axioms, no `sorry`. These are Cat 1
generic algebraic preservation lemmas, Mathlib-PR-contributable as
the canonical `Finset.sum` extensions of `IsSupermodular.add` for
the (yet-to-be-created) `Order.Supermodular` namespace. -/

#print axioms IsSupermodular.finset_sum
#print axioms IsSupermodular.finset_sum_smul_nonneg

end BlackwellDilemma.Infrastructure
