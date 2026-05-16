# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-16
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 51
**Data points**: 52

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 136,843 | 22,634 | 202 | 1.0000 | 0.3933 |
| AutoGen | 58,064 | 8,762 | 0 | 0.9275 | 0.3018 |
| Mem0 | 55,820 | 6,350 | 0 | 0.9242 | 0.2275 |
| CrewAI | 51,494 | 7,122 | 0 | 0.9174 | 0.2766 |
| LlamaIndex | 49,440 | 7,418 | 0 | 0.9139 | 0.3001 |
| LiteLLM | 47,159 | 8,085 | 1938 | 0.9099 | 0.9429 |
| DSPy | 34,452 | 2,892 | 0 | 0.8834 | 0.1679 |
| SemanticKernel | 27,911 | 4,602 | 0 | 0.8656 | 0.3298 |
| Haystack | 25,244 | 2,783 | 0 | 0.8571 | 0.2205 |
| PydanticAI | 17,084 | 2,086 | 0 | 0.8241 | 0.2442 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 136,843 | +4.31% | 21,601 | 22,634 | +4.78% |
| AutoGen | 56,243 | 58,064 | +3.24% | 8,453 | 8,762 | +3.66% |
| Mem0 | 51,132 | 55,820 | +9.17% | 5,717 | 6,350 | +11.07% |
| CrewAI | 47,278 | 51,494 | +8.92% | 6,385 | 7,122 | +11.54% |
| LlamaIndex | 48,012 | 49,440 | +2.97% | 7,093 | 7,418 | +4.58% |
| LiteLLM | 40,982 | 47,159 | +15.07% | 6,752 | 8,085 | +19.74% |
| DSPy | 33,187 | 34,452 | +3.81% | 2,728 | 2,892 | +6.01% |
| SemanticKernel | 27,567 | 27,911 | +1.25% | 4,523 | 4,602 | +1.75% |
| Haystack | 24,620 | 25,244 | +2.53% | 2,675 | 2,783 | +4.04% |
| PydanticAI | 15,824 | 17,084 | +7.96% | 1,830 | 2,086 | +13.99% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9429)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present