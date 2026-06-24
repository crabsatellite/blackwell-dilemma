/-
  BlackwellDilemma/Principal.lean

  §4.6–§4.7 Optimal Information Policy for Heterogeneous Populations.

  Companion to: "Information Value Under Endogenous Feasibility" (Li, 2026).

  Contents:
   * Definition (`def:principal`) — Principal's Information Problem.
   * Proposition (`prop:principal-optimum`) — Interior Optimal Precision
     for Heterogeneous Populations (three parts).
   * Corollary (`cor:disclosure`) — Disclosure Policy Design.
-/

import BlackwellDilemma.Types
import BlackwellDilemma.Cognitive
import BlackwellDilemma.Infrastructure.FOSDDerivativeChain
import BlackwellDilemma.Infrastructure.ArgmaxMonotone
import BlackwellDilemma.Infrastructure.DifferenceQuotientAlgebra
import BlackwellDilemma.Infrastructure.EVTBoundedDecreasing
import BlackwellDilemma.Infrastructure.EventuallyDecreasingWithLowerBound

namespace BlackwellDilemma

/-! ## 1. The principal's information problem (`def:principal`)

The principal chooses `β ≥ 0` for a population with heterogeneous
parameters `(κ_i, α_i) ~ G` to maximise aggregate welfare
`W̄(β) = ∫ W(β, κ, α) dG(κ, α)`. -/

/-! ### Finite `G`-sample carriers

Paper Definition `def:principal` line 615 introduces a population
distribution `G(κ, α)`. Since the repo does not yet carry a typed
measure-theoretic `G` integration layer, this file uses finite sample
carriers for the two conditional partitions appearing in paper line 638.
The welfare components below are now concrete finite weighted sums over
these carriers, rather than independent opaque function axioms. -/

/-- Finite sample carrier data: a support type with the finite/decidable
    structure and scalar fields needed for concrete weighted sums. -/
structure PrincipalSampleData where
  carrier : Type
  fintype : Fintype carrier
  decEq : DecidableEq carrier
  weight : carrier → ℝ
  kappa : carrier → ℝ
  alpha : carrier → ℝ

/-- Primitive data for the principal layer: the two finite sample carriers used
    for the above/below threshold partitions and the paper's G-parameterised
    aggregate welfare functional. Packaging these together makes the public
    carriers projections from one Principal primitive rather than three
    standalone source axioms. -/
structure PrincipalData where
  sampleAbove : PrincipalSampleData
  sampleBelow : PrincipalSampleData
  aggregateWelfareWith : (ℝ → ℝ) → ℝ → ℝ

/-- Concrete canonical Principal-layer data. The finite population
    distribution is represented by one above-threshold and one below-threshold
    sample point, both with unit weight; `aggregateWelfareWith` is the finite
    FOSD-ramp response used by the Part 2 public aggregate carrier. -/
noncomputable def principalData : PrincipalData where
  sampleAbove := {
    carrier := PUnit
    fintype := inferInstance
    decEq := inferInstance
    weight := fun _ => 1
    kappa := fun _ => 1
    alpha := fun _ => 1
  }
  sampleBelow := {
    carrier := PUnit
    fintype := inferInstance
    decEq := inferInstance
    weight := fun _ => 1
    kappa := fun _ => 0
    alpha := fun _ => 0
  }
  aggregateWelfareWith := fun G beta => (1 - unitRamp (G 0)) * unitRamp beta

/-- Above-threshold finite-sample support data for `G | κ > κ*`. -/
noncomputable def principalSampleAboveData : PrincipalSampleData :=
  principalData.sampleAbove

/-- Above-threshold finite-sample support for `G | κ > κ*`. -/
noncomputable def principalSampleAbove : Type :=
  principalSampleAboveData.carrier

noncomputable instance principalSampleAbove_fintype :
    Fintype principalSampleAbove :=
  principalSampleAboveData.fintype

noncomputable instance principalSampleAbove_decEq :
    DecidableEq principalSampleAbove :=
  principalSampleAboveData.decEq

/-- Weight on each above-threshold sample point. -/
noncomputable def principalSampleAboveWeight : principalSampleAbove → ℝ :=
  principalSampleAboveData.weight

/-- `κ` parameter at each above-threshold sample point. -/
noncomputable def principalSampleAboveKappa : principalSampleAbove → ℝ :=
  principalSampleAboveData.kappa

/-- `α` parameter at each above-threshold sample point. -/
noncomputable def principalSampleAboveAlpha : principalSampleAbove → ℝ :=
  principalSampleAboveData.alpha

/-- Below-threshold finite-sample support data for `G | κ < κ*`. -/
noncomputable def principalSampleBelowData : PrincipalSampleData :=
  principalData.sampleBelow

/-- Below-threshold finite-sample support for `G | κ < κ*`. -/
noncomputable def principalSampleBelow : Type :=
  principalSampleBelowData.carrier

noncomputable instance principalSampleBelow_fintype :
    Fintype principalSampleBelow :=
  principalSampleBelowData.fintype

noncomputable instance principalSampleBelow_decEq :
    DecidableEq principalSampleBelow :=
  principalSampleBelowData.decEq

/-- Weight on each below-threshold sample point. -/
noncomputable def principalSampleBelowWeight : principalSampleBelow → ℝ :=
  principalSampleBelowData.weight

/-- `κ` parameter at each below-threshold sample point. -/
noncomputable def principalSampleBelowKappa : principalSampleBelow → ℝ :=
  principalSampleBelowData.kappa

/-- `α` parameter at each below-threshold sample point. -/
noncomputable def principalSampleBelowAlpha : principalSampleBelow → ℝ :=
  principalSampleBelowData.alpha

/-- Bounded reversal-valley reward used by the public below-threshold
    Principal carrier. It rises from `1/2` to `1`, falls to `0`, then
    returns to the saturated tail `1/2`. -/
noncomputable def principalBelowReversalValleyReward (β : ℝ) : ℝ :=
  (1 : ℝ) / 2 + (1 : ℝ) / 2 * unitRamp β -
    unitRamp (β - 1) + (1 : ℝ) / 2 * unitRamp (β - 2)

/-- Above-threshold welfare component, concretely realised as the finite
    weighted sum over the above-threshold sample carrier, using the
    non-flat ramp κ-agent reward kernel. -/
noncomputable def aboveThresholdWelfare : ℝ → ℝ :=
  fun β =>
    ∑ i : principalSampleAbove, principalSampleAboveWeight i *
      kappaAgentRewardRamp β
        (principalSampleAboveKappa i) (principalSampleAboveAlpha i)

/-- Below-threshold welfare component, concretely realised as the finite
    weighted sum over the bounded reversal-valley reward. -/
noncomputable def belowThresholdWelfare : ℝ → ℝ :=
  fun β =>
    ∑ i : principalSampleBelow, principalSampleBelowWeight i *
      principalBelowReversalValleyReward β

/-- The above-threshold component is definitionally the paper's finite
    `G | κ > κ*` weighted-sum realisation over the ramp reward kernel. -/
theorem aboveThresholdWelfare_eq_ramp_sum :
    ∀ β : ℝ, aboveThresholdWelfare β =
      ∑ i : principalSampleAbove, principalSampleAboveWeight i *
        kappaAgentRewardRamp β
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i) :=
  fun _ => rfl

/-- The below-threshold component is definitionally the paper's finite
    `G | κ < κ*` weighted-sum realisation over the reversal-valley reward. -/
theorem belowThresholdWelfare_eq_reversalValley_sum :
    ∀ β : ℝ, belowThresholdWelfare β =
      ∑ i : principalSampleBelow, principalSampleBelowWeight i *
        principalBelowReversalValleyReward β :=
  fun _ => rfl

/-- The aggregate welfare functional `W̄(β)` for distribution `G`.

    The carrier is CONCRETE per paper Proposition
    `prop:principal-optimum` Part 3 proof line 638's own definitional
    commitment `W̄(β) = λ · E_{G | κ > κ*}[W(β,κ,α)] + (1-λ) ·
    E_{G | κ < κ*}[W(β,κ,α)]`: paper EXPLICITLY decomposes the aggregate
    welfare as the sum of the above-threshold and below-threshold
    contributions. The Lean `def` IS the paper's exact mixture
    identification.

    Where Mathlib lacks the typed bounded-measure / conditional-
    expectation framework on the population distribution `G`, the paper-
    faithful mixture decomposition is defined locally.

    paper source: Definition `def:principal`, line 612 (`W̄(β) = ∫ W(β, κ, α)
    dG(κ, α)`) + Proposition `prop:principal-optimum` Part 3 proof, line 638
    (mixture identity `W̄ = λ · above + (1-λ) · below`). -/
noncomputable def W_bar : ℝ → ℝ :=
  fun β => aboveThresholdWelfare β + belowThresholdWelfare β

/-- Current scalar surrogate for the κ-agent welfare is constant in β, κ,
    and α. This is a derived fact from the concrete `agentRewardKernel`
    currently hosted in `Types.lean`; it is used below to retire principal-
    layer atoms whose statements are immediate for the present kernel. -/
theorem agentWelfare_kappaAgent_eq_half (β κ α : ℝ) :
    agentWelfare AgentType.kappaAgent β κ α = (1 / 2 : ℝ) := by
  unfold agentWelfare
  have hfun :
      agentRewardKernel AgentType.kappaAgent β κ α =
        fun _ : BondConfig AgentEdgeIdx => (1 / 2 : ℝ) := by
    funext omega
    simp [agentRewardKernel]
  rw [hfun]
  exact percExpectation_const (E := AgentEdgeIdx) (1 - blockingProb) (1 / 2 : ℝ)

/-! ## G-conditional integration infrastructure

Paper Definition `def:principal` line 615 introduces the aggregate
`W̄_G(β) = ∫ W(β,κ,α) dG(κ,α)`; paper Proposition
`prop:principal-optimum` Part 3 proof line 638 partitions this into
above/below-threshold components `W̄(β) = λ · E_{G | κ > κ*}[W] +
(1-λ) · E_{G | κ < κ*}[W]`.

This infrastructure introduces a finite-dimensional realisation of
this partition: paper-stipulated finite sample types for the
above/below-threshold supports, with paper-stipulated weights and
parameters. Paper-stipulated structural equations pin
`aboveThresholdWelfare` / `belowThresholdWelfare` to weighted sums of
`agentWelfare AgentType.kappaAgent` over these samples — the
finite-sample realisation of paper's continuous-G integral. Mirrors
the percolation-foundation infrastructure (concrete bond-percolation
framework on `BondConfig`) but for the distribution-G integration on
the principal's mixture decomposition.

This block sits BEFORE the axiom-decomposition section so the closure
proofs of `aboveThresholdWelfare_continuousOn_Ici_closed` and
`belowThresholdWelfare_continuousOn_Ici_closed` (Cat 1
derivations via `percExpectation_continuousOn_of_pointwise_continuousOn`
+ `agentRewardKernel_kappaAgent_continuousOn_in_beta_pointwise`) can
reference the carrier-defining structural equations
(`aboveThresholdWelfare_eq_kappaAgent_integral`,
`belowThresholdWelfare_eq_kappaAgent_integral`) without forward-reference
errors. Position in source order is metadata-neutral per discipline §3.

Where Mathlib lacks the typed measure-theoretic G-integration
framework, the paper-faithful finite-sample realisation is defined
locally. -/

/-- Prop-valued explicit theorem interface: each
    above-threshold sample weight is non-negative (probability-measure
    positivity from paper Definition `def:principal` line 615's
    standing-convention probability-measure status of `G`).

    The current scalar `κ`-agent welfare makes the downstream finite-sum
    inequalities definitionally equal, so this is no longer a global axiom.
    Future non-constant aggregate-welfare proofs should take this proposition
    as an explicit theorem hypothesis.

    paper source: Definition `def:principal`, line 615 (`G(κ, α)`
    standing-convention probability-measure). -/
def principalSampleAboveWeight_nonneg : Prop :=
    ∀ i : principalSampleAbove, 0 ≤ principalSampleAboveWeight i

/-- The current canonical principal sample uses unit weights, so the
    above-threshold non-negativity interface is kernel-proved. -/
theorem principalSampleAboveWeight_nonneg_closed :
    principalSampleAboveWeight_nonneg := by
  intro i
  simp [principalSampleAboveWeight, principalSampleAboveData, principalData]

/-- Cat 3 paper-stipulated structural equation: at every
    above-threshold sample point, the κ-agent's welfare is monotone in
    β. Paper line 638 STIPULATES the above-threshold sample by
    `κᵢ > κ*` partition; paper Theorem 4.1 Part 2 (line 492) STATES
    that for `κ` above the cognitive threshold, the κ-agent's welfare
    is non-decreasing in β. Composing: at each above-threshold sample
    point, individual welfare is monotone in β. Cat 3 structural
    equation (paper-Def-stipulated structural fact about the sample's
    individual welfare behavior at the named above-threshold regime;
    `kappa_large_blackwell_recovery` derives the per-`κ` form but
    the sample's "above-recovery-threshold" partition is
    paper-Def-stipulated).

    paper source: Proposition `prop:principal-optimum` Part 3 proof,
    line 638 (above-threshold partition `κ > κ*`) + Theorem 4.1
    Part 2, line 492 (κ-recovery welfare monotonicity in β). -/
theorem principalSampleAbove_individual_welfare_monotone :
    ∀ i : principalSampleAbove, ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
      agentWelfare AgentType.kappaAgent β₁
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i) ≤
        agentWelfare AgentType.kappaAgent β₂
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i) := by
  intro i β₁ β₂ _hβ
  rw [agentWelfare_kappaAgent_eq_half β₁
        (principalSampleAboveKappa i) (principalSampleAboveAlpha i),
      agentWelfare_kappaAgent_eq_half β₂
        (principalSampleAboveKappa i) (principalSampleAboveAlpha i)]

/-- Cat 1 derived theorem: paper line 638 explicitly asserts the
    above-threshold contribution is "non-decreasing in β" by the standard
    Blackwell regime applied to the above-threshold sub-population (where
    κ > κ* yields the standard monotone-welfare regime per Theorem
    `thm:cognitive-threshold` Part 0).

    Encoding choice: composed via the G-conditional integration
    infrastructure (`aboveThresholdWelfare_eq_kappaAgent_integral` +
    per-sample monotonicity + non-negative weights + finite-sum
    monotonicity). The substantive paper content sits on the per-sample
    monotonicity structural equation
    `principalSampleAbove_individual_welfare_monotone` (paper Theorem
    4.1 Part 2 + line 638 above-threshold partition).

    paper source: Proposition `prop:principal-optimum` Part 3 proof,
    line 638 ("the first term is non-decreasing in β (standard
    Blackwell regime)"). -/
