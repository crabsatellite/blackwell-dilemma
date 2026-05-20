#!/usr/bin/env python3
"""
Generate the phase diagram figure for the Blackwell Dilemma paper.

Visualizes the Two-Regime Structure (Proposition prop:two-regime-five-state)
on the 5-state instance: greedy-agent welfare loss L(beta, p) as p varies
across the two regimes delineated by p_sharp = 4/9.

Output: PDF at paper/figures/two_regime_phase_diagram.pdf
"""

import math
import os
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

from scipy.stats import norm  # type: ignore  # noqa

# If scipy not available, fallback below.

SCRIPT_DIR = Path(__file__).resolve().parent
PAPER_DIR = SCRIPT_DIR.parent / "paper"
FIG_DIR = PAPER_DIR / "figures"
FIG_DIR.mkdir(parents=True, exist_ok=True)


def norm_cdf(x):
    """Standard normal CDF via erf."""
    return 0.5 * (1.0 + math.erf(x / math.sqrt(2.0)))


def sigma2(beta):
    if beta <= 0:
        return float("inf")
    if beta > 30:
        return 2.0 ** (-2 * beta)
    return 1.0 / (2.0 ** (2 * beta) - 1.0)


def loss_greedy(beta, p):
    """Greedy-agent welfare loss L(beta, p) on the 5-state instance (alpha = 1)."""
    s2 = sigma2(beta)
    den = math.sqrt(2.0 * s2)
    P_trap = norm_cdf(0.2 / den)
    Phi_B = norm_cdf(0.9 / den)
    return P_trap * 0.4 + (1.0 - P_trap) * 0.9 * (1.0 - (1.0 - p) * Phi_B)


def loss_kappa_agent(beta, kappa, p):
    """
    5-state kappa-agent welfare loss.

    At S, the kappa-agent uses a noisy topology signal about the B-G edge
    to form a posterior on the bridge continuation value:
      V_hat(B | omega_kappa) = 0.4 + 0.6 * Pr(open | omega_kappa)
    and picks B over A iff V_hat(B) > 0.6, i.e., Pr(open | omega_kappa) > 1/3.

    For alpha = 1, at S the agent compares signal-based reward estimates
    (alpha*E[r(u)|s] uses s directly under flat prior) for A vs V_hat(B):
      picks A iff alpha * s_A > alpha * V_hat(B)   (here alpha=1)
    With reward signal s_A ~ N(r_A, sigma^2), the decision at S integrates
    over both the reward signal and the topology signal.

    For simplicity at alpha = 1 we use the kappa-agent's routing rule:
      pick B iff Pr(open | omega_kappa) > 1/3 (majority-vote on topology)
    which is the paper's exact specification for the prior-dominated regime.

    Within-B subproblem: agent faces reward-signal-driven choice between
    G and D (when B-G open, probability 1-p).
    """
    if kappa <= 0:
        return loss_greedy(beta, p)

    # Topology noise variance at distance d=1
    sigma_topo2 = 1.0 / (2.0 ** (2 * kappa) - 1.0) if kappa < 30 else 1e-30

    # Bayesian-update probability threshold.
    # Bernoulli prior Pr(open) = 1-p. Gaussian signal omega_hat = 1[open] + eta,
    # eta ~ N(0, sigma_topo2). Posterior Pr(open | omega_hat) > 1/3 iff
    # omega_hat > threshold T(p, kappa) = 1/2 + sigma_topo2 * log(p / (2(1-p))).
    # For fixed true status (open) with omega_hat ~ N(1, sigma_topo2):
    #   P(correctly select B) = P(omega_hat > T | open)
    #                         = Phi((1 - T) / sqrt(sigma_topo2))
    # For true status (blocked) with omega_hat ~ N(0, sigma_topo2):
    #   P(incorrectly select B) = P(omega_hat > T | blocked)
    #                           = Phi((0 - T) / sqrt(sigma_topo2))

    if p >= 1.0:
        return 0.6  # bridge impossible; agent still possibly picks A with probability 1
    if 2.0 * (1.0 - p) <= p:
        # p >= 2/3: prior favors blocked. Threshold formula.
        if p == 2.0 / 3.0:
            T = 0.5
        else:
            log_arg = p / (2.0 * (1.0 - p))
            T = 0.5 + sigma_topo2 * math.log(log_arg)
    else:
        # p < 2/3: prior favors open, Pr(open) > 1/3 even at kappa = 0+.
        # In this regime the agent picks B under any kappa > 0 (posterior
        # dominated by prior when signal uninformative; confirmed by signal
        # when informative). Set T very negative so P(select B) ~ 1.
        T = -10.0

    # Probabilities of selecting B at S (conditional on true status)
    if sigma_topo2 > 0:
        sqrt_s = math.sqrt(sigma_topo2)
        p_B_given_open = norm_cdf((1.0 - T) / sqrt_s)
        p_B_given_blocked = norm_cdf((0.0 - T) / sqrt_s)
    else:
        p_B_given_open = 1.0 if T < 1.0 else 0.0
        p_B_given_blocked = 1.0 if T < 0.0 else 0.0

    # Within-B, agent uses reward signals to choose G vs D (when open) or
    # has no real choice (when blocked, B is terminal dead-end)
    s2 = sigma2(beta)
    den = math.sqrt(2.0 * s2)
    p_goal_given_B_open = norm_cdf(0.9 / den)

    # Welfare loss decomposition:
    # Event tree:
    #   True open (prob 1-p):
    #     Agent picks B (prob p_B_given_open): reaches G w.p. p_goal, loss = 0;
    #                                          reaches D w.p. 1-p_goal, loss = 0.9
    #     Agent picks A (prob 1-p_B_given_open): terminal A, loss = 0.4
    #   True blocked (prob p):
    #     Agent picks B (prob p_B_given_blocked): B is dead-end, loss = 1 - r(B) = 0.6
    #     Agent picks A (prob 1-p_B_given_blocked): terminal A, loss = 0.4
    loss_open = (
        p_B_given_open * (p_goal_given_B_open * 0.0 + (1.0 - p_goal_given_B_open) * 0.9)
        + (1.0 - p_B_given_open) * 0.4
    )
    loss_blocked = p_B_given_blocked * 0.6 + (1.0 - p_B_given_blocked) * 0.4

    return (1.0 - p) * loss_open + p * loss_blocked


