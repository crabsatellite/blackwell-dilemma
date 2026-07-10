#!/usr/bin/env python3
"""Verify that manuscript repairs preserve every checkpointed research claim."""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from collections import Counter
from pathlib import Path
from typing import Any


REPO_ROOT = Path(__file__).resolve().parents[1]
INVENTORY_PATH = REPO_ROOT / "paper" / "claim_inventory.json"
LINEAGE_PATH = REPO_ROOT / "paper" / "claim_lineage.json"
OBLIGATIONS_PATH = REPO_ROOT / "paper" / "publication_obligations.json"
PUBLIC_MANIFEST_PATH = REPO_ROOT / "reference-evidence" / "public_evidence_manifest.json"
BASELINE_COMMIT = "6746bf3d8830d9771f15607f6c9edf168eab1594"
PARENT_CHECKPOINT_COMMIT = "f19371df76d74ac0b5f2d837910ee67f63b373af"
INVENTORY_REPO_PATH = "paper/claim_inventory.json"
ALLOWED_RELATIONS = {
    "unchanged",
    "equivalent_restatement",
    "strengthened_assumptions",
    "split_core_and_frontier",
    "counterexample_delimited",
}
FORBIDDEN_MANUAL_KEYS = {"status", "closed", "reasonable", "verified"}


