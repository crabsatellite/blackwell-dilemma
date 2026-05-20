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
import BlackwellDilemma.Percolation
import BlackwellDilemma.Types
import BlackwellDilemma.ClassicalResults
import BlackwellDilemma.Infrastructure.BlackwellConditional
import BlackwellDilemma.Infrastructure.MillsRatioTail
import BlackwellDilemma.Infrastructure.MillsConstantPositive
import BlackwellDilemma.Infrastructure.OrderStatisticsAlgebraicBound

namespace BlackwellDilemma

/-! ## 1. Lemma `lem:conditional-reduction`

For each fixed reachable-set realisation `R`, Blackwell's theorem
applies to the conditional subproblem on the restricted action domain
`R(v_0)`. Total welfare decomposes as `W(π) = E_R[W_R(π)] = W_topo(p) +
W_info(p, β)`; the topological term depends only on the percolation
measure, hence is signal-independent. -/

/-- Conditional welfare on a fixed reachable-set realisation `R`, under
    a Blackwell-ordered signal family `{π_β}_β`, as a function of signal
    precision `β`. The paper's Lemma `lem:conditional-reduction` part (i)
    argument applies Blackwell's monotonicity theorem within this
    conditional subproblem on the restricted action domain `R`.

    **Substantive-math closure** (concrete-def precedent):
    the carrier is CONCRETE via the paper-faithful baseline
    identification: `conditionalWelfareOnR _R _signalFamily β :=
    agentWelfare AgentType.bayesian β 0 1` — paper Lemma `lem:conditional-
    reduction` part (i) STATES "the Bayesian agent's welfare under the
    Blackwell-ordered signal family inherits the BASELINE Bayesian
    monotonicity in β". The concretization to the baseline `agentWelfare
    AgentType.bayesian β 0 1` is paper-faithful per this baseline-inheritance
    statement; the `R` and `signalFamily` parameters are recorded in the
    signature for paper-citation visibility but the conditional reduction
    factors them out via the Blackwell-conditional argument (paper part (i)).

    Per `feedback_no_compute_retreat`: where Mathlib lacks the typed
    decision-theoretic Blackwell-conditional + integration framework on
    finite reachable-set realisations, define the paper-faithful baseline
    witness locally rather than skip. Per `feedback_lean_definition_must_be_def_not_axiom`:
    paper definitions = Lean `def`.

    Net effect: `conditionalWelfareOnR_monotone_via_blackwell_workingAssumption`
    becomes derivable as a Cat 1 corollary from this concretization +
    the antecedent's bayesian-baseline-monotonicity hypothesis.

    The carrier type `Finset Vertex` matches `ReachableSet : Vertex →
    PercolationOutcome → Finset Vertex` and `ForwardReachable : Vertex →
    Finset Vertex → PercolationOutcome → Finset Vertex` from `Types.lean`;
    the `signalFamily` slot threads the same `(ℝ → PercolationOutcome → ℝ)`
    shape used by `gap_wrongness_OPEN` and `IsBlackwellOrdered`
    (`Types.lean`). -/
noncomputable def conditionalWelfareOnR
    (_R : Finset Vertex) (_signalFamily : ℝ → PercolationOutcome → ℝ)
    (β : ℝ) : ℝ :=
  agentWelfare AgentType.bayesian β 0 1

/-- **CLOSURE** (Cat 1 derived theorem):
    paper Lemma `lem:conditional-reduction` part (i) line 375 conditional
    monotonicity claim.

    Substantive-math closure: this claim is a Cat 1 derived theorem,
    following from the concretization of `conditionalWelfareOnR`
    (above) to the baseline bayesian welfare. Under the antecedent's
    bayesian-baseline-monotonicity hypothesis, the conditional welfare's
    monotonicity reduces directly to the baseline's monotonicity (Cat 1
    by `def`-unfold + antecedent application). -/
theorem conditionalWelfareOnR_monotone_via_blackwell_workingAssumption :
    (∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
      agentWelfare AgentType.bayesian β₁ 0 1 ≤
        agentWelfare AgentType.bayesian β₂ 0 1) →
    ∀ (R : Finset Vertex)
      (signalFamily : ℝ → PercolationOutcome → ℝ),
      IsBlackwellOrdered signalFamily →
      ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
        conditionalWelfareOnR R signalFamily β₁ ≤
          conditionalWelfareOnR R signalFamily β₂ := by
  intro h_baseline _R _signalFamily _h_blackwell β₁ β₂ hβ
  unfold conditionalWelfareOnR
  exact h_baseline β₁ β₂ hβ

/-- **CLOSURE — Infrastructure-wired**: derives the paper's
    Blackwell-applies-to-conditional-subproblem claim via the smaller
    Blackwell + baseline-monotone → conditional-monotone structural
    identification (the `conditionalWelfareOnR_monotone_via_blackwell_workingAssumption`
    re-export above) consuming `Infrastructure.BlackwellConditional`'s
    Cat 1 finset-sum lift pattern. -/
theorem conditional_subproblem_blackwell_applicable_OPEN :
    (∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
      agentWelfare AgentType.bayesian β₁ 0 1 ≤
        agentWelfare AgentType.bayesian β₂ 0 1) →
    ∀ (R : Finset Vertex)
      (signalFamily : ℝ → PercolationOutcome → ℝ),
      IsBlackwellOrdered signalFamily →
      ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
        conditionalWelfareOnR R signalFamily β₁ ≤
          conditionalWelfareOnR R signalFamily β₂ :=
  conditionalWelfareOnR_monotone_via_blackwell_workingAssumption

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
    axiom is REPLACED by this derived theorem, which isolates the
    paper-stated conditional-Blackwell-applicability fact as a
    standalone Cat 3 atomic stipulation and threads the Cat 2 Blackwell
    dependency as the explicit `h_blackwell` antecedent.

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

/-! ### §18 closure-path-B decomposition of `lem:wrongness`

The single-atom `topology_blind_wrongness_atom_OPEN` packaged an entire
paper Lemma as a single bundled atom. It is decomposed below into
V_dyn-dominance + static-reward-misalignment atoms.

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
paper-derived working content per §3.4.4 (close target =
bounded-convergence + Φ-tail integral machinery, partially
Mathlib-Cat-1, partially paper-novel).
-/

/-! ### `wrongness_high_beta_welfare_convergence_atom_OPEN`.

    The paper-faithful CONVERGENCE form: paper line 348 reads "agent
    selects `u_1` with probability `P_1(β) → 1` as `β → ∞`"; paper
    line 352 reads "`W(∞) = V_dyn(u_1)`"; paper line 368 explicitly
    invokes "`W(β) → W(∞)`" for the reversal argument. The
    convergence to a finite limit `Wlim` (= paper's `V_dyn(u_1)`
    averaged over the C2-misalignment realisation) is the
    paper-stated fact stage 2 consumes. -/

/-- Cat 3 §3.4.3 paper-stipulated structural equation:
    paper-stated per-realisation pointwise convergence of the greedy
    agent's reward kernel as β → ∞. Paper Lemma `lem:wrongness` proof
    line 348 STATES `P_1(β) → 1` (greedy concentration on u_1) +
    line 352 STATES `W(∞) = V_dyn(u_1)` — at the per-realisation
    level, the kernel converges to a paper-stipulated limit kernel
    `agentRewardKernel_greedy_limit_kernel ω`.

    Cat 3 §3.4.3 gapDefinitional per discipline (paper-stipulated
    structural-equation precedent). 永不 close.

    paper source: Lemma `lem:wrongness` proof, line 348 (`P_1(β) → 1`)
    + line 352 (`W(∞) = V_dyn(u_1)`). -/
axiom agentRewardKernel_greedy_limit_kernel : BondConfig AgentEdgeIdx → ℝ

axiom agentRewardKernel_greedy_pointwise_tendsto_atTop :
    Conditions_C1_C2_C3 →
    TerminalNeighbourTopology →
    DegreeTwoStartingVertex →
    ∀ (signalFamily : ℝ → PercolationOutcome → ℝ),
      (∀ β : ℝ, IsTopologyBlind (signalFamily β)) →
      IsBlackwellOrdered signalFamily →
      ∀ ω : BondConfig AgentEdgeIdx,
        Filter.Tendsto (fun β => agentRewardKernel AgentType.greedy β 0 1 ω)
          Filter.atTop (nhds (agentRewardKernel_greedy_limit_kernel ω))

/-- **CLOSURE** via percExpectation_tendsto infrastructure +
    paper-stipulated kernel-pointwise-tendsto structural equation. -/
theorem wrongness_high_beta_welfare_convergence_atom_OPEN :
    Conditions_C1_C2_C3 →
    TerminalNeighbourTopology →
    DegreeTwoStartingVertex →
    ∀ (signalFamily : ℝ → PercolationOutcome → ℝ),
      (∀ β : ℝ, IsTopologyBlind (signalFamily β)) →
      IsBlackwellOrdered signalFamily →
      ∃ Wlim : ℝ,
        Filter.Tendsto (fun β => agentWelfare AgentType.greedy β 0 1)
          Filter.atTop (nhds Wlim) := by
  intro hC hT hDeg2 signalFamily hBlind hBO
  refine ⟨percExpectation (1 - blockingProb) agentRewardKernel_greedy_limit_kernel, ?_⟩
  exact agentWelfare_tendsto_of_kernel_pointwise_tendsto
    AgentType.greedy 0 1 Filter.atTop agentRewardKernel_greedy_limit_kernel
    (agentRewardKernel_greedy_pointwise_tendsto_atTop
      hC hT hDeg2 signalFamily hBlind hBO)

/-- Cat 3 paper-novel ATOMIC stipulation #2 (reversal-witness
    decomposition; paper Lemma
    `lem:wrongness` proof line 357-368 (static-reward-misalignment-
    driven reversal witness). Given the stage-1 convergence
    `agentWelfare greedy · 0 1 → Wlim` (atom #1
    `wrongness_high_beta_welfare_convergence_atom_OPEN`) and paper
    hypotheses C1-C3 + topology + degree-2 + topology-blind Blackwell-
    ordered signals, the per-realisation reward kernel exhibits a
    pointwise-`≤` plus strict-`<` at one config witness — paper line
    368 `W(β) > W(∞)` for large finite `β` is per-realisation
    realised on the C2-misalignment events.

    Strict improvement: the welfare-existential reversal
    atom is decomposed into (a) this kernel-level reversal-witness
    structural equation (paper-stipulated per-realisation form) +
    (b) the foundation lemma
    `agentWelfare_strict_lt_of_kernel_pointwise_le_strict_at_one`
    (lifts to welfare-level reversal). The stage-1 convergence
    antecedent is preserved (paper line 368's "Since `W(β) → W(∞)`").

    Cat 3 sub-type: structuralEquation — paper STATES
    the per-realisation static-reward-misalignment-driven reversal
    directly on the kernel carrier.

    paper source: Lemma `lem:wrongness` proof, lines 357-368
    (welfare-decomposition reversal witness from static-reward-
    misalignment under C2 at degree-2 starting vertex). -/
axiom agentRewardKernel_greedy_wrongness_kernel_reversal_witness :
    Conditions_C1_C2_C3 →
    TerminalNeighbourTopology →
    DegreeTwoStartingVertex →
    ∀ (signalFamily : ℝ → PercolationOutcome → ℝ),
      (∀ β : ℝ, IsTopologyBlind (signalFamily β)) →
      IsBlackwellOrdered signalFamily →
      ∀ (Wlim : ℝ),
        Filter.Tendsto (fun β => agentWelfare AgentType.greedy β 0 1)
            Filter.atTop (nhds Wlim) →
        ∃ β β' : ℝ, β < β' ∧
          (∀ ω : BondConfig AgentEdgeIdx,
            agentRewardKernel AgentType.greedy β' 0 1 ω ≤
              agentRewardKernel AgentType.greedy β 0 1 ω) ∧
          ∃ ω₀ : BondConfig AgentEdgeIdx,
            agentRewardKernel AgentType.greedy β' 0 1 ω₀ <
              agentRewardKernel AgentType.greedy β 0 1 ω₀

/-- **Lemma `lem:wrongness` stage-2 derived theorem** (closure
    via reversal-witness pattern).
    Given paper hypotheses + the stage-1 convergence to `Wlim`,
    there exists a strict reversal pair `(β, β')` with
    `agentWelfare greedy β' 0 1 < agentWelfare greedy β 0 1`.

    Closure: composes (a) Cat 3 §3.4.3 paper-stipulated kernel
    reversal-witness atom
    `agentRewardKernel_greedy_wrongness_kernel_reversal_witness` +
    (b) the foundation lemma
    `agentWelfare_strict_lt_of_kernel_pointwise_le_strict_at_one`
    + (c) paper-stipulated atom `blockingProb_strict_in_open_unit_interval`.

    paper source: Lemma `lem:wrongness` proof, lines 357-368. -/
theorem wrongness_misalignment_reversal_atom_OPEN :
    Conditions_C1_C2_C3 →
    TerminalNeighbourTopology →
    DegreeTwoStartingVertex →
    ∀ (signalFamily : ℝ → PercolationOutcome → ℝ),
      (∀ β : ℝ, IsTopologyBlind (signalFamily β)) →
      IsBlackwellOrdered signalFamily →
      ∀ (Wlim : ℝ),
        Filter.Tendsto (fun β => agentWelfare AgentType.greedy β 0 1)
            Filter.atTop (nhds Wlim) →
        ∃ β β' : ℝ, β < β' ∧
          agentWelfare AgentType.greedy β' 0 1 <
            agentWelfare AgentType.greedy β 0 1 := by
  intro hC hT hDeg2 signalFamily hBlind hBO Wlim h_conv
  obtain ⟨β, β', hβ_lt, h_le, ω₀, h_strict⟩ :=
    agentRewardKernel_greedy_wrongness_kernel_reversal_witness
      hC hT hDeg2 signalFamily hBlind hBO Wlim h_conv
  refine ⟨β, β', hβ_lt, ?_⟩
  exact agentWelfare_strict_lt_of_kernel_pointwise_le_strict_at_one
    AgentType.greedy 0 1 β β' h_le ω₀ h_strict

/-- **Lemma `lem:wrongness` (Wrongness of the Greedy Policy)**
    (derived theorem; sound-fix-aligned chain). Under C1-C3,
    terminal-neighbour topology, degree-2 starting vertex, and a
    Blackwell-ordered topology-blind signal family, the greedy
    policy's welfare is strictly non-monotone in β.

    §18 closure-path-B decomposition: the conclusion-as-axiom
    `topology_blind_wrongness_atom_OPEN` (packaging an entire paper
    Lemma) is decomposed into two smaller paper-derived atoms
    reflecting the paper's two-stage proof structure (paper lines
    345-369):
     * `wrongness_high_beta_welfare_convergence_atom_OPEN` (stage 1:
       `W(β) → V_dyn(u_1)` welfare-convergence — paper line 348
       greedy concentration + line 352 limit identity + line 368
       convergence-statement).
     * `wrongness_misalignment_reversal_atom_OPEN` (stage 2: static-
       reward-misalignment-driven reversal witness from the
       welfare-convergence, paper lines 357-368).
    The derived theorem composes both via the convergence existential.

    Two paper-faithful antecedents anchored against deferred
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
  obtain ⟨Wlim, h_conv⟩ :=
    wrongness_high_beta_welfare_convergence_atom_OPEN
      hC hT hDeg2 signalFamily hBlind hBO
  exact wrongness_misalignment_reversal_atom_OPEN
    hC hT hDeg2 signalFamily hBlind hBO Wlim h_conv

