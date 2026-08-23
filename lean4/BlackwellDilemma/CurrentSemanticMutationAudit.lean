/-
  Project-owned semantic mutation tests for the current paper contracts.

  Every block deliberately changes a carrier, direction, sign, endpoint, or
  regime and requires Lean to reject reuse of the genuine paper root.  If a
  future refactor makes one of these mutated statements typecheck, this file
  fails closed.
-/

import BlackwellDilemma.CurrentPaperContracts

namespace BlackwellDilemma.CurrentSemanticMutationAudit

set_option linter.unusedVariables false

open Filter Set Topology
open BlackwellDilemma.CurrentPosterior
open BlackwellDilemma.CurrentTwoAction
open BlackwellDilemma.CurrentRouteReversal
open BlackwellDilemma.CurrentCognition
open BlackwellDilemma.CurrentComplementarity
open BlackwellDilemma.CurrentFiveState
open BlackwellDilemma.CurrentRestoration

universe u v w x y

/-- Mutation: reverse the Blackwell-refinement value inequality. -/
example {Theta : Type u} [Fintype Theta]
    {Coarse : Type v} {Fine : Type w} [Fintype Coarse] [Fintype Fine]
    (R : FiniteBlackwellRefinement Theta Coarse Fine)
    {g : (Theta -> Real) -> Real}
    (hConvex : ConvexOn Real (posteriorSet Theta) g) : True := by
  fail_if_success
    have _hMutated : R.refinedValue g <= R.coarseValue g := by
      exact R.value_mono_of_convex hConvex
  trivial

/-- Mutation: make an objectively adverse boundary switch convex. -/
example {E : Type u} [NormedAddCommGroup E] [NormedSpace Real E]
    [FiniteDimensional Real E]
    (U0 Dv Du : E →ₗ[Real] Real) (boundaryGap : Real) (C : Set E)
    (hC : Convex Real C) (hInterior : (0 : E) ∈ interior C)
    (hAbsorb : AbsorbsDirections C) (hDv : Dv ≠ 0)
    (hAdverse : boundaryGap < 0) : True := by
  fail_if_success
    have _hMutated : ConvexOn Real C
        (twoActionWelfareWithBoundary U0 Dv Du boundaryGap) := by
      exact (CurrentPaperContracts.twoActionAlignmentContract
        U0 Dv Du boundaryGap C hC hInterior hAbsorb hDv).2 hAdverse
  trivial

/-- Mutation: replace the stopping disjunction by a conjunction. -/
example {V : Type u} [Fintype V] [DecidableEq V]
    (M : IDPModel V) (s : IDPState V) : True := by
  fail_if_success
    have _hMutated : M.IsStopping s <->
        s.current ∈ M.terminal /\
          Not (exists t : IDPState V, M.Step s t) := by
      rfl
  trivial

/-- Mutation: reverse the route-welfare monotonicity direction. -/
example {V : Type u} [Fintype V] [DecidableEq V]
    {Omega : Type v} [Fintype Omega]
    (X : FiniteExAnteIDP V Omega) (routeOne routeTwo : Omega -> Real)
    (ellOne ellTwo : Real)
    (hImmediate : ellTwo < ellOne)
    (hContinuation : expectedContinuation X.weight routeOne <
      expectedContinuation X.weight routeTwo) : True := by
  have hRoot := CurrentPaperContracts.routeReversalContract
    X routeOne routeTwo ellOne ellTwo hImmediate hContinuation
  fail_if_success
    have _hMutated : StrictMonoOn
        (terminalWelfare
          (expectedContinuation X.weight routeOne)
          (expectedContinuation X.weight routeTwo)
          (ellOne - ellTwo)) (Set.Ioi 0) := by
      exact hRoot.2.2
  trivial

/-- Mutation: reverse restoration under observed feasibility. -/
example {V : Type u} [Fintype V] [DecidableEq V]
    {Omega : Type v} [Fintype Omega]
    {Theta : Type w} [Fintype Theta]
    {Coarse : Type x} {Fine : Type y} [Fintype Coarse] [Fintype Fine]
    (X : FiniteExAnteIDP V Omega)
    (decision : (omega : Omega) -> PosteriorDecisionModel Theta
      (AttainableTerminal (X.realized omega) (X.initialState omega)))
    (hAligned : forall omega action theta,
      (decision omega).subjectivePayoff action theta =
        (decision omega).objectivePayoff action theta)
    (refinement : (omega : Omega) ->
      FiniteBlackwellRefinement Theta Coarse Fine) : True := by
  have hRoot := restorationUnderObservedFiniteFeasibility
    X decision
      (fun omega action theta =>
        (decision omega).objectivePayoff action theta)
      hAligned (by intros; rfl) refinement
  fail_if_success
    have _hMutated :
        finiteExpectation X.weight (fun omega =>
          (refinement omega).refinedValue
            (decision omega).inducedPosteriorWelfare) <=
        finiteExpectation X.weight (fun omega =>
          (refinement omega).coarseValue
            (decision omega).inducedPosteriorWelfare) := by
      exact hRoot
  trivial

/-- Mutation: change the nonpositive policy residual to nonnegative. -/
example {V : Type u} [Fintype V] [DecidableEq V] [Nonempty V]
    {Omega : Type v} [MeasurableSpace Omega]
    (setup : UnifiedWelfareSetup V Omega) : True := by
  have hRoot :=
    CurrentPaperContracts.feasibilityPolicyDecompositionContract setup
  fail_if_success
    have _hMutated : 0 <= setup.toWelfareSetup.W_info := by
      exact hRoot.2.2.1
  trivial

/-- Mutation: swap the below-threshold welfare regime from decreasing to
    increasing in payoff precision. -/
example (m0 mInf lowReward highReward : Real)
    (hM0 : m0 < 0) (hMInf : 0 < mInf) (hReward : lowReward < highReward)
    (kappa : Real) (hKappa : 0 <= kappa)
    (hBelow : kappa < kappaStar m0 mInf) : True := by
  rcases CurrentPaperContracts.cognitiveThresholdContract
      m0 mInf lowReward highReward hM0 hMInf hReward with
    ⟨_hPos, _hRoot, _hUnique, hAnti, _hAt, _hAbove⟩
  fail_if_success
    have _hMutated : StrictMonoOn
        (fun beta => cognitionWelfare
          m0 mInf lowReward highReward beta kappa) (Set.Ioi 0) := by
      exact hAnti kappa hKappa hBelow
  trivial

/-- Mutation: reverse the positive moderate-region cross effect. -/
example (m0 mInf lowReward highReward beta : Real)
    (kappa : Set.Ici (0 : Real))
    (hM0 : m0 < 0) (hMInf : 0 < mInf)
    (hReward : lowReward < highReward) (hBeta : 0 < beta)
    (hModerate : |cognitionIndex m0 mInf beta kappa.1| < 1) : True := by
  rcases CurrentPaperContracts.localComplementarityContract
      m0 mInf lowReward highReward beta kappa hM0 hMInf hReward hBeta
        hModerate with
    ⟨_hKappaDeriv, _hBetaDeriv, _hFormula, hPositive⟩
  fail_if_success
    have _hMutated :
        mixedCrossPartial m0 mInf lowReward highReward beta kappa.1 < 0 := by
      exact hPositive
  trivial

/-- Mutation: replace the exact no-information endpoint `0.425` by `0.5`. -/
example : True := by
  fail_if_success
    have _hMutated : expectedLoss 0 = (1 : Real) / 2 := by
      exact expectedLoss_zero
  trivial

end BlackwellDilemma.CurrentSemanticMutationAudit
