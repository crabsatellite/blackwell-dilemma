# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-06
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 41
**Data points**: 42

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 135,890 | 22,463 | 205 | 1.0000 | 0.3907 |
| AutoGen | 57,737 | 8,716 | 0 | 0.9276 | 0.3019 |
| Mem0 | 54,861 | 6,212 | 0 | 0.9233 | 0.2265 |
| CrewAI | 50,722 | 6,999 | 0 | 0.9166 | 0.2760 |
| LlamaIndex | 49,158 | 7,363 | 0 | 0.9140 | 0.2996 |
| LiteLLM | 45,809 | 7,799 | 2046 | 0.9080 | 0.9405 |
| DSPy | 34,221 | 2,875 | 0 | 0.8833 | 0.1680 |
| SemanticKernel | 27,843 | 4,583 | 0 | 0.8659 | 0.3292 |
| Haystack | 25,094 | 2,764 | 0 | 0.8571 | 0.2203 |
| PydanticAI | 16,859 | 2,026 | 0 | 0.8234 | 0.2403 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 135,890 | +3.58% | 21,601 | 22,463 | +3.99% |
| AutoGen | 56,243 | 57,737 | +2.66% | 8,453 | 8,716 | +3.11% |
| Mem0 | 51,132 | 54,861 | +7.29% | 5,717 | 6,212 | +8.66% |
| CrewAI | 47,278 | 50,722 | +7.28% | 6,385 | 6,999 | +9.62% |
| LlamaIndex | 48,012 | 49,158 | +2.39% | 7,093 | 7,363 | +3.81% |
| LiteLLM | 40,982 | 45,809 | +11.78% | 6,752 | 7,799 | +15.51% |
| DSPy | 33,187 | 34,221 | +3.12% | 2,728 | 2,875 | +5.39% |
| SemanticKernel | 27,567 | 27,843 | +1.00% | 4,523 | 4,583 | +1.33% |
| Haystack | 24,620 | 25,094 | +1.93% | 2,675 | 2,764 | +3.33% |
| PydanticAI | 15,824 | 16,859 | +6.54% | 1,830 | 2,026 | +10.71% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9405)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present