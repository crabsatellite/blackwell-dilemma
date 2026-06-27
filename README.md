# The Blackwell Dilemma

**When Better Information Makes Agents Worse Off Under Endogenous Feasibility Constraints**

[![SSRN](https://img.shields.io/badge/SSRN-6478278-014991?style=flat-square)](https://doi.org/10.2139/ssrn.6478278)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.19251487.svg)](https://doi.org/10.5281/zenodo.19251487)

Blackwell's theorem (1953) states that more informative signals lead to weakly better decisions. We identify a structural boundary: when actions are irreversible and signals are topology-blind, welfare decomposes into a signal-immune topological component and an exponentially vanishing informational residual. Above the percolation threshold $p_c = 1/2$, the Blackwell ordering becomes structurally irrelevant to welfare.

## Interactive Explanation

**[Explore the Blackwell Dilemma](https://crabsatellite.github.io/blackwell-dilemma/explorer.html)** — a step-by-step interactive guide (bilingual zh/en) covering the core ideas, with sliders, games, and live percolation grids.

## Computational Appendix

**[View the computational appendix](https://crabsatellite.github.io/blackwell-dilemma/)** — six experiment families verifying all theoretical predictions, rendered with full math formatting.

## Lean 4 Formalisation

The companion Lean 4 / Mathlib development lives in [`lean4/`](lean4/). It
contains the paper-to-Lean calibration matrix, the gap ledger, the axiom audit,
and source-level kernel-surface audits.

```bash
cd lean4
lake build BlackwellDilemma
lake build BlackwellDilemma.PaperSemanticGate
lake build BlackwellDilemma.AxiomAudit
python scripts/audit_kernel_surface.py
python scripts/audit_conditional_surface.py
python scripts/audit_paper_semantic_gate.py
cd ..
python tools/verify_public_evidence.py
```

The current public Lean package keeps the checked theorem surface
kernel-clean: no project-level source axioms, no proof escapes, no unresolved
conditional theorem interfaces, and no Cat 3 paper-novel input assumptions in
the live ledger. The two remaining counted conditional Prop interfaces are
identity-pinned to the Part 6 divergence and feasible-divergence witness
surfaces, with named current refutation and closure pairs. Complete
paper-semantic closure is separately gated in
`BlackwellDilemma/PaperSemanticGate.lean`; while that gate reports open
Part 6 lattice-embedding and random-supercritical percolation semantic targets,
the project does not claim the stronger full-manuscript semantic closure
status. The Part 4 lattice p-monotonicity target is now closed by the standard
`Z²` ranged local-lattice bridge; the former threshold target is closed by the
one-edge high-κ oracle-routing carrier
`FiveState.highKappaOracleRoutingWelfare_eq_oracle`; the neutral-carrier
refutation remains as diagnostic evidence for the retired route. The topo gate
now also machine-checks all-open/complement boxed-torus giant-event witnesses,
the full-reach `Z^2` boxed-torus bridge with its fixed-`L` all-`n` lower-bound
interface, and the old non-diagnostic
`RandomSupercriticalZ2TopoClusterBridgeData` contract as a kernel-refuted
over-strong route: its uniform giant-restricted lower-bound field contradicts
the pointwise giant-loss envelope along the flattened boxed-torus sizes. The
active closure route is now the repaired
`RandomSupercriticalZ2TopoClusterRepairedBridgeData` surface, which keeps the
standard `Z^2` graph identity, boxed-torus size facts, strict `p_c < p < 1`
parameter, unit-interval loss range, flat expected-loss lower bound,
giant-event mass lower bound, unrestricted positive-loss realisation, and
non-diagnostic tail certificate, while dropping the refuted uniform
giant-restricted loss lower-bound obligation.  The repaired support surface is
now itself kernel-gated by
`RandomSupercriticalZ2TopoClusterRepairedBridgeSupportSurfaceRepair`,
`RandomSupercriticalZ2TopoClusterSupportSurfaceRepairRoute`, and
`random_supercritical_z2_topo_cluster_support_surface_repair_certificate`; it
is a formally inhabited route, not just prose calibration.  Its route-output
certificate,
`random_supercritical_z2_topo_cluster_support_surface_repair_route_output_certificate`,
also projects repaired-bridge nonemptiness, repaired paper support, and the
same-tail flat/mass/member/positive-loss non-diagnostic support output.  The
random-supercritical semantic target remains open until this repaired support
route is instantiated by the real finite-lattice carrier. The
separately named projections machine-exclude the current full-reach, flat-only,
all-open-complement, deterministic all-open giant, and deterministic all-open
positive diagnostic families, including pointwise hybrids assembled from those
diagnostics. It derives an explicit finite member outside the first three
diagnostic carriers, and now also rules out extended eventual diagnostic tails
by deriving arbitrarily large members outside all five deterministic
diagnostic carriers, plus repaired supported tail members where those exclusions
hold at the same sizes as the flat lower-bound, giant-event mass, and
unrestricted positive-loss support. The Part 6 gate now also
machine-checks a generic positive-at-zero obstruction for the old global
domination interface, a repaired local near-`p_c` domination transfer, a
closed-unit local transfer on the explicit `alpha*(0,p_c) < alpha <= 1`
domain, a closed-unit existential paper-domain divergence witness projection,
the explicit near-`p_c` zero branch for the current unbounded `alpha = 2`
domain, the theorem that this zero branch blocks the current local bridge
shape, and the current local-bridge impossibility theorem. It also checks the exact
current unbounded output-witness obstruction:
`mean_estimate_gap_lt_one_of_nonneg_p_of_pos_kappa`,
`kappaStar_eq_zero_of_one_lt_alpha_of_nonneg_p`,
`not_unbounded_part6_divergence_witness_current`, and
`not_unbounded_part6_feasible_divergence_witness_current` prove that the current
carrier cannot supply the unbounded Part 6 divergence or same-`alpha`
feasible/divergence output witness while `alphaStar 0 p_c = 1`.
It also checks the exact
closed-unit domain criterion
`(exists alpha, alpha*(0,p_c) < alpha <= 1) iff alpha*(0,p_c) < 1` and the current
`alphaStar = 1` degeneracy, which makes the paper-bounded `α > α*`, `α <= 1`
domain empty on the present scalar carrier. The remaining repair is therefore
to supply a nondegenerate Part 6 `α`/feasible-set domain certificate, concretely
including an `alphaStar 0 p_c < 1` certificate for this closed-unit route, before
instantiating a `Z²` bridge with a real percolation scaling carrier. The
closed-unit local bridge contract now carries that threshold certificate and
derives the nonempty-domain witness from it, the gate proves the current carrier
cannot satisfy the threshold certificate, and the closed-unit transfer plus
existential witness theorem is ready for any repaired nonempty-domain instance.
The bridge-level tail-reversal output certificate now also projects
`alphaStar 0 p_c < 1`, closed-unit domain nonemptiness, closed-unit bridge
nonemptiness, same-carrier closed-unit full paper-domain support, same-bridge
paper-support plus sentimental-reversal, Part 6 route/support, and the full
output bundle from any future tail-reversal bridge.
It also proves that the current carrier cannot satisfy the closed-unit
paper-domain divergence witness or the stronger same-`alpha`
feasible/divergence witness, so the output shape itself is not vacuously
available while the domain is empty.
The semantic gate now also names the sufficient closure inputs explicitly:
`Part6LatticeEmbeddingClosureInput` would close the Part 6 target through the
tail-reversal bridge route, and
`TopoClusterRandomSupercriticalZ2ClosureInput` would close the topo target
through a repaired bridge with a pointwise-on-giant positive loss floor. Both
inputs are current-refuted and are packaged by
`remaining_open_semantic_targets_closure_input_certificate`.
Their output projections are also gated by
`remaining_open_semantic_targets_closure_input_output_certificate`: Part 6
reaches the divergence, same-`alpha` feasible/divergence, paired-output, and
full-output-bundle surfaces, while the topo input reaches the support-surface
route/output, repaired paper-support output, giant-loss output, full route, and
boxed route.
The semantic gate also separates exact closure inputs from those stronger
sufficient inputs:
`remaining_open_semantic_targets_exact_closure_input_certificate` proves the
Part 6 target equivalent to `Part6LatticeEmbeddingExactClosureInput` and the
topo target equivalent to `TopoClusterRandomSupercriticalZ2ExactClosureInput`;
each sufficient input is checked to project into its exact input, and both exact
inputs remain current-refuted.
The exact inputs are also tied directly to the reversible output layer by
`remaining_open_semantic_targets_exact_closure_input_output_certificate`: Part 6
equates its exact closure input with `Part6FullPaperClosingFullOutputBundle`,
and topo equates its support-surface exact input with
`TopoClusterRandomSupercriticalZ2SameBridgeFullOutputBundle`.
`part6_remaining_conditional_projection_certificate` additionally gates
the Part 6 conditional witness interfaces from both the exact closure input and
the full output bundle, while preserving the current refutations of the
divergence, feasible/divergence, and paired-output interfaces.
`part6_remaining_conditional_projection_statement_roster_certificate` pins
those witness projections and current witness/input/output obstructions in one
build-gated statement list.
`part6_lattice_embedding_route_obstruction_projection_certificate` then gates
the Part 6 route-level negative direction: refuting either the nondegenerate
feasible repair route or full paper-closing support refutes both the exact input
and full output bundle, and those route refutations are equivalent to the Part 6
target obstruction.
`part6_lattice_embedding_route_obstruction_projection_statement_roster_certificate`
pins those route refutation projections, route-obstruction equivalences, and
current Part 6 route/input/output obstructions in one build-gated statement
list.
`topo_cluster_random_supercritical_z2_exact_output_projection_certificate`
similarly projects the topo exact input and same-bridge output bundle to the
full route, boxed finite-lattice route, support-surface repair route/output,
paper-support output, and giant-loss output, while recording that the inhabited
support-surface repair layer still does not close the full or boxed route.
`topo_cluster_random_supercritical_z2_exact_output_projection_statement_roster_certificate`
pins those topo exact-output projections, current route/output obstructions,
and the inhabited support-surface repair route boundary in one build-gated
statement list.
`topo_cluster_random_supercritical_z2_route_obstruction_projection_certificate`
then gates the negative direction: refuting either the full route or boxed route
refutes both the topo exact input and same-bridge output bundle, and those route
refutations are equivalent to the topo target obstruction.
`topo_cluster_random_supercritical_z2_route_obstruction_projection_statement_roster_certificate`
pins those topo route-refutation projections, route-obstruction equivalences,
and current topo route/input/output obstructions in one build-gated statement
list.
`remaining_open_semantic_targets_obstruction_equivalence_certificate` further
proves that, for each open target, the target obstruction, exact-input
obstruction, and output-bundle obstruction are equivalent kernel consequences.
`open_semantic_target_obstruction_equivalence_named_roster_certificate` pins
that negative surface to the named Part 6/topo target, exact-input,
output-bundle, and obstruction rosters.
`remaining_open_semantic_targets_joint_closure_reduction_certificate` packages
the two remaining open targets as a joint closure problem, proving equivalence
between joint target satisfaction, joint exact-input satisfaction, and joint
full-output-bundle satisfaction, with all three joint packages current-refuted.
`remaining_open_semantic_targets_joint_closure_statement_roster_certificate`
pins every joint package projection, equivalence, and current package
obstruction formula in one build-gated statement list.
`remaining_open_semantic_targets_joint_route_obstruction_reduction_certificate`
also packages the same two targets as joint route obligations: joint target
satisfaction, joint target-route satisfaction, and joint closure-route
satisfaction are equivalent, and all three route packages are current-refuted.
`remaining_open_semantic_targets_joint_route_statement_roster_certificate`
pins every joint route-package projection, equivalence, and current package
obstruction formula in one build-gated statement list.
`remaining_open_semantic_targets_bilateral_package_obstruction_certificate`
checks that the joint target, exact-input, output-bundle, target-route, and
closure-route packages can each be refuted from either the Part 6 obstruction
or the topo obstruction.
`remaining_open_semantic_targets_bilateral_package_obstruction_statement_roster_certificate`
pins every single-side package-obstruction projection and every current joint
package obstruction formula in one build-gated statement list.
`open_semantic_target_kernel_surface_route_obstruction_equivalence_certificate`
lifts those route obstructions back to the machine-facing open-target roster:
for every roster surface, `Not target`, `Not targetRoute`, and
`Not closureRoute` are equivalent and synchronized with the typed payload
surface.
`open_semantic_target_frontier_payload_route_obstruction_equivalence_certificate`
repeats the same negative equivalences on the typed frontier-payload roster
itself, anchored back to the kernel roster certificate.
`open_semantic_target_named_route_obstruction_roster_certificate` further pins
the kernel and payload target/route/closure obstruction lists to the named
Part 6 and topo propositions, rather than only checking that the two lists
match each other.
`open_semantic_target_named_frontier_certificate_roster_certificate` likewise
pins the payload, route, closure, progress, nonclosure, and current-frontier
certificate rosters to the named Part 6/topo certificates on both surfaces.
`open_semantic_target_named_route_statement_roster_certificate` pins the
target-route, target-closure, and route-closure equivalence formulas themselves
to the named Part 6/topo statements on both surfaces.
The field-level payloads are additionally gated by
`remaining_open_semantic_targets_closure_input_field_certificate`: Part 6
exposes the closed-unit tail-reversal bridge, nonempty closed-unit domain,
bridge route, and sentimental-reversal paper support; the topo input exposes
the repaired bridge, pointwise-on-giant route, paper/support-surface repair
fields, strict supercritical probability domain, flat and giant-event mass
lower bounds, unit-interval loss range, and boxed-torus family lower-bound
surface.
The output layer is now reversible where that is semantically valid:
`remaining_open_semantic_targets_output_equivalence_certificate` proves the
Part 6 semantic target equivalent to `Part6FullPaperClosingFullOutputBundle`,
and proves the topo semantic target equivalent to the same-witness bundle
`TopoClusterRandomSupercriticalZ2SameBridgeFullOutputBundle`. The older topo
separated-existential output bundle remains only a forward projection, because
its separate witnesses cannot reconstruct one repaired bridge.
Those field payloads are now also listed in the typed
`openSemanticTargetClosureInputFieldSurfaces` roster, with the same ids as the
open semantic targets and with parser-checked payload proofs, reverse
payload-to-input projections, payload/input iff proofs, current payload
obstructions, certificate proofs, and a cross-target field-obstruction
certificate.
`open_semantic_target_closure_input_field_roster_certificate` additionally
pins the named Part 6/topo closure-input, field-payload, payload-obstruction,
and field-certificate rosters, and proves field-payload obstruction equivalent
to sufficient-input obstruction for each field surface.
`open_semantic_target_closure_input_field_statement_roster_certificate` pins
the closure-input-to-field-payload, field-payload-to-closure-input,
payload/input equivalence, and payload/input obstruction-equivalence formulas
to the named Part 6/topo statement lists.
The top-level
`completePaperSemanticKernelOnly_current_obstruction_certificate` also gates
the current non-complete claim against `open=2`, the exact remaining target ids,
and the frontier/surface-roster/payload-route-map/exact-input/output/
field-obstruction certificates.
`completePaperSemanticKernelOnly_current_obstruction_statement_roster_certificate`
pins those top-level obstruction statements as a Lean `List Prop`.
`audit_paper_semantic_gate.py` now parses that top-level certificate body and
fails unless all 40 expected certificate conjuncts are present.
The same audit parses the top-level statement roster and checks all 42 expected
base/certificate terms.
`open_semantic_target_closure_input_named_roster_certificate` now pins the
named sufficient closure-input roster itself, including target/input/current
obstruction/certificate propositions and the target-obstruction to
sufficient-input-obstruction projection.
`open_semantic_target_closure_input_statement_roster_certificate` additionally
pins the sufficient-input-to-target and target-obstruction-to-sufficient-input
formulas to the named Part 6/topo statements.
`open_semantic_target_exact_closure_input_named_roster_certificate` similarly
pins the exact closure-input roster and proves target obstruction equivalent to
exact-input obstruction for each remaining open semantic target.
`open_semantic_target_exact_closure_input_statement_roster_certificate` pins the
target-to-exact, exact-to-target, target-iff-exact, sufficient-to-exact, and
target-obstruction/exact-obstruction formulas to the named Part 6/topo
statements.
`open_semantic_target_exact_closure_input_output_named_roster_certificate`
pins the exact-input/output-bundle roster and proves target, exact-input, and
output-bundle obstructions pairwise equivalent on each surface.
`open_semantic_target_exact_closure_input_output_statement_roster_certificate`
pins the exact-input/output, target/exact-input, target/output, and all three
obstruction-equivalence formulas to the named Part 6/topo statements.
`open_semantic_target_output_equivalence_named_roster_certificate` separately
pins the reversible target/output roster and its target-output obstruction
equivalence.
`open_semantic_target_output_equivalence_statement_roster_certificate` pins the
target-to-output, output-to-target, target/output equivalence, and
target/output obstruction-equivalence formulas to the named Part 6/topo
statements.
`open_semantic_target_obstruction_equivalence_named_roster_certificate` also
pins the target/exact-input/output-bundle obstruction-equivalence roster, so
the negative surface is checked against named Part 6/topo propositions instead
of only anonymous surface fields.
`open_semantic_target_obstruction_equivalence_statement_roster_certificate`
pins the three pairwise obstruction-equivalence formulas to named Part 6/topo
statements.
The unbounded local bridge contract now also requires near-`p_c` feasible-set
nonemptiness and gates a single paper-support certificate tying that
nonemptiness to the `Z²` graph, scaling divergence, local domination, and
paper-facing divergence transfer at the same `alpha`. The closed-unit route
also gates same-`alpha` feasible/divergence certificates, so feasible-set
nonemptiness and the Part 6 divergence witness cannot be checked at unrelated
paper-domain parameters.
The gate also checks the single closed-unit paper-support certificate
`z2LatticeEmbeddingClosedUnitLocalBridgeData_paper_support_certificate`, tying
the `Z²` graph identity, scaling divergence, threshold certificate, local
domination field, near-`p_c` feasible-set nonemptiness, paper-domain witness,
and same-`alpha` feasible/divergence witness into one theorem.
See
[`lean4/README.md`](lean4/README.md) and
[`lean4/PAPER_LEAN_CALIBRATION.md`](lean4/PAPER_LEAN_CALIBRATION.md) for the
paper-label mapping and remaining semantic calibration notes.
Public reference/formula/numeric claims are also gated by
[`reference-evidence/public_evidence_manifest.json`](reference-evidence/public_evidence_manifest.json):
the verifier checks source cards for external formulas, committed JSON evidence
for public appendix numbers, the two still-open paper-semantic Lean targets,
and the companion paper-semantic audit output for the target routes, target-route
certificates, route obstructions, direct route-to-closure equivalence proofs,
closure routes, closure-route certificates, closure obstructions, frontier
progress/nonclosure certificates, full typed frontier payload certificates,
payload-derived progress/nonclosure/frontier projections, cross-surface
target/route-map/closure/frontier equality, payload-derived route-map and
route/closure certificate-obstruction projections, the payload route-map
certificate, closure-input sufficient-route/output/field certificates and obstructions,
exact closure-input equivalence, sufficient-to-exact projections,
exact-input/output bundle equivalence, output-equivalence target/output bundles,
bidirectional output projections, output iff proofs, output obstructions,
target/exact/output obstruction-equivalence proofs, joint closure-reduction
packages and package obstructions, joint route-obstruction packages, statement
rosters, and package obstructions, bilateral package obstruction statement
rosters, Part 6 conditional witness interface projections, statement roster,
and obstructions, Part 6 route-obstruction projections and statement roster, topo
exact-output projections, statement roster, and route nonclosure boundary, topo route-obstruction
projections and statement roster, field-roster id,
payload-to-input/iff consistency, payload-obstruction, and
payload/certificate consistency, field statement roster,
surface-roster consistency, top-level statement roster, and AxiomAudit coverage.
The public
verification command set includes the same Lean build, PaperSemanticGate build,
AxiomAudit build, and source-level audit scripts listed above.

## Installation

Python 3.9 or newer is required.

```bash
python -m venv .venv
# macOS / Linux
source .venv/bin/activate
# Windows (PowerShell)
.venv\Scripts\Activate.ps1

pip install -r requirements.txt
```

## Replication

All paper-relevant scripts live under `simulation/`. Run from that directory.

### Core theory (figures and analytical results)

```bash
cd simulation
python blackwell_violation.py        # Analytical proof + VOI computation (Thm 3.1)
python rationality_trap.py           # 4-state & 5-state interior optimum (Prop 6.4)
python generate_phase_diagram.py     # Two-regime phase diagram + welfare heatmap (Figs 1-2)
python alpha_star_five_state.py      # alpha* verification (Prop prop:threshold-alpha)
python approximation_audit.py        # Systematic audit of all numerical claims (~ values)
python bayesian_immunity.py          # Bayesian-agent immunity check (Thm 7.1)
python bayesian_agent.py             # Optimal Bayesian agent: monotone welfare in beta
python bayesian_agent_fast.py        # Vectorised Bayesian-agent variant
```

### Phase transition and finite-size scaling

```bash
python phase_transition_sim.py       # Core: 2D torus, bounded-rational agent (Thm 4.1)
python finite_size_scaling.py        # FSS with critical exponent nu = 4/3
python enhanced_fss.py               # Extended FSS + Proposition 5 verification
python sharp_transition_exp.py       # Sharp transition + bimodality on larger grids
python counterfactual_exp.py         # Within-model counterfactual (lowering p)
python trap_prevalence.py            # Fraction of vertices where V_static and V_dynamic disagree
```

### Robustness and structural extensions

```bash
python k_horizon_trap.py             # k-horizon robustness: trap persists for finite lookahead
python complementarity.py            # beta-alpha complementarity / phase transition
python upgrade_experiments.py        # Decomposition, policy gradients, structural identity
python weitzman_blindspot.py         # Error of applying Sims/Weitzman (p=0) to p>0 problems
python policy_disaster_sim.py        # Sims/Gabaix policy fails in supercritical regime
```

### Audit protocol and empirical applications

```bash
python bdes.py                       # Blackwell Dilemma Execution System (audit protocol)
python benchmark.py                  # Unified reproducible benchmark suite
python empirical_github.py           # ML-framework ecosystem application (Sec applic)
python replay_experiment.py          # Temporal IDP replay (platform lock-in)
python analyze_cfpb.py               # CFPB cross-domain irreversibility comparison
python analyze_hmda.py               # HMDA mortgage welfare-loss distribution
```

Results (JSON + PNG) are written to `results/`.

## Live Prediction (2026-03-26)

As an out-of-sample test, we track 10 AI agent/LLM frameworks daily via GitHub API. The quality leader (most stars) and the ecosystem leader (most development activity) are different frameworks — a developer choosing by visibility alone locks into a suboptimal long-term outcome.

**Prediction**: The quality leader will show lower relative ecosystem growth over 8 weeks than at least one framework with fewer stars.
**Verification date**: 2026-05-21

See [prediction.md](prediction.md) for full details and falsification criteria.

**Verification**: see [verification/live_prediction_verification_2026-05-21.md](verification/live_prediction_verification_2026-05-21.md). The short-note fork-growth predictions are confirmed; the commit-based EGR prediction is supported after recomputing 4-week commit windows from the GitHub commits API, with the pre-registered top-3 caution retained.

**Formal note**: the verified public research artifact is available as [paper/prediction_note_public.pdf](paper/prediction_note_public.pdf), with source at [paper/prediction_note.tex](paper/prediction_note.tex). The verification code and machine-readable output are in [verification/](verification/).

## Structure

The `paper/` directory contains the formal live-prediction note. The `verification/` directory contains the reproducible verifier, JSON output, and Markdown verification report.

```
├── simulation/             # All simulation code
│   ├── phase_transition_sim.py   # Core: graph setup, agent, noisy signals
│   ├── blackwell_violation.py    # Analytical proof figure + VOI
│   ├── rationality_trap.py       # 4-state & 5-state examples
│   ├── counterfactual_exp.py     # Within-model counterfactual
│   ├── finite_size_scaling.py    # FSS with critical exponent ν = 4/3
│   ├── upgrade_experiments.py    # Decomposition, policy gradients
│   ├── k_horizon_trap.py         # k-horizon robustness
│   └── ...
├── results/                # Output: JSON data + PNG plots
├── docs/                   # GitHub Pages
│   ├── explorer.html       # Interactive explanation (zh/en)
│   ├── index.html          # Computational appendix (MathJax)
│   └── computational_appendix.tex
├── tracker.py              # Daily prediction data collection
├── prediction.md           # Pre-registered prediction
└── data/
    └── snapshots.json      # Time series of daily GitHub snapshots
```

## Citation

```bibtex
@article{li2026blackwell,
  title={The Blackwell Dilemma: No Non-Vacuous Information Ordering Exists Under Endogenous Feasibility Constraints},
  author={Li, Alex Chengyu},
  year={2026},
  doi={10.5281/zenodo.19251487}
}
```

## License

MIT
