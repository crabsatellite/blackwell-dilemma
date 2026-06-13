# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-13
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 79
**Data points**: 80

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 139,164 | 23,070 | 282 | 1.0000 | 0.4921 |
| AutoGen | 58,913 | 8,896 | 0 | 0.9274 | 0.3020 |
| Mem0 | 58,463 | 6,714 | 88 | 0.9268 | 0.2798 |
| CrewAI | 53,396 | 7,470 | 0 | 0.9191 | 0.2798 |
| LiteLLM | 50,217 | 8,841 | 1054 | 0.9139 | 0.9521 |
| LlamaIndex | 50,100 | 7,549 | 53 | 0.9137 | 0.3315 |
| DSPy | 35,001 | 2,975 | 0 | 0.8835 | 0.1700 |
| SemanticKernel | 28,109 | 4,645 | 0 | 0.8649 | 0.3305 |
| Haystack | 25,559 | 2,845 | 126 | 0.8569 | 0.2943 |
| PydanticAI | 17,732 | 2,212 | 0 | 0.8260 | 0.2495 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 139,164 | +6.08% | 21,601 | 23,070 | +6.80% |
| AutoGen | 56,243 | 58,913 | +4.75% | 8,453 | 8,896 | +5.24% |
| Mem0 | 51,132 | 58,463 | +14.34% | 5,717 | 6,714 | +17.44% |
| CrewAI | 47,278 | 53,396 | +12.94% | 6,385 | 7,470 | +16.99% |
| LiteLLM | 40,982 | 50,217 | +22.53% | 6,752 | 8,841 | +30.94% |
| LlamaIndex | 48,012 | 50,100 | +4.35% | 7,093 | 7,549 | +6.43% |
| DSPy | 33,187 | 35,001 | +5.47% | 2,728 | 2,975 | +9.05% |
| SemanticKernel | 27,567 | 28,109 | +1.97% | 4,523 | 4,645 | +2.70% |
| Haystack | 24,620 | 25,559 | +3.81% | 2,675 | 2,845 | +6.36% |
| PydanticAI | 15,824 | 17,732 | +12.06% | 1,830 | 2,212 | +20.87% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9521)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present