# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-01
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 67
**Data points**: 68

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 138,172 | 22,893 | 166 | 1.0000 | 0.4563 |
| AutoGen | 58,587 | 8,850 | 0 | 0.9275 | 0.3021 |
| Mem0 | 57,253 | 6,538 | 0 | 0.9256 | 0.2284 |
| CrewAI | 52,567 | 7,327 | 0 | 0.9184 | 0.2788 |
| LlamaIndex | 49,817 | 7,496 | 0 | 0.9138 | 0.3009 |
| LiteLLM | 48,901 | 8,514 | 797 | 0.9122 | 0.9482 |
| DSPy | 34,760 | 2,944 | 0 | 0.8834 | 0.1694 |
| SemanticKernel | 28,021 | 4,624 | 0 | 0.8652 | 0.3300 |
| Haystack | 25,428 | 2,819 | 0 | 0.8570 | 0.2217 |
| PydanticAI | 17,431 | 2,159 | 0 | 0.8251 | 0.2477 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 138,172 | +5.32% | 21,601 | 22,893 | +5.98% |
| AutoGen | 56,243 | 58,587 | +4.17% | 8,453 | 8,850 | +4.70% |
| Mem0 | 51,132 | 57,253 | +11.97% | 5,717 | 6,538 | +14.36% |
| CrewAI | 47,278 | 52,567 | +11.19% | 6,385 | 7,327 | +14.75% |
| LlamaIndex | 48,012 | 49,817 | +3.76% | 7,093 | 7,496 | +5.68% |
| LiteLLM | 40,982 | 48,901 | +19.32% | 6,752 | 8,514 | +26.10% |
| DSPy | 33,187 | 34,760 | +4.74% | 2,728 | 2,944 | +7.92% |
| SemanticKernel | 27,567 | 28,021 | +1.65% | 4,523 | 4,624 | +2.23% |
| Haystack | 24,620 | 25,428 | +3.28% | 2,675 | 2,819 | +5.38% |
| PydanticAI | 15,824 | 17,431 | +10.16% | 1,830 | 2,159 | +17.98% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9482)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present