/-
  Current-paper two-action alignment theorem.

  The paper works on the affine hull of the simplex and assumes that the
  subjective indifference hyperplane meets its relative interior. Translating
  one such interior boundary point to the origin turns both payoff gaps into
  linear functionals on the affine-hull direction space. This module proves
  the exact centered theorem: convexity of the tie-broken two-action welfare
  is equivalent to a nonnegative scalar alignment of the two gap functionals.
-/

import Mathlib.Analysis.Convex.Continuous
import Mathlib.Analysis.Convex.Function
import Mathlib.Tactic

namespace BlackwellDilemma.CurrentTwoAction

open Filter Set Topology

universe u

variable {E : Type u} [AddCommGroup E] [Module Real E]

/-- The finite-state expected payoff gap between actions `1` and `0`. -/
noncomputable def finitePayoffGap
    {Theta : Type*} [Fintype Theta]
    (payoff : Fin 2 -> Theta -> Real) (mu : Theta -> Real) : Real :=
  Finset.univ.sum fun theta =>
    mu theta * (payoff 1 theta - payoff 0 theta)

/-- The literal subjective indifference set in the manuscript. -/
def subjectiveIndifferenceSet
    {Theta : Type*} [Fintype Theta]
    (subjectivePayoff : Fin 2 -> Theta -> Real) : Set (Theta -> Real) :=
  {mu | finitePayoffGap subjectivePayoff mu = 0}

/-- Subjective payoff gap on the translated direction carrier. -/
noncomputable def centeredSubjectiveGap
    (Dv : E →ₗ[Real] Real) (x : E) : Real := Dv x

/-- Objective payoff gap on the translated direction carrier. -/
noncomputable def centeredObjectiveGap
    (Du : E →ₗ[Real] Real) (boundaryGap : Real) (x : E) : Real :=
  boundaryGap + Du x

/-- The centered payoff-gap formulas after translating the boundary point. -/
theorem centeredGapFormulas
    (Dv Du : E →ₗ[Real] Real) (boundaryGap : Real) (x : E) :
    centeredSubjectiveGap Dv x = Dv x /\
      centeredObjectiveGap Du boundaryGap x = boundaryGap + Du x := by
  exact ⟨rfl, rfl⟩

/-- The tie-broken two-action welfare after translating an interior point of
    the subjective indifference hyperplane to the origin. -/
noncomputable def twoActionWelfare
    (U0 Dv Du : E →ₗ[Real] Real) (x : E) : Real :=
  U0 x + if 0 <= Dv x then Du x else 0

/-- The uncentered boundary carrier. `boundaryGap` is the objective payoff
    gap at the translated subjective indifference point. The paper proof must
    derive that this term is zero; it is not silently discarded. -/
noncomputable def twoActionWelfareWithBoundary
    (U0 Dv Du : E →ₗ[Real] Real) (boundaryGap : Real) (x : E) : Real :=
  U0 x + if 0 <= Dv x then boundaryGap + Du x else 0

/-- The primitive alignment condition from Theorem 3. -/
def PositivelyAligned (Dv Du : E →ₗ[Real] Real) : Prop :=
  exists lambda : Real, 0 <= lambda /\ Du = lambda • Dv

/-- A translated relative-interior domain absorbs every affine-hull
    direction: every direction can be scaled by some positive amount and
    remain in the domain. This is the exact geometric content used by the
    current paper's relative-interior hypothesis. -/
def AbsorbsDirections (C : Set E) : Prop :=
  (0 : E) ∈ C /\ forall x : E, exists t : Real, 0 < t /\ t • x ∈ C

private theorem twoActionWelfare_nonneg_homogeneous
    (U0 Dv Du : E →ₗ[Real] Real) {t : Real} (hT : 0 <= t) (x : E) :
    twoActionWelfare U0 Dv Du (t • x) =
      t * twoActionWelfare U0 Dv Du x := by
  by_cases hSign : 0 <= Dv x
  · have hScaled : 0 <= t * Dv x := mul_nonneg hT hSign
    simp only [twoActionWelfare, map_smul, smul_eq_mul]
    rw [if_pos hScaled, if_pos hSign]
    ring
  · have hNeg : Dv x < 0 := lt_of_not_ge hSign
    by_cases hTZero : t = 0
    · simp [hTZero, twoActionWelfare]
    · have hTPos : 0 < t := lt_of_le_of_ne hT (Ne.symm hTZero)
      have hScaledNeg : t * Dv x < 0 := mul_neg_of_pos_of_neg hTPos hNeg
      have hScaledNot : Not (0 <= t * Dv x) := not_le_of_gt hScaledNeg
      simp only [twoActionWelfare, map_smul, smul_eq_mul]
      rw [if_neg hScaledNot, if_neg hSign]
      ring

