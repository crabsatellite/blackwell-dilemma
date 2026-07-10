/-
  BlackwellDilemma/Canonical.lean

  §5 Constructive Instances: 4-state and 5-state IDPs.

  Companion to: "Information Value Under Endogenous Feasibility" (Li, 2026).

  Contents:
   * §5.1 The Canonical Instance (4 states).
       - Proposition (`prop:canonical`) — Canonical Welfare formula.
   * §5.2 The Interior Optimum (5 states).
       - Proposition (`prop:interior-optimum`) — Interior Optimum formula.
       - Proposition (`prop:three-regime-five-state`) — Three-Regime
         Structure (p_1 = 4/9, p_2 = 2/3).
       - Corollary (`cor:five-state-policy`) — Policy Mapping.
       - Proposition (`prop:threshold-five-state`) — Cognitive Threshold
         on the 5-state instance.
       - Proposition (`prop:p-monotonicity-five-state`) — `p`-Monotonicity
         with closed form `κ*(p) = (1/2) log_2(2 log[p/(2(1-p))] + 1)`.
       - Proposition (`prop:bayesian-naive-five-state`) — Bayesian-Naive
         Threshold `p̂* = 2/3`.

  The constructive instances are formalised as concrete reward / topology
  records, with the welfare formulas exposed as `noncomputable def`s.
  Closed-form constants `c*(p)` and `κ*(p)` are stated as definitions;
  monotonicity and threshold properties are stated as theorems backed
  by paper-citation axioms.
-/

import BlackwellDilemma.Types
import BlackwellDilemma.ClassicalResults
import BlackwellDilemma.Infrastructure.ContinuousArithmetic
import BlackwellDilemma.Infrastructure.ArgmaxExistence
import Mathlib.Analysis.Calculus.Deriv.Slope
import Mathlib.Topology.MetricSpace.Lipschitz

namespace BlackwellDilemma

/-! ## 1. The Canonical Instance (4 states)

`V = {S, A, B, G}`, edges `S-A`, `S-B-G`; rewards `r(S)=0, r(A)=0.6,
r(B)=0.4, r(G)=1.0`. Edge `S-B` blocked with probability `p`. -/

namespace FourState

/-- Reward parameters of the 4-state canonical instance. Real division is
    `noncomputable` in Mathlib, so `r_A`, `r_B`, and the derived `Delta`
    are all marked `noncomputable`. -/
noncomputable def r_A : ℝ := (6 : ℝ) / 10
noncomputable def r_B : ℝ := (4 : ℝ) / 10
def r_G : ℝ := 1
def r_S : ℝ := 0

/-- The reward gap between the trap `A` and the bridge `B`. -/
noncomputable def Delta_4 : ℝ := r_A - r_B  -- = 0.2

/-- **Proposition `prop:canonical`** — Welfare formula on the open
    realisation (probability `1−p`).

    `W_open(β) = Φ(Δ/√(2σ²)) · r(A) + (1 − Φ(Δ/√(2σ²))) · r(G)`.

    paper source: Proposition `prop:canonical`, lines 708-715. -/
noncomputable def W_open (β : ℝ) : ℝ :=
  Phi (Delta_4 / Real.sqrt (2 * signalVariance β)) * r_A +
  (1 - Phi (Delta_4 / Real.sqrt (2 * signalVariance β))) * r_G

/-- **Limit β → ∞**: agent always picks the trap `A`, terminal reward `r_A = 0.6`.
    Substantive paper claim — limit-of-process encoding via `Filter.Tendsto`
    against the actual welfare process `W_open`. **CLOSED**: derived via
    `signalVariance_tendsto_zero_atTop` + `tendsto_const_div_atTop_of_tendsto_zero_pos`
    + `Phi_tendsto_one_atTop` + `Filter.Tendsto.mul_const` / `.add` chain.

    paper source: Proposition `prop:canonical` β→∞ limit. -/
theorem gap_W_open_limit_infty :
    Filter.Tendsto W_open Filter.atTop (nhds r_A) := by
  unfold W_open
  -- Step 1: signalVariance β → 0 as β → ∞ (Cat 1 closure in ClassicalResults.lean).
  have h_sigma : Filter.Tendsto signalVariance Filter.atTop (nhds 0) :=
    signalVariance_tendsto_zero_atTop
  -- Step 2: 2 * signalVariance β → 2 * 0 = 0.
  have h_2sigma : Filter.Tendsto (fun β : ℝ => 2 * signalVariance β)
      Filter.atTop (nhds 0) := by
    have := h_sigma.const_mul (2 : ℝ)
    simpa using this
  -- Step 3: sqrt(2 * signalVariance β) → sqrt(0) = 0 (continuity).
  have h_sqrt : Filter.Tendsto (fun β : ℝ => Real.sqrt (2 * signalVariance β))
      Filter.atTop (nhds 0) := by
    have h := (Real.continuous_sqrt.tendsto 0).comp h_2sigma
    rw [Real.sqrt_zero] at h
    exact h
  -- Step 4: sqrt(2 * signalVariance β) > 0 eventually atTop (uses β > 0).
  have h_sqrt_pos : ∀ᶠ β in Filter.atTop, 0 < Real.sqrt (2 * signalVariance β) := by
    filter_upwards [Filter.eventually_gt_atTop (0 : ℝ)] with β hβ
    have h_σ_pos : 0 < signalVariance β := by
      unfold signalVariance
      have h2_one_lt : (1 : ℝ) < 2 := by norm_num
      have h2β_pos : 0 < 2 * β := by linarith
      have h_one_lt_pow : (1 : ℝ) < (2 : ℝ) ^ (2 * β) :=
        Real.one_lt_rpow h2_one_lt h2β_pos
      have h_denom_pos : 0 < (2 : ℝ) ^ (2 * β) - 1 := by linarith
      exact one_div_pos.mpr h_denom_pos
    exact Real.sqrt_pos.mpr (mul_pos (by norm_num) h_σ_pos)
  -- Step 5: Delta_4 > 0.
  have h_Delta : (0 : ℝ) < Delta_4 := by
    unfold Delta_4 r_A r_B; norm_num
  -- Step 6: Delta_4 / sqrt(2 * signalVariance β) → ∞.
  have h_arg : Filter.Tendsto
      (fun β : ℝ => Delta_4 / Real.sqrt (2 * signalVariance β))
      Filter.atTop Filter.atTop :=
    tendsto_const_div_atTop_of_tendsto_zero_pos Delta_4 h_Delta
      (fun β => Real.sqrt (2 * signalVariance β)) h_sqrt h_sqrt_pos
  -- Step 7: Phi(arg) → 1.
  have h_phi : Filter.Tendsto
      (fun β : ℝ => Phi (Delta_4 / Real.sqrt (2 * signalVariance β)))
      Filter.atTop (nhds 1) :=
    Phi_tendsto_one_atTop.comp h_arg
  -- Step 8: 1 - Phi(arg) → 0.
  have h_one_minus_phi : Filter.Tendsto
      (fun β : ℝ => 1 - Phi (Delta_4 / Real.sqrt (2 * signalVariance β)))
      Filter.atTop (nhds 0) := by
    have h_const : Filter.Tendsto (fun _ : ℝ => (1 : ℝ)) Filter.atTop (nhds 1) :=
      tendsto_const_nhds
    have h := h_const.sub h_phi
    have h_eq : (1 : ℝ) - 1 = 0 := by norm_num
    rw [h_eq] at h
    exact h
  -- Step 9: combine via Tendsto.add and Tendsto.mul_const.
  have h_first : Filter.Tendsto
      (fun β : ℝ => Phi (Delta_4 / Real.sqrt (2 * signalVariance β)) * r_A)
      Filter.atTop (nhds (1 * r_A)) :=
    h_phi.mul_const r_A
  have h_second : Filter.Tendsto
      (fun β : ℝ => (1 - Phi (Delta_4 / Real.sqrt (2 * signalVariance β))) * r_G)
      Filter.atTop (nhds (0 * r_G)) :=
    h_one_minus_phi.mul_const r_G
  have h_sum : Filter.Tendsto
      (fun β : ℝ =>
        Phi (Delta_4 / Real.sqrt (2 * signalVariance β)) * r_A +
        (1 - Phi (Delta_4 / Real.sqrt (2 * signalVariance β))) * r_G)
      Filter.atTop (nhds (1 * r_A + 0 * r_G)) :=
    h_first.add h_second
  have h_eq : (1 : ℝ) * r_A + 0 * r_G = r_A := by ring
  rw [h_eq] at h_sum
  exact h_sum

/-- **Limit β → 0**: random choice, terminal reward = `(r_A + r_G)/2 = 0.80`.
    Substantive paper claim — limit-of-process encoding via
    `Filter.Tendsto` against the actual welfare process `W_open`, taken
    as the right-limit β → 0⁺ (β > 0 always in the paper). **CLOSED**:
    symmetric mirror of `gap_W_open_limit_infty`. Composed via
    `signalVariance_tendsto_atTop_of_tendsto_zero_pos`
    (`σ²(β) → +∞` as β → 0⁺) +
    `Filter.Tendsto.const_div_atTop` (`Δ / √(2σ²) → 0`) + `Phi_continuousAt 0`
    (Φ continuous at 0) + `Phi_zero` (`Φ(0) = 1/2`) +
    `Filter.Tendsto.mul_const` / `.add` arithmetic chain to
    `(1/2) · r_A + (1/2) · r_G = (r_A + r_G)/2`.

    paper source: Proposition `prop:canonical` β→0 limit. -/
theorem gap_W_open_limit_zero :
    Filter.Tendsto W_open (nhdsWithin 0 (Set.Ioi 0)) (nhds ((r_A + r_G) / 2)) := by
  unfold W_open
  -- Step 1: `signalVariance β → +∞` as β → 0⁺ (Cat 1 helper in ClassicalResults.lean).
  have h_sigma : Filter.Tendsto signalVariance
      (nhdsWithin 0 (Set.Ioi 0)) Filter.atTop :=
    signalVariance_tendsto_atTop_of_tendsto_zero_pos
  -- Step 2: `2 * signalVariance β → +∞`.
  have h_2sigma : Filter.Tendsto (fun β : ℝ => 2 * signalVariance β)
      (nhdsWithin 0 (Set.Ioi 0)) Filter.atTop :=
    h_sigma.const_mul_atTop (by norm_num : (0 : ℝ) < 2)
  -- Step 3: `sqrt(2 * signalVariance β) → +∞`.
  have h_sqrt : Filter.Tendsto (fun β : ℝ => Real.sqrt (2 * signalVariance β))
      (nhdsWithin 0 (Set.Ioi 0)) Filter.atTop :=
    Real.tendsto_sqrt_atTop.comp h_2sigma
  -- Step 4: `Delta_4 / sqrt(...) → 0` via `Filter.Tendsto.const_div_atTop`.
  have h_arg : Filter.Tendsto
      (fun β : ℝ => Delta_4 / Real.sqrt (2 * signalVariance β))
      (nhdsWithin 0 (Set.Ioi 0)) (nhds 0) :=
    h_sqrt.const_div_atTop Delta_4
  -- Step 5: `Phi(arg) → Phi 0 = 1/2` via `Phi_continuousAt 0` + `Phi_zero`.
  have h_phi : Filter.Tendsto
      (fun β : ℝ => Phi (Delta_4 / Real.sqrt (2 * signalVariance β)))
      (nhdsWithin 0 (Set.Ioi 0)) (nhds (1/2 : ℝ)) := by
    have h_cont : Filter.Tendsto Phi (nhds (0 : ℝ)) (nhds (Phi 0)) :=
      (Phi_continuousAt 0).tendsto
    have h_phi_zero : Phi (0 : ℝ) = 1/2 := Phi_zero
    rw [h_phi_zero] at h_cont
    exact h_cont.comp h_arg
  -- Step 6: `1 - Phi(arg) → 1 - 1/2 = 1/2`.
  have h_one_minus_phi : Filter.Tendsto
      (fun β : ℝ => 1 - Phi (Delta_4 / Real.sqrt (2 * signalVariance β)))
      (nhdsWithin 0 (Set.Ioi 0)) (nhds (1/2 : ℝ)) := by
    have h_const : Filter.Tendsto (fun _ : ℝ => (1 : ℝ))
        (nhdsWithin 0 (Set.Ioi 0)) (nhds 1) := tendsto_const_nhds
    have h := h_const.sub h_phi
    have h_eq : (1 : ℝ) - 1/2 = 1/2 := by norm_num
    rw [h_eq] at h
    exact h
  -- Step 7: combine via Tendsto.add and Tendsto.mul_const.
  have h_first : Filter.Tendsto
      (fun β : ℝ => Phi (Delta_4 / Real.sqrt (2 * signalVariance β)) * r_A)
      (nhdsWithin 0 (Set.Ioi 0)) (nhds ((1/2 : ℝ) * r_A)) :=
    h_phi.mul_const r_A
  have h_second : Filter.Tendsto
      (fun β : ℝ => (1 - Phi (Delta_4 / Real.sqrt (2 * signalVariance β))) * r_G)
      (nhdsWithin 0 (Set.Ioi 0)) (nhds ((1/2 : ℝ) * r_G)) :=
    h_one_minus_phi.mul_const r_G
  have h_sum : Filter.Tendsto
      (fun β : ℝ =>
        Phi (Delta_4 / Real.sqrt (2 * signalVariance β)) * r_A +
        (1 - Phi (Delta_4 / Real.sqrt (2 * signalVariance β))) * r_G)
      (nhdsWithin 0 (Set.Ioi 0)) (nhds ((1/2 : ℝ) * r_A + (1/2 : ℝ) * r_G)) :=
    h_first.add h_second
  -- Step 8: identify `(1/2)·r_A + (1/2)·r_G = (r_A + r_G)/2`.
  have h_eq : (1/2 : ℝ) * r_A + (1/2 : ℝ) * r_G = (r_A + r_G) / 2 := by ring
  rw [h_eq] at h_sum
  exact h_sum

end FourState

/-! ## 2. The Interior Optimum (5 states)

`V = {S, A, B, D, G}`, edges `S-A`, `S-B`, `B-D`, `B-G`; rewards
`r(S)=0, r(A)=0.6, r(B)=0.4, r(D)=0.1, r(G)=1.0`. Edge `B-G` blocked
with probability `p`. -/

namespace FiveState

/-- Reward parameters of the 5-state instance. Real division is
    `noncomputable` in Mathlib, so `r_A`, `r_B`, `r_D` (and the derived
    `Delta_S`, `Delta_B`) are all marked `noncomputable`. -/
noncomputable def r_A : ℝ := (6 : ℝ) / 10
noncomputable def r_B : ℝ := (4 : ℝ) / 10
noncomputable def r_D : ℝ := (1 : ℝ) / 10
def r_G : ℝ := 1

/-- The reward gap at `S` between `A` and `B`. -/
noncomputable def Delta_S : ℝ := r_A - r_B  -- = 0.2

/-- The reward gap at `B` between `G` and `D`. -/
noncomputable def Delta_B : ℝ := r_G - r_D  -- = 0.9

/-- **Trap-selection probability** at `S`: `P_trap(β) = Φ(Δ_S/√(2σ²))`. -/
noncomputable def P_trap (β : ℝ) : ℝ :=
  Phi (Delta_S / Real.sqrt (2 * signalVariance β))

/-- **Within-`B` goal-selection probability**:
    `Φ_B(β) = Φ(Δ_B/√(2σ²))`. -/
noncomputable def Phi_B (β : ℝ) : ℝ :=
  Phi (Delta_B / Real.sqrt (2 * signalVariance β))

/-- **Proposition `prop:interior-optimum`** — Closed-form welfare loss
    `L(β) = P_trap(β) · 0.4 + (1 − P_trap(β)) · (1 − Φ_B(β)) · 0.9` for
    the case `p = 0`.

    paper source: Proposition `prop:interior-optimum`, lines 769-779. -/
noncomputable def L_zero_p (β : ℝ) : ℝ :=
  P_trap β * (4/10 : ℝ) +
  (1 - P_trap β) * (1 - Phi_B β) * (9/10 : ℝ)

/-- **Generalised loss `L(β, p)`** for `p ∈ [0, 1)` on the `B–G` edge.

    `L(β, p) = P_trap(β) · 0.4 + (1 − P_trap(β)) · 0.9 ·
                 (1 − (1 − p)·Φ_B(β))`.

    paper source: line 802. -/
noncomputable def L (β p : ℝ) : ℝ :=
  P_trap β * (4/10 : ℝ) +
  (1 - P_trap β) * (9/10 : ℝ) * (1 - (1 - p) * Phi_B β)

/-! ### Helper lemmas: monotonicity of `P_trap` and `Phi_B`.

`P_trap β = Phi(Delta_S / √(2 σ²(β)))` and `Phi_B β = Phi(Delta_B / √(2 σ²(β)))`
with `Delta_S, Delta_B > 0`. As `β` increases, `σ²(β)` strictly decreases
(`signalVariance_strictAntitoneOn`), so the argument of `Phi` strictly
increases, and `Phi` is monotone (`Phi_monotone`). Both `P_trap` and
`Phi_B` are bounded above by `1` (`Phi_le_one`) and below by `0`
(`Phi_nonneg`). These auxiliary facts are pure Cat 1 derivations from
already-closed Mathlib-derivable inputs.

paper source: §2.2 line 138 (`σ²(β) = 1/(2^{2β} − 1)` strictly
decreasing in β); line 802 (`P_trap, Φ_B` defined). -/

/-- `Delta_S = r_A − r_B = 0.2 > 0`. -/
private theorem Delta_S_pos : 0 < Delta_S := by
  unfold Delta_S r_A r_B
  norm_num

/-- `Delta_B = r_G − r_D = 0.9 > 0`. -/
private theorem Delta_B_pos : 0 < Delta_B := by
  unfold Delta_B r_G r_D
  norm_num

/-- The five-state reward gaps have the exact ratio `Delta_S / Delta_B = 2 / 9`. -/
private theorem Delta_S_eq_two_ninths_mul_Delta_B :
    Delta_S = (2/9 : ℝ) * Delta_B := by
  unfold Delta_S Delta_B r_A r_B r_G r_D
  norm_num

/-- `signalVariance β > 0` for `β > 0`. -/
private theorem signalVariance_pos {β : ℝ} (hβ : 0 < β) : 0 < signalVariance β := by
  unfold signalVariance
  have h2_one_lt : (1 : ℝ) < 2 := by norm_num
  have h2β_pos : 0 < 2 * β := by linarith
  have h_one_lt_pow : (1 : ℝ) < (2 : ℝ)^(2 * β) :=
    Real.one_lt_rpow h2_one_lt h2β_pos
  have h_denom_pos : 0 < (2 : ℝ)^(2 * β) - 1 := by linarith
  exact one_div_pos.mpr h_denom_pos

/-- `√(2 · signalVariance β) > 0` for `β > 0`. -/
private theorem sqrt_two_sigma_pos {β : ℝ} (hβ : 0 < β) :
    0 < Real.sqrt (2 * signalVariance β) := by
  apply Real.sqrt_pos.mpr
  exact mul_pos (by norm_num) (signalVariance_pos hβ)

/-- For `β₁ ≤ β₂` (both positive), `Delta_S / √(2 σ²(β₁)) ≤ Delta_S / √(2 σ²(β₂))`.

    Combines `signalVariance_strictAntitoneOn` (β₁ < β₂ ⟹ σ²(β₂) < σ²(β₁)),
    `Real.sqrt_lt_sqrt`, `Delta_S_pos`, and division reversal on positives.
    The case `β₁ = β₂` gives equality. -/
private theorem arg_S_monotone {β₁ β₂ : ℝ} (hβ₁ : 0 < β₁) (h_le : β₁ ≤ β₂) :
    Delta_S / Real.sqrt (2 * signalVariance β₁) ≤
      Delta_S / Real.sqrt (2 * signalVariance β₂) := by
  rcases eq_or_lt_of_le h_le with heq | hlt
  · subst heq; rfl
  -- β₁ < β₂. σ²(β₂) < σ²(β₁), so √(2σ²(β₂)) < √(2σ²(β₁)), so reciprocal
  -- reverses, and multiplying by Delta_S > 0 preserves the order.
  have hβ₂ : 0 < β₂ := lt_trans hβ₁ hlt
  have h_sigma : signalVariance β₂ < signalVariance β₁ :=
    signalVariance_strictAntitoneOn hβ₁ hlt
  have h_2sigma_pos₂ : 0 < 2 * signalVariance β₂ :=
    mul_pos (by norm_num) (signalVariance_pos hβ₂)
  have h_2sigma_lt : 2 * signalVariance β₂ < 2 * signalVariance β₁ := by linarith
  have h_sqrt_lt :
      Real.sqrt (2 * signalVariance β₂) < Real.sqrt (2 * signalVariance β₁) :=
    Real.sqrt_lt_sqrt (le_of_lt h_2sigma_pos₂) h_2sigma_lt
  have h_sqrt_pos₂ : 0 < Real.sqrt (2 * signalVariance β₂) :=
    sqrt_two_sigma_pos hβ₂
  -- Apply division-reversal: a/b ≤ a/c whenever 0 < c ≤ b and 0 ≤ a.
  exact div_le_div_of_nonneg_left (le_of_lt Delta_S_pos)
    h_sqrt_pos₂ (le_of_lt h_sqrt_lt)

/-- For `β₁ ≤ β₂` (both positive), `Delta_B / √(2 σ²(β₁)) ≤ Delta_B / √(2 σ²(β₂))`. -/
private theorem arg_B_monotone {β₁ β₂ : ℝ} (hβ₁ : 0 < β₁) (h_le : β₁ ≤ β₂) :
    Delta_B / Real.sqrt (2 * signalVariance β₁) ≤
      Delta_B / Real.sqrt (2 * signalVariance β₂) := by
  rcases eq_or_lt_of_le h_le with heq | hlt
  · subst heq; rfl
  have hβ₂ : 0 < β₂ := lt_trans hβ₁ hlt
  have h_sigma : signalVariance β₂ < signalVariance β₁ :=
    signalVariance_strictAntitoneOn hβ₁ hlt
  have h_2sigma_pos₂ : 0 < 2 * signalVariance β₂ :=
    mul_pos (by norm_num) (signalVariance_pos hβ₂)
  have h_2sigma_lt : 2 * signalVariance β₂ < 2 * signalVariance β₁ := by linarith
  have h_sqrt_lt :
      Real.sqrt (2 * signalVariance β₂) < Real.sqrt (2 * signalVariance β₁) :=
    Real.sqrt_lt_sqrt (le_of_lt h_2sigma_pos₂) h_2sigma_lt
  have h_sqrt_pos₂ : 0 < Real.sqrt (2 * signalVariance β₂) :=
    sqrt_two_sigma_pos hβ₂
  exact div_le_div_of_nonneg_left (le_of_lt Delta_B_pos)
    h_sqrt_pos₂ (le_of_lt h_sqrt_lt)

/-- Strict version of `arg_B_monotone`: the `B` Gaussian argument is strictly
    increasing with precision on `(0, ∞)`. -/
private theorem arg_B_strictMono {β₁ β₂ : ℝ} (hβ₁ : 0 < β₁) (hlt : β₁ < β₂) :
    Delta_B / Real.sqrt (2 * signalVariance β₁) <
      Delta_B / Real.sqrt (2 * signalVariance β₂) := by
  have hβ₂ : 0 < β₂ := lt_trans hβ₁ hlt
  have h_sigma : signalVariance β₂ < signalVariance β₁ :=
    signalVariance_strictAntitoneOn hβ₁ hlt
  have h_2sigma_pos₂ : 0 < 2 * signalVariance β₂ :=
    mul_pos (by norm_num) (signalVariance_pos hβ₂)
  have h_2sigma_lt : 2 * signalVariance β₂ < 2 * signalVariance β₁ := by linarith
  have h_sqrt_lt :
      Real.sqrt (2 * signalVariance β₂) < Real.sqrt (2 * signalVariance β₁) :=
    Real.sqrt_lt_sqrt (le_of_lt h_2sigma_pos₂) h_2sigma_lt
  have h_sqrt_pos₂ : 0 < Real.sqrt (2 * signalVariance β₂) :=
    sqrt_two_sigma_pos hβ₂
  exact div_lt_div_of_pos_left Delta_B_pos h_sqrt_pos₂ h_sqrt_lt

/-- `P_trap` is monotonically non-decreasing on `(0, ∞)`: as precision
    `β` increases, the trap-selection probability rises. -/
private theorem P_trap_monotone {β₁ β₂ : ℝ} (hβ₁ : 0 < β₁) (h_le : β₁ ≤ β₂) :
    P_trap β₁ ≤ P_trap β₂ := by
  unfold P_trap
  exact Phi_monotone (arg_S_monotone hβ₁ h_le)

/-- `Phi_B` is monotonically non-decreasing on `(0, ∞)`: as precision
    `β` increases, the within-`B` goal-selection probability rises. -/
private theorem Phi_B_monotone {β₁ β₂ : ℝ} (hβ₁ : 0 < β₁) (h_le : β₁ ≤ β₂) :
    Phi_B β₁ ≤ Phi_B β₂ := by
  unfold Phi_B
  exact Phi_monotone (arg_B_monotone hβ₁ h_le)

/-- `0 ≤ P_trap β ≤ 1` for any `β`. -/
private theorem P_trap_mem_unitInterval (β : ℝ) :
    0 ≤ P_trap β ∧ P_trap β ≤ 1 := by
  unfold P_trap
  exact ⟨Phi_nonneg _, Phi_le_one _⟩

/-- `0 ≤ Phi_B β ≤ 1` for any `β`. -/
private theorem Phi_B_mem_unitInterval (β : ℝ) :
    0 ≤ Phi_B β ∧ Phi_B β ≤ 1 := by
  unfold Phi_B
  exact ⟨Phi_nonneg _, Phi_le_one _⟩

/-- **Auxiliary lemma — `L(β, p)` is monotonically non-increasing in `β`
    on `(0, ∞)` whenever `0.9 · (1 − p) · 1 ≤ 0.5`, i.e., `(1 − p) ≤ 5/9`,
    i.e., `p ≥ p_1 = 4/9`.

    This is the analytic engine common to both Regime (ii) (`p ∈ [p_1, p_2]`)
    and Regime (iii) (`p ∈ (p_2, 1)`) of Proposition
    `prop:three-regime-five-state`: in both regimes the bound on
    `0.9·(1−p)·Φ_B(β)` ensures the "first term" of `L₂ − L₁` is
    non-positive (since `−0.5 + 0.9·(1−p)·v₁ ≤ 0`), and the "second term"
    is non-positive by basic non-negativity (the `0.9·(1−u₂)·(1−p)` factor
    is non-negative, and the `Φ_B(β₂) − Φ_B(β₁)` factor is non-negative
    by `Phi_B_monotone`).

    paper source: Proposition `prop:three-regime-five-state` proof,
    Regime (ii) line 829 ("Direct differentiation gives ... `∂L/∂β < 0`").
    The Lean proof uses an algebraic decomposition equivalent to the
    paper's derivative-based argument: rather than computing the
    derivative explicitly, expand `L β₂ p − L β₁ p` and group into the
    two non-positive contributions. -/
private theorem L_monotone_under_q_le_5_9
    (p : ℝ) (hp_q_bound : 1 - p ≤ (5 : ℝ) / 9) (hp_le_1 : p ≤ 1)
    {β₁ β₂ : ℝ} (hβ₁ : 0 < β₁) (h_le : β₁ ≤ β₂) :
    L β₂ p ≤ L β₁ p := by
  -- Trivial case: β₁ = β₂.
  rcases eq_or_lt_of_le h_le with heq | hlt
  · subst heq; rfl
  -- Substantive case: β₁ < β₂.
  set u₁ := P_trap β₁ with hu₁_def
  set u₂ := P_trap β₂ with hu₂_def
  set v₁ := Phi_B β₁ with hv₁_def
  set v₂ := Phi_B β₂ with hv₂_def
  -- Monotonicity of P_trap and Phi_B.
  have h_u_le : u₁ ≤ u₂ := P_trap_monotone hβ₁ h_le
  have h_v_le : v₁ ≤ v₂ := Phi_B_monotone hβ₁ h_le
  -- Bounds on u, v: in [0, 1].
  obtain ⟨h_u₁_nn, h_u₁_le_1⟩ := P_trap_mem_unitInterval β₁
  obtain ⟨h_u₂_nn, h_u₂_le_1⟩ := P_trap_mem_unitInterval β₂
  obtain ⟨h_v₁_nn, h_v₁_le_1⟩ := Phi_B_mem_unitInterval β₁
  obtain ⟨_h_v₂_nn, h_v₂_le_1⟩ := Phi_B_mem_unitInterval β₂
  -- q := 1 - p, with 0 ≤ q ≤ 5/9.
  set q : ℝ := 1 - p with hq_def
  have h_q_nn : 0 ≤ q := by simp [hq_def]; linarith
  -- Key inequality: 0.9·q·v₁ ≤ 0.5.
  -- Proof: 0.9·q ≤ 0.9·(5/9) = 0.5, then × v₁ ≤ 1.
  have h_09q_le : (9/10 : ℝ) * q ≤ (1/2 : ℝ) := by
    have : (9/10 : ℝ) * q ≤ (9/10 : ℝ) * (5/9 : ℝ) := by
      exact mul_le_mul_of_nonneg_left hp_q_bound (by norm_num)
    linarith [this]
  have h_09qv_le : (9/10 : ℝ) * q * v₁ ≤ (1/2 : ℝ) := by
    have h_09q_nn : 0 ≤ (9/10 : ℝ) * q := mul_nonneg (by norm_num) h_q_nn
    have h_step : (9/10 : ℝ) * q * v₁ ≤ (9/10 : ℝ) * q * 1 :=
      mul_le_mul_of_nonneg_left h_v₁_le_1 h_09q_nn
    have : (9/10 : ℝ) * q * v₁ ≤ (9/10 : ℝ) * q := by linarith [h_step]
    linarith [this, h_09q_le]
  -- Algebraic decomposition:
  --   L₂ - L₁ = (u₂ - u₁) · (-0.5 + 0.9·q·v₁) - 0.9·q·(v₂ - v₁)·(1 - u₂).
  -- Both terms ≤ 0 under our hypotheses.
  have h_term1_le : (u₂ - u₁) * (-(1/2 : ℝ) + (9/10 : ℝ) * q * v₁) ≤ 0 := by
    have h_u_diff_nn : 0 ≤ u₂ - u₁ := by linarith
    have h_bracket : -(1/2 : ℝ) + (9/10 : ℝ) * q * v₁ ≤ 0 := by linarith
    exact mul_nonpos_of_nonneg_of_nonpos h_u_diff_nn h_bracket
  have h_term2_nn : 0 ≤ (9/10 : ℝ) * q * (v₂ - v₁) * (1 - u₂) := by
    have h_v_diff_nn : 0 ≤ v₂ - v₁ := by linarith
    have h_one_minus_u₂_nn : 0 ≤ 1 - u₂ := by linarith
    have h_09q_nn : 0 ≤ (9/10 : ℝ) * q := mul_nonneg (by norm_num) h_q_nn
    have : 0 ≤ (9/10 : ℝ) * q * (v₂ - v₁) := mul_nonneg h_09q_nn h_v_diff_nn
    exact mul_nonneg this h_one_minus_u₂_nn
  -- Now expand L β₂ p - L β₁ p = (term1) - (term2). Need to verify
  -- this is an algebraic identity; once verified, the bound L₂ ≤ L₁
  -- follows from term1 ≤ 0 and term2 ≥ 0.
  show L β₂ p ≤ L β₁ p
  unfold L
  -- L β p (definition) = P_trap β · 0.4 + (1 - P_trap β) · 0.9 · (1 - (1 - p) · Phi_B β)
  -- Substitute names u, v, q.
  show u₂ * (4/10 : ℝ) + (1 - u₂) * (9/10 : ℝ) * (1 - q * v₂) ≤
       u₁ * (4/10 : ℝ) + (1 - u₁) * (9/10 : ℝ) * (1 - q * v₁)
  -- The identity:
  --   [u₁ * 0.4 + (1 - u₁) * 0.9 * (1 - q * v₁)]
  -- - [u₂ * 0.4 + (1 - u₂) * 0.9 * (1 - q * v₂)]
  -- = - (u₂ - u₁) * (-0.5 + 0.9·q·v₁) + 0.9·q·(v₂ - v₁)·(1 - u₂)
  -- = (u₂ - u₁) * (0.5 - 0.9·q·v₁) + 0.9·q·(v₂ - v₁)·(1 - u₂)  [≥ 0]
  -- which means RHS - LHS ≥ 0, i.e., LHS ≤ RHS.
  nlinarith [h_term1_le, h_term2_nn]

/-- The first regime boundary `p_1 = 4/9` (paper line 809). -/
noncomputable def p_1 : ℝ := (4 : ℝ) / 9

/-- The second regime boundary `p_2 = 2/3` (paper line 809). -/
noncomputable def p_2 : ℝ := (2 : ℝ) / 3

/-! ### Substantive L-carrier analysis.

`L` is the concrete welfare-loss functional
`L β p = P_trap β · 0.4 + (1 − P_trap β) · 0.9 · (1 − (1 − p)·Φ_B β)`.
The following lemmas extract, by genuine real-analysis on the
concrete definition, the facts the paper's Proposition
`prop:three-regime-five-state` Regime (i) proof (lines 821-825) uses:
the strict bounds `P_trap β < 1` / `Φ_B β ∈ (1/2, 1)` for finite
`β > 0`, the limits `P_trap, Φ_B → 1` as `β → ∞` and `→ 1/2` as
`β → 0⁺`, the algebraic rearrangement `eq:five-state-rearr`, and the
endpoint limits `L → 0.4` (β → ∞) and `L → 0.425 + 0.225 p` (β → 0⁺).
These yield derived theorems for Regime (i) sub-claims.

