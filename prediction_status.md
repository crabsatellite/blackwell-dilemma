# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-07-07
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 103
**Data points**: 104

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 141,147 | 23,459 | 223 | 1.0000 | 0.4841 |
| Mem0 | 60,270 | 6,991 | 0 | 0.9282 | 0.2320 |
| AutoGen | 59,542 | 8,962 | 0 | 0.9272 | 0.3010 |
| CrewAI | 55,048 | 7,732 | 0 | 0.9206 | 0.2809 |
| LiteLLM | 52,812 | 9,529 | 882 | 0.9171 | 0.9609 |
| LlamaIndex | 50,698 | 7,701 | 0 | 0.9136 | 0.3038 |
| DSPy | 35,894 | 3,063 | 0 | 0.8845 | 0.1707 |
| SemanticKernel | 28,276 | 4,670 | 0 | 0.8644 | 0.3303 |
| Haystack | 25,840 | 2,901 | 0 | 0.8568 | 0.2245 |
| PydanticAI | 18,252 | 2,312 | 0 | 0.8275 | 0.2533 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 141,147 | +7.59% | 21,601 | 23,459 | +8.60% |
| Mem0 | 51,132 | 60,270 | +17.87% | 5,717 | 6,991 | +22.28% |
| AutoGen | 56,243 | 59,542 | +5.87% | 8,453 | 8,962 | +6.02% |
| CrewAI | 47,278 | 55,048 | +16.43% | 6,385 | 7,732 | +21.10% |
| LiteLLM | 40,982 | 52,812 | +28.87% | 6,752 | 9,529 | +41.13% |
| LlamaIndex | 48,012 | 50,698 | +5.59% | 7,093 | 7,701 | +8.57% |
| DSPy | 33,187 | 35,894 | +8.16% | 2,728 | 3,063 | +12.28% |
| SemanticKernel | 27,567 | 28,276 | +2.57% | 4,523 | 4,670 | +3.25% |
| Haystack | 24,620 | 25,840 | +4.96% | 2,675 | 2,901 | +8.45% |
| PydanticAI | 15,824 | 18,252 | +15.34% | 1,830 | 2,312 | +26.34% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9609)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present