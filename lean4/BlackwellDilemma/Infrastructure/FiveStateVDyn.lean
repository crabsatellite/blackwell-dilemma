/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.NormNum
import BlackwellDilemma.Infrastructure.FiveStateRewards

/-!
# Five-state canonical IDP — explicit `V_dyn` per vertex (Cat 1)

This file provides the **concrete dynamic-value computation** on the
paper's five-state canonical IDP instance, with `V_dyn(v)` computed as
the maximum reward over the forward-reachable set from each vertex.

## Five-state forward-reachable structure (Cat 1, paper §5.2)

* `S` (start, `r=0`): can reach `A` (terminal trap), or `B → {D, G}`
  (terminal deadend or terminal goal).
* `A` (trap, `r=0.6`): terminal — only `A` itself reachable.
* `B` (bridge intermediate, `r=0.4`): can reach `D` (terminal deadend)
  or `G` (terminal goal).
* `D` (deadend, `r=0.1`): terminal.
* `G` (goal, `r=1.0`): terminal.

Therefore (under all-edges-open):
* `V_dyn(D) = r_D = 0.1`
* `V_dyn(G) = r_G = 1.0`
* `V_dyn(A) = r_A = 0.6` (terminal)
* `V_dyn(B) = max(r_B, V_dyn(D), V_dyn(G)) = max(0.4, 0.1, 1.0) = 1.0`
* `V_dyn(S) = max(r_S, V_dyn(A), V_dyn(B)) = max(0, 0.6, 1.0) = 1.0`

The trap-bridge V_dyn-difference (paper line 505 `V_dyn(u_2) − V_dyn(u_1)`
with `u_1 = A`, `u_2 = B`) is therefore:

`V_dyn(B) − V_dyn(A) = 1.0 − 0.6 = 0.4 > 0`

This is the concrete witness for the paper's Theorem 4.1 Part 3 strict
positivity claim under C2 (`V_dyn(u_2) > V_dyn(u_1)`).

## Tags

5-state IDP, dynamic value, V_dyn, trap-bridge gap, Cat 1
-/

namespace BlackwellDilemma.Infrastructure.FiveState

open BlackwellDilemma.Infrastructure.FiveState

/-! ### Explicit `V_dyn` per vertex (under all-edges-open) -/

/-- Dynamic value of the deadend `D` (terminal): `V_dyn(D) = r(D) = 0.1`. -/
noncomputable def V_dyn_D : ℝ := r_D

/-- Dynamic value of the goal `G` (terminal): `V_dyn(G) = r(G) = 1.0`. -/
def V_dyn_G : ℝ := r_G

/-- Dynamic value of the trap `A` (terminal): `V_dyn(A) = r(A) = 0.6`. -/
noncomputable def V_dyn_A : ℝ := r_A

/-- Dynamic value of the bridge intermediate `B`: `V_dyn(B) = max(r(B),
    V_dyn(D), V_dyn(G)) = max(0.4, 0.1, 1.0) = 1.0`. -/
noncomputable def V_dyn_B : ℝ := max r_B (max V_dyn_D V_dyn_G)

/-- Dynamic value of the start vertex `S`: `V_dyn(S) = max(r(S),
    V_dyn(A), V_dyn(B)) = max(0, 0.6, 1.0) = 1.0`. -/
noncomputable def V_dyn_S : ℝ := max r_S (max V_dyn_A V_dyn_B)

/-! ### Computed values via `norm_num` -/

/-- `V_dyn(D) = 0.1`. -/
theorem V_dyn_D_eq : V_dyn_D = (1 : ℝ) / 10 := rfl

/-- `V_dyn(G) = 1`. -/
theorem V_dyn_G_eq : V_dyn_G = 1 := rfl

/-- `V_dyn(A) = 0.6`. -/
theorem V_dyn_A_eq : V_dyn_A = (6 : ℝ) / 10 := rfl

/-- `V_dyn(B) = 1` (the goal `G` dominates the deadend `D` and the bridge
    intermediate reward `r_B`). -/
theorem V_dyn_B_eq : V_dyn_B = 1 := by
  unfold V_dyn_B V_dyn_D V_dyn_G r_B r_D r_G
  have h₁ : max ((1 : ℝ) / 10) 1 = 1 := by
    rw [max_eq_right]; norm_num
  rw [h₁]
  rw [max_eq_right]; norm_num

/-- `V_dyn(S) = 1` (the goal-via-bridge path dominates the trap and the
    start reward). -/
theorem V_dyn_S_eq : V_dyn_S = 1 := by
  unfold V_dyn_S r_S V_dyn_A r_A
  rw [V_dyn_B_eq]
  -- max 0 (max (6/10) 1) = 1
  have h₁ : max ((6 : ℝ) / 10) 1 = 1 := by
    rw [max_eq_right]; norm_num
  rw [h₁]
  rw [max_eq_right]; norm_num

end BlackwellDilemma.Infrastructure.FiveState
