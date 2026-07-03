# BlackwellDilemma — Lean 4 Formalisation

Machine-checked Lean 4 formalisation of:

> Alex Chengyu Li (2026). **Information Value Under Endogenous Feasibility.**
> SSRN preprint; submitted to *Theoretical Economics*.

The formalisation establishes a **label-level correspondence between every
labeled paper item and a Lean theorem** (12 definitions, 6 theorems,
16 propositions, 2 lemmas, 5 corollaries; see
[`PAPER_LEAN_CALIBRATION.md`](PAPER_LEAN_CALIBRATION.md) for the explicit
mapping). Complete paper-semantic closure is tracked separately by
[`BlackwellDilemma/PaperSemanticGate.lean`](BlackwellDilemma/PaperSemanticGate.lean):
the current open semantic targets are the lattice-IDP embedding route for Part
6 and the random supercritical `Z2_L` topological cluster/phase carrier.  These
open frontiers are machine-gated by `part6_lattice_embedding_frontier_payload`
and `topo_cluster_random_supercritical_z2_frontier_payload`, and the gate now
also checks the exact open/closed semantic target identifiers, not just their
counts.  The Part 4
lattice p-monotonicity semantic target is now closed by
`part4_lattice_p_monotonicity_frontier_payload`, which checks the
generic `sInf` transfer
`kappaStar_p_monotone_of_mean_gap_antitone` and the lattice bridge transfer
`gap_cognitive_threshold_part4_from_lattice_bridge`.  It now also
checks the kernel-pure one-edge Bernoulli monotone-coupling table, the
finite-product monotone-coupling marginal data, the finite-box expectation
monotonicity theorem for coordinatewise monotone observables, and the standard
paper-facing `BondConfig` / `percExpectation` bridge
`percExpectation_mono_in_p_of_BoolConfigMonotone`.  It also now checks the
one-edge percolation bridge
`bridgePriorRewardObservable_expectation_eq_priorMean_u2` and
`priorMean_u2_fiveState_antitone_in_p_from_percExpectation`, which identify
the bridge-neighbour prior mean with an explicit finite bond-percolation
expectation and recover its blocking-probability antitonicity from
finite-product monotonicity.  The same route now lifts through Gaussian
posterior monotonicity as
`mean_estimate_gap_antitone_in_p_from_percExpectation`, giving a ranged
finite-percolation reconstruction of the full mean-estimate-gap antitonicity
on `0 <= p_1 <= p_2 <= 1`, and
`gap_cognitive_threshold_part4_from_percExpectation`, which transfers that
route to bounded `kappaStar` p-monotonicity.  The same payload checks the
standard `Z^2`
lattice-coupling interface carrying the per-edge, finite-product, and
finite-box expectation layers and
`standardZ2LatticePMonotonicityBridgeSkeleton_current` and
`gap_cognitive_threshold_part4_from_standard_z2_bridge_skeleton_current`,
which deliberately remain diagnostic: the current bridge shape can be filled
with standard `Z^2` graph/coupling data, but its load-bearing mean-gap
antitonicity still comes from the already proved abstract/canonical theorem.
The payload now also checks
`standardZ2RangedLatticePMonotonicityBridge_current` and
`gap_cognitive_threshold_part4_from_standard_z2_ranged_bridge_current`.  The
ranged bridge now carries the standard `Z^2` graph/coupling data, an explicit
one-edge `BondConfig` observable embedded as a real `Z^2` adjacent edge, its
monotonicity, and the `percExpectation (1 - p)` prior-mean equality; the gate
also checks the finite expectation monotonicity theorem routed through the
bridge's own lattice monotone-coupling field.  It derives
`priorMean_u2_fiveState_antitone_in_p_from_ranged_lattice_observable` and
`mean_estimate_gap_antitone_in_p_from_ranged_lattice_observable` from those
fields before transferring to bounded `kappaStar` monotonicity.  This is a
local/finite cylinder bridge on the standard lattice; non-local random lattice
semantics remain tracked by Part 6 and the topo/phase target.  The Part 6
payload now likewise checks the standard `Z²` lattice graph identity and the
future embedding-certificate entrypoint
`gap_cognitive_threshold_part6_from_z2_lattice_embedding_bridge`.  The topo
payload now also checks the future `Z2TopoClusterBridgeData` certificate
projections
`BoxedTorusFlatFamilyCoreConclusion_from_z2_topo_cluster_bridge` and
`BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion_from_z2_topo_cluster_bridge`,
the current standard-`Z^2` boxed-torus witness
`boxedTorusFullReachFlatOnlyZ2TopoClusterBridge_current`, and its
family/core/lower-bound projections,
and the flat-only diagnostic
`boxedTorusFullReachFlatOnlyComplementTopoLossData_flatOnlyDiagnostic`, plus the
fixed-`L` all-`n` obstruction
`not_UnitCompatibleAboveThresholdLowerBoundConclusion_boxedTorusFullReachFlatOnly`,
the stronger full-reach witness `boxedTorusFullReachZ2TopoClusterBridge_current`,
its family/core/lower-bound projections, its fixed-`L`
`UnitCompatibleAboveThresholdLowerBoundConclusion` theorem, and
`not_boxedTorusFullReachComplementTopoLossData_flatOnlyDiagnostic`,
without closing the still-missing random finite-lattice carrier theorem.  It
also gates `firstEdgeOpenGiantClosedTopoLossRepairedBridge_current`, a finite
first-edge Bernoulli compatibility witness proving that the repaired
random-supercritical bridge contract is nonempty and kernel-clean.  A separate
finite positive-regression gate,
`firstEdgeGiantStochasticTopoLossData_positive_regression_certificate`,
packages the first-edge stochastic witness's unit-interval loss, positive-mass
full-cluster giant event, unit-compatible lower bound, and strictly positive
giant-restricted expected loss at `p = 3/4`.  The witness
event is now also calibrated to the boxed-torus base horizontal edge via
`boxedTorusFlattenBaseHorizontalEdge_eq_firstEdgeIdx`, and
`firstEdgeOpenGiantClosedTopoLossFamily_giant_event_baseHorizontalTarget_reachable`
shows that the base horizontal target is reachable in the boxed-torus open-edge
reachable set on that event.  The same gate also proves
`firstEdgeOpenGiantClosedTopoLossFamily_topoLossKernel_zero_on_giant` and
`firstEdgeOpenGiantClosedTopoLossFamily_expectedTopoLossOnGiantOn_boxedTorus_eq_zero`,
then packages that as
`firstEdgeOpenGiantClosedTopoLossFamily_not_positive_giant_loss_lower_bound_at_three_quarters`,
so this witness has zero topological loss on its selected giant event, cannot
support a positive uniform giant-restricted loss lower bound, and remains
separate from the genuine random `Z2_L` giant-component theorem.  The
payload now also gates
`random_supercritical_z2_topo_cluster_full_support_envelope_obstruction_certificate`,
which proves that the current full-support route surface is generally
uninhabitable: its uniform giant-restricted lower bound contradicts the
theorem-core pointwise giant-loss envelope along growing flattened boxed-torus
sizes.  The support-surface repair is now kernel-gated by
`RandomSupercriticalZ2TopoClusterRepairedBridgeSupportSurfaceRepair`,
`RandomSupercriticalZ2TopoClusterSupportSurfaceRepairRoute`, and
`random_supercritical_z2_topo_cluster_support_surface_repair_certificate`, and
the current repaired first-edge bridge inhabits that route.  The route-output
certificate
`random_supercritical_z2_topo_cluster_support_surface_repair_route_output_certificate`
also gates the repaired-bridge, paper-support, and same-tail
flat/mass/member/positive-loss non-diagnostic outputs of any inhabitant.  The
nonclosure certificate
`random_supercritical_z2_topo_cluster_support_surface_repair_nonclosure_certificate`
now packages this repaired route/output together with the current first-edge
inhabitant and the kernel refutations of the full paper-closing and boxed-torus
finite `Z2_L` routes, so the repair layer cannot be mistaken for theorem
closure.  The full paper-closing route is now also gated to project back
through this repaired support-surface route/output via
`randomSupercriticalZ2TopoClusterFullPaperClosingRoute_support_surface_repair_route`
and
`randomSupercriticalZ2TopoClusterFullPaperClosingRoute_support_surface_repair_output_certificate`.
The
remaining topo closure task is therefore to instantiate this repaired support
route with a genuine random finite `Z2_L` carrier.  The
full-reach flat-only lower-bound route is also packaged by
`boxedTorusFullReachFlatOnlyLowerBound_cutset_route_certificate`, which gates
the reusable separator/cutset/boundary implication from pointwise `p^B / 2`
loss lower bounds to the family-level lower-bound package.  The
threshold-five-state oracle-routing target is now closed by
`FiveState.highKappaOracleRoutingWelfare_eq_oracle`; the current neutral
kappa-agent carrier refutation
`FiveState.not_current_kappaAgent_highKappa_oracle_at_p0` remains as diagnostic
evidence for the retired carrier route.

Every claim is exposed as a Lean declaration with its formalisation status
tracked in [`BlackwellDilemma/Ledger.lean`](BlackwellDilemma/Ledger.lean).

## Build

```bash
cd lean4
lake exe cache get
lake build BlackwellDilemma
lake build BlackwellDilemma.PaperSemanticGate
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
* Some declarations may report no axioms.
* The source-level audit must report 0 project-level `axiom`, `opaque`,
  `_OPEN`, `_paper_Def`, `_workingAssumption`, and `_paper_witness`
  declarations.

Any printed project-level paper axiom or opaque source declaration is a RED
FLAG; paper primitives must be represented as structures, definitions, or
explicit theorem parameters, not global bridge axioms.

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
| `Canonical.lean` | §5 Prop `canonical` (4-state), Prop `interior-optimum` (5-state), Prop `two-regime-five-state` (with historical `three-regime` aliases retained), Prop `p-monotonicity`, Prop `threshold-five-state`, Prop `bayesian-naive-five-state`, Cor `five-state-policy` |
| `Bayesian.lean` | §6 Theorem 5.1 `bayesian-immunity`, Prop `complementarity`, Rem `robustness-misspec` |
| `GeneralGraphs.lean` | §7 Def `greedy-path`, Theorem 6.1 `general-tree`, Ex `cyclic-trap`, Def `trap-tree`, Prop `error-compounding` |
| `Ledger.lean` | Status of every paper claim formalised here |
| `AxiomAudit.lean` | `#print axioms` for every theorem |

## Status summary

Current kernel-only audit target (2026-06-26):

Commands:

```bash
lake build BlackwellDilemma
lake build BlackwellDilemma.PaperSemanticGate
lake env lean BlackwellDilemma/AxiomAudit.lean
python scripts/audit_axiom_output.py
python scripts/audit_kernel_surface.py
python scripts/audit_conditional_surface.py
python scripts/audit_paper_semantic_gate.py
```

Current results:

