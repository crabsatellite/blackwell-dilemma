# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-17
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 83
**Data points**: 84

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 139,525 | 23,123 | 221 | 1.0000 | 0.4851 |
| AutoGen | 59,024 | 8,903 | 0 | 0.9274 | 0.3017 |
| Mem0 | 58,764 | 6,757 | 107 | 0.9270 | 0.3044 |
| CrewAI | 53,752 | 7,520 | 104 | 0.9195 | 0.3521 |
| LiteLLM | 50,654 | 8,939 | 863 | 0.9145 | 0.9529 |
| LlamaIndex | 50,188 | 7,575 | 0 | 0.9137 | 0.3019 |
| DSPy | 35,082 | 2,979 | 38 | 0.8835 | 0.1963 |
| SemanticKernel | 28,147 | 4,649 | 0 | 0.8649 | 0.3303 |
| Haystack | 25,588 | 2,861 | 0 | 0.8568 | 0.2236 |
| PydanticAI | 17,804 | 2,223 | 77 | 0.8262 | 0.3033 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 139,525 | +6.35% | 21,601 | 23,123 | +7.05% |
| AutoGen | 56,243 | 59,024 | +4.94% | 8,453 | 8,903 | +5.32% |
| Mem0 | 51,132 | 58,764 | +14.93% | 5,717 | 6,757 | +18.19% |
| CrewAI | 47,278 | 53,752 | +13.69% | 6,385 | 7,520 | +17.78% |
| LiteLLM | 40,982 | 50,654 | +23.60% | 6,752 | 8,939 | +32.39% |
| LlamaIndex | 48,012 | 50,188 | +4.53% | 7,093 | 7,575 | +6.80% |
| DSPy | 33,187 | 35,082 | +5.71% | 2,728 | 2,979 | +9.20% |
| SemanticKernel | 27,567 | 28,147 | +2.10% | 4,523 | 4,649 | +2.79% |
| Haystack | 24,620 | 25,588 | +3.93% | 2,675 | 2,861 | +6.95% |
| PydanticAI | 15,824 | 17,804 | +12.51% | 1,830 | 2,223 | +21.48% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9529)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present