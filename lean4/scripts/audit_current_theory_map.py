#!/usr/bin/env python3
"""Fail-closed paper-to-Lean audit for the current Theory and Decision paper."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path


SCRIPT_DIR = Path(__file__).resolve().parent
LEAN_ROOT = SCRIPT_DIR.parent
REPO_ROOT = LEAN_ROOT.parent
DEFAULT_PAPER = (
    REPO_ROOT.parent
    / "blackwell-dilemma-internal"
    / "paper"
    / "blackwell_theory_decision.tex"
)
INVENTORY = REPO_ROOT / "paper" / "current_theory_map.json"
THEOREM_MAP = LEAN_ROOT / "BlackwellDilemma" / "TheoremMap.lean"
LEDGER = LEAN_ROOT / "BlackwellDilemma" / "CurrentPaperLedger.lean"
ROOT_MODULE = LEAN_ROOT / "BlackwellDilemma.lean"

EXPECTED = [
    ("definition", "def:posterior-welfare", "Definition 1"),
    ("theorem", "thm:convexity-frontier", "Theorem 2"),
    ("theorem", "thm:two-action-alignment", "Theorem 3"),
    ("definition", "def:idp", "Definition 5"),
    ("theorem", "thm:route-reversal", "Theorem 6"),
    ("theorem", "thm:restoration", "Theorem 7"),
    ("lemma", "lem:decomposition", "Lemma 8"),
    ("theorem", "thm:cognitive-threshold", "Theorem 9"),
    ("proposition", "prop:complementarity", "Proposition 10"),
    ("proposition", "prop:interior-optimum", "Proposition 11"),
]

BINDINGS = {
    "def:posterior-welfare": "CurrentPaperContracts.posteriorWelfareDefinitionContract",
    "thm:convexity-frontier": "CurrentPaperContracts.posteriorConvexityFrontierContract",
    "thm:two-action-alignment": "CurrentPaperContracts.twoActionAlignmentContract",
    "def:idp": "CurrentPaperContracts.idpDefinitionContract",
    "thm:route-reversal": "CurrentPaperContracts.routeReversalContract",
    "thm:restoration": "CurrentRestoration.restorationUnderObservedFiniteFeasibility",
    "lem:decomposition": "CurrentPaperContracts.feasibilityPolicyDecompositionContract",
    "thm:cognitive-threshold": "CurrentPaperContracts.cognitiveThresholdContract",
    "prop:complementarity": "CurrentPaperContracts.localComplementarityContract",
    "prop:interior-optimum": "CurrentPaperContracts.interiorOptimalPrecisionContract",
}

EXPECTED_DERIVATIONS = [
    ("posterior-response", "CurrentPosterior.PosteriorDecisionModel.inducedPosteriorWelfare"),
    ("experiment-value", "CurrentPosterior.PosteriorDecisionModel.experimentObjectiveValue"),
    ("refinement-barycenter", "CurrentPosterior.FiniteBlackwellRefinement.barycenter"),
    ("refinement-values", "CurrentPosterior.FiniteBlackwellRefinement.valueFormulas"),
    ("frontier-order", "CurrentPosterior.FiniteBlackwellRefinement.value_mono_of_convex"),
    ("conditional-barycenter", "CurrentPosterior.FiniteBlackwellRefinement.barycenter"),
    ("conditional-jensen", "CurrentPosterior.FiniteBlackwellRefinement.conditionalJensen"),
    ("nonconvex-witness", "CurrentPosterior.not_convex_exists_binary_witness"),
    ("two-action-gaps", "CurrentTwoAction.finitePayoffGap"),
    ("two-action-boundary", "CurrentTwoAction.subjectiveIndifferenceSet"),
    ("two-action-centered-gaps", "CurrentTwoAction.centeredGapFormulas"),
    ("two-action-alignment", "CurrentTwoAction.twoActionAffineAlignmentOnInteriorDomain"),
    ("two-action-piecewise", "CurrentTwoAction.twoActionWelfareWithBoundary"),
    ("two-action-max", "CurrentTwoAction.twoActionAlignment"),
    ("gaussian-signal", "CurrentGaussian.gaussianScoreExperimentLaw"),
    ("precision-scale", "CurrentRouteReversal.precisionScale"),
    ("continuation-value", "CurrentRouteReversal.expectedContinuation"),
    ("ranking-mismatch", "CurrentRouteReversal.finiteRouteReversal"),
    ("route-welfare", "CurrentRouteReversal.terminalWelfare_formula"),
    ("restoration-order", "CurrentRestoration.restorationUnderObservedFiniteFeasibility"),
    ("attainable-maximum", "IDPModel.oracleValue"),
    ("welfare-decomposition", "UnifiedWelfareSetup.welfare_decomposition"),
    ("assimilation-weight", "CurrentCognition.assimilationWeight"),
    ("represented-score", "CurrentCognition.representedScore"),
    ("cognition-index", "CurrentCognition.cognitionIndex"),
    ("cognition-welfare", "CurrentCognition.cognitionWelfare"),
    ("cognition-threshold", "CurrentCognition.kappaStar"),
    ("mixed-cross-partial", "CurrentComplementarity.mixedCrossPartial"),
    ("moderate-region", "CurrentComplementarity.mixedCrossPartial_pos"),
    ("cognition-marginal", "CurrentComplementarity.cognitionWelfare_hasDerivAt_kappa"),
    ("five-state-rewards", "CurrentFiveState.fiveStateRewards"),
    ("five-state-tree", "CurrentFiveState.fiveStateTopology"),
    ("five-state-loss", "CurrentFiveState.expectedLoss_formula"),
    ("five-state-endpoints", "CurrentFiveState.expectedLoss_endpoints"),
    ("trap-probability", "CurrentFiveState.trapProbability"),
    ("distractor-probability", "CurrentFiveState.distractorProbability"),
    ("loss-rearrangement", "CurrentFiveState.expectedLoss_sub_limit"),
]


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def normalize_tex(text: str) -> str:
    text = re.sub(r"(?m)(?<!\\)%.*$", "", text)
    return re.sub(r"\s+", "", text)


def paper_objects(source: str) -> list[dict[str, object]]:
    pattern = re.compile(
        r"\\begin\{(definition|theorem|proposition|lemma)\}"
        r"(?:\[([^\]]*)\])?(.*?)\\end\{\1\}",
        re.DOTALL,
    )
    objects: list[dict[str, object]] = []
    number = 0
    all_numbered = re.compile(
        r"\\begin\{(definition|theorem|proposition|lemma|remark)\}"
        r"(?:\[[^\]]*\])?",
        re.DOTALL,
    )
    numbered_positions = [(m.start(), i + 1) for i, m in enumerate(all_numbered.finditer(source))]
    for match in pattern.finditer(source):
        label_match = re.search(r"\\label\{([^}]+)\}", match.group(3))
        label = label_match.group(1) if label_match else ""
        number = next(n for position, n in numbered_positions if position == match.start())
        statement = re.sub(r"\\label\{[^}]+\}", "", match.group(3), count=1)
        objects.append(
            {
                "kind": match.group(1),
                "label": label,
                "number": number,
                "title": match.group(2) or "",
                "statement_sha256": sha256_bytes(normalize_tex(statement).encode("utf-8")),
                "binding": BINDINGS.get(label, "<unbound>"),
            }
        )
    return objects


def paper_derivations(source: str) -> list[dict[str, str]]:
    marker_pattern = re.compile(
        r"%\s*FORMAL-BINDING:\s*([^:]+?)\s*::\s*([^\r\n]+)"
    )
    display_pattern = re.compile(r"\\\[(.*?)\\\]", re.DOTALL)
    markers = list(marker_pattern.finditer(source))
    displays = list(display_pattern.finditer(source))
    if len(markers) != len(displays):
        raise SystemExit(
            f"display/formal-binding count mismatch: displays={len(displays)} "
            f"bindings={len(markers)}"
        )
    result: list[dict[str, str]] = []
    previous_end = 0
    for marker, display in zip(markers, displays, strict=True):
        if not (previous_end <= marker.start() < display.start()):
            raise SystemExit("formal binding is not immediately ordered before its display")
        between = source[marker.end():display.start()]
        if between.strip():
            raise SystemExit(
                f"formal binding {marker.group(1).strip()} is not adjacent to its display"
            )
        result.append(
            {
                "key": marker.group(1).strip(),
                "binding": marker.group(2).strip(),
                "statement_sha256": sha256_bytes(
                    normalize_tex(display.group(1)).encode("utf-8")
                ),
            }
        )
        previous_end = display.end()
    return result


def build_inventory(paper: Path) -> dict[str, object]:
    source_bytes = paper.read_bytes()
    source = source_bytes.decode("utf-8")
    return {
        "schema_version": 1,
        "manuscript": paper.name,
        "manuscript_sha256": sha256_bytes(source_bytes),
        "objects": paper_objects(source),
        "derivations": paper_derivations(source),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--paper", type=Path, default=DEFAULT_PAPER)
    parser.add_argument("--emit-inventory", action="store_true")
    parser.add_argument("--inventory-only", action="store_true")
    parser.add_argument("--rebind", action="store_true")
    parser.add_argument("--acknowledge-correspondence-reviewed", action="store_true")
    args = parser.parse_args()

    if args.emit_inventory:
        observed = build_inventory(args.paper.resolve())
        print(json.dumps(observed, ensure_ascii=False, indent=2))
        return 0
    if args.rebind:
        if not args.acknowledge_correspondence_reviewed:
            raise SystemExit("rebind requires --acknowledge-correspondence-reviewed")
        observed = build_inventory(args.paper.resolve())
        INVENTORY.write_text(
            json.dumps(observed, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        print(f"current_theory_map_rebound={INVENTORY}")
        print(f"current_theory_map_objects={len(observed['objects'])}")
        print(f"current_theory_map_derivations={len(observed['derivations'])}")
        return 0
    stored = json.loads(INVENTORY.read_text(encoding="utf-8"))
    observed = stored if args.inventory_only else build_inventory(args.paper.resolve())

    expected_sequence = [(kind, label, int(marker.split()[-1])) for kind, label, marker in EXPECTED]
    observed_sequence = [
        (item["kind"], item["label"], item["number"])
        for item in observed["objects"]
    ]
    if observed_sequence != expected_sequence:
        raise SystemExit(
            "current paper object sequence drifted:\n"
            f"expected={expected_sequence}\nobserved={observed_sequence}"
        )

    if stored != observed:
        raise SystemExit("current theory inventory drifted from the live manuscript")

    observed_derivations = [
        (item["key"], item["binding"]) for item in observed["derivations"]
    ]
    if observed_derivations != EXPECTED_DERIVATIONS:
        raise SystemExit(
            "load-bearing derivation sequence drifted:\n"
            f"expected={EXPECTED_DERIVATIONS}\nobserved={observed_derivations}"
        )

    theorem_map = THEOREM_MAP.read_text(encoding="utf-8")
    ledger = LEDGER.read_text(encoding="utf-8")
    for kind, label, marker in EXPECTED:
        if f"## {marker}" not in theorem_map:
            raise SystemExit(f"missing theorem-map marker: {marker}")
        binding = BINDINGS[label]
        if binding not in theorem_map:
            raise SystemExit(f"missing theorem-map binding: {label} -> {binding}")
        if f'label := "{label}"' not in ledger:
            raise SystemExit(f"missing proof-ledger entry: {label}")
    for key, binding in EXPECTED_DERIVATIONS:
        if binding not in theorem_map:
            raise SystemExit(
                f"missing derivation-map binding: {key} -> {binding}"
            )

    root_imports = re.findall(
        r"^import\s+([^\s]+)", ROOT_MODULE.read_text(encoding="utf-8"), re.MULTILINE
    )
    if root_imports != ["BlackwellDilemma.CurrentPaperStatus"]:
        raise SystemExit(f"formal root is not current-paper-only: {root_imports}")

    print("current_theory_map_gate=passed")
    print(f"current_theory_map_objects={len(observed['objects'])}")
    print(f"current_theory_map_derivations={len(observed['derivations'])}")
    print(f"current_theory_map_manuscript_sha256={observed['manuscript_sha256']}")
    print(f"current_theory_map_live_paper_checked={not args.inventory_only}")
    print("current_theory_map_unfinished=0")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
