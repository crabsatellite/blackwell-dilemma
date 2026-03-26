"""
MRS (Minimal Real System) Daily Tracker
========================================
Tracks AI agent/LLM framework ecosystem in real time.

Purpose: Collect daily GitHub data → compute q(t)/e(t) proxies →
validate or falsify the Blackwell Dilemma prediction made at t0.

Prediction (2026-03-26):
  "LangChain (131k stars, quality leader) will show LOWER
   relative ecosystem growth than at least one framework with
   <60k stars over the next 8 weeks."

Usage:
  python tracker.py              # collect today's snapshot
  python tracker.py --report     # generate status report
"""

import subprocess
import json
import math
from pathlib import Path
from datetime import datetime, date
import sys
import argparse

BASE_DIR = Path(__file__).parent
DATA_DIR = BASE_DIR / "data"
DATA_DIR.mkdir(exist_ok=True)

SNAPSHOTS_FILE = DATA_DIR / "snapshots.json"

# =====================================================================
# Tracked Frameworks
# =====================================================================

FRAMEWORKS = {
    'LangChain':       'langchain-ai/langchain',
    'AutoGen':         'microsoft/autogen',
    'Mem0':            'mem0ai/mem0',
    'LlamaIndex':      'run-llama/llama_index',
    'CrewAI':          'crewAIInc/crewAI',
    'LiteLLM':         'BerriAI/litellm',
    'DSPy':            'stanfordnlp/dspy',
    'SemanticKernel':  'microsoft/semantic-kernel',
    'Haystack':        'deepset-ai/haystack',
    'PydanticAI':      'pydantic/pydantic-ai',
}

# =====================================================================
# Data Collection
# =====================================================================

def _gh_api(endpoint, jq_filter=None):
    cmd = ['gh', 'api', endpoint]
    if jq_filter:
        cmd += ['--jq', jq_filter]
    try:
        r = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
        if r.returncode == 0 and r.stdout.strip():
            parsed = json.loads(r.stdout)
            if isinstance(parsed, dict) and not parsed:
                return None  # GitHub 202 computing
            return parsed
    except Exception:
        pass
    return None


def collect_snapshot():
    """Collect current GitHub data for all frameworks."""
    today = date.today().isoformat()
    snapshot = {
        'date': today,
        'timestamp': datetime.now().isoformat(),
        'frameworks': {},
    }

    for name, repo in FRAMEWORKS.items():
        print(f"  {name:18s} ({repo})...", end=" ", flush=True)

        stats = _gh_api(
            f'repos/{repo}',
            '{stars: .stargazers_count, forks: .forks_count, '
            'issues: .open_issues_count, watchers: .subscribers_count, '
            'size: .size, pushed: .pushed_at}'
        )
        if stats is None:
            print("FAILED")
            continue

        # 52-week commit activity (may return null if GitHub is computing)
        activity = _gh_api(
            f'repos/{repo}/stats/commit_activity',
            '[.[].total]'
        )
        commits_52w = sum(activity) if isinstance(activity, list) else None
        commits_4w = sum(activity[-4:]) if isinstance(activity, list) else None

        entry = {
            'repo': repo,
            'stars': stats.get('stars', 0),
            'forks': stats.get('forks', 0),
            'issues': stats.get('issues', 0),
            'watchers': stats.get('watchers', 0),
            'size': stats.get('size', 0),
            'pushed': stats.get('pushed', ''),
            'commits_52w': commits_52w,
            'commits_4w': commits_4w,
        }
        snapshot['frameworks'][name] = entry
        c52 = f"{commits_52w}" if commits_52w is not None else "computing"
        print(f"stars={entry['stars']:,}  commits_52w={c52}")

    return snapshot


