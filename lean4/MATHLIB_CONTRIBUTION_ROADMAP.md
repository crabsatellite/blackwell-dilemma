# Mathlib Contribution Roadmap — BlackwellDilemma → paper-semantic closure

**Date opened**: 2026-05-16 (R152)
**Strategic goal**: keep the checked theorem surface Cat 1 / kernel-clean while
closing the remaining paper-semantic targets tracked by
`BlackwellDilemma/PaperSemanticGate.lean`. Mathlib-oriented work is still the
right long-run route where the missing theorem is broadly reusable, but the
short-term public claim must follow the build-checked semantic gate rather than
the older Cat 3 ledger reduction target.

## Current state (live counts)

Current 2026-06-26 audited state (`lake build BlackwellDilemma`):

```
Total ledger entries: 498
- gapClosed:       353
- gapDefinitional: 86
- gapOpen:         0
- gapPartial:      0
- gapDeadEnd:      59
- gapBlocked:      0
Input classes:      cat1Mathlib=435 cat2External=0 cat3PaperNovel=0 mixed=0 notInput=63
Cat 3 sub-type:     carrier=0 hypothesisPredicate=0 structuralEquation=0 workingAssumption=0 conditionalHypothesis=0 phenomenologicalConjecture=0 derivedTheorem=329 notCat3=169
Source axioms:      total=0 OPEN=0 paper_Def=0 workingAssumption=0 paper_witness=0
Proof escapes:      sorry=0 admit=0 unsafe=0 native_decide=0
Conditional audit:  prop_interfaces=2 closed_true_prop_interfaces=0
                    conditional_theorem_signatures=0
                    current_refuted_interfaces=2 current_closed_interfaces=0
                    unresolved_interfaces=0
                    unresolved_prop_def_interfaces=0
                    unresolved_structure_interfaces=0
                    unresolved_class_interfaces=0
                    conditional_signatures_using_unresolved_interfaces=0
                    conditional_signatures_using_unresolved_prop_def_interfaces=0
                    conditional_signatures_using_unresolved_structure_interfaces=0
                    conditional_signatures_using_unresolved_class_interfaces=0
Paper semantic gate: closed=3 open=2
```

The source-level axiom surface and live Cat 3 input surface are now zero, but
complete paper-semantic kernel-only closure is stricter than this live theorem
surface. `PaperSemanticGate.lean` currently lists two open semantic targets:
Theorem 4.1 Part 6 lattice embedding and the random supercritical `Z2_L`
topological cluster/phase carrier. These are not hidden source axioms or proof
escapes; they are the remaining manuscript-semantics-to-kernel correspondence
work.

The current open-frontier theorem surfaces are themselves build-gated:
`part6_lattice_embedding_frontier_payload` and
`topo_cluster_random_supercritical_z2_frontier_payload` are Lean records in
`PaperSemanticGate.lean`, not README-only references. The closed Part 4 local
lattice payload is still build-gated by
`part4_lattice_p_monotonicity_frontier_payload`.

Closed Part 4 lattice payload: `part4_lattice_p_monotonicity_frontier_payload`
machine-gates the closed bounded theorem surface
(`mean_estimate_gap_antitone_in_p_paper_Def`,
`kappaStar_p_monotone_of_mean_gap_antitone`,
`gap_cognitive_threshold_part4_from_lattice_bridge`,
`gap_cognitive_threshold_part4`, and
`FiveState.gap_p_monotonicity_bounded`). R520 adds the kernel-pure
one-edge Bernoulli monotone-coupling table
`standardBernoulliMonotoneCouplingData` and the standard per-edge lattice
data package `standardLatticeMonotoneCouplingData`, and gates them in the
Part 4 payload. R521 adds the finite-edge product marginal data
`standardBernoulliProductMonotoneCouplingMarginalData`, with total mass one,
both finite-product Bernoulli marginals, non-negative mass, and zero mass on
any configuration pair containing a forbidden open-to-closed edge, and threads
it through the standard lattice data package and Part 4 payload. R522 adds
`bernoulliProductExpectation_mono_of_monotone`, proving finite-box stochastic
monotonicity for every coordinatewise monotone real-valued observable under
`0 <= p_low <= p_high <= 1`, and gates that theorem in the standard lattice
data package and Part 4 payload. The current iteration bridges that theorem
back to the paper-facing `BondConfig` / `percExpectation` carrier as
`percExpectation_mono_in_p_of_BoolConfigMonotone` and gates the bridge in the
Part 4 payload. The current one-edge semantic bridge now proves
`bridgePriorRewardObservable_expectation_eq_priorMean_u2`, identifying the
bridge-neighbour prior mean with an explicit `percExpectation (1 - p)`
observable, and
`priorMean_u2_fiveState_antitone_in_p_from_percExpectation`, deriving its
blocking-probability antitonicity from finite-product monotonicity on
`0 <= p_1 <= p_2 <= 1`. The theorem
`mean_estimate_gap_antitone_in_p_from_percExpectation` now lifts that
one-edge route through Gaussian posterior monotonicity to the full ranged
mean-estimate-gap antitonicity, and
`gap_cognitive_threshold_part4_from_percExpectation` transfers it through the
`sInf` threshold definition to bounded `kappaStar` p-monotonicity. R517 adds
`LatticePMonotonicityBridgeData`, which fixes the shape of the missing
lattice/domain certificate: it must name a standard integer-lattice graph and
carry that per-edge plus finite-product monotone-coupling/expectation interface before proving the
domain-derived antitonicity of `mean_estimate_gap` in `p`. The current
`standardZ2LatticePMonotonicityBridgeSkeleton_current` and
`gap_cognitive_threshold_part4_from_standard_z2_bridge_skeleton_current` gate a
diagnostic standard-`Z^2` bridge skeleton: it fills the graph/coupling fields
and transfers through the `sInf` theorem, but its load-bearing antitonicity
field is still the abstract/canonical theorem rather than a lattice-observable
derivation. The current ranged bridge
`standardZ2RangedLatticePMonotonicityBridge_current` and
`gap_cognitive_threshold_part4_from_standard_z2_ranged_bridge_current`
packages the same standard graph/coupling data with the explicit one-edge
`BondConfig` observable embedded as a real `Z^2` adjacent edge, its
monotonicity, and its `percExpectation (1 - p)` prior-mean equality. The Part
4 payload now gates the finite expectation monotonicity theorem routed through
the bridge's own lattice monotone-coupling field plus
`priorMean_u2_fiveState_antitone_in_p_from_ranged_lattice_observable` and
`mean_estimate_gap_antitone_in_p_from_ranged_lattice_observable`, so the
ranged mean-gap antitonicity is derived from those observable fields rather
than stored as bridge data. This closes the Part 4 semantic target at the
standard `Z^2` local-cylinder level; full non-local random lattice semantics
remain tracked by the Part 6 embedding and topo/phase targets.

Current iteration result: the high-κ five-state oracle-routing target is now
closed, not merely diagnosed. `FiveState.fiveStateOracleWelfare` formalises
the R10 value `1 - 0.4p`, and
`FiveState.highKappaOracleRoutingWelfare_eq_oracle` proves that the one-edge
signal-conditional routing carrier achieves it. The prior
`FiveState.not_current_kappaAgent_highKappa_oracle_at_p0` theorem remains as
machine diagnostic evidence that the retired neutral `kappaAgent` carrier
could not support the paper claim at `p = 0`.

