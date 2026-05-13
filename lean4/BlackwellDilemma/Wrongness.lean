/-
  BlackwellDilemma/Wrongness.lean

  §3.2 Welfare Reversal Under Topology-Blind Signals.

  Companion to: "Information Value Under Endogenous Feasibility" (Li, 2026).

  Contents:
   * Lemma `lem:conditional-reduction` — Conditional Reduction Under
     State Augmentation.
   * Lemma `lem:wrongness` — Wrongness of the Greedy Policy Under
     Topology-Blind Signals.
   * Proposition `prop:info-decay` — Informational Decay.
   * Theorem 3.2 (`thm:dilemma`) — Welfare Non-Monotonicity Under
     Endogenous Feasibility.
   * Proposition `prop:topo-cluster` — Topological-Loss/Cluster-Size
     Relation.

  All five statements appeal to the abstract IDP primitives in
  `Types.lean` and the paper-cited classical results in
  `ClassicalResults.lean`. The proofs are wired through paper-citation
  axioms that take the form `gap_<theorem-name>_OPEN`, following the
  `feedback_gap_ledger_in_lean4` status-tag-in-name convention.
-/

import BlackwellDilemma.Basic
import BlackwellDilemma.Types
import BlackwellDilemma.ClassicalResults

namespace BlackwellDilemma

/-! ## 1. Lemma `lem:conditional-reduction`

For each fixed reachable-set realisation `R`, Blackwell's theorem
applies to the conditional subproblem on the restricted action domain
`R(v_0)`. Total welfare decomposes as `W(π) = E_R[W_R(π)] = W_topo(p) +
W_info(p, β)`; the topological term depends only on the percolation
measure, hence is signal-independent. -/

/-- Substantive paper claim — opaque carrier required (Mathlib gap).
    Conditional welfare on a fixed reachable-set realisation `R`, under
    a Blackwell-ordered signal family `{π_β}_β`, as a function of signal
    precision `β`. The paper's part (i) argument applies Blackwell's
    monotonicity theorem within this conditional subproblem on the
    restricted action domain `R`. The carrier type `Finset Vertex`
    matches `ReachableSet : Vertex → PercolationOutcome → Finset Vertex`
    and `ForwardReachable : Vertex → Finset Vertex → PercolationOutcome
    → Finset Vertex` from `Types.lean`; the `signalFamily` slot threads
    the same `(ℝ → PercolationOutcome → ℝ)` shape used by
    `gap_wrongness_OPEN` and `IsBlackwellOrdered` (`Types.lean`). -/
axiom conditionalWelfareOnR :
    Finset Vertex → (ℝ → PercolationOutcome → ℝ) → ℝ → ℝ

/-- **Lemma `lem:conditional-reduction` part (i) — substantive
    Blackwell-conditional content.**
    For each fixed reachable set `R` and each signal family
    `signalFamily : ℝ → PercolationOutcome → ℝ` that is Blackwell-
    ordered (`IsBlackwellOrdered signalFamily`), conditional welfare
    `conditionalWelfareOnR R signalFamily β` is monotone non-decreasing
    in `β`. This is the standard Blackwell theorem applied within the
    conditional subproblem on the restricted action domain `R`: paper
    part (i) literally states "if `π' ≻_B π`, then
    `W_R(π') ≥ W_R(π)`", so the Blackwell-ordering hypothesis is the
    operationally relevant antecedent — without it the monotonicity
    claim is folkloric.

    The previous formulation as a monotonicity claim on an arbitrary
    `W_R : ℝ → ℝ` (with no Blackwell antecedent and no binding to any
    IDP-specific carrier), and the post-carrier intermediate form (with
    the carrier but still no Blackwell-ordering hypothesis), were both
    inflations of the paper's substantive content; the carrier-bound +
    Blackwell-ordered form here matches the paper's actual statement
    scope.

    Cat 2 dependency surfacing: per the audit-chain discipline (axioms
    have no body, so a downstream axiom cannot "compose" an upstream
    axiom by direct call), the Cat 2 axiom
    `gap_blackwell_monotonicity_OPEN` (Blackwell 1951/1953) is threaded
    as an EXPLICIT ANTECEDENT `(h_blackwell : ...)` so that
    `#print axioms` on any theorem consuming
    `gap_conditional_reduction_part_i_OPEN` surfaces the Blackwell
    dependency. The R26 drop of this antecedent over-applied the
    "Cat 2 implicit consumption" rule: the CLAIM CONTENT of this entry
    is essentially the Blackwell monotonicity theorem applied to the
    paper-novel `conditionalWelfareOnR` carrier (per
    `feedback_gap_ledger_in_lean4` §10 paper-APPLICATION-to-opaque-
    carrier = Cat 3 with explicit Cat 2 chain). The relevant Cat 2
    axiom lives at
    `ClassicalResults.lean :: gap_blackwell_monotonicity_OPEN`.

    paper source: Lemma `lem:conditional-reduction` part (i),
    invoking Blackwell's theorem `\citep{blackwell1951,blackwell1953}`. -/
