# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-24
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 29
**Data points**: 30

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 134,729 | 22,268 | 205 | 1.0000 | 0.4110 |
| AutoGen | 57,379 | 8,648 | 0 | 0.9277 | 0.3014 |
| Mem0 | 53,944 | 6,065 | 0 | 0.9225 | 0.2249 |
| CrewAI | 49,746 | 6,824 | 0 | 0.9156 | 0.2744 |
| LlamaIndex | 48,872 | 7,295 | 0 | 0.9141 | 0.2985 |
| LiteLLM | 44,514 | 7,520 | 1529 | 0.9062 | 0.9379 |
| DSPy | 33,968 | 2,836 | 0 | 0.8833 | 0.1670 |
| SemanticKernel | 27,766 | 4,570 | 0 | 0.8663 | 0.3292 |
| Haystack | 24,968 | 2,733 | 0 | 0.8573 | 0.2189 |
| PydanticAI | 16,588 | 1,973 | 127 | 0.8227 | 0.2877 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 134,729 | +2.70% | 21,601 | 22,268 | +3.09% |
| AutoGen | 56,243 | 57,379 | +2.02% | 8,453 | 8,648 | +2.31% |
| Mem0 | 51,132 | 53,944 | +5.50% | 5,717 | 6,065 | +6.09% |
| CrewAI | 47,278 | 49,746 | +5.22% | 6,385 | 6,824 | +6.88% |
| LlamaIndex | 48,012 | 48,872 | +1.79% | 7,093 | 7,295 | +2.85% |
| LiteLLM | 40,982 | 44,514 | +8.62% | 6,752 | 7,520 | +11.37% |
| DSPy | 33,187 | 33,968 | +2.35% | 2,728 | 2,836 | +3.96% |
| SemanticKernel | 27,567 | 27,766 | +0.72% | 4,523 | 4,570 | +1.04% |
| Haystack | 24,620 | 24,968 | +1.41% | 2,675 | 2,733 | +2.17% |
| PydanticAI | 15,824 | 16,588 | +4.83% | 1,830 | 1,973 | +7.81% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9379)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present