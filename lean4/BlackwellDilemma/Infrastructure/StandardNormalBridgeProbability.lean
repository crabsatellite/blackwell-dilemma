/- Kernel derivation of the finite-variance Gaussian bridge probability bounds. -/

import Mathlib.Analysis.SpecialFunctions.Gaussian.GaussianIntegral
import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic
import Mathlib.MeasureTheory.Integral.IntegralEqImproper

namespace BlackwellDilemma.Infrastructure

open MeasureTheory

noncomputable def standardNormalDensity (z : Real) : Real :=
  (1 / Real.sqrt (2 * Real.pi)) * Real.exp (-z ^ 2 / 2)

noncomputable def standardNormalCDF (x : Real) : Real :=
  (1 : Real) / 2 + ∫ t in (0 : Real)..x, standardNormalDensity t

private theorem standardNormalDensity_neg (z : Real) :
    standardNormalDensity (-z) = standardNormalDensity z := by
  unfold standardNormalDensity
  rw [neg_sq]

private theorem standardNormalDensity_continuous :
    Continuous standardNormalDensity := by
  show Continuous (fun z : Real =>
    (1 / Real.sqrt (2 * Real.pi)) * Real.exp (-z ^ 2 / 2))
  exact continuous_const.mul (((continuous_id.pow 2).neg.div_const 2).rexp)

private theorem standardNormalDensity_pos (z : Real) :
    0 < standardNormalDensity z := by
  unfold standardNormalDensity
  have hTwoPi : (0 : Real) < 2 * Real.pi :=
    mul_pos (by norm_num) Real.pi_pos
  have hSqrt : 0 < Real.sqrt (2 * Real.pi) := Real.sqrt_pos.mpr hTwoPi
  positivity

private theorem standardNormalDensity_nonneg (z : Real) :
    0 <= standardNormalDensity z := (standardNormalDensity_pos z).le

private theorem standardNormalDensity_eq_gaussian (z : Real) :
    standardNormalDensity z =
      (1 / Real.sqrt (2 * Real.pi)) * Real.exp (-(1 / 2) * z ^ 2) := by
  unfold standardNormalDensity
  congr 1
  congr 1
  ring

private theorem standardNormalDensity_integral_Ioi_zero :
    ∫ t in Set.Ioi (0 : Real), standardNormalDensity t = (1 : Real) / 2 := by
  have hGaussian :
      (∫ t in Set.Ioi (0 : Real), Real.exp (-(1 / 2) * t ^ 2)) =
        Real.sqrt (Real.pi / (1 / 2)) / 2 :=
    integral_gaussian_Ioi (1 / 2)
  have hPiDiv : Real.pi / (1 / 2 : Real) = 2 * Real.pi := by ring
  rw [hPiDiv] at hGaussian
  have hDensity : (fun t : Real => standardNormalDensity t) =
      fun t => (1 / Real.sqrt (2 * Real.pi)) *
        Real.exp (-(1 / 2) * t ^ 2) := by
    funext t
    exact standardNormalDensity_eq_gaussian t
  rw [hDensity, integral_const_mul, hGaussian]
  have hSqrt : 0 < Real.sqrt (2 * Real.pi) :=
    Real.sqrt_pos.mpr (mul_pos (by norm_num) Real.pi_pos)
  field_simp

private theorem standardNormalDensity_integrableOn_Ioi_zero :
    IntegrableOn standardNormalDensity (Set.Ioi (0 : Real)) := by
  have hDensity : (fun t : Real => standardNormalDensity t) =
      fun t => (1 / Real.sqrt (2 * Real.pi)) *
        Real.exp (-(1 / 2) * t ^ 2) := by
    funext t
    exact standardNormalDensity_eq_gaussian t
  rw [show standardNormalDensity =
      (fun t : Real => (1 / Real.sqrt (2 * Real.pi)) *
        Real.exp (-(1 / 2) * t ^ 2)) from hDensity]
  apply Integrable.integrableOn
  apply Integrable.const_mul
  exact integrable_exp_neg_mul_sq (by norm_num : (0 : Real) < 1 / 2)

private theorem standardNormalCDF_neg (x : Real) :
    standardNormalCDF (-x) =
      (1 : Real) / 2 - ∫ t in (0 : Real)..x, standardNormalDensity t := by
  unfold standardNormalCDF
  have hCompNeg :
      (∫ s in (0 : Real)..x, standardNormalDensity (-s)) =
        ∫ s in (-x)..(-(0 : Real)), standardNormalDensity s :=
    intervalIntegral.integral_comp_neg standardNormalDensity
  simp only [neg_zero] at hCompNeg
  have hEven :
      (∫ s in (0 : Real)..x, standardNormalDensity (-s)) =
        ∫ s in (0 : Real)..x, standardNormalDensity s := by
    apply intervalIntegral.integral_congr
    intro s _
    exact standardNormalDensity_neg s
  rw [hEven] at hCompNeg
  have hSymm :
      (∫ s in (-x : Real)..0, standardNormalDensity s) =
        -(∫ s in (0 : Real)..(-x), standardNormalDensity s) := by
    rw [intervalIntegral.integral_symm]
  rw [hSymm] at hCompNeg
  linarith

