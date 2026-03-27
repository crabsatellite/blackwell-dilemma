"""
Policy Disaster Simulation
===========================
Concrete counterexample: Sims/Gabaix-recommended policy (increase beta)
is nearly ineffective in the supercritical regime, while structural
policy (decrease p) produces dramatic welfare improvement.

Mortgage market framing:
- Irreversibility p: switching barriers (prepayment penalties, refinancing costs)
- Information beta: financial literacy (ability to compare mortgage rates)
- Reward r: borrower welfare (negative of excess interest paid)
"""

import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from pathlib import Path
import sys
import time
import json

sys.path.insert(0, str(Path(__file__).parent))
from phase_transition_sim import setup_graph, run_agent, OUT_DIR


def run_scenario(n, p, beta, M, T, rng):
    """Run M trials and return loss statistics."""
    losses = []
    for _ in range(M):
        rewards, adj = setup_graph(n, p, rng)
        max_r = rewards.max()
        final_r, _ = run_agent(rewards, adj, beta, T, rng)
        losses.append(max_r - final_r)
    arr = np.array(losses)
    return {
        'mean': float(arr.mean()),
        'std': float(arr.std()),
        'median': float(np.median(arr)),
        'q25': float(np.percentile(arr, 25)),
        'q75': float(np.percentile(arr, 75)),
    }


def experiment_policy_comparison(n=50, M=500, seed=42):
    """
    Four scenarios comparing information vs structural policy.

    Baseline: p=0.60, beta=2.0 (high irreversibility, moderate info)
    Policy A: p=0.60, beta=5.0 (invest in financial literacy)
    Policy B: p=0.30, beta=2.0 (reduce switching barriers)
    Both:     p=0.30, beta=5.0 (both investments)
    """
    rng = np.random.default_rng(seed)
    T = n * n * 2

    scenarios = [
        ('Baseline', 0.60, 2.0),
        ('Policy A: +Literacy', 0.60, 5.0),
        ('Policy B: -Barriers', 0.30, 2.0),
        ('Both A+B', 0.30, 5.0),
    ]

    results = {}
    for name, p, beta in scenarios:
        stats = run_scenario(n, p, beta, M, T, rng)
        results[name] = {'p': p, 'beta': beta, **stats}
        print(f"  {name}: p={p}, b={beta}, loss={stats['mean']:.4f} +/- {stats['std']:.4f}")

    return results


def experiment_sweeps(n=50, M=400, seed=43):
    """
    Two sweeps:
    1. Fix p=0.60, vary beta from 0.5 to 10 -> shows beta ineffectiveness
    2. Fix beta=2.0, vary p from 0.10 to 0.80 -> shows p has dramatic effect
    """
    rng = np.random.default_rng(seed)
    T = n * n * 2

    # Sweep 1: beta sweep at fixed p=0.60
    beta_values = [0.5, 1.0, 1.5, 2.0, 3.0, 5.0, 7.0, 10.0]
    beta_results = []
    print("\n  Beta sweep (p=0.60):")
    for beta in beta_values:
        stats = run_scenario(n, 0.60, beta, M, T, rng)
        beta_results.append({'beta': beta, **stats})
        print(f"    b={beta:.1f}: loss={stats['mean']:.4f}")

    # Sweep 2: p sweep at fixed beta=2.0
    p_values = np.linspace(0.10, 0.80, 20).tolist()
    p_results = []
    print("\n  p sweep (b=2.0):")
    for p in p_values:
        stats = run_scenario(n, p, 2.0, M, T, rng)
        p_results.append({'p': p, **stats})
        print(f"    p={p:.3f}: loss={stats['mean']:.4f}")

    return beta_results, p_results


def plot_policy_comparison(results, filename="policy_disaster.png"):
    """Bar chart comparing four policy scenarios."""
    fig, ax = plt.subplots(figsize=(10, 6))

    names = list(results.keys())
    means = [results[n]['mean'] for n in names]
    stds = [results[n]['std'] for n in names]

    colors = ['#888888', '#E8A838', '#38B838', '#3838E8']
    bars = ax.bar(range(len(names)), means, yerr=stds, capsize=5,
                  color=colors, edgecolor='black', linewidth=0.8, alpha=0.85)

    # Baseline reference line
    ax.axhline(means[0], color='gray', linestyle='--', alpha=0.4)

    # Improvement annotations
    baseline = means[0]
    for i in range(1, len(names)):
        improvement = (baseline - means[i]) / baseline * 100
        y_pos = means[i] + stds[i] + 0.01
        color = 'darkgreen' if improvement > 30 else ('darkorange' if improvement > 5 else 'darkred')
        label = f'-{improvement:.0f}%' if improvement > 0 else f'+{abs(improvement):.0f}%'
        ax.annotate(label, xy=(i, y_pos), ha='center', fontsize=11,
                    fontweight='bold', color=color)

    ax.set_xticks(range(len(names)))
    labels = []
    for n in names:
        r = results[n]
        labels.append(f"{n}\n(p={r['p']}, b={r['beta']})")
    ax.set_xticklabels(labels, fontsize=9)
    ax.set_ylabel('Mean Welfare Loss', fontsize=12)
    ax.set_title('Policy Disaster: Financial Literacy vs Barrier Reduction\n'
                 'Same investment budget, opposite priorities',
                 fontsize=12, fontweight='bold')
    ax.set_ylim(bottom=0)
    ax.grid(True, alpha=0.2, axis='y')

    # Explanation box
    textstr = ('Sims/Gabaix prescribes Policy A (increase literacy)\n'
               'Our framework prescribes Policy B (reduce barriers)\n'
               'n=50 grid, 2500 states, M=500 trials')
    props = dict(boxstyle='round', facecolor='wheat', alpha=0.5)
    ax.text(0.02, 0.98, textstr, transform=ax.transAxes, fontsize=8,
            verticalalignment='top', bbox=props)

    plt.tight_layout()
    plt.savefig(OUT_DIR / filename, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / filename}")


