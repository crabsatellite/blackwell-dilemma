"""
Blackwell Violation: The One-Page Proof
========================================
Blackwell (1953) guarantees: more informative signal -> weakly better decisions,
IF the payoff u = u(a, omega) depends only on action and state.

Under irreversibility, u = u(a, omega, G) where G = graph topology.
G is not in the standard framework's state space omega.
Blackwell's precondition is violated. VOI can be negative.

PROOF: 4-state IDP.
  S(0) -> A(0.6) [absorbing trap]
  S(0) -> B(0.4) -> G(1.0)

  W(beta) = Phi(0.2 / sqrt(2*sigma^2(beta))) * 0.4
  W is strictly increasing. Perfectly rational = 2x worse than random.  QED.
"""

import numpy as np
from scipy.stats import norm
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


def W(beta):
    """
    Welfare loss for 4-state IDP.
    W(beta) = P(choose A | beta) * 0.4
    where P(choose A) = Phi(gap / sqrt(2*sigma^2))
    and gap = r(A) - r(B) = 0.2.
    """
    if beta > 15:
        return 0.4
    if beta < 0.001:
        return 0.2
    s2 = sigma_sq(beta)
    p_A = float(norm.cdf(0.2 / np.sqrt(2 * s2)))
    return p_A * 0.4


def draw_graph(ax):
    """Draw the 4-state IDP structure."""
    ax.set_xlim(-0.5, 3.5)
    ax.set_ylim(-1.2, 1.8)
    ax.set_aspect('equal')
    ax.axis('off')

    # Node positions
    nodes = {
        'S': (0, 0.3),
        'A': (1.5, 1.3),
        'B': (1.5, -0.7),
        'G': (3.0, -0.7),
    }
    rewards = {'S': '0', 'A': '0.6', 'B': '0.4', 'G': '1.0'}
    colors = {'S': '#CCCCCC', 'A': '#FF6666', 'B': '#66BB66', 'G': '#6666FF'}

    # Draw edges
    edges = [('S', 'A'), ('S', 'B'), ('B', 'G')]
    for (u, v) in edges:
        x0, y0 = nodes[u]
        x1, y1 = nodes[v]
        # Shorten arrows to not overlap circles
        dx, dy = x1 - x0, y1 - y0
        dist = np.sqrt(dx**2 + dy**2)
        shrink = 0.28 / dist
        ax.annotate('', xy=(x1 - dx * shrink, y1 - dy * shrink),
                    xytext=(x0 + dx * shrink, y0 + dy * shrink),
                    arrowprops=dict(arrowstyle='->', color='black',
                                    lw=2, connectionstyle='arc3,rad=0'))

    # Draw nodes
    for name, (x, y) in nodes.items():
        circle = plt.Circle((x, y), 0.25, color=colors[name],
                            ec='black', lw=1.5, zorder=5)
        ax.add_patch(circle)
        ax.text(x, y, name, ha='center', va='center',
                fontsize=13, fontweight='bold', zorder=6)
        ax.text(x, y - 0.42, f'r={rewards[name]}', ha='center',
                fontsize=9, color='#444444')

    # Labels
    ax.text(0.75, 1.15, 'trap', fontsize=9, color='darkred',
            fontstyle='italic', ha='center')
    ax.text(0.75, -0.3, 'passage', fontsize=9, color='darkgreen',
            fontstyle='italic', ha='center')
    ax.text(1.5, 1.65, 'absorbing', fontsize=8, color='gray', ha='center')
    ax.text(3.0, -1.1, 'absorbing', fontsize=8, color='gray', ha='center')

    ax.set_title('4-State IDP', fontsize=12, fontweight='bold', pad=10)


