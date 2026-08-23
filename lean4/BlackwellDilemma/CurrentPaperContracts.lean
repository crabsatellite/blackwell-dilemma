/-
  Direct, paper-faithful roots for the ten numbered mathematical objects in
  the current Theory and Decision manuscript.  Unlike the compact ledger,
  these declarations expose the complete input carriers, binder order,
  ranges, hypotheses, endpoints, and conclusions in their elaborated types.
-/

import BlackwellDilemma.CurrentComplementarity
import BlackwellDilemma.CurrentFiveState
import BlackwellDilemma.CurrentRestoration
import BlackwellDilemma.CurrentRouteReversal
import BlackwellDilemma.CurrentTwoAction
import BlackwellDilemma.UnifiedWelfare

namespace BlackwellDilemma.CurrentPaperContracts

open Filter Set Topology
open scoped BigOperators
open BlackwellDilemma.CurrentPosterior
open BlackwellDilemma.CurrentTwoAction
open BlackwellDilemma.CurrentRouteReversal
open BlackwellDilemma.CurrentGaussian
open BlackwellDilemma.CurrentCognition
open BlackwellDilemma.CurrentComplementarity
open BlackwellDilemma.CurrentFiveState
open BlackwellDilemma.CurrentRestoration

universe u v w x y

/-- Definition 1, including the tie-broken argmax carrier, induced objective
    welfare, and finite-experiment value. -/
theorem posteriorWelfareDefinitionContract
    {Theta : Type u} [Fintype Theta]
    {Action : Type v} [Fintype Action] [Nonempty Action]
    {Signal : Type w} [Fintype Signal]
    (M : PosteriorDecisionModel Theta Action)
    (mu : Theta -> Real) (hMu : mu ∈ posteriorSet Theta)
    (experiment : FinitePosteriorExperiment Theta Signal) :
    (forall action,
      Finset.univ.sum (fun theta =>
        mu theta * M.subjectivePayoff action theta) <=
      Finset.univ.sum (fun theta =>
        mu theta * M.subjectivePayoff (M.response mu) theta)) /\
    M.inducedPosteriorWelfare mu =
      Finset.univ.sum (fun theta =>
        mu theta * M.objectivePayoff (M.response mu) theta) /\
    experiment.prior ∈ posteriorSet Theta /\
    (forall signal, 0 <= experiment.weight signal /\
      experiment.posterior signal ∈ posteriorSet Theta) /\
    Finset.univ.sum experiment.weight = 1 /\
    experiment.prior = Finset.univ.sum (fun signal =>
      experiment.weight signal • experiment.posterior signal) /\
    experiment.objectiveValue M =
      Finset.univ.sum (fun signal =>
        experiment.weight signal *
          M.inducedPosteriorWelfare (experiment.posterior signal)) := by
  exact ⟨M.response_optimal mu hMu, rfl, experiment.prior_mem,
    fun signal => ⟨experiment.weight_nonneg signal,
      experiment.posterior_mem signal⟩,
    experiment.weight_sum_one, experiment.barycenter, rfl⟩

/-- Theorem 2, including the strict binary witness when convexity fails. -/
theorem posteriorConvexityFrontierContract
    (Theta : Type u) [Fintype Theta]
    {Action : Type v} [Fintype Action] [Nonempty Action]
    (M : PosteriorDecisionModel Theta Action) :
    (RespectsFiniteBlackwellRefinements Theta M.inducedPosteriorWelfare <->
      ConvexOn Real (posteriorSet Theta) M.inducedPosteriorWelfare) /\
    (Not (ConvexOn Real (posteriorSet Theta) M.inducedPosteriorWelfare) ->
      exists mu nu : Theta -> Real, mu ∈ posteriorSet Theta /\
        nu ∈ posteriorSet Theta /\
        exists a b : Real, 0 <= a /\ 0 <= b /\ a + b = 1 /\
          a * M.inducedPosteriorWelfare mu +
            b * M.inducedPosteriorWelfare nu <
              M.inducedPosteriorWelfare (a • mu + b • nu)) := by
  exact ⟨posteriorConvexityFrontier Theta M.inducedPosteriorWelfare,
    fun hNotConvex => not_convex_exists_binary_witness Theta hNotConvex⟩

