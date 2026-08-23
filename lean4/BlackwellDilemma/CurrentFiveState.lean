/- Exact current-paper five-state routing model and interior-minimum proof. -/

import BlackwellDilemma.CurrentGaussian
import Mathlib.Topology.Order.Compact

namespace BlackwellDilemma.CurrentFiveState

open Filter Set Topology
open BlackwellDilemma.CurrentGaussian

inductive Outcome where
  | trap
  | goal
  | distractor
  deriving DecidableEq, Fintype

noncomputable def deltaS : Real := (1 : Real) / 5
noncomputable def deltaB : Real := (9 : Real) / 10

theorem deltaS_pos : 0 < deltaS := by norm_num [deltaS]
theorem deltaB_pos : 0 < deltaB := by norm_num [deltaB]

noncomputable def trapProbability (beta : Real) : Real :=
  Phi (deltaS * precisionScale beta)

noncomputable def goalProbability (beta : Real) : Real :=
  Phi (deltaB * precisionScale beta)

noncomputable def routeProbability (beta : Real) : Outcome -> Real
  | .trap => trapProbability beta
  | .goal => (1 - trapProbability beta) * goalProbability beta
  | .distractor => (1 - trapProbability beta) * (1 - goalProbability beta)

noncomputable def terminalLoss : Outcome -> Real
  | .trap => (4 : Real) / 10
  | .goal => 0
  | .distractor => (9 : Real) / 10

noncomputable def expectedLoss (beta : Real) : Real :=
  Finset.univ.sum fun outcome => routeProbability beta outcome * terminalLoss outcome

theorem outcome_univ : (Finset.univ : Finset Outcome) =
    { .trap, .goal, .distractor } := by decide

theorem trapProbability_mem_unit (beta : Real) :
    trapProbability beta ∈ Set.Icc (0 : Real) 1 :=
  ⟨Phi_nonneg _, Phi_le_one _⟩

theorem goalProbability_mem_unit (beta : Real) :
    goalProbability beta ∈ Set.Icc (0 : Real) 1 :=
  ⟨Phi_nonneg _, Phi_le_one _⟩

theorem routeProbability_nonneg (beta : Real) (outcome : Outcome) :
    0 <= routeProbability beta outcome := by
  rcases trapProbability_mem_unit beta with ⟨hTrap0, hTrap1⟩
  rcases goalProbability_mem_unit beta with ⟨hGoal0, hGoal1⟩
  cases outcome <;>
    simp [routeProbability, hTrap0, hTrap1, hGoal0, hGoal1, mul_nonneg]

theorem routeProbability_sum_one (beta : Real) :
    Finset.univ.sum (routeProbability beta) = 1 := by
  rw [outcome_univ]
  simp [routeProbability]
  ring

theorem expectedLoss_formula (beta : Real) :
    expectedLoss beta =
      (4 / 10 : Real) * trapProbability beta +
        (9 / 10 : Real) * (1 - trapProbability beta) *
          (1 - goalProbability beta) := by
  unfold expectedLoss
  rw [outcome_univ]
  simp [routeProbability, terminalLoss]
  ring

theorem expectedLoss_sub_limit (beta : Real) :
    expectedLoss beta - (4 : Real) / 10 =
      (1 - trapProbability beta) *
        ((1 : Real) / 2 - (9 : Real) / 10 * goalProbability beta) := by
  rw [expectedLoss_formula]
  ring

theorem trapProbability_continuous : Continuous trapProbability := by
  unfold trapProbability
  exact Phi_continuous.comp
    (continuous_const.mul precisionScale_continuous)

theorem goalProbability_continuous : Continuous goalProbability := by
  unfold goalProbability
  exact Phi_continuous.comp
    (continuous_const.mul precisionScale_continuous)

theorem expectedLoss_continuous : Continuous expectedLoss := by
  apply Continuous.congr
    (continuous_const.mul trapProbability_continuous |>.add
      (continuous_const.mul
        (continuous_const.sub trapProbability_continuous) |>.mul
          (continuous_const.sub goalProbability_continuous)))
  intro beta
  exact (expectedLoss_formula beta).symm

theorem expectedLoss_zero : expectedLoss 0 = (425 : Real) / 1000 := by
  rw [expectedLoss_formula]
  simp [trapProbability, goalProbability, precisionScale_zero, Phi_zero]
  norm_num

