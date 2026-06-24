/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

import Mathlib.Tactic

/-!
# Terminal-neighbour topology witness

This module isolates the graph-theoretic content of the paper's
terminal-neighbour topology from the project-global `Vertex`/`IsEdge` carrier.
The current global carrier is the complete loopless graph on `Fin 5`, where
`TerminalNeighbourTopology` is impossible.  The witness below proves that the
topology shape itself is nonempty: a three-vertex path already satisfies the
parameterized terminal-neighbour predicate.

No paper primitives or axioms are imported here.
-/

namespace BlackwellDilemma.Infrastructure

/-- A leaf is terminal relative to its parent if all of its neighbours are the
    parent. This is the graph-parameterized form of
    `BlackwellDilemma.IsTerminalNeighbourOf`. -/
def IsTerminalNeighbourOfOn {V : Type*} (adj : V -> V -> Prop)
    (parent leaf : V) : Prop :=
  forall w : V, adj leaf w -> w = parent

/-- A depth-one subtree root has no children except the parent and terminal
    leaves. This is the graph-parameterized form of
    `BlackwellDilemma.IsDepthOneSubtreeRootOf`. -/
def IsDepthOneSubtreeRootOfOn {V : Type*} (adj : V -> V -> Prop)
    (parent root : V) : Prop :=
  forall child : V,
    adj root child -> child = parent \/ IsTerminalNeighbourOfOn adj root child

/-- A graph has terminal-neighbour topology if some start vertex has only
    terminal neighbours or depth-one subtree roots. -/
def TerminalNeighbourTopologyOn {V : Type*} (adj : V -> V -> Prop) : Prop :=
  exists v0 : V,
    forall u : V, adj v0 u ->
      IsTerminalNeighbourOfOn adj v0 u \/ IsDepthOneSubtreeRootOfOn adj v0 u

/-- Parameterized same-witness degree-two neighbourhood condition. This is
    the graph-local analogue of `BlackwellDilemma.NeighbourhoodExhaustedByPair`
    without committing to the project-global complete-loopless carrier. -/
def NeighbourhoodExhaustedByPairOn {V : Type*} (adj : V -> V -> Prop)
    (v0 u1 u2 : V) : Prop :=
  u1 ≠ u2 ∧ adj v0 u1 ∧ adj v0 u2 ∧
    forall u : V, adj v0 u -> u = u1 \/ u = u2

/-- Parameterized degree-two starting-vertex condition. This is the graph-local
    analogue of `BlackwellDilemma.DegreeTwoStartingVertex`, factored through the
    explicit same-witness pair-exhaustion predicate above. -/
def DegreeTwoStartingVertexOn {V : Type*} (adj : V -> V -> Prop) : Prop :=
  exists v0 u1 u2 : V, NeighbourhoodExhaustedByPairOn adj v0 u1 u2

theorem degreeTwoStartingVertexOn_of_neighbourhoodExhaustedByPairOn
    {V : Type*} {adj : V -> V -> Prop} {v0 u1 u2 : V}
    (h : NeighbourhoodExhaustedByPairOn adj v0 u1 u2) :
    DegreeTwoStartingVertexOn adj := by
  exact ⟨v0, u1, u2, h⟩

/-- The three-vertex path `0 -- 1 -- 2`. -/
def fin3PathAdj : Fin 3 -> Fin 3 -> Prop
  | 0, 1 => True
  | 1, 0 => True
  | 1, 2 => True
  | 2, 1 => True
  | _, _ => False

theorem fin3PathAdj_symm {u v : Fin 3} :
    fin3PathAdj u v -> fin3PathAdj v u := by
  fin_cases u <;> fin_cases v <;> simp [fin3PathAdj]

theorem fin3PathAdj_loopless (u : Fin 3) :
    Not (fin3PathAdj u u) := by
  fin_cases u <;> simp [fin3PathAdj]

theorem fin3Path_leaf2_terminal :
    IsTerminalNeighbourOfOn fin3PathAdj (1 : Fin 3) 2 := by
  intro w hw
  fin_cases w
  · simp [fin3PathAdj] at hw
  · rfl
  · simp [fin3PathAdj] at hw

theorem fin3Path_root1_depthOne :
    IsDepthOneSubtreeRootOfOn fin3PathAdj (0 : Fin 3) 1 := by
  intro child hchild
  fin_cases child
  · exact Or.inl rfl
  · simp [fin3PathAdj] at hchild
  · exact Or.inr fin3Path_leaf2_terminal

/-- Non-vacuous kernel witness that the terminal-neighbour topology shape is
    inhabited by an explicit finite graph. The project-global carrier remains
    separate; this theorem is the migration target for a future graph-parametric
    version of the terminal-neighbour route. -/
theorem fin3Path_terminalNeighbourTopology :
    TerminalNeighbourTopologyOn fin3PathAdj := by
  refine ⟨0, ?_⟩
  intro u hu
  fin_cases u
  · simp [fin3PathAdj] at hu
  · exact Or.inr fin3Path_root1_depthOne
  · simp [fin3PathAdj] at hu

/-- Parameterized forward reachability with a no-revisit history, mirroring
    the project-global `ForwardReachable` carrier without committing to the
    current complete-loopless graph. -/
noncomputable def ForwardReachableOn {V : Type*} [Fintype V] [DecidableEq V]
    (adj : V -> V -> Prop) (u : V) (H : Finset V) : Finset V := by
  classical
  exact Finset.univ.filter fun w =>
    w = u \/ Relation.ReflTransGen
      (fun x y : V => x ∉ H ∧ y ∉ H ∧ adj x y) u w

