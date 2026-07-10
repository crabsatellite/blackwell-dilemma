/-
  BlackwellDilemma/UnifiedTrapPrevalence.lean

  A finite local square-grid event that forces static/dynamic ranking reversal.
  The event exposes all incident edges of the four relevant grid vertices:
  three are open and ten are blocked. Three disjoint Uniform[0,1] reward
  windows then give a positive explicit product-mass lower bound.
-/

import BlackwellDilemma.Infrastructure.FiniteLocalTrapEvent
import Mathlib.Combinatorics.SimpleGraph.Connectivity.Finite
import Mathlib.MeasureTheory.Constructions.UnitInterval
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum

namespace BlackwellDilemma.TrapPrevalence

open MeasureTheory

abbrev GridPoint := Int × Int

def gridNeighbors (point : GridPoint) : Finset GridPoint :=
  {(point.1 + 1, point.2), (point.1 - 1, point.2),
    (point.1, point.2 + 1), (point.1, point.2 - 1)}

def GridAdjacent (left right : GridPoint) : Prop :=
  right ∈ gridNeighbors left

inductive LocalVertex where
  | root
  | trap
  | bridge
  | continuation
  deriving DecidableEq, Fintype

namespace LocalVertex

def point : LocalVertex -> GridPoint
  | root => (0, 0)
  | trap => (-1, 0)
  | bridge => (1, 0)
  | continuation => (2, 0)

def openAdj : LocalVertex -> LocalVertex -> Prop
  | root, trap | trap, root => True
  | root, bridge | bridge, root => True
  | bridge, continuation | continuation, bridge => True
  | _, _ => False

theorem openAdj_symm : Symmetric openAdj := by
  intro left right h
  cases left <;> cases right <;> simp [openAdj] at h ⊢

@[reducible] def openAdj_loopless : Std.Irrefl openAdj where
  irrefl vertex := by
    cases vertex <;> simp [openAdj]

def openGraph : SimpleGraph LocalVertex where
  Adj := openAdj
  symm := openAdj_symm
  loopless := openAdj_loopless

/-- The graph after the already-visited root is removed. -/
def postRootAdj : LocalVertex -> LocalVertex -> Prop
  | bridge, continuation | continuation, bridge => True
  | _, _ => False

theorem postRootAdj_symm : Symmetric postRootAdj := by
  intro left right h
  cases left <;> cases right <;> simp [postRootAdj] at h ⊢

@[reducible] def postRootAdj_loopless : Std.Irrefl postRootAdj where
  irrefl vertex := by
    cases vertex <;> simp [postRootAdj]

def postRootGraph : SimpleGraph LocalVertex where
  Adj := postRootAdj
  symm := postRootAdj_symm
  loopless := postRootAdj_loopless

theorem postRootAdj_iff_openAdj_without_root (left right : LocalVertex) :
    postRootGraph.Adj left right ↔
      openGraph.Adj left right /\ left ≠ root /\ right ≠ root := by
  cases left <;> cases right <;> simp [postRootGraph, postRootAdj,
    openGraph, openAdj]

theorem open_edges_embed_in_square_grid {left right : LocalVertex}
    (h : openGraph.Adj left right) :
    GridAdjacent left.point right.point := by
  cases left <;> cases right <;>
    simp [openGraph, openAdj, GridAdjacent, gridNeighbors, point] at h ⊢

theorem postRoot_reachable_trap_iff (vertex : LocalVertex) :
    postRootGraph.Reachable trap vertex ↔ vertex = trap := by
  constructor
  · rintro ⟨walk⟩
    cases walk with
    | nil => rfl
    | cons h _ =>
        simp [postRootGraph, postRootAdj] at h
  · rintro rfl
    exact SimpleGraph.Reachable.refl trap

theorem postRootAdj_preserves_bridge_pair {left right : LocalVertex}
    (hLeft : left = bridge ∨ left = continuation)
    (hAdj : postRootGraph.Adj left right) :
    right = bridge ∨ right = continuation := by
  rcases hLeft with rfl | rfl <;>
    cases right <;> simp [postRootGraph, postRootAdj] at hAdj ⊢

theorem postRootWalk_from_bridge_pair {left right : LocalVertex}
    (hLeft : left = bridge ∨ left = continuation)
    (walk : postRootGraph.Walk left right) :
    right = bridge ∨ right = continuation := by
  induction walk with
  | nil => exact hLeft
  | cons hAdj walk ih =>
      exact ih (postRootAdj_preserves_bridge_pair hLeft hAdj)

