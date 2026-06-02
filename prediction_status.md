# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-02
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 68
**Data points**: 69

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 138,288 | 22,917 | 169 | 1.0000 | 0.4538 |
| AutoGen | 58,624 | 8,855 | 0 | 0.9275 | 0.3021 |
| Mem0 | 57,365 | 6,554 | 0 | 0.9257 | 0.2285 |
| CrewAI | 52,637 | 7,340 | 0 | 0.9184 | 0.2789 |
| LlamaIndex | 49,847 | 7,500 | 0 | 0.9138 | 0.3009 |
| LiteLLM | 48,997 | 8,542 | 829 | 0.9123 | 0.9487 |
| DSPy | 34,778 | 2,947 | 0 | 0.8834 | 0.1695 |
| SemanticKernel | 28,028 | 4,625 | 0 | 0.8652 | 0.3300 |
| Haystack | 25,437 | 2,820 | 0 | 0.8570 | 0.2217 |
| PydanticAI | 17,458 | 2,164 | 0 | 0.8252 | 0.2479 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 138,288 | +5.41% | 21,601 | 22,917 | +6.09% |
| AutoGen | 56,243 | 58,624 | +4.23% | 8,453 | 8,855 | +4.76% |
| Mem0 | 51,132 | 57,365 | +12.19% | 5,717 | 6,554 | +14.64% |
| CrewAI | 47,278 | 52,637 | +11.34% | 6,385 | 7,340 | +14.96% |
| LlamaIndex | 48,012 | 49,847 | +3.82% | 7,093 | 7,500 | +5.74% |
| LiteLLM | 40,982 | 48,997 | +19.56% | 6,752 | 8,542 | +26.51% |
| DSPy | 33,187 | 34,778 | +4.79% | 2,728 | 2,947 | +8.03% |
| SemanticKernel | 27,567 | 28,028 | +1.67% | 4,523 | 4,625 | +2.26% |
| Haystack | 24,620 | 25,437 | +3.32% | 2,675 | 2,820 | +5.42% |
| PydanticAI | 15,824 | 17,458 | +10.33% | 1,830 | 2,164 | +18.25% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9487)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present