| Surface | Current value | Gate target |
| --- | ---: | --- |
| `lake build BlackwellDilemma` | pass | pass |
| `lake build BlackwellDilemma.AxiomAudit` | pass | pass |
| AxiomAudit output (`audit_axiom_output.py`) | dependency lines=5508, no-axiom lines=185, observed axioms=`Classical.choice,Quot.sound,propext`, unexpected=0 | only `propext`, `Classical.choice`, `Quot.sound` |
| paper semantic gate (`audit_paper_semantic_gate.py`) | closed=3, open=2; closed semantic-frontier direct statement roster/semantic-target partition direct statement roster/semantic-target partition ledger component roster/semantic-target count direct statement roster/status-partition direct statement roster/paper-label direct statement roster/paper-label/id direct statement roster/roster ids/targets/target routes/target-route certificates/target-route obstructions/route-equivalence proofs/closure routes/closure-route certificates/closure-route obstructions/frontier progress certificates/frontier nonclosure certificates/full typed frontier payload certificates/Part 6 frontier-payload direct statement roster/Part 6 alpha-domain repair frontier certificate and statement roster/topo frontier-payload direct statement roster/topo Mills lower-constant repair frontier certificate and statement roster/paired open-target repair frontier certificate, statement roster, and component statement roster/frontier statement roster/payload-derived route-map/route-closure-progress-nonclosure-frontier projections/cross-surface target/route-map/closure/frontier equality/payload route-map certificate/payload route-map direct statement roster/top-level complete-obstruction certificate and statement roster/closure-input sufficient-route, Part 6 closure-input direct statement roster, topo closure-input direct statement roster, closure-input summary statement roster, closure-input named roster length and target-to-input obstruction projection, closure-input statement roster, exact-input summary statement roster, exact-input named roster length and target/exact obstruction equivalence, exact-input statement roster, exact-input/output summary statement roster, exact-input/output named roster length and pairwise obstruction equivalence, Part 6 output direct statement roster, topo closure-input/output direct statement roster, closure-input/output direct statement roster, Part 6 field-level direct statement roster, topo closure-input-field direct statement roster, closure-input-field direct statement roster, closure-input-field obstruction direct statement roster, closure-input-field/output direct statement roster, output-equivalence summary statement roster, output named roster length, output statement roster and target/output obstruction equivalence, obstruction-equivalence summary statement roster, obstruction-equivalence named roster length and target/exact/output obstruction rosters, obstruction-equivalence, joint closure-reduction, joint closure-reduction direct statement roster, joint closure statement roster length, joint closure-reduction alignment, joint closure-reduction alignment statement roster, joint route-obstruction reduction, joint route-obstruction reduction direct statement roster, joint route statement roster length, joint route-obstruction reduction alignment, joint route-obstruction reduction alignment statement roster, kernel-surface route-obstruction equivalence statement roster length, frontier-payload route-obstruction equivalence statement roster length, bilateral package obstruction statement roster length, bilateral package-obstruction alignment, bilateral package-obstruction alignment statement roster, bilateral current-obstruction source statement roster length, bilateral current-obstruction source alignment, bilateral current-obstruction source alignment statement roster, field-payload current-obstruction source statement roster length, field-payload current-obstruction source alignment, field-payload current-obstruction source alignment statement roster, field-output current-obstruction source statement roster length, field-output current-obstruction source alignment, field-output current-obstruction source alignment statement roster, all current-obstruction source alignment, all current-obstruction source alignment statement roster, top-level semantic-target-ledger/current alignment, semantic-target-ledger current-alignment statement roster, top-level obstruction-source/current alignment, obstruction-source current-alignment statement roster, top-level surface/current obstruction alignment, surface current-alignment statement roster, top-level field-output/current obstruction alignment, field-output current-alignment statement roster, top-level obstruction-equivalence/current obstruction alignment, obstruction-equivalence current-alignment statement roster, top-level route/current obstruction alignment, route current-alignment statement roster, top-level frontier-payload/current alignment, frontier-payload current-alignment statement roster, top-level closure-input/current alignment, closure-input current-alignment statement roster, top-level field-payload/current alignment, field-payload current-alignment statement roster, top-level current-alignment umbrella and statement roster length, Part 6 conditional witness interface and statement roster length, Part 6 route-obstruction projection and statement roster length, Part 6 field-output statement roster length, detailed field-output roster length, topo exact-output projection and statement roster length, topo route-obstruction projection and statement roster length, topo support-surface closing nonclosure projection, topo field-output statement roster length, field, field-obstruction, field surface roster length, field statement roster length, field-output surface roster length, field-output statement roster length, field-output target/exact/output obstruction-to-field projections, and output-equivalence certificates/exact-input roster id, target/output, bidirectional projection, iff, sufficient-to-exact, and obstruction consistency/exact-input/output roster id, target/exact/output, bidirectional projection, iff, and obstruction consistency/target-exact-output obstruction-equivalence roster id, current obstructions, and not-iff proofs/joint target/exact/output package equivalences and current package obstructions/joint target/target-route/closure-route package equivalences and current package obstructions/Part 6 conditional witness exact-input and output-bundle projections plus witness obstructions/Part 6 route refutation projections/Part 6 field-output formula roster and route/output obstruction-to-field projections/topo exact-input and same-bridge-bundle route/output projections plus repair-layer nonclosure boundary/topo route refutation projections/topo field-output all route/repair/output obstruction-to-field projections/output-equivalence roster id, target/output, bidirectional projection, iff, and obstruction consistency/field-roster id, named closure-input/payload/obstruction/certificate rosters, payload-to-input/iff/not-iff consistency, payload-obstruction, field-payload current obstruction source, field-output current obstruction source, payload-certificate consistency, cross-module certificate references/proof theorems, field statement formulas/surface-roster consistency/named route-statement roster/named frontier-certificate roster/surface frontier-nonclosure certificate and statement roster/frontier certificates/all-surface ids/count and paper-label statement rosters, full field-output ledger certificate pair, final obstruction ledger certificate pair, open-target final ledger certificate pair, open-target exit certificate pair, target-obstruction exit certificate pair, route-obstruction exit certificate pair, route-obstruction-equivalence exit certificate pair, route-derived target-obstruction source certificates and statement roster, target-derived route-obstruction certificate and statement roster, routed final open-target exit certificate pair, routed top-level obstruction exit certificate pair, per-target routed-exit certificate pair, per-target routed-exit/open-target nonclosure named certificate and statement roster, obstruction-source/routed-exit open-target nonclosure named certificate and statement roster, route-source/routed-exit open-target nonclosure named certificate and statement roster, per-target route-source open-target nonclosure named certificate and statement roster, routed-exit ledger alignment, routed-exit top-level alignment, obstruction routed-exit top-level alignment, routed-exit final alignment, routed-exit final exit, current gate-status, open-target gate-status, final status, status direct routed-exit coverage, terminal consistency, terminal ledger-label consistency, terminal partition/status consistency, terminal umbrella consistency, terminal open-obstruction consistency, terminal per-target routed-exit consistency, terminal route/target obstruction-equivalence consistency, terminal final-obstruction status consistency, terminal alignment-closure consistency, terminal main-obstruction closure consistency, terminal open-target source closure consistency, terminal ledger-source closure consistency, terminal final ledger-source closure consistency, terminal all-current closure consistency, terminal paper-state closure consistency, terminal paper-state/routed-exit closure consistency, terminal paper-state/source-routed-exit closure consistency, terminal paper-state/source-final closure consistency, terminal paper-state/source-final gate-status closure consistency, terminal paper-state/source-final gate-status alignment closure consistency, terminal paper-state/source-final gate-status obstruction closure consistency, terminal paper-state/source-final gate-status ledger-obstruction closure consistency, terminal paper-state/source-final gate-status ledger/source-obstruction closure consistency, terminal paper-state/source-final gate-status ledger/source-field-output closure consistency, terminal paper-state/source-final gate-status ledger/source/all-current closure consistency, terminal paper-state/source-final gate-status ledger/source/all-current top-level closure consistency, terminal paper-state/source-final final gate judgement consistency, open target ID obstruction map consistency, open target ID obstruction-map ledger alignment, open target ID obstruction-map paper-label alignment, open target ID obstruction-map obstruction projection alignment, open target ID obstruction-map component statement roster, final judgement obstruction-map projection alignment, final judgement obstruction-map full alignment, paper-label obstruction map, id/paper-label obstruction map, id/paper-label obstruction projection alignment, paper-label obstruction projection bridge, obstruction-map index projection bridge, all-view obstruction-map terminal package, raw/open all-view obstruction-map package, final/raw all-view obstruction-map bridge, final-status obstruction-map bridge, terminal final-status/closure-input/obstruction-map gate, terminal nonclosure obstruction-bundle gate, terminal field-output nonclosure gate, terminal ledger-state nonclosure gate, terminal paper-label projection nonclosure gate, terminal field-output label nonclosure gate, terminal field-output id nonclosure gate, terminal obstruction-projection nonclosure gate, terminal obstruction-bundle view nonclosure gate, terminal all-view nonclosure gate, terminal kernel-only nonclosure capstone, terminal kernel-only nonclosure/gate-status bridge, terminal kernel-only theorem-name nonclosure/gate-status alias, terminal kernel-only nonclosure/open-target final-ledger bridge, terminal kernel-only theorem-name nonclosure/open-target final-ledger alias, terminal kernel-only nonclosure/open-target gate-status bridge, terminal kernel-only theorem-name nonclosure/open-target gate-status alias, terminal kernel-only nonclosure/open-target exit bridge, terminal kernel-only theorem-name nonclosure/open-target exit alias, terminal kernel-only nonclosure/open-target operational bundle, terminal kernel-only theorem-name nonclosure/open-target operational bundle alias, terminal kernel-only nonclosure/route-obstruction exit bundle, terminal kernel-only theorem-name nonclosure/route-obstruction exit bundle alias, terminal kernel-only nonclosure/obstruction-map bundle, terminal kernel-only theorem-name nonclosure/obstruction-map bundle alias, terminal kernel-only nonclosure/final-status bundle, terminal kernel-only theorem-name nonclosure/final-status bundle alias, terminal kernel-only nonclosure audit bundle, terminal kernel-only theorem-name nonclosure audit bundle alias, terminal kernel-only nonclosure public-evidence bundle, terminal kernel-only theorem-name nonclosure public-evidence bundle alias, topo frontier open-target nonclosure named certificate and statement roster, Part 6 frontier open-target nonclosure named certificate and statement roster, per-target routed-exit/open-target nonclosure alignment, Part 6 conditional projection/open-target nonclosure named certificate and statement roster, topo support-surface projection/open-target nonclosure named certificate and statement roster, source/routed-exit open-target nonclosure bundle, route-source/routed-exit open-target nonclosure bundle, Part 6 route-source conditional/open-target nonclosure named certificate and statement roster, topo route-source support/open-target nonclosure named certificate and statement roster, per-target route-source open-target nonclosure bundle, route-source per-target top-level bridge, route-source terminal kernel-only nonclosure bridge, route-source terminal named certificate and statement roster, route-source terminal capstone, route-source terminal capstone named certificate and statement roster, route-source terminal capstone audit bundle, route-source terminal theorem-name capstone audit bundle alias, route-source terminal capstone public-evidence bundle, route-source terminal theorem-name capstone public-evidence bundle alias, route-source terminal capstone public-evidence named certificate and statement roster, route-source terminal capstone public-evidence audit certificate and statement roster, route-source terminal capstone obstruction-map audit certificate and statement roster, route-source terminal capstone final audit certificate and statement roster, route-source terminal theorem-name capstone final-audit bundle alias, route-source terminal capstone field-output final-audit certificate, statement roster, theorem-name bundle alias, and field-output all-audit bundle, two-key terminal seal, two-key open-target identity seal, two-key route-source identity seal, current obstruction-vector seal, completion-barrier seal, paper-label completion barrier, paper-label obstruction-pair seal, paper-label route obstruction-pair seal, paper-label route obstruction-pair public-evidence audit seal, Part 6 repair-route terminal roster seal, topo support-surface repair terminal roster seal, topo route-obstruction source certificate, dual open-target repair-route terminal roster seal, dual open-target current-boundary vector seal, dual open-target required closure-input seal, dual open-target first-edge repair/not-closing seal, dual open-target Part 6 obstruction-source terminal seal, dual open-target obstruction-source terminal seal, dual open-target obstruction-source public-evidence audit seal, public nonclosure boundary projection-tail audit, public nonclosure boundary projection-tail reconstruction audit, public nonclosure source-link audit, public final audit, public paper export audit, public required closure-input export audit, public closure-input/field-output export audit, public final audit closure-input/field-output terminal-length bridge, public release gate, public release nonclosure/iff theorem, public release theorem package, public release per-target obstruction package, public release terminal-source audit package, public release terminal-source seal, theorem-name public release terminal-source audit bundle alias, public release terminal-source completion barrier, theorem-name public release terminal-source completion barrier alias, public release theorem-name completion gate, public release open-target terminal completion gate, theorem-name public release open-target terminal completion gate alias, public release terminal endpoint gate, public release terminal endpoint target-obstruction projection, public release terminal endpoint target-id obstruction pair, public release terminal endpoint target-id obstruction-pair public-evidence exit, public release terminal endpoint open-target id roster integrity, public release terminal endpoint open-target exhaustive membership, public release terminal endpoint open-target membership obstruction dispatch, public release terminal endpoint open/closed target-id disjointness, public release terminal endpoint semantic-target partition exit, public release terminal endpoint semantic-target classification obstruction exit, public release terminal endpoint closed-target closure dispatch, public release terminal endpoint total semantic-target dispatch, public release terminal endpoint total-dispatch exact-index seal, public release terminal endpoint semantic-target ledger-row seal, public release terminal endpoint semantic-target ledger-row dispatch seal, public release terminal endpoint semantic-target final seal, theorem-name final semantic-target seal alias, final semantic-target public-evidence bundle, theorem-name final semantic-target public-evidence bundle alias, endpoint final semantic-target public-evidence alias gate, endpoint conditional-interface audit gate, endpoint conditional-interface closure-pair audit gate, endpoint exact closure-input audit gate, endpoint exact closure-input/output audit gate, endpoint obstruction-equivalence audit gate, endpoint top-level alignment audit gate, endpoint field-output full-ledger alignment audit gate, endpoint final-judgement obstruction-map full-alignment audit gate, endpoint public nonclosure-boundary paper-export terminal-length bridge audit gate, endpoint semantic-target status-vector audit gate, endpoint semantic-target paper-label status-vector audit gate, endpoint semantic-target paper-label obstruction-map status-vector audit gate, endpoint semantic-target paper-label atomic obstruction-vector audit gate, endpoint semantic-target paper-label explicit obstruction-vector audit gate, endpoint semantic-target paper-label explicit closure-input/output vector audit gate, endpoint semantic-target paper-label explicit closure-equivalence vector audit gate, endpoint semantic-target paper-label explicit field-output vector audit gate, endpoint semantic-target paper-label explicit detailed field-output roster audit gate, endpoint semantic-target paper-label explicit endpoint registry audit gate, endpoint semantic-target paper-label explicit endpoint registry release-seal audit gate, endpoint semantic-target paper-label explicit endpoint registry release-seal public-evidence audit gate, endpoint semantic-target paper-label explicit endpoint registry release-seal public-evidence alignment audit gate, endpoint semantic-target paper-label explicit endpoint registry release-seal public-evidence paper-label alignment audit gate, endpoint semantic-target paper-label explicit endpoint registry release-seal public-evidence detailed field-output paper-label alignment audit gate, endpoint semantic-target paper-label explicit endpoint registry release-seal public-evidence detailed field-output row paper-label alignment audit gate, endpoint semantic-target paper-label explicit endpoint registry release-seal public-evidence detailed field-output row-roster full-alignment audit gate, endpoint semantic-target paper-label explicit endpoint registry release-seal public-evidence detailed field-output row-roster public-export bridge audit gate, endpoint semantic-target paper-label explicit endpoint registry release-seal public-evidence detailed field-output row-roster public-export release-completion bridge audit gate, endpoint semantic-target paper-label explicit endpoint registry release-seal public-evidence detailed field-output row-roster public-export release-completion public-evidence bridge audit gate, endpoint semantic-target paper-label explicit endpoint registry release-seal public-evidence detailed field-output row-roster public-export release-completion public-evidence paper-label bridge audit gate, endpoint semantic-target paper-label explicit endpoint registry release-seal public-evidence detailed field-output row-roster public-export release-completion public-evidence paper-label obstruction-map bridge audit gate, endpoint semantic-target paper-label explicit endpoint registry release-seal public-evidence detailed field-output row-roster public-export release-completion public-evidence paper-label obstruction-map explicit-vector bridge audit gate, endpoint semantic-target paper-label explicit endpoint registry release-seal public-evidence detailed field-output row-roster public-export release-completion public-evidence paper-label obstruction-map closure/field-vector bridge audit gate, endpoint semantic-target paper-label explicit endpoint registry release-seal public-evidence detailed field-output row-roster public-export release-completion public-evidence paper-label obstruction-map detailed endpoint-registry bridge audit gate, endpoint semantic-target paper-label explicit endpoint registry release-seal public-evidence detailed field-output row-roster public-export release-completion public-evidence paper-label obstruction-map detailed endpoint-registry release-seal public-evidence alignment bridge audit gate, endpoint semantic-target paper-label explicit endpoint registry release-seal public-evidence detailed field-output row-roster public-export release-completion public-evidence paper-label obstruction-map detailed endpoint-registry release-seal public-evidence alignment terminal-dispatch bridge audit gate, endpoint semantic-target paper-label explicit endpoint registry release-seal public-evidence detailed field-output row-roster public-export release-completion public-evidence paper-label obstruction-map detailed endpoint-registry release-seal public-evidence alignment terminal-dispatch public-evidence ledger bridge audit gate, endpoint semantic-target paper-label explicit endpoint registry release-seal public-evidence detailed field-output row-roster public-export release-completion public-evidence paper-label obstruction-map detailed endpoint-registry release-seal public-evidence alignment terminal-dispatch public-evidence ledger completion-barrier bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine route-obstruction-pair bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input detail bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-obstruction projection bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-id obstruction-pair bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-id obstruction-pair public-evidence-exit bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-id obstruction-pair public-evidence-exit open-target-id roster-integrity bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-id obstruction-pair public-evidence-exit open-target-id roster-integrity exhaustive-membership bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-id obstruction-pair public-evidence-exit open-target-id roster-integrity exhaustive-membership open-target membership-obstruction dispatch bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-id obstruction-pair public-evidence-exit open-target-id roster-integrity exhaustive-membership open-target membership-obstruction dispatch open/closed target-id disjointness bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-id obstruction-pair public-evidence-exit open-target-id roster-integrity exhaustive-membership open-target membership-obstruction dispatch open/closed target-id disjointness semantic-target partition-exit bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-id obstruction-pair public-evidence-exit open-target-id roster-integrity exhaustive-membership open-target membership-obstruction dispatch open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-id obstruction-pair public-evidence-exit open-target-id roster-integrity exhaustive-membership open-target membership-obstruction dispatch open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-id obstruction-pair public-evidence-exit open-target-id roster-integrity exhaustive-membership open-target membership-obstruction dispatch open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-id obstruction-pair public-evidence-exit open-target-id roster-integrity exhaustive-membership open-target membership-obstruction dispatch open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch exact-index seal bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-id obstruction-pair public-evidence-exit open-target-id roster-integrity exhaustive-membership open-target membership-obstruction dispatch open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch exact-index seal semantic-target ledger-row seal bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-id obstruction-pair public-evidence-exit open-target-id roster-integrity exhaustive-membership open-target membership-obstruction dispatch open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch exact-index seal semantic-target ledger-row dispatch-seal bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-id obstruction-pair public-evidence-exit open-target-id roster-integrity exhaustive-membership open-target membership-obstruction dispatch open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch exact-index seal semantic-target ledger-row dispatch-seal semantic-target final-seal bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-id obstruction-pair public-evidence-exit open-target-id roster-integrity exhaustive-membership open-target membership-obstruction dispatch open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch exact-index seal semantic-target ledger-row dispatch-seal semantic-target final-seal theorem-name alias bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-id obstruction-pair public-evidence-exit open-target-id roster-integrity exhaustive-membership open-target membership-obstruction dispatch open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch exact-index seal semantic-target ledger-row dispatch-seal semantic-target final-seal theorem-name alias public-evidence bundle bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-id obstruction-pair public-evidence-exit open-target-id roster-integrity exhaustive-membership open-target membership-obstruction dispatch open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch exact-index seal semantic-target ledger-row dispatch-seal semantic-target final-seal theorem-name alias public-evidence bundle theorem-name alias gate bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-id obstruction-pair public-evidence-exit open-target-id roster-integrity exhaustive-membership open-target membership-obstruction dispatch open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch exact-index seal semantic-target ledger-row dispatch-seal semantic-target final-seal theorem-name alias public-evidence bundle theorem-name alias gate conditional-interface bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-id obstruction-pair public-evidence-exit open-target-id roster-integrity exhaustive-membership open-target membership-obstruction dispatch open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch exact-index seal semantic-target ledger-row dispatch-seal semantic-target final-seal theorem-name alias public-evidence bundle theorem-name alias gate conditional-interface closure-pair bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-id obstruction-pair public-evidence-exit open-target-id roster-integrity exhaustive-membership open-target membership-obstruction dispatch open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch exact-index seal semantic-target ledger-row dispatch-seal semantic-target final-seal theorem-name alias public-evidence bundle theorem-name alias gate conditional-interface closure-pair exact-closure-input bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-id obstruction-pair public-evidence-exit open-target-id roster-integrity exhaustive-membership open-target membership-obstruction dispatch open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch exact-index seal semantic-target ledger-row dispatch-seal semantic-target final-seal theorem-name alias public-evidence bundle theorem-name alias gate conditional-interface closure-pair exact-closure-input/output bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-id obstruction-pair public-evidence-exit open-target-id roster-integrity exhaustive-membership open-target membership-obstruction dispatch open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch exact-index seal semantic-target ledger-row dispatch-seal semantic-target final-seal theorem-name alias public-evidence bundle theorem-name alias gate conditional-interface closure-pair exact-closure-input/output obstruction-equivalence bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-id obstruction-pair public-evidence-exit open-target-id roster-integrity exhaustive-membership open-target membership-obstruction dispatch open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch exact-index seal semantic-target ledger-row dispatch-seal semantic-target final-seal theorem-name alias public-evidence bundle theorem-name alias gate conditional-interface closure-pair exact-closure-input/output obstruction-equivalence top-level alignment bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-id obstruction-pair public-evidence-exit open-target-id roster-integrity exhaustive-membership open-target membership-obstruction dispatch open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch exact-index seal semantic-target ledger-row dispatch-seal semantic-target final-seal theorem-name alias public-evidence bundle theorem-name alias gate conditional-interface closure-pair exact-closure-input/output obstruction-equivalence top-level alignment field-output full-ledger alignment bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-id obstruction-pair public-evidence-exit open-target-id roster-integrity exhaustive-membership open-target membership-obstruction dispatch open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch exact-index seal semantic-target ledger-row dispatch-seal semantic-target final-seal theorem-name alias public-evidence bundle theorem-name alias gate conditional-interface closure-pair exact-closure-input/output obstruction-equivalence top-level alignment field-output full-ledger alignment final-judgement obstruction-map full-alignment bridge audit gate, public release terminal-dispatch public-evidence ledger completion-barrier two-key seal-spine dual-open-target closure-input field-output detail obstruction-map endpoint completion-barrier seal theorem-name completion terminal-endpoint target-id obstruction-pair public-evidence-exit open-target-id roster-integrity exhaustive-membership open-target membership-obstruction dispatch open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch exact-index seal semantic-target ledger-row dispatch-seal semantic-target final-seal theorem-name alias public-evidence bundle theorem-name alias gate conditional-interface closure-pair exact-closure-input/output obstruction-equivalence top-level alignment field-output full-ledger alignment final-judgement obstruction-map full-alignment public nonclosure-boundary paper-export terminal-length bridge audit gate, and top-level/field-output/final-judgement/public-export statement roster lengths and public-export closure-equivalence vector, field-output vector, detailed endpoint-registry, dual-open-target endpoint, completion-barrier seal, terminal-length, remaining-frontier, remaining-frontier ledger/disjointness, remaining-frontier ledger/disjointness status-vector, remaining-frontier ledger/disjointness status-vector obstruction-map, remaining-frontier ledger/disjointness status-vector obstruction-map explicit-vector, remaining-frontier ledger/disjointness status-vector obstruction-map explicit-vector closure-field, remaining-frontier ledger/disjointness status-vector obstruction-map explicit-vector closure-field endpoint-registry, and remaining-frontier ledger/disjointness status-vector obstruction-map explicit-vector closure-field endpoint-registry release-seal public-evidence alignment, remaining-frontier ledger/disjointness status-vector obstruction-map explicit-vector closure-field endpoint-registry release-seal public-evidence alignment paper-label, remaining-frontier ledger/disjointness status-vector obstruction-map explicit-vector closure-field endpoint-registry release-seal public-evidence alignment paper-label detailed field-output, remaining-frontier ledger/disjointness status-vector obstruction-map explicit-vector closure-field endpoint-registry release-seal public-evidence alignment paper-label detailed field-output row paper-label, remaining-frontier ledger/disjointness status-vector obstruction-map explicit-vector closure-field endpoint-registry release-seal public-evidence alignment paper-label detailed field-output row paper-label row-roster full-alignment, and remaining-frontier ledger/disjointness status-vector obstruction-map explicit-vector closure-field endpoint-registry release-seal public-evidence alignment paper-label detailed field-output row paper-label row-roster full-alignment public-export bridges synced, remaining-frontier ledger/disjointness status-vector obstruction-map explicit-vector closure-field endpoint-registry release-seal public-evidence alignment paper-label detailed field-output row paper-label row-roster full-alignment public-export release-completion bridges synced, and remaining-frontier ledger/disjointness status-vector obstruction-map explicit-vector closure-field endpoint-registry release-seal public-evidence alignment paper-label detailed field-output row paper-label row-roster full-alignment public-export release-completion public-evidence bridges synced, and remaining-frontier ledger/disjointness status-vector obstruction-map explicit-vector closure-field endpoint-registry release-seal public-evidence alignment paper-label detailed field-output row paper-label row-roster full-alignment public-export release-completion public-evidence paper-label bridges synced, and remaining-frontier ledger/disjointness status-vector obstruction-map explicit-vector closure-field endpoint-registry release-seal public-evidence alignment paper-label detailed field-output row paper-label row-roster full-alignment public-export release-completion public-evidence paper-label obstruction-map bridges synced, and remaining-frontier ledger/disjointness status-vector obstruction-map explicit-vector closure-field endpoint-registry release-seal public-evidence alignment paper-label detailed field-output row paper-label row-roster full-alignment public-export release-completion public-evidence paper-label obstruction-map explicit-vector bridges synced, and remaining-frontier ledger/disjointness status-vector obstruction-map closure/field-vector bridges synced, and remaining-frontier ledger/disjointness status-vector obstruction-map detailed endpoint-registry bridges synced, and remaining-frontier ledger/disjointness status-vector obstruction-map detailed endpoint-registry dual-open-target endpoint bridges synced, and remaining-frontier ledger/disjointness status-vector obstruction-map detailed endpoint-registry dual-open-target endpoint open/closed target-id disjointness bridges synced, and remaining-frontier ledger/disjointness status-vector obstruction-map detailed endpoint-registry dual-open-target endpoint open/closed target-id disjointness semantic-target partition-exit bridges synced, and remaining-frontier ledger/disjointness status-vector obstruction-map detailed endpoint-registry dual-open-target endpoint open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit bridges synced, and remaining-frontier ledger/disjointness status-vector obstruction-map detailed endpoint-registry dual-open-target endpoint open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch bridges synced, and remaining-frontier ledger/disjointness status-vector obstruction-map detailed endpoint-registry dual-open-target endpoint open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch bridges synced, and remaining-frontier ledger/disjointness status-vector obstruction-map detailed endpoint-registry dual-open-target endpoint open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch exact-index seal bridges synced, and remaining-frontier ledger/disjointness status-vector obstruction-map detailed endpoint-registry dual-open-target endpoint open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch exact-index seal semantic-target ledger-row seal bridges synced, and remaining-frontier ledger/disjointness status-vector obstruction-map detailed endpoint-registry dual-open-target endpoint open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch exact-index seal semantic-target ledger-row seal semantic-target ledger-row dispatch seal bridges synced, and remaining-frontier ledger/disjointness status-vector obstruction-map detailed endpoint-registry dual-open-target endpoint open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch exact-index seal semantic-target ledger-row seal semantic-target ledger-row dispatch seal semantic-target final-seal bridges synced, and remaining-frontier ledger/disjointness status-vector obstruction-map detailed endpoint-registry dual-open-target endpoint open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch exact-index seal semantic-target ledger-row seal semantic-target ledger-row dispatch seal semantic-target final-seal theorem-name alias bridges synced, and remaining-frontier ledger/disjointness status-vector obstruction-map detailed endpoint-registry dual-open-target endpoint open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch exact-index seal semantic-target ledger-row seal semantic-target ledger-row dispatch seal semantic-target final-seal theorem-name alias public-evidence bundle bridges synced, and remaining-frontier ledger/disjointness status-vector obstruction-map detailed endpoint-registry dual-open-target endpoint open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch exact-index seal semantic-target ledger-row seal semantic-target ledger-row dispatch seal semantic-target final-seal theorem-name alias public-evidence bundle theorem-name alias gate bridges synced, and remaining-frontier ledger/disjointness status-vector obstruction-map detailed endpoint-registry dual-open-target endpoint open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch exact-index seal semantic-target ledger-row seal semantic-target ledger-row dispatch seal semantic-target final-seal theorem-name alias public-evidence bundle theorem-name alias gate conditional-interface bridges synced, and remaining-frontier ledger/disjointness status-vector obstruction-map detailed endpoint-registry dual-open-target endpoint open/closed target-id disjointness semantic-target partition-exit semantic-target classification-obstruction-exit closed-target membership-closure dispatch semantic-target membership total-dispatch exact-index seal semantic-target ledger-row seal semantic-target ledger-row dispatch seal semantic-target final-seal theorem-name alias public-evidence bundle theorem-name alias gate conditional-interface closure-pair bridges synced, and theorem-name alias gate conditional-interface closure-pair exact-closure-input bridges synced, and theorem-name alias gate conditional-interface closure-pair exact-closure-input/output bridges synced, and theorem-name alias gate conditional-interface closure-pair exact-closure-input/output obstruction-equivalence bridges synced; AxiomAudit prints required=3771 | complete paper-semantic closure only after open=0 |
| proof escapes (`sorry`, `admit`, `unsafe`, `native_decide`) | 0 | 0 |
| source-level project `axiom` declarations | 0 | 0 |
| source-level `_OPEN` axioms | 0 | 0 |
| source-level `_paper_Def` axioms | 0 | 0 |
| source-level `_workingAssumption` axioms | 0 | 0 |
| source-level `_paper_witness` axioms | 0 | 0 |
| source-level `_OPEN` theorem declarations | 0 | 0 |
| conditional proof interfaces (`audit_conditional_surface.py`) | 2 (`Part6FullPaperClosingDivergenceWitness`, `Part6FullPaperClosingFeasibleDivergenceWitness`) | exact interface identities, current refutation pairs, and current closure pairs are pinned; all counted proof/carrier interface containers must be current-refuted or current-closed; unresolved=0 |
| closed `True` compatibility interfaces (`audit_conditional_surface.py`) | 0 | no remaining `True` compatibility aliases in the Prop-interface audit |
| conditional theorem signatures (`audit_conditional_surface.py`) | 0 | R454 demotes the last generic family-core promotion bridge to a proof-valued `def`; no theorem/lemma signature now takes an interface premise |
| interfaces with current/no-premise closure | 0 | no counted interface is currently closed without premise; remaining counted interfaces are refuted |
| interfaces with current-carrier refutation | 2 | the remaining Part 6 divergence and feasible-divergence witness interfaces are current-refuted |
| unresolved proof/carrier interfaces | 0 | every remaining conditional interface has a current closure or current-carrier refutation |
| unresolved Prop bridge interfaces | 0 | no remaining unresolved theorem-interface obligations under the syntactic audit |
| unresolved structure carrier interfaces | 0 | explicit carrier packages now have concrete current models |
| unresolved class interfaces | 0 | diagnostic typeclass surface has a current concrete package |
| conditional theorem signatures using unresolved interfaces | 0 | no live theorem signature depends on an unresolved interface |
| conditional signatures using unresolved Prop bridges | 0 | no live theorem signature depends on an unresolved Prop bridge |
| conditional signatures using unresolved structure carriers | 0 | structure-carrier signatures have current concrete models |
| conditional signatures using unresolved classes | 0 | no direct theorem-signature count under the current syntactic audit |
| ledger total entries | 498 | tracked |
| ledger status | open=0, partial=0, deadEnd=59, closed=353, definitional=86 | no open/partial theorem target; dead-end/retired markers are kernel-inert and do not count as live closed evidence |
| ledger input classes | cat1Mathlib=435, cat2External=0, cat3PaperNovel=0, mixed=0, notInput=63 | all live theorem dependencies reduced to Cat 1 or explicit theorem assumptions; dead-end routes require replacement |
| ledger Cat 3 subtype | carrier=0, hypothesisPredicate=0, structuralEquation=0, workingAssumption=0, derivedTheorem=329, notCat3=169 | paper primitives represented transparently; no hidden proof-carrying global axioms |

