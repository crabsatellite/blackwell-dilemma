# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-26
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 61
**Data points**: 62

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 137,670 | 22,796 | 186 | 1.0000 | 0.4440 |
| AutoGen | 58,405 | 8,814 | 0 | 0.9275 | 0.3018 |
| Mem0 | 56,725 | 6,470 | 0 | 0.9251 | 0.2281 |
| CrewAI | 52,193 | 7,241 | 0 | 0.9180 | 0.2775 |
| LlamaIndex | 49,667 | 7,459 | 0 | 0.9138 | 0.3004 |
| LiteLLM | 48,253 | 8,339 | 989 | 0.9114 | 0.9456 |
| DSPy | 34,651 | 2,922 | 0 | 0.8834 | 0.1687 |
| SemanticKernel | 27,982 | 4,608 | 0 | 0.8653 | 0.3294 |
| Haystack | 25,372 | 2,804 | 0 | 0.8571 | 0.2210 |
| PydanticAI | 17,306 | 2,132 | 0 | 0.8247 | 0.2464 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 137,670 | +4.94% | 21,601 | 22,796 | +5.53% |
| AutoGen | 56,243 | 58,405 | +3.84% | 8,453 | 8,814 | +4.27% |
| Mem0 | 51,132 | 56,725 | +10.94% | 5,717 | 6,470 | +13.17% |
| CrewAI | 47,278 | 52,193 | +10.40% | 6,385 | 7,241 | +13.41% |
| LlamaIndex | 48,012 | 49,667 | +3.45% | 7,093 | 7,459 | +5.16% |
| LiteLLM | 40,982 | 48,253 | +17.74% | 6,752 | 8,339 | +23.50% |
| DSPy | 33,187 | 34,651 | +4.41% | 2,728 | 2,922 | +7.11% |
| SemanticKernel | 27,567 | 27,982 | +1.51% | 4,523 | 4,608 | +1.88% |
| Haystack | 24,620 | 25,372 | +3.05% | 2,675 | 2,804 | +4.82% |
| PydanticAI | 15,824 | 17,306 | +9.37% | 1,830 | 2,132 | +16.50% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9456)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present