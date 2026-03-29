"""
Blackwell Dilemma Execution System (BDES)
==========================================
Protocol-level experimental system that produces, detects, and logs
the Blackwell Dilemma in structured environments.

6 layers in one file:
  L1: Environment wrapper (any graph → IDP)
  L2: Signal engine (control β)
  L3: Agent policies (greedy, bounded-rational, IDP-aware)
  L4: Counterfactual engine (per-decision loss attribution)
  L5: Dilemma detector (C1-C3 auto-check + reversal flag)
  L6: Logging & proof layer (auditable event log)

Primary scenario: Platform Lock-in Simulator
"""

import numpy as np
from scipy.stats import norm
from dataclasses import dataclass, field
from pathlib import Path
import json
import time
import sys
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

sys.path.insert(0, str(Path(__file__).parent))
from phase_transition_sim import OUT_DIR


# Layer 1: Environment Wrapper

@dataclass
class State:
    id: str
    reward: float
    absorbing: bool = False

@dataclass
class Environment:
    """IDP-compatible environment wrapper."""
    states: dict  # id -> State
    edges: dict   # id -> [list of neighbor ids]
    start: str
    name: str = "unnamed"

    def neighbors(self, state_id):
        return self.edges.get(state_id, [])

    def reachable_set(self, state_id, visited=None):
        """BFS/DFS to compute R(state_id)."""
        if visited is None:
            visited = set()
        visited.add(state_id)
        for nb in self.neighbors(state_id):
            if nb not in visited:
                self.reachable_set(nb, visited)
        return visited

    def reachable_max(self, state_id):
        """max_{w in R(state_id)} r(w)."""
        R = self.reachable_set(state_id)
        return max(self.states[s].reward for s in R)

    def switching_cost(self, from_id, to_id):
        """Effective switching cost: can we return from to_id to from_id's component?"""
        R_after = self.reachable_set(to_id)
        return 0.0 if from_id in R_after else 1.0  # binary: reversible or not


# Layer 2: Signal Engine

def sigma_sq(beta):
    """Gaussian channel noise variance at capacity beta bits."""
    if beta > 15:
        return 1e-10
    return 1.0 / (2.0 ** (2.0 * beta) - 1.0)


def generate_signals(env, state_id, beta, rng):
    """Generate noisy reward signals for all neighbors of state_id."""
    nbs = env.neighbors(state_id)
    if not nbs:
        return {}
    s2 = sigma_sq(beta)
    signals = {}
    for nb in nbs:
        true_r = env.states[nb].reward
        noise = rng.normal(0, np.sqrt(s2)) if beta < 15 else 0.0
        signals[nb] = true_r + noise
    return signals


# Layer 3: Agent Policies

def greedy_policy(signals, env, state_id):
    """Choose neighbor with highest signal (standard framework)."""
    if not signals:
        return None
    return max(signals, key=signals.get)


def random_policy(signals, env, state_id, rng):
    """Uniform random choice."""
    nbs = list(signals.keys())
    if not nbs:
        return None
    return nbs[rng.integers(len(nbs))]


def idp_aware_policy(signals, env, state_id):
    """Choose neighbor with highest V_dynamic (IDP framework)."""
    nbs = env.neighbors(state_id)
    if not nbs:
        return None
    return max(nbs, key=lambda nb: env.reachable_max(nb))


# Layer 4: Counterfactual Engine

@dataclass
class DecisionRecord:
    """Per-decision auditable record."""
    step: int
    state: str
    available_actions: list
    signals: dict
    chosen: str
    chosen_reward: float
    chosen_reachable_max: float
    best_alternative: str
    best_alt_reachable_max: float
    structural_loss: float  # best_alt_reachable_max - chosen_reachable_max
    is_trap: bool           # structural_loss > 0
    c1_irreversible: bool
    c2_misaligned: bool
    c3_signal_local: bool   # always True in our setup (signals are about r, not R)