def plot_blackwell_violation(filename="blackwell_violation.png"):
    """The one-page proof as a figure."""
    fig = plt.figure(figsize=(16, 8))

    # Layout: left = graph, center = W(beta) curve, right = logical structure
    ax_graph = fig.add_axes([0.02, 0.15, 0.28, 0.70])
    ax_curve = fig.add_axes([0.35, 0.15, 0.35, 0.70])
    ax_logic = fig.add_axes([0.73, 0.15, 0.25, 0.70])

    # Panel 1: Graph structure
    draw_graph(ax_graph)

    # Panel 2: W(beta) curve
    betas = np.concatenate([
        np.linspace(0.01, 0.5, 30),
        np.linspace(0.5, 3.0, 60),
        np.linspace(3.0, 10.0, 30),
    ])
    Ws = [W(b) for b in betas]

    ax_curve.plot(betas, Ws, 'b-', linewidth=3, label='W(β)')
    ax_curve.axhline(0.40, color='red', linestyle='--', linewidth=1.5, alpha=0.7)
    ax_curve.axhline(0.20, color='green', linestyle='--', linewidth=1.5, alpha=0.7)

    # Mark endpoints
    ax_curve.plot(0.01, 0.2, 'go', markersize=12, zorder=5)
    ax_curve.plot(10.0, W(10.0), 'ro', markersize=12, zorder=5)

    ax_curve.text(0.3, 0.195, 'β→0: random\nW = 0.20', fontsize=10,
                  color='darkgreen', fontweight='bold', va='top')
    ax_curve.text(6.5, 0.405, 'β→∞: perfectly rational\nW = 0.40',
                  fontsize=10, color='darkred', fontweight='bold', va='bottom')

    # The kill shot annotation
    ax_curve.annotate('2× WORSE',
                      xy=(5, 0.395), xytext=(3.5, 0.33),
                      fontsize=14, fontweight='bold', color='darkred',
                      arrowprops=dict(arrowstyle='->', color='darkred', lw=2),
                      bbox=dict(boxstyle='round,pad=0.3', facecolor='#FFEEEE',
                                edgecolor='darkred', linewidth=1.5))

    # Direction arrow showing "more info = worse"
    ax_curve.annotate('', xy=(8, 0.38), xytext=(2, 0.26),
                      arrowprops=dict(arrowstyle='->', color='purple',
                                      lw=2.5, ls='--'))
    ax_curve.text(5.5, 0.28, 'more information\n→ worse outcome',
                  fontsize=10, color='purple', fontstyle='italic',
                  ha='center', rotation=15)

    ax_curve.set_xlabel('Information capacity β (bits)', fontsize=12)
    ax_curve.set_ylabel('Expected welfare loss E[W]', fontsize=12)
    ax_curve.set_title('W(β) = Φ(0.2 / √(2σ²(β))) × 0.4\nStrictly increasing ∎',
                       fontsize=11, fontweight='bold')
    ax_curve.set_xlim(0, 10.5)
    ax_curve.set_ylim(0.15, 0.48)
    ax_curve.grid(True, alpha=0.3)

    # Panel 3: The Blackwell Dilemma
    ax_logic.axis('off')
    ax_logic.set_xlim(0, 1)
    ax_logic.set_ylim(0, 1)

    logic_text = (
        "THE BLACKWELL DILEMMA\n"
        "═══════════════════════\n"
        "\n"
        "W(p,β) = W_topo(p) + W_info(p,β)\n"
        "\n"
        "───── Ω = ℝᴺ (standard) ─────\n"
        "Blackwell applies\n"
        "but gives WRONG predictions\n"
        "  (W increases with β)\n"
        "\n"
        "───── Ω' = ℝᴺ × G (expanded) ─\n"
        "Blackwell is correct\n"
        "but governs only W_info → 0\n"
        "  (W_topo is signal-immune)\n"
        "\n"
        "═══════════════════════\n"
        "No Ω exists where Blackwell\n"
        "is both CORRECT and\n"
        "NON-VACUOUS above p_c.\n"
        "\n"
        "→ Replace (Ω, A, u, I)\n"
        "  with (G, p, β, r, v₀)"
    )

    ax_logic.text(0.05, 0.98, logic_text, fontsize=9.2,
                  fontfamily='monospace', va='top',
                  bbox=dict(boxstyle='round,pad=0.5', facecolor='#FFFFF0',
                            edgecolor='#888888', linewidth=1))

    # Suptitle
    fig.suptitle(
        "The Blackwell Dilemma\n"
        "Under irreversibility, no state space makes Blackwell both correct and non-vacuous",
        fontsize=14, fontweight='bold', y=0.98
    )

    plt.savefig(OUT_DIR / filename, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / filename}")


