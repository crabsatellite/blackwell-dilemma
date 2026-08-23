#!/usr/bin/env python3
"""Fail-closed release gate for the current Theory and Decision formal map."""

from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path


LEAN_ROOT = Path(__file__).resolve().parent
REPO_ROOT = LEAN_ROOT.parent
CURRENT_LEAN_FILES = [LEAN_ROOT / "BlackwellDilemma.lean"] + sorted(
    (LEAN_ROOT / "BlackwellDilemma").rglob("*.lean")
)
LIVE_PAPER = (
    REPO_ROOT.parent
    / "blackwell-dilemma-internal"
    / "paper"
    / "blackwell_theory_decision.tex"
)
EXPECTED_VERSION = "1.2.0"


def run(command: list[str], cwd: Path = LEAN_ROOT) -> str:
    result = subprocess.run(
        command,
        cwd=cwd,
        text=True,
        encoding="utf-8",
        errors="replace",
        capture_output=True,
    )
    output = result.stdout + result.stderr
    if result.returncode:
        print(output)
        raise SystemExit(f"command failed ({result.returncode}): {' '.join(command)}")
    return output


def strip_comments_and_strings(text: str) -> str:
    out: list[str] = []
    i = 0
    block_depth = 0
    in_string = False
    escaped = False
    while i < len(text):
        if in_string:
            char = text[i]
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                in_string = False
            out.append("\n" if char == "\n" else " ")
            i += 1
        elif block_depth == 0 and text.startswith("/-", i):
            block_depth = 1
            out.extend("  ")
            i += 2
        elif block_depth > 0 and text.startswith("/-", i):
            block_depth += 1
            out.extend("  ")
            i += 2
        elif block_depth > 0 and text.startswith("-/", i):
            block_depth -= 1
            out.extend("  ")
            i += 2
        elif block_depth > 0:
            out.append("\n" if text[i] == "\n" else " ")
            i += 1
        elif text.startswith("--", i):
            while i < len(text) and text[i] != "\n":
                out.append(" ")
                i += 1
        elif text[i] == '"':
            in_string = True
            out.append(" ")
            i += 1
        else:
            out.append(text[i])
            i += 1
    return "".join(out)


def audit_current_source() -> None:
    forbidden = re.compile(r"\b(sorry|admit|unsafe|native_decide|axiom|constant|opaque)\b")
    hits: list[str] = []
    for path in CURRENT_LEAN_FILES:
        if not path.is_file():
            hits.append(f"missing:{path.relative_to(LEAN_ROOT)}")
            continue
        clean = strip_comments_and_strings(path.read_text(encoding="utf-8"))
        for line_no, line in enumerate(clean.splitlines(), 1):
            if forbidden.search(line):
                hits.append(f"{path.relative_to(LEAN_ROOT)}:{line_no}:{line.strip()}")
    if hits:
        raise SystemExit("current formal source is not clean:\n" + "\n".join(hits))


def main() -> int:
    audit_current_source()

    lakefile = (LEAN_ROOT / "lakefile.toml").read_text(encoding="utf-8")
    if f'version = "{EXPECTED_VERSION}"' not in lakefile:
        raise SystemExit("lakefile release version drifted")
    if not (REPO_ROOT / "LICENSE").is_file():
        raise SystemExit("repository LICENSE is missing")
    citation = (REPO_ROOT / "CITATION.cff").read_text(encoding="utf-8")
    if f"version: {EXPECTED_VERSION}" not in citation:
        raise SystemExit("CITATION.cff release version drifted")

    build_output = run(
        [
            "lake",
            "build",
            "BlackwellDilemma",
            "BlackwellDilemma.CurrentPaperAxiomAudit",
        ]
    )
    if "error:" in build_output.lower():
        raise SystemExit("Lean build output contains an error marker")

    strict_lean = ["lake", "env", "lean", "--trust=0", "-DwarningAsError=true"]
    status_output = run(strict_lean + ["BlackwellDilemma/CurrentPaperStatus.lean"])
    required_status = "current-paper theory map: entries=10 closed=10 unfinished=0"
    if required_status not in status_output:
        raise SystemExit("current-paper status output drifted")

    run(strict_lean + ["BlackwellDilemma/TheoremMap.lean"])
    axiom_output = run(strict_lean + ["BlackwellDilemma/CurrentPaperAxiomAudit.lean"])
    if re.search(r"depends on axioms:\s*\[[^\]]*BlackwellDilemma", axiom_output, re.DOTALL):
        raise SystemExit("current-paper endpoint depends on a project axiom")
    if axiom_output.count("depends on axioms:") != 9:
        raise SystemExit("current-paper axiom endpoint count drifted")

    audit_command = [sys.executable, "scripts/audit_current_theory_map.py"]
    if not LIVE_PAPER.is_file():
        audit_command.append("--inventory-only")
    correspondence_output = run(audit_command)
    if "current_theory_map_gate=passed" not in correspondence_output:
        raise SystemExit("current theory-map correspondence gate did not pass")
    if "current_theory_map_derivations=37" not in correspondence_output:
        raise SystemExit("current derivation-map coverage drifted")

    print("blackwell_current_release_gate=passed")
    print("blackwell_current_theory_map=10/10")
    print("blackwell_current_derivation_map=37/37")
    print(f"blackwell_current_source_files={len(CURRENT_LEAN_FILES)}")
    print("blackwell_current_unfinished=0")
    print("blackwell_current_project_axioms=0")
    print(f"blackwell_current_release_version={EXPECTED_VERSION}")
    print(f"blackwell_live_manuscript_checked={LIVE_PAPER.is_file()}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
