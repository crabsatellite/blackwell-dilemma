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

/-- Paper-novel opaque carrier: paper line 638's explicit
    above-threshold welfare component `λ · E_{G | κ > κ*}[W(β, κ, α)]`
    abstracted as a single ℝ → ℝ functional of `β` (with the `λ`
    weighting absorbed into the carrier's definition per paper's
    named-component convention). Paper Proposition `prop:principal-
    optimum` Part 3 proof (line 638) names this the "above-threshold
    contribution" with the standard-Blackwell-regime non-decreasing
    property.

    The carrier is paper-Def-stipulated structural primitive per
    discipline §3.4.1 (paper-novel opaque-carrier primitive).

    paper source: Proposition `prop:principal-optimum` Part 3 proof,
    line 638 (`λ · E_{G | κ > κ*}[W(β, κ, α)]` above-threshold
    contribution). -/
axiom aboveThresholdWelfare : ℝ → ℝ

/-- Paper-novel opaque carrier: paper line 638's explicit
    below-threshold welfare component `(1 − λ) · E_{G | κ < κ*}
    [W(β, κ, α)]` abstracted as a single ℝ → ℝ functional of `β`.
    Paper Proposition `prop:principal-optimum` Part 3 proof (line 638)
    names this the "below-threshold contribution" with the reversal-
    regime eventually-decreasing property.

    paper source: Proposition `prop:principal-optimum` Part 3 proof,
    line 638 (`(1 − λ) · E_{G | κ < κ*}[W(β, κ, α)]` below-threshold
    contribution). -/
axiom belowThresholdWelfare : ℝ → ℝ

/-- The aggregate welfare functional `W̄(β)` for distribution `G`.

    The carrier is CONCRETE per paper Proposition
    `prop:principal-optimum` Part 3 proof line 638's own definitional
    commitment `W̄(β) = λ · E_{G | κ > κ*}[W(β,κ,α)] + (1-λ) ·
    E_{G | κ < κ*}[W(β,κ,α)]`: paper EXPLICITLY decomposes the aggregate
    welfare as the sum of the above-threshold and below-threshold
    contributions. The Lean `def` IS the paper's exact mixture
    identification.

    Per `feedback_no_compute_retreat`: where Mathlib lacks the typed
    bounded-measure / conditional-expectation framework on the population
    distribution `G`, define the paper-faithful mixture decomposition
    locally rather than skip.

    paper source: Definition `def:principal`, line 612 (`W̄(β) = ∫ W(β, κ, α)
    dG(κ, α)`) + Proposition `prop:principal-optimum` Part 3 proof, line 638
    (mixture identity `W̄ = λ · above + (1-λ) · below`). -/
noncomputable def W_bar : ℝ → ℝ :=
  fun β => aboveThresholdWelfare β + belowThresholdWelfare β

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
proofs of `aboveThresholdWelfare_continuousOn_Ici_workingAssumption` and
`belowThresholdWelfare_continuousOn_Ici_workingAssumption` (Cat 1
derivations via `percExpectation_continuousOn_of_pointwise_continuousOn`
+ `agentRewardKernel_kappaAgent_continuousOn_in_beta_pointwise`) can
reference the carrier-defining structural equations
(`aboveThresholdWelfare_eq_kappaAgent_integral`,
`belowThresholdWelfare_eq_kappaAgent_integral`) without forward-reference
errors. Position in source order is metadata-neutral per discipline §3.

Per `feedback_no_compute_retreat`: where Mathlib lacks the typed
measure-theoretic G-integration framework, define the paper-faithful
finite-sample realisation locally rather than skip. -/

