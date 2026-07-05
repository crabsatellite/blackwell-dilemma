# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-07-05
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 101
**Data points**: 102

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 140,948 | 23,409 | 200 | 1.0000 | 0.4771 |
| Mem0 | 60,104 | 6,969 | 197 | 0.9281 | 0.3747 |
| AutoGen | 59,495 | 8,960 | 0 | 0.9273 | 0.3012 |
| CrewAI | 54,925 | 7,705 | 130 | 0.9205 | 0.3748 |
| LiteLLM | 52,622 | 9,471 | 828 | 0.9169 | 0.9600 |
| LlamaIndex | 50,649 | 7,687 | 33 | 0.9137 | 0.3275 |
| DSPy | 35,836 | 3,054 | 13 | 0.8845 | 0.1799 |
| SemanticKernel | 28,258 | 4,669 | 35 | 0.8645 | 0.3558 |
| Haystack | 25,825 | 2,901 | 181 | 0.8569 | 0.3558 |
| PydanticAI | 18,217 | 2,304 | 159 | 0.8274 | 0.3682 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 140,948 | +7.44% | 21,601 | 23,409 | +8.37% |
| Mem0 | 51,132 | 60,104 | +17.55% | 5,717 | 6,969 | +21.90% |
| AutoGen | 56,243 | 59,495 | +5.78% | 8,453 | 8,960 | +6.00% |
| CrewAI | 47,278 | 54,925 | +16.17% | 6,385 | 7,705 | +20.67% |
| LiteLLM | 40,982 | 52,622 | +28.40% | 6,752 | 9,471 | +40.27% |
| LlamaIndex | 48,012 | 50,649 | +5.49% | 7,093 | 7,687 | +8.37% |
| DSPy | 33,187 | 35,836 | +7.98% | 2,728 | 3,054 | +11.95% |
| SemanticKernel | 27,567 | 28,258 | +2.51% | 4,523 | 4,669 | +3.23% |
| Haystack | 24,620 | 25,825 | +4.89% | 2,675 | 2,901 | +8.45% |
| PydanticAI | 15,824 | 18,217 | +15.12% | 1,830 | 2,304 | +25.90% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9600)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present