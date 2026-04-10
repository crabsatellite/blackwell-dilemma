# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-10
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 15
**Data points**: 16

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 133,003 | 21,947 | 211 | 1.0000 | 0.4154 |
| AutoGen | 56,902 | 8,557 | 0 | 0.9280 | 0.3008 |
| Mem0 | 52,501 | 5,889 | 0 | 0.9212 | 0.2243 |
| CrewAI | 48,484 | 6,617 | 0 | 0.9145 | 0.2730 |
| LlamaIndex | 48,470 | 7,184 | 0 | 0.9144 | 0.2964 |
| LiteLLM | 42,773 | 7,120 | 1482 | 0.9038 | 0.9329 |
| DSPy | 33,574 | 2,772 | 0 | 0.8833 | 0.1651 |
| SemanticKernel | 27,677 | 4,541 | 0 | 0.8670 | 0.3281 |
| Haystack | 24,785 | 2,704 | 0 | 0.8576 | 0.2182 |
| PydanticAI | 16,222 | 1,891 | 0 | 0.8217 | 0.2331 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 133,003 | +1.38% | 21,601 | 21,947 | +1.60% |
| AutoGen | 56,243 | 56,902 | +1.17% | 8,453 | 8,557 | +1.23% |
| Mem0 | 51,132 | 52,501 | +2.68% | 5,717 | 5,889 | +3.01% |
| CrewAI | 47,278 | 48,484 | +2.55% | 6,385 | 6,617 | +3.63% |
| LlamaIndex | 48,012 | 48,470 | +0.95% | 7,093 | 7,184 | +1.28% |
| LiteLLM | 40,982 | 42,773 | +4.37% | 6,752 | 7,120 | +5.45% |
| DSPy | 33,187 | 33,574 | +1.17% | 2,728 | 2,772 | +1.61% |
| SemanticKernel | 27,567 | 27,677 | +0.40% | 4,523 | 4,541 | +0.40% |
| Haystack | 24,620 | 24,785 | +0.67% | 2,675 | 2,704 | +1.08% |
| PydanticAI | 15,824 | 16,222 | +2.52% | 1,830 | 1,891 | +3.33% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9329)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present