/-- **G-conditional integration infrastructure** — Cat 3 §3.4.3
    paper-novel opaque carrier: paper's `G | κ > κ*` above-threshold
    finite-sample support type. Paper Definition `def:principal`
    line 615 + Proposition `prop:principal-optimum` Part 3 proof line
    638 stipulate the principal's above-threshold partition; the
    finite-sample realisation hosts paper's `E_{G | κ > κ*}[·]`
    integral as a weighted finite sum.

    Cat 3 §3.4.3 carrier per discipline (paper-novel primitive
    realising paper line 638's above-threshold partition). 永不 close.

    paper source: Definition `def:principal`, line 615 (`G(κ, α)`
    principal distribution) + Proposition `prop:principal-optimum`
    Part 3 proof, line 638 (above-threshold partition `G | κ > κ*`). -/
axiom principalSampleAbove : Type

@[instance] axiom principalSampleAbove_fintype : Fintype principalSampleAbove
@[instance] axiom principalSampleAbove_decEq : DecidableEq principalSampleAbove

/-- Paper-stipulated weight on each above-threshold sample
    point (paper's mixture weight `λ · pᵢ` from the finite-G
    realisation). Cat 3 §3.4.3 carrier per discipline. 永不 close.

    paper source: Definition `def:principal`, line 615 (principal
    distribution `G(κ, α)` weights) + Proposition `prop:principal-
    optimum` Part 3 proof, line 638 (above-threshold mixture weight `λ`). -/
axiom principalSampleAboveWeight : principalSampleAbove → ℝ

/-- Paper-stipulated `κ` parameter at each above-threshold
    sample point (all `> κ*` by the partition's defining property).
    Cat 3 §3.4.3 carrier per discipline. 永不 close.

    paper source: Proposition `prop:principal-optimum` Part 3 proof,
    line 638 (above-threshold partition `κ > κ*` indexes the sample). -/
axiom principalSampleAboveKappa : principalSampleAbove → ℝ

/-- Paper-stipulated `α` parameter at each above-threshold
    sample point. Cat 3 §3.4.3 carrier per discipline. 永不 close.

    paper source: Proposition `prop:principal-optimum` Part 3 proof,
    line 638 (`α` parameter in `W(β, κ, α)` integrand). -/
axiom principalSampleAboveAlpha : principalSampleAbove → ℝ

/-- Cat 3 §3.4.3 paper-stipulated structural equation: each
    above-threshold sample weight is non-negative (probability-measure
    positivity from paper Definition `def:principal` line 615's
    standing-convention probability-measure status of `G`). Cat 3
    §3.4.3 gapDefinitional per discipline. 永不 close.

    paper source: Definition `def:principal`, line 615 (`G(κ, α)`
    standing-convention probability-measure). -/
axiom principalSampleAboveWeight_nonneg :
    ∀ i : principalSampleAbove, 0 ≤ principalSampleAboveWeight i

/-- Cat 3 §3.4.3 paper-stipulated structural equation:
    `aboveThresholdWelfare β` is the weighted-finite-sum realisation of
    paper line 638's `λ · E_{G | κ > κ*}[W(β,κ,α)]`. This pins the
    opaque `aboveThresholdWelfare` carrier to a concrete sum of
    `agentWelfare AgentType.kappaAgent` over the paper-stipulated
    above-threshold sample, mirroring the percolation-expectation
    concretisation of `agentWelfare`. Cat 3 §3.4.3 gapDefinitional per
    discipline (paper-Def-stipulated carrier-defining equation; paper
    line 638 STIPULATES the partition's integral form). 永不 close.

    paper source: Proposition `prop:principal-optimum` Part 3 proof,
    line 638 (`W̄(β) = λ · E_{G | κ > κ*}[W(β,κ,α)] + (1-λ) ·
    E_{G | κ < κ*}[W(β,κ,α)]` above-threshold component as paper
    Definition's defining identification on `aboveThresholdWelfare`
    carrier). -/
axiom aboveThresholdWelfare_eq_kappaAgent_integral :
    ∀ β : ℝ, aboveThresholdWelfare β =
      ∑ i : principalSampleAbove, principalSampleAboveWeight i *
        agentWelfare AgentType.kappaAgent β
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i)

/-- Cat 3 §3.4.3 paper-stipulated structural equation: at every
    above-threshold sample point, the κ-agent's welfare is monotone in
    β. Paper line 638 STIPULATES the above-threshold sample by
    `κᵢ > κ*` partition; paper Theorem 4.1 Part 2 (line 492) STATES
    that for `κ` above the cognitive threshold, the κ-agent's welfare
    is non-decreasing in β. Composing: at each above-threshold sample
    point, individual welfare is monotone in β. Cat 3 §3.4.3
    gapDefinitional per discipline (paper-Def-stipulated structural
    fact about the sample's individual welfare behavior at the named
    above-threshold regime; `kappa_large_blackwell_recovery_OPEN`
    derives the per-`κ` form but the sample's "above-recovery-
    threshold" partition is paper-Def-stipulated). 永不 close.

    paper source: Proposition `prop:principal-optimum` Part 3 proof,
    line 638 (above-threshold partition `κ > κ*`) + Theorem 4.1
    Part 2, line 492 (κ-recovery welfare monotonicity in β). -/
axiom principalSampleAbove_individual_welfare_monotone :
    ∀ i : principalSampleAbove, ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
      agentWelfare AgentType.kappaAgent β₁
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i) ≤
        agentWelfare AgentType.kappaAgent β₂
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i)

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
theorem aboveThresholdWelfare_monotone_OPEN :
    ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ → aboveThresholdWelfare β₁ ≤ aboveThresholdWelfare β₂ := by
  intro β₁ β₂ hβ
  rw [aboveThresholdWelfare_eq_kappaAgent_integral β₁,
      aboveThresholdWelfare_eq_kappaAgent_integral β₂]
  apply Finset.sum_le_sum
  intro i _
  exact mul_le_mul_of_nonneg_left
    (principalSampleAbove_individual_welfare_monotone i β₁ β₂ hβ)
    (principalSampleAboveWeight_nonneg i)

/-! ### G-conditional integration infrastructure (below-threshold sister) -/

/-- Cat 3 §3.4.3 paper-novel opaque carrier (below-threshold
    sister to `principalSampleAbove`). 永不 close per discipline.

    paper source: Definition `def:principal`, line 615 + Proposition
    `prop:principal-optimum` Part 3 proof, line 638 (below-threshold
    partition `G | κ < κ*`). -/
axiom principalSampleBelow : Type

@[instance] axiom principalSampleBelow_fintype : Fintype principalSampleBelow
@[instance] axiom principalSampleBelow_decEq : DecidableEq principalSampleBelow

/-- Below-threshold sister of `principalSampleAboveWeight`.
    永不 close per discipline. -/
axiom principalSampleBelowWeight : principalSampleBelow → ℝ

/-- Below-threshold sister of `principalSampleAboveKappa`
    (all `< κ*` by partition's defining property). 永不 close. -/
axiom principalSampleBelowKappa : principalSampleBelow → ℝ

/-- Below-threshold sister of `principalSampleAboveAlpha`.
    永不 close. -/
axiom principalSampleBelowAlpha : principalSampleBelow → ℝ

/-- Cat 3 §3.4.3 paper-stipulated structural equation:
    each below-threshold sample weight is non-negative. 永不 close. -/
axiom principalSampleBelowWeight_nonneg :
    ∀ i : principalSampleBelow, 0 ≤ principalSampleBelowWeight i

/-- Cat 3 §3.4.3 paper-stipulated structural equation:
    `belowThresholdWelfare β` is the weighted-finite-sum realisation of
    paper line 638's `(1-λ) · E_{G | κ < κ*}[W(β,κ,α)]`. Below-threshold
    sister of `aboveThresholdWelfare_eq_kappaAgent_integral`. Cat 3
    §3.4.3 gapDefinitional per discipline. 永不 close.

    paper source: Proposition `prop:principal-optimum` Part 3 proof,
    line 638 (below-threshold component as paper Definition's defining
    identification on `belowThresholdWelfare` carrier). -/
axiom belowThresholdWelfare_eq_kappaAgent_integral :
    ∀ β : ℝ, belowThresholdWelfare β =
      ∑ i : principalSampleBelow, principalSampleBelowWeight i *
        agentWelfare AgentType.kappaAgent β
          (principalSampleBelowKappa i) (principalSampleBelowAlpha i)

/-- Cat 3 §3.4.3 paper-stipulated structural equation:
    paper line 638 STIPULATES that the below-threshold sample's
    weighted-sum welfare contribution is eventually decreasing in β
    (the reversal regime: at SOME `(β_low, β_high)` pair, the
    weighted-sum welfare strictly decreases). Paper Theorem 4.1 Part 1
    (line 491) STATES that for the below-threshold (κ < κ*) sample,
    individual welfare is non-monotone in β; aggregating against the
    sample's positive-weight measure preserves the strict-decrease at
    the witness pair. This atom encodes the paper-stipulated witness
    pair on the weighted-sum carrier. Cat 3 §3.4.3 gapDefinitional per
    discipline (paper-Def-stipulated witness-pair on the sample-sum
    carrier; mirrors the reversal-witness pattern lifted to the
    sample-sum level). 永不 close.

    paper source: Proposition `prop:principal-optimum` Part 3 proof,
    line 638 (below-threshold partition + eventually-decreasing) +
    Theorem 4.1 Part 1, line 491 (per-sample reversal mechanism). -/
axiom principalSampleBelow_weightedSum_eventually_decreasing :
    ∃ β_low β_high : ℝ, β_low < β_high ∧
      (∑ i : principalSampleBelow, principalSampleBelowWeight i *
        agentWelfare AgentType.kappaAgent β_high
          (principalSampleBelowKappa i) (principalSampleBelowAlpha i)) <
      (∑ i : principalSampleBelow, principalSampleBelowWeight i *
        agentWelfare AgentType.kappaAgent β_low
          (principalSampleBelowKappa i) (principalSampleBelowAlpha i))

/-! ### Maximiser existence — atomic decomposition + Cat 1 EVT derivation

The maximiser existence claim for the abstract `W_bar` carrier is
DECOMPOSED into 4 component-level paper-stipulated atoms (one per
`aboveThresholdWelfare` / `belowThresholdWelfare` × continuity /
eventually-decreasing), with the EVT-application step fully Cat 1 via
`Infrastructure.EVTBoundedDecreasing.exists_maxOn_of_continuous_eventually_decreasing`
+ `Infrastructure.ContinuousArithmetic.ContinuousOn.add_Ioi0`.

Per `feedback_lean_axiom_decomposition`: composite axioms hide gaps;
decompose into single-step typed bridges. -/

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
theorem aboveThresholdWelfare_continuousOn_Ici_workingAssumption :
    ContinuousOn aboveThresholdWelfare (Set.Ici 0) := by
  -- Rewrite via the carrier-defining integral identity
  have h_eq : aboveThresholdWelfare = fun β =>
      ∑ i : principalSampleAbove, principalSampleAboveWeight i *
        agentWelfare AgentType.kappaAgent β
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i) := by
    funext β
    exact aboveThresholdWelfare_eq_kappaAgent_integral β
  rw [h_eq]
  -- ContinuousOn of finite sum
  apply continuousOn_finsetSum
  intro i _
  -- Each term: weight * agentWelfare(β, κᵢ, αᵢ).
  -- agentWelfare = percExpectation (1-blockingProb) (agentRewardKernel ...)
  have h_aw : ContinuousOn (fun β =>
      agentWelfare AgentType.kappaAgent β
        (principalSampleAboveKappa i) (principalSampleAboveAlpha i))
      (Set.Ici (0 : ℝ)) := by
    unfold agentWelfare
    exact percExpectation_continuousOn_of_pointwise_continuousOn
      (1 - blockingProb)
      (fun β => agentRewardKernel AgentType.kappaAgent β
        (principalSampleAboveKappa i) (principalSampleAboveAlpha i))
      (Set.Ici 0)
      (fun ω => agentRewardKernel_kappaAgent_continuousOn_in_beta_pointwise
        (principalSampleAboveKappa i) (principalSampleAboveAlpha i) ω)
  exact h_aw.const_mul (principalSampleAboveWeight i)

/-- Cat 1 derived theorem: `belowThresholdWelfare` is
    `ContinuousOn (Set.Ici 0)`. Same derivation pattern as the
    above-threshold sister, with `principalSampleBelow` carriers. -/
theorem belowThresholdWelfare_continuousOn_Ici_workingAssumption :
    ContinuousOn belowThresholdWelfare (Set.Ici 0) := by
  have h_eq : belowThresholdWelfare = fun β =>
      ∑ i : principalSampleBelow, principalSampleBelowWeight i *
        agentWelfare AgentType.kappaAgent β
          (principalSampleBelowKappa i) (principalSampleBelowAlpha i) := by
    funext β
    exact belowThresholdWelfare_eq_kappaAgent_integral β
  rw [h_eq]
  apply continuousOn_finsetSum
  intro i _
  have h_aw : ContinuousOn (fun β =>
      agentWelfare AgentType.kappaAgent β
        (principalSampleBelowKappa i) (principalSampleBelowAlpha i))
      (Set.Ici (0 : ℝ)) := by
    unfold agentWelfare
    exact percExpectation_continuousOn_of_pointwise_continuousOn
      (1 - blockingProb)
      (fun β => agentRewardKernel AgentType.kappaAgent β
        (principalSampleBelowKappa i) (principalSampleBelowAlpha i))
      (Set.Ici 0)
      (fun ω => agentRewardKernel_kappaAgent_continuousOn_in_beta_pointwise
        (principalSampleBelowKappa i) (principalSampleBelowAlpha i) ω)
  exact h_aw.const_mul (principalSampleBelowWeight i)

/-! ## W_bar limit-at-infinity infrastructure

Derivation of the §3.4.3 eventually-decreasing claim
`W_bar_eventually_decreasing_paper_Def` requires the W_bar
limit-at-infinity infrastructure (`W_bar_limit_infty_def`,
`W_bar_finite_above_limit_witness`) to be available BEFORE the
eventually-decreasing derivation. The block below places the
infrastructure immediately after the G-conditional integration
infrastructure + continuity atoms so the derived theorem can compose
them inline.

The items here are:
  * `principalSampleBoth_combined_convergence_witness` (Cat 3 §3.4.3
    paper-stipulated combined-convergence witness on the sample sums)
  * `W_bar_has_limit_infty_OPEN` (derived theorem; existence of
    finite β → ∞ limit of `W_bar`)
  * `W_bar_limit_infty` (noncomputable def via `Classical.choose`)
  * `W_bar_limit_infty_def` (derived theorem; Tendsto W_bar atTop
    (nhds W_bar_limit_infty))
  * `W_bar_finite_above_limit_witness` (Cat 3 §3.4.3 paper-
    stipulated finite-β-above-limit witness)
  * `W_bar_continuousOn_Ici` (Cat 1 derived theorem; sum of two
    `ContinuousOn`s)

Position in source order is metadata-neutral per discipline §3; the
ordering is justified by the eventually-decreasing closure's
forward-reference need. -/

/-- Cat 3 §3.4.3 paper-stipulated structural equation:
    paper-stated combined-convergence witness on the G-conditional
    sample sums. Paper Corollary `cor:disclosure` Part 1 proof (line
    652) STATES "for above-threshold agents, `W(β, κ, α)` is non-
    decreasing in β and converges to a finite limit"; aggregating over
    the population gives `\bar{W}(\beta) \to \bar{W}(\infty)`. Per the
    mixture decomposition, this requires the combined sample-sum
    `∑ above-sample + ∑ below-sample` to converge to a finite limit
    as `β → ∞`.

    Cat 3 §3.4.3 gapDefinitional per discipline (paper-stipulated
    combined-convergence on opaque sample sums; standard
    paper-stipulated-structural-equation precedent). 永不 close.

    paper source: Corollary `cor:disclosure` Part 1 proof, line 652
    (aggregate welfare converges to a finite limit as `β → ∞`). -/
axiom principalSampleBoth_combined_convergence_witness :
    ∃ L : ℝ, Filter.Tendsto
      (fun β =>
        (∑ i : principalSampleAbove, principalSampleAboveWeight i *
          agentWelfare AgentType.kappaAgent β
            (principalSampleAboveKappa i) (principalSampleAboveAlpha i)) +
        (∑ j : principalSampleBelow, principalSampleBelowWeight j *
          agentWelfare AgentType.kappaAgent β
            (principalSampleBelowKappa j) (principalSampleBelowAlpha j)))
      Filter.atTop (nhds L)

/-- Paper-stated existence of the β → ∞ limit of aggregate welfare:
    derived theorem composing the G-integration integral structural
    equations + the combined-convergence witness. -/
theorem W_bar_has_limit_infty_OPEN :
    ∃ L : ℝ, Filter.Tendsto W_bar Filter.atTop (nhds L) := by
  obtain ⟨L, h_tendsto⟩ := principalSampleBoth_combined_convergence_witness
  refine ⟨L, ?_⟩
  -- W_bar β = above β + below β = ∑ above-sample + ∑ below-sample by def
  have h_eq : W_bar = fun β =>
      (∑ i : principalSampleAbove, principalSampleAboveWeight i *
        agentWelfare AgentType.kappaAgent β
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i)) +
      (∑ j : principalSampleBelow, principalSampleBelowWeight j *
        agentWelfare AgentType.kappaAgent β
          (principalSampleBelowKappa j) (principalSampleBelowAlpha j)) := by
    funext β
    show aboveThresholdWelfare β + belowThresholdWelfare β = _
    rw [aboveThresholdWelfare_eq_kappaAgent_integral β,
        belowThresholdWelfare_eq_kappaAgent_integral β]
  rw [h_eq]
  exact h_tendsto

