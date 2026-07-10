/-
  BlackwellDilemma/UnifiedSupermodularCognition.lean

  Exact mixed-partial calculation for the repaired two-route cognition
  experiment. The score is state-conditioned, and beta enters through the
  inverse effective Gaussian noise from the manuscript's variance model.
-/

import BlackwellDilemma.UnifiedCognitiveThreshold
import BlackwellDilemma.Infrastructure.TopkisCrossPartialCriterion

namespace BlackwellDilemma.SupermodularCognition

open BlackwellDilemma.CognitiveThreshold
open BlackwellDilemma.FiveStateCognition

/-- Inverse effective standard deviation for the difference of two
independent reward signals with variance `(2^(2 * beta) - 1)⁻¹`. -/
noncomputable def signalScale (beta : Real) : Real :=
  Real.sqrt (((2 : Real) ^ (2 * beta) - 1) / 2)

noncomputable def signalScaleDerivative (beta : Real) : Real :=
  ((2 : Real) ^ (2 * beta) * Real.log 2) /
    (2 * signalScale beta)

theorem two_rpow_two_beta_hasDerivAt (beta : Real) :
    HasDerivAt (fun beta' : Real => (2 : Real) ^ (2 * beta'))
      ((2 : Real) ^ (2 * beta) * Real.log 2 * 2) beta := by
  have hInner : HasDerivAt (fun beta' : Real => 2 * beta') 2 beta := by
    simpa using (hasDerivAt_id beta).const_mul (2 : Real)
  have hOuter : HasDerivAt (fun exponent : Real => (2 : Real) ^ exponent)
      ((2 : Real) ^ (2 * beta) * Real.log 2) (2 * beta) :=
    (Real.hasStrictDerivAt_const_rpow (by norm_num) (2 * beta)).hasDerivAt
  exact hOuter.comp beta hInner

theorem signalScale_pos {beta : Real} (hBeta : 0 < beta) :
    0 < signalScale beta := by
  have hExponent : 0 < 2 * beta := by linarith
  have hPow : (1 : Real) < (2 : Real) ^ (2 * beta) :=
    Real.one_lt_rpow (by norm_num) hExponent
  unfold signalScale
  exact Real.sqrt_pos.mpr (by linarith)

