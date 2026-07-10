/-
  BlackwellDilemma/UnifiedTwoRegime.lean

  Exact two-regime theorem for the five-state benchmark. The greedy-loss
  theorem and perfect-topology benchmark are proved here; behavior under a
  partially informative topology signal remains a separate model claim.
-/

import BlackwellDilemma.UnifiedInterior

namespace BlackwellDilemma.FiveStateTwoRegime

open FiveState

inductive RoutingOutcome where
  | trap
  | openGoal
  | openDistractor
  | blockedDistractor
  deriving DecidableEq, Fintype

noncomputable def outcomeProbability (beta p : Real) : RoutingOutcome -> Real
  | .trap => P_trap beta
  | .openGoal => (1 - P_trap beta) * (1 - p) * Phi_B beta
  | .openDistractor =>
      (1 - P_trap beta) * (1 - p) * (1 - Phi_B beta)
  | .blockedDistractor => (1 - P_trap beta) * p

noncomputable def terminalLoss : RoutingOutcome -> Real
  | .trap => (4 : Real) / 10
  | .openGoal => 0
  | .openDistractor => (9 : Real) / 10
  | .blockedDistractor => (9 : Real) / 10

noncomputable def expectedLoss (beta p : Real) : Real :=
  ∑ outcome : RoutingOutcome,
    outcomeProbability beta p outcome * terminalLoss outcome

theorem routingOutcome_univ : (Finset.univ : Finset RoutingOutcome) =
    { .trap, .openGoal, .openDistractor, .blockedDistractor } := by
  decide

theorem outcomeProbability_nonneg (beta p : Real)
    (hp_nonneg : 0 <= p) (hp_le_one : p <= 1)
    (outcome : RoutingOutcome) :
    0 <= outcomeProbability beta p outcome := by
  have hTrapNonneg : 0 <= P_trap beta := by
    unfold P_trap
    exact Phi_nonneg _
  have hTrapLe : P_trap beta <= 1 := by
    unfold P_trap
    exact Phi_le_one _
  have hGoalNonneg : 0 <= Phi_B beta := by
    unfold Phi_B
    exact Phi_nonneg _
  have hGoalLe : Phi_B beta <= 1 := by
    unfold Phi_B
    exact Phi_le_one _
  have hOneTrap : 0 <= 1 - P_trap beta := sub_nonneg.mpr hTrapLe
  have hOneP : 0 <= 1 - p := sub_nonneg.mpr hp_le_one
  have hOneGoal : 0 <= 1 - Phi_B beta := sub_nonneg.mpr hGoalLe
  cases outcome <;>
    simp only [outcomeProbability] <;> positivity

theorem outcomeProbability_sum_one (beta p : Real) :
    ∑ outcome : RoutingOutcome, outcomeProbability beta p outcome = 1 := by
  rw [routingOutcome_univ]
  simp [outcomeProbability]
  ring

theorem expectedLoss_eq_L (beta p : Real) : expectedLoss beta p = L beta p := by
  unfold expectedLoss
  rw [routingOutcome_univ]
  simp [outcomeProbability, terminalLoss, L]
  ring

inductive EdgeState where
  | open
  | blocked
  deriving DecidableEq, Fintype

noncomputable def edgeProbability (p : Real) : EdgeState -> Real
  | .open => 1 - p
  | .blocked => p

noncomputable def bridgeContinuationReward : EdgeState -> Real
  | .open => 1
  | .blocked => (1 : Real) / 10

noncomputable def perfectTopologyReward : EdgeState -> Real
  | .open => 1
  | .blocked => (6 : Real) / 10

noncomputable def expectedBridgeContinuation (p : Real) : Real :=
  ∑ state : EdgeState, edgeProbability p state * bridgeContinuationReward state

noncomputable def expectedPerfectTopologyReward (p : Real) : Real :=
  ∑ state : EdgeState, edgeProbability p state * perfectTopologyReward state

noncomputable def topologicalLossMagnitude (p : Real) : Real :=
  1 - expectedPerfectTopologyReward p

noncomputable def informationalLossMagnitude (p : Real) : Real :=
  expectedPerfectTopologyReward p - r_A

theorem edgeState_univ : (Finset.univ : Finset EdgeState) =
    { .open, .blocked } := by
  decide