The R207 theorem
`not_harrisKestenScalingFunction_diverges_at_pc_paper_Def` proves the current
unbounded lower-envelope carrier route false, so the cognitive Part 6 route now
uses the parameterized `kappaStar_diverges_at_pc_via_scaling_carrier` interface.
R467 instantiates the divergence half with the explicit hyperbolic carrier
`criticalHyperbolicScaling p := 1 / (p_c - p)` and proves
`criticalHyperbolicScaling_diverges_at_pc`. R468 proves this exact hyperbolic
carrier cannot satisfy the current unbounded high-alpha domination target:
`not_criticalHyperbolicScaling_dominates_kappaStar_current` gives the
`alpha = 2`, `p = 0` counterexample, where the carrier is positive but
`kappaStar 0 2 = 0`. The current Part 6 gate now generalizes this obstruction:
`not_positive_at_zero_scaling_dominates_kappaStar_current` proves that any
candidate scaling carrier with `0 < s 0` fails the same current domination
interface, and
`not_z2_lattice_embedding_bridge_with_positive_at_zero_scalingCarrier` lifts
that to the bridge level. The bridge-level obstructions
`not_z2_lattice_embedding_bridge_with_harrisKestenScalingFunction` and
`not_z2_lattice_embedding_bridge_with_criticalHyperbolicScaling` now prove that
neither candidate can instantiate `Z2LatticeEmbeddingBridgeData`.
The same candidate layer is now bundled by
`part6_scaling_candidate_current_obstruction_certificate`, which packages the
lower-envelope, generic positive-at-zero, hyperbolic, and bridge-level carrier
exclusions as one audited Part 6 certificate.
`part6_lattice_embedding_frontier_payload` machine-gates this
transfer/obstruction frontier, including
`current_part6_unbounded_alpha_zero_branch_near_pc`: `alpha = 2` lies in the
current unbounded domain and every deleted left-neighbourhood of `p_c`
contains a non-negative `p` with `kappaStar p 2 = 0`, plus
`current_part6_unbounded_alpha_zero_branch_blocks_local_bridge`, which turns
that witness into the generic obstruction to the current local bridge shape.
R521 adds the repaired local-domination
transfer `gap_cognitive_threshold_part6_local` and the local bridge transfer
`gap_cognitive_threshold_part6_from_z2_lattice_embedding_local_bridge`; the
local bridge contract now also gates
`z2LatticeEmbeddingLocalBridgeData_near_pc_feasible_nonempty` and
`z2LatticeEmbeddingLocalBridgeData_paper_support_certificate`, so an unbounded
repair must prove near-`p_c` nonemptiness of the `kappaStar` feasible set
together with graph identity, scaling divergence, local domination, and the
paper-facing divergence transfer; the
current gate now also proves `not_z2_lattice_embedding_local_bridge_current`.
Thus the local transfer is usable, but the present local bridge contract is
still uninhabitable because its unbounded `α` domain includes `α = 2`, where
the concrete `kappaStar p 2` branch is zero at near-`p_c` non-negative
left-neighbourhood points; the blocker theorem is now the proof spine for
this obstruction. It also gates
`mean_estimate_gap_lt_one_of_nonneg_p_of_pos_kappa`,
`kappaStar_eq_zero_of_one_lt_alpha_of_nonneg_p`,
`not_unbounded_part6_divergence_witness_current`,
`not_unbounded_part6_pointwise_paper_domain_certificate_current`, and
`not_unbounded_part6_feasible_divergence_witness_current`, so the current
carrier is ruled out at the unbounded pointwise/output witness layer as well as
at the local-bridge layer. It now also gates
`not_unbounded_part6_full_paper_domain_witness_current` and the combined
`unbounded_part6_current_obstruction_certificate`, tying the near-`p_c` zero
branch, unbounded output-witness obstructions, full same-`alpha` witness
obstruction, and local-bridge obstruction into one audited theorem. It also
names `UnboundedPart6FullPaperClosingSupport`,
`ClosedUnitPart6FullPaperClosingSupport`, and
`Part6FullPaperClosingSupport`, then proves
`not_part6_full_paper_closing_support_current`; the current formalized surface
therefore rules out both existing routes as complete paper-closing supports.
It also gates `Part6FullPaperClosingDivergenceWitness`,
`part6_full_paper_closing_support_divergence_witness`,
`not_part6_full_paper_closing_divergence_witness_current`, and
`not_part6_full_paper_closing_support_current_via_divergence_witness`, so the
future support theorem has to project to a real same-`alpha` divergence output
and the current carrier is refuted at that projected output layer.
The bridge route is also tied to that output by
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
support/bridge-route current obstructions through that full bundle. This pins a
future Part 6 closure to one machine-checked package containing support,
divergence, and same-`alpha` feasible/divergence witnesses.
The unified `part6_current_frontier_certificate` now packages the unbounded
current-obstruction certificate, scaling-candidate obstruction certificate,
and closed-unit current-obstruction certificate together with the paired/full
output-bundle obstructions, support obstruction, and bridge-route obstruction.
It also gates `Part6FullPaperClosingBridgeRoute`,
`part6_full_paper_closing_support_of_bridge_route`, and
`not_part6_full_paper_closing_bridge_route_current`, pinning the future
upstream obligation to an actually inhabited repaired bridge route rather than
a prose description of nondegenerate support. The same gate now
proves `alphaStar_eq_one_current` and
`not_closed_unit_alpha_above_alphaStar_current`, so a naive closed-unit
paper-domain repair is also empty on the current scalar carrier. The
closed-unit local bridge contract now makes both the `alphaStar 0 p_c < 1`
threshold certificate and the nonempty-domain requirement explicit, carries
near-`p_c` feasible-set nonemptiness on that closed-unit paper domain, and
`gap_cognitive_threshold_part6_from_z2_lattice_embedding_closed_unit_local_bridge`
now provides the bounded transfer theorem for any future instance on
`alphaStar 0 p_c < α <= 1`, and
`gap_cognitive_threshold_part6_from_z2_lattice_embedding_closed_unit_local_bridge_witness`
turns the bridge's derived nonempty-domain certificate into an explicit paper-domain
divergence witness. The gate also checks
`not_closed_unit_part6_divergence_witness_current` and
`not_closed_unit_part6_feasible_divergence_witness_current`, so the current
carrier is ruled out at the closed-unit output witness layer as well as at the
bridge-contract layer. It also checks
`z2LatticeEmbeddingClosedUnitLocalBridgeData_paper_support_certificate`,
which binds the `Z^2` graph identity, scaling divergence, threshold
certificate, local domination field, near-`p_c` feasible-set nonemptiness, and
same-`alpha` witness projection into one closed-unit Part 6 paper-support
theorem. The unbounded-local paper-support certificate now also includes
same-`alpha` feasible/divergence support. The gate also checks
`z2LatticeEmbeddingLocalBridgeData_pointwise_paper_domain_certificate`,
`z2LatticeEmbeddingClosedUnitLocalBridgeData_pointwise_paper_domain_certificate`,
and
`z2LatticeEmbeddingClosedUnitLocalBridgeData_feasible_divergence_witness`,
so the same-alpha projections remain independently auditable. The gate also checks
`closed_unit_alpha_domain_nonempty_iff_alphaStar_lt_one`, reducing the
closed-unit nonempty-domain repair to a positive `alphaStar 0 p_c < 1`
threshold certificate. It also gates
`alphaStar_lt_one_requires_sentimental_welfare_reversal_witness` and
`z2LatticeEmbeddingClosedUnitLocalBridgeData_sentimental_welfare_reversal_required`,
so the closed-unit repair must provide a genuine sentimental welfare reversal
inside the closed unit alpha range, not merely another scaling-carrier wrapper.
It also checks `ClosedUnitAlphaStarTailReversalRepairRoute`,
`alphaStar_lt_one_of_closed_unit_tail_reversal_repair_route`,
`closed_unit_alpha_domain_nonempty_of_tail_reversal_repair_route`, and
`not_closed_unit_alphaStar_tail_reversal_repair_route_current`, so one
kernel-checked sufficient route is now explicit: prove a uniform tail
sentimental welfare reversal above some `a < 1`; the current carrier is blocked
because it remains beta-monotone on the whole closed unit interval.
The gate lifts that route to the bridge level through
`Z2LatticeEmbeddingClosedUnitTailReversalBridgeData`,
`z2LatticeEmbeddingClosedUnitLocalBridgeData_of_tail_reversal_bridge`,
`part6_full_paper_closing_bridge_route_of_closed_unit_tail_reversal_bridge_nonempty`,
and
`part6_full_paper_closing_support_of_closed_unit_tail_reversal_bridge_nonempty`,
while
`not_z2_lattice_embedding_closed_unit_tail_reversal_bridge_current` records the
current obstruction at that exact bridge-level surface.
The gate also checks
`z2LatticeEmbeddingClosedUnitLocalBridgeData_paper_support_with_sentimental_reversal`,
which combines that reversal requirement with the closed-unit paper-support
certificate on the same bridge-level contract.
It also gates
`not_z2_lattice_embedding_closed_unit_local_bridge_paper_support_with_sentimental_reversal_current`,
so the current carrier is blocked at that exact combined-contract surface.
`not_z2_lattice_embedding_closed_unit_local_bridge_current` gates the current
threshold-certificate obstruction at the bridge-contract level. The Part 6
repair is therefore first to supply a nondegenerate `α`/feasible-set domain
certificate, including
`alphaStar 0 p_c < 1` for the closed-unit route, then instantiate that repaired
bridge with a paper-faithful carrier whose domination theorem
holds near `p_c`, before there can be a live Cat 2 percolation-universality
closure target. R518 adds
`Z2LatticeEmbeddingBridgeData`, making that future
certificate shape explicit in Lean: it must name `SimpleGraph.Z2LatticeGraph`
and provide a replacement scaling carrier with both the `DivergesAtBelowAtTop`
proof and the high-α domination theorem consumed by
`gap_cognitive_threshold_part6_from_z2_lattice_embedding_bridge`; R521's
local-transfer layer remains preferred because the divergence proof only
consumes near-`p_c` domination, but its bridge data needs the domain repair
above before it can be a final certificate shape. The
thirty-five dead-end
ledger markers are tracked as `notInput`, not as theorem targets. Main paper
theorem `#print axioms` output must reduce to Lean/Mathlib kernel axioms plus
explicit hypotheses.

The former Principal Part 2 bridge obligations are now current-carrier
dead-ends rather than explicit theorem interfaces:
`not_AggregateWelfareWithDifferenceDominatesUnderFOSD_current` and
`not_exists_AggregateOptimalBetaMonotoneUnderDiffDom_current` record the
obstructions. A future aggregate-welfare kernel must replace this unrestricted
carrier route.

Trap-tree `c_star_constant` positivity is likewise a projection theorem from
the explicit current positive-subtype witness in
`KappaStarDepthDCarriers_current`, rather than a global carrier axiom or an
extra theorem hypothesis on the `κ*(d)` bounds.
`KappaStarDepthDCarriers_current` now provides the unit positive constant as a
current concrete carrier model; the asymptotic theorem is now a current-carrier
result for the paper route.

`ReachableSet` is now definitionally `ForwardReachable _ ∅ _`, with
`ReachableSet_eq_ForwardReachable_empty` proved by `rfl`. The C1/C2 diagnostic
conditions and `IsTopologyBlind` are now semantic definitions over the current
IDP carriers, not standalone global source axioms.

`Vertex` is now the concrete canonical finite carrier `Fin 5`; its
`Fintype`/`DecidableEq` instances are inherited from Mathlib.

`IsEdge` is now the concrete loopless complete relation `u ≠ v`; `IsEdge.symm`
is a theorem rather than a separate source axiom.

`PercolationOutcome` is now the concrete Boolean open-edge assignment space
`Vertex → Vertex → Bool`, with `IsOpen` defined by symmetric open-edge
assignment.

`ForwardReachable` is now a concrete finite reachable set: the start vertex
itself plus vertices connected by a reflexive-transitive chain of open edges
outside the visit history. `ForwardReachable_self_member` is a theorem.

`DegreeTwoStartingVertex` is now a semantic `IsEdge`-neighbourhood predicate
rather than a standalone global source axiom.

`TerminalNeighbourTopology` is now a semantic `IsEdge` topology predicate,
rather than a standalone global source axiom.

The remaining diagnostic/signal scope predicates `C2prime_GreedyPathMisalignment`,
`C3_InformationLocality`, and `IsBlackwellOrdered` now project from
`DiagnosticSignalHypothesisData`, a transparent inductive kernel-data package
marked for local instance resolution rather than a source-level project axiom
or counted proof-record interface.

The trap-prevalence Part 1 paperGraph preconnectedness bridge is now closed by
`Infrastructure.paperGraph_preconnected_current` from the current
complete-loopless `IsEdge` definition. The all-open forward-reachability
identification is now also closed by
`ForwardReachable_empty_full_at_all_open_current`, so this route no longer has
a paperGraph bridge carrier.

The paper dynamic value `V_dyn` is now concretely defined as the `Finset.sup'`
of rewards over `ForwardReachable`; `V_dyn_def` is a kernel theorem by `rfl`,
not a global structural-equation axiom.

`blockingProb` is the concrete canonical non-degenerate value `1/3`. `reward`
is a concrete bounded five-state profile and `intrinsicPref` is the neutral
`1/2` realisation. Their strict/range facts, including
`blockingProb_mem_unitInterval`, `reward_mem_unitInterval`, and
`intrinsicPref_mem_unitInterval`, are theorems rather than separate
source-level axioms.
Future fully parameterised coverage should move the blocking probability to
theorem/module parameters rather than reintroducing a global source axiom.

The unused `oracleReward` stub is a transparent neutral placeholder in the
current scalar model, and `oracleReward_mem_unitInterval` is a theorem. The
real Definition 2.6 oracle expectation remains a future concrete-oracle module
task, but this no longer contributes source-level axioms.

