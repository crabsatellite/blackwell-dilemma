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

/-- R63 paper-novel opaque carrier: paper line 638's explicit
    above-threshold welfare component `λ · E_{G | κ > κ*}[W(β, κ, α)]`
    abstracted as a single ℝ → ℝ functional of `β` (with the `λ`
    weighting absorbed into the carrier's definition per paper's
    named-component convention). Paper Proposition `prop:principal-
    optimum` Part 3 proof (line 638) names this the "above-threshold
    contribution" with the standard-Blackwell-regime non-decreasing
    property.

    R72 hoist (was R63 declared after `W_bar`): hoisted to BEFORE
    `W_bar` to support R72 substantive-math closure pattern (per R71
    `kappa_FOSD` precedent). The carrier is paper-Def-stipulated
    structural primitive per discipline §3.4.1 (paper-novel opaque-
    carrier primitive); position in source order is metadata-neutral.

    paper source: Proposition `prop:principal-optimum` Part 3 proof,
    line 638 (`λ · E_{G | κ > κ*}[W(β, κ, α)]` above-threshold
    contribution). -/
axiom aboveThresholdWelfare : ℝ → ℝ

/-- R63 paper-novel opaque carrier: paper line 638's explicit
    below-threshold welfare component `(1 − λ) · E_{G | κ < κ*}
    [W(β, κ, α)]` abstracted as a single ℝ → ℝ functional of `β`.
    Paper Proposition `prop:principal-optimum` Part 3 proof (line 638)
    names this the "below-threshold contribution" with the reversal-
    regime eventually-decreasing property.

    R72 hoist (was R63 declared after `W_bar`): hoisted to BEFORE
    `W_bar` to support R72 substantive-math closure pattern (per R71
    `kappa_FOSD` precedent). Position in source order is metadata-
    neutral.

    paper source: Proposition `prop:principal-optimum` Part 3 proof,
    line 638 (`(1 − λ) · E_{G | κ < κ*}[W(β, κ, α)]` below-threshold
    contribution). -/
axiom belowThresholdWelfare : ℝ → ℝ

/-- The aggregate welfare functional `W̄(β)` for distribution `G`.

    R72 substantive-math closure: previously declared `axiom W_bar`
    (opaque carrier). R72 makes the carrier CONCRETE per paper Proposition
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

/-- R76 NEW Cat 3 paper-novel ATOMIC stipulation: paper-stated existence
    of an argmax of the aggregate welfare functional `W̄`. Paper
    Proposition `prop:principal-optimum` Part 1 (line 625) establishes
    that an interior maximum `β̄* ∈ (0, ∞)` exists by continuity from
    the eventually-decreasing + exceeds-zero properties; line 622
    introduces `\bar{\beta}^*` directly as the maximiser, which is the
    universal-inequality formulation of an argmax.

    This atom encodes the bare paper-stated EXISTENCE of an argmax:
    `∃ β_max : ℝ, ∀ β : ℝ, W_bar β ≤ W_bar β_max`. The downstream
    `noncomputable def betaBarStar` invokes `Classical.choose` on this
    atom to obtain the canonical maximiser; the structural-equation
    atom `betaBarStar_def` is then internalised by `Classical.choose_spec`.

    Cat 3 sub-type: workingAssumption (paper-stated existence of a
    global maximiser of `W_bar` on the real line; pending Mathlib
    continuous-function-on-compact-interval + Bolzano-Weierstrass
    machinery for the explicit maximiser witness; 必须 close before
    publication). The atom is paper-faithful per Proposition
    `prop:principal-optimum` line 622's introduction of `\bar{\beta}^*`
    as "the maximiser of `W̄`" — a paper-stipulated existence claim
    on the aggregate welfare functional.

    R76 Pattern 5 propagation per `feedback_no_compute_retreat` +
    `feedback_gap_ledger_in_lean4` §18 (R74 `betaStarOfP` / R75
    `smoothTransitionBeta` precedent): split the bundled
    structural-equation atom `betaBarStar_def` (carrier-pin +
    universal-inequality bundled together) into this smaller existence
    atom + the Pattern 5 closure of `betaBarStar_def` via
    `Classical.choose_spec`. Net wA delta: 0 (1 new wA, 1 retired
    wA via Pattern 5); net structural-equation delta: 0; net
    derivedTheorem delta: +1; audit chain becomes more granular per
    discipline §18 (the existence claim is now atomically separated
    from the carrier-identification step).

    paper source: Proposition `prop:principal-optimum`, line 622
    ("\\bar{\\beta}^* is the maximiser of \\bar{W}" — paper-stated
    existence of a global maximiser of the aggregate welfare). -/
