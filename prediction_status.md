# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-06
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 72
**Data points**: 73

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 138,622 | 22,966 | 208 | 1.0000 | 0.4461 |
| AutoGen | 58,725 | 8,863 | 0 | 0.9275 | 0.3018 |
| Mem0 | 57,844 | 6,611 | 60 | 0.9262 | 0.2617 |
| CrewAI | 52,915 | 7,391 | 97 | 0.9187 | 0.3328 |
| LlamaIndex | 49,946 | 7,516 | 53 | 0.9138 | 0.3302 |
| LiteLLM | 49,448 | 8,640 | 1088 | 0.9129 | 0.9495 |
| DSPy | 34,872 | 2,958 | 47 | 0.8834 | 0.1956 |
| SemanticKernel | 28,062 | 4,632 | 13 | 0.8651 | 0.3373 |
| Haystack | 25,466 | 2,830 | 133 | 0.8569 | 0.2956 |
| PydanticAI | 17,550 | 2,179 | 118 | 0.8254 | 0.3134 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 138,622 | +5.67% | 21,601 | 22,966 | +6.32% |
| AutoGen | 56,243 | 58,725 | +4.41% | 8,453 | 8,863 | +4.85% |
| Mem0 | 51,132 | 57,844 | +13.13% | 5,717 | 6,611 | +15.64% |
| CrewAI | 47,278 | 52,915 | +11.92% | 6,385 | 7,391 | +15.76% |
| LlamaIndex | 48,012 | 49,946 | +4.03% | 7,093 | 7,516 | +5.96% |
| LiteLLM | 40,982 | 49,448 | +20.66% | 6,752 | 8,640 | +27.96% |
| DSPy | 33,187 | 34,872 | +5.08% | 2,728 | 2,958 | +8.43% |
| SemanticKernel | 27,567 | 28,062 | +1.80% | 4,523 | 4,632 | +2.41% |
| Haystack | 24,620 | 25,466 | +3.44% | 2,675 | 2,830 | +5.79% |
| PydanticAI | 15,824 | 17,550 | +10.91% | 1,830 | 2,179 | +19.07% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9495)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present