The Wrongness/topo-cluster unit upper bound is now a derived theorem from the
concrete finite percolation expectation and `topoLossKernel_mem_unitInterval`.
The below-threshold giant-event bridges
`topoLossKernel_eq_orderStatisticsRatio_on_giant_paper_Def` and
`giantComponent_cluster_size_lower_bound_paper_Def` are now transparent bridge
abbreviations, and the current diagnostic global chain consumes their current
closures internally rather than exposing them as theorem-level premises. The
full finite-lattice bridge route is preserved by
`topoLossKernel_pointwise_bound_on data` over an explicit
`WrongnessPercolationData` package.
The underlying Wrongness/topo percolation carriers (`wInfoOracleKernel`,
`wInfoOracleClusterCount`, `topoLossKernel`, `giantComponentEvent`, and
`expectedTopoLossAboveLowerConst`) now project from a transparent diagnostic
`WrongnessPercolationData` package. This removes the former source axiom. The
oracle and above-threshold lower-bound sides remain neutral, while the topo
side has a nonempty `n = 1` giant-event witness and
`expectedTopoLossOnGiant 1 p = 1/2` as kernel theorems. The non-trivial `Z^2_L`
giant-component and above-threshold lower-bound content remains explicit as
theorem interfaces where the route is still mathematically viable.
The current proofs of
`topoLossKernel_eq_orderStatisticsRatio_on_giant_current` and
`giantComponent_cluster_size_lower_bound_current` now have a real `n = 1`
diagnostic witness; the remaining target is a finite `Z^2_L` giant-component
carrier.
The above-threshold Mills-inverse route is now a kernel-proved dead-end, not
just a neutral-carrier limitation. `not_mills_inverse_above_threshold_route_with_unit_bound`
proves that R200 Mills identification plus R201 eventual lower bound would
force `expectedTopoLoss n p > 1`, contradicting the derived unit upper bound
`expectedTopoLoss_le_one_atom`. The remaining target is therefore a corrected,
unit-compatible `Z^2_L` lower-bound carrier/theorem, not the current
`1/(1-exp(-c))` bridge. R516 gates this state in
`topo_cluster_random_supercritical_z2_frontier_payload`, including the
conditional expectation formulas, below/above phase theorem surfaces,
boxed-torus flat-family lower-bound package, and Mills-route obstructions.
R519 adds the `Z2TopoClusterBridgeData` certificate interface and gates its
family-core/lower-bound projections in `PaperSemanticGate.lean`; this keeps the
future random-supercritical `Z^2_L` bridge as an explicit machine-checked
obligation rather than a prose-only roadmap item. The current gate strengthens
this with `RandomSupercriticalZ2TopoClusterBridgeData`, but that old structure
is now retained only as a kernel-refuted over-strong route:
`not_random_supercritical_z2_topo_cluster_bridge_contract_current` proves that
its uniform giant-restricted lower-bound field is incompatible with the
pointwise giant-loss envelope on flattened boxed-torus sizes. The active
closure interface is the repaired
`RandomSupercriticalZ2TopoClusterRepairedBridgeData`, whose fields include the
finite boxed-torus vertex/edge indexing facts, a named strict supercritical
probability, a flat expected-loss lower-bound theorem, a giant-event mass
lower-bound theorem, family-level unit-interval loss range, the same
family-core theorem package, and non-diagnostic guards excluding the current
full-reach, flat-only, all-open-complement, deterministic all-open giant,
deterministic all-open positive, pointwise-hybrid, and extended eventual-tail
diagnostic families. The repaired projections
`randomSupercriticalZ2TopoClusterRepairedBridgeData_eventually_uniform_flat_event_mass_lower_bound_and_loss_realisation`,
`randomSupercriticalZ2TopoClusterRepairedBridgeData_eventually_giant_event_member`,
`randomSupercriticalZ2TopoClusterRepairedBridgeData_eventually_uniform_flat_event_mass_member_and_loss_realisation`,
`randomSupercriticalZ2TopoClusterRepairedBridgeData_eventually_uniform_supported_extended_non_diagnostic_member`,
`randomSupercriticalZ2TopoClusterRepairedBridgeData_eventually_uniform_supported_extended_non_diagnostic_member_with_giant_member`,
and `randomSupercriticalZ2TopoClusterRepairedBridgeData_paper_support` fold the
flat lower bound, giant-event mass, explicit giant-event membership,
same-index support, same-`L` non-diagnostic support with a giant-event member,
unrestricted positive-loss realisation, strict
`p_c < p < 1` parameter, graph/indexing facts, and non-diagnostic tail
into one gateable surface. `PaperSemanticGate.lean` gates both the old
contract obstruction and the repaired bridge projections so the eventual
closure target is now a concrete Lean structure, not a prose instruction. The
topo payload now also
gates `boxedTorusFullReachFlatOnlyZ2TopoClusterBridge_current`, its
family/core/lower-bound projections through the bridge interface, and
`boxedTorusFullReachFlatOnlyComplementTopoLossData_flatOnlyDiagnostic`,
which proves the current flat-only family has zero total expected topo loss
off the flattened boxed-torus index and zero giant-restricted topo loss at
every index. It also gates
`boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_eq_failureMass`,
so the current lower-bound support is explicitly the full-reach failure
complement, not the final random-supercritical `Z^2_L` event.
R520 adds and gates the stronger full-reach bridge
`boxedTorusFullReachZ2TopoClusterBridge_current`, its family/core/flat
lower-bound projections, its fixed-`L`
`UnitCompatibleAboveThresholdLowerBoundConclusion` theorem, and
`not_boxedTorusFullReachComplementTopoLossData_flatOnlyDiagnostic`, separating
the full-reach finite carrier from the flat-only diagnostic. The same payload
now also gates the all-open boxed-torus finite
giant-event package, its restricted-envelope theorem, the positive restricted
loss regression on `boxedTorusAllOpenPositiveTopoLossData`, and the
`boxedTorusAllOpenComplementTopoLossData` flat-sequence lower-bound package
with its per-member unit-compatible, full-cluster, envelope, and `1/8` flat
expected-loss lower-bound theorems. The same payload also gates
`not_UnitCompatibleAboveThresholdLowerBoundConclusion_boxedTorusFullReachFlatOnly`
and the current-bridge form of that obstruction,
showing that each fixed flat-only member cannot satisfy the all-`n`
above-threshold lower-bound interface; this is the kernel-checked reason the
current family remains a diagnostic/all-open/flat-sequence frontier rather
than the final random-supercritical carrier.
The active repaired random-supercritical bridge surface is now known to be
nonempty: `firstEdgeOpenGiantClosedTopoLossRepairedBridge_current` instantiates
`RandomSupercriticalZ2TopoClusterRepairedBridgeData` using the first-edge-open
cylinder event, `p = 3/4`, a uniform flat expected-loss lower bound, a uniform
giant-event-mass lower bound, unit-interval topo loss, and the repaired
paper-support certificate. The selected event is also now tied to the existing
boxed-torus edge flattening surface:
`boxedTorusFlattenBaseHorizontalEdge_eq_firstEdgeIdx` proves that the
boxed-torus base horizontal edge flattens to the canonical first edge, and
`firstEdgeOpenGiantClosedTopoLossFamily_giant_event_boxedTorusBaseHorizontal_mem_iff`
identifies the witness giant event with that edge-open cylinder.
`firstEdgeOpenGiantClosedTopoLossFamily_giant_event_baseHorizontalTarget_reachable`
then proves that the base horizontal target is in the boxed-torus open-edge
reachable set on the selected event. The same calibration now proves
`firstEdgeOpenGiantClosedTopoLossFamily_topoLossKernel_zero_on_giant` and
`firstEdgeOpenGiantClosedTopoLossFamily_expectedTopoLossOnGiantOn_boxedTorus_eq_zero`,
then turns that into
`firstEdgeOpenGiantClosedTopoLossFamily_not_positive_giant_loss_lower_bound_at_three_quarters`,
so the current witness has zero topological loss on its selected giant event
and cannot provide a positive uniform giant-restricted lower bound. The gate
also packages this current compatibility and not-closing surface as
`firstEdgeOpenGiantClosedTopoLossRepairedBridge_current_compatibility_certificate`.
The missing paper-closing field is now named as
`RandomSupercriticalZ2TopoClusterRepairedBridgeGiantLossPaperClosing`; the old
final contract projects to it, and
`firstEdgeOpenGiantClosedTopoLossRepairedBridge_current_not_giant_loss_paper_closing`
proves the current repaired witness cannot supply it.
The gate also names
`RandomSupercriticalZ2TopoClusterRepairedBridgeFullPaperClosingSupport`, which
combines repaired paper support with same-constant flat loss,
giant-restricted loss, giant-event mass, and in-giant positive-loss support;
the old final contract projects to it, and
`firstEdgeOpenGiantClosedTopoLossRepairedBridge_current_not_full_paper_closing_support`
refutes it for the current first-edge witness.
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
The final existential route is now named as
`RandomSupercriticalZ2TopoClusterFullPaperClosingRoute`; the gate checks that
full-support repaired bridges inhabit it, that the route exposes a repaired
bridge and full-support witness, and that the old over-strong contract would
project to it.
It also gates
`randomSupercriticalZ2TopoClusterFullPaperClosingRoute_paper_support_output`,
`randomSupercriticalZ2TopoClusterFullPaperClosingRoute_giant_loss_output` and
`randomSupercriticalZ2TopoClusterFullPaperClosingRoute_combined_support_output`,
so the future route must project to the repaired paper-support surface, the
missing giant-loss field, and the same-tail flat/giant/mass/positive-realisation
package before the remaining Mathlib/percolation work can count as
paper-semantic closure.
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
so the current first-edge witness is refuted at the exact
paper-support-inclusive full output-bundle surface.
The route outputs are now also collected into
`RandomSupercriticalZ2TopoClusterFullPaperClosingRouteOutputCertificate` and
gated in `topo_cluster_random_supercritical_z2_frontier_payload`, so the
frontier checks the route-output surface through one Lean certificate as well
as through the individual projection theorems.
The unified `random_supercritical_z2_topo_cluster_current_frontier_certificate`
now packages this route-output certificate, the route-level paper-support
output, and bundled obstruction together with the finite positive-regression
certificate
`firstEdgeGiantStochasticTopoLossData_positive_regression_certificate`.
It also packages
`random_supercritical_z2_topo_cluster_giant_pointwise_loss_route_certificate`,
which proves that a pointwise-on-giant repaired route would close the
giant-loss field, the full repaired support surface, and the named full route,
while the current first-edge witness cannot satisfy that route.
It now also includes
`RandomSupercriticalZ2TopoClusterRepairedBridgeDiagnosticObstructionCertificate`
and
`random_supercritical_z2_topo_cluster_repaired_bridge_diagnostic_obstruction_certificate`,
so the repaired bridge surface itself excludes the current full-reach,
flat-only, all-open-complement, deterministic all-open giant, deterministic
all-open positive, pointwise-hybrid, and eventual diagnostic-tail families.
It also gates
`randomSupercriticalZ2TopoClusterFullPaperClosingRoute_supported_extended_non_diagnostic_output`,
so any final route must expose arbitrarily large non-diagnostic finite members
carrying full flat/giant/mass/in-giant-positive support.
The combined
`random_supercritical_z2_topo_cluster_current_frontier_certificate` now gates
both the old over-strong bridge-contract obstruction and that repaired
first-edge compatibility/not-closing witness, diagnostic obstruction
certificate, and finite positive-regression and pointwise-route certificates
in one theorem.
This is a
reachability and zero-loss calibration for the repaired interface, not the
final paper theorem, because the witness remains a one-edge cylinder rather
than the genuine random finite `Z^2_L` giant-component carrier.
For Part 6, the new `closed_unit_alpha_domain_repair_certificate` packages the
closed-unit `alphaStar 0 p_c = 1` degeneracy, the exact nonempty-domain iff,
the forced sentimental-reversal witness, the sufficient tail-reversal route,
and the current route obstruction as one gate theorem.
The `part6_bridge_route_support_certificate` now also packages both
local/closed-unit bridge-to-support projections, the total bridge-route
support projection, and the current branch/route obstructions as one audited
Part 6 route-surface theorem.
R321 removes the positive Mills wrappers and the
R200/R201 Prop interfaces from the live conditional theorem surface.
R407 adds that corrected interface shape,
`UnitCompatibleAboveThresholdLowerBoundConclusion data`, and proves the
selected all-open boxed-torus core carrier cannot satisfy it: its carrier-local
`expectedTopoLossOnData` is identically zero.
R408 proves the corrected interface is nevertheless viable on a transparent
nonzero diagnostic carrier: `unitPositiveTopoLossData` has
`expectedTopoLossOnData = 1/2` and closes
`UnitCompatibleAboveThresholdLowerBoundConclusion` with witnesses
`p = 3/4`, `c = 1/2`, and `N = 0`.
R409 strengthens this from a constant diagnostic integrand to a finite
Bernoulli edge-state witness: `firstEdgeStochasticTopoLossData` has topo loss
`1/2` exactly when the first finite edge is open, and Lean proves
`expectedTopoLossOnData = (1-p)/2`.
R410 strengthens the finite stochastic regression witness again by making the
same first-edge-open condition the explicit giant event:
`firstEdgeGiantStochasticTopoLossData` proves exact event mass `q`, restricted
topological loss `expectedTopoLossOnGiantOn = (1-p)/2`, positive/full-cluster
giant-event conclusions, and the corrected lower-bound interface. The real
`Z^2_L` giant-component/reward-loss carrier remains the target.
The gate now also packages this as
`firstEdgeGiantStochasticTopoLossData_positive_regression_certificate`, adding
the explicit `p = 3/4` positive giant-restricted regression check to the public
frontier without promoting the finite first-edge carrier to a random
finite-lattice theorem.
R411 moves the positive topo-loss regression onto the boxed-torus all-open
coordinate-edge event: `boxedTorusAllOpenPositiveTopoLossData` proves
all-open event-indicator mass, positive restricted/full topo-loss expectation
`((1-p) ^ Fintype.card (BoxedTorusEdgeIdx L)) / 2` at the flattened
boxed-torus graph size, and the full-cluster giant-event package. Lean also
proves that this fixed-`L` carrier still cannot satisfy the eventual
unit-compatible lower-bound interface, isolating the next target as a
positive lower-bound family across all sufficiently large finite lattices.
R412 adds `boxedTorusAllOpenFirstEdgeAwayTopoLossData`, an explicit
compatibility carrier that keeps the boxed-torus oracle/cluster/giant packages
on the all-open finite-torus event, sets topo loss to zero at that flat index,
and uses the first-edge stochastic loss away from it. Lean proves this one
package satisfies the oracle interfaces, finite nonzero oracle witness,
pointwise giant-event bound, restricted giant-event envelope, full-cluster
boxed-torus event package, boxed-torus cluster-count expectation bounds, and
the corrected above-threshold lower-bound interface. This closes the current
graph-local theorem core as a kernel-only interface package, while leaving the
paper-faithful target unchanged: the positive all-large topo-loss lower bound
still needs to be tied to the same genuine finite-lattice giant event.
R413 replaces that separated-support public-core witness with
`firstEdgeOpenGiantClosedTopoLossData`. The giant event is the same
first-edge-open event used by the envelope side; topo loss is zero on that
event and `1/2` on its first-edge-closed complement, so Lean proves
`expectedTopoLossOnGiantOn = 0` and `expectedTopoLossOnData = p / 2` in the
same data package. This closes the below-envelope, full-cluster,
cluster-count, and corrected above-threshold lower-bound interfaces through
one event/complement mechanism. The remaining paper-faithful target is still
the random `Z^2_L` giant-component/reward-loss carrier.
R414 upgrades the diagnostic event again to
`allEdgeOpenGiantComplementTopoLossData`: the selected giant event is
`allEdgeOpenEvent n`, the event that every edge in the current finite
`EdgeIdx n` carrier is open, and the topo-loss kernel is zero on that event
and `1/2` on its complement. Lean proves the all-edge-open event is nonempty,
has mass `q ^ Fintype.card (EdgeIdx n)`, has zero restricted giant-event loss,
and has full expected topo loss bounded below by the R413 first-edge-closed
loss `p / 2`. The public core now uses this all-current-edge event/complement
package, while the paper-faithful target remains the random `Z^2_L`
giant-component/reward-loss carrier.
R415 migrates the public core from that transparent cluster-count diagnostic
back onto the boxed-torus reachable-set carrier:
`boxedTorusAllOpenComplementTopoLossData 1` uses the concrete finite-bond
reachable-set cardinality from `boxedTorusFiniteBondGraphOracleData 1`, the
all-coordinate-edge-open boxed-torus event at the flattened size, zero
topo-loss on that event, and `1/2` complement loss at that flat index. It
retains the first-edge-closed tail away from the flat index to keep the
corrected above-threshold lower-bound interface eventual and uniform. The
remaining paper-faithful target is still a random supercritical `Z^2_L`
giant-component/reward-loss family, not the deterministic all-open event.
R416 proves that the flat boxed-torus sizes themselves no longer need that
away-from-flat tail: for `boxedTorusAllOpenComplementTopoLossData L`, Lean
computes the flat-index expected topo loss as
`(1 - (1 - p) ^ Fintype.card (BoxedTorusEdgeIdx L)) / 2` and proves a uniform
`1/8` lower bound at `p = 3/4` for every `L`. The new family-level interface
`BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion` closes for
the family `boxedTorusAllOpenComplementTopoLossData` with `L0 = 0`. This is a
boxed-torus flat-sequence theorem. R417 wires this result into the public
`ParametricGraphLocalDilemmaTheoremCore`: the core now selects the
`boxedTorusAllOpenComplementTopoLossData` family and member `L = 1`, using the
member for oracle/giant/cluster packages and the family for the lower-bound
side. The public core no longer depends on the fixed-carrier all-`n`
`UnitCompatibleAboveThresholdLowerBoundConclusion` tail.
R418 reroutes the public theorem-core witness family to
`boxedTorusFullReachComplementTopoLossData`. The flat-size giant event is now
defined by full cardinality of the concrete finite-bond oracle reachable set;
the all-open event is only a sub-event used for positive mass in the
probability domain `0 < q <= 1`. The flat lower-bound package now closes as
`BoxedTorusFullReachFlatUnitCompatibleAboveThresholdLowerBoundConclusion_current`
with witnesses `p = 3/4`, `c = 1/512`, and `L0 = 1`, using the
base-incident-closed obstruction plus the degree-four incident-edge bound.
R419 changes the public theorem-core witness family to
`boxedTorusFullReachFlatOnlyComplementTopoLossData`. It agrees with the R418
full-reach complement package at `n = boxedTorusFlatGraphN L`, transfers the
same `1/512` flat lower bound by equality at that index, and sets the
off-flat public topo-loss/giant-event surface to zero/empty. The selected
public core no longer carries the R418 first-edge off-flat diagnostic tail.
R420 removes the transfer from the current proof dependency path: Lean now
proves
`boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedIncident`
directly for the flat-only carrier, then derives the `1/512` lower bound from
the same incident-degree bound. The equality-to-R418 theorem remains only as a
comparison fact.
R421 exposes the probability event in that argument. Lean now defines
`boxedTorusFullReachFailureEvent`, proves the closed base-incident event is a
sub-event of it, proves a full-reach-failure mass lower bound, and identifies
the flat-only carrier's expected loss with one half of that failure-event
mass.
R422 exposes the finite success/failure mass partition behind the same route:
full-reach failure mass is now proved equal to `1 -` full-reach success mass,
the local closed-incident obstruction is restated as an upper bound on
full-reach success probability, and the flat-only expected-loss theorem now
uses the success-mass complement form.
R423 abstracts the local obstruction behind `BoxedTorusBaseTargetSeparator`.
Any coordinate edge set whose closure blocks every base-to-horizontal-target
open path now yields full-reach failure mass and success-mass upper bounds via
generic separator/cutset theorems. The current instance remains the
base-incident cut, but the replacement point for a nonlocal `Z^2_L` proof is
now explicit.
R424 adds the omega-free cutset form `BoxedTorusBaseTargetEdgeCutset` and the
bridge `boxedTorusBaseTargetSeparator_of_edgeCutset`. A future nonlocal
`Z^2_L` proof can target the pure edge-skeleton cutset statement and then
reuse the existing separator, event-mass, and expected-loss layers.
R425 proves the converse bridge `boxedTorusBaseTargetEdgeCutset_of_separator`,
so the closed-edge separator and pure edge-skeleton cutset formulations are
equivalent for this finite boxed-torus route.
R426 adds `boxedTorusCoordEdgeBoundarySet_baseTargetEdgeCutset`: any finite
vertex region containing the base and excluding the horizontal target produces
the required edge cutset via its coordinate edge boundary. This is the standard
region-boundary target for a future nonlocal `Z^2_L` crossing/separation proof.
R427 exposes that region-boundary target at the probability and loss layers:
the boundary-generated separator now feeds directly into full-reach failure
mass, success-mass upper bounds, and the flat-only expected-loss lower bound.
R428 instantiates the current public numerical lower-bound theorem through the
singleton base-region boundary: its boundary is proved to have cardinality at
most four by comparison with the base incident-edge set, and the `1/512`
flat-only lower bound now calls the singleton-boundary expected-loss theorem.
R429 factors the numerical step through a generic small-boundary theorem: any
base-containing, target-excluding vertex region whose boundary has cardinality
at most four supplies the same `1/512` lower-bound shape, with `{base}` only as
the current finite obstruction instance.
R430 lifts that bridge to the flat-family package level:
`BoxedTorusFullReachFlatOnlyLowerBoundConclusion_of_eventually_smallBoundary`
closes the package from any eventual family of such small boundaries, and the
current public package is now just the singleton-family instance.
R431 generalizes the package-level theorem to any eventual boundary family
with a uniform finite coordinate-boundary bound `B`:
`BoxedTorusFullReachFlatOnlyLowerBoundConclusion_of_eventually_boundedBoundary`
uses the explicit constant `(3/4)^B / 2`; the old small-boundary package is
now the `B = 4` specialization.
R432 generalizes that bounded-boundary theorem over the selected probability:
`BoxedTorusFullReachFlatOnlyLowerBoundConclusion_of_eventually_boundedBoundary_at`
accepts any explicit `p` with `p_c < p <= 1` and uses constant `p^B / 2`;
the fixed `3/4` theorem is only the current public witness instance.
R433 exposes the corresponding pointwise expected-loss theorem:
`boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedBoundary_pow_div_two_of_card_le`
turns any boundary-cardinality bound `<= B` into the explicit `p^B / 2`
lower bound before any existential package theorem is used.
R434 exposes the current singleton specialization as a separate pointwise
theorem:
`boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_baseSingletonBoundary_pow_four_div_two`
gives `p^4 / 2` for the base-region boundary before the current `1/512`
specialization is applied.
R435 moves the reusable bridge below vertex boundaries:
`boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedSeparator_pow_div_two_of_card_le`
and
`BoxedTorusFullReachFlatOnlyLowerBoundConclusion_of_eventually_boundedSeparator_at`
accept bounded edge separators directly, and
`BoxedTorusFullReachFlatOnlyLowerBoundConclusion_of_eventually_boundedCutset_at`
does the same for omega-free edge cutsets. Vertex-boundary families now
specialize the separator package instead of being the only package interface.
R436 exposes the omega-free cutset route at the pointwise loss layer:
`boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedCutset_pow_div_two_of_card_le`
is the direct `p^B / 2` theorem for bounded edge cutsets, and the
bounded-cutset package now consumes it directly.
The semantic gate packages this reusable route as
`boxedTorusFullReachFlatOnlyLowerBound_cutset_route_certificate`, so future
nonlocal `Z^2_L` cutset/crossing work has a single machine-checked lower-bound
interface to instantiate.
R437 rewires the historical base-incident pointwise theorem through the same
cutset layer: the current local witness is now a cutset instance, not a
separate expected-loss calculation.
R438 gives the sibling full-reach complement carrier the same separator/cutset
surface: its `..._ge_closedIncident` theorem now delegates to an audited
`..._ge_closedCutset` specialization.
R439 adds the sibling `p^B / 2` quantitative separator/cutset layer, and the
older public `1/512` theorem now instantiates the `B = 4`, `p = 3/4` cutset
theorem instead of calling the legacy incident theorem.
R440 lifts that sibling predecessor route through vertex-boundary and
singleton-boundary specializations too: its `1/512` theorem now factors through
the explicit `{base}` `p^4 / 2` theorem.
R441 lifts the predecessor's existential lower-bound theorem to the same
eventual bounded separator/cutset/boundary package interface: the new
`BoxedTorusFullReachComplementLowerBoundConclusion_of_eventually_*` theorems
close the sibling carrier from a reusable bounded local obstruction family, and
the historical current theorem now delegates to that package-level current
instance.

