/-
  BlackwellDilemma/UnifiedCognitiveThreshold.lean

  A semantic repair of the paper's cognitive-threshold theorem. Cognition is
  an explicit reveal-or-erasure topology experiment. The decision score is
  conditioned on the realized target state, so it can genuinely vary with
  experiment informativeness without contradicting iterated expectations.
-/

import BlackwellDilemma.UnifiedCognitiveFiveState
import BlackwellDilemma.Infrastructure.KappaStarClosedForm

namespace BlackwellDilemma.CognitiveThreshold

open Filter Set Topology
open BlackwellDilemma.FiveStateCognition

theorem revealProbability_strictMono : StrictMono revealProbability := by
  intro kappaLow kappaHigh hKappa
  have hPow :
      (1 / 2 : Real) ^ kappaHigh < (1 / 2 : Real) ^ kappaLow :=
    (Real.strictAnti_rpow_of_base_lt_one
      (by norm_num : (0 : Real) < 1 / 2)
      (by norm_num : (1 / 2 : Real) < 1)) hKappa
  unfold revealProbability
  linarith

/-- State-conditioned gap between the bridge and trap continuation scores.
On an erasure the prior gap is used; on revelation the realized true gap is
used. -/
noncomputable def interpolatedScore
    (priorGap trueGap kappa : Real) : Real :=
  priorGap + revealProbability kappa * (trueGap - priorGap)

theorem interpolatedScore_zero (priorGap trueGap : Real) :
    interpolatedScore priorGap trueGap 0 = priorGap := by
  simp [interpolatedScore, revealProbability_zero]

theorem interpolatedScore_continuous (priorGap trueGap : Real) :
    Continuous (interpolatedScore priorGap trueGap) := by
  unfold interpolatedScore
  exact continuous_const.add
    (revealProbability_continuous.mul continuous_const)

theorem interpolatedScore_strictMono
    {priorGap trueGap : Real} (hGap : priorGap < trueGap) :
    StrictMono (interpolatedScore priorGap trueGap) := by
  intro kappaLow kappaHigh hKappa
  have hReveal := revealProbability_strictMono hKappa
  have hPositive : 0 < trueGap - priorGap := sub_pos.mpr hGap
  unfold interpolatedScore
  nlinarith

theorem interpolatedScore_tendsto_trueGap (priorGap trueGap : Real) :
    Tendsto (interpolatedScore priorGap trueGap) atTop (nhds trueGap) := by
  have hScaled := revealProbability_tendsto_one.mul_const (trueGap - priorGap)
  have hConstant :
      Tendsto (fun _ : Real => priorGap) atTop (nhds priorGap) :=
    tendsto_const_nhds
  have hShifted := hConstant.add hScaled
  simpa [interpolatedScore] using hShifted

/-- A negative erasure-prior gap and a positive revealed-state gap produce a
unique positive crossing depth. -/
theorem exists_unique_positive_threshold
    {priorGap trueGap : Real}
    (hPrior : priorGap < 0) (hTrue : 0 < trueGap) :
    ∃! kappaStar : Real,
      0 < kappaStar /\
        interpolatedScore priorGap trueGap kappaStar = 0 := by
  have hEventuallyPositive :
      Filter.Eventually (fun kappa =>
        0 < interpolatedScore priorGap trueGap kappa) atTop :=
    (interpolatedScore_tendsto_trueGap priorGap trueGap).eventually
      (Ioi_mem_nhds hTrue)
  obtain ⟨kappaHigh, hScoreHigh, hKappaHigh⟩ :=
    (hEventuallyPositive.and (eventually_gt_atTop 0)).exists
  have hZeroInRange :
      (0 : Real) ∈ Set.Icc
        (interpolatedScore priorGap trueGap 0)
        (interpolatedScore priorGap trueGap kappaHigh) := by
    rw [interpolatedScore_zero]
    exact ⟨hPrior.le, hScoreHigh.le⟩
  obtain ⟨kappaStar, hKappaStarRange, hScoreZero⟩ :=
    intermediate_value_Icc hKappaHigh.le
      (interpolatedScore_continuous priorGap trueGap).continuousOn
      hZeroInRange
  have hKappaStarNe : kappaStar ≠ 0 := by
    intro hZero
    subst kappaStar
    rw [interpolatedScore_zero] at hScoreZero
    linarith
  have hKappaStarPositive : 0 < kappaStar :=
    lt_of_le_of_ne hKappaStarRange.1 (Ne.symm hKappaStarNe)
  refine ⟨kappaStar, ⟨hKappaStarPositive, hScoreZero⟩, ?_⟩
  intro other hOther
  exact (interpolatedScore_strictMono (hPrior.trans hTrue)).injective
    (hOther.2.trans hScoreZero.symm)

