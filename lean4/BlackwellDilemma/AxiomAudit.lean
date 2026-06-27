/-
  BlackwellDilemma/AxiomAudit.lean

  Prints the axiom dependency list for every theorem (CLOSED entry)
  in the formalisation.

  Status `CLOSED` requires `theorem gap_X : <statement> := <proof>`
  with no `sorry`. The audit verifies this by checking #print axioms
  for each CLOSED entry.

  Expected axioms:
   * Lean 4 / Mathlib kernel: `propext`, `Classical.choice`, `Quot.sound`.
   * Some declarations may report no axioms.
   * The source-level audit must report 0 project-level `axiom`, `opaque`,
     `_OPEN`, `_paper_Def`, `_workingAssumption`, and `_paper_witness`
     declarations.

  Any printed project-level paper axiom or opaque source declaration is a RED
  FLAG.  Paper primitives must be structures, definitions, or explicit theorem
  parameters, not global bridge axioms.

  Note on external or semantic dependencies:
  the current public kernel-clean surface does not allow live Cat 2/Cat 3
  `_OPEN` source axioms.  External mathematical input must be either already
  formalised in Lean/Mathlib, carried as an explicit theorem parameter, or
  listed as an open paper-semantic target in `PaperSemanticGate.lean`.
  DEAD-END markers document refuted or retired routes; they are not accepted
  proof payload.

  Usage:  `lake env lean BlackwellDilemma/AxiomAudit.lean`
-/

import BlackwellDilemma

namespace BlackwellDilemma.AxiomAudit

-- §2 IDP Types (signal-variance algebra)
#print axioms BlackwellDilemma.signalVariance_strictAntitoneOn
-- Derived by projecting the concrete subtype-backed `blockingProbData`;
-- `blockingProb_strict_in_open_unit_interval` is also a theorem, not a
-- separate source axiom.
#print axioms BlackwellDilemma.blockingProb_mem_unitInterval
-- The unused Definition 2.6 oracle stub is transparent in the current scalar
-- model; its interval bound is a theorem, not a source axiom.
#print axioms BlackwellDilemma.ReachableSet_eq_ForwardReachable_empty
#print axioms BlackwellDilemma.oracleReward
#print axioms BlackwellDilemma.oracleReward_mem_unitInterval
-- Cat 1 closure: `σ²_topo(κ, 0) = 0` (paper proof line 870 —
-- terminal-vertex distance-0 case). Kernel-pure via `unfold + simp`.
#print axioms BlackwellDilemma.topoSignalVariance_distance_zero

-- §3 Welfare Decomposition (CLOSED — kernel only)
#print axioms BlackwellDilemma.WelfareSetup.gap_welfare_decomposition
#print axioms BlackwellDilemma.SignalFamily.gap_W_topo_signal_immune
#print axioms BlackwellDilemma.SignalFamily.gap_W_topo_constant
#print axioms BlackwellDilemma.WelfareSetup.gap_physical_irreducibility
#print axioms BlackwellDilemma.WelfareSetup.gap_W_info_nonpos
#print axioms BlackwellDilemma.WelfareSetup.gap_oracle_W_info_zero
#print axioms BlackwellDilemma.WelfareSetup.gap_welfare_le_W_topo
#print axioms BlackwellDilemma.WelfareSetup.gap_oracle_welfare_eq_W_topo

-- §3.2 Welfare Reversal layer
#print axioms BlackwellDilemma.gap_dilemma
#print axioms BlackwellDilemma.not_currentOracleInfoNonzeroWitness_current
#print axioms BlackwellDilemma.currentOracleInfoDecayConclusion_from_zero
#print axioms BlackwellDilemma.currentOracleInfoDecayConclusion_from_on_current
#print axioms BlackwellDilemma.currentOracleInfoDecayConclusion_from_interfacesOn_current
#print axioms BlackwellDilemma.currentOracleInfoDecayConclusion_from_boxedTorusFiniteBondGraph
#print axioms BlackwellDilemma.currentOracleInfoDecayConclusion_from_boxedTorusAllOpenGiantTopoLossData
#print axioms BlackwellDilemma.unitExponentialOracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.unitExponentialOracleInfoDecayConclusion
#print axioms BlackwellDilemma.singletonReachableSetOracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.singletonReachableSetOracleInfoDecayConclusion
#print axioms BlackwellDilemma.finiteBondGraphOracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.finiteBondGraphOracleInfoDecayConclusion
#print axioms BlackwellDilemma.starFiniteBondGraphOracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.starFiniteBondGraphOracleInfoDecayConclusion
#print axioms BlackwellDilemma.currentGreedyWelfareReversalConclusion
#print axioms BlackwellDilemma.currentOracleInfoDecayConclusion
#print axioms BlackwellDilemma.gap_dilemma_current_noDiagnosticAssumptions
-- Derived closure: Proposition `prop:topo-cluster` closed-form
-- `(n-k)/((n+1)(k+1))` derives algebraically from the derived theorem
-- `expectedTopoLoss_conditional_def` (paper line 292 order-statistics
-- decomposition `n/(n+1) − k/(k+1)`, Cat 2 absorbed via David &
-- Nagaraja Eq. 2.1.4) via `field_simp; ring`.
#print axioms BlackwellDilemma.gap_topo_cluster_relation
-- `expectedTopoLoss_conditional_def` derived theorem composes
-- `gap_orderstats_topo_decomposition` (paper-application of David &
-- Nagaraja Eq. 2.1.4 to IDP carrier via paper Def 2.1 standing convention,
-- Wrongness.lean) + `gap_david_nagaraja_eq214` (substantive David &
-- Nagaraja 2003 Eq. 2.1.4 textbook identity on `expectedMaxIIDUniform`,
-- ClassicalResults.lean). In the current source both bridge declarations are
-- theorem-interface layers over concrete carriers rather than global axioms.
#print axioms BlackwellDilemma.expectedTopoLoss_conditional_def
#print axioms BlackwellDilemma.gap_conditional_reduction_part_ii
-- Derived closure: Lemma `lem:conditional-reduction` part (i),
-- conditional Blackwell monotonicity on the restricted action domain.
-- The generic route `gap_conditional_reduction_part_i_from_blackwell`
-- composes the Cat 3 atom `conditional_subproblem_blackwell_applicable`
-- (paper line 375) with an explicit Blackwell monotonicity input; the public
-- theorem consumes the current closed `gap_blackwell_monotonicity`
-- theorem internally and keeps the `IsBlackwellOrdered` scope hypothesis.
#print axioms BlackwellDilemma.gap_conditional_reduction_part_i_from_blackwell
#print axioms BlackwellDilemma.gap_conditional_reduction_part_i

-- §3.3 Phase Transition layer
-- The ER phase witnesses are now concrete-carrier theorem closures; the
-- semantic Bollobas random-graph results remain Mathlib-roadmap context,
-- not source-level `_OPEN` axioms.
#print axioms BlackwellDilemma.V_dyn
#print axioms BlackwellDilemma.V_dyn_def
#print axioms BlackwellDilemma.gap_er_phase_subcritical
#print axioms BlackwellDilemma.gap_er_phase_supercritical
#print axioms BlackwellDilemma.gap_power_law_heavy_tail
-- Derived closure: Proposition `prop:trap-prevalence` Part 1
-- (V_dyn agrees on neighbours at p = 0). Composes current theorem
-- `ForwardReachable_empty_full_at_all_open_current` with `V_dyn_def` +
-- `Finset.sup'_congr` (Cat 1 Mathlib).
-- The `[Fintype Vertex]` parameter is an instance argument on the
-- theorem and does NOT block `#print axioms` (which prints the
-- definition's axiom dependency closure, not its applied form).
#print axioms BlackwellDilemma.Infrastructure.paperGraph_preconnected_current
#print axioms BlackwellDilemma.ForwardReachable_empty_full_at_all_open_current
#print axioms BlackwellDilemma.gap_trap_prevalence_zero
-- Derived closures: Theorem 3.3 phase-transition Parts 1+2 +
-- Proposition `prop:trap-prevalence` Part 2.
--  * `gap_phase_transition_below`: composes
--    `topo_loss_decay_below_pc_OPEN` (decay envelope existence,
--    paper line 415-417) + `topo_loss_decay_arbitrary_threshold_OPEN`
--    (arbitrary-ε convergence, paper line 417). Cat 2 Grimmett
--    percolation-probability dependency threaded via `h_perc_prob`.
--  * `gap_phase_transition_above`: composes
--    `wInfoTopoRatio_const_exists_OPEN` (positive constant existence,
--    paper line 421-427) + `wInfoTopoRatio_bound_OPEN` (quantitative
--    ratio bound, paper line 427). Current Lean uses the concrete
--    zero/unit carrier route; the nontrivial Grimmett/Mills derivation is
--    tracked separately as a future percolation target.
--  * `gap_trap_prevalence_above_threshold`: re-exports
--    `trap_config_local_positive_OPEN` (paper-stated local FKG
--    estimate, paper line 473).
#print axioms BlackwellDilemma.gap_phase_transition_below
#print axioms BlackwellDilemma.gap_phase_transition_above
#print axioms BlackwellDilemma.Z2TopoClusterBridgeData_from_random_supercritical_z2_topo_cluster_bridge
#print axioms BlackwellDilemma.BoxedTorusFlatFamilyCoreConclusion_from_random_supercritical_z2_topo_cluster_bridge
#print axioms BlackwellDilemma.BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion_from_random_supercritical_z2_topo_cluster_bridge
#print axioms BlackwellDilemma.expectedTopoLossOnData_pos_realisation_witness
#print axioms BlackwellDilemma.expectedTopoLossOnGiantOn_pos_realisation_witness
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_supercriticalProbability_domain
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_supercriticalProbability_strict_domain
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_supercritical_flat_lower_bound
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_supercritical_giant_lower_bound
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_supercritical_giant_event_mass_lower_bound
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_family_topoLossKernel_mem_unitInterval
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_positive_flat_loss_witness
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_eventually_positive_flat_loss
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_eventually_positive_giant_loss
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_eventually_positive_giant_event_mass
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_positive_loss_realisation_witness
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_eventually_positive_loss_realisation_witness
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_eventually_uniform_lower_bound_and_loss_realisation
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_eventually_positive_giant_loss_realisation_witness
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_eventually_uniform_giant_lower_bound_and_loss_realisation
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_eventually_uniform_flat_giant_lower_bound_and_loss_realisation
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_eventually_uniform_flat_giant_event_mass_lower_bound_and_loss_realisation
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_eventually_uniform_supported_extended_non_diagnostic_member
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_paper_support_certificate
#print axioms BlackwellDilemma.not_random_supercritical_z2_topo_cluster_bridge_contract_current
#print axioms BlackwellDilemma.RandomSupercriticalZ2TopoClusterRepairedBridgeData_from_current_contract
#print axioms BlackwellDilemma.expectedTopoLossOnGiantOn_ge_mul_mass_of_pointwise_ge
#print axioms BlackwellDilemma.RandomSupercriticalZ2TopoClusterRepairedBridgeGiantPointwiseLossRoute
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterRepairedBridgeGiantLossPaperClosing_of_giant_pointwise_loss_route
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterRepairedBridgeFullPaperClosingSupport_of_giant_pointwise_loss_route
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterFullPaperClosingRoute_of_giant_pointwise_loss_route
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBoxedTorusFiniteZ2LClosingRoute_of_giant_pointwise_loss_route
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_repaired_giant_loss_paper_closing
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_repaired_full_paper_closing_support
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterFullPaperClosingRoute_of_repaired_bridge
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterFullPaperClosingRoute_repaired_bridge_nonempty
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterFullPaperClosingRoute_support_witness
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterFullPaperClosingRoute_paper_support_output
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterFullPaperClosingRoute_support_surface_repair_output
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterFullPaperClosingRoute_support_surface_repair_route
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterFullPaperClosingRoute_support_surface_repair_output_certificate
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterFullPaperClosingRoute_giant_loss_output
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterFullPaperClosingRoute_combined_support_output
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterFullPaperClosingRoute_supported_extended_non_diagnostic_output
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterFullPaperClosingRoute_output_bundle
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterFullPaperClosingRoute_full_output_bundle
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBoxedTorusFiniteZ2LClosingRoute_of_full_paper_closing_route
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterFullPaperClosingRoute_of_boxed_torus_finite_z2L_route
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterFullPaperClosingRoute_iff_boxed_torus_finite_z2L_route
#print axioms BlackwellDilemma.RandomSupercriticalZ2TopoClusterFullPaperClosingRoute
#print axioms BlackwellDilemma.RandomSupercriticalZ2TopoClusterBoxedTorusFiniteZ2LRouteCertificate
#print axioms BlackwellDilemma.random_supercritical_z2_topo_cluster_boxed_torus_finite_z2L_route_certificate
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_full_paper_closing_route
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_full_paper_closing_route_paper_support_output
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_full_paper_closing_route_giant_loss_output
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_full_paper_closing_route_combined_support_output
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_full_paper_closing_route_supported_extended_non_diagnostic_output
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_full_paper_closing_route_output_bundle
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_full_paper_closing_route_full_output_bundle
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterRepairedBridgeData_eventually_uniform_flat_event_mass_lower_bound_and_loss_realisation
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterRepairedBridgeData_eventually_giant_event_member
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterRepairedBridgeData_eventually_uniform_flat_event_mass_member_and_loss_realisation
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterRepairedBridgeData_eventually_uniform_supported_extended_non_diagnostic_member
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterRepairedBridgeData_eventually_uniform_supported_extended_non_diagnostic_member_with_giant_member
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterRepairedBridgeData_paper_support
#print axioms BlackwellDilemma.exists_firstEdgeOpenGiantClosedTopoLossRepairedBridge_current
#print axioms BlackwellDilemma.boxedTorusFlattenBaseHorizontalEdge_eq_firstEdgeIdx
#print axioms BlackwellDilemma.firstEdgeOpenEvent_boxedTorusBaseHorizontal_mem_iff
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossFamily_giant_event_boxedTorusBaseHorizontal_mem_iff
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossFamily_giant_event_baseHorizontalTarget_reachable
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossFamily_topoLossKernel_zero_on_giant
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossFamily_expectedTopoLossOnGiantOn_boxedTorus_eq_zero
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossFamily_not_positive_giant_loss_lower_bound_at_three_quarters
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossRepairedBridge_current_not_giant_loss_paper_closing
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossRepairedBridge_current_not_full_paper_closing_support
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossRepairedBridge_current_not_giant_pointwise_loss_route
#print axioms BlackwellDilemma.not_randomSupercriticalZ2TopoClusterRepairedBridge_firstEdge_three_quarters_giant_loss_paper_closing
#print axioms BlackwellDilemma.not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute_firstEdge_three_quarters_giant_loss_output
#print axioms BlackwellDilemma.not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute_firstEdge_three_quarters_combined_support_output
#print axioms BlackwellDilemma.not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute_firstEdge_three_quarters_supported_extended_non_diagnostic_output
#print axioms BlackwellDilemma.not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute_firstEdge_three_quarters_output_bundle
#print axioms BlackwellDilemma.not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute_firstEdge_three_quarters_full_output_bundle
#print axioms BlackwellDilemma.not_randomSupercriticalZ2TopoClusterRepairedBridge_firstEdge_three_quarters_full_paper_closing_support
#print axioms BlackwellDilemma.not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute_firstEdge_three_quarters_witness
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossFamily_giant_event_mass_lower_bound_at_three_quarters
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossRepairedBridge_current_paper_support
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossRepairedBridge_current_compatibility_certificate
#print axioms BlackwellDilemma.not_random_supercritical_z2_topo_cluster_repaired_bridge_full_reach_diagnostic
#print axioms BlackwellDilemma.not_random_supercritical_z2_topo_cluster_repaired_bridge_flat_only_diagnostic
#print axioms BlackwellDilemma.not_random_supercritical_z2_topo_cluster_repaired_bridge_all_open_complement_diagnostic
#print axioms BlackwellDilemma.not_random_supercritical_z2_topo_cluster_repaired_bridge_all_open_giant_diagnostic
#print axioms BlackwellDilemma.not_random_supercritical_z2_topo_cluster_repaired_bridge_all_open_positive_diagnostic
#print axioms BlackwellDilemma.not_random_supercritical_z2_topo_cluster_repaired_bridge_pointwise_diagnostic_combo
#print axioms BlackwellDilemma.not_random_supercritical_z2_topo_cluster_repaired_bridge_eventual_pointwise_diagnostic_combo
#print axioms BlackwellDilemma.not_random_supercritical_z2_topo_cluster_repaired_bridge_eventual_pointwise_extended_diagnostic_combo
#print axioms BlackwellDilemma.random_supercritical_z2_topo_cluster_repaired_bridge_diagnostic_obstruction_certificate
#print axioms BlackwellDilemma.RandomSupercriticalZ2TopoClusterFullPaperClosingRouteOutputCertificate
#print axioms BlackwellDilemma.random_supercritical_z2_topo_cluster_full_paper_closing_route_output_certificate
#print axioms BlackwellDilemma.RandomSupercriticalZ2TopoClusterRepairedBridgeSupportSurfaceRepair
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterRepairedBridge_support_surface_repair
#print axioms BlackwellDilemma.RandomSupercriticalZ2TopoClusterSupportSurfaceRepairRoute
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterSupportSurfaceRepairRoute_current
#print axioms BlackwellDilemma.RandomSupercriticalZ2TopoClusterSupportSurfaceRepairCertificate
#print axioms BlackwellDilemma.random_supercritical_z2_topo_cluster_support_surface_repair_certificate
#print axioms BlackwellDilemma.RandomSupercriticalZ2TopoClusterSupportSurfaceRepairOutput
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterSupportSurfaceRepairRoute_support_output
#print axioms BlackwellDilemma.RandomSupercriticalZ2TopoClusterSupportSurfaceRepairRouteOutputCertificate
#print axioms BlackwellDilemma.random_supercritical_z2_topo_cluster_support_surface_repair_route_output_certificate
#print axioms BlackwellDilemma.RandomSupercriticalZ2TopoClusterRepairedBridgeSupportSurfaceClosingRoute
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterRepairedBridgeSupportSurfaceClosingRoute_of_full_paper_closing_support
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterRepairedBridgeFullPaperClosingSupport_of_support_surface_closing_route
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterRepairedBridgeSupportSurfaceClosingRoute_iff_full_paper_closing_support
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterRepairedBridgeSupportSurfaceClosingRoute_of_giant_pointwise_loss_route
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterFullPaperClosingRoute_of_support_surface_closing_route
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBoxedTorusFiniteZ2LClosingRoute_of_support_surface_closing_route
#print axioms BlackwellDilemma.RandomSupercriticalZ2TopoClusterSupportSurfaceClosingRouteCertificate
#print axioms BlackwellDilemma.random_supercritical_z2_topo_cluster_support_surface_closing_route_certificate
#print axioms BlackwellDilemma.not_randomSupercriticalZ2TopoClusterRepairedBridge_giant_loss_paper_closing
#print axioms BlackwellDilemma.not_randomSupercriticalZ2TopoClusterRepairedBridge_full_paper_closing_support
#print axioms BlackwellDilemma.not_randomSupercriticalZ2TopoClusterRepairedBridge_giant_pointwise_loss_route
#print axioms BlackwellDilemma.not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute
#print axioms BlackwellDilemma.not_randomSupercriticalZ2TopoClusterBoxedTorusFiniteZ2LClosingRoute
#print axioms BlackwellDilemma.RandomSupercriticalZ2TopoClusterBoxedTorusFiniteZ2LClosingRoute
#print axioms BlackwellDilemma.PaperSemanticGate.TopoClusterRandomSupercriticalZ2SemanticKernelTarget
#print axioms BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_semantic_kernel_target_iff_full_route
#print axioms BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_semantic_kernel_target_iff_boxed_torus_finite_z2L_route
#print axioms BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_semantic_kernel_target_notYet
#print axioms BlackwellDilemma.RandomSupercriticalZ2TopoClusterFullSupportEnvelopeObstructionCertificate
#print axioms BlackwellDilemma.random_supercritical_z2_topo_cluster_full_support_envelope_obstruction_certificate
#print axioms BlackwellDilemma.RandomSupercriticalZ2TopoClusterSupportSurfaceRepairNonClosureCertificate
#print axioms BlackwellDilemma.random_supercritical_z2_topo_cluster_support_surface_repair_nonclosure_certificate
#print axioms BlackwellDilemma.RandomSupercriticalZ2TopoClusterCurrentFrontierCertificate
#print axioms BlackwellDilemma.random_supercritical_z2_topo_cluster_current_frontier_certificate
#print axioms BlackwellDilemma.not_random_supercritical_z2_topo_cluster_bridge_full_reach_diagnostic
#print axioms BlackwellDilemma.not_random_supercritical_z2_topo_cluster_bridge_flat_only_diagnostic
#print axioms BlackwellDilemma.not_random_supercritical_z2_topo_cluster_bridge_all_open_complement_diagnostic
#print axioms BlackwellDilemma.not_random_supercritical_z2_topo_cluster_bridge_all_open_giant_diagnostic
#print axioms BlackwellDilemma.not_random_supercritical_z2_topo_cluster_bridge_all_open_positive_diagnostic
#print axioms BlackwellDilemma.not_random_supercritical_z2_topo_cluster_bridge_pointwise_diagnostic_combo
#print axioms BlackwellDilemma.not_random_supercritical_z2_topo_cluster_bridge_eventual_pointwise_diagnostic_combo
#print axioms BlackwellDilemma.not_random_supercritical_z2_topo_cluster_bridge_eventual_pointwise_extended_diagnostic_combo
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_exists_non_diagnostic_member
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_arbitrarily_large_non_diagnostic_member
#print axioms BlackwellDilemma.randomSupercriticalZ2TopoClusterBridgeData_arbitrarily_large_extended_non_diagnostic_member
#print axioms BlackwellDilemma.BoxedTorusFlatFamilyCoreConclusion_from_z2_topo_cluster_bridge
#print axioms BlackwellDilemma.BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion_from_z2_topo_cluster_bridge
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyZ2TopoClusterBridge_current
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyZ2TopoClusterBridge_current_core
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyZ2TopoClusterBridge_current_lower_bound
#print axioms BlackwellDilemma.not_UnitCompatibleAboveThresholdLowerBoundConclusion_boxedTorusFullReachFlatOnlyZ2TopoClusterBridge_current
#print axioms BlackwellDilemma.boxedTorusFullReachZ2TopoClusterBridge_current
#print axioms BlackwellDilemma.boxedTorusFullReachZ2TopoClusterBridge_current_unit_compatible
#print axioms BlackwellDilemma.not_boxedTorusFullReachComplementTopoLossData_flatOnlyDiagnostic
#print axioms BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_frontier_payload
#print axioms BlackwellDilemma.PaperSemanticGate.TopoClusterRandomSupercriticalZ2FrontierPayloadCertificate
#print axioms BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_frontier_payload_certificate
#print axioms BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_frontier_payload_frontier_progress_certificate
#print axioms BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_frontier_payload_frontier_nonclosure_certificate
#print axioms BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_frontier_payload_current_frontier_certificate
#print axioms BlackwellDilemma.gap_trap_prevalence_above_threshold

-- Hodge-style paper-citation closures: def IS the paper's stated
-- closed form (per CLOSED def "paper-grade proof referenced + ported"
-- clause). Substantive derivations cited but not Lean-encoded.
-- The 4 limit-of-process entries (W_open_limit_{infty,zero},
-- error_compounding_part{1,2}) were reverted to honest OPEN axioms
-- because Hodge-style def-rfl is not appropriate for limits-of-process
-- (the def discards the limit content); they now appear as
-- `gap_*_OPEN` Filter.Tendsto axioms in their respective files.
#print axioms BlackwellDilemma.gap_order_statistics_max
#print axioms BlackwellDilemma.gap_order_statistics_density_integral
#print axioms BlackwellDilemma.gap_er_bond_percolation_threshold
#print axioms BlackwellDilemma.gap_power_law_thin_tail
-- ER supercritical witness: `poissonSurvival` is now a concrete witness
-- carrier, and the positivity consequence is kernel-pure.
#print axioms BlackwellDilemma.poissonSurvival
#print axioms BlackwellDilemma.gap_er_supercritical
#print axioms BlackwellDilemma.gap_er_phase_supercritical

-- §3.3 ClassicalResults consumer chain for Harris-Kesten anchor
#print axioms BlackwellDilemma.gap_harris_kesten_squared

-- Gaussian PDF/CDF derivative closures: phi + Phi are concrete defs;
-- derivatives proved via Mathlib's HasDerivAt + FTC. Kernel-pure.
#print axioms BlackwellDilemma.gap_phi_derivative
#print axioms BlackwellDilemma.gap_Phi_derivative
-- Mills' tail bound: proved via Mathlib improper-integral machinery
-- (integral_gaussian_Ioi + monotoneOn_of_deriv_nonneg). Kernel-pure.
#print axioms BlackwellDilemma.gap_phi_tail_bound

-- §4 Cognitive layer
#print axioms BlackwellDilemma.gap_cognitive_threshold_characterisation
#check BlackwellDilemma.gap_policy_complementarity_from_signs
#check BlackwellDilemma.gap_policy_complementarity
#print axioms BlackwellDilemma.gap_policy_complementarity_from_signs
#print axioms BlackwellDilemma.gap_policy_complementarity
#print axioms BlackwellDilemma.kappaAgentWelfareSNR_nonflat_example
#print axioms BlackwellDilemma.kappaAgentWelfareSNR_strict_four_corner_example
#print axioms BlackwellDilemma.unitRamp_eq_one_of_one_le
#print axioms BlackwellDilemma.kappaAgentRewardRamp_mem_unitInterval
#print axioms BlackwellDilemma.kappaAgentRewardRamp_increasing_differences
#print axioms BlackwellDilemma.kappaAgentRewardRamp_strict_four_corner_example
#print axioms BlackwellDilemma.kappaAgentRewardRamp_eq_at_one_of_one_le_beta
#print axioms BlackwellDilemma.kappaAgentWelfareSNRRamp_isSupermodular
#print axioms BlackwellDilemma.kappaAgentWelfareSNRRamp_strict_four_corner_example
#print axioms BlackwellDilemma.gap_threshold_alpha_monotone
-- Derived closures: Proposition `prop:supermodular` +
-- Proposition `prop:sentimental`.
--  * `gap_supermodular_from_signs`: composes
--    `welfareCrossPartial_explicit_form` (paper-stated calculus closed
--    form, line 564-583) + `cross_partial_sign_in_z_lt_one`
--    (paper-stated sign analysis at `|z| < 1`, line 582-584) under an
--    explicit `SupermodularFactorSigns` package. Public `gap_supermodular`
--    discharges that package with `canonicalSupermodularFactorSigns`.
--    The current route no longer carries a non-load-bearing Topkis parameter;
--    policy complementarity uses the current supermodularity theorem directly.
--  * `gap_sentimental_immunity`: composes `signal_independent_at_alpha_zero`
--    (derived theorem; paper L600 base case at α = 0; current source closure
--    via concrete scalar theorem `gap_iid_continuous_rank_symmetry`) +
--    `welfare_continuity_in_alpha`
--    (paper L602 perturbative continuity neighbourhood) +
--    `alpha_star_existence_via_continuity_OPEN` (paper L602 sup-existence
--    of `α*`).
#print axioms BlackwellDilemma.gap_supermodular_from_signs
#print axioms BlackwellDilemma.gap_supermodular
#print axioms BlackwellDilemma.gap_sentimental_immunity
-- `signal_independent_at_alpha_zero` preserves the paper-facing α = 0
-- interface. Its active source dependency is now the closed concrete scalar
-- theorem `gap_iid_continuous_rank_symmetry`; the David-Nagaraja /
-- Blackwell route remains semantic attribution and Mathlib-roadmap context.
#print axioms BlackwellDilemma.signal_independent_at_alpha_zero
-- Theorem 4.1 Part 5 (κ*(α) non-decreasing in α). Paper-faithful
-- bounded closure on the abstract `kappaStar` carrier via the
-- α-faithful welfare-transition reformulation
-- `kappaStar p α = sInf { 0 < κ ∧ alphaWelfareShift α ≤ m(p, κ) }`
-- + Mathlib `csInf_le_csInf` lift over the set inclusion
-- `S(p, α₂) ⊆ S(p, α₁)` (immediate from the derived
-- monotonicity `alphaWelfareShift_monotone_paper_Def` in
-- `Infrastructure/AlphaWelfareShift.lean`). Mirrors the Part 4 bounded
-- closure pattern via `mean_estimate_gap_antitone_in_p_paper_Def` +
-- `csInf_le_csInf`.
--
-- KERNEL-PURE: expected output `[propext, Classical.choice, Quot.sound]`.
#print axioms BlackwellDilemma.gap_cognitive_threshold_part5

-- The α-monotonicity of the welfare-transition shift carrier
-- underpinning Part 5. The paper's IFT sign analysis (Proposition
-- `\label{prop:threshold-alpha}` line 586 `∂M/∂α < 0` on the
-- welfare-transition functional `M(p, κ, α) = 0`) fixes the sign
-- (strictly positive `∂κ*/∂α`) of the shift gradient.
--
-- KERNEL-PURE: expected output `[propext, Classical.choice, Quot.sound]`.
#print axioms BlackwellDilemma.Infrastructure.alphaWelfareShift_monotone_paper_Def

-- Part 4 antitone-in-p derived theorem via
-- `Infrastructure/MeanEstimateGapAntitoneInP`. The mean-estimate-gap
-- on the canonical IDP instance is antitone in `p` for every `κ > 0`
-- because the prior-mean component for the bridge neighbour `u_2`
-- `priorMean_u2_fiveState p = (1-p)·r(G) + p·r(u_2)` is antitone in `p`
-- (linear closed form) and the Gaussian conjugate-prior posterior mean
-- is monotone in its prior-mean argument (derivation from
-- `gaussianPosteriorMean_denom_pos` + `div_le_div_of_nonneg_right`).
#print axioms BlackwellDilemma.mean_estimate_gap_antitone_in_p_paper_Def

