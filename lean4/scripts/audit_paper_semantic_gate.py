#!/usr/bin/env python3
"""Audit the paper-semantic kernel-only gate.

The Lean build imports `BlackwellDilemma/PaperSemanticGate.lean`, so the
machine-readable semantic target count is part of `lake build BlackwellDilemma`.
This script is a companion documentation guard:

* the manifest counts and target identifiers in `PaperSemanticGate.lean` must
  match their theorem gates; and
* if any semantic target is still open, public docs must not claim complete
  paper-semantic kernel-only closure.
"""

from __future__ import annotations

import collections
import json
import pathlib
import re
import sys


ROOT = pathlib.Path(__file__).resolve().parents[1]
REPO_ROOT = ROOT.parent
GATE = ROOT / "BlackwellDilemma" / "PaperSemanticGate.lean"
AXIOM_AUDIT = ROOT / "BlackwellDilemma" / "AxiomAudit.lean"
PUBLIC_EVIDENCE_MANIFEST = REPO_ROOT / "reference-evidence" / "public_evidence_manifest.json"
PUBLIC_EVIDENCE_CHECK_ID = "paper_semantic_companion_audit"

EXPECTED_OPEN_KERNEL_SURFACES = {
    "theorem_4_1_part6_lattice_embedding": (
        "Part6LatticeEmbeddingSemanticKernelTarget",
        "Part6NondegenerateFeasibleRepairRoute",
        "part6_lattice_embedding_semantic_kernel_target_iff_repair_route",
        "Part6NondegenerateFeasibleRepairRouteCertificate",
        "part6_nondegenerate_feasible_repair_route_certificate",
        "not_part6_nondegenerate_feasible_repair_route_current",
        "Part6FullPaperClosingSupport",
        "part6_lattice_embedding_semantic_kernel_target_iff_full_support",
        "part6_nondegenerate_feasible_repair_route_iff_full_paper_closing_support",
        "Part6FullPaperClosingOutputLayerCertificate",
        "part6_full_paper_closing_output_layer_certificate",
        "not_part6_full_paper_closing_support_current",
        "Z2LatticeEmbeddingClosedUnitTailReversalBridgeOutputCertificate",
        "z2_lattice_embedding_closed_unit_tail_reversal_bridge_output_certificate",
        "Z2LatticeEmbeddingClosedUnitTailReversalBridgeNonClosureCertificate",
        "z2_lattice_embedding_closed_unit_tail_reversal_bridge_nonclosure_certificate",
        "part6_lattice_embedding_semantic_kernel_target_notYet",
        "Part6CurrentFrontierCertificate",
        "part6_current_frontier_certificate",
    ),
    "topo_cluster_random_supercritical_z2": (
        "TopoClusterRandomSupercriticalZ2SemanticKernelTarget",
        "RandomSupercriticalZ2TopoClusterFullPaperClosingRoute",
        "topo_cluster_random_supercritical_z2_semantic_kernel_target_iff_full_route",
        "RandomSupercriticalZ2TopoClusterFullPaperClosingRouteOutputCertificate",
        "random_supercritical_z2_topo_cluster_full_paper_closing_route_output_certificate",
        "not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute",
        "RandomSupercriticalZ2TopoClusterBoxedTorusFiniteZ2LClosingRoute",
        "topo_cluster_random_supercritical_z2_semantic_kernel_target_iff_boxed_torus_finite_z2L_route",
        "randomSupercriticalZ2TopoClusterFullPaperClosingRoute_iff_boxed_torus_finite_z2L_route",
        "RandomSupercriticalZ2TopoClusterBoxedTorusFiniteZ2LRouteCertificate",
        "random_supercritical_z2_topo_cluster_boxed_torus_finite_z2L_route_certificate",
        "not_randomSupercriticalZ2TopoClusterBoxedTorusFiniteZ2LClosingRoute",
        "RandomSupercriticalZ2TopoClusterSupportSurfaceRepairRouteOutputCertificate",
        "random_supercritical_z2_topo_cluster_support_surface_repair_route_output_certificate",
        "RandomSupercriticalZ2TopoClusterSupportSurfaceRepairNonClosureCertificate",
        "random_supercritical_z2_topo_cluster_support_surface_repair_nonclosure_certificate",
        "topo_cluster_random_supercritical_z2_semantic_kernel_target_notYet",
        "RandomSupercriticalZ2TopoClusterCurrentFrontierCertificate",
        "random_supercritical_z2_topo_cluster_current_frontier_certificate",
    ),
}

EXPECTED_OPEN_FRONTIER_PAYLOAD_SURFACES = {
    "theorem_4_1_part6_lattice_embedding": (
        "part6_lattice_embedding_frontier_payload",
        "Part6LatticeEmbeddingFrontierPayloadCertificate",
        "part6_lattice_embedding_frontier_payload_certificate",
        "Part6LatticeEmbeddingSemanticKernelTarget",
        "part6_lattice_embedding_semantic_kernel_target_notYet",
        "Part6NondegenerateFeasibleRepairRoute",
        "part6_lattice_embedding_semantic_kernel_target_iff_repair_route",
        "Part6NondegenerateFeasibleRepairRouteCertificate",
        "part6_lattice_embedding_frontier_payload_target_route_certificate",
        "part6_lattice_embedding_frontier_payload_target_route_obstruction",
        "Part6FullPaperClosingSupport",
        "part6_lattice_embedding_semantic_kernel_target_iff_full_support",
        "part6_nondegenerate_feasible_repair_route_iff_full_paper_closing_support",
        "Part6FullPaperClosingOutputLayerCertificate",
        "part6_lattice_embedding_frontier_payload_closure_route_certificate",
        "part6_lattice_embedding_frontier_payload_closure_route_obstruction",
        "Z2LatticeEmbeddingClosedUnitTailReversalBridgeOutputCertificate",
        "part6_lattice_embedding_frontier_payload_frontier_progress_certificate",
        "Z2LatticeEmbeddingClosedUnitTailReversalBridgeNonClosureCertificate",
        "part6_lattice_embedding_frontier_payload_frontier_nonclosure_certificate",
        "Part6CurrentFrontierCertificate",
        "part6_lattice_embedding_frontier_payload_current_frontier_certificate",
    ),
    "topo_cluster_random_supercritical_z2": (
        "topo_cluster_random_supercritical_z2_frontier_payload",
        "TopoClusterRandomSupercriticalZ2FrontierPayloadCertificate",
        "topo_cluster_random_supercritical_z2_frontier_payload_certificate",
        "TopoClusterRandomSupercriticalZ2SemanticKernelTarget",
        "topo_cluster_random_supercritical_z2_semantic_kernel_target_notYet",
        "RandomSupercriticalZ2TopoClusterFullPaperClosingRoute",
        "topo_cluster_random_supercritical_z2_semantic_kernel_target_iff_full_route",
        "RandomSupercriticalZ2TopoClusterFullPaperClosingRouteOutputCertificate",
        "topo_cluster_random_supercritical_z2_frontier_payload_target_route_certificate",
        "topo_cluster_random_supercritical_z2_frontier_payload_target_route_obstruction",
        "RandomSupercriticalZ2TopoClusterBoxedTorusFiniteZ2LClosingRoute",
        "topo_cluster_random_supercritical_z2_semantic_kernel_target_iff_boxed_torus_finite_z2L_route",
        "randomSupercriticalZ2TopoClusterFullPaperClosingRoute_iff_boxed_torus_finite_z2L_route",
        "RandomSupercriticalZ2TopoClusterBoxedTorusFiniteZ2LRouteCertificate",
        "topo_cluster_random_supercritical_z2_frontier_payload_closure_route_certificate",
        "topo_cluster_random_supercritical_z2_frontier_payload_closure_route_obstruction",
        "RandomSupercriticalZ2TopoClusterSupportSurfaceRepairRouteOutputCertificate",
        "topo_cluster_random_supercritical_z2_frontier_payload_frontier_progress_certificate",
        "RandomSupercriticalZ2TopoClusterSupportSurfaceRepairNonClosureCertificate",
        "topo_cluster_random_supercritical_z2_frontier_payload_frontier_nonclosure_certificate",
        "RandomSupercriticalZ2TopoClusterCurrentFrontierCertificate",
        "topo_cluster_random_supercritical_z2_frontier_payload_current_frontier_certificate",
    ),
}

EXPECTED_OPEN_CLOSURE_INPUT_SURFACES = {
    "theorem_4_1_part6_lattice_embedding": (
        "Part6LatticeEmbeddingSemanticKernelTarget",
        "Part6LatticeEmbeddingClosureInput",
        "part6_lattice_embedding_semantic_kernel_target_of_closure_input",
        "part6_lattice_embedding_closure_input_notYet",
        "part6_lattice_embedding_semantic_kernel_target_notYet",
        "Part6LatticeEmbeddingClosureInputCertificate",
        "part6_lattice_embedding_closure_input_certificate",
    ),
    "topo_cluster_random_supercritical_z2": (
        "TopoClusterRandomSupercriticalZ2SemanticKernelTarget",
        "TopoClusterRandomSupercriticalZ2ClosureInput",
        "topo_cluster_random_supercritical_z2_semantic_kernel_target_of_closure_input",
        "topo_cluster_random_supercritical_z2_closure_input_notYet",
        "topo_cluster_random_supercritical_z2_semantic_kernel_target_notYet",
        "TopoClusterRandomSupercriticalZ2ClosureInputCertificate",
        "topo_cluster_random_supercritical_z2_closure_input_certificate",
    ),
}

EXPECTED_OPEN_EXACT_CLOSURE_INPUT_SURFACES = {
    "theorem_4_1_part6_lattice_embedding": (
        "Part6LatticeEmbeddingSemanticKernelTarget",
        "Part6LatticeEmbeddingExactClosureInput",
        "Part6LatticeEmbeddingClosureInput",
        "part6_lattice_embedding_exact_closure_input_of_semantic_kernel_target",
        "part6_lattice_embedding_semantic_kernel_target_of_exact_closure_input",
        "part6_lattice_embedding_semantic_kernel_target_iff_exact_closure_input",
        "part6_lattice_embedding_exact_closure_input_of_closure_input",
        "part6_lattice_embedding_exact_closure_input_notYet",
    ),
    "topo_cluster_random_supercritical_z2": (
        "TopoClusterRandomSupercriticalZ2SemanticKernelTarget",
        "TopoClusterRandomSupercriticalZ2ExactClosureInput",
        "TopoClusterRandomSupercriticalZ2ClosureInput",
        "topo_cluster_random_supercritical_z2_exact_closure_input_of_semantic_kernel_target",
        "topo_cluster_random_supercritical_z2_semantic_kernel_target_of_exact_closure_input",
        "topo_cluster_random_supercritical_z2_semantic_kernel_target_iff_exact_closure_input",
        "topo_cluster_random_supercritical_z2_exact_closure_input_of_closure_input",
        "topo_cluster_random_supercritical_z2_exact_closure_input_notYet",
    ),
}

EXPECTED_OPEN_CLOSURE_INPUT_FIELD_SURFACES = {
    "theorem_4_1_part6_lattice_embedding": (
        "Part6LatticeEmbeddingClosureInput",
        "Part6LatticeEmbeddingClosureInputFieldPayload",
        "part6_lattice_embedding_field_payload_of_closure_input",
        "part6_lattice_embedding_closure_input_of_field_payload",
        "part6_lattice_embedding_field_payload_iff_closure_input",
        "part6_lattice_embedding_field_payload_notYet",
        "Part6LatticeEmbeddingClosureInputFieldCertificate",
        "part6_lattice_embedding_closure_input_field_certificate",
    ),
    "topo_cluster_random_supercritical_z2": (
        "TopoClusterRandomSupercriticalZ2ClosureInput",
        "TopoClusterRandomSupercriticalZ2ClosureInputFieldPayload",
        "topo_cluster_random_supercritical_z2_field_payload_of_closure_input",
        "topo_cluster_random_supercritical_z2_closure_input_of_field_payload",
        "topo_cluster_random_supercritical_z2_field_payload_iff_closure_input",
        "topo_cluster_random_supercritical_z2_field_payload_notYet",
        "TopoClusterRandomSupercriticalZ2ClosureInputFieldCertificate",
        "topo_cluster_random_supercritical_z2_closure_input_field_certificate",
    ),
}

EXPECTED_OPEN_CLOSURE_INPUT_FIELD_OUTPUT_SURFACES = {
    "theorem_4_1_part6_lattice_embedding": (
        "Part6LatticeEmbeddingClosureInputFieldPayload",
        "Part6LatticeEmbeddingSemanticKernelTarget",
        "Part6LatticeEmbeddingExactClosureInput",
        "Part6FullPaperClosingFullOutputBundle",
        "part6_lattice_embedding_semantic_kernel_target_of_field_payload",
        "part6_lattice_embedding_exact_closure_input_of_field_payload",
        "part6_lattice_embedding_full_output_bundle_of_field_payload",
        "part6_lattice_embedding_field_payload_notYet",
        "Part6LatticeEmbeddingClosureInputFieldOutputCertificate",
        "part6_lattice_embedding_closure_input_field_output_certificate",
    ),
    "topo_cluster_random_supercritical_z2": (
        "TopoClusterRandomSupercriticalZ2ClosureInputFieldPayload",
        "TopoClusterRandomSupercriticalZ2SemanticKernelTarget",
        "TopoClusterRandomSupercriticalZ2ExactClosureInput",
        "TopoClusterRandomSupercriticalZ2SameBridgeFullOutputBundle",
        "topo_cluster_random_supercritical_z2_semantic_kernel_target_of_field_payload",
        "topo_cluster_random_supercritical_z2_exact_closure_input_of_field_payload",
        "topo_cluster_random_supercritical_z2_same_bridge_full_output_bundle_of_field_payload",
        "topo_cluster_random_supercritical_z2_field_payload_notYet",
        "TopoClusterRandomSupercriticalZ2ClosureInputFieldOutputCertificate",
        "topo_cluster_random_supercritical_z2_closure_input_field_output_certificate",
    ),
}

EXPECTED_OPEN_OUTPUT_EQUIVALENCE_SURFACES = {
    "theorem_4_1_part6_lattice_embedding": (
        "Part6LatticeEmbeddingSemanticKernelTarget",
        "Part6FullPaperClosingFullOutputBundle",
        "part6_lattice_embedding_full_output_bundle_of_semantic_kernel_target",
        "part6_lattice_embedding_semantic_kernel_target_of_full_output_bundle",
        "part6_lattice_embedding_semantic_kernel_target_iff_full_output_bundle",
        "not_part6_full_paper_closing_full_output_bundle_current",
    ),
    "topo_cluster_random_supercritical_z2": (
        "TopoClusterRandomSupercriticalZ2SemanticKernelTarget",
        "TopoClusterRandomSupercriticalZ2SameBridgeFullOutputBundle",
        "topo_cluster_random_supercritical_z2_same_bridge_full_output_bundle_of_semantic_kernel_target",
        "topo_cluster_random_supercritical_z2_semantic_kernel_target_of_same_bridge_full_output_bundle",
        "topo_cluster_random_supercritical_z2_semantic_kernel_target_iff_same_bridge_full_output_bundle",
        "topo_cluster_random_supercritical_z2_same_bridge_full_output_bundle_notYet",
    ),
}

EXPECTED_OPEN_EXACT_CLOSURE_INPUT_OUTPUT_SURFACES = {
    "theorem_4_1_part6_lattice_embedding": (
        "Part6LatticeEmbeddingSemanticKernelTarget",
        "Part6LatticeEmbeddingExactClosureInput",
        "Part6FullPaperClosingFullOutputBundle",
        "part6_lattice_embedding_full_output_bundle_of_exact_closure_input",
        "part6_lattice_embedding_exact_closure_input_of_full_output_bundle",
        "part6_lattice_embedding_exact_closure_input_iff_full_output_bundle",
        "part6_lattice_embedding_semantic_kernel_target_iff_exact_closure_input",
        "part6_lattice_embedding_semantic_kernel_target_iff_full_output_bundle",
        "part6_lattice_embedding_exact_closure_input_notYet",
        "not_part6_full_paper_closing_full_output_bundle_current",
    ),
    "topo_cluster_random_supercritical_z2": (
        "TopoClusterRandomSupercriticalZ2SemanticKernelTarget",
        "TopoClusterRandomSupercriticalZ2ExactClosureInput",
        "TopoClusterRandomSupercriticalZ2SameBridgeFullOutputBundle",
        "topo_cluster_random_supercritical_z2_same_bridge_full_output_bundle_of_exact_closure_input",
        "topo_cluster_random_supercritical_z2_exact_closure_input_of_same_bridge_full_output_bundle",
        "topo_cluster_random_supercritical_z2_exact_closure_input_iff_same_bridge_full_output_bundle",
        "topo_cluster_random_supercritical_z2_semantic_kernel_target_iff_exact_closure_input",
        "topo_cluster_random_supercritical_z2_semantic_kernel_target_iff_same_bridge_full_output_bundle",
        "topo_cluster_random_supercritical_z2_exact_closure_input_notYet",
        "topo_cluster_random_supercritical_z2_same_bridge_full_output_bundle_notYet",
    ),
}

EXPECTED_OPEN_OBSTRUCTION_EQUIVALENCE_SURFACES = {
    "theorem_4_1_part6_lattice_embedding": (
        "Part6LatticeEmbeddingSemanticKernelTarget",
        "Part6LatticeEmbeddingExactClosureInput",
        "Part6FullPaperClosingFullOutputBundle",
        "part6_lattice_embedding_semantic_kernel_target_notYet",
        "part6_lattice_embedding_exact_closure_input_notYet",
        "not_part6_full_paper_closing_full_output_bundle_current",
        "part6_lattice_embedding_semantic_kernel_target_not_iff_exact_closure_input",
        "part6_lattice_embedding_semantic_kernel_target_not_iff_full_output_bundle",
        "part6_lattice_embedding_exact_closure_input_not_iff_full_output_bundle",
    ),
    "topo_cluster_random_supercritical_z2": (
        "TopoClusterRandomSupercriticalZ2SemanticKernelTarget",
        "TopoClusterRandomSupercriticalZ2ExactClosureInput",
        "TopoClusterRandomSupercriticalZ2SameBridgeFullOutputBundle",
        "topo_cluster_random_supercritical_z2_semantic_kernel_target_notYet",
        "topo_cluster_random_supercritical_z2_exact_closure_input_notYet",
        "topo_cluster_random_supercritical_z2_same_bridge_full_output_bundle_notYet",
        "topo_cluster_random_supercritical_z2_semantic_kernel_target_not_iff_exact_closure_input",
        "topo_cluster_random_supercritical_z2_semantic_kernel_target_not_iff_same_bridge_full_output_bundle",
        "topo_cluster_random_supercritical_z2_exact_closure_input_not_iff_same_bridge_full_output_bundle",
    ),
}

CORE_OUTPUT_EQUIVALENCE_DECLS = {
    "Part6FullPaperClosingFullOutputBundle",
    "not_part6_full_paper_closing_full_output_bundle_current",
}

EXPECTED_TOP_LEVEL_CURRENT_OBSTRUCTION_CONJUNCTS = (
    "CompletePaperSemanticKernelOnly ↔ False",
    "paperSemanticClosedCount = 3",
    "closedSemanticTargetIds =",
    "ClosedSemanticTargetsFrontierCertificate",
    "RemainingOpenSemanticTargetsFrontierCertificate",
    "OpenSemanticTargetSurfaceRosterConsistencyCertificate",
    "OpenSemanticTargetAllSurfaceIdsCountCertificate",
    "OpenSemanticTargetAllSurfaceIdsCountStatementRosterCertificate",
    "RemainingOpenSemanticTargetsPayloadRouteMapCertificate",
    "OpenSemanticTargetClosureInputNamedRosterCertificate",
    "OpenSemanticTargetClosureInputStatementRosterCertificate",
    "RemainingOpenSemanticTargetsExactClosureInputCertificate",
    "OpenSemanticTargetExactClosureInputNamedRosterCertificate",
    "OpenSemanticTargetExactClosureInputStatementRosterCertificate",
    "RemainingOpenSemanticTargetsExactClosureInputOutputCertificate",
    "OpenSemanticTargetExactClosureInputOutputNamedRosterCertificate",
    "OpenSemanticTargetExactClosureInputOutputStatementRosterCertificate",
    "RemainingOpenSemanticTargetsObstructionEquivalenceCertificate",
    "OpenSemanticTargetObstructionEquivalenceNamedRosterCertificate",
    "OpenSemanticTargetObstructionEquivalenceStatementRosterCertificate",
    "RemainingOpenSemanticTargetsJointClosureReductionCertificate",
    "RemainingOpenSemanticTargetsJointClosureStatementRosterCertificate",
    "RemainingOpenSemanticTargetsJointRouteObstructionReductionCertificate",
    "RemainingOpenSemanticTargetsJointRouteStatementRosterCertificate",
    "RemainingOpenSemanticTargetsBilateralPackageObstructionCertificate",
    "RemainingOpenSemanticTargetsBilateralPackageObstructionStatementRosterCertificate",
    "OpenSemanticTargetKernelSurfaceRouteObstructionEquivalenceCertificate",
    "OpenSemanticTargetFrontierPayloadRouteObstructionEquivalenceCertificate",
    "OpenSemanticTargetNamedRouteObstructionRosterCertificate",
    "OpenSemanticTargetNamedFrontierCertificateRosterCertificate",
    "OpenSemanticTargetNamedRouteStatementRosterCertificate",
    "Part6RemainingConditionalProjectionCertificate",
    "Part6RemainingConditionalProjectionStatementRosterCertificate",
    "Part6LatticeEmbeddingRouteObstructionProjectionCertificate",
    "Part6LatticeEmbeddingRouteObstructionProjectionStatementRosterCertificate",
    "Part6LatticeEmbeddingClosureInputFieldOutputStatementRosterCertificate",
    "TopoClusterRandomSupercriticalZ2ExactOutputProjectionCertificate",
    "TopoClusterRandomSupercriticalZ2ExactOutputProjectionStatementRosterCertificate",
    "TopoClusterRandomSupercriticalZ2RouteObstructionProjectionCertificate",
    "TopoClusterRandomSupercriticalZ2RouteObstructionProjectionStatementRosterCertificate",
    "TopoClusterRandomSupercriticalZ2ClosureInputFieldOutputStatementRosterCertificate",
    "RemainingOpenSemanticTargetsClosureInputFieldOutputDetailedStatementRosterCertificate",
    "openSemanticTargetClosureInputFieldOutputDetailedStatementRosterIds =",
    "openSemanticTargetClosureInputFieldOutputDetailedStatementRosters.length =",
    "RemainingOpenSemanticTargetsOutputEquivalenceCertificate",
    "OpenSemanticTargetOutputEquivalenceNamedRosterCertificate",
    "OpenSemanticTargetOutputEquivalenceStatementRosterCertificate",
    "RemainingOpenSemanticTargetsClosureInputFieldObstructionCertificate",
    "OpenSemanticTargetClosureInputFieldRosterCertificate",
    "OpenSemanticTargetClosureInputFieldStatementRosterCertificate",
    "RemainingOpenSemanticTargetsClosureInputFieldOutputCertificate",
    "openSemanticTargetClosureInputFieldOutputSurfaceIds =",
    "openSemanticTargetClosureInputFieldOutputSurfaces.length =",
    "OpenSemanticTargetClosureInputFieldOutputRosterCertificate",
    "OpenSemanticTargetClosureInputFieldOutputStatementRosterCertificate",
    "CompletePaperSemanticKernelOnlyCurrentObstructionStatementRosterCertificate",
)

EXPECTED_TOP_LEVEL_CURRENT_OBSTRUCTION_STATEMENT_TERMS = (
    "Not CompletePaperSemanticKernelOnly",
    "paperSemanticOpenCount = 2",
    "openSemanticTargetIds =",
    *EXPECTED_TOP_LEVEL_CURRENT_OBSTRUCTION_CONJUNCTS[:-1],
)

FORBIDDEN_WHEN_OPEN = {
    REPO_ROOT / "README.md": [
        "complete kernel-only audit target",
        "complete paper-semantic kernel-only",
    ],
    ROOT / "README.md": [
        "complete paper-semantic kernel-only proof",
        "complete kernel-only proof of the full manuscript",
    ],
    ROOT / "PAPER_LEAN_CALIBRATION.md": [
        "FULL CORRESPONDENCE",
        "complete kernel-only proof",
    ],
    ROOT / "MATHLIB_CONTRIBUTION_ROADMAP.md": [
        "BlackwellDilemma → Cat 1 only",
        "cat3PaperNovel=94",
        "gapClosed:       341",
        "complete kernel-only target",
    ],
}