def IsThreshold
    (priorGap trueGap kappaStar : Real) : Prop :=
  0 < kappaStar /\
    interpolatedScore priorGap trueGap kappaStar = 0 /\
    (forall kappa, kappa < kappaStar ->
      interpolatedScore priorGap trueGap kappa < 0) /\
    (forall kappa, kappaStar < kappa ->
      0 < interpolatedScore priorGap trueGap kappa)

theorem exists_unique_threshold
    {priorGap trueGap : Real}
    (hPrior : priorGap < 0) (hTrue : 0 < trueGap) :
    ∃! kappaStar : Real,
      IsThreshold priorGap trueGap kappaStar := by
  obtain ⟨kappaStar, hRoot, hUniqueRoot⟩ :=
    exists_unique_positive_threshold hPrior hTrue
  have hStrict := interpolatedScore_strictMono (hPrior.trans hTrue)
  have hBelow : forall kappa, kappa < kappaStar ->
      interpolatedScore priorGap trueGap kappa < 0 := by
    intro kappa hKappa
    simpa [hRoot.2] using hStrict hKappa
  have hAbove : forall kappa, kappaStar < kappa ->
      0 < interpolatedScore priorGap trueGap kappa := by
    intro kappa hKappa
    simpa [hRoot.2] using hStrict hKappa
  refine ⟨kappaStar, ⟨hRoot.1, hRoot.2, hBelow, hAbove⟩, ?_⟩
  intro other hOther
  exact hUniqueRoot other ⟨hOther.1, hOther.2.1⟩

/-- Probability of choosing the dynamically correct route when reward-signal
precision is `beta` and the state-conditioned route score is `score`. -/
noncomputable def correctRouteProbability
    (beta score : Real) : Real :=
  Phi (score * Real.sqrt beta)

theorem correctRouteProbability_mono_of_score_nonneg
    {betaLow betaHigh score : Real}
    (hBeta : betaLow <= betaHigh) (hScore : 0 <= score) :
    correctRouteProbability betaLow score <=
      correctRouteProbability betaHigh score := by
  apply Phi_monotone
  exact mul_le_mul_of_nonneg_left (Real.sqrt_le_sqrt hBeta) hScore

theorem correctRouteProbability_antitone_of_score_nonpos
    {betaLow betaHigh score : Real}
    (hBeta : betaLow <= betaHigh) (hScore : score <= 0) :
    correctRouteProbability betaHigh score <=
      correctRouteProbability betaLow score := by
  apply Phi_monotone
  exact mul_le_mul_of_nonpos_left (Real.sqrt_le_sqrt hBeta) hScore

noncomputable def twoRouteWelfare
    (lowReward highReward beta score : Real) : Real :=
  lowReward + correctRouteProbability beta score *
    (highReward - lowReward)

theorem twoRouteWelfare_mono_of_score_nonneg
    {lowReward highReward betaLow betaHigh score : Real}
    (hReward : lowReward <= highReward)
    (hBeta : betaLow <= betaHigh) (hScore : 0 <= score) :
    twoRouteWelfare lowReward highReward betaLow score <=
      twoRouteWelfare lowReward highReward betaHigh score := by
  have hProbability :=
    correctRouteProbability_mono_of_score_nonneg hBeta hScore
  unfold twoRouteWelfare
  nlinarith

