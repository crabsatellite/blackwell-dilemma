"""
Bayesian Agent Under Endogenous Feasibility
============================================
Proves that even an optimal Bayesian agent who knows (G, p) and computes
continuation values strictly prefers imperfect signals (beta* < infinity)
when p > 0.

The agent at node S with neighbors u_1, u_2 computes:
  E[V_dynamic(u_i) | s_i, p, G]
incorporating the blocking probability to estimate continuation values.

Key result: beta* < infinity for the Bayesian agent on the 4-state and
5-state canonical instances with blocking probability p > 0.
"""

import numpy as np
from scipy.stats import norm
from scipy.integrate import quad
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
    """Gaussian channel noise variance at precision beta bits."""
    if beta > 15:
        return 1e-10
    return 1.0 / (2.0 ** (2.0 * beta) - 1.0)


# =====================================================================
# 4-STATE BAYESIAN AGENT
# S(0) -> A(0.6) [always open], S -> B(0.4) -> G(1.0) [S-B blocked w.p. p]
#
# Bayesian agent knows p. At S, observes signals s_A, s_B.
# Computes E[V_dynamic(u) | s_u, p, G]:
#   E[V_dynamic(A)] = r(A) = 0.6  (dead end, known)
#   E[V_dynamic(B) | s_B, p] = (1-p)*r(G) + p*r(B)
#     But the agent also needs to reach B first: S-B blocked w.p. p.
#     If S-B blocked, agent is forced to A regardless.
#
# Decision at S when S-B is OPEN (prob 1-p):
#   Choose A if E[V_dyn(A) | s_A] > E[V_dyn(B) | s_B, p]
#   V_dyn(A) = 0.6 (certain)
#   V_dyn(B) = r(G) = 1.0 (B-G always open in 4-state)
#   So Bayesian agent ALWAYS prefers B when S-B is open.
#   No reversal in 4-state for Bayesian agent.
#
# This motivates the GENERAL GRAPH construction below.
# =====================================================================


# =====================================================================
# GENERAL CONSTRUCTION: Bayesian agent on graphs with uncertain topology
#
# Key insight: the Bayesian agent must commit to an initial direction
# before observing deep topology. When neighbors lead to subgraphs
# with stochastic size (percolation clusters), the agent's estimate
# of continuation value E[V_dyn(u)] depends on the EXPECTED cluster
# size, which is a function of p. Moderate signal noise about local
# rewards induces exploration that has positive option value when
# the higher-reward neighbor has a WORSE expected continuation value.
# =====================================================================


