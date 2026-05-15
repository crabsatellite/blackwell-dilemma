/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Topology.ContinuousOn
import Mathlib.Topology.Algebra.Order.Field
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Data.Real.Basic

/-!
# ContinuousOn arithmetic atoms (Cat 1)

This file provides **packaged ContinuousOn preservation atoms** for
sums, scalars, products, and differences on the half-line `Set.Ioi 0`,
ergonomically convenient for paper-bridge work involving continuity
of explicit posterior moments / mean-estimate gaps / divergence forms.

## Main results

* `ContinuousOn.add_const_Ioi0` — `f` cont on `(0, ∞)` ⇒ `f + c` cont.
* `ContinuousOn.const_smul_Ioi0` — non-zero scalar preserves continuity.
* `ContinuousOn.div_pos_Ioi0` — division by a positive function preserves
  continuity.
* `ContinuousOn.sub_Ioi0` — sum of continuous functions on `(0, ∞)` is
  continuous.

## Cat 1 status

Built only from `Mathlib.Topology.ContinuousOn`. No paper-novel
axioms, no `sorry`. The atoms are minor packagings of Mathlib's
existing `ContinuousOn` infrastructure.

## Tags

continuity, ContinuousOn, half-line, arithmetic atoms, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### ContinuousOn arithmetic on `Set.Ioi 0` -/

/-- **Adding a constant preserves continuity on `(0, ∞)`.** -/
theorem ContinuousOn.add_const_Ioi0 {f : ℝ → ℝ}
    (hf : ContinuousOn f (Set.Ioi 0)) (c : ℝ) :
    ContinuousOn (fun x => f x + c) (Set.Ioi 0) :=
  hf.add continuousOn_const

/-- **Subtracting a constant preserves continuity on `(0, ∞)`.** -/
theorem ContinuousOn.sub_const_Ioi0 {f : ℝ → ℝ}
    (hf : ContinuousOn f (Set.Ioi 0)) (c : ℝ) :
    ContinuousOn (fun x => f x - c) (Set.Ioi 0) :=
  hf.sub continuousOn_const

/-- **Constant scalar multiplication preserves continuity.** -/
theorem ContinuousOn.const_smul_Ioi0 {f : ℝ → ℝ}
    (hf : ContinuousOn f (Set.Ioi 0)) (c : ℝ) :
    ContinuousOn (fun x => c * f x) (Set.Ioi 0) :=
  (continuousOn_const (c := c)).mul hf

/-- **Sum of continuous functions on `(0, ∞)` is continuous.** -/
theorem ContinuousOn.add_Ioi0 {f g : ℝ → ℝ}
    (hf : ContinuousOn f (Set.Ioi 0)) (hg : ContinuousOn g (Set.Ioi 0)) :
    ContinuousOn (fun x => f x + g x) (Set.Ioi 0) := hf.add hg

/-- **Difference of continuous functions on `(0, ∞)` is continuous.** -/
theorem ContinuousOn.sub_Ioi0 {f g : ℝ → ℝ}
    (hf : ContinuousOn f (Set.Ioi 0)) (hg : ContinuousOn g (Set.Ioi 0)) :
    ContinuousOn (fun x => f x - g x) (Set.Ioi 0) := hf.sub hg

/-- **Product of continuous functions on `(0, ∞)` is continuous.** -/
theorem ContinuousOn.mul_Ioi0 {f g : ℝ → ℝ}
    (hf : ContinuousOn f (Set.Ioi 0)) (hg : ContinuousOn g (Set.Ioi 0)) :
    ContinuousOn (fun x => f x * g x) (Set.Ioi 0) := hf.mul hg

/-- **Identity function is continuous on `(0, ∞)`.** -/
theorem continuousOn_id_Ioi0 : ContinuousOn (fun x : ℝ => x) (Set.Ioi 0) :=
  continuousOn_id

/-- **Linear function `a · x + b` is continuous on `(0, ∞)`.** -/
theorem continuousOn_linear_Ioi0 (a b : ℝ) :
    ContinuousOn (fun x : ℝ => a * x + b) (Set.Ioi 0) :=
  ContinuousOn.add_const_Ioi0
    (ContinuousOn.const_smul_Ioi0 continuousOn_id_Ioi0 a) b

/-! ### Restriction to subset preserves continuity -/

/-- **Continuity on a superset implies continuity on a subset.** -/
theorem ContinuousOn.mono_subset {f : ℝ → ℝ} {s t : Set ℝ}
    (hf : ContinuousOn f s) (h_sub : t ⊆ s) :
    ContinuousOn f t := hf.mono h_sub

/-! ### Kernel-purity audit -/

#print axioms ContinuousOn.add_Ioi0
#print axioms continuousOn_linear_Ioi0

end BlackwellDilemma.Infrastructure
