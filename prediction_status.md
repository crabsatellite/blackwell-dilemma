# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-12
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 78
**Data points**: 79

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 139,097 | 23,052 | 257 | 1.0000 | 0.4863 |
| AutoGen | 58,893 | 8,888 | 0 | 0.9274 | 0.3018 |
| Mem0 | 58,400 | 6,707 | 75 | 0.9267 | 0.2749 |
| CrewAI | 53,304 | 7,458 | 0 | 0.9190 | 0.2798 |
| LiteLLM | 50,122 | 8,815 | 996 | 0.9138 | 0.9517 |
| LlamaIndex | 50,091 | 7,538 | 0 | 0.9138 | 0.3010 |
| DSPy | 34,996 | 2,974 | 0 | 0.8835 | 0.1700 |
| SemanticKernel | 28,107 | 4,641 | 0 | 0.8650 | 0.3302 |
| Haystack | 25,545 | 2,840 | 0 | 0.8569 | 0.2224 |
| PydanticAI | 17,717 | 2,208 | 0 | 0.8260 | 0.2493 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 139,097 | +6.03% | 21,601 | 23,052 | +6.72% |
| AutoGen | 56,243 | 58,893 | +4.71% | 8,453 | 8,888 | +5.15% |
| Mem0 | 51,132 | 58,400 | +14.21% | 5,717 | 6,707 | +17.32% |
| CrewAI | 47,278 | 53,304 | +12.75% | 6,385 | 7,458 | +16.81% |
| LiteLLM | 40,982 | 50,122 | +22.30% | 6,752 | 8,815 | +30.55% |
| LlamaIndex | 48,012 | 50,091 | +4.33% | 7,093 | 7,538 | +6.27% |
| DSPy | 33,187 | 34,996 | +5.45% | 2,728 | 2,974 | +9.02% |
| SemanticKernel | 27,567 | 28,107 | +1.96% | 4,523 | 4,641 | +2.61% |
| Haystack | 24,620 | 25,545 | +3.76% | 2,675 | 2,840 | +6.17% |
| PydanticAI | 15,824 | 17,717 | +11.96% | 1,830 | 2,208 | +20.66% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9517)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present