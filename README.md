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
lake build BlackwellDilemma.AxiomAudit
python scripts/audit_kernel_surface.py
python scripts/audit_conditional_surface.py
python scripts/audit_paper_semantic_gate.py
```

The current public Lean package keeps the checked theorem surface
kernel-clean: no project-level source axioms, no proof escapes, no unresolved
conditional theorem interfaces, and no Cat 3 paper-novel input assumptions in
the live ledger. Complete paper-semantic closure is separately gated in
`BlackwellDilemma/PaperSemanticGate.lean`; while that gate reports open
Part 6 lattice-embedding and random-supercritical percolation semantic targets,
the project does not claim the stronger full-manuscript semantic closure
status. The Part 4 lattice p-monotonicity target is now closed by the standard
`Z²` ranged local-lattice bridge; the former threshold target is closed by the
one-edge high-κ oracle-routing carrier
`FiveState.highKappaOracleRoutingWelfare_eq_oracle`; the neutral-carrier
refutation remains as diagnostic evidence for the retired route. The topo gate
now also machine-checks all-open/complement boxed-torus giant-event witnesses,
the full-reach `Z²` boxed-torus bridge with its fixed-`L` all-`n` lower-bound
interface, the explicit non-diagnostic
`RandomSupercriticalZ2TopoClusterBridgeData` contract, and the flat-sequence
lower-bound package, but the random-supercritical semantic target remains open
until that contract is instantiated by the real finite-lattice carrier. The
contract now machine-excludes the current full-reach, flat-only, and
all-open-complement diagnostic families. The Part 6 gate now also
machine-checks a generic positive-at-zero obstruction for the old global
domination interface, a repaired local near-`p_c` domination transfer, and the
current local-bridge impossibility theorem. It also checks the current
`alphaStar = 1` degeneracy, which makes the paper-bounded `α > α*`, `α <= 1`
domain empty on the present scalar carrier. The remaining repair is therefore
to supply a nondegenerate Part 6 `α`/feasible-set domain certificate before
instantiating a `Z²` bridge with a real percolation scaling carrier.
See
[`lean4/README.md`](lean4/README.md) and
[`lean4/PAPER_LEAN_CALIBRATION.md`](lean4/PAPER_LEAN_CALIBRATION.md) for the
paper-label mapping and remaining semantic calibration notes.

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