The concrete scalar `agentRewardKernel` now proves five former structural
obligations directly: general unit-interval range, Bayesian/Sentimental
pointwise monotonicity, κ-agent pointwise continuity, and κ-agent increasing
differences.
The greedy high-precision limit kernel and pointwise-atTop convergence are now
closed from the same concrete scalar carrier: the limit kernel is the constant
`6/10`, and `greedyKernelPointwiseTendstoAtTop` proves eventual equality to it.
The supermodular scalar carriers now come from a concrete scalar package
(`snrZ`, `BridgeDominance`, `sigEffRatioFactor`, `mPrime`,
`bridgeValueGap`, `pCorrectDerivKappa`, and `vDynDerivBeta`), and
`canonicalSupermodularFactorSigns` proves the current factor-sign interface.
It also proves the three 5-state pointwise monotonicity facts for κ-agent
above-threshold, κ-agent at-threshold, and Bayesian-naive below-threshold
directly by unfolding the current concrete scalar kernel.
The Bayesian-naive above-threshold strict reversal witness is now an explicit
Prop-valued theorem interface rather than a global source axiom, since the
current scalar `bayesianNaive` branch is constant and the strict reversal
requires a future non-trivial Bayesian-naive kernel.

The R205 Harris-Kesten / Cardy / Smirnov-Werner lower-envelope obligation is
now a kernel-proved dead-end and no longer retained as a separate Prop
interface: `not_harrisKestenScalingFunction_diverges_at_pc_paper_Def` shows the
current unbounded lower-envelope carrier is zero on `p ≥ 0`. The cognitive
threshold Part 6 chain now exposes the required mathematics through the
parameterized `kappaStar_diverges_at_pc_via_scaling_carrier` interface instead
of depending on a global `_paper_Def` axiom; the remaining carrier-repair work
is a paper-faithful carrier/domain change, or a different replacement carrier
whose high-alpha domination theorem avoids the R468 `alpha = 2`, `p = 0`
empty-feasible-set obstruction.

