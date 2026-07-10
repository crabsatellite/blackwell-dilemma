/- Paper-faithful asymptotic shape for Theorem 4.1 Part 6. -/

import Mathlib.Analysis.SpecificLimits.Basic

namespace BlackwellDilemma.Infrastructure

open Filter Topology

/-- A sequence of tail probabilities is unbounded in probability when every
fixed finite threshold is exceeded with probability tending to one. -/
def UnboundedInProbability
    (tailProbability : Nat -> Real -> Real) : Prop :=
  forall bound : Real,
    Tendsto (fun latticeSize => tailProbability latticeSize bound)
      atTop (nhds 1)

/-- Correct fixed-parameter quantifier shape for the lattice Part 6 claim.

The blocking parameter and alpha are fixed before the lattice-size limit. The
tail probability is indexed by lattice size and a finite threshold; there is no
scalar `p -> p_c` divergence surrogate. -/
def FixedParameterLatticeUnboundedClaim
    (admissibleBlocking : Real -> Prop)
    (admissibleAlpha : Real -> Prop)
    (tailProbability : Real -> Real -> Nat -> Real -> Real) : Prop :=
  forall p : Real, admissibleBlocking p ->
    forall alpha : Real, admissibleAlpha alpha ->
      UnboundedInProbability (tailProbability p alpha)

/-- If independent trials each have fixed success probability `rho > 0`, the
probability `1 - (1 - rho)^trials` of at least one success tends to one. This
is the analytic amplification step only; applying it to lattice blocks still
requires a separate proof that the selected local events are independent. -/
theorem independentTrialAmplification
    (rho : Real) (hPositive : 0 < rho) (hAtMostOne : rho <= 1) :
    Tendsto (fun trials : Nat => 1 - (1 - rho) ^ trials)
      atTop (nhds 1) := by
  have hFailureNonnegative : 0 <= 1 - rho := sub_nonneg.mpr hAtMostOne
  have hFailureLessThanOne : 1 - rho < 1 := sub_lt_self 1 hPositive
  have hFailureTendsToZero :
      Tendsto (fun trials : Nat => (1 - rho) ^ trials)
        atTop (nhds 0) :=
    tendsto_pow_atTop_nhds_zero_of_lt_one
      hFailureNonnegative hFailureLessThanOne
  simpa using tendsto_const_nhds.sub hFailureTendsToZero

/-- The same amplification along any lattice-size-indexed trial count that
diverges to infinity. -/
theorem independentTrialAmplificationAlong
    (trials : Nat -> Nat)
    (hTrials : Tendsto trials atTop atTop)
    (rho : Real) (hPositive : 0 < rho) (hAtMostOne : rho <= 1) :
    Tendsto (fun latticeSize : Nat =>
      1 - (1 - rho) ^ trials latticeSize)
      atTop (nhds 1) := by
  exact (independentTrialAmplification
    rho hPositive hAtMostOne).comp hTrials

def IndependentTrialAmplificationPrinciple : Prop :=
  forall rho : Real, 0 < rho -> rho <= 1 ->
    Tendsto (fun trials : Nat => 1 - (1 - rho) ^ trials)
      atTop (nhds 1)

theorem independentTrialAmplificationPrinciple_proved :
    IndependentTrialAmplificationPrinciple := by
  intro rho hPositive hAtMostOne
  exact independentTrialAmplification rho hPositive hAtMostOne

/-- A lower event whose probability tends to one transfers Part 6 unboundedness
to any probability-valued threshold event containing it. -/
theorem unboundedInProbability_of_lower_bound
    (tailProbability lowerEventProbability : Nat -> Real -> Real)
    (hUpper : forall latticeSize bound,
      tailProbability latticeSize bound <= 1)
    (hDominates : forall latticeSize bound,
      lowerEventProbability latticeSize bound <=
        tailProbability latticeSize bound)
    (hLowerTendsToOne : forall bound,
      Tendsto (fun latticeSize => lowerEventProbability latticeSize bound)
        atTop (nhds 1)) :
    UnboundedInProbability tailProbability := by
  intro bound
  exact tendsto_of_tendsto_of_tendsto_of_le_of_le
    (hLowerTendsToOne bound)
    tendsto_const_nhds
    (fun latticeSize => hDominates latticeSize bound)
    (fun latticeSize => hUpper latticeSize bound)

