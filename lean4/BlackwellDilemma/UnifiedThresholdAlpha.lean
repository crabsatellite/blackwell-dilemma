/-
  BlackwellDilemma/UnifiedThresholdAlpha.lean

  Exact alpha comparative statics for the repaired cognitive crossing model.
  Instrumental weight enters the route score through an explicit positive
  loading rather than an unspecified implicit-function derivative.
-/

import BlackwellDilemma.UnifiedCognitiveThreshold

namespace BlackwellDilemma.ThresholdAlpha

open BlackwellDilemma.CognitiveThreshold

noncomputable def alphaAdjustedScore
    (priorGap trueGap loading kappa alpha : Real) : Real :=
  interpolatedScore priorGap trueGap kappa - loading * alpha

theorem alphaAdjustedScore_eq_interpolated
    (priorGap trueGap loading kappa alpha : Real) :
    alphaAdjustedScore priorGap trueGap loading kappa alpha =
      interpolatedScore (priorGap - loading * alpha)
        (trueGap - loading * alpha) kappa := by
  unfold alphaAdjustedScore interpolatedScore
  ring

def IsAlphaKappaThreshold
    (priorGap trueGap loading alpha kappaStar : Real) : Prop :=
  IsThreshold (priorGap - loading * alpha)
    (trueGap - loading * alpha) kappaStar

theorem exists_unique_kappaThreshold_at_alpha
    {priorGap trueGap loading alpha : Real}
    (hPrior : priorGap - loading * alpha < 0)
    (hTrue : 0 < trueGap - loading * alpha) :
    ∃! kappaStar : Real,
      IsAlphaKappaThreshold priorGap trueGap loading alpha kappaStar := by
  exact exists_unique_threshold hPrior hTrue

theorem alphaAdjustedScore_strictAnti
    {priorGap trueGap loading kappa : Real} (hLoading : 0 < loading) :
    StrictAnti (alphaAdjustedScore priorGap trueGap loading kappa) := by
  intro alphaLow alphaHigh hAlpha
  unfold alphaAdjustedScore
  nlinarith

theorem kappaThreshold_strictMono_in_alpha
    {priorGap trueGap loading alphaLow alphaHigh
      kappaLow kappaHigh : Real}
    (hLoading : 0 < loading) (hAlpha : alphaLow < alphaHigh)
    (hLow : IsAlphaKappaThreshold priorGap trueGap loading
      alphaLow kappaLow)
    (hHigh : IsAlphaKappaThreshold priorGap trueGap loading
      alphaHigh kappaHigh) :
    kappaLow < kappaHigh := by
  have hLowRoot :
      alphaAdjustedScore priorGap trueGap loading kappaLow alphaLow = 0 := by
    rw [alphaAdjustedScore_eq_interpolated]
    exact hLow.2.1
  have hHighAtLow :
      alphaAdjustedScore priorGap trueGap loading kappaLow alphaHigh < 0 :=
    (alphaAdjustedScore_strictAnti hLoading hAlpha).trans_eq hLowRoot
  rw [alphaAdjustedScore_eq_interpolated] at hHighAtLow
  rcases lt_trichotomy kappaLow kappaHigh with hBefore | hEqual | hAfter
  · exact hBefore
  · subst kappaHigh
    rw [hHigh.2.1] at hHighAtLow
    exfalso
    exact (lt_irrefl 0) hHighAtLow
  · have hPositive := hHigh.2.2.2 kappaLow hAfter
    linarith

noncomputable def alphaCrossing
    (priorGap trueGap loading kappa : Real) : Real :=
  interpolatedScore priorGap trueGap kappa / loading

def IsAlphaCrossing
    (priorGap trueGap loading kappa alphaStar : Real) : Prop :=
  0 < alphaStar /\ alphaStar < 1 /\
  alphaAdjustedScore priorGap trueGap loading kappa alphaStar = 0 /\
  (forall alpha, alpha < alphaStar ->
    0 < alphaAdjustedScore priorGap trueGap loading kappa alpha) /\
  (forall alpha, alphaStar < alpha ->
    alphaAdjustedScore priorGap trueGap loading kappa alpha < 0)