axiom gap_conditional_reduction_part_i_OPEN :
    (∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
      agentWelfare AgentType.bayesian β₁ 0 1 ≤
        agentWelfare AgentType.bayesian β₂ 0 1) →
    ∀ (R : Finset Vertex)
      (signalFamily : ℝ → PercolationOutcome → ℝ),
      IsBlackwellOrdered signalFamily →
      ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
        conditionalWelfareOnR R signalFamily β₁ ≤
          conditionalWelfareOnR R signalFamily β₂

/-- **Lemma `lem:conditional-reduction` part (ii) — welfare decomposition
    + signal-immunity of the dominant component.**
    Paper part (ii) states two facts together:
    (a) total welfare decomposes as `W(π) = W_topo(p) + W_info(p, β)`,
        and
    (b) `W_topo(p) = E_R[max_{v ∈ R} r(v)] − r*` is signal-independent
        (depends only on the percolation measure), so no signal
        comparison `π' ≻_B π` orders the dominant component `W_topo`.
    Both facts are kernel-pure CLOSED in this formalisation:
    (a) is `WelfareSetup.gap_welfare_decomposition` (Basic.lean), and
    (b) is `SignalFamily.gap_W_topo_signal_immune` (SignalImmunity.lean).
    This re-export records the decomposition clause as the per-`s`
    statement; the signal-immunity clause is recorded once globally
    against the `SignalFamily` carrier in `SignalImmunity.lean` rather
    than re-asserted here against an arbitrary `WelfareSetup`.

    paper source: Lemma `lem:conditional-reduction` part (ii). -/
theorem gap_conditional_reduction_part_ii
    {Ω : Type*} [MeasurableSpace Ω] (s : WelfareSetup Ω) :
    s.welfare = s.W_topo + s.W_info :=
  s.gap_welfare_decomposition

/-! ## 2. Lemma `lem:wrongness`

