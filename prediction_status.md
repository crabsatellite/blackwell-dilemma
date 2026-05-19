# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-19
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 54
**Data points**: 55

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 137,075 | 22,674 | 186 | 1.0000 | 0.4056 |
| AutoGen | 58,164 | 8,784 | 0 | 0.9275 | 0.3020 |
| Mem0 | 56,100 | 6,385 | 0 | 0.9245 | 0.2276 |
| CrewAI | 51,696 | 7,157 | 0 | 0.9176 | 0.2769 |
| LlamaIndex | 49,501 | 7,431 | 0 | 0.9139 | 0.3002 |
| LiteLLM | 47,503 | 8,162 | 1492 | 0.9104 | 0.9436 |
| DSPy | 34,518 | 2,905 | 0 | 0.8834 | 0.1683 |
| SemanticKernel | 27,935 | 4,602 | 0 | 0.8655 | 0.3295 |
| Haystack | 25,285 | 2,792 | 0 | 0.8571 | 0.2208 |
| PydanticAI | 17,133 | 2,096 | 0 | 0.8242 | 0.2447 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 137,075 | +4.49% | 21,601 | 22,674 | +4.97% |
| AutoGen | 56,243 | 58,164 | +3.42% | 8,453 | 8,784 | +3.92% |
| Mem0 | 51,132 | 56,100 | +9.72% | 5,717 | 6,385 | +11.68% |
| CrewAI | 47,278 | 51,696 | +9.34% | 6,385 | 7,157 | +12.09% |
| LlamaIndex | 48,012 | 49,501 | +3.10% | 7,093 | 7,431 | +4.77% |
| LiteLLM | 40,982 | 47,503 | +15.91% | 6,752 | 8,162 | +20.88% |
| DSPy | 33,187 | 34,518 | +4.01% | 2,728 | 2,905 | +6.49% |
| SemanticKernel | 27,567 | 27,935 | +1.33% | 4,523 | 4,602 | +1.75% |
| Haystack | 24,620 | 25,285 | +2.70% | 2,675 | 2,792 | +4.37% |
| PydanticAI | 15,824 | 17,133 | +8.27% | 1,830 | 2,096 | +14.54% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9436)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present