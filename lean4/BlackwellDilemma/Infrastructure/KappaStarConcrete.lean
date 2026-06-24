/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

/-!
# Divergence-from-below characterization (Cat 1)

This file provides the **abstract divergence-from-below predicate**
used by the R208 parameterized Part 6 transfer interface, plus its
basic algebraic operations.

## Main definitions

* `DivergesAtBelowAtTop f c` —
  `∀ M : ℝ, ∃ ε > 0, ∀ p, c - ε < p → p < c → M < f p`.
  The "ε-M" form of "f diverges to +∞ as p → c⁻".

## Main results

* `DivergesAtBelowAtTop.add_const` — adding a constant preserves
  divergence.
* `DivergesAtBelowAtTop.add` — sum of two diverging functions
  diverges (joint ε via `min`).
* `DivergesAtBelowAtTop.mono` — pointwise dominance preserves
  divergence (if `f ≤ g` near `c⁻` and `f` diverges, so does `g`).
* `hyperbolicBelowScaling_diverges_at` — the explicit carrier
  `p ↦ 1 / (c - p)` diverges from below at `c`.

## Bridge to paper carrier `kappaStar`

The paper's Part 6 claim takes the form
`∀ M, ∃ ε > 0, ∀ p ∈ (p_c - ε, p_c), M < kappaStar p α`, which is exactly
`DivergesAtBelowAtTop (fun p => kappaStar p α) p_c`. With this Cat 1
abstract predicate available, the repaired source interface can state the
remaining mathematics as explicit theorem parameters: a replacement scaling
carrier `s`, a proof that `s` diverges at `p_c`, and a proof that `s` is
bounded above by `kappaStar` in the high-α regime.

## Substantive divergence (Harris-Kesten)

The full divergence `kappaStar p α → +∞ as p → p_c⁻` requires the
Harris-Kesten (1980) + Cardy (1992) + Smirnov-Werner (2001) percolation
universality results, which lie beyond Mathlib's current bond-percolation
infrastructure. This file provides only the abstract predicate +
algebra; substantive bond-percolation infrastructure is deferred to
the pending `GiantComponentMills.lean` module.

## Cat 1 status

Built only from `Mathlib.Data.Real.Basic` plus elementary tactics.
No paper-novel axioms, no `sorry`. The predicate + algebra is
Mathlib-PR-contributable as a natural form of one-sided divergence.

## Tags

divergence, atTop, one-sided limit, percolation threshold, kappaStar,
Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### Abstract divergence-from-below predicate -/

/-- A function `f : ℝ → ℝ` **diverges to `+∞` from below at `c`** iff
    for every threshold `M`, there exists a left-neighborhood radius
    `ε > 0` such that `f p > M` for all `p ∈ (c - ε, c)`.

    This is the ε-M form of `Tendsto f (𝓝[Iio c] c) Filter.atTop`. -/
def DivergesAtBelowAtTop (f : ℝ → ℝ) (c : ℝ) : Prop :=
  ∀ M : ℝ, ∃ ε : ℝ, 0 < ε ∧
    ∀ p : ℝ, c - ε < p → p < c → M < f p

/-! ### Explicit hyperbolic left-scaling carrier -/

/-- The elementary left-side hyperbolic scaling carrier `p -> 1 / (c - p)`.
    It is useful as a kernel-pure replacement-scaling prototype for
    one-sided critical-threshold arguments. -/
noncomputable def hyperbolicBelowScaling (c p : Real) : Real :=
  1 / (c - p)

/-- The explicit hyperbolic carrier diverges to `+infty` from below at
    its pole. This supplies the divergence half of a replacement scaling
    carrier without any project-specific paper axiom. -/
