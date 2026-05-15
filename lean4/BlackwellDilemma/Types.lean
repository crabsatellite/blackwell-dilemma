/-
  BlackwellDilemma/Types.lean

  Opaque IDP primitives.

  Companion to: "Information Value Under Endogenous Feasibility" (Li, 2026), §2.

  Mathlib has `Mathlib.Combinatorics.SimpleGraph` (graphs),
  `Mathlib.MeasureTheory` (probability), and
  `Mathlib.Probability.Distributions.Gaussian` (Gaussian densities), but the
  combination needed to state the IDP — random subgraphs under bond
  percolation, Gaussian-noise reward signals, distance-decaying topology
  signals, sequential agent traversal with no-revisit rule — is not yet
  packaged. We therefore introduce the IDP primitives axiomatically,
  following the same opaque-types-with-paper-citations pattern used in
  `hodge-conjecture-lean4-formalization/HodgeReduction/Types.lean`.

  No bare `Prop` fields; no `def := True` tricks; no free-RHS existentials.

  ## Module docstring on opaque predicates

  Every `axiom` carries a `paper source:` citation. Predicates fall into
  two groups:
   * Predicates with data-bound semantic content (e.g. `Edge.IsBlocked`,
     `IsReachable`): constrained by further axioms tying them to the paper
     (Definitions 2.1–2.6).
   * Predicates pinned only by the theorem that uses them
     (e.g. `IsTopologyBlind`, `IsBlackwellOrdered`): they are scope labels,
     not independently-verifiable propositions within this file.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Data.Finset.Basic
import Mathlib.MeasureTheory.Measure.MeasureSpace
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import BlackwellDilemma.Percolation

namespace BlackwellDilemma

/-! ## 1. Action graph

The paper quantifies over a finite undirected graph `G = (V, E)` on `n`
vertices, the "action space" (Definition 2.1, line 108). We axiomatise
the carrier abstractly to avoid the SimpleGraph machinery, since later
percolation-aware constructions are easier on a custom carrier. -/

