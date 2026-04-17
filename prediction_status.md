# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-17
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 22
**Data points**: 23

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 133,822 | 22,118 | 224 | 1.0000 | 0.4351 |
| AutoGen | 57,162 | 8,602 | 0 | 0.9279 | 0.3010 |
| Mem0 | 53,274 | 5,970 | 0 | 0.9220 | 0.2241 |
| CrewAI | 49,067 | 6,705 | 205 | 0.9150 | 0.3690 |
| LlamaIndex | 48,642 | 7,206 | 0 | 0.9143 | 0.2963 |
| LiteLLM | 43,614 | 7,301 | 1285 | 0.9050 | 0.9348 |
| DSPy | 33,758 | 2,798 | 0 | 0.8833 | 0.1658 |
| SemanticKernel | 27,722 | 4,553 | 0 | 0.8666 | 0.3285 |
| Haystack | 24,864 | 2,719 | 0 | 0.8574 | 0.2187 |
| PydanticAI | 16,425 | 1,952 | 0 | 0.8223 | 0.2377 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 133,822 | +2.01% | 21,601 | 22,118 | +2.39% |
| AutoGen | 56,243 | 57,162 | +1.63% | 8,453 | 8,602 | +1.76% |
| Mem0 | 51,132 | 53,274 | +4.19% | 5,717 | 5,970 | +4.43% |
| CrewAI | 47,278 | 49,067 | +3.78% | 6,385 | 6,705 | +5.01% |
| LlamaIndex | 48,012 | 48,642 | +1.31% | 7,093 | 7,206 | +1.59% |
| LiteLLM | 40,982 | 43,614 | +6.42% | 6,752 | 7,301 | +8.13% |
| DSPy | 33,187 | 33,758 | +1.72% | 2,728 | 2,798 | +2.57% |
| SemanticKernel | 27,567 | 27,722 | +0.56% | 4,523 | 4,553 | +0.66% |
| Haystack | 24,620 | 24,864 | +0.99% | 2,675 | 2,719 | +1.64% |
| PydanticAI | 15,824 | 16,425 | +3.80% | 1,830 | 1,952 | +6.67% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9348)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present