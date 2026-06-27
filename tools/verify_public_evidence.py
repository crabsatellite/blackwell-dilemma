#!/usr/bin/env python3
"""Verify public reference, formula, numeric, and semantic-gate evidence.

The verifier is intentionally offline.  It checks only git-tracked local
artifacts declared in ``reference-evidence/public_evidence_manifest.json``:

* public text locations still contain the declared claim text;
* external formula/reference cards are present for cited outside results;
* result-backed public numbers still agree with committed JSON outputs;
* simple local formulas used in the appendix agree with their committed data;
* paper-semantic open targets remain explicitly gated instead of drifting into
  README-only claims; and
* manifest source-card, claim, location, and check identifiers are present and
  unique in their local scope.
"""

from __future__ import annotations

import argparse
import json
import math
import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any


@dataclass
class Failure:
    claim_id: str
    check_id: str
    message: str


def load_json(path: Path) -> Any:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        raise SystemExit(f"{path}: JSON parse error: {exc}") from exc


def repo_path(repo_root: Path, rel_path: str) -> Path:
    path = (repo_root / rel_path).resolve()
    try:
        path.relative_to(repo_root)
    except ValueError as exc:
        raise SystemExit(f"{rel_path}: path escapes repository root") from exc
    return path


def get_path(data: Any, parts: list[Any]) -> Any:
    cur = data
    for part in parts:
        if isinstance(cur, list):
            cur = cur[int(part)]
        elif isinstance(cur, dict):
            cur = cur[str(part)]
        else:
            raise KeyError(part)
    return cur


def close_enough(actual: float, expected: float, tolerance: float | None) -> bool:
    if tolerance is None:
        return actual == expected
    return math.isclose(actual, expected, rel_tol=0.0, abs_tol=tolerance)


def semantic_target_chunk(text: str, target_id: str) -> str:
    needle = f'id := "{target_id}"'
    start = text.find(needle)
    if start == -1:
        return ""
    next_target = text.find('id := "', start + len(needle))
    if next_target == -1:
        next_target = text.find("def openSemanticTargets", start)
    if next_target == -1:
        next_target = len(text)
    return text[start:next_target]


def check_unique_ids(items: list[dict[str, Any]], kind: str, owner_id: str) -> tuple[int, list[Failure]]:
    failures: list[Failure] = []
    seen: dict[str, int] = {}
    check_count = 0
    for index, item in enumerate(items):
        check_count += 1
        item_id = item.get("id")
        if not item_id:
            failures.append(Failure(owner_id, f"{kind}_id_present", f"missing id at index {index}"))
            continue
        if item_id in seen:
            failures.append(
                Failure(
                    owner_id,
                    f"{kind}_id_unique",
                    f"duplicate id {item_id!r} at index {index}; first index {seen[item_id]}",
                )
            )
        else:
            seen[item_id] = index
    return check_count, failures