Under topology-blind, Blackwell-ordered signals on an IDP satisfying
C1-C3 with terminal-neighbour topology and `|N_R(v_0)| = 2`, the greedy
policy's welfare is non-monotone in β: there exist `β' > β` with
`W(π_{β'}) < W(π_β)`. -/

/-- **Lemma `lem:wrongness` (Wrongness of the Greedy Policy).**
    Under C1-C3, terminal-neighbour topology, `|N_R(v_0)| = 2` (encoded
    via `DegreeTwoStartingVertex`), and a Blackwell-ordered topology-
    blind signal family `{π_β}_β` (the WHOLE family is topology-blind,
    `∀ β, IsTopologyBlind (signalFamily β)`, matching the paper's
    statement scope), the greedy policy's welfare is strictly non-
    monotone in `β`.

    Two paper-faithful antecedents anchored here against earlier
    deferred discrepancies:
    (a) `DegreeTwoStartingVertex` premise — paper line 338 reads
        "Assume further that `v_0` has exactly two accessible
        neighbours (`|N_R(v_0)| = 2`)"; the prior signature dropped this
        hypothesis. `DegreeTwoStartingVertex` is a paper-novel scope
        predicate declared in `Types.lean`.
    (b) Whole-family topology-blindness `∀ β, IsTopologyBlind
        (signalFamily β)` — paper line 338 reads "topology-blind signal
        family `{π_β}_{β ≥ 0}`" (the family quantifier ranges over the
        precision parameter). The prior signature only required
        `IsTopologyBlind (signalFamily 0)`, a single-instance hypothesis
        weaker than the paper's family-level scope.

    paper source: Lemma `lem:wrongness`, lines 336-369. -/
axiom gap_wrongness_OPEN :
    Conditions_C1_C2_C3 →
    TerminalNeighbourTopology →
    DegreeTwoStartingVertex →
    ∀ (signalFamily : ℝ → PercolationOutcome → ℝ),
      (∀ β : ℝ, IsTopologyBlind (signalFamily β)) →
      IsBlackwellOrdered signalFamily →
      ∃ β β' : ℝ, β < β' ∧
        agentWelfare AgentType.greedy β' 0 1 <
          agentWelfare AgentType.greedy β 0 1

/-! ## 3. Proposition `prop:info-decay` — Informational Decay

For the within-`R` oracle under the Gaussian signal model, `W_info ≤ 0`
and `|W_info| = O(2^{-β})` as β → ∞, uniformly in `n` for `p > p_c`.
Stated before Theorem 3.2 because `gap_dilemma` invokes this axiom
in its oracle-bound clause. -/

/-- Substantive paper claim — opaque carrier required (Mathlib gap).
    The within-`R` oracle's informational residual `W_info_oracle(p, β)` —
    the actual quantity bounded in Proposition `prop:info-decay`. Encoding
    via opaque carrier rather than free existential prevents Pattern 4
    (vacuous-existential satisfaction by witness `W_info_oracle := 0`).
    paper source: Proposition `prop:info-decay`. -/
axiom W_info_oracle : ℝ → ℝ → ℝ  -- (p, β) ↦ oracle's W_info residual

/-- Cat 3 paper-novel ATOMIC structural fact: the within-`R` oracle's
    informational residual `W_info_oracle p β` is non-positive for
    `p > p_c` and `β > 0`. Paper Proposition `prop:info-decay` line
    272 states the bound is "the oracle's informational residual is
    non-positive and exponentially small"; the non-positivity clause
    isolates the sign part of the paper's joint claim.

    Encoding choice: extracted from the bundled `gap_info_decay_OPEN`
    sign sub-clause per `feedback_gap_ledger_in_lean4` §18 atomic-
    decomposition pattern. Hosted on the opaque carrier
    `W_info_oracle : ℝ → ℝ → ℝ` (R19-A); non-positivity is a paper-
    stated structural fact reflecting that information value is
    bounded by the topology-only welfare under topology-blind signals
    (paper §3 W_info ≤ 0 family).

    Cat 3 sub-type: workingAssumption (paper-stated sign fact pending
    closure from the Cat 2 Mills-tail / Cat 1 Gaussian-integration
    machinery; 必须 close before publication).

    paper source: Proposition `prop:info-decay`, lines 270-272
    ("`W_info_oracle ≤ 0`"). -/
axiom W_info_oracle_nonpos_OPEN :
    ∀ p : ℝ, harrisKestenCriticalProb < p →
      ∀ β : ℝ, 0 < β → W_info_oracle p β ≤ 0

/-- Cat 3 paper-novel ATOMIC structural fact: the within-`R` oracle's
    informational residual `|W_info_oracle p β|` is exponentially
    small in `β`, uniformly in `n`, for `p > p_c`. Paper Proposition
    `prop:info-decay` line 272 reads "`|W_info| = O(2^{-β})` as
    `β → ∞`, uniformly in `n` for `p > p_c`": the exponential bound
    sub-clause of the paper's joint claim.

    The paper proof composes two operative inputs:
    (a) the Gaussian Mills-tail bound
        `Φ(-x) ≤ (1/(x√(2π)))·exp(-x²/2)` (Cat 1, CLOSED in
        `ClassicalResults.lean` as `gap_phi_tail_bound`), giving the
        per-vertex `O(2^{-β})` welfare-loss bound; and
    (b) Grimmett 1999 _Percolation_ 2nd ed. §6.75 cluster-size
        exponential tail `Pr(|R(v_0)| ≥ k) ≤ exp(-c(p)·k)` for
        `p > p_c` (Cat 2 axiom `gap_grimmett_exponential_decay_OPEN`),
        which gives `E[|R|] = O(1)` uniformly in `n`.
    The `|W_info| = O(2^{-β}) uniform in n` claim is the
    multiplicative composition `|R| · 2^{-β}` of these two inputs.

    Encoding choice: extracted from the bundled `gap_info_decay_OPEN`
    exponential-bound sub-clause per `feedback_gap_ledger_in_lean4`
    §18 atomic-decomposition pattern. The Cat 2 dependency on Grimmett
    1999 §6.75 is threaded as an explicit antecedent `(h_grimmett :
    ...)` so that `#print axioms` on any theorem consuming this atom
    surfaces the Grimmett dependency (audit-chain visibility per
    §12 / R28-A axiom-vs-theorem-consumer clarification).

    Cat 3 sub-type: workingAssumption (paper-stated exponential bound
    on opaque carrier `W_info_oracle` pending Cat 1 Mills + Cat 2
    Grimmett composition; 必须 close before publication).

    paper source: Proposition `prop:info-decay`, lines 270-277;
    Grimmett 1999 _Percolation_ 2nd ed. §6.75 cited as the Cat 2
    cluster-size exponential-decay dependency. -/
axiom W_info_oracle_exponential_bound_OPEN :
    (∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ c : ℝ, 0 < c ∧
        ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ)))) →
    ∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ C : ℝ, 0 < C ∧
        ∀ β : ℝ, 0 < β →
          |W_info_oracle p β| ≤ C * Real.rpow 2 (-β)

