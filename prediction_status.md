# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-31
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 66
**Data points**: 67

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 138,078 | 22,877 | 166 | 1.0000 | 0.4563 |
| AutoGen | 58,553 | 8,846 | 0 | 0.9275 | 0.3022 |
| Mem0 | 57,172 | 6,526 | 0 | 0.9255 | 0.2283 |
| CrewAI | 52,500 | 7,312 | 0 | 0.9183 | 0.2786 |
| LlamaIndex | 49,788 | 7,490 | 0 | 0.9138 | 0.3009 |
| LiteLLM | 48,804 | 8,496 | 797 | 0.9121 | 0.9482 |
| DSPy | 34,739 | 2,944 | 0 | 0.8834 | 0.1695 |
| SemanticKernel | 28,012 | 4,622 | 0 | 0.8652 | 0.3300 |
| Haystack | 25,417 | 2,816 | 0 | 0.8570 | 0.2216 |
| PydanticAI | 17,406 | 2,159 | 0 | 0.8250 | 0.2481 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 138,078 | +5.25% | 21,601 | 22,877 | +5.91% |
| AutoGen | 56,243 | 58,553 | +4.11% | 8,453 | 8,846 | +4.65% |
| Mem0 | 51,132 | 57,172 | +11.81% | 5,717 | 6,526 | +14.15% |
| CrewAI | 47,278 | 52,500 | +11.05% | 6,385 | 7,312 | +14.52% |
| LlamaIndex | 48,012 | 49,788 | +3.70% | 7,093 | 7,490 | +5.60% |
| LiteLLM | 40,982 | 48,804 | +19.09% | 6,752 | 8,496 | +25.83% |
| DSPy | 33,187 | 34,739 | +4.68% | 2,728 | 2,944 | +7.92% |
| SemanticKernel | 27,567 | 28,012 | +1.61% | 4,523 | 4,622 | +2.19% |
| Haystack | 24,620 | 25,417 | +3.24% | 2,675 | 2,816 | +5.27% |
| PydanticAI | 15,824 | 17,406 | +10.00% | 1,830 | 2,159 | +17.98% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9482)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present