/-- A reward-maximising child for a parameterized finite candidate set. -/
noncomputable def greedyRewardChildOn {V : Type*} (reward : V -> ℝ)
    (N : Finset V) (hN : N.Nonempty) : V :=
  Classical.choose (Finset.exists_max_image N reward hN)

theorem greedyRewardChildOn_mem {V : Type*} (reward : V -> ℝ)
    (N : Finset V) (hN : N.Nonempty) :
    greedyRewardChildOn reward N hN ∈ N :=
  (Classical.choose_spec (Finset.exists_max_image N reward hN)).1

/-- Parameterized version of the sufficient condition isolated in
    `BlackwellDilemma.GreedyChildTerminalAndSelfLe`. The candidate set is the
    whole forward-reachable set minus self, matching the current global greedy
    carrier. -/
def GreedyChildTerminalAndSelfLeOn {V : Type*} [Fintype V] [DecidableEq V]
    (adj : V -> V -> Prop) (reward : V -> ℝ) : Prop :=
  forall (u : V) (H : Finset V)
    (hN : ((ForwardReachableOn adj u H).erase u).Nonempty),
      let c : V := greedyRewardChildOn reward ((ForwardReachableOn adj u H).erase u) hN
      ForwardReachableOn adj c (insert u H) = {c} ∧ reward u ≤ reward c

/-- Candidate-set obstruction for the current greedy carrier: the non-vacuous
    three-vertex terminal-neighbour path does not satisfy the R274 sufficient
    condition when the greedy candidate set is the whole forward-reachable set
    minus self. This shows the remaining route needs a local-neighbour greedy
    carrier, or a stronger flat-one-step graph condition, not just the
    terminal-neighbour topology shape. -/
theorem not_fin3Path_GreedyChildTerminalAndSelfLeOn (reward : Fin 3 -> ℝ) :
    ¬ GreedyChildTerminalAndSelfLeOn fin3PathAdj reward := by
  intro h_flat
  classical
  let H0 : Finset (Fin 3) := ∅
  let N : Finset (Fin 3) := (ForwardReachableOn fin3PathAdj (0 : Fin 3) H0).erase 0
  have h01 :
      Relation.ReflTransGen
        (fun x y : Fin 3 => x ∉ H0 ∧ y ∉ H0 ∧ fin3PathAdj x y)
        (0 : Fin 3) 1 := by
    exact Relation.ReflTransGen.single (by simp [H0, fin3PathAdj])
  have h1FR : (1 : Fin 3) ∈ ForwardReachableOn fin3PathAdj (0 : Fin 3) H0 := by
    dsimp [ForwardReachableOn]
    exact Finset.mem_filter.mpr ⟨by simp, Or.inr h01⟩
  have hN : N.Nonempty := by
    refine ⟨1, ?_⟩
    exact Finset.mem_erase.mpr ⟨by norm_num, by simpa [N] using h1FR⟩
  let c : Fin 3 := greedyRewardChildOn reward N hN
  have hcN : c ∈ N := greedyRewardChildOn_mem reward N hN
  have hc_ne_zero : c ≠ (0 : Fin 3) :=
    (Finset.mem_erase.mp (by simpa [N, c] using hcN)).1
  have hc_cases : c = (1 : Fin 3) ∨ c = (2 : Fin 3) := by
    have hval : c.val = 0 ∨ c.val = 1 ∨ c.val = 2 := by
      omega
    rcases hval with h0 | h1 | h2
    · exact False.elim (hc_ne_zero (Fin.ext (by simpa using h0)))
    · exact Or.inl (Fin.ext (by simpa using h1))
    · exact Or.inr (Fin.ext (by simpa using h2))
  have h_flat_at :
      ForwardReachableOn fin3PathAdj c (insert (0 : Fin 3) H0) = {c} ∧
        reward (0 : Fin 3) ≤ reward c := by
    simpa [GreedyChildTerminalAndSelfLeOn, H0, N, c] using
      h_flat (0 : Fin 3) H0 hN
  have hterm := h_flat_at.1
  rcases hc_cases with hc_eq_one | hc_eq_two
  · rw [hc_eq_one] at hterm
    have h12 :
        Relation.ReflTransGen
          (fun x y : Fin 3 =>
            x ∉ insert (0 : Fin 3) H0 ∧
              y ∉ insert (0 : Fin 3) H0 ∧ fin3PathAdj x y)
          (1 : Fin 3) 2 := by
      exact Relation.ReflTransGen.single (by simp [H0, fin3PathAdj])
    have h2FR :
        (2 : Fin 3) ∈
          ForwardReachableOn fin3PathAdj (1 : Fin 3) (insert (0 : Fin 3) H0) := by
      dsimp [ForwardReachableOn]
      exact Finset.mem_filter.mpr ⟨by simp, Or.inr h12⟩
    have h2single : (2 : Fin 3) ∈ ({(1 : Fin 3)} : Finset (Fin 3)) := by
      rw [← hterm]
      exact h2FR
    simp at h2single
  · rw [hc_eq_two] at hterm
    have h21 :
        Relation.ReflTransGen
          (fun x y : Fin 3 =>
            x ∉ insert (0 : Fin 3) H0 ∧
              y ∉ insert (0 : Fin 3) H0 ∧ fin3PathAdj x y)
          (2 : Fin 3) 1 := by
      exact Relation.ReflTransGen.single (by simp [H0, fin3PathAdj])
    have h1FR' :
        (1 : Fin 3) ∈
          ForwardReachableOn fin3PathAdj (2 : Fin 3) (insert (0 : Fin 3) H0) := by
      dsimp [ForwardReachableOn]
      exact Finset.mem_filter.mpr ⟨by simp, Or.inr h21⟩
    have h1single : (1 : Fin 3) ∈ ({(2 : Fin 3)} : Finset (Fin 3)) := by
      rw [← hterm]
      exact h1FR'
    simp at h1single

