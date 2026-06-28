# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-28
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 94
**Data points**: 95

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 140,357 | 23,298 | 289 | 1.0000 | 0.5635 |
| Mem0 | 59,609 | 6,897 | 171 | 0.9277 | 0.3684 |
| AutoGen | 59,303 | 8,939 | 0 | 0.9273 | 0.3015 |
| CrewAI | 54,479 | 7,629 | 109 | 0.9202 | 0.3674 |
| LiteLLM | 51,802 | 9,245 | 749 | 0.9159 | 0.9569 |
| LlamaIndex | 50,457 | 7,645 | 12 | 0.9137 | 0.3126 |
| DSPy | 35,529 | 3,025 | 0 | 0.8841 | 0.1703 |
| SemanticKernel | 28,208 | 4,664 | 31 | 0.8646 | 0.3555 |
| Haystack | 25,764 | 2,886 | 0 | 0.8570 | 0.2240 |
| PydanticAI | 18,041 | 2,263 | 0 | 0.8269 | 0.2509 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 140,357 | +6.99% | 21,601 | 23,298 | +7.86% |
| Mem0 | 51,132 | 59,609 | +16.58% | 5,717 | 6,897 | +20.64% |
| AutoGen | 56,243 | 59,303 | +5.44% | 8,453 | 8,939 | +5.75% |
| CrewAI | 47,278 | 54,479 | +15.23% | 6,385 | 7,629 | +19.48% |
| LiteLLM | 40,982 | 51,802 | +26.40% | 6,752 | 9,245 | +36.92% |
| LlamaIndex | 48,012 | 50,457 | +5.09% | 7,093 | 7,645 | +7.78% |
| DSPy | 33,187 | 35,529 | +7.06% | 2,728 | 3,025 | +10.89% |
| SemanticKernel | 27,567 | 28,208 | +2.33% | 4,523 | 4,664 | +3.12% |
| Haystack | 24,620 | 25,764 | +4.65% | 2,675 | 2,886 | +7.89% |
| PydanticAI | 15,824 | 18,041 | +14.01% | 1,830 | 2,263 | +23.66% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9569)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present