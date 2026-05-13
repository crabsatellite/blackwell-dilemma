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

/-- Cat 3 paper-novel ATOMIC stipulation: paper Theorem 3.3 Part 1
    (proof line 415-417) derives that conditional on `v_0` lying in the
    giant component with `|R(v_0)| = k = Θ(N)`, Proposition
    `prop:topo-cluster` gives `E[|W_topo| | |R| = k] = (N - k) / ((N+1)
    (k+1)) = O(1/N) → 0`. Aggregated over the giant-component event
    (probability `θ(1-p) > 0` by Harris-Kesten + Grimmett percolation-
    probability), the unconditional `expectedTopoLoss n p` admits a
    decay function `topo_loss_decay_below : ℕ → ℝ` (the per-`n` upper
    bound `expectedTopoLoss n p ≤ topo_loss_decay_below n`) that
    converges to `0` as `n → ∞`. This atomic stipulation isolates the
    EXISTENCE of such a decay-function envelope on the existing
    carrier `expectedTopoLoss`.

    Encoding choice: extracted from the bundled
    `gap_phase_transition_below_OPEN` per `feedback_gap_ledger_in_lean4`
    §18 Manufactured-Recognition pattern (decompose bundled conclusion-
    axiom into atomic stipulations + derived theorem). The Cat 2
    Grimmett dependency is threaded as the explicit `h_perc_prob`
    antecedent (paper authority for `θ(1-p) > 0` below threshold).

    Cat 3 sub-type: workingAssumption (paper-stated existence of decay
    envelope; pending Mathlib percolation + cluster-size-asymptotics
    machinery; 必须 close before publication).

    paper source: Theorem 3.3 Part 1 proof, lines 415-417 (`E[|W_topo|]
    = O(1/N) → 0` via giant-component conditioning + topo-cluster
    formula); Grimmett 1999 cited as the Cat 2 percolation-probability
    dependency. -/
axiom topo_loss_decay_below_pc_OPEN :
    (∃ θ : ℝ → ℝ,
      (∀ p : ℝ, p < harrisKestenCriticalProb → 0 < θ (1 - p)) ∧
      (∀ p : ℝ, harrisKestenCriticalProb ≤ p → θ (1 - p) = 0)) →
    ∀ p : ℝ, 0 ≤ p → p < harrisKestenCriticalProb →
      ∃ topo_loss_decay : ℕ → ℝ,
        Filter.Tendsto topo_loss_decay Filter.atTop (nhds 0) ∧
        ∀ n : ℕ, expectedTopoLoss n p ≤ topo_loss_decay n

/-- Cat 3 paper-novel ATOMIC stipulation: paper Theorem 3.3 Part 1
    (proof line 417) derives the asymptotic ε-N convergence form
    `∀ ε > 0, ∃ N, ∀ n ≥ N, expectedTopoLoss n p < ε` from the existence
    of a decay-function envelope `topo_loss_decay : ℕ → ℝ` with
    `topo_loss_decay → 0`. This atomic stipulation isolates the
    arbitrary-threshold convergence from the decay-function-existence
    fact: given any `topo_loss_decay : ℕ → ℝ` with `Tendsto _ atTop (nhds 0)`,
    the eventually-below-ε bound on `expectedTopoLoss n p` follows.

    Encoding choice: extracted from the bundled
    `gap_phase_transition_below_OPEN` per `feedback_gap_ledger_in_lean4`
    §18 Manufactured-Recognition pattern. This is the second atomic
    stipulation completing the decomposition: the first
    (`topo_loss_decay_below_pc_OPEN`) provides the decay envelope; this
    one converts the envelope into the paper-stated arbitrary-ε bound.
    Both atoms together (under the Cat 2 Grimmett antecedent) compose
    the original bundled axiom's content.

    Cat 3 sub-type: workingAssumption (paper-stated arbitrary-threshold
    convergence; pending the substantive `topo_loss_decay` envelope
    from `topo_loss_decay_below_pc_OPEN` + standard ε-δ Tendsto
    unfolding; 必须 close before publication. Note: the unfolding step
    itself is Cat 1 derivable from Mathlib `Filter.Tendsto`, but this
    atomic axiom is retained as a paper-stated structural form to keep
    the §18 decomposition surface honest at the abstraction level —
    the paper-stated convergence is the operative downstream content).

    paper source: Theorem 3.3 Part 1 proof, line 417 (asymptotic
    convergence `O(1/N) → 0`). -/
