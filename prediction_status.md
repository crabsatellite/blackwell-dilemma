# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-07
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 42
**Data points**: 43

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 135,988 | 22,481 | 205 | 1.0000 | 0.3899 |
| AutoGen | 57,768 | 8,719 | 0 | 0.9276 | 0.3019 |
| Mem0 | 54,966 | 6,227 | 0 | 0.9234 | 0.2266 |
| CrewAI | 50,782 | 7,012 | 0 | 0.9167 | 0.2762 |
| LlamaIndex | 49,181 | 7,365 | 0 | 0.9140 | 0.2995 |
| LiteLLM | 45,979 | 7,825 | 2076 | 0.9083 | 0.9404 |
| DSPy | 34,249 | 2,878 | 0 | 0.8833 | 0.1681 |
| SemanticKernel | 27,850 | 4,586 | 0 | 0.8658 | 0.3293 |
| Haystack | 25,103 | 2,767 | 0 | 0.8571 | 0.2205 |
| PydanticAI | 16,878 | 2,030 | 0 | 0.8235 | 0.2405 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 135,988 | +3.66% | 21,601 | 22,481 | +4.07% |
| AutoGen | 56,243 | 57,768 | +2.71% | 8,453 | 8,719 | +3.15% |
| Mem0 | 51,132 | 54,966 | +7.50% | 5,717 | 6,227 | +8.92% |
| CrewAI | 47,278 | 50,782 | +7.41% | 6,385 | 7,012 | +9.82% |
| LlamaIndex | 48,012 | 49,181 | +2.43% | 7,093 | 7,365 | +3.83% |
| LiteLLM | 40,982 | 45,979 | +12.19% | 6,752 | 7,825 | +15.89% |
| DSPy | 33,187 | 34,249 | +3.20% | 2,728 | 2,878 | +5.50% |
| SemanticKernel | 27,567 | 27,850 | +1.03% | 4,523 | 4,586 | +1.39% |
| Haystack | 24,620 | 25,103 | +1.96% | 2,675 | 2,767 | +3.44% |
| PydanticAI | 15,824 | 16,878 | +6.66% | 1,830 | 2,030 | +10.93% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9404)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present