"""
Upgrade Experiments: From Lower Bound to Structural Identity
=============================================================
Three experiments that elevate the result from "tool" to "language":

A. Decomposition: W = W_topo + W_info, verify W_topo IS the percolation observable
B. Policy gradients: ∂W/∂β ≈ 0 vs ∂W/∂p >> 0 in supercritical regime
C. Minimal 2-state counterexample: Sims predicts W→0, our model predicts W = p·Δr
"""

import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from pathlib import Path
import time
import sys

sys.path.insert(0, str(Path(__file__).parent))
from phase_transition_sim import setup_graph, run_agent, compute_reachable_set, get_accessible_neighbors, noisy_signal, OUT_DIR


# ═══════════════════════════════════════════════════════════════
# EXPERIMENT A: Welfare Decomposition W = W_topo + W_info
# ═══════════════════════════════════════════════════════════════


def experiment_decomposition(n=40, p_values=None, beta_values=None, M=400, seed=500):
    """
    For each (p, β): compute W, W_topo, W_info separately.
    W_topo = max_V r - max_{R(v0)} r (independent of β)
    W_info = max_{R(v0)} r - r(v_T) (depends on β)
    """
    if p_values is None:
        p_values = np.linspace(0, 0.85, 25)
    if beta_values is None:
        beta_values = [0.5, 1.0, 2.0, 5.0, 20.0]  # 20.0 ≈ ∞

    T = n * n * 2
    rng = np.random.default_rng(seed)

    results = {
        'p_values': p_values.tolist(),
        'beta_values': beta_values,
        'n': n, 'M': M,
    }

    for beta in beta_values:
        w_topo_means = []
        w_info_means = []
        w_total_means = []

        for p in p_values:
            w_topos = []
            w_infos = []

            for _ in range(M):
                rewards, adj = setup_graph(n, p, rng)
                max_r = rewards.max()
                N = n * n
                v0 = rng.integers(N)

                # W_topo: max_V r - max_{R(v0)} r
                reachable = compute_reachable_set(adj, v0)
                max_reachable_r = max(rewards[v] for v in reachable)
                w_topo = max_r - max_reachable_r

                # Run agent from same start
                v = v0
                for _ in range(T):
                    neighbors = get_accessible_neighbors(adj, v)
                    if not neighbors:
                        break
                    signals = [(u, noisy_signal(rewards[u], beta, rng)) for u in neighbors]
                    v = max(signals, key=lambda x: x[1])[0]

                w_total = max_r - rewards[v]
                w_info = w_total - w_topo  # = max_R r - r(v_T)

                w_topos.append(w_topo)
                w_infos.append(max(0, w_info))  # clamp numerical noise

            w_topo_means.append(float(np.mean(w_topos)))
            w_info_means.append(float(np.mean(w_infos)))
            w_total_means.append(float(np.mean(w_topos)) + float(np.mean(w_infos)))

        results[f'beta_{beta}_w_topo'] = w_topo_means
        results[f'beta_{beta}_w_info'] = w_info_means
        results[f'beta_{beta}_w_total'] = w_total_means

        print(f"  β={beta}: done")

    return results


def plot_decomposition(results, filename="decomposition.png"):
    """Show W = W_topo + W_info for multiple β values."""
    p = results['p_values']
    betas = results['beta_values']

    fig, axes = plt.subplots(1, 3, figsize=(18, 5.5))

    colors = plt.cm.viridis(np.linspace(0.2, 0.9, len(betas)))

    # Panel 1: W_topo (should be IDENTICAL across all β)
    ax = axes[0]
    for beta, color in zip(betas, colors):
        ax.plot(p, results[f'beta_{beta}_w_topo'], color=color, marker='o',
                markersize=2, linewidth=1.5, label=f'β={beta}')
    ax.axvline(0.5, color='red', linestyle='--', alpha=0.5, label='p_c = 0.5')
    ax.set_xlabel('Irreversibility p', fontsize=12)
    ax.set_ylabel('W_topo', fontsize=12)
    ax.set_title('Topological Loss W_topo\n(IDENTICAL across all β — depends only on p)', fontsize=11)
    ax.legend(fontsize=8)
    ax.grid(True, alpha=0.3)

    # Panel 2: W_info (should decrease with β, smooth in p)
    ax = axes[1]
    for beta, color in zip(betas, colors):
        ax.plot(p, results[f'beta_{beta}_w_info'], color=color, marker='o',
                markersize=2, linewidth=1.5, label=f'β={beta}')
    ax.set_xlabel('Irreversibility p', fontsize=12)
    ax.set_ylabel('W_info', fontsize=12)
    ax.set_title('Informational Loss W_info\n(smooth, decreasing in β — the Sims/Gabaix world)', fontsize=11)
    ax.legend(fontsize=8)
    ax.grid(True, alpha=0.3)

    # Panel 3: Total W = W_topo + W_info
    ax = axes[2]
    for beta, color in zip(betas, colors):
        ax.plot(p, results[f'beta_{beta}_w_total'], color=color, marker='o',
                markersize=2, linewidth=1.5, label=f'β={beta}')
    ax.axvline(0.5, color='red', linestyle='--', alpha=0.5)
    ax.set_xlabel('Irreversibility p', fontsize=12)
    ax.set_ylabel('W = W_topo + W_info', fontsize=12)
    ax.set_title('Total Welfare Loss\n(phase transition from W_topo, smooth part from W_info)', fontsize=11)
    ax.legend(fontsize=8)
    ax.grid(True, alpha=0.3)

    plt.suptitle('WELFARE DECOMPOSITION: W = W_topo + W_info\n'
                 'W_topo = percolation observable (non-analytic at p_c) | W_info = information loss (smooth)',
                 fontsize=13, fontweight='bold')
    plt.tight_layout()
    plt.savefig(OUT_DIR / filename, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / filename}")


