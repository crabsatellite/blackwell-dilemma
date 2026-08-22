/-
  Publication-facing Theory and Decision theorem map.

  Every labeled mathematical object in the current 17-page manuscript has a
  named kernel carrier or proof endpoint below. Historical extended-paper
  claims do not enter this map.
-/

import BlackwellDilemma.CurrentPaperLedger

open BlackwellDilemma

/-! ## Definition 1: induced posterior welfare and experiment value. -/
#check CurrentPosterior.PosteriorDecisionModel
#check CurrentPosterior.PosteriorDecisionModel.inducedPosteriorWelfare
#check CurrentPosterior.PosteriorDecisionModel.experimentObjectiveValue

/-! ## Theorem 2: posterior-convexity frontier and binary witness. -/
#check CurrentPosterior.FiniteBlackwellRefinement
#check CurrentPosterior.posteriorConvexityFrontier
#check CurrentPosterior.not_convex_exists_binary_witness
#check CurrentPaperLedger.posteriorConvexityFrontierClaim_proved

/-! ## Theorem 3: two-action alignment on the translated affine hull. -/
#check CurrentTwoAction.twoActionWelfare
#check CurrentTwoAction.PositivelyAligned
#check CurrentTwoAction.twoActionAlignment
#check CurrentPaperLedger.twoActionAlignmentClaim_proved

/-! ## Definition 5: finite irreversibility decision problem. -/
#check IDPModel
#check IDPState
#check IDPModel.Step
#check IDPModel.IsStopping
#check IDPModel.Reaches
#check IDPModel.attainableStops
#check IDPModel.attainableStops_nonempty

/-! ## Theorem 6: strict Gaussian route reversal. -/
#check CurrentRouteReversal.routeTwoProbability
#check CurrentRouteReversal.terminalWelfare
#check CurrentRouteReversal.terminalWelfare_formula
#check CurrentRouteReversal.routeReversal_strictAntiOn
#check CurrentPaperLedger.routeReversalClaim_proved

/-! ## Theorem 7: restoration under feasibility knowledge. -/
#check CurrentPosterior.PosteriorDecisionModel.inducedPosteriorWelfare_convex_of_aligned
#check CurrentPosterior.alignedObjective_respectsFiniteBlackwellRefinements
#check CurrentPaperLedger.restorationClaim_proved

/-! ## Lemma 8: feasibility and policy decomposition. -/
#check UnifiedWelfareSetup.welfare_decomposition
#check UnifiedWelfareSetup.dynamic_topology_component_nonpos
#check UnifiedWelfareSetup.informational_residual_nonpos
#check UnifiedWelfareSetup.oracle_welfare_eq_agent_dynamic_topology_component
#check CurrentPaperLedger.feasibilityPolicyDecompositionClaim_proved

/-! ## Theorem 9: exact cognitive threshold and strict regimes. -/
#check CurrentCognition.kappaStar
#check CurrentCognition.kappaStar_isThreshold
#check CurrentCognition.welfare_strictAntiOn_of_score_neg
#check CurrentCognition.welfare_at_kappaStar_independent
#check CurrentCognition.welfare_strictMonoOn_of_score_pos
#check CurrentCognition.cognitiveThresholdClaim_proved

/-! ## Proposition 10: local information-knowledge complementarity. -/
#check SupermodularCognition.mixedDerivativeValue
#check SupermodularCognition.cognitionMarginal_hasDerivAt_beta
#check SupermodularCognition.mixedDerivativeValue_pos
#check SupermodularCognition.supermodularCognitionClaim_proved
#check CurrentPaperLedger.complementarityClaim_proved

/-! ## Proposition 11: five-state interior optimal precision. -/
#check FiveStateRouting.routeProbability_sum_one
#check FiveStateRouting.expectedLoss_formula
#check FiveStateRouting.uniqueInteriorMinimum
#check FiveStateRouting.interiorOptimumClaim_proved
#check CurrentPaperLedger.interiorOptimumClaim_proved
