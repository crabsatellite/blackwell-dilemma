# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-03-28
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 2
**Data points**: 3

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 131,333 | 21,642 | 238 | 1.0000 | 0.3822 |
| AutoGen | 56,309 | 8,457 | 0 | 0.9281 | 0.3004 |
| Mem0 | 51,287 | 5,740 | 0 | 0.9202 | 0.2238 |
| LlamaIndex | 48,073 | 7,104 | 124 | 0.9147 | 0.3230 |
| CrewAI | 47,387 | 6,406 | 128 | 0.9135 | 0.2987 |
| LiteLLM | 41,270 | 6,802 | 2715 | 0.9018 | 0.9296 |
| DSPy | 33,222 | 2,734 | 45 | 0.8834 | 0.1745 |
| SemanticKernel | 27,582 | 4,527 | 37 | 0.8676 | 0.3364 |
| Haystack | 24,634 | 2,678 | 0 | 0.8580 | 0.2174 |
| PydanticAI | 15,884 | 1,838 | 0 | 0.8208 | 0.2314 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 131,333 | +0.11% | 21,601 | 21,642 | +0.19% |
| AutoGen | 56,243 | 56,309 | +0.12% | 8,453 | 8,457 | +0.05% |
| Mem0 | 51,132 | 51,287 | +0.30% | 5,717 | 5,740 | +0.40% |
| LlamaIndex | 48,012 | 48,073 | +0.13% | 7,093 | 7,104 | +0.16% |
| CrewAI | 47,278 | 47,387 | +0.23% | 6,385 | 6,406 | +0.33% |
| LiteLLM | 40,982 | 41,270 | +0.70% | 6,752 | 6,802 | +0.74% |
| DSPy | 33,187 | 33,222 | +0.11% | 2,728 | 2,734 | +0.22% |
| SemanticKernel | 27,567 | 27,582 | +0.05% | 4,523 | 4,527 | +0.09% |
| Haystack | 24,620 | 24,634 | +0.06% | 2,675 | 2,678 | +0.11% |
| PydanticAI | 15,824 | 15,884 | +0.38% | 1,830 | 1,838 | +0.44% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9296)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present