/-- Immediate non-self unvisited neighbours for a parameterized graph. This is
    the local candidate-set carrier matching the paper's greedy-path phrase
    "children with open edges", in contrast to `ForwardReachableOn`, which
    contains every vertex reachable by a path. -/
noncomputable def NeighbourSetOn {V : Type*} [Fintype V] [DecidableEq V]
    (adj : V -> V -> Prop) (u : V) (H : Finset V) : Finset V := by
  classical
  exact Finset.univ.filter fun v => v ≠ u ∧ u ∉ H ∧ v ∉ H ∧ adj u v

theorem NeighbourSetOn_mem_ForwardReachableOn_erase {V : Type*}
    [Fintype V] [DecidableEq V] {adj : V -> V -> Prop}
    {u v : V} {H : Finset V}
    (hv : v ∈ NeighbourSetOn adj u H) :
    v ∈ (ForwardReachableOn adj u H).erase u := by
  classical
  unfold NeighbourSetOn at hv
  simp only [Finset.mem_filter, Finset.mem_univ, true_and] at hv
  rcases hv with ⟨hvu, huH, hvH, huv⟩
  refine Finset.mem_erase.mpr ⟨hvu, ?_⟩
  dsimp [ForwardReachableOn]
  exact Finset.mem_filter.mpr
    ⟨by simp, Or.inr (Relation.ReflTransGen.single ⟨huH, hvH, huv⟩)⟩

theorem ForwardReachableOn_trans_from_erase {V : Type*}
    [Fintype V] [DecidableEq V] {adj : V -> V -> Prop}
    {u c w : V} {H : Finset V}
    (hc : c ∈ (ForwardReachableOn adj u H).erase u)
    (hw : w ∈ ForwardReachableOn adj c (insert u H)) :
    w ∈ ForwardReachableOn adj u H := by
  classical
  have hc_mem : c ∈ ForwardReachableOn adj u H := (Finset.mem_erase.mp hc).2
  have hc_ne : c ≠ u := (Finset.mem_erase.mp hc).1
  unfold ForwardReachableOn at hc_mem hw ⊢
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
            (fun x y : V => x ∉ H ∧ y ∉ H ∧ adj x y) c w := by
        exact hw_path.mono fun x y hxy => by
          rcases hxy with ⟨hx, hy, hxy_adj⟩
          exact
            ⟨(by
                intro hxH
                exact hx (Finset.mem_insert_of_mem hxH)),
              (by
                intro hyH
                exact hy (Finset.mem_insert_of_mem hyH)),
              hxy_adj⟩
      exact Relation.ReflTransGen.trans hc_path hw_path'

/-- Parameterized candidate-locality bridge: the all-forward-reachable
    non-self candidate set agrees with the immediate-neighbour candidate set
    at every state. This is the graph-parameterized analogue of
    `BlackwellDilemma.ForwardReachableCandidatesAreLocal`. -/
def ForwardReachableCandidatesAreLocalOn {V : Type*} [Fintype V]
    [DecidableEq V] (adj : V -> V -> Prop) : Prop :=
  forall (u : V) (H : Finset V),
    (ForwardReachableOn adj u H).erase u = NeighbourSetOn adj u H

/-- The three-vertex terminal-neighbour path refutes the all-forward-reachable
    to immediate-neighbour candidate-locality bridge: from `0`, vertex `2` is
    forward-reachable by the path `0 -- 1 -- 2`, but it is not an immediate
    neighbour of `0`. -/
theorem not_fin3Path_ForwardReachableCandidatesAreLocalOn :
    Not (ForwardReachableCandidatesAreLocalOn fin3PathAdj) := by
  intro hlocal
  classical
  let H0 : Finset (Fin 3) := ∅
  have hEq := hlocal (0 : Fin 3) H0
  have h01 :
      (fun x y : Fin 3 => x ∉ H0 ∧ y ∉ H0 ∧ fin3PathAdj x y)
        (0 : Fin 3) 1 := by
    simp [H0, fin3PathAdj]
  have h12 :
      (fun x y : Fin 3 => x ∉ H0 ∧ y ∉ H0 ∧ fin3PathAdj x y)
        (1 : Fin 3) 2 := by
    simp [H0, fin3PathAdj]
  have h02 :
      Relation.ReflTransGen
        (fun x y : Fin 3 => x ∉ H0 ∧ y ∉ H0 ∧ fin3PathAdj x y)
        (0 : Fin 3) 2 := by
    exact Relation.ReflTransGen.trans
      (Relation.ReflTransGen.single h01)
      (Relation.ReflTransGen.single h12)
  have h2FR :
      (2 : Fin 3) ∈ (ForwardReachableOn fin3PathAdj (0 : Fin 3) H0).erase 0 := by
    refine Finset.mem_erase.mpr ?_
    constructor
    · decide
    · dsimp [ForwardReachableOn]
      exact Finset.mem_filter.mpr ⟨by simp, Or.inr h02⟩
  have h2Local : (2 : Fin 3) ∈ NeighbourSetOn fin3PathAdj (0 : Fin 3) H0 := by
    simpa [hEq] using h2FR
  simp [NeighbourSetOn, H0, fin3PathAdj] at h2Local

theorem greedyRewardChildOn_singleton {V : Type*} [DecidableEq V]
    (reward : V -> ℝ) (a : V) (hN : ({a} : Finset V).Nonempty) :
    greedyRewardChildOn reward ({a} : Finset V) hN = a := by
  have hmem := greedyRewardChildOn_mem reward ({a} : Finset V) hN
  simpa using hmem

/-- Fuel-bounded local-neighbour greedy traversal. The fuel parameter keeps
    this migration carrier structurally total while the project decides how to
    replace the current all-forward-reachable greedy recursion. -/
