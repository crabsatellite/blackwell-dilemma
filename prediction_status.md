# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-16
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 82
**Data points**: 83

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 139,430 | 23,107 | 215 | 1.0000 | 0.4960 |
| AutoGen | 58,989 | 8,896 | 0 | 0.9274 | 0.3016 |
| Mem0 | 58,673 | 6,744 | 0 | 0.9269 | 0.2299 |
| CrewAI | 53,666 | 7,509 | 97 | 0.9194 | 0.3541 |
| LiteLLM | 50,535 | 8,908 | 784 | 0.9143 | 0.9525 |
| LlamaIndex | 50,165 | 7,568 | 0 | 0.9137 | 0.3017 |
| DSPy | 35,059 | 2,979 | 0 | 0.8835 | 0.1699 |
| SemanticKernel | 28,132 | 4,649 | 0 | 0.8649 | 0.3305 |
| Haystack | 25,578 | 2,860 | 0 | 0.8568 | 0.2236 |
| PydanticAI | 17,778 | 2,221 | 76 | 0.8261 | 0.3080 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 139,430 | +6.28% | 21,601 | 23,107 | +6.97% |
| AutoGen | 56,243 | 58,989 | +4.88% | 8,453 | 8,896 | +5.24% |
| Mem0 | 51,132 | 58,673 | +14.75% | 5,717 | 6,744 | +17.96% |
| CrewAI | 47,278 | 53,666 | +13.51% | 6,385 | 7,509 | +17.60% |
| LiteLLM | 40,982 | 50,535 | +23.31% | 6,752 | 8,908 | +31.93% |
| LlamaIndex | 48,012 | 50,165 | +4.48% | 7,093 | 7,568 | +6.70% |
| DSPy | 33,187 | 35,059 | +5.64% | 2,728 | 2,979 | +9.20% |
| SemanticKernel | 27,567 | 28,132 | +2.05% | 4,523 | 4,649 | +2.79% |
| Haystack | 24,620 | 25,578 | +3.89% | 2,675 | 2,860 | +6.92% |
| PydanticAI | 15,824 | 17,778 | +12.35% | 1,830 | 2,221 | +21.37% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9525)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present