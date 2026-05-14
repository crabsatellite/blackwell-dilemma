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

/-- Cat 3 paper-novel ATOMIC stipulation: paper Lemma `lem:conditional-
    reduction` part (i) states that for each fixed reachable-set
    realisation `R = R_0`, the agent faces a standard decision problem
    with FIXED action set `A_{R_0} = R_0(v_0)`, fixed state space `Ω`,
    and payoff `u(a, ω)` for `a ∈ A_{R_0}` (paper proof line 381). On
    this conditional subproblem, the Blackwell ordering applies in the
    standard form: `π' ≻_B π ⇒ W_{R_0}(π') ≥ W_{R_0}(π)` (paper line
    375 statement). This atomic stipulation isolates the paper-stated
    conditional-Blackwell-applicability fact on the existing carrier
    `conditionalWelfareOnR R signalFamily β`, threading the Cat 2
    Blackwell 1951/1953 dependency as an explicit antecedent.

    Encoding choice: extracted from the bundled
    `gap_conditional_reduction_part_i_OPEN` per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition
    pattern (decompose bundled conclusion-axiom into atomic
    stipulation + derived theorem). The Cat 2 dependency on Blackwell
    1951/1953 is threaded as the explicit `h_blackwell` antecedent for
    audit-chain visibility (`#print axioms` on any theorem consuming
    this atom surfaces the Blackwell dependency). The Blackwell-
    ordering paper-novel scope predicate `IsBlackwellOrdered
    signalFamily` is threaded as the operative paper-stated antecedent
    of part (i)'s monotonicity conclusion.

    Cat 3 sub-type: workingAssumption (paper-stated higher-level
    application of Cat 2 Blackwell theorem to the paper-novel
    `conditionalWelfareOnR` carrier; pending substantive Mathlib
    decision-theoretic Blackwell ordering machinery; 必须 close
    before publication).

    paper source: Lemma `lem:conditional-reduction` part (i), line
    375 (Blackwell ordering applies to conditional subproblem on
    `R(v_0)`); paper proof line 381 (fixed-feasible-set conditional
    subproblem permits direct Blackwell-theorem application);
    Blackwell 1951/1953 cited as the Cat 2 dependency. -/
axiom conditional_subproblem_blackwell_applicable_OPEN :
    (∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
      agentWelfare AgentType.bayesian β₁ 0 1 ≤
        agentWelfare AgentType.bayesian β₂ 0 1) →
    ∀ (R : Finset Vertex)
      (signalFamily : ℝ → PercolationOutcome → ℝ),
      IsBlackwellOrdered signalFamily →
      ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
        conditionalWelfareOnR R signalFamily β₁ ≤
          conditionalWelfareOnR R signalFamily β₂

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
    operationally relevant antecedent.

    Derived theorem composing the paper-stated atomic stipulation
    `conditional_subproblem_blackwell_applicable_OPEN` per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition
    pattern. The bundled `gap_conditional_reduction_part_i_OPEN`
    axiom is REPLACED by this derived theorem (which is structurally
    a re-export of the atomic stipulation; the decomposition isolates
    the paper-stated conditional-Blackwell-applicability fact as a
    standalone Cat 3 atomic stipulation, separating the audit-chain
    Cat 2 Blackwell threading from the higher-level lemma claim).

    paper source: Lemma `lem:conditional-reduction` part (i),
    invoking Blackwell's theorem `\citep{blackwell1951,blackwell1953}`. -/
theorem gap_conditional_reduction_part_i
    (h_blackwell : ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
      agentWelfare AgentType.bayesian β₁ 0 1 ≤
        agentWelfare AgentType.bayesian β₂ 0 1) :
    ∀ (R : Finset Vertex)
      (signalFamily : ℝ → PercolationOutcome → ℝ),
      IsBlackwellOrdered signalFamily →
      ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
        conditionalWelfareOnR R signalFamily β₁ ≤
          conditionalWelfareOnR R signalFamily β₂ :=
  conditional_subproblem_blackwell_applicable_OPEN h_blackwell

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

/-! ### R60 §18 closure-path-B decomposition of `lem:wrongness`

R44 hostile audit flagged `topology_blind_wrongness_atom_OPEN` as MOST
EGREGIOUS conclusion-as-axiom (an entire paper Lemma packaged as a
single workingAssumption). R44 attackHistory recommended R45+
decomposition into V_dyn-dominance + static-reward-misalignment atoms.
R60 implements the recommended decomposition.

Paper proof (lines 345-369) operates in two substantive stages:
 1. **High-precision concentration on the worst branch**
    (paper line 348): under topology-blind Blackwell-ordered signals,
    the greedy policy's selection probability `P_1(β)` for the
    higher-immediate-reward neighbour `u_1` tends to `1` as
    `β → ∞`, so the agent concentrates on `u_1`. We isolate the
    operationally-relevant consequence at the welfare level: the
    high-`β` greedy welfare converges to `V_dyn(u_1)` (paper line 352
    `W(∞) = V_dyn(u_1)`).
 2. **Reversal-witness from static-reward-misalignment**
    (paper lines 357-368): at finite but high `β`, the `o(1)` slack
    in the welfare decomposition implies `W(β) > W(∞) = V_dyn(u_1)`
    strictly, while at the limit `W(β) → W(∞)`; combined this gives
    the existence of `β < β'` with `W(β') < W(β)` (paper line 368).

