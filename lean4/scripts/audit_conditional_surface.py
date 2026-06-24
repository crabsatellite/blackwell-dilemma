#!/usr/bin/env python3
"""Audit explicit conditional proof surfaces in the BlackwellDilemma Lean tree.

`audit_kernel_surface.py` checks hard proof escapes: source axioms, opaque
declarations, sorry/admit, and legacy `_OPEN` names.  This script checks the
next layer toward a complete kernel-only proof: theorem signatures that still
take explicit bridge, witness, or carrier-interface propositions as premises.

The audit is intentionally syntactic.  It is a progress metric, not a Lean
elaborator and not a replacement for `lake build` or `AxiomAudit.lean`.
"""

from __future__ import annotations

import argparse
import collections
import pathlib
import re
import sys


ROOT_FILES = [pathlib.Path("BlackwellDilemma.lean")]
ROOT_DIR = pathlib.Path("BlackwellDilemma")
EXCLUDED_FILES = {pathlib.Path("BlackwellDilemma/Ledger.lean")}

INTERFACE_NAME_RE = re.compile(
    r"("
    r"_paper_Def$|"
    r"paper_Def$|"
    r"Witness|"
    r"Conclusion$|"
    r"Interfaces?$|"
    r"Carriers?$|"
    r"Hypothesis(Data)?$|"
    r"DifferenceDominatesUnderFOSD$|"
    r"MonotoneUnderDiffDom$|"
    r"finite_above_limit_witness$"
    r")"
)

DECL_START_RE = re.compile(
    r"(?m)^\s*(?:@\[[^\n]*\]\s*)*"
    r"(?:private\s+|protected\s+|noncomputable\s+)*"
    r"(theorem|lemma|def|class|structure)\s+([^\s:(]+)"
)


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
    return [p for p in files if p not in EXCLUDED_FILES]


def line_no_at(text: str, offset: int) -> int:
    return text.count("\n", 0, offset) + 1


def decl_head(text: str, start: int) -> str:
    end = text.find(":=", start)
    if end == -1:
        end = text.find("\nwhere", start)
    if end == -1:
        end = text.find("\n\n", start)
    if end == -1:
        end = len(text)
    return text[start:end]


def is_true_prop_alias(text: str, head: str, start: int) -> bool:
    if not re.search(r":\s*Prop\b", head):
        return False
    body_start = text.find(":=", start)
    if body_start == -1:
        return False
    body = text[body_start + 2 :]
    return re.match(r"\s*True\b", body) is not None


def interface_names_as_premises_from_head(head: str, interface_names: set[str]) -> list[str]:
    found = []
    for name in sorted(interface_names, key=len, reverse=True):
        escaped = re.escape(name)
        explicit_binder = re.search(
            rf"[\(\{{\[][^)\}}\]]*:\s*[^)\}}\]]*(?<![\w'.]){escaped}(?![\w'.])",
            head,
            flags=re.S,
        )
        arrow_antecedent = re.search(
            rf"(?<![\w'.]){escaped}(?![\w'.])\s*(?:→|->)",
            head,
        )
        if explicit_binder or arrow_antecedent:
            found.append(name)
    return found


def top_level_result_type(head: str) -> str:
    depth = 0
    for i, ch in enumerate(head):
        if ch in "({[":
            depth += 1
        elif ch in ")}]" and depth > 0:
            depth -= 1
        elif ch == ":" and depth == 0:
            return head[i + 1 :].strip()
    return ""


def interface_name_as_direct_conclusion(head: str, interface_names: set[str]) -> str | None:
    result_type = top_level_result_type(head)
    for name in sorted(interface_names, key=len, reverse=True):
        if re.match(rf"{re.escape(name)}\b", result_type):
            return name
    return None


