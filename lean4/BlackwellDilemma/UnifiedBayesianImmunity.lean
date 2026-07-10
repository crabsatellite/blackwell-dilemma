/-
  BlackwellDilemma/UnifiedBayesianImmunity.lean

  Strategy-aligned specialization of Blackwell monotonicity to a finite IDP
  percolation family. The external Blackwell step remains an explicit premise;
  fixed feasibility and aggregation are kernel proved here.
-/

import BlackwellDilemma.UnifiedIDP
import Mathlib.Algebra.Order.BigOperators.Group.Finset

namespace BlackwellDilemma.BayesianImmunity

universe u v w x

/-- A finite family of realized IDPs. `conditionalValue omega beta` denotes
    the optimized Bayesian value on realization `omega`; the theorem below
    deliberately requires its Blackwell monotonicity as an external premise. -/
structure BayesianIDPFamily
    (Omega : Type u) (V : Type v) (Signal : Type w) (Experiment : Type x)
    [Fintype Omega] [DecidableEq Omega]
    [Fintype V] [DecidableEq V] where
  realizationWeight : Omega -> Real
  realizationWeight_nonneg : forall omega, 0 <= realizationWeight omega
  realizationWeight_sum_one :
    (Finset.univ.sum realizationWeight) = 1
  model : Omega -> IDPModel V
  initial : Omega -> IDPState V
  experiment : Real -> Experiment
  blackwellMoreInformative : Experiment -> Experiment -> Prop
  experiment_ordered : forall betaLow betaHigh,
    betaLow <= betaHigh ->
      blackwellMoreInformative (experiment betaLow) (experiment betaHigh)
  conditionalValue : Omega -> Experiment -> Real

namespace BayesianIDPFamily

variable {Omega : Type u} {V : Type v}
variable {Signal : Type w} {Experiment : Type x}
variable [Fintype Omega] [DecidableEq Omega]
variable [Fintype V] [DecidableEq V]

/-- The attainable stopping set under the common IDP transition and stopping
    rules. The precision argument is intentionally ignored: reward information
    does not alter physical feasibility conditional on a realization. -/
noncomputable def feasibleStopsAtPrecision
    (F : BayesianIDPFamily Omega V Signal Experiment)
    (omega : Omega) (_beta : Real) : Finset V :=
  (F.model omega).attainableStops (F.initial omega)

theorem feasibleStopsAtPrecision_nonempty
    (F : BayesianIDPFamily Omega V Signal Experiment)
    (omega : Omega) (beta : Real) :
    (F.feasibleStopsAtPrecision omega beta).Nonempty := by
  exact (F.model omega).attainableStops_nonempty (F.initial omega)

theorem feasibleStopsAtPrecision_independent
    (F : BayesianIDPFamily Omega V Signal Experiment)
    (omega : Omega) (betaLow betaHigh : Real) :
    F.feasibleStopsAtPrecision omega betaLow =
      F.feasibleStopsAtPrecision omega betaHigh :=
  rfl

/-- Signal-contingent terminal choices that are implemented by the common IDP
    transition and stopping rules. The precision argument is ignored because
    information changes beliefs, not the feasible traversal set. -/
noncomputable def feasibleDecisionRulesAtPrecision
    (F : BayesianIDPFamily Omega V Signal Experiment)
    (omega : Omega) (_beta : Real) : Set (Signal -> V) :=
  {delta | forall signal, delta signal ∈ F.feasibleStopsAtPrecision omega 0}

theorem feasibleDecisionRulesAtPrecision_nonempty
    (F : BayesianIDPFamily Omega V Signal Experiment)
    (omega : Omega) (beta : Real) :
    (F.feasibleDecisionRulesAtPrecision omega beta).Nonempty := by
  rcases F.feasibleStopsAtPrecision_nonempty omega 0 with ⟨v, hv⟩
  exact ⟨fun _ => v, fun _ => hv⟩

theorem feasibleDecisionRulesAtPrecision_independent
    (F : BayesianIDPFamily Omega V Signal Experiment)
    (omega : Omega) (betaLow betaHigh : Real) :
    F.feasibleDecisionRulesAtPrecision omega betaLow =
      F.feasibleDecisionRulesAtPrecision omega betaHigh :=
  rfl

theorem feasibleDecisionRule_implemented
    (F : BayesianIDPFamily Omega V Signal Experiment)
    (omega : Omega) (beta : Real) (delta : Signal -> V)
    (hdelta : delta ∈ F.feasibleDecisionRulesAtPrecision omega beta)
    (signal : Signal) :
    exists t : IDPState V,
      (F.model omega).Reaches (F.initial omega) t /\
        (F.model omega).IsStopping t /\ t.current = delta signal := by
  exact ((F.model omega).mem_attainableStops_iff
    (F.initial omega) (delta signal)).1 (hdelta signal)

/-- Ex ante welfare obtained by averaging the conditional Bayesian values over
    the finite percolation realization space. -/
noncomputable def aggregateWelfare
    (F : BayesianIDPFamily Omega V Signal Experiment) (beta : Real) : Real :=
  Finset.univ.sum fun omega =>
    F.realizationWeight omega * F.conditionalValue omega (F.experiment beta)