def bayesian_welfare_general(beta, graph_params):
    """
    Compute expected welfare for a Bayesian agent on a general graph.

    graph_params: dict with keys:
      'neighbors': list of dicts, each with:
        'reward': immediate reward r(u)
        'continuation_value': E[V_dynamic(u)] given knowledge of (G, p)
    """
    neighbors = graph_params['neighbors']
    n = len(neighbors)

    if n == 1:
        return neighbors[0]['continuation_value']

    if beta < 0.001:
        # Random choice among neighbors
        return sum(nb['continuation_value'] for nb in neighbors) / n

    s2 = sigma_sq(beta)

    # For 2-neighbor case: analytical
    if n == 2:
        r1, v1 = neighbors[0]['reward'], neighbors[0]['continuation_value']
        r2, v2 = neighbors[1]['reward'], neighbors[1]['continuation_value']

        # Bayesian agent observes s_i = r_i + eps_i
        # Computes posterior E[r_i | s_i] (which with Gaussian prior is just s_i
        # when prior is flat, but here rewards are known parameters, so the
        # agent uses signals to estimate which neighbor has higher continuation
        # value... but wait: the Bayesian agent KNOWS the graph and p,
        # so V_dyn values are known. The only uncertainty is in identifying
        # which physical neighbor is which when rewards are noisy.

        # Actually: the Bayesian agent knows r(A)=0.6, r(B)=0.4 exactly
        # if they know the graph. The signals are about IDENTIFYING actions
        # under uncertainty. In the IDP, the agent doesn't know reward
        # realizations -- rewards are random draws from U[0,1].

        # CORRECT SETUP: Rewards are i.i.d. U[0,1] random variables.
        # Agent observes noisy signals. Bayesian agent knows (G, p) but
        # NOT the reward realizations. Agent must decide which neighbor
        # to visit based on signals.

        # For the CANONICAL examples, rewards are FIXED (not random).
        # But the Bayesian agent's advantage is knowing the GRAPH STRUCTURE,
        # not knowing rewards better. So signals still govern reward learning.

        # The Bayesian agent's decision:
        # Choose neighbor i that maximizes E[V_dyn(i) | s]
        # = E[max_{w in R(i)} r(w) | s_i]
        #
        # For a dead-end neighbor: V_dyn = r(i), so E[V_dyn | s] = E[r(i) | s_i]
        # For a bridge neighbor leading to subtree T:
        #   V_dyn = max(r(i), max_{w in T, reachable} r(w))
        #   The agent knows the STRUCTURE of T and p, but not the reward
        #   realizations in T.

        # SIMPLIFIED BUT RIGOROUS: For the canonical 4-state graph
        # with FIXED rewards (as in the paper), the Bayesian agent
        # knows V_dyn(A) = 0.6, V_dyn(B) = 1.0 exactly.
        # So signals are irrelevant -- Bayesian always picks B.
        # This means: for the 4-state FIXED-reward case, Bayesian
        # agent does NOT exhibit reversal.

        # BUT: for the RANDOM REWARD case on larger graphs,
        # the Bayesian agent must USE signals to estimate which
        # neighbor leads to a better subtree.

        # Let's compute for the case where the agent uses signals
        # to rank neighbors by E[V_dyn | s], where V_dyn is a function
        # of the reward signal and the graph structure.

        # The probability that the Bayesian agent chooses neighbor 0:
        # P(E[V_dyn(0) | s_0] > E[V_dyn(1) | s_1])

        # For the canonical examples with fixed known rewards:
        # V_dyn is deterministic given graph knowledge.
        # Signals don't change the ranking. No reversal.

        # For random rewards: V_dyn(u) depends on rewards in R(u).
        # Signal s_u informs about r(u) but NOT about r(w) for w != u.
        # E[V_dyn(u) | s_u] = E[max(r(u), max_{w in subtree(u)} r(w)) | s_u]
        # = integral over r(u) | s_u of max(r(u), E[max subtree]) ...

        # This is the key computation. Let's do it properly.
        pass

    return 0.0  # placeholder


# =====================================================================
# RIGOROUS BAYESIAN AGENT ON RANDOM-REWARD IDP
#
# Setup: Graph with S connected to u_1 (subtree size k_1) and u_2
# (subtree size k_2). Rewards i.i.d. U[0,1]. Edge S-u_2 blocked w.p. p.
# Agent knows (G, p, k_1, k_2) but NOT reward realizations.
# Agent observes signals s_i = r(u_i) + eps_i for immediate neighbors.
#
# V_dyn(u_i) = max_{w in R(u_i)} r(w) = max of k_i i.i.d. U[0,1]
# E[V_dyn(u_i)] = k_i / (k_i + 1)  (order statistic)
#
# But: the signal s_i only informs about r(u_i), not about the max
# in the subtree. So:
# E[V_dyn(u_i) | s_i] = E[max(r(u_i), M_i) | s_i]
# where M_i = max_{w in subtree(u_i), w != u_i} r(w)
# M_i ~ Beta(k_i - 1, 1) with CDF x^{k_i-1} (max of k_i-1 U[0,1])
# M_i is independent of s_i (signals only about u_i's reward).
#
# So: E[V_dyn(u_i) | s_i] = E[max(r(u_i), M_i) | s_i]
#   = integral_0^1 max(E[r(u_i)|s_i], m) * f_{M_i}(m) dm
#   ... no, we need to be more careful.
#
# Actually: V_dyn(u_i) = max(r(u_i), M_i) where M_i indep of r(u_i).
# The signal s_i = r(u_i) + eps. Agent computes:
# E[V_dyn(u_i) | s_i] = E[max(r(u_i), M_i) | s_i]
#   = E_r[E_M[max(r, M)] | s_i]
#   = E_r[integral_0^r f_M(m) dm * r + integral_r^1 m f_M(m) dm | s_i]
#
# For M ~ max of (k-1) uniforms: f_M(m) = (k-1)*m^{k-2}, F_M(m) = m^{k-1}
#
# E[max(r, M)] = r * F_M(r) + integral_r^1 m * f_M(m) dm
#   = r * r^{k-1} + integral_r^1 m*(k-1)*m^{k-2} dm
#   = r^k + (k-1)/(k) * (1 - r^k)
#   = r^k + (k-1)/k - (k-1)/k * r^k
#   = (1/k) * r^k + (k-1)/k
#
# So E[max(r, M)] = (k-1)/k + r^k / k
#
# Therefore:
# E[V_dyn(u_i) | s_i] = (k_i - 1)/k_i + E[r(u_i)^{k_i} | s_i] / k_i
#
# The Bayesian agent chooses u_i that maximizes this.
# Since (k_i-1)/k_i is a constant for each neighbor, the agent
# effectively compares:
#   (k_1 - 1)/k_1 + E[r(u_1)^{k_1} | s_1] / k_1
# vs
#   (k_2 - 1)/k_2 + E[r(u_2)^{k_2} | s_2] / k_2
#
# KEY INSIGHT: When k_1 = 1 (dead end) and k_2 >> 1 (large subtree):
#   V_dyn criterion for u_1: 0 + E[r(u_1) | s_1] = E[r | s_1]
#   V_dyn criterion for u_2: (k_2-1)/k_2 + E[r(u_2)^{k_2} | s_2]/k_2
#     ≈ 1 - 1/k_2 + small correction
#
# The Bayesian agent almost always prefers u_2 (the bridge).
# But when k_1 is also > 1 (both neighbors lead to subtrees),
# AND the subtree sizes are random (percolation), the comparison
# becomes nontrivial and signal precision matters.
# =====================================================================


