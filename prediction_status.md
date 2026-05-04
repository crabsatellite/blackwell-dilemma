# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-04
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 39
**Data points**: 40

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 135,712 | 22,433 | 190 | 1.0000 | 0.3968 |
| AutoGen | 57,686 | 8,702 | 0 | 0.9276 | 0.3017 |
| Mem0 | 54,711 | 6,187 | 0 | 0.9231 | 0.2262 |
| CrewAI | 50,563 | 6,973 | 0 | 0.9165 | 0.2758 |
| LlamaIndex | 49,120 | 7,351 | 0 | 0.9140 | 0.2993 |
| LiteLLM | 45,584 | 7,749 | 1722 | 0.9077 | 0.9400 |
| DSPy | 34,180 | 2,869 | 0 | 0.8833 | 0.1679 |
| SemanticKernel | 27,830 | 4,580 | 0 | 0.8659 | 0.3291 |
| Haystack | 25,068 | 2,762 | 0 | 0.8571 | 0.2204 |
| PydanticAI | 16,821 | 2,021 | 0 | 0.8233 | 0.2403 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 135,712 | +3.45% | 21,601 | 22,433 | +3.85% |
| AutoGen | 56,243 | 57,686 | +2.57% | 8,453 | 8,702 | +2.95% |
| Mem0 | 51,132 | 54,711 | +7.00% | 5,717 | 6,187 | +8.22% |
| CrewAI | 47,278 | 50,563 | +6.95% | 6,385 | 6,973 | +9.21% |
| LlamaIndex | 48,012 | 49,120 | +2.31% | 7,093 | 7,351 | +3.64% |
| LiteLLM | 40,982 | 45,584 | +11.23% | 6,752 | 7,749 | +14.77% |
| DSPy | 33,187 | 34,180 | +2.99% | 2,728 | 2,869 | +5.17% |
| SemanticKernel | 27,567 | 27,830 | +0.95% | 4,523 | 4,580 | +1.26% |
| Haystack | 24,620 | 25,068 | +1.82% | 2,675 | 2,762 | +3.25% |
| PydanticAI | 15,824 | 16,821 | +6.30% | 1,830 | 2,021 | +10.44% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9400)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present