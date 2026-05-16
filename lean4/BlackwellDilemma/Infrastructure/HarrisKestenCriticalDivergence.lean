/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import BlackwellDilemma.Infrastructure.KappaStarConcrete
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

/-!
# Harris-Kesten + Cardy + Smirnov-Werner critical divergence (Cat 1)

This file provides the **Cat 1 packaging of the standard percolation
universality fact** that drives the divergence of paper's cognitive
threshold `κ*` at the Harris-Kesten critical probability `p_c = 1/2`
on `Z²`.

## Conceptual source

* Harris (1960), *A lower bound for the critical probability in a
  certain percolation process* — established `p_c(Z²) ≥ 1/2`.
* Kesten (1980), *The critical probability of bond percolation on the
  square lattice equals 1/2* — completed the equality `p_c(Z²) = 1/2`.
* Cardy (1992), *Critical percolation in finite geometries* — predicted
  conformal-invariance crossing formulas for percolation at `p_c`.
* Smirnov (2001), *Critical percolation in the plane: conformal
  invariance, Cardy's formula, scaling limits* — proved Cardy's formula
  for site percolation on the triangular lattice.
* Smirnov-Werner (2001), *Critical exponents for two-dimensional
  percolation* — derived critical exponents.

The substantive content of these results is **Cat 2** (beyond Mathlib's
current bond-percolation infrastructure). This file provides only the
**Cat 1 generic lifting** that allows a divergence on a substantive
percolation-scaling carrier to be transferred to a function that
pointwise-dominates it from below, via `DivergesAtBelowAtTop`.

## Main results

* `DivergesAtBelowAtTop.of_pointwise_le` — **generic Cat 1 lifting
  (pointwise-dominance form)**: a function `f` that pointwise-dominates
  a divergent function `g` on the entire left side of `c` inherits
  divergence at `c⁻`.
* `cognitive_kernel_diverges_via_percolation_scaling` — **Cat 1
  packaging of the percolation-scaling-driven divergence transfer**:
  given a Cat 2 percolation-scaling function `s` that diverges at a
  critical point `c`, and a cognitive kernel `f` that pointwise-
  dominates `s` on `(-∞, c)`, the cognitive kernel inherits divergence.

## Relationship to existing `DivergesAtBelowAtTop.mono`

`KappaStarConcrete.lean` already provides a `mono` form requiring only
domination on a left-neighborhood `(c - δ, c)`. The `of_pointwise_le`
form below is the **uniform-domination corollary** (`δ = ∞` case),
which is more convenient when the dominator inequality is established
globally below `c` (e.g. percolation-scaling lower bounds derived from
universality, which hold for all sub-critical `p < p_c`, not merely
near `p_c⁻`).

## Cat 1 status

Built only from `Mathlib.Data.Real.Basic` + `Mathlib.Tactic.Linarith`
+ the existing `KappaStarConcrete.DivergesAtBelowAtTop` predicate.
No paper-novel axioms, no `sorry`. Kernel-pure
(`#print axioms` shows only `[propext, Classical.choice, Quot.sound]`).

## Tags

divergence, atTop, percolation universality, Harris-Kesten, Cardy,
Smirnov-Werner, scaling function, pointwise domination, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### Generic Cat 1 lifting: pointwise-dominance form -/

/-- **Cat 1 lifting (uniform pointwise domination)**: a function
    `f : ℝ → ℝ` that pointwise-dominates a divergent function `g`
    on the entire left half-line `(-∞, c)` inherits divergence at
    `c⁻`. This is the uniform-domination corollary of
    `DivergesAtBelowAtTop.mono` (the latter only requires domination
    on a left-neighborhood `(c - δ, c)`).

    Useful when the dominator inequality holds globally below `c`,
    e.g. percolation-scaling lower bounds from Harris-Kesten +
    Smirnov-Werner universality. -/
theorem DivergesAtBelowAtTop.of_pointwise_le
    (f g : ℝ → ℝ) (c : ℝ)
    (h_le : ∀ x : ℝ, x < c → g x ≤ f x)
    (h_g_diverges : DivergesAtBelowAtTop g c) :
    DivergesAtBelowAtTop f c := by
  intro M
  obtain ⟨ε, hε_pos, hε⟩ := h_g_diverges M
  refine ⟨ε, hε_pos, ?_⟩
  intro p hp_left hp_right
  have h_g_lt : M < g p := hε p hp_left hp_right
  have h_g_le_f : g p ≤ f p := h_le p hp_right
  linarith

/-! ### Cat 1 packaging of the percolation-scaling divergence transfer -/

/-- **Cat 1 packaging of percolation-scaling-driven divergence
    transfer**: given a Cat 2 percolation-scaling function `s` that
    diverges at a critical point `c`, and a cognitive kernel `f` that
    pointwise-dominates `s` on `(-∞, c)`, the cognitive kernel inherits
    divergence at `c⁻`.

    This is the canonical Cat 1 vehicle for transferring Harris-Kesten
    + Cardy + Smirnov-Werner percolation universality from the
    substantive percolation-scaling carrier (Cat 2 axiomatic stipulation
    in the paper-novel layer) to paper's cognitive-threshold carrier
    `κ*`. The Cat 2 percolation universality + the Cat 3 paper-Def-
    stipulated pointwise-domination together compose via this lemma to
    yield the cognitive-threshold divergence at `p_c⁻`.

    Specialised form of `DivergesAtBelowAtTop.of_pointwise_le` with
    domain semantics: argument `s` is interpreted as the percolation-
    scaling function and `f` as the cognitive kernel. -/
theorem cognitive_kernel_diverges_via_percolation_scaling
    {s f : ℝ → ℝ} (c : ℝ)
    (h_s_diverges : DivergesAtBelowAtTop s c)
    (h_f_dominates : ∀ x : ℝ, x < c → s x ≤ f x) :
    DivergesAtBelowAtTop f c :=
  DivergesAtBelowAtTop.of_pointwise_le f s c h_f_dominates h_s_diverges

/-! ### Kernel-purity audit

`#print axioms` on both lemmas surfaces ONLY Mathlib kernel axioms
(`propext, Classical.choice, Quot.sound`) — no paper-novel
`Types.lean` carriers, no broken-link `_OPEN` axioms, no `sorry`.
These provide the Cat 1 generic lifting + Cat 1 packaging of the
percolation-scaling divergence transfer; the substantive Cat 2
Harris-Kesten + Smirnov-Werner universality is encoded as a paper-
novel atomic stipulation in the Cognitive.lean layer (per discipline
§3.4.3 paper-Def axiom). -/

#print axioms DivergesAtBelowAtTop.of_pointwise_le
#print axioms cognitive_kernel_diverges_via_percolation_scaling

end BlackwellDilemma.Infrastructure
