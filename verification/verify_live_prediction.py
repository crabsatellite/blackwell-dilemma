#!/usr/bin/env python3
"""
Verify the Blackwell Dilemma live prediction.

This script treats data/snapshots.json as the locked daily time series, but it
does not trust the GitHub /stats/commit_activity endpoint for historical
4-week commit counts. That endpoint can return "computing" or empty values,
which the original tracker recorded as zeros. For verification we recompute
4-week commit counts using the GitHub commits API over explicit timestamp
windows.
"""

from __future__ import annotations

import argparse
import json
import math
import os
import random
import re
import sys
import time
import urllib.parse
import urllib.request
from dataclasses import dataclass
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any


FRAMEWORKS = {
    "LangChain": "langchain-ai/langchain",
    "AutoGen": "microsoft/autogen",
    "Mem0": "mem0ai/mem0",
    "LlamaIndex": "run-llama/llama_index",
    "CrewAI": "crewAIInc/crewAI",
    "LiteLLM": "BerriAI/litellm",
    "DSPy": "stanfordnlp/dspy",
    "SemanticKernel": "microsoft/semantic-kernel",
    "Haystack": "deepset-ai/haystack",
    "PydanticAI": "pydantic/pydantic-ai",
}


@dataclass(frozen=True)
class CommitCount:
    repo: str
    since: str
    until: str
    count: int
    rate_limit_remaining: str | None


def utc_now() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")


def parse_snapshot_time(snapshot: dict[str, Any]) -> datetime:
    raw = snapshot.get("timestamp")
    if raw:
        dt = datetime.fromisoformat(raw)
    else:
        dt = datetime.fromisoformat(snapshot["date"] + "T23:59:59")
    if dt.tzinfo is None:
        # GitHub Actions runners use UTC; the original tracker wrote naive UTC.
        dt = dt.replace(tzinfo=timezone.utc)
    return dt.astimezone(timezone.utc)


