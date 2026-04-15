# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-15
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 20
**Data points**: 21

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 133,592 | 22,072 | 174 | 1.0000 | 0.4293 |
| AutoGen | 57,095 | 8,594 | 0 | 0.9280 | 0.3010 |
| Mem0 | 53,074 | 5,956 | 0 | 0.9218 | 0.2244 |
| CrewAI | 48,911 | 6,676 | 0 | 0.9149 | 0.2730 |
| LlamaIndex | 48,601 | 7,197 | 0 | 0.9143 | 0.2962 |
| LiteLLM | 43,336 | 7,250 | 1056 | 0.9046 | 0.9346 |
| DSPy | 33,702 | 2,793 | 27 | 0.8833 | 0.1811 |
| SemanticKernel | 27,705 | 4,550 | 0 | 0.8667 | 0.3285 |
| Haystack | 24,833 | 2,718 | 0 | 0.8574 | 0.2189 |
| PydanticAI | 16,365 | 1,939 | 0 | 0.8221 | 0.2370 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 133,592 | +1.83% | 21,601 | 22,072 | +2.18% |
| AutoGen | 56,243 | 57,095 | +1.51% | 8,453 | 8,594 | +1.67% |
| Mem0 | 51,132 | 53,074 | +3.80% | 5,717 | 5,956 | +4.18% |
| CrewAI | 47,278 | 48,911 | +3.45% | 6,385 | 6,676 | +4.56% |
| LlamaIndex | 48,012 | 48,601 | +1.23% | 7,093 | 7,197 | +1.47% |
| LiteLLM | 40,982 | 43,336 | +5.74% | 6,752 | 7,250 | +7.38% |
| DSPy | 33,187 | 33,702 | +1.55% | 2,728 | 2,793 | +2.38% |
| SemanticKernel | 27,567 | 27,705 | +0.50% | 4,523 | 4,550 | +0.60% |
| Haystack | 24,620 | 24,833 | +0.87% | 2,675 | 2,718 | +1.61% |
| PydanticAI | 15,824 | 16,365 | +3.42% | 1,830 | 1,939 | +5.96% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9346)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present