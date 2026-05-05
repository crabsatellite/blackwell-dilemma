# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-05
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 40
**Data points**: 41

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 135,798 | 22,444 | 190 | 1.0000 | 0.3874 |
| AutoGen | 57,712 | 8,710 | 0 | 0.9276 | 0.3018 |
| Mem0 | 54,781 | 6,199 | 0 | 0.9232 | 0.2263 |
| CrewAI | 50,632 | 6,980 | 0 | 0.9165 | 0.2757 |
| LlamaIndex | 49,128 | 7,352 | 0 | 0.9140 | 0.2993 |
| LiteLLM | 45,696 | 7,767 | 2006 | 0.9078 | 0.9399 |
| DSPy | 34,196 | 2,870 | 0 | 0.8833 | 0.1679 |
| SemanticKernel | 27,836 | 4,581 | 0 | 0.8659 | 0.3291 |
| Haystack | 25,081 | 2,761 | 0 | 0.8571 | 0.2202 |
| PydanticAI | 16,843 | 2,026 | 0 | 0.8234 | 0.2406 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 135,798 | +3.51% | 21,601 | 22,444 | +3.90% |
| AutoGen | 56,243 | 57,712 | +2.61% | 8,453 | 8,710 | +3.04% |
| Mem0 | 51,132 | 54,781 | +7.14% | 5,717 | 6,199 | +8.43% |
| CrewAI | 47,278 | 50,632 | +7.09% | 6,385 | 6,980 | +9.32% |
| LlamaIndex | 48,012 | 49,128 | +2.32% | 7,093 | 7,352 | +3.65% |
| LiteLLM | 40,982 | 45,696 | +11.50% | 6,752 | 7,767 | +15.03% |
| DSPy | 33,187 | 34,196 | +3.04% | 2,728 | 2,870 | +5.21% |
| SemanticKernel | 27,567 | 27,836 | +0.98% | 4,523 | 4,581 | +1.28% |
| Haystack | 24,620 | 25,081 | +1.87% | 2,675 | 2,761 | +3.21% |
| PydanticAI | 15,824 | 16,843 | +6.44% | 1,830 | 2,026 | +10.71% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9399)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present