theorem edgeProbability_sum_one (p : Real) :
    ∑ state : EdgeState, edgeProbability p state = 1 := by
  rw [edgeState_univ]
  simp [edgeProbability]

theorem expectedBridgeContinuation_formula (p : Real) :
    expectedBridgeContinuation p = 1 - (9 / 10 : Real) * p := by
  unfold expectedBridgeContinuation
  rw [edgeState_univ]
  simp [edgeProbability, bridgeContinuationReward]
  ring

theorem expectedPerfectTopologyReward_formula (p : Real) :
    expectedPerfectTopologyReward p = 1 - (4 / 10 : Real) * p := by
  unfold expectedPerfectTopologyReward
  rw [edgeState_univ]
  simp [edgeProbability, perfectTopologyReward]
  ring

theorem expectedBridgeContinuation_gt_trap_iff (p : Real) :
    r_A < expectedBridgeContinuation p <-> p < p_1 := by
  rw [expectedBridgeContinuation_formula]
  unfold r_A p_1
  constructor <;> intro h <;> norm_num at h ⊢ <;> linarith

theorem expectedBridgeContinuation_le_trap_iff (p : Real) :
    expectedBridgeContinuation p <= r_A <-> p_1 <= p := by
  rw [expectedBridgeContinuation_formula]
  unfold r_A p_1
  constructor <;> intro h <;> norm_num at h ⊢ <;> linarith

theorem topologicalLossMagnitude_formula (p : Real) :
    topologicalLossMagnitude p = (4 / 10 : Real) * p := by
  unfold topologicalLossMagnitude
  rw [expectedPerfectTopologyReward_formula]
  ring

theorem informationalLossMagnitude_formula (p : Real) :
    informationalLossMagnitude p = (4 / 10 : Real) * (1 - p) := by
  unfold informationalLossMagnitude r_A
  rw [expectedPerfectTopologyReward_formula]
  ring

theorem lossMagnitude_decomposition (p : Real) :
    topologicalLossMagnitude p + informationalLossMagnitude p =
      (4 / 10 : Real) := by
  rw [topologicalLossMagnitude_formula, informationalLossMagnitude_formula]
  ring

theorem L_strictMono_in_p (beta : Real) {p q : Real} (hpq : p < q) :
    L beta p < L beta q := by
  have hTrapLt : P_trap beta < 1 := by
    unfold P_trap
    exact Phi_lt_one _
  have hGoalPos : 0 < Phi_B beta := by
    unfold Phi_B
    exact Phi_pos _
  have hCoefficient :
      0 < (1 - P_trap beta) * (9 / 10 : Real) * Phi_B beta := by
    positivity
  have hDifference :
      L beta q - L beta p =
        (1 - P_trap beta) * (9 / 10 : Real) * Phi_B beta * (q - p) := by
    unfold L
    ring
  have : 0 < L beta q - L beta p := by
    rw [hDifference]
    exact mul_pos hCoefficient (sub_pos.mpr hpq)
  linarith

def ReversalBundle (p : Real) : Prop :=
  exists betaStar : Real,
    0 < betaStar /\
    (forall beta : Real, 0 < beta -> L betaStar p <= L beta p) /\
    (forall beta : Real, 0 < beta ->
      L beta p <= L betaStar p -> beta = betaStar) /\
    L betaStar p < (4 / 10 : Real) /\
    (exists betaLow betaHigh : Real,
      0 < betaLow /\ betaLow < betaHigh /\ L betaHigh p < L betaLow p) /\
    (exists betaLow betaHigh : Real,
      0 < betaLow /\ betaLow < betaHigh /\ L betaLow p < L betaHigh p) /\
    r_A < expectedBridgeContinuation p

