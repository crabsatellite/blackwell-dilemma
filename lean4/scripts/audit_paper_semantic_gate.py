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
        "part6_lattice_embedding_semantic_kernel_target_notYet",
        "Part6CurrentFrontierCertificate",
        "part6_current_frontier_certificate",
    ),
    "topo_cluster_random_supercritical_z2": (
        "TopoClusterRandomSupercriticalZ2SemanticKernelTarget",
        "topo_cluster_random_supercritical_z2_semantic_kernel_target_notYet",
        "RandomSupercriticalZ2TopoClusterCurrentFrontierCertificate",
        "random_supercritical_z2_topo_cluster_current_frontier_certificate",
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


def open_kernel_surfaces(text: str) -> list[tuple[str, str, str, str, str]]:
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
        r"currentObstruction\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"frontierCertificate\s*:=\s*([A-Za-z0-9_'.]+).*?"
        r"frontierCertificateProof\s*:=\s*([A-Za-z0-9_'.]+)",
        match.group(1),
        flags=re.DOTALL,
    )
    if not surfaces:
        raise SystemExit("no open semantic target kernel-surface entries found")
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
    kernel_surface_ids = [
        target_id
        for target_id, _target, _obstruction, _frontier, _frontier_proof in kernel_surfaces
    ]

    print(f"semantic_targets_open={open_count}")
    print(f"semantic_targets_closed={closed_count}")
    print(f"theorem_gate_open={expected_open}")
    print(f"theorem_gate_closed={expected_closed}")
    print(f"semantic_target_open_ids={','.join(open_ids)}")
    print(f"semantic_target_closed_ids={','.join(closed_ids)}")
    print(f"semantic_target_kernel_surface_ids={','.join(kernel_surface_ids)}")
    print(
        "semantic_target_kernel_surface_targets="
        + ",".join(
            target
            for _target_id, target, _obstruction, _frontier, _frontier_proof in kernel_surfaces
        )
    )
    print(
        "semantic_target_kernel_surface_obstructions="
        + ",".join(
            obstruction
            for _target_id, _target, obstruction, _frontier, _frontier_proof in kernel_surfaces
        )
    )
    print(
        "semantic_target_kernel_surface_frontier_certificates="
        + ",".join(
            frontier
            for _target_id, _target, _obstruction, frontier, _frontier_proof in kernel_surfaces
        )
    )
    print(
        "semantic_target_kernel_surface_frontier_proofs="
        + ",".join(
            frontier_proof
            for _target_id, _target, _obstruction, _frontier, frontier_proof in kernel_surfaces
        )
    )
    required_axiom_audit_decls = set(REQUIRED_AXIOM_AUDIT_DECLS)
    for _target_id, target_prop, obstruction, frontier, frontier_proof in kernel_surfaces:
        required_axiom_audit_decls.add(f"BlackwellDilemma.PaperSemanticGate.{target_prop}")
        required_axiom_audit_decls.add(f"BlackwellDilemma.PaperSemanticGate.{obstruction}")
        required_axiom_audit_decls.add(f"BlackwellDilemma.{frontier}")
        required_axiom_audit_decls.add(f"BlackwellDilemma.{frontier_proof}")
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
    for target_id, target_prop, obstruction, frontier, frontier_proof in kernel_surfaces:
        expected_surface = EXPECTED_OPEN_KERNEL_SURFACES.get(target_id)
        if expected_surface is None:
            failures.append(f"unexpected kernel-surface id: {target_id}")
            continue
        expected_target, expected_obstruction, expected_frontier, expected_frontier_proof = (
            expected_surface
        )
        if target_prop != expected_target:
            failures.append(
                f"{target_id} target prop {target_prop!r} != expected {expected_target!r}"
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