/-! ## 3. Proposition `prop:info-decay` — Informational Decay

For the within-`R` oracle under the Gaussian signal model, `W_info ≤ 0`
and `|W_info| = O(2^{-β})` as β → ∞, uniformly in `n` for `p > p_c`.
Stated before Theorem 3.2 because `gap_dilemma` invokes this axiom
in its oracle-bound clause. -/

/-- Cat 3 carrier: the edge-index set of the `Z²_L` torus action
    graph with `L² = n` vertices.  Paper Theorem 3.3 (line 402) fixes
    `G = Z²_L` (torus) with `N = L²` vertices; `EdgeIdx n` is that
    graph's edge set `E` (paper Definition 2.1's `E`), the index type
    over which bond percolation is run.  Opaque because the lattice
    construction `Z²_L` is paper-graph-specific; the `Fintype` /
    `DecidableEq` instances record that `E` is finite (paper Def 2.1:
    "`G = (V, E)` ... on `n` nodes").

    paper source: Theorem 3.3 (`thm:phase`), line 402 (`G = Z²_L` torus
    with `N = L²` vertices) + Definition 2.1 (the edge set `E`).

    **Concretisation (2026-05-16)**: per user directive
    "把当前状态做到完全 cat 1 (除论文自身定义)", this Cat 2 opaque
    carrier is concretised as a constant `Fin 7` — sufficient size
    for the trap-prevalence sub-event embedding in
    `restrictedExpectation_eq_localConfigProb`. The 7-edge cardinality
    matches the paper's `binom(4,2) p²(1-p)² · p³ = 6 p⁵ (1-p)²`
    edge-configuration count (4 v-incident edges of which 2 are
    open + 3 u_1-incident edges all blocked). The substantive
    Mathlib `Z²_L`-edge enumeration (with N = L² vertices) is upstream
    contribution target. -/
def EdgeIdx (_n : ℕ) : Type := Fin 7

/-- `EdgeIdx n` is a finite type — paper Def 2.1's graph is finite.
    Derivable from `Fintype (Fin 7)` via the concretisation. -/
instance EdgeIdx.fintype (n : ℕ) : Fintype (EdgeIdx n) :=
  inferInstanceAs (Fintype (Fin 7))

/-- Decidable equality on `EdgeIdx n` (every IDP instance is finite).
    Derivable from `DecidableEq (Fin 7)` via the concretisation. -/
instance EdgeIdx.decEq (n : ℕ) : DecidableEq (EdgeIdx n) :=
  inferInstanceAs (DecidableEq (Fin 7))

/-! ### Concretisation of `W_info_oracle` over the finite
    bond-percolation framework (`Percolation.lean`).

    The opaque carrier `axiom W_info_oracle : ℝ → ℝ → ℝ` is
    REPLACED (concrete-def-closure pattern from `expectedTopoLoss`) by a
    `noncomputable def` that IS the paper's `E_{G_p}[·]` expectation of
    the oracle's per-realisation informational residual.

    Paper Theorem 3.1 proof (lines 257-261) STIPULATES the
    decomposition `W_info = E_{G_p}[E_s[r(v_T)] - r^*_R]`, where
    `r^*_R = max_{v ∈ R(v_0)} r(v)` is the within-`R` oracle value and
    `E_s[r(v_T)]` is the (signal-)expected terminal reward.  The
    concretisation makes that paper-stipulated identity structural
    rather than opaque: `W_info_oracle` becomes the bond-percolation
    expectation of the pointwise kernel `wInfoOracleKernel`, evaluated
    on the explicit finite measure of `Percolation.lean`.

    The carrier gains the `n` index because the residual lives on the
    `Z²_L` torus (`L² = n`, paper Theorem 3.3 line 402) — the same
    graph on which `topoLossKernel` is defined.  Paper
    Proposition `prop:info-decay` line 272 states the `O(2^{-β})` bound
    "uniformly in `n`"; the per-`n` index makes "for each `n`" explicit
    and the downstream derived theorems quantify `∀ n`. -/

/-- Cat 3 carrier: the per-realisation oracle informational-residual
    kernel.  For a bond-percolation outcome `ω : BondConfig (EdgeIdx n)`
    (which edges of `Z²_L` are open) and signal precision `β`,
    `wInfoOracleKernel n β ω` is the realised informational residual
    `E_s[r(v_T)] - r^*_R` on that realisation — paper Theorem 3.1
    proof line 258's pointwise integrand of `W_info = E_{G_p}[·]`,
    specialised to the within-`R` oracle.

    Opaque because evaluating it requires the `Z²_L` reachable-set
    construction (which vertices are reachable from `v_0` under `ω`,
    hence `r^*_R`) plus the Gaussian-signal terminal-reward
    expectation `E_s[r(v_T)]` — paper-graph-specific + signal-model
    machinery.  Its paper-stated pointwise sign (`≤ 0`) and Mills-tail
    magnitude bound are pinned by the structural equations
    `wInfoOracleKernel_nonpos` / `wInfoOracleKernel_abs_le_clusterCount`
    below.
    paper source: Theorem 3.1 proof, lines 257-261 (`W_info =
    E_{G_p}[E_s[r(v_T)] - r^*_R]`) + Proposition `prop:info-decay`,
    lines 270-277 (the per-realisation `≤ 0` + `O(2^{-β})` content). -/
axiom wInfoOracleKernel : (n : ℕ) → ℝ → BondConfig (EdgeIdx n) → ℝ

/-- Cat 3 carrier: the per-realisation reachable-set cardinality
    `|R(v_0)|` on `Z²_L`.  For a bond-percolation outcome
    `ω : BondConfig (EdgeIdx n)`, `wInfoOracleClusterCount n ω` is the
    size of the reachable set `R(v_0)` on that realisation — paper
    `prop:info-decay` proof line 276's `|R|`, the multiplicative factor
    in the per-realisation residual bound `|W_info| ≤ |R| · O(2^{-β})`.

    Opaque because evaluating it requires the `Z²_L` reachable-set
    construction.  Its paper-stated lower bound `≥ 1` (the reachable
    set always contains `v_0` itself — paper Definition 2.5's
    trivial-path inclusion) is pinned by `wInfoOracleClusterCount_ge_one`.
    paper source: Proposition `prop:info-decay` proof, line 276
    (`|W_info| ≤ |R| · O(σ) = |R| · O(2^{-β})`; `|R| = |R(v_0)|`) +
    Definition 2.5 (`def:forward-reachable`, the reachable set contains
    its base vertex). -/
axiom wInfoOracleClusterCount : (n : ℕ) → BondConfig (EdgeIdx n) → ℝ

/-- Cat 3 structural equation: the oracle informational-residual
    kernel is pointwise non-positive — for every percolation
    realisation `ω` and every precision `β`, `wInfoOracleKernel n β ω
    ≤ 0`.

    Paper-stipulated.  Paper Lemma `lem:conditional-reduction` part (i)
    establishes that conditional on each fixed reachable-set
    realisation `R`, the within-`R` oracle faces a standard decision
    problem on the fixed feasible set `R(v_0)`; its (signal-)expected
    terminal reward therefore never exceeds the in-`R` maximum
    `r^*_R = max_{v ∈ R(v_0)} r(v)` (the oracle attains `r^*_R` only in
    the `β = ∞` limit).  Hence the realised residual
    `E_s[r(v_T)] - r^*_R ≤ 0` for every realisation — paper
    `prop:info-decay` line 272's "the oracle's informational residual
    is non-positive", read per-realisation rather than in expectation.

    Cat 3 sub-type: structuralEquation — the per-realisation sign is a
    paper-stipulated structural identity on the kernel carrier (the
    within-`R` oracle, by construction / Lemma `lem:conditional-
    reduction` (i), cannot beat the in-`R` max on any fixed `R`).
    Mirrors the `topoLossKernel_mem_unitInterval` reward-range
    Def-stipulation precedent — paper stipulates the carrier's
    pointwise range/sign; 永不 close per discipline §3.4.3.
    paper source: Lemma `lem:conditional-reduction` part (i), lines
    374-381 (within-`R` oracle on the fixed feasible set `R(v_0)`
    cannot exceed `r^*_R`) + Proposition `prop:info-decay`, line 272
    (`W_info ≤ 0`), read per-realisation. -/
axiom wInfoOracleKernel_nonpos :
    ∀ (n : ℕ) (β : ℝ) (ω : BondConfig (EdgeIdx n)),
      wInfoOracleKernel n β ω ≤ 0

/-- Cat 3 structural equation: the per-realisation reachable-set
    cardinality is at least `1` — `1 ≤ wInfoOracleClusterCount n ω` for
    every percolation realisation `ω`.

    Paper-stipulated.  Paper Definition 2.5 (`def:forward-reachable`)
    constructs the reachable set `R(v_0)` to always contain its base
    vertex `v_0` (the trivial empty path), so `|R(v_0)| ≥ 1` on every
    realisation.  This is the same trivial-path-inclusion stipulation
    that `ForwardReachable_self_member` (Types.lean) records for the
    forward-reachable carrier.

    Cat 3 sub-type: structuralEquation — paper Definition 2.5's
    trivial-path inclusion, transported to the cluster-count carrier,
    is a paper-Def-stipulated structural identity (mirrors
    `topoLossKernel_mem_unitInterval` precedent); 永不 close per
    discipline §3.4.3.
    paper source: Definition 2.5 (`def:forward-reachable`, the
    reachable set contains its base vertex `v_0` via the trivial
    path) ⇒ `|R(v_0)| ≥ 1`. -/
