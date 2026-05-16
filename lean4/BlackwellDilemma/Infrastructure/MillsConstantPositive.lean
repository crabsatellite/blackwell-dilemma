/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

/-!
# Mills-tail constant positivity (Cat 1)

This module provides Cat 1 lemmas about strict positivity of Mills-tail
constants derived from exponential cluster-tail decay parameters.

**Key result**: if `c > 0` is the exponential decay rate, then the
"Mills-tail constant" `1/(1 - exp(-c))` is strictly positive and finite.
This is the foundational positivity statement for paper claims like
"the Mills-style positive constant `c₁(p)` exists" (paper Proposition
`prop:topo-cluster` Part 2 line 287).

## Main results

* `mills_const_pos_of_exp_decay_rate_pos` — `1/(1 - exp(-c))` is
  strictly positive and `> 1` for `c > 0`.
* `mills_const_finite_of_exp_decay_rate_pos` — denominator
  `1 - exp(-c)` is strictly positive (so the constant is finite).

## Cat 1 status

Built only from Mathlib (`Real.exp` lemmas). Kernel-pure
(`#print axioms` shows only `[propext, Classical.choice, Quot.sound]`).
Generic on `ℝ`.

## Future Mathlib PR

Suggested namespace: `Mathlib.Analysis.SpecialFunctions.Mills` or
`Mathlib.Analysis.GeometricSeries.Mills`. Useful for any analysis
involving Mills-tail bounds (Mills 1926).

## Tags

Mills-tail, geometric series, exponential decay, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

open Real

/-- **Denominator positivity for Mills-tail constant**:
    `1 - exp(-c) > 0` for `c > 0`. -/
theorem mills_const_denom_pos (c : ℝ) (hc : 0 < c) :
    0 < 1 - Real.exp (-c) := by
  have h_exp_lt_one : Real.exp (-c) < 1 := by
    rw [show (1 : ℝ) = Real.exp 0 from Real.exp_zero.symm]
    exact Real.exp_strictMono (by linarith)
  linarith

/-- **Mills-tail constant positivity**: `1/(1 - exp(-c)) > 0` for `c > 0`. -/
theorem mills_const_pos_of_exp_decay_rate_pos (c : ℝ) (hc : 0 < c) :
    0 < 1 / (1 - Real.exp (-c)) := by
  have h_denom := mills_const_denom_pos c hc
  positivity

/-- **Mills-tail constant exceeds 1**: `1/(1 - exp(-c)) > 1` for `c > 0`,
    since the denominator `1 - exp(-c)` is in `(0, 1)`. -/
theorem mills_const_gt_one_of_exp_decay_rate_pos (c : ℝ) (hc : 0 < c) :
    1 < 1 / (1 - Real.exp (-c)) := by
  have h_denom_pos := mills_const_denom_pos c hc
  have h_denom_lt_one : 1 - Real.exp (-c) < 1 := by
    have h_exp_pos : 0 < Real.exp (-c) := Real.exp_pos _
    linarith
  -- 1 < 1/(1-exp(-c)) iff (1-exp(-c)) < 1 (both sides multiplied by 1-exp(-c) > 0)
  rw [lt_div_iff₀ h_denom_pos]
  linarith

/-! ### Kernel-purity audit

`#print axioms` on the main theorems surfaces ONLY Mathlib kernel
axioms (`propext, Classical.choice, Quot.sound`) — no paper-novel
carriers, no broken-link `_OPEN` axioms, no `sorry`. These provide
foundational positivity / non-vanishing results for Mills-tail
constants derived from exponential decay rates. -/

#print axioms mills_const_denom_pos
#print axioms mills_const_pos_of_exp_decay_rate_pos
#print axioms mills_const_gt_one_of_exp_decay_rate_pos

end BlackwellDilemma.Infrastructure
