/-
  BlackwellDilemma/UnifiedInterior.lean

  Explicit sequential route distribution for the open five-state IDP.
  This connects the Gaussian routing probabilities to the paper's loss
  formula and packages the kernel-proved unique interior minimum.
-/

import BlackwellDilemma.Canonical

namespace BlackwellDilemma.FiveStateRouting

inductive Outcome where
  | trap
  | goal
  | distractor
  deriving DecidableEq, Fintype

open FiveState

noncomputable def routeProbability (beta : Real) : Outcome -> Real
  | .trap => P_trap beta
  | .goal => (1 - P_trap beta) * Phi_B beta
  | .distractor => (1 - P_trap beta) * (1 - Phi_B beta)

noncomputable def terminalLoss : Outcome -> Real
  | .trap => (4 : Real) / 10
  | .goal => 0
  | .distractor => (9 : Real) / 10

noncomputable def expectedLoss (beta : Real) : Real :=
  ∑ outcome : Outcome, routeProbability beta outcome * terminalLoss outcome

theorem outcome_univ : (Finset.univ : Finset Outcome) =
    { .trap, .goal, .distractor } := by
  decide

theorem trapProbability_mem_unitInterval (beta : Real) :
    P_trap beta ∈ Set.Icc (0 : Real) 1 := by
  exact ⟨Phi_nonneg _, Phi_le_one _⟩

theorem goalProbability_mem_unitInterval (beta : Real) :
    Phi_B beta ∈ Set.Icc (0 : Real) 1 := by
  exact ⟨Phi_nonneg _, Phi_le_one _⟩

theorem routeProbability_nonneg (beta : Real) (outcome : Outcome) :
    0 <= routeProbability beta outcome := by
  rcases trapProbability_mem_unitInterval beta with ⟨hTrapNonneg, hTrapLe⟩
  rcases goalProbability_mem_unitInterval beta with ⟨hGoalNonneg, hGoalLe⟩
  cases outcome <;>
    simp [routeProbability, hTrapNonneg, hTrapLe, hGoalNonneg, hGoalLe,
      mul_nonneg]

theorem routeProbability_sum_one (beta : Real) :
    ∑ outcome : Outcome, routeProbability beta outcome = 1 := by
  rw [outcome_univ]
  simp [routeProbability]
  ring

theorem expectedLoss_formula (beta : Real) :
    expectedLoss beta =
      P_trap beta * (4 / 10 : Real) +
        (1 - P_trap beta) * (1 - Phi_B beta) * (9 / 10 : Real) := by
  unfold expectedLoss
  rw [outcome_univ]
  simp [routeProbability, terminalLoss]

theorem expectedLoss_eq_L_zero_p (beta : Real) :
    expectedLoss beta = L_zero_p beta := by
  rw [expectedLoss_formula]
  rfl

theorem L_zero_p_eq_L_zero (beta : Real) : L_zero_p beta = L beta 0 := by
  change
    P_trap beta * (4 / 10 : Real) +
      (1 - P_trap beta) * (1 - Phi_B beta) * (9 / 10 : Real) =
    P_trap beta * (4 / 10 : Real) +
      (1 - P_trap beta) * (9 / 10 : Real) *
        (1 - (1 - 0) * Phi_B beta)
  ring

theorem uniqueInteriorMinimum :
    exists betaStar : Real,
      0 < betaStar /\
      (forall beta : Real, 0 <= beta ->
        expectedLoss betaStar <= expectedLoss beta) /\
      (forall beta : Real, 0 < beta ->
        expectedLoss beta <= expectedLoss betaStar -> beta = betaStar) := by
  rcases interior_minimiser_existence with ⟨betaMin, hBetaMin, hMin⟩
  rcases L_unimodal_in_regime_i_paper_Def 0 le_rfl
      (by norm_num [p_1]) with ⟨betaUnique, hBetaUnique, hUnique⟩
  have hMinLeUnique : L betaMin 0 <= L betaUnique 0 :=
    hMin betaUnique hBetaUnique.le
  have hEqual : betaMin = betaUnique :=
    hUnique betaMin hBetaMin hMinLeUnique
  refine ⟨betaMin, hBetaMin, ?_, ?_⟩
  · intro beta hBeta
    simpa [expectedLoss_eq_L_zero_p, L_zero_p_eq_L_zero] using hMin beta hBeta
  · intro beta hBeta hLoss
    have hL : L beta 0 <= L betaMin 0 := by
      simpa [expectedLoss_eq_L_zero_p, L_zero_p_eq_L_zero] using hLoss
    have : beta = betaUnique := hUnique beta hBeta (hEqual ▸ hL)
    exact this.trans hEqual.symm

/-- Exact machine target for the repaired manuscript Proposition
    `prop:interior-optimum`. Numerical localization is gated separately. -/
def InteriorOptimumClaim : Prop :=
  (forall beta : Real,
    expectedLoss beta =
      P_trap beta * (4 / 10 : Real) +
        (1 - P_trap beta) * (1 - Phi_B beta) * (9 / 10 : Real)) /\
  (forall beta : Real,
    ∑ outcome : Outcome, routeProbability beta outcome = 1) /\
  (exists betaStar : Real,
    0 < betaStar /\
    (forall beta : Real, 0 <= beta ->
      expectedLoss betaStar <= expectedLoss beta) /\
    (forall beta : Real, 0 < beta ->
      expectedLoss beta <= expectedLoss betaStar -> beta = betaStar))

theorem interiorOptimumClaim_proved : InteriorOptimumClaim := by
  exact ⟨expectedLoss_formula, routeProbability_sum_one, uniqueInteriorMinimum⟩

end BlackwellDilemma.FiveStateRouting