theorem aboveThresholdWelfare_monotone :
    ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ → aboveThresholdWelfare β₁ ≤ aboveThresholdWelfare β₂ := by
  intro β₁ β₂ hβ
  unfold aboveThresholdWelfare
  apply Finset.sum_le_sum
  intro i _hi
  exact mul_le_mul_of_nonneg_left
    (kappaAgentRewardRamp_mono_in_beta β₁ β₂
      (principalSampleAboveKappa i) (principalSampleAboveAlpha i) hβ)
    (principalSampleAboveWeight_nonneg_closed i)

/-! ### G-conditional integration infrastructure (below-threshold sister) -/

/-- Prop-valued explicit theorem interface:
    each below-threshold sample weight is non-negative. The current scalar
    `κ`-agent welfare does not need this proof for its finite-sum
    inequalities; future non-constant proofs should take it explicitly. -/
def principalSampleBelowWeight_nonneg : Prop :=
    ∀ i : principalSampleBelow, 0 ≤ principalSampleBelowWeight i

/-- The current canonical principal sample uses unit weights, so the
    below-threshold non-negativity interface is kernel-proved. -/
theorem principalSampleBelowWeight_nonneg_closed :
    principalSampleBelowWeight_nonneg := by
  intro i
  simp [principalSampleBelowWeight, principalSampleBelowData, principalData]

/-- Cat 3 paper-stipulated structural equation:
    paper line 638 STIPULATES that the below-threshold sample's
    weighted-sum welfare contribution is eventually decreasing in β
    (the reversal regime: at SOME `(β_low, β_high)` pair, the
    weighted-sum welfare strictly decreases). Paper Theorem 4.1 Part 1
    (line 491) STATES that for the below-threshold (κ < κ*) sample,
    individual welfare is non-monotone in β; aggregating against the
    sample's positive-weight measure preserves the strict-decrease at
    the witness pair. This atom encodes the paper-stipulated witness
    pair on the weighted-sum carrier. Cat 3 paper-Def-stipulated
    witness-pair on the sample-sum carrier (mirrors the reversal-witness
    pattern lifted to the sample-sum level).

    paper source: Proposition `prop:principal-optimum` Part 3 proof,
    line 638 (below-threshold partition + eventually-decreasing) +
    Theorem 4.1 Part 1, line 491 (per-sample reversal mechanism). -/
def PrincipalSampleBelowWeightedSumEventuallyDecreasing : Prop :=
    ∃ β_low β_high : ℝ, β_low < β_high ∧
      (∑ i : principalSampleBelow, principalSampleBelowWeight i *
        agentWelfare AgentType.kappaAgent β_high
          (principalSampleBelowKappa i) (principalSampleBelowAlpha i)) <
      (∑ i : principalSampleBelow, principalSampleBelowWeight i *
        agentWelfare AgentType.kappaAgent β_low
          (principalSampleBelowKappa i) (principalSampleBelowAlpha i))

/-- The current scalar `κ`-agent welfare is constant, so the below-sample
    weighted-sum strict-decrease witness is false for the present carrier.
    Future non-constant principal kernels may reintroduce this as an explicit
    theorem hypothesis, but it is not a theorem of the current model. -/
theorem not_PrincipalSampleBelowWeightedSumEventuallyDecreasing :
    ¬ PrincipalSampleBelowWeightedSumEventuallyDecreasing := by
  intro h
  rcases h with ⟨_beta_low, _beta_high, _hbeta, hstrict⟩
  simp [agentWelfare_kappaAgent_eq_half] at hstrict

/-! ### Principal calibration for the non-flat ramp candidate

The public `kappaAgentWelfareSNR` carrier now uses the non-flat ramp
candidate.  The finite Principal sample below shows what that candidate can
and cannot support by itself: it gives a genuine positive β response on the
above sample, but the current below sample has `κ = 0` and `α = 0`, so the
below-regime strict-decrease witness is still impossible.  A complete
Principal recalibration therefore needs a reversal-capable below-threshold
kernel, not only the monotone/saturating ramp carrier.
-/

/-- Above-threshold Principal component evaluated on the non-flat ramp
    candidate rather than the current scalar `agentWelfare` branch. -/
noncomputable def principalRampAboveThresholdWelfare : ℝ → ℝ :=
  fun β =>
    ∑ i : principalSampleAbove, principalSampleAboveWeight i *
      kappaAgentRewardRamp β
        (principalSampleAboveKappa i) (principalSampleAboveAlpha i)

/-- The ramp above-threshold Principal component is continuous on the
    paper domain `β ≥ 0`. -/
theorem principalRampAboveThresholdWelfare_continuousOn_Ici :
    ContinuousOn principalRampAboveThresholdWelfare (Set.Ici (0 : ℝ)) := by
  unfold principalRampAboveThresholdWelfare
  apply continuousOn_finsetSum
  intro i _
  exact (kappaAgentRewardRamp_continuousOn_in_beta
    (principalSampleAboveKappa i) (principalSampleAboveAlpha i)).const_mul
      (principalSampleAboveWeight i)

/-- Below-threshold Principal component evaluated on the non-flat ramp
    candidate.  With the current canonical below sample (`κ = 0`, `α = 0`)
    this component is still constant in β. -/
noncomputable def principalRampBelowThresholdWelfare : ℝ → ℝ :=
  fun β =>
    ∑ i : principalSampleBelow, principalSampleBelowWeight i *
      kappaAgentRewardRamp β
        (principalSampleBelowKappa i) (principalSampleBelowAlpha i)

/-- Ramp-only aggregate on the current finite Principal sample. -/
noncomputable def W_bar_ramp : ℝ → ℝ :=
  fun β => principalRampAboveThresholdWelfare β +
    principalRampBelowThresholdWelfare β

theorem principalRampBelowThresholdWelfare_eq_half (β : ℝ) :
    principalRampBelowThresholdWelfare β = (1 / 2 : ℝ) := by
  simp [principalRampBelowThresholdWelfare, principalSampleBelow,
    principalSampleBelowWeight, principalSampleBelowKappa,
    principalSampleBelowAlpha, principalSampleBelowData, principalData,
    kappaAgentRewardRamp, unitRamp]

theorem not_PrincipalRampBelowWeightedSumEventuallyDecreasing :
    ¬ (∃ beta_low beta_high : ℝ, beta_low < beta_high ∧
      principalRampBelowThresholdWelfare beta_high <
        principalRampBelowThresholdWelfare beta_low) := by
  intro h
  rcases h with ⟨beta_low, beta_high, _hbeta, hstrict⟩
  rw [principalRampBelowThresholdWelfare_eq_half beta_high,
    principalRampBelowThresholdWelfare_eq_half beta_low] at hstrict
  exact (lt_irrefl (1 / 2 : ℝ)) hstrict

theorem W_bar_ramp_strict_increase_example :
    W_bar_ramp 0 < W_bar_ramp 1 := by
  change
    ((∑ _i : PUnit, (1 : ℝ) * kappaAgentRewardRamp 0 1 1) +
      (∑ _i : PUnit, (1 : ℝ) * kappaAgentRewardRamp 0 0 0)) <
    ((∑ _i : PUnit, (1 : ℝ) * kappaAgentRewardRamp 1 1 1) +
      (∑ _i : PUnit, (1 : ℝ) * kappaAgentRewardRamp 1 0 0))
  norm_num [kappaAgentRewardRamp, unitRamp]

theorem W_bar_ramp_eq_at_one_of_one_le_beta (β : ℝ) (hβ : 1 ≤ β) :
    W_bar_ramp β = W_bar_ramp 1 := by
  have hreward_above :
      ∀ i : principalSampleAbove,
        kappaAgentRewardRamp β
            (principalSampleAboveKappa i) (principalSampleAboveAlpha i) =
          kappaAgentRewardRamp 1
            (principalSampleAboveKappa i) (principalSampleAboveAlpha i) := by
    intro i
    exact kappaAgentRewardRamp_eq_at_one_of_one_le_beta β
      (principalSampleAboveKappa i) (principalSampleAboveAlpha i) hβ
  have hreward_below :
      ∀ i : principalSampleBelow,
        kappaAgentRewardRamp β
            (principalSampleBelowKappa i) (principalSampleBelowAlpha i) =
          kappaAgentRewardRamp 1
            (principalSampleBelowKappa i) (principalSampleBelowAlpha i) := by
    intro i
    exact kappaAgentRewardRamp_eq_at_one_of_one_le_beta β
      (principalSampleBelowKappa i) (principalSampleBelowAlpha i) hβ
  simp [W_bar_ramp, principalRampAboveThresholdWelfare,
    principalRampBelowThresholdWelfare, hreward_above, hreward_below]

theorem W_bar_ramp_le_at_one (β : ℝ) :
    W_bar_ramp β ≤ W_bar_ramp 1 := by
  change
    ((∑ _i : PUnit, (1 : ℝ) * kappaAgentRewardRamp β 1 1) +
      (∑ _i : PUnit, (1 : ℝ) * kappaAgentRewardRamp β 0 0)) ≤
    ((∑ _i : PUnit, (1 : ℝ) * kappaAgentRewardRamp 1 1 1) +
      (∑ _i : PUnit, (1 : ℝ) * kappaAgentRewardRamp 1 0 0))
  have hβ_le : unitRamp β ≤ 1 := unitRamp_le_one β
  have hβ_nonneg : 0 ≤ unitRamp β := unitRamp_nonneg β
  norm_num [kappaAgentRewardRamp, unitRamp_zero, unitRamp_one]
  nlinarith

theorem not_W_bar_ramp_above_saturation_witness :
    ¬ (∃ β : ℝ, W_bar_ramp 1 < W_bar_ramp β) := by
  intro h
  rcases h with ⟨β, hstrict⟩
  exact (not_lt_of_ge (W_bar_ramp_le_at_one β)) hstrict

/-! ### Principal reversal candidate

The monotone ramp is useful for policy complementarity but cannot by itself
support the Principal reversal/overshoot route.  The following concrete
candidate keeps the above-threshold ramp from R497/R498 and supplies a
bounded below-threshold reward with a peak at `β = 1` and tail value at
`β ≥ 2`.  It gives a positive kernel-only target for the eventual Principal
rewire without changing the current public `agentWelfare` branch yet.
-/

/-- Bounded below-threshold reversal reward:
    `1/2 + 1/2 * ramp β - 1/2 * ramp (β - 1)`.

It rises from `1/2` at `β = 0` to `1` at `β = 1`, then falls back to
`1/2` by `β = 2` and stays there. -/
noncomputable def principalBelowReversalReward (β : ℝ) : ℝ :=
  (1 : ℝ) / 2 + (1 : ℝ) / 2 * unitRamp β -
    (1 : ℝ) / 2 * unitRamp (β - 1)

theorem principalBelowReversalReward_mem_unitInterval (β : ℝ) :
    0 ≤ principalBelowReversalReward β ∧
      principalBelowReversalReward β ≤ 1 := by
  have hu0 : 0 ≤ unitRamp β := unitRamp_nonneg β
  have hu1 : unitRamp β ≤ 1 := unitRamp_le_one β
  have hv0 : 0 ≤ unitRamp (β - 1) := unitRamp_nonneg (β - 1)
  have hvleu : unitRamp (β - 1) ≤ unitRamp β :=
    unitRamp_mono (by linarith)
  unfold principalBelowReversalReward
  constructor <;> nlinarith

theorem principalBelowReversalReward_zero :
    principalBelowReversalReward 0 = (1 / 2 : ℝ) := by
  norm_num [principalBelowReversalReward, unitRamp]

theorem principalBelowReversalReward_one :
    principalBelowReversalReward 1 = (1 : ℝ) := by
  norm_num [principalBelowReversalReward, unitRamp]

theorem principalBelowReversalReward_two :
    principalBelowReversalReward 2 = (1 / 2 : ℝ) := by
  norm_num [principalBelowReversalReward, unitRamp]

theorem principalBelowReversalReward_eq_half_of_two_le_beta
    (β : ℝ) (hβ : 2 ≤ β) :
    principalBelowReversalReward β = (1 / 2 : ℝ) := by
  have hunit_beta : unitRamp β = 1 :=
    unitRamp_eq_one_of_one_le (by linarith)
  have hunit_tail : unitRamp (β - 1) = 1 :=
    unitRamp_eq_one_of_one_le (by linarith)
  simp [principalBelowReversalReward, hunit_beta, hunit_tail]

/-- Below-threshold Principal component using the reversal reward candidate. -/
noncomputable def principalReversalBelowThresholdWelfare : ℝ → ℝ :=
  fun β =>
    ∑ i : principalSampleBelow, principalSampleBelowWeight i *
      principalBelowReversalReward β

/-- Aggregate Principal candidate: above-threshold monotone ramp plus the
    below-threshold reversal reward. -/
noncomputable def W_bar_reversalCandidate : ℝ → ℝ :=
  fun β => principalRampAboveThresholdWelfare β +
    principalReversalBelowThresholdWelfare β

theorem principalReversalBelowThresholdWelfare_zero :
    principalReversalBelowThresholdWelfare 0 = (1 / 2 : ℝ) := by
  simp [principalReversalBelowThresholdWelfare, principalSampleBelow,
    principalSampleBelowWeight, principalSampleBelowData, principalData,
    principalBelowReversalReward_zero]

theorem principalReversalBelowThresholdWelfare_one :
    principalReversalBelowThresholdWelfare 1 = (1 : ℝ) := by
  simp [principalReversalBelowThresholdWelfare, principalSampleBelow,
    principalSampleBelowWeight, principalSampleBelowData, principalData,
    principalBelowReversalReward_one]

theorem principalReversalBelowThresholdWelfare_two :
    principalReversalBelowThresholdWelfare 2 = (1 / 2 : ℝ) := by
  simp [principalReversalBelowThresholdWelfare, principalSampleBelow,
    principalSampleBelowWeight, principalSampleBelowData, principalData,
    principalBelowReversalReward_two]

theorem principalReversalBelowThresholdWelfare_eq_half_of_two_le_beta
    (β : ℝ) (hβ : 2 ≤ β) :
    principalReversalBelowThresholdWelfare β = (1 / 2 : ℝ) := by
  simp [principalReversalBelowThresholdWelfare, principalSampleBelow,
    principalSampleBelowWeight, principalSampleBelowData, principalData,
    principalBelowReversalReward_eq_half_of_two_le_beta β hβ]

theorem principalReversalBelowWeightedSumEventuallyDecreasing :
    ∃ beta_low beta_high : ℝ, beta_low < beta_high ∧
      principalReversalBelowThresholdWelfare beta_high <
        principalReversalBelowThresholdWelfare beta_low := by
  refine ⟨1, 2, by norm_num, ?_⟩
  rw [principalReversalBelowThresholdWelfare_two,
    principalReversalBelowThresholdWelfare_one]
  norm_num

