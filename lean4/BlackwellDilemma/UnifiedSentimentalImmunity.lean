/-
  BlackwellDilemma/UnifiedSentimentalImmunity.lean

  Sentimental immunity derived from the paper's alpha-weighted policy score.
  The threshold is the unique zero of the instrumental/sentimental utility
  comparison, not a hand-coded welfare carrier.
-/

import BlackwellDilemma.UnifiedSupermodularCognition

namespace BlackwellDilemma.SentimentalImmunity

open BlackwellDilemma.SupermodularCognition

noncomputable def policyScore
    (instrumentalGap sentimentalGap alpha : Real) : Real :=
  alpha * instrumentalGap + (1 - alpha) * sentimentalGap

noncomputable def policyAlphaStar
    (instrumentalGap sentimentalGap : Real) : Real :=
  sentimentalGap / (sentimentalGap - instrumentalGap)

theorem policyAlphaStar_mem_openUnit
    {instrumentalGap sentimentalGap : Real}
    (hInstrumental : instrumentalGap < 0)
    (hSentimental : 0 < sentimentalGap) :
    0 < policyAlphaStar instrumentalGap sentimentalGap /\
      policyAlphaStar instrumentalGap sentimentalGap < 1 := by
  have hDenominator : 0 < sentimentalGap - instrumentalGap := by
    linarith
  constructor
  · exact div_pos hSentimental hDenominator
  · exact (div_lt_one hDenominator).2 (by linarith)

theorem policyScore_at_alphaStar
    {instrumentalGap sentimentalGap : Real}
    (hInstrumental : instrumentalGap < 0)
    (hSentimental : 0 < sentimentalGap) :
    policyScore instrumentalGap sentimentalGap
      (policyAlphaStar instrumentalGap sentimentalGap) = 0 := by
  have hDenominator : sentimentalGap - instrumentalGap ≠ 0 := by
    linarith
  unfold policyScore policyAlphaStar
  field_simp
  ring

theorem policyScore_strictAnti
    {instrumentalGap sentimentalGap : Real}
    (hInstrumental : instrumentalGap < 0)
    (hSentimental : 0 < sentimentalGap) :
    StrictAnti (policyScore instrumentalGap sentimentalGap) := by
  intro alphaLow alphaHigh hAlpha
  unfold policyScore
  nlinarith

theorem policyScore_pos_below_alphaStar
    {instrumentalGap sentimentalGap alpha : Real}
    (hInstrumental : instrumentalGap < 0)
    (hSentimental : 0 < sentimentalGap)
    (hAlpha : alpha < policyAlphaStar instrumentalGap sentimentalGap) :
    0 < policyScore instrumentalGap sentimentalGap alpha := by
  have hStrict := policyScore_strictAnti hInstrumental hSentimental hAlpha
  rw [policyScore_at_alphaStar hInstrumental hSentimental] at hStrict
  exact hStrict

theorem policyScore_neg_above_alphaStar
    {instrumentalGap sentimentalGap alpha : Real}
    (hInstrumental : instrumentalGap < 0)
    (hSentimental : 0 < sentimentalGap)
    (hAlpha : policyAlphaStar instrumentalGap sentimentalGap < alpha) :
    policyScore instrumentalGap sentimentalGap alpha < 0 := by
  have hStrict := policyScore_strictAnti hInstrumental hSentimental hAlpha
  rw [policyScore_at_alphaStar hInstrumental hSentimental] at hStrict
  exact hStrict

noncomputable def effectivePolicyScore
    (instrumentalGap sentimentalGap alpha : Real) : Real :=
  policyScore instrumentalGap sentimentalGap alpha / alpha

theorem effectivePolicyScore_pos_below_alphaStar
    {instrumentalGap sentimentalGap alpha : Real}
    (hInstrumental : instrumentalGap < 0)
    (hSentimental : 0 < sentimentalGap)
    (hAlphaPositive : 0 < alpha)
    (hAlpha : alpha < policyAlphaStar instrumentalGap sentimentalGap) :
    0 < effectivePolicyScore instrumentalGap sentimentalGap alpha := by
  exact div_pos
    (policyScore_pos_below_alphaStar
      hInstrumental hSentimental hAlpha)
    hAlphaPositive

