/-
  BlackwellDilemma/Phase.lean

  §3.3–§3.4 Phase transition and trap prevalence.

  Companion to: "Information Value Under Endogenous Feasibility" (Li, 2026).

  Contents:
   * Theorem 3.3 (`thm:phase`) — Phase Transition at `p_c = 1/2` on `Z²`.
   * Proposition (`prop:trap-prevalence`) — Generic Trap Prevalence on `Z²`.
   * Corollary (`cor:er-phase`) — Phase Transition on Erdős–Rényi.
   * Corollary (`cor:power-law`) — Power-Law Networks `2 < γ < 3`.
   * Definition (`def:value-functions`) — Static and Dynamic Value
     (encoded as opaque functions over Vertex / PercolationOutcome).

  Each statement is wired through paper-citation axioms or to the
  classical results in `ClassicalResults.lean` (Harris–Kesten, Grimmett,
  Bollobás, Cohen et al., Molloy–Reed).
-/

import BlackwellDilemma.Types
import BlackwellDilemma.ClassicalResults
import BlackwellDilemma.Wrongness

namespace BlackwellDilemma

/-! ## 1. Static and dynamic value (`def:value-functions`)

`V_static(v) = r(v)`; `V_dyn(v) = max_{w ∈ R(v | v')} r(w)` is the best
forward-reachable reward under the no-revisit rule. -/

/-- Static value of vertex `v`: just its immediate reward.
    paper source: Definition `def:value-functions`, line 442. -/
noncomputable def V_static (v : Vertex) : ℝ := reward v

/-- Dynamic value of vertex `v` given parent `v'` and percolation
    outcome `ω`: the best reward in the forward reachable set.
    paper source: Definition `def:value-functions`, line 443. -/
axiom V_dyn : Vertex → Finset Vertex → PercolationOutcome → ℝ

