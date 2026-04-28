# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-28
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 33
**Data points**: 34

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 135,186 | 22,350 | 176 | 1.0000 | 0.4053 |
| AutoGen | 57,516 | 8,665 | 0 | 0.9277 | 0.3013 |
| Mem0 | 54,259 | 6,106 | 0 | 0.9227 | 0.2251 |
| CrewAI | 50,131 | 6,897 | 0 | 0.9160 | 0.2752 |
| LlamaIndex | 48,993 | 7,324 | 0 | 0.9141 | 0.2990 |
| LiteLLM | 44,977 | 7,621 | 1414 | 0.9069 | 0.9389 |
| DSPy | 34,039 | 2,845 | 0 | 0.8833 | 0.1672 |
| SemanticKernel | 27,796 | 4,574 | 0 | 0.8661 | 0.3291 |
| Haystack | 25,005 | 2,742 | 0 | 0.8572 | 0.2193 |
| PydanticAI | 16,691 | 1,993 | 0 | 0.8230 | 0.2388 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 135,186 | +3.05% | 21,601 | 22,350 | +3.47% |
| AutoGen | 56,243 | 57,516 | +2.26% | 8,453 | 8,665 | +2.51% |
| Mem0 | 51,132 | 54,259 | +6.12% | 5,717 | 6,106 | +6.80% |
| CrewAI | 47,278 | 50,131 | +6.03% | 6,385 | 6,897 | +8.02% |
| LlamaIndex | 48,012 | 48,993 | +2.04% | 7,093 | 7,324 | +3.26% |
| LiteLLM | 40,982 | 44,977 | +9.75% | 6,752 | 7,621 | +12.87% |
| DSPy | 33,187 | 34,039 | +2.57% | 2,728 | 2,845 | +4.29% |
| SemanticKernel | 27,567 | 27,796 | +0.83% | 4,523 | 4,574 | +1.13% |
| Haystack | 24,620 | 25,005 | +1.56% | 2,675 | 2,742 | +2.50% |
| PydanticAI | 15,824 | 16,691 | +5.48% | 1,830 | 1,993 | +8.91% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9389)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present