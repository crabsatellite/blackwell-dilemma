/- Minimal Gaussian and precision-scale analysis used by the current paper. -/

import Mathlib.Analysis.Calculus.Deriv.MeanValue
import Mathlib.Analysis.SpecialFunctions.Gaussian.GaussianIntegral
import Mathlib.Analysis.SpecialFunctions.Pow.Asymptotics
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus
import Mathlib.Probability.Distributions.Gaussian.Real
import Mathlib.Tactic

namespace BlackwellDilemma.CurrentGaussian

open Filter MeasureTheory Set Topology

noncomputable def phi (z : Real) : Real :=
  (1 / Real.sqrt (2 * Real.pi)) * Real.exp (-z ^ 2 / 2)

noncomputable def Phi (x : Real) : Real :=
  (1 : Real) / 2 + ∫ t in (0 : Real)..x, phi t

theorem phi_hasDerivAt (z : Real) : HasDerivAt phi (-z * phi z) z := by
  have hInner : HasDerivAt (fun x : Real => -x ^ 2 / 2) (-z) z := by
    convert ((hasDerivAt_pow 2 z).neg.div_const 2) using 1
    all_goals ring
  have hExp := hInner.exp.const_mul (1 / Real.sqrt (2 * Real.pi))
  convert hExp using 1
  all_goals simp [phi]
  all_goals ring

theorem phi_continuous : Continuous phi := by
  unfold phi
  exact continuous_const.mul (((continuous_id.pow 2).neg.div_const 2).rexp)

theorem phi_pos (z : Real) : 0 < phi z := by
  unfold phi
  have hSqrt : 0 < Real.sqrt (2 * Real.pi) :=
    Real.sqrt_pos.mpr (mul_pos (by norm_num) Real.pi_pos)
  positivity

theorem phi_nonneg (z : Real) : 0 <= phi z := (phi_pos z).le

theorem Phi_hasDerivAt (x : Real) : HasDerivAt Phi (phi x) x := by
  have hIntegral :
      HasDerivAt (fun u : Real => ∫ t in (0 : Real)..u, phi t) (phi x) x :=
    intervalIntegral.integral_hasDerivAt_right
      (phi_continuous.intervalIntegrable 0 x)
      phi_continuous.aestronglyMeasurable.stronglyMeasurableAtFilter
      phi_continuous.continuousAt
  exact hIntegral.const_add ((1 : Real) / 2)

theorem Phi_continuous : Continuous Phi := by
  rw [continuous_iff_continuousAt]
  exact fun x => (Phi_hasDerivAt x).continuousAt

theorem Phi_strictMono : StrictMono Phi :=
  strictMono_of_hasDerivAt_pos Phi_hasDerivAt phi_pos

theorem Phi_monotone : Monotone Phi := Phi_strictMono.monotone

theorem Phi_zero : Phi 0 = (1 : Real) / 2 := by
  simp [Phi]

private theorem phi_eq_gaussian (z : Real) :
    phi z = (1 / Real.sqrt (2 * Real.pi)) *
      Real.exp (-(1 / 2 : Real) * z ^ 2) := by
  unfold phi
  congr 2
  ring

private theorem integral_phi_Ioi_zero :
    ∫ t in Set.Ioi (0 : Real), phi t = (1 : Real) / 2 := by
  have hGaussian :
      ∫ t in Set.Ioi (0 : Real), Real.exp (-(1 / 2 : Real) * t ^ 2) =
        Real.sqrt (Real.pi / (1 / 2 : Real)) / 2 :=
    integral_gaussian_Ioi (1 / 2)
  have hPi : Real.pi / (1 / 2 : Real) = 2 * Real.pi := by ring
  rw [hPi] at hGaussian
  have hCarrier : phi = fun t =>
      (1 / Real.sqrt (2 * Real.pi)) *
        Real.exp (-(1 / 2 : Real) * t ^ 2) := by
    funext t
    exact phi_eq_gaussian t
  rw [hCarrier, MeasureTheory.integral_const_mul, hGaussian]
  have hSqrt : 0 < Real.sqrt (2 * Real.pi) :=
    Real.sqrt_pos.mpr (mul_pos (by norm_num) Real.pi_pos)
  field_simp

private theorem phi_integrableOn_Ioi_zero :
    IntegrableOn phi (Set.Ioi (0 : Real)) := by
  rw [show phi = fun t =>
      (1 / Real.sqrt (2 * Real.pi)) *
        Real.exp (-(1 / 2 : Real) * t ^ 2) from by
    funext t
    exact phi_eq_gaussian t]
  exact (integrable_exp_neg_mul_sq (by norm_num : (0 : Real) < 1 / 2)).const_mul _ |>.integrableOn