theorem trapProbability_tendsto_one :
    Tendsto trapProbability atTop (nhds 1) := by
  unfold trapProbability
  exact Phi_tendsto_one_atTop.comp
    (precisionScale_tendsto_atTop.const_mul_atTop deltaS_pos)

theorem goalProbability_tendsto_one :
    Tendsto goalProbability atTop (nhds 1) := by
  unfold goalProbability
  exact Phi_tendsto_one_atTop.comp
    (precisionScale_tendsto_atTop.const_mul_atTop deltaB_pos)

theorem expectedLoss_tendsto_atTop :
    Tendsto expectedLoss atTop (nhds ((4 : Real) / 10)) := by
  have hFormula : Tendsto
      (fun beta =>
        (4 / 10 : Real) * trapProbability beta +
          (9 / 10 : Real) * (1 - trapProbability beta) *
            (1 - goalProbability beta))
      atTop
      (nhds ((4 / 10 : Real) * 1 +
        (9 / 10 : Real) * (1 - 1) * (1 - 1))) :=
    (tendsto_const_nhds.mul trapProbability_tendsto_one).add
      ((tendsto_const_nhds.mul
        (tendsto_const_nhds.sub trapProbability_tendsto_one)).mul
          (tendsto_const_nhds.sub goalProbability_tendsto_one))
  have hTarget :
      (4 / 10 : Real) * 1 +
        (9 / 10 : Real) * (1 - 1) * (1 - 1) = (4 : Real) / 10 := by
    norm_num
  rw [hTarget] at hFormula
  exact hFormula.congr' (Filter.Eventually.of_forall fun beta =>
    (expectedLoss_formula beta).symm)

theorem exists_below_perfect_limit :
    exists beta0 : Real, 0 < beta0 /\ expectedLoss beta0 < (4 : Real) / 10 := by
  have hEventuallyGoal : ∀ᶠ beta in atTop,
      (5 / 9 : Real) < goalProbability beta :=
    goalProbability_tendsto_one.eventually
      (eventually_gt_nhds (by norm_num : (5 / 9 : Real) < 1))
  have hEventuallyPositive : ∀ᶠ beta : Real in atTop, 0 < beta :=
    eventually_gt_atTop 0
  rcases (hEventuallyGoal.and hEventuallyPositive).exists with
    ⟨beta0, hGoal, hBeta0⟩
  refine ⟨beta0, hBeta0, ?_⟩
  have hTrap : trapProbability beta0 < 1 := Phi_lt_one _
  have hFactorOne : 0 < 1 - trapProbability beta0 := by linarith
  have hFactorTwo :
      (1 / 2 : Real) - (9 / 10 : Real) * goalProbability beta0 < 0 := by
    linarith
  rw [← sub_neg, expectedLoss_sub_limit]
  exact mul_neg_of_pos_of_neg hFactorOne hFactorTwo

