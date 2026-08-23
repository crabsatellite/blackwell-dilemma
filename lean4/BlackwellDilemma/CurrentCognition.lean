/- Exact current-paper continuous cognition-weight model. -/

import BlackwellDilemma.CurrentGaussian
import Mathlib.Analysis.SpecialFunctions.Log.Base

namespace BlackwellDilemma.CurrentCognition

open Filter Set Topology
open BlackwellDilemma.CurrentGaussian

noncomputable def assimilationWeight (kappa : Real) : Real :=
  1 - (1 / 2 : Real) ^ kappa

noncomputable def representedScore (m0 mInf kappa : Real) : Real :=
  m0 + assimilationWeight kappa * (mInf - m0)

noncomputable def cognitionIndex (m0 mInf beta kappa : Real) : Real :=
  precisionScale beta * representedScore m0 mInf kappa

noncomputable def cognitionWelfare
    (m0 mInf lowReward highReward beta kappa : Real) : Real :=
  lowReward + (highReward - lowReward) *
    Phi (cognitionIndex m0 mInf beta kappa)

noncomputable def kappaStar (m0 mInf : Real) : Real :=
  Real.logb 2 ((mInf - m0) / mInf)

theorem assimilationWeight_zero : assimilationWeight 0 = 0 := by
  simp [assimilationWeight]

theorem assimilationWeight_strictMono : StrictMono assimilationWeight := by
  intro kappaLow kappaHigh hKappa
  have hPow :
      (1 / 2 : Real) ^ kappaHigh < (1 / 2 : Real) ^ kappaLow :=
    (Real.strictAnti_rpow_of_base_lt_one
      (by norm_num : (0 : Real) < 1 / 2)
      (by norm_num : (1 / 2 : Real) < 1)) hKappa
  unfold assimilationWeight
  linarith

theorem representedScore_strictMono
    {m0 mInf : Real} (hGap : m0 < mInf) :
    StrictMono (representedScore m0 mInf) := by
  intro kappaLow kappaHigh hKappa
  have hWeight := assimilationWeight_strictMono hKappa
  unfold representedScore
  nlinarith

theorem kappaStar_pos {m0 mInf : Real} (hM0 : m0 < 0) (hMInf : 0 < mInf) :
    0 < kappaStar m0 mInf := by
  apply Real.logb_pos (by norm_num : (1 : Real) < 2)
  apply (lt_div_iff₀ hMInf).2
  linarith

theorem representedScore_kappaStar
    {m0 mInf : Real} (hM0 : m0 < 0) (hMInf : 0 < mInf) :
    representedScore m0 mInf (kappaStar m0 mInf) = 0 := by
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
  unfold representedScore assimilationWeight
  rw [hHalf]
  field_simp [hMInf.ne', (sub_pos.mpr (hM0.trans hMInf)).ne']
  ring

def IsThreshold (m0 mInf kStar : Real) : Prop :=
  0 < kStar /\
    representedScore m0 mInf kStar = 0 /\
    (forall kappa, kappa < kStar -> representedScore m0 mInf kappa < 0) /\
    (forall kappa, kStar < kappa -> 0 < representedScore m0 mInf kappa)

theorem kappaStar_isThreshold
    {m0 mInf : Real} (hM0 : m0 < 0) (hMInf : 0 < mInf) :
    IsThreshold m0 mInf (kappaStar m0 mInf) := by
  have hStrict : StrictMono (representedScore m0 mInf) :=
    representedScore_strictMono (hM0.trans hMInf)
  have hRoot := representedScore_kappaStar hM0 hMInf
  refine ⟨kappaStar_pos hM0 hMInf, hRoot, ?_, ?_⟩
  · intro kappa hKappa
    simpa [hRoot] using hStrict hKappa
  · intro kappa hKappa
    simpa [hRoot] using hStrict hKappa