# ═══════════════════════════════════════════════════════════════
# EXPERIMENT B: Policy Gradient Comparison
# ═══════════════════════════════════════════════════════════════

def experiment_policy_gradients(n=40, M=400, seed=600, B=2000):
    """
    Compute ∂W/∂β and ∂W/∂p numerically at a grid of (p, β) points.
    Show that ∂W/∂β → 0 while ∂W/∂p >> 0 in supercritical regime.
    Bootstrap standard errors on gradients (B resamples).
    """
    T = n * n * 2
    rng_base = np.random.default_rng(seed)

    p_points = [0.30, 0.45, 0.55, 0.70]  # sub, near, near, super
    beta_points = [1.0, 2.0, 3.0, 5.0, 10.0]

    dp = 0.03
    dbeta = 0.3

    results = {'p_points': p_points, 'beta_points': beta_points,
               'dW_dp': {}, 'dW_dbeta': {}, 'W_values': {},
               'se_dW_dp': {}, 'se_dW_dbeta': {}}

    def losses_array(n, p, beta, M, seed):
        """Return array of per-trial losses."""
        rng = np.random.default_rng(seed)
        losses = np.empty(M)
        for i in range(M):
            rewards, adj = setup_graph(n, p, rng)
            max_r = rewards.max()
            final_r, _ = run_agent(rewards, adj, beta, T, rng)
            losses[i] = max_r - final_r
        return losses

    for p in p_points:
        for beta in beta_points:
            s = int(seed + p * 1000 + beta * 100)

            L = losses_array(n, p, beta, M, s)
            L_pp = losses_array(n, p + dp, beta, M, s)
            L_pm = losses_array(n, p - dp, beta, M, s)
            L_bp = losses_array(n, p, beta + dbeta, M, s)
            L_bm = losses_array(n, p, max(0.1, beta - dbeta), M, s)

            W = L.mean()
            dw_dp = (L_pp.mean() - L_pm.mean()) / (2 * dp)
            dw_db = (L_bp.mean() - L_bm.mean()) / (2 * dbeta)

            # Bootstrap SEs on gradients
            boot_rng = np.random.default_rng(s + 999999)
            boot_dp = np.empty(B)
            boot_db = np.empty(B)
            for b in range(B):
                idx_pp = boot_rng.integers(0, M, size=M)
                idx_pm = boot_rng.integers(0, M, size=M)
                idx_bp = boot_rng.integers(0, M, size=M)
                idx_bm = boot_rng.integers(0, M, size=M)
                boot_dp[b] = (L_pp[idx_pp].mean() - L_pm[idx_pm].mean()) / (2 * dp)
                boot_db[b] = (L_bp[idx_bp].mean() - L_bm[idx_bm].mean()) / (2 * dbeta)

            se_dp = boot_dp.std()
            se_db = boot_db.std()

            results['W_values'][(p, beta)] = W
            results['dW_dp'][(p, beta)] = dw_dp
            results['dW_dbeta'][(p, beta)] = dw_db
            results['se_dW_dp'][(p, beta)] = se_dp
            results['se_dW_dbeta'][(p, beta)] = se_db

            print(f"  p={p:.2f}, b={beta:.1f}: W={W:.4f}, "
                  f"|dW/dp|={abs(dw_dp):.4f}±{se_dp:.4f}, "
                  f"|dW/db|={abs(dw_db):.4f}±{se_db:.4f}, "
                  f"ratio={abs(dw_dp/(dw_db+1e-10)):.1f}x")

    return results


