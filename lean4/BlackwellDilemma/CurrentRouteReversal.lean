/- Current-paper generic Gaussian route-reversal theorem. -/

import BlackwellDilemma.ClassicalResults

namespace BlackwellDilemma.CurrentRouteReversal

open BlackwellDilemma

noncomputable def routeTwoProbability (rewardGap beta : Real) : Real :=
  Phi (-rewardGap / Real.sqrt (2 * signalVariance beta))

noncomputable def terminalWelfare
    (routeOneValue routeTwoValue rewardGap beta : Real) : Real :=
  routeOneValue + routeTwoProbability rewardGap beta *
    (routeTwoValue - routeOneValue)

theorem signalVariance_pos {beta : Real} (hBeta : 0 < beta) :
    0 < signalVariance beta := by
  unfold signalVariance
  have hPow : (1 : Real) < (2 : Real) ^ (2 * beta) :=
    Real.one_lt_rpow (by norm_num) (by linarith)
  exact one_div_pos.mpr (by linarith)

theorem signalStd_pos {beta : Real} (hBeta : 0 < beta) :
    0 < Real.sqrt (2 * signalVariance beta) := by
  exact Real.sqrt_pos.mpr (mul_pos (by norm_num) (signalVariance_pos hBeta))

theorem normalizedGap_strictMono
    {rewardGap betaLow betaHigh : Real}
    (hGap : 0 < rewardGap) (hBetaLow : 0 < betaLow)
    (hBeta : betaLow < betaHigh) :
    rewardGap / Real.sqrt (2 * signalVariance betaLow) <
      rewardGap / Real.sqrt (2 * signalVariance betaHigh) := by
  have hBetaHigh : 0 < betaHigh := lt_trans hBetaLow hBeta
  have hVariance : signalVariance betaHigh < signalVariance betaLow :=
    signalVariance_strictAntitoneOn hBetaLow hBeta
  have hTwice :
      2 * signalVariance betaHigh < 2 * signalVariance betaLow := by
    linarith
  have hSqrt :
      Real.sqrt (2 * signalVariance betaHigh) <
        Real.sqrt (2 * signalVariance betaLow) :=
    Real.sqrt_lt_sqrt
      (le_of_lt (mul_pos (by norm_num) (signalVariance_pos hBetaHigh)))
      hTwice
  exact div_lt_div_of_pos_left hGap (signalStd_pos hBetaHigh) hSqrt

theorem routeTwoProbability_strictAntiOn
    {rewardGap : Real} (hGap : 0 < rewardGap) :
    StrictAntiOn (routeTwoProbability rewardGap) (Set.Ioi 0) := by
  intro betaLow hLow betaHigh hHigh hBeta
  unfold routeTwoProbability
  apply Phi_strictMono
  have hNormalized := normalizedGap_strictMono hGap hLow hBeta
  simpa only [neg_div] using neg_lt_neg hNormalized

/-- Theorem 6: every strict precision increase lowers expected terminal
    welfare when the immediate and continuation rankings are opposed. -/
theorem routeReversal_strictAntiOn
    {routeOneValue routeTwoValue rewardGap : Real}
    (hGap : 0 < rewardGap) (hContinuation : routeOneValue < routeTwoValue) :
    StrictAntiOn
      (terminalWelfare routeOneValue routeTwoValue rewardGap)
      (Set.Ioi 0) := by
  intro betaLow hLow betaHigh hHigh hBeta
  have hProbability := routeTwoProbability_strictAntiOn hGap hLow hHigh hBeta
  unfold terminalWelfare
  nlinarith

theorem terminalWelfare_formula
    (routeOneValue routeTwoValue rewardGap beta : Real) :
    terminalWelfare routeOneValue routeTwoValue rewardGap beta =
      routeOneValue +
        Phi (-rewardGap / Real.sqrt (2 * signalVariance beta)) *
          (routeTwoValue - routeOneValue) := rfl

end BlackwellDilemma.CurrentRouteReversal