/-- **Proposition `prop:info-decay`** — informational residual decays
    exponentially in β for the oracle, uniformly above the percolation
    threshold. Encoded as substantive bound on opaque carrier
    `W_info_oracle p β` (not free existential — hostile audit caught
    Pattern 4 vacuous-existential satisfaction by witness 0).

    Derived theorem composing two Cat 3 atomic stipulations per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition
    pattern (decompose bundled conclusion-axiom into atomic
    stipulations + derived theorem):
    * `W_info_oracle_nonpos_OPEN` (paper-stated non-positivity),
    * `W_info_oracle_exponential_bound_OPEN` (paper-stated `O(2^{-β})`
      exponential bound, threading Grimmett 1999 §6.75 via the
      `h_grimmett` antecedent).
    The composition is closed kernel-pure; the atomic stipulations
    are paper-stated structural facts on the opaque carrier
    `W_info_oracle` pending Cat 1 Mills-tail + Cat 2 Grimmett-
    cluster-size composition.

    The threshold antecedent `harrisKestenCriticalProb < p` consumes
    the Harris-Kesten `p_c` carrier rather than a literal `(1 : ℝ) / 2`.
    Paper Proposition `prop:info-decay` line 272 states the bound
    "uniformly in `n` for `p > p_c`"; using `harrisKestenCriticalProb`
    matches the paper's `p_c` symbol literally.

    Cat 2 dependency surfacing: the Cat 2 axiom
    `gap_grimmett_exponential_decay_OPEN` is threaded as an EXPLICIT
    ANTECEDENT `(h_grimmett : ...)` so that `#print axioms` on any
    theorem consuming `gap_info_decay` surfaces the Grimmett
    dependency.

    paper source: Proposition `prop:info-decay`, lines 270-277;
    Grimmett 1999 _Percolation_ 2nd ed. §6.75 cited as the Cat 2
    cluster-size exponential-decay dependency (paper proof line 276:
    "For `p > p_c`, `E[|R|] = O(1)` (exponential cluster-size
    tails)"). -/
