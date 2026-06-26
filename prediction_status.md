# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-26
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 92
**Data points**: 93

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 140,238 | 23,263 | 321 | 1.0000 | 0.5351 |
| Mem0 | 59,476 | 6,877 | 0 | 0.9276 | 0.2313 |
| AutoGen | 59,265 | 8,938 | 0 | 0.9273 | 0.3016 |
| CrewAI | 54,393 | 7,609 | 0 | 0.9201 | 0.2798 |
| LiteLLM | 51,605 | 9,190 | 947 | 0.9156 | 0.9562 |
| LlamaIndex | 50,411 | 7,636 | 0 | 0.9137 | 0.3029 |
| DSPy | 35,410 | 3,006 | 0 | 0.8839 | 0.1698 |
| SemanticKernel | 28,199 | 4,664 | 0 | 0.8647 | 0.3308 |
| Haystack | 25,730 | 2,884 | 0 | 0.8569 | 0.2242 |
| PydanticAI | 18,008 | 2,257 | 0 | 0.8268 | 0.2507 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 140,238 | +6.90% | 21,601 | 23,263 | +7.69% |
| Mem0 | 51,132 | 59,476 | +16.32% | 5,717 | 6,877 | +20.29% |
| AutoGen | 56,243 | 59,265 | +5.37% | 8,453 | 8,938 | +5.74% |
| CrewAI | 47,278 | 54,393 | +15.05% | 6,385 | 7,609 | +19.17% |
| LiteLLM | 40,982 | 51,605 | +25.92% | 6,752 | 9,190 | +36.11% |
| LlamaIndex | 48,012 | 50,411 | +5.00% | 7,093 | 7,636 | +7.66% |
| DSPy | 33,187 | 35,410 | +6.70% | 2,728 | 3,006 | +10.19% |
| SemanticKernel | 27,567 | 28,199 | +2.29% | 4,523 | 4,664 | +3.12% |
| Haystack | 24,620 | 25,730 | +4.51% | 2,675 | 2,884 | +7.81% |
| PydanticAI | 15,824 | 18,008 | +13.80% | 1,830 | 2,257 | +23.33% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9562)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present