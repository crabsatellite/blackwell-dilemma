# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-21
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 87
**Data points**: 88

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 139,779 | 23,182 | 287 | 1.0000 | 0.5556 |
| AutoGen | 59,099 | 8,918 | 0 | 0.9273 | 0.3018 |
| Mem0 | 59,008 | 6,808 | 118 | 0.9272 | 0.3228 |
| CrewAI | 54,055 | 7,568 | 101 | 0.9198 | 0.3588 |
| LiteLLM | 51,011 | 9,031 | 769 | 0.9149 | 0.9541 |
| LlamaIndex | 50,246 | 7,597 | 9 | 0.9136 | 0.3094 |
| DSPy | 35,227 | 2,993 | 18 | 0.8837 | 0.1840 |
| SemanticKernel | 28,169 | 4,657 | 26 | 0.8648 | 0.3509 |
| Haystack | 25,617 | 2,869 | 0 | 0.8568 | 0.2240 |
| PydanticAI | 17,878 | 2,239 | 58 | 0.8264 | 0.2957 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 139,779 | +6.55% | 21,601 | 23,182 | +7.32% |
| AutoGen | 56,243 | 59,099 | +5.08% | 8,453 | 8,918 | +5.50% |
| Mem0 | 51,132 | 59,008 | +15.40% | 5,717 | 6,808 | +19.08% |
| CrewAI | 47,278 | 54,055 | +14.33% | 6,385 | 7,568 | +18.53% |
| LiteLLM | 40,982 | 51,011 | +24.47% | 6,752 | 9,031 | +33.75% |
| LlamaIndex | 48,012 | 50,246 | +4.65% | 7,093 | 7,597 | +7.11% |
| DSPy | 33,187 | 35,227 | +6.15% | 2,728 | 2,993 | +9.71% |
| SemanticKernel | 27,567 | 28,169 | +2.18% | 4,523 | 4,657 | +2.96% |
| Haystack | 24,620 | 25,617 | +4.05% | 2,675 | 2,869 | +7.25% |
| PydanticAI | 15,824 | 17,878 | +12.98% | 1,830 | 2,239 | +22.35% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9541)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present