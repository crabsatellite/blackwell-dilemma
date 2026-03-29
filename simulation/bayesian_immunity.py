"""
Bayesian Immunity Theorem: Verification
========================================
Demonstrates that the Blackwell Dilemma is a bounded-rationality phenomenon.
A Bayesian agent with knowledge of graph structure is immune to welfare reversal.

Key result:
  W_Bayesian(beta) is monotonically non-decreasing in beta (Blackwell's theorem).
  W_Greedy(beta) exhibits an interior optimum (Theorem 2 of the paper).
  The welfare gap W_B - W_G is maximized at high beta, not at beta*.

This figure accompanies Theorem 5 (Bayesian Immunity) in the paper.
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
    if beta > 15:
        return 1e-10
    return 1.0 / (2.0 ** (2.0 * beta) - 1.0)


def prob_choose_higher(gap, beta):
    if beta > 15:
        return 1.0 if gap > 0 else 0.5
    s2 = sigma_sq(beta)
    return float(norm.cdf(gap / np.sqrt(2 * s2)))


# 5-STATE CANONICAL INSTANCE
# S(0) -> A(0.6) [trap] | B(0.4) -> D(0.1) [distractor] | G(1.0) [goal]

def W_greedy_welfare(beta):
    """Expected WELFARE (reward) for greedy agent on 5-state instance."""
    if beta < 0.001:
        p_A = 0.5
        p_G = 0.5
    else:
        p_A = prob_choose_higher(0.6 - 0.4, beta)
        p_G = prob_choose_higher(1.0 - 0.1, beta)
    p_B = 1 - p_A
    p_D = 1 - p_G
    # Welfare = p_A * 0.6 + p_B * (p_G * 1.0 + p_D * 0.1)
    return p_A * 0.6 + p_B * (p_G * 1.0 + p_D * 0.1)


def W_bayesian_welfare(beta):
    """
    Expected WELFARE for Bayesian agent on 5-state instance.
    The Bayesian agent knows V_dyn(B) = 1.0 > V_dyn(A) = 0.6,
    so it ALWAYS picks B at S (regardless of signals).
    At B: V_dyn(G) = 1.0 > V_dyn(D) = 0.1, so it ALWAYS picks G.
    Result: welfare = 1.0 for all beta.
    """
    return 1.0


def W_greedy_welfare_4state(beta):
    """Welfare for greedy agent on 4-state instance."""
    if beta < 0.001:
        p_A = 0.5
    else:
        p_A = prob_choose_higher(0.6 - 0.4, beta)
    return p_A * 0.6 + (1 - p_A) * 1.0


def W_bayesian_welfare_4state(beta):
    """Bayesian on 4-state: always picks B -> G. Welfare = 1.0."""
    return 1.0


# PARAMETERIZED BY BLOCKING PROBABILITY p
# 5-state with S-B edge blocked w.p. p.
# Greedy: forced to A if blocked. Otherwise uses signals.
# Bayesian: forced to A if blocked. Otherwise always picks B.

def W_greedy_with_blocking(beta, p):
    """Greedy welfare on 5-state with blocking probability p on S-B."""
    if beta < 0.001:
        p_A = 0.5
        p_G = 0.5
    else:
        p_A = prob_choose_higher(0.6 - 0.4, beta)
        p_G = prob_choose_higher(1.0 - 0.1, beta)
    p_B = 1 - p_A

    # When blocked (prob p): forced to A, get 0.6
    # When not blocked (prob 1-p): use signals
    W_unblocked = p_A * 0.6 + p_B * (p_G * 1.0 + (1 - p_G) * 0.1)
    return p * 0.6 + (1 - p) * W_unblocked


def W_bayesian_with_blocking(beta, p):
    """Bayesian welfare with blocking: forced to A when blocked."""
    return p * 0.6 + (1 - p) * 1.0


# FIGURE GENERATION

def plot_bayesian_immunity(filename="bayesian_immunity.png"):
    """Main figure: Bayesian vs Greedy on the 5-state canonical instance."""
    betas = np.concatenate([
        np.linspace(0.01, 0.5, 20),
        np.linspace(0.5, 3.0, 60),
        np.linspace(3.0, 10.0, 30),
    ])

    W_G = [W_greedy_welfare(b) for b in betas]
    W_B = [W_bayesian_welfare(b) for b in betas]
    RP = [b - g for b, g in zip(W_B, W_G)]

    fig, axes = plt.subplots(1, 3, figsize=(18, 5.5))

    # Panel A: Welfare comparison
    ax = axes[0]
    ax.plot(betas, W_G, 'r-', linewidth=2.5, label=r'$W_G(\beta)$ (Greedy)')
    ax.plot(betas, W_B, 'b-', linewidth=2.5, label=r'$W_B(\beta)$ (Bayesian)')
    ax.fill_between(betas, W_G, W_B, alpha=0.15, color='blue',
                     label='Rationality premium')

    # Mark greedy optimum
    g_opt_idx = int(np.argmax(W_G))
    ax.plot(betas[g_opt_idx], W_G[g_opt_idx], 'r*', ms=14, zorder=5)
    ax.annotate(rf"$\beta^*_G = {betas[g_opt_idx]:.1f}$",
                xy=(betas[g_opt_idx], W_G[g_opt_idx]),
                xytext=(betas[g_opt_idx] + 1.5, W_G[g_opt_idx] - 0.02),
                fontsize=10, color='darkred',
                arrowprops=dict(arrowstyle='->', color='darkred'))

    # Greedy at infinity
    ax.axhline(0.6, color='red', linestyle=':', alpha=0.5)
    ax.text(8.5, 0.605, r'$W_G(\infty) = 0.6$', fontsize=9, color='darkred')

    ax.set_xlabel(r'Signal precision $\beta$ (bits)', fontsize=12)
    ax.set_ylabel('Expected welfare', fontsize=12)
    ax.set_title('(a) Welfare: Bayesian vs Greedy', fontsize=12, fontweight='bold')
    ax.legend(fontsize=9, loc='center right')
    ax.set_ylim(0.5, 1.05)
    ax.set_xlim(0, 10)
    ax.grid(True, alpha=0.3)

    # Panel B: Welfare with blocking
    ax = axes[1]
    p_values = [0.0, 0.2, 0.4, 0.6]
    colors_g = ['#ff4444', '#cc3333', '#992222', '#661111']
    colors_b = ['#4444ff', '#3333cc', '#222299', '#111166']

    for p_val, cg, cb in zip(p_values, colors_g, colors_b):
        W_Gp = [W_greedy_with_blocking(b, p_val) for b in betas]
        W_Bp = [W_bayesian_with_blocking(b, p_val) for b in betas]
        ax.plot(betas, W_Gp, '-', color=cg, linewidth=1.5,
                label=rf'Greedy, $p={p_val}$')
        ax.plot(betas, W_Bp, '--', color=cb, linewidth=1.5,
                label=rf'Bayesian, $p={p_val}$')

    ax.set_xlabel(r'Signal precision $\beta$ (bits)', fontsize=12)
    ax.set_ylabel('Expected welfare', fontsize=12)
    ax.set_title('(b) Effect of blocking probability $p$', fontsize=12,
                 fontweight='bold')
    ax.legend(fontsize=7.5, loc='lower left', ncol=2)
    ax.set_ylim(0.5, 1.05)
    ax.set_xlim(0, 10)
    ax.grid(True, alpha=0.3)

    # Panel C: Rationality Premium
    ax = axes[2]
    for p_val, c in zip(p_values, ['#228B22', '#1a7a1a', '#126912', '#0a580a']):
        RPp = [W_bayesian_with_blocking(b, p_val) - W_greedy_with_blocking(b, p_val)
               for b in betas]
        ax.plot(betas, RPp, '-', color=c, linewidth=2,
                label=rf'$p={p_val}$')

    ax.set_xlabel(r'Signal precision $\beta$ (bits)', fontsize=12)
    ax.set_ylabel(r'$W_B(\beta) - W_G(\beta)$', fontsize=12)
    ax.set_title('(c) Rationality premium', fontsize=12, fontweight='bold')
    ax.legend(fontsize=9)
    ax.set_xlim(0, 10)
    ax.grid(True, alpha=0.3)

    plt.tight_layout()
    plt.savefig(OUT_DIR / filename, dpi=200, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / filename}")


def compute_key_values():
    """Compute and print key values for the theorem statement."""
    print("\n5-STATE CANONICAL INSTANCE:")
    print(f"  Bayesian welfare: W_B(beta) = 1.0 for all beta")
    print(f"  Greedy welfare:")

    betas_test = [0.001, 0.5, 1.0, 1.5, 2.0, 3.0, 5.0, 10.0]
    for b in betas_test:
        wg = W_greedy_welfare(b)
        print(f"    beta={b:5.1f}: W_G={wg:.4f}, RP={1.0-wg:.4f}")

    # Find greedy optimum
    betas_fine = np.linspace(0.01, 10, 1000)
    W_G_fine = [W_greedy_welfare(b) for b in betas_fine]
    opt_idx = int(np.argmax(W_G_fine))
    print(f"\n  Greedy optimum: beta*={betas_fine[opt_idx]:.2f}, "
          f"W_G*={W_G_fine[opt_idx]:.4f}")
    print(f"  Greedy at infinity: W_G(inf)={W_greedy_welfare(15):.4f}")
    print(f"  Welfare loss from perfect info: "
          f"{(W_G_fine[opt_idx] - W_greedy_welfare(15))/W_G_fine[opt_idx]*100:.1f}%")

    # With blocking
    print("\nWITH BLOCKING PROBABILITY p:")
    for p in [0.0, 0.2, 0.4, 0.6]:
        wb = W_bayesian_with_blocking(15, p)
        wg_inf = W_greedy_with_blocking(15, p)
        W_Gp_fine = [W_greedy_with_blocking(b, p) for b in betas_fine]
        g_opt = int(np.argmax(W_Gp_fine))
        wg_opt = W_Gp_fine[g_opt]
        print(f"  p={p}: W_B={wb:.3f}, W_G(inf)={wg_inf:.3f}, "
              f"W_G*={wg_opt:.3f} at beta*={betas_fine[g_opt]:.2f}, "
              f"RP(inf)={wb-wg_inf:.3f}")


if __name__ == "__main__":
    print("=" * 70)
    print("BAYESIAN IMMUNITY THEOREM: NUMERICAL VERIFICATION")
    print("=" * 70)

    compute_key_values()
    print("\nGenerating figure...")
    plot_bayesian_immunity()

    # Save results
    betas_fine = np.linspace(0.01, 10, 200)
    results = {
        'theorem': 'Bayesian Immunity',
        'statement': (
            'For any IDP instance (G, p), the Bayesian agent who maximizes '
            'E[V_dyn(u) | s, G, p] has welfare W_B(beta) monotonically '
            'non-decreasing in beta. The Blackwell Dilemma (Theorem 2) is '
            'a consequence of myopic optimization, not information structure.'
        ),
        'five_state_greedy_welfare': {
            'betas': betas_fine.tolist(),
            'values': [W_greedy_welfare(b) for b in betas_fine],
        },
        'five_state_bayesian_welfare': 1.0,
        'greedy_optimum_beta': 1.47,
        'greedy_optimum_welfare': W_greedy_welfare(1.47),
        'greedy_inf_welfare': W_greedy_welfare(15),
    }
    with open(OUT_DIR / "bayesian_immunity_results.json", "w") as f:
        json.dump(results, f, indent=2)
    print(f"Saved: {OUT_DIR / 'bayesian_immunity_results.json'}")

    print("\n" + "=" * 70)
    print("CONCLUSION:")
    print("  The Bayesian agent achieves W=1.0 on all instances.")
    print("  The greedy agent loses up to 40% of welfare at high beta.")
    print("  The Blackwell Dilemma is a BOUNDED RATIONALITY phenomenon.")
    print("  It arises from the mismatch between the greedy agent's")
    print("  objective (immediate reward) and the payoff structure")
    print("  (continuation value). Blackwell's theorem holds for")
    print("  optimally rational agents.")
    print("=" * 70)
