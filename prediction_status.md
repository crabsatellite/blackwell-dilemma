# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-07-03
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 99
**Data points**: 100

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 140,797 | 23,374 | 309 | 1.0000 | 0.5258 |
| Mem0 | 59,993 | 6,955 | 197 | 0.9280 | 0.3554 |
| AutoGen | 59,452 | 8,950 | 0 | 0.9273 | 0.3011 |
| CrewAI | 54,808 | 7,683 | 130 | 0.9204 | 0.3619 |
| LiteLLM | 52,475 | 9,414 | 957 | 0.9167 | 0.9588 |
| LlamaIndex | 50,613 | 7,675 | 33 | 0.9137 | 0.3240 |
| DSPy | 35,777 | 3,050 | 12 | 0.8844 | 0.1780 |
| SemanticKernel | 28,249 | 4,669 | 35 | 0.8645 | 0.3525 |
| Haystack | 25,817 | 2,901 | 0 | 0.8569 | 0.2247 |
| PydanticAI | 18,173 | 2,294 | 170 | 0.8273 | 0.3590 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 140,797 | +7.32% | 21,601 | 23,374 | +8.21% |
| Mem0 | 51,132 | 59,993 | +17.33% | 5,717 | 6,955 | +21.65% |
| AutoGen | 56,243 | 59,452 | +5.71% | 8,453 | 8,950 | +5.88% |
| CrewAI | 47,278 | 54,808 | +15.93% | 6,385 | 7,683 | +20.33% |
| LiteLLM | 40,982 | 52,475 | +28.04% | 6,752 | 9,414 | +39.43% |
| LlamaIndex | 48,012 | 50,613 | +5.42% | 7,093 | 7,675 | +8.21% |
| DSPy | 33,187 | 35,777 | +7.80% | 2,728 | 3,050 | +11.80% |
| SemanticKernel | 27,567 | 28,249 | +2.47% | 4,523 | 4,669 | +3.23% |
| Haystack | 24,620 | 25,817 | +4.86% | 2,675 | 2,901 | +8.45% |
| PydanticAI | 15,824 | 18,173 | +14.84% | 1,830 | 2,294 | +25.36% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9588)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present