theorem postRoot_reachable_bridge_iff (vertex : LocalVertex) :
    postRootGraph.Reachable bridge vertex ↔
      vertex = bridge ∨ vertex = continuation := by
  constructor
  · rintro ⟨walk⟩
    exact postRootWalk_from_bridge_pair (Or.inl rfl) walk
  · rintro (rfl | rfl)
    · exact SimpleGraph.Reachable.refl bridge
    · exact (show postRootGraph.Adj bridge continuation by
        simp [postRootGraph, postRootAdj]).reachable

noncomputable def reachableSet (start : LocalVertex) : Finset LocalVertex := by
  classical
  exact Finset.univ.filter (postRootGraph.Reachable start)

theorem reachableSet_nonempty (start : LocalVertex) :
    (reachableSet start).Nonempty := by
  classical
  refine ⟨start, ?_⟩
  simp [reachableSet]

theorem reachableSet_trap : reachableSet trap = {trap} := by
  classical
  ext vertex
  simp [reachableSet, postRoot_reachable_trap_iff]

theorem reachableSet_bridge :
    reachableSet bridge = {bridge, continuation} := by
  classical
  ext vertex
  simp [reachableSet, postRoot_reachable_bridge_iff]

def reward
    (trapReward bridgeReward continuationReward : Real) :
    LocalVertex -> Real
  | root => 0
  | trap => trapReward
  | bridge => bridgeReward
  | continuation => continuationReward

noncomputable def dynamicValue
    (trapReward bridgeReward continuationReward : Real)
    (start : LocalVertex) : Real :=
  let values := (reachableSet start).image
    (reward trapReward bridgeReward continuationReward)
  values.max' ((reachableSet_nonempty start).image _)

theorem dynamicValue_trap
    (trapReward bridgeReward continuationReward : Real) :
    dynamicValue trapReward bridgeReward continuationReward trap =
      trapReward := by
  simp [dynamicValue, reachableSet_trap, reward]

theorem dynamicValue_bridge
    (trapReward bridgeReward continuationReward : Real) :
    dynamicValue trapReward bridgeReward continuationReward bridge =
      max bridgeReward continuationReward := by
  simp [dynamicValue, reachableSet_bridge, reward]

end LocalVertex

inductive LocalEdge where
  | rootTrap
  | rootBridge
  | bridgeContinuation
  | rootUp
  | rootDown
  | trapLeft
  | trapUp
  | trapDown
  | bridgeUp
  | bridgeDown
  | continuationRight
  | continuationUp
  | continuationDown
  deriving DecidableEq, Fintype

namespace LocalEdge

def endpoints : LocalEdge -> GridPoint × GridPoint
  | rootTrap => ((-1, 0), (0, 0))
  | rootBridge => ((0, 0), (1, 0))
  | bridgeContinuation => ((1, 0), (2, 0))
  | rootUp => ((0, 0), (0, 1))
  | rootDown => ((0, -1), (0, 0))
  | trapLeft => ((-2, 0), (-1, 0))
  | trapUp => ((-1, 0), (-1, 1))
  | trapDown => ((-1, -1), (-1, 0))
  | bridgeUp => ((1, 0), (1, 1))
  | bridgeDown => ((1, -1), (1, 0))
  | continuationRight => ((2, 0), (3, 0))
  | continuationUp => ((2, 0), (2, 1))
  | continuationDown => ((2, -1), (2, 0))

def isOpen : LocalEdge -> Bool
  | rootTrap | rootBridge | bridgeContinuation => true
  | _ => false

theorem endpoints_injective : Function.Injective endpoints := by
  intro left right h
  fin_cases left <;> fin_cases right <;>
    simp [endpoints] at h ⊢

theorem endpoints_gridAdjacent (edge : LocalEdge) :
    GridAdjacent (endpoints edge).1 (endpoints edge).2 := by
  cases edge <;> norm_num [GridAdjacent, gridNeighbors, endpoints]

theorem open_count :
    (Finset.univ.filter fun edge : LocalEdge => isOpen edge = true).card = 3 := by
  decide

theorem open_edges_eq :
    (Finset.univ.filter fun edge : LocalEdge => isOpen edge = true) =
      {rootTrap, rootBridge, bridgeContinuation} := by
  decide

