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

/-- **Theorem 4.1 Part 1: Failure at `κ = 0`.**
    For `α > α*(0, p)`, greedy welfare is non-monotone in β.

    paper source: Theorem 4.1 Part 1, line 491. -/
axiom gap_cognitive_threshold_part1_OPEN :
    Conditions_C1_C2_C3 →
    TerminalNeighbourTopology →
    ∀ p α : ℝ, alphaStar 0 p < α →
      ∃ β₁ β₂ : ℝ, β₁ < β₂ ∧
        agentWelfare AgentType.greedy β₂ 0 α <
          agentWelfare AgentType.greedy β₁ 0 α

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
axiom gap_cognitive_threshold_part2_OPEN :
    (∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
      agentWelfare AgentType.bayesian β₁ 0 1 ≤
        agentWelfare AgentType.bayesian β₂ 0 1) →
    Conditions_C1_C2_C3 →
    TerminalNeighbourTopology →
    ∀ _p α : ℝ,
      ∃ κ₀ : ℝ, ∀ κ β₁ β₂ : ℝ, κ₀ ≤ κ → β₁ ≤ β₂ →
        agentWelfare AgentType.kappaAgent β₁ κ α ≤
          agentWelfare AgentType.kappaAgent β₂ κ α

/-- Substantive paper claim — opaque carrier required (Mathlib gap).
    Asymptotic limit of the mean-estimate-gap `m(κ)` as `κ → ∞`,
    paper notation `V_dyn(u_2) − V_dyn(u_1)`. Strict positivity is
    asserted in `gap_cognitive_threshold_part3_OPEN`.

    paper source: Theorem 4.1 Part 3, line 493. -/
axiom mLimit : ℝ → ℝ

/-- **Theorem 4.1 Part 3: Existence of `κ*` (with paper's full content).**
    `m(κ)` (the mean-estimate-gap, `mean_estimate_gap p κ`) is continuous
    on `(0, ∞)`, and `m(κ) → V_dyn(u_2) − V_dyn(u_1) =: mLimit p > 0`
    as `κ → ∞`. The cognitive threshold satisfies the inf-characterisation
    `κ*(p, α) = sInf {κ : 0 < κ ∧ 0 ≤ mean_estimate_gap p κ}` and
    lies in `[0, ∞)`.

    Encoded as the conjunction of the four sub-claims (continuity of
    `m(·)` on `(0, ∞)`, the `Tendsto` limit at infinity, strict
    positivity of the limit, and the sInf characterisation pinned with
    non-negativity of `kappaStar`). The earlier weaker form (just
    `0 ≤ kappaStar p α`) was caught as Anti-pattern #2 in the
    discipline audit and is now superseded.

    Continuity is asserted as `ContinuousOn ... (Set.Ioi 0)` (the
    positive reals), matching the paper's domain restriction exactly:
    paper Remark `kappa-discontinuity` (Types.lean, around line 174)
    explicitly separates the greedy agent (`κ = 0`) from the
    `κ → 0⁺` limit, so the paper does NOT claim continuity at or
    below 0. (A prior version of this axiom asserted global
    `Continuous` on all of ℝ — an overclaim relative to the paper,
    corrected here.)

    paper source: Theorem 4.1 Part 3, line 493. -/
axiom gap_cognitive_threshold_part3_OPEN :
    Conditions_C1_C2_C3 →
    ∀ p α : ℝ,
      ContinuousOn (fun κ : ℝ => mean_estimate_gap p κ) (Set.Ioi 0) ∧
      Filter.Tendsto (fun κ : ℝ => mean_estimate_gap p κ) Filter.atTop
        (nhds (mLimit p)) ∧
      0 < mLimit p ∧
      kappaStar p α =
        sInf { κ : ℝ | 0 < κ ∧ 0 ≤ mean_estimate_gap p κ } ∧
      0 ≤ kappaStar p α

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
axiom gap_cognitive_threshold_part4_OPEN :
    ∀ α : ℝ, ∀ p₁ p₂ : ℝ, p₁ ≤ p₂ →
      kappaStar p₁ α ≤ kappaStar p₂ α

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
axiom gap_cognitive_threshold_part5_OPEN :
    ∀ p : ℝ, ∀ α₁ α₂ : ℝ, α₁ ≤ α₂ →
      kappaStar p α₁ ≤ kappaStar p α₂

/-- **Theorem 4.1 Part 6: Divergence at `p_c`.**
    On `Z²` with `α > α*`, `κ*(p, α) → +∞` as `p → p_c⁻` (provided
    `κ*(p, α) > 0` near `p_c`).

    paper source: Theorem 4.1 Part 6, line 496. -/
axiom gap_cognitive_threshold_part6_OPEN :
    ∀ α : ℝ, alphaStar 0 harrisKestenCriticalProb < α →
      ∀ M : ℝ, ∃ ε : ℝ, 0 < ε ∧
        ∀ p : ℝ, harrisKestenCriticalProb - ε < p → p < harrisKestenCriticalProb →
          M < kappaStar p α

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
  ⟨ gap_cognitive_threshold_part1_OPEN hC hT,
    gap_cognitive_threshold_part2_OPEN gap_blackwell_monotonicity_OPEN hC hT,
    fun p α => (gap_cognitive_threshold_part3_OPEN hC p α).2.2.2.2,
    gap_cognitive_threshold_part4_OPEN,
    gap_cognitive_threshold_part5_OPEN,
    gap_cognitive_threshold_part6_OPEN ⟩

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

/-- **Proposition `prop:supermodular` (Supermodular Complementarity).**

    Under C1-C3 + terminal-neighbour topology + `α = 1` + the monotonicity
    of `m(κ)` hypothesis, the welfare function satisfies
    `∂²W / (∂β ∂κ) > 0` for `(β, κ)` jointly satisfying both
    (i) `|z(β, κ)| < 1` (moderate SNR) and
    (ii) `V_dyn(u_2, β) > r(u_1)` (bridge-dominance, paper line 558),
    encoded as `BridgeDominance β` (Cat 3 paper-novel predicate).

    Substantive paper claim — opaque carrier required (Mathlib gap).
    Topkis 1978/1998 is the structural inspiration for the
    cross-partial-to-supermodularity bridge.

    Cat 2 dependency surfacing (R28-A restoration): per the audit-chain
    discipline (axioms have no body, so a downstream axiom cannot
    "compose" an upstream axiom by direct call), the Cat 2 axiom
    `gap_topkis_supermodularity_OPEN` is threaded as an EXPLICIT
    ANTECEDENT `(h_topkis : ...)` for audit-chain visibility.
    `#print axioms` on any theorem consuming `gap_supermodular_OPEN`
    will surface `gap_topkis_supermodularity_OPEN` in the dependency
    closure. The R26 drop of this antecedent was correct for downstream
    THEOREMS (which compose axioms in the proof body) but WRONG for
    downstream AXIOMS (which have no body and therefore cannot make
    the dependency visible to the kernel). The R28 restoration is
    enabled by the Cat 2 axiom's R28-FIX-2 restructure (drop of the
    unrelated `mixedPartial` parameter); the restated Topkis axiom
    has signature `∀ W, supermodularity-on-W → supermodularity-on-W`
    which can be threaded honestly as an antecedent here without the
    universal-vs-regional scope mismatch that R18-A flagged as
    performative.
    paper source: Proposition `prop:supermodular`, lines 552-585
    (joint antecedent `|z| < 1 ∧ V_dyn(u_2, β) > r(u_1)` at line 558);
    Topkis 1978/1998 cited as structural inspiration. -/
