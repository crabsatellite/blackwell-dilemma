/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Alex Chengyu Li
-/
import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Data.Int.AbsoluteValue
import Mathlib.Data.Fintype.Pi

/-!
# The integer lattice as a `SimpleGraph`

This file defines the `d`-dimensional integer lattice `Fin d → ℤ` as a
`SimpleGraph`, with adjacency given by the ℓ¹-distance equal to one
(equivalently: two vertices are adjacent iff they differ in exactly one
coordinate by `±1`). This is the standard model of `ℤᵈ` in
combinatorics, statistical mechanics, and bond-percolation theory.

## Main definitions

* `integerLatticeGraph d` — the integer lattice graph on `Fin d → ℤ`
  with ℓ¹-adjacency.
* `Z2LatticeGraph` — convenience abbreviation for `d = 2`, the standard
  `ℤ²` lattice used in two-dimensional percolation (Harris–Kesten).

## Main results

* `integerLatticeGraph_adj_iff` — adjacency unfolded as a coordinate
  condition on `Fin d → ℤ`: there is exactly one index `i` where
  `x i` and `y i` differ by `±1`, and `x j = y j` for all `j ≠ i`.
* `integerLatticeGraph_loopless` — the graph has no self-loops
  (immediate from `Adj x x = False`).
* `integerLatticeGraph_symmetric` — the adjacency relation is symmetric
  (immediate from absolute value).

## Mathlib upstream target

This file is the **Phase 1** deliverable of the Mathlib contribution
plan documented in `lean4/MATHLIB_CONTRIBUTION_ROADMAP.md` for the
BlackwellDilemma paper's lattice infrastructure (see paper Theorem
`thm:phase` line 411 ff. and Theorem `thm:cognitive-threshold` Part 6
line 498). The intended Mathlib home is
`Mathlib/Combinatorics/SimpleGraph/IntegerLattice.lean`. The file is
written to Mathlib style conventions (Apache 2.0 header, single-import
preface, Mathlib namespace `SimpleGraph.IntegerLattice`, no paper-novel
carriers, no `axiom` declarations).

## Implementation notes

* The ℓ¹-distance is computed as `∑ i, |x i - y i|` over `Finset.univ`
  (since `Fin d` is a `Fintype`). This avoids importing the heavier
  `Mathlib.Analysis.Normed.Lp.PiLp` infrastructure.
* For `d = 2`, the convenience definition `Z2LatticeGraph` operates
  directly on `Fin 2 → ℤ`.
* Connectedness, locally-finite degree, and bounded-box edge-counts
  are stated separately in `Mathlib/Combinatorics/SimpleGraph/IntegerLattice/Basic.lean`
  (Phase 1b PR; not in this stub).

## Tags

simple graph, integer lattice, Z^d, percolation
-/

namespace SimpleGraph

namespace IntegerLattice

/-- The ℓ¹-distance between two points in the `d`-dimensional integer
lattice. -/
def l1Dist {d : ℕ} (x y : Fin d → ℤ) : ℤ :=
  ∑ i, |x i - y i|

@[simp]
lemma l1Dist_self {d : ℕ} (x : Fin d → ℤ) : l1Dist x x = 0 := by
  unfold l1Dist
  simp

lemma l1Dist_symm {d : ℕ} (x y : Fin d → ℤ) : l1Dist x y = l1Dist y x := by
  unfold l1Dist
  apply Finset.sum_congr rfl
  intro i _
  rw [abs_sub_comm]

lemma l1Dist_nonneg {d : ℕ} (x y : Fin d → ℤ) : 0 ≤ l1Dist x y := by
  unfold l1Dist
  exact Finset.sum_nonneg (fun i _ => abs_nonneg _)

end IntegerLattice

open IntegerLattice in
/-- The `d`-dimensional integer lattice as a `SimpleGraph` on `Fin d → ℤ`.

Two vertices `x, y : Fin d → ℤ` are adjacent iff their ℓ¹-distance is
exactly one — equivalently, they differ in exactly one coordinate by
`±1` and agree on every other coordinate.

This is the standard combinatorial model of `ℤᵈ` used in bond
percolation (Harris 1960, Kesten 1980, Grimmett 1999) and statistical
mechanics. -/
def integerLatticeGraph (d : ℕ) : SimpleGraph (Fin d → ℤ) where
  Adj x y := IntegerLattice.l1Dist x y = 1
  symm := by
    intro x y h
    rw [IntegerLattice.l1Dist_symm]
    exact h
  loopless := by
    refine ⟨fun x h => ?_⟩
    rw [IntegerLattice.l1Dist_self] at h
    exact absurd h (by decide)

/-- Convenience abbreviation for the two-dimensional integer lattice
`ℤ²`, the canonical setting for the Harris–Kesten theorem
(`p_c(ℤ²) = 1/2`) used in the BlackwellDilemma paper Theorem
`thm:phase`. -/
abbrev Z2LatticeGraph : SimpleGraph (Fin 2 → ℤ) :=
  integerLatticeGraph 2

@[simp]
lemma integerLatticeGraph_adj_iff {d : ℕ} (x y : Fin d → ℤ) :
    (integerLatticeGraph d).Adj x y ↔ IntegerLattice.l1Dist x y = 1 := Iff.rfl

end SimpleGraph
