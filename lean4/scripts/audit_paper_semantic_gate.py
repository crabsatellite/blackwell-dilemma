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

import pathlib
import re
import sys


ROOT = pathlib.Path(__file__).resolve().parents[1]
REPO_ROOT = ROOT.parent
GATE = ROOT / "BlackwellDilemma" / "PaperSemanticGate.lean"
AXIOM_AUDIT = ROOT / "BlackwellDilemma" / "AxiomAudit.lean"

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
    ),
    "topo_cluster_random_supercritical_z2": (
        "topo_cluster_random_supercritical_z2_frontier_payload",
        "TopoClusterRandomSupercriticalZ2FrontierPayloadCertificate",
        "topo_cluster_random_supercritical_z2_frontier_payload_certificate",
    ),
}

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
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_target_route",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_target_route_current_obstruction",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_target_route_certificate",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_closure_route",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_route_equivalence",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_closure_route_current_obstruction",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_closure_route_certificate",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_frontier_progress_certificate",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetKernelSurface_frontier_nonclosure_certificate",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurfaceIds_current",
    "BlackwellDilemma.PaperSemanticGate.openSemanticTargetFrontierPayloadSurface_certificate",
    "BlackwellDilemma.PaperSemanticGate.RemainingOpenSemanticTargetsFrontierCertificate",
    "BlackwellDilemma.PaperSemanticGate.remaining_open_semantic_targets_frontier_certificate",
}


def read(path: pathlib.Path) -> str:
    return path.read_text(encoding="utf-8", errors="replace")


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


def open_frontier_payload_surfaces(text: str) -> list[tuple[str, str, str]]:
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
        r"payloadCertificateProof\s*:=\s*([A-Za-z0-9_'.]+)",
        match.group(1),
        flags=re.DOTALL,
    )
    if not surfaces:
        raise SystemExit("no open semantic target frontier-payload entries found")
    return surfaces


def has_axiom_audit_print(text: str, decl: str) -> bool:
    return (
        re.search(rf"^\s*#print\s+axioms\s+{re.escape(decl)}\s*$", text, flags=re.MULTILINE)
        is not None
    )


def main() -> int:
    text = read(GATE)
    axiom_audit_text = read(AXIOM_AUDIT)
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

    print(f"semantic_targets_open={open_count}")
    print(f"semantic_targets_closed={closed_count}")
    print(f"theorem_gate_open={expected_open}")
    print(f"theorem_gate_closed={expected_closed}")
    print(f"semantic_target_open_ids={','.join(open_ids)}")
    print(f"semantic_target_closed_ids={','.join(closed_ids)}")
    print(f"semantic_target_kernel_surface_ids={','.join(kernel_surface_ids)}")
    print(f"semantic_target_frontier_payload_surface_ids={','.join(payload_surface_ids)}")
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
    required_axiom_audit_decls = set(REQUIRED_AXIOM_AUDIT_DECLS)
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
    for target_id, payload_certificate, payload_certificate_proof in payload_surfaces:
        expected_payload_surface = EXPECTED_OPEN_FRONTIER_PAYLOAD_SURFACES.get(target_id)
        if expected_payload_surface is None:
            continue
        payload_term, _expected_payload_certificate, _expected_payload_certificate_proof = (
            expected_payload_surface
        )
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{payload_term}"
        )
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{payload_certificate}"
        )
        required_axiom_audit_decls.add(
            f"BlackwellDilemma.PaperSemanticGate.{payload_certificate_proof}"
        )
    print(f"semantic_target_axiom_audit_prints_required={len(required_axiom_audit_decls)}")

    failures: list[str] = []
    if open_count != expected_open:
        failures.append(f"open target count {open_count} != theorem gate {expected_open}")
    if closed_count != expected_closed:
        failures.append(f"closed target count {closed_count} != theorem gate {expected_closed}")
    if open_ids != expected_open_ids:
        failures.append(f"open target ids {open_ids!r} != theorem gate {expected_open_ids!r}")
    if closed_ids != expected_closed_ids:
        failures.append(f"closed target ids {closed_ids!r} != theorem gate {expected_closed_ids!r}")
    if kernel_surface_ids != open_ids:
        failures.append(
            f"kernel-surface ids {kernel_surface_ids!r} != open semantic target ids {open_ids!r}"
        )
    if payload_surface_ids != open_ids:
        failures.append(
            f"frontier-payload surface ids {payload_surface_ids!r} != open semantic target ids {open_ids!r}"
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
    for target_id, payload_certificate, payload_certificate_proof in payload_surfaces:
        expected_payload_surface = EXPECTED_OPEN_FRONTIER_PAYLOAD_SURFACES.get(target_id)
        if expected_payload_surface is None:
            failures.append(f"unexpected frontier-payload surface id: {target_id}")
            continue
        (
            _expected_payload_term,
            expected_payload_certificate,
            expected_payload_certificate_proof,
        ) = expected_payload_surface
        if payload_certificate != expected_payload_certificate:
            failures.append(
                f"{target_id} payload certificate {payload_certificate!r} != expected {expected_payload_certificate!r}"
            )
        if payload_certificate_proof != expected_payload_certificate_proof:
            failures.append(
                f"{target_id} payload certificate proof {payload_certificate_proof!r} != expected {expected_payload_certificate_proof!r}"
            )
    missing_payload_surface_ids = sorted(
        set(EXPECTED_OPEN_FRONTIER_PAYLOAD_SURFACES) - set(payload_surface_ids)
    )
    for target_id in missing_payload_surface_ids:
        failures.append(f"missing frontier-payload surface id: {target_id}")
    for decl in sorted(required_axiom_audit_decls):
        if not has_axiom_audit_print(axiom_audit_text, decl):
            failures.append(f"AxiomAudit.lean is missing '#print axioms {decl}'")

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
