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


def main() -> int:
    text = read(GATE)
    open_ids, closed_ids = semantic_target_ids_by_status(text)
    open_count = len(open_ids)
    closed_count = len(closed_ids)

    expected_open = theorem_count(text, "paperSemanticOpenCount_current")
    expected_closed = theorem_count(text, "paperSemanticClosedCount_current")
    expected_open_ids = theorem_id_list(text, "openSemanticTargetIds_current")
    expected_closed_ids = theorem_id_list(text, "closedSemanticTargetIds_current")

    print(f"semantic_targets_open={open_count}")
    print(f"semantic_targets_closed={closed_count}")
    print(f"theorem_gate_open={expected_open}")
    print(f"theorem_gate_closed={expected_closed}")
    print(f"semantic_target_open_ids={','.join(open_ids)}")
    print(f"semantic_target_closed_ids={','.join(closed_ids)}")

    failures: list[str] = []
    if open_count != expected_open:
        failures.append(f"open target count {open_count} != theorem gate {expected_open}")
    if closed_count != expected_closed:
        failures.append(f"closed target count {closed_count} != theorem gate {expected_closed}")
    if open_ids != expected_open_ids:
        failures.append(f"open target ids {open_ids!r} != theorem gate {expected_open_ids!r}")
    if closed_ids != expected_closed_ids:
        failures.append(f"closed target ids {closed_ids!r} != theorem gate {expected_closed_ids!r}")

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
