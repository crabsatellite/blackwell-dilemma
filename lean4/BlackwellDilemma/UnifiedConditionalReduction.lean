/-
  BlackwellDilemma/UnifiedConditionalReduction.lean

  Finite comparison-of-experiments theorem and its conditional-on-reachable-
  set specialization. The theorem is proved directly from stochastic-kernel
  composition; the Blackwell (1953) reference supplies attribution, not an
  unproved Lean premise.
-/

import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Data.Real.Archimedean
import Mathlib.Order.ConditionallyCompleteLattice.Basic
import Mathlib.Tactic.Ring

namespace BlackwellDilemma.ConditionalReduction

open scoped BigOperators

universe u v w x

/-- A finite stochastic kernel. -/
structure FiniteKernel (X : Type u) (Y : Type v) [Fintype Y] where
  prob : X -> Y -> Real
  prob_nonneg : forall x y, 0 <= prob x y
  prob_sum_one : forall x, Finset.univ.sum (prob x) = 1

namespace FiniteKernel

variable {X : Type u} {Y : Type v} {Z : Type w} {T : Type x}
variable [Fintype Y] [Fintype Z] [Fintype T]

@[ext]
theorem ext (K L : FiniteKernel X Y) (h : K.prob = L.prob) : K = L := by
  cases K
  cases L
  simp_all

/-- Composition of two finite stochastic kernels. -/
def comp (K : FiniteKernel X Y) (L : FiniteKernel Y Z) : FiniteKernel X Z where
  prob x z := Finset.univ.sum (fun y => K.prob x y * L.prob y z)
  prob_nonneg x z := Finset.sum_nonneg (fun y _ =>
    mul_nonneg (K.prob_nonneg x y) (L.prob_nonneg y z))
  prob_sum_one x := by
    rw [Finset.sum_comm]
    simp_rw [<- Finset.mul_sum, L.prob_sum_one]
    simp [K.prob_sum_one]

@[simp]
theorem comp_prob (K : FiniteKernel X Y) (L : FiniteKernel Y Z) (x : X) (z : Z) :
    (K.comp L).prob x z = Finset.univ.sum (fun y => K.prob x y * L.prob y z) :=
  rfl

/-- Stochastic-kernel composition is associative. -/
theorem comp_assoc (K : FiniteKernel X Y) (L : FiniteKernel Y Z)
    (M : FiniteKernel Z T) :
    (K.comp L).comp M = K.comp (L.comp M) := by
  apply FiniteKernel.ext
  funext x t
  simp only [comp_prob]
  calc
    Finset.univ.sum (fun z =>
        (Finset.univ.sum (fun y => K.prob x y * L.prob y z)) * M.prob z t) =
        Finset.univ.sum (fun z => Finset.univ.sum (fun y =>
          (K.prob x y * L.prob y z) * M.prob z t)) := by
            apply Finset.sum_congr rfl
            intro z _
            rw [Finset.sum_mul]
    _ = Finset.univ.sum (fun y => Finset.univ.sum (fun z =>
          (K.prob x y * L.prob y z) * M.prob z t)) := Finset.sum_comm
    _ = Finset.univ.sum (fun y =>
          K.prob x y * Finset.univ.sum (fun z => L.prob y z * M.prob z t)) := by
            apply Finset.sum_congr rfl
            intro y _
            rw [Finset.mul_sum]
            apply Finset.sum_congr rfl
            intro z _
            ring

/-- The deterministic rule induced by a function. -/
noncomputable def deterministic [Fintype Z] [Nonempty Z]
    (f : Y -> Z) : FiniteKernel Y Z := by
  classical
  refine
    { prob := fun y z => if z = f y then 1 else 0
      prob_nonneg := ?_
      prob_sum_one := ?_ }
  · intro y z
    split <;> norm_num
  · intro y
    simp

end FiniteKernel

/-- A probability distribution on a finite type. -/
structure FiniteDistribution (X : Type u) [Fintype X] where
  prob : X -> Real
  prob_nonneg : forall x, 0 <= prob x
  prob_sum_one : Finset.univ.sum prob = 1

variable {State : Type u} {Signal : Type v} {Action : Type w}
variable [Fintype State] [Fintype Signal] [Fintype Action]

/-- Expected utility after an experiment followed by a decision rule. -/
noncomputable def expectedUtility
    (prior : FiniteDistribution State)
    (experiment : FiniteKernel State Signal)
    (rule : FiniteKernel Signal Action)
    (utility : State -> Action -> Real) : Real :=
  Finset.univ.sum (fun omega =>
    prior.prob omega * Finset.univ.sum (fun action =>
      (experiment.comp rule).prob omega action * utility omega action))

