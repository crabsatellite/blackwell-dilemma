# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-23
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 28
**Data points**: 29

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 134,568 | 22,239 | 198 | 1.0000 | 0.4132 |
| AutoGen | 57,349 | 8,642 | 0 | 0.9278 | 0.3014 |
| Mem0 | 53,853 | 6,048 | 0 | 0.9225 | 0.2246 |
| CrewAI | 49,610 | 6,803 | 0 | 0.9155 | 0.2743 |
| LlamaIndex | 48,829 | 7,288 | 0 | 0.9142 | 0.2985 |
| LiteLLM | 44,350 | 7,491 | 1437 | 0.9060 | 0.9378 |
| DSPy | 33,934 | 2,831 | 0 | 0.8833 | 0.1669 |
| SemanticKernel | 27,761 | 4,568 | 0 | 0.8663 | 0.3291 |
| Haystack | 24,955 | 2,731 | 0 | 0.8573 | 0.2189 |
| PydanticAI | 16,562 | 1,966 | 0 | 0.8226 | 0.2374 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 134,568 | +2.57% | 21,601 | 22,239 | +2.95% |
| AutoGen | 56,243 | 57,349 | +1.97% | 8,453 | 8,642 | +2.24% |
| Mem0 | 51,132 | 53,853 | +5.32% | 5,717 | 6,048 | +5.79% |
| CrewAI | 47,278 | 49,610 | +4.93% | 6,385 | 6,803 | +6.55% |
| LlamaIndex | 48,012 | 48,829 | +1.70% | 7,093 | 7,288 | +2.75% |
| LiteLLM | 40,982 | 44,350 | +8.22% | 6,752 | 7,491 | +10.94% |
| DSPy | 33,187 | 33,934 | +2.25% | 2,728 | 2,831 | +3.78% |
| SemanticKernel | 27,567 | 27,761 | +0.70% | 4,523 | 4,568 | +0.99% |
| Haystack | 24,620 | 24,955 | +1.36% | 2,675 | 2,731 | +2.09% |
| PydanticAI | 15,824 | 16,562 | +4.66% | 1,830 | 1,966 | +7.43% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9378)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present