def plot_sweeps(beta_results, p_results, filename="policy_sweeps.png"):
    """Two-panel: beta is flat, p is dramatic."""
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5.5))

    # Left: beta sweep at p=0.60
    betas = [r['beta'] for r in beta_results]
    b_means = [r['mean'] for r in beta_results]
    b_stds = [r['std'] for r in beta_results]

    ax1.errorbar(betas, b_means, yerr=b_stds, fmt='o-', color='#E8A838',
                 linewidth=2, markersize=8, capsize=4)
    ax1.set_xlabel('Information Capacity b (financial literacy)', fontsize=11)
    ax1.set_ylabel('Mean Welfare Loss', fontsize=11)
    ax1.set_title('Sweep b at fixed p=0.60 (above p_c)\n'
                  'Sims predicts: loss should decrease with b', fontsize=11)
    ax1.set_ylim(bottom=0)
    ax1.grid(True, alpha=0.3)

    # Annotate flatness
    loss_range = max(b_means) - min(b_means)
    mid_y = (max(b_means) + min(b_means)) / 2
    ax1.annotate(f'Total change: {loss_range:.4f}\n(nearly flat -- b is irrelevant)',
                 xy=(5, mid_y), fontsize=10, color='red', fontweight='bold',
                 ha='center')

    # Right: p sweep at beta=2.0
    ps = [r['p'] for r in p_results]
    p_means = [r['mean'] for r in p_results]
    p_stds = [r['std'] for r in p_results]

    ax2.errorbar(ps, p_means, yerr=p_stds, fmt='o-', color='#38B838',
                 linewidth=2, markersize=6, capsize=3)
    ax2.axvline(0.5, color='red', linestyle='--', alpha=0.5, label='p_c = 0.5')
    ax2.set_xlabel('Irreversibility p (switching barriers)', fontsize=11)
    ax2.set_ylabel('Mean Welfare Loss', fontsize=11)
    ax2.set_title('Sweep p at fixed b=2.0\n'
                  'Our model: sharp transition at p_c', fontsize=11)
    ax2.set_ylim(bottom=0)
    ax2.legend(fontsize=9)
    ax2.grid(True, alpha=0.3)

    # Annotate regions
    ax2.text(0.2, max(p_means) * 0.15, 'Below p_c\n(low loss)',
             fontsize=10, color='darkgreen', fontweight='bold', ha='center')
    ax2.text(0.7, max(p_means) * 0.8, 'Above p_c\n(high loss)',
             fontsize=10, color='darkred', fontweight='bold', ha='center')

    plt.suptitle('Why Sims/Gabaix Policy Fails Above the Phase Boundary',
                 fontsize=13, fontweight='bold')
    plt.tight_layout()
    plt.savefig(OUT_DIR / filename, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / filename}")


if __name__ == "__main__":
    print("=" * 70)
    print("POLICY DISASTER SIMULATION")
    print("=" * 70)

    t0 = time.time()

    print("\n1. Policy Comparison (4 scenarios):")
    comparison = experiment_policy_comparison(n=50, M=500, seed=42)

    print("\n2. Policy Sweeps:")
    beta_results, p_results = experiment_sweeps(n=50, M=400, seed=43)

    elapsed = time.time() - t0
    print(f"\nTotal time: {elapsed:.1f}s")

    plot_policy_comparison(comparison)
    plot_sweeps(beta_results, p_results)

    # Save data
    save_data = {
        'comparison': comparison,
        'beta_sweep': beta_results,
        'p_sweep': p_results,
    }
    with open(OUT_DIR / "policy_disaster_results.json", "w") as f:
        json.dump(save_data, f, indent=2)

    print(f"\nResults saved to {OUT_DIR}")
    print("=" * 70)
    print("POLICY DISASTER SIMULATION COMPLETE")
    print("=" * 70)