theorem blocked_count :
    (Finset.univ.filter fun edge : LocalEdge => isOpen edge = false).card = 10 := by
  decide

theorem univ_eq : (Finset.univ : Finset LocalEdge) =
    {rootTrap, rootBridge, bridgeContinuation, rootUp, rootDown,
      trapLeft, trapUp, trapDown, bridgeUp, bridgeDown,
      continuationRight, continuationUp, continuationDown} := by
  decide

def otherEndpointsAt (point : GridPoint) (edge : LocalEdge) :
    Finset GridPoint :=
  if (endpoints edge).1 = point then {(endpoints edge).2}
  else if (endpoints edge).2 = point then {(endpoints edge).1}
  else ∅

def supportNeighbors (point : GridPoint) : Finset GridPoint :=
  Finset.univ.biUnion (otherEndpointsAt point)

theorem supportNeighbors_at_localVertex (vertex : LocalVertex) :
    supportNeighbors vertex.point = gridNeighbors vertex.point := by
  cases vertex <;>
    simp [supportNeighbors, otherEndpointsAt, univ_eq, gridNeighbors,
      LocalVertex.point, endpoints, Finset.biUnion_insert] <;>
    decide

end LocalEdge

def supportedOpenEdges : Finset (GridPoint × GridPoint) :=
  (Finset.univ.filter fun edge : LocalEdge =>
      LocalEdge.isOpen edge = true).biUnion fun edge =>
        {LocalEdge.endpoints edge,
          ((LocalEdge.endpoints edge).2, (LocalEdge.endpoints edge).1)}

def SupportedOpenAdjacent (left right : GridPoint) : Prop :=
  (left, right) ∈ supportedOpenEdges

theorem supportedOpenAdjacent_iff_localOpenGraph
    (left right : LocalVertex) :
    SupportedOpenAdjacent left.point right.point ↔
      LocalVertex.openGraph.Adj left right := by
  cases left <;> cases right <;>
    simp [SupportedOpenAdjacent, supportedOpenEdges, LocalEdge.open_edges_eq,
      LocalEdge.endpoints,
      LocalVertex.point, LocalVertex.openGraph, LocalVertex.openAdj]

inductive RewardWindow where
  | trap
  | bridge
  | continuation
  deriving DecidableEq, Fintype

noncomputable def rewardWindowMass : RewardWindow -> Real
  | .trap => 1 / 6
  | .bridge => 1 / 3
  | .continuation => 1 / 6

noncomputable def half : unitInterval := ⟨1 / 2, by constructor <;> norm_num⟩

noncomputable def twoThirds : unitInterval := ⟨2 / 3, by constructor <;> norm_num⟩

noncomputable def oneThird : unitInterval := ⟨1 / 3, by constructor <;> norm_num⟩

noncomputable def fiveSixths : unitInterval := ⟨5 / 6, by constructor <;> norm_num⟩

def zero : unitInterval := ⟨0, by constructor <;> norm_num⟩

def one : unitInterval := ⟨1, by constructor <;> norm_num⟩

def rewardWindowSet : RewardWindow -> Set unitInterval
  | .trap => Set.Ioo half twoThirds
  | .bridge => Set.Ioo zero oneThird
  | .continuation => Set.Ioo fiveSixths one

theorem rewardWindowSet_volume (window : RewardWindow) :
    volume (rewardWindowSet window) =
      ENNReal.ofReal (rewardWindowMass window) := by
  cases window <;>
    norm_num [rewardWindowSet, rewardWindowMass, unitInterval.volume_Ioo,
      half, twoThirds, zero, oneThird, fiveSixths, one]

theorem rewardWindow_univ_eq : (Finset.univ : Finset RewardWindow) =
    {.trap, .bridge, .continuation} := by
  decide

noncomputable def independentWindowWeight
    (windowState : RewardWindow -> Bool) : Real :=
  Finset.univ.prod fun window =>
    if windowState window then rewardWindowMass window
    else 1 - rewardWindowMass window

theorem independentWindowWeight_univ_total :
    Finset.univ.sum independentWindowWeight = 1 := by
  classical
  unfold independentWindowWeight
  have hprodSum :
      (Finset.univ.prod fun window : RewardWindow =>
        Finset.univ.sum fun state : Bool =>
          if state then rewardWindowMass window
          else 1 - rewardWindowMass window) =
        Finset.univ.sum fun windowState : RewardWindow -> Bool =>
          Finset.univ.prod fun window : RewardWindow =>
            if windowState window then rewardWindowMass window
            else 1 - rewardWindowMass window := by
    simpa using Fintype.prod_sum (fun window : RewardWindow => fun state : Bool =>
      if state then rewardWindowMass window else 1 - rewardWindowMass window)
  rw [← hprodSum]
  simp

