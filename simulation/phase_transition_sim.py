"""
Phase Transition in Welfare Loss under Bounded Rationality with Irreversible Decisions
======================================================================================
Core simulation: 2D torus grid, bounded-rational agent navigates with blocked edges.
Tests whether welfare loss exhibits a sharp phase transition as irreversibility p increases.

Model:
- n x n torus (periodic grid), each vertex has i.i.d. Uniform[0,1] reward
- Each edge independently BLOCKED with probability p (bond percolation: edge removed entirely)
- Agent starts at random vertex, takes T steps
- At each step: observes noisy signals about neighbor rewards (β bits MI), moves to best-looking neighbor
- Welfare = reward at final position; Loss = max_reward - final_reward

Experiment:
- Sweep p from 0 to 1 at fixed β
- Sweep β at fixed p
- For each (p, β): run M trials, record welfare loss distribution
- Plot: mean welfare loss vs p (expect sharp transition at p_c = 1/2, Harris-Kesten)
- Plot: welfare loss histogram at low-p vs high-p (expect unimodal vs bimodal/heavy-tail)
"""

import numpy as np
from scipy import stats
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from pathlib import Path
import time
import json

OUT_DIR = Path(__file__).parent.parent / "results"
OUT_DIR.mkdir(exist_ok=True)


def create_torus_edges(n):
    """Create edge list for n x n torus (periodic 2D grid). Returns list of (u, v) pairs."""
    edges = []
    for i in range(n):
        for j in range(n):
            u = i * n + j
            # right neighbor
            v_right = i * n + (j + 1) % n
            edges.append((u, v_right))
            # down neighbor
            v_down = ((i + 1) % n) * n + j
            edges.append((u, v_down))
    return edges


def setup_graph(n, p, rng):
    """
    Build adjacency structure for n x n torus with bond percolation parameter p.

    Each edge is independently BLOCKED (removed) with probability p,
    or OPEN (bidirectional) with probability 1-p. This is standard bond
    percolation with retention probability 1-p.

    Returns:
        rewards: array of shape (n*n,) with Uniform[0,1] rewards
        adj: dict mapping vertex -> dict of {neighbor: is_accessible}
             is_accessible[u][v] = True means agent CAN go from u to v
    """
    N = n * n
    rewards = rng.random(N)
    edges = create_torus_edges(n)

    # Build adjacency: initially all edges are bidirectional
    adj = {v: {} for v in range(N)}

    for u, v in edges:
        is_blocked = rng.random() < p
        if is_blocked:
            # Bond percolation: edge removed entirely (both directions)
            adj[u][v] = False
            adj[v][u] = False
        else:
            # Edge open: both directions accessible
            adj[u][v] = True
            adj[v][u] = True

    return rewards, adj


def get_accessible_neighbors(adj, v):
    """Get list of neighbors accessible from v."""
    return [u for u, accessible in adj[v].items() if accessible]


def noisy_signal(true_value, beta, rng):
    """
    Generate noisy observation of true_value with mutual information β bits.
    Uses Gaussian channel: s = v + ε, ε ~ N(0, σ²), β = 0.5 * log2(1 + 1/σ²)
    So σ² = 1 / (2^{2β} - 1)
    """
    if beta > 20:
        return true_value  # effectively perfect observation
    sigma2 = 1.0 / (2 ** (2 * beta) - 1)
    noise = rng.normal(0, np.sqrt(sigma2))
    return true_value + noise


def run_agent(rewards, adj, beta, T, rng):
    """
    Run a bounded-rational agent on the graph.

    Returns:
        final_reward: reward at agent's final position
        trajectory: list of visited vertices
    """
    N = len(rewards)
    v = rng.integers(N)  # random start
    trajectory = [v]

    for _ in range(T):
        neighbors = get_accessible_neighbors(adj, v)
        if not neighbors:
            break  # trapped, no accessible neighbors

        # Observe noisy signals for each neighbor's reward
        signals = [(u, noisy_signal(rewards[u], beta, rng)) for u in neighbors]

        # Move to neighbor with highest signal (greedy policy)
        best_u = max(signals, key=lambda x: x[1])[0]
        v = best_u
        trajectory.append(v)

    return rewards[v], trajectory


def compute_reachable_set(adj, start):
    """BFS to find all vertices reachable from start via accessible edges."""
    visited = set()
    queue = [start]
    visited.add(start)
    while queue:
        v = queue.pop(0)
        for u in get_accessible_neighbors(adj, v):
            if u not in visited:
                visited.add(u)
                queue.append(u)
    return visited