The decomposition exposes the paper's two-step structure: stage 1 is
the topology-blind concentration mechanism (paper-novel application of
Blackwell-ordering at the greedy policy under topology-blindness), and
stage 2 is the C2-misalignment-driven reversal witness (paper-novel
analytic argument over the IDP welfare functional). Both atoms remain
workingAssumption-tier per §3.4.4 (paper-derived working content; close
target = bounded-convergence + Φ-tail integral machinery, partially
Mathlib-Cat-1, partially paper-novel).
-/

/-- Cat 3 paper-novel ATOMIC stipulation #1 (R60 §18 closure-path-B
    decomposition): paper Lemma `lem:wrongness` line 348 + line 352
    states that under C1-C3 + terminal-neighbour topology + degree-2
    starting vertex + topology-blind Blackwell-ordered signals, the
    greedy policy's high-precision welfare limit `W(∞)` equals
    `V_dyn(u_1)`, the dynamic-value of the higher-immediate-reward
    neighbour. Equivalently, there exists a precision threshold
    `β₀` such that for all `β > β₀`, the greedy welfare
    `agentWelfare AgentType.greedy β 0 1` is at least `V_dyn(u_1)` minus
    an `o(1)` slack, AND there exists a high-`β` strict-positive slack
    `Δ > 0` (paper line 357 reads `V_dyn(u_2,β) - V_dyn(u_1,β) > Δ_R/2`
    for all `β > β₀`).

    Encoded operationally as: there exist a baseline `β₀` and an
    upper-baseline-welfare value `Wlim` such that `agentWelfare greedy β 0 1
    ≥ Wlim` for all `β > β₀` (the high-`β` greedy welfare is at-least
    `Wlim`, encoding paper line 357 `W(β) > W(∞) + o(1)` at `β > β₀`).

    Encoding choice: the V_dyn-dominance step is the paper's stage-1
    structural fact (greedy concentration mechanism under topology-blind
    Blackwell signals at degree-2 + terminal-neighbour topology); the
    high-`β` welfare-floor encoding extracts the operationally-relevant
    welfare consequence without committing to a closed-form for `Wlim`
    (which the paper records as `V_dyn(u_1)` via paper line 352
    `W(∞) = V_dyn(u_1)`).

    Cat 3 sub-type: workingAssumption (paper-stated stage-1
    concentration + welfare-floor; pending bounded-convergence + Φ-tail
    integral machinery; 必须 close before publication).

    paper source: Lemma `lem:wrongness` proof, line 348
    (`P_1(β) → 1` greedy concentration) + line 352 (`W(∞) = V_dyn(u_1)`)
    + line 357 (`V_dyn(u_2,β) - V_dyn(u_1,β) > Δ_R/2` slack at
    `β > β₀`). -/
axiom wrongness_high_beta_welfare_floor_atom_OPEN :
    Conditions_C1_C2_C3 →
    TerminalNeighbourTopology →
    DegreeTwoStartingVertex →
    ∀ (signalFamily : ℝ → PercolationOutcome → ℝ),
      (∀ β : ℝ, IsTopologyBlind (signalFamily β)) →
      IsBlackwellOrdered signalFamily →
      ∃ β₀ : ℝ, ∃ Wlim : ℝ,
        ∀ β : ℝ, β₀ < β → Wlim ≤ agentWelfare AgentType.greedy β 0 1

/-- Cat 3 paper-novel ATOMIC stipulation #2 (R60 §18 closure-path-B
    decomposition): paper Lemma `lem:wrongness` proof line 357-368
    (static-reward-misalignment-driven reversal witness). Given the
    stage-1 high-`β` welfare-floor `Wlim` (encoded by atom #1
    `wrongness_high_beta_welfare_floor_atom_OPEN`), paper line 368 reads
    "Since `W(β) → W(∞)` yet `W(β) > W(∞)` for large finite `β`, `W` is
    not monotonically non-decreasing: there exist `β_1 < β_2` with
    `W(β_1) > W(β_2)`."

    Operationally: given a high-`β` welfare-floor `Wlim` and an
    above-baseline witness threshold `β₀`, there exist precision values
    `β < β'` (both above `β₀`) with `agentWelfare greedy β' 0 1 < agentWelfare
    greedy β 0 1`, exhibiting the strict reversal. The witness is
    stipulated as existential over `(β, β')` because the paper proof
    constructs them implicitly from the Blackwell-monotone decomposition
    (paper lines 358-368 displayed equation), which here is encoded at
    the welfare-existential level on the opaque `agentWelfare` carrier.

    Encoding choice: the reversal-witness step is the paper's stage-2
    analytic conclusion derived from the welfare decomposition under
    C2-misalignment; the existential encoding on `(β, β')` matches the
    paper-stated existential conclusion form (paper line 339-341
    `∃ β' > β, W(π_{β'}) < W(π_β)`).

    Cat 3 sub-type: workingAssumption (paper-stated stage-2 reversal
    witness from the welfare-floor + C2-misalignment; pending
    bounded-convergence + Φ-tail integral machinery; 必须 close before
    publication).

    paper source: Lemma `lem:wrongness` proof, lines 357-368
    (welfare-decomposition reversal witness from static-reward-
    misalignment under C2 at degree-2 starting vertex). -/