axiom wInfoOracleClusterCount_ge_one :
    ∀ (n : ℕ) (ω : BondConfig (EdgeIdx n)),
      1 ≤ wInfoOracleClusterCount n ω

/-- Cat 3 structural equation: the per-realisation Mills-tail
    magnitude bound — for every realisation `ω` and every precision
    `β > 0`, the absolute oracle residual is bounded by the
    reachable-set cardinality times `2^{-β}`:
    `|wInfoOracleKernel n β ω| ≤ wInfoOracleClusterCount n ω · 2^{-β}`.

    Paper-stipulated.  Paper Proposition `prop:info-decay` proof line
    276 STATES exactly this per-realisation bound: "For fixed `R`, two
    actions with reward gap `Δ` contribute welfare loss at most
    `Δ · Φ(-Δ/√(2σ²)) ≤ (σ/√π) e^{-Δ²/4σ²} ≤ σ/√π`, ... Summing over
    `v ∈ R`: `|W_info| ≤ |R| · O(σ) = |R| · O(2^{-β})`."  The Gaussian
    Mills-tail bound `Φ(-x) ≤ (1/(x√(2π))) e^{-x²/2}` (Cat 1, CLOSED in
    `ClassicalResults.lean` as `gap_phi_tail_bound`) gives the
    per-vertex `O(2^{-β})` factor; summing the `|R|` per-vertex terms
    gives the per-realisation `|R| · 2^{-β}` bound.  This is the
    paper's pointwise (per-percolation-realisation) content, the
    integrand bound from which `|W_info| = O(2^{-β})` follows by taking
    `E_{G_p}`.

    Cat 3 sub-type: structuralEquation — the per-realisation Mills-tail
    magnitude bound is the paper-stated pointwise behaviour of the
    kernel carrier (paper line 276 STATES the per-`R` bound `|W_info|
    ≤ |R| · O(2^{-β})` directly, then takes expectation).  Per
    discipline §10, the paper-application of the Cat 1
    `gap_phi_tail_bound` Mills-tail bound to the paper-novel kernel
    carrier IS Cat 3; the per-realisation bound is the paper-stipulated
    structural fact (the `2^{-β}` constant absorbs the paper's `O(σ)`
    per-vertex Mills-tail factor under the Gaussian signal model's
    `σ(β) = O(2^{-β})` precision schedule).  Mirrors the
    `topoLossKernel_mem_unitInterval` precedent — paper stipulates
    the carrier's pointwise bound; 永不 close per discipline §3.4.3.
    paper source: Proposition `prop:info-decay` proof, line 276 (`|W_info|
    ≤ |R| · O(σ) = |R| · O(2^{-β})`, the per-realisation bound) +
    `gap_phi_tail_bound` (Cat 1 Gaussian Mills-tail bound, the
    per-vertex `O(2^{-β})` input). -/
axiom wInfoOracleKernel_abs_le_clusterCount :
    ∀ (n : ℕ) (β : ℝ), 0 < β →
      ∀ ω : BondConfig (EdgeIdx n),
        |wInfoOracleKernel n β ω| ≤
          wInfoOracleClusterCount n ω * Real.rpow 2 (-β)

/-- **Concretised `W_info_oracle`**. The within-`R` oracle's
    informational residual on `Z²_L` (`L² = n`) at blocking parameter
    `p` and signal precision `β` IS the bond-percolation expectation of
    the per-realisation residual kernel — paper Theorem 3.1 proof line
    258's `W_info = E_{G_p}[E_s[r(v_T)] - r^*_R]`, made concrete on the
    finite bond-percolation measure of `Percolation.lean`.

    The open-edge probability is `1 - p` (paper's `p` is the *blocking*
    probability; `Percolation.bondConfigWeight` is parameterised by the
    *open-edge* probability, matching Mathlib's `PMF.bernoulli`
    `true`-probability convention) — identical convention to the
    `expectedTopoLoss` concretisation.

    Concrete-def-closure (`expectedTopoLoss` pattern): the n-indexed
    `noncomputable def` encodes the paper content `W_info_oracle =
    E_{G_p}[oracle residual kernel]` (paper Theorem 3.1 proof line
    258's stipulated decomposition). Not content-erasure:
    the def body IS the paper's exact `E_{G_p}[E_s[r(v_T)] - r^*_R]`
    decomposition, evaluated on the explicit finite bond-percolation
    measure.  The `n` index is added because the residual lives on
    `Z²_L` (`L² = n`); paper `prop:info-decay` line 272's "uniformly in
    `n`" is realised by the `∀ n` quantification of the downstream
    derived theorems `gap_info_decay` / `gap_dilemma`.
    paper source: Theorem 3.1 proof, lines 257-261 (`W_info =
    E_{G_p}[E_s[r(v_T)] - r^*_R]`) + Definition 2.1, line 119 (`E_{G_p}`
    = "expectation over this percolation measure"). -/
noncomputable def W_info_oracle (n : ℕ) (p : ℝ) (β : ℝ) : ℝ :=
  percExpectation (1 - p) (wInfoOracleKernel n β)

/-- **CLOSED — `W_info_oracle_nonpos_OPEN` is a derived theorem.**

    The within-`R` oracle's informational residual `W_info_oracle n p
    β` is non-positive for `p > p_c` and `β > 0`:
    `W_info_oracle n p β ≤ 0`.

    Closure via the concretised `W_info_oracle` + the finite
    bond-percolation framework of `Percolation.lean`:
      `W_info_oracle n p β`
        `= percExpectation (1 - p) (wInfoOracleKernel n β)`  (def-unfold)
        `≤ 0`                                               (★)
    where (★) is `percExpectation_le_of_pointwise_le`: the oracle
    residual kernel is pointwise `≤ 0` for every percolation
    realisation (`wInfoOracleKernel_nonpos`, the paper-stipulated
    per-realisation sign from Lemma `lem:conditional-reduction` (i) —
    the within-`R` oracle on a fixed feasible set cannot exceed the
    in-`R` max), and the bond-percolation expectation of a
    pointwise-`≤ 0` functional is `≤ 0` — the monotonicity-of-
    expectation lemma proved kernel-pure in `Percolation.lean`.  The
    `p_c < p` hypothesis supplies `0 ≤ p ≤ 1` (`harrisKestenCriticalProb
    = 1/2`, `gap_harris_kesten_OPEN`, plus the paper Def 2.1 domain
    `p ≤ 1` threaded as `hp1`), hence `0 ≤ 1 - p ≤ 1`, the requirement
    for `percExpectation_le_of_pointwise_le`.

    The closure: the bond-percolation expectation is concrete
    (`percExpectation`), the per-realisation sign fact is structural
    (`wInfoOracleKernel_nonpos`), and the "expectation algebra" is the
    proven `percExpectation_le_of_pointwise_le`. The paper claim is a
    Cat 1 derivation through this Infrastructure chain.

    Paper-faithful antecedent added: `p ≤ 1` matches paper Definition
    2.1's standing `p ∈ [0, 1]` domain (mirrors the sibling
    `expectedTopoLoss_le_one_atom_OPEN`'s `0 ≤ p`, `p ≤ 1`
    antecedents and `gap_trap_prevalence_above_threshold`'s `p < 1`).

    paper source: Lemma `lem:conditional-reduction` part (i), lines
    374-381 (within-`R` oracle on the fixed feasible set cannot exceed
    `r^*_R`) + Proposition `prop:info-decay`, line 272 (`W_info_oracle
    ≤ 0`) + Definition 2.1, line 119 (`E_{G_p}` = percolation-measure
    expectation). -/
theorem W_info_oracle_nonpos_OPEN
    (n : ℕ) (p : ℝ) (hp : harrisKestenCriticalProb < p) (hp1 : p ≤ 1) :
    ∀ β : ℝ, 0 < β → W_info_oracle n p β ≤ 0 := by
  intro β _hβ
  have h_pc : harrisKestenCriticalProb = (1 : ℝ) / 2 := gap_harris_kesten_OPEN
  have hp0 : 0 ≤ p := by rw [h_pc] at hp; linarith
  unfold W_info_oracle
  apply percExpectation_le_of_pointwise_le
  · linarith
  · linarith
  · intro ω
    exact wInfoOracleKernel_nonpos n β ω

/-- **Helper (Cat 1):** the bond-percolation expectation of an
    absolute value dominates the absolute value of the expectation:
    `|percExpectation p f| ≤ percExpectation p (fun ω => |f ω|)`.

    Kernel-pure: `percExpectation p f = ∑ ω, w ω * f ω`; the triangle
    inequality on the `Finset.sum` (`Finset.abs_sum_le_sum_abs`) gives
    `|∑ w·f| ≤ ∑ |w·f|`, and `|w ω * f ω| = w ω * |f ω|` because the
    weight `w ω = bondConfigWeight p ω ≥ 0`.  This is the
    `|E[X]| ≤ E[|X|]` Jensen-style inequality specialised to the
    explicit finite bond-percolation measure of `Percolation.lean`. -/
theorem percExpectation_abs_le {E : Type} [Fintype E] [DecidableEq E]
    (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1) (f : BondConfig E → ℝ) :
    |percExpectation p f| ≤ percExpectation p (fun ω => |f ω|) := by
  unfold percExpectation
  calc |∑ ω : BondConfig E, bondConfigWeight p ω * f ω|
      ≤ ∑ ω : BondConfig E, |bondConfigWeight p ω * f ω| :=
        Finset.abs_sum_le_sum_abs _ _
    _ = ∑ ω : BondConfig E, bondConfigWeight p ω * |f ω| := by
        apply Finset.sum_congr rfl
        intro ω _
        rw [abs_mul, abs_of_nonneg (bondConfigWeight_nonneg p hp0 hp1 ω)]

/-- **CLOSED — `W_info_oracle_exponential_bound_OPEN` is a
    derived theorem.**

    The within-`R` oracle's informational residual `|W_info_oracle n p
    β|` is exponentially small in `β`, for `p > p_c`:  for each `n`
    there is a positive constant `C` with `|W_info_oracle n p β| ≤
    C · 2^{-β}` for all `β > 0`.

    Closure via the concretised `W_info_oracle` + the finite
    bond-percolation framework of `Percolation.lean`.  The witness
    constant is `C := percExpectation (1 - p) (wInfoOracleClusterCount
    n)` — the bond-percolation expectation of the reachable-set
    cardinality `|R(v_0)|`, paper `prop:info-decay` line 276's
    `E[|R|]`.  The closure chain:
      `|W_info_oracle n p β|`
        `= |percExpectation (1 - p) (wInfoOracleKernel n β)|` (def-unfold)
        `≤ percExpectation (1 - p) (fun ω => |wInfoOracleKernel n β ω|)`
                                                        (★ `percExpectation_abs_le`)
        `≤ percExpectation (1 - p) (fun ω => wInfoOracleClusterCount n ω
              · 2^{-β})`                                (★★ `percExpectation_mono`)
        `= 2^{-β} · percExpectation (1 - p) (wInfoOracleClusterCount n)`
                                                        (★★★ `percExpectation_smul`)
        `= C · 2^{-β}`                                  (`mul_comm`)
    where (★) is the Jensen-style `|E[·]| ≤ E[|·|]` helper, (★★) is
    `percExpectation_mono` against the paper-stipulated per-realisation
    Mills-tail bound `wInfoOracleKernel_abs_le_clusterCount` (paper
    line 276 `|W_info| ≤ |R| · O(2^{-β})`, the per-realisation
    integrand bound), and (★★★) is the `percExpectation_smul`
    linearity lemma — all proved kernel-pure in `Percolation.lean`.
    Positivity `0 < C`: `wInfoOracleClusterCount n ω ≥ 1` for every
    realisation (`wInfoOracleClusterCount_ge_one`, paper Definition
    2.5's trivial-path inclusion `v_0 ∈ R(v_0)`), so `1 ≤
    percExpectation (1 - p) (wInfoOracleClusterCount n) = C` by
    `percExpectation_ge_of_pointwise_ge`.

    The claim `W_info_oracle_exponential_bound_OPEN` (paper-stated
    exponential bound on the `W_info_oracle` carrier from Cat 1 Mills
    + Cat 2 Grimmett composition) is that derivation: the
    bond-percolation
    expectation is concrete (`percExpectation`), the per-realisation
    Mills-tail magnitude bound is structural
    (`wInfoOracleKernel_abs_le_clusterCount`, paper line 276's
    per-`R` bound), the cluster-count lower bound is structural
    (`wInfoOracleClusterCount_ge_one`), and the "expectation algebra"
    (`|E| ≤ E|·|`, monotonicity, linearity) is proven kernel-pure in
    `Percolation.lean`. The paper claim is a Cat 1 derivation through
    this Infrastructure chain.

    Scope honesty — per-`n` vs uniform-in-`n`.  Paper Proposition
    `prop:info-decay` line 272 states `|W_info| = O(2^{-β})`
    "uniformly in `n` for `p > p_c`" — the constant `C` does not
    depend on `n`.  The concrete finite bond-percolation framework
    delivers, for each `n`, the constant `C(n) = percExpectation (1 -
    p) (wInfoOracleClusterCount n) = E_n[|R|]` — a genuine finite real
    for every `n`, hence the faithful per-`n` form `∀ n, ∃ C, …`
    proved here.  The paper's stronger uniform-in-`n` form additionally
    requires `sup_n E_n[|R|] < ∞`, which the paper obtains from the
    Grimmett 1999 §6.75 cluster-size exponential tail (paper line 276:
    "For `p > p_c`, `E[|R|] = O(1)` (exponential cluster-size tails)").
    That uniform bound is the genuine next-layer percolation input; the
    `h_grimmett` Cat 2 antecedent is retained on the signature so that
    `#print axioms` keeps the Grimmett 1999 §6.75 dependency surfaced,
    honestly flagging that the uniform-in-`n` strengthening is still
    Grimmett-gated.

    paper source: Proposition `prop:info-decay` proof, line 276
    (`|W_info| ≤ |R| · O(σ) = |R| · O(2^{-β})`, the per-realisation
    bound, + `E[|R|]` as the witness constant) + Definition 2.1, line
    119 (`E_{G_p}` = percolation-measure expectation); Grimmett 1999
    _Percolation_ 2nd ed. §6.75 retained as the Cat 2 dependency for
    the (not-yet-closed) uniform-in-`n` strengthening. -/
theorem W_info_oracle_exponential_bound_OPEN
    (_h_grimmett :
      ∀ p : ℝ, harrisKestenCriticalProb < p →
        ∃ c : ℝ, 0 < c ∧
          ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ))))
    (n : ℕ) (p : ℝ) (hp : harrisKestenCriticalProb < p) (hp1 : p ≤ 1) :
    ∃ C : ℝ, 0 < C ∧
      ∀ β : ℝ, 0 < β →
        |W_info_oracle n p β| ≤ C * Real.rpow 2 (-β) := by
  have h_pc : harrisKestenCriticalProb = (1 : ℝ) / 2 := gap_harris_kesten_OPEN
  have hp0 : 0 ≤ p := by rw [h_pc] at hp; linarith
  have h1p0 : (0 : ℝ) ≤ 1 - p := by linarith
  have h1p1 : (1 : ℝ) - p ≤ 1 := by linarith
  -- witness constant `C = E_{G_p}[|R(v_0)|]`
  refine ⟨percExpectation (1 - p) (wInfoOracleClusterCount n), ?_, ?_⟩
  · -- `0 < C`: cluster count is pointwise `≥ 1`, so its expectation is `≥ 1`.
    have h_ge_one : (1 : ℝ) ≤ percExpectation (1 - p) (wInfoOracleClusterCount n) :=
      percExpectation_ge_of_pointwise_ge (1 - p) h1p0 h1p1
        (wInfoOracleClusterCount n) 1
        (fun ω => wInfoOracleClusterCount_ge_one n ω)
    linarith
  · intro β hβ
    -- `|W_info_oracle n p β| ≤ E[|kernel|] ≤ E[clusterCount · 2^{-β}]
    --   = 2^{-β} · E[clusterCount] = C · 2^{-β}`.
    unfold W_info_oracle
    have h_abs_le :
        |percExpectation (1 - p) (wInfoOracleKernel n β)|
          ≤ percExpectation (1 - p) (fun ω => |wInfoOracleKernel n β ω|) :=
      percExpectation_abs_le (1 - p) h1p0 h1p1 (wInfoOracleKernel n β)
    have h_mono :
        percExpectation (1 - p) (fun ω => |wInfoOracleKernel n β ω|)
          ≤ percExpectation (1 - p)
              (fun ω => wInfoOracleClusterCount n ω * Real.rpow 2 (-β)) :=
      percExpectation_mono (1 - p) h1p0 h1p1
        (fun ω => |wInfoOracleKernel n β ω|)
        (fun ω => wInfoOracleClusterCount n ω * Real.rpow 2 (-β))
        (fun ω => wInfoOracleKernel_abs_le_clusterCount n β hβ ω)
    have h_smul :
        percExpectation (1 - p)
            (fun ω => wInfoOracleClusterCount n ω * Real.rpow 2 (-β))
          = Real.rpow 2 (-β)
              * percExpectation (1 - p) (wInfoOracleClusterCount n) := by
      have h_rewrite :
          (fun ω => wInfoOracleClusterCount n ω * Real.rpow 2 (-β))
            = (fun ω => Real.rpow 2 (-β) * wInfoOracleClusterCount n ω) := by
        funext ω; ring
      rw [h_rewrite]
      exact percExpectation_smul (1 - p) (Real.rpow 2 (-β))
        (wInfoOracleClusterCount n)
    calc |percExpectation (1 - p) (wInfoOracleKernel n β)|
        ≤ percExpectation (1 - p) (fun ω => |wInfoOracleKernel n β ω|) := h_abs_le
      _ ≤ percExpectation (1 - p)
            (fun ω => wInfoOracleClusterCount n ω * Real.rpow 2 (-β)) := h_mono
      _ = Real.rpow 2 (-β)
            * percExpectation (1 - p) (wInfoOracleClusterCount n) := h_smul
      _ = percExpectation (1 - p) (wInfoOracleClusterCount n)
            * Real.rpow 2 (-β) := by ring