def experiment_sweep_p(n=30, beta=1.0, T=None, p_values=None, M=500, seed=42):
    """
    Sweep irreversibility p at fixed cognitive budget β.
    Returns dict with results.
    """
    if T is None:
        T = n * n  # enough steps to traverse the grid
    if p_values is None:
        p_values = np.linspace(0, 0.95, 40)

    rng = np.random.default_rng(seed)
    results = {
        'p_values': p_values.tolist(),
        'beta': beta,
        'n': n,
        'T': T,
        'M': M,
        'mean_loss': [],
        'std_loss': [],
        'median_loss': [],
        'p90_loss': [],
        'p10_loss': [],
        'all_losses': [],  # for distribution analysis
        'mean_reachable_frac': [],
    }

    max_reward_expected = 1.0 - 1.0 / (n * n)  # E[max of n² Uniform]

    for p in p_values:
        losses = []
        reachable_fracs = []

        for trial in range(M):
            rewards, adj = setup_graph(n, p, rng)
            max_r = rewards.max()

            final_r, traj = run_agent(rewards, adj, beta, T, rng)
            loss = max_r - final_r
            losses.append(loss)

            # Sample reachable set size from a random start (subsample for speed)
            if trial < 50:
                start = rng.integers(n * n)
                reachable = compute_reachable_set(adj, start)
                reachable_fracs.append(len(reachable) / (n * n))

        losses = np.array(losses)
        results['mean_loss'].append(float(losses.mean()))
        results['std_loss'].append(float(losses.std()))
        results['median_loss'].append(float(np.median(losses)))
        results['p90_loss'].append(float(np.percentile(losses, 90)))
        results['p10_loss'].append(float(np.percentile(losses, 10)))
        results['all_losses'].append(losses.tolist())
        results['mean_reachable_frac'].append(float(np.mean(reachable_fracs)) if reachable_fracs else 0.0)

        print(f"  p={p:.3f}: mean_loss={losses.mean():.4f}, reachable={np.mean(reachable_fracs):.3f}")

    return results


def experiment_sweep_beta(n=30, p=0.5, T=None, beta_values=None, M=500, seed=42):
    """
    Sweep cognitive budget β at fixed irreversibility p.
    Shows that above critical p, increasing β doesn't help.
    """
    if T is None:
        T = n * n
    if beta_values is None:
        beta_values = np.linspace(0.1, 5.0, 20)

    rng = np.random.default_rng(seed)
    results = {
        'beta_values': beta_values.tolist(),
        'p': p,
        'n': n,
        'T': T,
        'M': M,
        'mean_loss': [],
    }

    for beta in beta_values:
        losses = []
        for _ in range(M):
            rewards, adj = setup_graph(n, p, rng)
            max_r = rewards.max()
            final_r, _ = run_agent(rewards, adj, beta, T, rng)
            losses.append(max_r - final_r)

        results['mean_loss'].append(float(np.mean(losses)))
        print(f"  β={beta:.2f}: mean_loss={np.mean(losses):.4f}")

    return results


