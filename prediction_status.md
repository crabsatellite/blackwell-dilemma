# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-20
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 55
**Data points**: 56

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 137,171 | 22,692 | 220 | 1.0000 | 0.4187 |
| AutoGen | 58,196 | 8,790 | 0 | 0.9275 | 0.3021 |
| Mem0 | 56,212 | 6,399 | 0 | 0.9246 | 0.2277 |
| CrewAI | 51,769 | 7,170 | 0 | 0.9176 | 0.2770 |
| LlamaIndex | 49,519 | 7,431 | 0 | 0.9139 | 0.3001 |
| LiteLLM | 47,635 | 8,184 | 1502 | 0.9106 | 0.9436 |
| DSPy | 34,536 | 2,909 | 0 | 0.8834 | 0.1685 |
| SemanticKernel | 27,941 | 4,601 | 0 | 0.8655 | 0.3293 |
| Haystack | 25,302 | 2,795 | 0 | 0.8571 | 0.2209 |
| PydanticAI | 17,157 | 2,096 | 0 | 0.8243 | 0.2443 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 137,171 | +4.56% | 21,601 | 22,692 | +5.05% |
| AutoGen | 56,243 | 58,196 | +3.47% | 8,453 | 8,790 | +3.99% |
| Mem0 | 51,132 | 56,212 | +9.94% | 5,717 | 6,399 | +11.93% |
| CrewAI | 47,278 | 51,769 | +9.50% | 6,385 | 7,170 | +12.29% |
| LlamaIndex | 48,012 | 49,519 | +3.14% | 7,093 | 7,431 | +4.77% |
| LiteLLM | 40,982 | 47,635 | +16.23% | 6,752 | 8,184 | +21.21% |
| DSPy | 33,187 | 34,536 | +4.06% | 2,728 | 2,909 | +6.63% |
| SemanticKernel | 27,567 | 27,941 | +1.36% | 4,523 | 4,601 | +1.72% |
| Haystack | 24,620 | 25,302 | +2.77% | 2,675 | 2,795 | +4.49% |
| PydanticAI | 15,824 | 17,157 | +8.42% | 1,830 | 2,096 | +14.54% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9436)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present