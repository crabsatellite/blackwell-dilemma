# Live Prediction Verification

This directory verifies the pre-registered AI framework ecosystem prediction
from `prediction.md` and the companion short-note design.

## Files

- `verify_live_prediction.py` recomputes the verification metrics from
  `data/snapshots.json` and live GitHub commit counts.
- `live_prediction_verification_2026-05-21.json` is the machine-readable
  verification output.
- `live_prediction_verification_2026-05-21.md` is the human-readable verdict.

## Why Recompute Commit Counts

The original daily tracker uses GitHub's `/stats/commit_activity` endpoint.
That endpoint can return empty or computing results. In several snapshots those
values were recorded as `0`, even though the repositories had commits in the
same 4-week windows.

For the final verification, `verify_live_prediction.py` recomputes commit
counts via the GitHub commits API over explicit 28-day timestamp windows:

```bash
python verification/verify_live_prediction.py
```

If unauthenticated GitHub API limits are exhausted, provide a token:

```bash
GH_TOKEN=... python verification/verify_live_prediction.py
```

## Conclusion

The companion short note's fork-growth predictions are confirmed:

- P1: baseline stars have non-positive Spearman correlation with fork growth.
- P2: LangChain ranks in the bottom half by fork growth.
- P3: LiteLLM's fork growth exceeds LangChain's fork growth.

The commit-based EGR prediction in `prediction.md` is also supported after
recomputing 4-week commit counts: PydanticAI beats LangChain on the
verification date. This is a weak EGR result because LangChain still ranks
second by EGR, triggering the pre-registered top-3 caution.

The reliable interpretation is that the visible quality leader was not the best
growth choice once hidden ecosystem-health dynamics were measured. This is
supporting predictive evidence for the Blackwell Dilemma diagnostic, not causal
proof of the theorem.
