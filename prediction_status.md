# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-29
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 64
**Data points**: 65

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 137,934 | 22,839 | 210 | 1.0000 | 0.4460 |
| AutoGen | 58,506 | 8,824 | 0 | 0.9275 | 0.3016 |
| Mem0 | 57,025 | 6,499 | 0 | 0.9254 | 0.2279 |
| CrewAI | 52,405 | 7,286 | 0 | 0.9182 | 0.2781 |
| LlamaIndex | 49,743 | 7,477 | 0 | 0.9138 | 0.3006 |
| LiteLLM | 48,628 | 8,452 | 1097 | 0.9119 | 0.9476 |
| DSPy | 34,719 | 2,935 | 0 | 0.8834 | 0.1691 |
| SemanticKernel | 28,003 | 4,612 | 0 | 0.8653 | 0.3294 |
| Haystack | 25,408 | 2,813 | 0 | 0.8571 | 0.2214 |
| PydanticAI | 17,370 | 2,151 | 0 | 0.8249 | 0.2477 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 137,934 | +5.14% | 21,601 | 22,839 | +5.73% |
| AutoGen | 56,243 | 58,506 | +4.02% | 8,453 | 8,824 | +4.39% |
| Mem0 | 51,132 | 57,025 | +11.53% | 5,717 | 6,499 | +13.68% |
| CrewAI | 47,278 | 52,405 | +10.84% | 6,385 | 7,286 | +14.11% |
| LlamaIndex | 48,012 | 49,743 | +3.61% | 7,093 | 7,477 | +5.41% |
| LiteLLM | 40,982 | 48,628 | +18.66% | 6,752 | 8,452 | +25.18% |
| DSPy | 33,187 | 34,719 | +4.62% | 2,728 | 2,935 | +7.59% |
| SemanticKernel | 27,567 | 28,003 | +1.58% | 4,523 | 4,612 | +1.97% |
| Haystack | 24,620 | 25,408 | +3.20% | 2,675 | 2,813 | +5.16% |
| PydanticAI | 15,824 | 17,370 | +9.77% | 1,830 | 2,151 | +17.54% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9476)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present