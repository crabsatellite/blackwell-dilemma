# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-16
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 21
**Data points**: 22

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 133,719 | 22,098 | 210 | 1.0000 | 0.4352 |
| AutoGen | 57,129 | 8,598 | 0 | 0.9280 | 0.3010 |
| Mem0 | 53,174 | 5,961 | 0 | 0.9219 | 0.2242 |
| CrewAI | 48,988 | 6,696 | 0 | 0.9149 | 0.2734 |
| LlamaIndex | 48,624 | 7,197 | 0 | 0.9143 | 0.2960 |
| LiteLLM | 43,460 | 7,275 | 1204 | 0.9048 | 0.9348 |
| DSPy | 33,740 | 2,794 | 0 | 0.8833 | 0.1656 |
| SemanticKernel | 27,713 | 4,552 | 0 | 0.8667 | 0.3285 |
| Haystack | 24,846 | 2,719 | 0 | 0.8574 | 0.2189 |
| PydanticAI | 16,400 | 1,946 | 0 | 0.8222 | 0.2373 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 133,719 | +1.93% | 21,601 | 22,098 | +2.30% |
| AutoGen | 56,243 | 57,129 | +1.58% | 8,453 | 8,598 | +1.72% |
| Mem0 | 51,132 | 53,174 | +3.99% | 5,717 | 5,961 | +4.27% |
| CrewAI | 47,278 | 48,988 | +3.62% | 6,385 | 6,696 | +4.87% |
| LlamaIndex | 48,012 | 48,624 | +1.27% | 7,093 | 7,197 | +1.47% |
| LiteLLM | 40,982 | 43,460 | +6.05% | 6,752 | 7,275 | +7.75% |
| DSPy | 33,187 | 33,740 | +1.67% | 2,728 | 2,794 | +2.42% |
| SemanticKernel | 27,567 | 27,713 | +0.53% | 4,523 | 4,552 | +0.64% |
| Haystack | 24,620 | 24,846 | +0.92% | 2,675 | 2,719 | +1.64% |
| PydanticAI | 15,824 | 16,400 | +3.64% | 1,830 | 1,946 | +6.34% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9348)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present