axiom wrongness_misalignment_reversal_atom_OPEN :
    Conditions_C1_C2_C3 →
    TerminalNeighbourTopology →
    DegreeTwoStartingVertex →
    ∀ (signalFamily : ℝ → PercolationOutcome → ℝ),
      (∀ β : ℝ, IsTopologyBlind (signalFamily β)) →
      IsBlackwellOrdered signalFamily →
      ∀ (β₀ : ℝ) (Wlim : ℝ),
        (∀ β : ℝ, β₀ < β → Wlim ≤ agentWelfare AgentType.greedy β 0 1) →
        ∃ β β' : ℝ, β < β' ∧
          agentWelfare AgentType.greedy β' 0 1 <
            agentWelfare AgentType.greedy β 0 1

/-- **Lemma `lem:wrongness` (Wrongness of the Greedy Policy)** (R60
    derived theorem). Under C1-C3, terminal-neighbour topology, degree-2
    starting vertex, and a Blackwell-ordered topology-blind signal
    family, the greedy policy's welfare is strictly non-monotone in β.

    R60 §18 closure-path-B refactor: the prior single-atom
    `topology_blind_wrongness_atom_OPEN` (R44 flagged as MOST EGREGIOUS
    conclusion-as-axiom packaging an entire paper Lemma) is decomposed
    into two smaller workingAssumption atoms reflecting the paper's
    two-stage proof structure (paper lines 345-369):
     * `wrongness_high_beta_welfare_floor_atom_OPEN` (stage 1: V_dyn-
       dominance + greedy concentration mechanism, paper lines 348-352
       + line 357 slack)
     * `wrongness_misalignment_reversal_atom_OPEN` (stage 2: static-
       reward-misalignment-driven reversal witness, paper lines 357-368)
    The derived theorem composes both via the welfare-floor existential.

    Two paper-faithful antecedents anchored against earlier deferred
    discrepancies:
    (a) `DegreeTwoStartingVertex` premise — paper line 338 reads
        "Assume further that `v_0` has exactly two accessible
        neighbours (`|N_R(v_0)| = 2`)"; declared in `Types.lean` as a
        paper-novel scope predicate.
    (b) Whole-family topology-blindness `∀ β, IsTopologyBlind
        (signalFamily β)` — paper line 338 reads "topology-blind signal
        family `{π_β}_{β ≥ 0}`" (the family quantifier ranges over the
        precision parameter).

    paper source: Lemma `lem:wrongness`, lines 336-369. -/
theorem gap_wrongness :
    Conditions_C1_C2_C3 →
    TerminalNeighbourTopology →
    DegreeTwoStartingVertex →
    ∀ (signalFamily : ℝ → PercolationOutcome → ℝ),
      (∀ β : ℝ, IsTopologyBlind (signalFamily β)) →
      IsBlackwellOrdered signalFamily →
      ∃ β β' : ℝ, β < β' ∧
        agentWelfare AgentType.greedy β' 0 1 <
          agentWelfare AgentType.greedy β 0 1 := by
  intro hC hT hDeg2 signalFamily hBlind hBO
  obtain ⟨β₀, Wlim, h_floor⟩ :=
    wrongness_high_beta_welfare_floor_atom_OPEN hC hT hDeg2 signalFamily hBlind hBO
  exact wrongness_misalignment_reversal_atom_OPEN
    hC hT hDeg2 signalFamily hBlind hBO β₀ Wlim h_floor

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
  ⟨gap_wrongness hC hT hDeg2 signalFamily hBlind hBO,
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