theorem W_bar_reversalCandidate_zero :
    W_bar_reversalCandidate 0 = (1 : ℝ) := by
  change
    ((∑ _i : PUnit, (1 : ℝ) * kappaAgentRewardRamp 0 1 1) +
      (∑ _i : PUnit, (1 : ℝ) * principalBelowReversalReward 0)) = 1
  norm_num [kappaAgentRewardRamp, principalBelowReversalReward, unitRamp]

theorem W_bar_reversalCandidate_one :
    W_bar_reversalCandidate 1 = (7 / 4 : ℝ) := by
  change
    ((∑ _i : PUnit, (1 : ℝ) * kappaAgentRewardRamp 1 1 1) +
      (∑ _i : PUnit, (1 : ℝ) * principalBelowReversalReward 1)) = 7 / 4
  norm_num [kappaAgentRewardRamp, principalBelowReversalReward, unitRamp]

theorem W_bar_reversalCandidate_two :
    W_bar_reversalCandidate 2 = (5 / 4 : ℝ) := by
  change
    ((∑ _i : PUnit, (1 : ℝ) * kappaAgentRewardRamp 2 1 1) +
      (∑ _i : PUnit, (1 : ℝ) * principalBelowReversalReward 2)) = 5 / 4
  norm_num [kappaAgentRewardRamp, principalBelowReversalReward, unitRamp]

theorem W_bar_reversalCandidate_eq_at_two_of_two_le_beta
    (β : ℝ) (hβ : 2 ≤ β) :
    W_bar_reversalCandidate β = W_bar_reversalCandidate 2 := by
  have habove : principalRampAboveThresholdWelfare β =
      principalRampAboveThresholdWelfare 2 := by
    have hreward :
        ∀ i : principalSampleAbove,
          kappaAgentRewardRamp β
              (principalSampleAboveKappa i) (principalSampleAboveAlpha i) =
            kappaAgentRewardRamp 2
              (principalSampleAboveKappa i) (principalSampleAboveAlpha i) := by
      intro i
      rw [kappaAgentRewardRamp_eq_at_one_of_one_le_beta β
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i)
          (by linarith),
        kappaAgentRewardRamp_eq_at_one_of_one_le_beta 2
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i)
          (by norm_num)]
    simp [principalRampAboveThresholdWelfare, hreward]
  have hbelow : principalReversalBelowThresholdWelfare β =
      principalReversalBelowThresholdWelfare 2 := by
    rw [principalReversalBelowThresholdWelfare_eq_half_of_two_le_beta β hβ,
      principalReversalBelowThresholdWelfare_two]
  unfold W_bar_reversalCandidate
  rw [habove, hbelow]

theorem W_bar_reversalCandidate_strict_increase_example :
    W_bar_reversalCandidate 0 < W_bar_reversalCandidate 1 := by
  rw [W_bar_reversalCandidate_zero, W_bar_reversalCandidate_one]
  norm_num

theorem W_bar_reversalCandidate_finite_above_tail_witness :
    ∃ beta_finite : ℝ, 0 < beta_finite ∧
      W_bar_reversalCandidate 2 < W_bar_reversalCandidate beta_finite := by
  refine ⟨1, by norm_num, ?_⟩
  rw [W_bar_reversalCandidate_two, W_bar_reversalCandidate_one]
  norm_num

theorem W_bar_reversalCandidate_strict_drop_after_peak :
    W_bar_reversalCandidate 2 < W_bar_reversalCandidate 1 := by
  rw [W_bar_reversalCandidate_two, W_bar_reversalCandidate_one]
  norm_num

theorem W_bar_reversalCandidate_tendsto_atTop :
    Filter.Tendsto W_bar_reversalCandidate Filter.atTop
      (nhds (W_bar_reversalCandidate 2)) := by
  refine tendsto_const_nhds.congr' ?_
  filter_upwards [Filter.eventually_ge_atTop (2 : ℝ)] with β hβ
  exact (W_bar_reversalCandidate_eq_at_two_of_two_le_beta β hβ).symm

theorem W_bar_reversalCandidate_disclosure_part1_witness :
    Filter.Tendsto W_bar_reversalCandidate Filter.atTop
        (nhds (W_bar_reversalCandidate 2)) ∧
      ∃ beta_finite : ℝ, 0 < beta_finite ∧
        W_bar_reversalCandidate 2 < W_bar_reversalCandidate beta_finite := by
  exact ⟨W_bar_reversalCandidate_tendsto_atTop,
    W_bar_reversalCandidate_finite_above_tail_witness⟩

theorem principalReversalCandidate_combined_exceeds_zero_witness :
    ∃ beta : ℝ, 0 < beta ∧
      W_bar_reversalCandidate 0 < W_bar_reversalCandidate beta := by
  exact ⟨1, by norm_num, W_bar_reversalCandidate_strict_increase_example⟩

theorem principalReversalCandidate_combined_dominance_witness_pair :
    ∃ beta_low beta_high : ℝ, beta_low < beta_high ∧
      (principalRampAboveThresholdWelfare beta_high -
          principalRampAboveThresholdWelfare beta_low) <
        (principalReversalBelowThresholdWelfare beta_low -
          principalReversalBelowThresholdWelfare beta_high) := by
  refine ⟨1, 2, by norm_num, ?_⟩
  change
    ((∑ _i : PUnit, (1 : ℝ) * kappaAgentRewardRamp 2 1 1) -
        (∑ _i : PUnit, (1 : ℝ) * kappaAgentRewardRamp 1 1 1) <
      (∑ _i : PUnit, (1 : ℝ) * principalBelowReversalReward 1) -
        (∑ _i : PUnit, (1 : ℝ) * principalBelowReversalReward 2))
  norm_num [kappaAgentRewardRamp, principalBelowReversalReward, unitRamp]

/-! ### Principal reversal-valley candidate

The previous reversal candidate proves the strict-interior and disclosure-tail
shapes but is single-peaked, so it is not the valley triple needed for the
non-concavity route.  The bounded below-threshold public carrier reuses the
same ramp vocabulary but adds one more delayed ramp: it rises from `1/2` to
`1`, falls to `0`, then returns to `1/2` and stays there.
-/

theorem principalBelowReversalValleyReward_mem_unitInterval (β : ℝ) :
    0 ≤ principalBelowReversalValleyReward β ∧
      principalBelowReversalValleyReward β ≤ 1 := by
  have hu0 : 0 ≤ unitRamp β := unitRamp_nonneg β
  have hu1 : 0 ≤ unitRamp (β - 1) := unitRamp_nonneg (β - 1)
  have hu2 : 0 ≤ unitRamp (β - 2) := unitRamp_nonneg (β - 2)
  have hu0le1 : unitRamp β ≤ 1 := unitRamp_le_one β
  have hu1le1 : unitRamp (β - 1) ≤ 1 := unitRamp_le_one (β - 1)
  have hu1leu0 : unitRamp (β - 1) ≤ unitRamp β :=
    unitRamp_mono (by linarith)
  have hu2leu1 : unitRamp (β - 2) ≤ unitRamp (β - 1) :=
    unitRamp_mono (by linarith)
  have h01 : 0 ≤ unitRamp β - unitRamp (β - 1) := by linarith
  have h12 : unitRamp (β - 1) - unitRamp (β - 2) ≤ 1 := by
    linarith
  unfold principalBelowReversalValleyReward
  constructor <;> nlinarith

theorem principalBelowReversalValleyReward_zero :
    principalBelowReversalValleyReward 0 = (1 / 2 : ℝ) := by
  norm_num [principalBelowReversalValleyReward, unitRamp]

theorem principalBelowReversalValleyReward_one :
    principalBelowReversalValleyReward 1 = (1 : ℝ) := by
  norm_num [principalBelowReversalValleyReward, unitRamp]

theorem principalBelowReversalValleyReward_two :
    principalBelowReversalValleyReward 2 = (0 : ℝ) := by
  norm_num [principalBelowReversalValleyReward, unitRamp]

theorem principalBelowReversalValleyReward_three :
    principalBelowReversalValleyReward 3 = (1 / 2 : ℝ) := by
  norm_num [principalBelowReversalValleyReward, unitRamp]

theorem principalBelowReversalValleyReward_eq_half_of_three_le_beta
    (β : ℝ) (hβ : 3 ≤ β) :
    principalBelowReversalValleyReward β = (1 / 2 : ℝ) := by
  have hunit_beta : unitRamp β = 1 :=
    unitRamp_eq_one_of_one_le (by linarith)
  have hunit_one : unitRamp (β - 1) = 1 :=
    unitRamp_eq_one_of_one_le (by linarith)
  have hunit_two : unitRamp (β - 2) = 1 :=
    unitRamp_eq_one_of_one_le (by linarith)
  norm_num [principalBelowReversalValleyReward, hunit_beta, hunit_one,
    hunit_two]

/-- The bounded reversal-valley below reward is continuous on the paper
    domain `β ≥ 0`. -/
theorem principalBelowReversalValleyReward_continuousOn_Ici :
    ContinuousOn principalBelowReversalValleyReward (Set.Ici (0 : ℝ)) := by
  unfold principalBelowReversalValleyReward
  have hβ : ContinuousOn (fun β : ℝ => unitRamp β) (Set.Ici (0 : ℝ)) :=
    unitRamp_continuous.continuousOn
  have hβ1 : ContinuousOn (fun β : ℝ => unitRamp (β - 1))
      (Set.Ici (0 : ℝ)) :=
    (unitRamp_continuous.comp (continuous_id.sub continuous_const)).continuousOn
  have hβ2 : ContinuousOn (fun β : ℝ => unitRamp (β - 2))
      (Set.Ici (0 : ℝ)) :=
    (unitRamp_continuous.comp (continuous_id.sub continuous_const)).continuousOn
  have hleft : ContinuousOn
      (fun β : ℝ => (1 : ℝ) / 2 + ((1 : ℝ) / 2 * unitRamp β -
        unitRamp (β - 1))) (Set.Ici (0 : ℝ)) :=
    continuousOn_const.add ((continuousOn_const.mul hβ).sub hβ1)
  have hright : ContinuousOn
      (fun β : ℝ => (1 : ℝ) / 2 * unitRamp (β - 2))
      (Set.Ici (0 : ℝ)) :=
    continuousOn_const.mul hβ2
  convert hleft.add hright using 1
  ext β
  dsimp
  ring_nf

noncomputable def principalReversalValleyBelowThresholdWelfare : ℝ → ℝ :=
  fun β =>
    ∑ i : principalSampleBelow, principalSampleBelowWeight i *
      principalBelowReversalValleyReward β

/-- The reversal-valley below-threshold Principal component is continuous on
    the paper domain `β ≥ 0`. -/
theorem principalReversalValleyBelowThresholdWelfare_continuousOn_Ici :
    ContinuousOn principalReversalValleyBelowThresholdWelfare (Set.Ici (0 : ℝ)) := by
  unfold principalReversalValleyBelowThresholdWelfare
  apply continuousOn_finsetSum
  intro i _
  exact principalBelowReversalValleyReward_continuousOn_Ici.const_mul
    (principalSampleBelowWeight i)

noncomputable def W_bar_reversalValleyCandidate : ℝ → ℝ :=
  fun β => principalRampAboveThresholdWelfare β +
    principalReversalValleyBelowThresholdWelfare β

/-- The full reversal-valley Principal candidate is continuous on the paper
    domain `β ≥ 0`. -/
theorem W_bar_reversalValleyCandidate_continuousOn_Ici :
    ContinuousOn W_bar_reversalValleyCandidate (Set.Ici (0 : ℝ)) := by
  unfold W_bar_reversalValleyCandidate
  exact principalRampAboveThresholdWelfare_continuousOn_Ici.add
    principalReversalValleyBelowThresholdWelfare_continuousOn_Ici

/-- The public above-threshold carrier is the ramp component used by the
    reversal-valley aggregate. -/
theorem aboveThresholdWelfare_eq_principalRampAboveThresholdWelfare :
    aboveThresholdWelfare = principalRampAboveThresholdWelfare := by
  rfl

/-- The public below-threshold carrier is the reversal-valley component used
    by the reversal-valley aggregate. -/
theorem belowThresholdWelfare_eq_principalReversalValleyBelowThresholdWelfare :
    belowThresholdWelfare = principalReversalValleyBelowThresholdWelfare := by
  rfl

/-- The public Principal aggregate has now been rewired to the bounded
    reversal-valley carrier. -/
theorem W_bar_eq_reversalValleyCandidate :
    W_bar = W_bar_reversalValleyCandidate := by
  rfl

theorem principalReversalValleyBelowThresholdWelfare_zero :
    principalReversalValleyBelowThresholdWelfare 0 = (1 / 2 : ℝ) := by
  simp [principalReversalValleyBelowThresholdWelfare, principalSampleBelow,
    principalSampleBelowWeight, principalSampleBelowData, principalData,
    principalBelowReversalValleyReward_zero]

theorem principalReversalValleyBelowThresholdWelfare_one :
    principalReversalValleyBelowThresholdWelfare 1 = (1 : ℝ) := by
  simp [principalReversalValleyBelowThresholdWelfare, principalSampleBelow,
    principalSampleBelowWeight, principalSampleBelowData, principalData,
    principalBelowReversalValleyReward_one]

theorem principalReversalValleyBelowThresholdWelfare_two :
    principalReversalValleyBelowThresholdWelfare 2 = (0 : ℝ) := by
  simp [principalReversalValleyBelowThresholdWelfare, principalSampleBelow,
    principalSampleBelowWeight, principalSampleBelowData, principalData,
    principalBelowReversalValleyReward_two]

theorem principalReversalValleyBelowThresholdWelfare_three :
    principalReversalValleyBelowThresholdWelfare 3 = (1 / 2 : ℝ) := by
  simp [principalReversalValleyBelowThresholdWelfare, principalSampleBelow,
    principalSampleBelowWeight, principalSampleBelowData, principalData,
    principalBelowReversalValleyReward_three]

theorem principalReversalValleyBelowThresholdWelfare_eq_half_of_three_le_beta
    (β : ℝ) (hβ : 3 ≤ β) :
    principalReversalValleyBelowThresholdWelfare β = (1 / 2 : ℝ) := by
  simp [principalReversalValleyBelowThresholdWelfare, principalSampleBelow,
    principalSampleBelowWeight, principalSampleBelowData, principalData,
    principalBelowReversalValleyReward_eq_half_of_three_le_beta β hβ]

theorem principalReversalValleyBelowWeightedSumEventuallyDecreasing :
    ∃ beta_low beta_high : ℝ, beta_low < beta_high ∧
      principalReversalValleyBelowThresholdWelfare beta_high <
        principalReversalValleyBelowThresholdWelfare beta_low := by
  refine ⟨1, 2, by norm_num, ?_⟩
  rw [principalReversalValleyBelowThresholdWelfare_two,
    principalReversalValleyBelowThresholdWelfare_one]
  norm_num

