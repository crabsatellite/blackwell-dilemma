#!/usr/bin/env python3
"""Audit AxiomAudit output against the allowed Lean kernel axiom set."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path


LEAN_ROOT = Path(__file__).resolve().parents[1]
REPO_ROOT = Path(__file__).resolve().parents[2]
PUBLIC_EVIDENCE_MANIFEST = REPO_ROOT / "reference-evidence" / "public_evidence_manifest.json"
PUBLIC_EVIDENCE_CHECK_ID = "axiom_output_allowed_audit"
ALLOWED_AXIOMS = frozenset({"propext", "Classical.choice", "Quot.sound"})


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


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--timeout", type=int, default=180)
    args = parser.parse_args()

    command = ["lake", "env", "lean", "BlackwellDilemma/AxiomAudit.lean"]
    result = subprocess.run(
        command,
        cwd=LEAN_ROOT,
        text=True,
        encoding="utf-8",
        errors="replace",
        capture_output=True,
        timeout=args.timeout,
    )
    output = result.stdout + result.stderr
    dependency_lines = re.findall(r"depends on axioms:\s*\[([^\]]*)\]", output)
    no_axiom_lines = re.findall(r"does not depend on any axioms", output)

    observed_axioms: set[str] = set()
    for axiom_blob in dependency_lines:
        observed_axioms.update(
            axiom.strip() for axiom in axiom_blob.split(",") if axiom.strip()
        )
    unexpected_axioms = observed_axioms - ALLOWED_AXIOMS

    output_lines = [
        "axiom_output_command=lake env lean BlackwellDilemma/AxiomAudit.lean",
        f"axiom_output_returncode={result.returncode}",
        f"axiom_output_dependency_lines={len(dependency_lines)}",
        f"axiom_output_no_axiom_lines={len(no_axiom_lines)}",
        "axiom_output_allowed_axioms=" + ",".join(sorted(ALLOWED_AXIOMS)),
        "axiom_output_observed_axioms=" + ",".join(sorted(observed_axioms)),
        f"axiom_output_unexpected_axioms={len(unexpected_axioms)}",
        "axiom_output_unexpected_axiom_names=" + ",".join(sorted(unexpected_axioms)),
    ]
    required_manifest_lines = [
        *output_lines,
        "public_manifest_axiom_output_stdout_contains_missing=0",
    ]
    manifest_missing_stdout_lines = public_manifest_missing_stdout_lines(
        PUBLIC_EVIDENCE_CHECK_ID,
        required_manifest_lines,
    )

    for line in output_lines:
        print(line)
    print(
        "public_manifest_axiom_output_stdout_contains_missing="
        f"{len(manifest_missing_stdout_lines)}"
    )

    failures: list[str] = []
    if result.returncode != 0:
        failures.append(f"AxiomAudit command exited {result.returncode}")
    if not dependency_lines:
        failures.append("AxiomAudit output contained no dependency lines")
    if unexpected_axioms:
        failures.append(
            "unexpected axioms in AxiomAudit output: "
            + ",".join(sorted(unexpected_axioms))
        )
    if manifest_missing_stdout_lines:
        failures.append(
            "public evidence manifest missing axiom-output stdout lines: "
            + ",".join(manifest_missing_stdout_lines)
        )

    if failures:
        print()
        print("axiom-output audit failures:")
        for failure in failures:
            print(f"- {failure}")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
