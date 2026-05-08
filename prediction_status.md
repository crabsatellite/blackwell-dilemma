# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-08
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 43
**Data points**: 44

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 136,092 | 22,491 | 209 | 1.0000 | 0.3889 |
| AutoGen | 57,814 | 8,722 | 0 | 0.9276 | 0.3017 |
| Mem0 | 55,049 | 6,239 | 0 | 0.9234 | 0.2267 |
| CrewAI | 50,866 | 7,022 | 0 | 0.9167 | 0.2761 |
| LlamaIndex | 49,230 | 7,372 | 0 | 0.9140 | 0.2995 |
| LiteLLM | 46,107 | 7,849 | 2150 | 0.9084 | 0.9405 |
| DSPy | 34,270 | 2,881 | 0 | 0.8833 | 0.1681 |
| SemanticKernel | 27,857 | 4,590 | 0 | 0.8658 | 0.3295 |
| Haystack | 25,112 | 2,771 | 0 | 0.8570 | 0.2207 |
| PydanticAI | 16,923 | 2,038 | 0 | 0.8237 | 0.2409 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 136,092 | +3.74% | 21,601 | 22,491 | +4.12% |
| AutoGen | 56,243 | 57,814 | +2.79% | 8,453 | 8,722 | +3.18% |
| Mem0 | 51,132 | 55,049 | +7.66% | 5,717 | 6,239 | +9.13% |
| CrewAI | 47,278 | 50,866 | +7.59% | 6,385 | 7,022 | +9.98% |
| LlamaIndex | 48,012 | 49,230 | +2.54% | 7,093 | 7,372 | +3.93% |
| LiteLLM | 40,982 | 46,107 | +12.51% | 6,752 | 7,849 | +16.25% |
| DSPy | 33,187 | 34,270 | +3.26% | 2,728 | 2,881 | +5.61% |
| SemanticKernel | 27,567 | 27,857 | +1.05% | 4,523 | 4,590 | +1.48% |
| Haystack | 24,620 | 25,112 | +2.00% | 2,675 | 2,771 | +3.59% |
| PydanticAI | 15,824 | 16,923 | +6.95% | 1,830 | 2,038 | +11.37% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9405)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present