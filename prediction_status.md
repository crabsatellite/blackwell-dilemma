# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-11
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 46
**Data points**: 47

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 136,367 | 22,541 | 158 | 1.0000 | 0.3871 |
| AutoGen | 57,913 | 8,738 | 0 | 0.9276 | 0.3018 |
| Mem0 | 55,354 | 6,272 | 0 | 0.9237 | 0.2266 |
| CrewAI | 51,125 | 7,068 | 0 | 0.9170 | 0.2765 |
| LlamaIndex | 49,326 | 7,386 | 0 | 0.9140 | 0.2995 |
| LiteLLM | 46,485 | 7,928 | 1678 | 0.9090 | 0.9411 |
| DSPy | 34,325 | 2,881 | 0 | 0.8833 | 0.1679 |
| SemanticKernel | 27,879 | 4,594 | 0 | 0.8657 | 0.3296 |
| Haystack | 25,144 | 2,777 | 0 | 0.8570 | 0.2209 |
| PydanticAI | 16,983 | 2,053 | 0 | 0.8238 | 0.2418 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 136,367 | +3.95% | 21,601 | 22,541 | +4.35% |
| AutoGen | 56,243 | 57,913 | +2.97% | 8,453 | 8,738 | +3.37% |
| Mem0 | 51,132 | 55,354 | +8.26% | 5,717 | 6,272 | +9.71% |
| CrewAI | 47,278 | 51,125 | +8.14% | 6,385 | 7,068 | +10.70% |
| LlamaIndex | 48,012 | 49,326 | +2.74% | 7,093 | 7,386 | +4.13% |
| LiteLLM | 40,982 | 46,485 | +13.43% | 6,752 | 7,928 | +17.42% |
| DSPy | 33,187 | 34,325 | +3.43% | 2,728 | 2,881 | +5.61% |
| SemanticKernel | 27,567 | 27,879 | +1.13% | 4,523 | 4,594 | +1.57% |
| Haystack | 24,620 | 25,144 | +2.13% | 2,675 | 2,777 | +3.81% |
| PydanticAI | 15,824 | 16,983 | +7.32% | 1,830 | 2,053 | +12.19% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9411)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present