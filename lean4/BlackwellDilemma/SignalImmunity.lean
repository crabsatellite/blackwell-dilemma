/-
  BlackwellDilemma/SignalImmunity.lean

  Signal-immunity of the topological loss W_topo.

  Companion to: "Information Value Under Endogenous Feasibility" (Li, 2026),
  Theorem 3.1 final clause: "∂W_topo / ∂β = 0 for all signal structures".

  For any signal-parameterised family of welfare setups — where the
  probability measure, the global maximum, and the reachable-set maximum
  rStarR do not depend on the signal-precision parameter β — the
  topological loss W_topo is constant in β. Equivalently, the derivative
  with respect to β vanishes identically.

  This formalisation makes the claim a machine-checked artifact rather
  than relying on definitional inspection of the paper's equations.
-/

import BlackwellDilemma.Basic

namespace BlackwellDilemma

open MeasureTheory

/--
  A signal-parameterised welfare family.

  Only `terminalReward` depends on the signal-precision parameter
  β ∈ ℝ; `μ`, `rStar`, and `rStarR` are common across the family
  (matching the paper's setup where percolation and global reward
  structure are exogenous to the signal channel).
-/
structure SignalFamily (Ω : Type*) [MeasurableSpace Ω] where
  μ : Measure Ω
  rStar : ℝ
  rStarR : Ω → ℝ
  terminalReward : ℝ → Ω → ℝ  -- (β, ω) ↦ v_T(ω; β)
  hProb : IsProbabilityMeasure μ
  hRStarR_integrable : Integrable rStarR μ
  hTerminal_integrable : ∀ β, Integrable (terminalReward β) μ

namespace SignalFamily

variable {Ω : Type*} [MeasurableSpace Ω] (f : SignalFamily Ω)

/-- The β-slice of a signal family, viewed as a concrete WelfareSetup. -/
noncomputable def setup (β : ℝ) : WelfareSetup Ω where
  μ := f.μ
  rStar := f.rStar
  rStarR := f.rStarR
  terminalReward := f.terminalReward β
  hProb := f.hProb
  hRStarR_integrable := f.hRStarR_integrable
  hTerminal_integrable := f.hTerminal_integrable β

/--
  **Signal immunity of W_topo (Theorem 3.1, signal-immunity clause).**

  W_topo takes the same value at every β: the topological component of
  welfare cannot be influenced by any signal structure.
-/
theorem gap_W_topo_signal_immune (β₁ β₂ : ℝ) :
    (f.setup β₁).W_topo = (f.setup β₂).W_topo := by
  simp only [setup, WelfareSetup.W_topo]

/--
  **Corollary: β ↦ W_topo is a constant function.**

  There exists `c : ℝ` such that for all signal precisions β,
  `W_topo(β) = c`. Equivalently, `∂W_topo/∂β = 0` wherever the
  derivative is considered.
-/
theorem gap_W_topo_constant : ∃ c : ℝ, ∀ β : ℝ, (f.setup β).W_topo = c :=
  ⟨(f.setup 0).W_topo, fun β => f.gap_W_topo_signal_immune β 0⟩

end SignalFamily

end BlackwellDilemma
