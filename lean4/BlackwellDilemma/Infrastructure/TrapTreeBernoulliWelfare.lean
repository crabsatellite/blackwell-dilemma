/- Finite Bernoulli derivation of the depth-d trap-tree welfare formula. -/

import BlackwellDilemma.Infrastructure.KappaStarClosedForm

namespace BlackwellDilemma.Infrastructure

open Filter Topology

def boolSuccessIndicator (choice : Bool) : Real :=
  if choice then 1 else 0

/-- Indicator that every one of the `depth` bridge choices succeeds. -/
def allBridgeIndicator (depth : Nat) (choices : Fin depth -> Bool) : Real :=
  Finset.univ.prod (fun level => boolSuccessIndicator (choices level))

theorem allBridgeIndicator_bernoulliExpectation
    (bridgeProbability : Real) (depth : Nat) :
    bernoulliProductExpectation bridgeProbability
      (allBridgeIndicator depth) = bridgeProbability ^ depth := by
  classical
  let factor : Fin depth -> Bool -> Real := fun _level choice =>
    bernoulliFactor bridgeProbability choice * boolSuccessIndicator choice
  have hProductSum :
      (Finset.univ.prod (fun level : Fin depth =>
        Finset.univ.sum (fun choice : Bool => factor level choice))) =
      Finset.univ.sum (fun choices : Fin depth -> Bool =>
        Finset.univ.prod (fun level : Fin depth =>
          factor level (choices level))) := by
    simpa using Fintype.prod_sum factor
  unfold bernoulliProductExpectation bernoulliWeight allBridgeIndicator
  calc
    Finset.univ.sum (fun choices : Fin depth -> Bool =>
        (Finset.univ.prod (fun level : Fin depth =>
          bernoulliFactor bridgeProbability (choices level))) *
        Finset.univ.prod (fun level : Fin depth =>
          boolSuccessIndicator (choices level))) =
      Finset.univ.sum (fun choices : Fin depth -> Bool =>
        Finset.univ.prod (fun level : Fin depth =>
          factor level (choices level))) := by
        apply Finset.sum_congr rfl
        intro choices _hChoices
        simp only [factor, Finset.prod_mul_distrib]
    _ = Finset.univ.prod (fun level : Fin depth =>
        Finset.univ.sum (fun choice : Bool => factor level choice)) :=
      hProductSum.symm
    _ = bridgeProbability ^ depth := by
      simp [factor, bernoulliFactor, boolSuccessIndicator]

/-- Terminal reward on a Bernoulli choice sequence: the goal premium is paid
exactly when every bridge choice succeeds. -/
def trapTreeTerminalReward
    (trapReward goalReward : Real) (depth : Nat)
    (choices : Fin depth -> Bool) : Real :=
  trapReward +
    (goalReward - trapReward) * allBridgeIndicator depth choices

noncomputable def trapTreeExpectedWelfare
    (trapReward goalReward bridgeProbability : Real)
    (depth : Nat) : Real :=
  bernoulliProductExpectation bridgeProbability
    (trapTreeTerminalReward trapReward goalReward depth)

theorem trapTreeExpectedWelfare_eq
    (trapReward goalReward bridgeProbability : Real)
    (depth : Nat) :
    trapTreeExpectedWelfare trapReward goalReward bridgeProbability depth =
      trapReward +
        (goalReward - trapReward) * bridgeProbability ^ depth := by
  classical
  have hSuccessMass :
      Finset.univ.sum (fun choices : Fin depth -> Bool =>
        bernoulliWeight bridgeProbability Finset.univ choices *
          allBridgeIndicator depth choices) = bridgeProbability ^ depth := by
    simpa [bernoulliProductExpectation] using
      allBridgeIndicator_bernoulliExpectation bridgeProbability depth
  unfold trapTreeExpectedWelfare trapTreeTerminalReward
    bernoulliProductExpectation
  calc
    Finset.univ.sum (fun choices : Fin depth -> Bool =>
        bernoulliWeight bridgeProbability Finset.univ choices *
          (trapReward +
            (goalReward - trapReward) * allBridgeIndicator depth choices)) =
      Finset.univ.sum (fun choices : Fin depth -> Bool =>
        trapReward * bernoulliWeight bridgeProbability Finset.univ choices +
          (goalReward - trapReward) *
            (bernoulliWeight bridgeProbability Finset.univ choices *
              allBridgeIndicator depth choices)) := by
        apply Finset.sum_congr rfl
        intro choices _hChoices
        ring
    _ = trapReward *
          Finset.univ.sum (fun choices : Fin depth -> Bool =>
            bernoulliWeight bridgeProbability Finset.univ choices) +
        (goalReward - trapReward) *
          Finset.univ.sum (fun choices : Fin depth -> Bool =>
            bernoulliWeight bridgeProbability Finset.univ choices *
              allBridgeIndicator depth choices) := by
        rw [Finset.sum_add_distrib, Finset.mul_sum, Finset.mul_sum]
    _ = trapReward +
        (goalReward - trapReward) * bridgeProbability ^ depth := by
      rw [bernoulliWeight_univ_total,
        hSuccessMass]
      ring

