/- Correct asymptotic direction for topological loss on a giant component. -/

import Mathlib.Analysis.SpecificLimits.Basic

namespace BlackwellDilemma.Infrastructure

open Filter Topology

/-- A nonnegative loss bounded by `1 / (n + 1)` vanishes as the graph size
tends to infinity. This is the direction used by the manuscript on the giant
component; a uniform positive lower bound would contradict this envelope. -/
theorem giantLoss_tendsto_zero_of_one_div_envelope
    (loss : Nat -> Real)
    (hNonnegative : forall n, 0 <= loss n)
    (hEnvelope : forall n, loss n <= 1 / ((n : Real) + 1)) :
    Tendsto loss atTop (nhds 0) := by
  exact tendsto_of_tendsto_of_tendsto_of_le_of_le
    tendsto_const_nhds
    tendsto_one_div_add_atTop_nhds_zero_nat
    hNonnegative
    hEnvelope

def TopoGiantLossEnvelopePrinciple : Prop :=
  forall loss : Nat -> Real,
    (forall n, 0 <= loss n) ->
    (forall n, loss n <= 1 / ((n : Real) + 1)) ->
    Tendsto loss atTop (nhds 0)

theorem topoGiantLossEnvelopePrinciple_proved :
    TopoGiantLossEnvelopePrinciple := by
  intro loss hNonnegative hEnvelope
  exact giantLoss_tendsto_zero_of_one_div_envelope
    loss hNonnegative hEnvelope

end BlackwellDilemma.Infrastructure