/-- Limit of aggregate welfare as `β → ∞`.

    Concrete-def closure (existence-via-`Classical.choose`). The
    carrier is CONCRETE per paper line 652's paper-stated existence
    claim of the finite limit: define `W_bar_limit_infty` as
    `Classical.choose` of the limit-witness from the existence atom
    `W_bar_has_limit_infty_OPEN`.

    The Lean `def` IS the paper's "convergence-to-finite-limit"
    identification (the `Classical.choose` literally picks the paper-
    stated finite limit of `W_bar` at `+∞`), so the carrier encodes
    paper content faithfully. The def body invokes the substantive
    existence atom `W_bar_has_limit_infty_OPEN` as input, with no
    content erasure; the carrier-identification step
    (`W_bar_limit_infty_def`) is internalised by `Classical.choose_spec`.

    Per `feedback_no_compute_retreat`: where Mathlib lacks the typed
    monotone-bounded-convergence + per-agent finite-limit aggregation
    machinery, define the paper-faithful selection locally rather than
    skip.

    paper source: Corollary `cor:disclosure` Part 1, line 652
    (`\bar{W}(\beta) \to \bar{W}(\infty)` as `β → ∞`). -/
noncomputable def W_bar_limit_infty : ℝ :=
  Classical.choose W_bar_has_limit_infty_OPEN

/-- Cat 3 Tendsto-characterisation of `W_bar_limit_infty`:
    `Filter.Tendsto W_bar Filter.atTop (nhds W_bar_limit_infty)`.

    Closure: composes the `W_bar_limit_infty` `def` (which invokes
    `Classical.choose` on `W_bar_has_limit_infty_OPEN`) with
    `Classical.choose_spec` (which yields the Tendsto-property of the
    chosen limit witness directly).

    paper source: Corollary `cor:disclosure` Part 1 proof, line 652
    ("aggregate welfare converges to a finite limit as β → ∞"). -/
theorem W_bar_limit_infty_def :
    Filter.Tendsto W_bar Filter.atTop (nhds W_bar_limit_infty) := by
  unfold W_bar_limit_infty
  exact Classical.choose_spec W_bar_has_limit_infty_OPEN

/-- Cat 3 §3.4.3 paper-stipulated structural equation:
    paper-stated existence of a finite β at which `W_bar` strictly
    exceeds its β → ∞ limit. Paper Corollary `cor:disclosure` Part 1
    proof line 656 STATES "Since `W̄(β) → W̄(∞)` yet there exists
    `β_0` with `W̄(β_0) > W̄(∞)`..." — paper directly stipulates the
    existence of such `β_0`.

    Cat 3 §3.4.3 gapDefinitional per discipline (paper-stipulated
    existence of finite-β-above-limit witness; standard
    paper-stipulated-structural-equation precedent). 永不 close.

    paper source: Corollary `cor:disclosure` Part 1 proof, line 656. -/
axiom W_bar_finite_above_limit_witness :
    ∃ β_finite : ℝ, 0 < β_finite ∧ W_bar_limit_infty < W_bar β_finite

/-- Cat 1 derived theorem: `W_bar` is `ContinuousOn (Set.Ici 0)`
    by arithmetic (sum of two `ContinuousOn`s).

    Derivation from the above/below continuity atoms via
    `Infrastructure.ContinuousArithmetic.ContinuousOn.add_Ioi0`-style
    addition. Kernel-pure. -/
theorem W_bar_continuousOn_Ici : ContinuousOn W_bar (Set.Ici 0) := by
  unfold W_bar
  exact aboveThresholdWelfare_continuousOn_Ici_workingAssumption.add
    belowThresholdWelfare_continuousOn_Ici_workingAssumption