theorem trapTreeExpectedWelfare_at_zero
    (trapReward goalReward : Real)
    (depth : Nat) (hDepth : 0 < depth) :
    trapTreeExpectedWelfare trapReward goalReward 0 depth = trapReward := by
  rw [trapTreeExpectedWelfare_eq, zero_pow hDepth.ne']
  ring

theorem trapTreeExpectedWelfare_at_one
    (trapReward goalReward : Real) (depth : Nat) :
    trapTreeExpectedWelfare trapReward goalReward 1 depth = goalReward := by
  rw [trapTreeExpectedWelfare_eq, one_pow]
  ring

theorem trapTreeWelfareGain_pos
    (trapReward goalReward bridgeProbability : Real)
    (depth : Nat)
    (hReward : trapReward < goalReward)
    (hProbability : 0 < bridgeProbability) :
    0 < trapTreeExpectedWelfare
      trapReward goalReward bridgeProbability depth - trapReward := by
  rw [trapTreeExpectedWelfare_eq]
  have hPremium : 0 < goalReward - trapReward := sub_pos.mpr hReward
  have hPower : 0 < bridgeProbability ^ depth :=
    pow_pos hProbability depth
  nlinarith

theorem trapTreeExpectedWelfare_tendsto_trap
    (trapReward goalReward bridgeProbability : Real)
    (hProbabilityNonnegative : 0 <= bridgeProbability)
    (hProbabilityLessThanOne : bridgeProbability < 1) :
    Tendsto (fun depth : Nat =>
      trapTreeExpectedWelfare
        trapReward goalReward bridgeProbability depth)
      atTop (nhds trapReward) := by
  have hPower : Tendsto (fun depth : Nat => bridgeProbability ^ depth)
      atTop (nhds 0) :=
    tendsto_pow_atTop_nhds_zero_of_lt_one
      hProbabilityNonnegative hProbabilityLessThanOne
  have hPremium : Tendsto (fun depth : Nat =>
      (goalReward - trapReward) * bridgeProbability ^ depth)
      atTop (nhds 0) := by
    simpa using hPower.const_mul (goalReward - trapReward)
  have hTrap : Tendsto (fun _depth : Nat => trapReward)
      atTop (nhds trapReward) := tendsto_const_nhds
  have hTotal : Tendsto (fun depth : Nat =>
      trapReward +
        (goalReward - trapReward) * bridgeProbability ^ depth)
      atTop (nhds trapReward) := by
    simpa using hTrap.add hPremium
  apply hTotal.congr'
  filter_upwards with depth
  rw [trapTreeExpectedWelfare_eq]

def TrapTreeBernoulliWelfarePrinciple : Prop :=
  (forall trapReward goalReward bridgeProbability : Real,
      forall depth : Nat,
      trapTreeExpectedWelfare
        trapReward goalReward bridgeProbability depth =
        trapReward +
          (goalReward - trapReward) * bridgeProbability ^ depth) /\
    (forall trapReward goalReward : Real,
      forall depth : Nat, 0 < depth ->
      trapTreeExpectedWelfare trapReward goalReward 0 depth = trapReward) /\
    (forall trapReward goalReward : Real,
      forall depth : Nat,
      trapTreeExpectedWelfare trapReward goalReward 1 depth = goalReward) /\
    (forall trapReward goalReward bridgeProbability : Real,
      forall depth : Nat,
      trapReward < goalReward -> 0 < bridgeProbability ->
      0 < trapTreeExpectedWelfare
        trapReward goalReward bridgeProbability depth - trapReward) /\
    (forall trapReward goalReward bridgeProbability : Real,
      0 <= bridgeProbability -> bridgeProbability < 1 ->
      Tendsto (fun depth : Nat =>
        trapTreeExpectedWelfare
          trapReward goalReward bridgeProbability depth)
        atTop (nhds trapReward))

theorem trapTreeBernoulliWelfarePrinciple_proved :
    TrapTreeBernoulliWelfarePrinciple := by
  exact And.intro
    trapTreeExpectedWelfare_eq
    (And.intro
      trapTreeExpectedWelfare_at_zero
      (And.intro
        trapTreeExpectedWelfare_at_one
        (And.intro
          trapTreeWelfareGain_pos
          trapTreeExpectedWelfare_tendsto_trap)))

def ErrorCompoundingKernelBundle : Prop :=
  TrapTreeBernoulliWelfarePrinciple /\
    KappaStarClosedFormDivergencePrinciple

theorem errorCompoundingKernelBundle_proved :
    ErrorCompoundingKernelBundle := by
  exact And.intro
    trapTreeBernoulliWelfarePrinciple_proved
    kappaStarClosedFormDivergencePrinciple_proved

end BlackwellDilemma.Infrastructure
