# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-03
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 8
**Data points**: 9

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 132,165 | 21,796 | 224 | 1.0000 | 0.3913 |
| AutoGen | 56,622 | 8,514 | 2 | 0.9281 | 0.3013 |
| Mem0 | 51,828 | 5,803 | 0 | 0.9206 | 0.2239 |
| LlamaIndex | 48,248 | 7,148 | 0 | 0.9145 | 0.2963 |
| CrewAI | 47,890 | 6,508 | 0 | 0.9139 | 0.2718 |
| LiteLLM | 42,004 | 6,952 | 2187 | 0.9028 | 0.9310 |
| DSPy | 33,406 | 2,753 | 0 | 0.8834 | 0.1648 |
| SemanticKernel | 27,629 | 4,533 | 0 | 0.8673 | 0.3281 |
| Haystack | 24,692 | 2,695 | 0 | 0.8577 | 0.2183 |
| PydanticAI | 16,053 | 1,871 | 0 | 0.8212 | 0.2331 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 132,165 | +0.74% | 21,601 | 21,796 | +0.90% |
| AutoGen | 56,243 | 56,622 | +0.67% | 8,453 | 8,514 | +0.72% |
| Mem0 | 51,132 | 51,828 | +1.36% | 5,717 | 5,803 | +1.50% |
| LlamaIndex | 48,012 | 48,248 | +0.49% | 7,093 | 7,148 | +0.78% |
| CrewAI | 47,278 | 47,890 | +1.29% | 6,385 | 6,508 | +1.93% |
| LiteLLM | 40,982 | 42,004 | +2.49% | 6,752 | 6,952 | +2.96% |
| DSPy | 33,187 | 33,406 | +0.66% | 2,728 | 2,753 | +0.92% |
| SemanticKernel | 27,567 | 27,629 | +0.22% | 4,523 | 4,533 | +0.22% |
| Haystack | 24,620 | 24,692 | +0.29% | 2,675 | 2,695 | +0.75% |
| PydanticAI | 15,824 | 16,053 | +1.45% | 1,830 | 1,871 | +2.24% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9310)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present