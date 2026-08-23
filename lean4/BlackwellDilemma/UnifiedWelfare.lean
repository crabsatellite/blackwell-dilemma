/-
  BlackwellDilemma/UnifiedWelfare.lean

  Probability-level welfare decomposition instantiated with the common IDP
  transition and stopping semantics from UnifiedIDP.
-/

import BlackwellDilemma.Basic
import BlackwellDilemma.UnifiedIDP
import Mathlib.Analysis.Calculus.Deriv.Basic

namespace BlackwellDilemma

open MeasureTheory

universe u v

/-- A random realized finite IDP together with one feasible policy outcome.
    The global maximum is constant across graph realizations because rewards
    are fixed while only feasibility is random. -/
structure UnifiedWelfareSetup
    (V : Type u) [Fintype V] [DecidableEq V] [Nonempty V]
    (Omega : Type v) [MeasurableSpace Omega] where
  mu : Measure Omega
  model : Omega -> IDPModel V
  start : Omega -> IDPState V
  terminalState : Omega -> IDPState V
  terminal_reaches : forall omega,
    (model omega).Reaches (start omega) (terminalState omega)
  terminal_stops : forall omega, (model omega).IsStopping (terminalState omega)
  rStar : Real
  global_value_eq_rStar : forall omega, (model omega).globalValue = rStar
  hProb : IsProbabilityMeasure mu
  hRelaxed_integrable : Integrable
    (fun omega => (model omega).relaxedOracleValue (start omega)) mu
  hOracle_integrable : Integrable
    (fun omega => (model omega).oracleValue (start omega)) mu
  hTerminal_integrable : Integrable
    (fun omega => (model omega).welfare (terminalState omega).current) mu

namespace UnifiedWelfareSetup

variable
    {V : Type u} [Fintype V] [DecidableEq V] [Nonempty V]
    {Omega : Type v} [MeasurableSpace Omega]
    (s : UnifiedWelfareSetup V Omega)

noncomputable def relaxedReward (omega : Omega) : Real :=
  (s.model omega).relaxedOracleValue (s.start omega)

noncomputable def oracleReward (omega : Omega) : Real :=
  (s.model omega).oracleValue (s.start omega)

noncomputable def terminalReward (omega : Omega) : Real :=
  (s.model omega).welfare (s.terminalState omega).current

theorem terminalReward_le_oracleReward (omega : Omega) :
    s.terminalReward omega <= s.oracleReward omega := by
  exact (s.model omega).stopping_welfare_le_oracle
    (s.terminal_reaches omega) (s.terminal_stops omega)

theorem terminalReward_le_relaxedReward (omega : Omega) :
    s.terminalReward omega <= s.relaxedReward omega := by
  exact (s.model omega).reaches_welfare_le_relaxedOracle
    (s.terminal_reaches omega)

theorem oracleReward_le_relaxedReward (omega : Omega) :
    s.oracleReward omega <= s.relaxedReward omega := by
  exact (s.model omega).oracleValue_le_relaxedOracleValue (s.start omega)

theorem relaxedReward_le_rStar (omega : Omega) :
    s.relaxedReward omega <= s.rStar := by
  rw [← s.global_value_eq_rStar omega]
  exact (s.model omega).relaxedOracleValue_le_globalValue (s.start omega)

theorem oracleReward_le_rStar (omega : Omega) :
    s.oracleReward omega <= s.rStar :=
  le_trans (s.oracleReward_le_relaxedReward omega)
    (s.relaxedReward_le_rStar omega)

/-- Algebraic welfare setup for the relaxed physical reachability benchmark. -/
noncomputable def relaxedWelfareSetup : WelfareSetup Omega :=
  WelfareSetup.mk s.mu s.rStar s.relaxedReward s.terminalReward s.hProb
    s.hRelaxed_integrable s.hTerminal_integrable

/-- Algebraic welfare setup for the attainable dynamic-oracle benchmark. -/
noncomputable def toWelfareSetup : WelfareSetup Omega :=
  WelfareSetup.mk s.mu s.rStar s.oracleReward s.terminalReward s.hProb
    s.hOracle_integrable s.hTerminal_integrable