noncomputable def localGreedyPathValueFuelOn {V : Type*}
    [Fintype V] [DecidableEq V] (adj : V -> V -> Prop) (reward : V -> ℝ) :
    ℕ -> V -> Finset V -> ℝ
  | 0, u, _H => reward u
  | fuel + 1, u, H =>
      let N : Finset V := NeighbourSetOn adj u H
      if hN : N.Nonempty then
        localGreedyPathValueFuelOn adj reward fuel
          (greedyRewardChildOn reward N hN) (insert u H)
      else
        reward u

/-- Local-neighbour greedy value with enough fuel for a finite simple path
    without introducing a new well-founded recursion into this migration
    module. -/
noncomputable def localGreedyPathValueOn {V : Type*}
    [Fintype V] [DecidableEq V] (adj : V -> V -> Prop)
    (reward : V -> ℝ) (u : V) (H : Finset V) : ℝ :=
  localGreedyPathValueFuelOn adj reward (Fintype.card V + 1) u H

/-- Parameterized concrete local-C2prime witness carrier. It packages the
    same-witness degree-two neighbourhood with the local-neighbour greedy
    value reversal that R288/R290 use on the project-global carrier. -/
abbrev LocalC2primeFullWitnessOn {V : Type*} [Fintype V] [DecidableEq V]
    (adj : V -> V -> Prop) (reward : V -> ℝ) : Prop :=
  exists (v0 u_high u_low : V) (H : Finset V),
    NeighbourhoodExhaustedByPairOn adj v0 u_high u_low ∧
      reward u_low < reward u_high ∧
      localGreedyPathValueOn adj reward u_high H <
        localGreedyPathValueOn adj reward u_low H

/-- Graph-local welfare proxy for the C2prime witness pair. At zero precision
    the proxy follows the lower-immediate-reward branch, while at positive
    precision it follows the higher-immediate-reward local-greedy branch. This
    is deliberately local to the explicit graph carrier and does not use the
    project-global scalar `agentWelfare`. -/
noncomputable def localGreedySignalWelfareOn {V : Type*}
    [Fintype V] [DecidableEq V] (adj : V -> V -> Prop)
    (reward : V -> ℝ) (u_high u_low : V) (H : Finset V)
    (β : ℝ) : ℝ :=
  if β <= 0 then
    localGreedyPathValueOn adj reward u_low H
  else
    localGreedyPathValueOn adj reward u_high H

def LocalGreedyWelfareReversalOn {V : Type*} [Fintype V] [DecidableEq V]
    (adj : V -> V -> Prop) (reward : V -> ℝ) : Prop :=
  exists (v0 u_high u_low : V) (H : Finset V),
    NeighbourhoodExhaustedByPairOn adj v0 u_high u_low ∧
      reward u_low < reward u_high ∧
      localGreedySignalWelfareOn adj reward u_high u_low H 1 <
        localGreedySignalWelfareOn adj reward u_high u_low H 0

theorem localGreedySignalWelfareOn_reversal_of_path_reversal
    {V : Type*} [Fintype V] [DecidableEq V]
    (adj : V -> V -> Prop) (reward : V -> ℝ)
    {u_high u_low : V} {H : Finset V}
    (h_path :
      localGreedyPathValueOn adj reward u_high H <
        localGreedyPathValueOn adj reward u_low H) :
    localGreedySignalWelfareOn adj reward u_high u_low H 1 <
      localGreedySignalWelfareOn adj reward u_high u_low H 0 := by
  have h_one : ¬ ((1 : ℝ) <= 0) := by norm_num
  have h_zero : (0 : ℝ) <= 0 := by norm_num
  simpa [localGreedySignalWelfareOn, h_one, h_zero] using h_path

theorem ForwardReachableOn_self_mem {V : Type*} [Fintype V] [DecidableEq V]
    (adj : V -> V -> Prop) (u : V) (H : Finset V) :
    u ∈ ForwardReachableOn adj u H := by
  classical
  dsimp [ForwardReachableOn]
  exact Finset.mem_filter.mpr ⟨by simp, Or.inl rfl⟩

/-- Dynamic value for the parameterized graph carrier: the maximum reward over
    all forward-reachable vertices. -/
noncomputable def dynamicValueOn {V : Type*} [Fintype V] [DecidableEq V]
    (adj : V -> V -> Prop) (reward : V -> ℝ) (u : V) (H : Finset V) : ℝ :=
  (ForwardReachableOn adj u H).sup'
    ⟨u, ForwardReachableOn_self_mem adj u H⟩ reward

theorem localGreedyPathValueFuelOn_terminal_in_ForwardReachableOn {V : Type*}
    [Fintype V] [DecidableEq V] (adj : V -> V -> Prop)
    (reward : V -> ℝ) :
    ∀ (fuel : ℕ) (u : V) (H : Finset V),
      ∃ w ∈ ForwardReachableOn adj u H,
        localGreedyPathValueFuelOn adj reward fuel u H = reward w := by
  intro fuel
  induction fuel with
  | zero =>
      intro u H
      exact ⟨u, ForwardReachableOn_self_mem adj u H, rfl⟩
  | succ fuel ih =>
      intro u H
      let N : Finset V := NeighbourSetOn adj u H
      by_cases hN : N.Nonempty
      · let c : V := greedyRewardChildOn reward N hN
        have hcLocal : c ∈ N := greedyRewardChildOn_mem reward N hN
        have hcFR : c ∈ (ForwardReachableOn adj u H).erase u :=
          NeighbourSetOn_mem_ForwardReachableOn_erase
            (by simpa [N, c] using hcLocal)
        obtain ⟨w, hw_mem, hw_eq⟩ := ih c (insert u H)
        refine ⟨w, ForwardReachableOn_trans_from_erase hcFR hw_mem, ?_⟩
        simpa [localGreedyPathValueFuelOn, N, hN, c] using hw_eq
      · refine ⟨u, ForwardReachableOn_self_mem adj u H, ?_⟩
        simp [localGreedyPathValueFuelOn, N, hN]

