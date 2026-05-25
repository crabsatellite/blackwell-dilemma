# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-25
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 60
**Data points**: 61

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 137,575 | 22,774 | 184 | 1.0000 | 0.4468 |
| AutoGen | 58,369 | 8,810 | 0 | 0.9275 | 0.3019 |
| Mem0 | 56,641 | 6,460 | 0 | 0.9250 | 0.2281 |
| CrewAI | 52,131 | 7,230 | 0 | 0.9180 | 0.2774 |
| LlamaIndex | 49,644 | 7,456 | 0 | 0.9139 | 0.3004 |
| LiteLLM | 48,153 | 8,322 | 954 | 0.9113 | 0.9456 |
| DSPy | 34,622 | 2,919 | 0 | 0.8834 | 0.1686 |
| SemanticKernel | 27,972 | 4,607 | 0 | 0.8654 | 0.3294 |
| Haystack | 25,369 | 2,806 | 0 | 0.8571 | 0.2212 |
| PydanticAI | 17,274 | 2,130 | 0 | 0.8246 | 0.2466 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 137,575 | +4.87% | 21,601 | 22,774 | +5.43% |
| AutoGen | 56,243 | 58,369 | +3.78% | 8,453 | 8,810 | +4.22% |
| Mem0 | 51,132 | 56,641 | +10.77% | 5,717 | 6,460 | +13.00% |
| CrewAI | 47,278 | 52,131 | +10.26% | 6,385 | 7,230 | +13.23% |
| LlamaIndex | 48,012 | 49,644 | +3.40% | 7,093 | 7,456 | +5.12% |
| LiteLLM | 40,982 | 48,153 | +17.50% | 6,752 | 8,322 | +23.25% |
| DSPy | 33,187 | 34,622 | +4.32% | 2,728 | 2,919 | +7.00% |
| SemanticKernel | 27,567 | 27,972 | +1.47% | 4,523 | 4,607 | +1.86% |
| Haystack | 24,620 | 25,369 | +3.04% | 2,675 | 2,806 | +4.90% |
| PydanticAI | 15,824 | 17,274 | +9.16% | 1,830 | 2,130 | +16.39% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9456)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present