/- Exact differential complementarity result for the current cognition model. -/

import BlackwellDilemma.CurrentCognition

namespace BlackwellDilemma.CurrentComplementarity

open BlackwellDilemma.CurrentCognition
open BlackwellDilemma.CurrentGaussian

noncomputable def assimilationDerivative (kappa : Real) : Real :=
  -(Real.log (1 / 2) * (1 / 2 : Real) ^ kappa)

noncomputable def representedScoreDerivative
    (m0 mInf kappa : Real) : Real :=
  assimilationDerivative kappa * (mInf - m0)

noncomputable abbrev precisionScaleDerivative :=
  BlackwellDilemma.CurrentGaussian.precisionScaleDerivative

noncomputable def cognitionMarginal
    (m0 mInf lowReward highReward beta kappa : Real) : Real :=
  ((highReward - lowReward) *
    (phi (cognitionIndex m0 mInf beta kappa) * precisionScale beta)) *
      representedScoreDerivative m0 mInf kappa

noncomputable def mixedCrossPartial
    (m0 mInf lowReward highReward beta kappa : Real) : Real :=
  (highReward - lowReward) * representedScoreDerivative m0 mInf kappa *
    precisionScaleDerivative beta * phi (cognitionIndex m0 mInf beta kappa) *
    (1 - cognitionIndex m0 mInf beta kappa ^ 2)

theorem assimilationWeight_hasDerivAt (kappa : Real) :
    HasDerivAt assimilationWeight (assimilationDerivative kappa) kappa := by
  have hPow :
      HasDerivAt (fun x : Real => (1 / 2 : Real) ^ x)
        (Real.log (1 / 2) * (1 / 2 : Real) ^ kappa) kappa := by
    simpa using
      (hasDerivAt_id kappa).const_rpow (by norm_num : (0 : Real) < 1 / 2)
  convert (hasDerivAt_const kappa (1 : Real)).sub hPow using 1
  unfold assimilationDerivative
  ring

theorem assimilationDerivative_pos (kappa : Real) :
    0 < assimilationDerivative kappa := by
  have hLog : Real.log (1 / 2) < 0 :=
    Real.log_neg (by norm_num) (by norm_num)
  have hPow : 0 < (1 / 2 : Real) ^ kappa :=
    Real.rpow_pos_of_pos (by norm_num) _
  unfold assimilationDerivative
  exact neg_pos.mpr (mul_neg_of_neg_of_pos hLog hPow)

theorem representedScore_hasDerivAt (m0 mInf kappa : Real) :
    HasDerivAt (representedScore m0 mInf)
      (representedScoreDerivative m0 mInf kappa) kappa := by
  have hScaled :=
    (assimilationWeight_hasDerivAt kappa).mul_const (mInf - m0)
  exact hScaled.const_add m0

theorem representedScoreDerivative_pos
    {m0 mInf kappa : Real} (hGap : m0 < mInf) :
    0 < representedScoreDerivative m0 mInf kappa := by
  unfold representedScoreDerivative
  exact mul_pos (assimilationDerivative_pos kappa) (sub_pos.mpr hGap)

theorem cognitionWelfare_hasDerivAt_kappa
    (m0 mInf lowReward highReward beta kappa : Real) :
    HasDerivAt
      (fun kappa' => cognitionWelfare
        m0 mInf lowReward highReward beta kappa')
      (cognitionMarginal m0 mInf lowReward highReward beta kappa) kappa := by
  have hScore := representedScore_hasDerivAt m0 mInf kappa
  have hIndex := hScore.const_mul (precisionScale beta)
  have hPhi := (Phi_hasDerivAt (cognitionIndex m0 mInf beta kappa)).comp
    kappa hIndex
  have hScaled := hPhi.const_mul (highReward - lowReward)
  have hShifted := hScaled.const_add lowReward
  convert hShifted using 1
  simp [cognitionMarginal, cognitionIndex]
  ring

theorem cognitionMarginal_hasDerivAt_beta
    {m0 mInf lowReward highReward beta kappa : Real}
    (hBeta : 0 < beta) :
    HasDerivAt
      (fun beta' => cognitionMarginal
        m0 mInf lowReward highReward beta' kappa)
      (mixedCrossPartial m0 mInf lowReward highReward beta kappa) beta := by
  have hScale := precisionScale_hasDerivAt hBeta
  have hIndex := hScale.mul_const (representedScore m0 mInf kappa)
  have hPhi := (phi_hasDerivAt (cognitionIndex m0 mInf beta kappa)).comp
    beta hIndex
  have hProduct := hPhi.mul hScale
  have hRewardScaled := hProduct.const_mul (highReward - lowReward)
  have hScoreScaled :=
    hRewardScaled.mul_const (representedScoreDerivative m0 mInf kappa)
  convert hScoreScaled using 1
  simp [mixedCrossPartial, cognitionIndex, Function.comp_apply]
  ring

theorem mixedCrossPartial_pos
    {m0 mInf lowReward highReward beta kappa : Real}
    (hGap : m0 < mInf) (hReward : lowReward < highReward)
    (hBeta : 0 < beta)
    (hModerate : |cognitionIndex m0 mInf beta kappa| < 1) :
    0 < mixedCrossPartial m0 mInf lowReward highReward beta kappa := by
  have hScore := representedScoreDerivative_pos (kappa := kappa) hGap
  have hScale := precisionScaleDerivative_pos hBeta
  have hDensity := phi_pos (cognitionIndex m0 mInf beta kappa)
  have hUnit : 0 < 1 - cognitionIndex m0 mInf beta kappa ^ 2 := by
    rcases abs_lt.mp hModerate with ⟨hLow, hHigh⟩
    nlinarith
  unfold mixedCrossPartial
  positivity

def LocalComplementarityClaim : Prop :=
  forall m0 mInf lowReward highReward beta kappa : Real,
    m0 < mInf -> lowReward < highReward -> 0 < beta ->
    |cognitionIndex m0 mInf beta kappa| < 1 ->
      HasDerivAt
        (fun kappa' => cognitionWelfare
          m0 mInf lowReward highReward beta kappa')
        (cognitionMarginal m0 mInf lowReward highReward beta kappa) kappa /\
      HasDerivAt
        (fun beta' => cognitionMarginal
          m0 mInf lowReward highReward beta' kappa)
        (mixedCrossPartial m0 mInf lowReward highReward beta kappa) beta /\
      0 < mixedCrossPartial m0 mInf lowReward highReward beta kappa

theorem localComplementarityClaim_proved : LocalComplementarityClaim := by
  intro m0 mInf lowReward highReward beta kappa
    hGap hReward hBeta hModerate
  exact ⟨cognitionWelfare_hasDerivAt_kappa _ _ _ _ _ _,
    cognitionMarginal_hasDerivAt_beta hBeta,
    mixedCrossPartial_pos hGap hReward hBeta hModerate⟩

end BlackwellDilemma.CurrentComplementarity
