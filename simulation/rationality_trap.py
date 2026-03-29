"""
The Rationality Trap: Counterexample to Blackwell Monotonicity
===============================================================
A minimal example where more information --> STRICTLY WORSE outcomes.
The analogue of Allais paradox for bounded rationality.

MINIMAL (4 states): W(beta) is monotonically increasing.
    Perfectly rational agent is 2x worse than random.

EXTENDED (5 states): W(beta) has interior minimum.
    Perfectly rational agent is 47% worse than optimally bounded-rational.

Both violate Blackwell's theorem in the presence of topology.
"""

import numpy as np
from scipy.stats import norm
from scipy.optimize import minimize_scalar
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from pathlib import Path
import sys
import json

sys.path.insert(0, str(Path(__file__).parent))
from phase_transition_sim import OUT_DIR


def sigma_sq(beta):
    """Gaussian channel noise variance at capacity beta bits."""
    return 1.0 / (2.0 ** (2.0 * beta) - 1.0)


def prob_choose_higher(gap, beta):
    """
    P(agent chooses option with higher reward).
    gap = r_high - r_low > 0.
    Returns P(signal_high > signal_low) = Phi(gap / sqrt(2*sigma^2)).
    """
    if beta > 15:
        return 1.0 if gap > 0 else 0.5
    s2 = sigma_sq(beta)
    return float(norm.cdf(gap / np.sqrt(2 * s2)))


# MINIMAL EXAMPLE: 4 states
# States: S(0), A(0.6), B(0.4), G(1.0)
# Edges: S->A, S->B, B->G. A and G absorbing.

def W_minimal(beta):
    """
    E[W] for the 4-state minimal example.
    From S: choose A (trap) or B (passage to G).
    If A: stuck, loss = 1.0 - 0.6 = 0.4.
    If B: goes to G (only neighbor), loss = 0.
    """
    if beta < 0.001:
        return 0.5 * 0.4  # random
    p_A = prob_choose_higher(0.6 - 0.4, beta)  # gap = 0.2
    return p_A * 0.4


# EXTENDED EXAMPLE: 5 states
# States: S(0), A(0.6), B(0.4), D(0.1), G(1.0)
# Edges: S->A, S->B, B->D, B->G. A, D, G absorbing.

def W_extended(beta):
    """
    E[W] for the 5-state extended example.
    From S: choose A (trap, r=0.6) or B (passage, r=0.4).
    If A: stuck, loss = 0.4.
    If B: choose D (distractor, r=0.1) or G (goal, r=1.0).
       If D: stuck, loss = 0.9.
       If G: stuck, loss = 0.
    """
    if beta < 0.001:
        p_A = 0.5
        p_G_at_B = 0.5
    else:
        p_A = prob_choose_higher(0.6 - 0.4, beta)   # gap = 0.2 at S
        p_G_at_B = prob_choose_higher(1.0 - 0.1, beta)  # gap = 0.9 at B
    p_B = 1.0 - p_A
    p_D_at_B = 1.0 - p_G_at_B
    return p_A * 0.4 + p_B * p_D_at_B * 0.9


def find_optimal_beta(W_func, low=0.01, high=10.0):
    """Find beta that minimizes W via grid search + refinement."""
    # Grid search first (optimizer gets stuck in flat regions)
    betas = np.linspace(low, high, 500)
    Ws = np.array([W_func(b) for b in betas])
    idx = int(np.argmin(Ws))
    # Refine if interior minimum
    if 0 < idx < len(betas) - 1:
        lo = betas[max(0, idx - 3)]
        hi = betas[min(len(betas) - 1, idx + 3)]
        result = minimize_scalar(W_func, bounds=(lo, hi), method='bounded')
        return result.x, result.fun
    return float(betas[idx]), float(Ws[idx])


def compute_analytical_curves():
    """Compute W(beta) for both examples over a fine grid."""
    betas = np.concatenate([
        np.linspace(0.01, 0.5, 20),
        np.linspace(0.5, 3.0, 50),
        np.linspace(3.0, 10.0, 30),
    ])

    minimal_W = [W_minimal(b) for b in betas]
    extended_W = [W_extended(b) for b in betas]

    return betas, minimal_W, extended_W


def simulate_example(rewards, edges, beta, M=50000, T=20, seed=100):
    """
    Monte Carlo simulation of a small graph example.
    rewards: dict {state: reward}
    edges: dict {state: [list of (neighbor, state) reachable]}
    Returns mean welfare loss.
    """
    rng = np.random.default_rng(seed)
    states = list(rewards.keys())
    max_r = max(rewards.values())
    losses = []

    for _ in range(M):
        current = 'S'
        for _ in range(T):
            neighbors = edges.get(current, [])
            if not neighbors:
                break  # absorbing state
            if beta < 0.001:
                # random choice
                current = neighbors[rng.integers(len(neighbors))]
            else:
                s2 = sigma_sq(beta)
                signals = [(n, rewards[n] + rng.normal(0, np.sqrt(s2))) for n in neighbors]
                current = max(signals, key=lambda x: x[1])[0]
        losses.append(max_r - rewards[current])

    return float(np.mean(losses))


