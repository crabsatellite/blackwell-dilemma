/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Order.Monotone.Basic
import Mathlib.Tactic.Linarith

/-!
# Monotone function algebra (Cat 1)

This file provides **algebraic operations on monotone functions
`ℝ → ℝ`** (sum, non-negative scalar, composition). These are
foundational atoms for paper-bridge axioms that derive monotonicity
from compositional structure.

## Main results

* `Monotone.add` — sum of monotone is monotone (Mathlib-known).
* `Monotone.smul_nonneg_const` — non-negative scalar preserves
  monotonicity.
* `Monotone.comp_monotone_in_first` — composition with single-variable
  monotone function preserves the monotone property.
* `Monotone.sub_antitone_left` — monotone minus antitone is monotone.

## Cat 1 status

Built only from `Mathlib.Order.Monotone.Basic`. No paper-novel
axioms, no `sorry`. The atoms below are minor packagings of Mathlib's
existing `Monotone` infrastructure for Mathlib-PR-style ergonomics.

## Tags

monotone, function algebra, composition, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### Monotone real-valued function algebra -/

/-- **Sum of two monotone real-valued functions is monotone.**
    Mathlib's `Monotone.add` packaged for `ℝ → ℝ`. -/
theorem monotone_add {f g : ℝ → ℝ}
    (hf : Monotone f) (hg : Monotone g) :
    Monotone (fun x => f x + g x) := hf.add hg

/-- **Non-negative scalar multiplication preserves monotonicity.** -/
theorem monotone_smul_nonneg_const {f : ℝ → ℝ} {c : ℝ}
    (hf : Monotone f) (hc : 0 ≤ c) :
    Monotone (fun x => c * f x) := by
  intro x₁ x₂ hx
  have h := hf hx
  exact mul_le_mul_of_nonneg_left h hc

/-- **Composition with a single-variable monotone function preserves
    monotonicity.** If `g : ℝ → ℝ` is monotone and `f : ℝ → ℝ` is
    monotone, then `g ∘ f` is monotone. -/
theorem monotone_comp {f g : ℝ → ℝ}
    (hg : Monotone g) (hf : Monotone f) :
    Monotone (g ∘ f) := hg.comp hf

/-- **Monotone minus antitone is monotone.**
    If `f` is monotone and `g` is antitone, then `f - g` is monotone. -/
theorem monotone_sub_antitone {f g : ℝ → ℝ}
    (hf : Monotone f) (hg : Antitone g) :
    Monotone (fun x => f x - g x) := by
  intro x₁ x₂ hx
  have h_f := hf hx
  have h_g := hg hx
  linarith

/-- **Constant function is monotone (trivially).** -/
theorem monotone_const (c : ℝ) : Monotone (fun _ : ℝ => c) :=
  fun _ _ _ => le_refl _

/-! ### Strict monotonicity preservation -/

/-- **Strictly-monotone + monotone = strictly-monotone (sum form).**
    If `f` is strictly monotone and `g` is monotone, then `f + g`
    is strictly monotone. -/
theorem strictMono_add_mono {f g : ℝ → ℝ}
    (hf : StrictMono f) (hg : Monotone g) :
    StrictMono (fun x => f x + g x) := by
  intro x₁ x₂ hx
  have h_f := hf hx
  have h_g := hg (le_of_lt hx)
  linarith

/-! ### Monotone-on-set variants -/

/-- **Monotone-on-set sum.** -/
theorem monotoneOn_add {f g : ℝ → ℝ} {s : Set ℝ}
    (hf : MonotoneOn f s) (hg : MonotoneOn g s) :
    MonotoneOn (fun x => f x + g x) s := by
  intro x₁ hx₁ x₂ hx₂ hx
  have h_f := hf hx₁ hx₂ hx
  have h_g := hg hx₁ hx₂ hx
  linarith

/-- **Monotone restricts to monotone on subset.** -/
theorem MonotoneOn.mono_subset {f : ℝ → ℝ} {s t : Set ℝ}
    (hf : MonotoneOn f s) (h_sub : t ⊆ s) :
    MonotoneOn f t :=
  fun _ hx₁ _ hx₂ hx => hf (h_sub hx₁) (h_sub hx₂) hx

/-! ### Kernel-purity audit -/

#print axioms monotone_add
#print axioms monotone_sub_antitone

end BlackwellDilemma.Infrastructure