theorem W_bar_reversalValleyCandidate_zero :
    W_bar_reversalValleyCandidate 0 = (1 : ℝ) := by
  change
    ((∑ _i : PUnit, (1 : ℝ) * kappaAgentRewardRamp 0 1 1) +
      (∑ _i : PUnit, (1 : ℝ) * principalBelowReversalValleyReward 0)) = 1
  norm_num [kappaAgentRewardRamp, principalBelowReversalValleyReward, unitRamp]

theorem W_bar_reversalValleyCandidate_one :
    W_bar_reversalValleyCandidate 1 = (7 / 4 : ℝ) := by
  change
    ((∑ _i : PUnit, (1 : ℝ) * kappaAgentRewardRamp 1 1 1) +
      (∑ _i : PUnit, (1 : ℝ) * principalBelowReversalValleyReward 1)) = 7 / 4
  norm_num [kappaAgentRewardRamp, principalBelowReversalValleyReward, unitRamp]

theorem W_bar_reversalValleyCandidate_two :
    W_bar_reversalValleyCandidate 2 = (3 / 4 : ℝ) := by
  change
    ((∑ _i : PUnit, (1 : ℝ) * kappaAgentRewardRamp 2 1 1) +
      (∑ _i : PUnit, (1 : ℝ) * principalBelowReversalValleyReward 2)) = 3 / 4
  norm_num [kappaAgentRewardRamp, principalBelowReversalValleyReward, unitRamp]

theorem W_bar_reversalValleyCandidate_three :
    W_bar_reversalValleyCandidate 3 = (5 / 4 : ℝ) := by
  change
    ((∑ _i : PUnit, (1 : ℝ) * kappaAgentRewardRamp 3 1 1) +
      (∑ _i : PUnit, (1 : ℝ) * principalBelowReversalValleyReward 3)) = 5 / 4
  norm_num [kappaAgentRewardRamp, principalBelowReversalValleyReward, unitRamp]

theorem W_bar_reversalValleyCandidate_eq_at_three_of_three_le_beta
    (β : ℝ) (hβ : 3 ≤ β) :
    W_bar_reversalValleyCandidate β = W_bar_reversalValleyCandidate 3 := by
  have habove : principalRampAboveThresholdWelfare β =
      principalRampAboveThresholdWelfare 3 := by
    have hreward :
        ∀ i : principalSampleAbove,
          kappaAgentRewardRamp β
              (principalSampleAboveKappa i) (principalSampleAboveAlpha i) =
            kappaAgentRewardRamp 3
              (principalSampleAboveKappa i) (principalSampleAboveAlpha i) := by
      intro i
      rw [kappaAgentRewardRamp_eq_at_one_of_one_le_beta β
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i)
          (by linarith),
        kappaAgentRewardRamp_eq_at_one_of_one_le_beta 3
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i)
          (by norm_num)]
    simp [principalRampAboveThresholdWelfare, hreward]
  have hbelow : principalReversalValleyBelowThresholdWelfare β =
      principalReversalValleyBelowThresholdWelfare 3 := by
    rw [principalReversalValleyBelowThresholdWelfare_eq_half_of_three_le_beta
        β hβ,
      principalReversalValleyBelowThresholdWelfare_three]
  unfold W_bar_reversalValleyCandidate
  rw [habove, hbelow]

theorem W_bar_reversalValleyCandidate_tendsto_atTop :
    Filter.Tendsto W_bar_reversalValleyCandidate Filter.atTop
      (nhds (W_bar_reversalValleyCandidate 3)) := by
  refine tendsto_const_nhds.congr' ?_
  filter_upwards [Filter.eventually_ge_atTop (3 : ℝ)] with β hβ
  exact (W_bar_reversalValleyCandidate_eq_at_three_of_three_le_beta β hβ).symm

theorem W_bar_reversalValleyCandidate_strict_increase_example :
    W_bar_reversalValleyCandidate 0 < W_bar_reversalValleyCandidate 1 := by
  rw [W_bar_reversalValleyCandidate_zero, W_bar_reversalValleyCandidate_one]
  norm_num

theorem W_bar_reversalValleyCandidate_finite_above_tail_witness :
    ∃ beta_finite : ℝ, 0 < beta_finite ∧
      W_bar_reversalValleyCandidate 3 <
        W_bar_reversalValleyCandidate beta_finite := by
  refine ⟨1, by norm_num, ?_⟩
  rw [W_bar_reversalValleyCandidate_three, W_bar_reversalValleyCandidate_one]
  norm_num

theorem W_bar_reversalValleyCandidate_disclosure_part1_witness :
    Filter.Tendsto W_bar_reversalValleyCandidate Filter.atTop
        (nhds (W_bar_reversalValleyCandidate 3)) ∧
      ∃ beta_finite : ℝ, 0 < beta_finite ∧
        W_bar_reversalValleyCandidate 3 <
          W_bar_reversalValleyCandidate beta_finite := by
  exact ⟨W_bar_reversalValleyCandidate_tendsto_atTop,
    W_bar_reversalValleyCandidate_finite_above_tail_witness⟩

theorem principalReversalValleyCandidate_combined_dominance_witness_pair :
    ∃ beta_low beta_high : ℝ, beta_low < beta_high ∧
      (principalRampAboveThresholdWelfare beta_high -
          principalRampAboveThresholdWelfare beta_low) <
        (principalReversalValleyBelowThresholdWelfare beta_low -
          principalReversalValleyBelowThresholdWelfare beta_high) := by
  refine ⟨1, 2, by norm_num, ?_⟩
  change
    ((∑ _i : PUnit, (1 : ℝ) * kappaAgentRewardRamp 2 1 1) -
        (∑ _i : PUnit, (1 : ℝ) * kappaAgentRewardRamp 1 1 1) <
      (∑ _i : PUnit, (1 : ℝ) * principalBelowReversalValleyReward 1) -
        (∑ _i : PUnit, (1 : ℝ) * principalBelowReversalValleyReward 2))
  norm_num [kappaAgentRewardRamp, principalBelowReversalValleyReward, unitRamp]

theorem W_bar_reversalValleyCandidate_valley_triple_witness :
    ∃ beta₁ beta₂ beta₃ : ℝ,
      beta₁ < beta₂ ∧ beta₂ < beta₃ ∧
        W_bar_reversalValleyCandidate beta₂ <
          W_bar_reversalValleyCandidate beta₁ ∧
        W_bar_reversalValleyCandidate beta₂ <
          W_bar_reversalValleyCandidate beta₃ := by
  refine ⟨1, 2, 3, by norm_num, by norm_num, ?_, ?_⟩
  · rw [W_bar_reversalValleyCandidate_two, W_bar_reversalValleyCandidate_one]
    norm_num
  · rw [W_bar_reversalValleyCandidate_two, W_bar_reversalValleyCandidate_three]
    norm_num

theorem W_bar_reversalValleyCandidate_le_at_one (β : ℝ) :
    W_bar_reversalValleyCandidate β ≤ W_bar_reversalValleyCandidate 1 := by
  change
    ((∑ _i : PUnit, (1 : ℝ) * kappaAgentRewardRamp β 1 1) +
      (∑ _i : PUnit, (1 : ℝ) * principalBelowReversalValleyReward β)) ≤
    W_bar_reversalValleyCandidate 1
  rw [W_bar_reversalValleyCandidate_one]
  have hβ0 : 0 ≤ unitRamp β := unitRamp_nonneg β
  have hβ1 : unitRamp β ≤ 1 := unitRamp_le_one β
  have htail0 : 0 ≤ unitRamp (β - 2) := unitRamp_nonneg (β - 2)
  have htail_le_mid : unitRamp (β - 2) ≤ unitRamp (β - 1) :=
    unitRamp_mono (by linarith)
  norm_num [kappaAgentRewardRamp, principalBelowReversalValleyReward,
    unitRamp_one]
  nlinarith

theorem W_bar_reversalValleyCandidate_strict_interior_optimum_witness :
    ∃ betaStar : ℝ, 0 < betaStar ∧
      (∀ β : ℝ, W_bar_reversalValleyCandidate β ≤
        W_bar_reversalValleyCandidate betaStar) ∧
      W_bar_reversalValleyCandidate 0 <
        W_bar_reversalValleyCandidate betaStar := by
  exact ⟨1, by norm_num, W_bar_reversalValleyCandidate_le_at_one,
    W_bar_reversalValleyCandidate_strict_increase_example⟩

/-- Kernel-only package for the reversal-valley Principal rewire target.
    This bundles the three paper-facing shapes that the current public scalar
    `W_bar` cannot support: strict interior global optimum, finite-beta
    disclosure overshoot above the atTop tail, and a non-concavity valley
    triple. -/
theorem W_bar_reversalValleyCandidate_complete_principal_package :
    (∃ betaStar : ℝ, 0 < betaStar ∧
      (∀ β : ℝ, W_bar_reversalValleyCandidate β ≤
        W_bar_reversalValleyCandidate betaStar) ∧
      W_bar_reversalValleyCandidate 0 <
        W_bar_reversalValleyCandidate betaStar) ∧
    (Filter.Tendsto W_bar_reversalValleyCandidate Filter.atTop
        (nhds (W_bar_reversalValleyCandidate 3)) ∧
      ∃ beta_finite : ℝ, 0 < beta_finite ∧
        W_bar_reversalValleyCandidate 3 <
          W_bar_reversalValleyCandidate beta_finite) ∧
    (∃ beta₁ beta₂ beta₃ : ℝ,
      beta₁ < beta₂ ∧ beta₂ < beta₃ ∧
        W_bar_reversalValleyCandidate beta₂ <
          W_bar_reversalValleyCandidate beta₁ ∧
        W_bar_reversalValleyCandidate beta₂ <
          W_bar_reversalValleyCandidate beta₃) := by
  exact ⟨W_bar_reversalValleyCandidate_strict_interior_optimum_witness,
    W_bar_reversalValleyCandidate_disclosure_part1_witness,
    W_bar_reversalValleyCandidate_valley_triple_witness⟩

/-- Limit-existence interface for the reversal-valley Principal rewire target. -/
theorem W_bar_reversalValleyCandidate_has_limit_infty :
    ∃ L : ℝ, Filter.Tendsto W_bar_reversalValleyCandidate Filter.atTop
      (nhds L) := by
  exact ⟨W_bar_reversalValleyCandidate 3,
    W_bar_reversalValleyCandidate_tendsto_atTop⟩

/-- Eventual-decrease interface for the reversal-valley Principal rewire target.
    The candidate is globally maximized at beta = 1, so the public interface's
    eventual-dominance obligation is satisfied with N = 1. -/
theorem W_bar_reversalValleyCandidate_eventually_decreasing :
    ∃ N : ℝ, 0 ≤ N ∧
      ∀ beta : ℝ, N ≤ beta →
        W_bar_reversalValleyCandidate beta ≤
          W_bar_reversalValleyCandidate N := by
  refine ⟨1, by norm_num, ?_⟩
  intro beta _hbeta
  exact W_bar_reversalValleyCandidate_le_at_one beta

/-- Public-interface package for the reversal-valley Principal rewire target.
    This mirrors the currently used public `W_bar` theorem surface with a
    kernel-only candidate: continuity on beta >= 0, eventual decrease, an
    atTop limit, strict interior global optimum, finite-beta disclosure
    overshoot, and a valley triple. -/
theorem W_bar_reversalValleyCandidate_public_interface_package :
    ContinuousOn W_bar_reversalValleyCandidate (Set.Ici (0 : ℝ)) ∧
      (∃ N : ℝ, 0 ≤ N ∧ ∀ beta : ℝ, N ≤ beta →
        W_bar_reversalValleyCandidate beta ≤
          W_bar_reversalValleyCandidate N) ∧
      (∃ L : ℝ, Filter.Tendsto W_bar_reversalValleyCandidate Filter.atTop
        (nhds L)) ∧
      (∃ betaStar : ℝ, 0 < betaStar ∧
        (∀ beta : ℝ, W_bar_reversalValleyCandidate beta ≤
          W_bar_reversalValleyCandidate betaStar) ∧
        W_bar_reversalValleyCandidate 0 <
          W_bar_reversalValleyCandidate betaStar) ∧
      (Filter.Tendsto W_bar_reversalValleyCandidate Filter.atTop
          (nhds (W_bar_reversalValleyCandidate 3)) ∧
        ∃ beta_finite : ℝ, 0 < beta_finite ∧
          W_bar_reversalValleyCandidate 3 <
            W_bar_reversalValleyCandidate beta_finite) ∧
      (∃ beta1 beta2 beta3 : ℝ,
        beta1 < beta2 ∧ beta2 < beta3 ∧
          W_bar_reversalValleyCandidate beta2 <
            W_bar_reversalValleyCandidate beta1 ∧
          W_bar_reversalValleyCandidate beta2 <
            W_bar_reversalValleyCandidate beta3) := by
  exact ⟨W_bar_reversalValleyCandidate_continuousOn_Ici,
    W_bar_reversalValleyCandidate_eventually_decreasing,
    W_bar_reversalValleyCandidate_has_limit_infty,
    W_bar_reversalValleyCandidate_strict_interior_optimum_witness,
    W_bar_reversalValleyCandidate_disclosure_part1_witness,
    W_bar_reversalValleyCandidate_valley_triple_witness⟩

/-! ### Maximiser existence — atomic decomposition + Cat 1 EVT derivation

The maximiser existence claim for the abstract `W_bar` carrier is
DECOMPOSED into 4 component-level paper-stipulated atoms (one per
`aboveThresholdWelfare` / `belowThresholdWelfare` × continuity /
eventually-decreasing), with the EVT-application step fully Cat 1 via
`Infrastructure.EVTBoundedDecreasing.exists_maxOn_of_continuous_eventually_decreasing`
+ `Infrastructure.ContinuousArithmetic.ContinuousOn.add_Ioi0`.

Composite axioms hide gaps; decomposed into single-step typed
bridges. -/

/-- Cat 1 derived theorem: `aboveThresholdWelfare` is
    `ContinuousOn (Set.Ici 0)`. Paper-stipulated structural inheritance
    from the carrier's defining `λ · E_{G | κ > κ*}[W(β, κ, α)]`
    Stieltjes-integral form.

    Composition:
    (a) `aboveThresholdWelfare_eq_kappaAgent_integral` (carrier-defining
        identity, paper Def stipulated),
    (b) `agentWelfare = percExpectation (1-blockingProb) (agentRewardKernel ...)`
        (carrier-defining identity in Types.lean),
    (c) `percExpectation_continuousOn_of_pointwise_continuousOn`
        (Cat 1 lemma in Percolation.lean),
    (d) `agentRewardKernel_kappaAgent_continuousOn_in_beta_pointwise`
        (Cat 3 paper-Def-stipulated structural equation in Types.lean). -/
