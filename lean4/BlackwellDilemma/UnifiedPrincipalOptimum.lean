/-
  BlackwellDilemma/UnifiedPrincipalOptimum.lean

  Exact finite-population disclosure results. The interior optimum follows
  from explicit continuity, uniform-tail, and positive-improvement premises;
  comparative statics follow from finite-sum increasing differences; and a
  separate two-type reduced form witnesses a strict precision valley.
-/

import BlackwellDilemma.Infrastructure.ArgmaxExistence
import BlackwellDilemma.Infrastructure.DifferenceDominatesFinsetSum

namespace BlackwellDilemma.PrincipalOptimum

open Set
open BlackwellDilemma.Infrastructure

noncomputable def aggregateWelfare {Agent : Type*}
    (agents : Finset Agent) (weight : Agent -> Real)
    (welfare : Agent -> Real -> Real) (beta : Real) : Real :=
  agents.sum (fun i => weight i * welfare i beta)

theorem aggregateWelfare_continuousOn
    {Agent : Type*} (agents : Finset Agent) (weight : Agent -> Real)
    (welfare : Agent -> Real -> Real)
    (hContinuous : forall i, i ∈ agents ->
      ContinuousOn (welfare i) (Set.Ici 0)) :
    ContinuousOn (aggregateWelfare agents weight welfare) (Set.Ici 0) := by
  unfold aggregateWelfare
  apply continuousOn_finsetSum
  intro i hi
  exact (hContinuous i hi).const_smul (weight i)

theorem aggregateWelfare_tail_dominated
    {Agent : Type*} (agents : Finset Agent) (weight : Agent -> Real)
    (welfare : Agent -> Real -> Real) (tailStart : Real)
    (hWeight : forall i, i ∈ agents -> 0 <= weight i)
    (hTail : forall i, i ∈ agents -> forall beta,
      tailStart <= beta -> welfare i beta <= welfare i tailStart) :
    forall beta, tailStart <= beta ->
      aggregateWelfare agents weight welfare beta <=
        aggregateWelfare agents weight welfare tailStart := by
  intro beta hBeta
  unfold aggregateWelfare
  apply Finset.sum_le_sum
  intro i hi
  exact mul_le_mul_of_nonneg_left (hTail i hi beta hBeta) (hWeight i hi)

theorem positive_argmax_exists
    (f : Real -> Real) (tailStart : Real)
    (hTailStart : 0 <= tailStart)
    (hContinuous : ContinuousOn f (Set.Ici 0))
    (hTail : forall beta, tailStart <= beta -> f beta <= f tailStart)
    (hImprovement : exists betaPlus, 0 < betaPlus /\ f 0 < f betaPlus) :
    exists betaStar, 0 < betaStar /\
      forall beta, 0 <= beta -> f beta <= f betaStar := by
  obtain ⟨betaStar, hBetaStarNonnegative, hBetaStarMax⟩ :=
    argmax_exists_of_continuous_eventually_decreasing
      f tailStart hTailStart hContinuous hTail
  obtain ⟨betaPlus, hBetaPlus, hStrictImprovement⟩ := hImprovement
  have hBetaStarPositive : 0 < betaStar := by
    by_contra hNotPositive
    have hBetaStarNonpositive : betaStar <= 0 := le_of_not_gt hNotPositive
    have hBetaStarZero : betaStar = 0 :=
      le_antisymm hBetaStarNonpositive hBetaStarNonnegative
    have hDominance := hBetaStarMax betaPlus hBetaPlus.le
    rw [hBetaStarZero] at hDominance
    exact (not_lt_of_ge hDominance) hStrictImprovement
  exact ⟨betaStar, hBetaStarPositive, hBetaStarMax⟩

