#!/usr/bin/env python3
"""Audit the proof-derived paper claim ledger."""

from __future__ import annotations

import json
import re
import subprocess
import sys
from collections import Counter
from pathlib import Path


LEAN_ROOT = Path(__file__).resolve().parents[1]
REPO_ROOT = LEAN_ROOT.parent
ROOT_MODULE = LEAN_ROOT / "BlackwellDilemma.lean"
LEDGER = LEAN_ROOT / "BlackwellDilemma" / "Ledger.lean"
GATE = LEAN_ROOT / "BlackwellDilemma" / "PaperSemanticGate.lean"
INVENTORY = REPO_ROOT / "paper" / "claim_inventory.json"

FORBIDDEN = (
    "SemanticStatus",
    "theorem_4_1_part6_lattice_embedding",
    "topo_cluster_random_supercritical_z2",
    "BridgeAuditGate",
    "CompletePaperSemanticKernelOnly",
)

REMOVED_FALSE_CLOSURES = (
    "agentRewardKernel_kappaAgent_fiveState_pointwise_monotone_above_kappaStar",
    "smoothTransitionBeta",
    "gap_threshold_fiveState_smooth_transition",
    "not_current_kappaAgent_highKappa_oracle_at_p0",
    "gap_bayesian_naive_routing_threshold",
    "agentRewardKernel_bayesianNaive_aboveThreshold_kernel_reversal_witness",
    "gap_bayesian_naive_reversal_present",
    "agentRewardKernel_greedy_C2prime_kernel_reversal_witness",
    "gap_general_tree_current",
    "gap_general_tree_from_reversal",
    "gap_cyclic_trap_from_reversal",
    "GreedyWrongnessKernelReversalWitness",
    "WrongnessGreedyInterfaces_current",
    "wrongness_misalignment_reversal_atom",
    "greedy_welfare_reversal_current_noDiagnosticAssumptions",
    "gap_dilemma_current_noDiagnosticAssumptions",
    "ParametricDilemmaCurrentBridge",
    "conditionalWelfareOnR",
    "conditional_subproblem_blackwell_applicable",
    "gap_conditional_reduction_part_i_from_blackwell",
    "gap_conditional_reduction_part_i",
    "gap_conditional_reduction_part_ii",
)


def fail(message: str) -> None:
    print(f"paper_claim_audit_error={message}")
    raise SystemExit(1)


inventory = json.loads(INVENTORY.read_text(encoding="utf-8"))
claims = inventory.get("claims", [])
expected_labels = [claim["label"] for claim in claims]
if not expected_labels:
    fail("empty-inventory")
if len(set(expected_labels)) != len(expected_labels):
    fail("duplicate-inventory-label")

source = LEDGER.read_text(encoding="utf-8") + "\n" + GATE.read_text(encoding="utf-8")
if re.search(r"^\s*status\s*:=", source, flags=re.MULTILINE):
    fail("manual-status-assignment")
for token in FORBIDDEN:
    if token in source:
        fail(f"forbidden-token:{token}")

canonical_source = (LEAN_ROOT / "BlackwellDilemma" / "Canonical.lean").read_text(
    encoding="utf-8"
)
retired_bridge_source = "\n".join(
    [
        canonical_source,
        (LEAN_ROOT / "BlackwellDilemma" / "Bayesian.lean").read_text(
            encoding="utf-8"
        ),
        (LEAN_ROOT / "BlackwellDilemma" / "GeneralGraphs.lean").read_text(
            encoding="utf-8"
        ),
        (LEAN_ROOT / "BlackwellDilemma" / "Wrongness.lean").read_text(
            encoding="utf-8"
        ),
    ]
)
for token in REMOVED_FALSE_CLOSURES:
    if token in retired_bridge_source:
        fail(f"removed-false-closure-present:{token}")