theorem effectivePolicyScore_neg_above_alphaStar
    {instrumentalGap sentimentalGap alpha : Real}
    (hInstrumental : instrumentalGap < 0)
    (hSentimental : 0 < sentimentalGap)
    (hAlphaPositive : 0 < alpha)
    (hAlpha : policyAlphaStar instrumentalGap sentimentalGap < alpha) :
    effectivePolicyScore instrumentalGap sentimentalGap alpha < 0 := by
  exact div_neg_of_neg_of_pos
    (policyScore_neg_above_alphaStar
      hInstrumental hSentimental hAlpha)
    hAlphaPositive

theorem signalScale_mono {betaLow betaHigh : Real}
    (hBeta : betaLow <= betaHigh) :
    signalScale betaLow <= signalScale betaHigh := by
  unfold signalScale
  apply Real.sqrt_le_sqrt
  have hExponent : 2 * betaLow <= 2 * betaHigh := by linarith
  have hPower :
      (2 : Real) ^ (2 * betaLow) <= (2 : Real) ^ (2 * betaHigh) :=
    Real.rpow_le_rpow_of_exponent_le (by norm_num) hExponent
  linarith

noncomputable def positiveAlphaWelfare
    (lowReward highReward instrumentalGap sentimentalGap
      beta alpha : Real) : Real :=
  lowReward + (highReward - lowReward) *
    Phi (signalScale beta *
      effectivePolicyScore instrumentalGap sentimentalGap alpha)

noncomputable def policyWelfare
    (lowReward highReward instrumentalGap sentimentalGap
      beta alpha : Real) : Real :=
  if alpha = 0 then highReward else
    positiveAlphaWelfare lowReward highReward
      instrumentalGap sentimentalGap beta alpha

theorem positiveAlphaWelfare_mono_of_effectiveScore_nonneg
    {lowReward highReward instrumentalGap sentimentalGap
      betaLow betaHigh alpha : Real}
    (hReward : lowReward <= highReward)
    (hBeta : betaLow <= betaHigh)
    (hScore :
      0 <= effectivePolicyScore instrumentalGap sentimentalGap alpha) :
    positiveAlphaWelfare lowReward highReward
        instrumentalGap sentimentalGap betaLow alpha <=
      positiveAlphaWelfare lowReward highReward
        instrumentalGap sentimentalGap betaHigh alpha := by
  have hScale := signalScale_mono hBeta
  have hArgument := mul_le_mul_of_nonneg_right hScale hScore
  have hProbability := Phi_monotone hArgument
  unfold positiveAlphaWelfare
  nlinarith

theorem positiveAlphaWelfare_antitone_of_effectiveScore_nonpos
    {lowReward highReward instrumentalGap sentimentalGap
      betaLow betaHigh alpha : Real}
    (hReward : lowReward <= highReward)
    (hBeta : betaLow <= betaHigh)
    (hScore :
      effectivePolicyScore instrumentalGap sentimentalGap alpha <= 0) :
    positiveAlphaWelfare lowReward highReward
        instrumentalGap sentimentalGap betaHigh alpha <=
      positiveAlphaWelfare lowReward highReward
        instrumentalGap sentimentalGap betaLow alpha := by
  have hScale := signalScale_mono hBeta
  have hArgument := mul_le_mul_of_nonpos_right hScale hScore
  have hProbability := Phi_monotone hArgument
  unfold positiveAlphaWelfare
  nlinarith