theorem finitePopulation_positive_argmax_exists
    {Agent : Type*} (agents : Finset Agent) (weight : Agent -> Real)
    (welfare : Agent -> Real -> Real) (tailStart : Real)
    (hWeight : forall i, i ∈ agents -> 0 <= weight i)
    (_hWeightSum : agents.sum weight = 1)
    (hTailStart : 0 <= tailStart)
    (hContinuous : forall i, i ∈ agents ->
      ContinuousOn (welfare i) (Set.Ici 0))
    (hTail : forall i, i ∈ agents -> forall beta,
      tailStart <= beta -> welfare i beta <= welfare i tailStart)
    (hImprovement : exists betaPlus, 0 < betaPlus /\
      aggregateWelfare agents weight welfare 0 <
        aggregateWelfare agents weight welfare betaPlus) :
    exists betaStar, 0 < betaStar /\ forall beta, 0 <= beta ->
      aggregateWelfare agents weight welfare beta <=
        aggregateWelfare agents weight welfare betaStar := by
  exact positive_argmax_exists
    (aggregateWelfare agents weight welfare) tailStart hTailStart
    (aggregateWelfare_continuousOn agents weight welfare hContinuous)
    (aggregateWelfare_tail_dominated
      agents weight welfare tailStart hWeight hTail)
    hImprovement

def IsUniqueArgmaxOnNonnegative (f : Real -> Real) (betaStar : Real) : Prop :=
  0 <= betaStar /\
  (forall beta, 0 <= beta -> f beta <= f betaStar) /\
  (forall beta, 0 <= beta -> f beta = f betaStar -> beta = betaStar)

theorem optimalPrecision_mono_of_differenceDominance
    {lowWelfare highWelfare : Real -> Real}
    {betaLow betaHigh : Real}
    (hLow : IsUniqueArgmaxOnNonnegative lowWelfare betaLow)
    (hHigh : IsUniqueArgmaxOnNonnegative highWelfare betaHigh)
    (hDifference : DifferenceDominates highWelfare lowWelfare) :
    betaLow <= betaHigh := by
  by_contra hNotLe
  have hHighLtLow : betaHigh < betaLow := lt_of_not_ge hNotLe
  have hIncrement := hDifference betaHigh betaLow hHighLtLow.le
  have hLowOptimal := hLow.2.1 betaHigh hHigh.1
  have hHighOptimal := hHigh.2.1 betaLow hLow.1
  have hLowTie : lowWelfare betaHigh = lowWelfare betaLow := by
    linarith
  have hSameBeta := hLow.2.2 betaHigh hHigh.1 hLowTie
  linarith

theorem finitePopulation_differenceDominates
    {Agent : Type*} (agents : Finset Agent) (weight : Agent -> Real)
    (lowWelfare highWelfare : Agent -> Real -> Real)
    (hWeight : forall i, i ∈ agents -> 0 <= weight i)
    (hDifference : forall i, i ∈ agents ->
      DifferenceDominates (highWelfare i) (lowWelfare i)) :
    DifferenceDominates
      (aggregateWelfare agents weight highWelfare)
      (aggregateWelfare agents weight lowWelfare) := by
  unfold aggregateWelfare
  exact DifferenceDominates.finset_sum_smul_nonneg
    agents weight highWelfare lowWelfare hWeight hDifference

theorem finitePopulation_optimalPrecision_mono
    {Agent : Type*} (agents : Finset Agent) (weight : Agent -> Real)
    (lowWelfare highWelfare : Agent -> Real -> Real)
    {betaLow betaHigh : Real}
    (hWeight : forall i, i ∈ agents -> 0 <= weight i)
    (hDifference : forall i, i ∈ agents ->
      DifferenceDominates (highWelfare i) (lowWelfare i))
    (hLow : IsUniqueArgmaxOnNonnegative
      (aggregateWelfare agents weight lowWelfare) betaLow)
    (hHigh : IsUniqueArgmaxOnNonnegative
      (aggregateWelfare agents weight highWelfare) betaHigh) :
    betaLow <= betaHigh := by
  exact optimalPrecision_mono_of_differenceDominance hLow hHigh
    (finitePopulation_differenceDominates
      agents weight lowWelfare highWelfare hWeight hDifference)

