# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-11
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 77
**Data points**: 78

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 139,010 | 23,034 | 245 | 1.0000 | 0.4860 |
| AutoGen | 58,861 | 8,881 | 0 | 0.9274 | 0.3018 |
| Mem0 | 58,314 | 6,698 | 65 | 0.9266 | 0.2707 |
| CrewAI | 53,247 | 7,448 | 0 | 0.9190 | 0.2798 |
| LlamaIndex | 50,071 | 7,537 | 0 | 0.9138 | 0.3011 |
| LiteLLM | 49,992 | 8,780 | 951 | 0.9136 | 0.9513 |
| DSPy | 34,983 | 2,976 | 0 | 0.8835 | 0.1701 |
| SemanticKernel | 28,099 | 4,641 | 0 | 0.8650 | 0.3303 |
| Haystack | 25,529 | 2,839 | 0 | 0.8569 | 0.2224 |
| PydanticAI | 17,693 | 2,204 | 0 | 0.8259 | 0.2491 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 139,010 | +5.96% | 21,601 | 23,034 | +6.63% |
| AutoGen | 56,243 | 58,861 | +4.65% | 8,453 | 8,881 | +5.06% |
| Mem0 | 51,132 | 58,314 | +14.05% | 5,717 | 6,698 | +17.16% |
| CrewAI | 47,278 | 53,247 | +12.63% | 6,385 | 7,448 | +16.65% |
| LlamaIndex | 48,012 | 50,071 | +4.29% | 7,093 | 7,537 | +6.26% |
| LiteLLM | 40,982 | 49,992 | +21.99% | 6,752 | 8,780 | +30.04% |
| DSPy | 33,187 | 34,983 | +5.41% | 2,728 | 2,976 | +9.09% |
| SemanticKernel | 27,567 | 28,099 | +1.93% | 4,523 | 4,641 | +2.61% |
| Haystack | 24,620 | 25,529 | +3.69% | 2,675 | 2,839 | +6.13% |
| PydanticAI | 15,824 | 17,693 | +11.81% | 1,830 | 2,204 | +20.44% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9513)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present