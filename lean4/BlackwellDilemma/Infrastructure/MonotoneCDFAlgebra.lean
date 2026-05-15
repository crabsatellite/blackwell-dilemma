/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import BlackwellDilemma.Infrastructure.MonotoneFunctionAlgebra
import BlackwellDilemma.Infrastructure.UnitIntervalAlgebra

/-!
# CDF (cumulative distribution function) algebra (Cat 1)

This file provides the **CDF predicate** + algebra: a function
`G : ℝ → ℝ` is a CDF iff it is monotone non-decreasing, with values in
`[0, 1]`, and the limits 0 at `-∞` and 1 at `+∞`. This file handles the
algebraic / order-theoretic side; the limit conditions are stated
abstractly without measure-theoretic foundations.

## Main definitions

* `IsCDF G` — `G : ℝ → ℝ` is monotone non-decreasing AND values in `[0, 1]`.

## Main results

* `IsCDF.mono` — CDFs are monotone (extracted from definition).
* `IsCDF.values_in_unitInterval` — CDF values are in `[0, 1]`.
* `IsCDF.const_one`, `IsCDF.const_zero` — constant CDFs (degenerate).

## FOSD definition

* `FOSD G₁ G₂` — `G₂` first-order stochastically dominates `G₁` iff
  `∀ x, G₂(x) ≤ G₁(x)` (G₂'s CDF lies below G₁'s, i.e. G₂ puts more
  mass on higher values).

## Bridge to paper carrier `kappa_FOSD`

Paper's `kappa_FOSD G₁ G₂ : Prop` is the standard FOSD predicate
`∀ x, G₁(x) ≥ G₂(x)`, which is exactly `FOSD G₁ G₂` below. The paper's
opaque `kappa_FOSD` carrier identifies with this concrete definition
once the κ-CDF carrier is concretised.

## Cat 1 status

Built from `MonotoneFunctionAlgebra` and `UnitIntervalAlgebra` (both
Cat 1). No paper-novel axioms, no `sorry`. Mathlib-PR-contributable
as a CDF algebra.

## Tags

CDF, cumulative distribution, FOSD, stochastic dominance, monotone,
unit interval, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### CDF predicate -/

/-- **CDF predicate**. A function `G : ℝ → ℝ` is a CDF iff it is
    monotone non-decreasing with values in `[0, 1]`. (The limit
    conditions `G(-∞) = 0`, `G(+∞) = 1` are deferred to a
    `MeasureTheory`-laden Phase 13b extension.) -/
def IsCDF (G : ℝ → ℝ) : Prop :=
  Monotone G ∧ ∀ x, InUnitInterval (G x)

/-- **CDFs are monotone.** -/
theorem IsCDF.mono {G : ℝ → ℝ} (hG : IsCDF G) : Monotone G := hG.1

/-- **CDF values are in `[0, 1]`.** -/
theorem IsCDF.values_in_unitInterval {G : ℝ → ℝ} (hG : IsCDF G) (x : ℝ) :
    InUnitInterval (G x) := hG.2 x

/-! ### FOSD predicate -/

/-- **FOSD predicate**. `G₂` first-order stochastically dominates `G₁`
    iff `∀ x, G₂(x) ≤ G₁(x)` (i.e., `G₂`'s CDF lies pointwise below
    `G₁`'s CDF, equivalently `G₂` puts more probability mass on
    higher values). -/
def FOSD (G₁ G₂ : ℝ → ℝ) : Prop := ∀ x, G₂ x ≤ G₁ x

/-! ### FOSD properties -/

/-- **Reflexivity** of FOSD. -/
theorem FOSD.refl (G : ℝ → ℝ) : FOSD G G := fun _ => le_refl _

/-- **Transitivity** of FOSD. -/
theorem FOSD.trans {G₁ G₂ G₃ : ℝ → ℝ}
    (h₁₂ : FOSD G₁ G₂) (h₂₃ : FOSD G₂ G₃) :
    FOSD G₁ G₃ := fun x => le_trans (h₂₃ x) (h₁₂ x)

/-- **Antisymmetry** of FOSD: if `G₁` and `G₂` mutually dominate, they
    are equal. -/
theorem FOSD.antisymm {G₁ G₂ : ℝ → ℝ}
    (h₁₂ : FOSD G₁ G₂) (h₂₁ : FOSD G₂ G₁) :
    G₁ = G₂ := by
  funext x
  exact le_antisymm (h₂₁ x) (h₁₂ x)

/-! ### Constant CDFs -/

/-- **Constant CDF** `G(x) = c` for `c ∈ [0, 1]`. -/
theorem isCDF_const {c : ℝ} (hc : InUnitInterval c) :
    IsCDF (fun _ : ℝ => c) :=
  ⟨monotone_const c, fun _ => hc⟩

/-- **All-mass-at-zero degenerate CDF** is the constant `1` function. -/
theorem isCDF_const_one : IsCDF (fun _ : ℝ => (1 : ℝ)) :=
  isCDF_const InUnitInterval.one

/-- **Empty distribution** (no probability) — the constant `0` function. -/
theorem isCDF_const_zero : IsCDF (fun _ : ℝ => (0 : ℝ)) :=
  isCDF_const InUnitInterval.zero

/-! ### Kernel-purity audit -/

#print axioms IsCDF.mono
#print axioms FOSD.trans
#print axioms isCDF_const

end BlackwellDilemma.Infrastructure
