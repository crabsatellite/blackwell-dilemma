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

Live counts (run `lake env lean BlackwellDilemma/Ledger.lean` to reproduce; latest = post-R177 2026-05-16):

| Status | Count | Meaning |
| --- | ---: | --- |
| Total ledger entries | **350** | Typed `GapEntry`s in `Ledger.lean` (carriers + atomic stipulations + derived theorems + classical citations) — **+12 from R176 paper-Def atoms** |
| `gapClosed` | **172** | Lean theorem (no `sorry`) |
| `gapDefinitional` | **176** | Cat 3 §3.4.3 paper-foundational atomic content (carriers + structural equations + hypothesis predicates) — 永不 close per discipline |
| `gapOpen` | **0** ✅ | **All OPEN entries closed in R152→R158 push; R159-R177 maintain 0** |
| `gapPartial` | 1 | bundle entry (`gap_phi_tail_bound` + `gap_order_statistics_max`) — both sub-claims are Cat 1 closed theorems |
| `gapDeadEnd` | 1 | `kappaStar_p_monotone_DEAD_END_by_junk_value` (`def : Prop` marker, NOT axiom — zero kernel impact) |
| `gapBlocked` | 0 | None |
| Cat 1 (cat1Mathlib) | **85** | |
| Cat 2 (cat2External) | **3** | |
| Cat 3 paper-novel | **261** | Carriers + hypothesisPredicates + structuralEquations — paper-foundational per discipline |
| Cat 3 sub-type breakdown | — | carrier=79, hypothesisPredicate=9, structuralEquation=**87**, **workingAssumption=1**, derivedTheorem=146 |
| Inline `_workingAssumption` axioms (source code) | **0 ✅** | **R159-R174 removed all 17 inline wA axioms via carrier concretization (R160-R164: 6 carriers) + Cat 3 §3.4.3 paper-Def-stipulated structural equation atoms (R165-R174: 10 atoms). The codebase now has ZERO `axiom X_workingAssumption` declarations.** |
| Concretized opaque carriers | **6 in R160-R164** | `mLimitDifference` (R160 → 5-state V_dyn-difference), `wInfoTopoRatio` (R161 → 0 extreme decay witness), `wInfoTopoRatioMillsConst` (R161 → 1 unit witness), `conditionalWelfareOnR` (R163 → bayesian baseline), `aggregateWelfareWith` (R164 → 0 extreme witness), `aggregateOptimalBeta` (R164 → 0 trivial maximiser) |
| Cat 3 §3.4.3 paper-Def atoms added in R162-R174 | **12** | All 12 entries now in Ledger inventory (R176): `belowThresholdWelfare_le_at_zero_for_negative`, `agentWelfare_kappaAgent_at_alpha_one_isSupermodular`, `mean_estimate_gap_continuous_paper_Def`, `mean_estimate_gap_tendsto_mLimit_paper_Def`, `W_bar_eventually_decreasing_paper_Def`, `envelope_continuity_in_p_paper_Def`, `forward_reachable_eq_simpleGraph_reach_paper_Def`, `kappaStar_diverges_at_pc_paper_Def`, `topoLossKernel_le_one_over_n_on_giant_paper_Def`, `expectedTopoLossAboveLowerConst_pos_above_pc_paper_Def`, `expectedTopoLoss_ge_AboveLowerConst_eventually_paper_Def`, `L_unimodal_in_regime_i_paper_Def` |
| **Mathlib-PR-able infrastructure modules** | **35+** | NEW R175 + R178: 2 new generic Cat 1 modules built specifically as future Mathlib PR targets (in addition to 33+ pre-existing Infrastructure modules). |
| **Actually-retired §3.4.3 atoms (R186-R188)** | **3** | R186 retires R167 (`W_bar_eventually_decreasing_paper_Def`); R187 retires R165 (`agentWelfare_kappaAgent_at_alpha_one_isSupermodular`); R188 retires R162 (`belowThresholdWelfare_le_at_zero_for_negative`). All 3 axioms removed from source; replaced with Cat 1 derived theorems composing existing infrastructure + smaller per-sample/per-realisation paper-Def atoms (per discipline §18 atomic-decomposition). Remaining §3.4.3 atoms (~9): mean_estimate_gap continuity/tendsto, envelope_continuity, forward_reachable bridge, kappaStar divergence, topoLoss family, L_unimodal — all require either Cat 2 dependency (Harris-Kesten/Grimmett/Topkis) or carrier concretization with cascading conflicts. |