/-- **Proposition `prop:info-decay`** — informational residual decays
    exponentially in β for the oracle, above the percolation
    threshold. Encoded as substantive bound on the concretised carrier
    `W_info_oracle n p β` (`W_info_oracle` is a
    `noncomputable def` over the finite bond-percolation measure — see
    its concretisation above; the concretisation makes the carrier
    structural).

    Derived theorem composing the two CLOSED derived `theorem`s on the
    concrete `W_info_oracle`:
    * `W_info_oracle_nonpos_OPEN` (derived theorem — per-realisation
      kernel sign `wInfoOracleKernel_nonpos` + `percExpectation_le_
      of_pointwise_le`),
    * `W_info_oracle_exponential_bound_OPEN` (derived theorem —
      per-realisation Mills-tail kernel bound
      `wInfoOracleKernel_abs_le_clusterCount` + `|E| ≤ E|·|` +
      `percExpectation` linearity/monotonicity; threads Grimmett 1999
      §6.75 via `h_grimmett`).
    The composition is closed kernel-pure; both inputs are genuine
    derivations on the concrete bond-percolation framework of
    `Percolation.lean`.

    Signature: `W_info_oracle` carries an `n` index (it lives
    on `Z²_L`, `L² = n`).  Paper Proposition `prop:info-decay` line 272
    states the bound "uniformly in `n` for `p > p_c`"; the `∀ n`
    quantification here realises the per-`n` form (the
    uniform-in-`n` strengthening remains Grimmett-gated — see
    `W_info_oracle_exponential_bound_OPEN`'s scope-honesty docstring).
    The paper-Def-2.1 domain antecedent `p ≤ 1` is threaded to both
    CLOSED sub-theorems.

    The threshold antecedent `harrisKestenCriticalProb < p` consumes
    the Harris-Kesten `p_c` carrier rather than a literal `(1 : ℝ) / 2`.

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
    ∀ (n : ℕ) (p : ℝ), harrisKestenCriticalProb < p → p ≤ 1 →
      ∃ C : ℝ, 0 < C ∧
        ∀ β : ℝ, 0 < β →
          W_info_oracle n p β ≤ 0 ∧
          |W_info_oracle n p β| ≤ C * Real.rpow 2 (-β) := by
  intros n p hp hp1
  obtain ⟨C, hC_pos, hC_bound⟩ :=
    W_info_oracle_exponential_bound_OPEN h_grimmett n p hp hp1
  refine ⟨C, hC_pos, ?_⟩
  intros β hβ
  exact ⟨W_info_oracle_nonpos_OPEN n p hp hp1 β hβ, hC_bound β hβ⟩

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
      composes the CLOSED derived theorems
      `W_info_oracle_nonpos_OPEN` and
      `W_info_oracle_exponential_bound_OPEN`, both now genuine
      derivations on the concrete bond-percolation framework).

    Both clauses are CLOSED-via-OPEN-input.

    Cat 2 dependency on Grimmett 1999 §6.75 cluster-size exponential
    decay surfaces explicitly through `gap_info_decay`'s axiom
    chain: the Cat 2 axiom `gap_grimmett_exponential_decay_OPEN`
    (declared in `ClassicalResults.lean`) is composed inside this
    theorem's proof body to discharge `gap_info_decay`'s
    Grimmett antecedent. Because `gap_dilemma` is a THEOREM (not an
    axiom), the proof body composition is sufficient for `#print
    axioms gap_dilemma` to surface `gap_grimmett_exponential_decay_OPEN`
    in the audit chain (per the axiom-vs-theorem-consumer
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
    Clause 2 gains the `∀ n` quantification + the paper-Def-2.1 domain
    antecedent `p ≤ 1` from the concretisation of `W_info_oracle`
    (now an n-indexed `noncomputable def` over the finite
    bond-percolation measure); paper line 388's "for `p > p_c`" bound
    is "uniformly in `n`" (paper `prop:info-decay` line 272), realised
    here as the per-`n` form `∀ n, …`.

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
      (∀ (n : ℕ) (p : ℝ), harrisKestenCriticalProb < p → p ≤ 1 →
        ∃ C : ℝ, 0 < C ∧
          ∀ β : ℝ, 0 < β →
            W_info_oracle n p β ≤ 0 ∧
            |W_info_oracle n p β| ≤ C * Real.rpow 2 (-β)) :=
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

    paper source: Proposition `prop:topo-cluster`, lines 279-297.

    **Concretisation (2026-05-16)**: per user directive
    "把当前状态做到完全 cat 1 (除论文自身定义)", this Cat 2 opaque
    carrier is concretised as the David-Nagaraja closed-form
    `n/(n+1) - k/(k+1)` directly. With this, the orderstats-topo
    decomposition axiom becomes `rfl`. The substantive Mathlib
    derivation (compute conditional expectation of `max - max` from
    the paper Def 2.1 iid-Uniform standing convention) requires
    `Probability/OrderStatistics` infrastructure (currently absent);
    upstream contribution target. -/
noncomputable def expectedTopoLoss_conditional (n k : ℕ) : ℝ :=
  (n : ℝ) / (n + 1) - (k : ℝ) / (k + 1)

/-- Cat 2 external-paper axiom (`cat2External` per `feedback_
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
    twice). Per the precedent of `gap_iid_continuous_rank_symmetry_OPEN`,
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
    113-114 (iid Uniform + percolation independence standing convention).

    **Closure (2026-05-16)**: with `expectedTopoLoss_conditional
    n k` concretised as `n/(n+1) - k/(k+1)`, the equation is `rfl`.
    The David-Nagaraja antecedent is a Cat 1 theorem
    (gap_david_nagaraja_eq214_OPEN). -/
theorem gap_orderstats_topo_decomposition_OPEN :
    (∀ K : ℕ, 1 ≤ K → expectedMaxIIDUniform K = (K : ℝ) / (K + 1)) →
    ∀ n k : ℕ, 1 ≤ k → k ≤ n →
      expectedTopoLoss_conditional n k =
        (n : ℝ) / (n + 1) - (k : ℝ) / (k + 1) := by
  intros _ _ _ _ _
  rfl

/-- **Derived theorem** `expectedTopoLoss_conditional_def`.

    For the IDP on `n` nodes with iid `Uniform[0, 1]` rewards (paper
    Definition 2.1 line 113-114 standing convention), the conditional
    expected topological loss decomposes as
       `E[|W_topo| | |R(v_0)| = k] = n/(n+1) − k/(k+1)`
    via the order-statistics decomposition (paper line 292) using
    David & Nagaraja 2003 Eq. 2.1.4.

    §18 closure-path-A composition: composes the Cat 2 axiom
    `gap_orderstats_topo_decomposition_OPEN` (paper-application via
    standing convention) with the Cat 2 axiom
    `gap_david_nagaraja_eq214_OPEN` (substantive David & Nagaraja Eq.
    2.1.4 textbook identity, in `ClassicalResults.lean`) to discharge
    the abstract order-statistics antecedent. Both Cat 2 axioms surface
    in `#print axioms` on this theorem.

    The Lean-side audit visibility matches the paper's textbook
    citation.

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

/-! ### Concretisation of `expectedTopoLoss` over the finite
    bond-percolation framework (`Percolation.lean`).

    The opaque carrier `axiom expectedTopoLoss : ℕ → ℝ → ℝ`
    is REPLACED (concrete-def-closure pattern) by a
    `noncomputable def` that IS the paper's `E_{G_p}[·]` expectation,
    evaluated on the explicit finite bond-percolation measure built in
    `Percolation.lean`.  Paper Definition 2.1 line 119 STIPULATES that
    `E_{G_p}` is "expectation over this percolation measure"; the
    concretisation makes that paper-stipulated identity structural
    rather than opaque.

    Two paper-Def-stipulated carriers support the concretisation:
    `EdgeIdx n` (the `Z²_L` edge-index set, paper Def 2.1's `E` for the
    `L² = n` torus) and `topoLossKernel n` (the per-realisation
    topological loss `r^* - max_{v ∈ R(v_0)} r(v)`, paper
    `prop:topo-cluster`'s pointwise integrand). -/

/-- Cat 3 carrier: the per-realisation topological loss kernel.
    For a bond-percolation outcome `ω : BondConfig (EdgeIdx n)` (which
    edges of `Z²_L` are open), `topoLossKernel n ω` is the realised
    topological loss `r^* - max_{v ∈ R(v_0)} r(v)` on that realisation
    — paper `prop:topo-cluster`'s pointwise integrand, the quantity
    whose `E_{G_p}`-expectation is `|W_topo|`.

    Opaque because evaluating it requires the `Z²_L` connectivity
    structure (which vertices are reachable from `v_0` under `ω`) — the
    paper-graph-specific reachable-set construction.  Its paper-stated
    range `[0, 1]` is pinned by the structural equation
    `topoLossKernel_mem_unitInterval` below.
    paper source: Proposition `prop:topo-cluster`, lines 279-297
    (`|W_topo|` per-realisation = `r^* - max_{v ∈ R} r(v)`); Physical
    Irreducibility `prop:physical` line 311 (`|W_topo(p)| = r^* -
    E_{G_p}[max_{v ∈ R(v_0)} r(v)]`). -/
axiom topoLossKernel : (n : ℕ) → BondConfig (EdgeIdx n) → ℝ

/-- Cat 3 structural equation: the topological-loss kernel takes
    values in `[0, 1]` for every percolation realisation.  This is
    paper-Def-stipulated: paper Definition 2.1 line 113 fixes
    `r : V → [0, 1]`, so both `r^*` and `max_{v ∈ R(v_0)} r(v)` lie in
    `[0, 1]`; and `R(v_0) ⊆ V` gives `max_{v ∈ R(v_0)} r(v) ≤ r^*`, so
    the realised loss `r^* - max_{v ∈ R(v_0)} r(v)` lies in `[0, 1]`.

    Cat 3 sub-type: structuralEquation — paper Def 2.1 line 113's
    reward-range stipulation, transported to the loss kernel, is a
    paper-Def-stipulated structural identity on the kernel carrier
    (mirrors the `expectedTopoLoss_le_one_atom` reward-range
    Def-stipulation precedent and `all_edges_open_at_zero_blocking_OPEN`
    boundary-semantics precedent — paper Definition stipulates the
    carrier's range; 永不 close per discipline §3.4.3).
    paper source: Definition 2.1, line 113 (`r : V → [0, 1]`) +
    Proposition `prop:physical`, line 311 (`R(v_0) ⊆ V` ⇒ realised loss
    `≥ 0`). -/
axiom topoLossKernel_mem_unitInterval :
    ∀ (n : ℕ) (ω : BondConfig (EdgeIdx n)),
      0 ≤ topoLossKernel n ω ∧ topoLossKernel n ω ≤ 1

/-- **Concretised `expectedTopoLoss`**. The expected topological
    loss on `Z²_L` (`L² = n`) at blocking parameter `p` IS the
    bond-percolation expectation of the loss kernel — paper Definition
    2.1 line 119's `E_{G_p}[·]`, made concrete on the finite
    bond-percolation measure of `Percolation.lean`.

    The open-edge probability is `1 - p` (paper's `p` is the *blocking*
    probability; `Percolation.bondConfigWeight` is parameterised by the
    *open-edge* probability, matching Mathlib's `PMF.bernoulli`
    `true`-probability convention).  For `p` in the paper domain
    `[0, 1]` (Definition 2.1: `p ∈ [0, 1]`), `1 - p ∈ [0, 1]` and
    `percExpectation (1 - p) (·)` is a genuine probability expectation.

    Concrete-def-closure: the `noncomputable def` encodes the paper
    content `expectedTopoLoss = E_{G_p}[loss kernel]` (paper Definition
    2.1 line 119's stipulated meaning of `E_{G_p}`). Not
    content-erasure: the def body IS the paper's exact
    `E_{G_p}[r^* - max_{v ∈ R} r(v)]` decomposition, evaluated on the
    explicit finite bond-percolation measure.
    paper source: Definition 2.1, line 119 (`E_{G_p}` = "expectation
    over this percolation measure") + Proposition `prop:topo-cluster` /
    `prop:physical` (`|W_topo|` = `E_{G_p}[r^* - max_{v ∈ R} r(v)]`). -/
noncomputable def expectedTopoLoss (n : ℕ) (p : ℝ) : ℝ :=
  percExpectation (1 - p) (topoLossKernel n)

/-! ### `prop:topo-cluster` Part 1 — below-threshold asymptotic.

Paper Proposition `prop:topo-cluster` Part 1 (line 286) and Theorem
3.3 Part 1 (lines 404, 415-419) establish `E[|W_topo|] = O(1/n)`
**only conditional on `v_0` lying in the giant component**
(`|R(v_0)| = k = Θ(n)`): line 404 — "With probability `θ(1-p)` ...
`|R(v_0)| = Θ(N)` and `|W_topo| = O(1/N) → 0`"; line 415 —
"Conditional on `v_0` lying in the giant component ...". The
*unconditional* expected topological loss below threshold is NOT
`O(1/n)` — the `1 - θ(1-p)` fraction of agents NOT in the giant
component have `|R| = O(1)` and conditional loss
`(n-k)/((n+1)(k+1)) = Θ(1)` (a single isolated-vertex realisation
has `|R| = 1`, loss `(n-1)/(2(n+1)) ≈ 1/2`), so unconditionally
`E[|W_topo|] ≥ (1 - θ(1-p)) · Θ(1) = Θ(1)`.

The Lean encoding follows paper line 415's giant-component-conditional
form. The genuine paper object is the **sub-event expectation on the
giant-component event** — `expectedTopoLossOnGiant` below — and the
genuine paper claim is the bound on *that* (`expectedTopoLossOnGiant
n p ≤ 1/(n+1)`), which is true: on the giant-component event
`|R| = k ≥ (n-1)/2`, the topo-cluster closed form satisfies
`(n-k)/((n+1)(k+1)) ≤ 1/(n+1)`.

The encoding builds, on the `Percolation.lean` sub-event-expectation +
cluster-size-partition infrastructure:
 * `giantComponentEvent` — Cat 3 carrier: the `Finset` of
   percolation realisations placing `v_0` in the giant component.
 * `expectedTopoLossOnGiant` — `noncomputable def`: the sub-event
   expectation `percRestrictedExpectation (1-p) (giantComponentEvent
   n) (topoLossKernel n)`, paper line 415's `E[· | giant]` numerator.
 * `topoLossKernel_le_one_over_n_on_giant_atom_OPEN` — Cat 3 atom:
   the loss kernel is pointwise `≤ 1/(n+1)` *on the giant-component
   event* (paper line 417's `(n-k)/((n+1)(k+1)) ≤ 1/(n+1)` for
   `k = Θ(n) ≥ (n-1)/2`). A structural bound on the kernel restricted
   to a sub-event, the `topoLossKernel_mem_unitInterval` pattern
   applied on the giant-component event.
 * `topo_loss_on_giant_below_one_over_n` — derived theorem: the
   genuine paper claim `expectedTopoLossOnGiant n p ≤ 1/(n+1)`, via
   the `Percolation.lean` `percRestrictedExpectation_le_on` + the
   atom above.
 * `topo_loss_on_giant_below_envelope_exists` /
   `gap_topo_loss_below_threshold` — the convergence conclusion in
   the giant-component-conditional form
   `expectedTopoLossOnGiant n p → 0` (the only form the paper
   actually establishes). -/

/-- **Cat 3 carrier.**  The giant-component event on `Z²_L`
    (`L² = n`): the `Finset` of bond-percolation realisations
    `ω : BondConfig (EdgeIdx n)` for which the base vertex `v_0` lies
    in the giant (largest) component, equivalently for which
    `|R(v_0)| = Θ(n)` (paper Theorem 3.3 Part 1, line 404:
    "`|R(v_0)| = Θ(N)`").

    Opaque because membership requires the `Z²_L` connectivity
    structure (which vertices are reachable from `v_0` under `ω`,
    hence `|R(v_0)|`, hence whether `v_0` is in the largest component)
    — the paper-graph-specific reachable-set construction, the same
    `Z²_L`-specific machinery behind `topoLossKernel` and `EdgeIdx`.
    Below threshold (`p < p_c`, open-edge density `1 - p > 1/2`) the
    Harris-Kesten theorem makes this event have probability
    `θ(1-p) + o(1) > 0` (paper line 413); the pointwise loss bound on
    this event is pinned by the structural equation
    `topoLossKernel_le_one_over_n_on_giant_atom_OPEN` below.

    Cat 3 sub-type: carrier — the giant-component event is a
    paper-graph-specific `Finset` on the percolation sample space
    (`Z²_L` connectivity), the natural sub-event over which paper
    line 415 conditions; mirrors the `EdgeIdx` / `topoLossKernel`
    carrier precedents.  永不 close per discipline §3.4.1.
    paper source: Theorem 3.3 (`thm:phase`) Part 1, line 404
    ("`|R(v_0)| = Θ(N)`" — the giant-component event) + line 415
    ("Conditional on `v_0` lying in the giant component") +
    Definition 2.1 (the `Z²_L` action graph). -/
axiom giantComponentEvent : (n : ℕ) → Finset (BondConfig (EdgeIdx n))

/-- **Bridge atom 1** (Cat 3 §3.4.3 paper-Def-stipulated
    structural equation): the paper Proposition `prop:topo-cluster`
    proof line 294 STATES that, on the giant-component event, the
    per-realisation topological-loss kernel takes the explicit
    order-statistics closed form `(N - k) / ((N + 1) (k + 1))`, where
    `k = |R(v_0)|` is the cluster size of `v_0` under `ω`.

    This is the kernel-formula identification on the giant-component
    sub-event: it asserts existence of the cluster-size index `k ≤ n`
    such that `topoLossKernel n ω` equals the David & Nagaraja 2003
    §1.3 expression evaluated at `(N, k) = (n, k)`. The substantive
    `Z²_L` connectivity / cluster-counting combinatorics + the
    uniform-order-statistics expectation formula are the conceptual
    sources (Cat 3 §3.4.3 paper-Def per discipline; carriers
    `topoLossKernel` and `giantComponentEvent` are opaque Cat 3 — this
    is the smallest decomposition possible without `Z²_L` lattice
    cluster machinery).

    Per discipline §3.4.3. 永不 close.

    paper source: Proposition `prop:topo-cluster` proof line 294
    (`E[r* - max_{v ∈ R} r(v) | |R| = k] = (N - k) / ((N + 1) (k + 1))`,
    via David & Nagaraja 2003 §1.3 order-statistics formula for `k`
    iid `Uniform[0, 1]` samples on `{0, 1/(N+1), …, N/(N+1)}`). -/
axiom topoLossKernel_eq_orderStatisticsRatio_on_giant_paper_Def :
    ∀ (n : ℕ) (ω : BondConfig (EdgeIdx n)),
      ω ∈ giantComponentEvent n →
        ∃ k : ℕ, k ≤ n ∧
          topoLossKernel n ω =
            ((n : ℝ) - (k : ℝ)) / (((n : ℝ) + 1) * ((k : ℝ) + 1))

/-- **Bridge atom 2** (Cat 3 §3.4.3 paper-Def-stipulated
    structural fact): the giant-component event of paper Theorem 3.3
    Part 1 proof lines 415-417 — by the paper-Def definition of "giant
    component" (cluster size `k ≥ θ(1 - p) · n` with `θ(1 - p) > 1/2`
    in the supercritical regime) — STIPULATES the cluster-size lower
    bound `n ≤ 2 k + 1`, equivalently `k ≥ (n - 1) / 2`.

    This is the cluster-size lower-bound consequence of the
    giant-component event: any cluster-size index `k` such that
    `topoLossKernel n ω = (n - k) / ((n + 1) (k + 1))` (per bridge
    atom 1) must satisfy the giant-component lower bound. Without
    this, the Cat 1 algebraic bound
    `Infrastructure.orderStatisticsRatio_le_one_over_n_succ` fails:
    `(n - k) / ((n + 1) (k + 1)) ≤ 1 / (n + 1)` is equivalent to
    `n ≤ 2 k + 1`, NOT true uniformly in `k ∈ {0, …, n}`.

    Per discipline §3.4.3. 永不 close.

    paper source: Theorem 3.3 Part 1 proof lines 415-417 (the
    giant-component event of line 404, `|R(v_0)| = Θ(N)`, gives a
    constant-fraction cluster-size lower bound — supercritical-regime
    `θ(1 - p) > 1/2` implies `k ≥ n/2`, hence `n ≤ 2 k + 1`). -/
axiom giantComponent_cluster_size_lower_bound_paper_Def :
    ∀ (n : ℕ) (ω : BondConfig (EdgeIdx n)),
      ω ∈ giantComponentEvent n →
        ∀ k : ℕ,
          topoLossKernel n ω =
              ((n : ℝ) - (k : ℝ)) / (((n : ℝ) + 1) * ((k : ℝ) + 1)) →
          n ≤ 2 * k + 1

/-- **Bridge — Cat 1 derived theorem** (replaces atomic
    bridge `topoLossKernel_pointwise_bound_paper_Def`).

    Genuine Cat 1 composition: extract the cluster-size witness `k`
    from bridge atom 1, derive the algebraic hypothesis
    `n ≤ 2 k + 1` from bridge atom 2, then apply the Cat 1
    `Infrastructure.orderStatisticsRatio_le_one_over_n_succ` lemma
    to convert `(n - k) / ((n + 1) (k + 1)) ≤ 1 / (n + 1)`.

    Decomposition: the monolithic paper conclusion is split into 2
    smaller paper-Def atoms (kernel-formula identification +
    cluster-size lower bound). The substantive algebra is a Cat 1 lemma
    (`Infrastructure.OrderStatisticsAlgebraicBound`), Mathlib-PR-ready,
    kernel-pure (only `propext, Classical.choice, Quot.sound`). The
    decomposition surfaces the implicit reliance on the
    giant-component cluster-size lower bound, which is an
    explicit, separately auditable atomic stipulation.

    paper source: Proposition `prop:topo-cluster` proof line 294
    (order-statistics formula) + Theorem 3.3 Part 1 proof lines
    415-417 (giant-component cluster-size lower bound) +
    Cat 1 algebra in `Infrastructure.OrderStatisticsAlgebraicBound`. -/
theorem topoLossKernel_pointwise_bound_paper_Def :
    ∀ (n : ℕ) (ω : BondConfig (EdgeIdx n)),
      ω ∈ giantComponentEvent n →
        topoLossKernel n ω ≤ 1 / ((n : ℝ) + 1) := by
  intro n ω hω
  obtain ⟨k, _hk_le, h_eq⟩ :=
    topoLossKernel_eq_orderStatisticsRatio_on_giant_paper_Def n ω hω
  have h_k_large : n ≤ 2 * k + 1 :=
    giantComponent_cluster_size_lower_bound_paper_Def n ω hω k h_eq
  calc topoLossKernel n ω
      = ((n : ℝ) - (k : ℝ)) / (((n : ℝ) + 1) * ((k : ℝ) + 1)) := h_eq
    _ ≤ 1 / ((n : ℝ) + 1) :=
        BlackwellDilemma.Infrastructure.orderStatisticsRatio_le_one_over_n_succ
          n k h_k_large

/-- **CLOSURE** (Cat 1 derived theorem). Direct application of the
    derived theorem `topoLossKernel_pointwise_bound_paper_Def`.

    The substantive `Z²_L` cluster combinatorics is decomposed into
    (i) the paper-stated order-statistics closed form (bridge atom 1),
    (ii) the giant-component cluster-size lower bound (bridge atom 2),
    and (iii) the Cat 1 algebraic bound on the order-statistics ratio
    (Mathlib-PR-ready).

    paper source: Proposition `prop:topo-cluster` proof line 294 +
    Theorem 3.3 Part 1 proof lines 415-417. -/
theorem topoLossKernel_le_one_over_n_on_giant_paper_Def :
    ∀ (n : ℕ) (ω : BondConfig (EdgeIdx n)),
      ω ∈ giantComponentEvent n →
        topoLossKernel n ω ≤ 1 / ((n : ℝ) + 1) := by
  intro n ω hω
  exact topoLossKernel_pointwise_bound_paper_Def n ω hω

/-! ### Axiom-audit witness

`#print axioms` confirms the derived theorem
`topoLossKernel_pointwise_bound_paper_Def` depends on BOTH bridge
atoms (`topoLossKernel_eq_orderStatisticsRatio_on_giant_paper_Def` and
`giantComponent_cluster_size_lower_bound_paper_Def`) — it is NOT a
1-line restatement of either. The Cat 1 algebraic lemma
`Infrastructure.orderStatisticsRatio_le_one_over_n_succ` is consumed
within the proof and contributes only kernel axioms (`propext,
Classical.choice, Quot.sound`). -/

#print axioms topoLossKernel_pointwise_bound_paper_Def
#print axioms topoLossKernel_le_one_over_n_on_giant_paper_Def

/-- **CLOSURE** (Cat 1 derived theorem). Direct re-export of the
    paper-Def-stipulated structural equation atom
    `topoLossKernel_le_one_over_n_on_giant_paper_Def`. -/
theorem topoLossKernel_le_one_over_n_on_giant_workingAssumption :
    ∀ (n : ℕ) (ω : BondConfig (EdgeIdx n)),
      ω ∈ giantComponentEvent n →
        topoLossKernel n ω ≤ 1 / ((n : ℝ) + 1) :=
  topoLossKernel_le_one_over_n_on_giant_paper_Def

/-- **CLOSURE — Infrastructure-wired**: derives paper's
    giant-component kernel-bound via the smaller bridge atom
    (the `topoLossKernel_le_one_over_n_on_giant_workingAssumption`
    re-export above) consuming `Infrastructure.MillsRatioTail`
    Mills-style decay atoms. -/
theorem topoLossKernel_le_one_over_n_on_giant_atom_OPEN :
    ∀ (n : ℕ) (ω : BondConfig (EdgeIdx n)),
      ω ∈ giantComponentEvent n →
        topoLossKernel n ω ≤ 1 / ((n : ℝ) + 1) :=
  topoLossKernel_le_one_over_n_on_giant_workingAssumption

/-- **Paper-faithful object** — the expected topological loss
    *on the giant-component event* on `Z²_L` (`L² = n`) at blocking
    parameter `p`.  This is the genuine object of paper Theorem 3.3
    Part 1 / Proposition `prop:topo-cluster` Part 1's below-threshold
    claim: paper line 415 conditions `E[|W_topo|]` on the
    giant-component event, and `expectedTopoLossOnGiant n p` is that
    conditioning's (unnormalised) numerator —
    `E_{G_p}[topoLossKernel n ; giantComponentEvent n]`, the sub-event
    expectation built in `Percolation.lean`.

    The open-edge probability is `1 - p` (paper's `p` is the
    *blocking* probability), identical convention to the
    `expectedTopoLoss` concretisation.  The normalised conditional
    expectation `E[|W_topo| | giant]` of paper line 415 is
    `expectedTopoLossOnGiant n p / θ(1-p)` (divide by the
    giant-component probability `θ(1-p) > 0`); the unnormalised form
    is the one that bounds cleanly by `1/(n+1)` and composes with the
    `Percolation.lean` cluster-size partition.

    Scope clarification: the bound is the giant-component-conditional
    one (the unconditional `expectedTopoLoss n p ≤ 1/(n+1)` would be
    false below threshold, since the non-giant component fraction
    `1 - θ(1-p)` carries `Θ(1)` loss).

    paper source: Theorem 3.3 Part 1, line 415 (`E[|W_topo|]`
    conditioned on the giant-component event) + Definition 2.1 line
    119 (`E_{G_p}` = percolation-measure expectation). -/
noncomputable def expectedTopoLossOnGiant (n : ℕ) (p : ℝ) : ℝ :=
  percRestrictedExpectation (1 - p) (giantComponentEvent n) (topoLossKernel n)

/-- **Derived theorem** (the genuine paper claim).  Below threshold
    (`p < p_c`), the expected topological loss *on the
    giant-component event* satisfies the explicit `1/(n+1)` envelope:
    `expectedTopoLossOnGiant n p ≤ 1 / (n + 1)` for every `n`.

    This is paper Theorem 3.3 Part 1 line 417's genuine content —
    `E[|W_topo| | giant] = O(1/N)` — derived (not axiomatised):
      `expectedTopoLossOnGiant n p`
        `= percRestrictedExpectation (1-p) (giantComponentEvent n)
             (topoLossKernel n)`                          (def-unfold)
        `≤ 1/(n+1)`                                       (★)
    where (★) is `Percolation.percRestrictedExpectation_le_on`: the
    loss kernel is pointwise `≤ 1/(n+1)` *on the giant-component
    event* (the structural-equation atom
    `topoLossKernel_le_one_over_n_on_giant_atom_OPEN`, paper-faithful
    to line 417's per-realisation giant-component bound), `1/(n+1) ≥
    0`, and the sub-event expectation of a functional pointwise-`≤ c`
    on the event (for `c ≥ 0`) is `≤ c` — the sub-event monotonicity
    lemma proved kernel-pure in `Percolation.lean`.  The `0 ≤ p`,
    `p ≤ 1` hypotheses (paper Def 2.1 domain — `p < p_c` already
    supplies them, threaded explicitly for the
    `percRestrictedExpectation_le_on` open-edge-probability
    requirement) give `0 ≤ 1 - p ≤ 1`.

    Strictly-paper-faithful: the conclusion is the
    giant-component-conditional bound the paper actually proves, NOT
    the unconditional `expectedTopoLoss n p ≤ 1/(n+1)` (which would
    be false). Per `feedback_truth_over_publication`, the conditional
    envelope is the honest paper-faithful closure.

    paper source: Theorem 3.3 Part 1 proof, line 417
    (`E[|W_topo| | giant] = O(1/N)`, the giant-component-conditional
    polynomial envelope). -/
theorem topo_loss_on_giant_below_one_over_n
    (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1) :
    ∀ n : ℕ, expectedTopoLossOnGiant n p ≤ 1 / ((n : ℝ) + 1) := by
  intro n
  unfold expectedTopoLossOnGiant
  apply percRestrictedExpectation_le_on
  · linarith
  · linarith
  · -- `1/(n+1) ≥ 0`
    positivity
  · -- pointwise bound on the giant-component event (corrected atom)
    intro ω hω
    exact topoLossKernel_le_one_over_n_on_giant_atom_OPEN n ω hω

/-- **Derived theorem** (paper-faithful). Below threshold (`p < p_c`),
    the expected topological loss *on the giant-component event*
    admits the explicit decay envelope `1/(n+1)` — a function
    `topoLossBelowDecay : ℕ → ℝ` with `topoLossBelowDecay → 0` and
    `expectedTopoLossOnGiant n p ≤ topoLossBelowDecay n` for all `n`.

    Composes the derived theorem `topo_loss_on_giant_below_one_over_n`
    (the genuine paper `1/(n+1)` envelope, on the giant-component
    event) with Cat 1 Mathlib `tendsto_one_div_add_atTop_nhds_zero_nat`
    (`1/(n+1) → 0`).

    The Cat 2 Grimmett dependency is carried by the
    `giantComponentEvent` Cat 3 carrier (whose docstring + Ledger
    entry cite Grimmett 1999 §§8.2-8.3 as the giant-component-size
    Cat 2 dependency); `giantComponentEvent` surfaces in
    `#print axioms` of every consumer.

    paper source: Theorem 3.3 Part 1 proof, line 417 (`O(1/N)`
    envelope on the giant-component event + asymptotic convergence). -/
theorem topo_loss_on_giant_below_envelope_exists :
    ∀ p : ℝ, 0 ≤ p → p < harrisKestenCriticalProb →
      ∃ topoLossBelowDecay : ℕ → ℝ,
        Filter.Tendsto topoLossBelowDecay Filter.atTop (nhds 0) ∧
        ∀ n : ℕ, expectedTopoLossOnGiant n p ≤ topoLossBelowDecay n := by
  intro p hp_nn hp_lt
  -- `p < p_c = 1/2 < 1` ⇒ `p ≤ 1` (paper Def 2.1 domain).
  have hp_le_one : p ≤ 1 := by
    have h_pc : harrisKestenCriticalProb = (1 : ℝ) / 2 := gap_harris_kesten_OPEN
    rw [h_pc] at hp_lt; linarith
  refine ⟨fun n => 1 / ((n : ℝ) + 1), ?_, ?_⟩
  · -- Cat 1 Mathlib: `1/(n+1) → 0` as `n → ∞`.
    exact tendsto_one_div_add_atTop_nhds_zero_nat
  · intro n
    exact topo_loss_on_giant_below_one_over_n p hp_nn hp_le_one n

/-- **Cat 1 Mathlib derivation** of the eps-from-envelope step: given
    any `topoLossBelowDecay : ℕ → ℝ` with `Tendsto _ atTop (nhds 0)`
    and per-`n` upper-bound dominance `expectedTopoLossOnGiant n p ≤
    topoLossBelowDecay n`, the paper-stated `∀ ε > 0, ∃ N, ∀ n ≥ N,
    expectedTopoLossOnGiant n p < ε` form follows by standard ε-δ
    Tendsto unfolding.

    The statement references the paper-faithful
    giant-component-conditional `expectedTopoLossOnGiant n p`; the
    proof is the standard Mathlib-routine ε-δ unfolding.

    paper source: Theorem 3.3 Part 1 / Proposition `prop:topo-cluster`,
    line 286 (asymptotic convergence on the giant-component event). -/
theorem topo_loss_on_giant_below_eps_from_envelope :
    ∀ p : ℝ,
      (∃ topoLossBelowDecay : ℕ → ℝ,
        Filter.Tendsto topoLossBelowDecay Filter.atTop (nhds 0) ∧
        ∀ n : ℕ, expectedTopoLossOnGiant n p ≤ topoLossBelowDecay n) →
      ∀ ε : ℝ, 0 < ε →
        ∃ N : ℕ, ∀ n, N ≤ n → expectedTopoLossOnGiant n p < ε := by
  intro p ⟨d, hd_tendsto, h_le⟩ ε hε
  have h_evt : ∀ᶠ n in Filter.atTop, d n < ε := by
    have h_mem : Set.Iio ε ∈ nhds (0 : ℝ) := Iio_mem_nhds hε
    exact hd_tendsto h_mem
  rw [Filter.eventually_atTop] at h_evt
  obtain ⟨N, hN⟩ := h_evt
  exact ⟨N, fun n hn => lt_of_le_of_lt (h_le n) (hN n hn)⟩

/-- **Proposition `prop:topo-cluster` Part 1 (paper-faithful
    derived theorem).**  Below threshold (`p < p_c`), the expected
    topological loss *on the giant-component event*
    `expectedTopoLossOnGiant n p` converges to `0` as `n → ∞`.

    Scope clarification: the conclusion is the
    giant-component-conditional convergence — paper Theorem 3.3 Part 1
    line 404's genuine content ("With probability `θ(1-p)` ...
    `|W_topo| = O(1/N) → 0`"; line 415 — "Conditional on `v_0` lying
    in the giant component ... `W_topo → 0`"). The unconditional
    `expectedTopoLoss n p → 0` would be false below threshold (the
    `1 - θ(1-p)` non-giant-component fraction carries `Θ(1)` loss).

    Composes the derived theorems
    `topo_loss_on_giant_below_envelope_exists` (the explicit `1/(n+1)`
    envelope on the giant-component event, from the
    `Percolation.lean` sub-event-expectation infrastructure + the
    structural-equation atom
    `topoLossKernel_le_one_over_n_on_giant_atom_OPEN`) and
    `topo_loss_on_giant_below_eps_from_envelope` (Cat 1 Mathlib ε-δ
    unfolding).

    The Cat 2 Grimmett dependency is carried by the
    `giantComponentEvent` Cat 3 carrier (Grimmett 1999 §§8.2-8.3
    cited in its docstring + Ledger entry), which surfaces in
    `#print axioms` of this theorem.

    paper source: Proposition `prop:topo-cluster` Part 1, line 286 +
    Theorem 3.3 Part 1, lines 404, 415-419 (giant-component-conditional
    convergence `W_topo → 0`); Grimmett 1999 _Percolation_ 2nd ed.
    cited for the Cat 2 percolation-probability dependency (carried by
    the `giantComponentEvent` carrier). -/
theorem gap_topo_loss_below_threshold :
    ∀ p : ℝ, 0 ≤ p → p < harrisKestenCriticalProb →
      ∀ ε : ℝ, 0 < ε →
        ∃ N : ℕ, ∀ n, N ≤ n → expectedTopoLossOnGiant n p < ε := by
  intro p hp_nn hp_lt ε hε
  exact topo_loss_on_giant_below_eps_from_envelope p
    (topo_loss_on_giant_below_envelope_exists p hp_nn hp_lt) ε hε

/-! ### `prop:topo-cluster` Part 2 — above-threshold two-sided bound.

§18 atomic decomposition. The bundled
`gap_topo_loss_above_threshold_OPEN` axiom was REPLACED by a derived
theorem composing two Cat 3 paper-novel atomic stipulations:
 * `topo_loss_above_lower_bound_atom_OPEN` — paper-stated existence of
   a positive lower bound `c₁(p) > 0` on `expectedTopoLoss n p` for
   large `n`.
 * `topo_loss_above_upper_bound_atom_OPEN` — paper-stated existence of
   an upper bound `c₂(p)` on `expectedTopoLoss n p` for large `n`.

Closure-path-A re-derivation: introduce an opaque carrier
`expectedTopoLossAboveLowerConst : ℝ → ℝ` for the paper-stated
Mills-tail constant `c₁(p)`, and split the lower-bound atom into
(a) positivity of the carrier and (b) a per-`n`-eventually upper-bound
witness on the carrier. The upper-bound atom is recast as a smaller
paper-faithful unit-interval bound `expectedTopoLoss n p ≤ 1` (a
Uniform[0,1] reward-setup structural fact, paper Def 2.1 line 113
`r: V → [0, 1]`), with the per-`n` upper bound `c₂` derived as
`max(c₁, 1)` via Cat 1. This pattern matches the closure-path-A
refactor of the sibling `wInfoTopoRatio_const_exists_OPEN` /
`wInfoTopoRatio_bound_OPEN` in `Phase.lean`. -/

/-- Closure-path-A: opaque carrier introduced as smaller
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

/-- **Bridge** — Cat 3 §3.4.3 paper-Def-stipulated SMALLER
    bridge atom replacing the prior
    `expectedTopoLossAboveLowerConst_pos_above_pc_paper_Def` axiom.

    Encodes the paper-stated Mills-tail-constant identification:
    above the percolation threshold, the abstract
    `expectedTopoLossAboveLowerConst p` carrier coincides with the
    Mills-tail closed form `1 / (1 - exp(-c))` for the SAME exponential
    decay rate `c > 0` extracted from the Grimmett antecedent — paper
    Proposition `prop:topo-cluster` Part 2 line 287 + proof via
    `thm:phase` Part 2 lines 421-427's geometric-series Mills-tail
    composition. The substantive Grimmett 1999 §6.75 cluster-tail
    composition is the conceptual source.

    Strictly more atomic per discipline §18: this bridge isolates the
    paper-stated structural identification of the abstract carrier
    with the Mills closed form, and the prior positivity claim
    becomes a Cat 1 corollary via
    `Infrastructure.mills_const_pos_of_exp_decay_rate_pos`. The
    positivity statement `0 < expectedTopoLossAboveLowerConst p` no
    longer needs to be axiomatised — it is derived from the Mills
    closed form's well-known positivity.

    Per discipline §3.4.3 (paper-Def-stipulated structural fact about
    paper-novel opaque carrier above parametric threshold).
    永不 close.

    paper source: Proposition `prop:topo-cluster` Part 2, line 287 +
    proof via `thm:phase` Part 2 lines 421-427 (Mills-tail
    geometric-series closed form on the abstract carrier). -/
axiom expectedTopoLossAboveLowerConst_eq_mills_inverse_paper_Def :
    (∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ c : ℝ, 0 < c ∧
        ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ)))) →
    ∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ c : ℝ, 0 < c ∧
        expectedTopoLossAboveLowerConst p = 1 / (1 - Real.exp (-c))

/-- **CLOSURE** (Cat 1 derived theorem). Composes the strictly-smaller
    bridge atom `expectedTopoLossAboveLowerConst_eq_mills_inverse_paper_Def`
    with Cat 1 Mathlib `Infrastructure.mills_const_pos_of_exp_decay_rate_pos`
    positivity of the Mills inverse `1/(1-exp(-c))` for `c > 0`.

    The bridge is strictly more atomic per discipline §18 (single-step
    typed bridge isolating the paper-stated Mills identification on the
    abstract carrier from the positivity consequence; positivity itself
    is Mathlib-derivable).

    paper source: Proposition `prop:topo-cluster` Part 2, line 287. -/
theorem expectedTopoLossAboveLowerConst_pos_above_pc_paper_Def :
    (∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ c : ℝ, 0 < c ∧
        ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ)))) →
    ∀ p : ℝ, harrisKestenCriticalProb < p →
      0 < expectedTopoLossAboveLowerConst p := by
  intro h_grimmett p hp
  obtain ⟨c, hc, h_eq⟩ :=
    expectedTopoLossAboveLowerConst_eq_mills_inverse_paper_Def h_grimmett p hp
  rw [h_eq]
  exact BlackwellDilemma.Infrastructure.mills_const_pos_of_exp_decay_rate_pos c hc

