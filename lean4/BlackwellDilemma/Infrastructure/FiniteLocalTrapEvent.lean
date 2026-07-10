/- Finite-product facts used by the paper's local trap events. -/

import BlackwellDilemma.Infrastructure.BernoulliProductFinite
import BlackwellDilemma.Infrastructure.UnboundedInProbability

namespace BlackwellDilemma.Infrastructure

/-- Joint product mass of a specified finite edge pattern and specified
positive reward-window masses. The edge parameter is the paper's blocking
probability, so an open edge has Bernoulli parameter `1 - p`. -/
def finiteJointPatternMass {Edge RewardIndex : Type*}
    (edgeSupport : Finset Edge)
    (rewardSupport : Finset RewardIndex)
    (blockingProbability : Real)
    (edgeState : Edge -> Bool)
    (rewardWindowMass : RewardIndex -> Real) : Real :=
  bernoulliWeight (1 - blockingProbability) edgeSupport edgeState *
    rewardSupport.prod rewardWindowMass

/-- Every fully specified finite edge/reward pattern has positive product
mass when the blocking probability is non-degenerate and every reward window
has positive mass. -/
theorem finiteJointPatternMass_pos {Edge RewardIndex : Type*}
    (edgeSupport : Finset Edge)
    (rewardSupport : Finset RewardIndex)
    (blockingProbability : Real)
    (edgeState : Edge -> Bool)
    (rewardWindowMass : RewardIndex -> Real)
    (hBlockingPositive : 0 < blockingProbability)
    (hBlockingLessThanOne : blockingProbability < 1)
    (hRewardPositive : forall rewardIndex,
      rewardIndex ∈ rewardSupport -> 0 < rewardWindowMass rewardIndex) :
    0 < finiteJointPatternMass edgeSupport rewardSupport
      blockingProbability edgeState rewardWindowMass := by
  apply mul_pos
  · exact bernoulliWeight_pos edgeSupport
      (sub_pos.mpr hBlockingLessThanOne)
      (sub_lt_self 1 hBlockingPositive)
      edgeState
  · exact Finset.prod_pos hRewardPositive

/-- Product lower bound displayed in the manuscript's depth-`d` embedding:
`2d+1` required open edges, linearly many required blocked edges, and
`2(d+1)` positive reward windows. -/
def trapTreeLocalPatternLowerBound
    (blockingProbability rewardWindowMass : Real)
    (depth blockedEdgesPerDepth : Nat) : Real :=
  (1 - blockingProbability) ^ (2 * depth + 1) *
    blockingProbability ^ (blockedEdgesPerDepth * depth) *
    rewardWindowMass ^ (2 * (depth + 1))

theorem trapTreeLocalPatternLowerBound_pos
    (blockingProbability rewardWindowMass : Real)
    (depth blockedEdgesPerDepth : Nat)
    (hBlockingPositive : 0 < blockingProbability)
    (hBlockingLessThanOne : blockingProbability < 1)
    (hRewardPositive : 0 < rewardWindowMass) :
    0 < trapTreeLocalPatternLowerBound
      blockingProbability rewardWindowMass depth blockedEdgesPerDepth := by
  unfold trapTreeLocalPatternLowerBound
  exact mul_pos
    (mul_pos
      (pow_pos (sub_pos.mpr hBlockingLessThanOne) _)
      (pow_pos hBlockingPositive _))
    (pow_pos hRewardPositive _)

def TrapTreeLocalPatternPositivePrinciple : Prop :=
  forall blockingProbability rewardWindowMass : Real,
    forall depth blockedEdgesPerDepth : Nat,
      0 < blockingProbability -> blockingProbability < 1 ->
      0 < rewardWindowMass ->
      0 < trapTreeLocalPatternLowerBound
        blockingProbability rewardWindowMass depth blockedEdgesPerDepth

theorem trapTreeLocalPatternPositivePrinciple_proved :
    TrapTreeLocalPatternPositivePrinciple := by
  intro blockingProbability rewardWindowMass depth blockedEdgesPerDepth
    hBlockingPositive hBlockingLessThanOne hRewardPositive
  exact trapTreeLocalPatternLowerBound_pos
    blockingProbability rewardWindowMass depth blockedEdgesPerDepth
    hBlockingPositive hBlockingLessThanOne hRewardPositive

/-- An explicit bounded local subevent for trap prevalence: five prescribed
blocked edges, three prescribed open edges, and three disjoint reward windows
of lengths `1/6`, `1/3`, and `1/6`. -/
noncomputable def immediateTrapLocalPatternLowerBound
    (blockingProbability : Real) : Real :=
  blockingProbability ^ 5 * (1 - blockingProbability) ^ 3 *
    ((1 / 6 : Real) * (1 / 3 : Real) * (1 / 6 : Real))

theorem immediateTrapLocalPatternLowerBound_pos
    (blockingProbability : Real)
    (hBlockingPositive : 0 < blockingProbability)
    (hBlockingLessThanOne : blockingProbability < 1) :
    0 < immediateTrapLocalPatternLowerBound blockingProbability := by
  unfold immediateTrapLocalPatternLowerBound
  have hRewardMass :
      0 < (1 / 6 : Real) * (1 / 3 : Real) * (1 / 6 : Real) := by
    positivity
  exact mul_pos
    (mul_pos
      (pow_pos hBlockingPositive _)
      (pow_pos (sub_pos.mpr hBlockingLessThanOne) _))
    hRewardMass

/-- The explicit reward windows force the paper's local ranking reversal:
the immediate trap reward exceeds the bridge reward, while a continuation
reward in the bridge component exceeds the trap reward. -/
theorem explicitRewardWindows_force_reversal
    (trapReward bridgeReward continuationReward : Real)
    (hTrapLower : (1 / 2 : Real) < trapReward)
    (hTrapUpper : trapReward < (2 / 3 : Real))
    (hBridgeUpper : bridgeReward < (1 / 3 : Real))
    (hContinuationLower : (5 / 6 : Real) < continuationReward) :
    bridgeReward < trapReward /\ trapReward < continuationReward := by
  constructor <;> linarith

def TrapPrevalenceLocalKernelBundle : Prop :=
  (forall blockingProbability : Real,
      0 < blockingProbability -> blockingProbability < 1 ->
      0 < immediateTrapLocalPatternLowerBound blockingProbability) /\
    (forall trapReward bridgeReward continuationReward : Real,
      (1 / 2 : Real) < trapReward ->
      trapReward < (2 / 3 : Real) ->
      bridgeReward < (1 / 3 : Real) ->
      (5 / 6 : Real) < continuationReward ->
      bridgeReward < trapReward /\ trapReward < continuationReward)

theorem trapPrevalenceLocalKernelBundle_proved :
    TrapPrevalenceLocalKernelBundle := by
  constructor
  · intro blockingProbability hPositive hLessThanOne
    exact immediateTrapLocalPatternLowerBound_pos
      blockingProbability hPositive hLessThanOne
  · intro trapReward bridgeReward continuationReward
      hTrapLower hTrapUpper hBridgeUpper hContinuationLower
    exact explicitRewardWindows_force_reversal
      trapReward bridgeReward continuationReward
      hTrapLower hTrapUpper hBridgeUpper hContinuationLower

def Part6LocalPatternKernelBundle : Prop :=
  Part6AnalyticKernelBundle /\ TrapTreeLocalPatternPositivePrinciple

theorem part6LocalPatternKernelBundle_proved :
    Part6LocalPatternKernelBundle := by
  exact And.intro
    part6AnalyticKernelBundle_proved
    trapTreeLocalPatternPositivePrinciple_proved

end BlackwellDilemma.Infrastructure
