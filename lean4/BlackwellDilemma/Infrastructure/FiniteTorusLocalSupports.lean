/- Finite two-dimensional torus indices and separated local supports. -/

import BlackwellDilemma.Infrastructure.SeparatedBlockPlacements

namespace BlackwellDilemma.Infrastructure

/-- Two-dimensional torus vertex carrier with side length `side + 1`. -/
abbrev FiniteTorusVertex (side : Nat) : Type :=
  Fin (side + 1) × Fin (side + 1)

/-- Horizontal or vertical edge slot based at a torus vertex. -/
abbrev FiniteTorusEdge (side : Nat) : Type :=
  Fin 2 × FiniteTorusVertex side

/-- Cyclic successor on one torus coordinate. -/
def finiteCycleSucc (side : Nat) (coordinate : Fin (side + 1)) :
    Fin (side + 1) :=
  Fin.mk ((coordinate.val + 1) % (side + 1))
    (Nat.mod_lt _ (Nat.succ_pos side))

theorem nat_ne_successor_mod_self
    (modulus residue : Nat) (hModulus : 1 < modulus)
    (hResidue : residue < modulus) :
    Not (residue = (residue + 1) % modulus) := by
  intro hEqual
  have hSuccessorLe : residue + 1 <= modulus :=
    Nat.succ_le_of_lt hResidue
  by_cases hStrict : residue + 1 < modulus
  · have hMod : (residue + 1) % modulus = residue + 1 :=
      Nat.mod_eq_of_lt hStrict
    rw [hMod] at hEqual
    exact (Nat.ne_of_lt (Nat.lt_succ_self residue)) hEqual
  · have hAtBoundary : residue + 1 = modulus :=
      Nat.le_antisymm hSuccessorLe (Nat.le_of_not_gt hStrict)
    have hMod : (residue + 1) % modulus = 0 := by
      rw [hAtBoundary]
      exact Nat.mod_self modulus
    rw [hMod] at hEqual
    have hResiduePositive : 0 < residue := by
      by_contra hNotPositive
      have hResidueZero : residue = 0 := Nat.eq_zero_of_not_pos hNotPositive
      rw [hResidueZero] at hAtBoundary
      simp only [zero_add] at hAtBoundary
      exact (Nat.ne_of_gt hModulus) hAtBoundary.symm
    exact (Nat.ne_of_gt hResiduePositive) hEqual

theorem finiteCycleSucc_ne_self
    (side : Nat) (hSide : 0 < side)
    (coordinate : Fin (side + 1)) :
    finiteCycleSucc side coordinate ≠ coordinate := by
  intro hEqual
  have hValue := congrArg Fin.val hEqual
  change (coordinate.val + 1) % (side + 1) = coordinate.val at hValue
  exact nat_ne_successor_mod_self
    (side + 1) coordinate.val
    (Nat.succ_lt_succ hSide) coordinate.isLt hValue.symm

/-- Direction zero is horizontal; direction one is vertical. -/
def finiteTorusEdgeEndpoints
    (side : Nat) (edge : FiniteTorusEdge side) :
    FiniteTorusVertex side × FiniteTorusVertex side :=
  let source := edge.2
  let target :=
    if edge.1.val = 0 then
      (finiteCycleSucc side source.1, source.2)
    else
      (source.1, finiteCycleSucc side source.2)
  (source, target)

theorem finiteTorusEdgeEndpoints_loopless
    (side : Nat) (hSide : 0 < side)
    (edge : FiniteTorusEdge side) :
    (finiteTorusEdgeEndpoints side edge).1 ≠
      (finiteTorusEdgeEndpoints side edge).2 := by
  dsimp [finiteTorusEdgeEndpoints]
  by_cases hHorizontal : edge.1.val = 0
  · rw [if_pos hHorizontal]
    intro hEndpoints
    have hFirst := congrArg Prod.fst hEndpoints
    exact (finiteCycleSucc_ne_self side hSide edge.2.1) hFirst.symm
  · rw [if_neg hHorizontal]
    intro hEndpoints
    have hSecond := congrArg Prod.snd hEndpoints
    exact (finiteCycleSucc_ne_self side hSide edge.2.2) hSecond.symm

theorem finiteTorusVertex_card (side : Nat) :
    Fintype.card (FiniteTorusVertex side) =
      (side + 1) * (side + 1) := by
  simp [Fintype.card_prod]

theorem finiteTorusEdge_card (side : Nat) :
    Fintype.card (FiniteTorusEdge side) =
      2 * ((side + 1) * (side + 1)) := by
  simp [Fintype.card_prod]

/-- Reward-variable support in row zero whose horizontal coordinate belongs
to a translated coordinate block. -/
def torusRowBlockRewardSupport
    (side width placement : Nat) : Finset (FiniteTorusVertex side) :=
  Finset.univ.filter (fun vertex =>
    vertex.2.val = 0 /\
      vertex.1.val ∈ translatedBlockSupport width placement)

/-- Edge-variable support based in row zero and in the same horizontal block.
Both horizontal and vertical edge slots are retained. -/
def torusRowBlockEdgeSupport
    (side width placement : Nat) : Finset (FiniteTorusEdge side) :=
  Finset.univ.filter (fun edge =>
    edge.2.2.val = 0 /\
      edge.2.1.val ∈ translatedBlockSupport width placement)

theorem torusRowBlockRewardSupport_disjoint_of_lt
    (side width : Nat) {left right : Nat}
    (hLeftRight : left < right) :
    Disjoint (torusRowBlockRewardSupport side width left)
      (torusRowBlockRewardSupport side width right) := by
  rw [Finset.disjoint_left]
  intro vertex hLeft hRight
  simp only [torusRowBlockRewardSupport, Finset.mem_filter,
    Finset.mem_univ, true_and] at hLeft hRight
  exact Finset.disjoint_left.mp
    (translatedBlockSupport_disjoint_of_lt width hLeftRight)
    hLeft.2 hRight.2