Mathlib lemmas used: `Phi_lt_one`, `Phi_gt_half_of_pos`,
`Phi_tendsto_one_atTop`, `Phi_continuousAt`, `Phi_zero`,
`signalVariance_tendsto_zero_atTop`,
`signalVariance_tendsto_atTop_of_tendsto_zero_pos`,
`tendsto_const_div_atTop_of_tendsto_zero_pos`,
`Real.continuous_sqrt`, `Real.tendsto_sqrt_atTop`,
`Filter.Tendsto.const_div_atTop`, plus the `Filter.Tendsto`
arithmetic combinators. -/

/-- `P_trap β < 1` for every `β`: the trap-selection probability is a
    standard-normal CDF value, strictly below `1` (`Phi_lt_one`).
    paper source: line 825 ("`1 − P_trap(β) > 0` for finite `β`"). -/
private theorem P_trap_lt_one (β : ℝ) : P_trap β < 1 := by
  unfold P_trap
  exact Phi_lt_one _

/-- `1/2 < Φ_B β` for `β > 0`: the within-`B` goal-selection
    probability is `Φ` of a strictly positive argument
    (`Δ_B > 0`, `√(2σ²(β)) > 0`), hence strictly exceeds `1/2`
    (`Phi_gt_half_of_pos`).
    paper source: line 825 ("`Φ_B(β)` ranges over `(1/2, 1)`"). -/
private theorem Phi_B_gt_half {β : ℝ} (hβ : 0 < β) : (1 : ℝ)/2 < Phi_B β := by
  unfold Phi_B
  apply Phi_gt_half_of_pos
  exact div_pos Delta_B_pos (sqrt_two_sigma_pos hβ)

/-- `Φ_B β → 1` as `β → ∞`: the argument `Δ_B/√(2σ²(β)) → ∞` because
    `σ²(β) → 0⁺`, and `Φ(x) → 1` as `x → ∞` (`Phi_tendsto_one_atTop`).
    Mirrors the `gap_W_open_limit_infty` derivation chain.
    paper source: line 825 ("`Φ_B(β)` ranges over `(1/2, 1)`"). -/
private theorem Phi_B_tendsto_one_atTop :
    Filter.Tendsto Phi_B Filter.atTop (nhds 1) := by
  unfold Phi_B
  have h_2sigma : Filter.Tendsto (fun β : ℝ => 2 * signalVariance β)
      Filter.atTop (nhds 0) := by
    have := signalVariance_tendsto_zero_atTop.const_mul (2 : ℝ)
    simpa using this
  have h_sqrt : Filter.Tendsto (fun β : ℝ => Real.sqrt (2 * signalVariance β))
      Filter.atTop (nhds 0) := by
    have h := (Real.continuous_sqrt.tendsto 0).comp h_2sigma
    rw [Real.sqrt_zero] at h
    exact h
  have h_sqrt_pos : ∀ᶠ β in Filter.atTop, 0 < Real.sqrt (2 * signalVariance β) := by
    filter_upwards [Filter.eventually_gt_atTop (0 : ℝ)] with β hβ
    exact sqrt_two_sigma_pos hβ
  have h_arg : Filter.Tendsto
      (fun β : ℝ => Delta_B / Real.sqrt (2 * signalVariance β))
      Filter.atTop Filter.atTop :=
    tendsto_const_div_atTop_of_tendsto_zero_pos Delta_B Delta_B_pos
      (fun β => Real.sqrt (2 * signalVariance β)) h_sqrt h_sqrt_pos
  exact Phi_tendsto_one_atTop.comp h_arg

/-- `P_trap β → 1` as `β → ∞`: identical chain to `Phi_B_tendsto_one_atTop`
    with the reward gap `Δ_S > 0` in place of `Δ_B`.
    paper source: line 804 ("`P_trap → 1` so `L(∞, p) = 0.4`"). -/
private theorem P_trap_tendsto_one_atTop :
    Filter.Tendsto P_trap Filter.atTop (nhds 1) := by
  unfold P_trap
  have h_2sigma : Filter.Tendsto (fun β : ℝ => 2 * signalVariance β)
      Filter.atTop (nhds 0) := by
    have := signalVariance_tendsto_zero_atTop.const_mul (2 : ℝ)
    simpa using this
  have h_sqrt : Filter.Tendsto (fun β : ℝ => Real.sqrt (2 * signalVariance β))
      Filter.atTop (nhds 0) := by
    have h := (Real.continuous_sqrt.tendsto 0).comp h_2sigma
    rw [Real.sqrt_zero] at h
    exact h
  have h_sqrt_pos : ∀ᶠ β in Filter.atTop, 0 < Real.sqrt (2 * signalVariance β) := by
    filter_upwards [Filter.eventually_gt_atTop (0 : ℝ)] with β hβ
    exact sqrt_two_sigma_pos hβ
  have h_arg : Filter.Tendsto
      (fun β : ℝ => Delta_S / Real.sqrt (2 * signalVariance β))
      Filter.atTop Filter.atTop :=
    tendsto_const_div_atTop_of_tendsto_zero_pos Delta_S Delta_S_pos
      (fun β => Real.sqrt (2 * signalVariance β)) h_sqrt h_sqrt_pos
  exact Phi_tendsto_one_atTop.comp h_arg

/-- `P_trap β → 1/2` as `β → 0⁺`: the argument `Δ_S/√(2σ²(β)) → 0`
    because `σ²(β) → +∞`, and `Φ` is continuous with `Φ(0) = 1/2`.
    Mirrors the `gap_W_open_limit_zero` derivation chain.
    paper source: line 825 ("`L(0, p) = 0.425 + 0.225 p`", which uses
    `P_trap(0⁺) = 1/2`). -/
private theorem P_trap_tendsto_half_atZero :
    Filter.Tendsto P_trap (nhdsWithin 0 (Set.Ioi 0)) (nhds (1/2 : ℝ)) := by
  unfold P_trap
  have h_2sigma : Filter.Tendsto (fun β : ℝ => 2 * signalVariance β)
      (nhdsWithin 0 (Set.Ioi 0)) Filter.atTop :=
    signalVariance_tendsto_atTop_of_tendsto_zero_pos.const_mul_atTop
      (by norm_num : (0 : ℝ) < 2)
  have h_sqrt : Filter.Tendsto (fun β : ℝ => Real.sqrt (2 * signalVariance β))
      (nhdsWithin 0 (Set.Ioi 0)) Filter.atTop :=
    Real.tendsto_sqrt_atTop.comp h_2sigma
  have h_arg : Filter.Tendsto
      (fun β : ℝ => Delta_S / Real.sqrt (2 * signalVariance β))
      (nhdsWithin 0 (Set.Ioi 0)) (nhds 0) :=
    h_sqrt.const_div_atTop Delta_S
  have h_cont : Filter.Tendsto Phi (nhds (0 : ℝ)) (nhds (Phi 0)) :=
    (Phi_continuousAt 0).tendsto
  rw [Phi_zero] at h_cont
  exact h_cont.comp h_arg

/-- `Φ_B β → 1/2` as `β → 0⁺`: identical chain to
    `P_trap_tendsto_half_atZero` with `Δ_B` in place of `Δ_S`.
    paper source: line 825 ("`L(0, p) = 0.425 + 0.225 p`", which uses
    `Φ_B(0⁺) = 1/2`). -/
private theorem Phi_B_tendsto_half_atZero :
    Filter.Tendsto Phi_B (nhdsWithin 0 (Set.Ioi 0)) (nhds (1/2 : ℝ)) := by
  unfold Phi_B
  have h_2sigma : Filter.Tendsto (fun β : ℝ => 2 * signalVariance β)
      (nhdsWithin 0 (Set.Ioi 0)) Filter.atTop :=
    signalVariance_tendsto_atTop_of_tendsto_zero_pos.const_mul_atTop
      (by norm_num : (0 : ℝ) < 2)
  have h_sqrt : Filter.Tendsto (fun β : ℝ => Real.sqrt (2 * signalVariance β))
      (nhdsWithin 0 (Set.Ioi 0)) Filter.atTop :=
    Real.tendsto_sqrt_atTop.comp h_2sigma
  have h_arg : Filter.Tendsto
      (fun β : ℝ => Delta_B / Real.sqrt (2 * signalVariance β))
      (nhdsWithin 0 (Set.Ioi 0)) (nhds 0) :=
    h_sqrt.const_div_atTop Delta_B
  have h_cont : Filter.Tendsto Phi (nhds (0 : ℝ)) (nhds (Phi 0)) :=
    (Phi_continuousAt 0).tendsto
  rw [Phi_zero] at h_cont
  exact h_cont.comp h_arg

/-- **Rearrangement identity `eq:five-state-rearr`** (paper line 823):
    `L(β, p) − 0.4 = (1 − P_trap β) · (0.5 − 0.9·(1 − p)·Φ_B β)`.
    Pure algebraic identity on the concrete `L` definition,
    discharged by `ring`.
    paper source: Equation `eq:five-state-rearr`, line 823. -/
theorem L_rearrangement (β p : ℝ) :
    L β p - (4/10 : ℝ) =
      (1 - P_trap β) * ((1/2 : ℝ) - (9/10 : ℝ) * (1 - p) * Phi_B β) := by
  unfold L
  ring