theorem policyWelfare_mono_below_alphaStar
    {lowReward highReward instrumentalGap sentimentalGap
      betaLow betaHigh alpha : Real}
    (hInstrumental : instrumentalGap < 0)
    (hSentimental : 0 < sentimentalGap)
    (hReward : lowReward <= highReward)
    (hAlphaNonnegative : 0 <= alpha)
    (hAlpha : alpha < policyAlphaStar instrumentalGap sentimentalGap)
    (hBeta : betaLow <= betaHigh) :
    policyWelfare lowReward highReward instrumentalGap sentimentalGap
        betaLow alpha <=
      policyWelfare lowReward highReward instrumentalGap sentimentalGap
        betaHigh alpha := by
  by_cases hAlphaZero : alpha = 0
  · simp [policyWelfare, hAlphaZero]
  · have hAlphaPositive : 0 < alpha :=
      lt_of_le_of_ne hAlphaNonnegative (Ne.symm hAlphaZero)
    have hScore := (effectivePolicyScore_pos_below_alphaStar
      hInstrumental hSentimental hAlphaPositive hAlpha).le
    simpa [policyWelfare, hAlphaZero] using
      positiveAlphaWelfare_mono_of_effectiveScore_nonneg
        hReward hBeta hScore

theorem policyWelfare_antitone_above_alphaStar
    {lowReward highReward instrumentalGap sentimentalGap
      betaLow betaHigh alpha : Real}
    (hInstrumental : instrumentalGap < 0)
    (hSentimental : 0 < sentimentalGap)
    (hReward : lowReward <= highReward)
    (hAlphaPositive : 0 < alpha)
    (hAlpha : policyAlphaStar instrumentalGap sentimentalGap < alpha)
    (hBeta : betaLow <= betaHigh) :
    policyWelfare lowReward highReward instrumentalGap sentimentalGap
        betaHigh alpha <=
      policyWelfare lowReward highReward instrumentalGap sentimentalGap
        betaLow alpha := by
  have hAlphaNonzero : alpha ≠ 0 := hAlphaPositive.ne'
  have hScore := (effectivePolicyScore_neg_above_alphaStar
    hInstrumental hSentimental hAlphaPositive hAlpha).le
  simpa [policyWelfare, hAlphaNonzero] using
    positiveAlphaWelfare_antitone_of_effectiveScore_nonpos
      hReward hBeta hScore

def SentimentalImmunityClaim : Prop :=
  forall lowReward highReward instrumentalGap sentimentalGap : Real,
    instrumentalGap < 0 ->
    0 < sentimentalGap ->
    lowReward <= highReward ->
      0 < policyAlphaStar instrumentalGap sentimentalGap /\
      policyAlphaStar instrumentalGap sentimentalGap < 1 /\
      (forall alpha, 0 <= alpha ->
        alpha < policyAlphaStar instrumentalGap sentimentalGap ->
        forall betaLow betaHigh, betaLow <= betaHigh ->
          policyWelfare lowReward highReward
              instrumentalGap sentimentalGap betaLow alpha <=
            policyWelfare lowReward highReward
              instrumentalGap sentimentalGap betaHigh alpha) /\
      (forall alpha, 0 < alpha ->
        policyAlphaStar instrumentalGap sentimentalGap < alpha ->
        forall betaLow betaHigh, betaLow <= betaHigh ->
          policyWelfare lowReward highReward
              instrumentalGap sentimentalGap betaHigh alpha <=
            policyWelfare lowReward highReward
              instrumentalGap sentimentalGap betaLow alpha)

theorem sentimentalImmunityClaim_proved : SentimentalImmunityClaim := by
  intro lowReward highReward instrumentalGap sentimentalGap
    hInstrumental hSentimental hReward
  obtain ⟨hAlphaPositive, hAlphaBelowOne⟩ :=
    policyAlphaStar_mem_openUnit hInstrumental hSentimental
  exact ⟨
    hAlphaPositive,
    hAlphaBelowOne,
    (fun _ hAlphaNonnegative hAlpha _ _ hBeta =>
      policyWelfare_mono_below_alphaStar
        hInstrumental hSentimental hReward
        hAlphaNonnegative hAlpha hBeta),
    (fun _ hAlphaPositive hAlpha _ _ hBeta =>
      policyWelfare_antitone_above_alphaStar
        hInstrumental hSentimental hReward
        hAlphaPositive hAlpha hBeta)⟩

end BlackwellDilemma.SentimentalImmunity