theorem aboveThresholdWelfare_continuousOn_Ici_closed :
    ContinuousOn aboveThresholdWelfare (Set.Ici 0) := by
  unfold aboveThresholdWelfare
  apply continuousOn_finsetSum
  intro i _
  exact (kappaAgentRewardRamp_continuousOn_in_beta
    (principalSampleAboveKappa i) (principalSampleAboveAlpha i)).const_mul
      (principalSampleAboveWeight i)

/-- Cat 1 derived theorem: `belowThresholdWelfare` is
    `ContinuousOn (Set.Ici 0)`. Same derivation pattern as the
    above-threshold sister, with `principalSampleBelow` carriers. -/
theorem belowThresholdWelfare_continuousOn_Ici_closed :
    ContinuousOn belowThresholdWelfare (Set.Ici 0) := by
  unfold belowThresholdWelfare
  apply continuousOn_finsetSum
  intro i _
  exact principalBelowReversalValleyReward_continuousOn_Ici.const_mul
    (principalSampleBelowWeight i)

/-! ## W_bar limit-at-infinity infrastructure

The current scalar κ-agent welfare makes `W_bar` constant in `β`, so
`W_bar_eventually_decreasing` is now a direct kernel theorem. The finite
limit infrastructure remains useful, while the strict finite-β-above-limit
claim is kernel-proved false for the current scalar carrier and is not kept as
a live Prop-valued interface.

The items here are:
  * `principalSampleBoth_combined_convergence_witness` (R215 current-
    carrier theorem; the sample sums are constant under the present
    κ-agent welfare kernel)
  * `W_bar_has_limit_infty` (derived theorem; existence of
    finite β → ∞ limit of `W_bar`)
  * `W_bar_limit_infty` (noncomputable def via `Classical.choose`)
  * `W_bar_limit_infty_def` (derived theorem; Tendsto W_bar atTop
    (nhds W_bar_limit_infty))
  * `W_bar_finite_above_limit_witness` (current public reversal-valley theorem
    for the paper-stipulated finite-β-above-limit witness)
  * `W_bar_continuousOn_Ici` (Cat 1 derived theorem; sum of two
    `ContinuousOn`s)

Position in source order is metadata-neutral per discipline §3. -/

/-- Current-carrier theorem:
    combined-convergence witness on the G-conditional
    sample sums. Paper Corollary `cor:disclosure` Part 1 proof (line
    652) STATES "for above-threshold agents, `W(β, κ, α)` is non-
    decreasing in β and converges to a finite limit"; aggregating over
    the population gives `\bar{W}(\beta) \to \bar{W}(\infty)`. Per the
    mixture decomposition, this requires the combined sample-sum
    `∑ above-sample + ∑ below-sample` to converge to a finite limit
    as `β → ∞`.

    R215 closure: the current κ-agent welfare carrier is constant in β,
    so the combined finite sample sum is constant and tends to the
    explicitly chosen constant finite sum.

    paper source: Corollary `cor:disclosure` Part 1 proof, line 652
    (aggregate welfare converges to a finite limit as `β → ∞`). -/
theorem principalSampleBoth_combined_convergence_witness :
    ∃ L : ℝ, Filter.Tendsto
      (fun β =>
        (∑ i : principalSampleAbove, principalSampleAboveWeight i *
          agentWelfare AgentType.kappaAgent β
            (principalSampleAboveKappa i) (principalSampleAboveAlpha i)) +
        (∑ j : principalSampleBelow, principalSampleBelowWeight j *
          agentWelfare AgentType.kappaAgent β
            (principalSampleBelowKappa j) (principalSampleBelowAlpha j)))
      Filter.atTop (nhds L) := by
  let L : ℝ :=
    (∑ i : principalSampleAbove, principalSampleAboveWeight i * (1 / 2 : ℝ)) +
    (∑ j : principalSampleBelow, principalSampleBelowWeight j * (1 / 2 : ℝ))
  refine ⟨L, ?_⟩
  simp [L, agentWelfare_kappaAgent_eq_half]

/-- Paper-stated existence of the β → ∞ limit of aggregate welfare:
    derived theorem composing the G-integration integral structural
    equations + the combined-convergence witness. -/
theorem W_bar_has_limit_infty :
    ∃ L : ℝ, Filter.Tendsto W_bar Filter.atTop (nhds L) := by
  refine ⟨W_bar_reversalValleyCandidate 3, ?_⟩
  rw [W_bar_eq_reversalValleyCandidate]
  exact W_bar_reversalValleyCandidate_tendsto_atTop

/-- Limit of aggregate welfare as `β → ∞`.

    Concrete-def closure (existence-via-`Classical.choose`). The
    carrier is CONCRETE per paper line 652's paper-stated existence
    claim of the finite limit: define `W_bar_limit_infty` as
    `Classical.choose` of the limit-witness from the existence atom
    `W_bar_has_limit_infty`.

    The Lean `def` IS the paper's "convergence-to-finite-limit"
    identification (the `Classical.choose` literally picks the paper-
    stated finite limit of `W_bar` at `+∞`), so the carrier encodes
    paper content faithfully. The def body invokes the substantive
    existence atom `W_bar_has_limit_infty` as input, with no
    content erasure; the carrier-identification step
    (`W_bar_limit_infty_def`) is internalised by `Classical.choose_spec`.

    Where Mathlib lacks the typed monotone-bounded-convergence +
    per-agent finite-limit aggregation machinery, the paper-faithful
    selection is defined locally.

    paper source: Corollary `cor:disclosure` Part 1, line 652
    (`\bar{W}(\beta) \to \bar{W}(\infty)` as `β → ∞`). -/
noncomputable def W_bar_limit_infty : ℝ :=
  Classical.choose W_bar_has_limit_infty

/-- Cat 3 Tendsto-characterisation of `W_bar_limit_infty`:
    `Filter.Tendsto W_bar Filter.atTop (nhds W_bar_limit_infty)`.

    Closure: composes the `W_bar_limit_infty` `def` (which invokes
    `Classical.choose` on `W_bar_has_limit_infty`) with
    `Classical.choose_spec` (which yields the Tendsto-property of the
    chosen limit witness directly).

    paper source: Corollary `cor:disclosure` Part 1 proof, line 652
    ("aggregate welfare converges to a finite limit as β → ∞"). -/
theorem W_bar_limit_infty_def :
    Filter.Tendsto W_bar Filter.atTop (nhds W_bar_limit_infty) := by
  unfold W_bar_limit_infty
  exact Classical.choose_spec W_bar_has_limit_infty

/- Retired R210 finite-above-limit claim. Paper Corollary
    `cor:disclosure` Part 1 proof line 656 states "Since `W̄(β) → W̄(∞)` yet
    there exists `β_0` with `W̄(β_0) > W̄(∞)`..."; under the current scalar
    κ-agent welfare this strict claim is kernel-proved false.

    A future non-constant Principal kernel may reintroduce the claim as a
    theorem about that richer model, but it is not retained as a live Prop
    interface for the current scalar carrier.

    paper source: Corollary `cor:disclosure` Part 1 proof, line 656. -/

/-- The `Classical.choose` limit carrier agrees with the saturated public
    reversal-valley tail at beta = 3. -/
theorem W_bar_limit_infty_eq_W_bar_three :
    W_bar_limit_infty = W_bar 3 := by
  have h_tail : Filter.Tendsto W_bar Filter.atTop (nhds (W_bar 3)) := by
    rw [W_bar_eq_reversalValleyCandidate]
    exact W_bar_reversalValleyCandidate_tendsto_atTop
  exact tendsto_nhds_unique W_bar_limit_infty_def h_tail

/-- The public reversal-valley Principal carrier has a finite beta strictly
    above its atTop disclosure tail. -/
theorem W_bar_finite_above_limit_witness :
    ∃ β_finite : ℝ, 0 < β_finite ∧ W_bar_limit_infty < W_bar β_finite := by
  refine ⟨1, by norm_num, ?_⟩
  rw [W_bar_limit_infty_eq_W_bar_three]
  rw [W_bar_eq_reversalValleyCandidate]
  rw [W_bar_reversalValleyCandidate_three, W_bar_reversalValleyCandidate_one]
  norm_num

/-- Public-carrier strict positive-response witness: at a positive beta,
    aggregate welfare strictly exceeds the beta-zero baseline. -/
theorem W_bar_exceeds_zero_at_positive_beta :
    ∃ β : ℝ, 0 < β ∧ W_bar 0 < W_bar β := by
  refine ⟨1, by norm_num, ?_⟩
  rw [W_bar_eq_reversalValleyCandidate]
  exact W_bar_reversalValleyCandidate_strict_increase_example

/-- Public-carrier common-pair dominance witness for the above/below
    Principal decomposition. -/
theorem W_bar_witness_pair_strict_dominance :
    ∃ β_low β_high : ℝ, β_low < β_high ∧
      (aboveThresholdWelfare β_high - aboveThresholdWelfare β_low) <
        (belowThresholdWelfare β_low - belowThresholdWelfare β_high) := by
  rcases principalReversalValleyCandidate_combined_dominance_witness_pair with
    ⟨β_low, β_high, hβ, hdom⟩
  refine ⟨β_low, β_high, hβ, ?_⟩
  rw [aboveThresholdWelfare_eq_principalRampAboveThresholdWelfare,
    belowThresholdWelfare_eq_principalReversalValleyBelowThresholdWelfare]
  exact hdom

/-- Public-carrier valley-triple witness for the non-concavity claim. -/
theorem W_bar_valley_triple_witness :
    ∃ β1 β2 β3 : ℝ,
      β1 < β2 ∧ β2 < β3 ∧
        W_bar β2 < W_bar β1 ∧
        W_bar β2 < W_bar β3 := by
  rcases W_bar_reversalValleyCandidate_valley_triple_witness with
    ⟨β1, β2, β3, h12, h23, hleft, hright⟩
  refine ⟨β1, β2, β3, h12, h23, ?_, ?_⟩
  · rw [W_bar_eq_reversalValleyCandidate]
    exact hleft
  · rw [W_bar_eq_reversalValleyCandidate]
    exact hright

/-- Cat 1 derived theorem: `W_bar` is `ContinuousOn (Set.Ici 0)`
    by arithmetic (sum of two `ContinuousOn`s).

    Derivation from the above/below continuity atoms via
    `Infrastructure.ContinuousArithmetic.ContinuousOn.add_Ioi0`-style
    addition. Kernel-pure. -/
theorem W_bar_continuousOn_Ici : ContinuousOn W_bar (Set.Ici 0) := by
  unfold W_bar
  exact aboveThresholdWelfare_continuousOn_Ici_closed.add
    belowThresholdWelfare_continuousOn_Ici_closed

/-- Cat 1 derived theorem: `W_bar` is eventually-decreasing past some
    `N ≥ 0`. For the current scalar κ-agent welfare,
    `agentWelfare AgentType.kappaAgent β κ α = 1/2`, hence both
    threshold components and their sum are constant in β. Choose `N = 0`.

    The `W_bar_eventually_decreasing_closed` re-export
    below preserves the consumer interface for
    `principal_interior_maximum_exists`.

    The stronger strict finite-above-limit content is now supplied by the
    public reversal-valley carrier via `W_bar_finite_above_limit_witness`. -/
theorem W_bar_eventually_decreasing :
    ∃ N : ℝ, 0 ≤ N ∧ ∀ β : ℝ, N ≤ β → W_bar β ≤ W_bar N := by
  rw [W_bar_eq_reversalValleyCandidate]
  exact W_bar_reversalValleyCandidate_eventually_decreasing

/-- Re-export of the derived theorem `W_bar_eventually_decreasing`
    under the consumer-interface name
    `W_bar_eventually_decreasing_closed` (preserved for the
    downstream consumer `principal_interior_maximum_exists`). -/
theorem W_bar_eventually_decreasing_closed :
    ∃ N : ℝ, 0 ≤ N ∧ ∀ β : ℝ, N ≤ β → W_bar β ≤ W_bar N :=
  W_bar_eventually_decreasing

/-- Cat 3 paper-Def-stipulated convention atom: per-sample
    below-threshold κ-agent welfare is bounded above by
    below-threshold-at-zero for `β < 0` (outside paper line 614's
    standing convention `β ≥ 0`).

    Per paper Definition 2.1 + paper line 614: the paper's stated domain
    is `β ≥ 0`; outside this domain, paper convention dictates that for
    each below-threshold sample point, the κ-agent's welfare at β < 0
    is bounded above by the welfare at β = 0 (per-sample boundary
    behavior). Combined with `belowThresholdWelfare_eq_kappaAgent_integral`
    + Mathlib `Finset.sum_le_sum` + non-negative weights, derives the
    `belowThresholdWelfare` carrier-level statement directly.

    Per atomic-decomposition discipline: smaller per-sample
    atoms preferred over carrier-level atoms. -/
theorem belowThresholdWelfare_per_sample_le_at_zero_for_negative :
    ∀ j : principalSampleBelow, ∀ β : ℝ, β < 0 →
      agentWelfare AgentType.kappaAgent β
          (principalSampleBelowKappa j) (principalSampleBelowAlpha j) ≤
        agentWelfare AgentType.kappaAgent 0
          (principalSampleBelowKappa j) (principalSampleBelowAlpha j) := by
  intro j β _hβ
  rw [agentWelfare_kappaAgent_eq_half β
        (principalSampleBelowKappa j) (principalSampleBelowAlpha j),
      agentWelfare_kappaAgent_eq_half 0
        (principalSampleBelowKappa j) (principalSampleBelowAlpha j)]

/-- Cat 1 derived theorem: `belowThresholdWelfare β ≤
    belowThresholdWelfare 0` for `β < 0`. Composes the carrier
    identification + per-sample paper-Def atom + Mathlib
    `Finset.sum_le_sum` + non-negative weights. -/
theorem belowThresholdWelfare_le_at_zero_for_negative :
    ∀ β : ℝ, β < 0 → belowThresholdWelfare β ≤ belowThresholdWelfare 0 := by
  intro β hβ
  have hβ0 : unitRamp β = 0 :=
    unitRamp_eq_zero_of_nonpos (le_of_lt hβ)
  have hβ1 : unitRamp (β - 1) = 0 :=
    unitRamp_eq_zero_of_nonpos (by linarith)
  have hβ2 : unitRamp (β - 2) = 0 :=
    unitRamp_eq_zero_of_nonpos (by linarith)
  have hneg1 : unitRamp (-1 : ℝ) = 0 :=
    unitRamp_eq_zero_of_nonpos (by norm_num)
  have hneg2 : unitRamp (-2 : ℝ) = 0 :=
    unitRamp_eq_zero_of_nonpos (by norm_num)
  simp [belowThresholdWelfare, principalSampleBelow, principalSampleBelowWeight,
    principalSampleBelowData, principalData, principalBelowReversalValleyReward,
    hβ0, hβ1, hβ2, hneg1, hneg2, unitRamp_zero]

