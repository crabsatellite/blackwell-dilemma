/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import BlackwellDilemma.Infrastructure.FiveStateVDyn

/-!
# Concrete `mLimitDifference` for the five-state canonical IDP (Cat 1)

This file provides the **concrete realisation** of paper Theorem 4.1
Part 3 line 505's `mLimit p = V_dyn(u_2) − V_dyn(u_1)` quantity for
the five-state canonical IDP, with `u_1 = A` (trap) and `u_2 = B`
(bridge intermediate). The result `0.4 > 0` is fully Cat 1 via
`norm_num`.

This is the Cat 1 instance witness for the abstract paper-stipulated
positivity claim `mLimitDifference_pos_paper_witness`;
the abstract claim is `Conditions_C1_C2_C3 → ∀ p, 0 < mLimitDifference p`
on an opaque carrier, while this file pins the carrier value at the
canonical IDP and proves positivity via `norm_num` over `ℚ`.

## Tags

5-state IDP, V_dyn-difference, mLimitDifference, paper Theorem 4.1 Part 3,
Cat 1
-/

namespace BlackwellDilemma.Infrastructure.FiveState

open BlackwellDilemma.Infrastructure.FiveState

/-! ### Concrete `mLimitDifference` value -/

/-- The trap-bridge V_dyn-difference at the five-state canonical IDP:
    `V_dyn(B) − V_dyn(A) = 1 − 0.6 = 0.4`. -/
noncomputable def mLimitDifference_fiveState : ℝ := V_dyn_B - V_dyn_A

/-- The trap-bridge V_dyn-difference equals `0.4` (kernel-pure). -/
theorem mLimitDifference_fiveState_eq :
    mLimitDifference_fiveState = (4 : ℝ) / 10 := by
  unfold mLimitDifference_fiveState
  rw [V_dyn_B_eq, V_dyn_A_eq]
  norm_num

/-- **CAT 1 positivity** of the trap-bridge V_dyn-difference for the
    five-state canonical IDP. This is the concrete Lean-checkable
    version of paper Theorem 4.1 Part 3 line 505's strict-positivity
    claim `V_dyn(u_2) − V_dyn(u_1) > 0` (no axioms beyond Mathlib
    arithmetic). -/
theorem mLimitDifference_fiveState_pos : 0 < mLimitDifference_fiveState := by
  rw [mLimitDifference_fiveState_eq]
  norm_num

/-! ### Kernel-purity audit

`#print axioms` on `mLimitDifference_fiveState_pos` surfaces ONLY
Mathlib kernel axioms (`propext, Classical.choice, Quot.sound`) — no
paper-novel `Types.lean` carriers, no broken-link `_OPEN` axioms, no
`sorry`. This is the prototype of the full Cat 1 cover programme: a
concrete Lean-checkable witness of paper Theorem 4.1 Part 3 line 505
strict-positivity claim, derived from explicit five-state canonical
IDP rewards via `norm_num` over `ℚ`. -/

#print axioms mLimitDifference_fiveState_pos

end BlackwellDilemma.Infrastructure.FiveState
