# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-28
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 63
**Data points**: 64

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 137,835 | 22,808 | 205 | 1.0000 | 0.4463 |
| AutoGen | 58,476 | 8,819 | 0 | 0.9275 | 0.3016 |
| Mem0 | 56,936 | 6,484 | 0 | 0.9253 | 0.2278 |
| CrewAI | 52,337 | 7,272 | 0 | 0.9182 | 0.2779 |
| LlamaIndex | 49,718 | 7,469 | 0 | 0.9138 | 0.3005 |
| LiteLLM | 48,500 | 8,421 | 1066 | 0.9117 | 0.9473 |
| DSPy | 34,696 | 2,929 | 0 | 0.8834 | 0.1688 |
| SemanticKernel | 27,996 | 4,609 | 0 | 0.8653 | 0.3293 |
| Haystack | 25,397 | 2,810 | 0 | 0.8571 | 0.2213 |
| PydanticAI | 17,355 | 2,142 | 0 | 0.8249 | 0.2468 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 137,835 | +5.07% | 21,601 | 22,808 | +5.59% |
| AutoGen | 56,243 | 58,476 | +3.97% | 8,453 | 8,819 | +4.33% |
| Mem0 | 51,132 | 56,936 | +11.35% | 5,717 | 6,484 | +13.42% |
| CrewAI | 47,278 | 52,337 | +10.70% | 6,385 | 7,272 | +13.89% |
| LlamaIndex | 48,012 | 49,718 | +3.55% | 7,093 | 7,469 | +5.30% |
| LiteLLM | 40,982 | 48,500 | +18.34% | 6,752 | 8,421 | +24.72% |
| DSPy | 33,187 | 34,696 | +4.55% | 2,728 | 2,929 | +7.37% |
| SemanticKernel | 27,567 | 27,996 | +1.56% | 4,523 | 4,609 | +1.90% |
| Haystack | 24,620 | 25,397 | +3.16% | 2,675 | 2,810 | +5.05% |
| PydanticAI | 15,824 | 17,355 | +9.68% | 1,830 | 2,142 | +17.05% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9473)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present