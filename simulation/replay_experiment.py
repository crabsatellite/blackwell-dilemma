"""
Experiment B: Platform Lock-in Temporal Replay
================================================
Real-data-driven synthetic environment. Not a real market sim —
a structurally pure temporal IDP where platforms evolve over time.

Key dynamics:
  - Platforms have observable quality r(t) and hidden ecosystem value e(t)
  - Quality signals reveal r(t) with precision beta
  - Ecosystem is INVISIBLE to the agent (C3)
  - Switching costs create irreversibility (C1)
  - High-quality platforms can have declining ecosystems (C2)

Terminal value: V = w_r * r(T) + w_e * e(T)
Signals cover r but not e. Blackwell Dilemma manifests:
  high beta -> confidently locks into best-looking platform -> low ecosystem -> low V
  low beta  -> explores randomly -> sometimes finds growing platform -> higher V

Experiment C (Audit Protocol) integrated: generates forensic event logs
and structured markdown audit report.
"""

import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from dataclasses import dataclass, field
from pathlib import Path
import sys
import time
import json

sys.path.insert(0, str(Path(__file__).parent))
from phase_transition_sim import OUT_DIR


# Platform Dynamics

@dataclass
class Platform:
    name: str
    quality_0: float        # initial observable quality
    quality_drift: float    # per-period quality change
    ecosystem_0: float      # initial hidden ecosystem value
    ecosystem_drift: float  # per-period ecosystem change
    archetype: str          # for labeling

    def quality(self, t):
        return np.clip(self.quality_0 + self.quality_drift * t, 0, 1)

    def ecosystem(self, t):
        return np.clip(self.ecosystem_0 + self.ecosystem_drift * t, 0, 1)

    def terminal_value(self, T, w_e=0.5):
        """True terminal value (quality + ecosystem)."""
        return (1 - w_e) * self.quality(T) + w_e * self.ecosystem(T)


# Canonical platform profiles
# KEY DESIGN: FlashyTrap has PERSISTENTLY highest quality (observable)
# but lowest ecosystem (hidden). More information about quality
# makes greedy agent MORE confidently wrong — the Blackwell Dilemma.
PLATFORMS = [
    Platform("FlashyTrap",   0.85,  0.005, 0.15, -0.005, "quality-first incumbent"),
    Platform("SteadyGrower", 0.50,  0.005, 0.65,  0.015, "stable mid-tier"),
    Platform("RisingStar",   0.35,  0.01,  0.75,  0.01,  "ecosystem-first challenger"),
    Platform("HiddenGem",    0.30,  0.005, 0.80,  0.01,  "ecosystem-first"),
    Platform("NicheStable",  0.45,  0.0,   0.50,  0.0,   "niche player"),
]


# Signal Engine

def sigma_sq(beta):
    if beta > 15:
        return 1e-10
    return 1.0 / (2.0 ** (2.0 * beta) - 1.0)


def observe_platforms(platforms, t, beta, rng):
    """
    Agent observes noisy quality signals at time t.
    Ecosystem is NEVER observed (C3 enforced).
    """
    sigma = np.sqrt(sigma_sq(beta)) if beta < 15 else 0.0
    signals = {}
    for p in platforms:
        true_q = p.quality(t)
        noise = rng.normal(0, sigma) if sigma > 0 else 0.0
        signals[p.name] = true_q + noise
    return signals


# Agent Policies

def greedy_agent(signals, current, switching_cost):
    """Standard framework: pick highest signal, switch if worth it."""
    best = max(signals, key=signals.get)
    if current is None:
        return best  # initial choice
    if signals[best] > signals[current] + switching_cost:
        return best
    return current


def oracle_agent(platforms, t, T, w_e=0.5):
    """Knows ecosystem values. Picks best terminal value."""
    return max(platforms, key=lambda p: p.terminal_value(T, w_e)).name


def random_agent(platforms, current, rng):
    """Uniform random initial choice, never switches."""
    if current is None:
        return platforms[rng.integers(len(platforms))].name
    return current


# Temporal Replay Engine

@dataclass
class ReplayEvent:
    t: int
    current: str
    signals: dict
    chosen: str
    switched: bool
    quality_current: float
    quality_best: float
    ecosystem_current: float
    ecosystem_best_dynamic: float
    structural_regret: float   # terminal_value(oracle) - terminal_value(current)
    c1: bool
    c2: bool
    c3: bool