theorem reversalBundle (p : Real) (hp_nonneg : 0 <= p) (hp_lt : p < p_1) :
    ReversalBundle p := by
  have hBetaPos : 0 < betaStarOfP p := betaStarOfP_pos hp_nonneg hp_lt
  have hBetaMin : forall beta : Real, 0 < beta ->
      L (betaStarOfP p) p <= L beta p :=
    betaStarOfP_def p hp_nonneg hp_lt
  obtain ⟨betaUnique, hBetaUniquePos, hUnique⟩ :=
    gap_two_regime_reversal_uniqueness p hp_nonneg hp_lt
  have hSelectedLeUnique :
      L (betaStarOfP p) p <= L betaUnique p :=
    hBetaMin betaUnique hBetaUniquePos
  have hSelectedEqUnique : betaStarOfP p = betaUnique :=
    hUnique (betaStarOfP p) hBetaPos hSelectedLeUnique
  obtain ⟨hDecreasing, hIncreasing⟩ :=
    gap_two_regime_reversal_nonmonotone p hp_nonneg hp_lt
  refine ⟨betaStarOfP p, hBetaPos, hBetaMin, ?_,
    betaStarOfP_loss_below_limit p hp_nonneg hp_lt,
    hDecreasing, hIncreasing,
    (expectedBridgeContinuation_gt_trap_iff p).2 hp_lt⟩
  intro beta hBeta hLoss
  have hLossToUnique : L beta p <= L betaUnique p := by
    simpa [← hSelectedEqUnique] using hLoss
  exact (hUnique beta hBeta hLossToUnique).trans hSelectedEqUnique.symm

theorem optimalLoss_strictMono_regimeI {p q : Real}
    (hp_nonneg : 0 <= p) (hpq : p < q) (hq_lt : q < p_1) :
    L (betaStarOfP p) p < L (betaStarOfP q) q := by
  have hq_nonneg : 0 <= q := le_trans hp_nonneg hpq.le
  have hBetaQPos : 0 < betaStarOfP q := betaStarOfP_pos hq_nonneg hq_lt
  calc
    L (betaStarOfP p) p <= L (betaStarOfP q) p :=
      betaStarOfP_def p hp_nonneg (lt_trans hpq hq_lt)
        (betaStarOfP q) hBetaQPos
    _ < L (betaStarOfP q) q := L_strictMono_in_p (betaStarOfP q) hpq

theorem overshootRegimeI_strictAnti {p q : Real}
    (hp_nonneg : 0 <= p) (hpq : p < q) (hq_lt : q < p_1) :
    overshootRegimeI q < overshootRegimeI p := by
  have hLoss := optimalLoss_strictMono_regimeI hp_nonneg hpq hq_lt
  unfold overshootRegimeI
  linarith

theorem topologyRegime_finite_loss_gt_limit (p : Real)
    (hp_lo : p_1 <= p) (hp_hi : p < 1) (beta : Real) :
    (4 / 10 : Real) < L beta p := by
  have hTrapLt : P_trap beta < 1 := by
    unfold P_trap
    exact Phi_lt_one _
  have hGoalNonneg : 0 <= Phi_B beta := by
    unfold Phi_B
    exact Phi_nonneg _
  have hGoalLt : Phi_B beta < 1 := by
    unfold Phi_B
    exact Phi_lt_one _
  have hOnePPos : 0 < 1 - p := by linarith
  have hOnePBound : 1 - p <= (5 / 9 : Real) := by
    unfold p_1 at hp_lo
    linarith
  have hScaledGoalLt : (1 - p) * Phi_B beta < (5 / 9 : Real) := by
    have hMulLt : (1 - p) * Phi_B beta < (1 - p) * 1 :=
      mul_lt_mul_of_pos_left hGoalLt hOnePPos
    nlinarith
  have hBracketPos :
      0 < (1 / 2 : Real) - (9 / 10 : Real) * (1 - p) * Phi_B beta := by
    nlinarith
  have hProductPos :
      0 < (1 - P_trap beta) *
        ((1 / 2 : Real) - (9 / 10 : Real) * (1 - p) * Phi_B beta) := by
    exact mul_pos (sub_pos.mpr hTrapLt) hBracketPos
  have hLossDifference : 0 < L beta p - (4 / 10 : Real) := by
    rw [L_rearrangement]
    exact hProductPos
  linarith

