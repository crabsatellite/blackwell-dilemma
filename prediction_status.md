# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-07-02
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 98
**Data points**: 99

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 140,703 | 23,361 | 309 | 1.0000 | 0.5390 |
| Mem0 | 59,898 | 6,944 | 0 | 0.9280 | 0.2319 |
| AutoGen | 59,415 | 8,946 | 0 | 0.9273 | 0.3011 |
| CrewAI | 54,743 | 7,673 | 0 | 0.9204 | 0.2803 |
| LiteLLM | 52,340 | 9,376 | 896 | 0.9166 | 0.9583 |
| LlamaIndex | 50,582 | 7,668 | 0 | 0.9137 | 0.3032 |
| DSPy | 35,725 | 3,042 | 0 | 0.8844 | 0.1703 |
| SemanticKernel | 28,237 | 4,667 | 0 | 0.8645 | 0.3306 |
| Haystack | 25,804 | 2,899 | 0 | 0.8569 | 0.2247 |
| PydanticAI | 18,132 | 2,287 | 0 | 0.8272 | 0.2523 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 140,703 | +7.25% | 21,601 | 23,361 | +8.15% |
| Mem0 | 51,132 | 59,898 | +17.14% | 5,717 | 6,944 | +21.46% |
| AutoGen | 56,243 | 59,415 | +5.64% | 8,453 | 8,946 | +5.83% |
| CrewAI | 47,278 | 54,743 | +15.79% | 6,385 | 7,673 | +20.17% |
| LiteLLM | 40,982 | 52,340 | +27.71% | 6,752 | 9,376 | +38.86% |
| LlamaIndex | 48,012 | 50,582 | +5.35% | 7,093 | 7,668 | +8.11% |
| DSPy | 33,187 | 35,725 | +7.65% | 2,728 | 3,042 | +11.51% |
| SemanticKernel | 27,567 | 28,237 | +2.43% | 4,523 | 4,667 | +3.18% |
| Haystack | 24,620 | 25,804 | +4.81% | 2,675 | 2,899 | +8.37% |
| PydanticAI | 15,824 | 18,132 | +14.59% | 1,830 | 2,287 | +24.97% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9583)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present