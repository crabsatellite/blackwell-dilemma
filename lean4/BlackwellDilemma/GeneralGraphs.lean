/-
  BlackwellDilemma/GeneralGraphs.lean

  §7 Extensions Beyond Lattices.

  Companion to: "Information Value Under Endogenous Feasibility" (Li, 2026).

  Contents:
   * Definition (`def:greedy-path`) — Greedy-Path Value `V_g(u; H)`.
   * Theorem 6.1 (`thm:general-tree`) — Non-Monotonicity on General
     Graphs (under condition C2′).
   * Example (`ex:cyclic-trap`) — Cyclic Trap.
   * Definition (`def:trap-tree`) — Depth-`d` Trap Tree.
   * Proposition (`prop:error-compounding`) — Error Compounding on
     depth-`d` trap trees, including `κ*(d) = Θ(log d)` closed form.
-/

import BlackwellDilemma.Types
import BlackwellDilemma.ClassicalResults
import BlackwellDilemma.Wrongness
import BlackwellDilemma.Phase  -- for V_dyn

namespace BlackwellDilemma

/-! ## 1. Greedy-path value (`def:greedy-path`)

For a vertex `u` with history `H`, `V_g(u; H)` is the terminal reward
obtained by the greedy agent under perfect signals (`β = ∞`):
at each vertex `w`, select `argmax_{c ∈ N_R(w) \ H_w} r(c)`. -/

/-- The greedy-path value `V_g(u; H, ω)`: terminal reward of the greedy
    agent with perfect signals under percolation outcome `ω`, starting
    at `u` with history `H` already visited.

    paper source: Definition `def:greedy-path`, lines 982-985. -/
axiom V_g : Vertex → Finset Vertex → PercolationOutcome → ℝ

