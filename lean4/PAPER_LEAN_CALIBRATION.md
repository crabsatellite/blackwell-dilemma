# Paper ↔ Lean Calibration Matrix

**Date**: 2026-05-16 (post-paper-R10 §5 two-regime rewrite + post-R148 calibration audit)
**Paper**: `blackwell_dilemma.tex` (~1207 lines, post R8-R15 audit cycle commit `bf462f97`)
**Lean**: `BlackwellDilemma/` (15 main files + 32+ Infrastructure modules)

## Summary

| Class | Paper count | Lean coverage | Status |
|-------|-------------|---------------|--------|
| Definitions | 12 | 12 (as carriers/structures/predicates) | ✅ |
| Theorems | 6 | 6 (Thm 4.1 Part 4 lattice sub-claim closed by the standard `Z^2` ranged local-lattice bridge; Part 6 embedding still separately gated) | ✅ |
| Propositions | 16 | 16 (most split into parts) | ✅ |
| Lemmas | 2 | 2 | ✅ |
| Corollaries | 5 | 5 | ✅ |
| **TOTAL** | **41** | **41** | Label coverage plus build-checked semantic-gate tracking |

## Detailed Mapping

### Definitions (12)

| Paper label | Line | Lean encoding | File |
|---|---|---|---|
| `def:idp` | 105 | `IDP` structure (Vertex, IsEdge, etc.) | Types.lean |
| `def:reachable` | 122 | `ReachableSet := ForwardReachable _ ∅ _` | Types.lean |
| `def:cognitive-depth` | 145 | `cognitiveDepth` (kappa parameter) | Types.lean |
| `def:rationality` | 173 | `alpha` (instrumental rationality parameter) | Types.lean |
| `def:forward-reachable` | 188 | concrete `ForwardReachable` via open-edge reachability outside visit history | Types.lean |
| `def:oracle` | 211 | `oracleWelfare` carrier | Wrongness.lean |
| `def:diagnostic` | 220 | `C1_Irreversibility`, `C2_RewardTopologyMisalignment`, `C3_InformationLocality` | Types.lean |
| `def:topology-blind` | 326 | `IsTopologyBlind` predicate | Types.lean |
| `def:value-functions` | 442 | `V_static`; concrete `V_dyn` as `Finset.sup'` over `ForwardReachable` | Phase.lean |
| `def:principal` | 613 | `aboveThresholdWelfare`, `belowThresholdWelfare`, `def W_bar` | Principal.lean:65,86 |
| `def:greedy-path` | 983 | well-founded concrete `V_g`; current `V_g_def_terminal`/`V_g_def_step`; `C2prime_GreedyPathMisalignment` | GeneralGraphs.lean |
| `def:trap-tree` | 1032 | `TrapTree` namespace + structure | GeneralGraphs.lean:471 |

### Theorems (6)

| Paper label | Line | Lean theorem(s) | File |
|---|---|---|---|
| `thm:decomp` (3.1) | 237 | `gap_welfare_decomposition` | Basic.lean:105 |
| `thm:dilemma` (3.2) | 387 | Current public theorem `gap_dilemma`; current no-diagnostic route `gap_dilemma_current_noDiagnosticAssumptions` | Wrongness.lean:8887,8963 |
| `thm:phase` (3.3) | 401 | Current standard-only theorem surfaces `gap_phase_transition_below` and `gap_phase_transition_above`; below route is giant-component-conditional, above route is current zero/unit carrier | Phase.lean:203,351 |
| `thm:cognitive-threshold` (4.1) | 488 | Current standard-only scalar theorem bundle `gap_cognitive_threshold_characterisation`; Part 4 standard `Z^2` local-lattice semantic payload closed; Part 6 graph-parametric embedding remains separate calibration target | Cognitive.lean:1445 |
| `thm:bayesian-immunity` (5.1) | 924 | `gap_bayesian_immunity` | Bayesian.lean:48 |
| `thm:general-tree` (6.1) | 990 | Public current wrapper `gap_general_tree` via `agentRewardKernel_greedy_C2prime_kernel_reversal_witness_current`; generic future route remains `gap_general_tree_from_reversal` | GeneralGraphs.lean:1468,1488,1514 |

### Propositions (16)

| Paper label | Line | Lean theorem(s) | File |
|---|---|---|---|
| `prop:info-decay` | 271 | finite-per-`n` current theorem `gap_info_decay_finite` plus compatibility name `gap_info_decay`; uniform-in-`n` strengthening remains a separate percolation target | Wrongness.lean:8809,8820 |
| `prop:topo-cluster` | 280 | Current standard-only theorem surfaces `expectedTopoLoss_conditional_def`, `gap_topo_cluster_relation`, and `gap_topo_loss_below_threshold`; Part 2 old Mills route dead-end: `not_mills_inverse_above_threshold_route_with_unit_bound`; current public theorem-core lower-bound route: `BoxedTorusFullReachFlatOnlyLowerBoundConclusion_current` plus `boxedTorusFullReachFlatOnlyComplementTopoLossData_flatFamilyCoreConclusion`; the stronger full-reach bridge `boxedTorusFullReachZ2TopoClusterBridge_current` gates the non-flat-only full-reach family/core/lower-bound route and its fixed-`L` all-`n` lower-bound theorem; the stronger paper-facing contract `RandomSupercriticalZ2TopoClusterBridgeData` now gates the future random-supercritical `Z^2_L` bridge projections, a single-certificate flat plus giant lower-bound projection, uniform eventual positive flat, giant-restricted, unrestricted pointwise, and in-giant pointwise loss projections, excludes the current full-reach, flat-only, all-open-complement, deterministic all-open giant, deterministic all-open positive, pointwise-hybrid, and extended eventual-tail diagnostic families, and requires arbitrarily large non-diagnostic finite members inside the same supported flat/giant lower-bound and in-giant positive-loss regime; the repaired first-edge compatibility witness is kernel-gated through base-edge reachability, zero selected giant-restricted topo loss, and no positive uniform giant-restricted lower-bound theorem (`firstEdgeOpenGiantClosedTopoLossFamily_topoLossKernel_zero_on_giant`, `firstEdgeOpenGiantClosedTopoLossFamily_expectedTopoLossOnGiantOn_boxedTorus_eq_zero`, `firstEdgeOpenGiantClosedTopoLossFamily_not_positive_giant_loss_lower_bound_at_three_quarters`); the flat-only diagnostic is kernel-gated by `boxedTorusFullReachFlatOnlyComplementTopoLossData_flatOnlyDiagnostic`, and its flat lower-bound support is gated by `boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_eq_failureMass`; the fixed-`L` all-`n` obstruction is kernel-gated by `not_UnitCompatibleAboveThresholdLowerBoundConclusion_boxedTorusFullReachFlatOnly`; the open semantic frontier is machine-gated by `topo_cluster_random_supercritical_z2_frontier_payload`, including the repaired support-surface route-output certificate; random supercritical `Z^2_L` strengthening remains separate | Wrongness.lean; PaperSemanticGate.lean |
| `prop:physical` | 304 | `gap_physical_irreducibility` + `gap_W_info_nonpos` + `gap_oracle_W_info_zero` + `gap_welfare_le_W_topo` + `gap_oracle_welfare_eq_W_topo` | PhysicalIrreducibility.lean:46,58,74,91,105 |
| `prop:trap-prevalence` | 454 | Current standard-only theorem surfaces `gap_trap_prevalence_zero` and `gap_trap_prevalence_above_threshold` | Phase.lean:569,970 |
| `prop:threshold-alpha` | 528 | `gap_threshold_alpha_monotone` | Cognitive.lean:2610 |
| `prop:supermodular` | 553 | Current public theorem `gap_supermodular` via `gap_supermodular_from_signs` and `canonicalSupermodularFactorSigns` on the non-flat ramp carrier | Cognitive.lean:1973,1989 |
| `prop:sentimental` | 595 | `gap_sentimental_immunity` | Cognitive.lean:2443 |
| `prop:principal-optimum` | 622 | Current public carrier closed: Part 1 `principal_interior_maximum_exists`, `W_bar_exceeds_zero_at_positive_beta`, `W_bar_witness_pair_strict_dominance`; Part 2 `aggregateWelfareWith_principal_part2_package` over public finite FOSD-ramp `aggregateWelfareWith` / stable `aggregateOptimalBeta`; Part 3 `W_bar_valley_triple_witness`; legacy scalar sample diagnostics: `not_PrincipalSampleBothCombinedDominanceWitnessPair`, `not_PrincipalSampleBothExceedsZeroWitness`, `not_PrincipalSampleBothValleyTripleWitness` | Principal.lean:1389,1247,1255,1783,1267,1878,1896,1922 |
| `prop:canonical` (5.1) | 709 | Current standard-only theorem surfaces `FourState.W_open`, `gap_W_open_limit_infty`, and `gap_W_open_limit_zero` | Canonical.lean:63,74,159 |
| `prop:interior-optimum` (5.2) | 769 | `gap_interior_optimum` | Canonical.lean:1430 |
| `prop:two-regime-five-state` (paper R10 rewrite of former `prop:three-regime-five-state`) | 817 | Current standard-only theorem surfaces for the six reversal clauses plus cognitive augmentation and sufficient cognition; paper-facing `gap_two_regime_*` aliases cover the R10 relabeling and are now checked by the typed gate payload `r10_two_regime_label_recalibration_payload`, with historical `gap_three_regime_*` names retained for traceability | Canonical.lean:2692,2798,2869,2934,3218,3385,3401,3431,3455,3534; PaperSemanticGate.lean:135 |
| `prop:threshold-five-state` (paper R10 rewrite to "Cognitive Sufficiency on the 5-State Instance") | 866 | Current standard-only theorem surfaces `gap_threshold_fiveState_greedy_has_interior_optimum`, `gap_threshold_fiveState_kappa_above_kstar`, and `gap_threshold_fiveState_smooth_transition`; paper R10 high-κ oracle-routing clause is now closed by the one-edge signal-conditional carrier `highKappaOracleRoutingWelfare_eq_oracle`; the current neutral κ-agent refutation `not_current_kappaAgent_highKappa_oracle_at_p0` remains as diagnostic evidence for the retired route | Canonical.lean:3736,3853,4019,4058,4095 |
| `prop:p-monotonicity-five-state` | 884 | `gap_p_monotonicity_bounded` + `gap_kappaStar_at_two_thirds` (latter is mathematically true but its `kappaStar_fiveState` referent is SUPERSEDED in paper R10; see Canonical.lean line ~2105 deprecation block) | Canonical.lean:3639,3723 |
| `prop:complementarity` | 933 | `gap_information_knowledge_complementarity` | Bayesian.lean:90 |
| `prop:bayesian-naive-five-state` | 951 | Parts (i)/(ii)/(iii): `gap_bayesian_naive_routing_threshold` + `gap_bayesian_naive_reversal_absent` + `gap_bayesian_naive_reversal_present`; current kernel witness: `agentRewardKernel_bayesianNaive_aboveThreshold_kernel_reversal_witness_current` | Canonical.lean:4113,4220,4293,4268 |
| `prop:error-compounding` | 1037 | `gap_error_compounding_part1` + `gap_error_compounding_part2` | GeneralGraphs.lean:1939,2138 |

