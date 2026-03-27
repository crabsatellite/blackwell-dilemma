# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-03-27
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 1
**Data points**: 2

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 131,264 | 21,615 | 226 | 1.0000 | 0.3811 |
| AutoGen | 56,276 | 8,454 | 2 | 0.9281 | 0.3009 |
| Mem0 | 51,191 | 5,728 | 115 | 0.9201 | 0.2501 |
| LlamaIndex | 48,041 | 7,096 | 0 | 0.9147 | 0.2954 |
| CrewAI | 47,322 | 6,398 | 127 | 0.9134 | 0.2995 |
| LiteLLM | 41,110 | 6,774 | 2618 | 0.9015 | 0.9296 |
| DSPy | 33,206 | 2,731 | 42 | 0.8834 | 0.1741 |
| SemanticKernel | 27,570 | 4,526 | 37 | 0.8676 | 0.3368 |
| Haystack | 24,630 | 2,674 | 161 | 0.8580 | 0.2540 |
| PydanticAI | 15,849 | 1,837 | 72 | 0.8206 | 0.2483 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 131,264 | +0.06% | 21,601 | 21,615 | +0.06% |
| AutoGen | 56,243 | 56,276 | +0.06% | 8,453 | 8,454 | +0.01% |
| Mem0 | 51,132 | 51,191 | +0.12% | 5,717 | 5,728 | +0.19% |
| LlamaIndex | 48,012 | 48,041 | +0.06% | 7,093 | 7,096 | +0.04% |
| CrewAI | 47,278 | 47,322 | +0.09% | 6,385 | 6,398 | +0.20% |
| LiteLLM | 40,982 | 41,110 | +0.31% | 6,752 | 6,774 | +0.33% |
| DSPy | 33,187 | 33,206 | +0.06% | 2,728 | 2,731 | +0.11% |
| SemanticKernel | 27,567 | 27,570 | +0.01% | 4,523 | 4,526 | +0.07% |
| Haystack | 24,620 | 24,630 | +0.04% | 2,675 | 2,674 | -0.04% |
| PydanticAI | 15,824 | 15,849 | +0.16% | 1,830 | 1,837 | +0.38% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9296)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present