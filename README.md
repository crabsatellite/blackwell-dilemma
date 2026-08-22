# When More Payoff Information Hurts

This repository is the Lean 4 / Mathlib formal companion for the current
17-page *Theory and Decision* manuscript, *When More Payoff Information Hurts:
Objective Alignment under Endogenous Feasibility*.

## Current formal status

The publication-facing root is current-paper-only:

```text
formal_root=BlackwellDilemma.CurrentPaperStatus
numbered_objects=10
closed=10
unfinished=0
project_axioms=0
proof_escapes=0
```

The map covers every labeled definition, theorem, proposition, and lemma in the
current manuscript:

1. induced posterior welfare;
2. posterior-convexity frontier, including the binary counterexample;
3. two-action positive-proportionality alignment;
4. the finite irreversibility decision problem;
5. strict Gaussian route reversal;
6. monotonicity restoration under feasibility knowledge;
7. feasibility/policy welfare decomposition;
8. the exact cognition threshold and three strict precision regimes;
9. local information-knowledge complementarity; and
10. the five-state interior optimum.

The previous extended-paper ledger and modules that were outside the current
root import closure have been removed. Their history remains recoverable from
Git. The empirical prediction materials under `verification/`, `simulation/`,
`results/`, and `docs/` are separate research artifacts and are not imported by
the Lean library.

## Authoritative formal surfaces

- [`lean4/BlackwellDilemma/TheoremMap.lean`](lean4/BlackwellDilemma/TheoremMap.lean)
  gives the publication-facing `#check` correspondence.
- [`lean4/BlackwellDilemma/CurrentPaperLedger.lean`](lean4/BlackwellDilemma/CurrentPaperLedger.lean)
  stores proof-carrying entries; a result is closed only by a term of its stored
  proposition.
- [`lean4/BlackwellDilemma/CurrentPaperStatus.lean`](lean4/BlackwellDilemma/CurrentPaperStatus.lean)
  proves 10 entries, 10 closed, zero unfinished, and unique labels.
- [`lean4/BlackwellDilemma/CurrentPaperAxiomAudit.lean`](lean4/BlackwellDilemma/CurrentPaperAxiomAudit.lean)
  prints the dependency surface for every current result.
- [`paper/current_theory_map.json`](paper/current_theory_map.json) binds each
  manuscript statement hash to its Lean consumer.
- [`lean4/scripts/audit_current_theory_map.py`](lean4/scripts/audit_current_theory_map.py)
  compares the live manuscript with the stored map and formal root.
- [`lean4/verify_release.py`](lean4/verify_release.py) is the fail-closed release
  gate used by CI.

## Verification

```powershell
cd lean4
python verify_release.py
```

The gate builds the current root and axiom audit, checks the complete theorem
map, rejects `sorry`, `admit`, `unsafe`, `native_decide`, project axioms, opaque
constants, stale statement hashes, duplicate labels, and any unfinished
current-paper entry.

## Reproducibility

Lean uses the toolchain in `lean4/lean-toolchain` and the Mathlib revision
pinned by `lean4/lake-manifest.json`.

The manuscript and submission package are maintained in the adjacent internal
paper project. The public repository stores the exact manuscript SHA-256 and
normalized statement hashes, so a local release build fails if either side
drifts.

## License

MIT. See [`LICENSE`](LICENSE).
