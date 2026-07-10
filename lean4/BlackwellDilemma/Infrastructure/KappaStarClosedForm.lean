/- Divergence of the depth-dependent closed form displayed in the paper. -/

import BlackwellDilemma.Infrastructure.FiniteTorusLocalSupports
import Mathlib.Analysis.SpecialFunctions.Log.Base

namespace BlackwellDilemma.Infrastructure

open Filter Topology

/-- The displayed expression `(1/2) log_2 (d^2 / c + 1)`. This definition is
not identified with the paper's actual posterior threshold; that identity
requires a separate theorem about the IDP estimator. -/
noncomputable def kappaStarClosedForm
    (c : Real) (depth : Nat) : Real :=
  (1 / 2 : Real) *
    Real.logb 2 (((depth : Real) ^ 2) / c + 1)

theorem kappaStarClosedForm_inner_tendsto_atTop
    (c : Real) (hC : 0 < c) :
    Tendsto (fun depth : Nat =>
      ((depth : Real) ^ 2) / c + 1) atTop atTop := by
  have hCast : Tendsto (fun depth : Nat => (depth : Real)) atTop atTop :=
    tendsto_natCast_atTop_atTop
  have hSquareMul : Tendsto (fun depth : Nat =>
      (depth : Real) * (depth : Real)) atTop atTop :=
    hCast.atTop_mul_atTop₀ hCast
  have hSquare : Tendsto (fun depth : Nat =>
      (depth : Real) ^ 2) atTop atTop := by
    simpa [pow_two] using hSquareMul
  have hDiv : Tendsto (fun depth : Nat =>
      ((depth : Real) ^ 2) / c) atTop atTop :=
    Tendsto.atTop_div_const hC hSquare
  exact tendsto_atTop_add_const_right atTop 1 hDiv

theorem kappaStarClosedForm_tendsto_atTop
    (c : Real) (hC : 0 < c) :
    Tendsto (kappaStarClosedForm c) atTop atTop := by
  have hLog : Tendsto (fun depth : Nat =>
      Real.logb 2 (((depth : Real) ^ 2) / c + 1)) atTop atTop :=
    (Real.tendsto_logb_atTop (b := (2 : Real)) (by norm_num)).comp
      (kappaStarClosedForm_inner_tendsto_atTop c hC)
  unfold kappaStarClosedForm
  exact Tendsto.const_mul_atTop
    (by norm_num : (0 : Real) < 1 / 2) hLog

theorem kappaStarClosedForm_cofinal
    (c : Real) (hC : 0 < c) :
    forall bound : Real,
      exists depth : Nat, bound < kappaStarClosedForm c depth := by
  intro bound
  exact ((kappaStarClosedForm_tendsto_atTop c hC).eventually
    (eventually_gt_atTop bound)).exists

def KappaStarClosedFormDivergencePrinciple : Prop :=
  forall c : Real, 0 < c ->
    Tendsto (kappaStarClosedForm c) atTop atTop /\
      forall bound : Real,
        exists depth : Nat, bound < kappaStarClosedForm c depth

theorem kappaStarClosedFormDivergencePrinciple_proved :
    KappaStarClosedFormDivergencePrinciple := by
  intro c hC
  exact And.intro
    (kappaStarClosedForm_tendsto_atTop c hC)
    (kappaStarClosedForm_cofinal c hC)

def Part6DepthGrowthKernelBundle : Prop :=
  Part6FiniteTorusSupportKernelBundle /\
    KappaStarClosedFormDivergencePrinciple

theorem part6DepthGrowthKernelBundle_proved :
    Part6DepthGrowthKernelBundle := by
  exact And.intro
    part6FiniteTorusSupportKernelBundle_proved
    kappaStarClosedFormDivergencePrinciple_proved

end BlackwellDilemma.Infrastructure