noncomputable def equippedTypeWelfare (beta : Real) : Real := beta

noncomputable def reversalTypeWelfare (beta : Real) : Real :=
  max (4 - 4 * beta) 0

noncomputable def twoTypeAggregateWelfare (beta : Real) : Real :=
  (equippedTypeWelfare beta + reversalTypeWelfare beta) / 2

def HasStrictValley (f : Real -> Real) : Prop :=
  exists betaLow betaMiddle betaHigh,
    betaLow < betaMiddle /\ betaMiddle < betaHigh /\
    f betaMiddle < f betaLow /\ f betaMiddle < f betaHigh

theorem twoTypeAggregateWelfare_continuous :
    Continuous twoTypeAggregateWelfare := by
  unfold twoTypeAggregateWelfare equippedTypeWelfare reversalTypeWelfare
  fun_prop

theorem twoTypeAggregateWelfare_strictValley :
    HasStrictValley twoTypeAggregateWelfare := by
  refine ⟨0, 1, 2, by norm_num, by norm_num, ?_, ?_⟩
  all_goals norm_num [twoTypeAggregateWelfare,
    equippedTypeWelfare, reversalTypeWelfare]

def PrincipalOptimumClaim : Prop :=
  (forall (Agent : Type) (agents : Finset Agent)
      (weight : Agent -> Real) (welfare : Agent -> Real -> Real)
      (tailStart : Real),
    (forall i, i ∈ agents -> 0 <= weight i) ->
    agents.sum weight = 1 ->
    0 <= tailStart ->
    (forall i, i ∈ agents ->
      ContinuousOn (welfare i) (Set.Ici 0)) ->
    (forall i, i ∈ agents -> forall beta,
      tailStart <= beta -> welfare i beta <= welfare i tailStart) ->
    (exists betaPlus, 0 < betaPlus /\
      aggregateWelfare agents weight welfare 0 <
        aggregateWelfare agents weight welfare betaPlus) ->
    exists betaStar, 0 < betaStar /\ forall beta, 0 <= beta ->
      aggregateWelfare agents weight welfare beta <=
        aggregateWelfare agents weight welfare betaStar) /\
  (forall (Agent : Type) (agents : Finset Agent)
      (weight : Agent -> Real)
      (lowWelfare highWelfare : Agent -> Real -> Real)
      (betaLow betaHigh : Real),
    (forall i, i ∈ agents -> 0 <= weight i) ->
    (forall i, i ∈ agents ->
      DifferenceDominates (highWelfare i) (lowWelfare i)) ->
    IsUniqueArgmaxOnNonnegative
      (aggregateWelfare agents weight lowWelfare) betaLow ->
    IsUniqueArgmaxOnNonnegative
      (aggregateWelfare agents weight highWelfare) betaHigh ->
    betaLow <= betaHigh) /\
  Continuous twoTypeAggregateWelfare /\
  HasStrictValley twoTypeAggregateWelfare

theorem principalOptimumClaim_proved : PrincipalOptimumClaim := by
  refine ⟨?_, ?_,
    twoTypeAggregateWelfare_continuous,
    twoTypeAggregateWelfare_strictValley⟩
  · intro Agent agents weight welfare tailStart hWeight hWeightSum
      hTailStart hContinuous hTail hImprovement
    exact finitePopulation_positive_argmax_exists
      agents weight welfare tailStart hWeight hWeightSum
      hTailStart hContinuous hTail hImprovement
  · intro Agent agents weight lowWelfare highWelfare betaLow betaHigh
      hWeight hDifference hLow hHigh
    exact finitePopulation_optimalPrecision_mono
      agents weight lowWelfare highWelfare
      hWeight hDifference hLow hHigh

end BlackwellDilemma.PrincipalOptimum
