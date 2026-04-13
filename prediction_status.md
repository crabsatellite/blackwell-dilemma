# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-13
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 18
**Data points**: 19

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 133,327 | 22,032 | 159 | 1.0000 | 0.4430 |
| AutoGen | 57,021 | 8,582 | 0 | 0.9280 | 0.3010 |
| Mem0 | 52,832 | 5,922 | 0 | 0.9216 | 0.2242 |
| CrewAI | 48,739 | 6,658 | 0 | 0.9147 | 0.2732 |
| LlamaIndex | 48,531 | 7,194 | 0 | 0.9144 | 0.2965 |
| LiteLLM | 43,067 | 7,189 | 848 | 0.9042 | 0.9339 |
| DSPy | 33,638 | 2,786 | 0 | 0.8833 | 0.1656 |
| SemanticKernel | 27,695 | 4,545 | 0 | 0.8668 | 0.3282 |
| Haystack | 24,821 | 2,707 | 102 | 0.8575 | 0.2903 |
| PydanticAI | 16,313 | 1,927 | 0 | 0.8220 | 0.2363 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 133,327 | +1.63% | 21,601 | 22,032 | +2.00% |
| AutoGen | 56,243 | 57,021 | +1.38% | 8,453 | 8,582 | +1.53% |
| Mem0 | 51,132 | 52,832 | +3.32% | 5,717 | 5,922 | +3.59% |
| CrewAI | 47,278 | 48,739 | +3.09% | 6,385 | 6,658 | +4.28% |
| LlamaIndex | 48,012 | 48,531 | +1.08% | 7,093 | 7,194 | +1.42% |
| LiteLLM | 40,982 | 43,067 | +5.09% | 6,752 | 7,189 | +6.47% |
| DSPy | 33,187 | 33,638 | +1.36% | 2,728 | 2,786 | +2.13% |
| SemanticKernel | 27,567 | 27,695 | +0.46% | 4,523 | 4,545 | +0.49% |
| Haystack | 24,620 | 24,821 | +0.82% | 2,675 | 2,707 | +1.20% |
| PydanticAI | 15,824 | 16,313 | +3.09% | 1,830 | 1,927 | +5.30% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9339)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present