theorem gap_info_decay
    (h_grimmett :
      ∀ p : ℝ, harrisKestenCriticalProb < p →
        ∃ c : ℝ, 0 < c ∧
          ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ)))) :
    ∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ C : ℝ, 0 < C ∧
        ∀ β : ℝ, 0 < β →
          W_info_oracle p β ≤ 0 ∧
          |W_info_oracle p β| ≤ C * Real.rpow 2 (-β) := by
  intros p hp
  obtain ⟨C, hC_pos, hC_bound⟩ :=
    W_info_oracle_exponential_bound_OPEN h_grimmett p hp
  refine ⟨C, hC_pos, ?_⟩
  intros β hβ
  exact ⟨W_info_oracle_nonpos_OPEN p hp β hβ, hC_bound β hβ⟩

/-! ## 4. Theorem 3.2 — `thm:dilemma`

Under C1-C3 + topology-blind signals + terminal-neighbour topology +
degree-2 starting vertex, the greedy agent's welfare is non-monotone in
β. For the within-`R` oracle, Blackwell monotonicity holds conditionally
on each fixed `R`, but `|W_info| = O(2^{-β})` is exponentially small
relative to `|W_topo| = Θ(1)` for `p > p_c`. -/

/-- **Theorem 3.2** (`thm:dilemma`, Welfare Non-Monotonicity Under
    Endogenous Feasibility). Conjunction of both clauses the paper
    states under `\label{thm:dilemma}`:
    * **Greedy-reversal clause:** under C1-C3, terminal-neighbour
      topology, degree-2 starting vertex, and Blackwell-ordered
      topology-blind signals, there exist `β < β'` with the greedy
      agent's welfare strictly decreasing — direct invocation of
      `gap_wrongness_OPEN`.
    * **Oracle-bound clause:** above the percolation threshold,
      the within-`R` oracle's informational residual is non-positive
      and exponentially small in `β`: `|W_info_oracle| = O(2^{-β})` —
      direct invocation of derived theorem `gap_info_decay` (which
      composes Cat 3 atoms `W_info_oracle_nonpos_OPEN` and
      `W_info_oracle_exponential_bound_OPEN`).

    Both clauses are CLOSED-via-OPEN-input.

    Cat 2 dependency on Grimmett 1999 §6.75 cluster-size exponential
    decay surfaces explicitly through `gap_info_decay`'s axiom
    chain: the Cat 2 axiom `gap_grimmett_exponential_decay_OPEN`
    (declared in `ClassicalResults.lean`) is composed inside this
    theorem's proof body to discharge `gap_info_decay`'s
    Grimmett antecedent. Because `gap_dilemma` is a THEOREM (not an
    axiom), the proof body composition is sufficient for `#print
    axioms gap_dilemma` to surface `gap_grimmett_exponential_decay_OPEN`
    in the audit chain (per the R28 axiom-vs-theorem-consumer
    clarification of the broken-link discipline).

    Two paper-faithful antecedents are propagated downstream from
    `gap_wrongness_OPEN` (the clause-1 input):
    (a) `hDeg2 : DegreeTwoStartingVertex` — paper `\label{thm:dilemma}`
        line 388 reads "with `v_0` of degree `2` in `N_R(v_0)`",
        matching Lemma `lem:wrongness`'s `|N_R(v_0)| = 2` premise.
    (b) `hBlind : ∀ β, IsTopologyBlind (signalFamily β)` — paper line
        388 reads "with topology-blind signals" (whole signal family),
        matching Lemma `lem:wrongness`'s `{π_β}_β` family-level scope.
    Clause 2's threshold antecedent `harrisKestenCriticalProb < p`
    matches `gap_info_decay`'s threshold antecedent and the
    paper's `p > p_c` formulation (line 388: "for `p > p_c`").

    paper source: Theorem `\label{thm:dilemma}` (statement and proof
    `Direct application of Lemma \ref{lem:wrongness}` for clause 1,
    `By Proposition \ref{prop:info-decay}` for clause 2);
    Grimmett 1999 _Percolation_ 2nd ed. §6.75 cited as the Cat 2
    cluster-size exponential-decay dependency for the oracle-bound
    clause. -/