theorem twoRouteWelfare_antitone_of_score_nonpos
    {lowReward highReward betaLow betaHigh score : Real}
    (hReward : lowReward <= highReward)
    (hBeta : betaLow <= betaHigh) (hScore : score <= 0) :
    twoRouteWelfare lowReward highReward betaHigh score <=
      twoRouteWelfare lowReward highReward betaLow score := by
  have hProbability :=
    correctRouteProbability_antitone_of_score_nonpos hBeta hScore
  unfold twoRouteWelfare
  nlinarith

theorem threshold_welfare_regimes
    {priorGap trueGap kappaStar lowReward highReward : Real}
    (hThreshold : IsThreshold priorGap trueGap kappaStar)
    (hReward : lowReward <= highReward) :
    (forall kappa, kappa < kappaStar ->
      forall betaLow betaHigh, betaLow <= betaHigh ->
        twoRouteWelfare lowReward highReward betaHigh
            (interpolatedScore priorGap trueGap kappa) <=
          twoRouteWelfare lowReward highReward betaLow
            (interpolatedScore priorGap trueGap kappa)) /\
    (forall kappa, kappaStar < kappa ->
      forall betaLow betaHigh, betaLow <= betaHigh ->
        twoRouteWelfare lowReward highReward betaLow
            (interpolatedScore priorGap trueGap kappa) <=
          twoRouteWelfare lowReward highReward betaHigh
            (interpolatedScore priorGap trueGap kappa)) := by
  constructor
  · intro kappa hKappa betaLow betaHigh hBeta
    exact twoRouteWelfare_antitone_of_score_nonpos hReward hBeta
      (hThreshold.2.2.1 kappa hKappa).le
  · intro kappa hKappa betaLow betaHigh hBeta
    exact twoRouteWelfare_mono_of_score_nonneg hReward hBeta
      (hThreshold.2.2.2 kappa hKappa).le

noncomputable def topologyNoiseAtDepth
    (depth : Nat) (kappa : Real) : Real :=
  (depth : Real) ^ 2 / ((2 : Real) ^ (2 * kappa) - 1)

theorem topologyNoiseAtDepth_kappaStarClosedForm
    (c : Real) (hC : 0 < c) (depth : Nat) (hDepth : 0 < depth) :
    topologyNoiseAtDepth depth
        (Infrastructure.kappaStarClosedForm c depth) = c := by
  have hInnerPositive :
      0 < ((depth : Real) ^ 2) / c + 1 := by positivity
  have hExponent :
      2 * Infrastructure.kappaStarClosedForm c depth =
        Real.logb 2 (((depth : Real) ^ 2) / c + 1) := by
    unfold Infrastructure.kappaStarClosedForm
    ring
  have hRpow :
      (2 : Real) ^
          (2 * Infrastructure.kappaStarClosedForm c depth) =
        ((depth : Real) ^ 2) / c + 1 := by
    rw [hExponent]
    exact Real.rpow_logb (by norm_num) (by norm_num) hInnerPositive
  have hDepthCast : (depth : Real) ≠ 0 := by
    exact_mod_cast (Nat.ne_of_gt hDepth)
  unfold topologyNoiseAtDepth
  rw [hRpow]
  field_simp
  ring