theorem localGreedyPathValueOn_terminal_in_ForwardReachableOn {V : Type*}
    [Fintype V] [DecidableEq V] (adj : V -> V -> Prop)
    (reward : V -> ℝ) (u : V) (H : Finset V) :
    ∃ w ∈ ForwardReachableOn adj u H,
      localGreedyPathValueOn adj reward u H = reward w :=
  localGreedyPathValueFuelOn_terminal_in_ForwardReachableOn adj reward
    (Fintype.card V + 1) u H

theorem localGreedyPathValueOn_le_dynamicValueOn {V : Type*}
    [Fintype V] [DecidableEq V] (adj : V -> V -> Prop)
    (reward : V -> ℝ) (u : V) (H : Finset V) :
    localGreedyPathValueOn adj reward u H ≤ dynamicValueOn adj reward u H := by
  obtain ⟨w, hw_mem, hw_eq⟩ :=
    localGreedyPathValueOn_terminal_in_ForwardReachableOn adj reward u H
  rw [hw_eq, dynamicValueOn]
  exact Finset.le_sup' (f := reward) hw_mem

def LocalGreedyPathValueDominatesForwardReachableOn {V : Type*}
    [Fintype V] [DecidableEq V] (adj : V -> V -> Prop)
    (reward : V -> ℝ) : Prop :=
  ∀ (u : V) (H : Finset V), ∀ w ∈ ForwardReachableOn adj u H,
    reward w ≤ localGreedyPathValueOn adj reward u H

theorem localGreedyPathValueOn_eq_dynamicValueOn_at_of_dominates_forwardReachableOn
    {V : Type*} [Fintype V] [DecidableEq V] (adj : V -> V -> Prop)
    (reward : V -> ℝ) {u : V} {H : Finset V}
    (hDom : ∀ w ∈ ForwardReachableOn adj u H,
      reward w ≤ localGreedyPathValueOn adj reward u H) :
    localGreedyPathValueOn adj reward u H = dynamicValueOn adj reward u H := by
  apply le_antisymm
  · exact localGreedyPathValueOn_le_dynamicValueOn adj reward u H
  · unfold dynamicValueOn
    apply Finset.sup'_le
    intro w hw
    exact hDom w hw

theorem localGreedyPathValueOn_eq_dynamicValueOn_of_dominates_forwardReachableOn
    {V : Type*} [Fintype V] [DecidableEq V] (adj : V -> V -> Prop)
    (reward : V -> ℝ)
    (hDom : LocalGreedyPathValueDominatesForwardReachableOn adj reward) :
    ∀ (u : V) (H : Finset V),
      localGreedyPathValueOn adj reward u H = dynamicValueOn adj reward u H := by
  intro u H
  exact localGreedyPathValueOn_eq_dynamicValueOn_at_of_dominates_forwardReachableOn
    adj reward (hDom u H)

theorem fin3Path_neighbourSet_zero_empty :
    NeighbourSetOn fin3PathAdj (0 : Fin 3) ∅ = {1} := by
  classical
  ext v
  fin_cases v <;> simp [NeighbourSetOn, fin3PathAdj]

theorem fin3Path_neighbourSet_one_after_zero :
    NeighbourSetOn fin3PathAdj (1 : Fin 3) (insert (0 : Fin 3) ∅) = {2} := by
  classical
  ext v
  fin_cases v <;> simp [NeighbourSetOn, fin3PathAdj]

theorem fin3Path_neighbourSet_one_singleton_zero :
    NeighbourSetOn fin3PathAdj (1 : Fin 3) ({(0 : Fin 3)} : Finset (Fin 3)) = {2} := by
  classical
  ext v
  fin_cases v <;> simp [NeighbourSetOn, fin3PathAdj]

theorem fin3Path_neighbourSet_two_after_one_zero :
    NeighbourSetOn fin3PathAdj (2 : Fin 3)
      (insert (1 : Fin 3) (insert (0 : Fin 3) ∅)) = ∅ := by
  classical
  ext v
  fin_cases v <;> simp [NeighbourSetOn, fin3PathAdj]

theorem fin3Path_neighbourSet_two_pair_one_zero :
    NeighbourSetOn fin3PathAdj (2 : Fin 3)
      ({(1 : Fin 3), (0 : Fin 3)} : Finset (Fin 3)) = ∅ := by
  classical
  ext v
  fin_cases v <;> simp [NeighbourSetOn, fin3PathAdj]

theorem fin3Path_forwardReachable_zero_empty_univ :
    ForwardReachableOn fin3PathAdj (0 : Fin 3) ∅ = Finset.univ := by
  classical
  ext v
  constructor
  · intro _hv
    simp
  · intro _hv
    fin_cases v
    · exact ForwardReachableOn_self_mem fin3PathAdj (0 : Fin 3) ∅
    · dsimp [ForwardReachableOn]
      exact Finset.mem_filter.mpr
        ⟨by simp,
          Or.inr (Relation.ReflTransGen.single (by simp [fin3PathAdj]))⟩
    · have h01 :
          Relation.ReflTransGen
            (fun x y : Fin 3 => x ∉ (∅ : Finset (Fin 3)) ∧
              y ∉ (∅ : Finset (Fin 3)) ∧ fin3PathAdj x y)
            (0 : Fin 3) 1 := by
        exact Relation.ReflTransGen.single (by simp [fin3PathAdj])
      have h12 :
          Relation.ReflTransGen
            (fun x y : Fin 3 => x ∉ (∅ : Finset (Fin 3)) ∧
              y ∉ (∅ : Finset (Fin 3)) ∧ fin3PathAdj x y)
            (1 : Fin 3) 2 := by
        exact Relation.ReflTransGen.single (by simp [fin3PathAdj])
      dsimp [ForwardReachableOn]
      exact Finset.mem_filter.mpr
        ⟨by simp, Or.inr (Relation.ReflTransGen.trans h01 h12)⟩

