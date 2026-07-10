/- Disjoint finite placements for repeated bounded-support local events. -/

import BlackwellDilemma.Infrastructure.FiniteLocalTrapEvent
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Data.Finset.Interval

namespace BlackwellDilemma.Infrastructure

open Filter Topology

/-- The coordinate support of block `placement`, with fixed natural width.
These half-open blocks can be placed inside one row of a finite torus without
using wrap-around coordinates. -/
def translatedBlockSupport (width placement : Nat) : Finset Nat :=
  Finset.Ico (placement * width) ((placement + 1) * width)

theorem translatedBlockSupport_disjoint_of_lt
    (width : Nat) {left right : Nat} (hLeftRight : left < right) :
    Disjoint (translatedBlockSupport width left)
      (translatedBlockSupport width right) := by
  rw [Finset.disjoint_left]
  intro coordinate hLeft hRight
  simp only [translatedBlockSupport, Finset.mem_Ico] at hLeft hRight
  have hSeparated :
      (left + 1) * width <= right * width :=
    Nat.mul_le_mul_right width (Nat.succ_le_iff.mpr hLeftRight)
  exact (not_lt_of_ge hRight.1) (hLeft.2.trans_le hSeparated)

theorem translatedBlockSupport_pairwiseDisjoint (width : Nat) :
    Pairwise (fun left right =>
      Disjoint (translatedBlockSupport width left)
        (translatedBlockSupport width right)) := by
  intro left right hNe
  rcases lt_or_gt_of_ne hNe with hLeftRight | hRightLeft
  · exact translatedBlockSupport_disjoint_of_lt width hLeftRight
  · exact (translatedBlockSupport_disjoint_of_lt width hRightLeft).symm

/-- Number of full width-`width` blocks that fit in a coordinate side. -/
def blockPlacementCount (side width : Nat) : Nat :=
  side / width

theorem translatedBlockSupport_subset_range
    (side width placement : Nat)
    (hPlacement : placement < blockPlacementCount side width) :
    translatedBlockSupport width placement ⊆ Finset.range side := by
  intro coordinate hCoordinate
  simp only [translatedBlockSupport, Finset.mem_Ico] at hCoordinate
  simp only [Finset.mem_range]
  have hSuccessor :
      placement + 1 <= side / width :=
    Nat.succ_le_iff.mpr hPlacement
  have hScaled :
      (placement + 1) * width <= (side / width) * width :=
    Nat.mul_le_mul_right width hSuccessor
  exact hCoordinate.2.trans_le
    (hScaled.trans (Nat.div_mul_le_self side width))

theorem blockPlacementCount_tendsto_atTop
    (width : Nat) (hWidth : width ≠ 0) :
    Tendsto (fun side => blockPlacementCount side width) atTop atTop := by
  simpa [blockPlacementCount] using Nat.tendsto_div_const_atTop hWidth

/-- Positive-probability local blocks placed with a fixed nonzero width give
an at-least-one occurrence probability tending to one as side length grows.
This theorem uses only the disjoint-trial formula; identifying the blocks with
paper-specific torus edge/reward events remains a separate obligation. -/
theorem independentBlockAmplificationAtSide
    (width : Nat) (hWidth : width ≠ 0)
    (rho : Real) (hPositive : 0 < rho) (hAtMostOne : rho <= 1) :
    Tendsto (fun side : Nat =>
      1 - (1 - rho) ^ blockPlacementCount side width)
      atTop (nhds 1) := by
  exact independentTrialAmplificationAlong
    (fun side => blockPlacementCount side width)
    (blockPlacementCount_tendsto_atTop width hWidth)
    rho hPositive hAtMostOne

def SeparatedBlockPlacementPrinciple : Prop :=
  (forall width : Nat,
      Pairwise (fun left right =>
        Disjoint (translatedBlockSupport width left)
          (translatedBlockSupport width right))) /\
    (forall side width placement : Nat,
      placement < blockPlacementCount side width ->
      translatedBlockSupport width placement ⊆ Finset.range side) /\
    (forall width : Nat, width ≠ 0 ->
      Tendsto (fun side => blockPlacementCount side width) atTop atTop) /\
    (forall width : Nat, width ≠ 0 ->
      forall rho : Real, 0 < rho -> rho <= 1 ->
      Tendsto (fun side : Nat =>
        1 - (1 - rho) ^ blockPlacementCount side width)
        atTop (nhds 1))

theorem separatedBlockPlacementPrinciple_proved :
    SeparatedBlockPlacementPrinciple := by
  exact And.intro
    translatedBlockSupport_pairwiseDisjoint
    (And.intro
      translatedBlockSupport_subset_range
      (And.intro
        blockPlacementCount_tendsto_atTop
        independentBlockAmplificationAtSide))

def Part6SeparatedPlacementKernelBundle : Prop :=
  Part6LocalPatternKernelBundle /\ SeparatedBlockPlacementPrinciple

theorem part6SeparatedPlacementKernelBundle_proved :
    Part6SeparatedPlacementKernelBundle := by
  exact And.intro
    part6LocalPatternKernelBundle_proved
    separatedBlockPlacementPrinciple_proved

end BlackwellDilemma.Infrastructure