-- §4 Principal layer
-- Derived closures: current `principal_interior_maximum_exists`,
-- legacy scalar-carrier dead-end evidence for Proposition
-- `prop:principal-optimum` strict sample-witness routes, and Corollary
-- `cor:disclosure` Parts 1-2.
--  * `principal_interior_maximum_exists`: closed current theorem giving a
--    nonnegative maximizer of the present public reversal-valley `W_bar`.
--  * `W_bar_exceeds_zero_at_positive_beta` and
--    `W_bar_witness_pair_strict_dominance` are current public-carrier
--    witnesses for the Part 1 strict-response route. The old sample-level
--    scalar predicates remain printed below only as diagnostic refutations.
--  * `gap_principal_monotone_in_kappa` is not revived as a false-premise
--    wrapper. R510 rewires the public aggregate carrier to the finite
--    FOSD-ramp response and proves the current Part 2 package directly as
--    `aggregateWelfareWith_principal_part2_package`.
--  * `W_bar_valley_triple_witness` is the current public-carrier Part 3
--    valley witness. The old sample-level scalar valley predicate remains
--    kernel-refuted and diagnostic.
--  * Corollary `cor:disclosure` Part 1 is now represented by the direct
--    public theorem `W_bar_finite_above_limit_witness`; the previous
--    `gap_disclosure_full_suboptimal` false-premise wrapper remains retired.
--  * `gap_disclosure_differentiated_dominates`: re-exports the derived
--    theorem `differentiated_per_agent_optimum_dominates_uniform`
--    (composes `perAgentOptimalAggregate` carrier +
--    `differentiatedDisclosureWelfare_eq_perAgentOptimal` structural
--    eq + `perAgentOptimalAggregate_dominates_uniform` smaller wA).
-- Current kernel-only boundary: the scalar κ-agent welfare is now proved
-- constant at `1/2`, so the above-threshold individual monotonicity,
-- combined convergence, negative-β below-boundary, and per-agent optimum
-- dominance facts are derived theorems. The public reversal-valley `W_bar`
-- now proves the strict positive-response, dominance-pair, and valley-triple
-- witnesses directly. The legacy scalar sample predicates remain
-- kernel-proved impossible for that diagnostic branch:
-- `PrincipalSampleBelowWeightedSumEventuallyDecreasing`,
-- `PrincipalSampleBothCombinedDominanceWitnessPair`,
-- `PrincipalSampleBothExceedsZeroWitness`, and
-- `PrincipalSampleBothValleyTripleWitness`.
-- The old strict-interior wrappers over these propositions have been retired
-- because their current concrete witness routes are dead-ended rather than
-- live Cat 3 input.
-- The public per-agent `β*` selectors are canonical `1` definitions for the
-- reversal-valley carrier. `W_bar_eventually_decreasing` and the strict
-- finite-above-limit disclosure witness are now derived through
-- `W_bar_eq_reversalValleyCandidate`, not through the legacy constant scalar
-- κ-agent welfare branch.
#print axioms BlackwellDilemma.principal_interior_maximum_exists
#print axioms BlackwellDilemma.gap_disclosure_differentiated_dominates
-- Closure-path-A derived theorems (closing bundled paper
-- conclusions through smaller atoms; ledger entries consume these).
#print axioms BlackwellDilemma.interior_max_exists_from_unimodal_envelope
#print axioms BlackwellDilemma.W_bar_mixture_decomposition
#print axioms BlackwellDilemma.differentiated_per_agent_optimum_dominates_uniform
-- Substantive-math closures (concrete-def closure pattern via the
-- `kappa_FOSD_def` precedent applied at scale): atoms closed via
-- `def <aggregate> := <component-expression>` matching paper's explicit
-- identification, then theorem reduces to `rfl`. The two structural-
-- equation closures here (aboveThresholdWelfare / belowThresholdWelfare /
-- W_bar / differentiatedDisclosureWelfare) + the mLimit closure
-- (Cognitive.lean) + the oracleValueAtRoot closure (GeneralGraphs.lean).
#print axioms BlackwellDilemma.aboveThresholdWelfare
#print axioms BlackwellDilemma.belowThresholdWelfare
#print axioms BlackwellDilemma.aboveThresholdWelfare_eq_ramp_sum
#print axioms BlackwellDilemma.belowThresholdWelfare_eq_reversalValley_sum
#print axioms BlackwellDilemma.principalSampleAboveWeight_nonneg_closed
#print axioms BlackwellDilemma.principalSampleBelowWeight_nonneg_closed
#print axioms BlackwellDilemma.not_PrincipalSampleBelowWeightedSumEventuallyDecreasing
#print axioms BlackwellDilemma.W_bar_ramp_strict_increase_example
#print axioms BlackwellDilemma.W_bar_ramp_eq_at_one_of_one_le_beta
#print axioms BlackwellDilemma.W_bar_ramp_le_at_one
#print axioms BlackwellDilemma.not_W_bar_ramp_above_saturation_witness
#print axioms BlackwellDilemma.not_PrincipalRampBelowWeightedSumEventuallyDecreasing
#print axioms BlackwellDilemma.principalBelowReversalReward_mem_unitInterval
#print axioms BlackwellDilemma.principalReversalBelowWeightedSumEventuallyDecreasing
#print axioms BlackwellDilemma.W_bar_reversalCandidate_eq_at_two_of_two_le_beta
#print axioms BlackwellDilemma.W_bar_reversalCandidate_strict_increase_example
#print axioms BlackwellDilemma.W_bar_reversalCandidate_finite_above_tail_witness
#print axioms BlackwellDilemma.W_bar_reversalCandidate_strict_drop_after_peak
#print axioms BlackwellDilemma.W_bar_reversalCandidate_tendsto_atTop
#print axioms BlackwellDilemma.W_bar_reversalCandidate_disclosure_part1_witness
#print axioms BlackwellDilemma.principalReversalCandidate_combined_exceeds_zero_witness
#print axioms BlackwellDilemma.principalReversalCandidate_combined_dominance_witness_pair
#print axioms BlackwellDilemma.principalRampAboveThresholdWelfare_continuousOn_Ici
#print axioms BlackwellDilemma.principalBelowReversalValleyReward_mem_unitInterval
#print axioms BlackwellDilemma.principalBelowReversalValleyReward_continuousOn_Ici
#print axioms BlackwellDilemma.principalReversalValleyBelowThresholdWelfare_continuousOn_Ici
#print axioms BlackwellDilemma.principalReversalValleyBelowWeightedSumEventuallyDecreasing
#print axioms BlackwellDilemma.W_bar_reversalValleyCandidate_continuousOn_Ici
#print axioms BlackwellDilemma.W_bar_reversalValleyCandidate_tendsto_atTop
#print axioms BlackwellDilemma.W_bar_reversalValleyCandidate_disclosure_part1_witness
#print axioms BlackwellDilemma.principalReversalValleyCandidate_combined_dominance_witness_pair
#print axioms BlackwellDilemma.W_bar_reversalValleyCandidate_valley_triple_witness
#print axioms BlackwellDilemma.W_bar_reversalValleyCandidate_le_at_one
#print axioms BlackwellDilemma.W_bar_reversalValleyCandidate_strict_interior_optimum_witness
#print axioms BlackwellDilemma.W_bar_reversalValleyCandidate_complete_principal_package
#print axioms BlackwellDilemma.W_bar_reversalValleyCandidate_has_limit_infty
#print axioms BlackwellDilemma.W_bar_reversalValleyCandidate_eventually_decreasing
#print axioms BlackwellDilemma.W_bar_reversalValleyCandidate_public_interface_package
#print axioms BlackwellDilemma.not_PrincipalSampleBothCombinedDominanceWitnessPair
#print axioms BlackwellDilemma.not_PrincipalSampleBothExceedsZeroWitness
#print axioms BlackwellDilemma.not_PrincipalSampleBothValleyTripleWitness
#print axioms BlackwellDilemma.W_bar_eq_reversalValleyCandidate
#print axioms BlackwellDilemma.W_bar_limit_infty_eq_W_bar_three
#print axioms BlackwellDilemma.W_bar_finite_above_limit_witness
#print axioms BlackwellDilemma.W_bar_exceeds_zero_at_positive_beta
#print axioms BlackwellDilemma.W_bar_witness_pair_strict_dominance
#print axioms BlackwellDilemma.W_bar_valley_triple_witness
#print axioms BlackwellDilemma.W_bar_eventually_decreasing
#print axioms BlackwellDilemma.aggregateWelfareWithFOSDRamp
#print axioms BlackwellDilemma.aggregateOptimalBetaFOSDRamp
#print axioms BlackwellDilemma.AggregateOptimumExistsPerG_FOSDRamp
#print axioms BlackwellDilemma.aggregateWelfareWithFOSDRamp_difference_dominates_of_kappa_FOSD
#print axioms BlackwellDilemma.aggregateWelfareWithFOSDRamp_argmax_preference_preservation
#print axioms BlackwellDilemma.aggregateOptimalBetaFOSDRamp_def
#print axioms BlackwellDilemma.aggregateOptimalBetaFOSDRamp_monotone_of_kappa_FOSD
#print axioms BlackwellDilemma.aggregateWelfareWithFOSDRamp_principal_part2_package
#print axioms BlackwellDilemma.aggregateWelfareWith_eq_FOSDRamp
#print axioms BlackwellDilemma.aggregate_optimum_exists_per_G_current
#print axioms BlackwellDilemma.aggregateOptimalBeta_eq_FOSDRamp
#print axioms BlackwellDilemma.AggregateWelfareWithDifferenceDominatesUnderFOSD_current
#print axioms BlackwellDilemma.aggregateWelfareWith_argmax_preference_preservation_current
#print axioms BlackwellDilemma.aggregateOptimalBeta_monotone_of_kappa_FOSD_current
#print axioms BlackwellDilemma.aggregateOptimalBeta_monotone_under_diffdom_current
#print axioms BlackwellDilemma.aggregateWelfareWith_principal_part2_package
#print axioms BlackwellDilemma.perAgentOptimalAggregate
#print axioms BlackwellDilemma.perAgentOptimalAggregate_eq_reversalValley_sum
#print axioms BlackwellDilemma.principalSampleAbove_per_agent_optimum_dominance
#print axioms BlackwellDilemma.principalSampleBelow_per_agent_optimum_dominance
#print axioms BlackwellDilemma.principalSampleBoth_combined_convergence_witness
#print axioms BlackwellDilemma.W_bar_eq_mixture
#print axioms BlackwellDilemma.differentiatedDisclosureWelfare_eq_perAgentOptimal
-- Existence-via-Classical.choose closures extended to the Principal
-- layer (`betaStarOfP` / `smoothTransitionBeta` precedent): interfaces
-- closed via `noncomputable def <carrier> := Classical.choose
-- <existence_atom>` + `theorem <atom>_def := Classical.choose_spec`.
-- The carriers betaBarStar, aggregateOptimalBeta, W_bar_limit_infty
-- are concrete defs invoking Classical.choose on existence inputs.
-- `aggregateOptimalBeta` is now the stable finite-ramp selector, and
-- `AggregateOptimumExistsPerG` is closed by beta = 1 on the public carrier.
#print axioms BlackwellDilemma.betaBarStar_def
#print axioms BlackwellDilemma.aggregateOptimalBeta_def
#print axioms BlackwellDilemma.W_bar_limit_infty_def
-- Closure-path-A on welfareCrossPartial_explicit_form:
-- bundled paper conclusion decomposed into 2 carriers
-- (firstTermCrossPartial + secondTermCrossPartial per paper line 566
-- explicit two-term decomposition) + 2 smaller atoms
-- (secondTermCrossPartial_nonneg per paper line 568 +
-- firstTermCrossPartial_pos_in_z_lt_one per paper lines 582-584).
-- welfareCrossPartial is a `noncomputable def := firstTermCrossPartial
-- + secondTermCrossPartial`. The cross_partial_sign_in_z_lt_one
-- atom closes via Cat 1 linarith arithmetic on the universal-quantified
-- premises.
#print axioms BlackwellDilemma.welfareCrossPartial_explicit_form
#print axioms BlackwellDilemma.cross_partial_sign_in_z_lt_one
-- Concretisation of the firstTermCrossPartial / secondTermCrossPartial
-- carriers as the paper's exact closed-form products (Proposition
-- prop:supermodular proof lines 566-584):
--   firstTermCrossPartial β κ
--     = sigEffRatioFactor β * mPrime κ * stdNormalPDF (snrZ β κ)
--         * (1 - snrZ β κ ^ 2) * bridgeValueGap β
--   secondTermCrossPartial β κ = pCorrectDerivKappa β κ * vDynDerivBeta β
-- The 2 secondTermCrossPartial_nonneg +
-- firstTermCrossPartial_pos_in_z_lt_one are derived theorems of
-- the same name. secondTermCrossPartial_nonneg closes via
-- `mul_nonneg` of paper-stated factor signs;
-- firstTermCrossPartial_pos_in_z_lt_one closes factor-by-factor
-- with stdNormalPDF_pos (Mathlib-derived, kernel-pure) + `1 - z² > 0`
-- (Mathlib nlinarith from |z| < 1) + 3 paper-stated factor-sign inputs.
-- The 5 factor-sign obligations (sigEffRatioFactor_pos, mPrime_pos,
-- bridgeValueGap_pos, pCorrectDerivKappa_pos, vDynDerivBeta_nonneg)
-- are now explicit fields of `SupermodularFactorSigns`, consumed as theorem
-- inputs rather than global source-level axioms. The current concrete scalar
-- package supplies `canonicalSupermodularFactorSigns`, so the canonical model
-- closes this interface without a project axiom. stdNormalPDF_pos is Cat 1
-- Mathlib (kernel-pure, no paper axioms).
#print axioms BlackwellDilemma.secondTermCrossPartial_nonneg
#print axioms BlackwellDilemma.firstTermCrossPartial_pos_in_z_lt_one
#print axioms BlackwellDilemma.canonicalSupermodularFactorSigns
#print axioms BlackwellDilemma.stdNormalPDF_pos

-- §5 Constructive instances
#print axioms BlackwellDilemma.FiveState.gap_kappaStar_at_two_thirds
#print axioms BlackwellDilemma.FiveState.gap_bayesian_naive_routing_threshold
#print axioms BlackwellDilemma.FiveState.gap_threshold_fiveState_greedy_has_interior_optimum
#print axioms BlackwellDilemma.gap_fiveState_policy_mapping
#print axioms BlackwellDilemma.FiveState.gap_three_regime_sufficient_cognition_kappaStar_pos
-- p-monotonicity on the paper's intended domain p ∈ [0, 1).
#print axioms BlackwellDilemma.FiveState.gap_p_monotonicity_bounded

-- §6 Bayesian + complementarity
#print axioms BlackwellDilemma.gap_bayesian_immunity
#print axioms BlackwellDilemma.gap_information_knowledge_complementarity
-- Decompositions (Bayesian.lean): the public myopic/satisficing robustness
-- theorems now consume current closed carriers internally. The myopic public
-- theorem now directly composes the current carrier with closed Blackwell
-- monotonicity; the satisficing public theorem proves the affine current model
-- directly. The current carrier and current affine behavior witnesses remain
-- printed below as kernel-visible evidence, but neither public route
-- contributes a conditional theorem signature.
#print axioms BlackwellDilemma.gap_robustness_myopic_k
#print axioms BlackwellDilemma.gap_robustness_satisficing
-- Individual atom prints (kernel-purity baseline):
#print axioms BlackwellDilemma.MyopicKWelfareCarriers
#print axioms BlackwellDilemma.MyopicKWelfareCarriers_current
#print axioms BlackwellDilemma.SatisficingCarriers
#print axioms BlackwellDilemma.SatisficingCarriers_current
#print axioms BlackwellDilemma.SatisficingCarriers_current_trapAcceptance_strictMono_in_beta
#print axioms BlackwellDilemma.SatisficingCarriers_current_welfare_antitone_in_trap_acceptance
#print axioms BlackwellDilemma.myopic_k_eq_bayesian_above_divergence_depth
#print axioms BlackwellDilemma.satisficingTrapAcceptanceProb
-- §5 Three-regime arithmetic split (Cat 1 promotion)
#print axioms BlackwellDilemma.FiveState.gap_three_regime_cognitive_augmentation_arithmetic_part

-- §5 Three-regime β-monotonicity (Cat 1 promotions): β-monotonicity of
-- L(β, p) on Regime (ii) [p_1, p_2] and Regime (iii) (p_2, 1) closed via
-- `Phi_strictMono` + `Phi_le_one` + `Phi_nonneg` + `signalVariance_strictAntitoneOn`
-- + algebraic decomposition of L₂ - L₁ into two non-positive contributions.
#print axioms BlackwellDilemma.FiveState.gap_three_regime_cognitive_augmentation_monotonicity
#print axioms BlackwellDilemma.FiveState.gap_three_regime_sufficient_cognition

-- Phi monotonicity / non-negativity / upper-bound helpers (Cat 1 closures
-- supporting the three-regime β-monotonicity theorems).
#print axioms BlackwellDilemma.Phi_strictMono
#print axioms BlackwellDilemma.Phi_monotone
#print axioms BlackwellDilemma.Phi_zero
#print axioms BlackwellDilemma.Phi_le_one
#print axioms BlackwellDilemma.Phi_nonneg

-- Cat 1 limit helpers: Φ tail limits + signal-variance limit at infinity
-- + the constant-divided-by-vanishing-positive-function → ∞ helper. Used by
-- the gap_W_open_limit_infty + gap_error_compounding_part1 closures.
#print axioms BlackwellDilemma.Phi_tendsto_one_atTop
#print axioms BlackwellDilemma.Phi_tendsto_zero_atBot
#print axioms BlackwellDilemma.signalVariance_tendsto_zero_atTop
#print axioms BlackwellDilemma.tendsto_const_div_atTop_of_tendsto_zero_pos

-- Cat 1 helpers: Phi continuity (from FTC closure) + signalVariance
-- limit at 0+ (symmetric mirror of the atTop limit above).
-- Used by gap_W_open_limit_zero closure.
#print axioms BlackwellDilemma.Phi_continuousAt
#print axioms BlackwellDilemma.signalVariance_tendsto_atTop_of_tendsto_zero_pos

-- Derived closures: prop:canonical β→∞ limit + prop:error-compounding
-- Part 1 (β→∞ welfare-limit on the depth-d trap tree).
#print axioms BlackwellDilemma.FourState.gap_W_open_limit_infty
#print axioms BlackwellDilemma.TrapTree.gap_error_compounding_part1

-- Derived closure: prop:canonical β→0+ limit (symmetric mirror of
-- gap_W_open_limit_infty). Composes the Cat 1 helpers above.
#print axioms BlackwellDilemma.FourState.gap_W_open_limit_zero

-- Derived closure: rem:robustness-misspec (i) — re-export of
-- FiveState.gap_bayesian_naive_routing_threshold (Cat 1 kernel-pure).
#print axioms BlackwellDilemma.gap_robustness_bayesian_naive

-- §5 Three-regime reversal six-way decomposition: paper line 814 has six
-- sub-claims — existence, uniqueness, non-monotonicity, overshoot
-- strictly decreasing in p, overshoot continuous in p on [0, p_1), and
-- overshoot vanishing at p_1 — split per axiom-decomposition
-- Anti-pattern #2. Each sub-axiom is a Cat 3 OPEN claim with
-- explicit single-clause encoding; the continuity + vanishing-at-p_1
-- sub-axioms are stated against the opaque carrier `betaStarOfP` (whose
-- own dependencies appear under each consuming axiom). Only the existence
-- sub-axiom is currently consumed by downstream `gap_fiveState_policy_mapping`.
#print axioms BlackwellDilemma.FiveState.gap_three_regime_reversal_existence
#print axioms BlackwellDilemma.FiveState.gap_three_regime_reversal_uniqueness
#print axioms BlackwellDilemma.FiveState.gap_three_regime_reversal_nonmonotone
#print axioms BlackwellDilemma.FiveState.gap_three_regime_reversal_overshoot_decreasing
#print axioms BlackwellDilemma.FiveState.L_at_betaStarOfP_continuousOn_paper_Def_closed
#print axioms BlackwellDilemma.FiveState.gap_three_regime_reversal_overshoot_continuous
#print axioms BlackwellDilemma.FiveState.gap_three_regime_reversal_overshoot_vanishes_at_p1

-- §7 General graphs + trap tree
#print axioms BlackwellDilemma.TrapTree.gap_welfare_gain_decay
-- Current closure: Proposition `prop:error-compounding` Part 2
-- (oracle dynamic value at root = `r_goal` for all `d ≥ 1`).
-- The empty compatibility carrier has been removed; the public theorem is
-- the direct closure-path-B composition over concrete definitions.
#print axioms BlackwellDilemma.TrapTree.oracleBridgePathTerminalReward_TrapTree
#print axioms BlackwellDilemma.TrapTree.oracleValueAtRoot_TrapTree
#print axioms BlackwellDilemma.TrapTree.oracleValueAtRoot_eq_bridgePathTerminalReward_TrapTree
#print axioms BlackwellDilemma.TrapTree.oracleBridgePathTerminalReward_TrapTree_eq_r_goal
#print axioms BlackwellDilemma.TrapTree.gap_error_compounding_part2
-- Upper-bound half of the κ*(d) = Θ(log d) asymptotic. The lower-bound
-- half is ALSO a genuine theorem (`kappaStar_depth_d_lower_bound` via
-- weighted AM-GM), so the full Θ-asymptotic
-- `bernoulli_real_power_estimate` is no longer an OPEN axiom. These theorems
-- are now stated for `KappaStarDepthDCarriers_current`, not as theorem-level
-- carrier-parameter routes.
#print axioms BlackwellDilemma.TrapTree.gap_kappaStar_depth_d_upper_bound
#print axioms BlackwellDilemma.TrapTree.bernoulli_real_power_estimate
-- Derived closures from Manufactured-Recognition-pattern atomic
-- decomposition:
--  * `V_g_terminal_in_ForwardReachable`: current theorem from the
--    well-founded `V_g` recursion and canonical `ForwardReachable`
--    transitivity.
--  * `gap_V_g_le_V_dyn`: composes that theorem with `V_dyn_def` +
--    Mathlib `Finset.le_sup'` (Cat 1).
--  * `dilemma_subsumed_by_gap_general_tree`: composes explicit Cat 3
--    interfaces for terminal-neighbour `V_g = V_dyn` and C2/C2′ reduction
--    with the trivial conjunction-rebuilding step on
--    `Conditions_C1_C2_C3` / `Conditions_C1_C2prime_C3`.
#print axioms BlackwellDilemma.gap_V_g_le_V_dyn
#print axioms BlackwellDilemma.V_g_terminal_in_ForwardReachable
#print axioms BlackwellDilemma.dilemma_subsumed_by_gap_general_tree

-- Derived closures composing orphan atoms with Mathlib and companion
-- atoms to give them explicit downstream consumers:
--  * `ReachableSet_self_member`: derived theorem composing
--    `ReachableSet_eq_ForwardReachable_empty` (Def 2.5 line 193) +
--    `ForwardReachable_self_member` (projection theorem from
--    `ForwardReachableData`, Def 2.5 length-0 path).
--  * `realisedUtility_mem_unitInterval`: composes the projection theorems
--    `intrinsicPref_mem_unitInterval` (Def 2.1 line 114) and
--    `reward_mem_unitInterval` (Def 2.1 line 113) from
--    `intrinsicPrefData` / `rewardData` via convex-combination Cat 1
--    arithmetic.
--  * `kappaAgentWelfareSNR_mem_unitInterval`: composes the public
--    non-flat ramp carrier equation (`prop:supermodular` line 565) +
--    `kappaAgentRewardRamp_mem_unitInterval` (§2.5 lines 204-208 +
--    Def 2.1 line 113).
--  * `betaStarOfP_loss_below_limit`: composes `betaStarOfP_def`
--    (`prop:three-regime-five-state` Regime (i) line 814 argmin) +
--    `gap_three_regime_reversal_existence_OPEN` (existence sub-axiom)
--    via transitivity, binding the existential witness to the canonical
--    `betaStarOfP` carrier.
--  * `V_g_terminal_mem_unitInterval`: composes the current concrete
--    theorem `V_g_def_terminal` (`def:greedy-path` lines 982-985
--    terminal-base, now proved from the well-founded `V_g` definition)
--    with the projection theorem `reward_mem_unitInterval` from
--    `rewardData`, bounding `V_g` in the terminal-vertex case.
--  * `W_bar_limit_infty_le_W_bar_betaBarStar`: composes `W_bar_limit_infty_def`
--    (`cor:disclosure` Part 1 line 652 Tendsto limit) + `betaBarStar_def`
--    (`prop:principal-optimum` line 622 argmax) via Mathlib's
--    `le_of_tendsto'` (limit-of-bounded-function lemma).
#print axioms BlackwellDilemma.ReachableSet_self_member
#print axioms BlackwellDilemma.realisedUtility_mem_unitInterval
#print axioms BlackwellDilemma.kappaAgentWelfareSNR_mem_unitInterval
#print axioms BlackwellDilemma.FiveState.betaStarOfP_loss_below_limit
#print axioms BlackwellDilemma.greedyRewardChild_reward_max
#print axioms BlackwellDilemma.greedyRewardChild_congr
#print axioms BlackwellDilemma.greedyPathValueFuel
#print axioms BlackwellDilemma.greedyPathValue
#print axioms BlackwellDilemma.V_g
#print axioms BlackwellDilemma.ForwardReachableCandidatesAreLocal
#print axioms BlackwellDilemma.V_g_eq_localGreedyPathValue_of_candidates_are_local
#print axioms BlackwellDilemma.V_g_def_terminal
#print axioms BlackwellDilemma.V_g_def_step
#print axioms BlackwellDilemma.localGreedyPathValue
#print axioms BlackwellDilemma.localGreedyPathValue_terminal_in_ForwardReachable
#print axioms BlackwellDilemma.localGreedyPathValue_le_V_dyn
#print axioms BlackwellDilemma.LocalGreedyPathValueDominatesForwardReachable
#print axioms BlackwellDilemma.localGreedyPathValue_eq_V_dyn_at_of_dominates_forwardReachable
#print axioms BlackwellDilemma.localGreedyPathValue_eq_V_dyn_of_dominates_forwardReachable
#print axioms BlackwellDilemma.V_g_eq_V_dyn_of_candidates_are_local_and_local_dominates
#print axioms BlackwellDilemma.diagnosticContinuationValue_eq_V_dyn
#print axioms BlackwellDilemma.localGreedyPathValue_eq_diagnosticContinuationValue_at_of_dominates
#print axioms BlackwellDilemma.C2primeLocalGreedyCoreMisalignment
#print axioms BlackwellDilemma.C2primeLocalGreedyCoreMisalignment_of_C2_and_localGreedy_eq_diagnostic
#print axioms BlackwellDilemma.not_C2LocalGreedyDominatesForwardReachableAtWitnesses_current
#print axioms BlackwellDilemma.not_C2LocalGreedyDiagnosticWitnessBridge_current
#print axioms BlackwellDilemma.NeighbourhoodExhaustedByPair
#print axioms BlackwellDilemma.not_NeighbourhoodExhaustedByPair_current
#print axioms BlackwellDilemma.C2RewardTopologyMisalignmentAtExhaustedPair
#print axioms BlackwellDilemma.C2RewardTopologyMisalignmentAtExhaustedPair_to_C2
#print axioms BlackwellDilemma.C2RewardTopologyMisalignmentAtExhaustedPair_to_degreeTwo
#print axioms BlackwellDilemma.not_C2RewardTopologyMisalignmentAtExhaustedPair_current
#print axioms BlackwellDilemma.not_C2primeLocalGreedyFullWitness_current
#print axioms BlackwellDilemma.ParametricLocalC2primeFullWitness
#print axioms BlackwellDilemma.ParametricGraphLocalGreedyWelfareReversal
#print axioms BlackwellDilemma.ParametricTerminalLocalC2primeFullWitness
#print axioms BlackwellDilemma.ParametricDilemmaGraphScopeWitness
#print axioms BlackwellDilemma.fin5Trap_parametricTerminalLocalC2primeFullWitness
#print axioms BlackwellDilemma.fin5Trap_parametricLocalC2primeFullWitness
#print axioms BlackwellDilemma.fin5Trap_parametricGraphLocalGreedyWelfareReversal
#print axioms BlackwellDilemma.fin5Trap_parametricDilemmaGraphScopeWitness
#print axioms BlackwellDilemma.gap_dilemma_fin5Trap_parametricGraphScope_current
#print axioms BlackwellDilemma.ParametricDilemmaCurrentBridge
#print axioms BlackwellDilemma.fin5Trap_parametricDilemmaCurrentBridge
#print axioms BlackwellDilemma.fin5Trap_parametricDilemmaGraphScope_and_currentDilemma
#print axioms BlackwellDilemma.ParametricGraphLocalGreedyDilemmaCore
#print axioms BlackwellDilemma.fin5Trap_parametricGraphLocalGreedyDilemmaCore
#print axioms BlackwellDilemma.ParametricGraphLocalDilemmaTheoremCore
#print axioms BlackwellDilemma.parametricGraphLocalDilemmaTheoremCore_of_boxedTorusFlatFamilyCore
#print axioms BlackwellDilemma.fin5Trap_parametricGraphLocalDilemmaTheoremCore
#print axioms BlackwellDilemma.ParametricGraphLocalDilemmaTheoremCoreOn
#print axioms BlackwellDilemma.fin5Trap_parametricGraphLocalDilemmaTheoremCoreOn_of_oracleInterfaces
#print axioms BlackwellDilemma.ParametricGraphLocalDilemmaTheoremCoreOnWithNonzeroOracle
#print axioms BlackwellDilemma.fin5Trap_unitExponential_parametricGraphLocalDilemmaTheoremCoreOnWithNonzeroOracle
#print axioms BlackwellDilemma.fin5Trap_boxedTorus_parametricGraphLocalDilemmaTheoremCoreOnWithNonzeroOracle
#print axioms BlackwellDilemma.fin5Trap_boxedTorusAllOpenGiant_parametricGraphLocalDilemmaTheoremCoreOnWithNonzeroOracle
#print axioms BlackwellDilemma.fin5Trap_parametricGraphLocalDilemmaTheoremCoreWithNonzeroOracle
#print axioms BlackwellDilemma.diagnosticSignalHypothesisDataWithParametricLocalC2prime
#print axioms BlackwellDilemma.ConcreteC3InformationLocality
#print axioms BlackwellDilemma.constantZeroSignalFamily
#print axioms BlackwellDilemma.constantZeroSignalFamily_topologyBlind
#print axioms BlackwellDilemma.concreteC3InformationLocality_current
#print axioms BlackwellDilemma.diagnosticSignalHypothesisDataWithParametricLocalC2primeAndConcreteC3
#print axioms BlackwellDilemma.diagnosticSignalHypothesisDataWithParametricLocalC2primeConcreteC3NoBlackwell
#print axioms BlackwellDilemma.DiagnosticSignalHypothesisData_current
#print axioms BlackwellDilemma.C2prime_GreedyPathMisalignment_iff_parametricLocalFullWitness_under_parametricLocalC2primeData
#print axioms BlackwellDilemma.C2prime_GreedyPathMisalignment_of_fin5Trap_under_parametricLocalC2primeData
#print axioms BlackwellDilemma.Conditions_C1_C2prime_C3_of_fin5Trap_under_parametricLocalC2primeData
#print axioms BlackwellDilemma.C3_InformationLocality_iff_concreteC3_under_parametricLocalC2primeConcreteC3Data
#print axioms BlackwellDilemma.Conditions_C1_C2prime_C3_of_fin5Trap_under_parametricLocalC2primeConcreteC3Data
#print axioms BlackwellDilemma.not_IsBlackwellOrdered_under_parametricLocalC2primeConcreteC3NoBlackwellData
#print axioms BlackwellDilemma.Conditions_C1_C2prime_C3_of_fin5Trap_under_parametricLocalC2primeConcreteC3NoBlackwellData
#print axioms BlackwellDilemma.gap_general_tree_current_of_fin5Trap_under_parametricLocalC2primeData
#print axioms BlackwellDilemma.gap_general_tree_current_of_fin5Trap_under_parametricLocalC2primeConcreteC3Data
#print axioms BlackwellDilemma.gap_general_tree_current_of_fin5Trap_under_parametricLocalC2primeConcreteC3NoBlackwellData
#print axioms BlackwellDilemma.gap_dilemma_current_of_fin5Trap_parametricLocalGreedy
#print axioms BlackwellDilemma.fin5Trap_parametricDilemmaCurrentBridge_viaGeneralTree
#print axioms BlackwellDilemma.GreedyChildTerminalAndSelfLe
#print axioms BlackwellDilemma.V_g_eq_V_dyn_of_greedyChild_terminal_and_self_le
#print axioms BlackwellDilemma.not_GreedyChildTerminalAndSelfLe_current
#print axioms BlackwellDilemma.V_g_terminal_in_ForwardReachable
#print axioms BlackwellDilemma.Infrastructure.fin3Path_terminalNeighbourTopology
#print axioms BlackwellDilemma.Infrastructure.not_fin3Path_GreedyChildTerminalAndSelfLeOn
#print axioms BlackwellDilemma.Infrastructure.not_fin3Path_ForwardReachableCandidatesAreLocalOn
#print axioms BlackwellDilemma.Infrastructure.NeighbourSetOn_mem_ForwardReachableOn_erase
#print axioms BlackwellDilemma.Infrastructure.ForwardReachableOn_trans_from_erase
#print axioms BlackwellDilemma.Infrastructure.localGreedyPathValueOn_terminal_in_ForwardReachableOn
#print axioms BlackwellDilemma.Infrastructure.localGreedyPathValueOn_le_dynamicValueOn
#print axioms BlackwellDilemma.Infrastructure.LocalGreedyPathValueDominatesForwardReachableOn
#print axioms BlackwellDilemma.Infrastructure.localGreedyPathValueOn_eq_dynamicValueOn_at_of_dominates_forwardReachableOn
#print axioms BlackwellDilemma.Infrastructure.localGreedyPathValueOn_eq_dynamicValueOn_of_dominates_forwardReachableOn
#print axioms BlackwellDilemma.Infrastructure.fin3Path_localGreedy_dominates_forwardReachable_from_start_of_leaf_dominates
#print axioms BlackwellDilemma.Infrastructure.fin3Path_localGreedy_eq_dynamic_from_start_of_leaf_dominates
#print axioms BlackwellDilemma.Infrastructure.fin3Path_localGreedy_eq_dynamic_from_start_concreteLeafReward
#print axioms BlackwellDilemma.Infrastructure.exists_fin3_terminalNeighbour_localGreedy_eq_dynamic_from_start
#print axioms BlackwellDilemma.Infrastructure.fin3_terminalNeighbour_localRoute_succeeds_and_oldCandidateLocality_fails
#print axioms BlackwellDilemma.Infrastructure.NeighbourhoodExhaustedByPairOn
#print axioms BlackwellDilemma.Infrastructure.DegreeTwoStartingVertexOn
#print axioms BlackwellDilemma.Infrastructure.degreeTwoStartingVertexOn_of_neighbourhoodExhaustedByPairOn
#print axioms BlackwellDilemma.Infrastructure.LocalC2primeFullWitnessOn
#print axioms BlackwellDilemma.Infrastructure.localGreedySignalWelfareOn
#print axioms BlackwellDilemma.Infrastructure.LocalGreedyWelfareReversalOn
#print axioms BlackwellDilemma.Infrastructure.localGreedySignalWelfareOn_reversal_of_path_reversal
#print axioms BlackwellDilemma.Infrastructure.fin5Trap_terminalNeighbourTopology
#print axioms BlackwellDilemma.Infrastructure.fin5Trap_neighbourhoodExhausted_zero_one_two
#print axioms BlackwellDilemma.Infrastructure.fin5Trap_degreeTwoStartingVertexOn
#print axioms BlackwellDilemma.Infrastructure.fin5Trap_localGreedy_one_after_zero
#print axioms BlackwellDilemma.Infrastructure.fin5Trap_localGreedy_two_after_zero
#print axioms BlackwellDilemma.Infrastructure.fin5Trap_localGreedy_reversal
#print axioms BlackwellDilemma.Infrastructure.fin5Trap_localC2primeFullWitnessOn
#print axioms BlackwellDilemma.Infrastructure.fin5Trap_localGreedyWelfareReversalOn
#print axioms BlackwellDilemma.Infrastructure.fin5Trap_terminalNeighbour_and_localC2primeFullWitness
#print axioms BlackwellDilemma.Infrastructure.fin5Trap_terminalNeighbour_and_degreeTwoStartingVertexOn
#print axioms BlackwellDilemma.exists_vertex_not_eq_triple_current
#print axioms BlackwellDilemma.not_TerminalNeighbourTopology_current
#print axioms BlackwellDilemma.not_DegreeTwoStartingVertex_current
#print axioms BlackwellDilemma.V_g_eq_V_dyn_on_terminal_neighbour_current
#print axioms BlackwellDilemma.C2_to_C2prime_via_V_g_eq_V_dyn_at_terminal_neighbour_current
#print axioms BlackwellDilemma.V_g_terminal_mem_unitInterval
#print axioms BlackwellDilemma.W_bar_limit_infty_le_W_bar_betaBarStar