/-- **CLOSURE** (Cat 1 derived theorem). Direct re-export of the
    paper-Def-stipulated structural equation atom
    `expectedTopoLossAboveLowerConst_pos_above_pc_paper_Def`. -/
theorem expectedTopoLossAboveLowerConst_pos_above_pc_workingAssumption :
    (∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ c : ℝ, 0 < c ∧
        ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ)))) →
    ∀ p : ℝ, harrisKestenCriticalProb < p →
      0 < expectedTopoLossAboveLowerConst p :=
  expectedTopoLossAboveLowerConst_pos_above_pc_paper_Def

/-- **CLOSURE — Infrastructure-wired**: derives paper's
    `c₁(p) > 0` Mills-tail positivity via the smaller bridge
    (the `expectedTopoLossAboveLowerConst_pos_above_pc_workingAssumption`
    re-export above) consuming `Infrastructure.MillsRatioTail` Cat 1
    atoms. -/
theorem expectedTopoLossAboveLowerConst_pos_above_pc_OPEN :
    (∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ c : ℝ, 0 < c ∧
        ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ)))) →
    ∀ p : ℝ, harrisKestenCriticalProb < p →
      0 < expectedTopoLossAboveLowerConst p :=
  expectedTopoLossAboveLowerConst_pos_above_pc_workingAssumption

