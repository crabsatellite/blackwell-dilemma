# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-24
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 59
**Data points**: 60

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 137,507 | 22,753 | 184 | 1.0000 | 0.4467 |
| AutoGen | 58,330 | 8,806 | 0 | 0.9275 | 0.3019 |
| Mem0 | 56,552 | 6,446 | 0 | 0.9249 | 0.2280 |
| CrewAI | 52,058 | 7,211 | 0 | 0.9179 | 0.2770 |
| LlamaIndex | 49,621 | 7,450 | 0 | 0.9139 | 0.3003 |
| LiteLLM | 48,050 | 8,297 | 954 | 0.9111 | 0.9453 |
| DSPy | 34,605 | 2,918 | 0 | 0.8834 | 0.1686 |
| SemanticKernel | 27,965 | 4,604 | 0 | 0.8654 | 0.3293 |
| Haystack | 25,358 | 2,804 | 0 | 0.8571 | 0.2212 |
| PydanticAI | 17,249 | 2,125 | 0 | 0.8245 | 0.2464 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 137,507 | +4.82% | 21,601 | 22,753 | +5.33% |
| AutoGen | 56,243 | 58,330 | +3.71% | 8,453 | 8,806 | +4.18% |
| Mem0 | 51,132 | 56,552 | +10.60% | 5,717 | 6,446 | +12.75% |
| CrewAI | 47,278 | 52,058 | +10.11% | 6,385 | 7,211 | +12.94% |
| LlamaIndex | 48,012 | 49,621 | +3.35% | 7,093 | 7,450 | +5.03% |
| LiteLLM | 40,982 | 48,050 | +17.25% | 6,752 | 8,297 | +22.88% |
| DSPy | 33,187 | 34,605 | +4.27% | 2,728 | 2,918 | +6.96% |
| SemanticKernel | 27,567 | 27,965 | +1.44% | 4,523 | 4,604 | +1.79% |
| Haystack | 24,620 | 25,358 | +3.00% | 2,675 | 2,804 | +4.82% |
| PydanticAI | 15,824 | 17,249 | +9.01% | 1,830 | 2,125 | +16.12% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9453)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present