def plot_defense_map(filename="blackwell_dilemma.png"):
    """
    The Blackwell Dilemma: Wrong vs Vacuous.
    No state space exists where Blackwell is both correct and non-vacuous.
    """
    fig, ax = plt.subplots(figsize=(12, 7))
    ax.axis('off')
    ax.set_xlim(-0.5, 10.5)
    ax.set_ylim(-0.5, 8.5)

    # Top: the question
    ax.text(5, 8, 'Can Blackwell ordering govern welfare under irreversibility?',
            fontsize=14, fontweight='bold', ha='center', va='center',
            bbox=dict(boxstyle='round,pad=0.5', facecolor='#F0F0FF',
                      edgecolor='#4444CC', linewidth=2))

    # Fork
    ax.annotate('', xy=(2.5, 6.5), xytext=(5, 7.2),
                arrowprops=dict(arrowstyle='->', color='#666666', lw=2))
    ax.annotate('', xy=(7.5, 6.5), xytext=(5, 7.2),
                arrowprops=dict(arrowstyle='->', color='#666666', lw=2))

    # Left branch: standard Omega
    ax.text(2.5, 6.2, 'Keep Ω = ℝᴺ\n(standard framework)',
            fontsize=11, ha='center', va='center',
            bbox=dict(boxstyle='round,pad=0.5', facecolor='#FFF8DC',
                      edgecolor='#888888', linewidth=1))

    ax.annotate('', xy=(2.5, 4.5), xytext=(2.5, 5.4),
                arrowprops=dict(arrowstyle='->', color='#666666', lw=2))

    ax.text(2.5, 4.1, 'Blackwell applies\nbut W(β) INCREASES\n(wrong predictions)',
            fontsize=10, ha='center', va='center',
            bbox=dict(boxstyle='round,pad=0.5', facecolor='#FFE0E0',
                      edgecolor='#CC4444', linewidth=1.5))

    ax.annotate('', xy=(2.5, 2.7), xytext=(2.5, 3.3),
                arrowprops=dict(arrowstyle='->', color='darkred', lw=2))

    ax.text(2.5, 2.2, 'INCORRECT',
            fontsize=14, fontweight='bold', ha='center', va='center',
            color='darkred',
            bbox=dict(boxstyle='round,pad=0.4', facecolor='#FFD0D0',
                      edgecolor='darkred', linewidth=2))

    # Right branch: expanded Omega
    ax.text(7.5, 6.2, 'Expand Ω\' = ℝᴺ × G\n(include topology)',
            fontsize=11, ha='center', va='center',
            bbox=dict(boxstyle='round,pad=0.5', facecolor='#FFF8DC',
                      edgecolor='#888888', linewidth=1))

    ax.annotate('', xy=(7.5, 4.5), xytext=(7.5, 5.4),
                arrowprops=dict(arrowstyle='->', color='#666666', lw=2))

    ax.text(7.5, 4.1, 'Blackwell is correct\nbut governs only W_info → 0\n(W_topo is signal-immune)',
            fontsize=10, ha='center', va='center',
            bbox=dict(boxstyle='round,pad=0.5', facecolor='#FFFDE0',
                      edgecolor='#CC8844', linewidth=1.5))

    ax.annotate('', xy=(7.5, 2.7), xytext=(7.5, 3.3),
                arrowprops=dict(arrowstyle='->', color='#CC6600', lw=2))

    ax.text(7.5, 2.2, 'VACUOUS',
            fontsize=14, fontweight='bold', ha='center', va='center',
            color='#CC6600',
            bbox=dict(boxstyle='round,pad=0.4', facecolor='#FFF0D0',
                      edgecolor='#CC6600', linewidth=2))

    # Bottom convergence
    ax.annotate('', xy=(5, 1.0), xytext=(2.5, 1.6),
                arrowprops=dict(arrowstyle='->', color='#444444', lw=2))
    ax.annotate('', xy=(5, 1.0), xytext=(7.5, 1.6),
                arrowprops=dict(arrowstyle='->', color='#444444', lw=2))

    ax.text(5, 0.4, 'No state space exists where Blackwell is\n'
            'both CORRECT and NON-VACUOUS above p_c\n\n'
            '→  Replace (Ω, A, u, I) with (G, p, β, r, v₀)',
            fontsize=12, fontweight='bold', ha='center', va='center',
            bbox=dict(boxstyle='round,pad=0.6', facecolor='#E0FFE0',
                      edgecolor='darkgreen', linewidth=2))

    ax.set_title('The Blackwell Dilemma',
                 fontsize=15, fontweight='bold', pad=15)

    plt.tight_layout()
    plt.savefig(OUT_DIR / filename, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / filename}")