private theorem integral_phi_zero_tendsto :
    Tendsto (fun x : Real => ∫ t in (0 : Real)..x, phi t)
      atTop (nhds ((1 : Real) / 2)) := by
  have h := MeasureTheory.intervalIntegral_tendsto_integral_Ioi
    0 phi_integrableOn_Ioi_zero tendsto_id
  rwa [integral_phi_Ioi_zero] at h

theorem Phi_tendsto_one_atTop : Tendsto Phi atTop (nhds 1) := by
  have h := integral_phi_zero_tendsto.const_add ((1 : Real) / 2)
  convert h using 1
  all_goals norm_num [Phi]

private theorem integral_phi_zero_to_x_le_half (x : Real) (hX : 0 <= x) :
    ∫ t in (0 : Real)..x, phi t <= (1 : Real) / 2 := by
  have hSplit :
      (∫ t in Set.Ioi (0 : Real), phi t) -
          (∫ t in Set.Ioi x, phi t) =
        ∫ t in (0 : Real)..x, phi t :=
    intervalIntegral.integral_Ioi_sub_Ioi phi_integrableOn_Ioi_zero hX
  rw [integral_phi_Ioi_zero] at hSplit
  have hTail : 0 <= ∫ t in Set.Ioi x, phi t :=
    integral_nonneg phi_nonneg
  linarith

theorem Phi_le_one (x : Real) : Phi x <= 1 := by
  by_cases hX : 0 <= x
  · unfold Phi
    linarith [integral_phi_zero_to_x_le_half x hX]
  · have hMono : Phi x <= Phi 0 := Phi_monotone (le_of_not_ge hX)
    rw [Phi_zero] at hMono
    linarith

theorem Phi_nonneg (x : Real) : 0 <= Phi x := by
  by_cases hX : 0 <= x
  · have hMono : Phi 0 <= Phi x := Phi_monotone hX
    rw [Phi_zero] at hMono
    linarith
  · let y : Real := -x
    have hY : 0 <= y := by dsimp [y]; linarith
    have hEven : ∀ t, phi (-t) = phi t := by
      intro t
      simp [phi]
    have hComp : ∫ t in (0 : Real)..y, phi (-t) =
        ∫ t in (-y)..(0 : Real), phi t := by
      simpa only [neg_zero] using
        (intervalIntegral.integral_comp_neg
          (a := (0 : Real)) (b := y) phi)
    have hNegIntegral :
        ∫ t in (0 : Real)..x, phi t =
          -(∫ t in (0 : Real)..y, phi t) := by
      have hEvenIntegral : ∫ t in (0 : Real)..y, phi (-t) =
          ∫ t in (0 : Real)..y, phi t := by
        apply intervalIntegral.integral_congr
        intro t _
        exact hEven t
      rw [hEvenIntegral] at hComp
      have hXY : -y = x := by simp [y]
      rw [hXY] at hComp
      rw [intervalIntegral.integral_symm, ← hComp]
    unfold Phi
    rw [hNegIntegral]
    linarith [integral_phi_zero_to_x_le_half y hY]

theorem Phi_pos (x : Real) : 0 < Phi x := by
  have hStrict : Phi (x - 1) < Phi x := Phi_strictMono (by linarith)
  exact lt_of_le_of_lt (Phi_nonneg (x - 1)) hStrict

theorem Phi_lt_one (x : Real) : Phi x < 1 := by
  have hStrict : Phi x < Phi (x + 1) := Phi_strictMono (by linarith)
  exact lt_of_lt_of_le hStrict (Phi_le_one (x + 1))

noncomputable def signalVariance (beta : Real) : Real :=
  1 / ((2 : Real) ^ (2 * beta) - 1)

theorem signalVariance_pos {beta : Real} (hBeta : 0 < beta) :
    0 < signalVariance beta := by
  have hPow : (1 : Real) < (2 : Real) ^ (2 * beta) :=
    Real.one_lt_rpow (by norm_num) (by linarith)
  unfold signalVariance
  positivity

