# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-23
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 58
**Data points**: 59

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 137,435 | 22,736 | 245 | 1.0000 | 0.4177 |
| AutoGen | 58,305 | 8,805 | 0 | 0.9275 | 0.3020 |
| Mem0 | 56,474 | 6,438 | 0 | 0.9248 | 0.2280 |
| CrewAI | 51,992 | 7,207 | 0 | 0.9178 | 0.2772 |
| LlamaIndex | 49,601 | 7,450 | 0 | 0.9139 | 0.3004 |
| LiteLLM | 47,988 | 8,275 | 1692 | 0.9111 | 0.9449 |
| DSPy | 34,591 | 2,918 | 0 | 0.8834 | 0.1687 |
| SemanticKernel | 27,961 | 4,606 | 0 | 0.8654 | 0.3295 |
| Haystack | 25,348 | 2,803 | 0 | 0.8571 | 0.2212 |
| PydanticAI | 17,223 | 2,117 | 0 | 0.8245 | 0.2458 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 137,435 | +4.76% | 21,601 | 22,736 | +5.25% |
| AutoGen | 56,243 | 58,305 | +3.67% | 8,453 | 8,805 | +4.16% |
| Mem0 | 51,132 | 56,474 | +10.45% | 5,717 | 6,438 | +12.61% |
| CrewAI | 47,278 | 51,992 | +9.97% | 6,385 | 7,207 | +12.87% |
| LlamaIndex | 48,012 | 49,601 | +3.31% | 7,093 | 7,450 | +5.03% |
| LiteLLM | 40,982 | 47,988 | +17.10% | 6,752 | 8,275 | +22.56% |
| DSPy | 33,187 | 34,591 | +4.23% | 2,728 | 2,918 | +6.96% |
| SemanticKernel | 27,567 | 27,961 | +1.43% | 4,523 | 4,606 | +1.84% |
| Haystack | 24,620 | 25,348 | +2.96% | 2,675 | 2,803 | +4.79% |
| PydanticAI | 15,824 | 17,223 | +8.84% | 1,830 | 2,117 | +15.68% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9449)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present