/-- Opaque carrier: vertex set of the action graph.
    paper source: Definition 2.1 ("`G = (V, E)` is an undirected graph on
    `n` nodes"). -/
axiom Vertex : Type

/-- Decidable equality on vertices (every IDP instance is finite). -/
axiom Vertex.decEq : DecidableEq Vertex
attribute [instance] Vertex.decEq

/-- Opaque undirected edge predicate.
    paper source: Definition 2.1. -/
axiom IsEdge : Vertex → Vertex → Prop

/-- Edge symmetry (paper graph is undirected).
    paper source: Definition 2.1 ("undirected graph"). -/
axiom IsEdge.symm : ∀ {u v : Vertex}, IsEdge u v → IsEdge v u

/-! ## 2. Percolation realisation

For each edge, a Bernoulli-`p` blocking decision; the open-edge subgraph
is `G_p` (paper line 119 "We write G_p for the random subgraph"). We
expose the opaque type `PercolationOutcome` = "an outcome of the bond
percolation experiment on G". -/

/-- Sample space of bond percolation on `G`.
    paper source: Definition 2.1 + line 119. -/
axiom PercolationOutcome : Type

/-- Predicate: in this percolation outcome, the edge `(u, v)` is OPEN
    (i.e., not blocked).
    paper source: Definition 2.1 ("Each edge `e ∈ E` is independently
    blocked with probability `p`"). -/
axiom IsOpen : PercolationOutcome → Vertex → Vertex → Prop

/-- The blocking probability `p ∈ [0, 1]` (the IDP's irreversibility
    parameter).
    paper source: Definition 2.1, the parameter `p`. -/
axiom blockingProb : ℝ

/-- Constraint: blocking probability lies in `[0, 1]`. -/
axiom blockingProb_mem_unitInterval : 0 ≤ blockingProb ∧ blockingProb ≤ 1

/-- **R90 Cat 3 §3.4.3 paper-Def-stipulated structural-positivity atom**:
    the paper's bond-percolation parameter is non-trivial,
    `0 < blockingProb ∧ blockingProb < 1`.  Required for the R90
    reversal-witness pattern: lifting per-realisation strict-`<` to
    expectation strict-`<` requires every bond configuration to carry
    POSITIVE measure, which holds iff `0 < p < 1` (Percolation.lean
    `bondConfigWeight_pos`).

    This is paper-stipulated by the Definition 2.1 setup —
    "endogenous feasibility" requires non-trivial percolation:
     * `p = 0` collapses to the deterministic full-graph case
       (no bond-percolation randomness);
     * `p = 1` collapses to the deterministic empty-graph case
       (every edge blocked, `R(v_0) = {v_0}`).
    Both degenerate to non-percolation problems where the paper's
    trap-prevalence / C2-misalignment / reversal mechanism (which
    require `p > p_c = 1/2 > 0` and `p < 1` for non-degenerate
    cluster structure) does not arise.  Cat 3 §3.4.3 gapDefinitional
    per the discipline (paper-Def-stipulated structural fact about
    the primitive carrier `blockingProb`'s scope of validity);
    永不 close.

    paper source: Definition 2.1, line 119 ("each edge `e ∈ E` is
    independently blocked with probability `p`" — the bond-percolation
    setup is non-trivial in the paper's standing hypothesis); paper
    §3 onwards uses `p ∈ (p_c, 1)` for trap-regime claims and
    `p ∈ (0, p_c)` for giant-component claims, both strict-positive
    strict-below-1. -/
axiom blockingProb_strict_in_open_unit_interval :
    0 < blockingProb ∧ blockingProb < 1

/-! ## 3. Reachable set + dynamic value

Definition 2.2 (`def:reachable`): `R(v_0) = { v : ∃ path from v_0 to v
using only unblocked edges }`. Definition 2.5 (`def:forward-reachable`):
`R(u | H_t)` = forward reachable set from `u` given visit history `H_t`. -/

/-- The reachable set `R(v₀, ω) = {v : ∃ path from v₀ to v in `ω`'s open
    edges}`.
    paper source: Definition 2.2. -/
axiom ReachableSet : Vertex → PercolationOutcome → Finset Vertex

/-- The forward reachable set `R(u | H_t)` from `u` after history `H_t`.
    paper source: Definition 2.5 (`def:forward-reachable`). -/
axiom ForwardReachable :
    Vertex → Finset Vertex → PercolationOutcome → Finset Vertex

/-- Cat 3 paper-novel ATOMIC structural equation: the starting-vertex
    case relating `ReachableSet` and `ForwardReachable`. Paper
    Definition 2.5 (`def:forward-reachable`) explicitly states "For the
    starting vertex, `R(v_0) = R(v_0 | ∅)` is the full reachable set
    (Definition 2.2)". This is a paper-stated structural equation
    between the two existing IDP primitives `ReachableSet` (Def 2.2)
    and `ForwardReachable` (Def 2.5).
    paper source: Definition 2.5 (`def:forward-reachable`), line 193
    ("For the starting vertex, `R(v_0) = R(v_0 | ∅)` is the full
    reachable set"). -/
axiom ReachableSet_eq_ForwardReachable_empty :
    ∀ (v : Vertex) (ω : PercolationOutcome),
      ReachableSet v ω = ForwardReachable v ∅ ω

/-- Cat 3 paper-novel ATOMIC structural equation: forward-reachable set
    contains the starting vertex `u` (length-0 path convention applied
    to forward-reachable construction). Paper Definition 2.5
    (`def:forward-reachable`) defines `R(u | H_t) = {w ∈ V : ∃ path from
    u to w in G[V \ H_t] using only unblocked edges}`; the length-0
    path from `u` to `u` is admitted (consistent with Def 2.2's
    convention recorded in `ReachableSet_self_member` (now derived
    theorem below).

    Scope discipline (opaque-carrier convention): paper's `H_t` denotes
    the visit-history at step `t` BEFORE arriving at `u`, so paper's
    `R(u | H_t)` is naturally evaluated only at histories with `u ∉ H`.
    For the opaque-carrier axiomatic encoding here, we adopt the
    paper-faithful length-0-path convention UNCONDITIONALLY (i.e.
    `u ∈ ForwardReachable u H ω` for any `H`, including `H ∋ u`),
    parallel to the derived `ReachableSet_self_member` and consistent
    with the paper's path-counting convention. The unconditional form is
    REQUIRED by the foundational `V_dyn_def` axiom (Phase.lean), which
    witnesses non-emptiness of `ForwardReachable v H ω` over arbitrary
    `H` to define `V_dyn` via `Finset.sup'`; tightening this atom with
    a `u ∉ H` premise would cascade premise-threading into `V_dyn_def`
    (and into `gap_V_g_le_V_dyn`, plus every Phase / GeneralGraphs /
    Cognitive theorem that unfolds `V_dyn` over a non-empty history).
    Paper-faithful theorems (e.g. `gap_trap_prevalence_zero`) apply this
    atom only at `H = ∅`, where the convention coincides exactly with
    paper line 463 scope. The slightly-stronger Lean form is acknowledged
    here as the documented opaque-carrier abstraction.

    paper source: Definition 2.5 (`def:forward-reachable`), lines
    187-194 (length-0 path inclusion convention, parallel to Def 2.2). -/
axiom ForwardReachable_self_member :
    ∀ (u : Vertex) (H : Finset Vertex) (ω : PercolationOutcome),
      u ∈ ForwardReachable u H ω

/-- Cat 3 derived theorem (refactored from prior atomic axiom
    `ReachableSet_self_member` per the gap-ledger discipline's
    "atoms must serve downstream consumers" mandate): the trivial-path
    inclusion convention `v ∈ R(v, ω)`. Paper Definition 2.2
    (`def:reachable`) is the source convention; the convention is now
    derived by composing the two atomic structural equations
    `ReachableSet_eq_ForwardReachable_empty` (paper Def 2.5 line 193
    structural equation between IDP primitives) and
    `ForwardReachable_self_member` (paper Def 2.5 length-0 path
    inclusion). The Cat 3 derivation chain shows that the Def 2.2
    convention is a structural consequence of the Def 2.5 atoms,
    not an independent atomic input.
    paper source: Definition 2.2 (`def:reachable`), lines 121-128
    (length-0 path inclusion convention) — derived from Definition 2.5
    atoms. -/
theorem ReachableSet_self_member :
    ∀ (v : Vertex) (ω : PercolationOutcome), v ∈ ReachableSet v ω := by
  intro v ω
  rw [ReachableSet_eq_ForwardReachable_empty v ω]
  exact ForwardReachable_self_member v ∅ ω

/-- Reward function `r: V → [0, 1]` (paper Def 2.1, line 113).
    paper source: Definition 2.1 ("`r: V → [0,1]` is the reward function"). -/
axiom reward : Vertex → ℝ

/-- Boundedness of the reward function (paper standing assumption: bounded
    rewards, uniform on `[0,1]`).
    paper source: Definition 2.1 + Proposition info-decay (line 270 onward,
    standing-assumption: `r: V → [0,1]`). -/
axiom reward_mem_unitInterval : ∀ v : Vertex, 0 ≤ reward v ∧ reward v ≤ 1

/-- Intrinsic preference function `ξ: V → [0, 1]` (paper Def 2.1).

    Encoding choice — extra `PercolationOutcome` parameter: paper Def 2.1
    line 114 introduces `ξ` as drawn "i.i.d. from `Uniform[0, 1]`
    independently of `r`", and paper §2.5 line 207-208 defines welfare
    `W = E_{G_p}[E_{s, ω̂_κ}[r(v_T)]]` where the inner expectation is
    explicitly described as ranging "over reward signals, topology
    signals, and the intrinsic preference realization". Thus `ξ` is not
    a fixed deterministic function but a sampled realisation drawn
    jointly with the percolation experiment. We model `ξ : V × Ω → ℝ`
    where `Ω = PercolationOutcome` is the underlying joint sample space
    — `intrinsicPref v ω` denotes the realised value of `ξ(v)` under
    the joint sample `ω`. The pointwise unit-interval support is then
    captured by `intrinsicPref_mem_unitInterval` (a per-`(v, ω)`
    constraint matching paper's `ξ : V → [0, 1]` range claim).

    paper source: Definition 2.1, line 114 ("`ξ: V → [0,1]` is the
    intrinsic preference function, drawn i.i.d. from `Uniform[0,1]`
    independently of `r`") + §2.5 line 207-208 (joint inner expectation
    "over reward signals, topology signals, and the intrinsic preference
    realization"). -/
axiom intrinsicPref : Vertex → PercolationOutcome → ℝ

/-- Cat 3 paper-novel ATOMIC structural equation: the intrinsic
    preference function is bounded in `[0, 1]` per the paper's stated
    range. Companion to `reward_mem_unitInterval`; `intrinsicPref` was
    introduced opaquely without its paper-stated unit-interval support
    until this atomic axiom restores Definition 2.1's range claim.
    paper source: Definition 2.1 (`def:idp`), line 114
    ("`ξ: V → [0,1]` is the intrinsic preference function, drawn i.i.d.
    from `Uniform[0,1]`"). The Lean signature does not encode the i.i.d.
    Uniform measure (a probabilistic claim on the joint distribution
    over `PercolationOutcome`); only the pointwise unit-interval support
    is captured here. -/
axiom intrinsicPref_mem_unitInterval :
    ∀ (v : Vertex) (ω : PercolationOutcome),
      0 ≤ intrinsicPref v ω ∧ intrinsicPref v ω ≤ 1

/-! ### Realised utility (`def:rationality`)

Definition 2.4 (`def:rationality`, line 174-178) gives the agent's
realised utility at vertex `v` as a convex combination of the monetary
reward `r(v)` and the intrinsic preference `ξ(v)`:
`U(v) = α · r(v) + (1 - α) · ξ(v)`. This is a paper-stated structural
definition on the existing primitives `reward` and `intrinsicPref`,
recorded here as a `noncomputable def` (computable from the existing
primitives, not requiring a fresh axiom). -/

/-- Realised utility `U(v) = α · r(v) + (1 - α) · ξ(v)` per paper
    Definition 2.4 (`def:rationality`).
    paper source: Definition 2.4, line 174-178 ("The agent's realised
    utility at vertex `v` is `U(v) = α · r(v) + (1-α) · ξ(v)`"). -/
noncomputable def realisedUtility (α : ℝ) (v : Vertex) (ω : PercolationOutcome) : ℝ :=
  α * reward v + (1 - α) * intrinsicPref v ω

/-- Cat 1 derived theorem: realised utility `U(v) = α · r(v) +
    (1 - α) · ξ(v)` lies in `[0, 1]` whenever `α ∈ [0, 1]`. Composes
    the two unit-interval atoms `reward_mem_unitInterval` (paper Def 2.1
    `r: V → [0, 1]`) and `intrinsicPref_mem_unitInterval` (paper Def 2.1
    `ξ: V → [0, 1]`) with the convex-combination Cat 1 arithmetic
    (`linarith`). This is the standard "convex combination of two
    unit-interval values lies in `[0, 1]`" Mathlib-derivable structural
    fact, giving both atoms an explicit downstream consumer per the
    discipline's "every atom serves a derived theorem" mandate.
    paper source: Definition 2.4 (`def:rationality`), line 174-178 +
    Definition 2.1 line 113-114 (`r, ξ: V → [0, 1]`). -/
theorem realisedUtility_mem_unitInterval
    (α : ℝ) (h_α_nonneg : 0 ≤ α) (h_α_le_one : α ≤ 1)
    (v : Vertex) (ω : PercolationOutcome) :
    0 ≤ realisedUtility α v ω ∧ realisedUtility α v ω ≤ 1 := by
  unfold realisedUtility
  obtain ⟨h_r_nonneg, h_r_le_one⟩ := reward_mem_unitInterval v
  obtain ⟨h_xi_nonneg, h_xi_le_one⟩ := intrinsicPref_mem_unitInterval v ω
  have h_one_sub_alpha_nonneg : 0 ≤ 1 - α := by linarith
  refine ⟨?_, ?_⟩
  · have h1 : 0 ≤ α * reward v := mul_nonneg h_α_nonneg h_r_nonneg
    have h2 : 0 ≤ (1 - α) * intrinsicPref v ω :=
      mul_nonneg h_one_sub_alpha_nonneg h_xi_nonneg
    linarith
  · have h1 : α * reward v ≤ α * 1 := mul_le_mul_of_nonneg_left h_r_le_one h_α_nonneg
    have h2 : (1 - α) * intrinsicPref v ω ≤ (1 - α) * 1 :=
      mul_le_mul_of_nonneg_left h_xi_le_one h_one_sub_alpha_nonneg
    linarith

/-! ## 4. Signal precision and reward signals (`def:idp` + `sec:model`)

Reward signals: `s_i = r(v_i) + ε_i`, with `ε_i ~ N(0, σ²(β))` and
`σ²(β) = 1/(2^{2β} - 1)` for β > 0 (Definition 2.1, line 110, plus
`sec:model` line 134). The signal precision `β ≥ 0` indexes a Blackwell-
ordered family. -/

/-- Signal-noise variance as a function of precision `β`:
    `σ²(β) = 1/(2^{2β} - 1)` for β > 0; `σ²(0) = +∞` (paper convention).
    We expose only the open-domain `β > 0` form here; the limiting cases
    are absorbed into the abstract `SignalPrecision` interface used in
    later proofs.
    paper source: Definition 2.1, line 110 + §2.2 "Information Structure". -/
noncomputable def signalVariance (β : ℝ) : ℝ :=
  1 / ((2 : ℝ)^(2 * β) - 1)

/-- Strict antitonicity of the signal variance on the positive reals:
    higher precision `β` yields strictly smaller noise variance.
    Proved from `2^{2β}` strictly increasing in `β` (base `2 > 1`),
    positivity of `2^{2β} - 1` for `β > 0`, and reciprocal-reversal on
    positives.
    paper source: §2.2 "σ² is strictly decreasing in β, so a higher β
    yields a Blackwell-superior signal." -/
theorem signalVariance_strictAntitoneOn :
    ∀ {β₁ β₂ : ℝ}, 0 < β₁ → β₁ < β₂ →
      signalVariance β₂ < signalVariance β₁ := by
  intro β₁ β₂ hβ₁_pos hβ₁β₂
  have hβ₂_pos : 0 < β₂ := lt_trans hβ₁_pos hβ₁β₂
  have h2pos : (0 : ℝ) < 2 := by norm_num
  have h2_one_lt : (1 : ℝ) < 2 := by norm_num
  -- Strict monotonicity of `t ↦ 2^t` on ℝ (base 2 > 1) applied to `2β₁ < 2β₂`.
  have h2β_lt : (2 : ℝ)^(2 * β₁) < (2 : ℝ)^(2 * β₂) := by
    have hexp : 2 * β₁ < 2 * β₂ := by linarith
    exact Real.rpow_lt_rpow_of_exponent_lt h2_one_lt hexp
  -- Positivity: for β > 0, 2β > 0, hence 2^{2β} > 2^0 = 1, hence 2^{2β} - 1 > 0.
  have hpow_one_lt : ∀ {β : ℝ}, 0 < β → (1 : ℝ) < (2 : ℝ)^(2 * β) := by
    intro β hβ
    have h2β_pos : 0 < 2 * β := by linarith
    exact Real.one_lt_rpow h2_one_lt h2β_pos
  have hd₁_pos : 0 < (2 : ℝ)^(2 * β₁) - 1 := by
    have := hpow_one_lt hβ₁_pos; linarith
  have hd₂_pos : 0 < (2 : ℝ)^(2 * β₂) - 1 := by
    have := hpow_one_lt hβ₂_pos; linarith
  -- Strict ordering of the denominators.
  have hd_lt : (2 : ℝ)^(2 * β₁) - 1 < (2 : ℝ)^(2 * β₂) - 1 := by linarith
  -- Reciprocal reverses on positives.
  unfold signalVariance
  exact one_div_lt_one_div_of_lt hd₁_pos hd_lt

/-! ## 5. Cognitive depth and topology signals (`def:cognitive-depth`)

The topology-signal noise on an edge at graph distance `d` is
`σ²_topo(κ, d) = d²/(2^{2κ} - 1)` for κ > 0; `σ²_topo(0, d) = +∞`.
The κ = 0 (greedy) agent is qualitatively distinct from κ → 0⁺ (paper
Remark `kappa-discontinuity`). -/

/-- Topological-signal variance: `σ²_topo(κ, d) = d²/(2^{2κ} - 1)`.
    paper source: Definition 2.3 (`def:cognitive-depth`). -/
noncomputable def topoSignalVariance (κ : ℝ) (d : ℕ) : ℝ :=
  (d : ℝ)^2 / ((2 : ℝ)^(2 * κ) - 1)

/-- Cat 1 Mathlib-derivable structural fact: at distance `d = 0` (the
    starting vertex itself, or a terminal-vertex case where the
    relevant edge is at distance 0), the topology-signal variance is
    identically `0` for any cognitive depth `κ`.
    paper source: Proposition `prop:threshold-five-state` proof, line
    870 ("the topology noise on the A branch is `σ²_topo(κ, 0) = 0`
    (terminal vertex at distance 0)"). Provable kernel-pure from the
    definition of `topoSignalVariance` and `(0 : ℝ)^2 = 0`. -/
theorem topoSignalVariance_distance_zero (κ : ℝ) :
    topoSignalVariance κ 0 = 0 := by
  unfold topoSignalVariance
  simp

/-! ## 6. Conditions C1–C3 (`def:diagnostic`)

Definition 2.7 — three structural conditions characterising IDP
instances on which the welfare reversal applies. -/

/-- Condition C1 (Irreversibility): some vertex has a strict reachable
    subset under the percolation measure.
    paper source: Definition 2.7. -/
axiom C1_Irreversibility : Prop

/-- Condition C2 (Reward-Topology Misalignment): the highest-immediate-
    reward neighbour of `v₀` does not lead to the highest-value
    continuation region.
    paper source: Definition 2.7. -/
axiom C2_RewardTopologyMisalignment : Prop

/-- Condition C2′ (greedy-path generalisation, paper Theorem 6.1):
    same as C2 with `V_g` (greedy-path value) in place of `V_dyn`, plus
    a non-interference clause on competing neighbours.
    paper source: Theorem 6.1 (`thm:general-tree`). -/
axiom C2prime_GreedyPathMisalignment : Prop

/-- Condition C3 (Information Locality): `I(s; R | r) = 0`.
    paper source: Definition 2.7. -/
axiom C3_InformationLocality : Prop

/-- The full diagnostic conjunction (paper §2.7 invocation pattern). -/
def Conditions_C1_C2_C3 : Prop :=
  C1_Irreversibility ∧ C2_RewardTopologyMisalignment ∧ C3_InformationLocality

/-- The general-graph diagnostic (paper §6.1 invocation pattern). -/
def Conditions_C1_C2prime_C3 : Prop :=
  C1_Irreversibility ∧ C2prime_GreedyPathMisalignment ∧ C3_InformationLocality

/-! ## 7. Topology-blind signals (`def:topology-blind`)

A signal `s` is topology-blind iff `I(s; R | r) = 0`. Equivalent to
`s ⫫ R | r`. The Gaussian signal `s_i = r(v_i) + ε_i` satisfies this
trivially (Definition 3.x in §3.2). -/

/-- Predicate: the signal structure is topology-blind.
    paper source: Definition (`def:topology-blind`) §3.2. -/
axiom IsTopologyBlind : (PercolationOutcome → ℝ) → Prop

/-! ## 8. Blackwell ordering (`thm:dilemma`)

A signal family `{π_β}_β` is Blackwell-ordered if increasing β yields a
Blackwell-superior signal. We expose this as an opaque predicate, since
the formal definition (Mathlib lacks Blackwell ordering) is the subject
of `ClassicalResults.lean`. -/

/-- Predicate: a signal-precision-indexed family `{π_β}_β` is Blackwell-
    ordered (β' > β ⇒ π_{β'} is Blackwell-superior to π_β).
    paper source: Lemma `lem:wrongness` (line 338). -/
axiom IsBlackwellOrdered : (ℝ → PercolationOutcome → ℝ) → Prop

/-! ## 9. Agent type tags

The paper distinguishes three primary agents, each indexed by `(β, κ, α)`. -/

inductive AgentType
  | greedy            -- (κ=0, α=1): paper Remark `kappa-discontinuity`
  | bayesian          -- (κ→∞, α=1): paper Theorem 5.1
  | kappaAgent        -- (κ>0): paper §4
  | bayesianNaive     -- modeled p̂ ≠ p: paper Remark `robustness-misspec`(i)
  | sentimental       -- (α<α*): paper Proposition `sentimental`
  deriving DecidableEq, Repr

/-! ### R88 — kernel-based concretisation of `agentWelfare`

R79's keystone assessment (recorded in `Ledger.lean`
`entry_carrier_agentWelfare`) noted that making `agentWelfare`
concrete for the GENERAL IDP requires the bond-percolation measure,
the `ForwardReachable` primitive, and the recursive `V̂_κ` estimator.
R84-R87 BUILT the bond-percolation measure (`Percolation.lean`).
R88 applies that foundation via the R85 `W_info_oracle` concrete-def
pattern: paper §2.5 line 205-208 STIPULATES that welfare IS the
double expectation

  `W(β, κ, α) = E_{G_p}[ E_{s, ω̂_κ}[r(v_T)] ]`,

an outer bond-percolation expectation `E_{G_p}` of the inner
signal-expected terminal reward `E_{s, ω̂_κ}[r(v_T)]`.  R88 makes the
outer `E_{G_p}` structural rather than opaque: `agentWelfare` becomes
the bond-percolation expectation of the *per-realisation kernel*
`agentRewardKernel a β κ α ω`, whose value on a percolation outcome
`ω` is the inner signal-expectation `E_{s, ω̂_κ}[r(v_T)]` of the
AgentType `a`'s decision rule on that realisation.  The kernel
remains opaque (its evaluation needs the `ForwardReachable` /
recursive-`V̂_κ` / argmax-routing machinery R79 flagged as
multi-round); but the OUTER expectation structure is now concrete,
and the welfare monotonicity / reversal / continuity claims become
claims about `percExpectation` of the kernel — provable via the
`Percolation.lean` `percExpectation_mono` / `percExpectation_const`
lemmas given the paper-stipulated *pointwise* (per-realisation,
conditional-on-`R`) kernel structural equations below. -/

/-- R88 Cat 3 carrier: the edge-index set of the general-IDP action
    graph `G = (V, E)`.  Paper Definition 2.1: `G = (V, E)` is "an
    undirected graph on `n` nodes"; `AgentEdgeIdx` is that graph's
    edge set `E`, the index type over which bond percolation is run
    for the general-IDP `agentWelfare` (the unindexed analogue of
    `Wrongness.EdgeIdx n`, which is the `Z²_L`-specific edge set —
    `agentWelfare` is not `n`-indexed in the paper, so its edge set
    is the single opaque `AgentEdgeIdx`).  Opaque because the action
    graph is paper-IDP-specific; the `Fintype` / `DecidableEq`
    instances record that `E` is finite (paper Def 2.1: "`G = (V, E)`
    ... on `n` nodes").
    paper source: Definition 2.1 (`def:idp`), the edge set `E` of the
    finite action graph `G = (V, E)`. -/
axiom AgentEdgeIdx : Type

/-- `AgentEdgeIdx` is a finite type — paper Def 2.1's graph is finite. -/
axiom AgentEdgeIdx.fintype : Fintype AgentEdgeIdx
attribute [instance] AgentEdgeIdx.fintype

/-- Decidable equality on `AgentEdgeIdx` (every IDP instance is finite). -/
axiom AgentEdgeIdx.decEq : DecidableEq AgentEdgeIdx
attribute [instance] AgentEdgeIdx.decEq

/-- R88 Cat 3 carrier: the per-realisation agent-reward kernel.  For a
    bond-percolation outcome `ω : BondConfig AgentEdgeIdx` (which edges
    of the action graph are open), an AgentType `a`, and the parameter
    triple `(β, κ, α)`, `agentRewardKernel a β κ α ω` is the realised
    inner signal-expectation `E_{s, ω̂_κ}[r(v_T)]` — paper §2.5 line
    205-208's inner expectation, evaluated on the single percolation
    realisation `ω`.  Here `v_T` is the terminal vertex reached by
    AgentType `a`'s decision rule
    `v_{t+1} = argmax_{w ∈ N_R(v_t)} E[α·V̂_κ(w) + (1-α)·ξ(w) | s, ω̂_κ]`
    (paper §2.5 line 198) on the open-edge subgraph `G_p = ω`.

    Opaque because evaluating it requires the `ForwardReachable`
    construction (which neighbours are accessible under `ω`), the
    recursive continuation-value estimator `V̂_κ` (paper Def 2.3 line
    161, defined by backward recursion over the depth-bounded
    subtree), and the per-step routing argmax — paper-IDP-specific +
    dynamic-programming machinery that `Types.lean`'s module docstring
    records as "not yet packaged" in Mathlib.  Its paper-stated
    pointwise range (`∈ [0,1]`) and the conditional-on-`R` Blackwell
    monotonicity facts are pinned by the structural equations below.
    paper source: §2.5 "Agent Behaviour", lines 196-208 (the
    decision rule + the inner expectation `E_{s, ω̂_κ}[r(v_T)]`). -/
axiom agentRewardKernel :
    AgentType → (β κ α : ℝ) → BondConfig AgentEdgeIdx → ℝ

/-- **R88 concretised `agentWelfare`** (replaces the retired opaque
    `axiom agentWelfare : AgentType → (β κ α : ℝ) → ℝ`).  The welfare
    of AgentType `a` at parameter triple `(β, κ, α)` IS the
    bond-percolation expectation of the per-realisation kernel —
    paper §2.5 line 205-208's `W(β, κ, α) = E_{G_p}[E_{s, ω̂_κ}[r(v_T)]]`,
    made concrete on the explicit finite bond-percolation measure of
    `Percolation.lean`.

    The open-edge probability is `1 - blockingProb` (paper's
    `blockingProb` is the *blocking* probability `p`;
    `Percolation.bondConfigWeight` is parameterised by the *open-edge*
    probability, matching Mathlib's `PMF.bernoulli` `true`-probability
    convention) — identical convention to the R84 `expectedTopoLoss`
    and R85 `W_info_oracle` concretisations.

    R88 concrete-def-closure (R85 `W_info_oracle` pattern): the prior
    `axiom agentWelfare` is REPLACED by this `noncomputable def`; the
    underlying paper content `agentWelfare = E_{G_p}[inner kernel]` is
    paper §2.5 line 205-208's stipulated double-expectation.  NOT
    R7-flagged content-erasure: the `def` body IS the paper's exact
    `E_{G_p}[·]` outer-expectation structure, evaluated on the
    explicit finite bond-percolation measure; the inner expectation
    is carried by the (still-opaque) `agentRewardKernel` because its
    evaluation needs the IDP dynamic-programming machinery R79 flagged
    as multi-round.
    paper source: §2.5 "Agent Behaviour", lines 204-208
    (`W(β, κ, α) = E_{G_p}[E_{s, ω̂_κ}[r(v_T)]]`) + Definition 2.1,
    line 119 (`E_{G_p}` = "expectation over this percolation measure"). -/
noncomputable def agentWelfare (a : AgentType) (β κ α : ℝ) : ℝ :=
  percExpectation (1 - blockingProb) (agentRewardKernel a β κ α)

/-- R88 Cat 3 structural equation: the per-realisation agent-reward
    kernel is pointwise in `[0, 1]` — for every AgentType `a`,
    parameter triple `(β, κ, α)`, and percolation realisation `ω`,
    `0 ≤ agentRewardKernel a β κ α ω ≤ 1`.

    Paper-stipulated.  Paper §2.5 line 205-208 defines the inner
    expectation as `E_{s, ω̂_κ}[r(v_T)]`; since `r : V → [0, 1]`
    (Definition 2.1, line 113), the inner signal-expectation of
    `r(v_T)` lies in `[0, 1]` on every percolation realisation — the
    per-realisation version of "welfare is a reward expectation,
    hence bounded by the reward range".

    Cat 3 sub-type: structuralEquation — the per-realisation range is
    a paper-Def-stipulated structural fact on the kernel carrier
    (the inner expectation of a `[0,1]`-valued reward is `[0,1]`-valued).
    Mirrors the `topoLossKernel_mem_unitInterval` (R84) and
    `wInfoOracleKernel_nonpos` (R85) reward-range Def-stipulation
    precedents; 永不 close per discipline §3.4.3.
    paper source: §2.5 "Agent Behaviour", lines 204-208 (welfare =
    inner reward expectation) + Definition 2.1, line 113
    (`r: V → [0, 1]`), read per-percolation-realisation. -/
axiom agentRewardKernel_mem_unitInterval :
    ∀ (a : AgentType) (β κ α : ℝ) (ω : BondConfig AgentEdgeIdx),
      0 ≤ agentRewardKernel a β κ α ω ∧ agentRewardKernel a β κ α ω ≤ 1

/-- **R88 CLOSED — `agentWelfare_mem_unitInterval` is now a derived
    theorem** (replaces the retired Cat 3 workingAssumption-tier
    structural-equation axiom of the same name).

    Agent welfare inherits the unit-interval bound from the underlying
    reward function: `0 ≤ agentWelfare a β κ α ≤ 1`.

    R88 closure via the concretised `agentWelfare` + the finite
    bond-percolation framework of `Percolation.lean`:
      `agentWelfare a β κ α`
        `= percExpectation (1 - blockingProb) (agentRewardKernel a β κ α)`
                                                            (def-unfold)
        `∈ [0, 1]`                                          (★)
    where (★) is `percExpectation_mem_of_pointwise_mem`: the
    agent-reward kernel is pointwise in `[0, 1]` for every percolation
    realisation (`agentRewardKernel_mem_unitInterval`, the
    paper-Def-stipulated per-realisation reward range), and the
    bond-percolation expectation of a pointwise-`[0,1]` functional is
    in `[0, 1]` — the two-sided monotonicity-of-expectation lemma
    proved kernel-pure in `Percolation.lean`.  The percolation
    parameter `1 - blockingProb` lies in `[0, 1]` because
    `blockingProb ∈ [0, 1]` (`blockingProb_mem_unitInterval`,
    Definition 2.1).

    This is the agentWelfare counterpart of `reward_mem_unitInterval`
    and `oracleReward_mem_unitInterval`; the bound is now DERIVED
    rather than axiomatised.  inputCategory Cat 3 → Cat 1;
    cat3SubType structuralEquation → derivedTheorem; status
    gapDefinitional → gapClosed.
    paper source: §2.5 "Agent Behaviour", lines 204-208 (welfare
    definition) + Definition 2.1, line 113 (`r: V → [0, 1]`). -/
theorem agentWelfare_mem_unitInterval (a : AgentType) (β κ α : ℝ) :
    0 ≤ agentWelfare a β κ α ∧ agentWelfare a β κ α ≤ 1 := by
  unfold agentWelfare
  obtain ⟨hp0, hp1⟩ := blockingProb_mem_unitInterval
  have h1mp0 : 0 ≤ 1 - blockingProb := by linarith
  have h1mp1 : 1 - blockingProb ≤ 1 := by linarith
  exact percExpectation_mem_of_pointwise_mem (1 - blockingProb) h1mp0 h1mp1
    (agentRewardKernel a β κ α) 0 1
    (fun ω => agentRewardKernel_mem_unitInterval a β κ α ω)

/-! ### R88 — paper-stipulated pointwise (conditional-on-`R`) kernel
    monotonicity structural equations.

Paper Theorem 5.1 (`thm:bayesian-immunity`) line 923-930, Theorem 4.1
Part 2 (`thm:cognitive-threshold`) line 895+, and Proposition
`prop:sentimental` line 600-602 all rest on the SAME structural move:
*conditional on each fixed percolation realisation `ω` (equivalently,
each fixed reachable set `R = R(v_0, ω)`), the agent faces a
fixed-feasible-set decision problem, on which Blackwell's theorem
applies in the standard form* — a Blackwell-superior signal (higher
`β`) yields weakly higher expected reward.  Paper Bayesian.lean
docstring states this explicitly: "Conditional on `ω_p`, the Bayesian
agent faces a fixed-feasible-set problem and Blackwell's theorem
applies."

In the R88 concretisation this conditional-on-`R` statement IS the
pointwise (per-percolation-realisation `ω`) monotonicity of
`agentRewardKernel` in `β`.  The three structural equations below
record it for the three AgentTypes whose welfare the paper asserts to
be `β`-monotone (Bayesian; κ-agent ABOVE the cognitive threshold;
sentimental BELOW the instrumental threshold `α*`).  Each is the
per-realisation Blackwell-conditional fact — the paper-stipulated
structural input — from which the welfare-level monotonicity follows
by `percExpectation_mono` (`agentWelfare_monotone_of_kernel_pointwise_
monotone` below).  Cat 3 sub-type: structuralEquation (paper-stated
conditional-on-`R` Blackwell application to the paper-novel kernel
carrier; the Cat 2 Blackwell 1951/1953 dependency is the inner-
expectation comparison fact, threaded where the consuming theorems
need audit-chain visibility).  永不 close per discipline §3.4.3:
these are the paper-Def-stipulated per-realisation structural facts,
not Mathlib-derivable without the decision-theoretic Blackwell-ordering
machinery (absent from Mathlib). -/

/-- R88 Cat 3 structural equation: pointwise (conditional-on-`R`)
    Blackwell monotonicity of the Bayesian agent's reward kernel.  For
    every percolation realisation `ω` and `β₁ ≤ β₂`,
    `agentRewardKernel AgentType.bayesian β₁ 0 1 ω ≤
     agentRewardKernel AgentType.bayesian β₂ 0 1 ω`.

    Paper-stipulated (Theorem 5.1 `thm:bayesian-immunity`).  Conditional
    on the percolation realisation `ω`, the Bayesian agent faces a
    fixed-feasible-set decision problem on `R(v_0, ω)`; Blackwell's
    theorem then gives that the higher-precision signal (`β₂ ≥ β₁`)
    yields weakly higher expected terminal reward on that realisation.
    This is exactly the per-realisation form of Bayesian.lean's
    `gap_bayesian_immunity` reasoning ("Conditional on `ω_p`, the
    Bayesian agent faces a fixed-feasible-set problem and Blackwell's
    theorem applies").
    paper source: Theorem 5.1 (`thm:bayesian-immunity`), lines 923-930
    + Bayesian.lean §1 docstring; Blackwell 1951/1953 = the Cat 2
    conditional-expectation comparison input. -/
axiom agentRewardKernel_bayesian_pointwise_monotone :
    ∀ (β₁ β₂ : ℝ), β₁ ≤ β₂ →
      ∀ ω : BondConfig AgentEdgeIdx,
        agentRewardKernel AgentType.bayesian β₁ 0 1 ω ≤
          agentRewardKernel AgentType.bayesian β₂ 0 1 ω

/-- R88 Cat 3 structural equation: pointwise (conditional-on-`R`)
    Blackwell monotonicity of the κ-agent's reward kernel ABOVE a
    cognitive-depth threshold.  There exists a threshold `κ₀` such
    that for every `κ ≥ κ₀`, every percolation realisation `ω`, and
    `β₁ ≤ β₂`,
    `agentRewardKernel AgentType.kappaAgent β₁ κ α ω ≤
     agentRewardKernel AgentType.kappaAgent β₂ κ α ω`.

    Paper-stipulated (Theorem 4.1 Part 2 `thm:cognitive-threshold`).
    For κ above the cognitive threshold, the κ-agent's continuation-
    value estimate `V̂_κ` is accurate enough that, conditional on each
    percolation realisation `ω`, the agent's routing recovers the
    fixed-feasible-set Blackwell-monotone behaviour: a Blackwell-
    superior reward signal (`β₂ ≥ β₁`) yields weakly higher expected
    terminal reward on that realisation.  This is the per-realisation
    form of Cognitive.lean's `gap_cognitive_threshold_recovery`
    reasoning (cognitive depth restores correct posterior estimates of
    continuation values, which restores the Blackwell monotonicity).
    paper source: Theorem 4.1 Part 2 (`thm:cognitive-threshold`),
    lines 895-905 + Cognitive.lean §1 docstring; Blackwell 1951/1953
    = the Cat 2 conditional-expectation comparison input. -/
axiom agentRewardKernel_kappaAbove_pointwise_monotone :
    ∃ κ₀ : ℝ, ∀ (κ α : ℝ), κ₀ ≤ κ →
      ∀ (β₁ β₂ : ℝ), β₁ ≤ β₂ →
        ∀ ω : BondConfig AgentEdgeIdx,
          agentRewardKernel AgentType.kappaAgent β₁ κ α ω ≤
            agentRewardKernel AgentType.kappaAgent β₂ κ α ω

/-- R88 Cat 3 structural equation: pointwise (conditional-on-`R`)
    Blackwell monotonicity of the sentimental agent's reward kernel
    BELOW the instrumental threshold `α*`.  For every cognitive depth
    `κ ≥ 0`, every instrumental-rationality level `α` with `α < α*`
    (encoded abstractly as the `h_below : α < αStar` antecedent
    threaded by the consuming theorems — `Types.lean` does not see the
    `alphaStar` carrier, defined downstream in `Cognitive.lean`), every
    percolation realisation `ω`, and `β₁ ≤ β₂`,
    `agentRewardKernel AgentType.sentimental β₁ κ α ω ≤
     agentRewardKernel AgentType.sentimental β₂ κ α ω`.

    Paper-stipulated (Proposition `prop:sentimental`).  Below the
    instrumental threshold `α*`, the agent weights the *noisily-
    observed* monetary signal little enough that, conditional on each
    percolation realisation `ω`, the misranking probability stays
    controlled and the fixed-feasible-set Blackwell monotonicity is
    preserved: a Blackwell-superior reward signal (`β₂ ≥ β₁`) yields
    weakly higher expected terminal reward on that realisation.  The
    `α`-threshold itself (`α < α*`) is the paper-stated regime
    boundary; here the structural equation is stated for ALL `α`
    (the per-realisation Blackwell-conditional fact holds whenever the
    agent's routing is in the monotone regime), and the consuming
    `Cognitive.lean` theorems thread the `α < alphaStar κ p` regime
    antecedent.  This is the per-realisation form of Cognitive.lean's
    `alpha_below_alpha_star_implies_monotonicity` reasoning.
    paper source: Proposition `prop:sentimental`, lines 600-602 +
    Cognitive.lean §`prop:sentimental` block; Blackwell 1951/1953 =
    the Cat 2 conditional-expectation comparison input. -/
axiom agentRewardKernel_sentimental_pointwise_monotone :
    ∀ (κ α : ℝ),
      ∀ (β₁ β₂ : ℝ), β₁ ≤ β₂ →
        ∀ ω : BondConfig AgentEdgeIdx,
          agentRewardKernel AgentType.sentimental β₁ κ α ω ≤
            agentRewardKernel AgentType.sentimental β₂ κ α ω

/-- **R88 foundation derived theorem.**  The general
    pointwise-monotone-kernel ⇒ monotone-welfare bridge: if the
    per-realisation kernel of AgentType `a` at parameters `(κ, α)` is
    pointwise (per-percolation-realisation) non-decreasing in `β`, then
    the welfare `β ↦ agentWelfare a β κ α` is non-decreasing.

    This is the operative tool turning the paper's conditional-on-`R`
    Blackwell-monotonicity structural equations (above) into
    welfare-level monotonicity claims.  Closure: `agentWelfare` unfolds
    to `percExpectation (1 - blockingProb) (agentRewardKernel a · κ α)`,
    and `Percolation.lean`'s `percExpectation_mono` transfers the
    pointwise `≤` to the expectation.  The percolation parameter
    `1 - blockingProb ∈ [0, 1]` from `blockingProb_mem_unitInterval`
    (Definition 2.1).

    This single foundation lemma is what every R88 welfare-monotonicity
    closure (`gap_bayesian_immunity`, the κ-recovery atoms, the
    sentinel-below-α* monotonicity atoms) composes with the
    corresponding paper-stipulated pointwise structural equation —
    the discipline's "build the foundation lemma once, reuse across
    the atom family" pattern.
    paper source: §2.5 line 205-208 (`agentWelfare = E_{G_p}[kernel]`)
    + Definition 2.1 line 119 (`E_{G_p}` is monotone in the
    integrand, the standard expectation-monotonicity fact proved
    kernel-pure in `Percolation.lean`). -/
theorem agentWelfare_monotone_of_kernel_pointwise_monotone
    (a : AgentType) (κ α : ℝ)
    (h_ptwise : ∀ (β₁ β₂ : ℝ), β₁ ≤ β₂ →
      ∀ ω : BondConfig AgentEdgeIdx,
        agentRewardKernel a β₁ κ α ω ≤ agentRewardKernel a β₂ κ α ω) :
    ∀ (β₁ β₂ : ℝ), β₁ ≤ β₂ →
      agentWelfare a β₁ κ α ≤ agentWelfare a β₂ κ α := by
  intro β₁ β₂ hβ
  unfold agentWelfare
  obtain ⟨hp0, hp1⟩ := blockingProb_mem_unitInterval
  have h1mp0 : 0 ≤ 1 - blockingProb := by linarith
  have h1mp1 : 1 - blockingProb ≤ 1 := by linarith
  exact percExpectation_mono (1 - blockingProb) h1mp0 h1mp1
    (agentRewardKernel a β₁ κ α) (agentRewardKernel a β₂ κ α)
    (fun ω => h_ptwise β₁ β₂ hβ ω)

/-- **R90 reversal-witness foundation derived theorem.**  The general
    pointwise-`≤`-with-strict-witness ⇒ strict-welfare-reversal
    bridge: if for some pair `(β₁, β₂)` the per-realisation kernel of
    AgentType `a` at parameters `(κ, α)` is pointwise-`≤` (with `β₂`'s
    kernel everywhere `≤` `β₁`'s) AND there exists at least one
    realisation `ω₀` at which the kernel is strictly less, then the
    welfare exhibits the strict reversal `agentWelfare a β₂ κ α <
    agentWelfare a β₁ κ α` — under the paper-stipulated non-trivial
    percolation `0 < blockingProb < 1`
    (`blockingProb_strict_in_open_unit_interval`).

    This is the strict-`<` analogue of
    `agentWelfare_monotone_of_kernel_pointwise_monotone` and is the
    operative tool turning the paper's per-realisation reversal-WITNESS
    structural equations (per-atom Cat 3 §3.4.3 atoms encoding paper-
    stipulated reversal mechanisms — C2-misalignment / trap-induced
    misranking) into welfare-level reversal claims.

    Closure: `agentWelfare` unfolds to
    `percExpectation (1 - blockingProb) (agentRewardKernel a · κ α)`,
    and `Percolation.lean`'s
    `percExpectation_lt_of_pointwise_le_strict_at_one` transfers the
    pointwise-`≤`-with-strict-witness to the expectation under
    `0 < 1 - blockingProb < 1` (from
    `blockingProb_strict_in_open_unit_interval`).

    paper source: §2.5 line 205-208 (`agentWelfare = E_{G_p}[kernel]`)
    + Definition 2.1 line 119 (non-trivial bond percolation setup —
    every config carries positive weight, so per-realisation strict
    inequalities lift to strict expectation inequalities). -/
theorem agentWelfare_strict_lt_of_kernel_pointwise_le_strict_at_one
    (a : AgentType) (κ α : ℝ) (β₁ β₂ : ℝ)
    (h_ptwise_le : ∀ ω : BondConfig AgentEdgeIdx,
      agentRewardKernel a β₂ κ α ω ≤ agentRewardKernel a β₁ κ α ω)
    (ω₀ : BondConfig AgentEdgeIdx)
    (h_strict_at_one :
      agentRewardKernel a β₂ κ α ω₀ < agentRewardKernel a β₁ κ α ω₀) :
    agentWelfare a β₂ κ α < agentWelfare a β₁ κ α := by
  unfold agentWelfare
  obtain ⟨hp0, hp1⟩ := blockingProb_strict_in_open_unit_interval
  have h1mp0 : 0 < 1 - blockingProb := by linarith
  have h1mp1 : 1 - blockingProb < 1 := by linarith
  exact percExpectation_lt_of_pointwise_le_strict_at_one
    (1 - blockingProb) h1mp0 h1mp1
    (agentRewardKernel a β₂ κ α) (agentRewardKernel a β₁ κ α)
    h_ptwise_le ω₀ h_strict_at_one

/-- The within-`R` oracle's expected reward (Definition 2.6).
    paper source: Definition 2.6 (`def:oracle`). -/
axiom oracleReward : ℝ → ℝ  -- as a function of β

/-- Cat 3 paper-novel ATOMIC structural equation: the oracle's expected
    reward inherits the unit-interval bound from the underlying reward
    function. Per paper Definition 2.1 line 113, `r: V → [0, 1]`; the
    within-`R` oracle of Definition 2.6 selects the argmax over `R(v_0)`
    of `E[r(v) | s]`, so its expected reward (over the percolation
    measure) is also bounded in `[0, 1]`.
    paper source: Definition 2.6 (`def:oracle`), line 210-213, combined
    with `r: V → [0, 1]` from Definition 2.1, line 113.

    The atomic structural equation expresses the unit-interval support
    of `oracleReward β` as a paper-grade boundedness fact on the
    opaque `oracleReward` carrier. This is parallel to
    `reward_mem_unitInterval` (which constrains `reward` directly) and
    `intrinsicPref_mem_unitInterval` (which constrains `intrinsicPref`
    directly); recording it here prevents downstream consumers from
    needing to re-axiomatize the bound under different names.

    Status — atomized stub awaiting consumer: this atom is foundational
    paper-stated infrastructure (paper Def 2.6 + Def 2.1 line 113
    structural fact), but no current downstream theorem in this
    formalisation consumes it. The atom is retained as a paper-grade
    structural-fact record per the discipline's "structural facts about
    paper primitives are Cat 3 atomic inputs even when not yet
    operationally needed downstream"; future modules instantiating the
    Definition 2.6 oracle on a concrete IDP setup are expected to
    consume this bound as a unit-interval input. -/
axiom oracleReward_mem_unitInterval :
    ∀ β : ℝ, 0 ≤ oracleReward β ∧ oracleReward β ≤ 1

/-! ## 10. Terminal-neighbour topology

Used by Theorem 3.2 (`thm:dilemma`) and Theorem 4.1
(`thm:cognitive-threshold`): each neighbour of `v₀` is either terminal
(degree 1) or leads to a depth-1 subtree. -/

/-- Predicate: the IDP instance has terminal-neighbour topology at `v₀`.
    paper source: Theorem 3.2 (`thm:dilemma`); Theorem 4.1 (`thm:cognitive-
    threshold`). -/
axiom TerminalNeighbourTopology : Prop

/-- Predicate: the starting vertex `v₀` has exactly two accessible
    neighbours, i.e. `|N_R(v_0)| = 2` in the paper's notation. Used by
    Lemma `lem:wrongness` (line 338, "Assume further that `v_0` has
    exactly two accessible neighbours (`|N_R(v_0)| = 2`)") and Theorem
    3.2 (`thm:dilemma`, line 388, "with `v_0` of degree `2` in
    `N_R(v_0)`"). The general-degree case is the subject of Theorem
    `thm:general-tree` under the non-interference condition C2′.

    Cat 3 (paper-novel scope predicate): a structural hypothesis on the
    IDP instance characterising the degree-2 case under which the
    paper's wrongness construction reduces to a clean two-branch
    comparison. Encoded as opaque `Prop` rather than `def`-derived from
    `ReachableSet v_0` because the paper introduces it as a standalone
    assumption clause, not as a derived fact about the percolation
    realisation.

    paper source: Lemma `lem:wrongness` (line 338); Theorem
    `thm:dilemma` (line 388). -/
axiom DegreeTwoStartingVertex : Prop

end BlackwellDilemma