The five-state loss-shape `_paper_Def` source axioms are also gone.
`L_interior_minimizer_exists_paper_Def` is now a theorem from the concrete
`L_minimum_exists_in_regime_i_proof`; R238 proves
`L_at_betaStarOfP_continuousOn_paper_Def` by a Lipschitz value-function
argument, so `envelope_continuity_in_p_*` no longer takes a bridge
hypothesis.
R256 closes the former Gaussian-ratio bridge:
`L_lowerGaussianHazard_antitoneOn_pos` and
`L_upperGaussianMills_antitoneOn_pos` prove the lower-hazard and upper-Mills
positive-half-line antitonicity facts from quotient differentiation,
`gap_phi_tail_bound`, and `Phi_reflect`. R469 retires the former
`L_strict_unique_minimizer_paper_Def` `True` compatibility theorem from source;
the `L_unimodal_in_regime_i_*` chain no longer takes it, or the intermediate
L-shape reductions, as public premises.
The R238 continuity fact plus the R249-R255 Gaussian/threshold
single-crossing chain are now ordinary theorem reductions rather than
`Prop`-interface surfaces.
R245 defines the explicit residual
`L_balanceResidual` and makes `L_firstOrderBalance` its zero set. R246 corrects
the live bridge to single-crossing-after-zero: after a residual zero on the
positive right branch, all later positive right-branch points have strictly
positive residual. R247 factors out the common positive chain-rule scale, R248
rewrites the reduced beta-core as the one-variable Gaussian z-core
`L_balanceResidualZCore` under `z = Delta_B / sqrt(2 * signalVariance β)`, and
R249 removes the positive `Delta_B` factor while exposing
`c = 0.9 * (1 - p)` in `L_balanceResidualNormalizedZCore`; R250 rewrites that
normalized core as `c * H(z) - K(z)` and moves the bridge to positivity
persistence of `H` plus strict decrease of `K/H`; R251 factors
`H = scale * D` and `K = (1/2) * scale`, so the live bridge is positivity
persistence and strict increase of the normalized denominator `D`; R252 rewrites
`D` as the explicit hazard/Mills denominator
`Phi z * (1 - (upperMills((2/9)z) * lowerHazard z) / (2/9))`, and proves
`D(z) > 0` iff that hazard/Mills product is `< 2/9`; R253 reduces denominator
shape to non-increase of that explicit product on positive `z`.
R236 exposes
the already-formalized left-branch derivative sign as
`L_hasDerivAt_negative_on_left_branch`; R237 exposes the right-branch
derivative sign as the conditional theorem
`L_hasDerivAt_positive_of_right_branch_dominance`; R241 proves
`L_global_minimizer_not_left_branch`, excluding positive global minimisers on
the left branch by local descent from the negative derivative; R242 proves
`L_global_minimizer_not_right_branch_dominance`, excluding the current
positive-derivative dominance condition at a positive global minimiser. The
R243 Fermat step proves `L_global_minimizer_first_order_balance`, the exact
first-order balance equation at any positive global minimiser. The remaining
strict-uniqueness work is the pair of pure one-variable Gaussian ratio
antitonicity facts for upper Mills and lower hazard.

`AgentEdgeIdx` is now concretised as `Fin 7`, following the existing
`Wrongness.EdgeIdx` finite-carrier pattern; its type/Fintype/DecidableEq
declarations are no longer source axioms.

The Principal `aboveThresholdWelfare` / `belowThresholdWelfare` carriers are
now concrete finite weighted sums over `principalSampleAbove` /
`principalSampleBelow`; their integral-identification lemmas are definitional
theorems instead of source-level structural-equation axioms.
The above/below sample support types now project from `PrincipalSampleData`,
which packages the support carrier with its `Fintype` and `DecidableEq`
instances, plus the sample `weight`, `kappa`, and `alpha` fields consumed by
the finite weighted sums. The public parameter functions are projections from
that data package rather than standalone global source axioms.
Those two sample-data packages and the G-parameterised
`aggregateWelfareWith` functional now come from concrete one-point principal
samples rather than a remaining `PrincipalData` source axiom. The two
Principal sample-weight non-negativity facts are kernel-proved for the
unit-weight samples.

The Principal per-agent optimum aggregate `perAgentOptimalAggregate` is also a
concrete finite weighted sum over the sample carriers and per-agent `β*`
assignments; its integral-identification lemma is definitional.

The current scalar κ-agent welfare is constant at `1/2`. Principal now uses
that theorem to close the above-threshold individual monotonicity atom, the
combined convergence witness, the negative-β below-threshold boundary atom,
and both per-agent optimum dominance atoms. The strict Principal witness
claims are now kernel-proved false for the current scalar carrier and tracked
as dead-end routes instead of live Cat 3 inputs:
`PrincipalSampleBelowWeightedSumEventuallyDecreasing`,
`PrincipalSampleBothCombinedDominanceWitnessPair`,
`PrincipalSampleBothExceedsZeroWitness`, and
`PrincipalSampleBothValleyTripleWitness`.
The old Part 1 strict-interior wrappers and Part 3 valley-triple wrapper have
been retired. `principal_interior_maximum_exists` remains a closed current
maximizer-existence theorem; strict interiorness requires a future non-constant
Principal kernel.
The per-agent `β*` selectors are canonical `0` definitions under the same
constant-welfare indifference.
`W_bar_eventually_decreasing` is proved directly from the same constant
welfare. The strict disclosure-suboptimality ingredient
is also kernel-proved false for the current constant `W_bar`; the old
false-premise `gap_disclosure_full_suboptimal` wrapper has been retired, so
Part 1 now requires a future non-constant Principal kernel. R470 also retires
the old vacuous averaged-overshoot atom from the live theorem inventory: the
`delta_bar := 1` existential discharge is tracked as a dead-end/notInput marker,
not as Cat 1 evidence for the disclosure mechanism.

Trap-tree terminal reward is now represented by the concrete definition
`oracleBridgePathTerminalReward_TrapTree := fun _ => r_goal`; the former
`oracleBridgePathTerminalReward_TrapTree_eq_r_goal_OPEN` interface is a theorem
and is no longer an explicit hypothesis of `gap_error_compounding_part2`. The
empty compatibility carrier has also been removed; public
`gap_error_compounding_part2` is now the direct kernel theorem.

The ER supercritical survival carrier `poissonSurvival` is now a concrete
witness definition and `gap_er_supercritical_OPEN` is a kernel-pure theorem;
the canonical branching-process fixed-point development remains an upstream
contribution target.

The `V_g_terminal_in_ForwardReachable` bridge is now a theorem from the
well-founded `V_g` recursion and canonical `ForwardReachable` transitivity.
The remaining local GeneralGraphs bridge interfaces
`V_g_eq_V_dyn_on_terminal_neighbour_interface`,
`C2_to_C2prime_via_V_g_eq_V_dyn_at_terminal_neighbour_interface`, and the
R240 cyclic closed wrapper are Prop-valued interfaces consumed explicitly by
downstream theorems. The cyclic wrapper now uses
`C1_Irreversibility_current` plus explicit C2′/C3 diagnostic evidence rather
than a standalone structural-equation bridge.

`V_g` is now a well-founded concrete greedy traversal over the current
canonical finite vertex carrier (`Vertex = Fin 5`). The paper recursive-
definition equations `V_g_def_terminal` and `V_g_def_step` are current
theorems obtained from `greedyPathValue.eq_def`; no `V_gRecursionCarriers`
interface remains on this path.

`V_g_eq_V_dyn_on_terminal_neighbour_current` is now a dead-end route marker
rather than a closed contribution: it is kernel-closed only vacuously by
`not_TerminalNeighbourTopology_current`, because the complete-loopless `Fin 5`
graph does not support the paper's terminal-neighbour topology. The companion
`C2_to_C2prime_via_V_g_eq_V_dyn_at_terminal_neighbour_current` theorem is
tracked the same way, since it closes for the same false-premise reason. A
non-vacuous bridge is now a graph-parametric carrier task.

The old current-carrier C2/C2prime local-greedy bridge route is no longer a
live interface surface: `not_C2LocalGreedyDominatesForwardReachableAtWitnesses_current`
and `not_C2LocalGreedyDiagnosticWitnessBridge_current` refute the expanded
domination/equality premises, and `not_C2primeLocalGreedyFullWitness_current`
refutes the same-witness full C2prime existential. The finite counterexample
puts `u_high = 1` in the visit history, giving diagnostic value `0.6`, while
`u_low = 2` can reach reward-`1` vertex `0`; local greedy then follows
`0 -> 3` and terminates at reward `0`. This retires the old global bridge
route and leaves the non-vacuous route as a graph-parametric/local-neighbour
theorem, not a hidden project assumption.
The no-load `gap_dilemma_parametricGraphScope_current` wrapper was removed:
its graph-scope premise was ignored, so the concrete fin5Trap current route
now calls the current scalar dilemma theorem directly instead of contributing
a misleading conditional theorem signature.

The Theorem 6.1 greedy C2′ kernel-reversal witness
`agentRewardKernel_greedy_C2prime_kernel_reversal_witness` is now closed for
the current scalar carrier by
`agentRewardKernel_greedy_C2prime_kernel_reversal_witness_current`. The generic
routes remain available as `gap_general_tree_from_reversal` and
`gap_cyclic_trap_from_reversal`; public `gap_general_tree` and
`gap_cyclic_trap` consume the current witness internally.

The Bayesian bounded-rationality carriers are transparent data carriers:
`MyopicKWelfareCarriers` and `SatisficingCarriers` carry the paper-specific
myopic/satisficing functions, while current satisficing behavior evidence is
exposed as ordinary theorems rather than hidden global axioms. The ER
supercritical interface and Principal aggregate-optimum
existence interface are also explicit theorem inputs rather than source-level
`_OPEN` axioms.
The public myopic-k theorem no longer exposes the Blackwell-monotonicity input:
`gap_robustness_myopic_k` consumes the closed current
`gap_blackwell_monotonicity` theorem and current carrier directly; the former
generic Blackwell wrapper is retired from the live theorem-signature surface.
`MyopicKWelfareCarriers_current` supplies a zero below-depth branch as a
kernel-visible model of the explicit paper-implicit carrier slot. The
horizon-suffices equality is now stated over that current carrier, so
`MyopicKWelfareCarriers` no longer contributes a conditional theorem
signature.
`SatisficingCarriers_current` likewise gives a concrete affine model,
`acceptance β = β` and `welfare β = -β`; the public
`gap_robustness_satisficing` now proves that current model directly, so the
satisficing carrier no longer contributes a conditional theorem signature or a
counted proof-record interface.
The same public/generic split is now used for conditional reduction part (i):
`gap_conditional_reduction_part_i` consumes the closed current Blackwell
monotonicity theorem internally, while
`gap_conditional_reduction_part_i_from_blackwell` preserves the explicit
Blackwell-parameter route. `IsBlackwellOrdered signalFamily` remains a genuine
scope hypothesis.
Cognitive-threshold Part 2 also uses this split:
`gap_cognitive_threshold_part2` consumes the closed current Blackwell
monotonicity theorem internally, while
`gap_cognitive_threshold_part2_from_blackwell` preserves the explicit
Blackwell-parameter route. The public Part 2 theorem now exposes no
diagnostic graph-scope parameters. The surrounding theorem bundle no longer
carries `TerminalNeighbourTopology`; it still carries `Conditions_C1_C2_C3`
only where Part 3 consumes that bridge hypothesis.

Canonical five-state Blackwell-transfer clauses now use the same split:
public `gap_threshold_fiveState_kappa_above_kstar` and
`gap_bayesian_naive_reversal_absent` consume the closed current Blackwell
monotonicity theorem internally, while
`gap_threshold_fiveState_kappa_above_kstar_from_blackwell` and
`gap_bayesian_naive_reversal_absent_from_blackwell` preserve the explicit
Blackwell-parameter routes.
R471 corrects the above-threshold Bayesian-naive reversal status: the current
constant Bayesian-naive reward kernel refutes the required strict reversal
witness, so `prop:bayesian-naive-five-state` Part (iii) is a current-carrier
dead-end until a non-constant Bayesian-naive kernel is supplied.

