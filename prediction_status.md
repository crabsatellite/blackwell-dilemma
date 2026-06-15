# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-15
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 81
**Data points**: 82

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 139,331 | 23,093 | 203 | 1.0000 | 0.4884 |
| AutoGen | 58,960 | 8,896 | 0 | 0.9274 | 0.3018 |
| Mem0 | 58,586 | 6,730 | 0 | 0.9269 | 0.2297 |
| CrewAI | 53,577 | 7,501 | 0 | 0.9193 | 0.2800 |
| LiteLLM | 50,415 | 8,881 | 776 | 0.9142 | 0.9523 |
| LlamaIndex | 50,134 | 7,563 | 0 | 0.9137 | 0.3017 |
| DSPy | 35,036 | 2,976 | 0 | 0.8835 | 0.1699 |
| SemanticKernel | 28,120 | 4,649 | 0 | 0.8649 | 0.3307 |
| Haystack | 25,569 | 2,854 | 0 | 0.8569 | 0.2232 |
| PydanticAI | 17,761 | 2,216 | 0 | 0.8261 | 0.2495 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 139,331 | +6.21% | 21,601 | 23,093 | +6.91% |
| AutoGen | 56,243 | 58,960 | +4.83% | 8,453 | 8,896 | +5.24% |
| Mem0 | 51,132 | 58,586 | +14.58% | 5,717 | 6,730 | +17.72% |
| CrewAI | 47,278 | 53,577 | +13.32% | 6,385 | 7,501 | +17.48% |
| LiteLLM | 40,982 | 50,415 | +23.02% | 6,752 | 8,881 | +31.53% |
| LlamaIndex | 48,012 | 50,134 | +4.42% | 7,093 | 7,563 | +6.63% |
| DSPy | 33,187 | 35,036 | +5.57% | 2,728 | 2,976 | +9.09% |
| SemanticKernel | 27,567 | 28,120 | +2.01% | 4,523 | 4,649 | +2.79% |
| Haystack | 24,620 | 25,569 | +3.85% | 2,675 | 2,854 | +6.69% |
| PydanticAI | 15,824 | 17,761 | +12.24% | 1,830 | 2,216 | +21.09% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9523)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present