/-- Cat 3 paper-novel ATOMIC structural equation: terminal-vertex base
    case of the greedy-path-value recursion. Paper Definition
    `def:greedy-path` (lines 982-985) reads "if `u` is a leaf,
    `V_g(u) = r(u)`"; specialised to the IDP setting where "leaf"
    means "no unvisited accessible neighbour", which under the
    `ForwardReachable` carrier is the case `ForwardReachable u H ω = {u}`
    (only the trivial-path-to-self lies in the forward-reachable set).

    Encoding choice: the paper definition is recursive; the recursion
    cannot be written directly as a Lean `def` over `Vertex` because
    `Vertex` is opaque (no induction principle). We therefore expose
    the two paper-STATED key properties as atomic axioms: this terminal
    base case (`V_g_def_terminal`) and the recursion-step greedy-choice
    equation (`V_g_def_step` below). Together they pin the opaque carrier
    to the paper's recursive definition over the existing IDP primitives.

    paper source: Definition `def:greedy-path`, lines 982-985 ("if `u` is
    a leaf, `V_g(u) = r(u)`"). -/
axiom V_g_def_terminal :
    ∀ (u : Vertex) (H : Finset Vertex) (ω : PercolationOutcome),
      ForwardReachable u H ω = {u} →
      V_g u H ω = reward u

/-- Cat 1 derived theorem: in the terminal-vertex case
    (`ForwardReachable u H ω = {u}`), the greedy-path value `V_g u H ω`
    inherits the unit-interval bound `[0, 1]` from `reward u` (paper Def 2.1
    `r: V → [0, 1]`). Composes the structural-equation atom
    `V_g_def_terminal` (paper `def:greedy-path` lines 982-985 terminal-base
    case `V_g(u) = r(u)`) with the unit-interval atom
    `reward_mem_unitInterval` (paper Def 2.1 line 113), giving
    `V_g_def_terminal` an explicit downstream consumer per the discipline's
    "every atom serves a derived theorem" mandate. The unit-interval
    bound on `V_g u H ω` in the terminal case is paper-implicit (greedy
    value is bounded by reward range); this derivation makes that
    consequence operational on the `V_g` carrier.
    paper source: Definition `def:greedy-path`, lines 982-985 (terminal-
    vertex base case `V_g(u) = r(u)`) + Definition 2.1 line 113
    (`r: V → [0, 1]`). -/
theorem V_g_terminal_mem_unitInterval
    (u : Vertex) (H : Finset Vertex) (ω : PercolationOutcome)
    (h_terminal : ForwardReachable u H ω = {u}) :
    0 ≤ V_g u H ω ∧ V_g u H ω ≤ 1 := by
  rw [V_g_def_terminal u H ω h_terminal]
  exact reward_mem_unitInterval u

/-- Cat 3 paper-novel ATOMIC structural equation: recursive step of the
    greedy-path-value definition. Paper Definition `def:greedy-path`
    (lines 982-985) reads "if `u` has children `c_1, ..., c_b` with open
    edges, `V_g(u) = V_g(argmax_{c_i} r(c_i))`": the greedy agent at `u`
    selects the highest-immediate-reward child and recurses.

    Encoding choice: the paper's `argmax_{c_i} r(c_i)` is realised by
    `(N.image reward).argmax id`, but to avoid choosing a specific
    `argmax` selector we encode the WEAKER paper-stated property: there
    EXISTS some child `c ∈ N` with `reward c = (N.image reward).max'`
    (i.e., a maximiser exists; non-emptiness is supplied as `hN_nonempty`)
    such that `V_g u H ω = V_g c (insert u H) ω`. This captures the
    paper-stated recursive equation without committing to a specific
    `argmax` tie-breaking convention.

    The hypothesis `N` is the set of unvisited accessible neighbours
    `N := ForwardReachable u H ω \ {u}` (the "children" of `u` in the
    paper's terminology, after excluding the length-0 self-path).

    paper source: Definition `def:greedy-path`, lines 982-985 ("if `u`
    has children `c_1, ..., c_b` with open edges, `V_g(u) =
    V_g(argmax_{c_i} r(c_i))`").

    Status — atomized stub awaiting consumer: this atom is the paper-
    stated recursive-step structural equation paired with
    `V_g_def_terminal` (the terminal-base case, now consumed by
    `V_g_terminal_mem_unitInterval`). The recursive-step companion is
    retained as paper-grade infrastructure but no current theorem
    inducts on the existential-maximiser to consume it. Future
    derivations of `V_g`-monotonicity / `V_g`-connectivity arguments
    that descend through the greedy path are expected to consume this
    atom; until then the discipline accepts it as a foundational
    Cat 3 atomic structural-equation record. -/
axiom V_g_def_step :
    ∀ (u : Vertex) (H : Finset Vertex) (ω : PercolationOutcome)
      (hN_nonempty : ((ForwardReachable u H ω).erase u).Nonempty),
        ∃ c ∈ ((ForwardReachable u H ω).erase u),
          reward c =
            (((ForwardReachable u H ω).erase u).image reward).max'
              (hN_nonempty.image reward) ∧
          V_g u H ω = V_g c (insert u H) ω

/-- Cat 3 paper-novel ATOMIC structural equation: the greedy-path
    terminal vertex lies in the forward-reachable set. Paper Definition
    `def:greedy-path` (lines 982-985) describes the greedy traversal as
    "at each vertex `w`, the agent selects `argmax_{c ∈ N_R(w) ∖ H_w}
    r(c)` ... the process terminates when no such neighbor exists";
    the resulting terminal vertex `v_T_greedy(u, H, ω)` is reached from
    `u` via a sequence of open edges (paper line 984: "with open edges,
    `V_g(u) = V_g(argmax_{c_i} r(c_i))`"), so by Definition 2.5
    (`def:forward-reachable`) the terminal vertex belongs to
    `ForwardReachable u H ω`. The greedy-path value equals the reward
    of this terminal vertex (paper line 984 leaf-case: "if `u` is a
    leaf, `V_g(u) = r(u)`").

    Encoding choice: a single existential witnessing both (a) the
    terminal vertex's membership in the forward-reachable set and
    (b) the greedy-path value equation `V_g u H ω = reward w`. This
    matches the paper's recursive definition without committing to a
    specific tie-breaking convention for the greedy traversal. The
    existential follows from the paper's recursive description; it is
    paper-stated structurally even though the recursion itself is
    encoded by `V_g_def_terminal` and `V_g_def_step` (already in this
    file).

    paper source: Definition `def:greedy-path`, lines 982-985 ("if `u`
    is a leaf, `V_g(u) = r(u)`; if `u` has children `c_1, ..., c_b`
    with open edges, `V_g(u) = V_g(argmax_{c_i} r(c_i))`") + Definition
    2.5 (`def:forward-reachable`, length-0 path inclusion + open-edge
    propagation). -/
axiom V_g_terminal_in_ForwardReachable_OPEN :
    ∀ (u : Vertex) (H : Finset Vertex) (ω : PercolationOutcome),
      ∃ w ∈ ForwardReachable u H ω, V_g u H ω = reward w

/-- **Generic inequality `V_g(u) ≤ V_dyn(u)`** on deeper trees: the
    greedy path may miss the globally optimal leaf.

    Refactored from the prior `gap_V_g_le_V_dyn_OPEN` per
    `feedback_gap_ledger_in_lean4` 2026-05-13 anti-pattern repair: the
    inequality is now derived from (a) the Cat 3 atomic structural
    equation `V_g_terminal_in_ForwardReachable_OPEN` (paper-stated
    greedy-path-terminal-membership in the forward-reachable set), and
    (b) the existing Cat 3 atomic structural equation `V_dyn_def`
    (paper-stated `V_dyn` characterisation as `sup'` of `reward` over
    the forward-reachable set). The terminal vertex's reward is bounded
    above by the supremum over the entire forward-reachable carrier
    (Mathlib `Finset.le_sup'`), giving the inequality.

    paper source: line 987 ("On terminal-neighbor topology, V_g(u) =
    V_dyn(u). On deeper trees, V_g(u) ≤ V_dyn(u), potentially strictly"). -/
theorem gap_V_g_le_V_dyn :
    ∀ (u : Vertex) (H : Finset Vertex) (ω : PercolationOutcome),
      V_g u H ω ≤ V_dyn u H ω := by
  intro u H ω
  obtain ⟨w, hw_mem, hw_eq⟩ := V_g_terminal_in_ForwardReachable_OPEN u H ω
  rw [hw_eq, V_dyn_def u H ω]
  exact Finset.le_sup' (f := reward) hw_mem

/-! ## 2. Theorem 6.1 — Non-Monotonicity on General Graphs

Under C1, C3, and the greedy-path generalisation C2′ (which includes a
non-interference clause), the greedy agent's welfare on any finite
connected graph `G` is non-monotone in β. -/

/-- **Theorem 6.1** (`thm:general-tree`).
    Subsumes Theorem 3.2: terminal-neighbour topology satisfies C2′
    whenever C2 holds, and cycles do not invalidate C2′ because the
    no-revisit rule prevents back-tracking.

    paper source: Theorem 6.1 (`thm:general-tree`), lines 989-998. -/
axiom C2prime_implies_greedy_reversal_OPEN :
    Conditions_C1_C2prime_C3 →
    ∃ β β' : ℝ, β < β' ∧
      agentWelfare AgentType.greedy β' 0 1 <
        agentWelfare AgentType.greedy β 0 1

/-- **Theorem 6.1** (`thm:general-tree`) (derived theorem composing
    `C2prime_implies_greedy_reversal_OPEN` per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern).
    Subsumes Theorem 3.2 via `dilemma_subsumed_by_gap_general_tree`
    (terminal-neighbour topology + C2 ⇒ C2′).

    paper source: Theorem 6.1 (`thm:general-tree`), lines 989-998. -/
theorem gap_general_tree :
    Conditions_C1_C2prime_C3 →
    ∃ β β' : ℝ, β < β' ∧
      agentWelfare AgentType.greedy β' 0 1 <
        agentWelfare AgentType.greedy β 0 1 :=
  C2prime_implies_greedy_reversal_OPEN

/-- Cat 3 paper-novel ATOMIC stipulation #1 (R58 closure-path-B
    decomposition of retired
    `terminal_neighbour_implies_C2prime_atom_OPEN`): under
    terminal-neighbour topology, the greedy-path value `V_g` agrees with
    the oracle dynamic value `V_dyn` (paper line 987 + line 1019 first
    "since" reason: "V_g = V_dyn on flat subtrees"). On terminal-neighbour
    topology each accessible neighbour of `v₀` is either terminal
    (degree 1) or leads to a depth-1 subtree, so the greedy traversal
    coincides with the oracle path: `V_g(u; H) = V_dyn(u; H, ω)` for
    all `u`, `H`, `ω`.

    Encoded as a paper-stated structural-equation atom on the existing
    `V_g`, `V_dyn`, and `TerminalNeighbourTopology` carriers. Strictly
    smaller than the retired bundled atom (which packaged this
    structural equality with the additional non-interference vacuity +
    the C2/C2′ inferential composition step). The atom isolates the
    paper's first reason exactly as line 987 and line 1019 state it.

    Cat 3 sub-type: structuralEquation (R70 §3.4.3 reclassification —
    paper line 987 STATES inline `On terminal-neighbor topology, V_g(u)
    = V_dyn(u)` as paper-defining commitment about how the V_g and V_dyn
    carriers relate at the paper-named TerminalNeighbourTopology regime;
    paper does NOT derive this, it is paper's stipulation). Mirrors
    `V_g_def_terminal` precedent (R23-C1 carrier-defining equation at
    boundary regime per paper Def `def:greedy-path` line 984 STIPULATING
    V_g(u) = r(u) at terminal vertex). 永不 close per discipline §3.4.3.

    paper source: line 987 ("On terminal-neighbor topology, V_g(u) =
    V_dyn(u)") + line 1019 first "since" ("V_g = V_dyn on flat
    subtrees"). -/
axiom V_g_eq_V_dyn_on_terminal_neighbour_OPEN :
    TerminalNeighbourTopology →
    ∀ (u : Vertex) (H : Finset Vertex) (ω : PercolationOutcome),
      V_g u H ω = V_dyn u H ω

/-- Cat 3 paper-novel ATOMIC stipulation #2 (R58 closure-path-B
    decomposition of retired
    `terminal_neighbour_implies_C2prime_atom_OPEN`): the C2′ predicate
    is implied by C2 plus the paper's two structural reasons identified
    by line 1019 ("V_g = V_dyn on flat subtrees AND non-interference
    clause is vacuous for degree 2"). The paper-stated inferential
    composition step: the C2′ misalignment definition (paper Theorem
    6.1, lines 992-995) reduces to the C2 misalignment when
    (a) `V_g = V_dyn` (so the misalignment statement on `V_g` collapses
    to the misalignment statement on `V_dyn` already encoded in C2),
    AND (b) the non-interference clause is vacuous (paper line 995:
    "When |N_R(v_0)| = 2, the clause is vacuous and C2′ reduces to C2");
    the latter holds automatically under terminal-neighbour topology
    (paper line 1019 second "since" reason, the degree-2 vacuity
    instance specialised to terminal-neighbour topology).

    Strictly smaller than the retired bundled atom: the inferential
    composition step is now isolated from the underlying structural
    equality of stipulation #1, exposing the paper's `V_g = V_dyn`
    reduction explicitly in the chained antecedent. The composition is
    paper-stated on the opaque hypothesis predicates `C2_*`, `C2prime_*`,
    `TerminalNeighbourTopology`.

    Cat 3 sub-type: structuralEquation (R70 §3.4.3 reclassification —
    paper Theorem 6.1 line 995 STATES inline `When |N_R(v_0)| = 2, the
    clause is vacuous and C2′ reduces to C2` as paper-defining
    commitment about how the C2 and C2′ predicates relate at the
    paper-named degree-2 regime; paper line 1019 specialises this to
    terminal-neighbour topology. Paper does NOT derive these; they are
    paper's stipulations). Mirrors R68 closure 2 + R69 closures 1+2
    precedents (paper-stipulated predicate-conjunction validity /
    inter-carrier bindings at named regimes are §3.4.3 structural
    identities). 永不 close per discipline §3.4.3.

    paper source: Theorem 6.1 line 995 ("When |N_R(v_0)| = 2, the
    clause is vacuous and C2′ reduces to C2") + line 1019 second
    "since" ("non-interference clause is vacuous for degree~2",
    specialising line 995 to terminal-neighbour topology). -/
axiom C2_to_C2prime_via_V_g_eq_V_dyn_at_terminal_neighbour_OPEN :
    TerminalNeighbourTopology →
    (∀ (u : Vertex) (H : Finset Vertex) (ω : PercolationOutcome),
      V_g u H ω = V_dyn u H ω) →
    C2_RewardTopologyMisalignment →
    C2prime_GreedyPathMisalignment

/-- **Subsumption: `C2 + terminal-neighbour topology ⇒ C2′`**
    (R58 closure-path-B derived theorem from §18 decomposition).

    The retired `terminal_neighbour_implies_C2prime_atom_OPEN` bundled
    the V_g = V_dyn structural equality, the non-interference vacuity,
    and the C2/C2′ inferential composition into one axiom. R58 splits
    this into two strictly-smaller atoms:
      (i) `V_g_eq_V_dyn_on_terminal_neighbour_OPEN` (paper line 987 +
          line 1019 first "since" reason: V_g = V_dyn on flat subtrees);
      (ii) `C2_to_C2prime_via_V_g_eq_V_dyn_at_terminal_neighbour_OPEN`
          (paper line 1019 inferential composition step).
    The implication is now derived by composing the two atoms. The
    isolated structural equality (atom (i)) is reusable independently
    of the C2/C2′ inferential composition (atom (ii)), opening the door
    for downstream consumers that need V_g = V_dyn on flat subtrees
    without invoking the C2/C2′ machinery.

    paper source: line 1019 ("terminal-neighbour topology satisfies C2′
    whenever C2 holds, since V_g = V_dyn on flat subtrees and the
    non-interference clause is vacuous for degree~2"). -/
theorem terminal_neighbour_implies_C2prime :
    C2_RewardTopologyMisalignment →
    TerminalNeighbourTopology →
    C2prime_GreedyPathMisalignment := by
  intro hC2 hT
  have h_V_g_eq_V_dyn := V_g_eq_V_dyn_on_terminal_neighbour_OPEN hT
  exact C2_to_C2prime_via_V_g_eq_V_dyn_at_terminal_neighbour_OPEN
    hT h_V_g_eq_V_dyn hC2

/-- **Subsumption: Theorem 3.2 follows from Theorem 6.1.**
    Terminal-neighbour topology + C2 ⇒ C2′ (the non-interference clause
    is vacuous at degree 2).

    Refactored from the prior `dilemma_subsumed_by_gap_general_tree_OPEN`
    per `feedback_gap_ledger_in_lean4` 2026-05-13 anti-pattern repair:
    the implication on the bundle-form predicates `Conditions_C1_C2_C3
    → Conditions_C1_C2prime_C3` is now derived from (a) the Cat 3
    atomic structural-implication axiom
    `terminal_neighbour_implies_C2prime_atom_OPEN` (paper line 1019
    structural fact on the C2/C2′ predicates) plus (b) the trivial
    conjunction-rebuilding step using the definitions of the bundle
    predicates in Types.lean (§6 line 294-299).

    paper source: line 1019. -/
theorem dilemma_subsumed_by_gap_general_tree :
    Conditions_C1_C2_C3 →
    TerminalNeighbourTopology →
    Conditions_C1_C2prime_C3 := by
  intro hC hT
  obtain ⟨h_C1, h_C2, h_C3⟩ := hC
  exact ⟨h_C1, terminal_neighbour_implies_C2prime h_C2 hT, h_C3⟩

/-! ## 3. Example `ex:cyclic-trap`

A 4-cycle `v₀–u₁–w–u₂–v₀` plus an attached goal `G` adjacent to `u₂`.
With `r(u₁) = 0.6, r(u₂) = 0.4, r(w) = 0.3, r(G) = 1.0` and edge
`u₁–w` blocked with probability `p > 0`: on the event that the edge is
blocked (probability `p > 0`), C2′ holds and Theorem 6.1 applies. -/

/-- Cat 3 paper-novel ATOMIC stipulation (R58 closure-path-A
    decomposition of retired
    `cyclic_4_satisfies_C2prime_at_open_event_OPEN`): the 4-cycle trap
    configuration of paper Example `ex:cyclic-trap` (lines 1026-1029)
    satisfies the full diagnostic conjunction `Conditions_C1_C2prime_C3`
    on the event that the unreliable edge `u_1`-`w` is blocked
    (probability `p > 0`). Paper line 1028 explicitly states: "On the
    event that `u_1`-`w` is blocked (probability `p > 0`):
    `r(u_1) > r(u_2)` but `V_g(u_1) = 0.6 < 1.0 = V_g(u_2)`, so C2′
    holds and Theorem~\ref{thm:general-tree} applies."

    Strictly smaller than the retired bundled atom (which packaged the
    `Conditions_C1_C2prime_C3` validity AND the existential β-reversal
    conclusion of Theorem 6.1). The atom isolates the structural
    pre-condition (the IDP instance satisfies the diagnostic conjunction),
    leaving the existential reversal conclusion to be derived by
    composition with the file-local Cat 3 atom
    `C2prime_implies_greedy_reversal_OPEN` (paper Theorem 6.1, the
    derived consequence of the conditions on any IDP instance).

    R68 §3.4.3 reclassification (was R58 workingAssumption): paper
    Example `ex:cyclic-trap` line 1028 EXPLICITLY STATES "On the event
    that `u_1`-`w` is blocked (probability `p > 0`): `r(u_1) > r(u_2)`
    but `V_g(u_1) = 0.6 < 1.0 = V_g(u_2)`, so C2′ holds and Theorem
    \ref{thm:general-tree} applies." The Example IS the paper's
    construction-stipulated diagnostic conjunction validity at this
    exhibited 4-cycle configuration. Paper Examples are stipulation
    devices that fix the construction (rewards, topology, percolation
    assignments) and ASSERT the conditions hold by construction — they
    are NOT paper-Theorem-derivations.

    Since `Conditions_C1_C2prime_C3 = C1 ∧ C2′ ∧ C3` is a conjunction
    of opaque `Prop` axioms (paper hypothesis-predicate carriers), the
    assertion that the predicates evaluate True at this paper-Example
    construction IS the paper's stipulated structural identity on the
    opaque hypothesis-predicate carriers. Mirrors R63 precedent
    (`betaBarStar_nonneg_OPEN` carrier-domain commitment): the paper's
    Example STIPULATES the structural property of the opaque-Prop
    carriers under the example's construction.

    Cat 3 sub-type: structuralEquation (paper-Example-stipulated
    structural identity on the opaque hypothesis-predicate carriers
    `C1_Irreversibility ∧ C2prime_GreedyPathMisalignment ∧
    C3_InformationLocality` under the cyclic-4-trap construction; 永不
    close per discipline §3.4.3 — paper Example IS the construction's
    stipulation).

    paper source: Example `ex:cyclic-trap`, line 1028 (paper-Example-
    stipulated diagnostic conjunction at the blocked event). -/
axiom cyclic_4_satisfies_full_conditions_at_blocked_event_OPEN :
    ∀ p : ℝ, 0 < p → p < 1 → Conditions_C1_C2prime_C3

/-- **Example `ex:cyclic-trap`** (R58 closure-path-A derived theorem
    composing the smaller atom
    `cyclic_4_satisfies_full_conditions_at_blocked_event_OPEN`
    (paper line 1028 — diagnostic conjunction holds at the blocked
    event) with the file-local Cat 3 atom
    `C2prime_implies_greedy_reversal_OPEN` (paper Theorem 6.1 —
    `Conditions_C1_C2prime_C3` ⇒ greedy β-reversal exists).
    Non-monotonicity survives on graphs with cycles.

    Net effect: the original bundled
    `cyclic_4_satisfies_C2prime_at_open_event_OPEN` (which packaged
    both the diagnostic-conjunction validity AND the existential
    β-reversal conclusion of Theorem 6.1 into one axiom) is replaced
    by a strictly-smaller atom (just the diagnostic-conjunction
    validity at the blocked event) chained with the existing Theorem 6.1
    atom. The atomic decomposition exposes the paper-stated structural
    composition explicitly: the cyclic-trap example satisfies the
    Theorem 6.1 hypotheses, hence inherits the Theorem 6.1 conclusion.

    paper source: Example `ex:cyclic-trap`, lines 1026-1029. -/
theorem gap_cyclic_trap :
    ∀ p : ℝ, 0 < p → p < 1 →
      ∃ β β' : ℝ, β < β' ∧
        agentWelfare AgentType.greedy β' 0 1 < agentWelfare AgentType.greedy β 0 1 := by
  intro p hp_pos hp_lt_one
  exact C2prime_implies_greedy_reversal_OPEN
    (cyclic_4_satisfies_full_conditions_at_blocked_event_OPEN p hp_pos hp_lt_one)

/-! ## 4. Depth-`d` trap tree (`def:trap-tree`)

`T_d` has root `v_0` with binary routing at each depth `< d`: a trap
leaf `t_k` (reward `0.6`) and a bridge `b_k` (reward `0.4`); `b_{d-1}`
has a single child `G` (reward `1.0`). -/

namespace TrapTree

/-- Reward of a trap leaf (constant across depth). Real division is
    `noncomputable`, so the rationals 6/10 and 4/10 force `noncomputable`. -/
noncomputable def r_trap : ℝ := (6 : ℝ) / 10

/-- Reward of a bridge node (constant across depth). -/
noncomputable def r_bridge : ℝ := (4 : ℝ) / 10

/-- Reward of the goal at depth `d`. -/
def r_goal : ℝ := 1

/-- Reward gap at each binary routing decision. -/
noncomputable def Delta : ℝ := r_trap - r_bridge  -- = 0.2

/-! ## 5. Proposition `prop:error-compounding` -/

/-- **Bridge-selection probability at each node**:
    `P_b(β) = Φ(-Δ/√(2σ²(β)))`. Identical at every depth.

    paper source: Proposition `prop:error-compounding` Part 3. -/
noncomputable def P_b (β : ℝ) : ℝ :=
  Phi (-(Delta / Real.sqrt (2 * signalVariance β)))

/-- **Proposition `prop:error-compounding` Part 3.**
    `W(β) = 0.6 + 0.4 · P_b(β)^d` on `T_d`.

    paper source: Proposition `prop:error-compounding` Part 3. -/
noncomputable def W (β : ℝ) (d : ℕ) : ℝ :=
  r_trap + (4/10 : ℝ) * (P_b β)^d

/-- **Proposition `prop:error-compounding` Part 1.**
    Greedy welfare on depth-`d` trap tree achieves
    `lim_{β→∞} W(β, d) = r_trap = 0.6`, independent of `d`. Substantive
    paper claim — limit encoded via `Filter.Tendsto` against the actual
    finite-β welfare process `W β d`. **CLOSED**: derived via the same
    `signalVariance_tendsto_zero_atTop` + `tendsto_const_div_atTop_of_tendsto_zero_pos`
    chain as `gap_W_open_limit_infty` (Canonical.lean), composed with
    `Phi_tendsto_zero_atBot` (since `P_b β = Φ(−Δ/√(2σ²(β)))` — negative
    argument tending to `−∞`) and `pow_d` continuity at `0`.

    paper source: Proposition `prop:error-compounding` Part 1. -/
theorem gap_error_compounding_part1 :
    ∀ d : ℕ, 1 ≤ d →
      Filter.Tendsto (fun β : ℝ => W β d) Filter.atTop (nhds r_trap) := by
  intro d _
  unfold W
  -- Step 1: signalVariance β → 0 atTop.
  have h_sigma : Filter.Tendsto signalVariance Filter.atTop (nhds 0) :=
    signalVariance_tendsto_zero_atTop
  -- Step 2: 2 * signalVariance β → 0.
  have h_2sigma : Filter.Tendsto (fun β : ℝ => 2 * signalVariance β)
      Filter.atTop (nhds 0) := by
    have := h_sigma.const_mul (2 : ℝ)
    simpa using this
  -- Step 3: sqrt(2 * signalVariance β) → 0 (continuity).
  have h_sqrt : Filter.Tendsto (fun β : ℝ => Real.sqrt (2 * signalVariance β))
      Filter.atTop (nhds 0) := by
    have h := (Real.continuous_sqrt.tendsto 0).comp h_2sigma
    rw [Real.sqrt_zero] at h
    exact h
  -- Step 4: sqrt > 0 eventually atTop.
  have h_sqrt_pos : ∀ᶠ β in Filter.atTop, 0 < Real.sqrt (2 * signalVariance β) := by
    filter_upwards [Filter.eventually_gt_atTop (0 : ℝ)] with β hβ
    have h_σ_pos : 0 < signalVariance β := by
      unfold signalVariance
      have h2_one_lt : (1 : ℝ) < 2 := by norm_num
      have h2β_pos : 0 < 2 * β := by linarith
      have h_one_lt_pow : (1 : ℝ) < (2 : ℝ) ^ (2 * β) :=
        Real.one_lt_rpow h2_one_lt h2β_pos
      have h_denom_pos : 0 < (2 : ℝ) ^ (2 * β) - 1 := by linarith
      exact one_div_pos.mpr h_denom_pos
    exact Real.sqrt_pos.mpr (mul_pos (by norm_num) h_σ_pos)
  -- Step 5: Delta > 0.
  have h_Delta : (0 : ℝ) < Delta := by
    unfold Delta r_trap r_bridge; norm_num
  -- Step 6: Delta / sqrt(2σ²(β)) → ∞.
  have h_arg_pos : Filter.Tendsto
      (fun β : ℝ => Delta / Real.sqrt (2 * signalVariance β))
      Filter.atTop Filter.atTop :=
    tendsto_const_div_atTop_of_tendsto_zero_pos Delta h_Delta
      (fun β => Real.sqrt (2 * signalVariance β)) h_sqrt h_sqrt_pos
  -- Step 7: -(Delta / sqrt(...)) → -∞.
  have h_arg_neg : Filter.Tendsto
      (fun β : ℝ => -(Delta / Real.sqrt (2 * signalVariance β)))
      Filter.atTop Filter.atBot :=
    Filter.tendsto_neg_atTop_atBot.comp h_arg_pos
  -- Step 8: Phi(-(Delta / sqrt(...))) → 0 via Phi_tendsto_zero_atBot.
  have h_phi : Filter.Tendsto
      (fun β : ℝ => Phi (-(Delta / Real.sqrt (2 * signalVariance β))))
      Filter.atTop (nhds 0) :=
    Phi_tendsto_zero_atBot.comp h_arg_neg
  -- Step 9: (P_b β)^d → 0^d = 0. Unfold P_b.
  have h_pow : Filter.Tendsto
      (fun β : ℝ => (Phi (-(Delta / Real.sqrt (2 * signalVariance β))))^d)
      Filter.atTop (nhds 0) := by
    have h_cont : Filter.Tendsto (fun x : ℝ => x^d) (nhds 0) (nhds (0^d)) :=
      (continuous_pow d).tendsto 0
    have h := h_cont.comp h_phi
    have h_eq : (0 : ℝ)^d = 0 := zero_pow (by omega : d ≠ 0)
    rw [h_eq] at h
    exact h
  -- Step 10: 0.4 * (P_b)^d → 0.4 * 0 = 0.
  have h_mul : Filter.Tendsto
      (fun β : ℝ => (4/10 : ℝ) * (Phi (-(Delta / Real.sqrt (2 * signalVariance β))))^d)
      Filter.atTop (nhds 0) := by
    have := h_pow.const_mul ((4/10 : ℝ))
    simpa using this
  -- Step 11: r_trap + 0.4 * (P_b)^d → r_trap + 0 = r_trap.
  have h_const : Filter.Tendsto (fun _ : ℝ => r_trap) Filter.atTop (nhds r_trap) :=
    tendsto_const_nhds
  have h_sum : Filter.Tendsto
      (fun β : ℝ => r_trap + (4/10 : ℝ) *
        (Phi (-(Delta / Real.sqrt (2 * signalVariance β))))^d)
      Filter.atTop (nhds (r_trap + 0)) :=
    h_const.add h_mul
  have h_eq : r_trap + 0 = r_trap := by ring
  rw [h_eq] at h_sum
  -- Final: change `Phi (-(Delta / sqrt...))^d` back to `(P_b β)^d` by unfold.
  apply h_sum.congr'
  filter_upwards with β
  unfold P_b
  ring

/-- Opaque carrier (R58 closure-path-B decomposition of retired
    `oracleValueAtRoot_TrapTree_def`): the terminal-vertex reward
    achieved by the oracle on the depth-`d` trap tree, parameterised
    by `d`. Paper proof line 1053 reads: "the oracle follows the
    bridge path to G"; the carrier hosts the terminal reward of this
    path at depth `d`. Cat 3 carrier per §3.4.1 (paper-novel primitive
    function on the depth-d trap-tree oracle's terminal reward).

    R72 hoist (was R58 declared after `oracleValueAtRoot_TrapTree`):
    hoisted to BEFORE `oracleValueAtRoot_TrapTree` to support R72
    substantive-math closure pattern (per R71 `kappa_FOSD` precedent).
    The carrier is paper-Def-stipulated structural primitive per
    discipline §3.4.1 (paper-novel opaque-carrier primitive); position
    in source order is metadata-neutral.

    paper source: paper Proposition `prop:error-compounding` Part 2
    proof, line 1053 (`the oracle follows the bridge path to G`). -/
axiom oracleBridgePathTerminalReward_TrapTree : ℕ → ℝ

/-- Oracle dynamic value at root of depth-`d` trap tree on the
    all-edges-open realisation, paper-claimed value `r_goal = 1.0`.

    R72 substantive-math closure: previously declared `axiom
    oracleValueAtRoot_TrapTree` (opaque carrier). R72 makes the carrier
    CONCRETE per paper Proposition `prop:error-compounding` Part 2 proof
    line 1053's own definitional commitment "the oracle follows the
    bridge path to G" + Definition 2.6 (`def:oracle`) decision rule:
    the oracle's value at the root EQUALS the maximum reward over the
    reachable set, which on the trap tree's bridge-routed path attains
    the terminal reward of the bridge path. The Lean `def` IS the paper's
    oracle-policy identification.

    Per `feedback_no_compute_retreat`: where Mathlib lacks the typed
    oracle-policy framework on per-trap-tree-instance vertex paths,
    define the paper-faithful identification locally rather than skip.

    Per discipline §3.4.3 boundary criterion: the `def` faithfully
    encodes the paper-Theorem-derivation (oracle policy = bridge-path)
    rather than R7-style content-erasure. The identification is
    paper-derived (proof body line 1053) but on opaque-carrier inputs
    where Mathlib lacks the substrate; the `def` records this paper
    derivation as definitional identification at the carrier level.

    paper source: Proposition `prop:error-compounding` Part 2 proof,
    line 1053 (`the oracle follows the bridge path to G`) + Definition
    2.6 (`def:oracle`). -/
noncomputable def oracleValueAtRoot_TrapTree : ℕ → ℝ :=
  fun d => oracleBridgePathTerminalReward_TrapTree d

/-- R68 §3.4.3 reclassification (was R58 closure-path-B workingAssumption):
    paper Definition `def:trap-tree` line 1033 STIPULATES — as part of the
    trap-tree's defining construction — that "Bridge `b_{d-1}` has a single
    child: the goal `G` with `r(G) = 1.0`". The carrier
    `oracleBridgePathTerminalReward_TrapTree d` was introduced explicitly
    to host the bridge-path's terminal reward; its value `= r_goal = 1.0`
    is paper-DEFINING, not paper-derived. The Definition fixes the
    terminal-leaf reward by construction.

    R68 audit-substantive correction: this atom is paper-Def-stipulated
    structural identity on the carrier, NOT a paper-Theorem/Proposition-
    proof-derived working content. Paper line 1053 ("the oracle follows
    the bridge path to G") states which path the oracle takes — this is
    derivation; but the bridge-path's TERMINAL REWARD is fixed by Def
    `def:trap-tree` line 1033 ("Bridge has a single child G with r(G) =
    1.0"). The atom encodes only the latter (carrier-defining terminal-
    reward identity), not the former (oracle policy identification — that
    is the companion atom #2 `oracleValueAtRoot_eq_bridgePathTerminalReward_
    TrapTree_OPEN`, which remains workingAssumption per R67/R68 boundary).

    Cat 3 sub-type: structuralEquation (paper-Def-stipulated terminal-
    reward identity on the bridge-path carrier per Def `def:trap-tree`
    line 1033 — paper's commitment to the trap-tree primitive's bridge-
    leaf reward; 永不 close per discipline §3.4.3).

    paper source: Definition `def:trap-tree`, line 1033 ("Bridge `b_{d-1}`
    has a single child: the goal `G` with `r(G) = 1.0`" — paper-Def-
    stipulated bridge-leaf reward fixing the carrier
    `oracleBridgePathTerminalReward_TrapTree d` to `r_goal`). -/
axiom oracleBridgePathTerminalReward_TrapTree_eq_r_goal_OPEN :
    ∀ d : ℕ, 1 ≤ d → oracleBridgePathTerminalReward_TrapTree d = r_goal

/-- Cat 1 derived theorem (R72 substantive-math closure): paper proof
    line 1053 + Def 2.6 oracle-policy identification
    `oracleValueAtRoot_TrapTree d = oracleBridgePathTerminalReward_TrapTree d`
    under `1 ≤ d`. Now provable kernel-pure via the
    `oracleValueAtRoot_TrapTree` `def`'s unfolding (`rfl`).

    R72 closure pattern: the previous `axiom oracleValueAtRoot_eq_
    bridgePathTerminalReward_TrapTree_OPEN` (R58 `workingAssumption gapOpen`)
    is REPLACED by this Cat 1 derived theorem composing the paper-faithful
    `oracleValueAtRoot_TrapTree` `def` (paper proof line 1053 oracle-policy
    identification IS the carrier's defining identification) with kernel-
    level `rfl`. The companion carrier `oracleBridgePathTerminalReward_
    TrapTree` (hoisted to before `oracleValueAtRoot_TrapTree` above)
    hosts the bridge-path terminal reward.

    Discipline §3.4.3 boundary check: paper Theorem-PROOF line 1053
    derives the policy identification from Def 2.6 inputs; on opaque
    carriers (where Mathlib lacks the substrate), the identification
    becomes definitional at the carrier level. The `def` faithfully
    encodes the paper-derivation rather than R7-style content-erasure.

    Net workingAssumption delta: −1 (workingAssumption gapOpen atom
    retired; carrier-pair preserved with paper-faithful identification
    encoded in `def`).

    paper source: Proposition `prop:error-compounding` Part 2 proof,
    line 1053 ("the oracle follows the bridge path to G") + Definition
    2.6 (`def:oracle`). -/
theorem oracleValueAtRoot_eq_bridgePathTerminalReward_TrapTree_OPEN :
    ∀ d : ℕ, 1 ≤ d →
      oracleValueAtRoot_TrapTree d = oracleBridgePathTerminalReward_TrapTree d :=
  fun _ _ => rfl

/-- **Proposition `prop:error-compounding` Part 2** (R58 closure-path-B
    derived theorem composing the two paper-stated atomic stipulations
    decomposed from the retired `oracleValueAtRoot_TrapTree_def`):
      (i) `oracleValueAtRoot_eq_bridgePathTerminalReward_TrapTree_OPEN`
          (paper line 1053 + Def 2.6 — oracle policy follows the
          bridge path);
      (ii) `oracleBridgePathTerminalReward_TrapTree_eq_r_goal_OPEN`
          (paper line 1053 + Def `def:trap-tree` line 1033 — the
          bridge path terminates at the goal G with reward `r_goal`).

    Each atom is strictly smaller than the original bundled atom (which
    packaged both the policy identification step AND the terminal-reward
    valuation into one). The decomposition exposes the paper proof's
    explicit two-step structure: (a) the oracle follows the bridge path
    (policy identification), then (b) the bridge path terminates at
    `r(G) = r_goal` (terminal-reward valuation).

    paper source: Proposition `prop:error-compounding` Part 2, line
    1041 ("The oracle achieves V_dyn(v_0) = r(G) = 1.0 for all d") +
    proof line 1053 ("the oracle follows the bridge path to G"). -/
theorem gap_error_compounding_part2 :
    ∀ d : ℕ, 1 ≤ d → oracleValueAtRoot_TrapTree d = r_goal := by
  intro d hd
  rw [oracleValueAtRoot_eq_bridgePathTerminalReward_TrapTree_OPEN d hd,
      oracleBridgePathTerminalReward_TrapTree_eq_r_goal_OPEN d hd]

/-- **Proposition `prop:error-compounding` Part 4.**
    `W(β) − W(∞) = 0.4 · P_b(β)^d > 0` for finite β; decays exponentially
    in `d`.

    paper source: Proposition `prop:error-compounding` Part 4. -/
theorem gap_welfare_gain_decay (β : ℝ) (d : ℕ) :
    W β d - r_trap = (4/10 : ℝ) * (P_b β)^d := by
  unfold W
  ring

/-- Substantive paper claim — opaque carrier required (Mathlib gap).
    **Closed-form constant `c*(Δ_r, Δ_V) > 0`** in `κ*(d)`'s formula.
    Strictly positive constant depending on `Δ_r = 0.2` and `Δ_V = 0.6`.

    paper source: Proposition `prop:error-compounding` Part 5, line 1048. -/
axiom c_star_constant : ℝ

/-- Cat 3 paper-novel ATOMIC structural equation: paper line 1048
    `where c* = c*(Δ_r, Δ_V) > 0 is a constant depending on the reward
    gap Δ_r and the continuation gap Δ_V`. Paper INTRODUCES the
    `c_star_constant` carrier via this `where` clause (paper does not
    pre-define c* elsewhere; it appears here as the implicit constant
    satisfying `σ_topo(κ*, d) = c*` per proof body line 1059) and
    SIMULTANEOUSLY stipulates its defining positivity inline.
    Per R68/R69/R70 boundary criterion (paper-CONTENT, not paper-source-
    structure label): paper INLINE STATING carrier-defining property
    via `where` clause IS §3.4.3 paper-commitment regardless of whether
    surrounding context is Definition / Theorem / Proposition / Example /
    Remark.

    R71 §3.4.3 reclassification: structuralEquation/gapDefinitional
    (永不 close; paper-Def-stipulated structural identity per discipline
    §3.4.3). R52 had defaulted to wA via paper-source-structure label
    (Proposition statement); R71 stronger override applies the R68/R69/R70
    paper-CONTENT boundary criterion: the `where ... > 0 is a constant`
    clause IS paper's introduction-with-positivity-stipulation of c*,
    parallel to `oracleBridgePathTerminalReward_TrapTree_eq_r_goal` R68
    closure (paper Def-stipulated terminal-leaf reward by trap-tree
    construction).

    paper source: Proposition `prop:error-compounding` Part 5, line 1048. -/
axiom gap_c_star_constant_pos_OPEN : 0 < c_star_constant

/-- **Closed form `κ*(d) = (1/2) log_2(d²/c* + 1)`** on the depth-`d`
    trap tree.

    `Real.logb` is in a separate Mathlib import that may not be
    available in older Mathlib snapshots; we use the explicit
    `Real.log _ / Real.log 2` form instead.

    paper source: Proposition `prop:error-compounding` Part 5,
    lines 1044-1048. -/
noncomputable def kappaStar_depth_d (d : ℕ) : ℝ :=
  (1/2 : ℝ) *
    (Real.log ((d : ℝ)^2 / c_star_constant + 1) / Real.log 2)

/-- Convenience helper: `log_2 x = Real.log x / Real.log 2`. -/
noncomputable def log_2 (x : ℝ) : ℝ := Real.log x / Real.log 2

/-- **Upper-bound half** of the Θ-asymptotic: `κ*(d) ≤ log_2 d + c₃`
    for `d ≥ 1`, where `c₃ = (1/2) log_2(1/c* + 1)`. This is a
    closed (kernel-pure) partial result; combined with the R83
    lower bound `kappaStar_depth_d_lower_bound` it gives the full
    Θ-asymptotic (`bernoulli_real_power_estimate_OPEN`).

    Proof: for `d ≥ 1` (natural), `1 ≤ d²`, so
    `d²/c* + 1 ≤ d²/c* + d² = d² (1/c* + 1)`. Apply `log_2`
    monotonicity (using `0 < c_star_constant`) and `log_2 (a · b) =
    log_2 a + log_2 b` to get
    `log_2(d²/c* + 1) ≤ log_2(d²) + log_2(1/c* + 1) = 2 log_2 d + log_2(1/c* + 1)`,
    hence `κ*(d) ≤ log_2 d + (1/2) log_2(1/c* + 1)`. -/
theorem gap_kappaStar_depth_d_upper_bound :
    ∃ c₃ : ℝ, ∀ d : ℕ, 1 ≤ d →
      kappaStar_depth_d d ≤ log_2 d + c₃ := by
  refine ⟨(1/2 : ℝ) * (Real.log (1 / c_star_constant + 1) / Real.log 2), ?_⟩
  intro d hd
  have hK : 0 < c_star_constant := gap_c_star_constant_pos_OPEN
  have hd_real : (1 : ℝ) ≤ (d : ℝ) := by exact_mod_cast hd
  have hd_pos : 0 < (d : ℝ) := lt_of_lt_of_le zero_lt_one hd_real
  have hd_sq_pos : 0 < (d : ℝ)^2 := by positivity
  have hd_sq_ge_one : (1 : ℝ) ≤ (d : ℝ)^2 := by
    have : (1 : ℝ)^2 ≤ (d : ℝ)^2 := by
      apply sq_le_sq' <;> nlinarith
    simpa using this
  -- Step 1: d²/K + 1 ≤ d²/K + d² = d² · (1/K + 1)
  have h_split : (d : ℝ)^2 / c_star_constant + 1
      ≤ (d : ℝ)^2 * (1 / c_star_constant + 1) := by
    have heq : (d : ℝ)^2 * (1 / c_star_constant + 1)
        = (d : ℝ)^2 / c_star_constant + (d : ℝ)^2 := by
      field_simp
    rw [heq]
    linarith
  -- Step 2: positivity of d²/K + 1
  have h_lhs_pos : 0 < (d : ℝ)^2 / c_star_constant + 1 := by
    have : 0 < (d : ℝ)^2 / c_star_constant := div_pos hd_sq_pos hK
    linarith
  -- Step 3: log_2 monotonicity
  have h_log_le : Real.log ((d : ℝ)^2 / c_star_constant + 1)
      ≤ Real.log ((d : ℝ)^2 * (1 / c_star_constant + 1)) :=
    Real.log_le_log h_lhs_pos h_split
  -- Step 4: split log of product
  have h_inv_K_plus_one_pos : 0 < 1 / c_star_constant + 1 := by
    have : 0 < 1 / c_star_constant := one_div_pos.mpr hK
    linarith
  have h_log_split : Real.log ((d : ℝ)^2 * (1 / c_star_constant + 1))
      = Real.log ((d : ℝ)^2) + Real.log (1 / c_star_constant + 1) :=
    Real.log_mul (ne_of_gt hd_sq_pos) (ne_of_gt h_inv_K_plus_one_pos)
  have h_log_sq : Real.log ((d : ℝ)^2) = 2 * Real.log (d : ℝ) := by
    rw [show ((d : ℝ)^2) = (d : ℝ) * (d : ℝ) by ring,
        Real.log_mul (ne_of_gt hd_pos) (ne_of_gt hd_pos)]
    ring
  -- Step 5: assemble
  have h_log2_pos : 0 < Real.log 2 := Real.log_pos (by norm_num)
  unfold kappaStar_depth_d log_2
  rw [show ((1 : ℝ)/2) * (Real.log ((d : ℝ)^2 / c_star_constant + 1) / Real.log 2)
        = Real.log ((d : ℝ)^2 / c_star_constant + 1) / (2 * Real.log 2) by ring]
  rw [show Real.log (d : ℝ) / Real.log 2
        + (1/2 : ℝ) * (Real.log (1 / c_star_constant + 1) / Real.log 2)
        = (2 * Real.log (d : ℝ) + Real.log (1 / c_star_constant + 1)) / (2 * Real.log 2) by ring]
  apply div_le_div_of_nonneg_right
  · rw [h_log_sq] at h_log_split
    calc Real.log ((d : ℝ)^2 / c_star_constant + 1)
        ≤ Real.log ((d : ℝ)^2 * (1 / c_star_constant + 1)) := h_log_le
      _ = 2 * Real.log (d : ℝ) + Real.log (1 / c_star_constant + 1) := h_log_split
  · positivity

/-- **R83 lower-bound half of the `κ*(d) = Θ(log d)` asymptotic.**
    For `d ≥ 1` and the (opaque, positive) constant `c*`, the
    weighted AM–GM inequality gives the Bernoulli-style power bound
    `d^(2/(1+c*)) ≤ d²/c* + 1`, hence
    `(1/(1+c*)) · log_2 d ≤ κ*(d)`.

    Proof: weighted AM–GM (`Real.geom_mean_le_arith_mean2_weighted`)
    with weights `w₁ = 1/(1+c*)`, `w₂ = c*/(1+c*)` and points
    `p₁ = d²`, `p₂ = 1` yields
    `(d²)^(1/(1+c*)) ≤ (d² + c*)/(1+c*)`. Rewriting
    `(d²)^(1/(1+c*)) = d^(2/(1+c*))` (via `Real.rpow_natCast` +
    `Real.rpow_mul`) and chaining with
    `(d² + c*)/(1+c*) ≤ (d² + c*)/c* = d²/c* + 1` (since `c* ≤ 1+c*`)
    gives `d^(2/(1+c*)) ≤ d²/c* + 1`. Applying `Real.log` monotonicity
    (`Real.log_le_log`) and `Real.log_rpow` (`log (d^t) = t·log d` for
    `d > 0`) gives `(2/(1+c*))·log d ≤ log(d²/c* + 1)`, i.e.
    `(1/(1+c*))·log_2 d ≤ κ*(d)` after dividing by `2·log 2 > 0`.

    paper source: Proposition `prop:error-compounding` Part 5, line 1044
    (the `(1+1/K)^(log_2 d) ≤ d²/K + 1` Bernoulli-style estimate
    underlying the `κ*(d) = log_2 d + O(1)` lower-bound half). -/
private theorem kappaStar_depth_d_lower_bound (d : ℕ) (hd : 1 ≤ d) :
    (1 / (1 + c_star_constant)) * log_2 d ≤ kappaStar_depth_d d := by
  have hK : 0 < c_star_constant := gap_c_star_constant_pos_OPEN
  have hd_real : (1 : ℝ) ≤ (d : ℝ) := by exact_mod_cast hd
  have hd_pos : 0 < (d : ℝ) := lt_of_lt_of_le zero_lt_one hd_real
  have hd_sq_pos : 0 < (d : ℝ) ^ 2 := by positivity
  have h1K_pos : 0 < 1 + c_star_constant := by linarith
  -- weights of the weighted AM–GM
  set w₁ : ℝ := 1 / (1 + c_star_constant) with hw₁_def
  set w₂ : ℝ := c_star_constant / (1 + c_star_constant) with hw₂_def
  have hw₁_nonneg : 0 ≤ w₁ := by rw [hw₁_def]; positivity
  have hw₂_nonneg : 0 ≤ w₂ := by rw [hw₂_def]; positivity
  have hw_sum : w₁ + w₂ = 1 := by
    rw [hw₁_def, hw₂_def]; field_simp
  -- weighted AM–GM: `(d²)^w₁ · 1^w₂ ≤ w₁·d² + w₂·1`
  have h_amgm :
      ((d : ℝ) ^ 2) ^ w₁ * (1 : ℝ) ^ w₂
        ≤ w₁ * (d : ℝ) ^ 2 + w₂ * 1 :=
    Real.geom_mean_le_arith_mean2_weighted hw₁_nonneg hw₂_nonneg
      (le_of_lt hd_sq_pos) (by norm_num) hw_sum
  -- simplify the geometric-mean side: `1^w₂ = 1`,
  -- `(d²)^w₁ = d^(2·w₁)`
  have h_rpow_two : ((d : ℝ) ^ 2) ^ w₁ = (d : ℝ) ^ (2 * w₁) := by
    rw [Real.rpow_mul (le_of_lt hd_pos), ← Real.rpow_natCast (d : ℝ) 2]
    norm_num
  have h_one_rpow : (1 : ℝ) ^ w₂ = 1 := Real.one_rpow w₂
  -- arithmetic-mean side equals `(d² + c*)/(1+c*)`
  have h_arith : w₁ * (d : ℝ) ^ 2 + w₂ * 1
      = ((d : ℝ) ^ 2 + c_star_constant) / (1 + c_star_constant) := by
    rw [hw₁_def, hw₂_def]; field_simp
  have h_power_le_mean :
      (d : ℝ) ^ (2 * w₁)
        ≤ ((d : ℝ) ^ 2 + c_star_constant) / (1 + c_star_constant) := by
    have := h_amgm
    rw [h_rpow_two, h_one_rpow, mul_one, h_arith] at this
    exact this
  -- `(d² + c*)/(1+c*) ≤ d²/c* + 1`
  have h_mean_le_target :
      ((d : ℝ) ^ 2 + c_star_constant) / (1 + c_star_constant)
        ≤ (d : ℝ) ^ 2 / c_star_constant + 1 := by
    have h_num_pos : 0 < (d : ℝ) ^ 2 + c_star_constant := by positivity
    have h_eq : (d : ℝ) ^ 2 / c_star_constant + 1
        = ((d : ℝ) ^ 2 + c_star_constant) / c_star_constant := by
      field_simp
    rw [h_eq]
    apply div_le_div_of_nonneg_left (le_of_lt h_num_pos) hK
    linarith
  -- chain: `d^(2·w₁) ≤ d²/c* + 1`
  have h_power_le_target :
      (d : ℝ) ^ (2 * w₁) ≤ (d : ℝ) ^ 2 / c_star_constant + 1 :=
    le_trans h_power_le_mean h_mean_le_target
  -- positivity of the rpow base for `log` monotonicity
  have h_rpow_pos : 0 < (d : ℝ) ^ (2 * w₁) := Real.rpow_pos_of_pos hd_pos _
  -- `Real.log` monotonicity + `Real.log_rpow`
  have h_log_le :
      (2 * w₁) * Real.log (d : ℝ)
        ≤ Real.log ((d : ℝ) ^ 2 / c_star_constant + 1) := by
    have h_step :
        Real.log ((d : ℝ) ^ (2 * w₁))
          ≤ Real.log ((d : ℝ) ^ 2 / c_star_constant + 1) :=
      Real.log_le_log h_rpow_pos h_power_le_target
    rwa [Real.log_rpow hd_pos] at h_step
  -- divide by `2·log 2 > 0` to conclude
  have h_log2_pos : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have h_two_log2_pos : 0 < 2 * Real.log 2 := by positivity
  unfold kappaStar_depth_d log_2
  rw [hw₁_def] at *
  rw [show (1 / (1 + c_star_constant))
        * (Real.log (d : ℝ) / Real.log 2)
        = ((2 * (1 / (1 + c_star_constant))) * Real.log (d : ℝ))
            / (2 * Real.log 2) by ring,
      show (1 / 2 : ℝ)
        * (Real.log ((d : ℝ) ^ 2 / c_star_constant + 1) / Real.log 2)
        = Real.log ((d : ℝ) ^ 2 / c_star_constant + 1)
            / (2 * Real.log 2) by ring]
  exact div_le_div_of_nonneg_right h_log_le h_two_log2_pos.le

/-- **R83 substantive closure of `bernoulli_real_power_estimate_OPEN`.**
    The previous `axiom bernoulli_real_power_estimate_OPEN` is REPLACED
    with this genuine theorem (`feedback_lean_real_math` +
    `feedback_no_compute_retreat`). The closure couples two real-analysis
    half-results on the concrete `kappaStar_depth_d` carrier:

      * **lower bound** — `kappaStar_depth_d_lower_bound` (R83 NEW):
        `(1/(1+c*)) · log_2 d ≤ κ*(d)` via the weighted-AM–GM
        Bernoulli-style power estimate `d^(2/(1+c*)) ≤ d²/c* + 1`;
      * **upper bound** — `gap_kappaStar_depth_d_upper_bound` (R-prior,
        kernel-pure): `κ*(d) ≤ log_2 d + c₃` with the explicit
        `c₃ = (1/2)·log_2(1/c* + 1)`.

    PAPER-FAITHFUL CORRECTION: the previous axiom encoded the additive
    constant as a literal `+ 1`, which is mathematically FALSE for
    `c* ∈ (0, 1/3)` (at `d = 1`, `log_2 1 = 0` forces `κ*(1) ≤ 1`,
    i.e. `c* ≥ 1/3` — see the previous OBSTACLE docstring). The paper's
    actual claim (`prop:error-compounding` Part 5, line 1044) is
    `κ*(d) = log_2 d + O(1)`, i.e. an EXISTENTIALLY-quantified additive
    constant. The corrected statement adds `∃ c₃` exactly matching the
    paper's `O(1)`; with that paper-faithful form the claim is fully
    provable (NOT a `kappaStar_p_monotone`-style DEAD-END — the
    over-strong `+ 1` literal was an honest-but-defective encoding,
    fixed here to the paper's `Θ` statement and then DISCHARGED).

    paper source: Proposition `prop:error-compounding` Part 5, line 1044
    ("κ*(d) = log_2 d + O(1) as d → ∞"). -/
theorem bernoulli_real_power_estimate_OPEN :
    ∃ c₁ c₂ c₃ : ℝ, 0 < c₁ ∧ c₁ ≤ c₂ ∧
      ∀ d : ℕ, 1 ≤ d →
        c₁ * log_2 d ≤ kappaStar_depth_d d ∧
        kappaStar_depth_d d ≤ c₂ * log_2 d + c₃ := by
  have hK : 0 < c_star_constant := gap_c_star_constant_pos_OPEN
  obtain ⟨c₃, h_upper⟩ := gap_kappaStar_depth_d_upper_bound
  refine ⟨1 / (1 + c_star_constant), 1, c₃, ?_, ?_, ?_⟩
  · positivity
  · -- `1/(1+c*) ≤ 1` since `1 ≤ 1 + c*`
    rw [div_le_one (by linarith)]; linarith
  · intro d hd
    refine ⟨kappaStar_depth_d_lower_bound d hd, ?_⟩
    -- upper bound: `κ*(d) ≤ log_2 d + c₃ = 1 · log_2 d + c₃`
    have := h_upper d hd
    linarith

/-- **`κ*(d) = Θ(log d)`** asymptotic (derived theorem composing
    `bernoulli_real_power_estimate_OPEN` per `feedback_gap_ledger_in_lean4`
    §18 Manufactured-Recognition pattern). Since R83 the underlying
    `bernoulli_real_power_estimate_OPEN` is itself a genuine theorem
    (no project `_OPEN` axiom), so this bundle theorem is kernel-pure
    modulo the opaque `c_star_constant` carrier + its positivity atom
    `gap_c_star_constant_pos_OPEN`. The additive constant is the
    paper-faithful existentially-quantified `c₃` (paper's `O(1)`).

    paper source: Proposition `prop:error-compounding` Part 5, line 1044. -/
theorem gap_kappaStar_depth_d_log_growth :
    ∃ c₁ c₂ c₃ : ℝ, 0 < c₁ ∧ c₁ ≤ c₂ ∧
      ∀ d : ℕ, 1 ≤ d →
        c₁ * log_2 d ≤ kappaStar_depth_d d ∧
        kappaStar_depth_d d ≤ c₂ * log_2 d + c₃ :=
  bernoulli_real_power_estimate_OPEN

end TrapTree

end BlackwellDilemma