theorem signalVariance_strictAntiOn :
    StrictAntiOn signalVariance (Set.Ioi 0) := by
  intro betaLow hLow betaHigh _hHigh hBeta
  have hBetaLow : 0 < betaLow := hLow
  have hDenomLow : 0 < (2 : Real) ^ (2 * betaLow) - 1 := by
    have hPow : (1 : Real) < (2 : Real) ^ (2 * betaLow) :=
      Real.one_lt_rpow (by norm_num) (by linarith [hBetaLow])
    linarith
  have hPow :
      (2 : Real) ^ (2 * betaLow) < (2 : Real) ^ (2 * betaHigh) :=
    Real.rpow_lt_rpow_of_exponent_lt (by norm_num) (by linarith)
  unfold signalVariance
  exact one_div_lt_one_div_of_lt hDenomLow (by linarith)

/-- Positive variance carrier for the Gaussian signal experiment. -/
noncomputable def positiveSignalVariance
    (beta : Set.Ioi (0 : Real)) : NNReal :=
  ⟨signalVariance beta.1, (signalVariance_pos beta.2).le⟩

open ProbabilityTheory in
/-- One coordinate of the manuscript's Gaussian payoff experiment. -/
noncomputable def gaussianScoreLaw
    (ell : Real) (beta : Set.Ioi (0 : Real)) : Measure Real :=
  gaussianReal ell (positiveSignalVariance beta)

open ProbabilityTheory in
/-- The joint law of the two independent, equal-variance Gaussian scores. -/
noncomputable def gaussianScoreExperimentLaw
    (ell : Fin 2 -> Real) (beta : Set.Ioi (0 : Real)) : Measure (Real × Real) :=
  (gaussianScoreLaw (ell 0) beta).prod (gaussianScoreLaw (ell 1) beta)

open ProbabilityTheory in
/-- Literal additive-noise garbling of every score coordinate. -/
def GaussianScoreGarbling
    (ell : Fin 2 -> Real)
    (betaLow betaHigh : Set.Ioi (0 : Real)) : Prop :=
  forall i : Fin 2,
    gaussianScoreLaw (ell i) betaHigh ∗
        gaussianReal 0
          (positiveSignalVariance betaLow - positiveSignalVariance betaHigh) =
      gaussianScoreLaw (ell i) betaLow

open ProbabilityTheory in
theorem gaussianScoreGarbling_of_lt
    (ell : Fin 2 -> Real)
    {betaLow betaHigh : Set.Ioi (0 : Real)}
    (hBeta : betaLow.1 < betaHigh.1) :
    GaussianScoreGarbling ell betaLow betaHigh := by
  have hVarianceReal :
      signalVariance betaHigh.1 < signalVariance betaLow.1 :=
    signalVariance_strictAntiOn betaLow.2 betaHigh.2 hBeta
  have hVariance :
      positiveSignalVariance betaHigh <= positiveSignalVariance betaLow := by
    exact_mod_cast hVarianceReal.le
  intro i
  unfold gaussianScoreLaw
  rw [gaussianReal_conv_gaussianReal]
  simp only [add_zero]
  rw [add_tsub_cancel_of_le hVariance]

noncomputable def precisionScale (beta : Real) : Real :=
  Real.sqrt (((2 : Real) ^ (2 * beta) - 1) / 2)

theorem precisionScale_zero : precisionScale 0 = 0 := by
  simp [precisionScale]

theorem precisionScale_continuous : Continuous precisionScale := by
  unfold precisionScale
  exact Real.continuous_sqrt.comp
    ((((Real.continuous_const_rpow (by norm_num : (2 : Real) ≠ 0)).comp
      (continuous_const.mul continuous_id)).sub continuous_const).div_const 2)

theorem precisionScale_pos {beta : Real} (hBeta : 0 < beta) :
    0 < precisionScale beta := by
  have hPow : (1 : Real) < (2 : Real) ^ (2 * beta) :=
    Real.one_lt_rpow (by norm_num) (by linarith)
  exact Real.sqrt_pos.mpr (by linarith)

theorem precisionScale_strictMonoOn :
    StrictMonoOn precisionScale (Set.Ioi 0) := by
  intro betaLow hLow betaHigh hHigh hBeta
  have hPow :
      (2 : Real) ^ (2 * betaLow) < (2 : Real) ^ (2 * betaHigh) :=
    Real.rpow_lt_rpow_of_exponent_lt (by norm_num) (by linarith)
  unfold precisionScale
  apply Real.sqrt_lt_sqrt
  · have hOne : (1 : Real) < (2 : Real) ^ (2 * betaLow) :=
      Real.one_lt_rpow (by norm_num) (by
        have : 0 < betaLow := hLow
        linarith)
    linarith
  · linarith

noncomputable def precisionScaleDerivative (beta : Real) : Real :=
  ((2 : Real) ^ (2 * beta) * Real.log 2) /
    (2 * precisionScale beta)

