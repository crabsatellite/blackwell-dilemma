#!/usr/bin/env python3
"""Audit the project-level Lean kernel surface.

This script is intentionally syntactic. It strips Lean block comments,
line comments, and string literals, then counts declaration-level escape
surfaces in the BlackwellDilemma source tree.

It does not replace `lake build` or `AxiomAudit`; it gives a stable
iteration metric for the complete kernel-only target.
"""

from __future__ import annotations

import argparse
import collections
import json
import pathlib
import re
import sys


ROOT_FILES = [pathlib.Path("BlackwellDilemma.lean")]
ROOT_DIR = pathlib.Path("BlackwellDilemma")
PUBLIC_EVIDENCE_MANIFEST = (
    pathlib.Path(__file__).resolve().parents[2]
    / "reference-evidence"
    / "public_evidence_manifest.json"
)
PUBLIC_EVIDENCE_CHECK_ID = "kernel_surface_zero_escape_audit"


def strip_comments_and_strings(text: str) -> str:
    out: list[str] = []
    i = 0
    block_depth = 0
    in_string = False
    escaped = False

    while i < len(text):
        ch = text[i]

        if in_string:
            if escaped:
                escaped = False
                out.append(" ")
                i += 1
            elif ch == "\\":
                escaped = True
                out.append(" ")
                i += 1
            elif ch == '"':
                in_string = False
                out.append(" ")
                i += 1
            else:
                out.append("\n" if ch == "\n" else " ")
                i += 1
        elif block_depth == 0 and text.startswith("/-", i):
            block_depth = 1
            out.append("  ")
            i += 2
        elif block_depth > 0 and text.startswith("/-", i):
            block_depth += 1
            out.append("  ")
            i += 2
        elif block_depth > 0 and text.startswith("-/", i):
            block_depth -= 1
            out.append("  ")
            i += 2
        elif block_depth > 0:
            out.append("\n" if ch == "\n" else " ")
            i += 1
        elif text.startswith("--", i):
            while i < len(text) and text[i] != "\n":
                out.append(" ")
                i += 1
        elif ch == '"':
            in_string = True
            out.append(" ")
            i += 1
        else:
            out.append(ch)
            i += 1

    return "".join(out)


def source_files() -> list[pathlib.Path]:
    files = [p for p in ROOT_FILES if p.exists()]
    if ROOT_DIR.exists():
        files.extend(sorted(ROOT_DIR.rglob("*.lean")))
    return files


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
    parser.add_argument("--list", action="store_true", help="list matching declarations")
    args = parser.parse_args()

    hits: dict[str, list[tuple[pathlib.Path, int, str]]] = collections.defaultdict(list)
    files = source_files()

    for path in files:
        clean = strip_comments_and_strings(path.read_text(encoding="utf-8"))
        for line_no, line in enumerate(clean.splitlines(), 1):
            if m := re.match(r"\s*axiom\s+([^\s:(]+)", line):
                hits["axiom"].append((path, line_no, m.group(1)))
            if m := re.match(r"\s*constant\s+([^\s:(]+)", line):
                hits["constant"].append((path, line_no, m.group(1)))
            if m := re.match(r"\s*opaque\s+([^\s:(]+)", line):
                hits["opaque"].append((path, line_no, m.group(1)))
            for keyword in ("sorry", "admit", "unsafe", "native_decide"):
                if re.search(rf"\b{keyword}\b", line):
                    hits[keyword].append((path, line_no, line.strip()))
            if m := re.match(
                r"\s*(?:noncomputable\s+)?(def|theorem|lemma)\s+([^\s:(]+)",
                line,
            ):
                decl_kind = m.group(1)
                name = m.group(2)
                if "workingAssumption" in name:
                    hits["decl_workingAssumption"].append((path, line_no, name))
                if decl_kind == "def" and name.endswith("_OPEN"):
                    hits["def_OPEN"].append((path, line_no, name))
                if decl_kind in ("theorem", "lemma") and name.endswith("_OPEN"):
                    hits["theorem_OPEN"].append((path, line_no, name))

    axiom_names = [name for _, _, name in hits["axiom"]]
    output_lines = [
        f"project_lean_files={len(files)}",
        f"axiom={len(hits['axiom'])}",
        f"constant={len(hits['constant'])}",
        f"opaque={len(hits['opaque'])}",
        f"sorry={len(hits['sorry'])}",
        f"admit={len(hits['admit'])}",
        f"unsafe={len(hits['unsafe'])}",
        f"native_decide={len(hits['native_decide'])}",
        f"axiom_OPEN={sum(name.endswith('_OPEN') for name in axiom_names)}",
        f"axiom_paper_Def={sum(name.endswith('_paper_Def') for name in axiom_names)}",
        f"axiom_workingAssumption={sum('workingAssumption' in name for name in axiom_names)}",
        f"axiom_paper_witness={sum('paper_witness' in name for name in axiom_names)}",
        f"decl_workingAssumption={len(hits['decl_workingAssumption'])}",
        f"def_OPEN={len(hits['def_OPEN'])}",
        f"theorem_OPEN={len(hits['theorem_OPEN'])}",
    ]
    for line in output_lines:
        print(line)

    required_manifest_lines = [
        *output_lines,
        "public_manifest_kernel_stdout_contains_missing=0",
    ]
    manifest_missing_stdout_lines = public_manifest_missing_stdout_lines(
        PUBLIC_EVIDENCE_CHECK_ID,
        required_manifest_lines,
    )
    print(
        "public_manifest_kernel_stdout_contains_missing="
        f"{len(manifest_missing_stdout_lines)}"
    )

    if args.list:
        print()
        for key in (
            "axiom",
            "constant",
            "opaque",
            "sorry",
            "admit",
            "unsafe",
            "native_decide",
            "decl_workingAssumption",
            "def_OPEN",
            "theorem_OPEN",
        ):
            if not hits[key]:
                continue
            print(f"[{key}]")
            for path, line_no, name in hits[key]:
                print(f"{path.as_posix()}:{line_no}: {name}")

    bad_proof_escape = any(hits[key] for key in ("sorry", "admit", "unsafe", "native_decide"))
    bad_decl_surface = any(hits[key] for key in ("decl_workingAssumption",))
    if manifest_missing_stdout_lines:
        print()
        print("public-manifest kernel stdout missing:")
        for line in manifest_missing_stdout_lines:
            print(f"- {line}")
    bad_public_manifest = bool(manifest_missing_stdout_lines)
    return 1 if bad_proof_escape or bad_decl_surface or bad_public_manifest else 0


if __name__ == "__main__":
    sys.exit(main())