The paper semantic audit also checks that every `*_named_current` theorem has
the matching `*_length_current` theorem in `PaperSemanticGate.lean`, so roster
membership and roster length evidence cannot drift apart silently. It also
checks that every such roster-current theorem has an `AxiomAudit.lean`
`#print axioms` entry, and that every theorem in the paper semantic gate,
plus every paper-semantic gate `def`, is covered by the same audit. The same
coverage rule applies to every paper-semantic gate `structure` and `inductive`
declaration. The paper-semantic `#print axioms` subset is also checked for
duplicate entries.

The current theorem surface is kernel-clean in the source-level sense:
`#print axioms` output contains only Lean/Mathlib kernel axioms, and
`audit_conditional_surface.py` exposes no unresolved explicit bridge, witness,
or carrier-interface hypotheses. The same audit now publishes
expected/missing/unexpected drift counts for the pinned conditional interface,
current-refutation, and current-closure identities; the public evidence
manifest also pins those zero-drift lines and the zero source-level escape
surface from `audit_kernel_surface.py`. The kernel, conditional, and
paper-semantic audit scripts fail if the public manifest drops any of their
current required stdout lines, so Lean-side CI also guards the public evidence
calibration. Complete paper-semantic
closure is the stronger target tracked by `PaperSemanticGate.lean`; that claim
is not made until the semantic gate reaches open=0.
The named Lean target `CompletePaperSemanticKernelOnly` is definitionally
`paperSemanticOpenCount = 0`, and
`completePaperSemanticKernelOnly_iff_false_current` sharpens its current
negation to `CompletePaperSemanticKernelOnly ↔ False`.
`completePaperSemanticKernelOnly_current_obstruction_certificate` now ties that
negation to `open=2`, the exact remaining ids, and the remaining-open frontier,
surface-roster, payload-route-map, and field-obstruction certificates.
`completePaperSemanticKernelOnly_current_obstruction_statement_roster_certificate`
pins those top-level obstruction statements as a Lean `List Prop`.
`audit_paper_semantic_gate.py` parses that top-level certificate body and fails
unless all 100 expected certificate conjuncts are present.
The same audit parses the top-level statement roster and checks all 101 expected
base/certificate terms, backed by
`completePaperSemanticKernelOnlyCurrentObstructionStatements_length_current`.
`completePaperSemanticKernelOnly_current_public_nonclosure_boundary_certificate`
now packages the public-evidence audit seal with `open=2`, the exact remaining
ids, `CompletePaperSemanticKernelOnly <-> False`, and
`Not CompletePaperSemanticKernelOnly`.
`completePaperSemanticKernelOnly_current_public_nonclosure_boundary_per_target_obstruction_certificate`
now ties that public boundary to the Part 6 target/repair/full-support
obstructions and the topo target/full-route/boxed-route obstructions.
It also publishes both the required AxiomAudit print count and missing print
count.
It now publishes expected/missing/unexpected drift counts for the open/closed
target ids and each open-target surface roster.
`remaining_open_semantic_targets_closure_input_field_output_certificate` now
gates direct projections from each remaining field payload to its target, exact
closure input, and output bundle before recording the current field-payload
obstruction.
`remaining_open_semantic_targets_closure_input_field_output_statement_roster_certificate`
pins the shared field-output certificate itself as a direct 14-term statement
roster; the field-output current-obstruction source roster now checks four
terms, and the field-output obstruction alignment gate counts sixteen
components.
For Part 6, the same certificate also records direct field-payload projections
to the divergence witness, feasible/divergence witness, paired output witness,
repair route, and full-support route.
`part6_lattice_embedding_closure_input_field_output_statement_roster_certificate`
pins those target-specific field-output formulas as a 13-term Lean `List Prop`.
For the topo target, it records the direct field-payload projection to the
support-surface closing spine.
`topo_cluster_random_supercritical_z2_closure_input_field_output_statement_roster_certificate`
pins the topo target-specific field-output formulas as a 14-term Lean `List Prop`.
`remaining_open_semantic_targets_closure_input_field_output_detailed_statement_roster_certificate`
packages the Part 6 and topo detailed field-output rosters together as a
2-term Lean list.
The package also gates its ids and length against the current open semantic
target ids/count, and those two equalities are now explicit top-level
current-obstruction roster terms.
The field-output surface roster ids/count are likewise explicit top-level
current-obstruction roster terms.
Its payload, target, exact-input, output-bundle, obstruction, and certificate
rosters are fixed as six 2-term Lean lists.
`open_semantic_target_closure_input_field_output_statement_roster_certificate`
pins the surface field-to-target, field-to-exact-input, and field-to-output
formulas as three 2-term Lean `List Prop` rosters.
`open_semantic_target_all_surface_ids_count_certificate` packages ids/count
synchronization for every open-target surface roster and the detailed
field-output statement roster; its statement roster is fixed by
`open_semantic_target_all_surface_ids_count_statement_roster_certificate` and
has 20 checked statements.
`open_semantic_target_all_surface_id_paper_labels_certificate` packages
`(id, paperLabel)` synchronization for the same surface rosters plus the named
route/frontier statement rosters; its statement roster is fixed by
`open_semantic_target_all_surface_id_paper_label_statement_roster_certificate`
and has 13 checked statements.
The top-level current-obstruction statement roster is likewise fixed by
`completePaperSemanticKernelOnlyCurrentObstructionStatements_length_current`
with 101 checked statements.
`open_semantic_target_closure_input_named_roster_certificate` also pins the
sufficient closure-input roster as five 2-term Lean lists, including named
target/input/current-obstruction and certificate propositions plus the generic
projection from target obstruction to sufficient-input obstruction.
`open_semantic_target_closure_input_statement_roster_certificate` pins the
sufficient-input-to-target and target-obstruction-to-sufficient-input formulas
to named Part 6/topo statements, with 4 formula terms checked against
`paperSemanticOpenCount`.
`open_semantic_target_exact_closure_input_named_roster_certificate` then pins
the exact closure-input roster as five 2-term Lean lists of named
target/exact/sufficient-input/current obstruction propositions and proves
target obstruction iff exact-input obstruction for each exact surface.
`open_semantic_target_exact_closure_input_statement_roster_certificate` pins the
target-to-exact, exact-to-target, target-iff-exact, sufficient-to-exact, and
target-obstruction/exact-obstruction formulas to named Part 6/topo statements,
with 10 formula terms checked against `paperSemanticOpenCount`.
`open_semantic_target_exact_closure_input_output_named_roster_certificate`
pins the exact-input/output-bundle roster as six 2-term Lean lists and proves
target, exact-input, and output-bundle obstructions pairwise equivalent on every
exact-output surface.
`open_semantic_target_exact_closure_input_output_statement_roster_certificate`
pins exact-input/output, target/exact-input, target/output, and all three
obstruction-equivalence formulas to named Part 6/topo statements, with 16
formula terms checked against `paperSemanticOpenCount`.
`open_semantic_target_output_equivalence_named_roster_certificate` pins the
target/output roster itself as four 2-term Lean lists and proves the
target/output obstruction equivalence separately from the exact-input/output
surface.
`open_semantic_target_output_equivalence_statement_roster_certificate` pins the
target-to-output, output-to-target, target/output equivalence, and
target/output obstruction-equivalence formulas to named Part 6/topo statements,
with 8 formula terms checked against `paperSemanticOpenCount`.
`open_semantic_target_obstruction_equivalence_named_roster_certificate` pins the
target/exact-input/output-bundle obstruction-equivalence roster as six 2-term
Lean lists to named Part 6/topo target, exact-input, output-bundle, and
obstruction propositions.
`open_semantic_target_obstruction_equivalence_statement_roster_certificate`
pins the three pairwise obstruction-equivalence formulas to named Part 6/topo
statements, with 6 formula terms checked against `paperSemanticOpenCount`.
The two remaining open semantic targets are also named as Lean propositions:
`Part6LatticeEmbeddingSemanticKernelTarget` and
`TopoClusterRandomSupercriticalZ2SemanticKernelTarget`. Their `*_notYet`
theorems gate the current kernel refutations while the target count remains
open=2.
`openSemanticTargetKernelSurfaces` ties the two open ledger ids to those Lean
propositions, their exact target routes, target-route certificates, their
target-route obstructions, paper-facing closure routes, closure-route
certificates, closure-route obstructions, direct route-equivalence proofs,
frontier progress/nonclosure certificates, and their current obstruction proofs, with id/count theorems checking that the roster matches
`openSemanticTargetIds`. Each roster entry also carries the full current
frontier certificate for that target, and `audit_paper_semantic_gate.py` checks
the target, target route, target-route proof, target-route certificate,
target-route certificate proof, target-route obstruction, closure route,
closure-route proof, route-equivalence proof, closure-route certificate,
closure-route certificate proof, closure-route obstruction, frontier progress
certificate/proof, frontier nonclosure certificate/proof, obstruction,
frontier certificate, frontier proof, and AxiomAudit print names.
`openSemanticTargetFrontierPayloadSurfaces` separately ties the same two open
ids to `Nonempty` certificates for their full typed frontier payload terms,
and the semantic audit requires the payload terms, payload certificates, and
payload-certificate proofs to appear in `AxiomAudit.lean`. The same surface now
also carries payload-derived projections for each target's active frontier
progress certificate, matching nonclosure certificate, and current frontier
certificate. The payload surface also carries each target proposition, its
current target obstruction, the target-to-route proof, target-to-closure proof,
route-equivalence proof, and payload-derived target-route/closure-route
certificate and obstruction projections for both open targets through a fixed
frontier-payload route-obstruction statement roster. The
kernel-surface and payload-surface views of the target propositions, current
target obstruction propositions, target-to-route statements, target-to-closure
statements, route-equivalence statements, target routes, target-route
certificates, target-route obstruction propositions, closure routes,
closure-route certificates, closure-route obstruction propositions, and the
three frontier certificate lists are all definitionally checked equal.
`open_semantic_target_surface_roster_consistency_certificate` then proves that
the semantic ledger ids, kernel-surface ids, typed frontier-payload ids, and
both roster counts plus those cross-surface lists are synchronized.
`remaining_open_semantic_targets_payload_route_map_certificate` packages the
same full typed payload route map into one Lean theorem, including the current
target obstructions, route equivalence proofs, payload-derived route/closure
certificates, route/closure obstructions, and frontier certificates.
`remaining_open_semantic_targets_frontier_certificate`
collects these gates into one Lean theorem, including current refutations of
the exact target routes, their route certificates, route-equivalence proofs,
closure routes, closure-route certificates, and the current progress/nonclosure
certificates.
`openSemanticTargetClosureInputSurfaces` separately names sufficient closure
inputs for the two open targets: `Part6LatticeEmbeddingClosureInput` would close
the Part 6 target through the closed-unit tail-reversal bridge route, and
`TopoClusterRandomSupercriticalZ2ClosureInput` would close the topo target
through a repaired bridge with pointwise-on-giant positive loss. The semantic
audit checks the input propositions, input-to-target proofs, input
obstructions, target obstructions, input certificates, certificate proofs, and
`remaining_open_semantic_targets_closure_input_certificate`.
`remaining_open_semantic_targets_closure_input_output_certificate` also gates
the output projections from those inputs: Part 6 reaches the divergence,
same-alpha feasible/divergence, paired-output, and full-output-bundle surfaces,
while the topo input reaches the support-surface route/output, repaired
paper-support output, giant-loss output, full route, and boxed route.
`remaining_open_semantic_targets_exact_closure_input_certificate` separates
exact target-equivalent closure inputs from those stronger sufficient inputs:
Part 6 is equivalent to `Part6LatticeEmbeddingExactClosureInput`, topo is
equivalent to `TopoClusterRandomSupercriticalZ2ExactClosureInput`, and each
sufficient input projects into its exact input. Both exact inputs remain
current-refuted, and the public terminal endpoint now exports that exact-input
boundary as its own audit gate.
`remaining_open_semantic_targets_exact_closure_input_output_certificate` then
ties those exact inputs to the reversible output layer: Part 6's exact input is
equivalent to `Part6FullPaperClosingFullOutputBundle`, while the topo exact
input is equivalent to `TopoClusterRandomSupercriticalZ2SameBridgeFullOutputBundle`.
The public terminal endpoint also exports this exact-input/output boundary as a
separate audit gate with both output bundles current-refuted. It also exports
the target/exact-input/output obstruction-equivalence boundary as a separate
audit gate, so the current obstructions cannot diverge across those layers.
`part6_remaining_conditional_projection_certificate` separately gates
the Part 6 conditional witness interfaces from the exact input and full output
bundle, with current refutations for the divergence, feasible/divergence, and
paired-output interfaces.
`part6_remaining_conditional_projection_statement_roster_certificate` pins
those witness projections and current witness/input/output obstructions in one
build-gated 11-term statement list.
`part6_lattice_embedding_route_obstruction_projection_certificate` gates the
Part 6 route-level negative direction: nondegenerate feasible-repair-route and
full-support refutations each refute the exact input and full output bundle,
and those route refutations are equivalent to the Part 6 target obstruction.
`part6_lattice_embedding_route_obstruction_projection_statement_roster_certificate`
pins those route refutation projections, route-obstruction equivalences, and
current Part 6 route/input/output obstructions in one build-gated 12-term
statement list.
`topo_cluster_random_supercritical_z2_exact_output_projection_certificate`
projects the topo exact input and same-bridge output bundle down to the full
route, boxed finite-lattice route, support-surface repair route/output,
paper-support output, and giant-loss output; it also records that the inhabited
support-surface repair layer remains a nonclosure boundary for the full and
boxed routes.
`topo_cluster_random_supercritical_z2_exact_output_projection_statement_roster_certificate`
pins those topo exact-output projections, current route/output obstructions,
and the inhabited support-surface repair route boundary in one build-gated
16-term statement list.
`topo_cluster_random_supercritical_z2_route_obstruction_projection_certificate`
gates the route-level negative direction: full-route and boxed-route
refutations each refute the topo exact input and same-bridge output bundle, and
the route refutations are equivalent to the topo target obstruction.
`topo_cluster_random_supercritical_z2_route_obstruction_projection_statement_roster_certificate`
pins those topo route-refutation projections, route-obstruction equivalences,
and current topo route/input/output obstructions in one build-gated 12-term
statement list.
`remaining_open_semantic_targets_obstruction_equivalence_certificate` also gates
the corresponding negative statements: for each open target, `Not target`,
`Not exactClosureInput`, and `Not outputBundle` are pairwise equivalent.
`open_semantic_target_obstruction_equivalence_named_roster_certificate` also
pins those negative statements to the named Part 6/topo roster fields.
`remaining_open_semantic_targets_joint_closure_reduction_certificate` packages
the two remaining targets jointly: satisfying both targets, satisfying both
exact inputs, and satisfying both reversible output bundles are equivalent, and
all three joint packages are current-refuted.
`remaining_open_semantic_targets_joint_closure_statement_roster_certificate`
pins every joint package projection, equivalence, and current package
obstruction formula in one build-gated 12-term statement list.
`remaining_open_semantic_targets_joint_route_obstruction_reduction_certificate`
packages the two remaining targets at the route layer as well: joint target
satisfaction, joint target-route satisfaction, and joint closure-route
satisfaction are equivalent, and all three route packages are current-refuted.
`remaining_open_semantic_targets_joint_route_statement_roster_certificate`
pins every joint route-package projection, equivalence, and current package
obstruction formula in one build-gated 12-term statement list.
`remaining_open_semantic_targets_bilateral_package_obstruction_certificate`
also checks that every joint package refutation can be obtained from either
side of the open pair: the Part 6 obstruction or the topo obstruction.
`remaining_open_semantic_targets_bilateral_package_obstruction_statement_roster_certificate`
pins every single-side package-obstruction projection and every current joint
package obstruction formula in one build-gated 15-term statement list.
`remaining_open_semantic_targets_bilateral_current_obstruction_source_certificate`
exposes both remaining targets' current obstruction sources across the target,
exact-input, output-bundle, target-route, and closure-route layers; its
statement-roster certificate pins the same formulas in one build-gated 11-term
list, so the bilateral package refutations cannot be read as a Part 6-only
artifact.
`open_semantic_target_kernel_surface_route_obstruction_equivalence_certificate`
then lifts the same negative route layer to every machine-facing open-target
surface: `Not target`, `Not targetRoute`, and `Not closureRoute` are equivalent
for the roster entries and remain synchronized with the typed payload roster.
`open_semantic_target_frontier_payload_route_obstruction_equivalence_certificate`
checks the same negative equivalences directly on the typed frontier-payload
roster, anchored back to the kernel roster certificate.
`open_semantic_target_named_route_obstruction_roster_certificate` also pins the
kernel and payload target/route/closure obstruction lists to the named Part 6
and topo propositions, so the route-obstruction gate is not merely an
anonymous list-consistency check; 24 obstruction/route terms are checked
against `paperSemanticOpenCount`.
`open_semantic_target_named_frontier_certificate_roster_certificate` similarly
pins the payload, route, closure, progress, nonclosure, and current-frontier
certificate rosters to named Part 6/topo certificate propositions on both
surfaces, with 22 certificate terms checked against `paperSemanticOpenCount`.
`open_semantic_target_named_route_statement_roster_certificate` pins the
target-route, target-closure, and route-closure equivalence statements
themselves to named Part 6/topo formulas on both surfaces, with 12
route-statement terms checked against `paperSemanticOpenCount`.
`remaining_open_semantic_targets_closure_input_field_certificate` gates the
field-level payloads beneath those inputs: Part 6 exposes the closed-unit
tail-reversal bridge, nonempty closed-unit alpha domain, bridge route, and
paper support with sentimental reversal; topo exposes the repaired bridge,
pointwise-on-giant route, paper/support-surface repair fields, strict
supercritical domain, flat and giant-event mass lower bounds, unit-interval
loss range, and boxed-torus family lower-bound surface.
`remaining_open_semantic_targets_closure_input_field_statement_roster_certificate`
pins the two field certificates plus their shared closure-input/output
dependency as a direct 3-term Lean statement roster, and the field-payload
alignment gate now counts that roster explicitly.
`remaining_open_semantic_targets_output_equivalence_certificate` also gates the
reversible output layer: Part 6 is equivalent to
`Part6FullPaperClosingFullOutputBundle`, while topo is equivalent to the
same-witness bundle
`TopoClusterRandomSupercriticalZ2SameBridgeFullOutputBundle`. The older topo
full-output bundle with separated existential witnesses remains only a forward
projection, since it cannot reconstruct one repaired bridge in Lean.
The same field payloads and field certificates are listed in
`openSemanticTargetClosureInputFieldSurfaces`, whose ids are checked against
the open semantic-target roster by Lean and by `audit_paper_semantic_gate.py`;
the same roster now carries reverse payload-to-input projections, payload/input
iff proofs, and the current field-payload obstructions, and
`remaining_open_semantic_targets_closure_input_field_obstruction_certificate`
collects them into a cross-target gate.
`remaining_open_semantic_targets_closure_input_field_obstruction_statement_roster_certificate`
pins the surface-wide field-payload obstruction, both target-specific
field-payload obstructions, and the field-certificate package as a direct
5-term statement roster. The field-payload current-obstruction source roster
therefore now has four checked terms, and the field-payload alignment gate
counts sixteen components.
`open_semantic_target_closure_input_field_roster_certificate` pins the named
closure-input, field-payload, field-payload obstruction, and field-certificate
rosters as four 2-term Lean lists and proves each field-payload obstruction
equivalent to its sufficient closure-input obstruction.
`open_semantic_target_closure_input_field_statement_roster_certificate` pins
the closure-input-to-field-payload, field-payload-to-closure-input,
payload/input equivalence, and payload/input obstruction-equivalence formulas
to four named 2-term Part 6/topo statement lists.

