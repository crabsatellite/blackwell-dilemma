# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-01
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 6
**Data points**: 7

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 131,856 | 21,737 | 211 | 1.0000 | 0.3898 |
| AutoGen | 56,536 | 8,496 | 0 | 0.9282 | 0.3006 |
| Mem0 | 51,629 | 5,780 | 0 | 0.9205 | 0.2239 |
| LlamaIndex | 48,183 | 7,132 | 0 | 0.9146 | 0.2960 |
| CrewAI | 47,742 | 6,477 | 0 | 0.9138 | 0.2713 |
| LiteLLM | 41,744 | 6,895 | 2106 | 0.9024 | 0.9303 |
| DSPy | 33,338 | 2,742 | 0 | 0.8834 | 0.1645 |
| SemanticKernel | 27,606 | 4,529 | 0 | 0.8674 | 0.3281 |
| Haystack | 24,672 | 2,689 | 0 | 0.8578 | 0.2180 |
| PydanticAI | 15,999 | 1,855 | 0 | 0.8211 | 0.2319 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 131,856 | +0.51% | 21,601 | 21,737 | +0.63% |
| AutoGen | 56,243 | 56,536 | +0.52% | 8,453 | 8,496 | +0.51% |
| Mem0 | 51,132 | 51,629 | +0.97% | 5,717 | 5,780 | +1.10% |
| LlamaIndex | 48,012 | 48,183 | +0.36% | 7,093 | 7,132 | +0.55% |
| CrewAI | 47,278 | 47,742 | +0.98% | 6,385 | 6,477 | +1.44% |
| LiteLLM | 40,982 | 41,744 | +1.86% | 6,752 | 6,895 | +2.12% |
| DSPy | 33,187 | 33,338 | +0.45% | 2,728 | 2,742 | +0.51% |
| SemanticKernel | 27,567 | 27,606 | +0.14% | 4,523 | 4,529 | +0.13% |
| Haystack | 24,620 | 24,672 | +0.21% | 2,675 | 2,689 | +0.52% |
| PydanticAI | 15,824 | 15,999 | +1.11% | 1,830 | 1,855 | +1.37% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9303)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present