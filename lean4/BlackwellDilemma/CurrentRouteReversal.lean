/- Current-paper two-route Gaussian reversal on the common precision scale. -/

import BlackwellDilemma.CurrentGaussian

namespace BlackwellDilemma.CurrentRouteReversal

open BlackwellDilemma.CurrentGaussian

noncomputable abbrev precisionScale :=
  BlackwellDilemma.CurrentGaussian.precisionScale

noncomputable def routeTwoProbability (scoreGap beta : Real) : Real :=
  Phi (-scoreGap * precisionScale beta)

noncomputable def terminalWelfare
    (routeOneValue routeTwoValue scoreGap beta : Real) : Real :=
  routeOneValue + routeTwoProbability scoreGap beta *
    (routeTwoValue - routeOneValue)

theorem precisionScale_eq_inverse_difference_std
    {beta : Real} (hBeta : 0 < beta) :
    precisionScale beta =
      1 / Real.sqrt (2 * CurrentGaussian.signalVariance beta) :=
  CurrentGaussian.precisionScale_eq_inverse_difference_std hBeta

theorem scoreIndex_strictMono
    {scoreGap betaLow betaHigh : Real}
    (hGap : 0 < scoreGap) (hBetaLow : 0 < betaLow)
    (hBeta : betaLow < betaHigh) :
    scoreGap * precisionScale betaLow <
      scoreGap * precisionScale betaHigh := by
  exact mul_lt_mul_of_pos_left
    (CurrentGaussian.precisionScale_strictMonoOn
      hBetaLow (lt_trans hBetaLow hBeta) hBeta) hGap

theorem routeTwoProbability_strictAntiOn
    {scoreGap : Real} (hGap : 0 < scoreGap) :
    StrictAntiOn (routeTwoProbability scoreGap) (Set.Ioi 0) := by
  intro betaLow hLow betaHigh hHigh hBeta
  unfold routeTwoProbability
  apply Phi_strictMono
  have hIndex := scoreIndex_strictMono hGap hLow hBeta
  simpa using neg_lt_neg hIndex

theorem routeReversal_strictAntiOn
    {routeOneValue routeTwoValue scoreGap : Real}
    (hGap : 0 < scoreGap) (hContinuation : routeOneValue < routeTwoValue) :
    StrictAntiOn
      (terminalWelfare routeOneValue routeTwoValue scoreGap)
      (Set.Ioi 0) := by
  intro betaLow hLow betaHigh hHigh hBeta
  have hProbability := routeTwoProbability_strictAntiOn hGap hLow hHigh hBeta
  unfold terminalWelfare
  nlinarith

theorem terminalWelfare_formula
    (routeOneValue routeTwoValue scoreGap beta : Real) :
    terminalWelfare routeOneValue routeTwoValue scoreGap beta =
      routeOneValue +
        Phi (-scoreGap * precisionScale beta) *
          (routeTwoValue - routeOneValue) := rfl

end BlackwellDilemma.CurrentRouteReversal
