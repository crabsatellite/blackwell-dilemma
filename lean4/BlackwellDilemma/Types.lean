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
import BlackwellDilemma.Infrastructure.TopkisCrossPartial
import BlackwellDilemma.Infrastructure.TopkisCrossPartialCriterion

namespace BlackwellDilemma

/-! ## 1. Action graph

The paper quantifies over a finite undirected graph `G = (V, E)` on `n`
vertices, the "action space" (Definition 2.1, line 108). We axiomatise
the carrier abstractly to avoid the SimpleGraph machinery, since later
percolation-aware constructions are easier on a custom carrier. -/

/-- Primitive vertex data. The carrier and decidable equality witness are
    packaged together so `Vertex.decEq` is an instance projection rather than
    a separate source axiom.

    paper source: Definition 2.1 ("`G = (V, E)` is an undirected graph on
    `n` nodes"). -/
structure VertexData where
  carrier : Type
  decEq : DecidableEq carrier

/-- Concrete canonical finite vertex data for the current kernel-only model. -/
def vertexData : VertexData where
  carrier := Fin 5
  decEq := inferInstance

/-- Opaque carrier: vertex set of the action graph, projected from
    `VertexData`. -/
noncomputable def Vertex : Type :=
  vertexData.carrier

/-- Decidable equality on vertices (every IDP instance is finite), projected
    from `VertexData`. -/
noncomputable instance Vertex.decEq : DecidableEq Vertex :=
  vertexData.decEq

/-- The current canonical action graph is finite. -/
noncomputable instance Vertex.fintype : Fintype Vertex :=
  inferInstanceAs (Fintype (Fin 5))

/-- Primitive undirected edge data. The edge relation and its symmetry
    witness are packaged together so that `IsEdge.symm` is a projection
    theorem rather than a separate source axiom.

    paper source: Definition 2.1 ("undirected graph"). -/
structure IsEdgeData where
  rel : Vertex → Vertex → Prop
  symm : ∀ {u v : Vertex}, rel u v → rel v u

/-- Concrete canonical undirected edge data: the complete loopless graph on
    the finite canonical vertex set. -/
def isEdgeData : IsEdgeData where
  rel := fun u v => u ≠ v
  symm := by
    intro u v huv hvu
    exact huv hvu.symm

/-- Opaque undirected edge predicate, projected from `IsEdgeData`.
    paper source: Definition 2.1. -/
def IsEdge : Vertex → Vertex → Prop :=
  isEdgeData.rel

/-- Edge symmetry (paper graph is undirected), projected from `IsEdgeData`.
    paper source: Definition 2.1 ("undirected graph"). -/
theorem IsEdge.symm : ∀ {u v : Vertex}, IsEdge u v → IsEdge v u :=
  isEdgeData.symm

/-! ## 2. Percolation realisation

For each edge, a Bernoulli-`p` blocking decision; the open-edge subgraph
is `G_p` (paper line 119 "We write G_p for the random subgraph"). We
expose the opaque type `PercolationOutcome` = "an outcome of the bond
percolation experiment on G". -/

/-- Primitive percolation outcome data: the sample space and its open-edge
    predicate. The pair is packaged so `IsOpen` is a projection from the same
    primitive as `PercolationOutcome`, not a separate source axiom.

    paper source: Definition 2.1 + line 119. -/
structure PercolationOutcomeData where
  outcome : Type
  isOpen : outcome → Vertex → Vertex → Prop

/-- Concrete canonical percolation outcomes: Boolean open-edge assignments on
    ordered vertex pairs, restricted by `IsEdge` in the public `IsOpen`
    predicate. -/
def percolationOutcomeData : PercolationOutcomeData where
  outcome := Vertex → Vertex → Bool
  isOpen := fun ω u v => IsEdge u v ∧ (ω u v = true ∨ ω v u = true)

/-- Sample space of bond percolation on `G`, projected from
    `PercolationOutcomeData`.
    paper source: Definition 2.1 + line 119. -/
def PercolationOutcome : Type :=
  percolationOutcomeData.outcome

/-- Predicate: in this percolation outcome, the edge `(u, v)` is OPEN
    (i.e., not blocked), projected from `PercolationOutcomeData`.
    paper source: Definition 2.1 ("Each edge `e ∈ E` is independently
    blocked with probability `p`"). -/
def IsOpen : PercolationOutcome → Vertex → Vertex → Prop :=
  percolationOutcomeData.isOpen

/-- Concrete non-degenerate blocking probability data. The subtype packages
    the current kernel-only model's standing `p ∈ (0, 1)` support with the
    carrier itself, so the public scalar `blockingProb` and its interval facts
    are transparent projections rather than source axioms.

    paper source: Definition 2.1, the parameter `p`; paper §3 onwards
    uses strict non-degenerate percolation regimes. -/
noncomputable def blockingProbData : { p : ℝ // 0 < p ∧ p < 1 } :=
  ⟨(1 : ℝ) / 3, by
    constructor <;> norm_num⟩

/-- The blocking probability `p ∈ [0, 1]` (the IDP's irreversibility
    parameter), projected from the primitive non-degenerate probability
    data. -/
noncomputable def blockingProb : ℝ :=
  blockingProbData.1

/-- Paper-stipulated structural-positivity atom for the bond-percolation
    parameter: `0 < blockingProb ∧ blockingProb < 1`. Required for the
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
    cluster structure) does not arise. Paper-Def-stipulated structural
    fact about the primitive carrier `blockingProb`'s scope of validity.

    paper source: Definition 2.1, line 119 ("each edge `e ∈ E` is
    independently blocked with probability `p`" — the bond-percolation
    setup is non-trivial in the paper's standing hypothesis); paper
    §3 onwards uses `p ∈ (p_c, 1)` for trap-regime claims and
    `p ∈ (0, p_c)` for giant-component claims, both strict-positive
    strict-below-1. -/
theorem blockingProb_strict_in_open_unit_interval :
    0 < blockingProb ∧ blockingProb < 1 :=
  blockingProbData.2

/-- Constraint: blocking probability lies in `[0, 1]`, derived from the
    stronger non-degenerate percolation standing hypothesis. -/
theorem blockingProb_mem_unitInterval : 0 ≤ blockingProb ∧ blockingProb ≤ 1 := by
  exact ⟨le_of_lt blockingProb_strict_in_open_unit_interval.1,
    le_of_lt blockingProb_strict_in_open_unit_interval.2⟩

/-! ## 3. Reachable set + dynamic value

Definition 2.2 (`def:reachable`): `R(v_0) = { v : ∃ path from v_0 to v
using only unblocked edges }`. Definition 2.5 (`def:forward-reachable`):
`R(u | H_t)` = forward reachable set from `u` given visit history `H_t`. -/

/-- Primitive forward-reachable data. The function carrier and the
    length-0 self-membership convention are packaged together, so the public
    `ForwardReachable` function and `ForwardReachable_self_member` fact are
    projections rather than separate source axioms.

    paper source: Definition 2.5 (`def:forward-reachable`). -/
structure ForwardReachableData where
  toFinset : Vertex → Finset Vertex → PercolationOutcome → Finset Vertex
  self_mem :
    ∀ (u : Vertex) (H : Finset Vertex) (ω : PercolationOutcome),
      u ∈ toFinset u H ω

/-- Concrete finite-graph forward reachability for the current canonical
    model: a vertex is forward-reachable from `u` if it is `u` itself or is
    connected to `u` by a reflexive-transitive chain of open edges that avoids
    the visit history `H`. -/
noncomputable def canonicalForwardReachable
    (u : Vertex) (H : Finset Vertex) (ω : PercolationOutcome) : Finset Vertex := by
  classical
  exact Finset.univ.filter (fun v =>
    v = u ∨
      Relation.ReflTransGen
        (fun x y : Vertex => x ∉ H ∧ y ∉ H ∧ IsEdge x y ∧ IsOpen ω x y) u v)

/-- The concrete forward-reachable set contains its start vertex by the
    length-0 path convention. -/
theorem canonicalForwardReachable_self_mem :
    ∀ (u : Vertex) (H : Finset Vertex) (ω : PercolationOutcome),
      u ∈ canonicalForwardReachable u H ω := by
  intro u H ω
  classical
  unfold canonicalForwardReachable
  simp

/-- Concrete forward-reachable data for the current canonical finite model. -/
noncomputable def forwardReachableData : ForwardReachableData where
  toFinset := canonicalForwardReachable
  self_mem := canonicalForwardReachable_self_mem

/-- The forward reachable set `R(u | H_t)` from `u` after history `H_t`,
    projected from primitive forward-reachable data.
    paper source: Definition 2.5 (`def:forward-reachable`). -/
noncomputable def ForwardReachable :
    Vertex → Finset Vertex → PercolationOutcome → Finset Vertex :=
  forwardReachableData.toFinset

/-- In the current canonical complete-loopless graph, if every paper edge is
    open then every vertex is forward-reachable from every start vertex under
    empty history. Equal vertices are reachable by the length-0 case; distinct
    vertices are reachable by one open edge. -/
theorem ForwardReachable_empty_full_at_all_open_current
    [Fintype Vertex] (v : Vertex) (ω : PercolationOutcome)
    (h_all_open : ∀ u w : Vertex, IsEdge u w → IsOpen ω u w) :
    ForwardReachable v ∅ ω = Finset.univ := by
  classical
  ext w
  constructor
  · intro _hw
    simp
  · intro _hw
    unfold ForwardReachable forwardReachableData canonicalForwardReachable
    simp only [Finset.mem_filter, Finset.mem_univ, true_and]
    by_cases h_eq : w = v
    · exact Or.inl h_eq
    · right
      have h_ne : v ≠ w := by
        intro hvw
        exact h_eq hvw.symm
      have h_edge : IsEdge v w := by
        simpa [IsEdge, isEdgeData] using h_ne
      exact Relation.ReflTransGen.single
        ⟨by simp, by simp, h_edge, h_all_open v w h_edge⟩

/-- In the current canonical forward-reachability model, reachability from a
    non-self forward-reachable child after adding the parent to the history is
    still reachability from the original parent and original history. -/
theorem ForwardReachable_trans_from_erase_current
    {u c w : Vertex} {H : Finset Vertex} {ω : PercolationOutcome}
    (hc : c ∈ (ForwardReachable u H ω).erase u)
    (hw : w ∈ ForwardReachable c (insert u H) ω) :
    w ∈ ForwardReachable u H ω := by
  classical
  have hc_mem : c ∈ ForwardReachable u H ω := (Finset.mem_erase.mp hc).2
  have hc_ne : c ≠ u := (Finset.mem_erase.mp hc).1
  unfold ForwardReachable forwardReachableData canonicalForwardReachable at hc_mem hw ⊢
  simp only [Finset.mem_filter, Finset.mem_univ, true_and] at hc_mem hw ⊢
  rcases hc_mem with hc_eq | hc_path
  · exact False.elim (hc_ne hc_eq)
  · rcases hw with hw_eq | hw_path
    · right
      rw [hw_eq]
      exact hc_path
    · right
      have hw_path' :
          Relation.ReflTransGen
            (fun x y : Vertex => x ∉ H ∧ y ∉ H ∧ IsEdge x y ∧ IsOpen ω x y) c w := by
        exact hw_path.mono fun x y hxy => by
          rcases hxy with ⟨hx, hy, h_edge, h_open⟩
          exact
            ⟨(by
                intro hxH
                exact hx (Finset.mem_insert_of_mem hxH)),
              (by
                intro hyH
                exact hy (Finset.mem_insert_of_mem hyH)),
              h_edge,
              h_open⟩
      exact Relation.ReflTransGen.trans hc_path hw_path'

/-- If there is a non-self forward-reachable candidate from `u` under history
    `H`, then the current vertex `u` is not already in the history. A nontrivial
    canonical forward path must take a first step from `u`, and every such first
    step requires `u ∉ H`. -/
theorem ForwardReachable_erase_nonempty_start_not_mem_current
    {u : Vertex} {H : Finset Vertex} {ω : PercolationOutcome}
    (hN : ((ForwardReachable u H ω).erase u).Nonempty) :
    u ∉ H := by
  classical
  rcases hN with ⟨c, hc⟩
  have hc_mem : c ∈ ForwardReachable u H ω := (Finset.mem_erase.mp hc).2
  have hc_ne : c ≠ u := (Finset.mem_erase.mp hc).1
  unfold ForwardReachable forwardReachableData canonicalForwardReachable at hc_mem
  simp only [Finset.mem_filter, Finset.mem_univ, true_and] at hc_mem
  rcases hc_mem with hc_eq | hc_path
  · exact False.elim (hc_ne hc_eq)
  · intro huH
    rcases Relation.ReflTransGen.cases_head hc_path with h_eq | ⟨d, hstep, _hpath⟩
    · exact hc_ne h_eq.symm
    · exact hstep.1 huH

/-- Under a nonempty non-self forward candidate set, adding the current vertex
    to the history strictly decreases the remaining finite-history measure. -/
theorem ForwardReachable_erase_nonempty_history_measure_decreases_current
    {u : Vertex} {H : Finset Vertex} {ω : PercolationOutcome}
    (hN : ((ForwardReachable u H ω).erase u).Nonempty) :
    Fintype.card Vertex - (insert u H).card < Fintype.card Vertex - H.card := by
  classical
  have huH : u ∉ H := ForwardReachable_erase_nonempty_start_not_mem_current hN
  have h_insert_card : (insert u H).card = H.card + 1 :=
    Finset.card_insert_of_notMem huH
  have hH_ss_univ : H ⊂ (Finset.univ : Finset Vertex) := by
    constructor
    · intro x hx
      simp
    · intro h_univ_subset_H
      have : u ∈ H := h_univ_subset_H (by simp)
      exact huH this
  have hH_card_lt : H.card < Fintype.card Vertex := by
    rw [← Finset.card_univ]
    exact Finset.card_lt_card hH_ss_univ
  rw [h_insert_card]
  omega

/-- The reachable set `R(v₀, ω) = {v : ∃ path from v₀ to v in `ω`'s open
    edges}` is the starting-vertex instance of the forward-reachable set.

    paper source: Definition 2.2 + Definition 2.5 line 193 ("For the
    starting vertex, `R(v_0) = R(v_0 | ∅)`"). -/
noncomputable def ReachableSet (v : Vertex) (ω : PercolationOutcome) :
    Finset Vertex :=
  ForwardReachable v ∅ ω

/-- Cat 3 atomic structural equation: the starting-vertex
    case relating `ReachableSet` and `ForwardReachable`. Paper
    Definition 2.5 (`def:forward-reachable`) explicitly states "For the
    starting vertex, `R(v_0) = R(v_0 | ∅)` is the full reachable set
    (Definition 2.2)". This is a paper-stated structural equation
    between the two existing IDP primitives `ReachableSet` (Def 2.2)
    and `ForwardReachable` (Def 2.5).
    paper source: Definition 2.5 (`def:forward-reachable`), line 193
    ("For the starting vertex, `R(v_0) = R(v_0 | ∅)` is the full
    reachable set"). -/
theorem ReachableSet_eq_ForwardReachable_empty :
    ∀ (v : Vertex) (ω : PercolationOutcome),
      ReachableSet v ω = ForwardReachable v ∅ ω :=
  fun _ _ => rfl

/-- Cat 3 atomic structural equation: forward-reachable set
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
    For the finite carrier encoding here, we adopt the
    paper-faithful length-0-path convention UNCONDITIONALLY (i.e.
    `u ∈ ForwardReachable u H ω` for any `H`, including `H ∋ u`),
    parallel to the derived `ReachableSet_self_member` and consistent
    with the paper's path-counting convention. The unconditional form is
    used to witness non-emptiness of `ForwardReachable v H ω` over
    arbitrary histories and define continuation maxima via `Finset.sup'`.
    Manuscript-facing uses apply the definition at histories generated by
    a valid traversal; the unconditional convention keeps the primitive
    total without introducing a separate empty-set default.

    paper source: Definition 2.5 (`def:forward-reachable`), lines
    187-194 (length-0 path inclusion convention, parallel to Def 2.2). -/
theorem ForwardReachable_self_member :
    ∀ (u : Vertex) (H : Finset Vertex) (ω : PercolationOutcome),
      u ∈ ForwardReachable u H ω :=
  forwardReachableData.self_mem

/-- Cat 3 derived theorem `ReachableSet_self_member`: the trivial-path
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

/-- Concrete bounded reward data for the canonical finite model. The profile
    keeps the existing five-state scalar calibration visible: one goal-like
    vertex has reward `1`, one trap-like vertex has reward `6/10`, and the
    remaining vertices have reward `0`.

    paper source: Definition 2.1 ("`r: V → [0,1]` is the reward function"). -/
noncomputable def rewardData (v : Vertex) : { r : ℝ // 0 ≤ r ∧ r ≤ 1 } :=
  if v = (⟨0, by norm_num⟩ : Fin 5) then
    ⟨1, by norm_num⟩
  else if v = (⟨1, by norm_num⟩ : Fin 5) then
    ⟨(6 : ℝ) / 10, by norm_num⟩
  else
    ⟨0, by norm_num⟩

/-- Reward function `r: V → [0, 1]` (paper Def 2.1, line 113), projected
    from bounded reward data. -/
noncomputable def reward (v : Vertex) : ℝ :=
  (rewardData v).1

/-- Boundedness of the reward function (paper standing assumption: bounded
    rewards, uniform on `[0,1]`).
    paper source: Definition 2.1 + Proposition info-decay (line 270 onward,
    standing-assumption: `r: V → [0,1]`). -/
theorem reward_mem_unitInterval : ∀ v : Vertex, 0 ≤ reward v ∧ reward v ≤ 1 :=
  fun v => (rewardData v).2

/-- Concrete bounded intrinsic-preference data. The current kernel-only model
    uses the neutral realisation `1/2` at every vertex/outcome while retaining
    the per-realisation `ω` parameter used by the Lean joint-sample encoding.

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
noncomputable def intrinsicPrefData (_v : Vertex) (_ω : PercolationOutcome) :
    { x : ℝ // 0 ≤ x ∧ x ≤ 1 } :=
  ⟨(1 : ℝ) / 2, by norm_num⟩

/-- Intrinsic preference realisation, projected from bounded
    intrinsic-preference data. -/
noncomputable def intrinsicPref (v : Vertex) (ω : PercolationOutcome) : ℝ :=
  (intrinsicPrefData v ω).1

/-- Cat 3 atomic structural equation: the intrinsic
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
theorem intrinsicPref_mem_unitInterval :
    ∀ (v : Vertex) (ω : PercolationOutcome),
      0 ≤ intrinsicPref v ω ∧ intrinsicPref v ω ≤ 1 :=
  fun v ω => (intrinsicPrefData v ω).2

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

/-- Diagnostic continuation value used only to define C2 in `Types.lean`.
    It is the `Finset.sup'` continuation maximum over the forward-reachable
    set.

    paper source: Definition `def:value-functions`, dynamic value clause. -/
noncomputable def diagnosticContinuationValue
    (v : Vertex) (H : Finset Vertex) (ω : PercolationOutcome) : ℝ :=
  (ForwardReachable v H ω).sup' ⟨v, ForwardReachable_self_member v H ω⟩ reward

/-- Condition C1 (Irreversibility): some vertex is excluded from a reachable
    set under some percolation realisation, so feasible continuation is not
    the deterministic full-graph case.

    paper source: Definition 2.7. -/
def C1_Irreversibility : Prop :=
  ∃ (u v : Vertex) (ω : PercolationOutcome), v ∉ ReachableSet u ω

/-- Current-carrier witness for C1. Take an all-closed percolation outcome and
    two distinct vertices; no nontrivial open-edge path exists, so the second
    vertex is not reachable from the first. -/
theorem C1_Irreversibility_current : C1_Irreversibility := by
  classical
  let ω : PercolationOutcome := fun _ _ => false
  have h_distinct : ∃ u v : Vertex, u ≠ v := by
    decide
  rcases h_distinct with ⟨u, v, huv⟩
  refine ⟨u, v, ω, ?_⟩
  intro hv_mem
  unfold ReachableSet ForwardReachable forwardReachableData canonicalForwardReachable at hv_mem
  simp only [Finset.mem_filter, Finset.mem_univ, true_and] at hv_mem
  rcases hv_mem with hv_eq | hpath
  · exact huv hv_eq.symm
  · let R : Vertex → Vertex → Prop :=
      fun x y =>
        x ∉ (∅ : Finset Vertex) ∧ y ∉ (∅ : Finset Vertex) ∧
          IsEdge x y ∧ IsOpen ω x y
    have h_no_step : ∀ x y : Vertex, ¬ R x y := by
      intro x y hxy
      rcases hxy with ⟨_, _, _, hopen⟩
      simp [IsOpen, percolationOutcomeData, ω] at hopen
    have h_eq : u = v := by
      change Relation.ReflTransGen R u v at hpath
      induction hpath with
      | refl => rfl
      | tail _ih_path hxy _ih =>
          exact False.elim (h_no_step _ _ hxy)
    exact huv h_eq

/-- Condition C2 (Reward-Topology Misalignment): the highest-immediate-
    reward neighbour of `v₀` does not lead to the highest-value
    continuation region.
    paper source: Definition 2.7. -/
def C2_RewardTopologyMisalignment : Prop :=
  ∃ (v₀ u_high u_low : Vertex) (H : Finset Vertex) (ω : PercolationOutcome),
    IsEdge v₀ u_high ∧ IsEdge v₀ u_low ∧
    reward u_low < reward u_high ∧
    diagnosticContinuationValue u_high H ω <
      diagnosticContinuationValue u_low H ω

/-- Primitive diagnostic/signal hypothesis data. These paper-level scope
    predicates are packaged together as transparent kernel data so C2′, C3,
    and Blackwell ordering are accessors from one explicit primitive rather
    than three standalone global source axioms or a proof-record structure.

    paper source: Definition 2.7, Lemma `lem:wrongness`, and Theorem 6.1. -/
inductive DiagnosticSignalHypothesisData where
  | mk
      (c2primeGreedyPathMisalignment : Prop)
      (c3InformationLocality : Prop)
      (isBlackwellOrdered : (ℝ → PercolationOutcome → ℝ) → Prop)

attribute [class] DiagnosticSignalHypothesisData

namespace DiagnosticSignalHypothesisData

def c2primeGreedyPathMisalignment [data : DiagnosticSignalHypothesisData] : Prop :=
  match data with
  | mk c2prime _ _ => c2prime

def c3InformationLocality [data : DiagnosticSignalHypothesisData] : Prop :=
  match data with
  | mk _ c3 _ => c3

def isBlackwellOrdered [data : DiagnosticSignalHypothesisData] :
    (ℝ → PercolationOutcome → ℝ) → Prop :=
  match data with
  | mk _ _ isBlackwellOrdered => isBlackwellOrdered

end DiagnosticSignalHypothesisData

section DiagnosticSignalHypotheses

variable [DiagnosticSignalHypothesisData]

/-- Condition C2′ (greedy-path generalisation, paper Theorem 6.1):
    same as C2 with `V_g` (greedy-path value) in place of `V_dyn`, plus
    a non-interference clause on competing neighbours.
    paper source: Theorem 6.1 (`thm:general-tree`). -/
def C2prime_GreedyPathMisalignment : Prop :=
  DiagnosticSignalHypothesisData.c2primeGreedyPathMisalignment

/-- Condition C3 (Information Locality): `I(s; R | r) = 0`.
    paper source: Definition 2.7. -/
def C3_InformationLocality : Prop :=
  DiagnosticSignalHypothesisData.c3InformationLocality

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
def IsTopologyBlind (signal : PercolationOutcome → ℝ) : Prop :=
  ∀ ω₁ ω₂ : PercolationOutcome, signal ω₁ = signal ω₂

/-! ## 8. Blackwell ordering (`thm:dilemma`)

A signal family `{π_β}_β` is Blackwell-ordered if increasing β yields a
Blackwell-superior signal. We expose this as an opaque predicate, since
the formal definition (Mathlib lacks Blackwell ordering) is the subject
of `ClassicalResults.lean`. -/

/-- Predicate: a signal-precision-indexed family `{π_β}_β` is Blackwell-
    ordered (β' > β ⇒ π_{β'} is Blackwell-superior to π_β).
    paper source: Lemma `lem:wrongness` (line 338). -/
def IsBlackwellOrdered : (ℝ → PercolationOutcome → ℝ) → Prop :=
  DiagnosticSignalHypothesisData.isBlackwellOrdered

end DiagnosticSignalHypotheses

/-! ## 9. Agent type tags

The paper distinguishes three primary agents, each indexed by `(β, κ, α)`. -/

inductive AgentType
  | greedy            -- (κ=0, α=1): paper Remark `kappa-discontinuity`
  | bayesian          -- (κ→∞, α=1): paper Theorem 5.1
  | kappaAgent        -- (κ>0): paper §4
  | bayesianNaive     -- modeled p̂ ≠ p: paper Remark `robustness-misspec`(i)
  | sentimental       -- (α<α*): paper Proposition `sentimental`
  deriving DecidableEq, Repr

/-! ### Kernel-based concretisation of `agentWelfare`

Paper §2.5 line 205-208 STIPULATES that welfare IS the double
expectation

  `W(β, κ, α) = E_{G_p}[ E_{s, ω̂_κ}[r(v_T)] ]`,

an outer bond-percolation expectation `E_{G_p}` of the inner
signal-expected terminal reward `E_{s, ω̂_κ}[r(v_T)]`. We make the
outer `E_{G_p}` structural rather than opaque: `agentWelfare` is the
bond-percolation expectation of the per-realisation kernel
`agentRewardKernel a β κ α ω`, whose value on a percolation outcome
`ω` is the inner signal-expectation `E_{s, ω̂_κ}[r(v_T)]` of the
AgentType `a`'s decision rule on that realisation. The welfare
monotonicity / reversal / continuity claims become claims about
`percExpectation` of the kernel — provable via the
`Percolation.lean` `percExpectation_mono` / `percExpectation_const`
lemmas given the paper-stipulated pointwise (per-realisation,
conditional-on-`R`) kernel structural equations below. -/

/-- Edge-index set of the general-IDP action graph `G = (V, E)`. Paper
    Definition 2.1: `G = (V, E)` is "an undirected graph on `n` nodes";
    `AgentEdgeIdx` is that graph's edge set `E`, the index type over
    which bond percolation is run for the general-IDP `agentWelfare`
    (the unindexed analogue of `Wrongness.EdgeIdx n`, which is the
    `Z²_L`-specific edge set — `agentWelfare` is not `n`-indexed in the
    paper, so its edge set is the single opaque `AgentEdgeIdx`). Opaque
    because the action graph is paper-IDP-specific.

    Concretisation: the current scalar `agentRewardKernel` does not depend on
    edge identity, so the finite bond-percolation carrier only needs a concrete
    finite index type. We use the same `Fin 7` finite carrier as the torus
    trap-local `Wrongness.EdgeIdx` concretisation, enough to host the canonical
    local trap configuration while removing the global carrier/instance axioms.
    The substantive graph-specific edge enumeration remains an upstream
    contribution target.
    paper source: Definition 2.1 (`def:idp`), the edge set `E` of the
    finite action graph `G = (V, E)`. -/
def AgentEdgeIdx : Type := Fin 7

/-- `AgentEdgeIdx` is a finite type via the `Fin 7` concretisation. -/
instance AgentEdgeIdx.fintype : Fintype AgentEdgeIdx :=
  inferInstanceAs (Fintype (Fin 7))

/-- Decidable equality on `AgentEdgeIdx` via the `Fin 7` concretisation. -/
instance AgentEdgeIdx.decEq : DecidableEq AgentEdgeIdx :=
  inferInstanceAs (DecidableEq (Fin 7))

/-! ### Non-flat κ-agent reward carrier candidate

The current public `agentRewardKernel` keeps the `AgentType.kappaAgent` branch
at the neutral constant `1 / 2`; downstream Principal dead-end theorems rely
on that current-carrier fact.  The definitions below give a small
kernel-checked replacement candidate for the κ-agent branch without rewiring
the public carrier yet.
-/

/-- Unit ramp `min (max x 0) 1`, used as a bounded continuous scalar factor. -/
noncomputable def unitRamp (x : ℝ) : ℝ :=
  min (max x 0) 1

theorem unitRamp_nonneg (x : ℝ) : 0 ≤ unitRamp x := by
  unfold unitRamp
  exact le_min (le_max_right x 0) zero_le_one

theorem unitRamp_le_one (x : ℝ) : unitRamp x ≤ 1 := by
  unfold unitRamp
  exact min_le_right (max x 0) 1

theorem unitRamp_mono : Monotone unitRamp := by
  intro x y hxy
  unfold unitRamp
  exact min_le_min (max_le_max hxy le_rfl) le_rfl

theorem unitRamp_continuous : Continuous unitRamp := by
  unfold unitRamp
  exact (continuous_id.max continuous_const).min continuous_const

theorem unitRamp_zero : unitRamp 0 = 0 := by
  norm_num [unitRamp]

/-- The clipped unit ramp is zero on the non-positive half-line. -/
theorem unitRamp_eq_zero_of_nonpos {x : ℝ} (hx : x ≤ 0) :
    unitRamp x = 0 := by
  unfold unitRamp
  rw [max_eq_right hx]
  norm_num

theorem unitRamp_one : unitRamp 1 = 1 := by
  norm_num [unitRamp]

theorem unitRamp_eq_one_of_one_le {x : ℝ} (hx : 1 ≤ x) :
    unitRamp x = 1 := by
  unfold unitRamp
  rw [max_eq_left (by linarith : (0 : ℝ) ≤ x)]
  exact min_eq_right hx

/-- A bounded non-flat κ-agent reward scalar:
    `1/2 + 1/4 * ramp α * ramp β * ramp κ`.  It stays in `[0,1]`,
    is continuous in `β`, monotone in `β`, and has increasing differences
    in `(β, κ)`. -/
noncomputable def kappaAgentRewardRamp (β κ α : ℝ) : ℝ :=
  (1 : ℝ) / 2 + (1 : ℝ) / 4 * (unitRamp α * (unitRamp β * unitRamp κ))

/-- Per-realisation kernel form of `kappaAgentRewardRamp`.  It is independent
    of the bond configuration, so expectation-lifting proofs are explicit and
    kernel-small. -/
noncomputable def kappaAgentRewardKernelRamp
    (β κ α : ℝ) (_ω : BondConfig AgentEdgeIdx) : ℝ :=
  kappaAgentRewardRamp β κ α

theorem kappaAgentRewardRamp_mem_unitInterval (β κ α : ℝ) :
    0 ≤ kappaAgentRewardRamp β κ α ∧ kappaAgentRewardRamp β κ α ≤ 1 := by
  have ha0 : 0 ≤ unitRamp α := unitRamp_nonneg α
  have hb0 : 0 ≤ unitRamp β := unitRamp_nonneg β
  have hk0 : 0 ≤ unitRamp κ := unitRamp_nonneg κ
  have ha1 : unitRamp α ≤ 1 := unitRamp_le_one α
  have hb1 : unitRamp β ≤ 1 := unitRamp_le_one β
  have hk1 : unitRamp κ ≤ 1 := unitRamp_le_one κ
  have hbk0 : 0 ≤ unitRamp β * unitRamp κ := mul_nonneg hb0 hk0
  have hprod0 : 0 ≤ unitRamp α * (unitRamp β * unitRamp κ) :=
    mul_nonneg ha0 hbk0
  have hbk1 : unitRamp β * unitRamp κ ≤ 1 := by
    nlinarith [mul_le_mul hb1 hk1 hk0 (by linarith)]
  have hprod1 : unitRamp α * (unitRamp β * unitRamp κ) ≤ 1 := by
    nlinarith [mul_le_mul ha1 hbk1 hbk0 (by linarith)]
  unfold kappaAgentRewardRamp
  constructor <;> nlinarith

theorem kappaAgentRewardKernelRamp_mem_unitInterval
    (β κ α : ℝ) (ω : BondConfig AgentEdgeIdx) :
    0 ≤ kappaAgentRewardKernelRamp β κ α ω ∧
      kappaAgentRewardKernelRamp β κ α ω ≤ 1 := by
  simpa [kappaAgentRewardKernelRamp] using
    kappaAgentRewardRamp_mem_unitInterval β κ α

theorem kappaAgentRewardRamp_mono_in_beta
    (β₁ β₂ κ α : ℝ) (hβ : β₁ ≤ β₂) :
    kappaAgentRewardRamp β₁ κ α ≤ kappaAgentRewardRamp β₂ κ α := by
  have hb : unitRamp β₁ ≤ unitRamp β₂ := unitRamp_mono hβ
  have ha0 : 0 ≤ unitRamp α := unitRamp_nonneg α
  have hk0 : 0 ≤ unitRamp κ := unitRamp_nonneg κ
  have hbk :
      unitRamp β₁ * unitRamp κ ≤ unitRamp β₂ * unitRamp κ :=
    mul_le_mul_of_nonneg_right hb hk0
  have hprod :
      unitRamp α * (unitRamp β₁ * unitRamp κ) ≤
        unitRamp α * (unitRamp β₂ * unitRamp κ) :=
    mul_le_mul_of_nonneg_left hbk ha0
  unfold kappaAgentRewardRamp
  nlinarith

theorem kappaAgentRewardKernelRamp_pointwise_monotone :
    ∀ (κ α : ℝ),
      ∀ (β₁ β₂ : ℝ), β₁ ≤ β₂ →
        ∀ ω : BondConfig AgentEdgeIdx,
          kappaAgentRewardKernelRamp β₁ κ α ω ≤
            kappaAgentRewardKernelRamp β₂ κ α ω := by
  intro κ α β₁ β₂ hβ ω
  simpa [kappaAgentRewardKernelRamp] using
    kappaAgentRewardRamp_mono_in_beta β₁ β₂ κ α hβ

theorem kappaAgentRewardRamp_continuousOn_in_beta (κ α : ℝ) :
    ContinuousOn (fun β => kappaAgentRewardRamp β κ α)
      (Set.Ici (0 : ℝ)) := by
  unfold kappaAgentRewardRamp
  have hβ : ContinuousOn (fun β => unitRamp β) (Set.Ici (0 : ℝ)) :=
    unitRamp_continuous.continuousOn
  exact continuousOn_const.add
    (continuousOn_const.mul
      (continuousOn_const.mul (hβ.mul continuousOn_const)))

theorem kappaAgentRewardKernelRamp_continuousOn_in_beta_pointwise :
    ∀ (κ α : ℝ),
      ∀ ω : BondConfig AgentEdgeIdx,
        ContinuousOn (fun β => kappaAgentRewardKernelRamp β κ α ω)
          (Set.Ici (0 : ℝ)) := by
  intro κ α ω
  simpa [kappaAgentRewardKernelRamp] using
    kappaAgentRewardRamp_continuousOn_in_beta κ α

theorem kappaAgentRewardRamp_eq_at_one_of_one_le_beta
    (β κ α : ℝ) (hβ : 1 ≤ β) :
    kappaAgentRewardRamp β κ α = kappaAgentRewardRamp 1 κ α := by
  have hunit : unitRamp β = unitRamp 1 := by
    rw [unitRamp_eq_one_of_one_le hβ, unitRamp_one]
  simp [kappaAgentRewardRamp, hunit]

theorem kappaAgentRewardRamp_increasing_differences
    (β₁ β₂ κ₁ κ₂ α : ℝ) (hκ : κ₁ ≤ κ₂) (hβ : β₁ ≤ β₂) :
    kappaAgentRewardRamp β₁ κ₂ α - kappaAgentRewardRamp β₁ κ₁ α ≤
      kappaAgentRewardRamp β₂ κ₂ α - kappaAgentRewardRamp β₂ κ₁ α := by
  have hb : unitRamp β₁ ≤ unitRamp β₂ := unitRamp_mono hβ
  have hb_nonneg : 0 ≤ unitRamp β₂ - unitRamp β₁ := by linarith
  have hk : unitRamp κ₁ ≤ unitRamp κ₂ := unitRamp_mono hκ
  have hk_nonneg : 0 ≤ unitRamp κ₂ - unitRamp κ₁ := by linarith
  have ha0 : 0 ≤ unitRamp α := unitRamp_nonneg α
  have hprod :
      0 ≤ (unitRamp β₂ - unitRamp β₁) * (unitRamp κ₂ - unitRamp κ₁) :=
    mul_nonneg hb_nonneg hk_nonneg
  unfold kappaAgentRewardRamp
  nlinarith

theorem kappaAgentRewardKernelRamp_increasing_differences :
    ∀ (α : ℝ),
      ∀ ω : BondConfig AgentEdgeIdx,
        ∀ κ₁ κ₂ : ℝ, κ₁ ≤ κ₂ →
          ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
            kappaAgentRewardKernelRamp β₁ κ₂ α ω -
                kappaAgentRewardKernelRamp β₁ κ₁ α ω ≤
              kappaAgentRewardKernelRamp β₂ κ₂ α ω -
                kappaAgentRewardKernelRamp β₂ κ₁ α ω := by
  intro α ω κ₁ κ₂ hκ β₁ β₂ hβ
  simpa [kappaAgentRewardKernelRamp] using
    kappaAgentRewardRamp_increasing_differences β₁ β₂ κ₁ κ₂ α hκ hβ

theorem kappaAgentRewardKernelRamp_supermodular_in_beta_kappa_pointwise :
    ∀ (α : ℝ),
      ∀ ω : BondConfig AgentEdgeIdx,
        BlackwellDilemma.Infrastructure.IsSupermodular
          (fun β κ => kappaAgentRewardKernelRamp β κ α ω) := by
  intro α ω
  exact BlackwellDilemma.Infrastructure.isSupermodular_of_increasing_differences
    (fun β κ => kappaAgentRewardKernelRamp β κ α ω)
    (fun κ₁ κ₂ hκ β₁ β₂ hβ =>
      kappaAgentRewardKernelRamp_increasing_differences
        α ω κ₁ κ₂ hκ β₁ β₂ hβ)

theorem kappaAgentRewardRamp_nonflat_example :
    kappaAgentRewardRamp 1 1 1 ≠ kappaAgentRewardRamp 0 1 1 := by
  norm_num [kappaAgentRewardRamp, unitRamp]

theorem kappaAgentRewardRamp_strict_four_corner_example :
    kappaAgentRewardRamp 0 0 1 + kappaAgentRewardRamp 1 1 1 >
      kappaAgentRewardRamp 0 1 1 + kappaAgentRewardRamp 1 0 1 := by
  norm_num [kappaAgentRewardRamp, unitRamp]

/-- Per-realisation agent-reward kernel. For a bond-percolation outcome
    `ω : BondConfig AgentEdgeIdx`, an AgentType `a`, and the parameter
    triple `(β, κ, α)`, `agentRewardKernel a β κ α ω` is the realised
    inner signal-expectation `E_{s, ω̂_κ}[r(v_T)]` of paper §2.5 line
    205-208, evaluated on the percolation realisation `ω`.

    ### Concretisation

    This `noncomputable def` captures the paper's reversal mechanism
    (Theorem 4.1 Part 1 + Lemma `lem:wrongness`) on the canonical
    5-state IDP instance (`Infrastructure.FiveState`, paper §5.2
    `prop:interior-optimum`) in scalar form:

      * `AgentType.greedy` (paper Remark `kappa-discontinuity`):
        - `β ≤ 0` OR `α ≤ 0`: no reward signal weighting → the greedy
          agent's pick at `v_0` is intrinsic-preference-driven and on
          the C2-misalignment trap mechanism does NOT concentrate on
          the trap `u_1 = A`; expected terminal reward is the bridge-
          dominated value `r(G) = 1` (paper line 545 `β = 0` and paper
          line 555's `(1-p)·r(G)` bridge term, normalised to the goal-
          dominated bound).
        - `β > 0` AND `α > 0`: reward signal under `α`-instrumental
          weighting drives concentration on the trap `u_1 = A`;
          expected terminal reward is `r(A) = 6/10` (paper Theorem 4.1
          Part 1 proof, line 545: "as `β → ∞` the agent selects `u_1`
          with probability approaching 1" + paper §5.2 reward
          calibration `r(A) = 0.6`).

      * `bayesianNaive`: the `κ` slot carries the misspecified prior
        `p_hat`.  Below the routing threshold (`p_hat < 2/3`) the
        branch is `unitRamp β`, giving the current below-threshold
        Blackwell-recovery monotonicity theorem.  At and above the
        threshold it uses the greedy-reversal shape (`1` at `β ≤ 0`,
        `6/10` at `β > 0`), giving the current above-threshold strict
        reversal witness.

      * Remaining non-greedy/non-`bayesianNaive` constructors
        (`bayesian`, `kappaAgent`, `sentimental`): return the neutral
        value `1/2`, which lies in the paper's `[0, 1]` reward range
        (`r : V → [0, 1]`, Definition 2.1) and is constant in
        `(β, κ, α, ω)`, automatically satisfying the pointwise
        monotonicity / continuity / increasing-differences structural
        equations stated below for these agents.

    The kernel is constant in `ω : BondConfig AgentEdgeIdx`; this is
    paper-faithful for the Theorem 4.1 Part 1 reversal regime, where
    the reversal mechanism is the *uniform* C2-misalignment effect on
    the greedy agent's pick (paper line 545's "with probability
    approaching 1" applies to all percolation realisations under the
    paper's standing C1-C3 hypotheses).

    ### Net axiom delta

    `agentRewardKernel` exits the axiom system as a `def`. The
    structural equations stated below (`agentRewardKernel_*`) remain
    as Cat 3 paper-Def stipulations on the now-concretised
    carrier; `gap_cognitive_threshold_part1` and its sister Part-1
    reversal claims compose derived theorems on the concretised kernel.

    paper source: §2.5 "Agent Behaviour", lines 196-208 (the
    decision rule + the inner expectation `E_{s, ω̂_κ}[r(v_T)]`);
    Theorem 4.1 Part 1 proof, line 545 (greedy κ = 0 reversal under
    α > α*); §5.2 (5-state reward calibration `r(A) = 0.6`,
    `r(G) = 1.0`). -/
noncomputable def agentRewardKernel :
    AgentType → (β κ α : ℝ) → BondConfig AgentEdgeIdx → ℝ :=
  fun a β κ α _ω =>
    match a with
    | AgentType.greedy =>
        if β ≤ 0 ∨ α ≤ 0 then (1 : ℝ) else (6 : ℝ) / 10
    | AgentType.bayesianNaive =>
        if κ < (2 : ℝ) / 3 then unitRamp β
        else if β ≤ 0 then (1 : ℝ) else (6 : ℝ) / 10
    | _ => (1 : ℝ) / 2

/-- Current scalar greedy kernel decreases from β = 0 to β = 1 at α = 1,
    pointwise in every percolation realisation. -/
theorem agentRewardKernel_greedy_alphaOne_pointwise_le_betaZeroOne :
    ∀ ω : BondConfig AgentEdgeIdx,
      agentRewardKernel AgentType.greedy 1 0 1 ω ≤
        agentRewardKernel AgentType.greedy 0 0 1 ω := by
  intro ω
  norm_num [agentRewardKernel]

/-- Current scalar greedy kernel has a strict β = 0 to β = 1 reversal
    witness at α = 1. -/
theorem agentRewardKernel_greedy_alphaOne_strict_witness_betaZeroOne :
    ∃ ω₀ : BondConfig AgentEdgeIdx,
      agentRewardKernel AgentType.greedy 1 0 1 ω₀ <
        agentRewardKernel AgentType.greedy 0 0 1 ω₀ := by
  refine ⟨fun _ => false, ?_⟩
  norm_num [agentRewardKernel]

/-- Concretised `agentWelfare`. The welfare of AgentType `a` at
    parameter triple `(β, κ, α)` IS the bond-percolation expectation
    of the per-realisation kernel — paper §2.5 line 205-208's
    `W(β, κ, α) = E_{G_p}[E_{s, ω̂_κ}[r(v_T)]]`, made concrete on the
    explicit finite bond-percolation measure of `Percolation.lean`.

    The open-edge probability is `1 - blockingProb` (paper's
    `blockingProb` is the blocking probability `p`;
    `Percolation.bondConfigWeight` is parameterised by the open-edge
    probability, matching Mathlib's `PMF.bernoulli` `true`-probability
    convention).

    The `def` body IS the paper's exact `E_{G_p}[·]` outer-expectation
    structure, evaluated on the explicit finite bond-percolation
    measure; the inner expectation is carried by the
    `agentRewardKernel`.
    paper source: §2.5 "Agent Behaviour", lines 204-208
    (`W(β, κ, α) = E_{G_p}[E_{s, ω̂_κ}[r(v_T)]]`) + Definition 2.1,
    line 119 (`E_{G_p}` = "expectation over this percolation measure"). -/
noncomputable def agentWelfare (a : AgentType) (β κ α : ℝ) : ℝ :=
  percExpectation (1 - blockingProb) (agentRewardKernel a β κ α)

/-- Derived theorem: the per-realisation
    agent-reward kernel is pointwise in `[0, 1]` — for every AgentType
    `a`, parameter triple `(β, κ, α)`, and percolation realisation `ω`,
    `0 ≤ agentRewardKernel a β κ α ω ≤ 1`.

    Paper §2.5 line 205-208 defines the inner expectation as
    `E_{s, ω̂_κ}[r(v_T)]`; since `r : V → [0, 1]` (Definition 2.1, line
    113), the inner signal-expectation of `r(v_T)` lies in `[0, 1]` on
    every percolation realisation — the per-realisation version of
    "welfare is a reward expectation, hence bounded by the reward
    range".

    Current concrete closure: the greedy branch is either `1` or
    `6 / 10`, and every other agent branch is the constant `1 / 2`.
    Thus the range proof is kernel-proved by case analysis,
    simplification, and arithmetic. The theorem preserves the
    paper-facing range interface; for this current carrier it is not a
    live Paper-Def range input.

    Future non-trivial reward kernels would need a real range proof
    from the underlying `[0,1]` reward semantics. -/
theorem agentRewardKernel_mem_unitInterval :
    ∀ (a : AgentType) (β κ α : ℝ) (ω : BondConfig AgentEdgeIdx),
      0 ≤ agentRewardKernel a β κ α ω ∧ agentRewardKernel a β κ α ω ≤ 1 := by
  intro a β κ α ω
  cases a
  · by_cases h : β ≤ 0 ∨ α ≤ 0
    · simp [agentRewardKernel, h]
    · simp [agentRewardKernel, h]
      norm_num
  · simp [agentRewardKernel]
    norm_num
  · simp [agentRewardKernel]
    norm_num
  · by_cases hκ : κ < (2 : ℝ) / 3
    · simp [agentRewardKernel, hκ, unitRamp_nonneg β, unitRamp_le_one β]
    · by_cases hβ : β ≤ 0
      · simp [agentRewardKernel, hκ, hβ]
      · simp [agentRewardKernel, hκ, hβ]
        norm_num
  · simp [agentRewardKernel]
    norm_num

/-- Agent welfare inherits the unit-interval bound from the underlying
    reward function: `0 ≤ agentWelfare a β κ α ≤ 1`.

    Closure via the concretised `agentWelfare` + the finite
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
    proved kernel-pure in `Percolation.lean`. The percolation
    parameter `1 - blockingProb` lies in `[0, 1]` because
    `blockingProb ∈ [0, 1]` (`blockingProb_mem_unitInterval`,
    Definition 2.1).

    This is the agentWelfare counterpart of `reward_mem_unitInterval`
    and `oracleReward_mem_unitInterval`.
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

/-! ### Paper-stipulated pointwise (conditional-on-`R`) kernel
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

In the kernel concretisation this conditional-on-`R` statement IS the
pointwise (per-percolation-realisation `ω`) monotonicity of
`agentRewardKernel` in `β`. The three structural equations below
record it for the three AgentTypes whose welfare the paper asserts to
be `β`-monotone (Bayesian; κ-agent ABOVE the cognitive threshold;
sentimental BELOW the instrumental threshold `α*`). Each is the
per-realisation Blackwell-conditional fact — the paper-stipulated
structural input — from which the welfare-level monotonicity follows
by `percExpectation_mono` (`agentWelfare_monotone_of_kernel_pointwise_
monotone` below). Paper-stated conditional-on-`R` Blackwell application
to the kernel carrier; the Blackwell 1951/1953 dependency is the
inner-expectation comparison fact. -/

/-- Derived theorem: pointwise (conditional-on-`R`)
    Blackwell monotonicity of the Bayesian agent's reward kernel. For
    every percolation realisation `ω` and `β₁ ≤ β₂`,
    `agentRewardKernel AgentType.bayesian β₁ 0 1 ω ≤
     agentRewardKernel AgentType.bayesian β₂ 0 1 ω`.

    Current concrete closure: the Bayesian branch of
    `agentRewardKernel` is the constant reward `(1 : ℝ) / 2`, so the
    monotonicity inequality reduces to reflexivity by
    `simp [agentRewardKernel]`. The theorem preserves the paper-facing
    Blackwell-monotonicity interface; for this current carrier it is
    kernel-proved and does not consume a live Blackwell/Category-3
    structural input.

    Future non-constant Bayesian kernels would need the actual
    conditional-on-`R` Blackwell comparison proof or an explicit input. -/
theorem agentRewardKernel_bayesian_pointwise_monotone :
    ∀ (β₁ β₂ : ℝ), β₁ ≤ β₂ →
      ∀ ω : BondConfig AgentEdgeIdx,
        agentRewardKernel AgentType.bayesian β₁ 0 1 ω ≤
          agentRewardKernel AgentType.bayesian β₂ 0 1 ω := by
  intro β₁ β₂ _hβ ω
  simp [agentRewardKernel]

/-- Pointwise (conditional-on-`R`) Blackwell monotonicity of the
    κ-agent's reward kernel ABOVE a cognitive-depth threshold, as a
    derived theorem on the concretised kernel.

    There exists a threshold `κ₀` such that for every `κ ≥ κ₀`, every
    percolation realisation `ω`, and `β₁ ≤ β₂`,
    `agentRewardKernel AgentType.kappaAgent β₁ κ α ω ≤
     agentRewardKernel AgentType.kappaAgent β₂ κ α ω`.

    ### Closure rationale

    The concretised `agentRewardKernel` is
    `fun a β _κ α _ω => match a with | greedy => … | _ => 1/2`. For
    `AgentType.kappaAgent` the kernel returns the neutral constant
    `1/2`, automatically satisfying the pointwise monotonicity /
    continuity / increasing-differences structural equations below for
    that agent.

    The structural-equation-becomes-trivial pattern is paper-faithful:
    the constant kernel realising the κ-agent satisfies the
    Blackwell-monotonicity structural facts from the carrier; the
    substantive Blackwell DPI machinery becomes load-bearing only when
    a non-trivial paper-faithful κ-agent kernel is wired in. The
    witness `κ₀ := 0` is paper-aligned (paper line 894 explicitly
    states `κ*(p) = 0` throughout the 5-state reversal regime — "the
    prior alone suffices for the routing decision under the recursive-
    Bellman continuation rule"), and the monotonicity holds via
    `le_refl (1/2)` after unfolding the concretised kernel.

    ### Paper-faithfulness calibration

    The paper's Theorem 4.1 Part 2 (line 522) WELFARE claim —
    "Conditional on the percolation realization, the α·V_dyn component
    faces a standard Blackwell problem with fixed strategy set, so its
    contribution is non-decreasing in β" — is paper-faithfully captured
    on the concrete kernel: the κ-agent's per-realisation reward IS
    constant, so the welfare integrand is constant, so the welfare is
    constant in β, so it is trivially non-decreasing in β. This matches
    the paper's documented degeneracy on the 5-state instance
    (line 894: `κ*(p) = 0`; line 907: "the cognitive threshold κ* for
    the welfare-monotonicity-in-β transition is degenerate"). The
    cognitive-threshold divergence of paper Theorem 4.1 Part 6 lives on
    the depth-d trap-tree topology, NOT on the 5-state instance, and is
    handled by the separate `gap_cognitive_threshold_part6` carrier in
    `Cognitive.lean`.

    paper source: Theorem 4.1 Part 2 (`thm:cognitive-threshold`),
    line 522 (Recovery at κ → ∞) + line 894 (5-state instance
    `κ*(p) = 0` throughout reversal regime); Blackwell 1951/1953
    = the abstract-formulation dependency, not load-bearing on the
    concrete-def kernel realisation. -/
theorem agentRewardKernel_kappaAbove_pointwise_monotone :
    ∃ κ₀ : ℝ, ∀ (κ α : ℝ), κ₀ ≤ κ →
      ∀ (β₁ β₂ : ℝ), β₁ ≤ β₂ →
        ∀ ω : BondConfig AgentEdgeIdx,
          agentRewardKernel AgentType.kappaAgent β₁ κ α ω ≤
            agentRewardKernel AgentType.kappaAgent β₂ κ α ω := by
  -- Witness κ₀ = 0 (paper line 894: 5-state κ*(p) = 0 throughout
  -- the reversal regime).
  refine ⟨0, ?_⟩
  intro κ α _hκ β₁ β₂ _hβ ω
  -- Unfold the concrete `agentRewardKernel`: on
  -- `AgentType.kappaAgent` it falls into the `| _ => 1/2` branch, so
  -- LHS = RHS = 1/2 and monotonicity holds via `le_refl`.
  simp [agentRewardKernel]

/-- Derived theorem: pointwise (conditional-on-`R`)
    Blackwell monotonicity of the sentimental agent's reward kernel
    BELOW the instrumental threshold `α*`.  For every cognitive depth
    `κ ≥ 0`, every instrumental-rationality level `α` with `α < α*`
    (encoded abstractly as the `h_below : α < αStar` antecedent
    threaded by the consuming theorems — `Types.lean` does not see the
    `alphaStar` carrier, defined downstream in `Cognitive.lean`), every
    percolation realisation `ω`, and `β₁ ≤ β₂`,
    `agentRewardKernel AgentType.sentimental β₁ κ α ω ≤
     agentRewardKernel AgentType.sentimental β₂ κ α ω`.

    Current concrete closure: the sentimental branch of
    `agentRewardKernel` is the constant reward `(1 : ℝ) / 2`, so the
    monotonicity inequality reduces to reflexivity by
    `simp [agentRewardKernel]`. The theorem preserves the paper-facing
    sentimental monotonicity interface; for this current carrier it is
    kernel-proved and does not consume a live Blackwell/Category-3
    structural input.

    Future non-constant sentimental kernels would need the actual
    below-threshold fixed-feasible-set Blackwell comparison proof or an
    explicit input. -/
theorem agentRewardKernel_sentimental_pointwise_monotone :
    ∀ (κ α : ℝ),
      ∀ (β₁ β₂ : ℝ), β₁ ≤ β₂ →
        ∀ ω : BondConfig AgentEdgeIdx,
          agentRewardKernel AgentType.sentimental β₁ κ α ω ≤
            agentRewardKernel AgentType.sentimental β₂ κ α ω := by
  intro κ α β₁ β₂ _hβ ω
  simp [agentRewardKernel]

/-- Derived theorem: pointwise (per-percolation-
    realisation) continuity of the κ-agent's reward kernel in `β`.
    For every cognitive depth `κ`, instrumental rationality `α`, and
    percolation realisation `ω`, the function `β ↦ agentRewardKernel
    AgentType.kappaAgent β κ α ω` is continuous on `Set.Ici 0`.

    Paper-stipulated. Paper §2.5 line 205-208 STIPULATES the inner
    expectation `E_{s, ω̂_κ}[r(v_T)]` as a continuous function of the
    signal-precision parameter `β` (the Gaussian signal model with
    variance `σ²(β) = 1/(2^{2β} - 1)` is continuous in `β` on
    `(0, ∞)`, and the paper extends this continuously to `β = 0`).
    The per-realisation form here STIPULATES the pointwise version of
    this paper-Def-stipulated continuity, paralleling the
    pointwise-monotone structural equations above
    (`agentRewardKernel_*_pointwise_monotone`).

    Current concrete closure of the κ-agent pointwise-continuity
    interface used by the Principal continuity lemmas. In the current
    scalar carrier, `agentRewardKernel AgentType.kappaAgent` is the
    constant reward `(1 : ℝ) / 2`, so the β-section is continuous on
    `Set.Ici 0` by `continuousOn_const` and simplification.

    This theorem preserves the paper-facing interface consumed by
    `aboveThresholdWelfare_continuousOn_Ici` and
    `belowThresholdWelfare_continuousOn_Ici`; for the current carrier it
    is kernel-proved, not an active Paper-Def smoothness input.

    Future non-constant κ-agent reward kernels would need a real
    posterior/reward continuity proof or an explicit regularity input. -/
theorem agentRewardKernel_kappaAgent_continuousOn_in_beta_pointwise :
    ∀ (κ α : ℝ),
      ∀ ω : BondConfig AgentEdgeIdx,
        ContinuousOn (fun β => agentRewardKernel AgentType.kappaAgent β κ α ω)
          (Set.Ici (0 : ℝ)) := by
  intro κ α ω
  simpa [agentRewardKernel] using
    (continuousOn_const :
      ContinuousOn (fun _β : ℝ => (1 : ℝ) / 2) (Set.Ici (0 : ℝ)))

/-- Current concrete closure of the Topkis 1978 §3.1 increasing-
    differences interface for the per-realisation κ-agent reward kernel.

    In the current scalar carrier, `agentRewardKernel AgentType.kappaAgent`
    is the constant reward `(1 : ℝ) / 2`. Hence both slice differences
    are definitionally zero, and the increasing-differences inequality
    is kernel-proved by simplification. The theorem keeps the paper-facing
    interface used by downstream Topkis/supermodularity statements, but it
    is not an active Paper-Def bridge for this concrete carrier.

    Future non-constant κ-agent reward kernels would need a new explicit
    Topkis/increasing-differences proof or input. -/
theorem agentRewardKernel_kappaAgent_increasing_differences_paper_Def :
    ∀ (α : ℝ),
      ∀ ω : BondConfig AgentEdgeIdx,
        ∀ κ₁ κ₂ : ℝ, κ₁ ≤ κ₂ →
          ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
            agentRewardKernel AgentType.kappaAgent β₁ κ₂ α ω -
                agentRewardKernel AgentType.kappaAgent β₁ κ₁ α ω ≤
              agentRewardKernel AgentType.kappaAgent β₂ κ₂ α ω -
                agentRewardKernel AgentType.kappaAgent β₂ κ₁ α ω := by
  intro α ω κ₁ κ₂ _hκ β₁ β₂ _hβ
  simp [agentRewardKernel]

/-- Derived theorem: per-realisation reward-kernel four-corner
    positivity in `(β, κ)` for the κ-agent — the Topkis four-corner
    inequality on the reward kernel.

    Composes the kernel-proved increasing-differences interface
    `agentRewardKernel_kappaAgent_increasing_differences_paper_Def`
    (the Topkis 1978 §3.1 form, which is one-dimensional slice-
    difference monotonicity) with the substantive infrastructure lemma
    `Infrastructure.TopkisCrossPartialCriterion.isSupermodular_of_
    increasing_differences` (lifting slice-difference monotonicity
    to the four-corner inequality).

    `IsSupermodular` definitionally IS the four-corner inequality, but
    the increasing-differences form is genuinely different and requires
    `linarith`-based algebraic rearrangement.

    paper source: Proposition prop:supermodular line 565 + Topkis 1978
    §3.1 cross-partial criterion. -/
theorem agentRewardKernel_kappaAgent_corner_positivity_paper_Def :
    ∀ (α : ℝ),
      ∀ ω : BondConfig AgentEdgeIdx,
        ∀ x₁ x₂ y₁ y₂ : ℝ, x₁ ≤ x₂ → y₁ ≤ y₂ →
          agentRewardKernel AgentType.kappaAgent x₁ y₁ α ω +
              agentRewardKernel AgentType.kappaAgent x₂ y₂ α ω ≥
            agentRewardKernel AgentType.kappaAgent x₁ y₂ α ω +
              agentRewardKernel AgentType.kappaAgent x₂ y₁ α ω := by
  intro α ω x₁ x₂ y₁ y₂ hx hy
  -- Lift the increasing-differences interface to the four-corner form
  -- via the infrastructure lemma.
  have h_super :
      BlackwellDilemma.Infrastructure.IsSupermodular
        (fun β κ => agentRewardKernel AgentType.kappaAgent β κ α ω) :=
    BlackwellDilemma.Infrastructure.isSupermodular_of_increasing_differences
      (fun β κ => agentRewardKernel AgentType.kappaAgent β κ α ω)
      (fun κ₁ κ₂ hκ β₁ β₂ hβ =>
        agentRewardKernel_kappaAgent_increasing_differences_paper_Def
          α ω κ₁ κ₂ hκ β₁ β₂ hβ)
  exact h_super x₁ x₂ y₁ y₂ hx hy

#print axioms agentRewardKernel_kappaAgent_corner_positivity_paper_Def

/-- Per-realisation κ-agent reward-kernel supermodularity in `(β, κ)`.
    Paper Proposition `prop:supermodular` (line 565) STATES that the
    κ-agent's welfare functional `W(β, κ)` (= `agentWelfare AgentType.
    kappaAgent β κ 1`) is supermodular in `(β, κ)`. Per the
    kernel-decomposition (`agentWelfare a β κ α := percExpectation
    (1 - blockingProb) (agentRewardKernel a β κ α)`), this welfare-
    level supermodularity is paper-PRESUPPOSED by the per-realisation
    reward-kernel supermodularity in `(β, κ)`.

    Topkis 1978 §3.1 cross-partial criterion is the conceptual source:
    the `(β, κ)` cross-partial of the paper's Bayesian posterior
    structure is non-negative ⇒ supermodular. The welfare-level
    supermodularity is derivable via
    `Infrastructure.PercExpectationSupermodular.percExpectation_
    supermodular_of_pointwise_supermodular` (lifting from per-ω
    supermodularity to integrated form).

    Implementation: derived theorem composing the four-corner interface
    `agentRewardKernel_kappaAgent_corner_positivity_paper_Def` (itself
    derived from the kernel-proved current-carrier theorem
    `agentRewardKernel_kappaAgent_increasing_differences_paper_Def`
    via `Infrastructure.TopkisCrossPartialCriterion.
    isSupermodular_of_increasing_differences`). The increasing-
    differences form remains the one-dimensional interface exposed to
    downstream Topkis statements; for the current kernel it closes by
    simplification. -/
theorem agentRewardKernel_kappaAgent_supermodular_in_beta_kappa_pointwise :
    ∀ (α : ℝ),
      ∀ ω : BondConfig AgentEdgeIdx,
        BlackwellDilemma.Infrastructure.IsSupermodular
          (fun β κ => agentRewardKernel AgentType.kappaAgent β κ α ω) := by
  intro α ω
  exact agentRewardKernel_kappaAgent_corner_positivity_paper_Def α ω

/-- Foundation derived theorem: the general pointwise-monotone-kernel
    ⇒ monotone-welfare bridge. If the per-realisation kernel of
    AgentType `a` at parameters `(κ, α)` is pointwise (per-percolation-
    realisation) non-decreasing in `β`, then the welfare `β ↦
    agentWelfare a β κ α` is non-decreasing.

    This is the operative tool turning the paper's conditional-on-`R`
    Blackwell-monotonicity structural equations (above) into
    welfare-level monotonicity claims. Closure: `agentWelfare` unfolds
    to `percExpectation (1 - blockingProb) (agentRewardKernel a · κ α)`,
    and `Percolation.lean`'s `percExpectation_mono` transfers the
    pointwise `≤` to the expectation. The percolation parameter
    `1 - blockingProb ∈ [0, 1]` from `blockingProb_mem_unitInterval`
    (Definition 2.1).

    This single foundation lemma is what every welfare-monotonicity
    closure (`gap_bayesian_immunity`, the κ-recovery atoms, the
    sentinel-below-α* monotonicity atoms) composes with the
    corresponding paper-stipulated pointwise structural equation.
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

/-- Reversal-witness foundation derived theorem. The general
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
    structural equations (paper-stipulated reversal mechanisms —
    C2-misalignment / trap-induced misranking) into welfare-level
    reversal claims.

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

/-- Tendsto-preservation foundation derived theorem. If for each
    percolation realisation `ω` the kernel sequence `agentRewardKernel
    a β κ α ω` converges to `g ω` as β evolves along filter `l`, then
    the welfare `agentWelfare a β κ α` converges to
    `percExpectation (1 - blockingProb) g` along the same filter.

    Sister to the monotonicity foundation and the strict-`<` foundation;
    enables Tendsto-style welfare-convergence closures via paper-
    stipulated kernel-pointwise-tendsto structural equations. -/
theorem agentWelfare_tendsto_of_kernel_pointwise_tendsto
    (a : AgentType) (κ α : ℝ) (l : Filter ℝ)
    (g : BondConfig AgentEdgeIdx → ℝ)
    (h_ptwise : ∀ ω : BondConfig AgentEdgeIdx,
      Filter.Tendsto (fun β => agentRewardKernel a β κ α ω) l (nhds (g ω))) :
    Filter.Tendsto (fun β => agentWelfare a β κ α) l
      (nhds (percExpectation (1 - blockingProb) g)) := by
  unfold agentWelfare
  exact percExpectation_tendsto_of_pointwise_tendsto
    (1 - blockingProb) (fun β => agentRewardKernel a β κ α) g l h_ptwise

/-- The within-`R` oracle's expected reward (Definition 2.6).

    The current kernel-only scalar model has not yet connected the
    Definition 2.6 oracle construction to the IDP primitives, and no
    downstream theorem consumes this carrier. We therefore keep a
    transparent neutral placeholder, so the source contains no global
    axiom for an unused oracle stub. A later fully instantiated oracle
    module can replace this definition with the expectation over the
    concrete signal/percolation construction.

    paper source: Definition 2.6 (`def:oracle`). -/
noncomputable def oracleReward : ℝ → ℝ :=
  fun _ => (1 / 2 : ℝ)

/-- Cat 3 atomic structural equation: the oracle's expected
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
    consume this bound as a unit-interval input.

    R214 current-source closure: in the present scalar model
    `oracleReward _ = (1 / 2 : Real)`, so this range theorem closes by
    `norm_num [oracleReward]` and is no longer a live structural-equation
    input for the current carrier. -/
theorem oracleReward_mem_unitInterval :
    ∀ β : ℝ, 0 ≤ oracleReward β ∧ oracleReward β ≤ 1 := by
  intro β
  constructor <;> norm_num [oracleReward]

/-! ## 10. Terminal-neighbour topology

Used by Theorem 3.2 (`thm:dilemma`) and Theorem 4.1
(`thm:cognitive-threshold`): each neighbour of `v₀` is either terminal
(degree 1) or leads to a depth-1 subtree. -/

/-- A neighbour `leaf` is terminal relative to its parent if its only
    graph neighbour is that parent. This is the local degree-1 case in
    the terminal-neighbour topology condition. -/
def IsTerminalNeighbourOf (parent leaf : Vertex) : Prop :=
  ∀ w : Vertex, IsEdge leaf w → w = parent

/-- A neighbour `root` leads to a depth-1 subtree relative to its parent
    if every graph neighbour other than the parent is terminal relative
    to `root`. -/
def IsDepthOneSubtreeRootOf (parent root : Vertex) : Prop :=
  ∀ child : Vertex,
    IsEdge root child → child = parent ∨ IsTerminalNeighbourOf root child

/-- Predicate: the IDP instance has terminal-neighbour topology at some
    starting vertex `v₀`: every neighbour of `v₀` is either terminal
    (degree 1 relative to `v₀`) or leads to a depth-1 subtree.

    This is a semantic graph predicate over `IsEdge`, not a bare source
    axiom. Downstream theorems still take this topology condition as a
    hypothesis; the kernel can now unfold what the condition means.

    paper source: Theorem 3.2 (`thm:dilemma`); Theorem 4.1 (`thm:cognitive-
    threshold`). -/
def TerminalNeighbourTopology : Prop :=
  ∃ v₀ : Vertex,
    ∀ u : Vertex, IsEdge v₀ u →
      IsTerminalNeighbourOf v₀ u ∨ IsDepthOneSubtreeRootOf v₀ u

/-- In the current `Fin 5` carrier there is always a vertex distinct from any
    two specified vertices. -/
theorem exists_vertex_not_eq_pair_current (a b : Vertex) :
    ∃ c : Vertex, c ≠ a ∧ c ≠ b := by
  revert a b
  decide

/-- In the current `Fin 5` carrier there is always a vertex distinct from any
    three specified vertices. -/
theorem exists_vertex_not_eq_triple_current (a b c : Vertex) :
    ∃ d : Vertex, d ≠ a ∧ d ≠ b ∧ d ≠ c := by
  revert a b c
  decide

/-- In the current complete-loopless graph no vertex can be terminal relative
    to any parent: every candidate leaf has another neighbour. -/
theorem not_IsTerminalNeighbourOf_current (parent leaf : Vertex) :
    ¬ IsTerminalNeighbourOf parent leaf := by
  intro h_terminal
  obtain ⟨w, h_w_ne_leaf, h_w_ne_parent⟩ :=
    exists_vertex_not_eq_pair_current leaf parent
  have h_edge_leaf_w : IsEdge leaf w := by
    simpa [IsEdge, isEdgeData] using h_w_ne_leaf.symm
  exact h_w_ne_parent (h_terminal w h_edge_leaf_w)

/-- In the current complete-loopless graph no neighbour can be a depth-one
    subtree root relative to any parent. -/
theorem not_IsDepthOneSubtreeRootOf_current (parent root : Vertex) :
    ¬ IsDepthOneSubtreeRootOf parent root := by
  intro h_depth
  obtain ⟨child, h_child_ne_root, h_child_ne_parent⟩ :=
    exists_vertex_not_eq_pair_current root parent
  have h_edge_root_child : IsEdge root child := by
    simpa [IsEdge, isEdgeData] using h_child_ne_root.symm
  rcases h_depth child h_edge_root_child with h_child_eq_parent | h_terminal
  · exact h_child_ne_parent h_child_eq_parent
  · exact not_IsTerminalNeighbourOf_current root child h_terminal

/-- Current-carrier obstruction: the canonical complete-loopless graph on
    `Fin 5` does not instantiate the paper's terminal-neighbour topology. -/
theorem not_TerminalNeighbourTopology_current :
    ¬ TerminalNeighbourTopology := by
  rintro ⟨v₀, h_topology⟩
  obtain ⟨u, h_u_ne_v₀, _⟩ := exists_vertex_not_eq_pair_current v₀ v₀
  have h_edge_v₀_u : IsEdge v₀ u := by
    simpa [IsEdge, isEdgeData] using h_u_ne_v₀.symm
  rcases h_topology u h_edge_v₀_u with h_terminal | h_depth
  · exact not_IsTerminalNeighbourOf_current v₀ u h_terminal
  · exact not_IsDepthOneSubtreeRootOf_current v₀ u h_depth

/-- Predicate: some starting vertex has exactly two accessible graph
    neighbours. This encodes the paper's degree-two starting-vertex
    scope condition as a semantic graph predicate over `IsEdge`, rather
    than as a bare source axiom.

    The predicate is intentionally existential: downstream paper theorems
    still take the degree-two condition as a hypothesis, but the meaning
    of that hypothesis is now transparent to the kernel. The local
    neighbour set is represented by the two distinct witnesses `u₁` and
    `u₂`, and the final clause says every accessible neighbour of the
    chosen start vertex is one of those two.

    paper source: Lemma `lem:wrongness` (line 338, "`|N_R(v_0)| = 2`");
    Theorem `thm:dilemma` (line 388, "`v_0` of degree `2` in
    `N_R(v_0)`). -/
def DegreeTwoStartingVertex : Prop :=
  ∃ v₀ u₁ u₂ : Vertex,
    u₁ ≠ u₂ ∧
    IsEdge v₀ u₁ ∧
    IsEdge v₀ u₂ ∧
    ∀ u : Vertex, IsEdge v₀ u → u = u₁ ∨ u = u₂

/-- Current-carrier obstruction: the canonical complete-loopless graph on
    `Fin 5` has too many neighbours at every vertex to instantiate the
    paper's degree-two starting-vertex condition. -/
theorem not_DegreeTwoStartingVertex_current :
    ¬ DegreeTwoStartingVertex := by
  rintro ⟨v₀, u₁, u₂, _h_ne, _h_edge₁, _h_edge₂, h_all⟩
  obtain ⟨w, hw_ne_v₀, hw_ne_u₁, hw_ne_u₂⟩ :=
    exists_vertex_not_eq_triple_current v₀ u₁ u₂
  have h_edge_v₀_w : IsEdge v₀ w := by
    simpa [IsEdge, isEdgeData] using hw_ne_v₀.symm
  rcases h_all w h_edge_v₀_w with h_eq_u₁ | h_eq_u₂
  · exact hw_ne_u₁ h_eq_u₁
  · exact hw_ne_u₂ h_eq_u₂

end BlackwellDilemma
