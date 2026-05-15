#!/usr/bin/env python3
"""
Numerical verification of alpha* ≈ 0.41 on the 5-state instance (p=0, kappa=0).

Companion to: "Information Value Under Endogenous Feasibility" (Li, 2026),
Remark 6.5 (Sentimental Immunity on the 5-State Instance).

Model (paper, Section 6.2-6.3):
  Vertices: S (start), A (trap), B (bridge), D (distractor), G (goal)
  Rewards: r(S)=0, r(A)=0.6, r(B)=0.4, r(D)=0.1, r(G)=1.0
  All edges open (p=0)
  Signal model: s_v = r(v) + eps_v, eps_v ~ N(0, sigma^2(beta))
                sigma^2(beta) = 1/(2^{2*beta} - 1)
  Agent utility: U(v) = alpha * r(v) + (1-alpha) * xi(v)
  Intrinsic xi(v) ~ Uniform[0,1] iid, known to agent with certainty
  kappa = 0: greedy policy using alpha-weighted signal

Derivation of alpha*:
  Agent at S picks A iff alpha * s_A + (1-alpha) * xi_A > alpha * s_B + (1-alpha) * xi_B
  With flat prior E[r(v)|s_v] = s_v (improper prior; valid for misranking analysis).
  Equivalently: alpha * (s_A - s_B) > (1-alpha) * (xi_B - xi_A)

  Let X = alpha * (s_A - s_B),  X ~ N(0.2*alpha, 2*alpha^2*sigma^2)
  Let Y = (1-alpha) * (xi_A - xi_B),  Y ~ scaled Triangular(-1, 1) by (1-alpha)
  xi_A - xi_B has pdf f(z) = (1 - |z|) for z in [-1, 1]  (difference of iid Unif[0,1])

  P_A(beta, alpha) = P(X + Y > 0)
                   = int_{-(1-alpha)}^{(1-alpha)} pdf_{(1-alpha) Tri}(y) * Phi((0.2*alpha + y)/(alpha*sqrt(2*sigma^2))) dy

  Similarly at B: agent picks G iff alpha*(s_G-s_D) + (1-alpha)*(xi_G-xi_D) > 0
  Uses Delta_B = r(G) - r(D) = 0.9 instead of Delta_S = 0.2.

Loss function:
  L(beta, alpha) = P_A * 0.4 + (1-P_A) * (1-P_{G|B}) * 0.9

alpha* = inf { alpha : L(., alpha) monotonically non-increasing in beta }.

Expected result (reported in paper Remark 6.5): alpha* ≈ 0.41.
"""

import math


def norm_cdf(x):
    """Standard normal CDF via erf."""
    return 0.5 * (1.0 + math.erf(x / math.sqrt(2.0)))


def sigma2(beta):
    """Signal noise variance as function of precision beta."""
    if beta <= 0:
        return float('inf')
    if beta > 30:
        return 2.0 ** (-2 * beta)  # negligible, avoid overflow
    return 1.0 / (2.0 ** (2 * beta) - 1.0)


def tri_pdf(z):
    """pdf of xi_A - xi_B where xi_A, xi_B iid Uniform[0,1]."""
    if abs(z) >= 1.0:
        return 0.0
    return 1.0 - abs(z)


def p_choose_first(beta, alpha, delta_r, n_grid=2001):
    """
    Probability that agent picks the higher-reward option at a binary node
    with reward gap delta_r (>0), under alpha-weighted decision rule.

    P = P(alpha*(s_1 - s_2) + (1-alpha)*(xi_1 - xi_2) > 0)
    with mean of Gaussian component = alpha * delta_r, variance = 2*alpha^2*sigma^2.
    """
    if alpha <= 0.0:
        # Signal ignored; choose by xi alone.  P(xi_1 > xi_2) = 1/2 by symmetry.
        return 0.5
    if alpha >= 1.0:
        # xi ignored; pure Gaussian comparison.
        s2 = sigma2(beta)
        return norm_cdf(delta_r / math.sqrt(2.0 * s2))

    s2 = sigma2(beta)
    # Scale of Gaussian component: alpha * sqrt(2 * sigma2)
    scale = alpha * math.sqrt(2.0 * s2)
    mean = alpha * delta_r
    a = 1.0 - alpha  # support half-width for (1-alpha) * (xi_A - xi_B)

    # P = integral over y in [-a, a] of pdf_Y(y) * Phi((mean + y) / scale) dy
    # where Y = (1-alpha) * (xi_A - xi_B), so pdf_Y(y) = (1/a) * tri_pdf(y/a).
    # Simpson's rule on fine grid.
    if n_grid % 2 == 0:
        n_grid += 1
    ys = [-a + 2.0 * a * k / (n_grid - 1) for k in range(n_grid)]
    vals = []
    for y in ys:
        pdf_y = tri_pdf(y / a) / a if a > 0 else 0.0
        if scale > 0:
            cdf_arg = (mean + y) / scale
        else:
            cdf_arg = float('inf') if (mean + y) > 0 else (-float('inf') if (mean + y) < 0 else 0.0)
        vals.append(pdf_y * norm_cdf(cdf_arg))

    # Composite Simpson's rule
    h = 2.0 * a / (n_grid - 1)
    s = vals[0] + vals[-1]
    for i in range(1, n_grid - 1):
        s += (4.0 if i % 2 == 1 else 2.0) * vals[i]
    return s * h / 3.0


