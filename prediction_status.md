# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-09
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 14
**Data points**: 15

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 132,853 | 21,922 | 208 | 1.0000 | 0.4157 |
| AutoGen | 56,842 | 8,549 | 0 | 0.9280 | 0.3008 |
| Mem0 | 52,381 | 5,875 | 0 | 0.9211 | 0.2243 |
| LlamaIndex | 48,421 | 7,179 | 97 | 0.9144 | 0.3365 |
| CrewAI | 48,390 | 6,600 | 0 | 0.9144 | 0.2728 |
| LiteLLM | 42,633 | 7,086 | 1457 | 0.9037 | 0.9324 |
| DSPy | 33,548 | 2,769 | 0 | 0.8833 | 0.1651 |
| SemanticKernel | 27,671 | 4,538 | 0 | 0.8670 | 0.3280 |
| Haystack | 24,769 | 2,703 | 0 | 0.8576 | 0.2183 |
| PydanticAI | 16,183 | 1,889 | 97 | 0.8215 | 0.2734 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 132,853 | +1.27% | 21,601 | 21,922 | +1.49% |
| AutoGen | 56,243 | 56,842 | +1.07% | 8,453 | 8,549 | +1.14% |
| Mem0 | 51,132 | 52,381 | +2.44% | 5,717 | 5,875 | +2.76% |
| LlamaIndex | 48,012 | 48,421 | +0.85% | 7,093 | 7,179 | +1.21% |
| CrewAI | 47,278 | 48,390 | +2.35% | 6,385 | 6,600 | +3.37% |
| LiteLLM | 40,982 | 42,633 | +4.03% | 6,752 | 7,086 | +4.95% |
| DSPy | 33,187 | 33,548 | +1.09% | 2,728 | 2,769 | +1.50% |
| SemanticKernel | 27,567 | 27,671 | +0.38% | 4,523 | 4,538 | +0.33% |
| Haystack | 24,620 | 24,769 | +0.61% | 2,675 | 2,703 | +1.05% |
| PydanticAI | 15,824 | 16,183 | +2.27% | 1,830 | 1,889 | +3.22% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9324)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present