/-- Cat 3 paper-novel ATOMIC structural equation: the dynamic value of
    a vertex `v` (under parent set `H`, percolation outcome `ω`) is the
    paper-stated sup of rewards over the forward-reachable set
    `ForwardReachable v H ω`. Paper Definition 2.2 line 127 reads
    "`V_dyn(v_0) = max_{v ∈ R(v_0)} r(v)`" and Definition
    `def:value-functions` line 446 reads "`V_dyn(v) = max_{w ∈ R(v|v')}
    r(w)`"; both are realised here as a `Finset.sup'` over the
    forward-reachable carrier (using the trivial-path inclusion
    `ForwardReachable_self_member` from Types.lean to witness
    non-emptiness).

    Encoding choice: the paper's `max` is realised by `Finset.sup'`
    rather than `Finset.max'` because `Finset.sup'` interfaces directly
    with the order on `ℝ` for arbitrary non-empty `Finset`s. The
    membership-witness `ForwardReachable_self_member` provides the
    `Finset.Nonempty` argument by `⟨v, ForwardReachable_self_member v H ω⟩`.

    paper source: Definition 2.2 (`def:reachable`), line 127 (`V_dyn(v_0)
    = max_{v ∈ R(v_0)} r(v)`); Definition `def:value-functions`,
    line 446 (`V_dyn(v) = max_{w ∈ R(v|v')} r(w)`). -/
axiom V_dyn_def :
    ∀ (v : Vertex) (H : Finset Vertex) (ω : PercolationOutcome),
      V_dyn v H ω =
        (ForwardReachable v H ω).sup' ⟨v, ForwardReachable_self_member v H ω⟩ reward

/-! ## 2. Theorem 3.3 — Phase Transition at `p_c` on `Z²`

The phase transition is sharp: below `p_c = 1/2`, a positive fraction
`θ(1−p)` of agents inhabit the giant component where information
governs welfare; above `p_c`, this fraction is identically zero. -/

/- **Theorem 3.3 (`thm:phase`) Part 1: Below threshold**
    (`p < p_c = harrisKestenCriticalProb`).
    Topological loss vanishes asymptotically; oracle Blackwell holds.
    Composes the Harris-Kesten Cat 2 axiom, `gap_percolation_probability_OPEN`
    (Cat 2 — Grimmett 1999), `gap_topo_cluster_relation_OPEN`,
    conditional Blackwell.

    The bundled `gap_phase_transition_below_OPEN` axiom is now
    REPLACED by the derived theorem `gap_phase_transition_below`
    composing two atomic stipulations per `feedback_gap_ledger_in_lean4`
    §18 Manufactured-Recognition pattern: see
    `topo_loss_decay_below_pc_OPEN` (existence of decay envelope) and
    `topo_loss_decay_arbitrary_threshold_OPEN` (arbitrary-threshold
    convergence) below. The Cat 2 Grimmett percolation-probability
    dependency is threaded as the explicit `h_perc_prob` antecedent for
    audit-chain visibility.

    paper source: Theorem 3.3 (`thm:phase`), lines 400-419;
    Grimmett 1999 _Percolation_ 2nd ed. cited as the Cat 2
    percolation-probability dependency. -/

/-! ### R86 SOUNDNESS-DEFECT FIX — Phase.lean sister correction.

    The retired R59 atom `expectedTopoLoss_below_pc_one_over_n_envelope_OPEN`
    asserted the *unconditional* bound `expectedTopoLoss n p ≤ 1/(n+1)`
    for `p < p_c`.  That signature is **over-strong — false**, for the
    same reason documented at the Wrongness.lean sister section: paper
    Theorem 3.3 Part 1 (lines 404, 415-419) establishes `E[|W_topo|] =
    O(1/n)` **only conditional on the giant-component event**
    (`|R(v_0)| = Θ(n)`).  The unconditional below-threshold expected
    topological loss is `Θ(1)` (the `1 - θ(1-p)` fraction of agents
    NOT in the giant component carry `Θ(1)` loss).

    R86 — per `feedback_truth_over_publication` + R83 precedent —
    REPLACES the retired Phase.lean atom + its derived-theorem chain
    with the paper-faithful giant-component-conditional form, reusing
    the R86 infrastructure built in `Wrongness.lean` /
    `Percolation.lean`:
      * `Percolation.percRestrictedExpectation` — sub-event
        expectation `E_{G_p}[· ; S]`;
      * `Wrongness.giantComponentEvent` — Cat 3 carrier, the
        giant-component event `Finset`;
      * `Wrongness.expectedTopoLossOnGiant` — the paper-faithful
        object `E_{G_p}[topoLossKernel ; giantComponentEvent]`;
      * `Wrongness.topoLossKernel_le_one_over_n_on_giant_atom_OPEN` —
        the SIGNATURE-CORRECTED Cat 3 structuralEquation atom (the
        loss kernel is pointwise `≤ 1/(n+1)` *on the
        giant-component event*, paper line 417's per-realisation
        giant-component bound — TRUE, unlike the retired atom);
      * `Wrongness.topo_loss_on_giant_below_one_over_n` — the genuine
        paper `1/(n+1)` envelope, on the giant-component event.

    The Phase.lean below-threshold derived theorems are accordingly
    re-stated against `expectedTopoLossOnGiant`; their conclusions
    are paper Theorem 3.3 Part 1 line 404's genuine content
    ("With probability `θ(1-p)` ... `|W_topo| = O(1/N) → 0`").
    `gap_phase_transition_below` is a terminal derived theorem (no
    higher consumer — verified by grep), so the correction is fully
    contained.  The single R59 atom
    `expectedTopoLoss_below_pc_one_over_n_envelope_OPEN` is RETIRED
    (no replacement Phase.lean-local atom: the corrected
    structuralEquation atom lives in `Wrongness.lean` and is shared
    by both the Wrongness.lean and Phase.lean below-threshold chains).

    paper source: Theorem 3.3 Part 1, lines 404, 415-419
    (giant-component-conditional `O(1/N)` envelope + convergence). -/

/-- **R86 derived theorem** (paper-faithful replacement of the retired
    `topo_loss_decay_below_pc`).  Below threshold (`p < p_c`), the
    expected topological loss *on the giant-component event*
    `expectedTopoLossOnGiant n p` admits the explicit decay envelope
    `1/(n+1)` — a function `topo_loss_decay : ℕ → ℝ` with
    `topo_loss_decay → 0` and `expectedTopoLossOnGiant n p ≤
    topo_loss_decay n` for all `n`.

    Thin Phase.lean wrapper around the `Wrongness.lean` R86 derived
    theorem `topo_loss_on_giant_below_envelope_exists` (which composes
    the genuine `1/(n+1)` giant-component envelope
    `topo_loss_on_giant_below_one_over_n` with Cat 1 Mathlib
    `tendsto_one_div_add_atTop_nhds_zero_nat`).  The retired
    unconditional `topo_loss_decay_below_pc` referenced the false
    `expectedTopoLoss n p`; the corrected statement uses the
    paper-faithful `expectedTopoLossOnGiant n p`.  The retired
    chain's threaded `h_perc_prob` (Grimmett percolation-probability)
    hypothesis is dropped — it was a Pattern-7 orphan (unused by the
    bound); the Cat 2 Grimmett dependency is carried by the
    `giantComponentEvent` carrier, surfacing in `#print axioms`.

    paper source: Theorem 3.3 Part 1 proof, line 417
    (giant-component-conditional `O(1/N)` envelope + convergence). -/
theorem topo_loss_decay_below_pc :
    ∀ p : ℝ, 0 ≤ p → p < harrisKestenCriticalProb →
      ∃ topo_loss_decay : ℕ → ℝ,
        Filter.Tendsto topo_loss_decay Filter.atTop (nhds 0) ∧
        ∀ n : ℕ, expectedTopoLossOnGiant n p ≤ topo_loss_decay n :=
  topo_loss_on_giant_below_envelope_exists

/-- **Cat 1 Mathlib derivation** of the eps-from-envelope step: given
    any `topo_loss_decay : ℕ → ℝ` with `Tendsto _ atTop (nhds 0)` and
    per-`n` upper-bound dominance `expectedTopoLossOnGiant n p ≤
    topo_loss_decay n`, the paper-stated `∀ ε > 0, ∃ N, ∀ n ≥ N,
    expectedTopoLossOnGiant n p < ε` form follows by standard ε-δ
    Tendsto unfolding.

    R86: the statement is updated from the retired
    `topo_loss_decay_arbitrary_threshold` (which referenced the false
    unconditional `expectedTopoLoss n p`) to the paper-faithful
    giant-component-conditional `expectedTopoLossOnGiant n p`; thin
    Phase.lean wrapper around the `Wrongness.lean` R86 Cat 1 theorem
    `topo_loss_on_giant_below_eps_from_envelope` (unchanged
    Mathlib-routine ε-δ unfolding, R42/R44 Pattern-1 fix).

    paper source: Theorem 3.3 Part 1 proof, line 417 (asymptotic
    convergence `O(1/N) → 0` on the giant-component event). -/
theorem topo_loss_decay_arbitrary_threshold :
    ∀ p : ℝ,
      (∃ topo_loss_decay : ℕ → ℝ,
        Filter.Tendsto topo_loss_decay Filter.atTop (nhds 0) ∧
        ∀ n : ℕ, expectedTopoLossOnGiant n p ≤ topo_loss_decay n) →
      ∀ ε : ℝ, 0 < ε →
        ∃ N : ℕ, ∀ n, N ≤ n → expectedTopoLossOnGiant n p < ε :=
  topo_loss_on_giant_below_eps_from_envelope

/-- **Theorem 3.3 (`thm:phase`) Part 1: R86 paper-faithful derived
    theorem.**  Below threshold (`p < p_c`), the topological loss
    *on the giant-component event* `expectedTopoLossOnGiant n p`
    converges to `0` as `n → ∞`.

    **R86 SOUNDNESS-DEFECT FIX.**  The retired version concluded the
    *unconditional* `expectedTopoLoss n p → 0`, which is FALSE below
    threshold.  The corrected conclusion is the
    giant-component-conditional convergence — paper Theorem 3.3 Part 1
    line 404's genuine content.  Per `feedback_truth_over_publication`
    + R83 precedent, the signature correction to the true paper claim
    + the genuine derivation IS the honest closure.

    Composes the R86 derived theorems `topo_loss_decay_below_pc` (the
    explicit `1/(n+1)` envelope on the giant-component event, sourced
    from the `Percolation.lean` sub-event-expectation infrastructure
    + the signature-corrected `Wrongness.lean` structuralEquation atom
    `topoLossKernel_le_one_over_n_on_giant_atom_OPEN`) and
    `topo_loss_decay_arbitrary_threshold` (Cat 1 Mathlib ε-δ
    unfolding).  `gap_phase_transition_below` has no higher consumer
    (terminal derived theorem, verified by grep), so the correction
    is fully contained.  The retired chain's threaded `h_perc_prob`
    (Grimmett percolation-probability) hypothesis is dropped — it was
    a Pattern-7 orphan; the Cat 2 Grimmett dependency is carried by
    the `giantComponentEvent` carrier, surfacing in `#print axioms`.

    paper source: Theorem 3.3 Part 1, lines 404, 415-419
    (giant-component-conditional convergence `W_topo → 0`). -/
theorem gap_phase_transition_below :
    ∀ p : ℝ, 0 ≤ p → p < harrisKestenCriticalProb →
      ∀ ε : ℝ, 0 < ε →
        ∃ N : ℕ, ∀ n, N ≤ n → expectedTopoLossOnGiant n p < ε := by
  intro p hp_nn hp_lt ε hε
  exact topo_loss_decay_arbitrary_threshold p
    (topo_loss_decay_below_pc p hp_nn hp_lt) ε hε

/-- Substantive paper claim — opaque carrier required (Mathlib gap).
    The information-to-topology ratio `|W_info(p, β)| / |W_topo(p)|`
    on `Z²` at blocking parameter `p` and signal precision `β`.

    paper source: Theorem 3.3 (`thm:phase`), part 2 (line 425). -/
axiom wInfoTopoRatio : ℝ → ℝ → ℝ

/- **Theorem 3.3 (`thm:phase`) Part 2: Above threshold**
    (`p > p_c = harrisKestenCriticalProb`).
    `|W_topo| = Θ(1)`; `|W_info| / |W_topo| = O(2^{-β}) → 0`. Composes
    the Cat 2 axiom `gap_grimmett_exponential_decay_OPEN`,
    `gap_info_decay_OPEN`, the wrongness lemma at `prop:trap-prevalence`.

    The bundled `gap_phase_transition_above_OPEN` axiom is now
    REPLACED by the derived theorem `gap_phase_transition_above`
    composing two atomic stipulations per `feedback_gap_ledger_in_lean4`
    §18 Manufactured-Recognition pattern: see
    `wInfoTopoRatio_const_exists_OPEN` (existence of positive constant)
    and `wInfoTopoRatio_bound_OPEN` (quantitative ratio bound) below.
    The Cat 2 Grimmett §6.75 exponential-decay dependency is threaded
    as the explicit `h_grimmett` antecedent for audit-chain visibility.

    paper source: Theorem 3.3 (`thm:phase`), lines 420-431;
    Grimmett 1999 _Percolation_ 2nd ed. §6.75 cited as the Cat 2
    exponential-decay dependency. -/

/-- R59 closure-path-A: new opaque carrier introduced as smaller
    replacement for the bundled `wInfoTopoRatio_const_exists_OPEN` +
    `wInfoTopoRatio_bound_OPEN`. The paper-stated Mills-tail constant
    `c(p) > 0` (paper Theorem 3.3 Part 2 proof lines 421-427) factored
    into the carrier so the existence + quantitative bound become
    derivable from atoms on the carrier rather than free-standing
    bundled claims.

    Substantive paper claim — opaque carrier required (Mathlib gap).
    The paper-stated decay constant `c(p)` for `wInfoTopoRatio p β`
    above the percolation threshold, characterising the exponential
    decay rate `wInfoTopoRatio p β = O(2^{-β})` per paper line 427.

    paper source: Theorem 3.3 (`thm:phase`), Part 2 proof, lines
    421-427 (Mills-tail + cluster-size composition giving the
    constant in `|W_info|/|W_topo| = O(2^{-β})`). -/
axiom wInfoTopoRatioMillsConst : ℝ → ℝ

/-- R59 closure-path-A: smaller paper-novel ATOMIC stipulation #1
    replacing the retired bundled `wInfoTopoRatio_const_exists_OPEN`.
    Paper Theorem 3.3 Part 2 proof line 421-427 derives that for
    `p > p_c`, the cluster size `|R(v_0)|` has exponentially decaying
    tail (Grimmett 1999 §6.75), so `E[|W_topo|] → E[1/(|R|+1)] = Θ(1)`
    while `|W_info| = O(2^{-β})` by `prop:info-decay`. The
    Mills-tail-over-cluster-size composition pins the constant to
    `wInfoTopoRatioMillsConst p > 0` for `p > p_c`.

    R59 strictly smaller than retired bundled atom: only positivity
    of the Mills-constant on the new opaque carrier
    `wInfoTopoRatioMillsConst` is asserted; the existential
    repackaging into `∃ c, 0 < c` is downstream Cat 0 derivation in
    the new derived theorem.

    Cat 3 sub-type: workingAssumption (paper-stated positivity of
    Mills-tail constant on opaque carrier; pending Mathlib percolation
    + Mills-tail composition machinery; 必须 close before publication).

    paper source: Theorem 3.3 Part 2 proof, lines 421-427 (cluster
    size exponential tail + Mills-tail Θ-bound); Grimmett 1999 §6.75
    + `prop:info-decay` cited as the Cat 2 dependencies. -/
axiom wInfoTopoRatioMillsConst_pos_above_pc_OPEN :
    (∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ c : ℝ, 0 < c ∧
        ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ)))) →
    ∀ p : ℝ, harrisKestenCriticalProb < p →
      0 < wInfoTopoRatioMillsConst p

