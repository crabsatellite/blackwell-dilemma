# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-30
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 96
**Data points**: 97

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 140,536 | 23,326 | 295 | 1.0000 | 0.5540 |
| Mem0 | 59,736 | 6,920 | 0 | 0.9278 | 0.2317 |
| AutoGen | 59,366 | 8,945 | 0 | 0.9273 | 0.3014 |
| CrewAI | 54,600 | 7,647 | 0 | 0.9202 | 0.2801 |
| LiteLLM | 52,081 | 9,307 | 797 | 0.9163 | 0.9574 |
| LlamaIndex | 50,521 | 7,653 | 0 | 0.9137 | 0.3030 |
| DSPy | 35,658 | 3,033 | 0 | 0.8843 | 0.1701 |
| SemanticKernel | 28,224 | 4,664 | 0 | 0.8646 | 0.3305 |
| Haystack | 25,785 | 2,891 | 0 | 0.8569 | 0.2242 |
| PydanticAI | 18,090 | 2,279 | 0 | 0.8270 | 0.2520 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 140,536 | +7.12% | 21,601 | 23,326 | +7.99% |
| Mem0 | 51,132 | 59,736 | +16.83% | 5,717 | 6,920 | +21.04% |
| AutoGen | 56,243 | 59,366 | +5.55% | 8,453 | 8,945 | +5.82% |
| CrewAI | 47,278 | 54,600 | +15.49% | 6,385 | 7,647 | +19.77% |
| LiteLLM | 40,982 | 52,081 | +27.08% | 6,752 | 9,307 | +37.84% |
| LlamaIndex | 48,012 | 50,521 | +5.23% | 7,093 | 7,653 | +7.90% |
| DSPy | 33,187 | 35,658 | +7.45% | 2,728 | 3,033 | +11.18% |
| SemanticKernel | 27,567 | 28,224 | +2.38% | 4,523 | 4,664 | +3.12% |
| Haystack | 24,620 | 25,785 | +4.73% | 2,675 | 2,891 | +8.07% |
| PydanticAI | 15,824 | 18,090 | +14.32% | 1,830 | 2,279 | +24.54% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9574)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present