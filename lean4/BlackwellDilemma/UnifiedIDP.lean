/-
  BlackwellDilemma/UnifiedIDP.lean

  One semantic kernel for the Irreversibility Decision Problem.

  Decision nodes carry a local score used by a misspecified policy. Terminal
  nodes carry social welfare. Every agent, including the oracle, uses the same
  open graph, no-revisit history, and stopping rule. This removes the mismatch
  between mandatory traversal and an oracle that could select an arbitrary
  reachable intermediate vertex.
-/

import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Combinatorics.SimpleGraph.Connectivity.Connected
import Mathlib.Data.Finset.Max
import Mathlib.Data.Real.Basic

namespace BlackwellDilemma

universe u v

/-- A realized finite IDP. `openGraph` is the percolation realization and is
    required to be a subgraph of `baseGraph`. -/
structure IDPModel (V : Type u) [Fintype V] [DecidableEq V] where
  baseGraph : SimpleGraph V
  openGraph : SimpleGraph V
  open_le_base : openGraph <= baseGraph
  terminal : Finset V
  localScore : V -> Real
  welfare : V -> Real

/-- The finite ex-ante carrier in Definition 5 of the current paper.  Each
    feasibility realization owns one realized `IDPModel`; `weight` is the
    paper's probability distribution over the finite realization type and
    `initialVertex` is the common root. -/
structure FiniteExAnteIDP
    (V : Type u) [Fintype V] [DecidableEq V]
    (Omega : Type v) [Fintype Omega] where
  weight : Omega -> Real
  weight_nonneg : forall omega, 0 <= weight omega
  weight_sum_one : Finset.univ.sum weight = 1
  baseGraph : SimpleGraph V
  feasibleGraph : Omega -> SimpleGraph V
  feasible_le_base : forall omega, feasibleGraph omega <= baseGraph
  terminal : Finset V
  localScore : V -> Real
  welfare : V -> Real
  initialVertex : V

/-- Process state. `history` contains vertices visited before `current`. -/
structure IDPState (V : Type u) [DecidableEq V] where
  current : V
  history : Finset V
  current_fresh : current ∉ history

namespace IDPState

variable {V : Type u} [DecidableEq V]

/-- Initial state at `v0`. -/
def initial (v0 : V) : IDPState V where
  current := v0
  history := ∅
  current_fresh := by simp

end IDPState

namespace FiniteExAnteIDP

variable {V : Type u} [Fintype V] [DecidableEq V]
variable {Omega : Type v} [Fintype Omega]

/-- The process starts from `(v0, empty)` in every realization. -/
def initialState (X : FiniteExAnteIDP V Omega) (_omega : Omega) : IDPState V :=
  IDPState.initial X.initialVertex

/-- Only the feasible subgraph varies with `omega`; the base graph, terminal
    set, local score, welfare function, and initial vertex are common. -/
def realized (X : FiniteExAnteIDP V Omega) (omega : Omega) : IDPModel V where
  baseGraph := X.baseGraph
  openGraph := X.feasibleGraph omega
  open_le_base := X.feasible_le_base omega
  terminal := X.terminal
  localScore := X.localScore
  welfare := X.welfare

end FiniteExAnteIDP

namespace IDPModel

variable {V : Type u} [Fintype V] [DecidableEq V]

/-- One feasible IDP transition. Designated terminal vertices cannot move;
    every move follows an open edge and appends the old current vertex to the
    no-revisit history. -/
def Step (M : IDPModel V) (s t : IDPState V) : Prop :=
  s.current ∉ M.terminal ∧
    M.openGraph.Adj s.current t.current ∧
    t.current ∉ s.history ∧
    t.history = insert s.current s.history

/-- A process stops at a designated terminal or when no feasible move exists. -/
def IsStopping (M : IDPModel V) (s : IDPState V) : Prop :=
  s.current ∈ M.terminal ∨ ¬ ∃ t : IDPState V, M.Step s t

/-- Reachability uses exactly the transition relation available to every
    policy and to the oracle. -/
def Reaches (M : IDPModel V) (s t : IDPState V) : Prop :=
  Relation.ReflTransGen M.Step s t

/-- Vertices physically reachable in the realized open graph, without the
    stopping restriction imposed by the dynamic process. -/
noncomputable def relaxedReachableVertices (M : IDPModel V) (s : IDPState V) :
    Finset V := by
  classical
  exact Finset.univ.filter fun v => M.openGraph.Reachable s.current v

