/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Alex Chengyu Li
-/
import BlackwellDilemma.Infrastructure.IntegerLattice
import BlackwellDilemma.Infrastructure.BernoulliProductFinite
import Mathlib.Combinatorics.SimpleGraph.Subgraph

/-!
# Bond percolation on the integer lattice (measure-theoretic stub)

This file is the **measure-theoretic stub** of the Mathlib contribution
roadmap (`MATHLIB_CONTRIBUTION_ROADMAP.md`). It assembles the
`integerLatticeGraph` and the Cat 1 finite Bernoulli-product weight
infrastructure into a unified namespace where the bond-percolation
constructions used in the BlackwellDilemma paper Theorem `thm:phase`
(line 411 ff.) and Theorem `thm:cognitive-threshold` Part 6 (line 498)
can be developed without the open-cluster measure-theoretic apparatus
that Mathlib does not yet host.

## Main definitions

* `BondConfigOnGraph G` — a bond-percolation outcome on a `SimpleGraph G`:
  a function from `Sym2 V` (unordered edge type) to `Bool` (open/closed).
  Specialised to `integerLatticeGraph d` for the lattice setting.
* `IsOpenEdge G ω e` — predicate that an edge `e ∈ G.edgeSet` is open
  under outcome `ω`.
* `latticeBondConfig d` — abbreviation for `BondConfigOnGraph
  (integerLatticeGraph d)`.
* `LatticeMonotoneCouplingData d` — the per-edge monotone Bernoulli
  coupling ingredient that a future infinite-product lattice coupling must
  extend.

## Why this is a stub

The complete measure-theoretic development from
`MATHLIB_CONTRIBUTION_ROADMAP.md` requires:
1. Measure-theoretic product Bernoulli on `(BondConfigOnGraph G)` —
   blocked by Mathlib's lack of an `MeasureTheory.Measure.pi`-friendly
   formulation for `Sym2 V` index sets when `V` is infinite (the lattice
   case has `V = Fin d → ℤ`, infinite even for `d = 1`).
2. Cluster + connected-component analysis on the random subgraph —
   needs `SimpleGraph.Subgraph`/`Connectivity` API extended to the
   percolation-induced random subgraph.
3. Strassen monotone coupling — straightforward once #1 is in place.

For now this stub provides only the discrete edge-state predicate and
bridges to the existing `Infrastructure.bernoulliWeight` framework
(which is finite-edge-set only). Full lattice infrastructure is a
multi-month upstream Mathlib contribution and is the path to closing
the 2 Cat 3 lattice OPEN entries (`trapLocalConfigProb_pos_and_le`,
`restrictedExpectation_eq_localConfigProb`) and the lattice DEAD-END
marker for Theorem 4.1 Part 4.

## Mathlib upstream targets

The contents of this file (when developed) are intended for:
* `Mathlib/Probability/Percolation/Basic.lean` — `BondConfigOnGraph`
  + `IsOpenEdge` + edge independence.
* `Mathlib/Probability/Percolation/Cluster.lean` — cluster + open-subgraph.
* `Mathlib/Probability/Percolation/Coupling.lean` — Strassen monotone coupling.

## Tags

bond percolation, simple graph, integer lattice, statistical mechanics
-/

namespace BlackwellDilemma.Infrastructure.BondPercolationLattice

open SimpleGraph

/-! ### Bond-configuration outcome on a SimpleGraph -/

/-- A bond-percolation outcome on a `SimpleGraph G`: assigns each
unordered edge a Boolean state (`true` = open, `false` = blocked).

We index by `Sym2 V` rather than by `G.edgeSet` directly because the
`Sym2 V → Bool` formulation gives the standard Mathlib treatment for
percolation processes (per the planned `Mathlib/Probability/Percolation/`
namespace). The `IsOpenEdge` predicate below restricts attention to
actual edges of `G`. -/
def BondConfigOnGraph {V : Type*} (_G : SimpleGraph V) : Type _ :=
  Sym2 V → Bool

/-- Edge `e` is open under bond-configuration `ω` and graph `G` iff
`e ∈ G.edgeSet` and `ω e = true`. -/
def IsOpenEdge {V : Type*} (G : SimpleGraph V) (ω : BondConfigOnGraph G)
    (e : Sym2 V) : Prop :=
  e ∈ G.edgeSet ∧ ω e = true

/-- The integer-lattice specialisation: a bond-percolation outcome on
the `d`-dimensional integer lattice graph. Used in BlackwellDilemma
paper §3.3 for the `Z²` percolation analysis. -/
abbrev latticeBondConfig (d : ℕ) : Type _ :=
  BondConfigOnGraph (integerLatticeGraph d)

/-- The `Z²` specialisation, for the canonical Harris–Kesten setting. -/
abbrev Z2BondConfig : Type _ := latticeBondConfig 2

/-! ### Per-edge monotone-coupling interface -/

/-- Lattice-level monotone-coupling data at the per-edge Bernoulli layer.

This is still not the infinite-product Strassen coupling needed to close the
paper-semantic lattice targets.  It is the kernel-checked local ingredient:
for every ordered pair `0 <= p_low <= p_high <= 1`, each lattice edge has a
one-edge monotone Bernoulli coupling with correct lower/upper marginals and no
mass on the forbidden open-to-closed transition. -/
structure LatticeMonotoneCouplingData (d : ℕ) where
  edge_coupling :
    ∀ p_low p_high : ℝ, 0 ≤ p_low -> p_low ≤ p_high -> p_high ≤ 1 ->
      BlackwellDilemma.Infrastructure.BernoulliMonotoneCouplingData
        p_low p_high

/-- Standard per-edge monotone-coupling data for the integer lattice. -/
def standardLatticeMonotoneCouplingData (d : ℕ) :
    LatticeMonotoneCouplingData d where
  edge_coupling := fun p_low p_high h_low_nonneg h_mono h_high_le_one =>
    BlackwellDilemma.Infrastructure.standardBernoulliMonotoneCouplingData
      p_low p_high h_low_nonneg h_mono h_high_le_one

/-! ### Connection to the existing finite-edge bond weight framework

The existing `BlackwellDilemma.bondConfigWeight` (in `Percolation.lean`,
also routed through `Infrastructure.bernoulliWeight`) handles
the FINITE-edge case where the edge type is a `Fintype`. The lattice
case `integerLatticeGraph d` has infinitely many edges (for any `d ≥ 1`),
so the existing finite-edge framework applies only to BOUNDED-BOX
restrictions of the lattice (an `EdgeFinset` on a `[-N, N]^d` cube).

The infinite-edge measure-theoretic extension is the substantive
follow-up work; this stub records the discrete-edge predicate that the
eventual `Probability/Percolation/Basic.lean` Mathlib file will
instantiate. -/

/-! ### Kernel-purity audit -/

#print axioms standardLatticeMonotoneCouplingData

end BlackwellDilemma.Infrastructure.BondPercolationLattice