REQUIRED_AXIOM_AUDIT_DECLS = {
    "BlackwellDilemma.PaperSemanticGate.paperSemanticOpenCount_current",
    "BlackwellDilemma.PaperSemanticGate.paperSemanticClosedCount_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetIds_current",
    "BlackwellDilemma.PaperSemanticGate.closedSemanticTargetIds_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_target_route",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_target_route_current_obstruction",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_target_route_certificate",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_closure_route",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_route_equivalence",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_target_not_iff_target_route",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_target_not_iff_closure_route",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_target_route_not_iff_closure_route",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_closure_route_current_obstruction",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_closure_route_certificate",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_frontier_progress_certificate",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_frontier_nonclosure_certificate",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfacePayloadCertificates",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceIds_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceCount_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfacePayloadCertificates_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceIds_eq_frontierPayloadSurfaceIds",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurface_certificate",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurface_current_obstruction",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurface_target_route",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurface_target_route_certificate",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurface_target_route_current_obstruction",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurface_closure_route",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurface_route_equivalence",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurface_target_not_iff_target_route",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurface_target_not_iff_closure_route",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurface_target_route_not_iff_closure_route",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurface_closure_route_certificate",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurface_closure_route_current_obstruction",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurface_frontier_progress_certificate",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurface_frontier_nonclosure_certificate",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurface_frontier_certificate",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetSurfaceTargets_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetSurfaceTargetObstructions_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetSurfaceTargetRouteStatements_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetSurfaceClosureRouteStatements_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetSurfaceRouteEquivalenceStatements_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceTargetRouteStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceTargetRouteStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceClosureRouteStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceClosureRouteStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceRouteEquivalenceStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceRouteEquivalenceStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceTargetRouteStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceTargetRouteStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceClosureRouteStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceClosureRouteStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceRouteEquivalenceStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceRouteEquivalenceStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetSurfaceTargetRoutes_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetSurfaceTargetRouteCertificates_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetSurfaceTargetRouteObstructions_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetSurfaceClosureRoutes_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetSurfaceClosureRouteCertificates_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetSurfaceClosureRouteObstructions_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetSurfaceFrontierProgressCertificates_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetSurfaceFrontierNonclosureCertificates_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetSurfaceCurrentFrontierCertificates_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceTargets_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceTargets_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceTargetObstructions_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceTargetObstructions_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceTargetRoutes_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceTargetRoutes_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceTargetRouteCertificates_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceTargetRouteCertificates_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceTargetRouteObstructions_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceTargetRouteObstructions_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceClosureRoutes_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceClosureRoutes_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceClosureRouteCertificates_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceClosureRouteCertificates_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceClosureRouteObstructions_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceClosureRouteObstructions_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceTargets_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceTargets_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceTargetObstructions_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceTargetObstructions_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceTargetRoutes_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceTargetRoutes_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceTargetRouteObstructions_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceTargetRouteObstructions_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceClosureRoutes_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceClosureRoutes_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceClosureRouteObstructions_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceClosureRouteObstructions_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceFrontierProgressCertificates_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceProgressCertificates_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceFrontierNonclosureCertificates_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceNonclosureCertificates_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceCurrentFrontierCertificates_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceCurrentFrontierCertificates_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfacePayloadCertificates_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceTargetRouteCertificates_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceTargetRouteCertificates_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceClosureRouteCertificates_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceClosureRouteCertificates_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceFrontierProgressCertificates_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceProgressCertificates_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceFrontierNonclosureCertificates_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceNonclosureCertificates_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurfaceCurrentFrontierCertificates_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceCurrentFrontierCertificates_length_current",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetSurfaceRosterConsistencyCertificate",
    "BlackwellDilemma.PaperSemanticGate.open_semantic_target_surface_roster_consistency_certificate",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetAllSurfaceIdsCountCertificate",
    "BlackwellDilemma.PaperSemanticGate.open_semantic_target_all_surface_ids_count_certificate",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetAllSurfaceIdsCountStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetAllSurfaceIdsCountStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetAllSurfaceIdsCountStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetAllSurfaceIdsCountStatementRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.open_semantic_target_all_surface_ids_count_statement_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.completePaperSemanticKernelOnlyCurrentObstructionStatements",
    "BlackwellDilemma.PaperSemanticGate.completePaperSemanticKernelOnlyCurrentObstructionStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.completePaperSemanticKernelOnlyCurrentObstructionStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.CompletePaperSemanticKernelOnlyCurrentObstructionStatementRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.completePaperSemanticKernelOnly_current_obstruction_statement_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.CompletePaperSemanticKernelOnlyCurrentObstructionCertificate",
    "BlackwellDilemma.PaperSemanticGate.completePaperSemanticKernelOnly_current_obstruction_certificate",
    "BlackwellDilemma.PaperSemanticGate.RemainingOpenSemanticTargetsPayloadRouteMapCertificate",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_payload_route_map_certificate",
    "BlackwellDilemma.PaperSemanticGate.RemainingOpenSemanticTargetsFrontierCertificate",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_frontier_certificate",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetClosureInputSurface",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurfaces",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurfaceIds",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurfaceTargets",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurfaceClosureInputs",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurfaceInputObstructions",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurfaceTargetObstructions",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurfaceInputCertificates",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurfaceInputToTargetStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurfaceTargetToInputObstructionStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurfaceIds_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurfaceCount_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurfaceTargets_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurfaceClosureInputs_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurfaceInputObstructions_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurfaceTargetObstructions_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurfaceInputCertificates_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurfaceTargets_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurfaceClosureInputs_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurfaceInputObstructions_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurfaceTargetObstructions_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurfaceInputCertificates_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurfaceInputToTargetStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurfaceTargetToInputObstructionStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurfaceInputToTargetStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurfaceTargetToInputObstructionStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurface_input_to_target",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurface_input_not_of_target_not",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurface_input_current_obstruction",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurface_target_current_obstruction",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputSurface_input_certificate",
    "BlackwellDilemma.PaperSemanticGate.RemainingOpenSemanticTargetsClosureInputCertificate",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_closure_input_certificate",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetClosureInputNamedRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.open_semantic_target_closure_input_named_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetClosureInputStatementRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.open_semantic_target_closure_input_statement_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.Part6LatticeEmbeddingExactClosureInput",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_exact_closure_input_of_semantic_kernel_target",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_semantic_kernel_target_of_exact_closure_input",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_semantic_kernel_target_iff_exact_closure_input",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_exact_closure_input_of_closure_input",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_exact_closure_input_notYet",
    "BlackwellDilemma.PaperSemanticGate.TopoClusterRandomSupercriticalZ2ExactClosureInput",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_exact_closure_input_of_semantic_kernel_target",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_semantic_kernel_target_of_exact_closure_input",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_semantic_kernel_target_iff_exact_closure_input",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_exact_closure_input_of_closure_input",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_exact_closure_input_notYet",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetExactClosureInputSurface",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaces",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceIds",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceTargets",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceExactInputs",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceSufficientInputs",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceTargetObstructions",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceExactInputObstructions",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceTargetToExactInputStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceExactInputToTargetStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceTargetIffExactInputStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceSufficientToExactInputStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceTargetNotIffExactInputStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceIds_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceCount_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceTargets_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceExactInputs_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceSufficientInputs_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceTargetObstructions_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceExactInputObstructions_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceTargets_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceExactInputs_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceSufficientInputs_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceTargetObstructions_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceExactInputObstructions_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceTargetToExactInputStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceExactInputToTargetStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceTargetIffExactInputStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceSufficientToExactInputStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceTargetNotIffExactInputStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceTargetToExactInputStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceExactInputToTargetStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceTargetIffExactInputStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceSufficientToExactInputStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurfaceTargetNotIffExactInputStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurface_target_to_exact_input",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurface_exact_input_to_target",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurface_target_iff_exact_input",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurface_target_not_iff_exact_input",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurface_sufficient_to_exact_input",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputSurface_exact_input_current_obstruction",
    "BlackwellDilemma.PaperSemanticGate.RemainingOpenSemanticTargetsExactClosureInputCertificate",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_exact_closure_input_certificate",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetExactClosureInputNamedRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.open_semantic_target_exact_closure_input_named_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetExactClosureInputStatementRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.open_semantic_target_exact_closure_input_statement_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetExactClosureInputOutputSurface",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaces",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceIds",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceTargets",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceExactInputs",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceOutputBundles",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceTargetObstructions",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceExactInputObstructions",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceOutputObstructions",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceExactInputToOutputStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceOutputToExactInputStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceExactInputIffOutputStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceTargetIffExactInputStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceTargetIffOutputStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceTargetNotIffExactInputStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceTargetNotIffOutputStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceExactInputNotIffOutputStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceIds_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceCount_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceTargets_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceExactInputs_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceOutputBundles_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceTargetObstructions_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceExactInputObstructions_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceOutputObstructions_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceTargets_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceExactInputs_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceOutputBundles_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceTargetObstructions_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceExactInputObstructions_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceOutputObstructions_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceExactInputToOutputStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceOutputToExactInputStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceExactInputIffOutputStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceTargetIffExactInputStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceTargetIffOutputStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceTargetNotIffExactInputStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceTargetNotIffOutputStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceExactInputNotIffOutputStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceExactInputToOutputStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceOutputToExactInputStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceExactInputIffOutputStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceTargetIffExactInputStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceTargetIffOutputStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceTargetNotIffExactInputStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceTargetNotIffOutputStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurfaceExactInputNotIffOutputStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurface_exact_input_to_output",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurface_output_to_exact_input",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurface_exact_input_iff_output",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurface_target_iff_exact_input",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurface_target_iff_output",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurface_target_not_iff_exact_input",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurface_target_not_iff_output",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurface_exact_input_not_iff_output",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurface_exact_input_current_obstruction",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetExactClosureInputOutputSurface_output_current_obstruction",
    "BlackwellDilemma.PaperSemanticGate.RemainingOpenSemanticTargetsExactClosureInputOutputCertificate",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_exact_closure_input_output_certificate",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetExactClosureInputOutputNamedRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.open_semantic_target_exact_closure_input_output_named_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetExactClosureInputOutputStatementRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.open_semantic_target_exact_closure_input_output_statement_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetObstructionEquivalenceSurface",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaces",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceIds",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceTargets",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceExactInputs",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceOutputBundles",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceTargetObstructions",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceExactInputObstructions",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceOutputObstructions",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceTargetNotIffExactInputStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceTargetNotIffOutputStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceExactInputNotIffOutputStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceIds_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceCount_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceTargets_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceExactInputs_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceOutputBundles_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceTargetObstructions_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceExactInputObstructions_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceOutputObstructions_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceTargets_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceExactInputs_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceOutputBundles_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceTargetObstructions_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceExactInputObstructions_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceOutputObstructions_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceTargetNotIffExactInputStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceTargetNotIffOutputStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceExactInputNotIffOutputStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceTargetNotIffExactInputStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceTargetNotIffOutputStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurfaceExactInputNotIffOutputStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurface_target_current_obstruction",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurface_exact_input_current_obstruction",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurface_output_current_obstruction",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurface_target_not_iff_exact",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurface_target_not_iff_output",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetObstructionEquivalenceSurface_exact_not_iff_output",
    "BlackwellDilemma.PaperSemanticGate.RemainingOpenSemanticTargetsObstructionEquivalenceCertificate",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_obstruction_equivalence_certificate",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetObstructionEquivalenceNamedRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.open_semantic_target_obstruction_equivalence_named_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetObstructionEquivalenceStatementRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.open_semantic_target_obstruction_equivalence_statement_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.RemainingOpenSemanticTargetsSatisfied",
    "BlackwellDilemma.PaperSemanticGate.RemainingOpenSemanticTargetsExactClosureInputsSatisfied",
    "BlackwellDilemma.PaperSemanticGate.RemainingOpenSemanticTargetsFullOutputBundlesSatisfied",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_exact_inputs_of_targets",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_targets_of_exact_inputs",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_satisfied_iff_exact_closure_inputs",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_outputs_of_targets",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_targets_of_outputs",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_satisfied_iff_full_outputs",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_outputs_of_exact_inputs",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_exact_inputs_of_outputs",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_exact_inputs_iff_full_outputs",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_satisfied_notYet",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_exact_inputs_notYet",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_full_outputs_notYet",
    "BlackwellDilemma.PaperSemanticGate.RemainingOpenSemanticTargetsJointClosureReductionCertificate",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_joint_closure_reduction_certificate",
    "BlackwellDilemma.PaperSemanticGate.remainingOpenSemanticTargetsJointClosureStatements",
    "BlackwellDilemma.PaperSemanticGate.remainingOpenSemanticTargetsJointClosureStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.remainingOpenSemanticTargetsJointClosureStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.RemainingOpenSemanticTargetsJointClosureStatementRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_joint_closure_statement_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.RemainingOpenSemanticTargetsTargetRoutesSatisfied",
    "BlackwellDilemma.PaperSemanticGate.RemainingOpenSemanticTargetsClosureRoutesSatisfied",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_target_routes_of_targets",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_targets_of_target_routes",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_satisfied_iff_target_routes",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_closure_routes_of_targets",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_targets_of_closure_routes",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_satisfied_iff_closure_routes",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_closure_routes_of_target_routes",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_target_routes_of_closure_routes",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_target_routes_iff_closure_routes",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_target_routes_notYet",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_closure_routes_notYet",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_satisfied_not_of_part6_target_not",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_satisfied_not_of_topo_target_not",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_exact_inputs_not_of_part6_exact_input_not",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_exact_inputs_not_of_topo_exact_input_not",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_full_outputs_not_of_part6_output_not",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_full_outputs_not_of_topo_output_not",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_target_routes_not_of_part6_route_not",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_target_routes_not_of_topo_route_not",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_closure_routes_not_of_part6_closure_not",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_closure_routes_not_of_topo_closure_not",
    "BlackwellDilemma.PaperSemanticGate.RemainingOpenSemanticTargetsJointRouteObstructionReductionCertificate",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_joint_route_obstruction_reduction_certificate",
    "BlackwellDilemma.PaperSemanticGate.remainingOpenSemanticTargetsJointRouteStatements",
    "BlackwellDilemma.PaperSemanticGate.remainingOpenSemanticTargetsJointRouteStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.remainingOpenSemanticTargetsJointRouteStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.RemainingOpenSemanticTargetsJointRouteStatementRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_joint_route_statement_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.RemainingOpenSemanticTargetsBilateralPackageObstructionCertificate",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_bilateral_package_obstruction_certificate",
    "BlackwellDilemma.PaperSemanticGate.remainingOpenSemanticTargetsBilateralPackageObstructionStatements",
    "BlackwellDilemma.PaperSemanticGate.remainingOpenSemanticTargetsBilateralPackageObstructionStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.remainingOpenSemanticTargetsBilateralPackageObstructionStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.RemainingOpenSemanticTargetsBilateralPackageObstructionStatementRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_bilateral_package_obstruction_statement_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetKernelSurfaceRouteObstructionEquivalenceCertificate",
    "BlackwellDilemma.PaperSemanticGate.open_semantic_target_kernel_surface_route_obstruction_equivalence_certificate",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetFrontierPayloadRouteObstructionEquivalenceCertificate",
    "BlackwellDilemma.PaperSemanticGate.open_semantic_target_frontier_payload_route_obstruction_equivalence_certificate",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetNamedRouteObstructionRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.open_semantic_target_named_route_obstruction_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetNamedFrontierCertificateRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.open_semantic_target_named_frontier_certificate_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetNamedRouteStatementRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.open_semantic_target_named_route_statement_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_divergence_witness_of_exact_closure_input",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_feasible_divergence_witness_of_exact_closure_input",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_output_pair_of_exact_closure_input",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_divergence_witness_of_full_output_bundle",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_feasible_divergence_witness_of_full_output_bundle",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_output_pair_of_full_output_bundle",
    "BlackwellDilemma.PaperSemanticGate.Part6RemainingConditionalProjectionCertificate",
    "BlackwellDilemma.PaperSemanticGate.part6_remaining_conditional_projection_certificate",
    "BlackwellDilemma.PaperSemanticGate.part6RemainingConditionalProjectionStatements",
    "BlackwellDilemma.PaperSemanticGate.part6RemainingConditionalProjectionStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.part6RemainingConditionalProjectionStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.Part6RemainingConditionalProjectionStatementRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.part6_remaining_conditional_projection_statement_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_exact_closure_input_not_of_repair_route_not",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_exact_closure_input_not_of_full_support_not",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_full_output_bundle_not_of_repair_route_not",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_full_output_bundle_not_of_full_support_not",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_semantic_kernel_target_not_iff_repair_route",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_semantic_kernel_target_not_iff_full_support",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_repair_route_not_iff_full_support_not",
    "BlackwellDilemma.PaperSemanticGate.Part6LatticeEmbeddingRouteObstructionProjectionCertificate",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_route_obstruction_projection_certificate",
    "BlackwellDilemma.PaperSemanticGate.part6LatticeEmbeddingRouteObstructionProjectionStatements",
    "BlackwellDilemma.PaperSemanticGate.part6LatticeEmbeddingRouteObstructionProjectionStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.part6LatticeEmbeddingRouteObstructionProjectionStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.Part6LatticeEmbeddingRouteObstructionProjectionStatementRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_route_obstruction_projection_statement_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_full_route_of_exact_closure_input",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_boxed_route_of_exact_closure_input",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_support_surface_repair_route_of_exact_closure_input",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_support_surface_repair_output_of_exact_closure_input",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_paper_support_output_of_exact_closure_input",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_giant_loss_output_of_exact_closure_input",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_boxed_route_of_same_bridge_full_output_bundle",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_support_surface_repair_route_of_same_bridge_full_output_bundle",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_support_surface_repair_output_of_same_bridge_full_output_bundle",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_paper_support_output_of_same_bridge_full_output_bundle",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_giant_loss_output_of_same_bridge_full_output_bundle",
    "BlackwellDilemma.PaperSemanticGate.TopoClusterRandomSupercriticalZ2ExactOutputProjectionCertificate",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_exact_output_projection_certificate",
    "BlackwellDilemma.PaperSemanticGate.topoClusterRandomSupercriticalZ2ExactOutputProjectionStatements",
    "BlackwellDilemma.PaperSemanticGate.topoClusterRandomSupercriticalZ2ExactOutputProjectionStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.topoClusterRandomSupercriticalZ2ExactOutputProjectionStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.TopoClusterRandomSupercriticalZ2ExactOutputProjectionStatementRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_exact_output_projection_statement_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_exact_closure_input_not_of_full_route_not",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_exact_closure_input_not_of_boxed_route_not",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_same_bridge_full_output_bundle_not_of_full_route_not",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_same_bridge_full_output_bundle_not_of_boxed_route_not",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_semantic_kernel_target_not_iff_full_route",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_semantic_kernel_target_not_iff_boxed_route",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_full_route_not_iff_boxed_route_not",
    "BlackwellDilemma.PaperSemanticGate.TopoClusterRandomSupercriticalZ2RouteObstructionProjectionCertificate",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_route_obstruction_projection_certificate",
    "BlackwellDilemma.PaperSemanticGate.topoClusterRandomSupercriticalZ2RouteObstructionProjectionStatements",
    "BlackwellDilemma.PaperSemanticGate.topoClusterRandomSupercriticalZ2RouteObstructionProjectionStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.topoClusterRandomSupercriticalZ2RouteObstructionProjectionStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.TopoClusterRandomSupercriticalZ2RouteObstructionProjectionStatementRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_route_obstruction_projection_statement_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_divergence_witness_of_closure_input",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_feasible_divergence_witness_of_closure_input",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_output_pair_of_closure_input",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_full_output_bundle_of_closure_input",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_semantic_kernel_target_of_full_output_bundle",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_full_output_bundle_of_semantic_kernel_target",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_semantic_kernel_target_iff_full_output_bundle",
    "BlackwellDilemma.PaperSemanticGate.Part6LatticeEmbeddingClosureInputOutputCertificate",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_closure_input_output_certificate",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_support_surface_repair_route_of_closure_input",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_support_surface_repair_output_of_closure_input",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_paper_support_output_of_closure_input",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_giant_loss_output_of_closure_input",
    "BlackwellDilemma.PaperSemanticGate.TopoClusterRandomSupercriticalZ2SameBridgeFullOutputBundle",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_same_bridge_full_output_bundle_of_full_route",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_full_route_of_same_bridge_full_output_bundle",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_same_bridge_full_output_bundle_of_semantic_kernel_target",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_semantic_kernel_target_of_same_bridge_full_output_bundle",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_semantic_kernel_target_iff_same_bridge_full_output_bundle",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_same_bridge_full_output_bundle_of_closure_input",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_same_bridge_full_output_bundle_notYet",
    "BlackwellDilemma.PaperSemanticGate.TopoClusterRandomSupercriticalZ2ClosureInputOutputCertificate",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_closure_input_output_certificate",
    "BlackwellDilemma.PaperSemanticGate.RemainingOpenSemanticTargetsClosureInputOutputCertificate",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_closure_input_output_certificate",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetOutputEquivalenceSurface",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaces",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceIds",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceTargets",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceOutputBundles",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceTargetObstructions",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceOutputObstructions",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceTargetToOutputStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceOutputToTargetStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceTargetIffOutputStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceTargetNotIffOutputStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceIds_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceCount_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceTargets_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceOutputBundles_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceTargetObstructions_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceOutputObstructions_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceTargets_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceOutputBundles_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceTargetObstructions_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceOutputObstructions_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceTargetToOutputStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceOutputToTargetStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceTargetIffOutputStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceTargetNotIffOutputStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceTargetToOutputStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceOutputToTargetStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceTargetIffOutputStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurfaceTargetNotIffOutputStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurface_target_to_output",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurface_output_to_target",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurface_target_iff_output",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurface_target_not_iff_output",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetOutputEquivalenceSurface_output_current_obstruction",
    "BlackwellDilemma.PaperSemanticGate.RemainingOpenSemanticTargetsOutputEquivalenceCertificate",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_output_equivalence_certificate",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetOutputEquivalenceNamedRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.open_semantic_target_output_equivalence_named_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetOutputEquivalenceStatementRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.open_semantic_target_output_equivalence_statement_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.Part6LatticeEmbeddingClosureInputFieldPayload",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_field_payload_of_closure_input",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_closure_input_of_field_payload",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_field_payload_iff_closure_input",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_field_payload_notYet",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_bridge_route_of_closure_input",
    "BlackwellDilemma.PaperSemanticGate.Part6LatticeEmbeddingClosureInputFieldCertificate",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_closure_input_field_certificate",
    "BlackwellDilemma.PaperSemanticGate.TopoClusterRandomSupercriticalZ2ClosureInputFieldPayload",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_field_payload_of_closure_input",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_closure_input_of_field_payload",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_field_payload_iff_closure_input",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_field_payload_notYet",
    "BlackwellDilemma.PaperSemanticGate.TopoClusterRandomSupercriticalZ2ClosureInputFieldCertificate",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_closure_input_field_certificate",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetClosureInputFieldSurface",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaces",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceIds",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceClosureInputs",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceFieldPayloads",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceFieldPayloadObstructions",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceFieldCertificates",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceIds_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceCount_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceClosureInputs_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceFieldPayloads_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceFieldPayloadObstructions_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceFieldCertificates_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceClosureInputs_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceFieldPayloads_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceFieldPayloadObstructions_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceFieldCertificates_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurface_field_payload",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurface_field_payload_to_closure_input",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurface_field_payload_iff_closure_input",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurface_field_payload_not_iff_closure_input",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurface_field_payload_current_obstruction",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurface_field_certificate",
    "BlackwellDilemma.PaperSemanticGate.RemainingOpenSemanticTargetsClosureInputFieldCertificate",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_closure_input_field_certificate",
    "BlackwellDilemma.PaperSemanticGate.RemainingOpenSemanticTargetsClosureInputFieldObstructionCertificate",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_closure_input_field_obstruction_certificate",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetClosureInputFieldRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.open_semantic_target_closure_input_field_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceClosureInputToFieldPayloadStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceFieldPayloadToClosureInputStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceFieldPayloadIffClosureInputStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceFieldPayloadNotIffClosureInputStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceClosureInputToFieldPayloadStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceFieldPayloadToClosureInputStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceFieldPayloadIffClosureInputStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceFieldPayloadNotIffClosureInputStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceClosureInputToFieldPayloadStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceFieldPayloadToClosureInputStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceFieldPayloadIffClosureInputStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldSurfaceFieldPayloadNotIffClosureInputStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetClosureInputFieldStatementRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.open_semantic_target_closure_input_field_statement_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_semantic_kernel_target_of_field_payload",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_exact_closure_input_of_field_payload",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_divergence_witness_of_field_payload",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_feasible_divergence_witness_of_field_payload",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_output_pair_of_field_payload",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_repair_route_of_field_payload",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_full_output_bundle_of_field_payload",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_full_support_of_field_payload",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_bridge_route_of_field_payload",
    "BlackwellDilemma.PaperSemanticGate.Part6LatticeEmbeddingClosureInputFieldOutputCertificate",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_closure_input_field_output_certificate",
    "BlackwellDilemma.PaperSemanticGate.part6LatticeEmbeddingClosureInputFieldOutputStatements",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_closure_input_field_output_statements_named_current",
    "BlackwellDilemma.PaperSemanticGate.part6LatticeEmbeddingClosureInputFieldOutputStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_closure_input_field_output_statements_length_current",
    "BlackwellDilemma.PaperSemanticGate.Part6LatticeEmbeddingClosureInputFieldOutputStatementRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.part6_lattice_embedding_closure_input_field_output_statement_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_semantic_kernel_target_of_field_payload",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_exact_closure_input_of_field_payload",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_full_route_of_field_payload",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_boxed_route_of_field_payload",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_support_surface_closing_route_of_field_payload",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_support_surface_repair_route_of_field_payload",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_support_surface_repair_output_of_field_payload",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_same_bridge_full_output_bundle_of_field_payload",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_paper_support_output_of_field_payload",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_giant_loss_output_of_field_payload",
    "BlackwellDilemma.PaperSemanticGate.TopoClusterRandomSupercriticalZ2ClosureInputFieldOutputCertificate",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_closure_input_field_output_certificate",
    "BlackwellDilemma.PaperSemanticGate.topoClusterRandomSupercriticalZ2ClosureInputFieldOutputStatements",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_closure_input_field_output_statements_named_current",
    "BlackwellDilemma.PaperSemanticGate.topoClusterRandomSupercriticalZ2ClosureInputFieldOutputStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_closure_input_field_output_statements_length_current",
    "BlackwellDilemma.PaperSemanticGate.TopoClusterRandomSupercriticalZ2ClosureInputFieldOutputStatementRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.topo_cluster_random_supercritical_z2_closure_input_field_output_statement_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputDetailedStatementRosters",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputDetailedStatementRosterIds",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputDetailedStatementRosterIds_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputDetailedStatementRosters_count_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputDetailedStatementRosters_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputDetailedStatementRosters_named_current",
    "BlackwellDilemma.PaperSemanticGate.RemainingOpenSemanticTargetsClosureInputFieldOutputDetailedStatementRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_closure_input_field_output_detailed_statement_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetClosureInputFieldOutputSurface",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaces",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceIds",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceFieldPayloads",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceTargets",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceExactInputs",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceOutputBundles",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceFieldPayloadObstructions",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceFieldOutputCertificates",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceFieldToTargetStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceFieldToExactInputStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceFieldToOutputStatements",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceIds_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceCount_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceFieldPayloads_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceTargets_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceExactInputs_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceOutputBundles_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceFieldPayloadObstructions_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceFieldOutputCertificates_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceFieldPayloads_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceTargets_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceExactInputs_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceOutputBundles_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceFieldPayloadObstructions_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceFieldOutputCertificates_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceFieldToTargetStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceFieldToExactInputStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceFieldToOutputStatements_named_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceFieldToTargetStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceFieldToExactInputStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurfaceFieldToOutputStatements_length_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurface_field_to_target",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurface_field_to_exact_input",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurface_field_to_output",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurface_field_current_obstruction",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetClosureInputFieldOutputSurface_field_output_certificate",
    "BlackwellDilemma.PaperSemanticGate.RemainingOpenSemanticTargetsClosureInputFieldOutputCertificate",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_closure_input_field_output_certificate",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetClosureInputFieldOutputRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.open_semantic_target_closure_input_field_output_roster_certificate",
    "BlackwellDilemma.PaperSemanticGate.OpenSemanticTargetClosureInputFieldOutputStatementRosterCertificate",
    "BlackwellDilemma.PaperSemanticGate.open_semantic_target_closure_input_field_output_statement_roster_certificate",
}