/-- R59 closure-path-A: smaller paper-novel ATOMIC stipulation #2
    replacing the retired bundled `wInfoTopoRatio_bound_OPEN`. Paper
    Theorem 3.3 Part 2 proof line 427 derives the explicit ratio bound
    `|W_info(p, β)| / |W_topo(p)| = O(2^{-β})` from the Mills-tail
    composition; the resulting bound on the opaque `wInfoTopoRatio`
    carrier is the per-`(p, β)` inequality
    `wInfoTopoRatio p β ≤ wInfoTopoRatioMillsConst p * 2^{-β}` at the
    paper-stated Mills-tail constant.

    R59 strictly smaller than retired bundled atom: the bound is
    asserted only at the carrier-pinned constant `wInfoTopoRatioMillsConst p`,
    not for arbitrary `c > 0` (the prior atom's `∀ c > 0` form was
    semantically stronger than what paper proves — paper's c is the
    specific Mills-tail constant, not arbitrary).

    Cat 3 sub-type: workingAssumption (paper-stated quantitative bound
    on opaque carriers `wInfoTopoRatio` and `wInfoTopoRatioMillsConst`;
    pending Mathlib Mills-tail + percolation composition; 必须 close
    before publication).

    paper source: Theorem 3.3 Part 2 proof, line 427 (`|W_info| /
    |W_topo| = O(2^{-β}) → 0`); Grimmett 1999 §6.75 + `prop:info-decay`
    composition. -/