def panel_two_regime(ax, p, label, color, regime):
    """Draw L(beta) curve for a specific p, on a given axis."""
    betas = np.linspace(0.01, 5.0, 301)
    losses = [loss_greedy(b, p) for b in betas]
    loss_inf = loss_greedy(50.0, p)
    ax.plot(betas, losses, color=color, linewidth=1.8, label=f"$p={p}$ ({label})")
    ax.axhline(y=loss_inf, color=color, linestyle="--", linewidth=0.8, alpha=0.6)
    ax.annotate(
        f"$L(\\infty)={loss_inf:.3f}$",
        xy=(4.9, loss_inf),
        xytext=(4.9, loss_inf + 0.015),
        fontsize=7,
        color=color,
        ha="right",
    )
    return regime


def figure_two_regime():
    """
    Figure 1: Two-regime welfare-loss structure on the 5-state instance.

    Panel (a): L(beta) curves for p in each regime, showing regime shift
               from interior optimum (Regime I, p < 4/9) to monotone
               (Regime II, p >= 4/9).
    Panel (b): overshoot = L(infty, p) - min_beta L(beta, p) as function of p,
               showing it vanishes at p_sharp = 4/9, the single threshold
               separating Regime I (reversal) from Regime II (monotone).
    """
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(10, 4))

    # Panel (a): L(beta) for representative p values across the two regimes
    ps = [(0.20, "Regime I: reversal", "#1f77b4", "I"),
          (0.40, "Regime I near boundary", "#4a90c2", "I"),
          (0.60, "Regime II: monotone", "#ff7f0e", "II")]
    for p, label, color, regime in ps:
        panel_two_regime(ax1, p, label, color, regime)
    ax1.set_xlabel(r"Signal precision $\beta$ (bits)", fontsize=10)
    ax1.set_ylabel(r"Welfare loss $L(\beta, p)$", fontsize=10)
    ax1.set_title(r"(a) Greedy $L(\beta, p)$ across the two regimes", fontsize=11)
    ax1.set_xlim(0, 5)
    ax1.set_ylim(0.25, 0.65)
    ax1.legend(loc="upper left", fontsize=8, framealpha=0.9)
    ax1.grid(True, alpha=0.25, linewidth=0.4)

    # Panel (b): Overshoot as a function of p
    p_grid = np.linspace(0.001, 0.95, 200)
    overshoots = []
    betas_fine = np.linspace(0.01, 10.0, 401)
    for p in p_grid:
        L_inf = loss_greedy(50.0, p)
        L_min = min(loss_greedy(b, p) for b in betas_fine)
        overshoots.append(L_inf - L_min)
    overshoots = np.array(overshoots)

    ax2.plot(p_grid, overshoots, color="#1f77b4", linewidth=1.8)
    ax2.fill_between(p_grid, 0, overshoots, alpha=0.15, color="#1f77b4")

    # Single regime boundary p_sharp = 4/9
    p_sharp = 4.0 / 9.0
    ax2.axvline(x=p_sharp, color="#d62728", linestyle="--", linewidth=1.0, alpha=0.85)
    ax2.text(p_sharp - 0.005, 0.105, r"$p^\sharp = 4/9$", color="#d62728",
             ha="right", fontsize=9, rotation=90, va="bottom")

    ax2.set_xlabel(r"Blocking probability $p$", fontsize=10)
    ax2.set_ylabel(r"Overshoot $L(\infty, p) - \min_\beta L(\beta, p)$", fontsize=10)
    ax2.set_title(r"(b) Greedy-reversal overshoot vanishes at $p^\sharp$", fontsize=11)
    ax2.set_xlim(0, 0.95)
    ax2.set_ylim(-0.005, 0.135)
    ax2.grid(True, alpha=0.25, linewidth=0.4)

    # Regime labels at top of panel (b)
    ax2.text((0 + p_sharp) / 2, 0.125, "Regime I",
             ha="center", fontsize=8, color="#1f77b4",
             bbox=dict(boxstyle="round,pad=0.15", facecolor="#e8f1fa", edgecolor="none"))
    ax2.text((p_sharp + 0.95) / 2, 0.125, "Regime II",
             ha="center", fontsize=8, color="#ff7f0e",
             bbox=dict(boxstyle="round,pad=0.15", facecolor="#fdeedb", edgecolor="none"))

    plt.tight_layout()
    out_path = FIG_DIR / "two_regime_phase_diagram.pdf"
    fig.savefig(out_path, bbox_inches="tight", dpi=150)
    plt.close(fig)
    print(f"Wrote {out_path}")


