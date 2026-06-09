# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-09
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 75
**Data points**: 76

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 138,849 | 22,990 | 172 | 1.0000 | 0.4486 |
| AutoGen | 58,792 | 8,874 | 0 | 0.9274 | 0.3019 |
| Mem0 | 58,111 | 6,671 | 0 | 0.9264 | 0.2296 |
| CrewAI | 53,111 | 7,428 | 0 | 0.9188 | 0.2797 |
| LlamaIndex | 50,020 | 7,526 | 0 | 0.9138 | 0.3009 |
| LiteLLM | 49,734 | 8,710 | 879 | 0.9133 | 0.9503 |
| DSPy | 34,938 | 2,967 | 0 | 0.8835 | 0.1698 |
| SemanticKernel | 28,084 | 4,637 | 0 | 0.8650 | 0.3302 |
| Haystack | 25,502 | 2,833 | 0 | 0.8569 | 0.2222 |
| PydanticAI | 17,635 | 2,195 | 0 | 0.8257 | 0.2489 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 138,849 | +5.84% | 21,601 | 22,990 | +6.43% |
| AutoGen | 56,243 | 58,792 | +4.53% | 8,453 | 8,874 | +4.98% |
| Mem0 | 51,132 | 58,111 | +13.65% | 5,717 | 6,671 | +16.69% |
| CrewAI | 47,278 | 53,111 | +12.34% | 6,385 | 7,428 | +16.34% |
| LlamaIndex | 48,012 | 50,020 | +4.18% | 7,093 | 7,526 | +6.10% |
| LiteLLM | 40,982 | 49,734 | +21.36% | 6,752 | 8,710 | +29.00% |
| DSPy | 33,187 | 34,938 | +5.28% | 2,728 | 2,967 | +8.76% |
| SemanticKernel | 27,567 | 28,084 | +1.88% | 4,523 | 4,637 | +2.52% |
| Haystack | 24,620 | 25,502 | +3.58% | 2,675 | 2,833 | +5.91% |
| PydanticAI | 15,824 | 17,635 | +11.44% | 1,830 | 2,195 | +19.95% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9503)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present