/-
  BlackwellDilemma/UnifiedGreedyReversal.lean

  Generic forced-continuation two-route model for the paper's wrongness lemma
  and central welfare-reversal theorem.
-/

import BlackwellDilemma.ClassicalResults

namespace BlackwellDilemma.GreedyReversal

open Filter

/-- The graph-to-model reduction used by the publication theorem: the root
    has two signal-ranked routes and each selected route has a fixed terminal
    payoff because continuation is forced. -/
structure ForcedTwoRouteModel where
  trapImmediate : Real
  bridgeImmediate : Real
  trapTerminal : Real
  bridgeTerminal : Real
  immediateMisalignment : bridgeImmediate < trapImmediate
  terminalMisalignment : trapTerminal < bridgeTerminal

namespace ForcedTwoRouteModel

noncomputable def immediateGap (M : ForcedTwoRouteModel) : Real :=
  M.trapImmediate - M.bridgeImmediate

theorem immediateGap_pos (M : ForcedTwoRouteModel) : 0 < M.immediateGap := by
  unfold immediateGap
  linarith [M.immediateMisalignment]

noncomputable def trapProbability
    (M : ForcedTwoRouteModel) (beta : Real) : Real :=
  Phi (M.immediateGap / Real.sqrt (2 * signalVariance beta))

noncomputable def bridgeProbability
    (M : ForcedTwoRouteModel) (beta : Real) : Real :=
  1 - M.trapProbability beta

noncomputable def welfare
    (M : ForcedTwoRouteModel) (beta : Real) : Real :=
  M.trapProbability beta * M.trapTerminal +
    M.bridgeProbability beta * M.bridgeTerminal

theorem routeProbability_sum_one (M : ForcedTwoRouteModel) (beta : Real) :
    M.trapProbability beta + M.bridgeProbability beta = 1 := by
  simp [bridgeProbability]

theorem bridgeProbability_pos (M : ForcedTwoRouteModel) (beta : Real) :
    0 < M.bridgeProbability beta := by
  unfold bridgeProbability trapProbability
  linarith [Phi_lt_one
    (M.immediateGap / Real.sqrt (2 * signalVariance beta))]

theorem welfare_sub_perfectSignal
    (M : ForcedTwoRouteModel) (beta : Real) :
    M.welfare beta - M.trapTerminal =
      M.bridgeProbability beta * (M.bridgeTerminal - M.trapTerminal) := by
  unfold welfare
  rw [show M.trapProbability beta = 1 - M.bridgeProbability beta by
    simp [bridgeProbability]]
  ring

theorem finite_precision_overshoot
    (M : ForcedTwoRouteModel) (beta : Real) :
    M.trapTerminal < M.welfare beta := by
  apply sub_pos.mp
  rw [welfare_sub_perfectSignal]
  exact mul_pos (M.bridgeProbability_pos beta)
    (sub_pos.mpr M.terminalMisalignment)

theorem trapProbability_tendsto_one_atTop (M : ForcedTwoRouteModel) :
    Tendsto M.trapProbability atTop (nhds 1) := by
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
    have hPow : (1 : Real) < (2 : Real) ^ (2 * beta) :=
      Real.one_lt_rpow (by norm_num) (by linarith)
    have hVariance : 0 < signalVariance beta := by
      exact one_div_pos.mpr (by linarith)
    exact Real.sqrt_pos.mpr (mul_pos (by norm_num) hVariance)
  have hArgument : Tendsto
      (fun beta : Real =>
        M.immediateGap / Real.sqrt (2 * signalVariance beta))
      atTop atTop :=
    tendsto_const_div_atTop_of_tendsto_zero_pos
      M.immediateGap M.immediateGap_pos
      (fun beta => Real.sqrt (2 * signalVariance beta)) hSqrt hSqrtPos
  exact Phi_tendsto_one_atTop.comp hArgument

theorem bridgeProbability_tendsto_zero_atTop (M : ForcedTwoRouteModel) :
    Tendsto M.bridgeProbability atTop (nhds 0) := by
  have hConst : Tendsto (fun _ : Real => (1 : Real)) atTop (nhds 1) :=
    tendsto_const_nhds
  simpa [bridgeProbability] using hConst.sub M.trapProbability_tendsto_one_atTop

theorem welfare_tendsto_perfectSignal (M : ForcedTwoRouteModel) :
    Tendsto M.welfare atTop (nhds M.trapTerminal) := by
  have hTrap := M.trapProbability_tendsto_one_atTop
  have hBridge := M.bridgeProbability_tendsto_zero_atTop
  unfold welfare
  simpa using (hTrap.mul_const M.trapTerminal).add
    (hBridge.mul_const M.bridgeTerminal)

theorem exists_strict_reversal_pair (M : ForcedTwoRouteModel) :
    exists beta beta' : Real,
      beta < beta' /\ M.welfare beta' < M.welfare beta := by
  have hOvershoot : M.trapTerminal < M.welfare 1 :=
    M.finite_precision_overshoot 1
  have hEventuallyWelfare :
      ∀ᶠ beta' : Real in atTop, M.welfare beta' < M.welfare 1 :=
    M.welfare_tendsto_perfectSignal.eventually (Iio_mem_nhds hOvershoot)
  have hEventuallyBeta : ∀ᶠ beta' : Real in atTop, 1 < beta' :=
    eventually_gt_atTop 1
  obtain ⟨beta', hWelfare, hBeta⟩ :=
    (hEventuallyWelfare.and hEventuallyBeta).exists
  exact ⟨1, beta', hBeta, hWelfare⟩

end ForcedTwoRouteModel

def WrongnessClaim : Prop :=
  forall M : ForcedTwoRouteModel,
    (forall beta : Real, M.trapTerminal < M.welfare beta) /\
      Tendsto M.welfare atTop (nhds M.trapTerminal) /\
      exists beta beta' : Real,
        beta < beta' /\ M.welfare beta' < M.welfare beta

theorem wrongnessClaim_proved : WrongnessClaim := by
  intro M
  exact ⟨M.finite_precision_overshoot,
    M.welfare_tendsto_perfectSignal,
    M.exists_strict_reversal_pair⟩

def DilemmaClaim : Prop :=
  forall M : ForcedTwoRouteModel,
    (exists beta beta' : Real,
      beta < beta' /\ M.welfare beta' < M.welfare beta) /\
    (forall beta : Real, M.trapTerminal < M.welfare beta)

theorem dilemmaClaim_proved : DilemmaClaim := by
  intro M
  exact ⟨M.exists_strict_reversal_pair, M.finite_precision_overshoot⟩

end BlackwellDilemma.GreedyReversal