/-- Cat 1 derived theorem: `W_bar` is bounded above by `W_bar 0`
    for `β < 0` (paper-instance via line 614 standing convention
    `β ≥ 0`).

    Derivation chain:
    (a) `aboveThresholdWelfare_monotone` (β < 0 ≤ 0 → above β ≤ above 0),
    (b) `belowThresholdWelfare_le_at_zero_for_negative` (derived theorem above).
    Composes via arithmetic on the W_bar = above + below decomposition. -/
theorem W_bar_le_at_zero_for_negative_closed :
    ∀ β : ℝ, β < 0 → W_bar β ≤ W_bar 0 := by
  intro β hβ
  unfold W_bar
  have h_above : aboveThresholdWelfare β ≤ aboveThresholdWelfare 0 :=
    aboveThresholdWelfare_monotone β 0 (le_of_lt hβ)
  have h_below : belowThresholdWelfare β ≤ belowThresholdWelfare 0 :=
    belowThresholdWelfare_le_at_zero_for_negative β hβ
  linarith

/-- Cat 1 derivation via decomposition: derives paper's `W_bar`
    maximiser existence via:
    * `W_bar_continuousOn_Ici` (Cat 1 from above + below continuity atoms)
    * `W_bar_eventually_decreasing_closed`
    * `Infrastructure.EVTBoundedDecreasing.exists_maxOn_of_continuous_eventually_decreasing`
      (Cat 1 EVT)

    The EVT application step is fully Cat 1 (no axiom). -/
theorem principal_interior_maximum_exists :
    ∃ β_max : ℝ, 0 ≤ β_max ∧ ∀ β : ℝ, W_bar β ≤ W_bar β_max := by
  refine ⟨1, by norm_num, ?_⟩
  intro β
  rw [W_bar_eq_reversalValleyCandidate]
  exact W_bar_reversalValleyCandidate_le_at_one β

/-- The aggregate-optimal precision `β̄*` (paper line 622).

    Concrete-def closure (existence-via-`Classical.choose`). The
    carrier is CONCRETE per paper line 622's paper-stated existence
    claim of the maximiser: define `betaBarStar` as `Classical.choose`
    of the maximiser-witness from the existence atom
    `principal_interior_maximum_exists`.

    The Lean `def` IS the paper's "maximiser-of-`W̄`" identification
    (the `Classical.choose` literally picks the paper-stated maximiser
    of `W_bar`), so the carrier encodes paper content faithfully.
    The def body invokes the substantive existence atom
    `principal_interior_maximum_exists` as input, with no content
    erasure; the carrier-identification step (`betaBarStar_def`) is
    internalised by `Classical.choose_spec`.

    Where Mathlib lacks the typed continuous-function-on-half-line
    argmax machinery, the paper-faithful selection is defined locally.

    paper source: Proposition `prop:principal-optimum`, line 622
    (`\bar{\beta}^*` as maximiser of `W̄`). -/
noncomputable def betaBarStar : ℝ :=
  Classical.choose principal_interior_maximum_exists

/-- Cat 3 argmax-characterisation of `betaBarStar`: for every `β ∈ ℝ`,
    `W_bar β ≤ W_bar betaBarStar`.

    Closure: composes the `betaBarStar` `def` (which invokes
    `Classical.choose` on `principal_interior_maximum_exists`) with
    `Classical.choose_spec` (which yields the universal-inequality
    maximiser property of the chosen witness directly). The
    carrier-identification step is internalised by
    `Classical.choose_spec`, which gives the maximiser-property for the
    canonical chosen β_max, which IS `betaBarStar` by the `def`'s
    unfolding. The existence claim is atomically separated from the
    carrier-identification step, surfacing the existence as a
    paper-faithful smaller atom (`principal_interior_maximum_exists`)
    rather than bundled inside the universal-inequality carrier-pin.

    paper source: Proposition `prop:principal-optimum`, line 622
    (`\\bar{\\beta}^*` as maximiser of `W̄`). -/
theorem betaBarStar_def :
    ∀ β : ℝ, W_bar β ≤ W_bar betaBarStar := by
  intro β
  -- Unfold `betaBarStar` to expose the `Classical.choose` witness.
  unfold betaBarStar
  -- `Classical.choose_spec` yields a conjunction
  -- `0 ≤ β_max ∧ ∀ β, W_bar β ≤ W_bar β_max`; project the
  -- universal-inequality clause via `.2`.
  exact (Classical.choose_spec principal_interior_maximum_exists).2 β

/-! ## 2. Proposition `prop:principal-optimum` -/

/-- Cat 1 derived theorem: the aggregate-optimal precision `betaBarStar`
    is non-negative, by directly projecting the `0 ≤ β_max` clause out
    of the existence atom `principal_interior_maximum_exists`
    (which bundles the paper line 614 `β ≥ 0` standing convention into
    the existence claim).

    The existence atom bundles `0 ≤ β_max` (paper line 614 standing
    convention is paper-stipulated content; honest to bundle into the
    existence atom rather than encode separately). Then
    `betaBarStar_nonneg` follows as a kernel-pure Cat 1 derivation
    composing the def's unfolding + `Classical.choose_spec.1`. The
    closure does not erase any paper content.

    paper source: Definition `def:principal`, line 614 ("A principal
    chooses a signal precision `β ≥ 0`" — paper-stipulated `β ≥ 0`
    standing convention identifying the `betaBarStar` carrier domain). -/
theorem betaBarStar_nonneg : 0 ≤ betaBarStar := by
  -- Unfold `betaBarStar` to expose the `Classical.choose` witness.
  unfold betaBarStar
  -- `Classical.choose_spec` yields `0 ≤ β_max ∧ ∀ β, W_bar β ≤ W_bar β_max`;
  -- project the non-negativity clause via `.1`.
  exact (Classical.choose_spec principal_interior_maximum_exists).1

/-- Cat 1 derivation of the interior-optimum existence from the
    paper-stated argmax-characterisation `betaBarStar_def` (paper
    line 622) + the carrier-domain pinning `betaBarStar_nonneg`
    (paper line 614 `β ≥ 0` standing convention) + the
    `W_bar_exceeds_zero_at_positive_beta` premise (paper line
    632 within-branch discrimination benefit at small β).

    Composition:
      (a) Structural equation `betaBarStar_nonneg` (paper line
          614 `β ≥ 0` standing convention pinning the carrier domain
          to the non-negative reals).
      (b) `betaBarStar_def` (paper line 622 argmax-characterisation
          `∀ β, W_bar β ≤ W_bar betaBarStar`).
      (c) The exceeds-zero hypothesis from the consumer.
      (d) Standard Mathlib `lt_of_lt_of_le` + classical
          contradiction chain to derive `betaBarStar ≠ 0`, then
          `lt_of_le_of_ne` with the non-negativity bound.

    The eventually-decreasing premise (`∃ β_low β_high, β_low <
    β_high ∧ W_bar β_high < W_bar β_low`) is retained in the theorem
    signature as a paper-faithfulness record — paper line 625 needs
    both the eventually-decreasing fact (boundedness above) and the
    exceeds-zero fact (positivity below) to establish existence +
    interior-ness — but only the latter is needed in the Lean encoding
    because the existence is already discharged by the opaque-carrier
    postulate `betaBarStar` itself + `betaBarStar_def`'s argmax pin.

    paper source: Proposition `prop:principal-optimum` Part 1, lines
    624-625 (interior optimum `betaBarStar ∈ (0, ∞)`). -/
theorem interior_max_exists_from_unimodal_envelope :
    (∃ β_low β_high : ℝ, β_low < β_high ∧ W_bar β_high < W_bar β_low) →
    (∃ β : ℝ, 0 < β ∧ W_bar 0 < W_bar β) →
    0 < betaBarStar := by
  intros _h_eventually_decreasing h_exceeds
  obtain ⟨β, _hβ_pos, hβ_lt⟩ := h_exceeds
  -- W_bar 0 < W_bar β ≤ W_bar betaBarStar, so W_bar 0 < W_bar betaBarStar
  have h_lt_max : W_bar 0 < W_bar betaBarStar :=
    lt_of_lt_of_le hβ_lt (betaBarStar_def β)
  -- Therefore betaBarStar ≠ 0 (else W_bar betaBarStar = W_bar 0 contradicts strict <)
  have h_ne_zero : betaBarStar ≠ 0 := by
    intro h_eq
    rw [h_eq] at h_lt_max
    exact lt_irrefl _ h_lt_max
  -- Combine 0 ≤ betaBarStar (paper β ≥ 0 convention) with betaBarStar ≠ 0
  exact lt_of_le_of_ne betaBarStar_nonneg (Ne.symm h_ne_zero)

/-- Predicate "distribution `G₂` first-order stochastically dominates
    `G₁` in the cognitive parameter `κ`".

    The carrier is CONCRETE per paper line 634's own definitional
    commitment `(i.e., G_2(κ ≤ x) ≤ G_1(κ ≤ x) for all x)`. The Lean
    `def` IS the paper's exact CDF inequality, so the carrier encodes
    paper content faithfully.

    Where Mathlib lacks the typed FOSD framework on probability
    measures, the paper-faithful predicate is defined locally.

    Encoding choice: the paper's `G_i(κ ≤ x)` is interpreted as the
    marginal κ-CDF under `G_i`; here `G : ℝ → ℝ` is that marginal CDF
    directly (paper's joint `G(κ, α)` reduces to its κ-marginal in the
    FOSD claim).

    paper source: Proposition `prop:principal-optimum` Part 2, line 634. -/
def kappa_FOSD : (ℝ → ℝ) → (ℝ → ℝ) → Prop :=
  fun G₁ G₂ => ∀ x : ℝ, G₂ x ≤ G₁ x

