# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-03-29
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 3
**Data points**: 4

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 131,432 | 21,658 | 194 | 1.0000 | 0.3899 |
| AutoGen | 56,350 | 8,472 | 2 | 0.9281 | 0.3013 |
| Mem0 | 51,353 | 5,744 | 0 | 0.9203 | 0.2237 |
| LlamaIndex | 48,100 | 7,113 | 97 | 0.9147 | 0.3259 |
| CrewAI | 47,447 | 6,423 | 0 | 0.9136 | 0.2707 |
| LiteLLM | 41,359 | 6,825 | 1930 | 0.9019 | 0.9300 |
| DSPy | 33,241 | 2,736 | 0 | 0.8834 | 0.1646 |
| SemanticKernel | 27,583 | 4,528 | 30 | 0.8675 | 0.3376 |
| Haystack | 24,640 | 2,685 | 139 | 0.8580 | 0.2612 |
| PydanticAI | 15,915 | 1,839 | 0 | 0.8209 | 0.2311 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 131,432 | +0.18% | 21,601 | 21,658 | +0.26% |
| AutoGen | 56,243 | 56,350 | +0.19% | 8,453 | 8,472 | +0.22% |
| Mem0 | 51,132 | 51,353 | +0.43% | 5,717 | 5,744 | +0.47% |
| LlamaIndex | 48,012 | 48,100 | +0.18% | 7,093 | 7,113 | +0.28% |
| CrewAI | 47,278 | 47,447 | +0.36% | 6,385 | 6,423 | +0.60% |
| LiteLLM | 40,982 | 41,359 | +0.92% | 6,752 | 6,825 | +1.08% |
| DSPy | 33,187 | 33,241 | +0.16% | 2,728 | 2,736 | +0.29% |
| SemanticKernel | 27,567 | 27,583 | +0.06% | 4,523 | 4,528 | +0.11% |
| Haystack | 24,620 | 24,640 | +0.08% | 2,675 | 2,685 | +0.37% |
| PydanticAI | 15,824 | 15,915 | +0.58% | 1,830 | 1,839 | +0.49% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9300)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present