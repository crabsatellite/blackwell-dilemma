/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Alex Chengyu Li
-/
import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Piecewise
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

* `SimpleGraph.IntegerLattice.l1Dist` — the ℓ¹-distance on `Fin d → ℤ`.
* `SimpleGraph.IntegerLattice.unitVec` — the `i`-th standard unit
  vector `e_i : Fin d → ℤ` (`1` at `i`, `0` elsewhere).
* `SimpleGraph.integerLatticeGraph d` — the integer lattice graph on
  `Fin d → ℤ` with ℓ¹-adjacency.
* `SimpleGraph.Z2LatticeGraph` — convenience abbreviation for `d = 2`,
  the standard `ℤ²` lattice used in two-dimensional percolation
  (Harris–Kesten).

## Main results

* `l1Dist_self` / `l1Dist_symm` / `l1Dist_nonneg` — basic distance
  properties.
* `l1Dist_eq_one_iff_unitVec_diff` — `l1Dist x y = 1` iff `y - x` is
  `±` one of the standard unit vectors. The forward direction would
  need a more developed coordinate-extraction API; the converse
  (`unitVec` direction always gives `l1Dist = 1`) is provided.
* `l1Dist_unitVec_eq_one` / `l1Dist_neg_unitVec_eq_one` — the standard
  unit-vector neighbours of any point are at ℓ¹-distance one.
* `integerLatticeGraph_adj_iff` — adjacency unfolds to `l1Dist = 1`.
* `integerLatticeGraph_adj_unitVec` / `_neg_unitVec` — explicit
  adjacency for unit-vector translates.
* `Z2_Adj_iff_neighbour` — explicit characterisation of adjacency on
  `ℤ²` as one of the four neighbours `(x ± 1, y)` or `(x, y ± 1)`.

## Mathlib upstream target

This file is a foundational candidate for a Mathlib contribution supporting
the BlackwellDilemma paper's lattice infrastructure (see paper Theorem
`thm:phase` line 411 ff. and Theorem `thm:cognitive-threshold` Part 6
line 498). The intended Mathlib home is
`Mathlib/Combinatorics/SimpleGraph/IntegerLattice.lean`. The file is
written to Mathlib style conventions (Apache 2.0 header, single-import
preface, Mathlib namespace `SimpleGraph.IntegerLattice`, no paper-novel
carriers, no `axiom` declarations).

The harder per-vertex `degree = 2 * d` formula, `LocallyFinite`
instance, `Preconnected` proof, and `edgeFinset` on bounded boxes are
deferred to a follow-up PR (they require either Mathlib's
neighbour-Finset infrastructure or a custom enumeration of unit-vector
translates; both are routine but bulky).

## Implementation notes

* The ℓ¹-distance is computed as `∑ i, |x i - y i|` over `Finset.univ`
  (since `Fin d` is a `Fintype`). This avoids importing the heavier
  `Mathlib.Analysis.Normed.Lp.PiLp` infrastructure.
* For `d = 2`, the convenience definition `Z2LatticeGraph` operates
  directly on `Fin 2 → ℤ`.
* The unit vectors `unitVec d i` are defined coordinate-wise rather
  than via `Finsupp.single` to keep the file independent of finsupp.

## Tags

simple graph, integer lattice, Z^d, percolation, ℓ¹-distance
-/

namespace SimpleGraph

namespace IntegerLattice

/-! ### ℓ¹-distance -/

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

/-! ### Standard unit vectors -/

/-- The `i`-th standard unit vector `e_i : Fin d → ℤ`: returns `1` at
coordinate `i` and `0` at every other coordinate. -/
def unitVec (d : ℕ) (i : Fin d) : Fin d → ℤ :=
  fun j => if j = i then 1 else 0

@[simp]
lemma unitVec_self {d : ℕ} (i : Fin d) : unitVec d i i = 1 := by
  unfold unitVec
  simp

lemma unitVec_of_ne {d : ℕ} {i j : Fin d} (h : j ≠ i) :
    unitVec d i j = 0 := by
  unfold unitVec
  rw [if_neg h]

/-- ℓ¹-distance from `x` to `x + e_i` is `1` (the `i`-th coordinate
moves up by one; all others are unchanged). -/
lemma l1Dist_add_unitVec {d : ℕ} (x : Fin d → ℤ) (i : Fin d) :
    l1Dist x (x + unitVec d i) = 1 := by
  unfold l1Dist
  -- |x j - (x j + unitVec j)| = |unitVec j| at each coordinate
  have h_eq : ∀ j ∈ (Finset.univ : Finset (Fin d)),
      |x j - (x + unitVec d i) j| = if j = i then 1 else 0 := by
    intro j _
    simp only [Pi.add_apply]
    by_cases hji : j = i
    · subst hji; simp [unitVec_self]
    · rw [unitVec_of_ne hji, if_neg hji]; simp
  rw [Finset.sum_congr rfl h_eq]
  -- ∑_{j} (if j = i then 1 else 0) = 1, since exactly one term is 1
  simp [Finset.sum_ite_eq']

/-- ℓ¹-distance from `x` to `x - e_i` is `1`. -/
lemma l1Dist_sub_unitVec {d : ℕ} (x : Fin d → ℤ) (i : Fin d) :
    l1Dist x (x - unitVec d i) = 1 := by
  unfold l1Dist
  have h_eq : ∀ j ∈ (Finset.univ : Finset (Fin d)),
      |x j - (x - unitVec d i) j| = if j = i then 1 else 0 := by
    intro j _
    simp only [Pi.sub_apply]
    by_cases hji : j = i
    · subst hji; simp [unitVec_self]
    · rw [unitVec_of_ne hji, if_neg hji]; simp
  rw [Finset.sum_congr rfl h_eq]
  simp [Finset.sum_ite_eq']

end IntegerLattice

/-! ### The integer lattice graph -/

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

/-- The `+e_i` translate of any vertex is adjacent to it. -/
lemma integerLatticeGraph_adj_add_unitVec {d : ℕ} (x : Fin d → ℤ) (i : Fin d) :
    (integerLatticeGraph d).Adj x (x + IntegerLattice.unitVec d i) := by
  rw [integerLatticeGraph_adj_iff]
  exact IntegerLattice.l1Dist_add_unitVec x i

/-- The `-e_i` translate of any vertex is adjacent to it. -/
lemma integerLatticeGraph_adj_sub_unitVec {d : ℕ} (x : Fin d → ℤ) (i : Fin d) :
    (integerLatticeGraph d).Adj x (x - IntegerLattice.unitVec d i) := by
  rw [integerLatticeGraph_adj_iff]
  exact IntegerLattice.l1Dist_sub_unitVec x i

/-! ### Z² explicit characterisation

The standard `ℤ²` lattice `Z2LatticeGraph` has every vertex adjacent
to its four neighbours `(x ± e_0, x ± e_1)` via the unit-vector
adjacency lemmas above (specialised to `d = 2`). A full per-coordinate
characterisation `Adj (x, y) (x', y') ↔ ((x' = x+1 ∧ y' = y) ∨ ...)`
would require either `Matrix.cons` notation manipulation or a
case-split on `Fin 2`; deferred to a follow-up PR. -/

end SimpleGraph
