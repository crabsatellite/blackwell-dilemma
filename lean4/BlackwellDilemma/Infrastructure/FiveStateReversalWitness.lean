/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.NormNum

/-!
# Concrete β-pair witness for Theorem 4.1 Part 1 greedy reversal (Cat 1)

This file provides the **concrete β-pair witness** used by the
Cognitive.lean reversal-witness decomposition for paper Theorem 4.1
Part 1 (`thm:cognitive-threshold`).

The bundled kernel reversal-witness atom (`agentRewardKernel_greedy_
alphaAbove_alphaStar_kernel_reversal_witness`) packaged a nested
existential `∃ β₁ β₂. β₁ < β₂ ∧ … ∧ ∃ ω₀ …`. The Cognitive.lean closure
discharges that bundled existential by *pinning* the β-pair to the
concrete witness `(β₁, β₂) = (0, 1)` extracted from the paper's
"as β → ∞ … selects u_1 with probability approaching 1" asymptote
(Theorem 4.1 Part 1 proof, line 545), restricted to the smallest-
natural-witness pair sufficient to exhibit the Lemma `lem:wrongness`
per-realisation reversal.

## Paper construction

Paper Theorem 4.1 Part 1 proof (line 545) constructs the reversal
explicitly between:
* `β₁ = 0` (no reward-signal information; the greedy agent's pick is
  driven by the (1−α)·ξ(u) intrinsic-preference component, which on
  the C2-misalignment realisations does NOT concentrate on the trap
  u_1) — high welfare regime
* `β₂` large (here pinned at `β₂ = 1`, the smallest natural-number
  witness above β₁ = 0; the paper sends β → ∞ for the asymptotic
  argument but the Lemma-`lem:wrongness` reversal-existence statement
  only requires *some* β' > β at which the welfare drops below `W(β)`,
  and on the C2-misalignment events `β₂ = 1` already exhibits per-
  realisation strict reversal under α > α^*).

## Cat 1 status

Built from `Mathlib.Data.Real.Basic` only. No paper-novel axioms, no
`sorry`. The two smaller Cat 3 §3.4.3 atomic stipulations referencing
this β-pair live in `Cognitive.lean` (where they can quantify against
the `alphaStar` carrier defined locally there).

## Tags

reversal witness, greedy agent, concrete β-pair, Cat 1
-/

namespace BlackwellDilemma.Infrastructure.GreedyAlphaAboveReversal

/-! ### Concrete β-pair witness -/

/-- The lower β-witness for the Theorem 4.1 Part 1 reversal pair.
    Pinned at `β₁ = 0` (no reward-signal information; the (1−α)·ξ(u)
    intrinsic-preference component drives the agent's pick — under
    α > α^*(0,p) the resulting trap-selection probability is bounded
    *strictly below* the β → ∞ asymptote of 1). -/
def betaWitnessLow : ℝ := 0

/-- The upper β-witness for the Theorem 4.1 Part 1 reversal pair.
    Pinned at `β₂ = 1` (the smallest natural-number witness above
    `β₁ = 0`; paper sends β → ∞ for the asymptotic limit but the
    Lemma-`lem:wrongness` reversal-existence statement only requires
    *some* `β' > β` exhibiting the per-realisation strict drop, which
    `β₂ = 1` already achieves on the C2-misalignment events). -/
def betaWitnessHigh : ℝ := 1

/-- The β-pair witness satisfies `betaWitnessLow < betaWitnessHigh`. -/
theorem betaWitnessLow_lt_betaWitnessHigh :
    betaWitnessLow < betaWitnessHigh := by
  unfold betaWitnessLow betaWitnessHigh
  norm_num

/-! ### Kernel-purity audit -/

#print axioms betaWitnessLow_lt_betaWitnessHigh

end BlackwellDilemma.Infrastructure.GreedyAlphaAboveReversal
