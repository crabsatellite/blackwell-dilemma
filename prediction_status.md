# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-08
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 13
**Data points**: 14

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 132,744 | 21,905 | 199 | 1.0000 | 0.4139 |
| AutoGen | 56,806 | 8,545 | 0 | 0.9280 | 0.3008 |
| Mem0 | 52,247 | 5,853 | 0 | 0.9210 | 0.2241 |
| LlamaIndex | 48,387 | 7,176 | 94 | 0.9144 | 0.3362 |
| CrewAI | 48,304 | 6,584 | 0 | 0.9143 | 0.2726 |
| LiteLLM | 42,510 | 7,060 | 1424 | 0.9035 | 0.9322 |
| DSPy | 33,526 | 2,768 | 0 | 0.8833 | 0.1651 |
| SemanticKernel | 27,665 | 4,536 | 0 | 0.8671 | 0.3279 |
| Haystack | 24,758 | 2,700 | 0 | 0.8576 | 0.2181 |
| PydanticAI | 16,165 | 1,889 | 0 | 0.8215 | 0.2337 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 132,744 | +1.18% | 21,601 | 21,905 | +1.41% |
| AutoGen | 56,243 | 56,806 | +1.00% | 8,453 | 8,545 | +1.09% |
| Mem0 | 51,132 | 52,247 | +2.18% | 5,717 | 5,853 | +2.38% |
| LlamaIndex | 48,012 | 48,387 | +0.78% | 7,093 | 7,176 | +1.17% |
| CrewAI | 47,278 | 48,304 | +2.17% | 6,385 | 6,584 | +3.12% |
| LiteLLM | 40,982 | 42,510 | +3.73% | 6,752 | 7,060 | +4.56% |
| DSPy | 33,187 | 33,526 | +1.02% | 2,728 | 2,768 | +1.47% |
| SemanticKernel | 27,567 | 27,665 | +0.36% | 4,523 | 4,536 | +0.29% |
| Haystack | 24,620 | 24,758 | +0.56% | 2,675 | 2,700 | +0.93% |
| PydanticAI | 15,824 | 16,165 | +2.15% | 1,830 | 1,889 | +3.22% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9322)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present