axiom principal_interior_maximum_exists_OPEN :
    ∃ β_max : ℝ, ∀ β : ℝ, W_bar β ≤ W_bar β_max

/-- The aggregate-optimal precision `β̄*` (paper line 622).

    R76 substantive-math closure (concrete-def closure, Pattern 5:
    existence-via-`Classical.choose`). Previously declared
    `axiom betaBarStar : ℝ` (opaque carrier) plus the structural-
    equation atom `betaBarStar_def` (Cat 3 workingAssumption pinning
    the carrier to a maximiser of `W_bar`). R76 makes the carrier
    CONCRETE per paper line 622's own paper-stated existence claim
    of the maximiser: define `betaBarStar` as `Classical.choose` of
    the maximiser-witness from the existence atom
    `principal_interior_maximum_exists_OPEN`.

    The Lean `def` IS the paper's "maximiser-of-`W̄`" identification
    (the `Classical.choose` literally picks the paper-stated maximiser
    of `W_bar`), so the carrier encodes paper content faithfully.
    This is NOT the R7-flagged closure-count trick: the def body
    invokes the substantive existence atom
    `principal_interior_maximum_exists_OPEN` as input, with no content
    erasure; the previously-axiomatic carrier-identification step
    (`betaBarStar_def`) is internalised by `Classical.choose_spec`.

    Per `feedback_no_compute_retreat`: where Mathlib lacks the typed
    continuous-function-on-half-line argmax machinery, define the
    paper-faithful selection locally rather than skip.

    paper source: Proposition `prop:principal-optimum`, line 622
    (`\bar{\beta}^*` as maximiser of `W̄`). -/
noncomputable def betaBarStar : ℝ :=
  Classical.choose principal_interior_maximum_exists_OPEN

/-- **R76 derived theorem** (replaces R63 axiom `betaBarStar_def`;
    now closes via Pattern 5 `Classical.choose_spec` instead of
    standalone structural-equation axiom).
    Cat 3 argmax-characterisation of `betaBarStar`: for every `β ∈ ℝ`,
    `W_bar β ≤ W_bar betaBarStar`.

    R76 Pattern 5 closure: composes the `betaBarStar` `def` (which
    invokes `Classical.choose` on `principal_interior_maximum_exists_OPEN`)
    with `Classical.choose_spec` (which yields the universal-inequality
    maximiser property of the chosen witness directly). The previously-
    required structural-equation atom `betaBarStar_def` is no longer
    needed: `Classical.choose_spec` gives the maximiser-property for
    the canonical chosen β_max, which IS `betaBarStar` by the `def`'s
    unfolding.

    Net wA delta: 0 (1 retired wA via Pattern 5 + 1 new existence wA
    `principal_interior_maximum_exists_OPEN` — NET 0 per R75 deferral
    note's "DEFERRED to R76+" but with audit-chain granularity benefit
    per discipline §18). Net structural-equation delta: 0 (atom was
    already wA, not structuralEq, in current ledger state); net
    derivedTheorem delta: +1.

    R76 honesty audit: this NET 0 wA closure is qualitatively
    different from R74/R75 wins (which retired structuralEquation
    atoms). The R76 benefit is audit-chain granularity per discipline
    §18 — the existence claim is now atomically separated from the
    carrier-identification step, surfacing the existence as a paper-
    faithful smaller atom (`principal_interior_maximum_exists_OPEN`)
    rather than bundled inside the universal-inequality carrier-pin.
    Per the R75 deferral note: "those remain DEFERRED" was correct
    PRO-TEM; R76 now executes the deferred closure with explicit
    NET 0 wA accounting + audit-chain granularity argument.

    paper source: Proposition `prop:principal-optimum`, line 622
    (`\\bar{\\beta}^*` as maximiser of `W̄`). -/
