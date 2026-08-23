/-
  BlackwellDilemma/Basic.lean

  Welfare decomposition for the Irreversibility Decision Problem.

  Companion to: "Information Value Under Endogenous Feasibility" (Li, 2026).
  Formalises Theorem 3.1 (Canonical Welfare Decomposition).

  Scope:
    The decomposition `W = W_topo + W_info` is an algebraic identity that
    holds for **any** agent policy (greedy, Bayesian, or otherwise) and
    **any** signal structure. We abstract over the specific IDP components
    (graph, percolation, policy) and state the identity at the level of
    a probability space; the conclusion follows from linearity of the
    Bochner integral. The IDP-specific objects are formalised in
    `BlackwellDilemma/Types.lean`.
-/

import Mathlib.MeasureTheory.Integral.Bochner.Basic

namespace BlackwellDilemma

open MeasureTheory

/--
  Abstract welfare setup capturing the minimum structure for the
  Canonical Welfare Decomposition (Theorem 3.1 of the paper).

  Fields:
  * `μ`: probability measure on the outcome space `Ω`, jointly encoding
     the percolation realisation and signal-draw randomness.
  * `rStar`: the global reward maximum `r* = max_{v ∈ V} r(v)`,
     a deterministic constant of the IDP instance.
  * `rStarR`: the within-reachable-set maximum
     `r*_R(ω) = max_{v ∈ R(v_0, ω)} r(v)`, a function of the realisation
     (specifically, of the percolation component of ω) — **signal-independent**.
  * `terminalReward`: the agent's terminal reward `r(v_T(ω))`; depends on
     both percolation and signal draws.

  Integrability assumptions `hRStarR_integrable` and `hTerminal_integrable`
  hold automatically under the paper's standing assumption of bounded
  rewards `r : V → [0, 1]`; we state them explicitly here to allow the
  formalisation to extend to unbounded-reward settings later.
-/
structure WelfareSetup (Ω : Type*) [MeasurableSpace Ω] where
  μ : Measure Ω
  rStar : ℝ
  rStarR : Ω → ℝ
  terminalReward : Ω → ℝ
  hProb : IsProbabilityMeasure μ
  hRStarR_integrable : Integrable rStarR μ
  hTerminal_integrable : Integrable terminalReward μ

namespace WelfareSetup

variable {Ω : Type*} [MeasurableSpace Ω] (s : WelfareSetup Ω)

/--
  Total welfare shortfall (paper Theorem 3.1, line ~238):

    `W = E[r(v_T)] - r*`

  Non-positive when the global maximum dominates terminal rewards.
-/
noncomputable def welfare : ℝ :=
  ∫ ω, s.terminalReward ω ∂s.μ - s.rStar

/--
  Topological loss:

    `W_topo(p) = E[r*_R] - r*`

  Signal-immune: depends only on the percolation measure, not on the
  signal structure nor on the agent policy. Captures the welfare
  shortfall attributable purely to the best reachable action being worse
  than the global optimum (irreducible by any informational intervention).
-/
noncomputable def W_topo : ℝ :=
  ∫ ω, s.rStarR ω ∂s.μ - s.rStar

/--
  Informational residual:

    `W_info = W - W_topo = E[r(v_T) - r*_R]`

  Captures the gap between the agent's realised welfare and the
  within-reachable-set oracle benchmark. Blackwell-ordered for the
  oracle policy; non-monotone for greedy and cognitive-boundary agents
  under topology-blind signals.
-/
noncomputable def W_info : ℝ :=
  ∫ ω, (s.terminalReward ω - s.rStarR ω) ∂s.μ

/--
  **Theorem 3.1 (Canonical Welfare Decomposition).**

  For any IDP instance, any agent policy, and any signal structure,
  total welfare admits the decomposition

    `W = W_topo + W_info`

  as an algebraic identity. The proof is a direct consequence of
  linearity of the Bochner integral.
-/
theorem gap_welfare_decomposition : s.welfare = s.W_topo + s.W_info := by
  unfold welfare W_topo W_info
  rw [integral_sub s.hTerminal_integrable s.hRStarR_integrable]
  ring

theorem gap_physical_irreducibility
    (hBound : s.terminalReward ≤ᵐ[s.μ] s.rStarR) :
    ∫ omega, s.terminalReward omega ∂s.μ <=
      ∫ omega, s.rStarR omega ∂s.μ :=
  integral_mono_ae s.hTerminal_integrable s.hRStarR_integrable hBound

theorem gap_W_info_nonpos
    (hBound : s.terminalReward ≤ᵐ[s.μ] s.rStarR) :
    s.W_info <= 0 := by
  unfold W_info
  rw [integral_sub s.hTerminal_integrable s.hRStarR_integrable]
  linarith [s.gap_physical_irreducibility hBound]

theorem gap_oracle_W_info_zero
    (hEqual : s.terminalReward =ᵐ[s.μ] s.rStarR) :
    s.W_info = 0 := by
  unfold W_info
  rw [integral_sub s.hTerminal_integrable s.hRStarR_integrable]
  have hIntegral :
      ∫ omega, s.terminalReward omega ∂s.μ =
        ∫ omega, s.rStarR omega ∂s.μ := integral_congr_ae hEqual
  linarith

theorem gap_welfare_le_W_topo
    (hBound : s.terminalReward ≤ᵐ[s.μ] s.rStarR) :
    s.welfare <= s.W_topo := by
  rw [s.gap_welfare_decomposition]
  linarith [s.gap_W_info_nonpos hBound]

theorem gap_oracle_welfare_eq_W_topo
    (hEqual : s.terminalReward =ᵐ[s.μ] s.rStarR) :
    s.welfare = s.W_topo := by
  rw [s.gap_welfare_decomposition, s.gap_oracle_W_info_zero hEqual, add_zero]

end WelfareSetup

end BlackwellDilemma
