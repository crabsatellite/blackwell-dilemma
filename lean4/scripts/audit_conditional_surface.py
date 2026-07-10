#!/usr/bin/env python3
"""Guard the proof-derived claim evidence surface."""

import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
LEDGER = ROOT / "BlackwellDilemma" / "Ledger.lean"
GATE = ROOT / "BlackwellDilemma" / "PaperSemanticGate.lean"
text = LEDGER.read_text(encoding="utf-8") + "\n" + GATE.read_text(encoding="utf-8")

required = (
    "ClaimEvidence.proved",
    "ClaimEvidence.hasFullProof",
    "claim_isClosed_iff_fullProofFlag",
    "CompletePaperKernelOnly",
)
missing = [token for token in required if token not in text]
manual_status = len(re.findall(r"^\s*status\s*:=", text, flags=re.MULTILINE))
legacy_interfaces = sum(
    text.count(token)
    for token in (
        "Part6FullPaperClosingDivergenceWitness",
        "Part6FullPaperClosingFeasibleDivergenceWitness",
        "SemanticStatus",
    )
)

print(f"proof_derived_required_tokens={len(required)}")
print(f"proof_derived_required_tokens_missing={len(missing)}")
print("proof_derived_required_token_names_missing=" + ",".join(missing))
print(f"manual_status_assignments={manual_status}")
print(f"legacy_semantic_interfaces={legacy_interfaces}")

if missing or manual_status or legacy_interfaces:
    raise SystemExit(1)