private theorem convexOn_univ_of_convexOn_absorbing
    (f : E -> Real) (C : Set E)
    (hC : Convex Real C) (hAbsorb : AbsorbsDirections C)
    (hHomogeneous : forall {t : Real}, 0 <= t -> forall x,
      f (t • x) = t * f x)
    (hConvex : ConvexOn Real C f) :
    ConvexOn Real Set.univ f := by
  refine ⟨convex_univ, ?_⟩
  intro x _hx y _hy a b hA hB hSum
  rcases hAbsorb.2 x with ⟨tx, hTxPos, hTxMem⟩
  rcases hAbsorb.2 y with ⟨ty, hTyPos, hTyMem⟩
  let t : Real := min tx ty
  have hTPos : 0 < t := by
    exact lt_min hTxPos hTyPos
  have hTLeTx : t <= tx := min_le_left _ _
  have hTLeTy : t <= ty := min_le_right _ _
  have hScaledMem : forall (z : E) (tz : Real), 0 < tz ->
      tz • z ∈ C -> t <= tz -> t • z ∈ C := by
    intro z tz hTzPos hTzMem hTLe
    have hRatioNonneg : 0 <= t / tz :=
      div_nonneg hTPos.le hTzPos.le
    have hRatioLe : t / tz <= 1 := (div_le_one hTzPos).2 hTLe
    have hOneMinus : 0 <= 1 - t / tz := sub_nonneg.mpr hRatioLe
    have hWeights : (1 - t / tz) + t / tz = 1 := by ring
    have hMembership := hC hAbsorb.1 hTzMem hOneMinus hRatioNonneg hWeights
    have hScaleIdentity :
        (1 - t / tz) • (0 : E) + (t / tz) • (tz • z) = t • z := by
      rw [smul_zero, zero_add, smul_smul]
      field_simp [hTzPos.ne']
    rwa [hScaleIdentity] at hMembership
  have hTxScaled : t • x ∈ C :=
    hScaledMem x tx hTxPos hTxMem hTLeTx
  have hTyScaled : t • y ∈ C :=
    hScaledMem y ty hTyPos hTyMem hTLeTy
  have hJensen := hConvex.2 hTxScaled hTyScaled hA hB hSum
  have hCombination :
      a • (t • x) + b • (t • y) = t • (a • x + b • y) := by
    module
  rw [hCombination,
    hHomogeneous hTPos.le (a • x + b • y),
    hHomogeneous hTPos.le x,
    hHomogeneous hTPos.le y] at hJensen
  simp only [smul_eq_mul] at hJensen
  have hFactor :
      a * (t * f x) + b * (t * f y) =
        t * (a * f x + b * f y) := by ring
  rw [hFactor] at hJensen
  have hReduced := le_of_mul_le_mul_left hJensen hTPos
  simpa only [smul_eq_mul] using hReduced

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

/-- Theorem 3 on the translated affine-hull domain. The domain assumptions
    are an exact, coordinate-free formulation of an interior posterior:
    it is convex, contains the translated boundary point, and absorbs every
    affine-hull direction. No global-domain substitution is required. -/
theorem twoActionAlignmentOnAbsorbingDomain
    (U0 Dv Du : E →ₗ[Real] Real) (C : Set E)
    (hC : Convex Real C) (hAbsorb : AbsorbsDirections C)
    (hDv : Dv ≠ 0) :
    ConvexOn Real C (twoActionWelfare U0 Dv Du) <->
      PositivelyAligned Dv Du := by
  constructor
  · intro hConvex
    apply (twoActionAlignment U0 Dv Du hDv).1
    exact convexOn_univ_of_convexOn_absorbing
      (twoActionWelfare U0 Dv Du) C hC hAbsorb
      (twoActionWelfare_nonneg_homogeneous U0 Dv Du) hConvex
  · intro hAligned
    have hGlobal := (twoActionAlignment U0 Dv Du hDv).2 hAligned
    exact ⟨hC, fun x _hx y _hy a b hA hB hSum =>
      hGlobal.2 (Set.mem_univ x) (Set.mem_univ y) hA hB hSum⟩

/-- Exact uncentered form of Theorem 3. On a finite-dimensional translated
    relative-interior domain, convexity first forces the objective payoff gap
    at the subjective boundary to vanish. The remaining linear gaps are then
    nonnegatively proportional. -/
theorem twoActionAffineAlignmentOnInteriorDomain
    {F : Type*} [NormedAddCommGroup F] [NormedSpace Real F]
    [FiniteDimensional Real F]
    (U0 Dv Du : F →ₗ[Real] Real) (boundaryGap : Real) (C : Set F)
    (hC : Convex Real C) (hInterior : (0 : F) ∈ interior C)
    (hAbsorb : AbsorbsDirections C) (hDv : Dv ≠ 0) :
    ConvexOn Real C (twoActionWelfareWithBoundary U0 Dv Du boundaryGap) <->
      boundaryGap = 0 /\ PositivelyAligned Dv Du := by
  constructor
  · intro hConvex
    have hContinuousAt :
        ContinuousAt (twoActionWelfareWithBoundary U0 Dv Du boundaryGap) 0 := by
      have hWithin := hConvex.continuousOn_interior 0 hInterior
      exact hWithin.continuousAt (isOpen_interior.mem_nhds hInterior)
    rcases exists_map_pos Dv hDv with ⟨z, hZ⟩
    let path : Real -> F := fun t => (-t) • z
    have hPathContinuous : Continuous path := by
      exact continuous_id.neg.smul continuous_const
    have hPath : Tendsto path (nhdsWithin 0 (Set.Ioi 0)) (nhds 0) := by
      have hAt : Tendsto path (nhds 0) (nhds (path 0)) :=
        hPathContinuous.continuousAt
      simpa [path] using hAt.mono_left inf_le_left
    have hFunctionLimit :
        Tendsto
          (fun t => twoActionWelfareWithBoundary U0 Dv Du boundaryGap (path t))
          (nhdsWithin 0 (Set.Ioi 0))
          (nhds (twoActionWelfareWithBoundary U0 Dv Du boundaryGap 0)) :=
      hContinuousAt.tendsto.comp hPath
    have hLinearLimit :
        Tendsto (fun t => U0 (path t))
          (nhdsWithin 0 (Set.Ioi 0)) (nhds 0) := by
      have hAt := U0.continuous_of_finiteDimensional.continuousAt.tendsto.comp hPath
      simpa using hAt
    have hEventuallyEqual :
        (fun t => twoActionWelfareWithBoundary U0 Dv Du boundaryGap (path t))
          =ᶠ[nhdsWithin 0 (Set.Ioi 0)] (fun t => U0 (path t)) := by
      filter_upwards [self_mem_nhdsWithin] with t hT
      have hTPos : 0 < t := hT
      have hNegative : Not (0 <= Dv (path t)) := by
        dsimp [path]
        simp only [map_smul, smul_eq_mul]
        exact not_le_of_gt (mul_neg_of_neg_of_pos (neg_neg_of_pos hTPos) hZ)
      simp [twoActionWelfareWithBoundary, hNegative]
    have hFunctionZero :
        Tendsto
          (fun t => twoActionWelfareWithBoundary U0 Dv Du boundaryGap (path t))
          (nhdsWithin 0 (Set.Ioi 0)) (nhds 0) :=
      hLinearLimit.congr' hEventuallyEqual.symm
    have hBoundaryValue :
        twoActionWelfareWithBoundary U0 Dv Du boundaryGap 0 = 0 :=
      tendsto_nhds_unique hFunctionLimit hFunctionZero
    have hBoundaryGap : boundaryGap = 0 := by
      simpa [twoActionWelfareWithBoundary] using hBoundaryValue
    refine ⟨hBoundaryGap, ?_⟩
    apply (twoActionAlignmentOnAbsorbingDomain U0 Dv Du C hC hAbsorb hDv).1
    have hCarrier :
        twoActionWelfareWithBoundary U0 Dv Du boundaryGap =
          twoActionWelfare U0 Dv Du := by
      funext x
      simp [twoActionWelfareWithBoundary, twoActionWelfare, hBoundaryGap]
    rwa [← hCarrier]
  · rintro ⟨rfl, hAligned⟩
    have hCarrier :
        twoActionWelfareWithBoundary U0 Dv Du 0 =
          twoActionWelfare U0 Dv Du := by
      funext x
      simp [twoActionWelfareWithBoundary, twoActionWelfare]
    rw [hCarrier]
    exact (twoActionAlignmentOnAbsorbingDomain U0 Dv Du C hC hAbsorb hDv).2
      hAligned

/-- An objectively adverse tie-broken boundary switch (`boundaryGap < 0`)
    cannot have convex induced welfare on the translated posterior carrier. -/
theorem adverseBoundary_not_convex
    {F : Type*} [NormedAddCommGroup F] [NormedSpace Real F]
    [FiniteDimensional Real F]
    (U0 Dv Du : F →ₗ[Real] Real) (boundaryGap : Real) (C : Set F)
    (hC : Convex Real C) (hInterior : (0 : F) ∈ interior C)
    (hAbsorb : AbsorbsDirections C) (hDv : Dv ≠ 0)
    (hAdverse : boundaryGap < 0) :
    Not (ConvexOn Real C
      (twoActionWelfareWithBoundary U0 Dv Du boundaryGap)) := by
  intro hConvex
  have hBoundary :=
    (twoActionAffineAlignmentOnInteriorDomain
      U0 Dv Du boundaryGap C hC hInterior hAbsorb hDv).1 hConvex |>.1
  linarith

end BlackwellDilemma.CurrentTwoAction
