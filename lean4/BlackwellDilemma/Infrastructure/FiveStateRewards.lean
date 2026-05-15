/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.NormNum

/-!
# Five-state canonical IDP — explicit reward values (Cat 1)

This file provides the **concrete reward parameters** of the paper's
five-state canonical IDP instance (paper §5.2 `prop:interior-optimum`),
as `noncomputable def`s with `norm_num`-decidable inequalities.

## Paper instance

* `V = {S, A, B, D, G}` — 5 vertices, with `S` the start vertex.
* Edges: `S–A`, `S–B`, `B–D`, `B–G` (paper Definition `prop:interior-optimum`).
* Rewards: `r(S) = 0`, `r(A) = 0.6` (TRAP), `r(B) = 0.4`, `r(D) = 0.1`,
  `r(G) = 1.0` (GOAL).

This file's `def`s + lemmas are kernel-pure Cat 1 (no axioms beyond
`Mathlib`'s arithmetic).

## Tags

5-state IDP, canonical instance, explicit rewards, Cat 1
-/

namespace BlackwellDilemma.Infrastructure.FiveState

/-! ### Explicit reward parameters -/

/-- Reward of the start vertex `S`. -/
def r_S : ℝ := 0

/-- Reward of the trap vertex `A` (`= 0.6`). Paper §5.2 line 738. -/
noncomputable def r_A : ℝ := (6 : ℝ) / 10

/-- Reward of the bridge intermediate vertex `B` (`= 0.4`). Paper §5.2
    line 738. -/
noncomputable def r_B : ℝ := (4 : ℝ) / 10

/-- Reward of the deadend vertex `D` (`= 0.1`). Paper §5.2 line 739. -/
noncomputable def r_D : ℝ := (1 : ℝ) / 10

/-- Reward of the goal vertex `G` (`= 1.0`). Paper §5.2 line 738. -/
def r_G : ℝ := 1

/-! ### Reward inequalities (decidable arithmetic) -/

/-- The trap-vs-bridge reward gap: `r(A) > r(B)` (`0.6 > 0.4`). -/
theorem r_A_gt_r_B : r_A > r_B := by
  show (6 : ℝ) / 10 > (4 : ℝ) / 10
  norm_num

/-- The goal-vs-trap reward gap: `r(G) > r(A)` (`1.0 > 0.6`). -/
theorem r_G_gt_r_A : (r_G : ℝ) > r_A := by
  show (1 : ℝ) > (6 : ℝ) / 10
  norm_num

/-- The goal-vs-bridge reward gap: `r(G) > r(B)` (`1.0 > 0.4`). -/
theorem r_G_gt_r_B : (r_G : ℝ) > r_B := by
  show (1 : ℝ) > (4 : ℝ) / 10
  norm_num

/-- The goal-vs-deadend reward gap: `r(G) > r(D)` (`1.0 > 0.1`). -/
theorem r_G_gt_r_D : (r_G : ℝ) > r_D := by
  show (1 : ℝ) > (1 : ℝ) / 10
  norm_num

/-- The trap-vs-deadend reward gap: `r(A) > r(D)` (`0.6 > 0.1`). -/
theorem r_A_gt_r_D : r_A > r_D := by
  show (6 : ℝ) / 10 > (1 : ℝ) / 10
  norm_num

/-- The bridge-vs-deadend reward gap: `r(B) > r(D)` (`0.4 > 0.1`). -/
theorem r_B_gt_r_D : r_B > r_D := by
  show (4 : ℝ) / 10 > (1 : ℝ) / 10
  norm_num

/-- All rewards lie in the unit interval `[0, 1]`. -/
theorem rewards_mem_unitInterval :
    0 ≤ r_S ∧ r_S ≤ 1 ∧
    0 ≤ r_A ∧ r_A ≤ 1 ∧
    0 ≤ r_B ∧ r_B ≤ 1 ∧
    0 ≤ r_D ∧ r_D ≤ 1 ∧
    0 ≤ (r_G : ℝ) ∧ (r_G : ℝ) ≤ 1 := by
  unfold r_S r_A r_B r_D r_G
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> norm_num

end BlackwellDilemma.Infrastructure.FiveState
