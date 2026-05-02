# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-02
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 37
**Data points**: 38

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 135,613 | 22,407 | 226 | 1.0000 | 0.3951 |
| AutoGen | 57,649 | 8,692 | 0 | 0.9276 | 0.3015 |
| Mem0 | 54,559 | 6,164 | 0 | 0.9230 | 0.2260 |
| CrewAI | 50,451 | 6,951 | 0 | 0.9163 | 0.2756 |
| LlamaIndex | 49,090 | 7,339 | 0 | 0.9140 | 0.2990 |
| LiteLLM | 45,451 | 7,713 | 2099 | 0.9075 | 0.9394 |
| DSPy | 34,148 | 2,865 | 0 | 0.8833 | 0.1678 |
| SemanticKernel | 27,827 | 4,578 | 0 | 0.8660 | 0.3290 |
| Haystack | 25,051 | 2,755 | 0 | 0.8571 | 0.2200 |
| PydanticAI | 16,792 | 2,010 | 0 | 0.8232 | 0.2394 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 135,613 | +3.37% | 21,601 | 22,407 | +3.73% |
| AutoGen | 56,243 | 57,649 | +2.50% | 8,453 | 8,692 | +2.83% |
| Mem0 | 51,132 | 54,559 | +6.70% | 5,717 | 6,164 | +7.82% |
| CrewAI | 47,278 | 50,451 | +6.71% | 6,385 | 6,951 | +8.86% |
| LlamaIndex | 48,012 | 49,090 | +2.25% | 7,093 | 7,339 | +3.47% |
| LiteLLM | 40,982 | 45,451 | +10.90% | 6,752 | 7,713 | +14.23% |
| DSPy | 33,187 | 34,148 | +2.90% | 2,728 | 2,865 | +5.02% |
| SemanticKernel | 27,567 | 27,827 | +0.94% | 4,523 | 4,578 | +1.22% |
| Haystack | 24,620 | 25,051 | +1.75% | 2,675 | 2,755 | +2.99% |
| PydanticAI | 15,824 | 16,792 | +6.12% | 1,830 | 2,010 | +9.84% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9394)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present