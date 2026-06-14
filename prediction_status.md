# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-14
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 80
**Data points**: 81

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 139,227 | 23,079 | 199 | 1.0000 | 0.4854 |
| AutoGen | 58,936 | 8,895 | 0 | 0.9274 | 0.3019 |
| Mem0 | 58,510 | 6,720 | 80 | 0.9268 | 0.2916 |
| CrewAI | 53,510 | 7,489 | 0 | 0.9193 | 0.2799 |
| LiteLLM | 50,296 | 8,863 | 776 | 0.9140 | 0.9524 |
| LlamaIndex | 50,112 | 7,556 | 0 | 0.9137 | 0.3016 |
| DSPy | 35,013 | 2,976 | 0 | 0.8835 | 0.1700 |
| SemanticKernel | 28,115 | 4,647 | 0 | 0.8649 | 0.3306 |
| Haystack | 25,560 | 2,848 | 0 | 0.8569 | 0.2228 |
| PydanticAI | 17,746 | 2,215 | 0 | 0.8261 | 0.2496 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 139,227 | +6.13% | 21,601 | 23,079 | +6.84% |
| AutoGen | 56,243 | 58,936 | +4.79% | 8,453 | 8,895 | +5.23% |
| Mem0 | 51,132 | 58,510 | +14.43% | 5,717 | 6,720 | +17.54% |
| CrewAI | 47,278 | 53,510 | +13.18% | 6,385 | 7,489 | +17.29% |
| LiteLLM | 40,982 | 50,296 | +22.73% | 6,752 | 8,863 | +31.26% |
| LlamaIndex | 48,012 | 50,112 | +4.37% | 7,093 | 7,556 | +6.53% |
| DSPy | 33,187 | 35,013 | +5.50% | 2,728 | 2,976 | +9.09% |
| SemanticKernel | 27,567 | 28,115 | +1.99% | 4,523 | 4,647 | +2.74% |
| Haystack | 24,620 | 25,560 | +3.82% | 2,675 | 2,848 | +6.47% |
| PydanticAI | 15,824 | 17,746 | +12.15% | 1,830 | 2,215 | +21.04% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9524)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present