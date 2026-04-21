# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-21
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 26
**Data points**: 27

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 134,269 | 22,182 | 180 | 1.0000 | 0.4127 |
| AutoGen | 57,259 | 8,629 | 0 | 0.9278 | 0.3014 |
| Mem0 | 53,655 | 6,011 | 0 | 0.9223 | 0.2241 |
| CrewAI | 49,372 | 6,758 | 0 | 0.9153 | 0.2738 |
| LlamaIndex | 48,738 | 7,260 | 45 | 0.9142 | 0.3185 |
| LiteLLM | 44,081 | 7,412 | 1313 | 0.9057 | 0.9363 |
| DSPy | 33,877 | 2,819 | 0 | 0.8834 | 0.1664 |
| SemanticKernel | 27,750 | 4,563 | 0 | 0.8665 | 0.3289 |
| Haystack | 24,922 | 2,726 | 0 | 0.8574 | 0.2188 |
| PydanticAI | 16,508 | 1,954 | 0 | 0.8225 | 0.2367 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 134,269 | +2.35% | 21,601 | 22,182 | +2.69% |
| AutoGen | 56,243 | 57,259 | +1.81% | 8,453 | 8,629 | +2.08% |
| Mem0 | 51,132 | 53,655 | +4.93% | 5,717 | 6,011 | +5.14% |
| CrewAI | 47,278 | 49,372 | +4.43% | 6,385 | 6,758 | +5.84% |
| LlamaIndex | 48,012 | 48,738 | +1.51% | 7,093 | 7,260 | +2.35% |
| LiteLLM | 40,982 | 44,081 | +7.56% | 6,752 | 7,412 | +9.77% |
| DSPy | 33,187 | 33,877 | +2.08% | 2,728 | 2,819 | +3.34% |
| SemanticKernel | 27,567 | 27,750 | +0.66% | 4,523 | 4,563 | +0.88% |
| Haystack | 24,620 | 24,922 | +1.23% | 2,675 | 2,726 | +1.91% |
| PydanticAI | 15,824 | 16,508 | +4.32% | 1,830 | 1,954 | +6.78% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9363)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present