axiom topo_loss_decay_arbitrary_threshold_OPEN :
    ∀ p : ℝ,
      (∃ topo_loss_decay : ℕ → ℝ,
        Filter.Tendsto topo_loss_decay Filter.atTop (nhds 0) ∧
        ∀ n : ℕ, expectedTopoLoss n p ≤ topo_loss_decay n) →
      ∀ ε : ℝ, 0 < ε →
        ∃ N : ℕ, ∀ n, N ≤ n → expectedTopoLoss n p < ε

/-- **Theorem 3.3 (`thm:phase`) Part 1: derived theorem.** Below
    threshold (`p < p_c`), the topological loss `expectedTopoLoss n p`
    converges to `0` as `n → ∞`. Decomposed from the bundled
    `gap_phase_transition_below_OPEN` axiom into (a) `topo_loss_decay_
    below_pc_OPEN` (existence of decay envelope) + (b) `topo_loss_
    decay_arbitrary_threshold_OPEN` (arbitrary-ε convergence from
    envelope). The derived theorem composes both atoms.

    paper source: Theorem 3.3 Part 1, lines 400-419. -/
theorem gap_phase_transition_below
    (h_perc_prob :
      ∃ θ : ℝ → ℝ,
        (∀ p : ℝ, p < harrisKestenCriticalProb → 0 < θ (1 - p)) ∧
        (∀ p : ℝ, harrisKestenCriticalProb ≤ p → θ (1 - p) = 0)) :
    ∀ p : ℝ, 0 ≤ p → p < harrisKestenCriticalProb →
      ∀ ε : ℝ, 0 < ε →
        ∃ N : ℕ, ∀ n, N ≤ n → expectedTopoLoss n p < ε := by
  intro p hp_nn hp_lt ε hε
  exact topo_loss_decay_arbitrary_threshold_OPEN p
    (topo_loss_decay_below_pc_OPEN h_perc_prob p hp_nn hp_lt) ε hε

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

/-- Cat 3 paper-novel ATOMIC stipulation: paper Theorem 3.3 Part 2
    (proof lines 421-427) derives that for `p > p_c`, the cluster
    size `|R(v_0)|` has exponentially decaying tail (Grimmett 1999
    §6.75), so `E[|W_topo|] → E[1/(|R|+1)] = Θ(1)` while `|W_info| =
    O(2^{-β})` by `prop:info-decay`. The ratio `|W_info|/|W_topo|` has
    a positive constant `c(p) > 0` characterising the exponential
    decay rate. This atomic stipulation isolates the EXISTENCE of
    such a positive constant `c` on the existing carrier
    `wInfoTopoRatio`.

    Encoding choice: extracted from the bundled
    `gap_phase_transition_above_OPEN` per `feedback_gap_ledger_in_lean4`
    §18 Manufactured-Recognition pattern (decompose bundled
    conclusion-axiom into atomic stipulations + derived theorem). The
    Cat 2 Grimmett dependency is threaded as the explicit
    `h_grimmett` antecedent for audit-chain visibility.

    Cat 3 sub-type: workingAssumption (paper-stated existence of
    positive constant; pending Mathlib percolation + Mills-tail
    composition; 必须 close before publication).

    paper source: Theorem 3.3 Part 2 proof, lines 421-427 (cluster
    size exponential tail + ratio Θ-bound); Grimmett 1999 §6.75
    cited as the Cat 2 dependency. -/
axiom wInfoTopoRatio_const_exists_OPEN :
    (∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ c : ℝ, 0 < c ∧
        ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ)))) →
    ∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ c : ℝ, 0 < c