class LineageError(RuntimeError):
    pass


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def git_json(commit: str, path: str) -> dict[str, Any]:
    result = subprocess.run(
        ["git", "show", f"{commit}:{path}"],
        cwd=REPO_ROOT,
        text=True,
        encoding="utf-8",
        errors="strict",
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    if result.returncode != 0:
        raise LineageError(
            f"cannot read baseline {commit}:{path}; full git history is required: "
            f"{result.stderr.strip()}"
        )
    return json.loads(result.stdout)


def reject_manual_keys(value: Any, location: str) -> None:
    if isinstance(value, dict):
        forbidden = FORBIDDEN_MANUAL_KEYS.intersection(value)
        if forbidden:
            raise LineageError(
                f"{location}: forbidden manual fields {sorted(forbidden)}"
            )
        for key, child in value.items():
            reject_manual_keys(child, f"{location}.{key}")
    elif isinstance(value, list):
        for index, child in enumerate(value):
            reject_manual_keys(child, f"{location}[{index}]")


def initial_lineage(
    baseline: dict[str, Any], current: dict[str, Any]
) -> dict[str, Any]:
    baseline_claims = {claim["label"]: claim for claim in baseline["claims"]}
    current_claims = {claim["label"]: claim for claim in current["claims"]}
    if baseline_claims != current_claims:
        raise LineageError(
            "initial lineage can only be written while the current inventory equals the baseline"
        )
    return {
        "schema_version": 1,
        "policy": {
            "baseline_public_commit": BASELINE_COMMIT,
            "parent_manuscript_checkpoint_commit": PARENT_CHECKPOINT_COMMIT,
            "baseline_manuscript_sha256": baseline["manuscript_sha256"],
            "preservation_rule": (
                "Every checkpointed research claim remains addressable. A repaired "
                "publication statement may narrow assumptions or split off a proved core, "
                "but it may not silently erase the original research target."
            ),
            "allowed_relations": sorted(ALLOWED_RELATIONS),
        },
        "claims": [
            {
                "baseline_label": claim["label"],
                "baseline_kind": claim["kind"],
                "baseline_title": claim["title"],
                "baseline_statement_sha256": claim["statement_sha256"],
                "relation": "unchanged",
                "publication_labels": [claim["label"]],
                "research_target": (
                    "Preserve the checkpointed statement as the active research target "
                    "until a machine-gated repair or proof supersedes this publication form."
                ),
                "machine_witnesses": [],
            }
            for claim in baseline["claims"]
        ],
        "new_claims": [],
    }


def manifest_check_ids(data: dict[str, Any]) -> set[str]:
    return {
        check["id"]
        for claim in data.get("claims", [])
        for check in claim.get("checks", [])
        if check.get("id")
    }


def evaluate(
    baseline: dict[str, Any],
    current: dict[str, Any],
    lineage: dict[str, Any],
    obligations: dict[str, Any],
    public_manifest: dict[str, Any],
) -> dict[str, Any]:
    reject_manual_keys(lineage, "claim_lineage")
    if lineage.get("schema_version") != 1:
        raise LineageError("claim lineage schema_version must equal 1")

    policy = lineage.get("policy", {})
    expected_policy = {
        "baseline_public_commit": BASELINE_COMMIT,
        "parent_manuscript_checkpoint_commit": PARENT_CHECKPOINT_COMMIT,
        "baseline_manuscript_sha256": baseline.get("manuscript_sha256"),
        "allowed_relations": sorted(ALLOWED_RELATIONS),
    }
    for key, expected in expected_policy.items():
        if policy.get(key) != expected:
            raise LineageError(
                f"policy {key} mismatch: expected={expected!r} actual={policy.get(key)!r}"
            )
    if not policy.get("preservation_rule"):
        raise LineageError("policy preservation_rule must be nonempty")

    baseline_claims = {claim["label"]: claim for claim in baseline.get("claims", [])}
    current_claims = {claim["label"]: claim for claim in current.get("claims", [])}
    if len(baseline_claims) != len(baseline.get("claims", [])):
        raise LineageError("baseline inventory has duplicate labels")
    if len(current_claims) != len(current.get("claims", [])):
        raise LineageError("current inventory has duplicate labels")
    obligation_keys = {
        (claim["label"], obligation["id"])
        for claim in obligations.get("claims", [])
        for obligation in claim.get("obligations", [])
    }
    check_ids = manifest_check_ids(public_manifest)

    records = lineage.get("claims", [])
    record_labels = [record.get("baseline_label") for record in records]
    if len(record_labels) != len(set(record_labels)):
        raise LineageError("lineage has duplicate baseline labels")
    if set(record_labels) != set(baseline_claims):
        missing = sorted(set(baseline_claims) - set(record_labels))
        extra = sorted(set(record_labels) - set(baseline_claims))
        raise LineageError(f"baseline coverage mismatch: missing={missing} extra={extra}")

    covered_publication_labels: list[str] = []
    relation_counts: Counter[str] = Counter()
    for record in records:
        baseline_label = record["baseline_label"]
        baseline_claim = baseline_claims[baseline_label]
        for field in ("kind", "title", "statement_sha256"):
            actual = record.get(f"baseline_{field}")
            if actual != baseline_claim[field]:
                raise LineageError(
                    f"{baseline_label}: baseline_{field} mismatch: "
                    f"expected={baseline_claim[field]!r} actual={actual!r}"
                )

        relation = record.get("relation")
        if relation not in ALLOWED_RELATIONS:
            raise LineageError(f"{baseline_label}: invalid relation {relation!r}")
        relation_counts[relation] += 1
        publication_labels = record.get("publication_labels", [])
        if not publication_labels or len(publication_labels) != len(set(publication_labels)):
            raise LineageError(
                f"{baseline_label}: publication_labels must be nonempty and unique"
            )
        unknown = sorted(set(publication_labels) - set(current_claims))
        if unknown:
            raise LineageError(
                f"{baseline_label}: unknown publication labels {unknown}"
            )
        covered_publication_labels.extend(publication_labels)
        if not record.get("research_target"):
            raise LineageError(f"{baseline_label}: research_target must be nonempty")
        witnesses = record.get("machine_witnesses")
        if not isinstance(witnesses, list):
            raise LineageError(f"{baseline_label}: machine_witnesses must be a list")
        for witness in witnesses:
            if not isinstance(witness, dict):
                raise LineageError(
                    f"{baseline_label}: each machine witness must be an object"
                )
            witness_type = witness.get("type")
            if witness_type == "publication_obligation":
                key = (witness.get("claim_label"), witness.get("id"))
                if key not in obligation_keys:
                    raise LineageError(
                        f"{baseline_label}: unknown publication obligation witness {key}"
                    )
            elif witness_type == "evidence_check":
                if witness.get("id") not in check_ids:
                    raise LineageError(
                        f"{baseline_label}: unknown evidence check witness "
                        f"{witness.get('id')!r}"
                    )
            else:
                raise LineageError(
                    f"{baseline_label}: invalid machine witness type {witness_type!r}"
                )

        if relation == "unchanged":
            if publication_labels != [baseline_label]:
                raise LineageError(
                    f"{baseline_label}: unchanged relation must preserve its label"
                )
            if current_claims[baseline_label]["statement_sha256"] != baseline_claim[
                "statement_sha256"
            ]:
                raise LineageError(
                    f"{baseline_label}: changed statement requires a repaired relation"
                )
            if witnesses:
                raise LineageError(
                    f"{baseline_label}: unchanged relation must not claim machine witnesses"
                )
        elif not witnesses:
            raise LineageError(
                f"{baseline_label}: repaired relation requires machine_witnesses"
            )

    new_claims = lineage.get("new_claims", [])
    new_labels = [item.get("label") for item in new_claims]
    if len(new_labels) != len(set(new_labels)):
        raise LineageError("new_claims has duplicate labels")
    for item in new_claims:
        label = item.get("label")
        if label not in current_claims:
            raise LineageError(f"new claim {label!r} is absent from current inventory")
        if not item.get("research_target"):
            raise LineageError(f"new claim {label!r} lacks research_target")

    all_covered = covered_publication_labels + new_labels
    duplicates = sorted(
        label for label, count in Counter(all_covered).items() if count > 1
    )
    if duplicates:
        raise LineageError(f"current labels covered more than once: {duplicates}")
    if set(all_covered) != set(current_claims):
        missing = sorted(set(current_claims) - set(all_covered))
        extra = sorted(set(all_covered) - set(current_claims))
        raise LineageError(
            f"current claim coverage mismatch: missing={missing} extra={extra}"
        )

    return {
        "baseline_claims": len(baseline_claims),
        "current_claims": len(current_claims),
        "preserved_claims": len(records),
        "new_claims": len(new_claims),
        "relations": dict(sorted(relation_counts.items())),
    }


def print_report(summary: dict[str, Any]) -> None:
    print(f"claim_lineage_baseline_commit={BASELINE_COMMIT}")
    print(f"claim_lineage_parent_checkpoint={PARENT_CHECKPOINT_COMMIT}")
    for key in ("baseline_claims", "current_claims", "preserved_claims", "new_claims"):
        print(f"claim_lineage_{key}={summary[key]}")
    for relation, count in summary["relations"].items():
        print(f"claim_lineage_relation_{relation}={count}")
    print("claim_lineage_manual_status_fields=0")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write-lineage", action="store_true")
    args = parser.parse_args()

    try:
        baseline = git_json(BASELINE_COMMIT, INVENTORY_REPO_PATH)
        current = load_json(INVENTORY_PATH)
        obligations = load_json(OBLIGATIONS_PATH)
        public_manifest = load_json(PUBLIC_MANIFEST_PATH)
        if args.write_lineage:
            lineage = initial_lineage(baseline, current)
            LINEAGE_PATH.write_text(
                json.dumps(lineage, indent=2, ensure_ascii=True) + "\n",
                encoding="utf-8",
            )
            print("claim_lineage_written=1")
        else:
            lineage = load_json(LINEAGE_PATH)
        summary = evaluate(
            baseline, current, lineage, obligations, public_manifest
        )
    except (LineageError, FileNotFoundError, json.JSONDecodeError) as exc:
        print(f"claim_lineage_error={exc}", file=sys.stderr)
        return 1
    print_report(summary)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
