# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-07-09
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 105
**Data points**: 106

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 141,353 | 23,493 | 235 | 1.0000 | 0.4733 |
| Mem0 | 60,448 | 7,020 | 179 | 0.9284 | 0.3396 |
| AutoGen | 59,598 | 8,973 | 0 | 0.9272 | 0.3011 |
| CrewAI | 55,195 | 7,762 | 103 | 0.9207 | 0.3430 |
| LiteLLM | 53,041 | 9,601 | 1001 | 0.9173 | 0.9620 |
| LlamaIndex | 50,745 | 7,718 | 0 | 0.9136 | 0.3042 |
| DSPy | 35,967 | 3,075 | 0 | 0.8846 | 0.1710 |
| SemanticKernel | 28,288 | 4,674 | 0 | 0.8643 | 0.3305 |
| Haystack | 25,856 | 2,906 | 0 | 0.8568 | 0.2248 |
| PydanticAI | 18,286 | 2,323 | 0 | 0.8276 | 0.2541 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 141,353 | +7.75% | 21,601 | 23,493 | +8.76% |
| Mem0 | 51,132 | 60,448 | +18.22% | 5,717 | 7,020 | +22.79% |
| AutoGen | 56,243 | 59,598 | +5.97% | 8,453 | 8,973 | +6.15% |
| CrewAI | 47,278 | 55,195 | +16.75% | 6,385 | 7,762 | +21.57% |
| LiteLLM | 40,982 | 53,041 | +29.43% | 6,752 | 9,601 | +42.19% |
| LlamaIndex | 48,012 | 50,745 | +5.69% | 7,093 | 7,718 | +8.81% |
| DSPy | 33,187 | 35,967 | +8.38% | 2,728 | 3,075 | +12.72% |
| SemanticKernel | 27,567 | 28,288 | +2.62% | 4,523 | 4,674 | +3.34% |
| Haystack | 24,620 | 25,856 | +5.02% | 2,675 | 2,906 | +8.64% |
| PydanticAI | 15,824 | 18,286 | +15.56% | 1,830 | 2,323 | +26.94% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9620)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present