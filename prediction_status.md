# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-24
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 90
**Data points**: 91

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 140,050 | 23,221 | 320 | 1.0000 | 0.5551 |
| Mem0 | 59,294 | 6,844 | 0 | 0.9275 | 0.2308 |
| AutoGen | 59,195 | 8,926 | 0 | 0.9273 | 0.3016 |
| CrewAI | 54,263 | 7,598 | 113 | 0.9200 | 0.3590 |
| LiteLLM | 51,341 | 9,118 | 859 | 0.9153 | 0.9552 |
| LlamaIndex | 50,337 | 7,619 | 0 | 0.9136 | 0.3027 |
| DSPy | 35,339 | 2,998 | 0 | 0.8838 | 0.1697 |
| SemanticKernel | 28,181 | 4,662 | 0 | 0.8647 | 0.3309 |
| Haystack | 25,651 | 2,877 | 0 | 0.8568 | 0.2243 |
| PydanticAI | 17,955 | 2,251 | 0 | 0.8267 | 0.2507 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 140,050 | +6.75% | 21,601 | 23,221 | +7.50% |
| Mem0 | 51,132 | 59,294 | +15.96% | 5,717 | 6,844 | +19.71% |
| AutoGen | 56,243 | 59,195 | +5.25% | 8,453 | 8,926 | +5.60% |
| CrewAI | 47,278 | 54,263 | +14.77% | 6,385 | 7,598 | +19.00% |
| LiteLLM | 40,982 | 51,341 | +25.28% | 6,752 | 9,118 | +35.04% |
| LlamaIndex | 48,012 | 50,337 | +4.84% | 7,093 | 7,619 | +7.42% |
| DSPy | 33,187 | 35,339 | +6.48% | 2,728 | 2,998 | +9.90% |
| SemanticKernel | 27,567 | 28,181 | +2.23% | 4,523 | 4,662 | +3.07% |
| Haystack | 24,620 | 25,651 | +4.19% | 2,675 | 2,877 | +7.55% |
| PydanticAI | 15,824 | 17,955 | +13.47% | 1,830 | 2,251 | +23.01% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9552)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present