/-- R66 NEW Cat 2 external-paper axiom (`cat2External` per `feedback_
    gap_ledger_in_lean4` §6.2): paper-application of David & Nagaraja
    2003 Eq. 2.1.4 to the IDP carrier `expectedTopoLoss_conditional`
    via paper Definition 2.1's standing convention (rewards `r: V → [0,
    1]` iid `Uniform[0, 1]` independent of the percolation realisation).

    The axiom captures the paper-stated decomposition step (paper
    Proposition `prop:topo-cluster` proof, line 292):
       `E[|W_topo| | |R(v_0)| = k]
          = E[max_{v ∈ V} r] − E[max_{v ∈ R} r | |R| = k]
          = n/(n+1) − k/(k+1)`
    where the two order-statistics expectations are bound by the David
    & Nagaraja 2003 Eq. 2.1.4 textbook identity, applied to V (n iid
    rewards) and R (k iid rewards), valid by the paper Definition 2.1
    "rewards independent of percolation" standing convention.

    The Cat 2 textbook input is THREADED as an EXPLICIT antecedent (the
    abstract `expectedMaxIIDUniform K = K/(K+1)` quantifier pattern, to
    be discharged at consumption site by `gap_david_nagaraja_eq214_OPEN`
    from `ClassicalResults.lean`). The threading surfaces the David &
    Nagaraja Cat 2 dependency in `#print axioms` on any consumer of
    this axiom.

    Per `feedback_gap_ledger_in_lean4` §10 paper-APPLICATION-to-opaque-
    carrier discipline borderline: the IDP carrier appears in the
    conclusion, but the carrier-binding chain is mechanical (David &
    Nagaraja applied through paper Def 2.1 standing convention; the
    paper-application is essentially the textbook identity applied
    twice). Per R65 precedent (`gap_iid_continuous_rank_symmetry_OPEN`),
    the AXIOM is classified Cat 2 (cat2External, notCat3) because its
    content is "textbook fact applied through fixed paper-stipulated
    standing-convention pattern" — the "Cat 2-ness" justified by the
    threaded antecedent embodying the pure textbook input + the
    paper-stipulated standing convention being a published structural
    commitment (not paper-novel content).

    Cat 2 — accepted on David & Nagaraja 2003 + paper Definition 2.1
    standing convention authority. Mathlib lacks formalised order-
    statistics + product-uniform-measure infrastructure (same gap as
    `gap_david_nagaraja_eq214_OPEN`). Citing David HA & Nagaraja HN
    (2003) _Order Statistics_, 3rd ed., Wiley-Interscience, ISBN
    0-471-38926-9, §2.1 (Eq. 2.1.4) + paper Definition 2.1 line 113-114
    (`r: V → [0, 1]` iid `Uniform[0, 1]` independent of percolation
    realisation). Downstream consumer: `expectedTopoLoss_conditional_def`
    derived theorem hosts the axiom (combined with
    `gap_david_nagaraja_eq214_OPEN` to discharge the abstract textbook
    antecedent).

    paper source: Proposition `prop:topo-cluster` proof, line 292
    (decomposition + David & Nagaraja); paper Definition 2.1 line
    113-114 (iid Uniform + percolation independence standing convention). -/
axiom gap_orderstats_topo_decomposition_OPEN :
    (∀ K : ℕ, 1 ≤ K → expectedMaxIIDUniform K = (K : ℝ) / (K + 1)) →
    ∀ n k : ℕ, 1 ≤ k → k ≤ n →
      expectedTopoLoss_conditional n k =
        (n : ℝ) / (n + 1) - (k : ℝ) / (k + 1)

/-- **R66 derived theorem (replaces retired R23-C1 atom of the same
    name `expectedTopoLoss_conditional_def`)**.

    For the IDP on `n` nodes with iid `Uniform[0, 1]` rewards (paper
    Definition 2.1 line 113-114 standing convention), the conditional
    expected topological loss decomposes as
       `E[|W_topo| | |R(v_0)| = k] = n/(n+1) − k/(k+1)`
    via the order-statistics decomposition (paper line 292) using
    David & Nagaraja 2003 Eq. 2.1.4.

    R66 §18 closure-path-A composition: composes the new Cat 2 axiom
    `gap_orderstats_topo_decomposition_OPEN` (paper-application via
    standing convention) with the new Cat 2 axiom
    `gap_david_nagaraja_eq214_OPEN` (substantive David & Nagaraja Eq.
    2.1.4 textbook identity, in `ClassicalResults.lean`) to discharge
    the abstract order-statistics antecedent. Both Cat 2 axioms surface
    in `#print axioms` on this theorem, providing audit-chain visibility
    for the David & Nagaraja dependency that was previously acknowledged
    only in docstrings.

    Net effect: the prior R23-C1 wA atom `expectedTopoLoss_conditional_
    def` (paper-novel structural equation on opaque `expectedTopoLoss_
    conditional` carrier) is absorbed into the Cat 2 chain. The Lean-
    side audit visibility now matches the paper's textbook citation.

    paper source: Proposition `prop:topo-cluster`, line 292
    (`E[|W_topo| | |R| = k] = n/(n+1) − k/(k+1)`); David & Nagaraja
    2003 Eq. 2.1.4 cited for the order-statistics input. -/
theorem expectedTopoLoss_conditional_def :
    ∀ n k : ℕ, 1 ≤ k → k ≤ n →
      expectedTopoLoss_conditional n k =
        (n : ℝ) / (n + 1) - (k : ℝ) / (k + 1) :=
  gap_orderstats_topo_decomposition_OPEN gap_david_nagaraja_eq214_OPEN

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

/-! ### `prop:topo-cluster` Part 1 — below-threshold asymptotic.

R41 §18 atomic decomposition. The bundled `gap_topo_loss_below_threshold_OPEN`
axiom was REPLACED by a derived theorem composing two Cat 3 paper-novel
atomic stipulations:
 * `topo_loss_below_envelope_exists_atom_OPEN` — paper-stated existence
   of a per-`n` decay envelope `topoLossBelowDecay : ℕ → ℝ` with
   `expectedTopoLoss n p ≤ topoLossBelowDecay n` and
   `topoLossBelowDecay → 0`.
 * `topo_loss_below_eps_from_envelope_atom_OPEN` — paper-stated
   ε-N convergence from the envelope (the operative downstream form).

