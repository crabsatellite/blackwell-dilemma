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
import Mathlib.Data.Finset.Max
import Mathlib.Data.Real.Basic

namespace BlackwellDilemma

universe u

/-- A realized finite IDP. `openGraph` is the percolation realization and is
    required to be a subgraph of `baseGraph`. -/
structure IDPModel (V : Type u) [Fintype V] [DecidableEq V] where
  baseGraph : SimpleGraph V
  openGraph : SimpleGraph V
  open_le_base : openGraph <= baseGraph
  terminal : Finset V
  localScore : V -> Real
  welfare : V -> Real

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

end IDPModel

end BlackwellDilemma
