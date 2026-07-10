#!/usr/bin/env python3
"""Render the committed live-prediction Markdown from its JSON result."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

from verify_live_prediction import generate_markdown


HERE = Path(__file__).resolve().parent
RESULT = HERE / "live_prediction_verification_2026-05-21.json"
REPORT = HERE / "live_prediction_verification_2026-05-21.md"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()

    expected = generate_markdown(json.loads(RESULT.read_text(encoding="utf-8")))
    stale = not REPORT.exists() or REPORT.read_text(encoding="utf-8") != expected
    if args.check:
        print(f"live_prediction_report_stale={int(stale)}")
        return int(stale)

    REPORT.write_text(expected, encoding="utf-8")
    print("live_prediction_report_written=1")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
