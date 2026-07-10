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

end BlackwellDilemma.Infrastructure