theorem mem_relaxedReachableVertices_iff (M : IDPModel V) (s : IDPState V)
    (v : V) :
    v ∈ M.relaxedReachableVertices s ↔
      M.openGraph.Reachable s.current v := by
  classical
  simp [relaxedReachableVertices]

theorem relaxedReachableVertices_nonempty (M : IDPModel V) (s : IDPState V) :
    (M.relaxedReachableVertices s).Nonempty := by
  exact ⟨s.current, (M.mem_relaxedReachableVertices_iff s s.current).2
    (SimpleGraph.Reachable.refl s.current)⟩

/-- Welfare values in the relaxed physical reachability set. -/
noncomputable def relaxedReachableWelfareValues
    (M : IDPModel V) (s : IDPState V) : Finset Real := by
  classical
  exact (M.relaxedReachableVertices s).image M.welfare

theorem relaxedReachableWelfareValues_nonempty
    (M : IDPModel V) (s : IDPState V) :
    (M.relaxedReachableWelfareValues s).Nonempty := by
  classical
  exact (M.relaxedReachableVertices_nonempty s).image M.welfare

/-- Physical reachability benchmark used by the relaxed decomposition. -/
noncomputable def relaxedOracleValue (M : IDPModel V) (s : IDPState V) : Real :=
  (M.relaxedReachableWelfareValues s).max'
    (M.relaxedReachableWelfareValues_nonempty s)

/-- All welfare values in a nonempty finite IDP. -/
noncomputable def globalWelfareValues
    (M : IDPModel V) [Nonempty V] : Finset Real := by
  classical
  exact Finset.univ.image M.welfare

theorem globalWelfareValues_nonempty (M : IDPModel V) [Nonempty V] :
    M.globalWelfareValues.Nonempty := by
  classical
  exact Finset.univ_nonempty.image M.welfare

/-- Global welfare maximum `r*`. -/
noncomputable def globalValue (M : IDPModel V) [Nonempty V] : Real :=
  M.globalWelfareValues.max' M.globalWelfareValues_nonempty

/-- Zero blocking means that every base edge is open. It does not remove the
    independent no-revisit history rule. -/
def NoBlocking (M : IDPModel V) : Prop :=
  M.openGraph = M.baseGraph

theorem step_open_edge_is_base_edge (M : IDPModel V) {s t : IDPState V}
    (h : M.Step s t) : M.baseGraph.Adj s.current t.current :=
  M.open_le_base h.2.1

theorem terminal_has_no_step (M : IDPModel V) {s t : IDPState V}
    (hterminal : s.current ∈ M.terminal) : ¬ M.Step s t := by
  intro h
  exact h.1 hterminal

theorem step_history (M : IDPModel V) {s t : IDPState V}
    (h : M.Step s t) : t.history = insert s.current s.history :=
  h.2.2.2

/-- Every dynamically feasible trajectory is physically reachable in the
    realized open graph. -/
theorem reaches_openGraph_reachable (M : IDPModel V) {s t : IDPState V}
    (h : M.Reaches s t) : M.openGraph.Reachable s.current t.current := by
  apply (M.openGraph.reachable_iff_reflTransGen s.current t.current).2
  induction h with
  | refl => exact Relation.ReflTransGen.refl
  | tail hreach hstep ih =>
      exact Relation.ReflTransGen.tail ih hstep.2.1

theorem reaches_welfare_le_relaxedOracle (M : IDPModel V)
    {s t : IDPState V} (hreach : M.Reaches s t) :
    M.welfare t.current <= M.relaxedOracleValue s := by
  classical
  have hvertex : t.current ∈ M.relaxedReachableVertices s :=
    (M.mem_relaxedReachableVertices_iff s t.current).2
      (M.reaches_openGraph_reachable hreach)
  have hvalue : M.welfare t.current ∈ M.relaxedReachableWelfareValues s := by
    exact Finset.mem_image.mpr ⟨t.current, hvertex, rfl⟩
  exact (M.relaxedReachableWelfareValues s).le_max' _ hvalue

theorem relaxedOracleValue_attained (M : IDPModel V) (s : IDPState V) :
    exists v : V,
      M.openGraph.Reachable s.current v /\
        M.welfare v = M.relaxedOracleValue s := by
  classical
  have hmax : M.relaxedOracleValue s ∈ M.relaxedReachableWelfareValues s := by
    exact Finset.max'_mem _ _
  rcases Finset.mem_image.mp hmax with ⟨v, hv, hvalue⟩
  exact ⟨v, (M.mem_relaxedReachableVertices_iff s v).1 hv, hvalue⟩