theorem signalScale_hasDerivAt {beta : Real} (hBeta : 0 < beta) :
    HasDerivAt signalScale (signalScaleDerivative beta) beta := by
  have hInner :
      HasDerivAt
        (fun beta' : Real =>
          (((2 : Real) ^ (2 * beta') - 1) / 2))
        ((2 : Real) ^ (2 * beta) * Real.log 2) beta := by
    convert
      ((two_rpow_two_beta_hasDerivAt beta).sub_const 1).div_const 2 using 1
    ring
  have hInnerPos :
      0 < (((2 : Real) ^ (2 * beta) - 1) / 2) := by
    have hExponent : 0 < 2 * beta := by linarith
    have hPow : (1 : Real) < (2 : Real) ^ (2 * beta) :=
      Real.one_lt_rpow (by norm_num) hExponent
    linarith
  have hSqrt := hInner.sqrt hInnerPos.ne'
  change HasDerivAt
    (fun beta' : Real =>
      Real.sqrt (((2 : Real) ^ (2 * beta') - 1) / 2))
    (((2 : Real) ^ (2 * beta) * Real.log 2) /
      (2 * Real.sqrt (((2 : Real) ^ (2 * beta) - 1) / 2))) beta
  exact hSqrt

theorem signalScaleDerivative_pos {beta : Real} (hBeta : 0 < beta) :
    0 < signalScaleDerivative beta := by
  have hPow : 0 < (2 : Real) ^ (2 * beta) :=
    Real.rpow_pos_of_pos (by norm_num) _
  have hLog : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hScale := signalScale_pos hBeta
  unfold signalScaleDerivative
  positivity

noncomputable def revealDerivative (kappa : Real) : Real :=
  -(Real.log (1 / 2) * (1 / 2 : Real) ^ kappa)

theorem revealProbability_hasDerivAt (kappa : Real) :
    HasDerivAt revealProbability (revealDerivative kappa) kappa := by
  have hPow :
      HasDerivAt (fun kappa' : Real => (1 / 2 : Real) ^ kappa')
        (Real.log (1 / 2) * (1 / 2 : Real) ^ kappa) kappa := by
    simpa using
      (hasDerivAt_id kappa).const_rpow
        (by norm_num : (0 : Real) < 1 / 2)
  have hSub := (hasDerivAt_const kappa (1 : Real)).sub hPow
  change HasDerivAt
    (fun kappa' : Real => 1 - (1 / 2 : Real) ^ kappa')
    (-(Real.log (1 / 2) * (1 / 2 : Real) ^ kappa)) kappa
  convert hSub using 1
  ring

theorem revealDerivative_pos (kappa : Real) :
    0 < revealDerivative kappa := by
  have hLog : Real.log (1 / 2) < 0 :=
    Real.log_neg (by norm_num) (by norm_num)
  have hPow : 0 < (1 / 2 : Real) ^ kappa :=
    Real.rpow_pos_of_pos (by norm_num) _
  unfold revealDerivative
  exact neg_pos.mpr (mul_neg_of_neg_of_pos hLog hPow)

noncomputable def scoreDerivative
    (priorGap trueGap kappa : Real) : Real :=
  revealDerivative kappa * (trueGap - priorGap)

theorem interpolatedScore_hasDerivAt
    (priorGap trueGap kappa : Real) :
    HasDerivAt (interpolatedScore priorGap trueGap)
      (scoreDerivative priorGap trueGap kappa) kappa := by
  have hReveal := revealProbability_hasDerivAt kappa
  have hScaled := hReveal.mul_const (trueGap - priorGap)
  have hShifted := hScaled.const_add priorGap
  change HasDerivAt
    (fun kappa' => priorGap +
      revealProbability kappa' * (trueGap - priorGap))
    (revealDerivative kappa * (trueGap - priorGap)) kappa
  exact hShifted

theorem scoreDerivative_pos
    {priorGap trueGap kappa : Real} (hGap : priorGap < trueGap) :
    0 < scoreDerivative priorGap trueGap kappa := by
  unfold scoreDerivative
  exact mul_pos (revealDerivative_pos kappa) (sub_pos.mpr hGap)

noncomputable def zScore
    (priorGap trueGap beta kappa : Real) : Real :=
  signalScale beta * interpolatedScore priorGap trueGap kappa

noncomputable def scaledTwoRouteWelfare
    (priorGap trueGap lowReward highReward beta kappa : Real) : Real :=
  lowReward + (highReward - lowReward) *
    Phi (zScore priorGap trueGap beta kappa)

noncomputable def cognitionMarginal
    (priorGap trueGap lowReward highReward beta kappa : Real) : Real :=
  ((highReward - lowReward) *
    (phi (zScore priorGap trueGap beta kappa) * signalScale beta)) *
      scoreDerivative priorGap trueGap kappa

theorem scaledTwoRouteWelfare_hasDerivAt_kappa
    (priorGap trueGap lowReward highReward beta kappa : Real) :
    HasDerivAt
      (fun kappa' => scaledTwoRouteWelfare
        priorGap trueGap lowReward highReward beta kappa')
      (cognitionMarginal
        priorGap trueGap lowReward highReward beta kappa) kappa := by
  have hScore := interpolatedScore_hasDerivAt priorGap trueGap kappa
  have hZ := hScore.const_mul (signalScale beta)
  have hPhi :=
    (gap_Phi_derivative (zScore priorGap trueGap beta kappa)).comp
      kappa hZ
  have hScaled := hPhi.const_mul (highReward - lowReward)
  have hShifted := hScaled.const_add lowReward
  convert hShifted using 1
  simp only [cognitionMarginal, zScore]
  ring

noncomputable def mixedDerivativeValue
    (priorGap trueGap lowReward highReward beta kappa : Real) : Real :=
  (highReward - lowReward) * scoreDerivative priorGap trueGap kappa *
    signalScaleDerivative beta * phi (zScore priorGap trueGap beta kappa) *
    (1 - zScore priorGap trueGap beta kappa ^ 2)

theorem cognitionMarginal_hasDerivAt_beta
    {priorGap trueGap lowReward highReward beta kappa : Real}
    (hBeta : 0 < beta) :
    HasDerivAt
      (fun beta' => cognitionMarginal
        priorGap trueGap lowReward highReward beta' kappa)
      (mixedDerivativeValue
        priorGap trueGap lowReward highReward beta kappa) beta := by
  have hScale := signalScale_hasDerivAt hBeta
  have hZ := hScale.mul_const (interpolatedScore priorGap trueGap kappa)
  have hPhi :=
    (gap_phi_derivative (zScore priorGap trueGap beta kappa)).comp
      beta hZ
  have hProduct := hPhi.mul hScale
  have hRewardScaled := hProduct.const_mul (highReward - lowReward)
  have hScoreScaled :=
    hRewardScaled.mul_const (scoreDerivative priorGap trueGap kappa)
  convert hScoreScaled using 1
  simp only [mixedDerivativeValue, zScore, Function.comp_apply]
  ring

theorem phi_strictly_pos (z : Real) : 0 < phi z := by
  unfold phi
  have hSqrt : 0 < Real.sqrt (2 * Real.pi) :=
    Real.sqrt_pos.mpr (by positivity)
  positivity

theorem mixedDerivativeValue_pos
    {priorGap trueGap lowReward highReward beta kappa : Real}
    (hGap : priorGap < trueGap) (hReward : lowReward < highReward)
    (hBeta : 0 < beta)
    (hModerate : |zScore priorGap trueGap beta kappa| < 1) :
    0 < mixedDerivativeValue
      priorGap trueGap lowReward highReward beta kappa := by
  have hScore := scoreDerivative_pos
    (priorGap := priorGap) (trueGap := trueGap) (kappa := kappa) hGap
  have hScale := signalScaleDerivative_pos hBeta
  have hPhi : 0 < phi (zScore priorGap trueGap beta kappa) :=
    phi_strictly_pos _
  have hUnit : 0 < 1 - zScore priorGap trueGap beta kappa ^ 2 := by
    rcases abs_lt.mp hModerate with ⟨hLow, hHigh⟩
    nlinarith
  unfold mixedDerivativeValue
  positivity

def SupermodularCognitionClaim : Prop :=
  forall priorGap trueGap lowReward highReward beta kappa : Real,
    priorGap < trueGap ->
    lowReward < highReward ->
    0 < beta ->
    |zScore priorGap trueGap beta kappa| < 1 ->
      HasDerivAt
        (fun kappa' => scaledTwoRouteWelfare
          priorGap trueGap lowReward highReward beta kappa')
        (cognitionMarginal
          priorGap trueGap lowReward highReward beta kappa) kappa /\
      HasDerivAt
        (fun beta' => cognitionMarginal
          priorGap trueGap lowReward highReward beta' kappa)
        (mixedDerivativeValue
          priorGap trueGap lowReward highReward beta kappa) beta /\
      0 < mixedDerivativeValue
        priorGap trueGap lowReward highReward beta kappa

theorem supermodularCognitionClaim_proved :
    SupermodularCognitionClaim := by
  intro priorGap trueGap lowReward highReward beta kappa
    hGap hReward hBeta hModerate
  exact ⟨
    scaledTwoRouteWelfare_hasDerivAt_kappa
      priorGap trueGap lowReward highReward beta kappa,
    cognitionMarginal_hasDerivAt_beta hBeta,
    mixedDerivativeValue_pos hGap hReward hBeta hModerate⟩

end BlackwellDilemma.SupermodularCognition