/-- The exact external premise supplied by Blackwell's comparison theorem
    after conditioning on one realization and fixing the feasible strategy
    set. It is not asserted as a local axiom. -/
def BlackwellConditionalPremise
    (F : BayesianIDPFamily Omega V Signal Experiment) : Prop :=
  forall (omega : Omega) (experimentLow experimentHigh : Experiment),
    F.blackwellMoreInformative experimentLow experimentHigh ->
      F.conditionalValue omega experimentLow <=
        F.conditionalValue omega experimentHigh

theorem aggregateWelfare_mono_of_blackwell
    (F : BayesianIDPFamily Omega V Signal Experiment)
    (hBlackwell : F.BlackwellConditionalPremise) :
    Monotone F.aggregateWelfare := by
  intro betaLow betaHigh hBeta
  unfold aggregateWelfare
  apply Finset.sum_le_sum
  intro omega _hOmega
  exact mul_le_mul_of_nonneg_left
    (hBlackwell omega (F.experiment betaLow) (F.experiment betaHigh)
      (F.experiment_ordered betaLow betaHigh hBeta))
    (F.realizationWeight_nonneg omega)

structure BayesianImmunityBundle
    (F : BayesianIDPFamily Omega V Signal Experiment) : Prop where
  probabilityNonnegative : forall omega, 0 <= F.realizationWeight omega
  probabilityNormalized : Finset.univ.sum F.realizationWeight = 1
  feasibleStopsNonempty : forall omega beta,
    (F.feasibleStopsAtPrecision omega beta).Nonempty
  feasibleStopsFixed : forall omega betaLow betaHigh,
    F.feasibleStopsAtPrecision omega betaLow =
      F.feasibleStopsAtPrecision omega betaHigh
  feasibleDecisionRulesNonempty : forall omega beta,
    (F.feasibleDecisionRulesAtPrecision omega beta).Nonempty
  feasibleDecisionRulesFixed : forall omega betaLow betaHigh,
    F.feasibleDecisionRulesAtPrecision omega betaLow =
      F.feasibleDecisionRulesAtPrecision omega betaHigh
  feasibleDecisionRulesImplemented : forall omega beta delta,
    delta ∈ F.feasibleDecisionRulesAtPrecision omega beta ->
      forall signal, exists t : IDPState V,
        (F.model omega).Reaches (F.initial omega) t /\
          (F.model omega).IsStopping t /\ t.current = delta signal
  experimentsOrdered : forall betaLow betaHigh,
    betaLow <= betaHigh ->
      F.blackwellMoreInformative
        (F.experiment betaLow) (F.experiment betaHigh)
  welfareMonotone : Monotone F.aggregateWelfare

theorem bayesianImmunityBundle_of_blackwell
    (F : BayesianIDPFamily Omega V Signal Experiment)
    (hBlackwell : F.BlackwellConditionalPremise) :
    BayesianImmunityBundle F where
  probabilityNonnegative := F.realizationWeight_nonneg
  probabilityNormalized := F.realizationWeight_sum_one
  feasibleStopsNonempty := F.feasibleStopsAtPrecision_nonempty
  feasibleStopsFixed := F.feasibleStopsAtPrecision_independent
  feasibleDecisionRulesNonempty :=
    F.feasibleDecisionRulesAtPrecision_nonempty
  feasibleDecisionRulesFixed :=
    F.feasibleDecisionRulesAtPrecision_independent
  feasibleDecisionRulesImplemented := by
    intro omega beta delta hdelta signal
    exact F.feasibleDecisionRule_implemented omega beta delta hdelta signal
  experimentsOrdered := F.experiment_ordered
  welfareMonotone := F.aggregateWelfare_mono_of_blackwell hBlackwell

end BayesianIDPFamily

/-- Typed form of the cited Blackwell 1953 premise on every finite,
    strategy-aligned IDP realization family. -/
def Blackwell1953FixedFeasiblePremise : Prop :=
  forall (Omega V Signal Experiment : Type)
    [Fintype Omega] [DecidableEq Omega]
    [Fintype V] [DecidableEq V]
    (F : BayesianIDPFamily Omega V Signal Experiment),
      F.BlackwellConditionalPremise

/-- Publication statement after the cited conditional Blackwell step is
    specialized to the unified IDP transition and stopping semantics. -/
def BayesianImmunityClaim : Prop :=
  forall (Omega V Signal Experiment : Type)
    [Fintype Omega] [DecidableEq Omega]
    [Fintype V] [DecidableEq V]
    (F : BayesianIDPFamily Omega V Signal Experiment),
      BayesianIDPFamily.BayesianImmunityBundle F

theorem bayesianImmunityClaim_from_blackwell :
    Blackwell1953FixedFeasiblePremise -> BayesianImmunityClaim := by
  intro hBlackwell Omega V Signal Experiment _ _ _ _ F
  exact F.bayesianImmunityBundle_of_blackwell
    (hBlackwell Omega V Signal Experiment F)

end BlackwellDilemma.BayesianImmunity