def run_replay(platforms, T, beta, switching_cost, policy_fn, rng,
               w_e=0.5, platform_map=None):
    """Run one temporal replay trajectory."""
    if platform_map is None:
        platform_map = {p.name: p for p in platforms}

    current = None
    events = []
    oracle_choice = oracle_agent(platforms, 0, T, w_e)

    for t in range(T):
        signals = observe_platforms(platforms, t, beta, rng)

        if policy_fn == 'greedy':
            chosen = greedy_agent(signals, current, switching_cost)
        elif policy_fn == 'random':
            chosen = random_agent(platforms, current, rng)
        elif policy_fn == 'oracle':
            chosen = oracle_choice
            if current is None:
                current = chosen
        else:
            chosen = policy_fn(signals, current, switching_cost)

        switched = (current is not None and chosen != current)
        if current is None:
            current = chosen

        p_cur = platform_map[current]
        p_oracle = platform_map[oracle_choice]

        # Check C2: does highest-quality platform have lower terminal value?
        best_signal_name = max(signals, key=signals.get)
        p_best_signal = platform_map[best_signal_name]

        c2 = (p_best_signal.terminal_value(T, w_e) <
               max(p.terminal_value(T, w_e) for p in platforms
                   if p.name != best_signal_name))

        event = ReplayEvent(
            t=t,
            current=current,
            signals={k: round(v, 4) for k, v in signals.items()},
            chosen=chosen,
            switched=switched,
            quality_current=round(p_cur.quality(t), 4),
            quality_best=round(max(p.quality(t) for p in platforms), 4),
            ecosystem_current=round(p_cur.ecosystem(t), 4),
            ecosystem_best_dynamic=round(max(p.ecosystem(t) for p in platforms), 4),
            structural_regret=round(p_oracle.terminal_value(T, w_e) -
                                    p_cur.terminal_value(T, w_e), 4),
            c1=(switching_cost > 0),
            c2=c2,
            c3=True,  # ecosystem never observed
        )
        events.append(event)

        if switched:
            current = chosen

    terminal_v = platform_map[current].terminal_value(T, w_e)
    oracle_v = platform_map[oracle_choice].terminal_value(T, w_e)

    return current, terminal_v, oracle_v, events


def sweep_beta(platforms, T, switching_cost, beta_values, M=10000,
               w_e=0.5, seed=42):
    """Sweep beta, compute mean terminal value and regret for greedy agent."""
    rng = np.random.default_rng(seed)
    pmap = {p.name: p for p in platforms}

    results = []
    for beta in beta_values:
        greedy_vals = []
        random_vals = []
        oracle_val = None
        trap_count = 0
        choice_counts = {p.name: 0 for p in platforms}

        for _ in range(M):
            # Greedy
            cur_g, tv_g, ov, events = run_replay(
                platforms, T, beta, switching_cost, 'greedy', rng,
                w_e=w_e, platform_map=pmap)
            greedy_vals.append(tv_g)
            choice_counts[cur_g] += 1
            if oracle_val is None:
                oracle_val = ov
            # Check if greedy landed on trap (highest initial quality, not oracle)
            if cur_g == platforms[0].name:  # FlashyTrap
                trap_count += 1

            # Random
            cur_r, tv_r, _, _ = run_replay(
                platforms, T, beta, switching_cost, 'random', rng,
                w_e=w_e, platform_map=pmap)
            random_vals.append(tv_r)

        greedy_mean = float(np.mean(greedy_vals))
        random_mean = float(np.mean(random_vals))
        greedy_regret = oracle_val - greedy_mean
        random_regret = oracle_val - random_mean

        results.append({
            'beta': float(beta),
            'greedy_value': greedy_mean,
            'random_value': random_mean,
            'oracle_value': float(oracle_val),
            'greedy_regret': greedy_regret,
            'random_regret': random_regret,
            'trap_rate': trap_count / M,
            'choice_distribution': {k: v/M for k, v in choice_counts.items()},
        })
        print(f"  beta={beta:6.3f}: greedy={greedy_mean:.4f}, "
              f"random={random_mean:.4f}, oracle={oracle_val:.4f}, "
              f"trap={trap_count/M:.1%}")

    return results


# Experiment C: Audit Protocol

