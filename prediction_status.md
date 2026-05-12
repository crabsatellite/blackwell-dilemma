# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-12
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 47
**Data points**: 48

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 136,489 | 22,554 | 164 | 1.0000 | 0.3877 |
| AutoGen | 57,955 | 8,739 | 0 | 0.9276 | 0.3016 |
| Mem0 | 55,458 | 6,290 | 0 | 0.9238 | 0.2268 |
| CrewAI | 51,217 | 7,079 | 0 | 0.9171 | 0.2764 |
| LlamaIndex | 49,345 | 7,394 | 0 | 0.9140 | 0.2997 |
| LiteLLM | 46,624 | 7,962 | 1719 | 0.9092 | 0.9415 |
| DSPy | 34,346 | 2,881 | 0 | 0.8833 | 0.1678 |
| SemanticKernel | 27,893 | 4,592 | 0 | 0.8657 | 0.3293 |
| Haystack | 25,180 | 2,781 | 0 | 0.8571 | 0.2209 |
| PydanticAI | 17,013 | 2,060 | 0 | 0.8239 | 0.2422 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 136,489 | +4.04% | 21,601 | 22,554 | +4.41% |
| AutoGen | 56,243 | 57,955 | +3.04% | 8,453 | 8,739 | +3.38% |
| Mem0 | 51,132 | 55,458 | +8.46% | 5,717 | 6,290 | +10.02% |
| CrewAI | 47,278 | 51,217 | +8.33% | 6,385 | 7,079 | +10.87% |
| LlamaIndex | 48,012 | 49,345 | +2.78% | 7,093 | 7,394 | +4.24% |
| LiteLLM | 40,982 | 46,624 | +13.77% | 6,752 | 7,962 | +17.92% |
| DSPy | 33,187 | 34,346 | +3.49% | 2,728 | 2,881 | +5.61% |
| SemanticKernel | 27,567 | 27,893 | +1.18% | 4,523 | 4,592 | +1.53% |
| Haystack | 24,620 | 25,180 | +2.27% | 2,675 | 2,781 | +3.96% |
| PydanticAI | 15,824 | 17,013 | +7.51% | 1,830 | 2,060 | +12.57% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9415)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present