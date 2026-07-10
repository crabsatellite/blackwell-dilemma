/-
  BlackwellDilemma/UnifiedErrorCompounding.lean

  Exact finite trap-tree routing and cognitive-threshold bounds. Reward-noise
  comparisons use the same reduced-form Gaussian difference channel as the
  canonical finite examples. The estimator threshold band remains explicit.
-/

import BlackwellDilemma.Infrastructure.StandardNormalBridgeProbability
import BlackwellDilemma.Infrastructure.TrapTreeBernoulliWelfare
import BlackwellDilemma.Types

namespace BlackwellDilemma.ErrorCompounding

open Filter Topology
open BlackwellDilemma.Infrastructure

noncomputable def trapReward : Real := (6 : Real) / 10
noncomputable def bridgeReward : Real := (4 : Real) / 10
def goalReward : Real := 1
noncomputable def rewardGap : Real := trapReward - bridgeReward

def perfectGreedyChoices (depth : Nat) : Fin depth -> Bool :=
  fun _ => false

def oracleChoices (depth : Nat) : Fin depth -> Bool :=
  fun _ => true

theorem rewardGap_pos : 0 < rewardGap := by
  norm_num [rewardGap, trapReward, bridgeReward]

theorem perfectGreedy_terminalReward
    (depth : Nat) (hDepth : 0 < depth) :
    trapTreeTerminalReward trapReward goalReward depth
      (perfectGreedyChoices depth) = trapReward := by
  unfold trapTreeTerminalReward allBridgeIndicator perfectGreedyChoices
    boolSuccessIndicator
  simp [hDepth.ne']

theorem oracle_terminalReward (depth : Nat) :
    trapTreeTerminalReward trapReward goalReward depth
      (oracleChoices depth) = goalReward := by
  simp [trapTreeTerminalReward, allBridgeIndicator, oracleChoices,
    boolSuccessIndicator]

private theorem signalVariance_pos {beta : Real} (hBeta : 0 < beta) :
    0 < signalVariance beta := by
  have hExponent : (0 : Real) < 2 * beta := by linarith
  have hPow : (1 : Real) < (2 : Real) ^ (2 * beta) := by
    have h :=
      (Real.rpow_lt_rpow_left_iff (by norm_num : (1 : Real) < 2)).2 hExponent
    rw [Real.rpow_zero] at h
    exact h
  unfold signalVariance
  positivity

noncomputable def bridgeProbability (beta : Real) : Real :=
  gaussianBridgeProbability rewardGap (signalVariance beta)

noncomputable def welfare (beta : Real) (depth : Nat) : Real :=
  trapTreeExpectedWelfare trapReward goalReward
    (bridgeProbability beta) depth

theorem bridgeProbability_mem_openInterval
    {beta : Real} (hBeta : 0 < beta) :
    0 < bridgeProbability beta /\ bridgeProbability beta < (1 : Real) / 2 := by
  exact gaussianBridgeProbability_mem_openInterval
    rewardGap_pos (signalVariance_pos hBeta)

theorem welfare_formula (beta : Real) (depth : Nat) :
    welfare beta depth =
      trapReward + (goalReward - trapReward) * bridgeProbability beta ^ depth := by
  exact trapTreeExpectedWelfare_eq _ _ _ _

theorem welfare_gain_pos
    {beta : Real} (hBeta : 0 < beta) (depth : Nat) :
    0 < welfare beta depth - trapReward := by
  exact trapTreeWelfareGain_pos _ _ _ _ (by norm_num [trapReward, goalReward])
    (bridgeProbability_mem_openInterval hBeta).1

theorem welfare_gain_lt_half_power
    {beta : Real} (hBeta : 0 < beta)
    {depth : Nat} (hDepth : 0 < depth) :
    welfare beta depth - trapReward <
      (goalReward - trapReward) * ((1 : Real) / 2) ^ depth := by
  rw [welfare_formula]
  have hPower : bridgeProbability beta ^ depth < ((1 : Real) / 2) ^ depth :=
    pow_lt_pow_left₀
      (bridgeProbability_mem_openInterval hBeta).2
      (bridgeProbability_mem_openInterval hBeta).1.le hDepth.ne'
  have hPremium : 0 < goalReward - trapReward := by
    norm_num [goalReward, trapReward]
  linarith [mul_lt_mul_of_pos_left hPower hPremium]

theorem welfare_tendsto_trap_in_depth
    {beta : Real} (hBeta : 0 < beta) :
    Tendsto (fun depth : Nat => welfare beta depth)
      atTop (nhds trapReward) := by
  exact trapTreeExpectedWelfare_tendsto_trap _ _ _
    (bridgeProbability_mem_openInterval hBeta).1.le
    ((bridgeProbability_mem_openInterval hBeta).2.trans (by norm_num))

noncomputable def topologyNoise (kappa : Real) (level : Nat) : Real :=
  (level : Real) ^ 2 / ((2 : Real) ^ (2 * kappa) - 1)

/-- A reduced-form estimator whose acceptance region is pinned down outside
    an explicit threshold band. Behavior inside the band is unrestricted. -/
structure ThresholdEstimator where
  accepts : Real -> Prop
  cTwo : Real
  cOne : Real
  cTwo_pos : 0 < cTwo
  cTwo_le_cOne : cTwo <= cOne
  accepts_of_le_cTwo : forall variance,
    0 <= variance -> variance <= cTwo -> accepts variance
  rejects_of_cOne_lt : forall variance,
    cOne < variance -> Not (accepts variance)

namespace ThresholdEstimator

theorem cOne_pos (E : ThresholdEstimator) : 0 < E.cOne :=
  E.cTwo_pos.trans_le E.cTwo_le_cOne

def depthSufficient (E : ThresholdEstimator)
    (depth : Nat) (kappa : Real) : Prop :=
  0 < kappa /\
    forall level : Nat, 1 <= level -> level <= depth ->
      E.accepts (topologyNoise kappa level)

noncomputable def cognitiveThreshold
    (E : ThresholdEstimator) (depth : Nat) : Real :=
  sInf {kappa : Real | E.depthSufficient depth kappa}

private theorem cutoff_pos
    (c : Real) (hC : 0 < c) (depth : Nat) (hDepth : 0 < depth) :
    0 < kappaStarClosedForm c depth := by
  have hDepthReal : 0 < (depth : Real) := by exact_mod_cast hDepth
  have hInner : 1 < ((depth : Real) ^ 2) / c + 1 := by
    have : 0 < ((depth : Real) ^ 2) / c := by positivity
    linarith
  unfold kappaStarClosedForm
  have hLog : 0 < Real.logb 2 (((depth : Real) ^ 2) / c + 1) :=
    Real.logb_pos (by norm_num) hInner
  positivity

private theorem rpow_two_mul_cutoff
    (c : Real) (hC : 0 < c) (depth : Nat) (hDepth : 0 < depth) :
    (2 : Real) ^ (2 * kappaStarClosedForm c depth) =
      ((depth : Real) ^ 2) / c + 1 := by
  have hDepthReal : 0 < (depth : Real) := by exact_mod_cast hDepth
  have hInner : 0 < ((depth : Real) ^ 2) / c + 1 := by positivity
  unfold kappaStarClosedForm
  rw [show 2 * ((1 / 2 : Real) *
      Real.logb 2 (((depth : Real) ^ 2) / c + 1)) =
      Real.logb 2 (((depth : Real) ^ 2) / c + 1) by ring]
  exact Real.rpow_logb (by norm_num) (by norm_num) hInner

theorem topologyNoise_at_cutoff
    (c : Real) (hC : 0 < c) (depth : Nat) (hDepth : 0 < depth) :
    topologyNoise (kappaStarClosedForm c depth) depth = c := by
  rw [topologyNoise, rpow_two_mul_cutoff c hC depth hDepth]
  have hDepthReal : 0 < (depth : Real) := by exact_mod_cast hDepth
  field_simp
  ring

private theorem cutoff_denominator_pos
    (c : Real) (hC : 0 < c) (depth : Nat) (hDepth : 0 < depth) :
    0 < (2 : Real) ^ (2 * kappaStarClosedForm c depth) - 1 := by
  rw [rpow_two_mul_cutoff c hC depth hDepth]
  have hDepthReal : 0 < (depth : Real) := by exact_mod_cast hDepth
  have : 0 < (depth : Real) ^ 2 / c := by positivity
  linarith

theorem topologyNoise_level_le_at_cutoff
    (c : Real) (hC : 0 < c)
    {level depth : Nat} (hLevel : level <= depth) (hDepth : 0 < depth) :
    topologyNoise (kappaStarClosedForm c depth) level <= c := by
  have hLevelReal : (level : Real) <= (depth : Real) := by exact_mod_cast hLevel
  have hLevelNonnegative : 0 <= (level : Real) := Nat.cast_nonneg level
  have hDepthNonnegative : 0 <= (depth : Real) := Nat.cast_nonneg depth
  have hSquare : (level : Real) ^ 2 <= (depth : Real) ^ 2 := by
    nlinarith
  calc
    topologyNoise (kappaStarClosedForm c depth) level <=
        topologyNoise (kappaStarClosedForm c depth) depth := by
      unfold topologyNoise
      exact div_le_div_of_nonneg_right hSquare
        (cutoff_denominator_pos c hC depth hDepth).le
    _ = c := topologyNoise_at_cutoff c hC depth hDepth

private theorem topologyNoise_nonneg_at_cutoff
    (c : Real) (hC : 0 < c)
    (level depth : Nat) (hDepth : 0 < depth) :
    0 <= topologyNoise (kappaStarClosedForm c depth) level := by
  unfold topologyNoise
  exact div_nonneg (sq_nonneg _)
    (cutoff_denominator_pos c hC depth hDepth).le

theorem topologyNoise_gt_of_lt_cutoff
    (c : Real) (hC : 0 < c)
    (depth : Nat) (hDepth : 0 < depth)
    {kappa : Real} (hKappa : 0 < kappa)
    (hBelow : kappa < kappaStarClosedForm c depth) :
    c < topologyNoise kappa depth := by
  have hExponent : 2 * kappa < 2 * kappaStarClosedForm c depth := by linarith
  have hPowLt :
      (2 : Real) ^ (2 * kappa) <
        (2 : Real) ^ (2 * kappaStarClosedForm c depth) :=
    (Real.rpow_lt_rpow_left_iff (by norm_num : (1 : Real) < 2)).2 hExponent
  rw [rpow_two_mul_cutoff c hC depth hDepth] at hPowLt
  have hDenominatorPos : 0 < (2 : Real) ^ (2 * kappa) - 1 := by
    have hOneLt : (1 : Real) < (2 : Real) ^ (2 * kappa) := by
      have h :=
        (Real.rpow_lt_rpow_left_iff (by norm_num : (1 : Real) < 2)).2
          (by linarith : (0 : Real) < 2 * kappa)
      rw [Real.rpow_zero] at h
      exact h
    linarith
  have hDenominatorLt :
      (2 : Real) ^ (2 * kappa) - 1 < (depth : Real) ^ 2 / c := by
    linarith
  unfold topologyNoise
  apply (lt_div_iff₀ hDenominatorPos).2
  calc
    c * ((2 : Real) ^ (2 * kappa) - 1) <
        c * ((depth : Real) ^ 2 / c) :=
      mul_lt_mul_of_pos_left hDenominatorLt hC
    _ = (depth : Real) ^ 2 := by field_simp

private theorem upper_cutoff_sufficient
    (E : ThresholdEstimator) (depth : Nat) (hDepth : 0 < depth) :
    E.depthSufficient depth (kappaStarClosedForm E.cTwo depth) := by
  refine ⟨cutoff_pos E.cTwo E.cTwo_pos depth hDepth, ?_⟩
  intro level _hLevelOne hLevelDepth
  exact E.accepts_of_le_cTwo _
    (topologyNoise_nonneg_at_cutoff E.cTwo E.cTwo_pos level depth hDepth)
    (topologyNoise_level_le_at_cutoff E.cTwo E.cTwo_pos hLevelDepth hDepth)

theorem sufficientSet_nonempty
    (E : ThresholdEstimator) (depth : Nat) (hDepth : 0 < depth) :
    {kappa : Real | E.depthSufficient depth kappa}.Nonempty :=
  ⟨kappaStarClosedForm E.cTwo depth,
    upper_cutoff_sufficient E depth hDepth⟩

theorem sufficientSet_bddBelow
    (E : ThresholdEstimator) (depth : Nat) :
    BddBelow {kappa : Real | E.depthSufficient depth kappa} := by
  refine ⟨0, ?_⟩
  intro kappa hKappa
  exact hKappa.1.le

theorem cognitiveThreshold_upper
    (E : ThresholdEstimator) (depth : Nat) (hDepth : 0 < depth) :
    E.cognitiveThreshold depth <= kappaStarClosedForm E.cTwo depth := by
  unfold cognitiveThreshold
  exact csInf_le (sufficientSet_bddBelow E depth)
    (upper_cutoff_sufficient E depth hDepth)

theorem cognitiveThreshold_lower
    (E : ThresholdEstimator) (depth : Nat) (hDepth : 0 < depth) :
    kappaStarClosedForm E.cOne depth <= E.cognitiveThreshold depth := by
  unfold cognitiveThreshold
  apply le_csInf (sufficientSet_nonempty E depth hDepth)
  intro kappa hKappa
  by_contra hNot
  have hBelow : kappa < kappaStarClosedForm E.cOne depth := lt_of_not_ge hNot
  have hNoise : E.cOne < topologyNoise kappa depth :=
    topologyNoise_gt_of_lt_cutoff E.cOne E.cOne_pos depth hDepth
      hKappa.1 hBelow
  exact E.rejects_of_cOne_lt _ hNoise
    (hKappa.2 depth hDepth le_rfl)

theorem cognitiveThreshold_bounds
    (E : ThresholdEstimator) (depth : Nat) (hDepth : 0 < depth) :
    kappaStarClosedForm E.cOne depth <= E.cognitiveThreshold depth /\
      E.cognitiveThreshold depth <= kappaStarClosedForm E.cTwo depth :=
  ⟨cognitiveThreshold_lower E depth hDepth,
    cognitiveThreshold_upper E depth hDepth⟩

end ThresholdEstimator

def ErrorCompoundingClaim : Prop :=
  (forall depth : Nat, 0 < depth ->
    trapTreeTerminalReward trapReward goalReward depth
      (perfectGreedyChoices depth) = trapReward) /\
  (forall depth : Nat,
    trapTreeTerminalReward trapReward goalReward depth
      (oracleChoices depth) = goalReward) /\
  (forall beta : Real, 0 < beta -> forall depth : Nat, 0 < depth ->
    0 < bridgeProbability beta /\
      bridgeProbability beta < (1 : Real) / 2 /\
      welfare beta depth = trapReward +
        (goalReward - trapReward) * bridgeProbability beta ^ depth /\
      0 < welfare beta depth - trapReward /\
      welfare beta depth - trapReward <
        (goalReward - trapReward) * ((1 : Real) / 2) ^ depth) /\
  (forall beta : Real, 0 < beta ->
    Tendsto (fun depth : Nat => welfare beta depth)
      atTop (nhds trapReward)) /\
  (forall E : ThresholdEstimator, forall depth : Nat, 0 < depth ->
    kappaStarClosedForm E.cOne depth <= E.cognitiveThreshold depth /\
      E.cognitiveThreshold depth <= kappaStarClosedForm E.cTwo depth)

theorem errorCompoundingClaim_proved : ErrorCompoundingClaim := by
  refine ⟨perfectGreedy_terminalReward, oracle_terminalReward, ?_,
    (fun beta hBeta => welfare_tendsto_trap_in_depth hBeta),
    ThresholdEstimator.cognitiveThreshold_bounds⟩
  intro beta hBeta depth hDepth
  exact ⟨(bridgeProbability_mem_openInterval hBeta).1,
    (bridgeProbability_mem_openInterval hBeta).2,
    welfare_formula beta depth,
    welfare_gain_pos hBeta depth,
    welfare_gain_lt_half_power hBeta hDepth⟩

end BlackwellDilemma.ErrorCompounding