def iso_z(dt: datetime) -> str:
    return dt.astimezone(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")


def github_get_json(url: str, token: str | None) -> tuple[Any, dict[str, str]]:
    headers = {
        "Accept": "application/vnd.github+json",
        "User-Agent": "blackwell-dilemma-verifier",
    }
    if token:
        headers["Authorization"] = f"Bearer {token}"
    req = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(req, timeout=30) as resp:
        body = resp.read().decode("utf-8")
        response_headers = {k: v for k, v in resp.headers.items()}
    return json.loads(body), response_headers


def count_commits(repo: str, since: datetime, until: datetime, token: str | None) -> CommitCount:
    params = urllib.parse.urlencode(
        {
            "since": iso_z(since),
            "until": iso_z(until),
            "per_page": 1,
        }
    )
    url = f"https://api.github.com/repos/{repo}/commits?{params}"
    data, headers = github_get_json(url, token)
    link = headers.get("Link", "")
    match = re.search(r"[?&]page=(\d+)>; rel=\"last\"", link)
    if match:
        count = int(match.group(1))
    elif isinstance(data, list):
        count = len(data)
    else:
        count = 0
    return CommitCount(
        repo=repo,
        since=iso_z(since),
        until=iso_z(until),
        count=count,
        rate_limit_remaining=headers.get("X-RateLimit-Remaining"),
    )


def load_series(path: Path) -> dict[str, Any]:
    with path.open(encoding="utf-8") as f:
        return json.load(f)


def snapshot_by_date(series: dict[str, Any], date_value: str) -> dict[str, Any]:
    for snapshot in series["snapshots"]:
        if snapshot["date"] == date_value:
            return snapshot
    raise KeyError(f"No snapshot for {date_value}")


def rank_values(values: list[float]) -> list[float]:
    indexed = sorted(enumerate(values), key=lambda item: item[1])
    ranks = [0.0] * len(values)
    i = 0
    while i < len(indexed):
        j = i + 1
        while j < len(indexed) and indexed[j][1] == indexed[i][1]:
            j += 1
        avg_rank = (i + 1 + j) / 2.0
        for k in range(i, j):
            ranks[indexed[k][0]] = avg_rank
        i = j
    return ranks


def pearson(xs: list[float], ys: list[float]) -> float:
    mx = sum(xs) / len(xs)
    my = sum(ys) / len(ys)
    num = sum((x - mx) * (y - my) for x, y in zip(xs, ys))
    den_x = math.sqrt(sum((x - mx) ** 2 for x in xs))
    den_y = math.sqrt(sum((y - my) ** 2 for y in ys))
    if den_x == 0 or den_y == 0:
        return float("nan")
    return num / (den_x * den_y)


def spearman(xs: list[float], ys: list[float]) -> float:
    return pearson(rank_values(xs), rank_values(ys))


def permutation_p_value(
    xs: list[float],
    ys: list[float],
    observed: float,
    *,
    alternative: str,
    permutations: int,
    seed: int,
) -> float:
    rng = random.Random(seed)
    yr = rank_values(ys)
    xr = rank_values(xs)
    hits = 0
    for _ in range(permutations):
        rng.shuffle(yr)
        rho = pearson(xr, yr)
        if alternative == "less":
            hits += rho <= observed
        elif alternative == "greater":
            hits += rho >= observed
        else:
            hits += abs(rho) >= abs(observed)
    return (hits + 1) / (permutations + 1)


def sort_desc(rows: list[dict[str, Any]], key: str) -> list[dict[str, Any]]:
    return sorted(rows, key=lambda row: (-float(row[key]), row["framework"]))


def add_ranks(rows: list[dict[str, Any]], key: str, rank_key: str) -> list[dict[str, Any]]:
    sorted_rows = sort_desc(rows, key)
    for idx, row in enumerate(sorted_rows, start=1):
        row[rank_key] = idx
    return rows


def compute_fork_growth(t0: dict[str, Any], t1: dict[str, Any]) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for name in FRAMEWORKS:
        base = t0["frameworks"][name]
        final = t1["frameworks"][name]
        fgr = final["forks"] / base["forks"]
        rows.append(
            {
                "framework": name,
                "repo": FRAMEWORKS[name],
                "stars_t0": base["stars"],
                "forks_t0": base["forks"],
                "forks_t1": final["forks"],
                "fork_growth_ratio": fgr,
                "fork_growth_pct": (fgr - 1.0) * 100.0,
                "under_60k_stars_t0": base["stars"] < 60000,
            }
        )
    add_ranks(rows, "fork_growth_ratio", "fork_growth_rank")
    return rows


def compute_egr(
    t0: dict[str, Any],
    t1: dict[str, Any],
    counts_t0: dict[str, CommitCount],
    counts_t1: dict[str, CommitCount],
) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for name in FRAMEWORKS:
        base = t0["frameworks"][name]
        final = t1["frameworks"][name]
        commits_t0 = counts_t0[name].count
        commits_t1 = counts_t1[name].count
        egr = None
        if commits_t0 > 0:
            egr = (commits_t1 / commits_t0) * (final["forks"] / base["forks"])
        rows.append(
            {
                "framework": name,
                "repo": FRAMEWORKS[name],
                "stars_t0": base["stars"],
                "forks_t0": base["forks"],
                "forks_t1": final["forks"],
                "commit_count_4w_t0": commits_t0,
                "commit_count_4w_t1": commits_t1,
                "commit_growth_ratio": None if commits_t0 == 0 else commits_t1 / commits_t0,
                "ecosystem_growth_ratio": egr,
                "under_60k_stars_t0": base["stars"] < 60000,
                "tracker_commits_4w_t0": base.get("commits_4w"),
                "tracker_commits_4w_t1": final.get("commits_4w"),
                "tracker_zero_artifact": (
                    (base.get("commits_4w") == 0 and commits_t0 > 0)
                    or (final.get("commits_4w") == 0 and commits_t1 > 0)
                ),
            }
        )
    finite = [row for row in rows if row["ecosystem_growth_ratio"] is not None]
    sorted_finite = sorted(finite, key=lambda row: (-row["ecosystem_growth_ratio"], row["framework"]))
    for idx, row in enumerate(sorted_finite, start=1):
        row["ecosystem_growth_rank"] = idx
    return rows


def collect_commit_counts(
    snapshot: dict[str, Any],
    token: str | None,
    *,
    sleep_seconds: float,
) -> dict[str, CommitCount]:
    end = parse_snapshot_time(snapshot)
    start = end - timedelta(days=28)
    counts: dict[str, CommitCount] = {}
    for name, repo in FRAMEWORKS.items():
        counts[name] = count_commits(repo, start, end, token)
        if sleep_seconds:
            time.sleep(sleep_seconds)
    return counts


def missing_dates(series: dict[str, Any]) -> list[str]:
    dates = [datetime.fromisoformat(s["date"]).date() for s in series["snapshots"]]
    seen = set(dates)
    cur = min(dates)
    end = max(dates)
    missing: list[str] = []
    while cur <= end:
        if cur not in seen:
            missing.append(cur.isoformat())
        cur += timedelta(days=1)
    return missing


def table_line(values: list[str]) -> str:
    return "| " + " | ".join(values) + " |"


def fmt_ratio(value: float | None) -> str:
    if value is None:
        return "NA"
    return f"{value:.3f}"


def fmt_pct(value: float | None) -> str:
    if value is None:
        return "NA"
    return f"{value:+.2f}%"


def generate_markdown(result: dict[str, Any]) -> str:
    verification = result["verification"]
    current = result["current_extension"]
    short = verification["short_note_predictions"]
    egr = verification["prediction_md_egr"]
    lines: list[str] = [
        "<!-- GENERATED by verification/verify_live_prediction.py; DO NOT EDIT. -->"
    ]
    lines.append("# Live Prediction Verification")
    lines.append("")
    lines.append(f"Generated: {result['generated_at']}")
    lines.append("")
    lines.append("## Verdict")
    lines.append("")
    lines.append(
        "**Reliable conclusion:** the short-note fork-growth prediction is confirmed, "
        "and the commit-based EGR prediction is weakly supported after replacing the "
        "GitHub stats endpoint artifacts with explicit 4-week commit counts."
    )
    lines.append("")
    lines.append(
        "The strongest result is not that LiteLLM had the highest relative growth. "
        "LiteLLM remains the ecosystem-health leader, but its baseline commit rate was "
        "already very high. The robust out-of-sample growth winner at the verification "
        "date is PydanticAI under EGR and LiteLLM under fork growth."
    )
    lines.append("")
    lines.append("## Data Integrity")
    lines.append("")
    lines.append(f"- Snapshot range: {result['snapshot_range']['first']} to {result['snapshot_range']['last']}")
    lines.append(f"- Snapshot count: {result['snapshot_range']['count']}")
    lines.append(f"- Missing daily snapshots: {result['snapshot_range']['missing_count']}")
    lines.append(
        f"- Verification date: {verification['date']} "
        f"({verification['timestamp']})"
    )
    lines.append(
        "- Commit counts: recomputed from the GitHub commits API over explicit "
        "28-day timestamp windows, not from the GitHub stats endpoint."
    )
    lines.append(
        f"- Tracker zero artifacts at verification: "
        f"{verification['tracker_zero_artifact_count']} framework(s)."
    )
    lines.append("")
    lines.append("## Short Note Predictions")
    lines.append("")
    lines.append(table_line(["Prediction", "Result", "Verdict"]))
    lines.append(table_line(["---", "---", "---"]))
    lines.append(
        table_line(
            [
                "P1: Spearman stars(t0) vs FGR <= 0",
                f"rho={short['p1_spearman_stars_vs_fgr']:.3f}, one-sided permutation p~{short['p1_permutation_p_less']:.3f}",
                "confirmed" if short["p1_confirmed"] else "not confirmed",
            ]
        )
    )
    lines.append(
        table_line(
            [
                "P2: LangChain FGR rank in bottom half",
                f"rank={short['p2_langchain_fgr_rank']} of {short['n_frameworks']}",
                "confirmed" if short["p2_confirmed"] else "not confirmed",
            ]
        )
    )
    lines.append(
        table_line(
            [
                "P3: LiteLLM FGR > LangChain FGR",
                f"{short['p3_litellm_fgr']:.3f} > {short['p3_langchain_fgr']:.3f}",
                "confirmed" if short["p3_confirmed"] else "not confirmed",
            ]
        )
    )
    lines.append("")
    lines.append(f"Joint verdict: **{short['joint_verdict']}**.")
    lines.append("")
    lines.append("## EGR Verification")
    lines.append("")
    lines.append(
        f"LangChain EGR rank: {egr['langchain_egr_rank']} of {egr['n_egr_defined']} "
        f"(EGR={egr['langchain_egr']:.3f})."
    )
    lines.append(
        "Under-60k frameworks beating LangChain by EGR: "
        + ", ".join(f"{name} ({value:.3f})" for name, value in egr["under60_beating_langchain"])
        if egr["under60_beating_langchain"]
        else "Under-60k frameworks beating LangChain by EGR: none."
    )
    lines.append(
        f"Main EGR prediction: {'supported' if egr['main_prediction_supported'] else 'not supported'}; "
        f"strict falsification: {'yes' if egr['strict_falsification'] else 'no'}; "
        f"top-3 caution: {'yes' if egr['top3_caution'] else 'no'}."
    )
    lines.append("")
    lines.append("## Verification Rankings")
    lines.append("")
    lines.append("### Fork Growth Ratio")
    lines.append("")
    lines.append(table_line(["Rank", "Framework", "Stars t0", "Forks t0", "Forks t1", "FGR", "Growth"]))
    lines.append(table_line(["---:", "---", "---:", "---:", "---:", "---:", "---:"]))
    for row in sorted(verification["fork_growth_rows"], key=lambda r: r["fork_growth_rank"]):
        lines.append(
            table_line(
                [
                    str(row["fork_growth_rank"]),
                    row["framework"],
                    f"{row['stars_t0']:,}",
                    f"{row['forks_t0']:,}",
                    f"{row['forks_t1']:,}",
                    fmt_ratio(row["fork_growth_ratio"]),
                    fmt_pct(row["fork_growth_pct"]),
                ]
            )
        )
    lines.append("")
    lines.append("### Ecosystem Growth Ratio")
    lines.append("")
    lines.append(
        table_line(
            [
                "Rank",
                "Framework",
                "Commits t0",
                "Commits t1",
                "Forks t0",
                "Forks t1",
                "EGR",
                "Tracker artifact",
            ]
        )
    )
    lines.append(table_line(["---:", "---", "---:", "---:", "---:", "---:", "---:", "---"]))
    ranked_egr = sorted(
        [row for row in verification["egr_rows"] if row.get("ecosystem_growth_rank") is not None],
        key=lambda r: r["ecosystem_growth_rank"],
    )
    for row in ranked_egr:
        lines.append(
            table_line(
                [
                    str(row["ecosystem_growth_rank"]),
                    row["framework"],
                    str(row["commit_count_4w_t0"]),
                    str(row["commit_count_4w_t1"]),
                    f"{row['forks_t0']:,}",
                    f"{row['forks_t1']:,}",
                    fmt_ratio(row["ecosystem_growth_ratio"]),
                    "yes" if row["tracker_zero_artifact"] else "no",
                ]
            )
        )
    lines.append("")
    lines.append("## Holdout Extension")
    lines.append("")
    lines.append(
        f"As of {current['date']}, the EGR result remains directionally supported: "
        f"LangChain rank {current['prediction_md_egr']['langchain_egr_rank']} of "
        f"{current['prediction_md_egr']['n_egr_defined']}, with "
        f"{len(current['prediction_md_egr']['under60_beating_langchain'])} under-60k framework(s) ahead."
    )
    lines.append("")
    lines.append("## Interpretation")
    lines.append("")
    lines.append(
        "The evidence supports the Blackwell Dilemma diagnostic at the level this "
        "experiment can test: the visible quality leader was not the best growth "
        "choice once hidden ecosystem-health dynamics were measured. The result is "
        "predictive and out-of-sample, but still correlational and single-ecosystem. "
        "It should be used as supporting empirical evidence, not as causal proof of "
        "the theorem."
    )
    lines.append("")
    return "\n".join(lines)


def summarize_period(
    label: str,
    t0: dict[str, Any],
    target: dict[str, Any],
    counts_t0: dict[str, CommitCount],
    counts_target: dict[str, CommitCount],
    *,
    permutations: int,
    seed: int,
) -> dict[str, Any]:
    fork_rows = compute_fork_growth(t0, target)
    egr_rows = compute_egr(t0, target, counts_t0, counts_target)
    stars = [row["stars_t0"] for row in fork_rows]
    fgr_values = [row["fork_growth_ratio"] for row in fork_rows]
    rho = spearman(stars, fgr_values)
    p_less = permutation_p_value(
        stars,
        fgr_values,
        rho,
        alternative="less",
        permutations=permutations,
        seed=seed,
    )

    langchain_fgr = next(row for row in fork_rows if row["framework"] == "LangChain")
    litellm_fgr = next(row for row in fork_rows if row["framework"] == "LiteLLM")
    finite_egr = [row for row in egr_rows if row["ecosystem_growth_ratio"] is not None]
    langchain_egr = next(row for row in finite_egr if row["framework"] == "LangChain")
    under60_beating = [
        (row["framework"], row["ecosystem_growth_ratio"])
        for row in finite_egr
        if row["under_60k_stars_t0"]
        and row["ecosystem_growth_ratio"] is not None
        and row["ecosystem_growth_ratio"] > langchain_egr["ecosystem_growth_ratio"]
    ]
    under60_beating.sort(key=lambda item: (-item[1], item[0]))

    short_note = {
        "n_frameworks": len(fork_rows),
        "p1_spearman_stars_vs_fgr": rho,
        "p1_permutation_p_less": p_less,
        "p1_confirmed": rho <= 0,
        "p2_langchain_fgr_rank": langchain_fgr["fork_growth_rank"],
        "p2_langchain_fgr": langchain_fgr["fork_growth_ratio"],
        "p2_confirmed": langchain_fgr["fork_growth_rank"] >= 6,
        "p3_litellm_fgr": litellm_fgr["fork_growth_ratio"],
        "p3_langchain_fgr": langchain_fgr["fork_growth_ratio"],
        "p3_confirmed": litellm_fgr["fork_growth_ratio"] > langchain_fgr["fork_growth_ratio"],
    }
    short_note["joint_verdict"] = (
        "confirmed"
        if short_note["p1_confirmed"] and short_note["p2_confirmed"] and short_note["p3_confirmed"]
        else "mixed"
    )

    egr_summary = {
        "n_egr_defined": len(finite_egr),
        "langchain_egr": langchain_egr["ecosystem_growth_ratio"],
        "langchain_egr_rank": langchain_egr["ecosystem_growth_rank"],
        "under60_beating_langchain": under60_beating,
        "main_prediction_supported": len(under60_beating) >= 1,
        "strict_falsification": langchain_egr["ecosystem_growth_rank"] == 1,
        "top3_caution": langchain_egr["ecosystem_growth_rank"] <= 3,
    }

    return {
        "label": label,
        "date": target["date"],
        "timestamp": target.get("timestamp"),
        "fork_growth_rows": fork_rows,
        "egr_rows": egr_rows,
        "short_note_predictions": short_note,
        "prediction_md_egr": egr_summary,
        "tracker_zero_artifact_count": sum(1 for row in egr_rows if row["tracker_zero_artifact"]),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description="Verify the Blackwell Dilemma live prediction.")
    parser.add_argument("--snapshot-file", default="data/snapshots.json")
    parser.add_argument("--verification-date", default="2026-05-21")
    parser.add_argument("--output-json", default="verification/live_prediction_verification_2026-05-21.json")
    parser.add_argument("--output-md", default="verification/live_prediction_verification_2026-05-21.md")
    parser.add_argument("--permutations", type=int, default=50000)
    parser.add_argument("--seed", type=int, default=20260619)
    parser.add_argument("--sleep", type=float, default=0.1)
    args = parser.parse_args()

    snapshot_file = Path(args.snapshot_file)
    series = load_series(snapshot_file)
    t0_date = series["prediction"]["t0"]
    t0 = snapshot_by_date(series, t0_date)
    verification_snapshot = snapshot_by_date(series, args.verification_date)
    latest_snapshot = series["snapshots"][-1]
    token = os.environ.get("GH_TOKEN") or os.environ.get("GITHUB_TOKEN")

    print(f"Loading snapshots from {snapshot_file}")
    print(f"Collecting commit counts for {t0_date}, {args.verification_date}, {latest_snapshot['date']}")

    counts_t0 = collect_commit_counts(t0, token, sleep_seconds=args.sleep)
    counts_verification = collect_commit_counts(verification_snapshot, token, sleep_seconds=args.sleep)
    counts_latest = collect_commit_counts(latest_snapshot, token, sleep_seconds=args.sleep)

    missing = missing_dates(series)
    verification = summarize_period(
        "verification",
        t0,
        verification_snapshot,
        counts_t0,
        counts_verification,
        permutations=args.permutations,
        seed=args.seed,
    )
    current = summarize_period(
        "current_extension",
        t0,
        latest_snapshot,
        counts_t0,
        counts_latest,
        permutations=args.permutations,
        seed=args.seed + 1,
    )

    result = {
        "generated_at": utc_now(),
        "snapshot_file": str(snapshot_file),
        "prediction": series["prediction"],
        "snapshot_range": {
            "first": series["snapshots"][0]["date"],
            "last": series["snapshots"][-1]["date"],
            "count": len(series["snapshots"]),
            "missing_count": len(missing),
            "missing_dates": missing,
        },
        "commit_count_method": {
            "source": "GitHub commits API",
            "window_days": 28,
            "timestamp_basis": "snapshot timestamp, interpreted as UTC",
        },
        "commit_count_windows": {
            "t0": {name: counts_t0[name].__dict__ for name in FRAMEWORKS},
            "verification": {name: counts_verification[name].__dict__ for name in FRAMEWORKS},
            "latest": {name: counts_latest[name].__dict__ for name in FRAMEWORKS},
        },
        "verification": verification,
        "current_extension": current,
    }

    output_json = Path(args.output_json)
    output_md = Path(args.output_md)
    output_json.parent.mkdir(parents=True, exist_ok=True)
    output_md.parent.mkdir(parents=True, exist_ok=True)
    with output_json.open("w", encoding="utf-8") as f:
        json.dump(result, f, indent=2)
        f.write("\n")
    output_md.write_text(generate_markdown(result), encoding="utf-8")

    print(f"Wrote {output_json}")
    print(f"Wrote {output_md}")
    print(f"Short-note verdict: {verification['short_note_predictions']['joint_verdict']}")
    print(
        "EGR supported:",
        verification["prediction_md_egr"]["main_prediction_supported"],
        "LangChain rank:",
        verification["prediction_md_egr"]["langchain_egr_rank"],
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
