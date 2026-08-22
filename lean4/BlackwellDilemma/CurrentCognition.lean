/- Exact current-paper cognition threshold and strict welfare regimes. -/

import BlackwellDilemma.UnifiedSupermodularCognition
import Mathlib.Analysis.Calculus.Deriv.MeanValue

namespace BlackwellDilemma.CurrentCognition

open Set
open BlackwellDilemma.CognitiveThreshold
open BlackwellDilemma.FiveStateCognition
open BlackwellDilemma.SupermodularCognition

noncomputable def kappaStar (m0 mInf : Real) : Real :=
  Real.logb 2 ((mInf - m0) / mInf)

theorem kappaStar_pos {m0 mInf : Real} (hM0 : m0 < 0) (hMInf : 0 < mInf) :
    0 < kappaStar m0 mInf := by
  apply Real.logb_pos (by norm_num : (1 : Real) < 2)
  have hDenom : 0 < mInf := hMInf
  apply (lt_div_iff₀ hDenom).2
  linarith

theorem interpolatedScore_kappaStar
    {m0 mInf : Real} (hM0 : m0 < 0) (hMInf : 0 < mInf) :
    interpolatedScore m0 mInf (kappaStar m0 mInf) = 0 := by
  have hRatioPos : 0 < (mInf - m0) / mInf :=
    div_pos (sub_pos.mpr (hM0.trans hMInf)) hMInf
  have hPow :
      (2 : Real) ^ kappaStar m0 mInf = (mInf - m0) / mInf := by
    unfold kappaStar
    exact Real.rpow_logb (by norm_num) (by norm_num) hRatioPos
  have hHalf :
      (1 / 2 : Real) ^ kappaStar m0 mInf = mInf / (mInf - m0) := by
    rw [Real.div_rpow (by norm_num) (by norm_num), Real.one_rpow, hPow]
    field_simp [hMInf.ne', (sub_pos.mpr (hM0.trans hMInf)).ne']
  unfold interpolatedScore revealProbability
  rw [hHalf]
  field_simp [hMInf.ne', (sub_pos.mpr (hM0.trans hMInf)).ne']
  ring

theorem kappaStar_isThreshold
    {m0 mInf : Real} (hM0 : m0 < 0) (hMInf : 0 < mInf) :
    IsThreshold m0 mInf (kappaStar m0 mInf) := by
  have hStrict : StrictMono (interpolatedScore m0 mInf) :=
    interpolatedScore_strictMono (hM0.trans hMInf)
  have hRoot := interpolatedScore_kappaStar hM0 hMInf
  refine ⟨kappaStar_pos hM0 hMInf, hRoot, ?_, ?_⟩
  · intro kappa hKappa
    simpa [hRoot] using hStrict hKappa
  · intro kappa hKappa
    simpa [hRoot] using hStrict hKappa

theorem signalScale_strictMonoOn :
    StrictMonoOn signalScale (Set.Ioi 0) := by
  apply strictMonoOn_of_deriv_pos (convex_Ioi 0)
  · intro beta hBeta
    exact (signalScale_hasDerivAt hBeta).continuousAt.continuousWithinAt
  · intro beta hBeta
    have hBetaPos : 0 < beta := by simpa using hBeta
    rw [(signalScale_hasDerivAt hBetaPos).deriv]
    exact signalScaleDerivative_pos hBetaPos

theorem welfare_strictAntiOn_of_score_neg
    {m0 mInf lowReward highReward kappa : Real}
    (hReward : lowReward < highReward)
    (hScore : interpolatedScore m0 mInf kappa < 0) :
    StrictAntiOn
      (fun beta => scaledTwoRouteWelfare
        m0 mInf lowReward highReward beta kappa)
      (Set.Ioi 0) := by
  intro betaLow hLow betaHigh hHigh hBeta
  have hScale := signalScale_strictMonoOn hLow hHigh hBeta
  have hZ :
      zScore m0 mInf betaHigh kappa < zScore m0 mInf betaLow kappa := by
    unfold zScore
    exact mul_lt_mul_of_neg_right hScale hScore
  have hPhi := Phi_strictMono hZ
  unfold scaledTwoRouteWelfare
  nlinarith

theorem welfare_strictMonoOn_of_score_pos
    {m0 mInf lowReward highReward kappa : Real}
    (hReward : lowReward < highReward)
    (hScore : 0 < interpolatedScore m0 mInf kappa) :
    StrictMonoOn
      (fun beta => scaledTwoRouteWelfare
        m0 mInf lowReward highReward beta kappa)
      (Set.Ioi 0) := by
  intro betaLow hLow betaHigh hHigh hBeta
  have hScale := signalScale_strictMonoOn hLow hHigh hBeta
  have hZ :
      zScore m0 mInf betaLow kappa < zScore m0 mInf betaHigh kappa := by
    unfold zScore
    exact mul_lt_mul_of_pos_right hScale hScore
  have hPhi := Phi_strictMono hZ
  unfold scaledTwoRouteWelfare
  nlinarith

theorem welfare_at_kappaStar_independent
    {m0 mInf lowReward highReward : Real}
    (hM0 : m0 < 0) (hMInf : 0 < mInf) :
    forall beta : Real,
      scaledTwoRouteWelfare m0 mInf lowReward highReward beta
          (kappaStar m0 mInf) =
        lowReward + (highReward - lowReward) * Phi 0 := by
  intro beta
  have hRoot := interpolatedScore_kappaStar hM0 hMInf
  simp [scaledTwoRouteWelfare, zScore, hRoot]

def CognitiveThresholdClaim : Prop :=
  forall m0 mInf lowReward highReward : Real,
    m0 < 0 -> 0 < mInf -> lowReward < highReward ->
      let kStar := kappaStar m0 mInf
      IsThreshold m0 mInf kStar /\
      (forall kappa, kappa < kStar ->
        StrictAntiOn
          (fun beta => scaledTwoRouteWelfare
            m0 mInf lowReward highReward beta kappa)
          (Set.Ioi 0)) /\
      (forall beta,
        scaledTwoRouteWelfare m0 mInf lowReward highReward beta kStar =
          lowReward + (highReward - lowReward) * Phi 0) /\
      (forall kappa, kStar < kappa ->
        StrictMonoOn
          (fun beta => scaledTwoRouteWelfare
            m0 mInf lowReward highReward beta kappa)
          (Set.Ioi 0))

theorem cognitiveThresholdClaim_proved : CognitiveThresholdClaim := by
  intro m0 mInf lowReward highReward hM0 hMInf hReward
  let kStar := kappaStar m0 mInf
  have hThreshold : IsThreshold m0 mInf kStar :=
    kappaStar_isThreshold hM0 hMInf
  refine ⟨hThreshold, ?_, ?_, ?_⟩
  · intro kappa hKappa
    exact welfare_strictAntiOn_of_score_neg hReward
      (hThreshold.2.2.1 kappa hKappa)
  · exact welfare_at_kappaStar_independent hM0 hMInf
  · intro kappa hKappa
    exact welfare_strictMonoOn_of_score_pos hReward
      (hThreshold.2.2.2 kappa hKappa)

end BlackwellDilemma.CurrentCognition
