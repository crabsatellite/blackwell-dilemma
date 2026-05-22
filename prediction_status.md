# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-22
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 57
**Data points**: 58

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 137,347 | 22,723 | 238 | 1.0000 | 0.4200 |
| AutoGen | 58,279 | 8,798 | 0 | 0.9275 | 0.3019 |
| Mem0 | 56,400 | 6,431 | 0 | 0.9248 | 0.2280 |
| CrewAI | 51,932 | 7,199 | 0 | 0.9178 | 0.2772 |
| LlamaIndex | 49,572 | 7,445 | 0 | 0.9139 | 0.3004 |
| LiteLLM | 47,892 | 8,249 | 1602 | 0.9109 | 0.9445 |
| DSPy | 34,581 | 2,913 | 0 | 0.8834 | 0.1685 |
| SemanticKernel | 27,954 | 4,603 | 0 | 0.8654 | 0.3293 |
| Haystack | 25,333 | 2,802 | 0 | 0.8571 | 0.2212 |
| PydanticAI | 17,204 | 2,110 | 0 | 0.8244 | 0.2453 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 137,347 | +4.69% | 21,601 | 22,723 | +5.19% |
| AutoGen | 56,243 | 58,279 | +3.62% | 8,453 | 8,798 | +4.08% |
| Mem0 | 51,132 | 56,400 | +10.30% | 5,717 | 6,431 | +12.49% |
| CrewAI | 47,278 | 51,932 | +9.84% | 6,385 | 7,199 | +12.75% |
| LlamaIndex | 48,012 | 49,572 | +3.25% | 7,093 | 7,445 | +4.96% |
| LiteLLM | 40,982 | 47,892 | +16.86% | 6,752 | 8,249 | +22.17% |
| DSPy | 33,187 | 34,581 | +4.20% | 2,728 | 2,913 | +6.78% |
| SemanticKernel | 27,567 | 27,954 | +1.40% | 4,523 | 4,603 | +1.77% |
| Haystack | 24,620 | 25,333 | +2.90% | 2,675 | 2,802 | +4.75% |
| PydanticAI | 15,824 | 17,204 | +8.72% | 1,830 | 2,110 | +15.30% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9445)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present