"""
Sharpened Phase Transition Experiment
=====================================
Higher β (up to 10) + larger grid (n=50) + focus on distribution shape metrics.
Goal: demonstrate that the transition IS sharp when finite-size effects are reduced.

Key improvements over initial experiment:
1. Higher β (3.0) — so subcritical loss is much lower, making the jump visible
2. Larger grid (n=50, 2500 vertices) — less finite-size smoothing
3. Bimodality metrics: Hartigan's dip test, bimodality coefficient
4. Variance explosion plot at the critical point
"""

import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from scipy import stats
from pathlib import Path
import time
import json

# Import from main simulation
import sys
sys.path.insert(0, str(Path(__file__).parent))
from phase_transition_sim import setup_graph, run_agent, compute_reachable_set, OUT_DIR


def bimodality_coefficient(data):
    """
    Sarle's bimodality coefficient: BC = (skew² + 1) / kurtosis
    BC > 5/9 ≈ 0.555 suggests bimodality.
    """
    n = len(data)
    skew = float(stats.skew(data))
    kurt = float(stats.kurtosis(data, fisher=False))  # Pearson kurtosis
    if kurt == 0:
        return 0
    return (skew ** 2 + 1) / kurt


def hartigans_dip_statistic(data):
    """
    Simple approximation: compare empirical CDF to best-fitting unimodal CDF.
    Higher dip = more bimodal. This is a simplified version.
    """
    sorted_data = np.sort(data)
    n = len(sorted_data)
    ecdf = np.arange(1, n + 1) / n

    # Best unimodal fit: uniform CDF between min and max
    uniform_cdf = (sorted_data - sorted_data[0]) / (sorted_data[-1] - sorted_data[0] + 1e-10)

    # Maximum deviation
    dip = np.max(np.abs(ecdf - uniform_cdf))
    return dip


def experiment_sharp(n=50, beta=3.0, T=None, p_values=None, M=400, seed=100):
    """High-β, large-grid experiment for sharp transition."""
    if T is None:
        T = n * n * 2  # generous time budget
    if p_values is None:
        p_values = np.linspace(0, 0.85, 35)

    rng = np.random.default_rng(seed)

    results = {
        'p_values': p_values.tolist(), 'beta': beta, 'n': n, 'T': T, 'M': M,
        'mean_loss': [], 'var_loss': [], 'bimodality_coeff': [],
        'median_loss': [], 'p90_loss': [], 'p10_loss': [],
        'mean_reachable_frac': [], 'all_losses': [],
    }

    for p in p_values:
        losses = []
        reachable_fracs = []

        for trial in range(M):
            rewards, adj = setup_graph(n, p, rng)
            max_r = rewards.max()
            final_r, _ = run_agent(rewards, adj, beta, T, rng)
            losses.append(max_r - final_r)

            if trial < 30:
                start = rng.integers(n * n)
                reachable = compute_reachable_set(adj, start)
                reachable_fracs.append(len(reachable) / (n * n))

        losses = np.array(losses)
        results['mean_loss'].append(float(losses.mean()))
        results['var_loss'].append(float(losses.var()))
        results['bimodality_coeff'].append(float(bimodality_coefficient(losses)))
        results['median_loss'].append(float(np.median(losses)))
        results['p90_loss'].append(float(np.percentile(losses, 90)))
        results['p10_loss'].append(float(np.percentile(losses, 10)))
        results['mean_reachable_frac'].append(float(np.mean(reachable_fracs)) if reachable_fracs else 0.0)
        results['all_losses'].append(losses.tolist())

        print(f"  p={p:.3f}: mean={losses.mean():.4f}, var={losses.var():.4f}, "
              f"BC={bimodality_coefficient(losses):.3f}, reach={np.mean(reachable_fracs):.3f}")

    return results


