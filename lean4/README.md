# BlackwellDilemma — Lean 4 Formalisation

Machine-checked Lean 4 formalisation of:

> Alex Chengyu Li (2026). **Information Value Under Endogenous Feasibility.**
> SSRN preprint; submitted to *European Journal of Operational Research*.

The formalisation covers all theorems, lemmas, propositions, corollaries,
definitions, and remarks of the paper. Every claim is exposed as a Lean
declaration with its formalisation status tracked in
[`BlackwellDilemma/Ledger.lean`](BlackwellDilemma/Ledger.lean).

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

## Status summary (Ledger)

| Status | Count | Meaning |
| --- | ---: | --- |
| **CLOSED** | 4 | Proof depends only on Lean kernel axioms |
| **CLOSED-VIA-AXIOM-CITED** | 9 | Lean theorem composes one or more paper-citation axioms |
| **AXIOM-CITED** | 15 | Statement exposed as a Lean theorem; proof appeals to a paper-citation axiom |
| **Total entries** | 28 | All paper claims |

The four **CLOSED** entries do not depend on any paper-cited axiom and
are unconditional Lean 4 + Mathlib theorems:

1. `BlackwellDilemma.WelfareSetup.welfare_decomposition` (Theorem 3.1)
2. `BlackwellDilemma.SignalFamily.W_topo_signal_immune` (Theorem 3.1
   signal-immunity clause)
3. `BlackwellDilemma.WelfareSetup.physical_irreducibility` (Proposition
   `prop:physical`, plus its `W_info_nonpos`, `oracle_W_info_zero`,
   `welfare_le_W_topo`, `oracle_welfare_eq_W_topo` corollaries)
4. `BlackwellDilemma.topo_cluster_relation` (closed-form
   `(n−k)/((n+1)(k+1))`)

`CLOSED-VIA-AXIOM-CITED` entries are real Lean theorems whose
proofs invoke a paper-citation axiom. Examples: `Wrongness.dilemma`,
`Bayesian.bayesian_immunity`, `Canonical.fiveState_policy_mapping`,
`Phase.er_phase_subcritical`.

`AXIOM-CITED` entries declare the statement as a paper-citation axiom
because the proof requires either (a) a Mathlib component that does
not yet exist (Blackwell ordering, Harris–Kesten, Molloy–Reed,
configuration-model percolation, supermodularity), or (b) an analytic
derivation (continuity of `m(κ)`, intermediate value theorem on the
estimate gap, Φ-tail integral) that we did not commit to a full Lean
proof. Each axiom carries a `paper source:` line citing the paper
section/line.

## Convention: paper-citation axioms

Following the **Hodge Lean 4 formalisation** convention, each
`axiom <name>_paper_axiom` corresponds to a specific theorem,
proposition, lemma, or corollary in the paper. The axiom name encodes
the role:

* `<lemma-name>_paper_axiom` for paper-side lemmas.
* `<thm-tag>_paper_axiom` for paper-side theorems.
* `<author-year>_paper_axiom` for external classical results from the
  bibliography.

Replacing a paper-citation axiom with a real Lean proof is a strict
improvement; the statement and downstream proofs are stable under that
substitution.

## Relationship to the paper's published artifact

This Lean 4 formalisation is a **companion** to the paper, not a
replacement for the paper's mathematical exposition. Statements in the
paper that are formalised here also retain their natural-language
proofs in the manuscript; the Lean version provides an independent,
machine-checked record of the logical structure.

The paper itself notes (line 238, footnote to Theorem 3.1):

> A machine-checked Lean 4 formalisation of this theorem, its
> signal-immunity clause, and Proposition `prop:physical` is provided
> as a companion artifact; the formal proofs reduce to the three
> Lean 4 kernel axioms (`propext`, `Classical.choice`, `Quot.sound`)
> with no paper-derived content introduced as axioms.

That footnote applies to the four **CLOSED** entries above. The
remaining 24 entries extend the formalisation scope while introducing
explicit paper-citation axioms whose role is documented in
`Ledger.lean`.
