# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-07-06
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 102
**Data points**: 103

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 141,051 | 23,441 | 219 | 1.0000 | 0.4907 |
| Mem0 | 60,173 | 6,981 | 152 | 0.9282 | 0.3419 |
| AutoGen | 59,517 | 8,961 | 0 | 0.9272 | 0.3011 |
| CrewAI | 54,987 | 7,723 | 0 | 0.9206 | 0.2809 |
| LiteLLM | 52,717 | 9,507 | 830 | 0.9170 | 0.9607 |
| LlamaIndex | 50,675 | 7,695 | 0 | 0.9137 | 0.3037 |
| DSPy | 35,865 | 3,062 | 0 | 0.8845 | 0.1708 |
| SemanticKernel | 28,265 | 4,671 | 0 | 0.8644 | 0.3305 |
| Haystack | 25,833 | 2,902 | 0 | 0.8568 | 0.2247 |
| PydanticAI | 18,242 | 2,308 | 0 | 0.8275 | 0.2530 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 141,051 | +7.52% | 21,601 | 23,441 | +8.52% |
| Mem0 | 51,132 | 60,173 | +17.68% | 5,717 | 6,981 | +22.11% |
| AutoGen | 56,243 | 59,517 | +5.82% | 8,453 | 8,961 | +6.01% |
| CrewAI | 47,278 | 54,987 | +16.31% | 6,385 | 7,723 | +20.96% |
| LiteLLM | 40,982 | 52,717 | +28.63% | 6,752 | 9,507 | +40.80% |
| LlamaIndex | 48,012 | 50,675 | +5.55% | 7,093 | 7,695 | +8.49% |
| DSPy | 33,187 | 35,865 | +8.07% | 2,728 | 3,062 | +12.24% |
| SemanticKernel | 27,567 | 28,265 | +2.53% | 4,523 | 4,671 | +3.27% |
| Haystack | 24,620 | 25,833 | +4.93% | 2,675 | 2,902 | +8.49% |
| PydanticAI | 15,824 | 18,242 | +15.28% | 1,830 | 2,308 | +26.12% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9607)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present