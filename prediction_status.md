# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-14
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 19
**Data points**: 20

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 133,473 | 22,051 | 161 | 1.0000 | 0.4310 |
| AutoGen | 57,064 | 8,590 | 0 | 0.9280 | 0.3011 |
| Mem0 | 52,974 | 5,941 | 0 | 0.9217 | 0.2243 |
| CrewAI | 48,826 | 6,667 | 184 | 0.9148 | 0.3881 |
| LlamaIndex | 48,564 | 7,197 | 0 | 0.9143 | 0.2964 |
| LiteLLM | 43,209 | 7,221 | 960 | 0.9044 | 0.9342 |
| DSPy | 33,672 | 2,790 | 0 | 0.8833 | 0.1657 |
| SemanticKernel | 27,700 | 4,549 | 0 | 0.8668 | 0.3284 |
| Haystack | 24,830 | 2,716 | 0 | 0.8575 | 0.2188 |
| PydanticAI | 16,341 | 1,934 | 0 | 0.8220 | 0.2367 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 133,473 | +1.74% | 21,601 | 22,051 | +2.08% |
| AutoGen | 56,243 | 57,064 | +1.46% | 8,453 | 8,590 | +1.62% |
| Mem0 | 51,132 | 52,974 | +3.60% | 5,717 | 5,941 | +3.92% |
| CrewAI | 47,278 | 48,826 | +3.27% | 6,385 | 6,667 | +4.42% |
| LlamaIndex | 48,012 | 48,564 | +1.15% | 7,093 | 7,197 | +1.47% |
| LiteLLM | 40,982 | 43,209 | +5.43% | 6,752 | 7,221 | +6.95% |
| DSPy | 33,187 | 33,672 | +1.46% | 2,728 | 2,790 | +2.27% |
| SemanticKernel | 27,567 | 27,700 | +0.48% | 4,523 | 4,549 | +0.57% |
| Haystack | 24,620 | 24,830 | +0.85% | 2,675 | 2,716 | +1.53% |
| PydanticAI | 15,824 | 16,341 | +3.27% | 1,830 | 1,934 | +5.68% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9342)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present