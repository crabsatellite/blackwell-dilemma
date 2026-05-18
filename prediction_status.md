# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-18
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 53
**Data points**: 54

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 136,980 | 22,657 | 171 | 1.0000 | 0.4018 |
| AutoGen | 58,124 | 8,771 | 0 | 0.9275 | 0.3018 |
| Mem0 | 55,992 | 6,375 | 0 | 0.9244 | 0.2277 |
| CrewAI | 51,619 | 7,143 | 0 | 0.9175 | 0.2768 |
| LlamaIndex | 49,480 | 7,422 | 0 | 0.9139 | 0.3000 |
| LiteLLM | 47,377 | 8,135 | 1446 | 0.9102 | 0.9434 |
| DSPy | 34,495 | 2,901 | 0 | 0.8834 | 0.1682 |
| SemanticKernel | 27,926 | 4,606 | 0 | 0.8655 | 0.3299 |
| Haystack | 25,266 | 2,790 | 0 | 0.8571 | 0.2209 |
| PydanticAI | 17,118 | 2,093 | 0 | 0.8242 | 0.2445 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 136,980 | +4.41% | 21,601 | 22,657 | +4.89% |
| AutoGen | 56,243 | 58,124 | +3.34% | 8,453 | 8,771 | +3.76% |
| Mem0 | 51,132 | 55,992 | +9.50% | 5,717 | 6,375 | +11.51% |
| CrewAI | 47,278 | 51,619 | +9.18% | 6,385 | 7,143 | +11.87% |
| LlamaIndex | 48,012 | 49,480 | +3.06% | 7,093 | 7,422 | +4.64% |
| LiteLLM | 40,982 | 47,377 | +15.60% | 6,752 | 8,135 | +20.48% |
| DSPy | 33,187 | 34,495 | +3.94% | 2,728 | 2,901 | +6.34% |
| SemanticKernel | 27,567 | 27,926 | +1.30% | 4,523 | 4,606 | +1.84% |
| Haystack | 24,620 | 25,266 | +2.62% | 2,675 | 2,790 | +4.30% |
| PydanticAI | 15,824 | 17,118 | +8.18% | 1,830 | 2,093 | +14.37% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9434)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present