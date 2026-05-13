/-
  BlackwellDilemma/PhysicalIrreducibility.lean

  Formalises Proposition (Physical Irreducibility of W_topo) from:
    "Information Value Under Endogenous Feasibility" (Li, 2026), §3.1.

  Statement:
    For any IDP with p > 0, any signal structure, and any decision rule δ,
        E[r(δ(s))] ≤ E_{G_p}[max_{v ∈ R(v_0)} r(v)].
    The within-reachable-set oracle attains this bound with equality
    under perfect signals.

  Formalisation scope:
    We abstract the IDP structure into the WelfareSetup framework. The
    structural constraint "agent's terminal action lies in R(v_0) a.s."
    — which the paper proves from the IDP's irreversibility primitive
    — is taken here as an explicit hypothesis `h_bound`, since the IDP
    state space is abstracted away (the Lean setup does not commit to a
    specific percolation / policy model). The hypothesis is a Prop
    condition consistent with reachability; it is **not** an axiom
    imported from the paper.
-/

import BlackwellDilemma.Basic

namespace BlackwellDilemma

open MeasureTheory

namespace WelfareSetup

variable {Ω : Type*} [MeasurableSpace Ω] (s : WelfareSetup Ω)

/--
  **Proposition (Physical Irreducibility).**

  If the terminal reward is almost-surely bounded by the within-reachable
  maximum (the structural irreversibility constraint: the agent cannot
  exit its reachable component), then the expected terminal reward is
  bounded by the oracle's expected reward.

  This inequality holds regardless of signal structure — including
  topology-aware signals — because knowing the percolation realisation
  does not unblock any edges.
-/
theorem gap_physical_irreducibility
    (h_bound : s.terminalReward ≤ᵐ[s.μ] s.rStarR) :
    ∫ ω, s.terminalReward ω ∂s.μ ≤ ∫ ω, s.rStarR ω ∂s.μ :=
  integral_mono_ae s.hTerminal_integrable s.hRStarR_integrable h_bound

/--
  **Corollary: W_info ≤ 0.**

  Under the irreversibility constraint, the informational residual is
  non-positive: the agent's welfare cannot exceed the within-reachable
  oracle benchmark.
-/
theorem gap_W_info_nonpos
    (h_bound : s.terminalReward ≤ᵐ[s.μ] s.rStarR) :
    s.W_info ≤ 0 := by
  unfold W_info
  rw [integral_sub s.hTerminal_integrable s.hRStarR_integrable]
  linarith [s.gap_physical_irreducibility h_bound]

/--
  **Oracle tightness.**

  The within-reachable oracle — a decision rule attaining
  terminalReward = rStarR a.s. under perfect signals — achieves
  W_info = 0, saturating the Physical Irreducibility bound. When the
  paper's Gaussian-signal family is specialised to β → ∞, the oracle's
  terminal reward converges to rStarR pointwise, recovering this case.
-/
theorem gap_oracle_W_info_zero
    (h_equal : s.terminalReward =ᵐ[s.μ] s.rStarR) :
    s.W_info = 0 := by
  unfold W_info
  rw [integral_sub s.hTerminal_integrable s.hRStarR_integrable]
  have h_int_eq : ∫ ω, s.terminalReward ω ∂s.μ = ∫ ω, s.rStarR ω ∂s.μ :=
    integral_congr_ae h_equal
  linarith

/--
  **Welfare upper bound.**

  Under the irreversibility constraint, the agent's welfare cannot
  exceed the within-reachable oracle's welfare (= W_topo in the
  shortfall normalisation). This is the structural statement that no
  policy — greedy, cognitive, or Bayesian — can beat the oracle.
-/
theorem gap_welfare_le_W_topo
    (h_bound : s.terminalReward ≤ᵐ[s.μ] s.rStarR) :
    s.welfare ≤ s.W_topo := by
  have hdecomp : s.welfare = s.W_topo + s.W_info := s.gap_welfare_decomposition
  have hinfo : s.W_info ≤ 0 := s.gap_W_info_nonpos h_bound
  linarith

/--
  **Oracle attains the upper bound.**

  Combining oracle_W_info_zero with the welfare decomposition: the
  oracle's welfare equals W_topo exactly, confirming that Physical
  Irreducibility's bound is tight at the oracle.
-/
theorem gap_oracle_welfare_eq_W_topo
    (h_equal : s.terminalReward =ᵐ[s.μ] s.rStarR) :
    s.welfare = s.W_topo := by
  have hdecomp : s.welfare = s.W_topo + s.W_info := s.gap_welfare_decomposition
  have hinfo : s.W_info = 0 := s.gap_oracle_W_info_zero h_equal
  linarith

end WelfareSetup

end BlackwellDilemma