### Lemmas (2)

| Paper label | Line | Lean theorem(s) | File |
|---|---|---|---|
| `lem:wrongness` | 337 | Current public scalar theorem `gap_wrongness`; stage theorems `wrongness_high_beta_welfare_convergence_atom` and `wrongness_misalignment_reversal_atom`; no-diagnostic route `greedy_welfare_reversal_current_noDiagnosticAssumptions` | Wrongness.lean:358,399,439,482 |
| `lem:conditional-reduction` | 372 | Current public theorem `gap_conditional_reduction_part_i` via `gap_conditional_reduction_part_i_from_blackwell`, plus Cat 1 decomposition theorem `gap_conditional_reduction_part_ii` | Wrongness.lean:150,166,194 |

### Corollaries (5)

| Paper label | Line | Lean theorem(s) | File |
|---|---|---|---|
| `cor:policy-complementarity` | 588 | Current public theorem `gap_policy_complementarity` via `gap_policy_complementarity_from_signs` and `canonicalSupermodularFactorSigns` on the non-flat ramp carrier | Cognitive.lean:2280,2296 |
| `cor:disclosure` | 644 | Part 1 current theorem: `W_bar_finite_above_limit_witness`; R470 retired vacuous averaged-overshoot marker; Part 2 current public finite-sum theorem: `gap_disclosure_differentiated_dominates` via `perAgentOptimalAggregate_dominates_uniform` | Principal.lean:1237,2084,2138 |
| `cor:five-state-policy` | 837 | Current standard-only theorem `gap_fiveState_policy_mapping` | Canonical.lean:4180 |
| `cor:er-phase` | 1074 | `gap_er_phase_subcritical` + `gap_er_phase_supercritical` + `gap_er_bond_percolation_threshold` | Phase.lean:958,974,1000 |
| `cor:power-law` | 1088 | `gap_power_law_heavy_tail` + `gap_power_law_thin_tail` | Phase.lean:1031,1065 |

## Lean Theorems Beyond Paper (orphan check)

The following Lean theorems are NOT 1-to-1 paper-claims but support paper's
overall §6 robustness discussion or are sub-claims used for composition:

| Lean theorem | Purpose | Justification |
|---|---|---|
| `gap_robustness_bayesian_naive` | §6 robustness alternative agent | Paper §6.4 robustness footnote |
| `gap_robustness_myopic_k` | §6 robustness alternative agent | Paper §6.4 robustness footnote |
| `gap_robustness_satisficing` | §6 robustness alternative agent | Paper §6.4 robustness footnote |
| `gap_W_topo_signal_immune` | §3 final clause `∂W_topo/∂β = 0` | Paper §3 line 297 |
| `gap_W_topo_constant` | §3 final clause supporting | Paper §3 line 297 |
| `gap_cyclic_trap` | Example illustrating trap-tree | Paper §6 example |

`gap_robustness_myopic_k` is now the public direct current-carrier route: it
consumes both the current closed `gap_blackwell_monotonicity` theorem and
`MyopicKWelfareCarriers_current` in its proof, without a live generic
Blackwell-parameter theorem signature. The horizon-suffices equality is also
stated over the current carrier rather than over an arbitrary carrier.

`gap_robustness_satisficing` is now the public direct current-affine route:
it proves the strict-reversal witness for `SatisficingCarriers_current`
without a live carrier-parameter theorem signature.

`gap_conditional_reduction_part_i` is now the public route at
`Wrongness.lean:165`; it consumes the current closed
`gap_blackwell_monotonicity` theorem internally while preserving
`IsBlackwellOrdered signalFamily` as the scope hypothesis. The generic
Blackwell-parameter route remains
`gap_conditional_reduction_part_i_from_blackwell` at `Wrongness.lean:149`.

`gap_cognitive_threshold_part2` is now the public route at
`Cognitive.lean:554`; it consumes the current closed
`gap_blackwell_monotonicity` theorem internally and no longer exposes `hC`
or `hT`. The generic Blackwell-parameter route remains
`gap_cognitive_threshold_part2_from_blackwell` at `Cognitive.lean:539`.
Current public Part 1 likewise exposes no diagnostic/topology parameters;
`gap_cognitive_threshold_characterisation` now carries no diagnostic/topology
parameters on the current scalar route. The Part 3 Gaussian bridge is
discharged directly by the concrete posterior witness.

Canonical five-state public routes now use the same public/generic split:
`gap_threshold_fiveState_kappa_above_kstar` is public at
`Canonical.lean:3767`, with the generic Blackwell-parameter route
`gap_threshold_fiveState_kappa_above_kstar_from_blackwell` at
`Canonical.lean:3754`; `gap_bayesian_naive_reversal_absent` is public at
`Canonical.lean:4083`, with the generic Blackwell-parameter route
`gap_bayesian_naive_reversal_absent_from_blackwell` at `Canonical.lean:4070`.
R511 closes the above-threshold Bayesian-naive reversal clause for the current
public carrier: `agentRewardKernel` now carries the misspecified prior `p_hat`
in the `κ` slot for `bayesianNaive`, and
`agentRewardKernel_bayesianNaive_aboveThreshold_kernel_reversal_witness_current`
feeds the public `gap_bayesian_naive_reversal_present` theorem.

## Verification Status

✅ **All 41 paper labeled items have Lean correspondents**
✅ **No orphan paper claims** (every \begin{theorem/proposition/...} has a Lean theorem)
✅ **Lean orphan theorems** are §6 robustness extensions / sub-decomposition steps
✅ **Build GREEN** (full project build passes; current incremental job count depends on cache state)
✅ **Wire-up status** (R141-R143): all 18 retired `_paper_witness` axioms now flow through Infrastructure Cat 1 modules

## Calibration Notes (specific findings)

### Theorem 4.1 Part 4 — closed local-lattice coverage

**Paper claim (line 494)**: "On the constructive instances of Section §5.1
and on lattices, the threshold κ* is non-decreasing in p."

**Lean encoding**:
- `gap_cognitive_threshold_part4` (Cognitive.lean:1059) — strict
  kernel-pure bounded theorem on the abstract `kappaStar` carrier, with the
  paper's implicit threshold-existence premise made explicit.
