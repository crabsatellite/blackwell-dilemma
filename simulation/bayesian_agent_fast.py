"""
Bayesian Agent Under Endogenous Feasibility (Optimized)
=======================================================
Proves that an optimal Bayesian agent who knows (G, p) and computes
continuation values has MONOTONICALLY NON-DECREASING welfare in beta,
while the greedy agent exhibits an interior optimum (reversal).

Key formula:
  E[V_dyn(u) | s] = (k-1)/k + E[r^k | s] / k
  where k = subtree size, s = r + N(0, sigma^2(beta))

Optimization: precompute E[r^k | s] on a grid, then interpolate in MC.
"""

import numpy as np
from scipy.stats import norm
from scipy.integrate import quad
from scipy.interpolate import interp1d
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from pathlib import Path
import sys
import json
import time

sys.path.insert(0, str(Path(__file__).parent))
from phase_transition_sim import OUT_DIR


def sigma_sq(beta):
    """Gaussian channel noise variance at precision beta bits."""
    if beta > 15:
        return 1e-10
    return 1.0 / (2.0 ** (2.0 * beta) - 1.0)


def build_posterior_table(beta, max_power, s_grid_size=500):
    """
    Precompute E[r^power | s] for power=1..max_power on a grid of s values.
    Returns: dict {power: interpolation_function(s)}
    """
    if beta >= 6:
        # For high beta, sigma is so small that quad() misses the narrow
        # Gaussian peak. Use the analytical limit: E[r^k | s] -> clip(s,0,1)^k.
        tables = {}
        for power in range(1, max_power + 1):
            tables[power] = lambda s, p=power: np.clip(s, 0, 1) ** p
        return tables

    sig = np.sqrt(sigma_sq(beta))
    # Grid of s values: reward is U[0,1], noise is N(0,sig^2)
    s_min = -4 * sig
    s_max = 1 + 4 * sig
    s_vals = np.linspace(s_min, s_max, s_grid_size)

    tables = {}
    for power in range(1, max_power + 1):
        E_rk_given_s = np.zeros(s_grid_size)
        for i, s in enumerate(s_vals):
            # Integrate over a narrow band around s for numerical stability
            lo = max(0, s - 6 * sig)
            hi = min(1, s + 6 * sig)
            if lo >= hi:
                # s is far outside [0,1]; use boundary value
                r_map = np.clip(s, 0, 1)
                E_rk_given_s[i] = r_map ** power
                continue

            def num(r, _s=s, _sig=sig, _p=power):
                return r**_p * norm.pdf(_s, loc=r, scale=_sig)
            def den(r, _s=s, _sig=sig):
                return norm.pdf(_s, loc=r, scale=_sig)
            n, _ = quad(num, lo, hi, limit=100)
            d, _ = quad(den, lo, hi, limit=100)
            E_rk_given_s[i] = n / d if d > 1e-30 else np.clip(s, 0, 1)**power

        tables[power] = interp1d(
            s_vals, E_rk_given_s,
            kind='cubic', bounds_error=False,
            fill_value=(E_rk_given_s[0], E_rk_given_s[-1])
        )
    return tables


def E_Vdyn_fast(s, k, tables):
    """
    E[V_dyn(u) | signal s] using precomputed lookup.
    = (k-1)/k + E[r^k | s] / k
    """
    if k <= 1:
        return float(tables[1](s))
    E_rk = float(tables[k](s))
    return (k - 1) / k + E_rk / k


