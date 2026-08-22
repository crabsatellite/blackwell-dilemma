# BlackwellDilemma Lean 4 formalisation

## Machine state

```text
current_paper_objects=10
current_paper_closed=10
current_paper_unfinished=0
current_paper_project_axioms=0
formal_root_imports=BlackwellDilemma.CurrentPaperStatus
```

The current paper surface has no editable closed/open flag. Definitions are
marked definitional; every theorem, proposition, and lemma entry carries a proof
of the exact proposition stored in `CurrentPaperLedger.lean`.

## Paper-to-Lean map

| Manuscript object | Lean endpoint |
|---|---|
| Definition 1, `def:posterior-welfare` | `CurrentPosterior.PosteriorDecisionModel`, `inducedPosteriorWelfare`, `experimentObjectiveValue` |
| Theorem 2, `thm:convexity-frontier` | `CurrentPosterior.posteriorConvexityFrontier`, `not_convex_exists_binary_witness` |
| Theorem 3, `thm:two-action-alignment` | `CurrentTwoAction.twoActionAlignment` |
| Definition 5, `def:idp` | `IDPModel`, `IDPState`, `Step`, `IsStopping`, `attainableStops` |
| Theorem 6, `thm:route-reversal` | `CurrentRouteReversal.routeReversal_strictAntiOn` |
| Theorem 7, `thm:restoration` | `CurrentPosterior.alignedObjective_respectsFiniteBlackwellRefinements` |
| Lemma 8, `lem:decomposition` | `UnifiedWelfareSetup.welfare_decomposition` and sign/oracle endpoints |
| Theorem 9, `thm:cognitive-threshold` | `CurrentCognition.cognitiveThresholdClaim_proved` |
| Proposition 10, `prop:complementarity` | `SupermodularCognition.supermodularCognitionClaim_proved` |
| Proposition 11, `prop:interior-optimum` | `FiveStateRouting.interiorOptimumClaim_proved` |

## Trust boundary

`CurrentPaperAxiomAudit.lean` reports only Lean/Mathlib kernel dependencies:
`propext`, `Classical.choice`, and `Quot.sound`. No `BlackwellDilemma` project
axiom is consumed by a current-paper endpoint.

The posterior-convexity frontier is derived from a finite conditional posterior
split with a coordinatewise barycenter identity. The two-action theorem is
proved on the translated affine-hull direction space, where the subjective and
objective gaps are linear functionals and the tie rule chooses action 1 at
zero. The route, cognition, complementarity, decomposition, and five-state
results reuse only their exact current-paper semantic consumers.

## Build and audit

```powershell
lake build BlackwellDilemma
lake build BlackwellDilemma.CurrentPaperAxiomAudit
lake env lean BlackwellDilemma/TheoremMap.lean
lake env lean BlackwellDilemma/CurrentPaperStatus.lean
lake env lean BlackwellDilemma/CurrentPaperAxiomAudit.lean
python scripts/audit_current_theory_map.py
python verify_release.py
```

In a standalone public clone without the adjacent private manuscript source,
run `python scripts/audit_current_theory_map.py --inventory-only`; CI does this
automatically. Local manuscript preparation always performs the stronger live
source/hash comparison.

## Source layout

| File | Role |
|---|---|
| `CurrentPosterior.lean` | Definition 1, Theorem 2, and fixed-objective restoration core |
| `CurrentTwoAction.lean` | Theorem 3 |
| `UnifiedIDP.lean` / `UnifiedWelfare.lean` | Definition 5 and Lemma 8 |
| `CurrentRouteReversal.lean` | Theorem 6 |
| `CurrentCognition.lean` | Theorem 9 |
| `UnifiedSupermodularCognition.lean` | Proposition 10 |
| `UnifiedInterior.lean` | Proposition 11 |
| `CurrentPaperLedger.lean` | proof-carrying 10-object ledger |
| `TheoremMap.lean` | publication-facing correspondence map |
| `CurrentPaperStatus.lean` | 10/10 and zero-unfinished gate |
| `CurrentPaperAxiomAudit.lean` | current-only dependency audit |
