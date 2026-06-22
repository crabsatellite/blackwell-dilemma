# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-22
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 88
**Data points**: 89

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 139,848 | 23,193 | 287 | 1.0000 | 0.5550 |
| AutoGen | 59,130 | 8,921 | 0 | 0.9273 | 0.3017 |
| Mem0 | 59,091 | 6,818 | 129 | 0.9273 | 0.3312 |
| CrewAI | 54,110 | 7,579 | 101 | 0.9199 | 0.3587 |
| LiteLLM | 51,090 | 9,055 | 771 | 0.9150 | 0.9545 |
| LlamaIndex | 50,269 | 7,607 | 0 | 0.9136 | 0.3027 |
| DSPy | 35,272 | 2,996 | 0 | 0.8837 | 0.1699 |
| SemanticKernel | 28,177 | 4,660 | 0 | 0.8648 | 0.3308 |
| Haystack | 25,623 | 2,869 | 0 | 0.8568 | 0.2239 |
| PydanticAI | 17,900 | 2,242 | 0 | 0.8265 | 0.2505 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 139,848 | +6.60% | 21,601 | 23,193 | +7.37% |
| AutoGen | 56,243 | 59,130 | +5.13% | 8,453 | 8,921 | +5.54% |
| Mem0 | 51,132 | 59,091 | +15.57% | 5,717 | 6,818 | +19.26% |
| CrewAI | 47,278 | 54,110 | +14.45% | 6,385 | 7,579 | +18.70% |
| LiteLLM | 40,982 | 51,090 | +24.66% | 6,752 | 9,055 | +34.11% |
| LlamaIndex | 48,012 | 50,269 | +4.70% | 7,093 | 7,607 | +7.25% |
| DSPy | 33,187 | 35,272 | +6.28% | 2,728 | 2,996 | +9.82% |
| SemanticKernel | 27,567 | 28,177 | +2.21% | 4,523 | 4,660 | +3.03% |
| Haystack | 24,620 | 25,623 | +4.07% | 2,675 | 2,869 | +7.25% |
| PydanticAI | 15,824 | 17,900 | +13.12% | 1,830 | 2,242 | +22.51% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9545)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present