# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-07-08
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 104
**Data points**: 105

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 141,268 | 23,479 | 225 | 1.0000 | 0.4757 |
| Mem0 | 60,352 | 7,006 | 173 | 0.9283 | 0.3424 |
| AutoGen | 59,568 | 8,967 | 0 | 0.9272 | 0.3011 |
| CrewAI | 55,119 | 7,751 | 103 | 0.9206 | 0.3469 |
| LiteLLM | 52,921 | 9,551 | 942 | 0.9172 | 0.9610 |
| LlamaIndex | 50,720 | 7,710 | 25 | 0.9136 | 0.3199 |
| DSPy | 35,920 | 3,065 | 3 | 0.8845 | 0.1726 |
| SemanticKernel | 28,282 | 4,670 | 38 | 0.8644 | 0.3544 |
| Haystack | 25,848 | 2,901 | 0 | 0.8568 | 0.2245 |
| PydanticAI | 18,269 | 2,315 | 189 | 0.8275 | 0.3738 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 141,268 | +7.68% | 21,601 | 23,479 | +8.69% |
| Mem0 | 51,132 | 60,352 | +18.03% | 5,717 | 7,006 | +22.55% |
| AutoGen | 56,243 | 59,568 | +5.91% | 8,453 | 8,967 | +6.08% |
| CrewAI | 47,278 | 55,119 | +16.58% | 6,385 | 7,751 | +21.39% |
| LiteLLM | 40,982 | 52,921 | +29.13% | 6,752 | 9,551 | +41.45% |
| LlamaIndex | 48,012 | 50,720 | +5.64% | 7,093 | 7,710 | +8.70% |
| DSPy | 33,187 | 35,920 | +8.24% | 2,728 | 3,065 | +12.35% |
| SemanticKernel | 27,567 | 28,282 | +2.59% | 4,523 | 4,670 | +3.25% |
| Haystack | 24,620 | 25,848 | +4.99% | 2,675 | 2,901 | +8.45% |
| PydanticAI | 15,824 | 18,269 | +15.45% | 1,830 | 2,315 | +26.50% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9610)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present