def lower_first(name: str) -> str:
    return name[:1].lower() + name[1:]


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--list", action="store_true", help="list matching surfaces")
    parser.add_argument(
        "--fail-on-conditional",
        action="store_true",
        help="exit nonzero if any theorem signature uses an explicit interface",
    )
    args = parser.parse_args()

    prop_interfaces: list[tuple[pathlib.Path, int, str]] = []
    closed_true_prop_interfaces: list[tuple[pathlib.Path, int, str]] = []
    interface_names: set[str] = set()
    interface_kinds: dict[str, str] = {}
    theorem_hits: list[tuple[pathlib.Path, int, str, list[str]]] = []
    current_refutations: list[tuple[pathlib.Path, int, str, str]] = []
    current_closures: list[tuple[pathlib.Path, int, str, str]] = []

    clean_by_path: dict[pathlib.Path, str] = {}
    decls_by_path: dict[pathlib.Path, list[tuple[str, str, int, str]]] = {}

    for path in source_files():
        clean = strip_comments_and_strings(path.read_text(encoding="utf-8"))
        clean_by_path[path] = clean
        decls: list[tuple[str, str, int, str]] = []
        for m in DECL_START_RE.finditer(clean):
            kind, name = m.group(1), m.group(2)
            head = decl_head(clean, m.start())
            line_no = line_no_at(clean, m.start())
            decls.append((kind, name, line_no, head))
            is_prop_def = kind == "def" and re.search(r":\s*Prop\b", head)
            is_interface_container = kind in {"class", "structure"}
            if (is_prop_def or is_interface_container) and INTERFACE_NAME_RE.search(name):
                if is_prop_def and is_true_prop_alias(clean, head, m.start()):
                    closed_true_prop_interfaces.append((path, line_no, name))
                else:
                    interface_names.add(name)
                    interface_kinds[name] = "prop_def" if is_prop_def else kind
                    prop_interfaces.append((path, line_no, name))
        decls_by_path[path] = decls

    for path, decls in decls_by_path.items():
        for kind, name, line_no, head in decls:
            if kind in {"theorem", "lemma"}:
                used = interface_names_as_premises_from_head(head, interface_names)
                if used:
                    theorem_hits.append((path, line_no, name, used))
                for iface in interface_names:
                    iface_lower = lower_first(iface)
                    if (
                        name == f"not_{iface}"
                        or name == f"not_{iface}_current"
                        or name == f"not_{iface_lower}_current"
                        or name == f"not_exists_{iface}_current"
                        or name == f"not_exists_{iface_lower}_current"
                    ):
                        current_refutations.append((path, line_no, name, iface))
                    if name == f"{iface}_current" or name == f"{iface}_closed":
                        current_closures.append((path, line_no, name, iface))
                direct_closed = interface_name_as_direct_conclusion(head, interface_names)
                if direct_closed is not None:
                    used = interface_names_as_premises_from_head(head, interface_names)
                    if not used and (path, line_no, name, direct_closed) not in current_closures:
                        current_closures.append((path, line_no, name, direct_closed))
            elif kind == "def":
                direct_closed = interface_name_as_direct_conclusion(head, interface_names)
                if (
                    direct_closed is not None
                    and (name == f"{direct_closed}_current" or name == f"{direct_closed}_closed")
                    and (path, line_no, name, direct_closed) not in current_closures
                ):
                    current_closures.append((path, line_no, name, direct_closed))

    by_interface: dict[str, int] = collections.Counter()
    for _path, _line_no, _name, used in theorem_hits:
        for iface in used:
            by_interface[iface] += 1

    refuted_interfaces = {iface for *_, iface in current_refutations}
    closed_interfaces = {iface for *_, iface in current_closures}
    unresolved_interfaces = interface_names - refuted_interfaces - closed_interfaces
    conditional_hits_with_unresolved = [
        hit for hit in theorem_hits if any(iface in unresolved_interfaces for iface in hit[3])
    ]
    unresolved_by_kind = {
        kind: {iface for iface in unresolved_interfaces if interface_kinds.get(iface) == kind}
        for kind in ("prop_def", "structure", "class")
    }
    conditional_hits_with_unresolved_by_kind = {
        kind: [
            hit
            for hit in theorem_hits
            if any(iface in unresolved_by_kind[kind] for iface in hit[3])
        ]
        for kind in ("prop_def", "structure", "class")
    }

    print(f"project_lean_files={len(source_files())}")
    print(f"prop_interfaces={len(prop_interfaces)}")
    print(f"closed_true_prop_interfaces={len(closed_true_prop_interfaces)}")
    print(f"conditional_theorem_signatures={len(theorem_hits)}")
    print(f"interfaces_with_current_refutation={len(refuted_interfaces)}")
    print(f"interfaces_with_current_closure={len(closed_interfaces)}")
    print(f"unresolved_prop_interfaces={len(unresolved_interfaces)}")
    print(f"unresolved_prop_def_interfaces={len(unresolved_by_kind['prop_def'])}")
    print(f"unresolved_structure_interfaces={len(unresolved_by_kind['structure'])}")
    print(f"unresolved_class_interfaces={len(unresolved_by_kind['class'])}")
    print(f"conditional_signatures_using_unresolved_interfaces={len(conditional_hits_with_unresolved)}")
    print(
        "conditional_signatures_using_unresolved_prop_def_interfaces="
        f"{len(conditional_hits_with_unresolved_by_kind['prop_def'])}"
    )
    print(
        "conditional_signatures_using_unresolved_structure_interfaces="
        f"{len(conditional_hits_with_unresolved_by_kind['structure'])}"
    )
    print(
        "conditional_signatures_using_unresolved_class_interfaces="
        f"{len(conditional_hits_with_unresolved_by_kind['class'])}"
    )

    if args.list:
        if prop_interfaces:
            print("\n[prop_interfaces]")
            for path, line_no, name in prop_interfaces:
                print(f"{path.as_posix()}:{line_no}: {name}")
        if closed_true_prop_interfaces:
            print("\n[closed_true_prop_interfaces]")
            for path, line_no, name in closed_true_prop_interfaces:
                print(f"{path.as_posix()}:{line_no}: {name}")
        if theorem_hits:
            print("\n[conditional_theorem_signatures]")
            for path, line_no, name, used in theorem_hits:
                print(f"{path.as_posix()}:{line_no}: {name} <- {', '.join(used)}")
        if by_interface:
            print("\n[conditional_usage_by_interface]")
            for iface, count in by_interface.most_common():
                print(f"{iface}: {count}")
        if current_refutations:
            print("\n[current_refutations]")
            for path, line_no, name, iface in current_refutations:
                print(f"{path.as_posix()}:{line_no}: {name} refutes {iface}")
        if current_closures:
            print("\n[current_closures]")
            for path, line_no, name, iface in current_closures:
                print(f"{path.as_posix()}:{line_no}: {name} closes {iface}")
        if unresolved_interfaces:
            print("\n[unresolved_interfaces]")
            for iface in sorted(unresolved_interfaces):
                print(iface)
            for kind, interfaces in unresolved_by_kind.items():
                if interfaces:
                    print(f"\n[unresolved_{kind}_interfaces]")
                    for iface in sorted(interfaces):
                        print(iface)
        if conditional_hits_with_unresolved:
            print("\n[conditional_theorem_signatures_using_unresolved]")
            for path, line_no, name, used in conditional_hits_with_unresolved:
                unresolved_used = [iface for iface in used if iface in unresolved_interfaces]
                print(f"{path.as_posix()}:{line_no}: {name} <- {', '.join(unresolved_used)}")
            for kind, hits in conditional_hits_with_unresolved_by_kind.items():
                if hits:
                    print(f"\n[conditional_theorem_signatures_using_unresolved_{kind}]")
                    for path, line_no, name, used in hits:
                        unresolved_used = [
                            iface for iface in used if iface in unresolved_by_kind[kind]
                        ]
                        print(
                            f"{path.as_posix()}:{line_no}: {name} <- "
                            f"{', '.join(unresolved_used)}"
                        )

    return 1 if args.fail_on_conditional and theorem_hits else 0


if __name__ == "__main__":
    sys.exit(main())
