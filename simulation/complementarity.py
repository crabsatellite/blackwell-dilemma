"""
Information-Knowledge Complementarity
======================================
Formalizes how signal precision (beta) and topological knowledge (alpha)
interact. Shows a phase transition: substitutes below beta*, complements above.

Key result:
  d^2 W / d(beta) d(alpha) changes sign at the greedy optimum beta*.
  Below beta*: noise substitutes for knowledge (substitutes).
  Above beta*: knowledge amplifies signal value (complements).
"""

import numpy as np
from scipy.stats import norm
def derivative(func, x0, dx=1e-3):
    """Central finite difference."""
    return (func(x0 + dx) - func(x0 - dx)) / (2 * dx)
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


def W_greedy(beta, p=0.0):
    """Greedy welfare on 5-state instance with blocking p."""
    if beta < 0.001:
        p_A, p_G = 0.5, 0.5
    else:
        p_A = prob_choose_higher(0.2, beta)
        p_G = prob_choose_higher(0.9, beta)
    W_unblocked = p_A * 0.6 + (1 - p_A) * (p_G * 1.0 + (1 - p_G) * 0.1)
    return p * 0.6 + (1 - p) * W_unblocked


def W_bayesian(beta, p=0.0):
    """Bayesian welfare (constant = 1-0.4p)."""
    return p * 0.6 + (1 - p) * 1.0


def W_mixed(beta, alpha, p=0.0):
    """
    Welfare for agent with topological knowledge alpha in [0,1].
    alpha=0: greedy, alpha=1: Bayesian.
    Interpolation: with prob alpha, agent uses Bayesian strategy.
    """
    return alpha * W_bayesian(beta, p) + (1 - alpha) * W_greedy(beta, p)


def cross_derivative(beta, p=0.0, h=0.01):
    """
    d^2 W / d(beta) d(alpha) = d W_B/d(beta) - d W_G/d(beta)
    Since W_B is constant, this equals -d W_G/d(beta).
    """
    dWG = derivative(lambda b: W_greedy(b, p), beta, dx=h)
    dWB = derivative(lambda b: W_bayesian(b, p), beta, dx=h)
    return dWB - dWG


