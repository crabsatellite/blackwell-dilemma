# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-14
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 49
**Data points**: 50

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 136,680 | 22,602 | 179 | 1.0000 | 0.3886 |
| AutoGen | 58,012 | 8,751 | 0 | 0.9275 | 0.3017 |
| Mem0 | 55,647 | 6,336 | 0 | 0.9240 | 0.2277 |
| CrewAI | 51,366 | 7,100 | 0 | 0.9172 | 0.2764 |
| LlamaIndex | 49,391 | 7,406 | 0 | 0.9139 | 0.2999 |
| LiteLLM | 46,903 | 8,031 | 1857 | 0.9096 | 0.9425 |
| DSPy | 34,403 | 2,889 | 0 | 0.8833 | 0.1680 |
| SemanticKernel | 27,901 | 4,598 | 0 | 0.8656 | 0.3296 |
| Haystack | 25,221 | 2,784 | 0 | 0.8571 | 0.2208 |
| PydanticAI | 17,051 | 2,075 | 0 | 0.8240 | 0.2434 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 136,680 | +4.18% | 21,601 | 22,602 | +4.63% |
| AutoGen | 56,243 | 58,012 | +3.15% | 8,453 | 8,751 | +3.53% |
| Mem0 | 51,132 | 55,647 | +8.83% | 5,717 | 6,336 | +10.83% |
| CrewAI | 47,278 | 51,366 | +8.65% | 6,385 | 7,100 | +11.20% |
| LlamaIndex | 48,012 | 49,391 | +2.87% | 7,093 | 7,406 | +4.41% |
| LiteLLM | 40,982 | 46,903 | +14.45% | 6,752 | 8,031 | +18.94% |
| DSPy | 33,187 | 34,403 | +3.66% | 2,728 | 2,889 | +5.90% |
| SemanticKernel | 27,567 | 27,901 | +1.21% | 4,523 | 4,598 | +1.66% |
| Haystack | 24,620 | 25,221 | +2.44% | 2,675 | 2,784 | +4.07% |
| PydanticAI | 15,824 | 17,051 | +7.75% | 1,830 | 2,075 | +13.39% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9425)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present