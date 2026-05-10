# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-10
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 45
**Data points**: 46

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 136,274 | 22,526 | 158 | 1.0000 | 0.3887 |
| AutoGen | 57,870 | 8,732 | 0 | 0.9276 | 0.3018 |
| Mem0 | 55,255 | 6,260 | 0 | 0.9236 | 0.2266 |
| CrewAI | 51,040 | 7,053 | 0 | 0.9169 | 0.2764 |
| LlamaIndex | 49,271 | 7,377 | 0 | 0.9140 | 0.2994 |
| LiteLLM | 46,359 | 7,898 | 1632 | 0.9088 | 0.9407 |
| DSPy | 34,304 | 2,879 | 0 | 0.8833 | 0.1679 |
| SemanticKernel | 27,875 | 4,591 | 0 | 0.8658 | 0.3294 |
| Haystack | 25,140 | 2,775 | 0 | 0.8570 | 0.2208 |
| PydanticAI | 16,966 | 2,048 | 0 | 0.8238 | 0.2414 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 136,274 | +3.88% | 21,601 | 22,526 | +4.28% |
| AutoGen | 56,243 | 57,870 | +2.89% | 8,453 | 8,732 | +3.30% |
| Mem0 | 51,132 | 55,255 | +8.06% | 5,717 | 6,260 | +9.50% |
| CrewAI | 47,278 | 51,040 | +7.96% | 6,385 | 7,053 | +10.46% |
| LlamaIndex | 48,012 | 49,271 | +2.62% | 7,093 | 7,377 | +4.00% |
| LiteLLM | 40,982 | 46,359 | +13.12% | 6,752 | 7,898 | +16.97% |
| DSPy | 33,187 | 34,304 | +3.37% | 2,728 | 2,879 | +5.54% |
| SemanticKernel | 27,567 | 27,875 | +1.12% | 4,523 | 4,591 | +1.50% |
| Haystack | 24,620 | 25,140 | +2.11% | 2,675 | 2,775 | +3.74% |
| PydanticAI | 15,824 | 16,966 | +7.22% | 1,830 | 2,048 | +11.91% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9407)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present