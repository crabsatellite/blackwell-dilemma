# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-15
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 50
**Data points**: 51

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 136,773 | 22,621 | 192 | 1.0000 | 0.3917 |
| AutoGen | 58,038 | 8,760 | 0 | 0.9275 | 0.3019 |
| Mem0 | 55,751 | 6,345 | 0 | 0.9241 | 0.2276 |
| CrewAI | 51,431 | 7,107 | 0 | 0.9173 | 0.2764 |
| LlamaIndex | 49,425 | 7,416 | 0 | 0.9139 | 0.3001 |
| LiteLLM | 47,041 | 8,059 | 1890 | 0.9098 | 0.9426 |
| DSPy | 34,438 | 2,892 | 0 | 0.8834 | 0.1680 |
| SemanticKernel | 27,908 | 4,601 | 0 | 0.8656 | 0.3297 |
| Haystack | 25,231 | 2,782 | 0 | 0.8571 | 0.2205 |
| PydanticAI | 17,066 | 2,082 | 0 | 0.8240 | 0.2440 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 136,773 | +4.26% | 21,601 | 22,621 | +4.72% |
| AutoGen | 56,243 | 58,038 | +3.19% | 8,453 | 8,760 | +3.63% |
| Mem0 | 51,132 | 55,751 | +9.03% | 5,717 | 6,345 | +10.98% |
| CrewAI | 47,278 | 51,431 | +8.78% | 6,385 | 7,107 | +11.31% |
| LlamaIndex | 48,012 | 49,425 | +2.94% | 7,093 | 7,416 | +4.55% |
| LiteLLM | 40,982 | 47,041 | +14.78% | 6,752 | 8,059 | +19.36% |
| DSPy | 33,187 | 34,438 | +3.77% | 2,728 | 2,892 | +6.01% |
| SemanticKernel | 27,567 | 27,908 | +1.24% | 4,523 | 4,601 | +1.72% |
| Haystack | 24,620 | 25,231 | +2.48% | 2,675 | 2,782 | +4.00% |
| PydanticAI | 15,824 | 17,066 | +7.85% | 1,830 | 2,082 | +13.77% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9426)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present