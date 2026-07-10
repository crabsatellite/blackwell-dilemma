#!/usr/bin/env python3
"""Generate and verify the manuscript-to-BibTeX citation inventory."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Any


REPO_ROOT = Path(__file__).resolve().parents[1]
INVENTORY_PATH = REPO_ROOT / "paper" / "citation_inventory.json"
BIBLIOGRAPHY_PATH = REPO_ROOT / "paper" / "references.bib"
CLAIM_INVENTORY_PATH = REPO_ROOT / "paper" / "claim_inventory.json"
REFERENCE_REGISTRY_PATH = REPO_ROOT / "reference-evidence" / "reference_registry.json"
OBLIGATIONS_PATH = REPO_ROOT / "paper" / "publication_obligations.json"
MODEL_ASSUMPTIONS_PATH = REPO_ROOT / "paper" / "model_assumptions.json"


class AuditError(RuntimeError):
    pass


@dataclass(frozen=True)
class BibEntry:
    entry_type: str
    key: str
    text: str


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def strip_tex_comments(text: str) -> str:
    cleaned: list[str] = []
    for line in text.splitlines():
        index = 0
        while index < len(line):
            if line[index] == "%":
                slash_count = 0
                cursor = index - 1
                while cursor >= 0 and line[cursor] == "\\":
                    slash_count += 1
                    cursor -= 1
                if slash_count % 2 == 0:
                    line = line[:index]
                    break
            index += 1
        cleaned.append(line)
    return "\n".join(cleaned)


def parse_citation_keys(manuscript: str) -> list[str]:
    source = strip_tex_comments(manuscript)
    pattern = re.compile(
        r"\\cite[a-zA-Z]*\s*(?:\[[^\]]*\]\s*)*\{([^{}]+)\}",
        flags=re.MULTILINE,
    )
    keys = {
        key.strip()
        for match in pattern.finditer(source)
        for key in match.group(1).split(",")
        if key.strip()
    }
    if not keys:
        raise AuditError("manuscript contains no parsed citation keys")
    return sorted(keys)


def parse_bibtex_entries(text: str) -> list[BibEntry]:
    entries: list[BibEntry] = []
    index = 0
    while index < len(text):
        match = re.search(r"(?m)^\s*@([A-Za-z]+)\s*([({])", text[index:])
        if match is None:
            break
        start = index + match.start()
        entry_type = match.group(1).lower()
        opener = match.group(2)
        closer = "}" if opener == "{" else ")"
        body_start = index + match.end()
        comma = text.find(",", body_start)
        if comma < 0:
            raise AuditError(f"BibTeX entry at byte {start} has no key terminator")
        key = text[body_start:comma].strip()
        if not key:
            raise AuditError(f"BibTeX entry at byte {start} has an empty key")

        depth = 1
        cursor = body_start
        in_quote = False
        escaped = False
        while cursor < len(text) and depth:
            char = text[cursor]
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                in_quote = not in_quote
            elif not in_quote:
                if char == opener:
                    depth += 1
                elif char == closer:
                    depth -= 1
            cursor += 1
        if depth:
            raise AuditError(f"BibTeX entry {key!r} is not balanced")
        entries.append(BibEntry(entry_type, key, text[start:cursor].strip()))
        index = cursor

    keys = [entry.key for entry in entries]
    if not keys or len(keys) != len(set(keys)):
        raise AuditError("BibTeX keys must be nonempty and unique")
    return entries


def collect_reference_ids(value: Any) -> set[str]:
    found: set[str] = set()
    if isinstance(value, dict):
        for key, item in value.items():
            if key == "reference_ids" and isinstance(item, list):
                found.update(str(reference_id) for reference_id in item)
            else:
                found.update(collect_reference_ids(item))
    elif isinstance(value, list):
        for item in value:
            found.update(collect_reference_ids(item))
    return found


def critical_reference_bindings(
    registry: dict[str, Any], citation_keys: set[str], bib_keys: set[str]
) -> list[dict[str, str]]:
    critical_ids = collect_reference_ids(load_json(OBLIGATIONS_PATH))
    critical_ids.update(collect_reference_ids(load_json(MODEL_ASSUMPTIONS_PATH)))
    records = {record["id"]: record for record in registry.get("records", [])}
    bindings: list[dict[str, str]] = []
    for reference_id in sorted(critical_ids):
        if reference_id not in records:
            raise AuditError(f"critical reference is absent from registry: {reference_id}")
        bibtex_key = records[reference_id].get("bibtex_key")
        if not bibtex_key:
            raise AuditError(f"critical reference has no bibtex_key: {reference_id}")
        if bibtex_key not in bib_keys:
            raise AuditError(
                f"critical reference BibTeX key is absent: {reference_id} -> {bibtex_key}"
            )
        if bibtex_key not in citation_keys:
            raise AuditError(
                f"critical reference is not cited by manuscript: {reference_id} -> {bibtex_key}"
            )
        bindings.append({"reference_id": reference_id, "bibtex_key": bibtex_key})
    return bindings


def build_inventory(manuscript_path: Path, bibliography_path: Path) -> dict[str, Any]:
    manuscript_bytes = manuscript_path.read_bytes()
    bibliography_bytes = bibliography_path.read_bytes()
    manuscript = manuscript_bytes.decode("utf-8")
    bibliography = bibliography_bytes.decode("utf-8")
    citation_keys = parse_citation_keys(manuscript)
    entries = parse_bibtex_entries(bibliography)
    bib_keys = {entry.key for entry in entries}
    missing = sorted(set(citation_keys) - bib_keys)
    if missing:
        raise AuditError("citation keys missing from bibliography: " + ",".join(missing))
    registry = load_json(REFERENCE_REGISTRY_PATH)
    bindings = critical_reference_bindings(registry, set(citation_keys), bib_keys)
    rendered_entries = [
        {
            "key": entry.key,
            "entry_type": entry.entry_type,
            "entry_sha256": sha256_bytes(entry.text.encode("utf-8")),
            "cited": entry.key in citation_keys,
        }
        for entry in sorted(entries, key=lambda item: item.key)
    ]
    return {
        "schema_version": 1,
        "generated_by": "tools/audit_citation_inventory.py",
        "manuscript": "blackwell-dilemma-internal/paper/blackwell_dilemma.tex",
        "manuscript_sha256": sha256_bytes(manuscript_bytes),
        "bibliography": "paper/references.bib",
        "bibliography_sha256": sha256_bytes(bibliography_bytes),
        "summary": {
            "citation_keys": len(citation_keys),
            "bibliography_entries": len(entries),
            "uncited_bibliography_entries": len(bib_keys - set(citation_keys)),
            "critical_reference_bindings": len(bindings),
        },
        "citation_keys": citation_keys,
        "critical_reference_bindings": bindings,
        "bibliography_entries": rendered_entries,
    }


def verify_committed_inventory() -> dict[str, Any]:
    inventory = load_json(INVENTORY_PATH)
    if inventory.get("schema_version") != 1:
        raise AuditError("citation inventory schema_version must equal 1")
    if inventory.get("generated_by") != "tools/audit_citation_inventory.py":
        raise AuditError("citation inventory generator identity mismatch")
    claim_inventory = load_json(CLAIM_INVENTORY_PATH)
    if inventory.get("manuscript_sha256") != claim_inventory.get("manuscript_sha256"):
        raise AuditError("citation and claim inventories bind different manuscript hashes")

    bibliography_bytes = BIBLIOGRAPHY_PATH.read_bytes()
    if inventory.get("bibliography_sha256") != sha256_bytes(bibliography_bytes):
        raise AuditError("committed bibliography hash differs from citation inventory")
    bibliography = bibliography_bytes.decode("utf-8")
    entries = parse_bibtex_entries(bibliography)
    citation_keys = inventory.get("citation_keys", [])
    if citation_keys != sorted(set(citation_keys)):
        raise AuditError("citation keys must be sorted and unique")
    bib_keys = {entry.key for entry in entries}
    missing = sorted(set(citation_keys) - bib_keys)
    if missing:
        raise AuditError("inventory citations missing from bibliography: " + ",".join(missing))

    registry = load_json(REFERENCE_REGISTRY_PATH)
    expected_bindings = critical_reference_bindings(
        registry, set(citation_keys), bib_keys
    )
    expected_entries = [
        {
            "key": entry.key,
            "entry_type": entry.entry_type,
            "entry_sha256": sha256_bytes(entry.text.encode("utf-8")),
            "cited": entry.key in citation_keys,
        }
        for entry in sorted(entries, key=lambda item: item.key)
    ]
    expected_summary = {
        "citation_keys": len(citation_keys),
        "bibliography_entries": len(entries),
        "uncited_bibliography_entries": len(bib_keys - set(citation_keys)),
        "critical_reference_bindings": len(expected_bindings),
    }
    if inventory.get("critical_reference_bindings") != expected_bindings:
        raise AuditError("critical reference bindings are stale")
    if inventory.get("bibliography_entries") != expected_entries:
        raise AuditError("bibliography entry hashes are stale")
    if inventory.get("summary") != expected_summary:
        raise AuditError("citation inventory summary is stale")
    return expected_summary


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--manuscript", type=Path)
    parser.add_argument("--bibliography", type=Path)
    parser.add_argument("--write-inventory", action="store_true")
    args = parser.parse_args()

    if args.write_inventory:
        if args.manuscript is None or args.bibliography is None:
            raise AuditError("--write-inventory requires --manuscript and --bibliography")
        bibliography_text = args.bibliography.resolve().read_text(encoding="utf-8")
        bibliography_text = bibliography_text.replace("\r\n", "\n").replace("\r", "\n")
        BIBLIOGRAPHY_PATH.write_text(
            bibliography_text, encoding="utf-8", newline="\n"
        )
        inventory = build_inventory(
            args.manuscript.resolve(), BIBLIOGRAPHY_PATH.resolve()
        )
        INVENTORY_PATH.write_text(
            json.dumps(inventory, indent=2, ensure_ascii=True) + "\n",
            encoding="utf-8",
        )
        print("citation_inventory_written=1")

    summary = verify_committed_inventory()
    print("citation_inventory_stale=0")
    for key, value in summary.items():
        print(f"citation_{key}={value}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except AuditError as error:
        print(f"citation_inventory_error={error}")
        raise SystemExit(1)