/-- Correct lattice quantifier order: for each finite target, a fixed depth
witness is selected first; its occurrence probability then tends to one with
torus side length. -/
theorem latticeThreshold_unboundedInProbability_of_closedForm_witness
    (c : Real) (hC : 0 < c)
    (tailProbability : Nat -> Real -> Real)
    (depthEventProbability : Nat -> Nat -> Real)
    (hUpper : forall side bound, tailProbability side bound <= 1)
    (hDepthEvent : forall depth,
      Tendsto (depthEventProbability depth) atTop (nhds 1))
    (hDominates : forall depth side bound,
      bound < Infrastructure.kappaStarClosedForm c depth ->
      depthEventProbability depth side <= tailProbability side bound) :
    Infrastructure.UnboundedInProbability tailProbability := by
  exact Infrastructure.unboundedInProbability_of_depth_witness
    tailProbability (Infrastructure.kappaStarClosedForm c)
    depthEventProbability hUpper
    (Infrastructure.kappaStarClosedForm_cofinal c hC)
    hDepthEvent hDominates

def ClosedFormLatticeTransferClaim : Prop :=
  forall c : Real, 0 < c ->
    forall tailProbability : Nat -> Real -> Real,
    forall depthEventProbability : Nat -> Nat -> Real,
      (forall side bound, tailProbability side bound <= 1) ->
      (forall depth,
        Tendsto (depthEventProbability depth) atTop (nhds 1)) ->
      (forall depth side bound,
        bound < Infrastructure.kappaStarClosedForm c depth ->
        depthEventProbability depth side <= tailProbability side bound) ->
      Infrastructure.UnboundedInProbability tailProbability

theorem closedFormLatticeTransferClaim_proved :
    ClosedFormLatticeTransferClaim := by
  intro c hC tailProbability depthEventProbability
    hUpper hDepthEvent hDominates
  exact latticeThreshold_unboundedInProbability_of_closedForm_witness
    c hC tailProbability depthEventProbability
    hUpper hDepthEvent hDominates

def CognitiveThresholdClaim : Prop :=
  (forall priorGap trueGap : Real,
    priorGap < 0 -> 0 < trueGap ->
      ∃! kappaStar : Real,
        IsThreshold priorGap trueGap kappaStar) /\
  (forall priorGap trueGap kappaStar lowReward highReward : Real,
    IsThreshold priorGap trueGap kappaStar ->
    lowReward <= highReward ->
      (forall kappa, kappa < kappaStar ->
        forall betaLow betaHigh, betaLow <= betaHigh ->
          twoRouteWelfare lowReward highReward betaHigh
              (interpolatedScore priorGap trueGap kappa) <=
            twoRouteWelfare lowReward highReward betaLow
              (interpolatedScore priorGap trueGap kappa)) /\
      (forall kappa, kappaStar < kappa ->
        forall betaLow betaHigh, betaLow <= betaHigh ->
          twoRouteWelfare lowReward highReward betaLow
              (interpolatedScore priorGap trueGap kappa) <=
            twoRouteWelfare lowReward highReward betaHigh
              (interpolatedScore priorGap trueGap kappa))) /\
  Infrastructure.KappaStarClosedFormDivergencePrinciple /\
  Infrastructure.KappaStarClosedFormBoundsPrinciple /\
  (forall c : Real, 0 < c -> forall depth : Nat, 0 < depth ->
    topologyNoiseAtDepth depth
      (Infrastructure.kappaStarClosedForm c depth) = c) /\
  Infrastructure.Part6FiniteTorusSupportKernelBundle /\
  ClosedFormLatticeTransferClaim

theorem cognitiveThresholdClaim_proved : CognitiveThresholdClaim := by
  exact ⟨
    (fun _ _ hPrior hTrue => exists_unique_threshold hPrior hTrue),
    (fun _ _ _ _ _ hThreshold hReward =>
      threshold_welfare_regimes hThreshold hReward),
    Infrastructure.kappaStarClosedFormDivergencePrinciple_proved,
    Infrastructure.kappaStarClosedFormBoundsPrinciple_proved,
    topologyNoiseAtDepth_kappaStarClosedForm,
    Infrastructure.part6FiniteTorusSupportKernelBundle_proved,
    closedFormLatticeTransferClaim_proved⟩

end BlackwellDilemma.CognitiveThreshold
