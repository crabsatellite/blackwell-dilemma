# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-26
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 31
**Data points**: 32

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 134,936 | 22,310 | 167 | 1.0000 | 0.4039 |
| AutoGen | 57,438 | 8,660 | 0 | 0.9277 | 0.3015 |
| Mem0 | 54,075 | 6,089 | 0 | 0.9226 | 0.2252 |
| CrewAI | 49,928 | 6,865 | 181 | 0.9158 | 0.3543 |
| LlamaIndex | 48,939 | 7,310 | 0 | 0.9141 | 0.2987 |
| LiteLLM | 44,731 | 7,565 | 1369 | 0.9065 | 0.9382 |
| DSPy | 34,007 | 2,842 | 0 | 0.8833 | 0.1671 |
| SemanticKernel | 27,786 | 4,574 | 0 | 0.8662 | 0.3292 |
| Haystack | 24,992 | 2,737 | 0 | 0.8573 | 0.2190 |
| PydanticAI | 16,636 | 1,989 | 0 | 0.8228 | 0.2391 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 134,936 | +2.86% | 21,601 | 22,310 | +3.28% |
| AutoGen | 56,243 | 57,438 | +2.12% | 8,453 | 8,660 | +2.45% |
| Mem0 | 51,132 | 54,075 | +5.76% | 5,717 | 6,089 | +6.51% |
| CrewAI | 47,278 | 49,928 | +5.61% | 6,385 | 6,865 | +7.52% |
| LlamaIndex | 48,012 | 48,939 | +1.93% | 7,093 | 7,310 | +3.06% |
| LiteLLM | 40,982 | 44,731 | +9.15% | 6,752 | 7,565 | +12.04% |
| DSPy | 33,187 | 34,007 | +2.47% | 2,728 | 2,842 | +4.18% |
| SemanticKernel | 27,567 | 27,786 | +0.79% | 4,523 | 4,574 | +1.13% |
| Haystack | 24,620 | 24,992 | +1.51% | 2,675 | 2,737 | +2.32% |
| PydanticAI | 15,824 | 16,636 | +5.13% | 1,830 | 1,989 | +8.69% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9382)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present