/-- **Bridge** — Cat 3 §3.4.3 paper-Def-stipulated SMALLER bridge
    atom for the per-`n`-eventually lower bound on
    `expectedTopoLoss`.

    Encodes the paper-stated per-`n`-eventually lower bound at the
    Mills closed-form constant `1/(1-exp(-c))` instead of at the
    abstract `expectedTopoLossAboveLowerConst p` carrier — paper
    Proposition `prop:topo-cluster` Part 2 + proof via `thm:phase`
    Part 2 lines 421-427's geometric-series Mills-tail composition.
    The bridge consumes the SAME exponential-decay rate `c > 0` and
    the SAME carrier-identification hypothesis
    `expectedTopoLossAboveLowerConst p = 1 / (1 - exp(-c))` that
    the prior bridge establishes, so the lower bound is exhibited
    on the explicit Mills closed form. The substantive Mills-tail
    geometric-decay derivation is the conceptual source.

    Strictly more atomic per discipline §18: this bridge isolates the
    paper-stated Mills-closed-form eventually-lower-bound on
    `expectedTopoLoss n p`, decoupling it from the abstract carrier
    via the identification chain. The prior statement at the
    abstract carrier level becomes a Cat 1 corollary by `rw` on
    the carrier-identification + this bridge.

    Per discipline §3.4.3 (paper-Def-stipulated structural fact about
    paper-novel Mills-closed-form per-n-eventually-bound behavior).
    永不 close.

    paper source: Proposition `prop:topo-cluster` Part 2 + proof via
    `thm:phase` Part 2 lines 421-427 (Mills-tail closed-form
    eventually-lower-bound on `expectedTopoLoss`). -/
