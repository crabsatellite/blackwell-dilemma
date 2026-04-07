# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-07
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 12
**Data points**: 13

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 132,584 | 21,885 | 195 | 1.0000 | 0.4138 |
| AutoGen | 56,771 | 8,541 | 0 | 0.9281 | 0.3009 |
| Mem0 | 52,124 | 5,840 | 0 | 0.9208 | 0.2241 |
| LlamaIndex | 48,355 | 7,165 | 0 | 0.9145 | 0.2963 |
| CrewAI | 48,200 | 6,571 | 146 | 0.9142 | 0.3353 |
| LiteLLM | 42,380 | 7,043 | 1398 | 0.9033 | 0.9324 |
| DSPy | 33,495 | 2,767 | 0 | 0.8834 | 0.1652 |
| SemanticKernel | 27,663 | 4,536 | 0 | 0.8671 | 0.3279 |
| Haystack | 24,745 | 2,697 | 0 | 0.8577 | 0.2180 |
| PydanticAI | 16,144 | 1,882 | 0 | 0.8215 | 0.2332 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 132,584 | +1.06% | 21,601 | 21,885 | +1.31% |
| AutoGen | 56,243 | 56,771 | +0.94% | 8,453 | 8,541 | +1.04% |
| Mem0 | 51,132 | 52,124 | +1.94% | 5,717 | 5,840 | +2.15% |
| LlamaIndex | 48,012 | 48,355 | +0.71% | 7,093 | 7,165 | +1.02% |
| CrewAI | 47,278 | 48,200 | +1.95% | 6,385 | 6,571 | +2.91% |
| LiteLLM | 40,982 | 42,380 | +3.41% | 6,752 | 7,043 | +4.31% |
| DSPy | 33,187 | 33,495 | +0.93% | 2,728 | 2,767 | +1.43% |
| SemanticKernel | 27,567 | 27,663 | +0.35% | 4,523 | 4,536 | +0.29% |
| Haystack | 24,620 | 24,745 | +0.51% | 2,675 | 2,697 | +0.82% |
| PydanticAI | 15,824 | 16,144 | +2.02% | 1,830 | 1,882 | +2.84% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9324)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present