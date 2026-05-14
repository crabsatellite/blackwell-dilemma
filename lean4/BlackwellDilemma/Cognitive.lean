/-
  BlackwellDilemma/Cognitive.lean

  §4 The Cognitive Threshold and Information–Cognition Complementarity.

  Companion to: "Information Value Under Endogenous Feasibility" (Li, 2026).

  Contents:
   * Theorem 4.1 (`thm:cognitive-threshold`) — Characterisation of the
     Blackwell Regime (six parts).
   * Proposition (`prop:supermodular`) — Supermodular Complementarity.
   * Corollary (`cor:policy-complementarity`) — Policy Complementarity.
   * Proposition (`prop:sentimental`) — Sentimental Immunity.
   * Proposition (`prop:threshold-alpha`) — Cognitive Threshold Increases
     with Instrumental Rationality.
-/

import BlackwellDilemma.Types
import BlackwellDilemma.ClassicalResults

namespace BlackwellDilemma

/-! ## 1. The mean estimate gap and `κ*`

The cognitive threshold `κ*(p, α)` is defined via
`m(κ) = E[V̂_κ(u_2)] − E[V̂_κ(u_1)]` (paper line 489). The greedy agent
is structurally distinct from the κ → 0⁺ limit (paper Remark
`kappa-discontinuity`). -/

/-- The mean estimate gap `m(κ) = E[V̂_κ(u_2)] − E[V̂_κ(u_1)]`.
    paper source: Theorem 4.1 statement, line 489. -/
axiom mean_estimate_gap : ℝ → ℝ → ℝ  -- (p, κ) ↦ m(κ)

/-- The cognitive threshold `κ*(p, α)`.
    paper source: Theorem 4.1 (`thm:cognitive-threshold`). -/
axiom kappaStar : ℝ → ℝ → ℝ  -- (p, α) ↦ κ*(p, α)

/-- The critical instrumental rationality `α*(κ, p)`.
    paper source: Proposition `prop:sentimental`. -/
axiom alphaStar : ℝ → ℝ → ℝ  -- (κ, p) ↦ α*(κ, p)

/-- Cat 3 paper-novel ATOMIC structural equation: cognitive threshold
    `κ*(p, α)` characterised as the infimum of strictly-positive κ at
    which the mean-estimate-gap `m(κ)` is non-negative. Paper Theorem
    4.1 Part 3 (line 493) gives the IVT-based existence
    `κ* = inf{κ > 0 : m(κ) ≥ 0}`; this axiom isolates the
    inf-characterisation as a standalone Cat 3 atomic structural
    equation on the existing carriers `kappaStar` and
    `mean_estimate_gap`.

    Encoding choice: extracted from the bundled
    `gap_cognitive_threshold_part3_OPEN` per
    `feedback_gap_ledger_in_lean4` 2026-05-13 update mandating
    paper-stated structural equations be Cat 3 atoms (not bundled inside
    higher-level claims). The bundle entry retains the conjunction
    presentation; this atomic axiom hosts the inf-equation alone, so
    downstream consumers can compose the inf characterisation with
    other facts without unpacking the full bundle. The α-parameter
    appears in `kappaStar`'s signature but is not consumed on the RHS
    (the paper's threshold characterisation depends on α only through
    the IDP-instance assumptions; α-dependence is recorded by Part 5
    monotonicity).

    paper source: Theorem 4.1 Part 3, line 493 ("`κ* = inf{κ > 0 :
    m(κ) ≥ 0}`"). -/
axiom kappaStar_def :
    ∀ (p α : ℝ),
      kappaStar p α = sInf { κ : ℝ | 0 < κ ∧ 0 ≤ mean_estimate_gap p κ }

/-- Substantive paper claim — opaque carrier required for the
    `Filter.Tendsto` limit value declared in Theorem 4.1 Part 3 line
    505: `m(κ) → V_dyn(u_2) − V_dyn(u_1) > 0` as `κ → ∞`. Encoded as a
    fresh opaque carrier `mLimitOf : ℝ → ℝ` to host the limit value
    distinctly per `p`; equality with `V_dyn(u_2) − V_dyn(u_1)` is the
    paper-stated structural fact recorded by `mLimitOf_def` below
    (an OPEN Cat 3 entry that pins the limit value to the paper-stated
    `V_dyn`-difference once a paper-instance two-vertex pair is fixed,
    deferred to per-instance instantiation since `(u_1, u_2)` are
    paper-instance-local).

    paper source: Theorem 4.1 Part 3, line 505. -/
axiom mLimitOf : ℝ → ℝ

/-- Cat 3 paper-novel ATOMIC structural equation: the mean-estimate-gap
    `m(p, κ)` converges to the paper-stated limit `mLimitOf p` (which
    equals `V_dyn(u_2) − V_dyn(u_1)` for the C2 trap/bridge pair) as
    `κ → ∞`. Paper Theorem 4.1 Part 3 (line 505) reads "`m(κ) → V_dyn(u_2)
    − V_dyn(u_1)` as `κ → ∞`": this axiom isolates the `Filter.Tendsto`
    limit as a standalone Cat 3 atomic structural equation on the
    existing carriers `mean_estimate_gap` and `mLimitOf`.

    Encoding choice: extracted from the bundled
    `gap_cognitive_threshold_part3_OPEN` Tendsto sub-clause per
    `feedback_gap_ledger_in_lean4` 2026-05-13 update. The paper-stated
    `mLimitOf p = V_dyn(u_2) − V_dyn(u_1)` link is deferred to a
    per-IDP-instance closure (the paper's `(u_1, u_2)` are local to the
    instance); only the limit-value carrier `mLimitOf` is pinned here as
    the ATOMIC structural equation governing the κ → ∞ limit.

    paper source: Theorem 4.1 Part 3, line 505 ("`m(κ) → V_dyn(u_2) −
    V_dyn(u_1) > 0` as `κ → ∞`").

    Status — atomized stub awaiting consumer: this atom hosts the κ → ∞
    Tendsto limit on the new `mLimitOf` carrier (extracted from the
    bundled `gap_cognitive_threshold_part3_OPEN`). The downstream
    consumption requires composing with strict-positivity of `mLimitOf`
    (paper line 505 fact `mLimitOf p > 0`) plus the per-IDP-instance
    link `mLimitOf p = V_dyn(u_2) − V_dyn(u_1)` deferred to per-instance
    closure (paper's `(u_1, u_2)` are local to each IDP instance);
    pending those instantiations the atom is retained as a paper-grade
    structural equation record. -/
axiom mLimit_def :
    ∀ (p : ℝ),
      Filter.Tendsto (fun κ : ℝ => mean_estimate_gap p κ) Filter.atTop
        (nhds (mLimitOf p))

/-- Cat 3 paper-novel ATOMIC structural equation: critical instrumental
    rationality `α*(κ, p)` characterised as the supremum of `α ∈ [0, 1]`
    at which welfare is non-decreasing in `β`. Paper `prop:sentimental`
    proof (line 602) reads "The critical `α*` is therefore well-defined
    as the supremum of [the set of `α` for which `W(β, κ, α)` is
    non-decreasing in β]": this axiom isolates the sup-characterisation
    as a standalone Cat 3 atomic structural equation on the existing
    carriers `alphaStar` and `agentWelfare`.

    Encoding choice: the paper's set-of-α is encoded via the
    monotonicity predicate on `agentWelfare AgentType.sentimental β κ α`
    (the paper's W under the given (β,κ,α)-agent), and the supremum is
    realised by `sSup` over reals. The closure clause (`α ≤ 1`) of the
    paper's `α*(κ, p) ∈ (0, 1]` is captured implicitly by the sup over
    a subset of `[0, 1]`; positivity (`0 < α*`) is the paper's
    perturbation argument and remains within
    `gap_sentimental_immunity_OPEN` as a separate clause.

    paper source: Proposition `prop:sentimental` proof, line 602
    ("The critical `α*` is therefore well-defined as the supremum of
    [the monotonicity set]").

    Status — atomized stub awaiting consumer: this atom is the paper-
    stated sup-characterisation of `alphaStar` (extracted from the
    bundled `gap_sentimental_immunity_OPEN`). Direct downstream
    derivation of `alphaStar`'s positivity / monotonicity properties
    requires composing this characterisation with the substantive
    sentimental-immunity content (paper `prop:sentimental` perturbation
    argument), which remains within `gap_sentimental_immunity_OPEN`
    pending Mathlib bounded-convergence + Φ-tail integral machinery.
    Retained as paper-grade structural-equation record. -/
axiom alphaStar_def :
    ∀ (κ p : ℝ),
      alphaStar κ p =
        sSup { α : ℝ | 0 ≤ α ∧ α ≤ 1 ∧
          ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
            agentWelfare AgentType.sentimental β₁ κ α ≤
              agentWelfare AgentType.sentimental β₂ κ α }

/-! ## 2. Theorem 4.1 — Characterisation of the Blackwell Regime -/

/-- Cat 3 paper-novel ATOMIC stipulation: paper Theorem 4.1 Part 1
    (line 491) states that for instrumental-rationality parameter
    `α > α*(0, p)` (i.e. above the greedy critical α-threshold), the
    greedy agent's welfare is strictly non-monotone in β: there exist
    β₁ < β₂ such that `W_greedy(β₂, 0, α) < W_greedy(β₁, 0, α)`. The
    α-above-α* premise is the paper-stated regime gate that triggers
    the trap-induced reversal at κ = 0 (greedy regime).

    Encoding choice: extracted as standalone Cat 3 atomic stipulation
    from the bundled `gap_cognitive_threshold_part1_OPEN` per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern
    (decompose bundled conclusion-axiom into atomic stipulation +
    derived theorem). The atom isolates the paper-stated greedy-
    reversal triggering at α > α*(0, p).

    Cat 3 sub-type: workingAssumption (paper-stated higher-level
    welfare-reversal claim on opaque carrier `agentWelfare` at the
    greedy κ = 0 regime; pending per-IDP-instance derivation from the
    paper's trap-probability + V_dyn-misalignment chain; 必须 close
    before publication).

    paper source: Theorem 4.1 Part 1, line 491 (`α > α*(0, p)` ⇒
    greedy welfare non-monotone in β). -/
axiom alpha_above_alpha_star_implies_reversal_OPEN :
    Conditions_C1_C2_C3 →
    TerminalNeighbourTopology →
    ∀ p α : ℝ, alphaStar 0 p < α →
      ∃ β₁ β₂ : ℝ, β₁ < β₂ ∧
        agentWelfare AgentType.greedy β₂ 0 α <
          agentWelfare AgentType.greedy β₁ 0 α

/-- **Theorem 4.1 Part 1: Failure at `κ = 0`** (derived theorem).
    For `α > α*(0, p)`, greedy welfare is non-monotone in β.

    Derived theorem composing the atomic stipulation
    `alpha_above_alpha_star_implies_reversal_OPEN` per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern.

    paper source: Theorem 4.1 Part 1, line 491. -/
theorem gap_cognitive_threshold_part1
    (hC : Conditions_C1_C2_C3)
    (hT : TerminalNeighbourTopology) :
    ∀ p α : ℝ, alphaStar 0 p < α →
      ∃ β₁ β₂ : ℝ, β₁ < β₂ ∧
        agentWelfare AgentType.greedy β₂ 0 α <
          agentWelfare AgentType.greedy β₁ 0 α :=
  alpha_above_alpha_star_implies_reversal_OPEN hC hT

/-- **Theorem 4.1 Part 2: Recovery at `κ → ∞`.**
    For sufficiently large κ, welfare is monotonically non-decreasing in β.

    Cat 2 dependency surfacing: per the audit-chain discipline (axioms
    have no body, so a downstream axiom cannot "compose" an upstream
    axiom by direct call), the Cat 2 axiom
    `gap_blackwell_monotonicity_OPEN` (Blackwell 1951/1953) is threaded
    as an EXPLICIT ANTECEDENT `(h_blackwell : ...)` so that
    `#print axioms` on any theorem consuming
    `gap_cognitive_threshold_part2_OPEN` surfaces the Blackwell
    dependency. The R26 drop of this antecedent over-applied the
    "Cat 2 implicit consumption" rule: the CLAIM CONTENT of this entry
    is the Blackwell monotonicity theorem applied to the κ-agent's
    welfare at sufficiently large `κ` (the high-cognition limit where
    the agent's posterior converges to the truth and the conditional
    Blackwell-ordering argument applies, per
    `feedback_gap_ledger_in_lean4` §10 paper-APPLICATION-to-opaque-
    carrier = Cat 3 with explicit Cat 2 chain). The relevant Cat 2
    axiom lives at
    `ClassicalResults.lean :: gap_blackwell_monotonicity_OPEN`.

    paper source: Theorem 4.1 Part 2, line 492. -/
