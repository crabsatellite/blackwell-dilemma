# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-10
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 76
**Data points**: 77

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 138,932 | 23,010 | 197 | 1.0000 | 0.4633 |
| AutoGen | 58,825 | 8,874 | 0 | 0.9274 | 0.3017 |
| Mem0 | 58,229 | 6,687 | 0 | 0.9266 | 0.2297 |
| CrewAI | 53,180 | 7,440 | 0 | 0.9189 | 0.2798 |
| LlamaIndex | 50,054 | 7,532 | 51 | 0.9138 | 0.3351 |
| LiteLLM | 49,863 | 8,740 | 895 | 0.9135 | 0.9506 |
| DSPy | 34,958 | 2,974 | 0 | 0.8835 | 0.1701 |
| SemanticKernel | 28,090 | 4,639 | 0 | 0.8650 | 0.3303 |
| Haystack | 25,511 | 2,836 | 0 | 0.8569 | 0.2223 |
| PydanticAI | 17,667 | 2,201 | 0 | 0.8259 | 0.2492 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 138,932 | +5.90% | 21,601 | 23,010 | +6.52% |
| AutoGen | 56,243 | 58,825 | +4.59% | 8,453 | 8,874 | +4.98% |
| Mem0 | 51,132 | 58,229 | +13.88% | 5,717 | 6,687 | +16.97% |
| CrewAI | 47,278 | 53,180 | +12.48% | 6,385 | 7,440 | +16.52% |
| LlamaIndex | 48,012 | 50,054 | +4.25% | 7,093 | 7,532 | +6.19% |
| LiteLLM | 40,982 | 49,863 | +21.67% | 6,752 | 8,740 | +29.44% |
| DSPy | 33,187 | 34,958 | +5.34% | 2,728 | 2,974 | +9.02% |
| SemanticKernel | 27,567 | 28,090 | +1.90% | 4,523 | 4,639 | +2.56% |
| Haystack | 24,620 | 25,511 | +3.62% | 2,675 | 2,836 | +6.02% |
| PydanticAI | 15,824 | 17,667 | +11.65% | 1,830 | 2,201 | +20.27% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9506)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present