def figure_beta_kappa_heatmap():
    """
    Figure 2: Welfare heatmap over (beta, kappa) at a representative p in
    Regime II (p = 0.8 > p^sharp = 4/9), where kappa* = log2(2*log(2)+1)/2 ~ 0.63.

    Shows sharp transition in welfare as kappa crosses kappa*(p).
    """
    fig, ax = plt.subplots(figsize=(6, 4.5))

    betas = np.linspace(0.05, 4.0, 80)
    kappas = np.linspace(0.0, 2.5, 80)
    p = 0.8

    W = np.zeros((len(kappas), len(betas)))
    for i, k in enumerate(kappas):
        for j, b in enumerate(betas):
            W[i, j] = -loss_kappa_agent(b, k, p)  # welfare = -loss

    im = ax.imshow(
        W,
        origin="lower",
        aspect="auto",
        extent=[betas[0], betas[-1], kappas[0], kappas[-1]],
        cmap="RdYlGn",
    )

    # Overlay kappa*(p) line at p = 0.8 (from paper's closed-form):
    # kappa*(0.8) = 0.5 * log2(2 * log(0.8 / 0.4) + 1)
    #             = 0.5 * log2(2 * log(2) + 1)
    #             ~ 0.627
    kstar_08 = 0.5 * math.log2(2 * math.log(2) + 1)
    ax.axhline(y=kstar_08, color="white", linestyle="--", linewidth=1.5)
    ax.text(3.5, kstar_08 + 0.05, r"$\kappa^*(p=0.8) \approx 0.63$",
            color="white", fontsize=9, ha="right", fontweight="bold")

    cbar = fig.colorbar(im, ax=ax)
    cbar.set_label(r"Welfare $W = -L$ (monetary reward)", fontsize=9)

    ax.set_xlabel(r"Signal precision $\beta$ (bits)", fontsize=10)
    ax.set_ylabel(r"Cognitive depth $\kappa$ (bits)", fontsize=10)
    ax.set_title(r"Welfare $W(\beta, \kappa)$ at $p=0.8$ (Regime II)", fontsize=11)

    plt.tight_layout()
    out_path = FIG_DIR / "welfare_beta_kappa_heatmap.pdf"
    fig.savefig(out_path, bbox_inches="tight", dpi=150)
    plt.close(fig)
    print(f"Wrote {out_path}")


def main():
    print("Generating phase-diagram figures for Blackwell Dilemma paper.")
    print("Output directory:", FIG_DIR)
    print()
    figure_two_regime()
    figure_beta_kappa_heatmap()
    print()
    print("Done.")


if __name__ == "__main__":
    main()