axiom wInfoTopoRatio_le_MillsConst_decay_OPEN :
    (∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ c : ℝ, 0 < c ∧
        ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ)))) →
    ∀ p : ℝ, harrisKestenCriticalProb < p →
      ∀ β : ℝ, 0 < β →
        wInfoTopoRatio p β ≤ wInfoTopoRatioMillsConst p * Real.rpow 2 (-β)

/-- **Theorem 3.3 (`thm:phase`) Part 2: derived theorem.** Above
    threshold (`p > p_c`), the information-to-topology ratio
    `wInfoTopoRatio p β` is bounded by `c * 2^{-β}` for some positive
    constant `c`.

    R59 closure-path-A re-derivation: the bundled
    `gap_phase_transition_above_OPEN` was originally decomposed (R37)
    into the bundled `wInfoTopoRatio_const_exists_OPEN` +
    `wInfoTopoRatio_bound_OPEN` axioms; R59 further decomposes via
    Path A into a new opaque carrier `wInfoTopoRatioMillsConst` plus
    two strictly-smaller atoms:
      (a) `wInfoTopoRatioMillsConst_pos_above_pc_OPEN` (Cat 3
          workingAssumption — paper line 421-427 Mills-constant
          positivity on the new carrier), AND
      (b) `wInfoTopoRatio_le_MillsConst_decay_OPEN` (Cat 3
          workingAssumption — paper line 427 quantitative bound at
          the carrier-pinned constant).
    The derived theorem instantiates the existential with
    `wInfoTopoRatioMillsConst p`. The Cat 2 Grimmett §6.75
    exponential-decay dependency remains threaded through `h_grimmett`.

    paper source: Theorem 3.3 Part 2, lines 420-431. -/
theorem gap_phase_transition_above
    (h_grimmett :
      ∀ p : ℝ, harrisKestenCriticalProb < p →
        ∃ c : ℝ, 0 < c ∧
          ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ))))
    (p : ℝ) (hp : harrisKestenCriticalProb < p) :
    ∃ c : ℝ, 0 < c ∧
      ∀ β : ℝ, 0 < β →
        wInfoTopoRatio p β ≤ c * Real.rpow 2 (-β) := by
  refine ⟨wInfoTopoRatioMillsConst p,
          wInfoTopoRatioMillsConst_pos_above_pc_OPEN h_grimmett p hp,
          ?_⟩
  intros β hβ
  exact wInfoTopoRatio_le_MillsConst_decay_OPEN h_grimmett p hp β hβ

/-! ## 3. Proposition `prop:trap-prevalence`

For `p > p_c` on `Z²`, the probability that a random vertex `v` has
neighbours `u_1, u_2` with `V_static(u_1) > V_static(u_2)` but
`V_dyn(u_1) < V_dyn(u_2)` is bounded below by a positive constant
depending on `p`. -/

/-- R59 closure-path-B: smaller paper-novel ATOMIC structural equation
    #1 replacing the retired bundled `forward_reachable_full_at_zero_OPEN`.
    Paper Definition 2.1 (line 108) introduces `G = (V, E)` as a
    CONNECTED undirected graph on `n` nodes — this connectivity is a
    structural assumption on the action graph that the paper invokes
    implicitly throughout (e.g. `R(v_0)` would be a strict subset of `V`
    even at `p = 0` if the graph were disconnected). At `blockingProb
    = 0` (no edges blocked), the percolation realisation is the
    full-edge subgraph of `G`, and the `H = ∅` forward-reachable set
    is the entire connected component of `v` in this full subgraph.

    R59 strictly smaller than retired bundled atom: this atom isolates
    only the connected-component identification with `Finset.univ`
    (which depends on paper Def 2.1 connectivity); the bond-percolation
    semantics linking `blockingProb = 0` to the full-edge subgraph is
    isolated as a separate Cat 3 atom
    `all_edges_open_at_zero_blocking_OPEN` below.

    Cat 3 sub-type: workingAssumption (paper-stated structural equation
    consequent on Def 2.1 connectivity + Def 2.2/2.5 reachable-set
    semantics; pending Mathlib graph-theoretic infrastructure to
    formalise the Def 2.1 connected-graph carrier and the
    full-edge-subgraph identification; 必须 close before publication).

    R68 NOTE: examined for §3.4.3 reclassification candidacy and rejected.
    While paper Def 2.1 (G connected) + Def 2.5 (forward-reachable
    construction) are both paper Definitions, the conclusion
    `ForwardReachable v ∅ ω = Finset.univ under all-edges-open` is a
    graph-theoretic consequence (connected graph + all-open subgraph →
    reachable component = vertex set) rather than a paper-DEFINING
    stipulation on the carrier. Paper line 463 derives this; it is not
    paper-Def stipulated. Per R52/R45 boundary precedent, paper-derived
    graph-theoretic consequences classify as workingAssumption pending
    paper proof reconstruction OR Mathlib graph infrastructure.

    paper source: Definition 2.1 (line 108, `G = (V, E)` is a
    connected undirected graph) + Definition 2.5 (`def:forward-reachable`,
    paper line 187-194 forward-reachable construction at `H = ∅`)
    specialised to the all-edges-open subgraph. -/
