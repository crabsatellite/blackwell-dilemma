/-
  Current-paper two-action alignment theorem.

  The paper works on the affine hull of the simplex and assumes that the
  subjective indifference hyperplane meets its relative interior. Translating
  one such interior boundary point to the origin turns both payoff gaps into
  linear functionals on the affine-hull direction space. This module proves
  the exact centered theorem: convexity of the tie-broken two-action welfare
  is equivalent to a nonnegative scalar alignment of the two gap functionals.
-/

import Mathlib.Analysis.Convex.Function
import Mathlib.Tactic

namespace BlackwellDilemma.CurrentTwoAction

universe u

variable {E : Type u} [AddCommGroup E] [Module Real E]

/-- The tie-broken two-action welfare after translating an interior point of
    the subjective indifference hyperplane to the origin. -/
noncomputable def twoActionWelfare
    (U0 Dv Du : E →ₗ[Real] Real) (x : E) : Real :=
  U0 x + if 0 <= Dv x then Du x else 0

/-- The primitive alignment condition from Theorem 3. -/
def PositivelyAligned (Dv Du : E →ₗ[Real] Real) : Prop :=
  exists lambda : Real, 0 <= lambda /\ Du = lambda • Dv

private theorem exists_map_pos (Dv : E →ₗ[Real] Real) (hDv : Dv ≠ 0) :
    exists z : E, 0 < Dv z := by
  have hExists : exists z : E, Dv z ≠ 0 := by
    by_contra hNone
    apply hDv
    ext z
    have hz : Dv z = 0 := by
      by_contra hne
      exact hNone ⟨z, hne⟩
    simpa using hz
  rcases hExists with ⟨z, hz⟩
  rcases lt_or_gt_of_ne hz with hNeg | hPos
  · exact ⟨-z, by simpa using neg_pos.mpr hNeg⟩
  · exact ⟨z, hPos⟩

private theorem boundary_upper_bound
    (U0 Dv Du : E →ₗ[Real] Real)
    (hConvex : ConvexOn Real Set.univ (twoActionWelfare U0 Dv Du))
    {x z : E} (hX : Dv x = 0) (hZ : 0 < Dv z) :
    Du x <= Du z := by
  have hJensen := hConvex.2 (Set.mem_univ (x - z))
    (Set.mem_univ (x + z))
    (by norm_num : (0 : Real) <= 1 / 2)
    (by norm_num : (0 : Real) <= 1 / 2)
    (by norm_num : (1 / 2 : Real) + 1 / 2 = 1)
  have hMid : (1 / 2 : Real) • (x - z) + (1 / 2 : Real) • (x + z) = x := by
    module
  have hZNotLe : Not (Dv z <= 0) := not_le_of_gt hZ
  rw [hMid] at hJensen
  simp [twoActionWelfare, hX, hZNotLe, map_sub, map_add]
    at hJensen
  simp [hZ.le] at hJensen
  linarith

private theorem boundary_lower_bound
    (U0 Dv Du : E →ₗ[Real] Real)
    (hConvex : ConvexOn Real Set.univ (twoActionWelfare U0 Dv Du))
    {x z : E} (hX : Dv x = 0) (hZ : 0 < Dv z) :
    0 <= Du x := by
  have hJensen := hConvex.2 (Set.mem_univ x)
    (Set.mem_univ (x - (2 : Real) • z))
    (by norm_num : (0 : Real) <= 1 / 2)
    (by norm_num : (0 : Real) <= 1 / 2)
    (by norm_num : (1 / 2 : Real) + 1 / 2 = 1)
  have hMid : (1 / 2 : Real) • x +
      (1 / 2 : Real) • (x - (2 : Real) • z) = x - z := by
    module
  have hZNotLe : Not (Dv z <= 0) := not_le_of_gt hZ
  have hTwoZNotLe : Not ((2 : Real) * Dv z <= 0) := by
    exact not_le_of_gt (mul_pos (by norm_num) hZ)
  rw [hMid] at hJensen
  simp [twoActionWelfare, hX, hZNotLe,
    hTwoZNotLe, map_sub, map_smul] at hJensen
  linarith

