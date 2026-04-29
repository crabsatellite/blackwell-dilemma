# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-29
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 34
**Data points**: 35

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 135,303 | 22,368 | 183 | 1.0000 | 0.4068 |
| AutoGen | 57,554 | 8,675 | 0 | 0.9277 | 0.3015 |
| Mem0 | 54,352 | 6,120 | 0 | 0.9228 | 0.2252 |
| CrewAI | 50,229 | 6,914 | 0 | 0.9161 | 0.2753 |
| LlamaIndex | 49,026 | 7,331 | 0 | 0.9141 | 0.2991 |
| LiteLLM | 45,123 | 7,646 | 1441 | 0.9071 | 0.9389 |
| DSPy | 34,077 | 2,851 | 0 | 0.8833 | 0.1673 |
| SemanticKernel | 27,805 | 4,574 | 0 | 0.8661 | 0.3290 |
| Haystack | 25,013 | 2,746 | 0 | 0.8571 | 0.2196 |
| PydanticAI | 16,716 | 1,995 | 0 | 0.8230 | 0.2387 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 135,303 | +3.14% | 21,601 | 22,368 | +3.55% |
| AutoGen | 56,243 | 57,554 | +2.33% | 8,453 | 8,675 | +2.63% |
| Mem0 | 51,132 | 54,352 | +6.30% | 5,717 | 6,120 | +7.05% |
| CrewAI | 47,278 | 50,229 | +6.24% | 6,385 | 6,914 | +8.29% |
| LlamaIndex | 48,012 | 49,026 | +2.11% | 7,093 | 7,331 | +3.36% |
| LiteLLM | 40,982 | 45,123 | +10.10% | 6,752 | 7,646 | +13.24% |
| DSPy | 33,187 | 34,077 | +2.68% | 2,728 | 2,851 | +4.51% |
| SemanticKernel | 27,567 | 27,805 | +0.86% | 4,523 | 4,574 | +1.13% |
| Haystack | 24,620 | 25,013 | +1.60% | 2,675 | 2,746 | +2.65% |
| PydanticAI | 15,824 | 16,716 | +5.64% | 1,830 | 1,995 | +9.02% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9389)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present