/-- Theorem 3 on the exact uncentered translated carrier. -/
theorem twoActionAlignmentContract
    {E : Type u} [NormedAddCommGroup E] [NormedSpace Real E]
    [FiniteDimensional Real E]
    (U0 Dv Du : E →ₗ[Real] Real) (boundaryGap : Real) (C : Set E)
    (hCarrierConvex : Convex Real C)
    (hBoundaryInterior : (0 : E) ∈ interior C)
    (hAbsorbsDirections : AbsorbsDirections C)
    (hSubjectiveGapNonzero : Dv ≠ 0) :
    (ConvexOn Real C
        (twoActionWelfareWithBoundary U0 Dv Du boundaryGap) <->
      boundaryGap = 0 /\ PositivelyAligned Dv Du) /\
    (boundaryGap < 0 ->
      Not (ConvexOn Real C
        (twoActionWelfareWithBoundary U0 Dv Du boundaryGap))) := by
  exact ⟨twoActionAffineAlignmentOnInteriorDomain
      U0 Dv Du boundaryGap C hCarrierConvex hBoundaryInterior
        hAbsorbsDirections hSubjectiveGapNonzero,
    adverseBoundary_not_convex U0 Dv Du boundaryGap C hCarrierConvex
      hBoundaryInterior hAbsorbsDirections hSubjectiveGapNonzero⟩

/-- Definition 5: finite ex-ante feasibility carrier plus the exact realized
    transition, stopping, and no-revisit semantics. -/
theorem idpDefinitionContract
    {V : Type u} [Fintype V] [DecidableEq V]
    {Omega : Type v} [Fintype Omega]
    (X : FiniteExAnteIDP V Omega) (omega : Omega)
    (s t : IDPState V) :
    0 <= X.weight omega /\
    Finset.univ.sum X.weight = 1 /\
    (X.realized omega).baseGraph = X.baseGraph /\
    (X.realized omega).openGraph = X.feasibleGraph omega /\
    (X.realized omega).terminal = X.terminal /\
    (X.realized omega).localScore = X.localScore /\
    (X.realized omega).welfare = X.welfare /\
    X.initialState omega = IDPState.initial X.initialVertex /\
    ((X.realized omega).Step s t <->
      s.current ∉ (X.realized omega).terminal /\
      (X.realized omega).openGraph.Adj s.current t.current /\
      t.current ∉ s.history /\
      t.history = insert s.current s.history) /\
    ((X.realized omega).IsStopping s <->
      s.current ∈ (X.realized omega).terminal \/
        Not (exists next : IDPState V, (X.realized omega).Step s next)) /\
    ((X.realized omega).attainableStops (X.initialState omega)).Nonempty := by
  exact ⟨X.weight_nonneg omega, X.weight_sum_one, rfl, rfl, rfl, rfl, rfl,
    rfl, Iff.rfl, Iff.rfl,
    (X.realized omega).attainableStops_nonempty (X.initialState omega)⟩

