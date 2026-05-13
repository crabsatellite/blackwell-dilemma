# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-13
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 48
**Data points**: 49

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 136,592 | 22,591 | 167 | 1.0000 | 0.3874 |
| AutoGen | 57,989 | 8,743 | 0 | 0.9275 | 0.3015 |
| Mem0 | 55,547 | 6,316 | 0 | 0.9239 | 0.2274 |
| CrewAI | 51,297 | 7,097 | 0 | 0.9172 | 0.2767 |
| LlamaIndex | 49,374 | 7,399 | 0 | 0.9139 | 0.2997 |
| LiteLLM | 46,755 | 7,998 | 1771 | 0.9093 | 0.9421 |
| DSPy | 34,382 | 2,884 | 0 | 0.8833 | 0.1678 |
| SemanticKernel | 27,896 | 4,594 | 0 | 0.8657 | 0.3294 |
| Haystack | 25,209 | 2,783 | 0 | 0.8571 | 0.2208 |
| PydanticAI | 17,036 | 2,066 | 0 | 0.8240 | 0.2425 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 136,592 | +4.12% | 21,601 | 22,591 | +4.58% |
| AutoGen | 56,243 | 57,989 | +3.10% | 8,453 | 8,743 | +3.43% |
| Mem0 | 51,132 | 55,547 | +8.63% | 5,717 | 6,316 | +10.48% |
| CrewAI | 47,278 | 51,297 | +8.50% | 6,385 | 7,097 | +11.15% |
| LlamaIndex | 48,012 | 49,374 | +2.84% | 7,093 | 7,399 | +4.31% |
| LiteLLM | 40,982 | 46,755 | +14.09% | 6,752 | 7,998 | +18.45% |
| DSPy | 33,187 | 34,382 | +3.60% | 2,728 | 2,884 | +5.72% |
| SemanticKernel | 27,567 | 27,896 | +1.19% | 4,523 | 4,594 | +1.57% |
| Haystack | 24,620 | 25,209 | +2.39% | 2,675 | 2,783 | +4.04% |
| PydanticAI | 15,824 | 17,036 | +7.66% | 1,830 | 2,066 | +12.90% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9421)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present