The supermodular factor-sign obligations are packaged for the current concrete
scalar model by `canonicalSupermodularFactorSigns`. The generic
`SupermodularFactorSigns` route remains available through
`gap_supermodular_from_signs` and `gap_policy_complementarity_from_signs`;
public `gap_supermodular` and `gap_policy_complementarity` consume the current
package and no longer expose that interface parameter. The current kernel route
also no longer threads a non-load-bearing Topkis theorem parameter through
these results; Topkis remains an optional semantic-alignment Mathlib target.

The above-threshold topological-loss Mills route is explicitly dead-ended:
`not_mills_inverse_above_threshold_route_with_unit_bound` shows that the
R200/R201 Mills-inverse decomposition is incompatible with the unit upper bound
on topological loss. A future route must prove a corrected, unit-compatible
constant lower bound for a real `Z^2_L` carrier.
The corrected interface is now present as
`UnitCompatibleAboveThresholdLowerBoundConclusion data`; Lean refutes it for
the current all-open boxed-torus carrier, so the next mathematical target is a
nonzero stochastic finite-lattice topo-loss carrier rather than another wrapper
around the all-open regression package.
The same interface now has a positive kernel-only diagnostic witness,
`unitPositiveTopoLossData_unitCompatibleAboveThresholdLowerBoundConclusion`,
which proves the repaired statement shape is consistent while keeping the
real `Z^2_L` carrier as the remaining target.
It also has a finite stochastic regression witness,
`firstEdgeStochasticTopoLossData_unitCompatibleAboveThresholdLowerBoundConclusion`,
whose lower bound is derived from `percExpectation_open_edge_indicator`.
R410 further ties the finite stochastic lower bound to a positive-mass event:
`firstEdgeGiantStochasticTopoLossData_positiveGiant_and_unitCompatible`
combines the first-edge-open giant-event package with the corrected
above-threshold lower-bound conclusion.
R411 adds the boxed-torus counterpart
`boxedTorusAllOpenPositiveTopoLossData`: it has a genuine finite `Z^2_L`
all-open event with positive restricted and full topo-loss expectation.
The companion theorem
`not_UnitCompatibleAboveThresholdLowerBoundConclusion_boxedTorusAllOpenPositive`
shows why a fixed finite lattice cannot be the final theorem route.
R412 then strengthens the public graph-local theorem core with
`UnitCompatibleAboveThresholdLowerBoundConclusion data` and supplies the
combined carrier `boxedTorusAllOpenFirstEdgeAwayTopoLossData 1`. That carrier
keeps the boxed-torus oracle/cluster/giant packages and adds an all-large
first-edge topo-loss tail, proving the current interfaces are mutually
kernel-consistent while still marking the same-event finite-lattice giant
carrier as the next paper-faithful target.
R413 reroutes the public graph-local theorem core to
`firstEdgeOpenGiantClosedTopoLossData`, replacing that all-large separated
tail with a single first-edge-open event and its closed complement. The public
core now has one diagnostic package that simultaneously carries the nonzero
oracle interface, below-envelope package, full-cluster evidence,
cluster-count bounds, and corrected above-threshold lower bound.
R414 reroutes the public graph-local theorem core again to
`allEdgeOpenGiantComplementTopoLossData`, replacing the single-edge event with
the all-edge-open event over the full current finite carrier. The lower-bound
proof compares the not-all-open complement loss against the R413
first-edge-closed loss, preserving the uniform corrected above-threshold
lower bound while moving the selected event away from a one-edge diagnostic.
R415 reroutes the public graph-local theorem core to
`boxedTorusAllOpenComplementTopoLossData 1`, keeping an all-open/complement
loss mechanism at the flattened boxed-torus size while restoring the concrete
finite-bond reachable-set cluster count from `boxedTorusFiniteBondGraphOracleData`.
The first-edge-closed tail remains only away from the flat boxed-torus index to
discharge the eventual above-threshold lower-bound package.
R416 adds `BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion_current`,
showing that the boxed-torus flat sequence has a uniform positive
complement-loss lower bound without the away-tail. R417 replaces the public
graph-local core's all-`n` lower-bound package with this family-level
flat-sequence interface, so the away-tail is no longer part of the
unqualified theorem-core contract.
R418 replaces the public witness with
`boxedTorusFullReachComplementTopoLossData 1`: the selected event is full
finite-oracle reachability, not all-open, and the complement-loss lower bound
is proved from a local closed-neighborhood obstruction.
R419 replaces the selected public witness with
`boxedTorusFullReachFlatOnlyComplementTopoLossData 1`: the flat-size event and
lower bound are the same full-reach complement evidence, while off-flat
indices are zero/empty instead of the first-edge diagnostic tail.
R420 proves that lower-bound evidence directly on the flat-only carrier via
the closed base-incident obstruction, so the selected public theorem core no
longer uses the R418 carrier theorem as a proof dependency.
R421 factors this evidence through the full-reach-failure event mass theorem,
making the local probabilistic obstruction reusable rather than hidden inside
the expected-loss proof.
R422 factors the same evidence through the success/failure mass partition, so
the selected public theorem core now exposes the exact probability interface
that a future nonlocal `Z^2_L` giant-component proof must replace.
R423 additionally factors that probability interface through a generic
separator/cutset predicate. Future work can replace only the separator
instance, instead of rewriting the finite Bernoulli mass or expected-loss
layers.
R424 splits that replacement point into a pure edge-cutset theorem plus a
kernel-proved cutset-to-separator bridge, reducing the future nonlocal task to
a coordinate-path combinatorics statement before probability is applied.
R425 adds the reverse separator-to-cutset bridge, making that replacement
point mathematically exact rather than only sufficient.
R426 further reduces the replacement point to a vertex-region boundary theorem:
prove a suitable region separates base from target, and the existing kernel
chain supplies the edge cutset, separator, finite-event mass, and expected-loss
interfaces.
R427 makes that last sentence literal in the theorem surface: boundary
specializations now exist all the way through full-reach event mass and the
flat-only expected-loss lower-bound theorem.
R428 wires the current local numerical instance through that same boundary
surface: `{base}` is the selected finite region, its coordinate boundary has
cardinality at most four, and the public `1/512` lower bound uses the
singleton-boundary theorem rather than directly using the closed-incident
expected-loss route.
R429 lifts the numerical bridge one level above that singleton instance:
`boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedBoundary_one_over_512`
accepts any qualifying small coordinate boundary before the public theorem
specializes it to `{base}`.
R430 lifts the same idea to the family/package interface: the public flat
boxed-torus lower-bound package is derived from an eventual small-boundary
family theorem, not directly from the singleton theorem.
R431 replaces the hard-coded small-boundary package bridge with a uniformly
bounded-boundary bridge parameterized by `B`; the singleton route remains the
current finite obstruction instance.
R432 removes the remaining hard-coded probability from that reusable bridge:
the public package can now be closed at any above-threshold `p`, while the
selected current witness still instantiates `p = 3/4`.
R433 pushes the same quantitative bridge down to the pointwise loss layer, so
future nonlocal `Z^2_L` boundary or crossing work can target a direct expected
loss theorem before closing the package interface.
R434 keeps the current singleton obstruction equally explicit: the selected
local route is now an arbitrary-`p` `p^4 / 2` theorem plus the public
`p = 3/4` numerical weakening, not a hidden singleton-only calculation.
R435 makes the nonlocal replacement point broader than vertex-boundary
families: any eventual bounded edge separator or omega-free edge cutset now
feeds the same `p^B / 2` flat-family package, with the current singleton
boundary retained only as the local witness.
R436 moves the cutset bridge below package closure: future nonlocal `Z^2_L`
skeleton/crossing work can target the pointwise cutset lower-bound theorem
first, then reuse the package wrapper unchanged.
R437 makes the current base-incident obstruction instantiate that pointwise
cutset theorem, so the local witness and future nonlocal witness now share the
same proof spine.
R438 aligns the older full-reach complement carrier with that spine too, so the
off-flat-tail predecessor no longer has a separate base-incident-only
expected-loss route.
R439 aligns its numerical route as well: the predecessor's `1/512` proof now
consumes the same bounded-cutset quantitative theorem shape as the flat-only
successor.
R440 makes that predecessor's selected local witness the same singleton
vertex-boundary route, not merely an incident-edge cutset instance.
R441 gives the predecessor the same eventual separator/cutset/boundary
package-level wrapper as the flat-only successor, so future replacement work
can target either carrier through the same bounded-obstruction interface.
R442 adds `BoxedTorusFlatFamilyCoreConclusion` and wires it into the public
`ParametricGraphLocalDilemmaTheoremCore`; the current predecessor and flat-only
full-reach families both prove this family-level core, so the eventual
finite-`Z^2_L` replacement point is now an audited theorem-core field rather
than a nearby collection of per-member facts.
R443 adds
`parametricGraphLocalDilemmaTheoremCore_of_boxedTorusFlatFamilyCore`, making
that replacement point executable: any future family-level finite-`Z^2_L`
package proof can be promoted directly to the public graph-local theorem core.
R444 removes the derivable `OracleInfoDecayConclusionOn (family L)` field from
`BoxedTorusFlatFamilyCoreConclusion`; the generic graph-local bridge now
recovers selected-member oracle decay from `WInfoOracleInterfacesOn` itself.
The future finite-`Z^2_L` family package therefore has one fewer proof field
to supply without weakening the public theorem core.
R445 removes that same derived oracle-decay field from the unqualified
`ParametricGraphLocalDilemmaTheoremCore` selected-member contract. The public
core now stores the pointwise oracle-interface package as the proof surface;
oracle decay remains available through the compatibility `...CoreOn` route
when needed.
R446 removes the remaining selected-member package duplication from the
unqualified core.  The theorem core now stores the family-core package once,
plus the already audited `ParametricGraphLocalGreedyDilemmaCore`;
selected-member oracle, topo-loss, giant-event, and cluster-count facts are
recovered from the family-core eventual witness when needed.
R447 removes the last direct graph-local tuple expansion from the unqualified
core.  Graph scope and greedy reversal now enter through
`ParametricGraphLocalGreedyDilemmaCore`, so the theorem-core tuple stores one
closed graph-local subpackage instead of repeating its two fields.
R448 applies the same cleanup to the legacy nonzero-oracle compatibility
surface: `ParametricGraphLocalDilemmaTheoremCoreOnWithNonzeroOracle` is now
the closed `ParametricGraphLocalDilemmaTheoremCoreOn data` package plus the
single extra nonzero-oracle witness field.
R449 removes the graph-local tuple expansion from the on-data compatibility
core itself.  `ParametricGraphLocalDilemmaTheoremCoreOn data` now stores the
closed `ParametricGraphLocalGreedyDilemmaCore` subpackage plus the selected
member's derived oracle-decay theorem.
R450 removes another derivable field from the family-core package:
`ExpectedTopoLossOnGiantEnvelopeConclusion (family L)` is no longer an
eventual per-member input.  The stored
`TopoLossKernelPointwiseBoundOn (family L)` field now supplies the envelope
through `BoxedTorusFlatFamilyCoreConclusion_expectedTopoLossOnGiantEnvelope`
and `expectedTopoLossOnGiantEnvelopeConclusion_from_pointwise_bound`.
R453 demotes that envelope recovery from a conditional theorem signature to a
proof-valued projection `def`.  The family-core package still supplies the same
kernel-checked restricted-expectation envelope when consumed, but the syntactic
conditional theorem surface then contained only the R443 generic family-core
promotion bridge.
R454 demotes that remaining R443 promotion bridge,
`parametricGraphLocalDilemmaTheoremCore_of_boxedTorusFlatFamilyCore`, to a
proof-valued `def` as well.  It remains the public kernel-checked transformer
from a closed `BoxedTorusFlatFamilyCoreConclusion family` proof into the
graph-local theorem core, but no theorem/lemma signature now carries an
interface premise under the syntactic conditional audit.
R455 removes the redundant `CurrentDilemmaConclusion` Prop-interface wrapper.
The current route now states the pair
`CurrentGreedyWelfareReversalConclusion ∧ CurrentOracleInfoDecayConclusion`
directly, preserving the same kernel proof while avoiding a counted package
that only repeated those two component interfaces.
R456 removes the redundant `CurrentGreedyWelfareReversalConclusion`
Prop-interface wrapper too.  The current route now states the beta/beta-prime
greedy welfare reversal existential directly, with
`currentGreedyWelfareReversalConclusion` retained as the theorem proving that
expanded statement.
R457 removes the redundant `CurrentOracleInfoDecayConclusion` Prop-interface
wrapper too.  The current route now states the finite nonzero
`WrongnessPercolationData` existential directly, and the bridge declarations
whose target exposes `OracleInfoNonzeroWitnessOn` are proof-valued `def`s, so
the theorem-signature audit remains at zero while the raw Prop-interface count
drops again.
R458 demotes `OracleInfoNonzeroWitnessOn` itself from a standalone `def`-level
Prop interface to a transparent `abbrev` for the expanded nonzero oracle
existential. The named witness theorems remain, but the alias is no longer
counted as an audited interface package.
R459 demotes `ExpectedTopoLossOnGiantEnvelopeConclusion` from a standalone
`def`-level Prop interface to a transparent `abbrev` for the same
restricted-expectation envelope. The pointwise-bound theorem still recovers
the envelope proof from `TopoLossKernelPointwiseBoundOn`, but the alias no
longer contributes another audited interface package.
R460 demotes the two below-threshold topo-cluster bridge statements,
`topoLossKernel_eq_orderStatisticsRatio_on_giant_paper_Def` and
`giantComponent_cluster_size_lower_bound_paper_Def`, from `def`-level Prop
interfaces to transparent `abbrev`s. Their current diagnostic closure theorems
and downstream pointwise topo-loss theorem remain unchanged, but the aliases no
longer contribute two separate audited interface packages.
R461 demotes the remaining counted `def`-level Prop packages in the
graph-local/wrongness core to transparent `abbrev`s: the parametric C2prime and
graph-scope witnesses, the local C2prime witness-on-data alias, the greedy
wrongness reversal witness, and the giant-event/cluster-count/above-threshold
boxed-torus family packages. The residual audit surface is now five
structure/class carrier interfaces, not theorem-level or `def`-level Prop
aliases.
R462 removes the remaining single-field `WrongnessGreedyInterfaces` structure
from the counted interface surface by making it a transparent abbreviation for
`GreedyWrongnessKernelReversalWitness`. The current wrongness reversal theorem
now applies `WrongnessGreedyInterfaces_current` directly rather than projecting
a record field.
R463 demotes the single-field `MyopicKWelfareCarriers` data record to a
transparent function-type abbreviation for the below-depth welfare branch. The
current carrier remains the same zero below-depth branch, and the public
myopic-k robustness theorem still uses the same kernel-pure `if_pos` route in
the paper-named `k >= d` regime.
R464 demotes the trap-tree `KappaStarDepthDCarriers` record to a transparent
positive-subtype carrier `{ cStar : ℝ // 0 < cStar }`. The public depth-d
`κ*` asymptotic route is unchanged: `c_star_constant` projects the value and
`c_star_constant_pos` projects the subtype proof for the current unit carrier.
R465 demotes `SatisficingCarriers` from a proof-bearing record to a transparent
pair of carrier functions. The current affine monotonicity and
welfare-antitonicity evidence is now exposed as ordinary theorems, so the
conditional-surface audit leaves only `DiagnosticSignalHypothesisData`.
R466 demotes `DiagnosticSignalHypothesisData` from a `class` record to a
class-attributed inductive kernel-data package with explicit accessor
definitions. The existing local-instance route is preserved, but the
conditional-surface audit now reports zero counted proof/carrier interfaces.
The below-threshold bridge mechanism now has a nonempty diagnostic carrier:
`oneStepGiantTopoLossData` proves, at `n = 1`, a nonempty giant event plus the
parameterized order-statistics bridge, cluster-size lower bound, pointwise
`1/(n+1)` bound, and restricted expectation envelope. This keeps the bridge
kernel-auditable on a non-vacuous finite carrier while leaving the real
finite `Z^2_L` giant-component/Mills carrier as the remaining target.
The same bridge is now wired to a genuine boxed-torus finite-graph event:
`boxedTorusAllOpenGiantTopoLossData` uses the all-open coordinate-edge event at
`n = boxedTorusFlatGraphN L`, proves nonemptiness and Bernoulli mass
`q ^ |E_L|`, proves full reachable-cluster cardinality
`boxedTorusFlatGraphN L + 1 = (L + 1)^2`, and closes the zero-loss all-open
boundary case with witness `k = n`. It also exposes the data-level flat
giant-event mass theorem and inherits the boxed-torus square-event
cluster-count expectation lower/upper bounds for the same data package.
The below-threshold envelope and epsilon-convergence wrappers are now
available at the `WrongnessPercolationData` parameter level and are
instantiated for this boxed-torus all-open package.
The graph-local dilemma core now stores the corresponding pointwise
topo-loss bound for the same selected carrier, and the restricted-expectation
envelope is recovered from that pointwise theorem. It also stores
`GiantComponentEventFullClusterConclusion data`, so the all-open giant event
is proof-carrying as a full-cluster positive-mass event rather than only as a
nonempty finite set or a positive-mass-only event package. It also stores
`BoxedTorusClusterCountExpectationBoundsConclusion data`, so the square-event
cluster-count expectation lower bound and vertex-count upper bound are part of
the theorem-core data package rather than only nearby standalone theorems.
Public Wrongness/Phase below-threshold wrappers now consume the current closed
bridge package internally, reducing the syntactic conditional theorem signature
count; explicit bridge use remains only in the lower bridge/atom layer and the
parameterized carrier route.
The compatibility nonzero-oracle existence theorem still records this
all-open boxed-torus package rather than the oracle-only boxed-torus package.
The public graph-local core has since advanced to
`boxedTorusFullReachFlatOnlyComplementTopoLossData 1`, which uses full
finite-oracle reachability as the selected flat-size event and has zero/empty
off-flat public surface. This is progress toward the real finite-lattice
carrier, but it is not yet the random supercritical giant-component theorem or
the above-threshold Mills lower bound.