theorem welfare_le_globalValue (M : IDPModel V) [Nonempty V] (v : V) :
    M.welfare v <= M.globalValue := by
  classical
  have hvalue : M.welfare v ∈ M.globalWelfareValues := by
    exact Finset.mem_image.mpr ⟨v, Finset.mem_univ v, rfl⟩
  exact M.globalWelfareValues.le_max' _ hvalue

theorem relaxedOracleValue_le_globalValue
    (M : IDPModel V) [Nonempty V] (s : IDPState V) :
    M.relaxedOracleValue s <= M.globalValue := by
  rcases M.relaxedOracleValue_attained s with ⟨v, _hreach, hvalue⟩
  rw [← hvalue]
  exact M.welfare_le_globalValue v

theorem step_records_departed_vertex (M : IDPModel V) {s t : IDPState V}
    (h : M.Step s t) : s.current ∈ t.history := by
  rw [M.step_history h]
  simp

theorem step_history_card (M : IDPModel V) {s t : IDPState V}
    (h : M.Step s t) : t.history.card = s.history.card + 1 := by
  rw [M.step_history h, Finset.card_insert_of_notMem s.current_fresh]

/-- Immediate return is impossible after a transition. -/
theorem no_immediate_return (M : IDPModel V) {s t u : IDPState V}
    (hst : M.Step s t) (htu : M.Step t u) : u.current ≠ s.current := by
  intro hreturn
  have hrecorded : s.current ∈ t.history := M.step_records_departed_vertex hst
  have hunvisited : u.current ∉ t.history := htu.2.2.1
  exact hunvisited (by simpa [hreturn] using hrecorded)

/-- Even in the no-blocking boundary model, no-revisit history still prevents
    immediate reversal. Thus `p = 0` removes random edge loss, not endogenous
    path dependence. -/
theorem no_revisit_persists_under_noBlocking (M : IDPModel V)
    {s t u : IDPState V} (_hNoBlocking : M.NoBlocking)
    (hst : M.Step s t) (htu : M.Step t u) : u.current ≠ s.current :=
  M.no_immediate_return hst htu

/-- Number of vertices not yet recorded in the history. This strictly falls
    after each transition. -/
def remainingMoves (_M : IDPModel V) (s : IDPState V) : Nat :=
  Fintype.card V - s.history.card

theorem history_card_lt_univ (s : IDPState V) :
    s.history.card < Fintype.card V := by
  rw [← Finset.card_univ]
  apply Finset.card_lt_card
  rw [Finset.ssubset_iff_subset_ne]
  refine ⟨by simp, ?_⟩
  intro heq
  have : s.current ∈ s.history := by
    rw [heq]
    simp
  exact s.current_fresh this

theorem step_remainingMoves_lt (M : IDPModel V) {s t : IDPState V}
    (h : M.Step s t) : M.remainingMoves t < M.remainingMoves s := by
  unfold remainingMoves
  rw [M.step_history_card h]
  have hs : s.history.card < Fintype.card V := history_card_lt_univ s
  omega

/-- Every finite no-revisit process reaches a stopping state. -/
theorem exists_stopping_reachable (M : IDPModel V) (s : IDPState V) :
    ∃ t : IDPState V, M.Reaches s t ∧ M.IsStopping t := by
  classical
  induction hmeasure : M.remainingMoves s using Nat.strong_induction_on generalizing s with
  | h n ih =>
      by_cases hstop : M.IsStopping s
      · exact ⟨s, Relation.ReflTransGen.refl, hstop⟩
      · have hstep : ∃ t : IDPState V, M.Step s t := by
          by_contra hnone
          exact hstop (Or.inr hnone)
        rcases hstep with ⟨t, hst⟩
        have hdecrease : M.remainingMoves t < n := by
          rw [← hmeasure]
          exact M.step_remainingMoves_lt hst
        rcases ih (M.remainingMoves t) hdecrease t rfl with
          ⟨u, hreach, hustop⟩
        exact ⟨u, Relation.ReflTransGen.head hst hreach, hustop⟩

/-- Terminal vertices attainable from `s` under the common transition and
    stopping rules. -/
noncomputable def attainableStops (M : IDPModel V) (s : IDPState V) :
    Finset V := by
  classical
  exact Finset.univ.filter fun v =>
    ∃ t : IDPState V, M.Reaches s t ∧ M.IsStopping t ∧ t.current = v

theorem mem_attainableStops_iff (M : IDPModel V) (s : IDPState V) (v : V) :
    v ∈ M.attainableStops s ↔
      ∃ t : IDPState V, M.Reaches s t ∧ M.IsStopping t ∧ t.current = v := by
  classical
  simp [attainableStops]