private theorem topology_component_nonpos
    (setup : WelfareSetup Omega)
    (hBound : forall omega, setup.rStarR omega <= setup.rStar) :
    setup.W_topo <= 0 := by
  letI : IsProbabilityMeasure setup.μ := setup.hProb
  rw [WelfareSetup.W_topo, sub_nonpos]
  calc
    (∫ omega, setup.rStarR omega ∂setup.μ) <=
        ∫ _ : Omega, setup.rStar ∂setup.μ := by
      apply integral_mono_ae setup.hRStarR_integrable (integrable_const setup.rStar)
      exact Filter.Eventually.of_forall hBound
    _ = setup.rStar := by simp

theorem relaxed_welfare_decomposition :
    s.relaxedWelfareSetup.welfare =
      s.relaxedWelfareSetup.W_topo + s.relaxedWelfareSetup.W_info :=
  s.relaxedWelfareSetup.gap_welfare_decomposition

theorem relaxed_informational_residual_nonpos :
    s.relaxedWelfareSetup.W_info <= 0 :=
  s.relaxedWelfareSetup.gap_W_info_nonpos
    (Filter.Eventually.of_forall s.terminalReward_le_relaxedReward)

theorem relaxed_topology_component_nonpos :
    s.relaxedWelfareSetup.W_topo <= 0 :=
  topology_component_nonpos s.relaxedWelfareSetup s.relaxedReward_le_rStar

theorem relaxed_welfare_nonpos : s.relaxedWelfareSetup.welfare <= 0 := by
  rw [s.relaxed_welfare_decomposition]
  exact add_nonpos s.relaxed_topology_component_nonpos
    s.relaxed_informational_residual_nonpos

theorem relaxed_topology_signal_immune (beta : Real) :
    HasDerivAt (fun _ : Real => s.relaxedWelfareSetup.W_topo) 0 beta :=
  hasDerivAt_const beta s.relaxedWelfareSetup.W_topo

theorem welfare_decomposition :
    s.toWelfareSetup.welfare =
      s.toWelfareSetup.W_topo + s.toWelfareSetup.W_info :=
  s.toWelfareSetup.gap_welfare_decomposition

theorem informational_residual_nonpos :
    s.toWelfareSetup.W_info <= 0 :=
  s.toWelfareSetup.gap_W_info_nonpos
    (Filter.Eventually.of_forall s.terminalReward_le_oracleReward)

theorem dynamic_topology_component_nonpos :
    s.toWelfareSetup.W_topo <= 0 :=
  topology_component_nonpos s.toWelfareSetup s.oracleReward_le_rStar

theorem dynamic_welfare_nonpos : s.toWelfareSetup.welfare <= 0 := by
  rw [s.welfare_decomposition]
  exact add_nonpos s.dynamic_topology_component_nonpos
    s.informational_residual_nonpos

theorem welfare_le_dynamic_topology_component :
    s.toWelfareSetup.welfare <= s.toWelfareSetup.W_topo :=
  s.toWelfareSetup.gap_welfare_le_W_topo
    (Filter.Eventually.of_forall s.terminalReward_le_oracleReward)

theorem dynamic_topology_component_le_relaxed_topology_component :
    s.toWelfareSetup.W_topo <= s.relaxedWelfareSetup.W_topo := by
  change (∫ omega, s.oracleReward omega ∂s.mu) - s.rStar <=
    (∫ omega, s.relaxedReward omega ∂s.mu) - s.rStar
  apply sub_le_sub_right
  apply integral_mono_ae s.hOracle_integrable s.hRelaxed_integrable
  exact Filter.Eventually.of_forall s.oracleReward_le_relaxedReward

/-- A feasible stopping state realizes the dynamic-oracle value in every
    random outcome. -/
theorem oracle_reward_attainable (omega : Omega) :
    exists t : IDPState V,
      (s.model omega).Reaches (s.start omega) t /\
        (s.model omega).IsStopping t /\
        (s.model omega).welfare t.current = s.oracleReward omega := by
  exact (s.model omega).oracle_value_attainable (s.start omega)

/-- Welfare setup for the attainable dynamic oracle itself. -/
noncomputable def oracleWelfareSetup : WelfareSetup Omega :=
  WelfareSetup.mk s.mu s.rStar s.oracleReward s.oracleReward s.hProb
    s.hOracle_integrable s.hOracle_integrable

theorem oracle_informational_residual_zero :
    s.oracleWelfareSetup.W_info = 0 := by
  apply s.oracleWelfareSetup.gap_oracle_W_info_zero
  exact Filter.Eventually.of_forall fun _ => rfl

