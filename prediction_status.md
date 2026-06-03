# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-03
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 69
**Data points**: 70

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 138,379 | 22,923 | 177 | 1.0000 | 0.4427 |
| AutoGen | 58,656 | 8,855 | 0 | 0.9275 | 0.3019 |
| Mem0 | 57,518 | 6,575 | 0 | 0.9258 | 0.2286 |
| CrewAI | 52,721 | 7,352 | 0 | 0.9185 | 0.2789 |
| LlamaIndex | 49,867 | 7,501 | 0 | 0.9138 | 0.3008 |
| LiteLLM | 49,114 | 8,552 | 953 | 0.9125 | 0.9483 |
| DSPy | 34,805 | 2,947 | 0 | 0.8834 | 0.1693 |
| SemanticKernel | 28,037 | 4,628 | 0 | 0.8651 | 0.3301 |
| Haystack | 25,445 | 2,827 | 0 | 0.8569 | 0.2222 |
| PydanticAI | 17,481 | 2,163 | 0 | 0.8252 | 0.2475 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 138,379 | +5.48% | 21,601 | 22,923 | +6.12% |
| AutoGen | 56,243 | 58,656 | +4.29% | 8,453 | 8,855 | +4.76% |
| Mem0 | 51,132 | 57,518 | +12.49% | 5,717 | 6,575 | +15.01% |
| CrewAI | 47,278 | 52,721 | +11.51% | 6,385 | 7,352 | +15.14% |
| LlamaIndex | 48,012 | 49,867 | +3.86% | 7,093 | 7,501 | +5.75% |
| LiteLLM | 40,982 | 49,114 | +19.84% | 6,752 | 8,552 | +26.66% |
| DSPy | 33,187 | 34,805 | +4.88% | 2,728 | 2,947 | +8.03% |
| SemanticKernel | 27,567 | 28,037 | +1.70% | 4,523 | 4,628 | +2.32% |
| Haystack | 24,620 | 25,445 | +3.35% | 2,675 | 2,827 | +5.68% |
| PydanticAI | 15,824 | 17,481 | +10.47% | 1,830 | 2,163 | +18.20% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9483)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present