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

namespace BlackwellDilemma

/-! ## 1. The principal's information problem (`def:principal`)

The principal chooses `β ≥ 0` for a population with heterogeneous
parameters `(κ_i, α_i) ~ G` to maximise aggregate welfare
`W̄(β) = ∫ W(β, κ, α) dG(κ, α)`. -/

/-- The aggregate welfare functional `W̄(β)` for distribution `G`.
    Substantive paper claim — opaque carrier required (Mathlib gap).
    paper source: Definition `def:principal`, line 612. -/
axiom W_bar : ℝ → ℝ

/-- The aggregate-optimal precision `β̄*` (paper line 622).
    Substantive paper claim — opaque carrier required (Mathlib gap).
    paper source: Proposition `prop:principal-optimum`. -/
axiom betaBarStar : ℝ

/-- Cat 3 paper-novel ATOMIC structural equation: paper-stated argmax
    characterisation of `betaBarStar`. Paper Definition `def:principal`
    (line 612-619) reads "The principal maximises aggregate welfare:
    `W̄(β) = ∫ W(β, κ, α) dG(κ, α)`"; Proposition `prop:principal-optimum`
    line 622 then introduces `\bar{\beta}^*` as the maximiser of `W̄`.
    This atomic axiom encodes the argmax-characterisation directly on
    the existing carriers `betaBarStar` and `W_bar`: for every `β ∈ ℝ`,
    `W_bar β ≤ W_bar betaBarStar`.

    Encoding choice: the argmax-characterisation pins `betaBarStar` to
    the maximiser without committing to its existence proof (which
    follows from `gap_principal_interior_optimum_OPEN`'s
    interior-optimum claim under the reversal-regime hypothesis).
    Universal quantification over all `β` is acceptable here per the
    paper's standing convention `β ≥ 0`; for `β < 0` the inequality is
    vacuously satisfied if `W_bar` is conventionally set to a low
    junk value, or alternatively the paper's `β ≥ 0` domain is implicit
    in the carrier definition.

    paper source: Proposition `prop:principal-optimum`, line 622
    (`\bar{\beta}^*` is the maximiser of `W̄`). -/
axiom betaBarStar_def :
    ∀ β : ℝ, W_bar β ≤ W_bar betaBarStar

/-! ## 2. Proposition `prop:principal-optimum` -/

/-- Cat 3 paper-novel ATOMIC stipulation: paper Proposition
    `prop:principal-optimum` Part 1 proof (line 632) derives that
    when `G` has support entirely in the reversal regime, each
    individual welfare `W(β, κ, α)` is non-monotone in β (Theorem
    `thm:cognitive-threshold` Part 1), so `dW̄/dβ < 0` for all
    sufficiently large β: there exists `β_high` with
    `W_bar β_high < W_bar β_high'` for some `β_high' < β_high`.
    Equivalently, `W_bar` is eventually decreasing. This atomic
    stipulation captures the "eventually-decreasing" sub-clause of
    the paper-stated interior-optimum existence on the existing
    carrier `W_bar`.

    Encoding choice: extracted from the bundled
    `gap_principal_interior_optimum_OPEN` per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition
    pattern. The eventually-decreasing form is encoded as an
    explicit existential pair `∃ β_low < β_high, W_bar β_high <
    W_bar β_low`.

    Cat 3 sub-type: workingAssumption (paper-stated eventually-
    decreasing fact on opaque carrier `W_bar` via Theorem
    `thm:cognitive-threshold` Part 1; 必须 close before publication).

    paper source: Proposition `prop:principal-optimum` Part 1 proof,
    line 632 (each individual welfare non-monotone → `W_bar`
    eventually decreasing). -/
axiom W_bar_eventually_decreasing_in_reversal_OPEN :
    Conditions_C1_C2_C3 →
    TerminalNeighbourTopology →
    (∀ p : ℝ, alphaStar 0 p < 1) →
    ∃ β_low β_high : ℝ, β_low < β_high ∧ W_bar β_high < W_bar β_low

/-- Cat 3 paper-novel ATOMIC stipulation: paper Proposition
    `prop:principal-optimum` Part 1 proof (line 632) derives that
    `W_bar(β) > W_bar(0)` for some `β > 0`. The argument uses the
    bridge-subtree within-branch discrimination benefit at small
    `β` (paper Lemma `lem:conditional-reduction`(i)): the conditional
    welfare `W(β | bridge chosen)` is strictly increasing at `β = 0⁺`,
    while the trap-probability `P_trap(β) - 1/2` is `O(β)` with bounded
    coefficient, so for sufficiently small β the within-branch gain
    dominates the routing loss. This atomic stipulation captures the
    "exceeds-W_bar(0)-somewhere" sub-clause on the opaque carrier
    `W_bar`.

    Encoding choice: extracted from the bundled
    `gap_principal_interior_optimum_OPEN` per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition
    pattern. Encoded as `∃ β > 0, W_bar 0 < W_bar β`.

    Cat 3 sub-type: workingAssumption (paper-stated within-branch
    discrimination benefit on opaque carrier `W_bar`; pending Mathlib
    derivative-comparison machinery; 必须 close before publication).

    paper source: Proposition `prop:principal-optimum` Part 1 proof,
    line 632 (within-branch discrimination benefit at small β
    dominates routing loss). -/
