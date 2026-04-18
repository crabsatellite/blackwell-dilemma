# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-18
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 23
**Data points**: 24

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 133,913 | 22,127 | 232 | 1.0000 | 0.4316 |
| AutoGen | 57,177 | 8,611 | 0 | 0.9279 | 0.3012 |
| Mem0 | 53,381 | 5,983 | 0 | 0.9221 | 0.2242 |
| CrewAI | 49,134 | 6,713 | 0 | 0.9151 | 0.2733 |
| LlamaIndex | 48,657 | 7,214 | 0 | 0.9142 | 0.2965 |
| LiteLLM | 43,734 | 7,326 | 1377 | 0.9052 | 0.9350 |
| DSPy | 33,776 | 2,803 | 0 | 0.8833 | 0.1660 |
| SemanticKernel | 27,729 | 4,556 | 0 | 0.8666 | 0.3286 |
| Haystack | 24,882 | 2,721 | 0 | 0.8574 | 0.2187 |
| PydanticAI | 16,440 | 1,954 | 0 | 0.8223 | 0.2377 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 133,913 | +2.08% | 21,601 | 22,127 | +2.44% |
| AutoGen | 56,243 | 57,177 | +1.66% | 8,453 | 8,611 | +1.87% |
| Mem0 | 51,132 | 53,381 | +4.40% | 5,717 | 5,983 | +4.65% |
| CrewAI | 47,278 | 49,134 | +3.93% | 6,385 | 6,713 | +5.14% |
| LlamaIndex | 48,012 | 48,657 | +1.34% | 7,093 | 7,214 | +1.71% |
| LiteLLM | 40,982 | 43,734 | +6.72% | 6,752 | 7,326 | +8.50% |
| DSPy | 33,187 | 33,776 | +1.77% | 2,728 | 2,803 | +2.75% |
| SemanticKernel | 27,567 | 27,729 | +0.59% | 4,523 | 4,556 | +0.73% |
| Haystack | 24,620 | 24,882 | +1.06% | 2,675 | 2,721 | +1.72% |
| PydanticAI | 15,824 | 16,440 | +3.89% | 1,830 | 1,954 | +6.78% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9350)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present