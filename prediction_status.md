# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-09
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 44
**Data points**: 45

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 136,191 | 22,508 | 213 | 1.0000 | 0.3896 |
| AutoGen | 57,848 | 8,728 | 0 | 0.9276 | 0.3018 |
| Mem0 | 55,179 | 6,250 | 0 | 0.9236 | 0.2265 |
| CrewAI | 50,960 | 7,044 | 0 | 0.9168 | 0.2765 |
| LlamaIndex | 49,254 | 7,373 | 0 | 0.9140 | 0.2994 |
| LiteLLM | 46,251 | 7,880 | 2163 | 0.9086 | 0.9407 |
| DSPy | 34,289 | 2,879 | 0 | 0.8833 | 0.1679 |
| SemanticKernel | 27,862 | 4,592 | 0 | 0.8658 | 0.3296 |
| Haystack | 25,130 | 2,774 | 0 | 0.8570 | 0.2208 |
| PydanticAI | 16,943 | 2,043 | 0 | 0.8237 | 0.2412 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 136,191 | +3.81% | 21,601 | 22,508 | +4.20% |
| AutoGen | 56,243 | 57,848 | +2.85% | 8,453 | 8,728 | +3.25% |
| Mem0 | 51,132 | 55,179 | +7.91% | 5,717 | 6,250 | +9.32% |
| CrewAI | 47,278 | 50,960 | +7.79% | 6,385 | 7,044 | +10.32% |
| LlamaIndex | 48,012 | 49,254 | +2.59% | 7,093 | 7,373 | +3.95% |
| LiteLLM | 40,982 | 46,251 | +12.86% | 6,752 | 7,880 | +16.71% |
| DSPy | 33,187 | 34,289 | +3.32% | 2,728 | 2,879 | +5.54% |
| SemanticKernel | 27,567 | 27,862 | +1.07% | 4,523 | 4,592 | +1.53% |
| Haystack | 24,620 | 25,130 | +2.07% | 2,675 | 2,774 | +3.70% |
| PydanticAI | 15,824 | 16,943 | +7.07% | 1,830 | 2,043 | +11.64% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9407)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present