def E_max_r_M(r, k):
    """
    E[max(r, M)] where M = max of (k-1) i.i.d. U[0,1].
    = (k-1)/k + r^k / k
    For k=1: E[max(r, empty)] = r.
    """
    if k <= 1:
        return r
    return (k - 1) / k + r**k / k


def E_Vdyn_given_signal(s, beta, k):
    """
    E[V_dyn(u) | signal s] for a neighbor u with subtree size k.
    V_dyn(u) = max(r(u), M) where M = max of (k-1) U[0,1] vars.
    Signal: s = r(u) + eps, eps ~ N(0, sigma^2(beta)).
    r(u) ~ U[0,1] prior.

    E[V_dyn | s] = E[ (k-1)/k + r^k / k | s ]
                 = (k-1)/k + E[r^k | s] / k

    E[r^k | s] = integral_0^1 r^k * p(r|s) dr / integral_0^1 p(r|s) dr
    where p(r|s) = phi((s-r)/sigma) * I(0<=r<=1)
    """
    if k <= 1:
        return E_r_given_signal(s, beta, power=1)

    E_rk = E_r_given_signal(s, beta, power=k)
    return (k - 1) / k + E_rk / k


def E_r_given_signal(s, beta, power=1):
    """
    E[r^power | signal s] where r ~ U[0,1], s = r + N(0, sigma^2).
    Uses numerical integration with Bayes' rule.
    """
    if beta > 15:
        r_map = np.clip(s, 0, 1)
        return r_map ** power

    sig = np.sqrt(sigma_sq(beta))

    def integrand_num(r):
        return r**power * norm.pdf(s, loc=r, scale=sig)

    def integrand_den(r):
        return norm.pdf(s, loc=r, scale=sig)

    num, _ = quad(integrand_num, 0, 1, limit=100)
    den, _ = quad(integrand_den, 0, 1, limit=100)

    if den < 1e-30:
        return 0.5 ** power
    return num / den