There are no remaining source-level project axioms.

The oracle information-decay pointwise obligations close directly on the
current neutral global carrier through `W_info_oracle_current_uniform_unit_bound`.
The legacy global `WInfoOracleInterfaces` route is retired; future non-neutral
oracle work remains on the parameterized `WInfoOracleInterfacesOn data` surface
and its finite/boxed-torus instances.
The public `currentOracleInfoDecayConclusion` theorem is no longer that legacy
global zero-residual theorem and no longer targets a standalone
`CurrentOracleInfoDecayConclusion` package; it proves directly an existential
finite nonzero `WrongnessPercolationData` package whose witness also stores
`WInfoOracleInterfacesOn data` and no separate already-derived
`OracleInfoDecayConclusionOn data` field, witnessed by the all-open boxed-torus
carrier `boxedTorusAllOpenGiantTopoLossData 1`. The smaller
`boxedTorusFiniteBondGraphOracleData 1` theorem remains as a regression
witness with the same explicit-interface package shape.
The nonzero oracle branch now has a checked finite-carrier core theorem. The
unqualified `fin5Trap_parametricGraphLocalDilemmaTheoremCore` selects
`boxedTorusFullReachFlatOnlyComplementTopoLossData 1`, pairing the fin5Trap
local-greedy reversal with a finite nonzero oracle/topological carrier whose
boxed-torus flat-index giant event is full concrete finite-bond reachability,
whose complement loss is lower-bounded by the base-incident-closed event, and
whose off-flat public surface is zero/empty rather than a first-edge fallback.
Its
theorem-core type also requires the family-level
`BoxedTorusFlatFamilyCoreConclusion family` package, whose eventual
per-member fields include
`WInfoOracleInterfacesOn data`,
`TopoLossKernelPointwiseBoundOn data`,
`GiantComponentEventFullClusterConclusion data`,
`BoxedTorusClusterCountExpectationBoundsConclusion data`. The
restricted-expectation envelope remains derivable from the pointwise
topo-loss field. The
`fin5Trap_parametricGraphLocalDilemmaTheoremCoreWithNonzeroOracle` name is now
a compatibility alias for that same strengthened core, while
`fin5Trap_boxedTorusAllOpenGiant_parametricGraphLocalDilemmaTheoremCoreOnWithNonzeroOracle`
keeps the transparent `OracleInfoNonzeroWitnessOn` abbreviation in the
concrete theorem package without a separate generic theorem-level
nonzero-oracle premise. R451 also removes the
derived oracle-decay field from `CurrentOracleInfoDecayConclusion`, so the
current oracle package stores interfaces plus nonzero evidence and recovers
decay by `oracleInfoDecayConclusionOn_from_finite_interfaces`. This does not
solve the random topo-loss giant-component same-event lower-bound carrier
problem; R443/R454 only make the family-core-to-graph-local promotion generic
and theorem-signature-free.
R452 removes `GiantComponentEventPositiveMassConclusion` from the raw
Prop-interface inventory: positive-mass-only liveness is now an expanded
theorem target and a proof-valued projection from
`GiantComponentEventFullClusterConclusion`, whose full-cluster event already
contains the nonempty and positive-mass components.
random topo-loss giant-component same-event lower-bound carrier problem, but
it means the local dilemma core is no longer evidenced only by the neutral zero
oracle package or a prose-only topo-loss/nonempty-event/above-threshold side
condition.

The greedy-kernel reversal witness is packaged for the current scalar kernel by
`WrongnessGreedyInterfaces_current`. Public `gap_wrongness` and `gap_dilemma`
consume the current package directly and no longer expose or retain an
interface-parameter theorem route.

Legacy R152 planning snapshot follows; do not treat it as current:

```
Total ledger entries: 334
- gapClosed:       158
- gapDefinitional: 163  (Cat 3 §3.4.3 paper-foundational, 永不 close)
- gapOpen (legacy): 11   (then-current planning snapshot; current count above is 0)
- gapPartial (legacy): 1    (Phi-tail bundle; current count above is 0)
- gapDeadEnd:      1    (kappaStar_p_monotone def-marker, NOT axiom)
- gapBlocked:      0
Cat 3 sub-type:    workingAssumption (legacy)=1 (also a marker, NOT axiom)
```

The current 215 closed theorems are Lean-checked, but not all are strict
kernel-only in the final target sense: many depend on paper-novel carriers,
structural-equation atoms, external classical bridges, or explicit diagnostic
hypotheses.

## Audit summary (R152, three parallel agents)

### Audit A — Current Mathlib backlog (0 live Cat 2 entries)

| Bucket | Count | Entries |
|---|---|---|
| A: closeable NOW with existing Mathlib | 0 | None in the live `cat2External=0` ledger set. |
| B: already source-closed; optional semantic-alignment PRs | 6 | Blackwell DPI, Topkis supermodularity, David-Nagaraja rank symmetry, David-Nagaraja order-statistics expectation, ER phase, and power-law phase. These are no longer active project gaps, but reusable Mathlib versions would better match the paper route. |
| C: live Cat 2 external backlog requiring substantial upstream infrastructure | 0 | The former Harris-Kesten lower-envelope target is now a project-local dead-end, not an upstream-ready Cat 2 theorem. |
| D: project-local carrier repair before Mathlib work | 1 | R467 supplies a valid replacement carrier's divergence half, but R468 refutes this exact carrier's current unbounded high-alpha domination target. Repair the carrier/domain interface, or find a different replacement carrier with a valid domination theorem, before Harris-Kesten/Cardy/SLE infrastructure becomes the live Cat 2 target again. |

### Audit B — Infrastructure/ PR-readiness (33 modules, 3,921 LOC)

| Bucket | Count | Action |
|---|---|---|
| A: ready NOW with editorial pass | 16 | Bundle into 9 PRs (sequence below) |
| B: needs cleanup (rename, deduplicate, generalise) | 13 | Triage against current Mathlib first; only PR genuine deltas |
| C: paper-specific (not for upstream) | 4 | `FiveStateRewards`, `FiveStateVDyn`, `MLimitDifferenceConcrete`, `Roadmap` — keep in repo, never PR |

### Audit C — Lattice + bond percolation Mathlib roadmap (6 phases)