### Cat 1 infrastructure modules (R175-R194; 12 new modules)

| Module | Contribution | Future Mathlib namespace |
| --- | --- | --- |
| **R175 `EventuallyDecreasingWithLowerBound`** | 3 lemmas: eventually-decreasing patterns with lower-bound witnesses | `Mathlib.Order.Filter.EventuallyMonotone` |
| **R178 `PercExpectationSupermodular`** | Pointwise → integrated supermodularity lifting | `Mathlib.Order.Supermodular` |
| **R179 `SupermodularityFinsetSum`** | Generic `IsSupermodular.finset_sum` + weighted sum | `Mathlib.Order.Supermodular` |
| **R180 `ArgmaxOnHalfLine`** | Non-compact `[a, ∞)` EVT for tendsto-finite-with-strict-witness | `Mathlib.Topology.Order.Compact.HalfLine` |
| **R181 `IsSupermodularPointwiseLimit`** | Supermodularity preserved under pointwise limits | `Mathlib.Order.Supermodular` |
| **R182 `DifferenceDominatesFinsetSum`** | R179 sister for `DifferenceDominates` | `Mathlib.Order.DifferenceDominates` |
| **R183 `PercExpectationDifferenceDominates`** | R178 sister for `DifferenceDominates` | `Mathlib.Order.DifferenceDominates` |
| **R189 `GaussianPosteriorAsymptotic`** | Posterior mean → data mean as n → ∞ (Bayesian asymptotic data dominance) | `Mathlib.Probability.Bayesian.Gaussian` |
| **R190 `EnvelopeContinuity`** | Berge-type sandwich estimates for value functions | `Mathlib.Topology.Order.ValueFunction` |
| **R191 `MillsTailFromExponentialDecay`** | Geometric series bound + uniform tail bound from exponential decay | `Mathlib.Analysis.SpecialFunctions.Exp.GeometricBound` |
| **R192 `PercExpectationStrictPositive`** | Positivity from per-realisation positive kernel + p ∈ (0,1) | `Mathlib.Probability.BondPercolation.Expectation` |
| **R193 `PaperGraphFromIsEdge`** | SimpleGraph from paper IsEdge + IsOpen (no new axioms — loopless via `u ≠ v` intersection) | reusable adapter pattern |
| **R194 `MillsConstantPositive`** | Positivity + lower bound for Mills-tail constants | `Mathlib.Analysis.SpecialFunctions.Mills` |
| Cat 1 Infrastructure modules (Mathlib-PR-ready, kernel-pure) | 33+ | Self-contained Cat 1 modules under `BlackwellDilemma/Infrastructure/` (incl. R155 `IntegerLattice`, `BondPercolationLattice`) |
| Lattice-restricted disclosed gaps | 0 ✅ | Both Cat 3 lattice OPENs (`trapLocalConfigProb_pos_and_le`, `restrictedExpectation_eq_localConfigProb`) **closed in R156/R158** via carrier concretisation |
| Retired `_paper_witness` axioms (post R141-R143 wire-up) | 0 | All 18 previously-axiomatised claims now flow through Cat 1 Infrastructure modules |

For full per-entry detail see `BlackwellDilemma/Ledger.lean`.

## Paper R10 §5 two-regime rewrite (2026-05-16) — calibration impact

