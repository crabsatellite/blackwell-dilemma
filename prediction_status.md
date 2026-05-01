# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-01
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 36
**Data points**: 37

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 135,535 | 22,397 | 201 | 1.0000 | 0.4029 |
| AutoGen | 57,618 | 8,687 | 0 | 0.9276 | 0.3015 |
| Mem0 | 54,513 | 6,153 | 0 | 0.9229 | 0.2257 |
| CrewAI | 50,393 | 6,941 | 170 | 0.9163 | 0.3367 |
| LlamaIndex | 49,070 | 7,337 | 0 | 0.9140 | 0.2990 |
| LiteLLM | 45,370 | 7,697 | 1666 | 0.9074 | 0.9393 |
| DSPy | 34,124 | 2,859 | 49 | 0.8833 | 0.1852 |
| SemanticKernel | 27,822 | 4,579 | 0 | 0.8660 | 0.3292 |
| Haystack | 25,040 | 2,754 | 0 | 0.8571 | 0.2200 |
| PydanticAI | 16,765 | 2,004 | 0 | 0.8231 | 0.2391 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 135,535 | +3.31% | 21,601 | 22,397 | +3.69% |
| AutoGen | 56,243 | 57,618 | +2.44% | 8,453 | 8,687 | +2.77% |
| Mem0 | 51,132 | 54,513 | +6.61% | 5,717 | 6,153 | +7.63% |
| CrewAI | 47,278 | 50,393 | +6.59% | 6,385 | 6,941 | +8.71% |
| LlamaIndex | 48,012 | 49,070 | +2.20% | 7,093 | 7,337 | +3.44% |
| LiteLLM | 40,982 | 45,370 | +10.71% | 6,752 | 7,697 | +14.00% |
| DSPy | 33,187 | 34,124 | +2.82% | 2,728 | 2,859 | +4.80% |
| SemanticKernel | 27,567 | 27,822 | +0.93% | 4,523 | 4,579 | +1.24% |
| Haystack | 24,620 | 25,040 | +1.71% | 2,675 | 2,754 | +2.95% |
| PydanticAI | 15,824 | 16,765 | +5.95% | 1,830 | 2,004 | +9.51% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9393)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present