def run_mc_validation():
    """Validate analytical formulas with Monte Carlo."""
    # Minimal example
    rewards_min = {'S': 0.0, 'A': 0.6, 'B': 0.4, 'G': 1.0}
    edges_min = {'S': ['A', 'B'], 'B': ['G']}  # A and G absorbing

    # Extended example
    rewards_ext = {'S': 0.0, 'A': 0.6, 'B': 0.4, 'D': 0.1, 'G': 1.0}
    edges_ext = {'S': ['A', 'B'], 'B': ['D', 'G']}

    test_betas = [0.001, 0.5, 1.0, 1.5, 2.0, 3.0, 5.0, 10.0]
    print("\n  Validation (analytical vs Monte Carlo, M=50000):")
    print(f"  {'beta':>6} | {'Min(ana)':>9} {'Min(MC)':>9} | {'Ext(ana)':>9} {'Ext(MC)':>9}")
    print("  " + "-" * 55)

    mc_minimal = []
    mc_extended = []
    for beta in test_betas:
        ana_min = W_minimal(beta)
        ana_ext = W_extended(beta)
        mc_min = simulate_example(rewards_min, edges_min, beta)
        mc_ext = simulate_example(rewards_ext, edges_ext, beta)
        mc_minimal.append(mc_min)
        mc_extended.append(mc_ext)
        print(f"  {beta:6.3f} | {ana_min:9.4f} {mc_min:9.4f} | {ana_ext:9.4f} {mc_ext:9.4f}")

    return test_betas, mc_minimal, mc_extended


def plot_rationality_trap(betas, minimal_W, extended_W, mc_data=None,
                          filename="rationality_trap.png"):
    """
    The kill shot figure: W(beta) for both examples.
    """
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6))

    # Panel 1: Minimal (4-state)
    ax1.plot(betas, minimal_W, 'b-', linewidth=2.5, label='E[W(b)]')
    ax1.axhline(0.4, color='red', linestyle='--', linewidth=1.5,
                label='W(b=inf) = 0.40 (perfectly rational)')
    ax1.axhline(0.2, color='green', linestyle=':', linewidth=1.5,
                label='W(b->0) = 0.20 (random)')

    if mc_data:
        mc_betas, mc_min, _ = mc_data
        ax1.scatter(mc_betas, mc_min, color='red', s=40, zorder=5,
                    marker='x', label='Monte Carlo (M=50k)')

    ax1.set_xlabel('Information Capacity b (bits)', fontsize=12)
    ax1.set_ylabel('Expected Welfare Loss E[W]', fontsize=12)
    ax1.set_title('Minimal Example (4 states)\n'
                  'S(0) -> A(0.6) [trap] | B(0.4) -> G(1.0)',
                  fontsize=11, fontweight='bold')
    ax1.legend(fontsize=8.5, loc='center right')
    ax1.set_ylim(0, 0.55)
    ax1.set_xlim(0, 8)
    ax1.grid(True, alpha=0.3)

    # Annotation
    ax1.annotate('Perfectly rational agent\nis 2x WORSE than random',
                 xy=(5, 0.39), xytext=(3.5, 0.50),
                 fontsize=10, fontweight='bold', color='darkred',
                 arrowprops=dict(arrowstyle='->', color='darkred'),
                 bbox=dict(boxstyle='round', facecolor='lightyellow'))

    # Panel 2: Extended (5-state)
    ax2.plot(betas, extended_W, 'b-', linewidth=2.5, label='E[W(b)]')

    # Find and mark optimal beta
    opt_idx = np.argmin(extended_W)
    opt_beta = betas[opt_idx]
    opt_W = extended_W[opt_idx]
    ax2.plot(opt_beta, opt_W, 'g*', markersize=15, zorder=5,
             label=f'Optimal: b*={opt_beta:.1f}, W={opt_W:.3f}')

    ax2.axhline(0.4, color='red', linestyle='--', linewidth=1.5,
                label='W(b=inf) = 0.40')
    ax2.axhline(W_extended(0.001), color='orange', linestyle=':', linewidth=1.5,
                label=f'W(b->0) = {W_extended(0.001):.3f}')

    if mc_data:
        mc_betas, _, mc_ext = mc_data
        ax2.scatter(mc_betas, mc_ext, color='red', s=40, zorder=5,
                    marker='x', label='Monte Carlo (M=50k)')

    ax2.set_xlabel('Information Capacity b (bits)', fontsize=12)
    ax2.set_ylabel('Expected Welfare Loss E[W]', fontsize=12)
    ax2.set_title('Extended Example (5 states)\n'
                  'S(0) -> A(0.6) [trap] | B(0.4) -> D(0.1) [distractor] | G(1.0)',
                  fontsize=11, fontweight='bold')
    ax2.legend(fontsize=8.5, loc='upper right')
    ax2.set_ylim(0, 0.55)
    ax2.set_xlim(0, 8)
    ax2.grid(True, alpha=0.3)

    # Annotation: the gap
    pct_worse = (0.4 - opt_W) / opt_W * 100
    ax2.annotate(f'Rational agent is {pct_worse:.0f}% worse\n'
                 f'than optimally bounded-rational\n'
                 f'(interior optimum at b*={opt_beta:.1f})',
                 xy=(5, 0.39), xytext=(3.5, 0.50),
                 fontsize=10, fontweight='bold', color='darkred',
                 arrowprops=dict(arrowstyle='->', color='darkred'),
                 bbox=dict(boxstyle='round', facecolor='lightyellow'))

    plt.suptitle("The Rationality Trap: Counterexample to Blackwell Monotonicity\n"
                 "More information can make agents strictly WORSE under irreversibility",
                 fontsize=13, fontweight='bold')
    plt.tight_layout()
    plt.savefig(OUT_DIR / filename, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / filename}")