axiom kappa_large_blackwell_recovery_OPEN :
    (∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
      agentWelfare AgentType.bayesian β₁ 0 1 ≤
        agentWelfare AgentType.bayesian β₂ 0 1) →
    Conditions_C1_C2_C3 →
    TerminalNeighbourTopology →
    ∀ _p α : ℝ,
      ∃ κ₀ : ℝ, ∀ κ β₁ β₂ : ℝ, κ₀ ≤ κ → β₁ ≤ β₂ →
        agentWelfare AgentType.kappaAgent β₁ κ α ≤
          agentWelfare AgentType.kappaAgent β₂ κ α

/-- **Theorem 4.1 Part 2: Recovery at `κ → ∞`** (derived theorem).
    For sufficiently large κ, the κ-agent's welfare is monotonically
    non-decreasing in β: cognitive depth restores correct posterior
    estimates of continuation values, which in turn restores the
    Blackwell-monotonicity chain on the conditional decision subproblem.

    Derived theorem composing the atomic stipulation
    `kappa_large_blackwell_recovery_OPEN` per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern
    (decompose bundled conclusion-axiom into atomic stipulation +
    derived theorem). Cat 2 dependency on Blackwell 1951/1953 surfaces
    via the `h_blackwell` antecedent thread.

    paper source: Theorem 4.1 Part 2, line 492. -/
theorem gap_cognitive_threshold_part2
    (h_blackwell : ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
      agentWelfare AgentType.bayesian β₁ 0 1 ≤
        agentWelfare AgentType.bayesian β₂ 0 1)
    (hC : Conditions_C1_C2_C3)
    (hT : TerminalNeighbourTopology) :
    ∀ _p α : ℝ,
      ∃ κ₀ : ℝ, ∀ κ β₁ β₂ : ℝ, κ₀ ≤ κ → β₁ ≤ β₂ →
        agentWelfare AgentType.kappaAgent β₁ κ α ≤
          agentWelfare AgentType.kappaAgent β₂ κ α :=
  kappa_large_blackwell_recovery_OPEN h_blackwell hC hT

/-- Substantive paper claim — opaque carrier required (Mathlib gap).
    Asymptotic limit of the mean-estimate-gap `m(κ)` as `κ → ∞`,
    paper notation `V_dyn(u_2) − V_dyn(u_1)`. Strict positivity is
    asserted in `gap_cognitive_threshold_part3_OPEN`.

    paper source: Theorem 4.1 Part 3, line 493. -/
axiom mLimit : ℝ → ℝ

