# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-27
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 32
**Data points**: 33

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 135,051 | 22,332 | 169 | 1.0000 | 0.4043 |
| AutoGen | 57,471 | 8,664 | 0 | 0.9277 | 0.3015 |
| Mem0 | 54,158 | 6,098 | 0 | 0.9227 | 0.2252 |
| CrewAI | 50,023 | 6,881 | 0 | 0.9159 | 0.2751 |
| LlamaIndex | 48,959 | 7,318 | 0 | 0.9141 | 0.2989 |
| LiteLLM | 44,837 | 7,589 | 1379 | 0.9067 | 0.9385 |
| DSPy | 34,016 | 2,844 | 34 | 0.8833 | 0.1820 |
| SemanticKernel | 27,788 | 4,573 | 0 | 0.8662 | 0.3291 |
| Haystack | 24,998 | 2,739 | 0 | 0.8572 | 0.2191 |
| PydanticAI | 16,663 | 1,991 | 0 | 0.8229 | 0.2390 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 135,051 | +2.94% | 21,601 | 22,332 | +3.38% |
| AutoGen | 56,243 | 57,471 | +2.18% | 8,453 | 8,664 | +2.50% |
| Mem0 | 51,132 | 54,158 | +5.92% | 5,717 | 6,098 | +6.66% |
| CrewAI | 47,278 | 50,023 | +5.81% | 6,385 | 6,881 | +7.77% |
| LlamaIndex | 48,012 | 48,959 | +1.97% | 7,093 | 7,318 | +3.17% |
| LiteLLM | 40,982 | 44,837 | +9.41% | 6,752 | 7,589 | +12.40% |
| DSPy | 33,187 | 34,016 | +2.50% | 2,728 | 2,844 | +4.25% |
| SemanticKernel | 27,567 | 27,788 | +0.80% | 4,523 | 4,573 | +1.11% |
| Haystack | 24,620 | 24,998 | +1.54% | 2,675 | 2,739 | +2.39% |
| PydanticAI | 15,824 | 16,663 | +5.30% | 1,830 | 1,991 | +8.80% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9385)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present