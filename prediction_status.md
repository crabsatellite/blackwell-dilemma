# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-05-30
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 65
**Data points**: 66

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 138,011 | 22,858 | 217 | 1.0000 | 0.4465 |
| AutoGen | 58,533 | 8,830 | 0 | 0.9275 | 0.3017 |
| Mem0 | 57,112 | 6,510 | 0 | 0.9254 | 0.2280 |
| CrewAI | 52,455 | 7,296 | 0 | 0.9183 | 0.2782 |
| LlamaIndex | 49,765 | 7,482 | 0 | 0.9138 | 0.3007 |
| LiteLLM | 48,734 | 8,480 | 1130 | 0.9120 | 0.9480 |
| DSPy | 34,726 | 2,937 | 0 | 0.8834 | 0.1692 |
| SemanticKernel | 28,010 | 4,616 | 0 | 0.8653 | 0.3296 |
| Haystack | 25,410 | 2,816 | 0 | 0.8570 | 0.2216 |
| PydanticAI | 17,389 | 2,157 | 0 | 0.8250 | 0.2481 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 138,011 | +5.20% | 21,601 | 22,858 | +5.82% |
| AutoGen | 56,243 | 58,533 | +4.07% | 8,453 | 8,830 | +4.46% |
| Mem0 | 51,132 | 57,112 | +11.70% | 5,717 | 6,510 | +13.87% |
| CrewAI | 47,278 | 52,455 | +10.95% | 6,385 | 7,296 | +14.27% |
| LlamaIndex | 48,012 | 49,765 | +3.65% | 7,093 | 7,482 | +5.48% |
| LiteLLM | 40,982 | 48,734 | +18.92% | 6,752 | 8,480 | +25.59% |
| DSPy | 33,187 | 34,726 | +4.64% | 2,728 | 2,937 | +7.66% |
| SemanticKernel | 27,567 | 28,010 | +1.61% | 4,523 | 4,616 | +2.06% |
| Haystack | 24,620 | 25,410 | +3.21% | 2,675 | 2,816 | +5.27% |
| PydanticAI | 15,824 | 17,389 | +9.89% | 1,830 | 2,157 | +17.87% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9480)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present