private theorem objectiveGap_zero_on_subjective_boundary
    (U0 Dv Du : E →ₗ[Real] Real) (hDv : Dv ≠ 0)
    (hConvex : ConvexOn Real Set.univ (twoActionWelfare U0 Dv Du)) :
    forall x : E, Dv x = 0 -> Du x = 0 := by
  rcases exists_map_pos Dv hDv with ⟨z, hZ⟩
  intro x hX
  have hLower : 0 <= Du x :=
    boundary_lower_bound U0 Dv Du hConvex hX hZ
  have hNotPos : Not (0 < Du x) := by
    intro hPosX
    let c : Real := Du z / Du x + 1
    let z' : E := z - c • x
    have hZ' : 0 < Dv z' := by
      simp [z', map_sub, map_smul, hX, hZ]
    have hUpper := boundary_upper_bound U0 Dv Du hConvex hX hZ'
    have hDuZ' : Du z' = -Du x := by
      dsimp [z', c]
      simp only [map_sub, map_smul, smul_eq_mul]
      rw [add_mul, div_mul_cancel₀ (Du z) hPosX.ne']
      ring
    rw [hDuZ'] at hUpper
    linarith
  exact le_antisymm (le_of_not_gt hNotPos) hLower

private theorem proportional_of_boundary_zero
    (Dv Du : E →ₗ[Real] Real) (hDv : Dv ≠ 0)
    (hBoundary : forall x : E, Dv x = 0 -> Du x = 0) :
    exists lambda : Real, Du = lambda • Dv := by
  have hExists : exists z : E, Dv z ≠ 0 := by
    by_contra hNone
    apply hDv
    ext z
    have hz : Dv z = 0 := by
      by_contra hne
      exact hNone ⟨z, hne⟩
    simpa using hz
  rcases hExists with ⟨z, hZ⟩
  let lambda : Real := Du z / Dv z
  refine ⟨lambda, ?_⟩
  ext x
  let y : E := x - (Dv x / Dv z) • z
  have hY : Dv y = 0 := by
    dsimp [y]
    simp only [map_sub, map_smul, smul_eq_mul]
    rw [div_mul_cancel₀ (Dv x) hZ]
    ring
  have hDuY := hBoundary y hY
  dsimp [y] at hDuY
  simp only [map_sub, map_smul] at hDuY
  change Du x = lambda * Dv x
  dsimp [lambda]
  calc
    Du x = (Dv x / Dv z) * Du z := sub_eq_zero.mp hDuY
    _ = (Du z / Dv z) * Dv x := by field_simp [hZ]

private theorem aligned_welfare_convex
    (U0 Dv : E →ₗ[Real] Real) {lambda : Real} (hLambda : 0 <= lambda) :
    ConvexOn Real Set.univ
      (fun x => U0 x + lambda * max (Dv x) 0) := by
  refine ⟨convex_univ, ?_⟩
  intro x _hx y _hy a b hA hB hSum
  have hX : Dv x <= max (Dv x) 0 := le_max_left _ _
  have hY : Dv y <= max (Dv y) 0 := le_max_left _ _
  have hZeroX : 0 <= max (Dv x) 0 := le_max_right _ _
  have hZeroY : 0 <= max (Dv y) 0 := le_max_right _ _
  have hMax :
      max (a * Dv x + b * Dv y) 0 <=
        a * max (Dv x) 0 + b * max (Dv y) 0 := by
    apply max_le
    · exact add_le_add (mul_le_mul_of_nonneg_left hX hA)
        (mul_le_mul_of_nonneg_left hY hB)
    · exact add_nonneg (mul_nonneg hA hZeroX) (mul_nonneg hB hZeroY)
  simp only [map_add, map_smul, smul_eq_mul]
  nlinarith

private theorem twoActionWelfare_eq_aligned
    (U0 Dv Du : E →ₗ[Real] Real) {lambda : Real}
    (hAligned : Du = lambda • Dv) :
    twoActionWelfare U0 Dv Du =
      (fun x => U0 x + lambda * max (Dv x) 0) := by
  funext x
  by_cases hSign : 0 <= Dv x
  · simp [twoActionWelfare, hSign, hAligned]
  · have hNonpos : Dv x <= 0 := le_of_not_ge hSign
    simp [twoActionWelfare, hSign, max_eq_right hNonpos]

private theorem alignment_scalar_nonnegative
    (U0 Dv Du : E →ₗ[Real] Real) (hDv : Dv ≠ 0)
    (hConvex : ConvexOn Real Set.univ (twoActionWelfare U0 Dv Du))
    {lambda : Real} (hAligned : Du = lambda • Dv) :
    0 <= lambda := by
  rcases exists_map_pos Dv hDv with ⟨z, hZ⟩
  have hJensen := hConvex.2 (Set.mem_univ (-z)) (Set.mem_univ z)
    (by norm_num : (0 : Real) <= 1 / 2)
    (by norm_num : (0 : Real) <= 1 / 2)
    (by norm_num : (1 / 2 : Real) + 1 / 2 = 1)
  have hMid : (1 / 2 : Real) • (-z) + (1 / 2 : Real) • z = (0 : E) := by
    module
  have hZNotLe : Not (Dv z <= 0) := not_le_of_gt hZ
  rw [hMid] at hJensen
  simp [twoActionWelfare, hZ.le, hZNotLe, hAligned] at hJensen
  nlinarith

/-- Theorem 3 (two-action alignment), on the translated affine-hull direction
    space: the induced welfare is convex exactly when the objective and
    subjective payoff-gap functionals are nonnegative scalar multiples. -/
theorem twoActionAlignment
    (U0 Dv Du : E →ₗ[Real] Real) (hDv : Dv ≠ 0) :
    ConvexOn Real Set.univ (twoActionWelfare U0 Dv Du) <->
      PositivelyAligned Dv Du := by
  constructor
  · intro hConvex
    have hBoundary :=
      objectiveGap_zero_on_subjective_boundary U0 Dv Du hDv hConvex
    rcases proportional_of_boundary_zero Dv Du hDv hBoundary with
      ⟨lambda, hAligned⟩
    exact ⟨lambda,
      alignment_scalar_nonnegative U0 Dv Du hDv hConvex hAligned,
      hAligned⟩
  · rintro ⟨lambda, hLambda, hAligned⟩
    rw [twoActionWelfare_eq_aligned U0 Dv Du hAligned]
    exact aligned_welfare_convex U0 Dv hLambda

end BlackwellDilemma.CurrentTwoAction