def generate_audit_report(events, platforms, T, beta, switching_cost, w_e,
                          terminal_platform, terminal_value, oracle_value):
    """Generate structured audit report from replay events."""
    trap_events = [e for e in events if e.structural_regret > 0.01]
    switches = [e for e in events if e.switched]

    report = {
        'metadata': {
            'T': T,
            'beta': beta,
            'switching_cost': switching_cost,
            'w_ecosystem': w_e,
            'n_platforms': len(platforms),
            'platform_names': [p.name for p in platforms],
        },
        'summary': {
            'terminal_platform': terminal_platform,
            'terminal_value': terminal_value,
            'oracle_value': oracle_value,
            'total_regret': oracle_value - terminal_value,
            'n_switches': len(switches),
            'n_trap_events': len(trap_events),
            'mean_structural_regret': float(np.mean([e.structural_regret
                                                      for e in trap_events]))
                if trap_events else 0,
            'reversal_detected': terminal_value < oracle_value - 0.01,
        },
        'diagnostics': {
            'c1_all_periods': all(e.c1 for e in events),
            'c2_any_period': any(e.c2 for e in events),
            'c3_all_periods': all(e.c3 for e in events),
            'blackwell_dilemma': (all(e.c1 for e in events) and
                                  any(e.c2 for e in events) and
                                  all(e.c3 for e in events)),
        },
        'top_trap_events': [],
    }

    # Top 5 trap events by structural regret
    sorted_traps = sorted(trap_events, key=lambda e: -e.structural_regret)[:5]
    for e in sorted_traps:
        report['top_trap_events'].append({
            'event_id': f"t{e.t}_{e.current}",
            'period': e.t,
            'platform': e.current,
            'quality_signal': e.signals.get(e.current, 0),
            'ecosystem_hidden': e.ecosystem_current,
            'structural_regret': e.structural_regret,
            'c1': e.c1, 'c2': e.c2, 'c3': e.c3,
        })

    return report


def format_markdown_report(report):
    """Format audit report as markdown."""
    lines = []
    lines.append("# Blackwell Dilemma Audit Report")
    lines.append("")
    m = report['metadata']
    lines.append(f"**Environment**: {m['n_platforms']} platforms, "
                 f"T={m['T']}, beta={m['beta']}, "
                 f"switching_cost={m['switching_cost']}")
    lines.append("")

    s = report['summary']
    lines.append("## Summary")
    lines.append(f"- Terminal platform: **{s['terminal_platform']}**")
    lines.append(f"- Terminal value: {s['terminal_value']:.4f}")
    lines.append(f"- Oracle value: {s['oracle_value']:.4f}")
    lines.append(f"- **Total regret: {s['total_regret']:.4f}**")
    lines.append(f"- Switches: {s['n_switches']}")
    lines.append(f"- Trap events: {s['n_trap_events']}")
    lines.append("")

    d = report['diagnostics']
    lines.append("## Diagnostic (C1-C2-C3)")
    lines.append(f"- C1 (irreversibility): {'PASS' if d['c1_all_periods'] else 'FAIL'}")
    lines.append(f"- C2 (misalignment): {'PASS' if d['c2_any_period'] else 'FAIL'}")
    lines.append(f"- C3 (signal locality): {'PASS' if d['c3_all_periods'] else 'FAIL'}")
    lines.append(f"- **Blackwell Dilemma: {'DETECTED' if d['blackwell_dilemma'] else 'NOT DETECTED'}**")
    lines.append("")

    if report['top_trap_events']:
        lines.append("## Top Trap Events (by structural regret)")
        lines.append("| Period | Platform | Quality Signal | Ecosystem (hidden) | Regret |")
        lines.append("|--------|----------|----------------|-------------------|--------|")
        for e in report['top_trap_events']:
            lines.append(f"| t={e['period']} | {e['platform']} | "
                         f"{e['quality_signal']:.3f} | {e['ecosystem_hidden']:.3f} | "
                         f"**{e['structural_regret']:.4f}** |")

    return "\n".join(lines)


# Visualization

