# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-04
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 70
**Data points**: 71

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 138,463 | 22,940 | 190 | 1.0000 | 0.4456 |
| AutoGen | 58,680 | 8,861 | 0 | 0.9275 | 0.3020 |
| Mem0 | 57,650 | 6,585 | 0 | 0.9260 | 0.2284 |
| CrewAI | 52,805 | 7,372 | 0 | 0.9186 | 0.2792 |
| LlamaIndex | 49,901 | 7,505 | 0 | 0.9138 | 0.3008 |
| LiteLLM | 49,232 | 8,583 | 998 | 0.9127 | 0.9487 |
| DSPy | 34,838 | 2,952 | 0 | 0.8834 | 0.1695 |
| SemanticKernel | 28,047 | 4,631 | 0 | 0.8651 | 0.3302 |
| Haystack | 25,454 | 2,829 | 0 | 0.8569 | 0.2223 |
| PydanticAI | 17,507 | 2,166 | 0 | 0.8253 | 0.2474 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 138,463 | +5.54% | 21,601 | 22,940 | +6.20% |
| AutoGen | 56,243 | 58,680 | +4.33% | 8,453 | 8,861 | +4.83% |
| Mem0 | 51,132 | 57,650 | +12.75% | 5,717 | 6,585 | +15.18% |
| CrewAI | 47,278 | 52,805 | +11.69% | 6,385 | 7,372 | +15.46% |
| LlamaIndex | 48,012 | 49,901 | +3.93% | 7,093 | 7,505 | +5.81% |
| LiteLLM | 40,982 | 49,232 | +20.13% | 6,752 | 8,583 | +27.12% |
| DSPy | 33,187 | 34,838 | +4.97% | 2,728 | 2,952 | +8.21% |
| SemanticKernel | 27,567 | 28,047 | +1.74% | 4,523 | 4,631 | +2.39% |
| Haystack | 24,620 | 25,454 | +3.39% | 2,675 | 2,829 | +5.76% |
| PydanticAI | 15,824 | 17,507 | +10.64% | 1,830 | 2,166 | +18.36% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9487)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present