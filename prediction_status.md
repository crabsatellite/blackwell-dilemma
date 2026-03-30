# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-03-30
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 4
**Data points**: 5

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 131,561 | 21,682 | 197 | 1.0000 | 0.3909 |
| AutoGen | 56,414 | 8,480 | 0 | 0.9282 | 0.3006 |
| Mem0 | 51,434 | 5,753 | 0 | 0.9203 | 0.2237 |
| LlamaIndex | 48,125 | 7,116 | 97 | 0.9147 | 0.3259 |
| CrewAI | 47,539 | 6,440 | 0 | 0.9136 | 0.2709 |
| LiteLLM | 41,478 | 6,847 | 1928 | 0.9021 | 0.9302 |
| DSPy | 33,265 | 2,740 | 0 | 0.8834 | 0.1647 |
| SemanticKernel | 27,589 | 4,528 | 0 | 0.8675 | 0.3282 |
| Haystack | 24,648 | 2,684 | 139 | 0.8579 | 0.2610 |
| PydanticAI | 15,931 | 1,841 | 0 | 0.8209 | 0.2311 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 131,561 | +0.28% | 21,601 | 21,682 | +0.37% |
| AutoGen | 56,243 | 56,414 | +0.30% | 8,453 | 8,480 | +0.32% |
| Mem0 | 51,132 | 51,434 | +0.59% | 5,717 | 5,753 | +0.63% |
| LlamaIndex | 48,012 | 48,125 | +0.24% | 7,093 | 7,116 | +0.32% |
| CrewAI | 47,278 | 47,539 | +0.55% | 6,385 | 6,440 | +0.86% |
| LiteLLM | 40,982 | 41,478 | +1.21% | 6,752 | 6,847 | +1.41% |
| DSPy | 33,187 | 33,265 | +0.24% | 2,728 | 2,740 | +0.44% |
| SemanticKernel | 27,567 | 27,589 | +0.08% | 4,523 | 4,528 | +0.11% |
| Haystack | 24,620 | 24,648 | +0.11% | 2,675 | 2,684 | +0.34% |
| PydanticAI | 15,824 | 15,931 | +0.68% | 1,830 | 1,841 | +0.60% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9302)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present