axiom forward_reachable_empty_full_at_all_open_OPEN :
    ∀ [Fintype Vertex] (v : Vertex) (ω : PercolationOutcome),
      (∀ u w : Vertex, IsEdge u w → IsOpen ω u w) →
        ForwardReachable v ∅ ω = Finset.univ

/-- R59 closure-path-B: smaller paper-novel ATOMIC structural equation
    #2 replacing the retired bundled `forward_reachable_full_at_zero_OPEN`.
    Paper Definition 2.1 (line 119) introduces bond percolation on `G`:
    "Each edge `e ∈ E` is independently blocked with probability `p`",
    so at `blockingProb = 0` the realised percolation outcome has every
    edge OPEN with probability 1; under the paper's structural
    quantification over realised outcomes (paper §2.5 inner expectation
    "over reward signals, topology signals, and the intrinsic
    preference realization"), the substantive content is that the
    paper's reachable-set claims at `p = 0` are evaluated on the
    all-edges-open realisation.

    R59 strictly smaller than retired bundled atom: this atom isolates
    only the percolation-semantics binding `blockingProb = 0 → all
    edges open`, leaving the connected-component → `Finset.univ`
    identification to atom #1.

    R68 §3.4.3 reclassification (was R59 workingAssumption): paper
    Definition 2.1 line 119 STIPULATES the bond-percolation construction
    "Each edge `e ∈ E` is independently blocked with probability `p`".
    At the boundary value `p = 0`, the percolation measure assigns
    blocking probability 0 to every edge, so the paper-stipulated
    semantics fix every realised outcome ω (drawn from this measure)
    to have every edge OPEN. This is the paper Definition's DEFINING
    semantics of the boundary value `p = 0` — analogous to the
    discipline §3.4.3 canonical example `V_dyn_def` (paper Definition
    2.2 stipulating how V_dyn behaves on its primitive carrier domain).

    The atom is the discretized realization of the paper-Def-stipulated
    measure-theoretic identity "at `p = 0`, every realised ω has every
    edge open with probability 1"; the Lean signature folds the "with
    probability 1" into universal quantification over ω because the
    percolation outcome carrier is the discrete witness type. The
    paper's Def 2.1 line 119 commits the percolation primitive to this
    `p = 0` boundary semantics, making it a structural identity on the
    `PercolationOutcome` carrier under `blockingProb = 0`.

    Mirrors `expectedTopoLoss_le_one_atom` precedent (R55 PASS criterion
    #3 boundary): paper Definition 2.1 line 113 reward-range stipulation
    `r: V → [0, 1]` is structural identity on the reward carrier; here
    paper Def 2.1 line 119 percolation-blocking stipulation is structural
    identity on the percolation-outcome carrier under the boundary value
    `blockingProb = 0`.

    Cat 3 sub-type: structuralEquation (paper-Def-stipulated bond-
    percolation semantics binding `blockingProb = 0` to the all-edges-
    open realisation per Definition 2.1 line 119; 永不 close per
    discipline §3.4.3 — this is paper's commitment to the percolation
    primitive's boundary semantics at p = 0).

    paper source: Definition 2.1, line 119 ("Each edge `e ∈ E` is
    independently blocked with probability `p`" — paper-Def-stipulated
    bond-percolation semantics + the paper-implicit boundary reading
    at `p = 0`). -/
axiom all_edges_open_at_zero_blocking_OPEN :
    ∀ (ω : PercolationOutcome),
      blockingProb = 0 →
        ∀ u w : Vertex, IsEdge u w → IsOpen ω u w

/-- **R59 derived theorem** (replaces retired bundled
    `forward_reachable_full_at_zero_OPEN`). At `blockingProb = 0`, the
    forward-reachable set from any vertex `v` under EMPTY history
    equals the entire vertex carrier `Finset.univ`.

    R59 closure-path-B decomposition: the original bundled atom
    packaged (i) bond-percolation semantics linking `blockingProb = 0`
    to the all-edges-open realisation + (ii) the connected-graph
    forward-reachable-equals-univ identification into one
    workingAssumption. Decomposed into two strictly-smaller paper-
    novel atoms:
      (a) `all_edges_open_at_zero_blocking_OPEN` (Cat 3
          workingAssumption — paper Def 2.1 line 119 percolation
          semantics binding), AND
      (b) `forward_reachable_empty_full_at_all_open_OPEN` (Cat 3
          workingAssumption — paper Def 2.1 connectivity + Def 2.5
          full-edge-subgraph forward-reachable identification).
    Each smaller atom is more atomic per §18 + has an explicit paper
    Definition close target.

    paper source: Proposition `prop:trap-prevalence` Part 1 proof,
    line 463 (`R(v) = V` for all `v` when no edges are blocked), now
    derived from Def 2.1 + Def 2.5 atoms. -/
theorem forward_reachable_full_at_zero
    [Fintype Vertex] (v : Vertex) (ω : PercolationOutcome)
    (h_p_zero : blockingProb = 0) :
    ForwardReachable v ∅ ω = Finset.univ :=
  forward_reachable_empty_full_at_all_open_OPEN v ω
    (all_edges_open_at_zero_blocking_OPEN ω h_p_zero)

/-- **Proposition `prop:trap-prevalence` Part 1** — Cat 3 derived
    closure. At `blockingProb = 0`, all vertices have the same dynamic
    value `V_dyn = sSup r` because every vertex's forward-reachable set
    (under EMPTY history, matching paper Def 2.2 `R(v)`) coincides with
    the full vertex carrier `Finset.univ`. Hence the Vstatic/Vdyn rankings
    agree on all neighbours.

    Refactored from the prior `gap_trap_prevalence_zero_OPEN` per
    `feedback_gap_ledger_in_lean4` 2026-05-13 anti-pattern repair, then
    restated per the SCOPE-INFLATION audit: the prior axiom form
    (`V_dyn u {v} ω = V_dyn v ∅ ω`) and the prior `∀ H` atom form were
    SCOPE-INFLATED beyond paper line 463 — paper's `R(v) = V` is the
    `H = ∅` (i.e. `ReachableSet`) statement. The refactored statement
    encodes the paper's actual conclusion (`V_dyn` is constant over the
    `H = ∅` family at `p = 0`) and is derived from the H=∅-scoped
    Cat 3 atomic structural equation `forward_reachable_full_at_zero_OPEN`
    plus the existing `V_dyn_def` atom — the equality follows because
    both sides reduce to a `sup'` over the SAME carrier `Finset.univ`
    (with both witnesses providing the same non-emptiness data).

    paper source: Proposition `prop:trap-prevalence` Part 1, line 457
    + line 463 proof. -/
theorem gap_trap_prevalence_zero
    [Fintype Vertex]
    (v : Vertex) (ω : PercolationOutcome)
    (h_p_zero : blockingProb = 0) :
    ∀ u : Vertex, IsEdge v u →
      V_dyn u ∅ ω = V_dyn v ∅ ω := by
  intro u _h_edge
  have h_eq_u : ForwardReachable u ∅ ω = Finset.univ :=
    forward_reachable_full_at_zero u ω h_p_zero
  have h_eq_v : ForwardReachable v ∅ ω = Finset.univ :=
    forward_reachable_full_at_zero v ω h_p_zero
  rw [V_dyn_def u ∅ ω, V_dyn_def v ∅ ω]
  -- Both sides equal `Finset.univ.sup' _ reward` via `Finset.sup'_congr`
  -- (Mathlib `Data/Finset/Lattice/Fold.lean:587`). Bring both sides to
  -- this normal form, then close by `rfl` (sup' is independent of the
  -- proof witness — the proof argument is propext-style irrelevant in
  -- the conclusion of `sup'_congr`).
  rw [Finset.sup'_congr ⟨u, ForwardReachable_self_member u ∅ ω⟩ h_eq_u
        (fun _ _ => rfl),
      Finset.sup'_congr ⟨v, ForwardReachable_self_member v ∅ ω⟩ h_eq_v
        (fun _ _ => rfl)]

/-- Substantive paper claim — opaque carrier required (Mathlib gap).
    Probability that a uniformly chosen vertex on `Z²` exhibits the
    (V_static, V_dyn) misalignment under bond percolation at parameter
    `p`. The paper-classical constant is zero at and below `p_c = 1/2`,
    strictly positive above.
    paper source: Proposition `prop:trap-prevalence` Part 2. -/
axiom trapMisalignmentProbability : ℝ → ℝ

/-- R59 closure-path-A: explicit Hodge-style closed-form encoding of the
    paper's local-FKG lower-bound formula for the trap pattern. Paper
    Proposition `prop:trap-prevalence` Part 2 proof line 473 gives the
    explicit local-FKG estimate `binom(4, 2) p² (1-p)² · p^3 > 0` on
    the lattice with degree 4 — six choices of two edges incident to `v`
    being open (probability `(1-p)²` each), the other two incident
    edges being blocked (probability `p²`), and the chosen `u_1`
    neighbour having its remaining three incident edges blocked
    (probability `p^3` so that `|C_1| = 1`). The product is
    `6 * (1-p)^2 * p^2 * p^3 = 6 * p^5 * (1-p)^2`.

    Hodge-style closed form: the def IS the paper's stated formula
    (paper line 473 `binom(4, 2) p² (1-p)² · p^3 > 0`); the
    substantive FKG-positivity binding to the opaque
    `trapMisalignmentProbability` carrier remains a Cat 3
    workingAssumption (atom `trapConfigLocalProb_le_misalignmentProb_OPEN`
    below). -/
noncomputable def trapConfigLocalProb (p : ℝ) : ℝ :=
  6 * p ^ 5 * (1 - p) ^ 2

/-- R59 closure-path-A: smaller paper-novel ATOMIC stipulation
    replacing the retired `trap_config_local_positive_OPEN`. Paper
    Proposition `prop:trap-prevalence` Part 2 proof line 473 binds the
    local-FKG estimate `binom(4, 2) p² (1-p)² · p^3 = 6 * p^5 * (1-p)^2`
    as a LOWER BOUND on `trapMisalignmentProbability p` for `p > p_c`
    via FKG-positivity of the local trap pattern (`v` has exactly two
    open edges + `u_1` isolated + `|C_2| ≥ 2`).

    R59 strictly smaller than retired bundled atom: the FKG-positivity
    binding `trapConfigLocalProb p ≤ trapMisalignmentProbability p` is
    isolated from the arithmetic positivity claim
    `0 < trapConfigLocalProb p` (which becomes Cat 1 derivation in
    `trapConfigLocalProb_pos`). The retired atom packaged both into
    `0 < trapMisalignmentProbability p`.

    Cat 3 sub-type: workingAssumption (paper-stated FKG lower-bound
    binding on opaque `trapMisalignmentProbability` carrier; pending
    Mathlib Z²-lattice + bond-percolation measure machinery; 必须
    close before publication).

    paper source: Proposition `prop:trap-prevalence` Part 2 proof,
    line 473 (`binom(4, 2) p² (1-p)² · p^3 > 0` local-FKG lower
    bound on the lattice-degree-4 trap pattern). -/
axiom trapConfigLocalProb_le_misalignmentProb_OPEN :
    ∀ p : ℝ, harrisKestenCriticalProb < p → p < 1 →
      trapConfigLocalProb p ≤ trapMisalignmentProbability p

/-- **Cat 1 Mathlib derivation** of the arithmetic positivity of the
    paper's local-FKG closed form. Given `0 < p < 1` (which follows
    from `harrisKestenCriticalProb < p < 1` plus
    `harrisKestenCriticalProb = 1/2 > 0` from `gap_harris_kesten_OPEN`),
    the closed form `6 * p^5 * (1-p)^2` is a product of strictly
    positive factors. Kernel-pure via `nlinarith` on the explicit
    polynomial form.

    R59: this Cat 1 step was previously bundled into the retired
    `trap_config_local_positive_OPEN` atom. -/
theorem trapConfigLocalProb_pos
    (p : ℝ) (hp_pc : harrisKestenCriticalProb < p) (hp_lt_one : p < 1) :
    0 < trapConfigLocalProb p := by
  have h_pc : harrisKestenCriticalProb = (1 : ℝ) / 2 := gap_harris_kesten_OPEN
  have h_p_pos : 0 < p := by rw [h_pc] at hp_pc; linarith
  have h_one_sub_p_pos : 0 < 1 - p := by linarith
  unfold trapConfigLocalProb
  have h_p5_pos : 0 < p ^ 5 := pow_pos h_p_pos 5
  have h_one_sub_p_sq_pos : 0 < (1 - p) ^ 2 := pow_pos h_one_sub_p_pos 2
  have h_six_pos : (0 : ℝ) < 6 := by norm_num
  exact mul_pos (mul_pos h_six_pos h_p5_pos) h_one_sub_p_sq_pos

/-- **Proposition `prop:trap-prevalence` Part 2: derived theorem.**
    For `p > p_c = harrisKestenCriticalProb` on `Z²` and `p < 1`, the
    trap configuration has positive lower-bounded probability.

    R59 closure-path-A re-derivation: the bundled
    `gap_trap_prevalence_above_threshold_OPEN` was originally
    decomposed (R37) into the single bundled atom
    `trap_config_local_positive_OPEN` (which packaged the FKG lower
    bound + arithmetic positivity into one workingAssumption). R59
    further decomposes via Path A into a Hodge-style closed form
    `trapConfigLocalProb p := 6 * p^5 * (1-p)^2` (paper line 473
    explicit formula) plus:
      (a) `trapConfigLocalProb_le_misalignmentProb_OPEN` (Cat 3
          workingAssumption — paper line 473 FKG lower-bound binding
          on the opaque `trapMisalignmentProbability` carrier),
      (b) `trapConfigLocalProb_pos` (Cat 1 Mathlib theorem — arithmetic
          positivity of the explicit closed form for `0 < p < 1`).
    The derived theorem composes both via transitivity of `<` and `≤`.

    The added `p < 1` antecedent matches the paper's implicit
    probability-domain assumption (paper Def 2.1 has
    `blockingProb ∈ [0, 1]`). The threshold antecedent consumes
    `harrisKestenCriticalProb` rather than the literal `1/2`; the
    paper-stated equality is recorded by `gap_harris_kesten_OPEN`.

    paper source: Proposition `prop:trap-prevalence` Part 2, lines 458-473. -/
theorem gap_trap_prevalence_above_threshold :
    ∀ p : ℝ, harrisKestenCriticalProb < p → p < 1 →
      0 < trapMisalignmentProbability p := by
  intro p hp_pc hp_lt_one
  exact lt_of_lt_of_le
    (trapConfigLocalProb_pos p hp_pc hp_lt_one)
    (trapConfigLocalProb_le_misalignmentProb_OPEN p hp_pc hp_lt_one)

/-! ## 4. Corollary `cor:er-phase` — Erdős–Rényi

On `G(n, c/n)`: if `c < 1`, all components are `O(log n)` and topology
dominates. If `c > 1`, the giant component has size `Θ(n)` for a
positive `ζ(c)` fraction of agents and information governs welfare. -/

/-- **Corollary `cor:er-phase` Part 1: subcritical ER.**
    `c < 1` gives `O(log n)` components and `|W_topo| = Θ(1)`.

    Consumes the Cat 2 axiom `gap_er_subcritical_OPEN` directly per the
    2026-05-13 discipline clarification (Cat 2 axioms with paper
    authority are consumed directly, not threaded as broken-link
    hypotheses).

    paper source: Corollary `cor:er-phase` Part 1, lines 1075-1077. -/
theorem gap_er_phase_subcritical
    (c : ℝ) (hc : c < 1) :
    ∃ K : ℝ, 0 < K ∧
      ∀ n : ℕ, 1 ≤ n → giantComponentSize_ER n c ≤ K * Real.log (n + 1) :=
  gap_er_subcritical_OPEN c hc

/-- **Corollary `cor:er-phase` Part 2: supercritical ER.**
    `c > 1` gives a giant component of size `Θ(n)` for a positive
    fraction `ζ(c) = poissonSurvival c > 0` of agents.

    Consumes the Cat 2 axiom `gap_er_supercritical_OPEN` directly per
    the 2026-05-13 discipline clarification (Cat 2 axioms with paper
    authority are consumed directly, not threaded as broken-link
    hypotheses).

    paper source: Corollary `cor:er-phase` Part 2, lines 1078-1080. -/
theorem gap_er_phase_supercritical
    (c : ℝ) (hc : 1 < c) : 0 < poissonSurvival c :=
  gap_er_supercritical_OPEN c hc

/-- Bond-percolation critical threshold for `G(n, c/n)`, encoded as
    its closed-form value `1 - 1/c` per the paper's stated formula
    (line 1080). Hodge-style paper-citation encoding: the def IS the
    paper's authority-cited closed form (Newman 2001 §IIIA generating-
    function derivation); the substantive Newman 2001 derivation
    remains a Mathlib gap, but the formula's correctness is taken
    on paper authority. -/