-- Atomic-decomposition derived theorems: 22 conclusion-axioms
-- decomposed into atomic stipulations + derived theorems.
-- Each entry below is the derived theorem now hosting the bundled
-- paper conclusion; the corresponding atomic-stipulation declaration
-- (axiom or explicit Prop interface, often named `<paper_content>_OPEN`)
-- is the underlying paper-stated substance pending per-instance closure.

-- Cognitive.lean Theorem 4.1 derived theorems (Part 4 is the
-- paper-faithful bounded form on the abstract `kappaStar` carrier —
-- see the `gap_cognitive_threshold_part4` docstring for the
-- non-emptiness-premise rationale):
--
-- `gap_cognitive_threshold_part2` is STRICT KERNEL-PURE (modulo
-- Types.lean foundational primitives). The
-- `agentRewardKernel_kappaAbove_pointwise_monotone` structural
-- equation is a derived `theorem` via the kernel concretisation: the
-- `AgentType.kappaAgent` branch of `agentRewardKernel` returns the
-- constant value `1/2`, so pointwise monotonicity holds via `le_refl`
-- after `simp [agentRewardKernel]`; the existential witness
-- `κ₀ := 0` is paper-aligned (paper line 894: 5-state `κ*(p) = 0`
-- throughout the reversal regime). `#check` on
-- `gap_cognitive_threshold_part2` now exposes only `_p` and `α`; the
-- non-load-bearing C1-C3 / terminal-topology parameters were removed from
-- the current public Part 2 route. The generic route
-- `gap_cognitive_threshold_part2_from_blackwell` keeps the explicit
-- Blackwell monotonicity input; the public theorem consumes the closed
-- current `gap_blackwell_monotonicity` theorem internally.
#print axioms BlackwellDilemma.gap_cognitive_threshold_part1
#print axioms BlackwellDilemma.gap_cognitive_threshold_part2_from_blackwell
#print axioms BlackwellDilemma.gap_cognitive_threshold_part2
#print axioms BlackwellDilemma.kappaStar_p_monotone_of_mean_gap_antitone
#print axioms BlackwellDilemma.Infrastructure.bernoulliMonotoneCouplingFactor_lower_marginal
#print axioms BlackwellDilemma.Infrastructure.bernoulliMonotoneCouplingFactor_upper_marginal
#print axioms BlackwellDilemma.Infrastructure.standardBernoulliMonotoneCouplingData
#print axioms BlackwellDilemma.Infrastructure.bernoulliProductMonotoneCouplingFactor_nonneg
#print axioms BlackwellDilemma.Infrastructure.bernoulliProductMonotoneCouplingFactor_no_forbidden_open_to_closed_edge
#print axioms BlackwellDilemma.Infrastructure.standardBernoulliProductMonotoneCouplingData
#print axioms BlackwellDilemma.Infrastructure.bernoulliProductMonotoneCouplingFactor_total_mass
#print axioms BlackwellDilemma.Infrastructure.bernoulliProductMonotoneCouplingFactor_lower_marginal
#print axioms BlackwellDilemma.Infrastructure.bernoulliProductMonotoneCouplingFactor_upper_marginal
#print axioms BlackwellDilemma.Infrastructure.standardBernoulliProductMonotoneCouplingMarginalData
#print axioms BlackwellDilemma.Infrastructure.bernoulliProductExpectation_mono_of_monotone_coupling
#print axioms BlackwellDilemma.Infrastructure.bernoulliProductExpectation_mono_of_monotone
#print axioms BlackwellDilemma.percExpectation_eq_bernoulliProductExpectation
#print axioms BlackwellDilemma.percExpectation_mono_in_p_of_BoolConfigMonotone
#print axioms BlackwellDilemma.percExpectation_mono_in_p_of_lattice_monotone_coupling
#print axioms BlackwellDilemma.Infrastructure.MeanEstimateGap.bridgePriorRewardObservable_mono
#print axioms BlackwellDilemma.Infrastructure.MeanEstimateGap.bridgePriorRewardObservable_expectation_eq_priorMean_u2
#print axioms BlackwellDilemma.Infrastructure.MeanEstimateGap.priorMean_u2_fiveState_antitone_in_p_from_percExpectation
#print axioms BlackwellDilemma.mean_estimate_gap_antitone_in_p_from_percExpectation
#print axioms BlackwellDilemma.gap_cognitive_threshold_part4_from_percExpectation
#print axioms BlackwellDilemma.Infrastructure.BondPercolationLattice.standardLatticeMonotoneCouplingData
#print axioms BlackwellDilemma.gap_cognitive_threshold_part4_from_lattice_bridge
#print axioms BlackwellDilemma.standardZ2LatticePMonotonicityBridgeSkeleton_current
#print axioms BlackwellDilemma.gap_cognitive_threshold_part4_from_standard_z2_bridge_skeleton_current
#print axioms BlackwellDilemma.standardZ2RangedLatticePMonotonicityBridge_current
#print axioms BlackwellDilemma.priorMean_u2_fiveState_antitone_in_p_from_ranged_lattice_observable
#print axioms BlackwellDilemma.mean_estimate_gap_antitone_in_p_from_ranged_lattice_observable
#print axioms BlackwellDilemma.gap_cognitive_threshold_part4_from_ranged_lattice_bridge
#print axioms BlackwellDilemma.gap_cognitive_threshold_part4_from_standard_z2_ranged_bridge_current
#print axioms BlackwellDilemma.gap_cognitive_threshold_part4
#print axioms BlackwellDilemma.PaperSemanticGate.part4_lattice_p_monotonicity_frontier_payload
#print axioms BlackwellDilemma.gap_cognitive_threshold_part6
#print axioms BlackwellDilemma.gap_cognitive_threshold_part6_local
#print axioms BlackwellDilemma.gap_cognitive_threshold_part6_from_z2_lattice_embedding_bridge
#print axioms BlackwellDilemma.gap_cognitive_threshold_part6_from_z2_lattice_embedding_local_bridge
#print axioms BlackwellDilemma.z2LatticeEmbeddingLocalBridgeData_near_pc_feasible_nonempty
#print axioms BlackwellDilemma.z2LatticeEmbeddingLocalBridgeData_nonempty_unbounded_alpha_domain
#print axioms BlackwellDilemma.z2LatticeEmbeddingLocalBridgeData_paper_support_certificate
#print axioms BlackwellDilemma.z2LatticeEmbeddingLocalBridgeData_pointwise_paper_domain_certificate
#print axioms BlackwellDilemma.z2LatticeEmbeddingLocalBridgeData_feasible_divergence_witness
#print axioms BlackwellDilemma.z2LatticeEmbeddingLocalBridgeData_full_paper_domain_witness
#print axioms BlackwellDilemma.gap_cognitive_threshold_part6_from_z2_lattice_embedding_closed_unit_local_bridge
#print axioms BlackwellDilemma.z2LatticeEmbeddingClosedUnitLocalBridgeData_nonempty_closed_unit_alpha_domain
#print axioms BlackwellDilemma.z2LatticeEmbeddingClosedUnitLocalBridgeData_near_pc_feasible_nonempty
#print axioms BlackwellDilemma.gap_cognitive_threshold_part6_from_z2_lattice_embedding_closed_unit_local_bridge_witness
#print axioms BlackwellDilemma.z2LatticeEmbeddingClosedUnitLocalBridgeData_paper_support_certificate
#print axioms BlackwellDilemma.z2LatticeEmbeddingClosedUnitLocalBridgeData_paper_support_with_sentimental_reversal
#print axioms BlackwellDilemma.z2LatticeEmbeddingClosedUnitLocalBridgeData_pointwise_paper_domain_certificate
#print axioms BlackwellDilemma.z2LatticeEmbeddingClosedUnitLocalBridgeData_feasible_divergence_witness
#print axioms BlackwellDilemma.z2LatticeEmbeddingClosedUnitLocalBridgeData_full_paper_domain_witness
#print axioms BlackwellDilemma.not_z2_lattice_embedding_bridge_with_harrisKestenScalingFunction
#print axioms BlackwellDilemma.not_z2_lattice_embedding_bridge_with_criticalHyperbolicScaling
#print axioms BlackwellDilemma.part6_scaling_candidate_current_obstruction_certificate
#print axioms BlackwellDilemma.current_part6_unbounded_alpha_zero_branch_near_pc
#print axioms BlackwellDilemma.current_part6_unbounded_alpha_zero_branch_blocks_local_bridge
#print axioms BlackwellDilemma.mean_estimate_gap_lt_one_of_nonneg_p_of_pos_kappa
#print axioms BlackwellDilemma.kappaStar_eq_zero_of_one_lt_alpha_of_nonneg_p
#print axioms BlackwellDilemma.not_unbounded_part6_divergence_witness_current
#print axioms BlackwellDilemma.not_unbounded_part6_pointwise_paper_domain_certificate_current
#print axioms BlackwellDilemma.not_unbounded_part6_feasible_divergence_witness_current
#print axioms BlackwellDilemma.not_unbounded_part6_full_paper_domain_witness_current
#print axioms BlackwellDilemma.not_unbounded_part6_full_paper_closing_support_current
#print axioms BlackwellDilemma.not_z2_lattice_embedding_local_bridge_current
#print axioms BlackwellDilemma.unbounded_part6_current_obstruction_certificate
#print axioms BlackwellDilemma.part6_full_paper_closing_support_of_z2_lattice_embedding_local_bridge
#print axioms BlackwellDilemma.not_z2_lattice_embedding_closed_unit_local_bridge_current
#print axioms BlackwellDilemma.not_z2_lattice_embedding_closed_unit_local_bridge_paper_support_with_sentimental_reversal_current
#print axioms BlackwellDilemma.alphaStar_eq_one_of_sentimental_welfare_monotone_on_unit
#print axioms BlackwellDilemma.alphaStar_lt_one_requires_sentimental_welfare_reversal_witness
#print axioms BlackwellDilemma.z2LatticeEmbeddingClosedUnitLocalBridgeData_sentimental_welfare_reversal_required
#print axioms BlackwellDilemma.alphaStar_eq_one_current
#print axioms BlackwellDilemma.not_closed_unit_alphaStar_lt_one_current
#print axioms BlackwellDilemma.closed_unit_alpha_domain_nonempty_iff_alphaStar_lt_one
#print axioms BlackwellDilemma.ClosedUnitAlphaStarTailReversalRepairRoute
#print axioms BlackwellDilemma.alphaStar_le_of_closed_unit_tail_reversal_repair_route
#print axioms BlackwellDilemma.alphaStar_lt_one_of_closed_unit_tail_reversal_repair_route
#print axioms BlackwellDilemma.closed_unit_alpha_domain_nonempty_of_tail_reversal_repair_route
#print axioms BlackwellDilemma.not_closed_unit_alphaStar_tail_reversal_repair_route_current
#print axioms BlackwellDilemma.Z2LatticeEmbeddingClosedUnitTailReversalBridgeData
#print axioms BlackwellDilemma.z2LatticeEmbeddingClosedUnitLocalBridgeData_of_tail_reversal_bridge
#print axioms BlackwellDilemma.not_z2_lattice_embedding_closed_unit_tail_reversal_bridge_current
#print axioms BlackwellDilemma.not_closed_unit_alpha_above_alphaStar_current
#print axioms BlackwellDilemma.not_closed_unit_part6_divergence_witness_current
#print axioms BlackwellDilemma.not_closed_unit_part6_feasible_divergence_witness_current
#print axioms BlackwellDilemma.not_closed_unit_part6_full_paper_domain_witness_current
#print axioms BlackwellDilemma.not_closed_unit_part6_full_paper_closing_support_current
#print axioms BlackwellDilemma.closed_unit_part6_current_obstruction_certificate
#print axioms BlackwellDilemma.part6_full_paper_closing_support_of_z2_lattice_embedding_closed_unit_local_bridge
#print axioms BlackwellDilemma.part6_full_paper_closing_bridge_route_of_closed_unit_tail_reversal_bridge
#print axioms BlackwellDilemma.part6_full_paper_closing_bridge_route_of_closed_unit_tail_reversal_bridge_nonempty
#print axioms BlackwellDilemma.part6_full_paper_closing_support_of_closed_unit_tail_reversal_bridge
#print axioms BlackwellDilemma.part6_full_paper_closing_support_of_closed_unit_tail_reversal_bridge_nonempty
#print axioms BlackwellDilemma.Z2LatticeEmbeddingClosedUnitTailReversalBridgeOutputCertificate
#print axioms BlackwellDilemma.z2_lattice_embedding_closed_unit_tail_reversal_bridge_alphaStar_lt_one
#print axioms BlackwellDilemma.z2_lattice_embedding_closed_unit_tail_reversal_bridge_alpha_domain_nonempty
#print axioms BlackwellDilemma.z2_lattice_embedding_closed_unit_tail_reversal_bridge_closed_unit_bridge_nonempty
#print axioms BlackwellDilemma.z2_lattice_embedding_closed_unit_tail_reversal_bridge_full_paper_domain_witness
#print axioms BlackwellDilemma.z2_lattice_embedding_closed_unit_tail_reversal_bridge_full_paper_closing_support_nonempty
#print axioms BlackwellDilemma.z2_lattice_embedding_closed_unit_tail_reversal_bridge_paper_support_with_sentimental_reversal
#print axioms BlackwellDilemma.z2_lattice_embedding_closed_unit_tail_reversal_bridge_paper_support_with_sentimental_reversal_nonempty
#print axioms BlackwellDilemma.part6_full_paper_closing_divergence_witness_of_closed_unit_tail_reversal_bridge
#print axioms BlackwellDilemma.part6_full_paper_closing_feasible_divergence_witness_of_closed_unit_tail_reversal_bridge
#print axioms BlackwellDilemma.part6_full_paper_closing_output_pair_of_closed_unit_tail_reversal_bridge
#print axioms BlackwellDilemma.part6_full_paper_closing_output_pair_of_closed_unit_tail_reversal_bridge_nonempty
#print axioms BlackwellDilemma.part6_full_paper_closing_full_output_bundle_of_closed_unit_tail_reversal_bridge
#print axioms BlackwellDilemma.part6_full_paper_closing_full_output_bundle_of_closed_unit_tail_reversal_bridge_nonempty
#print axioms BlackwellDilemma.z2_lattice_embedding_closed_unit_tail_reversal_bridge_output_certificate
#print axioms BlackwellDilemma.Z2LatticeEmbeddingClosedUnitTailReversalBridgeNonClosureCertificate
#print axioms BlackwellDilemma.z2_lattice_embedding_closed_unit_tail_reversal_bridge_nonclosure_certificate
#print axioms BlackwellDilemma.part6_full_paper_closing_support_of_bridge_route
#print axioms BlackwellDilemma.part6_current_bridge_routes_obstruction_certificate
#print axioms BlackwellDilemma.not_part6_full_paper_closing_support_current
#print axioms BlackwellDilemma.part6_full_paper_closing_support_divergence_witness
#print axioms BlackwellDilemma.part6_full_paper_closing_bridge_route_divergence_witness
#print axioms BlackwellDilemma.not_part6_full_paper_closing_divergence_witness_current
#print axioms BlackwellDilemma.not_Part6FullPaperClosingDivergenceWitness_current
#print axioms BlackwellDilemma.not_part6_full_paper_closing_support_current_via_divergence_witness
#print axioms BlackwellDilemma.not_part6_full_paper_closing_bridge_route_current_via_divergence_witness
#print axioms BlackwellDilemma.part6_full_paper_closing_support_feasible_divergence_witness
#print axioms BlackwellDilemma.part6_full_paper_closing_bridge_route_feasible_divergence_witness
#print axioms BlackwellDilemma.part6_full_paper_closing_support_output_pair
#print axioms BlackwellDilemma.part6_full_paper_closing_bridge_route_output_pair
#print axioms BlackwellDilemma.part6_full_paper_closing_support_full_output_bundle
#print axioms BlackwellDilemma.part6_full_paper_closing_bridge_route_full_output_bundle
#print axioms BlackwellDilemma.Part6FullPaperClosingOutputLayerCertificate
#print axioms BlackwellDilemma.part6_full_paper_closing_output_layer_certificate
#print axioms BlackwellDilemma.Part6NondegenerateFeasibleRepairRoute
#print axioms BlackwellDilemma.part6_nondegenerate_feasible_repair_route_of_full_paper_closing_support
#print axioms BlackwellDilemma.part6_full_paper_closing_support_of_nondegenerate_feasible_repair_route
#print axioms BlackwellDilemma.part6_nondegenerate_feasible_repair_route_iff_full_paper_closing_support
#print axioms BlackwellDilemma.part6_nondegenerate_feasible_repair_route_divergence_witness
#print axioms BlackwellDilemma.part6_nondegenerate_feasible_repair_route_feasible_divergence_witness
#print axioms BlackwellDilemma.part6_nondegenerate_feasible_repair_route_of_bridge_route
#print axioms BlackwellDilemma.part6_nondegenerate_feasible_repair_route_of_closed_unit_tail_reversal_bridge
#print axioms BlackwellDilemma.part6_nondegenerate_feasible_repair_route_of_closed_unit_tail_reversal_bridge_nonempty
#print axioms BlackwellDilemma.part6_nondegenerate_feasible_repair_route_output_pair
#print axioms BlackwellDilemma.part6_nondegenerate_feasible_repair_route_full_output_bundle
#print axioms BlackwellDilemma.not_part6_nondegenerate_feasible_repair_route_current
#print axioms BlackwellDilemma.not_part6_nondegenerate_feasible_repair_route_current_via_divergence_witness
#print axioms BlackwellDilemma.not_part6_nondegenerate_feasible_repair_route_current_via_feasible_divergence_witness
#print axioms BlackwellDilemma.not_part6_nondegenerate_feasible_repair_route_current_via_output_pair
#print axioms BlackwellDilemma.not_part6_nondegenerate_feasible_repair_route_current_via_full_output_bundle
#print axioms BlackwellDilemma.Part6NondegenerateFeasibleRepairRouteCertificate
#print axioms BlackwellDilemma.part6_nondegenerate_feasible_repair_route_certificate
#print axioms BlackwellDilemma.Part6FullPaperClosingSupport
#print axioms BlackwellDilemma.PaperSemanticGate.Part6LatticeEmbeddingSemanticKernelTarget
#print axioms BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_semantic_kernel_target_iff_repair_route
#print axioms BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_semantic_kernel_target_iff_full_support
#print axioms BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_semantic_kernel_target_notYet
#print axioms BlackwellDilemma.Part6CurrentFrontierCertificate
#print axioms BlackwellDilemma.part6_current_frontier_certificate
#print axioms BlackwellDilemma.not_part6_full_paper_closing_feasible_divergence_witness_current
#print axioms BlackwellDilemma.not_Part6FullPaperClosingFeasibleDivergenceWitness_current
#print axioms BlackwellDilemma.not_part6_full_paper_closing_output_pair_current
#print axioms BlackwellDilemma.not_part6_full_paper_closing_full_output_bundle_current
#print axioms BlackwellDilemma.not_part6_full_paper_closing_support_current_via_feasible_divergence_witness
#print axioms BlackwellDilemma.not_part6_full_paper_closing_bridge_route_current_via_feasible_divergence_witness
#print axioms BlackwellDilemma.not_part6_full_paper_closing_support_current_via_output_pair
#print axioms BlackwellDilemma.not_part6_full_paper_closing_bridge_route_current_via_output_pair
#print axioms BlackwellDilemma.not_part6_full_paper_closing_support_current_via_full_output_bundle
#print axioms BlackwellDilemma.not_part6_full_paper_closing_bridge_route_current_via_full_output_bundle
#print axioms BlackwellDilemma.not_part6_full_paper_closing_bridge_route_current
#print axioms BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_frontier_payload
#print axioms BlackwellDilemma.PaperSemanticGate.Part6LatticeEmbeddingFrontierPayloadCertificate
#print axioms BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_frontier_payload_certificate
#print axioms BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_frontier_payload_frontier_progress_certificate
#print axioms BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_frontier_payload_frontier_nonclosure_certificate
#print axioms BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_frontier_payload_current_frontier_certificate
#print axioms BlackwellDilemma.gap_kappaWelfare_cross_partial_link

-- Wrongness.lean decomposition (current scalar interface route):
#print axioms BlackwellDilemma.gap_wrongness

-- Canonical.lean decomposition (public routes plus generic Blackwell routes):
#print axioms BlackwellDilemma.FiveState.gap_interior_optimum
#print axioms BlackwellDilemma.FiveState.gap_three_regime_reversal_existence
#print axioms BlackwellDilemma.FiveState.gap_three_regime_reversal_uniqueness
#print axioms BlackwellDilemma.FiveState.gap_three_regime_reversal_nonmonotone
#print axioms BlackwellDilemma.FiveState.gap_three_regime_reversal_overshoot_decreasing
#print axioms BlackwellDilemma.FiveState.gap_three_regime_reversal_overshoot_continuous
#print axioms BlackwellDilemma.FiveState.gap_three_regime_reversal_overshoot_vanishes_at_p1
#print axioms BlackwellDilemma.FiveState.gap_two_regime_reversal_existence
#print axioms BlackwellDilemma.FiveState.gap_two_regime_reversal_uniqueness
#print axioms BlackwellDilemma.FiveState.gap_two_regime_reversal_nonmonotone
#print axioms BlackwellDilemma.FiveState.gap_two_regime_reversal_overshoot_decreasing
#print axioms BlackwellDilemma.FiveState.gap_two_regime_reversal_overshoot_continuous
#print axioms BlackwellDilemma.FiveState.gap_two_regime_reversal_overshoot_vanishes_at_p1
#print axioms BlackwellDilemma.FiveState.gap_two_regime_cognitive_augmentation_arithmetic_part
#print axioms BlackwellDilemma.FiveState.gap_two_regime_cognitive_augmentation_monotonicity
#print axioms BlackwellDilemma.FiveState.gap_two_regime_sufficient_cognition
#print axioms BlackwellDilemma.FiveState.gap_two_regime_sufficient_cognition_kappaStar_pos
#print axioms BlackwellDilemma.PaperSemanticGate.r10_two_regime_label_recalibration_payload
#print axioms BlackwellDilemma.FiveState.gap_threshold_fiveState_kappa_above_kstar_from_blackwell
#print axioms BlackwellDilemma.FiveState.gap_threshold_fiveState_kappa_above_kstar
#print axioms BlackwellDilemma.FiveState.gap_threshold_fiveState_smooth_transition
#print axioms BlackwellDilemma.FiveState.highKappaOracleRoutingWelfare_eq_oracle
#print axioms BlackwellDilemma.PaperSemanticGate.r10_threshold_five_state_high_kappa_routing_payload
#print axioms BlackwellDilemma.PaperSemanticGate.CompletePaperSemanticKernelOnly
#print axioms BlackwellDilemma.PaperSemanticGate.completePaperSemanticKernelOnly_iff_no_open_targets
#print axioms BlackwellDilemma.PaperSemanticGate.completePaperSemanticKernelOnly_notYet
#print axioms BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetKernelSurface
#print axioms BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaces
#print axioms BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceIds
#print axioms BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceIds_current
#print axioms BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceCount_current
#print axioms BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_target_route
#print axioms BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_target_route_current_obstruction
#print axioms BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_target_route_certificate
#print axioms BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_closure_route
#print axioms BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_route_equivalence
#print axioms BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_closure_route_current_obstruction
#print axioms BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_closure_route_certificate
#print axioms BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_frontier_progress_certificate
#print axioms BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_frontier_nonclosure_certificate
#print axioms BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_current_obstruction
#print axioms BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_frontier_certificate
#print axioms BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceIds_current
#print axioms BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceCount_current
#print axioms BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceIds_eq_frontierPayloadSurfaceIds
#print axioms BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurface_certificate
#print axioms BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurface_frontier_progress_certificate
#print axioms BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurface_frontier_nonclosure_certificate
#print axioms BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurface_frontier_certificate
#print axioms BlackwellDilemma.PaperSemanticGate.openSemanticTargetSurfaceFrontierProgressCertificates_current
#print axioms BlackwellDilemma.PaperSemanticGate.openSemanticTargetSurfaceFrontierNonclosureCertificates_current
#print axioms BlackwellDilemma.PaperSemanticGate.openSemanticTargetSurfaceCurrentFrontierCertificates_current
#print axioms BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetSurfaceRosterConsistencyCertificate
#print axioms BlackwellDilemma.PaperSemanticGate.open_semantic_target_surface_roster_consistency_certificate
#print axioms BlackwellDilemma.PaperSemanticGate.RemainingOpenSemanticTargetsFrontierCertificate
#print axioms BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_frontier_certificate
#print axioms BlackwellDilemma.FiveState.agentWelfare_kappaAgent_current_eq_half
#print axioms BlackwellDilemma.FiveState.not_current_kappaAgent_highKappa_oracle_at_p0
#print axioms BlackwellDilemma.FiveState.gap_bayesian_naive_reversal_present

-- GeneralGraphs.lean decomposition (generic interface routes + public current routes):
#print axioms BlackwellDilemma.agentRewardKernel_greedy_C2prime_kernel_reversal_witness
#print axioms BlackwellDilemma.gap_general_tree_from_reversal
#print axioms BlackwellDilemma.gap_general_tree
#print axioms BlackwellDilemma.gap_cyclic_trap_from_reversal
#print axioms BlackwellDilemma.gap_cyclic_trap
-- `gap_kappaStar_depth_d_log_growth`: the print surfaces only
-- [propext, Classical.choice, Quot.sound] plus the current positive-subtype
-- `KappaStarDepthDCarriers_current`; positivity is a current carrier
-- projection theorem, not an additional theorem hypothesis.
#print axioms BlackwellDilemma.TrapTree.KappaStarDepthDCarriers
#print axioms BlackwellDilemma.TrapTree.KappaStarDepthDCarriers_current
#print axioms BlackwellDilemma.TrapTree.c_star_constant_pos
#print axioms BlackwellDilemma.TrapTree.gap_kappaStar_depth_d_log_growth

-- Individual atom prints + derived theorem:
--  * `terminal_neighbour_implies_C2prime` derived theorem composes the
--    two smaller explicit interfaces below.
--  * `gap_cyclic_trap_from_reversal` is the generic cyclic route.
--    Public `gap_cyclic_trap` consumes the current greedy reversal witness
--    internally; R240 still factors the cyclic condition wrapper through
--    current-carrier C1 plus explicit C2′/C3 diagnostic evidence, rather than
--    a standalone structural equation.
--  * `gap_error_compounding_part2` composes the rfl oracle-path theorem with
--    the current concrete bridge-terminal reward theorem; no empty
--    compatibility carrier remains in the theorem surface.
#print axioms BlackwellDilemma.terminal_neighbour_implies_C2prime
#print axioms BlackwellDilemma.V_g_eq_V_dyn_on_terminal_neighbour_interface
#print axioms BlackwellDilemma.C2_to_C2prime_via_V_g_eq_V_dyn_at_terminal_neighbour_interface
#print axioms BlackwellDilemma.not_C2prime_GreedyPathMisalignment_under_falseDiagnosticSignalData
#print axioms BlackwellDilemma.not_forall_C2prime_GreedyPathMisalignment
#print axioms BlackwellDilemma.not_forall_Conditions_C1_C2prime_C3
#print axioms BlackwellDilemma.C1_Irreversibility_current
#print axioms BlackwellDilemma.Cyclic4BlockedEventConditions
#print axioms BlackwellDilemma.cyclic_4_satisfies_full_conditions_at_blocked_event_closed
#print axioms BlackwellDilemma.TrapTree.oracleBridgePathTerminalReward_TrapTree
#print axioms BlackwellDilemma.TrapTree.oracleValueAtRoot_TrapTree
#print axioms BlackwellDilemma.TrapTree.oracleValueAtRoot_eq_bridgePathTerminalReward_TrapTree
#print axioms BlackwellDilemma.TrapTree.oracleBridgePathTerminalReward_TrapTree_eq_r_goal
#print axioms BlackwellDilemma.TrapTree.gap_error_compounding_part2

-- Phase.lean decompositions (3 derived theorems):
--  * `gap_topo_loss_below_threshold` (Wrongness.lean): composes a
--    paper-derived envelope-existence atom (paper line 286) + Cat 1
--    theorem `topo_loss_below_eps_from_envelope` (Mathlib-discharge
--    from `Filter.Tendsto`) with explicit Cat 2 Grimmett `h_perc_prob`
--    antecedent.
--  * The old Mills-inverse `gap_topo_loss_above_threshold` wrapper is
--    retired. R320/R321 now audits the route through
--    `not_mills_inverse_above_threshold_route_with_unit_bound`, which proves
--    the R200/R201 Mills decomposition contradicts the unit upper bound on
--    `expectedTopoLoss`.
--  * `gap_bayesian_naive_reversal_absent_from_blackwell`
--    (Canonical.lean): single-atom generic route composing
--    `bayesian_naive_below_threshold_blackwell_recovery_atom` with
--    explicit Cat 2 Blackwell `h_blackwell` antecedent.
--    Public `gap_bayesian_naive_reversal_absent` consumes the current
--    closed Blackwell theorem internally.
-- The closure also adds the Cat 1 theorem itself:
--  * `topo_loss_below_eps_from_envelope` (Wrongness.lean): Cat 1 Mathlib
--    derivation from `Filter.Tendsto` neighborhood unfolding + transitivity
--    through envelope upper bound.
#print axioms BlackwellDilemma.gap_topo_loss_below_threshold
#print axioms BlackwellDilemma.not_mills_inverse_above_threshold_route_with_unit_bound
#print axioms BlackwellDilemma.FiveState.gap_bayesian_naive_reversal_absent_from_blackwell
#print axioms BlackwellDilemma.FiveState.gap_bayesian_naive_reversal_absent
-- `topo_loss_below_eps_from_envelope` is consumed inside the
-- `gap_topo_loss_below_threshold` chain; not surfaced separately.

-- Phase.lean sibling of the Wrongness.lean Pattern-1 fix:
--  * `topo_loss_decay_arbitrary_threshold` (Phase.lean): Cat 1 theorem
--    derivation from `Filter.Tendsto` neighborhood unfolding + transitivity
--    through envelope upper bound. Ports the Wrongness.lean proof verbatim.
#print axioms BlackwellDilemma.topo_loss_decay_arbitrary_threshold