theorem gap_dilemma
    (hC : Conditions_C1_C2_C3)
    (hT : TerminalNeighbourTopology)
    (hDeg2 : DegreeTwoStartingVertex)
    (signalFamily : ℝ → PercolationOutcome → ℝ)
    (hBlind : ∀ β : ℝ, IsTopologyBlind (signalFamily β))
    (hBO : IsBlackwellOrdered signalFamily) :
    (∃ β β' : ℝ, β < β' ∧
        agentWelfare AgentType.greedy β' 0 1 <
          agentWelfare AgentType.greedy β 0 1) ∧
      (∀ p : ℝ, harrisKestenCriticalProb < p →
        ∃ C : ℝ, 0 < C ∧
          ∀ β : ℝ, 0 < β →
            W_info_oracle p β ≤ 0 ∧
            |W_info_oracle p β| ≤ C * Real.rpow 2 (-β)) :=
  ⟨gap_wrongness_OPEN hC hT hDeg2 signalFamily hBlind hBO,
   gap_info_decay gap_grimmett_exponential_decay_OPEN⟩

/-! ## 5. Proposition `prop:topo-cluster` — Topological-Loss/Cluster-Size
   Relation

`E[|W_topo| | |R(v_0)| = k] = (n - k) / ((n+1)(k+1))`. Below threshold
(`p < p_c`): `E[|W_topo|] = O(1/n) → 0`. Above threshold (`p > p_c`):
`E[|W_topo|] ≈ 1/(k+1) = Θ(1)`. -/

/-- Substantive paper claim — opaque carrier required (Mathlib gap).
    Conditional expected topological loss
    `E[|W_topo| | |R(v_0)| = k]` on the lattice with `n` total
    vertices.

    paper source: Proposition `prop:topo-cluster`, lines 279-297. -/
axiom expectedTopoLoss_conditional : ℕ → ℕ → ℝ

/-- Cat 3 paper-novel ATOMIC structural equation: paper Proposition
    `prop:topo-cluster` proof line 292-294 derives the conditional
    expected topological loss as the difference of two order-statistics
    expectations:
    `E[|W_topo| | |R(v_0)| = k] = E[max_{V} r] − E[max_{R} r | |R| = k]
                                = n/(n+1) − k/(k+1)`,
    using `E[max k iid Uniform[0,1]] = k/(k+1)` (David & Nagaraja 2003,
    Eq. 2.1.4). The closed-form simplification
    `n/(n+1) − k/(k+1) = (n−k)/((n+1)(k+1))` is encoded by
    `gap_topo_cluster_relation_OPEN` (which now derives algebraically
    from this atom).

    Encoding choice: this Cat 3 atomic structural equation isolates the
    order-statistics-based decomposition step (paper line 292,
    pre-algebraic-simplification) as a paper-stated structural fact on
    the existing carrier `expectedTopoLoss_conditional`. The closed-form
    `(n−k)/((n+1)(k+1))` simplification is a downstream Cat 1 algebraic
    derivation. Hypothesis `1 ≤ k ∧ k ≤ n` matches the paper's
    "1 ≤ |R(v_0)| ≤ n" range (a vertex is reachable from itself, and
    the reachable set is a subset of the vertex set).

    Cat 2 chain — David & Nagaraja 2003 Eq. 2.1.4 (Lebesgue order
    statistics on iid `Uniform[0, 1]`): `expectedMaxUniform k = k/(k+1)`
    is encoded in `ClassicalResults.lean` via the def-rfl pattern
    (`gap_order_statistics_max`). The Cat 2 dependency is acknowledged
    in this docstring; the substantive Lebesgue identity remains a
    Mathlib gap (the def-rfl encoding pins the value but does not
    derive it from product-uniform-measure machinery).

    paper source: Proposition `prop:topo-cluster`, line 292
    (`E[|W_topo| | |R| = k] = n/(n+1) − k/(k+1)`); David & Nagaraja
    2003 Eq. 2.1.4 cited for the order-statistics input. -/
axiom expectedTopoLoss_conditional_def :
    ∀ n k : ℕ, 1 ≤ k → k ≤ n →
      expectedTopoLoss_conditional n k =
        (n : ℝ) / (n + 1) - (k : ℝ) / (k + 1)

