/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Combinatorics.SimpleGraph.Connectivity.Connected

/-!
# Reachable-set covers `univ` under preconnected SimpleGraphs (Cat 1)

This file provides the **graph-theoretic structural identification** that
the missing axiom `forward_reachable_empty_full_at_all_open` is asking
for: under the percolation outcome where every edge of the underlying
graph is open, the forward-reachable set from any vertex covers the
whole vertex space — provided the underlying graph is preconnected.

## Main results

* `reachable_finset_eq_univ_of_preconnected` —
  `G.Preconnected ⇒ ∀ v, {w | G.Reachable v w}.toFinset = Finset.univ`
  (equivalent to `∀ v w, G.Reachable v w` finset-packaged).
* `reachable_finset_eq_univ_of_complete` —
  `(⊤ : SimpleGraph V) reachable from any v` covers `univ`. Specialises
  the preconnected result via `preconnected_top`.

## Bridge to paper carrier `ForwardReachable`

The paper's opaque carrier `ForwardReachable : Vertex → Finset Vertex →
PercolationOutcome → Finset Vertex` (paper Def 2.5) reduces to
`SimpleGraph.Reachable`-based reachability under the all-edges-open
percolation outcome on the underlying graph G. The bridge is the
paper-stipulated structural premise that the abstract carrier MATCHES
this concrete realisation when the underlying graph is provided as a
`SimpleGraph`. With that bridge in place, the
`forward_reachable_empty_full_at_all_open_paper_witness` axiom becomes a
direct Cat 1 corollary of `reachable_finset_eq_univ_of_preconnected`.

## Cat 1 status

Built only from Mathlib (`Mathlib.Combinatorics.SimpleGraph.Connectivity.Connected`).
No paper-novel axioms, no `sorry`. Both theorems are
Mathlib-PR-contributable as natural Finset packagings of `Preconnected`.

## Tags

SimpleGraph, Reachable, Preconnected, complete graph, Finset univ,
forward-reachable, percolation, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

open SimpleGraph

/-- **Reachable-set covers `univ` under preconnected.**
    For a `SimpleGraph` on a `Fintype V` that is preconnected (every
    pair is reachable), the reachable-set Finset from any vertex
    equals `Finset.univ`. Uses classical decidability for `Reachable`
    so `Finset.filter` is well-defined.

    Cat 1: kernel-pure (no axioms beyond Mathlib `SimpleGraph`). -/
theorem reachable_finset_eq_univ_of_preconnected
    {V : Type*} [Fintype V] {G : SimpleGraph V}
    (h_pre : G.Preconnected) (v : V) :
    haveI : DecidablePred (fun w => G.Reachable v w) := Classical.decPred _
    (Finset.univ.filter (fun w => G.Reachable v w)) = Finset.univ := by
  haveI : DecidablePred (fun w => G.Reachable v w) := Classical.decPred _
  ext w
  simp only [Finset.mem_filter, Finset.mem_univ, true_and, iff_true]
  exact h_pre v w

/-- **Complete-graph specialisation.**
    For the complete graph `(⊤ : SimpleGraph V)` on a `Fintype V`,
    the reachable-set Finset from any vertex equals `Finset.univ`.

    Cat 1: kernel-pure, follows from `preconnected_top`. -/
theorem reachable_finset_eq_univ_of_complete
    {V : Type*} [Fintype V] (v : V) :
    haveI : DecidablePred (fun w => (⊤ : SimpleGraph V).Reachable v w) :=
      Classical.decPred _
    (Finset.univ.filter (fun w => (⊤ : SimpleGraph V).Reachable v w))
        = Finset.univ :=
  reachable_finset_eq_univ_of_preconnected preconnected_top v

/-! ### Kernel-purity audit

`#print axioms` on `reachable_finset_eq_univ_of_preconnected` surfaces
ONLY Mathlib kernel axioms — no paper-novel `Types.lean` carriers, no
broken-link `_OPEN` axioms, no `sorry`. This is the Cat 1 graph-theoretic
core that the paper's `forward_reachable_empty_full_at_all_open` axiom
identifies with the abstract `ForwardReachable` carrier. -/

#print axioms reachable_finset_eq_univ_of_preconnected

end BlackwellDilemma.Infrastructure
