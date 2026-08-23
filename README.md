# When More Payoff Information Hurts

This repository is the Lean 4 / Mathlib formal companion for the current
current *Theory and Decision* manuscript, *When More Payoff Information Hurts:
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
load_bearing_derivations=37
current_source_files=15
```

The map covers every labeled definition, theorem, proposition, and lemma plus
all 37 load-bearing displayed derivations in the current manuscript:

1. induced posterior welfare;
2. posterior-convexity frontier, including the binary counterexample;
3. nondegenerate two-action nonnegative-proportionality alignment, including
   the boundary intercept forced to zero by convexity;
4. the finite irreversibility decision problem;
5. strict Gaussian route reversal;
6. monotonicity restoration under feasibility knowledge;
7. feasibility/policy welfare decomposition;
8. the exact cognition threshold and three strict precision regimes;
9. local differential information-knowledge complementarity; and
10. the five-state interior optimum.

The transitive current-paper surface is now exactly 15 project files and 2,742
source lines. Percolation, lattice, finite-torus, legacy cognition, and old
multi-regime modules have been removed from the release source; their history
remains recoverable from Git. The empirical prediction materials under `verification/`, `simulation/`,
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
  manuscript object and every displayed derivation hash to its compiled Lean
  consumer.
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
and derivation maps under `--trust=0 -DwarningAsError=true`, scans every project
source file, and rejects `sorry`, `admit`, `unsafe`, `native_decide`, project
axioms, opaque constants, stale statement hashes, duplicate labels, or any
unfinished current-paper entry.

## Reproducibility

Lean uses the toolchain in `lean4/lean-toolchain` and the Mathlib revision
pinned by `lean4/lake-manifest.json`.

The manuscript and submission package are maintained in the adjacent internal
paper project. The public repository stores the exact manuscript SHA-256 and
normalized statement hashes, so a local release build fails if either side
drifts.

## License

MIT. See [`LICENSE`](LICENSE).
