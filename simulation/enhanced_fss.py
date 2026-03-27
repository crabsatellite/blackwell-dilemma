"""
Enhanced Finite-Size Scaling + Proposition 5 Verification
==========================================================
Two experiments that fill the remaining gaps in the computational appendix:

1. FSS with larger grids: n in {20, 40, 60, 80, 100}, M=800, 40 p-values
   Goal: proper critical exponent extraction (gamma/nu = 1.792)
   The existing n={15,25,40,60} M=300 was explicitly flagged as insufficient.

2. Proposition 5 verification: E[|W_topo| | |R|=k] = (n-k)/((n+1)(k+1))
   Compare analytic formula against Monte Carlo estimation.
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
from phase_transition_sim import setup_graph, compute_reachable_set, OUT_DIR

P_C = 0.5
NU = 4.0 / 3.0
BETA_PERC = 5.0 / 36.0
GAMMA = 43.0 / 18.0


def run_fss_enhanced(grid_sizes, p_values, M=800, seed=500):
    """Run enhanced FSS: for each (n, p), M trials measuring loss and reachable fraction."""
    all_results = {}

    for n in grid_sizes:
        rng = np.random.default_rng(seed)
        n_vertices = n * n
        results = {
            'n': n, 'M': M,
            'p_values': p_values.tolist(),
            'mean_loss': [], 'var_loss': [],
            'mean_reachable': [], 'var_reachable': [],
            'mean_oracle_loss': [],
        }

        t0 = time.time()
        print(f"\n  n={n} ({n_vertices} vertices), M={M}:")

        for ip, p in enumerate(p_values):
            oracle_losses = []
            reachable_sizes = []

            for trial in range(M):
                rewards, adj = setup_graph(n, p, rng)
                global_max = rewards.max()
                start = rng.integers(n_vertices)
                reachable = compute_reachable_set(adj, start)
                k = len(reachable)
                oracle_val = max(rewards[v] for v in reachable)
                oracle_losses.append(global_max - oracle_val)
                reachable_sizes.append(k / n_vertices)

            oracle_losses = np.array(oracle_losses)
            reachable_sizes = np.array(reachable_sizes)

            results['mean_loss'].append(float(oracle_losses.mean()))
            results['var_loss'].append(float(oracle_losses.var()))
            results['mean_reachable'].append(float(reachable_sizes.mean()))
            results['var_reachable'].append(float(reachable_sizes.var()))
            results['mean_oracle_loss'].append(float(oracle_losses.mean()))

            if (ip + 1) % 10 == 0:
                elapsed = time.time() - t0
                print(f"    {ip+1}/{len(p_values)} p-values done ({elapsed:.0f}s)")

        elapsed = time.time() - t0
        print(f"    n={n} complete in {elapsed:.0f}s")
        all_results[n] = results

    return all_results


def run_prop5_verification(n_values, p_values, M=2000, seed=600):
    """
    Verify Proposition 5: E[|W_topo| | |R|=k] = (n-k)/((n+1)(k+1))

    For each (n, p): run M trials, bin by |R|=k, compare empirical E[W_topo|k]
    against the analytic formula.
    """
    results = {}

    for n in n_values:
        n_vertices = n * n
        rng = np.random.default_rng(seed)
        results[n] = {}

        print(f"\n  Prop5 verification: n={n} ({n_vertices} vertices)")

        for p in p_values:
            k_to_losses = {}

            for trial in range(M):
                rewards, adj = setup_graph(n, p, rng)
                global_max = rewards.max()
                start = rng.integers(n_vertices)
                reachable = compute_reachable_set(adj, start)
                k = len(reachable)
                oracle_val = max(rewards[v] for v in reachable)
                loss = global_max - oracle_val

                if k not in k_to_losses:
                    k_to_losses[k] = []
                k_to_losses[k].append(loss)

            empirical = {}
            for k, losses in sorted(k_to_losses.items()):
                if len(losses) >= 5:
                    emp_mean = float(np.mean(losses))
                    analytic = (n_vertices - k) / ((n_vertices + 1) * (k + 1))
                    empirical[k] = {
                        'empirical_mean': emp_mean,
                        'analytic': analytic,
                        'count': len(losses),
                        'relative_error': abs(emp_mean - analytic) / max(analytic, 1e-10),
                    }

            results[n][str(p)] = empirical
            n_bins = len(empirical)
            if n_bins > 0:
                errors = [v['relative_error'] for v in empirical.values()]
                print(f"    p={p:.2f}: {n_bins} k-bins, median rel. error = {np.median(errors):.4f}")

    return results


def plot_fss_enhanced(all_results):
    """Generate enhanced FSS plots: raw curves + data collapse + exponent extraction."""
    fig, axes = plt.subplots(2, 2, figsize=(14, 12))
    colors = plt.cm.viridis(np.linspace(0.15, 0.9, len(all_results)))

    # Panel 1: Raw mean loss
    ax = axes[0, 0]
    for (n, res), c in zip(sorted(all_results.items()), colors):
        ax.plot(res['p_values'], res['mean_loss'], '-o', ms=2, lw=1.5, color=c, label=f'n={n}')
    ax.axvline(P_C, color='red', ls='--', alpha=0.5, label=f'$p_c$={P_C}')
    ax.set_xlabel('Irreversibility $p$')
    ax.set_ylabel('Mean Oracle Loss $|W_{\\mathrm{topo}}|$')
    ax.set_title('(a) Raw Loss Curves')
    ax.legend(fontsize=8)
    ax.grid(True, alpha=0.3)

    # Panel 2: Data collapse (loss)
    ax = axes[0, 1]
    for (n, res), c in zip(sorted(all_results.items()), colors):
        p_arr = np.array(res['p_values'])
        x = (p_arr - P_C) * n ** (1.0 / NU)
        ax.plot(x, res['mean_loss'], '-o', ms=2, lw=1.5, color=c, label=f'n={n}')
    ax.axvline(0, color='red', ls='--', alpha=0.3)
    ax.set_xlabel(r'$(p - p_c) \cdot n^{1/\nu}$')
    ax.set_ylabel('Mean Oracle Loss')
    ax.set_title(f'(b) Loss Collapse ($\\nu$ = {NU:.3f})')
    ax.legend(fontsize=8)
    ax.grid(True, alpha=0.3)

    # Panel 3: Reachable fraction collapse
    ax = axes[1, 0]
    for (n, res), c in zip(sorted(all_results.items()), colors):
        p_arr = np.array(res['p_values'])
        x = (p_arr - P_C) * n ** (1.0 / NU)
        y = np.array(res['mean_reachable']) * n ** (BETA_PERC / NU)
        ax.plot(x, y, '-o', ms=2, lw=1.5, color=c, label=f'n={n}')
    ax.axvline(0, color='red', ls='--', alpha=0.3)
    ax.set_xlabel(r'$(p - p_c) \cdot n^{1/\nu}$')
    ax.set_ylabel(r'$R \cdot n^{\beta_{\mathrm{perc}}/\nu}$')
    ax.set_title(f'(c) Reachable Fraction Collapse')
    ax.legend(fontsize=8)
    ax.grid(True, alpha=0.3)

    # Panel 4: Variance peak scaling → γ/ν extraction
    ax = axes[1, 1]
    grid_sizes_sorted = sorted(all_results.keys())
    peak_vars = []
    for n in grid_sizes_sorted:
        res = all_results[n]
        p_arr = np.array(res['p_values'])
        var_arr = np.array(res['var_loss'])
        mask = np.abs(p_arr - P_C) < 0.06
        if mask.any():
            peak_vars.append(var_arr[mask].max())
        else:
            peak_vars.append(var_arr.max())

    log_n = np.log(np.array(grid_sizes_sorted, dtype=float))
    log_var = np.log(np.array(peak_vars))
    ax.plot(log_n, log_var, 'ko-', ms=8, lw=2, zorder=5)

    if len(log_n) >= 3:
        slope, intercept = np.polyfit(log_n, log_var, 1)
        fit_x = np.linspace(log_n.min() - 0.1, log_n.max() + 0.1, 50)
        ax.plot(fit_x, slope * fit_x + intercept, 'r--', lw=1.5,
                label=f'Fit: slope = {slope:.3f}\nTheory $\\gamma/\\nu$ = {GAMMA/NU:.3f}')
    ax.set_xlabel('$\\ln(n)$')
    ax.set_ylabel('$\\ln(\\mathrm{Var\\ peak})$')
    ax.set_title('(d) Critical Exponent Extraction')
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)

    plt.suptitle('Enhanced Finite-Size Scaling (2D Bond Percolation Universality)',
                 fontsize=13, fontweight='bold')
    plt.tight_layout()
    plt.savefig(OUT_DIR / "fss_enhanced.png", dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / 'fss_enhanced.png'}")

    return slope if len(log_n) >= 3 else None


def plot_prop5(prop5_results):
    """Plot Proposition 5 verification: empirical vs analytic."""
    n_values = sorted(prop5_results.keys())
    fig, axes = plt.subplots(1, len(n_values), figsize=(6 * len(n_values), 5))
    if len(n_values) == 1:
        axes = [axes]

    for ax, n in zip(axes, n_values):
        n_vertices = n * n
        for p_str, data in sorted(prop5_results[n].items()):
            ks = sorted([int(k) for k in data.keys()])
            # Handle both int and str keys (direct dict vs JSON-loaded)
            def get(k):
                return data.get(k, data.get(str(k)))
            emp = [get(k)['empirical_mean'] for k in ks]
            ana = [get(k)['analytic'] for k in ks]
            ax.scatter(ana, emp, s=15, alpha=0.6, label=f'p={p_str}')

        lims = ax.get_xlim()
        ax.plot([0, max(lims[1], 0.5)], [0, max(lims[1], 0.5)], 'k--', lw=1, alpha=0.5, label='y=x')
        ax.set_xlabel('Analytic: $(n-k)/((n+1)(k+1))$')
        ax.set_ylabel('Empirical $\\mathbb{E}[|W_{\\mathrm{topo}}| \\mid |R|=k]$')
        ax.set_title(f'n={n} ({n_vertices} vertices)')
        ax.legend(fontsize=7, loc='upper left')
        ax.grid(True, alpha=0.3)

    plt.suptitle('Proposition 5 Verification: Analytic vs Monte Carlo',
                 fontsize=13, fontweight='bold')
    plt.tight_layout()
    plt.savefig(OUT_DIR / "prop5_verification.png", dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / 'prop5_verification.png'}")


if __name__ == "__main__":
    t_start = time.time()

    # ================================================================
    # PART 1: Enhanced Finite-Size Scaling
    # ================================================================
    print("=" * 70)
    print("PART 1: Enhanced Finite-Size Scaling")
    print("  Grid sizes: n in {20, 40, 60, 80, 100}")
    print("  M=800 trials per (n, p) pair, 40 p-values")
    print("=" * 70)

    grid_sizes = [20, 40, 60, 80, 100]
    p_values = np.linspace(0.25, 0.75, 40)

    fss_results = run_fss_enhanced(grid_sizes, p_values, M=800, seed=500)
    exponent = plot_fss_enhanced(fss_results)

    # Save FSS results
    fss_save = {}
    for n, res in fss_results.items():
        fss_save[str(n)] = res
    with open(OUT_DIR / "fss_enhanced_results.json", "w") as f:
        json.dump(fss_save, f, indent=2)
    print(f"Saved: {OUT_DIR / 'fss_enhanced_results.json'}")

    # ================================================================
    # PART 2: Proposition 5 Verification
    # ================================================================
    print("\n" + "=" * 70)
    print("PART 2: Proposition 5 Verification")
    print("  E[|W_topo| | |R|=k] = (n-k)/((n+1)(k+1))")
    print("=" * 70)

    prop5_results = run_prop5_verification(
        n_values=[20, 40],
        p_values=[0.3, 0.5, 0.6, 0.7],
        M=2000,
        seed=600
    )
    plot_prop5(prop5_results)

    # Save Prop 5 results
    prop5_save = {}
    for n, pdata in prop5_results.items():
        prop5_save[str(n)] = pdata
    with open(OUT_DIR / "prop5_verification_results.json", "w") as f:
        json.dump(prop5_save, f, indent=2)
    print(f"Saved: {OUT_DIR / 'prop5_verification_results.json'}")

    # ================================================================
    # Summary
    # ================================================================
    total = time.time() - t_start
    print("\n" + "=" * 70)
    print(f"ALL EXPERIMENTS COMPLETE ({total:.0f}s = {total/60:.1f}min)")
    print("=" * 70)
    if exponent is not None:
        print(f"  Extracted gamma/nu = {exponent:.3f} (theory: {GAMMA/NU:.3f})")
    print(f"  FSS: {len(grid_sizes)} grid sizes x {len(p_values)} p-values x 800 trials")
    print(f"  Prop5: 2 grid sizes x 4 p-values x 2000 trials")