theorem exists_global_interior_minimum :
    exists betaStar : Real,
      0 < betaStar /\
      (forall beta : Real, 0 <= beta -> expectedLoss betaStar <= expectedLoss beta) /\
      expectedLoss betaStar < (4 : Real) / 10 := by
  rcases exists_below_perfect_limit with ⟨beta0, hBeta0, hBeta0Loss⟩
  have hBeta0BelowZero : expectedLoss beta0 < (425 : Real) / 1000 := by
    linarith
  have hAtZero : Tendsto expectedLoss
      (nhdsWithin 0 (Set.Ioi 0)) (nhds ((425 : Real) / 1000)) := by
    have h : Tendsto expectedLoss (nhds 0) (nhds (expectedLoss 0)) :=
      expectedLoss_continuous.continuousAt
    rw [expectedLoss_zero] at h
    exact h.mono_left inf_le_left
  have hNearZero : ∀ᶠ beta in nhdsWithin (0 : Real) (Set.Ioi 0),
      expectedLoss beta0 < expectedLoss beta :=
    hAtZero.eventually (eventually_gt_nhds hBeta0BelowZero)
  rw [eventually_nhdsWithin_iff, Metric.eventually_nhds_iff] at hNearZero
  rcases hNearZero with ⟨delta, hDelta, hDeltaProperty⟩
  let epsilon : Real := min (delta / 2) beta0
  have hEpsilonPos : 0 < epsilon := lt_min (by linarith) hBeta0
  have hEpsilonLeBeta0 : epsilon <= beta0 := min_le_right _ _
  have hBelowEpsilon : forall beta : Real, 0 < beta -> beta <= epsilon ->
      expectedLoss beta0 < expectedLoss beta := by
    intro beta hBeta hBetaLe
    have hDistance : dist beta (0 : Real) < delta := by
      rw [Real.dist_eq, sub_zero, abs_of_pos hBeta]
      have hLe : beta <= delta / 2 :=
        le_trans hBetaLe (min_le_left _ _)
      linarith
    exact hDeltaProperty hDistance hBeta
  have hAtTop : ∀ᶠ beta in atTop,
      expectedLoss beta0 < expectedLoss beta :=
    expectedLoss_tendsto_atTop.eventually
      (eventually_gt_nhds hBeta0Loss)
  rcases hAtTop.exists_forall_of_atTop with ⟨m0, hM0⟩
  let upper : Real := max m0 beta0
  have hBeta0LeUpper : beta0 <= upper := le_max_right _ _
  have hAboveUpper : forall beta : Real, upper <= beta ->
      expectedLoss beta0 < expectedLoss beta := by
    intro beta hBeta
    exact hM0 beta (le_trans (le_max_left _ _) hBeta)
  have hEpsilonLeUpper : epsilon <= upper :=
    le_trans hEpsilonLeBeta0 hBeta0LeUpper
  have hContinuous : ContinuousOn expectedLoss (Set.Icc epsilon upper) :=
    expectedLoss_continuous.continuousOn
  have hNonempty : (Set.Icc epsilon upper).Nonempty :=
    ⟨epsilon, le_rfl, hEpsilonLeUpper⟩
  rcases isCompact_Icc.exists_isMinOn hNonempty hContinuous with
    ⟨betaStar, hBetaStarMem, hMinimum⟩
  have hBetaStarPos : 0 < betaStar :=
    lt_of_lt_of_le hEpsilonPos hBetaStarMem.1
  have hBeta0Mem : beta0 ∈ Set.Icc epsilon upper :=
    ⟨hEpsilonLeBeta0, hBeta0LeUpper⟩
  have hStarLeWitness : expectedLoss betaStar <= expectedLoss beta0 :=
    hMinimum hBeta0Mem
  refine ⟨betaStar, hBetaStarPos, ?_, lt_of_le_of_lt hStarLeWitness hBeta0Loss⟩
  intro beta hBetaNonneg
  rcases lt_or_ge beta epsilon with hLow | hNotLow
  · rcases eq_or_lt_of_le hBetaNonneg with rfl | hBetaPos
    · rw [expectedLoss_zero]
      linarith
    · have hBoundary := hBelowEpsilon beta hBetaPos hLow.le
      linarith
  · rcases le_or_gt beta upper with hInside | hHigh
    · exact hMinimum ⟨hNotLow, hInside⟩
    · have hBoundary := hAboveUpper beta hHigh.le
      linarith

def InteriorOptimumClaim : Prop :=
  (forall beta, Finset.univ.sum (routeProbability beta) = 1) /\
  (forall beta outcome, 0 <= routeProbability beta outcome) /\
  (forall beta,
    expectedLoss beta =
      (4 / 10 : Real) * trapProbability beta +
        (9 / 10 : Real) * (1 - trapProbability beta) *
          (1 - goalProbability beta)) /\
  (forall beta,
    expectedLoss beta - (4 : Real) / 10 =
      (1 - trapProbability beta) *
        ((1 : Real) / 2 - (9 : Real) / 10 * goalProbability beta)) /\
  expectedLoss 0 = (425 : Real) / 1000 /\
  Tendsto expectedLoss atTop (nhds ((4 : Real) / 10)) /\
  exists betaStar : Real,
    0 < betaStar /\
    (forall beta : Real, 0 <= beta -> expectedLoss betaStar <= expectedLoss beta) /\
    expectedLoss betaStar < (4 : Real) / 10

theorem interiorOptimumClaim_proved : InteriorOptimumClaim := by
  exact ⟨routeProbability_sum_one, routeProbability_nonneg,
    expectedLoss_formula, expectedLoss_sub_limit, expectedLoss_zero,
    expectedLoss_tendsto_atTop, exists_global_interior_minimum⟩

end BlackwellDilemma.CurrentFiveState