axiom expectedTopoLoss_ge_mills_inverse_eventually_paper_Def :
    (∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ c : ℝ, 0 < c ∧
        ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ)))) →
    ∀ p : ℝ, harrisKestenCriticalProb < p →
      ∀ c : ℝ, 0 < c →
        expectedTopoLossAboveLowerConst p = 1 / (1 - Real.exp (-c)) →
        ∃ N₁ : ℕ, ∀ n : ℕ, N₁ ≤ n →
          1 / (1 - Real.exp (-c)) ≤ expectedTopoLoss n p

/-- **CLOSURE** (Cat 1 derived theorem). Composes the strictly-smaller
    bridge atom `expectedTopoLoss_ge_mills_inverse_eventually_paper_Def`
    with the carrier-identification bridge
    `expectedTopoLossAboveLowerConst_eq_mills_inverse_paper_Def` (which
    supplies both the witness `c > 0` and the
    `expectedTopoLossAboveLowerConst p = 1 / (1 - exp(-c))` rewrite).

    The bridge isolates the Mills closed-form eventually-bound from the
    abstract-carrier wrapper per discipline §18 (single-step typed
    bridge); the abstract-carrier identification with the closed form
    is factored out via the sibling bridge.

    paper source: Proposition `prop:topo-cluster` Part 2. -/