def verify_manifest(manifest_path: Path) -> tuple[int, list[Failure]]:
    manifest_path = manifest_path.resolve()
    repo_root = manifest_path.parent.parent.resolve()
    manifest = load_json(manifest_path)

    failures: list[Failure] = []
    check_count = 0

    source_card_items = manifest.get("source_cards", [])
    count, id_failures = check_unique_ids(source_card_items, "source_card", "manifest")
    check_count += count
    failures.extend(id_failures)
    source_cards = {
        card["id"]: card for card in source_card_items if card.get("id")
    }
    referenced_cards: set[str] = set()

    for card_id, card in source_cards.items():
        for field in ("kind", "role", "status"):
            check_count += 1
            if not card.get(field):
                failures.append(Failure(card_id, f"source_card_{field}", "missing source-card field"))
        if not (card.get("source_url") or card.get("local_file") or card.get("bibliographic_note")):
            check_count += 1
            failures.append(Failure(card_id, "source_card_locator", "missing source URL/local file/note"))

    claim_items = manifest.get("claims", [])
    count, id_failures = check_unique_ids(claim_items, "claim", "manifest")
    check_count += count
    failures.extend(id_failures)

    for claim in claim_items:
        claim_id = claim.get("id", "<missing-id>")

        for card_id in claim.get("source_cards", []):
            check_count += 1
            referenced_cards.add(card_id)
            if card_id not in source_cards:
                failures.append(Failure(claim_id, "source_card_exists", f"unknown source card: {card_id}"))

        locations = claim.get("locations", [])
        count, id_failures = check_unique_ids(locations, "location", claim_id)
        check_count += count
        failures.extend(id_failures)

        for loc in locations:
            loc_id = loc.get("id", loc.get("path", "<location>"))
            path = repo_path(repo_root, loc["path"])
            check_count += 1
            if not path.exists():
                failures.append(Failure(claim_id, f"{loc_id}:exists", f"missing file: {loc['path']}"))
                continue
            text = path.read_text(encoding="utf-8")
            for snippet in loc.get("contains", []):
                check_count += 1
                if snippet not in text:
                    failures.append(
                        Failure(claim_id, f"{loc_id}:contains", f"snippet not found in {loc['path']}: {snippet}")
                    )

        checks = claim.get("checks", [])
        count, id_failures = check_unique_ids(checks, "check", claim_id)
        check_count += count
        failures.extend(id_failures)

        for check in checks:
            check_id = check.get("id", check.get("type", "<check>"))
            ctype = check["type"]
            check_count += 1

            try:
                if ctype == "json_numeric":
                    path = repo_path(repo_root, check["path"])
                    actual = float(get_path(load_json(path), check["json_path"]))
                    if "round" in check:
                        expected = float(check["expected"])
                        if round(actual, int(check["round"])) != expected:
                            failures.append(
                                Failure(claim_id, check_id, f"{actual} rounded to {check['round']} != {expected}")
                            )
                    elif "min" in check and actual < float(check["min"]):
                        failures.append(Failure(claim_id, check_id, f"{actual} < min {check['min']}"))
                    elif "max" in check and actual > float(check["max"]):
                        failures.append(Failure(claim_id, check_id, f"{actual} > max {check['max']}"))
                    elif "expected" in check and not close_enough(
                        actual, float(check["expected"]), check.get("tolerance")
                    ):
                        failures.append(Failure(claim_id, check_id, f"{actual} != {check['expected']}"))

                elif ctype == "uniform_topo_loss_formula":
                    path = repo_path(repo_root, check["path"])
                    actual = float(get_path(load_json(path), check["json_path"]))
                    total_vertices = int(check["total_vertices"])
                    cluster_size = int(check["cluster_size"])
                    expected = (total_vertices - cluster_size) / (
                        (total_vertices + 1) * (cluster_size + 1)
                    )
                    if not close_enough(actual, expected, float(check.get("tolerance", 1e-12))):
                        failures.append(Failure(claim_id, check_id, f"{actual} != formula {expected}"))

                elif ctype == "semantic_gate_status":
                    path = repo_path(repo_root, check["path"])
                    text = path.read_text(encoding="utf-8")
                    chunk = semantic_target_chunk(text, check["target_id"])
                    if not chunk:
                        failures.append(Failure(claim_id, check_id, f"semantic target missing: {check['target_id']}"))
                    expected_status = f"status := SemanticStatus.{check['status']}"
                    if chunk and expected_status not in chunk:
                        failures.append(Failure(claim_id, check_id, f"{check['target_id']} is not {check['status']}"))

                elif ctype == "regex_count":
                    path = repo_path(repo_root, check["path"])
                    text = path.read_text(encoding="utf-8")
                    count = len(re.findall(check["pattern"], text, flags=re.MULTILINE))
                    if count != int(check["expected_count"]):
                        failures.append(Failure(claim_id, check_id, f"count {count} != {check['expected_count']}"))

                elif ctype == "python_script":
                    script = repo_path(repo_root, check["path"])
                    cwd = repo_path(repo_root, check.get("cwd", "."))
                    result = subprocess.run(
                        [sys.executable, str(script)],
                        cwd=cwd,
                        text=True,
                        capture_output=True,
                        timeout=int(check.get("timeout_seconds", 120)),
                    )
                    if result.returncode != 0:
                        failures.append(
                            Failure(
                                claim_id,
                                check_id,
                                f"script exited {result.returncode}: {result.stdout}{result.stderr}",
                            )
                        )
                    for snippet in check.get("stdout_contains", []):
                        check_count += 1
                        if snippet not in result.stdout:
                            failures.append(
                                Failure(claim_id, check_id, f"script stdout missing: {snippet}")
                            )

                else:
                    failures.append(Failure(claim_id, check_id, f"unknown check type: {ctype}"))
            except subprocess.TimeoutExpired as exc:
                failures.append(Failure(claim_id, check_id, f"script timed out: {exc}"))
            except (KeyError, ValueError, TypeError) as exc:
                failures.append(Failure(claim_id, check_id, f"check error: {exc}"))

    for card_id in source_cards:
        check_count += 1
        if card_id not in referenced_cards:
            failures.append(Failure(card_id, "source_card_referenced", "source card is not referenced by any claim"))

    return check_count, failures


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "manifest",
        nargs="?",
        default="reference-evidence/public_evidence_manifest.json",
        help="Path to the public evidence manifest.",
    )
    args = parser.parse_args()

    check_count, failures = verify_manifest(Path(args.manifest))
    if failures:
        print(f"public_evidence_checks={check_count}")
        print(f"public_evidence_failures={len(failures)}")
        for failure in failures:
            print(f"FAIL {failure.claim_id}::{failure.check_id}: {failure.message}")
        return 1

    print(f"public_evidence_checks={check_count}")
    print("public_evidence_failures=0")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
