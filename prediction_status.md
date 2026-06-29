# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-29
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 95
**Data points**: 96

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 140,454 | 23,311 | 291 | 1.0000 | 0.5608 |
| Mem0 | 59,657 | 6,908 | 171 | 0.9278 | 0.3661 |
| AutoGen | 59,338 | 8,942 | 0 | 0.9273 | 0.3014 |
| CrewAI | 54,529 | 7,638 | 0 | 0.9202 | 0.2801 |
| LiteLLM | 51,928 | 9,277 | 763 | 0.9161 | 0.9573 |
| LlamaIndex | 50,484 | 7,649 | 0 | 0.9137 | 0.3030 |
| DSPy | 35,596 | 3,032 | 0 | 0.8842 | 0.1704 |
| SemanticKernel | 28,215 | 4,664 | 0 | 0.8646 | 0.3306 |
| Haystack | 25,771 | 2,888 | 0 | 0.8569 | 0.2241 |
| PydanticAI | 18,057 | 2,270 | 0 | 0.8269 | 0.2514 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 140,454 | +7.06% | 21,601 | 23,311 | +7.92% |
| Mem0 | 51,132 | 59,657 | +16.67% | 5,717 | 6,908 | +20.83% |
| AutoGen | 56,243 | 59,338 | +5.50% | 8,453 | 8,942 | +5.78% |
| CrewAI | 47,278 | 54,529 | +15.34% | 6,385 | 7,638 | +19.62% |
| LiteLLM | 40,982 | 51,928 | +26.71% | 6,752 | 9,277 | +37.40% |
| LlamaIndex | 48,012 | 50,484 | +5.15% | 7,093 | 7,649 | +7.84% |
| DSPy | 33,187 | 35,596 | +7.26% | 2,728 | 3,032 | +11.14% |
| SemanticKernel | 27,567 | 28,215 | +2.35% | 4,523 | 4,664 | +3.12% |
| Haystack | 24,620 | 25,771 | +4.68% | 2,675 | 2,888 | +7.96% |
| PydanticAI | 15,824 | 18,057 | +14.11% | 1,830 | 2,270 | +24.04% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9573)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present