def plot_phase_transition(results_p, filename="phase_transition_p.png"):
    """Plot mean welfare loss vs irreversibility p."""
    fig, axes = plt.subplots(1, 3, figsize=(18, 5))

    p = results_p['p_values']
    mean_loss = results_p['mean_loss']
    std_loss = results_p['std_loss']
    p90 = results_p['p90_loss']
    p10 = results_p['p10_loss']
    reachable = results_p['mean_reachable_frac']

    # Panel 1: Mean welfare loss vs p
    ax = axes[0]
    ax.plot(p, mean_loss, 'b-o', markersize=3, linewidth=1.5, label='Mean loss')
    ax.fill_between(p, p10, p90, alpha=0.2, color='blue', label='10th-90th percentile')
    ax.set_xlabel('Irreversibility p', fontsize=12)
    ax.set_ylabel('Welfare Loss', fontsize=12)
    ax.set_title(f'Welfare Loss vs Irreversibility\n(n={results_p["n"]}, β={results_p["beta"]}, M={results_p["M"]})', fontsize=11)
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)

    # Panel 2: Reachable fraction vs p (percolation indicator)
    ax = axes[1]
    ax.plot(p, reachable, 'r-o', markersize=3, linewidth=1.5)
    ax.set_xlabel('Irreversibility p', fontsize=12)
    ax.set_ylabel('Reachable Fraction of Graph', fontsize=12)
    ax.set_title('Reachable Set Size vs Irreversibility\n(Percolation Indicator)', fontsize=11)
    ax.axhline(y=0.5, color='gray', linestyle='--', alpha=0.5, label='50% threshold')
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)

    # Panel 3: Loss distribution at low-p vs high-p
    ax = axes[2]
    # Pick a low-p and high-p index
    low_idx = len(p) // 5       # ~20% of range
    high_idx = 4 * len(p) // 5  # ~80% of range
    low_p_val = p[low_idx]
    high_p_val = p[high_idx]

    losses_low = results_p['all_losses'][low_idx]
    losses_high = results_p['all_losses'][high_idx]

    ax.hist(losses_low, bins=40, alpha=0.5, density=True, color='green',
            label=f'p={low_p_val:.2f} (low irrev.)')
    ax.hist(losses_high, bins=40, alpha=0.5, density=True, color='red',
            label=f'p={high_p_val:.2f} (high irrev.)')
    ax.set_xlabel('Welfare Loss', fontsize=12)
    ax.set_ylabel('Density', fontsize=12)
    ax.set_title('Loss Distribution: Low vs High Irreversibility', fontsize=11)
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)

    plt.tight_layout()
    plt.savefig(OUT_DIR / filename, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / filename}")


def plot_beta_comparison(results_low_p, results_high_p, filename="beta_comparison.png"):
    """Plot: increasing β helps at low p but NOT at high p."""
    fig, ax = plt.subplots(figsize=(8, 5))

    ax.plot(results_low_p['beta_values'], results_low_p['mean_loss'],
            'g-o', markersize=4, linewidth=1.5, label=f'p={results_low_p["p"]} (low irrev.)')
    ax.plot(results_high_p['beta_values'], results_high_p['mean_loss'],
            'r-s', markersize=4, linewidth=1.5, label=f'p={results_high_p["p"]} (high irrev.)')

    ax.set_xlabel('Cognitive Budget β (bits)', fontsize=12)
    ax.set_ylabel('Mean Welfare Loss', fontsize=12)
    ax.set_title('Effect of Cognition on Welfare Loss\n'
                 '(More thinking helps only below irreversibility threshold)', fontsize=11)
    ax.legend(fontsize=10)
    ax.grid(True, alpha=0.3)

    plt.tight_layout()
    plt.savefig(OUT_DIR / filename, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / filename}")


def plot_heatmap(n=20, T=None, M=200, seed=42, filename="heatmap_p_beta.png"):
    """2D heatmap: mean welfare loss as function of (p, β). Phase boundary should be visible."""
    if T is None:
        T = n * n

    p_values = np.linspace(0, 0.95, 25)
    beta_values = np.linspace(0.2, 4.0, 20)
    loss_matrix = np.zeros((len(beta_values), len(p_values)))

    rng = np.random.default_rng(seed)
    total = len(p_values) * len(beta_values)
    done = 0

    for i, beta in enumerate(beta_values):
        for j, p in enumerate(p_values):
            losses = []
            for _ in range(M):
                rewards, adj = setup_graph(n, p, rng)
                max_r = rewards.max()
                final_r, _ = run_agent(rewards, adj, beta, T, rng)
                losses.append(max_r - final_r)
            loss_matrix[i, j] = np.mean(losses)
            done += 1
            if done % 50 == 0:
                print(f"  Heatmap: {done}/{total} cells done")

    fig, ax = plt.subplots(figsize=(10, 7))
    im = ax.imshow(loss_matrix, origin='lower', aspect='auto',
                   extent=[p_values[0], p_values[-1], beta_values[0], beta_values[-1]],
                   cmap='RdYlGn_r', vmin=0, vmax=0.8)

    # Mark the approximate phase boundary (contour at loss = 0.3)
    cs = ax.contour(p_values, beta_values, loss_matrix,
                    levels=[0.15, 0.25, 0.35], colors='black', linewidths=1.5)
    ax.clabel(cs, inline=True, fontsize=9, fmt='%.2f')

    ax.set_xlabel('Irreversibility p', fontsize=13)
    ax.set_ylabel('Cognitive Budget β (bits)', fontsize=13)
    ax.set_title(f'Mean Welfare Loss: Phase Diagram\n(n={n}, T={T}, M={M})', fontsize=12)
    plt.colorbar(im, ax=ax, label='Mean Welfare Loss')

    plt.tight_layout()
    plt.savefig(OUT_DIR / filename, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / filename}")

    return p_values, beta_values, loss_matrix