def plot_policy_gradients(results, filename="policy_gradients.png"):
    """Show ∂W/∂p vs ∂W/∂β across the phase boundary."""
    p_points = results['p_points']
    beta_points = results['beta_points']

    fig, axes = plt.subplots(1, 3, figsize=(18, 5.5))

    # Panel 1: ∂W/∂p at different (p, β)
    ax = axes[0]
    for p in p_points:
        vals = [results['dW_dp'].get((p, b), 0) for b in beta_points]
        marker = 's' if p > 0.5 else 'o'
        ax.plot(beta_points, vals, marker=marker, markersize=5, linewidth=2,
                label=f'p={p:.2f} {"(super)" if p > 0.5 else "(sub)"}')
    ax.set_xlabel('Cognitive Budget β', fontsize=12)
    ax.set_ylabel('∂W/∂p (structural policy effect)', fontsize=12)
    ax.set_title('Structural Policy Gradient ∂W/∂p\n(reducing irreversibility)', fontsize=11)
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)

    # Panel 2: ∂W/∂β at different (p, β)
    ax = axes[1]
    for p in p_points:
        vals = [results['dW_dbeta'].get((p, b), 0) for b in beta_points]
        marker = 's' if p > 0.5 else 'o'
        ax.plot(beta_points, vals, marker=marker, markersize=5, linewidth=2,
                label=f'p={p:.2f}')
    ax.set_xlabel('Cognitive Budget β', fontsize=12)
    ax.set_ylabel('∂W/∂β (information policy effect)', fontsize=12)
    ax.set_title('Information Policy Gradient ∂W/∂β\n(financial literacy, disclosure)', fontsize=11)
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)
    ax.axhline(0, color='gray', linestyle=':', alpha=0.5)

    # Panel 3: Ratio |∂W/∂p| / |∂W/∂β| — policy leverage
    ax = axes[2]
    for p in p_points:
        ratios = []
        for b in beta_points:
            dp_val = abs(results['dW_dp'].get((p, b), 0))
            db_val = abs(results['dW_dbeta'].get((p, b), 1e-10))
            ratios.append(dp_val / max(db_val, 1e-10))
        marker = 's' if p > 0.5 else 'o'
        ax.plot(beta_points, ratios, marker=marker, markersize=5, linewidth=2,
                label=f'p={p:.2f}')
    ax.set_xlabel('Cognitive Budget β', fontsize=12)
    ax.set_ylabel('|∂W/∂p| / |∂W/∂β|', fontsize=12)
    ax.set_title('Policy Leverage Ratio\n(>> 1 means structural policy dominates information policy)', fontsize=11)
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)
    ax.set_yscale('log')
    ax.axhline(1, color='red', linestyle='--', alpha=0.5, label='Equal effectiveness')

    plt.suptitle('POLICY INEFFECTIVENESS: Information interventions fail in supercritical regime\n'
                 '∂W/∂β → 0 as β grows, while ∂W/∂p remains large',
                 fontsize=13, fontweight='bold')
    plt.tight_layout()
    plt.savefig(OUT_DIR / filename, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / filename}")


# ═══════════════════════════════════════════════════════════════
# EXPERIMENT C: Minimal 2-State Counterexample
# ═══════════════════════════════════════════════════════════════

def experiment_two_state(M=100000, seed=700):
    """
    The simplest possible counterexample to Sims (2003).
    2 states: A (reward=0), B (reward=1).
    Agent starts at A.
    With probability p, edge A→B is removed.
    Agent has information capacity β.

    Sims predicts: W(β) → 0 as β → ∞ (perfect info → perfect choice)
    Our model: W(p, β→∞) = p (with probability p, B is unreachable)
    """
    rng = np.random.default_rng(seed)

    p_values = np.linspace(0, 1, 50)
    beta_values = [0.5, 1.0, 2.0, 5.0, 100.0]

    results = {'p_values': p_values.tolist(), 'beta_values': beta_values}

    for beta in beta_values:
        losses = []
        for p in p_values:
            total_loss = 0
            for _ in range(M):
                # Edge A→B exists with probability 1−p
                can_reach_B = rng.random() >= p

                if can_reach_B:
                    # Agent observes B's reward with noise
                    signal_B = noisy_signal(1.0, beta, rng)
                    signal_stay = noisy_signal(0.0, beta, rng)
                    if signal_B > signal_stay:
                        total_loss += 0  # correctly moved to B
                    else:
                        total_loss += 1  # info error: stayed at A
                else:
                    # TRAPPED at A regardless of β
                    total_loss += 1

            losses.append(total_loss / M)

        results[f'beta_{beta}'] = losses
        print(f"  β={beta}: done")

    # Sims prediction: W = P(wrong choice | β) = P(signal_A > signal_B | β)
    # = Φ(−1/σ) where σ² = 1/(2^{2β}−1), so Φ(−√(2^{2β}−1))
    from scipy.stats import norm
    sims_predictions = {}
    for beta in beta_values:
        if beta > 20:
            sims_predictions[beta] = [0.0] * len(p_values)
        else:
            sigma2 = 1.0 / (2 ** (2 * beta) - 1)
            # P(noise_A - noise_B > 1) = P(N(0, 2σ²) > 1) = Φ(−1/√(2σ²))
            p_wrong = norm.cdf(-1.0 / np.sqrt(2 * sigma2))
            sims_predictions[beta] = [float(p_wrong)] * len(p_values)  # constant in p!

    results['sims_predictions'] = sims_predictions

    return results


