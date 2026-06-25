# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-25
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 91
**Data points**: 92

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 140,141 | 23,245 | 320 | 1.0000 | 0.5494 |
| Mem0 | 59,399 | 6,863 | 0 | 0.9276 | 0.2311 |
| AutoGen | 59,226 | 8,934 | 0 | 0.9273 | 0.3017 |
| CrewAI | 54,326 | 7,605 | 0 | 0.9200 | 0.2800 |
| LiteLLM | 51,465 | 9,162 | 882 | 0.9155 | 0.9560 |
| LlamaIndex | 50,366 | 7,629 | 0 | 0.9136 | 0.3029 |
| DSPy | 35,377 | 3,002 | 0 | 0.8838 | 0.1697 |
| SemanticKernel | 28,191 | 4,663 | 0 | 0.8647 | 0.3308 |
| Haystack | 25,711 | 2,881 | 0 | 0.8569 | 0.2241 |
| PydanticAI | 17,989 | 2,254 | 0 | 0.8268 | 0.2506 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 140,141 | +6.82% | 21,601 | 23,245 | +7.61% |
| Mem0 | 51,132 | 59,399 | +16.17% | 5,717 | 6,863 | +20.05% |
| AutoGen | 56,243 | 59,226 | +5.30% | 8,453 | 8,934 | +5.69% |
| CrewAI | 47,278 | 54,326 | +14.91% | 6,385 | 7,605 | +19.11% |
| LiteLLM | 40,982 | 51,465 | +25.58% | 6,752 | 9,162 | +35.69% |
| LlamaIndex | 48,012 | 50,366 | +4.90% | 7,093 | 7,629 | +7.56% |
| DSPy | 33,187 | 35,377 | +6.60% | 2,728 | 3,002 | +10.04% |
| SemanticKernel | 27,567 | 28,191 | +2.26% | 4,523 | 4,663 | +3.10% |
| Haystack | 24,620 | 25,711 | +4.43% | 2,675 | 2,881 | +7.70% |
| PydanticAI | 15,824 | 17,989 | +13.68% | 1,830 | 2,254 | +23.17% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9560)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present