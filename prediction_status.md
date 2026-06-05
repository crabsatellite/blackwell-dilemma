# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-05
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 71
**Data points**: 72

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 138,548 | 22,954 | 198 | 1.0000 | 0.4450 |
| AutoGen | 58,704 | 8,861 | 0 | 0.9275 | 0.3019 |
| Mem0 | 57,752 | 6,600 | 51 | 0.9261 | 0.2578 |
| CrewAI | 52,870 | 7,381 | 92 | 0.9186 | 0.3320 |
| LlamaIndex | 49,929 | 7,510 | 53 | 0.9138 | 0.3313 |
| LiteLLM | 49,358 | 8,614 | 1045 | 0.9128 | 0.9490 |
| DSPy | 34,854 | 2,958 | 46 | 0.8834 | 0.1961 |
| SemanticKernel | 28,055 | 4,634 | 13 | 0.8651 | 0.3378 |
| Haystack | 25,462 | 2,829 | 0 | 0.8569 | 0.2222 |
| PydanticAI | 17,534 | 2,176 | 117 | 0.8254 | 0.3154 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 138,548 | +5.61% | 21,601 | 22,954 | +6.26% |
| AutoGen | 56,243 | 58,704 | +4.38% | 8,453 | 8,861 | +4.83% |
| Mem0 | 51,132 | 57,752 | +12.95% | 5,717 | 6,600 | +15.45% |
| CrewAI | 47,278 | 52,870 | +11.83% | 6,385 | 7,381 | +15.60% |
| LlamaIndex | 48,012 | 49,929 | +3.99% | 7,093 | 7,510 | +5.88% |
| LiteLLM | 40,982 | 49,358 | +20.44% | 6,752 | 8,614 | +27.58% |
| DSPy | 33,187 | 34,854 | +5.02% | 2,728 | 2,958 | +8.43% |
| SemanticKernel | 27,567 | 28,055 | +1.77% | 4,523 | 4,634 | +2.45% |
| Haystack | 24,620 | 25,462 | +3.42% | 2,675 | 2,829 | +5.76% |
| PydanticAI | 15,824 | 17,534 | +10.81% | 1,830 | 2,176 | +18.91% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9490)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present