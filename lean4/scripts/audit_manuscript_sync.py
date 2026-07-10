#!/usr/bin/env python3
"""Verify that the private manuscript matches the public claim inventory."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from pathlib import Path


LEAN_ROOT = Path(__file__).resolve().parents[1]
REPO_ROOT = LEAN_ROOT.parent
INVENTORY_PATH = REPO_ROOT / "paper" / "claim_inventory.json"
OBLIGATIONS_PATH = REPO_ROOT / "paper" / "publication_obligations.json"
LEDGER_PATH = LEAN_ROOT / "BlackwellDilemma" / "Ledger.lean"
CLAIM_PATTERN = re.compile(
    r"\\begin\{(?P<kind>theorem|proposition|lemma|corollary)\}"
    r"(?:\[(?P<title>[^\]]+)\])?\s*"
    r"\\label\{(?P<label>[^}]+)\}"
)


def fail(message: str) -> None:
    print(f"manuscript_sync_error={message}", file=sys.stderr)
    raise SystemExit(1)


def normalized_title(title: str) -> str:
    title = re.sub(r"\s+", " ", title).strip()
    return title.replace(r"\H{o}", "o").replace(r"\'e", "e")


def extract_claims(text: str) -> list[dict[str, object]]:
    claims: list[dict[str, object]] = []
    for match in CLAIM_PATTERN.finditer(text):
        kind = match.group("kind")
        end_token = rf"\end{{{kind}}}"
        end_index = text.find(end_token, match.end())
        if end_index < 0:
            fail(f"unterminated-{kind}:{match.group('label')}")
        claim_block = text[match.start() : end_index + len(end_token)]
        claims.append(
            {
                "line": text.count("\n", 0, match.start()) + 1,
                "kind": kind,
                "label": match.group("label"),
                "title": normalized_title(match.group("title") or ""),
                "statement_sha256": hashlib.sha256(
                    claim_block.encode("utf-8")
                ).hexdigest(),
            }
        )
    return claims


def sync_derived_bindings(claims: list[dict[str, object]]) -> None:
    """Refresh data that is mechanically determined by the manuscript."""
    by_label = {str(claim["label"]): claim for claim in claims}

    obligations_text = OBLIGATIONS_PATH.read_text(encoding="utf-8")
    obligations = json.loads(obligations_text)
    obligation_claims = obligations.get("claims", [])
    if {claim.get("label") for claim in obligation_claims} != set(by_label):
        fail("publication-obligation-label-roster")
    for label, claim in by_label.items():
        pattern = re.compile(
            rf'("label"\s*:\s*"{re.escape(label)}"\s*,\s*'
            rf'"statement_sha256"\s*:\s*")[0-9a-f]{{64}}(")'
        )
        obligations_text, replacements = pattern.subn(
            rf'\g<1>{claim["statement_sha256"]}\g<2>',
            obligations_text,
            count=1,
        )
        if replacements != 1:
            fail(f"publication-obligation-hash-binding:{label}:{replacements}")
    OBLIGATIONS_PATH.write_text(obligations_text, encoding="utf-8")

    ledger = LEDGER_PATH.read_text(encoding="utf-8")
    for label, claim in by_label.items():
        pattern = re.compile(
            rf'(label := "{re.escape(label)}"\s*\n'
            rf'(?:.*\n)*?\s*sourceLine := )\d+',
        )
        ledger, replacements = pattern.subn(
            rf'\g<1>{claim["line"]}', ledger, count=1
        )
        if replacements != 1:
            fail(f"ledger-source-line-binding:{label}:{replacements}")
    LEDGER_PATH.write_text(ledger, encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--manuscript", required=True, type=Path)
    parser.add_argument("--write-inventory", action="store_true")
    args = parser.parse_args()

    manuscript = args.manuscript.resolve()
    if not manuscript.is_file():
        fail(f"missing-manuscript:{manuscript}")

    manuscript_bytes = manuscript.read_bytes()
    manuscript_text = manuscript_bytes.decode("utf-8")
    if re.search(r"^(?:<<<<<<<|=======|>>>>>>>)", manuscript_text, re.MULTILINE):
        fail("unresolved-merge-conflict-marker")
    actual_hash = hashlib.sha256(manuscript_bytes).hexdigest()
    actual_claims = extract_claims(manuscript_text)

    if args.write_inventory:
        previous = json.loads(INVENTORY_PATH.read_text(encoding="utf-8"))
        inventory = {
            "schema_version": 2,
            "manuscript": previous.get(
                "manuscript",
                "blackwell-dilemma-internal/paper/blackwell_dilemma.tex",
            ),
            "manuscript_sha256": actual_hash,
            "claims": actual_claims,
        }
        INVENTORY_PATH.write_text(
            json.dumps(inventory, indent=2, ensure_ascii=True) + "\n",
            encoding="utf-8",
        )
        sync_derived_bindings(actual_claims)
        print(f"manuscript_sha256={actual_hash}")
        print(f"manuscript_claims={len(actual_claims)}")
        print("manuscript_inventory_written=1")
        print(f"manuscript_derived_bindings_written={len(actual_claims) * 2}")
        return

    inventory = json.loads(INVENTORY_PATH.read_text(encoding="utf-8"))
    if inventory.get("schema_version") != 2:
        fail(f"inventory-schema:{inventory.get('schema_version')}")
    expected_hash = inventory.get("manuscript_sha256")
    if actual_hash != expected_hash:
        fail(f"sha256:expected={expected_hash}:actual={actual_hash}")

    expected_claims = inventory.get("claims")
    if actual_claims != expected_claims:
        for index, (actual, expected) in enumerate(
            zip(actual_claims, expected_claims or []), start=1
        ):
            if actual != expected:
                fail(f"claim-{index}:expected={expected}:actual={actual}")
        fail(
            f"claim-count:expected={len(expected_claims or [])}:"
            f"actual={len(actual_claims)}"
        )

    labels = [claim["label"] for claim in actual_claims]
    if len(labels) != len(set(labels)):
        fail("duplicate-label")

    print(f"manuscript_sha256={actual_hash}")
    print(f"manuscript_claims={len(actual_claims)}")
    print("manuscript_inventory_match=1")


if __name__ == "__main__":
    main()