if __name__ == "__main__":
    print("=" * 70)
    print("THE RATIONALITY TRAP")
    print("Counterexample to Blackwell Monotonicity under Irreversibility")
    print("=" * 70)

    # Analytical computation
    print("\n1. Analytical computation:")
    betas, minimal_W, extended_W = compute_analytical_curves()

    # Find optima
    opt_beta_min, opt_W_min = find_optimal_beta(W_minimal)
    opt_beta_ext, opt_W_ext = find_optimal_beta(W_extended)

    print(f"\n  MINIMAL (4 states):")
    print(f"    W(b=0)   = {W_minimal(0.001):.4f}")
    print(f"    W(b=inf) = {W_minimal(15.0):.4f}")
    print(f"    Optimal: b*={opt_beta_min:.3f}, W*={opt_W_min:.4f}")
    print(f"    Rational agent is {(W_minimal(15.0) - opt_W_min)/opt_W_min * 100:.0f}% "
          f"worse than optimal")

    print(f"\n  EXTENDED (5 states):")
    print(f"    W(b=0)   = {W_extended(0.001):.4f}")
    print(f"    W(b=inf) = {W_extended(15.0):.4f}")
    print(f"    Optimal: b*={opt_beta_ext:.3f}, W*={opt_W_ext:.4f}")
    print(f"    Rational agent is {(W_extended(15.0) - opt_W_ext)/opt_W_ext * 100:.0f}% "
          f"worse than optimal")

    # Monte Carlo validation
    print("\n2. Monte Carlo validation:")
    mc_betas, mc_min, mc_ext = run_mc_validation()

    # Plot
    print("\n3. Generating plots:")
    plot_rationality_trap(betas, minimal_W, extended_W,
                          mc_data=(mc_betas, mc_min, mc_ext))

    # Save data
    save_data = {
        'minimal': {
            'description': 'S(0)->A(0.6)[trap] | B(0.4)->G(1.0)',
            'W_at_0': W_minimal(0.001),
            'W_at_inf': W_minimal(15.0),
            'optimal_beta': float(opt_beta_min),
            'optimal_W': float(opt_W_min),
        },
        'extended': {
            'description': 'S(0)->A(0.6)[trap] | B(0.4)->D(0.1)[distractor] | G(1.0)',
            'W_at_0': W_extended(0.001),
            'W_at_inf': W_extended(15.0),
            'optimal_beta': float(opt_beta_ext),
            'optimal_W': float(opt_W_ext),
        },
    }
    with open(OUT_DIR / "rationality_trap_results.json", "w") as f:
        json.dump(save_data, f, indent=2)

    print("\n" + "=" * 70)
    print("KEY RESULT:")
    print(f"  The perfectly rational agent (b=inf) incurs welfare loss = 0.40")
    print(f"  The optimally bounded-rational agent (b*={opt_beta_ext:.1f}) "
          f"incurs loss = {opt_W_ext:.3f}")
    print(f"  Perfect rationality is "
          f"{(W_extended(15.0) - opt_W_ext)/opt_W_ext * 100:.0f}% WORSE.")
    print(f"  This is a counterexample to Blackwell (1953) monotonicity")
    print(f"  under irreversibility.")
    print("=" * 70)
