# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-05
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 10
**Data points**: 11

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 132,395 | 21,842 | 175 | 1.0000 | 0.4059 |
| AutoGen | 56,700 | 8,525 | 0 | 0.9281 | 0.3007 |
| Mem0 | 51,985 | 5,820 | 0 | 0.9207 | 0.2239 |
| LlamaIndex | 48,300 | 7,161 | 0 | 0.9145 | 0.2965 |
| CrewAI | 48,050 | 6,542 | 0 | 0.9141 | 0.2723 |
| LiteLLM | 42,191 | 6,996 | 1383 | 0.9030 | 0.9316 |
| DSPy | 33,448 | 2,757 | 0 | 0.8833 | 0.1649 |
| SemanticKernel | 27,650 | 4,535 | 0 | 0.8672 | 0.3280 |
| Haystack | 24,714 | 2,696 | 0 | 0.8577 | 0.2182 |
| PydanticAI | 16,100 | 1,873 | 0 | 0.8214 | 0.2327 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 132,395 | +0.92% | 21,601 | 21,842 | +1.12% |
| AutoGen | 56,243 | 56,700 | +0.81% | 8,453 | 8,525 | +0.85% |
| Mem0 | 51,132 | 51,985 | +1.67% | 5,717 | 5,820 | +1.80% |
| LlamaIndex | 48,012 | 48,300 | +0.60% | 7,093 | 7,161 | +0.96% |
| CrewAI | 47,278 | 48,050 | +1.63% | 6,385 | 6,542 | +2.46% |
| LiteLLM | 40,982 | 42,191 | +2.95% | 6,752 | 6,996 | +3.61% |
| DSPy | 33,187 | 33,448 | +0.79% | 2,728 | 2,757 | +1.06% |
| SemanticKernel | 27,567 | 27,650 | +0.30% | 4,523 | 4,535 | +0.27% |
| Haystack | 24,620 | 24,714 | +0.38% | 2,675 | 2,696 | +0.79% |
| PydanticAI | 15,824 | 16,100 | +1.74% | 1,830 | 1,873 | +2.35% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9316)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present