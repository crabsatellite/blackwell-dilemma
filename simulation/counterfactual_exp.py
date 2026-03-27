"""
Constructive Counterfactual: Does Lowering p Eliminate the Floor?
=================================================================
The critical causal identification experiment.

Design:
- Generate graphs at p=0.70 (supercritical) with high β=5.0
- Then SURGICALLY REDUCE p by converting irreversible edges back to reversible
- If the floor disappears when p drops below p_c ≈ 0.5, we have:
  CAUSAL IDENTIFICATION: it's the topology (p), not the cognition (β)

This is more powerful than any additional dataset because it isolates the mechanism.
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
from phase_transition_sim import create_torus_edges, get_accessible_neighbors, noisy_signal, compute_reachable_set, OUT_DIR


def setup_graph_with_edge_tracking(n, p, rng):
    """Like setup_graph but returns the list of which edges are blocked.

    Bond percolation: each edge is independently BLOCKED (removed entirely)
    with probability p, or OPEN (bidirectional) with probability 1-p.
    """
    N = n * n
    rewards = rng.random(N)
    edges = create_torus_edges(n)
    adj = {v: {} for v in range(N)}
    blocked_edges = []  # track which edges were blocked

    for u, v in edges:
        is_blocked = rng.random() < p
        if is_blocked:
            # Bond percolation: edge removed entirely (both directions)
            adj[u][v] = False
            adj[v][u] = False
            blocked_edges.append((u, v))
        else:
            adj[u][v] = True
            adj[v][u] = True

    return rewards, adj, blocked_edges


def repair_edges(adj, blocked_edges, repair_fraction, rng):
    """
    Repair a fraction of blocked edges — restore them as bidirectional.
    This surgically reduces effective p without changing anything else.
    """
    adj_repaired = {v: dict(neighbors) for v, neighbors in adj.items()}
    n_repair = int(len(blocked_edges) * repair_fraction)
    if n_repair == 0:
        return adj_repaired

    repair_indices = rng.choice(len(blocked_edges), size=n_repair, replace=False)
    for idx in repair_indices:
        u, v = blocked_edges[idx]
        adj_repaired[u][v] = True
        adj_repaired[v][u] = True

    return adj_repaired


def run_agent(rewards, adj, beta, T, rng):
    """Run bounded-rational agent."""
    N = len(rewards)
    v = rng.integers(N)
    for _ in range(T):
        neighbors = get_accessible_neighbors(adj, v)
        if not neighbors:
            break
        signals = [(u, noisy_signal(rewards[u], beta, rng)) for u in neighbors]
        v = max(signals, key=lambda x: x[1])[0]
    return rewards[v]


def experiment_counterfactual(n=50, p_initial=0.70, beta=5.0, M=400, seed=300):
    """
    Fix a supercritical graph, then repair edges to reduce effective p.
    Show that the welfare loss floor disappears.
    """
    T = n * n * 2
    rng = np.random.default_rng(seed)

    # Repair fractions: 0% (original) to 100% (fully reversible)
    # p_effective = p_initial * (1 - repair_fraction)
    repair_fractions = np.linspace(0, 1.0, 25)
    p_effective = p_initial * (1 - repair_fractions)

    results = {
        'p_initial': p_initial, 'beta': beta, 'n': n, 'M': M,
        'repair_fractions': repair_fractions.tolist(),
        'p_effective': p_effective.tolist(),
        'mean_loss': [], 'std_loss': [], 'mean_reachable': [],
        'p10_loss': [], 'p90_loss': [],
    }

    for rf in repair_fractions:
        losses = []
        reachable_fracs = []

        for trial in range(M):
            rewards, adj, blocked_edges = setup_graph_with_edge_tracking(n, p_initial, rng)
            adj_repaired = repair_edges(adj, blocked_edges, rf, rng)

            max_r = rewards.max()
            final_r = run_agent(rewards, adj_repaired, beta, T, rng)
            losses.append(max_r - final_r)

            if trial < 30:
                start = rng.integers(n * n)
                reachable = compute_reachable_set(adj_repaired, start)
                reachable_fracs.append(len(reachable) / (n * n))

        losses = np.array(losses)
        p_eff = p_initial * (1 - rf)
        results['mean_loss'].append(float(losses.mean()))
        results['std_loss'].append(float(losses.std()))
        results['mean_reachable'].append(float(np.mean(reachable_fracs)) if reachable_fracs else 0.0)
        results['p10_loss'].append(float(np.percentile(losses, 10)))
        results['p90_loss'].append(float(np.percentile(losses, 90)))

        print(f"  repair={rf:.2f} (p_eff={p_eff:.3f}): loss={losses.mean():.4f}, reach={np.mean(reachable_fracs):.3f}")

    return results


def plot_counterfactual(results, filename="counterfactual.png"):
    """3-panel: loss vs p_eff, reachable vs p_eff, before/after comparison."""
    fig, axes = plt.subplots(1, 3, figsize=(18, 5.5))

    p_eff = results['p_effective']
    mean_loss = results['mean_loss']
    p10 = results['p10_loss']
    p90 = results['p90_loss']
    reachable = results['mean_reachable']

    # Panel 1: Loss vs effective p (reversed x-axis: high p on left, low p on right)
    ax = axes[0]
    ax.plot(p_eff, mean_loss, 'b-o', markersize=4, linewidth=2)
    ax.fill_between(p_eff, p10, p90, alpha=0.15, color='blue')
    ax.axvline(x=0.5, color='red', linestyle='--', alpha=0.7, linewidth=1.5, label='p_c = 0.5')
    ax.axhline(y=results['mean_loss'][0], color='gray', linestyle=':', alpha=0.5,
               label=f'Original floor = {results["mean_loss"][0]:.3f}')
    ax.set_xlabel('Effective Irreversibility p', fontsize=12)
    ax.set_ylabel('Mean Welfare Loss', fontsize=12)
    ax.set_title(f'Counterfactual: Repairing Edges at β={results["beta"]}\n'
                 f'(n={results["n"]}, original p={results["p_initial"]})', fontsize=11)
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)
    ax.invert_xaxis()

    # Panel 2: Reachable fraction vs effective p
    ax = axes[1]
    ax.plot(p_eff, reachable, 'purple', marker='o', markersize=4, linewidth=2)
    ax.axvline(x=0.5, color='red', linestyle='--', alpha=0.7, linewidth=1.5, label='p_c = 0.5')
    ax.set_xlabel('Effective Irreversibility p', fontsize=12)
    ax.set_ylabel('Reachable Fraction', fontsize=12)
    ax.set_title('Reachable Set Recovery\n(percolation restored as p drops)', fontsize=11)
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)
    ax.invert_xaxis()

    # Panel 3: Direct comparison — β=5 at p=0.70 vs p=0.70→repaired
    ax = axes[2]
    # Bar chart: original vs subcritical
    original_loss = results['mean_loss'][0]
    # Find the entry closest to p_eff=0.3
    idx_sub = min(range(len(p_eff)), key=lambda i: abs(p_eff[i] - 0.30))
    # Find p_eff=0 (fully repaired)
    idx_full = len(p_eff) - 1

    bars = [original_loss, results['mean_loss'][idx_sub], results['mean_loss'][idx_full]]
    labels = [f'p={results["p_initial"]:.2f}\n(original)', f'p≈{p_eff[idx_sub]:.2f}\n(partial repair)', f'p≈{p_eff[idx_full]:.2f}\n(full repair)']
    colors = ['red', 'orange', 'green']

    ax.bar(labels, bars, color=colors, alpha=0.8, edgecolor='black')
    ax.set_ylabel('Mean Welfare Loss', fontsize=12)
    ax.set_title(f'Causal Identification (β={results["beta"]} fixed)\n'
                 f'Same cognition, different topology → different outcome', fontsize=11)
    ax.grid(True, alpha=0.3, axis='y')

    # Annotate reduction
    for i, (b, l) in enumerate(zip(bars, labels)):
        ax.text(i, b + 0.01, f'{b:.3f}', ha='center', fontsize=11, fontweight='bold')

    plt.suptitle('CONSTRUCTIVE COUNTERFACTUAL: Reducing Irreversibility Eliminates the Welfare Floor',
                 fontsize=13, fontweight='bold')
    plt.tight_layout()
    plt.savefig(OUT_DIR / filename, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / filename}")


if __name__ == "__main__":
    print("=" * 70)
    print("COUNTERFACTUAL EXPERIMENT: Does lowering p eliminate the floor?")
    print("=" * 70)

    t0 = time.time()
    results = experiment_counterfactual(n=50, p_initial=0.70, beta=5.0, M=400, seed=300)
    elapsed = time.time() - t0
    print(f"Done in {elapsed:.1f}s")

    plot_counterfactual(results)

    with open(OUT_DIR / "counterfactual_results.json", "w") as f:
        json.dump(results, f, indent=2)
    print(f"Results saved to {OUT_DIR / 'counterfactual_results.json'}")

    print("\n" + "=" * 70)
    print("COUNTERFACTUAL COMPLETE")
    print("=" * 70)