| Phase | Content | Effort | Acceptance |
|---|---|---|---|
| 1 | Z^d integer lattice as `SimpleGraph` | small (8–10h) | high |
| 2 | Bond percolation as product Bernoulli measure | medium (30–45h) | high |
| 3 | FKG inequality for percolation (finite + infinite) | medium (25–35h) | high (finite) / medium (infinite) |
| 4 | Harris–Kesten theorem (`p_c(ℤ²) = 1/2`) | xl (250–400h) | high in principle, slow review |
| 5 | Grimmett 1999 §6.75 exponential decay (subcritical) | large (60–100h) | high |
| 6 | Erdős–Rényi phase transition (separate track) | large–xl (80–200h) | high |

**Total to Cat-1 closure of THIS paper's lattice gaps**: Phases 1 + 2a/b/c + 3a → 100–150h (excluding Mathlib review iteration).

**Full ambition (Phases 1–6, all theorem interfaces and dead-ended routes replaced)**: 600–900h.

## Master PR sequence (priority-ordered)

### Quick wins (under 50h each — can land in weeks)

**PR-1** — `Mathlib/Combinatorics/SimpleGraph/IntegerLattice.lean` ✅ **STARTED 2026-05-16**
- Stub already in `BlackwellDilemma/Infrastructure/IntegerLattice.lean` (builds GREEN)
- Defines `integerLatticeGraph (d : ℕ) : SimpleGraph (Fin d → ℤ)` + `Z2LatticeGraph`
- Adjacency = ℓ¹-distance equals one
- Basic lemmas: `l1Dist_self`, `l1Dist_symm`, `l1Dist_nonneg`, `integerLatticeGraph_adj_iff`
- Effort to PR-prep: 8h (add `degree_eq_two_mul_d`, `LocallyFinite`, `Preconnected`, ~15 API lemmas + Mathlib-style docstring polish)
- Acceptance: high; matches existing patterns (`Hasse`, `Circulant`, `UnitDistance/Basic`)

**PR-2** — `Mathlib/Topology/Order/Compact.lean` extension (independent of PR-1)
- From `BlackwellDilemma/Infrastructure/EVTBoundedDecreasing.lean` + `ArgmaxExistence.lean`
- Generalises EVT to `[a, ∞)` with eventually-decreasing dominance
- Effort: small (~10h after dedup against existing Mathlib)
- Acceptance: high

**PR-3** — `Mathlib/Combinatorics/SimpleGraph/Connectivity/Reachable.lean` extension
- From `BlackwellDilemma/Infrastructure/SimpleGraphReachable.lean`
- Adds Finset-packaging of forward-reachable component
- Effort: small (~6h)
- Acceptance: high

**PR-4** — `Mathlib/Algebra/Order/BigOperators/DiscreteTail.lean` (drop "Mills" name)
- From `BlackwellDilemma/Infrastructure/MillsRatioTail.lean` (rename — content is generic discrete tail bounds, NOT Mills's Gaussian ratio)
- Effort: small (~4h, mostly rename + dedup check)
- Acceptance: high

**PR-5** — `Mathlib/Algebra/Order/BigOperators/MonoLift.lean`
- From `BlackwellDilemma/Infrastructure/{BlackwellConditional, MonotoneIntegralFOSD, AbstractKernelMonotonicity, FOSDLiftedExpectation}.lean`
- Rename `BlackwellConditional` (generic Finset-sum monotonicity, no Blackwell theory)
- Effort: small (~12h after dedup)
- Acceptance: high

### Medium tier (50–100h each — 1–3 months part-time)

**PR-6** — `Mathlib/Order/Supermodular/{Basic,Comparative,Calculus}.lean` (foundation series)
- Pre-req: lattice-generalise from `ℝ → ℝ → ℝ` to `α → β → γ` over arbitrary lattices
- From `BlackwellDilemma/Infrastructure/{TopkisCrossPartial, SupermodularExtended, FOSDDerivativeChain, ArgmaxMonotone, DifferenceQuotientAlgebra, CalculusTopkis}.lean`
- Effort: medium (~50h for generalisation + Topkis equivalence theorem)
- Acceptance: high (Topkis is on Mathlib 1000.yaml as Q7824894 unformalised)
- **Closes `gap_topkis_supermodularity_OPEN`** (paper-special-case via in-repo specialisation)

**PR-7** — `Mathlib/Probability/Bayesian/GaussianConjugatePrior.lean`
- From `BlackwellDilemma/Infrastructure/GaussianPosterior.lean`
- Adds posterior variance + measure-theoretic statement using Mathlib's `MeasureTheory.Gaussian` if available
- Effort: medium (~30h)
- Acceptance: high

**PR-8** — `Mathlib/Probability/Bernoulli/FiniteProduct.lean`
- From `BlackwellDilemma/Infrastructure/{BernoulliProductFinite, PercolationExpectation}.lean`
- Reconciles with Mathlib's `ProbabilityTheory.bernoulli`
- Effort: medium (~20h)
- Acceptance: high; foundational for Phase 2 below

### Large tier (100–500h — multi-quarter)

**PR-9 / Phase 2 series** — `Mathlib/Probability/Percolation/{Basic,Cluster,Coupling,FKG}.lean`
- Pre-req: PR-1 (lattice graphs) + PR-8 (Bernoulli product) merged
- 3 sub-PRs:
  - 2a: `BondPercolation` definition + `IsOpen` + edge independence (~20h)
  - 2b: `Cluster` + measurability of cluster-size and infinite-cluster events (~25h)
  - 2c: Strassen monotone coupling + `percolationProbability` monotonicity (~15h)
- Effort: medium-large (~60h total)
- Acceptance: high (Mathlib explicitly waiting per `BinomialRandomGraph/README` stub)
- **Closes `trapLocalConfigProb_pos_and_le` and `restrictedExpectation_eq_localConfigProb`** Cat 3 lattice interfaces
- **Further upstreams non-local percolation machinery used by the Part 6/topo targets** (the Part 4 local-lattice gate is already closed in project source)

**PR-10** — `Mathlib/Probability/Independence/FKG.lean` + `Mathlib/Probability/Percolation/FKG.lean`
- Specialise existing `Combinatorics/SetFamily/FourFunctions` (Ahlswede-Daykin) to Bernoulli product
- 2 sub-PRs (finite + infinite via `Probability/InfinitePi`)
- Effort: medium (~25h)
- Acceptance: high (textbook Mathlib target)

### Extra-large tier (500h+ — multi-year, team effort)

**PR-11 / Phase 4 series** — `Mathlib/Probability/Percolation/{Critical, Russo, RSW, HarrisKesten}.lean`
- The Harris-Kesten theorem (`p_c(ℤ²) = 1/2`) — Mathlib's prime-number-theorem analogue in scope
- Sub-PRs: planar duality, RSW box-crossing, Harris half, Russo's formula, BKKKL influence inequality, sharp threshold + Kesten half
- Effort: xl (~250–400h)
- Recommendation: 2–3 person team; expect 12–24 months
- **Closes `gap_harris_kesten_OPEN`, `gap_percolation_probability_OPEN` (downstream)**

**PR-12 / Phase 5** — `Mathlib/Probability/Percolation/SubcriticalDecay.lean`
- Duminil-Copin–Tassion 2016 modern proof of subcritical exponential decay
- Effort: large (~60–100h); needs Russo from Phase 4 framework but not full Harris-Kesten
- **Closes `gap_grimmett_exponential_decay_OPEN`**

**PR-13 / Phase 6 series** — `Mathlib/Probability/Combinatorics/BinomialRandomGraph/{GiantComponent, MolloyReed, ConfigurationModel}.lean`
- Erdős–Rényi phase transition + Molloy-Reed criterion + Cohen power-law thinning
- 4 sub-PRs (definition, subcritical, supercritical, Molloy-Reed, Cohen)
- Effort: large–xl (~150–250h)
- Different reviewer pool than percolation, can run in parallel
- **Closes `gap_er_subcritical_OPEN`, `gap_er_supercritical_OPEN`, `gap_molloy_reed_OPEN`, `gap_cohen_powerlaw_OPEN`**

## Recommended landing order (minimise blocking)

```
Phase A (quick wins, ~6 weeks part-time):
  PR-1 (Z² lattice)       ✅ STARTED 2026-05-16
  PR-2 (EVT extension)
  PR-3 (SimpleGraph reachable)
  PR-4 (discrete tail)
  PR-5 (BigOperators MonoLift)

Phase B (medium, ~3 months part-time):
  PR-6 (Supermodular series)  → semantic Topkis alignment for the current theorem-interface route
  PR-7 (Gaussian posterior)
  PR-8 (Bernoulli product)    ← prerequisite for PR-9

Phase C (paper's substantive Cat 3 closures, ~3 months part-time):
  PR-9 (Percolation Basic+Cluster+Coupling)  → supports non-vacuous Wrongness giant-component carrier repair
  PR-10 (FKG)                                 → high reusability for Phase 6 too
  Project-local prerequisite                  → instantiate the R208 replacement scaling-carrier interface

Phase D (multi-year, team or back-burner):
  PR-11 (Harris-Kesten / universality series) → applies only after the replacement scaling carrier is instantiated
  PR-12 (cluster-size decay)                  → reusable support for the percolation track
  PR-13 (Erdős-Rényi / power-law series)      → semantic alignment for already source-closed ER/power-law phase routes
```

**End-state at Phase C completion**: Lean v2.0 of BlackwellDilemma can claim the project-local percolation carriers are domain-sound, with the current dead-ended lower-envelope route replaced by an instantiated theorem interface.

**End-state at Phase D completion**: Cat 1 only across the entire ledger; nothing remains in `gapOpen`, as a Cat 2 axiom, or as a dead-ended theorem route.

## Strategic value beyond this paper

Each PR contributes broadly reusable Mathlib infrastructure:

- **PR-1 (lattice)** — used by stat-mech, combinatorics, computer-science (cellular automata)
- **PR-6 (supermodularity)** — used by economics (Milgrom-Shannon), game theory (Vives), combinatorial optimization
- **PR-8 + PR-9 (percolation)** — used by stat-mech, probability theory, network science
- **PR-10 (FKG)** — used by Ising model, percolation, random-cluster representation
- **PR-11 (Harris-Kesten)** — Mathlib 1000.yaml target; high-prestige naming-rights anchor
- **PR-13 (Erdős-Rényi)** — used by graph theory, network science, computer science

## Cross-paper applicability (per OE memory)

These Mathlib contributions also serve other OE papers:
- `project_civilizational_capability_sinks` — graph fragmentation analysis
- `project_audit_framework_program` — V×P×S framework with network components
- `project_three_body_topology` — resilience-graph chapter
- `project_influence_decomposition_paper` — bipartite + network structure
- Future Millennium-target Lean projects (BSD, Hodge, Riemann, p-vs-np, Yang-Mills, Navier-Stokes) — all benefit from supermodularity, EVT, big-operator infrastructure

## Authorship leverage

Per `feedback_author_title_convention`: Mathlib commits are Tier A pure-mathematics → credit `Alex Li` only (no Accenture title). Accepted Mathlib PRs covering Harris-Kesten or Erdős-Rényi giant-component would establish naming-rights anchors well beyond the BlackwellDilemma paper, supporting v6 methodology-expert positioning.

## Immediate next actions (R152+ session work)

1. ✅ R152 complete: Phase 1 stub (`IntegerLattice.lean`) + this roadmap
2. Next session: PR-1 polish (add `LocallyFinite`, `Preconnected`, degree formula, ~15 API lemmas) → fork Mathlib4, draft PR
3. Session +2: PR-2/3/4 polish + draft (independent quick wins)
4. Session +3: PR-5 + start Mathlib Zulip thread for Supermodular series RFC
5. Session +4: PR-6 (Supermodular) — substantive math work begins

## Tracking

Each PR opened → tag with status in this file. Live ledger counts re-run via:
```bash
cd lean4 && lake env lean BlackwellDilemma/Ledger.lean | grep -E "(inventory|Total)"
```

If a future Cat 2 theorem interface is replaced by a Mathlib PR (merged + downstream substitution applied), update `Ledger.lean` entry to `gapClosed` + cite the Mathlib commit hash.