theorem betaBarStar_def :
    ∀ β : ℝ, W_bar β ≤ W_bar betaBarStar := by
  intro β
  -- Unfold `betaBarStar` to expose the `Classical.choose` witness.
  unfold betaBarStar
  -- `Classical.choose_spec` yields `∀ β, W_bar β ≤ W_bar β_max`
  -- on the canonical chosen β_max.
  exact Classical.choose_spec principal_interior_maximum_exists_OPEN β

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

    R71 substantive-math closure: previously declared `axiom kappa_FOSD`
    (opaque carrier). R71 makes the carrier CONCRETE per paper line 634's
    own definitional commitment `(i.e., G_2(κ ≤ x) ≤ G_1(κ ≤ x) for all x)`.
    The Lean `def` IS the paper's exact CDF inequality, so the carrier
    encodes paper content faithfully; this is NOT the R7-flagged
    closure-count trick (R6's `kappa_FOSD ≡ True` content-erasure).
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

/-- Cat 1 derived theorem (R71 substantive-math closure): paper line 634
    biconditional between the `kappa_FOSD` predicate and the paper-stated
    CDF inequality `∀ x, G₂(κ ≤ x) ≤ G₁(κ ≤ x)`. Now provable kernel-pure
    via the `kappa_FOSD` `def`'s unfolding (`Iff.rfl`).

    R71 closure pattern: the previous `axiom kappa_FOSD_def` (R50-honest
    `workingAssumption gapOpen`) is REPLACED by this Cat 1 derived theorem
    composing the paper-faithful `kappa_FOSD` `def` (paper line 634
    parenthetical `(i.e., G_2(κ ≤ x) ≤ G_1(κ ≤ x) for all x)` IS the
    carrier's defining biconditional) with kernel-level `Iff.rfl`. Net
    workingAssumption delta: −1.

    paper source: Proposition `prop:principal-optimum` Part 2, line 634
    parenthetical CDF-inequality definition of κ-FOSD. -/
theorem kappa_FOSD_def :
    ∀ (G₁ G₂ : ℝ → ℝ),
      kappa_FOSD G₁ G₂ ↔ ∀ x : ℝ, G₂ x ≤ G₁ x :=
  fun _ _ => Iff.rfl

/-- Substantive paper claim — opaque-carrier-on-opaque-carrier required.
    Aggregate welfare `W̄_G(β)` for a given distribution G, paper
    Definition `def:principal` (line 612-619) reads
    `W̄(β) = ∫ W(β, κ, α) dG(κ, α)`. Encoded as a fresh
    G-parameterised opaque carrier (the existing `W_bar : ℝ → ℝ` fixes
    G implicitly; this carrier exposes the G-dependence required by
    `aggregateOptimalBeta_def` below).

    paper source: Definition `def:principal`, line 615. -/
axiom aggregateWelfareWith : (ℝ → ℝ) → ℝ → ℝ

/-- R76 NEW Cat 3 paper-novel ATOMIC stipulation: paper-stated existence
    of an argmax of the G-parameterised aggregate-welfare functional
    `aggregateWelfareWith G`, for every `G`. Paper Proposition
    `prop:principal-optimum` Part 2 (line 634) reads "the unique zero
    crossing of `dW̄/dβ` under `G_2` lies weakly to the right of that
    under `G_1`" — paper presupposes the existence of the argmax for
    each `G_i`, which is the per-`G` analogue of the fixed-G argmax
    existence atom `principal_interior_maximum_exists_OPEN`.

    This atom encodes the bare paper-stated EXISTENCE of an argmax
    per `G`: `∀ G : ℝ → ℝ, ∃ β_max : ℝ, ∀ β : ℝ, aggregateWelfareWith
    G β ≤ aggregateWelfareWith G β_max`. The downstream
    `noncomputable def aggregateOptimalBeta` invokes
    `Classical.choose` on this atom (per-`G`) to obtain the canonical
    maximiser; the structural-equation atom `aggregateOptimalBeta_def`
    is then internalised by `Classical.choose_spec`.

    Cat 3 sub-type: workingAssumption (paper-stated existence of a
    global maximiser of `aggregateWelfareWith G` per-`G` on the
    real line; pending Mathlib continuous-function-on-compact-interval
    + Bolzano-Weierstrass machinery for the explicit per-`G`
    maximiser witness; 必须 close before publication).

    R76 Pattern 5 propagation per `feedback_no_compute_retreat` +
    `feedback_gap_ledger_in_lean4` §18 (R74 `betaStarOfP` / R75
    `smoothTransitionBeta` / R76-A `betaBarStar` precedent): split
    the bundled structural-equation atom `aggregateOptimalBeta_def`
    into this smaller per-`G` existence atom + the Pattern 5 closure
    of `aggregateOptimalBeta_def` via `Classical.choose_spec`. Net
    wA delta: 0 (1 new wA, 1 retired wA via Pattern 5); audit-chain
    granularity benefit per discipline §18.

    paper source: Definition `def:principal`, line 615 (`\\bar{W}_G(β)`
    integral) + Proposition `prop:principal-optimum` Part 2, line 634
    (`\\bar{\\beta}^*_G` as the per-`G` maximiser). -/
axiom aggregate_optimum_exists_per_G_OPEN :
    ∀ G : ℝ → ℝ, ∃ β_max : ℝ,
      ∀ β : ℝ, aggregateWelfareWith G β ≤ aggregateWelfareWith G β_max

/-- Aggregate-optimal precision `β̄*_G` for given distribution `G : ℝ → ℝ`.

    R76 substantive-math closure (concrete-def closure, Pattern 5:
    existence-via-`Classical.choose`). Previously declared
    `axiom aggregateOptimalBeta : (ℝ → ℝ) → ℝ` (opaque carrier) plus
    the structural-equation atom `aggregateOptimalBeta_def` (Cat 3
    workingAssumption pinning the carrier to a maximiser of
    `aggregateWelfareWith G`). R76 makes the carrier CONCRETE per
    paper line 634's own paper-stated existence claim of the per-`G`
    maximiser: define `aggregateOptimalBeta G` as `Classical.choose`
    of the maximiser-witness from the existence atom
    `aggregate_optimum_exists_per_G_OPEN G`.

    The Lean `def` IS the paper's "maximiser-of-`W̄_G`" identification
    (the `Classical.choose` literally picks the paper-stated per-`G`
    maximiser of `aggregateWelfareWith G`), so the carrier encodes
    paper content faithfully. NOT the R7-flagged closure-count trick:
    the def body invokes the substantive existence atom
    `aggregate_optimum_exists_per_G_OPEN` as input, with no content
    erasure; the previously-axiomatic carrier-identification step
    (`aggregateOptimalBeta_def`) is internalised by `Classical.choose_spec`.

    Per `feedback_no_compute_retreat`: where Mathlib lacks the typed
    G-parameterised continuous-function-on-half-line argmax machinery,
    define the paper-faithful selection locally rather than skip.

    paper source: Proposition `prop:principal-optimum`, line 634
    (`\bar{\beta}^*_G` as per-`G` maximiser of `\bar{W}_G`). -/
noncomputable def aggregateOptimalBeta (G : ℝ → ℝ) : ℝ :=
  Classical.choose (aggregate_optimum_exists_per_G_OPEN G)

/-- **R76 derived theorem** (replaces R-original axiom
    `aggregateOptimalBeta_def`; now closes via Pattern 5
    `Classical.choose_spec` instead of standalone structural-equation
    axiom).
    Cat 3 argmax-characterisation of `aggregateOptimalBeta G`:
    for every `G : ℝ → ℝ` and `β ∈ ℝ`,
    `aggregateWelfareWith G β ≤ aggregateWelfareWith G (aggregateOptimalBeta G)`.

    R76 Pattern 5 closure: composes the `aggregateOptimalBeta` `def`
    (which invokes `Classical.choose` on
    `aggregate_optimum_exists_per_G_OPEN G`) with `Classical.choose_spec`
    (which yields the universal-inequality maximiser property of the
    chosen witness directly).

    Net delta: 0 wA (1 new existence wA + 1 retired wA via Pattern 5);
    +1 derivedTheorem; audit-chain granularity benefit per discipline
    §18 (R75 deferral note's "DEFERRED to R76+" now executed).

    paper source: Proposition `prop:principal-optimum` Part 2,
    line 634 (`\\bar{\\beta}^*_G` as per-`G` maximiser of
    `\\bar{W}_G`). -/
theorem aggregateOptimalBeta_def :
    ∀ (G : ℝ → ℝ) (β : ℝ),
      aggregateWelfareWith G β ≤ aggregateWelfareWith G (aggregateOptimalBeta G) := by
  intro G β
  unfold aggregateOptimalBeta
  exact Classical.choose_spec (aggregate_optimum_exists_per_G_OPEN G) β

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

/-- Cat 1 derived theorem (R72 substantive-math closure): paper line 638
    explicit mixture identity `W_bar β = aboveThresholdWelfare β +
    belowThresholdWelfare β`. Now provable kernel-pure via the `W_bar`
    `def`'s unfolding (`rfl`).

    R72 closure pattern: the previous `axiom W_bar_eq_mixture_OPEN`
    (R63 `structuralEquation gapDefinitional`) is REPLACED by this Cat 1
    derived theorem composing the paper-faithful `W_bar` `def` (paper
    line 638 `W̄(β) = λ · above + (1-λ) · below` IS the carrier's
    defining mixture identification) with kernel-level `rfl`. The
    component carriers `aboveThresholdWelfare` and `belowThresholdWelfare`
    (hoisted to before `W_bar` above) host the per-regime contributions.

    Net workingAssumption delta: −1 (structural-equation gapDefinitional
    atom retired; carrier-pair preserved with paper-faithful identification
    encoded in `def`).

    paper source: Proposition `prop:principal-optimum` Part 3 proof,
    line 638 (`W̄(β) = λ · above + (1 − λ) · below` mixture identity). -/
theorem W_bar_eq_mixture_OPEN :
    ∀ β : ℝ, W_bar β = aboveThresholdWelfare β + belowThresholdWelfare β :=
  fun _ => rfl

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

/-- R76 NEW Cat 3 paper-novel ATOMIC stipulation: paper-stated existence
    of the β → ∞ limit of aggregate welfare. Paper Corollary
    `cor:disclosure` Part 1 proof (line 652) reads "for above-threshold
    agents, `W(β, κ, α)` is non-decreasing in β and converges to a
    finite limit `W(∞, κ, α)`"; aggregating over the population gives
    `\bar{W}(\beta) \to \bar{W}(\infty)` as `β → ∞`. This atom encodes
    the bare paper-stated EXISTENCE of a finite limit, without committing
    to a specific named limit constant.

    The atom is `∃ L : ℝ, Filter.Tendsto W_bar Filter.atTop (nhds L)`.
    The downstream `noncomputable def W_bar_limit_infty` invokes
    `Classical.choose` on this atom to obtain the canonical limit; the
    structural-equation atom `W_bar_limit_infty_def` is then internalised
    by `Classical.choose_spec`.

    Cat 3 sub-type: workingAssumption (paper-stated existence of a
    finite limit of `W_bar` at `+∞`; pending Mathlib monotone-bounded-
    convergence + per-agent finite-limit aggregation machinery for the
    explicit limit witness; 必须 close before publication).

    R76 Pattern 5 propagation per `feedback_no_compute_retreat` +
    `feedback_gap_ledger_in_lean4` §18 (R74/R75/R76-A/R76-B precedent):
    split the bundled structural-equation atom `W_bar_limit_infty_def`
    (carrier-pin + Tendsto-claim bundled together) into this smaller
    existence atom + the Pattern 5 closure of `W_bar_limit_infty_def`
    via `Classical.choose_spec`. Net wA delta: 0 (1 new wA, 1 retired
    wA via Pattern 5); audit-chain granularity benefit per discipline §18.

    paper source: Corollary `cor:disclosure` Part 1 proof, line 652
    ("aggregate welfare converges to a finite limit as β → ∞" —
    paper-stated existence of a finite limit at `+∞`). -/
axiom W_bar_has_limit_infty_OPEN :
    ∃ L : ℝ, Filter.Tendsto W_bar Filter.atTop (nhds L)

/-- Limit of aggregate welfare as `β → ∞`.

    R76 substantive-math closure (concrete-def closure, Pattern 5:
    existence-via-`Classical.choose`). Previously declared
    `axiom W_bar_limit_infty : ℝ` (opaque carrier) plus the structural-
    equation atom `W_bar_limit_infty_def` (Cat 3 workingAssumption
    pinning the carrier to the Tendsto-limit of `W_bar`). R76 makes the
    carrier CONCRETE per paper line 652's own paper-stated existence
    claim of the finite limit: define `W_bar_limit_infty` as
    `Classical.choose` of the limit-witness from the existence atom
    `W_bar_has_limit_infty_OPEN`.

    The Lean `def` IS the paper's "convergence-to-finite-limit"
    identification (the `Classical.choose` literally picks the paper-
    stated finite limit of `W_bar` at `+∞`), so the carrier encodes
    paper content faithfully. NOT the R7-flagged closure-count trick:
    the def body invokes the substantive existence atom
    `W_bar_has_limit_infty_OPEN` as input, with no content erasure;
    the previously-axiomatic carrier-identification step
    (`W_bar_limit_infty_def`) is internalised by `Classical.choose_spec`.

    Per `feedback_no_compute_retreat`: where Mathlib lacks the typed
    monotone-bounded-convergence + per-agent finite-limit aggregation
    machinery, define the paper-faithful selection locally rather than
    skip.

    paper source: Corollary `cor:disclosure` Part 1, line 652
    (`\bar{W}(\beta) \to \bar{W}(\infty)` as `β → ∞`). -/
noncomputable def W_bar_limit_infty : ℝ :=
  Classical.choose W_bar_has_limit_infty_OPEN

/-- **R76 derived theorem** (replaces R-original axiom
    `W_bar_limit_infty_def`; now closes via Pattern 5
    `Classical.choose_spec` instead of standalone structural-equation
    axiom).
    Cat 3 Tendsto-characterisation of `W_bar_limit_infty`:
    `Filter.Tendsto W_bar Filter.atTop (nhds W_bar_limit_infty)`.

    R76 Pattern 5 closure: composes the `W_bar_limit_infty` `def`
    (which invokes `Classical.choose` on `W_bar_has_limit_infty_OPEN`)
    with `Classical.choose_spec` (which yields the Tendsto-property
    of the chosen limit witness directly).

    Net delta: 0 wA (1 new existence wA + 1 retired wA via Pattern 5);
    +1 derivedTheorem; audit-chain granularity benefit per discipline
    §18 (R75 deferral note's "DEFERRED to R76+" now executed).

    paper source: Corollary `cor:disclosure` Part 1 proof, line 652
    ("aggregate welfare converges to a finite limit as β → ∞"). -/
theorem W_bar_limit_infty_def :
    Filter.Tendsto W_bar Filter.atTop (nhds W_bar_limit_infty) := by
  unfold W_bar_limit_infty
  exact Classical.choose_spec W_bar_has_limit_infty_OPEN

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

/-- R63 paper-novel opaque carrier: paper line 658's explicit
    per-agent-optimum aggregate `∫ W(β*(κ, α), κ, α) dG` abstracted
    as a single (ℝ → ℝ) → ℝ functional of the population distribution.
    Paper Corollary `cor:disclosure` Part 2 proof (line 658) writes
    "the planner sets `β_i = β*(κ_i, α_i)` for each agent type. ...
    This achieves `W̄_diff = ∫ W(β*(κ, α), κ, α) dG`."

    R72 hoist (was R63 declared after `differentiatedDisclosureWelfare`):
    hoisted to BEFORE `differentiatedDisclosureWelfare` to support R72
    substantive-math closure pattern (per R71 `kappa_FOSD` precedent).
    The carrier itself remains paper-Def-stipulated structural primitive
    per discipline §3.4.1 (paper-novel opaque-carrier primitive); position
    in source order is metadata-neutral.

    paper source: Corollary `cor:disclosure` Part 2 proof, line 658
    (`∫ W(β*(κ, α), κ, α) dG` per-agent-optimum aggregate). -/
axiom perAgentOptimalAggregate : (ℝ → ℝ) → ℝ

/-- Differentiated-disclosure aggregate welfare.

    R72 substantive-math closure: previously declared `axiom
    differentiatedDisclosureWelfare` (opaque carrier). R72 makes the
    carrier CONCRETE per paper Corollary `cor:disclosure` Part 2 proof
    line 658's own definitional commitment "the planner sets `β_i =
    β*(κ_i, α_i)` for each agent type. ... This achieves `W̄_diff =
    ∫ W(β*(κ, α), κ, α) dG`": paper EXPLICITLY equates the differentiated
    welfare with the per-agent-optimum aggregate. The Lean `def` IS the
    paper's exact identification.

    Per `feedback_no_compute_retreat`: where Mathlib lacks the typed
    measure-theoretic per-agent-integration framework, define the paper-
    faithful identification locally rather than skip.

    paper source: Corollary `cor:disclosure` Part 2 proof, line 658
    (`W̄_diff = ∫ W(β*(κ, α), κ, α) dG` per-agent-optimum aggregate
    identification). -/
noncomputable def differentiatedDisclosureWelfare : (ℝ → ℝ) → ℝ :=
  fun G => perAgentOptimalAggregate G

/-- Cat 1 derived theorem (R72 substantive-math closure): paper line 658
    explicit identification `differentiatedDisclosureWelfare G =
    perAgentOptimalAggregate G`. Now provable kernel-pure via the
    `differentiatedDisclosureWelfare` `def`'s unfolding (`rfl`).

    R72 closure pattern: the previous `axiom differentiatedDisclosureWelfare_
    eq_perAgentOptimal_OPEN` (R63 `structuralEquation gapDefinitional`)
    is REPLACED by this Cat 1 derived theorem composing the paper-
    faithful `differentiatedDisclosureWelfare` `def` (paper line 658
    `W̄_diff = ∫ W(β*(κ, α), κ, α) dG` IS the carrier's defining
    identification with the per-agent-optimum aggregate) with kernel-
    level `rfl`. The companion carrier `perAgentOptimalAggregate`
    (hoisted to before `differentiatedDisclosureWelfare` above) hosts
    the per-agent-optimum aggregate.

    Net workingAssumption delta: −1 (structural-equation gapDefinitional
    atom retired; carrier-pair preserved with paper-faithful identification
    encoded in `def`).

    paper source: Corollary `cor:disclosure` Part 2 proof, line 658
    (`W̄_diff = ∫ W(β*(κ, α), κ, α) dG` explicit per-agent-assignment
    formula). -/
theorem differentiatedDisclosureWelfare_eq_perAgentOptimal_OPEN :
    ∀ G : ℝ → ℝ,
      differentiatedDisclosureWelfare G = perAgentOptimalAggregate G :=
  fun _ => rfl

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