def save_snapshot(snapshot):
    """Append snapshot to time series."""
    if SNAPSHOTS_FILE.exists():
        with open(SNAPSHOTS_FILE) as f:
            series = json.load(f)
    else:
        series = {'prediction': PREDICTION, 'snapshots': []}

    # Replace existing snapshot for today if re-run
    series['snapshots'] = [
        s for s in series['snapshots'] if s['date'] != snapshot['date']
    ]
    series['snapshots'].append(snapshot)
    series['snapshots'].sort(key=lambda s: s['date'])

    with open(SNAPSHOTS_FILE, 'w') as f:
        json.dump(series, f, indent=2, default=str)

    print(f"\n  Saved to {SNAPSHOTS_FILE}")
    print(f"  Total snapshots: {len(series['snapshots'])}")
    return series


# =====================================================================
# Prediction Definition
# =====================================================================

PREDICTION = {
    't0': '2026-03-26',
    't1': '2026-05-21',
    'window_weeks': 8,
    'quality_leader': 'LangChain',
    'quality_leader_stars_t0': 131189,
    'hypothesis': (
        'LangChain (quality leader at t0 with 131k stars, 2.3x #2) '
        'will show LOWER relative ecosystem growth over 8 weeks than '
        'at least one framework with <60k stars at t0. '
        'Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * '
        '(forks(t1)/forks(t0)). This tests the Blackwell Dilemma: '
        'the most visible framework is not necessarily the healthiest.'
    ),
    'falsification': (
        'If LangChain shows the HIGHEST ecosystem growth ratio '
        'among all tracked frameworks at t1, the prediction fails.'
    ),
    'mechanism': (
        'C1: switching cost (workflow lock-in, API coupling) '
        'C2: quality signal (stars) misaligned with ecosystem health (commits, contributors) '
        'C3: stars/downloads do not reveal commit trajectory or contributor diversity'
    ),
}


# =====================================================================
# Proxy Computation
# =====================================================================

def compute_proxies(snapshot):
    """Compute q(t) and e(t) from snapshot data."""
    fw = snapshot['frameworks']
    if not fw:
        return {}

    max_stars = max(d['stars'] for d in fw.values())
    # For ecosystem, use commits_4w (most recent signal) if available, else forks
    commits_available = {
        n: d for n, d in fw.items() if d.get('commits_4w') is not None
    }
    max_commits_4w = max(
        (d['commits_4w'] for d in commits_available.values()),
        default=1
    )

    proxies = {}
    for name, d in fw.items():
        q = math.log1p(d['stars']) / math.log1p(max_stars)

        if d.get('commits_4w') is not None:
            e_commits = d['commits_4w'] / max_commits_4w if max_commits_4w > 0 else 0
        else:
            # Fallback: use fork/star ratio as ecosystem proxy
            fork_ratio = d['forks'] / max(d['stars'], 1)
            e_commits = min(1.0, fork_ratio / 0.2)

        fork_ratio = d['forks'] / max(d['stars'], 1)
        e_forks = min(1.0, fork_ratio / 0.2)
        e = 0.6 * e_commits + 0.4 * e_forks

        proxies[name] = {'q': round(q, 4), 'e': round(e, 4)}

    return proxies


# =====================================================================
# Report Generation
# =====================================================================

