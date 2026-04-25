# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-25
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 30
**Data points**: 31

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 134,818 | 22,285 | 217 | 1.0000 | 0.4107 |
| AutoGen | 57,411 | 8,653 | 0 | 0.9277 | 0.3014 |
| Mem0 | 54,013 | 6,077 | 0 | 0.9226 | 0.2250 |
| CrewAI | 49,826 | 6,837 | 0 | 0.9157 | 0.2744 |
| LlamaIndex | 48,897 | 7,305 | 0 | 0.9141 | 0.2988 |
| LiteLLM | 44,643 | 7,547 | 1625 | 0.9064 | 0.9381 |
| DSPy | 33,990 | 2,841 | 0 | 0.8833 | 0.1672 |
| SemanticKernel | 27,777 | 4,571 | 0 | 0.8663 | 0.3291 |
| Haystack | 24,979 | 2,732 | 0 | 0.8573 | 0.2187 |
| PydanticAI | 16,609 | 1,981 | 0 | 0.8227 | 0.2385 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 134,818 | +2.77% | 21,601 | 22,285 | +3.17% |
| AutoGen | 56,243 | 57,411 | +2.08% | 8,453 | 8,653 | +2.37% |
| Mem0 | 51,132 | 54,013 | +5.63% | 5,717 | 6,077 | +6.30% |
| CrewAI | 47,278 | 49,826 | +5.39% | 6,385 | 6,837 | +7.08% |
| LlamaIndex | 48,012 | 48,897 | +1.84% | 7,093 | 7,305 | +2.99% |
| LiteLLM | 40,982 | 44,643 | +8.93% | 6,752 | 7,547 | +11.77% |
| DSPy | 33,187 | 33,990 | +2.42% | 2,728 | 2,841 | +4.14% |
| SemanticKernel | 27,567 | 27,777 | +0.76% | 4,523 | 4,571 | +1.06% |
| Haystack | 24,620 | 24,979 | +1.46% | 2,675 | 2,732 | +2.13% |
| PydanticAI | 15,824 | 16,609 | +4.96% | 1,830 | 1,981 | +8.25% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9381)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present