theorem torusRowBlockEdgeSupport_disjoint_of_lt
    (side width : Nat) {left right : Nat}
    (hLeftRight : left < right) :
    Disjoint (torusRowBlockEdgeSupport side width left)
      (torusRowBlockEdgeSupport side width right) := by
  rw [Finset.disjoint_left]
  intro edge hLeft hRight
  simp only [torusRowBlockEdgeSupport, Finset.mem_filter,
    Finset.mem_univ, true_and] at hLeft hRight
  exact Finset.disjoint_left.mp
    (translatedBlockSupport_disjoint_of_lt width hLeftRight)
    hLeft.2 hRight.2

theorem torusRowBlockRewardSupport_pairwiseDisjoint
    (side width : Nat) :
    Pairwise (fun left right =>
      Disjoint (torusRowBlockRewardSupport side width left)
        (torusRowBlockRewardSupport side width right)) := by
  intro left right hNe
  rcases lt_or_gt_of_ne hNe with hLeftRight | hRightLeft
  · exact torusRowBlockRewardSupport_disjoint_of_lt
      side width hLeftRight
  · exact (torusRowBlockRewardSupport_disjoint_of_lt
      side width hRightLeft).symm

theorem torusRowBlockEdgeSupport_pairwiseDisjoint
    (side width : Nat) :
    Pairwise (fun left right =>
      Disjoint (torusRowBlockEdgeSupport side width left)
        (torusRowBlockEdgeSupport side width right)) := by
  intro left right hNe
  rcases lt_or_gt_of_ne hNe with hLeftRight | hRightLeft
  · exact torusRowBlockEdgeSupport_disjoint_of_lt
      side width hLeftRight
  · exact (torusRowBlockEdgeSupport_disjoint_of_lt
      side width hRightLeft).symm

theorem torusRowBlockSupports_nonempty
    (side width placement : Nat)
    (hWidth : 0 < width)
    (hPlacement : placement < blockPlacementCount side width) :
    (torusRowBlockRewardSupport side width placement).Nonempty /\
      (torusRowBlockEdgeSupport side width placement).Nonempty := by
  have hStartInBlock :
      placement * width ∈ translatedBlockSupport width placement := by
    simp only [translatedBlockSupport, Finset.mem_Ico, le_refl, true_and]
    exact Nat.mul_lt_mul_of_pos_right (Nat.lt_succ_self placement) hWidth
  have hStartInRange :
      placement * width ∈ Finset.range side :=
    translatedBlockSupport_subset_range
      side width placement hPlacement hStartInBlock
  have hStartLtSide : placement * width < side :=
    Finset.mem_range.mp hStartInRange
  let horizontal : Fin (side + 1) :=
    Fin.mk (placement * width)
      (hStartLtSide.trans (Nat.lt_succ_self side))
  let rowZero : Fin (side + 1) := 0
  let vertex : FiniteTorusVertex side := (horizontal, rowZero)
  have hVertex :
      vertex ∈ torusRowBlockRewardSupport side width placement := by
    simp [torusRowBlockRewardSupport, vertex, horizontal, rowZero,
      hStartInBlock]
  let horizontalDirection : Fin 2 := 0
  let edge : FiniteTorusEdge side := (horizontalDirection, vertex)
  have hEdge : edge ∈ torusRowBlockEdgeSupport side width placement := by
    simp [torusRowBlockEdgeSupport, edge, horizontalDirection,
      vertex, horizontal, rowZero, hStartInBlock]
  exact And.intro ⟨vertex, hVertex⟩ ⟨edge, hEdge⟩

def FiniteTorusSeparatedSupportPrinciple : Prop :=
  (forall side : Nat, 0 < side ->
      forall edge : FiniteTorusEdge side,
        (finiteTorusEdgeEndpoints side edge).1 ≠
          (finiteTorusEdgeEndpoints side edge).2) /\
    (forall side width : Nat,
      Pairwise (fun left right =>
        Disjoint (torusRowBlockRewardSupport side width left)
          (torusRowBlockRewardSupport side width right))) /\
    (forall side width : Nat,
      Pairwise (fun left right =>
        Disjoint (torusRowBlockEdgeSupport side width left)
          (torusRowBlockEdgeSupport side width right))) /\
    (forall side width placement : Nat,
      0 < width ->
      placement < blockPlacementCount side width ->
      (torusRowBlockRewardSupport side width placement).Nonempty /\
        (torusRowBlockEdgeSupport side width placement).Nonempty)

theorem finiteTorusSeparatedSupportPrinciple_proved :
    FiniteTorusSeparatedSupportPrinciple := by
  exact And.intro
    finiteTorusEdgeEndpoints_loopless
    (And.intro
      torusRowBlockRewardSupport_pairwiseDisjoint
      (And.intro
        torusRowBlockEdgeSupport_pairwiseDisjoint
        torusRowBlockSupports_nonempty))

def Part6FiniteTorusSupportKernelBundle : Prop :=
  Part6SeparatedPlacementKernelBundle /\
    FiniteTorusSeparatedSupportPrinciple

theorem part6FiniteTorusSupportKernelBundle_proved :
    Part6FiniteTorusSupportKernelBundle := by
  exact And.intro
    part6SeparatedPlacementKernelBundle_proved
    finiteTorusSeparatedSupportPrinciple_proved

end BlackwellDilemma.Infrastructure