def generate_report(series):
    """Generate prediction tracking report."""
    snapshots = series['snapshots']
    if not snapshots:
        print("No data to report.")
        return

    latest = snapshots[-1]
    proxies = compute_proxies(latest)

    lines = []
    lines.append("# Blackwell Dilemma MRS: Prediction Tracker")
    lines.append(f"\n**Report date**: {latest['date']}")
    lines.append(f"**Prediction made**: {series['prediction']['t0']}")
    lines.append(f"**Verification date**: {series['prediction']['t1']}")
    lines.append(f"**Days elapsed**: {(date.fromisoformat(latest['date']) - date.fromisoformat(series['prediction']['t0'])).days}")
    lines.append(f"**Data points**: {len(snapshots)}")

    lines.append("\n## Hypothesis")
    lines.append(f"> {series['prediction']['hypothesis']}")

    lines.append("\n## Current Snapshot")
    lines.append("| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |")
    lines.append("|-----------|-------|-------|------------|-------------|---------------|")
    for name in sorted(latest['frameworks'].keys(),
                       key=lambda n: latest['frameworks'][n]['stars'],
                       reverse=True):
        d = latest['frameworks'][name]
        p = proxies.get(name, {})
        c4w = str(d['commits_4w']) if d.get('commits_4w') is not None else 'N/A'
        lines.append(
            f"| {name} | {d['stars']:,} | {d['forks']:,} | {c4w} | "
            f"{p.get('q', 'N/A'):.4f} | {p.get('e', 'N/A'):.4f} |"
        )

    # Time series analysis if we have >1 snapshots
    if len(snapshots) >= 2:
        first = snapshots[0]
        lines.append("\n## Growth Since t0")
        lines.append("| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |")
        lines.append("|-----------|----------|-----------|--------|----------|-----------|--------|")
        for name in sorted(latest['frameworks'].keys(),
                           key=lambda n: latest['frameworks'][n]['stars'],
                           reverse=True):
            if name not in first['frameworks'] or name not in latest['frameworks']:
                continue
            d0 = first['frameworks'][name]
            d1 = latest['frameworks'][name]
            star_growth = (d1['stars'] - d0['stars']) / max(d0['stars'], 1)
            fork_growth = (d1['forks'] - d0['forks']) / max(d0['forks'], 1)
            lines.append(
                f"| {name} | {d0['stars']:,} | {d1['stars']:,} | "
                f"{star_growth:+.2%} | {d0['forks']:,} | {d1['forks']:,} | "
                f"{fork_growth:+.2%} |"
            )

    # Misalignment check
    lines.append("\n## Diagnostic")
    if proxies:
        q_leader = max(proxies, key=lambda n: proxies[n]['q'])
        e_leader = max(proxies, key=lambda n: proxies[n]['e'])
        lines.append(f"- Quality leader (q): **{q_leader}** (q={proxies[q_leader]['q']:.4f})")
        lines.append(f"- Ecosystem leader (e): **{e_leader}** (e={proxies[e_leader]['e']:.4f})")
        misaligned = q_leader != e_leader
        lines.append(f"- **Misalignment (C2)**: {'YES' if misaligned else 'NO'}")
        if misaligned:
            lines.append(f"  - Quality leader {q_leader} != ecosystem leader {e_leader}")
            lines.append(f"  - Blackwell Dilemma structure present")

    report_text = "\n".join(lines)

    report_path = BASE_DIR / "prediction_status.md"
    with open(report_path, 'w', encoding='utf-8') as f:
        f.write(report_text)
    print(f"\n  Report saved to {report_path}")
    print(report_text)
    return report_text


# =====================================================================
# Main
# =====================================================================

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='MRS Daily Tracker')
    parser.add_argument('--report', action='store_true',
                        help='Generate prediction status report')
    args = parser.parse_args()

    print("=" * 70)
    print("MRS TRACKER: AI Agent Framework Ecosystem")
    print(f"Date: {date.today().isoformat()}")
    print("=" * 70)

    if args.report:
        if SNAPSHOTS_FILE.exists():
            with open(SNAPSHOTS_FILE) as f:
                series = json.load(f)
            generate_report(series)
        else:
            print("No snapshots found. Run without --report first.")
        sys.exit(0)

    # Collect and save
    print("\n[1] Collecting snapshot...")
    snapshot = collect_snapshot()

    print("\n[2] Computing proxies...")
    proxies = compute_proxies(snapshot)
    for name in sorted(proxies, key=lambda n: proxies[n]['q'], reverse=True):
        p = proxies[name]
        print(f"    {name:18s}: q={p['q']:.4f}  e={p['e']:.4f}")

    print("\n[3] Saving snapshot...")
    series = save_snapshot(snapshot)

    print("\n[4] Generating report...")
    generate_report(series)

    print("\n" + "=" * 70)
    print("DONE. Run daily to build time series.")
    print(f"  Next: python tracker.py --report")
    print("=" * 70)
