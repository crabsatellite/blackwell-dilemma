# Public Evidence Gate

This directory records the public repository's machine-checkable evidence
surface for references, formulas, numeric claims, and paper-semantic target
status.

Run from the repository root:

```bash
python tools/verify_public_evidence.py
```

The gate is offline. It does not certify that external papers are themselves
proved in this repository. It certifies that public claims depending on outside
results are explicitly source-carded, that result-backed public numbers agree
with committed JSON artifacts, and that the two remaining paper-semantic Lean
targets stay visibly open until an actual Lean inhabitant closes them.