theorem oracle_welfare_eq_dynamic_topology_component :
    s.oracleWelfareSetup.welfare = s.oracleWelfareSetup.W_topo := by
  apply s.oracleWelfareSetup.gap_oracle_welfare_eq_W_topo
  exact Filter.Eventually.of_forall fun _ => rfl

theorem oracle_welfare_eq_agent_dynamic_topology_component :
    s.oracleWelfareSetup.welfare = s.toWelfareSetup.W_topo := by
  rw [s.oracle_welfare_eq_dynamic_topology_component]
  rfl

theorem oracle_eq_relaxed_of_terminal_complete (omega : Omega)
    (hterminalComplete : exists t : IDPState V,
      (s.model omega).Reaches (s.start omega) t /\
        (s.model omega).IsStopping t /\
        (s.model omega).welfare t.current = s.relaxedReward omega) :
    s.oracleReward omega = s.relaxedReward omega := by
  exact (s.model omega).oracleValue_eq_relaxedOracleValue_of_attainable
    (s.start omega) hterminalComplete

theorem decomposition_components_eq_of_benchmarks_eq
    (hBenchmarks : forall omega, s.oracleReward omega = s.relaxedReward omega) :
    s.toWelfareSetup.W_topo = s.relaxedWelfareSetup.W_topo /\
      s.toWelfareSetup.W_info = s.relaxedWelfareSetup.W_info := by
  have hFunctions : s.oracleReward = s.relaxedReward := funext hBenchmarks
  constructor <;>
    simp [toWelfareSetup, relaxedWelfareSetup, WelfareSetup.W_topo,
      WelfareSetup.W_info, hFunctions]

/-- Complete relaxed and strategy-aligned decomposition bundle used by the
    repaired paper theorem. -/
def UnifiedDecompositionBundle : Prop :=
  s.relaxedWelfareSetup.welfare =
      s.relaxedWelfareSetup.W_topo + s.relaxedWelfareSetup.W_info /\
    s.relaxedWelfareSetup.W_topo <= 0 /\
    s.relaxedWelfareSetup.W_info <= 0 /\
    s.relaxedWelfareSetup.welfare <= 0 /\
    (forall beta : Real,
      HasDerivAt (fun _ : Real => s.relaxedWelfareSetup.W_topo) 0 beta) /\
    s.toWelfareSetup.welfare =
      s.toWelfareSetup.W_topo + s.toWelfareSetup.W_info /\
    s.toWelfareSetup.W_topo <= 0 /\
    s.toWelfareSetup.W_info <= 0 /\
    s.toWelfareSetup.welfare <= 0 /\
    s.toWelfareSetup.welfare <= s.toWelfareSetup.W_topo /\
    (forall omega : Omega, exists t : IDPState V,
      (s.model omega).Reaches (s.start omega) t /\
        (s.model omega).IsStopping t /\
        (s.model omega).welfare t.current = s.oracleReward omega) /\
    s.oracleWelfareSetup.W_info = 0 /\
    s.oracleWelfareSetup.welfare = s.oracleWelfareSetup.W_topo /\
    (forall omega : Omega, s.oracleReward omega <= s.relaxedReward omega) /\
    ((forall omega : Omega, s.oracleReward omega = s.relaxedReward omega) ->
      s.toWelfareSetup.W_topo = s.relaxedWelfareSetup.W_topo /\
        s.toWelfareSetup.W_info = s.relaxedWelfareSetup.W_info)

theorem unifiedDecompositionBundle_proved : s.UnifiedDecompositionBundle := by
  apply And.intro s.relaxed_welfare_decomposition
  apply And.intro s.relaxed_topology_component_nonpos
  apply And.intro s.relaxed_informational_residual_nonpos
  apply And.intro s.relaxed_welfare_nonpos
  apply And.intro s.relaxed_topology_signal_immune
  apply And.intro s.welfare_decomposition
  apply And.intro s.dynamic_topology_component_nonpos
  apply And.intro s.informational_residual_nonpos
  apply And.intro s.dynamic_welfare_nonpos
  apply And.intro s.welfare_le_dynamic_topology_component
  apply And.intro s.oracle_reward_attainable
  apply And.intro s.oracle_informational_residual_zero
  apply And.intro s.oracle_welfare_eq_dynamic_topology_component
  apply And.intro s.oracleReward_le_relaxedReward
  exact s.decomposition_components_eq_of_benchmarks_eq

end UnifiedWelfareSetup

end BlackwellDilemma