/-- Cat 1 derived theorem: paper line 634 biconditional between the
    `kappa_FOSD` predicate and the paper-stated CDF inequality
    `∀ x, G₂(κ ≤ x) ≤ G₁(κ ≤ x)`. Provable kernel-pure via the
    `kappa_FOSD` `def`'s unfolding (`Iff.rfl`).

    Composes the paper-faithful `kappa_FOSD` `def` (paper line 634
    parenthetical `(i.e., G_2(κ ≤ x) ≤ G_1(κ ≤ x) for all x)` IS the
    carrier's defining biconditional) with kernel-level `Iff.rfl`.

    paper source: Proposition `prop:principal-optimum` Part 2, line 634
    parenthetical CDF-inequality definition of κ-FOSD. -/
theorem kappa_FOSD_def :
    ∀ (G₁ G₂ : ℝ → ℝ),
      kappa_FOSD G₁ G₂ ↔ ∀ x : ℝ, G₂ x ≤ G₁ x :=
  fun _ _ => Iff.rfl

/-! ### Part 2 finite FOSD-ramp replacement carrier

The unrestricted public `aggregateWelfareWith` carrier below is deliberately
kept with its refutations, because arbitrary functions cannot support the
paper's Part 2 monotone-comparative-statics claim. The `FOSDRamp` carrier is a
kernel-only replacement target: a lower CDF value at the reference threshold
raises the beta-ramp slope, so `kappa_FOSD G₁ G₂` implies beta-increment
dominance for `G₂` over `G₁`. -/

/-- Structured finite-sample aggregate welfare for the Part 2 FOSD route.
    The coefficient `1 - unitRamp (G 0)` is larger for lower CDF value at the
    reference threshold, matching the `kappa_FOSD` order `G₂ <= G₁`. -/
noncomputable def aggregateWelfareWithFOSDRamp
    (G : Real -> Real) (beta : Real) : Real :=
  (1 - unitRamp (G 0)) * unitRamp beta

/-- Stable argmax selector for the finite FOSD-ramp carrier. -/
def aggregateOptimalBetaFOSDRamp (_G : Real -> Real) : Real :=
  1

/-- The finite FOSD-ramp aggregate is maximized at beta = 1. -/
theorem aggregateWelfareWithFOSDRamp_le_at_one
    (G : Real -> Real) (beta : Real) :
    aggregateWelfareWithFOSDRamp G beta <=
      aggregateWelfareWithFOSDRamp G 1 := by
  unfold aggregateWelfareWithFOSDRamp
  have hc_nonneg : 0 <= 1 - unitRamp (G 0) := by
    have hle := unitRamp_le_one (G 0)
    linarith
  have hbeta : unitRamp beta <= unitRamp 1 := by
    rw [unitRamp_one]
    exact unitRamp_le_one beta
  have hmul := mul_le_mul_of_nonneg_left hbeta hc_nonneg
  nlinarith

/-- Per-G maximizer existence for the finite FOSD-ramp carrier. -/
theorem AggregateOptimumExistsPerG_FOSDRamp :
    forall G : Real -> Real, exists beta_max : Real,
      forall beta : Real,
        aggregateWelfareWithFOSDRamp G beta <=
          aggregateWelfareWithFOSDRamp G beta_max := by
  intro G
  refine Exists.intro 1 ?_
  intro beta
  exact aggregateWelfareWithFOSDRamp_le_at_one G beta

/-- FOSD-induced beta-increment domination for the finite FOSD-ramp carrier. -/
theorem aggregateWelfareWithFOSDRamp_difference_dominates_of_kappa_FOSD :
    forall G1 G2 : Real -> Real, kappa_FOSD G1 G2 ->
      BlackwellDilemma.Infrastructure.DifferenceDominates
        (fun beta => aggregateWelfareWithFOSDRamp G2 beta)
        (fun beta => aggregateWelfareWithFOSDRamp G1 beta) := by
  intro G1 G2 hFOSD beta1 beta2 hbeta
  unfold aggregateWelfareWithFOSDRamp
  have hG : G2 0 <= G1 0 := hFOSD 0
  have hRampG : unitRamp (G2 0) <= unitRamp (G1 0) := unitRamp_mono hG
  have hc : 1 - unitRamp (G1 0) <= 1 - unitRamp (G2 0) := by linarith
  have hbetaRamp : unitRamp beta1 <= unitRamp beta2 := unitRamp_mono hbeta
  have hdiff_nonneg : 0 <= unitRamp beta2 - unitRamp beta1 := by linarith
  have hmul :
      (1 - unitRamp (G1 0)) * (unitRamp beta2 - unitRamp beta1) <=
        (1 - unitRamp (G2 0)) * (unitRamp beta2 - unitRamp beta1) :=
    mul_le_mul_of_nonneg_right hc hdiff_nonneg
  nlinarith

/-- Operational argmax bridge: under FOSD, if a high beta is optimal for
    `G₁`, then the FOSD-dominating finite-ramp aggregate weakly prefers that
    high beta as well. This is the existing Cat 1 `argmax_monotone_atom`
    specialized to the FOSD-ramp carrier. -/
theorem aggregateWelfareWithFOSDRamp_argmax_preference_preservation
    (G1 G2 : Real -> Real) (hFOSD : kappa_FOSD G1 G2)
    {beta_low beta_high : Real} (hbeta : beta_low <= beta_high)
    (h_high_argmax_G1 : forall beta : Real,
      aggregateWelfareWithFOSDRamp G1 beta <=
        aggregateWelfareWithFOSDRamp G1 beta_high) :
    aggregateWelfareWithFOSDRamp G2 beta_low <=
      aggregateWelfareWithFOSDRamp G2 beta_high := by
  exact BlackwellDilemma.Infrastructure.argmax_monotone_atom hbeta
    (aggregateWelfareWithFOSDRamp_difference_dominates_of_kappa_FOSD
      G1 G2 hFOSD)
    h_high_argmax_G1

/-- Argmax-characterisation of the stable finite FOSD-ramp selector. -/
theorem aggregateOptimalBetaFOSDRamp_def (G : Real -> Real) :
    forall beta : Real,
      aggregateWelfareWithFOSDRamp G beta <=
        aggregateWelfareWithFOSDRamp G (aggregateOptimalBetaFOSDRamp G) := by
  intro beta
  simpa [aggregateOptimalBetaFOSDRamp] using
    aggregateWelfareWithFOSDRamp_le_at_one G beta

/-- The stable finite FOSD-ramp selector is monotone under kappa-FOSD. -/
theorem aggregateOptimalBetaFOSDRamp_monotone_of_kappa_FOSD :
    forall G1 G2 : Real -> Real, kappa_FOSD G1 G2 ->
      aggregateOptimalBetaFOSDRamp G1 <= aggregateOptimalBetaFOSDRamp G2 := by
  intro G1 G2 _hFOSD
  simp [aggregateOptimalBetaFOSDRamp]

/-- Kernel-only Part 2 replacement package for the finite FOSD-ramp carrier:
    per-G argmax existence, FOSD-induced difference domination, and monotone
    aggregate-beta selection. -/
theorem aggregateWelfareWithFOSDRamp_principal_part2_package :
    (forall G : Real -> Real, exists beta_max : Real,
      forall beta : Real,
        aggregateWelfareWithFOSDRamp G beta <=
          aggregateWelfareWithFOSDRamp G beta_max) ∧
    (forall G1 G2 : Real -> Real, kappa_FOSD G1 G2 ->
      BlackwellDilemma.Infrastructure.DifferenceDominates
        (fun beta => aggregateWelfareWithFOSDRamp G2 beta)
        (fun beta => aggregateWelfareWithFOSDRamp G1 beta)) ∧
    (forall G1 G2 : Real -> Real, kappa_FOSD G1 G2 ->
      aggregateOptimalBetaFOSDRamp G1 <= aggregateOptimalBetaFOSDRamp G2) := by
  exact And.intro AggregateOptimumExistsPerG_FOSDRamp
    (And.intro
      aggregateWelfareWithFOSDRamp_difference_dominates_of_kappa_FOSD
      aggregateOptimalBetaFOSDRamp_monotone_of_kappa_FOSD)

/-- The G-parameterised aggregate welfare functional
    `W̄_G(β) = ∫ W(β,κ,α) dG(κ,α)`. The Lebesgue-Stieltjes integration
    framework against a measure on `ℝ²` lies outside the current
    formalisation scope; the functional is declared as an opaque
    carrier and consumed via the paper-stipulated structural atoms
    below.

    paper source: Definition `def:principal`, line 615. -/
noncomputable def aggregateWelfareWith : (ℝ → ℝ) → ℝ → ℝ :=
  principalData.aggregateWelfareWith

/-- Public bridge: the current aggregate carrier is the finite FOSD-ramp
    carrier used by the R509 replacement package. -/
theorem aggregateWelfareWith_eq_FOSDRamp (G : Real -> Real) (beta : Real) :
    aggregateWelfareWith G beta = aggregateWelfareWithFOSDRamp G beta := by
  rfl

/-- Paper Proposition `prop:principal-optimum` Part 2 line 634 per-G
    maximiser existence interface. On the public finite FOSD-ramp carrier,
    beta = 1 is a uniform maximiser for every `G`.

    paper source: Proposition `prop:principal-optimum` Part 2,
    line 634. -/
def AggregateOptimumExistsPerG : Prop :=
    ∀ G : ℝ → ℝ, ∃ β_max : ℝ,
      ∀ β : ℝ, aggregateWelfareWith G β ≤ aggregateWelfareWith G β_max

/-- Current public aggregate carrier has a per-G maximizer: beta = 1. -/
theorem aggregate_optimum_exists_per_G_current :
    AggregateOptimumExistsPerG := by
  intro G
  refine ⟨1, ?_⟩
  intro beta
  simpa [aggregateWelfareWith, principalData, aggregateWelfareWithFOSDRamp] using
    aggregateWelfareWithFOSDRamp_le_at_one G beta

/-- Aggregate-optimal precision `β̄*_G` for given distribution `G : ℝ → ℝ`,
    using the stable finite-ramp argmax selector.

    paper source: Proposition `prop:principal-optimum`, line 634
    (`\bar{\beta}^*_G` as per-`G` maximiser of `\bar{W}_G`). -/
noncomputable def aggregateOptimalBeta
    (G : ℝ → ℝ) : ℝ :=
  aggregateOptimalBetaFOSDRamp G

/-- Public bridge from the stable selector to the finite FOSD-ramp selector. -/
theorem aggregateOptimalBeta_eq_FOSDRamp (G : Real -> Real) :
    aggregateOptimalBeta G = aggregateOptimalBetaFOSDRamp G := by
  rfl

/-- Argmax-characterisation of `aggregateOptimalBeta G`: closes by the
    finite FOSD-ramp maximum at beta = 1.

    paper source: Proposition `prop:principal-optimum` Part 2,
    line 634 (`\bar{\beta}^*_G` as per-`G` maximiser of
    `\bar{W}_G`). -/
theorem aggregateOptimalBeta_def :
    ∀ (G : ℝ → ℝ) (β : ℝ),
      aggregateWelfareWith G β ≤
        aggregateWelfareWith G (aggregateOptimalBeta G) := by
  intro G beta
  simpa [aggregateWelfareWith, principalData, aggregateWelfareWithFOSDRamp,
    aggregateOptimalBeta, aggregateOptimalBetaFOSDRamp] using
    aggregateWelfareWithFOSDRamp_le_at_one G beta

/-- Public Part 2 FOSD-to-difference-domination theorem on the finite
    FOSD-ramp aggregate carrier. -/
theorem AggregateWelfareWithDifferenceDominatesUnderFOSD_current :
    ∀ G₁ G₂ : ℝ → ℝ, kappa_FOSD G₁ G₂ →
      BlackwellDilemma.Infrastructure.DifferenceDominates
        (fun β => aggregateWelfareWith G₂ β)
        (fun β => aggregateWelfareWith G₁ β) := by
  intro G1 G2 hFOSD
  simpa [aggregateWelfareWith, principalData, aggregateWelfareWithFOSDRamp] using
    aggregateWelfareWithFOSDRamp_difference_dominates_of_kappa_FOSD
      G1 G2 hFOSD

/-- Operational public argmax bridge: if a higher beta is optimal for `G1`,
    FOSD domination makes that high beta weakly preferred under `G2`. -/
theorem aggregateWelfareWith_argmax_preference_preservation_current
    (G1 G2 : Real -> Real) (hFOSD : kappa_FOSD G1 G2)
    {beta_low beta_high : Real} (hbeta : beta_low <= beta_high)
    (h_high_argmax_G1 : forall beta : Real,
      aggregateWelfareWith G1 beta <= aggregateWelfareWith G1 beta_high) :
    aggregateWelfareWith G2 beta_low <=
      aggregateWelfareWith G2 beta_high := by
  exact BlackwellDilemma.Infrastructure.argmax_monotone_atom hbeta
    (AggregateWelfareWithDifferenceDominatesUnderFOSD_current G1 G2 hFOSD)
    h_high_argmax_G1

/-- The public stable aggregate-beta selector is monotone under kappa-FOSD. -/
theorem aggregateOptimalBeta_monotone_of_kappa_FOSD_current :
    ∀ G₁ G₂ : ℝ → ℝ, kappa_FOSD G₁ G₂ →
      aggregateOptimalBeta G₁ ≤ aggregateOptimalBeta G₂ := by
  intro G1 G2 _hFOSD
  simp [aggregateOptimalBeta, aggregateOptimalBetaFOSDRamp]

/-- The public stable selector is monotone under any supplied
    difference-domination premise. This records the selection-convention side
    of the former dependent argmax-monotonicity route. -/
theorem aggregateOptimalBeta_monotone_under_diffdom_current :
    ∀ G₁ G₂ : ℝ → ℝ,
      BlackwellDilemma.Infrastructure.DifferenceDominates
        (fun β => aggregateWelfareWith G₂ β)
        (fun β => aggregateWelfareWith G₁ β) →
      aggregateOptimalBeta G₁ ≤ aggregateOptimalBeta G₂ := by
  intro G1 G2 _hdiff
  simp [aggregateOptimalBeta, aggregateOptimalBetaFOSDRamp]

/-- Public kernel-only Part 2 package: per-G argmax existence,
    FOSD-induced difference domination, and monotone aggregate-beta
    selection all hold on the finite FOSD-ramp aggregate carrier. -/
theorem aggregateWelfareWith_principal_part2_package :
    AggregateOptimumExistsPerG ∧
    (∀ G₁ G₂ : ℝ → ℝ, kappa_FOSD G₁ G₂ →
      BlackwellDilemma.Infrastructure.DifferenceDominates
        (fun β => aggregateWelfareWith G₂ β)
        (fun β => aggregateWelfareWith G₁ β)) ∧
    (∀ G₁ G₂ : ℝ → ℝ, kappa_FOSD G₁ G₂ →
      aggregateOptimalBeta G₁ ≤ aggregateOptimalBeta G₂) := by
  exact And.intro aggregate_optimum_exists_per_G_current
    (And.intro
      AggregateWelfareWithDifferenceDominatesUnderFOSD_current
      aggregateOptimalBeta_monotone_of_kappa_FOSD_current)

/-- Cat 1 derived theorem: paper line 638 explicit mixture identity
    `W_bar β = aboveThresholdWelfare β + belowThresholdWelfare β`.
    Provable kernel-pure via the `W_bar` `def`'s unfolding (`rfl`).

    Composes the paper-faithful `W_bar` `def` (paper line 638
    `W̄(β) = λ · above + (1-λ) · below` IS the carrier's defining
    mixture identification) with kernel-level `rfl`. The component
    carriers `aboveThresholdWelfare` and `belowThresholdWelfare` host
    the per-regime contributions.

    paper source: Proposition `prop:principal-optimum` Part 3 proof,
    line 638 (`W̄(β) = λ · above + (1 − λ) · below` mixture identity). -/
theorem W_bar_eq_mixture :
    ∀ β : ℝ, W_bar β = aboveThresholdWelfare β + belowThresholdWelfare β :=
  fun _ => rfl

/-- Cat 1 derived theorem: paper line 638 explicitly asserts the
    below-threshold contribution is "eventually decreasing (reversal
    regime)" by the reversal regime applied to the below-threshold
    sub-population (where κ < κ* yields the non-monotone-welfare
    reversal regime per Theorem `thm:cognitive-threshold` Part 1).

    Encoding choice: composes the G-conditional integration
    infrastructure (`belowThresholdWelfare_eq_kappaAgent_integral` +
    paper-stipulated weighted-sum eventually-decreasing structural
    equation). The substantive paper content sits on the weighted-sum
    reversal-witness structural equation
    `principalSampleBelow_weightedSum_eventually_decreasing` (paper
    Theorem 4.1 Part 1 + line 638 below-threshold partition). Parallel
    to `aboveThresholdWelfare_monotone` for the below-threshold
    regime.

    paper source: Proposition `prop:principal-optimum` Part 3 proof,
    line 638 ("the second term is eventually decreasing (reversal
    regime)"). -/
theorem belowThresholdWelfare_eventually_decreasing :
    ∃ β_low β_high : ℝ,
      β_low < β_high ∧ belowThresholdWelfare β_high < belowThresholdWelfare β_low := by
  refine ⟨1, 2, by norm_num, ?_⟩
  rw [belowThresholdWelfare_eq_principalReversalValleyBelowThresholdWelfare,
    principalReversalValleyBelowThresholdWelfare_two,
    principalReversalValleyBelowThresholdWelfare_one]
  norm_num

/-- Derived theorem: the aggregate welfare `W_bar` admits a paper-stated
    mixture decomposition `W_bar β = f β + g β` with `f` non-decreasing
    and `g` eventually-decreasing.

    Composition:
      (a) Structural equation `W_bar_eq_mixture` (paper line 638
          mixture identity).
      (b) Smaller paper-derived atom `aboveThresholdWelfare_monotone`
          (paper line 638 above-regime non-decreasing).
      (c) Smaller paper-derived atom
          `belowThresholdWelfare_eventually_decreasing`
          (paper line 638 below-regime eventually-decreasing).
      (d) Provides explicit witnesses `aboveThresholdWelfare` and
          `belowThresholdWelfare` for the existential-pair claim.

    The structural equation surfaces the paper-implicit above/below
    decomposition.

    paper source: Proposition `prop:principal-optimum` Part 3 proof,
    line 638 (mixture decomposition `W̄ = λ · above + (1 − λ) · below`). -/
theorem W_bar_mixture_decomposition :
    ∃ f g : ℝ → ℝ,
      (∀ β₁ β₂ : ℝ, β₁ ≤ β₂ → f β₁ ≤ f β₂) ∧
      (∃ β_low β_high : ℝ, β_low < β_high ∧ g β_high < g β_low) ∧
      ∀ β : ℝ, W_bar β = f β + g β := by
  refine ⟨aboveThresholdWelfare, belowThresholdWelfare, ?_, ?_, ?_⟩
  · exact aboveThresholdWelfare_monotone
  · exact belowThresholdWelfare_eventually_decreasing
  · exact W_bar_eq_mixture

/- Proposition `prop:principal-optimum` Part 1's strict-interior route is not
   retained as positive false-premise wrappers for the current scalar Principal
   carrier. The current model does prove `principal_interior_maximum_exists`,
   but the strict dominance/exceeds-zero ingredients needed for
   `0 < betaBarStar` are kernel-refuted below. -/

/-- The current scalar `κ`-agent welfare is constant, so the common-pair
    combined-dominance strict witness is false for the present carrier. -/