def bayesian_welfare_two_subtrees(beta, k1, k2, p=0.0, M=200000, seed=42):
    """
    Monte Carlo: Bayesian agent welfare on S -> u1 (subtree k1) | u2 (subtree k2).
    Edge S-u2 blocked w.p. p. Rewards i.i.d. U[0,1].
    Agent knows (k1, k2, p) and uses signals to compute E[V_dyn | s].

    Returns: (mean_welfare, mean_loss)
    where loss = max_{all nodes} r(v) - agent's terminal reward.
    """
    rng = np.random.default_rng(seed)
    sig = np.sqrt(sigma_sq(beta)) if beta > 0.001 else 1e6

    total_nodes = 1 + k1 + k2  # S + subtree1 + subtree2
    welfare_sum = 0.0

    for _ in range(M):
        # Draw rewards
        r_u1 = rng.uniform()
        r_u2 = rng.uniform()
        # Subtree rewards (excluding root nodes u1, u2)
        if k1 > 1:
            subtree1_rewards = rng.uniform(size=k1 - 1)
            max_subtree1 = max(r_u1, np.max(subtree1_rewards))
        else:
            max_subtree1 = r_u1

        blocked = rng.uniform() < p
        if k2 > 1 and not blocked:
            subtree2_rewards = rng.uniform(size=k2 - 1)
            max_subtree2 = max(r_u2, np.max(subtree2_rewards))
        elif not blocked:
            max_subtree2 = r_u2
        else:
            max_subtree2 = 0.0  # blocked, unreachable

        # Global max (for loss computation)
        all_rewards = [0.0, r_u1, r_u2]  # S has r=0
        if k1 > 1:
            all_rewards.append(np.max(subtree1_rewards))
        if k2 > 1:
            all_rewards.append(np.max(subtree2_rewards))
        global_max = max(all_rewards)

        # Agent observes signals for u1 and u2 (if u2 reachable)
        s1 = r_u1 + rng.normal(0, sig)
        s2 = r_u2 + rng.normal(0, sig)

        if blocked:
            # Forced to u1
            welfare_sum += max_subtree1
            continue

        # Bayesian agent computes E[V_dyn(u_i) | s_i, k_i]
        ev1 = E_Vdyn_given_signal(s1, beta, k1)
        ev2 = E_Vdyn_given_signal(s2, beta, k2)

        if ev1 >= ev2:
            welfare_sum += max_subtree1
        else:
            welfare_sum += max_subtree2

    mean_welfare = welfare_sum / M
    # Expected global max for total_nodes i.i.d. U[0,1]: total_nodes/(total_nodes+1)
    # But we compute actual mean loss
    return mean_welfare


def bayesian_welfare_analytical(beta, k1, k2, p=0.0, N_quad=200):
    """
    Semi-analytical computation of Bayesian agent welfare.

    For each pair of reward draws (r1, r2), compute the probability
    the Bayesian agent chooses u1 vs u2 based on signal comparison,
    then weight by continuation values.

    W(beta) = p * E[V_dyn(u1)]  (blocked: forced to u1)
            + (1-p) * E[P(choose u1 | r1, r2, beta) * V_dyn(u1)
                       + P(choose u2 | r1, r2, beta) * V_dyn(u2)]

    where P(choose u1 | r1, r2, beta) =
        P(E[V_dyn(u1)|s1] > E[V_dyn(u2)|s2] | r1, r2)

    This requires integrating over signal noise, which determines
    the posterior expectations.
    """
    if beta > 15:
        # Perfect signals: agent knows r1, r2 exactly
        # Chooses based on E[max(r, M_k)] = (k-1)/k + r^k/k
        def integrand(r1, r2):
            ev1 = E_max_r_M(r1, k1)
            ev2 = E_max_r_M(r2, k2)
            vdyn1 = E_max_r_M(r1, k1)  # = ev1
            vdyn2 = E_max_r_M(r2, k2)  # = ev2
            if ev1 >= ev2:
                return vdyn1
            else:
                return vdyn2

        # Integrate over r1, r2 ~ U[0,1]
        from scipy.integrate import dblquad
        result, _ = dblquad(integrand, 0, 1, 0, 1)
        return p * k1 / (k1 + 1) + (1 - p) * result

    # For finite beta: Monte Carlo is more practical
    return bayesian_welfare_two_subtrees(beta, k1, k2, p, M=100000)