/-- Theorem 6 with literal finite expectations and separate local scores. -/
theorem routeReversalContract
    {V : Type u} [Fintype V] [DecidableEq V]
    {Omega : Type v} [Fintype Omega]
    (X : FiniteExAnteIDP V Omega) (routeOne routeTwo : Omega -> Real)
    (ellOne ellTwo : Real)
    (hImmediateRanking : ellTwo < ellOne)
    (hContinuationRanking :
      expectedContinuation X.weight routeOne <
        expectedContinuation X.weight routeTwo) :
    (forall betaLow betaHigh : Set.Ioi (0 : Real),
      betaLow.1 < betaHigh.1 ->
        GaussianScoreGarbling
          (fun i : Fin 2 => if i = 0 then ellOne else ellTwo)
          betaLow betaHigh) /\
    (forall beta,
      terminalWelfare
          (expectedContinuation X.weight routeOne)
          (expectedContinuation X.weight routeTwo)
          (ellOne - ellTwo) beta =
        expectedContinuation X.weight routeOne +
          Phi (-(ellOne - ellTwo) *
            CurrentRouteReversal.precisionScale beta) *
            (expectedContinuation X.weight routeTwo -
              expectedContinuation X.weight routeOne)) /\
    StrictAntiOn
      (terminalWelfare
        (expectedContinuation X.weight routeOne)
        (expectedContinuation X.weight routeTwo)
        (ellOne - ellTwo))
      (Set.Ioi 0) := by
  have hReversal := finiteRouteReversal X.weight routeOne routeTwo ellOne ellTwo
    hImmediateRanking hContinuationRanking
  exact ⟨fun betaLow betaHigh hBeta =>
      gaussianScoreGarbling_of_lt
        (fun i : Fin 2 => if i = 0 then ellOne else ellTwo) hBeta,
    hReversal.1, hReversal.2⟩

/-- Lemma 8 with the paper's attainable dynamic oracle. -/
theorem feasibilityPolicyDecompositionContract
    {V : Type u} [Fintype V] [DecidableEq V] [Nonempty V]
    {Omega : Type v} [MeasurableSpace Omega]
    (setup : UnifiedWelfareSetup V Omega) :
    setup.toWelfareSetup.welfare =
        setup.toWelfareSetup.W_topo + setup.toWelfareSetup.W_info /\
      setup.toWelfareSetup.W_topo <= 0 /\
      setup.toWelfareSetup.W_info <= 0 /\
      setup.oracleWelfareSetup.W_info = 0 /\
      setup.oracleWelfareSetup.welfare = setup.toWelfareSetup.W_topo := by
  exact ⟨setup.welfare_decomposition,
    setup.dynamic_topology_component_nonpos,
    setup.informational_residual_nonpos,
    setup.oracle_informational_residual_zero,
    setup.oracle_welfare_eq_agent_dynamic_topology_component⟩

/-- Theorem 9 with explicit uniqueness, the nonnegative cognition range, and
    the positive-precision domain. -/
theorem cognitiveThresholdContract
    (m0 mInf lowReward highReward : Real)
    (hMyopicNegative : m0 < 0) (hInformedPositive : 0 < mInf)
    (hRewardRanking : lowReward < highReward) :
    let kStar := kappaStar m0 mInf
    0 < kStar /\
    representedScore m0 mInf kStar = 0 /\
    (forall kappa, representedScore m0 mInf kappa = 0 -> kappa = kStar) /\
    (forall kappa, 0 <= kappa -> kappa < kStar ->
      StrictAntiOn
        (fun beta => cognitionWelfare
          m0 mInf lowReward highReward beta kappa)
        (Set.Ioi 0)) /\
    (forall beta,
      cognitionWelfare m0 mInf lowReward highReward beta kStar =
        lowReward + (highReward - lowReward) * Phi 0) /\
    (forall kappa, kStar < kappa ->
      StrictMonoOn
        (fun beta => cognitionWelfare
          m0 mInf lowReward highReward beta kappa)
        (Set.Ioi 0)) := by
  dsimp
  have hThreshold := kappaStar_isThreshold hMyopicNegative hInformedPositive
  have hClaim := cognitiveThresholdClaim_proved
    m0 mInf lowReward highReward hMyopicNegative hInformedPositive
      hRewardRanking
  exact ⟨hThreshold.1, hThreshold.2.1,
    fun kappa hZero =>
      (representedScore_eq_zero_iff hMyopicNegative hInformedPositive).1 hZero,
    hClaim.2.1, hClaim.2.2.1, hClaim.2.2.2⟩