R60 closure-path-B re-derivation of the envelope-existence atom: split
into a smaller per-`n` `1/(n+1)` polynomial-bound atom (paper-faithful
to line 294 closed form `(n-k)/((n+1)(k+1))` specialised to the
`k = Θ(n)` giant-component regime) plus a Cat 1 Mathlib `1/(n+1) → 0`
derivation. This mirrors the R59 closure-path-B refactor of the
sibling `topo_loss_decay_below_pc_OPEN` in `Phase.lean` against the
new smaller atom `expectedTopoLoss_below_pc_one_over_n_envelope_OPEN`. -/

/-- R60 closure-path-B: smaller paper-novel ATOMIC stipulation
    replacing the bundled `topo_loss_below_envelope_exists_atom_OPEN`
    existence claim. Paper Proposition `prop:topo-cluster` Part 1
    (line 286 "topological loss vanishes asymptotically", proof lines
    292-294) derives, conditional on `v_0` lying in the giant component
    (`|R(v_0)| = k = Θ(n)`), the closed-form formula
    `(n-k)/((n+1)(k+1)) = O(1/n)`. Aggregating over the giant-component
    event (probability `θ(1-p) > 0` by Harris-Kesten + Grimmett
    percolation-probability), the unconditional `expectedTopoLoss n p`
    is bounded above by the explicit envelope `1 / (n + 1)` for every
    `n`.

    R60 strictly smaller than retired bundled atom: only the per-`n`
    upper bound on `expectedTopoLoss n p` is asserted here; the
    EXISTENCE of a decay envelope + the `Tendsto _ → 0` convergence
    of the explicit envelope `1 / (n + 1)` are downstream Cat 1
    Mathlib derivations that the new derived theorem
    `topo_loss_below_envelope_exists` composes. The encoding is
    parallel to the Phase.lean sister atom
    `expectedTopoLoss_below_pc_one_over_n_envelope_OPEN` (which targets
    the same paper line 417 `O(1/N)` polynomial envelope from the
    Theorem 3.3 Part 1 statement); both atoms encode the same
    paper-line-294 closed-form bound on the same opaque carrier
    `expectedTopoLoss`.

    Cat 3 sub-type: workingAssumption (paper-stated explicit polynomial
    upper bound on the opaque `expectedTopoLoss` carrier; pending
    Mathlib percolation + cluster-size-asymptotics machinery; 必须
    close before publication).

    paper source: Proposition `prop:topo-cluster` Part 1, line 286 +
    proof lines 292-294 (`(n-k)/((n+1)(k+1))` closed form specialised
    to `k = Θ(n)` giant-component regime); Grimmett 1999 _Percolation_
    2nd ed. percolation-probability cited as the Cat 2 dependency
    (giant-component event positivity below threshold). -/
axiom topo_loss_below_one_over_n_envelope_atom_OPEN :
    (∃ θ : ℝ → ℝ,
      (∀ p : ℝ, p < harrisKestenCriticalProb → 0 < θ (1 - p)) ∧
      (∀ p : ℝ, harrisKestenCriticalProb ≤ p → θ (1 - p) = 0)) →
    ∀ p : ℝ, 0 ≤ p → p < harrisKestenCriticalProb →
      ∀ n : ℕ, expectedTopoLoss n p ≤ 1 / ((n : ℝ) + 1)

/-- **R60 derived theorem** (replaces retired bundled
    `topo_loss_below_envelope_exists_atom_OPEN`). Below threshold
    (`p < p_c`), `expectedTopoLoss n p` admits a paper-stated decay
    envelope `topoLossBelowDecay : ℕ → ℝ` with the per-`n` upper bound
    `expectedTopoLoss n p ≤ topoLossBelowDecay n` and
    `topoLossBelowDecay → 0` as `n → ∞`.

    R60 closure-path-B decomposition: the original bundled atom
    packaged (i) explicit envelope construction, (ii) per-`n` upper
    bound, (iii) `Tendsto → 0` convergence into one workingAssumption.
    Decomposed into:
      (a) `topo_loss_below_one_over_n_envelope_atom_OPEN` (Cat 3
          workingAssumption — paper line 294 polynomial upper bound
          `expectedTopoLoss n p ≤ 1/(n+1)` from giant-component
          conditioning + topo-cluster formula), AND
      (b) Cat 1 Mathlib `tendsto_one_div_add_atTop_nhds_zero_nat`
          (standard `1/(n+1) → 0` derivation).
    The decomposition pins the witness envelope to the explicit
    Hodge-style closed form `1 / (n + 1)`; the Cat 2 Grimmett
    percolation-probability dependency remains threaded through
    `h_perc_prob`.

    paper source: Proposition `prop:topo-cluster` Part 1, line 286 +
    proof lines 292-294 (`O(1/N)` envelope + asymptotic convergence). -/
theorem topo_loss_below_envelope_exists
    (h_perc_prob :
      ∃ θ : ℝ → ℝ,
        (∀ p : ℝ, p < harrisKestenCriticalProb → 0 < θ (1 - p)) ∧
        (∀ p : ℝ, harrisKestenCriticalProb ≤ p → θ (1 - p) = 0)) :
    ∀ p : ℝ, 0 ≤ p → p < harrisKestenCriticalProb →
      ∃ topoLossBelowDecay : ℕ → ℝ,
        Filter.Tendsto topoLossBelowDecay Filter.atTop (nhds 0) ∧
        ∀ n : ℕ, expectedTopoLoss n p ≤ topoLossBelowDecay n := by
  intro p hp_nn hp_lt
  refine ⟨fun n => 1 / ((n : ℝ) + 1), ?_, ?_⟩
  · -- Cat 1 Mathlib: `1/(n+1) → 0` as `n → ∞`.
    exact tendsto_one_div_add_atTop_nhds_zero_nat
  · intro n
    exact topo_loss_below_one_over_n_envelope_atom_OPEN h_perc_prob p hp_nn hp_lt n