/-- Scoped domination witness for the explicit three-vertex terminal-neighbour
    path. Under the leaf-dominance hypotheses, the local-neighbour greedy value
    from the start dominates every forward-reachable reward from that start. -/
theorem fin3Path_localGreedy_dominates_forwardReachable_from_start_of_leaf_dominates
    (reward : Fin 3 -> ℝ)
    (h0 : reward (0 : Fin 3) ≤ reward (2 : Fin 3))
    (h1 : reward (1 : Fin 3) ≤ reward (2 : Fin 3)) :
    ∀ w ∈ ForwardReachableOn fin3PathAdj (0 : Fin 3) ∅,
      reward w ≤ localGreedyPathValueOn fin3PathAdj reward (0 : Fin 3) ∅ := by
  classical
  have h_local :
      localGreedyPathValueOn fin3PathAdj reward (0 : Fin 3) ∅ =
        reward (2 : Fin 3) := by
    simp [localGreedyPathValueOn, localGreedyPathValueFuelOn,
      fin3Path_neighbourSet_zero_empty,
      fin3Path_neighbourSet_one_singleton_zero,
      fin3Path_neighbourSet_two_pair_one_zero,
      greedyRewardChildOn_singleton]
  intro w _hw
  rw [h_local]
  fin_cases w
  · exact h0
  · exact h1
  · rfl

/-- Non-vacuous positive migration target for the terminal-neighbour route.
    On the explicit three-vertex terminal-neighbour path, the local-neighbour
    greedy carrier agrees with the dynamic carrier from the start vertex when
    the terminal leaf dominates the two earlier rewards. This is the
    kernel-only version of the route that R275 showed cannot be obtained from
    the old all-forward-reachable candidate semantics. -/
theorem fin3Path_localGreedy_eq_dynamic_from_start_of_leaf_dominates
    (reward : Fin 3 -> ℝ)
    (h0 : reward (0 : Fin 3) ≤ reward (2 : Fin 3))
    (h1 : reward (1 : Fin 3) ≤ reward (2 : Fin 3)) :
    localGreedyPathValueOn fin3PathAdj reward (0 : Fin 3) ∅ =
      dynamicValueOn fin3PathAdj reward (0 : Fin 3) ∅ := by
  exact localGreedyPathValueOn_eq_dynamicValueOn_at_of_dominates_forwardReachableOn
    (adj := fin3PathAdj) (reward := reward)
    (u := (0 : Fin 3)) (H := ∅)
    (fin3Path_localGreedy_dominates_forwardReachable_from_start_of_leaf_dominates
      reward h0 h1)

/-- Concrete reward witness for the non-vacuous terminal-neighbour route:
    the terminal leaf has reward `1`, earlier vertices have reward `0`. -/
def fin3LeafReward (v : Fin 3) : ℝ :=
  if v = (2 : Fin 3) then 1 else 0

theorem fin3LeafReward_zero_le_two :
    fin3LeafReward (0 : Fin 3) ≤ fin3LeafReward (2 : Fin 3) := by
  have h02 : (0 : Fin 3) ≠ (2 : Fin 3) := by decide
  simp [fin3LeafReward, h02]

theorem fin3LeafReward_one_le_two :
    fin3LeafReward (1 : Fin 3) ≤ fin3LeafReward (2 : Fin 3) := by
  have h12 : (1 : Fin 3) ≠ (2 : Fin 3) := by decide
  simp [fin3LeafReward, h12]

/-- Fully closed non-vacuous witness for the local-neighbour terminal route:
    on an explicit terminal-neighbour graph with a concrete leaf-dominating
    reward function, local greedy agrees with the dynamic value from the start. -/
theorem fin3Path_localGreedy_eq_dynamic_from_start_concreteLeafReward :
    localGreedyPathValueOn fin3PathAdj fin3LeafReward (0 : Fin 3) ∅ =
      dynamicValueOn fin3PathAdj fin3LeafReward (0 : Fin 3) ∅ := by
  exact fin3Path_localGreedy_eq_dynamic_from_start_of_leaf_dominates
    fin3LeafReward fin3LeafReward_zero_le_two fin3LeafReward_one_le_two

/-- Existence form of the non-vacuous local terminal-neighbour witness. This
    packages the graph-topology witness with the concrete reward equality while
    keeping the result graph-parameterized, not tied to the impossible current
    complete-loopless global carrier. -/
theorem exists_fin3_terminalNeighbour_localGreedy_eq_dynamic_from_start :
    ∃ reward : Fin 3 -> ℝ,
      TerminalNeighbourTopologyOn fin3PathAdj ∧
        localGreedyPathValueOn fin3PathAdj reward (0 : Fin 3) ∅ =
          dynamicValueOn fin3PathAdj reward (0 : Fin 3) ∅ := by
  exact ⟨fin3LeafReward, fin3Path_terminalNeighbourTopology,
    fin3Path_localGreedy_eq_dynamic_from_start_concreteLeafReward⟩

/-- Boundary theorem for the terminal-neighbour migration: the same explicit
    `Fin 3` terminal-neighbour instance has a closed local-neighbour
    greedy/dynamic equality witness while refuting the old all-forward-reachable
    candidate-locality bridge. This pins the next proof step to a public
    `V_g` semantics migration rather than another attempt to prove candidate
    locality from terminal-neighbour topology. -/