noncomputable def bondPercolationCriticalER (c : ℝ) : ℝ := 1 - 1 / c

/-- **Bond-percolation thinning of ER**: `p_c = 1 − 1/c`, with positivity
    `0 < p_c` for `c > 1`.

    The def `bondPercolationCriticalER c := 1 − 1/c` IS the paper's
    stated closed form (paper `\label{cor:er-phase}`). The theorem
    records both the consistency between the def and the paper formula
    AND the positivity assertion (which uses the `1 < c` hypothesis
    via `1 - 1/c > 0 ⟺ 1/c < 1 ⟺ 1 < c`). Pattern matches
    `gap_power_law_thin_tail`, which similarly bundles equality with
    positivity discharged from the hypothesis.

    paper source: Corollary `cor:er-phase` (`\citep{newman2001}` rigorous
    derivation; positivity from heavy-tail `c > 1` requirement). -/
theorem gap_er_bond_percolation_threshold :
    ∀ c : ℝ, 1 < c →
      bondPercolationCriticalER c = 1 - 1 / c
      ∧ 0 < bondPercolationCriticalER c := by
  intros c hc
  refine ⟨rfl, ?_⟩
  unfold bondPercolationCriticalER
  -- 0 < 1 - 1/c iff 1/c < 1 iff 1 < c (using 0 < c from 1 < c)
  have hc_pos : 0 < c := lt_trans zero_lt_one hc
  have h_inv_lt_one : 1 / c < 1 := by
    rw [div_lt_one hc_pos]; exact hc
  linarith