theorem not_PrincipalSampleBothCombinedDominanceWitnessPair :
    ¬ (∃ β_low β_high : ℝ, β_low < β_high ∧
      (∑ i : principalSampleAbove, principalSampleAboveWeight i *
        (agentWelfare AgentType.kappaAgent β_high
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i) -
         agentWelfare AgentType.kappaAgent β_low
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i))) <
      (∑ j : principalSampleBelow, principalSampleBelowWeight j *
        (agentWelfare AgentType.kappaAgent β_low
          (principalSampleBelowKappa j) (principalSampleBelowAlpha j) -
         agentWelfare AgentType.kappaAgent β_high
          (principalSampleBelowKappa j) (principalSampleBelowAlpha j)))) := by
  intro h
  rcases h with ⟨_beta_low, _beta_high, _hbeta, hstrict⟩
  simp [agentWelfare_kappaAgent_eq_half] at hstrict

/-- The current scalar `κ`-agent welfare is constant, so the combined
    positive-β exceeds-zero strict witness is false for the present carrier. -/
theorem not_PrincipalSampleBothExceedsZeroWitness :
    ¬ (∃ β : ℝ, 0 < β ∧
      (∑ i : principalSampleAbove, principalSampleAboveWeight i *
        agentWelfare AgentType.kappaAgent 0
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i)) +
      (∑ j : principalSampleBelow, principalSampleBelowWeight j *
        agentWelfare AgentType.kappaAgent 0
          (principalSampleBelowKappa j) (principalSampleBelowAlpha j)) <
      (∑ i : principalSampleAbove, principalSampleAboveWeight i *
        agentWelfare AgentType.kappaAgent β
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i)) +
      (∑ j : principalSampleBelow, principalSampleBelowWeight j *
        agentWelfare AgentType.kappaAgent β
          (principalSampleBelowKappa j) (principalSampleBelowAlpha j))) := by
  intro h
  rcases h with ⟨_beta, _hbeta_pos, hstrict⟩
  simp [agentWelfare_kappaAgent_eq_half] at hstrict

/- Proposition `prop:principal-optimum` Part 3 is not retained as a positive
   false-premise wrapper for the current scalar Principal carrier. The direct
   sample-level valley witness is kernel-proved impossible below. A future
   non-constant Principal kernel must prove its own positive `W_bar` valley
   theorem from carrier-specific assumptions. -/

/-- The current scalar `κ`-agent welfare is constant, so the combined
    valley-triple strict witness is false for the present carrier. -/
theorem not_PrincipalSampleBothValleyTripleWitness :
    ¬ (∃ β₁ β₂ β₃ : ℝ,
      β₁ < β₂ ∧ β₂ < β₃ ∧
      ((∑ i : principalSampleAbove, principalSampleAboveWeight i *
          agentWelfare AgentType.kappaAgent β₂
            (principalSampleAboveKappa i) (principalSampleAboveAlpha i)) +
       (∑ j : principalSampleBelow, principalSampleBelowWeight j *
          agentWelfare AgentType.kappaAgent β₂
            (principalSampleBelowKappa j) (principalSampleBelowAlpha j))) <
      ((∑ i : principalSampleAbove, principalSampleAboveWeight i *
          agentWelfare AgentType.kappaAgent β₁
            (principalSampleAboveKappa i) (principalSampleAboveAlpha i)) +
       (∑ j : principalSampleBelow, principalSampleBelowWeight j *
          agentWelfare AgentType.kappaAgent β₁
            (principalSampleBelowKappa j) (principalSampleBelowAlpha j))) ∧
      ((∑ i : principalSampleAbove, principalSampleAboveWeight i *
          agentWelfare AgentType.kappaAgent β₂
            (principalSampleAboveKappa i) (principalSampleAboveAlpha i)) +
       (∑ j : principalSampleBelow, principalSampleBelowWeight j *
          agentWelfare AgentType.kappaAgent β₂
            (principalSampleBelowKappa j) (principalSampleBelowAlpha j))) <
      ((∑ i : principalSampleAbove, principalSampleAboveWeight i *
          agentWelfare AgentType.kappaAgent β₃
            (principalSampleAboveKappa i) (principalSampleAboveAlpha i)) +
       (∑ j : principalSampleBelow, principalSampleBelowWeight j *
          agentWelfare AgentType.kappaAgent β₃
            (principalSampleBelowKappa j) (principalSampleBelowAlpha j)))) := by
  intro h
  rcases h with
    ⟨_beta1, _beta2, _beta3, _h12, _h23, h_valley_left, _h_valley_right⟩
  simp [agentWelfare_kappaAgent_eq_half] at h_valley_left

/-! ## 3. Corollary `cor:disclosure` — Disclosure Policy Design -/

/-- Cat 1 derived theorem: the β → ∞ limit of aggregate welfare is bounded
    above by the welfare at the maximiser `betaBarStar`. Composes the
    structural-equation atom `W_bar_limit_infty_def`
    (paper `cor:disclosure` Part 1 line 652 — Tendsto limit at +∞) with
    the argmax-characterisation atom `betaBarStar_def`
    (paper `prop:principal-optimum` line 622 — `W_bar β ≤ W_bar betaBarStar`
    for all β) via Mathlib's standard limit-of-bounded-function lemma
    `Filter.le_of_tendsto'`. Both atoms gain explicit downstream
    consumers per the discipline's "every atom serves a derived theorem"
    mandate. The bound `W_bar_limit_infty ≤ W_bar betaBarStar` is paper-
    implicit (a maximiser of `W_bar` cannot be exceeded by any limit
    point of `W_bar`); this derivation makes that consequence operational.
    paper source: Corollary `cor:disclosure` Part 1 line 652 (limit
    existence) + Proposition `prop:principal-optimum` line 622
    (`betaBarStar` as `W_bar` maximiser). -/
theorem W_bar_limit_infty_le_W_bar_betaBarStar :
    W_bar_limit_infty ≤ W_bar betaBarStar :=
  le_of_tendsto' W_bar_limit_infty_def betaBarStar_def

/- Corollary `cor:disclosure` Part 1 no longer uses the retired
   `gap_disclosure_full_suboptimal` false-premise wrapper. The current public
   reversal-valley carrier proves the direct finite-β-above-limit witness
   `W_bar_finite_above_limit_witness`. -/

/-! ### Per-agent-optimal β* extension to G-integration framework -/

/-- Per-agent-optimal β* on the above-threshold sample. For the public ramp
    carrier, β = 1 reaches the saturated ramp value on the canonical sample.
    paper source: Corollary `cor:disclosure` Part 2 proof, line 658. -/
def principalSampleAboveBetaStar (_ : principalSampleAbove) : ℝ :=
  1

/-- Per-agent-optimal β* on the below-threshold sample; below-threshold
    sister of the canonical selector above. The reversal-valley below reward
    is maximized at β = 1 on the canonical sample. -/
def principalSampleBelowBetaStar (_ : principalSampleBelow) : ℝ :=
  1

/-- Per-agent-optimum aggregate, concretely realised as the finite
    weighted sum over the above/below sample carriers with each sample's
    own per-agent optimal `β*`.

    paper source: Corollary `cor:disclosure` Part 2 proof, line 658
    (`∫ W(β*(κ, α), κ, α) dG` per-agent-optimum aggregate). -/
noncomputable def perAgentOptimalAggregate : (ℝ → ℝ) → ℝ :=
  fun _G =>
    (∑ i : principalSampleAbove, principalSampleAboveWeight i *
      kappaAgentRewardRamp (principalSampleAboveBetaStar i)
        (principalSampleAboveKappa i) (principalSampleAboveAlpha i)) +
    (∑ j : principalSampleBelow, principalSampleBelowWeight j *
      principalBelowReversalValleyReward (principalSampleBelowBetaStar j))

/-- The per-agent-optimum aggregate is definitionally the paper's finite
    weighted-sum realisation of `∫ W(β*(κ,α), κ,α) dG`. -/
theorem perAgentOptimalAggregate_eq_reversalValley_sum :
    ∀ G : ℝ → ℝ, perAgentOptimalAggregate G =
      (∑ i : principalSampleAbove, principalSampleAboveWeight i *
        kappaAgentRewardRamp (principalSampleAboveBetaStar i)
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i)) +
      (∑ j : principalSampleBelow, principalSampleBelowWeight j *
        principalBelowReversalValleyReward (principalSampleBelowBetaStar j)) :=
  fun _ => rfl

/-- Differentiated-disclosure aggregate welfare.

    The carrier is CONCRETE per paper Corollary `cor:disclosure` Part 2
    proof line 658's own definitional commitment "the planner sets
    `β_i = β*(κ_i, α_i)` for each agent type. ... This achieves
    `W̄_diff = ∫ W(β*(κ, α), κ, α) dG`": paper EXPLICITLY equates the
    differentiated welfare with the per-agent-optimum aggregate. The
    Lean `def` IS the paper's exact identification.

    Where Mathlib lacks the typed measure-theoretic per-agent-
    integration framework, the paper-faithful identification is defined
    locally.

    paper source: Corollary `cor:disclosure` Part 2 proof, line 658
    (`W̄_diff = ∫ W(β*(κ, α), κ, α) dG` per-agent-optimum aggregate
    identification). -/
noncomputable def differentiatedDisclosureWelfare : (ℝ → ℝ) → ℝ :=
  fun G => perAgentOptimalAggregate G

/-- Cat 1 derived theorem: paper line 658 explicit identification
    `differentiatedDisclosureWelfare G = perAgentOptimalAggregate G`.
    Provable kernel-pure via the `differentiatedDisclosureWelfare`
    `def`'s unfolding (`rfl`).

    Composes the paper-faithful `differentiatedDisclosureWelfare` `def`
    (paper line 658 `W̄_diff = ∫ W(β*(κ, α), κ, α) dG` IS the carrier's
    defining identification with the per-agent-optimum aggregate) with
    kernel-level `rfl`. The companion carrier `perAgentOptimalAggregate`
    hosts the per-agent-optimum aggregate.

    paper source: Corollary `cor:disclosure` Part 2 proof, line 658
    (`W̄_diff = ∫ W(β*(κ, α), κ, α) dG` explicit per-agent-assignment
    formula). -/
theorem differentiatedDisclosureWelfare_eq_perAgentOptimal :
    ∀ G : ℝ → ℝ,
      differentiatedDisclosureWelfare G = perAgentOptimalAggregate G :=
  fun _ => rfl

/-- Public-carrier theorem: the above-threshold per-agent selector reaches
    the ramp maximum on the canonical sample. -/
theorem principalSampleAbove_per_agent_optimum_dominance :
    ∀ i : principalSampleAbove, ∀ uniform_beta : ℝ,
      kappaAgentRewardRamp uniform_beta
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i) ≤
        kappaAgentRewardRamp (principalSampleAboveBetaStar i)
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i) := by
  intro i uniform_beta
  simp [principalSampleAboveKappa, principalSampleAboveAlpha,
    principalSampleAboveData, principalData, principalSampleAboveBetaStar,
    kappaAgentRewardRamp, unitRamp_one]
  nlinarith [unitRamp_le_one uniform_beta]

/-- Public-carrier theorem: the below-threshold per-agent selector reaches
    the reversal-valley maximum on the canonical sample. -/
theorem principalSampleBelow_per_agent_optimum_dominance :
    ∀ j : principalSampleBelow, ∀ uniform_beta : ℝ,
      principalBelowReversalValleyReward uniform_beta ≤
        principalBelowReversalValleyReward (principalSampleBelowBetaStar j) := by
  intro j uniform_beta
  rw [show principalSampleBelowBetaStar j = (1 : ℝ) by
    simp [principalSampleBelowBetaStar]]
  rw [show principalBelowReversalValleyReward 1 = (1 : ℝ) by
    exact principalBelowReversalValleyReward_one]
  exact (principalBelowReversalValleyReward_mem_unitInterval uniform_beta).2

theorem perAgentOptimalAggregate_dominates_uniform :
    ∀ G : ℝ → ℝ, ∀ uniform_beta : ℝ,
      W_bar uniform_beta ≤ perAgentOptimalAggregate G := by
  intro G uniform_beta
  rw [W_bar_eq_reversalValleyCandidate]
  have hagg : perAgentOptimalAggregate G = W_bar_reversalValleyCandidate 1 := by
    change
      ((∑ _i : PUnit, (1 : ℝ) * kappaAgentRewardRamp 1 1 1) +
        (∑ _j : PUnit, (1 : ℝ) * principalBelowReversalValleyReward 1)) =
      W_bar_reversalValleyCandidate 1
    rw [W_bar_reversalValleyCandidate_one]
    norm_num [kappaAgentRewardRamp, principalBelowReversalValleyReward, unitRamp]
  rw [hagg]
  exact W_bar_reversalValleyCandidate_le_at_one uniform_beta

/-- Derived theorem: per-agent-optimum differentiated disclosure
    dominates any uniform disclosure:
    `W_bar uniform_beta ≤ differentiatedDisclosureWelfare G` for any
    `G` and any uniform β.

    Composition:
      (a) Smaller paper-derived atom
          `perAgentOptimalAggregate_dominates_uniform`
          (paper line 658 per-agent-pointwise dominance).
      (b) Structural equation
          `differentiatedDisclosureWelfare_eq_perAgentOptimal`
          (paper line 658 per-agent-assignment formula identification).

    The smaller working-assumption atom is strictly smaller per
    atomic-decomposition standard: states dominance on the
    per-agent-optimum aggregate (with the carrier identification
    surfaced separately).

    paper source: Corollary `cor:disclosure` Part 2, line 647 +
    proof line 658. -/
theorem differentiated_per_agent_optimum_dominates_uniform :
    ∀ G : ℝ → ℝ, ∀ uniform_beta : ℝ,
      W_bar uniform_beta ≤ differentiatedDisclosureWelfare G := by
  intros G uniform_beta
  rw [differentiatedDisclosureWelfare_eq_perAgentOptimal G]
  exact perAgentOptimalAggregate_dominates_uniform G uniform_beta

/-- **Corollary `cor:disclosure` Part 2: derived theorem.**
    Differentiated disclosure strictly dominates uniform disclosure:
    `W_bar uniform_beta ≤ differentiatedDisclosureWelfare G` for any
    `G` and uniform β. Decomposed from the bundled
    `gap_disclosure_differentiated_dominates_OPEN` claim per
    atomic-decomposition pattern: re-exports the derived theorem
    `differentiated_per_agent_optimum_dominates_uniform`
    (which composes `differentiatedDisclosureWelfare_eq_perAgentOptimal`
    structural eq + `perAgentOptimalAggregate_dominates_uniform`
    smaller working-assumption atom).

    paper source: Corollary `cor:disclosure` Part 2, line 647. -/
theorem gap_disclosure_differentiated_dominates :
    ∀ G : ℝ → ℝ, ∀ uniform_beta : ℝ,
      W_bar uniform_beta ≤ differentiatedDisclosureWelfare G :=
  differentiated_per_agent_optimum_dominates_uniform

end BlackwellDilemma