theorem fin3_terminalNeighbour_localRoute_succeeds_and_oldCandidateLocality_fails :
    TerminalNeighbourTopologyOn fin3PathAdj ∧
      localGreedyPathValueOn fin3PathAdj fin3LeafReward (0 : Fin 3) ∅ =
        dynamicValueOn fin3PathAdj fin3LeafReward (0 : Fin 3) ∅ ∧
      Not (ForwardReachableCandidatesAreLocalOn fin3PathAdj) := by
  exact ⟨fin3Path_terminalNeighbourTopology,
    fin3Path_localGreedy_eq_dynamic_from_start_concreteLeafReward,
    not_fin3Path_ForwardReachableCandidatesAreLocalOn⟩

/-! ### Non-vacuous parameterized C2prime trap witness -/

/-- A five-vertex terminal-neighbour trap:
    `0` branches to `1` and `2`; `1` leads to leaf `3`, and `2` leads to
    leaf `4`. -/
def fin5TrapAdj : Fin 5 -> Fin 5 -> Prop
  | 0, 1 => True
  | 1, 0 => True
  | 0, 2 => True
  | 2, 0 => True
  | 1, 3 => True
  | 3, 1 => True
  | 2, 4 => True
  | 4, 2 => True
  | _, _ => False

theorem fin5Trap_leaf3_terminal :
    IsTerminalNeighbourOfOn fin5TrapAdj (1 : Fin 5) 3 := by
  intro w hw
  fin_cases w <;> simp [fin5TrapAdj] at hw ⊢

theorem fin5Trap_leaf4_terminal :
    IsTerminalNeighbourOfOn fin5TrapAdj (2 : Fin 5) 4 := by
  intro w hw
  fin_cases w <;> simp [fin5TrapAdj] at hw ⊢

theorem fin5Trap_root1_depthOne :
    IsDepthOneSubtreeRootOfOn fin5TrapAdj (0 : Fin 5) 1 := by
  intro child hchild
  fin_cases child <;> simp [fin5TrapAdj] at hchild ⊢
  exact fin5Trap_leaf3_terminal

theorem fin5Trap_root2_depthOne :
    IsDepthOneSubtreeRootOfOn fin5TrapAdj (0 : Fin 5) 2 := by
  intro child hchild
  fin_cases child <;> simp [fin5TrapAdj] at hchild ⊢
  exact fin5Trap_leaf4_terminal

theorem fin5Trap_terminalNeighbourTopology :
    TerminalNeighbourTopologyOn fin5TrapAdj := by
  refine ⟨(0 : Fin 5), ?_⟩
  intro u hu
  fin_cases u <;> simp [fin5TrapAdj] at hu ⊢
  · exact Or.inr fin5Trap_root1_depthOne
  · exact Or.inr fin5Trap_root2_depthOne

theorem fin5Trap_neighbourhoodExhausted_zero_one_two :
    NeighbourhoodExhaustedByPairOn fin5TrapAdj
      (0 : Fin 5) 1 2 := by
  refine ⟨by decide, by simp [fin5TrapAdj], by simp [fin5TrapAdj], ?_⟩
  intro u hu
  fin_cases u <;> simp [fin5TrapAdj] at hu ⊢

theorem fin5Trap_degreeTwoStartingVertexOn :
    DegreeTwoStartingVertexOn fin5TrapAdj := by
  exact degreeTwoStartingVertexOn_of_neighbourhoodExhaustedByPairOn
    fin5Trap_neighbourhoodExhausted_zero_one_two

/-- Rewards make the immediately higher-reward branch (`1`) lead to the
    lower continuation leaf (`3`), while the lower-reward branch (`2`) leads
    to the high continuation leaf (`4`). -/
def fin5TrapReward : Fin 5 -> ℝ
  | 0 => 0
  | 1 => 6
  | 2 => 4
  | 3 => 3
  | 4 => 10

theorem fin5Trap_reward_low_lt_high :
    fin5TrapReward (2 : Fin 5) < fin5TrapReward 1 := by
  norm_num [fin5TrapReward]

theorem fin5Trap_neighbourSet_one_singleton_zero :
    NeighbourSetOn fin5TrapAdj (1 : Fin 5)
      ({(0 : Fin 5)} : Finset (Fin 5)) = {3} := by
  classical
  ext v
  fin_cases v <;> simp [NeighbourSetOn, fin5TrapAdj]

theorem fin5Trap_neighbourSet_two_singleton_zero :
    NeighbourSetOn fin5TrapAdj (2 : Fin 5)
      ({(0 : Fin 5)} : Finset (Fin 5)) = {4} := by
  classical
  ext v
  fin_cases v <;> simp [NeighbourSetOn, fin5TrapAdj]

theorem fin5Trap_neighbourSet_three_pair_one_zero :
    NeighbourSetOn fin5TrapAdj (3 : Fin 5)
      ({(1 : Fin 5), (0 : Fin 5)} : Finset (Fin 5)) = ∅ := by
  classical
  ext v
  fin_cases v <;> simp [NeighbourSetOn, fin5TrapAdj]

theorem fin5Trap_neighbourSet_four_pair_two_zero :
    NeighbourSetOn fin5TrapAdj (4 : Fin 5)
      ({(2 : Fin 5), (0 : Fin 5)} : Finset (Fin 5)) = ∅ := by
  classical
  ext v
  fin_cases v <;> simp [NeighbourSetOn, fin5TrapAdj]

