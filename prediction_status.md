# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-03
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 38
**Data points**: 39

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 135,656 | 22,429 | 184 | 1.0000 | 0.3949 |
| AutoGen | 57,663 | 8,700 | 0 | 0.9276 | 0.3018 |
| Mem0 | 54,627 | 6,175 | 0 | 0.9230 | 0.2261 |
| CrewAI | 50,501 | 6,965 | 0 | 0.9164 | 0.2758 |
| LlamaIndex | 49,102 | 7,346 | 0 | 0.9140 | 0.2992 |
| LiteLLM | 45,517 | 7,734 | 1719 | 0.9076 | 0.9398 |
| DSPy | 34,163 | 2,867 | 0 | 0.8833 | 0.1678 |
| SemanticKernel | 27,824 | 4,580 | 0 | 0.8659 | 0.3292 |
| Haystack | 25,060 | 2,759 | 0 | 0.8571 | 0.2202 |
| PydanticAI | 16,810 | 2,014 | 0 | 0.8233 | 0.2396 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 135,656 | +3.40% | 21,601 | 22,429 | +3.83% |
| AutoGen | 56,243 | 57,663 | +2.52% | 8,453 | 8,700 | +2.92% |
| Mem0 | 51,132 | 54,627 | +6.84% | 5,717 | 6,175 | +8.01% |
| CrewAI | 47,278 | 50,501 | +6.82% | 6,385 | 6,965 | +9.08% |
| LlamaIndex | 48,012 | 49,102 | +2.27% | 7,093 | 7,346 | +3.57% |
| LiteLLM | 40,982 | 45,517 | +11.07% | 6,752 | 7,734 | +14.54% |
| DSPy | 33,187 | 34,163 | +2.94% | 2,728 | 2,867 | +5.10% |
| SemanticKernel | 27,567 | 27,824 | +0.93% | 4,523 | 4,580 | +1.26% |
| Haystack | 24,620 | 25,060 | +1.79% | 2,675 | 2,759 | +3.14% |
| PydanticAI | 15,824 | 16,810 | +6.23% | 1,830 | 2,014 | +10.05% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9398)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present