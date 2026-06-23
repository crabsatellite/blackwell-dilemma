# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-23
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 89
**Data points**: 90

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 139,932 | 23,206 | 319 | 1.0000 | 0.5724 |
| AutoGen | 59,174 | 8,921 | 0 | 0.9274 | 0.3015 |
| Mem0 | 59,174 | 6,828 | 0 | 0.9274 | 0.2308 |
| CrewAI | 54,187 | 7,588 | 0 | 0.9199 | 0.2801 |
| LiteLLM | 51,187 | 9,079 | 795 | 0.9151 | 0.9547 |
| LlamaIndex | 50,304 | 7,607 | 0 | 0.9137 | 0.3024 |
| DSPy | 35,311 | 2,995 | 0 | 0.8838 | 0.1696 |
| SemanticKernel | 28,178 | 4,661 | 0 | 0.8647 | 0.3308 |
| Haystack | 25,636 | 2,877 | 0 | 0.8568 | 0.2244 |
| PydanticAI | 17,920 | 2,247 | 0 | 0.8266 | 0.2508 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 139,932 | +6.66% | 21,601 | 23,206 | +7.43% |
| AutoGen | 56,243 | 59,174 | +5.21% | 8,453 | 8,921 | +5.54% |
| Mem0 | 51,132 | 59,174 | +15.73% | 5,717 | 6,828 | +19.43% |
| CrewAI | 47,278 | 54,187 | +14.61% | 6,385 | 7,588 | +18.84% |
| LiteLLM | 40,982 | 51,187 | +24.90% | 6,752 | 9,079 | +34.46% |
| LlamaIndex | 48,012 | 50,304 | +4.77% | 7,093 | 7,607 | +7.25% |
| DSPy | 33,187 | 35,311 | +6.40% | 2,728 | 2,995 | +9.79% |
| SemanticKernel | 27,567 | 28,178 | +2.22% | 4,523 | 4,661 | +3.05% |
| Haystack | 24,620 | 25,636 | +4.13% | 2,675 | 2,877 | +7.55% |
| PydanticAI | 15,824 | 17,920 | +13.25% | 1,830 | 2,247 | +22.79% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9547)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present