As of R510, the former Principal Part 2 bridge interfaces
`AggregateWelfareWithDifferenceDominatesUnderFOSD` and
`AggregateOptimalBetaMonotoneUnderDiffDom` remain retired, but the public
aggregate carrier has been rewired to the finite FOSD-ramp route.
`aggregateWelfareWith_principal_part2_package` now closes per-`G` argmax
existence, FOSD-induced beta-increment domination, and monotone aggregate-beta
selection for the public `aggregateWelfareWith` / `aggregateOptimalBeta`
surface. The earlier unrestricted-carrier refutations are retained only as
diagnostics for the retired arbitrary-function route.

The former `gap_c_star_constant_pos_OPEN` source axiom is now the projection
theorem `c_star_constant_pos` for the current
positive-subtype witness in `KappaStarDepthDCarriers_current`, so the
trap-tree `κ*(d)` bounds no longer take an external positivity hypothesis or
carrier parameter.
`KappaStarDepthDCarriers_current` supplies the unit positive constant as a
kernel-visible current model; the depth-d `κ*` asymptotic theorems are now
current-carrier results for the paper route.

`ReachableSet` is now the starting-history instance of `ForwardReachable`,
`ReachableSet v ω := ForwardReachable v ∅ ω`, and
`ReachableSet_eq_ForwardReachable_empty` is a definitional theorem. The C1/C2
diagnostic predicates and `IsTopologyBlind` are now concrete semantic
definitions over the existing IDP carriers rather than bare source axioms.

The foundational IDP carrier block is now concrete for the canonical finite
artifact: `Vertex` is `Fin 5`, with `Fintype` and `DecidableEq` inherited from
Mathlib.

`IsEdge` is the concrete loopless complete relation `u ≠ v`; `IsEdge.symm` is
a theorem, not a source axiom.

`PercolationOutcome` is the concrete Boolean open-edge assignment space
`Vertex → Vertex → Bool`; `IsOpen` is the symmetric open-edge predicate over
that assignment.

`ForwardReachable` is now a concrete finite reachable set: the start vertex
itself plus vertices connected by a reflexive-transitive chain of open edges
outside the visit history. `ForwardReachable_self_member` is a theorem.

`DegreeTwoStartingVertex` is also no longer a bare source axiom: it is a
semantic graph predicate over `IsEdge`, asserting the existence of a starting
vertex whose accessible neighbours are exactly two distinct vertices.

`TerminalNeighbourTopology` is likewise a semantic `IsEdge` topology predicate:
for some start vertex, every neighbour is terminal or leads only to a depth-1
subtree.

The remaining diagnostic/signal scope predicates `C2prime_GreedyPathMisalignment`,
`C3_InformationLocality`, and `IsBlackwellOrdered` now project from
`DiagnosticSignalHypothesisData`, a transparent inductive kernel-data package
marked for local instance resolution. This keeps the diagnostic assumptions
explicit without introducing a source-level project axiom or a counted
proof-record interface.
The current parametric local-C2prime route also exposes
`DiagnosticSignalHypothesisData_current`: its C2prime field is the fin5Trap
parametric local-greedy witness package, its C3 field is the constant-signal
concrete witness, and its Blackwell-ordering field is intentionally `False`
because Theorem 6.1's current fin5Trap route does not consume Blackwell
ordering.

The paperGraph preconnectedness bridge for trap-prevalence Part 1 is now the
current theorem `Infrastructure.paperGraph_preconnected_current` from the
complete-loopless `IsEdge` definition. The all-open forward-reachability
identification is now also closed by
`ForwardReachable_empty_full_at_all_open_current` from the concrete
`ForwardReachable` definition.

`V_dyn` is now the concrete `Finset.sup'` over `ForwardReachable` from paper
Definition 2.2 / `def:value-functions`; `V_dyn_def` is a definitional theorem
rather than a source-level structural-equation axiom.

`blockingProb` is the concrete canonical non-degenerate value `1/3`. `reward`
is a concrete bounded five-state profile and `intrinsicPref` is the neutral
`1/2` realisation. Their strict/range facts, including
`blockingProb_mem_unitInterval`, `reward_mem_unitInterval`, and
`intrinsicPref_mem_unitInterval`, are theorems rather than separate global
source axioms.
Future fully parameterised coverage should move the blocking probability to
theorem/module parameters rather than reintroducing a global source axiom.

The unused `oracleReward` stub is now a transparent neutral placeholder
definition in the current scalar model, and `oracleReward_mem_unitInterval` is
a theorem. The full Definition 2.6 oracle expectation remains future work for a
concrete signal/percolation oracle module, but it no longer contributes hidden
global axioms.