def plot_two_state(results, filename="two_state_counterexample.png"):
    """The pedagogical Figure 1: Sims vs reality in the simplest possible setting."""
    p = results['p_values']
    betas = results['beta_values']

    fig, axes = plt.subplots(1, 3, figsize=(18, 5.5))

    colors = plt.cm.plasma(np.linspace(0.1, 0.9, len(betas)))

    # Panel 1: Our model — W(p, β)
    ax = axes[0]
    for beta, color in zip(betas, colors):
        ax.plot(p, results[f'beta_{beta}'], color=color, linewidth=2,
                label=f'β={beta}')
    ax.plot(p, p, 'k--', linewidth=1.5, alpha=0.5, label='W = p (β→∞ limit)')
    ax.set_xlabel('Irreversibility p', fontsize=12)
    ax.set_ylabel('Welfare Loss W', fontsize=12)
    ax.set_title('OUR MODEL: W(p, β)\n(W → p as β → ∞)', fontsize=11)
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)

    # Panel 2: Sims prediction — W(β), constant in p
    ax = axes[1]
    for beta, color in zip(betas, colors):
        sims = results['sims_predictions'][beta]
        ax.plot(p, sims, color=color, linewidth=2, linestyle='--',
                label=f'β={beta}: W={sims[0]:.4f}')
    ax.set_xlabel('Irreversibility p', fontsize=12)
    ax.set_ylabel('Welfare Loss W', fontsize=12)
    ax.set_title('SIMS (2003) PREDICTION: W(β)\n(horizontal lines — p is not a parameter!)', fontsize=11)
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)
    ax.set_ylim(-0.05, 1.05)

    # Panel 3: The gap at β=∞
    ax = axes[2]
    our_inf = results[f'beta_{100.0}']
    sims_inf = results['sims_predictions'][100.0]
    ax.fill_between(p, sims_inf, our_inf, alpha=0.3, color='red', label='Irreducible gap')
    ax.plot(p, our_inf, 'r-', linewidth=2, label='Our model (β→∞)')
    ax.plot(p, sims_inf, 'b--', linewidth=2, label='Sims prediction (β→∞)')
    ax.plot(p, p, 'k:', linewidth=1, alpha=0.5, label='W = p (exact)')

    ax.set_xlabel('Irreversibility p', fontsize=12)
    ax.set_ylabel('Welfare Loss W', fontsize=12)
    ax.set_title('THE GAP SIMS CANNOT EXPLAIN\n(red area = topological loss invisible to information theory)', fontsize=11)
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)

    plt.suptitle('MINIMAL COUNTEREXAMPLE: 2 States, 1 Edge\n'
                 'Sims (2003): "more information always helps" → WRONG when actions are irreversible',
                 fontsize=13, fontweight='bold')
    plt.tight_layout()
    plt.savefig(OUT_DIR / filename, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / filename}")


# ═══════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════

if __name__ == "__main__":
    print("=" * 70)
    print("UPGRADE EXPERIMENTS: From Lower Bound to Structural Identity")
    print("=" * 70)

    # Experiment C first (fastest, most important pedagogically)
    print("\n[C] Minimal 2-state counterexample...")
    t0 = time.time()
    results_2state = experiment_two_state(M=100000, seed=700)
    print(f"  Done in {time.time()-t0:.1f}s")
    plot_two_state(results_2state)

    # Experiment A: Decomposition
    print("\n[A] Welfare decomposition W = W_topo + W_info...")
    t0 = time.time()
    results_decomp = experiment_decomposition(n=40, M=400, seed=500)
    print(f"  Done in {time.time()-t0:.1f}s")
    plot_decomposition(results_decomp)

    # Experiment B: Policy gradients
    print("\n[B] Policy gradient comparison dW/dp vs dW/dbeta...")
    t0 = time.time()
    results_policy = experiment_policy_gradients(n=40, M=400, seed=600)
    print(f"  Done in {time.time()-t0:.1f}s")
    plot_policy_gradients(results_policy)

    print("\n" + "=" * 70)
    print("UPGRADE EXPERIMENTS COMPLETE")
    print("=" * 70)