theorem attainableStops_nonempty (M : IDPModel V) (s : IDPState V) :
    (M.attainableStops s).Nonempty := by
  rcases M.exists_stopping_reachable s with ⟨t, hreach, hstop⟩
  exact ⟨t.current, (M.mem_attainableStops_iff s t.current).2
    ⟨t, hreach, hstop, rfl⟩⟩

/-- Welfare values attainable at process stopping states. -/
noncomputable def attainableWelfareValues (M : IDPModel V) (s : IDPState V) :
    Finset Real := by
  classical
  exact (M.attainableStops s).image M.welfare

theorem attainableWelfareValues_nonempty (M : IDPModel V) (s : IDPState V) :
    (M.attainableWelfareValues s).Nonempty := by
  classical
  exact (M.attainableStops_nonempty s).image M.welfare

/-- The oracle benchmark is the maximum welfare among outcomes attainable by
    the same IDP transition and stopping rules as every other policy. -/
noncomputable def oracleValue (M : IDPModel V) (s : IDPState V) : Real :=
  (M.attainableWelfareValues s).max' (M.attainableWelfareValues_nonempty s)

theorem stopping_welfare_le_oracle (M : IDPModel V) {s t : IDPState V}
    (hreach : M.Reaches s t) (hstop : M.IsStopping t) :
    M.welfare t.current ≤ M.oracleValue s := by
  classical
  have houtcome : t.current ∈ M.attainableStops s :=
    (M.mem_attainableStops_iff s t.current).2 ⟨t, hreach, hstop, rfl⟩
  have hvalue : M.welfare t.current ∈ M.attainableWelfareValues s := by
    exact Finset.mem_image.mpr ⟨t.current, houtcome, rfl⟩
  exact (M.attainableWelfareValues s).le_max' _ hvalue

/-- Tightness is constructive at the semantic level: a stopping state that
    attains the oracle value is connected to `s` by the common feasible-step
    relation. -/
theorem oracle_value_attainable (M : IDPModel V) (s : IDPState V) :
    ∃ t : IDPState V,
      M.Reaches s t ∧ M.IsStopping t ∧ M.welfare t.current = M.oracleValue s := by
  classical
  have hmax : M.oracleValue s ∈ M.attainableWelfareValues s := by
    exact Finset.max'_mem _ _
  rcases Finset.mem_image.mp hmax with ⟨v, hv, hvmax⟩
  rcases (M.mem_attainableStops_iff s v).1 hv with
    ⟨t, hreach, hstop, htcurrent⟩
  refine ⟨t, hreach, hstop, ?_⟩
  rw [htcurrent]
  exact hvmax

/-- The strategy-aligned oracle cannot exceed the relaxed physical
    reachability benchmark. -/
theorem oracleValue_le_relaxedOracleValue (M : IDPModel V) (s : IDPState V) :
    M.oracleValue s <= M.relaxedOracleValue s := by
  rcases M.oracle_value_attainable s with ⟨t, hreach, _hstop, hvalue⟩
  rw [← hvalue]
  exact M.reaches_welfare_le_relaxedOracle hreach

/-- If the relaxed maximizer is itself an attainable stopping outcome, the
    relaxed and dynamic oracle values coincide. -/
theorem oracleValue_eq_relaxedOracleValue_of_attainable
    (M : IDPModel V) (s : IDPState V)
    (hterminalComplete : exists t : IDPState V,
      M.Reaches s t /\ M.IsStopping t /\
        M.welfare t.current = M.relaxedOracleValue s) :
    M.oracleValue s = M.relaxedOracleValue s := by
  rcases hterminalComplete with ⟨t, hreach, hstop, hvalue⟩
  apply le_antisymm (M.oracleValue_le_relaxedOracleValue s)
  rw [← hvalue]
  exact M.stopping_welfare_le_oracle hreach hstop

theorem oracleValue_eq_relaxedOracleValue_iff_terminalComplete
    (M : IDPModel V) (s : IDPState V) :
    M.oracleValue s = M.relaxedOracleValue s ↔
      exists t : IDPState V,
        M.Reaches s t /\ M.IsStopping t /\
          M.welfare t.current = M.relaxedOracleValue s := by
  constructor
  · intro hEqual
    rcases M.oracle_value_attainable s with ⟨t, hreach, hstop, hvalue⟩
    exact ⟨t, hreach, hstop, hvalue.trans hEqual⟩
  · exact M.oracleValue_eq_relaxedOracleValue_of_attainable s

end IDPModel

end BlackwellDilemma