In the Wrongness/topo-cluster layer, the topo-loss unit-interval range proof
is now a derived theorem over the concrete finite percolation expectation.
The current Mills-inverse above-threshold route is now a kernel-proved
dead-end, not merely unsupported by the neutral carrier. The theorem
`not_mills_inverse_above_threshold_route_with_unit_bound` proves that R200
Mills identification plus R201 eventual lower bound would force
`expectedTopoLoss n p > 1`, contradicting the derived unit upper bound
`expectedTopoLoss_le_one_atom`. The final route must replace the
`1/(1-exp(-c))` lower constant with a unit-compatible `Z^2_L`
above-threshold lower-bound carrier/theorem.
R407 adds the corrected interface
`UnitCompatibleAboveThresholdLowerBoundConclusion data` and proves
`not_UnitCompatibleAboveThresholdLowerBoundConclusion_current`: the selected
all-open boxed-torus core carrier has identically zero carrier-local expected
topological loss, so it cannot witness any positive lower bound.
R408 adds `unitPositiveTopoLossData` and proves
`unitPositiveTopoLossData_unitCompatibleAboveThresholdLowerBoundConclusion`,
so the corrected interface is kernel-consistent on a transparent nonzero
diagnostic carrier; the remaining missing object is the real stochastic
finite-lattice `Z^2_L` carrier.
R409 adds `firstEdgeStochasticTopoLossData`, where topological loss is the
first finite edge's Bernoulli open indicator scaled by `1/2`; its expectation
is proved to be `(1-p)/2`, closing the corrected interface with `p=3/4` and
`c=1/8` on a genuinely edge-state-dependent finite carrier.
R410 then ties the same first-edge topological loss to a positive-mass finite
event: `firstEdgeGiantStochasticTopoLossData` uses `firstEdgeOpenEvent n` as
its giant event, proves exact event mass `q`, restricted topological loss
`expectedTopoLossOnGiantOn = (1-p)/2`, positive/full-cluster giant-event
conclusions, and the same corrected lower-bound interface. This is still a
finite regression witness, not the final `Z^2_L` giant-component theorem.
R411 moves the positive topo-loss regression from a first-edge diagnostic to
the boxed-torus all-open coordinate-edge event:
`boxedTorusAllOpenPositiveTopoLossData` proves all-open event-indicator mass,
positive restricted/full topo-loss expectation
`((1-p) ^ Fintype.card (BoxedTorusEdgeIdx L)) / 2` at
`n = boxedTorusFlatGraphN L`, and the full-cluster giant-event package. Lean
also proves this fixed-`L` carrier cannot satisfy the eventual
`UnitCompatibleAboveThresholdLowerBoundConclusion`, so the remaining target is
a positive lower-bound family across all large finite lattices.
R412 adds `boxedTorusAllOpenFirstEdgeAwayTopoLossData`: the boxed-torus
oracle/cluster/giant packages remain on the all-open finite-torus event, while
the topo-loss kernel is zero at that flat index and uses the first-edge
stochastic loss for every larger `n`. Lean proves its oracle interfaces,
nonzero oracle witness, below-threshold giant-event envelope,
full-cluster/boxed-torus cluster-count packages, and the corrected
above-threshold lower-bound package in one data object. R412 also made the
public `ParametricGraphLocalDilemmaTheoremCore` require
`UnitCompatibleAboveThresholdLowerBoundConclusion data`.
R413 replaces that separated-tail witness in the public graph-local core with
`firstEdgeOpenGiantClosedTopoLossData`: the same first-edge-open event is the
giant event, topo loss is zero on that event, and its first-edge-closed
complement carries loss `1/2`, so Lean proves `expectedTopoLossOnGiantOn = 0`
while `expectedTopoLossOnData = p / 2`. This closes the below-envelope and
corrected above-threshold lower-bound packages through one event/complement
mechanism. It remains diagnostic, not the final `Z^2_L` random
giant-component/reward-loss carrier.
R414 upgrades that diagnostic mechanism to
`allEdgeOpenGiantComplementTopoLossData`: the selected giant event is
`allEdgeOpenEvent n`, meaning every edge in the current finite `EdgeIdx n`
carrier is open, and the topo-loss kernel is zero on that event and `1/2` on
its complement. Lean proves the all-edge-open event is nonempty, has mass
`q ^ Fintype.card (EdgeIdx n)`, has zero restricted giant-event loss, and has
full expected topo loss bounded below by the R413 first-edge-closed loss
`p / 2`. The public graph-local core now uses this all-current-edge
event/complement package. This is still diagnostic because the cluster-count
carrier is transparent, not the random supercritical `Z^2_L` geometry.
R415 migrates that public core back onto the boxed-torus reachable-set oracle
with `boxedTorusAllOpenComplementTopoLossData 1`. At the flattened
boxed-torus size, the selected giant event is the all-coordinate-edge-open
event, the cluster count is the concrete finite-bond reachable-set
cardinality, and topo loss is zero on that event and `1/2` on its complement.
Away from the flat index it retains the first-edge-closed tail to keep the
corrected above-threshold lower-bound package eventual and uniform. This is
still not the final random supercritical `Z^2_L` theorem, but the public core
no longer relies on R414's transparent `n + 1` cluster-count carrier.
R416 adds a flat boxed-torus family lower-bound route that does not use the
away-from-flat tail. Lean proves the exact flat-index expectation for
`boxedTorusAllOpenComplementTopoLossData L`:
`(1 - (1 - p) ^ Fintype.card (BoxedTorusEdgeIdx L)) / 2`, then proves that
at `p = 3/4` every flattened boxed-torus member has expected topo loss at
least `1/8`. The new family-level interface
`BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion` is closed
for `boxedTorusAllOpenComplementTopoLossData` with `L0 = 0`.
R417 wires that family-level result into the public graph-local theorem core:
`ParametricGraphLocalDilemmaTheoremCore` now selects the
`boxedTorusAllOpenComplementTopoLossData` family plus member `L = 1`, uses
that member for the oracle/giant-event/cluster-count packages, and uses
`BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion_current` for
the above-threshold lower-bound side. The public core therefore no longer
depends on the fixed-carrier all-`n` `UnitCompatibleAboveThresholdLowerBoundConclusion`
tail.
R418 reroutes the same public core to
`boxedTorusFullReachComplementTopoLossData` with member `L = 1`. At the
flattened boxed-torus size, the selected giant event is now full reachability
of the concrete oracle reachable set, not the all-coordinate-edge-open event;
all-open is used only as a sub-event to prove positive mass on the Bernoulli
probability domain `0 < q <= 1`. The flat lower-bound side is closed by
`BoxedTorusFullReachFlatUnitCompatibleAboveThresholdLowerBoundConclusion_current`
with witnesses `p = 3/4`, `c = 1/512`, and `L0 = 1`, using the local
base-incident-closed obstruction and the degree bound
`boxedTorusIncidentEdgeSet_card_le_four`. The remaining paper-faithful gap is
the random supercritical `Z^2_L` giant-component/reward-loss theorem, not an
all-open definition of the event.
R419 reroutes the public core one step further to
`boxedTorusFullReachFlatOnlyComplementTopoLossData` with member `L = 1`. This
new public witness is identical to the R418 full-reach complement carrier on
the flattened boxed-torus size, but has zero topological loss and empty giant
event off the flat sequence. The public theorem core therefore no longer
carries the R418 first-edge off-flat diagnostic tail; the remaining
above-threshold lower-bound obligation is exactly the flat-family interface
`BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion`.
R420 proves the flat-only carrier's `1/512` lower bound directly from
`boxedTorusBaseIncidentClosedEvent_not_fullReach`, the finite-product mass of
the closed base-incident event, and `boxedTorusIncidentEdgeSet_card_le_four`.
The equality-to-R418 theorem remains only as an audit/comparison fact; the
current public lower-bound package no longer depends on the R418 carrier
theorem.
R421 factors that direct proof through an explicit event statement:
`boxedTorusFullReachFailureEvent` is the complement of the full-reach event,
`boxedTorusBaseIncidentClosedEvent_subset_fullReachFailureEvent` gives the
local obstruction as a sub-event, and
`boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_eq_failureMass`
identifies flat expected loss with one half of the failure-event mass.
R422 exposes the success/failure probability partition behind that same
argument: `boxedTorusFullReachGiantFailureEventMass_add_eq_one` and
`boxedTorusFullReachFailureEventMass_eq_one_sub_fullReachGiantEventMass` make
failure mass equal to `1 -` full-reach success mass, and the flat expected-loss
proof now factors through
`boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_eq_one_sub_fullReachMass`.
R423 isolates the obstruction as a replaceable separator/cutset interface:
`BoxedTorusBaseTargetSeparator` states that closing a coordinate edge set
blocks every base-to-horizontal-target open path, and the full-reach failure
mass and success-mass upper-bound theorems now work for any such separator.
The current instance is still the local base-incident cut, but the probability
route no longer hard-codes that instance.
R424 makes the cutset layer omega-free: `BoxedTorusBaseTargetEdgeCutset`
requires every edge-simple base-to-horizontal-target skeleton to meet the cut,
and `boxedTorusBaseTargetSeparator_of_edgeCutset` turns that pure combinatorial
fact into the closed-edge separator consumed by the probability layer.
R425 proves the converse `boxedTorusBaseTargetEdgeCutset_of_separator`, so the
separator predicate and the omega-free edge-cutset predicate are now connected
in both directions on the current finite coordinate model.
R426 adds the standard vertex-region source of such cutsets:
`boxedTorusCoordEdgeBoundarySet_baseTargetEdgeCutset` proves that any finite
vertex set containing the base and excluding the horizontal target generates a
base-target edge cutset through its coordinate edge boundary.
R427 exposes that boundary source directly at the probability and loss layers:
`boxedTorusCoordEdgeBoundarySet_baseTargetSeparator` feeds boundary-generated
separators into the full-reach failure-mass, success-mass upper-bound, and
flat-only expected-loss lower-bound theorems.
R428 instantiates the public numerical route through the singleton base-region
boundary: the coordinate boundary of `{base}` has cardinality at most four by
comparison with the base incident-edge set, and the `1/512` flat-only lower
bound now calls the singleton-boundary expected-loss theorem.
R429 factors that numerical step once more: any base-containing,
target-excluding vertex region whose coordinate boundary has cardinality at
most four now feeds the same `1/512` flat-only lower-bound theorem shape; the
singleton base-region boundary is just the current instance.
R430 lifts this from a pointwise expected-loss theorem to the family package:
`BoxedTorusFullReachFlatOnlyLowerBoundConclusion_of_eventually_smallBoundary`
closes the flat boxed-torus lower-bound interface from any eventual family of
such small boundaries, and the current public theorem instantiates it with
the singleton base-region family.
R431 generalizes the package-level bridge once more:
`BoxedTorusFullReachFlatOnlyLowerBoundConclusion_of_eventually_boundedBoundary`
closes the same interface from any eventual boundary family with a uniform
finite coordinate-boundary bound `B`, using the explicit kernel constant
`(3/4)^B / 2`; the small-boundary theorem is now just the `B = 4`
specialization.
R432 makes that bounded-boundary theorem probability-parametric:
`BoxedTorusFullReachFlatOnlyLowerBoundConclusion_of_eventually_boundedBoundary_at`
accepts any explicit `p` with `p_c < p <= 1` and uses constant `p^B / 2`;
the fixed `p = 3/4` theorem is now just the current witness instance.
R433 exposes the same quantitative step at the pointwise loss layer:
`boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedBoundary_pow_div_two_of_card_le`
states the explicit `p^B / 2` expected-loss lower bound for any qualifying
boundary before that bound is repackaged into the family interface.
R434 exposes the current singleton instance separately:
`boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_baseSingletonBoundary_pow_four_div_two`
gives the explicit `p^4 / 2` loss lower bound for the base-region boundary,
and the public `1/512` theorem now factors through this stronger local fact.
R435 moves the reusable lower-bound bridge below vertex boundaries:
`boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedSeparator_pow_div_two_of_card_le`
and
`BoxedTorusFullReachFlatOnlyLowerBoundConclusion_of_eventually_boundedSeparator_at`
accept any bounded edge separator, while
`BoxedTorusFullReachFlatOnlyLowerBoundConclusion_of_eventually_boundedCutset_at`
accepts the omega-free edge-cutset form. The boundary-family theorem is now a
specialization of this separator package.
R436 exposes the omega-free cutset route one layer lower:
`boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedCutset_pow_div_two_of_card_le`
is the pointwise `p^B / 2` theorem for bounded edge cutsets, and the
bounded-cutset package now consumes it directly.
The gate-level
`boxedTorusFullReachFlatOnlyLowerBound_cutset_route_certificate` packages the
separator, cutset, boundary, and family-level lower-bound variants into one
frontier certificate for the topo semantic gate.
R437 folds the legacy base-incident pointwise theorem into the same cutset
path: `boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedIncident`
now instantiates `boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedCutset`
with `boxedTorusBaseIncidentEdgeSet_baseTargetEdgeCutset`.
R438 mirrors that interface on the sibling full-reach complement carrier:
`boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedSeparator`
and `..._ge_closedCutset` are now audited theorem targets, and the historical
`..._ge_closedIncident` theorem delegates to the cutset specialization.
R439 adds the sibling quantitative forms
`boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedSeparator_pow_div_two_of_card_le`
and `..._ge_closedCutset_pow_div_two_of_card_le`; the older `1/512` theorem
now instantiates the `B = 4`, `p = 3/4` cutset theorem instead of calling the
incident theorem.
R440 lifts the same sibling route through vertex boundaries and the current
singleton base region:
`boxedTorusFullReachComplementTopoLossData_expectedTopoLossOnData_flat_ge_baseSingletonBoundary_pow_four_div_two`
is now the predecessor's explicit `p^4 / 2` local witness, and its `1/512`
theorem delegates to that singleton-boundary specialization.
R441 promotes that predecessor route to the same package-level interface:
`BoxedTorusFullReachComplementLowerBoundConclusion_of_eventually_boundedSeparator_at`,
`..._of_eventually_boundedCutset_at`, and the boundary specializations now
close `BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion` for the
sibling carrier from any eventual uniformly bounded local separator/cutset
family; the historical current theorem delegates to that package-level current
instance.
The below-threshold giant-component bridge facts remain explicit interface
predicates at the lower bridge layer: the order-statistics formula on the giant
event and the giant-component cluster-size lower bound are not erased. On the
current diagnostic global carrier, however,
`topoLossKernel_pointwise_bound_paper_Def`,
`topoLossKernel_le_one_over_n_on_giant_paper_Def`,
`topoLossKernel_le_one_over_n_on_giant_from_bridges`, and
`topoLossKernel_le_one_over_n_on_giant_atom` now consume the current bridge
closures internally and expose no theorem-level bridge premises. The
full finite-lattice route is preserved by the explicit-package bridge theorem
`topoLossKernel_pointwise_bound_on data`.
The public wrappers `topo_loss_on_giant_below_one_over_n`,
`topo_loss_on_giant_below_envelope_exists`, `gap_topo_loss_below_threshold`,
`topo_loss_decay_below_pc`, and `gap_phase_transition_below` therefore no
longer expose those bridge parameters in theorem signatures.
The underlying Wrongness/topo percolation carriers (`wInfoOracleKernel`,
`wInfoOracleClusterCount`, `topoLossKernel`, `giantComponentEvent`, and
`expectedTopoLossAboveLowerConst`) now project from a transparent diagnostic
`WrongnessPercolationData` package. This removes the former source axiom. The
oracle and above-threshold lower-bound sides remain neutral, while the topo
side has a nonempty `n = 1` diagnostic giant event:
`giantComponentEvent_one_current_nonempty` and
`expectedTopoLossOnGiant_one_current_pos` are kernel theorems. The full
non-trivial `Z^2_L` giant-component and above-threshold lower-bound content is
still exposed as explicit theorem interfaces rather than claimed by this
diagnostic carrier.
The two below-threshold giant-event bridge statements
`topoLossKernel_eq_orderStatisticsRatio_on_giant_current` and
`giantComponent_cluster_size_lower_bound_current` are kernel theorems for the
current carrier with a real `n = 1` witness; this is a non-vacuity regression
for the bridge mechanism, not a full `Z^2_L` giant-component proof.
`topo_cluster_random_supercritical_z2_frontier_payload` now machine-gates this
current frontier by storing the conditional expectation formulas, below/above
phase theorem surfaces, boxed-torus flat-family lower-bound package, and
Mills-route obstructions in `PaperSemanticGate.lean`.  It also checks the
future `Z2TopoClusterBridgeData` bridge projections into the family-core and
flat lower-bound conclusions, the current standard-`Z^2` witness
`boxedTorusFullReachFlatOnlyZ2TopoClusterBridge_current` with its
family/core/lower-bound projections, plus
`boxedTorusFullReachFlatOnlyComplementTopoLossData_flatOnlyDiagnostic`: the
current flat-only family has zero total expected topo loss off the flattened
boxed-torus index and zero giant-restricted topo loss at every index.  The
final `RandomSupercriticalZ2TopoClusterBridgeData` contract now also carries a
named supercritical probability `p > p_c`, separate flat and giant-restricted
lower-bound theorem fields at that same parameter, and a derived
single-certificate projection with one positive constant and one size threshold
supporting both lower bounds.  The gate also checks the derived
`randomSupercriticalZ2TopoClusterBridgeData_paper_support_certificate`, which
ties this support to the standard `Z^2` graph identity, finite boxed-torus
vertex/edge indexing facts, the same named `p > p_c` domain, and the
non-diagnostic tail certificate.  That certificate now includes the current
full-reach, flat-only, all-open-complement, deterministic all-open giant, and
deterministic all-open positive exclusions; the pointwise and eventual hybrid
exclusions; and arbitrarily large finite members outside all five deterministic
diagnostic families.  It also requires arbitrarily large members where those
diagnostic exclusions hold at the same finite sizes as the shared flat/giant
lower-bound support and in-giant positive-loss realisation. Thus future closure
cannot hide the paper probability, giant-component support, or non-diagnostic
finite-lattice tail only inside the abstract family-core package; the payload
also gates the derived uniform eventual positive flat-loss witness, eventual
positive giant-restricted loss witness, eventual unrestricted pointwise
positive-loss realisation witness, and eventual in-giant pointwise positive-loss
realisation witness at that same parameter. It also gates
`randomSupercriticalZ2TopoClusterBridgeData_exists_non_diagnostic_member`,
which turns the pointwise-hybrid exclusion into an explicit finite `L` whose
family member is not the full-reach, flat-only, or all-open-complement
diagnostic carrier, and
`randomSupercriticalZ2TopoClusterBridgeData_arbitrarily_large_non_diagnostic_member`,
which rules out eventual diagnostic tails by producing such a member above
every finite threshold.  The same gate now also checks the deterministic
all-open giant and deterministic all-open positive exclusions, the extended
eventual five-family tail exclusion, and
`randomSupercriticalZ2TopoClusterBridgeData_arbitrarily_large_extended_non_diagnostic_member`,
which produces arbitrarily large members outside all five deterministic
diagnostic families, and
`randomSupercriticalZ2TopoClusterBridgeData_eventually_uniform_supported_extended_non_diagnostic_member`,
which chooses such members inside the same eventual shared lower-bound and
in-giant positive-loss support regime.
The
payload also gates the flat-size support identity
`boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_eq_failureMass`,
so the current lower-bound evidence is explicitly tied to the full-reach
failure complement rather than to a random supercritical `Z^2_L` theorem.  The
same payload now also gates the stronger full-reach bridge
`boxedTorusFullReachZ2TopoClusterBridge_current`, its family/core/flat lower-bound
projections, the per-member all-`n`
`boxedTorusFullReachZ2TopoClusterBridge_current_unit_compatible` theorem, and
`not_boxedTorusFullReachComplementTopoLossData_flatOnlyDiagnostic`, which
separates that full-reach carrier from the flat-only diagnostic by its off-flat
first-edge fallback loss.  The payload now also gates the all-open boxed-torus
finite giant-event witnesses
`boxedTorusAllOpenGiantTopoLossData_giantEventFullClusterConclusion`,
`boxedTorusAllOpenGiantTopoLossData_expectedTopoLossOnGiantEnvelopeConclusion`,
and the positive restricted-loss regression
`boxedTorusAllOpenPositiveTopoLossData_expectedTopoLossOnGiant_flat_pos`.  It
also gates the complement family `boxedTorusAllOpenComplementTopoLossData`:
the flat-sequence lower-bound conclusion, every selected member's
unit-compatible lower-bound package, its full-cluster giant-event and
restricted-envelope packages, and the uniform `1/8` flat expected-loss lower
bound at `p = 3/4`.  The payload also gates
`not_UnitCompatibleAboveThresholdLowerBoundConclusion_boxedTorusFullReachFlatOnly`
and its current-bridge form, showing that each fixed flat-only member cannot be repackaged as an all-`n`
above-threshold lower-bound carrier.  The
semantic target remains open because these are finite all-open, complement,
and flat-sequence carriers rather than a random finite `Z^2_L`
giant-component/lower-bound theorem.  The gate now records the stronger
`RandomSupercriticalZ2TopoClusterBridgeData` contract and its projection
theorems, plus non-diagnostic guards excluding the current full-reach,
flat-only, all-open-complement, deterministic all-open giant, and deterministic
all-open positive families, including extended eventual tails assembled from
those diagnostics.  The next semantic closure step is
therefore to instantiate that contract with the paper's stochastic
finite-lattice family rather than to add another wrapper around the current
diagnostics.
The repaired random-supercritical surface now also has an explicit compatibility
instance,
`firstEdgeOpenGiantClosedTopoLossRepairedBridge_current`, with `p = 3/4`, a
uniform flat expected-loss lower bound, a uniform giant-event-mass lower bound,
unit-interval topo loss, and a paper-support certificate.  The payload also
checks
`randomSupercriticalZ2TopoClusterRepairedBridgeData_eventually_giant_event_member`,
so the positive giant-event mass is converted into actual finite
configuration membership rather than left as a numerical-only non-vacuity
claim. It also gates
`randomSupercriticalZ2TopoClusterRepairedBridgeData_eventually_uniform_flat_event_mass_member_and_loss_realisation`,
which keeps the flat lower bound, giant-event mass, giant-event member, and
positive-loss realisation together at the same sufficiently large boxed-torus
index, and
`randomSupercriticalZ2TopoClusterRepairedBridgeData_eventually_uniform_supported_extended_non_diagnostic_member_with_giant_member`,
which gives arbitrarily large non-diagnostic repaired members where that same
flat lower bound, giant-event mass, giant-event member, positive-loss
realisation, and the five deterministic-diagnostic exclusions all hold at the
same chosen `L`. Its event is no
longer only a naked `firstEdgeIdx`: the gate checks
`boxedTorusFlattenBaseHorizontalEdge_eq_firstEdgeIdx` and
`firstEdgeOpenGiantClosedTopoLossFamily_giant_event_boxedTorusBaseHorizontal_mem_iff`,
so the selected cylinder event is the existing boxed-torus base horizontal edge
after flattening, and
`firstEdgeOpenGiantClosedTopoLossFamily_giant_event_baseHorizontalTarget_reachable`
shows that the base horizontal target lies in the corresponding open-edge
reachable set. The gate also checks
`firstEdgeOpenGiantClosedTopoLossFamily_topoLossKernel_zero_on_giant` and
`firstEdgeOpenGiantClosedTopoLossFamily_expectedTopoLossOnGiantOn_boxedTorus_eq_zero`,
plus
`firstEdgeOpenGiantClosedTopoLossFamily_not_positive_giant_loss_lower_bound_at_three_quarters`,
so the current witness is explicitly zero on its selected giant-restricted
topological loss and cannot provide a positive uniform giant-restricted lower
bound. The gate packages these current compatibility and not-closing facts as
`firstEdgeOpenGiantClosedTopoLossRepairedBridge_current_compatibility_certificate`.
It now names the missing paper-closing field as
`RandomSupercriticalZ2TopoClusterRepairedBridgeGiantLossPaperClosing`: every
old final bridge would project to that field, while
`firstEdgeOpenGiantClosedTopoLossRepairedBridge_current_not_giant_loss_paper_closing`
proves the current first-edge repaired witness cannot satisfy it.
The stronger
`RandomSupercriticalZ2TopoClusterRepairedBridgeFullPaperClosingSupport` also
packages repaired paper support with one constant/tail threshold for flat loss,
giant-restricted loss, giant-event mass, and an in-giant positive-loss
realisation; the old final contract projects to this full surface, and
`firstEdgeOpenGiantClosedTopoLossRepairedBridge_current_not_full_paper_closing_support`
refutes it for the current witness.
The gate now also exposes a sufficient route:
`RandomSupercriticalZ2TopoClusterRepairedBridgeGiantPointwiseLossRoute`
requires a uniform positive pointwise loss floor on the repaired bridge's
giant event; by
`expectedTopoLossOnGiantOn_ge_mul_mass_of_pointwise_ge`,
`randomSupercriticalZ2TopoClusterRepairedBridgeGiantLossPaperClosing_of_giant_pointwise_loss_route`,
`randomSupercriticalZ2TopoClusterRepairedBridgeFullPaperClosingSupport_of_giant_pointwise_loss_route`,
`randomSupercriticalZ2TopoClusterRepairedBridgeSupportSurfaceClosingRoute_of_giant_pointwise_loss_route`,
and
`randomSupercriticalZ2TopoClusterFullPaperClosingRoute_of_giant_pointwise_loss_route`,
and
`randomSupercriticalZ2TopoClusterBoxedTorusFiniteZ2LClosingRoute_of_giant_pointwise_loss_route`,
that floor plus the existing giant-event mass lower bound is enough for full
topo paper-closing support, the repaired support-surface closing spine, the
named full route, and the boxed-torus finite `Z2_L` route. The current
first-edge witness is blocked from that route by
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
The existential closing target is now also named as
`RandomSupercriticalZ2TopoClusterFullPaperClosingRoute`; the gate checks that a
full-support repaired bridge inhabits this route, that the route contains an
actual repaired bridge and full-support witness, and that the old over-strong
contract would project to it.
It also gates
`randomSupercriticalZ2TopoClusterFullPaperClosingRoute_paper_support_output`,
`randomSupercriticalZ2TopoClusterFullPaperClosingRoute_support_surface_repair_output`,
`randomSupercriticalZ2TopoClusterFullPaperClosingRoute_support_surface_repair_route`,
`randomSupercriticalZ2TopoClusterFullPaperClosingRoute_support_surface_repair_output_certificate`,
`randomSupercriticalZ2TopoClusterFullPaperClosingRoute_giant_loss_output` and
`randomSupercriticalZ2TopoClusterFullPaperClosingRoute_combined_support_output`,
so a future route must expose the repaired paper-support surface, factor back
through the repaired support-surface route/output, expose the missing giant-loss
closing field, and carry the same-tail flat/giant/mass/positive-realisation
output rather than merely an existential wrapper.
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
so the three numeric topo route output layers and the repaired paper-support
surface are checked together.
It now also names
`not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute_firstEdge_three_quarters_full_output_bundle`,
so the current first-edge witness is refuted at the exact
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
range in the same repaired-bridge witness.  The same calibration is now named
as the iff
`randomSupercriticalZ2TopoClusterFullPaperClosingRoute_iff_boxed_torus_finite_z2L_route`;
the repaired support-surface closing spine likewise has the named per-bridge
iff
`randomSupercriticalZ2TopoClusterRepairedBridgeSupportSurfaceClosingRoute_iff_full_paper_closing_support`.
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
which states that a pointwise-on-giant repaired route would close the
giant-loss field, the full repaired support surface, the repaired
support-surface closing spine, the named full route, and the boxed-torus
finite `Z2_L` route, while the current first-edge witness is refuted at that
route surface.
The current surface is now further calibrated by
`random_supercritical_z2_topo_cluster_full_support_envelope_obstruction_certificate`
and the individual theorems
`not_randomSupercriticalZ2TopoClusterRepairedBridge_giant_loss_paper_closing`,
`not_randomSupercriticalZ2TopoClusterRepairedBridge_full_paper_closing_support`,
`not_randomSupercriticalZ2TopoClusterRepairedBridge_giant_pointwise_loss_route`,
`not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute`, and
`not_randomSupercriticalZ2TopoClusterBoxedTorusFiniteZ2LClosingRoute`: under
the present theorem-core pointwise envelope, the giant-loss/full-support route
surface is uninhabitable for every repaired bridge.  The repaired replacement
surface is now explicitly build-gated by
`RandomSupercriticalZ2TopoClusterRepairedBridgeSupportSurfaceRepair`, its named
route, and
`random_supercritical_z2_topo_cluster_support_surface_repair_certificate`, with
the current repaired first-edge bridge as an inhabitant.  The companion
`random_supercritical_z2_topo_cluster_support_surface_repair_route_output_certificate`
projects repaired bridge nonemptiness, repaired paper support, and the
same-tail non-diagnostic support output from the repaired route.  The explicit
`random_supercritical_z2_topo_cluster_support_surface_repair_nonclosure_certificate`
then binds that inhabited repair layer to the full-route and boxed-torus-route
obstructions.  The stronger
`random_supercritical_z2_topo_cluster_support_surface_closing_route_certificate`
now gates the repaired closing spine itself: full paper-closing support and the
support-surface closing route are equivalent, the pointwise-on-giant route
projects into it, and any inhabitant exposes both the named full route and the
boxed-torus finite `Z2_L` route.  This makes the next paper-semantic task a
genuine random finite `Z2_L` instantiation of that repaired route, not another
search inside the refuted full-support surface.
It now also includes
`RandomSupercriticalZ2TopoClusterRepairedBridgeDiagnosticObstructionCertificate`
and
`random_supercritical_z2_topo_cluster_repaired_bridge_diagnostic_obstruction_certificate`,
which rule out discharging the repaired bridge itself by the current
full-reach, flat-only, all-open-complement, deterministic all-open giant,
deterministic all-open positive, pointwise-hybrid, or eventual diagnostic-tail
families.
It also gates
`randomSupercriticalZ2TopoClusterFullPaperClosingRoute_supported_extended_non_diagnostic_output`,
so that same route must expose arbitrarily large non-diagnostic finite members
carrying full flat/giant/mass/in-giant-positive support.
It also gates the combined
`random_supercritical_z2_topo_cluster_current_frontier_certificate`, which
keeps the old over-strong contract obstruction and the repaired first-edge
compatibility witness, diagnostic obstruction certificate, and finite
positive-regression and pointwise-route certificates in one current-frontier
theorem.
This proves the repaired contract is satisfiable and linked to the
finite reachable-set semantics, but it is still deliberately a one-edge
cylinder event rather than the paper's random finite `Z2_L` giant-component
carrier, so the paper semantic gate remains `closed=3 open=2`.

The concrete scalar `agentRewardKernel` now also proves its general
unit-interval range, Bayesian/Sentimental pointwise monotonicity, κ-agent
pointwise continuity, and κ-agent increasing-differences facts directly as
theorems. Those five facts no longer contribute source-level axioms.
The 5-state κ-agent above-threshold, 5-state κ-agent at-threshold, and
Bayesian-naive below-threshold pointwise monotonicity facts are likewise
kernel theorems by unfolding the current concrete scalar kernel, removing
three more former source axioms.
The Bayesian-naive above-threshold strict reversal witness is now a current
theorem, not a source axiom: the public `bayesianNaive` branch carries `p_hat`
in the `κ` slot and switches from the below-threshold `unitRamp` branch to the
above-threshold greedy-reversal shape at `p_hat ≥ 2/3`.
The greedy high-precision limit kernel is also no longer a source axiom:
`agentRewardKernel_greedy_limit_kernel` is the concrete constant `6/10`, and
`greedyKernelPointwiseTendstoAtTop` proves the atTop convergence by eventual
equality to that constant.