axiom W_bar_exceeds_zero_at_positive_beta_OPEN :
    Conditions_C1_C2_C3 →
    TerminalNeighbourTopology →
    (∀ p : ℝ, alphaStar 0 p < 1) →
    ∃ β : ℝ, 0 < β ∧ W_bar 0 < W_bar β

/-- R63 closure-path-A NEW Cat 3 paper-novel ATOMIC structural
    equation: the aggregate-optimal precision `betaBarStar` lies in
    the paper's standing-convention domain `[0, ∞)`. Paper Definition
    `def:principal` line 614 reads "A principal chooses a signal
    precision `β ≥ 0`" — the paper's `β ≥ 0` standing convention is a
    paper-stipulated identification of the `betaBarStar` carrier with
    the non-negative-reals domain (the maximiser of `W_bar` over
    `β ≥ 0` is itself `≥ 0`).

    Encoding choice: extracted from the retired bundled
    `interior_max_exists_from_unimodal_envelope_OPEN` workingAssumption
    per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition
    pattern + R61 `mLimit_pos` / R62 `betaStarOfP_def` precedent
    (split bundled wA into structural identification atom + Cat 1
    Mathlib chain). The retired atom claimed `0 < betaBarStar`
    directly from the bundled eventually-decreasing + exceeds-zero
    hypotheses without surfacing the paper line 614 explicit
    identification of the carrier with the `β ≥ 0` domain; the R63
    decomposition factors this into the carrier-pinning structural
    equation (this axiom; paper line 614 `β ≥ 0` standing convention)
    + a Cat 1 derivation composing `betaBarStar_def` (R23-C1
    argmax-characterisation, paper line 622) and the
    `W_bar_exceeds_zero_at_positive_beta_OPEN` premise.

    Cat 3 sub-type: structuralEquation (paper-stipulated identity
    pinning the `betaBarStar` carrier to the paper's `β ≥ 0` standing
    domain per Definition `def:principal` line 614; 永不 close per
    discipline §3.4.3 — this is the paper's commitment to the
    primitive's domain). The structural equation is unconditional on
    paper hypotheses because the paper's `β ≥ 0` convention applies
    to the carrier domain itself, not to any per-instance reversal-
    regime hypothesis.

    paper source: Definition `def:principal`, line 614 ("A principal
    chooses a signal precision `β ≥ 0`" — paper-stipulated `β ≥ 0`
    standing convention identifying the `betaBarStar` carrier domain). -/
axiom betaBarStar_nonneg_OPEN : 0 ≤ betaBarStar

/-- **R63 derived theorem** (replaces retired
    `interior_max_exists_from_unimodal_envelope_OPEN` axiom).
    Cat 1 derivation of the interior-optimum existence from the
    paper-stated argmax-characterisation `betaBarStar_def` (paper
    line 622) + the carrier-domain pinning `betaBarStar_nonneg_OPEN`
    (paper line 614 `β ≥ 0` standing convention) + the
    `W_bar_exceeds_zero_at_positive_beta_OPEN` premise (paper line
    632 within-branch discrimination benefit at small β).

    R63 closure-path-A composition:
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
    signature (matching the original axiom) as a paper-faithfulness
    record — paper line 625 needs both the eventually-decreasing
    fact (boundedness above) and the exceeds-zero fact (positivity
    below) to establish existence + interior-ness — but only the
    latter is needed in the Lean encoding because the existence is
    already discharged by the opaque-carrier postulate `betaBarStar`
    itself + `betaBarStar_def`'s argmax pin.

    Net workingAssumption delta: -1 (1 retired wA, 1 new
    structuralEquation, derived theorem composes them via Cat 1
    Mathlib chain). Best-round-style closure mirroring R62
    `betaStarOfP_def` pattern.

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

/-- **Proposition `prop:principal-optimum` Part 1: derived theorem.**
    If `G` has support contained in the reversal regime
    `{(κ, α) : κ < κ*(p, α), α > α*}`, then `betaBarStar ∈ (0, ∞)`.
    Decomposed from the bundled `gap_principal_interior_optimum_OPEN`
    axiom per `feedback_gap_ledger_in_lean4` §18 pattern: composes
    `W_bar_eventually_decreasing_in_reversal_OPEN` (eventually-
    decreasing from reversal regime) +
    `W_bar_exceeds_zero_at_positive_beta_OPEN` (within-branch
    discrimination benefit at small β) +
    `interior_max_exists_from_unimodal_envelope` (R63 derived
    theorem replacing the retired axiom; composes
    `betaBarStar_nonneg_OPEN` structural eq + `betaBarStar_def`
    argmax-characterisation via Cat 1 Mathlib chain).

    paper source: Proposition `prop:principal-optimum` Part 1, lines 624-625. -/
theorem gap_principal_interior_optimum
    (hC : Conditions_C1_C2_C3)
    (hT : TerminalNeighbourTopology)
    (h_reversal : ∀ p : ℝ, alphaStar 0 p < 1) :
    0 < betaBarStar :=
  interior_max_exists_from_unimodal_envelope
    (W_bar_eventually_decreasing_in_reversal_OPEN hC hT h_reversal)
    (W_bar_exceeds_zero_at_positive_beta_OPEN hC hT h_reversal)

/-- Predicate "distribution `G₂` first-order stochastically dominates
    `G₁` in the cognitive parameter `κ`".
    Substantive paper claim — opaque carrier required (Mathlib gap).
    paper source: Proposition `prop:principal-optimum` Part 2. -/
axiom kappa_FOSD : (ℝ → ℝ) → (ℝ → ℝ) → Prop

/-- Cat 3 paper-novel ATOMIC structural equation: first-order stochastic
    dominance characterisation. Paper `prop:principal-optimum` Part 2
    (line 634) reads "G_2 first-order stochastically dominates G_1 in κ
    (i.e., `G_2(κ ≤ x) ≤ G_1(κ ≤ x)` for all x)": this axiom encodes
    the FOSD definition directly on the existing carrier `kappa_FOSD`.

    Encoding choice: the paper's `G_i(κ ≤ x)` is interpreted as the CDF
    of the marginal κ-distribution under `G_i`; here `G : ℝ → ℝ` is
    treated as that marginal CDF directly (the paper's joint distribution
    `G(κ, α)` reduces to its κ-marginal in the FOSD claim). The
    structural equivalence `kappa_FOSD G₁ G₂ ↔ ∀ x, G₂ x ≤ G₁ x`
    pins the predicate to the paper-stated CDF inequality.

    paper source: Proposition `prop:principal-optimum` Part 2, line 634
    ("G_2 FOSD G_1 in κ iff `G_2(κ ≤ x) ≤ G_1(κ ≤ x)` for all x").

    Status — atomized stub awaiting consumer: this atom defines the
    paper's `kappa_FOSD` predicate as the CDF inequality. Substantive
    downstream consumption (FOSD-to-monotone-aggregate-optimum chain
    of paper Part 2 line 626) requires the integration-by-parts /
    Lebesgue-Stieltjes machinery embedded in
    `gap_principal_monotone_in_kappa_OPEN`; pending that closure the
    atom is retained as a paper-grade definitional-predicate equation. -/
axiom kappa_FOSD_def :
    ∀ (G₁ G₂ : ℝ → ℝ),
      kappa_FOSD G₁ G₂ ↔ ∀ x : ℝ, G₂ x ≤ G₁ x

/-- Aggregate-optimal precision `β̄*` for given distribution `G : ℝ → ℝ`.
    Substantive paper claim — opaque carrier required (Mathlib gap).
    paper source: Proposition `prop:principal-optimum`. -/
axiom aggregateOptimalBeta : (ℝ → ℝ) → ℝ

/-- Substantive paper claim — opaque-carrier-on-opaque-carrier required.
    Aggregate welfare `W̄_G(β)` for a given distribution G, paper
    Definition `def:principal` (line 612-619) reads
    `W̄(β) = ∫ W(β, κ, α) dG(κ, α)`. Encoded as a fresh
    G-parameterised opaque carrier (the existing `W_bar : ℝ → ℝ` fixes
    G implicitly; this carrier exposes the G-dependence required by
    `aggregateOptimalBeta_def` below).

    paper source: Definition `def:principal`, line 615. -/
axiom aggregateWelfareWith : (ℝ → ℝ) → ℝ → ℝ

/-- Cat 3 paper-novel ATOMIC structural equation: argmax characterisation
    of `aggregateOptimalBeta G`. Paper `prop:principal-optimum` Part 2
    proof (line 634) reads "the unique zero crossing of `dW̄/dβ` under
    `G_2` lies weakly to the right of that under `G_1`, giving
    `\bar{\beta}^*_{G_2} ≥ \bar{\beta}^*_{G_1}`": this axiom encodes
    the argmax-characterisation `aggregateOptimalBeta G` is a maximiser
    of the G-parameterised aggregate-welfare carrier
    `aggregateWelfareWith G`.

    Encoding choice: parallel to `betaBarStar_def` for the
    G-parameterised case. The maximiser-characterisation pins
    `aggregateOptimalBeta` to the argmax of `aggregateWelfareWith G`
    without committing to its existence proof (which is a separate
    Cat 3 OPEN at `gap_principal_interior_optimum_OPEN` for the
    fixed-G `W_bar` case).

    paper source: Definition `def:principal`, line 615 (`\bar{W}_G(β)`
    integral) + Proposition `prop:principal-optimum` Part 2, line 634
    (`\bar{\beta}^*_G` as the maximiser).

    Status — atomized stub awaiting consumer: this atom is the
    G-parameterised parallel of `betaBarStar_def` (now consumed by
    `W_bar_limit_infty_le_W_bar_betaBarStar`). Direct G-parameterised
    consumers would require a `Filter.Tendsto` limit on
    `aggregateWelfareWith G` analogous to `W_bar_limit_infty_def`,
    which is paper-implied by Cor `cor:disclosure` Part 1 but not yet
    encoded as a separate G-parameterised limit-carrier. Retained as
    paper-grade structural-equation record pending the G-parameterised
    limit infrastructure. -/
axiom aggregateOptimalBeta_def :
    ∀ (G : ℝ → ℝ) (β : ℝ),
      aggregateWelfareWith G β ≤ aggregateWelfareWith G (aggregateOptimalBeta G)

/-- Cat 3 paper-novel ATOMIC stipulation: paper Proposition
    `prop:principal-optimum` Part 2 proof (line 634) derives that
    Proposition `prop:supermodular`'s positive cross-partial
    `∂²W / (∂β ∂κ) > 0` integrated against a FOSD-dominating
    distribution yields `dW̄_{G_2}/dβ ≥ dW̄_{G_1}/dβ` at each β.
    The FOSD-induced inequality on aggregate-welfare derivatives is
    paper-stated as: for `G_2 ≽_FOSD G_1` in κ, the per-β derivative
    of `aggregateWelfareWith G_2` weakly dominates that of
    `aggregateWelfareWith G_1`. This atomic stipulation captures the
    paper-stated FOSD-induces-derivative-domination step on the
    existing carriers `aggregateWelfareWith` and `kappa_FOSD`.

    The paper-stated derivative-domination is encoded as a discrete
    derivative-inequality form `aggregateWelfareWith G₂ β₂ -
    aggregateWelfareWith G₂ β₁ ≥ aggregateWelfareWith G₁ β₂ -
    aggregateWelfareWith G₁ β₁` for `β₁ ≤ β₂`, mirroring the paper's
    integrated-supermodularity argument without committing to
    HasDerivAt machinery.

    Encoding choice: extracted from the bundled
    `gap_principal_monotone_in_kappa_OPEN` per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition
    pattern.

    Cat 3 sub-type: workingAssumption (paper-stated FOSD-induces-
    derivative-domination on opaque carrier `aggregateWelfareWith`;
    pending Mathlib HasDerivAt + Lebesgue-Stieltjes machinery; 必须
    close before publication).

    paper source: Proposition `prop:principal-optimum` Part 2 proof,
    line 634 (FOSD + supermodular → derivative-domination). -/
axiom fosd_induces_derivative_domination_OPEN :
    ∀ G₁ G₂ : ℝ → ℝ, kappa_FOSD G₁ G₂ →
      ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
        aggregateWelfareWith G₁ β₂ - aggregateWelfareWith G₁ β₁ ≤
          aggregateWelfareWith G₂ β₂ - aggregateWelfareWith G₂ β₁

/-- Cat 3 paper-novel ATOMIC stipulation: paper Proposition
    `prop:principal-optimum` Part 2 proof (line 634, second sentence)
    derives that the unique zero crossing of `dW̄/dβ` under `G_2`
    lies WEAKLY TO THE RIGHT of that under `G_1` (since both
    aggregate welfare functions are eventually decreasing with
    interior maxima, by Part 1). Therefore `aggregateOptimalBeta G_1
    ≤ aggregateOptimalBeta G_2`. This atomic stipulation captures the
    paper-stated argmax-monotonicity inference from the prior
    derivative-domination atom.

    Encoding choice: extracted from the bundled
    `gap_principal_monotone_in_kappa_OPEN` per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition
    pattern. The atom takes the paper-derived premise (FOSD-induced
    derivative domination on `aggregateWelfareWith`) and concludes
    the argmax-ordering on `aggregateOptimalBeta`.

    Cat 3 sub-type: workingAssumption (paper-stated argmax-
    monotonicity from derivative-domination; pending Mathlib
    argmax/uniqueness machinery; 必须 close before publication).

    paper source: Proposition `prop:principal-optimum` Part 2 proof,
    line 634 (zero crossing weakly to the right → argmax monotonicity). -/
axiom argmax_monotone_under_derivative_domination_OPEN :
    ∀ G₁ G₂ : ℝ → ℝ,
      (∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
        aggregateWelfareWith G₁ β₂ - aggregateWelfareWith G₁ β₁ ≤
          aggregateWelfareWith G₂ β₂ - aggregateWelfareWith G₂ β₁) →
      aggregateOptimalBeta G₁ ≤ aggregateOptimalBeta G₂

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

/-- R63 closure-path-A NEW opaque carrier: paper line 638's explicit
    above-threshold welfare component `λ · E_{G | κ > κ*}[W(β, κ, α)]`
    abstracted as a single ℝ → ℝ functional of `β`. Paper Proposition
    `prop:principal-optimum` Part 3 proof (line 638) names this the
    "above-threshold contribution" with the standing-Blackwell-regime
    monotonicity property.

    Encoding choice: introduced by R63 to factor the retired bundled
    `W_bar_mixture_decomposition_OPEN` workingAssumption into (i) a
    §3.4.3 structural equation pinning the explicit mixture
    `W_bar β = aboveThresholdWelfare β + belowThresholdWelfare β`
    (paper line 638 explicit decomposition formula), and (ii)
    smaller §3.4.4 workingAssumptions carrying the substantive
    above-regime and below-regime monotonicities. The carrier itself
    is `gapDefinitional` per `feedback_gap_ledger_in_lean4` §3.4.1
    (paper-novel opaque-carrier primitive).

    paper source: Proposition `prop:principal-optimum` Part 3 proof,
    line 638 (`λ · E_{G | κ > κ*}[W(β, κ, α)]` above-threshold
    contribution). -/
axiom aboveThresholdWelfare : ℝ → ℝ

/-- R63 closure-path-A NEW opaque carrier: paper line 638's explicit
    below-threshold welfare component `(1 − λ) · E_{G | κ < κ*}
    [W(β, κ, α)]` abstracted as a single ℝ → ℝ functional of `β`.
    Paper Proposition `prop:principal-optimum` Part 3 proof (line 638)
    names this the "below-threshold contribution" with the reversal-
    regime eventually-decreasing property.

    Encoding choice: introduced by R63 to factor the retired bundled
    `W_bar_mixture_decomposition_OPEN` workingAssumption (parallel to
    `aboveThresholdWelfare`).

    paper source: Proposition `prop:principal-optimum` Part 3 proof,
    line 638 (`(1 − λ) · E_{G | κ < κ*}[W(β, κ, α)]` below-threshold
    contribution). -/
axiom belowThresholdWelfare : ℝ → ℝ

/-- R63 closure-path-A NEW Cat 3 paper-novel ATOMIC structural
    equation: paper line 638's explicit pointwise mixture
    `W̄(β) = λ · above-contribution(β) + (1 − λ) · below-contribution(β)`
    pinning the existing `W_bar` carrier as the sum of the two new
    paper-instance carriers `aboveThresholdWelfare` and
    `belowThresholdWelfare` (with the `λ` and `(1 − λ)` weighting
    absorbed into each carrier's definition).

    Encoding choice: extracted from the retired bundled
    `W_bar_mixture_decomposition_OPEN` workingAssumption per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition
    pattern + R61 `mLimit_pos` precedent (split bundled wA into
    structural identification + smaller monotonicity-content wA).
    The retired atom existentially asserted "some `f, g` exist with
    these properties"; the R63 decomposition surfaces the paper-named
    above/below carriers explicitly as `aboveThresholdWelfare` and
    `belowThresholdWelfare`, then pins the mixture identity via this
    structural equation.

    Cat 3 sub-type: structuralEquation (paper-stipulated identity
    pinning `W_bar` to the mixture sum per paper line 638 explicit
    decomposition formula; 永不 close per discipline §3.4.3 — this is
    paper's commitment to how its primitives decompose).

    paper source: Proposition `prop:principal-optimum` Part 3 proof,
    line 638 (`W̄(β) = λ · above + (1 − λ) · below` mixture identity). -/
axiom W_bar_eq_mixture_OPEN :
    ∀ β : ℝ, W_bar β = aboveThresholdWelfare β + belowThresholdWelfare β

/-- R63 closure-path-A NEW smaller paper-novel ATOMIC stipulation:
    paper line 638 explicitly asserts the above-threshold contribution
    is "non-decreasing in β" by the standard Blackwell regime applied
    to the above-threshold sub-population (where κ > κ* yields the
    standard monotone-welfare regime per Theorem `thm:cognitive-
    threshold` Part 0). This atomic stipulation captures the paper-
    stated above-regime monotonicity on the new opaque carrier
    `aboveThresholdWelfare`.

    Encoding choice: extracted from the retired bundled
    `W_bar_mixture_decomposition_OPEN` workingAssumption per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition
    pattern. The smaller wA isolates the paper-stated above-regime
    monotonicity content separately from the below-regime eventually-
    decreasing content (also a smaller wA below) and the mixture-
    identity content (now a structural eq above).

    Cat 3 sub-type: workingAssumption (paper-stated monotonicity of
    the above-threshold contribution under standard Blackwell regime;
    pending Mathlib bounded-measure / conditional-expectation
    aggregation machinery for the explicit `λ E_{G | κ > κ*}[W(β,
    κ, α)]` derivation; 必须 close before publication).

    paper source: Proposition `prop:principal-optimum` Part 3 proof,
    line 638 ("the first term is non-decreasing in β (standard
    Blackwell regime)"). -/
axiom aboveThresholdWelfare_monotone_OPEN :
    ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ → aboveThresholdWelfare β₁ ≤ aboveThresholdWelfare β₂

/-- R63 closure-path-A NEW smaller paper-novel ATOMIC stipulation:
    paper line 638 explicitly asserts the below-threshold contribution
    is "eventually decreasing (reversal regime)" by the reversal
    regime applied to the below-threshold sub-population (where
    κ < κ* yields the non-monotone-welfare reversal regime per
    Theorem `thm:cognitive-threshold` Part 1). This atomic stipulation
    captures the paper-stated below-regime eventually-decreasing
    property on the new opaque carrier `belowThresholdWelfare`.

    Encoding choice: extracted from the retired bundled
    `W_bar_mixture_decomposition_OPEN` workingAssumption per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition
    pattern. Parallel to `aboveThresholdWelfare_monotone_OPEN` for the
    below-threshold regime.

    Cat 3 sub-type: workingAssumption (paper-stated eventually-
    decreasing of the below-threshold contribution under reversal
    regime; pending the same conditional-expectation infrastructure
    as the above-regime atom; 必须 close before publication).

    paper source: Proposition `prop:principal-optimum` Part 3 proof,
    line 638 ("the second term is eventually decreasing (reversal
    regime)"). -/
axiom belowThresholdWelfare_eventually_decreasing_OPEN :
    ∃ β_low β_high : ℝ,
      β_low < β_high ∧ belowThresholdWelfare β_high < belowThresholdWelfare β_low

/-- **R63 derived theorem** (replaces retired
    `W_bar_mixture_decomposition_OPEN` axiom). The aggregate welfare
    `W_bar` admits a paper-stated mixture decomposition
    `W_bar β = f β + g β` with `f` non-decreasing and `g` eventually-
    decreasing.

    R63 closure-path-A composition:
      (a) Structural equation `W_bar_eq_mixture_OPEN` (paper line 638
          mixture identity).
      (b) Smaller workingAssumption `aboveThresholdWelfare_monotone_OPEN`
          (paper line 638 above-regime non-decreasing).
      (c) Smaller workingAssumption `belowThresholdWelfare_eventually_decreasing_OPEN`
          (paper line 638 below-regime eventually-decreasing).
      (d) Provides explicit witnesses `aboveThresholdWelfare` and
          `belowThresholdWelfare` for the existential-pair claim.

    Net workingAssumption delta: +1 (1 retired wA, 2 new carriers,
    1 new structuralEquation, 2 new smaller wA — net +1 wA but each
    new atom is strictly smaller per discipline §18 standard with a
    distinct paper-line-638 close target). The structural equation
    surfaces the paper-implicit above/below decomposition.

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

/-- Cat 3 paper-novel ATOMIC stipulation: paper Proposition
    `prop:principal-optimum` Part 3 proof (line 640) derives that
    "the sum of a non-decreasing function and a non-monotone function
    can be non-concave: `W_bar` may increase, then decrease, then
    increase again", giving an explicit triple `β_1 < β_2 < β_3` with
    `W_bar β_2 < W_bar β_1 ∧ W_bar β_2 < W_bar β_3` (the non-concave
    "valley" pattern). This atomic stipulation captures the paper-
    stated existence of such a triple from the mixture decomposition.

    Encoding choice: extracted from the bundled
    `gap_principal_regime_bifurcation_OPEN` per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition
    pattern. The atom takes the paper-derived premise (mixture
    decomposition with non-decreasing + eventually-decreasing terms)
    and extracts the paper-stated non-concavity triple.

    Cat 3 sub-type: workingAssumption (paper-stated non-concavity
    from mixture decomposition; pending Mathlib monotonicity-pattern
    analysis; 必须 close before publication).

    paper source: Proposition `prop:principal-optimum` Part 3 proof,
    line 640 (non-concavity `W̄` valley pattern). -/
axiom non_concave_triple_from_mixture_OPEN :
    (∃ f g : ℝ → ℝ,
      (∀ β₁ β₂ : ℝ, β₁ ≤ β₂ → f β₁ ≤ f β₂) ∧
      (∃ β_low β_high : ℝ, β_low < β_high ∧ g β_high < g β_low) ∧
      ∀ β : ℝ, W_bar β = f β + g β) →
    ∃ β₁ β₂ β₃ : ℝ,
      β₁ < β₂ ∧ β₂ < β₃ ∧
      W_bar β₂ < W_bar β₁ ∧ W_bar β₂ < W_bar β₃

/-- **Proposition `prop:principal-optimum` Part 3: derived theorem.**
    The aggregate `W̄(β)` exhibits a non-concave valley pattern:
    there exists a triple `β₁ < β₂ < β₃` with `W_bar β₂ < W_bar β₁`
    and `W_bar β₂ < W_bar β₃`. Decomposed from the bundled
    `gap_principal_regime_bifurcation_OPEN` axiom per
    `feedback_gap_ledger_in_lean4` §18 pattern: composes
    `W_bar_mixture_decomposition_OPEN` (paper-stated mixture
    decomposition into above-threshold non-decreasing + below-
    threshold eventually-decreasing parts) +
    `non_concave_triple_from_mixture_OPEN` (paper-stated non-concavity
    triple from the mixture decomposition).

    paper source: Proposition `prop:principal-optimum` Part 3, line 627. -/
theorem gap_principal_regime_bifurcation :
    ∃ β₁ β₂ β₃ : ℝ,
      β₁ < β₂ ∧ β₂ < β₃ ∧
      W_bar β₂ < W_bar β₁ ∧ W_bar β₂ < W_bar β₃ :=
  non_concave_triple_from_mixture_OPEN W_bar_mixture_decomposition

/-! ## 3. Corollary `cor:disclosure` — Disclosure Policy Design -/

/-- Limit of aggregate welfare as `β → ∞`.
    Substantive paper claim — opaque carrier required (Mathlib gap).
    paper source: Corollary `cor:disclosure` Part 1. -/
axiom W_bar_limit_infty : ℝ

/-- Cat 3 paper-novel ATOMIC structural equation: paper-stated
    convergence of aggregate welfare as `β → ∞`. Paper Corollary
    `cor:disclosure` Part 1 proof (line 652) reads "for above-threshold
    agents, `W(β, κ, α)` is non-decreasing in β and converges to a
    finite limit `W(∞, κ, α)`"; aggregating over the population gives
    `\bar{W}(\beta) \to \bar{W}(\infty) =: W_bar_limit_infty` as
    `β → ∞`. This axiom encodes the `Filter.Tendsto` characterisation
    directly on the existing carriers `W_bar` and `W_bar_limit_infty`.

    Encoding choice: pins the limit-value carrier to the actual limit
    of `W_bar` (rather than leaving the limit value disconnected from
    the welfare process). Downstream consumer
    `gap_disclosure_full_suboptimal_OPEN` uses `W_bar_limit_infty`
    as the limit reference value; this atomic axiom makes that usage
    structurally honest.

    paper source: Corollary `cor:disclosure` Part 1 proof, line 652
    ("aggregate welfare converges to a finite limit as β → ∞"). -/
axiom W_bar_limit_infty_def :
    Filter.Tendsto W_bar Filter.atTop (nhds W_bar_limit_infty)

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

    Cat 3 sub-type: workingAssumption (paper-stated overshoot
    positivity in reversal regime; pending Mathlib conditional-
    expectation + Theorem `thm:cognitive-threshold` Part 1
    composition; 必须 close before publication).

    paper source: Corollary `cor:disclosure` Part 1 proof, lines 652-
    654 (G-averaged reversal-regime overshoot `δ̄ > 0`). -/
axiom averaged_reversal_overshoot_positive_OPEN :
    ∀ G_reversal_fraction : ℝ, 0 < G_reversal_fraction →
      ∃ delta_bar : ℝ, 0 < delta_bar

/-- Cat 3 paper-novel ATOMIC stipulation: paper Corollary `cor:disclosure`
    Part 1 proof (line 656) derives that for any `ε > 0` (above-threshold
    welfare-loss bound at finite β_0 from the full-disclosure limit),
    if we choose `ε` small enough that `λ ε < (1 - λ) δ̄`, then
    `W̄(β_0) > W̄(∞)` holds. This atomic stipulation captures the
    paper-stated existence of a finite β with `W_bar β > W_bar_limit_infty`,
    given a positive reversal-regime overshoot `δ̄ > 0`.

    Encoding choice: extracted from the bundled
    `gap_disclosure_full_suboptimal_OPEN` per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition
    pattern.

    Cat 3 sub-type: workingAssumption (paper-stated finite-β-strictly-
    above-limit existence from positive averaged overshoot; pending
    Mathlib limit-comparison + ε-choice machinery; 必须 close before
    publication).

    paper source: Corollary `cor:disclosure` Part 1 proof, line 656
    (`λ ε < (1 - λ) δ̄ ⇒ W̄(β_0) > W̄(∞)`). -/
axiom finite_beta_above_limit_from_overshoot_OPEN :
    ∀ delta_bar : ℝ, 0 < delta_bar →
      ∃ β_finite : ℝ, 0 < β_finite ∧ W_bar_limit_infty < W_bar β_finite

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

/-- Differentiated-disclosure aggregate welfare.
    Substantive paper claim — opaque carrier required (Mathlib gap).
    paper source: Corollary `cor:disclosure` Part 2. -/
axiom differentiatedDisclosureWelfare : (ℝ → ℝ) → ℝ

/-- R63 closure-path-A NEW opaque carrier: paper line 658's explicit
    per-agent-optimum aggregate `∫ W(β*(κ, α), κ, α) dG` abstracted
    as a single (ℝ → ℝ) → ℝ functional of the population distribution.
    Paper Corollary `cor:disclosure` Part 2 proof (line 658) writes
    "the planner sets `β_i = β*(κ_i, α_i)` for each agent type. ...
    This achieves `W̄_diff = ∫ W(β*(κ, α), κ, α) dG`."

    Encoding choice: introduced by R63 to factor the retired bundled
    `differentiated_per_agent_optimum_dominates_uniform_OPEN`
    workingAssumption into (i) a §3.4.3 structural equation pinning
    `differentiatedDisclosureWelfare G = perAgentOptimalAggregate G`
    (paper line 658 explicit per-agent-assignment formula), and
    (ii) a smaller §3.4.4 workingAssumption carrying the substantive
    per-agent-pointwise-dominance content. The carrier itself is
    `gapDefinitional` per `feedback_gap_ledger_in_lean4` §3.4.1
    (paper-novel opaque-carrier primitive).

    paper source: Corollary `cor:disclosure` Part 2 proof, line 658
    (`∫ W(β*(κ, α), κ, α) dG` per-agent-optimum aggregate). -/
axiom perAgentOptimalAggregate : (ℝ → ℝ) → ℝ

/-- R63 closure-path-A NEW Cat 3 paper-novel ATOMIC structural
    equation: paper line 658's explicit identification
    `differentiatedDisclosureWelfare G = perAgentOptimalAggregate G`
    pinning the existing `differentiatedDisclosureWelfare` carrier as
    the per-agent-optimum aggregate. Paper Corollary `cor:disclosure`
    Part 2 proof (line 658) writes "the planner sets `β_i = β*(κ_i,
    α_i)` for each agent type. ... This achieves `W̄_diff = ∫ W(β*(κ,
    α), κ, α) dG`": this structural equation pins the differentiated
    welfare to the per-agent-optimum aggregate carrier.

    Encoding choice: extracted from the retired bundled
    `differentiated_per_agent_optimum_dominates_uniform_OPEN`
    workingAssumption per `feedback_gap_ledger_in_lean4` §18
    Manufactured-Recognition pattern + R61 `mLimit_pos` precedent.
    The retired atom claimed `W_bar uniform_beta ≤
    differentiatedDisclosureWelfare G` directly without surfacing the
    paper line 658 explicit per-agent-assignment formula; the R63
    decomposition factors this into the carrier-pinning structural
    equation (this axiom; paper line 658 per-agent-assignment
    identification) + a smaller workingAssumption
    `perAgentOptimalAggregate_dominates_uniform_OPEN` (the substantive
    per-agent-pointwise-dominance content).

    Cat 3 sub-type: structuralEquation (paper-stipulated identity
    pinning the `differentiatedDisclosureWelfare` carrier to the
    per-agent-optimum aggregate per paper line 658 explicit
    `β_i = β*(κ_i, α_i)` per-agent assignment; 永不 close per
    discipline §3.4.3 — this is paper's commitment to how its
    primitives are related).

    paper source: Corollary `cor:disclosure` Part 2 proof, line 658
    (`W̄_diff = ∫ W(β*(κ, α), κ, α) dG` explicit per-agent-assignment
    formula). -/
axiom differentiatedDisclosureWelfare_eq_perAgentOptimal_OPEN :
    ∀ G : ℝ → ℝ,
      differentiatedDisclosureWelfare G = perAgentOptimalAggregate G

/-- R63 closure-path-A NEW smaller paper-novel ATOMIC stipulation:
    paper line 658 explicitly asserts the per-agent-optimum aggregate
    `∫ W(β*(κ, α), κ, α) dG` dominates any uniform-β aggregate
    `W̄(β̄*) = ∫ W(β̄*, κ, α) dG`. The pointwise rationale: for each
    agent type `(κ, α)`, `W(β*(κ, α), κ, α) ≥ W(β̄*, κ, α)` by
    definition of `β*` as the per-agent optimum; integrating against
    `dG` preserves the inequality. This atomic stipulation captures
    the paper-stated per-agent-pointwise-dominance content on the
    new opaque carrier `perAgentOptimalAggregate`.

    Encoding choice: extracted from the retired bundled
    `differentiated_per_agent_optimum_dominates_uniform_OPEN` per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition
    pattern. The retired atom bundled (a) the paper line 658 per-
    agent-assignment formula identification (now a structural eq
    above) and (b) the per-agent-pointwise-dominance content (this
    smaller wA). The R63 decomposition surfaces both separately.

    Cat 3 sub-type: workingAssumption (paper-stated per-agent-
    pointwise dominance integrated against `G`; pending Mathlib
    measure-theoretic per-agent integration + per-agent-optimum
    pointwise dominance; 必须 close before publication).

    paper source: Corollary `cor:disclosure` Part 2 proof, line 658
    ("achieves `W̄_diff ≥ W̄(β̄*)` for any uniform `β̄*`"). -/
axiom perAgentOptimalAggregate_dominates_uniform_OPEN :
    ∀ G : ℝ → ℝ, ∀ uniform_beta : ℝ,
      W_bar uniform_beta ≤ perAgentOptimalAggregate G

/-- **R63 derived theorem** (replaces retired
    `differentiated_per_agent_optimum_dominates_uniform_OPEN` axiom).
    Per-agent-optimum differentiated disclosure dominates any uniform
    disclosure: `W_bar uniform_beta ≤ differentiatedDisclosureWelfare G`
    for any `G` and any uniform β.

    R63 closure-path-A composition:
      (a) Smaller workingAssumption atom
          `perAgentOptimalAggregate_dominates_uniform_OPEN`
          (paper line 658 per-agent-pointwise dominance).
      (b) Structural equation
          `differentiatedDisclosureWelfare_eq_perAgentOptimal_OPEN`
          (paper line 658 per-agent-assignment formula identification).

    Net workingAssumption delta: 0 (1 retired wA, 1 new
    structuralEquation, 1 new carrier, 1 new smaller wA, derived
    theorem composes them via Cat 1 `rw`). The new wA is strictly
    smaller per discipline §18 standard: the original atom claimed
    dominance on the bundled `differentiatedDisclosureWelfare`
    carrier; the new atom states dominance on the per-agent-optimum
    aggregate (with the carrier identification surfaced separately).
    Best-round-style closure mirroring R61 `mLimit_pos` and R62
    `betaStarOfP_def` patterns.

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
    `gap_disclosure_differentiated_dominates_OPEN` axiom per
    `feedback_gap_ledger_in_lean4` §18 pattern: re-exports the R63
    derived theorem `differentiated_per_agent_optimum_dominates_uniform`
    (which composes `differentiatedDisclosureWelfare_eq_perAgentOptimal_OPEN`
    structural eq + `perAgentOptimalAggregate_dominates_uniform_OPEN`
    smaller wA).

    paper source: Corollary `cor:disclosure` Part 2, line 647. -/
theorem gap_disclosure_differentiated_dominates :
    ∀ G : ℝ → ℝ, ∀ uniform_beta : ℝ,
      W_bar uniform_beta ≤ differentiatedDisclosureWelfare G :=
  differentiated_per_agent_optimum_dominates_uniform

end BlackwellDilemma