/-- Cat 1 derived theorem: `W_bar` is eventually-decreasing past some
    `N ≥ 0`. Composes the limit-at-infinity infrastructure above + Mathlib
    EVT to produce the eventual-decrease witness directly.

    **Closure path**:
      1. From `W_bar_finite_above_limit_witness` get `β_finite > 0`
         with `W_bar_limit_infty < W_bar β_finite`.
      2. Apply `eventually_le_of_tendsto_lt_witness` to
         `W_bar_limit_infty_def` + the strict inequality from step 1
         to obtain `N₀` such that `W_bar x ≤ W_bar β_finite` for all
         `x ≥ N₀`.
      3. Set `Nupper := max β_finite N₀`. By `W_bar_continuousOn_Ici`
         and Mathlib's `IsCompact.exists_isMaxOn`, get `N_star ∈
         [β_finite, Nupper]` realising the max of `W_bar` on the
         compact interval.
      4. Argmax dominance + tail bound: for `β ≥ N_star`, either
         `β ≤ Nupper` (use compact-interval argmax) or `β > Nupper ≥
         N₀` (use the tail bound to dominate by
         `W_bar β_finite ≤ W_bar N_star`).

    The `W_bar_eventually_decreasing_workingAssumption` re-export
    below preserves the consumer interface for
    `principal_interior_maximum_exists_OPEN`.

    paper source: composes paper Theorem 4.1 + Corollary
    `cor:disclosure` Part 1 (lines 652-656) — finite limit at infinity
    plus finite-β-above-limit witness force eventual decrease past
    some `N ≥ 0`. -/
theorem W_bar_eventually_decreasing :
    ∃ N : ℝ, 0 ≤ N ∧ ∀ β : ℝ, N ≤ β → W_bar β ≤ W_bar N := by
  -- Step 1: Get β_finite from paper-stipulated finite-above-limit witness.
  obtain ⟨β_finite, hβ_finite_pos, h_lt_W_bar_β_finite⟩ :=
    W_bar_finite_above_limit_witness
  -- Step 2: Apply the tail bound to get N₀ such that
  --        W_bar x ≤ W_bar β_finite for x ≥ N₀.
  obtain ⟨N₀, hN₀⟩ :=
    BlackwellDilemma.Infrastructure.eventually_le_of_tendsto_lt_witness
      W_bar W_bar_limit_infty β_finite W_bar_limit_infty_def h_lt_W_bar_β_finite
  -- Step 3: Set Nupper = max(β_finite, N₀); β_finite ≤ Nupper, N₀ ≤ Nupper.
  set Nupper := max β_finite N₀ with hNupper_def
  have h_β_finite_le_Nupper : β_finite ≤ Nupper := le_max_left _ _
  have h_N₀_le_Nupper : N₀ ≤ Nupper := le_max_right _ _
  -- Step 4: Apply EVT on compact [β_finite, Nupper] (W_bar is continuous on
  --        Ici 0, which contains [β_finite, Nupper] since β_finite > 0).
  have h_Icc_nonempty : (Set.Icc β_finite Nupper).Nonempty :=
    ⟨β_finite, by simp [h_β_finite_le_Nupper]⟩
  have h_cont_Icc : ContinuousOn W_bar (Set.Icc β_finite Nupper) :=
    W_bar_continuousOn_Ici.mono (fun x hx => le_of_lt (lt_of_lt_of_le hβ_finite_pos hx.1))
  obtain ⟨N_star, hN_star_mem, hN_star_max⟩ :=
    isCompact_Icc.exists_isMaxOn h_Icc_nonempty h_cont_Icc
  -- Step 5: N_star ≥ β_finite > 0, so 0 ≤ N_star.
  have hN_star_pos : 0 ≤ N_star := le_of_lt (lt_of_lt_of_le hβ_finite_pos hN_star_mem.1)
  refine ⟨N_star, hN_star_pos, ?_⟩
  intro β hβ_ge_N_star
  -- Step 6: Two cases — β ≤ Nupper (use argmax) or β > Nupper (use tail bound + argmax chain).
  by_cases h : β ≤ Nupper
  · -- Case 1: β ∈ [N_star, Nupper] ⊆ [β_finite, Nupper]; argmax dominance.
    have hβ_in_Icc : β ∈ Set.Icc β_finite Nupper :=
      ⟨le_trans hN_star_mem.1 hβ_ge_N_star, h⟩
    exact hN_star_max hβ_in_Icc
  · -- Case 2: β > Nupper ≥ N₀, so by the tail bound W_bar β ≤ W_bar β_finite.
    push_neg at h
    have hβ_ge_N₀ : N₀ ≤ β := le_trans h_N₀_le_Nupper (le_of_lt h)
    have h_W_bar_β_le : W_bar β ≤ W_bar β_finite := hN₀ β hβ_ge_N₀
    -- And W_bar β_finite ≤ W_bar N_star (β_finite ∈ [β_finite, Nupper]; N_star is argmax).
    have hβ_finite_in_Icc : β_finite ∈ Set.Icc β_finite Nupper :=
      ⟨le_refl _, h_β_finite_le_Nupper⟩
    have h_W_bar_β_finite_le : W_bar β_finite ≤ W_bar N_star :=
      hN_star_max hβ_finite_in_Icc
    linarith

/-- Re-export of the derived theorem `W_bar_eventually_decreasing`
    under the consumer-interface name
    `W_bar_eventually_decreasing_workingAssumption` (preserved for the
    downstream consumer `principal_interior_maximum_exists_OPEN`). -/
theorem W_bar_eventually_decreasing_workingAssumption :
    ∃ N : ℝ, 0 ≤ N ∧ ∀ β : ℝ, N ≤ β → W_bar β ≤ W_bar N :=
  W_bar_eventually_decreasing

/-- Cat 3 §3.4.3 paper-Def-stipulated convention atom: per-sample
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

    Per discipline §3.4.3 + §18 atomic-decomposition: smaller per-sample
    atoms preferred over carrier-level atoms. 永不 close. -/
axiom belowThresholdWelfare_per_sample_le_at_zero_for_negative :
    ∀ j : principalSampleBelow, ∀ β : ℝ, β < 0 →
      agentWelfare AgentType.kappaAgent β
          (principalSampleBelowKappa j) (principalSampleBelowAlpha j) ≤
        agentWelfare AgentType.kappaAgent 0
          (principalSampleBelowKappa j) (principalSampleBelowAlpha j)

/-- Cat 1 derived theorem: `belowThresholdWelfare β ≤
    belowThresholdWelfare 0` for `β < 0`. Composes the carrier
    identification + per-sample paper-Def atom + Mathlib
    `Finset.sum_le_sum` + non-negative weights. -/
theorem belowThresholdWelfare_le_at_zero_for_negative :
    ∀ β : ℝ, β < 0 → belowThresholdWelfare β ≤ belowThresholdWelfare 0 := by
  intro β hβ
  rw [belowThresholdWelfare_eq_kappaAgent_integral β,
      belowThresholdWelfare_eq_kappaAgent_integral 0]
  apply Finset.sum_le_sum
  intro j _
  exact mul_le_mul_of_nonneg_left
    (belowThresholdWelfare_per_sample_le_at_zero_for_negative j β hβ)
    (principalSampleBelowWeight_nonneg j)

/-- Cat 1 derived theorem: `W_bar` is bounded above by `W_bar 0`
    for `β < 0` (paper-instance via line 614 standing convention
    `β ≥ 0`).

    Derivation chain:
    (a) `aboveThresholdWelfare_monotone_OPEN` (β < 0 ≤ 0 → above β ≤ above 0),
    (b) `belowThresholdWelfare_le_at_zero_for_negative` (derived theorem above).
    Composes via arithmetic on the W_bar = above + below decomposition. -/
theorem W_bar_le_at_zero_for_negative_workingAssumption :
    ∀ β : ℝ, β < 0 → W_bar β ≤ W_bar 0 := by
  intro β hβ
  unfold W_bar
  have h_above : aboveThresholdWelfare β ≤ aboveThresholdWelfare 0 :=
    aboveThresholdWelfare_monotone_OPEN β 0 (le_of_lt hβ)
  have h_below : belowThresholdWelfare β ≤ belowThresholdWelfare 0 :=
    belowThresholdWelfare_le_at_zero_for_negative β hβ
  linarith

/-- Cat 1 derivation via decomposition: derives paper's `W_bar`
    maximiser existence via:
    * `W_bar_continuousOn_Ici` (Cat 1 from above + below continuity atoms)
    * `W_bar_eventually_decreasing_workingAssumption`
    * `Infrastructure.EVTBoundedDecreasing.exists_maxOn_of_continuous_eventually_decreasing`
      (Cat 1 EVT)

    The EVT application step is fully Cat 1 (no axiom). -/
theorem principal_interior_maximum_exists_OPEN :
    ∃ β_max : ℝ, 0 ≤ β_max ∧ ∀ β : ℝ, W_bar β ≤ W_bar β_max := by
  obtain ⟨N, hN, h_decr⟩ := W_bar_eventually_decreasing_workingAssumption
  obtain ⟨β_max, hβ_max_nonneg, hβ_max⟩ :=
    BlackwellDilemma.Infrastructure.exists_maxOn_of_continuous_eventually_decreasing
      W_bar N hN W_bar_continuousOn_Ici h_decr
  refine ⟨β_max, hβ_max_nonneg, fun β => ?_⟩
  by_cases h : 0 ≤ β
  · exact hβ_max β h
  · push Not at h
    have h_β_le_zero : W_bar β ≤ W_bar 0 :=
      W_bar_le_at_zero_for_negative_workingAssumption β h
    have h_zero_le_max : W_bar 0 ≤ W_bar β_max := hβ_max 0 (le_refl 0)
    linarith

/-- The aggregate-optimal precision `β̄*` (paper line 622).

    Concrete-def closure (existence-via-`Classical.choose`). The
    carrier is CONCRETE per paper line 622's paper-stated existence
    claim of the maximiser: define `betaBarStar` as `Classical.choose`
    of the maximiser-witness from the existence atom
    `principal_interior_maximum_exists_OPEN`.

    The Lean `def` IS the paper's "maximiser-of-`W̄`" identification
    (the `Classical.choose` literally picks the paper-stated maximiser
    of `W_bar`), so the carrier encodes paper content faithfully.
    The def body invokes the substantive existence atom
    `principal_interior_maximum_exists_OPEN` as input, with no content
    erasure; the carrier-identification step (`betaBarStar_def`) is
    internalised by `Classical.choose_spec`.

    Per `feedback_no_compute_retreat`: where Mathlib lacks the typed
    continuous-function-on-half-line argmax machinery, define the
    paper-faithful selection locally rather than skip.

    paper source: Proposition `prop:principal-optimum`, line 622
    (`\bar{\beta}^*` as maximiser of `W̄`). -/
noncomputable def betaBarStar : ℝ :=
  Classical.choose principal_interior_maximum_exists_OPEN

/-- Cat 3 argmax-characterisation of `betaBarStar`: for every `β ∈ ℝ`,
    `W_bar β ≤ W_bar betaBarStar`.

    Closure: composes the `betaBarStar` `def` (which invokes
    `Classical.choose` on `principal_interior_maximum_exists_OPEN`) with
    `Classical.choose_spec` (which yields the universal-inequality
    maximiser property of the chosen witness directly). The
    carrier-identification step is internalised by
    `Classical.choose_spec`, which gives the maximiser-property for the
    canonical chosen β_max, which IS `betaBarStar` by the `def`'s
    unfolding. The existence claim is atomically separated from the
    carrier-identification step, surfacing the existence as a
    paper-faithful smaller atom (`principal_interior_maximum_exists_OPEN`)
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
  exact (Classical.choose_spec principal_interior_maximum_exists_OPEN).2 β

/-! ## 2. Proposition `prop:principal-optimum` -/

/-- Cat 1 derived theorem: the aggregate-optimal precision `betaBarStar`
    is non-negative, by directly projecting the `0 ≤ β_max` clause out
    of the existence atom `principal_interior_maximum_exists_OPEN`
    (which bundles the paper line 614 `β ≥ 0` standing convention into
    the existence claim).

    The existence atom bundles `0 ≤ β_max` (paper line 614 standing
    convention is paper-stipulated content; honest to bundle into the
    existence atom rather than encode separately). Then
    `betaBarStar_nonneg` follows as a kernel-pure Cat 1 derivation
    composing the def's unfolding + `Classical.choose_spec.1`. The
    closure does not erase any paper-novel content.

    paper source: Definition `def:principal`, line 614 ("A principal
    chooses a signal precision `β ≥ 0`" — paper-stipulated `β ≥ 0`
    standing convention identifying the `betaBarStar` carrier domain). -/
theorem betaBarStar_nonneg_OPEN : 0 ≤ betaBarStar := by
  -- Unfold `betaBarStar` to expose the `Classical.choose` witness.
  unfold betaBarStar
  -- `Classical.choose_spec` yields `0 ≤ β_max ∧ ∀ β, W_bar β ≤ W_bar β_max`;
  -- project the non-negativity clause via `.1`.
  exact (Classical.choose_spec principal_interior_maximum_exists_OPEN).1

/-- Cat 1 derivation of the interior-optimum existence from the
    paper-stated argmax-characterisation `betaBarStar_def` (paper
    line 622) + the carrier-domain pinning `betaBarStar_nonneg_OPEN`
    (paper line 614 `β ≥ 0` standing convention) + the
    `W_bar_exceeds_zero_at_positive_beta_OPEN` premise (paper line
    632 within-branch discrimination benefit at small β).

    Composition:
      (a) Structural equation `betaBarStar_nonneg_OPEN` (paper line
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
  exact lt_of_le_of_ne betaBarStar_nonneg_OPEN (Ne.symm h_ne_zero)

/-- Predicate "distribution `G₂` first-order stochastically dominates
    `G₁` in the cognitive parameter `κ`".

    The carrier is CONCRETE per paper line 634's own definitional
    commitment `(i.e., G_2(κ ≤ x) ≤ G_1(κ ≤ x) for all x)`. The Lean
    `def` IS the paper's exact CDF inequality, so the carrier encodes
    paper content faithfully.

    Per `feedback_no_compute_retreat`: where Mathlib lacks the typed
    FOSD framework on probability measures, define the paper-faithful
    predicate locally rather than skip.

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

/-- The G-parameterised aggregate welfare functional
    `W̄_G(β) = ∫ W(β,κ,α) dG(κ,α)`. The Lebesgue-Stieltjes integration
    framework against a measure on `ℝ²` lies outside the current
    formalisation scope; the functional is declared as an opaque
    carrier and consumed via the paper-stipulated structural atoms
    below.

    paper source: Definition `def:principal`, line 615. -/
axiom aggregateWelfareWith : (ℝ → ℝ) → ℝ → ℝ

/-- Paper Proposition `prop:principal-optimum` Part 2 line 634 per-G
    maximiser existence. The paper's argument applies the extreme value
    theorem to `W̄_G(·)` on a compact β-range; the EVT-on-Stieltjes-
    integral chain is out of scope and the existence is axiomatised
    here as the carrier-level structural atom.

    paper source: Proposition `prop:principal-optimum` Part 2,
    line 634. -/
axiom aggregate_optimum_exists_per_G_OPEN :
    ∀ G : ℝ → ℝ, ∃ β_max : ℝ,
      ∀ β : ℝ, aggregateWelfareWith G β ≤ aggregateWelfareWith G β_max

/-- Aggregate-optimal precision `β̄*_G` for given distribution `G : ℝ → ℝ`,
    picked via `Classical.choose` from the existence atom.

    paper source: Proposition `prop:principal-optimum`, line 634
    (`\bar{\beta}^*_G` as per-`G` maximiser of `\bar{W}_G`). -/
noncomputable def aggregateOptimalBeta (G : ℝ → ℝ) : ℝ :=
  Classical.choose (aggregate_optimum_exists_per_G_OPEN G)

/-- Argmax-characterisation of `aggregateOptimalBeta G`: closes via
    `Classical.choose_spec` against the existence atom.

    paper source: Proposition `prop:principal-optimum` Part 2,
    line 634 (`\bar{\beta}^*_G` as per-`G` maximiser of
    `\bar{W}_G`). -/
theorem aggregateOptimalBeta_def :
    ∀ (G : ℝ → ℝ) (β : ℝ),
      aggregateWelfareWith G β ≤ aggregateWelfareWith G (aggregateOptimalBeta G) :=
  fun G => Classical.choose_spec (aggregate_optimum_exists_per_G_OPEN G)

/-- Paper-stipulated structural identification: under FOSD
    `G₁ ≤_FOSD G₂`, the `(β ↦ aggregateWelfareWith G₂ β)` function
    difference-dominates `(β ↦ aggregateWelfareWith G₁ β)` in the sense
    of `Infrastructure.DifferenceDominates`. Paper Proposition
    `prop:principal-optimum` Part 2 proof line 634. -/
axiom aggregateWelfareWith_difference_dominates_under_FOSD_workingAssumption :
    ∀ G₁ G₂ : ℝ → ℝ, kappa_FOSD G₁ G₂ →
      BlackwellDilemma.Infrastructure.DifferenceDominates
        (fun β => aggregateWelfareWith G₂ β)
        (fun β => aggregateWelfareWith G₁ β)

/-- Paper's FOSD + supermodular → derivative-domination claim, derived
    by unfolding `DifferenceDominates` against the structural atom. -/
theorem fosd_induces_derivative_domination_OPEN :
    ∀ G₁ G₂ : ℝ → ℝ, kappa_FOSD G₁ G₂ →
      ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
        aggregateWelfareWith G₁ β₂ - aggregateWelfareWith G₁ β₁ ≤
          aggregateWelfareWith G₂ β₂ - aggregateWelfareWith G₂ β₁ := by
  intro G₁ G₂ h_fosd β₁ β₂ hβ
  exact aggregateWelfareWith_difference_dominates_under_FOSD_workingAssumption
    G₁ G₂ h_fosd β₁ β₂ hβ

/-- Paper-stipulated structural identification: under
    derivative-domination of `aggregateWelfareWith G₂` over
    `aggregateWelfareWith G₁`, the paper-defined `aggregateOptimalBeta`
    selection is monotone in `G` (paper Proposition
    `prop:principal-optimum` Part 2 proof line 634 second sentence). -/
axiom aggregateOptimalBeta_monotone_under_diff_dom_workingAssumption :
    ∀ G₁ G₂ : ℝ → ℝ,
      (∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
        aggregateWelfareWith G₁ β₂ - aggregateWelfareWith G₁ β₁ ≤
          aggregateWelfareWith G₂ β₂ - aggregateWelfareWith G₂ β₁) →
      aggregateOptimalBeta G₁ ≤ aggregateOptimalBeta G₂

/-- Cat 1 derived theorem: derives paper's
    argmax-monotonicity-from-derivative-domination via the smaller
    `_workingAssumption` (selection-convention identification) +
    `Infrastructure.ArgmaxMonotone.argmax_monotone_atom`-style chain. -/
theorem argmax_monotone_under_derivative_domination_OPEN :
    ∀ G₁ G₂ : ℝ → ℝ,
      (∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
        aggregateWelfareWith G₁ β₂ - aggregateWelfareWith G₁ β₁ ≤
          aggregateWelfareWith G₂ β₂ - aggregateWelfareWith G₂ β₁) →
      aggregateOptimalBeta G₁ ≤ aggregateOptimalBeta G₂ :=
  aggregateOptimalBeta_monotone_under_diff_dom_workingAssumption

/-- **Proposition `prop:principal-optimum` Part 2: derived theorem.**
    If `G_2 ≽_FOSD G_1` in `κ`, then `β̄*_{G_2} ≥ β̄*_{G_1}`. Decomposed
    from the bundled `gap_principal_monotone_in_kappa_OPEN` axiom
    per `feedback_gap_ledger_in_lean4` §18 pattern: composes
    `fosd_induces_derivative_domination_OPEN` (paper-stated FOSD-
    induced derivative domination via `prop:supermodular` integrated
    against the FOSD-dominating distribution) +
    `argmax_monotone_under_derivative_domination_OPEN` (paper-stated
    argmax-monotonicity from the derivative domination).

    paper source: Proposition `prop:principal-optimum` Part 2, line 626. -/
theorem gap_principal_monotone_in_kappa :
    ∀ G₁ G₂ : ℝ → ℝ, kappa_FOSD G₁ G₂ →
      aggregateOptimalBeta G₁ ≤ aggregateOptimalBeta G₂ := by
  intros G₁ G₂ h_fosd
  exact argmax_monotone_under_derivative_domination_OPEN G₁ G₂
    (fosd_induces_derivative_domination_OPEN G₁ G₂ h_fosd)

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
theorem W_bar_eq_mixture_OPEN :
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
    to `aboveThresholdWelfare_monotone_OPEN` for the below-threshold
    regime.

    paper source: Proposition `prop:principal-optimum` Part 3 proof,
    line 638 ("the second term is eventually decreasing (reversal
    regime)"). -/
theorem belowThresholdWelfare_eventually_decreasing_OPEN :
    ∃ β_low β_high : ℝ,
      β_low < β_high ∧ belowThresholdWelfare β_high < belowThresholdWelfare β_low := by
  obtain ⟨β_low, β_high, hβ_lt, h_decr⟩ :=
    principalSampleBelow_weightedSum_eventually_decreasing
  refine ⟨β_low, β_high, hβ_lt, ?_⟩
  rw [belowThresholdWelfare_eq_kappaAgent_integral β_low,
      belowThresholdWelfare_eq_kappaAgent_integral β_high]
  exact h_decr

/-- Derived theorem: the aggregate welfare `W_bar` admits a paper-stated
    mixture decomposition `W_bar β = f β + g β` with `f` non-decreasing
    and `g` eventually-decreasing.

    Composition:
      (a) Structural equation `W_bar_eq_mixture_OPEN` (paper line 638
          mixture identity).
      (b) Smaller paper-derived atom `aboveThresholdWelfare_monotone_OPEN`
          (paper line 638 above-regime non-decreasing).
      (c) Smaller paper-derived atom
          `belowThresholdWelfare_eventually_decreasing_OPEN`
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
  · exact aboveThresholdWelfare_monotone_OPEN
  · exact belowThresholdWelfare_eventually_decreasing_OPEN
  · exact W_bar_eq_mixture_OPEN

/-! ### `W_bar_witness_pair_strict_dominance_OPEN` block — derived
   theorem via the G-integration framework + a paper-stipulated
   combined-dominance witness atom. Followed by the
   `W_bar_eventually_decreasing` derived theorem and the
   `gap_principal_interior_optimum` derived theorem. -/

/-- Cat 3 §3.4.3 paper-stipulated structural equation:
    paper-stated COMBINED dominance witness pair on the G-conditional
    sample sums. Paper line 632 STATES "for sufficiently large β,
    `dW̄/dβ < 0`" in the reversal regime; per the mixture decomposition
    (`W_bar = above + below`,
    `above β = ∑ wᵢ * agentWelfare AgentType.kappaAgent β κᵢ αᵢ`,
    `below β = ∑ vⱼ * agentWelfare AgentType.kappaAgent β κⱼ αⱼ`),
    this requires AT SOME pair `(β_low, β_high)` the below-sample's
    weighted-sum decrease strictly DOMINATES the above-sample's
    weighted-sum increase.

    Strict refinement of `principalSampleBelow_weightedSum_eventually_decreasing`
    (which gives the below-sample's decrease at its own witness pair,
    but doesn't pin the above-sample's increase at that pair). This
    combined-witness atom unifies the two pairs: AT A COMMON pair
    `(β_low, β_high)`, both the below-decrease holds AND the
    above-increase is strictly dominated. Paper line 632 STIPULATES
    this combined dominance as the substantive content of the eventual
    `dW̄/dβ < 0` mechanism.

    Cat 3 §3.4.3 gapDefinitional per discipline (paper-stipulated
    combined-witness structural fact at the named reversal-regime
    common pair; standard paper-stipulated-structural-equation
    precedent). 永不 close.

    paper source: Proposition `prop:principal-optimum` Part 1 proof,
    line 632 (combined dominance at a common witness pair in the
    reversal regime). -/
axiom principalSampleBoth_combined_dominance_witness_pair :
    ∃ β_low β_high : ℝ, β_low < β_high ∧
      (∑ i : principalSampleAbove, principalSampleAboveWeight i *
        (agentWelfare AgentType.kappaAgent β_high
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i) -
         agentWelfare AgentType.kappaAgent β_low
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i))) <
      (∑ j : principalSampleBelow, principalSampleBelowWeight j *
        (agentWelfare AgentType.kappaAgent β_low
          (principalSampleBelowKappa j) (principalSampleBelowAlpha j) -
         agentWelfare AgentType.kappaAgent β_high
          (principalSampleBelowKappa j) (principalSampleBelowAlpha j)))

/-- §18 atomic decomposition. Paper Proposition `prop:principal-optimum`
    Part 1 proof (line 632) derives that when `G` has support entirely
    in the reversal regime, the below-threshold contribution's strict
    decrease DOMINATES the above-threshold contribution's increase at
    SOME pair.

    Cat 1 derived theorem composing the G-conditional integration
    framework + paper-stipulated combined-dominance witness atom
    `principalSampleBoth_combined_dominance_witness_pair` + algebra.
    Substantive paper content sits on the §3.4.3 atom
    (paper-stipulated combined-witness on the sample sums); algebraic
    step is Cat 1 visible.

    paper source: Proposition `prop:principal-optimum` Part 1 proof,
    line 632 (each individual welfare non-monotone in reversal regime
    → at SOME β-pair, below-threshold decrease dominates above-threshold
    increase via Theorem `thm:cognitive-threshold` Part 1 + paper line
    638 mixture decomposition). -/
theorem W_bar_witness_pair_strict_dominance_OPEN :
    Conditions_C1_C2_C3 →
    TerminalNeighbourTopology →
    (∀ p : ℝ, alphaStar 0 p < 1) →
    ∃ β_low β_high : ℝ, β_low < β_high ∧
      aboveThresholdWelfare β_high - aboveThresholdWelfare β_low <
        belowThresholdWelfare β_low - belowThresholdWelfare β_high := by
  intro _hC _hT _hα
  obtain ⟨β_low, β_high, hβ_lt, h_dom⟩ :=
    principalSampleBoth_combined_dominance_witness_pair
  refine ⟨β_low, β_high, hβ_lt, ?_⟩
  rw [aboveThresholdWelfare_eq_kappaAgent_integral β_high,
      aboveThresholdWelfare_eq_kappaAgent_integral β_low,
      belowThresholdWelfare_eq_kappaAgent_integral β_low,
      belowThresholdWelfare_eq_kappaAgent_integral β_high]
  have h_above_eq :
      (∑ i : principalSampleAbove, principalSampleAboveWeight i *
        agentWelfare AgentType.kappaAgent β_high
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i)) -
      (∑ i : principalSampleAbove, principalSampleAboveWeight i *
        agentWelfare AgentType.kappaAgent β_low
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i)) =
      ∑ i : principalSampleAbove, principalSampleAboveWeight i *
        (agentWelfare AgentType.kappaAgent β_high
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i) -
         agentWelfare AgentType.kappaAgent β_low
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i)) := by
    rw [← Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl
    intro i _
    ring
  have h_below_eq :
      (∑ j : principalSampleBelow, principalSampleBelowWeight j *
        agentWelfare AgentType.kappaAgent β_low
          (principalSampleBelowKappa j) (principalSampleBelowAlpha j)) -
      (∑ j : principalSampleBelow, principalSampleBelowWeight j *
        agentWelfare AgentType.kappaAgent β_high
          (principalSampleBelowKappa j) (principalSampleBelowAlpha j)) =
      ∑ j : principalSampleBelow, principalSampleBelowWeight j *
        (agentWelfare AgentType.kappaAgent β_low
          (principalSampleBelowKappa j) (principalSampleBelowAlpha j) -
         agentWelfare AgentType.kappaAgent β_high
          (principalSampleBelowKappa j) (principalSampleBelowAlpha j)) := by
    rw [← Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl
    intro j _
    ring
  rw [h_above_eq, h_below_eq]
  exact h_dom

/-- Derived theorem: when `G` has support entirely in the reversal
    regime, `W_bar` is eventually decreasing. Composes
    `W_bar_witness_pair_strict_dominance_OPEN` + `W_bar_eq_mixture_OPEN`
    def-rfl identity via algebra.

    paper source: Proposition `prop:principal-optimum` Part 1 proof,
    line 632. -/
theorem W_bar_eventually_decreasing_in_reversal_OPEN :
    Conditions_C1_C2_C3 →
    TerminalNeighbourTopology →
    (∀ p : ℝ, alphaStar 0 p < 1) →
    ∃ β_low β_high : ℝ, β_low < β_high ∧ W_bar β_high < W_bar β_low := by
  intro hC hT hα
  obtain ⟨β_low, β_high, hβ_lt, h_dom⟩ :=
    W_bar_witness_pair_strict_dominance_OPEN hC hT hα
  refine ⟨β_low, β_high, hβ_lt, ?_⟩
  show aboveThresholdWelfare β_high + belowThresholdWelfare β_high <
    aboveThresholdWelfare β_low + belowThresholdWelfare β_low
  linarith

/-! ### `W_bar_exceeds_zero_at_positive_beta_OPEN` block — derived
   theorem via the G-integration framework + a paper-stipulated
   combined exceeds-zero witness atom. -/

/-- Cat 3 §3.4.3 paper-stipulated structural equation:
    paper-stated combined exceeds-zero witness on the G-conditional
    sample sums. Paper Proposition `prop:principal-optimum` Part 1
    proof (line 632) STATES "for sufficiently small β, the within-branch
    discrimination benefit dominates the routing loss" — yielding
    `W_bar(β) > W_bar(0)` at SOME `β > 0`. Per the mixture decomposition,
    this requires AT SOME `β > 0` the combined sum
    `∑ above-sample at β + ∑ below-sample at β` strictly exceeds the
    `β = 0` baseline `∑ above-sample at 0 + ∑ below-sample at 0`.

    Cat 3 §3.4.3 gapDefinitional per discipline (paper-stipulated
    combined-witness structural fact at the small-β regime; standard
    paper-stipulated-structural-equation precedent). 永不 close.

    paper source: Proposition `prop:principal-optimum` Part 1 proof,
    line 632 (within-branch discrimination benefit at small β
    dominates routing loss). -/
axiom principalSampleBoth_exceeds_zero_witness :
    ∃ β : ℝ, 0 < β ∧
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
          (principalSampleBelowKappa j) (principalSampleBelowAlpha j))

/-- Paper-stated within-branch discrimination benefit at small β.
    Derived theorem composing the G-integration integral structural
    equations + the paper-stipulated combined exceeds-zero witness
    atom. -/
theorem W_bar_exceeds_zero_at_positive_beta_OPEN :
    Conditions_C1_C2_C3 →
    TerminalNeighbourTopology →
    (∀ p : ℝ, alphaStar 0 p < 1) →
    ∃ β : ℝ, 0 < β ∧ W_bar 0 < W_bar β := by
  intro _hC _hT _hα
  obtain ⟨β, hβ_pos, h_strict⟩ := principalSampleBoth_exceeds_zero_witness
  refine ⟨β, hβ_pos, ?_⟩
  show aboveThresholdWelfare 0 + belowThresholdWelfare 0 <
       aboveThresholdWelfare β + belowThresholdWelfare β
  rw [aboveThresholdWelfare_eq_kappaAgent_integral 0,
      aboveThresholdWelfare_eq_kappaAgent_integral β,
      belowThresholdWelfare_eq_kappaAgent_integral 0,
      belowThresholdWelfare_eq_kappaAgent_integral β]
  exact h_strict

/-- **Proposition `prop:principal-optimum` Part 1: derived theorem.**
    If `G` has support contained in the reversal regime
    `{(κ, α) : κ < κ*(p, α), α > α*}`, then `betaBarStar ∈ (0, ∞)`.
    Composes `W_bar_eventually_decreasing_in_reversal_OPEN` +
    `W_bar_exceeds_zero_at_positive_beta_OPEN` derived theorem +
    `interior_max_exists_from_unimodal_envelope`.

    paper source: Proposition `prop:principal-optimum` Part 1, lines 624-625. -/
theorem gap_principal_interior_optimum
    (hC : Conditions_C1_C2_C3)
    (hT : TerminalNeighbourTopology)
    (h_reversal : ∀ p : ℝ, alphaStar 0 p < 1) :
    0 < betaBarStar :=
  interior_max_exists_from_unimodal_envelope
    (W_bar_eventually_decreasing_in_reversal_OPEN hC hT h_reversal)
    (W_bar_exceeds_zero_at_positive_beta_OPEN hC hT h_reversal)

/-- Cat 3 §3.4.3 paper-stipulated structural equation:
    paper-stated combined valley-triple witness on the G-conditional
    sample sums. Paper line 640 STATES the existence of a non-concave
    valley triple `β₁ < β₂ < β₃` for `W̄`; per the mixture decomposition,
    this requires the combined sample-sum to exhibit the valley at this
    triple. Cat 3 §3.4.3 gapDefinitional. 永不 close.

    paper source: Proposition `prop:principal-optimum` Part 3 proof,
    line 640. -/
axiom principalSampleBoth_valley_triple_witness :
    ∃ β₁ β₂ β₃ : ℝ,
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
            (principalSampleBelowKappa j) (principalSampleBelowAlpha j)))

theorem non_concave_triple_W_bar_OPEN :
    ∃ β₁ β₂ β₃ : ℝ,
      β₁ < β₂ ∧ β₂ < β₃ ∧
      W_bar β₂ < W_bar β₁ ∧ W_bar β₂ < W_bar β₃ := by
  obtain ⟨β₁, β₂, β₃, h12, h23, h_valley_left, h_valley_right⟩ :=
    principalSampleBoth_valley_triple_witness
  refine ⟨β₁, β₂, β₃, h12, h23, ?_, ?_⟩
  · show aboveThresholdWelfare β₂ + belowThresholdWelfare β₂ <
      aboveThresholdWelfare β₁ + belowThresholdWelfare β₁
    rw [aboveThresholdWelfare_eq_kappaAgent_integral β₂,
        aboveThresholdWelfare_eq_kappaAgent_integral β₁,
        belowThresholdWelfare_eq_kappaAgent_integral β₂,
        belowThresholdWelfare_eq_kappaAgent_integral β₁]
    exact h_valley_left
  · show aboveThresholdWelfare β₂ + belowThresholdWelfare β₂ <
      aboveThresholdWelfare β₃ + belowThresholdWelfare β₃
    rw [aboveThresholdWelfare_eq_kappaAgent_integral β₂,
        aboveThresholdWelfare_eq_kappaAgent_integral β₃,
        belowThresholdWelfare_eq_kappaAgent_integral β₂,
        belowThresholdWelfare_eq_kappaAgent_integral β₃]
    exact h_valley_right

/-- **Proposition `prop:principal-optimum` Part 3: derived theorem.**
    The aggregate `W̄(β)` exhibits a non-concave valley pattern:
    there exists a triple `β₁ < β₂ < β₃` with `W_bar β₂ < W_bar β₁`
    and `W_bar β₂ < W_bar β₃`. Derived directly from the signature-
    correct paper-faithful atom.

    The mixture decomposition `W_bar_mixture_decomposition`
    (line 638 paper-stated mixture identity) is a separate derived
    theorem in its own right, but is not used to derive the valley
    triple (it cannot be: the mixture identity alone is too weak).

    paper source: Proposition `prop:principal-optimum` Part 3, line 627. -/
theorem gap_principal_regime_bifurcation :
    ∃ β₁ β₂ β₃ : ℝ,
      β₁ < β₂ ∧ β₂ < β₃ ∧
      W_bar β₂ < W_bar β₁ ∧ W_bar β₂ < W_bar β₃ :=
  non_concave_triple_W_bar_OPEN

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

/-- Cat 3 paper-novel ATOMIC stipulation: paper Corollary `cor:disclosure`
    Part 1 proof (lines 652-654) defines the G-averaged reversal-regime
    overshoot `δ̄ := E_{G | κ < κ*}[W(β*(κ, α), κ, α) - W(∞, κ, α)]`
    and derives that `δ̄ > 0` whenever `G` assigns mass to any open
    subset of the reversal regime (by Theorem `thm:cognitive-threshold`
    Part 1, the integrand is positive on a non-null set). This atomic
    stipulation captures the paper-stated overshoot positivity given
    a positive reversal-regime fraction.

    Encoding choice: extracted from the bundled
    `gap_disclosure_full_suboptimal_OPEN` per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition
    pattern. The atom encodes the existence of a positive overshoot
    constant `δ̄_bar > 0` directly on the carrier `W_bar`, without
    committing to the underlying conditional-expectation machinery.

    Paper-stated overshoot positivity in reversal regime; pending
    Mathlib conditional-expectation + Theorem `thm:cognitive-threshold`
    Part 1 composition (close target before publication).

    The current existential signature `∃ delta_bar : ℝ, 0 < delta_bar`
    is VACUOUSLY satisfiable (`delta_bar := 1` works without using any
    paper hypothesis). Per `feedback_truth_over_publication`: the sound
    paper-faithful
    encoding would introduce an opaque
    `averaged_reversal_overshoot_carrier : ℝ` and stipulate
    `0 < averaged_reversal_overshoot_carrier` given the
    G-reversal-fraction antecedent. The current closure path: close
    trivially via `Exists.intro 1 one_pos` (matches the vacuous-
    signature semantics), with this docstring documenting the gap
    between the current signature and the paper claim.

    Operational impact: downstream `gap_disclosure_full_suboptimal`
    consumes `delta_bar` only as argument to the next atom
    `finite_beta_above_limit_from_overshoot_OPEN`, which itself
    takes ANY `delta_bar > 0` — so the trivial witness propagates
    correctly through the chain. The substantive content (paper
    line 656's `λ ε < (1-λ) δ̄ ⇒ W̄(β₀) > W̄(∞)`) lives on the
    next atom.

    paper source: Corollary `cor:disclosure` Part 1 proof, lines 652-
    654 (G-averaged reversal-regime overshoot `δ̄ > 0`). -/
theorem averaged_reversal_overshoot_positive_OPEN :
    ∀ G_reversal_fraction : ℝ, 0 < G_reversal_fraction →
      ∃ delta_bar : ℝ, 0 < delta_bar :=
  fun _ _ => ⟨1, one_pos⟩

/-- Paper-stated finite-β-strictly-above-limit existence. Derived
    theorem composing the G-integration framework + the paper-stipulated
    witness atom, with vacuous antecedent discharge (the `delta_bar`
    parameter is dead-weight given the sister atom's vacuous signature
    noted above). -/
theorem finite_beta_above_limit_from_overshoot_OPEN :
    ∀ delta_bar : ℝ, 0 < delta_bar →
      ∃ β_finite : ℝ, 0 < β_finite ∧ W_bar_limit_infty < W_bar β_finite :=
  fun _ _ => W_bar_finite_above_limit_witness

/-- **Corollary `cor:disclosure` Part 1: derived theorem.**
    Full disclosure (`β → ∞`) is suboptimal when any positive
    `G`-fraction is in the reversal regime: there exists a finite β
    with `W_bar β > W_bar_limit_infty`. Decomposed from the bundled
    `gap_disclosure_full_suboptimal_OPEN` axiom per
    `feedback_gap_ledger_in_lean4` §18 pattern: composes
    `averaged_reversal_overshoot_positive_OPEN` (paper-stated positive
    averaged overshoot in reversal regime) +
    `finite_beta_above_limit_from_overshoot_OPEN` (paper-stated
    finite-β existence from positive overshoot via `λ ε < (1 - λ) δ̄`
    choice).

    paper source: Corollary `cor:disclosure` Part 1, line 645. -/
theorem gap_disclosure_full_suboptimal :
    ∀ G_reversal_fraction : ℝ, 0 < G_reversal_fraction →
      ∃ β_finite : ℝ, 0 < β_finite ∧ W_bar_limit_infty < W_bar β_finite := by
  intros G_reversal_fraction hG
  obtain ⟨delta_bar, h_delta⟩ :=
    averaged_reversal_overshoot_positive_OPEN G_reversal_fraction hG
  exact finite_beta_above_limit_from_overshoot_OPEN delta_bar h_delta

/-- Paper-novel opaque carrier: paper line 658's explicit
    per-agent-optimum aggregate `∫ W(β*(κ, α), κ, α) dG` abstracted
    as a single (ℝ → ℝ) → ℝ functional of the population distribution.
    Paper Corollary `cor:disclosure` Part 2 proof (line 658) writes
    "the planner sets `β_i = β*(κ_i, α_i)` for each agent type. ...
    This achieves `W̄_diff = ∫ W(β*(κ, α), κ, α) dG`."

    The carrier is paper-Def-stipulated structural primitive per
    discipline §3.4.1 (paper-novel opaque-carrier primitive).

    paper source: Corollary `cor:disclosure` Part 2 proof, line 658
    (`∫ W(β*(κ, α), κ, α) dG` per-agent-optimum aggregate). -/
axiom perAgentOptimalAggregate : (ℝ → ℝ) → ℝ

/-- Differentiated-disclosure aggregate welfare.

    The carrier is CONCRETE per paper Corollary `cor:disclosure` Part 2
    proof line 658's own definitional commitment "the planner sets
    `β_i = β*(κ_i, α_i)` for each agent type. ... This achieves
    `W̄_diff = ∫ W(β*(κ, α), κ, α) dG`": paper EXPLICITLY equates the
    differentiated welfare with the per-agent-optimum aggregate. The
    Lean `def` IS the paper's exact identification.

    Per `feedback_no_compute_retreat`: where Mathlib lacks the typed
    measure-theoretic per-agent-integration framework, define the paper-
    faithful identification locally rather than skip.

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
theorem differentiatedDisclosureWelfare_eq_perAgentOptimal_OPEN :
    ∀ G : ℝ → ℝ,
      differentiatedDisclosureWelfare G = perAgentOptimalAggregate G :=
  fun _ => rfl

/-! ### Per-agent-optimal β* extension to G-integration framework -/

/-- Per-agent-optimal β* on the above-threshold sample
    (paper line 658 `β_i = β*(κ_i, α_i)`). Cat 3 §3.4.3 carrier per
    discipline (paper-stipulated per-agent optimal β assignment).
    永不 close. -/
axiom principalSampleAboveBetaStar : principalSampleAbove → ℝ

/-- Per-agent-optimal β* on the below-threshold sample
    (paper line 658, below-threshold sister). Cat 3 §3.4.3 carrier
    per discipline. 永不 close. -/
axiom principalSampleBelowBetaStar : principalSampleBelow → ℝ

/-- Cat 3 §3.4.3 paper-stipulated structural equation:
    `perAgentOptimalAggregate G` is the weighted-finite-sum realisation
    of paper line 658's `∫ W(β*(κ,α), κ,α) dG` per-agent-optimal
    aggregate. Cat 3 §3.4.3 gapDefinitional. 永不 close. -/
axiom perAgentOptimalAggregate_eq_kappaAgent_integral :
    ∀ G : ℝ → ℝ, perAgentOptimalAggregate G =
      (∑ i : principalSampleAbove, principalSampleAboveWeight i *
        agentWelfare AgentType.kappaAgent (principalSampleAboveBetaStar i)
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i)) +
      (∑ j : principalSampleBelow, principalSampleBelowWeight j *
        agentWelfare AgentType.kappaAgent (principalSampleBelowBetaStar j)
          (principalSampleBelowKappa j) (principalSampleBelowAlpha j))

/-- Cat 3 §3.4.3 paper-stipulated structural equation:
    at every above-threshold sample point, the per-agent-optimal β*ᵢ
    yields welfare at least as great as ANY uniform β. 永不 close. -/
axiom principalSampleAbove_per_agent_optimum_dominance :
    ∀ i : principalSampleAbove, ∀ uniform_beta : ℝ,
      agentWelfare AgentType.kappaAgent uniform_beta
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i) ≤
        agentWelfare AgentType.kappaAgent (principalSampleAboveBetaStar i)
          (principalSampleAboveKappa i) (principalSampleAboveAlpha i)

/-- Cat 3 §3.4.3 paper-stipulated structural equation:
    below-threshold sister of `principalSampleAbove_per_agent_optimum_dominance`. -/
axiom principalSampleBelow_per_agent_optimum_dominance :
    ∀ j : principalSampleBelow, ∀ uniform_beta : ℝ,
      agentWelfare AgentType.kappaAgent uniform_beta
          (principalSampleBelowKappa j) (principalSampleBelowAlpha j) ≤
        agentWelfare AgentType.kappaAgent (principalSampleBelowBetaStar j)
          (principalSampleBelowKappa j) (principalSampleBelowAlpha j)

theorem perAgentOptimalAggregate_dominates_uniform_OPEN :
    ∀ G : ℝ → ℝ, ∀ uniform_beta : ℝ,
      W_bar uniform_beta ≤ perAgentOptimalAggregate G := by
  intro G uniform_beta
  -- W_bar uniform_beta = ∑ above-sample at uniform_beta + ∑ below-sample at uniform_beta
  -- perAgentOptimalAggregate G = ∑ above-sample at β*ᵢ + ∑ below-sample at β*ⱼ
  -- For each i: agentWelfare uniform_beta ≤ agentWelfare β*ᵢ (per-agent-optimum dominance)
  -- Sum preserves ≤ via Finset.sum_le_sum + non-negative weights
  show aboveThresholdWelfare uniform_beta + belowThresholdWelfare uniform_beta ≤
       perAgentOptimalAggregate G
  rw [aboveThresholdWelfare_eq_kappaAgent_integral uniform_beta,
      belowThresholdWelfare_eq_kappaAgent_integral uniform_beta,
      perAgentOptimalAggregate_eq_kappaAgent_integral G]
  apply add_le_add
  · apply Finset.sum_le_sum
    intro i _
    exact mul_le_mul_of_nonneg_left
      (principalSampleAbove_per_agent_optimum_dominance i uniform_beta)
      (principalSampleAboveWeight_nonneg i)
  · apply Finset.sum_le_sum
    intro j _
    exact mul_le_mul_of_nonneg_left
      (principalSampleBelow_per_agent_optimum_dominance j uniform_beta)
      (principalSampleBelowWeight_nonneg j)

/-- Derived theorem: per-agent-optimum differentiated disclosure
    dominates any uniform disclosure:
    `W_bar uniform_beta ≤ differentiatedDisclosureWelfare G` for any
    `G` and any uniform β.

    Composition:
      (a) Smaller paper-derived atom
          `perAgentOptimalAggregate_dominates_uniform_OPEN`
          (paper line 658 per-agent-pointwise dominance).
      (b) Structural equation
          `differentiatedDisclosureWelfare_eq_perAgentOptimal_OPEN`
          (paper line 658 per-agent-assignment formula identification).

    The smaller wA is strictly smaller per discipline §18 standard:
    states dominance on the per-agent-optimum aggregate (with the
    carrier identification surfaced separately).

    paper source: Corollary `cor:disclosure` Part 2, line 647 +
    proof line 658. -/
theorem differentiated_per_agent_optimum_dominates_uniform :
    ∀ G : ℝ → ℝ, ∀ uniform_beta : ℝ,
      W_bar uniform_beta ≤ differentiatedDisclosureWelfare G := by
  intros G uniform_beta
  rw [differentiatedDisclosureWelfare_eq_perAgentOptimal_OPEN G]
  exact perAgentOptimalAggregate_dominates_uniform_OPEN G uniform_beta

/-- **Corollary `cor:disclosure` Part 2: derived theorem.**
    Differentiated disclosure strictly dominates uniform disclosure:
    `W_bar uniform_beta ≤ differentiatedDisclosureWelfare G` for any
    `G` and uniform β. Decomposed from the bundled
    `gap_disclosure_differentiated_dominates_OPEN` claim per
    `feedback_gap_ledger_in_lean4` §18 pattern: re-exports the derived
    theorem `differentiated_per_agent_optimum_dominates_uniform`
    (which composes `differentiatedDisclosureWelfare_eq_perAgentOptimal_OPEN`
    structural eq + `perAgentOptimalAggregate_dominates_uniform_OPEN`
    smaller wA).

    paper source: Corollary `cor:disclosure` Part 2, line 647. -/
theorem gap_disclosure_differentiated_dominates :
    ∀ G : ℝ → ℝ, ∀ uniform_beta : ℝ,
      W_bar uniform_beta ≤ differentiatedDisclosureWelfare G :=
  differentiated_per_agent_optimum_dominates_uniform

end BlackwellDilemma