/-! ## 5. Corollary `cor:power-law` — Power-law networks

For configuration model with `Pr(D = k) ∝ k^{-γ}`:
* `2 < γ < 3` → `p_c = 1` (no non-trivial transition; topology vanishes
  at any `p < 1`).
* `γ > 3` → `p_c = 1 − E[D]/E[D(D−1)] > 0` by Molloy–Reed. -/

/-- **Corollary `cor:power-law` Part 1: heavy-tailed (`2 < γ ≤ 3`).**
    Giant component survives at any `p < 1`, hence `|W_topo| = O(1/n)`
    everywhere except at `p = 1`. Boundary `γ ≤ 3` matches Cohen et al.
    2000 (paper says α ≤ 3 closed boundary).

    Consumes the Cat 2 axiom `gap_cohen_powerlaw_OPEN` directly per the
    2026-05-13 discipline clarification (Cat 2 axioms with paper
    authority are consumed directly, not threaded as broken-link
    hypotheses).

    paper source: Corollary `cor:power-law` Part 1, lines 1090-1093. -/
theorem gap_power_law_heavy_tail
    (γ : ℝ) (hγ : 2 < γ ∧ γ ≤ 3) :
    ∀ p : ℝ, 0 ≤ p → p < 1 →
      ∃ E_D E_D_DSub1 : ℝ, 0 < E_D ∧
        HasGiantComponent (E_D * (1 - p)) (E_D_DSub1 * (1 - p)^2) :=
  gap_cohen_powerlaw_OPEN γ hγ

