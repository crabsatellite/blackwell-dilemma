/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import BlackwellDilemma.Types
import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Combinatorics.SimpleGraph.Connectivity.Connected

/-!
# SimpleGraph from paper's IsEdge predicate (Cat 1 bridge)

This module constructs Cat 1 `SimpleGraph` instances from paper's
opaque `IsEdge : Vertex → Vertex → Prop` + paper's per-realisation
`IsOpen : PercolationOutcome → Vertex → Vertex → Prop`. The
construction handles the loopless requirement (`Adj` must be
irreflexive in `SimpleGraph`) by intersecting with `u ≠ v`.

This bridges paper's opaque `Vertex` + `IsEdge` to Mathlib's
`SimpleGraph` framework, enabling Cat 1 application of
`Infrastructure.SimpleGraphReachable.reachable_finset_eq_univ_of_preconnected`
once paper's preconnectedness is supplied.

## Main definitions

* `paperGraph : SimpleGraph Vertex` —
  the underlying graph from paper's `IsEdge` (excluding self-loops by
  construction).
* `percolationGraph (ω : PercolationOutcome) : SimpleGraph Vertex` —
  the open-edge subgraph at percolation realisation `ω`.

## Main results

* `percolationGraph_eq_paperGraph_at_all_open` —
  if every paper-edge is open in `ω`, then the percolation subgraph
  equals the full paper graph (Cat 1 derivation; no new axioms).

## Cat 1 status

Built only from `BlackwellDilemma.Types` (paper's `Vertex`, `IsEdge`,
`IsEdge.symm`, `IsOpen`) + `Mathlib.Combinatorics.SimpleGraph`. No
new paper-novel axioms — the loopless requirement is satisfied by
construction (intersecting with `u ≠ v`). Kernel-pure.

## Future Mathlib PR

This pattern (constructing `SimpleGraph` from a symmetric predicate
plus inequality) is a useful adapter, generalisable as
`SimpleGraph.fromSymmetricRel`.

## Tags

SimpleGraph, IsEdge, paper graph, percolation graph, bridge,
Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

open BlackwellDilemma SimpleGraph

/-- **Paper's underlying SimpleGraph from `IsEdge`**. The Adj
    relation is `IsEdge u v ∧ u ≠ v`, satisfying SimpleGraph's
    irreflexivity (loopless) requirement by construction.
    Symmetry follows from paper's `IsEdge.symm`. -/
def paperGraph : SimpleGraph Vertex where
  Adj u v := IsEdge u v ∧ u ≠ v
  symm := fun {u v} ⟨h_edge, h_ne⟩ =>
    ⟨IsEdge.symm h_edge, fun h => h_ne h.symm⟩
  loopless := ⟨fun u h => h.2 rfl⟩

/-- The current canonical `paperGraph` is preconnected. Since the current
    `IsEdge` carrier is the complete loopless relation `u ≠ v`, any two
    distinct vertices are adjacent and equal vertices are reachable by the
    empty walk. -/
theorem paperGraph_preconnected_current : paperGraph.Preconnected := by
  intro u v
  by_cases h : u = v
  case pos =>
    subst v
    exact SimpleGraph.Reachable.refl u
  case neg =>
    have h_edge : IsEdge u v := by
      simpa [IsEdge, isEdgeData] using h
    have h_adj : paperGraph.Adj u v := And.intro h_edge h
    exact h_adj.reachable

/-- **Open-edge SimpleGraph at percolation realisation `ω`**. The Adj
    relation includes only edges that are paper-edges AND open in `ω`,
    plus loopless intersection. Symmetry follows from `IsEdge.symm`
    plus assumed symmetry of `IsOpen` (which the paper's bond
    percolation model satisfies). -/
def percolationGraph (ω : PercolationOutcome)
    (h_isOpen_symm : ∀ {u v : Vertex}, IsOpen ω u v → IsOpen ω v u) :
    SimpleGraph Vertex where
  Adj u v := IsEdge u v ∧ IsOpen ω u v ∧ u ≠ v
  symm := fun {u v} ⟨h_edge, h_open, h_ne⟩ =>
    ⟨IsEdge.symm h_edge, h_isOpen_symm h_open, fun h => h_ne h.symm⟩
  loopless := ⟨fun u h => h.2.2 rfl⟩

/-- **All-edges-open implies percolation subgraph = paper graph**:
    if every paper-edge is open in `ω`, then `percolationGraph ω` has
    the same Adj relation as `paperGraph`.

    Cat 1: kernel-pure derivation from the definitions of
    `paperGraph` and `percolationGraph`. -/
theorem percolationGraph_adj_eq_paperGraph_at_all_open
    (ω : PercolationOutcome)
    (h_isOpen_symm : ∀ {u v : Vertex}, IsOpen ω u v → IsOpen ω v u)
    (h_all_open : ∀ u w : Vertex, IsEdge u w → IsOpen ω u w) :
    ∀ u v : Vertex,
      (percolationGraph ω h_isOpen_symm).Adj u v ↔ paperGraph.Adj u v := by
  intro u v
  constructor
  · intro ⟨h_edge, _h_open, h_ne⟩
    exact ⟨h_edge, h_ne⟩
  · intro ⟨h_edge, h_ne⟩
    exact ⟨h_edge, h_all_open u v h_edge, h_ne⟩

/-! ### Kernel-purity audit

`#print axioms` on the constructions surfaces ONLY paper's
`Vertex`, `IsEdge`, `IsEdge.symm` axioms (Cat 3 §3.4.1 paper-novel
primitives) + Mathlib kernel axioms. NO new paper-novel atoms are
introduced by this bridge module — the loopless requirement is
satisfied by construction (`u ≠ v` intersection), and symmetry uses
the existing paper `IsEdge.symm` axiom. -/

#print axioms paperGraph
#print axioms paperGraph_preconnected_current
#print axioms percolationGraph_adj_eq_paperGraph_at_all_open

end BlackwellDilemma.Infrastructure