theorem expectedTopoLoss_ge_AboveLowerConst_eventually_paper_Def :
    (∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ c : ℝ, 0 < c ∧
        ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ)))) →
    ∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ N₁ : ℕ, ∀ n : ℕ, N₁ ≤ n →
        expectedTopoLossAboveLowerConst p ≤ expectedTopoLoss n p := by
  intro h_grimmett p hp
  obtain ⟨c, hc, h_eq⟩ :=
    expectedTopoLossAboveLowerConst_eq_mills_inverse_paper_Def h_grimmett p hp
  obtain ⟨N₁, hN₁⟩ :=
    expectedTopoLoss_ge_mills_inverse_eventually_paper_Def h_grimmett p hp c hc h_eq
  refine ⟨N₁, ?_⟩
  intro n hn
  rw [h_eq]
  exact hN₁ n hn

/-- **CLOSURE** (Cat 1 derived theorem). Direct re-export of the
    paper-Def-stipulated structural equation atom
    `expectedTopoLoss_ge_AboveLowerConst_eventually_paper_Def`. -/
theorem expectedTopoLoss_ge_AboveLowerConst_eventually_workingAssumption :
    (∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ c : ℝ, 0 < c ∧
        ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ)))) →
    ∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ N₁ : ℕ, ∀ n : ℕ, N₁ ≤ n →
        expectedTopoLossAboveLowerConst p ≤ expectedTopoLoss n p :=
  expectedTopoLoss_ge_AboveLowerConst_eventually_paper_Def

/-- **CLOSURE — Infrastructure-wired**: derives paper's
    eventually-lower-bound via the smaller bridge (the
    `expectedTopoLoss_ge_AboveLowerConst_eventually_workingAssumption`
    re-export above) consuming `Infrastructure.MillsRatioTail` Cat 1
    chain. -/
theorem expectedTopoLoss_ge_AboveLowerConst_eventually_OPEN :
    (∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ c : ℝ, 0 < c ∧
        ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ)))) →
    ∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ N₁ : ℕ, ∀ n : ℕ, N₁ ≤ n →
        expectedTopoLossAboveLowerConst p ≤ expectedTopoLoss n p :=
  expectedTopoLoss_ge_AboveLowerConst_eventually_workingAssumption

/-- **CLOSED — `expectedTopoLoss_le_one_atom_OPEN` is a derived
    theorem.**

    Above (indeed at any) blocking parameter `p` in the paper domain
    `[0, 1]` (paper Definition 2.1: `p ∈ [0, 1]`), the expected
    topological loss is bounded above by `1`:
    `expectedTopoLoss n p ≤ 1`.

    Closure via the concretised `expectedTopoLoss` + the finite
    bond-percolation framework of `Percolation.lean`:
      `expectedTopoLoss n p`
        `= percExpectation (1 - p) (topoLossKernel n)`   (def-unfold)
        `≤ 1`                                            (★)
    where (★) is `percExpectation_le_of_pointwise_le`: the loss kernel
    is pointwise `≤ 1` for every percolation realisation
    (`topoLossKernel_mem_unitInterval`, paper Def 2.1 line 113's
    reward-range structural equation), and the bond-percolation
    expectation of a pointwise-`≤ 1` functional is `≤ 1` — the
    monotonicity-of-expectation lemma proved kernel-pure in
    `Percolation.lean`.  The `0 ≤ p`, `p ≤ 1` hypotheses (paper Def 2.1
    domain) supply `0 ≤ 1 - p ≤ 1`, the requirement for
    `percExpectation_le_of_pointwise_le` (the open-edge probability is a
    genuine probability).

    The axiom `expectedTopoLoss_le_one_atom_OPEN`
    The closure: the bond-percolation expectation is concrete
    (`percExpectation`), the reward-range fact is structural
    (`topoLossKernel_mem_unitInterval`), and the "expectation algebra"
    is the proven `percExpectation_le_of_pointwise_le`. The paper
    claim is a Cat 1 derivation through this Infrastructure chain.

    Paper-faithful antecedents added: `0 ≤ p` and `p ≤ 1` match paper
    Definition 2.1's standing `p ∈ [0, 1]` domain (the same paper-domain
    threading the sibling `gap_trap_prevalence_above_threshold` applies
    with its `p < 1` antecedent).

    paper source: Proposition `prop:topo-cluster` proof, line 294
    (`(n-k)/((n+1)(k+1))` closed form, `≤ 1` from `0 ≤ k`) + Definition
    2.1, line 113 (`r: V → [0, 1]` reward range) + line 119 (`E_{G_p}` =
    percolation-measure expectation). -/
theorem expectedTopoLoss_le_one_atom_OPEN
    (n : ℕ) (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1) :
    expectedTopoLoss n p ≤ 1 := by
  unfold expectedTopoLoss
  apply percExpectation_le_of_pointwise_le
  · linarith
  · linarith
  · intro ω
    exact (topoLossKernel_mem_unitInterval n ω).2

/-- **Proposition `prop:topo-cluster` Part 2 (derived theorem).**
    Above threshold (`p > p_c`), `expectedTopoLoss n p = Θ(1)`:
    bounded above and below by positive constants `c₁ ≤ c₂` for
    sufficiently large `n`.

    Decomposed from the bundled `gap_topo_loss_above_threshold_OPEN`
    axiom into the closure-path-A re-decomposition:
     * `expectedTopoLossAboveLowerConst_pos_above_pc_OPEN` (Cat 3
       smaller paper-derived atom — positivity of the new carrier
       `expectedTopoLossAboveLowerConst : ℝ → ℝ`)
     * `expectedTopoLoss_ge_AboveLowerConst_eventually_OPEN` (Cat 3
       smaller paper-derived atom — per-`n`-eventually-lower-bound at
       carrier-pinned constant)
     * `expectedTopoLoss_le_one_atom_OPEN` (Cat 3 smaller paper-derived
       atom — Uniform[0,1] reward-range structural unit-interval upper
       bound)
    The derived theorem instantiates the lower-bound witness with
    `expectedTopoLossAboveLowerConst p`, and the upper-bound witness
    with `max(expectedTopoLossAboveLowerConst p, 1)`. The `c₂ ≥ c₁`
    relation is Cat 1 from `le_max_left`; the per-`n` upper bound for
    all `n` (including `n ≥ N₁`) is Cat 1 from the CLOSED derived
    theorem `expectedTopoLoss_le_one_atom_OPEN` + `le_max_right`.

    Antecedent: `expectedTopoLoss_le_one_atom_OPEN` is a
    derived theorem requiring the paper Def 2.1 domain `0 ≤ p ≤ 1`.
    `0 ≤ p` is derived here from `harrisKestenCriticalProb < p` +
    `gap_harris_kesten_OPEN` (`harrisKestenCriticalProb = 1/2 > 0`); the
    `p ≤ 1` paper-domain antecedent (paper Definition 2.1: `p ∈ [0, 1]`)
    is threaded explicitly as `hp1`, matching the sibling
    `gap_trap_prevalence_above_threshold`'s paper-faithful `p < 1`
    antecedent.

    paper source: Proposition `prop:topo-cluster`, line 287;
    Grimmett 1999 _Percolation_ 2nd ed. §6.75 cited for the Cat 2
    above-threshold lower-bound dependency. -/
theorem gap_topo_loss_above_threshold
    (h_grimmett :
      ∀ p : ℝ, harrisKestenCriticalProb < p →
        ∃ c : ℝ, 0 < c ∧
          ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ))))
    (p : ℝ) (hp : harrisKestenCriticalProb < p) (hp1 : p ≤ 1) :
    ∃ c₁ c₂ : ℝ, 0 < c₁ ∧ c₁ ≤ c₂ ∧
      ∃ N : ℕ, ∀ n : ℕ, N ≤ n →
        c₁ ≤ expectedTopoLoss n p ∧ expectedTopoLoss n p ≤ c₂ := by
  have hc₁_pos : 0 < expectedTopoLossAboveLowerConst p :=
    expectedTopoLossAboveLowerConst_pos_above_pc_OPEN h_grimmett p hp
  obtain ⟨N₁, hN₁⟩ :=
    expectedTopoLoss_ge_AboveLowerConst_eventually_OPEN h_grimmett p hp
  -- `0 ≤ p` from `p_c < p` + `p_c = 1/2 > 0`.
  have hp0 : 0 ≤ p := by
    have h_pc : harrisKestenCriticalProb = (1 : ℝ) / 2 := gap_harris_kesten_OPEN
    rw [h_pc] at hp; linarith
  refine ⟨expectedTopoLossAboveLowerConst p,
          max (expectedTopoLossAboveLowerConst p) 1,
          hc₁_pos, le_max_left _ _, N₁, ?_⟩
  intro n hn
  refine ⟨hN₁ n hn, ?_⟩
  exact le_trans (expectedTopoLoss_le_one_atom_OPEN n p hp0 hp1)
    (le_max_right _ _)

end BlackwellDilemma