theorem cognitionWelfare_strictAntiOn_of_score_neg
    {m0 mInf lowReward highReward kappa : Real}
    (hReward : lowReward < highReward)
    (hScore : representedScore m0 mInf kappa < 0) :
    StrictAntiOn
      (fun beta => cognitionWelfare
        m0 mInf lowReward highReward beta kappa)
      (Set.Ioi 0) := by
  intro betaLow hLow betaHigh hHigh hBeta
  have hScale := precisionScale_strictMonoOn hLow hHigh hBeta
  have hIndex :
      cognitionIndex m0 mInf betaHigh kappa <
        cognitionIndex m0 mInf betaLow kappa := by
    unfold cognitionIndex
    exact mul_lt_mul_of_neg_right hScale hScore
  have hPhi := Phi_strictMono hIndex
  unfold cognitionWelfare
  nlinarith

theorem cognitionWelfare_strictMonoOn_of_score_pos
    {m0 mInf lowReward highReward kappa : Real}
    (hReward : lowReward < highReward)
    (hScore : 0 < representedScore m0 mInf kappa) :
    StrictMonoOn
      (fun beta => cognitionWelfare
        m0 mInf lowReward highReward beta kappa)
      (Set.Ioi 0) := by
  intro betaLow hLow betaHigh hHigh hBeta
  have hScale := precisionScale_strictMonoOn hLow hHigh hBeta
  have hIndex :
      cognitionIndex m0 mInf betaLow kappa <
        cognitionIndex m0 mInf betaHigh kappa := by
    unfold cognitionIndex
    exact mul_lt_mul_of_pos_right hScale hScore
  have hPhi := Phi_strictMono hIndex
  unfold cognitionWelfare
  nlinarith

theorem cognitionWelfare_at_kappaStar
    {m0 mInf lowReward highReward : Real}
    (hM0 : m0 < 0) (hMInf : 0 < mInf) :
    forall beta : Real,
      cognitionWelfare m0 mInf lowReward highReward beta
          (kappaStar m0 mInf) =
        lowReward + (highReward - lowReward) * Phi 0 := by
  intro beta
  have hRoot := representedScore_kappaStar hM0 hMInf
  simp [cognitionWelfare, cognitionIndex, hRoot]

def CognitiveThresholdClaim : Prop :=
  forall m0 mInf lowReward highReward : Real,
    m0 < 0 -> 0 < mInf -> lowReward < highReward ->
      let kStar := kappaStar m0 mInf
      IsThreshold m0 mInf kStar /\
      (forall kappa, 0 <= kappa -> kappa < kStar ->
        StrictAntiOn
          (fun beta => cognitionWelfare
            m0 mInf lowReward highReward beta kappa)
          (Set.Ioi 0)) /\
      (forall beta,
        cognitionWelfare m0 mInf lowReward highReward beta kStar =
          lowReward + (highReward - lowReward) * Phi 0) /\
      (forall kappa, kStar < kappa ->
        StrictMonoOn
          (fun beta => cognitionWelfare
            m0 mInf lowReward highReward beta kappa)
          (Set.Ioi 0))

theorem cognitiveThresholdClaim_proved : CognitiveThresholdClaim := by
  intro m0 mInf lowReward highReward hM0 hMInf hReward
  let kStar := kappaStar m0 mInf
  have hThreshold : IsThreshold m0 mInf kStar :=
    kappaStar_isThreshold hM0 hMInf
  refine ⟨hThreshold, ?_, ?_, ?_⟩
  · intro kappa _hKappaNonneg hKappa
    exact cognitionWelfare_strictAntiOn_of_score_neg hReward
      (hThreshold.2.2.1 kappa hKappa)
  · exact cognitionWelfare_at_kappaStar hM0 hMInf
  · intro kappa hKappa
    exact cognitionWelfare_strictMonoOn_of_score_pos hReward
      (hThreshold.2.2.2 kappa hKappa)

end BlackwellDilemma.CurrentCognition