/-- Every decision after a garbled experiment has exactly the same payoff as
    the composed decision rule after the more informative experiment. -/
theorem expectedUtility_garbling_identity
    {FineSignal : Type v} {CoarseSignal : Type x}
    [Fintype FineSignal] [Fintype CoarseSignal]
    (prior : FiniteDistribution State)
    (fine : FiniteKernel State FineSignal)
    (garbling : FiniteKernel FineSignal CoarseSignal)
    (coarseRule : FiniteKernel CoarseSignal Action)
    (utility : State -> Action -> Real) :
    expectedUtility prior (fine.comp garbling) coarseRule utility =
      expectedUtility prior fine (garbling.comp coarseRule) utility := by
  unfold expectedUtility
  rw [FiniteKernel.comp_assoc]

/-- Attainable expected utilities for all stochastic decision rules. -/
def attainableValues
    (prior : FiniteDistribution State)
    (experiment : FiniteKernel State Signal)
    (utility : State -> Action -> Real) : Set Real :=
  Set.range (fun rule : FiniteKernel Signal Action =>
    expectedUtility prior experiment rule utility)

/-- The finite decision problem's optimal value. -/
noncomputable def optimalValue
    (prior : FiniteDistribution State)
    (experiment : FiniteKernel State Signal)
    (utility : State -> Action -> Real) : Real :=
  sSup (attainableValues prior experiment utility)

theorem attainableValues_nonempty [Nonempty Action]
    (prior : FiniteDistribution State)
    (experiment : FiniteKernel State Signal)
    (utility : State -> Action -> Real) :
    (attainableValues prior experiment utility).Nonempty := by
  classical
  let a0 : Action := Classical.choice inferInstance
  let rule : FiniteKernel Signal Action :=
    FiniteKernel.deterministic (fun _ => a0)
  exact Set.range_nonempty_iff_nonempty.mpr <| Nonempty.intro rule

/-- Bounded utility makes the set of attainable expected utilities bounded
    above. This discharges the only order-completeness side condition used by
    `sSup`. -/
theorem expectedUtility_le_of_utility_le
    (prior : FiniteDistribution State)
    (experiment : FiniteKernel State Signal)
    (rule : FiniteKernel Signal Action)
    (utility : State -> Action -> Real) (upper : Real)
    (hUtility : forall omega action, utility omega action <= upper) :
    expectedUtility prior experiment rule utility <= upper := by
  let actionKernel := experiment.comp rule
  unfold expectedUtility
  calc
    Finset.univ.sum (fun omega =>
        prior.prob omega * Finset.univ.sum (fun action =>
          actionKernel.prob omega action * utility omega action)) <=
        Finset.univ.sum (fun omega => prior.prob omega * upper) := by
          apply Finset.sum_le_sum
          intro omega _
          apply mul_le_mul_of_nonneg_left _ (prior.prob_nonneg omega)
          calc
            Finset.univ.sum (fun action =>
                actionKernel.prob omega action * utility omega action) <=
                Finset.univ.sum (fun action =>
                  actionKernel.prob omega action * upper) := by
                    apply Finset.sum_le_sum
                    intro action _
                    exact mul_le_mul_of_nonneg_left
                      (hUtility omega action) (actionKernel.prob_nonneg omega action)
            _ = upper := by
              rw [<- Finset.sum_mul, actionKernel.prob_sum_one]
              simp
    _ = upper := by
      rw [<- Finset.sum_mul, prior.prob_sum_one]
      simp

theorem attainableValues_bddAbove
    (prior : FiniteDistribution State)
    (experiment : FiniteKernel State Signal)
    (utility : State -> Action -> Real) (upper : Real)
    (hUtility : forall omega action, utility omega action <= upper) :
    BddAbove (attainableValues prior experiment utility) := by
  refine ⟨upper, ?_⟩
  intro value hValue
  obtain ⟨rule, rfl⟩ := hValue
  exact expectedUtility_le_of_utility_le
    prior experiment rule utility upper hUtility

/-- The forward direction of the finite Blackwell comparison theorem:
    garbling cannot increase the optimal value of a fixed decision problem. -/
