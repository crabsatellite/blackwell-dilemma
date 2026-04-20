# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-20
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 25
**Data points**: 26

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 134,120 | 22,163 | 176 | 1.0000 | 0.4137 |
| AutoGen | 57,223 | 8,624 | 0 | 0.9279 | 0.3014 |
| Mem0 | 53,559 | 6,005 | 0 | 0.9223 | 0.2242 |
| CrewAI | 49,277 | 6,744 | 0 | 0.9152 | 0.2737 |
| LlamaIndex | 48,694 | 7,228 | 0 | 0.9142 | 0.2969 |
| LiteLLM | 43,939 | 7,373 | 1269 | 0.9055 | 0.9356 |
| DSPy | 33,836 | 2,814 | 20 | 0.8834 | 0.1758 |
| SemanticKernel | 27,745 | 4,560 | 0 | 0.8665 | 0.3287 |
| Haystack | 24,910 | 2,724 | 0 | 0.8574 | 0.2187 |
| PydanticAI | 16,490 | 1,952 | 0 | 0.8225 | 0.2367 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 134,120 | +2.23% | 21,601 | 22,163 | +2.60% |
| AutoGen | 56,243 | 57,223 | +1.74% | 8,453 | 8,624 | +2.02% |
| Mem0 | 51,132 | 53,559 | +4.75% | 5,717 | 6,005 | +5.04% |
| CrewAI | 47,278 | 49,277 | +4.23% | 6,385 | 6,744 | +5.62% |
| LlamaIndex | 48,012 | 48,694 | +1.42% | 7,093 | 7,228 | +1.90% |
| LiteLLM | 40,982 | 43,939 | +7.22% | 6,752 | 7,373 | +9.20% |
| DSPy | 33,187 | 33,836 | +1.96% | 2,728 | 2,814 | +3.15% |
| SemanticKernel | 27,567 | 27,745 | +0.65% | 4,523 | 4,560 | +0.82% |
| Haystack | 24,620 | 24,910 | +1.18% | 2,675 | 2,724 | +1.83% |
| PydanticAI | 15,824 | 16,490 | +4.21% | 1,830 | 1,952 | +6.67% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9356)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present