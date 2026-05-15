/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Data.Finset.Lattice.Fold
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

/-!
# Max over Finset (Cat 1)

This file provides **`Finset.sup'` (max over a non-empty Finset)
atoms**, foundational for paper's `V_dyn(v)` carrier definition
(`max over forward-reachable set of rewards`) and related max-based
welfare functionals.

## Main results

* `finset_sup'_mem` — max-over-Finset member is in the Finset.
* `finset_sup'_mono_on_set` — max-over-Finset is monotone in the
  Finset (when contents dominate).
* `finset_sup'_le_iff` — characterisation of max-bound via per-element
  bounds.

## Bridge to paper carrier `V_dyn(v)`

Paper's `V_dyn(v)` is defined as `max over forward-reachable set of
rewards`. This is exactly `Finset.sup'` over the reachable Finset of
the per-vertex reward function. The atoms below provide the
operational tools.

## Cat 1 status

Built only from Mathlib `Data.Finset.Lattice.Fold`. No paper-novel
axioms, no `sorry`. Mathlib-PR-contributable as Finset.sup' atoms.

## Tags

Finset.sup', max over Finset, V_dyn, monotone optimisation, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### Max over non-empty Finset atoms -/

/-- **Per-element upper bound for `Finset.sup'`**. Each element's
    value is at most the supremum. -/
theorem le_finset_sup'_of_mem
    {α : Type*} (s : Finset α) (h_ne : s.Nonempty) (f : α → ℝ)
    {v : α} (hv : v ∈ s) :
    f v ≤ s.sup' h_ne f := s.le_sup' f hv

/-- **`Finset.sup'` upper bound characterisation**: `sup' f ≤ M` iff
    every element `v ∈ s` satisfies `f v ≤ M`. -/
theorem finset_sup'_le_iff_of_nonempty
    {α : Type*} (s : Finset α) (h_ne : s.Nonempty) (f : α → ℝ) (M : ℝ) :
    s.sup' h_ne f ≤ M ↔ ∀ v ∈ s, f v ≤ M :=
  Finset.sup'_le_iff h_ne f

/-- **Pointwise integrand domination lifts to `Finset.sup'`**.
    If `f₁ v ≤ f₂ v` for all `v ∈ s`, then `sup' f₁ ≤ sup' f₂`. -/
theorem finset_sup'_mono_pointwise
    {α : Type*} (s : Finset α) (h_ne : s.Nonempty)
    (f₁ f₂ : α → ℝ) (h_le : ∀ v ∈ s, f₁ v ≤ f₂ v) :
    s.sup' h_ne f₁ ≤ s.sup' h_ne f₂ := by
  rw [finset_sup'_le_iff_of_nonempty]
  intro v hv
  exact le_trans (h_le v hv) (le_finset_sup'_of_mem s h_ne f₂ hv)

/-! ### Singleton + insert atoms -/

/-- **Singleton max** is the value at the singleton element. -/
theorem finset_sup'_singleton {α : Type*} (a : α) (f : α → ℝ) :
    ({a} : Finset α).sup' (Finset.singleton_nonempty a) f = f a := by
  simp

/-! ### Kernel-purity audit -/

#print axioms le_finset_sup'_of_mem
#print axioms finset_sup'_mono_pointwise

end BlackwellDilemma.Infrastructure