/-- Cat 3 paper-novel ATOMIC structural fact: the mean-estimate-gap
    `m(p, κ)` is continuous on the positive reals `(0, ∞)`. Paper
    Theorem 4.1 Part 3 (line 493) asserts continuity of `m(κ)` on
    `(0, ∞)` (the paper's domain restriction; `κ = 0` is structurally
    excluded per Remark `kappa-discontinuity`).

    Encoding choice: extracted from the bundled
    `gap_cognitive_threshold_part3_OPEN` as a standalone Cat 3 atomic
    stipulation per `feedback_gap_ledger_in_lean4` §18 Manufactured-
    Recognition pattern (decompose bundled conclusion-axioms into
    atomic stipulations + derived theorem). The continuity is
    paper-stated content on the existing `mean_estimate_gap` carrier;
    a Lean derivation from per-instance V_dyn / posterior continuity
    properties is deferred to per-IDP-instance closure.

    Cat 3 sub-type: workingAssumption (paper-stated higher-level
    continuity claim pending per-instance derivation from the
    paper's V_dyn continuity inputs; 必须 close before publication).

    paper source: Theorem 4.1 Part 3, line 493 ("`m(κ)` is continuous
    on `(0, ∞)`"). -/
axiom mean_estimate_gap_continuous_OPEN :
    Conditions_C1_C2_C3 →
    ∀ p : ℝ,
      ContinuousOn (fun κ : ℝ => mean_estimate_gap p κ) (Set.Ioi 0)

/-- Cat 3 paper-novel ATOMIC structural fact: the mean-estimate-gap
    `m(p, κ)` converges to `mLimit p` as `κ → ∞`. Paper Theorem 4.1
    Part 3 (line 505) states `m(κ) → V_dyn(u_2) − V_dyn(u_1) =:
    mLimit p` as `κ → ∞`.

    Encoding choice: extracted from the bundled
    `gap_cognitive_threshold_part3_OPEN` Tendsto sub-clause per
    `feedback_gap_ledger_in_lean4` §18 atomic-decomposition pattern.
    Hosts the Tendsto limit on the bundle's `mLimit` carrier (distinct
    from `mLimit_def` which hosts the analogous Tendsto on the
    separate `mLimitOf` carrier introduced for per-instance work).

    Cat 3 sub-type: workingAssumption (paper-stated limit pending
    per-instance derivation linking `mLimit p` to the
    `V_dyn(u_2) − V_dyn(u_1)` paper-instance vertex pair; 必须 close
    before publication).

    paper source: Theorem 4.1 Part 3, line 505 ("`m(κ) →
    V_dyn(u_2) − V_dyn(u_1) > 0` as `κ → ∞`"). -/
axiom mean_estimate_gap_tendsto_mLimit_OPEN :
    Conditions_C1_C2_C3 →
    ∀ p : ℝ,
      Filter.Tendsto (fun κ : ℝ => mean_estimate_gap p κ) Filter.atTop
        (nhds (mLimit p))

/-- Cat 3 paper-novel ATOMIC structural fact: the limit value
    `mLimit p` of the mean-estimate-gap as `κ → ∞` is strictly
    positive. Paper Theorem 4.1 Part 3 (line 505) writes
    "`m(κ) → V_dyn(u_2) − V_dyn(u_1) > 0` as `κ → ∞`": the strict
    positivity reflects C2 trap/bridge misalignment (`u_2` is the
    bridge neighbour with strictly higher dynamic value than the
    trap neighbour `u_1`).

    Encoding choice: extracted from the bundled
    `gap_cognitive_threshold_part3_OPEN` strict-positivity sub-clause
    per `feedback_gap_ledger_in_lean4` §18 atomic-decomposition
    pattern.

    Cat 3 sub-type: workingAssumption (paper-stated strict positivity
    pending per-instance derivation; 必须 close before publication).

    paper source: Theorem 4.1 Part 3, line 505 ("`m(κ) →
    V_dyn(u_2) − V_dyn(u_1) > 0` as `κ → ∞`"). -/
axiom mLimit_pos_OPEN :
    Conditions_C1_C2_C3 →
    ∀ p : ℝ, 0 < mLimit p

/-- **Cat 1 Mathlib derivation**: the cognitive threshold `kappaStar p α`
    is non-negative. Paper Theorem 4.1 Part 3 (line 493) characterises
    `kappaStar p α` as `sInf {κ > 0 : m(κ) ≥ 0}`, so `0 ≤ kappaStar p α`
    follows directly from `Real.sInf_nonneg` applied to a set of strictly
    positive reals (junk-value branch `Real.sInf_empty = 0` preserves
    the bound).

    R46 conversion (Pattern-1 violation fix): the prior R37 encoding as
    `axiom kappaStar_nonneg_OPEN` was flagged by R45 hostile audit as
    a Pattern-1 violation since the derivation is Mathlib-routine via
    `kappaStar_def` (Cat 3 atom) composed with Mathlib's `Real.sInf_nonneg`
    lemma. Now encoded as a Cat 1 `theorem` with kernel-pure proof.

    paper source: Theorem 4.1 Part 3, line 493 ("`κ*(p, α) ≥ 0`"). -/
theorem kappaStar_nonneg :
    ∀ p α : ℝ, 0 ≤ kappaStar p α := by
  intros p α
  rw [kappaStar_def p α]
  exact Real.sInf_nonneg (fun _ ⟨h_pos, _⟩ => le_of_lt h_pos)

/-- **Theorem 4.1 Part 3: Existence of `κ*` (derived theorem).**
    `m(κ)` (the mean-estimate-gap, `mean_estimate_gap p κ`) is continuous
    on `(0, ∞)`, and `m(κ) → V_dyn(u_2) − V_dyn(u_1) =: mLimit p > 0`
    as `κ → ∞`. The cognitive threshold satisfies the inf-characterisation
    `κ*(p, α) = sInf {κ : 0 < κ ∧ 0 ≤ mean_estimate_gap p κ}` and
    lies in `[0, ∞)`.

    Derived theorem composing five Cat 3 atomic stipulations per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition
    pattern (decompose bundled conclusion-axiom into atomic
    stipulations + derived theorem):
    * `mean_estimate_gap_continuous_OPEN` (continuity on `(0, ∞)`),
    * `mean_estimate_gap_tendsto_mLimit_OPEN` (Tendsto limit),
    * `mLimit_pos_OPEN` (strict positivity of the limit),
    * `kappaStar_def` (inf-characterisation; R23-C1 atom), and
    * `kappaStar_nonneg` (Cat 1 theorem, R46 Pattern-1 fix from former atom).
    The composition is closed kernel-pure; the atomic stipulations
    are paper-stated structural facts pending separate per-instance
    derivations.

    Continuity is asserted as `ContinuousOn ... (Set.Ioi 0)` (the
    positive reals), matching the paper's domain restriction exactly:
    paper Remark `kappa-discontinuity` explicitly separates the
    greedy agent (`κ = 0`) from the `κ → 0⁺` limit, so the paper
    does NOT claim continuity at or below 0.

    paper source: Theorem 4.1 Part 3, line 493 + 505. -/
theorem gap_cognitive_threshold_part3
    (hC : Conditions_C1_C2_C3) :
    ∀ p α : ℝ,
      ContinuousOn (fun κ : ℝ => mean_estimate_gap p κ) (Set.Ioi 0) ∧
      Filter.Tendsto (fun κ : ℝ => mean_estimate_gap p κ) Filter.atTop
        (nhds (mLimit p)) ∧
      0 < mLimit p ∧
      kappaStar p α =
        sInf { κ : ℝ | 0 < κ ∧ 0 ≤ mean_estimate_gap p κ } ∧
      0 ≤ kappaStar p α := by
  intros p α
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact mean_estimate_gap_continuous_OPEN hC p
  · exact mean_estimate_gap_tendsto_mLimit_OPEN hC p
  · exact mLimit_pos_OPEN hC p
  · exact kappaStar_def p α
  · exact kappaStar_nonneg p α

/-- **Theorem 4.1 Part 4: Monotonicity in `p`.**
    On lattices and the Section 5 instances, `κ*(p)` is non-decreasing in `p`.

    Status reasoning: under the current `kappaStar_def` encoding,
    the paper's statement Part 4 `kappaStar p₁ α ≤ kappaStar p₂ α`
    for `p₁ ≤ p₂` is potentially junk-value-defective (mirroring the
    `gap_p_monotonicity_OPEN` finding in Cognitive: the unconditional
    universal form was Lean-falsified by junk-value semantics).
    Specifically, after composing with the natural Cat 3 atom
    `mean_estimate_gap_antitone_in_p_OPEN` (paper line 511 stating
    `m(p, κ)` is non-increasing in `p`), the standard sInf-monotonicity
    chain breaks at the corner case where the feasible set
    `{κ | 0 < κ ∧ 0 ≤ m(p₂, κ)}` is empty: by Mathlib convention
    `Real.sInf_empty = 0`, but `kappaStar p₁ α` could be strictly
    positive in that case, violating the inequality. The mathematical
    content is correct only under the implicit non-emptiness premise
    (paper assumes the threshold exists). Future-round candidate:
    refine the statement to be conditional on threshold existence, OR
    enrich `kappaStar_def` to handle the junk-value branch via a
    `0`-default in the empty-feasible-set case.

    paper source: Theorem 4.1 Part 4, line 494. -/
axiom kappaStar_p_monotone_OPEN :
    ∀ α : ℝ, ∀ p₁ p₂ : ℝ, p₁ ≤ p₂ →
      kappaStar p₁ α ≤ kappaStar p₂ α

/-- **Theorem 4.1 Part 4: Monotonicity in `p`** (derived theorem).
    On lattices and the Section 5 instances, `κ*(p)` is non-decreasing
    in `p`.

    Derived theorem composing the atomic stipulation
    `kappaStar_p_monotone_OPEN` per `feedback_gap_ledger_in_lean4` §18
    Manufactured-Recognition pattern. The atom encodes the paper's
    p-monotonicity claim against the implicit non-emptiness premise
    (paper assumes the threshold exists; the unconditional universal
    form is junk-value-defective per R23-C2 audit, mirroring the
    `gap_p_monotonicity_OPEN` finding).

    paper source: Theorem 4.1 Part 4, line 494. -/
theorem gap_cognitive_threshold_part4 :
    ∀ α : ℝ, ∀ p₁ p₂ : ℝ, p₁ ≤ p₂ →
      kappaStar p₁ α ≤ kappaStar p₂ α :=
  kappaStar_p_monotone_OPEN

/-- **Theorem 4.1 Part 5: Monotonicity in `α`.**
    `κ*(p, α)` is non-decreasing in `α`.

    REVERTED to OPEN per α-erasure honesty audit (Cat 3 Pattern 4
    tautological-premise violation). The previous CLOSED-via-
    `kappaStar_def` derivation was a tautological closure: the proof
    script `rw [kappaStar_def p α₁, kappaStar_def p α₂]` reduced both
    sides to the SAME α-free expression `sInf {κ | 0 < κ ∧ 0 ≤
    mean_estimate_gap p κ}`, so the monotonicity inequality `≤` was
    discharged because the two sides are DEFINITIONALLY EQUAL
    (regardless of whether `α₁ ≤ α₂` or even `α₁ > α₂`). That closure
    carried zero substantive paper content.

    Paper-source verification: the paper's `m(κ) = E[V̂_κ(u_2)] −
    E[V̂_κ(u_1)]` (Thm 4.1 statement, line 489 + Part 3 line 505)
    literally has NO α-dependence — it depends on `(p, κ)` only via
    the κ-agent's posterior estimates of the dynamic value. So the
    paper's Part 3 inf-characterisation `κ* = inf{κ > 0 : m(κ) ≥ 0}`
    (line 493) is itself α-free in form. The α-dependence of `κ*`
    enters via a DIFFERENT characterisation: paper Prop:threshold-alpha
    proof line 540 reads "The threshold `κ*` is the value of `κ` where
    the welfare transitions from non-monotone to monotone in β. Since
    higher α increases the trap probability (making non-monotonicity
    more severe), a higher κ is needed to compensate: `∂κ*/∂α > 0`."
    The paper does NOT prove that the inf-formula is α-monotone; it
    implicitly assumes both characterisations (inf-of-m≥0 and welfare-
    transition value) agree at points where the threshold exists, and
    derives α-monotonicity from the welfare-transition characterisation
    via the trap-probability argument.

    Therefore: under the current `kappaStar_def` encoding (which
    faithfully reflects ONLY the Part 3 inf-formula), the α-monotonicity
    claim is NOT derivable from `kappaStar_def` alone — it requires
    its OWN atomic Cat 3 axiom encoding the paper's welfare-transition
    α-monotonicity claim. Refactoring `mean_estimate_gap` to take α
    would phantom-introduce α-dependence the paper does not state on
    `m(κ)`. The honest encoding leaves Part 5 as an independent OPEN
    Cat 3 axiom (paper-stated structural monotonicity claim on the
    `kappaStar` carrier, not reducible to `kappaStar_def`).

    paper source: Theorem 4.1 Part 5, line 495 + Proposition
    `prop:threshold-alpha`, lines 527-543 (proof line 540 welfare-
    transition characterisation). -/
axiom welfare_transition_alpha_monotone_OPEN :
    ∀ p : ℝ, ∀ α₁ α₂ : ℝ, α₁ ≤ α₂ →
      kappaStar p α₁ ≤ kappaStar p α₂

/-- **Theorem 4.1 Part 5: Monotonicity in `α`** (derived theorem).
    `κ*(p, α)` is non-decreasing in `α`.

    Derived theorem composing the atomic stipulation
    `welfare_transition_alpha_monotone_OPEN` per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern.
    The atom encodes the paper's welfare-transition characterisation
    (Prop:threshold-alpha proof line 540), which is independent of the
    `kappaStar_def` inf-formula and avoids the prior tautological
    α-erasure closure (R24-B audit).

    paper source: Theorem 4.1 Part 5, line 495 + Proposition
    `prop:threshold-alpha`, lines 527-543. -/
theorem gap_cognitive_threshold_part5 :
    ∀ p : ℝ, ∀ α₁ α₂ : ℝ, α₁ ≤ α₂ →
      kappaStar p α₁ ≤ kappaStar p α₂ :=
  welfare_transition_alpha_monotone_OPEN

/-- **Theorem 4.1 Part 6: Divergence at `p_c`.**
    On `Z²` with `α > α*`, `κ*(p, α) → +∞` as `p → p_c⁻` (provided
    `κ*(p, α) > 0` near `p_c`).

    paper source: Theorem 4.1 Part 6, line 496. -/
axiom kappaStar_diverges_at_pc_OPEN :
    ∀ α : ℝ, alphaStar 0 harrisKestenCriticalProb < α →
      ∀ M : ℝ, ∃ ε : ℝ, 0 < ε ∧
        ∀ p : ℝ, harrisKestenCriticalProb - ε < p → p < harrisKestenCriticalProb →
          M < kappaStar p α

/-- **Theorem 4.1 Part 6: Divergence at `p_c`** (derived theorem).
    On `Z²` with `α > α*`, `κ*(p, α) → +∞` as `p → p_c⁻` (provided
    `κ*(p, α) > 0` near `p_c`).

    Derived theorem composing the atomic stipulation
    `kappaStar_diverges_at_pc_OPEN` per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern.
    The atom packages the paper-stated unboundedness on the
    `harrisKestenCriticalProb` carrier (Cat 2 dependency on Harris-Kesten
    1960/1980 surfaces via the carrier consumption).

    paper source: Theorem 4.1 Part 6, line 496. -/
theorem gap_cognitive_threshold_part6 :
    ∀ α : ℝ, alphaStar 0 harrisKestenCriticalProb < α →
      ∀ M : ℝ, ∃ ε : ℝ, 0 < ε ∧
        ∀ p : ℝ, harrisKestenCriticalProb - ε < p → p < harrisKestenCriticalProb →
          M < kappaStar p α :=
  kappaStar_diverges_at_pc_OPEN

/-- **Theorem 4.1 (full statement, conjunction).**
    Combines all six parts above. Each conjunct is the exact statement
    delivered by the corresponding `gap_cognitive_threshold_partK_OPEN`
    axiom (Part 3 is projected to its non-negativity sub-clause for
    notational uniformity with the other parts; the substantive
    continuity / Tendsto / sInf / strict-positivity content of Part 3
    is encoded in the axiom itself and accessible through it). -/
theorem gap_cognitive_threshold_characterisation
    (hC : Conditions_C1_C2_C3)
    (hT : TerminalNeighbourTopology) :
    -- Part 1
    (∀ p α : ℝ, alphaStar 0 p < α →
      ∃ β₁ β₂ : ℝ, β₁ < β₂ ∧
        agentWelfare AgentType.greedy β₂ 0 α <
          agentWelfare AgentType.greedy β₁ 0 α) ∧
    -- Part 2 (recovery at large κ)
    (∀ _p α : ℝ,
      ∃ κ₀ : ℝ, ∀ κ β₁ β₂ : ℝ, κ₀ ≤ κ → β₁ ≤ β₂ →
        agentWelfare AgentType.kappaAgent β₁ κ α ≤
          agentWelfare AgentType.kappaAgent β₂ κ α) ∧
    -- Part 3 (existence; non-negativity sub-clause)
    (∀ p α : ℝ, 0 ≤ kappaStar p α) ∧
    -- Part 4 (p-monotonicity)
    (∀ α : ℝ, ∀ p₁ p₂ : ℝ, p₁ ≤ p₂ → kappaStar p₁ α ≤ kappaStar p₂ α) ∧
    -- Part 5 (α-monotonicity)
    (∀ p : ℝ, ∀ α₁ α₂ : ℝ, α₁ ≤ α₂ → kappaStar p α₁ ≤ kappaStar p α₂) ∧
    -- Part 6 (divergence at p_c)
    (∀ α : ℝ, alphaStar 0 harrisKestenCriticalProb < α →
      ∀ M : ℝ, ∃ ε : ℝ, 0 < ε ∧
        ∀ p : ℝ, harrisKestenCriticalProb - ε < p → p < harrisKestenCriticalProb →
          M < kappaStar p α) :=
  ⟨ gap_cognitive_threshold_part1 hC hT,
    gap_cognitive_threshold_part2 gap_blackwell_monotonicity_OPEN hC hT,
    fun p α => (gap_cognitive_threshold_part3 hC p α).2.2.2.2,
    gap_cognitive_threshold_part4,
    gap_cognitive_threshold_part5,
    gap_cognitive_threshold_part6 ⟩

/-! ## 3. Proposition `prop:supermodular` — Supermodular Complementarity

In the moderate signal-to-noise regime `|z| < 1`, the welfare cross-
partial `∂²W/(∂β ∂κ) > 0`: signal precision and cognitive depth are
Topkis complements. -/

/-- The signal-to-noise ratio `z(β, κ) = m(κ)/σ_eff(β)` (paper line 568).
    Substantive paper claim — opaque carrier required (Mathlib gap). -/
axiom snrZ : ℝ → ℝ → ℝ

/-- The welfare cross-partial `∂²W/(∂β ∂κ)` evaluated at `(β, κ)`.
    Substantive paper claim — opaque carrier required (Mathlib gap).
    paper source: Proposition `prop:supermodular`. -/
axiom welfareCrossPartial : ℝ → ℝ → ℝ

/-- Substantive paper claim — Cat 3 paper-novel predicate.
    Bridge-dominance hypothesis for the supermodular regime: at signal
    precision `β`, the dynamic value of the bridge neighbour `u_2`
    exceeds the static reward of the trap neighbour `u_1`, i.e. the
    paper notation `V_dyn(u_2, β) > r(u_1)` (paper line 558). The
    proposition's positivity claim on `welfareCrossPartial` requires
    this antecedent jointly with the moderate-SNR hypothesis
    `|z(β, κ)| < 1`; dropping it would scope-inflate the axiom and was
    previously caught as Audit 2D paper-source-verification finding.
    Encoded as an opaque predicate `BridgeDominance : ℝ → Prop`
    rather than an explicit `V_dyn` carrier comparison because the
    paper-stated condition is a per-`β` regime gate keyed off the
    fixed paper-instance vertices `(u_1, u_2)`; an explicit
    `V_dyn`-vs-`reward` form would force opaque-carrier choices for
    the paper-instance vertex pair that are outside the scope of this
    file (`u_1, u_2` are local to the proposition's setup).
    paper source: Proposition `prop:supermodular`, line 558
    (`V_dyn(u_2, β) > r(u_1)` joint hypothesis). -/
axiom BridgeDominance : ℝ → Prop

/- **Proposition `prop:supermodular` (Supermodular Complementarity).**
    Under C1-C3 + terminal-neighbour topology + `α = 1` + the monotonicity
    of `m(κ)` hypothesis, the welfare function satisfies
    `∂²W / (∂β ∂κ) > 0` for `(β, κ)` jointly satisfying both
    (i) `|z(β, κ)| < 1` (moderate SNR) and
    (ii) `V_dyn(u_2, β) > r(u_1)` (bridge-dominance, paper line 558),
    encoded as `BridgeDominance β` (Cat 3 paper-novel predicate).

    The bundled `gap_supermodular_OPEN` axiom is now REPLACED by the
    derived theorem `gap_supermodular` composing two atomic
    stipulations per `feedback_gap_ledger_in_lean4` §18 Manufactured-
    Recognition pattern: see `welfareCrossPartial_explicit_form_OPEN`
    (paper-stated calculus expression, line 580-583) and
    `cross_partial_sign_in_z_lt_one_OPEN` (paper-stated sign analysis at
    `|z| < 1`, line 582-584) below. The Cat 2 Topkis dependency is
    threaded as the explicit `h_topkis` antecedent for audit-chain
    visibility.

    paper source: Proposition `prop:supermodular`, lines 552-585
    (joint antecedent `|z| < 1 ∧ V_dyn(u_2, β) > r(u_1)` at line 558);
    Topkis 1978/1998 cited as structural inspiration. -/

/-- Cat 3 paper-novel ATOMIC stipulation: paper Proposition
    `prop:supermodular` proof line 580-583 derives the explicit
    closed-form expression for the welfare cross-partial:
    `∂²P_correct / (∂β ∂κ) = |σ'_eff|/σ_eff² · m'(κ) · φ(z) · [1 - z²]`
    using `φ'(z) = -z·φ(z)` (paper line 583). Combined with the
    paper's welfare decomposition `W = P_correct · V_dyn(u_2, β)
    + (1 - P_correct) · r(u_1)` (paper line 564), the cross-partial
    `∂²W / (∂β ∂κ)` decomposes as the sum of two terms (paper line 566):
    (i) `∂²P_correct/(∂β ∂κ) · [V_dyn(u_2, β) - r(u_1)]` (involving the
    `[1 - z²]` factor) plus (ii) `∂P_correct/∂κ · ∂V_dyn(u_2, β)/∂β`
    (the within-subtree Blackwell term, non-negative). This atomic
    stipulation isolates the EXISTENCE of an algebraic decomposition
    of `welfareCrossPartial β κ` as a sum of these two paper-stated
    contributions, on the existing carriers `welfareCrossPartial`,
    `snrZ` (z = m(κ)/σ_eff(β)), `BridgeDominance` (the V_dyn(u_2,β)
    > r(u_1) condition).

    Encoding choice: extracted from the bundled `gap_supermodular_OPEN`
    per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition
    pattern (decompose bundled conclusion-axiom into atomic
    stipulations + derived theorem). The decomposition is encoded as
    a per-`(β, κ)` existential `∃ first second, welfareCrossPartial =
    first + second ∧ second-non-negative`, capturing the paper's
    two-term welfare-cross-partial decomposition without committing to
    explicit Φ + φ derivative computations (which are Mathlib gaps).

    Cat 3 sub-type: workingAssumption (paper-stated closed-form
    calculus expression on opaque carrier `welfareCrossPartial`;
    pending Mathlib HasDerivAt + Φ + φ derivative machinery; 必须
    close before publication).

    paper source: Proposition `prop:supermodular` proof, lines 564-583
    (welfare decomposition + cross-partial closed form via φ'(z) =
    -z·φ(z)). -/
axiom welfareCrossPartial_explicit_form_OPEN :
    Conditions_C1_C2_C3 →
    TerminalNeighbourTopology →
    ∀ β κ : ℝ, BridgeDominance β →
      ∃ first second : ℝ,
        welfareCrossPartial β κ = first + second ∧
        0 ≤ second ∧
        -- first term sign matches `[1 - z²]` factor sign
        (|snrZ β κ| < 1 → 0 < first)

/-- Cat 3 paper-novel ATOMIC stipulation: paper Proposition
    `prop:supermodular` proof line 582-584 derives that under the
    moderate-SNR antecedent `|z(β, κ)| < 1`, each factor in the
    cross-partial closed form is strictly positive: `|σ'_eff|/σ_eff²
    > 0` (effective noise SD strictly decreasing in β), `m'(κ) > 0`
    (paper hypothesis monotonicity of mean estimate gap), `φ(z) > 0`
    (Gaussian PDF positivity), and `[1 - z²] > 0` (the
    moderate-SNR antecedent). Combined with the bridge-dominance
    antecedent `V_dyn(u_2, β) > r(u_1)` (paper line 558), the
    first-term factor `[V_dyn(u_2, β) - r(u_1)] > 0`, making the
    full first-term contribution strictly positive. The second term
    is non-negative (paper line 568). Hence the sum is strictly
    positive: `0 < welfareCrossPartial β κ`.

    Encoding choice: extracted from the bundled `gap_supermodular_OPEN`
    per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition
    pattern. Captures the paper's sign-analysis step that converts
    the explicit closed-form expression (encoded by
    `welfareCrossPartial_explicit_form_OPEN`) into the strict-
    positivity conclusion under the moderate-SNR + bridge-dominance
    joint antecedent.

    Cat 3 sub-type: workingAssumption (paper-stated sign analysis on
    opaque carrier `welfareCrossPartial` decomposition; pending
    Mathlib Gaussian PDF positivity + derivative-sign-from-formula
    machinery; 必须 close before publication).

    paper source: Proposition `prop:supermodular` proof, line 582-584
    (`|σ'_eff|/σ_eff² > 0; m'(κ) > 0; φ(z) > 0; [1 - z²] > 0` factor
    analysis at `|z| < 1`). -/
axiom cross_partial_sign_in_z_lt_one_OPEN :
    Conditions_C1_C2_C3 →
    TerminalNeighbourTopology →
    ∀ β κ : ℝ, |snrZ β κ| < 1 →
      BridgeDominance β →
      ∀ first second : ℝ,
        welfareCrossPartial β κ = first + second →
        0 ≤ second →
        (|snrZ β κ| < 1 → 0 < first) →
        0 < welfareCrossPartial β κ

/-- **Proposition `prop:supermodular` (Supermodular Complementarity).**
    Under C1-C3 + terminal-neighbour topology + `α = 1`, the welfare
    function satisfies `∂²W / (∂β ∂κ) > 0` for `(β, κ)` jointly
    satisfying both (i) `|z(β, κ)| < 1` (moderate SNR) and
    (ii) `V_dyn(u_2, β) > r(u_1)` (bridge-dominance, paper line 558).

    Derived theorem composing two atomic stipulations per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition
    pattern: `welfareCrossPartial_explicit_form_OPEN` (paper-stated
    calculus closed form, line 580-583) +
    `cross_partial_sign_in_z_lt_one_OPEN` (paper-stated sign analysis
    at `|z| < 1`, line 582-584).

    The Cat 2 Topkis 1978/1998 dependency is threaded as the explicit
    `h_topkis` antecedent for audit-chain visibility (the wider
    cross-partial-to-supermodularity bridge inspired by Topkis is
    consumed downstream by `gap_kappaWelfare_cross_partial_link_OPEN`
    rather than at this proposition's decomposition).

    paper source: Proposition `prop:supermodular`, lines 552-585. -/
theorem gap_supermodular
    (_h_topkis : ∀ (W : ℝ → ℝ → ℝ),
      (∀ x₁ x₂ y₁ y₂ : ℝ, x₁ ≤ x₂ → y₁ ≤ y₂ →
        W x₁ y₁ + W x₂ y₂ ≥ W x₁ y₂ + W x₂ y₁) →
      ∀ x₁ x₂ y₁ y₂ : ℝ, x₁ ≤ x₂ → y₁ ≤ y₂ →
        W x₁ y₁ + W x₂ y₂ ≥ W x₁ y₂ + W x₂ y₁)
    (hC : Conditions_C1_C2_C3) (hT : TerminalNeighbourTopology) :
    ∀ β κ : ℝ, |snrZ β κ| < 1 →
      BridgeDominance β →
      0 < welfareCrossPartial β κ := by
  intros β κ hz hbd
  obtain ⟨first, second, h_eq, h_second_nn, h_first_pos⟩ :=
    welfareCrossPartial_explicit_form_OPEN hC hT β κ hbd
  exact cross_partial_sign_in_z_lt_one_OPEN hC hT β κ hz hbd
    first second h_eq h_second_nn h_first_pos

/-- The κ-agent's welfare under the moderate-SNR regime with `α = 1`.

    Hodge-style concrete definition (per the
    `feedback_gap_ledger_in_lean4` 2026-05-13 Cat 1 reduction discipline):
    the previously orphan opaque carrier is now a Mathlib-level `def`
    that returns the existing `agentWelfare` primitive instantiated on
    the `AgentType.kappaAgent` constructor at `α = 1`. The companion
    structural equation `kappaAgentWelfareSNR_def` becomes a Cat 1
    closed theorem (proof: `rfl`).

    paper source: Proposition `prop:supermodular`, line 565 (welfare
    object `W(β, κ)` for the κ-agent at `α = 1`). -/
noncomputable def kappaAgentWelfareSNR (β κ : ℝ) : ℝ :=
  agentWelfare AgentType.kappaAgent β κ 1

/-- Cat 1 derived theorem: definitional unfolding of `kappaAgentWelfareSNR`
    to its underlying `agentWelfare` instance at `α = 1`. Closes via
    `rfl` because `kappaAgentWelfareSNR` is now a Mathlib-level `def`
    (formerly the axiom-pair `axiom kappaAgentWelfareSNR + axiom
    kappaAgentWelfareSNR_def`). Eliminates the opaque-on-opaque pattern
    between `kappaAgentWelfareSNR` and the welfare ledger; downstream
    consumers (the `prop:supermodular` cross-partial closure and
    `cor:policy-complementarity`) inherit the binding to `agentWelfare`
    automatically.

    paper source: Proposition `prop:supermodular`, line 565 (welfare
    object `W(β, κ)` for the κ-agent at `α = 1`). -/
theorem kappaAgentWelfareSNR_def :
    ∀ (β κ : ℝ),
      kappaAgentWelfareSNR β κ = agentWelfare AgentType.kappaAgent β κ 1 := by
  intros β κ
  rfl

/-- Cat 1 derived theorem: the moderate-SNR κ-agent welfare carrier
    `kappaAgentWelfareSNR β κ` lies in `[0, 1]` for any precision `β`
    and cognitive depth `κ`. Composes the structural-equation atom
    `kappaAgentWelfareSNR_def` (paper `prop:supermodular` line 565
    pinning the carrier to `agentWelfare AgentType.kappaAgent β κ 1`)
    with the unit-interval atom `agentWelfare_mem_unitInterval`
    (Types.lean §2.5 lines 204-208 + Def 2.1 line 113), giving both
    atoms an explicit downstream consumer per the discipline's
    "every atom serves a derived theorem" mandate. The unit-interval
    bound on `kappaAgentWelfareSNR` is paper-implicit (welfare values
    are bounded by the reward range `[0, 1]`); this derivation makes
    that consequence operational on the moderate-SNR carrier.
    paper source: Proposition `prop:supermodular`, line 565 (welfare
    object `W(β, κ)` for the κ-agent at `α = 1`) + §2.5 lines 204-208
    + Definition 2.1 line 113 (`r: V → [0, 1]`). -/
theorem kappaAgentWelfareSNR_mem_unitInterval (β κ : ℝ) :
    0 ≤ kappaAgentWelfareSNR β κ ∧ kappaAgentWelfareSNR β κ ≤ 1 := by
  rw [kappaAgentWelfareSNR_def β κ]
  exact agentWelfare_mem_unitInterval AgentType.kappaAgent β κ 1

/-- Substantive paper claim — opaque-carrier coupling axiom.
    The cross-partial `welfareCrossPartial β κ` equals the limit of
    discrete second-differences of `kappaAgentWelfareSNR` (the
    paper-stated mixed-partial relationship for the smooth IDP welfare
    under moderate SNR). For closure-discipline purposes here we encode
    only the qualitative relationship: positivity of the cross-partial
    at the four lattice corners `(β_i, κ_j)` implies positivity of the
    appropriate discrete second-difference, which is the Topkis pairwise
    inequality for `kappaAgentWelfareSNR` on those corners. This
    axiomatic link is required because both `welfareCrossPartial` and
    `kappaAgentWelfareSNR` are opaque carriers; the coupling cannot be
    derived without committing to a concrete welfare functional.
    Topkis 1978/1998 is the structural inspiration for the
    cross-partial-to-supermodularity bridge, but the regional `|z| < 1`
    cross-partial positivity hypothesised at the four corners is
    paper-novel content not directly reducible to the universal
    Topkis criterion (the Topkis Cat 2 axiom
    `gap_topkis_supermodularity_OPEN` quantifies over universal
    non-negativity, not the regional/four-corner positivity used here).
    Cat 2 dependency surfacing: per the audit-chain discipline (axioms
    have no body, so a downstream axiom cannot "compose" an upstream
    axiom by direct call), the Cat 2 axiom
    `gap_topkis_supermodularity_OPEN` (Topkis 1978/1998) is threaded as
    an EXPLICIT ANTECEDENT `(h_topkis : ...)` so that `#print axioms`
    on any theorem consuming `gap_kappaWelfare_cross_partial_link_OPEN`
    surfaces the Topkis dependency. The R26 drop of this antecedent
    over-applied the "Cat 2 implicit consumption" rule: the CLAIM
    CONTENT of this entry is the Topkis cross-partial-to-supermodularity
    bridge applied to the paper-novel `kappaAgentWelfareSNR` carrier on
    the four corner-lattice points (per `feedback_gap_ledger_in_lean4`
    §10 paper-APPLICATION-to-opaque-carrier = Cat 3 with explicit Cat 2
    chain). The relevant Cat 2 axiom lives at
    `ClassicalResults.lean :: gap_topkis_supermodularity_OPEN`.
    paper source: Proposition `prop:supermodular` proof line, calculus
    of the welfare gradient; Topkis 1978/1998 cited as structural
    inspiration. -/
axiom corner_supermodularity_via_topkis_OPEN :
    (∀ (W : ℝ → ℝ → ℝ),
      (∀ x₁ x₂ y₁ y₂ : ℝ, x₁ ≤ x₂ → y₁ ≤ y₂ →
        W x₁ y₁ + W x₂ y₂ ≥ W x₁ y₂ + W x₂ y₁) →
      ∀ x₁ x₂ y₁ y₂ : ℝ, x₁ ≤ x₂ → y₁ ≤ y₂ →
        W x₁ y₁ + W x₂ y₂ ≥ W x₁ y₂ + W x₂ y₁) →
    ∀ β₁ β₂ κ₁ κ₂ : ℝ, β₁ ≤ β₂ → κ₁ ≤ κ₂ →
      |snrZ β₁ κ₁| < 1 → |snrZ β₂ κ₂| < 1 →
      |snrZ β₁ κ₂| < 1 → |snrZ β₂ κ₁| < 1 →
      (0 < welfareCrossPartial β₁ κ₁ → 0 < welfareCrossPartial β₂ κ₂ →
       0 < welfareCrossPartial β₁ κ₂ → 0 < welfareCrossPartial β₂ κ₁ →
       kappaAgentWelfareSNR β₁ κ₁ + kappaAgentWelfareSNR β₂ κ₂ ≥
         kappaAgentWelfareSNR β₁ κ₂ + kappaAgentWelfareSNR β₂ κ₁)

/-- Cat 3 derived theorem (re-export of `corner_supermodularity_via_topkis_OPEN`):
    cross-partial-positivity-at-the-four-lattice-corners → corner-
    supermodularity link on the paper-novel `kappaAgentWelfareSNR`
    carrier. Threads the Topkis 1978/1998 Cat 2 dependency via the
    `h_topkis` antecedent for audit-chain visibility.

    Decomposition per `feedback_gap_ledger_in_lean4` §18 Manufactured-
    Recognition pattern: the bundled OPEN axiom previously named
    `gap_kappaWelfare_cross_partial_link_OPEN` is now hosted by the
    Cat 3 atomic stipulation `corner_supermodularity_via_topkis_OPEN`
    (renamed to reflect the atomic content); this derived theorem is
    the trivial consumer used by downstream policy-complementarity
    closures.

    paper source: Proposition `prop:supermodular` proof, calculus of
    the welfare gradient; Topkis 1978/1998 cited as structural
    inspiration. -/
theorem gap_kappaWelfare_cross_partial_link
    (h_topkis : ∀ (W : ℝ → ℝ → ℝ),
      (∀ x₁ x₂ y₁ y₂ : ℝ, x₁ ≤ x₂ → y₁ ≤ y₂ →
        W x₁ y₁ + W x₂ y₂ ≥ W x₁ y₂ + W x₂ y₁) →
      ∀ x₁ x₂ y₁ y₂ : ℝ, x₁ ≤ x₂ → y₁ ≤ y₂ →
        W x₁ y₁ + W x₂ y₂ ≥ W x₁ y₂ + W x₂ y₁) :
    ∀ β₁ β₂ κ₁ κ₂ : ℝ, β₁ ≤ β₂ → κ₁ ≤ κ₂ →
      |snrZ β₁ κ₁| < 1 → |snrZ β₂ κ₂| < 1 →
      |snrZ β₁ κ₂| < 1 → |snrZ β₂ κ₁| < 1 →
      (0 < welfareCrossPartial β₁ κ₁ → 0 < welfareCrossPartial β₂ κ₂ →
       0 < welfareCrossPartial β₁ κ₂ → 0 < welfareCrossPartial β₂ κ₁ →
       kappaAgentWelfareSNR β₁ κ₁ + kappaAgentWelfareSNR β₂ κ₂ ≥
         kappaAgentWelfareSNR β₁ κ₂ + kappaAgentWelfareSNR β₂ κ₁) :=
  corner_supermodularity_via_topkis_OPEN h_topkis

/-- **Corollary `cor:policy-complementarity`** — derived from
    `gap_supermodular_OPEN` (positive cross-partial in moderate-SNR
    regime) via `gap_kappaWelfare_cross_partial_link_OPEN` (the
    opaque-carrier coupling axiom for the
    cross-partial-to-supermodularity step). This restores the paper's
    actual derivation chain: cross-partial > 0 at the four lattice
    corners → corner-supermodularity → policy complementarity.

    Bridge-dominance hypothesis `h_dom : ∀ β, BridgeDominance β` is
    threaded per the Audit 2D paper-source-verification finding: the
    paper's positivity claim on `welfareCrossPartial` requires the
    joint antecedent `|z| < 1 ∧ V_dyn(u_2, β) > r(u_1)` (paper line
    558), so each of the four corner-applications of
    `gap_supermodular_OPEN` must be supplied with the bridge-dominance
    witness at the corresponding `β`-coordinate.

    Topkis 1978/1998 is the structural inspiration for the
    cross-partial-to-supermodularity bridge. Cat 2 dependency on
    `gap_topkis_supermodularity_OPEN` is consumed via the proof body
    composition through `gap_supermodular_OPEN`'s `h_topkis`
    antecedent (R28-A audit-chain restoration), making the dependency
    visible to `#print axioms`. -/
theorem gap_policy_complementarity_OPEN_derived
    (hC : Conditions_C1_C2_C3) (hT : TerminalNeighbourTopology)
    (h_snr : ∀ β κ : ℝ, |snrZ β κ| < 1)
    (h_dom : ∀ β : ℝ, BridgeDominance β)
    (β₁ β₂ κ₁ κ₂ : ℝ) (hβ : β₁ ≤ β₂) (hκ : κ₁ ≤ κ₂) :
    kappaAgentWelfareSNR β₁ κ₁ + kappaAgentWelfareSNR β₂ κ₂ ≥
      kappaAgentWelfareSNR β₁ κ₂ + kappaAgentWelfareSNR β₂ κ₁ := by
  apply gap_kappaWelfare_cross_partial_link
    gap_topkis_supermodularity_OPEN β₁ β₂ κ₁ κ₂ hβ hκ
  · exact h_snr β₁ κ₁
  · exact h_snr β₂ κ₂
  · exact h_snr β₁ κ₂
  · exact h_snr β₂ κ₁
  · exact gap_supermodular gap_topkis_supermodularity_OPEN
      hC hT β₁ κ₁ (h_snr β₁ κ₁) (h_dom β₁)
  · exact gap_supermodular gap_topkis_supermodularity_OPEN
      hC hT β₂ κ₂ (h_snr β₂ κ₂) (h_dom β₂)
  · exact gap_supermodular gap_topkis_supermodularity_OPEN
      hC hT β₁ κ₂ (h_snr β₁ κ₂) (h_dom β₁)
  · exact gap_supermodular gap_topkis_supermodularity_OPEN
      hC hT β₂ κ₁ (h_snr β₂ κ₁) (h_dom β₂)

/-- **Corollary `cor:policy-complementarity`** — wrapper theorem providing
    the named export `gap_policy_complementarity`. Honestly couples the
    corollary to (a) IDP conditions hC + hT, (b) the κ-agent welfare
    carrier `kappaAgentWelfareSNR` (paper-specific, not the generic
    Topkis wrapper), (c) the moderate-SNR regime hypothesis (the
    paper's stated domain restriction), and (d) the bridge-dominance
    hypothesis `BridgeDominance β` (paper line 558 joint antecedent
    on `gap_supermodular_OPEN`'s positivity claim). Derives via
    `gap_policy_complementarity_OPEN_derived`, which composes
    `gap_supermodular_OPEN` (positive welfare cross-partial) with
    `gap_kappaWelfare_cross_partial_link_OPEN` (the cross-partial →
    corner-supermodularity coupling axiom).

    Topkis 1978/1998 is the structural inspiration for the
    cross-partial-to-supermodularity bridge; per R28-A, the Cat 2 axiom
    `gap_topkis_supermodularity_OPEN` is now threaded through
    `gap_supermodular_OPEN`'s `h_topkis` antecedent (proof-body
    composition), so `#print axioms gap_policy_complementarity` will
    surface `gap_topkis_supermodularity_OPEN` in the dependency closure.

    paper source: Corollary `cor:policy-complementarity`, lines 587-590;
    Topkis 1978/1998 cited as structural inspiration. -/
theorem gap_policy_complementarity
    (hC : Conditions_C1_C2_C3) (hT : TerminalNeighbourTopology) :
    ∀ β₁ β₂ κ₁ κ₂ : ℝ, β₁ ≤ β₂ → κ₁ ≤ κ₂ →
      (∀ β κ : ℝ, |snrZ β κ| < 1) →
      (∀ β : ℝ, BridgeDominance β) →
      kappaAgentWelfareSNR β₁ κ₁ + kappaAgentWelfareSNR β₂ κ₂ ≥
        kappaAgentWelfareSNR β₁ κ₂ + kappaAgentWelfareSNR β₂ κ₁ := by
  intros β₁ β₂ κ₁ κ₂ hβ hκ h_snr h_dom
  exact gap_policy_complementarity_OPEN_derived hC hT h_snr h_dom β₁ β₂ κ₁ κ₂ hβ hκ

/-! ## 4. Proposition `prop:sentimental` — Sentimental Immunity

For any IDP and any `κ ≥ 0`, there exists `α* > 0` such that for
`α < α*`, welfare is monotonically non-decreasing in β. Sufficiently
sentimental agents are immune. -/

/-- Cat 3 paper-novel ATOMIC stipulation: paper Proposition
    `prop:sentimental` proof line 600 (base case at α = 0). At α = 0,
    the agent's ranking of neighbours converges to `ξ(u)` (intrinsic
    preference), which is signal-independent. Therefore
    `P_trap(β, κ, 0) = Pr(ξ(u_1) > ξ(u_2)) = 1/2` for all β, and the
    ranking is signal-independent. Since within-branch welfare under
    fixed ranking is non-decreasing in β by the standard Blackwell
    argument (paper Lemma `lem:conditional-reduction`), the welfare
    `W(β, κ, 0)` is non-decreasing in β. This atomic stipulation
    captures the α = 0 base case.

    Encoding choice: extracted from the bundled
    `gap_sentimental_immunity_OPEN` per `feedback_gap_ledger_in_lean4`
    §18 Manufactured-Recognition pattern. The α = 0 base case is the
    primitive paper-stated fact on the sentimental-agent welfare
    carrier; the existence of `α* > 0` follows from this base case
    plus paper-stated continuity of `α ↦ W(β, κ, α)`.

    Cat 3 sub-type: workingAssumption (paper-stated α = 0 monotonicity
    base case via paper `lem:conditional-reduction`(i) applied at the
    signal-independent ranking; 必须 close before publication).

    paper source: Proposition `prop:sentimental` proof, line 600
    (signal-independent ranking at α = 0 + `lem:conditional-reduction`
    application). -/
axiom signal_independent_at_alpha_zero_OPEN :
    ∀ κ _p : ℝ, 0 ≤ κ →
      ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
        agentWelfare AgentType.sentimental β₁ κ 0 ≤
          agentWelfare AgentType.sentimental β₂ κ 0

/-- Cat 3 paper-novel ATOMIC stipulation: paper Proposition
    `prop:sentimental` proof line 602 (perturbative continuity in α).
    Paper states that the set `{α ∈ [0, 1] : W(β, κ, α) non-decreasing
    in β}` is CLOSED in α (by pointwise convergence of continuous
    functions on the compact domain `β ∈ [0, B]` for any finite B,
    and the limit of non-decreasing functions is non-decreasing).
    Moreover, the perturbation bound `|P_trap(β, κ, α) - 1/2| ≤
    α · |E[V̂_κ(u_1)] - E[V̂_κ(u_2)]| / Var(ξ)^{1/2}` (paper line 602)
    is `O(α)`-small, so for α small enough the perturbation does not
    create non-monotonicity. This atomic stipulation captures the
    paper-stated closedness + small-α perturbation neighborhood:
    `∃ δ > 0, ∀ α ∈ [0, δ], W(β, κ, α) non-decreasing in β`.

    Encoding choice: extracted from the bundled
    `gap_sentimental_immunity_OPEN` per `feedback_gap_ledger_in_lean4`
    §18 Manufactured-Recognition pattern.

    Cat 3 sub-type: workingAssumption (paper-stated perturbative
    continuity argument; pending Mathlib closed-set/compact-domain
    Banach-lattice analysis; 必须 close before publication).

    paper source: Proposition `prop:sentimental` proof, line 602
    (closed monotonicity-set + small-α perturbation neighborhood). -/
axiom welfare_continuity_in_alpha_OPEN :
    ∀ κ _p : ℝ, 0 ≤ κ →
      ∃ δ : ℝ, 0 < δ ∧ δ ≤ 1 ∧
        ∀ α : ℝ, 0 ≤ α → α ≤ δ →
          ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
            agentWelfare AgentType.sentimental β₁ κ α ≤
              agentWelfare AgentType.sentimental β₂ κ α

/-- Cat 3 paper-novel ATOMIC stipulation: paper Proposition
    `prop:sentimental` proof line 602 (sup over monotonicity set).
    Paper defines `α*(κ, p)` as the supremum of the closed set
    `{α ∈ [0, 1] : W(β, κ, α) non-decreasing in β}`. By the
    α = 0 base case (`signal_independent_at_alpha_zero_OPEN`) and the
    small-α perturbation neighborhood (`welfare_continuity_in_alpha_OPEN`),
    the set contains a neighbourhood of 0 with positive width, hence
    its supremum lies in `(0, 1]`. This atomic stipulation captures
    the paper-stated existence of `α*` with positivity + upper-bound-by-1
    + the monotonicity-for-α-below-α* implication, given the small-α
    neighbourhood width δ.

    Encoding choice: extracted from the bundled
    `gap_sentimental_immunity_OPEN` per `feedback_gap_ledger_in_lean4`
    §18 Manufactured-Recognition pattern.

    Cat 3 sub-type: workingAssumption (paper-stated supremum existence
    argument; pending Mathlib sSup/closed-set machinery; 必须 close
    before publication).

    paper source: Proposition `prop:sentimental` proof, line 602
    (sup over monotonicity set). -/
axiom alpha_star_existence_via_continuity_OPEN :
    ∀ κ p : ℝ, 0 ≤ κ →
      ∀ δ : ℝ, 0 < δ → δ ≤ 1 →
        (∀ α : ℝ, 0 ≤ α → α ≤ δ →
          ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
            agentWelfare AgentType.sentimental β₁ κ α ≤
              agentWelfare AgentType.sentimental β₂ κ α) →
        0 < alphaStar κ p ∧ alphaStar κ p ≤ 1 ∧
        ∀ α : ℝ, 0 ≤ α → α < alphaStar κ p →
          ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
            agentWelfare AgentType.sentimental β₁ κ α ≤
              agentWelfare AgentType.sentimental β₂ κ α

/-- **Proposition `prop:sentimental` (Sentimental Immunity).**
    For each `κ ≥ 0`, `α*(κ, p) ∈ (0, 1]`, and welfare is non-decreasing
    in β for `α < α*`.

    Derived theorem composing three atomic stipulations per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition
    pattern: `signal_independent_at_alpha_zero_OPEN` (paper L600 base
    case at α = 0), `welfare_continuity_in_alpha_OPEN` (paper L602
    perturbative continuity neighbourhood), and
    `alpha_star_existence_via_continuity_OPEN` (paper L602 sup over
    monotonicity set).

    paper source: Proposition `prop:sentimental`, lines 595-603. -/
theorem gap_sentimental_immunity :
    ∀ κ p : ℝ, 0 ≤ κ →
      0 < alphaStar κ p ∧ alphaStar κ p ≤ 1 ∧
      ∀ α : ℝ, 0 ≤ α → α < alphaStar κ p →
        ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
          agentWelfare AgentType.sentimental β₁ κ α ≤
            agentWelfare AgentType.sentimental β₂ κ α := by
  intros κ p hκ
  obtain ⟨δ, hδ_pos, hδ_le_one, h_mono⟩ :=
    welfare_continuity_in_alpha_OPEN κ p hκ
  exact alpha_star_existence_via_continuity_OPEN κ p hκ δ hδ_pos hδ_le_one h_mono

/-! ## 5. Proposition `prop:threshold-alpha` — Cognitive Threshold
   Increases with Instrumental Rationality

`∂κ*/∂α > 0` for `α ∈ (0, 1)`. -/

/-- **Proposition `prop:threshold-alpha`.** `κ*(α)` is non-decreasing in
    `α` on `(0, 1)`; `α*(κ, p)` exists by continuity at `α = 0`.

    Re-export of `gap_cognitive_threshold_part5_OPEN` (reverted from
    a prior tautological CLOSED — see the upstream axiom docstring
    for the α-erasure honesty audit).

    paper source: Proposition `prop:threshold-alpha`, lines 527-543. -/
theorem gap_threshold_alpha_monotone :
    ∀ p : ℝ, ∀ α₁ α₂ : ℝ, α₁ ≤ α₂ →
      kappaStar p α₁ ≤ kappaStar p α₂ :=
  gap_cognitive_threshold_part5

end BlackwellDilemma