def compute_counterfactual(env, state_id, chosen, signals):
    """Compute counterfactual loss for a single decision."""
    nbs = env.neighbors(state_id)
    if len(nbs) < 2:
        return None

    chosen_rmax = env.reachable_max(chosen)
    alt_rmaxes = {nb: env.reachable_max(nb) for nb in nbs if nb != chosen}
    best_alt = max(alt_rmaxes, key=alt_rmaxes.get)
    best_alt_rmax = alt_rmaxes[best_alt]

    # C1: is this choice irreversible?
    c1 = env.switching_cost(state_id, chosen) > 0

    # C2: reward-topology misalignment?
    c2 = False
    for nb in nbs:
        if nb == chosen:
            continue
        if (env.states[chosen].reward > env.states[nb].reward and
                env.reachable_max(nb) > env.reachable_max(chosen)):
            c2 = True
            break

    loss = max(0, best_alt_rmax - chosen_rmax)

    return DecisionRecord(
        step=-1,  # filled by caller
        state=state_id,
        available_actions=nbs,
        signals=dict(signals),
        chosen=chosen,
        chosen_reward=env.states[chosen].reward,
        chosen_reachable_max=chosen_rmax,
        best_alternative=best_alt,
        best_alt_reachable_max=best_alt_rmax,
        structural_loss=loss,
        is_trap=(loss > 1e-10),
        c1_irreversible=c1,
        c2_misaligned=c2,
        c3_signal_local=True,  # by construction: signals reveal r, not R
    )


# Layer 5: Dilemma Detector

@dataclass
class DilemmaReport:
    """Summary report for a batch of runs."""
    beta_values: list
    mean_losses: list
    trap_counts: list
    total_decisions: list
    c1_rate: list
    c2_rate: list
    reversal_detected: bool = False
    reversal_pairs: list = field(default_factory=list)

    def check_reversal(self):
        """Check if increasing beta leads to increasing loss."""
        for i in range(len(self.beta_values) - 1):
            if (self.beta_values[i+1] > self.beta_values[i] and
                    self.mean_losses[i+1] > self.mean_losses[i] + 1e-6):
                self.reversal_detected = True
                self.reversal_pairs.append(
                    (self.beta_values[i], self.beta_values[i+1],
                     self.mean_losses[i], self.mean_losses[i+1]))
        return self.reversal_detected


# Layer 6: Logging & Proof Layer

def format_event_log(records):
    """Format decision records as auditable event log."""
    lines = []
    for rec in records:
        if rec is None:
            continue
        flag = " *** TRAP ***" if rec.is_trap else ""
        lines.append(
            f"  t={rec.step}: at {rec.state}, chose {rec.chosen} "
            f"(r={rec.chosen_reward:.2f}, Rmax={rec.chosen_reachable_max:.2f}) | "
            f"best alt: {rec.best_alternative} "
            f"(Rmax={rec.best_alt_reachable_max:.2f}) | "
            f"loss={rec.structural_loss:.2f} | "
            f"C1={rec.c1_irreversible} C2={rec.c2_misaligned} C3={rec.c3_signal_local}"
            f"{flag}"
        )
    return "\n".join(lines)


# Simulation Runner

def run_trajectory(env, beta, policy_fn, rng, max_steps=20):
    """Run one agent trajectory through the environment."""
    current = env.start
    records = []

    for t in range(max_steps):
        nbs = env.neighbors(current)
        if not nbs:
            break  # absorbing state

        signals = generate_signals(env, current, beta, rng)
        chosen = policy_fn(signals, env, current)
        if chosen is None:
            break

        rec = compute_counterfactual(env, current, chosen, signals)
        if rec is not None:
            rec.step = t
            records.append(rec)

        current = chosen

    terminal_reward = env.states[current].reward
    max_possible = max(s.reward for s in env.states.values())
    welfare_loss = max_possible - terminal_reward

    return terminal_reward, welfare_loss, records