def loss(beta, alpha):
    """5-state greedy welfare loss at (beta, alpha) with p = kappa = 0."""
    p_trap = p_choose_first(beta, alpha, delta_r=0.2)       # P(A at S)
    p_goal = p_choose_first(beta, alpha, delta_r=0.9)       # P(G at B)
    return p_trap * 0.4 + (1.0 - p_trap) * (1.0 - p_goal) * 0.9


def is_monotone_non_increasing(alpha, betas):
    """
    Check whether L(., alpha) is monotonically non-increasing on the beta grid.
    Returns (is_mono, overshoot) where overshoot = L(inf) - min_beta L(beta, alpha).
    Overshoot > 0 ⇒ interior minimum exists (reversal active).
    """
    L_vals = [loss(b, alpha) for b in betas]
    L_inf = loss(50.0, alpha)   # beta = 50 is effectively infinity
    min_L = min(L_vals + [L_inf])
    overshoot = L_inf - min_L
    # Non-monotone iff overshoot strictly positive (min < L_inf) with a margin to
    # avoid numerical noise.  Use 1e-4 as threshold.
    is_mono = overshoot <= 1e-4
    return is_mono, overshoot


def find_alpha_star(betas=None, alpha_lo=0.0, alpha_hi=1.0, tol=1e-3):
    """
    Bisect on alpha to find alpha* = inf { alpha : L(., alpha) monotone non-increasing }.
    Below alpha*, interior min exists; above alpha*, monotone.
    """
    if betas is None:
        # Dense grid over beta from near-zero to beta ~ 10 (beyond which negligible change)
        betas = [0.01] + [0.1 * k for k in range(1, 61)] + [6.5 + 0.5 * k for k in range(1, 8)]

    # Bisection: at low alpha, L flat (non-mono? actually constant ⇒ mono).  Hmm.
    # Actually at alpha=0, L is constant in beta, so technically "monotone non-increasing"
    # (degenerate). As alpha increases from 0, interior min appears once overshoot > 0.
    # So we want largest alpha such that overshoot = 0 below it ... wait let me re-think.
    #
    # From paper Remark 6.5: alpha* = inf { alpha : dW/dbeta first changes sign }.
    # = inf { alpha : interior min exists }.
    # At alpha = 0: L constant in beta, no interior min (degenerate).
    # As alpha ↑, interior min emerges (some threshold alpha_c where overshoot becomes > 0).
    # alpha* is this emergence threshold.

    # Scan upward to find first alpha at which overshoot exceeds epsilon.
    alphas_scan = [0.01 * k for k in range(1, 101)]  # 0.01, 0.02, ..., 1.00
    overshoots = [is_monotone_non_increasing(a, betas)[1] for a in alphas_scan]
    return alphas_scan, overshoots


def main():
    print("5-state alpha* verification (p=0, kappa=0)")
    print("=" * 60)
    print()

    # Sanity check: alpha = 1 should recover the paper's L(beta) table at p=0.
    print("Sanity check at alpha = 1 (should match paper's 5-state table):")
    for beta in [0.01, 0.5, 1.0, 1.5, 2.0, 3.0, 20.0]:
        L = loss(beta, 1.0)
        p_trap = p_choose_first(beta, 1.0, 0.2)
        p_goal = p_choose_first(beta, 1.0, 0.9)
        print(f"  beta={beta:5.2f}  P(trap)={p_trap:.3f}  P(goal)={p_goal:.3f}  L={L:.4f}")
    print()

    # Boundary: alpha = 0 should give L constant at 0.425.
    print("Sanity check at alpha = 0 (L should be constant 0.425):")
    for beta in [0.01, 0.5, 1.0, 2.0, 10.0]:
        L = loss(beta, 0.0)
        print(f"  beta={beta:5.2f}  L={L:.4f}")
    print()

    # Scan alpha and report overshoot.
    print("Overshoot L(inf) - min_beta L(beta, alpha) as a function of alpha:")
    alphas, overshoots = find_alpha_star()
    for a, o in zip(alphas, overshoots):
        if 0.3 <= a <= 0.55:
            marker = "  <-- transition zone" if 0.38 <= a <= 0.45 else ""
            print(f"  alpha={a:.2f}  overshoot={o:+.6f}{marker}")
    print()

    # Find first alpha where overshoot > 1e-4 (operational threshold).
    alpha_star_operational = None
    for a, o in zip(alphas, overshoots):
        if o > 1e-4:
            alpha_star_operational = a
            break

    # Find first alpha where overshoot > 1e-3 (empirically detectable).
    alpha_star_detectable = None
    for a, o in zip(alphas, overshoots):
        if o > 1e-3:
            alpha_star_detectable = a
            break

    print(f"alpha* (strict, overshoot > 1e-4 threshold) ≈ {alpha_star_operational}")
    print(f"alpha* (empirically detectable, overshoot > 1e-3) ≈ {alpha_star_detectable}")
    print()
    print("Paper Remark 6.5 reports alpha* ~ 0.41; 'empirically detectable only for alpha >~ 0.45'")


if __name__ == "__main__":
    main()
