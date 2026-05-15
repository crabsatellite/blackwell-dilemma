# BlackwellDilemma — Lean 4 Formalisation

Machine-checked Lean 4 formalisation of:

> Alex Chengyu Li (2026). **Information Value Under Endogenous Feasibility.**
> SSRN preprint; submitted to *Theoretical Economics*.

The formalisation establishes a **label-level correspondence between every
labeled paper item and a Lean theorem** (12 definitions, 6 theorems,
16 propositions, 2 lemmas, 5 corollaries; see
[`PAPER_LEAN_CALIBRATION.md`](PAPER_LEAN_CALIBRATION.md) for the explicit
mapping), with two explicitly disclosed lattice-restricted sub-clause
gaps (the lattice variant of Theorem 4.1 Part 4 and the lattice-IDP
embedding-and-reduction proof of Part 6), both awaiting formalised
lattice and percolation-correlation-length infrastructure in Mathlib.

Every claim is exposed as a Lean declaration with its formalisation status
tracked in [`BlackwellDilemma/Ledger.lean`](BlackwellDilemma/Ledger.lean).

## Build

```bash
cd lean4
lake exe cache get
lake build BlackwellDilemma
```

This downloads the Mathlib build cache (`lake exe cache get`); never
rebuild Mathlib from scratch. After a successful build, run the axiom
audit:

```bash
lake env lean BlackwellDilemma/AxiomAudit.lean
```

The audit prints the axiom dependency list of every key theorem.
Expected output:

* **Lean kernel axioms** for every CLOSED entry: `propext`,
  `Classical.choice`, `Quot.sound`.
* **Paper-citation axioms** (named `<theorem-name>_paper_axiom`) for
  AXIOM-CITED and CLOSED-VIA-AXIOM-CITED entries.
* **Opaque types** declared in `Types.lean` (`Vertex`, `IsEdge`,
  `PercolationOutcome`, `IsOpen`, `reward`, `Phi`, `phi`, ...).

Any axiom outside these three categories is a RED FLAG.

## Module map

The formalisation follows the paper's section structure.

| File | Paper content |
| --- | --- |
| `Basic.lean` | §3 Theorem 3.1 — Canonical Welfare Decomposition `W = W_topo + W_info` |
| `SignalImmunity.lean` | §3 Theorem 3.1 final clause — `∂W_topo/∂β = 0` |
| `PhysicalIrreducibility.lean` | §3.1 Proposition `prop:physical` — `W_info ≤ 0`, oracle saturation |
| `Types.lean` | §2 IDP primitives (graph, percolation, signals, agents, conditions C1–C3) |
| `ClassicalResults.lean` | Blackwell 1953, Harris–Kesten, Grimmett 1999, Bollobás 2001, Molloy–Reed, Cohen et al., Topkis 1998 |
| `Wrongness.lean` | §3.2 Lemma `wrongness`, Lemma `conditional-reduction`, Theorem 3.2 `dilemma`, Prop `info-decay`, Prop `topo-cluster` |
| `Phase.lean` | §3.3 Theorem 3.3 `phase`, Prop `trap-prevalence`, Cor `er-phase`, Cor `power-law` |
| `Cognitive.lean` | §4 Theorem 4.1 `cognitive-threshold`, Prop `supermodular`, Cor `policy-complementarity`, Prop `sentimental`, Prop `threshold-alpha` |
| `Principal.lean` | §4.6 Def `principal`, Prop `principal-optimum`, Cor `disclosure` |
| `Canonical.lean` | §5 Prop `canonical` (4-state), Prop `interior-optimum` (5-state), Prop `three-regime`, Prop `p-monotonicity`, Prop `threshold-five-state`, Prop `bayesian-naive-five-state`, Cor `five-state-policy` |
| `Bayesian.lean` | §6 Theorem 5.1 `bayesian-immunity`, Prop `complementarity`, Rem `robustness-misspec` |
| `GeneralGraphs.lean` | §7 Def `greedy-path`, Theorem 6.1 `general-tree`, Ex `cyclic-trap`, Def `trap-tree`, Prop `error-compounding` |
| `Ledger.lean` | Status of every paper claim formalised here |
| `AxiomAudit.lean` | `#print axioms` for every theorem |

## Status summary

| Status | Count | Meaning |
| --- | ---: | --- |
| Paper-statement labels mapped to Lean theorems | **41 / 41** | 100% label-level correspondence (see `PAPER_LEAN_CALIBRATION.md`) |
| Cat 1 Infrastructure modules (Mathlib-PR-ready, kernel-pure) | 30 | Self-contained Cat 1 modules under `BlackwellDilemma/Infrastructure/` |
| Lattice-restricted disclosed gaps | 2 | Theorem 4.1 Part 4 lattice variant; Theorem 4.1 Part 6 lattice embedding-and-reduction proof |
| Retired `_paper_witness` axioms (post R141-R143 wire-up) | 0 | All 18 previously-axiomatised claims now flow through Cat 1 Infrastructure modules |

For full per-entry detail see `BlackwellDilemma/Ledger.lean`.

Each `theorem gap_<name>` exposes a paper-statement label as a Lean
theorem. The proof depends only on (a) Lean kernel axioms (`propext`,
`Classical.choice`, `Quot.sound`), (b) opaque carriers from
`Types.lean` (`Vertex`, `IsEdge`, `PercolationOutcome`, etc., which
are paper-novel primitives per Definition 1), and (c) at most one
paper-stipulated `_workingAssumption` axiom isolating the carrier-
identification needed for that specific result. The R141-R143 wire-up
sequence retired all 18 prior `_paper_witness` composite axioms,
replacing each with a smaller `_workingAssumption` plus a Cat 1
derivation through `BlackwellDilemma/Infrastructure/`.

## Convention: workingAssumption axioms

Each `axiom <name>_workingAssumption` corresponds to a specific
paper Definition that stipulates a structural property of an opaque
carrier (e.g., supermodularity of the κ-agent welfare functional,
divergence of κ* at the percolation threshold). Each axiom is a
single-step typed bridge per the
[`feedback_lean_axiom_decomposition`] discipline. Each axiom carries
a `paper source:` line citing the paper section/line.

Replacing a `_workingAssumption` axiom with a real Lean proof is a
strict improvement; the statement and downstream proofs are stable
under that substitution. The Cat 1 Infrastructure modules
(`BlackwellDilemma/Infrastructure/`) provide reusable Mathlib-PR-ready
abstract algebra (supermodularity, EVT extensions, Mills-tail bounds,
Gaussian conjugate-prior posterior, etc.) on which the paper-side
derivations are built.

## Relationship to the paper's published artifact

This Lean 4 formalisation is a **companion** to the paper, not a
replacement for the paper's mathematical exposition. Statements in the
paper that are formalised here also retain their natural-language
proofs in the manuscript; the Lean version provides an independent,
machine-checked record of the logical structure.

The paper itself notes (footnote to Theorem 3.1) that the formal
proof of the welfare-decomposition theorem and its signal-immunity
clause reduces to the three Lean 4 kernel axioms (`propext`,
`Classical.choice`, `Quot.sound`) with no paper-derived content
introduced as axioms. Across the full formalisation, the
paper-statement-to-Lean correspondence is one-to-one at the label
level; per-entry status (Cat 1 derived theorem vs. paper-stipulated
`_workingAssumption` axiom vs. opaque carrier) is documented in
`Ledger.lean` and verified in `AxiomAudit.lean`.