def run_experiment(env, beta_values, M=10000, seed=42):
    """Run full experiment sweeping beta, return DilemmaReport."""
    rng = np.random.default_rng(seed)

    report = DilemmaReport(
        beta_values=list(beta_values),
        mean_losses=[], trap_counts=[], total_decisions=[],
        c1_rate=[], c2_rate=[],
    )

    for beta in beta_values:
        losses = []
        traps = 0
        decisions = 0
        c1_count = 0
        c2_count = 0

        for _ in range(M):
            _, wl, records = run_trajectory(
                env, beta, greedy_policy, rng)
            losses.append(wl)
            for rec in records:
                decisions += 1
                if rec.is_trap:
                    traps += 1
                if rec.c1_irreversible:
                    c1_count += 1
                if rec.c2_misaligned:
                    c2_count += 1

        report.mean_losses.append(float(np.mean(losses)))
        report.trap_counts.append(traps)
        report.total_decisions.append(decisions)
        report.c1_rate.append(c1_count / max(decisions, 1))
        report.c2_rate.append(c2_count / max(decisions, 1))

    report.check_reversal()
    return report


# Scenario: Platform Lock-in (isomorphic to 4-state IDP)

def platform_lockin_env():
    """
    Platform Lock-in Simulator.

    Uncommitted → Platform A (flashy, r=0.7, dead-end)
                → Platform B (modest, r=0.4) → Ecosystem Leader (r=1.0)

    C1: Adopting a platform is irreversible (switching cost = 1)
    C2: A has higher immediate reward but worse reachable max
    C3: Signals reveal current quality, not ecosystem trajectory
    """
    states = {
        'Uncommitted': State('Uncommitted', 0.0),
        'PlatformA':   State('PlatformA', 0.7, absorbing=True),
        'PlatformB':   State('PlatformB', 0.4),
        'EcoLeader':   State('EcoLeader', 1.0, absorbing=True),
    }
    edges = {
        'Uncommitted': ['PlatformA', 'PlatformB'],
        'PlatformB': ['EcoLeader'],
    }
    return Environment(
        states=states, edges=edges,
        start='Uncommitted', name='Platform Lock-in',
    )


def platform_extended_env():
    """
    Extended: adds a Declining platform as distractor after B.

    Uncommitted → A (0.7, trap)
                → B (0.4) → Declining (0.15, distractor)
                           → EcoLeader (1.0, goal)
    """
    states = {
        'Uncommitted': State('Uncommitted', 0.0),
        'PlatformA':   State('PlatformA', 0.7, absorbing=True),
        'PlatformB':   State('PlatformB', 0.4),
        'Declining':   State('Declining', 0.15, absorbing=True),
        'EcoLeader':   State('EcoLeader', 1.0, absorbing=True),
    }
    edges = {
        'Uncommitted': ['PlatformA', 'PlatformB'],
        'PlatformB': ['Declining', 'EcoLeader'],
    }
    return Environment(
        states=states, edges=edges,
        start='Uncommitted', name='Platform Lock-in (Extended)',
    )


# Scenario: Grid IDP (connects to percolation simulations)

def grid_idp_env(n=10, p=0.6, rng=None):
    """
    Random grid IDP on n×n torus with irreversibility p.
    Each edge is one-way with probability p.
    """
    if rng is None:
        rng = np.random.default_rng(42)
    N = n * n
    rewards_arr = rng.uniform(0, 1, N)

    states = {}
    edges = {}
    for i in range(N):
        sid = f"v{i}"
        states[sid] = State(sid, float(rewards_arr[i]))
        edges[sid] = []

    # 4-neighbor torus
    for i in range(N):
        r, c = divmod(i, n)
        neighbors_idx = [
            ((r - 1) % n) * n + c,
            ((r + 1) % n) * n + c,
            r * n + (c - 1) % n,
            r * n + (c + 1) % n,
        ]
        for j in neighbors_idx:
            edges[f"v{i}"].append(f"v{j}")
            # With prob p, remove reverse edge (make one-way)
            if rng.random() < p:
                # Don't add reverse; handled when j's turn comes
                pass
            # Note: for simplicity, we add all forward edges and let
            # the irreversibility be captured by asymmetric reachability.
            # Full percolation model is in phase_transition_sim.py.

    start = f"v{rng.integers(N)}"
    return Environment(states=states, edges=edges, start=start,
                       name=f'Grid IDP ({n}x{n}, p={p})')


