# The Blackwell Dilemma

**When Better Information Makes Agents Worse Off Under Endogenous Feasibility Constraints**

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.19251487.svg)](https://doi.org/10.5281/zenodo.19251487)

Blackwell's theorem (1953) states that more informative signals lead to weakly better decisions. We identify a structural boundary: when actions are irreversible and signals are topology-blind, welfare decomposes into a signal-immune topological component and an exponentially vanishing informational residual. Above the percolation threshold $p_c = 1/2$, the Blackwell ordering becomes structurally irrelevant to welfare.

## Interactive Explanation

**[Explore the Blackwell Dilemma](https://crabsatellite.github.io/blackwell-dilemma/explorer.html)** — a step-by-step interactive guide (bilingual zh/en) covering the core ideas, with sliders, games, and live percolation grids.

## Computational Appendix

**[View the computational appendix](https://crabsatellite.github.io/blackwell-dilemma/)** — six experiment families verifying all theoretical predictions, rendered with full math formatting.

## Replication

```bash
cd simulation
python phase_transition_sim.py       # Core phase transition experiments
python counterfactual_exp.py         # Within-model counterfactual
python finite_size_scaling.py        # Finite-size scaling with data collapse
python blackwell_violation.py        # Analytical proof + VOI computation
python rationality_trap.py           # 4-state & 5-state interior optimum
python sharp_transition_exp.py       # Sharp transition + bimodality
```

Results (JSON + PNG) are written to `results/`.

## Live Prediction (2026-03-26)

As an out-of-sample test, we track 10 AI agent/LLM frameworks daily via GitHub API. The quality leader (most stars) and the ecosystem leader (most development activity) are different frameworks — a developer choosing by visibility alone locks into a suboptimal long-term outcome.

**Prediction**: The quality leader will show lower relative ecosystem growth over 8 weeks than at least one framework with fewer stars.
**Verification date**: 2026-05-21

See [prediction.md](prediction.md) for full details and falsification criteria.

## Structure

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