def plot_distribution_gallery(results_p, filename="distribution_gallery.png"):
    """Show welfare loss distributions at multiple p values."""
    p_values = results_p['p_values']
    # Pick 6 representative p values
    indices = [0, len(p_values)//5, 2*len(p_values)//5,
               3*len(p_values)//5, 4*len(p_values)//5, len(p_values)-1]

    fig, axes = plt.subplots(2, 3, figsize=(15, 9))
    axes = axes.flatten()

    for idx, ax_idx in enumerate(indices):
        ax = axes[idx]
        losses = results_p['all_losses'][ax_idx]
        p_val = p_values[ax_idx]

        ax.hist(losses, bins=40, density=True, alpha=0.7,
                color=plt.cm.RdYlGn_r(p_val), edgecolor='black', linewidth=0.3)
        ax.set_title(f'p = {p_val:.2f}', fontsize=12, fontweight='bold')
        ax.set_xlabel('Welfare Loss')
        ax.set_ylabel('Density')
        ax.set_xlim(0, 1)
        ax.grid(True, alpha=0.3)

        # Add stats
        losses_arr = np.array(losses)
        ax.axvline(losses_arr.mean(), color='red', linestyle='--', linewidth=1.5,
                   label=f'Mean={losses_arr.mean():.3f}')
        ax.legend(fontsize=8)

    plt.suptitle(f'Welfare Loss Distribution at Various Irreversibility Levels\n'
                 f'(n={results_p["n"]}, β={results_p["beta"]}, M={results_p["M"]})',
                 fontsize=13, fontweight='bold')
    plt.tight_layout()
    plt.savefig(OUT_DIR / filename, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / filename}")


if __name__ == "__main__":
    print("=" * 70)
    print("Phase Transition Simulation: Irreversibility x Bounded Rationality")
    print("=" * 70)

    # ── Experiment 1: Sweep p at fixed β ──
    print("\n[Exp 1] Sweeping irreversibility p at β=1.0...")
    t0 = time.time()
    results_p = experiment_sweep_p(n=30, beta=1.0, M=500, seed=42)
    print(f"  Done in {time.time()-t0:.1f}s")

    plot_phase_transition(results_p)
    plot_distribution_gallery(results_p)

    # ── Experiment 2: β sweep at low vs high p ──
    print("\n[Exp 2] Sweeping β at p=0.15 (low) and p=0.70 (high)...")
    t0 = time.time()
    results_beta_low = experiment_sweep_beta(n=30, p=0.15, M=300, seed=43)
    results_beta_high = experiment_sweep_beta(n=30, p=0.70, M=300, seed=44)
    print(f"  Done in {time.time()-t0:.1f}s")

    plot_beta_comparison(results_beta_low, results_beta_high)

    # ── Experiment 3: 2D heatmap (p, β) ──
    print("\n[Exp 3] Phase diagram heatmap (p x β)...")
    t0 = time.time()
    p_vals, beta_vals, loss_mat = plot_heatmap(n=20, M=200, seed=45)
    print(f"  Done in {time.time()-t0:.1f}s")

    # ── Save numerical results ──
    summary = {
        'exp1_p_sweep': {
            'p_values': results_p['p_values'],
            'mean_loss': results_p['mean_loss'],
            'reachable_frac': results_p['mean_reachable_frac'],
        },
        'exp2_beta_low': {
            'beta_values': results_beta_low['beta_values'],
            'mean_loss': results_beta_low['mean_loss'],
            'p': results_beta_low['p'],
        },
        'exp2_beta_high': {
            'beta_values': results_beta_high['beta_values'],
            'mean_loss': results_beta_high['mean_loss'],
            'p': results_beta_high['p'],
        },
    }
    with open(OUT_DIR / "simulation_results.json", "w") as f:
        json.dump(summary, f, indent=2)
    print(f"\nResults saved to {OUT_DIR / 'simulation_results.json'}")

    print("\n" + "=" * 70)
    print("ALL EXPERIMENTS COMPLETE. Check results/ for plots.")
    print("=" * 70)