ledger_imports = re.findall(r"^import\s+([^\s]+)", LEDGER.read_text(encoding="utf-8"), re.MULTILINE)
allowed_ledger_imports = {
    "BlackwellDilemma.Basic",
    "BlackwellDilemma.PhysicalIrreducibility",
    "BlackwellDilemma.UnifiedWelfare",
    "BlackwellDilemma.UnifiedCanonical",
    "BlackwellDilemma.UnifiedInterior",
    "BlackwellDilemma.UnifiedTwoRegime",
    "BlackwellDilemma.UnifiedCognitiveFiveState",
    "BlackwellDilemma.UnifiedBayesianImmunity",
    "BlackwellDilemma.UnifiedComplementarity",
    "BlackwellDilemma.UnifiedBayesianNaiveFiveState",
    "BlackwellDilemma.UnifiedGeneralTree",
    "BlackwellDilemma.UnifiedErrorCompounding",
    "BlackwellDilemma.UnifiedGreedyReversal",
    "BlackwellDilemma.UnifiedConditionalReduction",
    "BlackwellDilemma.UnifiedInformationDecay",
    "BlackwellDilemma.UnifiedTopoCluster",
    "BlackwellDilemma.Infrastructure.FiniteLocalTrapEvent",
    "BlackwellDilemma.Infrastructure.FiniteTorusLocalSupports",
    "BlackwellDilemma.Infrastructure.KappaStarClosedForm",
    "BlackwellDilemma.Infrastructure.SeparatedBlockPlacements",
    "BlackwellDilemma.Infrastructure.UnboundedInProbability",
}
model_only_imports = [
    module for module in ledger_imports if module not in allowed_ledger_imports
]
if model_only_imports:
    fail("model-only-imports:" + ",".join(model_only_imports))

root_imports = re.findall(
    r"^import\s+([^\s]+)", ROOT_MODULE.read_text(encoding="utf-8"), re.MULTILINE
)
expected_root_imports = ["BlackwellDilemma.PaperSemanticGate"]
if root_imports != expected_root_imports:
    fail("formal-root-imports:" + ",".join(root_imports))

line_limits = {
    ROOT_MODULE: 20,
    LEDGER: 800,
    GATE: 200,
    Path(__file__).resolve(): 300,
}
for path, limit in line_limits.items():
    count = len(path.read_text(encoding="utf-8").splitlines())
    if count > limit:
        fail(f"line-limit:{path.name}:{count}>{limit}")

build = subprocess.run(
    ["lake", "build", "BlackwellDilemma.PaperSemanticGate"],
    cwd=LEAN_ROOT,
    text=True,
    encoding="utf-8",
    errors="replace",
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT,
    check=False,
)
if build.returncode != 0:
    print(build.stdout)
    fail(f"lake-build-returncode:{build.returncode}")

run = subprocess.run(
    ["lake", "env", "lean", "BlackwellDilemma/PaperSemanticGate.lean"],
    cwd=LEAN_ROOT,
    text=True,
    encoding="utf-8",
    errors="replace",
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT,
    check=False,
)
if run.returncode != 0:
    print(run.stdout)
    fail(f"lean-returncode:{run.returncode}")

observed = re.findall(
    r"paper_claim=([^|\s]+)\|(closed|partial|conditional|refuted-encoding|unformalized)\|"
    r"(local|mixed|external-library|semantic-repair)",
    run.stdout,
)
observed_labels = [label for label, _state, _route in observed]
if observed_labels != expected_labels:
    fail("lean-label-roster-does-not-match-manuscript-inventory")

observed_metadata = re.findall(
    r"paper_claim_meta=([^|\s]+)\|"
    r"(theorem|proposition|lemma|corollary)\|(\d+)",
    run.stdout,
)
expected_metadata = [
    (claim["label"], claim["kind"], str(claim["line"])) for claim in claims
]
if observed_metadata != expected_metadata:
    fail("lean-metadata-does-not-match-manuscript-inventory")
if any(not re.fullmatch(r"[0-9a-f]{64}", claim.get("statement_sha256", "")) for claim in claims):
    fail("missing-or-invalid-statement-sha256")

states = Counter(state for _label, state, _route in observed)
expected_gate = (
    f"paper_claim_gate=total:{len(observed)},closed:{states['closed']},"
    f"partial:{states['partial']},conditional:{states['conditional']},"
    f"refuted-encoding:{states['refuted-encoding']},"
    f"unformalized:{states['unformalized']}"
)
if expected_gate not in run.stdout:
    fail(f"missing-lean-summary:{expected_gate}")

print(f"paper_claims_total={len(observed)}")
print(f"paper_claims_closed={states['closed']}")
print(f"paper_claims_partial={states['partial']}")
print(f"paper_claims_conditional={states['conditional']}")
print(f"paper_claims_refuted_encoding={states['refuted-encoding']}")
print(f"paper_claims_unformalized={states['unformalized']}")
print("paper_claim_labels=" + ",".join(observed_labels))
print("paper_claim_manual_status_assignments=0")
print("paper_claim_legacy_semantic_targets=0")
print("paper_claim_bridge_gate_tokens=0")
print("paper_claim_removed_false_closures=0")
print("paper_claim_model_only_imports=0")
print("paper_claim_formal_root_imports=" + ",".join(root_imports))
print("paper_claim_formal_root_model_only_imports=0")
print("paper_claim_inventory_match=1")
print("paper_claim_metadata_match=1")
print(f"paper_claim_statement_hashes={len(claims)}")

sys.exit(0)
