# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-07-01
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 97
**Data points**: 98

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 140,611 | 23,355 | 297 | 1.0000 | 0.5387 |
| Mem0 | 59,821 | 6,932 | 185 | 0.9279 | 0.3604 |
| AutoGen | 59,389 | 8,944 | 0 | 0.9273 | 0.3012 |
| CrewAI | 54,669 | 7,662 | 123 | 0.9203 | 0.3658 |
| LiteLLM | 52,196 | 9,343 | 863 | 0.9164 | 0.9580 |
| LlamaIndex | 50,549 | 7,662 | 14 | 0.9137 | 0.3129 |
| DSPy | 35,700 | 3,035 | 0 | 0.8844 | 0.1700 |
| SemanticKernel | 28,231 | 4,665 | 0 | 0.8646 | 0.3305 |
| Haystack | 25,792 | 2,898 | 0 | 0.8569 | 0.2247 |
| PydanticAI | 18,113 | 2,283 | 0 | 0.8271 | 0.2521 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 140,611 | +7.18% | 21,601 | 23,355 | +8.12% |
| Mem0 | 51,132 | 59,821 | +16.99% | 5,717 | 6,932 | +21.25% |
| AutoGen | 56,243 | 59,389 | +5.59% | 8,453 | 8,944 | +5.81% |
| CrewAI | 47,278 | 54,669 | +15.63% | 6,385 | 7,662 | +20.00% |
| LiteLLM | 40,982 | 52,196 | +27.36% | 6,752 | 9,343 | +38.37% |
| LlamaIndex | 48,012 | 50,549 | +5.28% | 7,093 | 7,662 | +8.02% |
| DSPy | 33,187 | 35,700 | +7.57% | 2,728 | 3,035 | +11.25% |
| SemanticKernel | 27,567 | 28,231 | +2.41% | 4,523 | 4,665 | +3.14% |
| Haystack | 24,620 | 25,792 | +4.76% | 2,675 | 2,898 | +8.34% |
| PydanticAI | 15,824 | 18,113 | +14.47% | 1,830 | 2,283 | +24.75% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9580)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present