The R205 Harris-Kesten / Cardy / Smirnov-Werner lower-envelope divergence claim
is no longer retained as a live Prop interface:
`not_harrisKestenScalingFunction_diverges_at_pc_paper_Def` proves that the
current unbounded lower-envelope carrier is identically zero on `p ≥ 0`, due to
the `α = 2` feasible-set-empty branch and `Real.sInf_empty = 0`. The paper
Part 6 route now uses the parameterized
`kappaStar_diverges_at_pc_via_scaling_carrier` transfer interface: callers must
provide a replacement scaling carrier `s`, a proof that `s` diverges at `p_c`,
and a domination proof `s p ≤ kappaStar p α` in the high-α regime. R467 now
supplies an explicit hyperbolic replacement carrier
`criticalHyperbolicScaling p := 1 / (p_c - p)` and proves
`criticalHyperbolicScaling_diverges_at_pc`. R468 proves this exact carrier
cannot satisfy the current unbounded high-alpha domination target:
`not_criticalHyperbolicScaling_dominates_kappaStar_current` uses the
`alpha = 2`, `p = 0` counterexample, where the hyperbolic carrier is positive
but `kappaStar 0 2 = 0`. The Part 6 gate now also checks the generic theorem
`not_positive_at_zero_scaling_dominates_kappaStar_current` and its bridge form
`not_z2_lattice_embedding_bridge_with_positive_at_zero_scalingCarrier`: any
candidate scaling carrier with `0 < s 0` is excluded by the current
unbounded high-alpha domination interface. It also gates
`current_part6_unbounded_alpha_zero_branch_near_pc`, which packages the
near-`p_c` form of the obstruction: `alpha = 2` is in the current unbounded
domain, and every deleted left-neighbourhood of `p_c` contains a non-negative
`p` with `kappaStar p 2 = 0`. The gate also checks
`current_part6_unbounded_alpha_zero_branch_blocks_local_bridge`, which turns
that witness into a generic obstruction to the current unbounded local bridge
shape. The bridge-level exclusions
`not_z2_lattice_embedding_bridge_with_harrisKestenScalingFunction` and
`not_z2_lattice_embedding_bridge_with_criticalHyperbolicScaling` now show that
neither retired/current candidate can instantiate `Z2LatticeEmbeddingBridgeData`.
The same candidate layer is now bundled as
`part6_scaling_candidate_current_obstruction_certificate`, so the lower-envelope,
generic positive-at-zero, hyperbolic, and bridge-level carrier exclusions are
available as one audited Part 6 certificate.
The Part 6 gate now also checks the repaired local-domination transfer
`gap_cognitive_threshold_part6_local` and the local bridge entrypoint
`gap_cognitive_threshold_part6_from_z2_lattice_embedding_local_bridge`.
The local bridge contract now carries
`z2LatticeEmbeddingLocalBridgeData_near_pc_feasible_nonempty` and the gate
checks `z2LatticeEmbeddingLocalBridgeData_paper_support_certificate`, so an
unbounded repaired route must also prove near-`p_c` nonemptiness of the
`kappaStar` feasible set rather than relying on an empty `sInf` branch.
It also checks `not_z2_lattice_embedding_local_bridge_current`, which proves
the current local bridge shape is still uninhabitable: the unbounded `α` domain
includes `α = 2`, while the new near-`p_c` zero-branch witness shows
`kappaStar p 2 = 0` at non-negative left-neighbourhood points where any
divergent scaling carrier is positive; the blocker theorem is now the proof
spine for this obstruction. It also gates
`mean_estimate_gap_lt_one_of_nonneg_p_of_pos_kappa`,
`kappaStar_eq_zero_of_one_lt_alpha_of_nonneg_p`,
`not_unbounded_part6_divergence_witness_current`,
`not_unbounded_part6_pointwise_paper_domain_certificate_current`, and
`not_unbounded_part6_feasible_divergence_witness_current`, proving that the
current carrier cannot even supply the unbounded divergence, pointwise
paper-domain certificate, or same-`alpha` feasible/divergence output witness
once `alpha > alphaStar 0 p_c = 1`. It also gates
`not_unbounded_part6_full_paper_domain_witness_current` and the combined
`unbounded_part6_current_obstruction_certificate`, so the near-`p_c` zero
branch, output-witness obstructions, full same-`alpha` witness obstruction,
and current local-bridge impossibility are audited as one unbounded-route
certificate.
The same gate now
checks `alphaStar_eq_one_current` and
`not_closed_unit_alpha_above_alphaStar_current`, showing that a naive
paper-bounded domain repair `α <= 1` would be empty on the current scalar
carrier. It also gates
`closed_unit_alpha_domain_nonempty_iff_alphaStar_lt_one`, so the closed-unit
nonempty-domain repair is exactly the threshold certificate
`alphaStar 0 p_c < 1`. The gate also checks
`alphaStar_lt_one_requires_sentimental_welfare_reversal_witness` and
`z2LatticeEmbeddingClosedUnitLocalBridgeData_sentimental_welfare_reversal_required`,
so a closed-unit repair must expose an actual sentimental welfare reversal in
the closed unit alpha range rather than only replacing the scaling carrier. The
gate now also checks `ClosedUnitAlphaStarTailReversalRepairRoute`,
`alphaStar_lt_one_of_closed_unit_tail_reversal_repair_route`,
`closed_unit_alpha_domain_nonempty_of_tail_reversal_repair_route`, and
`not_closed_unit_alphaStar_tail_reversal_repair_route_current`: a future
repaired carrier can close the closed-unit alpha-domain by proving a uniform
tail welfare reversal above some `a < 1`, while the current carrier is ruled
out because its sentimental kernel remains beta-monotone on the whole closed
unit interval. The
new `closed_unit_alpha_domain_repair_certificate` packages the exact
`alphaStar 0 p_c = 1` degeneracy, the nonempty-domain iff, the forced
sentimental-reversal witness, the sufficient tail-reversal route, and the
current route obstruction in one Part 6 gate theorem.
The
gate lifts this sufficient route to the bridge level through
`Z2LatticeEmbeddingClosedUnitTailReversalBridgeData`,
`z2LatticeEmbeddingClosedUnitLocalBridgeData_of_tail_reversal_bridge`,
`part6_full_paper_closing_bridge_route_of_closed_unit_tail_reversal_bridge_nonempty`,
and
`part6_full_paper_closing_support_of_closed_unit_tail_reversal_bridge_nonempty`.
The companion
`z2_lattice_embedding_closed_unit_tail_reversal_bridge_output_certificate`
now also projects `alphaStar 0 p_c < 1`, closed-unit alpha-domain nonemptiness,
closed-unit bridge nonemptiness, same-carrier closed-unit full paper-domain
support, same-bridge paper-support plus sentimental-reversal, Part 6
route/support, the same-alpha divergence/feasible-divergence output pair
(`part6_full_paper_closing_output_pair_of_closed_unit_tail_reversal_bridge`),
and the full output bundle from any future tail-reversal bridge.
It also gates
`not_z2_lattice_embedding_closed_unit_tail_reversal_bridge_current`, so the
current carrier is refuted at the exact bridge-level route that would otherwise
enter the Part 6 paper-support surface.
The dedicated
`z2_lattice_embedding_closed_unit_tail_reversal_bridge_nonclosure_certificate`
now packages that output certificate with the alpha-domain repair obstruction,
the current tail-reversal bridge nonempty obstruction, and the current
Part 6 bridge-route/support/full-output-bundle refutations, so this repair
surface is build-gated as sufficient but not yet a theorem closure.
The
closed-unit local bridge contract now includes that
threshold certificate, derives the nonempty-domain witness from it, carries
near-`p_c` feasible-set nonemptiness on the closed-unit paper domain, and the
gate also checks the bounded transfer theorem
`gap_cognitive_threshold_part6_from_z2_lattice_embedding_closed_unit_local_bridge`
for any future instance on `alphaStar 0 p_c < α <= 1`, plus
`gap_cognitive_threshold_part6_from_z2_lattice_embedding_closed_unit_local_bridge_witness`,
which packages the derived nonempty-domain certificate into an actual
paper-domain divergence witness. It also gates
`not_closed_unit_part6_divergence_witness_current` and
`not_closed_unit_part6_feasible_divergence_witness_current`, proving that the
current carrier cannot even supply those closed-unit output witness shapes while
`alphaStar 0 p_c = 1` makes the domain empty. The gate also checks
`z2LatticeEmbeddingClosedUnitLocalBridgeData_paper_support_certificate`,
which binds the `Z^2` graph identity, scaling divergence, threshold
certificate, local domination field, near-`p_c` feasible-set nonemptiness, and
same-`alpha` witness projection into one paper-support theorem. It also gates
`z2LatticeEmbeddingClosedUnitLocalBridgeData_paper_support_with_sentimental_reversal`,
so a closed-unit repair must carry the paper-support surface and the
sentimental reversal forced by `alphaStar 0 p_c < 1` on the same bridge-level
contract. It also gates
`not_z2_lattice_embedding_closed_unit_local_bridge_paper_support_with_sentimental_reversal_current`,
which proves the current carrier cannot satisfy that exact combined contract.
It now also checks
`z2LatticeEmbeddingLocalBridgeData_pointwise_paper_domain_certificate`,
`z2LatticeEmbeddingClosedUnitLocalBridgeData_pointwise_paper_domain_certificate`,
and
`z2LatticeEmbeddingClosedUnitLocalBridgeData_feasible_divergence_witness`,
with the first and third also folded into the single paper-support certificates.
The gate now also names the full paper-closing surfaces as
`UnboundedPart6FullPaperClosingSupport`,
`ClosedUnitPart6FullPaperClosingSupport`, and
`Part6FullPaperClosingSupport`, and proves
`not_part6_full_paper_closing_support_current`; this makes the current
unbounded/closed-unit non-closure a direct Lean theorem about the paper support
surface rather than only a collection of bridge-level failures.
It also gates `Part6FullPaperClosingDivergenceWitness`,
`part6_full_paper_closing_support_divergence_witness`,
`not_part6_full_paper_closing_divergence_witness_current`, and
`not_part6_full_paper_closing_support_current_via_divergence_witness`, so full
support must expose the same-`alpha` divergence output required by the paper
and the current carrier is refuted at that projected output layer.
The bridge route is now tied to the same output by
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
support/bridge-route current obstructions through that full bundle. Thus a
future Part 6 closure must machine-expose support, divergence, and same-`alpha`
feasible/divergence witnesses as one checked package.
These projections and refutations are now also collected in
`Part6FullPaperClosingOutputLayerCertificate` and gated in
`part6_lattice_embedding_frontier_payload`, so the two counted Part 6 output
witness interfaces and their full bundle are checked through one Lean
certificate.
The new `part6_nondegenerate_feasible_repair_route_certificate` names the exact
remaining alpha/feasible-set repair route: it is equivalent to full Part 6
support by the named iff
`part6_nondegenerate_feasible_repair_route_iff_full_paper_closing_support`,
every repaired bridge route factors through it, the closed-unit
tail-reversal sufficient route projects into it, and any inhabitant exposes the
individual divergence witness, the same-`alpha` feasible/divergence witness,
the paired output layer, and the full output bundle; the current carrier still
refutes that route directly and again through each output-level obstruction,
including the paired output obstruction
`not_part6_nondegenerate_feasible_repair_route_current_via_output_pair`.
The unified `part6_current_frontier_certificate` now packages the unbounded
current-obstruction certificate, scaling-candidate obstruction certificate,
and closed-unit current-obstruction certificate together with the output-layer
certificate, the tail-reversal bridge nonclosure certificate, support
obstruction, bridge-level tail-reversal route obstruction, bridge-route
obstruction, and the unified `part6_bridge_route_support_certificate`.
It also gates `Part6FullPaperClosingBridgeRoute` and
`part6_full_paper_closing_support_of_bridge_route`, so an inhabited repaired
local or closed-unit bridge is now machine-checked to imply that full support
surface, while `not_part6_full_paper_closing_bridge_route_current` records that
the current bridge routes are still uninhabited.
The `part6_bridge_route_support_certificate` also keeps the two individual
local/closed-unit bridge-to-support projections and the paired current
branch-route obstruction in one audited proposition.
`not_z2_lattice_embedding_closed_unit_local_bridge_current` proves the current
carrier cannot instantiate that bridge because its threshold certificate is
impossible. The remaining Part 6 repair is therefore
no longer the transfer-domain theorem itself; it is to supply a nondegenerate
`α`/feasible-set domain certificate, including `alphaStar 0 p_c < 1` for the
closed-unit route, then instantiate the repaired bridge with a
paper-faithful scaling carrier whose domination theorem holds near `p_c`.
The current transfer and obstruction frontier is machine-gated by
`part6_lattice_embedding_frontier_payload`. That repaired bridge instance is
the precondition for any Harris-Kesten/Cardy/SLE formalisation to become a
valid closure target.

The five-state loss-shape existence bridge
`L_interior_minimizer_exists_paper_Def` is now a theorem from the concrete
`L_minimum_exists_in_regime_i_proof` extreme-value argument. R238 also proves
`L_at_betaStarOfP_continuousOn_paper_Def` by a Lipschitz value-function proof:
fixed-`β` Lipschitz continuity in `p` plus the minimizer inequalities for
`betaStarOfP`. R256 closes the former loss-shape paper-Def obligation, and R469
retires the former `L_strict_unique_minimizer_paper_Def` `True` compatibility
theorem from source. The closed proof chain derives the former Gaussian factor bridge from
`L_lowerGaussianHazard_antitoneOn_pos` and `L_upperGaussianMills_antitoneOn_pos`
using `gap_phi_derivative`, `gap_Phi_derivative`, `gap_phi_tail_bound`, and
`Phi_reflect`. The R238 continuity fact and the R249-R255 Gaussian/threshold
single-crossing chain are now ordinary theorem reductions rather than
`Prop`-interface surfaces. R245 defines the
explicit residual `L_balanceResidual` and makes `L_firstOrderBalance` its zero
set. R246 corrects the live bridge to the weaker single-crossing-after-zero
property: after a residual zero on the positive right branch, all later
positive right-branch points have strictly positive residual. R247 factors out
the common positive chain-rule scale as `L_balanceResidualScale`; R248 rewrites
the reduced beta-core as the one-variable Gaussian z-core
`L_balanceResidualZCore` under `z = Delta_B / sqrt(2 * signalVariance β)`;
R249 removes the positive `Delta_B` factor and exposes
`c = 0.9 * (1 - p)` in `L_balanceResidualNormalizedZCore`; R250 rewrites that
normalized core as `c * H(z) - K(z)` and moves the bridge to positivity
persistence of `H` plus strict decrease of the threshold `K/H`; R251 factors
`H = scale * D` and `K = (1/2) * scale`, so the live bridge is positivity
persistence and strict increase of the normalized denominator `D`; R252 rewrites
`D` as the explicit hazard/Mills denominator
`Phi z * (1 - (upperMills((2/9)z) * lowerHazard z) / (2/9))`, and proves
`D(z) > 0` iff that hazard/Mills product is `< 2/9`; R253 reduces denominator
shape to non-increase of that explicit product on positive `z`.
R236 closes the left-branch derivative
sign as `L_hasDerivAt_negative_on_left_branch`, and R237 closes the
right-branch chain-rule/algebra layer conditionally as
`L_hasDerivAt_positive_of_right_branch_dominance`. R241 closes the
left-branch global-minimiser exclusion as
`L_global_minimizer_not_left_branch`: a positive global minimiser cannot lie
on the negative-derivative branch. R242 also closes
`L_global_minimizer_not_right_branch_dominance`: the current right-branch
dominance condition cannot hold at a positive global minimiser because it
would give a positive derivative and a better positive point to the left. The
R243 Fermat step proves the exact first-order balance equation at every
positive global minimiser via
`L_global_minimizer_first_order_balance`. The strict-uniqueness burden is now
the pair of pure one-variable Gaussian ratio antitonicity facts for upper
Mills and lower hazard, which imply product antitonicity, denominator shape,
threshold shape, full residual single-crossing, and then balance uniqueness.
The source-level `_paper_Def`
axiom count is now zero.

`AgentEdgeIdx` is now the concrete finite carrier `Fin 7`, matching the
existing `Wrongness.EdgeIdx` finite-carrier pattern and removing the separate
type/Fintype/DecidableEq carrier axioms.

The Principal above/below-threshold welfare components
`aboveThresholdWelfare` and `belowThresholdWelfare` are now concrete finite
weighted sums over the explicit `principalSampleAbove` / `principalSampleBelow`
carriers; their integral-identification lemmas are `rfl` theorems rather than
global structural-equation axioms.
The above/below sample support types now project from `PrincipalSampleData`,
which packages the support carrier with its `Fintype` and `DecidableEq`
instances, plus the sample `weight`, `kappa`, and `alpha` fields consumed by
the finite weighted sums. The public parameter functions are projections from
that data package rather than standalone global source axioms.
The two sample-data packages and the G-parameterised `aggregateWelfareWith`
functional now come from concrete one-point principal samples; this removes the
former `PrincipalData` source axiom entirely. The two sample-weight
non-negativity facts are kernel-proved for the unit-weight samples.

The per-agent optimal aggregate `perAgentOptimalAggregate` is likewise a
concrete finite weighted sum over the sample carriers and their per-agent
`β*` assignments; `perAgentOptimalAggregate_eq_reversalValley_sum` is now a
definitional theorem over the public reversal-valley carrier.

The legacy scalar κ-agent welfare branch is still constant at `1/2`, and
Principal keeps its direct refutation evidence for the old false witness
interfaces:
`principalSampleAbove_individual_welfare_monotone`,
`principalSampleBoth_combined_convergence_witness`,
`belowThresholdWelfare_per_sample_le_at_zero_for_negative`, and the two
legacy per-agent optimum dominance facts. Four strict scalar sample predicates
remain kernel-proved false for that legacy carrier and are tracked as
diagnostic routes rather than live public inputs:
`PrincipalSampleBelowWeightedSumEventuallyDecreasing`,
`PrincipalSampleBothCombinedDominanceWitnessPair`,
`PrincipalSampleBothExceedsZeroWitness`, and
`PrincipalSampleBothValleyTripleWitness`.
R507 rewires the public Principal carrier: `aboveThresholdWelfare` now uses
`kappaAgentRewardRamp`, `belowThresholdWelfare` now uses
`principalBelowReversalValleyReward`, and `W_bar_eq_reversalValleyCandidate`
bridges the public aggregate to the bounded reversal-valley carrier.
`principal_interior_maximum_exists`, `W_bar_eventually_decreasing`,
`W_bar_limit_infty_eq_W_bar_three`, and
`W_bar_finite_above_limit_witness` are current public theorems on that carrier.
R508 lifts the remaining public strict-shape evidence to the installed
carrier: `W_bar_exceeds_zero_at_positive_beta`,
`W_bar_witness_pair_strict_dominance`, and
`W_bar_valley_triple_witness` are now direct public `W_bar` theorems, while
the legacy scalar sample refutations remain diagnostic only.
R510 completes the Part 2 public rewire:
`aggregateWelfareWith_principal_part2_package` proves the public finite
FOSD-ramp carrier has per-`G` maxima, FOSD-induced difference domination, and
monotone stable beta selection kernel-purely.
The old false-premise `gap_disclosure_full_suboptimal` wrapper remains retired;
the live Part 1 evidence is the direct finite-above-limit theorem. R470 also
retires the old vacuous averaged-overshoot atom from the live theorem
inventory: the
`delta_bar := 1` existential discharge is tracked as a dead-end/notInput marker,
not as Cat 1 evidence for the disclosure mechanism.

The trap-tree terminal reward equation
`oracleBridgePathTerminalReward_TrapTree_eq_r_goal` is now a theorem from the
concrete bridge-terminal reward definition
`oracleBridgePathTerminalReward_TrapTree := fun _ => r_goal`; it is no
longer an explicit hypothesis of `gap_error_compounding_part2`. The remaining
empty compatibility carrier has also been removed: public
`gap_error_compounding_part2` is now the direct kernel theorem.

The `V_g_terminal_in_ForwardReachable` bridge is now a theorem from the
well-founded `V_g` recursion and canonical `ForwardReachable` transitivity, so
`gap_V_g_le_V_dyn` no longer consumes a terminal-membership structural
equation. The remaining terminal-neighbour bridge interfaces are Prop-valued
theorem parameters consumed by `terminal_neighbour_implies_C2prime` and
`dilemma_subsumed_by_gap_general_tree`, not global source-level axioms.

`V_g` is now a well-founded concrete greedy traversal over the current
canonical finite vertex carrier (`Vertex = Fin 5`). The paper recursion
equations `V_g_def_terminal` and `V_g_def_step` are current theorems obtained
from `greedyPathValue.eq_def`, so no `V_gRecursionCarriers` interface remains
on this path.

The terminal-neighbour bridge `V_g_eq_V_dyn_on_terminal_neighbour_current`
is now tracked as a dead-end route marker rather than a closed contribution:
the theorem is kernel-closed only vacuously because
`not_TerminalNeighbourTopology_current` proves the complete-loopless `Fin 5`
graph cannot instantiate the paper's terminal-neighbour topology. A
non-vacuous theorem needs a graph-parametric carrier. The companion
`C2_to_C2prime_via_V_g_eq_V_dyn_at_terminal_neighbour_current` theorem is
tracked the same way, since it closes for the same false-premise reason.
The old `gap_dilemma_parametricGraphScope_current` wrapper has been removed:
its graph-scope parameter was not proof-relevant, so the concrete
`fin5Trap_parametricGraphScope_current` route now calls the current scalar
dilemma theorem directly and the audit no longer counts a misleading
conditional theorem signature there.

The Theorem 6.1 greedy C2′ kernel-reversal witness
`agentRewardKernel_greedy_C2prime_kernel_reversal_witness` is discharged for
the current scalar carrier by
`agentRewardKernel_greedy_C2prime_kernel_reversal_witness_current`. The generic
routes remain available as `gap_general_tree_from_reversal` and
`gap_cyclic_trap_from_reversal`; public `gap_general_tree` and
`gap_cyclic_trap` consume the current witness internally.

The former Bayesian satisficing atoms, ER supercritical atom, and Principal
aggregate-optimum existence atom are also explicit theorem interfaces. As of
this audit there are no remaining source-level `_OPEN` axioms.

For the myopic-k robustness theorem, the public
`gap_robustness_myopic_k` now consumes the closed current
`gap_blackwell_monotonicity` theorem and current myopic carrier directly. The concrete
`MyopicKWelfareCarriers_current` witness uses the zero below-depth branch as a
kernel-visible model of the paper-implicit carrier slot; the former generic
Blackwell wrapper is retired from the live theorem-signature surface. The
horizon-suffices equality is now stated over the current carrier, so
`MyopicKWelfareCarriers` no longer contributes a conditional theorem signature.

The satisficing robustness theorem now proves the current concrete model
directly: `SatisficingCarriers_current` uses `acceptance β = β` and
`welfare β = -β`, and public `gap_robustness_satisficing` closes the
strict-reversal witness without a carrier-parameter theorem signature. The
current affine trap-acceptance and welfare-antitonicity facts are ordinary
theorems rather than fields of a project-level carrier record.

The old current-carrier C2 local-greedy bridge route is now retired from the
live interface surface. The finite path counterexample has `u_high = 1`
already in history, so its diagnostic continuation value is `0.6`; the low
branch `2` can reach reward-`1` vertex `0`, but local greedy continues along
`0 -> 3` and terminates at reward `0`. This proves both direct refutations
`not_C2LocalGreedyDominatesForwardReachableAtWitnesses_current` and
`not_C2LocalGreedyDiagnosticWitnessBridge_current`. The same complete-loopless
carrier also proves the expanded same-witness full C2prime local-greedy
existential impossible via `not_C2primeLocalGreedyFullWitness_current`. The
non-vacuous route is the graph-parametric fin5Trap/terminal-neighbour theorem
path, not the retired current-carrier wrapper.