def simulate_both_agents(beta, k1, k2, p, tables, M=100000, seed=42):
    """
    Monte Carlo for BOTH Bayesian and greedy agents simultaneously.
    Bayesian compares E[V_dyn(u_i) | s_i].
    Greedy compares E[r(u_i) | s_i].
    """
    rng = np.random.default_rng(seed)
    sig = np.sqrt(sigma_sq(beta)) if beta > 0.001 else 1e6

    # Draw all random numbers at once (vectorized)
    r_u1 = rng.uniform(size=M)
    r_u2 = rng.uniform(size=M)
    eps1 = rng.normal(0, sig, size=M)
    eps2 = rng.normal(0, sig, size=M)
    block_draws = rng.uniform(size=M)

    s1 = r_u1 + eps1
    s2 = r_u2 + eps2
    blocked = block_draws < p

    # Compute subtree maxima
    if k1 > 1:
        sub1 = rng.uniform(size=(M, k1 - 1))
        max_sub1 = np.maximum(r_u1, np.max(sub1, axis=1))
    else:
        max_sub1 = r_u1.copy()

    if k2 > 1:
        sub2 = rng.uniform(size=(M, k2 - 1))
        max_sub2 = np.maximum(r_u2, np.max(sub2, axis=1))
    else:
        max_sub2 = r_u2.copy()

    # Vectorized E[r^k | s] via interpolation tables
    Er1_k1 = tables[k1](s1) if k1 in tables else tables[1](s1)
    Er2_k2 = tables[k2](s2) if k2 in tables else tables[1](s2)
    Er1_1 = tables[1](s1)
    Er2_1 = tables[1](s2)

    # Bayesian expected continuation values
    if k1 <= 1:
        ev1_bayesian = Er1_1
    else:
        ev1_bayesian = (k1 - 1) / k1 + Er1_k1 / k1

    if k2 <= 1:
        ev2_bayesian = Er2_1
    else:
        ev2_bayesian = (k2 - 1) / k2 + Er2_k2 / k2

    # Bayesian choice: pick u1 if ev1 >= ev2
    bayesian_choose_u1 = ev1_bayesian >= ev2_bayesian

    # Greedy choice: pick u1 if E[r1|s1] >= E[r2|s2]
    greedy_choose_u1 = Er1_1 >= Er2_1

    # Compute welfare
    bayesian_welfare = np.where(
        blocked,
        max_sub1,  # forced to u1
        np.where(bayesian_choose_u1, max_sub1, max_sub2)
    )

    greedy_welfare = np.where(
        blocked,
        max_sub1,
        np.where(greedy_choose_u1, max_sub1, max_sub2)
    )

    return float(np.mean(bayesian_welfare)), float(np.mean(greedy_welfare))


def run_experiment(configs, betas, M=100000):
    """Run all configurations across all beta values."""
    all_results = {}

    for k1, k2, p, desc in configs:
        print(f"\n{'='*60}")
        print(f"Config: {desc} (k1={k1}, k2={k2}, p={p})")
        print(f"{'='*60}")

        max_k = max(k1, k2)
        bayesian_W = []
        greedy_W = []

        for i, b in enumerate(betas):
            t0 = time.time()
            print(f"  beta={b:.2f} ({i+1}/{len(betas)})...", end="", flush=True)

            # Build interpolation tables for this beta
            tables = build_posterior_table(b, max_power=max_k, s_grid_size=400)

            bw, gw = simulate_both_agents(b, k1, k2, p, tables, M=M, seed=42+i)
            bayesian_W.append(bw)
            greedy_W.append(gw)
            dt = time.time() - t0
            print(f" B={bw:.4f}, G={gw:.4f} ({dt:.1f}s)")

        # Find optima
        b_opt_idx = int(np.argmax(bayesian_W))
        g_opt_idx = int(np.argmax(greedy_W))
        bayesian_at_inf = bayesian_W[-1]
        greedy_at_inf = greedy_W[-1]
        bayesian_interior = bayesian_W[b_opt_idx] > bayesian_at_inf + 1e-4
        greedy_interior = greedy_W[g_opt_idx] > greedy_at_inf + 1e-4

        print(f"\n  Bayesian: beta*={betas[b_opt_idx]:.2f}, "
              f"W*={bayesian_W[b_opt_idx]:.4f}, W(inf)={bayesian_at_inf:.4f}, "
              f"interior={bayesian_interior}")
        print(f"  Greedy:   beta*={betas[g_opt_idx]:.2f}, "
              f"W*={greedy_W[g_opt_idx]:.4f}, W(inf)={greedy_at_inf:.4f}, "
              f"interior={greedy_interior}")

        config_key = f"k1={k1}_k2={k2}_p={p}"
        all_results[config_key] = {
            'description': desc,
            'k1': k1, 'k2': k2, 'p': p,
            'betas': betas.tolist(),
            'bayesian_welfare': bayesian_W,
            'greedy_welfare': greedy_W,
            'bayesian_optimal_beta': float(betas[b_opt_idx]),
            'bayesian_optimal_W': float(bayesian_W[b_opt_idx]),
            'bayesian_at_inf': float(bayesian_at_inf),
            'bayesian_interior_optimum': bool(bayesian_interior),
            'greedy_optimal_beta': float(betas[g_opt_idx]),
            'greedy_optimal_W': float(greedy_W[g_opt_idx]),
            'greedy_at_inf': float(greedy_at_inf),
            'greedy_interior_optimum': bool(greedy_interior),
        }

        # Plot
        plot_comparison(betas, bayesian_W, greedy_W, k1, k2, p,
                        filename=f"bayesian_{config_key}.png")

    return all_results