def read(path: pathlib.Path) -> str:
    return path.read_text(encoding="utf-8", errors="replace")


def readme_axiom_audit_required_count(text: str) -> int | None:
    match = re.search(r"AxiomAudit prints required=(\d+)", text)
    if not match:
        return None
    return int(match.group(1))


def theorem_count(text: str, name: str) -> int:
    match = re.search(rf"theorem\s+{re.escape(name)}\s*:\s*[^=]+=\s*(\d+)", text)
    if not match:
        raise SystemExit(f"missing theorem count gate: {name}")
    return int(match.group(1))


def theorem_id_list(text: str, name: str) -> list[str]:
    match = re.search(
        rf"theorem\s+{re.escape(name)}\s*:\s*\w+\s*=\s*(\[[^\]]*\])",
        text,
        flags=re.DOTALL,
    )
    if not match:
        raise SystemExit(f"missing theorem id-list gate: {name}")
    return re.findall(r'"([^"]+)"', match.group(1))


def missing_expected(expected: list[str], actual: list[str]) -> list[str]:
    return sorted(set(expected) - set(actual))


def unexpected_actual(expected: list[str], actual: list[str]) -> list[str]:
    return sorted(set(actual) - set(expected))


def print_id_drift(label: str, expected: list[str], actual: list[str]) -> None:
    print(f"{label}_expected={','.join(expected)}")
    print(f"{label}_missing_expected_count={len(missing_expected(expected, actual))}")
    print(f"{label}_unexpected_count={len(unexpected_actual(expected, actual))}")


def id_drift_lines(label: str, expected: list[str], actual: list[str]) -> list[str]:
    return [
        f"{label}_expected={','.join(expected)}",
        f"{label}_missing_expected_count={len(missing_expected(expected, actual))}",
        f"{label}_unexpected_count={len(unexpected_actual(expected, actual))}",
    ]


def public_manifest_stdout_contains(check_id: str) -> set[str]:
    manifest = json.loads(PUBLIC_EVIDENCE_MANIFEST.read_text(encoding="utf-8"))
    for claim in manifest.get("claims", []):
        for check in claim.get("checks", []):
            if check.get("id") == check_id:
                return set(check.get("stdout_contains", []))
    raise RuntimeError(f"public evidence check id not found: {check_id}")


def public_manifest_missing_stdout_lines(check_id: str, lines: list[str]) -> list[str]:
    manifest_lines = public_manifest_stdout_contains(check_id)
    return [line for line in lines if line not in manifest_lines]


def semantic_target_ids_by_status(text: str) -> tuple[list[str], list[str]]:
    targets = re.findall(
        r'id\s*:=\s*"([^"]+)"(?:(?!id\s*:=).)*?status\s*:=\s*SemanticStatus\.(open|closed)',
        text,
        flags=re.DOTALL,
    )
    if not targets:
        raise SystemExit("no semantic targets found")

    open_ids = [target_id for target_id, status in targets if status == "open"]
    closed_ids = [target_id for target_id, status in targets if status == "closed"]
    return open_ids, closed_ids


def open_kernel_surfaces(text: str) -> list[
    tuple[
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
    ]
]:
    match = re.search(
        r"def\s+openSemanticTargetKernelSurfaces\s*:\s*"
        r"List\s+OpenSemanticTargetKernelSurface\s*:=\s*"
        r"(\[.*?\])\s*\n\s*def\s+openSemanticTargetKernelSurfaceIds",
        text,
        flags=re.DOTALL,
    )
    if not match:
        raise SystemExit("missing open semantic target kernel-surface roster")

    surfaces = re.findall(
        r'id\s*:=\s*"([^"]+)".*?'
        r"target\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"targetRoute\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"targetRouteProof\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"targetRouteCertificate\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"targetRouteCertificateProof\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"targetRouteObstruction\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"closureRoute\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"closureRouteProof\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"routeEquivalenceProof\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"closureRouteCertificate\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"closureRouteCertificateProof\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"closureRouteObstruction\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"frontierProgressCertificate\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"frontierProgressCertificateProof\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"frontierNonclosureCertificate\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"frontierNonclosureCertificateProof\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"currentObstruction\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"frontierCertificate\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"frontierCertificateProof\s*:=\s*([A-Za-z0-9_'.]+)",
        match.group(1),
        flags=re.DOTALL,
    )
    if not surfaces:
        raise SystemExit("no open semantic target kernel-surface entries found")
    return surfaces


def open_frontier_payload_surfaces(
    text: str,
) -> list[
    tuple[
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
    ]
]:
    match = re.search(
        r"def\s+openSemanticTargetFrontierPayloadSurfaces\s*:\s*"
        r"List\s+OpenSemanticTargetFrontierPayloadSurface\s*:=\s*"
        r"(\[.*?\])\s*\n\s*def\s+openSemanticTargetFrontierPayloadSurfaceIds",
        text,
        flags=re.DOTALL,
    )
    if not match:
        raise SystemExit("missing open semantic target frontier-payload roster")

    surfaces = re.findall(
        r'id\s*:=\s*"([^"]+)".*?'
        r"payloadCertificate\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"payloadCertificateProof\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"target\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"targetCurrentObstructionProof\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"targetRoute\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"targetRouteProof\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"targetRouteCertificate\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"targetRouteCertificateProof\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"targetRouteObstructionProof\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"closureRoute\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"closureRouteProof\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"routeEquivalenceProof\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"closureRouteCertificate\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"closureRouteCertificateProof\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"closureRouteObstructionProof\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"frontierProgressCertificate\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"frontierProgressCertificateProof\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"frontierNonclosureCertificate\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"frontierNonclosureCertificateProof\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"frontierCertificate\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"frontierCertificateProof\s*:=\s*([A-Za-z0-9_'.]+)",
        match.group(1),
        flags=re.DOTALL,
    )
    if not surfaces:
        raise SystemExit("no open semantic target frontier-payload entries found")
    return surfaces


def open_closure_input_surfaces(
    text: str,
) -> list[
    tuple[
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
    ]
]:
    match = re.search(
        r"def\s+openSemanticTargetClosureInputSurfaces\s*:\s*"
        r"List\s+OpenSemanticTargetClosureInputSurface\s*:=\s*"
        r"(\[.*?\])\s*\n\s*def\s+openSemanticTargetClosureInputSurfaceIds",
        text,
        flags=re.DOTALL,
    )
    if not match:
        raise SystemExit("missing open semantic target closure-input roster")

    surfaces = re.findall(
        r'id\s*:=\s*"([^"]+)".*?'
        r"target\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"closureInput\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"inputToTarget\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"inputCurrentObstruction\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"targetCurrentObstruction\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"inputCertificate\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"inputCertificateProof\s*:=\s*([A-Za-z0-9_'.]+)",
        match.group(1),
        flags=re.DOTALL,
    )
    if not surfaces:
        raise SystemExit("no open semantic target closure-input entries found")
    return surfaces