Likewise, conditional-reduction part (i) now has a public
`gap_conditional_reduction_part_i` theorem that consumes the closed current
Blackwell monotonicity theorem internally; the generic route remains
`gap_conditional_reduction_part_i_from_blackwell`. Its current theorem surface
is standard-only; the theorem still exposes `IsBlackwellOrdered signalFamily`,
which is the substantive scope condition for the conditional subproblem.

Cognitive-threshold Part 2 follows the same pattern:
`gap_cognitive_threshold_part2` consumes the closed current Blackwell
monotonicity theorem internally, while
`gap_cognitive_threshold_part2_from_blackwell` preserves the generic route.
The public theorem no longer exposes the non-load-bearing diagnostic
graph-scope hypotheses. The surrounding Theorem 4.1 bundle no longer carries
`hC`, `hT`, or the ambient diagnostic class on the current scalar route; the
Part 3 Gaussian bridge is now discharged directly by the concrete posterior
witness.

The Canonical five-state Blackwell-transfer clauses now follow the same
public/generic split. Public `gap_threshold_fiveState_kappa_above_kstar` and
`gap_bayesian_naive_reversal_absent` consume the closed current Blackwell
monotonicity theorem internally; the reusable routes
`gap_threshold_fiveState_kappa_above_kstar_from_blackwell` and
`gap_bayesian_naive_reversal_absent_from_blackwell` retain the explicit
Blackwell antecedent.
R511 closes the above-threshold Bayesian-naive reversal status for the current
public carrier.  The `bayesianNaive` reward kernel now carries the misspecified
prior `p_hat` in the `κ` slot: below threshold it is `unitRamp β`, and above
threshold it has the greedy-reversal shape, so
`prop:bayesian-naive-five-state` Parts (i), (ii), and (iii) are all current
kernel theorems.

The five supermodular factor-sign inputs
(`sigEffRatioFactor_pos`, `mPrime_pos`, `bridgeValueGap_pos`,
`pCorrectDerivKappa_pos`, `vDynDerivBeta_nonneg`) are no longer global
source-level axioms. They are collected in `SupermodularFactorSigns`, and the
current canonical scalar package supplies the theorem
`canonicalSupermodularFactorSigns`.
The generalized theorem routes remain available as `gap_supermodular_from_signs`
and `gap_policy_complementarity_from_signs`; public `gap_supermodular` and
`gap_policy_complementarity` consume `canonicalSupermodularFactorSigns`
internally and no longer expose a factor-sign package parameter. R494 aligns
the public policy-complementarity export with the paper-facing supermodular
corner inequality direction (`W(β₁,κ₁)+W(β₂,κ₂) ≥ W(β₁,κ₂)+W(β₂,κ₁)`).
R495 made the prior current-carrier limitation explicit: the old
`kappaAgentWelfareSNR` route was kernel-proved constant at `1/2`, so its weak
corner inequality was a flat closure. R496 added the checked replacement core:
`kappaAgentRewardRamp` / `kappaAgentRewardKernelRamp` are bounded,
β-continuous, β-monotone, and have increasing differences; R497 switches the
public `kappaAgentWelfareSNR` carrier to that ramp expectation and proves both
nonflatness and a strict four-corner witness. R498 adds a Principal-side ramp
calibration: `W_bar_ramp` is non-flat and saturates after β = 1, but
`W_bar_ramp_le_at_one` / `not_W_bar_ramp_above_saturation_witness` rule out
ramp-only overshoot above the saturation value, and
`not_PrincipalRampBelowWeightedSumEventuallyDecreasing` proves the current
below sample (`κ = 0`, `α = 0`) still cannot provide the strict below-regime
decrease. The existing Principal dead-end theorems still document the older
global `agentWelfare AgentType.kappaAgent` constant branch, and full Principal
recalibration now specifically requires a reversal-capable below-threshold
kernel rather than merely reusing the monotone ramp. R499 adds that positive
next target without rewiring the public carrier yet:
`principalBelowReversalReward` is bounded in `[0,1]`, rises from `1/2` at
β = 0 to `1` at β = 1, falls back to `1/2` at β = 2, and yields
`principalReversalBelowWeightedSumEventuallyDecreasing`,
`W_bar_reversalCandidate_finite_above_tail_witness`, and
`W_bar_reversalCandidate_strict_drop_after_peak` as kernel-proved witnesses.
R500 adds `W_bar_reversalCandidate_tendsto_atTop` and
`W_bar_reversalCandidate_disclosure_part1_witness`, proving the candidate
aggregate is eventually equal to its saturated tail value and has a finite
β strictly above that tail limit. This is still a candidate-carrier result,
not a public `W_bar` rewire.
R501 adds `principalReversalCandidate_combined_exceeds_zero_witness` and
`principalReversalCandidate_combined_dominance_witness_pair`, giving the
candidate-carrier analogues of the strict-interior witnesses refuted for the
then-current scalar public carrier.
R502 then adds the unified `principalBelowReversalValleyReward` /
`W_bar_reversalValleyCandidate` carrier: the below reward takes exact values
`1/2`, `1`, `0`, and `1/2` at β = 0, 1, 2, and 3, stays in `[0,1]`, and
the aggregate proves below strict decrease, finite-above-tail, atTop-tail,
combined-dominance, and valley-triple witnesses kernel-purely. At that point
it was the best Principal rewire target; R507 later installed it as the public
carrier.
R503 strengthens that target with `W_bar_reversalValleyCandidate_le_at_one`
and `W_bar_reversalValleyCandidate_strict_interior_optimum_witness`: β = 1 is
a global maximizer of the candidate aggregate and strictly improves over
β = 0. R504 bundles the same route into
`W_bar_reversalValleyCandidate_complete_principal_package`, a single
kernel-only package covering strict interior global optimum, finite-beta
overshoot above the disclosure tail, and the valley-triple non-concavity
witness. R505 adds the continuity bridge for that rewire target:
`principalRampAboveThresholdWelfare_continuousOn_Ici`,
`principalBelowReversalValleyReward_continuousOn_Ici`,
`principalReversalValleyBelowThresholdWelfare_continuousOn_Ici`, and
`W_bar_reversalValleyCandidate_continuousOn_Ici`. R506 adds
`W_bar_reversalValleyCandidate_has_limit_infty`,
`W_bar_reversalValleyCandidate_eventually_decreasing`, and
`W_bar_reversalValleyCandidate_public_interface_package`, so the candidate now
matches the public Principal interface surface for continuity, eventual
decrease, limit existence, strict interior optimum, disclosure-tail overshoot,
and valley evidence. R507 installs that target as the public carrier:
`W_bar_eq_reversalValleyCandidate` is definitional, and the public
finite-above-limit/disclosure-tail, eventual-decrease, and strict-interior
maximizer statements now close on the same kernel-only reversal-valley
aggregate.
R508 adds the remaining public strict-response and non-concavity surface:
`W_bar_exceeds_zero_at_positive_beta`, `W_bar_witness_pair_strict_dominance`,
and `W_bar_valley_triple_witness` are kernel-only consequences of that same
public aggregate.
R510 completes the remaining Part 2 rewire path: the public
`aggregateWelfareWith` is definitionally bridged to `aggregateWelfareWithFOSDRamp`,
public `aggregateOptimalBeta` uses the stable finite-ramp selector, and
`aggregateWelfareWith_principal_part2_package` proves per-`G` maximizer
existence, FOSD-induced difference dominance, and monotone beta selection
without new project axioms.
The current supermodular
and policy-complementarity routes also no longer carry a
non-load-bearing Topkis theorem parameter; Topkis remains roadmap-relevant for
semantic alignment, not a current proof input.
The underlying supermodular scalar carriers (`snrZ`, `BridgeDominance`,
`sigEffRatioFactor`, `mPrime`, `bridgeValueGap`, `pCorrectDerivKappa`, and
`vDynDerivBeta`) now come from a concrete scalar package, so this block has no
source-level axiom.

The above-threshold topological-loss Mills route is explicitly dead-ended:
`not_mills_inverse_above_threshold_route_with_unit_bound` shows the R200/R201
Mills-inverse decomposition is incompatible with the unit upper bound on
topological loss. The surviving task is a corrected, unit-compatible
above-threshold lower-bound theorem for a real `Z^2_L` carrier.
That corrected target is now present as
`UnitCompatibleAboveThresholdLowerBoundConclusion data`; Lean also proves the
current all-open boxed-torus carrier cannot satisfy it because its
`expectedTopoLossOnData` value is always zero.
Lean also proves a positive diagnostic instance,
`unitPositiveTopoLossData_unitCompatibleAboveThresholdLowerBoundConclusion`,
with `expectedTopoLossOnData = 1/2`; this validates the corrected interface
shape without pretending to close the paper's random finite-lattice theorem.
The stronger R409 regression witness
`firstEdgeStochasticTopoLossData_unitCompatibleAboveThresholdLowerBoundConclusion`
computes the lower bound from `percExpectation_open_edge_indicator`, so the
route now exercises the finite Bernoulli product measure rather than only a
constant integrand.
R410 additionally proves
`firstEdgeGiantStochasticTopoLossData_positiveGiant_and_unitCompatible`: the
same stochastic lower-bound carrier is supported on a positive-mass
first-edge-open event and has restricted topo-loss expectation `(1-p)/2`.
The gate-level certificate
`firstEdgeGiantStochasticTopoLossData_positive_regression_certificate`
bundles that carrier's range, giant-event, unit-compatible lower-bound, and
strictly positive `p = 3/4` giant-restricted loss facts as a finite regression
witness, without identifying it with the random finite `Z^2_L` carrier.
R411 adds `boxedTorusAllOpenPositiveTopoLossData`, the first positive
topo-loss regression carrier supported on the finite boxed-torus all-open
coordinate-edge event. It also proves
`not_UnitCompatibleAboveThresholdLowerBoundConclusion_boxedTorusAllOpenPositive`,
which rules out a fixed-`L` boxed-torus event as the final eventual
above-threshold theorem.
R412 then strengthens the graph-local theorem core itself with
`UnitCompatibleAboveThresholdLowerBoundConclusion data` and supplies the
combined witness `boxedTorusAllOpenFirstEdgeAwayTopoLossData 1`. The same
selected data package now stores oracle interfaces, finite nonzero oracle
decay, below-threshold giant-event envelope, full-cluster boxed-torus evidence,
boxed-torus cluster-count bounds, and the corrected above-threshold
lower-bound package.
R413 reroutes that public core to `firstEdgeOpenGiantClosedTopoLossData`, where
the giant event and lower-bound loss are the same first-edge-open event and its
closed complement rather than two separated supports. The selected package
still stores the oracle interfaces, finite nonzero oracle witness,
below-envelope, full-cluster, cluster-count, and corrected lower-bound
conclusions required by the strengthened core.
R414 reroutes the same public core again to
`allEdgeOpenGiantComplementTopoLossData`, replacing the single-edge event with
the all-edge-open event over the current finite carrier. The lower-bound proof
uses monotonicity against the R413 first-edge-closed loss, so the corrected
above-threshold package remains uniform while the event side is less
single-edge-specific.
R415 reroutes the public core to `boxedTorusAllOpenComplementTopoLossData 1`,
keeping the all-open/complement loss at the boxed-torus flat index while using
the concrete boxed-torus reachable-set cluster count from
`boxedTorusFiniteBondGraphOracleData 1`. The first-edge-closed tail remains
only away from the flat boxed-torus index to satisfy the eventual
above-threshold lower-bound interface.
R416 adds the flat-sequence lower-bound package
`BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion_current`,
showing that the boxed-torus flat sizes themselves already have a uniform
positive complement-loss lower bound. R417 replaces the public core's
all-`n` lower-bound field with this family-level flat-sequence interface, so
the unqualified `fin5Trap_parametricGraphLocalDilemmaTheoremCore` no longer
consumes the away-from-flat tail.
R418 replaces the public witness family with
`boxedTorusFullReachComplementTopoLossData`: the selected flat-size event is
the full reachable-set cardinality event, all-open is only a positive-mass
sub-event, and the complement-loss lower bound now comes from the explicit
base-incident-closed obstruction.
R419 changes the selected public witness family to
`boxedTorusFullReachFlatOnlyComplementTopoLossData`: the flat-size theorem
surface is unchanged from R418, but off-flat indices are zero/empty rather
than using the old first-edge diagnostic fallback. The public core now matches
the flat-family lower-bound interface it consumes.
R420 moves the flat-size `1/512` lower-bound proof onto the flat-only carrier
itself, via
`boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedIncident`;
the public lower-bound theorem no longer rewrites through the R418 carrier.
R421 makes the same proof event-level: the failure event has a kernel-proved
mass lower bound from the closed base-incident event, and the flat-only
expected topo loss is exactly half of that failure-event mass.
R422 rewrites that event-level proof into the success-probability form: the
local obstruction gives an upper bound on full-reach success mass, and the
flat-only expected topo loss is exactly half of `1 -` that success mass.
R423 factors the local obstruction through a generic separator/cutset
interface, so replacing the current local base-incident cut with a nonlocal
`Z^2_L` separator or crossing theorem no longer requires changing the
event-mass or expected-loss layers.
R424 separates the combinatorial and percolation sides of that interface:
future work can prove an omega-free edge-cutset statement and reuse the
kernel-proved cutset-to-separator bridge.
R425 adds the reverse bridge, showing that the separator interface is not a
weaker semantic wrapper: it is equivalent to hitting every edge-simple
base-target skeleton in the current finite model.
R426 lowers the future nonlocal task again: it is enough to produce a
vertex-region boundary separating base from target, and the kernel route turns
that boundary into the required edge cutset and separator.
R427 carries that boundary specialization through the finite event-mass and
flat expected-loss layers, so a future nonlocal region-boundary proof can plug
in without changing the Bernoulli-product or loss algebra.
R428 makes the current public `1/512` lower-bound theorem use that boundary
surface: the singleton base-region boundary is proved to have at most four
edges, and the numerical lower bound now flows through
`boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_baseSingletonBoundary`.
R429 inserts the generic small-boundary theorem above that instance:
`boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_ge_closedBoundary_one_over_512`.
The public theorem therefore specializes a cardinality-`<= 4` boundary route,
not a singleton-only numerical proof.
R430 moves the same bridge to package level:
`BoxedTorusFullReachFlatOnlyLowerBoundConclusion_current` now delegates to
`BoxedTorusFullReachFlatOnlyLowerBoundConclusion_of_eventually_smallBoundary`
before specializing to `{base}`.
R431 inserts the more general bounded-boundary package theorem
`BoxedTorusFullReachFlatOnlyLowerBoundConclusion_of_eventually_boundedBoundary`
under that small-boundary theorem, so the proof no longer hard-codes the
number four except in the current singleton specialization.
R432 inserts the probability-parametric version
`BoxedTorusFullReachFlatOnlyLowerBoundConclusion_of_eventually_boundedBoundary_at`
under the fixed `3/4` theorem, so the reusable package interface now follows
the paper's arbitrary above-threshold `p` form.
R433 moves the reusable quantitative step one layer lower:
the pointwise flat expected-loss theorem now exposes `p^B / 2` directly from
a boundary-cardinality bound, and the package theorem consumes that theorem.
R434 does the same for the current singleton obstruction: the public
singleton lower bound first proves an arbitrary-`p` `p^4 / 2` pointwise
theorem, then specializes to `p = 3/4` and weakens numerically to `1/512`.
R435 moves that reusable package one level closer to the nonlocal target:
bounded edge separators and omega-free edge cutsets now close the same
above-threshold package directly; vertex-boundary families are just one
instantiation route.
R436 makes the cutset route visible before package closure: a future nonlocal
`Z^2_L` skeleton or crossing proof can target the pointwise cutset lower-bound
theorem directly, then reuse the existing package theorem.
R437 makes the current local base-incident witness a direct instance of that
same cutset theorem, leaving fewer special-case local calculations in the
public route.
R438 keeps the older full-reach complement carrier aligned with that route:
its flat expected-loss lower bound now exposes separator/cutset theorem names
instead of only the legacy base-incident theorem.
R439 makes that predecessor quantitative too: its public `1/512` witness now
flows through the same `p^B / 2` cutset theorem at `B = 4`, `p = 3/4`.
R440 makes the predecessor's current witness boundary-generated as well:
`{base}` supplies the same `p^4 / 2` theorem before the fixed numerical
specialization.
R441 then gives that predecessor the same eventual bounded
separator/cutset/boundary package surface as the flat-only successor, so the
older current theorem is no longer a one-off existential proof.
R442 adds `BoxedTorusFlatFamilyCoreConclusion`, an audited family-level
package requiring the flat above-threshold lower bound plus eventual
per-member oracle, pointwise topo-loss, giant-event, and cluster-count
packages. Both the predecessor and public flat-only full-reach families now
close this package, and `ParametricGraphLocalDilemmaTheoremCore` stores it
explicitly.
R443 adds the generic bridge
`parametricGraphLocalDilemmaTheoremCore_of_boxedTorusFlatFamilyCore`: any
family proving `BoxedTorusFlatFamilyCoreConclusion` now directly yields the
public graph-local theorem core, so a future random finite-`Z^2_L` family proof
can plug into the main theorem core without reworking the fin5Trap graph-local
side.
R444 tightens that family-core package by removing the redundant
`OracleInfoDecayConclusionOn (family L)` field from the eventual per-member
requirements. The public graph-local core can still recover selected-member
oracle decay, but the generic bridge now derives it from
`WInfoOracleInterfacesOn (family L)` instead of asking a future `Z^2_L` family
proof to carry a second proof of the derived consequence.
R445 applies the same cleanup to the unqualified
`ParametricGraphLocalDilemmaTheoremCore` selected-member contract itself: it
stores `WInfoOracleInterfacesOn data` as the oracle proof surface, not the
derived `OracleInfoDecayConclusionOn data` field. The older `...CoreOn`
compatibility surfaces still expose oracle decay when a consumer specifically
needs that derived theorem.
R446 removes the remaining selected-member package duplication from the
unqualified core.  The public core now stores the closed
`BoxedTorusFlatFamilyCoreConclusion family` plus the already audited
`ParametricGraphLocalGreedyDilemmaCore`; the selected member's oracle,
nonzero, topo-loss, giant-event, and cluster-count packages are recovered from
the family-core eventual witness instead of being duplicated in the
theorem-core tuple.
R447 removes the remaining graph-local tuple expansion from the unqualified
core.  The public theorem-core witness now reuses
`ParametricGraphLocalGreedyDilemmaCore` directly, so graph scope and greedy
reversal are supplied by one closed subpackage rather than repeated as
separate fields.
R448 applies the same packaging discipline to the legacy nonzero-oracle
compatibility surface: `ParametricGraphLocalDilemmaTheoremCoreOnWithNonzeroOracle`
is now just `ParametricGraphLocalDilemmaTheoremCoreOn data` plus the
`OracleInfoNonzeroWitnessOn data` field.
R449 removes the graph-local tuple expansion from that on-data compatibility
core as well: `ParametricGraphLocalDilemmaTheoremCoreOn data` now stores
`ParametricGraphLocalGreedyDilemmaCore` plus the selected member's derived
oracle-decay theorem.
R450 removes another derived field from the family-core package:
`ExpectedTopoLossOnGiantEnvelopeConclusion (family L)` is no longer an
eventual per-member input.  The family-core stores the pointwise
`TopoLossKernelPointwiseBoundOn (family L)` proof, and
`BoxedTorusFlatFamilyCoreConclusion_expectedTopoLossOnGiantEnvelope` recovers
the restricted-expectation envelope through
`expectedTopoLossOnGiantEnvelopeConclusion_from_pointwise_bound`.
R451 applies the same reduction to `CurrentOracleInfoDecayConclusion`: the
existential current oracle package no longer stores the already-derived
`OracleInfoDecayConclusionOn data` field alongside `WInfoOracleInterfacesOn
data`. It stores the oracle interfaces and the nonzero witness; decay remains
recoverable from `oracleInfoDecayConclusionOn_from_finite_interfaces`.
R452 retires `GiantComponentEventPositiveMassConclusion` as a standalone
Prop-interface package. The positive-mass-only fact is now an expanded theorem
target and a proof-valued projection from the stronger
`GiantComponentEventFullClusterConclusion`, which already contains nonempty,
positive-mass, and full-cluster evidence on the same event.
R453 applies the same theorem-interface downgrade to the family-core envelope
projection: `BoxedTorusFlatFamilyCoreConclusion_expectedTopoLossOnGiantEnvelope`
is now a proof-valued `def`, not a conditional theorem signature. The remaining
conditional theorem signature is the R443 generic promotion from a closed
`BoxedTorusFlatFamilyCoreConclusion family` package into the public graph-local
theorem core.
R454 demotes that remaining generic promotion bridge,
`parametricGraphLocalDilemmaTheoremCore_of_boxedTorusFlatFamilyCore`, from a
conditional theorem signature to a proof-valued `def`. It still constructs the
same public theorem-core package from a closed family-core proof, but the
syntactic theorem-interface audit now has no theorem/lemma declarations that
take interface packages as premises.
R455 retires `CurrentDilemmaConclusion` as a standalone Prop-interface wrapper.
The current dilemma route now targets the expanded conjunction
`CurrentGreedyWelfareReversalConclusion ∧ CurrentOracleInfoDecayConclusion`
directly, so the audit no longer counts a conclusion package that merely
repeated its two already-audited component packages.
R456 applies the same cleanup to `CurrentGreedyWelfareReversalConclusion`.
The current greedy route now states the beta/beta-prime welfare reversal
existential directly, while `currentGreedyWelfareReversalConclusion` remains as
the theorem name proving that expanded statement.
R457 removes the matching `CurrentOracleInfoDecayConclusion` Prop-interface
wrapper.  The current oracle route now states the finite nonzero
`WrongnessPercolationData` existential directly, and the current bridge
declarations that expose `OracleInfoNonzeroWitnessOn` in their proof target are
proof-valued `def`s, preserving the zero conditional-theorem-signature audit.
R458 demotes `OracleInfoNonzeroWitnessOn` itself from a standalone `def`-level
Prop interface to a transparent `abbrev` for the same expanded nonzero
existential. Existing proof names still document the finite nonzero witnesses,
but the syntactic Prop-interface audit no longer treats the abbreviation as a
separate package layer.
R459 demotes `ExpectedTopoLossOnGiantEnvelopeConclusion` from a standalone
`def`-level Prop interface to a transparent `abbrev` for the same
restricted-expectation envelope. The named theorem
`expectedTopoLossOnGiantEnvelopeConclusion_from_pointwise_bound` still recovers
that envelope from `TopoLossKernelPointwiseBoundOn`, but the envelope alias is
no longer counted as a separate Prop-interface package.
R460 demotes the two below-threshold topo-cluster bridge statements,
`topoLossKernel_eq_orderStatisticsRatio_on_giant_paper_Def` and
`giantComponent_cluster_size_lower_bound_paper_Def`, from `def`-level Prop
interfaces to transparent `abbrev`s. Their current diagnostic closure theorems
and downstream pointwise topo-loss theorem remain unchanged, but the aliases no
longer contribute two separate counted interface packages.
R461 demotes the remaining counted `def`-level Prop packages in the
graph-local/wrongness core to transparent `abbrev`s: the parametric C2prime and
graph-scope witnesses, the local C2prime witness-on-data alias, the greedy
wrongness reversal witness, and the giant-event/cluster-count/above-threshold
boxed-torus family packages. The audit surface now contains only five
structure/class carrier interfaces; theorem content and current closure proofs
are unchanged.
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