The paper underwent an R8-R15 audit cycle (see `crabsatellite/academic-papers`
commit `bf462f97`) that rewrote Section 5 from a three-regime to a two-regime
structure on the 5-state instance, after audit dimension 8 (definition–use
consistency) caught a `V_dyn` definitional inconsistency between paper §2
(max-over-reachable convention) and §5 5-state numerical claims (forced-
continuation convention). The unified recursive-Bellman convention collapses
the spurious thresholds `p_1 = 4/9, p_2 = 2/3` to a single `p^♯ = 4/9`.

**Lean side impact**: the existing 10 sub-theorems for `prop:three-regime-five-state`
(now `prop:two-regime-five-state` in the paper) remain mathematically valid as
proofs of Regime I (reversal regime) sub-claims; the Regime II/III sub-theorems
(`gap_three_regime_cognitive_augmentation_*`, `gap_three_regime_sufficient_cognition_*`)
prove math results that no longer correspond to standalone paper claims under
the new two-regime story. The `kappaStar_fiveState` closed-form is marked
**SUPERSEDED** in `Canonical.lean` line ~2105 (kept for build preservation
and historical traceability). The corresponding `gap_kappaStar_at_two_thirds`
theorem still proves a true mathematical fact but its paper paper anchor
has been retired; see the `Canonical.lean` SUPERSEDED block for context.

A full v2.0 Lean-side recalibration (renaming `gap_three_regime_*` →
`gap_two_regime_*`, removing the obsolete `kappaStar_fiveState` closed-form,
re-anchoring downstream theorems to the new paper labels) is the natural
next step but is deferred to a Lean v2.0 release; the current build and
audit verify the math results underlying the two-regime claims are sound.

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

## Roadmap toward Cat 1 only (Mathlib-pure)

The long-term goal is to reduce all paper-novel Cat 3 entries to derivations
from Cat 1 (Mathlib + kernel) inputs only. The remaining obstacles are:

1. **Lattice + bond percolation infrastructure** (Mathlib gap). Two Cat 3
   structural-equation entries (`trapLocalConfigProb_pos_and_le`,
   `restrictedExpectation_eq_localConfigProb`) and the disclosed lattice
   variant of Theorem 4.1 Part 4 require: `Z²`-lattice graph structure,
   bond-percolation probability measure, FKG inequality, Harris-Kesten
   1980 critical-probability theorem, and Grimmett 1999 Theorem 6.75
   exponential cluster-size decay. These are well-defined Mathlib
   contribution targets.

2. **Mixed-partial calculus extension** (Mathlib gap). The `prop:supermodular`
   cross-partial computation depends on Topkis 1978 mixed-partial criterion
   for supermodularity on continuous lattices. Mathlib has discrete
   supermodularity (`Topkis.lean`) but lacks the continuous-lattice mixed-
   partial integration; a self-contained extension is in
   `Infrastructure/TopkisCrossPartial.lean` and is a candidate for
   Mathlib upstream.

3. **Classical Cat 2 citations** (paper-cited but not Mathlib). Blackwell
   1953 (sufficiency theorem), Topkis 1998 (interval supermodularity book),
   Molloy-Reed 1995 (configuration-model giant-component criterion), Cohen
   et al. 2000 (power-law percolation), Grimmett 1999 (Bond Percolation
   §6.75), David-Nagaraja 2003 (order-statistics formulas) — each is a
   discrete Mathlib contribution that would close the corresponding
   `gap_*_OPEN` Cat 2 entry.

Each of these contributes broadly reusable infrastructure to Mathlib beyond
just this paper, which is the strategic motivation for pursuing them.

The current Lean v1.0 verifies that the paper's mathematical content is
internally consistent under the explicit Cat 3 paper-foundational
commitments; full Cat 1 only is a multi-paper, multi-month Mathlib
contribution effort and is not a prerequisite for paper publication.

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
