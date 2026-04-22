# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-22
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 27
**Data points**: 28

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 134,433 | 22,214 | 191 | 1.0000 | 0.4148 |
| AutoGen | 57,313 | 8,634 | 0 | 0.9278 | 0.3013 |
| Mem0 | 53,759 | 6,031 | 0 | 0.9224 | 0.2244 |
| CrewAI | 49,485 | 6,781 | 0 | 0.9154 | 0.2741 |
| LlamaIndex | 48,791 | 7,279 | 0 | 0.9142 | 0.2984 |
| LiteLLM | 44,215 | 7,448 | 1359 | 0.9058 | 0.9369 |
| DSPy | 33,909 | 2,825 | 0 | 0.8834 | 0.1666 |
| SemanticKernel | 27,752 | 4,565 | 0 | 0.8664 | 0.3290 |
| Haystack | 24,946 | 2,730 | 0 | 0.8574 | 0.2189 |
| PydanticAI | 16,542 | 1,960 | 0 | 0.8226 | 0.2370 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 134,433 | +2.47% | 21,601 | 22,214 | +2.84% |
| AutoGen | 56,243 | 57,313 | +1.90% | 8,453 | 8,634 | +2.14% |
| Mem0 | 51,132 | 53,759 | +5.14% | 5,717 | 6,031 | +5.49% |
| CrewAI | 47,278 | 49,485 | +4.67% | 6,385 | 6,781 | +6.20% |
| LlamaIndex | 48,012 | 48,791 | +1.62% | 7,093 | 7,279 | +2.62% |
| LiteLLM | 40,982 | 44,215 | +7.89% | 6,752 | 7,448 | +10.31% |
| DSPy | 33,187 | 33,909 | +2.18% | 2,728 | 2,825 | +3.56% |
| SemanticKernel | 27,567 | 27,752 | +0.67% | 4,523 | 4,565 | +0.93% |
| Haystack | 24,620 | 24,946 | +1.32% | 2,675 | 2,730 | +2.06% |
| PydanticAI | 15,824 | 16,542 | +4.54% | 1,830 | 1,960 | +7.10% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9369)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present