/-- Cat 3 paper-novel ATOMIC stipulation: paper Theorem 3.3 Part 2
    (proof line 427) derives the explicit ratio bound `|W_info(p, β)|
    / |W_topo(p)| = O(2^{-β})` from the composition of the Mills-tail
    `|W_info| = O(2^{-β})` (paper `prop:info-decay`) with the cluster-
    size exponential tail giving `|W_topo| = Θ(1)`. The bound
    `wInfoTopoRatio p β ≤ c * 2^{-β}` holds for any positive constant
    `c` matching the Mills + cluster composition rate. This atomic
    stipulation isolates the QUANTITATIVE bound on the existing
    carrier `wInfoTopoRatio` given a positive constant `c`.

    Encoding choice: extracted from the bundled
    `gap_phase_transition_above_OPEN` per `feedback_gap_ledger_in_lean4`
    §18 Manufactured-Recognition pattern. The Cat 2 Grimmett
    dependency is threaded as the explicit `h_grimmett` antecedent
    for audit-chain visibility.

    Cat 3 sub-type: workingAssumption (paper-stated quantitative
    bound on opaque carrier `wInfoTopoRatio`; pending Mathlib
    Mills-tail + percolation composition; 必须 close before publication).

    paper source: Theorem 3.3 Part 2 proof, line 427 (`|W_info|
    / |W_topo| = O(2^{-β}) → 0`); Grimmett 1999 §6.75 + `prop:info-
    decay` composition. -/
axiom wInfoTopoRatio_bound_OPEN :
    (∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ c : ℝ, 0 < c ∧
        ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ)))) →
    ∀ p : ℝ, harrisKestenCriticalProb < p →
      ∀ c : ℝ, 0 < c →
        ∀ β : ℝ, 0 < β →
          wInfoTopoRatio p β ≤ c * Real.rpow 2 (-β)

/-- **Theorem 3.3 (`thm:phase`) Part 2: derived theorem.** Above
    threshold (`p > p_c`), the information-to-topology ratio
    `wInfoTopoRatio p β` is bounded by `c * 2^{-β}` for some positive
    constant `c`. Decomposed from the bundled
    `gap_phase_transition_above_OPEN` axiom into (a)
    `wInfoTopoRatio_const_exists_OPEN` (existence of positive
    constant) + (b) `wInfoTopoRatio_bound_OPEN` (quantitative ratio
    bound). The derived theorem composes both atoms.

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
  obtain ⟨c, hc_pos⟩ := wInfoTopoRatio_const_exists_OPEN h_grimmett p hp
  refine ⟨c, hc_pos, ?_⟩
  intros β hβ
  exact wInfoTopoRatio_bound_OPEN h_grimmett p hp c hc_pos β hβ

/-! ## 3. Proposition `prop:trap-prevalence`

For `p > p_c` on `Z²`, the probability that a random vertex `v` has
neighbours `u_1, u_2` with `V_static(u_1) > V_static(u_2)` but
`V_dyn(u_1) < V_dyn(u_2)` is bounded below by a positive constant
depending on `p`. -/

/-- Cat 3 paper-novel ATOMIC structural equation: at `blockingProb = 0`,
    the forward-reachable set from any vertex `v` under EMPTY history
    equals the entire vertex carrier `Finset.univ`. Paper proof of
    Proposition `prop:trap-prevalence` Part 1 line 463 reads "When no
    edges are blocked, `R(v) = V` for all `v`": the entire vertex set is
    forward-reachable from any starting vertex when no edge is blocked.
    This atomic structural equation pins the paper-stated full-reachability
    fact at `p = 0` on the existing `ForwardReachable` carrier, scoped
    to the `H = ∅` base case that matches paper line 463 (the paper's
    `R(v)` is `ReachableSet` per Def 2.2, identified with
    `ForwardReachable v ∅ ω` via `ReachableSet_eq_ForwardReachable_empty`).
    Cat 1 reduction check: not Mathlib-derivable (depends on the paper's
    bond-percolation semantics that link `blockingProb = 0` to the
    all-edges-open realisation and the consequent connectivity claim).
    Cat 2 reduction check: paper-novel structural equation on the IDP
    primitives. Encoding choice: the `Fintype Vertex` instance is needed
    to express `Finset.univ`; declared as a Cat 3 atomic axiom alongside
    the existing `Vertex.decEq` because paper Definition 2.1 says the
    graph is on `n` nodes (finite).

    Scope discipline: the `H = ∅` restriction matches paper line 463
    exactly. For `H ∋ u` (e.g. `H = {v}` after visiting `v`), removing
    `v` from a connected graph could disconnect it, so
    `ForwardReachable u {v} ω ≠ Finset.univ` in general at `p = 0` (a
    formerly-overclaimed `∀ H` form would be SCOPE-INFLATED beyond the
    paper).

    paper source: Proposition `prop:trap-prevalence` Part 1 proof, line
    463 ("When no edges are blocked, `R(v) = V` for all `v`"). -/