theorem independentWindowWeight_nonneg
    (windowState : RewardWindow -> Bool) :
    0 <= independentWindowWeight windowState := by
  unfold independentWindowWeight
  apply Finset.prod_nonneg
  intro window _
  fin_cases window <;> simp only [rewardWindowMass] <;>
    split <;> norm_num

def targetRewardWindowState : RewardWindow -> Bool := fun _ => true

theorem targetRewardWindowState_weight :
    independentWindowWeight targetRewardWindowState = 1 / 108 := by
  unfold independentWindowWeight
  rw [rewardWindow_univ_eq]
  simp [targetRewardWindowState, rewardWindowMass, Finset.prod_insert]
  norm_num

abbrev LocalOutcome :=
  (LocalEdge -> Bool) × (RewardWindow -> Bool)

noncomputable def localOutcomeWeight (p : Real) (outcome : LocalOutcome) : Real :=
  Infrastructure.bernoulliWeight (1 - p) Finset.univ outcome.1 *
    independentWindowWeight outcome.2

theorem localOutcomeWeight_univ_total (p : Real) :
    Finset.univ.sum (localOutcomeWeight p) = 1 := by
  rw [Fintype.sum_prod_type]
  simp only [localOutcomeWeight]
  rw [← Fintype.sum_mul_sum,
    Infrastructure.bernoulliWeight_univ_total,
    independentWindowWeight_univ_total, one_mul]

theorem localOutcomeWeight_nonneg
    (p : Real) (hp : 0 <= p) (hpOne : p <= 1)
    (outcome : LocalOutcome) :
    0 <= localOutcomeWeight p outcome := by
  apply mul_nonneg
  · have hOpen : 0 <= 1 - p /\ 1 - p <= 1 := by
      constructor <;> linarith
    exact Infrastructure.bernoulliWeight_nonneg Finset.univ hOpen outcome.1
  · exact independentWindowWeight_nonneg outcome.2

def targetLocalOutcome : LocalOutcome :=
  (LocalEdge.isOpen, targetRewardWindowState)

theorem localPatternMass_eq_lowerBound (p : Real) :
    Infrastructure.finiteJointPatternMass
      (Finset.univ : Finset LocalEdge)
      (Finset.univ : Finset RewardWindow)
      p LocalEdge.isOpen rewardWindowMass =
        Infrastructure.immediateTrapLocalPatternLowerBound p := by
  rw [LocalEdge.univ_eq, rewardWindow_univ_eq]
  simp [Infrastructure.finiteJointPatternMass,
    Infrastructure.bernoulliWeight, Infrastructure.bernoulliFactor,
    Infrastructure.immediateTrapLocalPatternLowerBound,
    LocalEdge.isOpen, rewardWindowMass, Finset.prod_insert]
  ring

theorem targetLocalOutcome_weight (p : Real) :
    localOutcomeWeight p targetLocalOutcome =
      Infrastructure.immediateTrapLocalPatternLowerBound p := by
  rw [show localOutcomeWeight p targetLocalOutcome =
      Infrastructure.finiteJointPatternMass
        (Finset.univ : Finset LocalEdge)
        (Finset.univ : Finset RewardWindow)
        p LocalEdge.isOpen rewardWindowMass by
    simp [localOutcomeWeight, targetLocalOutcome,
      targetRewardWindowState, independentWindowWeight,
      Infrastructure.finiteJointPatternMass]]
  exact localPatternMass_eq_lowerBound p

theorem rewardWindows_force_static_dynamic_reversal
    (trapReward bridgeReward continuationReward : Real)
    (hTrapLower : (1 / 2 : Real) < trapReward)
    (hTrapUpper : trapReward < (2 / 3 : Real))
    (_hBridgeLower : 0 < bridgeReward)
    (hBridgeUpper : bridgeReward < (1 / 3 : Real))
    (hContinuationLower : (5 / 6 : Real) < continuationReward)
    (hContinuationUpper : continuationReward < 1) :
    LocalVertex.reward trapReward bridgeReward continuationReward
        LocalVertex.trap >
      LocalVertex.reward trapReward bridgeReward continuationReward
        LocalVertex.bridge /\
    LocalVertex.dynamicValue trapReward bridgeReward continuationReward
        LocalVertex.trap <
      LocalVertex.dynamicValue trapReward bridgeReward continuationReward
        LocalVertex.bridge := by
  rw [LocalVertex.dynamicValue_trap, LocalVertex.dynamicValue_bridge]
  simp only [LocalVertex.reward]
  have hBridgeContinuation : bridgeReward < continuationReward := by linarith
  rw [max_eq_right hBridgeContinuation.le]
  constructor <;> linarith