def plot_platform_evolution(platforms, T, filename="platform_evolution.png"):
    """Show quality and ecosystem trajectories."""
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5.5))
    ts = np.arange(T + 1)
    colors = ['#CC4444', '#44AA44', '#4488CC', '#DD8844', '#888888']

    for p, c in zip(platforms, colors):
        qs = [p.quality(t) for t in ts]
        es = [p.ecosystem(t) for t in ts]
        ax1.plot(ts, qs, color=c, linewidth=2, label=f'{p.name} ({p.archetype})')
        ax2.plot(ts, es, color=c, linewidth=2, label=f'{p.name}')

    ax1.set_xlabel('Time period', fontsize=11)
    ax1.set_ylabel('Quality r(t) [OBSERVABLE]', fontsize=11)
    ax1.set_title('Observable quality (signals reveal this)',
                  fontsize=10, fontweight='bold')
    ax1.legend(fontsize=7.5, loc='best')
    ax1.grid(True, alpha=0.3)
    ax1.set_ylim(0, 1.05)

    ax2.set_xlabel('Time period', fontsize=11)
    ax2.set_ylabel('Ecosystem e(t) [HIDDEN]', fontsize=11)
    ax2.set_title('Hidden ecosystem value (signals do NOT reveal this)',
                  fontsize=10, fontweight='bold')
    ax2.legend(fontsize=7.5, loc='best')
    ax2.grid(True, alpha=0.3)
    ax2.set_ylim(0, 1.05)

    plt.suptitle('Platform Lock-in Replay: Observable vs Hidden Dynamics',
                 fontsize=13, fontweight='bold')
    plt.tight_layout()
    plt.savefig(OUT_DIR / filename, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / filename}")


