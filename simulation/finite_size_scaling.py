"""
Finite-Size Scaling Analysis
=============================
The experiment that elevates this from "economics paper" to "statistical physics".

If the phase transition is in the 2D bond percolation universality class:
- Critical exponent ν = 4/3
- Order parameter exponent β_perc = 5/36
- p_c = 1/2

Data collapse procedure:
- Plot W(p, n) for multiple n
- Rescale x-axis: (p - p_c) * n^{1/ν}
- Rescale y-axis depends on observable:
  - For reachable fraction: R * n^{β_perc/ν}
  - For variance: Var * n^{-γ/ν} (or just check peak scaling)

If all curves collapse onto a single universal function → CONFIRMED universality class.
"""

import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from pathlib import Path
import time
import json
import sys

sys.path.insert(0, str(Path(__file__).parent))
from phase_transition_sim import setup_graph, run_agent, compute_reachable_set, OUT_DIR


# Known 2D bond percolation critical exponents
P_C = 0.5
NU = 4.0 / 3.0        # correlation length exponent
BETA_PERC = 5.0 / 36.0  # order parameter exponent
GAMMA = 43.0 / 18.0     # susceptibility exponent


def experiment_fss(grid_sizes, beta=3.0, p_values=None, M=300, seed=400):
    """
    Run welfare loss experiment at multiple grid sizes for finite-size scaling.
    """
    if p_values is None:
        p_values = np.linspace(0.25, 0.75, 30)  # Focus around p_c

    all_results = {}

    for n in grid_sizes:
        T = n * n * 2
        rng = np.random.default_rng(seed)

        results = {
            'n': n, 'beta': beta, 'M': M, 'T': T,
            'p_values': p_values.tolist(),
            'mean_loss': [], 'var_loss': [],
            'mean_reachable': [], 'var_reachable': [],
        }

        print(f"\n  n={n} ({n*n} vertices):")
        for p in p_values:
            losses = []
            reachable_fracs = []

            for trial in range(M):
                rewards, adj = setup_graph(n, p, rng)
                max_r = rewards.max()
                final_r, _ = run_agent(rewards, adj, beta, T, rng)
                losses.append(max_r - final_r)

                if trial < 50:
                    start = rng.integers(n * n)
                    reachable = compute_reachable_set(adj, start)
                    reachable_fracs.append(len(reachable) / (n * n))

            losses = np.array(losses)
            results['mean_loss'].append(float(losses.mean()))
            results['var_loss'].append(float(losses.var()))
            results['mean_reachable'].append(float(np.mean(reachable_fracs)))
            results['var_reachable'].append(float(np.var(reachable_fracs)))

            print(f"    p={p:.3f}: loss={losses.mean():.4f}, var={losses.var():.4f}, reach={np.mean(reachable_fracs):.3f}")

        all_results[n] = results

    return all_results


def plot_raw_curves(all_results, filename="fss_raw.png"):
    """Raw data: mean loss and reachable fraction vs p for each grid size."""
    fig, axes = plt.subplots(1, 3, figsize=(18, 5.5))
    colors = plt.cm.viridis(np.linspace(0.2, 0.9, len(all_results)))

    # Panel 1: Mean loss
    ax = axes[0]
    for (n, results), color in zip(sorted(all_results.items()), colors):
        ax.plot(results['p_values'], results['mean_loss'],
                marker='o', markersize=2, linewidth=1.5, color=color, label=f'n={n}')
    ax.axvline(P_C, color='red', linestyle='--', alpha=0.5, label=f'p_c={P_C}')
    ax.set_xlabel('Irreversibility p', fontsize=12)
    ax.set_ylabel('Mean Welfare Loss', fontsize=12)
    ax.set_title('Mean Loss vs p (multiple grid sizes)', fontsize=11)
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)

    # Panel 2: Loss variance
    ax = axes[1]
    for (n, results), color in zip(sorted(all_results.items()), colors):
        ax.plot(results['p_values'], results['var_loss'],
                marker='o', markersize=2, linewidth=1.5, color=color, label=f'n={n}')
    ax.axvline(P_C, color='red', linestyle='--', alpha=0.5)
    ax.set_xlabel('Irreversibility p', fontsize=12)
    ax.set_ylabel('Variance of Loss', fontsize=12)
    ax.set_title('Loss Variance (should peak at p_c, peak grows with n)', fontsize=11)
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)

    # Panel 3: Reachable fraction
    ax = axes[2]
    for (n, results), color in zip(sorted(all_results.items()), colors):
        ax.plot(results['p_values'], results['mean_reachable'],
                marker='o', markersize=2, linewidth=1.5, color=color, label=f'n={n}')
    ax.axvline(P_C, color='red', linestyle='--', alpha=0.5)
    ax.axhline(0.5, color='gray', linestyle=':', alpha=0.3)
    ax.set_xlabel('Irreversibility p', fontsize=12)
    ax.set_ylabel('Reachable Fraction', fontsize=12)
    ax.set_title('Reachable Set (percolation order parameter)', fontsize=11)
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)

    plt.suptitle('Finite-Size Scaling: Raw Data', fontsize=13, fontweight='bold')
    plt.tight_layout()
    plt.savefig(OUT_DIR / filename, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / filename}")