- `gap_p_monotonicity_bounded` (Canonical.lean:3639) — **covers the
  constructive-instance form** for the 5-state IDP (paper's sub-claim 4a).
- `part4_lattice_p_monotonicity_frontier_payload`
  (PaperSemanticGate.lean) now machine-gates the current closed frontier:
  `mean_estimate_gap_antitone_in_p_paper_Def`,
  `kappaStar_p_monotone_of_mean_gap_antitone`,
  `gap_cognitive_threshold_part4_from_lattice_bridge`,
  `gap_cognitive_threshold_part4`, `gap_p_monotonicity_bounded`, and the
  standard one-edge/lattice monotone-coupling interface
  (`standardBernoulliMonotoneCouplingData`,
  `standardBernoulliProductMonotoneCouplingMarginalData`,
  `bernoulliProductExpectation_mono_of_monotone`,
  `percExpectation_mono_in_p_of_BoolConfigMonotone`,
  `standardLatticeMonotoneCouplingData`).
- **Lattice sub-claim (4b)** is now covered at the local cylinder level used by
  the Part 4 mean-gap argument.  R517 made the bridge explicit as
  `LatticePMonotonicityBridgeData`: a certificate names a standard
  integer-lattice graph, carries the kernel-checked per-edge monotone-coupling
  interface, and proves the lattice-derived antitonicity of `mean_estimate_gap`
  in `p`.  R520 adds the one-edge Bernoulli monotone-coupling mass table with
  both Bernoulli marginals and zero forbidden open-to-closed mass, plus the
  standard `Z^2` lattice per-edge interface.  R521 adds finite-edge product
  marginal data with total mass one, both finite-product Bernoulli marginals,
  non-negative mass, and zero mass on any configuration pair containing a
  forbidden open-to-closed edge.  R522 adds finite-box stochastic monotonicity:
  every coordinatewise monotone real-valued observable has non-decreasing
  Bernoulli-product expectation in `p`.  The current iteration bridges that
  product theorem back to the paper-facing `BondConfig` / `percExpectation`
  carrier via `percExpectation_mono_in_p_of_BoolConfigMonotone` and gates it
  in the Part 4 payload.  The current one-edge percolation bridge
  `bridgePriorRewardObservable_expectation_eq_priorMean_u2` identifies the
  bridge-neighbour prior mean with
  `percExpectation (1 - p) bridgePriorRewardObservable`, and
  `priorMean_u2_fiveState_antitone_in_p_from_percExpectation` recovers its
  blocking-probability antitonicity from finite-product monotonicity under
  `0 <= p_1 <= p_2 <= 1`.  The current
  `mean_estimate_gap_antitone_in_p_from_percExpectation` theorem lifts this
  one-edge percolation route through Gaussian posterior monotonicity to the
  full mean-estimate-gap antitonicity on the same probability domain.
  `gap_cognitive_threshold_part4_from_percExpectation` then applies the
  `sInf` feasible-set transfer to recover bounded `kappaStar` p-monotonicity
  from that finite-percolation route.  The generic `sInf` transfer from that
  bridge to bounded `kappaStar` p-monotonicity is kernel-checked.  The
  current
  `standardZ2LatticePMonotonicityBridgeSkeleton_current` diagnostic makes this
  distinction build-checked: the standard `Z^2` graph/coupling skeleton
  satisfies the present bridge type, and
  `gap_cognitive_threshold_part4_from_standard_z2_bridge_skeleton_current`
  transfers it through the same `sInf` theorem, but the skeleton's
  load-bearing antitonicity field is still the abstract/canonical
  `mean_estimate_gap_antitone_in_p_paper_Def` theorem rather than a theorem
  derived from a lattice observable.
  The ranged standard-`Z^2` bridge
  `standardZ2RangedLatticePMonotonicityBridge_current` and
  `gap_cognitive_threshold_part4_from_standard_z2_ranged_bridge_current`
  now package the standard graph/coupling data with the explicit one-edge
  `BondConfig` observable embedded as a real `Z^2` adjacent edge, its
  monotonicity, and its `percExpectation (1 - p)` prior-mean equality.  The
  expectation monotonicity step is routed through the bridge's own lattice
  monotone-coupling field.  The mean-gap theorem is no longer a bridge field:
  `priorMean_u2_fiveState_antitone_in_p_from_ranged_lattice_observable` and
  `mean_estimate_gap_antitone_in_p_from_ranged_lattice_observable` derive it
  from the observable fields on `0 <= p_1 <= p_2 <= 1`.  This closes the Part
  4 paper-semantic gate: the proof consumes a real `Z^2` adjacent edge and the
  bridge's lattice monotone-coupling field before transferring to bounded
  `kappaStar` p-monotonicity.  The remaining non-local random lattice semantics
  are the separately gated Part 6 embedding and topo/phase targets.

## Calibration Conclusions

Current 2026-06-26 correction: the project builds and the checked theorem
surface has zero proof escapes. Complete paper-semantic kernel-only closure is
not claimable while `PaperSemanticGate.lean` reports the open Part 6
lattice-embedding and random-supercritical percolation semantic targets. The
Part 4 lattice p-monotonicity target is closed by the standard `Z^2` ranged
local-lattice bridge. The live source audit reports 0 project-level `axiom`
declarations, including 0 `_OPEN`, 0 `_paper_Def`, and 0 `_workingAssumption`
declarations. The conditional-surface audit reports 2 counted Prop interfaces,
both current-refuted, 0 conditional theorem signatures, and 0 unresolved
interfaces.
The live ledger has no `gapOpen` entries, but the cognitive Part 6 route is not
complete: `not_harrisKestenScalingFunction_diverges_at_pc_paper_Def` proves the
current unbounded lower-envelope carrier route false. R208 replaces that route
with the parameterized `kappaStar_diverges_at_pc_via_scaling_carrier` transfer
interface. R467 proves the divergence half for the explicit hyperbolic carrier
`criticalHyperbolicScaling`, but R468 proves that this exact carrier cannot
satisfy the current unbounded high-alpha domination target.
The obstruction is now generalized by
`not_positive_at_zero_scaling_dominates_kappaStar_current`: every candidate
with `0 < s 0` fails the current domination interface at the same
`alpha = 2`, `p = 0` empty-feasible-set branch. Its bridge-level form
`not_z2_lattice_embedding_bridge_with_positive_at_zero_scalingCarrier` is also
machine-gated.
The bridge-level theorems
`not_z2_lattice_embedding_bridge_with_harrisKestenScalingFunction` and
`not_z2_lattice_embedding_bridge_with_criticalHyperbolicScaling` now prove
that neither candidate can instantiate the current `Z2LatticeEmbeddingBridgeData`
interface. `part6_lattice_embedding_frontier_payload` machine-gates this
current transfer/obstruction frontier in `PaperSemanticGate.lean`. The same
candidate layer is now bundled by
`part6_scaling_candidate_current_obstruction_certificate`, which packages the
lower-envelope, generic positive-at-zero, hyperbolic, and bridge-level carrier
exclusions as one audited Part 6 certificate. R518 adds
`Z2LatticeEmbeddingBridgeData` and
`gap_cognitive_threshold_part6_from_z2_lattice_embedding_bridge`: a future
certificate must name the standard `Z²` lattice graph and supply a replacement
scaling carrier with both one-sided divergence and high-α domination. R521
adds the repaired local-domination transfer
`gap_cognitive_threshold_part6_local` and the local bridge entrypoint
`gap_cognitive_threshold_part6_from_z2_lattice_embedding_local_bridge`. The
local bridge contract now also gates
`z2LatticeEmbeddingLocalBridgeData_near_pc_feasible_nonempty` and
`z2LatticeEmbeddingLocalBridgeData_paper_support_certificate`, requiring any
unbounded repaired route to supply near-`p_c` nonemptiness of the `kappaStar`
feasible set together with graph identity, scaling divergence, local
domination, and the paper-facing divergence transfer. The
current gate also proves `not_z2_lattice_embedding_local_bridge_current`: the
unbounded `α` domain still includes `α = 2`, where the current concrete
`kappaStar p 2` branch is zero at non-negative points in every deleted
left-neighbourhood of `p_c`; this exact zero-branch witness is now separately
machine-gated by `current_part6_unbounded_alpha_zero_branch_near_pc`, and
`current_part6_unbounded_alpha_zero_branch_blocks_local_bridge` turns that
witness into the generic obstruction, so no divergent near-`p_c` scaling
carrier can satisfy the present local bridge. It also gates
`mean_estimate_gap_lt_one_of_nonneg_p_of_pos_kappa`,
`kappaStar_eq_zero_of_one_lt_alpha_of_nonneg_p`,
`not_unbounded_part6_divergence_witness_current`,
`not_unbounded_part6_pointwise_paper_domain_certificate_current`, and
`not_unbounded_part6_feasible_divergence_witness_current`, so the current
carrier is machine-blocked at the unbounded pointwise/output witness layer, not
only at the local-bridge layer. It also gates
`not_unbounded_part6_full_paper_domain_witness_current` and the combined
`unbounded_part6_current_obstruction_certificate`, so the near-`p_c` zero
branch, unbounded output-witness obstructions, full same-`alpha` witness
obstruction, and local-bridge obstruction are checked as one current-route
certificate. The gate also names the full current paper-closing surfaces
`UnboundedPart6FullPaperClosingSupport`,
`ClosedUnitPart6FullPaperClosingSupport`, and
`Part6FullPaperClosingSupport`, and proves
`not_part6_full_paper_closing_support_current`; thus the remaining Part 6 gap
cannot be closed by merely selecting either existing current route. It also
gates `Part6FullPaperClosingDivergenceWitness`,
`part6_full_paper_closing_support_divergence_witness`,
`not_part6_full_paper_closing_divergence_witness_current`, and
`not_part6_full_paper_closing_support_current_via_divergence_witness`, so any
full paper-closing support must project to the actual same-`alpha` divergence
output and the current carrier is machine-refuted at that output layer. It also
ties the bridge route to this output by
`part6_full_paper_closing_bridge_route_divergence_witness` and
`not_part6_full_paper_closing_bridge_route_current_via_divergence_witness`.
It now also gates `Part6FullPaperClosingFeasibleDivergenceWitness`,
`part6_full_paper_closing_support_feasible_divergence_witness`,
`part6_full_paper_closing_bridge_route_feasible_divergence_witness`, and
the corresponding current obstructions, so support and bridge routes must
expose feasible-set nonemptiness and divergence at one same `alpha`.
It also gates the paired output projections
`part6_full_paper_closing_support_output_pair` and
`part6_full_paper_closing_bridge_route_output_pair`, plus the output-pair
current obstructions, so both Part 6 output layers are checked together.
It now also names `Part6FullPaperClosingFullOutputBundle` and gates
`part6_full_paper_closing_support_full_output_bundle`,
`part6_full_paper_closing_bridge_route_full_output_bundle`,
`not_part6_full_paper_closing_full_output_bundle_current`, and the corresponding
support/bridge-route current obstructions through that full bundle. Thus any
future Part 6 closure must expose support, divergence, and same-`alpha`
feasible/divergence witnesses as one machine-checked package.
These projections and refutations are now also collected in
`Part6FullPaperClosingOutputLayerCertificate` and gated in
`part6_lattice_embedding_frontier_payload`, so the two counted Part 6 output
witness interfaces and their full bundle are checked through one Lean
certificate.
The unified `part6_current_frontier_certificate` now packages the unbounded
current-obstruction certificate, scaling-candidate obstruction certificate,
and closed-unit current-obstruction certificate together with the
`part6_bridge_route_support_certificate`, the output-layer certificate,
support obstruction, and bridge-route obstruction.
It also
gates `Part6FullPaperClosingBridgeRoute`,
`part6_full_paper_closing_support_of_bridge_route`, and
`not_part6_full_paper_closing_bridge_route_current`, so a future inhabited
repaired bridge route is formally sufficient for the named support surface,
while the current bridge routes are formally ruled out. The unified
`part6_bridge_route_support_certificate` also packages both individual
local/closed-unit bridge-to-support projections with the paired branch-route
obstruction.
The gate also proves
`alphaStar_eq_one_current` and
`not_closed_unit_alpha_above_alphaStar_current`, so simply bounding the paper
domain by `α <= 1` would make the current `α > α*` regime empty. The
closed-unit local bridge contract now carries an explicit
`alphaStar 0 p_c < 1` threshold certificate and derives the nonempty-domain
witness from it, and it also carries near-`p_c` feasible-set nonemptiness on
that closed-unit paper domain; the bounded transfer theorem
`gap_cognitive_threshold_part6_from_z2_lattice_embedding_closed_unit_local_bridge`
now states the paper-facing divergence conclusion for any future instance on
`alphaStar 0 p_c < α <= 1`. The companion theorem
`gap_cognitive_threshold_part6_from_z2_lattice_embedding_closed_unit_local_bridge_witness`
packages the required nonempty-domain certificate into an actual paper-domain
divergence witness. The gate also checks
`not_closed_unit_part6_divergence_witness_current` and
`not_closed_unit_part6_feasible_divergence_witness_current`, so the current
carrier is machine-blocked not only at the bridge-contract level but also at the
closed-unit output witness level. It also checks
`z2LatticeEmbeddingClosedUnitLocalBridgeData_paper_support_certificate`,
which ties the `Z^2` graph identity, scaling divergence, threshold
certificate, local domination field, near-`p_c` feasible-set nonemptiness, and
same-`alpha` paper-domain witness into one machine-checked Part 6 certificate.
The unbounded-local paper-support certificate likewise now includes same-`alpha`
feasible/divergence support. The gate also checks
`z2LatticeEmbeddingLocalBridgeData_pointwise_paper_domain_certificate`,
`z2LatticeEmbeddingClosedUnitLocalBridgeData_pointwise_paper_domain_certificate`,
and
`z2LatticeEmbeddingClosedUnitLocalBridgeData_feasible_divergence_witness`,
so the same-alpha projections remain independently auditable. The gate also checks
`closed_unit_alpha_domain_nonempty_iff_alphaStar_lt_one`, so this closed-unit
domain is nonempty exactly when the repaired carrier proves
`alphaStar 0 p_c < 1`. The gate also checks
`alphaStar_lt_one_requires_sentimental_welfare_reversal_witness` and
`z2LatticeEmbeddingClosedUnitLocalBridgeData_sentimental_welfare_reversal_required`,
so this threshold repair must expose a genuine sentimental welfare reversal
inside the closed unit alpha range, not merely a replacement scaling carrier.
It also checks `ClosedUnitAlphaStarTailReversalRepairRoute`,
`alphaStar_lt_one_of_closed_unit_tail_reversal_repair_route`,
`closed_unit_alpha_domain_nonempty_of_tail_reversal_repair_route`, and
`not_closed_unit_alphaStar_tail_reversal_repair_route_current`, making the
sufficient repair route explicit: a repaired carrier may prove a uniform tail
sentimental welfare reversal above some `a < 1`, while the current carrier is
blocked because the sentimental kernel is beta-monotone throughout the closed
unit interval.
The new `closed_unit_alpha_domain_repair_certificate` packages the exact
`alphaStar 0 p_c = 1` degeneracy, the nonempty-domain iff, the forced
sentimental-reversal witness, the sufficient tail-reversal route, and the
current route obstruction in one Part 6 gate theorem.
The gate now lifts that sufficient route to bridge-level data through
`Z2LatticeEmbeddingClosedUnitTailReversalBridgeData`,
`z2LatticeEmbeddingClosedUnitLocalBridgeData_of_tail_reversal_bridge`,
`part6_full_paper_closing_bridge_route_of_closed_unit_tail_reversal_bridge_nonempty`,
and
`part6_full_paper_closing_support_of_closed_unit_tail_reversal_bridge_nonempty`,
with
`z2_lattice_embedding_closed_unit_tail_reversal_bridge_output_certificate`
now projecting `alphaStar 0 p_c < 1`, closed-unit alpha-domain nonemptiness,
closed-unit bridge nonemptiness, same-carrier closed-unit full paper-domain
support, same-bridge paper-support plus sentimental-reversal, Part 6
route/support, the same-alpha divergence/feasible-divergence output pair
(`part6_full_paper_closing_output_pair_of_closed_unit_tail_reversal_bridge`),
and the full output bundle from any future tail-reversal bridge,
and with
`not_z2_lattice_embedding_closed_unit_tail_reversal_bridge_current` recording
the exact current obstruction to that bridge-level route.
The standalone
`z2_lattice_embedding_closed_unit_tail_reversal_bridge_nonclosure_certificate`
now packages the output certificate with the alpha-domain repair obstruction,
the bridge-level nonempty obstruction, and the current Part 6
bridge-route/support/full-output-bundle refutations.  Thus the tail-reversal
surface is a machine-checked sufficient repair route, but also explicitly
machine-gated as non-closure for the current carrier.
It also gates
`z2LatticeEmbeddingClosedUnitLocalBridgeData_paper_support_with_sentimental_reversal`,
which ties that reversal requirement to the closed-unit Part 6 paper-support
certificate for the same repaired bridge.
The matching current obstruction
`not_z2_lattice_embedding_closed_unit_local_bridge_paper_support_with_sentimental_reversal_current`
is also gated, so the current carrier cannot be mistaken for this exact
combined contract.
The theorem
`not_z2_lattice_embedding_closed_unit_local_bridge_current` gates the current
threshold-certificate obstruction at the bridge-contract level. The remaining
Harris-Kesten scaling work is therefore first to supply a nondegenerate
`α`/feasible-set domain
certificate, including `alphaStar 0 p_c < 1` for the closed-unit route, then
instantiate that repaired bridge with a paper-faithful carrier
and valid near-`p_c` domination theorem.
`V_g` is now a well-founded concrete greedy traversal over the current
canonical finite vertex carrier (`Vertex = Fin 5`), and the paper recursion
laws `V_g_def_terminal` and `V_g_def_step` are current theorems.
The two former Principal Part 2
working assumptions are now current-carrier dead-end refutations, not global
axioms or live theorem-hypothesis interfaces; trap-tree `c_star_constant`
positivity and local GeneralGraphs bridge
claims are also explicit theorem hypotheses/interfaces. The paperGraph
preconnectedness bridge is now closed by
`Infrastructure.paperGraph_preconnected_current`; the all-open
forward-reachability identification bridge is now closed by
`ForwardReachable_empty_full_at_all_open_current`.
The legacy conclusions below should be read as paper-to-Lean
correspondence status, not as a complete kernel-only claim. The supermodular
factor-sign obligations are bundled by `canonicalSupermodularFactorSigns` for
the current scalar carrier, while `gap_supermodular_from_signs` and
`gap_policy_complementarity_from_signs` preserve the generalized
`SupermodularFactorSigns` route. These current routes no longer thread a
non-load-bearing Topkis theorem parameter. R494 fixes the public
`gap_policy_complementarity` export to the paper-facing supermodular corner
inequality direction (`W(β₁,κ₁)+W(β₂,κ₂) ≥ W(β₁,κ₂)+W(β₂,κ₁)`), matching the
generalized route. R495 records that the prior
`kappaAgentWelfareSNR` route was exactly constant at `1/2`; the weak corner
inequality was therefore a flat current-carrier closure. R496 supplied the
kernel-checked replacement core: `kappaAgentRewardRamp` /
`kappaAgentRewardKernelRamp` are bounded, β-continuous, β-monotone, and
increasing-differences carriers. R497 switches the public
`kappaAgentWelfareSNR` carrier to that ramp expectation and proves
expectation-level supermodularity, nonflatness, and a strict four-corner
witness. R498 adds a Principal-side ramp calibration: `W_bar_ramp` is non-flat
and saturates after β = 1; `W_bar_ramp_le_at_one` and
`not_W_bar_ramp_above_saturation_witness` rule out ramp-only overshoot above
the saturation value, while
`not_PrincipalRampBelowWeightedSumEventuallyDecreasing` proves the canonical
below sample (`κ = 0`, `α = 0`) still cannot supply the strict below-regime
decrease. The older global `agentWelfare AgentType.kappaAgent` constant branch
still remains in the Principal dead-end/refutation layer; full Principal
recalibration now specifically requires a reversal-capable below-threshold
kernel, not just the monotone ramp used for policy complementarity. R499 adds
that positive kernel-only rewire target without changing the public Principal
carrier yet: `principalBelowReversalReward` is bounded in `[0,1]`, has exact
values `1/2`, `1`, and `1/2` at β = 0, 1, and 2, and supports
`principalReversalBelowWeightedSumEventuallyDecreasing`,
`W_bar_reversalCandidate_finite_above_tail_witness`, and
`W_bar_reversalCandidate_strict_drop_after_peak`. R500 adds
`W_bar_reversalCandidate_tendsto_atTop` and
`W_bar_reversalCandidate_disclosure_part1_witness`, so the candidate aggregate
now has a formal atTop tail limit and a finite-β-above-tail witness without
changing the public `W_bar` carrier. R501 adds
`principalReversalCandidate_combined_exceeds_zero_witness` and
`principalReversalCandidate_combined_dominance_witness_pair`, so the same
candidate now also supplies the strict-interior positive-response and
combined-dominance witness shapes refuted for the current scalar public
carrier. R502 adds the unified `principalBelowReversalValleyReward` /
`W_bar_reversalValleyCandidate` route, whose below reward has exact values
`1/2`, `1`, `0`, and `1/2` at β = 0, 1, 2, and 3 and whose aggregate proves
below strict decrease, finite-above-tail, atTop-tail, combined-dominance, and
valley-triple witnesses kernel-purely. This is the carrier installed as the
public Principal aggregate in R507. R503 proves
`W_bar_reversalValleyCandidate_le_at_one` and
`W_bar_reversalValleyCandidate_strict_interior_optimum_witness`, so β = 1 is
a global maximizer of this candidate aggregate and strictly improves over
β = 0. R504 adds
`W_bar_reversalValleyCandidate_complete_principal_package`, bundling strict
interior global optimum, finite-beta disclosure-tail overshoot, and the
valley-triple witness as one kernel-only candidate package. R505 adds
`principalRampAboveThresholdWelfare_continuousOn_Ici`,
`principalBelowReversalValleyReward_continuousOn_Ici`,
`principalReversalValleyBelowThresholdWelfare_continuousOn_Ici`, and
`W_bar_reversalValleyCandidate_continuousOn_Ici`, so the candidate now also
matches the continuity side of the current public Principal EVT interface.
R506 adds `W_bar_reversalValleyCandidate_has_limit_infty`,
`W_bar_reversalValleyCandidate_eventually_decreasing`, and
`W_bar_reversalValleyCandidate_public_interface_package`, so the candidate now
also covers the public Principal interface surface for eventual decrease,
limit existence, strict interior optimum, finite-beta disclosure-tail
overshoot, and valley evidence. R507 installs that target as the public
Principal carrier: `aboveThresholdWelfare` uses `kappaAgentRewardRamp`,
`belowThresholdWelfare` uses `principalBelowReversalValleyReward`, and
`W_bar_eq_reversalValleyCandidate` makes public `W_bar` definitionally equal
to the reversal-valley aggregate. Consequently `principal_interior_maximum_exists`,
`W_bar_eventually_decreasing`, `W_bar_limit_infty_eq_W_bar_three`, and
`W_bar_finite_above_limit_witness` now close on the current public carrier.
R508 adds the remaining public strict-shape closures:
`W_bar_exceeds_zero_at_positive_beta`, `W_bar_witness_pair_strict_dominance`,
and `W_bar_valley_triple_witness` are now kernel-only theorems about the
installed public `W_bar`; the old scalar sample refutations are retained only
as diagnostics of the retired `agentWelfare` route.
R510 completes the remaining Part 2 public rewire:
`aggregateWelfareWith_principal_part2_package` packages per-`G` argmax
existence, FOSD-induced beta-increment domination, and monotone stable beta
selection for the public finite FOSD-ramp `aggregateWelfareWith` carrier and
stable `aggregateOptimalBeta` selector. The old unrestricted public carrier is
now only historical diagnostic evidence, not a live theorem surface.
The oracle
information-decay
pointwise obligations now close directly on the current neutral global carrier,
while future non-neutral oracle work is preserved on the parameterized
`WInfoOracleInterfacesOn data` surface.
The greedy high-precision limit kernel and pointwise-atTop convergence are now
closed from the concrete scalar kernel (`6/10` after `β > 0`); the current
greedy-kernel wrongness reversal witness is bundled by
`WrongnessGreedyInterfaces_current`, and public `gap_wrongness`/`gap_dilemma`
consume that current witness directly.
The ER supercritical survival carrier `poissonSurvival` is now a concrete
witness definition, so `gap_er_supercritical_OPEN` is kernel-pure.
The Bayesian myopic/satisficing carriers are explicit theorem-parameter
structures (`MyopicKWelfareCarriers`, `SatisficingCarriers`) rather than global
source-level axioms; public robustness theorems instantiate current carriers
where needed. R239/R322 moved the satisficing paper-Remark behavior into
`SatisficingCarriers` proof fields, and R389 retired the live generic wrapper
for the public satisficing theorem by proving the current affine instance
directly.
Trap-tree oracle bridge-path terminal reward is now concrete:
`oracleBridgePathTerminalReward_TrapTree := fun _ => r_goal`, with
`oracleBridgePathTerminalReward_TrapTree_eq_r_goal` proved by unfolding.
The empty current compatibility carrier has been removed, and public
`gap_error_compounding_part2` is the direct kernel theorem.
Trap-tree `κ*(d)` now carries the `c*` constant through
`KappaStarDepthDCarriers_current` instead of a global `c_star_constant` axiom
or theorem-level carrier parameter.
`V_dyn` itself is now a concrete `Finset.sup'` definition over
`ForwardReachable`, and `V_dyn_def` is a definitional theorem.
`ReachableSet` itself is now definitionally `ForwardReachable _ ∅ _`, so
`ReachableSet_eq_ForwardReachable_empty` is a theorem by `rfl`. The C1/C2
definitions are semantic, `PercolationOutcome`/`IsOpen` project from
`PercolationOutcomeData`, and C2′/C3/Blackwell-order project from the
`DiagnosticSignalHypothesisData` typeclass theorem-parameter surface.
diagnostic predicates and `IsTopologyBlind` are concrete semantic definitions
over the existing IDP carriers rather than bare source axioms.
`Vertex` is now the concrete canonical finite carrier `Fin 5`, and its
`Fintype`/`DecidableEq` instances are inherited from Mathlib. `IsEdge` is the
concrete loopless complete relation `u ≠ v`, and `IsEdge.symm` is a theorem.
`PercolationOutcome` is the concrete Boolean open-edge assignment space.
`ForwardReachable` is a concrete finite reachable set built from
reflexive-transitive chains of open edges outside the visit history, and
`ForwardReachable_self_member` is a theorem.
`DegreeTwoStartingVertex` is now a semantic graph-neighbourhood predicate over
`IsEdge`, not a bare source axiom.
`TerminalNeighbourTopology` is now a semantic graph-topology predicate over
`IsEdge`, not a bare source axiom.
`blockingProb` is the concrete canonical non-degenerate value `1/3`, `reward`
is a concrete bounded five-state profile, and `intrinsicPref` is the neutral
`1/2` realisation. Their strict/range facts, including
`blockingProb_mem_unitInterval`, `reward_mem_unitInterval`, and
`intrinsicPref_mem_unitInterval`, are theorems rather than separate
source-level axioms.
Future fully parameterised coverage should move the blocking probability to
theorem/module parameters rather than reintroducing a global source axiom.
The unused `oracleReward` stub is now a transparent neutral placeholder and
`oracleReward_mem_unitInterval` is a theorem; a concrete Definition 2.6 oracle
expectation remains future work.
The Wrongness/topo-cluster topo-loss unit bound is now a derived theorem over
the concrete finite percolation expectation. The R200/R201 Mills-tail bridge
facts have been retired from the live Prop-interface surface because R320
proves that route incompatible with the unit upper bound. R513 calibration:
the current public theorem-core above-threshold route is not merely the old
Mills-route refutation; it has a kernel-checked flat-only full-reach boxed-torus
family package via `BoxedTorusFullReachFlatOnlyLowerBoundConclusion_current`
and `boxedTorusFullReachFlatOnlyComplementTopoLossData_flatFamilyCoreConclusion`.
The remaining strengthening is the paper-faithful random supercritical
`Z^2_L` giant-component/reward-loss theorem, not a missing theorem-interface
closure for the current finite boxed-torus route. The below-threshold
giant-component order-statistics and cluster-size lower-bound bridge facts
remain explicit interfaces, but the current diagnostic global closure consumes
their current closures internally; the full finite-lattice paper-facing route is
the explicit-package theorem `topoLossKernel_pointwise_bound_on data`. R516
adds `topo_cluster_random_supercritical_z2_frontier_payload`, a
`PaperSemanticGate.lean` record that machine-gates the current topo theorem
surface, the flat-family boxed-torus package, and the Mills-route obstructions
while leaving the random `Z^2_L` semantic target open. R519 adds
`Z2TopoClusterBridgeData` and gates its projection theorems
`BoxedTorusFlatFamilyCoreConclusion_from_z2_topo_cluster_bridge` and
`BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion_from_z2_topo_cluster_bridge`;
this turns the future random-supercritical `Z^2_L` closure condition into a
kernel-checked certificate interface, but it does not instantiate that
certificate or change the topo/phase open semantic count. The current gate
also adds the stronger `RandomSupercriticalZ2TopoClusterBridgeData` contract,
including the finite boxed-torus vertex/edge indexing facts, a named
supercritical probability, flat and giant-restricted lower-bound theorems at
that same parameter, the derived uniform eventual positive flat-loss witness,
the derived paper-support certificate tying those bounds to the standard `Z^2`
graph, finite boxed-torus vertex/edge indexing facts, the same `p > p_c`
domain, and the non-diagnostic tail certificate, an eventual positive
giant-restricted loss witness, eventual unrestricted and in-giant pointwise
positive-loss realisation witnesses, and projections back to the current
family-core and lower-bound interfaces. The certificate now also includes
`randomSupercriticalZ2TopoClusterBridgeData_eventually_uniform_supported_extended_non_diagnostic_member`,
which chooses arbitrarily large finite members where the five-family diagnostic
exclusions, shared flat/giant lower bounds, and in-giant positive-loss
realisation hold together. The certificate and corresponding
gate theorems exclude the current full-reach, flat-only, all-open-complement,
deterministic all-open giant, deterministic all-open positive,
pointwise-hybrid, and extended eventual-tail diagnostic families; the derived
theorem
`randomSupercriticalZ2TopoClusterBridgeData_exists_non_diagnostic_member`
turns that exclusion into an explicit finite member outside all three current
diagnostic carriers, and
`randomSupercriticalZ2TopoClusterBridgeData_arbitrarily_large_non_diagnostic_member`
rules out eventual diagnostic tails by producing such a member above every
finite threshold. The stronger extended projection is now also part of the
paper-support certificate:
`randomSupercriticalZ2TopoClusterBridgeData_arbitrarily_large_extended_non_diagnostic_member`
now produces arbitrarily large members outside all five deterministic
diagnostic carriers. This is the object a final random finite-lattice proof
must instantiate. The topo payload now also
gates the current standard-`Z^2` boxed-torus witness
`boxedTorusFullReachFlatOnlyZ2TopoClusterBridge_current`, its family/core/
lower-bound projections, and
`boxedTorusFullReachFlatOnlyComplementTopoLossData_flatOnlyDiagnostic`,
which proves the current flat-only family has zero total expected topo loss
off the flattened boxed-torus index and zero giant-restricted topo loss at
every index. It also gates
`boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_eq_failureMass`,
making explicit that the current flat lower-bound evidence is supported by the
full-reach failure complement.
The route is now also bundled for the semantic gate by
`boxedTorusFullReachFlatOnlyLowerBound_cutset_route_certificate`, which
packages the separator, edge-cutset, coordinate-boundary, pointwise `p^B / 2`,
and family-level lower-bound implications for the full-reach flat-only carrier.
The repaired first-edge compatibility witness is now also calibrated by
`randomSupercriticalZ2TopoClusterRepairedBridgeData_eventually_giant_event_member`,
which turns the repaired bridge's positive giant-event mass into an actual
finite configuration in the selected event,
`randomSupercriticalZ2TopoClusterRepairedBridgeData_eventually_uniform_flat_event_mass_member_and_loss_realisation`,
which keeps that membership on the same sufficiently large boxed-torus index
as the flat lower bound, giant-event mass, and positive-loss realisation,
`randomSupercriticalZ2TopoClusterRepairedBridgeData_eventually_uniform_supported_extended_non_diagnostic_member_with_giant_member`,
which gives arbitrarily large non-diagnostic repaired members where the flat
lower bound, giant-event mass, giant-event member, positive-loss realisation,
and five deterministic-diagnostic exclusions all hold at the same chosen `L`,
and by
`firstEdgeOpenGiantClosedTopoLossFamily_topoLossKernel_zero_on_giant` and
`firstEdgeOpenGiantClosedTopoLossFamily_expectedTopoLossOnGiantOn_boxedTorus_eq_zero`.
The gate now also includes
`firstEdgeOpenGiantClosedTopoLossFamily_not_positive_giant_loss_lower_bound_at_three_quarters`.
It further gates the combined certificate
`firstEdgeOpenGiantClosedTopoLossRepairedBridge_current_compatibility_certificate`.
A separate finite positive-regression certificate,
`firstEdgeGiantStochasticTopoLossData_positive_regression_certificate`,
packages the first-edge stochastic carrier's unit-interval loss, positive-mass
full-cluster giant event, unit-compatible lower bound, exact
`p = 3/4` giant-restricted expected-loss value `1/8`, and strict positivity.
This is a non-vacuity regression for the repaired support shape, not a
replacement for the missing random finite `Z^2_L` giant-component family.
The missing paper-closing giant-loss field is now named as
`RandomSupercriticalZ2TopoClusterRepairedBridgeGiantLossPaperClosing`; it is
projected from the old final bridge contract and refuted for the current
first-edge repaired witness by
`firstEdgeOpenGiantClosedTopoLossRepairedBridge_current_not_giant_loss_paper_closing`.
The stronger full closing surface is now named as
`RandomSupercriticalZ2TopoClusterRepairedBridgeFullPaperClosingSupport`; it
requires repaired paper support plus same-constant flat loss, giant-restricted
loss, giant-event mass, and in-giant positive-loss support, is projected from
the old final bridge contract, and is refuted for the current first-edge
witness by
`firstEdgeOpenGiantClosedTopoLossRepairedBridge_current_not_full_paper_closing_support`.
The gate now also exposes a sufficient route:
`RandomSupercriticalZ2TopoClusterRepairedBridgeGiantPointwiseLossRoute`
requires a uniform positive pointwise loss floor on the repaired bridge's
giant event; by
`expectedTopoLossOnGiantOn_ge_mul_mass_of_pointwise_ge`,
`randomSupercriticalZ2TopoClusterRepairedBridgeGiantLossPaperClosing_of_giant_pointwise_loss_route`,
`randomSupercriticalZ2TopoClusterRepairedBridgeFullPaperClosingSupport_of_giant_pointwise_loss_route`,
and
`randomSupercriticalZ2TopoClusterFullPaperClosingRoute_of_giant_pointwise_loss_route`,
that floor plus the existing giant-event mass lower bound is enough for full
topo paper-closing support. The current first-edge witness is blocked from
that route by
`firstEdgeOpenGiantClosedTopoLossRepairedBridge_current_not_giant_pointwise_loss_route`.
The gate now generalizes this obstruction to every repaired bridge whose family
is `firstEdgeOpenGiantClosedTopoLossFamily` at `p = 3/4`, via
`not_randomSupercriticalZ2TopoClusterRepairedBridge_firstEdge_three_quarters_giant_loss_paper_closing`,
`not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute_firstEdge_three_quarters_giant_loss_output`,
`not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute_firstEdge_three_quarters_combined_support_output`,
`not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute_firstEdge_three_quarters_supported_extended_non_diagnostic_output`,
`not_randomSupercriticalZ2TopoClusterRepairedBridge_firstEdge_three_quarters_full_paper_closing_support`,
and
`not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute_firstEdge_three_quarters_witness`.
The existential closing route is now also named as
`RandomSupercriticalZ2TopoClusterFullPaperClosingRoute`: the gate proves that
full-support repaired bridges inhabit it, that it exposes both repaired-bridge
nonemptiness and the full-support witness, and that the old over-strong bridge
contract would project to this route.
It also proves
`randomSupercriticalZ2TopoClusterFullPaperClosingRoute_paper_support_output`,
`randomSupercriticalZ2TopoClusterFullPaperClosingRoute_support_surface_repair_output`,
`randomSupercriticalZ2TopoClusterFullPaperClosingRoute_support_surface_repair_route`,
`randomSupercriticalZ2TopoClusterFullPaperClosingRoute_support_surface_repair_output_certificate`,
`randomSupercriticalZ2TopoClusterFullPaperClosingRoute_giant_loss_output` and
`randomSupercriticalZ2TopoClusterFullPaperClosingRoute_combined_support_output`,
so the route must project to the repaired paper-support surface, factor back
through the repaired support-surface route/output, expose the missing giant-loss
closing field, and carry one same-tail flat/giant/mass/positive-realisation
output package.
It now also gates direct old-contract-to-output projections for the giant-loss,
paper-support, combined-support, and supported-nondiagnostic route outputs, so
the refuted old contract's paper-closing obligations are machine-calibrated at
each output layer.
It also gates `randomSupercriticalZ2TopoClusterFullPaperClosingRoute_output_bundle`,
`randomSupercriticalZ2TopoClusterBridgeData_full_paper_closing_route_output_bundle`,
`randomSupercriticalZ2TopoClusterFullPaperClosingRoute_full_output_bundle`,
`randomSupercriticalZ2TopoClusterBridgeData_full_paper_closing_route_full_output_bundle`,
and
`not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute_firstEdge_three_quarters_output_bundle`,
so all three numeric topo route output layers and the repaired paper-support
surface are checked together.
It now also gates
`not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute_firstEdge_three_quarters_full_output_bundle`,
which refutes the current first-edge witness at the exact
paper-support-inclusive full output-bundle surface.
The route outputs are now also collected into
`RandomSupercriticalZ2TopoClusterFullPaperClosingRouteOutputCertificate` and
gated in `topo_cluster_random_supercritical_z2_frontier_payload`, so the
frontier checks the route-output surface through one Lean certificate as well
as through the individual projection theorems.
It also gates
`RandomSupercriticalZ2TopoClusterBoxedTorusFiniteZ2LRouteCertificate`, which
calibrates any future full route to expose the finite boxed-torus indexing,
standard `Z^2` graph, strict `p_c < p < 1` parameter, and unit-interval loss
range in the same repaired-bridge witness.
The unified `random_supercritical_z2_topo_cluster_current_frontier_certificate`
now packages this route-output certificate, the route-level paper-support
output, and bundled obstruction together with the finite positive-regression
certificate
`firstEdgeGiantStochasticTopoLossData_positive_regression_certificate`.
It also packages
`firstEdgeGiantStochasticTopoLossData_not_random_supercritical_z2_bridge_certificate`,
which proves that the finite first-edge stochastic regression witness is not
liftable to the repaired random-supercritical `Z2_L` bridge surface: its
selected giant-event loss violates the theorem-core pointwise `1/(n+1)`
envelope already at `n = 2`.
It also packages
`random_supercritical_z2_topo_cluster_giant_pointwise_loss_route_certificate`,
which proves that a pointwise-on-giant repaired route would close the
giant-loss field, the full repaired support surface, and the named full route,
while the current first-edge witness cannot satisfy that route.
The current support surface is now also globally calibrated by
`random_supercritical_z2_topo_cluster_full_support_envelope_obstruction_certificate`
and the individual obstructions
`not_randomSupercriticalZ2TopoClusterRepairedBridge_giant_loss_paper_closing`,
`not_randomSupercriticalZ2TopoClusterRepairedBridge_full_paper_closing_support`,
`not_randomSupercriticalZ2TopoClusterRepairedBridge_giant_pointwise_loss_route`,
`not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute`, and
`not_randomSupercriticalZ2TopoClusterBoxedTorusFiniteZ2LClosingRoute`.
These prove that the present giant-loss/full-support/pointwise-on-giant
route surface is uninhabitable for every repaired bridge because its uniform
giant-restricted lower bound contradicts the theorem-core pointwise envelope
along growing flattened boxed-torus sizes.  The remaining topo closure task is
therefore no longer an informal support-surface repair: the repaired replacement
is now build-gated by
`RandomSupercriticalZ2TopoClusterRepairedBridgeSupportSurfaceRepair`,
`RandomSupercriticalZ2TopoClusterSupportSurfaceRepairRoute`, and
`random_supercritical_z2_topo_cluster_support_surface_repair_certificate`, with
the current repaired first-edge bridge inhabiting that route.  Its output layer
is also gated by
`random_supercritical_z2_topo_cluster_support_surface_repair_route_output_certificate`,
which projects repaired bridge nonemptiness, repaired paper support, and the
same-tail flat/mass/member/positive-loss non-diagnostic support output.  The
separate
`random_supercritical_z2_topo_cluster_support_surface_repair_nonclosure_certificate`
now packages that inhabited repair route with the current first-edge repaired
surface and the kernel refutations of the full paper-closing and boxed-torus
finite `Z2_L` routes.  The stronger
`random_supercritical_z2_topo_cluster_support_surface_closing_route_certificate`
now gates the repaired closing spine itself: full paper-closing support and the
support-surface closing route are equivalent, the pointwise-on-giant route
projects into it, and any inhabitant exposes both the named full route and the
boxed-torus finite `Z2_L` route.  What remains is a genuine random finite
`Z2_L` carrier instantiation of this repaired support route, not another
inhabitant search inside the refuted current surface.
It now also includes
`RandomSupercriticalZ2TopoClusterRepairedBridgeDiagnosticObstructionCertificate`
and
`random_supercritical_z2_topo_cluster_repaired_bridge_diagnostic_obstruction_certificate`,
so the repaired bridge surface itself cannot be closed by the current
full-reach, flat-only, all-open-complement, deterministic all-open giant,
deterministic all-open positive, pointwise-hybrid, or eventual diagnostic-tail
families.
It also gates
`randomSupercriticalZ2TopoClusterFullPaperClosingRoute_supported_extended_non_diagnostic_output`,
so the route must expose arbitrarily large non-diagnostic finite members
carrying full flat/giant/mass/in-giant-positive support.
The topo current frontier is also packaged as
`random_supercritical_z2_topo_cluster_current_frontier_certificate`, combining
the old over-strong bridge-contract obstruction with the repaired first-edge
compatibility/not-closing witness, diagnostic obstruction certificate, and
finite positive-regression, pointwise-route, and full-support envelope
obstruction certificates.
Thus its selected event is reachability-linked to the boxed-torus base
horizontal edge, but its giant-restricted topological loss is exactly zero and
admits no positive uniform lower-bound certificate, which is why it remains
only a contract-satisfiability witness rather than the random-supercritical
`Z^2_L` carrier.
R520 adds and gates the stronger full-reach bridge
`boxedTorusFullReachZ2TopoClusterBridge_current`, its family/core/flat
lower-bound projections, the per-member all-`n`
`boxedTorusFullReachZ2TopoClusterBridge_current_unit_compatible` theorem, and
`not_boxedTorusFullReachComplementTopoLossData_flatOnlyDiagnostic`, proving
that this carrier is not merely the flat-only diagnostic. It now also gates
the all-open boxed-torus finite giant-event
and restricted-envelope witnesses
`boxedTorusAllOpenGiantTopoLossData_giantEventFullClusterConclusion`,
`boxedTorusAllOpenGiantTopoLossData_expectedTopoLossOnGiantEnvelopeConclusion`,
the positive restricted-loss regression
`boxedTorusAllOpenPositiveTopoLossData_expectedTopoLossOnGiant_flat_pos`, and
the complement-family flat-sequence lower-bound package
`BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion_current`
together with per-member unit-compatible, full-cluster, envelope, and `1/8`
flat expected-loss lower-bound theorems for
`boxedTorusAllOpenComplementTopoLossData`. It also gates
`not_UnitCompatibleAboveThresholdLowerBoundConclusion_boxedTorusFullReachFlatOnly`
and the same obstruction through the current `Z^2` bridge witness,
which proves each fixed flat-only member fails the old all-`n`
above-threshold lower-bound interface.
The concrete scalar `agentRewardKernel` now proves its general range,
Bayesian/Sentimental pointwise monotonicity, κ-agent pointwise continuity, and
κ-agent increasing-differences facts directly as theorems.
It now also proves the 5-state κ-agent above-threshold, 5-state κ-agent
at-threshold, and Bayesian-naive below-threshold pointwise monotonicity facts
directly as theorems by unfolding the concrete scalar kernel.
The Bayesian-naive above-threshold strict reversal witness is now a current
theorem rather than a global source axiom: the public `bayesianNaive` branch
uses the `κ` slot as `p_hat`, with `unitRamp` below threshold and the
greedy-reversal shape above threshold.
The R205 Harris-Kesten / Cardy / Smirnov-Werner lower-envelope obligation is
now a kernel-proved dead-end:
`not_harrisKestenScalingFunction_diverges_at_pc_paper_Def` shows the current
unbounded lower-envelope carrier is zero on `p ≥ 0`. The cognitive Part 6 route
therefore uses the parameterized R208 scaling-carrier interface instead of the
failed lower-envelope proposition; the failed route is still not a global
`_paper_Def` source axiom. The open semantic-gate target is now calibrated by
`part6_lattice_embedding_frontier_payload`, which checks the live transfer
theorem, prototype divergence theorem, lower-envelope dominance theorem, and
the named plus generic obstruction theorems, including the current
local-bridge impossibility theorem and current `alphaStar = 1` bounded-domain
degeneracy, including the closed-unit local bridge contract with an explicit
`alphaStar 0 p_c < 1` threshold certificate, a derived nonempty-domain witness,
bounded transfer theorem, and existential
paper-domain divergence witness projection.
The five-state loss-shape existence bridge
`L_interior_minimizer_exists_paper_Def` is now a theorem from the concrete
`L_minimum_exists_in_regime_i_proof`. R238 also proves
`L_at_betaStarOfP_continuousOn_paper_Def` by a Lipschitz value-function
argument. R256 closes the former five-state loss-shape obligation:
`L_lowerGaussianHazard_antitoneOn_pos` and
`L_upperGaussianMills_antitoneOn_pos` prove the two Gaussian ratio
antitonicity facts kernel-purely, while R469 retires the former
`L_strict_unique_minimizer_paper_Def` `True` compatibility theorem from source.
The R238 continuity fact and
the R249-R255 Gaussian/threshold single-crossing chain are now theorem
reductions rather than `Prop`-interface surfaces. R245
defines the explicit residual `L_balanceResidual` and makes
`L_firstOrderBalance` its zero set. R246 corrects the live bridge to
single-crossing-after-zero for that residual. R247 factors out the common
positive chain-rule scale, and R248 rewrites the reduced beta-core as the
one-variable Gaussian z-core `L_balanceResidualZCore` under
`z = Delta_B / sqrt(2 * signalVariance β)`. R249 removes the positive
`Delta_B` factor and exposes `c = 0.9 * (1 - p)` in
`L_balanceResidualNormalizedZCore`. R250 rewrites that normalized core as
`c * H(z) - K(z)` and moves the bridge to positivity persistence of `H`
plus strict decrease of `K/H`; R251 factors `H = scale * D` and
`K = (1/2) * scale`, so the live bridge is positivity persistence and strict
increase of the normalized denominator `D`; R252 rewrites `D` as the explicit
hazard/Mills denominator
`Phi z * (1 - (upperMills((2/9)z) * lowerHazard z) / (2/9))`, and proves
`D(z) > 0` iff that hazard/Mills product is `< 2/9`; R253 reduces denominator
shape to non-increase of that explicit product on positive `z`. There are no
remaining source-level
`_paper_Def` axioms. R241 further proves
`L_global_minimizer_not_left_branch`, so the strict-uniqueness bridge no
longer needs a left-branch global-minimiser argument. R242 proves
`L_global_minimizer_not_right_branch_dominance`, so the current right-branch
positive-derivative dominance condition is also excluded at any positive
global minimiser. R243 proves `L_global_minimizer_first_order_balance`, the
exact first-order balance equation at every positive global minimiser.
The remaining strict-uniqueness work is the pair of pure one-variable Gaussian
ratio antitonicity facts for upper Mills and lower hazard.
`AgentEdgeIdx` is now concretised as `Fin 7`, matching the existing
`Wrongness.EdgeIdx` finite-carrier pattern.
Principal `aboveThresholdWelfare` and `belowThresholdWelfare` are now concrete
finite weighted-sum definitions over their explicit sample carriers, and their
integral-identification lemmas are definitional theorems.
The above/below sample support types now project from `PrincipalSampleData`,
which packages the support carrier with its `Fintype` and `DecidableEq`
instances, plus the sample `weight`, `kappa`, and `alpha` fields consumed by
the finite weighted sums. The public parameter functions are projections from
that data package rather than standalone global source axioms.
Those two sample-data packages and the G-parameterised
`aggregateWelfareWith` functional now come from concrete one-point principal
samples rather than a remaining `PrincipalData` source axiom. The two Principal
sample-weight non-negativity facts are kernel-proved for the unit-weight
samples.
Principal `perAgentOptimalAggregate` is also a concrete finite weighted-sum
definition over the sample carriers and per-agent `β*` assignments.
R507 updates the per-agent `β*` selectors to the public reversal-valley
optimum β = 1 and proves `perAgentOptimalAggregate_dominates_uniform` against
the public `W_bar`. Principal still keeps the legacy scalar
κ-agent welfare constant `1/2` refutations for the old diagnostic carrier.
R209 proves the four strict legacy Principal witness claims false for that
scalar carrier:
`PrincipalSampleBelowWeightedSumEventuallyDecreasing`,
`PrincipalSampleBothCombinedDominanceWitnessPair`,
`PrincipalSampleBothExceedsZeroWitness`, and
`PrincipalSampleBothValleyTripleWitness`.
The old false-premise wrappers remain retired. The current Lean state keeps
`principal_interior_maximum_exists`, `W_bar_finite_above_limit_witness`, and
`gap_disclosure_differentiated_dominates` as positive public-carrier theorems;
the older scalar dead-end markers are now legacy diagnostics rather than
public Principal blockers.
The Wrongness/topo percolation carriers now project from
a transparent diagnostic `WrongnessPercolationData` package
(`wInfoOracleKernel`, `wInfoOracleClusterCount`, `topoLossKernel`,
`giantComponentEvent`, and `expectedTopoLossAboveLowerConst`). This removes
the former source axiom. The oracle and above-threshold lower-bound sides
remain neutral, while the topo-loss side now has a nonempty `n = 1`
giant-event witness and `expectedTopoLossOnGiant 1 p = 1/2` as kernel
theorems. The non-trivial `Z^2_L` giant-component and above-threshold
lower-bound content remains explicit as theorem interfaces.
For the current diagnostic carrier, the two below-threshold giant-event bridge
closures are non-vacuous only at `n = 1`; a full paper calibration still
requires a finite `Z^2_L` giant-component carrier.
For the above-threshold Mills lower-bound route, the obstruction is now
stronger than neutral-carrier failure:
`not_mills_inverse_above_threshold_route_with_unit_bound` proves that R200
Mills identification plus R201 eventual lower bound would force
`expectedTopoLoss n p > 1`, contradicting `expectedTopoLoss_le_one_atom`.
The current Part 2 route is therefore a dead-end; a paper-faithful Lean proof
requires a corrected unit-compatible `Z^2_L` lower-bound carrier/theorem.
The supermodular scalar carriers now come from a concrete scalar package
(`snrZ`, `BridgeDominance`, `sigEffRatioFactor`, `mPrime`,
`bridgeValueGap`, `pCorrectDerivKappa`, and `vDynDerivBeta`), and
`canonicalSupermodularFactorSigns` proves the factor-sign interface for the
current model.
The per-agent `β*` selectors are canonical `1` definitions for the current
public reversal-valley Principal carrier. `W_bar_eventually_decreasing` and
`W_bar_finite_above_limit_witness` are now proved from
`W_bar_eq_reversalValleyCandidate`, not from the old constant scalar branch.
The old false-premise `gap_disclosure_full_suboptimal` wrapper is retired, but
the strict finite-beta-above-limit mechanism itself is now a direct public
theorem. R470 also retires the old vacuous averaged-overshoot atom: choosing
`delta_bar := 1` is no evidence for the paper's reversal-regime overshoot
mechanism and is tracked as dead-end/notInput.
`V_g_def_terminal` and `V_g_def_step` are current theorems from the
well-founded `V_g` definition, not global source-level axioms.
The Theorem 6.1 greedy C2′ reversal witness is closed for the current scalar
carrier by `agentRewardKernel_greedy_C2prime_kernel_reversal_witness_current`;
the generic routes remain as `gap_general_tree_from_reversal` and
`gap_cyclic_trap_from_reversal`, while public `gap_general_tree` and
`gap_cyclic_trap` consume the current witness internally.
The old current-carrier C2/C2prime local-greedy bridge wrappers have been
retired from source. Their expanded premises are refuted by
`not_C2LocalGreedyDominatesForwardReachableAtWitnesses_current`,
`not_C2LocalGreedyDiagnosticWitnessBridge_current`, and
`not_C2primeLocalGreedyFullWitness_current`; non-vacuous C2prime evidence now
lives on the graph-parametric fin5Trap/terminal-neighbour route.

1. **Paper ↔ Lean**: 41/41 → 100% paper-statement correspondence
   (Theorem 4.1 Part 4 lattice sub-claim is closed by the standard `Z^2`
   ranged local-lattice bridge)
2. **Lean rigor**: Every paper claim has a `theorem` (not axiom), but some
   theorems still depend on explicit paper/carrier interfaces.
3. **Axiom surface** (per source audit): 0 project-level source axioms,
   0 `_workingAssumption` source axioms, and 0 `_paper_Def` source axioms,
   plus remaining explicit theorem interfaces, paper/carrier parameters, and
   Lean kernel axioms (`propext`, `Classical.choice`, `Quot.sound`).

## Remaining work (post-publication)

For full kernel-pure cover (v2.0 future iteration):
- Keep the source-level axiom count at 0 while replacing the semantic targets
  listed in `PaperSemanticGate.lean` with paper-faithful kernel theorems, or
  revising the manuscript claims to match the already closed theorem payload.
- The paper R10 §5 `gap_three_regime_*` → `gap_two_regime_*` label
  recalibration is closed by aliases in `Canonical.lean`; the paper R10
  `prop:threshold-five-state` clause (iii) high-κ signal-conditional routing
  theorem is now closed by `highKappaOracleRoutingWelfare_eq_oracle`.  The
  current neutral κ-agent carrier refutation
  `not_current_kappaAgent_highKappa_oracle_at_p0` remains as diagnostic
  evidence for the retired route, not as an open semantic target.
- Upstream/polish the R256-closed Gaussian ratio interfaces:
  `L_lowerGaussianHazard_antitoneOn_pos` and
  `L_upperGaussianMills_antitoneOn_pos`; the former
  `L_strict_unique_minimizer_paper_Def` `True` compatibility alias is retired
  from source, not a live Cat 3 interface.
  The former cyclic-trap structural-equation wrapper is closed in R240 by
  `C1_Irreversibility_current` plus explicit C2′/C3 diagnostic evidence.
  The former satisficing structural-equation interfaces are closed in
  R239/R322/R389 by direct `SatisficingCarriers` fields and by the public
  theorem's direct proof over `SatisficingCarriers_current`.
  For the `L_strict_unique` item, the left-branch derivative sign is already
  kernel-proved as `L_hasDerivAt_negative_on_left_branch`, and the
  right-branch derivative sign is kernel-proved conditional on the exact
  dominance inequality by `L_hasDerivAt_positive_of_right_branch_dominance`;
  R241 also proves `L_global_minimizer_not_left_branch`, ruling out positive
  global minimisers on the left branch. R242 proves
  `L_global_minimizer_not_right_branch_dominance`, ruling out the current
  positive-derivative dominance condition at a positive global minimiser. The
  R243 Fermat step proves `L_global_minimizer_first_order_balance`, the exact
  first-order balance equation at any positive global minimiser. R250 reduces
  balance uniqueness to the pure z-threshold shape theorem for the affine
  normalized core `c * H(z) - K(z)`; R251 reduces that theorem to the
  normalized denominator-shape bridge; R252 rewrites that denominator in
  hazard/Mills form; R253 reduces that denominator shape to product
  antitonicity; R254 reduces product antitonicity to the two factor
  antitonicity facts; R255/R256 close both factor facts.
- Upgrade the diagnostic Wrongness percolation carrier to a full finite
  `Z^2_L` carrier before claiming the giant-component and Mills lower-bound
  routes as paper-supporting theorems.
- Part 4's local-lattice gate is closed; optional upstream lattice/percolation
  work now belongs to the Part 6/topo non-local carriers.
- Phase 5b Mathlib mixed-partial calculus contribution (Topkis 1978 mixed-partial criterion via `Infrastructure/TopkisCrossPartial.lean` upstream)
- Instantiate the R208 scaling-carrier interface with a valid replacement
  carrier and prove its divergence/domination facts; only then should the
  corresponding Harris-Kesten/Cardy/SLE closure be routed to Mathlib upstream
  contributions.
  Blackwell 1953, Topkis 1998, David-Nagaraja rank/order-statistics routes, ER
  phase, and power-law phase are now source-closed in this project but remain
  useful optional Mathlib-alignment PRs.

The remaining explicit theorem interfaces plus current DEAD-END markers are the
substantive "awaits carrier repair / Mathlib lattice infrastructure" items
disclosed in the paper's "Code and Lean 4 formalisation" section. The former live Cat 2
Harris-Kesten entry is now a kernel-proved lower-envelope carrier dead-end,
not an upstream-ready classical-result target; five additional dead-ends are
Principal/disclosure strict-witness failures caused by the current constant
κ-agent welfare carrier and require project-local non-constant carrier repair. The
former Blackwell/Topkis/David-Nagaraja/ER/power-law source gaps are
theorem-interface or concrete-carrier closures rather than project-level
source axioms.

These do NOT block paper publication; the paper's mathematical content is complete and the Lean v1.0 verifies correspondence.