structure TopologyRegimeBundle (p : Real) : Prop where
  lossAntitone : forall betaLow betaHigh : Real,
    0 < betaLow -> betaLow <= betaHigh -> L betaHigh p <= L betaLow p
  lossAtTop : Filter.Tendsto (fun beta : Real => L beta p)
    Filter.atTop (nhds (4 / 10 : Real))
  finiteLossAboveLimit : forall beta : Real, (4 / 10 : Real) < L beta p
  priorBridgeNotPreferred : expectedBridgeContinuation p <= r_A
  perfectTopologyRewardFormula :
    expectedPerfectTopologyReward p = 1 - (4 / 10 : Real) * p
  topologicalLossFormula :
    topologicalLossMagnitude p = (4 / 10 : Real) * p
  informationalLossFormula :
    informationalLossMagnitude p = (4 / 10 : Real) * (1 - p)
  totalLossDecomposition :
    topologicalLossMagnitude p + informationalLossMagnitude p =
      (4 / 10 : Real)

theorem topologyRegimeBundle (p : Real) (hp_lo : p_1 <= p) (hp_hi : p < 1) :
    TopologyRegimeBundle p := by
  have hAntitone : forall betaLow betaHigh : Real,
      0 < betaLow -> betaLow <= betaHigh -> L betaHigh p <= L betaLow p := by
    intro betaLow betaHigh hBetaLow hBetaLe
    by_cases hp_mid : p <= p_2
    · exact gap_two_regime_cognitive_augmentation_monotonicity
        p hp_lo hp_mid betaLow betaHigh hBetaLow hBetaLe
    · exact gap_two_regime_sufficient_cognition
        p (lt_of_not_ge hp_mid) hp_hi betaLow betaHigh hBetaLow hBetaLe
  exact
    { lossAntitone := hAntitone
      lossAtTop := L_tendsto_limit_atTop p
      finiteLossAboveLimit := topologyRegime_finite_loss_gt_limit p hp_lo hp_hi
      priorBridgeNotPreferred :=
        (expectedBridgeContinuation_le_trap_iff p).2 hp_lo
      perfectTopologyRewardFormula := expectedPerfectTopologyReward_formula p
      topologicalLossFormula := topologicalLossMagnitude_formula p
      informationalLossFormula := informationalLossMagnitude_formula p
      totalLossDecomposition := lossMagnitude_decomposition p }

structure FiniteRoutingBundle (beta p : Real) : Prop where
  probabilitySum :
    ∑ outcome : RoutingOutcome, outcomeProbability beta p outcome = 1
  expectedLossFormula : expectedLoss beta p = L beta p

theorem finiteRoutingBundle (beta p : Real) : FiniteRoutingBundle beta p :=
  ⟨outcomeProbability_sum_one beta p, expectedLoss_eq_L beta p⟩

/-- Exact machine target for the repaired manuscript Proposition
    `prop:two-regime-five-state`. Partially informed topology-signal behavior
    is deliberately excluded until its signal kernel is specified. -/
def TwoRegimeClaim : Prop :=
  p_1 = (4 / 9 : Real) /\
  (forall beta p : Real, FiniteRoutingBundle beta p) /\
  (forall beta p : Real, 0 <= p -> p <= 1 -> forall outcome : RoutingOutcome,
    0 <= outcomeProbability beta p outcome) /\
  (forall p : Real, 0 <= p -> p < p_1 -> ReversalBundle p) /\
  ContinuousOn overshootRegimeI (Set.Ico (0 : Real) p_1) /\
  (forall p q : Real, 0 <= p -> p < q -> q < p_1 ->
    overshootRegimeI q < overshootRegimeI p) /\
  Filter.Tendsto overshootRegimeI
    (nhdsWithin p_1 (Set.Iio p_1)) (nhds 0) /\
  (forall p : Real, p_1 <= p -> p < 1 -> TopologyRegimeBundle p)

theorem twoRegimeClaim_proved : TwoRegimeClaim := by
  refine ⟨rfl, finiteRoutingBundle, ?_, reversalBundle,
    gap_two_regime_reversal_overshoot_continuous, ?_,
    gap_two_regime_reversal_overshoot_vanishes_at_p1, topologyRegimeBundle⟩
  · intro beta p hp_nonneg hp_le_one outcome
    exact outcomeProbability_nonneg beta p hp_nonneg hp_le_one outcome
  · intro p q hp_nonneg hpq hq_lt
    exact overshootRegimeI_strictAnti hp_nonneg hpq hq_lt

end BlackwellDilemma.FiveStateTwoRegime
