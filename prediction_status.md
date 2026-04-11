# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-11
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 16
**Data points**: 17

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 133,114 | 21,982 | 219 | 1.0000 | 0.4167 |
| AutoGen | 56,948 | 8,564 | 0 | 0.9280 | 0.3008 |
| Mem0 | 52,607 | 5,903 | 0 | 0.9213 | 0.2244 |
| CrewAI | 48,567 | 6,629 | 0 | 0.9145 | 0.2730 |
| LlamaIndex | 48,487 | 7,188 | 0 | 0.9144 | 0.2965 |
| LiteLLM | 42,896 | 7,156 | 1520 | 0.9040 | 0.9336 |
| DSPy | 33,592 | 2,780 | 18 | 0.8833 | 0.1726 |
| SemanticKernel | 27,683 | 4,543 | 0 | 0.8669 | 0.3282 |
| Haystack | 24,802 | 2,705 | 0 | 0.8576 | 0.2181 |
| PydanticAI | 16,261 | 1,901 | 0 | 0.8218 | 0.2338 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 133,114 | +1.47% | 21,601 | 21,982 | +1.76% |
| AutoGen | 56,243 | 56,948 | +1.25% | 8,453 | 8,564 | +1.31% |
| Mem0 | 51,132 | 52,607 | +2.88% | 5,717 | 5,903 | +3.25% |
| CrewAI | 47,278 | 48,567 | +2.73% | 6,385 | 6,629 | +3.82% |
| LlamaIndex | 48,012 | 48,487 | +0.99% | 7,093 | 7,188 | +1.34% |
| LiteLLM | 40,982 | 42,896 | +4.67% | 6,752 | 7,156 | +5.98% |
| DSPy | 33,187 | 33,592 | +1.22% | 2,728 | 2,780 | +1.91% |
| SemanticKernel | 27,567 | 27,683 | +0.42% | 4,523 | 4,543 | +0.44% |
| Haystack | 24,620 | 24,802 | +0.74% | 2,675 | 2,705 | +1.12% |
| PydanticAI | 15,824 | 16,261 | +2.76% | 1,830 | 1,901 | +3.88% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9336)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present