/-- Proposition 10 on the literal nonnegative cognition carrier. -/
theorem localComplementarityContract
    (m0 mInf lowReward highReward beta : Real)
    (kappa : Set.Ici (0 : Real))
    (hMyopicNegative : m0 < 0) (hInformedPositive : 0 < mInf)
    (hRewardRanking : lowReward < highReward) (hPositivePrecision : 0 < beta)
    (hModerate : |cognitionIndex m0 mInf beta kappa.1| < 1) :
    HasDerivAt
      (fun kappa' => cognitionWelfare
        m0 mInf lowReward highReward beta kappa')
      (cognitionMarginal m0 mInf lowReward highReward beta kappa.1) kappa.1 /\
    HasDerivAt
      (fun beta' => cognitionMarginal
        m0 mInf lowReward highReward beta' kappa.1)
      (mixedCrossPartial m0 mInf lowReward highReward beta kappa.1) beta /\
    mixedCrossPartial m0 mInf lowReward highReward beta kappa.1 =
      (highReward - lowReward) *
        representedScoreDerivative m0 mInf kappa.1 *
        CurrentComplementarity.precisionScaleDerivative beta *
        phi (cognitionIndex m0 mInf beta kappa.1) *
        (1 - cognitionIndex m0 mInf beta kappa.1 ^ 2) /\
    0 < mixedCrossPartial m0 mInf lowReward highReward beta kappa.1 := by
  have hGap : m0 < mInf := hMyopicNegative.trans hInformedPositive
  exact ⟨cognitionWelfare_hasDerivAt_kappa _ _ _ _ _ _,
    cognitionMarginal_hasDerivAt_beta hPositivePrecision,
    rfl,
    mixedCrossPartial_pos hGap hRewardRanking hPositivePrecision hModerate⟩

/-- Proposition 11 with exact rational parameters, endpoints, one-sided
    infinite-precision limit, and a global minimum on `beta >= 0`. -/
theorem interiorOptimalPrecisionContract :
    fiveStateReward .S = 0 /\
    fiveStateReward .A = (6 : Real) / 10 /\
    fiveStateReward .B = (4 : Real) / 10 /\
    fiveStateReward .D = (1 : Real) / 10 /\
    fiveStateReward .G = 1 /\
    (forall x y, fiveStateGraph.Adj x y ↔ fiveStateAdjacency x y) /\
    fiveStateTerminal = { .A, .D, .G } /\
    deltaS = (1 : Real) / 5 /\
    deltaB = (9 : Real) / 10 /\
    (forall beta,
      distractorProbability beta =
        1 - Phi (deltaB * CurrentGaussian.precisionScale beta)) /\
    (forall beta,
      expectedLoss beta =
        (4 / 10 : Real) * Phi (deltaS * CurrentGaussian.precisionScale beta) +
          (9 / 10 : Real) *
            (1 - Phi (deltaS * CurrentGaussian.precisionScale beta)) *
            (1 - Phi (deltaB * CurrentGaussian.precisionScale beta))) /\
    expectedLoss 0 = (425 : Real) / 1000 /\
    Tendsto expectedLoss atTop (nhds ((4 : Real) / 10)) /\
    (exists betaStar : Real,
      0 < betaStar /\
      (forall beta : Real, 0 <= beta -> expectedLoss betaStar <= expectedLoss beta) /\
      expectedLoss betaStar < (4 : Real) / 10) /\
    (4 : Real) / 10 < (425 : Real) / 1000 := by
  rcases fiveStateRewards with ⟨hS, hA, hB, hD, hG⟩
  rcases fiveStateTopology with ⟨hTopology, hTerminal⟩
  refine ⟨hS, hA, hB, hD, hG, hTopology, hTerminal, ?_, ?_,
    distractorProbability_formula, ?_, expectedLoss_zero,
    expectedLoss_tendsto_atTop, exists_global_interior_minimum, by norm_num⟩
  · norm_num [deltaS, fiveStateReward]
  · norm_num [deltaB, fiveStateReward]
  intro beta
  simpa [trapProbability, goalProbability, distractorProbability] using
    expectedLoss_formula beta

end BlackwellDilemma.CurrentPaperContracts
