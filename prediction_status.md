# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-30
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 35
**Data points**: 36

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 135,437 | 22,386 | 192 | 1.0000 | 0.4046 |
| AutoGen | 57,589 | 8,680 | 0 | 0.9276 | 0.3014 |
| Mem0 | 54,439 | 6,137 | 0 | 0.9229 | 0.2255 |
| CrewAI | 50,321 | 6,929 | 0 | 0.9162 | 0.2754 |
| LlamaIndex | 49,048 | 7,333 | 0 | 0.9140 | 0.2990 |
| LiteLLM | 45,268 | 7,672 | 1556 | 0.9073 | 0.9390 |
| DSPy | 34,103 | 2,858 | 0 | 0.8833 | 0.1676 |
| SemanticKernel | 27,818 | 4,578 | 0 | 0.8660 | 0.3291 |
| Haystack | 25,027 | 2,749 | 0 | 0.8571 | 0.2197 |
| PydanticAI | 16,745 | 2,001 | 0 | 0.8231 | 0.2390 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 135,437 | +3.24% | 21,601 | 22,386 | +3.63% |
| AutoGen | 56,243 | 57,589 | +2.39% | 8,453 | 8,680 | +2.69% |
| Mem0 | 51,132 | 54,439 | +6.47% | 5,717 | 6,137 | +7.35% |
| CrewAI | 47,278 | 50,321 | +6.44% | 6,385 | 6,929 | +8.52% |
| LlamaIndex | 48,012 | 49,048 | +2.16% | 7,093 | 7,333 | +3.38% |
| LiteLLM | 40,982 | 45,268 | +10.46% | 6,752 | 7,672 | +13.63% |
| DSPy | 33,187 | 34,103 | +2.76% | 2,728 | 2,858 | +4.77% |
| SemanticKernel | 27,567 | 27,818 | +0.91% | 4,523 | 4,578 | +1.22% |
| Haystack | 24,620 | 25,027 | +1.65% | 2,675 | 2,749 | +2.77% |
| PydanticAI | 15,824 | 16,745 | +5.82% | 1,830 | 2,001 | +9.34% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9390)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present