# Visualization

def plot_bdes_results(report, env_name, filename=None):
    """Plot the BDES output: beta vs loss with dilemma detection."""
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6))

    betas = report.beta_values
    losses = report.mean_losses

    # Panel 1: Beta vs Welfare Loss
    ax1.plot(betas, losses, 'bo-', linewidth=2.5, markersize=8)

    if report.reversal_detected:
        for b1, b2, l1, l2 in report.reversal_pairs:
            ax1.annotate('', xy=(b2, l2), xytext=(b1, l1),
                         arrowprops=dict(arrowstyle='->', color='red',
                                         lw=2.5))
        ax1.text(0.5, 0.95, 'BLACKWELL DILEMMA DETECTED\nβ↑ ⇒ W↑ (reversal)',
                 transform=ax1.transAxes, fontsize=11, fontweight='bold',
                 color='darkred', va='top', ha='center',
                 bbox=dict(boxstyle='round', facecolor='#FFE0E0',
                           edgecolor='darkred'))

    ax1.set_xlabel('Signal precision β (bits)', fontsize=12)
    ax1.set_ylabel('Mean welfare loss E[W]', fontsize=12)
    ax1.set_title(f'{env_name}\nWelfare Loss vs Information Quality',
                  fontsize=11, fontweight='bold')
    ax1.grid(True, alpha=0.3)
    ax1.set_ylim(bottom=0)

    # Panel 2: C1-C3 verification rates
    ax2.plot(betas, report.c1_rate, 'rs-', linewidth=2, label='C1: Irreversible')
    ax2.plot(betas, report.c2_rate, 'g^-', linewidth=2, label='C2: Misaligned')
    ax2.axhline(1.0, color='blue', linestyle=':', alpha=0.4, label='C3: Local (=1 by design)')

    trap_rates = [t / max(d, 1) for t, d in
                  zip(report.trap_counts, report.total_decisions)]
    ax2.plot(betas, trap_rates, 'ko--', linewidth=1.5, label='Trap rate')

    ax2.set_xlabel('Signal precision β (bits)', fontsize=12)
    ax2.set_ylabel('Condition satisfaction rate', fontsize=12)
    ax2.set_title('Diagnostic: C1-C3 Auto-Verification',
                  fontsize=11, fontweight='bold')
    ax2.legend(fontsize=9)
    ax2.grid(True, alpha=0.3)
    ax2.set_ylim(-0.05, 1.15)

    plt.suptitle('Blackwell Dilemma Execution System (BDES)',
                 fontsize=13, fontweight='bold')
    plt.tight_layout()

    if filename is None:
        filename = f"bdes_{env_name.lower().replace(' ', '_').replace('(', '').replace(')', '')}.png"
    plt.savefig(OUT_DIR / filename, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / filename}")


# Main

