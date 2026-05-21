# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-21
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 56
**Data points**: 57

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 137,256 | 22,704 | 229 | 1.0000 | 0.4176 |
| AutoGen | 58,234 | 8,792 | 0 | 0.9275 | 0.3020 |
| Mem0 | 56,306 | 6,411 | 0 | 0.9247 | 0.2277 |
| CrewAI | 51,846 | 7,182 | 0 | 0.9177 | 0.2771 |
| LlamaIndex | 49,550 | 7,435 | 0 | 0.9139 | 0.3001 |
| LiteLLM | 47,756 | 8,217 | 1583 | 0.9108 | 0.9441 |
| DSPy | 34,555 | 2,913 | 0 | 0.8834 | 0.1686 |
| SemanticKernel | 27,950 | 4,602 | 0 | 0.8655 | 0.3293 |
| Haystack | 25,315 | 2,798 | 0 | 0.8571 | 0.2211 |
| PydanticAI | 17,177 | 2,107 | 0 | 0.8243 | 0.2453 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 137,256 | +4.62% | 21,601 | 22,704 | +5.11% |
| AutoGen | 56,243 | 58,234 | +3.54% | 8,453 | 8,792 | +4.01% |
| Mem0 | 51,132 | 56,306 | +10.12% | 5,717 | 6,411 | +12.14% |
| CrewAI | 47,278 | 51,846 | +9.66% | 6,385 | 7,182 | +12.48% |
| LlamaIndex | 48,012 | 49,550 | +3.20% | 7,093 | 7,435 | +4.82% |
| LiteLLM | 40,982 | 47,756 | +16.53% | 6,752 | 8,217 | +21.70% |
| DSPy | 33,187 | 34,555 | +4.12% | 2,728 | 2,913 | +6.78% |
| SemanticKernel | 27,567 | 27,950 | +1.39% | 4,523 | 4,602 | +1.75% |
| Haystack | 24,620 | 25,315 | +2.82% | 2,675 | 2,798 | +4.60% |
| PydanticAI | 15,824 | 17,177 | +8.55% | 1,830 | 2,107 | +15.14% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9441)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present