def open_exact_closure_input_surfaces(
    text: str,
) -> list[
    tuple[
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
    ]
]:
    match = re.search(
        r"def\s+openSemanticTargetExactClosureInputSurfaces\s*:\s*"
        r"List\s+OpenSemanticTargetExactClosureInputSurface\s*:=\s*"
        r"(\[.*?\])\s*(?:/\--.*?-/\s*)?"
        r"def\s+openSemanticTargetExactClosureInputSurfaceIds",
        text,
        flags=re.DOTALL,
    )
    if not match:
        raise SystemExit("missing open semantic target exact closure-input roster")

    surfaces = re.findall(
        r'id\s*:=\s*"([^"]+)".*?'
        r"target\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"exactClosureInput\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"sufficientClosureInput\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"targetToExactClosureInput\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"exactClosureInputToTarget\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"targetIffExactClosureInput\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"sufficientClosureInputToExactClosureInput\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"exactClosureInputCurrentObstruction\s*:=\s*([A-Za-z0-9_'.]+)",
        match.group(1),
        flags=re.DOTALL,
    )
    if not surfaces:
        raise SystemExit("no open semantic target exact closure-input entries found")
    return surfaces


def open_closure_input_field_surfaces(
    text: str,
) -> list[
    tuple[
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
    ]
]:
    match = re.search(
        r"def\s+openSemanticTargetClosureInputFieldSurfaces\s*:\s*"
        r"List\s+OpenSemanticTargetClosureInputFieldSurface\s*:=\s*"
        r"(\[.*?\])\s*\n\s*def\s+openSemanticTargetClosureInputFieldSurfaceIds",
        text,
        flags=re.DOTALL,
    )
    if not match:
        raise SystemExit("missing open semantic target closure-input field roster")

    surfaces = re.findall(
        r'id\s*:=\s*"([^"]+)".*?'
        r"closureInput\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"fieldPayload\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"fieldPayloadProof\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"fieldPayloadToClosureInput\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"fieldPayloadIffClosureInput\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"fieldPayloadCurrentObstruction\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"fieldCertificate\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"fieldCertificateProof\s*:=\s*([A-Za-z0-9_'.]+)",
        match.group(1),
        flags=re.DOTALL,
    )
    if not surfaces:
        raise SystemExit("no open semantic target closure-input field entries found")
    return surfaces


def open_closure_input_field_output_surfaces(
    text: str,
) -> list[
    tuple[
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
    ]
]:
    match = re.search(
        r"def\s+openSemanticTargetClosureInputFieldOutputSurfaces\s*:\s*"
        r"List\s+OpenSemanticTargetClosureInputFieldOutputSurface\s*:=\s*"
        r"(\[.*?\])\s*\n\s*def\s+openSemanticTargetClosureInputFieldOutputSurfaceIds",
        text,
        flags=re.DOTALL,
    )
    if not match:
        raise SystemExit(
            "missing open semantic target closure-input field-output roster"
        )

    surfaces = re.findall(
        r'id\s*:=\s*"([^"]+)".*?'
        r"fieldPayload\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"target\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"exactClosureInput\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"outputBundle\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"fieldPayloadToTarget\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"fieldPayloadToExactClosureInput\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"fieldPayloadToOutputBundle\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"fieldPayloadCurrentObstruction\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"fieldOutputCertificate\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"fieldOutputCertificateProof\s*:=\s*([A-Za-z0-9_'.]+)",
        match.group(1),
        flags=re.DOTALL,
    )
    if not surfaces:
        raise SystemExit(
            "no open semantic target closure-input field-output entries found"
        )
    return surfaces


def open_output_equivalence_surfaces(
    text: str,
) -> list[
    tuple[
        str,
        str,
        str,
        str,
        str,
        str,
        str,
    ]
]:
    match = re.search(
        r"def\s+openSemanticTargetOutputEquivalenceSurfaces\s*:\s*"
        r"List\s+OpenSemanticTargetOutputEquivalenceSurface\s*:=\s*"
        r"(\[.*?\])\s*(?:/\--.*?-/\s*)?"
        r"def\s+openSemanticTargetOutputEquivalenceSurfaceIds",
        text,
        flags=re.DOTALL,
    )
    if not match:
        raise SystemExit("missing open semantic target output-equivalence roster")

    surfaces = re.findall(
        r'id\s*:=\s*"([^"]+)".*?'
        r"target\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"outputBundle\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"targetToOutputBundle\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"outputBundleToTarget\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"targetIffOutputBundle\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"outputBundleCurrentObstruction\s*:=\s*([A-Za-z0-9_'.]+)",
        match.group(1),
        flags=re.DOTALL,
    )
    if not surfaces:
        raise SystemExit("no open semantic target output-equivalence entries found")
    return surfaces


def open_exact_closure_input_output_surfaces(
    text: str,
) -> list[
    tuple[
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
    ]
]:
    match = re.search(
        r"def\s+openSemanticTargetExactClosureInputOutputSurfaces\s*:\s*"
        r"List\s+OpenSemanticTargetExactClosureInputOutputSurface\s*:=\s*"
        r"(\[.*?\])\s*(?:/\--.*?-/\s*)?"
        r"def\s+openSemanticTargetExactClosureInputOutputSurfaceIds",
        text,
        flags=re.DOTALL,
    )
    if not match:
        raise SystemExit(
            "missing open semantic target exact closure-input/output roster"
        )

    surfaces = re.findall(
        r'id\s*:=\s*"([^"]+)".*?'
        r"target\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"exactClosureInput\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"outputBundle\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"exactClosureInputToOutputBundle\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"outputBundleToExactClosureInput\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"exactClosureInputIffOutputBundle\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"targetIffExactClosureInput\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"targetIffOutputBundle\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"exactClosureInputCurrentObstruction\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"outputBundleCurrentObstruction\s*:=\s*([A-Za-z0-9_'.]+)",
        match.group(1),
        flags=re.DOTALL,
    )
    if not surfaces:
        raise SystemExit(
            "no open semantic target exact closure-input/output entries found"
        )
    return surfaces


def open_obstruction_equivalence_surfaces(
    text: str,
) -> list[
    tuple[
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
        str,
    ]
]:
    match = re.search(
        r"def\s+openSemanticTargetObstructionEquivalenceSurfaces\s*:\s*"
        r"List\s+OpenSemanticTargetObstructionEquivalenceSurface\s*:=\s*"
        r"(\[.*?\])\s*(?:/\--.*?-/\s*)?"
        r"def\s+openSemanticTargetObstructionEquivalenceSurfaceIds",
        text,
        flags=re.DOTALL,
    )
    if not match:
        raise SystemExit(
            "missing open semantic target obstruction-equivalence roster"
        )

    surfaces = re.findall(
        r'id\s*:=\s*"([^"]+)".*?'
        r"target\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"exactClosureInput\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"outputBundle\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"targetCurrentObstruction\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"exactClosureInputCurrentObstruction\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"outputBundleCurrentObstruction\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"targetNotIffExactClosureInput\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"targetNotIffOutputBundle\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"exactClosureInputNotIffOutputBundle\s*:=\s*([A-Za-z0-9_'.]+)",
        match.group(1),
        flags=re.DOTALL,
    )
    if not surfaces:
        raise SystemExit(
            "no open semantic target obstruction-equivalence entries found"
        )
    return surfaces


def top_level_term_is_present(body: str, term: str) -> bool:
    if term == "Not CompletePaperSemanticKernelOnly":
        pattern = r"\bNot\s+CompletePaperSemanticKernelOnly\b"
    elif term == "paperSemanticOpenCount = 2":
        pattern = r"\bpaperSemanticOpenCount\s*=\s*2\b"
    elif term == "openSemanticTargetIds =":
        pattern = r"\bopenSemanticTargetIds\s*="
    elif term == "paperSemanticClosedCount = 3":
        pattern = r"\bpaperSemanticClosedCount\s*=\s*3\b"
    elif term == "closedSemanticTargetIds =":
        pattern = r"\bclosedSemanticTargetIds\s*="
    elif term == "openSemanticTargetClosureInputFieldOutputDetailedStatementRosterIds =":
        pattern = (
            r"\bopenSemanticTargetClosureInputFieldOutputDetailedStatementRosterIds\s*="
        )
    elif term == "openSemanticTargetClosureInputFieldOutputDetailedStatementRosters.length =":
        pattern = (
            r"\bopenSemanticTargetClosureInputFieldOutputDetailedStatementRosters"
            r"\.length\s*="
        )
    elif term == "openSemanticTargetClosureInputFieldOutputSurfaceIds =":
        pattern = r"\bopenSemanticTargetClosureInputFieldOutputSurfaceIds\s*="
    elif term == "openSemanticTargetClosureInputFieldOutputSurfaces.length =":
        pattern = (
            r"\bopenSemanticTargetClosureInputFieldOutputSurfaces"
            r"\.length\s*="
        )
    else:
        pattern = rf"\b{re.escape(term)}\b"
    return re.search(pattern, body) is not None


def top_level_current_obstruction_missing_conjuncts(text: str) -> list[str]:
    match = re.search(
        r"def\s+CompletePaperSemanticKernelOnlyCurrentObstructionCertificate\s*:\s*"
        r"Prop\s*:=\s*(.*?)\n\s*/--\s+The current paper-semantic",
        text,
        flags=re.DOTALL,
    )
    if not match:
        raise SystemExit(
            "missing CompletePaperSemanticKernelOnlyCurrentObstructionCertificate body"
        )
    body = match.group(1)
    return [
        conjunct
        for conjunct in EXPECTED_TOP_LEVEL_CURRENT_OBSTRUCTION_CONJUNCTS
        if not top_level_term_is_present(body, conjunct)
    ]


def top_level_statement_roster_missing_terms(text: str) -> list[str]:
    match = re.search(
        r"def\s+completePaperSemanticKernelOnlyCurrentObstructionStatements\s*:\s*"
        r"List\s+Prop\s*:=\s*(.*?)\n\s*/--\s+Build gate: the top-level",
        text,
        flags=re.DOTALL,
    )
    if not match:
        raise SystemExit(
            "missing completePaperSemanticKernelOnlyCurrentObstructionStatements body"
        )
    body = match.group(1)

    return [
        term
        for term in EXPECTED_TOP_LEVEL_CURRENT_OBSTRUCTION_STATEMENT_TERMS
        if not top_level_term_is_present(body, term)
    ]


def named_current_roster_missing_length_proofs(text: str) -> tuple[int, list[str]]:
    roster_names = sorted(
        set(
            re.findall(
                r"\btheorem\s+([A-Za-z0-9_]+_named_current)\s*:",
                text,
                flags=re.DOTALL,
            )
        )
    )
    missing: list[str] = []
    for roster_name in roster_names:
        length_name = roster_name.removesuffix("_named_current") + "_length_current"
        if (
            re.search(
                rf"\btheorem\s+{re.escape(length_name)}\s*:",
                text,
                flags=re.DOTALL,
            )
            is None
        ):
            missing.append(f"{roster_name}->{length_name}")
    return len(roster_names), missing


def current_roster_theorem_axiom_audit_missing_prints(
    text: str, axiom_audit_text: str
) -> tuple[int, list[str]]:
    theorem_names = sorted(
        set(
            re.findall(
                r"\btheorem\s+([A-Za-z0-9_]+_(?:named|length)_current)\s*:",
                text,
                flags=re.DOTALL,
            )
        )
    )
    missing = [
        f"BlackwellDilemma.PaperSemanticGate.{name}"
        for name in theorem_names
        if not has_axiom_audit_print(
            axiom_audit_text, f"BlackwellDilemma.PaperSemanticGate.{name}"
        )
    ]
    return len(theorem_names), missing


def paper_semantic_current_theorem_axiom_audit_missing_prints(
    text: str, axiom_audit_text: str
) -> tuple[int, list[str]]:
    theorem_names = sorted(
        set(
            re.findall(
                r"\btheorem\s+([A-Za-z0-9_]+_current)\s*:",
                text,
                flags=re.DOTALL,
            )
        )
    )
    missing = [
        f"BlackwellDilemma.PaperSemanticGate.{name}"
        for name in theorem_names
        if not has_axiom_audit_print(
            axiom_audit_text, f"BlackwellDilemma.PaperSemanticGate.{name}"
        )
    ]
    return len(theorem_names), missing


def paper_semantic_theorem_names(text: str) -> list[str]:
    return sorted(
        set(
            re.findall(
                r"\btheorem\s+([A-Za-z0-9_]+)\s*:",
                text,
                flags=re.DOTALL,
            )
        )
    )


def paper_semantic_theorem_axiom_audit_missing_prints(
    text: str, axiom_audit_text: str
) -> tuple[int, list[str]]:
    theorem_names = paper_semantic_theorem_names(text)
    missing = [
        f"BlackwellDilemma.PaperSemanticGate.{name}"
        for name in theorem_names
        if not has_axiom_audit_print(
            axiom_audit_text, f"BlackwellDilemma.PaperSemanticGate.{name}"
        )
    ]
    return len(theorem_names), missing


def paper_semantic_def_names(text: str) -> list[str]:
    return sorted(
        set(
            re.findall(
                r"\bdef\s+([A-Za-z0-9_]+)\s*:",
                text,
                flags=re.DOTALL,
            )
        )
    )


def paper_semantic_def_axiom_audit_missing_prints(
    text: str, axiom_audit_text: str
) -> tuple[int, list[str]]:
    def_names = paper_semantic_def_names(text)
    missing = [
        f"BlackwellDilemma.PaperSemanticGate.{name}"
        for name in def_names
        if not has_axiom_audit_print(
            axiom_audit_text, f"BlackwellDilemma.PaperSemanticGate.{name}"
        )
    ]
    return len(def_names), missing


def paper_semantic_type_names(text: str) -> list[str]:
    return sorted(
        set(
            re.findall(
                r"\b(?:structure|inductive)\s+([A-Za-z0-9_]+)\b",
                text,
                flags=re.DOTALL,
            )
        )
    )


def paper_semantic_type_axiom_audit_missing_prints(
    text: str, axiom_audit_text: str
) -> tuple[int, list[str]]:
    type_names = paper_semantic_type_names(text)
    missing = [
        f"BlackwellDilemma.PaperSemanticGate.{name}"
        for name in type_names
        if not has_axiom_audit_print(
            axiom_audit_text, f"BlackwellDilemma.PaperSemanticGate.{name}"
        )
    ]
    return len(type_names), missing


def paper_semantic_axiom_audit_duplicate_prints(
    axiom_audit_text: str,
) -> tuple[int, list[str]]:
    printed_decls = re.findall(
        r"^\s*#print\s+axioms\s+([A-Za-z0-9_.'α-ωΑ-Ω]+)\s*$",
        axiom_audit_text,
        flags=re.MULTILINE,
    )
    paper_semantic_decls = [
        decl
        for decl in printed_decls
        if decl.startswith("BlackwellDilemma.PaperSemanticGate.")
    ]
    counts = collections.Counter(paper_semantic_decls)
    duplicates = sorted(decl for decl, count in counts.items() if count > 1)
    return len(paper_semantic_decls), duplicates


def has_axiom_audit_print(text: str, decl: str) -> bool:
    return (
        re.search(rf"^\s*#print\s+axioms\s+{re.escape(decl)}\s*$", text, flags=re.MULTILINE)
        is not None
    )


def main() -> int:
    text = read(GATE)
    axiom_audit_text = read(AXIOM_AUDIT)
    lean_readme_text = read(ROOT / "README.md")
    open_ids, closed_ids = semantic_target_ids_by_status(text)
    open_count = len(open_ids)
    closed_count = len(closed_ids)

    expected_open = theorem_count(text, "paperSemanticOpenCount_current")
    expected_closed = theorem_count(text, "paperSemanticClosedCount_current")
    expected_open_ids = theorem_id_list(text, "openSemanticTargetIds_current")
    expected_closed_ids = theorem_id_list(text, "closedSemanticTargetIds_current")
    kernel_surfaces = open_kernel_surfaces(text)
    kernel_surface_ids = [surface[0] for surface in kernel_surfaces]
    payload_surfaces = open_frontier_payload_surfaces(text)
    payload_surface_ids = [surface[0] for surface in payload_surfaces]
    closure_input_surfaces = open_closure_input_surfaces(text)
    closure_input_surface_ids = [surface[0] for surface in closure_input_surfaces]
    exact_closure_input_surfaces = open_exact_closure_input_surfaces(text)
    exact_closure_input_surface_ids = [
        surface[0] for surface in exact_closure_input_surfaces
    ]
    closure_input_field_surfaces = open_closure_input_field_surfaces(text)
    closure_input_field_surface_ids = [
        surface[0] for surface in closure_input_field_surfaces
    ]
    closure_input_field_output_surfaces = open_closure_input_field_output_surfaces(
        text
    )
    closure_input_field_output_surface_ids = [
        surface[0] for surface in closure_input_field_output_surfaces
    ]
    output_equivalence_surfaces = open_output_equivalence_surfaces(text)
    output_equivalence_surface_ids = [
        surface[0] for surface in output_equivalence_surfaces
    ]
    exact_closure_input_output_surfaces = (
        open_exact_closure_input_output_surfaces(text)
    )
    exact_closure_input_output_surface_ids = [
        surface[0] for surface in exact_closure_input_output_surfaces
    ]
    obstruction_equivalence_surfaces = open_obstruction_equivalence_surfaces(text)
    obstruction_equivalence_surface_ids = [
        surface[0] for surface in obstruction_equivalence_surfaces
    ]
    top_level_missing_conjuncts = (
        top_level_current_obstruction_missing_conjuncts(text)
    )
    missing_top_level_statement_roster_terms = (
        top_level_statement_roster_missing_terms(text)
    )
    (
        named_current_roster_count,
        missing_named_current_roster_length_proofs,
    ) = named_current_roster_missing_length_proofs(text)
    (
        current_roster_axiom_audit_count,
        missing_current_roster_axiom_audit_prints,
    ) = current_roster_theorem_axiom_audit_missing_prints(text, axiom_audit_text)
    (
        current_theorem_axiom_audit_count,
        missing_current_theorem_axiom_audit_prints,
    ) = paper_semantic_current_theorem_axiom_audit_missing_prints(
        text, axiom_audit_text
    )
    (
        paper_semantic_theorem_axiom_audit_count,
        missing_paper_semantic_theorem_axiom_audit_prints,
    ) = paper_semantic_theorem_axiom_audit_missing_prints(text, axiom_audit_text)
    (
        paper_semantic_def_axiom_audit_count,
        missing_paper_semantic_def_axiom_audit_prints,
    ) = paper_semantic_def_axiom_audit_missing_prints(text, axiom_audit_text)
    (
        paper_semantic_type_axiom_audit_count,
        missing_paper_semantic_type_axiom_audit_prints,
    ) = paper_semantic_type_axiom_audit_missing_prints(text, axiom_audit_text)
    (
        paper_semantic_axiom_audit_print_count,
        duplicate_paper_semantic_axiom_audit_prints,
    ) = paper_semantic_axiom_audit_duplicate_prints(axiom_audit_text)

    print(f"semantic_targets_open={open_count}")
    print(f"semantic_targets_closed={closed_count}")
    print(f"theorem_gate_open={expected_open}")
    print(f"theorem_gate_closed={expected_closed}")
    print(f"semantic_target_open_ids={','.join(open_ids)}")
    print(f"semantic_target_closed_ids={','.join(closed_ids)}")
    print_id_drift("semantic_target_open_ids", expected_open_ids, open_ids)
    print_id_drift("semantic_target_closed_ids", expected_closed_ids, closed_ids)
    print(
        "semantic_target_closed_frontier_certificate="
        "ClosedSemanticTargetsFrontierCertificate"
    )
    print(
        "semantic_target_closed_frontier_certificate_proof="
        "closed_semantic_targets_frontier_certificate"
    )
    print(
        "semantic_target_closed_frontier_payloads="
        "r10_two_regime_label_recalibration_payload,"
        "part4_lattice_p_monotonicity_frontier_payload,"
        "r10_threshold_five_state_high_kappa_routing_payload"
    )
    print(
        "complete_paper_semantic_kernel_only_current_obstruction_certificate="
        "CompletePaperSemanticKernelOnlyCurrentObstructionCertificate"
    )
    print(
        "complete_paper_semantic_kernel_only_current_obstruction_certificate_proof="
        "completePaperSemanticKernelOnly_current_obstruction_certificate"
    )
    print(
        "complete_paper_semantic_kernel_only_current_obstruction_statement_roster_proof="
        "completePaperSemanticKernelOnlyCurrentObstructionStatements_named_current"
    )
    print(
        "complete_paper_semantic_kernel_only_current_obstruction_statement_roster_certificate="
        "CompletePaperSemanticKernelOnlyCurrentObstructionStatementRosterCertificate"
    )
    print(
        "complete_paper_semantic_kernel_only_current_obstruction_statement_roster_certificate_proof="
        "completePaperSemanticKernelOnly_current_obstruction_statement_roster_certificate"
    )
    print(
        "complete_paper_semantic_kernel_only_current_iff_false_proof="
        "completePaperSemanticKernelOnly_iff_false_current"
    )
    print(
        "complete_paper_semantic_kernel_only_current_obstruction_surface_payload_certificates="
        "OpenSemanticTargetSurfaceRosterConsistencyCertificate,"
        "RemainingOpenSemanticTargetsPayloadRouteMapCertificate"
    )
    print(
        "complete_paper_semantic_kernel_only_current_obstruction_all_surface_ids_count_certificate="
        "OpenSemanticTargetAllSurfaceIdsCountCertificate"
    )
    print(
        "complete_paper_semantic_kernel_only_current_obstruction_all_surface_ids_count_certificate_proof="
        "open_semantic_target_all_surface_ids_count_certificate"
    )
    print(
        "complete_paper_semantic_kernel_only_current_obstruction_all_surface_ids_count_statement_roster="
        "openSemanticTargetAllSurfaceIdsCountStatements"
    )
    print(
        "complete_paper_semantic_kernel_only_current_obstruction_all_surface_ids_count_statement_roster_proof="
        "openSemanticTargetAllSurfaceIdsCountStatements_named_current"
    )
    print(
        "complete_paper_semantic_kernel_only_current_obstruction_all_surface_ids_count_statement_roster_terms_checked=20"
    )
    print(
        "complete_paper_semantic_kernel_only_current_obstruction_all_surface_ids_count_statement_roster_terms_proof="
        "openSemanticTargetAllSurfaceIdsCountStatements_length_current"
    )
    print(
        "complete_paper_semantic_kernel_only_current_obstruction_all_surface_ids_count_statement_roster_certificate="
        "OpenSemanticTargetAllSurfaceIdsCountStatementRosterCertificate"
    )
    print(
        "complete_paper_semantic_kernel_only_current_obstruction_all_surface_ids_count_statement_roster_certificate_proof="
        "open_semantic_target_all_surface_ids_count_statement_roster_certificate"
    )
    print(
        "complete_paper_semantic_kernel_only_current_obstruction_conjuncts_checked="
        f"{len(EXPECTED_TOP_LEVEL_CURRENT_OBSTRUCTION_CONJUNCTS)}"
    )
    print(
        "complete_paper_semantic_kernel_only_current_obstruction_conjuncts_missing="
        f"{len(top_level_missing_conjuncts)}"
    )
    print(
        "complete_paper_semantic_kernel_only_current_obstruction_statement_roster_terms_checked="
        f"{len(EXPECTED_TOP_LEVEL_CURRENT_OBSTRUCTION_STATEMENT_TERMS)}"
    )
    print(
        "complete_paper_semantic_kernel_only_current_obstruction_statement_roster_terms_proof="
        "completePaperSemanticKernelOnlyCurrentObstructionStatements_length_current"
    )
    print(
        "complete_paper_semantic_kernel_only_current_obstruction_statement_roster_terms_missing="
        f"{len(missing_top_level_statement_roster_terms)}"
    )
    print(
        "semantic_target_named_current_roster_length_pairs_checked="
        f"{named_current_roster_count}"
    )
    print(
        "semantic_target_named_current_roster_missing_length_proofs_count="
        f"{len(missing_named_current_roster_length_proofs)}"
    )
    print(
        "semantic_target_named_current_roster_missing_length_proofs="
        + ",".join(missing_named_current_roster_length_proofs)
    )
    print(
        "semantic_target_current_roster_axiom_audit_prints_checked="
        f"{current_roster_axiom_audit_count}"
    )
    print(
        "semantic_target_current_roster_axiom_audit_prints_missing="
        f"{len(missing_current_roster_axiom_audit_prints)}"
    )
    print(
        "semantic_target_current_roster_axiom_audit_prints_missing_decls="
        + ",".join(missing_current_roster_axiom_audit_prints)
    )
    print(
        "semantic_target_current_theorem_axiom_audit_prints_checked="
        f"{current_theorem_axiom_audit_count}"
    )
    print(
        "semantic_target_current_theorem_axiom_audit_prints_missing="
        f"{len(missing_current_theorem_axiom_audit_prints)}"
    )
    print(
        "semantic_target_current_theorem_axiom_audit_prints_missing_decls="
        + ",".join(missing_current_theorem_axiom_audit_prints)
    )
    print(
        "semantic_target_theorem_axiom_audit_prints_checked="
        f"{paper_semantic_theorem_axiom_audit_count}"
    )
    print(
        "semantic_target_theorem_axiom_audit_prints_missing="
        f"{len(missing_paper_semantic_theorem_axiom_audit_prints)}"
    )
    print(
        "semantic_target_theorem_axiom_audit_prints_missing_decls="
        + ",".join(missing_paper_semantic_theorem_axiom_audit_prints)
    )
    print(
        "semantic_target_def_axiom_audit_prints_checked="
        f"{paper_semantic_def_axiom_audit_count}"
    )
    print(
        "semantic_target_def_axiom_audit_prints_missing="
        f"{len(missing_paper_semantic_def_axiom_audit_prints)}"
    )
    print(
        "semantic_target_def_axiom_audit_prints_missing_decls="
        + ",".join(missing_paper_semantic_def_axiom_audit_prints)
    )
    print(
        "semantic_target_type_axiom_audit_prints_checked="
        f"{paper_semantic_type_axiom_audit_count}"
    )
    print(
        "semantic_target_type_axiom_audit_prints_missing="
        f"{len(missing_paper_semantic_type_axiom_audit_prints)}"
    )
    print(
        "semantic_target_type_axiom_audit_prints_missing_decls="
        + ",".join(missing_paper_semantic_type_axiom_audit_prints)
    )
    print(
        "semantic_target_paper_semantic_axiom_audit_prints="
        f"{paper_semantic_axiom_audit_print_count}"
    )
    print(
        "semantic_target_paper_semantic_axiom_audit_duplicate_prints="
        f"{len(duplicate_paper_semantic_axiom_audit_prints)}"
    )
    print(
        "semantic_target_paper_semantic_axiom_audit_duplicate_decls="
        + ",".join(duplicate_paper_semantic_axiom_audit_prints)
    )
    print(f"semantic_target_kernel_surface_ids={','.join(kernel_surface_ids)}")
    print(f"semantic_target_frontier_payload_surface_ids={','.join(payload_surface_ids)}")
    print(f"semantic_target_closure_input_surface_ids={','.join(closure_input_surface_ids)}")
    print(
        "semantic_target_exact_closure_input_surface_ids="
        + ",".join(exact_closure_input_surface_ids)
    )
    print(
        "semantic_target_exact_closure_input_output_surface_ids="
        + ",".join(exact_closure_input_output_surface_ids)
    )
    print(
        "semantic_target_obstruction_equivalence_surface_ids="
        + ",".join(obstruction_equivalence_surface_ids)
    )
    print(
        "semantic_target_closure_input_field_surface_ids="
        + ",".join(closure_input_field_surface_ids)
    )
    print(
        "semantic_target_output_equivalence_surface_ids="
        + ",".join(output_equivalence_surface_ids)
    )
    print_id_drift(
        "semantic_target_kernel_surface_ids",
        list(EXPECTED_OPEN_KERNEL_SURFACES),
        kernel_surface_ids,
    )
    print_id_drift(
        "semantic_target_frontier_payload_surface_ids",
        list(EXPECTED_OPEN_FRONTIER_PAYLOAD_SURFACES),
        payload_surface_ids,
    )
    print_id_drift(
        "semantic_target_closure_input_surface_ids",
        list(EXPECTED_OPEN_CLOSURE_INPUT_SURFACES),
        closure_input_surface_ids,
    )
    print_id_drift(
        "semantic_target_exact_closure_input_surface_ids",
        list(EXPECTED_OPEN_EXACT_CLOSURE_INPUT_SURFACES),
        exact_closure_input_surface_ids,
    )
    print_id_drift(
        "semantic_target_exact_closure_input_output_surface_ids",
        list(EXPECTED_OPEN_EXACT_CLOSURE_INPUT_OUTPUT_SURFACES),
        exact_closure_input_output_surface_ids,
    )
    print_id_drift(
        "semantic_target_obstruction_equivalence_surface_ids",
        list(EXPECTED_OPEN_OBSTRUCTION_EQUIVALENCE_SURFACES),
        obstruction_equivalence_surface_ids,
    )
    print_id_drift(
        "semantic_target_closure_input_field_surface_ids",
        list(EXPECTED_OPEN_CLOSURE_INPUT_FIELD_SURFACES),
        closure_input_field_surface_ids,
    )
    print_id_drift(
        "semantic_target_closure_input_field_output_surface_ids",
        list(EXPECTED_OPEN_CLOSURE_INPUT_FIELD_OUTPUT_SURFACES),
        closure_input_field_output_surface_ids,
    )
    print_id_drift(
        "semantic_target_output_equivalence_surface_ids",
        list(EXPECTED_OPEN_OUTPUT_EQUIVALENCE_SURFACES),
        output_equivalence_surface_ids,
    )
    print(
        "semantic_target_kernel_surface_targets="
        + ",".join(surface[1] for surface in kernel_surfaces)
    )
    print(
        "semantic_target_kernel_surface_target_routes="
        + ",".join(surface[2] for surface in kernel_surfaces)
    )
    print(
        "semantic_target_kernel_surface_target_route_proofs="
        + ",".join(surface[3] for surface in kernel_surfaces)
    )
    print(
        "semantic_target_kernel_surface_target_route_certificates="
        + ",".join(surface[4] for surface in kernel_surfaces)
    )
    print(
        "semantic_target_kernel_surface_target_route_certificate_proofs="
        + ",".join(surface[5] for surface in kernel_surfaces)
    )
    print(
        "semantic_target_kernel_surface_target_route_obstructions="
        + ",".join(surface[6] for surface in kernel_surfaces)
    )
    print(
        "semantic_target_kernel_surface_closure_routes="
        + ",".join(surface[7] for surface in kernel_surfaces)
    )
    print(
        "semantic_target_kernel_surface_closure_route_proofs="
        + ",".join(surface[8] for surface in kernel_surfaces)
    )
    print(
        "semantic_target_kernel_surface_route_equivalence_proofs="
        + ",".join(surface[9] for surface in kernel_surfaces)
    )
    print(
        "semantic_target_kernel_surface_route_obstruction_not_iff_proofs="
        "openSemanticTargetKernelSurface_target_not_iff_target_route,"
        "openSemanticTargetKernelSurface_target_not_iff_closure_route,"
        "openSemanticTargetKernelSurface_target_route_not_iff_closure_route"
    )
    print(
        "semantic_target_kernel_surface_closure_route_certificates="
        + ",".join(surface[10] for surface in kernel_surfaces)
    )
    print(
        "semantic_target_kernel_surface_closure_route_certificate_proofs="
        + ",".join(surface[11] for surface in kernel_surfaces)
    )
    print(
        "semantic_target_kernel_surface_closure_route_obstructions="
        + ",".join(surface[12] for surface in kernel_surfaces)
    )
    print(
        "semantic_target_kernel_surface_frontier_progress_certificates="
        + ",".join(surface[13] for surface in kernel_surfaces)
    )
    print(
        "semantic_target_kernel_surface_frontier_progress_certificate_proofs="
        + ",".join(surface[14] for surface in kernel_surfaces)
    )
    print(
        "semantic_target_kernel_surface_frontier_nonclosure_certificates="
        + ",".join(surface[15] for surface in kernel_surfaces)
    )
    print(
        "semantic_target_kernel_surface_frontier_nonclosure_certificate_proofs="
        + ",".join(surface[16] for surface in kernel_surfaces)
    )
    print(
        "semantic_target_kernel_surface_obstructions="
        + ",".join(surface[17] for surface in kernel_surfaces)
    )
    print(
        "semantic_target_kernel_surface_frontier_certificates="
        + ",".join(surface[18] for surface in kernel_surfaces)
    )
    print(
        "semantic_target_kernel_surface_frontier_proofs="
        + ",".join(surface[19] for surface in kernel_surfaces)
    )
    print(
        "semantic_target_frontier_payload_terms="
        + ",".join(
            EXPECTED_OPEN_FRONTIER_PAYLOAD_SURFACES[surface_id][0]
            for surface_id in payload_surface_ids
            if surface_id in EXPECTED_OPEN_FRONTIER_PAYLOAD_SURFACES
        )
    )
    print(
        "semantic_target_frontier_payload_certificates="
        + ",".join(surface[1] for surface in payload_surfaces)
    )
    print(
        "semantic_target_frontier_payload_certificate_proofs="
        + ",".join(surface[2] for surface in payload_surfaces)
    )
    print(
        "semantic_target_frontier_payload_targets="
        + ",".join(surface[3] for surface in payload_surfaces)
    )
    print(
        "semantic_target_frontier_payload_target_current_obstruction_proofs="
        + ",".join(surface[4] for surface in payload_surfaces)
    )
    print(
        "semantic_target_frontier_payload_target_routes="
        + ",".join(surface[5] for surface in payload_surfaces)
    )
    print(
        "semantic_target_frontier_payload_target_route_proofs="
        + ",".join(surface[6] for surface in payload_surfaces)
    )
    print(
        "semantic_target_frontier_payload_target_route_certificates="
        + ",".join(surface[7] for surface in payload_surfaces)
    )
    print(
        "semantic_target_frontier_payload_target_route_certificate_proofs="
        + ",".join(surface[8] for surface in payload_surfaces)
    )
    print(
        "semantic_target_frontier_payload_target_route_obstruction_proofs="
        + ",".join(surface[9] for surface in payload_surfaces)
    )
    print(
        "semantic_target_frontier_payload_closure_routes="
        + ",".join(surface[10] for surface in payload_surfaces)
    )
    print(
        "semantic_target_frontier_payload_closure_route_proofs="
        + ",".join(surface[11] for surface in payload_surfaces)
    )
    print(
        "semantic_target_frontier_payload_route_equivalence_proofs="
        + ",".join(surface[12] for surface in payload_surfaces)
    )
    print(
        "semantic_target_frontier_payload_route_obstruction_not_iff_proofs="
        "openSemanticTargetFrontierPayloadSurface_target_not_iff_target_route,"
        "openSemanticTargetFrontierPayloadSurface_target_not_iff_closure_route,"
        "openSemanticTargetFrontierPayloadSurface_target_route_not_iff_closure_route"
    )
    print(
        "semantic_target_frontier_payload_closure_route_certificates="
        + ",".join(surface[13] for surface in payload_surfaces)
    )
    print(
        "semantic_target_frontier_payload_closure_route_certificate_proofs="
        + ",".join(surface[14] for surface in payload_surfaces)
    )
    print(
        "semantic_target_frontier_payload_closure_route_obstruction_proofs="
        + ",".join(surface[15] for surface in payload_surfaces)
    )
    print(
        "semantic_target_frontier_payload_progress_certificates="
        + ",".join(surface[16] for surface in payload_surfaces)
    )
    print(
        "semantic_target_frontier_payload_progress_certificate_proofs="
        + ",".join(surface[17] for surface in payload_surfaces)
    )
    print(
        "semantic_target_frontier_payload_nonclosure_certificates="
        + ",".join(surface[18] for surface in payload_surfaces)
    )
    print(
        "semantic_target_frontier_payload_nonclosure_certificate_proofs="
        + ",".join(surface[19] for surface in payload_surfaces)
    )
    print(
        "semantic_target_frontier_payload_frontier_certificates="
        + ",".join(surface[20] for surface in payload_surfaces)
    )
    print(
        "semantic_target_frontier_payload_frontier_certificate_proofs="
        + ",".join(surface[21] for surface in payload_surfaces)
    )
    print(
        "semantic_target_surface_target_consistency="
        "openSemanticTargetSurfaceTargets_current"
    )
    print(
        "semantic_target_surface_target_obstruction_consistency="
        "openSemanticTargetSurfaceTargetObstructions_current"
    )
    print(
        "semantic_target_surface_target_route_statement_consistency="
        "openSemanticTargetSurfaceTargetRouteStatements_current"
    )
    print(
        "semantic_target_surface_closure_route_statement_consistency="
        "openSemanticTargetSurfaceClosureRouteStatements_current"
    )
    print(
        "semantic_target_surface_route_equivalence_statement_consistency="
        "openSemanticTargetSurfaceRouteEquivalenceStatements_current"
    )
    print(
        "semantic_target_named_route_statement_roster_proofs="
        "openSemanticTargetKernelSurfaceTargetRouteStatements_named_current,"
        "openSemanticTargetFrontierPayloadSurfaceTargetRouteStatements_named_current,"
        "openSemanticTargetKernelSurfaceClosureRouteStatements_named_current,"
        "openSemanticTargetFrontierPayloadSurfaceClosureRouteStatements_named_current,"
        "openSemanticTargetKernelSurfaceRouteEquivalenceStatements_named_current,"
        "openSemanticTargetFrontierPayloadSurfaceRouteEquivalenceStatements_named_current"
    )
    print("semantic_target_named_route_statement_roster_terms_checked=12")
    print(
        "semantic_target_named_route_statement_roster_length_proofs="
        "openSemanticTargetKernelSurfaceTargetRouteStatements_length_current,"
        "openSemanticTargetFrontierPayloadSurfaceTargetRouteStatements_length_current,"
        "openSemanticTargetKernelSurfaceClosureRouteStatements_length_current,"
        "openSemanticTargetFrontierPayloadSurfaceClosureRouteStatements_length_current,"
        "openSemanticTargetKernelSurfaceRouteEquivalenceStatements_length_current,"
        "openSemanticTargetFrontierPayloadSurfaceRouteEquivalenceStatements_length_current"
    )
    print(
        "semantic_target_surface_target_route_consistency="
        "openSemanticTargetSurfaceTargetRoutes_current"
    )
    print(
        "semantic_target_surface_target_route_certificate_consistency="
        "openSemanticTargetSurfaceTargetRouteCertificates_current"
    )
    print(
        "semantic_target_surface_target_route_obstruction_consistency="
        "openSemanticTargetSurfaceTargetRouteObstructions_current"
    )
    print(
        "semantic_target_surface_closure_route_consistency="
        "openSemanticTargetSurfaceClosureRoutes_current"
    )
    print(
        "semantic_target_surface_closure_route_certificate_consistency="
        "openSemanticTargetSurfaceClosureRouteCertificates_current"
    )
    print(
        "semantic_target_surface_closure_route_obstruction_consistency="
        "openSemanticTargetSurfaceClosureRouteObstructions_current"
    )
    print(
        "semantic_target_surface_frontier_progress_consistency="
        "openSemanticTargetSurfaceFrontierProgressCertificates_current"
    )
    print(
        "semantic_target_surface_frontier_nonclosure_consistency="
        "openSemanticTargetSurfaceFrontierNonclosureCertificates_current"
    )
    print(
        "semantic_target_surface_current_frontier_consistency="
        "openSemanticTargetSurfaceCurrentFrontierCertificates_current"
    )
    print(
        "semantic_target_named_route_obstruction_roster_proofs="
        "openSemanticTargetKernelSurfaceTargets_named_current,"
        "openSemanticTargetFrontierPayloadSurfaceTargets_named_current,"
        "openSemanticTargetKernelSurfaceTargetObstructions_named_current,"
        "openSemanticTargetFrontierPayloadSurfaceTargetObstructions_named_current,"
        "openSemanticTargetKernelSurfaceTargetRoutes_named_current,"
        "openSemanticTargetFrontierPayloadSurfaceTargetRoutes_named_current,"
        "openSemanticTargetKernelSurfaceTargetRouteObstructions_named_current,"
        "openSemanticTargetFrontierPayloadSurfaceTargetRouteObstructions_named_current,"
        "openSemanticTargetKernelSurfaceClosureRoutes_named_current,"
        "openSemanticTargetFrontierPayloadSurfaceClosureRoutes_named_current,"
        "openSemanticTargetKernelSurfaceClosureRouteObstructions_named_current,"
        "openSemanticTargetFrontierPayloadSurfaceClosureRouteObstructions_named_current"
    )
    print("semantic_target_named_route_obstruction_roster_terms_checked=24")
    print(
        "semantic_target_named_route_obstruction_roster_length_proofs="
        "openSemanticTargetKernelSurfaceTargets_length_current,"
        "openSemanticTargetFrontierPayloadSurfaceTargets_length_current,"
        "openSemanticTargetKernelSurfaceTargetObstructions_length_current,"
        "openSemanticTargetFrontierPayloadSurfaceTargetObstructions_length_current,"
        "openSemanticTargetKernelSurfaceTargetRoutes_length_current,"
        "openSemanticTargetFrontierPayloadSurfaceTargetRoutes_length_current,"
        "openSemanticTargetKernelSurfaceTargetRouteObstructions_length_current,"
        "openSemanticTargetFrontierPayloadSurfaceTargetRouteObstructions_length_current,"
        "openSemanticTargetKernelSurfaceClosureRoutes_length_current,"
        "openSemanticTargetFrontierPayloadSurfaceClosureRoutes_length_current,"
        "openSemanticTargetKernelSurfaceClosureRouteObstructions_length_current,"
        "openSemanticTargetFrontierPayloadSurfaceClosureRouteObstructions_length_current"
    )
    print(
        "semantic_target_named_frontier_certificate_roster_proofs="
        "openSemanticTargetFrontierPayloadSurfacePayloadCertificates_named_current,"
        "openSemanticTargetKernelSurfaceTargetRouteCertificates_named_current,"
        "openSemanticTargetFrontierPayloadSurfaceTargetRouteCertificates_named_current,"
        "openSemanticTargetKernelSurfaceClosureRouteCertificates_named_current,"
        "openSemanticTargetFrontierPayloadSurfaceClosureRouteCertificates_named_current,"
        "openSemanticTargetKernelSurfaceFrontierProgressCertificates_named_current,"
        "openSemanticTargetFrontierPayloadSurfaceProgressCertificates_named_current,"
        "openSemanticTargetKernelSurfaceFrontierNonclosureCertificates_named_current,"
        "openSemanticTargetFrontierPayloadSurfaceNonclosureCertificates_named_current,"
        "openSemanticTargetKernelSurfaceCurrentFrontierCertificates_named_current,"
        "openSemanticTargetFrontierPayloadSurfaceCurrentFrontierCertificates_named_current"
    )
    print("semantic_target_named_frontier_certificate_roster_terms_checked=22")
    print(
        "semantic_target_named_frontier_certificate_roster_length_proofs="
        "openSemanticTargetFrontierPayloadSurfacePayloadCertificates_length_current,"
        "openSemanticTargetKernelSurfaceTargetRouteCertificates_length_current,"
        "openSemanticTargetFrontierPayloadSurfaceTargetRouteCertificates_length_current,"
        "openSemanticTargetKernelSurfaceClosureRouteCertificates_length_current,"
        "openSemanticTargetFrontierPayloadSurfaceClosureRouteCertificates_length_current,"
        "openSemanticTargetKernelSurfaceFrontierProgressCertificates_length_current,"
        "openSemanticTargetFrontierPayloadSurfaceProgressCertificates_length_current,"
        "openSemanticTargetKernelSurfaceFrontierNonclosureCertificates_length_current,"
        "openSemanticTargetFrontierPayloadSurfaceNonclosureCertificates_length_current,"
        "openSemanticTargetKernelSurfaceCurrentFrontierCertificates_length_current,"
        "openSemanticTargetFrontierPayloadSurfaceCurrentFrontierCertificates_length_current"
    )
    print(
        "semantic_target_surface_roster_consistency_certificate="
        "OpenSemanticTargetSurfaceRosterConsistencyCertificate"
    )
    print(
        "semantic_target_surface_roster_consistency_certificate_proof="
        "open_semantic_target_surface_roster_consistency_certificate"
    )
    print(
        "semantic_target_payload_route_map_certificate="
        "RemainingOpenSemanticTargetsPayloadRouteMapCertificate"
    )
    print(
        "semantic_target_payload_route_map_certificate_proof="
        "remaining_open_semantic_targets_payload_route_map_certificate"
    )
    print(
        "semantic_target_closure_input_targets="
        + ",".join(surface[1] for surface in closure_input_surfaces)
    )
    print(
        "semantic_target_closure_inputs="
        + ",".join(surface[2] for surface in closure_input_surfaces)
    )
    print(
        "semantic_target_closure_input_to_target_proofs="
        + ",".join(surface[3] for surface in closure_input_surfaces)
    )
    print(
        "semantic_target_closure_input_obstructions="
        + ",".join(surface[4] for surface in closure_input_surfaces)
    )
    print(
        "semantic_target_closure_input_target_obstructions="
        + ",".join(surface[5] for surface in closure_input_surfaces)
    )
    print(
        "semantic_target_closure_input_certificates="
        + ",".join(surface[6] for surface in closure_input_surfaces)
    )
    print(
        "semantic_target_closure_input_certificate_proofs="
        + ",".join(surface[7] for surface in closure_input_surfaces)
    )
    print(
        "semantic_target_closure_input_certificate="
        "RemainingOpenSemanticTargetsClosureInputCertificate"
    )
    print(
        "semantic_target_closure_input_certificate_proof="
        "remaining_open_semantic_targets_closure_input_certificate"
    )
    print(
        "semantic_target_closure_input_named_roster_proofs="
        "openSemanticTargetClosureInputSurfaceTargets_named_current,"
        "openSemanticTargetClosureInputSurfaceClosureInputs_named_current,"
        "openSemanticTargetClosureInputSurfaceInputObstructions_named_current,"
        "openSemanticTargetClosureInputSurfaceTargetObstructions_named_current,"
        "openSemanticTargetClosureInputSurfaceInputCertificates_named_current"
    )
    print("semantic_target_closure_input_named_roster_terms_checked=10")
    print(
        "semantic_target_closure_input_named_roster_length_proofs="
        "openSemanticTargetClosureInputSurfaceTargets_length_current,"
        "openSemanticTargetClosureInputSurfaceClosureInputs_length_current,"
        "openSemanticTargetClosureInputSurfaceInputObstructions_length_current,"
        "openSemanticTargetClosureInputSurfaceTargetObstructions_length_current,"
        "openSemanticTargetClosureInputSurfaceInputCertificates_length_current"
    )
    print(
        "semantic_target_closure_input_statement_roster_proofs="
        "openSemanticTargetClosureInputSurfaceInputToTargetStatements_named_current,"
        "openSemanticTargetClosureInputSurfaceTargetToInputObstructionStatements_named_current"
    )
    print("semantic_target_closure_input_statement_roster_terms_checked=4")
    print(
        "semantic_target_closure_input_statement_roster_length_proofs="
        "openSemanticTargetClosureInputSurfaceInputToTargetStatements_length_current,"
        "openSemanticTargetClosureInputSurfaceTargetToInputObstructionStatements_length_current"
    )
    print(
        "semantic_target_closure_input_target_to_input_obstruction_projection="
        "openSemanticTargetClosureInputSurface_input_not_of_target_not"
    )
    print(
        "semantic_target_closure_input_named_roster_certificate="
        "OpenSemanticTargetClosureInputNamedRosterCertificate"
    )
    print(
        "semantic_target_closure_input_named_roster_certificate_proof="
        "open_semantic_target_closure_input_named_roster_certificate"
    )
    print(
        "semantic_target_closure_input_statement_roster_certificate="
        "OpenSemanticTargetClosureInputStatementRosterCertificate"
    )
    print(
        "semantic_target_closure_input_statement_roster_certificate_proof="
        "open_semantic_target_closure_input_statement_roster_certificate"
    )
    print(
        "semantic_target_exact_closure_input_targets="
        + ",".join(surface[1] for surface in exact_closure_input_surfaces)
    )
    print(
        "semantic_target_exact_closure_inputs="
        + ",".join(surface[2] for surface in exact_closure_input_surfaces)
    )
    print(
        "semantic_target_exact_closure_sufficient_inputs="
        + ",".join(surface[3] for surface in exact_closure_input_surfaces)
    )
    print(
        "semantic_target_exact_closure_target_to_input_proofs="
        + ",".join(surface[4] for surface in exact_closure_input_surfaces)
    )
    print(
        "semantic_target_exact_closure_input_to_target_proofs="
        + ",".join(surface[5] for surface in exact_closure_input_surfaces)
    )
    print(
        "semantic_target_exact_closure_iff_proofs="
        + ",".join(surface[6] for surface in exact_closure_input_surfaces)
    )
    print(
        "semantic_target_exact_closure_sufficient_to_exact_proofs="
        + ",".join(surface[7] for surface in exact_closure_input_surfaces)
    )
    print(
        "semantic_target_exact_closure_input_obstructions="
        + ",".join(surface[8] for surface in exact_closure_input_surfaces)
    )
    print(
        "semantic_target_exact_closure_input_certificate="
        "RemainingOpenSemanticTargetsExactClosureInputCertificate"
    )
    print(
        "semantic_target_exact_closure_input_certificate_proof="
        "remaining_open_semantic_targets_exact_closure_input_certificate"
    )
    print(
        "semantic_target_exact_closure_named_roster_proofs="
        "openSemanticTargetExactClosureInputSurfaceTargets_named_current,"
        "openSemanticTargetExactClosureInputSurfaceExactInputs_named_current,"
        "openSemanticTargetExactClosureInputSurfaceSufficientInputs_named_current,"
        "openSemanticTargetExactClosureInputSurfaceTargetObstructions_named_current,"
        "openSemanticTargetExactClosureInputSurfaceExactInputObstructions_named_current"
    )
    print("semantic_target_exact_closure_named_roster_terms_checked=10")
    print(
        "semantic_target_exact_closure_named_roster_length_proofs="
        "openSemanticTargetExactClosureInputSurfaceTargets_length_current,"
        "openSemanticTargetExactClosureInputSurfaceExactInputs_length_current,"
        "openSemanticTargetExactClosureInputSurfaceSufficientInputs_length_current,"
        "openSemanticTargetExactClosureInputSurfaceTargetObstructions_length_current,"
        "openSemanticTargetExactClosureInputSurfaceExactInputObstructions_length_current"
    )
    print(
        "semantic_target_exact_closure_target_not_iff_exact_proof="
        "openSemanticTargetExactClosureInputSurface_target_not_iff_exact_input"
    )
    print(
        "semantic_target_exact_closure_named_roster_certificate="
        "OpenSemanticTargetExactClosureInputNamedRosterCertificate"
    )
    print(
        "semantic_target_exact_closure_named_roster_certificate_proof="
        "open_semantic_target_exact_closure_input_named_roster_certificate"
    )
    print(
        "semantic_target_exact_closure_input_statement_roster_proofs="
        "openSemanticTargetExactClosureInputSurfaceTargetToExactInputStatements_named_current,"
        "openSemanticTargetExactClosureInputSurfaceExactInputToTargetStatements_named_current,"
        "openSemanticTargetExactClosureInputSurfaceTargetIffExactInputStatements_named_current,"
        "openSemanticTargetExactClosureInputSurfaceSufficientToExactInputStatements_named_current,"
        "openSemanticTargetExactClosureInputSurfaceTargetNotIffExactInputStatements_named_current"
    )
    print("semantic_target_exact_closure_input_statement_roster_terms_checked=10")
    print(
        "semantic_target_exact_closure_input_statement_roster_length_proofs="
        "openSemanticTargetExactClosureInputSurfaceTargetToExactInputStatements_length_current,"
        "openSemanticTargetExactClosureInputSurfaceExactInputToTargetStatements_length_current,"
        "openSemanticTargetExactClosureInputSurfaceTargetIffExactInputStatements_length_current,"
        "openSemanticTargetExactClosureInputSurfaceSufficientToExactInputStatements_length_current,"
        "openSemanticTargetExactClosureInputSurfaceTargetNotIffExactInputStatements_length_current"
    )
    print(
        "semantic_target_exact_closure_input_statement_roster_certificate="
        "OpenSemanticTargetExactClosureInputStatementRosterCertificate"
    )
    print(
        "semantic_target_exact_closure_input_statement_roster_certificate_proof="
        "open_semantic_target_exact_closure_input_statement_roster_certificate"
    )
    print(
        "semantic_target_closure_input_output_certificates="
        "Part6LatticeEmbeddingClosureInputOutputCertificate,"
        "TopoClusterRandomSupercriticalZ2ClosureInputOutputCertificate"
    )
    print(
        "semantic_target_closure_input_output_certificate_proofs="
        "part6_lattice_embedding_closure_input_output_certificate,"
        "topo_cluster_random_supercritical_z2_closure_input_output_certificate"
    )
    print(
        "semantic_target_closure_input_output_certificate="
        "RemainingOpenSemanticTargetsClosureInputOutputCertificate"
    )
    print(
        "semantic_target_closure_input_output_certificate_proof="
        "remaining_open_semantic_targets_closure_input_output_certificate"
    )
    print(
        "semantic_target_output_equivalence_targets="
        + ",".join(surface[1] for surface in output_equivalence_surfaces)
    )
    print(
        "semantic_target_output_equivalence_bundles="
        + ",".join(surface[2] for surface in output_equivalence_surfaces)
    )
    print(
        "semantic_target_output_equivalence_target_to_output_proofs="
        + ",".join(surface[3] for surface in output_equivalence_surfaces)
    )
    print(
        "semantic_target_output_equivalence_output_to_target_proofs="
        + ",".join(surface[4] for surface in output_equivalence_surfaces)
    )
    print(
        "semantic_target_output_equivalence_iff_proofs="
        + ",".join(surface[5] for surface in output_equivalence_surfaces)
    )
    print(
        "semantic_target_output_equivalence_obstructions="
        + ",".join(surface[6] for surface in output_equivalence_surfaces)
    )
    print(
        "semantic_target_output_equivalence_certificate="
        "RemainingOpenSemanticTargetsOutputEquivalenceCertificate"
    )
    print(
        "semantic_target_output_equivalence_certificate_proof="
        "remaining_open_semantic_targets_output_equivalence_certificate"
    )
    print(
        "semantic_target_output_equivalence_named_roster_proofs="
        "openSemanticTargetOutputEquivalenceSurfaceTargets_named_current,"
        "openSemanticTargetOutputEquivalenceSurfaceOutputBundles_named_current,"
        "openSemanticTargetOutputEquivalenceSurfaceTargetObstructions_named_current,"
        "openSemanticTargetOutputEquivalenceSurfaceOutputObstructions_named_current"
    )
    print("semantic_target_output_equivalence_named_roster_terms_checked=8")
    print(
        "semantic_target_output_equivalence_named_roster_length_proofs="
        "openSemanticTargetOutputEquivalenceSurfaceTargets_length_current,"
        "openSemanticTargetOutputEquivalenceSurfaceOutputBundles_length_current,"
        "openSemanticTargetOutputEquivalenceSurfaceTargetObstructions_length_current,"
        "openSemanticTargetOutputEquivalenceSurfaceOutputObstructions_length_current"
    )
    print(
        "semantic_target_output_equivalence_not_iff_proof="
        "openSemanticTargetOutputEquivalenceSurface_target_not_iff_output"
    )
    print(
        "semantic_target_output_equivalence_named_roster_certificate="
        "OpenSemanticTargetOutputEquivalenceNamedRosterCertificate"
    )
    print(
        "semantic_target_output_equivalence_named_roster_certificate_proof="
        "open_semantic_target_output_equivalence_named_roster_certificate"
    )
    print(
        "semantic_target_output_equivalence_statement_roster_proofs="
        "openSemanticTargetOutputEquivalenceSurfaceTargetToOutputStatements_named_current,"
        "openSemanticTargetOutputEquivalenceSurfaceOutputToTargetStatements_named_current,"
        "openSemanticTargetOutputEquivalenceSurfaceTargetIffOutputStatements_named_current,"
        "openSemanticTargetOutputEquivalenceSurfaceTargetNotIffOutputStatements_named_current"
    )
    print("semantic_target_output_equivalence_statement_roster_terms_checked=8")
    print(
        "semantic_target_output_equivalence_statement_roster_length_proofs="
        "openSemanticTargetOutputEquivalenceSurfaceTargetToOutputStatements_length_current,"
        "openSemanticTargetOutputEquivalenceSurfaceOutputToTargetStatements_length_current,"
        "openSemanticTargetOutputEquivalenceSurfaceTargetIffOutputStatements_length_current,"
        "openSemanticTargetOutputEquivalenceSurfaceTargetNotIffOutputStatements_length_current"
    )
    print(
        "semantic_target_output_equivalence_statement_roster_certificate="
        "OpenSemanticTargetOutputEquivalenceStatementRosterCertificate"
    )
    print(
        "semantic_target_output_equivalence_statement_roster_certificate_proof="
        "open_semantic_target_output_equivalence_statement_roster_certificate"
    )
    print(
        "semantic_target_exact_closure_input_output_targets="
        + ",".join(surface[1] for surface in exact_closure_input_output_surfaces)
    )
    print(
        "semantic_target_exact_closure_input_output_exact_inputs="
        + ",".join(surface[2] for surface in exact_closure_input_output_surfaces)
    )
    print(
        "semantic_target_exact_closure_input_output_bundles="
        + ",".join(surface[3] for surface in exact_closure_input_output_surfaces)
    )
    print(
        "semantic_target_exact_closure_input_output_exact_to_output_proofs="
        + ",".join(surface[4] for surface in exact_closure_input_output_surfaces)
    )
    print(
        "semantic_target_exact_closure_input_output_output_to_exact_proofs="
        + ",".join(surface[5] for surface in exact_closure_input_output_surfaces)
    )
    print(
        "semantic_target_exact_closure_input_output_iff_proofs="
        + ",".join(surface[6] for surface in exact_closure_input_output_surfaces)
    )
    print(
        "semantic_target_exact_closure_input_output_target_iff_exact_proofs="
        + ",".join(surface[7] for surface in exact_closure_input_output_surfaces)
    )
    print(
        "semantic_target_exact_closure_input_output_target_iff_output_proofs="
        + ",".join(surface[8] for surface in exact_closure_input_output_surfaces)
    )
    print(
        "semantic_target_exact_closure_input_output_exact_input_obstructions="
        + ",".join(surface[9] for surface in exact_closure_input_output_surfaces)
    )
    print(
        "semantic_target_exact_closure_input_output_output_obstructions="
        + ",".join(surface[10] for surface in exact_closure_input_output_surfaces)
    )
    print(
        "semantic_target_exact_closure_input_output_certificate="
        "RemainingOpenSemanticTargetsExactClosureInputOutputCertificate"
    )
    print(
        "semantic_target_exact_closure_input_output_certificate_proof="
        "remaining_open_semantic_targets_exact_closure_input_output_certificate"
    )
    print(
        "semantic_target_exact_closure_input_output_named_roster_proofs="
        "openSemanticTargetExactClosureInputOutputSurfaceTargets_named_current,"
        "openSemanticTargetExactClosureInputOutputSurfaceExactInputs_named_current,"
        "openSemanticTargetExactClosureInputOutputSurfaceOutputBundles_named_current,"
        "openSemanticTargetExactClosureInputOutputSurfaceTargetObstructions_named_current,"
        "openSemanticTargetExactClosureInputOutputSurfaceExactInputObstructions_named_current,"
        "openSemanticTargetExactClosureInputOutputSurfaceOutputObstructions_named_current"
    )
    print("semantic_target_exact_closure_input_output_named_roster_terms_checked=12")
    print(
        "semantic_target_exact_closure_input_output_named_roster_length_proofs="
        "openSemanticTargetExactClosureInputOutputSurfaceTargets_length_current,"
        "openSemanticTargetExactClosureInputOutputSurfaceExactInputs_length_current,"
        "openSemanticTargetExactClosureInputOutputSurfaceOutputBundles_length_current,"
        "openSemanticTargetExactClosureInputOutputSurfaceTargetObstructions_length_current,"
        "openSemanticTargetExactClosureInputOutputSurfaceExactInputObstructions_length_current,"
        "openSemanticTargetExactClosureInputOutputSurfaceOutputObstructions_length_current"
    )
    print(
        "semantic_target_exact_closure_input_output_not_iff_proofs="
        "openSemanticTargetExactClosureInputOutputSurface_target_not_iff_exact_input,"
        "openSemanticTargetExactClosureInputOutputSurface_target_not_iff_output,"
        "openSemanticTargetExactClosureInputOutputSurface_exact_input_not_iff_output"
    )
    print(
        "semantic_target_exact_closure_input_output_named_roster_certificate="
        "OpenSemanticTargetExactClosureInputOutputNamedRosterCertificate"
    )
    print(
        "semantic_target_exact_closure_input_output_named_roster_certificate_proof="
        "open_semantic_target_exact_closure_input_output_named_roster_certificate"
    )
    print(
        "semantic_target_exact_closure_input_output_statement_roster_proofs="
        "openSemanticTargetExactClosureInputOutputSurfaceExactInputToOutputStatements_named_current,"
        "openSemanticTargetExactClosureInputOutputSurfaceOutputToExactInputStatements_named_current,"
        "openSemanticTargetExactClosureInputOutputSurfaceExactInputIffOutputStatements_named_current,"
        "openSemanticTargetExactClosureInputOutputSurfaceTargetIffExactInputStatements_named_current,"
        "openSemanticTargetExactClosureInputOutputSurfaceTargetIffOutputStatements_named_current,"
        "openSemanticTargetExactClosureInputOutputSurfaceTargetNotIffExactInputStatements_named_current,"
        "openSemanticTargetExactClosureInputOutputSurfaceTargetNotIffOutputStatements_named_current,"
        "openSemanticTargetExactClosureInputOutputSurfaceExactInputNotIffOutputStatements_named_current"
    )
    print("semantic_target_exact_closure_input_output_statement_roster_terms_checked=16")
    print(
        "semantic_target_exact_closure_input_output_statement_roster_length_proofs="
        "openSemanticTargetExactClosureInputOutputSurfaceExactInputToOutputStatements_length_current,"
        "openSemanticTargetExactClosureInputOutputSurfaceOutputToExactInputStatements_length_current,"
        "openSemanticTargetExactClosureInputOutputSurfaceExactInputIffOutputStatements_length_current,"
        "openSemanticTargetExactClosureInputOutputSurfaceTargetIffExactInputStatements_length_current,"
        "openSemanticTargetExactClosureInputOutputSurfaceTargetIffOutputStatements_length_current,"
        "openSemanticTargetExactClosureInputOutputSurfaceTargetNotIffExactInputStatements_length_current,"
        "openSemanticTargetExactClosureInputOutputSurfaceTargetNotIffOutputStatements_length_current,"
        "openSemanticTargetExactClosureInputOutputSurfaceExactInputNotIffOutputStatements_length_current"
    )
    print(
        "semantic_target_exact_closure_input_output_statement_roster_certificate="
        "OpenSemanticTargetExactClosureInputOutputStatementRosterCertificate"
    )
    print(
        "semantic_target_exact_closure_input_output_statement_roster_certificate_proof="
        "open_semantic_target_exact_closure_input_output_statement_roster_certificate"
    )
    print(
        "semantic_target_obstruction_equivalence_targets="
        + ",".join(surface[1] for surface in obstruction_equivalence_surfaces)
    )
    print(
        "semantic_target_obstruction_equivalence_exact_inputs="
        + ",".join(surface[2] for surface in obstruction_equivalence_surfaces)
    )
    print(
        "semantic_target_obstruction_equivalence_output_bundles="
        + ",".join(surface[3] for surface in obstruction_equivalence_surfaces)
    )
    print(
        "semantic_target_obstruction_equivalence_target_obstructions="
        + ",".join(surface[4] for surface in obstruction_equivalence_surfaces)
    )
    print(
        "semantic_target_obstruction_equivalence_exact_input_obstructions="
        + ",".join(surface[5] for surface in obstruction_equivalence_surfaces)
    )
    print(
        "semantic_target_obstruction_equivalence_output_obstructions="
        + ",".join(surface[6] for surface in obstruction_equivalence_surfaces)
    )
    print(
        "semantic_target_obstruction_equivalence_target_not_iff_exact_proofs="
        + ",".join(surface[7] for surface in obstruction_equivalence_surfaces)
    )
    print(
        "semantic_target_obstruction_equivalence_target_not_iff_output_proofs="
        + ",".join(surface[8] for surface in obstruction_equivalence_surfaces)
    )
    print(
        "semantic_target_obstruction_equivalence_exact_not_iff_output_proofs="
        + ",".join(surface[9] for surface in obstruction_equivalence_surfaces)
    )
    print(
        "semantic_target_obstruction_equivalence_named_roster_proofs="
        "openSemanticTargetObstructionEquivalenceSurfaceTargets_named_current,"
        "openSemanticTargetObstructionEquivalenceSurfaceExactInputs_named_current,"
        "openSemanticTargetObstructionEquivalenceSurfaceOutputBundles_named_current,"
        "openSemanticTargetObstructionEquivalenceSurfaceTargetObstructions_named_current,"
        "openSemanticTargetObstructionEquivalenceSurfaceExactInputObstructions_named_current,"
        "openSemanticTargetObstructionEquivalenceSurfaceOutputObstructions_named_current"
    )
    print("semantic_target_obstruction_equivalence_named_roster_terms_checked=12")
    print(
        "semantic_target_obstruction_equivalence_named_roster_length_proofs="
        "openSemanticTargetObstructionEquivalenceSurfaceTargets_length_current,"
        "openSemanticTargetObstructionEquivalenceSurfaceExactInputs_length_current,"
        "openSemanticTargetObstructionEquivalenceSurfaceOutputBundles_length_current,"
        "openSemanticTargetObstructionEquivalenceSurfaceTargetObstructions_length_current,"
        "openSemanticTargetObstructionEquivalenceSurfaceExactInputObstructions_length_current,"
        "openSemanticTargetObstructionEquivalenceSurfaceOutputObstructions_length_current"
    )
    print(
        "semantic_target_obstruction_equivalence_certificate="
        "RemainingOpenSemanticTargetsObstructionEquivalenceCertificate"
    )
    print(
        "semantic_target_obstruction_equivalence_certificate_proof="
        "remaining_open_semantic_targets_obstruction_equivalence_certificate"
    )
    print(
        "semantic_target_obstruction_equivalence_named_roster_certificate="
        "OpenSemanticTargetObstructionEquivalenceNamedRosterCertificate"
    )
    print(
        "semantic_target_obstruction_equivalence_named_roster_certificate_proof="
        "open_semantic_target_obstruction_equivalence_named_roster_certificate"
    )
    print(
        "semantic_target_obstruction_equivalence_statement_roster_proofs="
        "openSemanticTargetObstructionEquivalenceSurfaceTargetNotIffExactInputStatements_named_current,"
        "openSemanticTargetObstructionEquivalenceSurfaceTargetNotIffOutputStatements_named_current,"
        "openSemanticTargetObstructionEquivalenceSurfaceExactInputNotIffOutputStatements_named_current"
    )
    print("semantic_target_obstruction_equivalence_statement_roster_terms_checked=6")
    print(
        "semantic_target_obstruction_equivalence_statement_roster_length_proofs="
        "openSemanticTargetObstructionEquivalenceSurfaceTargetNotIffExactInputStatements_length_current,"
        "openSemanticTargetObstructionEquivalenceSurfaceTargetNotIffOutputStatements_length_current,"
        "openSemanticTargetObstructionEquivalenceSurfaceExactInputNotIffOutputStatements_length_current"
    )
    print(
        "semantic_target_obstruction_equivalence_statement_roster_certificate="
        "OpenSemanticTargetObstructionEquivalenceStatementRosterCertificate"
    )
    print(
        "semantic_target_obstruction_equivalence_statement_roster_certificate_proof="
        "open_semantic_target_obstruction_equivalence_statement_roster_certificate"
    )
    print(
        "semantic_target_joint_closure_targets="
        "RemainingOpenSemanticTargetsSatisfied"
    )
    print(
        "semantic_target_joint_closure_exact_inputs="
        "RemainingOpenSemanticTargetsExactClosureInputsSatisfied"
    )
    print(
        "semantic_target_joint_closure_output_bundles="
        "RemainingOpenSemanticTargetsFullOutputBundlesSatisfied"
    )
    print(
        "semantic_target_joint_closure_targets_to_exact_inputs="
        "remaining_open_semantic_targets_exact_inputs_of_targets"
    )
    print(
        "semantic_target_joint_closure_exact_inputs_to_targets="
        "remaining_open_semantic_targets_targets_of_exact_inputs"
    )
    print(
        "semantic_target_joint_closure_targets_iff_exact_inputs="
        "remaining_open_semantic_targets_satisfied_iff_exact_closure_inputs"
    )
    print(
        "semantic_target_joint_closure_targets_to_outputs="
        "remaining_open_semantic_targets_outputs_of_targets"
    )
    print(
        "semantic_target_joint_closure_outputs_to_targets="
        "remaining_open_semantic_targets_targets_of_outputs"
    )
    print(
        "semantic_target_joint_closure_targets_iff_outputs="
        "remaining_open_semantic_targets_satisfied_iff_full_outputs"
    )
    print(
        "semantic_target_joint_closure_exact_inputs_to_outputs="
        "remaining_open_semantic_targets_outputs_of_exact_inputs"
    )
    print(
        "semantic_target_joint_closure_outputs_to_exact_inputs="
        "remaining_open_semantic_targets_exact_inputs_of_outputs"
    )
    print(
        "semantic_target_joint_closure_exact_inputs_iff_outputs="
        "remaining_open_semantic_targets_exact_inputs_iff_full_outputs"
    )
    print(
        "semantic_target_joint_closure_target_package_obstruction="
        "remaining_open_semantic_targets_satisfied_notYet"
    )
    print(
        "semantic_target_joint_closure_exact_input_package_obstruction="
        "remaining_open_semantic_targets_exact_inputs_notYet"
    )
    print(
        "semantic_target_joint_closure_output_package_obstruction="
        "remaining_open_semantic_targets_full_outputs_notYet"
    )
    print(
        "semantic_target_joint_closure_reduction_certificate="
        "RemainingOpenSemanticTargetsJointClosureReductionCertificate"
    )
    print(
        "semantic_target_joint_closure_reduction_certificate_proof="
        "remaining_open_semantic_targets_joint_closure_reduction_certificate"
    )
    print(
        "semantic_target_joint_closure_statement_roster_proof="
        "remainingOpenSemanticTargetsJointClosureStatements_named_current"
    )
    print("semantic_target_joint_closure_statement_roster_terms_checked=12")
    print(
        "semantic_target_joint_closure_statement_roster_length_proof="
        "remainingOpenSemanticTargetsJointClosureStatements_length_current"
    )
    print(
        "semantic_target_joint_closure_statement_roster_certificate="
        "RemainingOpenSemanticTargetsJointClosureStatementRosterCertificate"
    )
    print(
        "semantic_target_joint_closure_statement_roster_certificate_proof="
        "remaining_open_semantic_targets_joint_closure_statement_roster_certificate"
    )
    print(
        "semantic_target_joint_route_targets="
        "RemainingOpenSemanticTargetsTargetRoutesSatisfied"
    )
    print(
        "semantic_target_joint_route_closure_routes="
        "RemainingOpenSemanticTargetsClosureRoutesSatisfied"
    )
    print(
        "semantic_target_joint_route_reductions="
        "remaining_open_semantic_targets_target_routes_of_targets,"
        "remaining_open_semantic_targets_targets_of_target_routes,"
        "remaining_open_semantic_targets_satisfied_iff_target_routes,"
        "remaining_open_semantic_targets_closure_routes_of_targets,"
        "remaining_open_semantic_targets_targets_of_closure_routes,"
        "remaining_open_semantic_targets_satisfied_iff_closure_routes,"
        "remaining_open_semantic_targets_closure_routes_of_target_routes,"
        "remaining_open_semantic_targets_target_routes_of_closure_routes,"
        "remaining_open_semantic_targets_target_routes_iff_closure_routes"
    )
    print(
        "semantic_target_joint_route_package_obstructions="
        "remaining_open_semantic_targets_satisfied_notYet,"
        "remaining_open_semantic_targets_target_routes_notYet,"
        "remaining_open_semantic_targets_closure_routes_notYet"
    )
    print(
        "semantic_target_bilateral_package_obstruction_proofs="
        "remaining_open_semantic_targets_satisfied_not_of_part6_target_not,"
        "remaining_open_semantic_targets_satisfied_not_of_topo_target_not,"
        "remaining_open_semantic_targets_exact_inputs_not_of_part6_exact_input_not,"
        "remaining_open_semantic_targets_exact_inputs_not_of_topo_exact_input_not,"
        "remaining_open_semantic_targets_full_outputs_not_of_part6_output_not,"
        "remaining_open_semantic_targets_full_outputs_not_of_topo_output_not,"
        "remaining_open_semantic_targets_target_routes_not_of_part6_route_not,"
        "remaining_open_semantic_targets_target_routes_not_of_topo_route_not,"
        "remaining_open_semantic_targets_closure_routes_not_of_part6_closure_not,"
        "remaining_open_semantic_targets_closure_routes_not_of_topo_closure_not"
    )
    print(
        "semantic_target_joint_route_reduction_certificate="
        "RemainingOpenSemanticTargetsJointRouteObstructionReductionCertificate"
    )
    print(
        "semantic_target_joint_route_reduction_certificate_proof="
        "remaining_open_semantic_targets_joint_route_obstruction_reduction_certificate"
    )
    print(
        "semantic_target_joint_route_statement_roster_proof="
        "remainingOpenSemanticTargetsJointRouteStatements_named_current"
    )
    print("semantic_target_joint_route_statement_roster_terms_checked=12")
    print(
        "semantic_target_joint_route_statement_roster_length_proof="
        "remainingOpenSemanticTargetsJointRouteStatements_length_current"
    )
    print(
        "semantic_target_joint_route_statement_roster_certificate="
        "RemainingOpenSemanticTargetsJointRouteStatementRosterCertificate"
    )
    print(
        "semantic_target_joint_route_statement_roster_certificate_proof="
        "remaining_open_semantic_targets_joint_route_statement_roster_certificate"
    )
    print(
        "semantic_target_bilateral_package_obstruction_certificate="
        "RemainingOpenSemanticTargetsBilateralPackageObstructionCertificate"
    )
    print(
        "semantic_target_bilateral_package_obstruction_certificate_proof="
        "remaining_open_semantic_targets_bilateral_package_obstruction_certificate"
    )
    print(
        "semantic_target_bilateral_package_obstruction_statement_roster_proof="
        "remainingOpenSemanticTargetsBilateralPackageObstructionStatements_named_current"
    )
    print("semantic_target_bilateral_package_obstruction_statement_roster_terms_checked=15")
    print(
        "semantic_target_bilateral_package_obstruction_statement_roster_length_proof="
        "remainingOpenSemanticTargetsBilateralPackageObstructionStatements_length_current"
    )
    print(
        "semantic_target_bilateral_package_obstruction_statement_roster_certificate="
        "RemainingOpenSemanticTargetsBilateralPackageObstructionStatementRosterCertificate"
    )
    print(
        "semantic_target_bilateral_package_obstruction_statement_roster_certificate_proof="
        "remaining_open_semantic_targets_bilateral_package_obstruction_statement_roster_certificate"
    )
    print(
        "semantic_target_kernel_surface_route_obstruction_certificate="
        "OpenSemanticTargetKernelSurfaceRouteObstructionEquivalenceCertificate"
    )
    print(
        "semantic_target_kernel_surface_route_obstruction_certificate_proof="
        "open_semantic_target_kernel_surface_route_obstruction_equivalence_certificate"
    )
    print(
        "semantic_target_frontier_payload_route_obstruction_certificate="
        "OpenSemanticTargetFrontierPayloadRouteObstructionEquivalenceCertificate"
    )
    print(
        "semantic_target_frontier_payload_route_obstruction_certificate_proof="
        "open_semantic_target_frontier_payload_route_obstruction_equivalence_certificate"
    )
    print(
        "semantic_target_named_route_obstruction_roster_certificate="
        "OpenSemanticTargetNamedRouteObstructionRosterCertificate"
    )
    print(
        "semantic_target_named_route_obstruction_roster_certificate_proof="
        "open_semantic_target_named_route_obstruction_roster_certificate"
    )
    print(
        "semantic_target_named_frontier_certificate_roster_certificate="
        "OpenSemanticTargetNamedFrontierCertificateRosterCertificate"
    )
    print(
        "semantic_target_named_frontier_certificate_roster_certificate_proof="
        "open_semantic_target_named_frontier_certificate_roster_certificate"
    )
    print(
        "semantic_target_named_route_statement_roster_certificate="
        "OpenSemanticTargetNamedRouteStatementRosterCertificate"
    )
    print(
        "semantic_target_named_route_statement_roster_certificate_proof="
        "open_semantic_target_named_route_statement_roster_certificate"
    )
    print(
        "semantic_target_part6_conditional_witness_exact_input_proofs="
        "part6_lattice_embedding_divergence_witness_of_exact_closure_input,"
        "part6_lattice_embedding_feasible_divergence_witness_of_exact_closure_input,"
        "part6_lattice_embedding_output_pair_of_exact_closure_input"
    )
    print(
        "semantic_target_part6_conditional_witness_output_bundle_proofs="
        "part6_lattice_embedding_divergence_witness_of_full_output_bundle,"
        "part6_lattice_embedding_feasible_divergence_witness_of_full_output_bundle,"
        "part6_lattice_embedding_output_pair_of_full_output_bundle"
    )
    print(
        "semantic_target_part6_conditional_witness_obstructions="
        "not_part6_full_paper_closing_divergence_witness_current,"
        "not_part6_full_paper_closing_feasible_divergence_witness_current,"
        "not_part6_full_paper_closing_output_pair_current"
    )
    print(
        "semantic_target_part6_conditional_witness_certificate="
        "Part6RemainingConditionalProjectionCertificate"
    )
    print(
        "semantic_target_part6_conditional_witness_certificate_proof="
        "part6_remaining_conditional_projection_certificate"
    )
    print(
        "semantic_target_part6_conditional_witness_statement_roster_proof="
        "part6RemainingConditionalProjectionStatements_named_current"
    )
    print("semantic_target_part6_conditional_witness_statement_roster_terms_checked=11")
    print(
        "semantic_target_part6_conditional_witness_statement_roster_length_proof="
        "part6RemainingConditionalProjectionStatements_length_current"
    )
    print(
        "semantic_target_part6_conditional_witness_statement_roster_certificate="
        "Part6RemainingConditionalProjectionStatementRosterCertificate"
    )
    print(
        "semantic_target_part6_conditional_witness_statement_roster_certificate_proof="
        "part6_remaining_conditional_projection_statement_roster_certificate"
    )
    print(
        "semantic_target_part6_route_obstruction_projection_proofs="
        "part6_lattice_embedding_exact_closure_input_not_of_repair_route_not,"
        "part6_lattice_embedding_exact_closure_input_not_of_full_support_not,"
        "part6_lattice_embedding_full_output_bundle_not_of_repair_route_not,"
        "part6_lattice_embedding_full_output_bundle_not_of_full_support_not,"
        "part6_lattice_embedding_semantic_kernel_target_not_iff_repair_route,"
        "part6_lattice_embedding_semantic_kernel_target_not_iff_full_support,"
        "part6_lattice_embedding_repair_route_not_iff_full_support_not"
    )
    print(
        "semantic_target_part6_route_obstruction_projection_current="
        "part6_lattice_embedding_semantic_kernel_target_notYet,"
        "not_part6_nondegenerate_feasible_repair_route_current,"
        "not_part6_full_paper_closing_support_current,"
        "part6_lattice_embedding_exact_closure_input_notYet,"
        "not_part6_full_paper_closing_full_output_bundle_current"
    )
    print(
        "semantic_target_part6_route_obstruction_projection_certificate="
        "Part6LatticeEmbeddingRouteObstructionProjectionCertificate"
    )
    print(
        "semantic_target_part6_route_obstruction_projection_certificate_proof="
        "part6_lattice_embedding_route_obstruction_projection_certificate"
    )
    print(
        "semantic_target_part6_route_obstruction_projection_statement_roster_proof="
        "part6LatticeEmbeddingRouteObstructionProjectionStatements_named_current"
    )
    print("semantic_target_part6_route_obstruction_projection_statement_roster_terms_checked=12")
    print(
        "semantic_target_part6_route_obstruction_projection_statement_roster_length_proof="
        "part6LatticeEmbeddingRouteObstructionProjectionStatements_length_current"
    )
    print(
        "semantic_target_part6_route_obstruction_projection_statement_roster_certificate="
        "Part6LatticeEmbeddingRouteObstructionProjectionStatementRosterCertificate"
    )
    print(
        "semantic_target_part6_route_obstruction_projection_statement_roster_certificate_proof="
        "part6_lattice_embedding_route_obstruction_projection_statement_roster_certificate"
    )
    print(
        "semantic_target_topo_exact_output_projection_exact_input_proofs="
        "topo_cluster_random_supercritical_z2_full_route_of_exact_closure_input,"
        "topo_cluster_random_supercritical_z2_boxed_route_of_exact_closure_input,"
        "topo_cluster_random_supercritical_z2_support_surface_repair_route_of_exact_closure_input,"
        "topo_cluster_random_supercritical_z2_support_surface_repair_output_of_exact_closure_input,"
        "topo_cluster_random_supercritical_z2_paper_support_output_of_exact_closure_input,"
        "topo_cluster_random_supercritical_z2_giant_loss_output_of_exact_closure_input"
    )
    print(
        "semantic_target_topo_exact_output_projection_same_bridge_bundle_proofs="
        "topo_cluster_random_supercritical_z2_boxed_route_of_same_bridge_full_output_bundle,"
        "topo_cluster_random_supercritical_z2_support_surface_repair_route_of_same_bridge_full_output_bundle,"
        "topo_cluster_random_supercritical_z2_support_surface_repair_output_of_same_bridge_full_output_bundle,"
        "topo_cluster_random_supercritical_z2_paper_support_output_of_same_bridge_full_output_bundle,"
        "topo_cluster_random_supercritical_z2_giant_loss_output_of_same_bridge_full_output_bundle"
    )
    print(
        "semantic_target_topo_exact_output_projection_boundary="
        "randomSupercriticalZ2TopoClusterSupportSurfaceRepairRoute_current,"
        "random_supercritical_z2_topo_cluster_support_surface_repair_nonclosure_certificate,"
        "not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute,"
        "not_randomSupercriticalZ2TopoClusterBoxedTorusFiniteZ2LClosingRoute"
    )
    print(
        "semantic_target_topo_exact_output_projection_certificate="
        "TopoClusterRandomSupercriticalZ2ExactOutputProjectionCertificate"
    )
    print(
        "semantic_target_topo_exact_output_projection_certificate_proof="
        "topo_cluster_random_supercritical_z2_exact_output_projection_certificate"
    )
    print(
        "semantic_target_topo_exact_output_projection_statement_roster_proof="
        "topoClusterRandomSupercriticalZ2ExactOutputProjectionStatements_named_current"
    )
    print("semantic_target_topo_exact_output_projection_statement_roster_terms_checked=16")
    print(
        "semantic_target_topo_exact_output_projection_statement_roster_length_proof="
        "topoClusterRandomSupercriticalZ2ExactOutputProjectionStatements_length_current"
    )
    print(
        "semantic_target_topo_exact_output_projection_statement_roster_certificate="
        "TopoClusterRandomSupercriticalZ2ExactOutputProjectionStatementRosterCertificate"
    )
    print(
        "semantic_target_topo_exact_output_projection_statement_roster_certificate_proof="
        "topo_cluster_random_supercritical_z2_exact_output_projection_statement_roster_certificate"
    )
    print(
        "semantic_target_topo_route_obstruction_projection_proofs="
        "topo_cluster_random_supercritical_z2_exact_closure_input_not_of_full_route_not,"
        "topo_cluster_random_supercritical_z2_exact_closure_input_not_of_boxed_route_not,"
        "topo_cluster_random_supercritical_z2_same_bridge_full_output_bundle_not_of_full_route_not,"
        "topo_cluster_random_supercritical_z2_same_bridge_full_output_bundle_not_of_boxed_route_not,"
        "topo_cluster_random_supercritical_z2_semantic_kernel_target_not_iff_full_route,"
        "topo_cluster_random_supercritical_z2_semantic_kernel_target_not_iff_boxed_route,"
        "topo_cluster_random_supercritical_z2_full_route_not_iff_boxed_route_not"
    )
    print(
        "semantic_target_topo_route_obstruction_projection_current="
        "topo_cluster_random_supercritical_z2_semantic_kernel_target_notYet,"
        "not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute,"
        "not_randomSupercriticalZ2TopoClusterBoxedTorusFiniteZ2LClosingRoute,"
        "topo_cluster_random_supercritical_z2_exact_closure_input_notYet,"
        "topo_cluster_random_supercritical_z2_same_bridge_full_output_bundle_notYet"
    )
    print(
        "semantic_target_topo_route_obstruction_projection_certificate="
        "TopoClusterRandomSupercriticalZ2RouteObstructionProjectionCertificate"
    )
    print(
        "semantic_target_topo_route_obstruction_projection_certificate_proof="
        "topo_cluster_random_supercritical_z2_route_obstruction_projection_certificate"
    )
    print(
        "semantic_target_topo_route_obstruction_projection_statement_roster_proof="
        "topoClusterRandomSupercriticalZ2RouteObstructionProjectionStatements_named_current"
    )
    print("semantic_target_topo_route_obstruction_projection_statement_roster_terms_checked=12")
    print(
        "semantic_target_topo_route_obstruction_projection_statement_roster_length_proof="
        "topoClusterRandomSupercriticalZ2RouteObstructionProjectionStatements_length_current"
    )
    print(
        "semantic_target_topo_route_obstruction_projection_statement_roster_certificate="
        "TopoClusterRandomSupercriticalZ2RouteObstructionProjectionStatementRosterCertificate"
    )
    print(
        "semantic_target_topo_route_obstruction_projection_statement_roster_certificate_proof="
        "topo_cluster_random_supercritical_z2_route_obstruction_projection_statement_roster_certificate"
    )
    print(
        "semantic_target_closure_input_field_payloads="
        + ",".join(surface[2] for surface in closure_input_field_surfaces)
    )
    print(
        "semantic_target_closure_input_field_closure_inputs="
        + ",".join(surface[1] for surface in closure_input_field_surfaces)
    )
    print(
        "semantic_target_closure_input_field_payload_proofs="
        + ",".join(surface[3] for surface in closure_input_field_surfaces)
    )
    print(
        "semantic_target_closure_input_field_payload_to_closure_input_proofs="
        + ",".join(surface[4] for surface in closure_input_field_surfaces)
    )
    print(
        "semantic_target_closure_input_field_payload_iff_closure_input_proofs="
        + ",".join(surface[5] for surface in closure_input_field_surfaces)
    )
    print(
        "semantic_target_closure_input_field_payload_obstructions="
        + ",".join(surface[6] for surface in closure_input_field_surfaces)
    )
    print(
        "semantic_target_closure_input_field_certificates="
        + ",".join(surface[7] for surface in closure_input_field_surfaces)
    )
    print(
        "semantic_target_closure_input_field_certificate_proofs="
        + ",".join(surface[8] for surface in closure_input_field_surfaces)
    )
    print(
        "semantic_target_closure_input_field_certificate="
        "RemainingOpenSemanticTargetsClosureInputFieldCertificate"
    )
    print(
        "semantic_target_closure_input_field_certificate_proof="
        "remaining_open_semantic_targets_closure_input_field_certificate"
    )
    print(
        "semantic_target_closure_input_field_obstruction_certificate="
        "RemainingOpenSemanticTargetsClosureInputFieldObstructionCertificate"
    )
    print(
        "semantic_target_closure_input_field_obstruction_certificate_proof="
        "remaining_open_semantic_targets_closure_input_field_obstruction_certificate"
    )
    print(
        "semantic_target_closure_input_field_named_roster_proofs="
        "openSemanticTargetClosureInputFieldSurfaceClosureInputs_named_current,"
        "openSemanticTargetClosureInputFieldSurfaceFieldPayloads_named_current,"
        "openSemanticTargetClosureInputFieldSurfaceFieldPayloadObstructions_named_current,"
        "openSemanticTargetClosureInputFieldSurfaceFieldCertificates_named_current"
    )
    print("semantic_target_closure_input_field_roster_terms_checked=8")
    print(
        "semantic_target_closure_input_field_roster_length_proofs="
        "openSemanticTargetClosureInputFieldSurfaceClosureInputs_length_current,"
        "openSemanticTargetClosureInputFieldSurfaceFieldPayloads_length_current,"
        "openSemanticTargetClosureInputFieldSurfaceFieldPayloadObstructions_length_current,"
        "openSemanticTargetClosureInputFieldSurfaceFieldCertificates_length_current"
    )
    print(
        "semantic_target_closure_input_field_not_iff_proof="
        "openSemanticTargetClosureInputFieldSurface_field_payload_not_iff_closure_input"
    )
    print(
        "semantic_target_closure_input_field_roster_certificate="
        "OpenSemanticTargetClosureInputFieldRosterCertificate"
    )
    print(
        "semantic_target_closure_input_field_roster_certificate_proof="
        "open_semantic_target_closure_input_field_roster_certificate"
    )
    print(
        "semantic_target_closure_input_field_statement_roster_proofs="
        "openSemanticTargetClosureInputFieldSurfaceClosureInputToFieldPayloadStatements_named_current,"
        "openSemanticTargetClosureInputFieldSurfaceFieldPayloadToClosureInputStatements_named_current,"
        "openSemanticTargetClosureInputFieldSurfaceFieldPayloadIffClosureInputStatements_named_current,"
        "openSemanticTargetClosureInputFieldSurfaceFieldPayloadNotIffClosureInputStatements_named_current"
    )
    print("semantic_target_closure_input_field_statement_roster_terms_checked=8")
    print(
        "semantic_target_closure_input_field_statement_roster_length_proofs="
        "openSemanticTargetClosureInputFieldSurfaceClosureInputToFieldPayloadStatements_length_current,"
        "openSemanticTargetClosureInputFieldSurfaceFieldPayloadToClosureInputStatements_length_current,"
        "openSemanticTargetClosureInputFieldSurfaceFieldPayloadIffClosureInputStatements_length_current,"
        "openSemanticTargetClosureInputFieldSurfaceFieldPayloadNotIffClosureInputStatements_length_current"
    )
    print(
        "semantic_target_closure_input_field_statement_roster_certificate="
        "OpenSemanticTargetClosureInputFieldStatementRosterCertificate"
    )
    print(
        "semantic_target_closure_input_field_statement_roster_certificate_proof="
        "open_semantic_target_closure_input_field_statement_roster_certificate"
    )
    print(
        "semantic_target_closure_input_field_output_payloads="
        + ",".join(surface[1] for surface in closure_input_field_output_surfaces)
    )
    print(
        "semantic_target_closure_input_field_output_targets="
        + ",".join(surface[2] for surface in closure_input_field_output_surfaces)
    )
    print(
        "semantic_target_closure_input_field_output_exact_inputs="
        + ",".join(surface[3] for surface in closure_input_field_output_surfaces)
    )
    print(
        "semantic_target_closure_input_field_output_bundles="
        + ",".join(surface[4] for surface in closure_input_field_output_surfaces)
    )
    print(
        "semantic_target_closure_input_field_output_target_proofs="
        + ",".join(surface[5] for surface in closure_input_field_output_surfaces)
    )
    print(
        "semantic_target_closure_input_field_output_exact_input_proofs="
        + ",".join(surface[6] for surface in closure_input_field_output_surfaces)
    )
    print(
        "semantic_target_closure_input_field_output_bundle_proofs="
        + ",".join(surface[7] for surface in closure_input_field_output_surfaces)
    )
    print(
        "semantic_target_closure_input_field_output_payload_obstructions="
        + ",".join(surface[8] for surface in closure_input_field_output_surfaces)
    )
    print(
        "semantic_target_closure_input_field_output_certificates="
        + ",".join(surface[9] for surface in closure_input_field_output_surfaces)
    )
    print(
        "semantic_target_closure_input_field_output_certificate_proofs="
        + ",".join(surface[10] for surface in closure_input_field_output_surfaces)
    )
    print("semantic_target_closure_input_field_output_roster_terms_checked=12")
    print(
        "semantic_target_closure_input_field_output_roster_length_proofs="
        "openSemanticTargetClosureInputFieldOutputSurfaceFieldPayloads_length_current,"
        "openSemanticTargetClosureInputFieldOutputSurfaceTargets_length_current,"
        "openSemanticTargetClosureInputFieldOutputSurfaceExactInputs_length_current,"
        "openSemanticTargetClosureInputFieldOutputSurfaceOutputBundles_length_current,"
        "openSemanticTargetClosureInputFieldOutputSurfaceFieldPayloadObstructions_length_current,"
        "openSemanticTargetClosureInputFieldOutputSurfaceFieldOutputCertificates_length_current"
    )
    print(
        "semantic_target_closure_input_field_output_certificate="
        "RemainingOpenSemanticTargetsClosureInputFieldOutputCertificate"
    )
    print(
        "semantic_target_closure_input_field_output_certificate_proof="
        "remaining_open_semantic_targets_closure_input_field_output_certificate"
    )
    print(
        "semantic_target_closure_input_field_output_roster_certificate="
        "OpenSemanticTargetClosureInputFieldOutputRosterCertificate"
    )
    print(
        "semantic_target_closure_input_field_output_roster_certificate_proof="
        "open_semantic_target_closure_input_field_output_roster_certificate"
    )
    print(
        "semantic_target_closure_input_field_output_statement_roster_certificate="
        "OpenSemanticTargetClosureInputFieldOutputStatementRosterCertificate"
    )
    print(
        "semantic_target_closure_input_field_output_statement_roster_certificate_proof="
        "open_semantic_target_closure_input_field_output_statement_roster_certificate"
    )
    print("semantic_target_closure_input_field_output_statement_roster_terms_checked=6")
    print(
        "semantic_target_closure_input_field_output_statement_roster_length_proofs="
        "openSemanticTargetClosureInputFieldOutputSurfaceFieldToTargetStatements_length_current,"
        "openSemanticTargetClosureInputFieldOutputSurfaceFieldToExactInputStatements_length_current,"
        "openSemanticTargetClosureInputFieldOutputSurfaceFieldToOutputStatements_length_current"
    )
    print(
        "semantic_target_part6_field_output_statement_roster="
        "part6LatticeEmbeddingClosureInputFieldOutputStatements"
    )
    print(
        "semantic_target_part6_field_output_statement_roster_proof="
        "part6_lattice_embedding_closure_input_field_output_statements_named_current"
    )
    print("semantic_target_part6_field_output_statement_roster_terms_checked=13")
    print(
        "semantic_target_part6_field_output_statement_roster_length_proof="
        "part6_lattice_embedding_closure_input_field_output_statements_length_current"
    )
    print(
        "semantic_target_part6_field_output_statement_roster_certificate="
        "Part6LatticeEmbeddingClosureInputFieldOutputStatementRosterCertificate"
    )
    print(
        "semantic_target_part6_field_output_statement_roster_certificate_proof="
        "part6_lattice_embedding_closure_input_field_output_statement_roster_certificate"
    )
    print(
        "semantic_target_topo_field_output_statement_roster="
        "topoClusterRandomSupercriticalZ2ClosureInputFieldOutputStatements"
    )
    print(
        "semantic_target_topo_field_output_statement_roster_proof="
        "topo_cluster_random_supercritical_z2_closure_input_field_output_statements_named_current"
    )
    print("semantic_target_topo_field_output_statement_roster_terms_checked=14")
    print(
        "semantic_target_topo_field_output_statement_roster_length_proof="
        "topo_cluster_random_supercritical_z2_closure_input_field_output_statements_length_current"
    )
    print(
        "semantic_target_topo_field_output_statement_roster_certificate="
        "TopoClusterRandomSupercriticalZ2ClosureInputFieldOutputStatementRosterCertificate"
    )
    print(
        "semantic_target_topo_field_output_statement_roster_certificate_proof="
        "topo_cluster_random_supercritical_z2_closure_input_field_output_statement_roster_certificate"
    )
    print(
        "semantic_target_closure_input_field_output_detailed_statement_rosters="
        "Part6LatticeEmbeddingClosureInputFieldOutputStatementRosterCertificate,"
        "TopoClusterRandomSupercriticalZ2ClosureInputFieldOutputStatementRosterCertificate"
    )
    print(
        "semantic_target_closure_input_field_output_detailed_statement_roster_ids="
        + ",".join(open_ids)
    )
    print(
        "semantic_target_closure_input_field_output_detailed_statement_roster_ids_proof="
        "openSemanticTargetClosureInputFieldOutputDetailedStatementRosterIds_current"
    )
    print(
        "semantic_target_closure_input_field_output_detailed_statement_roster_count_proof="
        "openSemanticTargetClosureInputFieldOutputDetailedStatementRosters_count_current"
    )
    print("semantic_target_closure_input_field_output_detailed_statement_roster_terms_checked=2")
    print(
        "semantic_target_closure_input_field_output_detailed_statement_roster_length_proof="
        "openSemanticTargetClosureInputFieldOutputDetailedStatementRosters_length_current"
    )
    print(
        "semantic_target_closure_input_field_output_detailed_statement_rosters_proof="
        "openSemanticTargetClosureInputFieldOutputDetailedStatementRosters_named_current"
    )
    print(
        "semantic_target_closure_input_field_output_detailed_statement_roster_certificate="
        "RemainingOpenSemanticTargetsClosureInputFieldOutputDetailedStatementRosterCertificate"
    )
    print(
        "semantic_target_closure_input_field_output_detailed_statement_roster_certificate_proof="
        "remaining_open_semantic_targets_closure_input_field_output_detailed_statement_roster_certificate"
    )
    required_axiom_audit_decls = set(REQUIRED_AXIOM_AUDIT_DECLS)
    required_axiom_audit_decls.update(
        f"BlackwellDilemma.PaperSemanticGate.{name}"
        for name in paper_semantic_theorem_names(text)
    )
    required_axiom_audit_decls.update(
        f"BlackwellDilemma.PaperSemanticGate.{name}"
        for name in paper_semantic_def_names(text)
    )
    required_axiom_audit_decls.update(
        f"BlackwellDilemma.PaperSemanticGate.{name}"
        for name in paper_semantic_type_names(text)
    )
    for (
        _target_id,
        target_prop,
        target_route,
        target_route_proof,
        target_route_certificate,
        target_route_certificate_proof,
        target_route_obstruction,
        closure_route,
        closure_route_proof,
        route_equivalence_proof,
        closure_route_certificate,
        closure_route_certificate_proof,
        closure_route_obstruction,
        frontier_progress_certificate,
        frontier_progress_certificate_proof,
        frontier_nonclosure_certificate,
        frontier_nonclosure_certificate_proof,
        obstruction,
        frontier,
        frontier_proof,
    ) in kernel_surfaces:
        required_axiom_audit_decls.add(f"BlackwellDilemma.PaperSemanticGate.{target_prop}")
        required_axiom_audit_decls.add(f"BlackwellDilemma.{target_route}")
        required_axiom_audit_decls.add(f"BlackwellDilemma.PaperSemanticGate.{target_route_proof}")
        required_axiom_audit_decls.add(f"BlackwellDilemma.{target_route_certificate}")
        required_axiom_audit_decls.add(f"BlackwellDilemma.{target_route_certificate_proof}")
        required_axiom_audit_decls.add(f"BlackwellDilemma.{target_route_obstruction}")
        required_axiom_audit_decls.add(f"BlackwellDilemma.{closure_route}")
        required_axiom_audit_decls.add(f"BlackwellDilemma.PaperSemanticGate.{closure_route_proof}")
        required_axiom_audit_decls.add(f"BlackwellDilemma.{route_equivalence_proof}")
        required_axiom_audit_decls.add(f"BlackwellDilemma.{closure_route_certificate}")
        required_axiom_audit_decls.add(f"BlackwellDilemma.{closure_route_certificate_proof}")
        required_axiom_audit_decls.add(f"BlackwellDilemma.{closure_route_obstruction}")
        required_axiom_audit_decls.add(f"BlackwellDilemma.{frontier_progress_certificate}")
        required_axiom_audit_decls.add(f"BlackwellDilemma.{frontier_progress_certificate_proof}")
        required_axiom_audit_decls.add(f"BlackwellDilemma.{frontier_nonclosure_certificate}")
        required_axiom_audit_decls.add(f"BlackwellDilemma.{frontier_nonclosure_certificate_proof}")
        required_axiom_audit_decls.add(f"BlackwellDilemma.PaperSemanticGate.{obstruction}")
        required_axiom_audit_decls.add(f"BlackwellDilemma.{frontier}")
        required_axiom_audit_decls.add(f"BlackwellDilemma.{frontier_proof}")
    for (
        target_id,
        payload_certificate,
        payload_certificate_proof,
        target_prop,
        target_current_obstruction_proof,
        target_route,
        target_route_proof,
        target_route_certificate,
        target_route_certificate_proof,
        target_route_obstruction_proof,
        closure_route,
        closure_route_proof,
        route_equivalence_proof,
        closure_route_certificate,
        closure_route_certificate_proof,
        closure_route_obstruction_proof,
        frontier_progress_certificate,
        frontier_progress_certificate_proof,
        frontier_nonclosure_certificate,
        frontier_nonclosure_certificate_proof,
        frontier_certificate,
        frontier_certificate_proof,
    ) in payload_surfaces:
        expected_payload_surface = EXPECTED_OPEN_FRONTIER_PAYLOAD_SURFACES.get(target_id)
        if expected_payload_surface is None:
            continue
        payload_term = expected_payload_surface[0]
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{payload_term}"
        )
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{payload_certificate}"
        )
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{payload_certificate_proof}"
        )
        required_axiom_audit_decls.add(f"BlackwellDilemma.PaperSemanticGate.{target_prop}")
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{target_current_obstruction_proof}"
        )
        required_axiom_audit_decls.add(f"BlackwellDilemma.{target_route}")
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{target_route_proof}"
        )
        required_axiom_audit_decls.add(f"BlackwellDilemma.{target_route_certificate}")
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{target_route_certificate_proof}"
        )
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{target_route_obstruction_proof}"
        )
        required_axiom_audit_decls.add(f"BlackwellDilemma.{closure_route}")
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{closure_route_proof}"
        )
        required_axiom_audit_decls.add(f"BlackwellDilemma.{route_equivalence_proof}")
        required_axiom_audit_decls.add(f"BlackwellDilemma.{closure_route_certificate}")
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{closure_route_certificate_proof}"
        )
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{closure_route_obstruction_proof}"
        )
        required_axiom_audit_decls.add(f"BlackwellDilemma.{frontier_progress_certificate}")
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{frontier_progress_certificate_proof}"
        )
        required_axiom_audit_decls.add(f"BlackwellDilemma.{frontier_nonclosure_certificate}")
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{frontier_nonclosure_certificate_proof}"
        )
        required_axiom_audit_decls.add(f"BlackwellDilemma.{frontier_certificate}")
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{frontier_certificate_proof}"
        )
    for (
        _target_id,
        target_prop,
        closure_input,
        input_to_target,
        input_obstruction,
        target_obstruction,
        input_certificate,
        input_certificate_proof,
    ) in closure_input_surfaces:
        required_axiom_audit_decls.add(f"BlackwellDilemma.PaperSemanticGate.{target_prop}")
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{closure_input}"
        )
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{input_to_target}"
        )
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{input_obstruction}"
        )
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{target_obstruction}"
        )
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{input_certificate}"
        )
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{input_certificate_proof}"
        )
    for (
        _target_id,
        target_prop,
        exact_closure_input,
        sufficient_closure_input,
        target_to_exact_input,
        exact_input_to_target,
        target_iff_exact_input,
        sufficient_to_exact_input,
        exact_input_obstruction,
    ) in exact_closure_input_surfaces:
        required_axiom_audit_decls.add(f"BlackwellDilemma.PaperSemanticGate.{target_prop}")
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{exact_closure_input}"
        )
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{sufficient_closure_input}"
        )
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{target_to_exact_input}"
        )
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{exact_input_to_target}"
        )
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{target_iff_exact_input}"
        )
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{sufficient_to_exact_input}"
        )
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{exact_input_obstruction}"
        )
    for (
        _target_id,
        target_prop,
        output_bundle,
        target_to_output_bundle,
        output_bundle_to_target,
        target_iff_output_bundle,
        output_bundle_obstruction,
    ) in output_equivalence_surfaces:
        def output_decl(decl: str) -> str:
            prefix = (
                "BlackwellDilemma"
                if decl in CORE_OUTPUT_EQUIVALENCE_DECLS
                else "BlackwellDilemma.PaperSemanticGate"
            )
            return f"{prefix}.{decl}"

        required_axiom_audit_decls.add(f"BlackwellDilemma.PaperSemanticGate.{target_prop}")
        required_axiom_audit_decls.add(output_decl(output_bundle))
        required_axiom_audit_decls.add(output_decl(target_to_output_bundle))
        required_axiom_audit_decls.add(output_decl(output_bundle_to_target))
        required_axiom_audit_decls.add(output_decl(target_iff_output_bundle))
        required_axiom_audit_decls.add(output_decl(output_bundle_obstruction))
    for (
        _target_id,
        target_prop,
        exact_closure_input,
        output_bundle,
        exact_input_to_output_bundle,
        output_bundle_to_exact_input,
        exact_input_iff_output_bundle,
        target_iff_exact_input,
        target_iff_output_bundle,
        exact_input_obstruction,
        output_bundle_obstruction,
    ) in exact_closure_input_output_surfaces:
        def output_decl(decl: str) -> str:
            prefix = (
                "BlackwellDilemma"
                if decl in CORE_OUTPUT_EQUIVALENCE_DECLS
                else "BlackwellDilemma.PaperSemanticGate"
            )
            return f"{prefix}.{decl}"

        required_axiom_audit_decls.add(f"BlackwellDilemma.PaperSemanticGate.{target_prop}")
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{exact_closure_input}"
        )
        required_axiom_audit_decls.add(output_decl(output_bundle))
        required_axiom_audit_decls.add(output_decl(exact_input_to_output_bundle))
        required_axiom_audit_decls.add(output_decl(output_bundle_to_exact_input))
        required_axiom_audit_decls.add(output_decl(exact_input_iff_output_bundle))
        required_axiom_audit_decls.add(output_decl(target_iff_exact_input))
        required_axiom_audit_decls.add(output_decl(target_iff_output_bundle))
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{exact_input_obstruction}"
        )
        required_axiom_audit_decls.add(output_decl(output_bundle_obstruction))
    for (
        _target_id,
        target_prop,
        exact_closure_input,
        output_bundle,
        target_obstruction,
        exact_input_obstruction,
        output_bundle_obstruction,
        target_not_iff_exact,
        target_not_iff_output,
        exact_not_iff_output,
    ) in obstruction_equivalence_surfaces:
        def output_decl(decl: str) -> str:
            prefix = (
                "BlackwellDilemma"
                if decl in CORE_OUTPUT_EQUIVALENCE_DECLS
                else "BlackwellDilemma.PaperSemanticGate"
            )
            return f"{prefix}.{decl}"

        required_axiom_audit_decls.add(f"BlackwellDilemma.PaperSemanticGate.{target_prop}")
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{exact_closure_input}"
        )
        required_axiom_audit_decls.add(output_decl(output_bundle))
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{target_obstruction}"
        )
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{exact_input_obstruction}"
        )
        required_axiom_audit_decls.add(output_decl(output_bundle_obstruction))
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{target_not_iff_exact}"
        )
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{target_not_iff_output}"
        )
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{exact_not_iff_output}"
        )
    missing_axiom_audit_prints = [
        decl
        for decl in sorted(required_axiom_audit_decls)
        if not has_axiom_audit_print(axiom_audit_text, decl)
    ]
    required_axiom_audit_count = len(required_axiom_audit_decls)
    readme_axiom_audit_count = readme_axiom_audit_required_count(lean_readme_text)
    print(f"semantic_target_axiom_audit_prints_required={required_axiom_audit_count}")
    print(f"semantic_target_axiom_audit_prints_missing={len(missing_axiom_audit_prints)}")
    print(
        "semantic_target_readme_axiom_audit_prints_required="
        + (
            str(readme_axiom_audit_count)
            if readme_axiom_audit_count is not None
            else "missing"
        )
    )
    print(
        "semantic_target_readme_axiom_audit_prints_required_matches="
        + ("1" if readme_axiom_audit_count == required_axiom_audit_count else "0")
    )
    public_manifest_required_lines = [
        f"semantic_targets_open={open_count}",
        f"semantic_targets_closed={closed_count}",
        f"theorem_gate_open={expected_open}",
        f"theorem_gate_closed={expected_closed}",
        f"semantic_target_open_ids={','.join(open_ids)}",
        f"semantic_target_closed_ids={','.join(closed_ids)}",
        *id_drift_lines("semantic_target_open_ids", expected_open_ids, open_ids),
        *id_drift_lines("semantic_target_closed_ids", expected_closed_ids, closed_ids),
        (
            "semantic_target_closed_frontier_certificate="
            "ClosedSemanticTargetsFrontierCertificate"
        ),
        (
            "semantic_target_closed_frontier_certificate_proof="
            "closed_semantic_targets_frontier_certificate"
        ),
        (
            "semantic_target_closed_frontier_payloads="
            "r10_two_regime_label_recalibration_payload,"
            "part4_lattice_p_monotonicity_frontier_payload,"
            "r10_threshold_five_state_high_kappa_routing_payload"
        ),
        (
            "complete_paper_semantic_kernel_only_current_obstruction_certificate="
            "CompletePaperSemanticKernelOnlyCurrentObstructionCertificate"
        ),
        (
            "complete_paper_semantic_kernel_only_current_obstruction_certificate_proof="
            "completePaperSemanticKernelOnly_current_obstruction_certificate"
        ),
        (
            "complete_paper_semantic_kernel_only_current_obstruction_statement_roster_proof="
            "completePaperSemanticKernelOnlyCurrentObstructionStatements_named_current"
        ),
        (
            "complete_paper_semantic_kernel_only_current_obstruction_conjuncts_checked="
            f"{len(EXPECTED_TOP_LEVEL_CURRENT_OBSTRUCTION_CONJUNCTS)}"
        ),
        (
            "complete_paper_semantic_kernel_only_current_obstruction_conjuncts_missing="
            f"{len(top_level_missing_conjuncts)}"
        ),
        (
            "complete_paper_semantic_kernel_only_current_obstruction_statement_roster_terms_checked="
            f"{len(EXPECTED_TOP_LEVEL_CURRENT_OBSTRUCTION_STATEMENT_TERMS)}"
        ),
        (
            "complete_paper_semantic_kernel_only_current_obstruction_statement_roster_terms_missing="
            f"{len(missing_top_level_statement_roster_terms)}"
        ),
        (
            "semantic_target_named_current_roster_length_pairs_checked="
            f"{named_current_roster_count}"
        ),
        (
            "semantic_target_named_current_roster_missing_length_proofs_count="
            f"{len(missing_named_current_roster_length_proofs)}"
        ),
        (
            "semantic_target_current_roster_axiom_audit_prints_checked="
            f"{current_roster_axiom_audit_count}"
        ),
        (
            "semantic_target_current_roster_axiom_audit_prints_missing="
            f"{len(missing_current_roster_axiom_audit_prints)}"
        ),
        (
            "semantic_target_current_theorem_axiom_audit_prints_checked="
            f"{current_theorem_axiom_audit_count}"
        ),
        (
            "semantic_target_current_theorem_axiom_audit_prints_missing="
            f"{len(missing_current_theorem_axiom_audit_prints)}"
        ),
        (
            "semantic_target_theorem_axiom_audit_prints_checked="
            f"{paper_semantic_theorem_axiom_audit_count}"
        ),
        (
            "semantic_target_theorem_axiom_audit_prints_missing="
            f"{len(missing_paper_semantic_theorem_axiom_audit_prints)}"
        ),
        (
            "semantic_target_def_axiom_audit_prints_checked="
            f"{paper_semantic_def_axiom_audit_count}"
        ),
        (
            "semantic_target_def_axiom_audit_prints_missing="
            f"{len(missing_paper_semantic_def_axiom_audit_prints)}"
        ),
        (
            "semantic_target_type_axiom_audit_prints_checked="
            f"{paper_semantic_type_axiom_audit_count}"
        ),
        (
            "semantic_target_type_axiom_audit_prints_missing="
            f"{len(missing_paper_semantic_type_axiom_audit_prints)}"
        ),
        (
            "semantic_target_paper_semantic_axiom_audit_prints="
            f"{paper_semantic_axiom_audit_print_count}"
        ),
        (
            "semantic_target_paper_semantic_axiom_audit_duplicate_prints="
            f"{len(duplicate_paper_semantic_axiom_audit_prints)}"
        ),
        (
            "semantic_target_paper_semantic_axiom_audit_duplicate_decls="
            + ",".join(duplicate_paper_semantic_axiom_audit_prints)
        ),
        f"semantic_target_axiom_audit_prints_required={required_axiom_audit_count}",
        f"semantic_target_axiom_audit_prints_missing={len(missing_axiom_audit_prints)}",
        (
            "semantic_target_readme_axiom_audit_prints_required="
            + (
                str(readme_axiom_audit_count)
                if readme_axiom_audit_count is not None
                else "missing"
            )
        ),
        (
            "semantic_target_readme_axiom_audit_prints_required_matches="
            + ("1" if readme_axiom_audit_count == required_axiom_audit_count else "0")
        ),
    ]
    manifest_missing_stdout_lines = public_manifest_missing_stdout_lines(
        PUBLIC_EVIDENCE_CHECK_ID,
        public_manifest_required_lines,
    )
    print(
        "public_manifest_paper_semantic_stdout_contains_missing="
        f"{len(manifest_missing_stdout_lines)}"
    )

    failures: list[str] = []
    if open_count != expected_open:
        failures.append(f"open target count {open_count} != theorem gate {expected_open}")
    if closed_count != expected_closed:
        failures.append(f"closed target count {closed_count} != theorem gate {expected_closed}")
    if open_ids != expected_open_ids:
        failures.append(f"open target ids {open_ids!r} != theorem gate {expected_open_ids!r}")
    if closed_ids != expected_closed_ids:
        failures.append(f"closed target ids {closed_ids!r} != theorem gate {expected_closed_ids!r}")
    if top_level_missing_conjuncts:
        failures.append(
            "top-level current obstruction certificate missing conjuncts: "
            + ",".join(top_level_missing_conjuncts)
        )
    if missing_top_level_statement_roster_terms:
        failures.append(
            "top-level current obstruction statement roster missing terms: "
            + ",".join(missing_top_level_statement_roster_terms)
        )
    if missing_named_current_roster_length_proofs:
        failures.append(
            "named-current rosters missing length proofs: "
            + ",".join(missing_named_current_roster_length_proofs)
        )
    if missing_current_roster_axiom_audit_prints:
        failures.append(
            "current roster theorems missing AxiomAudit prints: "
            + ",".join(missing_current_roster_axiom_audit_prints)
        )
    if missing_current_theorem_axiom_audit_prints:
        failures.append(
            "PaperSemanticGate current theorems missing AxiomAudit prints: "
            + ",".join(missing_current_theorem_axiom_audit_prints)
        )
    if missing_paper_semantic_theorem_axiom_audit_prints:
        failures.append(
            "PaperSemanticGate theorems missing AxiomAudit prints: "
            + ",".join(missing_paper_semantic_theorem_axiom_audit_prints)
        )
    if missing_paper_semantic_def_axiom_audit_prints:
        failures.append(
            "PaperSemanticGate defs missing AxiomAudit prints: "
            + ",".join(missing_paper_semantic_def_axiom_audit_prints)
        )
    if missing_paper_semantic_type_axiom_audit_prints:
        failures.append(
            "PaperSemanticGate types missing AxiomAudit prints: "
            + ",".join(missing_paper_semantic_type_axiom_audit_prints)
        )
    if duplicate_paper_semantic_axiom_audit_prints:
        failures.append(
            "PaperSemanticGate duplicate AxiomAudit prints: "
            + ",".join(duplicate_paper_semantic_axiom_audit_prints)
        )
    if manifest_missing_stdout_lines:
        failures.append(
            "public evidence manifest missing paper semantic stdout lines: "
            + ",".join(manifest_missing_stdout_lines)
        )
    if kernel_surface_ids != open_ids:
        failures.append(
            f"kernel-surface ids {kernel_surface_ids!r} != open semantic target ids {open_ids!r}"
        )
    if payload_surface_ids != open_ids:
        failures.append(
            f"frontier-payload surface ids {payload_surface_ids!r} != open semantic target ids {open_ids!r}"
        )
    if closure_input_surface_ids != open_ids:
        failures.append(
            f"closure-input surface ids {closure_input_surface_ids!r} != open semantic target ids {open_ids!r}"
        )
    if exact_closure_input_surface_ids != open_ids:
        failures.append(
            f"exact closure-input surface ids {exact_closure_input_surface_ids!r} != open semantic target ids {open_ids!r}"
        )
    if closure_input_field_output_surface_ids != open_ids:
        failures.append(
            f"closure-input field-output surface ids {closure_input_field_output_surface_ids!r} != open semantic target ids {open_ids!r}"
        )
    if exact_closure_input_output_surface_ids != open_ids:
        failures.append(
            f"exact closure-input/output surface ids {exact_closure_input_output_surface_ids!r} != open semantic target ids {open_ids!r}"
        )
    if obstruction_equivalence_surface_ids != open_ids:
        failures.append(
            f"obstruction-equivalence surface ids {obstruction_equivalence_surface_ids!r} != open semantic target ids {open_ids!r}"
        )
    if kernel_surface_ids != payload_surface_ids:
        failures.append(
            f"kernel-surface ids {kernel_surface_ids!r} != frontier-payload surface ids {payload_surface_ids!r}"
        )
    if kernel_surface_ids != closure_input_surface_ids:
        failures.append(
            f"kernel-surface ids {kernel_surface_ids!r} != closure-input surface ids {closure_input_surface_ids!r}"
        )
    if closure_input_field_surface_ids != open_ids:
        failures.append(
            f"closure-input field surface ids {closure_input_field_surface_ids!r} != open semantic target ids {open_ids!r}"
        )
    if output_equivalence_surface_ids != open_ids:
        failures.append(
            f"output-equivalence surface ids {output_equivalence_surface_ids!r} != open semantic target ids {open_ids!r}"
        )
    if closure_input_surface_ids != closure_input_field_surface_ids:
        failures.append(
            f"closure-input surface ids {closure_input_surface_ids!r} != field surface ids {closure_input_field_surface_ids!r}"
        )
    if output_equivalence_surface_ids != closure_input_surface_ids:
        failures.append(
            f"output-equivalence surface ids {output_equivalence_surface_ids!r} != closure-input surface ids {closure_input_surface_ids!r}"
        )
    if exact_closure_input_surface_ids != closure_input_surface_ids:
        failures.append(
            f"exact closure-input surface ids {exact_closure_input_surface_ids!r} != closure-input surface ids {closure_input_surface_ids!r}"
        )
    if exact_closure_input_output_surface_ids != exact_closure_input_surface_ids:
        failures.append(
            f"exact closure-input/output surface ids {exact_closure_input_output_surface_ids!r} != exact closure-input surface ids {exact_closure_input_surface_ids!r}"
        )
    if exact_closure_input_output_surface_ids != output_equivalence_surface_ids:
        failures.append(
            f"exact closure-input/output surface ids {exact_closure_input_output_surface_ids!r} != output-equivalence surface ids {output_equivalence_surface_ids!r}"
        )
    if obstruction_equivalence_surface_ids != exact_closure_input_output_surface_ids:
        failures.append(
            f"obstruction-equivalence surface ids {obstruction_equivalence_surface_ids!r} != exact closure-input/output surface ids {exact_closure_input_output_surface_ids!r}"
        )
    for (
        target_id,
        target_prop,
        target_route,
        target_route_proof,
        target_route_certificate,
        target_route_certificate_proof,
        target_route_obstruction,
        closure_route,
        closure_route_proof,
        route_equivalence_proof,
        closure_route_certificate,
        closure_route_certificate_proof,
        closure_route_obstruction,
        frontier_progress_certificate,
        frontier_progress_certificate_proof,
        frontier_nonclosure_certificate,
        frontier_nonclosure_certificate_proof,
        obstruction,
        frontier,
        frontier_proof,
    ) in kernel_surfaces:
        expected_surface = EXPECTED_OPEN_KERNEL_SURFACES.get(target_id)
        if expected_surface is None:
            failures.append(f"unexpected kernel-surface id: {target_id}")
            continue
        (
            expected_target,
            expected_target_route,
            expected_target_route_proof,
            expected_target_route_certificate,
            expected_target_route_certificate_proof,
            expected_target_route_obstruction,
            expected_closure_route,
            expected_closure_route_proof,
            expected_route_equivalence_proof,
            expected_closure_route_certificate,
            expected_closure_route_certificate_proof,
            expected_closure_route_obstruction,
            expected_frontier_progress_certificate,
            expected_frontier_progress_certificate_proof,
            expected_frontier_nonclosure_certificate,
            expected_frontier_nonclosure_certificate_proof,
            expected_obstruction,
            expected_frontier,
            expected_frontier_proof,
        ) = (
            expected_surface
        )
        if target_prop != expected_target:
            failures.append(
                f"{target_id} target prop {target_prop!r} != expected {expected_target!r}"
            )
        if target_route != expected_target_route:
            failures.append(
                f"{target_id} target route {target_route!r} != expected {expected_target_route!r}"
            )
        if target_route_proof != expected_target_route_proof:
            failures.append(
                f"{target_id} target route proof {target_route_proof!r} != expected {expected_target_route_proof!r}"
            )
        if target_route_certificate != expected_target_route_certificate:
            failures.append(
                f"{target_id} target route certificate {target_route_certificate!r} != expected {expected_target_route_certificate!r}"
            )
        if target_route_certificate_proof != expected_target_route_certificate_proof:
            failures.append(
                f"{target_id} target route certificate proof {target_route_certificate_proof!r} != expected {expected_target_route_certificate_proof!r}"
            )
        if target_route_obstruction != expected_target_route_obstruction:
            failures.append(
                f"{target_id} target route obstruction {target_route_obstruction!r} != expected {expected_target_route_obstruction!r}"
            )
        if closure_route != expected_closure_route:
            failures.append(
                f"{target_id} closure route {closure_route!r} != expected {expected_closure_route!r}"
            )
        if closure_route_proof != expected_closure_route_proof:
            failures.append(
                f"{target_id} closure route proof {closure_route_proof!r} != expected {expected_closure_route_proof!r}"
            )
        if route_equivalence_proof != expected_route_equivalence_proof:
            failures.append(
                f"{target_id} route equivalence proof {route_equivalence_proof!r} != expected {expected_route_equivalence_proof!r}"
            )
        if closure_route_certificate != expected_closure_route_certificate:
            failures.append(
                f"{target_id} closure route certificate {closure_route_certificate!r} != expected {expected_closure_route_certificate!r}"
            )
        if closure_route_certificate_proof != expected_closure_route_certificate_proof:
            failures.append(
                f"{target_id} closure route certificate proof {closure_route_certificate_proof!r} != expected {expected_closure_route_certificate_proof!r}"
            )
        if closure_route_obstruction != expected_closure_route_obstruction:
            failures.append(
                f"{target_id} closure route obstruction {closure_route_obstruction!r} != expected {expected_closure_route_obstruction!r}"
            )
        if frontier_progress_certificate != expected_frontier_progress_certificate:
            failures.append(
                f"{target_id} frontier progress certificate {frontier_progress_certificate!r} != expected {expected_frontier_progress_certificate!r}"
            )
        if frontier_progress_certificate_proof != expected_frontier_progress_certificate_proof:
            failures.append(
                f"{target_id} frontier progress certificate proof {frontier_progress_certificate_proof!r} != expected {expected_frontier_progress_certificate_proof!r}"
            )
        if frontier_nonclosure_certificate != expected_frontier_nonclosure_certificate:
            failures.append(
                f"{target_id} frontier nonclosure certificate {frontier_nonclosure_certificate!r} != expected {expected_frontier_nonclosure_certificate!r}"
            )
        if frontier_nonclosure_certificate_proof != expected_frontier_nonclosure_certificate_proof:
            failures.append(
                f"{target_id} frontier nonclosure certificate proof {frontier_nonclosure_certificate_proof!r} != expected {expected_frontier_nonclosure_certificate_proof!r}"
            )
        if obstruction != expected_obstruction:
            failures.append(
                f"{target_id} obstruction {obstruction!r} != expected {expected_obstruction!r}"
            )
        if frontier != expected_frontier:
            failures.append(
                f"{target_id} frontier certificate {frontier!r} != expected {expected_frontier!r}"
            )
        if frontier_proof != expected_frontier_proof:
            failures.append(
                f"{target_id} frontier proof {frontier_proof!r} != expected {expected_frontier_proof!r}"
            )
    missing_surface_ids = sorted(set(EXPECTED_OPEN_KERNEL_SURFACES) - set(kernel_surface_ids))
    for target_id in missing_surface_ids:
        failures.append(f"missing kernel-surface id: {target_id}")
    for (
        target_id,
        payload_certificate,
        payload_certificate_proof,
        target_prop,
        target_current_obstruction_proof,
        target_route,
        target_route_proof,
        target_route_certificate,
        target_route_certificate_proof,
        target_route_obstruction_proof,
        closure_route,
        closure_route_proof,
        route_equivalence_proof,
        closure_route_certificate,
        closure_route_certificate_proof,
        closure_route_obstruction_proof,
        frontier_progress_certificate,
        frontier_progress_certificate_proof,
        frontier_nonclosure_certificate,
        frontier_nonclosure_certificate_proof,
        frontier_certificate,
        frontier_certificate_proof,
    ) in payload_surfaces:
        expected_payload_surface = EXPECTED_OPEN_FRONTIER_PAYLOAD_SURFACES.get(target_id)
        if expected_payload_surface is None:
            failures.append(f"unexpected frontier-payload surface id: {target_id}")
            continue
        (
            _expected_payload_term,
            expected_payload_certificate,
            expected_payload_certificate_proof,
            expected_target_prop,
            expected_target_current_obstruction_proof,
            expected_target_route,
            expected_target_route_proof,
            expected_target_route_certificate,
            expected_target_route_certificate_proof,
            expected_target_route_obstruction_proof,
            expected_closure_route,
            expected_closure_route_proof,
            expected_route_equivalence_proof,
            expected_closure_route_certificate,
            expected_closure_route_certificate_proof,
            expected_closure_route_obstruction_proof,
            expected_frontier_progress_certificate,
            expected_frontier_progress_certificate_proof,
            expected_frontier_nonclosure_certificate,
            expected_frontier_nonclosure_certificate_proof,
            expected_frontier_certificate,
            expected_frontier_certificate_proof,
        ) = expected_payload_surface
        if payload_certificate != expected_payload_certificate:
            failures.append(
                f"{target_id} payload certificate {payload_certificate!r} != expected {expected_payload_certificate!r}"
            )
        if payload_certificate_proof != expected_payload_certificate_proof:
            failures.append(
                f"{target_id} payload certificate proof {payload_certificate_proof!r} != expected {expected_payload_certificate_proof!r}"
            )
        if target_prop != expected_target_prop:
            failures.append(
                f"{target_id} payload target prop {target_prop!r} != expected {expected_target_prop!r}"
            )
        if target_current_obstruction_proof != expected_target_current_obstruction_proof:
            failures.append(
                f"{target_id} payload target obstruction proof {target_current_obstruction_proof!r} != expected {expected_target_current_obstruction_proof!r}"
            )
        if target_route != expected_target_route:
            failures.append(
                f"{target_id} payload target route {target_route!r} != expected {expected_target_route!r}"
            )
        if target_route_proof != expected_target_route_proof:
            failures.append(
                f"{target_id} payload target route proof {target_route_proof!r} != expected {expected_target_route_proof!r}"
            )
        if target_route_certificate != expected_target_route_certificate:
            failures.append(
                f"{target_id} payload target route certificate {target_route_certificate!r} != expected {expected_target_route_certificate!r}"
            )
        if target_route_certificate_proof != expected_target_route_certificate_proof:
            failures.append(
                f"{target_id} payload target route certificate proof {target_route_certificate_proof!r} != expected {expected_target_route_certificate_proof!r}"
            )
        if target_route_obstruction_proof != expected_target_route_obstruction_proof:
            failures.append(
                f"{target_id} payload target route obstruction proof {target_route_obstruction_proof!r} != expected {expected_target_route_obstruction_proof!r}"
            )
        if closure_route != expected_closure_route:
            failures.append(
                f"{target_id} payload closure route {closure_route!r} != expected {expected_closure_route!r}"
            )
        if closure_route_proof != expected_closure_route_proof:
            failures.append(
                f"{target_id} payload closure route proof {closure_route_proof!r} != expected {expected_closure_route_proof!r}"
            )
        if route_equivalence_proof != expected_route_equivalence_proof:
            failures.append(
                f"{target_id} payload route equivalence proof {route_equivalence_proof!r} != expected {expected_route_equivalence_proof!r}"
            )
        if closure_route_certificate != expected_closure_route_certificate:
            failures.append(
                f"{target_id} payload closure route certificate {closure_route_certificate!r} != expected {expected_closure_route_certificate!r}"
            )
        if closure_route_certificate_proof != expected_closure_route_certificate_proof:
            failures.append(
                f"{target_id} payload closure route certificate proof {closure_route_certificate_proof!r} != expected {expected_closure_route_certificate_proof!r}"
            )
        if closure_route_obstruction_proof != expected_closure_route_obstruction_proof:
            failures.append(
                f"{target_id} payload closure route obstruction proof {closure_route_obstruction_proof!r} != expected {expected_closure_route_obstruction_proof!r}"
            )
        if frontier_progress_certificate != expected_frontier_progress_certificate:
            failures.append(
                f"{target_id} payload progress certificate {frontier_progress_certificate!r} != expected {expected_frontier_progress_certificate!r}"
            )
        if frontier_progress_certificate_proof != expected_frontier_progress_certificate_proof:
            failures.append(
                f"{target_id} payload progress proof {frontier_progress_certificate_proof!r} != expected {expected_frontier_progress_certificate_proof!r}"
            )
        if frontier_nonclosure_certificate != expected_frontier_nonclosure_certificate:
            failures.append(
                f"{target_id} payload nonclosure certificate {frontier_nonclosure_certificate!r} != expected {expected_frontier_nonclosure_certificate!r}"
            )
        if frontier_nonclosure_certificate_proof != expected_frontier_nonclosure_certificate_proof:
            failures.append(
                f"{target_id} payload nonclosure proof {frontier_nonclosure_certificate_proof!r} != expected {expected_frontier_nonclosure_certificate_proof!r}"
            )
        if frontier_certificate != expected_frontier_certificate:
            failures.append(
                f"{target_id} payload frontier certificate {frontier_certificate!r} != expected {expected_frontier_certificate!r}"
            )
        if frontier_certificate_proof != expected_frontier_certificate_proof:
            failures.append(
                f"{target_id} payload frontier proof {frontier_certificate_proof!r} != expected {expected_frontier_certificate_proof!r}"
            )
    missing_payload_surface_ids = sorted(
        set(EXPECTED_OPEN_FRONTIER_PAYLOAD_SURFACES) - set(payload_surface_ids)
    )
    for target_id in missing_payload_surface_ids:
        failures.append(f"missing frontier-payload surface id: {target_id}")
    for (
        target_id,
        target_prop,
        closure_input,
        input_to_target,
        input_obstruction,
        target_obstruction,
        input_certificate,
        input_certificate_proof,
    ) in closure_input_surfaces:
        expected_input_surface = EXPECTED_OPEN_CLOSURE_INPUT_SURFACES.get(target_id)
        if expected_input_surface is None:
            failures.append(f"unexpected closure-input surface id: {target_id}")
            continue
        (
            expected_target_prop,
            expected_closure_input,
            expected_input_to_target,
            expected_input_obstruction,
            expected_target_obstruction,
            expected_input_certificate,
            expected_input_certificate_proof,
        ) = expected_input_surface
        if target_prop != expected_target_prop:
            failures.append(
                f"{target_id} closure-input target prop {target_prop!r} != expected {expected_target_prop!r}"
            )
        if closure_input != expected_closure_input:
            failures.append(
                f"{target_id} closure input {closure_input!r} != expected {expected_closure_input!r}"
            )
        if input_to_target != expected_input_to_target:
            failures.append(
                f"{target_id} closure input proof {input_to_target!r} != expected {expected_input_to_target!r}"
            )
        if input_obstruction != expected_input_obstruction:
            failures.append(
                f"{target_id} closure input obstruction {input_obstruction!r} != expected {expected_input_obstruction!r}"
            )
        if target_obstruction != expected_target_obstruction:
            failures.append(
                f"{target_id} closure-input target obstruction {target_obstruction!r} != expected {expected_target_obstruction!r}"
            )
        if input_certificate != expected_input_certificate:
            failures.append(
                f"{target_id} closure-input certificate {input_certificate!r} != expected {expected_input_certificate!r}"
            )
        if input_certificate_proof != expected_input_certificate_proof:
            failures.append(
                f"{target_id} closure-input certificate proof {input_certificate_proof!r} != expected {expected_input_certificate_proof!r}"
            )
    missing_closure_input_surface_ids = sorted(
        set(EXPECTED_OPEN_CLOSURE_INPUT_SURFACES) - set(closure_input_surface_ids)
    )
    for target_id in missing_closure_input_surface_ids:
        failures.append(f"missing closure-input surface id: {target_id}")
    for (
        target_id,
        target_prop,
        exact_closure_input,
        sufficient_closure_input,
        target_to_exact_input,
        exact_input_to_target,
        target_iff_exact_input,
        sufficient_to_exact_input,
        exact_input_obstruction,
    ) in exact_closure_input_surfaces:
        expected_exact_surface = EXPECTED_OPEN_EXACT_CLOSURE_INPUT_SURFACES.get(
            target_id
        )
        if expected_exact_surface is None:
            failures.append(f"unexpected exact closure-input surface id: {target_id}")
            continue
        (
            expected_target_prop,
            expected_exact_closure_input,
            expected_sufficient_closure_input,
            expected_target_to_exact_input,
            expected_exact_input_to_target,
            expected_target_iff_exact_input,
            expected_sufficient_to_exact_input,
            expected_exact_input_obstruction,
        ) = expected_exact_surface
        if target_prop != expected_target_prop:
            failures.append(
                f"{target_id} exact closure target prop {target_prop!r} != expected {expected_target_prop!r}"
            )
        if exact_closure_input != expected_exact_closure_input:
            failures.append(
                f"{target_id} exact closure input {exact_closure_input!r} != expected {expected_exact_closure_input!r}"
            )
        if sufficient_closure_input != expected_sufficient_closure_input:
            failures.append(
                f"{target_id} sufficient closure input {sufficient_closure_input!r} != expected {expected_sufficient_closure_input!r}"
            )
        if target_to_exact_input != expected_target_to_exact_input:
            failures.append(
                f"{target_id} target-to-exact proof {target_to_exact_input!r} != expected {expected_target_to_exact_input!r}"
            )
        if exact_input_to_target != expected_exact_input_to_target:
            failures.append(
                f"{target_id} exact-to-target proof {exact_input_to_target!r} != expected {expected_exact_input_to_target!r}"
            )
        if target_iff_exact_input != expected_target_iff_exact_input:
            failures.append(
                f"{target_id} target iff exact proof {target_iff_exact_input!r} != expected {expected_target_iff_exact_input!r}"
            )
        if sufficient_to_exact_input != expected_sufficient_to_exact_input:
            failures.append(
                f"{target_id} sufficient-to-exact proof {sufficient_to_exact_input!r} != expected {expected_sufficient_to_exact_input!r}"
            )
        if exact_input_obstruction != expected_exact_input_obstruction:
            failures.append(
                f"{target_id} exact input obstruction {exact_input_obstruction!r} != expected {expected_exact_input_obstruction!r}"
            )
    missing_exact_closure_input_surface_ids = sorted(
        set(EXPECTED_OPEN_EXACT_CLOSURE_INPUT_SURFACES)
        - set(exact_closure_input_surface_ids)
    )
    for target_id in missing_exact_closure_input_surface_ids:
        failures.append(f"missing exact closure-input surface id: {target_id}")
    for (
        target_id,
        closure_input,
        field_payload,
        field_payload_proof,
        field_payload_to_closure_input,
        field_payload_iff_closure_input,
        field_payload_obstruction,
        field_certificate,
        field_certificate_proof,
    ) in closure_input_field_surfaces:
        expected_field_surface = EXPECTED_OPEN_CLOSURE_INPUT_FIELD_SURFACES.get(
            target_id
        )
        if expected_field_surface is None:
            failures.append(f"unexpected closure-input field surface id: {target_id}")
            continue
        (
            expected_closure_input,
            expected_field_payload,
            expected_field_payload_proof,
            expected_field_payload_to_closure_input,
            expected_field_payload_iff_closure_input,
            expected_field_payload_obstruction,
            expected_field_certificate,
            expected_field_certificate_proof,
        ) = expected_field_surface
        if closure_input != expected_closure_input:
            failures.append(
                f"{target_id} closure-input field input {closure_input!r} != expected {expected_closure_input!r}"
            )
        if field_payload != expected_field_payload:
            failures.append(
                f"{target_id} field payload {field_payload!r} != expected {expected_field_payload!r}"
            )
        if field_payload_proof != expected_field_payload_proof:
            failures.append(
                f"{target_id} field payload proof {field_payload_proof!r} != expected {expected_field_payload_proof!r}"
            )
        if field_payload_to_closure_input != expected_field_payload_to_closure_input:
            failures.append(
                f"{target_id} field payload-to-closure proof {field_payload_to_closure_input!r} != expected {expected_field_payload_to_closure_input!r}"
            )
        if field_payload_iff_closure_input != expected_field_payload_iff_closure_input:
            failures.append(
                f"{target_id} field payload iff closure-input proof {field_payload_iff_closure_input!r} != expected {expected_field_payload_iff_closure_input!r}"
            )
        if field_payload_obstruction != expected_field_payload_obstruction:
            failures.append(
                f"{target_id} field payload obstruction {field_payload_obstruction!r} != expected {expected_field_payload_obstruction!r}"
            )
        if field_certificate != expected_field_certificate:
            failures.append(
                f"{target_id} field certificate {field_certificate!r} != expected {expected_field_certificate!r}"
            )
        if field_certificate_proof != expected_field_certificate_proof:
            failures.append(
                f"{target_id} field certificate proof {field_certificate_proof!r} != expected {expected_field_certificate_proof!r}"
            )
    missing_closure_input_field_surface_ids = sorted(
        set(EXPECTED_OPEN_CLOSURE_INPUT_FIELD_SURFACES)
        - set(closure_input_field_surface_ids)
    )
    for target_id in missing_closure_input_field_surface_ids:
        failures.append(f"missing closure-input field surface id: {target_id}")
    for (
        target_id,
        field_payload,
        target_prop,
        exact_closure_input,
        output_bundle,
        field_payload_to_target,
        field_payload_to_exact_input,
        field_payload_to_output,
        field_payload_obstruction,
        field_output_certificate,
        field_output_certificate_proof,
    ) in closure_input_field_output_surfaces:
        expected_field_output_surface = (
            EXPECTED_OPEN_CLOSURE_INPUT_FIELD_OUTPUT_SURFACES.get(target_id)
        )
        if expected_field_output_surface is None:
            failures.append(
                f"unexpected closure-input field-output surface id: {target_id}"
            )
            continue
        (
            expected_field_payload,
            expected_target_prop,
            expected_exact_closure_input,
            expected_output_bundle,
            expected_field_payload_to_target,
            expected_field_payload_to_exact_input,
            expected_field_payload_to_output,
            expected_field_payload_obstruction,
            expected_field_output_certificate,
            expected_field_output_certificate_proof,
        ) = expected_field_output_surface
        if field_payload != expected_field_payload:
            failures.append(
                f"{target_id} field-output payload {field_payload!r} != expected {expected_field_payload!r}"
            )
        if target_prop != expected_target_prop:
            failures.append(
                f"{target_id} field-output target {target_prop!r} != expected {expected_target_prop!r}"
            )
        if exact_closure_input != expected_exact_closure_input:
            failures.append(
                f"{target_id} field-output exact input {exact_closure_input!r} != expected {expected_exact_closure_input!r}"
            )
        if output_bundle != expected_output_bundle:
            failures.append(
                f"{target_id} field-output bundle {output_bundle!r} != expected {expected_output_bundle!r}"
            )
        if field_payload_to_target != expected_field_payload_to_target:
            failures.append(
                f"{target_id} field-output target proof {field_payload_to_target!r} != expected {expected_field_payload_to_target!r}"
            )
        if field_payload_to_exact_input != expected_field_payload_to_exact_input:
            failures.append(
                f"{target_id} field-output exact proof {field_payload_to_exact_input!r} != expected {expected_field_payload_to_exact_input!r}"
            )
        if field_payload_to_output != expected_field_payload_to_output:
            failures.append(
                f"{target_id} field-output bundle proof {field_payload_to_output!r} != expected {expected_field_payload_to_output!r}"
            )
        if field_payload_obstruction != expected_field_payload_obstruction:
            failures.append(
                f"{target_id} field-output obstruction {field_payload_obstruction!r} != expected {expected_field_payload_obstruction!r}"
            )
        if field_output_certificate != expected_field_output_certificate:
            failures.append(
                f"{target_id} field-output certificate {field_output_certificate!r} != expected {expected_field_output_certificate!r}"
            )
        if field_output_certificate_proof != expected_field_output_certificate_proof:
            failures.append(
                f"{target_id} field-output certificate proof {field_output_certificate_proof!r} != expected {expected_field_output_certificate_proof!r}"
            )
    missing_closure_input_field_output_surface_ids = sorted(
        set(EXPECTED_OPEN_CLOSURE_INPUT_FIELD_OUTPUT_SURFACES)
        - set(closure_input_field_output_surface_ids)
    )
    for target_id in missing_closure_input_field_output_surface_ids:
        failures.append(f"missing closure-input field-output surface id: {target_id}")
    for (
        target_id,
        target_prop,
        output_bundle,
        target_to_output_bundle,
        output_bundle_to_target,
        target_iff_output_bundle,
        output_bundle_obstruction,
    ) in output_equivalence_surfaces:
        expected_output_surface = EXPECTED_OPEN_OUTPUT_EQUIVALENCE_SURFACES.get(
            target_id
        )
        if expected_output_surface is None:
            failures.append(f"unexpected output-equivalence surface id: {target_id}")
            continue
        (
            expected_target_prop,
            expected_output_bundle,
            expected_target_to_output_bundle,
            expected_output_bundle_to_target,
            expected_target_iff_output_bundle,
            expected_output_bundle_obstruction,
        ) = expected_output_surface
        if target_prop != expected_target_prop:
            failures.append(
                f"{target_id} output target prop {target_prop!r} != expected {expected_target_prop!r}"
            )
        if output_bundle != expected_output_bundle:
            failures.append(
                f"{target_id} output bundle {output_bundle!r} != expected {expected_output_bundle!r}"
            )
        if target_to_output_bundle != expected_target_to_output_bundle:
            failures.append(
                f"{target_id} target-to-output proof {target_to_output_bundle!r} != expected {expected_target_to_output_bundle!r}"
            )
        if output_bundle_to_target != expected_output_bundle_to_target:
            failures.append(
                f"{target_id} output-to-target proof {output_bundle_to_target!r} != expected {expected_output_bundle_to_target!r}"
            )
        if target_iff_output_bundle != expected_target_iff_output_bundle:
            failures.append(
                f"{target_id} target iff output proof {target_iff_output_bundle!r} != expected {expected_target_iff_output_bundle!r}"
            )
        if output_bundle_obstruction != expected_output_bundle_obstruction:
            failures.append(
                f"{target_id} output obstruction {output_bundle_obstruction!r} != expected {expected_output_bundle_obstruction!r}"
            )
    missing_output_equivalence_surface_ids = sorted(
        set(EXPECTED_OPEN_OUTPUT_EQUIVALENCE_SURFACES)
        - set(output_equivalence_surface_ids)
    )
    for target_id in missing_output_equivalence_surface_ids:
        failures.append(f"missing output-equivalence surface id: {target_id}")
    for (
        target_id,
        target_prop,
        exact_closure_input,
        output_bundle,
        exact_input_to_output_bundle,
        output_bundle_to_exact_input,
        exact_input_iff_output_bundle,
        target_iff_exact_input,
        target_iff_output_bundle,
        exact_input_obstruction,
        output_bundle_obstruction,
    ) in exact_closure_input_output_surfaces:
        expected_exact_output_surface = (
            EXPECTED_OPEN_EXACT_CLOSURE_INPUT_OUTPUT_SURFACES.get(target_id)
        )
        if expected_exact_output_surface is None:
            failures.append(
                f"unexpected exact closure-input/output surface id: {target_id}"
            )
            continue
        (
            expected_target_prop,
            expected_exact_closure_input,
            expected_output_bundle,
            expected_exact_input_to_output_bundle,
            expected_output_bundle_to_exact_input,
            expected_exact_input_iff_output_bundle,
            expected_target_iff_exact_input,
            expected_target_iff_output_bundle,
            expected_exact_input_obstruction,
            expected_output_bundle_obstruction,
        ) = expected_exact_output_surface
        if target_prop != expected_target_prop:
            failures.append(
                f"{target_id} exact-output target prop {target_prop!r} != expected {expected_target_prop!r}"
            )
        if exact_closure_input != expected_exact_closure_input:
            failures.append(
                f"{target_id} exact-output exact input {exact_closure_input!r} != expected {expected_exact_closure_input!r}"
            )
        if output_bundle != expected_output_bundle:
            failures.append(
                f"{target_id} exact-output bundle {output_bundle!r} != expected {expected_output_bundle!r}"
            )
        if exact_input_to_output_bundle != expected_exact_input_to_output_bundle:
            failures.append(
                f"{target_id} exact-to-output proof {exact_input_to_output_bundle!r} != expected {expected_exact_input_to_output_bundle!r}"
            )
        if output_bundle_to_exact_input != expected_output_bundle_to_exact_input:
            failures.append(
                f"{target_id} output-to-exact proof {output_bundle_to_exact_input!r} != expected {expected_output_bundle_to_exact_input!r}"
            )
        if exact_input_iff_output_bundle != expected_exact_input_iff_output_bundle:
            failures.append(
                f"{target_id} exact iff output proof {exact_input_iff_output_bundle!r} != expected {expected_exact_input_iff_output_bundle!r}"
            )
        if target_iff_exact_input != expected_target_iff_exact_input:
            failures.append(
                f"{target_id} target iff exact proof {target_iff_exact_input!r} != expected {expected_target_iff_exact_input!r}"
            )
        if target_iff_output_bundle != expected_target_iff_output_bundle:
            failures.append(
                f"{target_id} target iff output proof {target_iff_output_bundle!r} != expected {expected_target_iff_output_bundle!r}"
            )
        if exact_input_obstruction != expected_exact_input_obstruction:
            failures.append(
                f"{target_id} exact-input obstruction {exact_input_obstruction!r} != expected {expected_exact_input_obstruction!r}"
            )
        if output_bundle_obstruction != expected_output_bundle_obstruction:
            failures.append(
                f"{target_id} output obstruction {output_bundle_obstruction!r} != expected {expected_output_bundle_obstruction!r}"
            )
    missing_exact_closure_input_output_surface_ids = sorted(
        set(EXPECTED_OPEN_EXACT_CLOSURE_INPUT_OUTPUT_SURFACES)
        - set(exact_closure_input_output_surface_ids)
    )
    for target_id in missing_exact_closure_input_output_surface_ids:
        failures.append(
            f"missing exact closure-input/output surface id: {target_id}"
        )
    for (
        target_id,
        target_prop,
        exact_closure_input,
        output_bundle,
        target_obstruction,
        exact_input_obstruction,
        output_bundle_obstruction,
        target_not_iff_exact,
        target_not_iff_output,
        exact_not_iff_output,
    ) in obstruction_equivalence_surfaces:
        expected_obstruction_surface = (
            EXPECTED_OPEN_OBSTRUCTION_EQUIVALENCE_SURFACES.get(target_id)
        )
        if expected_obstruction_surface is None:
            failures.append(
                f"unexpected obstruction-equivalence surface id: {target_id}"
            )
            continue
        (
            expected_target_prop,
            expected_exact_closure_input,
            expected_output_bundle,
            expected_target_obstruction,
            expected_exact_input_obstruction,
            expected_output_bundle_obstruction,
            expected_target_not_iff_exact,
            expected_target_not_iff_output,
            expected_exact_not_iff_output,
        ) = expected_obstruction_surface
        if target_prop != expected_target_prop:
            failures.append(
                f"{target_id} obstruction target prop {target_prop!r} != expected {expected_target_prop!r}"
            )
        if exact_closure_input != expected_exact_closure_input:
            failures.append(
                f"{target_id} obstruction exact input {exact_closure_input!r} != expected {expected_exact_closure_input!r}"
            )
        if output_bundle != expected_output_bundle:
            failures.append(
                f"{target_id} obstruction output bundle {output_bundle!r} != expected {expected_output_bundle!r}"
            )
        if target_obstruction != expected_target_obstruction:
            failures.append(
                f"{target_id} target obstruction {target_obstruction!r} != expected {expected_target_obstruction!r}"
            )
        if exact_input_obstruction != expected_exact_input_obstruction:
            failures.append(
                f"{target_id} exact-input obstruction {exact_input_obstruction!r} != expected {expected_exact_input_obstruction!r}"
            )
        if output_bundle_obstruction != expected_output_bundle_obstruction:
            failures.append(
                f"{target_id} output obstruction {output_bundle_obstruction!r} != expected {expected_output_bundle_obstruction!r}"
            )
        if target_not_iff_exact != expected_target_not_iff_exact:
            failures.append(
                f"{target_id} target-not-iff-exact proof {target_not_iff_exact!r} != expected {expected_target_not_iff_exact!r}"
            )
        if target_not_iff_output != expected_target_not_iff_output:
            failures.append(
                f"{target_id} target-not-iff-output proof {target_not_iff_output!r} != expected {expected_target_not_iff_output!r}"
            )
        if exact_not_iff_output != expected_exact_not_iff_output:
            failures.append(
                f"{target_id} exact-not-iff-output proof {exact_not_iff_output!r} != expected {expected_exact_not_iff_output!r}"
            )
    missing_obstruction_equivalence_surface_ids = sorted(
        set(EXPECTED_OPEN_OBSTRUCTION_EQUIVALENCE_SURFACES)
        - set(obstruction_equivalence_surface_ids)
    )
    for target_id in missing_obstruction_equivalence_surface_ids:
        failures.append(
            f"missing obstruction-equivalence surface id: {target_id}"
        )
    for decl in missing_axiom_audit_prints:
        failures.append(f"AxiomAudit.lean is missing '#print axioms {decl}'")
    if readme_axiom_audit_count is None:
        failures.append("lean4/README.md missing AxiomAudit required print count")
    elif readme_axiom_audit_count != required_axiom_audit_count:
        failures.append(
            "lean4/README.md AxiomAudit required count "
            f"{readme_axiom_audit_count} != audit count {required_axiom_audit_count}"
        )

    if open_count:
        for path, phrases in FORBIDDEN_WHEN_OPEN.items():
            if not path.exists():
                continue
            doc = read(path)
            for phrase in phrases:
                if phrase in doc:
                    failures.append(f"{path.relative_to(REPO_ROOT)} contains overclaim phrase: {phrase!r}")

    if failures:
        print()
        print("paper-semantic gate failures:")
        for failure in failures:
            print(f"- {failure}")
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
