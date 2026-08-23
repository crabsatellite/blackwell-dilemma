/- Current-paper two-route Gaussian reversal on the common precision scale. -/

import BlackwellDilemma.CurrentGaussian
import BlackwellDilemma.CurrentPosterior

namespace BlackwellDilemma.CurrentRouteReversal

open BlackwellDilemma.CurrentGaussian
open BlackwellDilemma.CurrentPosterior

noncomputable abbrev precisionScale :=
  BlackwellDilemma.CurrentGaussian.precisionScale

noncomputable def routeTwoProbability (scoreGap beta : Real) : Real :=
  Phi (-scoreGap * precisionScale beta)

noncomputable def terminalWelfare
    (routeOneValue routeTwoValue scoreGap beta : Real) : Real :=
  routeOneValue + routeTwoProbability scoreGap beta *
    (routeTwoValue - routeOneValue)

/-- The finite expectation `\bar V_i = E_omega[V_i(omega)]` used by the
    current route-reversal theorem. -/
noncomputable def expectedContinuation
    {Omega : Type*} [Fintype Omega]
    (weight value : Omega -> Real) : Real :=
  finiteExpectation weight value

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

/-- Paper-faithful finite-realization form of Theorem 6.  The local scores
    remain separate inputs, the continuation values are literal finite
    expectations, and the strict precision conclusion is on `(0, infinity)`. -/
theorem finiteRouteReversal
    {Omega : Type*} [Fintype Omega]
    (weight routeOne routeTwo : Omega -> Real)
    (ellOne ellTwo : Real)
    (hScore : ellTwo < ellOne)
    (hContinuation :
      expectedContinuation weight routeOne <
        expectedContinuation weight routeTwo) :
    (forall beta,
      terminalWelfare
          (expectedContinuation weight routeOne)
          (expectedContinuation weight routeTwo)
          (ellOne - ellTwo) beta =
        expectedContinuation weight routeOne +
          Phi (-(ellOne - ellTwo) * precisionScale beta) *
            (expectedContinuation weight routeTwo -
              expectedContinuation weight routeOne)) /\
      StrictAntiOn
        (terminalWelfare
          (expectedContinuation weight routeOne)
          (expectedContinuation weight routeTwo)
          (ellOne - ellTwo))
        (Set.Ioi 0) := by
  have hGap : 0 < ellOne - ellTwo := sub_pos.mpr hScore
  exact ⟨terminalWelfare_formula _ _ _,
    routeReversal_strictAntiOn hGap hContinuation⟩

end BlackwellDilemma.CurrentRouteReversal