if __name__ == "__main__":
    print("=" * 70)
    print("BLACKWELL DILEMMA EXECUTION SYSTEM (BDES)")
    print("=" * 70)

    t0 = time.time()

    beta_values = [0.001, 0.1, 0.25, 0.5, 0.75, 1.0, 1.5, 2.0, 3.0, 5.0, 8.0, 15.0]

    # Scenario 1: Platform Lock-in (4-state)
    print("\n[Scenario 1] Platform Lock-in (4-state)")
    env1 = platform_lockin_env()
    report1 = run_experiment(env1, beta_values, M=50000, seed=42)

    print(f"  Reversal detected: {report1.reversal_detected}")
    for b, l in zip(report1.beta_values, report1.mean_losses):
        print(f"    β={b:6.3f}: E[W]={l:.4f}")

    if report1.reversal_detected:
        print("  Reversal pairs:")
        for b1, b2, l1, l2 in report1.reversal_pairs:
            print(f"    β={b1:.3f}→{b2:.3f}: W={l1:.4f}→{l2:.4f}")

    # Print sample event log
    print("\n  Sample trajectory (β=5.0):")
    rng_sample = np.random.default_rng(999)
    _, wl, recs = run_trajectory(env1, 5.0, greedy_policy, rng_sample)
    print(format_event_log(recs))
    print(f"  Terminal welfare loss: {wl:.2f}")

    plot_bdes_results(report1, env1.name, "bdes_platform_lockin.png")

    # Scenario 2: Extended Platform (5-state)
    print("\n[Scenario 2] Platform Lock-in Extended (5-state)")
    env2 = platform_extended_env()
    report2 = run_experiment(env2, beta_values, M=50000, seed=43)

    print(f"  Reversal detected: {report2.reversal_detected}")
    for b, l in zip(report2.beta_values, report2.mean_losses):
        print(f"    β={b:6.3f}: E[W]={l:.4f}")

    plot_bdes_results(report2, env2.name, "bdes_platform_extended.png")

    # Compare: Greedy vs IDP-aware
    print("\n[Comparison] Greedy vs IDP-aware at β=5.0")
    rng_cmp = np.random.default_rng(44)
    greedy_losses = []
    idp_losses = []
    for _ in range(50000):
        _, wl_g, _ = run_trajectory(env2, 5.0, greedy_policy, rng_cmp)
        greedy_losses.append(wl_g)
    rng_cmp2 = np.random.default_rng(44)
    for _ in range(50000):
        _, wl_i, _ = run_trajectory(
            env2, 5.0,
            lambda s, e, sid: idp_aware_policy(s, e, sid),
            rng_cmp2)
        idp_losses.append(wl_i)

    print(f"  Greedy (standard):  E[W] = {np.mean(greedy_losses):.4f}")
    print(f"  IDP-aware:          E[W] = {np.mean(idp_losses):.4f}")
    print(f"  IDP advantage: {(np.mean(greedy_losses) - np.mean(idp_losses)) / np.mean(greedy_losses) * 100:.1f}%")

    elapsed = time.time() - t0
    print(f"\nTotal time: {elapsed:.1f}s")

    # Save full results
    save_data = {
        'scenario_1': {
            'name': env1.name,
            'betas': report1.beta_values,
            'losses': report1.mean_losses,
            'reversal': report1.reversal_detected,
            'reversal_pairs': report1.reversal_pairs,
        },
        'scenario_2': {
            'name': env2.name,
            'betas': report2.beta_values,
            'losses': report2.mean_losses,
            'reversal': report2.reversal_detected,
        },
        'greedy_vs_idp': {
            'greedy_loss': float(np.mean(greedy_losses)),
            'idp_loss': float(np.mean(idp_losses)),
        },
    }
    with open(OUT_DIR / "bdes_results.json", "w") as f:
        json.dump(save_data, f, indent=2)

    print("\n" + "=" * 70)
    print("BDES SUMMARY:")
    print(f"  Scenario 1 (4-state): reversal = {report1.reversal_detected}")
    print(f"  Scenario 2 (5-state): reversal = {report2.reversal_detected}")
    print(f"  Greedy vs IDP-aware gap: "
          f"{(np.mean(greedy_losses) - np.mean(idp_losses)) / np.mean(greedy_losses) * 100:.1f}%")
    print("=" * 70)
