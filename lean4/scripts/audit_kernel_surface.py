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
import pathlib
import re
import sys


ROOT_FILES = [pathlib.Path("BlackwellDilemma.lean")]
ROOT_DIR = pathlib.Path("BlackwellDilemma")


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


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--list", action="store_true", help="list matching declarations")
    args = parser.parse_args()

    hits: dict[str, list[tuple[pathlib.Path, int, str]]] = collections.defaultdict(list)

    for path in source_files():
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

    print(f"project_lean_files={len(source_files())}")
    for key in ("axiom", "constant", "opaque", "sorry", "admit", "unsafe", "native_decide"):
        print(f"{key}={len(hits[key])}")

    axiom_names = [name for _, _, name in hits["axiom"]]
    print(f"axiom_OPEN={sum(name.endswith('_OPEN') for name in axiom_names)}")
    print(f"axiom_paper_Def={sum(name.endswith('_paper_Def') for name in axiom_names)}")
    print(f"axiom_workingAssumption={sum('workingAssumption' in name for name in axiom_names)}")
    print(f"axiom_paper_witness={sum('paper_witness' in name for name in axiom_names)}")
    print(f"decl_workingAssumption={len(hits['decl_workingAssumption'])}")
    print(f"def_OPEN={len(hits['def_OPEN'])}")
    print(f"theorem_OPEN={len(hits['theorem_OPEN'])}")

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
    return 1 if bad_proof_escape or bad_decl_surface else 0


if __name__ == "__main__":
    sys.exit(main())
