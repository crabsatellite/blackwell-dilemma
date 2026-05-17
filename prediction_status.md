# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-17
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 52
**Data points**: 53

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 136,909 | 22,648 | 162 | 1.0000 | 0.3981 |
| AutoGen | 58,088 | 8,767 | 0 | 0.9275 | 0.3019 |
| Mem0 | 55,902 | 6,365 | 0 | 0.9243 | 0.2277 |
| CrewAI | 51,554 | 7,130 | 0 | 0.9174 | 0.2766 |
| LlamaIndex | 49,457 | 7,419 | 0 | 0.9139 | 0.3000 |
| LiteLLM | 47,248 | 8,113 | 1446 | 0.9100 | 0.9434 |
| DSPy | 34,474 | 2,899 | 0 | 0.8834 | 0.1682 |
| SemanticKernel | 27,916 | 4,604 | 0 | 0.8656 | 0.3298 |
| Haystack | 25,250 | 2,786 | 0 | 0.8571 | 0.2207 |
| PydanticAI | 17,102 | 2,089 | 0 | 0.8241 | 0.2443 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 136,909 | +4.36% | 21,601 | 22,648 | +4.85% |
| AutoGen | 56,243 | 58,088 | +3.28% | 8,453 | 8,767 | +3.71% |
| Mem0 | 51,132 | 55,902 | +9.33% | 5,717 | 6,365 | +11.33% |
| CrewAI | 47,278 | 51,554 | +9.04% | 6,385 | 7,130 | +11.67% |
| LlamaIndex | 48,012 | 49,457 | +3.01% | 7,093 | 7,419 | +4.60% |
| LiteLLM | 40,982 | 47,248 | +15.29% | 6,752 | 8,113 | +20.16% |
| DSPy | 33,187 | 34,474 | +3.88% | 2,728 | 2,899 | +6.27% |
| SemanticKernel | 27,567 | 27,916 | +1.27% | 4,523 | 4,604 | +1.79% |
| Haystack | 24,620 | 25,250 | +2.56% | 2,675 | 2,786 | +4.15% |
| PydanticAI | 15,824 | 17,102 | +8.08% | 1,830 | 2,089 | +14.15% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9434)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present