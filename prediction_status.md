# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-04-04
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 9
**Data points**: 10

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 132,281 | 21,817 | 241 | 1.0000 | 0.3956 |
| AutoGen | 56,668 | 8,521 | 0 | 0.9281 | 0.3007 |
| Mem0 | 51,907 | 5,811 | 0 | 0.9207 | 0.2239 |
| LlamaIndex | 48,277 | 7,155 | 0 | 0.9145 | 0.2964 |
| CrewAI | 47,973 | 6,528 | 0 | 0.9140 | 0.2722 |
| LiteLLM | 42,115 | 6,980 | 2198 | 0.9029 | 0.9315 |
| DSPy | 33,422 | 2,754 | 0 | 0.8833 | 0.1648 |
| SemanticKernel | 27,635 | 4,533 | 0 | 0.8672 | 0.3281 |
| Haystack | 24,698 | 2,696 | 0 | 0.8577 | 0.2183 |
| PydanticAI | 16,091 | 1,874 | 81 | 0.8214 | 0.2550 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 132,281 | +0.83% | 21,601 | 21,817 | +1.00% |
| AutoGen | 56,243 | 56,668 | +0.76% | 8,453 | 8,521 | +0.80% |
| Mem0 | 51,132 | 51,907 | +1.52% | 5,717 | 5,811 | +1.64% |
| LlamaIndex | 48,012 | 48,277 | +0.55% | 7,093 | 7,155 | +0.87% |
| CrewAI | 47,278 | 47,973 | +1.47% | 6,385 | 6,528 | +2.24% |
| LiteLLM | 40,982 | 42,115 | +2.76% | 6,752 | 6,980 | +3.38% |
| DSPy | 33,187 | 33,422 | +0.71% | 2,728 | 2,754 | +0.95% |
| SemanticKernel | 27,567 | 27,635 | +0.25% | 4,523 | 4,533 | +0.22% |
| Haystack | 24,620 | 24,698 | +0.32% | 2,675 | 2,696 | +0.79% |
| PydanticAI | 15,824 | 16,091 | +1.69% | 1,830 | 1,874 | +2.40% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9315)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present