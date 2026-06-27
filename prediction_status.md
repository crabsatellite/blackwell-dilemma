# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-27
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 93
**Data points**: 94

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 140,312 | 23,287 | 331 | 1.0000 | 0.5175 |
| Mem0 | 59,545 | 6,890 | 180 | 0.9277 | 0.3324 |
| AutoGen | 59,286 | 8,937 | 0 | 0.9273 | 0.3015 |
| CrewAI | 54,436 | 7,621 | 0 | 0.9201 | 0.2800 |
| LiteLLM | 51,715 | 9,215 | 1070 | 0.9158 | 0.9564 |
| LlamaIndex | 50,438 | 7,640 | 12 | 0.9137 | 0.3097 |
| DSPy | 35,440 | 3,013 | 18 | 0.8839 | 0.1801 |
| SemanticKernel | 28,201 | 4,662 | 32 | 0.8646 | 0.3486 |
| Haystack | 25,748 | 2,884 | 197 | 0.8569 | 0.3345 |
| PydanticAI | 18,018 | 2,258 | 99 | 0.8268 | 0.3062 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 140,312 | +6.95% | 21,601 | 23,287 | +7.81% |
| Mem0 | 51,132 | 59,545 | +16.45% | 5,717 | 6,890 | +20.52% |
| AutoGen | 56,243 | 59,286 | +5.41% | 8,453 | 8,937 | +5.73% |
| CrewAI | 47,278 | 54,436 | +15.14% | 6,385 | 7,621 | +19.36% |
| LiteLLM | 40,982 | 51,715 | +26.19% | 6,752 | 9,215 | +36.48% |
| LlamaIndex | 48,012 | 50,438 | +5.05% | 7,093 | 7,640 | +7.71% |
| DSPy | 33,187 | 35,440 | +6.79% | 2,728 | 3,013 | +10.45% |
| SemanticKernel | 27,567 | 28,201 | +2.30% | 4,523 | 4,662 | +3.07% |
| Haystack | 24,620 | 25,748 | +4.58% | 2,675 | 2,884 | +7.81% |
| PydanticAI | 15,824 | 18,018 | +13.87% | 1,830 | 2,258 | +23.39% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9564)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present