/-- **Proposition `prop:topo-cluster`.** Closed-form expectation of the
    topological loss conditional on `|R(v_0)| = k`:
    `E[|W_topo| | |R(v_0)| = k] = (n − k) / ((n+1)(k+1))`.

    The substantive equality is encoded via the opaque carrier
    `expectedTopoLoss_conditional` rather than by tautological
    existential bookkeeping (per `feedback_lean_real_math` "real math,
    not closure-count tricks"). The paper's derivation uses the
    order-statistics identity `E[max k iid Uniform[0,1]] = k/(k+1)`
    (David & Nagaraja 2003, _Order Statistics_, 3rd ed., Eq. 2.1.4,
    Wiley, ISBN 0-471-38926-9), which remains a Mathlib gap.
    `gap_order_statistics_max` (in `ClassicalResults.lean`) records the
    def-rfl encoding of that formula but is NOT consumed in this
    axiom's signature; the Cat 2 dependency on David & Nagaraja
    2003 §2.1.4 is therefore disclosed at the docstring level only —
    a Cat 2 ↔ Cat 3 disconnect that would normally require explicit
    Lean-level threading per the broken-link discipline. The disconnect
    is honestly retained here because the order-statistics statement
    requires Mathlib product-measure infrastructure not yet packaged
    (so a typed Lean dependency on a meaningfully-quantified Cat 2
    predicate is not currently available); the opaque-carrier
    encoding via `expectedTopoLoss_conditional` already declares the
    Mathlib gap at the substantive-equality level.

    paper source: Proposition `prop:topo-cluster`, lines 279-297;
    David & Nagaraja 2003 Eq. 2.1.4 cited as the Cat 2
    order-statistics dependency.

    Refactored: closed-form simplification step derives Cat 1 from
    the order-statistics-based atomic structural equation
    `expectedTopoLoss_conditional_def` (`= n/(n+1) − k/(k+1)`) via
    direct algebraic identity
    `n/(n+1) − k/(k+1) = (n−k)/((n+1)(k+1))` over `ℝ`. -/
theorem gap_topo_cluster_relation :
    ∀ n k : ℕ, 1 ≤ k → k ≤ n →
      expectedTopoLoss_conditional n k = ((n : ℝ) - k) / ((n + 1) * (k + 1)) := by
  intros n k hk_lo hk_hi
  rw [expectedTopoLoss_conditional_def n k hk_lo hk_hi]
  -- Algebraic identity: n/(n+1) − k/(k+1) = (n−k)/((n+1)(k+1))
  have h_n1_pos : (0 : ℝ) < (n : ℝ) + 1 := by
    have : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
    linarith
  have h_k1_pos : (0 : ℝ) < (k : ℝ) + 1 := by
    have : (0 : ℝ) ≤ (k : ℝ) := Nat.cast_nonneg k
    linarith
  have h_n1_ne : ((n : ℝ) + 1) ≠ 0 := ne_of_gt h_n1_pos
  have h_k1_ne : ((k : ℝ) + 1) ≠ 0 := ne_of_gt h_k1_pos
  field_simp
  ring

/-- Substantive paper claim — opaque carrier required (Mathlib gap).
    Expected topological loss `E[|W_topo|]` on `Z²_L` with `L² = n`
    vertices at blocking parameter `p`. -/
axiom expectedTopoLoss : ℕ → ℝ → ℝ

/-- Substantive paper claim — opaque carrier required (Mathlib gap).
    **Topological loss vanishes below threshold** (Part 1 of `prop:topo-cluster`).

    For `p < 1/2`, `expectedTopoLoss n p = Θ(1/n) → 0` as `n → ∞`.

    Cat 3 paper-novel claim — accepted on Paper Thm 3.3 (paper-novel
    asymptotic on the paper's Cat 3 carrier `expectedTopoLoss`). The
    asymptotic uses the paper's Z²-percolation primitive
    `expectedTopoLoss` (Cat 3 paper-novel carrier) with the Cat 2
    cluster-size convergence-to-0 result from Grimmett 1999
    _Percolation_ 2nd ed. (Springer); Mathlib lacks formalized
    bond-percolation theory (same gap as `gap_harris_kesten_OPEN`), so
    the Lean encoding axiomatizes the paper-stated below-threshold
    asymptotic on the paper-novel carrier.

    Cat 2 dependency surfacing (R28-A restoration): the Cat 2
    Grimmett-percolation-probability axiom
    `gap_percolation_probability_OPEN` is threaded as an EXPLICIT
    ANTECEDENT `(h_perc_prob : ...)` so that `#print axioms` on any
    theorem consuming `gap_topo_loss_below_threshold_OPEN` surfaces
    the Grimmett dependency. The R26 drop of this antecedent was
    correct for downstream THEOREMS but WRONG for downstream AXIOMS
    (axioms have no body and cannot make the Cat 2 dependency visible
    to the kernel via direct call). R28 reclassifies this entry as
    paper-novel Cat 3 (was Cat 2 / Cat 3 edge case in R26) since the
    asymptotic on the paper-novel `expectedTopoLoss` carrier is
    paper-novel content; the Cat 2 dependency on Grimmett is the
    underlying percolation-infra input.

    paper source: Proposition `prop:topo-cluster`, line 286;
    Grimmett 1999 _Percolation_ 2nd ed. cited for the Z²-percolation
    cluster-size below-threshold infrastructure. -/
axiom gap_topo_loss_below_threshold_OPEN :
    (∃ θ : ℝ → ℝ,
      (∀ p : ℝ, p < harrisKestenCriticalProb → 0 < θ (1 - p)) ∧
      (∀ p : ℝ, harrisKestenCriticalProb ≤ p → θ (1 - p) = 0)) →
    ∀ p : ℝ, 0 ≤ p → p < harrisKestenCriticalProb →
      ∀ ε : ℝ, 0 < ε →
        ∃ N : ℕ, ∀ n, N ≤ n → expectedTopoLoss n p < ε

/-- Substantive paper claim — opaque carrier required (Mathlib gap).
    **Topological loss is `Θ(1)` above threshold** (Part 2 of
    `prop:topo-cluster`).

    For `p > 1/2`, `expectedTopoLoss n p = 1 − Θ(1/n) = Θ(1)`.

    Cat 3 paper-novel claim — accepted on Paper Thm 3.3 (paper-novel
    asymptotic on the paper's Cat 3 carrier `expectedTopoLoss`). The
    two-sided bound uses the paper's Z²-percolation primitive
    `expectedTopoLoss` (Cat 3 paper-novel carrier) with the Cat 2
    above-threshold cluster-size theory from Grimmett 1999
    _Percolation_ 2nd ed. §6.75 (Springer); Mathlib lacks formalized
    bond-percolation theory (same gap as `gap_harris_kesten_OPEN`), so
    the Lean encoding axiomatizes the paper-stated above-threshold
    asymptotic on the paper-novel carrier.

    Cat 2 dependency surfacing (R28-A restoration): the Cat 2
    Grimmett-exponential-decay axiom `gap_grimmett_exponential_decay_OPEN`
    is threaded as an EXPLICIT ANTECEDENT `(h_grimmett : ...)` so that
    `#print axioms` on any theorem consuming
    `gap_topo_loss_above_threshold_OPEN` surfaces the Grimmett
    dependency. The R26 drop of this antecedent was correct for
    downstream THEOREMS but WRONG for downstream AXIOMS (axioms have
    no body and cannot make the Cat 2 dependency visible to the kernel
    via direct call). R28 reclassifies this entry as paper-novel Cat 3
    (was Cat 2 / Cat 3 edge case in R26).

    paper source: Proposition `prop:topo-cluster`, line 287;
    Grimmett 1999 _Percolation_ 2nd ed. §6.75 cited for the Z²-
    percolation cluster-size above-threshold infrastructure. -/
axiom gap_topo_loss_above_threshold_OPEN :
    (∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ c : ℝ, 0 < c ∧
        ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ)))) →
    ∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ c₁ c₂ : ℝ, 0 < c₁ ∧ c₁ ≤ c₂ ∧
        ∃ N : ℕ, ∀ n : ℕ, N ≤ n →
          c₁ ≤ expectedTopoLoss n p ∧ expectedTopoLoss n p ≤ c₂

end BlackwellDilemma
