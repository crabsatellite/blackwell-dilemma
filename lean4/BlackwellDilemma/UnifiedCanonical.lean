/-
  BlackwellDilemma/UnifiedCanonical.lean

  Explicit finite routing distribution for the four-state canonical IDP.
  The standard Gaussian difference law determines the trap probability;
  expected terminal welfare is then derived by summing over route outcomes.
-/

import BlackwellDilemma.ClassicalResults

namespace BlackwellDilemma.CanonicalGaussianRoute

open Filter

noncomputable def rA : Real := (6 : Real) / 10
noncomputable def rB : Real := (4 : Real) / 10
def rG : Real := 1
noncomputable def rewardGap : Real := rA - rB

/-- Probability of routing to the terminal trap under the standard Gaussian
    difference law for two independent reward signals. -/
noncomputable def trapProbability (beta : Real) : Real :=
  Phi (rewardGap / Real.sqrt (2 * signalVariance beta))

/-- `true` is the trap route and `false` is the bridge-to-goal route. -/
noncomputable def routeProbability (beta : Real) (outcome : Bool) : Real :=
  if outcome then trapProbability beta else 1 - trapProbability beta

noncomputable def terminalReward (outcome : Bool) : Real :=
  if outcome then rA else rG

/-- Finite expected terminal reward induced by the route distribution. -/
noncomputable def expectedReward (beta : Real) : Real :=
  ∑ outcome : Bool, routeProbability beta outcome * terminalReward outcome

theorem trapProbability_mem_unitInterval (beta : Real) :
    trapProbability beta ∈ Set.Icc (0 : Real) 1 := by
  exact ⟨Phi_nonneg _, Phi_le_one _⟩

theorem routeProbability_nonneg (beta : Real) (outcome : Bool) :
    0 <= routeProbability beta outcome := by
  cases outcome <;>
    simp [routeProbability, (trapProbability_mem_unitInterval beta).1,
      (trapProbability_mem_unitInterval beta).2]

theorem routeProbability_sum_one (beta : Real) :
    ∑ outcome : Bool, routeProbability beta outcome = 1 := by
  simp [routeProbability]

theorem expectedReward_formula (beta : Real) :
    expectedReward beta =
      trapProbability beta * rA + (1 - trapProbability beta) * rG := by
  simp [expectedReward, routeProbability, terminalReward]

theorem rewardGap_pos : 0 < rewardGap := by
  norm_num [rewardGap, rA, rB]

theorem trapProbability_tendsto_one_atTop :
    Tendsto trapProbability atTop (nhds 1) := by
  have hSigma : Tendsto signalVariance atTop (nhds 0) :=
    signalVariance_tendsto_zero_atTop
  have hTwoSigma : Tendsto (fun beta : Real => 2 * signalVariance beta)
      atTop (nhds 0) := by
    simpa using hSigma.const_mul (2 : Real)
  have hSqrt : Tendsto
      (fun beta : Real => Real.sqrt (2 * signalVariance beta))
      atTop (nhds 0) := by
    simpa only [Function.comp_apply, Real.sqrt_zero] using
      (Real.continuous_sqrt.tendsto 0).comp hTwoSigma
  have hSqrtPos :
      ∀ᶠ beta : Real in atTop,
        0 < Real.sqrt (2 * signalVariance beta) := by
    filter_upwards [eventually_gt_atTop (0 : Real)] with beta hBeta
    have hPow : (1 : Real) < (2 : Real) ^ (2 * beta) := by
      exact Real.one_lt_rpow (by norm_num) (by linarith)
    have hVariance : 0 < signalVariance beta := by
      exact one_div_pos.mpr (by linarith)
    exact Real.sqrt_pos.mpr (mul_pos (by norm_num) hVariance)
  have hArgument : Tendsto
      (fun beta : Real =>
        rewardGap / Real.sqrt (2 * signalVariance beta))
      atTop atTop :=
    tendsto_const_div_atTop_of_tendsto_zero_pos rewardGap rewardGap_pos
      (fun beta => Real.sqrt (2 * signalVariance beta)) hSqrt hSqrtPos
  exact Phi_tendsto_one_atTop.comp hArgument

theorem expectedReward_tendsto_trapReward :
    Tendsto expectedReward atTop (nhds rA) := by
  have hTrap := trapProbability_tendsto_one_atTop
  have hOneMinus : Tendsto (fun beta : Real => 1 - trapProbability beta)
      atTop (nhds 0) := by
    have hConst : Tendsto (fun _ : Real => (1 : Real)) atTop (nhds 1) :=
      tendsto_const_nhds
    simpa only [sub_self] using hConst.sub hTrap
  have hFormula : expectedReward = fun beta =>
      trapProbability beta * rA + (1 - trapProbability beta) * rG := by
    funext beta
    exact expectedReward_formula beta
  rw [hFormula]
  simpa only [one_mul, zero_mul, add_zero] using
    (hTrap.mul_const rA).add (hOneMinus.mul_const rG)

/-- Exact machine target for manuscript Proposition `prop:canonical`. -/
def CanonicalWelfareClaim : Prop :=
  (forall beta : Real,
    expectedReward beta =
      Phi (rewardGap / Real.sqrt (2 * signalVariance beta)) * rA +
        (1 - Phi (rewardGap / Real.sqrt (2 * signalVariance beta))) * rG) /\
  Tendsto trapProbability atTop (nhds 1) /\
  Tendsto expectedReward atTop (nhds rA)

theorem canonicalWelfareClaim_proved : CanonicalWelfareClaim := by
  exact
    ⟨fun beta => by simpa [trapProbability] using expectedReward_formula beta,
      trapProbability_tendsto_one_atTop,
      expectedReward_tendsto_trapReward⟩

end BlackwellDilemma.CanonicalGaussianRoute
