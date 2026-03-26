# Irreversibility Phase Transition in Bounded Rationality

**Pre-registered prediction experiment**: Testing whether the Blackwell Dilemma manifests in live software ecosystems.

## What is the Blackwell Dilemma?

Blackwell's theorem (1953) states that more informative signals lead to weakly better decisions. We identify a structural exception: when actions are irreversible and signals only cover observable quality (not hidden ecosystem health), more information can lead to **worse** long-term outcomes.

## Live Prediction (2026-03-26)

**System**: AI agent/LLM framework ecosystem (10 frameworks tracked daily via GitHub API)

**Observation**: The quality leader (most GitHub stars) and the ecosystem leader (most development activity) are **different frameworks**. A developer choosing by visibility alone locks into a suboptimal long-term outcome.

**Prediction**: The quality leader will show lower relative ecosystem growth over 8 weeks than at least one framework with fewer stars.

**Verification date**: 2026-05-21

See [prediction.md](prediction.md) for full details and falsification criteria.

## Daily Tracking

GitHub Actions collects daily snapshots of all tracked frameworks. Data is committed automatically to `data/snapshots.json`.

### Run manually
```bash
python tracker.py              # collect today's snapshot
python tracker.py --report     # generate status report
```

## Structure

```
├── tracker.py          # Daily data collection + proxy computation
├── prediction.md       # Pre-registered prediction (timestamped)
├── data/
│   └── snapshots.json  # Time series of daily GitHub snapshots
└── .github/
    └── workflows/
        └── daily-track.yml  # GitHub Actions daily cron
```

## License

MIT