theorem precisionScale_hasDerivAt {beta : Real} (hBeta : 0 < beta) :
    HasDerivAt precisionScale (precisionScaleDerivative beta) beta := by
  have hPower :
      HasDerivAt (fun b : Real => (2 : Real) ^ (2 * b))
        ((2 : Real) ^ (2 * beta) * Real.log 2 * 2) beta := by
    have hInner : HasDerivAt (fun b : Real => 2 * b) 2 beta := by
      simpa using (hasDerivAt_id beta).const_mul (2 : Real)
    exact (Real.hasStrictDerivAt_const_rpow (by norm_num) (2 * beta)).hasDerivAt.comp beta hInner
  have hInside :
      HasDerivAt (fun b : Real => ((2 : Real) ^ (2 * b) - 1) / 2)
        ((2 : Real) ^ (2 * beta) * Real.log 2) beta := by
    convert (hPower.sub_const 1).div_const 2 using 1
    all_goals ring
  have hInsidePos : 0 < ((2 : Real) ^ (2 * beta) - 1) / 2 := by
    have hPow : (1 : Real) < (2 : Real) ^ (2 * beta) :=
      Real.one_lt_rpow (by norm_num) (by linarith)
    linarith
  convert hInside.sqrt hInsidePos.ne' using 1

theorem precisionScaleDerivative_pos {beta : Real} (hBeta : 0 < beta) :
    0 < precisionScaleDerivative beta := by
  have hPow : 0 < (2 : Real) ^ (2 * beta) :=
    Real.rpow_pos_of_pos (by norm_num) _
  have hLog : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hScale : 0 < precisionScale beta := precisionScale_pos hBeta
  unfold precisionScaleDerivative
  exact div_pos (mul_pos hPow hLog) (mul_pos (by norm_num) hScale)

theorem precisionScale_eq_inverse_difference_std
    {beta : Real} (hBeta : 0 < beta) :
    precisionScale beta = 1 / Real.sqrt (2 * signalVariance beta) := by
  let d : Real := (2 : Real) ^ (2 * beta) - 1
  have hD : 0 < d := by
    dsimp [d]
    have hPow : (1 : Real) < (2 : Real) ^ (2 * beta) :=
      Real.one_lt_rpow (by norm_num) (by linarith)
    linarith
  have hTwo : (0 : Real) <= 2 := by norm_num
  have hRewrite : 2 * (1 / d) = 2 / d := by ring
  unfold precisionScale signalVariance
  change Real.sqrt (d / 2) = 1 / Real.sqrt (2 * (1 / d))
  rw [Real.sqrt_div hD.le 2, hRewrite, Real.sqrt_div hTwo d]
  have hSqrtD : Real.sqrt d ≠ 0 := (Real.sqrt_pos.mpr hD).ne'
  have hSqrtTwo : Real.sqrt (2 : Real) ≠ 0 := by positivity
  field_simp

theorem precisionScale_tendsto_atTop : Tendsto precisionScale atTop atTop := by
  have hTwice : Tendsto (fun beta : Real => 2 * beta) atTop atTop :=
    tendsto_id.const_mul_atTop (by norm_num)
  have hLog : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hExpArg : Tendsto (fun beta : Real => 2 * beta * Real.log 2)
      atTop atTop := hTwice.atTop_mul_const hLog
  have hPow : Tendsto (fun beta : Real => (2 : Real) ^ (2 * beta))
      atTop atTop := by
    have hExp := Real.tendsto_exp_atTop.comp hExpArg
    have hPowEq : forall beta : Real,
        (2 : Real) ^ (2 * beta) =
          Real.exp (2 * beta * Real.log 2) := by
      intro beta
      rw [Real.rpow_def_of_pos (by norm_num : (0 : Real) < 2)]
      ring_nf
    apply hExp.congr'
    filter_upwards with beta
    exact (hPowEq beta).symm
  have hInside : Tendsto
      (fun beta : Real => ((2 : Real) ^ (2 * beta) - 1) / 2)
      atTop atTop := by
    have hConst : Tendsto (fun _ : Real => (-1 : Real)) atTop (nhds (-1)) :=
      tendsto_const_nhds
    have hSub : Tendsto
        (fun beta : Real => (2 : Real) ^ (2 * beta) + (-1))
        atTop atTop := hPow.atTop_add hConst
    have hDiv := hSub.atTop_div_const (by norm_num : (0 : Real) < 2)
    simpa [sub_eq_add_neg] using hDiv
  exact Real.tendsto_sqrt_atTop.comp hInside

end BlackwellDilemma.CurrentGaussian