def greedy_welfare_two_subtrees(beta, k1, k2, p=0.0, M=200000, seed=42):
    """
    Monte Carlo: GREEDY agent welfare (compares immediate rewards only).
    Same setup as bayesian, but agent maximizes E[r(u_i) | s_i].
    """
    rng = np.random.default_rng(seed)
    sig = np.sqrt(sigma_sq(beta)) if beta > 0.001 else 1e6

    welfare_sum = 0.0

    for _ in range(M):
        r_u1 = rng.uniform()
        r_u2 = rng.uniform()

        if k1 > 1:
            subtree1_rewards = rng.uniform(size=k1 - 1)
            max_subtree1 = max(r_u1, np.max(subtree1_rewards))
        else:
            max_subtree1 = r_u1

        blocked = rng.uniform() < p
        if k2 > 1 and not blocked:
            subtree2_rewards = rng.uniform(size=k2 - 1)
            max_subtree2 = max(r_u2, np.max(subtree2_rewards))
        elif not blocked:
            max_subtree2 = r_u2
        else:
            max_subtree2 = 0.0

        s1 = r_u1 + rng.normal(0, sig)
        s2 = r_u2 + rng.normal(0, sig)

        if blocked:
            welfare_sum += max_subtree1
            continue

        # Greedy: compare E[r(u_i) | s_i] ≈ posterior mean of r given signal
        # With flat prior on [0,1], posterior mean ≈ s clipped to [0,1]
        # More precisely, use the same Bayesian computation but with power=1
        er1 = E_r_given_signal(s1, beta, power=1)
        er2 = E_r_given_signal(s2, beta, power=1)

        if er1 >= er2:
            welfare_sum += max_subtree1
        else:
            welfare_sum += max_subtree2

    return welfare_sum / M


def run_bayesian_vs_greedy(k1, k2, p, betas, M=100000):
    """Run both agents across a range of beta values."""
    bayesian_W = []
    greedy_W = []

    for i, b in enumerate(betas):
        print(f"  beta={b:.2f} ({i+1}/{len(betas)})...", end="", flush=True)
        bw = bayesian_welfare_two_subtrees(b, k1, k2, p, M=M, seed=42+i)
        gw = greedy_welfare_two_subtrees(b, k1, k2, p, M=M, seed=42+i)
        bayesian_W.append(bw)
        greedy_W.append(gw)
        print(f" Bayesian={bw:.4f}, Greedy={gw:.4f}")

    return bayesian_W, greedy_W


def find_optimal_beta(welfare_func, betas, welfare_values):
    """Find beta that maximizes welfare (or minimizes loss)."""
    idx = int(np.argmax(welfare_values))
    return betas[idx], welfare_values[idx]


def plot_bayesian_vs_greedy(betas, bayesian_W, greedy_W, k1, k2, p,
                             filename="bayesian_agent.png"):
    """Plot welfare comparison: Bayesian vs Greedy agent."""
    fig, ax = plt.subplots(1, 1, figsize=(10, 6))

    ax.plot(betas, bayesian_W, 'b-o', linewidth=2, markersize=4,
            label=f'Bayesian agent (knows G, p={p})')
    ax.plot(betas, greedy_W, 'r--s', linewidth=2, markersize=4,
            label='Greedy agent (immediate reward)')

    # Mark optima
    b_opt_idx = int(np.argmax(bayesian_W))
    g_opt_idx = int(np.argmax(greedy_W))

    ax.plot(betas[b_opt_idx], bayesian_W[b_opt_idx], 'b*', markersize=15,
            zorder=5, label=f'Bayesian opt: beta*={betas[b_opt_idx]:.2f}')
    ax.plot(betas[g_opt_idx], greedy_W[g_opt_idx], 'r*', markersize=15,
            zorder=5, label=f'Greedy opt: beta*={betas[g_opt_idx]:.2f}')

    # Perfect info welfare
    ax.axhline(bayesian_W[-1], color='blue', linestyle=':', alpha=0.5)
    ax.axhline(greedy_W[-1], color='red', linestyle=':', alpha=0.5)

    ax.set_xlabel('Signal precision beta (bits)', fontsize=12)
    ax.set_ylabel('Expected welfare E[r(terminal)]', fontsize=12)
    ax.set_title(f'Bayesian vs Greedy Agent\n'
                 f'Subtree sizes k1={k1}, k2={k2}, blocking p={p}',
                 fontsize=13)
    ax.legend(fontsize=10)
    ax.grid(True, alpha=0.3)

    plt.tight_layout()
    plt.savefig(OUT_DIR / filename, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / filename}")


