"""
Trap Prevalence: The Information-Proof Kill Shot
=================================================
Computes the fraction of vertices where V_static and V_dynamic
give OPPOSITE rankings of neighbors.

V_static(u) = r(u)               (standard framework: immediate reward)
V_dynamic(u) = max_{w in R(u)} r(w)  (IDP framework: reachable max)

When these disagree, the standard decision rule (maximize immediate reward)
sends the agent in the WRONG direction. No amount of information about
immediate rewards can fix this — the error is in the OBJECTIVE, not the SIGNAL.

Key prediction: trap prevalence undergoes a phase transition at p_c.
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
from phase_transition_sim import (setup_graph, get_accessible_neighbors,
                                   compute_reachable_set, OUT_DIR)


def compute_all_dynamic_values(adj, rewards, N):
    """V_dynamic(v) = max reward in R(v) for all vertices."""
    v_dynamic = np.zeros(N)
    for v in range(N):
        reachable = compute_reachable_set(adj, v)
        v_dynamic[v] = max(rewards[w] for w in reachable)
    return v_dynamic


def measure_trap_prevalence(adj, rewards, N):
    """
    For each vertex with 2+ accessible neighbors:
    check if V_static and V_dynamic disagree on best neighbor.
    Returns (n_disagree, n_total, mean_loss_gap).
    """
    v_dynamic = compute_all_dynamic_values(adj, rewards, N)

    n_total = 0
    n_disagree = 0
    loss_gaps = []

    for v in range(N):
        neighbors = get_accessible_neighbors(adj, v)
        if len(neighbors) < 2:
            continue

        # V_static: best neighbor by immediate reward
        static_best = max(neighbors, key=lambda u: rewards[u])
        # V_dynamic: best neighbor by reachable max
        dynamic_best = max(neighbors, key=lambda u: v_dynamic[u])

        n_total += 1
        # Only count as trap if static choice leads to STRICTLY worse
        # dynamic outcome (not just tie-breaking artifact)
        vd_of_choice = v_dynamic[static_best]
        vd_of_optimal = v_dynamic[dynamic_best]
        gap = vd_of_optimal - vd_of_choice
        if gap > 1e-10:
            n_disagree += 1
            loss_gaps.append(gap)

    return n_disagree, n_total, loss_gaps


def experiment_trap_prevalence(n=20, M=80, seed=45):
    """
    Sweep p, compute trap prevalence at each value.
    Uses n=20 (400 vertices) for speed since we need BFS from every vertex.
    """
    rng = np.random.default_rng(seed)
    N = n * n
    p_values = np.array([0.0, 0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.35,
                         0.40, 0.45, 0.50, 0.55, 0.60, 0.65, 0.70, 0.80])

    results = []
    for p in p_values:
        total_disagree = 0
        total_vertices = 0
        all_gaps = []

        for _ in range(M):
            rewards, adj = setup_graph(n, p, rng)
            nd, nt, gaps = measure_trap_prevalence(adj, rewards, N)
            total_disagree += nd
            total_vertices += nt
            all_gaps.extend(gaps)

        prevalence = total_disagree / total_vertices if total_vertices > 0 else 0
        mean_gap = float(np.mean(all_gaps)) if all_gaps else 0
        results.append({
            'p': float(p),
            'prevalence': prevalence,
            'mean_gap': mean_gap,
            'n_disagree': total_disagree,
            'n_total': total_vertices,
        })
        print(f"  p={p:.2f}: prevalence={prevalence:.4f} "
              f"({total_disagree}/{total_vertices}), mean_gap={mean_gap:.4f}")

    return results


def plot_trap_prevalence(results, filename="trap_prevalence.png"):
    """
    The information-proof plot: shows that the standard decision rule
    is wrong at a fraction of vertices that phase-transitions at p_c.
    """
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6))

    ps = [r['p'] for r in results]
    prevs = [r['prevalence'] for r in results]
    gaps = [r['mean_gap'] for r in results]

    # Panel 1: Trap prevalence
    ax1.plot(ps, [p * 100 for p in prevs], 'ro-', linewidth=2.5, markersize=8)
    ax1.axvline(0.5, color='gray', linestyle=':', alpha=0.5, label='p_c = 0.5')
    ax1.set_xlabel('Irreversibility p', fontsize=12)
    ax1.set_ylabel('Trap Prevalence (%)\n(V_static != V_dynamic)', fontsize=12)
    ax1.set_title('Fraction of Vertices Where Standard\n'
                  'Decision Rule Gives WRONG Direction',
                  fontsize=11, fontweight='bold')
    ax1.legend(fontsize=10)
    ax1.set_ylim(bottom=0)
    ax1.grid(True, alpha=0.3)

    # Annotate the phase transition
    if len(prevs) > 0:
        max_prev = max(prevs)
        ax1.annotate(f'Peak: {max_prev*100:.1f}% of choices\nare WRONG under V_static',
                     xy=(ps[prevs.index(max_prev)], max_prev * 100),
                     xytext=(0.15, max_prev * 100 * 0.9),
                     fontsize=10, fontweight='bold', color='darkred',
                     arrowprops=dict(arrowstyle='->', color='darkred'))

    # Panel 2: Mean loss gap when wrong
    ax2.plot(ps, gaps, 'bs-', linewidth=2.5, markersize=8)
    ax2.axvline(0.5, color='gray', linestyle=':', alpha=0.5, label='p_c = 0.5')
    ax2.set_xlabel('Irreversibility p', fontsize=12)
    ax2.set_ylabel('Mean V_dynamic Gap\n(when V_static is wrong)', fontsize=12)
    ax2.set_title('Cost of Using Wrong Objective\n'
                  '= V_dynamic(correct) - V_dynamic(chosen)',
                  fontsize=11, fontweight='bold')
    ax2.legend(fontsize=10)
    ax2.set_ylim(bottom=0)
    ax2.grid(True, alpha=0.3)

    plt.suptitle('The Information-Proof Kill Shot:\n'
                 'Standard Rational Choice Is Structurally Wrong Above p_c\n'
                 '(regardless of signal quality)',
                 fontsize=13, fontweight='bold')
    plt.tight_layout()
    plt.savefig(OUT_DIR / filename, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / filename}")


if __name__ == "__main__":
    print("=" * 70)
    print("TRAP PREVALENCE: The Information-Proof Kill Shot")
    print("=" * 70)

    t0 = time.time()
    results = experiment_trap_prevalence(n=20, M=80, seed=45)
    elapsed = time.time() - t0
    print(f"\nTotal time: {elapsed:.1f}s")

    plot_trap_prevalence(results)

    with open(OUT_DIR / "trap_prevalence_results.json", "w") as f:
        json.dump(results, f, indent=2)

    # Summary
    print("\n" + "=" * 70)
    print("SUMMARY:")
    for r in results:
        if r['p'] in [0.0, 0.30, 0.50, 0.60, 0.70]:
            print(f"  p={r['p']:.2f}: {r['prevalence']*100:.1f}% of decisions wrong, "
                  f"mean gap={r['mean_gap']:.4f}")
    print("=" * 70)