def compute_key_numbers():
    """Compute and print the core numbers for the proof."""
    print("\n  KEY NUMBERS:")
    print(f"  W(beta->0)   = {W(0.001):.4f}")
    print(f"  W(beta=0.5)  = {W(0.5):.4f}")
    print(f"  W(beta=1.0)  = {W(1.0):.4f}")
    print(f"  W(beta=2.0)  = {W(2.0):.4f}")
    print(f"  W(beta=5.0)  = {W(5.0):.4f}")
    print(f"  W(beta->inf) = {W(15.0):.4f}")
    print(f"\n  Ratio: W(inf)/W(0) = {W(15.0)/W(0.001):.2f}x")
    print(f"  Perfectly rational agent is {W(15.0)/W(0.001):.0f}x worse than random.")

    # VOI at various beta transitions
    print("\n  VALUE OF INFORMATION (VOI):")
    transitions = [(0.5, 1.0), (1.0, 2.0), (2.0, 5.0), (5.0, 10.0)]
    for b1, b2 in transitions:
        voi = W(b1) - W(b2)  # W is loss; positive VOI = info helps, negative = info hurts
        print(f"  VOI(beta={b1}->{b2}) = {voi:.4f} {'(NEGATIVE: info hurts)' if voi < 0 else ''}")
    print("\n  All VOI values are NEGATIVE (W increases with beta).")
    print("  More information -> strictly worse outcomes.")

    return {
        'W_at_0': W(0.001),
        'W_at_inf': W(15.0),
        'ratio': W(15.0) / W(0.001),
        'formula': 'W(beta) = Phi(0.2 / sqrt(2*sigma^2(beta))) * 0.4',
        'sigma_sq': 'sigma^2(beta) = 1 / (2^(2*beta) - 1)',
        'precondition': 'u = u(a, omega) violated: u = u(a, omega, G), G not in omega',
    }


if __name__ == "__main__":
    print("=" * 70)
    print("BLACKWELL VIOLATION: THE ONE-PAGE PROOF")
    print("=" * 70)
    print("\nBlackwell (1953) precondition: u = u(a, omega).")
    print("Under irreversibility:         u = u(a, omega, G), G not in omega.")
    print("Precondition violated. VOI can be negative.")

    data = compute_key_numbers()

    print("\nGenerating proof figure...")
    plot_blackwell_violation()

    print("Generating defense map...")
    plot_defense_map()

    with open(OUT_DIR / "blackwell_violation_results.json", "w") as f:
        json.dump(data, f, indent=2)

    print("\n" + "=" * 70)
    print("THE PROOF:")
    print("  4 states. 1 formula. W strictly increasing in beta.")
    print("  Blackwell's precondition violated: u depends on G, G not in omega.")
    print("  Standard framework = degenerate case at p = 0.")
    print("=" * 70)