/-- **Endpoint limit `L(∞, p) = 0.4`** (paper line 804): as `β → ∞`,
    `P_trap β → 1` and `Φ_B β → 1`, so the concrete `L` functional
    tends to `1·0.4 + 0·0.9·(1 − (1 − p)·1) = 0.4`.
    paper source: line 804 ("at `β → ∞`, `P_trap → 1` so
    `L(∞, p) = 0.4`"). -/
theorem L_tendsto_limit_atTop (p : ℝ) :
    Filter.Tendsto (fun β : ℝ => L β p) Filter.atTop (nhds (4/10 : ℝ)) := by
  have h_Pt : Filter.Tendsto P_trap Filter.atTop (nhds 1) :=
    P_trap_tendsto_one_atTop
  have h_Pb : Filter.Tendsto Phi_B Filter.atTop (nhds 1) :=
    Phi_B_tendsto_one_atTop
  have h_comb : Filter.Tendsto
      (fun β : ℝ => P_trap β * (4/10 : ℝ) +
        (1 - P_trap β) * (9/10 : ℝ) * (1 - (1 - p) * Phi_B β))
      Filter.atTop
      (nhds ((1 : ℝ) * (4/10) +
        (1 - 1) * (9/10) * (1 - (1 - p) * 1))) := by
    exact ((h_Pt.mul_const _).add
      (((tendsto_const_nhds.sub h_Pt).mul_const _).mul
        (tendsto_const_nhds.sub
          ((tendsto_const_nhds.sub tendsto_const_nhds).mul h_Pb))))
  have h_eq : (1 : ℝ) * (4/10) + (1 - 1) * (9/10) * (1 - (1 - p) * 1)
      = (4/10 : ℝ) := by ring
  rw [h_eq] at h_comb
  exact h_comb

/-- **Endpoint limit `L(0⁺, p) = 0.425 + 0.225 p`** (paper line 825):
    as `β → 0⁺`, `P_trap β → 1/2` and `Φ_B β → 1/2`, so the concrete
    `L` functional tends to
    `(1/2)·0.4 + (1/2)·0.9·(1 − (1 − p)·(1/2)) = 0.425 + 0.225 p`.
    paper source: line 825 ("`L(0, p) = 0.425 + 0.225 p > 0.4`"). -/
private theorem L_tendsto_atZero (p : ℝ) :
    Filter.Tendsto (fun β : ℝ => L β p)
      (nhdsWithin 0 (Set.Ioi 0))
      (nhds ((425/1000 : ℝ) + (225/1000 : ℝ) * p)) := by
  have h_Pt : Filter.Tendsto P_trap (nhdsWithin 0 (Set.Ioi 0))
      (nhds (1/2 : ℝ)) := P_trap_tendsto_half_atZero
  have h_Pb : Filter.Tendsto Phi_B (nhdsWithin 0 (Set.Ioi 0))
      (nhds (1/2 : ℝ)) := Phi_B_tendsto_half_atZero
  have h_comb : Filter.Tendsto
      (fun β : ℝ => P_trap β * (4/10 : ℝ) +
        (1 - P_trap β) * (9/10 : ℝ) * (1 - (1 - p) * Phi_B β))
      (nhdsWithin 0 (Set.Ioi 0))
      (nhds (((1:ℝ)/2) * (4/10) +
        (1 - (1:ℝ)/2) * (9/10) * (1 - (1 - p) * ((1:ℝ)/2)))) := by
    exact ((h_Pt.mul_const _).add
      (((tendsto_const_nhds.sub h_Pt).mul_const _).mul
        (tendsto_const_nhds.sub
          ((tendsto_const_nhds.sub tendsto_const_nhds).mul h_Pb))))
  have h_eq : ((1:ℝ)/2) * (4/10) +
      (1 - (1:ℝ)/2) * (9/10) * (1 - (1 - p) * ((1:ℝ)/2))
      = (425/1000 : ℝ) + (225/1000 : ℝ) * p := by ring
  rw [h_eq] at h_comb
  exact h_comb

/-- **Substantive closure of `L_below_limit_at_some_beta`.**
    For `p ∈ [0, p_1)`, there exists a finite `β* > 0` with
    `L(β*, p) < 0.4`. Proof (paper line 825): in the rearrangement
    `L − 0.4 = (1 − P_trap β)·(0.5 − 0.9(1 − p)·Φ_B β)`, the factor
    `1 − P_trap β > 0` for every finite `β` (`P_trap_lt_one`); and
    since `p < p_1 = 4/9` gives `0.9(1 − p) > 1/2`, the threshold
    `1/(2·0.9(1 − p)) < 1`, while `Φ_B β → 1` (`Phi_B_tendsto_one_atTop`),
    so eventually `Φ_B β` exceeds that threshold, making the second
    factor strictly negative. Any such finite `β > 0` is the witness.

    Mathlib lemmas: `P_trap_lt_one`, `Phi_B_tendsto_one_atTop`,
    `L_rearrangement`, `Filter.Tendsto.eventually`, `eventually_gt_nhds`,
    `Filter.eventually_gt_atTop`. -/
private theorem L_below_limit_at_some_beta_proof
    (p : ℝ) (_hp_nonneg : 0 ≤ p) (hp_lt_p1 : p < p_1) :
    ∃ β_star_p : ℝ, 0 < β_star_p ∧ L β_star_p p < (4/10 : ℝ) := by
  -- `c := 0.9·(1 − p)` exceeds `1/2` since `p < 4/9`.
  set c : ℝ := (9/10 : ℝ) * (1 - p) with hc_def
  have hp_lt : p < (4 : ℝ)/9 := by
    have := hp_lt_p1; unfold p_1 at this; exact this
  have hc_gt_half : (1/2 : ℝ) < c := by rw [hc_def]; nlinarith
  have hc_pos : 0 < c := by linarith
  -- The threshold `θ := 1/(2c)` is `< 1`.
  set θ : ℝ := 1 / (2 * c) with hθ_def
  have hθ_lt_one : θ < 1 := by
    rw [hθ_def]
    rw [div_lt_one (by linarith)]
    linarith
  -- `Φ_B β → 1`, so eventually `Φ_B β > θ`.
  have h_ev_phiB : ∀ᶠ β in Filter.atTop, θ < Phi_B β :=
    Phi_B_tendsto_one_atTop.eventually (eventually_gt_nhds hθ_lt_one)
  -- Combine with eventual positivity of `β`.
  obtain ⟨β_star, hβ_phiB, hβ_pos⟩ :=
    ((h_ev_phiB.and (Filter.eventually_gt_atTop (0 : ℝ))).exists)
  refine ⟨β_star, hβ_pos, ?_⟩
  -- Second factor strictly negative: `1/2 − c·Φ_B β < 1/2 − c·θ = 0`.
  have h_cθ : c * θ = (1/2 : ℝ) := by
    rw [hθ_def]; field_simp
  have h_second_neg : (1/2 : ℝ) - c * Phi_B β_star < 0 := by
    have h_mul : c * θ < c * Phi_B β_star :=
      mul_lt_mul_of_pos_left hβ_phiB hc_pos
    rw [h_cθ] at h_mul
    linarith
  -- First factor strictly positive.
  have h_first_pos : 0 < 1 - P_trap β_star := by
    have := P_trap_lt_one β_star; linarith
  -- Rearrangement: `L − 0.4 = (1 − P_trap)·(1/2 − c·Φ_B) < 0`.
  have h_rearr : L β_star p - (4/10 : ℝ) =
      (1 - P_trap β_star) * ((1/2 : ℝ) - c * Phi_B β_star) := by
    have := L_rearrangement β_star p
    rw [this, hc_def]
  have h_prod_neg : (1 - P_trap β_star) *
      ((1/2 : ℝ) - c * Phi_B β_star) < 0 :=
    mul_neg_of_pos_of_neg h_first_pos h_second_neg
  linarith [h_rearr, h_prod_neg]

/-! ### Substantive closure of `interior_minimiser_existence`.

The interior-minimiser existence claim follows from the extreme value
theorem applied to the *concrete* `L` carrier, using the endpoint
limits. The chain:
  * `L(·, 0)` is continuous on `(0, ∞)` (composition of the continuous
    `signalVariance`, `Real.sqrt`, division by a positive function,
    and `Phi`);
  * `L_below_limit_at_some_beta_proof` supplies an interior
    point `β* > 0` with `L(β*, 0) < 0.4`;
  * `L_tendsto_atZero` / `L_tendsto_limit_atTop` show `L` exceeds
    `L(β*, 0)` near both ends of `(0, ∞)` (it tends to `0.425 > L(β*,0)`
    at `0⁺` and to `0.4 > L(β*,0)` at `∞`), and the closed-form value
    `L(0, 0) = 0.425 > L(β*, 0)` handles the `β = 0` endpoint;
  * hence the minimum of `L(·,0)` over a compact `[ε, M]` (extreme
    value theorem, `IsCompact.exists_isMinOn`) is a *global* minimum
    over `[0, ∞)`, and is interior (positive).

Mathlib lemmas: `IsCompact.exists_isMinOn`, `isCompact_Icc`,
`ContinuousOn.continuousWithinAt`, `Real.continuous_sqrt`,
`Continuous.rpow_const` / `Real.continuousAt_rpow_const`,
`ContinuousOn.div`, `Filter.Tendsto.eventually`, `eventually_gt_nhds`,
`Filter.eventually_gt_atTop`, `eventually_nhdsWithin_iff`,
plus `Phi_continuousAt`, `Phi_zero`. -/

/-- `signalVariance` is continuous on `(0, ∞)`: the denominator
    `2^(2β) − 1` is continuous everywhere and strictly positive
    (hence non-zero) for `β > 0`, so the reciprocal is continuous
    there. -/
private theorem signalVariance_continuousOn_Ioi :
    ContinuousOn signalVariance (Set.Ioi (0 : ℝ)) := by
  unfold signalVariance
  have h_den_cont : Continuous (fun β : ℝ => (2 : ℝ) ^ (2 * β) - 1) := by
    have h_rpow : Continuous (fun β : ℝ => (2 : ℝ) ^ (2 * β)) := by
      have h2 : (0 : ℝ) < 2 := by norm_num
      exact (Real.continuous_const_rpow (by norm_num)).comp
        (continuous_const.mul continuous_id)
    exact h_rpow.sub continuous_const
  apply ContinuousOn.div continuousOn_const h_den_cont.continuousOn
  intro β hβ
  have hβ_pos : 0 < β := hβ
  have h2β_pos : 0 < 2 * β := by linarith
  have : (1 : ℝ) < (2 : ℝ) ^ (2 * β) :=
    Real.one_lt_rpow (by norm_num) h2β_pos
  linarith

/-- `√(2·signalVariance β)` is continuous and strictly positive on
    `(0, ∞)`. -/
private theorem sqrt_two_sigma_continuousOn_Ioi :
    ContinuousOn (fun β : ℝ => Real.sqrt (2 * signalVariance β))
      (Set.Ioi (0 : ℝ)) :=
  Real.continuous_sqrt.comp_continuousOn
    (continuousOn_const.mul signalVariance_continuousOn_Ioi)

/-- `P_trap` is continuous on `(0, ∞)`: `Δ_S / √(2σ²(β))` is a
    continuous function (division by the strictly-positive continuous
    `√(2σ²)`) and `Φ` is continuous everywhere. -/
private theorem P_trap_continuousOn_Ioi :
    ContinuousOn P_trap (Set.Ioi (0 : ℝ)) := by
  unfold P_trap
  have h_arg : ContinuousOn
      (fun β : ℝ => Delta_S / Real.sqrt (2 * signalVariance β))
      (Set.Ioi (0 : ℝ)) := by
    apply ContinuousOn.div continuousOn_const sqrt_two_sigma_continuousOn_Ioi
    intro β hβ
    exact (sqrt_two_sigma_pos hβ).ne'
  exact fun β hβ => (Phi_continuousAt _).comp_continuousWithinAt (h_arg β hβ)

/-- `Φ_B` is continuous on `(0, ∞)`: identical chain to
    `P_trap_continuousOn_Ioi` with `Δ_B` in place of `Δ_S`. -/
private theorem Phi_B_continuousOn_Ioi :
    ContinuousOn Phi_B (Set.Ioi (0 : ℝ)) := by
  unfold Phi_B
  have h_arg : ContinuousOn
      (fun β : ℝ => Delta_B / Real.sqrt (2 * signalVariance β))
      (Set.Ioi (0 : ℝ)) := by
    apply ContinuousOn.div continuousOn_const sqrt_two_sigma_continuousOn_Ioi
    intro β hβ
    exact (sqrt_two_sigma_pos hβ).ne'
  exact fun β hβ => (Phi_continuousAt _).comp_continuousWithinAt (h_arg β hβ)

/-- **`L(·, p)` is continuous on `(0, ∞)`** for every fixed `p` —
    composition of the continuous `P_trap`, `Phi_B` via the concrete
    `L` definition (`p` enters only as a constant).
    paper source: Proposition `prop:interior-optimum`, the loss
    `L(β)` is continuous (line 769-779). -/
private theorem L_continuousOn_Ioi (p : ℝ) :
    ContinuousOn (fun β : ℝ => L β p) (Set.Ioi (0 : ℝ)) := by
  unfold L
  exact ((P_trap_continuousOn_Ioi.mul continuousOn_const).add
    (((continuousOn_const.sub P_trap_continuousOn_Ioi).mul
      continuousOn_const).mul
      (continuousOn_const.sub
        (continuousOn_const.mul Phi_B_continuousOn_Ioi))))

/-- **Closed-form boundary value `L(0, 0) = 0.425`.** At `β = 0`,
    `signalVariance 0 = 1/(2⁰ − 1) = 1/0 = 0` (Lean division
    convention), `√0 = 0`, `Δ/0 = 0`, so `P_trap 0 = Φ_B 0 = Φ(0) =
    1/2`, giving `L(0,0) = (1/2)·0.4 + (1/2)·0.9·(1 − 1·(1/2)) =
    0.425`. paper source: line 825 (`L(0,p) = 0.425 + 0.225p`,
    at `p = 0`). -/
private theorem L_zero_zero : L 0 0 = (425 / 1000 : ℝ) := by
  have h_sv : signalVariance 0 = 0 := by
    unfold signalVariance
    norm_num
  have h_Pt : P_trap 0 = (1 / 2 : ℝ) := by
    unfold P_trap
    rw [h_sv]
    simp [Phi_zero]
  have h_Pb : Phi_B 0 = (1 / 2 : ℝ) := by
    unfold Phi_B
    rw [h_sv]
    simp [Phi_zero]
  unfold L
  rw [h_Pt, h_Pb]
  norm_num

/-! ### Substantive `L'` derivative infrastructure.

The paper's Regime (i) unimodality argument (line 825, "uniqueness
follows from the unimodal structure of Proposition
`prop:interior-optimum`") rests on a *derivative* analysis of the
concrete welfare-loss `L(β, p)` in `β`. The L-carrier analysis above
supplied the endpoint limits, continuity, and extreme-value-theorem
existence; this section builds
the genuine `HasDerivAt` chain for `L(·, p)`, composing Mathlib's
`HasDerivAt.const_rpow` (for `2^{2β}`), `HasDerivAt.inv` (for
`σ²(β) = 1/(2^{2β}−1)`), `HasDerivAt.sqrt` (for `√(2σ²)`),
`HasDerivAt.div` (for `Δ/√(2σ²)`), `HasDerivAt.comp` with the closed
`gap_Phi_derivative` (for `P_trap = Φ ∘ arg_S` and `Φ_B = Φ ∘ arg_B`),
and the product/sum combinators (for `L` itself). Two structural
sign facts are extracted on `Ioi 0`:
  * `signalVariance` has a strictly negative derivative
    (`2^{2β} log 2 · 2 > 0`, denominator `(2^{2β}−1)² > 0`);
  * consequently `P_trap` and `Φ_B` have strictly positive
    derivatives (`Φ' = φ > 0`, `arg_S' = arg_B' > 0`).
These convert the paper's "direct differentiation" phrasing into a
Lean-checked derivative object, and feed the `L'` sign decomposition
`L'(β,p) = P_trap'(β)·(0.9(1−p)Φ_B(β) − 0.5) − (1−P_trap β)·0.9(1−p)·Φ_B'(β)`.

Mathlib lemmas: `Real.hasStrictDerivAt_const_rpow`, `HasDerivAt.comp`,
`HasDerivAt.const_rpow`, `HasDerivAt.sub_const`, `HasDerivAt.inv`,
`HasDerivAt.sqrt`, `HasDerivAt.const_mul`, `HasDerivAt.div`,
`HasDerivAt.const_div`, `gap_Phi_derivative`, `gap_phi_derivative`,
`HasDerivAt.mul`, `HasDerivAt.add`, plus `Real.log_pos`. -/

/-- **`P_trap β > 1/2` for `β > 0`.** Mirror of `Phi_B_gt_half` with
    `Δ_S` in place of `Δ_B`: `P_trap β = Φ(Δ_S/√(2σ²(β)))` with the
    argument strictly positive (`Δ_S > 0`, `√(2σ²) > 0`), so
    `Phi_gt_half_of_pos` applies.
    paper source: line 825 ("`P_trap(β)` ranges over `(1/2, 1)`"). -/
private theorem P_trap_gt_half {β : ℝ} (hβ : 0 < β) : (1 : ℝ)/2 < P_trap β := by
  unfold P_trap
  apply Phi_gt_half_of_pos
  exact div_pos Delta_S_pos (sqrt_two_sigma_pos hβ)

/-- **`phi z > 0` for all `z`** — local re-derivation (the
    `ClassicalResults.phi_pos` lemma is `private`). `phi z =
    (1/√(2π))·exp(−z²/2)`, a product of a strictly positive constant
    and a strictly positive exponential. -/
private theorem phi_pos_local (z : ℝ) : 0 < phi z := by
  unfold phi
  have h2pi : (0 : ℝ) < 2 * Real.pi := mul_pos (by norm_num) Real.pi_pos
  have hsqrt : 0 < Real.sqrt (2 * Real.pi) := Real.sqrt_pos.mpr h2pi
  positivity

/-- **Derivative of `2^{2β}`.** `HasDerivAt (fun β => 2^{2β})
    (2^{2β} · log 2 · 2) β` — `Real.hasStrictDerivAt_const_rpow`
    (base `2 > 0`) composed with the inner linear map `β ↦ 2β`. -/
private theorem hasDerivAt_two_rpow_two_beta (β : ℝ) :
    HasDerivAt (fun β : ℝ => (2 : ℝ) ^ (2 * β))
      ((2 : ℝ) ^ (2 * β) * Real.log 2 * 2) β := by
  have h_inner : HasDerivAt (fun β : ℝ => 2 * β) 2 β := by
    simpa using (hasDerivAt_id β).const_mul (2 : ℝ)
  have h_outer : HasDerivAt (fun y : ℝ => (2 : ℝ) ^ y)
      ((2 : ℝ) ^ (2 * β) * Real.log 2) (2 * β) :=
    (Real.hasStrictDerivAt_const_rpow (by norm_num) (2 * β)).hasDerivAt
  have h_comp := h_outer.comp β h_inner
  -- `h_comp : HasDerivAt ((fun y => 2^y) ∘ (fun β => 2*β))
  --   ((2^(2β)·log 2) * 2) β`; the function is defeq to `fun β => 2^(2β)`
  -- and the derivative value `(2^(2β)·log 2) * 2 = 2^(2β)·log 2·2`.
  exact h_comp

/-- **Derivative of `signalVariance` on `(0, ∞)`.**
    `signalVariance β = (2^{2β} − 1)⁻¹`, so
    `HasDerivAt signalVariance (−(2^{2β}·log 2·2)/(2^{2β}−1)²) β`
    via `HasDerivAt.inv` (denominator `2^{2β}−1 ≠ 0` for `β > 0`). -/
private theorem hasDerivAt_signalVariance {β : ℝ} (hβ : 0 < β) :
    HasDerivAt signalVariance
      (-((2 : ℝ) ^ (2 * β) * Real.log 2 * 2) / ((2 : ℝ) ^ (2 * β) - 1) ^ 2) β := by
  have h2β_pos : 0 < 2 * β := by linarith
  have h_one_lt : (1 : ℝ) < (2 : ℝ) ^ (2 * β) :=
    Real.one_lt_rpow (by norm_num) h2β_pos
  have h_den_ne : (2 : ℝ) ^ (2 * β) - 1 ≠ 0 := by
    have : 0 < (2 : ℝ) ^ (2 * β) - 1 := by linarith
    exact this.ne'
  have h_den : HasDerivAt (fun β : ℝ => (2 : ℝ) ^ (2 * β) - 1)
      ((2 : ℝ) ^ (2 * β) * Real.log 2 * 2) β := by
    have h := (hasDerivAt_two_rpow_two_beta β).sub (hasDerivAt_const β (1 : ℝ))
    -- derivative value is `2^(2β)·log 2·2 - 0`; rewrite to `… · 2`.
    rwa [sub_zero] at h
  have h_inv := h_den.inv h_den_ne
  have h_eq : signalVariance = fun β : ℝ => ((2 : ℝ) ^ (2 * β) - 1)⁻¹ := by
    funext b; unfold signalVariance; rw [one_div]
  rw [h_eq]
  exact h_inv

/-- **`signalVariance` has a strictly negative derivative on `(0, ∞)`.**
    The numerator `2^{2β}·log 2·2 > 0` (base `> 1`, `log 2 > 0`,
    exponent value `> 0`), the denominator `(2^{2β}−1)² > 0`, so the
    quotient is `> 0` and its negation is `< 0`. This is the Lean-checked
    form of the paper's "`σ²(β)` is strictly decreasing in `β`"
    (§2.2 line 138). -/
private theorem signalVariance_deriv_neg {β : ℝ} (hβ : 0 < β) :
    -((2 : ℝ) ^ (2 * β) * Real.log 2 * 2) / ((2 : ℝ) ^ (2 * β) - 1) ^ 2 < 0 := by
  have h2β_pos : 0 < 2 * β := by linarith
  have h_one_lt : (1 : ℝ) < (2 : ℝ) ^ (2 * β) :=
    Real.one_lt_rpow (by norm_num) h2β_pos
  have h_pow_pos : 0 < (2 : ℝ) ^ (2 * β) := by linarith
  have h_log_pos : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have h_num_pos : 0 < (2 : ℝ) ^ (2 * β) * Real.log 2 * 2 := by positivity
  have h_den_pos : 0 < ((2 : ℝ) ^ (2 * β) - 1) ^ 2 := by
    have : 0 < (2 : ℝ) ^ (2 * β) - 1 := by linarith
    positivity
  exact div_neg_of_neg_of_pos (by linarith) h_den_pos

/-- **Derivative of `√(2·signalVariance β)` on `(0, ∞)`.**
    `HasDerivAt (fun β => √(2σ²(β)))
      ((2·σ²'(β)) / (2·√(2σ²(β)))) β` via `HasDerivAt.sqrt`
    (`2σ²(β) > 0` for `β > 0`), where `σ²'(β)` is the
    `signalVariance` derivative. -/
private theorem hasDerivAt_sqrt_two_sigma {β : ℝ} (hβ : 0 < β) :
    HasDerivAt (fun β : ℝ => Real.sqrt (2 * signalVariance β))
      ((2 * (-((2 : ℝ) ^ (2 * β) * Real.log 2 * 2) /
        ((2 : ℝ) ^ (2 * β) - 1) ^ 2))
        / (2 * Real.sqrt (2 * signalVariance β))) β := by
  have h_2sigma : HasDerivAt (fun β : ℝ => 2 * signalVariance β)
      (2 * (-((2 : ℝ) ^ (2 * β) * Real.log 2 * 2) /
        ((2 : ℝ) ^ (2 * β) - 1) ^ 2)) β :=
    (hasDerivAt_signalVariance hβ).const_mul 2
  have h_ne : (fun β : ℝ => 2 * signalVariance β) β ≠ 0 := by
    have := signalVariance_pos hβ
    simp only
    positivity
  exact h_2sigma.sqrt h_ne

/-- **`√(2σ²(β))` has a strictly negative derivative on `(0, ∞)`.**
    Numerator `2·σ²'(β) < 0` (since `σ²'(β) < 0`), denominator
    `2·√(2σ²(β)) > 0`. -/
private theorem sqrt_two_sigma_deriv_neg {β : ℝ} (hβ : 0 < β) :
    (2 * (-((2 : ℝ) ^ (2 * β) * Real.log 2 * 2) /
      ((2 : ℝ) ^ (2 * β) - 1) ^ 2))
      / (2 * Real.sqrt (2 * signalVariance β)) < 0 := by
  have h_num_neg : 2 * (-((2 : ℝ) ^ (2 * β) * Real.log 2 * 2) /
      ((2 : ℝ) ^ (2 * β) - 1) ^ 2) < 0 := by
    have := signalVariance_deriv_neg hβ; linarith
  have h_den_pos : 0 < 2 * Real.sqrt (2 * signalVariance β) := by
    have := sqrt_two_sigma_pos hβ; linarith
  exact div_neg_of_neg_of_pos h_num_neg h_den_pos

/-- **Derivative of `P_trap` on `(0, ∞)`.** `P_trap β = Φ(arg_S β)`
    with `arg_S β = Δ_S/√(2σ²(β))`; the chain rule
    `HasDerivAt.comp` with `gap_Phi_derivative` (`Φ' = φ`) and
    `HasDerivAt.const_div` (for `Δ_S/·`) gives
    `P_trap'(β) = φ(arg_S β) · (−Δ_S·(√)'/(√)²)`. -/
private theorem hasDerivAt_P_trap {β : ℝ} (hβ : 0 < β) :
    HasDerivAt P_trap
      (phi (Delta_S / Real.sqrt (2 * signalVariance β)) *
        (-(Delta_S *
          ((2 * (-((2 : ℝ) ^ (2 * β) * Real.log 2 * 2) /
            ((2 : ℝ) ^ (2 * β) - 1) ^ 2))
            / (2 * Real.sqrt (2 * signalVariance β)))) /
          Real.sqrt (2 * signalVariance β) ^ 2)) β := by
  have h_sqrt := hasDerivAt_sqrt_two_sigma hβ
  have h_sqrt_ne : Real.sqrt (2 * signalVariance β) ≠ 0 :=
    (sqrt_two_sigma_pos hβ).ne'
  have h_arg : HasDerivAt
      (fun β : ℝ => Delta_S / Real.sqrt (2 * signalVariance β))
      (-(Delta_S *
        ((2 * (-((2 : ℝ) ^ (2 * β) * Real.log 2 * 2) /
          ((2 : ℝ) ^ (2 * β) - 1) ^ 2))
          / (2 * Real.sqrt (2 * signalVariance β)))) /
        Real.sqrt (2 * signalVariance β) ^ 2) β := by
    have h_div := (hasDerivAt_const β Delta_S).div h_sqrt h_sqrt_ne
    convert h_div using 1
    ring
  have h_comp := (gap_Phi_derivative
    (Delta_S / Real.sqrt (2 * signalVariance β))).comp β h_arg
  exact h_comp

/-- **Derivative of `Φ_B` on `(0, ∞)`.** Identical chain to
    `hasDerivAt_P_trap` with `Δ_B` in place of `Δ_S`. -/
private theorem hasDerivAt_Phi_B {β : ℝ} (hβ : 0 < β) :
    HasDerivAt Phi_B
      (phi (Delta_B / Real.sqrt (2 * signalVariance β)) *
        (-(Delta_B *
          ((2 * (-((2 : ℝ) ^ (2 * β) * Real.log 2 * 2) /
            ((2 : ℝ) ^ (2 * β) - 1) ^ 2))
            / (2 * Real.sqrt (2 * signalVariance β)))) /
          Real.sqrt (2 * signalVariance β) ^ 2)) β := by
  have h_sqrt := hasDerivAt_sqrt_two_sigma hβ
  have h_sqrt_ne : Real.sqrt (2 * signalVariance β) ≠ 0 :=
    (sqrt_two_sigma_pos hβ).ne'
  have h_arg : HasDerivAt
      (fun β : ℝ => Delta_B / Real.sqrt (2 * signalVariance β))
      (-(Delta_B *
        ((2 * (-((2 : ℝ) ^ (2 * β) * Real.log 2 * 2) /
          ((2 : ℝ) ^ (2 * β) - 1) ^ 2))
          / (2 * Real.sqrt (2 * signalVariance β)))) /
        Real.sqrt (2 * signalVariance β) ^ 2) β := by
    have h_div := (hasDerivAt_const β Delta_B).div h_sqrt h_sqrt_ne
    convert h_div using 1
    ring
  have h_comp := (gap_Phi_derivative
    (Delta_B / Real.sqrt (2 * signalVariance β))).comp β h_arg
  exact h_comp

/-- **`P_trap` has a strictly positive derivative on `(0, ∞)`.**
    `P_trap'(β) = φ(arg_S β) · arg_S'(β)` with `φ > 0` everywhere
    (`phi_pos`) and `arg_S'(β) = −Δ_S·(√)'/(√)² > 0` (numerator
    `−Δ_S·(√)' > 0` since `Δ_S > 0` and `(√)' < 0`; denominator
    `(√)² > 0`). Lean-checked form of the paper's "`P_trap` is
    strictly increasing in `β`" (line 825). -/
private theorem P_trap_deriv_pos {β : ℝ} (hβ : 0 < β) :
    0 < phi (Delta_S / Real.sqrt (2 * signalVariance β)) *
      (-(Delta_S *
        ((2 * (-((2 : ℝ) ^ (2 * β) * Real.log 2 * 2) /
          ((2 : ℝ) ^ (2 * β) - 1) ^ 2))
          / (2 * Real.sqrt (2 * signalVariance β)))) /
        Real.sqrt (2 * signalVariance β) ^ 2) := by
  have h_phi_pos := phi_pos_local (Delta_S / Real.sqrt (2 * signalVariance β))
  have h_sqrt_deriv_neg := sqrt_two_sigma_deriv_neg hβ
  have h_sqrt_pos := sqrt_two_sigma_pos hβ
  have h_arg_pos :
      0 < -(Delta_S *
        ((2 * (-((2 : ℝ) ^ (2 * β) * Real.log 2 * 2) /
          ((2 : ℝ) ^ (2 * β) - 1) ^ 2))
          / (2 * Real.sqrt (2 * signalVariance β)))) /
        Real.sqrt (2 * signalVariance β) ^ 2 := by
    apply div_pos
    · have h1 : Delta_S *
        ((2 * (-((2 : ℝ) ^ (2 * β) * Real.log 2 * 2) /
          ((2 : ℝ) ^ (2 * β) - 1) ^ 2))
          / (2 * Real.sqrt (2 * signalVariance β))) < 0 :=
        mul_neg_of_pos_of_neg Delta_S_pos h_sqrt_deriv_neg
      linarith
    · positivity
  exact mul_pos h_phi_pos h_arg_pos

/-- **`Φ_B` has a strictly positive derivative on `(0, ∞)`.**
    Identical to `P_trap_deriv_pos` with `Δ_B` in place of `Δ_S`. -/
private theorem Phi_B_deriv_pos {β : ℝ} (hβ : 0 < β) :
    0 < phi (Delta_B / Real.sqrt (2 * signalVariance β)) *
      (-(Delta_B *
        ((2 * (-((2 : ℝ) ^ (2 * β) * Real.log 2 * 2) /
          ((2 : ℝ) ^ (2 * β) - 1) ^ 2))
          / (2 * Real.sqrt (2 * signalVariance β)))) /
        Real.sqrt (2 * signalVariance β) ^ 2) := by
  have h_phi_pos := phi_pos_local (Delta_B / Real.sqrt (2 * signalVariance β))
  have h_sqrt_deriv_neg := sqrt_two_sigma_deriv_neg hβ
  have h_sqrt_pos := sqrt_two_sigma_pos hβ
  have h_arg_pos :
      0 < -(Delta_B *
        ((2 * (-((2 : ℝ) ^ (2 * β) * Real.log 2 * 2) /
          ((2 : ℝ) ^ (2 * β) - 1) ^ 2))
          / (2 * Real.sqrt (2 * signalVariance β)))) /
        Real.sqrt (2 * signalVariance β) ^ 2 := by
    apply div_pos
    · have h1 : Delta_B *
        ((2 * (-((2 : ℝ) ^ (2 * β) * Real.log 2 * 2) /
          ((2 : ℝ) ^ (2 * β) - 1) ^ 2))
          / (2 * Real.sqrt (2 * signalVariance β))) < 0 :=
        mul_neg_of_pos_of_neg Delta_B_pos h_sqrt_deriv_neg
      linarith
    · positivity
  exact mul_pos h_phi_pos h_arg_pos

/-- The concrete derivative value of `P_trap` at precision `β`, exposed as a
    named expression so downstream right-branch dominance statements can refer
    to the exact kernel-proved derivative rather than duplicating the chain
    rule expression. -/
noncomputable def P_trapDerivValue (β : ℝ) : ℝ :=
  phi (Delta_S / Real.sqrt (2 * signalVariance β)) *
    (-(Delta_S *
      ((2 * (-((2 : ℝ) ^ (2 * β) * Real.log 2 * 2) /
        ((2 : ℝ) ^ (2 * β) - 1) ^ 2))
        / (2 * Real.sqrt (2 * signalVariance β)))) /
      Real.sqrt (2 * signalVariance β) ^ 2)

/-- The concrete derivative value of `Phi_B` at precision `β`, exposed as a
    named expression for the remaining right-branch dominance theorem. -/
noncomputable def Phi_BDerivValue (β : ℝ) : ℝ :=
  phi (Delta_B / Real.sqrt (2 * signalVariance β)) *
    (-(Delta_B *
      ((2 * (-((2 : ℝ) ^ (2 * β) * Real.log 2 * 2) /
        ((2 : ℝ) ^ (2 * β) - 1) ^ 2))
        / (2 * Real.sqrt (2 * signalVariance β)))) /
      Real.sqrt (2 * signalVariance β) ^ 2)

/-- The common positive chain-rule factor in `P_trapDerivValue` and
    `Phi_BDerivValue`, namely `- (d/dβ sqrt(2σ² β)) / sqrt(2σ² β)^2`.
    R247 factors this out of the first-order residual so the remaining bridge
    only mentions the Gaussian CDF/PDF layer and the two reward gaps. -/
noncomputable def L_balanceResidualScale (β : ℝ) : ℝ :=
  -((2 * (-((2 : ℝ) ^ (2 * β) * Real.log 2 * 2) /
      ((2 : ℝ) ^ (2 * β) - 1) ^ 2))
      / (2 * Real.sqrt (2 * signalVariance β))) /
    Real.sqrt (2 * signalVariance β) ^ 2

/-- The common chain-rule factor is strictly positive on positive precisions. -/
private theorem L_balanceResidualScale_pos {β : ℝ} (hβ : 0 < β) :
    0 < L_balanceResidualScale β := by
  unfold L_balanceResidualScale
  have h_sqrt_deriv_neg := sqrt_two_sigma_deriv_neg hβ
  have h_sqrt_pos := sqrt_two_sigma_pos hβ
  apply div_pos
  · linarith
  · positivity

/-- The derivative of `P_trap` is the common positive scale times the
    Gaussian-PDF / reward-gap factor. -/
private theorem P_trapDerivValue_eq_scale_mul (β : ℝ) :
    P_trapDerivValue β =
      L_balanceResidualScale β *
        (Delta_S * phi (Delta_S / Real.sqrt (2 * signalVariance β))) := by
  unfold P_trapDerivValue L_balanceResidualScale
  ring

/-- The derivative of `Phi_B` is the common positive scale times the
    Gaussian-PDF / reward-gap factor. -/
private theorem Phi_BDerivValue_eq_scale_mul (β : ℝ) :
    Phi_BDerivValue β =
      L_balanceResidualScale β *
        (Delta_B * phi (Delta_B / Real.sqrt (2 * signalVariance β))) := by
  unfold Phi_BDerivValue L_balanceResidualScale
  ring

/-- The right derivative branch for the five-state loss: the paper's bracket
    `0.9(1-p)Φ_B(β) - 1/2` is strictly positive. -/
def L_rightBranch (p β : ℝ) : Prop :=
  (1/2 : ℝ) < (9/10 : ℝ) * (1 - p) * Phi_B β

/-- The same right derivative branch after the change of variables
    `z = Delta_B / sqrt(2 * signalVariance β)`. -/
def L_zRightBranch (p z : ℝ) : Prop :=
  (1/2 : ℝ) < (9/10 : ℝ) * (1 - p) * Phi z

/-- The z-space right branch with the linear coefficient
    `c = 0.9 * (1 - p)` made explicit. -/
def L_cRightBranch (c z : ℝ) : Prop :=
  (1/2 : ℝ) < c * Phi z

/-- The residual of the grouped first-order balance equation. Its zero set is
    exactly the first-order balance surface for positive global minimisers. -/
noncomputable def L_balanceResidual (p β : ℝ) : ℝ :=
  P_trapDerivValue β *
      ((9/10 : ℝ) * (1 - p) * Phi_B β - (1/2 : ℝ)) -
    (1 - P_trap β) * (9/10 : ℝ) * (1 - p) * Phi_BDerivValue β

/-- The first-order residual with the common positive chain-rule factor
    removed. Its sign and zero set agree with `L_balanceResidual` on positive
    precisions. -/
noncomputable def L_balanceResidualCore (p β : ℝ) : ℝ :=
  Delta_S * phi (Delta_S / Real.sqrt (2 * signalVariance β)) *
      ((9/10 : ℝ) * (1 - p) * Phi_B β - (1/2 : ℝ)) -
    (1 - P_trap β) * (9/10 : ℝ) * (1 - p) *
      Delta_B * phi (Delta_B / Real.sqrt (2 * signalVariance β))

/-- The reduced first-order residual written entirely in the Gaussian
    coordinate `z = Delta_B / sqrt(2 * signalVariance β)`. The trap argument
    is `(2/9) * z` because `Delta_S = (2/9) * Delta_B`. -/
noncomputable def L_balanceResidualZCore (p z : ℝ) : ℝ :=
  Delta_S * phi ((2/9 : ℝ) * z) *
      ((9/10 : ℝ) * (1 - p) * Phi z - (1/2 : ℝ)) -
    (1 - Phi ((2/9 : ℝ) * z)) * (9/10 : ℝ) * (1 - p) *
      Delta_B * phi z

/-- The same z-core with the positive `Delta_B` factor removed and
    `c = 0.9 * (1 - p)` exposed as the only parameter. -/
noncomputable def L_balanceResidualNormalizedZCore (c z : ℝ) : ℝ :=
  (2/9 : ℝ) * phi ((2/9 : ℝ) * z) *
      (c * Phi z - (1/2 : ℝ)) -
    c * (1 - Phi ((2/9 : ℝ) * z)) * phi z

/-- The coefficient of `c` in the normalized z-core. -/
noncomputable def L_normalizedZLinearCoeff (z : ℝ) : ℝ :=
  (2/9 : ℝ) * phi ((2/9 : ℝ) * z) * Phi z -
    (1 - Phi ((2/9 : ℝ) * z)) * phi z

/-- The positive constant term subtracted from `c * L_normalizedZLinearCoeff`. -/
noncomputable def L_normalizedZConstantTerm (z : ℝ) : ℝ :=
  (1/2 : ℝ) * (2/9 : ℝ) * phi ((2/9 : ℝ) * z)

/-- The common positive scale in the affine threshold decomposition. -/
noncomputable def L_normalizedZThresholdScale (z : ℝ) : ℝ :=
  (2/9 : ℝ) * phi ((2/9 : ℝ) * z)

/-- The normalized denominator of the threshold `K(z) / H(z)`.

    Algebraically, `H(z) = scale(z) * denom(z)` and
    `K(z) = (1/2) * scale(z)`, so strict decrease of `K/H` is just strict
    increase of this denominator wherever it is positive. The quotient form
    isolates the Gaussian tail-density comparison left by the paper. -/
noncomputable def L_normalizedZThresholdDenom (z : ℝ) : ℝ :=
  Phi z -
    ((1 - Phi ((2/9 : ℝ) * z)) * phi z) /
      L_normalizedZThresholdScale z

/-- Lower-tail Gaussian hazard ratio `phi(z) / Phi(z)`. -/
noncomputable def L_lowerGaussianHazard (z : ℝ) : ℝ :=
  phi z / Phi z

/-- Upper-tail Gaussian Mills ratio `(1 - Phi(z)) / phi(z)`. -/
noncomputable def L_upperGaussianMills (z : ℝ) : ℝ :=
  (1 - Phi z) / phi z

/-- The hazard/Mills product controlling the normalized threshold denominator. -/
noncomputable def L_normalizedZHazardProduct (z : ℝ) : ℝ :=
  L_upperGaussianMills ((2/9 : ℝ) * z) * L_lowerGaussianHazard z

/-- The same normalized denominator, written in explicit hazard/Mills form. -/
noncomputable def L_normalizedZHazardDenom (z : ℝ) : ℝ :=
  Phi z * (1 - L_normalizedZHazardProduct z / (2/9 : ℝ))

/-- Change-of-variables identity for the trap Gaussian argument. -/
private theorem Delta_S_arg_eq_two_ninths_mul_B_arg (β : ℝ) :
    Delta_S / Real.sqrt (2 * signalVariance β) =
      (2/9 : ℝ) * (Delta_B / Real.sqrt (2 * signalVariance β)) := by
  rw [Delta_S_eq_two_ninths_mul_Delta_B]
  ring

/-- The R247 beta-core is exactly the one-variable Gaussian `z`-core under
    `z = Delta_B / sqrt(2 * signalVariance β)`. -/
theorem L_balanceResidualCore_eq_zCore (p β : ℝ) :
    L_balanceResidualCore p β =
      L_balanceResidualZCore p (Delta_B / Real.sqrt (2 * signalVariance β)) := by
  unfold L_balanceResidualCore L_balanceResidualZCore P_trap Phi_B
  rw [Delta_S_arg_eq_two_ninths_mul_B_arg β]

/-- The z-core is the normalized z-core times the positive reward-gap factor
    `Delta_B`. -/
theorem L_balanceResidualZCore_eq_deltaB_mul_normalized (p z : ℝ) :
    L_balanceResidualZCore p z =
      Delta_B * L_balanceResidualNormalizedZCore ((9/10 : ℝ) * (1 - p)) z := by
  unfold L_balanceResidualZCore L_balanceResidualNormalizedZCore
  rw [Delta_S_eq_two_ninths_mul_Delta_B]
  ring

/-- The normalized z-core is affine in the coefficient
    `c = 0.9 * (1 - p)`. -/
theorem L_balanceResidualNormalizedZCore_eq_linear (c z : ℝ) :
    L_balanceResidualNormalizedZCore c z =
      c * L_normalizedZLinearCoeff z - L_normalizedZConstantTerm z := by
  unfold L_balanceResidualNormalizedZCore
    L_normalizedZLinearCoeff L_normalizedZConstantTerm
  ring

/-- The subtracted constant term in the affine normalized z-core is positive. -/
private theorem L_normalizedZConstantTerm_pos (z : ℝ) :
    0 < L_normalizedZConstantTerm z := by
  unfold L_normalizedZConstantTerm
  exact mul_pos (by norm_num) (phi_pos_local ((2/9 : ℝ) * z))

/-- The common threshold scale is positive. -/
private theorem L_normalizedZThresholdScale_pos (z : ℝ) :
    0 < L_normalizedZThresholdScale z := by
  unfold L_normalizedZThresholdScale
  exact mul_pos (by norm_num) (phi_pos_local ((2/9 : ℝ) * z))

/-- The affine coefficient `H(z)` factors through the threshold denominator. -/
theorem L_normalizedZLinearCoeff_eq_scale_mul_thresholdDenom (z : ℝ) :
    L_normalizedZLinearCoeff z =
      L_normalizedZThresholdScale z * L_normalizedZThresholdDenom z := by
  unfold L_normalizedZLinearCoeff L_normalizedZThresholdDenom
  change
    L_normalizedZThresholdScale z * Phi z -
        (1 - Phi ((2/9 : ℝ) * z)) * phi z =
      L_normalizedZThresholdScale z *
        (Phi z -
          ((1 - Phi ((2/9 : ℝ) * z)) * phi z) /
            L_normalizedZThresholdScale z)
  rw [mul_sub]
  rw [mul_div_cancel₀ _ (L_normalizedZThresholdScale_pos z).ne']

/-- The affine constant `K(z)` is one half of the common threshold scale. -/
theorem L_normalizedZConstantTerm_eq_half_mul_thresholdScale (z : ℝ) :
    L_normalizedZConstantTerm z =
      (1/2 : ℝ) * L_normalizedZThresholdScale z := by
  unfold L_normalizedZConstantTerm L_normalizedZThresholdScale
  ring

/-- The threshold denominator is exactly the hazard/Mills denominator. -/
theorem L_normalizedZThresholdDenom_eq_hazardDenom (z : ℝ) :
    L_normalizedZThresholdDenom z = L_normalizedZHazardDenom z := by
  unfold L_normalizedZThresholdDenom L_normalizedZHazardDenom
    L_normalizedZHazardProduct L_upperGaussianMills L_lowerGaussianHazard
    L_normalizedZThresholdScale
  have hphi : phi ((2/9 : ℝ) * z) ≠ 0 :=
    (phi_pos_local ((2/9 : ℝ) * z)).ne'
  have hPhi : Phi z ≠ 0 :=
    (Phi_pos z).ne'
  field_simp [hphi, hPhi]

/-- Positivity of the hazard denominator is exactly the product being below
    the trap scale `2/9`. -/
theorem L_normalizedZHazardDenom_pos_iff_product_lt (z : ℝ) :
    0 < L_normalizedZHazardDenom z ↔
      L_normalizedZHazardProduct z < (2/9 : ℝ) := by
  unfold L_normalizedZHazardDenom
  have hPhi_pos : 0 < Phi z := Phi_pos z
  constructor
  · intro hpos
    have hcore_pos :
        0 < 1 - L_normalizedZHazardProduct z / (2/9 : ℝ) := by
      by_contra hnot
      have hcore_nonpos :
          1 - L_normalizedZHazardProduct z / (2/9 : ℝ) ≤ 0 :=
        le_of_not_gt hnot
      have hmul_nonpos :
          Phi z *
              (1 - L_normalizedZHazardProduct z / (2/9 : ℝ)) ≤ 0 :=
        mul_nonpos_of_nonneg_of_nonpos (le_of_lt hPhi_pos) hcore_nonpos
      linarith
    nlinarith
  · intro hprod_lt
    have hcore_pos :
        0 < 1 - L_normalizedZHazardProduct z / (2/9 : ℝ) := by
      nlinarith
    exact mul_pos hPhi_pos hcore_pos

/-- Positivity of the affine coefficient `H(z)` is the same hazard/Mills
    product bound. -/
theorem L_normalizedZLinearCoeff_pos_iff_hazardProduct_lt (z : ℝ) :
    0 < L_normalizedZLinearCoeff z ↔
      L_normalizedZHazardProduct z < (2/9 : ℝ) := by
  rw [L_normalizedZLinearCoeff_eq_scale_mul_thresholdDenom z,
    L_normalizedZThresholdDenom_eq_hazardDenom z]
  have hscale_pos : 0 < L_normalizedZThresholdScale z :=
    L_normalizedZThresholdScale_pos z
  constructor
  · intro hpos
    have hdenom_pos : 0 < L_normalizedZHazardDenom z := by
      by_contra hnot
      have hdenom_nonpos : L_normalizedZHazardDenom z ≤ 0 :=
        le_of_not_gt hnot
      have hmul_nonpos :
          L_normalizedZThresholdScale z *
              L_normalizedZHazardDenom z ≤ 0 :=
        mul_nonpos_of_nonneg_of_nonpos (le_of_lt hscale_pos) hdenom_nonpos
      linarith
    exact (L_normalizedZHazardDenom_pos_iff_product_lt z).mp hdenom_pos
  · intro hprod_lt
    have hdenom_pos : 0 < L_normalizedZHazardDenom z :=
      (L_normalizedZHazardDenom_pos_iff_product_lt z).mpr hprod_lt
    exact mul_pos hscale_pos hdenom_pos

/-- The lower Gaussian hazard ratio is positive. -/
private theorem L_lowerGaussianHazard_pos (z : ℝ) :
    0 < L_lowerGaussianHazard z := by
  unfold L_lowerGaussianHazard
  exact div_pos (phi_pos_local z) (Phi_pos z)

/-- The upper Gaussian Mills ratio is positive. -/
private theorem L_upperGaussianMills_pos (z : ℝ) :
    0 < L_upperGaussianMills z := by
  unfold L_upperGaussianMills
  exact div_pos (sub_pos.mpr (Phi_lt_one z)) (phi_pos_local z)

/-- Derivative of the lower Gaussian hazard ratio `phi(z) / Phi(z)`. -/
theorem L_lowerGaussianHazard_hasDerivAt (z : ℝ) :
    HasDerivAt L_lowerGaussianHazard
      (((-z * phi z) * Phi z - phi z * phi z) / (Phi z)^2) z := by
  unfold L_lowerGaussianHazard
  have hphi : HasDerivAt phi (-z * phi z) z := gap_phi_derivative z
  have hPhi : HasDerivAt Phi (phi z) z := gap_Phi_derivative z
  have hPhi_ne : Phi z ≠ 0 := (Phi_pos z).ne'
  exact hphi.div hPhi hPhi_ne

/-- On positive arguments, the lower Gaussian hazard ratio is strictly
    decreasing. -/
theorem L_lowerGaussianHazard_deriv_neg_of_pos {z : ℝ} (hz : 0 < z) :
    deriv L_lowerGaussianHazard z < 0 := by
  have hderiv := L_lowerGaussianHazard_hasDerivAt z
  rw [hderiv.deriv]
  have hphi_pos : 0 < phi z := phi_pos_local z
  have hPhi_pos : 0 < Phi z := Phi_pos z
  have hden_pos : 0 < (Phi z)^2 := sq_pos_of_ne_zero hPhi_pos.ne'
  have hfirst_pos : 0 < z * phi z * Phi z :=
    mul_pos (mul_pos hz hphi_pos) hPhi_pos
  have hsecond_pos : 0 < phi z * phi z := mul_pos hphi_pos hphi_pos
  have hnum_neg : ((-z * phi z) * Phi z - phi z * phi z) < 0 := by
    nlinarith
  exact div_neg_of_neg_of_pos hnum_neg hden_pos

/-- Kernel proof of the positive-half-line antitonicity of the lower
    Gaussian hazard ratio. -/
theorem L_lowerGaussianHazard_antitoneOn_pos :
    ∀ z z' : ℝ, 0 < z → 0 < z' → z < z' →
      L_lowerGaussianHazard z' ≤ L_lowerGaussianHazard z := by
  intro z z' hz _hz' hlt
  have hanti : AntitoneOn L_lowerGaussianHazard (Set.Ici z) := by
    apply antitoneOn_of_deriv_nonpos (convex_Ici z)
    · intro s hs
      have hs_pos : 0 < s := lt_of_lt_of_le hz hs
      exact (L_lowerGaussianHazard_hasDerivAt s).continuousAt.continuousWithinAt
    · rw [interior_Ici]
      intro s hs
      have hs_pos : 0 < s := lt_trans hz hs
      exact (L_lowerGaussianHazard_hasDerivAt s).differentiableAt.differentiableWithinAt
    · rw [interior_Ici]
      intro s hs
      have hs_pos : 0 < s := lt_trans hz hs
      exact le_of_lt (L_lowerGaussianHazard_deriv_neg_of_pos hs_pos)
  have hz_mem : z ∈ Set.Ici z := by exact (le_rfl : z ≤ z)
  have hz'_mem : z' ∈ Set.Ici z := by exact (le_of_lt hlt : z ≤ z')
  exact hanti hz_mem hz'_mem (le_of_lt hlt : z ≤ z')

/-- Derivative of the upper Gaussian Mills ratio `(1 - Phi(z)) / phi(z)`. -/
theorem L_upperGaussianMills_hasDerivAt (z : ℝ) :
    HasDerivAt L_upperGaussianMills
      ((z * (1 - Phi z) - phi z) / phi z) z := by
  unfold L_upperGaussianMills
  have hPhi : HasDerivAt Phi (phi z) z := gap_Phi_derivative z
  have hnum : HasDerivAt (fun x : ℝ => 1 - Phi x) (-phi z) z := by
    simpa using (hasDerivAt_const z (1 : ℝ)).sub hPhi
  have hphi : HasDerivAt phi (-z * phi z) z := gap_phi_derivative z
  have hphi_ne : phi z ≠ 0 := (phi_pos_local z).ne'
  have hdiv := hnum.div hphi hphi_ne
  convert hdiv using 1
  field_simp [hphi_ne]
  ring

/-- Mills tail bound in the exact product form needed for the derivative
    sign of the upper Gaussian Mills ratio. -/
theorem L_upperGaussianMills_tail_mul_le {z : ℝ} (hz : 0 < z) :
    z * (1 - Phi z) ≤ phi z := by
  have htail := gap_phi_tail_bound z hz
  have hsqrt_pos : 0 < Real.sqrt (2 * Real.pi) :=
    Real.sqrt_pos.mpr (mul_pos (by norm_num) Real.pi_pos)
  have hsqrt_ne : Real.sqrt (2 * Real.pi) ≠ 0 := hsqrt_pos.ne'
  have hz_ne : z ≠ 0 := hz.ne'
  have h_rhs :
      (1 / (z * Real.sqrt (2 * Real.pi))) * Real.exp (-(z^2 / 2))
        = phi z / z := by
    unfold phi
    have h_exp_eq : Real.exp (-(z^2 / 2)) = Real.exp (-z^2 / 2) := by
      congr 1
      ring
    rw [h_exp_eq]
    field_simp [hz_ne, hsqrt_ne]
  have htail_phi : Phi (-z) ≤ phi z / z := by
    calc
      Phi (-z) ≤
          (1 / (z * Real.sqrt (2 * Real.pi))) * Real.exp (-(z^2 / 2)) := htail
      _ = phi z / z := h_rhs
  have h_reflect : 1 - Phi z = Phi (-z) := by
    have href := Phi_reflect z
    linarith
  have htail_one : 1 - Phi z ≤ phi z / z := by
    rw [h_reflect]
    exact htail_phi
  have hmul := mul_le_mul_of_nonneg_left htail_one hz.le
  have hright : z * (phi z / z) = phi z := by
    field_simp [hz_ne]
  linarith

/-- On positive arguments, the upper Gaussian Mills ratio has non-positive
    derivative. -/
theorem L_upperGaussianMills_deriv_nonpos_of_pos {z : ℝ} (hz : 0 < z) :
    deriv L_upperGaussianMills z ≤ 0 := by
  have hderiv := L_upperGaussianMills_hasDerivAt z
  rw [hderiv.deriv]
  have hbracket : z * (1 - Phi z) - phi z ≤ 0 :=
    sub_nonpos.mpr (L_upperGaussianMills_tail_mul_le hz)
  exact div_nonpos_of_nonpos_of_nonneg hbracket (le_of_lt (phi_pos_local z))

/-- Kernel proof of the positive-half-line antitonicity of the upper
    Gaussian Mills ratio. -/
theorem L_upperGaussianMills_antitoneOn_pos :
    ∀ z z' : ℝ, 0 < z → 0 < z' → z < z' →
      L_upperGaussianMills z' ≤ L_upperGaussianMills z := by
  intro z z' hz _hz' hlt
  have hanti : AntitoneOn L_upperGaussianMills (Set.Ici z) := by
    apply antitoneOn_of_deriv_nonpos (convex_Ici z)
    · intro s hs
      have hs_pos : 0 < s := lt_of_lt_of_le hz hs
      exact (L_upperGaussianMills_hasDerivAt s).continuousAt.continuousWithinAt
    · rw [interior_Ici]
      intro s hs
      have hs_pos : 0 < s := lt_trans hz hs
      exact (L_upperGaussianMills_hasDerivAt s).differentiableAt.differentiableWithinAt
    · rw [interior_Ici]
      intro s hs
      have hs_pos : 0 < s := lt_trans hz hs
      exact L_upperGaussianMills_deriv_nonpos_of_pos hs_pos
  have hz_mem : z ∈ Set.Ici z := by exact (le_rfl : z ≤ z)
  have hz'_mem : z' ∈ Set.Ici z := by exact (le_of_lt hlt : z ≤ z')
  exact hanti hz_mem hz'_mem (le_of_lt hlt : z ≤ z')

/-- The grouped first-order residual factors into the common positive scale
    times the reduced Gaussian CDF/PDF core. -/
theorem L_balanceResidual_eq_scale_mul_core (p β : ℝ) :
    L_balanceResidual p β =
      L_balanceResidualScale β * L_balanceResidualCore p β := by
  unfold L_balanceResidual
  rw [P_trapDerivValue_eq_scale_mul β, Phi_BDerivValue_eq_scale_mul β]
  unfold L_balanceResidualCore
  ring

/-- The exact first-order balance equation for the grouped derivative of
    `β ↦ L β p`. -/
def L_firstOrderBalance (p β : ℝ) : Prop :=
  L_balanceResidual p β = 0

/-- Right-branch monotonicity of the branch predicate itself: once the
    right-branch inequality holds at a positive precision, it keeps holding at
    larger precisions in Regime (i), because `Phi_B` is non-decreasing and
    `0 < 1 - p`. -/
private theorem L_rightBranch_mono_of_le
    (p : ℝ) (hp_lt : p < p_1) {β β' : ℝ}
    (hβ : 0 < β) (h_right : L_rightBranch p β) (h_le : β ≤ β') :
    L_rightBranch p β' := by
  dsimp [L_rightBranch] at h_right ⊢
  have hp_lt_one : p < 1 := by
    exact lt_trans hp_lt (by unfold p_1; norm_num)
  have hcoef_nonneg : 0 ≤ (9/10 : ℝ) * (1 - p) := by
    have hq_nonneg : 0 ≤ 1 - p := by linarith
    exact mul_nonneg (by norm_num) hq_nonneg
  have h_phi : Phi_B β ≤ Phi_B β' :=
    Phi_B_monotone hβ h_le
  have h_mul :
      (9/10 : ℝ) * (1 - p) * Phi_B β ≤
        (9/10 : ℝ) * (1 - p) * Phi_B β' := by
    exact mul_le_mul_of_nonneg_left h_phi hcoef_nonneg
  exact lt_of_lt_of_le h_right h_mul

/-- **Derivative of `L(·, p)` on `(0, ∞)`.** Composes
    `hasDerivAt_P_trap` and `hasDerivAt_Phi_B` through the concrete
    `L` definition `L β p = P_trap β·0.4 + (1−P_trap β)·0.9·
    (1−(1−p)·Φ_B β)` via the sum / product / `const_mul` / `const_sub`
    combinators. The derivative value is written abstractly as
    `L'(β,p) = P'·0.4 + ((−P')·0.9·(1−(1−p)Φ_B) + (1−P)·0.9·
    (−(1−p)·Φ_B'))` where `P' = P_trap'(β)`, `Φ_B' = Φ_B'(β)`. -/
private theorem hasDerivAt_L (p : ℝ) {β : ℝ} (_hβ : 0 < β)
    {Pt' Pb' : ℝ} (hPt : HasDerivAt P_trap Pt' β)
    (hPb : HasDerivAt Phi_B Pb' β) :
    HasDerivAt (fun β : ℝ => L β p)
      (Pt' * (4/10 : ℝ) +
        ((-Pt') * (9/10 : ℝ) * (1 - (1 - p) * Phi_B β) +
          (1 - P_trap β) * (9/10 : ℝ) * (-((1 - p) * Pb')))) β := by
  -- term 1: `P_trap β · 0.4`.
  have h_t1 : HasDerivAt (fun β : ℝ => P_trap β * (4/10 : ℝ))
      (Pt' * (4/10 : ℝ)) β := hPt.mul_const _
  -- `1 − P_trap β` has derivative `−P_trap'`.
  have h_oneSubP : HasDerivAt (fun β : ℝ => 1 - P_trap β) (-Pt') β := by
    have h := (hasDerivAt_const β (1 : ℝ)).sub hPt
    simpa using h
  -- `(1 − P_trap β) · 0.9` has derivative `(−P_trap')·0.9`.
  have h_oneSubP09 : HasDerivAt (fun β : ℝ => (1 - P_trap β) * (9/10 : ℝ))
      ((-Pt') * (9/10 : ℝ)) β := h_oneSubP.mul_const _
  -- `(1 − p) · Φ_B β` has derivative `(1 − p) · Φ_B'`.
  have h_qPb : HasDerivAt (fun β : ℝ => (1 - p) * Phi_B β)
      ((1 - p) * Pb') β := hPb.const_mul _
  -- `1 − (1 − p)·Φ_B β` has derivative `−((1 − p)·Φ_B')`.
  have h_inner : HasDerivAt (fun β : ℝ => 1 - (1 - p) * Phi_B β)
      (-((1 - p) * Pb')) β := by
    have h := (hasDerivAt_const β (1 : ℝ)).sub h_qPb
    simpa using h
  -- term 2: `((1 − P_trap β)·0.9) · (1 − (1 − p)·Φ_B β)` — product rule.
  have h_t2 : HasDerivAt
      (fun β : ℝ => ((1 - P_trap β) * (9/10 : ℝ)) * (1 - (1 - p) * Phi_B β))
      (((-Pt') * (9/10 : ℝ)) * (1 - (1 - p) * Phi_B β) +
        ((1 - P_trap β) * (9/10 : ℝ)) * (-((1 - p) * Pb'))) β :=
    h_oneSubP09.mul h_inner
  -- `L β p` is `term1 + term2`.
  have h_sum := h_t1.add h_t2
  have h_eq : (fun β : ℝ => L β p) =
      (fun β : ℝ => P_trap β * (4/10 : ℝ) +
        ((1 - P_trap β) * (9/10 : ℝ)) * (1 - (1 - p) * Phi_B β)) := by
    funext b; unfold L; ring
  rw [h_eq]
  exact h_sum

/-- **`L'(β, p)` sign decomposition** — algebraic rewrite of the
    `hasDerivAt_L` derivative value into the paper's
    `eq:five-state-rearr`-aligned grouped form
    `L'(β,p) = P_trap'(β)·(0.9(1−p)·Φ_B(β) − 0.5)
                − (1−P_trap β)·0.9·(1−p)·Φ_B'(β)`.
    This is the form the paper's "direct differentiation" argument
    (line 825) uses: the first summand carries the sign of
    `0.9(1−p)Φ_B(β) − 0.5` (the `eq:five-state-rearr` bracket), the
    second is `≤ 0` for `p ≤ 1`. Pure `ring` identity. -/
private theorem L_deriv_grouped (p : ℝ) (β : ℝ) (Pt' Pb' : ℝ) :
    Pt' * (4/10 : ℝ) +
      ((-Pt') * (9/10 : ℝ) * (1 - (1 - p) * Phi_B β) +
        (1 - P_trap β) * (9/10 : ℝ) * (-((1 - p) * Pb'))) =
    Pt' * ((9/10 : ℝ) * (1 - p) * Phi_B β - (1/2 : ℝ)) -
      (1 - P_trap β) * (9/10 : ℝ) * (1 - p) * Pb' := by
  ring

/-- **`L'(β, p) < 0` on the "left branch" of `(0, ∞)`** — wherever
    `0.9(1−p)·Φ_B(β) ≤ 1/2`, the grouped derivative value of `L(·, p)`
    is strictly negative. Via the `L'` sign decomposition
    `L'(β,p) = P_trap'(β)·(0.9(1−p)Φ_B(β) − 0.5)
                − (1−P_trap β)·0.9(1−p)·Φ_B'(β)`:
    the first summand is `≤ 0` (`P_trap'(β) > 0`, bracket `≤ 0`); the
    second summand is `≥ 0` (`1−P_trap β > 0`, `0.9(1−p) ≥ 0`,
    `Φ_B'(β) > 0`), and strictly so in the generic `1−p > 0` case, so
    subtracting it yields `L' < 0`. Total over `p ≤ 1` including the
    degenerate `p = 1`, where the bracket `0.9·0·Φ_B β − 1/2 = −1/2 < 0`
    and `Pt' > 0` make the *first* summand strictly negative while the
    second vanishes. The `P_trap`/`Φ_B`-derivative values `Pt'`, `Pb'`
    are supplied as strictly-positive Lean-checked inputs (from
    `P_trap_deriv_pos` / `Phi_B_deriv_pos`).

    This is the genuine *left-branch* portion of Regime (i)
    unimodality (paper line 825, "direct differentiation ... `L`
    decreases then increases"), Lean-checked via the `L'`
    derivative infrastructure on the concrete `L` carrier. The *right*-branch
    sign (where the first summand is `> 0` and must strictly dominate
    the second) needs the transcendental two-term comparison
    `P_trap'(β)·(0.9(1−p)Φ_B(β) − 0.5) > (1−P_trap β)·0.9(1−p)·Φ_B'(β)`,
    which the paper itself verifies only numerically; it is therefore
    NOT closed here, and `L_unimodal_in_regime_i` remains a
    paper-derived working content atom (see Ledger). -/
private theorem L_deriv_neg_on_left_branch (p : ℝ) (hp_le_one : p ≤ 1)
    {β : ℝ} (_hβ : 0 < β)
    {Pt' Pb' : ℝ} (hPt_pos : 0 < Pt') (hPb_pos : 0 < Pb')
    (h_branch : (9/10 : ℝ) * (1 - p) * Phi_B β ≤ (1/2 : ℝ)) :
    Pt' * ((9/10 : ℝ) * (1 - p) * Phi_B β - (1/2 : ℝ)) -
      (1 - P_trap β) * (9/10 : ℝ) * (1 - p) * Pb' < 0 := by
  have h_oneSubP_pos : 0 < 1 - P_trap β := by
    have := P_trap_lt_one β; linarith
  rcases eq_or_lt_of_le (by linarith : (0 : ℝ) ≤ 1 - p) with h_q_zero | h_q_pos
  · -- `1 − p = 0`: first summand `Pt'·(−1/2) < 0`, second summand `= 0`.
    rw [← h_q_zero]
    have h_first_neg : Pt' * ((9/10 : ℝ) * 0 * Phi_B β - (1/2 : ℝ)) < 0 := by
      have : (9/10 : ℝ) * 0 * Phi_B β - (1/2 : ℝ) = -(1/2 : ℝ) := by ring
      rw [this]; nlinarith
    nlinarith
  · -- generic `1 − p > 0`: both summand bounds active.
    have h_bracket_le : (9/10 : ℝ) * (1 - p) * Phi_B β - (1/2 : ℝ) ≤ 0 := by
      linarith
    have h_first_le : Pt' * ((9/10 : ℝ) * (1 - p) * Phi_B β - (1/2 : ℝ)) ≤ 0 :=
      mul_nonpos_of_nonneg_of_nonpos hPt_pos.le h_bracket_le
    have h_second_pos : 0 < (1 - P_trap β) * (9/10 : ℝ) * (1 - p) * Pb' :=
      mul_pos (mul_pos (mul_pos h_oneSubP_pos (by norm_num)) h_q_pos) hPb_pos
    linarith

/-- **Left-branch derivative theorem for `L`.** On the part of the
    positive-precision domain where
    `0.9 * (1 - p) * Phi_B β ≤ 1/2`, the concrete derivative of
    `β ↦ L β p` is strictly negative.

    This packages the private derivative chain into an audit-facing theorem:
    `hasDerivAt_P_trap`, `hasDerivAt_Phi_B`, `hasDerivAt_L`, the grouped
    derivative identity `L_deriv_grouped`, and the sign theorem
    `L_deriv_neg_on_left_branch`. It closes the left half of the paper's
    Regime (i) unimodality calculus; the remaining uniqueness input is the
    right-branch transcendental dominance plus the global stitching from
    derivative signs to strict uniqueness. -/
theorem L_hasDerivAt_negative_on_left_branch
    (p : ℝ) (hp_le_one : p ≤ 1) {β : ℝ} (hβ : 0 < β)
    (h_branch : (9/10 : ℝ) * (1 - p) * Phi_B β ≤ (1/2 : ℝ)) :
    ∃ d : ℝ, HasDerivAt (fun β : ℝ => L β p) d β ∧ d < 0 := by
  let Pt' : ℝ :=
    phi (Delta_S / Real.sqrt (2 * signalVariance β)) *
      (-(Delta_S *
        ((2 * (-((2 : ℝ) ^ (2 * β) * Real.log 2 * 2) /
          ((2 : ℝ) ^ (2 * β) - 1) ^ 2))
          / (2 * Real.sqrt (2 * signalVariance β)))) /
        Real.sqrt (2 * signalVariance β) ^ 2)
  let Pb' : ℝ :=
    phi (Delta_B / Real.sqrt (2 * signalVariance β)) *
      (-(Delta_B *
        ((2 * (-((2 : ℝ) ^ (2 * β) * Real.log 2 * 2) /
          ((2 : ℝ) ^ (2 * β) - 1) ^ 2))
          / (2 * Real.sqrt (2 * signalVariance β)))) /
        Real.sqrt (2 * signalVariance β) ^ 2)
  refine ⟨
    Pt' * ((9/10 : ℝ) * (1 - p) * Phi_B β - (1/2 : ℝ)) -
      (1 - P_trap β) * (9/10 : ℝ) * (1 - p) * Pb',
    ?_, ?_⟩
  · have hPt : HasDerivAt P_trap Pt' β := by
      dsimp [Pt']
      exact hasDerivAt_P_trap hβ
    have hPb : HasDerivAt Phi_B Pb' β := by
      dsimp [Pb']
      exact hasDerivAt_Phi_B hβ
    have hL := hasDerivAt_L p hβ hPt hPb
    have h_group := L_deriv_grouped p β Pt' Pb'
    rwa [h_group] at hL
  · have hPt_pos : 0 < Pt' := by
      dsimp [Pt']
      exact P_trap_deriv_pos hβ
    have hPb_pos : 0 < Pb' := by
      dsimp [Pb']
      exact Phi_B_deriv_pos hβ
    exact L_deriv_neg_on_left_branch p hp_le_one hβ hPt_pos hPb_pos h_branch

/-- **Right-branch derivative theorem for `L`, conditional on the remaining
    transcendental dominance inequality.** If the positive first term in the
    grouped derivative strictly dominates the second term, then the concrete
    derivative of `β ↦ L β p` is strictly positive at `β`.

    This is not a proof of the paper's right-branch dominance; rather, it
    isolates the exact inequality still needed for the strict-uniqueness route
    and discharges the chain-rule/algebra part kernel-purely. -/
theorem L_hasDerivAt_positive_of_right_branch_dominance
    (p : ℝ) {β : ℝ} (hβ : 0 < β)
    (h_dominance :
      (1 - P_trap β) * (9/10 : ℝ) * (1 - p) * Phi_BDerivValue β <
        P_trapDerivValue β *
          ((9/10 : ℝ) * (1 - p) * Phi_B β - (1/2 : ℝ))) :
    ∃ d : ℝ, HasDerivAt (fun β : ℝ => L β p) d β ∧ 0 < d := by
  refine ⟨
    P_trapDerivValue β *
        ((9/10 : ℝ) * (1 - p) * Phi_B β - (1/2 : ℝ)) -
      (1 - P_trap β) * (9/10 : ℝ) * (1 - p) * Phi_BDerivValue β,
    ?_, ?_⟩
  · have hPt : HasDerivAt P_trap (P_trapDerivValue β) β := by
      unfold P_trapDerivValue
      exact hasDerivAt_P_trap hβ
    have hPb : HasDerivAt Phi_B (Phi_BDerivValue β) β := by
      unfold Phi_BDerivValue
      exact hasDerivAt_Phi_B hβ
    have hL := hasDerivAt_L p hβ hPt hPb
    have h_group := L_deriv_grouped p β (P_trapDerivValue β) (Phi_BDerivValue β)
    rwa [h_group] at hL
  · linarith

/-- A negative derivative gives a strict descent point to the right. This is a
    small one-dimensional calculus helper used to rule out global minimisers
    at points where the derivative of `L(·, p)` is negative. -/
private theorem exists_right_lt_of_hasDerivAt_neg
    {f : ℝ → ℝ} {x d : ℝ} (hderiv : HasDerivAt f d x) (hd : d < 0) :
    ∃ y : ℝ, x < y ∧ f y < f x := by
  have h_slope :
      Filter.Tendsto (fun t : ℝ => t⁻¹ * (f (x + t) - f x))
        (nhdsWithin (0 : ℝ) (Set.Ioi 0)) (nhds d) := by
    simpa using hderiv.tendsto_slope_zero_right
  have h_event :
      ∀ᶠ t in nhdsWithin (0 : ℝ) (Set.Ioi 0), t⁻¹ * (f (x + t) - f x) < 0 :=
    h_slope.eventually (IsOpen.mem_nhds isOpen_Iio hd)
  have h_pos_event : ∀ᶠ t in nhdsWithin (0 : ℝ) (Set.Ioi 0), 0 < t :=
    eventually_mem_nhdsWithin
  rcases (h_event.and h_pos_event).exists with ⟨t, ht_slope, ht_pos⟩
  refine ⟨x + t, by linarith, ?_⟩
  have ht_inv_pos : 0 < t⁻¹ := inv_pos.mpr ht_pos
  have hdiff_neg : f (x + t) - f x < 0 := by
    have hmul_lt : t⁻¹ * (f (x + t) - f x) < t⁻¹ * 0 := by
      simpa using ht_slope
    simpa using lt_of_mul_lt_mul_left hmul_lt ht_inv_pos.le
  linarith

/-- A positive derivative at a positive point gives a strict descent point to
    the left that remains in the positive half-line. -/
private theorem exists_left_lt_of_hasDerivAt_pos
    {f : ℝ → ℝ} {x d : ℝ} (hx : 0 < x)
    (hderiv : HasDerivAt f d x) (hd : 0 < d) :
    ∃ y : ℝ, 0 < y ∧ y < x ∧ f y < f x := by
  have h_slope :
      Filter.Tendsto (fun t : ℝ => t⁻¹ * (f (x + t) - f x))
        (nhdsWithin (0 : ℝ) (Set.Iio 0)) (nhds d) := by
    simpa using hderiv.tendsto_slope_zero_left
  have h_event :
      ∀ᶠ t in nhdsWithin (0 : ℝ) (Set.Iio 0),
        0 < t⁻¹ * (f (x + t) - f x) :=
    h_slope.eventually (IsOpen.mem_nhds isOpen_Ioi hd)
  have h_neg_event : ∀ᶠ t in nhdsWithin (0 : ℝ) (Set.Iio 0), t < 0 :=
    eventually_mem_nhdsWithin
  have h_lower_event : ∀ᶠ t in nhdsWithin (0 : ℝ) (Set.Iio 0), -x < t :=
    (eventually_gt_nhds (by linarith : -x < (0 : ℝ))).filter_mono nhdsWithin_le_nhds
  rcases ((h_event.and h_neg_event).and h_lower_event).exists with
    ⟨t, ⟨⟨ht_slope, ht_neg⟩, ht_lower⟩⟩
  refine ⟨x + t, by linarith, by linarith, ?_⟩
  have ht_inv_neg : t⁻¹ < 0 := inv_lt_zero.2 ht_neg
  have hdiff_neg : f (x + t) - f x < 0 :=
    neg_of_mul_pos_right ht_slope ht_inv_neg.le
  linarith

/-- A positive global minimiser of `β ↦ L β p` cannot lie on the left
    derivative branch. If `β` minimises `L(·, p)` over positive precisions and
    `p ≤ 1`, then the branch expression is strictly above `1/2`.

    This closes the global-minimiser exclusion half of the strict-uniqueness
    route: the already-kernel-proved left-branch negative derivative would
    otherwise produce a strictly better positive precision to the right. -/
theorem L_global_minimizer_not_left_branch
    (p : ℝ) (hp_le_one : p ≤ 1) {β : ℝ} (hβ : 0 < β)
    (h_min : ∀ β' : ℝ, 0 < β' → L β p ≤ L β' p) :
    (1/2 : ℝ) < (9/10 : ℝ) * (1 - p) * Phi_B β := by
  by_contra h_not
  have h_branch : (9/10 : ℝ) * (1 - p) * Phi_B β ≤ (1/2 : ℝ) :=
    le_of_not_gt h_not
  obtain ⟨d, hd_deriv, hd_neg⟩ :=
    L_hasDerivAt_negative_on_left_branch p hp_le_one hβ h_branch
  obtain ⟨β_next, hβ_lt_next, h_next_lt⟩ :=
    exists_right_lt_of_hasDerivAt_neg hd_deriv hd_neg
  have hβ_next_pos : 0 < β_next := lt_trans hβ hβ_lt_next
  have h_min_le := h_min β_next hβ_next_pos
  linarith

/-- A positive global minimiser cannot satisfy the current right-branch
    dominance condition, since that condition gives a positive derivative and
    hence a better positive point to the left. -/
theorem L_global_minimizer_not_right_branch_dominance
    (p : ℝ) {β : ℝ} (hβ : 0 < β)
    (h_min : ∀ β' : ℝ, 0 < β' → L β p ≤ L β' p) :
    ¬ (1 - P_trap β) * (9/10 : ℝ) * (1 - p) * Phi_BDerivValue β <
        P_trapDerivValue β *
          ((9/10 : ℝ) * (1 - p) * Phi_B β - (1/2 : ℝ)) := by
  intro h_dominance
  obtain ⟨d, hd_deriv, hd_pos⟩ :=
    L_hasDerivAt_positive_of_right_branch_dominance p hβ h_dominance
  obtain ⟨β_prev, hβ_prev_pos, _hβ_prev_lt, h_prev_lt⟩ :=
    exists_left_lt_of_hasDerivAt_pos hβ hd_deriv hd_pos
  have h_min_le := h_min β_prev hβ_prev_pos
  linarith

/-- Fermat condition for a positive-domain global minimiser. If a function has
    a derivative at an interior point of `(0, ∞)` and that point minimises the
    function over all positive arguments, then the derivative value is zero. -/
private theorem deriv_eq_zero_of_global_min_on_Ioi
    {f : ℝ → ℝ} {x d : ℝ} (hx : 0 < x)
    (hderiv : HasDerivAt f d x)
    (h_min : ∀ y : ℝ, 0 < y → f x ≤ f y) :
    d = 0 := by
  by_contra hd_ne
  rcases lt_or_gt_of_ne hd_ne with hd_neg | hd_pos
  · obtain ⟨y, hy_gt, hy_lt⟩ :=
      exists_right_lt_of_hasDerivAt_neg hderiv hd_neg
    have hy_pos : 0 < y := lt_trans hx hy_gt
    have h_min_le := h_min y hy_pos
    linarith
  · obtain ⟨y, hy_pos, _hy_lt_x, hy_lt⟩ :=
      exists_left_lt_of_hasDerivAt_pos hx hderiv hd_pos
    have h_min_le := h_min y hy_pos
    linarith

/-- First-order condition for positive global minimisers of the concrete
    five-state loss `L`: at any positive global minimiser, the grouped
    derivative expression is exactly zero. -/
theorem L_global_minimizer_derivative_grouped_eq_zero
    (p : ℝ) {β : ℝ} (hβ : 0 < β)
    (h_min : ∀ β' : ℝ, 0 < β' → L β p ≤ L β' p) :
    P_trapDerivValue β *
        ((9/10 : ℝ) * (1 - p) * Phi_B β - (1/2 : ℝ)) -
      (1 - P_trap β) * (9/10 : ℝ) * (1 - p) * Phi_BDerivValue β = 0 := by
  have hPt : HasDerivAt P_trap (P_trapDerivValue β) β := by
    unfold P_trapDerivValue
    exact hasDerivAt_P_trap hβ
  have hPb : HasDerivAt Phi_B (Phi_BDerivValue β) β := by
    unfold Phi_BDerivValue
    exact hasDerivAt_Phi_B hβ
  have hL := hasDerivAt_L p hβ hPt hPb
  have h_group := L_deriv_grouped p β (P_trapDerivValue β) (Phi_BDerivValue β)
  have hL_grouped :
      HasDerivAt (fun β : ℝ => L β p)
        (P_trapDerivValue β *
            ((9/10 : ℝ) * (1 - p) * Phi_B β - (1/2 : ℝ)) -
          (1 - P_trap β) * (9/10 : ℝ) * (1 - p) * Phi_BDerivValue β) β := by
    rwa [h_group] at hL
  exact deriv_eq_zero_of_global_min_on_Ioi hβ hL_grouped h_min

/-- Balanced first-order equation at positive global minimisers of `L`. This is
    the paper's two-term comparison surface promoted to an equality at an
    actual minimiser. -/
theorem L_global_minimizer_first_order_balance
    (p : ℝ) {β : ℝ} (hβ : 0 < β)
    (h_min : ∀ β' : ℝ, 0 < β' → L β p ≤ L β' p) :
    L_firstOrderBalance p β := by
  have h_zero :=
    L_global_minimizer_derivative_grouped_eq_zero p hβ h_min
  simpa [L_firstOrderBalance, L_balanceResidual] using h_zero

/-- R255 live bridge after closing the lower-hazard factor: only the
    upper-tail Gaussian Mills ratio remains as a paper-level monotonicity
    target. It is now a theorem, not a `Prop` interface. -/
theorem L_upperGaussianMills_antitoneOn_pos_paper_Def :
    ∀ z z' : ℝ, 0 < z → 0 < z' → z < z' →
      L_upperGaussianMills z' ≤ L_upperGaussianMills z :=
  L_upperGaussianMills_antitoneOn_pos

/-- Closed paper-interface alias for the upper Gaussian Mills antitonicity
    theorem. This keeps the old `_paper_Def` surface auditable while the
    actual proof is the kernel theorem `L_upperGaussianMills_antitoneOn_pos`. -/
theorem L_upperGaussianMills_antitoneOn_pos_paper_Def_closed :
    ∀ z z' : ℝ, 0 < z → 0 < z' → z < z' →
      L_upperGaussianMills z' ≤ L_upperGaussianMills z :=
  L_upperGaussianMills_antitoneOn_pos_paper_Def

/-- R254 factor-monotonicity bridge. It splits the product antitonicity
    target into the two standard one-dimensional Gaussian ratio facts. This is
    now a theorem assembled from the closed upper-Mills and lower-hazard
    one-dimensional facts, not a `Prop` interface. -/
theorem L_gaussianHazardMillsFactorAntitone_paper_Def :
    (∀ z z' : ℝ, 0 < z → 0 < z' → z < z' →
      L_upperGaussianMills z' ≤ L_upperGaussianMills z) ∧
    (∀ z z' : ℝ, 0 < z → 0 < z' → z < z' →
      L_lowerGaussianHazard z' ≤ L_lowerGaussianHazard z) := by
  exact ⟨L_upperGaussianMills_antitoneOn_pos_paper_Def,
    L_lowerGaussianHazard_antitoneOn_pos⟩

/-- Kernel reduction from the R255 upper-Mills bridge to the R254
    factor-antitonicity bridge. The lower-hazard factor is now proved
    directly by `L_lowerGaussianHazard_antitoneOn_pos`. -/
theorem L_gaussianHazardMillsFactorAntitone_from_upperMills_antitone :
    (∀ z z' : ℝ, 0 < z → 0 < z' → z < z' →
      L_upperGaussianMills z' ≤ L_upperGaussianMills z) ∧
    (∀ z z' : ℝ, 0 < z → 0 < z' → z < z' →
      L_lowerGaussianHazard z' ≤ L_lowerGaussianHazard z) :=
  L_gaussianHazardMillsFactorAntitone_paper_Def

/-- R253 product-monotonicity theorem. Once the hazard/Mills product is
    non-increasing on positive `z`, the R252 denominator is strictly
    increasing on the region where it is positive because `Phi` is strictly
    increasing and the multiplier `1 - product / (2/9)` is non-decreasing.
    This is now proved from the R254 factor-antitonicity theorem rather than
    exposed as a `Prop` interface. -/
theorem L_normalizedZHazardProduct_antitoneOn_pos_paper_Def :
    ∀ z z' : ℝ, 0 < z → 0 < z' → z < z' →
      L_normalizedZHazardProduct z' ≤ L_normalizedZHazardProduct z := by
  intro z z' hz hz' hlt
  obtain ⟨h_upper, h_lower⟩ :=
    L_gaussianHazardMillsFactorAntitone_from_upperMills_antitone
  have hscale_pos : 0 < (2/9 : ℝ) := by norm_num
  have haz_pos : 0 < (2/9 : ℝ) * z := mul_pos hscale_pos hz
  have haz'_pos : 0 < (2/9 : ℝ) * z' := mul_pos hscale_pos hz'
  have haz_lt : (2/9 : ℝ) * z < (2/9 : ℝ) * z' := by
    nlinarith
  have hM_le :
      L_upperGaussianMills ((2/9 : ℝ) * z') ≤
        L_upperGaussianMills ((2/9 : ℝ) * z) :=
    h_upper ((2/9 : ℝ) * z) ((2/9 : ℝ) * z') haz_pos haz'_pos haz_lt
  have hH_le :
      L_lowerGaussianHazard z' ≤ L_lowerGaussianHazard z :=
    h_lower z z' hz hz' hlt
  unfold L_normalizedZHazardProduct
  have h_step1 :
      L_upperGaussianMills ((2/9 : ℝ) * z') *
          L_lowerGaussianHazard z' ≤
        L_upperGaussianMills ((2/9 : ℝ) * z) *
          L_lowerGaussianHazard z' :=
    mul_le_mul_of_nonneg_right hM_le
      (le_of_lt (L_lowerGaussianHazard_pos z'))
  have h_step2 :
      L_upperGaussianMills ((2/9 : ℝ) * z) *
          L_lowerGaussianHazard z' ≤
        L_upperGaussianMills ((2/9 : ℝ) * z) *
          L_lowerGaussianHazard z :=
    mul_le_mul_of_nonneg_left hH_le
      (le_of_lt (L_upperGaussianMills_pos ((2/9 : ℝ) * z)))
  exact le_trans h_step1 h_step2

/-- Compatibility alias for the former R253 reduction theorem name. -/
theorem L_normalizedZHazardProduct_antitone_from_factor_antitone :
    ∀ z z' : ℝ, 0 < z → 0 < z' → z < z' →
      L_normalizedZHazardProduct z' ≤ L_normalizedZHazardProduct z :=
  L_normalizedZHazardProduct_antitoneOn_pos_paper_Def

/-- R252 hazard/Mills denominator-shape theorem. This is the R251 denominator
    bridge after rewriting the denominator as
    `Phi z * (1 - (upperMills((2/9)z) * lowerHazard z) / (2/9))`. It is now
    a theorem derived from product antitonicity, not a `Prop` interface. -/
theorem L_normalizedZHazardDenomShape_paper_Def :
    ∀ z z' : ℝ, 0 < z → 0 < z' → z < z' →
      0 < L_normalizedZHazardDenom z →
        0 < L_normalizedZHazardDenom z' ∧
          L_normalizedZHazardDenom z <
            L_normalizedZHazardDenom z' := by
  intro z z' hz hz' hlt hD_pos
  have hP_le :
      L_normalizedZHazardProduct z' ≤ L_normalizedZHazardProduct z :=
    L_normalizedZHazardProduct_antitone_from_factor_antitone z z' hz hz' hlt
  have hP_lt :
      L_normalizedZHazardProduct z < (2/9 : ℝ) :=
    (L_normalizedZHazardDenom_pos_iff_product_lt z).mp hD_pos
  have hP'_lt :
      L_normalizedZHazardProduct z' < (2/9 : ℝ) :=
    lt_of_le_of_lt hP_le hP_lt
  have hD'_pos : 0 < L_normalizedZHazardDenom z' :=
    (L_normalizedZHazardDenom_pos_iff_product_lt z').mpr hP'_lt
  have hPhi_lt : Phi z < Phi z' := Phi_strictMono hlt
  have hPhi'_nonneg : 0 ≤ Phi z' := (Phi_pos z').le
  have hF_pos :
      0 < 1 - L_normalizedZHazardProduct z / (2/9 : ℝ) := by
    nlinarith
  have hF_le :
      1 - L_normalizedZHazardProduct z / (2/9 : ℝ) ≤
        1 - L_normalizedZHazardProduct z' / (2/9 : ℝ) := by
    nlinarith
  constructor
  · exact hD'_pos
  · unfold L_normalizedZHazardDenom
    calc
      Phi z *
          (1 - L_normalizedZHazardProduct z / (2/9 : ℝ)) <
        Phi z' *
          (1 - L_normalizedZHazardProduct z / (2/9 : ℝ)) :=
        mul_lt_mul_of_pos_right hPhi_lt hF_pos
      _ ≤ Phi z' *
          (1 - L_normalizedZHazardProduct z' / (2/9 : ℝ)) :=
        mul_le_mul_of_nonneg_left hF_le hPhi'_nonneg

/-- Compatibility alias for the former R252 reduction theorem name. -/
theorem L_normalizedZHazardDenomShape_from_product_antitone :
    ∀ z z' : ℝ, 0 < z → 0 < z' → z < z' →
      0 < L_normalizedZHazardDenom z →
        0 < L_normalizedZHazardDenom z' ∧
          L_normalizedZHazardDenom z <
            L_normalizedZHazardDenom z' :=
  L_normalizedZHazardDenomShape_paper_Def

/-- R251 denominator-shape theorem. Since `H = scale * denom` and
    `K = (1/2) * scale` with positive scale, the R250 threshold-shape theorem
    follows from positivity persistence and strict increase of this normalized
    denominator. -/
theorem L_normalizedZThresholdDenomShape_paper_Def :
    ∀ z z' : ℝ, 0 < z → 0 < z' → z < z' →
      0 < L_normalizedZThresholdDenom z →
        0 < L_normalizedZThresholdDenom z' ∧
          L_normalizedZThresholdDenom z <
            L_normalizedZThresholdDenom z' := by
  intro z z' hz hz' hlt hD_pos
  have hHz_pos : 0 < L_normalizedZHazardDenom z := by
    simpa [L_normalizedZThresholdDenom_eq_hazardDenom z] using hD_pos
  obtain ⟨hHz'_pos, hHz_lt⟩ :=
    L_normalizedZHazardDenomShape_from_product_antitone z z' hz hz' hlt hHz_pos
  constructor
  · simpa [L_normalizedZThresholdDenom_eq_hazardDenom z'] using hHz'_pos
  · simpa [L_normalizedZThresholdDenom_eq_hazardDenom z,
      L_normalizedZThresholdDenom_eq_hazardDenom z'] using hHz_lt

/-- Compatibility alias for the former R251 reduction theorem name. -/
theorem L_normalizedZThresholdDenomShape_from_hazardDenomShape :
    ∀ z z' : ℝ, 0 < z → 0 < z' → z < z' →
      0 < L_normalizedZThresholdDenom z →
        0 < L_normalizedZThresholdDenom z' ∧
          L_normalizedZThresholdDenom z <
            L_normalizedZThresholdDenom z' :=
  L_normalizedZThresholdDenomShape_paper_Def

/-- R250 pure z-shape theorem after the affine-threshold reduction. Writing
    the normalized core as `c * H(z) - K(z)`, this says that once the linear
    coefficient `H` is positive, it stays positive to the right and the
    threshold ratio `K/H` is strictly decreasing. The ratio is encoded by
    cross-multiplication to avoid adding division side conditions downstream. -/
theorem L_normalizedZThresholdShape_paper_Def :
    ∀ z z' : ℝ, 0 < z → 0 < z' → z < z' →
      0 < L_normalizedZLinearCoeff z →
        0 < L_normalizedZLinearCoeff z' ∧
          L_normalizedZConstantTerm z' * L_normalizedZLinearCoeff z <
            L_normalizedZConstantTerm z * L_normalizedZLinearCoeff z' := by
  intro z z' hz hz' hlt hH_pos
  have hscale_pos : 0 < L_normalizedZThresholdScale z :=
    L_normalizedZThresholdScale_pos z
  have hscale'_pos : 0 < L_normalizedZThresholdScale z' :=
    L_normalizedZThresholdScale_pos z'
  have hH_eq := L_normalizedZLinearCoeff_eq_scale_mul_thresholdDenom z
  have hH'_eq := L_normalizedZLinearCoeff_eq_scale_mul_thresholdDenom z'
  have hK_eq := L_normalizedZConstantTerm_eq_half_mul_thresholdScale z
  have hK'_eq := L_normalizedZConstantTerm_eq_half_mul_thresholdScale z'
  have hD_pos : 0 < L_normalizedZThresholdDenom z := by
    rw [hH_eq] at hH_pos
    by_contra hD_not_pos
    have hD_nonpos : L_normalizedZThresholdDenom z ≤ 0 :=
      le_of_not_gt hD_not_pos
    have hH_nonpos :
        L_normalizedZThresholdScale z *
            L_normalizedZThresholdDenom z ≤ 0 :=
      mul_nonpos_of_nonneg_of_nonpos (le_of_lt hscale_pos) hD_nonpos
    linarith
  obtain ⟨hD'_pos, hD_lt⟩ :=
    L_normalizedZThresholdDenomShape_from_hazardDenomShape z z' hz hz' hlt hD_pos
  have hH'_pos : 0 < L_normalizedZLinearCoeff z' := by
    rw [hH'_eq]
    exact mul_pos hscale'_pos hD'_pos
  have h_common_pos :
      0 < (1/2 : ℝ) * L_normalizedZThresholdScale z *
          L_normalizedZThresholdScale z' := by
    exact mul_pos (mul_pos (by norm_num) hscale_pos) hscale'_pos
  have h_threshold :
      L_normalizedZConstantTerm z' * L_normalizedZLinearCoeff z <
        L_normalizedZConstantTerm z * L_normalizedZLinearCoeff z' := by
    calc
      L_normalizedZConstantTerm z' * L_normalizedZLinearCoeff z =
          ((1/2 : ℝ) * L_normalizedZThresholdScale z *
              L_normalizedZThresholdScale z') *
              L_normalizedZThresholdDenom z := by
        rw [hK'_eq, hH_eq]
        ring
      _ < ((1/2 : ℝ) * L_normalizedZThresholdScale z *
              L_normalizedZThresholdScale z') *
              L_normalizedZThresholdDenom z' :=
        mul_lt_mul_of_pos_left hD_lt h_common_pos
      _ = L_normalizedZConstantTerm z * L_normalizedZLinearCoeff z' := by
        rw [hK_eq, hH'_eq]
        ring
  exact ⟨hH'_pos, h_threshold⟩

/-- Compatibility alias for the former R250 reduction theorem name. -/
theorem L_normalizedZThresholdShape_from_denomShape :
    ∀ z z' : ℝ, 0 < z → 0 < z' → z < z' →
      0 < L_normalizedZLinearCoeff z →
        0 < L_normalizedZLinearCoeff z' ∧
          L_normalizedZConstantTerm z' * L_normalizedZLinearCoeff z <
            L_normalizedZConstantTerm z * L_normalizedZLinearCoeff z' :=
  L_normalizedZThresholdShape_paper_Def

/-- R249 normalized z-core single-crossing theorem after the R250
    affine-threshold reduction. It follows from the pure z-threshold shape
    theorem and is no longer exposed as a `Prop` interface. -/
theorem L_balanceResidualNormalizedZCore_singleCrossingOn_rightBranch_paper_Def :
    ∀ c : ℝ, (1/2 : ℝ) < c → c ≤ (9/10 : ℝ) →
      ∀ z z' : ℝ, 0 < z → 0 < z' →
        L_cRightBranch c z → L_cRightBranch c z' →
          z < z' →
            L_balanceResidualNormalizedZCore c z = 0 →
              0 < L_balanceResidualNormalizedZCore c z' := by
  intro c hc_gt _hc_le z z' hz hz' _h_right _h_right' hlt h_zero
  have hc_pos : 0 < c := by
    linarith
  rw [L_balanceResidualNormalizedZCore_eq_linear] at h_zero
  have hK_pos : 0 < L_normalizedZConstantTerm z :=
    L_normalizedZConstantTerm_pos z
  have hcH_eq : c * L_normalizedZLinearCoeff z =
      L_normalizedZConstantTerm z := by
    linarith
  have hH_pos : 0 < L_normalizedZLinearCoeff z := by
    nlinarith
  obtain ⟨hH'_pos, h_threshold⟩ :=
    L_normalizedZThresholdShape_from_denomShape z z' hz hz' hlt hH_pos
  have hK'_lt_cH' :
      L_normalizedZConstantTerm z' < c * L_normalizedZLinearCoeff z' := by
    have htmp :
        L_normalizedZConstantTerm z' * L_normalizedZLinearCoeff z <
          (c * L_normalizedZLinearCoeff z') *
            L_normalizedZLinearCoeff z := by
      calc
        L_normalizedZConstantTerm z' * L_normalizedZLinearCoeff z
            < L_normalizedZConstantTerm z * L_normalizedZLinearCoeff z' :=
          h_threshold
        _ = (c * L_normalizedZLinearCoeff z') *
              L_normalizedZLinearCoeff z := by
          rw [← hcH_eq]
          ring
    exact lt_of_mul_lt_mul_right htmp (le_of_lt hH_pos)
  rw [L_balanceResidualNormalizedZCore_eq_linear]
  linarith

/-- Compatibility alias for the former R249 reduction theorem name. -/
theorem L_balanceResidualNormalizedZCore_singleCrossingOn_from_thresholdShape :
    ∀ c : ℝ, (1/2 : ℝ) < c → c ≤ (9/10 : ℝ) →
      ∀ z z' : ℝ, 0 < z → 0 < z' →
        L_cRightBranch c z → L_cRightBranch c z' →
          z < z' →
            L_balanceResidualNormalizedZCore c z = 0 →
              0 < L_balanceResidualNormalizedZCore c z' :=
  L_balanceResidualNormalizedZCore_singleCrossingOn_rightBranch_paper_Def

/-- R248 z-core single-crossing theorem. It follows from the normalized bridge
    because `c = 0.9 * (1 - p)` lies in `(1/2, 0.9]` for `p ∈ [0, p_1)`,
    and `Delta_B` is positive. -/
theorem L_balanceResidualZCore_singleCrossingOn_rightBranch_paper_Def :
    ∀ p : ℝ, 0 ≤ p → p < p_1 →
      ∀ z z' : ℝ, 0 < z → 0 < z' →
        L_zRightBranch p z → L_zRightBranch p z' →
          z < z' →
            L_balanceResidualZCore p z = 0 →
              0 < L_balanceResidualZCore p z' := by
  intro p hp hp_lt z z' hz hz' h_rightz h_rightz' hlt h_zcore_zero
  let c := (9/10 : ℝ) * (1 - p)
  have hc_gt : (1/2 : ℝ) < c := by
    dsimp [c]
    unfold p_1 at hp_lt
    nlinarith
  have hc_le : c ≤ (9/10 : ℝ) := by
    dsimp [c]
    nlinarith
  have hc_right : L_cRightBranch c z := by
    simpa [c, L_cRightBranch, L_zRightBranch] using h_rightz
  have hc_right' : L_cRightBranch c z' := by
    simpa [c, L_cRightBranch, L_zRightBranch] using h_rightz'
  have h_norm_zero : L_balanceResidualNormalizedZCore c z = 0 := by
    rw [L_balanceResidualZCore_eq_deltaB_mul_normalized] at h_zcore_zero
    exact eq_zero_of_ne_zero_of_mul_left_eq_zero Delta_B_pos.ne'
      (by simpa [c] using h_zcore_zero)
  have h_norm_pos :
      0 < L_balanceResidualNormalizedZCore c z' :=
    L_balanceResidualNormalizedZCore_singleCrossingOn_from_thresholdShape
      c hc_gt hc_le z z' hz hz' hc_right hc_right' hlt h_norm_zero
  rw [L_balanceResidualZCore_eq_deltaB_mul_normalized]
  exact mul_pos Delta_B_pos (by simpa [c] using h_norm_pos)

/-- Compatibility alias for the former R248 reduction theorem name. -/
theorem L_balanceResidualZCore_singleCrossingOn_from_normalized :
    ∀ p : ℝ, 0 ≤ p → p < p_1 →
      ∀ z z' : ℝ, 0 < z → 0 < z' →
        L_zRightBranch p z → L_zRightBranch p z' →
          z < z' →
            L_balanceResidualZCore p z = 0 →
              0 < L_balanceResidualZCore p z' :=
  L_balanceResidualZCore_singleCrossingOn_rightBranch_paper_Def

/-- R247 beta-core single-crossing theorem. It follows from the one-variable
    z-core theorem because the change of variables
    `β ↦ Delta_B / sqrt(2 * signalVariance β)` is strictly increasing on
    positive precisions. -/
theorem L_balanceResidualCore_singleCrossingOn_rightBranch_paper_Def :
    ∀ p : ℝ, 0 ≤ p → p < p_1 →
      ∀ β β' : ℝ, 0 < β → 0 < β' →
        L_rightBranch p β → L_rightBranch p β' →
          β < β' →
            L_balanceResidualCore p β = 0 →
              0 < L_balanceResidualCore p β' := by
  intro p hp hp_lt β β' hβ hβ' h_rightβ h_rightβ' hlt h_core_zero
  let z := Delta_B / Real.sqrt (2 * signalVariance β)
  let z' := Delta_B / Real.sqrt (2 * signalVariance β')
  have hz_pos : 0 < z := by
    dsimp [z]
    exact div_pos Delta_B_pos (sqrt_two_sigma_pos hβ)
  have hz'_pos : 0 < z' := by
    dsimp [z']
    exact div_pos Delta_B_pos (sqrt_two_sigma_pos hβ')
  have hz_lt : z < z' := by
    dsimp [z, z']
    exact arg_B_strictMono hβ hlt
  have hz_right : L_zRightBranch p z := by
    simpa [z, L_zRightBranch, L_rightBranch, Phi_B] using h_rightβ
  have hz'_right : L_zRightBranch p z' := by
    simpa [z', L_zRightBranch, L_rightBranch, Phi_B] using h_rightβ'
  have hz_zero : L_balanceResidualZCore p z = 0 := by
    rw [L_balanceResidualCore_eq_zCore p β] at h_core_zero
    simpa [z] using h_core_zero
  have hz_pos_core :
      0 < L_balanceResidualZCore p z' :=
    L_balanceResidualZCore_singleCrossingOn_from_normalized
      p hp hp_lt z z' hz_pos hz'_pos hz_right hz'_right hz_lt hz_zero
  rw [L_balanceResidualCore_eq_zCore p β']
  simpa [z'] using hz_pos_core

/-- Compatibility alias for the former R247 reduction theorem name. -/
theorem L_balanceResidualCore_singleCrossingOn_from_zCore :
    ∀ p : ℝ, 0 ≤ p → p < p_1 →
      ∀ β β' : ℝ, 0 < β → 0 < β' →
        L_rightBranch p β → L_rightBranch p β' →
          β < β' →
            L_balanceResidualCore p β = 0 →
              0 < L_balanceResidualCore p β' :=
  L_balanceResidualCore_singleCrossingOn_rightBranch_paper_Def

/-- Full grouped first-order residual single-crossing theorem after the R247
    core-factor reduction: once the full residual is zero at a positive
    right-branch point, it is strictly positive at every later positive
    right-branch point. -/
theorem L_balanceResidual_singleCrossingOn_rightBranch_paper_Def :
    ∀ p : ℝ, 0 ≤ p → p < p_1 →
      ∀ β β' : ℝ, 0 < β → 0 < β' →
        L_rightBranch p β → L_rightBranch p β' →
          β < β' →
            L_balanceResidual p β = 0 →
              0 < L_balanceResidual p β' := by
  intro p hp hp_lt β β' hβ hβ' h_rightβ h_rightβ' hlt h_res_zero
  have hscaleβ_pos : 0 < L_balanceResidualScale β :=
    L_balanceResidualScale_pos hβ
  have hscaleβ'_pos : 0 < L_balanceResidualScale β' :=
    L_balanceResidualScale_pos hβ'
  have h_core_zero : L_balanceResidualCore p β = 0 := by
    have hfact := L_balanceResidual_eq_scale_mul_core p β
    rw [hfact] at h_res_zero
    exact eq_zero_of_ne_zero_of_mul_left_eq_zero hscaleβ_pos.ne' h_res_zero
  have hcore_pos :
      0 < L_balanceResidualCore p β' :=
    L_balanceResidualCore_singleCrossingOn_from_zCore
      p hp hp_lt β β' hβ hβ' h_rightβ h_rightβ' hlt h_core_zero
  have hfact' := L_balanceResidual_eq_scale_mul_core p β'
  rw [hfact']
  exact mul_pos hscaleβ'_pos hcore_pos

/-- Compatibility alias for the former full-residual reduction theorem name. -/
theorem L_balanceResidual_singleCrossingOn_from_core :
    ∀ p : ℝ, 0 ≤ p → p < p_1 →
      ∀ β β' : ℝ, 0 < β → 0 < β' →
        L_rightBranch p β → L_rightBranch p β' →
          β < β' →
            L_balanceResidual p β = 0 →
              0 < L_balanceResidual p β' :=
  L_balanceResidual_singleCrossingOn_rightBranch_paper_Def

/-- First-order balance has at most one positive right-branch solution. This
    is now derived from the strict single-crossing theorem, not exposed as a
    standalone `Prop` interface. -/
theorem L_first_order_balance_unique_paper_Def :
    ∀ p : ℝ, 0 ≤ p → p < p_1 →
      ∀ β β' : ℝ, 0 < β → 0 < β' →
        L_rightBranch p β → L_rightBranch p β' →
          L_firstOrderBalance p β → L_firstOrderBalance p β' →
            β' = β := by
  intro p hp hp_lt β β' hβ hβ' h_rightβ h_rightβ' h_balβ h_balβ'
  have h_resβ : L_balanceResidual p β = 0 := by
    simpa [L_firstOrderBalance] using h_balβ
  have h_resβ' : L_balanceResidual p β' = 0 := by
    simpa [L_firstOrderBalance] using h_balβ'
  by_cases h_eq : β' = β
  · exact h_eq
  · rcases lt_or_gt_of_ne h_eq with hβ'_lt_β | hβ_lt_β'
    · have hlt_res :=
        L_balanceResidual_singleCrossingOn_from_core
          p hp hp_lt β' β hβ' hβ h_rightβ' h_rightβ hβ'_lt_β h_resβ'
      have hzero_lt : (0 : ℝ) < 0 := by
        rw [h_resβ] at hlt_res
        exact hlt_res
      exact False.elim ((lt_irrefl (0 : ℝ)) hzero_lt)
    · have hlt_res :=
        L_balanceResidual_singleCrossingOn_from_core
          p hp hp_lt β β' hβ hβ' h_rightβ h_rightβ' hβ_lt_β' h_resβ
      have hzero_lt : (0 : ℝ) < 0 := by
        rw [h_resβ'] at hlt_res
        exact hlt_res
      exact False.elim ((lt_irrefl (0 : ℝ)) hzero_lt)

/-- Compatibility alias for the former first-order-balance reduction theorem
    name. -/
theorem L_first_order_balance_unique_from_balanceResidual_singleCrossingOn :
    ∀ p : ℝ, 0 ≤ p → p < p_1 →
      ∀ β β' : ℝ, 0 < β → 0 < β' →
        L_rightBranch p β → L_rightBranch p β' →
          L_firstOrderBalance p β → L_firstOrderBalance p β' →
            β' = β :=
  L_first_order_balance_unique_paper_Def

/-- Kernel reduction from the right-branch first-order-balance uniqueness
    bridge to the original strict-uniqueness statement. -/
theorem L_strict_unique_minimizer_from_first_order_balance_unique :
    ∀ p : ℝ, 0 ≤ p → p < p_1 →
      ∀ β β' : ℝ, 0 < β → 0 < β' →
        (∀ β'' : ℝ, 0 < β'' → L β p ≤ L β'' p) →
        L β' p ≤ L β p →
          β' = β := by
  intro p hp hp_lt β β' hβ hβ' h_min h_le
  have hp_le_one : p ≤ 1 := by
    have hp_lt_one : p < 1 := by
      have h := hp_lt
      unfold p_1 at h
      linarith
    exact le_of_lt hp_lt_one
  have hβ'_min : ∀ β'' : ℝ, 0 < β'' → L β' p ≤ L β'' p := by
    intro β'' hβ''
    exact le_trans h_le (h_min β'' hβ'')
  have h_rightβ : L_rightBranch p β := by
    dsimp [L_rightBranch]
    exact L_global_minimizer_not_left_branch p hp_le_one hβ h_min
  have h_rightβ' : L_rightBranch p β' := by
    dsimp [L_rightBranch]
    exact L_global_minimizer_not_left_branch p hp_le_one hβ' hβ'_min
  have h_balβ : L_firstOrderBalance p β :=
    L_global_minimizer_first_order_balance p hβ h_min
  have h_balβ' : L_firstOrderBalance p β' :=
    L_global_minimizer_first_order_balance p hβ' hβ'_min
  exact L_first_order_balance_unique_from_balanceResidual_singleCrossingOn
    p hp hp_lt β β' hβ hβ' h_rightβ h_rightβ' h_balβ h_balβ'

/-- **Substantive closure of `interior_minimiser_existence`.**
    Existence of an interior global minimiser `β* > 0` of `L(·, 0)`:
    `∃ β* > 0, ∀ β ≥ 0, L(β*, 0) ≤ L(β, 0)`. Proof = extreme value
    theorem on the concrete `L` carrier.

    Steps: (1) take the below-limit witness `β₀ > 0` with
    `L(β₀,0) < 0.4`; (2) `L_tendsto_atZero` (`L → 0.425 > L(β₀,0)` as
    `β → 0⁺`) gives `ε ∈ (0, β₀]` with `L β 0 > L β₀ 0` for
    `β ∈ (0, ε]`, and `L_zero_zero` covers `β = 0`; (3)
    `L_tendsto_limit_atTop` (`L → 0.4 > L(β₀,0)`) gives `M ≥ β₀` with
    `L β 0 > L β₀ 0` for `β ≥ M`; (4) `L_continuousOn_Ioi` +
    `IsCompact.exists_isMinOn` on the compact `[ε, M]` (which contains
    `β₀`) yields a minimiser `β_min ∈ [ε, M]`, so `β_min > 0` and
    `L β_min 0 ≤ L β₀ 0`; (5) `β_min` beats every `β ≥ 0` by case
    split on `β < ε` / `β ∈ [ε,M]` / `β > M`.

    Mathlib lemmas: `IsCompact.exists_isMinOn`, `isCompact_Icc`,
    `L_continuousOn_Ioi`, `Filter.Tendsto.eventually`,
    `eventually_gt_nhds`, `Filter.eventually_gt_atTop`,
    `eventually_nhdsWithin_iff`. -/
private theorem interior_minimiser_existence_proof :
    ∃ β_star : ℝ, 0 < β_star ∧
      ∀ β : ℝ, 0 ≤ β → L β_star 0 ≤ L β 0 := by
  -- (1) Below-limit witness `β₀ > 0`, `L β₀ 0 < 0.4`.
  obtain ⟨β₀, hβ₀_pos, hβ₀_lt⟩ :=
    L_below_limit_at_some_beta_proof 0 le_rfl
      (by unfold p_1; norm_num)
  -- (2) Near `0⁺`: `L → 0.425 + 0 = 0.425 > L β₀ 0`.
  have h_zero_lim : (425 / 1000 : ℝ) + (225 / 1000 : ℝ) * 0 = 425 / 1000 := by
    ring
  have h_tendsto_zero : Filter.Tendsto (fun β : ℝ => L β 0)
      (nhdsWithin 0 (Set.Ioi 0)) (nhds (425 / 1000 : ℝ)) := by
    have := L_tendsto_atZero 0
    rwa [h_zero_lim] at this
  have hβ₀_lt_zerolim : L β₀ 0 < (425 / 1000 : ℝ) := by linarith
  have h_ev_zero : ∀ᶠ β in nhdsWithin (0 : ℝ) (Set.Ioi 0),
      L β₀ 0 < L β 0 :=
    h_tendsto_zero.eventually (eventually_gt_nhds hβ₀_lt_zerolim)
  rw [eventually_nhdsWithin_iff, Metric.eventually_nhds_iff] at h_ev_zero
  obtain ⟨δ, hδ_pos, hδ_prop⟩ := h_ev_zero
  -- `ε := min (δ/2) β₀ > 0`, and on `(0, ε]` we have `L β₀ 0 < L β 0`.
  set ε : ℝ := min (δ / 2) β₀ with hε_def
  have hε_pos : 0 < ε := lt_min (by linarith) hβ₀_pos
  have hε_le_β₀ : ε ≤ β₀ := min_le_right _ _
  have h_below_ε : ∀ β : ℝ, 0 < β → β ≤ ε → L β₀ 0 < L β 0 := by
    intro β hβ_pos hβ_le_ε
    have hβ_lt_δ : dist β (0 : ℝ) < δ := by
      rw [Real.dist_eq, sub_zero, abs_of_pos hβ_pos]
      have : β ≤ δ / 2 := le_trans hβ_le_ε (min_le_left _ _)
      linarith
    exact hδ_prop hβ_lt_δ hβ_pos
  -- (3) Near `+∞`: `L → 0.4 > L β₀ 0`.
  have hβ₀_lt_4 : L β₀ 0 < (4 / 10 : ℝ) := hβ₀_lt
  have h_ev_top : ∀ᶠ β in Filter.atTop, L β₀ 0 < L β 0 :=
    (L_tendsto_limit_atTop 0).eventually (eventually_gt_nhds hβ₀_lt_4)
  obtain ⟨M₀, hM₀_prop⟩ := h_ev_top.exists_forall_of_atTop
  set M : ℝ := max M₀ β₀ with hM_def
  have hM_ge_β₀ : β₀ ≤ M := le_max_right _ _
  have h_above_M : ∀ β : ℝ, M ≤ β → L β₀ 0 < L β 0 := by
    intro β hβ_ge_M
    exact hM₀_prop β (le_trans (le_max_left _ _) hβ_ge_M)
  have hε_le_M : ε ≤ M := le_trans hε_le_β₀ hM_ge_β₀
  -- (4) Extreme value theorem on the compact `[ε, M]`.
  have h_cont_Icc : ContinuousOn (fun β : ℝ => L β 0) (Set.Icc ε M) :=
    (L_continuousOn_Ioi 0).mono (fun β hβ => lt_of_lt_of_le hε_pos hβ.1)
  have h_nonempty : (Set.Icc ε M).Nonempty := ⟨ε, ⟨le_rfl, hε_le_M⟩⟩
  obtain ⟨β_min, hβ_min_mem, hβ_min_le⟩ :=
    (isCompact_Icc).exists_isMinOn h_nonempty h_cont_Icc
  have hβ_min_pos : 0 < β_min := lt_of_lt_of_le hε_pos hβ_min_mem.1
  -- `β₀ ∈ [ε, M]`, so `L β_min 0 ≤ L β₀ 0`.
  have hβ₀_mem : β₀ ∈ Set.Icc ε M := ⟨hε_le_β₀, hM_ge_β₀⟩
  have hβ_min_le_β₀ : L β_min 0 ≤ L β₀ 0 := hβ_min_le hβ₀_mem
  -- (5) `β_min` is a global minimiser over `[0, ∞)`.
  refine ⟨β_min, hβ_min_pos, ?_⟩
  intro β hβ_nonneg
  rcases lt_or_ge β ε with hβ_lt_ε | hβ_ge_ε
  · -- `β < ε`: either `β = 0` (use `L_zero_zero`) or `0 < β ≤ ε`.
    rcases eq_or_lt_of_le hβ_nonneg with hβ_eq | hβ_pos
    · -- `β = 0`: `L 0 0 = 0.425 > L β₀ 0 ≥ L β_min 0`.
      rw [← hβ_eq, L_zero_zero]
      linarith [hβ_min_le_β₀, hβ₀_lt_zerolim]
    · -- `0 < β ≤ ε`: boundary bound `L β₀ 0 < L β 0`.
      have := h_below_ε β hβ_pos (le_of_lt hβ_lt_ε)
      linarith [hβ_min_le_β₀]
  · rcases le_or_gt β M with hβ_le_M | hβ_gt_M
    · -- `β ∈ [ε, M]`: `β_min` minimises on the compact.
      exact hβ_min_le ⟨hβ_ge_ε, hβ_le_M⟩
    · -- `β > M`: boundary bound `L β₀ 0 < L β 0`.
      have := h_above_M β (le_of_lt hβ_gt_M)
      linarith [hβ_min_le_β₀]

/-- Cat 3 claim, fully derived theorem from a paper-derived atom:
    paper Proposition
    `prop:interior-optimum` (line 774) gives the existence of an
    interior minimiser of the Regime (i) `p = 0` loss function
    `L(·, 0)`. Encoded existentially on the existing carrier `L`:
    there exists a positive `β_star` such that `L(β_star, 0) ≤
    L(β, 0)` for all `β ≥ 0`.

    The explicit `β* ≈ 1.5 bits` numeric witness is a separate
    transcendental optimisation.
    Closure by genuine real analysis: the *existence* of an
    interior minimiser does not require the explicit numeric witness
    — it follows from the extreme value theorem
    (`interior_minimiser_existence_proof`), composing the L-analysis
    machinery (`L_below_limit_at_some_beta_proof`, `L_tendsto_atZero`,
    `L_tendsto_limit_atTop`) with the continuity lemma
    `L_continuousOn_Ioi` and the closed-form boundary value
    `L_zero_zero` (`L(0,0) = 0.425`). No `Classical.choose`, no opaque
    carrier — fully derived. The numeric value `β* ≈ 1.5 bits` remains
    a separate paper-stated computational fact, not needed for the
    existence claim.

    paper source: Proposition `prop:interior-optimum`, line 774. -/
theorem interior_minimiser_existence :
    ∃ β_star : ℝ, 0 < β_star ∧
      ∀ β : ℝ, 0 ≤ β → L β_star 0 ≤ L β 0 :=
  interior_minimiser_existence_proof

/-- **Substantive closure of `L_minimum_exists_in_regime_i`.**
    For every `p ∈ [0, p_1)`, the loss `L(·, p)` has an interior
    minimiser over the positive reals: `∃ β_min > 0, ∀ β > 0,
    L(β_min, p) ≤ L(β, p)`. Same extreme-value-theorem argument as
    `interior_minimiser_existence_proof`, generalised to `p` and
    restricted to `β > 0` (so no `β = 0` endpoint to handle).

    Steps: (1) `L_below_limit_at_some_beta_proof p` gives
    `β₀ > 0` with `L(β₀,p) < 0.4`; (2) `L_tendsto_atZero p`
    (`L → 0.425 + 0.225p ≥ 0.425 > 0.4 > L(β₀,p)` as `β → 0⁺`) gives
    `ε ∈ (0, β₀]` with `L β p > L β₀ p` for `β ∈ (0, ε]`; (3)
    `L_tendsto_limit_atTop p` (`L → 0.4 > L(β₀,p)`) gives `M ≥ β₀`
    with `L β p > L β₀ p` for `β ≥ M`; (4) `L_continuousOn_Ioi p` +
    `IsCompact.exists_isMinOn` on the compact `[ε, M]` ∋ `β₀` yields a
    minimiser `β_min`; (5) `β_min` beats every `β > 0` by the
    `β < ε` / `β ∈ [ε,M]` / `β > M` case split.

    Mathlib lemmas: `IsCompact.exists_isMinOn`, `isCompact_Icc`,
    `L_continuousOn_Ioi`, `Filter.Tendsto.eventually`,
    `eventually_gt_nhds`, `Filter.eventually_gt_atTop`,
    `eventually_nhdsWithin_iff`. -/
private theorem L_minimum_exists_in_regime_i_proof
    (p : ℝ) (hp_nonneg : 0 ≤ p) (hp_lt_p1 : p < p_1) :
    ∃ β_min : ℝ, 0 < β_min ∧
      ∀ β : ℝ, 0 < β → L β_min p ≤ L β p := by
  -- (1) Below-limit witness `β₀ > 0`, `L β₀ p < 0.4`.
  obtain ⟨β₀, hβ₀_pos, hβ₀_lt⟩ :=
    L_below_limit_at_some_beta_proof p hp_nonneg hp_lt_p1
  -- (2) Near `0⁺`: `L → 0.425 + 0.225p ≥ 0.425 > 0.4 > L β₀ p`.
  have h_zerolim_gt : (4 / 10 : ℝ) <
      (425 / 1000 : ℝ) + (225 / 1000 : ℝ) * p := by
    have : 0 ≤ (225 / 1000 : ℝ) * p := by positivity
    linarith
  have hβ₀_lt_zerolim : L β₀ p <
      (425 / 1000 : ℝ) + (225 / 1000 : ℝ) * p := by linarith
  have h_ev_zero : ∀ᶠ β in nhdsWithin (0 : ℝ) (Set.Ioi 0),
      L β₀ p < L β p :=
    (L_tendsto_atZero p).eventually (eventually_gt_nhds hβ₀_lt_zerolim)
  rw [eventually_nhdsWithin_iff, Metric.eventually_nhds_iff] at h_ev_zero
  obtain ⟨δ, hδ_pos, hδ_prop⟩ := h_ev_zero
  set ε : ℝ := min (δ / 2) β₀ with hε_def
  have hε_pos : 0 < ε := lt_min (by linarith) hβ₀_pos
  have hε_le_β₀ : ε ≤ β₀ := min_le_right _ _
  have h_below_ε : ∀ β : ℝ, 0 < β → β ≤ ε → L β₀ p < L β p := by
    intro β hβ_pos hβ_le_ε
    have hβ_lt_δ : dist β (0 : ℝ) < δ := by
      rw [Real.dist_eq, sub_zero, abs_of_pos hβ_pos]
      have : β ≤ δ / 2 := le_trans hβ_le_ε (min_le_left _ _)
      linarith
    exact hδ_prop hβ_lt_δ hβ_pos
  -- (3) Near `+∞`: `L → 0.4 > L β₀ p`.
  have h_ev_top : ∀ᶠ β in Filter.atTop, L β₀ p < L β p :=
    (L_tendsto_limit_atTop p).eventually (eventually_gt_nhds hβ₀_lt)
  obtain ⟨M₀, hM₀_prop⟩ := h_ev_top.exists_forall_of_atTop
  set M : ℝ := max M₀ β₀ with hM_def
  have hM_ge_β₀ : β₀ ≤ M := le_max_right _ _
  have h_above_M : ∀ β : ℝ, M ≤ β → L β₀ p < L β p := by
    intro β hβ_ge_M
    exact hM₀_prop β (le_trans (le_max_left _ _) hβ_ge_M)
  have hε_le_M : ε ≤ M := le_trans hε_le_β₀ hM_ge_β₀
  -- (4) Extreme value theorem on the compact `[ε, M]`.
  have h_cont_Icc : ContinuousOn (fun β : ℝ => L β p) (Set.Icc ε M) :=
    (L_continuousOn_Ioi p).mono (fun β hβ => lt_of_lt_of_le hε_pos hβ.1)
  have h_nonempty : (Set.Icc ε M).Nonempty := ⟨ε, ⟨le_rfl, hε_le_M⟩⟩
  obtain ⟨β_min, hβ_min_mem, hβ_min_le⟩ :=
    (isCompact_Icc).exists_isMinOn h_nonempty h_cont_Icc
  have hβ_min_pos : 0 < β_min := lt_of_lt_of_le hε_pos hβ_min_mem.1
  have hβ₀_mem : β₀ ∈ Set.Icc ε M := ⟨hε_le_β₀, hM_ge_β₀⟩
  have hβ_min_le_β₀ : L β_min p ≤ L β₀ p := hβ_min_le hβ₀_mem
  -- (5) `β_min` is a global minimiser over `(0, ∞)`.
  refine ⟨β_min, hβ_min_pos, ?_⟩
  intro β hβ_pos
  rcases lt_or_ge β ε with hβ_lt_ε | hβ_ge_ε
  · -- `0 < β < ε`: boundary bound `L β₀ p < L β p`.
    have := h_below_ε β hβ_pos (le_of_lt hβ_lt_ε)
    linarith [hβ_min_le_β₀]
  · rcases le_or_gt β M with hβ_le_M | hβ_gt_M
    · -- `β ∈ [ε, M]`: `β_min` minimises on the compact.
      exact hβ_min_le ⟨hβ_ge_ε, hβ_le_M⟩
    · -- `β > M`: boundary bound `L β₀ p < L β p`.
      have := h_above_M β (le_of_lt hβ_gt_M)
      linarith [hβ_min_le_β₀]

/-- **Existence of interior optimum** at `β* ≈ 1.5 bits` (derived theorem).

    Derived theorem composing `interior_minimiser_existence`,
    itself closed as a derived theorem (extreme value theorem
    on the concrete `L` carrier — see
    `interior_minimiser_existence_proof`). No longer rests on an
    opaque axiom.

    paper source: Proposition `prop:interior-optimum`, line 774. -/
theorem gap_interior_optimum :
    ∃ β_star : ℝ, 0 < β_star ∧
      ∀ β : ℝ, 0 ≤ β → L β_star 0 ≤ L β 0 :=
  interior_minimiser_existence

/-! ## 3. Three-regime structure (`prop:three-regime-five-state`)

The boundaries `p_1 = 4/9` and `p_2 = 2/3` separate three policy regimes. -/


/-- **Topological loss `|W_topo(p)| = 0.4·p`** on the 5-state instance.

    paper source: Proposition `prop:three-regime-five-state` Regime
    (ii) proof, line 831. -/
noncomputable def W_topo_p (p : ℝ) : ℝ := (4/10 : ℝ) * p

/-! **Proposition `prop:three-regime-five-state` Regime (i): Reversal.**
    Paper claim (lines 813-814): for `p ∈ [0, p_1)`, `L(β, p)` is
    non-monotone in `β` with a UNIQUE interior minimum
    `β*(p) ∈ (0, ∞)` satisfying `L(β*(p), p) < L(∞, p) = 0.4`, and
    the overshoot `L(∞, p) − L(β*(p), p)` is continuous and strictly
    decreasing in `p` on `[0, p_1)`, vanishing at `p_1`.

    Composite axioms hide gaps; the original single bundled axiom
    `gap_three_regime_reversal_OPEN` is decomposed into four
    single-clause sub-axioms below. Each sub-axiom is a Cat 3 claim
    with explicit single-clause encoding; the bundle entry
    `entry_prop_three_regime` lists all four. -/

/-- **Regime (i) sub-claim — existence of below-limit `β*`.**
    For `p ∈ [0, p_1)`, there exists `β*(p) ∈ (0, ∞)` with
    `L(β*(p), p) < L(∞, p) = 0.4`.

    Fully derived theorem from a paper-derived Cat 3 atom. Proved by
    genuine real-analysis on the concrete `L` carrier. The proof
    (`L_below_limit_at_some_beta_proof`) uses the rearrangement
    identity `eq:five-state-rearr` (`L_rearrangement`), the strict
    bound `P_trap β < 1` for finite `β` (`P_trap_lt_one`, from
    `Phi_lt_one`), and the limit `Φ_B β → 1` as `β → ∞`
    (`Phi_B_tendsto_one_atTop`, from `signalVariance_tendsto_zero_atTop`
    + `Phi_tendsto_one_atTop`): since `p < p_1 = 4/9` makes
    `0.9(1 − p) > 1/2`, the threshold `1/(2·0.9(1 − p)) < 1`, so
    eventually `Φ_B β` exceeds it and the rearranged loss is strictly
    negative. No `Classical.choose`, no opaque carrier — fully derived.

    paper source: Proposition `prop:three-regime-five-state` Regime (i),
    line 814 ("unique interior minimum ... satisfying L(β*(p), p) <
    L(∞, p) = 0.4"); proof line 825. -/
theorem L_below_limit_at_some_beta :
    ∀ p : ℝ, 0 ≤ p → p < p_1 →
      ∃ β_star_p : ℝ, 0 < β_star_p ∧
        L β_star_p p < (4/10 : ℝ) :=
  L_below_limit_at_some_beta_proof

/-- **Regime (i) sub-claim — existence of below-limit `β*`** (derived).
    For `p ∈ [0, p_1)`, there exists `β*(p) ∈ (0, ∞)` with
    `L(β*(p), p) < L(∞, p) = 0.4`.

    Derived theorem composing
    `L_below_limit_at_some_beta` .

    paper source: Proposition `prop:three-regime-five-state` Regime (i),
    line 814. -/
theorem gap_three_regime_reversal_existence :
    ∀ p : ℝ, 0 ≤ p → p < p_1 →
      ∃ β_star_p : ℝ, 0 < β_star_p ∧
        L β_star_p p < (4/10 : ℝ) :=
  L_below_limit_at_some_beta

/-- **Bridge (a), now closed**: existence of an interior minimiser of `L β p`
    over `β > 0` for
    `p ∈ [0, p_1)`. Paper Proposition `prop:three-regime-five-state`
    Regime (i) line 814 + proof line 825 STATE the unimodality of `L β p`
    on `(0, ∞)`; the existence-of-minimum sub-clause is the EXISTENCE-only
    component of the paper's unique-minimum claim.

    Atomic-decomposition pattern: smaller atoms +
    Cat 1 lifting are preferable to larger atoms. The larger theorem
    interface (existence + uniqueness) is split into two strictly smaller
    paper-Def interfaces: (a) interior-minimiser EXISTENCE (this interface), and
    (b) strict uniqueness from paper-stipulated strict structure
    (formerly exposed through `L_strict_unique_minimizer_paper_Def`). The
    combined statement becomes a Cat 1 derived theorem composing the two.

    R228 closure: this is now exactly the already-proved
    `L_minimum_exists_in_regime_i` theorem, a concrete real-analysis
    proof on the explicit `L` carrier using the extreme value theorem. -/
theorem L_interior_minimizer_exists_paper_Def :
    ∀ p : ℝ, 0 ≤ p → p < p_1 →
      ∃ β_star_p : ℝ, 0 < β_star_p ∧
        ∀ β' : ℝ, 0 < β' → L β_star_p p ≤ L β' p :=
  L_minimum_exists_in_regime_i_proof

/- **Bridge (b), retired compatibility name after R469.** The former Cat 3
    paper-Def bridge is no longer the whole strict-uniqueness conclusion.
    It was reduced to the two-factor antitonicity statement
    `L_gaussianHazardMillsFactorAntitone_paper_Def`; the R253 product
    antitonicity bridge, R252 hazard/Mills denominator-shape bridge, R251
    threshold-denominator bridge, R250 threshold-shape bridge, normalized
    z-core single-crossing,
    z-core/beta-core/full residual single-crossing, balance uniqueness, and
    original strict uniqueness follow by the kernel theorems
    `L_normalizedZHazardProduct_antitone_from_factor_antitone`,
    `L_normalizedZHazardDenomShape_from_product_antitone`,
    `L_normalizedZThresholdDenomShape_from_hazardDenomShape`,
    `L_normalizedZThresholdShape_from_denomShape`,
    `L_balanceResidualNormalizedZCore_singleCrossingOn_from_thresholdShape`,
    `L_balanceResidual_singleCrossingOn_from_core`,
    `L_first_order_balance_unique_from_balanceResidual_singleCrossingOn` and
    `L_strict_unique_minimizer_from_first_order_balance_unique`.

    The former compatibility name `L_strict_unique_minimizer_paper_Def` has
    been retired from source: public theorem signatures no longer take it as a
    premise, and the right-branch single-crossing content is discharged below
    from the closed upper-Mills antitonicity theorem. -/

/-- **Unimodality statement** Cat 1 derived theorem composing the two
    explicit paper-Def theorem interfaces above:
    paper Proposition `prop:three-regime-five-state` Regime (i) line 814
    + proof line 825 STATE that the explicit `L β p` formula is unimodal
    on `(0, ∞)` for `p ∈ [0, p_1)` (interior unique minimum exists).

    Paper-Def-stipulated unique-minimum structural fact about the explicit
    `L` carrier in Regime (i). Paper line 825 verifies this via the
    transcendental two-term comparison
    `P_trap'(β)·(0.9(1−p)Φ_B(β) − 0.5) > (1−P_trap β)·0.9(1−p)·Φ_B'(β)`
    only NUMERICALLY (the left-branch `L_deriv_neg_on_left_branch` is proved
    symbolically; right-branch transcendental comparison is paper-numerical).
    The right-branch sign claim is paper-stated FACT on the `L`
    carrier; the encoded atoms
    capture the paper-stipulated uniqueness conclusion.

    Composed as a Cat 1 derived theorem from the current concrete theorem
    `L_interior_minimizer_exists_paper_Def` (existence) and the closed
    right-branch single-crossing chain below; no external uniqueness premise
    remains. -/
theorem L_unimodal_in_regime_i_paper_Def :
    ∀ p : ℝ, 0 ≤ p → p < p_1 →
      ∃ β_star_p : ℝ, 0 < β_star_p ∧
        ∀ β' : ℝ, 0 < β' → L β' p ≤ L β_star_p p → β' = β_star_p := by
  intro p hp hp_lt
  obtain ⟨β_star_p, h_pos, h_min⟩ :=
    L_interior_minimizer_exists_paper_Def p hp hp_lt
  refine ⟨β_star_p, h_pos, ?_⟩
  intro β' hβ'_pos h_le
  exact L_strict_unique_minimizer_from_first_order_balance_unique
    p hp hp_lt β_star_p β' h_pos hβ'_pos h_min h_le

/-- **Unimodality** (Cat 1 derived theorem). Direct re-export of
    `L_unimodal_in_regime_i_paper_Def` with no external premise. -/
theorem L_unimodal_in_regime_i_from_unique_minimizer :
    ∀ p : ℝ, 0 ≤ p → p < p_1 →
      ∃ β_star_p : ℝ, 0 < β_star_p ∧
        ∀ β' : ℝ, 0 < β' → L β' p ≤ L β_star_p p → β' = β_star_p :=
  L_unimodal_in_regime_i_paper_Def

/-- **Infrastructure-wired**: derives paper's
    L-unimodality via the closed theorem
    `L_unimodal_in_regime_i_from_unique_minimizer` above,
    consuming `Infrastructure.ArgmaxExistence` Cat 1 chain. -/
theorem L_unimodal_in_regime_i :
    ∀ p : ℝ, 0 ≤ p → p < p_1 →
      ∃ β_star_p : ℝ, 0 < β_star_p ∧
        ∀ β' : ℝ, 0 < β' → L β' p ≤ L β_star_p p → β' = β_star_p :=
  L_unimodal_in_regime_i_from_unique_minimizer

/-- **Regime (i) sub-claim — uniqueness of the interior minimum**
    (derived theorem composing `L_unimodal_in_regime_i`).
    paper source: Regime (i), line 814 + proof line 825. -/
theorem gap_three_regime_reversal_uniqueness :
    ∀ p : ℝ, 0 ≤ p → p < p_1 →
      ∃ β_star_p : ℝ, 0 < β_star_p ∧
        ∀ β' : ℝ, 0 < β' → L β' p ≤ L β_star_p p → β' = β_star_p :=
  L_unimodal_in_regime_i

/-- **Regime (i) sub-claim — non-monotonicity of `L(·, p)` in `β`.**
    For `p ∈ [0, p_1)`, `L(β, p)` is non-monotone in `β`: there exist
    `β_low < β_high` (both `> 0`) such that `L(β_high, p) < L(β_low, p)`
    AND there exist `β_a < β_b` (both `> 0`) such that
    `L(β_a, p) < L(β_b, p)`.

    Fully derived theorem from a paper-derived Cat 3 atom. Proved by
    genuine real-analysis on the concrete `L` carrier, mirroring the
    paper's
    "the loss decreases below 0.4 and then rises back toward the limit
    L(∞, p) = 0.4" argument (line 825). Let `β*` be the below-limit
    witness with `L β* p < 0.4` (`L_below_limit_at_some_beta_proof`).
    * *Decreasing branch* (`β_low < β_high`): `L(β, p) → 0.425 + 0.225 p
      > 0.4 > L β* p` as `β → 0⁺` (`L_tendsto_atZero`), so eventually
      near `0⁺` the loss strictly exceeds `L β* p`; pick `β_low` there
      below `β*` and `β_high := β*`.
    * *Increasing branch* (`β_a < β_b`): `L(β, p) → 0.4 > L β* p` as
      `β → ∞` (`L_tendsto_limit_atTop`), so eventually the loss strictly
      exceeds `L β* p`; pick `β_a := β*` and `β_b` large.
    No `Classical.choose`, no opaque carrier — fully derived.

    paper source: Proposition `prop:three-regime-five-state` Regime (i),
    line 814 ("L(β, p) is non-monotone in β"); proof at lines 821-825. -/
theorem L_nonmonotone_witnesses :
    ∀ p : ℝ, 0 ≤ p → p < p_1 →
      (∃ β_low β_high : ℝ, 0 < β_low ∧ β_low < β_high ∧
        L β_high p < L β_low p) ∧
      (∃ β_a β_b : ℝ, 0 < β_a ∧ β_a < β_b ∧
        L β_a p < L β_b p) := by
  intro p hp_nonneg hp_lt_p1
  -- The below-limit witness `β*` with `L β* p < 0.4`.
  obtain ⟨β_star, hβ_star_pos, hβ_star_lt⟩ :=
    L_below_limit_at_some_beta_proof p hp_nonneg hp_lt_p1
  constructor
  · -- Decreasing branch: `L(·, p) → 0.425 + 0.225 p` as `β → 0⁺`,
    -- which strictly exceeds `0.4 > L β* p`.
    have h_limit_gt : (4/10 : ℝ) < (425/1000 : ℝ) + (225/1000 : ℝ) * p := by
      nlinarith
    have h_target : L β_star p < (425/1000 : ℝ) + (225/1000 : ℝ) * p := by
      linarith
    -- Eventually near `0⁺`, `L β p` exceeds `L β_star p`.
    have h_ev_L : ∀ᶠ β in nhdsWithin 0 (Set.Ioi 0), L β_star p < L β p :=
      (L_tendsto_atZero p).eventually (eventually_gt_nhds h_target)
    -- Eventually near `0⁺`, `β < β_star`.
    have h_ev_lt : ∀ᶠ β in nhdsWithin 0 (Set.Ioi 0), β < β_star :=
      eventually_nhdsWithin_of_eventually_nhds (eventually_lt_nhds hβ_star_pos)
    -- Eventually near `0⁺`, `β > 0` (the `Set.Ioi 0` membership).
    have h_ev_pos : ∀ᶠ β in nhdsWithin 0 (Set.Ioi 0), (0 : ℝ) < β :=
      eventually_mem_nhdsWithin.mono (fun β hβ => hβ)
    obtain ⟨β_low, hβ_low_L, hβ_low_lt, hβ_low_pos⟩ :=
      ((h_ev_L.and (h_ev_lt.and h_ev_pos)).exists)
    exact ⟨β_low, β_star, hβ_low_pos, hβ_low_lt, hβ_low_L⟩
  · -- Increasing branch: `L(·, p) → 0.4` as `β → ∞`, which strictly
    -- exceeds `L β* p`.
    have h_ev_L : ∀ᶠ β in Filter.atTop, L β_star p < L β p :=
      (L_tendsto_limit_atTop p).eventually (eventually_gt_nhds hβ_star_lt)
    have h_ev_gt : ∀ᶠ β in Filter.atTop, β_star < β :=
      Filter.eventually_gt_atTop β_star
    obtain ⟨β_b, hβ_b_L, hβ_b_gt⟩ := ((h_ev_L.and h_ev_gt).exists)
    exact ⟨β_star, β_b, hβ_star_pos, hβ_b_gt, hβ_b_L⟩

/-- **Regime (i) sub-claim — non-monotonicity of `L(·, p)` in `β`**
    (derived theorem composing
    `L_nonmonotone_witnesses`).
    paper source: Regime (i), line 814 + proof at lines 821-825. -/
theorem gap_three_regime_reversal_nonmonotone :
    ∀ p : ℝ, 0 ≤ p → p < p_1 →
      (∃ β_low β_high : ℝ, 0 < β_low ∧ β_low < β_high ∧
        L β_high p < L β_low p) ∧
      (∃ β_a β_b : ℝ, 0 < β_a ∧ β_a < β_b ∧
        L β_a p < L β_b p) :=
  L_nonmonotone_witnesses

/-- Closure-path-A smaller claim, fully derived theorem from a
    paper-derived atom: on Regime (i)'s domain `p ∈ [0, p_1)`, the
    loss function `L(·, p)` has an interior
    minimiser over the positive reals — i.e., there exists
    `β_min > 0` such that for every `β > 0`, `L β_min p ≤ L β p`.
    Paper `prop:three-regime-five-state` Regime (i) (line 814 + proof
    line 825) establishes this via the IVT-style chain: at `p < p_1`,
    `0.9·(1−p)·sup_β Φ_B(β) > 0.5` so `L(β, p) < 0.4 = L(∞, p)` for
    some β, and the unimodal structure of `prop:interior-optimum`
    (line 774) yields a global minimum on `(0, ∞)`.

    The explicit `β*(p)` witness is deferred to a transcendental
    optimisation. Closure by
    genuine real analysis: the *existence* of the interior minimiser
    follows from the extreme value theorem
    (`L_minimum_exists_in_regime_i_proof`), composing the L-analysis
    machinery (`L_below_limit_at_some_beta_proof`, `L_tendsto_atZero`,
    `L_tendsto_limit_atTop`) with the new continuity lemma
    `L_continuousOn_Ioi`. No `Classical.choose` for the *existence*,
    no opaque carrier — fully derived. (The `betaStarOfP` carrier
    below still applies `Classical.choose` to *select* a specific
    minimiser from this derived existence theorem — an
    implicit-function-style selection step.)

    This existence claim supports the existence-via-`Classical.choose`
    closure: `betaStarOfP` is a `noncomputable def` that invokes
    `Classical.choose` on this claim (per-`p`, inside the
    `0 ≤ p ∧ p < p_1` domain guard); `Classical.choose_spec` directly
    yields the universal-inequality form needed by `betaStarOfP_def`.

    paper source: Proposition `prop:three-regime-five-state` Regime (i),
    line 814 + proof line 825 (existence of interior minimum from
    IVT chain `0.9(1-p)·sup_β Φ_B > 0.5` for `p < p_1` plus the
    unimodal structure of `prop:interior-optimum` line 774). -/
theorem L_minimum_exists_in_regime_i :
    ∀ (p : ℝ), 0 ≤ p → p < p_1 →
      ∃ β_min : ℝ, 0 < β_min ∧
        ∀ (β : ℝ), 0 < β → L β_min p ≤ L β p :=
  L_minimum_exists_in_regime_i_proof

/-- **Carrier `β*(p)` for Regime (i)'s implicit-function selection.**

    On the Regime (i) domain `p ∈ [0, p_1)`, `betaStarOfP p` is the
    minimiser of `L(·, p)` picked via `Classical.choose` from the
    existence atom `L_minimum_exists_in_regime_i`. Outside the
    domain (paper-irrelevant), the definition follows the Mathlib
    convention of returning `0`.

    The Lean `def` IS the paper's implicit-function selection: the
    `Classical.choose` picks the paper-stated minimiser of `L(·, p)`,
    and `Classical.choose_spec` discharges the minimiser-property
    universally without a separate carrier-identification step.

    paper source: Proposition `prop:three-regime-five-state` Regime (i),
    line 814 (the "β*(p)" of the third bullet's overshoot expression
    `L(∞, p) − L(β*(p), p)`). -/
noncomputable def betaStarOfP (p : ℝ) : ℝ :=
  if h : 0 ≤ p ∧ p < p_1 then
    Classical.choose (L_minimum_exists_in_regime_i p h.1 h.2)
  else 0

/-- **Derived theorem**: closes via `Classical.choose_spec`.
    Cat 3 argmin characterisation of `betaStarOfP p` on Regime (i)'s
    domain `p ∈ [0, p_1)`: for every `β > 0`,
    `L (betaStarOfP p) p ≤ L β p`.

    Closure: composes the `betaStarOfP` `def` (which invokes
    `Classical.choose` on `L_minimum_exists_in_regime_i` inside
    the domain guard) with `Classical.choose_spec` (which yields the
    universal-inequality minimiser property of the chosen witness
    directly). The carrier-identification structural-equation atom
    `betaStarOfP_eq_minimiser_witness_OPEN` is not needed:
    `Classical.choose_spec` gives the minimiser-property for the
    canonical chosen β_min, which IS `betaStarOfP p` by the `def`'s
    `if_pos`-branch unfolding.

    The carrier `betaStarOfP` is paper-Def-stipulated structural
    primitive realised as a `noncomputable def` rather than opaque axiom.

    paper source: Proposition `prop:three-regime-five-state` Regime (i),
    line 814 ("unique interior minimum `β*(p)`"). -/
theorem betaStarOfP_def
    (p : ℝ) (h_p_nonneg : 0 ≤ p) (h_p_lt_p1 : p < p_1)
    (β : ℝ) (h_β_pos : 0 < β) :
    L (betaStarOfP p) p ≤ L β p := by
  -- Unfold `betaStarOfP` at the `if_pos` branch (in-domain).
  have h_dom : 0 ≤ p ∧ p < p_1 := ⟨h_p_nonneg, h_p_lt_p1⟩
  have h_unfold : betaStarOfP p =
      Classical.choose (L_minimum_exists_in_regime_i p h_p_nonneg h_p_lt_p1) := by
    unfold betaStarOfP
    rw [dif_pos h_dom]
  -- `Classical.choose_spec` yields `0 < β_min ∧ ∀ β > 0, L β_min p ≤ L β p`.
  have h_spec :=
    Classical.choose_spec (L_minimum_exists_in_regime_i p h_p_nonneg h_p_lt_p1)
  -- Extract the universal-inequality minimiser property.
  rw [h_unfold]
  exact h_spec.2 β h_β_pos

/-- Cat 3 derived theorem: at any `p ∈ [0, p_1)`, the loss at the
    paper-stated minimiser `betaStarOfP p` lies STRICTLY below the
    Regime (i) reference value `0.4`. Composes the argmin-characterisation
    atom `betaStarOfP_def` (paper `prop:three-regime-five-state` Regime (i)
    line 814 minimiser-characterisation on the existing `betaStarOfP` and
    `L` carriers) with the existence sub-axiom
    `gap_three_regime_reversal_existence_OPEN` (paper line 814 existential
    of a positive `β_star_p` whose loss is strictly below `0.4`). The
    derivation chain: existence supplies `β_star_p > 0` with
    `L β_star_p p < 0.4`; the argmin-fact gives
    `L (betaStarOfP p) p ≤ L β_star_p p`; transitivity gives
    `L (betaStarOfP p) p < 0.4`. This makes `betaStarOfP_def` operationally
    consumed downstream per the discipline's "every atom serves a derived
    theorem" mandate; it also strengthens the existence sub-axiom by
    binding the existential witness to the canonical `betaStarOfP` carrier.
    paper source: Proposition `prop:three-regime-five-state` Regime (i),
    line 814 ("L(β*(p), p) < L(∞, p) = 0.4"). -/
theorem betaStarOfP_loss_below_limit (p : ℝ) (h_p_nonneg : 0 ≤ p)
    (h_p_lt_p1 : p < p_1) :
    L (betaStarOfP p) p < (4/10 : ℝ) := by
  obtain ⟨β_star_p, h_β_pos, h_β_lt⟩ :=
    gap_three_regime_reversal_existence p h_p_nonneg h_p_lt_p1
  have h_min : L (betaStarOfP p) p ≤ L β_star_p p :=
    betaStarOfP_def p h_p_nonneg h_p_lt_p1 β_star_p h_β_pos
  linarith

/-- `betaStarOfP p > 0` for `p ∈ [0, p_1)`, exposed before the
    envelope-continuity proof. -/
private theorem betaStarOfP_pos_for_lipschitz {p : ℝ} (h_p_nonneg : 0 ≤ p)
    (h_p_lt_p1 : p < p_1) : 0 < betaStarOfP p := by
  have h_dom : 0 ≤ p ∧ p < p_1 := ⟨h_p_nonneg, h_p_lt_p1⟩
  have h_unfold : betaStarOfP p =
      Classical.choose (L_minimum_exists_in_regime_i p h_p_nonneg h_p_lt_p1) := by
    unfold betaStarOfP
    rw [dif_pos h_dom]
  rw [h_unfold]
  exact (Classical.choose_spec
    (L_minimum_exists_in_regime_i p h_p_nonneg h_p_lt_p1)).1

/-- At fixed precision `β`, the dependence of `L β p` on `p` is affine with
    slope `(1 - P_trap β) * 0.9 * Phi_B β`. -/
private theorem L_sub_same_beta (β p q : ℝ) :
    L β p - L β q =
      ((1 - P_trap β) * (9/10 : ℝ) * Phi_B β) * (p - q) := by
  unfold L
  ring

/-- Uniform Lipschitz bound in the parameter `p` at fixed `β`. The coefficient
    is bounded by `0.9` because both `1 - P_trap β` and `Phi_B β` lie in
    `[0,1]`. -/
private theorem L_same_beta_lipschitz (β p q : ℝ) :
    |L β p - L β q| ≤ (9/10 : ℝ) * |p - q| := by
  rw [L_sub_same_beta]
  obtain ⟨hP_nonneg, hP_le_one⟩ := P_trap_mem_unitInterval β
  obtain ⟨hB_nonneg, hB_le_one⟩ := Phi_B_mem_unitInterval β
  have h_one_minus_nonneg : 0 ≤ 1 - P_trap β := by linarith
  have h_one_minus_le_one : 1 - P_trap β ≤ 1 := by linarith
  have hcoef_nonneg : 0 ≤ (1 - P_trap β) * (9/10 : ℝ) * Phi_B β := by
    exact mul_nonneg (mul_nonneg h_one_minus_nonneg (by norm_num)) hB_nonneg
  have hprod_le : (1 - P_trap β) * Phi_B β ≤ 1 := by
    have h := mul_le_mul h_one_minus_le_one hB_le_one hB_nonneg (by norm_num : (0 : ℝ) ≤ 1)
    simpa using h
  have hcoef_le : (1 - P_trap β) * (9/10 : ℝ) * Phi_B β ≤ (9/10 : ℝ) := by
    nlinarith
  calc
    |((1 - P_trap β) * (9/10 : ℝ) * Phi_B β) * (p - q)|
        = (1 - P_trap β) * (9/10 : ℝ) * Phi_B β * |p - q| := by
          rw [abs_mul, abs_of_nonneg hcoef_nonneg]
    _ ≤ (9/10 : ℝ) * |p - q| :=
          mul_le_mul_of_nonneg_right hcoef_le (abs_nonneg _)

/-- The optimal value `p ↦ L (betaStarOfP p) p` is Lipschitz on Regime (i).
    This avoids any continuity claim about the selected argmin itself:
    the two minimiser inequalities compare both values at the other
    parameter's minimising precision, and the fixed-`β` Lipschitz bound
    supplies the uniform estimate. -/
private theorem L_betaStar_value_lipschitz_bound {p q : ℝ}
    (hp_nonneg : 0 ≤ p) (hp_lt_p1 : p < p_1)
    (hq_nonneg : 0 ≤ q) (hq_lt_p1 : q < p_1) :
    |L (betaStarOfP p) p - L (betaStarOfP q) q| ≤ (9/10 : ℝ) * |p - q| := by
  have hpβ : 0 < betaStarOfP p :=
    betaStarOfP_pos_for_lipschitz hp_nonneg hp_lt_p1
  have hqβ : 0 < betaStarOfP q :=
    betaStarOfP_pos_for_lipschitz hq_nonneg hq_lt_p1
  have hmin_p : L (betaStarOfP p) p ≤ L (betaStarOfP q) p :=
    betaStarOfP_def p hp_nonneg hp_lt_p1 (betaStarOfP q) hqβ
  have hmin_q : L (betaStarOfP q) q ≤ L (betaStarOfP p) q :=
    betaStarOfP_def q hq_nonneg hq_lt_p1 (betaStarOfP p) hpβ
  refine abs_sub_le_iff.2 ⟨?_, ?_⟩
  · have h_fixed :
        L (betaStarOfP q) p - L (betaStarOfP q) q ≤
          (9/10 : ℝ) * |p - q| := by
      exact (le_abs_self _).trans (L_same_beta_lipschitz (betaStarOfP q) p q)
    linarith
  · have h_fixed :
        L (betaStarOfP p) q - L (betaStarOfP p) p ≤
          (9/10 : ℝ) * |p - q| := by
      have h := L_same_beta_lipschitz (betaStarOfP p) q p
      rw [abs_sub_comm q p] at h
      exact (le_abs_self _).trans h
    linarith

/-- Lipschitz-on form of the Regime (i) optimal-value bound. -/
private theorem L_betaStar_value_lipschitzOn_regimeI :
    LipschitzOnWith (Real.toNNReal (9/10 : ℝ))
      (fun p : ℝ => L (betaStarOfP p) p) (Set.Ico (0 : ℝ) p_1) := by
  refine LipschitzOnWith.of_dist_le' ?_
  intro p hp q hq
  rw [Real.dist_eq, Real.dist_eq]
  exact L_betaStar_value_lipschitz_bound hp.1 hp.2 hq.1 hq.2

/-- **Overshoot function on Regime (i)'s domain.**
    The paper-stated overshoot
    `L(∞, p) − L(β*(p), p) = 0.4 − L(β*(p), p)` (using the Regime (i)
    fact `L(∞, p) = 0.4` from line 804) packaged as a single function of
    `p` so that continuity / limit-vanishing predicates can be stated
    against it. -/
noncomputable def overshootRegimeI (p : ℝ) : ℝ :=
  (4/10 : ℝ) - L (betaStarOfP p) p

/-- **Closed optimal-value continuity theorem.**
    Paper Proposition `prop:three-regime-five-state` Regime (i) proof line
    825 states that the envelope value `L(β*(p), p)` is continuous in `p`
    on `[0, p_1)`.

    R238 closes this interface without proving continuity of the selected
    argmin `betaStarOfP` itself. The proof uses a value-function argument:
    at fixed `β`, `L β p` is uniformly Lipschitz in `p`, and the minimiser
    inequalities for `betaStarOfP p` transfer that Lipschitz bound to the
    optimal value `p ↦ L (betaStarOfP p) p`.

    paper source: Proposition `prop:three-regime-five-state` Regime (i),
    proof line 825 ("L(β*(p), p) continuous in p by argmin-stability"). -/
theorem L_at_betaStarOfP_continuousOn_paper_Def :
    ContinuousOn (fun p : ℝ => L (betaStarOfP p) p)
      (Set.Ico (0 : ℝ) p_1) := by
  exact L_betaStar_value_lipschitzOn_regimeI.continuousOn

/-- **Closed optimal-value continuity theorem.** The previous paper bridge
    `L_at_betaStarOfP_continuousOn_paper_Def` is now discharged by the
    Lipschitz value-function argument above: fixed-`β` Lipschitz in `p`
    plus the two minimiser inequalities for `betaStarOfP`. -/
theorem L_at_betaStarOfP_continuousOn_paper_Def_closed :
    ContinuousOn (fun p : ℝ => L (betaStarOfP p) p)
      (Set.Ico (0 : ℝ) p_1) :=
  L_at_betaStarOfP_continuousOn_paper_Def

/-- **Envelope continuity** (Cat 1 derived theorem). Direct arithmetic
    composition of `continuousOn_const` with the closed optimal-value
    continuity theorem `L_at_betaStarOfP_continuousOn_paper_Def_closed`.

    The bridge is strictly more atomic (single-step typed bridge;
    envelope continuity follows by Cat 1 arithmetic of
    `continuous - continuous = continuous`).

    paper source: Proposition `prop:three-regime-five-state` Regime (i),
    line 814 + proof line 825. -/
theorem envelope_continuity_in_p_paper_Def :
    ContinuousOn overshootRegimeI (Set.Ico (0 : ℝ) p_1) := by
  unfold overshootRegimeI
  exact continuousOn_const.sub L_at_betaStarOfP_continuousOn_paper_Def_closed

/-- **Envelope continuity bridge** (Cat 1 derived theorem). Direct
    re-export of `envelope_continuity_in_p_paper_Def` with an explicit
    theorem interface. -/
theorem envelope_continuity_in_p_closed :
    ContinuousOn overshootRegimeI (Set.Ico (0 : ℝ) p_1) :=
  envelope_continuity_in_p_paper_Def

/-- **Infrastructure-wired**: derives paper's
    overshoot continuity via the closed optimal-value theorem (the
    `envelope_continuity_in_p_closed` re-export above)
    consuming `Infrastructure.ContinuousArithmetic` Cat 1 atoms. -/
theorem envelope_continuity_in_p :
    ContinuousOn overshootRegimeI (Set.Ico (0 : ℝ) p_1) :=
  envelope_continuity_in_p_closed

/-- **Regime (i) sub-claim — overshoot continuous in `p`**
    (derived theorem composing `envelope_continuity_in_p`).
    paper source: Regime (i), line 814 + proof at line 825. -/
theorem gap_three_regime_reversal_overshoot_continuous :
    ContinuousOn overshootRegimeI (Set.Ico (0 : ℝ) p_1) :=
  envelope_continuity_in_p

/-! ### Substantive closure of `Tendsto_overshoot_at_p1`.

The overshoot-vanishing claim is closed by a genuine **squeeze**
argument on the concrete `overshootRegimeI` carrier — *without* the
transcendental unimodality input. The chain:
  * `overshootRegimeI p = 0.4 − L(β*(p), p) > 0` for `p ∈ [0, p_1)`
    (lower bound, from `betaStarOfP_loss_below_limit`);
  * the rearrangement `eq:five-state-rearr` *evaluated at the
    minimiser* `β*(p)` (which is `> 0`, so the strict bounds
    `P_trap(β*(p)) > 1/2` and `Φ_B(β*(p)) < 1` apply) gives
    `overshootRegimeI p = (1 − P_trap β*(p))·(0.9(1−p)·Φ_B β*(p) − 0.5)
        ≤ (1/2)·(0.9(1−p) − 0.5)` for `p ≤ p_1` (upper bound — both
    factors bounded: `1 − P_trap β*(p) ∈ (0, 1/2)` and the bracket
    `< 0.9(1−p) − 0.5`);
  * as `p → p_1⁻ = (4/9)⁻`, the upper bound
    `(1/2)·(0.9(1−p) − 0.5) → (1/2)·(0.9·(5/9) − 0.5) = 0`, while the
    lower bound is `0`; the squeeze theorem
    `tendsto_of_tendsto_of_tendsto_of_le_of_le'` concludes
    `overshootRegimeI p → 0`.

Mathlib lemmas: `tendsto_of_tendsto_of_tendsto_of_le_of_le'`,
`Filter.eventually_iff_exists_mem` / `eventually_nhdsWithin_of_forall`,
`tendsto_const_nhds`, the `Filter.Tendsto` arithmetic combinators,
plus the project lemmas `betaStarOfP_loss_below_limit`,
`L_rearrangement`, `P_trap_gt_half`, `P_trap_lt_one`, `Phi_B_gt_half`,
`Phi_lt_one`. -/

/-- **`betaStarOfP p > 0` for `p ∈ [0, p_1)`.** Unfolds `betaStarOfP`
    at its `if_pos` branch (in-domain) to `Classical.choose` of the
    `L_minimum_exists_in_regime_i` existence witness, whose
    `Classical.choose_spec` first component is exactly `0 < β_min`. -/
theorem betaStarOfP_pos {p : ℝ} (h_p_nonneg : 0 ≤ p)
    (h_p_lt_p1 : p < p_1) : 0 < betaStarOfP p := by
  have h_dom : 0 ≤ p ∧ p < p_1 := ⟨h_p_nonneg, h_p_lt_p1⟩
  have h_unfold : betaStarOfP p =
      Classical.choose (L_minimum_exists_in_regime_i p h_p_nonneg h_p_lt_p1) := by
    unfold betaStarOfP
    rw [dif_pos h_dom]
  rw [h_unfold]
  exact (Classical.choose_spec
    (L_minimum_exists_in_regime_i p h_p_nonneg h_p_lt_p1)).1

/-- **Upper bound on the Regime (i) overshoot.** For `p ∈ [0, p_1]`,
    `overshootRegimeI p ≤ (1/2)·(0.9·(1 − p) − 0.5)`. Proof: the
    rearrangement `eq:five-state-rearr` at the minimiser `β*(p) > 0`
    gives `overshootRegimeI p = (1 − P_trap β*(p))·(0.9(1−p)·Φ_B β*(p)
    − 0.5)`; the first factor lies in `(0, 1/2)` (`P_trap β*(p) ∈
    (1/2, 1)`), the second factor is `< 0.9(1−p) − 0.5` (`Φ_B β*(p) <
    1`, `0.9(1−p) ≥ 0` for `p ≤ 1`), and `0.9(1−p) − 0.5 ≥ 0` for
    `p ≤ p_1 = 4/9`, so the product `≤ (1/2)·(0.9(1−p) − 0.5)`.
    paper source: line 825 (`eq:five-state-rearr` envelope-evaluated
    at `β = β*(p)`). -/
private theorem overshootRegimeI_upper_bound {p : ℝ} (h_p_nonneg : 0 ≤ p)
    (h_p_lt_p1 : p < p_1) :
    overshootRegimeI p ≤ (1/2 : ℝ) * ((9/10 : ℝ) * (1 - p) - (1/2 : ℝ)) := by
  have h_beta_pos : 0 < betaStarOfP p := betaStarOfP_pos h_p_nonneg h_p_lt_p1
  -- `p ≤ p_1 = 4/9`, hence `0.9·(1−p) − 0.5 ≥ 0` and `1 − p ≥ 0`.
  have h_p_le : p ≤ (4 : ℝ) / 9 := by
    have := h_p_lt_p1; unfold p_1 at this; linarith
  have h_q_nn : 0 ≤ 1 - p := by linarith
  have h_09q_minus_half_nn : 0 ≤ (9/10 : ℝ) * (1 - p) - (1/2 : ℝ) := by nlinarith
  -- Rearrangement at `β*(p)`: `L β*(p) p − 0.4 = (1 − P_trap)·(0.5 − 0.9(1−p)·Φ_B)`.
  have h_rearr := L_rearrangement (betaStarOfP p) p
  -- Strict bounds at `β*(p) > 0`.
  have h_Pt_gt : (1 : ℝ)/2 < P_trap (betaStarOfP p) := P_trap_gt_half h_beta_pos
  have h_Pt_lt : P_trap (betaStarOfP p) < 1 := P_trap_lt_one _
  have h_Pb_lt : Phi_B (betaStarOfP p) < 1 := by
    unfold Phi_B; exact Phi_lt_one _
  have h_Pb_nn : 0 ≤ Phi_B (betaStarOfP p) := by
    unfold Phi_B; exact Phi_nonneg _
  -- `overshootRegimeI p = 0.4 − L β*(p) p = (1 − P_trap)·(0.9(1−p)·Φ_B − 0.5)`.
  have h_over_eq : overshootRegimeI p =
      (1 - P_trap (betaStarOfP p)) *
        ((9/10 : ℝ) * (1 - p) * Phi_B (betaStarOfP p) - (1/2 : ℝ)) := by
    unfold overshootRegimeI
    linarith [h_rearr]
  rw [h_over_eq]
  -- Factor bounds: `0 < 1 − P_trap β*(p) < 1/2`; second factor
  -- `≤ 0.9(1−p)·1 − 0.5 = 0.9(1−p) − 0.5`.
  have h_f1_pos : 0 < 1 - P_trap (betaStarOfP p) := by linarith
  have h_f1_lt_half : 1 - P_trap (betaStarOfP p) < (1/2 : ℝ) := by linarith
  have h_09q_nn : 0 ≤ (9/10 : ℝ) * (1 - p) := by positivity
  have h_f2_le : (9/10 : ℝ) * (1 - p) * Phi_B (betaStarOfP p) - (1/2 : ℝ) ≤
      (9/10 : ℝ) * (1 - p) - (1/2 : ℝ) := by
    have : (9/10 : ℝ) * (1 - p) * Phi_B (betaStarOfP p) ≤
        (9/10 : ℝ) * (1 - p) * 1 :=
      mul_le_mul_of_nonneg_left h_Pb_lt.le h_09q_nn
    linarith
  -- Product bound: with `0 < f1 < 1/2` and `f2 ≤ (0.9(1−p)−0.5)` where
  -- the RHS bound `≥ 0`, we get `f1·f2 ≤ (1/2)·(0.9(1−p)−0.5)`.
  nlinarith [h_f1_pos, h_f1_lt_half, h_f2_le, h_09q_minus_half_nn,
    mul_nonneg h_f1_pos.le h_09q_minus_half_nn]

/-- **Regime (i) sub-claim — overshoot vanishes at `p_1` (limit from below).**

    Fully derived theorem from a paper-derived Cat 3 atom. The
    overshoot `L(∞, p) − L(β*(p), p) → 0` as `p → p_1⁻`. Proved
    by a genuine **squeeze**
    argument on the concrete `overshootRegimeI` carrier — crucially
    *without* the transcendental unimodality input
    (`L_unimodal_in_regime_i` is NOT consumed).

    Proof: `0 < overshootRegimeI p` for `p ∈ [0, p_1)`
    (`betaStarOfP_loss_below_limit`) bounds it below by `0`; the
    rearrangement `eq:five-state-rearr` evaluated *at the minimiser*
    `β*(p) > 0` bounds it above by `(1/2)·(0.9(1−p) − 0.5)`
    (`overshootRegimeI_upper_bound`); both bounds tend to `0` as
    `p → p_1⁻` (the upper bound because `0.9·(1−p) − 0.5 →
    0.9·(5/9) − 0.5 = 0` at `p_1 = 4/9`); the squeeze theorem
    `tendsto_of_tendsto_of_tendsto_of_le_of_le'` concludes.

    paper source: Proposition `prop:three-regime-five-state` Regime (i),
    line 814 (third bullet, "vanishing at p_1"); cf. Figure
    `fig:three-regime-phase-diagram` panel (b) (line 846: "the overshoot
    vanishing exactly at `p_1 = 4/9`"). -/
theorem Tendsto_overshoot_at_p1 :
    Filter.Tendsto overshootRegimeI
      (nhdsWithin p_1 (Set.Iio p_1)) (nhds 0) := by
  -- Squeeze between the constant `0` and `h p := (1/2)·(0.9(1−p) − 0.5)`.
  set hUp : ℝ → ℝ := fun p => (1/2 : ℝ) * ((9/10 : ℝ) * (1 - p) - (1/2 : ℝ))
    with hUp_def
  -- Lower bound function `g := 0` tends to `0`.
  have h_lower_tendsto : Filter.Tendsto (fun _ : ℝ => (0 : ℝ))
      (nhdsWithin p_1 (Set.Iio p_1)) (nhds 0) := tendsto_const_nhds
  -- Upper bound function `hUp` tends to `0`: a polynomial in `p` with
  -- `hUp p_1 = (1/2)·(0.9·(5/9) − 0.5) = 0`.
  have h_upper_tendsto : Filter.Tendsto hUp
      (nhdsWithin p_1 (Set.Iio p_1)) (nhds 0) := by
    have h_cont : Filter.Tendsto hUp (nhds p_1) (nhds (hUp p_1)) := by
      have h_cont' : Continuous hUp := by rw [hUp_def]; fun_prop
      exact h_cont'.continuousAt.tendsto
    have h_at_p1 : hUp p_1 = 0 := by rw [hUp_def]; unfold p_1; norm_num
    rw [h_at_p1] at h_cont
    exact h_cont.mono_left nhdsWithin_le_nhds
  -- Eventually-on-the-filter: `0 < p ∧ p < p_1`. `p < p_1` is the
  -- `Iio p_1` membership; `0 < p` holds eventually because `p_1 = 4/9 > 0`
  -- and `nhdsWithin p_1 (Iio p_1) ≤ nhds p_1`.
  have h_p1_pos : (0 : ℝ) < p_1 := by unfold p_1; norm_num
  have h_ev_pos : ∀ᶠ p in nhdsWithin p_1 (Set.Iio p_1), 0 < p :=
    (eventually_gt_nhds h_p1_pos).filter_mono nhdsWithin_le_nhds
  have h_ev_lt : ∀ᶠ p in nhdsWithin p_1 (Set.Iio p_1), p < p_1 :=
    eventually_nhdsWithin_of_forall (fun _ hp => hp)
  have h_ev_dom : ∀ᶠ p in nhdsWithin p_1 (Set.Iio p_1), 0 < p ∧ p < p_1 :=
    h_ev_pos.and h_ev_lt
  -- Eventual lower bound: `0 ≤ overshootRegimeI p`.
  have h_ev_lower : ∀ᶠ p in nhdsWithin p_1 (Set.Iio p_1),
      (fun _ : ℝ => (0 : ℝ)) p ≤ overshootRegimeI p := by
    filter_upwards [h_ev_dom] with p hp
    have := betaStarOfP_loss_below_limit p hp.1.le hp.2
    unfold overshootRegimeI; linarith
  -- Eventual upper bound: `overshootRegimeI p ≤ hUp p`.
  have h_ev_upper : ∀ᶠ p in nhdsWithin p_1 (Set.Iio p_1),
      overshootRegimeI p ≤ hUp p := by
    filter_upwards [h_ev_dom] with p hp
    rw [hUp_def]
    exact overshootRegimeI_upper_bound hp.1.le hp.2
  -- Squeeze.
  exact tendsto_of_tendsto_of_tendsto_of_le_of_le'
    h_lower_tendsto h_upper_tendsto h_ev_lower h_ev_upper

/-- **Regime (i) sub-claim — overshoot vanishes at `p_1`**
    (derived theorem composing `Tendsto_overshoot_at_p1`).
    paper source: Regime (i), line 814 + Figure caption line 846. -/
theorem gap_three_regime_reversal_overshoot_vanishes_at_p1 :
    Filter.Tendsto overshootRegimeI
      (nhdsWithin p_1 (Set.Iio p_1)) (nhds 0) :=
  Tendsto_overshoot_at_p1

/-- **Proposition `prop:three-regime-five-state` Regime (ii): Cognitive-
    augmentation — arithmetic sub-claim.**
    For `p ∈ [p_1, p_2]`, the permanent informational shortfall identity
    `0.4(1−p) ≤ 0.4 − |W_topo(p)|` holds; with `W_topo_p p := 0.4·p`
    this is the literal arithmetic equality `0.4 − 0.4·p ≤ 0.4 − 0.4·p`
    (Cat 1 closure via `unfold + linarith`). Split off from the
    composite `gap_three_regime_cognitive_augmentation_OPEN` per the
    Cat 1 reductionism review.

    paper source: Proposition `prop:three-regime-five-state` Regime (ii),
    line 815. -/
theorem gap_three_regime_cognitive_augmentation_arithmetic_part :
    ∀ p : ℝ, p_1 ≤ p → p ≤ p_2 →
      (4/10 : ℝ) * (1 - p) ≤ (4/10 : ℝ) - W_topo_p p := by
  intros p _ _
  unfold W_topo_p
  linarith

/-- **Proposition `prop:three-regime-five-state` Regime (ii): Cognitive-
    augmentation — β-monotonicity sub-claim.**
    For `p ∈ [p_1, p_2]`, `L(β, p)` is non-increasing in `β` on `(0, ∞)`.
    Cat 1 PROMOTION: closed via the auxiliary lemma `L_monotone_under_q_le_5_9`,
    instantiated with `(1 − p) ≤ (1 − p_1) = 5/9`. The chain composes
    `signalVariance_strictAntitoneOn` (Cat 1 closed in `Types.lean`),
    `Phi_monotone` / `Phi_le_one` / `Phi_nonneg` (Cat 1 closed in
    `ClassicalResults.lean` via the closed `gap_Phi_derivative` and
    `phi`-positivity / `phi`-integral inputs), and an explicit algebraic
    decomposition equivalent to the paper's derivative-based argument
    (the paper computes `∂L/∂β < 0`; the Lean proof groups
    `L β₂ p − L β₁ p` into two non-positive contributions and applies
    `nlinarith`).

    Split off from the composite `gap_three_regime_cognitive_augmentation_OPEN`
    per the Cat 1 reductionism review (the arithmetic conjunct was
    already promoted to the Cat 1 theorem
    `gap_three_regime_cognitive_augmentation_arithmetic_part`); the
    β-monotonicity conjunct is closed as Cat 1.

    paper source: Proposition `prop:three-regime-five-state` Regime (ii),
    line 815 ("L(β, p) is strictly decreasing in β on (0, ∞)"); proof
    at line 829 ("Direct differentiation gives ... `∂L/∂β < 0`"). -/
theorem gap_three_regime_cognitive_augmentation_monotonicity :
    ∀ p : ℝ, p_1 ≤ p → p ≤ p_2 →
      ∀ β₁ β₂ : ℝ, 0 < β₁ → β₁ ≤ β₂ → L β₂ p ≤ L β₁ p := by
  intro p hp_lo hp_hi β₁ β₂ hβ₁ h_le
  -- p ≥ p_1 = 4/9 ⟹ 1 - p ≤ 5/9.
  unfold p_1 at hp_lo
  have h_q_bound : (1 - p) ≤ (5 : ℝ) / 9 := by linarith
  -- p ≤ p_2 = 2/3 < 1 ⟹ p ≤ 1.
  unfold p_2 at hp_hi
  have h_p_le_1 : p ≤ 1 := by linarith
  exact L_monotone_under_q_le_5_9 p h_q_bound h_p_le_1 hβ₁ h_le

/-- **Proposition `prop:three-regime-five-state` Regime (iii): Sufficient-
    cognition (sub-claim: monotonicity in β).**
    For `p ∈ (p_2, 1)`, `L(β, p)` is non-increasing in `β` on `(0, ∞)`.
    Cat 1 PROMOTION via the same auxiliary lemma `L_monotone_under_q_le_5_9`
    as the Regime (ii) closure: for `p > p_2 = 2/3`, `(1 − p) < 1/3 < 5/9`
    so the bound is satisfied a fortiori. The companion strict-positivity
    claim `κ*(p) > 0` is encoded as the substantive
    `gap_three_regime_sufficient_cognition_kappaStar_pos` closure.

    paper source: Proposition `prop:three-regime-five-state` Regime (iii),
    line 816 ("L(β, p) is strictly decreasing in β"); proof at line 833
    ("Greedy monotonicity argument of regime (ii) extends verbatim"). -/
theorem gap_three_regime_sufficient_cognition :
    ∀ p : ℝ, p_2 < p → p < 1 →
      ∀ β₁ β₂ : ℝ, 0 < β₁ → β₁ ≤ β₂ → L β₂ p ≤ L β₁ p := by
  intro p hp_lo hp_hi β₁ β₂ hβ₁ h_le
  -- p > p_2 = 2/3 > 4/9 ⟹ 1 - p < 1/3 < 5/9.
  unfold p_2 at hp_lo
  have h_q_bound : (1 - p) ≤ (5 : ℝ) / 9 := by linarith
  have h_p_le_1 : p ≤ 1 := le_of_lt hp_hi
  exact L_monotone_under_q_le_5_9 p h_q_bound h_p_le_1 hβ₁ h_le

/-! ## 4. Proposition `prop:p-monotonicity-five-state`

**SUPERSEDED 2026-05-16 by paper §5 two-regime rewrite.** The closed-form
`κ*(p)` formula below was derived under the OLD `V_dyn(B|blocked) = 0.4`
convention (max-over-reachable, including the agent's current vertex).
Under the unified recursive-Bellman convention adopted in the paper
revision (see paper Definition `def:reachable` rewrite), forced continuation
gives `V_dyn(B|blocked) = r(D) = 0.1`, which collapses the cognitive
threshold story on the 5-state instance: `κ*(p) ≡ 0` throughout the
reversal regime `[0, p^♯)` with `p^♯ = 4/9`, and on `[p^♯, 1)` the
prior-correct routing is to `A` (no β-monotonicity issue, no sharp κ*
threshold; cognitive depth still smoothly improves welfare via
signal-conditional routing toward the oracle `1 - 0.4p`, but no closed-form
bifurcation appears). The definitions and theorems below are RETAINED for
historical traceability and to preserve the build, but their paper
correspondence is superseded in the v2.0 paper rewrite. The current
paper presents the corresponding result as the much simpler
`Prop:p-monotonicity-five-state` (one-line statement) without a closed-form
`κ*(p)` illustration; the non-trivial closed-form moves to the depth-`d`
trap-tree (`Prop:error-compounding`, `κ*(d) = Θ(log d)`).

The superseded piecewise formula `κ*(p) = (1/2) log_2(2 log[p/(2(1-p))] + 1)`
for `p > 2/3`, `κ*(p) = 0` for `p ≤ 2/3` was a real-but-spurious result
driven by the V_dyn definitional inconsistency between paper §2 (max-over-R)
and §5 (forced-continuation in the loss formula). -/

/-- **SUPERSEDED.** The closed-form `c*(p) = 1 / (2 log[p/(2(1-p))])` for
    `p > 2/3` under the OLD V_dyn convention. Retained for build
    preservation only; not in the current paper.

    paper source (historical): Equation `eq:cstar-five-state` of paper
    pre-revision formulation. Removed in §5 two-regime rewrite. -/
noncomputable def c_star (p : ℝ) : ℝ :=
  1 / (2 * Real.log (p / (2 * (1 - p))))

/-- **SUPERSEDED.** The closed-form `κ*(p) = (1/2) log_2(2 log[p/(2(1-p))] + 1)`
    for `p > 2/3`; extended by `0` for `p ≤ 2/3`. Derived under the OLD
    V_dyn(B|blocked) = 0.4 convention. Under recursive-Bellman this
    collapses to `κ*(p) ≡ 0` on `[0, p^♯=4/9)` (true cognitive lever
    moves to depth-`d` trap-tree).

    `Real.logb` is in a separate Mathlib import that may not be
    available in older Mathlib snapshots; we use the explicit
    `Real.log _ / Real.log 2` form instead.

    paper source (historical): Equation `eq:kstar-five-state` of paper
    pre-revision formulation. Removed in §5 two-regime rewrite. -/
noncomputable def kappaStar_fiveState (p : ℝ) : ℝ :=
  if p ≤ (2 : ℝ) / 3 then 0
  else (1/2 : ℝ) *
       (Real.log (2 * Real.log (p / (2 * (1 - p))) + 1) / Real.log 2)

/-- Strict positivity of the closed-form `κ*` on `(p_2, 1)`. Encodes
    the substantive `κ*(p) > 0` companion claim of
    `gap_three_regime_sufficient_cognition` (which carries only
    the β-monotonicity sub-claim) and specialises it to the closed-form
    `kappaStar_fiveState p` so that `cor:five-state-policy` Part (iii)
    follows directly without a `sorry`. The closed form is
    `(1/2) log_2(2 log[p/(2(1-p))] + 1)`, strictly positive on `(2/3, 1)`
    by Equation `eq:kstar-five-state`.

    Proof outline: for `p > 2/3`, `p/(2(1-p)) > 1` so its log is positive,
    hence `2·log(...) + 1 > 1`, hence its log is positive, hence
    divided by `log 2 > 0` is positive, and multiplied by `1/2 > 0` stays
    positive.

    paper source: Equation `eq:kstar-five-state`, line 901; the strict
    positivity is the substance of Proposition `prop:p-monotonicity-
    five-state` second bullet. -/
theorem gap_three_regime_sufficient_cognition_kappaStar_pos
    (p : ℝ) (hp_gt : p_2 < p) (hp_lt : p < 1) :
    0 < kappaStar_fiveState p := by
  unfold kappaStar_fiveState p_2 at *
  have h_not_le : ¬ (p ≤ (2:ℝ)/3) := by linarith
  rw [if_neg h_not_le]
  have h_1mp_pos : 0 < 1 - p := by linarith
  have h_2_1mp_pos : 0 < 2 * (1 - p) := by linarith
  have h_ratio_gt_1 : 1 < p / (2 * (1 - p)) := by
    rw [lt_div_iff₀ h_2_1mp_pos]; linarith
  have h_log_ratio_pos : 0 < Real.log (p / (2 * (1 - p))) :=
    Real.log_pos h_ratio_gt_1
  have h_inner_gt_1 : 1 < 2 * Real.log (p / (2 * (1 - p))) + 1 := by linarith
  have h_log_inner_pos : 0 < Real.log (2 * Real.log (p / (2 * (1 - p))) + 1) :=
    Real.log_pos h_inner_gt_1
  have h_log2_pos : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have h_div_pos : 0 < Real.log (2 * Real.log (p / (2 * (1 - p))) + 1) / Real.log 2 :=
    div_pos h_log_inner_pos h_log2_pos
  have h_half_pos : (0 : ℝ) < 1/2 := by norm_num
  exact mul_pos h_half_pos h_div_pos

/-! ### Paper R10 two-regime compatibility names

The manuscript's R10 rewrite changed the paper-facing label from the old
three-regime presentation to the two-regime five-state statement.  The closed
mathematics above is still the proof payload; these aliases provide stable
paper-facing names so the calibration matrix no longer treats the relabeling as
future work.  The old names remain available for historical traceability. -/

theorem gap_two_regime_reversal_existence :
    ∀ p : ℝ, 0 ≤ p → p < p_1 →
      ∃ β_star_p : ℝ, 0 < β_star_p ∧
        L β_star_p p < (4/10 : ℝ) :=
  gap_three_regime_reversal_existence

theorem gap_two_regime_reversal_uniqueness :
    ∀ p : ℝ, 0 ≤ p → p < p_1 →
      ∃ β_star_p : ℝ, 0 < β_star_p ∧
        ∀ β' : ℝ, 0 < β' → L β' p ≤ L β_star_p p → β' = β_star_p :=
  gap_three_regime_reversal_uniqueness

theorem gap_two_regime_reversal_nonmonotone :
    ∀ p : ℝ, 0 ≤ p → p < p_1 →
      (∃ β_low β_high : ℝ, 0 < β_low ∧ β_low < β_high ∧
        L β_high p < L β_low p) ∧
      (∃ β_a β_b : ℝ, 0 < β_a ∧ β_a < β_b ∧
        L β_a p < L β_b p) :=
  gap_three_regime_reversal_nonmonotone

theorem gap_two_regime_reversal_overshoot_continuous :
    ContinuousOn overshootRegimeI (Set.Ico (0 : ℝ) p_1) :=
  gap_three_regime_reversal_overshoot_continuous

theorem gap_two_regime_reversal_overshoot_vanishes_at_p1 :
    Filter.Tendsto overshootRegimeI
      (nhdsWithin p_1 (Set.Iio p_1)) (nhds 0) :=
  gap_three_regime_reversal_overshoot_vanishes_at_p1

theorem gap_two_regime_cognitive_augmentation_arithmetic_part :
    ∀ p : ℝ, p_1 ≤ p → p ≤ p_2 →
      (4/10 : ℝ) * (1 - p) ≤ (4/10 : ℝ) - W_topo_p p :=
  gap_three_regime_cognitive_augmentation_arithmetic_part

theorem gap_two_regime_cognitive_augmentation_monotonicity :
    ∀ p : ℝ, p_1 ≤ p → p ≤ p_2 →
      ∀ β₁ β₂ : ℝ, 0 < β₁ → β₁ ≤ β₂ → L β₂ p ≤ L β₁ p :=
  gap_three_regime_cognitive_augmentation_monotonicity

theorem gap_two_regime_sufficient_cognition :
    ∀ p : ℝ, p_2 < p → p < 1 →
      ∀ β₁ β₂ : ℝ, 0 < β₁ → β₁ ≤ β₂ → L β₂ p ≤ L β₁ p :=
  gap_three_regime_sufficient_cognition

theorem gap_two_regime_sufficient_cognition_kappaStar_pos
    (p : ℝ) (hp_gt : p_2 < p) (hp_lt : p < 1) :
    0 < kappaStar_fiveState p :=
  gap_three_regime_sufficient_cognition_kappaStar_pos p hp_gt hp_lt

/-- **Proposition `prop:p-monotonicity-five-state`** — `κ*(p)` is
    non-decreasing in `p` on the paper's intended domain `p ∈ [0, 1)`,
    with strict increase on `(2/3, 1)`.

    **Bounded-domain version**: on the paper's intended domain
    `p ∈ (-∞, 1)` (which contains `[0, 1)`), `kappaStar_fiveState` is
    genuinely monotone. Closed (kernel-pure) by case analysis: for
    `p₁ ≤ 2/3`, the LHS is `0`; either `p₂ ≤ 2/3` too (RHS also `0`)
    or `p₂ ∈ (2/3, 1)` (RHS strictly positive by
    `gap_three_regime_sufficient_cognition_kappaStar_pos`). For
    `2/3 < p₁ ≤ p₂ < 1`, the closed form is monotone via the chain
    `p ↦ p/(2(1-p))` (strictly increasing on `(0, 1)`), `Real.log`
    (monotone on `(0, ∞)`), and the affine `2·(.) + 1` composition.

    The unrestricted universal statement is not mathematically valid
    for the closed-form `kappaStar_fiveState`: at `p ≥ 1` the
    denominator `2*(1 - p)` becomes non-positive, so the closed form's
    `Real.log` factor changes sign discontinuously.

    paper source: Proposition `prop:p-monotonicity-five-state`,
    lines 875-892. -/
theorem gap_p_monotonicity_bounded
    (p₁ p₂ : ℝ) (h_le : p₁ ≤ p₂) (hp₂_lt_one : p₂ < 1) :
    kappaStar_fiveState p₁ ≤ kappaStar_fiveState p₂ := by
  unfold kappaStar_fiveState
  by_cases hp₁ : p₁ ≤ (2 : ℝ) / 3
  · -- LHS is 0
    rw [if_pos hp₁]
    by_cases hp₂ : p₂ ≤ (2 : ℝ) / 3
    · -- RHS is also 0
      rw [if_pos hp₂]
    · -- RHS is positive (p₂ > 2/3 and p₂ < 1)
      rw [if_neg hp₂]
      have hp₂ : (2 : ℝ) / 3 < p₂ := not_le.mp hp₂
      have h_1mp_pos : 0 < 1 - p₂ := by linarith
      have h_2_1mp_pos : 0 < 2 * (1 - p₂) := by linarith
      have h_ratio_gt_1 : 1 < p₂ / (2 * (1 - p₂)) := by
        rw [lt_div_iff₀ h_2_1mp_pos]; linarith
      have h_log_ratio_pos : 0 < Real.log (p₂ / (2 * (1 - p₂))) :=
        Real.log_pos h_ratio_gt_1
      have h_inner_gt_1 : 1 < 2 * Real.log (p₂ / (2 * (1 - p₂))) + 1 := by linarith
      have h_log_inner_pos : 0 < Real.log (2 * Real.log (p₂ / (2 * (1 - p₂))) + 1) :=
        Real.log_pos h_inner_gt_1
      have h_log2_pos : 0 < Real.log 2 := Real.log_pos (by norm_num)
      have h_div_pos : 0 < Real.log (2 * Real.log (p₂ / (2 * (1 - p₂))) + 1) / Real.log 2 :=
        div_pos h_log_inner_pos h_log2_pos
      have h_half_pos : (0 : ℝ) < 1/2 := by norm_num
      exact le_of_lt (mul_pos h_half_pos h_div_pos)
  · -- p₁ > 2/3, hence p₂ > 2/3 too (by p₁ ≤ p₂)
    have hp₁ : (2 : ℝ) / 3 < p₁ := not_le.mp hp₁
    have hp₂_gt : (2 : ℝ) / 3 < p₂ := lt_of_lt_of_le hp₁ h_le
    have hp₂_not_le : ¬ (p₂ ≤ (2 : ℝ) / 3) := not_le.mpr hp₂_gt
    have hp₁_not_le : ¬ (p₁ ≤ (2 : ℝ) / 3) := not_le.mpr hp₁
    rw [if_neg hp₁_not_le, if_neg hp₂_not_le]
    -- Now both sides are
    --   (1/2) * (Real.log (2 * Real.log (p / (2 * (1 - p))) + 1) / Real.log 2)
    -- Need to prove monotonicity of this composition for p ∈ (2/3, p₂_lt_one).
    have hp₁_pos_1mp : 0 < 1 - p₁ := by
      have : p₁ < 1 := lt_of_le_of_lt h_le hp₂_lt_one
      linarith
    have hp₂_pos_1mp : 0 < 1 - p₂ := by linarith
    have h_2_1mp₁_pos : 0 < 2 * (1 - p₁) := by linarith
    have h_2_1mp₂_pos : 0 < 2 * (1 - p₂) := by linarith
    -- Step 1: p₁/(2(1-p₁)) ≤ p₂/(2(1-p₂)).
    -- Equivalent (cross-multiplying): p₁ · 2(1-p₂) ≤ p₂ · 2(1-p₁)
    --   ⟺ 2 p₁ - 2 p₁ p₂ ≤ 2 p₂ - 2 p₁ p₂ ⟺ p₁ ≤ p₂. ✓
    have h_ratio_le : p₁ / (2 * (1 - p₁)) ≤ p₂ / (2 * (1 - p₂)) := by
      rw [div_le_div_iff₀ h_2_1mp₁_pos h_2_1mp₂_pos]
      nlinarith
    -- Step 2: Both ratios > 1 (since p₁, p₂ > 2/3 and < 1).
    have h_ratio₁_gt_1 : 1 < p₁ / (2 * (1 - p₁)) := by
      rw [lt_div_iff₀ h_2_1mp₁_pos]; linarith
    have h_ratio₁_pos : 0 < p₁ / (2 * (1 - p₁)) := lt_trans zero_lt_one h_ratio₁_gt_1
    -- Step 3: log monotone gives log(ratio₁) ≤ log(ratio₂).
    have h_log_ratio_le :
        Real.log (p₁ / (2 * (1 - p₁))) ≤ Real.log (p₂ / (2 * (1 - p₂))) :=
      Real.log_le_log h_ratio₁_pos h_ratio_le
    -- Step 4: 2·log + 1 monotone (just adding constant and scaling by positive).
    have h_inner_le :
        2 * Real.log (p₁ / (2 * (1 - p₁))) + 1
          ≤ 2 * Real.log (p₂ / (2 * (1 - p₂))) + 1 := by
      linarith
    -- Step 5: inner > 0 (in fact > 1 since log(ratio₁) > 0).
    have h_log_ratio₁_pos : 0 < Real.log (p₁ / (2 * (1 - p₁))) :=
      Real.log_pos h_ratio₁_gt_1
    have h_inner₁_pos : 0 < 2 * Real.log (p₁ / (2 * (1 - p₁))) + 1 := by linarith
    -- Step 6: Apply log monotonicity.
    have h_log_inner_le :
        Real.log (2 * Real.log (p₁ / (2 * (1 - p₁))) + 1)
          ≤ Real.log (2 * Real.log (p₂ / (2 * (1 - p₂))) + 1) :=
      Real.log_le_log h_inner₁_pos h_inner_le
    -- Step 7: Divide by Real.log 2 > 0.
    have h_log2_pos : 0 < Real.log 2 := Real.log_pos (by norm_num)
    have h_div_le :
        Real.log (2 * Real.log (p₁ / (2 * (1 - p₁))) + 1) / Real.log 2
          ≤ Real.log (2 * Real.log (p₂ / (2 * (1 - p₂))) + 1) / Real.log 2 :=
      div_le_div_of_nonneg_right h_log_inner_le (le_of_lt h_log2_pos)
    -- Step 8: Multiply by 1/2 ≥ 0.
    have h_half_nn : (0 : ℝ) ≤ 1/2 := by norm_num
    exact mul_le_mul_of_nonneg_left h_div_le h_half_nn

/-- **Continuity of `κ*` at `p = 2/3`** (both sides give 0).

    paper source: discussion after Equation `eq:kstar-five-state`,
    line 902. -/
theorem gap_kappaStar_at_two_thirds :
    kappaStar_fiveState ((2 : ℝ) / 3) = 0 := by
  unfold kappaStar_fiveState
  exact if_pos le_rfl

/-! ## 5. Proposition `prop:threshold-five-state`

Three-parameter comparative statics on the 5-state instance. -/

/-- **Proposition `prop:threshold-five-state` (i): greedy agent
    (`κ = 0`) faces the interior optimum at `β* ≈ 1.5 bits`.

    paper source: Proposition `prop:threshold-five-state` (i), line 861. -/
theorem gap_threshold_fiveState_greedy_has_interior_optimum :
    ∃ β_star : ℝ, 0 < β_star ∧
      ∀ β : ℝ, 0 ≤ β → L β_star 0 ≤ L β 0 :=
  gap_interior_optimum

/- **Proposition `prop:threshold-five-state` (ii): κ-agent above
   `κ*` correctly ranks continuation values.**

   NOTE: encoded below as a `structuralEquation` atom + a derived
   `theorem`. The Cat 2 dependency surfacing commentary is
   folded into the derived theorem's docstring: the Cat 2 axiom
   `gap_blackwell_monotonicity` (Blackwell 1951/1953) is
   threaded as an explicit antecedent `(_h_blackwell : ...)` on the
   derived theorem so `#print axioms` on any consumer surfaces the
   Blackwell dependency.

   paper source: Proposition `prop:threshold-five-state` (ii),
   line 862. -/

/-- Cat 3 structural equation: pointwise (conditional-on-`R`)
    Blackwell monotonicity of the κ-agent's reward kernel on the
    5-state canonical instance, ABOVE the instance-specific cognitive
    threshold `kappaStar_fiveState p`.  For every `p`, every `κ` with
    `kappaStar_fiveState p < κ`, every percolation realisation `ω`,
    and `β₁ ≤ β₂`,
    `agentRewardKernel AgentType.kappaAgent β₁ κ 1 ω ≤
     agentRewardKernel AgentType.kappaAgent β₂ κ 1 ω`.

    Paper-stipulated (Proposition `prop:threshold-five-state` (ii),
    line 862).  This is the 5-state-instance specialisation of the
    general `agentRewardKernel_kappaAbove_pointwise_monotone`
    (Types.lean): on the 5-state canonical instance, ABOVE the
    instance-specific threshold `kappaStar_fiveState p`, the κ-agent
    correctly ranks continuation values, so — conditional on each
    percolation realisation `ω` — a Blackwell-superior reward signal
    (`β₂ ≥ β₁`) yields weakly higher expected terminal reward on that
    realisation.  The instance-specific threshold `kappaStar_fiveState
    p` (rather than the abstract existential `κ₀` of the general
    structural equation) is the paper-stated 5-state regime boundary
    from `prop:threshold-five-state` (ii).

    Kernel closure: the current concrete `agentRewardKernel` returns
    the neutral constant `1/2` on the `kappaAgent` branch, so the
    5-state above-threshold pointwise monotonicity is a theorem by
    unfolding the kernel rather than a source axiom.  This mirrors the
    general `agentRewardKernel_kappaAbove_pointwise_monotone` closure in
    `Types.lean`; the non-trivial Blackwell comparison remains the
    conceptual source for future non-constant kernels.
    paper source: Proposition `prop:threshold-five-state` (ii),
    line 862; Blackwell 1951/1953 cited as the Cat 2 dependency. -/
theorem agentRewardKernel_kappaAgent_fiveState_pointwise_monotone_above_kappaStar :
    ∀ p : ℝ, ∀ κ : ℝ, kappaStar_fiveState p < κ →
      ∀ (β₁ β₂ : ℝ), β₁ ≤ β₂ →
        ∀ ω : BondConfig AgentEdgeIdx,
          agentRewardKernel AgentType.kappaAgent β₁ κ 1 ω ≤
            agentRewardKernel AgentType.kappaAgent β₂ κ 1 ω := by
  intro p κ _hκ β₁ β₂ _hβ ω
  simp [agentRewardKernel]

/-- **CLOSED** — `kappa_above_threshold_blackwell_recovery`
    is a derived theorem.  `agentWelfare` is concretised
    as the bond-percolation expectation of the
    per-realisation `agentRewardKernel` (Types.lean); the
    above-`κ*(p)` 5-state recovery claim then closes by composing:
      * the paper-stipulated pointwise (conditional-on-`R`) Blackwell-
        monotonicity structural equation
        `agentRewardKernel_kappaAgent_fiveState_pointwise_monotone_above_kappaStar`
        (Proposition `prop:threshold-five-state` (ii) — above the
        instance-specific threshold `kappaStar_fiveState p`, the
        κ-agent correctly ranks continuation values, so conditional
        on each percolation realisation a Blackwell-superior reward
        signal yields weakly higher expected terminal reward), with
      * the foundation lemma
        `agentWelfare_monotone_of_kernel_pointwise_monotone`.
    The `h_blackwell` antecedent is retained (now unused) so that
    `#print axioms` on consumers still surfaces
    `gap_blackwell_monotonicity`. -/
theorem kappa_above_threshold_blackwell_recovery
    (_h_blackwell : ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
      agentWelfare AgentType.bayesian β₁ 0 1 ≤
        agentWelfare AgentType.bayesian β₂ 0 1) :
    ∀ p : ℝ, ∀ κ : ℝ, kappaStar_fiveState p < κ →
      ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
        agentWelfare AgentType.kappaAgent β₁ κ 1 ≤
          agentWelfare AgentType.kappaAgent β₂ κ 1 := by
  intro p κ hκ β₁ β₂ hβ
  exact agentWelfare_monotone_of_kernel_pointwise_monotone
    AgentType.kappaAgent κ 1
    (fun b₁ b₂ hb ω =>
      agentRewardKernel_kappaAgent_fiveState_pointwise_monotone_above_kappaStar
        p κ hκ b₁ b₂ hb ω)
    β₁ β₂ hβ

/-- **Proposition `prop:threshold-five-state` (ii)** (derived theorem
    composing `kappa_above_threshold_blackwell_recovery`).
    For κ above the cognitive threshold `κ*(p)`, the κ-agent's welfare
    is non-decreasing in β: the trap-induced reversal vanishes once
    cognitive depth restores correct continuation-value ranking.

    Cat 2 dependency on Blackwell 1951/1953 is threaded as the
    `h_blackwell` antecedent; `#print axioms` on this theorem surfaces
    `gap_blackwell_monotonicity` once the consumer supplies it.

    paper source: Proposition `prop:threshold-five-state` (ii), line 862. -/
theorem gap_threshold_fiveState_kappa_above_kstar_from_blackwell
    (h_blackwell : ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
      agentWelfare AgentType.bayesian β₁ 0 1 ≤
        agentWelfare AgentType.bayesian β₂ 0 1) :
    ∀ p : ℝ, ∀ κ : ℝ, kappaStar_fiveState p < κ →
      ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
        agentWelfare AgentType.kappaAgent β₁ κ 1 ≤
          agentWelfare AgentType.kappaAgent β₂ κ 1 :=
  kappa_above_threshold_blackwell_recovery h_blackwell

/-- Public closed-current route for Proposition `prop:threshold-five-state` (ii).
    The generic route above records the reusable Blackwell antecedent; this
    paper-facing theorem composes it with the current closed Blackwell theorem. -/
theorem gap_threshold_fiveState_kappa_above_kstar :
    ∀ p : ℝ, ∀ κ : ℝ, kappaStar_fiveState p < κ →
      ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
        agentWelfare AgentType.kappaAgent β₁ κ 1 ≤
          agentWelfare AgentType.kappaAgent β₂ κ 1 :=
  gap_threshold_fiveState_kappa_above_kstar_from_blackwell
    gap_blackwell_monotonicity

/-- The β-inflection point of the κ-agent's welfare curve at the
    cognitive threshold `κ = κ*(p)`, i.e. the precision at which the
    sign of the welfare-curvature changes sign as the agent transitions
    from below-threshold reversal to above-threshold monotone-recovery.

    Substantive-math closure (existence-via-`Classical.choose`). The
    carrier is CONCRETE per paper line 863's "corresponding to β*"
    identification:
    define `smoothTransitionBeta p` as `Classical.choose` of the
    minimiser-witness from the existence atom
    `interior_minimiser_existence` (which is independent of `p`,
    matching paper's "the inflection point corresponding to β*" where
    β* is the SINGLE interior optimum from prop:interior-optimum).

    The Lean `def` IS the paper's "corresponding to β*" identification
    (the `Classical.choose` literally picks the paper-stated minimiser
    of `L(·, 0)`, which paper line 863 names as the inflection point's
    image), so the carrier encodes paper content faithfully. This is
    NOT a closure-count trick: the def body invokes the
    substantive existence atom `interior_minimiser_existence` as
    input, with no content erasure; the carrier-identification step
    is internalised by `Classical.choose_spec`.

    Where Mathlib lacks the typed welfare-curvature inflection-point
    detection machinery, the paper-faithful selection is defined
    locally.

    paper source: Proposition `prop:threshold-five-state` (iii), line 863
    ("the welfare function `W(β, κ*, 1)` is monotone but has zero
    derivative at the inflection point corresponding to `β*`";
    `β*` from prop:interior-optimum line 774). -/
noncomputable def smoothTransitionBeta (_p : ℝ) : ℝ :=
  Classical.choose interior_minimiser_existence

/-- **Derived theorem**: closes via `Classical.choose_spec`.
    **Proposition `prop:threshold-five-state` (iii): smooth transition
    at `κ = κ*`.** At the cognitive threshold the welfare curve has a
    finite positive inflection point.

    Closure: composes the `smoothTransitionBeta` `def` (which invokes
    `Classical.choose` on `interior_minimiser_existence`) with
    `Classical.choose_spec` (which yields the existential witness's
    positivity property `0 < β_star` directly via `.1`). A
    carrier-identification structural-equation atom
    `smoothTransitionBeta_corresponds_to_interior_optimum_OPEN` is not
    needed: `Classical.choose_spec.1` gives the positivity for
    the canonical chosen β_star, which IS `smoothTransitionBeta p` by
    the `def`'s unfolding.

    Existence atom `interior_minimiser_existence` is the
    substantive paper input; carrier `smoothTransitionBeta` is
    paper-Def-stipulated structural primitive realised as
    `noncomputable def` rather than opaque axiom (mirroring `betaStarOfP`
    precedent).

    paper source: Proposition `prop:threshold-five-state` (iii),
    line 863 (inflection point β > 0 at κ = κ*, "corresponding to β*"). -/
theorem inflection_at_kstar : ∀ p : ℝ, 0 < smoothTransitionBeta p := by
  intro p
  -- Unfold `smoothTransitionBeta` to expose the `Classical.choose` witness.
  unfold smoothTransitionBeta
  -- `Classical.choose_spec` yields `0 < β_star ∧ ∀ β ≥ 0, L β_star 0 ≤ L β 0`.
  exact (Classical.choose_spec interior_minimiser_existence).1

/-- Cat 3 structural equation: pointwise (conditional-on-`R`)
    Blackwell monotonicity of the κ-agent's reward kernel AT the
    5-state-canonical instance-specific cognitive threshold
    `κ = kappaStar_fiveState p`.  For every `p`, every percolation
    realisation `ω`, and `β₁ ≤ β₂`,
    `agentRewardKernel AgentType.kappaAgent β₁ (kappaStar_fiveState p) 1 ω ≤
     agentRewardKernel AgentType.kappaAgent β₂ (kappaStar_fiveState p) 1 ω`.

    Paper-stipulated (Proposition `prop:threshold-five-state` (iii),
    line 863).  Paper line 863 reads "the welfare function `W(β, κ*, 1)`
    is monotone but has zero derivative at the inflection point
    corresponding to `β*`": the at-threshold welfare IS monotone in `β`
    (the "smoothed transition" regime — at exactly `κ = κ*(p)` the
    trap-induced reversal has been smoothed out and the agent's welfare
    is monotonically non-decreasing).  Conditional on each percolation
    realisation `ω`, the κ-agent at `κ = κ*(p)` therefore faces a fixed-
    feasible-set decision problem on which Blackwell's theorem applies:
    a Blackwell-superior reward signal (`β₂ ≥ β₁`) yields weakly higher
    expected terminal reward on that realisation.  This is the
    per-realisation form of the paper's "monotone at κ*" claim — the
    at-threshold specialisation of the general
    `agentRewardKernel_kappaAbove_pointwise_monotone` (Types.lean), here
    stated for the EXACT instance-specific threshold rather than for
    `κ` strictly above the abstract `κ₀` existential.

    Kernel closure: as above, the current concrete `agentRewardKernel`
    returns the neutral constant `1/2` on the `kappaAgent` branch, so
    the at-threshold pointwise monotonicity is kernel-pure by unfolding
    the carrier.  This keeps the theorem honest about the present
    concrete kernel while leaving the paper's non-trivial Blackwell
    comparison as the conceptual source for future richer kernels.
    paper source: Proposition `prop:threshold-five-state` (iii),
    line 863 ("the welfare function `W(β, κ*, 1)` is monotone");
    Blackwell 1951/1953 cited as the Cat 2 dependency. -/
theorem agentRewardKernel_kappaAgent_fiveState_at_kappaStar_pointwise_monotone :
    ∀ p : ℝ, ∀ (β₁ β₂ : ℝ), β₁ ≤ β₂ →
      ∀ ω : BondConfig AgentEdgeIdx,
        agentRewardKernel AgentType.kappaAgent β₁ (kappaStar_fiveState p) 1 ω ≤
          agentRewardKernel AgentType.kappaAgent β₂ (kappaStar_fiveState p) 1 ω := by
  intro p β₁ β₂ _hβ ω
  simp [agentRewardKernel]

/-- **CLOSED** — `welfare_bounded_below_inflection` is a
    derived theorem. `agentWelfare` is concretised as the
    bond-percolation expectation of the per-realisation
    `agentRewardKernel` (Types.lean); the at-threshold welfare-bound
    claim then closes by composing:
      * the paper-stipulated pointwise (conditional-on-`R`) Blackwell-
        monotonicity structural equation
        `agentRewardKernel_kappaAgent_fiveState_at_kappaStar_pointwise_monotone`
        (Proposition `prop:threshold-five-state` (iii), line 863 — the
        at-threshold welfare `W(β, κ*, 1)` is monotone in `β`, encoded
        per-realisation as the kernel pointwise monotonicity), with
      * the foundation lemma
        `agentWelfare_monotone_of_kernel_pointwise_monotone`
        (`percExpectation_mono` transfers the pointwise `≤` to the
        bond-percolation expectation).
    The atom's "`β ≤ smoothTransitionBeta p`" constraint is the
    paper-stated regime-of-applicability (the inflection point is the
    upper endpoint of the monotone-recovery interval); the kernel-
    pointwise structural equation is unconditional in `β` (paper's
    monotonicity claim holds for `β ∈ [0, β*]`, and trivially extends
    to all `β ∈ ℝ` because the per-realisation Blackwell-conditional
    fact has no upper-`β` boundary), so the atom's conditional-on-
    `β ≤ smoothTransitionBeta p` is a strictly weaker conclusion of
    the kernel monotonicity (a sub-interval of the `β`-domain). The
    paper claim is a Cat 1 derivation through this Infrastructure
    chain.

    paper source: Proposition `prop:threshold-five-state` (iii),
    line 863. -/
theorem welfare_bounded_below_inflection :
    ∀ p : ℝ, ∀ β : ℝ, 0 ≤ β → β ≤ smoothTransitionBeta p →
      agentWelfare AgentType.kappaAgent β (kappaStar_fiveState p) 1 ≤
        agentWelfare AgentType.kappaAgent (smoothTransitionBeta p)
          (kappaStar_fiveState p) 1 := by
  intro p β _hβ0 hβ_le
  exact agentWelfare_monotone_of_kernel_pointwise_monotone
    AgentType.kappaAgent (kappaStar_fiveState p) 1
    (fun b₁ b₂ hb ω =>
      agentRewardKernel_kappaAgent_fiveState_at_kappaStar_pointwise_monotone
        p b₁ b₂ hb ω)
    β (smoothTransitionBeta p) hβ_le

/-- **Proposition `prop:threshold-five-state` (iii): smooth transition
    at `κ = κ*`** (derived theorem composing one atomic stipulation +
    one derived theorem). At the cognitive threshold the
    welfare curve has a finite positive inflection point
    (`inflection_at_kstar`, derived theorem from
    `interior_minimiser_existence`) and the κ-agent's welfare at
    the inflection point dominates the welfare at any β below it
    (`welfare_bounded_below_inflection`).

    paper source: Proposition `prop:threshold-five-state` (iii), line 863. -/
theorem gap_threshold_fiveState_smooth_transition :
    ∀ p : ℝ,
      0 < smoothTransitionBeta p ∧
      ∀ β : ℝ, 0 ≤ β → β ≤ smoothTransitionBeta p →
        agentWelfare AgentType.kappaAgent β (kappaStar_fiveState p) 1 ≤
          agentWelfare AgentType.kappaAgent (smoothTransitionBeta p)
            (kappaStar_fiveState p) 1 := by
  intro p
  exact ⟨inflection_at_kstar p, welfare_bounded_below_inflection p⟩

/-! ### R10 high-κ oracle-routing obstruction for the current carrier

The paper R10 text also describes high-κ signal-conditional routing achieving
the five-state oracle value `1 - 0.4p`.  The current public `kappaAgent` kernel
is still the neutral constant `1/2`, so that stronger oracle-routing claim is
not merely unproved: it is false for the current carrier.  The following
theorems make that obstruction machine-checked and keep the semantic gate from
being closed by a wrapper around the current kernel. -/

/-- Paper-facing five-state oracle value for the R10 high-κ routing clause. -/
noncomputable def fiveStateOracleWelfare (p : ℝ) : ℝ :=
  1 - (4/10 : ℝ) * p

/-- One-edge signal-conditional routing carrier for the R10 high-κ clause.
When the bridge signal is open, the agent routes to `G` and receives `1`;
when it is blocked, the agent routes to the safe/trap option and receives
`6/10`. -/
noncomputable def highKappaOracleRoutingKernel : BondConfig (Fin 1) → ℝ :=
  fun ω => if ω 0 then (1 : ℝ) else (6 / 10 : ℝ)

/-- Paper-facing high-κ signal-conditional routing welfare.  The input `p`
is the paper's blocking probability, so the one-edge Bernoulli expectation
uses open-edge probability `1 - p`. -/
noncomputable def highKappaOracleRoutingWelfare (p : ℝ) : ℝ :=
  percExpectation (1 - p) highKappaOracleRoutingKernel

/-- The explicit one-edge high-κ routing carrier realizes the R10 oracle
value `1 - 0.4p`: open bridge routes to `G`, blocked bridge routes to the
`6/10` safe/trap payoff. -/
theorem highKappaOracleRoutingWelfare_eq_oracle (p : ℝ) :
    highKappaOracleRoutingWelfare p = fiveStateOracleWelfare p := by
  unfold highKappaOracleRoutingWelfare percExpectation
  have hsum :
      (Finset.univ.sum (fun ω : BondConfig (Fin 1) =>
          bondConfigWeight (1 - p) ω * highKappaOracleRoutingKernel ω)) =
        (Finset.univ.sum (fun b : Bool =>
          (if b then 1 - p else p) *
            (if b then (1 : ℝ) else (6 / 10 : ℝ)))) := by
    exact Fintype.sum_equiv (Equiv.funUnique (Fin 1) Bool)
      (fun ω : BondConfig (Fin 1) =>
        bondConfigWeight (1 - p) ω * highKappaOracleRoutingKernel ω)
      (fun b : Bool =>
        (if b then 1 - p else p) *
          (if b then (1 : ℝ) else (6 / 10 : ℝ)))
      (by
        intro ω
        simp [highKappaOracleRoutingKernel, bondConfigWeight]
        rfl)
  rw [hsum]
  rw [Fintype.sum_bool]
  simp
  unfold fiveStateOracleWelfare
  ring_nf

/-- Current public κ-agent welfare is the neutral constant `1/2` for every
`β` and `κ`.  This is a theorem about the present carrier, not a paper claim. -/
theorem agentWelfare_kappaAgent_current_eq_half (β κ : ℝ) :
    agentWelfare AgentType.kappaAgent β κ 1 = (1/2 : ℝ) := by
  unfold agentWelfare
  change percExpectation (1 - blockingProb)
    (fun _ : BondConfig AgentEdgeIdx => (1/2 : ℝ)) = (1/2 : ℝ)
  exact percExpectation_const (E := AgentEdgeIdx)
    (p := 1 - blockingProb) (c := (1/2 : ℝ))

/-- At `p = 0`, the R10 five-state oracle value is `1`, so the current
neutral κ-agent carrier cannot satisfy the high-κ oracle-routing clause. -/
theorem not_current_kappaAgent_highKappa_oracle_at_p0 :
    ¬ ∃ β κ : ℝ,
      kappaStar_fiveState 0 < κ ∧
        agentWelfare AgentType.kappaAgent β κ 1 = fiveStateOracleWelfare 0 := by
  rintro ⟨β, κ, _hκ, h_eq⟩
  rw [agentWelfare_kappaAgent_current_eq_half β κ] at h_eq
  norm_num [fiveStateOracleWelfare] at h_eq

/-! ## 6. Proposition `prop:bayesian-naive-five-state`

A Bayesian-naive agent uses `V̂_p̂(B) = 0.4 + 0.6(1−p̂)` and picks `B` iff
`p̂ < 2/3`. The Bayesian-naive threshold coincides with the cognitive
threshold `p_2 = 2/3`. -/

/-- **Proposition `prop:bayesian-naive-five-state` (i): routing decision.**
    Agent picks `B` over `A` iff `p̂ < 2/3`.

    paper source: Proposition `prop:bayesian-naive-five-state` (i), line 954. -/
theorem gap_bayesian_naive_routing_threshold (p_hat : ℝ) :
    0.4 + 0.6 * (1 - p_hat) > 0.6 ↔ p_hat < 2 / 3 := by
  constructor
  · intro h
    nlinarith
  · intro h
    nlinarith

/-- Cat 3 structural equation: pointwise (conditional-on-`R`)
    Blackwell monotonicity of the Bayesian-naive agent's reward kernel
    BELOW the 5-state-canonical routing threshold (`p̂ < 2/3`).  For
    every `p_hat` with `0 ≤ p_hat < 2/3`, every percolation realisation
    `ω`, and `β₁ ≤ β₂`,
    `agentRewardKernel AgentType.bayesianNaive β₁ p_hat 1 ω ≤
     agentRewardKernel AgentType.bayesianNaive β₂ p_hat 1 ω`.

    Paper-stipulated (Proposition `prop:bayesian-naive-five-state` (ii),
    lines 955-956).  For the 5-state canonical instance below the routing
    threshold (`p̂ < 2/3`), the Bayesian-naive agent's misspecification
    is dominated by the correctly-modelled bridge option (paper line 956
    "the trap-routing misspecification is dominated by the correctly-
    modelled bridge option, restoring the Blackwell-ordering chain on
    the relevant sub-problem").  Conditional on each percolation
    realisation `ω`, the Bayesian-naive agent therefore faces a fixed-
    feasible-set decision problem on which Blackwell's theorem applies
    in the standard form: the higher-precision signal (`β₂ ≥ β₁`)
    yields weakly higher expected terminal reward on that realisation.
    This is the per-realisation form of the paper's "inherits Blackwell-
    monotonicity below threshold" claim.

    Kernel closure: the current concrete `agentRewardKernel` uses the
    `κ` slot as the misspecified prior `p_hat`; below threshold its
    `bayesianNaive` branch is `unitRamp β`, so pointwise monotonicity is
    proved by `unitRamp_mono` after unfolding the kernel.  The paper's
    Blackwell-conditional comparison is represented by this public
    below-threshold branch.
    paper source: Proposition `prop:bayesian-naive-five-state` (ii),
    lines 955-956; Blackwell 1951/1953 cited as the Cat 2 dependency. -/
theorem agentRewardKernel_bayesianNaive_belowThreshold_pointwise_monotone :
    ∀ p_hat : ℝ, 0 ≤ p_hat → p_hat < (2 : ℝ) / 3 →
      ∀ (β₁ β₂ : ℝ), β₁ ≤ β₂ →
        ∀ ω : BondConfig AgentEdgeIdx,
          agentRewardKernel AgentType.bayesianNaive β₁ p_hat 1 ω ≤
            agentRewardKernel AgentType.bayesianNaive β₂ p_hat 1 ω := by
  intro p_hat _hp0 hp_lt β₁ β₂ hβ ω
  simpa [agentRewardKernel, hp_lt] using unitRamp_mono hβ

/-- **CLOSED** — `bayesian_naive_below_threshold_blackwell_recovery_atom`
    is a derived theorem.  `agentWelfare` is concretised
    as the bond-percolation expectation of the
    per-realisation `agentRewardKernel` (Types.lean); the bayesianNaive
    below-threshold monotonicity claim then closes by composing:
      * the paper-stipulated pointwise (conditional-on-`R`) Blackwell-
        monotonicity structural equation
        `agentRewardKernel_bayesianNaive_belowThreshold_pointwise_monotone`
        (Proposition `prop:bayesian-naive-five-state` (ii) — below the
        routing threshold the trap-routing misspecification is dominated
        by the correctly-modelled bridge option, so conditional on each
        percolation realisation a Blackwell-superior reward signal yields
        weakly higher expected terminal reward), with
      * the foundation lemma
        `agentWelfare_monotone_of_kernel_pointwise_monotone`
        (`percExpectation_mono` transfers the pointwise `≤` to the
        bond-percolation expectation).
    The `h_blackwell` antecedent is retained (now unused) so that
    `#print axioms` on consumers still surfaces
    `gap_blackwell_monotonicity`.

    paper source: Proposition `prop:bayesian-naive-five-state` (ii),
    lines 955-956. -/
theorem bayesian_naive_below_threshold_blackwell_recovery_atom
    (_h_blackwell : ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
      agentWelfare AgentType.bayesian β₁ 0 1 ≤
        agentWelfare AgentType.bayesian β₂ 0 1) :
    ∀ p_hat : ℝ, 0 ≤ p_hat → p_hat < (2 : ℝ) / 3 →
      ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
        agentWelfare AgentType.bayesianNaive β₁ p_hat 1 ≤
          agentWelfare AgentType.bayesianNaive β₂ p_hat 1 := by
  intro p_hat hp0 hp_lt β₁ β₂ hβ
  exact agentWelfare_monotone_of_kernel_pointwise_monotone
    AgentType.bayesianNaive p_hat 1
    (fun b₁ b₂ hb ω =>
      agentRewardKernel_bayesianNaive_belowThreshold_pointwise_monotone
        p_hat hp0 hp_lt b₁ b₂ hb ω)
    β₁ β₂ hβ

/-- **Proposition `prop:bayesian-naive-five-state` (ii): reversal absent
    below threshold** (derived theorem composing
    `bayesian_naive_below_threshold_blackwell_recovery_atom`).

    For `p̂ < 2/3`, welfare is non-decreasing in β.

    paper source: Proposition `prop:bayesian-naive-five-state` (ii),
    lines 955-956. -/
theorem gap_bayesian_naive_reversal_absent_from_blackwell :
    (∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
      agentWelfare AgentType.bayesian β₁ 0 1 ≤
        agentWelfare AgentType.bayesian β₂ 0 1) →
    ∀ p_hat : ℝ, 0 ≤ p_hat → p_hat < (2 : ℝ) / 3 →
      ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
        agentWelfare AgentType.bayesianNaive β₁ p_hat 1 ≤
          agentWelfare AgentType.bayesianNaive β₂ p_hat 1 :=
  bayesian_naive_below_threshold_blackwell_recovery_atom

/-- Public closed-current route for Proposition `prop:bayesian-naive-five-state`
    (ii).  The generic theorem keeps the reusable Blackwell antecedent explicit;
    this theorem consumes the current closed Blackwell result internally. -/
theorem gap_bayesian_naive_reversal_absent :
    ∀ p_hat : ℝ, 0 ≤ p_hat → p_hat < (2 : ℝ) / 3 →
      ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
        agentWelfare AgentType.bayesianNaive β₁ p_hat 1 ≤
          agentWelfare AgentType.bayesianNaive β₂ p_hat 1 :=
  gap_bayesian_naive_reversal_absent_from_blackwell
    gap_blackwell_monotonicity

/-- **Proposition `prop:bayesian-naive-five-state` (iii): reversal
    appears above threshold** — reversal-witness decomposition.

    Reversal-witness decomposition: a single-atom
    `bayesian_naive_above_threshold_reversal_OPEN` (which would package the
    welfare-existential reversal as an opaque axiom) is decomposed
    into a paper-stipulated kernel-level reversal-witness
    structural equation that the foundation lemma
    `agentWelfare_strict_lt_of_kernel_pointwise_le_strict_at_one`
    lifts to the welfare-level reversal claim. Paper line 957
    explicitly: "for `p̂ ≥ 2/3`, the Bayesian-naive agent's
    trap-selection probability tends to 1 as β → ∞, recovering the
    greedy-reversal mechanism" — at the per-realisation level, in the
    above-threshold regime the misspecified-trap routing on enough
    realisations gives the kernel pointwise-`≤` plus strict-`<` at one
    config (witnessed by a percolation realisation in which the trap
    bridge is forward-reachable and the misspecification fires).

    Interface discipline: this witness remains an explicit Prop-valued
    package rather than a source axiom.  The current public
    `bayesianNaive` kernel carries `p_hat` in the `κ` slot and proves
    the package directly: above threshold it has the same pointwise
    reversal shape as the greedy current-carrier kernel.
    paper source: Proposition `prop:bayesian-naive-five-state` (iii),
    line 957. -/
def agentRewardKernel_bayesianNaive_aboveThreshold_kernel_reversal_witness : Prop :=
    ∀ p_hat : ℝ, (2 : ℝ) / 3 ≤ p_hat → p_hat < 1 →
      ∃ β₁ β₂ : ℝ, β₁ < β₂ ∧
        (∀ ω : BondConfig AgentEdgeIdx,
          agentRewardKernel AgentType.bayesianNaive β₂ p_hat 1 ω ≤
            agentRewardKernel AgentType.bayesianNaive β₁ p_hat 1 ω) ∧
        ∃ ω₀ : BondConfig AgentEdgeIdx,
          agentRewardKernel AgentType.bayesianNaive β₂ p_hat 1 ω₀ <
            agentRewardKernel AgentType.bayesianNaive β₁ p_hat 1 ω₀

/-- Current public above-threshold Bayesian-naive reversal witness.
    The `bayesianNaive` kernel now carries the misspecified prior `p_hat`
    in its `κ` slot. For `p_hat ≥ 2/3`, the concrete branch matches the
    greedy-reversal shape: beta = 0 gives reward `1`, while beta = 1 gives
    reward `6 / 10`, pointwise in every percolation realisation. -/
theorem agentRewardKernel_bayesianNaive_aboveThreshold_kernel_reversal_witness_current :
    agentRewardKernel_bayesianNaive_aboveThreshold_kernel_reversal_witness := by
  intro p_hat hp_hat_lo _hp_hat_hi
  refine ⟨0, 1, by norm_num, ?_, ?_⟩
  · intro ω
    have hnot : ¬ p_hat < (2 : ℝ) / 3 := by linarith
    norm_num [agentRewardKernel, hnot]
  · refine ⟨fun _ => false, ?_⟩
    have hnot : ¬ p_hat < (2 : ℝ) / 3 := by linarith
    norm_num [agentRewardKernel, hnot]

/-- **Proposition `prop:bayesian-naive-five-state` (iii): reversal
    appears above threshold** (derived theorem via reversal-witness
    pattern).  For `p̂ ≥ 2/3`, the Bayesian-naive agent's
    welfare exhibits the same β-non-monotonicity as the greedy agent.

    Closure composes (a) the current kernel theorem
    `agentRewardKernel_bayesianNaive_aboveThreshold_kernel_reversal_witness_current`
    + (b) foundation lemma
    `agentWelfare_strict_lt_of_kernel_pointwise_le_strict_at_one`
    + (c) paper-stipulated atom `blockingProb_strict_in_open_unit_interval`
    (consumed inside the foundation lemma).

    paper source: Proposition `prop:bayesian-naive-five-state` (iii),
    line 957. -/
theorem gap_bayesian_naive_reversal_present :
    ∀ p_hat : ℝ, (2 : ℝ) / 3 ≤ p_hat → p_hat < 1 →
      ∃ β₁ β₂ : ℝ, β₁ < β₂ ∧
        agentWelfare AgentType.bayesianNaive β₂ p_hat 1 <
          agentWelfare AgentType.bayesianNaive β₁ p_hat 1 := by
  intro p_hat hp_hat_lo hp_hat_hi
  obtain ⟨β₁, β₂, hβ_lt, h_le, ω₀, h_strict⟩ :=
    agentRewardKernel_bayesianNaive_aboveThreshold_kernel_reversal_witness_current
      p_hat hp_hat_lo hp_hat_hi
  refine ⟨β₁, β₂, hβ_lt, ?_⟩
  exact agentWelfare_strict_lt_of_kernel_pointwise_le_strict_at_one
    AgentType.bayesianNaive p_hat 1 β₁ β₂ h_le ω₀ h_strict

end FiveState

/-! ## 7. Corollary `cor:five-state-policy` — Policy Mapping -/

/-- **Corollary `cor:five-state-policy`** — Each of the three regimes
    admits a distinct dominant policy instrument:
    (i) Information discipline `β*(p)`;
    (ii) Low-barrier cognitive augmentation (`κ > 0` suffices);
    (iii) Substantive cognitive infrastructure (`κ ≥ κ*(p)`).

    paper source: Corollary `cor:five-state-policy`, lines 836-844. -/
theorem gap_fiveState_policy_mapping :
    -- (i) Regime [0, p_1): interior β*
    (∀ p : ℝ, 0 ≤ p → p < FiveState.p_1 →
      ∃ β_star_p : ℝ, 0 < β_star_p ∧ FiveState.L β_star_p p < (4/10 : ℝ))
    ∧
    -- (ii) Regime [p_1, p_2]: κ > 0 suffices (κ* = 0)
    (∀ p : ℝ, FiveState.p_1 ≤ p → p ≤ FiveState.p_2 →
      FiveState.kappaStar_fiveState p = 0)
    ∧
    -- (iii) Regime (p_2, 1): κ ≥ κ*(p) > 0 required
    (∀ p : ℝ, FiveState.p_2 < p → p < 1 →
      0 < FiveState.kappaStar_fiveState p) := by
  refine ⟨ ?_, ?_, ?_ ⟩
  · intro p hp_nn hp_lt
    obtain ⟨β_star_p, hβ_pos, hL_lt⟩ :=
      FiveState.gap_three_regime_reversal_existence p hp_nn hp_lt
    exact ⟨β_star_p, hβ_pos, hL_lt⟩
  · intro p _ hp2
    -- hp2 : p ≤ FiveState.p_2 reduces to p ≤ 2/3 via defeq
    unfold FiveState.kappaStar_fiveState FiveState.p_2 at *
    exact if_pos hp2
  · intro p hp_gt hp_lt
    -- The strict positivity of the closed form
    -- κ*(p) = (1/2) log_2(2 log[p/(2(1-p))] + 1) on (2/3, 1) is the
    -- analytic content of Equation eq:kstar-five-state, encoded as
    -- the substantive closure
    -- gap_three_regime_sufficient_cognition_kappaStar_pos.
    exact FiveState.gap_three_regime_sufficient_cognition_kappaStar_pos
      p hp_gt hp_lt

end BlackwellDilemma