theorem hyperbolicBelowScaling_diverges_at (c : Real) :
    DivergesAtBelowAtTop (hyperbolicBelowScaling c) c := by
  intro M
  by_cases hMneg : M < 0
  case pos =>
    refine Exists.intro (1 : Real) ?_
    constructor
    case left =>
      norm_num
    case right =>
      intro p _hp_left hp_right
      have hden_pos : 0 < c - p := by linarith
      have hdiv_pos : 0 < hyperbolicBelowScaling c p := by
        unfold hyperbolicBelowScaling
        positivity
      linarith
  case neg =>
    have hM_nonneg : 0 <= M := le_of_not_gt hMneg
    let eps : Real := 1 / (M + 1)
    have hdenom_pos : 0 < M + 1 := by linarith
    have heps_pos : 0 < eps := by
      dsimp [eps]
      positivity
    refine Exists.intro eps ?_
    constructor
    case left =>
      exact heps_pos
    case right =>
      intro p hp_left hp_right
      have hden_pos : 0 < c - p := by linarith
      have hden_lt_eps : c - p < eps := by linarith
      have h_inv_lt : 1 / eps < 1 / (c - p) :=
        one_div_lt_one_div_of_lt hden_pos hden_lt_eps
      have hM_lt_one_div_eps : M < 1 / eps := by
        dsimp [eps]
        field_simp [hdenom_pos.ne']
        linarith
      exact lt_trans hM_lt_one_div_eps h_inv_lt

/-! ### Basic algebraic operations -/

/-- **Adding a constant preserves divergence.** -/
theorem DivergesAtBelowAtTop.add_const
    {f : ℝ → ℝ} {c : ℝ} (hf : DivergesAtBelowAtTop f c) (k : ℝ) :
    DivergesAtBelowAtTop (fun p => f p + k) c := by
  intro M
  obtain ⟨ε, hε_pos, hε⟩ := hf (M - k)
  refine ⟨ε, hε_pos, ?_⟩
  intro p hp_left hp_right
  have := hε p hp_left hp_right
  linarith

/-- **Sum of two diverging functions diverges.** -/
theorem DivergesAtBelowAtTop.add
    {f g : ℝ → ℝ} {c : ℝ}
    (hf : DivergesAtBelowAtTop f c) (hg : DivergesAtBelowAtTop g c) :
    DivergesAtBelowAtTop (fun p => f p + g p) c := by
  intro M
  obtain ⟨ε₁, hε₁_pos, hε₁⟩ := hf (M / 2)
  obtain ⟨ε₂, hε₂_pos, hε₂⟩ := hg (M / 2)
  refine ⟨min ε₁ ε₂, lt_min hε₁_pos hε₂_pos, ?_⟩
  intro p hp_left hp_right
  have h_left₁ : c - ε₁ < p := by
    have : c - min ε₁ ε₂ ≤ c - ε₁ ∨ c - min ε₁ ε₂ ≤ c - ε₂ := by
      by_cases h : ε₁ ≤ ε₂
      · left; rw [min_eq_left h]
      · right; rw [min_eq_right (le_of_lt (lt_of_not_ge h))]
    have h_min_left : c - min ε₁ ε₂ = c - ε₁ ∨ c - min ε₁ ε₂ = c - ε₂ := by
      by_cases h : ε₁ ≤ ε₂
      · left; rw [min_eq_left h]
      · right; rw [min_eq_right (le_of_lt (lt_of_not_ge h))]
    rcases h_min_left with h | h
    · linarith [hp_left, h]
    · -- min = ε₂, so c - ε₂ < p, but we need c - ε₁ < p when ε₁ ≥ ε₂
      have h_ε : ε₂ ≤ ε₁ := by
        by_contra hc
        push Not at hc
        rw [min_eq_left (le_of_lt hc)] at h
        linarith
      linarith
  have h_left₂ : c - ε₂ < p := by
    have h_min_left : c - min ε₁ ε₂ = c - ε₁ ∨ c - min ε₁ ε₂ = c - ε₂ := by
      by_cases h : ε₁ ≤ ε₂
      · left; rw [min_eq_left h]
      · right; rw [min_eq_right (le_of_lt (lt_of_not_ge h))]
    rcases h_min_left with h | h
    · -- min = ε₁, so we have ε₁ ≤ ε₂, hence c - ε₂ ≤ c - ε₁ < p
      have h_ε : ε₁ ≤ ε₂ := by
        by_contra hc
        push Not at hc
        rw [min_eq_right (le_of_lt hc)] at h
        linarith
      linarith
    · linarith [hp_left, h]
  have h₁ := hε₁ p h_left₁ hp_right
  have h₂ := hε₂ p h_left₂ hp_right
  linarith

/-- **Pointwise dominance preserves divergence (eventually).**
    If `f` diverges and `g ≥ f` near `c⁻`, then `g` diverges. -/
theorem DivergesAtBelowAtTop.mono
    {f g : ℝ → ℝ} {c : ℝ}
    (hf : DivergesAtBelowAtTop f c)
    (h_dom : ∃ δ > 0, ∀ p, c - δ < p → p < c → f p ≤ g p) :
    DivergesAtBelowAtTop g c := by
  intro M
  obtain ⟨δ, hδ_pos, hδ⟩ := h_dom
  obtain ⟨ε, hε_pos, hε⟩ := hf M
  refine ⟨min δ ε, lt_min hδ_pos hε_pos, ?_⟩
  intro p hp_left hp_right
  have h_left_δ : c - δ < p := by
    have h_min_left : min δ ε ≤ δ := min_le_left δ ε
    linarith
  have h_left_ε : c - ε < p := by
    have h_min_right : min δ ε ≤ ε := min_le_right δ ε
    linarith
  have h_f := hε p h_left_ε hp_right
  have h_g := hδ p h_left_δ hp_right
  linarith

/-! ### Kernel-purity audit

`#print axioms` on `DivergesAtBelowAtTop.add` and
`hyperbolicBelowScaling_diverges_at` surfaces ONLY Mathlib
kernel axioms (`propext, Classical.choice, Quot.sound`) — no
paper-novel `Types.lean` carriers, no broken-link `_OPEN` axioms,
no `sorry`. This provides the abstract divergence-from-below
predicate, algebra, and an explicit hyperbolic replacement-scaling
carrier; the substantive `kappaStar` domination/divergence transfer
(Harris-Kesten 1980) is deferred to the pending `GiantComponentMills.lean`
module once the paper-specific domination input is available. -/

#print axioms hyperbolicBelowScaling_diverges_at
#print axioms DivergesAtBelowAtTop.add

end BlackwellDilemma.Infrastructure
