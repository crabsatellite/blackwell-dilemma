# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-19
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 85
**Data points**: 86

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 139,682 | 23,153 | 264 | 1.0000 | 0.4979 |
| AutoGen | 59,067 | 8,907 | 0 | 0.9274 | 0.3016 |
| Mem0 | 58,899 | 6,782 | 0 | 0.9271 | 0.2303 |
| CrewAI | 53,943 | 7,551 | 122 | 0.9197 | 0.3569 |
| LiteLLM | 50,852 | 8,995 | 952 | 0.9147 | 0.9538 |
| LlamaIndex | 50,223 | 7,585 | 24 | 0.9137 | 0.3172 |
| DSPy | 35,149 | 2,982 | 38 | 0.8835 | 0.1936 |
| SemanticKernel | 28,161 | 4,654 | 28 | 0.8648 | 0.3482 |
| Haystack | 25,605 | 2,865 | 0 | 0.8568 | 0.2238 |
| PydanticAI | 17,848 | 2,233 | 78 | 0.8263 | 0.2994 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 139,682 | +6.47% | 21,601 | 23,153 | +7.18% |
| AutoGen | 56,243 | 59,067 | +5.02% | 8,453 | 8,907 | +5.37% |
| Mem0 | 51,132 | 58,899 | +15.19% | 5,717 | 6,782 | +18.63% |
| CrewAI | 47,278 | 53,943 | +14.10% | 6,385 | 7,551 | +18.26% |
| LiteLLM | 40,982 | 50,852 | +24.08% | 6,752 | 8,995 | +33.22% |
| LlamaIndex | 48,012 | 50,223 | +4.61% | 7,093 | 7,585 | +6.94% |
| DSPy | 33,187 | 35,149 | +5.91% | 2,728 | 2,982 | +9.31% |
| SemanticKernel | 27,567 | 28,161 | +2.15% | 4,523 | 4,654 | +2.90% |
| Haystack | 24,620 | 25,605 | +4.00% | 2,675 | 2,865 | +7.10% |
| PydanticAI | 15,824 | 17,848 | +12.79% | 1,830 | 2,233 | +22.02% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9538)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present