axiom forward_reachable_full_at_zero_OPEN :
    ∀ [Fintype Vertex] (v : Vertex) (ω : PercolationOutcome),
      blockingProb = 0 → ForwardReachable v ∅ ω = Finset.univ

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
    forward_reachable_full_at_zero_OPEN u ω h_p_zero
  have h_eq_v : ForwardReachable v ∅ ω = Finset.univ :=
    forward_reachable_full_at_zero_OPEN v ω h_p_zero
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

/-- Cat 3 paper-novel ATOMIC stipulation: paper Proposition
    `prop:trap-prevalence` Part 2 proof (lines 467-473) derives that
    for `p > p_c` on `Z²`, the local configuration of (a) `v` having
    exactly two open edges to `u_1, u_2`, (b) `u_1` isolated
    (`|C_1| = 1`), and (c) `u_2` having `|C_2| ≥ 2`, has FKG-positive
    lower-bounded probability `≥ binom(4, 2) p² (1-p)² · p^3 > 0` on
    the lattice with degree 4 (paper line 473). The trap configuration
    on this local pattern thus contributes a paper-stated positive
    constant lower bound on `trapMisalignmentProbability p`. This
    atomic stipulation isolates the LOCAL FKG-positivity fact on the
    existing carrier `trapMisalignmentProbability`.

    Encoding choice: extracted from the bundled
    `gap_trap_prevalence_above_threshold_OPEN` per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition
    pattern (decompose bundled conclusion-axiom into atomic
    stipulation + derived theorem). The paper's substantive content
    here is the local-FKG estimate (paper line 473
    `binom(4, 2) p² (1-p)² · p^3 > 0` plus FKG-positivity of the
    `|C_2| ≥ 2` event); the bundled axiom's `0 < trapMisalignmentProbability p`
    conclusion is the direct paper-stated positivity sub-clause.

    Cat 3 sub-type: workingAssumption (paper-stated FKG-positivity of
    the local trap pattern; pending Mathlib Z²-lattice + percolation-
    measure machinery; 必须 close before publication).

    paper source: Proposition `prop:trap-prevalence` Part 2 proof,
    line 473 (`binom(4, 2) p² (1-p)² · p^3 > 0` lattice-degree-4
    local FKG estimate). -/
axiom trap_config_local_positive_OPEN :
    ∀ p : ℝ, harrisKestenCriticalProb < p → 0 < trapMisalignmentProbability p

/-- **Proposition `prop:trap-prevalence` Part 2: derived theorem.**
    For `p > p_c = harrisKestenCriticalProb` on `Z²`, the trap
    configuration has positive lower-bounded probability. Decomposed
    from the bundled `gap_trap_prevalence_above_threshold_OPEN`
    axiom into the atomic stipulation `trap_config_local_positive_OPEN`
    (paper-stated FKG estimate). The derived theorem re-exports.

    The hypothesis consumes `harrisKestenCriticalProb` rather than the
    literal `1/2`; the paper-stated equality is recorded by the
    Cat 2 axiom `gap_harris_kesten_OPEN`.

    paper source: Proposition `prop:trap-prevalence` Part 2, lines 458-473. -/
theorem gap_trap_prevalence_above_threshold :
    ∀ p : ℝ, harrisKestenCriticalProb < p → 0 < trapMisalignmentProbability p :=
  trap_config_local_positive_OPEN

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
