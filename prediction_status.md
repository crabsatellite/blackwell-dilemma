# Blackwell Dilemma MRS: Prediction Tracker

**Report date**: 2026-06-08
**Prediction made**: 2026-03-26
**Verification date**: 2026-05-21
**Days elapsed**: 74
**Data points**: 75

## Hypothesis
> LangChain (quality leader at t0 with 131k stars, 2.3x #2) will show LOWER relative ecosystem growth over 8 weeks than at least one framework with <60k stars at t0. Ecosystem growth = (commits_4w(t1)/commits_4w(t0)) * (forks(t1)/forks(t0)). This tests the Blackwell Dilemma: the most visible framework is not necessarily the healthiest.

## Current Snapshot
| Framework | Stars | Forks | 4w Commits | q (quality) | e (ecosystem) |
|-----------|-------|-------|------------|-------------|---------------|
| LangChain | 138,787 | 22,995 | 166 | 1.0000 | 0.4521 |
| AutoGen | 58,758 | 8,874 | 0 | 0.9274 | 0.3021 |
| Mem0 | 58,017 | 6,646 | 49 | 0.9263 | 0.2647 |
| CrewAI | 53,023 | 7,412 | 0 | 0.9187 | 0.2796 |
| LlamaIndex | 49,987 | 7,527 | 0 | 0.9138 | 0.3012 |
| LiteLLM | 49,602 | 8,685 | 825 | 0.9131 | 0.9502 |
| DSPy | 34,905 | 2,964 | 0 | 0.8834 | 0.1698 |
| SemanticKernel | 28,074 | 4,637 | 0 | 0.8650 | 0.3303 |
| Haystack | 25,487 | 2,832 | 0 | 0.8569 | 0.2222 |
| PydanticAI | 17,603 | 2,189 | 0 | 0.8256 | 0.2487 |

## Growth Since t0
| Framework | Stars t0 | Stars now | Growth | Forks t0 | Forks now | Growth |
|-----------|----------|-----------|--------|----------|-----------|--------|
| LangChain | 131,190 | 138,787 | +5.79% | 21,601 | 22,995 | +6.45% |
| AutoGen | 56,243 | 58,758 | +4.47% | 8,453 | 8,874 | +4.98% |
| Mem0 | 51,132 | 58,017 | +13.47% | 5,717 | 6,646 | +16.25% |
| CrewAI | 47,278 | 53,023 | +12.15% | 6,385 | 7,412 | +16.08% |
| LlamaIndex | 48,012 | 49,987 | +4.11% | 7,093 | 7,527 | +6.12% |
| LiteLLM | 40,982 | 49,602 | +21.03% | 6,752 | 8,685 | +28.63% |
| DSPy | 33,187 | 34,905 | +5.18% | 2,728 | 2,964 | +8.65% |
| SemanticKernel | 27,567 | 28,074 | +1.84% | 4,523 | 4,637 | +2.52% |
| Haystack | 24,620 | 25,487 | +3.52% | 2,675 | 2,832 | +5.87% |
| PydanticAI | 15,824 | 17,603 | +11.24% | 1,830 | 2,189 | +19.62% |

## Diagnostic
- Quality leader (q): **LangChain** (q=1.0000)
- Ecosystem leader (e): **LiteLLM** (e=0.9502)
- **Misalignment (C2)**: YES
  - Quality leader LangChain != ecosystem leader LiteLLM
  - Blackwell Dilemma structure present