def TrapPrevalenceClaim : Prop :=
  (Function.Injective LocalEdge.endpoints) /\
  (forall edge, GridAdjacent
    (LocalEdge.endpoints edge).1 (LocalEdge.endpoints edge).2) /\
  (forall vertex : LocalVertex,
    LocalEdge.supportNeighbors vertex.point = gridNeighbors vertex.point) /\
  (forall left right, LocalVertex.openGraph.Adj left right ->
    GridAdjacent left.point right.point) /\
  (forall left right,
    SupportedOpenAdjacent left.point right.point ↔
      LocalVertex.openGraph.Adj left right) /\
  LocalVertex.reachableSet LocalVertex.trap = {LocalVertex.trap} /\
  LocalVertex.reachableSet LocalVertex.bridge =
    {LocalVertex.bridge, LocalVertex.continuation} /\
  (Finset.univ.filter fun edge : LocalEdge =>
      LocalEdge.isOpen edge = true).card = 3 /\
  (Finset.univ.filter fun edge : LocalEdge =>
      LocalEdge.isOpen edge = false).card = 10 /\
  (forall window, volume (rewardWindowSet window) =
    ENNReal.ofReal (rewardWindowMass window)) /\
  (forall p : Real, Finset.univ.sum (localOutcomeWeight p) = 1) /\
  (forall p : Real, 0 <= p -> p <= 1 -> forall outcome,
    0 <= localOutcomeWeight p outcome) /\
  (forall p : Real,
    Infrastructure.finiteJointPatternMass
      (Finset.univ : Finset LocalEdge)
      (Finset.univ : Finset RewardWindow)
      p LocalEdge.isOpen rewardWindowMass =
        Infrastructure.immediateTrapLocalPatternLowerBound p) /\
  (forall p : Real, 0 < p -> p < 1 ->
    0 < Infrastructure.immediateTrapLocalPatternLowerBound p) /\
  (forall p : Real,
    localOutcomeWeight p targetLocalOutcome =
      Infrastructure.immediateTrapLocalPatternLowerBound p) /\
  (forall trapReward bridgeReward continuationReward : Real,
    (1 / 2 : Real) < trapReward ->
    trapReward < (2 / 3 : Real) ->
    0 < bridgeReward ->
    bridgeReward < (1 / 3 : Real) ->
    (5 / 6 : Real) < continuationReward ->
    continuationReward < 1 ->
    LocalVertex.reward trapReward bridgeReward continuationReward
        LocalVertex.trap >
      LocalVertex.reward trapReward bridgeReward continuationReward
        LocalVertex.bridge /\
    LocalVertex.dynamicValue trapReward bridgeReward continuationReward
        LocalVertex.trap <
      LocalVertex.dynamicValue trapReward bridgeReward continuationReward
        LocalVertex.bridge)

theorem trapPrevalenceClaim_proved : TrapPrevalenceClaim := by
  refine ⟨LocalEdge.endpoints_injective, LocalEdge.endpoints_gridAdjacent,
    LocalEdge.supportNeighbors_at_localVertex,
    (fun _left _right h => LocalVertex.open_edges_embed_in_square_grid h),
    supportedOpenAdjacent_iff_localOpenGraph,
    LocalVertex.reachableSet_trap, LocalVertex.reachableSet_bridge,
    LocalEdge.open_count, LocalEdge.blocked_count,
    rewardWindowSet_volume, localOutcomeWeight_univ_total,
    localOutcomeWeight_nonneg, localPatternMass_eq_lowerBound, ?_,
    targetLocalOutcome_weight, ?_⟩
  · intro p hp hpOne
    exact Infrastructure.immediateTrapLocalPatternLowerBound_pos p hp hpOne
  · exact rewardWindows_force_static_dynamic_reversal

end BlackwellDilemma.TrapPrevalence
