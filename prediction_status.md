# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-07-04
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 100
**Data points**: 101

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 140,881 | 23,391 | 309 | 1.0000 | 0.5153 |
| Mem0 | 60,055 | 6,962 | 197 | 0.9281 | 0.3487 |
| AutoGen | 59,479 | 8,955 | 0 | 0.9273 | 0.3011 |
| CrewAI | 54,867 | 7,690 | 130 | 0.9205 | 0.3574 |
| LiteLLM | 52,561 | 9,450 | 1012 | 0.9168 | 0.9596 |
| LlamaIndex | 50,634 | 7,679 | 33 | 0.9137 | 0.3229 |
| DSPy | 35,812 | 3,052 | 0 | 0.8845 | 0.1704 |
| SemanticKernel | 28,256 | 4,670 | 35 | 0.8645 | 0.3513 |
| Haystack | 25,821 | 2,902 | 181 | 0.8569 | 0.3321 |
| PydanticAI | 18,196 | 2,297 | 190 | 0.8274 | 0.3651 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 140,881 | +7.39% | 21,601 | 23,391 | +8.29% |
| Mem0 | 51,132 | 60,055 | +17.45% | 5,717 | 6,962 | +21.78% |
| AutoGen | 56,243 | 59,479 | +5.75% | 8,453 | 8,955 | +5.94% |
| CrewAI | 47,278 | 54,867 | +16.05% | 6,385 | 7,690 | +20.44% |
| LiteLLM | 40,982 | 52,561 | +28.25% | 6,752 | 9,450 | +39.96% |
| LlamaIndex | 48,012 | 50,634 | +5.46% | 7,093 | 7,679 | +8.26% |
| DSPy | 33,187 | 35,812 | +7.91% | 2,728 | 3,052 | +11.88% |
| SemanticKernel | 27,567 | 28,256 | +2.50% | 4,523 | 4,670 | +3.25% |
| Haystack | 24,620 | 25,821 | +4.88% | 2,675 | 2,902 | +8.49% |
| PydanticAI | 15,824 | 18,196 | +14.99% | 1,830 | 2,297 | +25.52% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9596)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present