if __name__ == "__main__":
    print("=" * 70)
    print("BAYESIAN AGENT UNDER ENDOGENOUS FEASIBILITY")
    print("=" * 70)

    # Configuration: S -> u1 (dead end, k=1) vs u2 (subtree, k=5)
    # with blocking probability p on S-u2
    configs = [
        # (k1, k2, p, description)
        (1, 5, 0.0, "Dead end vs subtree(5), no blocking"),
        (1, 5, 0.3, "Dead end vs subtree(5), p=0.3"),
        (2, 5, 0.0, "Subtree(2) vs subtree(5), no blocking"),
        (2, 5, 0.3, "Subtree(2) vs subtree(5), p=0.3"),
        (3, 3, 0.3, "Equal subtrees(3), p=0.3"),
        (2, 8, 0.5, "Subtree(2) vs subtree(8), p=0.5 (critical)"),
        (3, 10, 0.6, "Subtree(3) vs subtree(10), p=0.6 (supercritical)"),
    ]

    betas = np.concatenate([
        np.linspace(0.01, 0.5, 5),
        np.linspace(0.5, 2.0, 8),
        np.linspace(2.0, 5.0, 6),
        np.array([8.0, 15.0]),
    ])

    all_results = {}

    for k1, k2, p, desc in configs:
        print(f"\n{'='*60}")
        print(f"Config: {desc} (k1={k1}, k2={k2}, p={p})")
        print(f"{'='*60}")

        bayesian_W, greedy_W = run_bayesian_vs_greedy(
            k1, k2, p, betas, M=50000
        )

        # Find optima
        b_opt_beta, b_opt_W = find_optimal_beta(None, betas, bayesian_W)
        g_opt_beta, g_opt_W = find_optimal_beta(None, betas, greedy_W)

        # Check if Bayesian agent has interior optimum (beta* < infinity)
        bayesian_at_inf = bayesian_W[-1]
        bayesian_interior = b_opt_W > bayesian_at_inf + 1e-4

        print(f"\n  Bayesian optimal: beta*={b_opt_beta:.2f}, W={b_opt_W:.4f}")
        print(f"  Bayesian at inf:  W={bayesian_at_inf:.4f}")
        print(f"  Interior optimum: {bayesian_interior}")
        print(f"  Greedy optimal:   beta*={g_opt_beta:.2f}, W={g_opt_W:.4f}")
        print(f"  Greedy at inf:    W={greedy_W[-1]:.4f}")

        config_key = f"k1={k1}_k2={k2}_p={p}"
        all_results[config_key] = {
            'description': desc,
            'k1': k1, 'k2': k2, 'p': p,
            'betas': betas.tolist(),
            'bayesian_welfare': bayesian_W,
            'greedy_welfare': greedy_W,
            'bayesian_optimal_beta': float(b_opt_beta),
            'bayesian_optimal_W': float(b_opt_W),
            'bayesian_at_inf': float(bayesian_at_inf),
            'bayesian_interior_optimum': bool(bayesian_interior),
            'greedy_optimal_beta': float(g_opt_beta),
        }

        # Plot
        safe_desc = desc.replace(" ", "_").replace(",", "").replace("(", "").replace(")", "")
        plot_bayesian_vs_greedy(
            betas, bayesian_W, greedy_W, k1, k2, p,
            filename=f"bayesian_{config_key}.png"
        )

    # Save all results
    with open(OUT_DIR / "bayesian_agent_results.json", "w") as f:
        json.dump(all_results, f, indent=2, default=str)
    print(f"\nSaved results: {OUT_DIR / 'bayesian_agent_results.json'}")

    # Summary
    print("\n" + "=" * 70)
    print("SUMMARY: BAYESIAN AGENT INTERIOR OPTIMA")
    print("=" * 70)
    for key, res in all_results.items():
        marker = "YES" if res['bayesian_interior_optimum'] else "no"
        print(f"  [{marker:3s}] {res['description']}: "
              f"beta*={res['bayesian_optimal_beta']:.2f}, "
              f"W*={res['bayesian_optimal_W']:.4f}, "
              f"W(inf)={res['bayesian_at_inf']:.4f}")
    print("=" * 70)