def plot_replay_results(results, filename="replay_results.png"):
    """Beta sweep results: greedy vs random vs oracle."""
    fig, (ax1, ax2, ax3) = plt.subplots(1, 3, figsize=(18, 5.5))

    betas = [r['beta'] for r in results]
    greedy_v = [r['greedy_value'] for r in results]
    random_v = [r['random_value'] for r in results]
    oracle_v = results[0]['oracle_value']

    # Panel 1: Terminal value
    ax1.plot(betas, greedy_v, 'ro-', linewidth=2, markersize=6, label='Greedy agent')
    ax1.plot(betas, random_v, 'bs-', linewidth=2, markersize=6, label='Random agent')
    ax1.axhline(oracle_v, color='green', linestyle='--', linewidth=2,
                label=f'Oracle = {oracle_v:.3f}')
    ax1.set_xlabel('Signal precision beta', fontsize=11)
    ax1.set_ylabel('Terminal value', fontsize=11)
    ax1.set_title('Terminal Value vs Information Quality',
                  fontsize=10, fontweight='bold')
    ax1.legend(fontsize=9)
    ax1.grid(True, alpha=0.3)

    # Panel 2: Regret
    greedy_reg = [r['greedy_regret'] for r in results]
    random_reg = [r['random_regret'] for r in results]
    ax2.plot(betas, greedy_reg, 'ro-', linewidth=2, markersize=6, label='Greedy regret')
    ax2.plot(betas, random_reg, 'bs-', linewidth=2, markersize=6, label='Random regret')
    ax2.set_xlabel('Signal precision beta', fontsize=11)
    ax2.set_ylabel('Regret (oracle - realized)', fontsize=11)
    ax2.set_title('Regret vs Information Quality',
                  fontsize=10, fontweight='bold')
    ax2.legend(fontsize=9)
    ax2.grid(True, alpha=0.3)
    ax2.set_ylim(bottom=0)

    # Panel 3: Trap rate (fraction choosing FlashyTrap)
    trap_rates = [r['trap_rate'] for r in results]
    ax3.plot(betas, [t * 100 for t in trap_rates], 'ko-', linewidth=2, markersize=6)
    ax3.set_xlabel('Signal precision beta', fontsize=11)
    ax3.set_ylabel('Trap rate (%)', fontsize=11)
    ax3.set_title('Trap Rate: Fraction Locked into FlashyTrap',
                  fontsize=10, fontweight='bold')
    ax3.grid(True, alpha=0.3)
    ax3.set_ylim(0, 105)

    # Annotate reversal
    if len(greedy_reg) >= 2 and greedy_reg[-1] > greedy_reg[0]:
        ax2.annotate('REVERSAL: more info\n= higher regret',
                     xy=(betas[-3], greedy_reg[-3]),
                     xytext=(betas[2], max(greedy_reg) * 0.6),
                     fontsize=10, fontweight='bold', color='darkred',
                     arrowprops=dict(arrowstyle='->', color='darkred'),
                     bbox=dict(boxstyle='round', facecolor='#FFE0E0'))

    plt.suptitle('Experiment B: Platform Lock-in Temporal Replay',
                 fontsize=13, fontweight='bold')
    plt.tight_layout()
    plt.savefig(OUT_DIR / filename, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Saved: {OUT_DIR / filename}")


# Main

if __name__ == "__main__":
    print("=" * 70)
    print("EXPERIMENT B: Platform Lock-in Temporal Replay")
    print("EXPERIMENT C: Audit Protocol")
    print("=" * 70)

    t0 = time.time()
    T = 20
    switching_cost = 0.30
    w_e = 0.5  # weight on ecosystem in terminal value

    # Platform evolution
    print("\n[1] Platform profiles:")
    for p in PLATFORMS:
        tv = p.terminal_value(T, w_e)
        print(f"  {p.name:15s}: q(0)={p.quality_0:.2f}, e(0)={p.ecosystem_0:.2f}, "
              f"q(T)={p.quality(T):.2f}, e(T)={p.ecosystem(T):.2f}, "
              f"V(T)={tv:.3f}  [{p.archetype}]")

    oracle = max(PLATFORMS, key=lambda p: p.terminal_value(T, w_e))
    print(f"\n  Oracle picks: {oracle.name} (V={oracle.terminal_value(T, w_e):.3f})")

    plot_platform_evolution(PLATFORMS, T)

    # Beta sweep
    print("\n[2] Beta sweep (M=10,000 per beta):")
    beta_values = [0.001, 0.1, 0.25, 0.5, 0.75, 1.0, 1.5, 2.0, 3.0, 5.0, 10.0]
    results = sweep_beta(PLATFORMS, T, switching_cost, beta_values,
                         M=10000, w_e=w_e, seed=42)

    plot_replay_results(results)

    # Audit report for single trajectory
    print("\n[3] Generating audit report (single trajectory, beta=5.0):")
    rng_audit = np.random.default_rng(999)
    pmap = {p.name: p for p in PLATFORMS}
    term_plat, term_val, oracle_val, events = run_replay(
        PLATFORMS, T, 5.0, switching_cost, 'greedy', rng_audit,
        w_e=w_e, platform_map=pmap)

    report = generate_audit_report(
        events, PLATFORMS, T, 5.0, switching_cost, w_e,
        term_plat, term_val, oracle_val)

    md_report = format_markdown_report(report)
    print(md_report)

    # Save audit report
    report_path = OUT_DIR / "audit_report.md"
    with open(report_path, "w", encoding="utf-8") as f:
        f.write(md_report)
    print(f"\nSaved: {report_path}")

    with open(OUT_DIR / "audit_report.json", "w") as f:
        json.dump(report, f, indent=2, default=str)

    # Save all results
    elapsed = time.time() - t0

    save_data = {
        'platforms': [
            {'name': p.name, 'archetype': p.archetype,
             'q0': p.quality_0, 'e0': p.ecosystem_0,
             'q_drift': p.quality_drift, 'e_drift': p.ecosystem_drift,
             'V_T': p.terminal_value(T, w_e)}
            for p in PLATFORMS
        ],
        'parameters': {'T': T, 'switching_cost': switching_cost, 'w_e': w_e},
        'beta_sweep': results,
    }
    with open(OUT_DIR / "replay_results.json", "w") as f:
        json.dump(save_data, f, indent=2)

    print(f"\nTotal time: {elapsed:.1f}s")

    # Summary
    print("\n" + "=" * 70)
    print("EXPERIMENT B+C RESULTS:")
    greedy_at_high = [r for r in results if r['beta'] >= 5.0][0]
    greedy_at_low = [r for r in results if r['beta'] <= 0.01][0]
    print(f"  Oracle value: {results[0]['oracle_value']:.4f}")
    print(f"  Greedy at beta=0:  V={greedy_at_low['greedy_value']:.4f}, "
          f"regret={greedy_at_low['greedy_regret']:.4f}")
    print(f"  Greedy at beta=5:  V={greedy_at_high['greedy_value']:.4f}, "
          f"regret={greedy_at_high['greedy_regret']:.4f}")
    print(f"  Random at beta=5:  V={greedy_at_high['random_value']:.4f}")
    print(f"  Trap rate at beta=5: {greedy_at_high['trap_rate']:.1%}")
    reversal = greedy_at_high['greedy_regret'] > greedy_at_low['greedy_regret']
    print(f"  Blackwell reversal: {'YES' if reversal else 'NO'}")
    print(f"\n  Audit report: {report_path}")
    print("=" * 70)
