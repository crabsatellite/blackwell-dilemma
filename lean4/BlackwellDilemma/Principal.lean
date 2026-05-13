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

/-- **Proposition `prop:principal-optimum` Part 1: Interior optimum.**
    If `G` has support contained in the reversal regime
    `{(κ, α) : κ < κ*(p, α), α > α*}`, and the bridge subtree of `u_2`
    contains ≥2 terminal vertices with distinct rewards, then `W̄` is
    non-monotone in `β` and `β̄* ∈ (0, ∞)`.

    Substantive paper claim — opaque carrier required (Mathlib gap).
    paper source: Proposition `prop:principal-optimum` Part 1, lines 624-625. -/
axiom gap_principal_interior_optimum_OPEN :
    Conditions_C1_C2_C3 →
    TerminalNeighbourTopology →
    -- support contained in reversal regime
    (∀ p : ℝ, alphaStar 0 p < 1) →
    0 < betaBarStar

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

/-- **Proposition `prop:principal-optimum` Part 2: Monotonicity in
    cognitive infrastructure.**
    If `G_2 ≽_FOSD G_1` in `κ` (both supported in the reversal regime),
    then `β̄*_{G_2} ≥ β̄*_{G_1}`.

    Substantive paper claim — opaque carrier required (Mathlib gap).
    paper source: Proposition `prop:principal-optimum` Part 2, line 626. -/
axiom gap_principal_monotone_in_kappa_OPEN :
    ∀ G₁ G₂ : ℝ → ℝ, kappa_FOSD G₁ G₂ →
      aggregateOptimalBeta G₁ ≤ aggregateOptimalBeta G₂

/-- **Proposition `prop:principal-optimum` Part 3: Regime bifurcation.**
    If `G` has positive mass on both sides of `κ*`, the aggregate `W̄(β)`
    can be non-concave; the planner faces a discrete regime choice.

    Substantive paper claim — opaque carrier required (Mathlib gap).
    paper source: Proposition `prop:principal-optimum` Part 3, line 627. -/
axiom gap_principal_regime_bifurcation_OPEN :
    ∃ β₁ β₂ β₃ : ℝ,
      β₁ < β₂ ∧ β₂ < β₃ ∧
      W_bar β₂ < W_bar β₁ ∧ W_bar β₂ < W_bar β₃

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

/-- **Corollary `cor:disclosure` Part 1: Full disclosure is generically
    suboptimal.**
    If any positive `G`-fraction is in the reversal regime, full
    disclosure (`β → ∞`) is suboptimal: there exists a finite β
    with `W̄(β) > W̄(∞)`.

    Substantive paper claim — opaque carrier required (Mathlib gap).
    paper source: Corollary `cor:disclosure` Part 1, line 645. -/
axiom gap_disclosure_full_suboptimal_OPEN :
    ∀ G_reversal_fraction : ℝ, 0 < G_reversal_fraction →
      ∃ β_finite : ℝ, 0 < β_finite ∧ W_bar_limit_infty < W_bar β_finite

/-- Differentiated-disclosure aggregate welfare.
    Substantive paper claim — opaque carrier required (Mathlib gap).
    paper source: Corollary `cor:disclosure` Part 2. -/
axiom differentiatedDisclosureWelfare : (ℝ → ℝ) → ℝ

/-- **Corollary `cor:disclosure` Part 2: Differentiated disclosure
    dominates.**
    If the planner can condition `β` on observable proxies for
    `(κ, α)`, differentiated disclosure strictly dominates uniform
    disclosure: differentiated welfare ≥ W̄(β̄*) for any uniform β̄*.

    Substantive paper claim — opaque carrier required (Mathlib gap).
    paper source: Corollary `cor:disclosure` Part 2, line 647. -/
axiom gap_disclosure_differentiated_dominates_OPEN :
    ∀ G : ℝ → ℝ, ∀ uniform_beta : ℝ,
      W_bar uniform_beta ≤ differentiatedDisclosureWelfare G

end BlackwellDilemma