theorem optimalValue_mono_under_garbling
    {FineSignal : Type v} {CoarseSignal : Type x}
    [Fintype FineSignal] [Fintype CoarseSignal] [Nonempty Action]
    (prior : FiniteDistribution State)
    (fine : FiniteKernel State FineSignal)
    (garbling : FiniteKernel FineSignal CoarseSignal)
    (utility : State -> Action -> Real) (upper : Real)
    (hUtility : forall omega action, utility omega action <= upper) :
    optimalValue prior (fine.comp garbling) utility <=
      optimalValue prior fine utility := by
  apply csSup_le_csSup
    (attainableValues_bddAbove prior fine utility upper hUtility)
    (attainableValues_nonempty prior (fine.comp garbling) utility)
  intro value hValue
  obtain ⟨coarseRule, rfl⟩ := hValue
  refine ⟨garbling.comp coarseRule, ?_⟩
  exact (expectedUtility_garbling_identity
    prior fine garbling coarseRule utility).symm

section ReachableSetAggregation

variable {Reachable : Type u} [Fintype Reachable]

/-- Finite expectation over reachable-set realizations. -/
def reachableExpectation (distribution : FiniteDistribution Reachable)
    (value : Reachable -> Real) : Real :=
  Finset.univ.sum (fun reachable => distribution.prob reachable * value reachable)

/-- Pointwise conditional value dominance survives averaging over a fixed,
    signal-independent reachable-set distribution. -/
theorem reachableExpectation_mono
    (distribution : FiniteDistribution Reachable)
    {coarseValue fineValue : Reachable -> Real}
    (hValue : forall reachable, coarseValue reachable <= fineValue reachable) :
    reachableExpectation distribution coarseValue <=
      reachableExpectation distribution fineValue := by
  apply Finset.sum_le_sum
  intro reachable _
  exact mul_le_mul_of_nonneg_left
    (hValue reachable) (distribution.prob_nonneg reachable)

/-- The topological component depends only on the reachable-set distribution
    and its oracle benchmark, so changing the signal leaves it unchanged. -/
def topologyComponent (distribution : FiniteDistribution Reachable)
    (topologyValue : Reachable -> Real) (_signal : Signal) : Real :=
  reachableExpectation distribution topologyValue

omit [Fintype Signal] in
theorem topologyComponent_signal_invariant
    (distribution : FiniteDistribution Reachable)
    (topologyValue : Reachable -> Real) (signal1 signal2 : Signal) :
    topologyComponent distribution topologyValue signal1 =
      topologyComponent distribution topologyValue signal2 :=
  rfl

/-- Exact total-welfare decomposition into a signal-independent topological
    component and the residual informational component. -/
theorem total_eq_topology_add_information
    (distribution : FiniteDistribution Reachable)
    (total topology : Reachable -> Real) :
    reachableExpectation distribution total =
      reachableExpectation distribution topology +
        reachableExpectation distribution (fun reachable =>
          total reachable - topology reachable) := by
  unfold reachableExpectation
  rw [<- Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro reachable _
  ring

end ReachableSetAggregation

/-- Machine-facing bundle for paper Lemma `lem:conditional-reduction`. -/
def ConditionalReductionClaim : Prop :=
  (forall
      (State FineSignal CoarseSignal Action : Type)
      (_ : Fintype State) (_ : Fintype FineSignal)
      (_ : Fintype CoarseSignal) (_ : Fintype Action)
      (_ : Nonempty Action)
      (prior : FiniteDistribution State)
      (fine : FiniteKernel State FineSignal)
      (garbling : FiniteKernel FineSignal CoarseSignal)
      (utility : State -> Action -> Real) (upper : Real),
      (forall omega action, utility omega action <= upper) ->
      optimalValue prior (fine.comp garbling) utility <=
        optimalValue prior fine utility) /\
  (forall
      (Reachable : Type) (_ : Fintype Reachable)
      (distribution : FiniteDistribution Reachable)
      (coarseValue fineValue : Reachable -> Real),
      (forall reachable, coarseValue reachable <= fineValue reachable) ->
      reachableExpectation distribution coarseValue <=
        reachableExpectation distribution fineValue) /\
  (forall
      (Reachable : Type) (_ : Fintype Reachable)
      (distribution : FiniteDistribution Reachable)
      (total topology : Reachable -> Real),
      reachableExpectation distribution total =
        reachableExpectation distribution topology +
          reachableExpectation distribution (fun reachable =>
            total reachable - topology reachable))

theorem conditionalReductionClaim_proved : ConditionalReductionClaim := by
  refine ⟨?_, ?_, ?_⟩
  · intro State FineSignal CoarseSignal Action _ _ _ _ _
      prior fine garbling utility upper hUtility
    exact optimalValue_mono_under_garbling
      prior fine garbling utility upper hUtility
  · intro Reachable _ distribution coarseValue fineValue hValue
    exact reachableExpectation_mono distribution hValue
  · intro Reachable _ distribution total topology
    exact total_eq_topology_add_information distribution total topology

end BlackwellDilemma.ConditionalReduction