def experiment_beta_floor(n=50, p_values_pair=(0.10, 0.70), beta_values=None, M=300, seed=200):
    """Show that at high p, welfare loss floors regardless of β."""
    if beta_values is None:
        beta_values = np.array([0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 4.0, 5.0, 7.0, 10.0])

    rng = np.random.default_rng(seed)
    T = n * n * 2
    all_results = {}

    for p in p_values_pair:
        means = []
        for beta in beta_values:
            losses = []
            for _ in range(M):
                rewards, adj = setup_graph(n, p, rng)
                max_r = rewards.max()
                final_r, _ = run_agent(rewards, adj, beta, T, rng)
                losses.append(max_r - final_r)
            mean_l = np.mean(losses)
            means.append(mean_l)
            print(f"  p={p:.2f}, β={beta:.1f}: mean_loss={mean_l:.4f}")
        all_results[f"p_{p}"] = {'beta_values': beta_values.tolist(), 'mean_loss': means}

    return all_results


def plot_sharp_results(results, filename="sharp_transition.png"):
    """4-panel plot: mean, variance, bimodality coefficient, reachable fraction."""
    fig, axes = plt.subplots(2, 2, figsize=(14, 10))
    p = results['p_values']

    # Panel 1: Mean loss
    ax = axes[0, 0]
    ax.plot(p, results['mean_loss'], 'b-o', markersize=3, linewidth=1.5)
    ax.fill_between(p, results['p10_loss'], results['p90_loss'], alpha=0.2, color='blue')
    ax.set_ylabel('Welfare Loss', fontsize=11)
    ax.set_title(f'Mean Welfare Loss (n={results["n"]}, β={results["beta"]})', fontsize=11)
    ax.grid(True, alpha=0.3)

    # Panel 2: Variance (should spike at critical point)
    ax = axes[0, 1]
    ax.plot(p, results['var_loss'], 'r-o', markersize=3, linewidth=1.5)
    ax.set_ylabel('Variance of Loss', fontsize=11)
    ax.set_title('Loss Variance (peaks at critical point)', fontsize=11)
    ax.grid(True, alpha=0.3)

    # Panel 3: Bimodality coefficient
    ax = axes[1, 0]
    ax.plot(p, results['bimodality_coeff'], 'g-o', markersize=3, linewidth=1.5)
    ax.axhline(y=5/9, color='red', linestyle='--', alpha=0.7, label='BC=5/9 (bimodality threshold)')
    ax.set_xlabel('Irreversibility p', fontsize=11)
    ax.set_ylabel('Bimodality Coefficient', fontsize=11)
    ax.set_title('Bimodality Coefficient (>5/9 suggests bimodal)', fontsize=11)
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)

    # Panel 4: Reachable fraction (percolation)
    ax = axes[1, 1]
    ax.plot(p, results['mean_reachable_frac'], 'purple', marker='o', markersize=3, linewidth=1.5)
    ax.axhline(y=0.5, color='gray', linestyle='--', alpha=0.5)
    ax.set_xlabel('Irreversibility p', fontsize=11)
    ax.set_ylabel('Reachable Fraction', fontsize=11)
    ax.set_title('Reachable Set Size (percolation indicator)', fontsize=11)
    ax.grid(True, alpha=0.3)

    plt.suptitle('Sharpened Phase Transition Analysis', fontsize=14, fontweight='bold')
    plt.tight_layout()
    plt.savefig(OUT_DIR / filename, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / filename}")


