/-
  BlackwellDilemma/UnifiedGeneralTree.lean

  Tail-rate repair of the general-graph reversal theorem. C2-prime supplies a
  positive limiting bridge advantage. The additional C4 certificate requires
  all remaining finite-precision terms to be little-o of the root bridge
  probability; this is the rate condition missing from bounded convergence.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

namespace BlackwellDilemma.GeneralTreeTail

/-- An asymptotic certificate for one C2-prime trap/bridge pair. `remainder`
    contains every term other than the root bridge probability times the
    limiting greedy-path value gap. -/
structure TailRateCertificate where
  perfectSignalWelfare : Real
  bridgeGreedyPathValue : Real
  bridgeProbability : Real -> Real
  welfare : Real -> Real
  remainder : Real -> Real
  bridgeAdvantage : perfectSignalWelfare < bridgeGreedyPathValue
  decomposition : forall beta,
    welfare beta - perfectSignalWelfare =
      bridgeProbability beta *
        (bridgeGreedyPathValue - perfectSignalWelfare) + remainder beta
  bridgeProbabilityEventuallyPositive : exists betaPositive,
    forall beta, betaPositive < beta -> 0 < bridgeProbability beta
  remainderLittleO : forall epsilon : Real, 0 < epsilon ->
    exists betaRemainder,
      forall beta, betaRemainder < beta ->
        |remainder beta| <= epsilon * bridgeProbability beta

namespace TailRateCertificate

theorem eventual_strict_overshoot (D : TailRateCertificate) :
    exists beta0 : Real,
      forall beta : Real,
        beta0 < beta -> D.perfectSignalWelfare < D.welfare beta := by
  have hGap :
      0 < D.bridgeGreedyPathValue - D.perfectSignalWelfare := by
    linarith [D.bridgeAdvantage]
  obtain ⟨betaPositive, hProbabilityPositive⟩ :=
    D.bridgeProbabilityEventuallyPositive
  obtain ⟨betaRemainder, hRemainder⟩ :=
    D.remainderLittleO
      ((D.bridgeGreedyPathValue - D.perfectSignalWelfare) / 2)
      (by linarith)
  refine ⟨max betaPositive betaRemainder, ?_⟩
  intro beta hBeta
  have hBetaPositive : betaPositive < beta :=
    lt_of_le_of_lt (le_max_left _ _) hBeta
  have hBetaRemainder : betaRemainder < beta :=
    lt_of_le_of_lt (le_max_right _ _) hBeta
  have hProbability : 0 < D.bridgeProbability beta :=
    hProbabilityPositive beta hBetaPositive
  have hAbs := hRemainder beta hBetaRemainder
  have hRemainderLower :
      -((D.bridgeGreedyPathValue - D.perfectSignalWelfare) / 2 *
          D.bridgeProbability beta) <=
        D.remainder beta := by
    have hNegAbs : -|D.remainder beta| <= D.remainder beta :=
      neg_abs_le (D.remainder beta)
    have hScaleNonnegative :
        0 <= (D.bridgeGreedyPathValue - D.perfectSignalWelfare) / 2 *
          D.bridgeProbability beta := by
      positivity
    have hScale :
        |D.remainder beta| <=
          (D.bridgeGreedyPathValue - D.perfectSignalWelfare) / 2 *
            D.bridgeProbability beta := by
      simpa [mul_comm] using hAbs
    linarith
  have hDecomposition := D.decomposition beta
  nlinarith

end TailRateCertificate

/-- Exact repaired publication target: every tail-rate certificate produces
    welfare strictly above the perfect-signal greedy-path limit at all
    sufficiently large finite precisions. -/
def GeneralTreeReversalClaim : Prop :=
  forall D : TailRateCertificate,
    exists beta0 : Real,
      forall beta : Real,
        beta0 < beta -> D.perfectSignalWelfare < D.welfare beta

theorem generalTreeReversalClaim_proved : GeneralTreeReversalClaim :=
  TailRateCertificate.eventual_strict_overshoot

end BlackwellDilemma.GeneralTreeTail