/-- Bond-percolation critical threshold for the configuration model
    with given degree-distribution moments, encoded as its closed-form
    value `1 - E_D / E_D_DSub1` per the paper's stated formula (line
    1092). Hodge-style paper-citation encoding. -/
noncomputable def bondPercolationCritical_ConfigModel
    (E_D E_D_DSub1 : ℝ) : ℝ := 1 - E_D / E_D_DSub1

/-- **Corollary `cor:power-law` Part 2: thin-tailed (`γ > 3`).**
    `p_c = 1 − E[D]/E[D(D−1)] > 0` by Molloy-Reed criterion specialised
    to bond-thinning. Statement includes both the equality (encoded by
    the def) AND the `> 0` positivity assertion (proved from `0 < E_D`
    and `E_D < E_D_DSub1`, which the paper derives from `γ > 3` since
    `E[D(D-1)] > E[D]` for heavy-tailed distributions).

    The def IS the paper's stated closed form (line 1092 +
    `\citep{molloy1995,cohen2000,newman2001}`). Equality clause is
    `rfl`; positivity clause is proved from the hypotheses.

    Cat 2 dependency on Molloy-Reed 1995 is consumed implicitly through
    the axiom system per the 2026-05-13 discipline clarification (Cat 2
    axioms with paper authority are consumed directly, not threaded as
    broken-link hypotheses). The relevant Cat 2 axiom lives at
    `ClassicalResults.lean :: gap_molloy_reed_OPEN` (paper line 1092
    derives the closed form `p_c = 1 - E[D]/E[D(D−1)]` BY the
    Molloy-Reed criterion).

    paper source: Corollary `cor:power-law` Part 2, lines 1093-1094. -/
theorem gap_power_law_thin_tail :
    ∀ γ : ℝ, 3 < γ →
      ∀ E_D E_D_DSub1 : ℝ, 0 < E_D → E_D < E_D_DSub1 →
        bondPercolationCritical_ConfigModel E_D E_D_DSub1 = 1 - E_D / E_D_DSub1
        ∧ 0 < bondPercolationCritical_ConfigModel E_D E_D_DSub1 := by
  intros _ _ E_D E_D_DSub1 hE_D hE_lt
  refine ⟨rfl, ?_⟩
  unfold bondPercolationCritical_ConfigModel
  -- 0 < 1 - E_D / E_D_DSub1 iff E_D / E_D_DSub1 < 1 iff E_D < E_D_DSub1
  have hE_DSub1_pos : 0 < E_D_DSub1 := lt_trans hE_D hE_lt
  have h_div_lt_one : E_D / E_D_DSub1 < 1 := by
    rw [div_lt_one hE_DSub1_pos]; exact hE_lt
  linarith

end BlackwellDilemma