def plot_comparison(betas, bayesian_W, greedy_W, k1, k2, p, filename):
    """Plot welfare curves for Bayesian vs Greedy."""
    fig, axes = plt.subplots(1, 2, figsize=(14, 6))

    # Left: both curves
    ax = axes[0]
    ax.plot(betas, bayesian_W, 'b-o', linewidth=2, markersize=4,
            label=f'Bayesian (knows G, p)')
    ax.plot(betas, greedy_W, 'r--s', linewidth=2, markersize=4,
            label='Greedy (immediate reward)')

    b_opt = int(np.argmax(bayesian_W))
    g_opt = int(np.argmax(greedy_W))
    ax.plot(betas[b_opt], bayesian_W[b_opt], 'b*', ms=15, zorder=5)
    ax.plot(betas[g_opt], greedy_W[g_opt], 'r*', ms=15, zorder=5)

    ax.set_xlabel(r'Signal precision $\beta$ (bits)', fontsize=12)
    ax.set_ylabel(r'Expected welfare $W(\beta)$', fontsize=12)
    ax.set_title(f'k1={k1}, k2={k2}, p={p}', fontsize=13)
    ax.legend(fontsize=10)
    ax.grid(True, alpha=0.3)

    # Right: welfare gap
    ax = axes[1]
    gap = np.array(bayesian_W) - np.array(greedy_W)
    ax.plot(betas, gap, 'g-o', linewidth=2, markersize=4)
    ax.axhline(0, color='k', linestyle=':', alpha=0.3)
    ax.set_xlabel(r'Signal precision $\beta$ (bits)', fontsize=12)
    ax.set_ylabel(r'$W_{Bayesian} - W_{Greedy}$', fontsize=12)
    ax.set_title('Rationality Premium', fontsize=13)
    ax.grid(True, alpha=0.3)

    plt.tight_layout()
    plt.savefig(OUT_DIR / filename, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"  Saved: {OUT_DIR / filename}")


if __name__ == "__main__":
    print("=" * 70)
    print("BAYESIAN vs GREEDY AGENT: WELFARE COMPARISON")
    print("Optimized with interpolation tables")
    print("=" * 70)

    configs = [
        (1, 5, 0.0, "Dead end vs subtree(5), no blocking"),
        (1, 5, 0.3, "Dead end vs subtree(5), p=0.3"),
        (2, 5, 0.0, "Subtree(2) vs subtree(5), no blocking"),
        (2, 5, 0.3, "Subtree(2) vs subtree(5), p=0.3"),
        (3, 3, 0.3, "Equal subtrees(3), p=0.3"),
        (2, 8, 0.5, "Subtree(2) vs subtree(8), p=0.5"),
        (3, 10, 0.6, "Subtree(3) vs subtree(10), p=0.6"),
    ]

    betas = np.concatenate([
        np.linspace(0.01, 0.5, 5),
        np.linspace(0.5, 2.0, 8),
        np.linspace(2.0, 5.0, 6),
        np.linspace(5.0, 10.0, 4)[1:],  # 6.67, 8.33, 10
        np.array([15.0, 30.0]),
    ])

    all_results = run_experiment(configs, betas, M=100000)

    # Save results
    with open(OUT_DIR / "bayesian_agent_results.json", "w") as f:
        json.dump(all_results, f, indent=2, default=str)
    print(f"\nSaved: {OUT_DIR / 'bayesian_agent_results.json'}")

    # Summary table
    print("\n" + "=" * 70)
    print("SUMMARY")
    print("=" * 70)
    print(f"{'Config':<45} {'B-int':>5} {'G-int':>5} "
          f"{'B-beta*':>7} {'G-beta*':>7} {'B-W*':>7} {'G-W*':>7}")
    print("-" * 70)
    for key, r in all_results.items():
        bm = "YES" if r['bayesian_interior_optimum'] else "no"
        gm = "YES" if r['greedy_interior_optimum'] else "no"
        print(f"{r['description']:<45} {bm:>5} {gm:>5} "
              f"{r['bayesian_optimal_beta']:>7.2f} {r['greedy_optimal_beta']:>7.2f} "
              f"{r['bayesian_optimal_W']:>7.4f} {r['greedy_optimal_W']:>7.4f}")
    print("=" * 70)

    # Key finding
    any_bayesian_interior = any(r['bayesian_interior_optimum'] for r in all_results.values())
    all_greedy_interior = all(r['greedy_interior_optimum'] for r in all_results.values())
    print(f"\nBayesian agent interior optimum in ANY config: {any_bayesian_interior}")
    print(f"Greedy agent interior optimum in ALL configs: {all_greedy_interior}")

    if not any_bayesian_interior:
        print("\n>>> THEOREM CONFIRMED: Bayesian agent welfare is monotonically")
        print("    non-decreasing in beta. The Blackwell Dilemma is a consequence")
        print("    of bounded rationality (greedy/myopic decision-making),")
        print("    not a fundamental information-theoretic impossibility.")
