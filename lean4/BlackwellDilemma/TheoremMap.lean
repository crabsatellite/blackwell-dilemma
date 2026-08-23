/-
  Publication-facing Theory and Decision theorem map.

  Every labeled mathematical object in the current 17-page manuscript has a
  named kernel carrier or proof endpoint below. Historical extended-paper
  claims do not enter this map.
-/

import BlackwellDilemma.CurrentPaperLedger
import BlackwellDilemma.CurrentPaperContracts

open BlackwellDilemma

/-! ## Definition 1: induced posterior welfare and experiment value. -/
#check CurrentPosterior.PosteriorDecisionModel
#check CurrentPosterior.PosteriorDecisionModel.inducedPosteriorWelfare
#check CurrentPosterior.PosteriorDecisionModel.experimentObjectiveValue
#check CurrentPosterior.FinitePosteriorExperiment
#check CurrentPosterior.FinitePosteriorExperiment.objectiveValue
#check CurrentPaperContracts.posteriorWelfareDefinitionContract

/-! ## Theorem 2: posterior-convexity frontier and binary witness. -/
#check CurrentPosterior.FiniteBlackwellRefinement
#check CurrentPosterior.posteriorConvexityFrontier
#check CurrentPosterior.not_convex_exists_binary_witness
#check CurrentPaperLedger.posteriorConvexityFrontierClaim_proved
#check CurrentPaperContracts.posteriorConvexityFrontierContract

/-! ## Theorem 3: nondegenerate two-action alignment on the translated
    relative-interior affine-hull domain. -/
#check CurrentTwoAction.twoActionWelfare
#check CurrentTwoAction.twoActionWelfareWithBoundary
#check CurrentTwoAction.PositivelyAligned
#check CurrentTwoAction.AbsorbsDirections
#check CurrentTwoAction.twoActionAlignment
#check CurrentTwoAction.twoActionAlignmentOnAbsorbingDomain
#check CurrentTwoAction.twoActionAffineAlignmentOnInteriorDomain
#check CurrentPaperLedger.twoActionAlignmentClaim_proved
#check CurrentPaperContracts.twoActionAlignmentContract

/-! ## Definition 5: finite irreversibility decision problem. -/
#check IDPModel
#check IDPState
#check IDPState.initial
#check IDPModel.Step
#check IDPModel.IsStopping
#check IDPModel.Reaches
#check IDPModel.attainableStops
#check IDPModel.attainableStops_nonempty
#check IDPModel.oracleValue
#check UnifiedWelfareSetup
#check FiniteExAnteIDP
#check CurrentPaperContracts.idpDefinitionContract

/-! ## Theorem 6: strict Gaussian route reversal. -/
#check CurrentRouteReversal.routeTwoProbability
#check CurrentRouteReversal.precisionScale
#check CurrentRouteReversal.precisionScale_eq_inverse_difference_std
#check CurrentRouteReversal.terminalWelfare
#check CurrentRouteReversal.terminalWelfare_formula
#check CurrentRouteReversal.routeReversal_strictAntiOn
#check CurrentPaperLedger.routeReversalClaim_proved
#check CurrentPaperContracts.routeReversalContract

/-! ## Theorem 7: restoration under feasibility knowledge. -/
#check CurrentPosterior.PosteriorDecisionModel.inducedPosteriorWelfare_convex_of_aligned
#check CurrentPosterior.alignedObjective_respectsFiniteBlackwellRefinements
#check CurrentPosterior.finiteExpectation
#check CurrentPosterior.finiteExpectation_mono
#check CurrentPaperLedger.restorationClaim_proved
#check CurrentRestoration.AttainableTerminal
#check CurrentRestoration.restorationUnderObservedFiniteFeasibility

/-! ## Lemma 8: feasibility and policy decomposition. -/
#check UnifiedWelfareSetup.welfare_decomposition
#check UnifiedWelfareSetup.dynamic_topology_component_nonpos
#check UnifiedWelfareSetup.informational_residual_nonpos
#check UnifiedWelfareSetup.oracle_welfare_eq_agent_dynamic_topology_component
#check CurrentPaperLedger.feasibilityPolicyDecompositionClaim_proved
#check CurrentPaperContracts.feasibilityPolicyDecompositionContract

/-! ## Theorem 9: exact cognitive threshold and strict regimes. -/
#check CurrentCognition.kappaStar
#check CurrentCognition.assimilationWeight
#check CurrentCognition.representedScore
#check CurrentCognition.cognitionIndex
#check CurrentCognition.cognitionWelfare
#check CurrentCognition.kappaStar_isThreshold
#check CurrentCognition.cognitionWelfare_strictAntiOn_of_score_neg
#check CurrentCognition.cognitionWelfare_at_kappaStar
#check CurrentCognition.cognitionWelfare_strictMonoOn_of_score_pos
#check CurrentCognition.cognitiveThresholdClaim_proved
#check CurrentPaperContracts.cognitiveThresholdContract

/-! ## Proposition 10: local information-knowledge complementarity. -/
#check CurrentComplementarity.assimilationDerivative
#check CurrentComplementarity.representedScoreDerivative
#check CurrentComplementarity.precisionScaleDerivative
#check CurrentComplementarity.cognitionMarginal
#check CurrentComplementarity.mixedCrossPartial
#check CurrentComplementarity.cognitionMarginal_hasDerivAt_beta
#check CurrentComplementarity.mixedCrossPartial_pos
#check CurrentComplementarity.localComplementarityClaim_proved
#check CurrentPaperLedger.complementarityClaim_proved
#check CurrentPaperContracts.localComplementarityContract

/-! ## Proposition 11: five-state interior optimal precision. -/
#check CurrentFiveState.deltaS
#check CurrentFiveState.deltaB
#check CurrentFiveState.trapProbability
#check CurrentFiveState.goalProbability
#check CurrentFiveState.routeProbability
#check CurrentFiveState.routeProbability_sum_one
#check CurrentFiveState.expectedLoss_formula
#check CurrentFiveState.expectedLoss_sub_limit
#check CurrentFiveState.expectedLoss_zero
#check CurrentFiveState.expectedLoss_tendsto_atTop
#check CurrentFiveState.exists_global_interior_minimum
#check CurrentFiveState.interiorOptimumClaim_proved
#check CurrentPaperLedger.interiorOptimumClaim_proved
#check CurrentPaperContracts.interiorOptimalPrecisionContract

/-! ## Load-bearing displayed derivations outside theorem statements. -/
#check CurrentPosterior.FiniteBlackwellRefinement.barycenter
#check CurrentPosterior.FiniteBlackwellRefinement.coarseValue
#check CurrentPosterior.FiniteBlackwellRefinement.refinedValue
#check CurrentPosterior.FiniteBlackwellRefinement.value_mono_of_convex
#check CurrentPosterior.not_convex_exists_binary_witness
#check CurrentTwoAction.twoActionWelfareWithBoundary
#check CurrentRouteReversal.precisionScale_eq_inverse_difference_std
#check CurrentRouteReversal.terminalWelfare_formula
#check UnifiedWelfareSetup.welfare_decomposition
#check CurrentCognition.representedScore_kappaStar
#check CurrentComplementarity.cognitionWelfare_hasDerivAt_kappa
#check CurrentComplementarity.cognitionMarginal_hasDerivAt_beta
#check CurrentFiveState.expectedLoss_formula
#check CurrentFiveState.expectedLoss_sub_limit
#check CurrentFiveState.expectedLoss_zero
#check CurrentFiveState.expectedLoss_tendsto_atTop
#check CurrentFiveState.exists_global_interior_minimum
