# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-06
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 11
**Data points**: 12

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 132,480 | 21,865 | 177 | 1.0000 | 0.4069 |
| AutoGen | 56,730 | 8,536 | 0 | 0.9281 | 0.3009 |
| Mem0 | 52,048 | 5,832 | 0 | 0.9208 | 0.2241 |
| LlamaIndex | 48,319 | 7,161 | 0 | 0.9145 | 0.2964 |
| CrewAI | 48,119 | 6,555 | 0 | 0.9141 | 0.2724 |
| LiteLLM | 42,280 | 7,018 | 1383 | 0.9032 | 0.9320 |
| DSPy | 33,469 | 2,763 | 0 | 0.8834 | 0.1651 |
| SemanticKernel | 27,656 | 4,535 | 0 | 0.8672 | 0.3280 |
| Haystack | 24,724 | 2,696 | 0 | 0.8577 | 0.2181 |
| PydanticAI | 16,115 | 1,878 | 0 | 0.8214 | 0.2331 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 132,480 | +0.98% | 21,601 | 21,865 | +1.22% |
| AutoGen | 56,243 | 56,730 | +0.87% | 8,453 | 8,536 | +0.98% |
| Mem0 | 51,132 | 52,048 | +1.79% | 5,717 | 5,832 | +2.01% |
| LlamaIndex | 48,012 | 48,319 | +0.64% | 7,093 | 7,161 | +0.96% |
| CrewAI | 47,278 | 48,119 | +1.78% | 6,385 | 6,555 | +2.66% |
| LiteLLM | 40,982 | 42,280 | +3.17% | 6,752 | 7,018 | +3.94% |
| DSPy | 33,187 | 33,469 | +0.85% | 2,728 | 2,763 | +1.28% |
| SemanticKernel | 27,567 | 27,656 | +0.32% | 4,523 | 4,535 | +0.27% |
| Haystack | 24,620 | 24,724 | +0.42% | 2,675 | 2,696 | +0.79% |
| PydanticAI | 15,824 | 16,115 | +1.84% | 1,830 | 1,878 | +2.62% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9320)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present