/-- Paper-faithful quantifier transfer for the lattice argument. For each
finite target bound, choose a fixed trap depth whose deterministic threshold
exceeds that bound. The probability of finding that fixed-depth witness then
tends to one as lattice size grows. -/
theorem unboundedInProbability_of_depth_witness
    (tailProbability : Nat -> Real -> Real)
    (depthThreshold : Nat -> Real)
    (depthEventProbability : Nat -> Nat -> Real)
    (hUpper : forall latticeSize bound,
      tailProbability latticeSize bound <= 1)
    (hThresholdCofinal : forall bound : Real,
      exists depth : Nat, bound < depthThreshold depth)
    (hDepthEventTendsToOne : forall depth : Nat,
      Tendsto (depthEventProbability depth) atTop (nhds 1))
    (hDepthEventDominates : forall depth latticeSize bound,
      bound < depthThreshold depth ->
      depthEventProbability depth latticeSize <=
        tailProbability latticeSize bound) :
    UnboundedInProbability tailProbability := by
  intro bound
  obtain ⟨depth, hDepth⟩ := hThresholdCofinal bound
  exact tendsto_of_tendsto_of_tendsto_of_le_of_le
    (hDepthEventTendsToOne depth)
    tendsto_const_nhds
    (fun latticeSize =>
      hDepthEventDominates depth latticeSize bound hDepth)
    (fun latticeSize => hUpper latticeSize bound)

def Part6LowerBoundTransferPrinciple : Prop :=
  forall tailProbability lowerEventProbability : Nat -> Real -> Real,
    (forall latticeSize bound, tailProbability latticeSize bound <= 1) ->
    (forall latticeSize bound,
      lowerEventProbability latticeSize bound <=
        tailProbability latticeSize bound) ->
    (forall bound,
      Tendsto (fun latticeSize => lowerEventProbability latticeSize bound)
        atTop (nhds 1)) ->
    UnboundedInProbability tailProbability

theorem part6LowerBoundTransferPrinciple_proved :
    Part6LowerBoundTransferPrinciple := by
  intro tailProbability lowerEventProbability hUpper hDominates hLower
  exact unboundedInProbability_of_lower_bound
    tailProbability lowerEventProbability hUpper hDominates hLower

def Part6DepthWitnessTransferPrinciple : Prop :=
  forall tailProbability : Nat -> Real -> Real,
    forall depthThreshold : Nat -> Real,
    forall depthEventProbability : Nat -> Nat -> Real,
      (forall latticeSize bound,
        tailProbability latticeSize bound <= 1) ->
      (forall bound : Real,
        exists depth : Nat, bound < depthThreshold depth) ->
      (forall depth : Nat,
        Tendsto (depthEventProbability depth) atTop (nhds 1)) ->
      (forall depth latticeSize bound,
        bound < depthThreshold depth ->
        depthEventProbability depth latticeSize <=
          tailProbability latticeSize bound) ->
      UnboundedInProbability tailProbability

theorem part6DepthWitnessTransferPrinciple_proved :
    Part6DepthWitnessTransferPrinciple := by
  intro tailProbability depthThreshold depthEventProbability
    hUpper hThresholdCofinal hDepthEvent hDominates
  exact unboundedInProbability_of_depth_witness
    tailProbability depthThreshold depthEventProbability
    hUpper hThresholdCofinal hDepthEvent hDominates

/-- Kernel-checked analytic core currently available for Part 6. The remaining
work is to construct the paper's bounded local trap event on the finite torus,
prove its positive probability, and connect separated translates to the trial
formula above. -/
def Part6AnalyticKernelBundle : Prop :=
  Part6LowerBoundTransferPrinciple /\
    IndependentTrialAmplificationPrinciple /\
    Part6DepthWitnessTransferPrinciple

theorem part6AnalyticKernelBundle_proved :
    Part6AnalyticKernelBundle := by
  exact And.intro
    part6LowerBoundTransferPrinciple_proved
    (And.intro
      independentTrialAmplificationPrinciple_proved
      part6DepthWitnessTransferPrinciple_proved)

end BlackwellDilemma.Infrastructure
