# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-12
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 17
**Data points**: 18

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 133,212 | 22,006 | 155 | 1.0000 | 0.4415 |
| AutoGen | 56,978 | 8,568 | 0 | 0.9280 | 0.3007 |
| Mem0 | 52,714 | 5,913 | 0 | 0.9214 | 0.2243 |
| CrewAI | 48,643 | 6,642 | 0 | 0.9146 | 0.2731 |
| LlamaIndex | 48,510 | 7,189 | 0 | 0.9144 | 0.2964 |
| LiteLLM | 42,984 | 7,169 | 837 | 0.9041 | 0.9336 |
| DSPy | 33,608 | 2,781 | 0 | 0.8833 | 0.1655 |
| SemanticKernel | 27,688 | 4,544 | 0 | 0.8669 | 0.3282 |
| Haystack | 24,812 | 2,707 | 0 | 0.8576 | 0.2182 |
| PydanticAI | 16,285 | 1,909 | 0 | 0.8219 | 0.2344 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 133,212 | +1.54% | 21,601 | 22,006 | +1.87% |
| AutoGen | 56,243 | 56,978 | +1.31% | 8,453 | 8,568 | +1.36% |
| Mem0 | 51,132 | 52,714 | +3.09% | 5,717 | 5,913 | +3.43% |
| CrewAI | 47,278 | 48,643 | +2.89% | 6,385 | 6,642 | +4.03% |
| LlamaIndex | 48,012 | 48,510 | +1.04% | 7,093 | 7,189 | +1.35% |
| LiteLLM | 40,982 | 42,984 | +4.89% | 6,752 | 7,169 | +6.18% |
| DSPy | 33,187 | 33,608 | +1.27% | 2,728 | 2,781 | +1.94% |
| SemanticKernel | 27,567 | 27,688 | +0.44% | 4,523 | 4,544 | +0.46% |
| Haystack | 24,620 | 24,812 | +0.78% | 2,675 | 2,707 | +1.20% |
| PydanticAI | 15,824 | 16,285 | +2.91% | 1,830 | 1,909 | +4.32% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9336)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present