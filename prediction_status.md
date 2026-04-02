# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-02
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 7
**Data points**: 8

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 132,020 | 21,769 | 215 | 1.0000 | 0.3895 |
| AutoGen | 56,585 | 8,508 | 0 | 0.9281 | 0.3007 |
| Mem0 | 51,737 | 5,792 | 0 | 0.9206 | 0.2239 |
| LlamaIndex | 48,220 | 7,145 | 109 | 0.9146 | 0.3266 |
| CrewAI | 47,817 | 6,490 | 133 | 0.9139 | 0.3084 |
| LiteLLM | 41,861 | 6,919 | 2162 | 0.9026 | 0.9306 |
| DSPy | 33,370 | 2,749 | 0 | 0.8834 | 0.1648 |
| SemanticKernel | 27,614 | 4,530 | 0 | 0.8673 | 0.3281 |
| Haystack | 24,680 | 2,689 | 0 | 0.8578 | 0.2179 |
| PydanticAI | 16,030 | 1,860 | 71 | 0.8212 | 0.2518 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 132,020 | +0.63% | 21,601 | 21,769 | +0.78% |
| AutoGen | 56,243 | 56,585 | +0.61% | 8,453 | 8,508 | +0.65% |
| Mem0 | 51,132 | 51,737 | +1.18% | 5,717 | 5,792 | +1.31% |
| LlamaIndex | 48,012 | 48,220 | +0.43% | 7,093 | 7,145 | +0.73% |
| CrewAI | 47,278 | 47,817 | +1.14% | 6,385 | 6,490 | +1.64% |
| LiteLLM | 40,982 | 41,861 | +2.14% | 6,752 | 6,919 | +2.47% |
| DSPy | 33,187 | 33,370 | +0.55% | 2,728 | 2,749 | +0.77% |
| SemanticKernel | 27,567 | 27,614 | +0.17% | 4,523 | 4,530 | +0.15% |
| Haystack | 24,620 | 24,680 | +0.24% | 2,675 | 2,689 | +0.52% |
| PydanticAI | 15,824 | 16,030 | +1.30% | 1,830 | 1,860 | +1.64% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9306)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present