theorem alphaCrossing_certificate
    {priorGap trueGap loading kappa : Real}
    (hLoading : 0 < loading)
    (hScorePositive : 0 < interpolatedScore priorGap trueGap kappa)
    (hScoreBelowLoading :
      interpolatedScore priorGap trueGap kappa < loading) :
    IsAlphaCrossing priorGap trueGap loading kappa
      (alphaCrossing priorGap trueGap loading kappa) := by
  have hAlphaPositive :
      0 < alphaCrossing priorGap trueGap loading kappa :=
    div_pos hScorePositive hLoading
  have hAlphaBelowOne :
      alphaCrossing priorGap trueGap loading kappa < 1 :=
    (div_lt_one hLoading).2 hScoreBelowLoading
  have hRoot :
      alphaAdjustedScore priorGap trueGap loading kappa
        (alphaCrossing priorGap trueGap loading kappa) = 0 := by
    unfold alphaAdjustedScore alphaCrossing
    field_simp
    ring
  refine ⟨hAlphaPositive, hAlphaBelowOne, hRoot, ?_, ?_⟩
  · intro alpha hAlpha
    have hAnti := alphaAdjustedScore_strictAnti
      (priorGap := priorGap) (trueGap := trueGap)
      (kappa := kappa) hLoading hAlpha
    linarith
  · intro alpha hAlpha
    have hAnti := alphaAdjustedScore_strictAnti
      (priorGap := priorGap) (trueGap := trueGap)
      (kappa := kappa) hLoading hAlpha
    linarith

theorem exists_unique_alphaCrossing
    {priorGap trueGap loading kappa : Real}
    (hLoading : 0 < loading)
    (hScorePositive : 0 < interpolatedScore priorGap trueGap kappa)
    (hScoreBelowLoading :
      interpolatedScore priorGap trueGap kappa < loading) :
    ∃! alphaStar : Real,
      IsAlphaCrossing priorGap trueGap loading kappa alphaStar := by
  let alphaStar := alphaCrossing priorGap trueGap loading kappa
  have hCertificate :
      IsAlphaCrossing priorGap trueGap loading kappa alphaStar :=
    alphaCrossing_certificate hLoading hScorePositive hScoreBelowLoading
  refine ⟨alphaStar, hCertificate, ?_⟩
  intro other hOther
  have hStrictAnti := alphaAdjustedScore_strictAnti
    (priorGap := priorGap) (trueGap := trueGap)
    (kappa := kappa) hLoading
  exact hStrictAnti.injective (hOther.2.2.1.trans hCertificate.2.2.1.symm)

def ThresholdAlphaClaim : Prop :=
  (forall priorGap trueGap loading alpha : Real,
    priorGap - loading * alpha < 0 ->
    0 < trueGap - loading * alpha ->
      ∃! kappaStar : Real,
        IsAlphaKappaThreshold priorGap trueGap loading alpha kappaStar) /\
  (forall priorGap trueGap loading alphaLow alphaHigh
      kappaLow kappaHigh : Real,
    0 < loading -> alphaLow < alphaHigh ->
    IsAlphaKappaThreshold priorGap trueGap loading alphaLow kappaLow ->
    IsAlphaKappaThreshold priorGap trueGap loading alphaHigh kappaHigh ->
      kappaLow < kappaHigh) /\
  (forall priorGap trueGap loading kappa : Real,
    0 < loading ->
    0 < interpolatedScore priorGap trueGap kappa ->
    interpolatedScore priorGap trueGap kappa < loading ->
      ∃! alphaStar : Real,
        IsAlphaCrossing priorGap trueGap loading kappa alphaStar)

theorem thresholdAlphaClaim_proved : ThresholdAlphaClaim := by
  exact ⟨
    (fun _ _ _ _ hPrior hTrue =>
      exists_unique_kappaThreshold_at_alpha hPrior hTrue),
    (fun _ _ _ _ _ _ _ hLoading hAlpha hLow hHigh =>
      kappaThreshold_strictMono_in_alpha
        hLoading hAlpha hLow hHigh),
    (fun _ _ _ _ hLoading hPositive hBelow =>
      exists_unique_alphaCrossing hLoading hPositive hBelow)⟩

end BlackwellDilemma.ThresholdAlpha
