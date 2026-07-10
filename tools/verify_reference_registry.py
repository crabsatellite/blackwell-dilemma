#!/usr/bin/env python3
"""Verify pinned reference identity and scope metadata.

Offline verification is deterministic and used in CI. ``--online`` additionally
checks the pinned bibliographic identity against Crossref without modifying the
repository. Scope statements remain explicit premises; this tool never labels
an external theorem or modeling assumption as proved by Lean.
"""

from __future__ import annotations

import argparse
import html
import json
import re
import sys
import urllib.error
import urllib.parse
import urllib.request
import unicodedata
from pathlib import Path
from typing import Any


REPO_ROOT = Path(__file__).resolve().parents[1]
REGISTRY = REPO_ROOT / "reference-evidence" / "reference_registry.json"
EXPECTED_IDS = (
    "blackwell1953",
    "kesten1980",
    "aizenman_barsky1987",
    "grimmett1999",
    "pisztora1996",
    "topkis1978",
    "molloy_reed1995",
    "cohen2000",
    "newman_strogatz_watts2001",
    "bollobas2001",
    "pfister2013",
    "eschbach_stauffer_herrmann1981",
)
IDENTITY_FIELDS = (
    "id",
    "doi",
    "title",
    "authors",
    "year",
    "publisher",
    "container_title",
    "record_type",
    "canonical_url",
)
SCOPE_FIELDS = ("evidence_locator", "supports", "limitations")
FORBIDDEN_STATUS_KEYS = {"status", "closed", "verified", "reasonable"}


def normalize_text(value: Any) -> str:
    expanded = unicodedata.normalize("NFKD", html.unescape(str(value)))
    ascii_text = "".join(char for char in expanded if not unicodedata.combining(char))
    return re.sub(r"\s+", " ", ascii_text).strip()


def load_registry() -> dict[str, Any]:
    return json.loads(REGISTRY.read_text(encoding="utf-8"))


def crossref_message(doi: str) -> dict[str, Any]:
    encoded = urllib.parse.quote(doi, safe="")
    request = urllib.request.Request(
        f"https://api.crossref.org/works/{encoded}",
        headers={"User-Agent": "OpenExecution-reference-gate/1.0"},
    )
    with urllib.request.urlopen(request, timeout=30) as response:
        return json.load(response)["message"]


def crossref_authors(message: dict[str, Any]) -> list[str]:
    return [
        normalize_text(f"{author.get('given', '')} {author.get('family', '')}")
        for author in message.get("author", [])
    ]


def offline_failures(registry: dict[str, Any]) -> list[str]:
    failures: list[str] = []
    records = registry.get("records", [])
    ids = [record.get("id") for record in records]
    if registry.get("schema_version") != 1:
        failures.append("schema_version must equal 1")
    if tuple(ids) != EXPECTED_IDS:
        failures.append(f"record roster mismatch: {ids}")
    if len(ids) != len(set(ids)):
        failures.append("duplicate record id")

    for record in records:
        record_id = record.get("id", "<missing-id>")
        forbidden = FORBIDDEN_STATUS_KEYS.intersection(record)
        if forbidden:
            failures.append(f"{record_id}: forbidden manual status keys {sorted(forbidden)}")
        for field in IDENTITY_FIELDS:
            if field not in record:
                failures.append(f"{record_id}: missing identity field {field}")
        for field in SCOPE_FIELDS:
            if not record.get(field):
                failures.append(f"{record_id}: empty scope field {field}")
        doi = str(record.get("doi", ""))
        if doi != doi.lower() or not re.fullmatch(r"10\.\d{4,9}/\S+", doi):
            failures.append(f"{record_id}: DOI is not normalized: {doi}")
        if record.get("canonical_url") != f"https://doi.org/{doi}":
            failures.append(f"{record_id}: canonical URL does not match DOI")
        for field in ("authors", "supports", "limitations"):
            values = record.get(field)
            if not isinstance(values, list) or not values or len(values) != len(set(values)):
                failures.append(f"{record_id}: {field} must be a nonempty duplicate-free list")
    return failures


def online_failures(registry: dict[str, Any]) -> list[str]:
    failures: list[str] = []
    for record in registry["records"]:
        record_id = record["id"]
        try:
            message = crossref_message(record["doi"])
        except (urllib.error.URLError, TimeoutError, KeyError, json.JSONDecodeError) as exc:
            failures.append(f"{record_id}: Crossref request failed: {exc}")
            continue

        actual_year = message.get("published", {}).get("date-parts", [[None]])[0][0]
        comparisons = {
            "doi": str(message.get("DOI", "")).lower() == record["doi"],
            "title": normalize_text((message.get("title") or [""])[0])
            == normalize_text(record["title"]),
            "authors": [normalize_text(author) for author in crossref_authors(message)]
            == [normalize_text(author) for author in record["authors"]],
            "year": actual_year == record["year"],
            "publisher": normalize_text(message.get("publisher", ""))
            == normalize_text(record["publisher"]),
            "record_type": message.get("type") == record["record_type"],
        }
        for field, matches in comparisons.items():
            if not matches:
                failures.append(f"{record_id}: Crossref mismatch in {field}")
    return failures


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--online", action="store_true")
    args = parser.parse_args()

    registry = load_registry()
    failures = offline_failures(registry)
    records = registry.get("records", [])
    print(f"reference_records_total={len(records)}")
    print(f"reference_scope_support_entries={sum(len(r.get('supports', [])) for r in records)}")
    print(f"reference_scope_limitation_entries={sum(len(r.get('limitations', [])) for r in records)}")
    print("reference_manual_status_fields=0" if not any(
        FORBIDDEN_STATUS_KEYS.intersection(record) for record in records
    ) else "reference_manual_status_fields=1")

    if args.online and not failures:
        online = online_failures(registry)
        print(f"reference_metadata_online_checked={len(records)}")
        print(f"reference_metadata_online_failures={len(online)}")
        failures.extend(online)

    print(f"reference_metadata_offline_failures={len(offline_failures(registry))}")
    for failure in failures:
        print(f"FAIL {failure}")
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