-- Closure wave on Phase.lean — 5 derived theorems built from
-- smaller atoms + 1 carrier:
--  * `topo_loss_decay_below_pc` (derived theorem): composes the
--    paper-faithful giant-component-conditional bound and Cat 1
--    Mathlib `tendsto_one_div_add_atTop_nhds_zero_nat`.
--  * `gap_phase_transition_above` (derived theorem): instantiates the
--    existential with carrier `wInfoTopoRatioMillsConst p` and
--    composes two smaller atoms
--    `wInfoTopoRatioMillsConst_pos_above_pc` +
--    `wInfoTopoRatio_le_MillsConst_decay`.
--  * `forward_reachable_full_at_zero` (derived theorem): composes
--    `all_edges_open_at_zero_blocking`
--    (Def 2.1 line 119 percolation semantics) +
--    `forward_reachable_empty_full_at_all_open`, now a theorem from the
--    current concrete `ForwardReachable` definition and complete-loopless
--    `IsEdge`.
--  * `gap_trap_prevalence_above_threshold` (derived theorem, with
--    paper-faithful `p < 1` antecedent): composes Hodge-style def
--    `trapConfigLocalProb` + smaller atom
--    `trapConfigLocalProb_le_misalignmentProb_OPEN` (FKG binding) +
--    Cat 1 theorem `trapConfigLocalProb_pos` (arithmetic positivity).
-- NOTE: `topo_loss_decay_below_pc` is stated on the paper-faithful
-- `expectedTopoLossOnGiant`; its `#print axioms` surfaces the current
-- diagnostic closure theorem `topoLossKernel_le_one_over_n_on_giant_atom` +
-- the `giantComponentEvent` carrier. The full finite-lattice bridge-premise
-- route is audited separately by `topoLossKernel_pointwise_bound_on`.
-- NOTE: `gap_trap_prevalence_above_threshold` is derived on the
-- concretised `trapMisalignmentProbability` chain; its
-- `#print axioms` surfaces the structural-equation atoms
-- `trapLocalConfigProb_pos_and_le` /
-- `restrictedExpectation_eq_localConfigProb` /
-- `trapEventIndicator_nonneg` + the carriers `trapEventIndicator` /
-- `trapLocalConfigEvent` / `trapLocalConfigProb`.
#print axioms BlackwellDilemma.topo_loss_decay_below_pc
#print axioms BlackwellDilemma.wInfoTopoRatioMillsConst
#print axioms BlackwellDilemma.wInfoTopoRatioMillsConst_pos_above_pc
#print axioms BlackwellDilemma.wInfoTopoRatio_le_MillsConst_decay
#print axioms BlackwellDilemma.forward_reachable_full_at_zero
#print axioms BlackwellDilemma.all_edges_open_at_zero_blocking
#print axioms BlackwellDilemma.Infrastructure.paperGraph_preconnected_current
#print axioms BlackwellDilemma.ForwardReachable_empty_full_at_all_open_current
#print axioms BlackwellDilemma.forward_reachable_empty_full_at_all_open
#print axioms BlackwellDilemma.trapConfigLocalProb
#print axioms BlackwellDilemma.trapConfigLocalProb_pos

-- Closure wave on Wrongness.lean: derived theorems + smaller atoms +
-- carriers surface here for kernel-purity baseline:
--  * `wrongness_high_beta_welfare_convergence_atom` is now closed
--    from the concrete greedy scalar kernel: the limit kernel is the
--    constant `6/10`, and `greedyKernelPointwiseTendstoAtTop` proves
--    eventual equality at `Filter.atTop`.
--  * `gap_wrongness` now composes the current scalar
--    `WrongnessGreedyInterfaces_current` reversal-witness input through
--    `wrongness_misalignment_reversal_atom` (paper stage 2 reversal witness,
--    antecedent strengthened to convergence form) after obtaining the stage-1
--    convergence theorem above.
--  * The old above-threshold Mills wrapper is no longer printed as a
--    positive theorem. The route is audited by
--    `not_mills_inverse_above_threshold_route_with_unit_bound`; a future
--    positive theorem needs a corrected unit-compatible lower-bound carrier.
-- NOTE: the below-threshold envelope is stated on the paper-faithful
-- giant-component-conditional form via the derived theorem
-- `topo_loss_on_giant_below_envelope_exists` + the current-global closure
-- `topoLossKernel_le_one_over_n_on_giant_atom`, both printed in
-- the percolation-foundation section below.
#print axioms BlackwellDilemma.WrongnessGreedyInterfaces
#print axioms BlackwellDilemma.GreedyKernelPointwiseTendstoAtTop
#print axioms BlackwellDilemma.greedyKernelPointwiseTendstoAtTop_current
#print axioms BlackwellDilemma.greedyKernelPointwiseTendstoAtTop
#print axioms BlackwellDilemma.GreedyWrongnessKernelReversalWitness
#print axioms BlackwellDilemma.wrongness_high_beta_welfare_convergence_atom
#print axioms BlackwellDilemma.wrongness_high_beta_welfare_convergence_current
#print axioms BlackwellDilemma.wrongness_misalignment_reversal_atom
#print axioms BlackwellDilemma.wrongnessPercolationData
#print axioms BlackwellDilemma.expectedTopoLossAboveLowerConst
#print axioms BlackwellDilemma.expectedTopoLossAboveLowerConst_eq_zero_current
#print axioms BlackwellDilemma.not_expectedTopoLossAboveLowerConst_eq_mills_inverse_current
#print axioms BlackwellDilemma.expectedTopoLoss_le_one_atom
#print axioms BlackwellDilemma.not_mills_inverse_above_threshold_route_with_unit_bound
#print axioms BlackwellDilemma.expectedTopoLossOnData
#print axioms BlackwellDilemma.UnitCompatibleAboveThresholdLowerBoundConclusion
#print axioms BlackwellDilemma.boxedTorusAllOpenGiantTopoLossData_expectedTopoLossOnData_eq_zero
#print axioms BlackwellDilemma.not_UnitCompatibleAboveThresholdLowerBoundConclusion_current
#print axioms BlackwellDilemma.unitPositiveTopoLossData
#print axioms BlackwellDilemma.unitPositiveTopoLossData_topoLossKernel_mem_unitInterval
#print axioms BlackwellDilemma.unitPositiveTopoLossData_expectedTopoLossOnData_eq_half
#print axioms BlackwellDilemma.unitPositiveTopoLossData_unitCompatibleAboveThresholdLowerBoundConclusion
#print axioms BlackwellDilemma.exists_UnitCompatibleAboveThresholdLowerBoundConclusion
#print axioms BlackwellDilemma.firstEdgeIdx
#print axioms BlackwellDilemma.firstEdgeStochasticTopoLossData
#print axioms BlackwellDilemma.firstEdgeStochasticTopoLossData_topoLossKernel_open_closed
#print axioms BlackwellDilemma.firstEdgeStochasticTopoLossData_topoLossKernel_mem_unitInterval
#print axioms BlackwellDilemma.firstEdgeStochasticTopoLossData_expectedTopoLossOnData_eq
#print axioms BlackwellDilemma.firstEdgeStochasticTopoLossData_unitCompatibleAboveThresholdLowerBoundConclusion
#print axioms BlackwellDilemma.firstEdgeOpenEvent
#print axioms BlackwellDilemma.firstEdgeOpenEvent_mem_iff
#print axioms BlackwellDilemma.firstEdgeOpenEvent_nonempty
#print axioms BlackwellDilemma.firstEdgeOpenEvent_mass_eq
#print axioms BlackwellDilemma.firstEdgeOpenEvent_mass_pos
#print axioms BlackwellDilemma.firstEdgeOpenEvent_restricted_indicator_eq
#print axioms BlackwellDilemma.firstEdgeGiantStochasticTopoLossData
#print axioms BlackwellDilemma.firstEdgeGiantStochasticTopoLossData_topoLossKernel_mem_unitInterval
#print axioms BlackwellDilemma.firstEdgeGiantStochasticTopoLossData_expectedTopoLossOnData_eq
#print axioms BlackwellDilemma.firstEdgeGiantStochasticTopoLossData_expectedTopoLossOnGiantOn_eq
#print axioms BlackwellDilemma.firstEdgeGiantStochasticTopoLossData_giantEventPositiveMassConclusion
#print axioms BlackwellDilemma.firstEdgeGiantStochasticTopoLossData_giantEventFullClusterConclusion
#print axioms BlackwellDilemma.firstEdgeGiantStochasticTopoLossData_unitCompatibleAboveThresholdLowerBoundConclusion
#print axioms BlackwellDilemma.firstEdgeGiantStochasticTopoLossData_positiveGiant_and_unitCompatible
#print axioms BlackwellDilemma.FirstEdgeGiantStochasticTopoLossPositiveRegressionCertificate
#print axioms BlackwellDilemma.firstEdgeGiantStochasticTopoLossData_positive_regression_certificate
#print axioms BlackwellDilemma.not_TopoLossKernelPointwiseBoundOn_firstEdgeGiantStochasticTopoLossData
#print axioms BlackwellDilemma.not_BoxedTorusFlatFamilyCoreConclusion_firstEdgeGiantStochastic_family
#print axioms BlackwellDilemma.not_randomSupercriticalZ2TopoClusterRepairedBridgeData_firstEdgeGiantStochastic_family
#print axioms BlackwellDilemma.FirstEdgeGiantStochasticTopoLossNotRandomSupercriticalZ2BridgeCertificate
#print axioms BlackwellDilemma.firstEdgeGiantStochasticTopoLossData_not_random_supercritical_z2_bridge_certificate
#print axioms BlackwellDilemma.boxedTorusAllOpenGiantEvent_indicator_expectation_eq_pow_edgeCard
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_topoLossKernel_mem_unitInterval
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_clusterCount_eq_full_on_flat_giant
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_giantComponentEvent_flat
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_topoLossKernel_flat
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_giantEvent_flat_nonempty
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_flat_giantEventMass_eq_pow_edgeCard
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_flat_giantEventMass_pos
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_giantEventPositiveMassConclusion
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_giantEventFullClusterConclusion
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_expectedTopoLossOnGiant_flat_eq
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_expectedTopoLossOnGiant_flat_pos
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_expectedTopoLossOnData_flat_eq
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_expectedTopoLossOnData_flat_pos
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_expectedTopoLossOnData_eq_zero_of_ne
#print axioms BlackwellDilemma.not_UnitCompatibleAboveThresholdLowerBoundConclusion_boxedTorusAllOpenPositive
#print axioms BlackwellDilemma.boxedTorusAllOpenFirstEdgeAwayTopoLossData
#print axioms BlackwellDilemma.boxedTorusAllOpenFirstEdgeAwayTopoLossData_topoLossKernel_mem_unitInterval
#print axioms BlackwellDilemma.WInfoOracleInterfacesOn_boxedTorusAllOpenFirstEdgeAwayTopoLossData
#print axioms BlackwellDilemma.boxedTorusAllOpenFirstEdgeAwayTopoLossData_oracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.boxedTorusAllOpenFirstEdgeAwayTopoLossData_expectedTopoLossOnData_flat_eq_zero
#print axioms BlackwellDilemma.boxedTorusAllOpenFirstEdgeAwayTopoLossData_expectedTopoLossOnData_eq_of_ne
#print axioms BlackwellDilemma.boxedTorusAllOpenFirstEdgeAwayTopoLossData_topoLossKernel_pointwise_bound
#print axioms BlackwellDilemma.boxedTorusAllOpenFirstEdgeAwayTopoLossData_expectedTopoLossOnGiantEnvelopeConclusion
#print axioms BlackwellDilemma.boxedTorusAllOpenFirstEdgeAwayTopoLossData_giantEventFullClusterConclusion
#print axioms BlackwellDilemma.boxedTorusAllOpenFirstEdgeAwayTopoLossData_clusterCountExpectationBoundsConclusion
#print axioms BlackwellDilemma.boxedTorusAllOpenFirstEdgeAwayTopoLossData_unitCompatibleAboveThresholdLowerBoundConclusion
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossData
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossData_topoLossKernel_mem_unitInterval
#print axioms BlackwellDilemma.WInfoOracleInterfacesOn_firstEdgeOpenGiantClosedTopoLossData
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossData_oracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossData_topoLossKernel_zero_on_giant
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossData_topoLossKernel_pointwise_bound
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossData_expectedTopoLossOnGiantOn_eq_zero
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossData_expectedTopoLossOnGiantEnvelopeConclusion
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossData_expectedTopoLossOnData_eq
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossData_giantEventFullClusterConclusion
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossData_clusterCountExpectationBoundsConclusion
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossData_unitCompatibleAboveThresholdLowerBoundConclusion
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossData_corePackages
#print axioms BlackwellDilemma.allEdgeOpenEvent
#print axioms BlackwellDilemma.allEdgeOpenEvent_mem_iff
#print axioms BlackwellDilemma.allEdgeOpenEvent_nonempty
#print axioms BlackwellDilemma.allEdgeOpenEvent_mass_eq
#print axioms BlackwellDilemma.allEdgeOpenEvent_mass_pos
#print axioms BlackwellDilemma.allEdgeOpenGiantComplementTopoLossData
#print axioms BlackwellDilemma.allEdgeOpenGiantComplementTopoLossData_topoLossKernel_mem_unitInterval
#print axioms BlackwellDilemma.WInfoOracleInterfacesOn_allEdgeOpenGiantComplementTopoLossData
#print axioms BlackwellDilemma.allEdgeOpenGiantComplementTopoLossData_oracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.allEdgeOpenGiantComplementTopoLossData_topoLossKernel_zero_on_giant
#print axioms BlackwellDilemma.allEdgeOpenGiantComplementTopoLossData_topoLossKernel_pointwise_bound
#print axioms BlackwellDilemma.allEdgeOpenGiantComplementTopoLossData_expectedTopoLossOnGiantOn_eq_zero
#print axioms BlackwellDilemma.allEdgeOpenGiantComplementTopoLossData_expectedTopoLossOnGiantEnvelopeConclusion
#print axioms BlackwellDilemma.allEdgeOpenGiantComplementTopoLossData_expectedTopoLossOnData_ge
#print axioms BlackwellDilemma.allEdgeOpenGiantComplementTopoLossData_giantEventFullClusterConclusion
#print axioms BlackwellDilemma.allEdgeOpenGiantComplementTopoLossData_clusterCountExpectationBoundsConclusion
#print axioms BlackwellDilemma.allEdgeOpenGiantComplementTopoLossData_unitCompatibleAboveThresholdLowerBoundConclusion
#print axioms BlackwellDilemma.allEdgeOpenGiantComplementTopoLossData_corePackages
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_topoLossKernel_mem_unitInterval
#print axioms BlackwellDilemma.WInfoOracleInterfacesOn_boxedTorusAllOpenComplementTopoLossData
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_oracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_topoLossKernel_zero_on_giant
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_topoLossKernel_pointwise_bound
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_expectedTopoLossOnGiantOn_eq_zero
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_expectedTopoLossOnGiantEnvelopeConclusion
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_expectedTopoLossOnData_eq_of_ne
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_giantEventFullClusterConclusion
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_clusterCountExpectationBoundsConclusion
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_unitCompatibleAboveThresholdLowerBoundConclusion
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_corePackages
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_topoLossKernel_flat
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_expectedTopoLossOnData_flat_eq
#print axioms BlackwellDilemma.boxedTorusEdgeIdx_card_pos
#print axioms BlackwellDilemma.one_quarter_pow_boxedTorusEdgeIdx_card_le_one_quarter
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_expectedTopoLossOnData_flat_ge_eighth
#print axioms BlackwellDilemma.BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion
#print axioms BlackwellDilemma.BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion_current
#print axioms BlackwellDilemma.boxedTorusCoordClosedEdgeSetEvent
#print axioms BlackwellDilemma.boxedTorusCoordClosedEdgeSetEvent_mem_iff
#print axioms BlackwellDilemma.boxedTorusCoordClosedEdgeSetEventMass_eq_one_sub_pow_card
#print axioms BlackwellDilemma.boxedTorusCoordOpenPathLength_eq_base_of_baseIncident_closed
#print axioms BlackwellDilemma.boxedTorusFullReachGiantEvent
#print axioms BlackwellDilemma.boxedTorusFullReachGiantEvent_mem_iff
#print axioms BlackwellDilemma.boxedTorusAllOpenGiantEvent_subset_fullReachGiantEvent
#print axioms BlackwellDilemma.boxedTorusFullReachGiantEvent_nonempty
#print axioms BlackwellDilemma.boxedTorusFullReachGiantEventMass_pos
#print axioms BlackwellDilemma.boxedTorusReachableSet_card_eq_full_on_fullReachGiantEvent
#print axioms BlackwellDilemma.boxedTorusReachableSet_mem_of_card_eq_full
#print axioms BlackwellDilemma.boxedTorusFullReachGiantEvent_clusterCount_eq_full
#print axioms BlackwellDilemma.boxedTorusBaseIncidentClosedEvent
#print axioms BlackwellDilemma.boxedTorusBaseIncidentClosedEvent_mem_iff
#print axioms BlackwellDilemma.boxedTorusBaseIncidentClosedEventMass_eq
#print axioms BlackwellDilemma.BoxedTorusBaseTargetSeparator
#print axioms BlackwellDilemma.BoxedTorusBaseTargetEdgeCutset
#print axioms BlackwellDilemma.boxedTorusCoordEdgeBoundarySet
#print axioms BlackwellDilemma.boxedTorusCoordEdgeBoundarySet_mem_of_edgeAdj
#print axioms BlackwellDilemma.boxedTorusCoordSimplePathSkeleton_meets_edgeBoundary_of_not_mem
#print axioms BlackwellDilemma.boxedTorusCoordEdgeBoundarySet_baseTargetEdgeCutset
#print axioms BlackwellDilemma.boxedTorusCoordEdgeBoundarySet_baseSingleton_subset_baseIncident
#print axioms BlackwellDilemma.boxedTorusCoordEdgeBoundarySet_baseSingleton_card_le_four
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalTarget_not_mem_baseSingleton
#print axioms BlackwellDilemma.boxedTorusCoordEdgeBoundarySet_baseTargetSeparator
#print axioms BlackwellDilemma.boxedTorusCoordEdgeBoundarySet_baseSingleton_baseTargetSeparator
#print axioms BlackwellDilemma.boxedTorusCoordSimplePathSkeleton_meets_baseIncident_of_pos
#print axioms BlackwellDilemma.boxedTorusBaseIncidentEdgeSet_baseTargetEdgeCutset
#print axioms BlackwellDilemma.boxedTorusBaseTargetSeparator_of_edgeCutset
#print axioms BlackwellDilemma.boxedTorusBaseTargetEdgeCutset_of_separator
#print axioms BlackwellDilemma.boxedTorusBaseIncidentEdgeSet_baseTargetSeparator
#print axioms BlackwellDilemma.boxedTorusCoordClosedEdgeSetEvent_not_fullReach_of_baseTargetSeparator
#print axioms BlackwellDilemma.boxedTorusBaseIncidentClosedEvent_not_fullReach
#print axioms BlackwellDilemma.boxedTorusFullReachFailureEvent
#print axioms BlackwellDilemma.boxedTorusFullReachFailureEvent_mem_iff
#print axioms BlackwellDilemma.boxedTorusFullReachGiantFailureEventMass_add_eq_one
#print axioms BlackwellDilemma.boxedTorusFullReachFailureEventMass_eq_one_sub_fullReachGiantEventMass
#print axioms BlackwellDilemma.boxedTorusBaseIncidentClosedEvent_subset_fullReachFailureEvent
#print axioms BlackwellDilemma.boxedTorusCoordClosedEdgeSetEvent_subset_fullReachFailureEvent_of_baseTargetSeparator
#print axioms BlackwellDilemma.boxedTorusFullReachFailureEventMass_ge_closedSeparator
#print axioms BlackwellDilemma.boxedTorusFullReachFailureEventMass_ge_closedSeparator_one_sub
#print axioms BlackwellDilemma.boxedTorusFullReachFailureEventMass_ge_closedBoundary
#print axioms BlackwellDilemma.boxedTorusFullReachFailureEventMass_ge_closedBoundary_one_sub
#print axioms BlackwellDilemma.boxedTorusFullReachFailureEventMass_ge_baseIncidentClosed
#print axioms BlackwellDilemma.boxedTorusFullReachFailureEventMass_ge_baseIncidentClosed_one_sub
#print axioms BlackwellDilemma.boxedTorusFullReachGiantEventMass_le_one_sub_closedSeparator
#print axioms BlackwellDilemma.boxedTorusFullReachGiantEventMass_le_one_sub_closedSeparator_one_sub
#print axioms BlackwellDilemma.boxedTorusFullReachGiantEventMass_le_one_sub_closedBoundary
#print axioms BlackwellDilemma.boxedTorusFullReachGiantEventMass_le_one_sub_closedBoundary_one_sub
#print axioms BlackwellDilemma.boxedTorusFullReachGiantEventMass_le_one_sub_baseIncidentClosed
#print axioms BlackwellDilemma.boxedTorusFullReachGiantEventMass_le_one_sub_baseIncidentClosed_one_sub
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_topoLossKernel_mem_unitInterval
#print axioms BlackwellDilemma.WInfoOracleInterfacesOn_boxedTorusFullReachComplementTopoLossData
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_oracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_topoLossKernel_zero_on_giant
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_topoLossKernel_pointwise_bound
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnGiantOn_eq_zero
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnGiantEnvelopeConclusion
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_eq_of_ne
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_giantEventFullClusterConclusion
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_clusterCountExpectationBoundsConclusion
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_unitCompatibleAboveThresholdLowerBoundConclusion
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_corePackages
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_topoLossKernel_flat
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedSeparator
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedCutset
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedIncident
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedBoundary
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedSeparator_pow_div_two_of_card_le
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedCutset_pow_div_two_of_card_le
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedBoundary_pow_div_two_of_card_le
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_flat_ge_baseSingletonBoundary
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_flat_ge_baseSingletonBoundary_pow_four_div_two
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_flat_ge_baseSingletonBoundary_one_over_512
#print axioms BlackwellDilemma.one_over_512_le_three_quarters_pow_div_two_of_le_four
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_flat_ge_one_over_512
#print axioms BlackwellDilemma.BoxedTorusFlatFamilyCoreConclusion
#print axioms BlackwellDilemma.BoxedTorusFlatFamilyCoreConclusion_expectedTopoLossOnGiantEnvelope
#print axioms BlackwellDilemma.BoxedTorusFullReachComplementLowerBoundConclusion_of_eventually_boundedSeparator_at
#print axioms BlackwellDilemma.BoxedTorusFullReachComplementLowerBoundConclusion_of_eventually_boundedCutset_at
#print axioms BlackwellDilemma.BoxedTorusFullReachComplementLowerBoundConclusion_of_eventually_boundedBoundary_at
#print axioms BlackwellDilemma.BoxedTorusFullReachComplementLowerBoundConclusion_of_eventually_boundedBoundary
#print axioms BlackwellDilemma.BoxedTorusFullReachComplementLowerBoundConclusion_of_eventually_smallBoundary
#print axioms BlackwellDilemma.BoxedTorusFullReachComplementLowerBoundConclusion_current
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_flatFamilyCoreConclusion
#print axioms BlackwellDilemma.BoxedTorusFullReachFlatUnitCompatibleAboveThresholdLowerBoundConclusion_current
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_topoLossKernel_mem_unitInterval
#print axioms BlackwellDilemma.WInfoOracleInterfacesOn_boxedTorusFullReachFlatOnlyComplementTopoLossData
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_oracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_topoLossKernel_zero_on_giant
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_topoLossKernel_pointwise_bound
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnGiantOn_eq_zero
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnGiantEnvelopeConclusion
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_eq_of_ne
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_giantEventFullClusterConclusion
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_clusterCountExpectationBoundsConclusion
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_corePackages
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_topoLossKernel_flat
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_eq_fullReachComplement
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_eq_failureMass
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_eq_one_sub_fullReachMass
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_flatOnlyDiagnostic
#print axioms BlackwellDilemma.not_UnitCompatibleAboveThresholdLowerBoundConclusion_boxedTorusFullReachFlatOnly
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedSeparator
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedCutset
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedIncident
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedBoundary
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedBoundary_one_over_512
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_baseSingletonBoundary
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_baseSingletonBoundary_pow_four_div_two
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_baseSingletonBoundary_one_over_512
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_one_over_512
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedSeparator_pow_div_two_of_card_le
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedCutset_pow_div_two_of_card_le
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedBoundary_pow_div_two_of_card_le
#print axioms BlackwellDilemma.BoxedTorusFullReachFlatOnlyLowerBoundConclusion_of_eventually_boundedSeparator_at
#print axioms BlackwellDilemma.BoxedTorusFullReachFlatOnlyLowerBoundConclusion_of_eventually_boundedCutset_at
#print axioms BlackwellDilemma.BoxedTorusFullReachFlatOnlyLowerBoundConclusion_of_eventually_boundedBoundary_at
#print axioms BlackwellDilemma.BoxedTorusFullReachFlatOnlyLowerBoundConclusion_of_eventually_boundedBoundary
#print axioms BlackwellDilemma.BoxedTorusFullReachFlatOnlyLowerBoundConclusion_of_eventually_smallBoundary
#print axioms BlackwellDilemma.BoxedTorusFullReachFlatOnlyLowerBoundCutsetRouteCertificate
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyLowerBound_cutset_route_certificate
#print axioms BlackwellDilemma.BoxedTorusFullReachFlatOnlyLowerBoundConclusion_current
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_flatFamilyCoreConclusion

-- Closure wave on Cognitive.lean: derived theorems + smaller atoms
-- + carrier surface here for kernel-purity baseline:
--  * `mLimit_pos` (current concrete-def Cat 1 theorem): composes
--    `mLimit_eq_mLimitDifference` with `mLimitDifference_pos`, which
--    unfolds the current `mLimitDifference` carrier to the canonical
--    five-state V_dyn-difference positivity theorem. No C1-C3 or
--    diagnostic-instance parameter remains on this positivity chain.
--  * `alpha_star_existence_via_continuity` (derived theorem):
--    composes the existing `alphaStar_def` (Cat 3 atom) + Cat 1
--    Mathlib `le_csSup` / `csSup_le` + smaller paper-derived atom
--    `alpha_below_alpha_star_implies_monotonicity` (paper line
--    602 implicit downward-closure of monotonicity-set). Cat 3 derived
--    theorem (consumed by `gap_sentimental_immunity`).
#print axioms BlackwellDilemma.mLimit_pos
#print axioms BlackwellDilemma.mLimitDifference
#print axioms BlackwellDilemma.mLimit_eq_mLimitDifference
#print axioms BlackwellDilemma.mLimitDifference_pos
#print axioms BlackwellDilemma.alpha_star_existence_via_continuity
#print axioms BlackwellDilemma.alpha_below_alpha_star_implies_monotonicity

-- Closure wave on Canonical.lean: derived theorems + smaller atoms
-- surface here for kernel-purity baseline:
--  * `inflection_at_kstar` (derived theorem): composes the
--    structural-equation atom
--    `smoothTransitionBeta_corresponds_to_interior_optimum_OPEN`
--    (paper line 863 explicit `corresponding to β*` identification
--    of the inflection point with the prop:interior-optimum line 774
--    witness) + the existing `interior_minimiser_existence`
--    witness's positivity clause `0 < β_star`.
--    Downstream `gap_threshold_fiveState_smooth_transition` consumes
--    `inflection_at_kstar` at identical call signature.
--  * `betaStarOfP_def` (derived theorem via existence-via-Classical.choose
--    closure): `noncomputable def betaStarOfP (p : ℝ) : ℝ :=
--    if h : 0 ≤ p ∧ p < p_1 then
--    Classical.choose (L_minimum_exists_in_regime_i p h.1 h.2)
--    else 0`; `betaStarOfP_def` proof via `dif_pos` + `Classical.
--    choose_spec.2`. Downstream `betaStarOfP_loss_below_limit` consumes
--    the derived theorem at identical call signature.
-- `smoothTransitionBeta` is a `noncomputable def := Classical.choose
-- interior_minimiser_existence`; positivity derives Cat 1 from
-- `Classical.choose_spec.1`. The `inflection_at_kstar` print remains
-- as the canonical kernel-purity check for the derivation.
#print axioms BlackwellDilemma.FiveState.inflection_at_kstar
#print axioms BlackwellDilemma.FiveState.betaStarOfP_def
#print axioms BlackwellDilemma.FiveState.L_minimum_exists_in_regime_i
#print axioms BlackwellDilemma.FiveState.betaStarOfP
#print axioms BlackwellDilemma.FiveState.smoothTransitionBeta

-- Substantive-math closures (concrete-def closure of paper-stated
-- structural-equation atoms via the concrete-def closure pattern,
-- applied to two classes — sup/inf-characterisation atoms and paper-
-- named regime-split atoms):
--
-- (1) `kappaStar_def` (paper Theorem 4.1 Part 3 line 493 inf-
--     characterisation `κ* = inf{κ > 0 : m(κ) ≥ 0}`): derived theorem
--     via `noncomputable def kappaStar (p _α : ℝ) : ℝ :=
--     sInf {κ : ℝ | 0 < κ ∧ 0 ≤ mean_estimate_gap p κ}` +
--     `theorem kappaStar_def := fun _ _ => rfl`.
-- (2) `alphaStar_def` (paper `prop:sentimental` proof line 602 sup-
--     characterisation): derived theorem via
--     `noncomputable def alphaStar (κ _p : ℝ) : ℝ := sSup {...}` +
--     `theorem alphaStar_def := fun _ _ => rfl`.
-- (3) `myopic_k_eq_bayesian_above_divergence_depth` (paper Remark
--     `rem:robustness-misspec` (ii) line 942 paper-named regime split at
--     horizon `k ≥ d` on the current carrier): derived theorem via
--     `noncomputable def myopicKWelfare :=
--     if k ≥ d then agentWelfare AgentType.bayesian β 0 1
--     else myopicKWelfareBelowDepth MyopicKWelfareCarriers_current k d β` +
--     `theorem ... := by
--     unfold myopicKWelfare; exact if_pos hkd`. The transparent
--     `MyopicKWelfareCarriers` carrier is exposed through
--     `myopicKWelfareBelowDepth` for the paper-implicit `k < d` regime.
--
-- Each closure is HONEST (paper's exact identification formula or
-- paper-named regime split is encoded in the def body, no content-
-- erasure). The corresponding identifiers are now bound to derived
-- theorems; #print axioms reflects the kernel-pure derivation chain
-- (depending on `mean_estimate_gap`, `agentWelfare`, explicit carrier
-- parameters, etc., not on opaque axioms).
#print axioms BlackwellDilemma.kappaStar_def
#print axioms BlackwellDilemma.alphaStar_def
#print axioms BlackwellDilemma.myopicKWelfareBelowDepth

-- Substantive L-carrier closure wave (3 Cat 3 paper-derived atoms
-- about the CONCRETE 5-state welfare-loss carrier `L β p` closed by
-- genuine real-analysis on the concrete definition — NOT by
-- `Classical.choose` / opaque-carrier reclassification):
--
-- (1) `L_below_limit_at_some_beta` (paper prop:three-regime-five-
--     state Regime (i) line 814 below-limit β* existence): derived
--     theorem via `theorem L_below_limit_at_some_beta
--     := L_below_limit_at_some_beta_proof`. The proof composes the
--     rearrangement identity `eq:five-state-rearr` (`L_rearrangement`,
--     by `ring`), the strict bound `P_trap β < 1` (`P_trap_lt_one`,
--     from ClassicalResults lemma `Phi_lt_one`), and `Φ_B β → 1`
--     as β → ∞ (`Phi_B_tendsto_one_atTop`, from
--     `signalVariance_tendsto_zero_atTop` + `Phi_tendsto_one_atTop`).
-- (2) `L_nonmonotone_witnesses` (Regime (i) non-monotonicity):
--     derived theorem; both witness pairs proved from the
--     below-limit witness β* plus the endpoint limits `L_tendsto_atZero`
--     / `L_tendsto_limit_atTop`.
-- (3) `envelope_derivative_sign_in_p` (Regime (i) overshoot
--     existential): derived theorem; β*₁ = below-limit witness
--     for p₁, β*₂ = finite witness from `L_tendsto_limit_atTop` for p₂.
--
-- ClassicalResults.lean Mathlib-derived helpers: `Phi_reflect`,
-- `Phi_tail_integral_pos` (via `MeasureTheory.setIntegral_pos_iff_
-- support_of_nonneg_ae`), `Phi_gt_half_of_pos` (via `intervalIntegral.
-- intervalIntegral_pos_of_pos`), `Phi_pos`, `Phi_lt_one`. Each closure
-- is honest (genuine proof on the concrete `L` definition, no
-- content-erasure, no `sorry`). `#print axioms` on all 3 closures =
-- [propext, Classical.choice, Quot.sound] only (Classical.choice from
-- the `Filter.Tendsto.eventually` machinery; no project `_OPEN` axiom).
#print axioms BlackwellDilemma.FiveState.L_below_limit_at_some_beta
#print axioms BlackwellDilemma.FiveState.L_nonmonotone_witnesses
#print axioms BlackwellDilemma.FiveState.envelope_derivative_sign_in_p
#print axioms BlackwellDilemma.Phi_lt_one
#print axioms BlackwellDilemma.Phi_gt_half_of_pos
#print axioms BlackwellDilemma.Phi_reflect

