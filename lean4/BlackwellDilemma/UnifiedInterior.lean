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

/-- Greedy welfare on the open five-state benchmark, normalized as the
    negative of terminal welfare loss. -/
noncomputable def greedyWelfare (beta : Real) : Real :=
  -expectedLoss beta

/-- The unique loss minimizer is followed by a strictly negative greedy-
    welfare derivative at every larger precision. This supplies the actual
    derivative sign used by the manuscript's complementarity proposition,
    rather than inferring monotonicity from uniqueness alone. -/
theorem greedyWelfare_hasDerivAt_negative_after_uniqueMinimum :
    exists betaStar : Real,
      0 < betaStar /\
        forall beta : Real, betaStar < beta ->
          exists dGreedy : Real,
            HasDerivAt greedyWelfare dGreedy beta /\ dGreedy < 0 := by
  rcases uniqueInteriorMinimum with ⟨betaStar, hBetaStar, hMinimum, _hUnique⟩
  have hMinimumL : forall beta : Real, 0 < beta ->
      L betaStar 0 <= L beta 0 := by
    intro beta hBeta
    simpa [expectedLoss_eq_L_zero_p, L_zero_p_eq_L_zero] using
      hMinimum beta hBeta.le
  refine ⟨betaStar, hBetaStar, ?_⟩
  intro beta hAfter
  have hBeta : 0 < beta := lt_trans hBetaStar hAfter
  have hRightStar : L_rightBranch 0 betaStar := by
    exact L_global_minimizer_not_left_branch 0 (by norm_num)
      hBetaStar hMinimumL
  have hPhi : Phi_B betaStar <= Phi_B beta :=
    Phi_B_monotone hBetaStar hAfter.le
  have hRightBeta : L_rightBranch 0 beta := by
    dsimp [L_rightBranch] at hRightStar ⊢
    nlinarith
  have hResidualZero : L_balanceResidual 0 betaStar = 0 := by
    have hBalance :=
      L_global_minimizer_first_order_balance 0 hBetaStar hMinimumL
    simpa [L_firstOrderBalance] using hBalance
  have hResidualPositive : 0 < L_balanceResidual 0 beta :=
    L_balanceResidual_singleCrossingOn_from_core
      0 le_rfl (by norm_num [p_1]) betaStar beta hBetaStar hBeta
      hRightStar hRightBeta hAfter hResidualZero
  have hDominance :
      (1 - P_trap beta) * (9/10 : Real) * (1 - 0) * Phi_BDerivValue beta <
        P_trapDerivValue beta *
          ((9/10 : Real) * (1 - 0) * Phi_B beta - (1/2 : Real)) := by
    unfold L_balanceResidual at hResidualPositive
    linarith
  obtain ⟨dLoss, hLossDerivative, hLossPositive⟩ :=
    L_hasDerivAt_positive_of_right_branch_dominance
      0 hBeta hDominance
  refine ⟨-dLoss, ?_, by linarith⟩
  have hNegated := hLossDerivative.neg
  have hWelfareCarrier : greedyWelfare = (fun b : Real => -L b 0) := by
    funext b
    rw [greedyWelfare, expectedLoss_eq_L_zero_p, L_zero_p_eq_L_zero]
  rw [hWelfareCarrier]
  exact hNegated

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
      expectedLoss beta <= expectedLoss betaStar -> beta = betaStar)) /\
  (exists betaStar : Real,
    0 < betaStar /\
      forall beta : Real, betaStar < beta ->
        exists dGreedy : Real,
          HasDerivAt greedyWelfare dGreedy beta /\ dGreedy < 0)

theorem interiorOptimumClaim_proved : InteriorOptimumClaim := by
  exact ⟨expectedLoss_formula, routeProbability_sum_one, uniqueInteriorMinimum,
    greedyWelfare_hasDerivAt_negative_after_uniqueMinimum⟩

end BlackwellDilemma.FiveStateRouting