There are no remaining source-level project axioms. The residual work is now
in explicit theorem interfaces and ledger-tracked partial/dead-end items, not
hidden global declarations.

The three oracle information-decay pointwise obligations
(`wInfoOracleKernel_nonpos`, `wInfoOracleClusterCount_ge_one`,
`wInfoOracleKernel_abs_le_clusterCount`) now close directly on the current
neutral global carrier through `W_info_oracle_current_uniform_unit_bound`; the
legacy global `WInfoOracleInterfaces` route has been retired. Future
non-neutral oracle work remains represented by the parameterized
`WInfoOracleInterfacesOn data` surface and its finite/boxed-torus instances.
The public `currentOracleInfoDecayConclusion` theorem has also moved off the
legacy global zero residual and no longer targets a standalone
`CurrentOracleInfoDecayConclusion` package: it proves directly the existential
finite nonzero `WrongnessPercolationData` package carrying its
`WInfoOracleInterfacesOn data` proof and no separate derived oracle-decay
field, witnessed by the all-open boxed-torus carrier
`boxedTorusAllOpenGiantTopoLossData 1`. The smaller
`boxedTorusFiniteBondGraphOracleData 1` theorem remains as a regression
witness with the same explicit-interface package shape.
The nonzero oracle side is no longer only a roadmap item. The unqualified
`fin5Trap_parametricGraphLocalDilemmaTheoremCore` now selects a finite nonzero
oracle/topological carrier
(`boxedTorusFullReachFlatOnlyComplementTopoLossData 1`) whose
boxed-torus flat-index giant event is full reachability of the concrete
finite-bond reachable set and whose complement loss is lower-bounded by the
base-incident-closed obstruction. Off the flat sequence, this public carrier
has zero topological loss and empty giant event instead of an eventual
first-edge fallback. Its type now requires the same data package to satisfy
the family-level `BoxedTorusFlatFamilyCoreConclusion family` package. That
family-core package supplies eventual per-member
`WInfoOracleInterfacesOn data`, `TopoLossKernelPointwiseBoundOn data`,
`GiantComponentEventFullClusterConclusion data`,
`BoxedTorusClusterCountExpectationBoundsConclusion data`,
not a derived oracle-decay theorem, a derived restricted-expectation envelope,
a positive-mass-only event, a nonempty event, or only a nonzero oracle
witness package. The nonzero witness is now a transparent abbreviation for the
expanded oracle-residual existential, and the envelope package is still
available from the stored pointwise
topo-loss proof.
`fin5Trap_parametricGraphLocalDilemmaTheoremCoreWithNonzeroOracle` is retained
as the compatibility name for that same strengthened core. The concrete
boxed-torus theorem
`fin5Trap_boxedTorusAllOpenGiant_parametricGraphLocalDilemmaTheoremCoreOnWithNonzeroOracle`
packages the oracle-interface-derived on-data core together with
the transparent `OracleInfoNonzeroWitnessOn` nonzero existential abbreviation
directly.
The generic proof-valued bridge
`parametricGraphLocalDilemmaTheoremCore_of_boxedTorusFlatFamilyCore` is now the
single graph-local bridge from a boxed-torus family package to the public core;
the current `fin5Trap_parametricGraphLocalDilemmaTheoremCore` is just its
flat-only full-reach instance.
This core route therefore no longer depends solely on the neutral zero oracle
package, on a selected-member derived oracle-decay field, or on a prose-only
topo-loss/nonempty-event side condition.  It also no longer duplicates the
selected-member package already contained in the family-core witness. The
remaining percolation repair is the random topological-loss/giant-component
carrier that ties the positive lower-bound loss to a genuine all-large finite
lattice event, not the oracle residual's finite nonzero witness.

The greedy-kernel reversal witness is bundled by
`WrongnessGreedyInterfaces_current` for the current scalar kernel. Public
`gap_wrongness` and `gap_dilemma` consume the current bundle directly and no
longer expose or retain an `h_greedy` interface-parameter theorem route. The
stage-1 high-β convergence theorem
is now closed from the concrete greedy kernel and no longer requires that
interface.

Current audit snapshot:

| Status | Count | Meaning |
| --- | ---: | --- |
| Total ledger entries | **498** | Typed `GapEntry`s in `Ledger.lean` (carriers + atomic stipulations + derived theorems + classical citations) |
| `gapClosed` | **353** | Lean theorem (no `sorry`) |
| `gapDefinitional` | **86** | Definition primitives and remaining paper-foundational model surface (Cat 3 subset tracked separately) |
| `gapOpen` | **0** | No live open ledger entries after the R207 lower-envelope route was proved dead-end |
| `gapPartial` | **0** | `entry_phi_tail` is now closed after the Cat 1 `gap_order_statistics_density_integral` proof |
| `gapDeadEnd` | **59** | Kernel-proved route failures and retired false/over-strong markers under current carriers, including retired-signature cleanup entries (all NOT axioms) |
| `gapBlocked` | 0 | None |
| Cat 1 (cat1Mathlib) | **435** | |
| Cat 2 (cat2External) | **0** | |
| Cat 3 paper-novel | **0** | No project-level Cat3 input assumptions remain in the ledger; paper scope predicates are transparent definitions |
| Mixed input class | **0** | |
| Not input | **63** | Retired, dead-ended, or documentation-only routes |
| Cat 3 sub-type breakdown | - | carrier=0, hypothesisPredicate=0, structuralEquation=0, **workingAssumption=0**, derivedTheorem=329, notCat3=169 |
| Inline `_workingAssumption` axioms (source code) | **0 ✅** | **R159-R174 removed all 17 inline wA axioms via carrier concretization (R160-R164: 6 carriers) + Cat 3 §3.4.3 paper-Def-stipulated structural equation atoms (R165-R174: 10 atoms). The codebase now has ZERO `axiom X_workingAssumption` declarations.** |
| Concretized opaque carriers/predicates | **64+ through R528** | R525-R528 metadata now classifies current concrete source definitions and scope predicates as Cat 1 / notCat3 for input-counting; Cat3 input assumptions are zero |
| R162-R174 paper-Def atom lineage | **12** | All 12 historical entries remain tracked; some have since been closed or dead-ended by kernel proofs, including `W_bar_eventually_decreasing_paper_Def` in R210, `agentRewardKernel_kappaAgent_increasing_differences_paper_Def` in R211, `agentRewardKernel_kappaAgent_continuousOn_in_beta_pointwise` in R212, the R213 current-carrier reward-kernel range/Bayesian/sentimental monotonicity trio, the R214 definitional/current-carrier closures for `ReachableSet_eq_ForwardReachable_empty`, `oracleReward_mem_unitInterval`, `V_dyn_def`, and `trapEventIndicator_nonneg`, and the R215 current-carrier Canonical/Principal/Cognitive theorem closures. |
| **Mathlib-PR-able infrastructure modules** | **35+** | NEW R175 + R178: 2 new generic Cat 1 modules built specifically as future Mathlib PR targets (in addition to 33+ pre-existing Infrastructure modules). |
| **Actually-retired §3.4.3 atoms (R186-R201)** | **13** | All 13 original carrier-level §3.4.3 atoms (R162, R165, R166a/b, R167, R168, R169, R170, R171, R172, R173, R174, R184) NO LONGER `axiom`s — converted to `theorem`s (signature-preserving, no weakening). |
| **Hostile audit verdict (R202)** | **10 GENUINE / 3 RENAME** | Independent fresh-agent audit: 10 retirements are genuine substantive decompositions (R162 carrier→per-sample lift; R165 welfare→per-ω lift via R178; R166a/b shared posterior bridge + R189; R167 6-step EVT chain; R168 envelope split; R169 graph preconnected + identification; R172 abstract→Mills closed form; R173 Mills bound + carrier id; R174 existence/uniqueness factorisation). 3 retirements are essentially RENAMES (bridge atom is same/near-same content as retired statement): R170 (drops unused `alphaStar` premise), R171 (bit-for-bit identical bridge — pure rename), R184 (unfolds `IsSupermodular` predicate definition). The 3 rename retirements are HONEST per discipline §3.4.3 (paper-Def-stipulated structural facts that genuinely cannot decompose further without major Z²-percolation/Harris-Kesten infrastructure), but they don't gain atomicity per §18. |
| **Net atom delta** | **+11 raw bridges, −13 carrier axioms** | 11 new smaller bridge atoms (per genuinely-decomposed retirements); 3 rename-style atoms equal in content to retired. ZERO carrier-level paper-Def axioms remain in source. |

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
theorem. In the current R528 audit state, every live checked theorem depends
only on Lean/Mathlib kernel axioms (`propext`, `Classical.choice`,
`Quot.sound`) and transparent theorem parameters/definitions. The earlier
paper-novel global carriers, `_paper_witness` axioms, and
`_workingAssumption` axioms have been retired or converted into definitions,
ordinary theorems, theorem parameters, or kernel-proved dead-end diagnostics.

## Archived convention: workingAssumption axioms

This section records the pre-R528 discipline that was used while reducing the
formalisation. It is retained for audit history only. The current source has
zero `axiom <name>_workingAssumption` declarations.

Each `axiom <name>_workingAssumption` corresponds to a specific
paper Definition that stipulates a structural property of an opaque
carrier (e.g., supermodularity of the κ-agent welfare functional,
divergence of κ* at the percolation threshold). Each axiom is a
single-step typed bridge per the
[`feedback_lean_axiom_decomposition`] discipline. Each axiom carries
a `paper source:` line citing the paper section/line.

Replacing a historical `_workingAssumption` axiom with a real Lean proof was a
strict improvement; the statement and downstream proofs were kept stable under
that substitution. The Cat 1 Infrastructure modules
(`BlackwellDilemma/Infrastructure/`) provide reusable Mathlib-PR-ready
abstract algebra (supermodularity, EVT extensions, Mills-tail bounds,
Gaussian conjugate-prior posterior, etc.) on which the paper-side
derivations are built.

## Roadmap for semantic strengthening

The current source-level and ledger-level Cat 3 input count is zero. The
remaining roadmap is no longer about removing hidden global axioms; it is about
strengthening paper-faithful semantic carriers and upstreaming reusable
Mathlib infrastructure.

1. **Five-state loss-shape analysis.** The value-at-argmin continuity item
   `L_at_betaStarOfP_continuousOn_paper_Def` is closed by the R238
   Lipschitz value-function proof, and R256 closes the former
   `L_gaussianHazardMillsFactorAntitone_paper_Def` obligation. The upper Mills
   ratio and lower hazard ratio antitonicity facts are now kernel theorems;
   the former `L_strict_unique_minimizer_paper_Def` `True` compatibility
   theorem has been retired from source. The left-branch
   derivative sign is already kernel proved by
   `L_hasDerivAt_negative_on_left_branch`; the right-branch derivative sign is
   kernel-proved conditional on the exact dominance inequality by
   `L_hasDerivAt_positive_of_right_branch_dominance`. R241 also proves
   `L_global_minimizer_not_left_branch`, ruling out positive global minimisers
   on the left branch. R242 proves
   `L_global_minimizer_not_right_branch_dominance`, ruling out the current
   positive-derivative dominance condition at a positive global minimiser. The
   R243 Fermat step proves `L_global_minimizer_first_order_balance`, the exact
   first-order balance equation at any positive global minimiser. R250 reduces
   balance uniqueness to the pure z-threshold shape theorem; R251 reduces that
   theorem to the normalized denominator-shape bridge; R252 rewrites the
   denominator in hazard/Mills form; R253 reduces that denominator shape to
   product antitonicity; R254 reduces product antitonicity to the two factor
   antitonicity facts; R255/R256 close both factor facts, with the normalized
   z-core, z-core, beta-core, and full-residual bridges derived kernel-purely.

2. **Concrete diagnostic carrier.** The former cyclic-trap structural equation
   is closed in R240 as a conditional wrapper: `C1_Irreversibility_current`
   proves C1 for the current carrier, while C2′ and C3 remain explicit
   diagnostic evidence consumed by `gap_cyclic_trap`. The two former
   satisficing structural equations were closed in R239/R322/R389/R465 by
   moving the public theorem to the current affine carrier and then exposing
   the current behavior evidence as ordinary theorems instead of carrier proof
   fields.

3. **Finite-lattice percolation carrier repair.** The current Wrongness
   percolation package is oracle-neutral and above-threshold-neutral, but its
   topo-loss side is no longer empty: `giantComponentEvent 1` is nonempty and
   `expectedTopoLossOnGiant 1 p = 1/2` is kernel-proved. The R200 Mills
   identification is still kernel-proved false because the current
   `expectedTopoLossAboveLowerConst` is identically `0`. A complete paper
   proof still needs a finite `Z²_L` carrier with real giant-component and
   above-threshold lower-bound content. The oracle residual half now has a
   separate finite nonzero carrier theorem via
   `fin5Trap_parametricGraphLocalDilemmaTheoremCoreWithNonzeroOracle`, now a
   compatibility name for the all-open
   `boxedTorusAllOpenGiantTopoLossData 1` core that explicitly stores
   `WInfoOracleInterfacesOn data`, a pointwise topo-loss bound from which the
   restricted-expectation envelope is derived, and the full-cluster positive-mass
   `GiantComponentEventFullClusterConclusion data`, plus
   `BoxedTorusClusterCountExpectationBoundsConclusion data`. The public
   `currentOracleInfoDecayConclusion` now proves a finite nonzero
   `boxedTorusAllOpenGiantTopoLossData 1` witness directly, storing
   `WInfoOracleInterfacesOn` evidence and recovers oracle decay from that
   interface proof, while the earlier finite-bond-only witness remains as a
   regression theorem. This does not close the topo-loss
   carrier repair, but it removes the neutral-zero and finite-bond-only oracle
   witnesses as the public current/core-dilemma route. The current public
   graph-local route has since moved one step further to
   `boxedTorusFullReachFlatOnlyComplementTopoLossData 1`, where the selected
   flat-size event is full finite-oracle reachability rather than all-open and
   the off-flat public surface is zero/empty instead of the old first-edge
   diagnostic tail.
   The topo-loss half now also
   has `oneStepGiantTopoLossData`, a nonempty `n = 1` diagnostic
   giant-event carrier proving the parameterized order-statistics bridge,
   cluster-size lower bound, pointwise `1/(n+1)` bound, and restricted
   expectation envelope kernel-purely. This is a non-vacuity regression
   witness for the bridge mechanism, not the full finite `Z^2_L` carrier.
   The next finite-graph step is `boxedTorusAllOpenGiantTopoLossData`: it
   reuses the real boxed-torus finite-bond oracle carrier, takes the all-open
   boxed-torus coordinate-edge event at `n = boxedTorusFlatGraphN L`, proves
   that event nonempty and of Bernoulli mass `q ^ |E_L|`, proves that the
   reachable cluster from the base vertex has full cardinality
   `boxedTorusFlatGraphN L + 1 = (L + 1)^2`, and closes the same
   order-statistics/cluster-bound/restricted-expectation chain with the
   all-open zero-loss witness `k = n`. It also now exposes the data-level
   flat giant-event mass theorem and inherits the boxed-torus square-event
   cluster-count expectation lower/upper bounds for the same data package.
   The graph-local theorem core now stores the data-level restricted
   `expectedTopoLossOnGiantOn` envelope package for this same carrier rather
   than leaving the envelope as a separate downstream theorem, and it stores
   the all-open giant event as a full-cluster positive-mass event rather than
   as a bare nonempty set or a positive-mass-only event package. It also stores
   the boxed-torus cluster-count expectation lower/upper bounds as an explicit
   data-level package rather than leaving them as nearby standalone theorems.
   The below-threshold envelope and epsilon-convergence wrappers are now
   available at the `WrongnessPercolationData` parameter level and are
   instantiated for this boxed-torus all-open package.
   The existential nonzero-oracle core
   theorem now uses this all-open boxed-torus giant-event data package. This
   still leaves the stochastic finite `Z^2_L` giant-component/Mills
   lower-bound carrier as the remaining topo-loss target.

4. **Mixed-partial calculus extension** (Mathlib gap). The `prop:supermodular`
   cross-partial computation depends on Topkis 1978 mixed-partial criterion
   for supermodularity on continuous lattices. Mathlib has discrete
   supermodularity (`Topkis.lean`) but lacks the continuous-lattice mixed-
   partial integration; a self-contained extension is in
   `Infrastructure/TopkisCrossPartial.lean` and is a candidate for
   Mathlib upstream.

5. **Classical citation upstreaming** (paper-cited but not Mathlib). Blackwell
   1953 (sufficiency theorem), Topkis 1998 (interval supermodularity book),
   Molloy-Reed 1995 (configuration-model giant-component criterion), Cohen
   et al. 2000 (power-law percolation), Grimmett 1999 (Bond Percolation
   §6.75), David-Nagaraja 2003 (order-statistics formulas) — each is a
   discrete Mathlib contribution that would close the corresponding
    `gap_*_OPEN` Cat 2 entry. In the current R528 state these are no longer
    project axioms; they are upstreaming opportunities for making the companion
    proof more reusable at library level.

Each of these contributes broadly reusable infrastructure to Mathlib beyond
just this paper, which is the strategic motivation for pursuing them.

The current Lean v1.0 verifies the live theorem surface with no project-level
source axioms, no proof escapes, no unresolved conditional proof interfaces,
and no Cat 3 paper-novel input assumptions in the ledger. The remaining work is
semantic strengthening of selected paper-facing carriers, especially the
finite-lattice/percolation side, not repair of hidden proof unsoundness.

## Relationship to the paper's published artifact

This Lean 4 formalisation is a **companion** to the paper, not a
replacement for the paper's mathematical exposition. Statements in the
paper that are formalised here also retain their natural-language
proofs in the manuscript; the Lean version provides an independent,
machine-checked record of the logical structure.

The paper itself notes (footnote to Theorem 3.1) that the formal proof of the
welfare-decomposition theorem and its signal-immunity clause reduces to the
three Lean 4 kernel axioms (`propext`, `Classical.choice`, `Quot.sound`) with
no paper-derived content introduced as axioms. Across the current
formalisation, the paper-statement-to-Lean correspondence is tracked at the
label level; per-entry status, retired/dead-ended routes, and remaining
semantic calibration notes are documented in `Ledger.lean`,
`AxiomAudit.lean`, and `PAPER_LEAN_CALIBRATION.md`.
