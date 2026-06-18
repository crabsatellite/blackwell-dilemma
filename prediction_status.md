# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-18
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 84
**Data points**: 85

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 139,609 | 23,134 | 237 | 1.0000 | 0.4867 |
| AutoGen | 59,049 | 8,905 | 0 | 0.9274 | 0.3016 |
| Mem0 | 58,830 | 6,770 | 0 | 0.9271 | 0.2302 |
| CrewAI | 53,861 | 7,536 | 0 | 0.9196 | 0.2798 |
| LiteLLM | 50,761 | 8,971 | 916 | 0.9146 | 0.9535 |
| LlamaIndex | 50,200 | 7,581 | 0 | 0.9137 | 0.3020 |
| DSPy | 35,109 | 2,979 | 0 | 0.8835 | 0.1697 |
| SemanticKernel | 28,154 | 4,652 | 0 | 0.8648 | 0.3305 |
| Haystack | 25,597 | 2,864 | 0 | 0.8568 | 0.2238 |
| PydanticAI | 17,824 | 2,228 | 77 | 0.8263 | 0.3004 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 139,609 | +6.42% | 21,601 | 23,134 | +7.10% |
| AutoGen | 56,243 | 59,049 | +4.99% | 8,453 | 8,905 | +5.35% |
| Mem0 | 51,132 | 58,830 | +15.06% | 5,717 | 6,770 | +18.42% |
| CrewAI | 47,278 | 53,861 | +13.92% | 6,385 | 7,536 | +18.03% |
| LiteLLM | 40,982 | 50,761 | +23.86% | 6,752 | 8,971 | +32.86% |
| LlamaIndex | 48,012 | 50,200 | +4.56% | 7,093 | 7,581 | +6.88% |
| DSPy | 33,187 | 35,109 | +5.79% | 2,728 | 2,979 | +9.20% |
| SemanticKernel | 27,567 | 28,154 | +2.13% | 4,523 | 4,652 | +2.85% |
| Haystack | 24,620 | 25,597 | +3.97% | 2,675 | 2,864 | +7.07% |
| PydanticAI | 15,824 | 17,824 | +12.64% | 1,830 | 2,228 | +21.75% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9535)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present