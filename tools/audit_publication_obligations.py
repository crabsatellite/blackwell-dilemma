#!/usr/bin/env python3
"""Derive strict-kernel and publication-evidence closure from repo artifacts."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
import time
from collections import Counter
from pathlib import Path
from typing import Any


REPO_ROOT = Path(__file__).resolve().parents[1]
LEAN_ROOT = REPO_ROOT / "lean4"
INVENTORY_PATH = REPO_ROOT / "paper" / "claim_inventory.json"
OBLIGATIONS_PATH = REPO_ROOT / "paper" / "publication_obligations.json"
ASSUMPTIONS_PATH = REPO_ROOT / "paper" / "model_assumptions.json"
REFERENCE_PATH = REPO_ROOT / "reference-evidence" / "reference_registry.json"
PUBLIC_MANIFEST_PATH = REPO_ROOT / "reference-evidence" / "public_evidence_manifest.json"
DERIVED_LEDGER_PATH = REPO_ROOT / "paper" / "publication_evidence_ledger.json"
KNOWN_TYPES = {
    "lean_exact",
    "lean_conditional",
    "external_references",
    "model_assumptions",
    "statement_hash",
    "computational_certificate",
    "unresolved_semantics",
    "demote_to_discussion",
}
DERIVATION_TYPES = {"lean_exact", "lean_conditional", "demote_to_discussion"}
FORBIDDEN_MANUAL_KEYS = {"status", "closed", "reasonable", "verified"}
RESOLUTION_CLASSES = {
    "existing_theory_scope",
    "paper_model_encoding",
    "hybrid_model_and_strategy_evidence",
}
THEORY_EVIDENCE_CLASSES = {"theorem", "theoretical_model"}


class AuditError(RuntimeError):
    pass


def run_lean_command(command: list[str]) -> subprocess.CompletedProcess[str]:
    """Retry only the Windows empty-output 0xFFFFFFFF process failure."""
    for attempt in range(3):
        result = subprocess.run(
            command,
            cwd=LEAN_ROOT,
            text=True,
            encoding="utf-8",
            errors="replace",
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            check=False,
        )
        transient = (
            sys.platform == "win32"
            and result.returncode in {-1, 0xFFFFFFFF}
            and not result.stdout.strip()
        )
        if not transient or attempt == 2:
            return result
        time.sleep(0.5 * (attempt + 1))
    raise AssertionError("unreachable")


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def reject_manual_keys(value: Any, location: str) -> None:
    if isinstance(value, dict):
        forbidden = FORBIDDEN_MANUAL_KEYS.intersection(value)
        if forbidden:
            raise AuditError(f"{location}: forbidden manual fields {sorted(forbidden)}")
        for key, child in value.items():
            reject_manual_keys(child, f"{location}.{key}")
    elif isinstance(value, list):
        for index, child in enumerate(value):
            reject_manual_keys(child, f"{location}[{index}]")


def run_lean_states() -> dict[str, str]:
    build = run_lean_command(
        ["lake", "build", "BlackwellDilemma.PaperSemanticGate"]
    )
    if build.returncode != 0:
        raise AuditError(f"Lean semantic gate build exited {build.returncode}:\n{build.stdout}")
    result = run_lean_command(
        ["lake", "env", "lean", "BlackwellDilemma/PaperSemanticGate.lean"]
    )
    if result.returncode != 0:
        raise AuditError(f"Lean semantic gate exited {result.returncode}:\n{result.stdout}")
    rows = re.findall(
        r"paper_claim=([^|\s]+)\|"
        r"(closed|partial|conditional|refuted-encoding|unformalized)\|",
        result.stdout,
    )
    return dict(rows)


def validate_model_assumptions(
    data: dict[str, Any],
    references: dict[str, dict[str, Any]],
    check_ids: set[str],
) -> dict[str, dict[str, Any]]:
    if data.get("schema_version") != 1:
        raise AuditError("model assumptions schema_version must equal 1")
    policy = data.get("admissibility_policy", {})
    allowed_kinds = set(policy.get("allowed_kinds", []))
    allowed_testability = set(policy.get("allowed_testability_kinds", []))
    allowed_provenance = set(policy.get("allowed_provenance", []))
    allowed_theory_modes = set(policy.get("allowed_theory_evidence_modes", []))
    allowed_empirical_modes = set(policy.get("allowed_empirical_evidence_modes", []))
    assumptions = data.get("assumptions", [])
    ids = [item.get("id") for item in assumptions]
    if not ids or len(ids) != len(set(ids)):
        raise AuditError("model assumption ids must be nonempty and unique")

    evaluated: dict[str, dict[str, Any]] = {}
    for item in assumptions:
        assumption_id = item["id"]
        kind = item.get("kind")
        testability = item.get("testability", {})
        testability_kind = testability.get("kind")
        required_text = all(item.get(field) for field in ("statement", "scope", "role"))
        testability_ok = (
            testability_kind in allowed_testability and bool(testability.get("criterion"))
        )
        kind_ok = kind in allowed_kinds
        boundary_ok = (
            testability_kind == "model_boundary"
            if kind == "structural_definition"
            else testability_kind != "model_boundary"
        )
        truth_ok = item.get("empirical_truth_claimed") is False
        provenance = item.get("provenance")
        provenance_ok = provenance in allowed_provenance

        theory_evidence = item.get("theory_evidence", {})
        theory_mode = theory_evidence.get("mode")
        theory_reference_ids = theory_evidence.get("reference_ids", [])
        theory_references_valid = all(
            reference_id in references
            and references[reference_id].get("evidence_class") in THEORY_EVIDENCE_CLASSES
            for reference_id in theory_reference_ids
        )
        theory_mode_ok = theory_mode in allowed_theory_modes
        theory_shape_ok = (
            not theory_reference_ids
            if theory_mode == "not_required_for_conditional_theorem"
            else bool(theory_reference_ids)
        )
        theory_evidence_ok = all(
            (theory_mode_ok, theory_shape_ok, theory_references_valid)
        )

        empirical_evidence = item.get("empirical_evidence", {})
        empirical_mode = empirical_evidence.get("mode")
        empirical_reference_ids = empirical_evidence.get("reference_ids", [])
        empirical_check_ids = empirical_evidence.get("check_ids", [])
        empirical_mode_ok = empirical_mode in allowed_empirical_modes
        empirical_references_valid = all(
            reference_id in references
            and references[reference_id].get("evidence_class") == "empirical_study"
            for reference_id in empirical_reference_ids
        )
        empirical_checks_valid = all(check_id in check_ids for check_id in empirical_check_ids)
        empirical_required = empirical_mode == "required_for_real_world_application"
        empirical_inputs_present = bool(empirical_reference_ids or empirical_check_ids)
        empirically_anchored = all(
            (
                empirical_required,
                bool(empirical_reference_ids),
                bool(empirical_check_ids),
                empirical_references_valid,
                empirical_checks_valid,
            )
        )
        empirical_shape_ok = (
            not empirical_inputs_present
            if empirical_mode == "not_claimed"
            else empirical_references_valid and empirical_checks_valid
        )

        theory_admissible = all(
            (
                required_text,
                testability_ok,
                kind_ok,
                boundary_ok,
                truth_ok,
                provenance_ok,
                theory_evidence_ok,
                empirical_mode_ok,
                empirical_shape_ok,
            )
        )
        evaluated[assumption_id] = {
            "kind": kind,
            "provenance": provenance,
            "theory_admissible": theory_admissible,
            "theory_reference_ids": theory_reference_ids,
            "empirical_required": empirical_required,
            "empirically_anchored": empirically_anchored,
            "empirical_evidence_satisfied": not empirical_required or empirically_anchored,
            "empirical_reference_ids": empirical_reference_ids,
            "empirical_check_ids": empirical_check_ids,
        }
    return evaluated


def manifest_check_ids(data: dict[str, Any]) -> set[str]:
    return {
        check["id"]
        for claim in data.get("claims", [])
        for check in claim.get("checks", [])
        if check.get("id")
    }


def evaluate() -> dict[str, Any]:
    inventory = load_json(INVENTORY_PATH)
    obligations_data = load_json(OBLIGATIONS_PATH)
    assumptions_data = load_json(ASSUMPTIONS_PATH)
    references_data = load_json(REFERENCE_PATH)
    public_manifest = load_json(PUBLIC_MANIFEST_PATH)
    reject_manual_keys(obligations_data, "publication_obligations")
    reject_manual_keys(assumptions_data, "model_assumptions")

    if obligations_data.get("schema_version") != 1:
        raise AuditError("publication obligations schema_version must equal 1")
    inventory_claims = inventory.get("claims", [])
    obligation_claims = obligations_data.get("claims", [])
    inventory_labels = [claim["label"] for claim in inventory_claims]
    obligation_labels = [claim.get("label") for claim in obligation_claims]
    if obligation_labels != inventory_labels:
        raise AuditError("obligation claim roster/order differs from manuscript inventory")
    if not inventory_labels:
        raise AuditError("manuscript inventory is empty")

    lean_states = run_lean_states()
    if list(lean_states) != inventory_labels:
        raise AuditError("Lean claim roster/order differs from manuscript inventory")
    inventory_by_label = {claim["label"]: claim for claim in inventory_claims}
    references = {
        record["id"]: record for record in references_data.get("records", [])
    }
    check_ids = manifest_check_ids(public_manifest)
    assumptions = validate_model_assumptions(assumptions_data, references, check_ids)

    derived_claims: list[dict[str, Any]] = []
    obligation_counts: Counter[str] = Counter()
    obligation_pass_counts: Counter[str] = Counter()
    gap_counts: Counter[str] = Counter()
    semantic_resolution_counts: Counter[str] = Counter()

    for claim in obligation_claims:
        label = claim["label"]
        expected_hash = inventory_by_label[label].get("statement_sha256")
        if claim.get("statement_sha256") != expected_hash:
            raise AuditError(f"{label}: statement hash differs from manuscript inventory")
        obligations = claim.get("obligations", [])
        ids = [obligation.get("id") for obligation in obligations]
        if not obligations or any(not item for item in ids) or len(ids) != len(set(ids)):
            raise AuditError(f"{label}: obligation ids must be nonempty and unique")
        types = {obligation.get("type") for obligation in obligations}
        unknown = types - KNOWN_TYPES
        if unknown:
            raise AuditError(f"{label}: unknown obligation types {sorted(unknown)}")
        if not types.intersection(DERIVATION_TYPES):
            raise AuditError(f"{label}: no derivation or demotion obligation")

        results: list[dict[str, Any]] = []
        claim_assumption_ids: set[str] = set()
        semantic_resolution_classes: list[str] = []
        for obligation in obligations:
            obligation_id = obligation["id"]
            obligation_type = obligation["type"]
            obligation_counts[obligation_type] += 1
            detail = ""
            passed = False

            if obligation_type == "lean_exact":
                passed = lean_states[label] == "closed"
                detail = f"Lean state is {lean_states[label]}; exact closure requires closed"
            elif obligation_type == "lean_conditional":
                passed = lean_states[label] in {"conditional", "closed"}
                detail = (
                    f"Lean state is {lean_states[label]}; publication closure requires "
                    "a kernel-checked conditional or exact claim"
                )
            elif obligation_type == "external_references":
                requested = obligation.get("ids", [])
                missing = [reference_id for reference_id in requested if reference_id not in references]
                passed = bool(requested) and not missing
                detail = "pinned reference ids=" + ",".join(requested)
                if missing:
                    detail += "; missing=" + ",".join(missing)
            elif obligation_type == "model_assumptions":
                requested = obligation.get("ids", [])
                unknown_assumptions = [
                    assumption_id for assumption_id in requested if assumption_id not in assumptions
                ]
                if unknown_assumptions:
                    raise AuditError(
                        f"{label}/{obligation_id}: unknown model assumptions {unknown_assumptions}"
                    )
                claim_assumption_ids.update(requested)
                failed = [
                    assumption_id
                    for assumption_id in requested
                    if not assumptions[assumption_id]["theory_admissible"]
                ]
                passed = bool(requested) and not failed
                detail = "theory-admissible assumption ids=" + ",".join(requested)
                if failed:
                    detail += "; failed=" + ",".join(failed)
            elif obligation_type == "statement_hash":
                passed = claim["statement_sha256"] == expected_hash
                detail = f"statement_sha256={expected_hash}"
            elif obligation_type == "computational_certificate":
                requested = obligation.get("check_ids", [])
                missing = [check_id for check_id in requested if check_id not in check_ids]
                passed = bool(requested) and not missing
                detail = "manifest check ids=" + ",".join(requested)
                if missing:
                    detail += "; missing=" + ",".join(missing)
            elif obligation_type == "unresolved_semantics":
                detail = obligation.get("reason", "")
                if not detail:
                    raise AuditError(f"{label}/{obligation_id}: unresolved gap lacks reason")
                resolution_class = obligation.get("resolution_class")
                if resolution_class not in RESOLUTION_CLASSES:
                    raise AuditError(
                        f"{label}/{obligation_id}: invalid resolution_class {resolution_class}"
                    )
                semantic_resolution_classes.append(resolution_class)
                semantic_resolution_counts[resolution_class] += 1
            elif obligation_type == "demote_to_discussion":
                detail = obligation.get("reason", "")
                if not detail:
                    raise AuditError(f"{label}/{obligation_id}: demotion gap lacks reason")

            if passed:
                obligation_pass_counts[obligation_type] += 1
            else:
                gap_counts[obligation_type] += 1
            results.append(
                {
                    "id": obligation_id,
                    "type": obligation_type,
                    "passed": passed,
                    "detail": detail,
                }
            )

        strict_kernel = lean_states[label] == "closed"
        publication_evidence = all(result["passed"] for result in results)
        empirical_model_gaps = sorted(
            assumption_id
            for assumption_id in claim_assumption_ids
            if assumptions[assumption_id]["empirical_required"]
            and not assumptions[assumption_id]["empirically_anchored"]
        )
        model_evidence_closed = not empirical_model_gaps
        empirical_publication = publication_evidence and model_evidence_closed
        if "lean_conditional" in types:
            mathematical_route = "reference_conditional"
        elif "lean_exact" in types:
            mathematical_route = "model_internal_exact"
        else:
            mathematical_route = "discussion_demotion"
        if empirical_model_gaps:
            model_route = "real_strategy_evidence_required"
        elif claim_assumption_ids:
            model_route = "conditional_model_only"
        else:
            model_route = "none"
        derived_claims.append(
            {
                "label": label,
                "statement_sha256": expected_hash,
                "lean_state": lean_states[label],
                "strict_kernel_closed": strict_kernel,
                "publication_evidence_closed": publication_evidence,
                "empirical_publication_closed": empirical_publication,
                "mathematical_route": mathematical_route,
                "model_route": model_route,
                "model_assumption_ids": sorted(claim_assumption_ids),
                "empirical_model_gaps": empirical_model_gaps,
                "semantic_resolution_classes": semantic_resolution_classes,
                "obligations": results,
            }
        )

    summary = {
        "claims_total": len(derived_claims),
        "strict_kernel_closed": sum(claim["strict_kernel_closed"] for claim in derived_claims),
        "publication_evidence_closed": sum(
            claim["publication_evidence_closed"] for claim in derived_claims
        ),
        "empirical_publication_closed": sum(
            claim["empirical_publication_closed"] for claim in derived_claims
        ),
        "claims_model_evidence_closed": sum(
            not claim["empirical_model_gaps"] for claim in derived_claims
        ),
        "model_assumptions_total": len(assumptions),
        "model_assumptions_admissible": sum(
            assumption["theory_admissible"] for assumption in assumptions.values()
        ),
        "model_assumptions_theory_admissible": sum(
            assumption["theory_admissible"] for assumption in assumptions.values()
        ),
        "model_assumptions_theory_referenced": sum(
            bool(assumption["theory_reference_ids"])
            for assumption in assumptions.values()
        ),
        "model_assumptions_theory_reference_not_required": sum(
            not assumption["theory_reference_ids"]
            for assumption in assumptions.values()
        ),
        "model_assumptions_empirical_required": sum(
            assumption["empirical_required"] for assumption in assumptions.values()
        ),
        "model_assumptions_empirically_anchored": sum(
            assumption["empirically_anchored"] for assumption in assumptions.values()
        ),
        "model_assumptions_by_provenance": dict(
            sorted(Counter(
                assumption["provenance"] for assumption in assumptions.values()
            ).items())
        ),
        "obligations_total": sum(obligation_counts.values()),
        "obligations_passed": sum(obligation_pass_counts.values()),
        "obligations_by_type": dict(sorted(obligation_counts.items())),
        "passed_by_type": dict(sorted(obligation_pass_counts.items())),
        "gaps_by_type": dict(sorted(gap_counts.items())),
        "mathematical_routes": dict(
            sorted(Counter(claim["mathematical_route"] for claim in derived_claims).items())
        ),
        "model_routes": dict(
            sorted(Counter(claim["model_route"] for claim in derived_claims).items())
        ),
        "semantic_gaps_by_resolution_class": dict(
            sorted(semantic_resolution_counts.items())
        ),
    }
    return {
        "schema_version": 1,
        "generated_by": "tools/audit_publication_obligations.py",
        "manuscript_sha256": inventory["manuscript_sha256"],
        "summary": summary,
        "model_assumptions": [
            {"id": assumption_id, **evaluation}
            for assumption_id, evaluation in assumptions.items()
        ],
        "claims": derived_claims,
    }


def print_report(ledger: dict[str, Any]) -> None:
    summary = ledger["summary"]
    for key in (
        "claims_total",
        "strict_kernel_closed",
        "publication_evidence_closed",
        "empirical_publication_closed",
        "claims_model_evidence_closed",
        "model_assumptions_total",
        "model_assumptions_admissible",
        "model_assumptions_theory_admissible",
        "model_assumptions_theory_referenced",
        "model_assumptions_theory_reference_not_required",
        "model_assumptions_empirical_required",
        "model_assumptions_empirically_anchored",
        "obligations_total",
        "obligations_passed",
    ):
        print(f"publication_{key}={summary[key]}")
    print("publication_manual_status_fields=0")
    for gap_type, count in summary["gaps_by_type"].items():
        print(f"publication_gap_{gap_type}={count}")
    for provenance, count in summary["model_assumptions_by_provenance"].items():
        print(f"publication_model_assumption_provenance_{provenance}={count}")
    for route, count in summary["mathematical_routes"].items():
        print(f"publication_mathematical_route_{route}={count}")
    for route, count in summary["model_routes"].items():
        print(f"publication_model_route_{route}={count}")
    for resolution_class, count in summary["semantic_gaps_by_resolution_class"].items():
        print(f"publication_semantic_resolution_{resolution_class}={count}")
    for claim in ledger["claims"]:
        gaps = [
            f"{item['type']}:{item['id']}"
            for item in claim["obligations"]
            if not item["passed"]
        ]
        print(
            f"publication_claim={claim['label']}|"
            f"kernel:{int(claim['strict_kernel_closed'])}|"
            f"publication:{int(claim['publication_evidence_closed'])}|"
            f"empirical:{int(claim['empirical_publication_closed'])}|"
            f"math-route:{claim['mathematical_route']}|"
            f"model-route:{claim['model_route']}|"
            f"empirical-model-gaps:{','.join(claim['empirical_model_gaps'])}|"
            f"gaps:{','.join(gaps)}"
        )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write-ledger", action="store_true")
    parser.add_argument("--check-ledger", action="store_true")
    parser.add_argument("--require-publication-closed", action="store_true")
    parser.add_argument("--require-empirical-closed", action="store_true")
    parser.add_argument("--require-kernel-closed", action="store_true")
    args = parser.parse_args()
    if args.write_ledger and args.check_ledger:
        print("publication_audit_error=choose write or check, not both", file=sys.stderr)
        return 2

    try:
        ledger = evaluate()
    except (AuditError, KeyError, TypeError, ValueError, json.JSONDecodeError) as exc:
        print(f"publication_audit_error={exc}", file=sys.stderr)
        return 1

    rendered = json.dumps(ledger, indent=2, ensure_ascii=True) + "\n"
    if args.write_ledger:
        DERIVED_LEDGER_PATH.write_text(rendered, encoding="utf-8")
        print("publication_ledger_written=1")
    elif args.check_ledger:
        actual = DERIVED_LEDGER_PATH.read_text(encoding="utf-8") if DERIVED_LEDGER_PATH.exists() else ""
        stale = actual != rendered
        print(f"publication_ledger_stale={int(stale)}")
        if stale:
            return 1

    print_report(ledger)
    summary = ledger["summary"]
    if args.require_publication_closed and summary["publication_evidence_closed"] != summary["claims_total"]:
        return 1
    if args.require_empirical_closed and summary["empirical_publication_closed"] != summary["claims_total"]:
        return 1
    if args.require_kernel_closed and summary["strict_kernel_closed"] != summary["claims_total"]:
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