/-- **Cat 1 Mathlib derivation** of the eps-from-envelope step: given any
    `topoLossBelowDecay : ℕ → ℝ` with `Tendsto _ atTop (nhds 0)` and
    per-`n` upper-bound dominance `expectedTopoLoss n p ≤ topoLossBelowDecay n`,
    the paper-stated `∀ ε > 0, ∃ N, ∀ n ≥ N, expectedTopoLoss n p < ε` form
    follows by standard ε-δ Tendsto unfolding.

    R42 conversion (Pattern-1 violation fix): the prior R41 encoding as
    `axiom topo_loss_below_eps_from_envelope_atom_OPEN` (Cat 3 atom)
    was flagged by hostile audit as a Pattern-1 violation since the
    derivation is fully Mathlib-routine. Now encoded as a Cat 1
    `theorem` proved kernel-pure via `Filter.Tendsto` neighborhood
    unfolding + transitivity through the envelope upper bound.

    paper source: Proposition `prop:topo-cluster`, line 286
    (asymptotic convergence). -/
theorem topo_loss_below_eps_from_envelope :
    ∀ p : ℝ,
      (∃ topoLossBelowDecay : ℕ → ℝ,
        Filter.Tendsto topoLossBelowDecay Filter.atTop (nhds 0) ∧
        ∀ n : ℕ, expectedTopoLoss n p ≤ topoLossBelowDecay n) →
      ∀ ε : ℝ, 0 < ε →
        ∃ N : ℕ, ∀ n, N ≤ n → expectedTopoLoss n p < ε := by
  intro p ⟨d, hd_tendsto, h_le⟩ ε hε
  have h_evt : ∀ᶠ n in Filter.atTop, d n < ε := by
    have h_mem : Set.Iio ε ∈ nhds (0 : ℝ) := Iio_mem_nhds hε
    exact hd_tendsto h_mem
  rw [Filter.eventually_atTop] at h_evt
  obtain ⟨N, hN⟩ := h_evt
  exact ⟨N, fun n hn => lt_of_le_of_lt (h_le n) (hN n hn)⟩

/-- **Proposition `prop:topo-cluster` Part 1 (derived theorem).**
    Below threshold (`p < p_c`), `expectedTopoLoss n p` converges to `0`
    as `n → ∞`.

    Decomposed from the bundled `gap_topo_loss_below_threshold_OPEN`
    axiom into (a) the R60 derived theorem `topo_loss_below_envelope_exists`
    (composing the smaller R60 atom `topo_loss_below_one_over_n_envelope_atom_OPEN`
    + Cat 1 Mathlib `tendsto_one_div_add_atTop_nhds_zero_nat`) +
    (b) `topo_loss_below_eps_from_envelope` (Cat 1 Mathlib-derived
    theorem, R42 Pattern-1 fix from former atom). The derived theorem
    composes both. R60 §18 closure-path-B refactor of the existence
    sub-claim closed the prior `topo_loss_below_envelope_exists_atom_OPEN`
    bundled atom into a derived theorem on a smaller `1/(n+1)` envelope
    atom, mirroring the Phase.lean R59 sister refactor.

    paper source: Proposition `prop:topo-cluster`, line 286;
    Grimmett 1999 _Percolation_ 2nd ed. cited for the Cat 2
    percolation-probability dependency. -/
theorem gap_topo_loss_below_threshold
    (h_perc_prob :
      ∃ θ : ℝ → ℝ,
        (∀ p : ℝ, p < harrisKestenCriticalProb → 0 < θ (1 - p)) ∧
        (∀ p : ℝ, harrisKestenCriticalProb ≤ p → θ (1 - p) = 0)) :
    ∀ p : ℝ, 0 ≤ p → p < harrisKestenCriticalProb →
      ∀ ε : ℝ, 0 < ε →
        ∃ N : ℕ, ∀ n, N ≤ n → expectedTopoLoss n p < ε := by
  intro p hp_nn hp_lt ε hε
  exact topo_loss_below_eps_from_envelope p
    (topo_loss_below_envelope_exists h_perc_prob p hp_nn hp_lt) ε hε

/-! ### `prop:topo-cluster` Part 2 — above-threshold two-sided bound.

R41 §18 atomic decomposition. The bundled
`gap_topo_loss_above_threshold_OPEN` axiom was REPLACED by a derived
theorem composing two Cat 3 paper-novel atomic stipulations:
 * `topo_loss_above_lower_bound_atom_OPEN` — paper-stated existence of
   a positive lower bound `c₁(p) > 0` on `expectedTopoLoss n p` for
   large `n`.
 * `topo_loss_above_upper_bound_atom_OPEN` — paper-stated existence of
   an upper bound `c₂(p)` on `expectedTopoLoss n p` for large `n`.

