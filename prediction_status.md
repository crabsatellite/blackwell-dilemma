# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-03-31
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 5
**Data points**: 6

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 131,708 | 21,708 | 205 | 1.0000 | 0.3896 |
| AutoGen | 56,475 | 8,485 | 0 | 0.9282 | 0.3005 |
| Mem0 | 51,533 | 5,765 | 137 | 0.9204 | 0.2638 |
| LlamaIndex | 48,156 | 7,131 | 102 | 0.9147 | 0.3260 |
| CrewAI | 47,652 | 6,461 | 115 | 0.9138 | 0.3048 |
| LiteLLM | 41,626 | 6,871 | 2051 | 0.9023 | 0.9301 |
| DSPy | 33,299 | 2,742 | 0 | 0.8834 | 0.1647 |
| SemanticKernel | 27,602 | 4,530 | 0 | 0.8674 | 0.3282 |
| Haystack | 24,661 | 2,689 | 149 | 0.8579 | 0.2617 |
| PydanticAI | 15,959 | 1,849 | 56 | 0.8210 | 0.2481 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 131,708 | +0.39% | 21,601 | 21,708 | +0.50% |
| AutoGen | 56,243 | 56,475 | +0.41% | 8,453 | 8,485 | +0.38% |
| Mem0 | 51,132 | 51,533 | +0.78% | 5,717 | 5,765 | +0.84% |
| LlamaIndex | 48,012 | 48,156 | +0.30% | 7,093 | 7,131 | +0.54% |
| CrewAI | 47,278 | 47,652 | +0.79% | 6,385 | 6,461 | +1.19% |
| LiteLLM | 40,982 | 41,626 | +1.57% | 6,752 | 6,871 | +1.76% |
| DSPy | 33,187 | 33,299 | +0.34% | 2,728 | 2,742 | +0.51% |
| SemanticKernel | 27,567 | 27,602 | +0.13% | 4,523 | 4,530 | +0.15% |
| Haystack | 24,620 | 24,661 | +0.17% | 2,675 | 2,689 | +0.52% |
| PydanticAI | 15,824 | 15,959 | +0.85% | 1,830 | 1,849 | +1.04% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9301)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present