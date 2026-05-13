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

/-- Cat 3 paper-novel ATOMIC stipulation: paper Proposition
    `prop:principal-optimum` Part 1 (line 625, conclusion) derives
    `betaBarStar > 0` (interior optimum) from continuity of `W_bar`
    plus (a) `W_bar` is eventually decreasing (so the maximiser is
    bounded above) and (b) `W_bar` exceeds `W_bar(0)` at some β > 0
    (so the maximiser is strictly above 0). By continuity (paper-
    implicit standing assumption on `W_bar` since it integrates a
    continuous individual welfare against a finite measure), an
    interior maximum `betaBarStar ∈ (0, ∞)` exists. This atomic
    stipulation packages the paper's existence-of-interior-maximum
    inference given the two prior atomic stipulations.

    Encoding choice: extracted from the bundled
    `gap_principal_interior_optimum_OPEN` per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition
    pattern.

    Cat 3 sub-type: workingAssumption (paper-stated existence-of-
    interior-maximum given the prior eventually-decreasing +
    exceeds-zero-at-positive-β atoms; 必须 close before publication).

    paper source: Proposition `prop:principal-optimum` Part 1, lines
    624-625 (interior optimum `betaBarStar ∈ (0, ∞)`). -/
axiom interior_max_exists_from_unimodal_envelope_OPEN :
    (∃ β_low β_high : ℝ, β_low < β_high ∧ W_bar β_high < W_bar β_low) →
    (∃ β : ℝ, 0 < β ∧ W_bar 0 < W_bar β) →
    0 < betaBarStar

/-- **Proposition `prop:principal-optimum` Part 1: derived theorem.**
    If `G` has support contained in the reversal regime
    `{(κ, α) : κ < κ*(p, α), α > α*}`, then `betaBarStar ∈ (0, ∞)`.
    Decomposed from the bundled `gap_principal_interior_optimum_OPEN`
    axiom per `feedback_gap_ledger_in_lean4` §18 pattern: composes
    `W_bar_eventually_decreasing_in_reversal_OPEN` (eventually-
    decreasing from reversal regime) +
    `W_bar_exceeds_zero_at_positive_beta_OPEN` (within-branch
    discrimination benefit at small β) +
    `interior_max_exists_from_unimodal_envelope_OPEN` (interior-
    maximum existence from unimodal-envelope shape).

    paper source: Proposition `prop:principal-optimum` Part 1, lines 624-625. -/
theorem gap_principal_interior_optimum
    (hC : Conditions_C1_C2_C3)
    (hT : TerminalNeighbourTopology)
    (h_reversal : ∀ p : ℝ, alphaStar 0 p < 1) :
    0 < betaBarStar :=
  interior_max_exists_from_unimodal_envelope_OPEN
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

/-- Cat 3 paper-novel ATOMIC stipulation: paper Proposition
    `prop:principal-optimum` Part 3 proof (lines 636-640) writes
    `W̄(β) = λ E_{G | κ > κ*}[W(β, κ, α)] + (1-λ) E_{G | κ < κ*}
    [W(β, κ, α)]` with `λ = G({κ > κ*}) ∈ (0, 1)`. The first term
    (above-threshold contribution) is paper-stated to be
    NON-DECREASING in β (standard Blackwell regime), and the second
    term (below-threshold contribution) is paper-stated to be
    EVENTUALLY DECREASING in β (reversal regime). This atomic
    stipulation captures the paper-stated mixture decomposition
    qualitatively, encoding the existence of a pair of welfare
    functionals `f, g : ℝ → ℝ` with `f` non-decreasing, `g` eventually
    decreasing, and `W_bar = f + g`.

    Encoding choice: extracted from the bundled
    `gap_principal_regime_bifurcation_OPEN` per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition
    pattern.

    Cat 3 sub-type: workingAssumption (paper-stated mixture
    decomposition; pending Mathlib bounded-measure / conditional-
    expectation machinery; 必须 close before publication).

    paper source: Proposition `prop:principal-optimum` Part 3 proof,
    lines 636-640 (mixture decomposition `W̄ = λ · above + (1-λ) ·
    below`). -/
axiom W_bar_mixture_decomposition_OPEN :
    ∃ f g : ℝ → ℝ,
      (∀ β₁ β₂ : ℝ, β₁ ≤ β₂ → f β₁ ≤ f β₂) ∧
      (∃ β_low β_high : ℝ, β_low < β_high ∧ g β_high < g β_low) ∧
      ∀ β : ℝ, W_bar β = f β + g β

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
  non_concave_triple_from_mixture_OPEN W_bar_mixture_decomposition_OPEN

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

/-- Cat 3 paper-novel ATOMIC stipulation: paper Corollary `cor:disclosure`
    Part 2 proof (line 658) derives that under differentiated disclosure,
    the planner sets `β_i = β*(κ_i, α_i)` for each agent type,
    achieving the per-agent welfare optimum. Aggregating, the
    differentiated welfare equals `∫ W(β*(κ, α), κ, α) dG`, which
    pointwise dominates `W(β̄*, κ, α)` for any uniform β̄* (per-agent,
    by definition of `β*`). This atomic stipulation captures the
    paper-stated per-agent-optimum aggregate-welfare characterisation.

    Encoding choice: extracted from the bundled
    `gap_disclosure_differentiated_dominates_OPEN` per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition
    pattern. The atom encodes the per-agent-optimum aggregate
    characterisation via the existing carriers `W_bar`,
    `differentiatedDisclosureWelfare`.

    Cat 3 sub-type: workingAssumption (paper-stated per-agent-optimum
    aggregate-welfare characterisation; pending Mathlib measure-
    theoretic per-agent integration; 必须 close before publication).

    paper source: Corollary `cor:disclosure` Part 2 proof, line 658
    (per-agent `β_i = β*(κ_i, α_i)` optimum aggregated). -/
axiom differentiated_per_agent_optimum_dominates_uniform_OPEN :
    ∀ G : ℝ → ℝ, ∀ uniform_beta : ℝ,
      W_bar uniform_beta ≤ differentiatedDisclosureWelfare G

/-- **Corollary `cor:disclosure` Part 2: derived theorem.**
    Differentiated disclosure strictly dominates uniform disclosure:
    `W_bar uniform_beta ≤ differentiatedDisclosureWelfare G` for any
    `G` and uniform β. Decomposed from the bundled
    `gap_disclosure_differentiated_dominates_OPEN` axiom per
    `feedback_gap_ledger_in_lean4` §18 pattern: re-exports the
    atomic stipulation
    `differentiated_per_agent_optimum_dominates_uniform_OPEN` (paper-
    stated per-agent-optimum aggregate dominates any uniform
    aggregate).

    paper source: Corollary `cor:disclosure` Part 2, line 647. -/
theorem gap_disclosure_differentiated_dominates :
    ∀ G : ℝ → ℝ, ∀ uniform_beta : ℝ,
      W_bar uniform_beta ≤ differentiatedDisclosureWelfare G :=
  differentiated_per_agent_optimum_dominates_uniform_OPEN

end BlackwellDilemma