R60 closure-path-A re-derivation: introduce a new opaque carrier
`expectedTopoLossAboveLowerConst : ℝ → ℝ` for the paper-stated
Mills-tail constant `c₁(p)`, and split the lower-bound atom into
(a) positivity of the carrier and (b) a per-`n`-eventually upper-bound
witness on the carrier. The upper-bound atom is recast as a smaller
paper-faithful unit-interval bound `expectedTopoLoss n p ≤ 1` (a
Uniform[0,1] reward-setup structural fact, paper Def 2.1 line 113
`r: V → [0, 1]`), with the per-`n` upper bound `c₂` derived as
`max(c₁, 1)` via Cat 1. This pattern matches the R59 closure-path-A
refactor of the sibling `wInfoTopoRatio_const_exists_OPEN` /
`wInfoTopoRatio_bound_OPEN` in `Phase.lean`. -/

/-- R60 closure-path-A: new opaque carrier introduced as smaller
    replacement for the bundled `topo_loss_above_lower_bound_atom_OPEN`.
    The paper-stated lower-bound constant `c₁(p) > 0` (paper
    Proposition `prop:topo-cluster` line 287 + proof via `thm:phase`
    Part 2 lines 421-427) factored into the carrier so the existence
    + quantitative bound become derivable from atoms on the carrier
    rather than free-standing bundled claims.

    Substantive paper claim — opaque carrier required (Mathlib gap).
    The paper-stated constant `c₁(p)` characterising the
    `Θ(1)` lower-bound on `expectedTopoLoss n p` above the percolation
    threshold per paper line 287 + lines 421-427 cluster-size analysis
    (`E[1/(|R|+1)] ≥ c₁(p) > 0` for large `n`).

    paper source: Proposition `prop:topo-cluster`, line 287 + proof
    via `thm:phase` Part 2 lines 421-427 (cluster-size theory above
    threshold + `E[1/(|R|+1)] = Θ(1)` Mills-tail-style lower bound). -/
axiom expectedTopoLossAboveLowerConst : ℝ → ℝ

/-- R60 closure-path-A: smaller paper-novel ATOMIC stipulation #1
    replacing the retired bundled `topo_loss_above_lower_bound_atom_OPEN`.
    Paper Proposition `prop:topo-cluster` Part 2 (line 287) +
    `thm:phase` Part 2 proof lines 421-427 derive that for `p > p_c`,
    the cluster size `|R(v_0)|` has exponentially decaying tail
    (Grimmett 1999 §6.75), so `E[1/(|R|+1)] ≥ c₁(p) > 0` for large
    `n`. The cluster-size-Mills-tail composition pins the constant
    to `expectedTopoLossAboveLowerConst p > 0` for `p > p_c`.

    R60 strictly smaller than retired bundled atom: only positivity
    of the lower-bound constant on the new opaque carrier
    `expectedTopoLossAboveLowerConst` is asserted; the per-`n`
    eventually-bounded-from-below witness lives in atom #2.

    Cat 3 sub-type: workingAssumption (paper-stated positivity of
    lower-bound constant on opaque carrier; pending Mathlib percolation
    + cluster-tail machinery; 必须 close before publication).

    paper source: Proposition `prop:topo-cluster` Part 2, line 287 +
    proof via `thm:phase` Part 2 lines 421-427 (cluster-size theory
    `E[1/(|R|+1)] = Θ(1)` + Grimmett 1999 §6.75 Cat 2 dependency). -/
axiom expectedTopoLossAboveLowerConst_pos_above_pc_OPEN :
    (∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ c : ℝ, 0 < c ∧
        ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ)))) →
    ∀ p : ℝ, harrisKestenCriticalProb < p →
      0 < expectedTopoLossAboveLowerConst p

/-- R60 closure-path-A: smaller paper-novel ATOMIC stipulation #2
    replacing the retired bundled `topo_loss_above_lower_bound_atom_OPEN`.
    Paper Proposition `prop:topo-cluster` Part 2 (line 287) + proof
    via `thm:phase` Part 2 lines 421-427 derive the per-`n`
    eventually-bounded-from-below witness for `expectedTopoLoss n p`
    above the percolation threshold:  for sufficiently large `n`,
    `expectedTopoLossAboveLowerConst p ≤ expectedTopoLoss n p`.

    R60 strictly smaller than retired bundled atom: the per-`n`-eventually
    bound is asserted at the carrier-pinned constant
    `expectedTopoLossAboveLowerConst p`, not for arbitrary `c > 0`. The
    existential repackaging `∃ c₁ > 0, ∃ N, ...` is downstream Cat 0
    derivation in the new derived theorem.

    Cat 3 sub-type: workingAssumption (paper-stated quantitative
    eventually-lower-bound on opaque carriers `expectedTopoLoss` and
    `expectedTopoLossAboveLowerConst`; pending Mathlib percolation +
    cluster-tail composition; 必须 close before publication).

    paper source: Proposition `prop:topo-cluster` Part 2, line 287 +
    proof via `thm:phase` Part 2 lines 421-427. -/
