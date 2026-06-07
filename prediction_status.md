# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-07
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 73
**Data points**: 74

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 138,695 | 22,982 | 160 | 1.0000 | 0.4478 |
| AutoGen | 58,740 | 8,863 | 0 | 0.9274 | 0.3018 |
| Mem0 | 57,919 | 6,627 | 49 | 0.9262 | 0.2645 |
| CrewAI | 52,956 | 7,400 | 81 | 0.9187 | 0.3384 |
| LlamaIndex | 49,962 | 7,524 | 0 | 0.9138 | 0.3012 |
| LiteLLM | 49,523 | 8,660 | 825 | 0.9130 | 0.9497 |
| DSPy | 34,891 | 2,960 | 0 | 0.8834 | 0.1697 |
| SemanticKernel | 28,066 | 4,637 | 0 | 0.8651 | 0.3304 |
| Haystack | 25,472 | 2,830 | 95 | 0.8569 | 0.2913 |
| PydanticAI | 17,573 | 2,184 | 0 | 0.8255 | 0.2486 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 138,695 | +5.72% | 21,601 | 22,982 | +6.39% |
| AutoGen | 56,243 | 58,740 | +4.44% | 8,453 | 8,863 | +4.85% |
| Mem0 | 51,132 | 57,919 | +13.27% | 5,717 | 6,627 | +15.92% |
| CrewAI | 47,278 | 52,956 | +12.01% | 6,385 | 7,400 | +15.90% |
| LlamaIndex | 48,012 | 49,962 | +4.06% | 7,093 | 7,524 | +6.08% |
| LiteLLM | 40,982 | 49,523 | +20.84% | 6,752 | 8,660 | +28.26% |
| DSPy | 33,187 | 34,891 | +5.13% | 2,728 | 2,960 | +8.50% |
| SemanticKernel | 27,567 | 28,066 | +1.81% | 4,523 | 4,637 | +2.52% |
| Haystack | 24,620 | 25,472 | +3.46% | 2,675 | 2,830 | +5.79% |
| PydanticAI | 15,824 | 17,573 | +11.05% | 1,830 | 2,184 | +19.34% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9497)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present