def plot_data_collapse(all_results, filename="fss_collapse.png"):
    """
    Data collapse using 2D percolation critical exponents.
    If curves collapse → confirmed universality class.
    """
    fig, axes = plt.subplots(1, 3, figsize=(18, 5.5))
    colors = plt.cm.viridis(np.linspace(0.2, 0.9, len(all_results)))

    # Panel 1: Loss collapse
    # Rescale: x = (p - p_c) * n^{1/ν}, y = W (loss doesn't need rescaling if it's O(1))
    ax = axes[0]
    for (n, results), color in zip(sorted(all_results.items()), colors):
        p_arr = np.array(results['p_values'])
        x_scaled = (p_arr - P_C) * n ** (1.0 / NU)
        ax.plot(x_scaled, results['mean_loss'],
                marker='o', markersize=2, linewidth=1.5, color=color, label=f'n={n}')
    ax.set_xlabel(r'$(p - p_c) \cdot n^{1/\nu}$', fontsize=12)
    ax.set_ylabel('Mean Welfare Loss', fontsize=12)
    ax.set_title(f'Loss Collapse (ν = {NU:.3f})', fontsize=11)
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)
    ax.axvline(0, color='red', linestyle='--', alpha=0.3)

    # Panel 2: Reachable fraction collapse
    # R * n^{β_perc/ν} vs (p - p_c) * n^{1/ν}
    ax = axes[1]
    for (n, results), color in zip(sorted(all_results.items()), colors):
        p_arr = np.array(results['p_values'])
        x_scaled = (p_arr - P_C) * n ** (1.0 / NU)
        y_scaled = np.array(results['mean_reachable']) * n ** (BETA_PERC / NU)
        ax.plot(x_scaled, y_scaled,
                marker='o', markersize=2, linewidth=1.5, color=color, label=f'n={n}')
    ax.set_xlabel(r'$(p - p_c) \cdot n^{1/\nu}$', fontsize=12)
    ax.set_ylabel(r'$R \cdot n^{\beta/\nu}$', fontsize=12)
    ax.set_title(f'Reachable Fraction Collapse (β_perc={BETA_PERC:.3f}, ν={NU:.3f})', fontsize=11)
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)
    ax.axvline(0, color='red', linestyle='--', alpha=0.3)

    # Panel 3: Variance peak scaling
    # At p_c, Var should scale as n^{γ/ν}
    ax = axes[2]
    grid_sizes_sorted = sorted(all_results.keys())
    peak_vars = []
    for n in grid_sizes_sorted:
        results = all_results[n]
        p_arr = np.array(results['p_values'])
        var_arr = np.array(results['var_loss'])
        # Find variance near p_c (within ±0.05)
        mask = np.abs(p_arr - P_C) < 0.05
        if mask.any():
            peak_vars.append(var_arr[mask].max())
        else:
            peak_vars.append(var_arr.max())

    log_n = np.log(grid_sizes_sorted)
    log_var = np.log(peak_vars)

    ax.plot(log_n, log_var, 'ko-', markersize=8, linewidth=2)

    # Fit slope → should give γ/ν
    if len(log_n) >= 2:
        slope, intercept = np.polyfit(log_n, log_var, 1)
        fit_line = slope * log_n + intercept
        ax.plot(log_n, fit_line, 'r--', linewidth=1.5,
                label=f'Fit: slope = {slope:.3f}\n(theory γ/ν = {GAMMA/NU:.3f})')
    ax.set_xlabel('log(n)', fontsize=12)
    ax.set_ylabel('log(Var peak at p_c)', fontsize=12)
    ax.set_title('Variance Peak Scaling\n(slope should match γ/ν)', fontsize=11)
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)

    plt.suptitle('Finite-Size Scaling: Data Collapse with 2D Percolation Exponents',
                 fontsize=13, fontweight='bold')
    plt.tight_layout()
    plt.savefig(OUT_DIR / filename, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / filename}")


if __name__ == "__main__":
    print("=" * 70)
    print("FINITE-SIZE SCALING: Extracting Critical Exponents")
    print("=" * 70)

    grid_sizes = [15, 25, 40, 60]  # Balance between range and compute time
    # n=60 → 3600 vertices, manageable

    t0 = time.time()
    all_results = experiment_fss(
        grid_sizes=grid_sizes,
        beta=3.0,
        p_values=np.linspace(0.25, 0.75, 30),
        M=300,
        seed=400
    )
    elapsed = time.time() - t0
    print(f"\nTotal time: {elapsed:.1f}s")

    plot_raw_curves(all_results)
    plot_data_collapse(all_results)

    # Save results (without huge loss arrays)
    save_data = {}
    for n, results in all_results.items():
        save_data[str(n)] = {
            'n': results['n'], 'beta': results['beta'], 'M': results['M'],
            'p_values': results['p_values'],
            'mean_loss': results['mean_loss'],
            'var_loss': results['var_loss'],
            'mean_reachable': results['mean_reachable'],
        }
    with open(OUT_DIR / "fss_results.json", "w") as f:
        json.dump(save_data, f, indent=2)

    print(f"\nResults saved to {OUT_DIR}")
    print("=" * 70)
    print("FINITE-SIZE SCALING COMPLETE")
    print("=" * 70)