private theorem standardNormalDensity_tail_pos (x : Real) :
    0 < ∫ t in Set.Ioi x, standardNormalDensity t := by
  have hDensity : (fun t : Real => standardNormalDensity t) =
      fun t => (1 / Real.sqrt (2 * Real.pi)) *
        Real.exp (-(1 / 2) * t ^ 2) := by
    funext t
    exact standardNormalDensity_eq_gaussian t
  have hIntegrable : IntegrableOn standardNormalDensity (Set.Ioi x) := by
    rw [show standardNormalDensity =
        (fun t : Real => (1 / Real.sqrt (2 * Real.pi)) *
          Real.exp (-(1 / 2) * t ^ 2)) from hDensity]
    apply Integrable.integrableOn
    apply Integrable.const_mul
    exact integrable_exp_neg_mul_sq (by norm_num : (0 : Real) < 1 / 2)
  have hNonneg :
      0 ≤ᵐ[volume.restrict (Set.Ioi x)] standardNormalDensity :=
    Filter.Eventually.of_forall standardNormalDensity_nonneg
  rw [setIntegral_pos_iff_support_of_nonneg_ae hNonneg hIntegrable]
  have hSupport : Function.support standardNormalDensity = Set.univ := by
    ext t
    simp only [Function.mem_support, Set.mem_univ, iff_true]
    exact (standardNormalDensity_pos t).ne'
  rw [hSupport, Set.univ_inter]
  exact Measure.measure_Ioi_pos volume x

theorem standardNormalCDF_pos_of_neg {x : Real} (hx : x < 0) :
    0 < standardNormalCDF x := by
  set y : Real := -x with hy
  have hyPos : 0 < y := by simp [hy]; linarith
  have hxEq : x = -y := by simp [hy]
  rw [hxEq, standardNormalCDF_neg]
  have hSplit :
      (∫ t in Set.Ioi (0 : Real), standardNormalDensity t) -
          (∫ t in Set.Ioi y, standardNormalDensity t) =
        ∫ t in (0 : Real)..y, standardNormalDensity t :=
    intervalIntegral.integral_Ioi_sub_Ioi
      standardNormalDensity_integrableOn_Ioi_zero hyPos.le
  rw [standardNormalDensity_integral_Ioi_zero] at hSplit
  have hTail := standardNormalDensity_tail_pos y
  linarith

theorem standardNormalCDF_lt_half_of_neg {x : Real} (hx : x < 0) :
    standardNormalCDF x < (1 : Real) / 2 := by
  set y : Real := -x with hy
  have hyPos : 0 < y := by simp [hy]; linarith
  have hxEq : x = -y := by simp [hy]
  rw [hxEq, standardNormalCDF_neg]
  have hIntegral :
      0 < ∫ t in (0 : Real)..y, standardNormalDensity t :=
    intervalIntegral.intervalIntegral_pos_of_pos
      (standardNormalDensity_continuous.intervalIntegrable 0 y)
      standardNormalDensity_pos hyPos
  linarith

noncomputable def gaussianBridgeProbability
    (delta variance : Real) : Real :=
  standardNormalCDF (-(delta / Real.sqrt (2 * variance)))

theorem gaussianBridgeProbability_mem_openInterval
    {delta variance : Real} (hDelta : 0 < delta) (hVariance : 0 < variance) :
    0 < gaussianBridgeProbability delta variance /\
      gaussianBridgeProbability delta variance < (1 : Real) / 2 := by
  have hDenominator : 0 < Real.sqrt (2 * variance) := by
    exact Real.sqrt_pos.mpr (mul_pos (by norm_num) hVariance)
  have hArgument : -(delta / Real.sqrt (2 * variance)) < 0 :=
    neg_lt_zero.mpr (div_pos hDelta hDenominator)
  exact
    ⟨standardNormalCDF_pos_of_neg hArgument,
      standardNormalCDF_lt_half_of_neg hArgument⟩

def GaussianBridgeProbabilityPrinciple : Prop :=
  forall delta variance : Real,
    0 < delta -> 0 < variance ->
      0 < gaussianBridgeProbability delta variance /\
        gaussianBridgeProbability delta variance < (1 : Real) / 2

theorem gaussianBridgeProbabilityPrinciple_proved :
    GaussianBridgeProbabilityPrinciple := by
  intro delta variance hDelta hVariance
  exact gaussianBridgeProbability_mem_openInterval hDelta hVariance

end BlackwellDilemma.Infrastructure