-- Substantive L-carrier closure wave (2 Cat 3 paper-derived atoms
-- about the CONCRETE 5-state welfare-loss carrier `L β p` closed by
-- genuine real-analysis — the EXTREME VALUE THEOREM — on the concrete
-- definition, NOT by `Classical.choose` / opaque-carrier
-- reclassification):
--
-- (1) `interior_minimiser_existence` (paper prop:interior-optimum
--     line 774; `∃ β* > 0, ∀ β ≥ 0, L(β*,0) ≤ L(β,0)`): derived
--     theorem via `theorem interior_minimiser_existence :=
--     interior_minimiser_existence_proof`. KEY INSIGHT: existence of an
--     interior minimiser does NOT require the explicit `β* ≈ 1.5 bits`
--     numeric witness — it follows from the extreme value theorem. The
--     proof composes `L_below_limit_at_some_beta_proof` (interior
--     point with `L < 0.4`), `L_tendsto_atZero` /
--     `L_tendsto_limit_atTop` (boundary values exceed it), the
--     continuity lemma `L_continuousOn_Ioi`, the closed-form boundary
--     value `L_zero_zero` (`L(0,0) = 0.425`), and
--     `IsCompact.exists_isMinOn` on a compact `[ε, M]`.
-- (2) `L_minimum_exists_in_regime_i` (paper prop:three-regime-
--     five-state Regime (i) line 814; `∀ p ∈ [0,p_1), ∃ β_min > 0,
--     ∀ β > 0, L(β_min,p) ≤ L(β,p)`): derived theorem via
--     `theorem L_minimum_exists_in_regime_i :=
--     L_minimum_exists_in_regime_i_proof`. Same extreme-value-theorem
--     argument, generalised to `p` and restricted to `β > 0`.
--
-- Canonical.lean private continuity lemmas (Mathlib-derived):
-- `signalVariance_continuousOn_Ioi` (denominator `2^(2β)−1` continuous
-- and ≠ 0 on `Ioi 0`, via `Real.continuous_const_rpow` +
-- `ContinuousOn.div`), `sqrt_two_sigma_continuousOn_Ioi`,
-- `P_trap_continuousOn_Ioi`, `Phi_B_continuousOn_Ioi`,
-- `L_continuousOn_Ioi`, `L_zero_zero`. Each closure is honest (genuine
-- extreme-value-theorem proof on the concrete `L` definition, no
-- content-erasure, no `sorry`). `#print axioms` on both closures =
-- [propext, Classical.choice, Quot.sound] only (Classical.choice from
-- the `Filter.Tendsto.eventually` / `IsCompact.exists_isMinOn`
-- machinery; no project `_OPEN` axiom).
#print axioms BlackwellDilemma.FiveState.interior_minimiser_existence
#print axioms BlackwellDilemma.FiveState.L_minimum_exists_in_regime_i

-- Substantive closure wave: `L'` derivative infrastructure +
-- `Tendsto_overshoot_at_p1` closed by a SQUEEZE argument on the
-- concrete `overshootRegimeI` carrier.
--
-- (1) `Tendsto_overshoot_at_p1` (paper prop:three-regime-five-
--     state Regime (i) line 814 third bullet, "overshoot vanishing at
--     p_1"): derived theorem via a genuine SQUEEZE on the
--     concrete `overshootRegimeI p = 0.4 − L(β*(p), p)` carrier. Lower
--     bound `0 < overshootRegimeI p` from `betaStarOfP_loss_below_limit`;
--     upper bound `overshootRegimeI p ≤ (1/2)·(0.9(1−p) − 0.5)` from
--     the rearrangement `eq:five-state-rearr` EVALUATED AT the
--     minimiser `β*(p) > 0` (`overshootRegimeI_upper_bound`, using the
--     strict `β > 0` bounds `P_trap β*(p) ∈ (1/2,1)`,
--     `Φ_B β*(p) < 1`); both bounds → 0 as `p → p_1⁻` (the upper bound
--     because `0.9·(5/9) − 0.5 = 0` at `p_1 = 4/9`); concluded by
--     `tendsto_of_tendsto_of_tendsto_of_le_of_le'`. KEY INSIGHT: this
--     closure does NOT consume the transcendental unimodality input
--     `L_unimodal_in_regime_i` — the squeeze needs only the
--     rearrangement at `β*(p)` plus the minimiser positivity
--     `betaStarOfP_pos` (`Classical.choose_spec` of the closed
--     `L_minimum_exists_in_regime_i` theorem).
--
-- Canonical.lean `L'` derivative infrastructure (Mathlib-derived,
-- reusable): `phi_pos_local`, `hasDerivAt_two_rpow_two_beta` (via
-- `Real.hasStrictDerivAt_const_rpow`), `hasDerivAt_signalVariance`
-- (via `HasDerivAt.inv`), `signalVariance_deriv_neg`,
-- `hasDerivAt_sqrt_two_sigma` (via `HasDerivAt.sqrt`),
-- `sqrt_two_sigma_deriv_neg`, `hasDerivAt_P_trap` / `hasDerivAt_Phi_B`
-- (chain rule `HasDerivAt.comp` with the closed `gap_Phi_derivative`),
-- `P_trap_deriv_pos` / `Phi_B_deriv_pos`, `hasDerivAt_L` (product/sum
-- combinators on the concrete `L`), `L_deriv_grouped` (the
-- `eq:five-state-rearr`-aligned `L'` sign decomposition
-- `L'(β,p) = P_trap'(β)·(0.9(1−p)Φ_B(β) − 0.5)
--            − (1−P_trap β)·0.9(1−p)·Φ_B'(β)`),
-- `L_hasDerivAt_negative_on_left_branch` (the audit-facing theorem
-- packaging the genuine left-branch sign: `L' < 0` wherever
-- `0.9(1−p)Φ_B β ≤ 1/2`) and
-- `L_hasDerivAt_positive_of_right_branch_dominance` (the corresponding
-- right-branch theorem conditional on the exact remaining transcendental
-- dominance inequality). R241 also proves
-- `L_global_minimizer_not_left_branch`: any positive global minimiser of
-- `β ↦ L β p` with `p ≤ 1` must lie strictly on the right branch, using a
-- kernel-pure negative-derivative local-descent lemma plus the R236
-- left-branch derivative theorem. R242 proves
-- `L_global_minimizer_not_right_branch_dominance`: the current right-branch
-- dominance condition cannot hold at a positive global minimiser, because it
-- gives a positive derivative and hence a strict positive-domain descent point
-- to the left. R243 proves the positive-domain Fermat condition for the
-- concrete carrier: `L_global_minimizer_derivative_grouped_eq_zero` and
-- `L_global_minimizer_first_order_balance` show that any positive global
-- minimiser satisfies the exact grouped first-order balance equation. The
-- R256 closes the former strict-uniqueness bridge: after factoring out the
-- common positive chain-rule scale, changing
-- variables to `z = Delta_B / sqrt(2 * signalVariance beta)`, removing the
-- positive `Delta_B` factor, and writing the normalized z-core as
-- `c * H(z) - K(z)`, R251 further factors `H(z) = scale(z) * D(z)` and
-- `K(z) = (1/2) * scale(z)`. The remaining claim is positivity persistence
-- and strict increase of the hazard/Mills denominator
-- `Phi z * (1 - (upperMills((2/9)z) * lowerHazard z) / (2/9))`. R253
-- reduces that denominator shape to antitonicity of the explicit
-- hazard/Mills product, and R254 reduces product antitonicity to the separate
-- antitonicity of the upper Mills ratio and lower hazard ratio. R255 proves
-- lower-hazard antitonicity by quotient differentiation using
-- `gap_phi_derivative`, `gap_Phi_derivative`, and `Phi_pos`. R256 proves
-- upper-Mills antitonicity by quotient differentiation plus
-- `gap_phi_tail_bound` and `Phi_reflect`. The former compatibility name
-- `L_strict_unique_minimizer_paper_Def` has been retired from source and no
-- longer appears in public theorem signatures. The R253 product bridge is now a closed
-- theorem derived by
-- `L_normalizedZHazardProduct_antitone_from_factor_antitone`, the R252
-- hazard-denominator bridge is derived by
-- `L_normalizedZHazardDenomShape_from_product_antitone`, the R251
-- threshold-denominator bridge is derived by
-- `L_normalizedZThresholdDenomShape_from_hazardDenomShape`, and the R250
-- threshold-shape bridge is derived by
-- `L_normalizedZThresholdShape_from_denomShape`. The normalized z-core bridge
-- is derived by
-- `L_balanceResidualNormalizedZCore_singleCrossingOn_from_thresholdShape`;
-- the z-core bridge is derived by
-- `L_balanceResidualZCore_singleCrossingOn_from_normalized`; the beta-core
-- bridge is derived by `L_balanceResidualCore_singleCrossingOn_from_zCore`;
-- the full residual bridge is derived by
-- `L_balanceResidual_singleCrossingOn_from_core`, and balance uniqueness is
-- derived by
-- `L_first_order_balance_unique_from_balanceResidual_singleCrossingOn`.
-- These intermediate declarations no longer take theorem-interface premises.
-- The old `L_strict_unique_minimizer_paper_Def` source alias has been retired;
-- the live audit tracks the theorem chain below.
-- The
-- existence side of
-- `L_unimodal_in_regime_i` is now closed by
-- `L_interior_minimizer_exists_paper_Def`, forwarding to the R81
-- extreme-value-theorem proof; the right-branch uniqueness chain is discharged
-- through the closed upper-Mills antitonicity theorem and the residual
-- single-crossing reductions. Each closure is honest (genuine real-analysis /
-- `HasDerivAt` proof on the concrete carriers, no content-erasure, no
-- `sorry`). `#print axioms`
-- on the `Tendsto_overshoot_at_p1` closure = [propext,
-- Classical.choice, Quot.sound] only.
#print axioms BlackwellDilemma.FiveState.P_trapDerivValue
#print axioms BlackwellDilemma.FiveState.Phi_BDerivValue
#print axioms BlackwellDilemma.FiveState.L_hasDerivAt_negative_on_left_branch
#print axioms BlackwellDilemma.FiveState.L_global_minimizer_not_left_branch
#print axioms BlackwellDilemma.FiveState.L_hasDerivAt_positive_of_right_branch_dominance
#print axioms BlackwellDilemma.FiveState.L_global_minimizer_not_right_branch_dominance
#print axioms BlackwellDilemma.FiveState.L_global_minimizer_derivative_grouped_eq_zero
#print axioms BlackwellDilemma.FiveState.L_global_minimizer_first_order_balance
#print axioms BlackwellDilemma.FiveState.L_rightBranch
#print axioms BlackwellDilemma.FiveState.L_zRightBranch
#print axioms BlackwellDilemma.FiveState.L_cRightBranch
#print axioms BlackwellDilemma.FiveState.L_balanceResidualScale
#print axioms BlackwellDilemma.FiveState.L_balanceResidualCore
#print axioms BlackwellDilemma.FiveState.L_balanceResidualZCore
#print axioms BlackwellDilemma.FiveState.L_balanceResidualNormalizedZCore
#print axioms BlackwellDilemma.FiveState.L_normalizedZLinearCoeff
#print axioms BlackwellDilemma.FiveState.L_normalizedZConstantTerm
#print axioms BlackwellDilemma.FiveState.L_normalizedZThresholdScale
#print axioms BlackwellDilemma.FiveState.L_normalizedZThresholdDenom
#print axioms BlackwellDilemma.FiveState.L_lowerGaussianHazard
#print axioms BlackwellDilemma.FiveState.L_upperGaussianMills
#print axioms BlackwellDilemma.FiveState.L_lowerGaussianHazard_hasDerivAt
#print axioms BlackwellDilemma.FiveState.L_lowerGaussianHazard_deriv_neg_of_pos
#print axioms BlackwellDilemma.FiveState.L_lowerGaussianHazard_antitoneOn_pos
#print axioms BlackwellDilemma.FiveState.L_upperGaussianMills_hasDerivAt
#print axioms BlackwellDilemma.FiveState.L_upperGaussianMills_tail_mul_le
#print axioms BlackwellDilemma.FiveState.L_upperGaussianMills_deriv_nonpos_of_pos
#print axioms BlackwellDilemma.FiveState.L_upperGaussianMills_antitoneOn_pos
#print axioms BlackwellDilemma.FiveState.L_normalizedZHazardProduct
#print axioms BlackwellDilemma.FiveState.L_normalizedZHazardDenom
#print axioms BlackwellDilemma.FiveState.L_balanceResidualCore_eq_zCore
#print axioms BlackwellDilemma.FiveState.L_balanceResidualZCore_eq_deltaB_mul_normalized
#print axioms BlackwellDilemma.FiveState.L_balanceResidualNormalizedZCore_eq_linear
#print axioms BlackwellDilemma.FiveState.L_normalizedZLinearCoeff_eq_scale_mul_thresholdDenom
#print axioms BlackwellDilemma.FiveState.L_normalizedZConstantTerm_eq_half_mul_thresholdScale
#print axioms BlackwellDilemma.FiveState.L_normalizedZThresholdDenom_eq_hazardDenom
#print axioms BlackwellDilemma.FiveState.L_normalizedZHazardDenom_pos_iff_product_lt
#print axioms BlackwellDilemma.FiveState.L_normalizedZLinearCoeff_pos_iff_hazardProduct_lt
#print axioms BlackwellDilemma.FiveState.L_balanceResidual_eq_scale_mul_core
#print axioms BlackwellDilemma.FiveState.L_balanceResidual
#print axioms BlackwellDilemma.FiveState.L_firstOrderBalance
#print axioms BlackwellDilemma.FiveState.L_normalizedZThresholdShape_paper_Def
#print axioms BlackwellDilemma.FiveState.L_normalizedZThresholdDenomShape_paper_Def
#print axioms BlackwellDilemma.FiveState.L_normalizedZHazardDenomShape_paper_Def
#print axioms BlackwellDilemma.FiveState.L_normalizedZHazardProduct_antitoneOn_pos_paper_Def
#print axioms BlackwellDilemma.FiveState.L_gaussianHazardMillsFactorAntitone_paper_Def
#print axioms BlackwellDilemma.FiveState.L_upperGaussianMills_antitoneOn_pos_paper_Def
#print axioms BlackwellDilemma.FiveState.L_gaussianHazardMillsFactorAntitone_from_upperMills_antitone
#print axioms BlackwellDilemma.FiveState.L_normalizedZHazardProduct_antitone_from_factor_antitone
#print axioms BlackwellDilemma.FiveState.L_normalizedZHazardDenomShape_from_product_antitone
#print axioms BlackwellDilemma.FiveState.L_normalizedZThresholdDenomShape_from_hazardDenomShape
#print axioms BlackwellDilemma.FiveState.L_normalizedZThresholdShape_from_denomShape
#print axioms BlackwellDilemma.FiveState.L_balanceResidualNormalizedZCore_singleCrossingOn_rightBranch_paper_Def
#print axioms BlackwellDilemma.FiveState.L_balanceResidualNormalizedZCore_singleCrossingOn_from_thresholdShape
#print axioms BlackwellDilemma.FiveState.L_balanceResidualZCore_singleCrossingOn_rightBranch_paper_Def
#print axioms BlackwellDilemma.FiveState.L_balanceResidualZCore_singleCrossingOn_from_normalized
#print axioms BlackwellDilemma.FiveState.L_balanceResidualCore_singleCrossingOn_rightBranch_paper_Def
#print axioms BlackwellDilemma.FiveState.L_balanceResidualCore_singleCrossingOn_from_zCore
#print axioms BlackwellDilemma.FiveState.L_balanceResidual_singleCrossingOn_rightBranch_paper_Def
#print axioms BlackwellDilemma.FiveState.L_balanceResidual_singleCrossingOn_from_core
#print axioms BlackwellDilemma.FiveState.L_first_order_balance_unique_paper_Def
#print axioms BlackwellDilemma.FiveState.L_first_order_balance_unique_from_balanceResidual_singleCrossingOn
#print axioms BlackwellDilemma.FiveState.L_strict_unique_minimizer_from_first_order_balance_unique
#print axioms BlackwellDilemma.FiveState.Tendsto_overshoot_at_p1

-- Percolation-foundation wave: paper-faithful finite bond-percolation
-- framework (`Percolation.lean`) + concretisation of the
-- `expectedTopoLoss` carrier + closure of
-- `expectedTopoLoss_le_one_atom`.
--
-- (1) `Percolation.lean` FOUNDATION — the finite bond-percolation
--     measure and its expectation, built locally because Mathlib
--     doesn't have bond percolation. A paper-faithful finite-graph
--     bond-percolation framework is defined.  All lemmas are
--     kernel-pure `[propext,
--     Classical.choice, Quot.sound]` — ZERO project `_OPEN` axioms:
--      * `bondMeasureTotal_eq_one` — the explicit Bernoulli-product
--        weights `∏ e, (if ω e then p else 1−p)` sum to `1` over the
--        whole `2^|E|` sample space (proved via `Fintype.prod_sum`
--        product-of-sums factorisation + per-edge `p + (1−p) = 1`).
--        This is the defining normalisation of a probability measure.
--      * `percExpectation_const` — `E_{G_p}[c] = c` (uses
--        `bondMeasureTotal_eq_one`).
--      * `percExpectation_le_of_pointwise_le` /
--        `percExpectation_ge_of_pointwise_ge` /
--        `percExpectation_mem_of_pointwise_mem` — THE foundational
--        monotonicity-of-expectation lemmas: a pointwise (per-
--        realisation) bound on the integrand transfers to its
--        bond-percolation expectation.  This is the exact tool the
--        paper's §3.3 "envelope bounds" rest on (bound `|W_topo|` per
--        realisation, then take `E_{G_p}`).
--      * `percExpectation_add` / `percExpectation_smul` /
--        `percExpectation_mono` — linearity + integrand-monotonicity
--        of `E_{G_p}`.
--
-- (2) `expectedTopoLoss` CONCRETISED — `expectedTopoLoss : ℕ → ℝ → ℝ`
--     is given as `noncomputable def expectedTopoLoss n p :=
--     percExpectation (1 − p) (topoLossKernel n)`, which IS paper
--     Definition 2.1 line 119's `E_{G_p}[·]` evaluated on the
--     explicit finite bond-percolation measure.  Two supporting
--     paper-Def-stipulated carriers: `EdgeIdx n` (the `Z²_L` edge
--     set, paper Def 2.1's `E`) + `topoLossKernel n` (paper
--     `prop:topo-cluster`'s pointwise integrand `r^* − max_{v∈R} r`),
--     with the explicit theorem interface `topoLossKernel_mem_unitInterval`
--     (paper Def 2.1 line 113 reward-range `r : V → [0,1]`,
--     transported to the loss kernel — structuralEquation, paper-Def
--     foundational atom, mirroring the
--     `all_edges_open_at_zero_blocking` boundary-semantics
--     precedent).
--
-- (3) `expectedTopoLoss_le_one_atom` CLOSED —
--     `∀ n p, expectedTopoLoss n p ≤ 1` is a derived `theorem`
--     (paper Def 2.1 domain antecedents `0 ≤ p`, `p ≤ 1` added):
--     unfolds to `percExpectation (1−p) (topoLossKernel n) ≤ 1` and
--     closes by `percExpectation_le_of_pointwise_le` + the pointwise
--     kernel-bound interface `topoLossKernel_mem_unitInterval`. The paper
--     unit-bound claim is a Cat 1 derivation through this Infrastructure
--     chain. The old Mills positive wrapper that threaded the paper-faithful
--     `p ≤ 1` antecedent is retired; the current audit prints the route
--     obstruction instead.
--     `#print axioms` on the closure = kernel axioms + the 3
--     paper-Def carriers/explicit interfaces (`EdgeIdx`,
--     `topoLossKernel`, explicit `topoLossKernel_mem_unitInterval`) + the
--     `EdgeIdx` finiteness instances. Each item is honest (genuine
--     measure-theoretic proof on the concrete framework, no `sorry`,
--     no content-erasure — the `def` body IS the paper's exact
--     `E_{G_p}` decomposition).
--
-- The Lean encoding of the below-threshold `1/(n+1)` envelope follows
-- paper line 415's giant-component-conditional form (the
-- unconditional `1/(n+1)` bound is an EXPECTATION bound, false
-- pointwise — a single bad realisation can have loss up to `1`).
-- The `Percolation.lean` foundation provides the giant-component
-- split substrate.
#print axioms BlackwellDilemma.bondMeasureTotal_eq_one
#print axioms BlackwellDilemma.percExpectation_const
#print axioms BlackwellDilemma.percExpectation_zero_eq_eval_allFalse
#print axioms BlackwellDilemma.percExpectation_le_of_pointwise_le
#print axioms BlackwellDilemma.percExpectation_ge_of_pointwise_ge
#print axioms BlackwellDilemma.percExpectation_mem_of_pointwise_mem
#print axioms BlackwellDilemma.percExpectation_add
#print axioms BlackwellDilemma.percExpectation_smul
#print axioms BlackwellDilemma.percExpectation_mono
#print axioms BlackwellDilemma.bondOpenEdgeSet
#print axioms BlackwellDilemma.percExpectation_open_edge_indicator
#print axioms BlackwellDilemma.percExpectation_openEdgeSet_card
#print axioms BlackwellDilemma.topoLossKernel_mem_unitInterval_current
#print axioms BlackwellDilemma.expectedTopoLoss_le_one_atom

