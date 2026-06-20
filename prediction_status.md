# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-20
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 86
**Data points**: 87

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 139,736 | 23,169 | 315 | 1.0000 | 0.5285 |
| AutoGen | 59,080 | 8,914 | 0 | 0.9273 | 0.3018 |
| Mem0 | 58,953 | 6,794 | 0 | 0.9272 | 0.2305 |
| CrewAI | 54,007 | 7,558 | 0 | 0.9198 | 0.2799 |
| LiteLLM | 50,938 | 9,011 | 960 | 0.9148 | 0.9538 |
| LlamaIndex | 50,232 | 7,588 | 0 | 0.9136 | 0.3021 |
| DSPy | 35,161 | 2,983 | 0 | 0.8835 | 0.1697 |
| SemanticKernel | 28,166 | 4,657 | 0 | 0.8648 | 0.3307 |
| Haystack | 25,614 | 2,867 | 0 | 0.8568 | 0.2239 |
| PydanticAI | 17,863 | 2,236 | 0 | 0.8264 | 0.2503 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 139,736 | +6.51% | 21,601 | 23,169 | +7.26% |
| AutoGen | 56,243 | 59,080 | +5.04% | 8,453 | 8,914 | +5.45% |
| Mem0 | 51,132 | 58,953 | +15.30% | 5,717 | 6,794 | +18.84% |
| CrewAI | 47,278 | 54,007 | +14.23% | 6,385 | 7,558 | +18.37% |
| LiteLLM | 40,982 | 50,938 | +24.29% | 6,752 | 9,011 | +33.46% |
| LlamaIndex | 48,012 | 50,232 | +4.62% | 7,093 | 7,588 | +6.98% |
| DSPy | 33,187 | 35,161 | +5.95% | 2,728 | 2,983 | +9.35% |
| SemanticKernel | 27,567 | 28,166 | +2.17% | 4,523 | 4,657 | +2.96% |
| Haystack | 24,620 | 25,614 | +4.04% | 2,675 | 2,867 | +7.18% |
| PydanticAI | 15,824 | 17,863 | +12.89% | 1,830 | 2,236 | +22.19% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9538)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present