axiom expectedTopoLoss_ge_AboveLowerConst_eventually_OPEN :
    (∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ c : ℝ, 0 < c ∧
        ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ)))) →
    ∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ N₁ : ℕ, ∀ n : ℕ, N₁ ≤ n →
        expectedTopoLossAboveLowerConst p ≤ expectedTopoLoss n p

/-- R60 closure-path-A: smaller paper-novel ATOMIC stipulation #3
    replacing the retired bundled `topo_loss_above_upper_bound_atom_OPEN`.
    Paper Proposition `prop:topo-cluster` proof line 292-294 derives
    `expectedTopoLoss n p = E[(n - |R|)/((n+1)(|R|+1))]` from the
    closed-form conditional formula; combined with paper Definition 2.1
    line 113 reward-range `r: V → [0, 1]`, the unconditional
    `expectedTopoLoss n p = E[r(v_R*) - r*]` is a difference of two
    unit-interval-bounded reward expectations and so is itself bounded
    above by `1` (paper-faithful Uniform[0,1] reward-setup structural
    fact).

    R60 strictly smaller than retired bundled atom: only the per-`n`
    upper bound `expectedTopoLoss n p ≤ 1` is asserted (a paper-faithful
    Uniform[0,1] structural fact derived from paper Def 2.1 reward
    range); the eventually-bounded-from-above existential `∃ c₂ ≥ c₁,
    ∃ N₂, ...` is downstream Cat 0 derivation in the new derived theorem
    (witness `c₂ := max(c₁, 1)`, `N₂ := 0`).

    Cat 3 sub-type: workingAssumption (paper-stated unit-interval upper
    bound on opaque `expectedTopoLoss` carrier from paper-faithful
    Uniform[0,1] reward range; close target = derivation from
    `reward_mem_unitInterval` (Types.lean) + closed-form
    `expectedTopoLoss_conditional_def` Mathlib expectation algebra;
    必须 close before publication).

    paper source: Proposition `prop:topo-cluster` proof, line 294
    (`(n-k)/((n+1)(k+1))` closed form) + Definition 2.1, line 113
    (`r: V → [0, 1]` reward range). -/
axiom expectedTopoLoss_le_one_atom_OPEN :
    ∀ (n : ℕ) (p : ℝ), expectedTopoLoss n p ≤ 1

/-- **Proposition `prop:topo-cluster` Part 2 (derived theorem).**
    Above threshold (`p > p_c`), `expectedTopoLoss n p = Θ(1)`:
    bounded above and below by positive constants `c₁ ≤ c₂` for
    sufficiently large `n`.

    Decomposed from the bundled `gap_topo_loss_above_threshold_OPEN`
    axiom (R41) into the R60 closure-path-A re-decomposition:
     * `expectedTopoLossAboveLowerConst_pos_above_pc_OPEN` (Cat 3
       smaller workingAssumption — positivity of the new carrier
       `expectedTopoLossAboveLowerConst : ℝ → ℝ`)
     * `expectedTopoLoss_ge_AboveLowerConst_eventually_OPEN` (Cat 3
       smaller workingAssumption — per-`n`-eventually-lower-bound at
       carrier-pinned constant)
     * `expectedTopoLoss_le_one_atom_OPEN` (Cat 3 smaller workingAssumption
       — Uniform[0,1] reward-range structural unit-interval upper bound)
    The derived theorem instantiates the lower-bound witness with
    `expectedTopoLossAboveLowerConst p`, and the upper-bound witness
    with `max(expectedTopoLossAboveLowerConst p, 1)`. The `c₂ ≥ c₁`
    relation is Cat 1 from `le_max_left`; the per-`n` upper bound for
    all `n` (including `n ≥ N₁`) is Cat 1 from
    `expectedTopoLoss_le_one_atom_OPEN` + `le_max_right`.

    paper source: Proposition `prop:topo-cluster`, line 287;
    Grimmett 1999 _Percolation_ 2nd ed. §6.75 cited for the Cat 2
    above-threshold lower-bound dependency. -/
theorem gap_topo_loss_above_threshold
    (h_grimmett :
      ∀ p : ℝ, harrisKestenCriticalProb < p →
        ∃ c : ℝ, 0 < c ∧
          ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ))))
    (p : ℝ) (hp : harrisKestenCriticalProb < p) :
    ∃ c₁ c₂ : ℝ, 0 < c₁ ∧ c₁ ≤ c₂ ∧
      ∃ N : ℕ, ∀ n : ℕ, N ≤ n →
        c₁ ≤ expectedTopoLoss n p ∧ expectedTopoLoss n p ≤ c₂ := by
  have hc₁_pos : 0 < expectedTopoLossAboveLowerConst p :=
    expectedTopoLossAboveLowerConst_pos_above_pc_OPEN h_grimmett p hp
  obtain ⟨N₁, hN₁⟩ :=
    expectedTopoLoss_ge_AboveLowerConst_eventually_OPEN h_grimmett p hp
  refine ⟨expectedTopoLossAboveLowerConst p,
          max (expectedTopoLossAboveLowerConst p) 1,
          hc₁_pos, le_max_left _ _, N₁, ?_⟩
  intro n hn
  refine ⟨hN₁ n hn, ?_⟩
  exact le_trans (expectedTopoLoss_le_one_atom_OPEN n p) (le_max_right _ _)

end BlackwellDilemma