theorem fin5Trap_localGreedy_one_after_zero :
    localGreedyPathValueOn fin5TrapAdj fin5TrapReward
      (1 : Fin 5) ({(0 : Fin 5)} : Finset (Fin 5)) =
        fin5TrapReward 3 := by
  simp [localGreedyPathValueOn, localGreedyPathValueFuelOn,
    fin5Trap_neighbourSet_one_singleton_zero,
    fin5Trap_neighbourSet_three_pair_one_zero,
    greedyRewardChildOn_singleton]

theorem fin5Trap_localGreedy_two_after_zero :
    localGreedyPathValueOn fin5TrapAdj fin5TrapReward
      (2 : Fin 5) ({(0 : Fin 5)} : Finset (Fin 5)) =
        fin5TrapReward 4 := by
  simp [localGreedyPathValueOn, localGreedyPathValueFuelOn,
    fin5Trap_neighbourSet_two_singleton_zero,
    fin5Trap_neighbourSet_four_pair_two_zero,
    greedyRewardChildOn_singleton]

theorem fin5Trap_localGreedy_reversal :
    localGreedyPathValueOn fin5TrapAdj fin5TrapReward
      (1 : Fin 5) ({(0 : Fin 5)} : Finset (Fin 5)) <
        localGreedyPathValueOn fin5TrapAdj fin5TrapReward
          (2 : Fin 5) ({(0 : Fin 5)} : Finset (Fin 5)) := by
  rw [fin5Trap_localGreedy_one_after_zero,
    fin5Trap_localGreedy_two_after_zero]
  norm_num [fin5TrapReward]

theorem fin5Trap_localC2primeFullWitnessOn :
    LocalC2primeFullWitnessOn fin5TrapAdj fin5TrapReward := by
  exact ⟨(0 : Fin 5), 1, 2, ({(0 : Fin 5)} : Finset (Fin 5)),
    fin5Trap_neighbourhoodExhausted_zero_one_two,
    fin5Trap_reward_low_lt_high,
    fin5Trap_localGreedy_reversal⟩

theorem fin5Trap_localGreedyWelfareReversalOn :
    LocalGreedyWelfareReversalOn fin5TrapAdj fin5TrapReward := by
  exact ⟨(0 : Fin 5), 1, 2, ({(0 : Fin 5)} : Finset (Fin 5)),
    fin5Trap_neighbourhoodExhausted_zero_one_two,
    fin5Trap_reward_low_lt_high,
    localGreedySignalWelfareOn_reversal_of_path_reversal
      fin5TrapAdj fin5TrapReward fin5Trap_localGreedy_reversal⟩

theorem fin5Trap_terminalNeighbour_and_localC2primeFullWitness :
    TerminalNeighbourTopologyOn fin5TrapAdj ∧
      LocalC2primeFullWitnessOn fin5TrapAdj fin5TrapReward := by
  exact ⟨fin5Trap_terminalNeighbourTopology,
    fin5Trap_localC2primeFullWitnessOn⟩

theorem fin5Trap_terminalNeighbour_and_degreeTwoStartingVertexOn :
    TerminalNeighbourTopologyOn fin5TrapAdj ∧
      DegreeTwoStartingVertexOn fin5TrapAdj := by
  exact ⟨fin5Trap_terminalNeighbourTopology,
    fin5Trap_degreeTwoStartingVertexOn⟩

#print axioms fin3Path_terminalNeighbourTopology
#print axioms not_fin3Path_GreedyChildTerminalAndSelfLeOn
#print axioms not_fin3Path_ForwardReachableCandidatesAreLocalOn
#print axioms NeighbourSetOn_mem_ForwardReachableOn_erase
#print axioms ForwardReachableOn_trans_from_erase
#print axioms localGreedyPathValueOn_terminal_in_ForwardReachableOn
#print axioms localGreedyPathValueOn_le_dynamicValueOn
#print axioms LocalGreedyPathValueDominatesForwardReachableOn
#print axioms localGreedyPathValueOn_eq_dynamicValueOn_at_of_dominates_forwardReachableOn
#print axioms localGreedyPathValueOn_eq_dynamicValueOn_of_dominates_forwardReachableOn
#print axioms fin3Path_localGreedy_dominates_forwardReachable_from_start_of_leaf_dominates
#print axioms fin3Path_localGreedy_eq_dynamic_from_start_of_leaf_dominates
#print axioms fin3Path_localGreedy_eq_dynamic_from_start_concreteLeafReward
#print axioms exists_fin3_terminalNeighbour_localGreedy_eq_dynamic_from_start
#print axioms fin3_terminalNeighbour_localRoute_succeeds_and_oldCandidateLocality_fails
#print axioms NeighbourhoodExhaustedByPairOn
#print axioms DegreeTwoStartingVertexOn
#print axioms degreeTwoStartingVertexOn_of_neighbourhoodExhaustedByPairOn
#print axioms LocalC2primeFullWitnessOn
#print axioms localGreedySignalWelfareOn
#print axioms LocalGreedyWelfareReversalOn
#print axioms localGreedySignalWelfareOn_reversal_of_path_reversal
#print axioms fin5Trap_terminalNeighbourTopology
#print axioms fin5Trap_neighbourhoodExhausted_zero_one_two
#print axioms fin5Trap_degreeTwoStartingVertexOn
#print axioms fin5Trap_localGreedy_one_after_zero
#print axioms fin5Trap_localGreedy_two_after_zero
#print axioms fin5Trap_localGreedy_reversal
#print axioms fin5Trap_localC2primeFullWitnessOn
#print axioms fin5Trap_localGreedyWelfareReversalOn
#print axioms fin5Trap_terminalNeighbour_and_localC2primeFullWitness
#print axioms fin5Trap_terminalNeighbour_and_degreeTwoStartingVertexOn

end BlackwellDilemma.Infrastructure