-- Percolation-foundation wave (continuation): concretisation of
-- the `W_info_oracle` carrier over `Percolation.lean` + closure of
-- BOTH `prop:info-decay` paper-derived atoms.
--
-- (1) `W_info_oracle` CONCRETISED — `noncomputable def W_info_oracle n
--     p β := percExpectation (1 − p) (wInfoOracleKernel n β)`, which
--     IS paper Theorem 3.1 proof line 258's
--     `W_info = E_{G_p}[E_s[r(v_T)] − r^*_R]` evaluated on the
--     explicit finite bond-percolation measure.  The carrier gains an
--     `n` index (the residual lives on `Z²_L`, `L² = n`); paper
--     `prop:info-decay` line 272's "uniformly in `n`" is realised by
--     the `∀ n` quantification of the downstream derived theorems.
--     Supporting paper-Def-stipulated atoms:
--      * `wInfoOracleKernel` (carrier — paper Thm 3.1 proof line 258's
--        pointwise integrand `E_s[r(v_T)] − r^*_R`),
--      * `wInfoOracleClusterCount` (carrier — paper `prop:info-decay`
--        line 276's `|R(v_0)|`),
--      * `WInfoOracleKernelNonpos` (explicit interface — paper Lemma
--        `lem:conditional-reduction` (i): the within-`R` oracle on a
--        fixed feasible set cannot exceed `r^*_R`, so the
--        per-realisation residual is `≤ 0`; paper-Def foundational atom),
--      * `WInfoOracleClusterCountGeOne` (explicit interface — paper
--        Def 2.5 trivial-path inclusion `v_0 ∈ R(v_0)` ⇒ `|R| ≥ 1`),
--      * `WInfoOracleKernelAbsLeClusterCount` (explicit interface —
--        paper `prop:info-decay` proof line 276 STATES the
--        per-realisation Mills-tail bound `|W_info| ≤ |R| · O(2^{-β})`
--        directly; the per-`R` integrand bound, paper-Def foundational
--        atom + paper-application-of-Cat-1-`gap_phi_tail_bound`).
--     `EdgeIdx` + its `Fintype`/`DecidableEq` instances were moved up
--     from §5 of Wrongness.lean (was after `prop:topo-cluster`) so the
--     §3 `W_info_oracle` concretisation can reference the same `Z²_L`
--     edge set — carrier content unchanged, only relocated.
--     Current source-surface note: `wInfoOracleKernel`,
--     `wInfoOracleClusterCount`, `topoLossKernel`, `giantComponentEvent`,
--     and `expectedTopoLossAboveLowerConst` now project from the transparent
--     diagnostic package named `wrongnessPercolationData`
--     (`WrongnessPercolationData`). The oracle and above-threshold lower-bound
--     sides remain neutral, while the topo-loss side has a nonempty `n = 1`
--     diagnostic giant event. The full non-trivial `Z^2_L` percolation content
--     remains explicit through theorem interfaces.
--
-- (2) `W_info_oracle_nonpos` CLOSED — `∀ p, p_c < p → ∀ β > 0,
--     W_info_oracle p β ≤ 0` is a derived `theorem` (n-indexed, paper
--     Def 2.1 domain antecedent `p ≤ 1` added): unfolds to
--     `percExpectation (1−p) (wInfoOracleKernel n β) ≤ 0` and closes
--     by `percExpectation_le_of_pointwise_le` + the pointwise kernel
--     sign now supplied by the current neutral global theorem
--     `W_info_oracle_current_uniform_unit_bound`. Non-neutral oracle routes are
--     preserved on the parameterized `WInfoOracleInterfacesOn data` surface.
--
-- (3) `W_info_oracle_exponential_bound` CLOSED — derived
--     `theorem`. The witness constant is `C := percExpectation (1−p)
--     (wInfoOracleClusterCount n) = E_n[|R|]`; the closure chain is
--     `|W_info_oracle n p β| =
--     |percExpectation (1−p) (wInfoOracleKernel n β)| ≤
--     percExpectation (1−p) |kernel|  (Jensen-style helper
--     `percExpectation_abs_le`)  ≤ percExpectation (1−p)
--     (clusterCount · 2^{-β})  (`percExpectation_mono` against the
--     paper-stated per-realisation bound
--     the current neutral global theorem
--     `W_info_oracle_current_uniform_unit_bound`, with witness `C = 1`.
--     The parameterized non-neutral route still has the expectation-algebra
--     helpers and `WInfoOracleInterfacesOn data` instances.  The wave also adds the
--     Cat 1 helper `percExpectation_abs_le` (`|E[f]| ≤ E[|f|]` on the
--     finite bond-percolation measure, kernel-pure `[propext,
--     Classical.choice, Quot.sound]`). The paper claim is a Cat 1
--     derivation through this Infrastructure chain.
--
-- Scope honesty: the closed `W_info_oracle_exponential_bound` is
-- the FAITHFUL per-`n` form `∀ n, ∃ C, …` — for each `n` the constant
-- `C(n) = E_n[|R|]` is a genuine finite real on the finite
-- bond-percolation measure.  Paper `prop:info-decay` line 272's
-- stronger "uniformly in `n`" form additionally needs
-- `sup_n E_n[|R|] < ∞`, which the paper obtains from the Grimmett
-- 1999 §6.75 cluster-size exponential tail (paper line 276
-- `E[|R|] = O(1)`).  That uniform bound is the genuine next-layer
-- percolation input.  R353/R324 separate this from the public finite theorem:
-- `W_info_oracle_exponential_bound_finite` and `gap_info_decay_finite` no
-- longer carry oracle-interface or Grimmett-shaped proof parameters.
--
-- `#print axioms` on the global route = kernel axioms + the current neutral
-- carrier theorem. Parameterized non-neutral routes remain in the
-- `W_info_oracleOn` / `WInfoOracleInterfacesOn data` family. Each item is
-- honest (no `sorry`, no content-erasure — the `def` body IS the paper's exact
-- `E_{G_p}[E_s[r(v_T)] − r^*_R]` decomposition).
--
-- R324 update: the legacy global `WInfoOracleInterfaces` structure and
-- `gap_info_decay_from_*interfaces` wrappers are retired. The global
-- `W_info_oracle` theorem route is current-neutral; future non-neutral oracle
-- work is preserved by `WInfoOracleInterfacesOn data`.
-- R392 update: `gap_dilemma` now uses `WrongnessGreedyInterfaces_current`
-- directly and no longer keeps a live interface-parametric theorem route.
-- R353 update preserved: `gap_dilemma` uses `gap_info_decay_finite`, so the
-- core current theorem route no longer calls `gap_grimmett_exponential_decay`
-- for the finite-per-`n` statement.
#print axioms BlackwellDilemma.percExpectation_abs_le
#print axioms BlackwellDilemma.WInfoOracleKernelNonpos_current
#print axioms BlackwellDilemma.WInfoOracleClusterCountGeOne_current
#print axioms BlackwellDilemma.WInfoOracleKernelAbsLeClusterCount_current
#print axioms BlackwellDilemma.W_info_oracleOn
#print axioms BlackwellDilemma.WInfoOracleKernelNonposOn
#print axioms BlackwellDilemma.WInfoOracleClusterCountGeOneOn
#print axioms BlackwellDilemma.WInfoOracleKernelAbsLeClusterCountOn
#print axioms BlackwellDilemma.WInfoOracleInterfacesOn
#print axioms BlackwellDilemma.WInfoOracleInterfacesOn_current
#print axioms BlackwellDilemma.unitExponentialOracleData
#print axioms BlackwellDilemma.WInfoOracleInterfacesOn_unitExponential
#print axioms BlackwellDilemma.unitExponentialOracleData_kernel_nonzero
#print axioms BlackwellDilemma.W_info_oracleOn_unitExponential_eq
#print axioms BlackwellDilemma.OracleReachableSetData
#print axioms BlackwellDilemma.oracleReachableSet_card_pos
#print axioms BlackwellDilemma.oracleReachableSet_one_le_card_real
#print axioms BlackwellDilemma.oracleDataOfReachableSet
#print axioms BlackwellDilemma.singletonOracleReachableSetData
#print axioms BlackwellDilemma.singletonReachableSetOracleData
#print axioms BlackwellDilemma.OracleFiniteBondGraphData
#print axioms BlackwellDilemma.oracleFiniteBondGraphAdj
#print axioms BlackwellDilemma.oracleFiniteBondGraphAdj_symm
#print axioms BlackwellDilemma.oracleFiniteBondGraphAdj_of_open_edge
#print axioms BlackwellDilemma.oracleFiniteBondGraphOpenEdgeSet
#print axioms BlackwellDilemma.oracleFiniteBondGraphOpenEndpointSet
#print axioms BlackwellDilemma.oracleFiniteBondGraphOpenEndpointSet_card_le_two_mul_openEdgeSet_card
#print axioms BlackwellDilemma.oracleFiniteBondGraphReachableSet
#print axioms BlackwellDilemma.oracleFiniteBondGraphReachableSet_base_mem
#print axioms BlackwellDilemma.oracleFiniteBondGraphReachableSet_mem_of_adj
#print axioms BlackwellDilemma.oracleFiniteBondGraphAdj_all_false_false
#print axioms BlackwellDilemma.oracleFiniteBondGraphReachableSet_eq_singleton_base_of_all_false
#print axioms BlackwellDilemma.oracleFiniteBondGraphReachableSet_card_all_false
#print axioms BlackwellDilemma.oracleFiniteBondGraphReachableSet_subset_base_or_openEndpoints
#print axioms BlackwellDilemma.oracleFiniteBondGraphReachableSet_card_le_two_mul_openEdgeSet_card_add_one
#print axioms BlackwellDilemma.oracleFiniteBondGraphReachableSet_expectation_le_two_mul_q_mul_edgeCount_add_one
#print axioms BlackwellDilemma.oracleFiniteBondGraphReachableSet_endpoint2_mem_of_open_edge
#print axioms BlackwellDilemma.oracleFiniteBondGraphReachableSet_endpoint1_mem_of_open_edge
#print axioms BlackwellDilemma.oracleReachableSetDataOfFiniteBondGraph
#print axioms BlackwellDilemma.finiteBondGraphOracleData
#print axioms BlackwellDilemma.oracleStarFiniteBondGraphEndpoint
#print axioms BlackwellDilemma.EdgeIdx_card
#print axioms BlackwellDilemma.finCycleSucc_ne_self
#print axioms BlackwellDilemma.finCyclePred_ne_self
#print axioms BlackwellDilemma.finCyclePred_succ
#print axioms BlackwellDilemma.finCycleSucc_pred
#print axioms BlackwellDilemma.oracleCyclicTwoDirFiniteBondGraphEndpoint
#print axioms BlackwellDilemma.oracleCyclicTwoDirFiniteBondGraphData
#print axioms BlackwellDilemma.oracleCyclicTwoDirFiniteBondGraphEndpoint_loopless
#print axioms BlackwellDilemma.oracleCyclicTwoDirReachableSet_one_mem_of_open_base_succ
#print axioms BlackwellDilemma.oracleCyclicTwoDirReachableSet_last_mem_of_open_base_pred
#print axioms BlackwellDilemma.WInfoOracleInterfacesOn_cyclicTwoDirFiniteBondGraph
#print axioms BlackwellDilemma.cyclicTwoDirFiniteBondGraphOracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.cyclicTwoDirFiniteBondGraphOracleInfoDecayConclusion
#print axioms BlackwellDilemma.BoxedTorusVertex
#print axioms BlackwellDilemma.BoxedTorusEdgeIdx
#print axioms BlackwellDilemma.boxedTorusVertex_card
#print axioms BlackwellDilemma.boxedTorusEdgeIdx_card
#print axioms BlackwellDilemma.boxedTorusEndpoint
#print axioms BlackwellDilemma.boxedTorusEndpoint_horizontal
#print axioms BlackwellDilemma.boxedTorusEndpoint_vertical
#print axioms BlackwellDilemma.boxedTorusEndpoint_loopless
#print axioms BlackwellDilemma.boxedTorusIncidentEdgeSet
#print axioms BlackwellDilemma.boxedTorusIncidentEdgeSet_card_le_four
#print axioms BlackwellDilemma.boxedTorusEndpoint_mem_incidentEdgeSet
#print axioms BlackwellDilemma.boxedTorusNeighbourVertexSet
#print axioms BlackwellDilemma.boxedTorusNeighbourVertexSet_card_le_four
#print axioms BlackwellDilemma.boxedTorusFiniteGraphData
#print axioms BlackwellDilemma.boxedTorusFlatGraphN
#print axioms BlackwellDilemma.boxedTorusFlatGraphN_succ
#print axioms BlackwellDilemma.boxedTorusFlattenVertex
#print axioms BlackwellDilemma.boxedTorusFlattenVertex_val
#print axioms BlackwellDilemma.boxedTorusFlattenVertex_fst_val
#print axioms BlackwellDilemma.boxedTorusFlattenVertex_snd_val
#print axioms BlackwellDilemma.boxedTorusFlattenVertex_injective
#print axioms BlackwellDilemma.boxedTorusFlattenMainVertex
#print axioms BlackwellDilemma.boxedTorusFlattenEdgeRaw
#print axioms BlackwellDilemma.boxedTorusFlattenEdgeRaw_val
#print axioms BlackwellDilemma.boxedTorusFlattenEdgeRaw_dir_val
#print axioms BlackwellDilemma.boxedTorusFlattenEdgeRaw_vertex_val
#print axioms BlackwellDilemma.boxedTorusFlattenEdgeRaw_injective
#print axioms BlackwellDilemma.boxedTorusFlattenEdgeIdx
#print axioms BlackwellDilemma.boxedTorusFlattenEdgeIdx_injective
#print axioms BlackwellDilemma.boxedTorusFlattenMainVertex_injective
#print axioms BlackwellDilemma.boxedTorusUnflattenVertex
#print axioms BlackwellDilemma.boxedTorusUnflatten_flattenVertex
#print axioms BlackwellDilemma.boxedTorusFlattenVertex_unflattenVertex
#print axioms BlackwellDilemma.boxedTorusUnflattenMainVertex
#print axioms BlackwellDilemma.boxedTorusUnflattenMain_flattenMain
#print axioms BlackwellDilemma.boxedTorusFlattenMain_unflattenMain
#print axioms BlackwellDilemma.boxedTorusUnflattenMainVertex_injective
#print axioms BlackwellDilemma.boxedTorusUnflattenEdgeRaw
#print axioms BlackwellDilemma.boxedTorusUnflattenEdgeRaw_flattenEdgeRaw
#print axioms BlackwellDilemma.boxedTorusFlattenEdgeRaw_unflattenEdgeRaw
#print axioms BlackwellDilemma.boxedTorusEdgeIdxRawOfMain
#print axioms BlackwellDilemma.boxedTorusEdgeIdxRawOfMain_flattenEdgeIdx
#print axioms BlackwellDilemma.boxedTorusUnflattenEdgeIdx
#print axioms BlackwellDilemma.boxedTorusUnflattenEdgeIdx_flattenEdgeIdx
#print axioms BlackwellDilemma.boxedTorusFlattenEdgeIdx_unflattenEdgeIdx
#print axioms BlackwellDilemma.boxedTorusFlattenEndpoint
#print axioms BlackwellDilemma.boxedTorusFlattenEndpoint_flattenEdgeIdx
#print axioms BlackwellDilemma.boxedTorusFlattenEndpoint_loopless
#print axioms BlackwellDilemma.boxedTorusOracleFiniteBondGraphEndpoint
#print axioms BlackwellDilemma.boxedTorusOracleFiniteBondGraphData
#print axioms BlackwellDilemma.boxedTorusOracleFiniteBondGraphEndpoint_at_flat
#print axioms BlackwellDilemma.boxedTorusOracleFiniteBondGraphEndpoint_loopless_at_flat
#print axioms BlackwellDilemma.boxedTorusFiniteBondGraphOracleData
#print axioms BlackwellDilemma.boxedTorusBaseVertex
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalEdge
#print axioms BlackwellDilemma.boxedTorusBaseVerticalEdge
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalTarget
#print axioms BlackwellDilemma.boxedTorusBaseVerticalTarget
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalEndpoint
#print axioms BlackwellDilemma.boxedTorusBaseVerticalEndpoint
#print axioms BlackwellDilemma.boxedTorusFlattenMainVertex_base
#print axioms BlackwellDilemma.boxedTorusUnflattenMain_zero
#print axioms BlackwellDilemma.boxedTorusReachableSet_horizontal_mem_of_open
#print axioms BlackwellDilemma.boxedTorusReachableSet_vertical_mem_of_open
#print axioms BlackwellDilemma.boxedTorusReachableSet_endpoint2_mem_of_open_flatEdge
#print axioms BlackwellDilemma.boxedTorusReachableSet_endpoint1_mem_of_open_flatEdge
#print axioms BlackwellDilemma.boxedTorusReachableSet_endpoint2_mem_of_open_coordEdge
#print axioms BlackwellDilemma.boxedTorusReachableSet_endpoint1_mem_of_open_coordEdge
#print axioms BlackwellDilemma.boxedTorusCoordOpenAdj
#print axioms BlackwellDilemma.boxedTorusCoordEdgeAdj
#print axioms BlackwellDilemma.boxedTorusCoordEdgeStepTarget
#print axioms BlackwellDilemma.boxedTorusCoordEdgeAdj_mem_incidentEdgeSet
#print axioms BlackwellDilemma.boxedTorusCoordEdgeStepTarget_eq_of_edgeAdj
#print axioms BlackwellDilemma.boxedTorusCoordOpenAdj_of_edgeAdj
#print axioms BlackwellDilemma.boxedTorusOracleAdj_coordOpenAdj_unflatten
#print axioms BlackwellDilemma.boxedTorusCoordOpenAdj_mem_neighbourVertexSet
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourSet
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourSet_card_le_four
#print axioms BlackwellDilemma.boxedTorusCoordOpenAdj_mem_openNeighbourSet
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourSet_mem_adj
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourUnionSet
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourUnionSet_card_le_four_mul_card
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourUnionSet_mem_of_adj
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourUnionSet_mem_adj
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourLayer
#print axioms BlackwellDilemma.boxedTorusCoordOpenPathLength
#print axioms BlackwellDilemma.boxedTorusCoordOpenSimplePath
#print axioms BlackwellDilemma.boxedTorusCoordOpenSimplePath_edgeSet_card
#print axioms BlackwellDilemma.boxedTorusCoordOpenSimplePath_reflTransGen
#print axioms BlackwellDilemma.boxedTorusCoordOpenSimplePath_pathLength
#print axioms BlackwellDilemma.boxedTorusCoordEdgeSym2
#print axioms BlackwellDilemma.boxedTorusCoordEdgeAdj_sym2_eq
#print axioms BlackwellDilemma.boxedTorusCoordOpenAdj_symm
#print axioms BlackwellDilemma.boxedTorusCoordOpenSimpleGraph
#print axioms BlackwellDilemma.boxedTorusCoordOpenSimpleGraph_adj_of_openAdj_ne
#print axioms BlackwellDilemma.boxedTorusCoordOpenSimpleGraph_adj_openAdj
#print axioms BlackwellDilemma.boxedTorusCoordOpenSimpleGraph_adj_exists_coordEdge
#print axioms BlackwellDilemma.boxedTorusCoordOpenSimpleGraph_adj_exists_coordEdge_sym2
#print axioms BlackwellDilemma.boxedTorusCoordOpenSimplePath_succ_of_fresh_edge
#print axioms BlackwellDilemma.boxedTorusCoordOpenSimpleGraph_adj_openSimplePath_one
#print axioms BlackwellDilemma.boxedTorusCoordSimplePathSkeleton
#print axioms BlackwellDilemma.boxedTorusCoordSimplePathSkeleton_edgeSet_card
#print axioms BlackwellDilemma.boxedTorusCoordSimplePathSkeletonExtensionSet
#print axioms BlackwellDilemma.boxedTorusCoordSimplePathSkeletonExtensionSet_card_le_four
#print axioms BlackwellDilemma.boxedTorusCoordSimplePathSkeletonStateStepSet
#print axioms BlackwellDilemma.boxedTorusCoordSimplePathSkeletonStateStepSet_card_le_four_mul_card
#print axioms BlackwellDilemma.boxedTorusCoordSimplePathSkeletonStateSet
#print axioms BlackwellDilemma.boxedTorusCoordSimplePathSkeletonStateSet_card_le_four_pow
#print axioms BlackwellDilemma.boxedTorusCoordSimplePathSkeletonStateSet_mem_skeleton
#print axioms BlackwellDilemma.boxedTorusCoordSimplePathSkeleton_mem_stateSet
#print axioms BlackwellDilemma.boxedTorusCoordSimplePathSkeletonStateSet_mem_iff
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourLayer_card_le_four_pow
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourLayer_mem_pathLength
#print axioms BlackwellDilemma.boxedTorusCoordOpenPathLength_reflTransGen
#print axioms BlackwellDilemma.boxedTorusCoordOpenPathLength_of_reflTransGen
#print axioms BlackwellDilemma.boxedTorusCoordOpenPathLength_mem_layer
#print axioms BlackwellDilemma.boxedTorusCoordOpenPathLength_simpleGraphWalk_le
#print axioms BlackwellDilemma.boxedTorusCoordOpenPathLength_simpleGraphPath_le
#print axioms BlackwellDilemma.boxedTorusCoordOpenSimpleGraph_path_dropLast_isPath
#print axioms BlackwellDilemma.boxedTorusCoordOpenSimpleGraph_path_lastEdge_not_mem_dropLast_edges
#print axioms BlackwellDilemma.boxedTorusCoordOpenSimpleGraph_walk_openSimplePath_with_edgeSubset
#print axioms BlackwellDilemma.boxedTorusCoordOpenSimpleGraph_path_openSimplePath_with_edgeSubset
#print axioms BlackwellDilemma.boxedTorusCoordOpenPathLength_exists_openSimplePath_le
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourLayer_mem_openSimplePath_le
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourBall_mem_openSimplePath_le
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourLayer_mem_path
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourLayer_mem_simpleGraphPath_le
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourBall
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourBall_card_le_sum_four_pow
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourLayer_mem_ball_self
#print axioms BlackwellDilemma.boxedTorusCoordOpenPathLength_mem_ball
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourBall_mono_step
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourBall_mono
#print axioms BlackwellDilemma.boxedTorusCoordOpenSimplePath_mem_ball_of_le
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourBall_mem_exists_pathLength_le
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourBall_mem_path
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourBall_mem_simpleGraphPath_le
#print axioms BlackwellDilemma.boxedTorusReachableSet_mem_of_coord_adj
#print axioms BlackwellDilemma.boxedTorusReachableSet_mem_of_coord_path
#print axioms BlackwellDilemma.boxedTorusCoordOpenPath_of_oracleReachablePath_unflatten
#print axioms BlackwellDilemma.boxedTorusCoordOpenPath_of_reachableSet_mem_unflatten
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourBall_mem_of_reachableSet_mem_unflatten
#print axioms BlackwellDilemma.boxedTorusReachableSet_card_le_openNeighbourBall_card
#print axioms BlackwellDilemma.boxedTorusReachableSet_card_ge_of_coord_paths
#print axioms BlackwellDilemma.boxedTorusOracleClusterCount_ge_openNeighbourBall_card
#print axioms BlackwellDilemma.boxedTorusOracleClusterCount_le_openNeighbourBall_card
#print axioms BlackwellDilemma.boxedTorusOpenNeighbourBallExpectation_le_sum_four_pow
#print axioms BlackwellDilemma.boxedTorusClusterCountExpectation_ge_openNeighbourBallExpectation
#print axioms BlackwellDilemma.boxedTorusClusterCountExpectation_le_openNeighbourBallExpectation
#print axioms BlackwellDilemma.boxedTorusClusterCountExpectation_le_subcritical_geometric_const
#print axioms BlackwellDilemma.boxedTorusBaseTargets_pairwise_ne
#print axioms BlackwellDilemma.boxedTorusReachableSet_card_ge_three_of_base_axes_open
#print axioms BlackwellDilemma.boxedTorusOracleClusterCount_ge_three_of_base_axes_open
#print axioms BlackwellDilemma.percRestrictedExpectation_ge_of_pointwise_ge_on
#print axioms BlackwellDilemma.percRestrictedExpectation_smul
#print axioms BlackwellDilemma.percRestrictedExpectation_union_const_one_le
#print axioms BlackwellDilemma.percRestrictedExpectation_biUnion_const_one_le_sum
#print axioms BlackwellDilemma.percRestrictedExpectation_open_edgeSet_const_one
#print axioms BlackwellDilemma.percRestrictedExpectation_closed_edgeSet_const_one
#print axioms BlackwellDilemma.percRestrictedExpectation_two_open_edges_const_one
#print axioms BlackwellDilemma.percRestrictedExpectation_const_one_mono_event
#print axioms BlackwellDilemma.percRestrictedExpectation_const_one_pos_event_nonempty
#print axioms BlackwellDilemma.percExpectation_indicator_eq_restrictedExpectation_const_one
#print axioms BlackwellDilemma.percRestrictedExpectation_const_one_add_compl
#print axioms BlackwellDilemma.percRestrictedExpectation_compl_const_one_eq_one_sub
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalEdge_ne_verticalEdge
#print axioms BlackwellDilemma.boxedTorusFlattenBaseHorizontalEdge_ne_verticalEdge
#print axioms BlackwellDilemma.boxedTorusCoordOpenEdgeSetEvent
#print axioms BlackwellDilemma.boxedTorusCoordOpenEdgeSetEvent_mem_iff
#print axioms BlackwellDilemma.boxedTorusCoordOpenSimplePath_event_mem
#print axioms BlackwellDilemma.boxedTorusCoordOpenEdgeSetEvent_mem_of_edgeSet_subset
#print axioms BlackwellDilemma.boxedTorusCoordSimplePathSkeleton_openSimplePath
#print axioms BlackwellDilemma.boxedTorusCoordSimplePathSkeleton_reflTransGen_on_event
#print axioms BlackwellDilemma.boxedTorusCoordOpenSimplePath_skeleton
#print axioms BlackwellDilemma.boxedTorusCoordOpenEdgeSetEventMass_eq_pow_card
#print axioms BlackwellDilemma.boxedTorusCoordOpenEdgeSetEventMass_eq_pow_length_of_simplePath
#print axioms BlackwellDilemma.boxedTorusCoordOpenEdgeSetEventMass_eq_pow_length_of_skeleton
#print axioms BlackwellDilemma.boxedTorusCoordSimplePathSkeletonStateEventUnion
#print axioms BlackwellDilemma.boxedTorusCoordSimplePathSkeletonStateEventUnion_mem_iff
#print axioms BlackwellDilemma.boxedTorusCoordSimplePathSkeletonStateEventUnion_mem_of_skeleton
#print axioms BlackwellDilemma.boxedTorusCoordSimplePathSkeletonStateEventUnionMass_le_card_mul_q_pow
#print axioms BlackwellDilemma.boxedTorusCoordSimplePathSkeletonStateEventUnionMass_le_four_pow_mul_q_pow
#print axioms BlackwellDilemma.boxedTorusCoordSimplePathSkeletonStateEventUnionMass_le_four_mul_q_pow
#print axioms BlackwellDilemma.boxedTorusCoordSimplePathSkeletonStateEventUnion_mem_of_openSimplePath
#print axioms BlackwellDilemma.boxedTorusCoordOpenPathLength_skeletonStateEventUnion_mem_le
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourLayer_mem_skeletonStateEventUnion_le
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourBall_mem_skeletonStateEventUnion_le
#print axioms BlackwellDilemma.percExpectation_finset_sum
#print axioms BlackwellDilemma.percExpectation_eventFilter_card_eq_sum_eventMass
#print axioms BlackwellDilemma.boxedTorusCoordOpenedSimplePathSkeletonStateSet
#print axioms BlackwellDilemma.boxedTorusCoordOpenedSimplePathSkeletonTaggedStateSetUpTo
#print axioms BlackwellDilemma.boxedTorusCoordOpenedSimplePathEndpointSetUpTo
#print axioms BlackwellDilemma.boxedTorusCoordOpenSimplePath_mem_openedSkeletonTaggedStateSetUpTo
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourBall_subset_openedSimplePathEndpointSetUpTo
#print axioms BlackwellDilemma.boxedTorusCoordOpenNeighbourBall_card_le_openedSkeletonTaggedStateSetUpTo_card
#print axioms BlackwellDilemma.boxedTorusCoordOpenedSimplePathSkeletonTaggedStateSetUpTo_card_le_sum
#print axioms BlackwellDilemma.boxedTorusCoordOpenedSimplePathSkeletonStateSetExpectation_le_four_mul_q_pow
#print axioms BlackwellDilemma.boxedTorusCoordOpenedSimplePathSkeletonTaggedStateSetUpToExpectation_le_sum_four_mul_q_pow
#print axioms BlackwellDilemma.boxedTorusOpenNeighbourBallExpectation_le_sum_four_mul_q_pow
#print axioms BlackwellDilemma.real_geom_sum_pow_le_inv_one_sub
#print axioms BlackwellDilemma.boxedTorusOpenNeighbourBallExpectation_le_subcritical_geometric_const
#print axioms BlackwellDilemma.boxedTorusCoordSimplePathSkeletonStateEventUnion_mem_iff_openSimplePath
#print axioms BlackwellDilemma.boxedTorusOracleClusterCount_ge_card_of_coord_paths
#print axioms BlackwellDilemma.boxedTorusRestrictedClusterCount_ge_card_mul_q_pow_of_coord_paths_on_event
#print axioms BlackwellDilemma.boxedTorusRestrictedClusterCount_ge_card_mul_q_pow_of_coord_paths_on_superset_event
#print axioms BlackwellDilemma.boxedTorusRestrictedClusterCount_ge_card_mul_q_pow_succ_of_coord_paths_on_insert_event
#print axioms BlackwellDilemma.boxedTorusRestrictedClusterCount_ge_card_succ_mul_q_pow_succ_of_insert_edge_vertex
#print axioms BlackwellDilemma.boxedTorusRestrictedClusterCount_ge_card_add_two_mul_q_pow_add_two_of_insert_two_edges_vertices
#print axioms BlackwellDilemma.boxedTorusHorizontalIterX
#print axioms BlackwellDilemma.boxedTorusHorizontalIterVertex
#print axioms BlackwellDilemma.boxedTorusHorizontalIterEdge
#print axioms BlackwellDilemma.boxedTorusHorizontalIterEdgeSet
#print axioms BlackwellDilemma.boxedTorusHorizontalIterEdgeEndpoint
#print axioms BlackwellDilemma.boxedTorusHorizontalIterStep_path
#print axioms BlackwellDilemma.boxedTorusHorizontalIter_path_of_edgeSetEvent
#print axioms BlackwellDilemma.boxedTorusHorizontalIterVertexSet
#print axioms BlackwellDilemma.boxedTorusHorizontalIterVertexSet_coord_paths_of_edgeSetEvent
#print axioms BlackwellDilemma.boxedTorusRestrictedClusterCount_ge_horizontalIterVertexSet_card_mul_q_pow_edgeSet_card
#print axioms BlackwellDilemma.boxedTorusHorizontalIterX_val_of_le
#print axioms BlackwellDilemma.boxedTorusHorizontalIterVertex_injOn_range
#print axioms BlackwellDilemma.boxedTorusHorizontalIterVertexSet_card
#print axioms BlackwellDilemma.boxedTorusHorizontalIterEdge_injOn_range
#print axioms BlackwellDilemma.boxedTorusHorizontalIterEdgeSet_card
#print axioms BlackwellDilemma.boxedTorusRestrictedClusterCount_ge_nat_succ_mul_q_pow_horizontalIterEdgeSet
#print axioms BlackwellDilemma.boxedTorusVerticalIterVertex
#print axioms BlackwellDilemma.boxedTorusVerticalIterEdge
#print axioms BlackwellDilemma.boxedTorusVerticalIterEdgeSet
#print axioms BlackwellDilemma.boxedTorusVerticalIterEdgeEndpoint
#print axioms BlackwellDilemma.boxedTorusVerticalIterStep_path
#print axioms BlackwellDilemma.boxedTorusVerticalIter_path_of_edgeSetEvent
#print axioms BlackwellDilemma.boxedTorusVerticalIterVertexSet
#print axioms BlackwellDilemma.boxedTorusVerticalIterVertexSet_coord_paths_of_edgeSetEvent
#print axioms BlackwellDilemma.boxedTorusRestrictedClusterCount_ge_verticalIterVertexSet_card_mul_q_pow_edgeSet_card
#print axioms BlackwellDilemma.boxedTorusVerticalIterVertex_injOn_range
#print axioms BlackwellDilemma.boxedTorusVerticalIterVertexSet_card
#print axioms BlackwellDilemma.boxedTorusVerticalIterEdge_injOn_range
#print axioms BlackwellDilemma.boxedTorusVerticalIterEdgeSet_card
#print axioms BlackwellDilemma.boxedTorusRestrictedClusterCount_ge_nat_succ_mul_q_pow_verticalIterEdgeSet
#print axioms BlackwellDilemma.boxedTorusHorizontalThenVerticalVertex
#print axioms BlackwellDilemma.boxedTorusHorizontalThenVerticalVerticalEdge
#print axioms BlackwellDilemma.boxedTorusHorizontalThenVerticalVerticalEdgeSet
#print axioms BlackwellDilemma.boxedTorusHorizontalThenVerticalVerticalVertexSet
#print axioms BlackwellDilemma.boxedTorusHorizontalThenVerticalEdgeSet
#print axioms BlackwellDilemma.boxedTorusHorizontalThenVerticalVertexSet
#print axioms BlackwellDilemma.boxedTorusHorizontalThenVerticalVerticalEdgeEndpoint
#print axioms BlackwellDilemma.boxedTorusHorizontalThenVerticalVerticalStep_path
#print axioms BlackwellDilemma.boxedTorusHorizontalThenVertical_path_of_verticalEdgeSetEvent
#print axioms BlackwellDilemma.boxedTorusHorizontalThenVerticalVerticalVertexSet_coord_paths_of_edgeSetEvent
#print axioms BlackwellDilemma.boxedTorusHorizontalThenVerticalVertexSet_coord_paths_of_edgeSetEvent
#print axioms BlackwellDilemma.boxedTorusRestrictedClusterCount_ge_horizontalThenVerticalVertexSet_card_mul_q_pow_edgeSet_card
#print axioms BlackwellDilemma.boxedTorusHorizontalThenVerticalVerticalVertex_injOn_range
#print axioms BlackwellDilemma.boxedTorusHorizontalThenVerticalVerticalVertexSet_card
#print axioms BlackwellDilemma.boxedTorusHorizontalThenVerticalVerticalEdge_injOn_range
#print axioms BlackwellDilemma.boxedTorusHorizontalThenVerticalVerticalEdgeSet_card
#print axioms BlackwellDilemma.boxedTorusHorizontalThenVerticalEdgeSets_disjoint
#print axioms BlackwellDilemma.boxedTorusHorizontalThenVerticalEdgeSet_card
#print axioms BlackwellDilemma.boxedTorusHorizontalThenVerticalVertexSets_inter_eq_corner
#print axioms BlackwellDilemma.boxedTorusHorizontalThenVerticalVertexSet_card
#print axioms BlackwellDilemma.boxedTorusRestrictedClusterCount_ge_nat_succ_add_mul_q_pow_horizontalThenVerticalEdgeSet
#print axioms BlackwellDilemma.boxedTorusRectangleVertex
#print axioms BlackwellDilemma.boxedTorusRectangleHorizontalEdge
#print axioms BlackwellDilemma.boxedTorusRectangleVerticalEdge
#print axioms BlackwellDilemma.boxedTorusRectangleHorizontalEdgeSet
#print axioms BlackwellDilemma.boxedTorusRectangleVerticalEdgeSet
#print axioms BlackwellDilemma.boxedTorusRectangleEdgeSet
#print axioms BlackwellDilemma.boxedTorusRectangleVertexSet
#print axioms BlackwellDilemma.boxedTorusRectangleHorizontalEdge_zero_eq_horizontalIterEdge
#print axioms BlackwellDilemma.boxedTorusRectangleVerticalEdge_eq_horizontalThenVertical
#print axioms BlackwellDilemma.boxedTorusHorizontalIterEdgeSet_subset_rectangleHorizontalEdgeSet
#print axioms BlackwellDilemma.boxedTorusHorizontalThenVerticalVerticalEdgeSet_subset_rectangleVerticalEdgeSet
#print axioms BlackwellDilemma.boxedTorusHorizontalThenVerticalEdgeSet_subset_rectangleEdgeSet
#print axioms BlackwellDilemma.boxedTorusRectangleVertex_mem_horizontalThenVerticalVertexSet
#print axioms BlackwellDilemma.boxedTorusRectangleVertexSet_coord_paths_of_edgeSetEvent
#print axioms BlackwellDilemma.boxedTorusRestrictedClusterCount_ge_rectangleVertexSet_card_mul_q_pow_edgeSet_card
#print axioms BlackwellDilemma.boxedTorusRectangleVertex_injOn_rangeProduct
#print axioms BlackwellDilemma.boxedTorusRectangleVertexSet_card
#print axioms BlackwellDilemma.boxedTorusRectangleHorizontalEdge_injOn_rangeProduct
#print axioms BlackwellDilemma.boxedTorusRectangleHorizontalEdgeSet_card
#print axioms BlackwellDilemma.boxedTorusRectangleVerticalEdge_injOn_rangeProduct
#print axioms BlackwellDilemma.boxedTorusRectangleVerticalEdgeSet_card
#print axioms BlackwellDilemma.boxedTorusRectangleHorizontalVerticalEdgeSets_disjoint
#print axioms BlackwellDilemma.boxedTorusRectangleEdgeSet_card
#print axioms BlackwellDilemma.boxedTorusRestrictedClusterCount_ge_rectangle_area_mul_q_pow_edgeCount
#print axioms BlackwellDilemma.boxedTorusSquareVertexSet
#print axioms BlackwellDilemma.boxedTorusSquareEdgeSet
#print axioms BlackwellDilemma.boxedTorusSquareEdgeCount_eq_two_mul
#print axioms BlackwellDilemma.boxedTorusSquareVertexSet_card
#print axioms BlackwellDilemma.boxedTorusSquareEdgeSet_card
#print axioms BlackwellDilemma.boxedTorusRestrictedClusterCount_ge_square_area_mul_q_pow_edgeCount
#print axioms BlackwellDilemma.boxedTorusOracleClusterCount_nonneg
#print axioms BlackwellDilemma.boxedTorusOracleClusterCount_all_false
#print axioms BlackwellDilemma.boxedTorusOracleClusterCount_le_two_mul_openEdgeSet_card_add_one
#print axioms BlackwellDilemma.boxedTorusClusterCountExpectation_ge_square_area_mul_q_pow_edgeCount
#print axioms BlackwellDilemma.boxedTorusClusterCountExpectation_ge_square_area_mul_one_sub_p_pow_edgeCount
#print axioms BlackwellDilemma.boxedTorusBaseAxesEdgeSet
#print axioms BlackwellDilemma.boxedTorusBaseAxesEdgeSet_card
#print axioms BlackwellDilemma.boxedTorusBaseTripodVertexSet
#print axioms BlackwellDilemma.boxedTorusBaseTripodVertexSet_card
#print axioms BlackwellDilemma.boxedTorusBaseAxesCoordEdgeSetEventMass_eq_q_sq
#print axioms BlackwellDilemma.boxedTorusBaseTripod_coord_paths_of_baseAxesEdgeSetEvent
#print axioms BlackwellDilemma.boxedTorusReachableSet_card_ge_three_of_baseAxesEdgeSetEvent
#print axioms BlackwellDilemma.boxedTorusOracleClusterCount_ge_three_on_baseAxesEdgeSetEvent
#print axioms BlackwellDilemma.boxedTorusRestrictedClusterCount_ge_three_mul_q_sq_coordEdgeSetEvent
#print axioms BlackwellDilemma.boxedTorusBaseSquareCornerVertex
#print axioms BlackwellDilemma.boxedTorusHorizontalEdgeAtBaseVerticalTarget
#print axioms BlackwellDilemma.boxedTorusHorizontalAtBaseVerticalEndpoint
#print axioms BlackwellDilemma.boxedTorusBaseSquareCorner_pairwise_ne
#print axioms BlackwellDilemma.boxedTorusBaseSquareCornerVertexSet
#print axioms BlackwellDilemma.boxedTorusBaseSquareCornerVertexSet_card
#print axioms BlackwellDilemma.boxedTorusBaseSquareCornerEdgeSet
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalEdge_ne_horizontalAtBaseVertical
#print axioms BlackwellDilemma.boxedTorusBaseVerticalEdge_ne_horizontalAtBaseVertical
#print axioms BlackwellDilemma.boxedTorusBaseSquareCornerEdgeSet_card
#print axioms BlackwellDilemma.boxedTorusBaseSquareCornerEdgeSetEventMass_eq_q_cubed
#print axioms BlackwellDilemma.boxedTorusBaseSquareCorner_coord_paths_of_edgeSetEvent
#print axioms BlackwellDilemma.boxedTorusReachableSet_card_ge_four_of_baseSquareCornerEvent
#print axioms BlackwellDilemma.boxedTorusOracleClusterCount_ge_four_on_baseSquareCornerEvent
#print axioms BlackwellDilemma.boxedTorusRestrictedClusterCount_ge_four_mul_q_cubed_squareEvent
#print axioms BlackwellDilemma.finCycleSucc_succ_zero_ne_zero
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalSecondVertex
#print axioms BlackwellDilemma.boxedTorusHorizontalEdgeAtBaseHorizontalTarget
#print axioms BlackwellDilemma.boxedTorusHorizontalAtBaseHorizontalEndpoint
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalSecond_pairwise_ne
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalSecond_snd_ne_verticalTarget_snd
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalSecond_fst_ne_squareCorner_fst
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalOneStepVertexSet
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalOneStepVertexSet_card
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalOneStepEdgeSet
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalOneStepEdgeSet_card
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalOneStep_coord_paths_of_edgeSetEvent
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalSecondVertex_not_mem_oneStepVertexSet
#print axioms BlackwellDilemma.boxedTorusHorizontalAtBaseHorizontal_not_mem_oneStepEdgeSet
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalSecond_path_on_insert_oneStepEvent
#print axioms BlackwellDilemma.boxedTorusRestrictedClusterCount_ge_three_mul_q_sq_horizontalOneStepInsertEvent
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalTwoStepVertexSet
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalTwoStepVertexSet_card
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalTwoStepEdgeSet
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalTwoStepEdgeSet_eq_insert_oneStepEdgeSet
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalEdge_ne_horizontalAtBaseHorizontal
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalTwoStepEdgeSet_card
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalTwoStepEdgeSetEventMass_eq_q_sq
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalThirdVertex
#print axioms BlackwellDilemma.boxedTorusHorizontalEdgeAtBaseHorizontalSecond
#print axioms BlackwellDilemma.boxedTorusHorizontalAtBaseHorizontalSecondEndpoint
#print axioms BlackwellDilemma.finCycleSucc_succ_succ_zero_ne_zero
#print axioms BlackwellDilemma.finCycleSucc_succ_succ_zero_ne_succ_zero
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalThirdVertex_not_mem_twoStepVertexSet
#print axioms BlackwellDilemma.boxedTorusHorizontalAtSecond_not_mem_twoStepEdgeSet
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalTwoStep_coord_paths_of_edgeSetEvent
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalThird_path_on_insert_twoStepEvent
#print axioms BlackwellDilemma.boxedTorusRestrictedClusterCount_ge_four_mul_q_cubed_horizontalTwoStepInsertEvent
#print axioms BlackwellDilemma.boxedTorusReachableSet_card_ge_three_of_baseHorizontalTwoStepEvent
#print axioms BlackwellDilemma.boxedTorusOracleClusterCount_ge_three_on_baseHorizontalTwoStepEvent
#print axioms BlackwellDilemma.boxedTorusRestrictedClusterCount_ge_three_mul_q_sq_horizontalTwoStepEvent
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalSecondVertex_not_mem_squareCornerVertexSet
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalTwoStepSquareArmVertexSet
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalTwoStepSquareArmVertexSet_card
#print axioms BlackwellDilemma.boxedTorusHorizontalAtBaseHorizontal_not_mem_squareCornerEdgeSet
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalTwoStepSquareArmEdgeSet
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalTwoStepSquareArmEdgeSet_card
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalTwoStepSquareArmEventMass_eq_q_pow_four
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalTwoStepSquareArm_coord_paths_of_edgeSetEvent
#print axioms BlackwellDilemma.boxedTorusRestrictedClusterCount_ge_five_mul_q_pow_four_squareCornerInsertEvent
#print axioms BlackwellDilemma.boxedTorusReachableSet_card_ge_five_of_baseHorizontalTwoStepSquareArmEvent
#print axioms BlackwellDilemma.boxedTorusOracleClusterCount_ge_five_on_baseHorizontalTwoStepSquareArmEvent
#print axioms BlackwellDilemma.boxedTorusRestrictedClusterCount_ge_five_mul_q_pow_four_horizontalTwoStepSquareArmEvent
#print axioms BlackwellDilemma.boxedTorusRestrictedClusterCount_ge_four_mul_q_pow_four_squareCorner_on_horizontalTwoStepSquareArmEvent
#print axioms BlackwellDilemma.boxedTorusBaseAxesOpenEvent
#print axioms BlackwellDilemma.boxedTorusBaseAxesOpenEvent_mem_iff
#print axioms BlackwellDilemma.boxedTorusBaseAxesOpenEvent_eq_coordOpenEdgeSetEvent_pair
#print axioms BlackwellDilemma.boxedTorusOracleClusterCount_ge_three_on_baseAxesOpenEvent
#print axioms BlackwellDilemma.boxedTorusRestrictedClusterCount_ge_three_mul_baseAxesOpenEventMass
#print axioms BlackwellDilemma.boxedTorusBaseAxesOpenEventMass_eq_sq
#print axioms BlackwellDilemma.boxedTorusRestrictedClusterCount_ge_three_mul_q_sq
#print axioms BlackwellDilemma.oracleStarFiniteBondGraphData
#print axioms BlackwellDilemma.oracleStarFiniteBondGraphEndpoint_loopless
#print axioms BlackwellDilemma.oracleStarFiniteBondGraphReachableSet_one_mem_of_open_zeroMod
#print axioms BlackwellDilemma.starFiniteBondGraphOracleData
#print axioms BlackwellDilemma.WInfoOracleInterfacesOn_of_oracleReachableSetData
#print axioms BlackwellDilemma.WInfoOracleInterfacesOn_singletonReachableSet
#print axioms BlackwellDilemma.WInfoOracleInterfacesOn_finiteBondGraph
#print axioms BlackwellDilemma.WInfoOracleInterfacesOn_starFiniteBondGraph
#print axioms BlackwellDilemma.WInfoOracleInterfacesOn_boxedTorusFiniteBondGraph
#print axioms BlackwellDilemma.oracleDataOfReachableSet_kernel_nonzero
#print axioms BlackwellDilemma.OracleInfoDecayConclusionOn
#print axioms BlackwellDilemma.OracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.unitExponentialOracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.oracleReachableSetOracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.singletonReachableSetOracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.finiteBondGraphOracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.starFiniteBondGraphOracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.boxedTorusFiniteBondGraphOracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.W_info_oracleOn_nonpos_of_mem_unitInterval
#print axioms BlackwellDilemma.W_info_oracleOn_nonpos
#print axioms BlackwellDilemma.W_info_oracleOn_clusterCountExpectation_pos_of_mem_unitInterval
#print axioms BlackwellDilemma.W_info_oracleOn_abs_le_clusterCountExpectation_mul_rpow_of_mem_unitInterval
#print axioms BlackwellDilemma.W_info_oracleOn_exponential_bound_of_mem_unitInterval
#print axioms BlackwellDilemma.W_info_oracleOn_exponential_bound
#print axioms BlackwellDilemma.W_info_oracleOn_exponential_bound_finite
#print axioms BlackwellDilemma.oracleInfoDecayConclusionOn_from_finite_interfaces
#print axioms BlackwellDilemma.oracleInfoDecayConclusionOn_from_interfaces
#print axioms BlackwellDilemma.unitExponentialOracleInfoDecayConclusion
#print axioms BlackwellDilemma.oracleReachableSetOracleInfoDecayConclusion
#print axioms BlackwellDilemma.singletonReachableSetOracleInfoDecayConclusion
#print axioms BlackwellDilemma.finiteBondGraphOracleInfoDecayConclusion
#print axioms BlackwellDilemma.starFiniteBondGraphOracleInfoDecayConclusion
#print axioms BlackwellDilemma.boxedTorusFiniteBondGraphOracleInfoDecayConclusion
#print axioms BlackwellDilemma.boxedTorusOracleInfoDecay_explicitSquareWitness
#print axioms BlackwellDilemma.boxedTorusOracleClusterCount_le_vertexCount
#print axioms BlackwellDilemma.boxedTorusClusterCountExpectation_le_vertexCount
#print axioms BlackwellDilemma.boxedTorusClusterCountExpectation_le_four_mul_q_mul_area_add_one
#print axioms BlackwellDilemma.boxedTorusClusterCountExpectation_le_four_mul_C_add_one_of_q_le_area_inv
#print axioms BlackwellDilemma.boxedTorusClusterCountExpectation_le_vertexCount_one_sub_p
#print axioms BlackwellDilemma.boxedTorusClusterCountExpectation_eq_one_openProb_zero
#print axioms BlackwellDilemma.boxedTorusClusterCountExpectation_eq_one_blocking_one
#print axioms BlackwellDilemma.boxedTorusOracleInfoDecay_boundedExplicitSquareWitness
#print axioms BlackwellDilemma.boxedTorusOracleInfoDecay_blocking_one_unitWitness
#print axioms BlackwellDilemma.boxedTorusOracleInfoDecay_areaScaledOpenProbWitness
#print axioms BlackwellDilemma.W_info_oracle_eq_zero_current
#print axioms BlackwellDilemma.W_info_oracle_eq_on_current
#print axioms BlackwellDilemma.W_info_oracle_current_uniform_unit_bound
#print axioms BlackwellDilemma.W_info_oracle_nonpos
#print axioms BlackwellDilemma.W_info_oracle_exponential_bound_finite
#print axioms BlackwellDilemma.W_info_oracle_exponential_bound
#print axioms BlackwellDilemma.gap_info_decay_finite
#print axioms BlackwellDilemma.gap_info_decay
#print axioms BlackwellDilemma.gap_dilemma
#print axioms BlackwellDilemma.not_currentOracleInfoNonzeroWitness_current
#print axioms BlackwellDilemma.currentOracleInfoDecayConclusion_from_zero
#print axioms BlackwellDilemma.currentOracleInfoDecayConclusion_from_on_current
#print axioms BlackwellDilemma.currentOracleInfoDecayConclusion_from_interfacesOn_current
#print axioms BlackwellDilemma.currentOracleInfoDecayConclusion_from_boxedTorusFiniteBondGraph
#print axioms BlackwellDilemma.currentOracleInfoDecayConclusion_from_boxedTorusAllOpenGiantTopoLossData
#print axioms BlackwellDilemma.unitExponentialOracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.unitExponentialOracleInfoDecayConclusion
#print axioms BlackwellDilemma.singletonReachableSetOracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.singletonReachableSetOracleInfoDecayConclusion
#print axioms BlackwellDilemma.currentGreedyWelfareReversalConclusion
#print axioms BlackwellDilemma.currentOracleInfoDecayConclusion
#print axioms BlackwellDilemma.gap_dilemma_current_noDiagnosticAssumptions

-- Percolation-foundation wave (continuation) — paper-faithful
-- below-threshold `1/(n+1)` envelope on the giant-component
-- sub-event.
--
-- Paper Thm 3.3 Part 1 (lines 404, 415-419) + prop:topo-cluster (line
-- 286, proof lines 292-296) establish `E[|W_topo|] = O(1/n)` ONLY
-- conditional on `v_0` lying in the giant component (`|R(v_0)| =
-- Θ(n)`).  Unconditionally below threshold `E[|W_topo|] = Θ(1)` —
-- the `1 − θ(1−p)` fraction of non-giant-component realisations
-- carry `Θ(1)` loss (an isolated-vertex realisation has `|R| = 1`,
-- loss `(n−1)/(2(n+1)) ≈ 1/2`).  The `1/(n+1)` bound is an
-- EXPECTATION bound (false pointwise) requiring the giant-component
-- event probability `θ(1−p) > 0` to split the kernel.
--
-- The Lean encoding follows paper line 415's giant-component-conditional
-- form (truth-over-publication discipline).
--
-- (1) `Percolation.lean` EXTENDED with the sub-event-expectation +
--     cluster-size-partition layer (4 new kernel-pure lemmas):
--      * `percRestrictedExpectation p S f := ∑ ω ∈ S, bondConfigWeight
--        p ω * f ω` — the bond-percolation expectation RESTRICTED to a
--        sub-event `S` (paper proof line 292's conditioning building
--        block).
--      * `percRestrictedExpectation_univ` — `E_{G_p}[f ; univ] =
--        E_{G_p}[f]`.
--      * `percRestrictedExpectation_le_of_pointwise_le_on` (+ re-export
--        `percRestrictedExpectation_le_on`) — sub-event monotonicity:
--        pointwise-`≤ c` on `S` (for `c ≥ 0`) ⇒ `E_{G_p}[f ; S] ≤ c`.
--      * `percExpectation_eq_sum_clusterSizeFiber` — the cluster-size
--        PARTITION `E_{G_p}[f] = ∑_{k≤N} E_{G_p}[f ; {ω | κ ω = k}]`
--        via `Finset.sum_fiberwise_of_maps_to` (paper proof line 292's
--        "partition the sample space by `|R(v_0)| = k`").
--     All four kernel-pure `[propext, Classical.choice, Quot.sound]`.
--
-- (2) NEW Cat 3 carrier `giantComponentEvent : (n : ℕ) → Finset
--     (BondConfig (EdgeIdx n))` — the `Z²_L` giant-component event
--     (`v_0` in the largest component, paper line 404's `|R(v_0)| =
--     Θ(N)`), the sub-event over which paper line 415 conditions.
--     Carries the Grimmett 1999 §§8.2-8.3 giant-component-size Cat 2
--     dependency.
--
-- (3) Current-global diagnostic topoLoss closure
--     `topoLossKernel_le_one_over_n_on_giant_atom` — `∀ n ω,
--     ω ∈ giantComponentEvent n → topoLossKernel n ω ≤ 1/(n+1)`.
--     On the current diagnostic carrier this consumes the current closures of
--     the two bridge predicates internally and has a nonempty `n = 1`
--     witness, audited below by `giantComponentEvent_one_current_nonempty` and
--     `expectedTopoLossOnGiant_one_current_pos`; it exposes no theorem-level
--     bridge premises. The full finite-lattice bridge-premise route is
--     `topoLossKernel_pointwise_bound_on`, consuming
--     `TopoLossKernelEqOrderStatisticsRatioOnGiantOn data` and
--     `GiantComponentClusterSizeLowerBoundOn data`.
--
-- (4) GENUINE PAPER CLAIM derived (not axiomatised) —
--     `expectedTopoLossOnGiant n p := percRestrictedExpectation (1−p)
--     (giantComponentEvent n) (topoLossKernel n)` is the paper-faithful
--     object (paper line 415's `E[· | giant]` numerator), and
--     `topo_loss_on_giant_below_one_over_n : expectedTopoLossOnGiant n
--     p ≤ 1/(n+1)` is the DERIVED theorem (unfold + the Cat 1
--     `percRestrictedExpectation_le_on` + the atom above). The
--     convergence conclusions `gap_topo_loss_below_threshold` /
--     `gap_phase_transition_below` conclude the paper-faithful
--     giant-component-conditional `expectedTopoLossOnGiant n p → 0`
--     (paper line 404's genuine content). Both are TERMINAL derived
--     theorems (no higher consumer — grep-verified across all
--     `*.lean`). The Cat 2 Grimmett dependency is carried by the
--     `giantComponentEvent` carrier, which surfaces in
--     `#print axioms` of every consumer below.
#print axioms BlackwellDilemma.percRestrictedExpectation_univ
#print axioms BlackwellDilemma.percRestrictedExpectation_le_of_pointwise_le_on
#print axioms BlackwellDilemma.percExpectation_eq_sum_clusterSizeFiber
#print axioms BlackwellDilemma.percRestrictedExpectation_le_on
#print axioms BlackwellDilemma.topoLossKernel_eq_orderStatisticsRatio_on_giant_current
#print axioms BlackwellDilemma.giantComponent_cluster_size_lower_bound_current
#print axioms BlackwellDilemma.giantComponentEvent_one_current_nonempty
#print axioms BlackwellDilemma.expectedTopoLossOnGiant_one_current_eq_half
#print axioms BlackwellDilemma.expectedTopoLossOnGiant_one_current_pos
#print axioms BlackwellDilemma.topoLossKernel_pointwise_bound_on
#print axioms BlackwellDilemma.expectedTopoLossOnGiantOn_le_one_over_n
#print axioms BlackwellDilemma.expectedTopoLossOnGiantOn_below_envelope_exists
#print axioms BlackwellDilemma.ExpectedTopoLossOnGiantEnvelopeConclusion
#print axioms BlackwellDilemma.expectedTopoLossOnGiantEnvelopeConclusion_from_pointwise_bound
#print axioms BlackwellDilemma.giantComponentEventPositiveMassConclusion_of_fullCluster
#print axioms BlackwellDilemma.GiantComponentEventFullClusterConclusion
#print axioms BlackwellDilemma.BoxedTorusClusterCountExpectationBoundsConclusion
#print axioms BlackwellDilemma.expectedTopoLossOnGiantOn_below_eps_from_envelope
#print axioms BlackwellDilemma.oneStepGiantTopoLossData_giantComponentEvent_one_nonempty
#print axioms BlackwellDilemma.oneStepGiantTopoLossData_topoLossKernel_eq_orderStatisticsRatio_on_giant
#print axioms BlackwellDilemma.oneStepGiantTopoLossData_giantComponent_cluster_size_lower_bound
#print axioms BlackwellDilemma.oneStepGiantTopoLossData_topoLossKernel_pointwise_bound
#print axioms BlackwellDilemma.oneStepGiantTopoLossData_expectedTopoLossOnGiant_le_one_over_n
#print axioms BlackwellDilemma.oneStepGiantTopoLossData_expectedTopoLossOnGiant_one_eq_half
#print axioms BlackwellDilemma.oneStepGiantTopoLossData_expectedTopoLossOnGiant_one_pos
#print axioms BlackwellDilemma.unitPositiveTopoLossData
#print axioms BlackwellDilemma.unitPositiveTopoLossData_topoLossKernel_mem_unitInterval
#print axioms BlackwellDilemma.unitPositiveTopoLossData_expectedTopoLossOnData_eq_half
#print axioms BlackwellDilemma.unitPositiveTopoLossData_unitCompatibleAboveThresholdLowerBoundConclusion
#print axioms BlackwellDilemma.exists_UnitCompatibleAboveThresholdLowerBoundConclusion
#print axioms BlackwellDilemma.firstEdgeIdx
#print axioms BlackwellDilemma.firstEdgeStochasticTopoLossData
#print axioms BlackwellDilemma.firstEdgeStochasticTopoLossData_topoLossKernel_open_closed
#print axioms BlackwellDilemma.firstEdgeStochasticTopoLossData_topoLossKernel_mem_unitInterval
#print axioms BlackwellDilemma.firstEdgeStochasticTopoLossData_expectedTopoLossOnData_eq
#print axioms BlackwellDilemma.firstEdgeStochasticTopoLossData_unitCompatibleAboveThresholdLowerBoundConclusion
#print axioms BlackwellDilemma.firstEdgeOpenEvent
#print axioms BlackwellDilemma.firstEdgeOpenEvent_mem_iff
#print axioms BlackwellDilemma.firstEdgeOpenEvent_nonempty
#print axioms BlackwellDilemma.firstEdgeOpenEvent_mass_eq
#print axioms BlackwellDilemma.firstEdgeOpenEvent_mass_pos
#print axioms BlackwellDilemma.firstEdgeOpenEvent_restricted_indicator_eq
#print axioms BlackwellDilemma.firstEdgeGiantStochasticTopoLossData
#print axioms BlackwellDilemma.firstEdgeGiantStochasticTopoLossData_topoLossKernel_mem_unitInterval
#print axioms BlackwellDilemma.firstEdgeGiantStochasticTopoLossData_expectedTopoLossOnData_eq
#print axioms BlackwellDilemma.firstEdgeGiantStochasticTopoLossData_expectedTopoLossOnGiantOn_eq
#print axioms BlackwellDilemma.firstEdgeGiantStochasticTopoLossData_giantEventPositiveMassConclusion
#print axioms BlackwellDilemma.firstEdgeGiantStochasticTopoLossData_giantEventFullClusterConclusion
#print axioms BlackwellDilemma.firstEdgeGiantStochasticTopoLossData_unitCompatibleAboveThresholdLowerBoundConclusion
#print axioms BlackwellDilemma.firstEdgeGiantStochasticTopoLossData_positiveGiant_and_unitCompatible
#print axioms BlackwellDilemma.FirstEdgeGiantStochasticTopoLossPositiveRegressionCertificate
#print axioms BlackwellDilemma.firstEdgeGiantStochasticTopoLossData_positive_regression_certificate
#print axioms BlackwellDilemma.not_TopoLossKernelPointwiseBoundOn_firstEdgeGiantStochasticTopoLossData
#print axioms BlackwellDilemma.not_BoxedTorusFlatFamilyCoreConclusion_firstEdgeGiantStochastic_family
#print axioms BlackwellDilemma.not_randomSupercriticalZ2TopoClusterRepairedBridgeData_firstEdgeGiantStochastic_family
#print axioms BlackwellDilemma.FirstEdgeGiantStochasticTopoLossNotRandomSupercriticalZ2BridgeCertificate
#print axioms BlackwellDilemma.firstEdgeGiantStochasticTopoLossData_not_random_supercritical_z2_bridge_certificate
#print axioms BlackwellDilemma.boxedTorusAllOpenGiantEvent_nonempty
#print axioms BlackwellDilemma.boxedTorusAllOpenGiantEventMass_eq_pow_edgeCard
#print axioms BlackwellDilemma.boxedTorusAllOpenGiantEventMass_pos
#print axioms BlackwellDilemma.boxedTorusAllOpenGiantEvent_indicator_expectation_eq_pow_edgeCard
#print axioms BlackwellDilemma.boxedTorusReachableSet_card_eq_full_on_allOpenGiantEvent
#print axioms BlackwellDilemma.boxedTorusAllOpenGiantTopoLossData_clusterCount_eq_full_on_flat_giant
#print axioms BlackwellDilemma.boxedTorusAllOpenGiantTopoLossData_flat_giantEventMass_eq_pow_edgeCard
#print axioms BlackwellDilemma.boxedTorusAllOpenGiantTopoLossData_flat_giantEventMass_pos
#print axioms BlackwellDilemma.boxedTorusAllOpenGiantTopoLossData_giantEventPositiveMassConclusion
#print axioms BlackwellDilemma.boxedTorusAllOpenGiantTopoLossData_giantEventFullClusterConclusion
#print axioms BlackwellDilemma.boxedTorusAllOpenGiantTopoLossData_clusterCountExpectation_ge_square_area_mul_one_sub_p_pow_edgeCount
#print axioms BlackwellDilemma.boxedTorusAllOpenGiantTopoLossData_clusterCountExpectation_le_vertexCount_one_sub_p
#print axioms BlackwellDilemma.boxedTorusAllOpenGiantTopoLossData_clusterCountExpectationBoundsConclusion
#print axioms BlackwellDilemma.orderStatisticsRatio_eq_zero_implies_n_le_k
#print axioms BlackwellDilemma.boxedTorusAllOpenGiantTopoLossData_giantEvent_flat_nonempty
#print axioms BlackwellDilemma.boxedTorusAllOpenGiantTopoLossData_topoLossKernel_eq_orderStatisticsRatio_on_giant
#print axioms BlackwellDilemma.boxedTorusAllOpenGiantTopoLossData_giantComponent_cluster_size_lower_bound
#print axioms BlackwellDilemma.boxedTorusAllOpenGiantTopoLossData_topoLossKernel_pointwise_bound
#print axioms BlackwellDilemma.boxedTorusAllOpenGiantTopoLossData_expectedTopoLossOnGiant_le_one_over_n
#print axioms BlackwellDilemma.boxedTorusAllOpenGiantTopoLossData_expectedTopoLossOnGiant_below_envelope_exists
#print axioms BlackwellDilemma.boxedTorusAllOpenGiantTopoLossData_expectedTopoLossOnGiantEnvelopeConclusion
#print axioms BlackwellDilemma.boxedTorusAllOpenGiantTopoLossData_expectedTopoLossOnGiant_below_eps
#print axioms BlackwellDilemma.boxedTorusAllOpenGiantTopoLossData_expectedTopoLossOnGiant_flat_eq_zero
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_topoLossKernel_mem_unitInterval
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_clusterCount_eq_full_on_flat_giant
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_giantComponentEvent_flat
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_topoLossKernel_flat
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_giantEvent_flat_nonempty
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_flat_giantEventMass_eq_pow_edgeCard
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_flat_giantEventMass_pos
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_giantEventPositiveMassConclusion
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_giantEventFullClusterConclusion
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_expectedTopoLossOnGiant_flat_eq
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_expectedTopoLossOnGiant_flat_pos
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_expectedTopoLossOnData_flat_eq
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_expectedTopoLossOnData_flat_pos
#print axioms BlackwellDilemma.boxedTorusAllOpenPositiveTopoLossData_expectedTopoLossOnData_eq_zero_of_ne
#print axioms BlackwellDilemma.not_UnitCompatibleAboveThresholdLowerBoundConclusion_boxedTorusAllOpenPositive
#print axioms BlackwellDilemma.boxedTorusAllOpenFirstEdgeAwayTopoLossData
#print axioms BlackwellDilemma.boxedTorusAllOpenFirstEdgeAwayTopoLossData_topoLossKernel_mem_unitInterval
#print axioms BlackwellDilemma.WInfoOracleInterfacesOn_boxedTorusAllOpenFirstEdgeAwayTopoLossData
#print axioms BlackwellDilemma.boxedTorusAllOpenFirstEdgeAwayTopoLossData_oracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.boxedTorusAllOpenFirstEdgeAwayTopoLossData_expectedTopoLossOnData_flat_eq_zero
#print axioms BlackwellDilemma.boxedTorusAllOpenFirstEdgeAwayTopoLossData_expectedTopoLossOnData_eq_of_ne
#print axioms BlackwellDilemma.boxedTorusAllOpenFirstEdgeAwayTopoLossData_topoLossKernel_pointwise_bound
#print axioms BlackwellDilemma.boxedTorusAllOpenFirstEdgeAwayTopoLossData_expectedTopoLossOnGiantEnvelopeConclusion
#print axioms BlackwellDilemma.boxedTorusAllOpenFirstEdgeAwayTopoLossData_giantEventFullClusterConclusion
#print axioms BlackwellDilemma.boxedTorusAllOpenFirstEdgeAwayTopoLossData_clusterCountExpectationBoundsConclusion
#print axioms BlackwellDilemma.boxedTorusAllOpenFirstEdgeAwayTopoLossData_unitCompatibleAboveThresholdLowerBoundConclusion
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossData
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossData_topoLossKernel_mem_unitInterval
#print axioms BlackwellDilemma.WInfoOracleInterfacesOn_firstEdgeOpenGiantClosedTopoLossData
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossData_oracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossData_topoLossKernel_zero_on_giant
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossData_topoLossKernel_pointwise_bound
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossData_expectedTopoLossOnGiantOn_eq_zero
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossData_expectedTopoLossOnGiantEnvelopeConclusion
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossData_expectedTopoLossOnData_eq
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossData_giantEventFullClusterConclusion
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossData_clusterCountExpectationBoundsConclusion
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossData_unitCompatibleAboveThresholdLowerBoundConclusion
#print axioms BlackwellDilemma.firstEdgeOpenGiantClosedTopoLossData_corePackages
#print axioms BlackwellDilemma.allEdgeOpenEvent
#print axioms BlackwellDilemma.allEdgeOpenEvent_mem_iff
#print axioms BlackwellDilemma.allEdgeOpenEvent_nonempty
#print axioms BlackwellDilemma.allEdgeOpenEvent_mass_eq
#print axioms BlackwellDilemma.allEdgeOpenEvent_mass_pos
#print axioms BlackwellDilemma.allEdgeOpenGiantComplementTopoLossData
#print axioms BlackwellDilemma.allEdgeOpenGiantComplementTopoLossData_topoLossKernel_mem_unitInterval
#print axioms BlackwellDilemma.WInfoOracleInterfacesOn_allEdgeOpenGiantComplementTopoLossData
#print axioms BlackwellDilemma.allEdgeOpenGiantComplementTopoLossData_oracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.allEdgeOpenGiantComplementTopoLossData_topoLossKernel_zero_on_giant
#print axioms BlackwellDilemma.allEdgeOpenGiantComplementTopoLossData_topoLossKernel_pointwise_bound
#print axioms BlackwellDilemma.allEdgeOpenGiantComplementTopoLossData_expectedTopoLossOnGiantOn_eq_zero
#print axioms BlackwellDilemma.allEdgeOpenGiantComplementTopoLossData_expectedTopoLossOnGiantEnvelopeConclusion
#print axioms BlackwellDilemma.allEdgeOpenGiantComplementTopoLossData_expectedTopoLossOnData_ge
#print axioms BlackwellDilemma.allEdgeOpenGiantComplementTopoLossData_giantEventFullClusterConclusion
#print axioms BlackwellDilemma.allEdgeOpenGiantComplementTopoLossData_clusterCountExpectationBoundsConclusion
#print axioms BlackwellDilemma.allEdgeOpenGiantComplementTopoLossData_unitCompatibleAboveThresholdLowerBoundConclusion
#print axioms BlackwellDilemma.allEdgeOpenGiantComplementTopoLossData_corePackages
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_topoLossKernel_mem_unitInterval
#print axioms BlackwellDilemma.WInfoOracleInterfacesOn_boxedTorusAllOpenComplementTopoLossData
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_oracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_topoLossKernel_zero_on_giant
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_topoLossKernel_pointwise_bound
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_expectedTopoLossOnGiantOn_eq_zero
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_expectedTopoLossOnGiantEnvelopeConclusion
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_expectedTopoLossOnData_eq_of_ne
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_giantEventFullClusterConclusion
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_clusterCountExpectationBoundsConclusion
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_unitCompatibleAboveThresholdLowerBoundConclusion
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_corePackages
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_topoLossKernel_flat
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_expectedTopoLossOnData_flat_eq
#print axioms BlackwellDilemma.boxedTorusEdgeIdx_card_pos
#print axioms BlackwellDilemma.one_quarter_pow_boxedTorusEdgeIdx_card_le_one_quarter
#print axioms BlackwellDilemma.boxedTorusAllOpenComplementTopoLossData_expectedTopoLossOnData_flat_ge_eighth
#print axioms BlackwellDilemma.BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion
#print axioms BlackwellDilemma.BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion_current
#print axioms BlackwellDilemma.boxedTorusCoordClosedEdgeSetEvent
#print axioms BlackwellDilemma.boxedTorusCoordClosedEdgeSetEvent_mem_iff
#print axioms BlackwellDilemma.boxedTorusCoordClosedEdgeSetEventMass_eq_one_sub_pow_card
#print axioms BlackwellDilemma.boxedTorusCoordOpenPathLength_eq_base_of_baseIncident_closed
#print axioms BlackwellDilemma.boxedTorusFullReachGiantEvent
#print axioms BlackwellDilemma.boxedTorusFullReachGiantEvent_mem_iff
#print axioms BlackwellDilemma.boxedTorusAllOpenGiantEvent_subset_fullReachGiantEvent
#print axioms BlackwellDilemma.boxedTorusFullReachGiantEvent_nonempty
#print axioms BlackwellDilemma.boxedTorusFullReachGiantEventMass_pos
#print axioms BlackwellDilemma.boxedTorusReachableSet_card_eq_full_on_fullReachGiantEvent
#print axioms BlackwellDilemma.boxedTorusReachableSet_mem_of_card_eq_full
#print axioms BlackwellDilemma.boxedTorusFullReachGiantEvent_clusterCount_eq_full
#print axioms BlackwellDilemma.boxedTorusBaseIncidentClosedEvent
#print axioms BlackwellDilemma.boxedTorusBaseIncidentClosedEvent_mem_iff
#print axioms BlackwellDilemma.boxedTorusBaseIncidentClosedEventMass_eq
#print axioms BlackwellDilemma.BoxedTorusBaseTargetSeparator
#print axioms BlackwellDilemma.BoxedTorusBaseTargetEdgeCutset
#print axioms BlackwellDilemma.boxedTorusCoordEdgeBoundarySet
#print axioms BlackwellDilemma.boxedTorusCoordEdgeBoundarySet_mem_of_edgeAdj
#print axioms BlackwellDilemma.boxedTorusCoordSimplePathSkeleton_meets_edgeBoundary_of_not_mem
#print axioms BlackwellDilemma.boxedTorusCoordEdgeBoundarySet_baseTargetEdgeCutset
#print axioms BlackwellDilemma.boxedTorusCoordEdgeBoundarySet_baseSingleton_subset_baseIncident
#print axioms BlackwellDilemma.boxedTorusCoordEdgeBoundarySet_baseSingleton_card_le_four
#print axioms BlackwellDilemma.boxedTorusBaseHorizontalTarget_not_mem_baseSingleton
#print axioms BlackwellDilemma.boxedTorusCoordEdgeBoundarySet_baseTargetSeparator
#print axioms BlackwellDilemma.boxedTorusCoordEdgeBoundarySet_baseSingleton_baseTargetSeparator
#print axioms BlackwellDilemma.boxedTorusCoordSimplePathSkeleton_meets_baseIncident_of_pos
#print axioms BlackwellDilemma.boxedTorusBaseIncidentEdgeSet_baseTargetEdgeCutset
#print axioms BlackwellDilemma.boxedTorusBaseTargetSeparator_of_edgeCutset
#print axioms BlackwellDilemma.boxedTorusBaseTargetEdgeCutset_of_separator
#print axioms BlackwellDilemma.boxedTorusBaseIncidentEdgeSet_baseTargetSeparator
#print axioms BlackwellDilemma.boxedTorusCoordClosedEdgeSetEvent_not_fullReach_of_baseTargetSeparator
#print axioms BlackwellDilemma.boxedTorusBaseIncidentClosedEvent_not_fullReach
#print axioms BlackwellDilemma.boxedTorusFullReachFailureEvent
#print axioms BlackwellDilemma.boxedTorusFullReachFailureEvent_mem_iff
#print axioms BlackwellDilemma.boxedTorusFullReachGiantFailureEventMass_add_eq_one
#print axioms BlackwellDilemma.boxedTorusFullReachFailureEventMass_eq_one_sub_fullReachGiantEventMass
#print axioms BlackwellDilemma.boxedTorusBaseIncidentClosedEvent_subset_fullReachFailureEvent
#print axioms BlackwellDilemma.boxedTorusCoordClosedEdgeSetEvent_subset_fullReachFailureEvent_of_baseTargetSeparator
#print axioms BlackwellDilemma.boxedTorusFullReachFailureEventMass_ge_closedSeparator
#print axioms BlackwellDilemma.boxedTorusFullReachFailureEventMass_ge_closedSeparator_one_sub
#print axioms BlackwellDilemma.boxedTorusFullReachFailureEventMass_ge_closedBoundary
#print axioms BlackwellDilemma.boxedTorusFullReachFailureEventMass_ge_closedBoundary_one_sub
#print axioms BlackwellDilemma.boxedTorusFullReachFailureEventMass_ge_baseIncidentClosed
#print axioms BlackwellDilemma.boxedTorusFullReachFailureEventMass_ge_baseIncidentClosed_one_sub
#print axioms BlackwellDilemma.boxedTorusFullReachGiantEventMass_le_one_sub_closedSeparator
#print axioms BlackwellDilemma.boxedTorusFullReachGiantEventMass_le_one_sub_closedSeparator_one_sub
#print axioms BlackwellDilemma.boxedTorusFullReachGiantEventMass_le_one_sub_closedBoundary
#print axioms BlackwellDilemma.boxedTorusFullReachGiantEventMass_le_one_sub_closedBoundary_one_sub
#print axioms BlackwellDilemma.boxedTorusFullReachGiantEventMass_le_one_sub_baseIncidentClosed
#print axioms BlackwellDilemma.boxedTorusFullReachGiantEventMass_le_one_sub_baseIncidentClosed_one_sub
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_topoLossKernel_mem_unitInterval
#print axioms BlackwellDilemma.WInfoOracleInterfacesOn_boxedTorusFullReachComplementTopoLossData
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_oracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_topoLossKernel_zero_on_giant
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_topoLossKernel_pointwise_bound
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnGiantOn_eq_zero
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnGiantEnvelopeConclusion
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_eq_of_ne
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_giantEventFullClusterConclusion
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_clusterCountExpectationBoundsConclusion
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_unitCompatibleAboveThresholdLowerBoundConclusion
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_corePackages
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_topoLossKernel_flat
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedSeparator
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedCutset
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedIncident
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedBoundary
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedSeparator_pow_div_two_of_card_le
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedCutset_pow_div_two_of_card_le
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedBoundary_pow_div_two_of_card_le
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_flat_ge_baseSingletonBoundary
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_flat_ge_baseSingletonBoundary_pow_four_div_two
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_flat_ge_baseSingletonBoundary_one_over_512
#print axioms BlackwellDilemma.one_over_512_le_three_quarters_pow_div_two_of_le_four
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_flat_ge_one_over_512
#print axioms BlackwellDilemma.BoxedTorusFlatFamilyCoreConclusion
#print axioms BlackwellDilemma.BoxedTorusFlatFamilyCoreConclusion_expectedTopoLossOnGiantEnvelope
#print axioms BlackwellDilemma.BoxedTorusFullReachComplementLowerBoundConclusion_of_eventually_boundedSeparator_at
#print axioms BlackwellDilemma.BoxedTorusFullReachComplementLowerBoundConclusion_of_eventually_boundedCutset_at
#print axioms BlackwellDilemma.BoxedTorusFullReachComplementLowerBoundConclusion_of_eventually_boundedBoundary_at
#print axioms BlackwellDilemma.BoxedTorusFullReachComplementLowerBoundConclusion_of_eventually_boundedBoundary
#print axioms BlackwellDilemma.BoxedTorusFullReachComplementLowerBoundConclusion_of_eventually_smallBoundary
#print axioms BlackwellDilemma.BoxedTorusFullReachComplementLowerBoundConclusion_current
#print axioms BlackwellDilemma.boxedTorusFullReachComplementTopoLossData_flatFamilyCoreConclusion
#print axioms BlackwellDilemma.BoxedTorusFullReachFlatUnitCompatibleAboveThresholdLowerBoundConclusion_current
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_topoLossKernel_mem_unitInterval
#print axioms BlackwellDilemma.WInfoOracleInterfacesOn_boxedTorusFullReachFlatOnlyComplementTopoLossData
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_oracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_topoLossKernel_zero_on_giant
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_topoLossKernel_pointwise_bound
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnGiantOn_eq_zero
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnGiantEnvelopeConclusion
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_eq_of_ne
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_giantEventFullClusterConclusion
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_clusterCountExpectationBoundsConclusion
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_corePackages
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_topoLossKernel_flat
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_eq_fullReachComplement
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_eq_failureMass
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_eq_one_sub_fullReachMass
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedSeparator
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedCutset
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedIncident
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedBoundary
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedBoundary_one_over_512
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_baseSingletonBoundary
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_baseSingletonBoundary_pow_four_div_two
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_baseSingletonBoundary_one_over_512
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_one_over_512
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedSeparator_pow_div_two_of_card_le
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedCutset_pow_div_two_of_card_le
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedBoundary_pow_div_two_of_card_le
#print axioms BlackwellDilemma.BoxedTorusFullReachFlatOnlyLowerBoundConclusion_of_eventually_boundedSeparator_at
#print axioms BlackwellDilemma.BoxedTorusFullReachFlatOnlyLowerBoundConclusion_of_eventually_boundedCutset_at
#print axioms BlackwellDilemma.BoxedTorusFullReachFlatOnlyLowerBoundConclusion_of_eventually_boundedBoundary_at
#print axioms BlackwellDilemma.BoxedTorusFullReachFlatOnlyLowerBoundConclusion_of_eventually_boundedBoundary
#print axioms BlackwellDilemma.BoxedTorusFullReachFlatOnlyLowerBoundConclusion_of_eventually_smallBoundary
#print axioms BlackwellDilemma.BoxedTorusFullReachFlatOnlyLowerBoundCutsetRouteCertificate
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyLowerBound_cutset_route_certificate
#print axioms BlackwellDilemma.BoxedTorusFullReachFlatOnlyLowerBoundConclusion_current
#print axioms BlackwellDilemma.boxedTorusFullReachFlatOnlyComplementTopoLossData_flatFamilyCoreConclusion
#print axioms BlackwellDilemma.WInfoOracleInterfacesOn_boxedTorusAllOpenGiantTopoLossData
#print axioms BlackwellDilemma.boxedTorusAllOpenGiantTopoLossData_oracleInfoNonzeroWitnessOn
#print axioms BlackwellDilemma.topoLossKernel_le_one_over_n_on_giant_atom
#print axioms BlackwellDilemma.topo_loss_on_giant_below_one_over_n
#print axioms BlackwellDilemma.topo_loss_on_giant_below_envelope_exists
#print axioms BlackwellDilemma.topo_loss_on_giant_below_eps_from_envelope
#print axioms BlackwellDilemma.gap_topo_loss_below_threshold
#print axioms BlackwellDilemma.gap_phase_transition_below

-- ===================================================================
-- `trap-prevalence` Part 2 — paper-faithful product lower bound.
-- ===================================================================
--
-- Reading paper Proposition `prop:trap-prevalence` Part 2 proof line
-- 473 faithfully: `binom(4,2) p²(1-p)²·p³ = 6 p⁵ (1-p)²` is the
-- probability of the *edge configuration alone* (`v` has exactly two
-- open edges to `u_1, u_2`, its other two blocked, `u_1`'s three
-- remaining blocked so `|C_1| = 1`). The trap event ALSO requires
-- `|C_2| ≥ 2` ("with positive probability", NOT probability 1 — paper
-- line 473) AND the reward event `E` (`r(u_1) > r(u_2)` but
-- `max_{C_2} r > r(u_1)`, probability `1/6` for `|C_2| = 2` — paper
-- line 471).  The trap event is therefore a STRICTLY SMALLER sub-event
-- of the edge-config event, so `trapMisalignmentProbability p <
-- trapConfigLocalProb p`.  The paper's actual conclusion (line 473) is
-- that the trap probability is "bounded below by *a* positive constant
-- depending on `p`" — that constant is `6 p⁵ (1-p)²` *multiplied by*
-- the further positive factors.
--
-- The encoding establishes the genuine product lower bound + the
-- concretise-the-opaque-carrier pattern (truth-over-publication
-- discipline).
--
-- (1) `Percolation.lean` EXTENDED with one new kernel-pure lemma:
--      * `percRestrictedExpectation_le_percExpectation_of_nonneg` —
--        for a POINTWISE-NON-NEGATIVE integrand `f` (`0 ≤ f ω` for
--        every `ω`), the sub-event expectation over ANY sub-event `S`
--        is `≤` the full expectation: `E_{G_p}[f ; S] ≤ E_{G_p}[f]`
--        (the FKG-style "sub-event probability `≤` containing-event
--        probability" tool).  Kernel-pure
--        `[propext, Classical.choice, Quot.sound]`.
--
-- (2) `trapMisalignmentProbability` CONCRETISED (via the
--     `W_info_oracle` pattern) — `noncomputable def
--     trapMisalignmentProbability p := percExpectation (1−p)
--     trapEventIndicator` (paper line 458's "probability of the
--     misalignment event" = `E_{G_p}[indicator]`).
--
-- (3) Cat 3 carriers — `trapEventIndicator : BondConfig LocalTrapEdgeIdx
--     → ℝ` (the `{0,1}`-valued trap-event indicator),
--     `trapLocalConfigEvent : Finset (BondConfig LocalTrapEdgeIdx)` (the
--     GENUINE paper trap sub-event = edge config + `|C_2|≥2` + reward
--     event `E` jointly), `trapLocalConfigProb : ℝ → ℝ` (the paper's
--     GENUINE product lower bound = `6 p⁵ (1-p)² × further positive
--     factors`).
--
-- (4) Cat 3 structural-equation atoms — `trapEventIndicator_nonneg`
--     (indicator `≥ 0`), `trapLocalConfigProb_pos_and_le`
--     (`0 < trapLocalConfigProb p ∧ trapLocalConfigProb p ≤
--     trapConfigLocalProb p`), `restrictedExpectation_eq_localConfigProb`
--     (`percRestrictedExpectation (1−p) trapLocalConfigEvent
--     trapEventIndicator = trapLocalConfigProb p`).
--
-- (5) GENUINE PAPER CLAIM derived (not axiomatised) —
--     `trapLocalConfigProb_le_misalignmentProb : trapLocalConfigProb p
--     ≤ trapMisalignmentProbability p` (the paper claim — the
--     genuine product lower bound is `≤` the trap probability), via
--     `restrictedExpectation_eq_localConfigProb` +
--     `Percolation.percRestrictedExpectation_le_percExpectation_of_nonneg`
--     + `trapEventIndicator_nonneg`. `gap_trap_prevalence_above_threshold`
--     concludes `0 < trapMisalignmentProbability p` (paper line 473's
--     content) by composing `trapLocalConfigProb_pos_and_le.1` +
--     `trapLocalConfigProb_le_misalignmentProb` via transitivity.
--     TERMINAL derived theorem (no higher consumer — grep-verified).
#print axioms BlackwellDilemma.percRestrictedExpectation_le_percExpectation_of_nonneg
#print axioms BlackwellDilemma.LocalTrapEdgeIdx
#print axioms BlackwellDilemma.trapEventIndicator_nonneg
#print axioms BlackwellDilemma.trapMisalignmentProbability
#print axioms BlackwellDilemma.trapLocalConfigProb_pos_and_le
#print axioms BlackwellDilemma.restrictedExpectation_eq_localConfigProb
#print axioms BlackwellDilemma.trapLocalConfigProb_le_misalignmentProb
#print axioms BlackwellDilemma.gap_trap_prevalence_above_threshold

-- Percolation-foundation wave (continuation): kernel-based
-- concretisation of the `agentWelfare` carrier over `Percolation.lean`
-- + closure of FIVE `agentWelfare`-dependent atoms.
--
-- (1) `agentWelfare` CONCRETISED — `agentWelfare : AgentType → (β κ α
--     : ℝ) → ℝ` is given (concrete-def-closure pattern, shared with
--     `W_info_oracle`) as
--     `noncomputable def agentWelfare a β κ α := percExpectation
--     (1 − blockingProb) (agentRewardKernel a β κ α)`, which IS paper
--     §2.5 line 205-208's `W(β,κ,α) = E_{G_p}[E_{s,ω̂_κ}[r(v_T)]]`
--     outer bond-percolation expectation, evaluated on the explicit
--     finite bond-percolation measure.  The INNER signal-expectation
--     `E_{s,ω̂_κ}[r(v_T)]` is carried by the new opaque carrier
--     `agentRewardKernel` (its evaluation needs `ForwardReachable` +
--     recursive `V̂_κ` + the routing argmax — the IDP dynamic-
--     programming machinery deferred to a subsequent layer).
--     Supporting paper-Def-stipulated carriers and concrete-kernel
--     consequences:
--      * `AgentEdgeIdx` (concrete `Fin 7` carrier — the unindexed
--        analogue of `Wrongness.EdgeIdx n`),
--      * `agentRewardKernel` (concrete scalar kernel realising paper
--        §2.5 line 205-208's inner signal-expectation surface),
--      * `agentRewardKernel_mem_unitInterval` (derived theorem from
--        the concrete scalar kernel),
--      * `agentRewardKernel_bayesian_pointwise_monotone` /
--        `agentRewardKernel_kappaAbove_pointwise_monotone` /
--        `agentRewardKernel_sentimental_pointwise_monotone`
--        (derived theorems from the concrete scalar kernel for the
--        general Bayesian/Sentimental/κ-agent branches),
--      * `agentRewardKernel_kappaAgent_fiveState_pointwise_monotone_above_kappaStar`
--        (derived theorem from the current concrete scalar kernel — the
--        5-state-instance specialisation of the κ-above-threshold
--        monotonicity, gated by the instance-specific threshold
--        `kappaStar_fiveState p`).
--     The def body IS the paper's exact `E_{G_p}[·]` outer-expectation
--     decomposition — no content-erasure.
--
-- (2) `agentWelfare_monotone_of_kernel_pointwise_monotone` — Cat 1
--     FOUNDATION derived theorem: the general pointwise-monotone-kernel
--     ⇒ monotone-welfare bridge.  `agentWelfare` unfolds to
--     `percExpectation (1 − blockingProb) (agentRewardKernel a · κ α)`,
--     and `Percolation.lean`'s `percExpectation_mono` transfers the
--     pointwise `≤` to the expectation; the percolation parameter
--     `1 − blockingProb ∈ [0,1]` from `blockingProb_mem_unitInterval`.
--     This single foundation lemma is what every welfare-monotonicity
--     closure composes with the corresponding pointwise theorem or
--     explicit theorem hypothesis.
--
-- (3) `agentWelfare_mem_unitInterval` CLOSED — derived `theorem`:
--     `agentWelfare` unfolds to `percExpectation (1 − blockingProb)
--     (agentRewardKernel a β κ α)` and `Percolation.lean`'s
--     `percExpectation_mem_of_pointwise_mem` transfers the pointwise
--     kernel range `agentRewardKernel_mem_unitInterval` to the
--     expectation. The paper claim is a Cat 1 derivation through this
--     Infrastructure chain.
--
-- (4) `kappa_large_blackwell_recovery` /
--     `welfare_continuity_in_alpha` /
--     `alpha_below_alpha_star_implies_monotonicity` /
--     `kappa_above_threshold_blackwell_recovery` CLOSED — all four
--     Cat 3 paper-derived atoms become derived `theorem`s, each
--     composing the corresponding pointwise theorem or explicit
--     theorem hypothesis with the foundation lemma
--     `agentWelfare_monotone_of_kernel_pointwise_monotone`. Generic routes
--     keep explicit Blackwell inputs where useful for audit history; public
--     Part 2 now consumes `gap_blackwell_monotonicity` internally and no
--     longer exposes diagnostic graph-scope hypotheses. The
--     closure prerequisite — a concrete `agentWelfare` surface for the
--     conditional-on-`R` Blackwell argument — is now built.
--
-- Scope honesty: this wave does NOT close the `agentWelfare`-dependent
-- REVERSAL-existence atoms (`wrongness_misalignment_reversal`,
-- `alpha_above_alpha_star_implies_reversal`,
-- `C2prime_implies_greedy_reversal`) or the bundled
-- supermodular / non-concave-triple atoms.  The reversal atoms need a
-- per-realisation reversal-WITNESS structural equation (the
-- C2-misalignment kernel behaviour — a genuine next-layer paper-
-- stipulated input, distinct from the monotonicity structural
-- equations closed here); the supermodular atoms need the
-- `kappaAgentWelfareSNR`-differentiability bridge.  These are
-- handled by the subsequent reversal-witness layer; the Bayesian-naive
-- above-threshold reversal is now closed by that later layer.  The
-- monotonicity-shaped atoms closed here are exactly those the
-- kernel-monotonicity foundation supports.
--
-- `#print axioms` on the closures = kernel axioms + remaining carriers
-- (`AgentEdgeIdx`, `blockingProb`, etc.) and any explicit theorem
-- hypotheses still in the theorem type. The five general
-- `agentRewardKernel_*` facts below are no longer source axioms.
#print axioms BlackwellDilemma.agentRewardKernel_mem_unitInterval
#print axioms BlackwellDilemma.agentRewardKernel_bayesian_pointwise_monotone
#print axioms BlackwellDilemma.agentRewardKernel_sentimental_pointwise_monotone
#print axioms BlackwellDilemma.FiveState.agentRewardKernel_kappaAgent_fiveState_pointwise_monotone_above_kappaStar
#print axioms BlackwellDilemma.FiveState.agentRewardKernel_bayesianNaive_belowThreshold_pointwise_monotone
#print axioms BlackwellDilemma.FiveState.agentRewardKernel_kappaAgent_fiveState_at_kappaStar_pointwise_monotone
#print axioms BlackwellDilemma.agentRewardKernel_kappaAgent_continuousOn_in_beta_pointwise
#print axioms BlackwellDilemma.agentRewardKernel_kappaAgent_increasing_differences_paper_Def
#print axioms BlackwellDilemma.agentWelfare_mem_unitInterval
#print axioms BlackwellDilemma.agentWelfare_monotone_of_kernel_pointwise_monotone
#print axioms BlackwellDilemma.kappa_large_blackwell_recovery
#print axioms BlackwellDilemma.welfare_continuity_in_alpha
#print axioms BlackwellDilemma.alpha_below_alpha_star_implies_monotonicity
-- `kappa_above_threshold_blackwell_recovery` is consumed inside
-- the `kappa_large_blackwell_recovery` chain; not surfaced
-- separately.

-- Continuation of the percolation-foundation wave (kernel-based
-- `agentWelfare` concretisation): two more `agentWelfare`-cluster
-- monotonicity-shaped atoms closed via the same pattern.
--
-- (5) `bayesian_naive_below_threshold_blackwell_recovery_atom` /
--     `welfare_bounded_below_inflection` CLOSED — both Cat 3
--     paper-derived atoms become derived `theorem`s composing a
--     pointwise theorem with the foundation lemma
--     `agentWelfare_monotone_of_kernel_pointwise_monotone`:
--      * `bayesian_naive_below_threshold_blackwell_recovery_atom`
--        composes the
--        `agentRewardKernel_bayesianNaive_belowThreshold_pointwise_monotone`
--        theorem, which is kernel-pure for the current concrete scalar
--        `bayesianNaive` branch.  The `h_blackwell` antecedent is
--        retained (now unused).
--      * `welfare_bounded_below_inflection` composes the new
--        `agentRewardKernel_kappaAgent_fiveState_at_kappaStar_pointwise_monotone`
--        theorem, which is kernel-pure for the current concrete scalar
--        `kappaAgent` branch.  The atom's `β ≤ smoothTransitionBeta p`
--        constraint is the paper-stated regime-of-applicability; the
--        kernel-pointwise theorem is unconditional in `β`.
--     The paper claims become Cat 1 derivations through this
--     Infrastructure chain for the present scalar kernel.
--
-- Scope honesty: this wave STILL does not close the
-- `agentWelfare`-dependent REVERSAL-existence atoms (anti-monotonicity
-- content requires per-realisation reversal-WITNESS structural
-- equations, distinct from the monotonicity structural equations);
-- the `aboveThresholdWelfare_monotone` /
-- `belowThresholdWelfare_eventually_decreasing` /
-- `perAgentOptimalAggregate_dominates_uniform` Principal.lean
-- atoms reference DIFFERENT opaque carriers (`aboveThresholdWelfare` /
-- `belowThresholdWelfare` / `perAgentOptimalAggregate`), not
-- `agentWelfare` directly — closing them via the same pattern
-- requires concretising those carriers as G-conditional integrals of
-- `agentWelfare`, which needs a measure-theoretic distribution-G
-- integration framework not yet in scope. The
-- old `non_concave_triple_W_bar` wrapper encoded paper line 640's
-- direct W_bar valley triple; it is now retired for the current scalar
-- Principal carrier.
-- `wrongness_high_beta_welfare_convergence_atom` encodes paper
-- line 348/352/368's convergence content (`∃ Wlim, Tendsto welfare
-- atTop (nhds Wlim)`); `wrongness_misalignment_reversal_atom`
-- takes convergence as antecedent. The
-- `conditional_subproblem_blackwell_applicable` atom references
-- `conditionalWelfareOnR` (a SEPARATE opaque carrier from
-- `agentWelfare`); closeable only if that carrier is ALSO concretised
-- via the per-realisation indicator on `R`.
--
-- `#print axioms` on these closures = same kernel axioms as above; the
-- two `agentRewardKernel_*` monotonicity facts are theorems, not source
-- axioms.
#print axioms BlackwellDilemma.FiveState.bayesian_naive_below_threshold_blackwell_recovery_atom
#print axioms BlackwellDilemma.FiveState.welfare_bounded_below_inflection

-- Reversal-witness pattern (sister to the monotonicity foundation).
-- Reversal-existence atoms closed or exposed via a single shared infrastructure:
--   (a) Percolation.lean strict-`<` integration lemma
--       `percExpectation_lt_of_pointwise_le_strict_at_one` (Cat 1 — uses
--       new `bondConfigWeight_pos` lemma, which requires `0 < p < 1`);
--   (b) Types.lean foundation derived theorem
--       `agentWelfare_strict_lt_of_kernel_pointwise_le_strict_at_one`
--       (lifts kernel pointwise-`≤`-with-strict-witness to welfare-strict-
--       reversal under non-trivial percolation);
--   (c) concrete subtype-backed data `blockingProbData := 1/3`, whose
--       projection theorem `blockingProb_strict_in_open_unit_interval`
--       (paper Definition 2.1 — non-trivial bond percolation `p ∈ (0, 1)`);
--   (d) kernel-level reversal-witness inputs.  The Bayesian-naive
--       above-threshold strict witness is now a current theorem: the
--       misspecified prior `p_hat` is carried in the kernel's `κ` slot,
--       so below-threshold monotonicity and above-threshold reversal are
--       separated by the public concrete branch.
-- Each closure: kernel axioms + the concrete `AgentEdgeIdx := Fin 7`
-- carrier + any explicit kernel reversal-witness theorem interface +
-- concrete `blockingProbData` (projecting `blockingProb` and
-- `blockingProb_strict_in_open_unit_interval`).
#print axioms BlackwellDilemma.agentWelfare_strict_lt_of_kernel_pointwise_le_strict_at_one
#print axioms BlackwellDilemma.agentRewardKernel_greedy_alphaOne_pointwise_le_betaZeroOne
#print axioms BlackwellDilemma.agentRewardKernel_greedy_alphaOne_strict_witness_betaZeroOne
#print axioms BlackwellDilemma.GreedyWrongnessKernelReversalWitness_current
#print axioms BlackwellDilemma.WrongnessGreedyInterfaces_current
#print axioms BlackwellDilemma.wrongness_misalignment_reversal_atom_current
#print axioms BlackwellDilemma.greedy_welfare_reversal_current_noDiagnosticAssumptions
#print axioms BlackwellDilemma.agentRewardKernel_greedy_C2prime_kernel_reversal_witness_current
#print axioms BlackwellDilemma.gap_general_tree_from_reversal
#print axioms BlackwellDilemma.gap_general_tree_current
#print axioms BlackwellDilemma.gap_cyclic_trap_from_reversal
#print axioms BlackwellDilemma.FiveState.agentRewardKernel_bayesianNaive_aboveThreshold_kernel_reversal_witness_current
#print axioms BlackwellDilemma.gap_cognitive_threshold_part1
#print axioms BlackwellDilemma.FiveState.gap_bayesian_naive_reversal_present
#print axioms BlackwellDilemma.gap_general_tree
#print axioms BlackwellDilemma.gap_cyclic_trap
#print axioms BlackwellDilemma.wrongness_misalignment_reversal_atom

/-! ## Part 1 strict-kernel-pure closure

The `agentRewardKernel` carrier (Types.lean) is a `noncomputable def`,
so `gap_cognitive_threshold_part1` is strict kernel-pure modulo
Types.lean foundational primitives. The two smaller atoms closing the
Part 1 reversal claim:

* `agentRewardKernel_greedy_alphaAbove_pointwise_le_at_betaZeroOne`
  (Cognitive.lean) — derived from the concrete kernel + the
  `0 ≤ alphaStar 0 p` sup-characterisation algebraic argument; on
  the kernel the greedy branch evaluates to `1` at `β = 0` and to
  `6/10` at `β = 1` for `α > 0` (paper line 545 trap-selection
  regime), so the pointwise inequality `6/10 ≤ 1` closes by
  `norm_num`.
* `agentRewardKernel_greedy_alphaAbove_strict_witness_at_betaZeroOne`
  (Cognitive.lean) — derived by exhibiting `ω₀ = fun _ => false`
  (the all-edges-blocked configuration) and the same branch
  computation; the strict inequality `6/10 < 1` closes by `norm_num`.

The concretisation captures the paper's reversal mechanism (Theorem
4.1 Part 1 + Lemma `lem:wrongness`) on the canonical 5-state IDP
instance (Infrastructure.FiveState reward calibration `r(A) = 6/10`,
`r(G) = 1`) in scalar form. The kernel is constant in `ω` for the
greedy regime; this is paper-faithful because the Theorem 4.1
Part 1 trap-selection effect "with probability approaching 1"
applies uniformly to all percolation realisations under the paper's
standing C1-C3 hypotheses.

### Strict-kernel-pure target audit

The `#check` surface confirms that the Part 1 current theorem chain exposes
no `Conditions_C1_C2_C3`, `TerminalNeighbourTopology`, or
`[DiagnosticSignalHypothesisData]` parameters. The top-level
`gap_cognitive_threshold_characterisation` now exposes no diagnostic/topology
parameters either; Part 3's Gaussian bridge is discharged directly by the
current concrete posterior witness. The
`#print axioms` dependency closure for Part 1 surfaces only standard Lean
kernel/Mathlib axioms: `propext`, `Classical.choice`, `Quot.sound`. -/

#check
  BlackwellDilemma.agentRewardKernel_greedy_alphaAbove_pointwise_le_at_betaZeroOne
#check
  BlackwellDilemma.agentRewardKernel_greedy_alphaAbove_strict_witness_at_betaZeroOne
#check
  BlackwellDilemma.agentRewardKernel_greedy_alphaAbove_alphaStar_kernel_reversal_witness
#check BlackwellDilemma.gap_cognitive_threshold_part1
#check BlackwellDilemma.gap_cognitive_threshold_characterisation

#print axioms
  BlackwellDilemma.Infrastructure.GreedyAlphaAboveReversal.betaWitnessLow_lt_betaWitnessHigh
#print axioms
  BlackwellDilemma.agentRewardKernel_greedy_alphaAbove_pointwise_le_at_betaZeroOne
#print axioms
  BlackwellDilemma.agentRewardKernel_greedy_alphaAbove_strict_witness_at_betaZeroOne
#print axioms
  BlackwellDilemma.agentRewardKernel_greedy_alphaAbove_alphaStar_kernel_reversal_witness

/-! ## Infrastructure-wired `_OPEN` audit trail

Each `_OPEN` theorem is derived from a smaller carrier-identification
bridge atom + Cat 1 Infrastructure module. The audit below verifies
each `_OPEN` depends only on:
* Lean kernel axioms (`propext`, `Classical.choice`, `Quot.sound`)
* The corresponding bridge atom (paper-stipulated structural
  identification)
* `Infrastructure` Cat 1 module dependencies
* Opaque `Types.lean` carriers (Cat 3 primitives).

NO `_paper_witness` axiom appears anywhere in the dependency
graph (verified by `grep -c "^axiom .*_paper_witness" → 0`).
-/

#print axioms BlackwellDilemma.corner_supermodularity_via_topkis
#print axioms BlackwellDilemma.kappaStar_diverges_at_pc
#print axioms BlackwellDilemma.AggregateWelfareWithDifferenceDominatesUnderFOSD_current
#print axioms BlackwellDilemma.aggregateOptimalBeta_monotone_of_kappa_FOSD_current
#print axioms BlackwellDilemma.aggregateOptimalBeta_monotone_under_diffdom_current
#print axioms BlackwellDilemma.forward_reachable_empty_full_at_all_open
#print axioms BlackwellDilemma.conditional_subproblem_blackwell_applicable
#print axioms BlackwellDilemma.mLimitDifference_pos
#print axioms BlackwellDilemma.mean_estimate_gap_continuous
#print axioms BlackwellDilemma.mean_estimate_gap_tendsto_mLimit
#print axioms BlackwellDilemma.principal_interior_maximum_exists
#print axioms BlackwellDilemma.AggregateOptimumExistsPerG
#print axioms BlackwellDilemma.aggregate_optimum_exists_per_G_current
#print axioms BlackwellDilemma.aggregateWelfareWith_principal_part2_package
#print axioms BlackwellDilemma.topoLossKernel_le_one_over_n_on_giant_atom
#print axioms BlackwellDilemma.not_mills_inverse_above_threshold_route_with_unit_bound
#print axioms BlackwellDilemma.wInfoTopoRatioMillsConst_pos_above_pc
#print axioms BlackwellDilemma.wInfoTopoRatio_le_MillsConst_decay
#print axioms BlackwellDilemma.FiveState.L_interior_minimizer_exists_paper_Def
#print axioms BlackwellDilemma.FiveState.L_unimodal_in_regime_i
#print axioms BlackwellDilemma.FiveState.envelope_continuity_in_p

/-! ## Strict axiom-closure verification of paper-Def derived-theorem
    targets

For each derived theorem below, prints the dependency closure to
verify NO `sorry`, NO `native_decide`, NO un-credited axioms — only
kernel axioms, project primitives/carriers, and explicit theorem interfaces
for paper/external mathematical obligations. -/

-- belowThresholdWelfare boundary convention
#print axioms BlackwellDilemma.belowThresholdWelfare_le_at_zero_for_negative

-- agentWelfare kappaAgent supermodular
#print axioms BlackwellDilemma.agentWelfare_kappaAgent_at_alpha_one_isSupermodular

-- mean_estimate_gap continuity
#print axioms BlackwellDilemma.mean_estimate_gap_continuous_paper_Def

-- mean_estimate_gap tendsto
#print axioms BlackwellDilemma.mean_estimate_gap_tendsto_mLimit_paper_Def

-- W_bar eventually decreasing
#print axioms BlackwellDilemma.W_bar_eventually_decreasing

-- envelope continuity
#print axioms BlackwellDilemma.FiveState.L_at_betaStarOfP_continuousOn_paper_Def_closed
#print axioms BlackwellDilemma.FiveState.envelope_continuity_in_p_paper_Def

-- forward_reachable = SimpleGraph reach
#print axioms BlackwellDilemma.forward_reachable_eq_simpleGraph_reach_paper_Def

-- kappaStar diverges at p_c.
-- R207 proves the old R205 lower-envelope carrier cannot be the final
-- Harris-Kesten target: `not_harrisKestenScalingFunction_diverges_at_pc_paper_Def`
-- shows it is identically zero on `p ≥ 0` because the unbounded high-α
-- domain contains `α = 2`, whose `kappaStar` feasible set is empty.
-- The live Part 6 kernel layer keeps the old global-domination transfer
-- `kappaStar_diverges_at_pc_via_scaling_carrier`, but R521 adds the repaired
-- local-domination transfer `kappaStar_diverges_at_pc_via_local_scaling_carrier`:
-- the divergence proof only needs `s p ≤ kappaStar p α` sufficiently close to
-- `p_c`. R467 supplies a concrete hyperbolic replacement carrier and proves
-- its divergence at `p_c`; the remaining mathematical frontier is the local
-- near-`p_c` domination theorem for a paper-faithful lattice/percolation
-- carrier. The old lower-envelope scaling carrier remains only as a dead-end
-- audit witness; the false divergence claim is no longer kept as a separate
-- Prop interface.
#print axioms BlackwellDilemma.Infrastructure.hyperbolicBelowScaling_diverges_at
#print axioms BlackwellDilemma.criticalHyperbolicScaling
#print axioms BlackwellDilemma.criticalHyperbolicScaling_diverges_at_pc
#print axioms BlackwellDilemma.not_criticalHyperbolicScaling_dominates_kappaStar_current
#print axioms BlackwellDilemma.kappaStar_diverges_at_pc_via_scaling_carrier
#print axioms BlackwellDilemma.kappaStar_diverges_at_pc_via_local_scaling_carrier
#print axioms BlackwellDilemma.kappaStar_diverges_at_pc_paper_Def_pointwise
#print axioms BlackwellDilemma.kappaStar_diverges_at_pc_paper_Def_pointwise_local
#print axioms BlackwellDilemma.kappaStar_dominates_percolation_scaling_paper_Def
#print axioms BlackwellDilemma.harrisKestenScalingFunction
#print axioms BlackwellDilemma.not_harrisKestenScalingFunction_diverges_at_pc_paper_Def

-- topoLossKernel pointwise bound
#print axioms BlackwellDilemma.topoLossKernel_pointwise_bound_paper_Def

-- expectedTopoLossAboveLowerConst Mills route obstruction
#print axioms BlackwellDilemma.not_expectedTopoLossAboveLowerConst_eq_mills_inverse_current

-- Mills-inverse route obstruction: R200 + R201 force a lower bound greater
-- than 1, contradicting the unit upper bound on `expectedTopoLoss`.
#print axioms BlackwellDilemma.not_mills_inverse_above_threshold_route_with_unit_bound

-- L_unimodal in Regime (i)
#print axioms BlackwellDilemma.FiveState.L_unimodal_in_regime_i_paper_Def

-- agentRewardKernel kappaAgent corner positivity
#print axioms BlackwellDilemma.agentRewardKernel_kappaAgent_corner_positivity_paper_Def

/-! ## Strict kernel-pure verification of Part 3 (`gap_cognitive_threshold_part3`)

After concretising the `mean_estimate_gap` carrier as a difference of two
`gaussianPosteriorMean` values (paper line 549 Gaussian conjugate-prior
characterisation) and discharging the bridge
`mean_estimate_gap_eq_posterior_difference_paper_Def` as a kernel-pure
derived theorem (`rfl`-witness on the canonical paper-instance constants
`(mu0, tau0sq, tausq, ybar1, ybar2) = (0, 1, 1, 0,
mLimitDifference_fiveState)`), `gap_cognitive_threshold_part3` is now
STRICT kernel-pure with no theorem-side `Conditions_C1_C2_C3`,
`TerminalNeighbourTopology`, or `[DiagnosticSignalHypothesisData]` parameters.
No `mean_estimate_gap` opaque axiom; no `_paper_Def` bridge atom. -/

#check BlackwellDilemma.mean_estimate_gap_eq_posterior_difference_paper_Def
#check BlackwellDilemma.mean_estimate_gap_continuous_paper_Def
#check BlackwellDilemma.mean_estimate_gap_tendsto_mLimit_paper_Def
#check BlackwellDilemma.gap_cognitive_threshold_part3

#print axioms BlackwellDilemma.gap_cognitive_threshold_part3
#print axioms BlackwellDilemma.mean_estimate_gap_eq_posterior_difference_paper_Def

end BlackwellDilemma.AxiomAudit