def plot_beta_floor(results, filename="beta_floor.png"):
    """Show β-independence of welfare loss at high p."""
    fig, ax = plt.subplots(figsize=(9, 6))

    colors = ['green', 'red']
    markers = ['o', 's']
    for i, (key, data) in enumerate(results.items()):
        p_val = key.replace('p_', '')
        ax.plot(data['beta_values'], data['mean_loss'],
                color=colors[i], marker=markers[i], markersize=5, linewidth=2,
                label=f'p = {p_val}')

    ax.set_xlabel('Cognitive Budget β (bits)', fontsize=13)
    ax.set_ylabel('Mean Welfare Loss', fontsize=13)
    ax.set_title('Welfare Loss vs Cognition: The Irreversibility Floor\n'
                 '(High-p loss FLOORS — more thinking cannot help beyond threshold)',
                 fontsize=12)
    ax.legend(fontsize=11)
    ax.grid(True, alpha=0.3)

    # Annotate the floor
    high_p_data = list(results.values())[1]
    floor_val = min(high_p_data['mean_loss'][-3:])
    ax.axhline(y=floor_val, color='red', linestyle=':', alpha=0.5)
    ax.annotate(f'Irreversibility floor ≈ {floor_val:.3f}',
                xy=(8, floor_val), fontsize=10, color='red',
                ha='center', va='bottom')

    plt.tight_layout()
    plt.savefig(OUT_DIR / filename, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / filename}")


def plot_sharp_distributions(results, filename="sharp_distributions.png"):
    """Distribution gallery at high β — should show cleaner transition."""
    p_values = results['p_values']
    indices = [0, len(p_values)//6, 2*len(p_values)//6,
               3*len(p_values)//6, 4*len(p_values)//6, len(p_values)-1]

    fig, axes = plt.subplots(2, 3, figsize=(16, 10))
    axes = axes.flatten()

    for idx, ax_idx in enumerate(indices):
        ax = axes[idx]
        losses = np.array(results['all_losses'][ax_idx])
        p_val = p_values[ax_idx]
        bc = bimodality_coefficient(losses)

        color = plt.cm.RdYlGn_r(p_val / 0.85)
        ax.hist(losses, bins=50, density=True, alpha=0.7, color=color,
                edgecolor='black', linewidth=0.3)
        ax.set_title(f'p = {p_val:.2f}  (BC={bc:.2f})', fontsize=12, fontweight='bold')
        ax.set_xlabel('Welfare Loss')
        ax.set_ylabel('Density')
        ax.set_xlim(0, 1)
        ax.grid(True, alpha=0.3)
        ax.axvline(losses.mean(), color='red', linestyle='--', linewidth=1.5)

    plt.suptitle(f'Loss Distributions at β={results["beta"]} (higher cognition)\n'
                 f'n={results["n"]}, M={results["M"]}',
                 fontsize=13, fontweight='bold')
    plt.tight_layout()
    plt.savefig(OUT_DIR / filename, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / filename}")


if __name__ == "__main__":
    print("=" * 70)
    print("SHARPENED Phase Transition Experiments")
    print("=" * 70)

    # Experiment A: Sharp transition with high β, large grid
    print("\n[Exp A] n=50, β=3.0, M=400 — sharp transition sweep")
    t0 = time.time()
    results_sharp = experiment_sharp(n=50, beta=3.0, M=400, seed=100)
    elapsed = time.time() - t0
    print(f"  Done in {elapsed:.1f}s")

    plot_sharp_results(results_sharp)
    plot_sharp_distributions(results_sharp)

    # Experiment B: β floor demonstration with larger grid
    print("\n[Exp B] n=50, β sweep up to 10 — floor demonstration")
    t0 = time.time()
    results_floor = experiment_beta_floor(n=50, p_values_pair=(0.10, 0.70), M=300, seed=200)
    elapsed = time.time() - t0
    print(f"  Done in {elapsed:.1f}s")

    plot_beta_floor(results_floor)

    # Save results
    summary = {
        'sharp_transition': {
            'p_values': results_sharp['p_values'],
            'mean_loss': results_sharp['mean_loss'],
            'var_loss': results_sharp['var_loss'],
            'bimodality_coeff': results_sharp['bimodality_coeff'],
            'reachable_frac': results_sharp['mean_reachable_frac'],
        },
        'beta_floor': results_floor,
    }
    with open(OUT_DIR / "sharp_results.json", "w") as f:
        json.dump(summary, f, indent=2)

    print(f"\nResults saved to {OUT_DIR}/")
    print("=" * 70)
    print("SHARPENED EXPERIMENTS COMPLETE")
    print("=" * 70)
