# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-19
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 24
**Data points**: 25

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 133,999 | 22,142 | 175 | 1.0000 | 0.4132 |
| AutoGen | 57,198 | 8,622 | 0 | 0.9279 | 0.3015 |
| Mem0 | 53,461 | 5,994 | 0 | 0.9222 | 0.2242 |
| CrewAI | 49,196 | 6,728 | 0 | 0.9151 | 0.2735 |
| LlamaIndex | 48,678 | 7,220 | 0 | 0.9142 | 0.2966 |
| LiteLLM | 43,828 | 7,347 | 1269 | 0.9053 | 0.9353 |
| DSPy | 33,797 | 2,805 | 0 | 0.8833 | 0.1660 |
| SemanticKernel | 27,740 | 4,556 | 0 | 0.8666 | 0.3285 |
| Haystack | 24,896 | 2,724 | 0 | 0.8574 | 0.2188 |
| PydanticAI | 16,460 | 1,953 | 0 | 0.8224 | 0.2373 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 133,999 | +2.14% | 21,601 | 22,142 | +2.50% |
| AutoGen | 56,243 | 57,198 | +1.70% | 8,453 | 8,622 | +2.00% |
| Mem0 | 51,132 | 53,461 | +4.55% | 5,717 | 5,994 | +4.85% |
| CrewAI | 47,278 | 49,196 | +4.06% | 6,385 | 6,728 | +5.37% |
| LlamaIndex | 48,012 | 48,678 | +1.39% | 7,093 | 7,220 | +1.79% |
| LiteLLM | 40,982 | 43,828 | +6.94% | 6,752 | 7,347 | +8.81% |
| DSPy | 33,187 | 33,797 | +1.84% | 2,728 | 2,805 | +2.82% |
| SemanticKernel | 27,567 | 27,740 | +0.63% | 4,523 | 4,556 | +0.73% |
| Haystack | 24,620 | 24,896 | +1.12% | 2,675 | 2,724 | +1.83% |
| PydanticAI | 15,824 | 16,460 | +4.02% | 1,830 | 1,953 | +6.72% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9353)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present