def plot_complementarity(filename="complementarity.png"):
    """Generate figure for information-knowledge complementarity."""
    betas = np.linspace(0.05, 8.0, 300)

    fig, axes = plt.subplots(1, 3, figsize=(18, 5.5))

    # Panel A: Welfare curves and marginal value of knowledge
    ax = axes[0]
    for p in [0.0, 0.3]:
        wg = [W_greedy(b, p) for b in betas]
        wb = [W_bayesian(b, p) for b in betas]
        gap = [b - g for b, g in zip(wb, wg)]
        style = '-' if p == 0 else '--'
        ax.plot(betas, gap, style, linewidth=2,
                label=rf'$\mathrm{{RP}}(\beta), p={p}$')

    # Mark beta* for p=0
    wg_p0 = [W_greedy(b, 0) for b in betas]
    opt_idx = int(np.argmax(wg_p0))
    gap_p0 = [W_bayesian(b, 0) - W_greedy(b, 0) for b in betas]
    ax.axvline(betas[opt_idx], color='gray', linestyle=':', alpha=0.5)
    ax.annotate(rf'$\beta^*_G \approx {betas[opt_idx]:.1f}$',
                xy=(betas[opt_idx], gap_p0[opt_idx]),
                xytext=(betas[opt_idx] + 1.0, gap_p0[opt_idx] + 0.02),
                fontsize=10, arrowprops=dict(arrowstyle='->', color='gray'))

    ax.set_xlabel(r'Signal precision $\beta$', fontsize=12)
    ax.set_ylabel(r'$\mathrm{RP}(\beta) = W_B - W_G$', fontsize=12)
    ax.set_title('(a) Rationality premium', fontsize=12, fontweight='bold')
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)

    # Panel B: Cross-derivative
    ax = axes[1]
    for p, color in [(0.0, '#228B22'), (0.3, '#1a7a1a')]:
        cd = [cross_derivative(b, p) for b in betas]
        style = '-' if p == 0 else '--'
        ax.plot(betas, cd, style, color=color, linewidth=2,
                label=rf'$p={p}$')

    ax.axhline(0, color='k', linestyle='-', linewidth=0.5)
    ax.axvline(betas[opt_idx], color='gray', linestyle=':', alpha=0.5)
    ax.fill_between(betas[:opt_idx+1],
                     [cross_derivative(b, 0) for b in betas[:opt_idx+1]],
                     0, alpha=0.1, color='red', label='Substitutes')
    ax.fill_between(betas[opt_idx:],
                     [cross_derivative(b, 0) for b in betas[opt_idx:]],
                     0, alpha=0.1, color='blue', label='Complements')

    ax.set_xlabel(r'Signal precision $\beta$', fontsize=12)
    ax.set_ylabel(r'$\partial^2 W / \partial\beta\,\partial\alpha$', fontsize=12)
    ax.set_title('(b) Cross-derivative', fontsize=12, fontweight='bold')
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)

    # Panel C: Marginal value of beta, conditional on alpha
    ax = axes[2]
    for alpha, color, label in [(0.0, 'red', r'$\alpha=0$ (greedy)'),
                                  (0.5, 'purple', r'$\alpha=0.5$ (partial)'),
                                  (1.0, 'blue', r'$\alpha=1$ (Bayesian)')]:
        dW_dbeta = [derivative(lambda b: W_mixed(b, alpha, 0.0), b, dx=0.01)
                    for b in betas]
        ax.plot(betas, dW_dbeta, '-', color=color, linewidth=2, label=label)

    ax.axhline(0, color='k', linestyle='-', linewidth=0.5)
    ax.axvline(betas[opt_idx], color='gray', linestyle=':', alpha=0.5)

    ax.set_xlabel(r'Signal precision $\beta$', fontsize=12)
    ax.set_ylabel(r'$\partial W / \partial \beta$', fontsize=12)
    ax.set_title(r'(c) Marginal value of signal precision', fontsize=12,
                 fontweight='bold')
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)

    plt.tight_layout()
    plt.savefig(OUT_DIR / filename, dpi=200, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / filename}")


def compute_key_values():
    """Compute and print key values for theorem."""
    print("\nCOMPLEMENTARITY ANALYSIS")

    betas_fine = np.linspace(0.05, 10, 1000)
    wg = [W_greedy(b) for b in betas_fine]
    opt_idx = int(np.argmax(wg))
    beta_star = betas_fine[opt_idx]

    print(f"  Greedy optimum: beta* = {beta_star:.2f}")
    print(f"  W_G(beta*) = {wg[opt_idx]:.4f}")
    print(f"  W_G(inf)   = {W_greedy(15):.4f}")

    # Cross-derivative at key points
    for b in [0.5, 1.0, beta_star, 2.0, 3.0, 5.0]:
        cd = cross_derivative(b)
        regime = "SUBSTITUTES" if cd < 0 else "COMPLEMENTS"
        print(f"  beta={b:.1f}: cross-deriv = {cd:+.4f} ({regime})")

    # Exact sign change
    for i in range(len(betas_fine) - 1):
        cd1 = cross_derivative(betas_fine[i])
        cd2 = cross_derivative(betas_fine[i + 1])
        if cd1 < 0 and cd2 >= 0:
            print(f"\n  Sign change at beta = {betas_fine[i]:.3f} to {betas_fine[i+1]:.3f}")
            print(f"  (Greedy optimum at beta* = {beta_star:.3f})")
            break


if __name__ == "__main__":
    print("=" * 70)
    print("INFORMATION-KNOWLEDGE COMPLEMENTARITY")
    print("=" * 70)

    compute_key_values()
    print("\nGenerating figure...")
    plot_complementarity()

    print("\n" + "=" * 70)
    print("RESULT: Signal precision and topological knowledge are:")
    print(f"  SUBSTITUTES for beta < beta* (noise substitutes for knowledge)")
    print(f"  COMPLEMENTS for beta > beta* (knowledge amplifies signal value)")
    print(f"  The transition occurs at the greedy optimum beta*.")
    print("=" * 70)