axiom gap_supermodular_OPEN :
    (∀ (W : ℝ → ℝ → ℝ),
      (∀ x₁ x₂ y₁ y₂ : ℝ, x₁ ≤ x₂ → y₁ ≤ y₂ →
        W x₁ y₁ + W x₂ y₂ ≥ W x₁ y₂ + W x₂ y₁) →
      ∀ x₁ x₂ y₁ y₂ : ℝ, x₁ ≤ x₂ → y₁ ≤ y₂ →
        W x₁ y₁ + W x₂ y₂ ≥ W x₁ y₂ + W x₂ y₁) →
    Conditions_C1_C2_C3 →
    TerminalNeighbourTopology →
    ∀ β κ : ℝ, |snrZ β κ| < 1 →
      BridgeDominance β →
      0 < welfareCrossPartial β κ

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
axiom gap_kappaWelfare_cross_partial_link_OPEN :
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
  apply gap_kappaWelfare_cross_partial_link_OPEN
    gap_topkis_supermodularity_OPEN β₁ β₂ κ₁ κ₂ hβ hκ
  · exact h_snr β₁ κ₁
  · exact h_snr β₂ κ₂
  · exact h_snr β₁ κ₂
  · exact h_snr β₂ κ₁
  · exact gap_supermodular_OPEN gap_topkis_supermodularity_OPEN
      hC hT β₁ κ₁ (h_snr β₁ κ₁) (h_dom β₁)
  · exact gap_supermodular_OPEN gap_topkis_supermodularity_OPEN
      hC hT β₂ κ₂ (h_snr β₂ κ₂) (h_dom β₂)
  · exact gap_supermodular_OPEN gap_topkis_supermodularity_OPEN
      hC hT β₁ κ₂ (h_snr β₁ κ₂) (h_dom β₁)
  · exact gap_supermodular_OPEN gap_topkis_supermodularity_OPEN
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

/-- **Proposition `prop:sentimental` (Sentimental Immunity).**
    For each `κ ≥ 0`, `α*(κ, p) ∈ (0, 1]`, and welfare is non-decreasing
    in β for `α < α*`.

    paper source: Proposition `prop:sentimental`, lines 595-603. -/
axiom gap_sentimental_immunity_OPEN :
    ∀ κ p : ℝ, 0 ≤ κ →
      0 < alphaStar κ p ∧ alphaStar κ p ≤ 1 ∧
      ∀ α : ℝ, 0 ≤ α → α < alphaStar κ p →
        ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
          agentWelfare AgentType.sentimental β₁ κ α ≤
            agentWelfare AgentType.sentimental β₂ κ α

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
  gap_cognitive_threshold_part5_OPEN

end BlackwellDilemma
